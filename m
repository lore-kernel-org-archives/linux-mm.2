Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF1210F284E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7766B008C; Fri, 27 Mar 2026 12:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898396B0095; Fri, 27 Mar 2026 12:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786EE6B0096; Fri, 27 Mar 2026 12:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 631F26B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:41:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A42CC2506
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:41:13 +0000 (UTC)
X-FDA: 84592408026.15.8992B65
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3837F40012
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:41:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=IId5fapg;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774629671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FLSnaNJ3FAa1q1EwmjPz3cCYknjkUPu8jB/YLPDI5Y=;
	b=nD8BYJkZPpkAQfAxUrMFwYvrXwt3fa6BNRsw1nnGDV1QPvk9AxUqvTum7SuvwCMTku9uJk
	bojIaSHsc0rRgWgxYKmn5Df6RPSUuEFfBS/fyE/hWFu6k6skKxAmr8y5ORJRvef7f88K6w
	+MBX2knBTwHSVMe4f7M5c+rAkWBzqq8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=IId5fapg;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774629671; a=rsa-sha256;
	cv=none;
	b=wnCXvyrWQFt/uqXXP8HSeT9l8xlMG/tTWshMAStL/bttC+PJiNhvarzY/myxapPGEBgAex
	2bLvcFIjpPEVZWaOlS85TCkR8eksk4TSqbBaIV3BawW95GHhvw+QBaf3A0vHAeZj0eihiW
	jW87lQcciYHQTvY13LneUK5g7NIL33s=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cd7ecedf2cso249632285a.3
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1774629670; x=1775234470; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9FLSnaNJ3FAa1q1EwmjPz3cCYknjkUPu8jB/YLPDI5Y=;
        b=IId5fapgadVFlbdF2Lmsl6tViy86TH5GfC32BrKqFw1rwINWda4j+NdIekOewYuJDh
         XjeZsRpiKQOVCLcmDdJaYiDw0EW3QcDz9N8YEtzX51Ys6rg1GwG0CZilgGwu7QHnTLU0
         OpVhE9WkHbLZyobfX3KXa/FPD6E086bRPBkNqsB+1QelNxuSanfVTR7rscLotKCnuEvt
         IKWA4wZKKJUlGySyfUKNQD/Aynl+mPG1mEW/hQ4QIzUpP0NnmOM9VDlLBxmlkQoqtc+J
         Ngq7k8qFwtOz6ns0xLmIFy4yu2XKSjROaaCwSiWxLsska5TTZ5J5AQXmFDOECbpoZ96j
         wTbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774629670; x=1775234470;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9FLSnaNJ3FAa1q1EwmjPz3cCYknjkUPu8jB/YLPDI5Y=;
        b=WnqxWqK3w6I3469IUW83/EvgtXyk8H3PrkxIjGIilVbRYGoUol3DHb3y4oPsec1KMo
         4rkaLsBemUEG+RGhKnFD/5I5B4mp52EPYXVRStwjGzlB8Ccba/dwnHzKvEX6MGsH6Z2k
         irhogLW/ZGulV9XB8tqaOATKAuUg7227npKRppB38njDdIi/7mQmmxaNtHQ1IDgDmelD
         AiQgHbK5zfYF4D9UiGIREvGTCIbXPaH6gQjUAkRGdHs8Ygt6EbjMLHWHi7SK5LEF5qfz
         QOf49KhPIMxLR5YJzm5fGDxsKkbMmyNKT/DmuKufR23/+VubegibTVzKq+j94oExX20j
         pM6g==
X-Forwarded-Encrypted: i=1; AJvYcCUuAugD/7iYJE7pki86HOV8dbhzq96GNNFZgfzxX6QBVi7DSsoyUAg1Dw8aqoyHTk3d6Tv8YsfE7A==@kvack.org
X-Gm-Message-State: AOJu0YxyXtDKC+qj0Yqm8DoSX4nPyuL0g4/xKYX3fQ12DP7k8TyC4uc/
	88eqyNkdYmnUfAIooZRu6v9+If58EhQPRp3d4tNEs/t31XojpDmH3WZiVe84VH8evLXHkV8PYqa
	Mh3Su
X-Gm-Gg: ATEYQzxwSE0HWqzL24StWRXZojtueILlATsCDknlPLz9TDcO7Bge98w6JgAbNRC0Xkv
	vy4+l9a/ZBbUgj+Ylrc6ke+UWk7sVnPUZnuqQNjXT65mTOtR+V071QQ6U18QlpDaxUXK10pWJU5
	onoKnuPRQvckc0qZBQXqX+BYQEXVfy4HG6rDB9IzYk4ZD3oEoWovwEL3MbM8l9E066xDBFYJ7HL
	jLi8Py4zArxx+/yswH8rvnrXcFsovm8FD9hIkdiXbVV1/GQ0/EQdktLyX03DyzQCyumNLaXxj7y
	pT0ajsxmVlC+Idah/YIcKckYVR9evjhmNpk6g8n/mNxJdf0cPVEtVOWuny9Vq/PxZExHd8Yh4b0
	/Zr8X9321iosZYSwuW4DN4M9Clvd4fgGeiRFiXeUljPu52AMBNDirBV/UNa9d5C2E81FuoR8fuI
	iYKuLD+M5th9uqiLuM6f7JFEn67PhL0fTT
X-Received: by 2002:a05:620a:2991:b0:8cd:87aa:e3e1 with SMTP id af79cd13be357-8d01c685043mr393062085a.29.1774629670031;
        Fri, 27 Mar 2026 09:41:10 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d00e3d656fsm543904185a.17.2026.03.27.09.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 09:41:09 -0700 (PDT)
Date: Fri, 27 Mar 2026 12:41:06 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, mhocko@kernel.org,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	ljs@kernel.org, baohua@kernel.org, kasong@tencent.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1 for
 MGLRU
Message-ID: <acazIi04wEGrKq14@cmpxchg.org>
References: <3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3837F40012
X-Stat-Signature: esajmc6ip3g4dqck4ocq9t1qdrfngf5w
X-Rspam-User: 
X-HE-Tag: 1774629671-392478
X-HE-Meta: U2FsdGVkX1+NZjf+Xn8EAGBpVM9O6s0KcIxzmxhhcDHrvwc5nHhB3cX+++tRrZE9I9xUSfio8hNdR7jIF/0IhM2eFhbzSkv+Zyp3I/P25injczwYDZh2i1N8LfmryKFB9YD4HwrwfFChlO1AeM9GWtjBTmT5yU03lffWokxK49O8VUgRskmCh67L9Yng/tlw3RHMZRs1RUbVTym6azL0lIsgwU2d5xFe9Gjnxx4VBV8MdY7nh4Yx/P56WWuTzFSdDiabeVCyj5MMSeO1Ssm4MIFfoLCDV/qbJfQ4CA4QQXEoaoLGgsiKru24fImQsJ2Je+CSQMzHgUl2O9zAe8mVn9vY08PwCjuyzH0/cctRG36PI8Ig8D9S/5Eg2iREycioXZAIBsEBgZsD5bJAXTccJJGajtoLvNbZQvZxZN2Bfnf9LR57w7GVsCv78oEIYsT81sq51tq2zJlD6xXc6pqgPkgjJbThhQZSwqokiqMaAQpdToFloirZ8yrZYexsqbGqSpv4X/5M06tekCQg3JKabGBJ0p/Za6nVRqEtBK8sylrwRLkZermuKW62NGd26xcDF+hCyyd5isE5It4jzc8Jz93lxFtZcQiXWQ1p8Vkv+f/sKhvM2cB051EWDJJ3N3+FaviAyj8+9qmxTJPiCF/d4Yy7lh7d1aMlcNvnhOhKFiQisRjWOqP04PY8Ic45ISh0S/NMbxgRcM8HeiHXmQ229lOpOaUg+C1qPpWhaXAa1OPvkCftkFUQg4HaRFyOCbfDkO176mhMUExt6nkSI3vnh+gtsHPg8lfDbbBjPajPcrbzRXlm533SZ6nIJu68TIKLLOrJXrUlOMd3OOfKFM1GE5cJGAl7Hbqg/LoYkCKbF48X1q006gjMM13EhRMoSBSPwmYeL8URtXmxjM3hKnxR6ZHlRIfO/TgUk7aWYQmEQ+2iVl+WlQomZTN+nHfzIxqdOUAaSf9cGp8cfO3NIlF
 wZwRmrSH
 HHbLR9vy4Fdlt2S63172tfEOJ2Uqh9igH668RWVKOX0EOqIGko7d0ybi8NvX9GOCjWBjjaoqAL2NzorD0WlpnGLiP2ZEVKpllp+rnGjJBMZqpjKsGos7RScNr0rwseau0dML6XgHG7D5nY9gvSRLY4wNPTR4o+/Wl01ZKXDnWHXY6C1PdTGmoe6BR/mSIkwBqtIoF+Ra6dN78JrO4gECAPito1TwD378gHaz+V2TX6o26kUDZ4vMGOizaABgCGJ4GZIspQTi5hoDDtm2NDtdof9BYvFaWUL1KPDBiQJhBA3SZTHHH8nLVodmYfLksHfMssWwV7zl0N4o+2os3WU8yblzBgrd7V6tht6EXpn49WRli13zyB4LLg56mWK2AAHRiSNr+VazJKOIqCbSBI6Got+zfvzDh5N42X0g6/oYik/ppzooEowMvKiYIPXKv/oQeQUwoDHChuGPe/Vi9NUV5brknfAnS69+RtoOwNiEj1x2YwITugU2LPusNH4HJR/8m8+xTEivFGmek+as=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 06:21:08PM +0800, Baolin Wang wrote:
> The balance_dirty_pages() won't do the dirty folios throttling on cgroupv1.
> See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
> on traditional hierarchies").
> 
> Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
> longer attempt to write back filesystem folios through reclaim.
> 
> On large memory systems, the flusher may not be able to write back quickly
> enough. Consequently, MGLRU will encounter many folios that are already
> under writeback. Since we cannot reclaim these dirty folios, the system
> may run out of memory and trigger the OOM killer.
> 
> Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
> which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
> pages throttling on cgroup v1"), to avoid unnecessary OOM.

This fix for cgroup1 makes sense to me. For cgroup2, MGLRU shares the
shrink_node() reclaim throttling.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

The remaining notable difference is global reclaim. I don't see any
equivalent throttling in the lru_gen_shrink_node() path. What prevents
premature OOMs at the system level?

