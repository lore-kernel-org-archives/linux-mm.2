Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE3D5CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 17:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48B6A8E0014; Fri,  3 Oct 2025 13:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463388E0005; Fri,  3 Oct 2025 13:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378ED8E0014; Fri,  3 Oct 2025 13:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24FF08E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:24:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0193BBDF8
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:24:17 +0000 (UTC)
X-FDA: 83957476554.08.8FEF0CF
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf10.hostedemail.com (Postfix) with ESMTP id 873FCC000E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:24:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=XWGJ23jX;
	spf=pass (imf10.hostedemail.com: domain of "prvs=36448ed3a=kalyazin@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=36448ed3a=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759512255;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKU8SJ09O6RAdk9rzTuf+EPgBar7M5OPCHBeslmadhA=;
	b=B8cNO9NKRudjojpkavJOLkHdLFiGS4CdTB9b7RPRb2h4PM3WAJEdvuRe4V4Ji/I7jSTa0L
	QNJSZhFzbmjr6Onqxdk8iTY79WDY5r5VQsFnHW3GScsIx2racWkAouwuxuvm4nKCjOVk+P
	xYNl+QVZLqSJ8mm+s30LtpzeAc9fxsE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=XWGJ23jX;
	spf=pass (imf10.hostedemail.com: domain of "prvs=36448ed3a=kalyazin@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=36448ed3a=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759512255; a=rsa-sha256;
	cv=none;
	b=KHiQqnhEt71aY0z02TClXUzgC4mMD4cuu3eee4AxVYs4ukpPqin0BKJFBsbQcpMWUvkaAg
	BdezeS5OxyW+zrJCsJb3MzHeVTRlu2W3iqPjDj8mppeQjDmlcQMqBeJZ3d65JjCU/MbBXw
	CEbHntcm+aaULJ8vn+/lXh4t644mygw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759512255; x=1791048255;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=eKU8SJ09O6RAdk9rzTuf+EPgBar7M5OPCHBeslmadhA=;
  b=XWGJ23jXQ294Clb4UrCWio24YqwnWy9dNhMItYDIgCdtEI0ItenpdLtt
   q/IokEOUkeVX4zxIObAMNBaq3mdxg43FE8frFjgMaR/LbLUKq53uOwx2/
   MmvWXrgSmcguUoXgZORNcoBv6+px9opCYmSQF15w0ZZsA/GIu/0liIqAw
   8LDMCSdCRlcxK4RlTR5ZNsFRDBm6H5lUoyqS2vdBErfc+eVBU5LHcYh53
   YTywHXOiYInO8qTJ5b9qPV/epEHs72ZKuz9SnLxGAPjGIQYD96z9cWyHp
   kSqVoXMPbH6oaagChelHbnpZANiKFZU9tUVNEzCZxMRomGGMmZqYxdyZA
   w==;
X-CSE-ConnectionGUID: /bGeMqI5QHGO7ZeMBtXCHg==
X-CSE-MsgGUID: d1ZXsYzERHSwet8rfgRFpg==
X-IronPort-AV: E=Sophos;i="6.18,313,1751241600"; 
   d="scan'208";a="2975643"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:24:05 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:5746]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.33.147:2525] with esmtp (Farcaster)
 id f44c7b7f-75fc-43b3-8033-16cf4d5d0ded; Fri, 3 Oct 2025 17:24:04 +0000 (UTC)
X-Farcaster-Flow-ID: f44c7b7f-75fc-43b3-8033-16cf4d5d0ded
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 17:24:04 +0000
Received: from [192.168.4.149] (10.106.83.12) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 17:24:02 +0000
Message-ID: <fc0bb268-07b7-41ef-9a82-791d381f56ac@amazon.com>
Date: Fri, 3 Oct 2025 18:23:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH 15/34] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	"Oliver Upton" <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>,
	"Michael Ellerman" <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>,
	"Paul Walmsley" <paul.walmsley@sifive.com>, Palmer Dabbelt
	<palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson
	<seanjc@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)"
	<willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>
CC: <kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-mips@vger.kernel.org>,
	<linuxppc-dev@lists.ozlabs.org>, <kvm-riscv@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Xu Yilun <yilun.xu@intel.com>, Chao Peng
	<chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, Jarkko Sakkinen
	<jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, David Matlack
	<dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata
	<isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8?= =?UTF-8?Q?n?=
	<mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve
	<vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, "Maciej
 Szmigiero" <mail@maciej.szmigiero.name>, David Hildenbrand
	<david@redhat.com>, Quentin Perret <qperret@google.com>, Michael Roth
	<michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, Liam Merwick
	<liam.merwick@oracle.com>, "Isaku Yamahata" <isaku.yamahata@gmail.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20231105163040.14904-1-pbonzini@redhat.com>
 <20231105163040.14904-16-pbonzini@redhat.com>
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
In-Reply-To: <20231105163040.14904-16-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.12]
X-ClientProxiedBy: EX19D013EUA004.ant.amazon.com (10.252.50.48) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)
X-Rspamd-Queue-Id: 873FCC000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: pg34y16geoo14oic5d64qez8uhkded8o
X-HE-Tag: 1759512255-424107
X-HE-Meta: U2FsdGVkX18SZyM66pno3XmqKdgVUE23RKIsgg5mIRBiXYSF8iAQMV2qh7BKthQvsNvEG6rw+Z+wgEcHLg+EEhHY+0whuftFsQGiZRtUv/peuXTrfhDPeTaSdBvEJXKet0u6EKRh7yzPBXOz3KpRmvO3psJ75v2adP0lADzISj1N7q4ObuKd8gSaxOtZK/aAS2euQNTItD96pcX+/s2pNo0YEIwylWHLE5IcXvkYcj5jYPd6cxMLHeHgmmRDgBj9KeDWv7Q9vWVoX86cbstLMGvM+uasog+e+xAmnsr6M9P36XxoUwfAblx7wzYdw3PBYeiddFjRQadhMpEd7kGJJYyKxK96a7C3q1VLEc+3A2dDFWDI/Qck2dO4sog4JEYMCNR2Kv/y5Th4FMp08x0GrlN9MY+mCKV3L4jWT0LTHZOQlT7QVQ12NIB0pBpeuXr+fm3a20XYaq6lXKiyAXkQ4eZBg8nBzAFxIAPTK/SBt64Xi2eUMgIDv74uBpAkGVu8A7zIrhWHiVMbAC/09Vm5+x9os/s0NEGdjMqLhf0Ruc3qikFAQ9RwKa2Wf3vsMUcQFtWXey4KsdjY4ximgzC9qcPP9USkqnlSdzwd1OuBUzxmM1Xztz6jjkFsJB9AWhNYFgg8rFoywT1xSWfgKoJNeaGOIIAl/SxLrT2Ara9a8Gk3Bn6II4JwQYAe270uGKImF5M2nZFD60evAgw7/iYTMA9JhJHUvltD1sYBlhjlgeakGWTUOEf1a4ie2jrJPfxiSDHL2hBWGpidwCy1ard6q3jaBI7j3G5jsU5aKZ2zZHoeBehwgPPUjNFukgW/yRCx1kHJROsZJKR6sxFGpmOSyix7TO94uc9qsMSIXG4GHFoChO0MsVyw7ENlBs+HDMijGcufgGg01G3JP2SCC6bdYYx/vuddDrGQ0I/aiNEQ6W9tb179FI5/iL++rXOdCV8PClOnXZh4B3iS4lnq59P
 CpkChI5/
 FSdu2FYRcIqF1cAMRfwAsYQoUTJWpPDCVU4X94rv4ztneT63PTjQ3HgyV9S6sAloo9VZM823mcdA5JziYTA7v6387263pmLJphWwfpLW8PpP6m8VeuGNkV/oAuFSaf2m98sv0zinVRsxES9K5VLN9ykmHubGhnrTOU+Whvy6+066p0ql5vBhL886ARmzQN24B0ZAQpN/0BCHXGcCstGKkM7ioNbQOXL6S38rPaOjwKqmx2Lobovlckjc8GQis7sZIAm/0ERTh0jDWx3wdpBu/UjXrgffTVBGdbbdo8d2aAC/KxUBtjCaBWP+zYKg6xNoc/F2zbq7XKodd1RCvxvLX53Q5SDhBc7hlFPvMBR2VKWkO+BJVgVNkyEJWbD+smqkCijO12XCwg1Ppni0XpBPWPoQjwlgBfdEAdPefnqTFDPCZr67MzqHrobe9ZqFiFt6sVSAh27WlMWbKyU3ilS7JjlvFpAoZ0KOsNaQpX9rfkDJC4kCIeSrDrafjNz/lTRhXwkSFebcLUmwmuzOeXTdPAotAGiShU3ezrXvzfMA+fxMJ8CVLKgcP5abe3qmQaI2gH3roNMWjMbvT7buaUahbpoeQ224O4CEmzuRjpwfwWqB6mK/sikkX6ea+HkzoWtCUHIn9N7+P2i5WMFp80+bI51aK+EDIifOn4Q+krAMBMLdrJLYQGysNVDb/KnD0eTlRGgK53KMBcsRMBUnZNDq/HIxsLRdIpTO5+yprS0KjV+1KWLFrTMEAoLnJAFKUYTGJUDuHrmIpqwnFsXtJi1F4em9f9GLDoibJ5Fd3qdKp6YD0UQU1rXzCTRh4yYen/QWoU2ClXIpWPJoo0YgpOez4rWAFnuWaqQ/60DieakRdWSWu6UOcuXKA6xTckLRO7VSxcQdSQVG+uVVz03m5xcHZUgQ3AXYTiPJYDuC8MSnkoi/X12p/E48TM8Zo3fdhJCDs9D/w9nABbj2tsh4oRnfVu/GdL6Nu
 B9fyUghq
 KSxsC3AuodxpI3+Temu/6PxsZJsUjlCNgvHIUU7hpCKRrWd3xvsesqD2JnxPnXG89e4pFsvXqKaYYuu43UEo4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/11/2023 16:30, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Introduce an ioctl(), KVM_CREATE_GUEST_MEMFD, to allow creating file-based
> memory that is tied to a specific KVM virtual machine and whose primary
> purpose is to serve guest memory.

...
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f1a575d39b3b..8f46d757a2c5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c

...

> -static int check_memory_region_flags(const struct kvm_userspace_memory_region2 *mem)
> +static int check_memory_region_flags(struct kvm *kvm,
> +				     const struct kvm_userspace_memory_region2 *mem)
>   {
>   	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
>   
> +	if (kvm_arch_has_private_mem(kvm))
> +		valid_flags |= KVM_MEM_GUEST_MEMFD;
> +
> +	/* Dirty logging private memory is not currently supported. */
> +	if (mem->flags & KVM_MEM_GUEST_MEMFD)
> +		valid_flags &= ~KVM_MEM_LOG_DIRTY_PAGES;

I was wondering whether this restriction is still required at this stage 
or can be lifted in cases where the guest memory is accessible by the 
host.  Specifically, it would be useful to support differential memory 
snapshots based on dirty page tracking in Firecracker [1] or in live 
migration.  As an experiment, I removed the check and was able to 
produce a diff snapshot and restore a Firecracker VM from it.

[1] 
https://github.com/firecracker-microvm/firecracker/blob/main/docs/snapshotting/snapshot-support.md#creating-diff-snapshots

> +
>   #ifdef __KVM_HAVE_READONLY_MEM
>   	valid_flags |= KVM_MEM_READONLY;
>   #endif
> @@ -2018,7 +2029,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   	int as_id, id;
>   	int r;
>   
> -	r = check_memory_region_flags(mem);
> +	r = check_memory_region_flags(kvm, mem);
>   	if (r)
>   		return r;

