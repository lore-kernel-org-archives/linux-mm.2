Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48008606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kl0My9bw
Received: by kanga.kvack.org (Postfix)
	id 4C0676B05B3; Wed, 11 Nov 2026 09:53:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471A66B05B4; Wed, 11 Nov 2026 09:53:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F846B05B5; Wed, 11 Nov 2026 09:53:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0602C6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:53:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 761A7A7AC8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:53:46 +0000 (UTC)
X-FDA: 85423132452.30.B2C8057
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 80707180005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:53:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kl0My9bw;
	spf=pass (imf24.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794408824;
	b=msWyawcar4EqXI6qq8UxB6bL/KKKLKU3k+KkH7DnbA96GFDd/AU60LcvI21BV3BJAf09OB
	3McUfCG9YETna1uUFxJMjzY+d0Stm+qN5bLCjCwFFfD9ngbmwIFrDuihY0Dt8J2TV9/pW/
	kjuvyUlgDBpAeNwo3aDGcUqj+hfmHeU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kl0My9bw;
	spf=pass (imf24.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794408824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4sM8p1tTNaPGayyybeEyqVTJtS8aLvMWjajmNIN9tU=;
	b=bPWRfssQuTHfKIEvZ4H8FxHfIttghEPPWHAo6txC5ixaM+7ku3zbd0G9fCxrMtbUSYtyin
	VQsI0o9Rg5Yg6/1G5mRc/wQ9JKD7vc5CtwD/cleYoCsCu12tRfkLruWTUjMknd9tBXDXdL
	32yMjckC1tFWDaFWU3DkvIW1Ss76kzw=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso31261695e9.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794408823; x=1795013623; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b4sM8p1tTNaPGayyybeEyqVTJtS8aLvMWjajmNIN9tU=;
        b=kl0My9bwTGC9HdsfCkHzydbzA2lbQ03gKJS8iC5jA/NetHQJgCkiy6CIWlBDn7ke28
         Du5HCEAD4RCQfWoNWzQzpqbIZ6+oXJujohhTHdVOEwJ2agRtiwt2p7Zw0UhXKjeY5/bT
         Jfb6JDEYeYnl3M0SHRzEmNUfe0b5MiyxXgZp6UWSf/VxvYo/W7h0iSygyuCcSIa2a/cA
         mrFNMxwnXcsmOsy/e3mwRnsCBVVk/CTc0s+zJcwioytuMcASIYwcxG0noQC9vVk4jZG9
         Fqix8cOIXX/FE1ZWI2h1E98B9dG9hVl8rWDRcH1Vo7FQZ5uA30xG0mwm5oLJYUlBKVul
         JZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794408823; x=1795013623;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b4sM8p1tTNaPGayyybeEyqVTJtS8aLvMWjajmNIN9tU=;
        b=liwvbIOXuUI6BKXayRwqfuU+r0FDqX5WL0unPh/PFbwRjHNtjqQoZat6g4Q/2ltxNJ
         F/Pe0MUHYyawwzi/CmOjU1+LW0bG44BbvUr5MYN/mGwq9YHzpl+2P3Ie9r533z7GNXsi
         qF2za6tka50vU+de9eZyHeRIM8HrDPEh7/otkn3GOl6JovoPFMo7zeBi0fN5UgwfFpA1
         PKBVVOuFD5enO85qOZ2yhOY0OzuYoLPqDYa/8xqp1xczYozT1XKu0/tHMw0x9mjRPmKY
         ffZ3CG5CnuJuugq4F954F6+eh0qYoLMXGmF5jhVP41vxXiE3G9luBMsFhVDL3RpnODwT
         RUOw==
X-Forwarded-Encrypted: i=1; AL+hErHLppbtwhGZiJPJ6rEnyTxLXCw33S52EMcNtwJuJUCdnc8yUeb6JC1T0oSWOQNZPGfZElbjQX7sXQ==@kvack.org
X-Gm-Message-State: APuU4Z/4l2W/LUaKiksNK9zVr0rP3egrjEVXCZaszwsIYb+lDTuB3NkT
	m0sTbd0SX150ePiBQwqbNfhvZSiyTkg1mW96SoTyzthdjGew8U/SEhXD
X-Gm-Gg: AYBFou1vL/vghMdTs5UJ7zLUl1tf8uxcIoA8MymRAmfL+OXd0kIPPsIns7kVNhtBfnG
	qoPt/RqG6bkVGtsD2Ak/v3wBd+KzS5uCZPfLWIl3dS38+GtDuNKqjIJOf8cT3d2KV9ztsUvNXl3
	QdNZJG9M5I4yvYGF5jVetQxarZUkMaE+Abqs4GpDRTHldugPWhwUqVf4iTcP/6WXAcRivkLiT9H
	QhTRa6hOxO0a+6QcX6USX1vDrVhfgJuXp4QScsIvTdrowQs6mT3fSlAh+/6O63zg8dP8LVzHLY7
	RBuUi+2JWaWydVK5xuS2NGjyc0CSUTFQ0EFlDJYxzJDUQck6rOSmnYecCtgI2kRyyg2htTeSRMT
	Ff1nO1VcyW21TAyDtvYDA3OTGhj8FXuHdXYwj8gb4BWH/e7VTO8SYMEV/4DQmT+icvJQNE9KyH3
	u3XCfDYwyamvpSTqR4tBlIDx47It8PG5AJsFG8VxjbIoQ5bujnV7GmBG7azBfbO9jHUUVp1P5uL
	8da6GAq7y7Ez9CCfy7/w/XG+S6qC0ik6czS1RtTjjY7mKXnckogc7qe/XhLHyo0YH2xd9+hVGl1
	g4WXxEYHkahiC6V4aCm1pF7j5eSCK/GzGmrqgUiwo7s6WbGATvgpEQ1axKU1ullWi5BF
X-Received: by 2002:a05:600c:190a:b0:4a7:9006:b176 with SMTP id 5b1f17b1804b1-4ba0936c8bfmr47936675e9.7.1794408822864;
        Wed, 11 Nov 2026 06:53:42 -0800 (PST)
Received: from [172.31.15.113] (6.red-83-60-147.dynamicip.rima-tde.net. [83.60.147.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba08ddd467sm52895945e9.0.2026.11.11.06.53.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 06:53:42 -0800 (PST)
Message-ID: <a987a2f9-0580-4011-bee3-d706b4f41da9@gmail.com>
Date: Wed, 11 Nov 2026 15:53:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/hugetlb_vmemmap: fix lost HWPoison state during
 optimization
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
 <20261111093747.50048-2-songmuchun@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261111093747.50048-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uj7mw3hgxztigcofnp3wpwfwsqmpffzr
X-Rspamd-Queue-Id: 80707180005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794408824-287282
X-HE-Meta: U2FsdGVkX18cI4i4I4g8fES44XxHXsjLehDpKlGXzxXI7N45kQLK+uuUa1eTaoG1PUafpcaRX/Vjt23aO3AXi2eU04kq0hiCAbiaXsXmtzEzfgnh7aUCJMBqaZAWhSHged13f0WlNj+TTsCDQQygAj+VnB0fXjJZujH70C5qD7vBH2spimFmmzeEU3Vthe/1H0IPYQBm/oASrxILv2t0XG7BYZIcGaCRXehLaN75PqmEigXGnj/UNgFGUwbgAHaI5ru1dM5TphNLebs9RCgRSS69zls8eyTe7g6rNLMRslDvXjQac6n37BuVu3iVPjHB8mxnkdnzL/024iAem6mYct5lduxbRYw/q5FeA5lln0o5DwWfLfN7Uxn+RRfLBKwie7x7CNpAJTBsj9JGcR6vEb0X6IE8KzgegpCu7KQmSgPCE7vi2MmDckJ9v8T0mVoM3MktpIkY0SueIIGUkrc8Kmup+wisoRtYTiV+tflpVwjziYHm8QVdzg/cOTSDkgOqlJ0XYSEQyfs2THGsQ6++B+m6GQJ1MKRy+za6PsHXOqy0GI7ghtwZXlOwCksHHL2IklWT9QIL9Gmmt6BKle+XDd3SHHMNjsjv5Ropep73SHVSmpzAwnoLR12ZCUUfkD+URVJfKzXzg87Qh5jPWKnHXiuc4LQOSNDDwXOB7aBw/g0jHA6KSVX1iciax8bh+F5RBzJMwh0rJbu29hjmc1SZSN7bd1nJ/Cck2JT2iJ5jVne+TaSpxpPIIIylW5NMluTHRA71jm9QIGLaqGO2Qm8m+ygwsoJWPlfijTbzXPhueUmNBG8LKJmutQmNnmvs6EcJYSD2C8zz+KQ37xn9DvIU+g9KNhbtpcaule1oI4hBVJh9FdtJtmQD3rUJK9vPFxMY15dFHNj3weI0rTiHTlYBDF2URuvzeximQqyqcqoHGZiaZdonveSiA4A0hhdv2tYBLSEkl9/mapjTU4tfbp9
 Dut5jw/n
 36Dnh6+IX769Sulk2sW2FmYFagpJANBeoW3rLZhTpUS0x98wkmfV2D4M4Fbbud22AWuHbWZPRfwDF/Pt0cLEEmGdq/YcWvjmb3sioSkmFvi3NOsFKa+MyKKgvx7yC45N3kMoAIqgH16xzmv+FBOJHkMGsC19FTSY1ZcYv0DQX3Bg1n6TIV09dDJx/lwn/r9rts0s33izZ3rQw4Lxy7gR89hPcbI7tJONKoSVWH+RejDg5Jm8zPrert0YkmxLKcv1dKx1IlyQ51eus2zc/9D0Q4+qEGVu5Da3uppXn2Fs1PegnwM6mNVwKzfD1gOS7YRU/XzrCNss7HpvfBSYnFTawVuKLV5D6tjEXwIoCAjqAUwvpye7aELk2iQ7Lf9r5XS9boYGtBJABJvjc7gHKeROKDlk2OoXNTKgqqPVFoQ9X6tn+dJ2G/HtYaPm8OBm0O2KDis+RB3NJzZxLVWqRYza0XpS6yQp8EGEJfhYTMHkVkdmBNrXqHqiLwVKwqisLvT5mqsV3/608V7EC23odvqsMpWEbDL6BdrgTkFPRbNq7auNXXJ3Ym+G0IKn4FV2rUX6KoRju79+s1BaoZzIQZQF9Bj/h0K3VYadIKmzpJ48j4Sb0wGeAyWtXODNNb1A6v/SslSaqFtC8TZpUkPCH4WT8a3FVUeirbWnCexOyG6J3gKaDb7iVEi3ZLswFiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 10:37 AM, Muchun Song wrote:
> HVO copies the vmemmap head page before remapping it to a newly allocated
> backing page. Memory failure can update the old head page after the copy
> but before the remap's TLB invalidation completes:
> 
> CPU 0                            CPU 1
> init_new_hugetlb_folio()
> __hugetlb_vmemmap_optimize_folio()
>    vmemmap_optimize_pte()
>      copy_page(old_head, new_head)
>                                   try_memory_failure_hugetlb()
>                                     get_huge_page_for_hwpoison()
>                                       hugetlb_update_hwpoison(old_head)
>    set_pte_at(..., new_head)
>    flush_tlb_all()
> free_vmemmap_page_list(old_head)
> 
> The raw_hwp_page linked to the old head is then leaked and the folio's
> HWPoison state is lost when the obsolete backing page is freed, allowing
> the poisoned huge page to be allocated later.
> 
> Serialize HVO remapping against HWPoison updates. This ensures that an
> update is either copied to the new vmemmap head page or applied after HVO
> installs the new mapping and completes the TLB flush.
> 
> Fixes: 11aad2631bf7 ("mm/hugetlb_vmemmap: remap head page to newly allocated page")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-18e93f17-529b-4d84-ba44-a41829f4be64

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

