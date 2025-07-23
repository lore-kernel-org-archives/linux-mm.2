Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C77FC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 11:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32466B00B5; Wed, 23 Jul 2025 07:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBBC76B00B6; Wed, 23 Jul 2025 07:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA946B00B7; Wed, 23 Jul 2025 07:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB9B86B00B5
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:45:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3EE54C0160
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:45:08 +0000 (UTC)
X-FDA: 83695348296.07.2290996
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id E74D8140002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:45:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V906kXSO;
	spf=pass (imf23.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753271106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l59cD6t8x/yYppwAMFqjuP0HYW8qoCrV0FHN2nRJB/Y=;
	b=Q6vutIvVN8E6vhql13UAqx64OOL6gcv2TIat16VQ1pnQoEPKSourjnM3Q7q5N49ocUgY+X
	6esduMDHgySDcewnCgSmwg5Nngr3hWqk6QKBD9MdQPS88sdTBchcJ8TYvbeoxRV5gvcha+
	xhPUgSI3MpJEfSl+KRBuK+mW669VGzw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V906kXSO;
	spf=pass (imf23.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753271106; a=rsa-sha256;
	cv=none;
	b=6HMxHHdspspFIzydUXx+rR0BkuJ+5IiXuAe82UKczRsFhHaxpJO55536p7gh5kc+l152Io
	RSaWukUgHxegcxKYsDBypqP0dRpDm0Vb/Xw+f8m8oxwEDCbuM8sedZUrY5cde4mZH1Pcn0
	rJAPtPk7ITTBJSGpg0qvkP1iU51mY2U=
Message-ID: <63b70aa3-5b20-464f-83ac-97b6a78c99f9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753271102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l59cD6t8x/yYppwAMFqjuP0HYW8qoCrV0FHN2nRJB/Y=;
	b=V906kXSOWuv2GItOcDK540WJ3tHmdbNrKADl+IxsddBmeLbJQzIDavJMyUe5zJ84UCrZ+p
	/twn4ph0k0JIHqifJ4/aBEq9tMIzVjHm6gxNN3l5P+YcW81TP0J9XHd+QbgzDbPy/wLKf0
	EssEmv7nn7aObEElJagRnU4R8JLKNsU=
Date: Wed, 23 Jul 2025 19:44:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v15 16/21] KVM: arm64: Handle guest_memfd-backed guest
 page faults
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, will@kernel.org,
 qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org,
 hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com,
 fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com,
 pankaj.gupta@amd.com, ira.weiny@intel.com
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-17-tabba@google.com>
 <07976427-e5a4-4ca4-93e9-a428a962b0b2@linux.dev>
 <87pldrtj1o.wl-maz@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kunwu Chan <kunwu.chan@linux.dev>
In-Reply-To: <87pldrtj1o.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hmp3sr4546y54qmxp817axcfrybqnhnp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E74D8140002
X-Rspam-User: 
X-HE-Tag: 1753271104-342852
X-HE-Meta: U2FsdGVkX1+Au2co5oIZ0I0kQyWKbYhOpnArG8PFAwuHXeL4+wIBWPifUe0oJNlqt7mC1Mi0hb08j+4/8DTFBQTequbUoMk02pVCw/cHjP83io2PFFr3CUSwdsBfBOJR+eTpO8CgkZ1WtMD2htberMJWh6C9DBRUbbrTVns5+yhcv4JkpsSxJvvKzOHzA7ykRxqAbq73hi3PpuDkGER18bkBwa9V4uZejfElqvkkK/BFwKsPU8Kon/so8aQWKxVQTHkbESzyg3dAKh0gtR7yc0rBr1rqUduM1Ox7g5PQXaTwkPXxf02IRd9JdM0dAzeTBaofZN6JLPpfuwqtDnR17c/jWEOskUnLhqUJY6Bw3nc8QgJTbxwhIxgPa8lAFzk/XEVpKAkevg2xAwghPMHwD0uY7LQ4za1DAMDMbU5p4KxZhE0BYxk2AOgsvFE8rfF7NPBeMLikLO4/5IqUKde4sLIFe0/md/SsEkwwqfZ+59Jodgt2PBg3S4y+6z9jegZH2TIUSZDt5gJwtCLVBHhYZVxdMhqNqZun7hgwoFaKW7mXsJrBKgjFBMKCFDXdYB1PZR+lFUVrSC76xGp9nISwXzv9WPV1FfUghUvMieuO1MT6zjsjDeKRxBS9FSI9RIVkSI1vGbr6R2Q+bmlhBRTpaAgtDPwNzp9p7rOeKHdUYdT+vmzlxpqTHFKmJ3I+HTUqT2T3EGmSvwjRlVP61GFvCILc27Jp6vMreZblo9kpzK/hHgyr6jbs0rFt0Ed3m5ShBV7jAPFmImTDcEwZqoYvzNdfZxgfZa5xKANQ9/pvXHMMSUc8YAueK5DCG3G2hT2+EPdZ6EemQWQBFEb9NIDLt1YKX1l+fk5Non/dU2ag2lee7kBxYRp/lrlLVKABWeFo5K0yN+KopwoFY2/onIvc++Haw1OrQtvLeGshK5i6RigUKU8En9cxEwuq0nHcfpk9ZNMKcF9DPUJfhanIr6E
 OiztZpAo
 H1PD0c4jQ7BFhB+A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/7/23 16:20, Marc Zyngier wrote:
> On Tue, 22 Jul 2025 13:31:34 +0100,
> Kunwu Chan <kunwu.chan@linux.dev> wrote:
>> On 2025/7/18 00:27, Fuad Tabba wrote:
>>> Add arm64 architecture support for handling guest page faults on memory
>>> slots backed by guest_memfd.
>>>
>>> This change introduces a new function, gmem_abort(), which encapsulates
>>> the fault handling logic specific to guest_memfd-backed memory. The
>>> kvm_handle_guest_abort() entry point is updated to dispatch to
>>> gmem_abort() when a fault occurs on a guest_memfd-backed memory slot (as
>>> determined by kvm_slot_has_gmem()).
>>>
>>> Until guest_memfd gains support for huge pages, the fault granule for
>>> these memory regions is restricted to PAGE_SIZE.
>> Since huge pages are not currently supported, would it be more
>> friendly to define  sth like
>>
>> "#define GMEM_PAGE_GRANULE PAGE_SIZE" at the top (rather than
>> hardcoding PAGE_SIZE)
>>
>>   and make it easier to switch to huge page support later?
> No. PAGE_SIZE always has to be the fallback, no matter what. When (and
> if) larger mappings get supported, there will be extra code for that
> purpose, not just flipping a definition.
>
> Thanks,
>
> 	M.

Got it, no questions here. Feel free to add my "Reviewed-by" tag to the 
patch.

Reviewed-by: Tao Chan <chentao@kylinos.cn>

Thanks,
	TAO.
---
“Life finds a way.”


