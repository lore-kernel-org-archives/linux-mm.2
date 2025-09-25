Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C562CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 15:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1E68E0006; Thu, 25 Sep 2025 11:51:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561D58E0003; Thu, 25 Sep 2025 11:51:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4781F8E0006; Thu, 25 Sep 2025 11:51:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 398428E0003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:51:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D10801A0257
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:51:09 +0000 (UTC)
X-FDA: 83928211458.12.2E5EEBD
Received: from fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.57.120.243])
	by imf03.hostedemail.com (Postfix) with ESMTP id 441BB20015
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:51:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=OrGBQaD1;
	spf=pass (imf03.hostedemail.com: domain of "prvs=3564eb46b=roypat@amazon.co.uk" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=3564eb46b=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758815467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WShG4YI0EGKByiTLIIIv3ML54YmgGR7q846KIAo0FmA=;
	b=TCyGwpx66z2ySsmjVpcXRiTnl8rzOVWI9ksyjjhN7HwWxNwB5744t//ODVPxZ4mh+GIXbz
	GxTvqde1Z9awxfa7qpIoXkYNg+sts9WRo6ppohHZCXL9HYJ0KtV5T97bQR+8SZvwAhF7Sj
	Aq77zUzxPAHw0LGeRhbWcWRIwPmS/AI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=OrGBQaD1;
	spf=pass (imf03.hostedemail.com: domain of "prvs=3564eb46b=roypat@amazon.co.uk" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=3564eb46b=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758815467; a=rsa-sha256;
	cv=none;
	b=SyfcQaBm7nBGTe+UCoWjcMRbP4OT0vCHBKcaEt+C8khgDRW0aSOLxwPOvH9c4M+pQDgUwa
	vBgOEEdnl71r/x9hlBqR0kRsW6KYm1a9PU1lT/+6hYtjYNxTPJRhGF2YfwYbmjgK9jLAN/
	+okHRSW9hPJxKhh32CpvyDdmwmJbI2w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1758815467; x=1790351467;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WShG4YI0EGKByiTLIIIv3ML54YmgGR7q846KIAo0FmA=;
  b=OrGBQaD1K0Tub0lIPm1V2xXVtZGiV6LZgE71GIs66wDKgwYFaW6CPSBN
   dkbZtcZyta38znezXBe4FopbFBUsNVjXleGx76ZmGiyv77IMmQRgQMJHT
   RdncDh5BtoZ2uJt1eJOnbchve9qD1jNRGtncoH4DuhS/632Q+mQu9BJZA
   S/DihZ8CdVYokvqUnAjfwlse6Vj5eg5NHBFRiP7ieJ4FXJFiogLYxk4Uc
   w7U23cK5ZIpKzifsXSWoDWuYiVPZbscVbvFspTFGPzpKSg9RT2hh5qjOf
   x48jHvYB8zOxH3ghoZnfJhRNqQakkynqTyxDfHIqH1ARnOa2e9tCvn2pJ
   Q==;
X-CSE-ConnectionGUID: MbVH1R0YThKQmA86zMa6Xg==
X-CSE-MsgGUID: 2fM976tAQQK5Fw3KY2GCFw==
X-IronPort-AV: E=Sophos;i="6.18,292,1751241600"; 
   d="scan'208";a="2580762"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 15:50:57 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:31648]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.9.61:2525] with esmtp (Farcaster)
 id 1b0aa563-dc9d-47cc-b8c8-5261ca8f0b3b; Thu, 25 Sep 2025 15:50:57 +0000 (UTC)
X-Farcaster-Flow-ID: 1b0aa563-dc9d-47cc-b8c8-5261ca8f0b3b
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 25 Sep 2025 15:50:54 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 25 Sep 2025 15:50:53 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Thu, 25 Sep 2025 15:50:53 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>
CC: "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "andrii@kernel.org"
	<andrii@kernel.org>, "ast@kernel.org" <ast@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, "eddyz87@gmail.com"
	<eddyz87@gmail.com>, "haoluo@google.com" <haoluo@google.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Thomson, Jack" <jackabt@amazon.co.uk>, "jannh@google.com"
	<jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "luto@kernel.org"
	<luto@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>,
	"maz@kernel.org" <maz@kernel.org>, "mhocko@suse.com" <mhocko@suse.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "pfalcato@suse.de" <pfalcato@suse.de>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "rppt@kernel.org" <rppt@kernel.org>, "sdf@fomichev.me"
	<sdf@fomichev.me>, "seanjc@google.com" <seanjc@google.com>,
	"shuah@kernel.org" <shuah@kernel.org>, "song@kernel.org" <song@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "tabba@google.com" <tabba@google.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"will@kernel.org" <will@kernel.org>, "willy@infradead.org"
	<willy@infradead.org>, "x86@kernel.org" <x86@kernel.org>, "Cali, Marco"
	<xmarcalx@amazon.co.uk>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling
 TLB flushing
Thread-Topic: [PATCH v7 06/12] KVM: guest_memfd: add module param for
 disabling TLB flushing
Thread-Index: AQHcLjQso34Q5KN2CUWRdaSrXlVTqQ==
Date: Thu, 25 Sep 2025 15:50:53 +0000
Message-ID: <20250925155051.2959-1-roypat@amazon.co.uk>
References: <cf57bdec-6a2d-4d6a-b27c-991a7e2833ab@redhat.com>
In-Reply-To: <cf57bdec-6a2d-4d6a-b27c-991a7e2833ab@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 441BB20015
X-Rspamd-Server: rspam05
X-Stat-Signature: 6o3mn8gusj5bzijpi6hx9msstjx8rqje
X-Rspam-User: 
X-HE-Tag: 1758815467-347618
X-HE-Meta: U2FsdGVkX1/MtwpVnQ0xpPkesjrQ2QoRoTuF0/2s/+rhdhaNvKbOMS9b7P4/Jw86GDz4xUuaQO7JNoVn0/IyT2rdtjPV5hR7jS1QfPO1b17MlsBllxMhWNxYgS8EUDedmuY1tON2Pgs9MvCDJ2kVzY73GWAYAG6Zqrx+vAEZk2fohWGVCKrSO8vCl/GnZ/RL69iNXWYY924M8aGLT2v/VFYvKRfI4/phabXy4lgDmqZHnvFSH/f/qX0XcFkFJ3bnE3LaSuNosdslhiGFKVq5+6KkDODnUNJFC6YZ2G+U8mXCPMj3AgGaA4p1Mkoyl1PlnOCqFoXTTdoHpdGZichbaWo3zOx6XTIlezxAchIwvaYacGvm7iML5/Qb9IotcH874vvZ0aZ252AVzqau4rok8TS6ZzcrlTJXwzJ7W8rd4zcywCWQT5qa6kH8QIKUHNubnhPevAxkYCojjvR/U0/Q9ikSREcIc5HFmPBqEEa9sThFuBgtKI4pM7MMLuRv/Bzsl2Fxr1Fz5J+j7cbYijqNKxg1LZEw1TztO8pLPWQZs/Jm/rRTz8iY51Mt44w+1bNbHu1j3w/dwvCMlsXxsWVKGZ1eG0gkxG4WEOHMS3Usxks2pS5AXw4Qa6LYYPe7NmO8gWr5eS+XggHbWpYvhMBIU34/3CDGnnKAWoLxuVZi47VeesLdRU+pDiYEAVYDLEHnI5wmj4CQ55OpJXCycSE909a6V+GWriSh8EgjOcGp7e79Rd/+Akr/r+LSjbCJwcQgdpl9fK7DPyuvZix8XQsRKEt58/UbUaEG4GYLA1JAoPWWNdtG3sbzVcLGpo5Ao2VoapyzUtytOZ8FfMENi8Q5OtxSi/sizByuYMgl4y3lof5wK6jx0fZtWr1Yp/KbbSLGjOoXHx/DS46lp6uyOp1WjKs/eOAXAtfsz++O87Epdy3vEC10sCakce0M/zJ1wNykpFJ7mYMcMf6RUxWWPst
 vQP1LV1K
 R/DTNnSQHAHug3Hdr6T/DwH1+CV7T5vGjCazH6oSK1EEnmdFDa56YC/Q0Dq2CLrK+iRXFYsKcaOXZm8AV2rtqRPfsrCn6C83MWY1j4NroXvO4/muPA3h/dfmmJjC4erB9C8Ls0KPP9SxUZAWbUhonTo6Vr7G6IjfR1+evEvJtRBA+WV7cJyhi8j1V+SzmOmeRVAdXjIwgtKCPhcWln9dDPkmHYNNlJdR3iR6WnHXRvPZOPD/rwcQAgLvi27Sime+uD/amKr5DXEOnzRAeebamzLGvr9zLiTNcHLfn/6XJy0svxXtx+XMImjvPX2Xxj/rGCR45fzXeYrALZwgN6fdz+gfZOc43t6D9sZ5ohE97Ynll7jDFDednFuG7aSCgRdHSUIjHfk9UJtdH8rxgjkZRG8gzXb5y5XyWcv7Q5IqMetnEuyvgxJ26hdGJl23ZezU3A7WVye1ZL3YQyD2h24U89GoLUbWOvYVdUK6TLPg5xt8WSCHUzoqv4Z3YjSdZN+ca5N/VbUWjjP05pNthlgpcIKBeC5YjKKYqtl8buzEPilGcz1Pm6YiKJgT7JKbV8V6c5anDr8KP7ga8AxUakKSXWyCC8YM7YMtrK3JmrnCMerX+usDgkgraGPt8BQHeD1WsR1LYFa8yiy+l+g+a5OZebSEf/LVwLKxJJnkP5k3MHAj5vxJho3eitJtpUsiuIW9Di4DKso9xOTP8T7NaZrqiLvvH0/770Zd0is/pvLHWigRkpeFvvPVA+WZob+IpXuIAwuQoVzrTP7Mp009JAxF41KCuKgPk2xWVfhRFcCwEW86ASstjcbHCzBsEp399OfgkFJH6RtcOtG2OAJf/Rl/9JSN/dHJd/bythlHJJVvpiUABwFf0OhdS3gmBSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2025-09-25 at 12:02 +0100, David Hildenbrand wrote:=0A=
> On 24.09.25 17:22, Roy, Patrick wrote:=0A=
>> Add an option to not perform TLB flushes after direct map manipulations.=
=0A=
>> TLB flushes result in a up to 40x elongation of page faults in=0A=
>> guest_memfd (scaling with the number of CPU cores), or a 5x elongation=
=0A=
>> of memory population, which is inacceptable when wanting to use direct=
=0A=
>> map removed guest_memfd as a drop-in replacement for existing workloads.=
=0A=
>>=0A=
>> TLB flushes are not needed for functional correctness (the virt->phys=0A=
>> mapping technically stays "correct", the kernel should simply not use it=
=0A=
>> for a while), so we can skip them to keep performance in-line with=0A=
>> "traditional" VMs.=0A=
>>=0A=
>> Enabling this option means that the desired protection from=0A=
>> Spectre-style attacks is not perfect, as an attacker could try to=0A=
>> prevent a stale TLB entry from getting evicted, keeping it alive until=
=0A=
>> the page it refers to is used by the guest for some sensitive data, and=
=0A=
>> then targeting it using a spectre-gadget.=0A=
>>=0A=
>> Cc: Will Deacon <will@kernel.org>=0A=
>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
>> ---=0A=
>>   include/linux/kvm_host.h | 1 +=0A=
>>   virt/kvm/guest_memfd.c   | 3 ++-=0A=
>>   virt/kvm/kvm_main.c      | 3 +++=0A=
>>   3 files changed, 6 insertions(+), 1 deletion(-)=0A=
>>=0A=
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h=0A=
>> index 73a15cade54a..4d2bc18860fc 100644=0A=
>> --- a/include/linux/kvm_host.h=0A=
>> +++ b/include/linux/kvm_host.h=0A=
>> @@ -2298,6 +2298,7 @@ extern unsigned int halt_poll_ns;=0A=
>>   extern unsigned int halt_poll_ns_grow;=0A=
>>   extern unsigned int halt_poll_ns_grow_start;=0A=
>>   extern unsigned int halt_poll_ns_shrink;=0A=
>> +extern bool guest_memfd_tlb_flush;=0A=
>>=0A=
>>   struct kvm_device {=0A=
>>       const struct kvm_device_ops *ops;=0A=
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c=0A=
>> index b7129c4868c5..d8dd24459f0d 100644=0A=
>> --- a/virt/kvm/guest_memfd.c=0A=
>> +++ b/virt/kvm/guest_memfd.c=0A=
>> @@ -63,7 +63,8 @@ static int kvm_gmem_folio_zap_direct_map(struct folio =
*folio)=0A=
>>       if (!r) {=0A=
>>               unsigned long addr =3D (unsigned long) folio_address(folio=
);=0A=
>>               folio->private =3D (void *) ((u64) folio->private & KVM_GM=
EM_FOLIO_NO_DIRECT_MAP);=0A=
>> -             flush_tlb_kernel_range(addr, addr + folio_size(folio));=0A=
>> +             if (guest_memfd_tlb_flush)=0A=
>> +                     flush_tlb_kernel_range(addr, addr + folio_size(fol=
io));=0A=
>>       }=0A=
>>=0A=
>>       return r;=0A=
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c=0A=
>> index b5e702d95230..753c06ebba7f 100644=0A=
>> --- a/virt/kvm/kvm_main.c=0A=
>> +++ b/virt/kvm/kvm_main.c=0A=
>> @@ -95,6 +95,9 @@ unsigned int halt_poll_ns_shrink =3D 2;=0A=
>>   module_param(halt_poll_ns_shrink, uint, 0644);=0A=
>>   EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);=0A=
>>=0A=
>> +bool guest_memfd_tlb_flush =3D true;=0A=
>> +module_param(guest_memfd_tlb_flush, bool, 0444);=0A=
> =0A=
> The parameter name is a bit too generic. I think you somehow have to=0A=
> incorporate the "direct_map" aspects.=0A=
=0A=
Fair :)=0A=
=0A=
> Also, I wonder if this could be a capability per vm/guest_memfd?=0A=
=0A=
I don't really have any opinions on how to expose this knob, but I=0A=
thought capabilities should be additive? (e.g. we only have=0A=
KVM_ENABLE_EXTENSION(), and then having a capability with a negative=0A=
polarity "enable to _not_ do TLB flushes" is a bit weird in my head).=0A=
Then again, if people are fine having TLB flushes be opt-in instead of=0A=
opt-out (Will's comment on v6 makes me believe that the opt-out itself=0A=
might already be controversial for arm64), a capability would work.=0A=
=0A=
> Then, you could also nicely document the semantics, considerations,=0A=
> impact etc :)=0A=
=0A=
Yup, I got so lost in trying to figure out why flush_kernel_tlb_range()=0A=
didnt refused to let itself be exported that docs slipped my mind haha.=0A=
=0A=
> -- =0A=
> Cheers=0A=
> =0A=
> David / dhildenb=0A=
> =0A=
=0A=
Best,=0A=
Patrick=0A=
=0A=

