Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ACDAD277CD
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 03:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7CE06B0088; Fri,  9 Jan 2026 22:03:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A6F6B0089; Fri,  9 Jan 2026 22:03:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2C576B008A; Fri,  9 Jan 2026 22:03:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BFD546B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 22:03:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 668D9BEB14
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:03:39 +0000 (UTC)
X-FDA: 84314558958.27.2BFDEA2
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id A40FDC000C
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:03:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gyxY0HOM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768014217; a=rsa-sha256;
	cv=none;
	b=ENi5pdlc7Eixd2/6uYPxxFRdJHxNY6pmXLUdTY7fJOk98csgUnKFjdurfcdhylX6gL4cO4
	7jXQbwMzXkprqnsmB66nqKB/nexKxPsgNftMERzK7wE5VyNnDPM5ASfg903j40vkxXU2wt
	4ZlYD89G6WB88xbigX8LxcTHFclZ5sE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gyxY0HOM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768014217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zC912g/nQXiyktMDqOupygYAF3nxt2uOGfJ4uwa/AMU=;
	b=Bh4M2anQHeOxAljdbidJR4lHJIqKcRYxwTiFq9N8fduyEiN4KjGIbMzCdKqTgpY5rKVWq1
	KJrVFKbhB/axvsjdN8jIBo7jUU+r9E4kNlQ1JgGeAcKMvfCAAimefQdIElTAVDxrfxK6rB
	2CJ1ZJmWamwzNRuRR0vKJ4+dSCiguW4=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a0d06cfa93so23135ad.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 19:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768014216; x=1768619016; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zC912g/nQXiyktMDqOupygYAF3nxt2uOGfJ4uwa/AMU=;
        b=gyxY0HOM4aX51e76RJrFT49XPv9tTAvlSxLQ4LQtRh3nOV91VYYijQ/lHUqTaYX7wD
         bMOqJD9TizoScS8mkJ0lr025QOkHhEmOFAzz6T7aaHuQEKLIEwM0eYcqQ6+mQU0WQ/Hn
         cizSn1e4Dagxvuz5ka80CX6gCp8CGPcX60u/lb86Mzd0RITfEqMLlAq+s8i0YOxpiN0p
         ebet6gm1jfM8YkFsmaD/zKwj2yhUy/Pa6etI7+nk52a1R8kc7c0CcNrWT5roDjAU/4zW
         lsYb80XONJo7eqPCgHktw27CxAh8ueIWNtAinmLSOK1nsSIkeAgfDyiiFf4oz1txi07l
         WFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768014216; x=1768619016;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zC912g/nQXiyktMDqOupygYAF3nxt2uOGfJ4uwa/AMU=;
        b=Dhz29JBrRRxZ9/ryfJaYG6G0xgTFnytUMAYHRHCxS0mYdyRcv31rd/3qTop6EPjUGs
         iGLm47UVaAYWIFbuHnD4KAKClUS1KUz+MF0kHeDwZefLcJCJk4DtI3AxgmB+Xr6hjyoN
         sLuf7WY16suEn/ezUbztr/54Z8dQT7IJuPO2VyzKWqCLptAEnf3px9t9hOgrT/MB8tuK
         quzC4GXag4dcJaHoH4JaUhd/GqU+wR+0qssRj8az98Z1H8qla5ogiHHlNG6UMTY7tsc4
         7wMBdFPo0Vgcf/opc50EeQYhEvyVGysd8ntla4JWlXCKHsjI9twrEeBxKSRm7BUwHiW2
         1ljQ==
X-Gm-Message-State: AOJu0YzobIh+o78kSkpDL/TCU2LrUxJqEIj/PMkSlG2AF7lDMx3031mu
	qdfONbwgCk7SnTouAtAmCIUFjdOgRt5K6CwHFljYo32fIhjvfyum/1WPJsPXW1FePv4Qu1hrjij
	BwTWFmw==
X-Gm-Gg: AY/fxX6T+VdIGGtMsVqaAMlE3nDCcqE/gf+eL4wVmY0uRgxuoh8+pMfq89krFMC1N6R
	r1SE2KZdeKdvaj54j3vmvZ3h1RQEdHgCeeWLh95+W8YI0VebTcr4Jh7iv9UQ31k4eAoD1G+GiB6
	MpE86p2/SNnve7hpfR3sd9RGCkTYBdsl18d/fpnWmO9hbbfHVlejZvZKbCXMKqXCL07is8UnoIT
	sB7KfIL0hzmh6VdgSTih9Y5imI1wpeg/RQlNlj9Ghb0XtAr2FMHAARYDdMFKTmk0pdNrxDJclnD
	JTAoO8voM7XE0qF4iwaPS3JSHqI5gBLmqmRO+1BxJMvZ69Tf/w8LEkX2RLjoWQpEmpJMfpPCJg5
	mfRHgGILhl/Qtqp9v4z4yb5ramuk0roccPbshOcJ1dtTaKfKqC6nWud7KrqmLanxP7eDJT98hNe
	HiaG5e8iMOAUVyNoMOcVd11OYH22KnA59wqWknA4iyHypYAcDi7E9q
X-Received: by 2002:a17:902:d505:b0:295:5405:46be with SMTP id d9443c01a7336-2a41553b815mr1046565ad.1.1768014216008;
        Fri, 09 Jan 2026 19:03:36 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5fa947ecsm11721476a91.6.2026.01.09.19.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 19:03:35 -0800 (PST)
Date: Sat, 10 Jan 2026 03:03:30 +0000
From: Bing Jiao <bingjiao@google.com>
To: SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org
Subject: Re: [PATCH] mm/vmscan: fix uninitialized variable in
 demote_folio_list()
Message-ID: <aWHBgmOxt5_40Ues@google.com>
References: <20260109055937.3739860-1-bingjiao@google.com>
 <20260110012812.81501-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260110012812.81501-1-sj@kernel.org>
X-Rspamd-Queue-Id: A40FDC000C
X-Rspamd-Server: rspam06
X-Stat-Signature: 5j4fhgc4b1fs3uneyicm7fn89rnijx7e
X-Rspam-User: 
X-HE-Tag: 1768014217-815616
X-HE-Meta: U2FsdGVkX19OIGOTXOGfNmd3YWmZiJ3p/Ak9ZzPNqQxt06VWWb08oUUn5ZYy9KCBQe4uVyCeA+ouLceHcVYvvTPKJoE68HiQYOh+nhUFdM6AvXr35C54KRClVw8Gm1Ws2y3qUXNCkM5P6RugRgVqLbG7JWUcfL0sbIB2Z8ierUx9PvXsqfhaRGh2RuHRUU5B8LSjt3J7bp3uB87bdvk0uDdkrygpD0FtPpNBDOZDMs0rJVep9a2j1SGR7Xv9owJPE8Hxf9Vd1oAWdV3TdrVrbmSlIoqAW0Hpm7VXQy0GMVpFg6zIKU4UhXFhFIh0OBhH0Xy3LqgrvxOwITsgAQJsKgNDU7qaL7BJZufT1ufr5CVoto456Xy0VtVk+urKi+A6K6qeuO2BcBjBBZ31YlzqupPug2ntqqUcFgSkP0UqDiDDYT3D8hlJYOLzwQZpxObBBHxohOalYeMGtc37mSqV/oRD3hrUHkNLRN4/uvU4xawmzv5jpb1B4p+dEkeWBkzZJkScRK0Yei+BMJRg6t+BHlRm90XPvDcyne1xYExagiQ5cDYlJCD4ZsKU5Me8/n4qzXoo+4cRtc4ygBDzRmfwYZPmJG3xV6ZtDcT1lzI1fQE1mhrD9lFjJa4UzbnjzAfGPo0EEyj+54dwh9wR6mnTeWESbT0h5rIn1uxH3AuJ5A0gi32PoQt7aF5evMB8lhBwK8rGKS0Pk8DTuPn+VAkAwZzv1/G6EL80nc6JHt5ws5pdDFgtGd0D1Veq/GE5nfV6Of6lhvD+CT6cXGYkQ9x0BgO8OUOrnWPHyj0PVuw4IQNHYXquHckvAaYtzsYv175dyeeRPJtrTUIikKVoZD1OVFydt+cO1odRBGCQqGq8Lb0ls8pH7umKSqxw/zCPaVuHbmMHW6+njxkBffRJMDhbP8xrTMfaeAy3EcyUnd6O9F/GPLSGMXCDgTwhOygiOxs5L6CF5FgPLvlqqEZS704
 62zO1qVj
 +mnKZwC0vb0QoG9S8McB62PXT1cUYp3pDNqYYxsf5gogtbbXYXEGNndQlCWIVuoMteiqRcB8QbvFeYQTgwBD2d+dDcNMrxoCCvIgzB8gVM9eltvAU7EImudJMrtMhaZaO3lEOAyU0wfXMTspK95vqNy/HErsCJd3Zyq07XVfvsV8HETQ88LFm6NB6sST+B/ZsAGqcgGP9MatHpsC5K73wFJ7nS5vNAlVvqTd0XLI2h68moWGMOYqsG/1IbcYZbJ0sQMShe3Zm3R/yiky04MMkXFId2p6+X6ghrmPU6G9emZntMOV4MyM3g0Bgzl1NhWpjsaRYJJZOfV+HIrOuc1y++lnNW/3AGYcICz87qjFzJpVrWonrWwOstl6s9FPe8yYY7Aiq4pqdpu8AfhrlGtARS38BdJdFLJAOA9buidcCELN/fBvONIlRMk3koA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 05:28:11PM -0800, SeongJae Park wrote:
> On Fri,  9 Jan 2026 05:59:37 +0000 Bing Jiao <bingjiao@google.com> wrote:
>
> > Commit d92027a5f30a6c ("mm/vmscan: select the closest preferred node in
> > demote_folio_list()") refactored the selection logic for demotion target
> > nodes. However, it removed the initial assignment of 'target_nid' while
> > leaving a premature check for 'NUMA_NO_NODE' in place.
> >
> > Since 'target_nid' is now assigned further down in the function based on
> > preferred and allowed node masks, the initial check at line 1046 is
> > redundant.
> >
> > Remove the redundant check to resolve the compiler warning.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202601091037.vUSHeJCH-lkp@intel.com/
> > Fixes: d92027a5f30a6c ("mm/vmscan: select the closest preferred node in demote_folio_list()")
>
> Seems the broken commit is on mm-new, and therefore no need to Cc stable@.  I
> think explicitly clarifying that would be nice.  Also, as this fixup may need
> to be squashed into the broken commit before it is pulled into the mainline,
> sending this kind of fixup as a reply to the patch mail [1] of the commit would
> also be nice, and usual in mm.
>
> [1] https://lkml.kernel.org/r/20260108033248.2791579-3-bingjiao@google.com
>
> > Signed-off-by: Bing Jiao <bingjiao@google.com>
>
> Reviewed-by: SeongJae Park <sj@kernel.org>
>
>
> Thanks,
> SJ
>
> [...]

Hi SeongJae,

Thank you for the review and suggestions! The patch has sent to the patch
mail you mentioned.

Have a great weekend!

Best regards,
Bing

