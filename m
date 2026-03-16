Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4B41F013C0
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 07:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC816B0152; Mon, 16 Mar 2026 03:32:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 050956B0153; Mon, 16 Mar 2026 03:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74986B0154; Mon, 16 Mar 2026 03:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D3E566B0152
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:32:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78EE6140DCA
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:32:36 +0000 (UTC)
X-FDA: 84551108712.01.1A8EBAF
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 849F8C0002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:32:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fprEphja;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773646354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1v/dlypJeTwP5cfRx6n8+4g3859w68KLT19UYG1+6r4=;
	b=vxpULc8IBGLAFgy/s+VQKXzmRcHF1ZtLDdmGpcSl+/XeXFPo9QUazvN7SiTlP+5DOEOEI+
	0jE3BACF2d7hL0KGnOL/O0UsbxpILh06LNC16Xkk3pwJ+907CuqYu6TrjrcknE8wcEOAFC
	AXErWfjGW1YWegv8UERefm+qs6BTb/o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fprEphja;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773646354; a=rsa-sha256;
	cv=none;
	b=ljSNp0BVnlEBiixEMUhmLs5zK/KVJ9ZGVYvDPNO9w4ct7YdRpC7UYHHu4Iib+GGXcLtocA
	df3Oai93IEYvd6qjDX/0p1em6DfjzQ8QbmUzPLDIAcSzE9CACUa6hAgy2TkgzZMkP6QMbL
	i5mntf0Q128+kLCGoCb5T8exmCq4dP4=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso36956575e9.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 00:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773646353; x=1774251153; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1v/dlypJeTwP5cfRx6n8+4g3859w68KLT19UYG1+6r4=;
        b=fprEphjaHFn+VCsSUHBqz5c+ylFhMXj//aG/TujjU6srI/k+USfNHGOM6uKyaLGC4q
         rHc48TDAgCR/PeD1a46+Gf2Jb8Ys4BE2q8+mdxwebMSDadgIaDRWcCKsfibKnsqOQAia
         ykq/ybI105or6brmtH/ySx5smMrHEPnHMoJ/l+qE8Q2EAT2qH9nIvYBy4x3XiraxyRk7
         cCopjCRtjUAoo8qpFkU5/6NxFgN36lQiS3Cv1f8wr5oblZnNs1TyT/uYexrB4MmCvXF8
         mJl8Wcgx/ZGiimwIaK2kREtCznlJEaAdHzHSA7/A1nSheAKZllV/WFGaGVFrgJlLCVIg
         M7rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773646353; x=1774251153;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1v/dlypJeTwP5cfRx6n8+4g3859w68KLT19UYG1+6r4=;
        b=e/kgIrJryKL88FMs2wuZ42W3whAVNstFBVVou2oJDeZo7OcpaI/0lMBJztVvvysvSP
         AgHvtXqtMZAdbf6GbgNzEQUrJwoJiq2sPOjgIozJHt+CnbZ58qldC4oHL2eQ4l2QKF5H
         c/hqg43+qS56ZMe1xKxy7lHMpvgoiVqX7isYoIqvWnuXbyVV3Ux1TH/a8a4wVATJ1WdJ
         eh9qhc3ZGRXjdPjN4wR2TjkkgKkNWEO3XcL4Oy/zCi8AsZVsr0MyH2vB4pO5HAxVgs/0
         A4r1imD12MSN0SytbKsSwgUUz1aoRdpgsgZsB4oE/304AMm1XGlWP25OQikO8A3HPINV
         g5ew==
X-Forwarded-Encrypted: i=1; AJvYcCWCsy3mQoDdHxVWOzrdMqAcB6ZncVYHmOU8OuijK6Y+0M/fmwWit2WasTqtClWNqUg1AmPJhp8zZw==@kvack.org
X-Gm-Message-State: AOJu0YwImQ9nCA9dKCUJvvjC/YhhoPNQjzpA2XJQl+V/pLqpkIaOSwLL
	qRpjS2FdNbyEDwnxif8Q0oUZ9cdmASG4VygjAsMcZbqrpcNNvzhK/TzEfYn8F8NpSwY=
X-Gm-Gg: ATEYQzxq83dJnqhEtqdhUpkLEP06S5L3BGvRqF2xkNwxXTc62i66ioL6/s+ocrpbQLd
	MzI0UBwLJVb2Lw7ZKYcHTMz+Og0NJJg2xxtkV9tTzK3X0W5C2nBlPRsCIrtZOKNG/EyElEslP4I
	XN9q9SeMxewC9YyJeM8UJk7gKo5tGL1G80W0jGJ8J46bYUEdAEIQ55UrpO4Xna+xcX6JnFhvtkZ
	j2JaTz3Ln9vaVmjPjKtMbdz9J2MQdsNXdIGmhZLBD7Bo2emRMXHQTgv0wL+d9sxlv/5tP/OTmEz
	ms4Emz08SzF5hUAttYc+EfSJyoxO1taVkXtnKAln6mfAQBFMufFODuDnpFIwMi961bIwWGHwIpD
	NCRnTrTxjt1ZF3NchFs6JICYXOo4pGj4PxBOmzd72Lid43oHglQUpY/Fl74E+OCtBZdJMn+UGF7
	s3mKhH54y/h/QQCtd7mGIevAFF/1e28H6Z1JRP
X-Received: by 2002:a05:600c:5251:b0:485:3ff1:d5c5 with SMTP id 5b1f17b1804b1-485566cdc17mr194418895e9.7.1773646352820;
        Mon, 16 Mar 2026 00:32:32 -0700 (PDT)
Received: from localhost (109-81-21-195.rct.o2.cz. [109.81.21.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b6070acsm353694535e9.8.2026.03.16.00.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 00:32:32 -0700 (PDT)
Date: Mon, 16 Mar 2026 08:32:31 +0100
From: Michal Hocko <mhocko@suse.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Kit Dallege <xaum.io@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, corbet@lwn.net, linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs/mm: document the OOM killer
Message-ID: <abeyD1ZngYhkAx6g@tiehlicka>
References: <20260314152518.100194-1-xaum.io@gmail.com>
 <fbee0ca1-4de6-4182-865b-a33d9ed32ee4@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbee0ca1-4de6-4182-865b-a33d9ed32ee4@lucifer.local>
X-Rspamd-Queue-Id: 849F8C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: niy7a7majynscua7h6siexxkdkiykf7a
X-Rspam-User: 
X-HE-Tag: 1773646354-784723
X-HE-Meta: U2FsdGVkX18o9hB9whL7N4DLQk8lNWcZKz/1GSdayQSsJlPplYWKwVLW33EqPiyura3KDKM4AsCh8dRXEgnrKVS0oaj6BydOwj6V/Q/ykiEQINi/iN8c3lsZH09+81hIrAveu0GXQjSND9rZ2O5W8t2DqBOFmaIjTk7ic0E/lQdDmWCoWS6pVXngK+TPvI5pD61dyPq1YiRgMFRtiDEsyGaMj37HTGbEjlLgYJWik7i+cNx/TeBhYcH8g/p3PayUnoM/4WJHTFb+qbbpmpkQCcMZCSPOzfzg58o0KqXAhsNm1HebVUnr9eUo6yXyYtKyDkpBwNS44sgup9ur6jL+P8hbPJ834Zi7+rDYt8QIxP2As1yywXZJQ2URu14JjHZKzUZY4ApvEHRJu/Q7eVBG9FGqNGuZ4YuM4TygGm3Neoyek6Y4Dwa+bUKfC7NmEN/Bl6y88xDFC2JSTItvxycqyAVu37A696NUluG59g+QZQX0iN+ztUR1gV6diJwLx1ny/MBkTQuDmPDOtSFbKY62JG/+mRhyy7YZWrQVmMp/t98nd4wB5u1wYYDHPI/tV5hKdglbfrtwqwCzgjhiyOMlmDg9UIzWj5Cw/xzubSMRyIfM6simcnTRyUeQAOUv9YVkiczFNvcDM0GOssiQmBLK8DEAXID8gEJdVqG8vnZz9ITGiLhFwD41loR5p4PAJrYMvLFIYfUZaryWpD2Cz9ZaKY/JDE369lMFWCfq3cWaPUU7FFaDf0G2KFO8njGU0aSIJ9vlxkZr/7i1MjZNIAyVwANWS8JQAo0+EMRdxkdcAXGbYude+n+PdMqScdglL/seJsTj9m3f0dLMvkkUH8ZjmsQDQ8kSnzef2CvK55cGEpF6X9t/1kc4aquZhBTCDynJhO5LIx73NitvSAYToqI/D+ifqcrITKyA9uqZk4J3rAZDdkUJNmIGobmy5KALn5LZO4x6RqguN8g95Qosr9v
 i0k0+czL
 HsE12Nhb3M1sMm8ATtn7Fsg0c3yKpCIhn2ZjJsanwT53AVTIg3aClR2h/VfMzrlAydAg5DaY38RsOFho3wabQ0RJt3zkaBQMRvsYo5IKZ5glP6N84lwS6rfDJdRRbQVakEVJmftA2zsRsAbuQTqJQllE28o5ZWEaXQo3nSZ4g8Sc3m4MQ3tQUBQD+MAFpWUbOHPEyo1CiwRd7th0AHlMdQCj+kUJQbIF7m3llmA9bFfZdJAAlBNUJBQ5PKUsah+1N+2/QfpgJISbwLeYN7LlbziUdhju5AVFPHmPoSM1w+B66mrOcN7W3d38Y7eTPJtb6KkIQJWmbsEerJe/0AZik0i3eHGbcfjxYRC1xCy1RXWgzCjW6M3aTpUiYAxy7mZKaTS1V5hBuHTqyooN6qYvkpkPiynyumBP4OZTBdXqxE6akG4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 15-03-26 20:48:22, Lorenzo Stoakes (Oracle) wrote:
> NAK for being AI slop again, obviously.
> 
> Again, +cc the OOM maintainer you failed to bother to look up.

Thanks!

> Reasons, as the rest:
> - Worthless documentation
> - Everything about patch screams 'zero effort, Claude did it all'
> - Bad etiquette
> 
> As with all the rest it'd need to be totally rewritten and it's not worth the
> maintainer time.
> 
> On Sat, Mar 14, 2026 at 04:25:18PM +0100, Kit Dallege wrote:
> > Fill in the oom.rst stub that was created in commit 481cc97349d6
> > ("mm,doc: Add new documentation structure") as part of the structured
> > memory management documentation following Mel Gorman's book outline.
> 
> I mean the more I see it the more annoying it is.
> 
> >
> > Cover the scoring heuristic, allocation constraints, OOM reaper,
> > process_mrelease syscall, and sysctl knobs.
> 
> This sentence contains almost as much content as the patch.

The real question is who is the expected audience of this documentation?
Administrators, kernel developers? 
Reading through this proposal this doesn't really seem to fit neither
well. For kernel developers who try to wrap their heads around the code
it is barely scratches the surface. For admins it doesn't really explain
more than an existing documentation for tunables.

So if there is a serious interest to make this useful kernel developers
oriented documentation I am more than willing to help. The code is not
really easy to follow as it is scattered. There are many subtle
expectations spread out and it is quite easy to break a delicate balance
tuned for through years. So there is a big documentatin gap I never got
around to fill up.

-- 
Michal Hocko
SUSE Labs

