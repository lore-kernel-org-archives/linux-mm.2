Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D73606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pFy862fA
Received: by kanga.kvack.org (Postfix)
	id 5E2F06B05B2; Thu,  5 Nov 2026 06:28:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5928A6B05B3; Thu,  5 Nov 2026 06:28:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484936B05B4; Thu,  5 Nov 2026 06:28:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2ACCD6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:28:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21FD012096C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:28:11 +0000 (UTC)
X-FDA: 85400841582.02.C830F4C
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3FC011A000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:28:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pFy862fA;
	spf=pass (imf19.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793878089;
	b=WWwII1t75FMwQ5H4USdHvmmhniUPbmcHZftSR4m6FgBSxzUrvF1dVqSzvuQ6um0CdtNZz5
	g8HfCwBM65CYlh9iYNb5fHMFsz+6pc41jQxhLhR2vnrMjyo5b+ATFWWcmqqPID3d/IUqSM
	fVrZUaWIVDLdnXtusGOL2KSePKtWSIU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pFy862fA;
	spf=pass (imf19.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793878089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1uORwWZ1lMFhwuvqvOoHtu8XYv8QFSZmfwB9UbsnnNY=;
	b=PLezDiEr/L69CyTjfp9DNG1RTPZjgqWfMveMk2myBd/ls0eqZhRcA3b4Y+C2lRd2U9N5kS
	tk25gE/e2M1JXyCaSOV8E+mhj40f0nqVExvuEsT57mKWevWGSzz1atuT5z5DzTs96W3LQl
	gP+mmCQ4c8WKlD+WL5Qb3uYQ09dTzEo=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4910b863b84so329091f8f.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 03:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793878088; x=1794482888; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1uORwWZ1lMFhwuvqvOoHtu8XYv8QFSZmfwB9UbsnnNY=;
        b=pFy862fACpdlT1lxWBPppRVKMCmUMFH2NOMipXbgqzU2TS3R0mYQxM2+d/xCzb+2Ne
         0F1qZZzqugikriQEpnwewjTW9irvGkpc+XCNklP1L/9CYq0OdnSjRfX1PA/XNb682h0a
         RIsYfz7PboG6rFXZlfI1fX72mVMAaK89o3+qNwZoFtIjblKi6q1CZ0kQ/ZPncg4aoZ6t
         sRztmYpzuJMuF35NC0NwPRwirtNlOFBfvd4XqPibI6vt5hc1ft8EffRT6PGsjRIulmns
         hoUHdk4pR4Wph0Bv5gV1q2v0T1YB3cPaKGpyh5QZHwFKilmfbpLzmEL/q2wn0VKPA6od
         uKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793878088; x=1794482888;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1uORwWZ1lMFhwuvqvOoHtu8XYv8QFSZmfwB9UbsnnNY=;
        b=TzC0RqPrLuD7LImclxEAb39ITmUrLZ+g5wneud2DXGlWeLvkdqPY0/WEIUlwjsNymg
         TNhycCxLyarX8RALLXAR5Hv97fH3xAIY/qC2xseyWUm+JGqeTChAxP2sUDl2lRS3Z5d3
         kgk9halNoCDrvofpZsyfpYBJsJsrZDRmY6EOxXv41bAZ2mSI/tGhVRaU0GxjUM5KVA/N
         qouMR/kL69P6xSi2BXbhxPk9wzE1p0sZ1OnFtu9AjefuKmqaCpoL/DBkdU7zGWQcOtTK
         wKydaAlqDCCumYqGYJ5gxgMyYlUkw/rpl2nxb/pCMZn6ajYHtIOZ+zZ4Pnyhve1Cbuc1
         DLBw==
X-Forwarded-Encrypted: i=1; AKwUvBwRyEYJvkYOrhHyvCL8ltLa640UZuHCjgqANdQZ03wwgoa1ECEPjgYkgHamVRexxf7gcoSfYJy7FA==@kvack.org
X-Gm-Message-State: APuU4Z/veV/FeIT4nYp4s0LxQncrtiWyplaboIMrGN74V+kR4DjOmLXJ
	2r+C5ZGixPa/lGNjsc6P1z/dCmk72r030JBYXrj+tX9OosFYgO0O2Sos
X-Gm-Gg: AYBFou1g3MGCuyombWl56EZoCDJIENfV5/t0YcYmlsjC6+kwD+T2bgljXQE8vvlOFmc
	YCFeGSmQdDF1AimdHExiJBDMh66Gd1+UXYXAiHeZO1rCRHp967lETU6YfI/kFcTzHnNZ9cU7C+3
	g85lNOrQpqHS/pFizUO4bAyhqV9q3f1q1RdsiCT/jUbcC/b9R4DzFWBD4XMheR3PFna6KFs4kMB
	SXRT26dgU1DwC4FzGcAdJfv1e/k6uhWnSvmMjxPJz9TmGGCvPFqHYl5D3WQKeYSatJFWO7TmA/2
	4p1w5xA7R61yDpOWdssmE/WL+6N5kxFz0ZYMLVxhg69BhYzyn2oBVFs3qlo0p//4PdUwfgXxRTL
	oDpKp9N8PxQ//3F7lkBiu6MjernGvPFCg23A6WV1Rc0Om7gIN2yjuqiVVqZ3HuIAu7KvzXyqmns
	ZztX3w8SWzfREwWE5C1swvE6ekiUNYP8WsFNE2/WX28/f8HnFxLx4SIdlwNysMS4eTL8H6UBSLe
	N3WG7taJn5H3dFAXUTpScNtFt3p5rwx6ATr8htgy6MI95AELLrL64pBo+dp6CwZbI365R8u93ZD
	yhK2x3csarPc2kLA6o7V42E=
X-Received: by 2002:a05:600c:1989:b0:4a1:88df:8a2a with SMTP id 5b1f17b1804b1-4b55dbb09dfmr41331955e9.13.1793878087546;
        Thu, 05 Nov 2026 03:28:07 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56f5e59d3sm64368315e9.10.2026.11.05.03.28.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 03:28:06 -0800 (PST)
Message-ID: <a6b65236-24d9-4e2f-aac5-d90bc4b6a357@gmail.com>
Date: Thu, 5 Nov 2026 12:28:05 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, akpm@linux-foundation.org, lance.yang@linux.dev
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
 <818fb0b4bbb234e4a2bd0552d61634f1a8431616.1793850539.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <818fb0b4bbb234e4a2bd0552d61634f1a8431616.1793850539.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3FC011A000B
X-Stat-Signature: w7jkzicye4qsud7knok1199ggg5tj1hf
X-Rspam-User: 
X-HE-Tag: 1793878089-332957
X-HE-Meta: U2FsdGVkX1+hSkEaxiUft1Yi1dOYpGce8XwOxjM1LGPksdfzw5Muy1RI6Z6sd68gw3hdB9N1/CroY3iNCpbVgzxeBr8HeajQ8QDReztEIfUs7wd5EcssTGQNhVP5qdD2KcYAsNS9TU/ZvamLqmAodQtEsotaFTTD5VsLv9fPkfmdNLZe8GWUgf4U9L/ZdXea39oH9HcwA3lWLKVDwr3+4PhWkl3ghoi1LPvKhMFO/zxGQaGAztOLyNif6UvuK9fdgEaxX/qfBGhHJnFMSqqKQzl5DSNH3iUW7YTeR/rxYVLTLrR/VkTBTJ03mQ6xuWe9kjrtPSN31A3bNm86NOo1H+DtZjMaabUIqNuM3MpY1QUJsJYKhIl8S7grlN0VVkX6ENdN7DTnblhqI88FzX9ashezvtoktJwHs3IViDlhKD635Ku5XIBsy8xA/Co8YRZMf94pyCMtypZpxzQyWhPF5ZAmG2badQyZZosFB8bbrt94kz9frlrPdsmZA+f11BCm32NyAx6dbiLohdX7Lj4/uTHkimyvuZbeu/CFyaYTIGY5ld8892lVJjzp8QoO/qB/b+jwaA492z3pDlTKDXKuI2UiW4fSXHga7ixObzotejODjOHFsxLl070lhoq5UtVb3RWF9Lyf06IfFKOb0LxaVBh32vseQnVFDxzwqvukAKnQM7ShJS0Btw5WCTAuIHCVb7xgCobA74LURtDrlZgU4gli5SbJnrLDNMElAKMHqsLi0uzXqqf0JhDp803VMokU22l2MrqQ0hdCXo6rJ29Pxtt8CR+2IRM7fJY9gmmVTZAmljADNgye7/dJgNkriDuac3yT6hNv7zFaEW6Ix5bXP0kK/yDZHcH43LkHPsiEPSo4wCWgwN9o2XhpIgrQC1j9Kp8fJbDROsMR280hvC4nbtFKzw1C3PQ6jD1GHTZQY3T7YNo2MpBg3DcMaRAgx5eKeVtULVf5lsecZdsG5sb
 k2iKoyK/
 NujQgFc0H5S9a69KnVWlZ/qhnJcr1TAnhOijP10A19MsHoEYd8rH7X7zl56gqiE2ea+FRDOq5VixLsYNQFY5UOL6ocXDbutT4cYLZhlhDtqzjIxOn1ShUJzFUNVHjS0tXobOnwpuXN22AyW2GmwHbuAa4OZtiaDcxahtyhQiTuv2ONagWHTzoRjziMRPgoQaBr7yjtV+nQ8u5KC+KZ0HHhu5iOtjmL2FEfFlLG/8ODZcoAD1jsat2T02tBV05dQVDoMz88V4KXZc5qFIfVVWUM5U+Z6WHPF7wGlwE5vFs1bVRothyCK/SR7amrMtX80MuFINZku2zNBYWP2V4uoSRHtDrYzjy6OvDtpIHt0fcfW8CojhLZDDQ9qPCwvjAvPdqYIcR7jOlDb7GS85uO5mGVsrqMy8urpX3PjiNbPh+T3auKsgMmUDqAXvhnzA2W5LlfoAxrcyX7ujHzV3k4Etx5nRHP+sDR4gjzrcGR++P3YJoFB8qlYps2kHBbIWFkqgZf51P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 5:07 AM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
> unpinnable, causing unnecessary migration or pinning failures.
> 
> These folios already own their CMA bitmap ranges, and memory blocks
> overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
> HPG_cma to be pinned directly, including in ZONE_MOVABLE.
> 
> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
> Cc: stable@vger.kernel.org
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>


LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

