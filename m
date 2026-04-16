Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB965F8D755
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 18:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D6816B00BD; Thu, 16 Apr 2026 14:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AE4E6B00BF; Thu, 16 Apr 2026 14:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C43B6B00C0; Thu, 16 Apr 2026 14:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3B96B00BD
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:47:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3745BC02C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:47:58 +0000 (UTC)
X-FDA: 84665303436.03.5A847EF
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id C9E3F40002
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:47:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OK78HKhr;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776365276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ILOA3s1cbaK/JJIe+EXA1vNnzKgJjP9I4Ap8Gg380Y=;
	b=DVoTxbHDW/IBX2Vm/J7JSPP/kKQqPSWeTtWV6OUu9tzc82NhKyEvgrjPoCrBypBjz6qXUS
	MQblO4UfSAeeQC0S+Btm98+mhXFJLDt4609yUyJ/+bLKhEobrLnCjtTc+3nY9wtjbubEQ/
	Psb1LC8ZJyMG9kE1q6TezrYCufMzP7E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776365276; a=rsa-sha256;
	cv=pass;
	b=p1BwZylbmm6cTze5ZGBBzUCtl/HAA+DDNmwidsAjnZm5ZY6kGSDKiznIQJNQnuq+14Ffrq
	Kc5aTLi0DKpj38xRGxx4iOHNRT+8wfjWXl4dO5rbwE5r9ZzEgtu5VsxIjGpqvr5+HXgKgb
	U+s1gCIPFEKAI7ic9Ttf7PRrhKXKfsA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OK78HKhr;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-671d60ef9c6so4759478a12.2
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:47:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776365275; cv=none;
        d=google.com; s=arc-20240605;
        b=jAFuGvMhpj7QY8XRQSrVNI95py2lHIMGiGMb2bLBNEp6ZaJEPk6h5ld6NNP1z9ObMo
         3tFo44L4qAFCP5Nk7le3JFu2QChqgjfosP3KWJmVOURYBSpttJlqMzRNV0E6VN5G+z5U
         FOV7Kq3IrMxdTbCd/JlqVOtIBUQd/07ZBXUXQxNNUPELwxOH6Rhpi7Rbyc4rRUzE98DR
         bOArblL17VFFAQ2DINGNmIXSvoJBS2m6iRg7bRBAKBgIflXVxXI1/CEZEXldgnKj4g+1
         HlxTidgACRLc5O8DUsMISMB3QW2XdL7cLuSUftMKxJ2Zj8LgBE9Z4YwD/sz4X7O0SEwA
         6nCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=8ILOA3s1cbaK/JJIe+EXA1vNnzKgJjP9I4Ap8Gg380Y=;
        fh=3REOVNzYkQ8+arRUXdGjum57Nfv0U5m/3yka4Z4sNSI=;
        b=TVagzoA7THCPy5z9mucZG84sW9n8J9XNuI+LyZDc27pUBGf8jQ4TlYV+8qX6emxq4H
         X8jNqrdQASQesOgHONoibio2osaRzQxy/rKLjgHpAqj/fE8h7iB0a0QRua5t4orOYRPC
         X+q1ISpuX1/SEpoCMxAsAL83MdY3LCKWPhNHuPfWDruJYtvXxtLtfSG+X4e5Ou3t1s+G
         YJQf3XZSIBjUDQEK0bSgsn89zDAZ5BuAPJtmkfkMQcFFfwbY8AekFESTnWSoOulkEjPq
         gHYDZlOjlLtWcITgM/IWVvkmtM0fptAyqItkvxApFfrgLLP75UFAAxsCUxHNB4BhIUPv
         o36w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776365275; x=1776970075; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8ILOA3s1cbaK/JJIe+EXA1vNnzKgJjP9I4Ap8Gg380Y=;
        b=OK78HKhr4IosJ55rOHaLmjczYD8eiiRQdXFMwkIIqTiW81gcsadiPO+/HcgxKRDP5v
         oijKOoTL+4/1YoaH3JaZrTgK1ZZeSDwk8gzxMyf01IkhzqXpYtxX8ZAErl2VMLkvS4Yh
         7VEsTCLUCqKBlE+9NZr6Jdeq4247M3+eFv+KJRmIL2euhm0UzpxxX881t3KaQM6sSDL/
         BJBi2CUNARhYLWFWVrVspXRs2IWqX8bQCB6/T9PnwyWjltbDQBiEoXfFdTh4VO18GwhW
         oFlvEWCU0Bhraw+472trtTLTBa1gK1FFbgKEW9S3cH/+LcqaWv2xxQkTsR/WiPhqzhBn
         At9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776365275; x=1776970075;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ILOA3s1cbaK/JJIe+EXA1vNnzKgJjP9I4Ap8Gg380Y=;
        b=ktBQpkSe2baMaNnfETM9xbZFa44r9Q5HQbPk0ha3qwATTkDTUlCOCD1U5gmTWrQTaz
         nCibcq2NbgEKq1eFh6Mi47lAIM5vC+e0coAFA3SdgfR53PQWYNWaHudA4vGmLwWInWyQ
         GG9OkYHctfAsC5gqrACjynOy0DYpn6rhxuMz3zJznejfk7NV3MGHYwf2usV47jK0l65h
         GUQE/HUB8YbrJzup2WcM1+ciab3woRIr+2U7D7BjrotuTtTw1B49uDf2s9RgBnyiGOIr
         XTyMXb5qTfiFPYwCh9cKT6ButQ1coIdaIdz9SAxNLKe29qCMAa5IMtH4B/JOtcXoTfv9
         E+8Q==
X-Gm-Message-State: AOJu0YxCEhakOFHijOYdI8apoogfQKxErzegPR5X/M6ArsWSZRCE+B5i
	Moc+90dwZRrKz/wFVgyKfcGQTDVfOIOUryGMY9Jb3M1v3JAiv9pmhlwN3652GYZM3MTpYSVrC6Z
	k9M6jONOXDBOg5+OcCYk+qsc/REPBIBQ=
X-Gm-Gg: AeBDievPGN+2Wum7Y5ikxiyHxwXR5H+Wi88PeylNhpKvwu64/tVEEzCz7v93QwjevLw
	XlgSvECp5jMDiKNU8UXJOdBCdt+a8Gpdz7It8EM2xhw84Za+vvmmIzhwX8axEwkHbN8rcXnlyOk
	H1xGuPD3dSUiOgmuzKc9jLQOTHT/pA0jSbIaTOWnoDrtrXessl7s9c75gsdOqec9J4fH8UOtv5B
	mTAQAGjnU2f+ks6sE3yylxuGiZX/Cnr08jW2/Xljrrq+Njqmj5fbhkxqF8eswYVMttQq6H74r6T
	8BuBb1NFUZid00ADj/lfsibavvzAMznxCjIIgQPynOvtPiv8Lzc=
X-Received: by 2002:a05:6402:5d2:b0:671:a18b:32b8 with SMTP id
 4fb4d7f45d1cf-672bd216a6cmr191416a12.0.1776365274995; Thu, 16 Apr 2026
 11:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com> <20260413-mglru-reclaim-v5-4-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-4-8eaeacbddc44@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 17 Apr 2026 02:47:18 +0800
X-Gm-Features: AQROBzBu_5JMyy9KPWYmIHJAz78L41ZiFiEq9wxTDY-co5QMNWMGiw2GpLBgl4U
Message-ID: <CAMgjq7ArnmmoHOGRt6Wc8hu7tjx_t583-UVzJK+HOHgjjetQ9g@mail.gmail.com>
Subject: Re: [PATCH v5 04/14] mm/mglru: restructure the reclaim loop
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bc8h68bs7k9staadkyexjni7b6ogqkp8
X-Rspam-User: 
X-Rspamd-Queue-Id: C9E3F40002
X-Rspamd-Server: rspam05
X-HE-Tag: 1776365276-119619
X-HE-Meta: U2FsdGVkX18A8XgSn7avK/L7YKnTJsu/VBfNZ8VPBtafcHXLXhH0jBszLDQeOxuPZ70FLSOr13KLhenDpNDjM/OvfX+vJkwrvFY68XuTjzUTvXLYEknXhLVb5mbqJ5ZfZsCTuWz08goKO07RQYNjiL3EQxPIhrVD04yQqTyK0/2I5vR04JH2W3ZKWJxv4UGBgxaabIzP5SD5YSWQdIylcJZrFoxM6aerWA7vL+HGpEcWT7PVnZLpkJl5sGlpLadZVOkuHKiNfF69EUsUqPkmQSk+tYYXss8rdTCJy6sLyUEerS0XfQcugOsU8Xewcl4KYsEwpnao4tggsnsF6OhBWFPremUmUl4o0dBhkE7nqUdZiyoChqgLJi0m6JJc/Z/hvTDVpT6jJZ18YjOS+JPWYnw84L9kVFXXyugz5KhmwzW7+yHCzbBw49xSuFPIC8GbajnRwjI7CgrbJMKgYsGKSJJBo2xwUUdJpuyDMXPWXZQ4LMATMcX79drfTzrX0GqMXcLRl5/fB77e1htvy0lg1lVW1In/pItzoa06AX9ryJ2fuOsRmVSRQQm5oy+oA+SfZUoJfCYPTw382mPUm/I9b2hwLXAoJad54GHA7PI3nyivg7vpn51vE+3Sg9Z1MYwvtFdwGJ47DCRApVl6D92iL7OYfsuzHLzv0pYEbBoRnVGMNgY6g26j7eA84X1oTpjr2caoRrg0JsDgVYR64StTIdFUx9N9HyLowANIhYQjFakX8FXoUZzYOCTRrTLzuPckKxD/y7MyD0kkeuGKY/+qhwXqfA5PoqpJ2GSwgvTVLAeiFph5FifigKh3zJTf3NpsdruXYG1bwN9zF8VyIA/RvXufBmXN92DGXEfm0zcvylO5evZu4ddBnJdkYKiKYBLdqjgoyndcKzgYqXypP+/FITW+FvktTjbZmjWnObITp+6j+3lZxKU5/epJFIg447AlGr9Rst3E1N4evvPtP0a
 N1H75yXX
 E6YkQFErdgDSyij9MutzAaDRvAzJfJNxDzic8TZ6+iiG8pcrWNbGWqQfZH/RLmwDjMOGcXq/5Q4zqC/FuFWN1saeUhRwJJeAp8ku+cdnpU+RDVPzZXIuuEBOXlkwI4UAdIQ4vQ4/EP/iU3TmC9Vhu04QzfVjQOEICjOi94Z8BffZP9uEVVdr39c7HbI1jcKEzKH61hPGIJ/a+zaeHKdJ/XJSrK3QgtWguIroJMXvBGEXT76jbEhYdqxdYfojrPB8BIB5rkZGjpLVZAsUljBnj3FMD5u5LGQM1u/eLd7MUPbTIBHHwQReyAxB4/ldrX1RF1smMNCYHPoHlZp8Ig9A4ZD9ww28bA+FpTY3EkO1o9IlhODcOcw6oZ3p+jCTJ9hWRhfjPUQ7GUeWCHfhOVRRocxZZMZVbEZTfKX/7jEkk+6GotkIFIIEMzc5MDZDRRy5AKJtRSykz5sbNIvsz3+1yGgC24Np3f0blBxe5ZL99mCeBs4abwXm6kTwE4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding a sashiko review, which I think part of it makes sense:

> commit d1c559ae5b78a93fe3aef7c2115b93fc96970a6f
> Author: Kairui Song <kasong@tencent.com>
> mm/mglru: restructure the reclaim loop
> This commit decouples aging and rotation in the MGLRU reclaim loop. It
> calculates the scan number once per reclaim pass and consistently applies
> priority shifting. The behavior for offline memcgs and default priority
> aging is adjusted to make rotation more explicit.
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 963362523782a..d4aaaa62056d9 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> [ ... ]
> > +static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
> > +    struct mem_cgroup *memcg, int swappiness)
> >  {
> [ ... ]
> >  nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
> > + nr_to_scan >>= sc->priority;
> >
> > + if (!nr_to_scan && sc->priority < DEF_PRIORITY)
> > + nr_to_scan = min(evictable, SWAP_CLUSTER_MAX);
> >
> > + return nr_to_scan;
> >  }
> Does the new minimum batch fallback invert proportional memory protection?
> When an unprotected memcg has 1024 evictable pages at priority 10, the
> scan target evaluates to 1 (1024 >> 10) and bypasses the fallback. However,
> a protected memcg of the exact same size has its target floored to
> SWAP_CLUSTER_MAX (32) before shifting. This evaluates to 0 (32 >> 10),
> triggering the fallback and forcing a scan of 32 pages. This results in
> the protected memcg being scanned much more aggressively than the
> unprotected one.

No? This part of the review is not correct.
Proportional memory protection have a much more aggressive
batch fallback. We are already very cautious here.

> >  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
> >  {
> > + bool need_rotate = false;
> >  long nr_batch, nr_to_scan;
> > - unsigned long scanned = 0;
> >  int swappiness = get_swappiness(lruvec, sc);
> > + struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> > +
> > + nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
> > + if (!nr_to_scan)
> > + need_rotate = true;
> >
> > - while (true) {
> > + while (nr_to_scan > 0) {
> Could setting need_rotate for zero scan targets shield small memcgs from
> reclaim?
> If a memcg has fewer than 4096 evictable pages, its scan target at
> DEF_PRIORITY evaluates to 0. Setting need_rotate to true causes shrink_one()
> to return MEMCG_LRU_YOUNG, moving the memcg to the young generation.
> Since subsequent global reclaim passes with higher priorities iterate over
> the old generation, this might completely isolate these small memcgs from
> memory reclaim.

This concern makes sense.

I think the need_rotate = true above can be just dropped then,
it was added due to previous concern that tiny cgroups don't have a
chance to be rotated, but now they might get overly rotated
indeed. Meanwhile now we already have a min batch limit above
when priority < DEF_PRIORITY, and we never do aging (before or
after this patch) at DEF_PRIORITY anyway. So if priority has be
escalated, we will
always enter the reclaim loop and have the chance to do aging / rotation.

Removing this need_rotate for !nr_to_scan looks perfectly fine to me now,
and cleaner than before.

