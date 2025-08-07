Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1E6C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 13:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51EE56B009A; Thu,  7 Aug 2025 09:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CAEB6B009D; Thu,  7 Aug 2025 09:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BA4F6B00A0; Thu,  7 Aug 2025 09:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2D86B009A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 09:13:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F464116942
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:13:58 +0000 (UTC)
X-FDA: 83750004156.06.9EA755F
Received: from m.syntacore.com (m.syntacore.com [178.249.69.228])
	by imf03.hostedemail.com (Postfix) with ESMTP id F14632000C
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:13:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=syntacore.com header.s=m header.b=lwlxXC8O;
	spf=pass (imf03.hostedemail.com: domain of svetlana.parfenova@syntacore.com designates 178.249.69.228 as permitted sender) smtp.mailfrom=svetlana.parfenova@syntacore.com;
	dmarc=pass (policy=none) header.from=syntacore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754572436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRldComWRoiWOPNshpB2MJ/sQDU9cbT00ez0s1BzS8w=;
	b=7LbRBnO9g2ejKSkOgNDL6elILa/aruvYhZzwkgCNaru0JbGzfgr106ONAHO6/1CLK5Egbc
	uaDJ1DhTM/6rJ8KFN18rxb1zTRacYTZ8SsNWHAgXhPVvyVxbQjEYGLSZv01WURpFqgSEh+
	z4RvnRMNbmpm8hebAC/tTXCjFScGiR8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754572436; a=rsa-sha256;
	cv=none;
	b=UYSPiGXDYULQWtOCIYDIZH9KMl5nGlNaZMi1jj3SxjkT8CfSwT89qzPBgLujhjlV3D2xgR
	6jenlyXde7WHwbx0C4jE/3l38gUTuqWJIkM577Y+HwGs2X0drOmRCsSt+23Sr0DIIgH49x
	mX/xiB8SBlJGzr+yUn5sny7wXsk5ZEo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=syntacore.com header.s=m header.b=lwlxXC8O;
	spf=pass (imf03.hostedemail.com: domain of svetlana.parfenova@syntacore.com designates 178.249.69.228 as permitted sender) smtp.mailfrom=svetlana.parfenova@syntacore.com;
	dmarc=pass (policy=none) header.from=syntacore.com
Received: from MRN-SC-KSMG-01.corp.syntacore.com (localhost [127.0.0.1])
	by m.syntacore.com (Postfix) with ESMTP id 428081A0004;
	Thu,  7 Aug 2025 13:13:54 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 m.syntacore.com 428081A0004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=syntacore.com; s=m;
	t=1754572434; bh=PRldComWRoiWOPNshpB2MJ/sQDU9cbT00ez0s1BzS8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=lwlxXC8O4PxNXasjBDd5En6yslrBNKR2DOdsWuXC5VnWBHN451A0zyGjW/fCetcRS
	 Xisbxr/ILirZiNrhm/rf5gYXrjwuvkahiy9xdStOPmj/7HasYhx+k9cCz1O19IJhbh
	 G2F+OlT4Mp7aeotBQb1MhLhaFLBiDEBgCOSfHkWpSfm07paHg0V5EEF0z8DpNN0DuW
	 IIKVn4HZmwry5/iH9X4hXaytkvZChritrSB9WS4+AhwdwdF9gvyAZfOa42FX1dvDL0
	 1LmPyKNrVMvaL5FaSqTw1vR9xUafDPflnrzYeTA9jdtaKzekfP67saSzk/AY/7aKAM
	 SSBmCcIkPU5fQ==
Received: from S-SC-EXCH-01.corp.syntacore.com (mail.syntacore.com [10.76.202.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by m.syntacore.com (Postfix) with ESMTPS;
	Thu,  7 Aug 2025 13:13:52 +0000 (UTC)
Received: from [10.199.23.86] (10.199.23.86) by
 S-SC-EXCH-01.corp.syntacore.com (10.76.202.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 7 Aug 2025 16:13:20 +0300
Message-ID: <e9990237-bc83-4cbb-bab8-013b939a61fb@syntacore.com>
Date: Thu, 7 Aug 2025 19:13:50 +0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RESEND] binfmt_elf: preserve original ELF e_flags in core
 dumps
To: Kees Cook <kees@kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
References: <20250806161814.607668-1-svetlana.parfenova@syntacore.com>
 <202508061152.6B26BDC6FB@keescook>
Content-Language: en-US
From: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
In-Reply-To: <202508061152.6B26BDC6FB@keescook>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.199.23.86]
X-ClientProxiedBy: S-SC-EXCH-01.corp.syntacore.com (10.76.202.20) To
 S-SC-EXCH-01.corp.syntacore.com (10.76.202.20)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/08/07 12:24:00 #27641897
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5
X-Rspamd-Queue-Id: F14632000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 1yh3nbpdmom9tqnqogswm4pdi67mscks
X-HE-Tag: 1754572435-572351
X-HE-Meta: U2FsdGVkX1+8sSlkLf6mH2ReP/nJQUC0VgBWq8L+Gxg0UeSWXGkh9bYzxsrZ/lEPXxchclX+q54146P1dZhii/TvpgglbLPPuw9oQbH3w9g66wTOBn2kftfB9TT5+OqrR/MzLK7S0/9hi4cO57JBIi+9LnnAjgxy0M2tWEBhKh+HUWaXZDUnjcbqru2y0N29sloVzqUdOOFgC4Hmk8mpO1mzTZyeDCyCGfrcuj0PwCTlrqmdheYNMT6Gksr+EXrYA8KjYsyFxVbCf2mfCgxz85e4TNYKVKv+hULSKeAKCUejJGBAPMxqHmMhmUv8Rebj/d/3SJ4Eav0hhfcxp7L5VbA/uiwRx+OqJERb06ZiPUbx0J2Q1LyWtnM2xl2HtgUV4GS82TW0C4rjUDGBq7tzJ/Ol5vdpG5eHWf7IyZ01SMGR3o34QUZTYUN8PdlyfThlOzoinOyY8XSDlHGUU6ryFzTCqKuBxzUwy/jQMRsBN1whebWDcc2fgXXbqOUgN9JxrZsPi81umtYgCKqwxnBf6ndv+o4w8a/MnDBVHyMXxMmazjE8sWmurbjqhaYL9CFE128+3Uu43pd6ueZ4T41LOLWTDCW29jVEL2NdvPu1gOnQLKsSXk6McfvBXEreIeuYF3+a0TRGMEYuQ0rhBqrtJDgXt/csuZRxOmEy12mo+1r57oXdbgS63dq8/ssL0aRarhuCu/nHu7Whl07FwMmbSt5KBH6Nzd1jqH5VBe+Bar5eLUc2+NGU/sF+P1PNfl7JDyzPLlh9RDvo72kd4mGM6Ms3dqTLigey6UIxuwI11QJPmO2Kux8K8uPZhmfyFKnSP2dA4XmkCdWfMWKMFIx2moJ2XJpS2WsSOA/F5RJHno8rCRjsWYHd3JCI8YN1fOftG3YOGXfGI15bc5golU1Gcr0GpS661Zkwct6ezkIe4mjdM2OQWLmt15ubbVJ0CfuyrXqhjfwqwcjD0AJdCll
 0UpY+OXH
 JD0ehBfhil8+l3u3oF/bOySP73SI2sH641SS9qaLdK1tMDWCkDnVoDnLZWv6nD7BWAvblsw8O6hcIxLGQYX1iQNlU7zaKDy1AH4qsiLMaDnuO43QMXKfQK6uQV5j8PjtsrusNYEz9pzX8zKA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/08/2025 00.57, Kees Cook wrote:
> On Wed, Aug 06, 2025 at 10:18:14PM +0600, Svetlana Parfenova wrote:
>> Preserve the original ELF e_flags from the executable in the core dump
>> header instead of relying on compile-time defaults (ELF_CORE_EFLAGS or
>> value from the regset view). This ensures that ABI-specific flags in
>> the dump file match the actual binary being executed.
>>
>> Save the e_flags field during ELF binary loading (in load_elf_binary())
>> into the mm_struct, and later retrieve it during core dump generation
>> (in fill_note_info()). Use this saved value to populate the e_flags in
>> the core dump ELF header.
>>
>> Add a new Kconfig option, CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS, to guard
>> this behavior. Although motivated by a RISC-V use case, the mechanism is
>> generic and can be applied to all architectures.
> 
> In the general case, is e_flags mismatched? i.e. why hide this behind a
> Kconfig? Put another way, if I enabled this Kconfig and dumped core from
> some regular x86_64 process, will e_flags be different?
> 

The Kconfig option is currently restricted to the RISC-V architecture 
because it's not clear to me whether other architectures need actual 
e_flags value from ELF header. If this option is disabled, the core dump 
will always use a compile time value for e_flags, regardless of which 
method is selected: ELF_CORE_EFLAGS or CORE_DUMP_USE_REGSET. And this 
constant does not necessarily reflect the actual e_flags of the running 
process (at least on RISC-V), which can vary depending on how the binary 
was compiled. Thus, I made a third method to obtain e_flags that 
reflects the real value. And it is gated behind a Kconfig option, as not 
all users may need it.

>> This change is needed to resolve a debugging issue encountered when
>> analyzing core dumps with GDB for RISC-V systems. GDB inspects the
>> e_flags field to determine whether optional register sets such as the
>> floating-point unit are supported. Without correct flags, GDB may warn
>> and ignore valid register data:
>>
>>      warning: Unexpected size of section '.reg2/213' in core file.
>>
>> As a result, floating-point registers are not accessible in the debugger,
>> even though they were dumped. Preserving the original e_flags enables
>> GDB and other tools to properly interpret the dump contents.
>>
>> Signed-off-by: Svetlana Parfenova <svetlana.parfenova@syntacore.com>
>> ---
>>   fs/Kconfig.binfmt        |  9 +++++++++
>>   fs/binfmt_elf.c          | 26 ++++++++++++++++++++------
>>   include/linux/mm_types.h |  5 +++++
>>   3 files changed, 34 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
>> index bd2f530e5740..45bed2041542 100644
>> --- a/fs/Kconfig.binfmt
>> +++ b/fs/Kconfig.binfmt
>> @@ -184,4 +184,13 @@ config EXEC_KUNIT_TEST
>>   	  This builds the exec KUnit tests, which tests boundary conditions
>>   	  of various aspects of the exec internals.
>>   
>> +config CORE_DUMP_USE_PROCESS_EFLAGS
>> +	bool "Preserve ELF e_flags from executable in core dumps"
>> +	depends on BINFMT_ELF && ELF_CORE && RISCV
>> +	default n
>> +	help
>> +	  Save the ELF e_flags from the process executable at load time
>> +	  and use it in the core dump header. This ensures the dump reflects
>> +	  the original binary ABI.
>> +
>>   endmenu
>> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
>> index caeddccaa1fe..e5e06e11f9fc 100644
>> --- a/fs/binfmt_elf.c
>> +++ b/fs/binfmt_elf.c
>> @@ -1290,6 +1290,11 @@ static int load_elf_binary(struct linux_binprm *bprm)
>>   	mm->end_data = end_data;
>>   	mm->start_stack = bprm->p;
>>   
>> +#ifdef CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS
>> +	/* stash e_flags for use in core dumps */
>> +	mm->saved_e_flags = elf_ex->e_flags;
>> +#endif
> 
> Is this structure actually lost during ELF load? I thought we preserved
> some more of the ELF headers during load...
> 

As far as I can tell, the ELF header itself is not preserved beyond 
loading. If there's a mechanism I'm missing that saves it, please let me 
know.

>> +
>>   	/**
>>   	 * DOC: "brk" handling
>>   	 *
>> @@ -1804,6 +1809,8 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
>>   	struct elf_thread_core_info *t;
>>   	struct elf_prpsinfo *psinfo;
>>   	struct core_thread *ct;
>> +	u16 machine;
>> +	u32 flags;
>>   
>>   	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
>>   	if (!psinfo)
>> @@ -1831,17 +1838,24 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
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
>> +#ifdef CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS
>> +	flags = dump_task->mm->saved_e_flags;
>> +#endif
> 
> This appears to clobber the value from view->e_flags. Is that right? It
> feels like this change should only be needed in the default
> ELF_CORE_EFLAGS case. How is view->e_flags normally set?
> 

view->e_flags is set at compile time, and view is pointing to const 
struct. The override of e_flags is intentional in both cases 
(ELF_CORE_EFLAGS and CORE_DUMP_USE_REGSET) to allow access to the 
process actual e_flags, regardless of the selected method.

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
>> index d6b91e8a66d6..39921b32e4f5 100644
>> --- a/include/linux/mm_types.h
>> +++ b/include/linux/mm_types.h
>> @@ -1098,6 +1098,11 @@ struct mm_struct {
>>   
>>   		unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
>>   
>> +#ifdef CONFIG_CORE_DUMP_USE_PROCESS_EFLAGS
>> +		/* the ABI-related flags from the ELF header. Used for core dump */
>> +		unsigned long saved_e_flags;
>> +#endif
>> +
>>   		struct percpu_counter rss_stat[NR_MM_COUNTERS];
>>   
>>   		struct linux_binfmt *binfmt;
>> -- 
>> 2.50.1
>>
> 
> -Kees
> 


-- 
Best regards,
Svetlana Parfenova

