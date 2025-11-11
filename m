Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06176CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 17:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49A6B8E0008; Tue, 11 Nov 2025 12:54:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471D48E0002; Tue, 11 Nov 2025 12:54:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AEFB8E0008; Tue, 11 Nov 2025 12:54:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 28B628E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:54:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0971138F2D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 17:54:04 +0000 (UTC)
X-FDA: 84099074808.29.0F19337
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id C06AF20019
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 17:54:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=a1uFiBIJ;
	spf=pass (imf13.hostedemail.com: domain of 3OHgTaQgKCMUulnvxlymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3OHgTaQgKCMUulnvxlymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762883642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=siZpfgLP5dzbji0XiVCv9b7MoiCCfLbkPmoP4Qg2zlY=;
	b=z3HoAp6K+akBi3aR7loA/rqhp/v9xgYOs1UaqJBUbq4TV7gMBakZfkw6Jpy4o9REYzxMsC
	4PIXQ1dEA0duPjR7GR6UKQpH6EDX3U2uKz+1EqsF9GgNJZtyPVjWX9PqRmCREG+fWmP44W
	f31/Y9oabsTRQR1sD/L1N6dOHz16if4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762883642; a=rsa-sha256;
	cv=none;
	b=KmZlCYPDcJ0t2WXcgn1zCrTVOduatq1lv2eN5/79+tIgPX/6g9Sbkdl1ilGbuB68wU8dFw
	LZQbvLimPQQ53UKUsxLO8Cw5ksTjs4uSz4Jw7/imIZHg98NUAQ61HerMTKbB8biFhoyby6
	WmBLoPlS8RLcDFlGINSqsUfYcdIHdCA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=a1uFiBIJ;
	spf=pass (imf13.hostedemail.com: domain of 3OHgTaQgKCMUulnvxlymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3OHgTaQgKCMUulnvxlymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42b2ad29140so2208235f8f.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762883641; x=1763488441; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=siZpfgLP5dzbji0XiVCv9b7MoiCCfLbkPmoP4Qg2zlY=;
        b=a1uFiBIJSAWFIzdaS+0+DIwedXp5FajGl+x3/k6hPttJmD66PuJJ/nVDEfa2O6DL9v
         PgbvDCfxhBOicHS/jvkyOMyllSG+mA8wOSKP1IJsYVxymgwdTcmnXKcO7KT4buYVMhUf
         gsCOfMUocaX7xJc5Qpv9KSlXlS91Li6fJcobrACyAhxolhMMRV8u0o32sLatf5OxXBYu
         uppgyQxuL0oUeb/fuDfjVVmr7i9zLIv9/gGSj5z89dwXwaPIFTQow2p4q2QHJKQV749f
         WkCTyOgoOODrG/XW2g6GF00KtmKaGL/VSO2yXrhAp3MSxoKwVKvk3h7kP23qpQbG7gGA
         peoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762883641; x=1763488441;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=siZpfgLP5dzbji0XiVCv9b7MoiCCfLbkPmoP4Qg2zlY=;
        b=YMgmrFwxr/HQjP2UPGRez2VF/suXajMW1MMOyBVUOi/FUxEX+mieO9svsQWcaPbdEs
         DHjPZPUiCLdLb8RZhElxv5Q37miL3UZiF5GBgcCaM8MaIxuA7MB+Ppu5KXvLjPtsLinS
         /07kYVlVjf73onkurVg6zIc/sFd+irdGBcM+bHoTapG4htXI1C5lWiwzsTps/HWyJyG/
         6We8YEots7vj7rph2oH9qcykhqKFjCPi4saJjgS7g0d71aWATOwXCFg5X/pFH5OA/8xE
         1GJksam7aAma3mBBg4F6teT7Alt9OPm/s8BDi4Ayxf0rUxYoHaAr2z/Ud2SAWGlTtANR
         gN3g==
X-Forwarded-Encrypted: i=1; AJvYcCXRdRF+Leettv7Tvx2f+mYegGpfJC1acFt9LphxeAboqOwOUrgg8f7yIy9zmRwgt5eoWa2LB//7mQ==@kvack.org
X-Gm-Message-State: AOJu0Yy6fbp+qJTbJgERE8CgjiQ/54TfPS0iUxCQuplGRazjLqc5pBg3
	/OG/v2Rkg8mJ++DQy+p/qEP93rHK+3thRcfbWdqJpwAa7nhaEyxc4zK6Ecq+MU+JQ35Il490TtM
	rthxjrNwiJZXO4A==
X-Google-Smtp-Source: AGHT+IHnB/R6F1elE6X4v0mXrao282IGqxpFWQpLfCUMAKdx6t7LO867oky5ICmv/qkdodAMAQ3IVjvKrQvXng==
X-Received: from wmgg10.prod.google.com ([2002:a05:600d:a:b0:477:76e1:9b4e])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c8a:b0:477:10c4:b4e with SMTP id 5b1f17b1804b1-477871e3943mr2099455e9.41.1762883640647;
 Tue, 11 Nov 2025 09:54:00 -0800 (PST)
Date: Tue, 11 Nov 2025 17:53:59 +0000
In-Reply-To: <20251111145501.GXaRNORRWGIYQ7yFmH@fat_crate.local>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-4-2d861768041f@google.com> <20251111145501.GXaRNORRWGIYQ7yFmH@fat_crate.local>
X-Mailer: aerc 0.21.0
Message-ID: <DE623FVJ73LV.1PIGW7RLYUAX0@google.com>
Subject: Re: [PATCH 04/21] x86/mm/asi: set up asi_nonsensitive_pgd
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, <peterz@infradead.org>, 
	<dave.hansen@linux.intel.com>, <mingo@redhat.com>, <tglx@linutronix.de>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <derkling@google.com>, 
	<junaids@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<reijiw@google.com>, <rientjes@google.com>, <rppt@kernel.org>, 
	<vbabka@suse.cz>, <x86@kernel.org>, <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: C06AF20019
X-Stat-Signature: qa31bhqcg198ekr413zxtzpc76qsf3z6
X-HE-Tag: 1762883642-519384
X-HE-Meta: U2FsdGVkX1+Nzl35U1LlAfQEx8YR1Yep7Caw+rSF8bPMoUUzl58BPfKbtZy7RoMNjA04hvIuDtHyK+0A3DBdL/gfqwx5RWT+xcpeXz0xTMT5NRuIG5zAwp32Sn/oNTycRd2I8CxGLBtMcVwrepHfKPJyi6E3oheyGNewh3GsW4n1oojsPd7rF6fJCet+UNfhgP7othYtQFnXGlpCmRcrboifaz4CUEMSAUtRwrwI2b6069u3nzHt2hGYTcGgpUCnAuyVYYolYhf10j1kp4BNUwSweDtRgs/C09nsu2IkqaG8OvnbSFuOffm3L6oOTbJqOW23Yte4/IOO6DTPM5gACZQ/btONY9fEzy+XVmGfGGqSBWB8vFRFBwLTjl76AzjsMP7X6YSrlIW+l5Btz7VNfc2CUIgMbDLNZvTgCRj+LF8pC4lWQ7VBMS7fOqxkAH23E7NoeCIRAMAMP4NV2BuzJ6nT/0hkwTgxSI8gb8gr6JoSxyCbmgZhvl2rRsDF/eNdF8v7wif3C7A44/NGHQTm1IYqaw+f6W57nnpkBdDEn4PEVLtsGmEXp5LAIYdZZbxcLfGvalZ8OO3xyf/QYAfbz5lrxBnjCbdr9Wpl42R0pUfIBWiubFS2KKwX4YLzsyhlBLinxZzKIZbplDqB7PMzsHkf9sGjJtwzNDOVw5ubwwcLr3CVd9m8jgXbleH2u8vS4EHuI+IwIje8V5YGf4FYEMjvchOsX0BStT5+cNlGqugydhhjMMr3jUCGxW6fW7pnlcjOuMepkY6VGx5r096P++p+0dTijiHL+wA6MarMZrOlEPnKYm18AQtO3L0mFHswdq7qfeFBfmdjZ+42kFkJfQMGjnfcFQPAChwR59LWSoCr5Uw9ze/4t3d3xLwQPK7By5rC3/57OZEqT7Cnzo4YdwMvM8BcRW3yklQrIQ04WVBCpxnXOTObCG9Tz3PHTIEOiVQ16ZWp41iHRnWcmJd
 LsHsLm/f
 iCD/FoR7oicCima6SC7q40YYYo17xuKxumn+gkMQveloyI7Fqco/RfbWbwwThCbHHpJOLNw0EQAOdJzph4U7OAtCEFVFstKNaWZrFKy5og6kc+f9hrzb4uzb17QYT+67CWM5lOkomffgtU3lf9nmLU3+LMygz5RpiZYYu6/QK6sDKw2Vpwmtpr8at2f2JrirJDM7unwwsaxGKt1yrww6KiC+kCIk+GPklNkNE7FT3gmjgqYaatVsJH0wI5FgVEbQNoJYSuoBY3eUZVAPxzxH06W0Ui3/qTu2HmIM1p+MPFbeYgqtOqaol7J6MUfUQIVYI/36ZhI1X63auv2GxZcpGmqsXSwqrdO40XJYqutjm8MPjMki/VntypgM7FLc3e3gljjAT0nY0umVpaQyNZJB+ByypmtIHtwuVX0+jRxNKMVBclRL/Xby51lqxdZkBqzTOcHa6+ftA+wsLhy/xQIvp2GXX/l1vZys8NQk+5+1mgSqeS0kEbl/z3OzWK6EBgY2X/QWDcwMamlC8EmUxU3AlzmZvU9Vhdb30Jp3SOUYx/3mzBEiBSHcehv/wRxdfJtSUjdbnF3XkyDX4lC0yKD/buPyoQQiO7JZitWwo/8kWHPZdAwHri2lfipsWkzEgediiviv0vSLTBsvOUzk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Nov 11, 2025 at 2:55 PM UTC, Borislav Petkov wrote:
> On Wed, Sep 24, 2025 at 02:59:39PM +0000, Brendan Jackman wrote:
>> @@ -797,6 +800,24 @@ __kernel_physical_mapping_init(unsigned long paddr_start,
>>  
>>  	paddr_last = phys_pgd_init(init_mm.pgd, paddr_start, paddr_end, page_size_mask,
>>  				   prot, init, &pgd_changed);
>> +
>> +	/*
>> +	 * Set up ASI's unrestricted physmap. This needs to mapped at minimum 2M
>> +	 * size so that regions can be mapped and unmapped at pageblock
>> +	 * granularity without requiring allocations.
>> +	 */
>> +	if (asi_nonsensitive_pgd) {
>> +		/*
>> +		 * Since most memory is expected to end up sensitive, start with
>> +		 * everything unmapped in this pagetable.
>> +		 */
>> +		pgprot_t prot_np = __pgprot(pgprot_val(prot) & ~_PAGE_PRESENT);
>> +
>> +		VM_BUG_ON((PAGE_SHIFT + pageblock_order) < page_level_shift(PG_LEVEL_2M));
>> +		phys_pgd_init(asi_nonsensitive_pgd, paddr_start, paddr_end, 1 << PG_LEVEL_2M,
>> +			      prot_np, init, NULL);
>> +	}
>
> This looks weird: so you have some other function - asi_init() - which *must*
> run before this one so that the pgd is allocated. But then you check it here
> and in order to do such a "distributed" init, you export it too.
>
> Instead, I'd simply add a function call here - asi_init_physmap() or whatever
> - which is defined in asi.c and gets *only* called from here. And that
> function returns the pgd or NULL. And then you use phys_pgd_init() on it.

Well, this isn't the only place that refers to asi_nonsensitive_pgd in
this patchset - it's also used as a global from set_memory.c for the
later updates.

Still, you're right about the janky distributed init / setup ordering
issues. So yeah what you suggested with asi_init_physmap() (or whatever
we call it) still makes sense to me, it's just that we'd still have to
export it to set_memory.c

> Also, looking at kernel_map_pages_in_pgd() - and you mentioned set_memory.c
> already - and if I squint my eyes hard enough, it does look like a bunch of
> redundancy between there and init_64.c. But that's nasty code so unifying that
> would be a hard task.

Yeah :/ Some folks pointed out to me that all this logic is kinda
separated between the upper levels of pagetables which are preallocated,
and the lower level ones which are more complicated. So I am still
planning to see if I can come up with some sort of refactoring that only
affects the upper levels.

However, in the meantime I have switched tracks since David H pointed
out an opportunity for me to help out with the guest_memfd stuff [0].
That lets me start getting an interesting subset of this series without
needing any changes to the x86 code just yet.

[0] https://lore.kernel.org/all/20250924151101.2225820-1-patrick.roy@campus.lmu.de/


