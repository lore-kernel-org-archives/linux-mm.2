Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49368CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1998E0012; Wed, 22 Oct 2025 10:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889298E0010; Wed, 22 Oct 2025 10:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79EB88E0012; Wed, 22 Oct 2025 10:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67A218E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:53:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F6911180B4
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:53:50 +0000 (UTC)
X-FDA: 84026044620.03.3046525
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3BC49140007
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:53:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c5y8hu9t;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761144828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1cfXdO6iFVoG7HfA3ugtXk5YCzyB+I2gK/iAlyV/U2k=;
	b=ViXGxBjw3IVXC7N2hOMrfwnmjkEVe4cRToUC7tmoXLes/JkhKFhVlOJMsOh57BKvbj+RXb
	6uEt146gUFxOHPRJ4F61UOaC5EoyUjYHs+L2E+YB7z+aqLveOolwBRSBShhrSD4+r2YAoU
	AJlDel7SmzbxgoLQ6i6b3RtLGvLLocQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761144828; a=rsa-sha256;
	cv=none;
	b=wB/Q3wrCuC77emEbb0ahWoi/FW/Va7S0Xw9jgUqMiw0GlHKlbUe/MWv/GI8+uE2SNugXY9
	Yj5z+RDTGeUZ6iZVnc1pXSsF9NJqhS0MZI8capuHCOfnWpNdiKtSmz1UfUp4BvhZ6pR/kE
	XCX3nHaW/h1lnCsA3JP3iZ8ENrV71TI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c5y8hu9t;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8915bd01244so1058460185a.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761144827; x=1761749627; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1cfXdO6iFVoG7HfA3ugtXk5YCzyB+I2gK/iAlyV/U2k=;
        b=c5y8hu9todkm+z1q8V07vd74YP2uGfrLrWU5XYNR47BW85Bvy9wQMogfqteobHnpdv
         4UwhbIevSBf2u8cAamRNW4iwQ6/4gBwAoKpwSSvrpODcVrnHNLzVlAoQMbMtPxL4p5ZK
         fBXfWKUT16XKaW16jX6JjriTRhQ3vEjGD0gyoZBf+SCdsODE8gGKEA4bQtfU8RjDtSLJ
         Mjn2mPhvd8vYsTvONN3fqq4A8Zq2c0nN5pkMB64UjPHz1ydmkxYEFVx2vGLIgjMkzQKo
         cW6sDJnSgegLaEjZuG4qYCPRMGHbthKzMHGputnLIjXK/t1KekcGMINjS9uu8ex8CGal
         HrtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761144827; x=1761749627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1cfXdO6iFVoG7HfA3ugtXk5YCzyB+I2gK/iAlyV/U2k=;
        b=Nd7dIvqBW3kPUTc9u9dsMFrBsjU56qjalhuu06ufGMrMMCGgjJmLFKz6j64rXLlDMe
         AZXP5CQymYTpdzQM7D1y0uoOXCu+ENXC1yT+DxkucFXXBAD/t67c0ql7r2t6ngesG/Rf
         5nOcB2pFnrnYFRJddcIfLcCJY20itiLab6VUDzrVEv7byzwOR/9pIuTIa7aC9QVzA4wa
         V72zpzBX5QOz20ZmUrCkHwaXjO74nQSilgFgzCXZl3nbhlrFwlTAJhM9EZDY0mdgjRph
         dvOz6kbbXuAXN2orrUHUQG1zeUzF1p32bDmXC1C5J4Yx+rtirpHwdzcCJ8O0SvYj6kQd
         EXNg==
X-Gm-Message-State: AOJu0Yz1udB5ZziW/pS0mjpnZ+9DUgAjNXosRkdwIEO6STq8qil1zsJE
	Tnte6TMpZyUcIv5od3LRWGcw+LISP7Bpe1bH4mvLh9MYdB9MdbGvFNlkmhNiV7ftU4Q=
X-Gm-Gg: ASbGncvkBpS66YEUmyFyFvvyKr2E2/02EV/+uPIjJm6cQaIkVwJVHUHaOs8ZQNn8w0G
	7fvllGHLIdReuQqr0taLgkNOz6WTd5qlfpdB4SUuMih9Wu44UHmcfiy+7/H2ktyMounm1mS5q5f
	Yc6iux5vmGnmAW9QuQpcm90gE0fPbFQqStV4nLPuniBMmRF5bk+N3NIxtJWmjl9jtk/+ot9mpA4
	/EkJrOGa2kxJFnlHqdR2staYPY07n/pzrBizw9FMJEaoaeS+fiRwiFzPs6VJt/JtyLalIv2AKTz
	1uIrtcWaDaIjbXgZ+y1KCHE8UwTKJSgbOjjYKR6BSsqCQ7H8Dfi9jtLFkQv4mbFbUFXg+nBrN13
	3YHngJoM4HELnkm0PVOxRiSCo25npwS06+G9xCXTrr0xDkIa2zDDiKyJeYKV0R+0GYwPxBApO+2
	XU9WhCHQzRC1vXESlMovrKb/M1pJfYisr1sd/h0lwLwDB8XiZjW6hqvHFhlB8=
X-Google-Smtp-Source: AGHT+IFHuMaMm9YG8UjNunKuIxLRJWBbIuuF0QSGwuVL9vRBN2OWA2gEWGQ8hVXwPZQWU1e1osSl+Q==
X-Received: by 2002:ad4:5d6f:0:b0:87c:2c0d:309e with SMTP id 6a1803df08f44-87c2c0d3796mr169678726d6.37.1761144827141;
        Wed, 22 Oct 2025 07:53:47 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87cf51ff3c9sm90532536d6.8.2025.10.22.07.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 07:53:46 -0700 (PDT)
Date: Wed, 22 Oct 2025 10:53:44 -0400
From: Gregory Price <gourry@gourry.net>
To: SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, David Hildenbrand <david@redhat.com>
Subject: Re: [RFC PATCH v2] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
Message-ID: <aPjv-Kd2ZihLUqMS@gourry-fedora-PF4VCD3F>
References: <20251020210816.1089910-1-gourry@gourry.net>
 <20251022014057.128900-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022014057.128900-1-sj@kernel.org>
X-Rspamd-Server: rspam05
X-Stat-Signature: obzs3jwbdkc1fspna7osga7no9r99amx
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BC49140007
X-HE-Tag: 1761144828-293457
X-HE-Meta: U2FsdGVkX181ceaNTle//OYJj3ckUcF7UQLSv669sCQy48lgOTx/vd5TDJHb6wpKcWtijfpbHgQvNW3Bdtwjfx2zx2XC4qKuOiBBRy63mYbUjMLmqFHWeYwHPv7sAB3agHRd3geeiqeK/fADyHzLaUzGybeIoeU6uauaCSuJtVMIlLImEY9L3igrYdPMz6h8NHMDW9arU4+amUwi6JQbhWHFXQYxaAlviIMgZvFKSZ9Ufk5xp2KIREuJukWtpI9wbMSwUKawkvQvpXxhQfCvTIAMsdQPc8HYpnjGhS5xrwNOZlQ2F35vq/DQFOIbEwaWReP88y76Yl91T+VaMm/XCX4cf2gSU9QwkmUI5HmyeBCmsa1dpYvBUu3J9NUmMGHNyGpz09/kHvN/ZQ9AyLljQP/LZtlo4IyR3uqnCnWXlVOYpkW2tmaMl+kq3Vg3hZ3mAX/w8I17cjTPSVyzwiSZ02BqGOk7I81i2f3h+ItVIA9BOm89Q/Gv2XDgeNY0AoX+jRtoSxpwqhruVJt0LE4Ev00HnlPvY0/qzHfWN91gUqM8Kk8s7RTq6DzGrDCxCegJzKCf3U+N8uTL7n9Jkp1CzHl7QfQHnrcFj3yEp4UlH0OtLf6PjrA2Z7xvcdyM2S/50yG2qyh0YwL/JVRWlcbdm1ZYRA07FBYlNSls4Fk6bLQa9PTMnZjF6kXcSFoohQkoPkS/3wuSTahWMhSMxlWkv2r+Y/9hWNuqIu6MY7CEIIrldznHFwNhhDT43bUJ/sMUUY5rkCSir2BpRWJebnzr5umDf31HldQkhh6Ec3aLa7IX/nM9hlalbWIy/b1gSBcH1uPtlLHl94Icnsu8Pf9xylYWuZPipriFvwXIvS6jDz5TQrvGz8HhJa6V0ZeF8fjaIsXHVfA7dyIaQQx+SOnVVCvxJzkBzTU3Rz8RIsJOfqLOblsc8laiXyLqO2Nlv5OV9FffqHbo6N6jMD25sA3
 GeuggyR8
 O8oIOboq0sY9AJUBin/QsUtSdVAIOWD2aZ1DJTNycYMUtlx64rOybu1jNBr9/x8tPGaGn4++URAFmHWl/fJ4CF8L3T+c/cRpXg8t/e0shIdNthOD85Pnmz8meHE6q/6aO+jQvZXTGJZzVtnxOLJP0KMRv1yXYIPeQ2WH3SULL7wvtUrgtrahnTcNGYkEw2EXPgWbWznQ48DMRdvSCbb/cXoDN2SWP5nCgAAiN9we1xLJeQqQUA2wIEiPjYWRRcrAvpCOkjybavOrFbeb6XETMj3+OHFxlgi4OEhDaJOo/jo7D0KKPNfvVYGgHGXo8aNFcpaPPks0YVf01PMjg1ktwSuHnJr2PIaKWNa+xqPlRI2Jp3iRwArAYrv+5LGsM61t7Porfnk3OqQn50yY9r5w7ObfqgRCq+v//Nc5Oo84EU5HB1hZjDV7nUT5cRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 06:40:57PM -0700, SeongJae Park wrote:
> On Mon, 20 Oct 2025 17:08:16 -0400 Gregory Price <gourry@gourry.net> wrote:
> > +
> > +			/* Don't consider moving same size/larger pages */
> > +			page = compound_head(page);
> > +			order = compound_order(page);
> > +			if ((order >= MAX_PAGE_ORDER) ||
> > +			    (nr_pages < (1 << order)))
> > +				return false;
> 
> Shouldn't the comparison of 'nr_pages' against '1 << order' use '<=' instead of
> '<', to match the commit description?
> 

Good catch, got lost in the shuffle.  Thank you!

~Gregory

