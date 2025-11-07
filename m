Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FBA9CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 17:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9E768E0015; Fri,  7 Nov 2025 12:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75C58E0002; Fri,  7 Nov 2025 12:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C278E0015; Fri,  7 Nov 2025 12:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 868A28E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:37:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 360984BB88
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:37:08 +0000 (UTC)
X-FDA: 84084516936.23.E3CD30C
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5AE5B140009
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:37:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gq1gTYEU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3QC4OaQgKCCUKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3QC4OaQgKCCUKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762537026; a=rsa-sha256;
	cv=none;
	b=FuBZJ3b3YcZdGqY60X5b5Z+wr7TWv7KUqpWMvpeVnFPk5IGHw+UmCeTs6hfYXKSNM34mG0
	p+vvYxyKtP+hUGtREwDSowqx1JcJPXoHnBdZ+rEBhUhIb96MYre8zrI0S6TQVLNbq9WIiG
	JUDL5bnfqVDvTw5lYxR0GcRULlextRo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gq1gTYEU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3QC4OaQgKCCUKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3QC4OaQgKCCUKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762537026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zhz7gcsikgOjW44ogPO6UQeW+YT4AB9gKFb1aT581fI=;
	b=Ox4zwtOao8ZQfRoRup775hVJNIR/B10KRQA2tT8pmQ8NOMM3aopNNmkTWwdgcvuQJ+j4Sj
	MD5qnTyP+fJ5fS552+JcsnP2yxqTnUlvsgHpAcy8WosH6xNpxy8j/Hx+l8FPUYjDFH/C99
	ccWkhiauB4iaJGk4InSYn/512ARZoig=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429cd1d0d98so712275f8f.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 09:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762537025; x=1763141825; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zhz7gcsikgOjW44ogPO6UQeW+YT4AB9gKFb1aT581fI=;
        b=gq1gTYEUe+EXOvABZ4tnJsA0Gf7cJYVw2XNZByaVUDiSLaXV3JS+CDoZdz87nDP7wF
         GhZI0D5uos3xYuCMPdkcXm7iPK7GX4GrzBnT9fkY8xnkN1WdH6s8vPuQ+Uzl3alBx8W8
         Z6O31W51iP8ji9MIbJau7raiy8MQ2R1c0Kmz3TeFr/a+QFnIdZDg1If5rs957RMdQ5N5
         r/feP4NtSJijjvybSmvsVWJz/y6tVHH8SPNzZOtE3QqWoMx8vew6NC++QaF/WrT5Lz+Q
         nbNy2qrGnKP+loiHDySkPJQnNt2WzSbfPiavrpqMFG6MeGQpp1VZREeXU0LwxjNWJ0XP
         /Q2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762537025; x=1763141825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zhz7gcsikgOjW44ogPO6UQeW+YT4AB9gKFb1aT581fI=;
        b=dtTJxVHKlF9Ye3NbTey8FwmZGmDs9sSpc6iYUYmxU1sqGDD7xWcoVz2kK4/7l6/CiH
         WzXZb+hrOmj1QkPqq6wmdI6Yy0kHGLB+Y9aJNlNDPGXHQUte8bTUrvejs2DwLot0JUXH
         ja6rt6e9igOnW3py93ipG52fzm+0S4HeDR99o/rwc8L8kKWoociswbthPqqFRy2CuwRc
         I41owPZUhiUsxkvCRQwp3iMBXXbFQuW9fJl5Yn9aOmCfK124jFQOeM76Et9QoBnfPcYB
         fiR4t2Vh/hw+pzNeIcpMVOtkyibWCtwDPZ4aU6EU8qBps5Nit0yjoTkuN7AcNwPD8Zvm
         tn0A==
X-Forwarded-Encrypted: i=1; AJvYcCUBB3GqzET6THKhpLHZJs4gyJjjHTQsdbIetSkbqWKraU98BJbycTKViQlc+MK2unMq2PwLwYPJfA==@kvack.org
X-Gm-Message-State: AOJu0Yw+rVTqr7emGrlqDp4gEU+kOszyjdLmn7V/K3LGWISFvWhIoGMO
	MBlOWPYpS8tjfeRwuHvUxHQrbIfVTkSwj1G3JuKYvEC6s9mhosR/j52/kYiYeaSxJK6rqNKN+qo
	r1hAcbVQE9HXEJw==
X-Google-Smtp-Source: AGHT+IFJF2Ksc6u55CE+GD/K60cqff3jO8p1vj7rkxXgTU2hADlFy8fEI1U56A7kvOlzF5vcUeX5HHSZeZ5zgA==
X-Received: from wrbfq11.prod.google.com ([2002:a05:6000:2a0b:b0:429:ccad:3298])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:178b:b0:429:d725:4114 with SMTP id ffacd0b85a97d-42ae5ac5374mr3668462f8f.39.1762537024246;
 Fri, 07 Nov 2025 09:37:04 -0800 (PST)
Date: Fri, 07 Nov 2025 17:37:03 +0000
In-Reply-To: <DE2L1SAOC55E.E4JY62WJQ2A8@google.com>
Mime-Version: 1.0
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de> <DE2L1SAOC55E.E4JY62WJQ2A8@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DE2N8AOQ1A0Y.1PVEXY6ULPCFV@google.com>
Subject: Re: [PATCH v7 00/12] Direct Map Removal Support for guest_memfd
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, Patrick Roy <patrick.roy@campus.lmu.de>
Cc: Patrick Roy <roypat@amazon.co.uk>, <pbonzini@redhat.com>, <corbet@lwn.net>, 
	<maz@kernel.org>, <oliver.upton@linux.dev>, <joey.gouly@arm.com>, 
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <catalin.marinas@arm.com>, 
	<will@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>, 
	<luto@kernel.org>, <peterz@infradead.org>, <willy@infradead.org>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <lorenzo.stoakes@oracle.com>, 
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>, 
	<surenb@google.com>, <mhocko@suse.com>, <song@kernel.org>, <jolsa@kernel.org>, 
	<ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>, 
	<martin.lau@linux.dev>, <eddyz87@gmail.com>, <yonghong.song@linux.dev>, 
	<john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@fomichev.me>, 
	<haoluo@google.com>, <jgg@ziepe.ca>, <jhubbard@nvidia.com>, 
	<peterx@redhat.com>, <jannh@google.com>, <pfalcato@suse.de>, 
	<shuah@kernel.org>, <seanjc@google.com>, <kvm@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>, 
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>, <bpf@vger.kernel.org>, 
	<linux-kselftest@vger.kernel.org>, <xmarcalx@amazon.co.uk>, 
	<kalyazin@amazon.co.uk>, <jackabt@amazon.co.uk>, <derekmn@amazon.co.uk>, 
	<tabba@google.com>, <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AE5B140009
X-Stat-Signature: wx5hyigxyxgqhjea3uudrhtii8ao9w3n
X-HE-Tag: 1762537026-479150
X-HE-Meta: U2FsdGVkX18wI+2QiarI8asOhsF1aI4lGM+qLTMHGUXOw73hect01syscueK7xPSrNsv1rEY6jZxRJjWv1vylRJQL5tB9xpB4TiVi8SPRp5Obx4TFfG777Y6LMsoD5APl4jvi1tZkUUTl1ScPRXZ1NUOpEhrMOV6mHcszvJS2FFnUfQ+PaYh9I5pV/rD+9pHgYqYlsN8kwSftz0Ra8lO35Ab2cyAhRhbmmfqQ1fNx2E8kzalU0MOHqzu6yvsUfCpAMAlamQGwKR541h9CMEwvzjA46WqINViHlxWhYadx+8TYwpZbvYDhCoxhvtUzpD1qeWxPf86rRoqUwvDRHQhqOHxg4b3zEOW/38wB+p38pB6FJAm6xwvdPKmfuuu6VAUFB1sVH1MwHFz673r1GecOf4fw7MSeBnxFH5SzpDLApQ3fHSAxlksR2Sf9n4m7m4H/6m7ivr6UbjbC45C2iQA0zGozTjihz9u88L+usFGMregCg7+QuRoSPp7fAv3F2EAU1e1pPpqaPxG6gcINn9Up/4IZfWcfHIClGfm2I9J6yGJw/+QfjQEov1uCjPb5AUHt2hCrg7n1Rgto89XbmycXPXNMfVuY6waE1ZlHDAOmB0I4/RZpbYXmZz9UhPQJSzG+sE75ivbNkEASLv916ImURO+utuWFuX9DnJHcJ4CZvWezftM3+Rdl1rYrERFJqLrhttLYxZTWZHjTztwOE4WXZgIvVyyGb4IBeCTsOQUmlxOKmJnHDnK8o7AgbSNgt6VxAKayBXYnuq2IDobzQ2WgRYcaAFJZqhn31kpDpSL1SnMMd/QQzaxYhuEaw5xe499g6r1PW8tdkD4SO61K5z4dcD6Vlsw3Et340c4utiogc+0/HXelIaN6F3ogkbYmNihUm124cvfKLVAbJWhILSvSHoKTdNUjasyPQECKmKx1qHTk8vVnkso+7dB5Q5R26PDl8GnCQ9uI2pUDONjX0S
 iookTH6v
 z0BZ62LrJTQLyBGsXyKI4mfw1Mn4RDS1nba2+zlnqT8CuCDv1R4AqzqsG0e3auVlTKf+X3lrzIPScsTgZYL0ldpX6nlZr/Coy0CqghGNd5nJtgGNwGHaA56H49hQK05xTg5zSxz0sVmqQkWEKQHl/R9GDVYDnJZnosP1HJPjVbAzoGgZXjx3xGg5etX01MU7vIRj5jRBKxsJpmoQU/IFvWsm0/SFLS0bpHZWbAwqbgTmyTWJAaN/MiNLLgAHyRR3prXu2o+hSe3zUutnHKdhhU1UsTTCqxRsvnl8tRzOzI0gtT8ZyPspszqV2TITwN3CvK7a5P1d45sqBUHeIqTLc0VcJzjjT1Gi4gFa28ZRcRCqQdOKq+uuaBMynOoRzChIw4OUzOuZ2j2XX4S1DIBfo1jeLFahha4euS1L8vLqtOivzZa9aehlVT5KL2FUZsf2+SD/lZPoh0Fvop8KWq+Hic9fVvU9/A846L98wfaxticWY2tx60j6wKkGxMvOpPhkucC/w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Nov 7, 2025 at 3:54 PM UTC, Brendan Jackman wrote:
> On Wed Sep 24, 2025 at 3:10 PM UTC, Patrick Roy wrote:
>> From: Patrick Roy <roypat@amazon.co.uk>
>>
>> [ based on kvm/next ]
>>
>> Unmapping virtual machine guest memory from the host kernel's direct map is a
>> successful mitigation against Spectre-style transient execution issues: If the
>> kernel page tables do not contain entries pointing to guest memory, then any
>> attempted speculative read through the direct map will necessarily be blocked
>> by the MMU before any observable microarchitectural side-effects happen. This
>> means that Spectre-gadgets and similar cannot be used to target virtual machine
>> memory. Roughly 60% of speculative execution issues fall into this category [1,
>> Table 1].
>>
>> This patch series extends guest_memfd with the ability to remove its memory
>> from the host kernel's direct map, to be able to attain the above protection
>> for KVM guests running inside guest_memfd.
>>
>> Additionally, a Firecracker branch with support for these VMs can be found on
>> GitHub [2].
>>
>> For more details, please refer to the v5 cover letter [v5]. No
>> substantial changes in design have taken place since.
>>
>> === Changes Since v6 ===
>>
>> - Drop patch for passing struct address_space to ->free_folio(), due to
>>   possible races with freeing of the address_space. (Hugh)
>> - Stop using PG_uptodate / gmem preparedness tracking to keep track of
>>   direct map state.  Instead, use the lowest bit of folio->private. (Mike, David)
>> - Do direct map removal when establishing mapping of gmem folio instead
>>   of at allocation time, due to impossibility of handling direct map
>>   removal errors in kvm_gmem_populate(). (Patrick)
>> - Do TLB flushes after direct map removal, and provide a module
>>   parameter to opt out from them, and a new patch to export
>>   flush_tlb_kernel_range() to KVM. (Will)
>>
>> [1]: https://download.vusec.net/papers/quarantine_raid23.pdf
>> [2]: https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
>
> I just got around to trying this out, I checked out this patchset using
> its base-commit and grabbed the Firecracker branch. Things seem OK until
> I set the secrets_free flag in the Firecracker config which IIUC makes
> it set GUEST_MEMFD_FLAG_NO_DIRECT_MAP.
>
> If I set it, I find the guest doesn't show anything on the console.
> Running it in a VM and attaching GDB suggests that it's entering the
> guest repeatedly, it doesn't seem like the vCPU thread is stuck or
> anything. I'm a bit clueless about how to debug that (so far, whenever
> I've broken KVM, things always exploded very dramatically).

I discovered that Firecracker has a GDB stub, so I can just attach to
that and see what the guest is up to.

The issue that the pvclock_vcpu_time_info in kvmclock is all zero:

(gdb) backtrace
#0  pvclock_tsc_khz (src=0xffffffff83a03000 <hv_clock_boot>) at ../arch/x86/kernel/pvclock.c:28
#1  0xffffffff8109d137 in kvm_get_tsc_khz () at ../arch/x86/include/asm/kvmclock.h:11
#2  0xffffffff835c1842 in kvm_get_preset_lpj () at ../arch/x86/kernel/kvmclock.c:128
#3  kvmclock_init () at ../arch/x86/kernel/kvmclock.c:332
#4  0xffffffff835c1487 in kvm_init_platform () at ../arch/x86/kernel/kvm.c:982
#5  0xffffffff835a83df in setup_arch (cmdline_p=cmdline_p@entry=0xffffffff82e03f00) at ../arch/x86/kernel/setup.c:916
#6  0xffffffff83595a22 in start_kernel () at ../init/main.c:925
#7  0xffffffff835a7354 in x86_64_start_reservations (
    real_mode_data=real_mode_data@entry=0x36326c0 <error: Cannot access memory at address 0x36326c0>) at ../arch/x86/kernel/head64.c:507
#8  0xffffffff835a7466 in x86_64_start_kernel (real_mode_data=0x36326c0 <error: Cannot access memory at address 0x36326c0>)
    at ../arch/x86/kernel/head64.c:488
#9  0xffffffff8103e7fd in secondary_startup_64 () at ../arch/x86/kernel/head_64.S:413
#10 0x0000000000000000 in ?? ()
(gdb) p *src
$3 = {version = 0, pad0 = 0, tsc_timestamp = 0, system_time = 0, tsc_to_system_mul = 0, tsc_shift = 0 '\000', flags = 0 '\000', 
  pad = "\000"}

This causes a divide by zero in kvm_get_tsc_khz().

Probably the only reason I didn't see any console output is that I
forgot to set earlyprintk, oops...


