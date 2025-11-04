Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DDB6CCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 10:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D288E0128; Tue,  4 Nov 2025 05:31:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5AF8E0124; Tue,  4 Nov 2025 05:31:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66DEA8E0128; Tue,  4 Nov 2025 05:31:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0E28E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 05:31:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC36188B0D
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:31:17 +0000 (UTC)
X-FDA: 84072557394.27.7C8F848
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id E1879C000D
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:31:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FFeBC9Jz;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762252275; a=rsa-sha256;
	cv=none;
	b=lKc4yZJdlCv+7O7NUMDG/ZPLPA4qg3X0MMXWWzC+zUi033y0Spbj31s1Motw3KEzfMMVy6
	oZu/P7ova7JIa07S2I0wgjmuZK55zSkTDyyLw4slEcejpjbS/QjokWSpPAToCnh8by1I6y
	OqtlWr1eLHvQEY/x4lpxW3YgVV5ZNJc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FFeBC9Jz;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762252275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NSOPSjO6RreslNDAcd5uRimHqlxvaREmrSvGaog2qzE=;
	b=uVA9GJe4Boutk2upaMmh5O6Xgv90X2KDomkITtgMNathtYjqO5AfTFtfe6wjffzsd4L7Eh
	usdS6BI4UV+eeWLlb0ftkS1w27Q5DLxZ3/x2P+kNRGJNuakNTHY+6eiyl4mS8vXxKX2u0a
	R2Yd4oX5qBU2HRz30xUfmocjnQQdvOo=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-471191ac79dso59709095e9.3
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 02:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762252273; x=1762857073; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NSOPSjO6RreslNDAcd5uRimHqlxvaREmrSvGaog2qzE=;
        b=FFeBC9JzWDoF5UgRtrWNMDJnmv+fsvptxVD4G8VumSrUAd0Pmcwg4T5jlT963vMoiO
         mdLqmJSZBLuhmd8PCPWJIhQ/+V97lXsrfmYmQHtu1k6jAPAVoZzc28yZMzFiZBtq4zWb
         bjHR7FzLzpcdkx29CpbU2X4QocbK7+cDBp3kJEFenvVDeoU6eJUQ4yfMh1BBZ631O7GS
         FQq68Sxt/O6KmsT2+DQqfzmPySvXN2YYTG33EyZ81j9MvLnssGrWFIllUVsQbykuqaPQ
         iDMncBeWVPlXNXHrxP+/xKeyPb3UkTADflwKlzbHvijjYEaZ70VdZ+iqAAsf3PRQyKnU
         08bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762252273; x=1762857073;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NSOPSjO6RreslNDAcd5uRimHqlxvaREmrSvGaog2qzE=;
        b=JJ7JaSt76Mex06R4QvXg7K+N9F+u6unCxQVtmtZbDzMj/BzJc3kyJ7zoCOxdQiXcZT
         yi+fh09o0ZNhLhg1yfpMgzrLMI6aI5s1qP9dFhvwD0D09J2okWIHtxyG/IUEQCq4Ynxe
         Z7F4ygwsFura6//O4ARK/CamVqZ1uuD45HbwDKvkfYowq8CIbDZ/E1v5yqqy0IGMYdpS
         ATRkCpROOdhrOAHdrFBhyGszv6v9ZiO/ss3Vz8axu0DEWEa6ryRKxSaC/tavD5SqwQZS
         hM5vDGOlAVriKGI5h3NUYMW+jDjSQF6RTxw2UVR9xDAnS74zit5vHg8PBq/GbWv9zIXP
         zd7w==
X-Forwarded-Encrypted: i=1; AJvYcCUxOWbOmtfFmMDxhEVu6N2G4x8cxw0PA1EuifkUd8i5oK5uHX0Snp7tHULyfkosYVXS8OeXcG2JLg==@kvack.org
X-Gm-Message-State: AOJu0YxjL6ZcOmgZXkP559lMh70mrG+nGwGUAHFejgIujQpOZYun1Wbv
	w0pXXb6pct60vgCYJ6dTu8Dx4/BQCFjQD+IKODr73U5XeUe9Fx6VXt9eRn8cqcG9VD8=
X-Gm-Gg: ASbGnct/Gl3vKEzguWTTL0HAxjWg14YfowdWjT9UjKSJvDwWI+4q6cDDG6POP7nmdiu
	AEEffpjfJ3lKTN36qHx45Pjmln43ftDtjhBUPL60aoUhG5bQ+hxVS43FL7Ydx9tl5BipCzsB99N
	5aPFyIMNCnMCjiglU6zELe3Hw6W/70OsgPvMB3qL2kWz0OgVZM6JgQN/Niq1iK0DhKTqZfoge4W
	60YL4DQmlPuTp2GHbMXRnAleBYielFDlBp0TrP8tQb8RdN7JGgbdm4Zecxq6GkDc2U98qgxCMhx
	iQwjnVOsnmp2WRxD/mNfONiuiuZalKwQC+NSMDQKqHHjIuZoNbJh+jXQtjnB7QnzybsevyqCjtn
	1rIVtsWV6OI6n/O+7/QNmw5YGF0ASHgxkEy2tpRqHSAO3pY0x0dhunMjPV7bmmJpW8/qtF21KSw
	esL4Ls4rquhiMHaFaaxgs=
X-Google-Smtp-Source: AGHT+IG0yM/4LjWI3TtpLMmBCevAasyZkItqRC3R1FYg7HJh2om90kK+v+DnqpEiUr8P0yImeBkO1w==
X-Received: by 2002:a05:600d:434c:b0:477:b93:a7b8 with SMTP id 5b1f17b1804b1-477328b8fdfmr112603725e9.8.1762252273151;
        Tue, 04 Nov 2025 02:31:13 -0800 (PST)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc18f41bsm3680398f8f.9.2025.11.04.02.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 02:31:12 -0800 (PST)
Date: Tue, 4 Nov 2025 11:31:11 +0100
From: Michal Hocko <mhocko@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, libaokun@huaweicloud.com,
	linux-mm@kvack.org, akpm@linux-foundation.org, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	jack@suse.cz, yi.zhang@huawei.com, yangerkun@huawei.com,
	libaokun1@huawei.com
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Message-ID: <aQnV73KorhS0AWH5@tiehlicka>
References: <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
 <aQTHMI3t5mNXp0M1@casper.infradead.org>
 <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
 <qfo7raavlfupjqwbgl2mnmfvmn3z5oslnxcehorib3xjdgf4yo@bp76xmxplre7>
 <aQTb0NdyN3tU50ss@casper.infradead.org>
 <k6k5azen4otnvlc35hj5ak7dmz2gxbb4lrgdu7cirewotggnp2@55cywarovlvs>
 <aQTqELGGKCN3JTIm@casper.infradead.org>
 <aQhf5LJJMlvT-rrE@tiehlicka>
 <9d5790f0-4a07-4cca-9f94-de101084a7e6@suse.cz>
 <aQh1EmVd8IPHK0Gh@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQh1EmVd8IPHK0Gh@tiehlicka>
X-Rspamd-Queue-Id: E1879C000D
X-Rspamd-Server: rspam07
X-Stat-Signature: p9zzi498b7jqw861s1ey84ngzfzct5xc
X-Rspam-User: 
X-HE-Tag: 1762252274-275456
X-HE-Meta: U2FsdGVkX1/Z/jXhIQSmJ9WS+ENnhhK3sTkFhtocdQrvkB/I9xl5pSQwIlHeo+7LknxgvOnBnNm00LTVU+w5gc3vrZW8HKark7cBpQwuSZMs1Ngrv064pDa9meNsBetQlHYjTODE+7NSqH0E67P6DgzpiZovWI1S+ohwyLU31WzUKgQhM0UIABMIeilZTH8nv1CyjyS6uJqkBkpOASPLdx6PPmSaOIQASrj1/m1ktIgjzdySBWxPoEN+MPSNopoLWzlkO50Y5JH/c0tybC0buEgR0OgG+Xqr0H6K7R63SywHJX+muYReZ6kU1v0Jowt31/LpmCFeviPEidyCjp/rylrvhugPB63x22QMust7j4XE+YJcZZZmAL7tCqCv4snV8ZXK+IgfC3R7JXR93ls8P7gKsXAiF1970lyD/6oMd8tvHMAYth4rLoqOf14Np1ouBh2a7I4R7/djiqtDfwXWQt95vwHoPMu22VCH2HLZ+DfO5JDoX/U7qGmXrC746CjMJvH79uxLvecjdOZBi2l1LokeLUQox38XfibB5Muc2RoriPpVKoVjBQfxmUYAvYFZK2BUWoB4KvwAyce7QQkvy2ghnereflvQKQtID/ihZ9o3aq9OZssH1Db2C1WTotJno9ttKHrZILZd+bkaADpbDxzklylrHaXtbMBRKGhDBAjQclJWwuxD1tgBdqW3cewRzNMeuNqotklpHcJCKJZNU5a49jPbjRoKnLWoYPqUHi6TwEH3rhO+51Z221aQm9/TXyWnFVp+oNVwruwCQHiNPX56nP3t9pBBvhQB5uumVVCO0Svmqbsniclh8Kr8tbZ38QCGprilNwezzhG/8k4Vv2+qA0vn32v+x6WisK4lRq5xi6p5dXIVvjouY7yKR7DDRwtp/N0sdpoTI3mDvEXQwt3YkDZ78Gjn9xUUxsJFOqlDmov826TSUWY2MiT0ScnVP+mRcGADhA290oinOMe
 jnYllZHv
 znvtAhFZYMs2rsFVSI7Y/xGtOh8k6gIYcJ61jRiNe3pYjpbxEL+WPQAksH04+UELd3lcwVyftd/672C9BSHfIoEGr8Bs0HIB31lv7DeSL0Sz7JB2uoVFuLvb2e5lPnO2m4KYMUqSN79/TbThAPxMt3Qht0m7QYlJukW0HSBQR38sFLOzTD96PWFlR1E1ZuK5RVcJy5Tkc5jbrdpl5nVAf58m7F/dJaDcsiQRiY5AFRPor5FpT78cQa6a0Ey4Y1XBA+gjoV6KW8j+d81yeWg8VFSFSUrKFh0v3n/QSdwmLPOkFwyuMTEHwHltSNz1GrlRJtRoha1eqn0GaZh42+e06I8MoXgtIIxzxr1LfxBc6PcW9ItbLh/OUktfluvl0z6KUlivvbIANDUB80mlkljQ1nLLZSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 03-11-25 10:25:40, Michal Hocko wrote:
> On Mon 03-11-25 10:01:54, Vlastimil Babka wrote:
> > Maybe we could keep the warning for >=PMD_ORDER as that would still mean
> > someone made an error?
> 
> I am not sure TBH. For those large requests (anything that is costly
> order) it is essentially a loop around allocator inside the allocator.
> I would be really much more worried about order-3 which still triggers
> the oom killer and could kill half of the system without much progress.
> For oder-2 you at least have task_struct which spans 2 pages but I do
> not think we have any guaranteed order-3 page for each task to guarantee
> anything when killing those.

Essentially something like this
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 25923cfec9c6..2df477d97cee 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1142,6 +1142,14 @@ bool out_of_memory(struct oom_control *oc)
 	if (!(oc->gfp_mask & __GFP_FS) && !is_memcg_oom(oc))
 		return true;
 
+	/*
+	 * unlike for other !costly requests killing a task is not
+	 * really guaranteed to free any order-3 pages. Warn about
+	 * that to see whether that happens often enough to special
+	 * case.
+	 */
+	WARN_ON(oc->order == 3 && (oc->gfp_mask & __GFP_NOFAIL));
+
 	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA and memcg) that may require different handling.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d1d037f97c5f..ca8795156b14 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3993,6 +3993,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	/* Coredumps can quickly deplete all memory reserves */
 	if (current->flags & PF_DUMPCORE)
 		goto out;
+
 	/* The OOM killer will not help higher order allocs */
 	if (order > PAGE_ALLOC_COSTLY_ORDER)
 		goto out;
@@ -4612,11 +4613,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	int reserve_flags;
 
 	if (unlikely(nofail)) {
-		/*
-		 * We most definitely don't want callers attempting to
-		 * allocate greater than order-1 page units with __GFP_NOFAIL.
-		 */
-		WARN_ON_ONCE(order > 1);
 		/*
 		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
 		 * otherwise, we may result in lockup.
-- 
Michal Hocko
SUSE Labs

