Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC1B9CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 07:31:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64808E0003; Thu, 11 Sep 2025 03:31:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACD208E0001; Thu, 11 Sep 2025 03:31:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940E88E0003; Thu, 11 Sep 2025 03:31:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9F88E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:31:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18F9B13A967
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:31:41 +0000 (UTC)
X-FDA: 83876149602.12.0437D84
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0B5A340006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:31:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CE6vEXW1;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757575899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=degBKJVuyHnw33MrOSllu60lAvi3EP4JK10gQgtYi20=;
	b=WxpUxmKHU9EycUEYaicik6MI0prWenT8foOLXI/mVRcTRNzZMpchM/ILthz6bd08iJJTMT
	TClqBYdNV5VcQLckga3C/1KpkMDGeKWhN9uGNMX+G+jJmYqlh5oFCs2JnKnXUUYdD7Sxx1
	MGH/uS8wptCfh/dROwgsi3Mc6xvpsVI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757575899; a=rsa-sha256;
	cv=none;
	b=wwM3G+hiJ1v3SUnBJoKrXrvEqw83YtB8lFJ3SMXnK48oSs1quRJsY9HahMfHA6uIjCv7cd
	G/vUnLYdRshZydbX683kbkKksb+Efu4yzCoMMDAvjA6Rm9oBjTFO19YrGJUFZRcQPCZlMi
	tgaz4KYz8ceqqaXLkfKn0mfIQp3Ga3M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CE6vEXW1;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb7ae31caso59865566b.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 00:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757575897; x=1758180697; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=degBKJVuyHnw33MrOSllu60lAvi3EP4JK10gQgtYi20=;
        b=CE6vEXW1uEU/nJZqgMY6eGjd1JB8hj/V21G5rHKE4KCOR8BDdYhMS/V3AaLoP4NMrH
         Q122bsVZbqisXBZphXCK99QZWJmvUgs/HQa7JkVvAQtNY4xete5J0E2jBkkPfNcnavmQ
         G1eIwdkMiVsK6GGiPvqlDAoW9OXk/42uR6u/cHDqEftU4OsQGGzu7mxdmc6+M1bVoIp3
         mVp4Mb9bDiH/C91nAIytUHlm7s7BEqBWz4bJLRdHU9DWxiYBiD53T/Xzm2CpC/ZMpOW4
         U8F3gdk7QZOvPlrbAaJPdzuzJW9px4DdLWNYmjjsGNqTB2FiR8Zz17+uNRNCrjoClzlv
         n81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757575897; x=1758180697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=degBKJVuyHnw33MrOSllu60lAvi3EP4JK10gQgtYi20=;
        b=UWrKdAj33PV6UaxbjeMnIo7lSVuFuv69FyhAR5BiGzmbcHXDnaBqRpzQCq5xYSbcZE
         Co6MELpT8rnGMNZ4FTf4QKRBX8lx856ZAENHAxxNkFEUxvq20eoqBKZ18iryJTusTY6s
         Cc6+DCziOoGWwn5tzvRYk5E0qmVZbwBPsolXKlNBbd/P+dWWHOAH0vN1gHlJFZaI5ADD
         maPiGtUH/KYbst/gNAvla+jNRpOo32N1VBBwyxVXSUlL/Hl2E5YO24IJYYQr6Hg5qZs2
         QuiLiBbVdHuJb52AEfOgBLDCoKhsO4WDr4atdwuKAZkYx/Fmqas3/rCb3GquOfGduTw2
         ldag==
X-Forwarded-Encrypted: i=1; AJvYcCXAcNTc9bW3kwACZ0fF+PfwR4lZ5dg3jXvxlwoKaty8G9xTrYzFrxXslyeIX+/DhBfDhDtE7VRJgg==@kvack.org
X-Gm-Message-State: AOJu0Yxmp/L+qnOs5fltPvqYMfm19UghHS8hREuhMRx9/1tMBZkRsiNI
	KyZ+tygMPwez91JYr3JBf2bNh/swxvBJBgRXE8wlWQjV45xyi0XSAMXZbykLP2h4Gcw=
X-Gm-Gg: ASbGncstWQmACREdZfmycrtoO5Ou04Uqayb1AmpGJArai8MB4y7zN+P9Wa3FDD64TCt
	WnUTX35rcRlucj6/l4lbUcEsAn9Aj+kfh3xyT307tKeXJ2kOvVZmNsVlnfSxs0xAtTqjMCHm5kr
	IIClGmY5ihrFKQufe5TYl19EQGhKaj79BAv5EO6So3LWueWHniVvp5wtE+qwtSGR+vaaFb/3w/t
	vY+xPTAkFv9Asx7kv53Q5ogvwrc6xXao0fpvewsHgfMMRrNpWAC45zuyoCuGxmTD9cqsfuqex81
	PQCovSxXVZMUPGy7wFATQ1UNAjTM9iPB4aIXTN4xSJ4psR9Jv7VpQqe+GeHod70S/QuJLBmybXu
	DIXFu3MEh07M0uSeKeBLmGVtYJ81KTENh2h3kw9HzmSnY
X-Google-Smtp-Source: AGHT+IHdIz45ITHlnfk3Z9/vpjn8WUwHHtdftIGSPN/xekCYOQYFtBTJQ0MkrZ7ISSCBXqS7+DLEbQ==
X-Received: by 2002:a17:906:507:b0:b04:b446:355 with SMTP id a640c23a62f3a-b04b446113bmr1484877266b.59.1757575897066;
        Thu, 11 Sep 2025 00:31:37 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-62ec33b4d63sm613614a12.23.2025.09.11.00.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 00:31:36 -0700 (PDT)
Date: Thu, 11 Sep 2025 09:31:35 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: akpm@linux-foundation.org, feng.han@honor.com, lenb@kernel.org,
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pm@vger.kernel.org, liulu.liu@honor.com,
	lorenzo.stoakes@oracle.com, pavel@kernel.org, rafael@kernel.org,
	rientjes@google.com, shakeel.butt@linux.dev, surenb@google.com,
	tglx@linutronix.de
Subject: Re: [PATCH v9 2/2] mm/oom_kill: The OOM reaper traverses the VMA
 maple tree in reverse order
Message-ID: <aMJ619kjFm00c4OP@tiehlicka>
References: <aMGXsenuvA682-Dc@tiehlicka>
 <20250911040609.6126-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911040609.6126-1-zhongjinji@honor.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0B5A340006
X-Stat-Signature: 8aitqdposo9gawpc7tm53rtaqyf9jn6q
X-Rspam-User: 
X-HE-Tag: 1757575898-742155
X-HE-Meta: U2FsdGVkX183fVMO+EvrxZqoboN9PVbSGUzgE00qdyI8RbdMYW61/oiaFGsuMM7Tc4nl4zmsrebueNmgO5SgXvPGRPqi7VZhEqoV+d96busZ8sYyniDMMwtt3P/2LMaEp/Vw2KvaMKN5afwLy0ZJDmDlgA7IQApl9X4yYgYpGLFb5eTUzS+yrRvZxkfoSyI20Voht+zOEes65IMWpQElrp5mLnYcDwOiB7BIBAZQnDcm0BehiCsExpsan5QtAO5i+EIteEe0tIL1scz+RjAF6/8ouA2GEl9Zefoc5H1eFqQ25/j0B8RWAMwqu+OfXye3ACFB66WHddxQcm7an4mQUU1iUg2NKSKdVjO7iKYvRn73UZasmHIyRgGqJBcb1PPnm3GsMB6va1HJyXQJr8zhmOPIqsvrwRS3ccYPNVX6gsVtniJZ0qtniT9uSBr2TBcNN6kaAV2GXEXubUt589aZKixPJ9Tcf8jHbVwJQlojUa5L+8H7JAUFPc5/np0bvfbkkWFON+zkJ/7m0Ys+epS8UGNIkWmL2TyJv+WpaJpzlZNrOrE8UTL2tKxtjmFYSPlfkUC3GSDCagkhyIVP1vZFEMvz1IL91qwSo/9O7eHbnvFX6cYB669JhG2AlhYt4n5RGU7jFEf5crypHaWPvapaNNrX2+loVVjrh9EcHqJSboE34o6vpqrwUBaajZ5IaBe7d9FU6YSMNfUBvk0Vdw26VZC07XDAbTNzwZVVNltwRtlMv7xz0iyEKSIppjumLUr999BIE/fmPk/3y8gIfYKGCfuvm7APrYpPgHJ06N6+1rzo/qG4HAMvugNOlM0jN+cgzsOazaPwUoIrk60CU1uzV7+HeXnNaYTgpkoel66+VkihG52Ninftjvj2EOzPd+H0plISY2KK+fTQYaTt7dsDlTcYEIEWtFwu2yK0B3fjR/nUvIFI1zL5QJqaDfbo5KczeC2pFYvAmS/ooxpKdd7
 I4AxX0po
 R+xVYDIe6gPafiM2JBx6ZukOA8mf3vcooLfdw+A15ofdrlkoSmP12NG7NausMkk1od4Equy123Ipspbu0n/YLn66+zgZKqxnZlpMHo69dsHAtNfawhsCb55d4FR5jSCgA2cE7sFLdphAHNdR3MECh2Q76xgm/NMb3FMCQ1p3zYv1wn4jqxJVmRQqccvvxBu2QtHbXahnPUD7ztjNMGoapKYvQw6pxFF9bOm3vRJ4UiUR3/3va6jFV96UtGBMGiS8gq+91bRXAYEu0sLp9gjo0uyEwJ0YH/SQynLAcoGJ8F8z7+KULXlXlcRNR5c2308bNcbapVu+MzW8fDdqjO0uciuUX3+24e4Pxww4AF331rg36GLrY2YJA0HmICCtPgOlfJB7QfQGbaZcVqT5ivZoWI4kkFhbrW490PiX2QDe++N2o/D27EIpB/YZObQAanmTKHeWU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 11-09-25 12:06:09, zhongjinji wrote:
> > On Wed 10-09-25 22:37:26, zhongjinji wrote:
> > > Although the oom_reaper is delayed and it gives the oom victim chance to
> > > clean up its address space this might take a while especially for
> > > processes with a large address space footprint. In those cases
> > > oom_reaper might start racing with the dying task and compete for shared
> > > resources - e.g. page table lock contention has been observed.
> > > 
> > > Reduce those races by reaping the oom victim from the other end of the
> > > address space.
> > > 
> > > It is also a significant improvement for process_mrelease(). When a process
> > > is killed, process_mrelease is used to reap the killed process and often
> > > runs concurrently with the dying task. The test data shows that after
> > > applying the patch, lock contention is greatly reduced during the procedure
> > > of reaping the killed process.
> > > 
> > > The test is based on arm64.
> > > 
> > > Without the patch:
> > > |--99.57%-- oom_reaper
> > > |    |--0.28%-- [hit in function]
> > > |    |--73.58%-- unmap_page_range
> > > |    |    |--8.67%-- [hit in function]
> > > |    |    |--41.59%-- __pte_offset_map_lock
> > > |    |    |--29.47%-- folio_remove_rmap_ptes
> > > |    |    |--16.11%-- tlb_flush_mmu
> > > |    |    |--1.66%-- folio_mark_accessed
> > > |    |    |--0.74%-- free_swap_and_cache_nr
> > > |    |    |--0.69%-- __tlb_remove_folio_pages
> > > |    |--19.94%-- tlb_finish_mmu
> > > |    |--3.21%-- folio_remove_rmap_ptes
> > > |    |--1.16%-- __tlb_remove_folio_pages
> > > |    |--1.16%-- folio_mark_accessed
> > > |    |--0.36%-- __pte_offset_map_lock
> > > 
> > > With the patch:
> > > |--99.53%-- oom_reaper
> > > |    |--55.77%-- unmap_page_range
> > > |    |    |--20.49%-- [hit in function]
> > > |    |    |--58.30%-- folio_remove_rmap_ptes
> > > |    |    |--11.48%-- tlb_flush_mmu
> > > |    |    |--3.33%-- folio_mark_accessed
> > > |    |    |--2.65%-- __tlb_remove_folio_pages
> > > |    |    |--1.37%-- _raw_spin_lock
> > > |    |    |--0.68%-- __mod_lruvec_page_state
> > > |    |    |--0.51%-- __pte_offset_map_lock
> > > |    |--32.21%-- tlb_finish_mmu
> > > |    |--6.93%-- folio_remove_rmap_ptes
> > > |    |--1.90%-- __tlb_remove_folio_pages
> > > |    |--1.55%-- folio_mark_accessed
> > > |    |--0.69%-- __pte_offset_map_lock
> > 
> > I do not object to the patch but this profile is not telling much really
> > as already pointed out in prior versions as we do not know the base
> > those percentages are from. It would be really much more helpful to
> > measure the elapse time for the oom_repaer and exit_mmap to see those
> > gains.
> 
> I got it. I will reference the perf report like this [1] in the changelog.
> link : https://lore.kernel.org/all/20250908121503.20960-1-zhongjinji@honor.com/ [1]

Yes, this is much more informative. I do not think we need the full
report in the changelog though. I would just add your summary
Summary of measurements (ms):
+---------------------------------------------------------------+
| Category                      | Applying patch | Without patch|
+-------------------------------+---------------+--------------+
| Total running time            |    132.6      |    167.1      |
|   (exit_mmap + reaper work)   |  72.4 + 60.2  |  90.7 + 76.4  |
+-------------------------------+---------------+--------------+
| Time waiting for pte spinlock |     1.0       |    33.1      |
|   (exit_mmap + reaper work)   |   0.4 + 0.6   |  10.0 + 23.1 |
+-------------------------------+---------------+--------------+
| folio_remove_rmap_ptes time   |    42.0       |    41.3      |
|   (exit_mmap + reaper work)   |  18.4 + 23.6  |  22.4 + 18.9 |
+---------------------------------------------------------------+

and referenced the full report by the link.

Thanks!

-- 
Michal Hocko
SUSE Labs

