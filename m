Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E766D606A322
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c06Z2Dp6
Received: by kanga.kvack.org (Postfix)
	id BB6AB6B05B0; Mon, 16 Nov 2026 12:22:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8DE46B05B2; Mon, 16 Nov 2026 12:22:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7E6C6B05B3; Mon, 16 Nov 2026 12:22:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5C66B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:22:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B66BD1401A5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:22:43 +0000 (UTC)
X-FDA: 85441651806.11.419A498
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id BA5C71C0005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:22:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=c06Z2Dp6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794849761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lmlBXemGnXzGbNAEKUaRqB2tKtWoTT/lBmI1Jxehu0Q=;
	b=RGK5xVTvLsOnZ1nmIKOHD7294GYFLs3eOn2AbbhbnOdXVwh9HpEJfV//degfRa5dzXjCS8
	96uptRm5B9JR6LZA21gSvIl309bRn5rcBRpxZhlIYlh+sY+yh6/pYphLvZEWOw+uswV+aW
	rHBBWcdEJN5FFDLOr+HrTSZ+7cbJCXg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=c06Z2Dp6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794849761;
	b=s91MN9CDtGG5zJD8h9CLkYA83sYK9FocgMD2XuSe5MmeSHPHW2h7scA2QdILLqkdzWahoN
	d7RN24Fsg6n4pJFgyhhy41h2WwGSB1+jYCNaOX3r35XKIwkpx9ZZQx6t2bz6PlgyElFuIY
	Q5CeMdy+90p7NUirSl2k/0IspZ0PDsE=
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-71ada4644f8so1024406eaf.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794849761; x=1795454561; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lmlBXemGnXzGbNAEKUaRqB2tKtWoTT/lBmI1Jxehu0Q=;
        b=c06Z2Dp6Jk+kIKO84Bl/5MU5wi4HfxdTJSw1sN7W8k3uCMymxzU7BMNVB82cmJMk2t
         PDKKUMh2R/i/Z01gQjqGLAWxtq9g4Fl7PhBOp2ocrikRIykf/gJffMDxHE9LiAvgYxbD
         j5Q519uKD0N/PETi9qWHzJ99mjquPGMrx38L9ykqM2P0lhzrQSrSGM6IDmG9omjggXP7
         61JGMOObf/7Y7ulaRYlMYtTICwYNY04YhrFTMb3oWnb+Vtj4AKpTCmyTz6Sf/Wy9RXVN
         y3fZJt8EHtWObb08toR/55CY1WF70x3RPJuc0MoKdn6S0KYbWrwGSveQW9X9KPGTCERK
         EEfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794849761; x=1795454561;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lmlBXemGnXzGbNAEKUaRqB2tKtWoTT/lBmI1Jxehu0Q=;
        b=DmZmMcm6woRBAMQ+liS8IgpMtNbXQgJOsc25vZU0jOmQOl0UXhvtngGCRROx9cEgHz
         MyzC00ZOsvPUcifLhUQODhoq3qAIphtTjk6pVAA3E/WnPRfdcdS7MFAV33LBg0ovAfoX
         Dl2hv6rXZE3JS0c9gAGR0qAMjxbygCkzWt5yNeglurHQZ8z87mRIJIzxzZPQ8yzeJqAt
         ZEFX3QWbHD9rxh8QPsvvm+ipkdhEkHg6cMcAOICdMtKQk+jzh8AkTmlg2328pWnLvLJ/
         VHSTdkVA2JZcHap6j7ElxpwwoSg0uCP4TUeenuz1lVDKzCQIQp8PNzzv/P+95J1Y35Wm
         Xk4Q==
X-Forwarded-Encrypted: i=1; AL+hErG/Lhr4V6RegFeesXFzrBJFHuDnoq8ERJvPt6f9MI3RcIX+Pm6JIyOkf5HtHIiP2fs8DMMQZ54Klw==@kvack.org
X-Gm-Message-State: APuU4Z96rRwtxnv+tV6dJsRsAROK6dBHNv0FNIWJ7YrICZYl7TK+HnmY
	Hj5A7dm8z7c4pGC7R7Ae3sr3BS5BvaRLoK6vnC16RcnMVB4AOvtquflo
X-Gm-Gg: AYBFou2wGkD8TkdrqOxqkGO1rAqC7pIUYjFZlWz5yz24F1wsH63F3PdOnS42rzVNc5q
	4AlxrWfHyKsbRhTo1f4vpnPKPIP9LlaB++zAQbuttrzUpskriij0pW36URyiqNVmWrPqZzk/fKF
	NIyNQsbpKGjoIWgSGqmDNdVhmCLmEAjqjWHnOJXnEwKCV/dforCAaf/wAAybWCOr/44QmjUIE9Q
	NJ8NrayvASP0LAV2poEmZx0qW0G12k6LhgaHADKpHqNCPSwU01OCit1BYUJ0u2Sy7FmnSbP2ylH
	EYi1hoarGXldhZ327zjYazqAIoiPHDpotWFf2ByQ5pcxd2lRtbdsAzqoGo6Akj6dLYozM8xquiB
	XJcigY6NcUiLzWl2ZXY5EINAlXD6GwQjQZ/4BmYUeRzHqo3oCewA5ZzZ9G2dV32hE+5VQyv52ku
	sMJm0KXvNvYHamVV8h/iOOD3ewgxnHBvvAAhfSOPWgOx8TYNlES41va6S2/ZWsX25e41YuG9oCY
	zUpkQS9WvjgmhLPbUoc/LDBFkmbJIAEzlvGijYELVorgHc8xL70GZCD/hYu2sTtu6mjAV3bP790
	xmrwBDBjKq2XOimgKzBFI5MpQ9MxjIF2EWApvrj68DpZfyfQOiLNz0gi2zpySA==
X-Received: by 2002:a05:6820:a516:10b0:71a:fbe2:fca0 with SMTP id 006d021491bc7-71afbe2ffdfmr805254eaf.85.1794849760648;
        Mon, 16 Nov 2026 09:22:40 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-71ab4291ac1sm9184917eaf.3.2026.11.16.09.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 09:22:40 -0800 (PST)
Date: Mon, 16 Nov 2026 09:22:39 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 3/3] mm/vmscan: consolidate promo vs. high watermark
 checks
Message-ID: <avs7i4CqGlEpA4wp@devbig011.atn3.facebook.com>
Mail-Followup-To: SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261113235238.3595412-4-joshua.hahnjy@gmail.com>
 <20261114014917.86531-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114014917.86531-1-sj@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BA5C71C0005
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: d5osgembu5m5z9k7m7qcp4iygnn1x61h
X-HE-Tag: 1794849761-322988
X-HE-Meta: U2FsdGVkX18YNpLok3GerBZMt3+IOBkdzdV2CDZiS47l/+j+YwM5UWaGWR809hjwn096kYpdrSfkRy/4SL0Geq0YMCEeDCHopjd+mhzcTvNOD1qlptwwrvYjcayQJwv2c8un9wU0ed4QCVNzDAwlqstSFfkSChJqcM6y1qV2FPj+iHbWF17CKBCWI89VB4x8sSLotzCOZU1eXGTEyY/M/hhwKI2QhL17R9niDXOteq/b/HidR/iOb7BISTibP6xtbprgbLoY3ZWrDp7fBC11mrm36Xsz5MpzLKYelVUXHxnbefFHtK8S5971PPE0H1zbcrljdpKqvBT5teA5K0ALGJwDYIlqxgfWldXPMId/bBao0J+k6vyMaBPI54khAvESUgFLbsDclT7dxxgagyO+h3cXFgzDfRPirT1qRhiNfypBe0JXYrA+ylQA3L3918tdEEAMr8mW2lGBx44JrDH80eSwpdPQomXAvdDXadjpfzrfyfEZPEadLzG9p8zHyvBogtlX3AGyevMmcaKmGMT5oATesQRDrevZrYH2dOH5QOk/L4BIn7FgVzMgb0gOojLCwdRDJeFCaGe6wzhVZXflBrX66IYmlcUEPLlzJZub1drIXfwx8hySlpbyStYzSR8s9cq4AHcM5NRIY2OUtMuLqoxVSfiE/rc+hNYTk8Q3wbhrxkryBu4xhkpBJpBhe+sUsTGlp481K5gDuKMviu8d3U9jkD3KG7UdEMSc8YZ8cd1gXfXutVqORAaXAtrdAUmnVykJ3XG9VvjKEhKlC4Cc88Vg9WqN+LYcjMF4FkVjzj+v8vluJPPh2/MUB0PA7aTROvbHd+sN7LJYK2hC0BUqb/bES5sbK+GeGYmNVk0Jxy/FHnVyK1eVujp6/M64K1DeNNXA7jEd7FYcGbtQe9Vy2wzYyFocHBI0QHTE7dYJgKBRjeRlUTVDuzgAU8A9OIfFjFiC/4ATovHhuY0Ffu1
 P4tAhr63
 48eUtNkYQ9kUkbPhC2NhspCAV8LT1jTFlJ7ISG8ioC5vwGQslNqJffYzfNequbTU8NhlOH0XSExjrVm8E169cUYwHfE/z4lmZ76zVxFCOQcjjiF9mGpJYuipqOWnRZM/O7aNx2x37H6ZBsivn6krSO1cnwA81oRL2Wjni+yW6RTDoSNZJY6la6kKddyjERzMsdeCU5XrcVN+3klNxVmPEV0onhcMkiQDM04AxDF+zjQ2ICNDtXpmNgjZyvqpc/2yihps5cp8rOTm4PGVx3x4c09qKmqLdKIzDr/ve8q6Gaxfsw5TqFzPhAqWn4OAQRTZGP14OAQPWM/M30cS3hlP9GQXxYn8IMOrJb38GkHaADO3x7eAiekqGrkokd2Gc07LqKY4A7m7IxbLD6ysJV5iPi3kgwtir7f0PEW1bCCC1x7yZyxoKvaUQmQMr7K2GgsoICetjQiO65K9L3nuqL2PXRqfOTshG5HMXDEaeDO8tlELRTI09G7v8jRHCydhxmIrRZ4019FXlxQVe3dMEmNGLapWanlDqSfIxzuNQ1A9TFutKNN0Vg6EAO3aXbgHd8pf6M9xm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 05:49:17PM -0800, SJ Park wrote:
> On Fri, 13 Nov 2026 15:52:36 -0800 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > There are three sites which all check the watermark that kswapd reclaims
> > zones up to, which is the promo watermark when NUMA balancing memory
> > tiering is enabled, and the high watermark otherwise.
> > 
> > Consolidate the patern into a helper function. While at it, remove the
> 
> Nit of nit.  s/patern/pattern/ ?

Thanks for your review on the series, SJ! And yes, thank you for the
catch, totally missed that : -) 

Andrew / David -- could you help me to fix this in the commit message?
I'd be happy to send a new version as well, whichever you prefer!

Thanks! Have a great day SJ,
Joshua

> > include for <linux/sched/sysctl.h> in mm/page_alloc.c now that the
> > dependency on sysctl_numa_balancing_mode has been abstracted into
> > vmscan code.
> > 
> > No functional changes intended.
> 
> Looks good to me.
> 
> > 
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> 
> 
> Thanks,
> SJ
> 
> [...]

