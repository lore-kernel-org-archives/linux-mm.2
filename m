Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91AFCCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 17:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5558E0013; Fri,  7 Nov 2025 12:23:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9CA18E0002; Fri,  7 Nov 2025 12:23:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB3198E0013; Fri,  7 Nov 2025 12:23:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CAC228E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:23:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 93B1914034F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:23:58 +0000 (UTC)
X-FDA: 84084483756.20.1F57B0B
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2A4B0140004
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:23:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=JJfX9uo0;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf09.hostedemail.com: domain of "prvs=399a1bf2f=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=399a1bf2f=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762536236; a=rsa-sha256;
	cv=none;
	b=gwET1Ic5+3VEN6zShBiRm8VARSH83LLuc52Os3I+aAPM92oCEwxKx5+FQ16AIKO6xINxBl
	XMdksQ/AWDsARXSTMd2hyQ47ttTLe/1WGgmIX/SDLB8OKyzLa9wzmIa7WmlKKur9Qqfxe+
	9jd1PNTDesGOFEaGRP1Vc4ccw57f/cU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=JJfX9uo0;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf09.hostedemail.com: domain of "prvs=399a1bf2f=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=399a1bf2f=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762536236;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o6wcqFFajh7A/LsdWzRuMS1HeEL9V3ml4dPEALpSF3E=;
	b=E6dx///acZCBHHihF5iQxvwksdbnlmqV8rc5CYsxLh0/69wHSgWLKaW9Th/gBf4svN69zJ
	kTG6bM7SKl4RY7pvnZWfuagLLdDqET/SDq6ZbkhoOI3rQ8J+BcSqLjJnp7+duKgPxJQJYW
	IUJ43RlL71iaOtor1fklShqneDl+5LA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1762536236; x=1794072236;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=o6wcqFFajh7A/LsdWzRuMS1HeEL9V3ml4dPEALpSF3E=;
  b=JJfX9uo0UoKoWEHIlZN3Z33VEX09JpZfYbcaDbCUKhaGCV+BBe+byXcO
   GyVma2Ca4EbMCkWPn1mjYf6TgTzGLXrGwnEMD5AfDZ6Kb6Q+n1Ag5xH1/
   VEp2vB+3gGtXJmkUEa6++Yrgs2WWw2fxleQ20w3t1WHrzhOOykjTFCq0M
   0QA2187lnm0XL+ztjmdzI2YT7lfnOA1Nqb6CxwIzHcxvJ3kk1HYEiKk+Y
   R6dQBGHSbbu8/cbmQafNCwvvXT6a786C+/xqznRyk3Vup3s9C8e2tNnJa
   O/SdTW4hdBmK892w1uo0nH0xmLXUMOtK/CjcoXiFjyLA0VK996EjWQqB7
   w==;
X-CSE-ConnectionGUID: hWjyRCz+SZyv1J236BTcDQ==
X-CSE-MsgGUID: J4rqY35IROKEYxpnVVSXaA==
X-IronPort-AV: E=Sophos;i="6.19,287,1754956800"; 
   d="scan'208";a="4849373"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 17:23:54 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:28723]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.11.74:2525] with esmtp (Farcaster)
 id 5bb66a71-c62c-4d84-9175-7e585abc3994; Fri, 7 Nov 2025 17:23:54 +0000 (UTC)
X-Farcaster-Flow-ID: 5bb66a71-c62c-4d84-9175-7e585abc3994
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 7 Nov 2025 17:23:53 +0000
Received: from [192.168.9.244] (10.106.83.15) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Fri, 7 Nov 2025
 17:23:50 +0000
Message-ID: <add94932-290c-4037-b4e6-c3c760240819@amazon.com>
Date: Fri, 7 Nov 2025 17:23:49 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v7 00/12] Direct Map Removal Support for guest_memfd
To: Brendan Jackman <jackmanb@google.com>
CC: <pbonzini@redhat.com>, <corbet@lwn.net>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <song@kernel.org>,
	<jolsa@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
	<andrii@kernel.org>, <martin.lau@linux.dev>, <eddyz87@gmail.com>,
	<yonghong.song@linux.dev>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
	<sdf@fomichev.me>, <haoluo@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <shuah@kernel.org>, <seanjc@google.com>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <bpf@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <xmarcalx@amazon.co.uk>,
	<kalyazin@amazon.co.uk>, <jackabt@amazon.co.uk>, <derekmn@amazon.co.uk>,
	<tabba@google.com>, <ackerleytng@google.com>, Patrick Roy
	<patrick.roy@campus.lmu.de>
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
 <DE2L1SAOC55E.E4JY62WJQ2A8@google.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <DE2L1SAOC55E.E4JY62WJQ2A8@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.15]
X-ClientProxiedBy: EX19D002EUA001.ant.amazon.com (10.252.50.66) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)
X-Rspamd-Queue-Id: 2A4B0140004
X-Rspamd-Server: rspam07
X-Stat-Signature: h84uxe6kmqke4f7prnt6oimrtd9ugcp9
X-Rspam-User: 
X-HE-Tag: 1762536235-755694
X-HE-Meta: U2FsdGVkX18hr6naq16X4f9BIPBkqZG44kXUmZBQIy1QvW9JZW4VSJwHHx3AsGOTVnxRMXJBhvCMaPkoWywrLyLFYssy/raM5T09sBILulm+vbVxVpDgf+UPV6eg7U6ahCGnq+kyDB0r4YKPSxKdGkY/J0720jTwWiQv5IYBgHOLz47FAzUJPS7IH4J4Q8ulk00m3qfbe6MJX7KE9uGIRGqIrVNdlRy1VIPP5LnKiihPgT16Ow8y4/x66Wpx0DnF3uCx5ROP6Wq72mjbF1fyXKgHQaUFi+CFqPMgHgmKMSfx1vBBXs2sSbJmka2sTVeBmv+R3PymKQFK8YwWc1SFandjDhMvPU5BuDJ5U1AFMO1chpegCSfBP+BcGASoT32O5udVvCBbDN+wNMT5g2coxkZgC5tV57s4hqmxtDDi0ekbRk3IEBjsdmsE4h/JHZZALnML+nyDS/5d/Xp8pP4wn5X5SDfIP0yrv/94tL4kw4O2JBtwGSpNaIE9TbKCMoMT/Lpv6FWb50GzBVzsCwUYfnExM0vi4xrUE8UQhtk8JF7U4P0UQTkg6TuoUa/D/XaCI/LY/wEaA7+uIs0cGgMJxTmEJrBNi2+W28TWaTYV8nsb8yn4fHkQ8uD+VHl1YmVwZ6PQWTuu/0/DYqfL5T2S9hZ4fc+8jHRTz5ZETl8cFy999uZoAAZndG/i71HiJ0TcowhJdNp+Zwe+GYl7r8x/bRDaTZ5JY/C3al+xrWDeQx2N5kE9/zrvDdS19Lba6ZPiM/kIo3LrMaaTQUqLTrJr/1uD+NxHzxA61jPX0+ofF2i5h7LmjZF8QfHo3sMh3LbeFt4heMH+g5UFS4GKXa86OV9cvT3m5f5AiDyGFZg6FGzX229FY+zwYjD923OKhO/ngVnavdMIBeGu/Ioc0eClpwgvyj6aaShkM7KQn+D6+jOgYDur4B6OG/oIIWmHuLDRIb3u3tGG0QizyUwlEjg
 QVJT6y+X
 bUS7N0MBtALrmx5XRorutrZK1ryv4qv9CC0EpHQeoHDQO63A+qdrR/9zRz7dgXCeUXGps0WfVdGUT9NjQjR1hztexHcdXZK71j8R06eEUSwATL9PydvK9Hsz68BIu+90cBsdARqwy2+0CuPx/1pzjW+KAwsOcR4MiDp42kWv0J1HLmKV5obwuzsnLvAmsB2j/0HDgaRMwq9iz9dLSK5H5OP83SuOeEIaNnVUDEuoRyFlT/+MALFuGZqEIEOjevLy7cYic2FItcKnxILmQ5RF0phjNrEL+8aYs5E3Ed+iHwInsQ9Hd+M0TLbK2Hd5axjgEGxAtJWgxZI4YSbJsjLXRfTfFArUCQbGdxmX6K5VPzCnGPBS1RxHBDrAQs76CgtTJotGzQpOoO3naXmEj0lJ6HLVhe8HMb/f88/SX+aE5+XkuM2JYJcE6pjuzxsp9xV0deNMugIBG/xOO8lOI3yecOaCagkKPO40GoRk+AgZvzs6RLVKJWTOoGsjL7IR4Djr3eR9rY2x0GGWur1qybhk5gPstS7SDlLEaa4y2jTlrjB6toIceYPBDHlCMXYPObtJgvZmzAh7sOhlYm545AbL1JZ+tP7RRQ3Hh0fHNCgsFuouIVX4gli0ofKhJGVBelzft8yDtFZlE1csFH2F+yEGZ0Mqh2B9KbQdnGKq+4cztHr3XcuHgnoUS27QrBv6wllgIZ8aGQAKWi3PoISnmW7gKOVC0zLgZfKBsOxBwMZF+2U5WPR/ledua/J6kpAT7sDhnFeqWN9pyFf/zqzprg5gUJzExtE64MI3IfFJlTSrp7Cq2gqicS7bed193lE+/uaXfkHXY8mlHjoGQ+nfOOZvao64uXGdcGYxSRaHX0Mol89PS9UfSatsU/mvkQLP2McNE3pok2Wkxnrs8NJ2hmq6aShk9WAJCOkUV1jX87ZTdImvJJAlwhOpx/TYkI9K9C8b/U6wDmh/SLAxpUzVfm9GsjdgPNjKi
 axW1GRxe
 OhBYkG0YgqMjMAoW+exgZqspFeA3fzJoAYpHQR2rJCyY0fQuRMaxaB8bBJgc2AKXhHUXO77Qd4F8T7tbuySrUj2qwDIWB88ZUIoxj9zD6swcMKDsG21PKPZI71LkxxFDJArrO66NIYE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/11/2025 15:54, Brendan Jackman wrote:
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
>>    possible races with freeing of the address_space. (Hugh)
>> - Stop using PG_uptodate / gmem preparedness tracking to keep track of
>>    direct map state.  Instead, use the lowest bit of folio->private. (Mike, David)
>> - Do direct map removal when establishing mapping of gmem folio instead
>>    of at allocation time, due to impossibility of handling direct map
>>    removal errors in kvm_gmem_populate(). (Patrick)
>> - Do TLB flushes after direct map removal, and provide a module
>>    parameter to opt out from them, and a new patch to export
>>    flush_tlb_kernel_range() to KVM. (Will)
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
> 
> Anyway, if I then kill the firecracker process, the host sometimes
> crashes, I think this is the most suggestive splat I've seen:
> 
> [   99.673420][    T2] BUG: unable to handle page fault for address: ffff888012804000
> [   99.676216][    T2] #PF: supervisor write access in kernel mode
> [   99.678381][    T2] #PF: error_code(0x0002) - not-present page
> [   99.680499][    T2] PGD 2e01067 P4D 2e01067 PUD 2e02067 PMD 12801063 PTE 800fffffed7fb020
> [   99.683374][    T2] Oops: Oops: 0002 [#1] SMP
> [   99.685004][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Not tainted 6.17.0-rc7-00366-g473c46a3cb2a #106 NONE
> [   99.688514][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.1 11/11/2019
> [   99.691547][    T2] RIP: 0010:clear_page_erms+0x7/0x10
> [   99.693440][    T2] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 c3 0f 1f 80 00 00 00 00 b9 00 10 00 00 31 c0 <f3> aa c3 66 0f 1f 44 00 00 48 83 f9 40 73 2a 83 f9 08 73 0f 85 c9
> [   99.700188][    T2] RSP: 0018:ffff88800318fc10 EFLAGS: 00010246
> [   99.702321][    T2] RAX: 0000000000000000 RBX: 0000000000400dc0 RCX: 0000000000001000
> [   99.705100][    T2] RDX: ffffea00004a0100 RSI: ffffea00004a0200 RDI: ffff888012804000
> [   99.707861][    T2] RBP: 0000000000000801 R08: 0000000000000000 R09: 0000000000000000
> [   99.710648][    T2] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
> [   99.713412][    T2] R13: 0000000000000801 R14: ffffea00004a0100 R15: ffffffff81f4df80
> [   99.716191][    T2] FS:  0000000000000000(0000) GS:ffff8880bbf28000(0000) knlGS:0000000000000000
> [   99.719316][    T2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   99.721648][    T2] CR2: ffff888012804000 CR3: 0000000007583001 CR4: 0000000000372eb0
> [   99.724421][    T2] Call Trace:
> [   99.725608][    T2]  <TASK>
> [   99.726646][    T2]  get_page_from_freelist+0x6fe/0x14b0
> [   99.728583][    T2]  ? fs_reclaim_acquire+0x43/0xe0
> [   99.730325][    T2]  ? find_held_lock+0x2b/0x80
> [   99.731965][    T2]  __alloc_frozen_pages_noprof+0x147/0x2d0
> [   99.734003][    T2]  __alloc_pages_noprof+0x5/0x50
> [   99.735766][    T2]  copy_process+0x1b1/0x1b30
> [   99.737398][    T2]  ? lock_is_held_type+0x89/0x100
> [   99.739157][    T2]  ? kthreadd+0x25/0x190
> [   99.740664][    T2]  kernel_clone+0x59/0x390
> [   99.742213][    T2]  ? kthreadd+0x25/0x190
> [   99.743728][    T2]  kernel_thread+0x55/0x70
> [   99.745310][    T2]  ? kthread_complete_and_exit+0x20/0x20
> [   99.747265][    T2]  kthreadd+0x117/0x190
> [   99.748748][    T2]  ? kthread_is_per_cpu+0x30/0x30
> [   99.750509][    T2]  ret_from_fork+0x16b/0x1e0
> [   99.752193][    T2]  ? kthread_is_per_cpu+0x30/0x30
> [   99.753992][    T2]  ret_from_fork_asm+0x11/0x20
> [   99.755717][    T2]  </TASK>
> [   99.756861][    T2] CR2: ffff888012804000
> [   99.758353][    T2] ---[ end trace 0000000000000000 ]---
> [   99.760319][    T2] RIP: 0010:clear_page_erms+0x7/0x10
> [   99.762209][    T2] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 c3 0f 1f 80 00 00 00 00 b9 00 10 00 00 31 c0 <f3> aa c3 66 0f 1f 44 00 00 48 83 f9 40 73 2a 83 f9 08 73 0f 85 c9
> [   99.769129][    T2] RSP: 0018:ffff88800318fc10 EFLAGS: 00010246
> [   99.771297][    T2] RAX: 0000000000000000 RBX: 0000000000400dc0 RCX: 0000000000001000
> [   99.774126][    T2] RDX: ffffea00004a0100 RSI: ffffea00004a0200 RDI: ffff888012804000
> [   99.777013][    T2] RBP: 0000000000000801 R08: 0000000000000000 R09: 0000000000000000
> [   99.779827][    T2] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
> [   99.782641][    T2] R13: 0000000000000801 R14: ffffea00004a0100 R15: ffffffff81f4df80
> [   99.785487][    T2] FS:  0000000000000000(0000) GS:ffff8880bbf28000(0000) knlGS:0000000000000000
> [   99.788671][    T2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   99.791012][    T2] CR2: ffff888012804000 CR3: 0000000007583001 CR4: 0000000000372eb0
> [   99.793863][    T2] Kernel panic - not syncing: Fatal exception
> [   99.796760][    T2] Kernel Offset: disabled
> [   99.798296][    T2] ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> This makes me suspect the kvm_gmem_folio_restore_direct_map() path isn't
> working or isn't getting called.
> 
> If anyone wants help trying to reproduce this let me know.

Hi Brendan,

Thanks for trying to run it!

Just as a sanity check, the way it is known for us to work is we apply 
all patches from [1].  For booted VMs (as opposed to restored from 
snapshot), apart from the v6 of the direct map removal series, the only 
additional patch is a fix for kvmclock on x86 [2].  Please let me know 
if you see the same issue with that patch applied too.

Nikita

[1] 
https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding/resources/hiding_ci/linux_patches
[2] 
https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding/resources/hiding_ci/linux_patches/11-kvm-clock


