Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32FE4CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 13:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36C626B009E; Mon, 12 Oct 2026 09:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344BD6B009F; Mon, 12 Oct 2026 09:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259E16B00A0; Mon, 12 Oct 2026 09:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F1FB16B009E
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:30:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D3D3C0D2C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:30:10 +0000 (UTC)
X-FDA: 85314057780.25.57C6C9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B13A7100005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:30:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WHYH4W/O";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791811808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRQC0PbnL5aoeQCewgNON3zLqyfUoM4EnhixV5EbvJ0=;
	b=cjsXMm/zfbg6tSlTerzTr+64ew470PswtqNEiquRddC1SPELbCTPKg6OsfQEiRqBlTYORt
	wQWpA5gKoDoVqJ18MeDGUo1cy3edDx6Tvc2XUPrc50ueIyIdzBih9Jf5IhTOBZBTlS1Q3V
	lkxObL8ldduA9sHjICP2zVabYLvekfM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791811808;
	b=Mn/0vuziiemWudA05lQU+bWytLpw9vyf5VYHXTwSgUlXlfYlmvlTGl9hY+5WKPc4fUEucj
	+iviQEipS02CpMPXP7ujYUtPm9K61ilqpTxAczg5PGgdBu5ypddL/LpkcmqmDd5Y96OQGF
	XDU4GFVjVM9fjloMC/lvkxmv14pJlUg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WHYH4W/O";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78B94413AD;
	Mon, 12 Oct 2026 13:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AF61F0089B;
	Mon, 12 Oct 2026 13:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811807;
	bh=IRQC0PbnL5aoeQCewgNON3zLqyfUoM4EnhixV5EbvJ0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WHYH4W/O+WNRGKJ959IvlnVPR3K19TUntxG+0+bTiBcGY+x/vUyKlmLbKvjSixQGR
	 LN0Dchv8qLT3ba/IAy9vzyZI5AXwhyBry8Jkrsta1bLILtbVINHihXarzwp6RPJqb6
	 gzP2EJ3E8I8+fHrDSHcnfYdSnZLlnDHyeessGVqMbzr7mPULBQrXkynHRr78M4D5kA
	 5ZVirM11w9NhVs+BExU/x7JoZrwxmDQp5BIxPdFTYDwVO1elZKouBxQ72/YSMhR3xs
	 ebuYlWC1XeWBmmW00R5rQB6LyNMf+Q3TVRqCIPVuBkdfutgKTG3b7juEewu6cVzeFK
	 4vQchpcKYtVxQ==
Message-ID: <f5dcf4e4-5308-4d1f-946c-2deb4933217d@kernel.org>
Date: Mon, 12 Oct 2026 15:30:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] arm64/mm: fix destructor for unconstructed hotplug
 page tables
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Oscar Salvador <osalvador@suse.de>, Dave Hansen <dave.hansen@intel.com>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-5-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261010112457.49485-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B13A7100005
X-Stat-Signature: fpxg4tmfoqar61zcybzjajzyzn5ixysw
X-HE-Tag: 1791811808-805297
X-HE-Meta: U2FsdGVkX1+Z5GcEPra2u/nUA7frjLjy6IzHfnw2lpf1j50e6rfhVqq52gFplgoGktz/YHJZrB+kTwghenhkx6aqiV+RR/rBwuS42rbFeJai8olAQUa17kSJGO1TNNdG+hECcrVitBrXpf9mw57bdZcUqXBHr7k6a8onGX/qGU4mM6a7ZgeZ8Q/CutE6+88mvbQrHf4gO3rCVM/Yj4/kIUraAdJAhW+cR3QvxpiVEzYyH2UY0N3WU9Th/Rs71zkUcenEvhWacp8crQWUElIPIjBt2BqvQIvl8cpBzkyn26De8GHzaKnCcD6Bs/RNAOh92vz8iKSKeJAvKNujxoe2xs42bGV3DuMnoYjMVrnwZaz2hoGl1zTaGNJso1lsyP3A2yK0GhzPqYd4j1a9KOUorxzliMZaMLNrsAp8PH43HS/KBFvNocQqGOausEfKP394u2WZK5dcktRBfKu0ork0JiIRMhn16rUNXgRBTlTH8Ubmkqhs+nb0QlTqz8cfC5FG0dl/67EAlaxNwFMOgT3EmDtnhrMyiCYEjp01ZYgti1wfsiuWgHMjmbTzx5RbXs+9vksmeuJxGRU4WQBxlbMaz4NaUq01SwhDf2az0p0Bw+DtiJxb3gNg6EQZfTlyDCP6V5IbQLV6mtOAc7gi/b1wAiwli/b4dB7h6Q/URvmHA6UY3rzY/hTyrrASF+LGYM4OGznQy32fkHIMIPkiBnIRwwKlFIyplj/nCT/XJu+FrcNpWN0bdu7yRtNA+dZTGrfv4ryoifrhgIQHK5t/X6W55zNtAoZaV2X25dF+afVT2aR7jgODNHnbZTsTfxP/ySt7RRHlkkCWnLgAGrAfPHZQHL2XPNhr0LR79zBSAn9ZvG9llnvQwerSDISyeYJjKQJ9dV8FlHnF0B+FwH8rdc4AE1fJ/Plof2a+/YzpFw3mbXhb5D9v87PtWdUGW28KlRkoZOpZhmPnbEfm7E3f9xS
 CFztEGWC
 l3T+lbTcqp2NOLzYEk+QSCajPgJ5WPi861xbyz2n/a69i/GMuT5+ZUIsIXpXSGTBL9zuPjnf07TeBGwe0MDEJadSpf+gv+VjqAabtef4rYhQ2A1biz1PhquijysHm32wMcXn2apTqCoTKB2S6A+PA0FyvtP9ICVvaGnVgNW6FD14oSmIeEw8B5oAg1/bvmj9ruqW4Cc2Sn1Ug4ILg8R4UvGhd0x4RWEIPx/XfA91RmatZA09fZ1qxzlJb0gTLbeDEl/MQv/VkfwUjHcfxf7FcLmZ81jcTtbC6rVcUK2YOvx3nzB0LuGKJT4rX9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/26 13:24, Muchun Song wrote:
> Commit c594b83457cc ("arm64: mm: call pagetable dtor when freeing
> hot-removed page tables") made free_hotplug_pgtable_page()
> unconditionally run the page-table destructor. This matches page tables
> allocated by the arm64 mapping code, which runs the corresponding
> constructors.
> 
> However, arm64 also uses the generic sparse-vmemmap population code.
> Runtime intermediate page tables allocated by that code do not run a
> page-table constructor. Freeing one during memory hot-remove therefore
> runs a destructor without a matching constructor and corrupts
> NR_PAGETABLE accounting.
> 
> Free intermediate page-table pages through pagetable_free(). It runs the
> destructor only for constructor-backed pages and then releases the page
> through the page-table freeing path.
> 
> Fixes: c594b83457cc ("arm64: mm: call pagetable dtor when freeing hot-removed page tables")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

