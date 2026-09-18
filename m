Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B093DC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A47DC6B0088; Fri, 18 Sep 2026 16:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8CF6B008A; Fri, 18 Sep 2026 16:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1416B008C; Fri, 18 Sep 2026 16:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 619DB6B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:00:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7174DC05E2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:00:43 +0000 (UTC)
X-FDA: 85227950766.12.3371F5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8FBF4140003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:00:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jXwXVqX4;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789761641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqRuy6t8l0KMBsc8eMIIlqtXIJciSthuiHWYk9gxWWQ=;
	b=xOuCoARrkNitLgBrQ3VwqOij0Sqvdjl7+ooWNqH5u15L+yFM7LbQ8APdhtxCdqJuOz11qM
	L+W/p4JsKnpoJ7tViOAn5U6QIZaJkb2SaojrmRA2BhYqM1dIqlrB9BiuskXCzzNHXC+0Aw
	uS9ZFCdzojE3VrIq5I+qV4kPYOU4+lE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jXwXVqX4;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789761641;
	b=am6VpHjjx89jBwlv8nDB6zhOUkzFNBAya9XuXZp8MR8k6YkGKiCUQSoC3/IN5O3MWkOC0D
	5CFut4IXwGPEjNyK5sO9GvXsszgA8WVOot9t9yYDGVUpyhkzFDoGWi+fYIDVtf8amvKYbT
	DBVjIk5OkriVBgEwBnax2dlDsN+F3rE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2A9443894;
	Fri, 18 Sep 2026 20:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559CB1F000FF;
	Fri, 18 Sep 2026 20:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789761640;
	bh=DqRuy6t8l0KMBsc8eMIIlqtXIJciSthuiHWYk9gxWWQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jXwXVqX45pm1S5/YzhSxREbtC4KN6fHavNEtSUadv2NX6CDWi/5GQG5+EXoS7kNZL
	 z96gMCf/3OX5NhSzsj/QiOO1t3h++itVSy1RLabKNoyv/ZtCjcRWT2VZI4qBrQAS59
	 fIlbYqQnB0l/sDHT8n+jyftddKfjdRLarGpeYbecixZgXsqu+5Dfjwztm+s+Bf6KC1
	 0KxRZ3DNN8CrfEcasmcNn8MsT0c0IdeinzkdY3X6QejS2OF1o4Ay3Uo7sTNxu6i3fk
	 7rKhEw91gcHRrTbi0P6RtIWFjs77qURfBKonQtTPvEi2UumT9+aAFJ4AgOZUjxACRc
	 UGT9wFAH4fr8A==
Message-ID: <1d1e38d8-cc1a-4a53-80c7-c0ef75a70105@kernel.org>
Date: Fri, 18 Sep 2026 22:00:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] arm64: use hw_pte_t for fixmap HW PTEs
To: Ryan Roberts <ryan.roberts@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <20260914-pte0_arm-v1-4-bb53b663e396@arm.com>
 <829523cd-85a4-4f8e-b9f2-f3c1d7ce4fb1@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <829523cd-85a4-4f8e-b9f2-f3c1d7ce4fb1@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: nof5midearefzts6of4a7zghy38kczj3
X-Rspamd-Queue-Id: 8FBF4140003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789761641-808011
X-HE-Meta: U2FsdGVkX19ipRBH2+IkycFCoWzxTxjdQfqbFBGG8Yyk9vW6ZkO83fYsLvMuiOnqZGKCdwvfRCs3TfkMsrcVtkN9WGkUtRHKugaUYBJ8i1lqc6x+iYZBIBWNhrrBfo5qi8AJB6y+4jGNoxH5rLOm68jvzIfINnvTqhs8yAGLVuhrHhZjweMlblgNJa9p8PgvL84mw+KIwA3JfeQhgNKSWL/fy/Rjzbk8oeDlct++wbhHL6hxFYQRgvQwLKxb5JtaBbk+N0K5fr5zAi536Q7UUYCGbRCPiKIh7UNEc475DaQB0bkp6Upe6GTVYIYiLf802+gPdi7W/yP+L9E79+sXWhEKryXulD+NQSQQ6+ITU3bOIyzbbdaG3wuWTv8tTb7Cf22AWmfxVi2EzeF2nzvCs6t/X8fPKDOLSnXQEWTjhvUcWylSLukrODE7RRqpRmUvUD8tTP4D9vCtPj8VbxF4I35l9Sq3vLLP4XqaCYjPM5C9z7hOjw9GpYV0S/HUz8uID29lIw+KcdlnTB93gwMOFYv49Lvmw1YV3eoDpuV94FyznuxdD77XFHEHG5XDgZGk8vtQA4Athp5KKbCLtXcSs/dr0tqssl3qqe6Bsj5CtFh0rNt43qmHBQnDdWHevRfI6ACU0CHediNtqMYne1PWiVrz2t1Q0uX94gyhFAICJr7tkK+sghYMOMgbdLVEqpdJAXJapOps7frwUN+8h+TUJQVqFP836p2VIIxc9T3wycTYeMGFe/GK0dCbo7jlgI8Bg8Tpr2/oMPs0afQnTJPwDco59D5DBVk4VyUCbB4CaejddD2DYeh5yzpcG+sv4u/wLesil9FVGHt73GnZO58hrQ5ZqOU90TRhTIoOrT4xbCNXcPYtBE/lq9NhnX3Tq5dFDlNeQZV0oWFfoNl2fUYL9U3LGP+5JcDMBSxSbWYRbrfxBFv7+9W8CgUvTD8KX25MFBVKLFsRcmsAo4A2skY
 59jl3lw5
 9fNA5dXGfrNgCz7ix0Pgns4pHrRbVviZSxN3eYyplazEB9Rx88xrJ4nyFJuakmrh1dcxfP0uQL28zG+YVsK6A5Ygb3LpPi2F3gdh5TSRkpEy6Vf1q99778hIYwCosVp43FPsyTOE+PCDPizgWJ61Vmr/BL43gO1ggUIUfRB3C8CwpER2a05c8eLtfrra4l1Px2lG0w7a4PL+XCmMCdbHiLu/2p70sMibsIYKIxx1SHJ/07IURarHjbBr33AlkXEmwGXz1DkIKQNMPWLM6yhn6CvuBJ7DpXEQXwmpc/uVGhR6Vsx1COXV38FUhlc6AivWyHlCysW1++XML4wP85O/u/LhNc+Fbd/oYcF55ioDgcus25Euo2f+aaBs/fn0wRSRCpxfqztu3TXwojWwKMcwSwZ5/4A70YzywGGmeHA+A6VcI8ETpA8blBGOMbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 18:03, Ryan Roberts wrote:
> On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
>> fixmap_pte() returns a pointer into bm_pte, and early_fixmap_init_pte()
>> installs those arrays as page tables. Their elements are therefore
>> HW PTEs.
>>
>> Change the element type of bm_pte to hw_pte_t so it matches the HW PTE
>> pointers returned and passed to the accessors. This is needed before
>> ARCH_HAS_HW_PTE_T makes HW PTEs and SW PTE values distinct types; the
>> array dimensions and placement are unchanged.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>>  arch/arm64/mm/fixmap.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
>> index 237a9136bc73b..709a97fe327d8 100644
>> --- a/arch/arm64/mm/fixmap.c
>> +++ b/arch/arm64/mm/fixmap.c
>> @@ -31,7 +31,7 @@ static_assert(NR_BM_PMD_TABLES == 1);
>>  
>>  #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
>>  
>> -static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
>> +static hw_pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
> 
> I think in my original proposal it was impossible to have a hw_pte value; only a
> hw_pte pointer was possible. Being able to create hw_pte values means that it is
> possible that a hw_pte_t pointer is not actually pointing to an entry in a HW
> pgtable. The main motivation for this is that we want to dereference neighbours
> of a hw pte based on it's pointer and be confident that it is safe. I think this
> removes some of the safety.

If you follow some of the related discussions on the core-mm series, there is a
path forward to go further into that direction.

People instantiating a hw_pte_t on the stack are not really a concern right now.

-- 
Cheers,

David

