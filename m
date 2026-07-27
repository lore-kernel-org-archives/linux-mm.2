Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B532C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3746B00CB; Mon, 27 Jul 2026 11:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB1C6B00CC; Mon, 27 Jul 2026 11:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDE5C6B00CD; Mon, 27 Jul 2026 11:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B29DD6B00CB
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:28:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33888A074B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:28:13 +0000 (UTC)
X-FDA: 85034937666.19.E8C8E53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4FC371A0003
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:28:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MpTXTUf1;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785166091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yn7THn92ltfwpRSIf8y0JNhszbsvPepGxqi4mlY8vZY=;
	b=mpvIVhLYNmZaqpNv7Oq2CzYLPww6JwLgfz5gicC8Q8w47MDnHnpqFuf6ibBgKRkY8KWonQ
	0xWgbiHSaRkvqMrNx+zD0UD4/g+0g431h0RfwGI7ry6/UWrT0aQlJ8rnkPz/dWKyWAtI20
	37O7Mid0ds2VL2xc3kDpUMovPq/zeCU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785166091;
	b=4jGugoIEVI5f8rQXqg+5KUWgLWnzXVrXBL8IQwBPrheakQKxf9FLR0XY0HjiOR6Tt7uZX2
	I5ifLrdcGTIiMMHtKBLdekG5mJMnbqyCmhdjLYhJGSQmMI7aXZE/N6SxS9tv7TmntvCxMt
	HvwsX93WLBvid6EEeRUJ0cpUcqSbUAE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MpTXTUf1;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BFB586001A;
	Mon, 27 Jul 2026 15:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876871F000E9;
	Mon, 27 Jul 2026 15:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785166090;
	bh=Yn7THn92ltfwpRSIf8y0JNhszbsvPepGxqi4mlY8vZY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MpTXTUf1IbaWg0rNqCCbuu5PcPLoQsBp2p6QMOuOa6C67s0n3nqjMhVlRoe5gZoOp
	 +9aLBlLFOAQK+U+e1a/cBUO3wj8+0KDmrYAdAak8VXXbUHQGCyoArrETZVpKuxnhKc
	 84kpzIlC6XXpyg48j/G5uzn147tOg0iJRP3njbel+YBW112yQFQfx4muGjeKrReHmW
	 r2Xwn5pH7jKH2QupVAX0Nog8210kBR9DZuh7FpjJrb0lVwP1W66fZ+De2pTAnxOrsK
	 IKIAMET39ImFYc2PoHOQVINhU4OXYzMcPNunD547s8eqzIr0pQ8Q9+tXOLuKYxmNGu
	 Olgr4Wr0j5tHw==
Message-ID: <a1df631b-9854-497b-b7fd-831288fca81e@kernel.org>
Date: Mon, 27 Jul 2026 17:27:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 13/20] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Dave Hansen <dave.hansen@intel.com>
Cc: Russell King <linux@armlinux.org.uk>, Huacai Chen
 <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-openrisc@vger.kernel.org
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-13-d9e4bad31e0a@arm.com>
 <d16a8412-acee-4c21-a126-f570d6306983@intel.com>
 <amD_5r04mzMoZ0-r@e129823.arm.com>
 <33c774f6-2750-4831-8eee-e43dc471da32@intel.com>
 <amEvYRs7CjhQdQWT@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <amEvYRs7CjhQdQWT@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ys89mh8dsh445gjk34tm5gdh713od8hu
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4FC371A0003
X-HE-Tag: 1785166091-64876
X-HE-Meta: U2FsdGVkX18TUG1FRRMtCnrn+d4bt2EESNNGJGsKSJhIf4BjC91UNdp5KoqV8ltfdxVwajPFgf4fVX3tdZzQrjX0ZPO96KnAEGWBnnDqN/27xmeMpvTcOMrJJBVt7cbx7fQVZ2hWrfNQ8aWdChP8TDpzhg1tRvXFO/FzsiQ3goZQABQWx6fVdqvEd7ucrMrudv7MMQI99NOKVF/+G92xBXofHmJkxuYLF90B1TQqRWsl45JfJmPYgeQL3d//UQRwoB1KG5ehY4/jzLw825eOxkncJCtaRDf1N/I4z6Zu7yYZidU0Gwx6Uy6OgtiwKE68yL5PCWItTtlyfjj1iAZH4Mor3WCzx8BwJaVuFxBzSmyAqElecL4j+8DQJOQimLPRIO3YXkcD/+fLiPEHJJwAeO+QdmlKdVYSdK7IRZlC4NQFMFM+suPhrRVTltd5szTJwWk8Lcx3VGXQP7wUwGz87Ca8Cv82KMuriqyVTG4e1iYRzjhobpMYvT4rJquU3lkMofQd9U/6EU0JjYzjeaMrMm7meX1fqn4oxnus6cfWJb5XSAD4RCnXn+ImbOgHwCXo+4qFFmQ8Xy1cHHkN3BCwDlHKwcY3w2SCkfcfdK8I3bwyTwQuJIUb0n99MDYix4DJBvg8oQdSbS5XedLfJrQVxSQajQYAjRRoF0XnJSpQyro57px0HQssQKFyCTwjirGVyhAbI3gDBlQIJBaGLEG5Ccp58ki8cA39E6HXbaXRc7a3yFJZmkXle8IDKIpwwVP+9lhqZBLpBdSs685Oy1C1lb0byB6M8xEy8Eghb1CKgQzA1U/bPzx3eFIksQBwO4+ICSfvVhNM6lHde/9p5YHwTbA/DaiKmxViBXBMEGCTp0/60DP2u1lxBJ+eNb1OXhiej+/04jD0mvWYlyZiqVW6b9YNexhU7qW0l7Xr6UHDkbvh0UNLtSZS7SargRbLa9g3rHWvC29vyNz0ZlpCP2W
 d+8z3Qcq
 Vt1E5U+s1PqlnR/1dxGGjr8fkpeEi42jrQr7tRxsSK94tog6F7D00zwScuCBCQjxmu4BdVbrcDVLRAnC6rgaxgdj8ksorDYWbLkMGUSweMkWviDpFHo728JO35hZeTPR/7Mey06p8ay+Qf/eD00brC3JX1gk3L7XfFNNXEy8eig8HaO7iOqkaWqe1oplnbGYed9kIL49l0gbu421Q62nMJuO3sSyPkzArBCoR+gfoCGsA/Sw6Si67G3S/bK5L5W8bAr4QXaq8vvgIo/b3pszfFznbB/y8Zc1o7WseepeNUsevk2DZGy9bsogStg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 23:00, Yeoreum Yun wrote:
> On Wed, Jul 22, 2026 at 01:20:39PM -0700, Dave Hansen wrote:
>> On 7/22/26 10:37, Yeoreum Yun wrote:
>>> However, mm_pXd_folded() requires to mm for other architecture like
>>> s390. might save the mm instead of first_level and calls the
>>> ptdump_pt_level_first() with static inline version would make the
>>> constant comparison. So it requires to save *mm* structure in here.
>>
>> I'm having a really hard time parsing that.
>>
>> I think you're trying to say that the effective_prot_p*() functions need
>> to know the first level but they don't (today) need the mm_struct. If
>> they don't get the (calculated) first_level passed in, they need the
>> mm_struct instead.
>>
>> I think you're arguing 'pg_state' needs a ->first_level or a ->mm.
>> Having a pg_state->mm doesn't seem bad to me at all.
>>
>> But, it's also a little bit silly. It would not be rocket science to
>> pass an mm_struct down to the effective_prot_p*() functions. It makes a
>> whole lot of sense to me for a page table walking function to need
>> metadata from the mm_struct to walk correctly.
> 
> Yes. I mean to add pg_state->mm like:
> 
> diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
> index 2afa7a23340e..aaf00f0c6624 100644
> --- a/arch/x86/mm/dump_pagetables.c
> +++ b/arch/x86/mm/dump_pagetables.c
> @@ -38,6 +38,7 @@ struct pg_state {
>         bool check_wx;
>         unsigned long wx_pages;
>         struct seq_file *seq;
> +       struct mm_struct *mm;
>  };
> 
>  struct addr_marker {
> @@ -254,7 +255,7 @@ static void effective_prot(struct ptdump_state *pt_st, int level, u64 val)
>         pgprotval_t prot = val & PTE_FLAGS_MASK;
>         pgprotval_t effective;
> 
> -       if (level > 0) {
> +       if (level > pgtable_first_level(st->mm)) {
>                 pgprotval_t higher_prot = st->prot_levels[level - 1];
> 
>                 effective = (higher_prot & prot & (_PAGE_USER | _PAGE_RW)) |
> @@ -452,7 +453,8 @@ bool ptdump_walk_pgd_level_core(struct seq_file *m,
>                 .level = -1,
>                 .to_dmesg       = dmesg,
>                 .check_wx       = checkwx,
> -               .seq            = m
> +               .seq            = m,
> +               .mm             = mm,
>         };
> 
>         ptdump_walk_pgd(&st.ptdump, mm, pgd);
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 8c093c119e5a..6e7d0580db99 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -2490,4 +2490,15 @@ pgprot_t vm_get_page_prot(vm_flags_t vm_flags)                           \
>  }                                                                      \
>  EXPORT_SYMBOL(vm_get_page_prot);
> 
> +static inline int pgtable_first_level(struct mm_struct *mm)
> +{
> +       if (mm_pmd_folded(mm))
> +               return 3;
> +       if (mm_pud_folded(mm))
> +               return 2;
> +       if (mm_p4d_folded(mm))
> +               return 1;
> +       return 0;
> +}

In that case the function should probably be called

"mm_first_pgtable_level"

But now it gets confusing, because we have

enum pgtable_level {
	PGTABLE_LEVEL_PTE = 0,
	PGTABLE_LEVEL_PMD,
	PGTABLE_LEVEL_PUD,
	PGTABLE_LEVEL_P4D,
	PGTABLE_LEVEL_PGD,
};


But maybe we can make sense of it and do

/*
 * The enum values correspond to the numerical page table level,
 * starting with the highest level being level 0.
 */
enum pgtable_level {
	PGTABLE_LEVEL_PGD = 0,
	PGTABLE_LEVEL_P4D,
	PGTABLE_LEVEL_PUD,
	PGTABLE_LEVEL_PMD,
	PGTABLE_LEVEL_PTE,
};

static inline enum pgtable_level mm_first_pgtable_level(struct mm_struct *mm)
{
	if (mm_pmd_folded(mm))
		return PGTABLE_LEVEL_PMD;
	if (mm_pud_folded(mm))
		return PGTABLE_LEVEL_PUD;
	if (mm_p4d_folded(mm))
		return PGTABLE_LEVEL_P4D;
	return PGTABLE_LEVEL_PGD;
}


We could even teach effective_prot() and friends to consume enum pgtable_level
now and have it all be a bit cleaner?

-- 
Cheers,

David

