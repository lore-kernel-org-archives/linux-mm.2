Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 474A3C44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:11:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1068E6B00EB; Wed, 22 Jul 2026 12:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DFDC6B00F0; Wed, 22 Jul 2026 12:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4DD6B00F1; Wed, 22 Jul 2026 12:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ADE5A6B00EB
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:11:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35438A0248
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:11:10 +0000 (UTC)
X-FDA: 85016901900.29.AD25B93
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7E5794000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:11:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Nj7M+PEq;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784736668;
	b=HTjPk2Tx68x1ccbW4N9ht7qhOvNfo2g78Jkamak40cCXJrAq1t2xyQ2Afv+LHsGVCuGO38
	nIZIBCwyfqt4tCX5Yj27j4zcsGQvqgYmENn+5wt3Hgb04Lpf9TcBJ5ObPdXEKKclifrdfi
	ODXJ9cK6DIEdGP9PcSQt/y6hiw7zDcE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Nj7M+PEq;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784736668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7gbMtcRBklazeR9Yaje3s4+7Dy6S+nIhi//OZs/OEs=;
	b=FnAdNUQRcSGmEDbYSPSyr4EN++MJtvNaUyogORb4zVV562S5w3JgIB2d06b8jcAeAlBpt9
	IDTVtzmtZPG5ymnvVPxVLvY+C4osTOJ+wLEcm0jpV+NQzCbsY+fkNozi93eXM414DVChNz
	AEikBdevl7nO9M3rhpoHPznLxQi8fGU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784736667; x=1816272667;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qWuqbOwT6QdK8lEmHgXNQloF3XL7yChGj+btYV69y50=;
  b=Nj7M+PEqUe8iAMhUxYJkZTZYgIIiiPcDx0Sj2NTR5zruEWY6rD5zudDb
   xw3hT5mw4dQFTr0aRaMwvAIuGDpCpYu4Yo7ya3CCHbAqNygOsjIWFCeRG
   suULjwkCqUDJod6CtwPEyLCiPNEuA12e/66rz14E/z7k6Zn1FLBd+Q2f0
   MI6oZDxU22GkGklzZeLbkHN3SQPtqNYPvF9pTdMKiWqy1OreZwXGm8xkx
   XasBC/ePGEl/yvEfrvNwEpZ/oA90mC8fG+r9443n1PWFEcJNkHECMe1aK
   Pgk39CnzOVu0KapfZMywIbSXV4Y54mlf04vk6Sla4vdVs3PBMolL2T1M1
   Q==;
X-CSE-ConnectionGUID: uJWfiRVdSziME77Tfk5bIg==
X-CSE-MsgGUID: 3QRKGKesRdC0qXIT8EPOAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="85249338"
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="85249338"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 09:11:06 -0700
X-CSE-ConnectionGUID: U5arYDlqQuq4dLkP6r70fQ==
X-CSE-MsgGUID: /RBl1Ar4T1WRR1XwYHvZNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="256900095"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.58]) ([10.125.110.58])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 09:11:05 -0700
Message-ID: <d16a8412-acee-4c21-a126-f570d6306983@intel.com>
Date: Wed, 22 Jul 2026 09:11:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 13/20] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-openrisc@vger.kernel.org
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-13-d9e4bad31e0a@arm.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260722-dummy_ptxp3-v2-13-d9e4bad31e0a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7E5794000D
X-Stat-Signature: 3hjoo5ru8mukrrkpqberaiad7k8c1iu8
X-Rspam-User: 
X-HE-Tag: 1784736667-509502
X-HE-Meta: U2FsdGVkX18mhnRGSZwXl+U0v5UhHnJHZJOeNc9QwyljG9qaJLWl0Xd3LnZgu+Zum8baLEeTM/sqlfk9mhzadA9SaMGMxOKyxq2/6FUzFMT8uNvyPyfe28dYHmOKnzkDaqGi09rcfe7t/Kt6sW2epmNRvYi2FzTapJfns2xTb2ZbrYqNLB0vGRmLE+SbUgN4R/0g2WtucRyI6QWimIh5aYK1jp+WdBj9XwXUPlorkpzlqlFOeT7NjGnLKvWNLbDCo2ePfCtx+PQWRjeBrl/7hbe3ozEfI4gQNcJRlCEsYko5S10cnNeL38PTTHXwk8jF2tsPlV0dbXIJJ6w/Wae1sLQwDgyX5t9xJ5CvaT5CvjHayAsojJXHeIubOY1BbfuGh+D1jrUadDmAwzDeUfUZfgb3VZHO6YvAmXvC9W/HkBt58htE9sMmYo4CjwELKzakZzgyg9b1biipGtizqBsQisGsaIb5FsLECvZ7UPepDlty6fuRpe5LBizCc3vw2XvguTOm7kU1GCpSEwun+6o0ZdIW/moSXzxX4L6XwpyjVZg0it8ntlKo2di5A++tmQ/oc1ZGsihd9jjkOVS+3tkfhm9329pSfJfyqf+3uBPEvBfaNw+DWbQdjxF5kNZ5tn1VTr2TUPqK2IeZixXmnwK2CZtC1hU+4Pc3egcd93bVep57AZbQCZ4s8oQ9gZBdDDheyMCW0tl2vmRhhmSi3JtcPW4FZhHFcbdIXMgRK5us4WsGMRG0sv7PWpI+z/E+AMclBTYoYYB3YxpSTU95qPyCHAH/mKmpytfbiZNksgjCI/xd+ykvbi9vS723RWpOKzudFTZcmU3v2y0YDwyiidZP+HazxbuhiBakFfr3V4bIwJ7Uxzd70pp/w48lXk3fbe4M8zqyssX8LwOxy2ycmXauB9/apaqHjjMQX8iQ0FjmdJ/7PqqOzNwqtjmNgzzl3mFCcZ1OE5sLzZMZLC0M6Sm
 GOha3DJp
 +eIwtPMv/WsW9p7U1hDyx562E9jyLD7gl0sFNRvYNpDBbxynttsBewyGoVINriUppGenVjBqv+Sk+UHf8gilt/X7AIP2FQbi/M8SzgiWjXYft4QaJzlQlzFaWoOhU+GJYuGzrFQ0W1Uj+6TSD5Xf/veSPM8Lt9OxfgIu+zpo/JvAYBS4n9vUQ0rQBQdlyiH6Uw6NAfD/SQFdDo68ug+HKxZ4AggnnXTAJ8AyLeAQoYVE1zktQ1sBOdrocQ8+tvT8/P+WL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 08:30, Yeoreum Yun wrote:
>  struct pg_state {
>  	struct ptdump_state ptdump;
> +	int first_level;
>  	int level;
>  	pgprotval_t current_prot;
>  	pgprotval_t effective_prot;

There is zero reason on x86 to hold this value in a data structure. It
is 100% determined at boot time or earlier. Pre-5-level-paging it's a
compile-time constant.

On x86, it never varies per-mm.

> --- a/mm/ptdump.c
> +++ b/mm/ptdump.c
> @@ -197,6 +197,17 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
>  	st->note_page_flush(st);
>  }
>  
> +int ptdump_pt_level_first(struct mm_struct *mm)
> +{
> +	if (mm_pmd_folded(mm))
> +		return 3;
> +	if (mm_pud_folded(mm))
> +		return 2;
> +	if (mm_p4d_folded(mm))
> +		return 1;
> +	return 0;
> +}

Having this in a .c file may not be the best design decision. On a lot
of architectures and configs, this is 100% a compile-time constant.
Hiding it in a .c file and forcing a call is kinda silly.

In the worst-case scenario on x86, this ends up being an "ALTERNATIVES"
patched check. So it's technically variable, but patched at boot-time to
one possibility or the other.

If something is making the function larger than a few instructions,
something is wrong and needs to get fixed.

IOW, this should be a static inline in a header, not a full CALL'd
function in a .c file. *That* will make the value visible to the
compiler at all call sites and let it do all the smart things compilers
can do with build time constants.

Also, my original objection was "this function has zero to do with x86".
Well, it also really has zero to do with ptdump, either. I'd probably
just stick it in one of the generic page table headers.

