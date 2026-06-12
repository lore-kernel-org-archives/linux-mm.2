Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE854CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 09:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53636B0005; Fri, 12 Jun 2026 05:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C046B6B0088; Fri, 12 Jun 2026 05:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF3426B008C; Fri, 12 Jun 2026 05:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0E1B6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:35:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 437BB1C2571
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:35:40 +0000 (UTC)
X-FDA: 84870753240.23.3A1D771
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 73FBF20003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:35:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KfZG7iYZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781256938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JrObml0yIYnCUAWtv/OVz1bH4fklsP4VaVWmpRbw/Qg=;
	b=DPY0t1sy4R2m/PNTaKAAb8Xn2JsGrBcn8dNqTKJ8qZC4eqlTLhoSeidprTAbplXXHAHLaG
	hV8sXyEUaSeQAK4Y3e9rV93tpDYa3lqAbw1ye3a1ybc2zm4bnHrY0IMT1iJlv+M0XDbEpU
	DrD57J/CTHXfBiySP+Ykru9ham9LEms=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KfZG7iYZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781256938;
	b=2xKe1d/Y7m8Bjvcn5JY4/NpCcSwMfcLl1WOvSy6fW3HYK+9Iz6HlAQkVrQ+gFBcemx1dSL
	Rd9qIhiwn4TssksNxs9axf9Erek/CHviLjGAIlNnx3waYof/Ompkzgabq1H9/pTIROSMVO
	bNOOIVZ+Kq5v6Ggi7F2ggLeabET7Uu8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 65713407CA;
	Fri, 12 Jun 2026 09:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DC01F000E9;
	Fri, 12 Jun 2026 09:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781256937;
	bh=JrObml0yIYnCUAWtv/OVz1bH4fklsP4VaVWmpRbw/Qg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KfZG7iYZ8BJ0koumV+8rN1nPOlTuaeu+V4287qcq5PiETovxc1aRavIRbq/mIYsPB
	 XHRGbtNhxYo/yzfDgJ5hHU7lnHILOkVmiz6G4C1y5FMB6H5UYrJEvusAQNfY6dOPyd
	 ntHD/ynt+Wgkww9phjC4aMI/h+TAbpxkSYwqCy6sRDM+pASCKRadiVrB2vqC1fq581
	 lioLI87CpPgCEY0Uf2pv9SoxMcCs/MQYa0aTcDjP3EARaJv5dinzOVvF7Ifg9UanHi
	 eJC2IKwnSjeXaoYHajDeaH3qTyMRJCWzRg4FPbhWWzdqbfPSSAsMmNopPJbhG6I01n
	 MoP50i2UQ4glQ==
Message-ID: <ae6adf48-7769-4a16-b3b6-765141328a76@kernel.org>
Date: Fri, 12 Jun 2026 11:35:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: drop pte_clear_not_present_full()
To: "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260611-clear_not_present_full_ptes-v1-0-49865fc82629@kernel.org>
 <20260611-clear_not_present_full_ptes-v1-2-49865fc82629@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260611-clear_not_present_full_ptes-v1-2-49865fc82629@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 73FBF20003
X-Rspam-User: 
X-Stat-Signature: npfjsnke76n4m7kko57r8iwzwoi3qr1j
X-Rspamd-Server: rspam09
X-HE-Tag: 1781256938-933684
X-HE-Meta: U2FsdGVkX1+5048o8Z0uc7RnvJeOrbPMC3eTtrnvzTNN4gESgFj2jCtgs17v5cx5jzzRj6G2NSKwC18rose0o2jcWg1YG4CBDFGYhpvMBifAT4NN8EVjzjVv8DPOjgQ6/9o3jbx9UQL5ubrL7imeRTIBDjC/DpYqwm2dlDFG6OsOrGf4NnOOOGDTzXEM1BesoW8lW7+kI32wwsIcIq8ux8vhFxQMUZwLSk8T3u/8zGSk2b+4/pkQpCzXiGV0Z25N1rAqSaxThvHvjk1AJHkpfmywnP85HgoXSvWkZgil8PuMqJzkXUUOhQCMpLh7oya4nNEDuPARtFkP/Gc+6ZairgVybm5iEwoLzwMWgEQg4kxEv8gvnQE7doFKI4Dn0FyAERFFm2+6TQQ2uOB2W/flQW9HeKZbIgbY11qFu5Jz9yTdnZuEaUN7wNX+VkqXc3kU1U2/v7/Uz6RTqIj6ObMRkBDCFCaHnm9DyVh+eVtPIUbxE4a/f2HdcmVuEwc+aefsmy0oyGcTMYTKXjb+LSCUsLB469Y0mgXf1U6BnwP9wewV37MtgoIi2YI+dLvxyw7w9xTHdN4nNzME5DCZLxp7ZWpIF6R+7fDK0dpGefsHDCwYeogMMG6Zb6xqzfwrbSbBO+kp4obXG0nVc4b3cZqZMbACu192WtP+25eab/GLBURKRX4yFEgPC38SSeFhf06xYs1n8mfMm3chmyfKR8mFBS6ZOPUHbok9AhPbDWoA0JeTT2ThdwwtJqrh00Nkrl9NDSeFsmcRMJYIU6nyuxjTFediuinhzgTf9cgKaReK2sVzqFgTDgX+QjPLxZlR2QpIHlK5WtRyCdynOHlcP3HmNFm5pZmsosO+pkD9NgQ5pBo5bLfMgsuWYrwq5CrdfqI1UX8my/YmTfVvLSUICRF1DoNV6RUeqmz2Yh5CEUermly+za158iQk7e2o67qiNamBdk5MDwh32w5DaF+kfvt
 NS/fe8k+
 k/VKU22gjU7Huz1FEtQBos50YtImAOibjEWvSRQp6n7rYylFFrD6RmEiBgJFy6QDpTk/e/qFoSBXI7xEGVnBPHDIRomkQeaWODRb2PMmRrM0CmG5KF5N3DKi/hCkTG8gcr3R9h+ZCbRaTIo1pnUbPp7tb1o47bX3e0Zw6CoIeOPRpw+XemsuzvKoH2gw6xNs8KCT6Zh7uchu5dSpHlBMBHev85eIIaZPQkkKI/4ukq5Zt3D1XeHsh7US6pJPj/F17KD1ls9Ej879SnzAFUyDRtb95lWlDZV7pJdlAghnGSzTB8OeJ/jUrQwFovg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>   * Context: The caller holds the page table lock.  The PTEs are all not present.
>   * The PTEs are all in the same PMD.
> @@ -989,7 +974,7 @@ static inline void clear_not_present_full_ptes(struct mm_struct *mm,
>  		unsigned long addr, pte_t *ptep, unsigned int nr, int full)
>  {
>  	for (;;) {
> -		pte_clear_not_present_full(mm, addr, ptep, full);
> +		pte_clear(mm, addr, ptep);
>  		if (--nr == 0)
>  			break;
>  		ptep++;
> diff --git a/mm/madvise.c b/mm/madvise.c
> index cd9bb077072c..f3cda54c1d6a 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -698,7 +698,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
>  				clear_not_present_full_ptes(mm, addr, pte, nr, tlb->fullmm);
>  			} else if (softleaf_is_hwpoison(entry) ||
>  				   softleaf_is_poison_marker(entry)) {
> -				pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
> +				pte_clear(mm, addr, pte);

Some odd configs seem to complain about addr not being used (when pte_clear() is
just a define that doesn't use addr).

I'll silence that by doing something like (void)addr;

-- 
Cheers,

David

