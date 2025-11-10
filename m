Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BE42CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:36:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C69818E000B; Mon, 10 Nov 2025 10:36:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19E38E0006; Mon, 10 Nov 2025 10:36:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0FAB8E000B; Mon, 10 Nov 2025 10:36:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 963808E0006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:36:22 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 357EF138DC2
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:36:22 +0000 (UTC)
X-FDA: 84095099004.26.AFC6F54
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 353AC180005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:36:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qEjArPmF;
	spf=pass (imf06.hostedemail.com: domain of 3cgYSaQgKCBc6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3cgYSaQgKCBc6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762788980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GaWutXseEM49NYYHvmu1piLSnNhRd63IQT+QthHzxAo=;
	b=3xy4J/KjBEawg0YJ//dr5sWLyTR/0ur+vQfdUxQzCQ60XFcRx2rRn7qyp3g3aneVASjwm8
	PFzzLUYsbRYLnvVqsgDKjlfZ4mvMa2d+8oriesu9UKclgcKXhDHqZowhdcSpULbPpNELeo
	3LjJHaHSyRRp6i+fN/ylghoU9dvcj/g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762788980; a=rsa-sha256;
	cv=none;
	b=1521olJXzIWvGc2XnsedWgiguqFG1MrcX1N9cl2RpKyektYuMBFi43cea2OFWdC2pGP+5M
	ti6EKiLM0euYbGXigjaln6FGnf9OFf4eTkbR0IeYOIP9uvnRh/ruTloh1ch+Ha3IGawEva
	VANR3qy9cK4z4WjNTv7Rrp/yC7hCpPM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qEjArPmF;
	spf=pass (imf06.hostedemail.com: domain of 3cgYSaQgKCBc6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3cgYSaQgKCBc6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b726760acb7so427147066b.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762788978; x=1763393778; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GaWutXseEM49NYYHvmu1piLSnNhRd63IQT+QthHzxAo=;
        b=qEjArPmF9KRYkN1W4ImBG37Z0nIvBnavUt32orEKVgQ6UNz+geN+em4seKMNaxMInd
         t4zuzcdyndXYycVzwDjSpBqNfNlYpkQOkxFpICpXDEx9hufdhen6PFqwWFtzomD0oB9w
         h76YyRXEGaJLC4EdPFyq61MAXQAamN4ohKJ5xcod2s/MSDbBOz7DtxSc2EAnV3eH9zcq
         Req5+CDTGfICzBKF9XIPX+epze4GM/l75wjq495TtRPrMu2SIXSBiOzTGCasHfoDbAd9
         kgZQang3ULp1v42mnCHyoXciEOwdf5zg/MvYQInNFwKVj9SkiBnouyyWM8ymG5v17l6T
         ifZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762788978; x=1763393778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GaWutXseEM49NYYHvmu1piLSnNhRd63IQT+QthHzxAo=;
        b=IG/oIXOLS8XMuHZujXDbYlKlaCyu51eukGIsDbrcaVKNoAw0hbKeXfqOxkBVXfmNCG
         fCUkHV0wAv71dCj1PW220TPNU3ggo5MXLFbi96krWEr5wXx9CEeSH5hzMFToAwVyNaZV
         J8skWcCYrntTPzF/sBOkwhyia2G6fsAIpPSwJ2SWLFeck+MOge1PUglKpyECYZJ6m50o
         LMjnZGVK7t7oA5xZLsMYD2MT5vwAXhFWhTPaE9Ln68PplEzN4Ixg+VavZgmOWUTH/z30
         YgRHeFmJpkrm/1/AU7sa4liklWfO/HHbTsQpeLP/tTA/wpeg87gChUavyQPhwfWlNl0n
         AQ9A==
X-Forwarded-Encrypted: i=1; AJvYcCWWhH5e4gu8HQbSdY6gIeaOWDjYUbo0vPpZmD1B6jrfllbDQkQPiX78QISpK/jjWKCOC1XYcwtsAQ==@kvack.org
X-Gm-Message-State: AOJu0Yw89kqUYrwY++WTTNphhlrkW73pYnbbInJ7wfGLufjehsExuAcX
	FJPYFf5s+21wlh5GyOrfIhvCpOxpkoTNcmbuaXnR8yJuDOgrUxzq+kgonffQ6RH2M6Cbdd2SlVT
	P2xy2UanagN6q4Q==
X-Google-Smtp-Source: AGHT+IHTU5FXzUFeb1nI9cPK796M7PgT3DwXYMV5kcA8PjpI6OADg2Z/FZfwu9WOGlr1GmkIIQ0Qzc++hauFnA==
X-Received: from ejcsq16.prod.google.com ([2002:a17:907:3890:b0:b72:b433:246f])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:72c5:b0:b70:be84:5183 with SMTP id a640c23a62f3a-b72e0591830mr875999666b.60.1762788978060;
 Mon, 10 Nov 2025 07:36:18 -0800 (PST)
Date: Mon, 10 Nov 2025 15:36:17 +0000
In-Reply-To: <a940044f-3ae4-451f-b9ba-946ec6df5082@amazon.com>
Mime-Version: 1.0
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
 <DE2L1SAOC55E.E4JY62WJQ2A8@google.com> <add94932-290c-4037-b4e6-c3c760240819@amazon.com>
 <DE2NTMZXQ1MT.2TH9VAKM6WP6I@google.com> <a940044f-3ae4-451f-b9ba-946ec6df5082@amazon.com>
X-Mailer: aerc 0.21.0
Message-ID: <DE54JGHVJ4QH.KW6CD73R58AU@google.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 353AC180005
X-Stat-Signature: ou655ucnaph4ubtruzcrhwrs1skaqrp9
X-Rspam-User: 
X-HE-Tag: 1762788979-804391
X-HE-Meta: U2FsdGVkX18sLC+EjGvvvQ1f/KYr8tfZbXz7/YjWZAGycefvsqeAmzFPWgpqnvZTO5WoelGLvZj0DcrCIB8niknTB3PTECHlwulmxiWhwrJsVtaZzMNAoXILq0v0fn3bAF/rObCPwLc4vZq8tSnr6Nx93XtkDBu0r4ntjVjJCQmHB221MnIst/5F3+OEy9DaLe1oAM3CsHetsta9n5nvNBYGjo2yRt1lN7R63/ZAQvS8B1rTJBazHqydtqoRLJ9kWTAC7+RGNdH3tlilFPBM3PYRhC+RR/8BxcBI8RvQyZH8EKzLXNMpp06vYIfxUPX5e+BGoUg60EHj6sP3ye1DOpZWD4DDINvsDTA6ou7/rwmN0AV8DgvVDr8BbnP2jM4aT7IHeJsQOtSo81P7djdFt0v8ZHdbwo1knNFeG8KE7NCDO2+iQKU1QD35u1FvbCW1jpEXlyuV5rUnxg4RKZvHlkbVm1z00vBrpHRA1PevWNxLrsdn6iTCDPxFBIt7eTwthv93vn5i4a16vsv+1A+2Z3VL3rAOK6CgyOWVfEWlOJHgsg98OjBX9WzkqOnAVhW7CAEkO3BRkx0TvkQ2kP88qoYv100fv5qr3Xpia/+e4X0phST0yi7VxLt6zTNFmgo2Exf2My8vbKCReZXYgeUEYXH/XymcTBpyExbATP8/GOtxIBHki0Q7WnZvRHIoIhrE4jUOE1alBAgqbBjXEZ4XCpzfrsl/IScZtkdWq3M8ufa05MItaRw37tzdT/wQ2CvLdnaUWJJns2dK3CeEJnB1PQ4zHdcZfxpTe3S6Liiw7ElxlO81Wh53n5za4Vp13a9CUNQIvh2E8a771+s+4rqJl9DtFHcZgjtnp1JSwYGGt7uVa6D0FQrCAlmoHQ5aoD570Cc1uco7Ce5DAqJ0yLpHeuwBL3DyZZko0GP6rgcBYphc+HtwCtcUCP8v6hrgmZEjcblX6+Hjq4s1Cgjnz3u
 Qm96KQHw
 r1B7gstYUcToYcrWyEeBkL3GfufsJ8zcIN3A1s1+rpvm04JSKbK8Wov7MAuoDNiWM6Df9zN+21zv3JZyEW74r6ucGY/KHXtriUeQDtOFzk84Yhrr02Qb0gG+tQ6NqaTuP5CJY1m3/4u4oHm0Hoeoi4be4SAL3WZGfb2MxLHXMEtU2Qc85aByu3nO0yvCjG8pyRDMxFKxTbN52THgbEsnbL3CUO0TM2+4CHUKp+PdYWn1gYX20dAmgBhn7GRbToSj5Ov3dd23k3BM7b8hc+pKpqKsExD6qY50PamHJJkUdtWArrRQZ1qBP1z4lzYoxZgWXMcGWEf7lbTQgy871ccUpbJea5drjXmki32uHsacA8rryJMK7Yq8kwnhZn14+DGktJ9ukMGEpiCU8RmeoVgqzLXSc8D4moCgXlJiw+EKruCoFi5eah2dc1/QpFSml86DB8oeF824FiWLXaB46HjJOzaki9H/M7EEl+oZZcwTgrBmc8suzDiizOf63RDMNi17vrJJ8e2jh+kzX0jnz4/pBwYZEK6gHOhqoXQNq0nMv8rZDQeXNc1G05ogRGvh5pxUE2lCuPGyQw3OsUL+yHsgn91PsTCmvjXNMY/+R3h9Uu6+GVMOa1AyLHJ0+m/sBq6jAhBo3BYRy7ZZ5JBvO9RWncihvFsvxlKxbZqt2eYN4kcUpcW+Jcu68mD+I+VI1fWO+Un6gQE3ENEdFfih62WtTp5G57OLy/+pqc+XdiDBelp8bFykhTKqcLHAhafJ7gHbBX+iDeYJwaygJDgUuiGzRVx+kPkmZidNxlbHmZJJ3Tafxd5b9laCySRY0pHX4jyicrQgdwSKabhBsdNq8IOEpozI6up/4CSUyvnsUOmIKbt2tcCtspfT5XE5+hlmdWYVQTgv1FAt2aOQ42RKBRuODnV3cjL//cXk4nEsGBCNCh4wUI+a7exyvSGtMjCyG9KKSqVTh9PkIEWHqZi1lBmqC/hAuoyXR
 VfYrJjEj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Nov 7, 2025 at 6:11 PM UTC, Nikita Kalyazin wrote:
>
>
> On 07/11/2025 18:04, Brendan Jackman wrote:
>> On Fri Nov 7, 2025 at 5:23 PM UTC, Nikita Kalyazin wrote:
>>>
>>>
>>> On 07/11/2025 15:54, Brendan Jackman wrote:
>>>> On Wed Sep 24, 2025 at 3:10 PM UTC, Patrick Roy wrote:
>>>>> From: Patrick Roy <roypat@amazon.co.uk>
>>>>>
>>>>> [ based on kvm/next ]
>>>>>
>>>>> Unmapping virtual machine guest memory from the host kernel's direct map is a
>>>>> successful mitigation against Spectre-style transient execution issues: If the
>>>>> kernel page tables do not contain entries pointing to guest memory, then any
>>>>> attempted speculative read through the direct map will necessarily be blocked
>>>>> by the MMU before any observable microarchitectural side-effects happen. This
>>>>> means that Spectre-gadgets and similar cannot be used to target virtual machine
>>>>> memory. Roughly 60% of speculative execution issues fall into this category [1,
>>>>> Table 1].
>>>>>
>>>>> This patch series extends guest_memfd with the ability to remove its memory
>>>>> from the host kernel's direct map, to be able to attain the above protection
>>>>> for KVM guests running inside guest_memfd.
>>>>>
>>>>> Additionally, a Firecracker branch with support for these VMs can be found on
>>>>> GitHub [2].
>>>>>
>>>>> For more details, please refer to the v5 cover letter [v5]. No
>>>>> substantial changes in design have taken place since.
>>>>>
>>>>> === Changes Since v6 ===
>>>>>
>>>>> - Drop patch for passing struct address_space to ->free_folio(), due to
>>>>>     possible races with freeing of the address_space. (Hugh)
>>>>> - Stop using PG_uptodate / gmem preparedness tracking to keep track of
>>>>>     direct map state.  Instead, use the lowest bit of folio->private. (Mike, David)
>>>>> - Do direct map removal when establishing mapping of gmem folio instead
>>>>>     of at allocation time, due to impossibility of handling direct map
>>>>>     removal errors in kvm_gmem_populate(). (Patrick)
>>>>> - Do TLB flushes after direct map removal, and provide a module
>>>>>     parameter to opt out from them, and a new patch to export
>>>>>     flush_tlb_kernel_range() to KVM. (Will)
>>>>>
>>>>> [1]: https://download.vusec.net/papers/quarantine_raid23.pdf
>>>>> [2]: https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
>>>>
>>>> I just got around to trying this out, I checked out this patchset using
>>>> its base-commit and grabbed the Firecracker branch. Things seem OK until
>>>> I set the secrets_free flag in the Firecracker config which IIUC makes
>>>> it set GUEST_MEMFD_FLAG_NO_DIRECT_MAP.
>>>>
>>>> If I set it, I find the guest doesn't show anything on the console.
>>>> Running it in a VM and attaching GDB suggests that it's entering the
>>>> guest repeatedly, it doesn't seem like the vCPU thread is stuck or
>>>> anything. I'm a bit clueless about how to debug that (so far, whenever
>>>> I've broken KVM, things always exploded very dramatically).
>>>>
>>>> Anyway, if I then kill the firecracker process, the host sometimes
>>>> crashes, I think this is the most suggestive splat I've seen:
>>>>
>>>> [   99.673420][    T2] BUG: unable to handle page fault for address: ffff888012804000
>>>> [   99.676216][    T2] #PF: supervisor write access in kernel mode
>>>> [   99.678381][    T2] #PF: error_code(0x0002) - not-present page
>>>> [   99.680499][    T2] PGD 2e01067 P4D 2e01067 PUD 2e02067 PMD 12801063 PTE 800fffffed7fb020
>>>> [   99.683374][    T2] Oops: Oops: 0002 [#1] SMP
>>>> [   99.685004][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Not tainted 6.17.0-rc7-00366-g473c46a3cb2a #106 NONE
>>>> [   99.688514][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.1 11/11/2019
>>>> [   99.691547][    T2] RIP: 0010:clear_page_erms+0x7/0x10
>>>> [   99.693440][    T2] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 c3 0f 1f 80 00 00 00 00 b9 00 10 00 00 31 c0 <f3> aa c3 66 0f 1f 44 00 00 48 83 f9 40 73 2a 83 f9 08 73 0f 85 c9
>>>> [   99.700188][    T2] RSP: 0018:ffff88800318fc10 EFLAGS: 00010246
>>>> [   99.702321][    T2] RAX: 0000000000000000 RBX: 0000000000400dc0 RCX: 0000000000001000
>>>> [   99.705100][    T2] RDX: ffffea00004a0100 RSI: ffffea00004a0200 RDI: ffff888012804000
>>>> [   99.707861][    T2] RBP: 0000000000000801 R08: 0000000000000000 R09: 0000000000000000
>>>> [   99.710648][    T2] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
>>>> [   99.713412][    T2] R13: 0000000000000801 R14: ffffea00004a0100 R15: ffffffff81f4df80
>>>> [   99.716191][    T2] FS:  0000000000000000(0000) GS:ffff8880bbf28000(0000) knlGS:0000000000000000
>>>> [   99.719316][    T2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> [   99.721648][    T2] CR2: ffff888012804000 CR3: 0000000007583001 CR4: 0000000000372eb0
>>>> [   99.724421][    T2] Call Trace:
>>>> [   99.725608][    T2]  <TASK>
>>>> [   99.726646][    T2]  get_page_from_freelist+0x6fe/0x14b0
>>>> [   99.728583][    T2]  ? fs_reclaim_acquire+0x43/0xe0
>>>> [   99.730325][    T2]  ? find_held_lock+0x2b/0x80
>>>> [   99.731965][    T2]  __alloc_frozen_pages_noprof+0x147/0x2d0
>>>> [   99.734003][    T2]  __alloc_pages_noprof+0x5/0x50
>>>> [   99.735766][    T2]  copy_process+0x1b1/0x1b30
>>>> [   99.737398][    T2]  ? lock_is_held_type+0x89/0x100
>>>> [   99.739157][    T2]  ? kthreadd+0x25/0x190
>>>> [   99.740664][    T2]  kernel_clone+0x59/0x390
>>>> [   99.742213][    T2]  ? kthreadd+0x25/0x190
>>>> [   99.743728][    T2]  kernel_thread+0x55/0x70
>>>> [   99.745310][    T2]  ? kthread_complete_and_exit+0x20/0x20
>>>> [   99.747265][    T2]  kthreadd+0x117/0x190
>>>> [   99.748748][    T2]  ? kthread_is_per_cpu+0x30/0x30
>>>> [   99.750509][    T2]  ret_from_fork+0x16b/0x1e0
>>>> [   99.752193][    T2]  ? kthread_is_per_cpu+0x30/0x30
>>>> [   99.753992][    T2]  ret_from_fork_asm+0x11/0x20
>>>> [   99.755717][    T2]  </TASK>
>>>> [   99.756861][    T2] CR2: ffff888012804000
>>>> [   99.758353][    T2] ---[ end trace 0000000000000000 ]---
>>>> [   99.760319][    T2] RIP: 0010:clear_page_erms+0x7/0x10
>>>> [   99.762209][    T2] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 c3 0f 1f 80 00 00 00 00 b9 00 10 00 00 31 c0 <f3> aa c3 66 0f 1f 44 00 00 48 83 f9 40 73 2a 83 f9 08 73 0f 85 c9
>>>> [   99.769129][    T2] RSP: 0018:ffff88800318fc10 EFLAGS: 00010246
>>>> [   99.771297][    T2] RAX: 0000000000000000 RBX: 0000000000400dc0 RCX: 0000000000001000
>>>> [   99.774126][    T2] RDX: ffffea00004a0100 RSI: ffffea00004a0200 RDI: ffff888012804000
>>>> [   99.777013][    T2] RBP: 0000000000000801 R08: 0000000000000000 R09: 0000000000000000
>>>> [   99.779827][    T2] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
>>>> [   99.782641][    T2] R13: 0000000000000801 R14: ffffea00004a0100 R15: ffffffff81f4df80
>>>> [   99.785487][    T2] FS:  0000000000000000(0000) GS:ffff8880bbf28000(0000) knlGS:0000000000000000
>>>> [   99.788671][    T2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> [   99.791012][    T2] CR2: ffff888012804000 CR3: 0000000007583001 CR4: 0000000000372eb0
>>>> [   99.793863][    T2] Kernel panic - not syncing: Fatal exception
>>>> [   99.796760][    T2] Kernel Offset: disabled
>>>> [   99.798296][    T2] ---[ end Kernel panic - not syncing: Fatal exception ]---
>>>>
>>>> This makes me suspect the kvm_gmem_folio_restore_direct_map() path isn't
>>>> working or isn't getting called.
>>>>
>>>> If anyone wants help trying to reproduce this let me know.
>>>
>>> Hi Brendan,
>>>
>>> Thanks for trying to run it!
>>>
>>> Just as a sanity check, the way it is known for us to work is we apply
>>> all patches from [1].  For booted VMs (as opposed to restored from
>>> snapshot), apart from the v6 of the direct map removal series, the only
>>> additional patch is a fix for kvmclock on x86 [2].  Please let me know
>>> if you see the same issue with that patch applied too.
>>>
>>> Nikita
>>>
>>> [1]
>>> https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding/resources/hiding_ci/linux_patches
>>> [2]
>>> https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding/resources/hiding_ci/linux_patches/11-kvm-clock
>> 
>> Ah, thanks! Seems I should have checked my inbox before sending my other
>> mail. With the kvmclock fix applied to my host kernel, I start setting
>> the other crash immediately when the VM boots. If I comment out the
>> actual unmapping of memory, it boots (before, it wouldn't boot even with
>> that commented out).
>> 
>> For the other linux_patches, I couldn't apply them on top of this
>> series, do you have a branch I can use as a reference?
>
> Instead of having an explicit branch, we apply all the patches on top of 
> [1].  There is a script that performs fetch/build/install end-to-end: [2].
>
> [1] 
> https://github.com/firecracker-microvm/firecracker/blob/feature/secret-hiding/resources/hiding_ci/kernel_commit_hash
> [2] 
> https://github.com/firecracker-microvm/firecracker/blob/feature/secret-hiding/resources/hiding_ci/build_and_install_kernel.sh

Thanks, I was able to construct a branch and confirm the crashes go
away. I guess this should block merging the feature though, right? Do
you know which particular of the patches are the likely relevant ones
here?

