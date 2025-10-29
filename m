Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD9CDCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289208E0080; Wed, 29 Oct 2025 10:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2397F8E0045; Wed, 29 Oct 2025 10:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14FC48E0080; Wed, 29 Oct 2025 10:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 042F38E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:57:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8E5013BA93
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:57:48 +0000 (UTC)
X-FDA: 84051456216.28.4D3768B
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id EB38C4000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:57:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wOAf57Rr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761749867; a=rsa-sha256;
	cv=none;
	b=fcvjZpw/5txrHLYii09Szj5Pg8t24G0cH1JbNywYzOSiB0cmcYbfQ+tUjp9HX5HgGTOr4b
	7tADOLcw91TJf7Onxiud7vL0t85Vu0eAkp2iX6CIaOYzClUgMcCigYopuRGPiosAKLJrii
	PKfqSoD88K12JJW+Zu34BI20bvqHq/s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wOAf57Rr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761749866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1yPrZJAtYC54ch5kkR2jlvgWTejLF7D5+gBaBiHJFI=;
	b=lAphVg23Lji+OvLHqFWgJSg+LE31ypl8HlcmtHgdoxANLXIu1183EWzZYngxOyO6vu8gI/
	z/SskBk9TNwtnEq3WDqmE5lYJoJ4HosEyOoem0jgTQ/o23UEoCBEJyQUIqGFwwoMOSuZG0
	rhIG5LQrko4UOnotqTNgmlvWZ7kIdAU=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ea12242d2eso340711cf.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761749866; x=1762354666; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d1yPrZJAtYC54ch5kkR2jlvgWTejLF7D5+gBaBiHJFI=;
        b=wOAf57RrkGg30aZc/218LwYXn+ThOClkBStq536tUuHkJkuGnav1eyss4c5A8Rzs3e
         TEFEF4T6Cjbs4oPH+DTyA3Qlk+wz287/DxMQApd2hR78VJU9bcgHrOe1aLvW7WPiGkKD
         uPie+k6nRrmII9AsTWUoZycpTR3WGvsoImnwviMIodG8IZV5HhXfnHTiyxGrt26V7gAP
         /mfLdDg+gagWW63oOvXjw7XrGeIxy8PBN1OIhjuw588V3t4/akkaCWyvKQiB2Nk6dkAT
         QTtoL6zj/e5WHpN6RJyPt8uC/W+I6ZgOiJAGog1ME2nUkMP1l7i4OAn7AGJoxgj+eVE+
         oPPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761749866; x=1762354666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d1yPrZJAtYC54ch5kkR2jlvgWTejLF7D5+gBaBiHJFI=;
        b=To07o+rO72J1s660KcQahpxf9k+r/+GWUQ4nedItGETK/fGp8lcrxUcnHF6dgPvgf/
         wXIMSLQzsz5Ud0UeW2ueYBYDOK52sCU1jqZRZqnjpg/NS114NwVMQ9DdE33vE8AaS0Fg
         TsyTe1DUi0Vh5rJ/cyzQxxvZa3yjhUGoz2YVBANe+3y7nnK/DB2tALxgcmv85TtdV+/B
         AFKeMINqIMp07FcO6x5S+u36qrvLMeuOUB0L3vVfjFHNsW4YqQxD3Al9gvv0wvYllmWR
         6xb7ufpxAur/KPWYpIepB9UdmFBOA1jU2464NImXjmW0GOqqBfX2MjifZSOc523MUObp
         HFJA==
X-Forwarded-Encrypted: i=1; AJvYcCW4Q4ht7YddqqLomSL12TWgFNYMkFyzgD4rU92zgZwusZhLUpqMHN5h5On6bNE7c5Fm5dcV2QXg9g==@kvack.org
X-Gm-Message-State: AOJu0YzGSmASBXRBf49uXl4nffR5TWY1F+y8yRZuYxhzeoYgC2zE75I/
	Ahts0WSC3XTq5DsPlhTPc9ECXEjtqj+6UHHS9BrNfWI6Uy99PjxQv79R4mGDbcOuZrmTK/g/92P
	vL0CSO1khFeH0elwk6hddYCMRWHNrJu4EyFRXloJY
X-Gm-Gg: ASbGncvhGBAM2pKnGJ4QWl1gAYVlToZLIL6yqQZKxDzagbILxD1Ftsux0ztXBkUYDHy
	gnQy+nhsCHGCyZ5Q4cSXQEmRopbuGbbaEGq9dZWhVACfcL2dC+Vthq27TJhFVVeeS9O3WThUcXe
	sE0LeJBwBkH1KQ0XOljYF9vbdOLQzOqfp7VuoIs63zE01N+xMvY8La322XGb68CO0uFQPkz8KXS
	piG8YiHuywejNvgcMNKAdKi2wTzndHGg8Z2adSDUF7aCof82qACrOcDtc8JK5CYphCoAUTleALJ
	b8FtSxpLPBCRxToX5jLidubH5g==
X-Google-Smtp-Source: AGHT+IHJk1Z4xsEEl6nhEK364d+WNrqkglBzi78RQdt59uckdBYZ7htllhsIgZwt9bC5EN7/2oXDuEWCE2gLHAXeC4U=
X-Received: by 2002:a05:622a:11c8:b0:4e4:d480:ef3a with SMTP id
 d75a77b69052e-4ed165a8088mr6994811cf.13.1761749865638; Wed, 29 Oct 2025
 07:57:45 -0700 (PDT)
MIME-Version: 1.0
References: <20251026203611.1608903-1-surenb@google.com> <aP8XMZ_DfJEvrNxL@infradead.org>
 <CAJuCfpH1Nmnvmg--T2nYQ4r25pgJhDEo=2-GAXMjWaFU5vH7LQ@mail.gmail.com> <aQHdG_4yk0-o0iEY@infradead.org>
In-Reply-To: <aQHdG_4yk0-o0iEY@infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 29 Oct 2025 07:57:34 -0700
X-Gm-Features: AWmQ_blGYfe_lFn4eY8RCcDjRQso5Ijs05VisPx1zbBZudE9r4ISvY1EtlCdvh4
Message-ID: <CAJuCfpFPDPaQdHW3fy46fsNczyqje0W8BemHSfroeawB1-SRpQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Guaranteed CMA
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, alexandru.elisei@arm.com, 
	peterx@redhat.com, sj@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	corbet@lwn.net, axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, willy@infradead.org, m.szyprowski@samsung.com, 
	robin.murphy@arm.com, hannes@cmpxchg.org, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, minchan@kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EB38C4000A
X-Stat-Signature: pg5r8zib7rsgc6xttgggioenujepdea1
X-HE-Tag: 1761749866-441738
X-HE-Meta: U2FsdGVkX199RfjN7YHyC5Nh3kX/wuYdMtPU4eYqWCMjNZ5ZX5tgr56AG+i4C0+iy4Qdv5IlQZeKHVECwa1VdGGli6HC4XYt+vBQcYFpOI7manMqPJ4PE3V6/ft1jyP9TV+hqeC3nF7BHsH3XwZy2gWZBmdDgpGL3NzP1jfva/tTQko1ynKsfBNSADnv2UWEpz0ioxq7iEcELDPNriBvALpQs57d/QLG2BCAiji9BuAwcGxJSJ5yRR5ozaJx4sSzqsbqIYh2lGjluuc6epHR4bV15EThZExMSM1eL7LTz6gpEl629CscKezGSTiU1j8aq3Dy2jAwq03sKxkL/YSws6u+rUTNR3DgMVV5ZYNtbVO91a0ZkfqAKB3o9ePVv7jFf+WTqQKjt/cxncw7fDUGj55z4RC3a/xx9Dmb6684c9j6p70JoWSQFmUY1fw+jsH5bzkWxwhbs/vJ7cMCHEyJnDIQCi+i+GDThgXMpEeUMHpsAW0NNevlDzeBa1TO7LSsM7pcMnXQIwBQyySfLgx2e+Uh+6MBlkfCDfa8Cuk/Uk/EQ+mBzdSMdXymLUta81642XN2LvYSrKimAlYxAyrymycRJOyqr+MdPsy9L5GiAHAg8jc3xSIroSK/XRaaV7enEaFSAnQ+lHSh6nAB+JR1VdGTRb8oWUy4FF+Ev+fuJr2npSmKnvD78DEpgzd0eJp0AcXOMamsF44iBQJ6QBETTMYBNJkkBQWt2N/Vq6i/AwH7LDhe2bFj5JhPt2St/W9uBQtw70up7bZNjGNx1QXNEU2K4r2O++Iq0sspr2kUf3MFzShefVkSXrwno9Pu7s/icPoz4K5QyeWPuh1sGr4JD2uAXTA38PFqiBx3hMGbZiSKJdKxmGR8gTlFyrJVPXMg5tDEu/ZEEIBXbXxyTFlLIPuWCX33522mx0/jcZCru4I6qqz2RwMKsNum/ruuAQ2LUgtyhHly3DMOQDVQZ2H
 gdcrxqQo
 6+3cUYEFqTKz81ciTsVp0XJkutMtuSrpXvlpFdt7flZGlifBus1xy2z8xZh13KxaGsDPqEqE9MEoYkHkx0wvm1naAbexfi2TnimDgnEq6t+42/o34M9vB0yONi6L7OV/C5eNjvRSsWvuXbNIliZF03ohgyDCR9y/c5mSMwPhhQS7N9SNMJ/RJ1OX5Bkeb+UWvcWrSm+cdfvLZL7lzHHJJYpPKuLV6i5WR9ih7NNvwhGw2RS5VImmU9Li58KVbKPwh9JXXu4QMF/vjNKKO1YUvtuUlpYnhEwdpcyIrDVlqcCKe3fE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 2:23=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Mon, Oct 27, 2025 at 12:51:17PM -0700, Suren Baghdasaryan wrote:
> > I'm guessing you missed my reply to your comment in the previous
> > submission: https://lore.kernel.org/all/CAJuCfpFs5aKv8E96YC_pasNjH6=3De=
ukTuS2X8f=3DnBGiiuE0Nwhg@mail.gmail.com/
> > Please check it out and follow up here or on the original thread.
>
> I didn't feel to comment on it.  Please don't just build abstractions
> on top of abstractions for no reason.  If you later have to introduce
> them add them when they are actually needed.

Ok, if it makes it easier to review the code, I'll do it. So, I can:
1. merge cleancache code (patch 1) with the GCMA code (patch 7). This
way all the logic will be together.
2. . LRU additiona (patch 2) and readahead support (patch 3) can stay
as incremental additions to GCMA, sysfs interface (patch 4) and
cleancache documentation (


>

