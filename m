Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4592B606A330
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=efbh9wyl
Received: by kanga.kvack.org (Postfix)
	id 252D56B00EF; Wed, 11 Nov 2026 09:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22AE26B05B2; Wed, 11 Nov 2026 09:55:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 141F86B05B4; Wed, 11 Nov 2026 09:55:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D37F06B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:55:39 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99EB6A7CBD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:55:37 +0000 (UTC)
X-FDA: 85423137114.07.7F2E815
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id BB4DD1A000D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:55:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=efbh9wyl;
	spf=pass (imf19.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794408935;
	b=S0rSMw7eZuQr4wbJI4MFLxfakwnhUmHcmxX/mvI2/XNTlcmFv7Fe9+P1iyrEbRqAX8xFJX
	CCYjYiGV34lysara7AH1Vkbq6Zfa8z7phqwM3VEuExgnFXH9PTv2SSRmFyDg20VMbhef4+
	EJBJJfzgw91f+Ec1wQqQBS+W7LUJnh4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=efbh9wyl;
	spf=pass (imf19.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794408935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXxZNPloblwez8eotIUyzVyml6BygSTK9IEoRgeJrow=;
	b=Woui9ypytiqU0jM9m5cDpLUDcI1+vcNTVzijc9BokGKzco1zTBnKe6Ay4mCSdOaObKMINg
	Uf86oum9i9KxWoaP68PdA1wHquOUsUauH6Sz7Wae4c3PFQB9WVH1gblDlhYMNMKmgnmuo7
	x17EIBMLvanyXcfy0rMD+KAR15jI7Ts=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so25798345e9.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794408934; x=1795013734; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vXxZNPloblwez8eotIUyzVyml6BygSTK9IEoRgeJrow=;
        b=efbh9wylXnws1/Mzrhn0m8BoogOBhN9bgnw4bZSIz5zYLPtkKFCNfJq3jW4Mvvx6yl
         OV/uoSJ/a1Uy3ADdxHYc4R97zgYMK3/+iKsAnsCiXfPKEGnE7Vo88tP3bHSnGzg37BrO
         LRSC/lKNnyCFr5wW0VN4g6gCqx7qNLiZCT4zuMvtzzesuOxYRkNzFERMmGq8SY6P4xBl
         5MWyBUJsC/fgt58uxEQcNOT8lm0UeJ7IG6oxRAMU0fR4oeBaF6O7YRykjTYQDi7f+BP/
         L7/HFpP4th/2iH88R3D6O4P0N5o2p/VkA04ZGnkADwSq4O6hX2TeFhGbjj37nhzHgi1Z
         Hmgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794408934; x=1795013734;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vXxZNPloblwez8eotIUyzVyml6BygSTK9IEoRgeJrow=;
        b=0bMpiU204YIzoduPuXd9kZhXL/XIvMtji7ink+U5m3BFQGoTlNW3MyBz3s4mDTDmEf
         qdprt2XQ9DAwJftzHVqA/OTWPIIxF+gwiLzz52AimJZ5kh87f1sXrI3qvSce+bnXpUwC
         prmzPg/s9m8yEn6RAskJHYBAFv8pyecS6vwYgkZBXS5jf9PelrY/uftwP933W7ZdE1w1
         oFp+yohcv+oC/R8VKPgB7DF2uu68HNVaVl9Mqh/Z0MTJSMBnUAlytCRw8HM1896T8AHo
         CerAbKeluLtVvne2Ew1bSZuwkVhTzml2oAfOtdX+uxRTWp3YD6fT237POqvEYcnH838P
         fX8A==
X-Forwarded-Encrypted: i=1; AL+hErFId/TNoIpeTC7/NTmng2StduAWJi+geyt/aDauHbGsgjXLk6R+ISGRUWHMDUHdHJ8IvrsvFToyJQ==@kvack.org
X-Gm-Message-State: APuU4Z+3JuwKER4v9ssJMoMYi+ZefuLh08C7scX4QFkIY+yLq7W27Zhl
	601G2GpXgu/SqGkutlhCIQJTYC/kvrdjTzF/Ncgr63srLgk+3PM+aJuL
X-Gm-Gg: AYBFou0z3yuxqGxDJxQd854gi/AhgW9/k9d8gIBSUy3AuN9N0x/DNmJqZwaB17540yH
	JRiMDQhIl3N5AQEi1N8bWfx3J+7nTfJdLSz/n7x86IWgkHxXHGTbCavwmjM0pM0zFhtbZzsKMYj
	ND3kZcMfCrZpvrwIIRIfdOpMR5lWelCPHUY9D9H7AREJhkLvcxrerQ2YdeTCFr9leiMORhaJMn3
	wptr35ZGO8L4u4H7/3HuysKTlEMzMzCyZx/rt7HzdOeuzn2ym3aLXQF/OfimKq70vy+Aq1WtRDT
	57fUvqbQvEz6qMlErkeIiZdom0s8HQgRDIbBDM+wBP3TwLAItkzuezxqOT1e54bnVychxl8oJQ2
	e3njHLHXh1xqTrlcAcOuUpxcbhQ+dcoM8DgBPGl0LdBW1tA66rsonAHtxrF+sskA8EEZin0C4SZ
	CtdO5sdOOm9KKK1rVBd2uEx7YyyJTC7f/G+fcVcKOxLReh87tCwBBTlSopjZPDpmg57BMy9p2Jj
	ooo3uyS3iH4T+wpW2gEQfAXEYJGo01Dl/CjiBDTIYsyQHYqVHBfpqHqoI2QiHmMhnAUGF1pvXxm
	VCa6AmzlIGYtFlbv4weKQLZ1CnZj6/vHBchePLVMDvTzmS1AlzpvKiVjQdsxicinuX8b
X-Received: by 2002:a05:600c:4f4a:b0:4a1:7e76:d02f with SMTP id 5b1f17b1804b1-4ba0938a45bmr58472185e9.14.1794408934448;
        Wed, 11 Nov 2026 06:55:34 -0800 (PST)
Received: from [172.31.15.113] (6.red-83-60-147.dynamicip.rima-tde.net. [83.60.147.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4c554832sm1485795e9.12.2026.11.11.06.55.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 06:55:34 -0800 (PST)
Message-ID: <5b4c2e29-9c83-458c-a8ab-fc78cb1fc92f@gmail.com>
Date: Wed, 11 Nov 2026 15:55:32 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/hugetlb_vmemmap: fix PMD split TLB flush race
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>, David Hildenbrand
 <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Joao Martins <joao.m.martins@oracle.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Sashiko <sashiko-bot@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261111093747.50048-1-songmuchun@bytedance.com>
 <20261111093747.50048-3-songmuchun@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261111093747.50048-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: repahzqte6jmtcgx33zezkyx3e5upgy3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BB4DD1A000D
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794408935-430547
X-HE-Meta: U2FsdGVkX1//Aq3JFyppbtShZXnS022Sj8ziFgNF2cHK0Rorhgs1gSuokhxUoRmpbTq74CLlVlg4Ji3c3QUf3hn4hoFELtY6t6g62FWH1acbwgly3K8tmmhIlvFTo2/pVVHiOUeox2QZUy4sAg3Pv31OgOoS/ovzPcepqmoAh8GJDOVw6Z79ErjgFFJ9elOvKmxLteOFmDYPRNTyQFM/I0G8W7wECcXkFifirMzuKkKLrU/JUc05ZScE/1cMuKYk81kVOKcp9OxSaoQLuH3v6uP+FZysKMx6FkTCVLOTYoT8fjQM0rDT8YwfC9iUwT/yHqfNabPlBB1BkypnW2AVFcvY2/gndWL+oHRloereItZnY+nntimE+ehxP4V0mlkUuZfoPPUlnxJk6nsD3Z/aYh5to2e0gEXD7n8KJ01S2d/rvzYP+0tB8V4i/F7SfNnj4WE1kMqFb1nuvd85KgKRGMYm8SCafkvCmAiCbX4HpoxlEVcqxo/oJheJuBTLuC800JFZ+Zy229QJzqbXUs75e0XL6KtMst5pL6EcIGwXQhAhWUsxYzljG5a3rZpWT2V6RCDXaimnSIcnfLhXYXV03dwjgeD02wp4fcxAaRV3i2TX12R2w1i2UuVKHYEhm4HZ/50/nzvWnpPVq/Qea/cXMHKiIQLky3tiNA+KRMCN+/mv8dR7zHhWThcYBV2dprbjY4fdbpm1srzWSHuPjIMad+c6v9wAm4DX+mGg5oDe3xjM5RKY+5LeoASHw5dSZTKcNuui4G0iWRbR4ccYBl19K11z2XpIDSzO9LjqUc0/4W0PuaipLy67oC7youS0JThtcFmDYHoJg2VIVIUeOLheYLm7aJ4Bjgg69NzWnbbFzr93w/olrjBpoNjaSUDgYix8nHjmfcyxw5MXMXfQG6Nc6i3VCLiRwdDrYdEeqI3qFKvnOw47Lq6+gHHi+hGE9d3a7pkNaJ2joKhqVs+UwJR
 aaISzHpB
 kUFg70Cv182+Z7vU0FU+eQ6P/G5I481+TmJgkjwwnVECVVFT7+b1qTYbBXd4yStxEJUpWhmutq+Liy4Ukazy5M8vlIpKAfhgOgYyutvBZmv4HIq+jyueHDLr0OS8TTi4w6TpWSVCK/y2mUQwAUnnpxsyA1DqMfCo/yYrBjAWShiZ2SarT5HW2q384SQHdL/B5uvQnfB4TBAgxQxpYUtZeLEsgUOHvt4Nya1b7kbQioiV2eE2s4QWiR3Xzo24VpPkvTmmil0RNBspVgcyb7mIRg7RqwRvyVyShVDaA9D7c/4zGrsFYhZaa3ZeEqDx4s97RktrLKYgcXob6EtoQCt27N947TC1TdfjLWKrelrval6F8KHU6WP60DVrmug36EQvCgDgVtj9qqBvS/6odEfbLVkhcsn2gU0m4fw2dy5cEIgkV7CrwtYDVnKgrjjbXo6HG9sntGOpEjn/slwJL/M5ovJ+18TD3LFUGqJMbgUNdqG9VtU+dF/hgIe6snwEkRwzxSXOKqXWjil/R/zpGhhfVaziiE7Z40p5/BHrln/fd2fg3IkPBSng16D8wVmveA7q9uz1smkwHPQ2uZIZlubaWOOR64YuktJ28r/vXiUU/Md5CcQjnC66vYgr1Oc1keftTDA6qlR3v5EPC8vpX2LoFYag21AZIwFb8tqafM/WwPjoVTzkEOIjxj3gxMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 10:37 AM, Muchun Song wrote:
> Bulk HVO optimization converts vmemmap PMDs for a list of folios into
> PTE tables before issuing a single global TLB flush. After publishing
> a PTE table, a concurrent single-folio optimization can observe it and
> remap its PTEs before the deferred flush:
> 
> CPU0                             CPU1
> hugetlb_vmemmap_optimize_folios()
>    hugetlb_vmemmap_pteify_folio()
>      vmemmap_split_pmd()
>        pmd_populate_kernel()
>        /* TLB flush deferred */
>                                   hugetlb_vmemmap_optimize_folio()
>                                     vmemmap_pmd_entry()
>                                     /* sees a PTE table */
>                                     vmemmap_optimize_pte()
>                                       set_pte_at()
>    flush_tlb_all()
> 
> Modern MMUs permit overlapping TLB entries with different mapping
> granularities only when they translate to the same physical address. In
> this race, the stale PMD translation still points at the original vmemmap
> backing range while the new PTE can point at a shared or replacement
> vmemmap page for the same virtual address.
> 
> Serialize deferred PMD splitting against PTE remapping with the HVO
> rwsem. Hold it for write across the split-only pteify batch and its TLB
> flush, then downgrade it before remapping the folios' vmemmap pages.
> This guarantees that no PTE remapper can observe a newly split PMD until
> the stale PMD translations have been invalidated.
> 
> Fixes: f4b7e3efaddb ("hugetlb: batch PMD split for bulk vmemmap dedup")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-fbdc3410-a4cf-457e-88e6-684380fbadfe


LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

