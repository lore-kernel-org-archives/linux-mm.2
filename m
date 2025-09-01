Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46066CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73AD8E0062; Mon,  1 Sep 2025 09:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C24CF8E0006; Mon,  1 Sep 2025 09:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B144A8E0062; Mon,  1 Sep 2025 09:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 984878E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:59:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 627391605BF
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:59:03 +0000 (UTC)
X-FDA: 83840837766.22.6FB95BF
Received: from m.syntacore.com (m.syntacore.com [178.249.69.228])
	by imf12.hostedemail.com (Postfix) with ESMTP id D61724000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:59:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=syntacore.com header.s=m header.b=im375hOA;
	dmarc=pass (policy=none) header.from=syntacore.com;
	spf=pass (imf12.hostedemail.com: domain of svetlana.parfenova@syntacore.com designates 178.249.69.228 as permitted sender) smtp.mailfrom=svetlana.parfenova@syntacore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756735141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFK1KsPaY9lVZCNqSiIscNbL7eAxdmZz/XyL68Jx/+g=;
	b=FPj9s4Hc06550Ic5BzGqG2eNAtd0T2Ixb7cBN1S89nQalWVt94mh7OARuOQJcKgioVAv/N
	l50izjPX4wtozYfIaTVhEUSaVYPFsujde7EGWZX0Kn0fowpyyN/YrVruV2EbySF3JDeFde
	lpDUHxw0bUO7ZfQjrw0s7T3jOTLlGmA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=syntacore.com header.s=m header.b=im375hOA;
	dmarc=pass (policy=none) header.from=syntacore.com;
	spf=pass (imf12.hostedemail.com: domain of svetlana.parfenova@syntacore.com designates 178.249.69.228 as permitted sender) smtp.mailfrom=svetlana.parfenova@syntacore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756735141; a=rsa-sha256;
	cv=none;
	b=gmx6E6qoRv5nBgL3+hr6ryOtbKu1GgjULLVtVbCbxFh4AyouixLYteDb4umGsb5rLdmJac
	pLFk3eEEb9CBRXXgXR90/iRhD5HvzdmpM4MqFBoWDSwIt4DOEhhHhfHC3UD25s61WzIZnk
	XX1We4r6PGKSNERCfX1nPrOD0TntLiY=
Received: from MRN-SC-KSMG-01.corp.syntacore.com (localhost [127.0.0.1])
	by m.syntacore.com (Postfix) with ESMTP id 535941A0005;
	Mon,  1 Sep 2025 13:58:59 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 m.syntacore.com 535941A0005
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=syntacore.com; s=m;
	t=1756735139; bh=KFK1KsPaY9lVZCNqSiIscNbL7eAxdmZz/XyL68Jx/+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=im375hOAfoHr1jOpo6ZcppAjUC/QV2Bv0nkdC6qpYUk7R/j9aowFYySe4q9penFP8
	 inmTDm/ogLsyZ30UjzX/vNMzumDgERDBR1FTuqeyv5/g1HXiMY29LLx6sbhPKIcttv
	 YY7gPMpVEXHVR+15BR9i8PnlIrIQxsr/TWGFRHibIlhKtxFovTTomzHvmRWWf1Q0j/
	 3pORsKs/vnx9iU2jeZP5mbgMLbjBUjNpwH/Pqf95c7kJOha9/RLovtGZUqBh4Z/k7U
	 9G0+VsX0pd2W4K0+PpBj9PGIt9vIkmIQDuqw5s70wwhtGK/ieIdICXY3k0h7fXWLsB
	 vw2XM7GdPrqgg==
Received: from S-SC-EXCH-01.corp.syntacore.com (mail.syntacore.com [10.76.202.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by m.syntacore.com (Postfix) with ESMTPS;
	Mon,  1 Sep 2025 13:58:58 +0000 (UTC)
Received: from [10.30.18.228] (10.30.18.228) by
 S-SC-EXCH-01.corp.syntacore.com (10.76.202.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 1 Sep 2025 16:58:51 +0300
Message-ID: <308785c9-5579-4950-aea5-f19d02a2de37@syntacore.com>
Date: Mon, 1 Sep 2025 20:58:56 +0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RESEND v2] binfmt_elf: preserve original ELF e_flags for
 core dumps
To: Kees Cook <kees@kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
References: <20250806161814.607668-1-svetlana.parfenova@syntacore.com>
 <20250811095328.256869-1-svetlana.parfenova@syntacore.com>
 <202508251009.CB5EB2E304@keescook>
Content-Language: en-US
From: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
In-Reply-To: <202508251009.CB5EB2E304@keescook>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.18.228]
X-ClientProxiedBy: S-SC-EXCH-01.corp.syntacore.com (10.76.202.20) To
 S-SC-EXCH-01.corp.syntacore.com (10.76.202.20)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/09/01 12:41:00 #27718494
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D61724000B
X-Stat-Signature: hgonhphp68zjfts8x1f78z5r4umn8rw4
X-Rspam-User: 
X-HE-Tag: 1756735140-457537
X-HE-Meta: U2FsdGVkX1+Gxda9sCcGzf0m0VQAUTeKpOGNCkTx3zvRZfIo5kW18ASaZCPwqKICJ9gA1vAOezx9i4NbojodgNH04+099ftkIbfuamqcV6pXq3lH35jfMfZRvcGUVqxzwMOC0bQpUGI9LO6g57BqtjSk4+NMelyDa75tVDxyc8UHybKAWGBELGEdBWukzuFR6nMTHdnRP4k1fgYBAuQpjzH3PfZVhB9B7NVlLJCgRy2R93TUyEGdq8xZPRtQ0cfpaes31cwdK9eVakg2kBQWlsPs5kVANISW0v1ApHrXRWeLqGjBpHcbWuqgZbnGtmj93CcDag7Xs48oEUzMrwYFn1H8IHJToxLvIWawIwXKHop8X7vaYaaJvrYCKn5ESNegMfBKLZoFzcfpxwOIXYjU1cnsTP0Zxd0B10ecP00+jiNE0WrCe1Zv0UixwSMVKyPGF6Yd6ALeqvb5OS3s4xTh02TrEkQ2dcFzRXwAG50c8q2wQKlH1Me/8jWnrKhUx5uewMRTa/mHhdfw1+6HJeT3TxN7vCEeMJCIRpoR/or7oG+JY/ihMIR7ksGN+mhNsLCU1yIFkWWLRbkR/efkgekE36M+rcE194HX02icTXjYXsfjf8h3jw6fWMewOi9qijTm6eWgS0T/2TSQKGgv2qiC8djq4asHQdO66kxBNpkYCBURweug4aCCNH2eS+vQ9jzAD8AVHmoqp5dnSdQwQ18iA4OGZrG45STLYR30MTJRFW8llSyEPoClunLW5WuHNFKaY/+IgIqRso131PwDPKPodaLl6WlKj8jmq2RGkr2QA3nNvMcmuP64L9GG/cxdG96Uc2KOifYobfG69u+80R353ZP7cBCuIUG5noIxQBMSQpFzKS2JHbv/dnfTAuZsoXBCxq0pNtvpUk0Z1g+S5WUZbO4YGNK0/I1g3RKpZAff6VBXRGKjhqKCq1LS+dCJBTC7wSUuTPQWD/ekmUHQnwL
 nCFnQFjy
 A0JHCWp7q7umaRZHAnxBXJvFEu1GFp/bu5nS/9PW02RnTI19sVNML8+zyVq0dNboKMwalOgnqiBbUMU3zM7+6b7BWVtole4nplO1JxUXF2Bho8SAIhHD+qrrq4+AfYZAvXGB4Gz/e2i5Wxpqz/Xed4ovPdMUtYe5UOukChGxvkdAxVYfR3tnbB6tzwr6tDIOBNQ4QYivdDAlmreE+9f7ra2+Xj1WPnKk4ESmPNP923P9vXr3gpI50kzTSZgdA6bAXVko7ukKW/S7t2wqFfDH03OfvjTYmUDOv1e3DL2cyLIcEMNf6nb578m4Y9CrURKWix3y+sJ/phrKCWl3BjYkv8ollkvDekLclFwB8Q5PWbFUXUXj5IXdrZLHvSp1lYrTYwJuw5S7pZP8Qk6ErESEJXxIrd03WrVvBAsNc7mE9J8jWjbFx/GTIsUiTv1NE18H5jXqFLwPTn1diBJE3zVr2gmiwydXEskZu8lTmZ/MAck3TYjgQ5dksEXiZIXWh/H8LNQ2QsPH3oz04ozY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/2025 00.17, Kees Cook wrote:
> On Mon, Aug 11, 2025 at 03:53:28PM +0600, Svetlana Parfenova wrote:
>> Some architectures, such as RISC-V, use the ELF e_flags field to encode
>> ABI-specific information (e.g., ISA extensions, fpu support). Debuggers
>> like GDB rely on these flags in core dumps to correctly interpret
>> optional register sets. If the flags are missing or incorrect, GDB may
>> warn and ignore valid data, for example:
>>
>>      warning: Unexpected size of section '.reg2/213' in core file.
>>
>> This can prevent access to fpu or other architecture-specific registers
>> even when they were dumped.
>>
>> Save the e_flags field during ELF binary loading (in load_elf_binary())
>> into the mm_struct, and later retrieve it during core dump generation
>> (in fill_note_info()). A new macro ELF_CORE_USE_PROCESS_EFLAGS allows
>> architectures to enable this behavior - currently just RISC-V.
>>
>> Signed-off-by: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
>> ---
>> Changes in v2:
>>   - Remove usage of Kconfig option.
>>   - Add an architecture-optional macro to set process e_flags. Enabled
>>     by defining ELF_CORE_USE_PROCESS_EFLAGS. Defaults to no-op if not
>>     used.
>>
>>   arch/riscv/include/asm/elf.h |  1 +
>>   fs/binfmt_elf.c              | 34 ++++++++++++++++++++++++++++------
>>   include/linux/mm_types.h     |  3 +++
>>   3 files changed, 32 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/riscv/include/asm/elf.h b/arch/riscv/include/asm/elf.h
>> index c7aea7886d22..5d9f0ac851ee 100644
>> --- a/arch/riscv/include/asm/elf.h
>> +++ b/arch/riscv/include/asm/elf.h
>> @@ -20,6 +20,7 @@
>>    * These are used to set parameters in the core dumps.
>>    */
>>   #define ELF_ARCH	EM_RISCV
>> +#define ELF_CORE_USE_PROCESS_EFLAGS
> 
> Let's move this to the per-arch Kconfig instead, that way we can use it
> in other places. Maybe call in CONFIG_ARCH_HAS_ELF_CORE_EFLAGS?
> 
>>   
>>   #ifndef ELF_CLASS
>>   #ifdef CONFIG_64BIT
>> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
>> index caeddccaa1fe..e52b1e077218 100644
>> --- a/fs/binfmt_elf.c
>> +++ b/fs/binfmt_elf.c
>> @@ -66,6 +66,14 @@
>>   #define elf_check_fdpic(ex) false
>>   #endif
>>   
>> +#ifdef ELF_CORE_USE_PROCESS_EFLAGS
>> +#define elf_coredump_get_process_eflags(dump_task, e_flags) \
>> +	(*(e_flags) = (dump_task)->mm->saved_e_flags)
>> +#else
>> +#define elf_coredump_get_process_eflags(dump_task, e_flags) \
>> +	do { (void)(dump_task); (void)(e_flags); } while (0)
>> +#endif
> 
> Let's make specific set/get helpers here, instead.
> 
> static inline
> u32 coredump_get_mm_eflags(struct mm_struct *mm, u32 flags)
> {
> #ifdef CONFIG_ARCH_HAS_ELF_CORE_EFLAGS
> 	flags = mm->saved_e_flags;
> #else
> 	return flags;
> }
> 
> static inline
> void coredump_set_mm_eflags(struct mm_struct *mm, u32 flags)
> {
> #ifdef CONFIG_ARCH_HAS_ELF_CORE_EFLAGS
> 	mm->saved_e_flags = flags;
> #endif
> }
> 
> 
>> +
>>   static int load_elf_binary(struct linux_binprm *bprm);
>>   
>>   /*
>> @@ -1290,6 +1298,9 @@ static int load_elf_binary(struct linux_binprm *bprm)
>>   	mm->end_data = end_data;
>>   	mm->start_stack = bprm->p;
>>   
>> +	/* stash e_flags for use in core dumps */
>> +	mm->saved_e_flags = elf_ex->e_flags;
> 
> Then this is:
> 
> 	coredump_set_mm_eflags(mm, elf_ex->e_flags);
> 
>> +
>>   	/**
>>   	 * DOC: "brk" handling
>>   	 *
>> @@ -1804,6 +1815,8 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
>>   	struct elf_thread_core_info *t;
>>   	struct elf_prpsinfo *psinfo;
>>   	struct core_thread *ct;
>> +	u16 machine;
>> +	u32 flags;
>>   
>>   	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
>>   	if (!psinfo)
>> @@ -1831,17 +1844,26 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
>>   		return 0;
>>   	}
>>   
>> -	/*
>> -	 * Initialize the ELF file header.
>> -	 */
>> -	fill_elf_header(elf, phdrs,
>> -			view->e_machine, view->e_flags);
>> +	machine = view->e_machine;
>> +	flags = view->e_flags;
>>   #else
>>   	view = NULL;
>>   	info->thread_notes = 2;
>> -	fill_elf_header(elf, phdrs, ELF_ARCH, ELF_CORE_EFLAGS);
>> +	machine = ELF_ARCH;
>> +	flags = ELF_CORE_EFLAGS;
>>   #endif
>>   
>> +	/*
>> +	 * Override ELF e_flags with value taken from process,
>> +	 * if arch wants to.
>> +	 */
>> +	elf_coredump_get_process_eflags(dump_task, &flags);
> 
> And this is:
> 
> 	flags = coredump_get_mm_eflags(dump_task->mm, flags);
> 
>> +
>> +	/*
>> +	 * Initialize the ELF file header.
>> +	 */
>> +	fill_elf_header(elf, phdrs, machine, flags);
>> +
>>   	/*
>>   	 * Allocate a structure for each thread.
>>   	 */
>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>> index d6b91e8a66d6..e46f554f8d91 100644
>> --- a/include/linux/mm_types.h
>> +++ b/include/linux/mm_types.h
>> @@ -1098,6 +1098,9 @@ struct mm_struct {
>>   
>>   		unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
>>   
> 
> And then add:
> 
> #ifdef CONFIG_ARCH_HAS_ELF_CORE_EFLAGS
> 
>> +		/* the ABI-related flags from the ELF header. Used for core dump */
>> +		unsigned long saved_e_flags;
> 
> #endif
> 
> around this part
> 
>> +
>>   		struct percpu_counter rss_stat[NR_MM_COUNTERS];
>>   
>>   		struct linux_binfmt *binfmt;
>> -- 
>> 2.50.1
>>
> 

Thank you for review! I have addressed your comments in v3 of the patch.

-- 
Best regards,
Svetlana Parfenova

