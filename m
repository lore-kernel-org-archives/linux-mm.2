Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C521C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39ED46B00A5; Fri, 26 Jun 2026 10:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3501B6B00A7; Fri, 26 Jun 2026 10:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240C66B00A8; Fri, 26 Jun 2026 10:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB4356B00A5
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:46:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 747261A04B3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:46:00 +0000 (UTC)
X-FDA: 84922338480.02.E0EC02C
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf20.hostedemail.com (Postfix) with ESMTP id 82DFC1C0009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:45:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xBmLvvo9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782485158;
	b=TLJTeMh7OumhDZ1uMT+tCxrqwi8TAW0utYbymxImthdYydpUU1qskYmPTWiNjDVgz9AAXK
	ROe5jwdNkXEZqT1qKoB0w7NVk5htjqyH2XOdsfijtDczOhYBUTIubm9OFoCw61leAuFZmp
	Z8MgnNc20fOCKt8Kotl8i0ZjUd9SbtY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782485158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLoe9hgpuLGAv9HcjQXiuki+Z1Eo9W05Z+080Efe+Rc=;
	b=oX/B+CzomWqmuRE02iOWoLqUK3LQ37ybd161L4VT605+hrvRkXauup2tQMchkapK4YCupK
	/BFZSaeYqvUlvw/LqsAbwn8OrQHdKq6XAux3+QEUNbGLrIDNPpb2qEIFowE84Q9vCsVQRV
	qWevqP5L0N9Wl/T6ljfka6CA1y7/hrA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xBmLvvo9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782485154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hLoe9hgpuLGAv9HcjQXiuki+Z1Eo9W05Z+080Efe+Rc=;
	b=xBmLvvo9VeLWl6aCPOHJfACC84T1J3BTjH51kQr8iuIJvUHkpL0TY/1jmfKt3pAIas6Dh6
	hMKA2it5f7Povtcv7HNEPaX/tbq52whxslXQwIYDMnFdkUFHHwDlaTZMjI6N1SUuxeL0dB
	Mk0ZoJAcKfnjrWev0iaDEvycix+RYjk=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 14:45:45 +0000
Message-Id: <DJJ28Z81JTQI.1SI0CNIP7W1JQ@linux.dev>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
 <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
 <kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "kernel@xen0n.name" <kernel@xen0n.name>, "linux-riscv@lists.infradead.org"
 <linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
 <linux-s390@vger.kernel.org>, "loongarch@lists.linux.dev"
 <loongarch@lists.linux.dev>, "linux-pm@vger.kernel.org"
 <linux-pm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "oupton@kernel.org" <oupton@kernel.org>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com"
 <suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
 <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
 "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
 "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org"
 <willy@infradead.org>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org"
 <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org"
 <song@kernel.org>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
 <kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
 "haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
 <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
 <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>,
 "jannh@google.com" <jannh@google.com>, "pfalcato@suse.de"
 <pfalcato@suse.de>, "skhan@linuxfoundation.org"
 <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com"
 <jgross@suse.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>, "yosry@kernel.org"
 <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com"
 <tabba@google.com>, "prsampat@amd.com" <prsampat@amd.com>,
 "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com"
 <jmattson@google.com>, "jthoughton@google.com" <jthoughton@google.com>,
 "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "alex@ghiti.fr"
 <alex@ghiti.fr>, "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org"
 <pjw@kernel.org>, "shijie@os.amperecomputing.com"
 <shijie@os.amperecomputing.com>, "thuth@redhat.com" <thuth@redhat.com>,
 "yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
 "lenb@kernel.org" <lenb@kernel.org>, "pavel@kernel.org" <pavel@kernel.org>,
 "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
 "vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
 <jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>
Subject: Re: [PATCH v12 09/16] KVM: arm64: define
 kvm_arch_gmem_supports_no_direct_map()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Marc Zyngier" <maz@kernel.org>, "Kalyazin, Nikita"
 <kalyazin@amazon.co.uk>
References: <20260410151746.61150-1-kalyazin@amazon.com>
 <20260410151746.61150-10-kalyazin@amazon.com>
 <86fr4o1ceu.wl-maz@kernel.org>
In-Reply-To: <86fr4o1ceu.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 82DFC1C0009
X-Rspam-User: 
X-Stat-Signature: tjru3hiy6crtsn7e6eaimm33nncyfm67
X-HE-Tag: 1782485158-592982
X-HE-Meta: U2FsdGVkX19v00r3hdycfOVFKjDGVAagWARuHplktJUifZOlZQ1S9RqqsoiyxcmDoUOSlA1G7WsuOannFRZOYjbu5dmhqURE24Na9zmzYgs34lFkiWXTMOz/R1QF0NtwEv9hsSes1hAUeGnSOMNKcyU1lhp7KVeC7jFcFHMbjIXDyCxDidHCxFY2tjktyHoTrQ/siTUViWoMslnpIptSb1Jxi7v9ReWe4vbnQMKGdtg6R5zUlo+/rRTRkYFM145ymwFUJyNVSQ0A4vZsRqKQA8t37u3qkMj3J309Mb1nSD4j+OIlqo5F4Eg06NvO9wFab9/7n57GU5d4IhG7NktOEB0rcN6nDyxzy/QWJcoyj8JkWkPXAy1cA4LhdzCqX/3PF1vZStVtfwKi4SKBuHtFM9lwdNX5v+Nk7xd0d5li83ZMULcK/MfjeFILu9vFwShABQo/r+Bg5vq+u5h1O+ZSZ5M4qKqy8YhKhgooyG0cw7lHBwEKr97jJgMjrRIpSDwz+st8swfZIzKkuTchQu+vM4RHaGPvyALAsY2rNMMkjkA7Zko3p4wPt+VbAtT7I6zjrwyPGVKvPlfxIwSFF1s7ouTBYByRzvYyKuSNMEG3Lef+tuTlDbpWUVa3lCom3Z+4PoH4eUr/38n/cI1jX6lQV5UVS7M7/DoNtSM3cf/V+08qed25VMloLjSTNk3xqdPK/mfzy56ESmCeq5zCN3wEGIye+I7kuBEYUA11GduKLqAEOky/29FTM3Bs3K0TBl2NEePNvQvG8Awob6WjCPBbGqCpUmwwy8Z4SN6A1TZY+1NOlAGkdphDK9K8M0fGhM2w56B29PIZA8+kJJ3OPaUVkVtTxt85owLc0ff1tgFU04tNr0IJ2Cq8QldtBHSWs/FH5iyLv4eQvzgRN1GWwt4KedoqRkXZwwupzXrByoE4VpsDcQv5+diaofpeONb5EAddsaj4ERFUyM4NHbu2Kf0
 m9ioODGW
 JSWhoeE86H9goWJQOk347PB5t/s4XQMDsj9UfiOkSRQVJzFIZpnTEGeKvRX/5AC+CbHH1j38nnYgAHtlNCU4nlucDaDzM2QbcEhnmita8PqgPZLtiiGlI3W1llXuGrhby5v3WWC2si2JARAr1P2tVyGIeHJ2rHvIwymZ2pR2PgeLRubxKMMpwz3gVPZLWh7PC6AHs1oWCMSSXsgH3ukCgHEUlmBmczhWbDOx1pxggrngWP8fQEzfj3UdMeZKArf2QcHGH0Qd88GLPX2fWXUbo1obqdiBI46fsbnBiRrCpvYK7x0tOEDaTim6H3GGtBy1evy79w5H00kIrCOJGs2fL3dlO13/knYpkHZl4bh17hQsH0K2EU6h7qJ8FW+7j2LqxdsOLCNROVxYvTjM36fhNgWktXNmP6Op1CmWvgNQACpenZJM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Apr 21, 2026 at 4:55 PM UTC, Marc Zyngier wrote:
> On Fri, 10 Apr 2026 16:19:24 +0100,
> "Kalyazin, Nikita" <kalyazin@amazon.co.uk> wrote:
>>=20
>> From: Patrick Roy <patrick.roy@linux.dev>
>>=20
>> Support for GUEST_MEMFD_FLAG_NO_DIRECT_MAP on arm64 depends on 1) direct
>> map manipulations at 4k granularity being possible, and 2) FEAT_S2FWB.
>>=20
>> 1) is met whenever the direct map is set up at 4k granularity (e.g. not
>>  with huge/gigantic pages) at boottime, as due to ARM's
>> break-before-make semantics, breaking huge mappings into 4k mappings in
>> the direct map is not possible (BBM would require temporary invalidation
>> of the entire huge mapping, even if only a 4k subrange should be zapped,
>> which will probably crash the kernel). However, the current default for
>> rodata_full is true, which forces a 4k direct map.
>
> Where is this 4kB requirement enforced? Or is it that you means
> "PAGE_SIZE"?

Yeah I believe this means PAGE_SIZE and that it's effectively enforced
by checking can_set_direct_map() in
kvm_arch_gmem_supports_no_direct_map().

