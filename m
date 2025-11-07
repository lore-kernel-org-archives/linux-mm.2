Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D346CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 18:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50AF18E0006; Fri,  7 Nov 2025 13:05:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3248E0002; Fri,  7 Nov 2025 13:05:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F94E8E0006; Fri,  7 Nov 2025 13:05:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BB028E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:05:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C233D13B501
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 18:05:00 +0000 (UTC)
X-FDA: 84084587160.06.D4E2E15
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id E3029C0008
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 18:04:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iMSSFKHG;
	spf=pass (imf10.hostedemail.com: domain of 3yTQOaQgKCLoofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3yTQOaQgKCLoofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762538699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/AqAgTDxm6jquTqnEsjA3Waymb6wOkAp7ZeQjd8rqgw=;
	b=1rY8Am5IEN1iJ2wYHIyI61Hyp4ddyHsNfEKbJVSsEU1Ap3M4nTbHvom70U/PXUXAkoe2HK
	NjlsvPRvlp+iq3lh7piLZtlOT+cR/YrnBsYwnO8E81yyy8xJmi9QnzZxLawjZuukZTkhAS
	JaKrRgcJw2/i3qui0sEM4ooq98Av58U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762538699; a=rsa-sha256;
	cv=none;
	b=CidVhSs9Bk71Mkf6TtuZWpYkSKbnCtpdLbovwG3fNuX+BxER+AlfWW42coUDdXR2DeCQzr
	4wa0XwI3e7DSOeunds+VAabIAerNoZTdzjOB3debT7mSlbdPEjfYEJAtoExE++nBg+yFK2
	JJJLVnlQqChcK0QXfiRosquhrArrxlA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iMSSFKHG;
	spf=pass (imf10.hostedemail.com: domain of 3yTQOaQgKCLoofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3yTQOaQgKCLoofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429cce847c4so619188f8f.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 10:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762538697; x=1763143497; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/AqAgTDxm6jquTqnEsjA3Waymb6wOkAp7ZeQjd8rqgw=;
        b=iMSSFKHGc28FxW+DoYEza8acRad9SWNxJSpqSWpGlUR6zoRND+v+gtMXFTW2Z0YBY8
         3sgJbLlVnbQ4dvCH17D0Gps0Y4yL+9NyK7+GU1AZccHFdGAOp3gbRIIxdwKtjxt3oAU5
         2BuDU9gIrLwh6Z7aXJrhQ3/A9uRvRb0MrDhHiWzufY2HlTnBaWqT7ZopHpjg/m+Iuaa/
         /p+KURXiRV3vb/2Ki+aIMQyhcaHwFKsHsPD68PBtXh62rGQuk3SdVLkryCCkrtMgjUAn
         j9Qz0V+xnBvBJdGp0JUTYoTnJWAIvqdXsChXdF/YosqhHjaiObQPaq4HYuU9p+c+9Zhs
         dFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762538697; x=1763143497;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/AqAgTDxm6jquTqnEsjA3Waymb6wOkAp7ZeQjd8rqgw=;
        b=KX/iWMROldASjPr1reRsoF6wlZ68X3rWawK3VHLwVnwfU4QjvG4Wr9+wg8LCpyveTF
         qJEhfKMrHBygx5QdfDtpfLmnx3sCUnisJmblCZfC8/Xgaos4zlA8k07RBJBggTuqDBKa
         wjwsfR76jiI02lPbYcKPTxWHe0c6evMluUdLc/Oydk0qzytU0i6/pEA/KM3ti2lMQnQG
         Ri+Yv3JJfzr00kot3bmMeQKqdnd+f9rXAr4uaVPRxb8pCb99R2j8qMfEfq9BeYRckunn
         gVQ7qLfntWsEEDbGkEtfo5Qd7UD3ppBOVC1rbxVfcXfe2TTnN236EloiaaMjgQ9e3T9B
         U32A==
X-Forwarded-Encrypted: i=1; AJvYcCVgRLr8U6nl72bidwsgkpmzK0nYp8ByfxvDAmz1uTW/QvhTUt/GblTSyvbR0zjzQ3wnvWFhWQFZbQ==@kvack.org
X-Gm-Message-State: AOJu0YzrHZfBCYk4+RbeyXMXRVeZYUtfcV+toso09hsDlZAhfBygnCpL
	S8FekJBhPav/v0/sYD1np0pV81weVqEH1M7E34r2QH4hJZTuaU4kAMBF0OJz3nPclrRmb9bjN+u
	SMekq1LnugtTmUg==
X-Google-Smtp-Source: AGHT+IFOkVmSQK/jYvTSHAXnkCCnA0joruckYbu4Ldmd5HExfLsxuZZgznGEf8JFTpeS7lG61pD7MYDnH/6ugg==
X-Received: from wrvs14.prod.google.com ([2002:a5d:4ece:0:b0:425:f04a:4d98])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2408:b0:429:d3b8:7387 with SMTP id ffacd0b85a97d-42aefb4351dmr3543783f8f.42.1762538697024;
 Fri, 07 Nov 2025 10:04:57 -0800 (PST)
Date: Fri, 07 Nov 2025 18:04:56 +0000
In-Reply-To: <add94932-290c-4037-b4e6-c3c760240819@amazon.com>
Mime-Version: 1.0
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
 <DE2L1SAOC55E.E4JY62WJQ2A8@google.com> <add94932-290c-4037-b4e6-c3c760240819@amazon.com>
X-Mailer: aerc 0.21.0
Message-ID: <DE2NTMZXQ1MT.2TH9VAKM6WP6I@google.com>
Subject: Re: [PATCH v7 00/12] Direct Map Removal Support for guest_memfd
From: Brendan Jackman <jackmanb@google.com>
To: <kalyazin@amazon.com>, Brendan Jackman <jackmanb@google.com>
Cc: <pbonzini@redhat.com>, <corbet@lwn.net>, <maz@kernel.org>, 
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>, 
	<yuzenghui@huawei.com>, <catalin.marinas@arm.com>, <will@kernel.org>, 
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, 
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
	<tabba@google.com>, <ackerleytng@google.com>, 
	Patrick Roy <patrick.roy@campus.lmu.de>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: E3029C0008
X-Stat-Signature: pz31gwii9ub46s77zwnr3c9mo94d4wie
X-HE-Tag: 1762538698-901617
X-HE-Meta: U2FsdGVkX1+rkOxPksMX5BsWPopHlA+fLuPttFp7zEvLwqn6Efc+cD2AHDZ+lDPQm44E+2QnKHgGjLkjJB77tWUBqqnuZj3VyxpDxNjyj4effC82R/PyA0lAzNmXwS9ieY+uuwinEInRbZTWeXhCIsJwWmXxW1gcaiL+mh0m8ymLtR9qyQRZsWQ0HGLrCBmtvv4HkcDdSFNJ3Ya5be0aw4Le5BiJIkaexmCOws7HIoKwL4GQ0cK3hbYAP56oHD4TCJpgPOQfqvpVDYcKCXeA8R3ge0HHupSAnSjIS2NuGQMipfhRuXzCu02JqRB7+dB7cbi3SUBxY0Oal4pqN+Z+7rDhrLPgKmspNNON/2D04Qe3geJ6w4bQScoODLjDLRpFgrAS5l8KbCUsEwUmunCuLfvlFIZRVZFPx+zY8uW9RxIdhHD/Sp4j3NqOr4Zc1okhcTeWNunqM6jOwJmnPEcS6soXzmu/7g8bcMrUCoXnUv31ZRJmuolcyTXHbG2/wx8DzJCOzHjoDabUOZqjucpj83EeX9OssGHZO/gwqCHjAk1mxuINIp/SvOR9AkIJAtV5pXNh7W9lB2pxW2W8SUkLC5xGfb+x0xzkb2+c5OEFj41XqpEAUvzBclqOdtHnopGOe7Mac298aRHUPBzWMufcvRc/eKJeV/No657wAgxaDlUQ4f3qHTNQUWjPO6GFNi5w/mQH6VrkACloxcuMVQpfJxOYySWLmCd+DgOIn54Z3kakxu86X3OzJPkvWZzYfUGr245KIClVdAgL5rca+z4TGXiwiW7qd8qastmuX0/JZxEhd4i4qpURHIyboEXYYudqXF/QOEH4ge8cb5VpA5L8na3wa7KeKHUxRX1+7s7+8hioSO+hK9I2dVGdYNSt4U8FEGK1ZrJtWSBIPEPMNf50+ipnk+87JPnZ2EJ63xIZ2ikVcl2wNnN/1oX7dXus1zZMB3/+f7EptLpdWGEWrr1
 g+tmKuMo
 yVxgUcDdnxouioB8VNZ/1U9y9qz5sVJBlvRmQFdVoP8am7Y0232KJWG6vI1WRyAHqFEgtK+fG+ThkL2KsdgmzqpIvtNifU7Ja4rsC0TwCDSDz5EBucreHD9CUaNSEflYzR4gLlaAQxlYYnCTotONYv7PT50/NRLGPu2immB/ZZ72URKKeMmn2jWcmy/dB2pw4UTCyNm3oa87q/1EZ2liDoNY1Qw+K9usYri/KQ+4QoatoZn/Xrf2Fli0WUB30IU4bWKpHVy800YwPfwB2M5JPmV2z8UGt5Nhs+jG8vvrm6XPK6y1mq/sW2ne42L5q8n5pMgGyf/xE+cui75idz8QoLhcmFjVL/mN7iw8vSNjaho4L1Z/fBrIoSLFNXUp7/s/+YPARugJFgnBVL+1y49AYk/vYRIlHg4ey4fB5ztQicK6UO21kF9Eq869iZUJPKiRTpSvJ1yC4MIqS7QL/1rYY6jKDlkJxXMlqbkRRCa/lH3C+xidafCceCcs9Eb5zdkKWUWnvF9mW8kI4V04yz8Y26CIsOAORbfuumGd7wsBKIAXtsrdZVvaXtuUMBhFBhpC5p1cqZvO5iQXRfMF1dCNIOLZ6nZ5gxTE6xs4n8cJ+9Sqd+gMeq8lA6eCPmHCs48+IThqty+PQW6dkOQoeXSOkvPydFLViZhIYPevZJBKgZBCAvDw4ZtPctyH2EFsOobrerO/99ygsw/zhVvyD/L9xU+UQdQWbd11DEtvniNoW1H2zwhHU2bMDrdYxm9FAq2mCR8nGlQUd2cvgEkJbPrnZCwdkzAtig9klMxN6KNkwg4six+aZlstL8hCmtzjkCj0JTwOFwKmezBNSAoAmwXEDHHMkwRQtjiyJHoOz8CVHXf8+EXPQcK3gxKiVzUnsdUTeO2T/N3Txm/JERWLu+AAzcqSNXjbhz4v0gS1y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Nov 7, 2025 at 5:23 PM UTC, Nikita Kalyazin wrote:
>
>
> On 07/11/2025 15:54, Brendan Jackman wrote:
>> On Wed Sep 24, 2025 at 3:10 PM UTC, Patrick Roy wrote:
>>> From: Patrick Roy <roypat@amazon.co.uk>
>>>
>>> [ based on kvm/next ]
>>>
>>> Unmapping virtual machine guest memory from the host kernel's direct map is a
>>> successful mitigation against Spectre-style transient execution issues: If the
>>> kernel page tables do not contain entries pointing to guest memory, then any
>>> attempted speculative read through the direct map will necessarily be blocked
>>> by the MMU before any observable microarchitectural side-effects happen. This
>>> means that Spectre-gadgets and similar cannot be used to target virtual machine
>>> memory. Roughly 60% of speculative execution issues fall into this category [1,
>>> Table 1].
>>>
>>> This patch series extends guest_memfd with the ability to remove its memory
>>> from the host kernel's direct map, to be able to attain the above protection
>>> for KVM guests running inside guest_memfd.
>>>
>>> Additionally, a Firecracker branch with support for these VMs can be found on
>>> GitHub [2].
>>>
>>> For more details, please refer to the v5 cover letter [v5]. No
>>> substantial changes in design have taken place since.
>>>
>>> === Changes Since v6 ===
>>>
>>> - Drop patch for passing struct address_space to ->free_folio(), due to
>>>    possible races with freeing of the address_space. (Hugh)
>>> - Stop using PG_uptodate / gmem preparedness tracking to keep track of
>>>    direct map state.  Instead, use the lowest bit of folio->private. (Mike, David)
>>> - Do direct map removal when establishing mapping of gmem folio instead
>>>    of at allocation time, due to impossibility of handling direct map
>>>    removal errors in kvm_gmem_populate(). (Patrick)
>>> - Do TLB flushes after direct map removal, and provide a module
>>>    parameter to opt out from them, and a new patch to export
>>>    flush_tlb_kernel_range() to KVM. (Will)
>>>
>>> [1]: https://download.vusec.net/papers/quarantine_raid23.pdf
>>> [2]: https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
>> 
>> I just got around to trying this out, I checked out this patchset using
>> its base-commit and grabbed the Firecracker branch. Things seem OK until
>> I set the secrets_free flag in the Firecracker config which IIUC makes
>> it set GUEST_MEMFD_FLAG_NO_DIRECT_MAP.
>> 
>> If I set it, I find the guest doesn't show anything on the console.
>> Running it in a VM and attaching GDB suggests that it's entering the
>> guest repeatedly, it doesn't seem like the vCPU thread is stuck or
>> anything. I'm a bit clueless about how to debug that (so far, whenever
>> I've broken KVM, things always exploded very dramatically).
>> 
>> Anyway, if I then kill the firecracker process, the host sometimes
>> crashes, I think this is the most suggestive splat I've seen:
>> 
>> [   99.673420][    T2] BUG: unable to handle page fault for address: ffff888012804000
>> [   99.676216][    T2] #PF: supervisor write access in kernel mode
>> [   99.678381][    T2] #PF: error_code(0x0002) - not-present page
>> [   99.680499][    T2] PGD 2e01067 P4D 2e01067 PUD 2e02067 PMD 12801063 PTE 800fffffed7fb020
>> [   99.683374][    T2] Oops: Oops: 0002 [#1] SMP
>> [   99.685004][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Not tainted 6.17.0-rc7-00366-g473c46a3cb2a #106 NONE
>> [   99.688514][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.1 11/11/2019
>> [   99.691547][    T2] RIP: 0010:clear_page_erms+0x7/0x10
>> [   99.693440][    T2] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 c3 0f 1f 80 00 00 00 00 b9 00 10 00 00 31 c0 <f3> aa c3 66 0f 1f 44 00 00 48 83 f9 40 73 2a 83 f9 08 73 0f 85 c9
>> [   99.700188][    T2] RSP: 0018:ffff88800318fc10 EFLAGS: 00010246
>> [   99.702321][    T2] RAX: 0000000000000000 RBX: 0000000000400dc0 RCX: 0000000000001000
>> [   99.705100][    T2] RDX: ffffea00004a0100 RSI: ffffea00004a0200 RDI: ffff888012804000
>> [   99.707861][    T2] RBP: 0000000000000801 R08: 0000000000000000 R09: 0000000000000000
>> [   99.710648][    T2] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
>> [   99.713412][    T2] R13: 0000000000000801 R14: ffffea00004a0100 R15: ffffffff81f4df80
>> [   99.716191][    T2] FS:  0000000000000000(0000) GS:ffff8880bbf28000(0000) knlGS:0000000000000000
>> [   99.719316][    T2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   99.721648][    T2] CR2: ffff888012804000 CR3: 0000000007583001 CR4: 0000000000372eb0
>> [   99.724421][    T2] Call Trace:
>> [   99.725608][    T2]  <TASK>
>> [   99.726646][    T2]  get_page_from_freelist+0x6fe/0x14b0
>> [   99.728583][    T2]  ? fs_reclaim_acquire+0x43/0xe0
>> [   99.730325][    T2]  ? find_held_lock+0x2b/0x80
>> [   99.731965][    T2]  __alloc_frozen_pages_noprof+0x147/0x2d0
>> [   99.734003][    T2]  __alloc_pages_noprof+0x5/0x50
>> [   99.735766][    T2]  copy_process+0x1b1/0x1b30
>> [   99.737398][    T2]  ? lock_is_held_type+0x89/0x100
>> [   99.739157][    T2]  ? kthreadd+0x25/0x190
>> [   99.740664][    T2]  kernel_clone+0x59/0x390
>> [   99.742213][    T2]  ? kthreadd+0x25/0x190
>> [   99.743728][    T2]  kernel_thread+0x55/0x70
>> [   99.745310][    T2]  ? kthread_complete_and_exit+0x20/0x20
>> [   99.747265][    T2]  kthreadd+0x117/0x190
>> [   99.748748][    T2]  ? kthread_is_per_cpu+0x30/0x30
>> [   99.750509][    T2]  ret_from_fork+0x16b/0x1e0
>> [   99.752193][    T2]  ? kthread_is_per_cpu+0x30/0x30
>> [   99.753992][    T2]  ret_from_fork_asm+0x11/0x20
>> [   99.755717][    T2]  </TASK>
>> [   99.756861][    T2] CR2: ffff888012804000
>> [   99.758353][    T2] ---[ end trace 0000000000000000 ]---
>> [   99.760319][    T2] RIP: 0010:clear_page_erms+0x7/0x10
>> [   99.762209][    T2] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 c3 0f 1f 80 00 00 00 00 b9 00 10 00 00 31 c0 <f3> aa c3 66 0f 1f 44 00 00 48 83 f9 40 73 2a 83 f9 08 73 0f 85 c9
>> [   99.769129][    T2] RSP: 0018:ffff88800318fc10 EFLAGS: 00010246
>> [   99.771297][    T2] RAX: 0000000000000000 RBX: 0000000000400dc0 RCX: 0000000000001000
>> [   99.774126][    T2] RDX: ffffea00004a0100 RSI: ffffea00004a0200 RDI: ffff888012804000
>> [   99.777013][    T2] RBP: 0000000000000801 R08: 0000000000000000 R09: 0000000000000000
>> [   99.779827][    T2] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
>> [   99.782641][    T2] R13: 0000000000000801 R14: ffffea00004a0100 R15: ffffffff81f4df80
>> [   99.785487][    T2] FS:  0000000000000000(0000) GS:ffff8880bbf28000(0000) knlGS:0000000000000000
>> [   99.788671][    T2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   99.791012][    T2] CR2: ffff888012804000 CR3: 0000000007583001 CR4: 0000000000372eb0
>> [   99.793863][    T2] Kernel panic - not syncing: Fatal exception
>> [   99.796760][    T2] Kernel Offset: disabled
>> [   99.798296][    T2] ---[ end Kernel panic - not syncing: Fatal exception ]---
>> 
>> This makes me suspect the kvm_gmem_folio_restore_direct_map() path isn't
>> working or isn't getting called.
>> 
>> If anyone wants help trying to reproduce this let me know.
>
> Hi Brendan,
>
> Thanks for trying to run it!
>
> Just as a sanity check, the way it is known for us to work is we apply 
> all patches from [1].  For booted VMs (as opposed to restored from 
> snapshot), apart from the v6 of the direct map removal series, the only 
> additional patch is a fix for kvmclock on x86 [2].  Please let me know 
> if you see the same issue with that patch applied too.
>
> Nikita
>
> [1] 
> https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding/resources/hiding_ci/linux_patches
> [2] 
> https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding/resources/hiding_ci/linux_patches/11-kvm-clock

Ah, thanks! Seems I should have checked my inbox before sending my other
mail. With the kvmclock fix applied to my host kernel, I start setting
the other crash immediately when the VM boots. If I comment out the
actual unmapping of memory, it boots (before, it wouldn't boot even with
that commented out).

For the other linux_patches, I couldn't apply them on top of this
series, do you have a branch I can use as a reference?

Anyway, the solution I'm hoping to present for your problem gets rid of
that explicit unmapping code (the allocator will do it for you), so in
the meantime I have something I can work with.

