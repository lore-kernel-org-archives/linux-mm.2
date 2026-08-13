Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C61C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 15:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80366B02A3; Thu, 13 Aug 2026 11:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A31C06B02A5; Thu, 13 Aug 2026 11:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947156B02A6; Thu, 13 Aug 2026 11:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60B376B02A3
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:43:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D13AEC01E6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:43:00 +0000 (UTC)
X-FDA: 85096664520.06.30ED3E7
Received: from mta1.migadu.com (out-231.mta1.migadu.com [95.215.58.231])
	by imf18.hostedemail.com (Postfix) with ESMTP id AFEC81C0006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:42:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l97aQlE3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.231 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786635779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIS4vRt/pL7IIIsf1tDrksqUUmj1B3USv+cZFtaDwO0=;
	b=bReYUI+CCIFLsMc4n/Baej4j5vHEvBNXs4UZa/ewdNoRHsrBJRq/S7Mnqks4hKmY3z/0wi
	a6Wh7Dw5hiac6IXnathD2C6SJudZfARXXx1+DuRIzb9QS5SuxoLGc66Xrb6IEe0oQ5ovP5
	LH/Ui8aUY/m8djdG8grAQSuoq1CW/eE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l97aQlE3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.231 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786635779;
	b=tLt86db2NzYZYTQd17iq0q5u/XPhK8/nvVrD1NOpMJCGdXy4+r+9iHF7WX+eO4jZrhsS0H
	7qMnmYWxYQTlZLoPTHtRqbkimXW5oxyMxEG0vgM+9736VcqVoy8p5o/KdxUrvdpAi6Vx9s
	3MYzvwVI/JpWB0IBS4yjpTvHfP4v1sk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZrlSwz1sH+GuY7Ux1ESHXiK4jxEOJCDxesFdDcryT9Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786635777; v=1; x=1787240577;
 b=l97aQlE3ZvWWcPXuKH5FOf1di96Aysd+BgcEYHRPJr4BVzo0BpLnfbxX2/j6sjpb6C5O/orS
 +MZhejkxX3ityYvW+VTaq0pDyJOS04XmkJ3i677oUT/Pl7qEsELFoPgYkJanNQ7UcHMs403MMc0
 nAgIxL+YrXr77qBf3MD9wZSk=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id aae37bbb31fee682;
	Thu, 13 Aug 2026 15:42:56 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Aug 2026 16:42:55 +0100
Message-Id: <DKNXIWKP5KIO.1YT877KQJN0IF@linux.dev>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <x86@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, "Kalyazin, Nikita"
 <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Andy Lutomirski" <luto@kernel.org>, "David Kaplan"
 <david.kaplan@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Patrick
 Bellasi" <derkling@google.com>, "Reiji Watanabe" <reijiw@google.com>, "Sean
 Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 04/26] x86/mm: split out preallocate_sub_pgd()
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-4-6f5729aa9832@google.com>
 <am0aplxsh1b16Rch@google.com>
In-Reply-To: <am0aplxsh1b16Rch@google.com>
X-Rspamd-Queue-Id: AFEC81C0006
X-Stat-Signature: sohsnbd7zunk8attoba31qzck9uohf8p
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786635778-787110
X-HE-Meta: U2FsdGVkX19y9226TqM4u3Elfr3uHFYxyqVy9f6Mld/Gl9oWHoE2BVSMKlBWnRDIpVgx6/NwrF+JhhkRvxJktgsfDo2vkJa6zdUsX0YINoeOOriWls0ehOlMrgQsRFwTfCbU9svv+VIGhVHXFdi4pTRxtg/2Q+MLlHxwRKLxLtv/dUg9W4LjCqI2tSaWI0qAq6RuWJu36AcxXXl75l06yWGWmX3lKtqDUEjnnif0Wr04Bt8h7M0+cKW77bbWefAlyNb8Gv9XDnTQIO0ZdTw0oRpRXCNE05INziCI9D8tdGgJZbK6ixq2zvkpmSMrZWNOr1Htjbjtg13kOHIiuZ5u/0NxdLMgA/hE5yNI/FYQa7gaWP4KpkelcMvw0FhyFj9bAkTwOzfU4L6uZX+GWa4AZJ8v9TMmpMos3L0eTJjgR50ugIKQOrlpDxa3Swemp+cRxIv8AIcp4FSQ0ExfCGIhPfcnS0eujAPEFvBIAqFotAdVRioP+KbFuxW5vC0VxtGZ7OFUoTPj4OmgJV+w8CJsrGZoDFVHaZBluFFlsFRE0Tg9b8g1a2mEVq2vMoBQwZx1JHWkWufrSVAMWB8v31fiZKBT0Kdt7wJX0zBcw/AGah36J0X9m4LtaMm4DFjx16BI+NBvd+XL2mK1R+uX1ZidTCidYdbgSKxc0DwCn+6HvYuLuvK2OzM65sM6A+Q9l5D59QcPhinE7D3yo1Wr27gVBaUJ6xt0K6EZvhO8xUYtjFyIu5kTJZckz7z+lXEpL67iJZt2GJCX6y+vXLvQ7iU7GNertiQEQ8Q5kmyIgI+fi972fceS4Bfkt0DPKYsqFHWG/R2vOX3aC9ZW45hfHGtt8WoIicniZF8yKRbq8ZSffpTGnInNN6QxphdiJ5g5UxHd3x4BG459NopgnyLoVgyFWArYyHrl0E35Iihtigp6pgILMrH4MyDXgOzQxut8G4Bno+VsiJoOhO7dPEmgWGt
 l+oNynGZ
 g0+4/yzOW16LC15+R8xVkGAD+ynMcqsI8FvlEoH0GLuTEC+vkNp/lcd9rhb16cBm+5oJIIlEgc7KW9g8urUGNi5Z7fifLM2Y0OAHr/7kZJvpfw0zYySYjqTcrxeR4xLlbonAYdzKJOHq3taPdYdjNakCwWriOB6Rxr1wjxg4m/0zRT1N5wBx70FFVurvdLlxHotA/oPWdiELHbgcOZdfJfgfjKDWa2MRgX6vj1jgM8xgu0wW29ZR+LeFfTpx9KLwQlHJ+nN+2Sv2NEsHUElS058MCkUBeTbW8pl+WrMEPWzi2otX7Img8QR43fmkz8hYXpS8tpC4KYCNNjhQE/MoZIHp8XcLWN7PvHQyulF2TJOELG7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 31, 2026 at 11:10 PM BST, Yosry Ahmed wrote:
...
>> +extern int preallocate_sub_pgd(struct mm_struct *mm, unsigned long addr=
);
>> +
>
> Do we need extern here?

Nope=20

>> -		if (!pud)
>> -			goto failed;
>> +		if (preallocate_sub_pgd(&init_mm, addr)) {
>> +			/*
>> +			 * The pages have to be there now or they will be
>> +			 * missing in process page-tables later.
>> +			 */
>> +			panic("Failed to pre-allocate pagetables for vmalloc area\n");
>> +		}
>
> Nit: We can probably move this comment above the if block, and drop the
> curly braces:
>
> 		/*
> 		 * The pages have to be there now or they will be missing in
> 		 * process page-tables later.
> 		 */
> 		 if (preallocate_sub_pgd(&init_mm, addr))
> 		 	panic("Failed to pre-allocate pagetables for vmalloc area\n");
>

Ack, thanks.

>>  	}
>> -
>> -	return;
>> -
>> -failed:
>> -
>> -	/*
>> -	 * The pages have to be there now or they will be missing in
>> -	 * process page-tables later.
>> -	 */
>> -	panic("Failed to pre-allocate %s pages for vmalloc area\n", lvl);
>>  }
>> =20
>>  void __init arch_mm_preinit(void)
>> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
>> index f32facdb30354..fdd3709509946 100644
>> --- a/arch/x86/mm/pgtable.c
>> +++ b/arch/x86/mm/pgtable.c
>> @@ -833,3 +833,41 @@ void arch_check_zapped_pud(struct vm_area_struct *v=
ma, pud_t pud)
>>  	/* See note in arch_check_zapped_pte() */
>>  	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) && pud_shstk(pud));
>>  }
>> +
>> +#if CONFIG_PGTABLE_LEVELS > 3
>> +/*
>> + * Allocate all possibly required hardware page tables pointed to ths
>
> 								     ^the
>
>> + * top hardware level. In other words, allocate a p4d on 5-level or a
>
>    					  allocate p4ds?
>> + * pud on 4-level.
>
>       puds?
>
>> + */
>> +int preallocate_sub_pgd(struct mm_struct *mm, unsigned long addr)
>> +{
>> +	const char *lvl;
>
> Nit:
>
> 	const char *lvl =3D "p4d";
>
> or:
>
> 	const char *lvl =3D pgtable_l5_enabled() ? "p4d" : "pud";

This is just maintaining the old way preallocate_vmalloc_pages() was
written.

> But I am wondering how important this information is here?
>
> We should be able to tell whether 5-level paging is enabled based on
> kernel config and command line. If the information is generally not easy
> to get, maybe logging it during boot would generally be useful?

Yeah I don't think this is very important, I'm just trying to avoid
changing log messages unnecessarily, keepign it aligned with the old
preallocate_vmalloc_pages().

For both questions, not strong feelings from me either way, happy to
change it or try to keep it the same.

> Anyway, if we drop lvl here we can drop the gotos, which would be nice.
>
>> +	p4d_t *p4d;
>> +	pud_t *pud;
>> +
>> +	lvl =3D "p4d";
>> +	p4d =3D p4d_alloc(mm, pgd_offset_pgd(mm->pgd, addr), addr);
>> +	if (!p4d)
>> +		goto failed;
>> +
>> +	if (pgtable_l5_enabled())
>> +		return 0;
>> +
>> +	/*
>> +	 * On 4-level systems, the P4D layer is folded away and
>> +	 * the above code does no preallocation.  Below, go down
>> +	 * to the pud _software_ level to ensure the second
>> +	 * hardware level is allocated on 4-level systems too.
>> +	 */
>> +	lvl =3D "pud";
>> +	pud =3D pud_alloc(mm, p4d, addr);
>> +	if (!pud)
>> +		goto failed;
>> +	return 0;
>> +
>> +failed:
>> +	pr_warn_ratelimited("Failed to preallocate %s\n", lvl);
>
> Can this possibly fire more than once? IIUC we will panic right after
> returning.

In the immediate usecase no, but once it's used for
mm_local_map_to_user() we do actually handle failure.

