Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 334B6C55174
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 12:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B76C86B00B6; Sat,  8 Aug 2026 08:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A7E6B00B7; Sat,  8 Aug 2026 08:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE886B00B8; Sat,  8 Aug 2026 08:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 731966B00B6
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 08:09:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0BFD71A0362
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 12:09:54 +0000 (UTC)
X-FDA: 85077983508.28.5F582CA
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 40C89180008
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 12:09:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jw9tlMwC;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786190992;
	b=QE/H8BGDUDjyLCG8Cn0/lSfBnOXdyEKVdvA+50eJgJpN1EFxPTXBBaeTvsKILKNSkKuk6+
	CDAhzeiuJ9w7NDn8j/2mOLe+Yhwo43oSZsw1IYlIQFJqN3ufRsvkxNK4vQrViulrZ/DNUY
	BbTsNInYPUI6kuIjrtSGl3k69s6cCtk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jw9tlMwC;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786190992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtdtzXvGEBVmzPjM10Nks6+mSpQf5NRA60Z5gDD36Zk=;
	b=WKUMkYhVjaGBzzM/+j9iCNW4kJ4tMffWOjOrNDNLbu/XRVgVyUubjQ1ATg06nlFdDVfa+6
	mck7GFqvtDzchLwwgpqdGwJ20+gmZZKFek9t73P9Dla3514+ztXNQrwNRTzkAaNhyctwsl
	HX4kpa+2EKpb+BG6CoYBlkkGeadMmSI=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84847482584so272122b3a.0
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 05:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786190991; x=1786795791; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gtdtzXvGEBVmzPjM10Nks6+mSpQf5NRA60Z5gDD36Zk=;
        b=jw9tlMwCl82D40k1qWAriaEJr3j/HxiwZzB9GKCUM9IX9+C53o0KqtET2AbvwWFZYb
         luJ/beRg9df/JnRiAwRcOqLLgu6O9CaUbXEMGwe41VUsTvPzwQJoMlInxo/4kkEwZJFy
         KzHx5G16x0I1q2DeTbzcl4TyKstqjCEiCjU6eF2KqqNU5mN7NOw0YN0Co8YAnQRBdh8h
         W6yQ+9hSqX4YcR6J6w8p6pmhwZ5+hgTVXPL4DgO3c+zTFQ2BrKxLjwCy7PGpjL+EzTdY
         BbOlXUNRbalVOpu5zLHNHnZf4Tu0MlZ2j5/9KezMjIUXa5syR2b/CuY56c9K+wSptX/E
         TQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786190991; x=1786795791;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gtdtzXvGEBVmzPjM10Nks6+mSpQf5NRA60Z5gDD36Zk=;
        b=AfHLrT1jZiAengBSORFGb9ueJfIhNxNoc9V6E7mJiYlhlnM8M2j3oaLS1NjhBQtKLt
         mCHdJlabS7vljxwkw9IXub5qegwnE7H+T0CctkCfQhJpoK3BmfqawDEyHZXG6VGid+L5
         MwWZ0FZjUsiNck7feKkNXYdwrb89QrpwfNIWOl64krFsL2gGTZ+0MM8HwfTcSF+4hhbT
         DJOUXkLqGJT2M5DzF8iq5MQ/xZLq30oFdkvH6amEuShqUYQdgFtBEhno5YbLBeTyjYX0
         KNRbRYQmTTr/gNWLw3xdDucdmX8ziS2UXHUXLOs5j8G4JR/96I25DlLBR0lUTZz+4vau
         VV8Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqh76wnr+oTGIu54r70UdcuFb1Xpe9j/LaDMLHUrBZ4EuQAmIv+uEsnqZcFi/WjApPi5WsEiAoztQ==@kvack.org
X-Gm-Message-State: AOJu0YxO7Ty8e/+IyUCGhteq5IFSMWfbnlLo3XIVGBBEtICTQob+cHQO
	CXPsHBT18+IgHvjgJgYgHirU2i7atyHYJKTyBCQIw4HGre+Y71rGWHCR
X-Gm-Gg: AR+sD11AhGR9XhhD19fMrxMoWReyCUHh9fxCy5kSakTWp6TPsCc3bgUX01m56Rh+sH8
	j12JxqF4rYGUCM7KdOIovVDTTB/vlcu/7ZsRNnhOCnduiWQ+Gej22+QNV2TFHtJMTH1Tu6gRTu3
	MjF6d6jPE0kPAElQTdJAtkhuzSGc4zX7D7uOc3LGudgS1V8TbIjgYysq6lLpeei1JNOqwRW+GZg
	uBXmAi4pSORkC92kT3/rZJsPsBGVkc12/2JHERtxn3wzQ2NCPOrYl3hw5trBFbnZEwLKeapvpb/
	faJSKZCjG1pumQn2FDvW2VHKXVyBT+6XpMha82ZvIbT0yBL2HWPeqdO9dHLHcApa4nTydvbOkDS
	daSIcsBQ1tAJ199eMN8fGRj4J4T8N/kO5g4jakpgkrkIV14hPofwW+7ol27ex1dW1U/KSWVemA+
	P8z4Nz/HNVufMLuRvrrwJ2a3aNluOAhuL7tMlW0msTo1C6Ix1MI5aAGWHuh3a50Z5+7ND97Y51h
	XDA/J2CrC99C8J/Ojtl46Qe
X-Received: by 2002:a05:6a00:c0ce:20b0:84f:72f7:de58 with SMTP id d2e1a72fcca58-84f72f7e7cemr1924485b3a.17.1786190990918;
        Sat, 08 Aug 2026 05:09:50 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f5a589592sm2097842b3a.51.2026.08.08.05.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 05:09:50 -0700 (PDT)
Date: Sat, 8 Aug 2026 20:09:44 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Jianyue Wu <wujianyue000@gmail.com>, her0gyugyu@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm, swap: don't free a hibernation slot that is in
 the swap cache
Message-ID: <ancWz-4R93dnNOXn@KASONG-MC4>
References: <20260806190636.446205-1-youngjun.park@lge.com>
 <20260806190636.446205-2-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806190636.446205-2-youngjun.park@lge.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 40C89180008
X-Stat-Signature: f3519r4y18zumq9r7j13z46mooy5p635
X-Rspam-User: 
X-HE-Tag: 1786190992-436954
X-HE-Meta: U2FsdGVkX19qbqWOxD98U7jGJEUuhdXUfDa4YFWbn++hOOh4zx9IPOeFp8p4zhq8wLkB8BouTvVwxWwTA9Ec+nXPIhCKnDKDm4gohM5LvS7hgM6vm4eaB6i7c9HuNCN2DwKsxMmrDGUq/UE1QyfYkveGvJEq/y4sYWCuRn9MMflAByXrqKpFXjd4pYKWe3pBQR+mxkvT2Eb0EQ2ozpyCzFuU82AgJ+6qqqorD/1tvFKzK+qF1H1AJP+WDTJrMcQEz+UwsN+EBL4UG4V7ZnqPDpfDAiX2fV+hJey7ZZn84GmjNI9zk8bxa2ol0KoqqDv/y7Eu9w915jqGL6la5hUONXgND3fF0UEqmM9aihmU+8DDlo7sQ+Mt68Mk1LC2S3fbMk1QbEQIMVY8M6XLYsw7UfoM7fdVcBs5DFQCSTQx1A6PU4mhIbk67yJBSRcSGicaJB2O6Umk5l51jOSZzPgIACAognnYH+emR3gogpF/sMEuRfVo7SunimWcpVQwkVLUqJFpgPGg2tY/p6A/+MZCwjXjjlVe9nx6gSvCOEBplo6SDCik5l4CD9w+0xP9DT2WTYhDv/ITCXqFvvZGdL6AZMDPEccA45w9mwMcHKeIEG86X4UWbaOX/AHDndOs5gUmt5R5uUUhm9ht+lOJPhl9iJPoqf8kI3//RVEdIb3KWwgV9eyYCbnePSf3fPaN0KyladMTM+lGTqZHezdk42YcwK3Oi1arw2FDmMR5Z/ZRhzsqSbATpSQ5N7LC5Vdb2hsBLqeSEEG+l4FjPjYesRu2Elt/Gbx3JC5fe9eF+WYbSbq9WVDYC1fG5yfDg6AqODiXd9BRfXko+8NbFxfoshw97PYLG0BqSCqioTO7c4gK5oE3drXz06YIaFdeT8DYuTz12Refnueb1WQKNHv4y4wQ3WI6obImfIWoUqbeCMKDwE1TEat2KKz97y5GfWfwwdNCmfnk9SEJ3q8hA89wf2b
 vkIl5pyx
 wB+DpL4H08qYhN5M4lMBB3EavUqQHwMmftPJLoe1NlSbaEfzfw7DHqydnYk3kU6FPlwWJgURexggqFlrLxtEd2Sm/NxNcK4KytQx4VXv0w4GYbgXcwkV9Q3yIehpFPuhglkRDcObH1Z3DakFQ/Fp2fYPEb1uhtn78ffQ7s3wARd9WLuNYwbi0odl7JfMy0brr85886CTmvNGp0kMpVr/Cln5I0Go1x0T3mV5rnVrN6VWxyvsbjTRN3YsVC06b5MVbmFFmOpHADf1cWFvvjRHeRbBHkdlaNitaRLB2D2RM8+ASjnO4eaWK8/OvZUHJvL5aHYHg/HD0/ZuVXUqYBvrNqZ9bjtfE9N0Lnc9eSKnVMXS1XyBMD5y4i1jgvBQmaElc571EqORm1F+YRc1+oBNbMlw2NLhkRSJJkZm8LqBCtxspFBIjsScJ5BGL+deAC8xUCZZiQaTTxbldCJbED+fQGntgQyrGkt4DzOTi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 04:06:33AM +0800, Youngjun Park wrote:
> A slot with a folio in the swap cache is freed when the folio leaves the
> cache, not when its count drops.  swap_put_entries_cluster() follows that
> rule.  swap_free_hibernation_slot() does not, it calls
> __swap_cluster_free_entries() whether or not a folio sits on the slot.
> 
> Cluster readahead can put one there.  It walks a raw page_cluster sized
> window of offsets around the faulting entry, and a hibernation slot passes
> __swap_cache_add_check() because it is not a folio and its count is not
> zero.  Freeing the slot then clears the entry under that folio.
> 
> The folio is now unreachable from the swap table, and the offset goes back
> to the allocator.  The folio is still on the LRU though, so reclaim can
> pick it up later.  It then takes the old offset out of folio->swap and
> overwrites the table entry there, which by then may belong to someone else.
> 
> Check for a cached folio before freeing.  The slot is then left in the
> ordinary state where only the swap cache holds it, and it is freed when the
> folio leaves the cache, either through the reclaim below or through normal
> reclaim later.
> 
> Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Hi Youngjun,

Thanks a lot for looking into the hibernation issue, I've been thinking
about using a exclusive type for it, glad to see actual code for it :)

And this patch looks good to me, nice catch!

Acked-by: Kairui Song <kasong@tencent.com>

