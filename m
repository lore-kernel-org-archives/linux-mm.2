Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6737606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=awIOW8uj
Received: by kanga.kvack.org (Postfix)
	id D6F9C6B05B3; Fri,  6 Nov 2026 04:29:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20716B05B4; Fri,  6 Nov 2026 04:29:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10D86B05B6; Fri,  6 Nov 2026 04:29:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A00E66B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:29:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F0B1120CE0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:29:56 +0000 (UTC)
X-FDA: 85404172392.23.83E0B62
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5BFF640002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:29:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=awIOW8uj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793957394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waJSczF0G97CDukNHhtkD5XBmdR6Pv681qHRenWC8Ck=;
	b=N+QrYKx+8ApY6pvnFX1/5qTx4iISdsOLY8MxUdK6v5i+IyOwsfr1A+npyhaMc7tAGv72rm
	zW1uv+nEUY/BrxnCxISdvrn3mHmsYT/nKQqEa6hCyr7MMsdAtrsOnShHpXgdTcu/Z3EmBU
	wsnUvpemdRybcxJgQLqkWp4R2FIJQwg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=awIOW8uj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793957394;
	b=rm2p65Q8a5ZU/pofnScdBd5LQhFoPAUhzEyJrQ0NF98D8AAH3yc5eNNfynwp/Z5T4d1Sfv
	f0r3C3hRzcx46KjHk/SFdOkHlRSLBZVOEfc2EYXYb/z+B8DQ9ZMlSNsGOeOPoRzMP1lN2C
	AmGQ37uVb9Ut+loFZo6xiUopVAqS0R0=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso220355a91.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 01:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793957393; x=1794562193; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=waJSczF0G97CDukNHhtkD5XBmdR6Pv681qHRenWC8Ck=;
        b=awIOW8ujmZd9caAsJtL2Q8s27Ytgx9OlF6Wjm77kHoGrcyTBjMJOfN99ilvhdh5nKs
         zrpeBfK3Dx4eNRoF1MH61To/RCWb0NzegIk2KNWfhSZ0BPoqJS61LGaZ8LrvyFLqyfyD
         Jiimxy/z4RgxzcgXoZb4zUwPn2Df/8sGwseH7XMlENSAs336iL9BMc1/KLCcdDSAF9bV
         tgOrbS7X7dH3cgQ735EuFcMc9OE7yTjYgCxJs/3oLCqnPdYupmXBLxg6ITBHEbrBwTFp
         AVKmnOlyJ2B0Rrib8ncXrmeUAx5eEcFrdMG7RkbG6UC4Az8+C2qF6hcwbw8PxcvXp6i3
         g0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793957393; x=1794562193;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=waJSczF0G97CDukNHhtkD5XBmdR6Pv681qHRenWC8Ck=;
        b=1EezB0PkJyIHStdHqtvd7HndVJzjhA3AuEJeGRKxlAnvOn1Z7Hyt8bU8JBtpOsAAAA
         XWadT7mxxaDb2nUrPaDcIckz+/nJUEYy0kWqg5VaCCKZRiEcJlikTzr8MfHDe6XQ8WRS
         qcELNsr0iSdZWMRVCiaeQHqe3F2WMCs7zXxY3ME29PMoSdT6yOqk/ssB0G2frEqAAYwH
         OnMPXbczXREcetQPp1Jpi2tj0ujuHiKtudZIJhj+J/5EE44Hsb2HROI32BFwhZXcfX47
         rnS/E8U/y77AuySnlUDLtCBZEQieElfPy1WYPzhcz9QTUmjWytOxrUVaRY43e3cQnJwg
         ryTA==
X-Forwarded-Encrypted: i=1; AL+hErHbBlwUpQdqKzW2+GL8BUTj9WsE9R+evm9N3oqsppoFDF7LMWrAbDIC9K7t2dNyq23HuNt43Tpykw==@kvack.org
X-Gm-Message-State: APuU4Z9tRNW1Un5Ttk8V02J0vFtlnlRGc0adjZ4ZwBfPtXaffgPLSgCn
	W3URuXQ2AybxtWHhB/q4/LKdEiFa+sBmNE978uK+VMT7jPWPhuch7h2q
X-Gm-Gg: AYBFou1gWY8FbX8jYAtywAiAqKbI0NK7uz640HNPdCzYtgSptF7JQCQhVd6Czw7ZZDq
	RgAibkUr5IAdOqJwtSNl5wmzAubITNg//UZ14jqVPKLE+rwsDDdUAm+X6kE3PI6yhRT49YqmmAB
	P/l5bnv8hBpifddtLJ9fDvXUt0iu+Xk5stofxB6LOUlC6A1nA4adXgBziGpafoi7qb+XncU7ZVp
	Qv3G0tux0t1dnAGUGUbENqhD/s+jKP8vlzwp858NqNHui/SXxiOZOxOqos5Gy+GnT0FrSiwzDfe
	7ssVW8M5Kj59eMD8cIdu3JxAFfXQZjOIyU8a0CxMxYrjjd94kpLzTuRHcEhBXro0f7fc7Q/ETwy
	V4+SUnu76BQcaEgwubM+CoRqYHPzqijJVgDXB5CKy5hLSWT7vRe4G919n8U+ulTAt+5MZxU0RxP
	buJZiwMgaQtMP38mEHX/UQ6MfVRna2on5WBnKBQadcy3wVeLQLceOBY5yuwK7eLYC6NoOZmMcrg
	DBQNdKnU4uXMX/RwbwP5KoUnIqbRaIkZiPmynVyw57LXwJCb0Vm6sEk+1lgvkAqriM6eFbAhbry
	jXhQX0ebpFe5H1mcyeps54rUMPs8run2ZU7QlyWuqs7D1CPFpNmlRgM/ZLlwciUB
X-Received: by 2002:a17:90b:2c8f:b0:3ac:8897:7ba5 with SMTP id 98e67ed59e1d1-3b0db713f11mr1803189a91.59.1793957393089;
        Fri, 06 Nov 2026 01:29:53 -0800 (PST)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b326add7sm7043845a91.8.2026.11.06.01.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 01:29:52 -0800 (PST)
Date: Fri, 6 Nov 2026 17:29:45 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <b48e1b6d-0286-489c-a688-cf751fb74fe6@gmail.com>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
 <257ab860-b408-4897-838b-e7b68f981d6c@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <257ab860-b408-4897-838b-e7b68f981d6c@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5BFF640002
X-Stat-Signature: 1w4593c1gysimfiehhncb5pomq46ofjg
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793957394-947003
X-HE-Meta: U2FsdGVkX1/Xhon4klLuyzffI7Lu6BX+JKl07Ug31gxoTwJZMRbTXcLniPAHpCQQUty52qjf8fEh9TBKwzQ0VFaYNZvrbXROuBKYy/7ZCkVzb0aSHn4gi5hhsUnnNNnEr96JzQ0xefWBpFdFLOuAvdQUYnSTpL//ObbxSTCzBYQFZBiFO8MESFzdpGcJKs6XatBai3ekOEh9wd9TSorhVC9MozbX4HLyyldrxafnE9LqvsXb41jIzxFryLyJa0iZ8/66u3xG4ov3m02dvVpbZmojDH6fOrqR1sGh6t2SRjGX0lVHX0nS85C97MyXVtqTQQvMIOWNtWjqIt6ZReI/i2nBfB++X5OzdaxVIJBOKCEICcBZOb3VHpCY4UCw0bsXh9kLMwSJ2axbHVVE1tmHKW64I/IhL5wG0Z6QslYZQWJD/TkJOunBng+iOa2T6855Nmrc+4E6/GhEHqzlz0tOQ0sG2+YkHMNtAL6tjGqKyioH9eLJu88Rp/3denDH33qtOsnbkhPbBvUW0ha+m/pz4OhIhxZ8mgKTMr1jDJ6uU0vIaKK0MMn+E/gbw25yRAuHI890bfAmIIhvYfi/9+zvnw818Q79dwYtQ4jPuAayStnue4ywStKEBN2j1d0EAbWGTWMr/Z4A/W7sZFwvrNGtYRHiP8Weili09lm9nxAO/qA2ve81QuAuGKnaq9s+tUNJcopWuKAYHObH4EMqeQVp9pSkr7Uo4iAdKuuqIKaCNE//2IMVhL6KAKqSXx+pQpYUH8te+xAebcvwW2wZOoofp9evT+Q8NiHyUAIf0X0rba4icv9se0a8LRr9gnIVhczGnFDEzxWVC6FMy7FatXqIgXiWv2Yk7qedLuNmy6RGOTZRfljKaQ9gM5aN3f+VhxmFTImcTTko7mdsuZs6QACU5VPXfglSsJkU8KplUKINV2Rkm4Z+x8NocgliWU56aCznfpBIgSQYmjY3DVlkLWq
 nBW6NVYc
 Uw9Q/N4EToWgyMsM1xFv8bp2U/68g4Dt5hg8V9VUPQygUhRVfwdgscwVf7sIyO876R1hvscO2bvsm0Ksz6x0U5wAjGdDtlaLCjS1L19KQuBUeugnAoj3aRedWA6ohL7+Am9nLh5BsYrKCM38Z6MJpwMiYCeDnVPPlvbWQrILjjjxUHs1uKEkfvuMiFfPrnFSFLflzE4M6vBlIJoq82u5vn0H7fSin7vMAKP+DX5CgXlW4Pd7E8b6opGIRU3wwfGmIPLetmiXCYRUHqPouW2PQyCB5ao/RxPg/LynFGCIx/UXSJ6lj1moiStJvy+UQGSJxA0M1NBxJhXASuTV7U9KFt146N2fZzEzHc0s0BMnINtT7IHBzzwH21an2cD4rrh+9moV2iZYD1gMgOcbUPrJsBX0rMPfirk7WDUTUpUpICCqqSHRtm5SpBjetXsi1g5TuavdMYafvX0XR1dj9RrqV5rUCrSKv6D5UNgq64gxdHyigXdl8z8RHggIsPEXAbsopT8K3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 10:12:46AM +0800, Vernon Yang wrote:
> On Thu, Nov 05, 2026 at 08:57:24PM +0000, Lorenzo Stoakes (ARM) wrote:
> >  		if (!collapse_possible_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
> > -			/* Unable to collapse, skip to the next candidate. */
> > -			mm_slot->address = ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
> > +			const unsigned long next =
> > +				ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
> > +
> >  			cc->progress++;
> > +			/* Check for overflow. */
> > +			if (unlikely(next < vma->vm_end)) {
>
> I think you want it to be like that.
>
> 			if (unlikely(next >= vma->vm_end)) {
> 					  ^^

Don’t read this comment please. Your code is right.

The VMA at the top of mm, after aligning the end values according to the
PMD, may overflow to 0.

It might be easier to understand if this coding is used.

			if (unlikely(next == 0)) {

--
Cheers,
Vernon

