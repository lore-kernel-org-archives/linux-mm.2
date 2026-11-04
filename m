Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 816CD606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jz1Caecd
Received: by kanga.kvack.org (Postfix)
	id 9F8916B00EF; Wed,  4 Nov 2026 17:42:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D0026B05B0; Wed,  4 Nov 2026 17:42:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BEC96B05B1; Wed,  4 Nov 2026 17:42:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F39E6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:42:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05C4340866
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:42:00 +0000 (UTC)
X-FDA: 85398910842.23.A994E22
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5F8482000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:42:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jz1Caecd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793832119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JJZFX7GjlSxlyM1xt2ZPMCBId8gHLPODjL1RlXKQBc=;
	b=lZ+eMjw6cHb6vvCl5Qyj3rCqiEMTaGSahU0F3F0XsWL/h8/RHV7HcZuvxleMnT4begXz9F
	C4fxZfuNn/pDfpPuJUt3LD7L8rxqqICJ/JKDsn7IwFBkYiV0Sh8GIS0xQrL7M06lo+lDzm
	9xqVgidvYDjPg+6bINwqcxwtqBmVJDU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jz1Caecd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793832119;
	b=Dv+MiG6EB1rS+JfE+cG8KHYibbjOIPYnIIsk5QRp74/se2sDf2NCC6TKAASOBdwMJ/wPZH
	zWp2QVlQq2z3VCfaYnspYF6BQBG8BpkH1Wbp3GHC9iKuBh77b1Xb8lVjslZ5rAwsnFb6t1
	cCB4dCl7h36Q96pkqcptgZ1YgUWm4iI=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so9990265e9.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 14:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793832118; x=1794436918; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7JJZFX7GjlSxlyM1xt2ZPMCBId8gHLPODjL1RlXKQBc=;
        b=jz1CaecdudQ/DRcy/vaKp6a4Nt3CL6Y2Ld/DdJFj/d3mr2npfkWaSA/6yGGS3xBqOE
         rkGPJZ0cpOAlGjbPG2nBmMmRhun2wvvkA2iSvbuHvFkENCbDpPUiGQyRCCmmn3/agWh6
         asBGeMLVQwmz+MTEDSajpr1S0PXFEWDGo3Gn/r73IubsSvdC+HCU3x/6CDSns8ifiL0S
         QcuL8ahh98w3qbkG9fjDyVgTYELv4v4EBD6VgEleJPXwpL0hFsbhXZD2iEXZ3gfn1odG
         MNCr5LUikTrsnYzOgBgS5eBWQSHryfguhsynw2hqdemsg3XuC2mPpFVE06AzIGHzhY0Y
         6p5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793832118; x=1794436918;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7JJZFX7GjlSxlyM1xt2ZPMCBId8gHLPODjL1RlXKQBc=;
        b=nNbeS+Of1V42IVCkYeqQxu0iwoPhPCDx7zxox2TgPro1bScTLFL//SkOZph76Y1ydG
         TIToZD5PpLgoivGUcr8LMoLUiKVoTths523fgrKbb+LhB2IwdAdbHar8RPNkBi7rEagn
         ryMNYKjXRVJbvuG+GxmMS8Fbm0iOWMrzKkyoh/clqsXcxnQliq1hsV5GWmVbqJqtrT+D
         Gr/SEkux50aIOz0IxBh/5wciTrnooqr8s40m7oFmMDxKxOFzyRRhS1FzyB3VFY1NBHZa
         PIm2+AYO4cXwLU+1e93SR5SphHKjqKkUlvZoTLwi1gyWJYiWvMaSyjWalz/q/R3kUXsb
         KvZw==
X-Forwarded-Encrypted: i=1; AKwUvBxJnzAH/wWcfiC8NhnCD/BTIZNszMivdkGC9h5NBRJpTqh3in82IR5Z/0uxpU9/GsD1YzNqSx6EoA==@kvack.org
X-Gm-Message-State: APuU4Z+M9de37bs7f4w8BVaGw0m5TDnnbpoVlwTjRizyTWA7WDXwDKm9
	0rmLDS+jdXTK9DqLOPuQtq+wBgznC4pkVZgtJHyPlFiNmE0IlTh83yXe
X-Gm-Gg: AYBFou0+2DhnWJ8F2hFP8cZivF7djxJ2AKfCgVqsJ3mxgm9fpYI63kglnQqRP1VqSct
	8xm0U83mm4hOKwJwHGkAIRSwu5eu8YRaX+iZQXWSfNGjHWjIJhNY3YcrpHHlAp1k5AQNyCzXv5I
	FQf7bDnTfRYbj6BBzSGCF7/9Z9DBb8uAEIR5ZoW3OXPvT+McVkIq4KO8PZeFaDKtdrS0xu26mXI
	PSNX0SV9RZKub7V3j+AWre2Hc6HbEegKcGHr2ZfX3V/vmZ8MuPwbd6EWH3K2/S3zea3DG3Q797L
	H3SzXjOxfpc6Obj23dll8ePrbDhDoB0MHnknW/MYTrB0l8YE0nwlhbl3mZF/exwLQC9mukKglut
	u58ueHganneKLIPweC2JuJhr9wqtoK04LV8EuyZIXLquRFi2mkcLTEoHk29RBDIKocByWM7QdIg
	YvsEshMNdY3gaCFrajJzPrClktIBBJZUGxKKLgroE6Qa7sh25ASWmryXzmpPOA7wwdeRMoJL3Sn
	IfsUDtaRdSgNWvNioMFOCmfbTH5MRttbvCzb3XpLEPmN6odpte07MoxJO+2lFCPF48SfhL7TZee
	lxLZ/zfhmYVktnTdolbOVH4=
X-Received: by 2002:a05:600c:4e50:b0:4a9:2a92:231f with SMTP id 5b1f17b1804b1-4ac16bc461emr393154585e9.7.1793832117676;
        Wed, 04 Nov 2026 14:41:57 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed551dbasm6018773f8f.37.2026.11.04.14.41.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 14:41:57 -0800 (PST)
Message-ID: <d4b5e996-e718-452c-afa9-e9d9e08712c2@gmail.com>
Date: Wed, 4 Nov 2026 23:41:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: split out memory-failure declarations from internal.h
To: Breno Leitao <leitao@debian.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, kernel-team@meta.com
References: <20261104-memory-failure-split-v1-1-3b0a85f0b7e7@debian.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261104-memory-failure-split-v1-1-3b0a85f0b7e7@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5F8482000B
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: nckrqmnbz7ejfo8fe6f1r9u1hd85zpn6
X-HE-Tag: 1793832120-75483
X-HE-Meta: U2FsdGVkX19uuVXZdKWNiGoqTD+yzDm5ojoiv5OovRV7DvhZdr9VIkh+HuJjjcnyIwNe/BSbYYAle7R4FqR9n0u4Au4PAVE35FuKAf1KkX4VVDXpYyC2AjvwoyfGhfOAq1GV0kPiFhtVm30GGtbzSuxj4hbA6MIfh2u/+5jGEHHNzOKasUQhMEFEARhp8HlGgSjOdnvdnjEx8DKhAmLDehpf7P1Qh0SCff0t0StV61BLejQaWiqEYLE4i7qjrbbelnZtE9CwEEpZvciolCEIg6/9d6vTLnM8/EVQS/FYt3FN+UWzsAnYTKpI3IvWNm+1TXhEruHUmCaKBF2MRuKr0h2wi8PkZthESHCSa+B5Bz+1mv6gS4mtUmCSmczy7WywGP7LC4dXSySx0glvQie4Izi8kcg/soq+bcPa48uMW32/TvVflqRWLEeWsMK6FtBRSsflXo81/89qHMJMCs2Sj1OWElvz65bnPIjNgGVcsB6G9STo3vu1o/L+MQuU2+5o2R1X59Koo+0Jf56OmjA4+AatDCX5Agvebnag85RZMQY/3TMK+mPO+WzOdyckgk+EahaXU3qNFSy230opJlY3XMSh/wtH9JcLVlz9QlUybJkMzRVsx08vsCMlh4w7otGRN47b+Ceu6kk9aMSqEUiz2x4DXW14vpoAZ5Crp156YzFrIgSHBLbKKaB3WI/IyoqqJRnkSDE/QBdYYIzfAHqvhWKG7BnKZbQX9eTzjNyAOtmvtlmzwXSVWMnU6xrb06Mg3SsKkHmKJzmeA2b+LE89Dvf2HAkhzH1wK+NGwo7HM85pt32gHXG/mIznXd2FYMqUxiin3OuHvf/KvGzC+LjOBphQx1dY4cZEQuG/to1Hgjc89iCDg2BikrEjeZrKd32ScoYttbULubR9D89aAbnjv85kR2coPRM6ap3Zi1Wu9dHCuXkiyU30TkUb5pVPPqNM8Sfos4D/r6Q+wV7BMzD
 cdbekeFU
 1pQpsGZbfEYFUBazMeE57/Vp6us8mvmam6utYMK9iTcxf1sgzfLsvROB1QKoEkBk4/BkLadN0dWhqj6DzZxj+Z1/cmSYkRYOzj6syDBqtseDDzigg9k0QpOkrunxoKfIduTTxxkC7dCQqRUbKsS1k80VBZxjE4BnfF3+X5nGNlHrbYqUm38ZNWYI2mIOB03SQBmWggAJAEs0eovVOQ33n5v6LecEG/qtrcqAng1BUNc5d4U/ewp4950LzXORZQ3XRE0lKUmt5SPAVQOODsIh2Su/luwA8UFmmRVHsjj3B0OoHeKuUclkkBa+JAKZyzv035Qb8zWwRXGDK0k3ZhHjTDXPdWBU9CYl7PAxWw/nodwAyGMHceXS7h8wMlg6pn4JbZuOeubGi6Kv4ygKQnFQaxms+skBw1tGvw2RuT24bMJxwaSrEmN+ROOtYZbBeRvdERjh2oQafnzgT/n86kzoaemoxnlVzIx5O1vBJqGgen+Sj8Uvyo2GcP7ehHZ7bifZwLlo5er0aoaZyAkRCg3nxA2isDV/vDKvQRlYwhlhw2ek1SxLpmKM1DTRT3v4JENthj+Daqo20tKN5KMA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 5:45 PM, Breno Leitao wrote:
> mm/internal.h carries the memory failure declarations, but only seven
> of the 81 .c files that include it use them.
> 
> Move memory failure declarations to a new mm/memory-failure.h and
> include that from those seven files that need them.
> 
> Move the block as is, including take_page_off_buddy(),
> put_page_back_buddy() and page_mapped_in_vma(): they live in
> page_alloc.c and page_vma_mapped.c, but are built only for
> CONFIG_MEMORY_FAILURE and called only from memory-failure.c.
> 
> Keep the declarations private to mm/.
> 
> No functional change.
> 
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Link: https://lore.kernel.org/all/aumt-4kfGGtoXuh-@kernel.org/
> Signed-off-by: Breno Leitao <leitao@debian.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

