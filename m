Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7621FCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 21:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3E319001E1; Thu, 14 Aug 2025 17:35:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEE059001D5; Thu, 14 Aug 2025 17:35:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCD29001E1; Thu, 14 Aug 2025 17:35:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA3FB9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:35:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B44A836D1
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:35:10 +0000 (UTC)
X-FDA: 83776668780.28.1058F0A
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id B4765A000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:35:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="3HQn/tFe";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3i1aeaAsKCPwegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3i1aeaAsKCPwegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755207308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oajUHZurgaJBmxaEUN9ClPIgMpw3KkdomNP4S2lFK5E=;
	b=k1XHdL+/U+jhYsmrfUzbJq06wYrJz9ODpFY/8fBem3bUFkMG3TbYZE0wzggqenQAYhJns9
	pv/y+z4hDXp23M40ChD03npKtwS7lAC2ks0wZiadXSQ6Oq4ge699MJ3Y1MZL4dXuACURAi
	z0EAjQEFqcsuW3rH9gBxb/yT74TGDzY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="3HQn/tFe";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3i1aeaAsKCPwegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3i1aeaAsKCPwegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755207308; a=rsa-sha256;
	cv=none;
	b=qz3xotccCLEAmzrB3ElTHXnS8xXeavBGPqy3jr92DxrFk5DOnBjE+YHaMFFk1UZuc0fpvg
	mTP4p4tJIDXht7gddMUmfBeF0pk2GtKkj6NrgKcYsspYThiBpFguom4dPPua+6iTSyhRxX
	VmHHGiEAXYQS1karQfucDzGXCJDQAyo=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-244581ce388so27017465ad.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755207307; x=1755812107; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oajUHZurgaJBmxaEUN9ClPIgMpw3KkdomNP4S2lFK5E=;
        b=3HQn/tFeOFZBc75uKFyPdHGhaoRrWyVNlgdKW7oxtXNSVxHYuwYioQRDg5l7BB9J08
         geBD2GUs2oHD6ESPbYKw9pRivohKDcuwk72XrF5PTI4HzukaysvS9DLfg7nTNkyTpwRb
         wkmBNN+tIOtaR5p8tUKz5+yScpZRHQJ4P5wlnDrbmjXd8AglPQcnxXsWdRdpM/z5Qqt+
         fwjpOP1WyVl39bPEGxEfr5s0Kaops8/Xo9pcHMxVR/qM69cKljeQg+dKM45bj3s7x2pd
         oUohHJTxAGawPFd79G74/KpvhohKCQvMra9uIJtaOioDxjhQ9F26jJGAnDg94sB0Bjr4
         klYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755207307; x=1755812107;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oajUHZurgaJBmxaEUN9ClPIgMpw3KkdomNP4S2lFK5E=;
        b=Nr74CPVB0IbuvHrdtVURMxqTSOVXI8qXyv0MsETFGw6vFFwJ27wnTHQdlhOJTF0YhI
         gkrIOZaRET7GuUC2uybrG/e5bHFMEET4h0tOUzJvqacdb1XuI0hGiKanxMOLDexgbIyH
         X9zv+Ip/cvPh+ZECheYsRLeCNEr2v+alIRH/MZLcGD89umP1NjyyQt5q6ED33ACv3shX
         vHGOpnyF4Qque8aH08aTSCg3CDZb7vTvcfKlFzYZGKtUTwNBen4n8f547GQ9TmvAO42G
         zK2zLxeUaYQqOrc5OKGobIDIMgSCZR6+MznVXeSjWfRjauk1z8m+h5X3XPM+nM5OrOc2
         nbxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMsLY7KwQ2KHlNL4V2jAkXPIp/qOxBghVql47SOTl8zOo6OItiPlwrBZswW+joKWw1fTN+e3TGyQ==@kvack.org
X-Gm-Message-State: AOJu0YwEN/2xffcBlXY7Cp0IQo44pyOwRcZFtvjs0bKk1I26zihUyqmg
	eGk3zhQVr2As11wMDnrUKaIgEtpQxyMMeRTFMqKetkoSHOA5VgClIYPUZMjI7EmIbwWut85plDh
	z65IT3+HztLMSGM6exeUXsg5caw==
X-Google-Smtp-Source: AGHT+IHSCWEZ4WzQFvfM7gmfwowerM9ooYJUxTCTTxPR6qD/XE6Y7uX4MPuDDOyY1Umu3SEnPhVG+BTFarjXCQhhaQ==
X-Received: from pjboi8.prod.google.com ([2002:a17:90b:3a08:b0:321:90c5:fc2b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ef0f:b0:240:b075:577f with SMTP id d9443c01a7336-244586c4da1mr76912365ad.37.1755207307282;
 Thu, 14 Aug 2025 14:35:07 -0700 (PDT)
Date: Thu, 14 Aug 2025 14:35:05 -0700
In-Reply-To: <aIwD5kGbMibV7ksk@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aIwD5kGbMibV7ksk@yzhao56-desk.sh.intel.com>
Message-ID: <diqz349ta8om.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v2 02/51] KVM: guest_memfd: Introduce and use
 shareability to guard faulting
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org, aik@amd.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anthony.yznaga@oracle.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	bfoster@redhat.com, binbin.wu@linux.intel.com, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	dave.hansen@intel.com, david@redhat.com, dmatlack@google.com, 
	dwmw@amazon.co.uk, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	graf@amazon.com, haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, yuzenghui@huawei.com, 
	zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B4765A000D
X-Stat-Signature: gybibioc3h91k3rrmu6x67m6n9a51nm3
X-Rspam-User: 
X-HE-Tag: 1755207308-133557
X-HE-Meta: U2FsdGVkX1829tZUrrqbyLTZwkKobOgn+gSh4YBMYZmm1J+Jg0gvoEX4ypdeW+7T8qm91NBVePwQp+oydlF0vfSYnSltXkuo8n1A+a/WCrfwxDU7bsWasCehM8et4k+25Omsg1ZsAP61mscmsCoyIuX8HYGaMO465zo8qoUbO5Oo/8qkc7Ibgqf8R/OmkNcn6FlulMqUfbHHDxYINucAwtd6EHPPEOzk1PqAPJYvGOoSsfxy4k/rXIh5gWD7w9b9CwCdUABvJnwui0vRdNpibipAQB9DZ59csVSvYhE+511whfdV8MFxv+t2F73So2wNdIWWiz3zcc+L5gaWFRZx6DBc4bk/SDAnZ4NZHM3DujoRbaPydNEUpX6Ua66VEress6XQrZAr350dioj8KNqXEBA2DBPQ91Kel2Der5Md7pWuNBtE5mkkgJsPG1R5AUq2kGEBf7LmiUfko7AEGm9i0uO9aFDFgWRaGEqvIOSnuKMHaphFuLPMvb5cV4dOUBg5lChH1u6+RfVbfPXs4lPtMaw4RuBH9Ua4prVlgJskpkvmE5BUAcsxzln1XIgMtfkumFUUFaV4nSnqmW66ihNORkyL0LY0LVcoLYgXDOBBm6uNsR9HuAv5c77QPX+EcWVot1zZ8VWwhsfC6SFU60xB8+1EUy8Dnd380/xVdhg80tq+O5vwm3DUwRrK14JeVyQuDYdootvR639AxZJhAhTv2rWv2KQQyboulS3RYInqb5t3tpQLrpthaUrsQPU0DEdMmVWul1zWvtKl1xVU00C9ofz8zgCww7HG9DkOSKH6K1m4GwQWJLmC825423Kqu+sNpun/3HCGG5vsM73q5GD8h3IqeUNAtjrv6i5Pv/Heo5kxCC++zWviLz3HrqcjnidJUKyrP9VRaBdJt+2/lYLKWVt3SgGRIazjhHzqTpZVZqXDpPw6hcEJ5WFfpMXqJm4fC9KrR+UBDyeaond87hf
 BcFgfdF9
 ABoWNEMZUNJAVzm+URefIhiDF/qnx6KRcxInNXLnPGDTfhqgxXrtZyoa7Q4FcU/cx5B5MADS35r13BoHrn/p7otQ0yc1uDala9voMaidh8Nx6oGFaGMm3RlMD4R+OOuzbsxFjsogzp2kWf0LWB0XgN/UoNjyDtJLTH4BLr3Z5X3vVLmDnX9MxonJJyVdrNuKZmLf6q7agInV/JtaEA3dD808PUYAvaKD+9b3me9AHwCc/SCz1bd9r/W41gRt3OxcZgILOIApQTY1S4spYnWvjKKV2+6nq1I889MRBm4Thfn3JpWy3r+gGfd6odUn3sZDZYblNGH0dv3bJ+gBMQ8adU4BQ+bZjRE7OwODPI/l3VQeGsWf9K5TJ2fOn6p3aw4IArLypX8s16Px48WkAZf8DUnyNinsqiujs6PhrJhiVDYglumVY/tZeYlpSz4arfBW84QwJA1qXhMwE204/R9DCPdhIIjl8sGEWVurzSTbju1z6JIX/mnWmo9kYQFYNPRSdOpxgrgxEuxAtwrVvLUiWJkNh7keXOw5vXe6DkEz7SIGD3topLZLyMHAxS7T6uyAYOCUp2c/BV0PYaQRWX0zLqggGwLSACdL5LWLXczNScY0SYzbm4bvcrlVIhiviXZ143lUWV+n2Dd2+f8k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Wed, May 14, 2025 at 04:41:41PM -0700, Ackerley Tng wrote:
>> +static enum shareability kvm_gmem_shareability_get(struct inode *inode,
>> +						 pgoff_t index)
>> +{
>> +	struct maple_tree *mt;
>> +	void *entry;
>> +
>> +	mt = &kvm_gmem_private(inode)->shareability;
>> +	entry = mtree_load(mt, index);
>> +	WARN(!entry,
>> +	     "Shareability should always be defined for all indices in inode.");
>> +
>> +	return xa_to_value(entry);
>> +}
>> +
> Hi Ackerley,
>
> Not sure if it's a known issue. Just want to let you know in case you're unaware.
>

Thanks for informing me, and thanks for the analysis :)

> During a test to repeatedly launching/destroying TDs, I encountered a warning
> from kvm_gmem_shareability_get() (see the attached log at the bottom).
> The reproducing rate is 1 in every 20-100 times of launching TD.
>
> After some analysis, I found that the warning was produced by
> kvm_gmem_shareability_get() when it's called from kvm_gmem_is_private(), which
> is not protected by any locks.
>
> I can get rid of the warning by either fix 1 or fix 2 below.
> (I prefer fix 1 though :))
>
> fix 1:
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index e78fbebf4f53..136d46c5b2ab 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -2024,7 +2024,7 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
>
>  #ifdef CONFIG_KVM_GMEM_SHARED_MEM
>         if (flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED) {
> -               mt_init(&private->shareability);
> +               mt_init_flags(&private->shareability, MT_FLAGS_USE_RCU);
>
>                 err = kvm_gmem_shareability_setup(private, size, flags);
>                 if (err)
>

Not sure about the version of the conversion patch series that you're
using, in the version I'm preparing, I'm using
filemap_invalidate_lock_shared() to guard shareability
reads. filemap_invalidate_lock() is held during shareability updates, so
I think this issue should be fixed.

Please let me know if you're still seeing this issue in the next series
(coming soon). Thank you!

>
> fix 2:
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index e78fbebf4f53..9a4518104d56 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -171,7 +171,9 @@ static enum shareability kvm_gmem_shareability_get(struct inode *inode,
>         void *entry;
>
>         mt = &kvm_gmem_private(inode)->shareability;
> +       mtree_lock(mt);
>         entry = mtree_load(mt, index);
> +       mtree_unlock(mt);
>         WARN(!entry,
>              "Shareability should always be defined for all indices in inode.");
>
>
> Thanks
> Yan
>
> 
> [...snip...]
> 

