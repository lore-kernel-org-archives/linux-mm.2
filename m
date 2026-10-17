Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36414CCF2CF
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 19:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C9116B0088; Sat, 17 Oct 2026 15:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 152C96B008A; Sat, 17 Oct 2026 15:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01ABA6B008C; Sat, 17 Oct 2026 15:07:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CCDD06B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:07:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46D52C02DF
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:07:38 +0000 (UTC)
X-FDA: 85333052196.07.B767CE1
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5E2DC80007
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:07:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NS6BCoY+;
	spf=pass (imf02.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792264056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+E8a2PvgIUCT1IDNK7mru3JGGIez7qd+preTii2J3LQ=;
	b=5pe1jtBX0aLCnVlryVaU+FZl3ekoSWj+r4teOJ0Dr8wKDvvtl33LjnWqBXJgP2wojS+1k0
	aTd+bLc9z2z9wL2CnBt+vDtl8wMY7/pbhm1sAnMVpzjNhzHRUvFgze9gvyInKWRWK/PV+p
	W67g00DkMKVk832Pq8WPl117E7GoZHY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792264056;
	b=kUIPl3oHxRYTsnk44Np/BIb0l5PaHzvuhiGn9huqaPJ0liK9Ml5Ub2/2yYyk19mXwDdtO3
	tzyoJxGeSoL/MfpGfEt1LunXBT0FwkgCCI7Vqc077SMaV1TB5K4jAj71Y8YOapBQoggCPV
	90VN6CnegocB9q64cjZmAfoB3Qz7XEw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NS6BCoY+;
	spf=pass (imf02.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48e0d1da913so373357f8f.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792264055; x=1792868855; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+E8a2PvgIUCT1IDNK7mru3JGGIez7qd+preTii2J3LQ=;
        b=NS6BCoY+bp/Hao7dVO8B5Zk9wBeBP3kG7qd72lkAdxuOQzlz/mhRB+Zh1mDbF+N3We
         uyIWr5B2JSMVTuH/ZBnjx0A3kly+oBGu3SIxwoaCfvHyVhQjUejTLQ8yD7ZXfJNRcH6Q
         7esV7POinJqFElbTd7X9usXODEuVV6W2orhjoSOFGG/D5WoU0dMrazmSO2Sx/JdxrAT4
         5VeO4EXLPv3WO8Il+1/rpDd7RKmydeHHYvAtacnJnVo9XBeNMZH3y7iLhWo2oBBklBXR
         hixzaXAS6W9sNBVzOYTiVchtyPmB7XYTh6BvK/b7kQRC3JPR3ZFCQx2CvXxYP/z3kynr
         hEbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792264055; x=1792868855;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+E8a2PvgIUCT1IDNK7mru3JGGIez7qd+preTii2J3LQ=;
        b=B09GxJJlWapPa06sokB7su2MpycQrb0zTanRIke85Ivib0bnbo7jUTemdC4OM6bC7z
         Y1fpEZGHqb0sCkvGTZZWYSKatv4bVN8TAez5w/1/jja1MaS5YGkaANQJAHWwS0ZTj+AV
         mHbHWUmNgMByP9owUxrv+PV4zGMG1wIlruoN6LK+JiiYthfykgLBq7K/zVIIaRzkqbff
         r7jPUPuWMjri+4V22P8o1LEOtIX22vyi+XezAEAkIWLlF4QW68LlGzUNPWMF06jFLiAL
         s/B2fW3Ei/Cf0T0/L3rsWbK+pR8Nw+/r1n/0Es8khEHYbghuHi9y16Q4WUG5oTwqd3Pb
         adHA==
X-Gm-Message-State: AFq9FYI9Az98W7PiZ0Stu0nyRUj4a8div2FcVf5WR5Zt4wb7vaLoKxe7
	2eJTMeB3AKI9GPh2rbmkvCAQmEyZGf1eyEQQ1l4ZHtn6cIydyOJNkQvF
X-Gm-Gg: AYBFou0GwFqXMCzjvGirfI3+j1S/DIBeJMlMv3L5ZzTZPDU0k7sGtBya9INrzKVeFqg
	xsco3ac9AKbzN2Ts9ao9vyv0iewNYPsAfP2LYfdz/8xHnoLnEMVkRxiCecGHYnQ5hPeVHeXRk+X
	haLYJoHcVVmIQOu6aQixcC/gQUDJw0BtO8RWxOYCS8lOQyJp4rc04RPlW00SkFztUmsWOjUNATq
	X3kcwRAJ+0ellBiaAKB5jGkIu7f2MHYuG/X4i7ra0+df3cb7BsWL9+vwFsZ/jhk7uejdWqvACbR
	QUeQloVM/r8TPoAZq0hMHIXdTNXCy15AfJg3fJUpzIvJpByl8qFc+bBt6GJtdzAfri1fRZBPI9R
	zghB7/oyw1aDoOxqoqQkyRSyT3UB1OlZHZzMq9tTald4QVYT2rog1oqsIvKucdHBvbRb5AQV0ll
	QlKsfPWOL4AbyfPBLrrMw2qhRS4Qwpxxe4iQGJtrVQorBkB/fqUhz5VeMFhMkFvfZ2tqg=
X-Received: by 2002:a5d:5d08:0:b0:48d:efcb:1fea with SMTP id ffacd0b85a97d-48e07911cf3mr7339685f8f.0.1792264054717;
        Sat, 17 Oct 2026 12:07:34 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4ee183sm12491778f8f.29.2026.10.17.12.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2026 12:07:33 -0700 (PDT)
Message-ID: <ddb1e84f-2cfc-4a99-85c4-9a8c6415dbb1@gmail.com>
Date: Sat, 17 Oct 2026 21:07:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm: hugetlb: enable CMA allocation for PMD-sized
 pages
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
 <df6eee954b62f41d65c4d087d17a7a7cf60da791.1792136742.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <df6eee954b62f41d65c4d087d17a7a7cf60da791.1792136742.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6wp944f5gdm4bhm46h5c8ghtiq7hhdou
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E2DC80007
X-Rspamd-Server: rspam10
X-HE-Tag: 1792264056-435044
X-HE-Meta: U2FsdGVkX1/X5bCkIjAq/oLyYO/uGnil39xrUO3WyNQUsV6llv4MeKcjfk04EVoQ7udFtUTnQ53Hh23mwhPjBNqtX9Ee5qwyzpH4jsxb5UHYUbswdK063KITrGZF5gZK3uGxW3XI1rGbuk9d2wT/OB3UxjvW/0/rnqarlbFw8uquZ3priSMO6r71GIHE8/IxR3znSLyv3lwVGawJ2N8paeHiELME2/ot5gFniLNbdIpadiQDAZhcuSuoFI2TbvPTVO04sUD7PhtkFwbMaNlSfqr/K/94kC+Jl47vAVxasLE/a/XmwFg0DURMC74ci3Oyp3bKRmUF20Dl9N78XOu+2Bm52wdtLWqh36WkoI9/wUzPzxA9Ey2EdiyqhcHhGy5gNrAnBNs7l4tuIw/J2JPBkQVIaeYG04w3sVT/77ddBW7PM9f9pmwd7scUsWyvoRyWeQETuAlHazQgLjjSWZCe3mulRqDmOTqdMW4Wnm+kPLCtQ0TeaTPrlyhfKVqrT9YuyzEsTS50vV4RHn2Q+kiFx+gZafyO6fDW3nhxlH3fAZUl7OE3o4LMBUdykycK/Jx2eDT8ZjeS9Q/4yYMi+pgAT6z/tLgcztGiWM28ZRmv8Dirz8NvwfUt4/4S4eXRPlR6u2lVRxf5KEyBzTea93FVmXR4LKsaxlcdqwgWaHlmBJUeP87jGSA/TKbgZq52ItTAqIBZLFXIB3T35AouMPmdxgOGU3q+Lt+UvOOkDRIN3P1gGIIPG5Mus+TciLHj3udUhrFCVp8Lt+HDbDyXUQjnxzvEPu9k1WPaT9MIutcn4kGhL2R/VSefJDrJYT+YKwO9KH84v+tJRl8R/vT1jdOmgWGqsGcuVZa9mJ+IEKUfonS2k06udWiYcBAFauH7A4D2lfd/pgzA6eD/OEY2sYZ+YNCkPPZyv1048u1IMkkCZYCVcDDGxqZP042SaezQ7AyxOHCoy8tgjlflJAq8v5N
 0wQWNtT3
 RYOqD9dCi/q2TzJIym6heFGpXF4S2hW1xKrF9Vg0phiwlCO02CyFUYVEe+40hTh2brAcNqLDLN6HPKf0JFTuFdVsXvcgveuSXw2lRaaLq79asu4BJFthhfzjdaqVxF4WTNYSt56cykJqnrsTH/oPhSi1EEturebpw8MiOAuma+1/9Se5dUmVWJSTKtAV7EAQWB28qtmpl/huGYTEYXwzspJ/T3coKL408QyUVApFJxrQUj3TZx3jBV99wKJEkv1hmJ1bxb8cq1J2XZtVISmoF9XgvfcLOf+lFDalnL2V3iHgCcDBfe0u5+J5hW1MpXjZ/8WmO3bXAZ2Urom1a8/nFI+dd3vllcPy2lVJk59O31FThgdLsnValJutMgpUKgsQ/UOW0Ql6czNlsYpnCG+KbGSC5GIpQRwbjwYc7WtESGSGwYeNryabOpLF2xxI2Q9LMg3OkSx6YFzTqwnFTZOVefUu6sIapZuSL3h1Ph+kyW1HWazPFKpRSis8s0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/26 12:07 PM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Allow hugetlb_cma=<capacity>@<page-size> to select the architecture's PMD
> size in addition to its existing CMA size. PMD pages are 2M on x86-64 and
> 2M, 32M or 512M on arm64 with 4K, 16K or 64K base pages.
> 
> Give PMD pages their own pool without changing the original pool's sharing
> among other gigantic sizes. On arm64 with 4K base pages, 32M and 1G pages
> continue to use the default 1G-aligned pool. Unsuffixed arguments and an
> explicit default size still configure that same pool.
> 
> PMD requests use only the PMD pool, even when their order is gigantic.
> Other gigantic requests use only the original pool. Apply this mapping
> consistently to allocation, CMA-only policy and boot-time accounting.
> 
> Move CMA allocation into the common fresh HugeTLB allocation path so
> non-gigantic pages can use CMA. Align reservations to both the selected
> page size and CMA's minimum alignment, and use a bitmap granularity no
> larger than the selected order. Keep the original CMA area names and give
> PMD areas distinct names. Document the syntax and pool selection.
> 
> Assisted-by: LLM
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

[snip]

> +	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nmask);
> +	if (!folio) {

boot-time hugepages= goes through here too, so hugepages=128 with
hugetlb_cma=512M@2M already uses half of the pool at boot. would buddy
first and cma as fallback make more sense for PMD?

[snip]

> +	if (order != PMD_SHIFT - PAGE_SHIFT && order_is_gigantic(order))
>  		order = hugetlb_cma_default_order;

doesn't this take gigantic PMD-order pages out of the default pool even
when no PMD pool is set? would trying the exact order first and then
falling back to the default pool work?

I tested it on qemu and saw no issues, but I'm hesitant about the points
above. I can give a Tested-by tag on the next version :)

-- 
cheers,
jose a. p-a

