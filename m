Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8541CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 06:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416C88E00C1; Thu, 18 Sep 2025 02:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF3E8E0093; Thu, 18 Sep 2025 02:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305108E00C1; Thu, 18 Sep 2025 02:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1EFC38E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:53:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B2EBC5B691
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:53:45 +0000 (UTC)
X-FDA: 83901455610.05.12152B5
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf28.hostedemail.com (Postfix) with ESMTP id F0299C0002
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:53:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LOzeWRUE;
	spf=pass (imf28.hostedemail.com: domain of 3dqzLaAsKCEsnpxr4yrB60tt11tyr.p1zyv07A-zzx8npx.14t@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3dqzLaAsKCEsnpxr4yrB60tt11tyr.p1zyv07A-zzx8npx.14t@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758178424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdY8CdA7D7v7QlqIXdHWhklcBLDBGklkP9F/ba8VEO0=;
	b=ImgM+NOBLr4Cq6xMDiGzvBUS2MTegj5awyq5XOs82FekmFYiGMxybPOGFPJwTnyd8qSzfO
	eHWzjiEElEceap1SXU5lxCH1+Pm4NiY7tjFFBLsYK+uZXpCe+yFDPhF1EjA9WVzi7aQ39n
	MkMaPTdpubex1GYVVTqiPI4bQk06ahA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LOzeWRUE;
	spf=pass (imf28.hostedemail.com: domain of 3dqzLaAsKCEsnpxr4yrB60tt11tyr.p1zyv07A-zzx8npx.14t@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3dqzLaAsKCEsnpxr4yrB60tt11tyr.p1zyv07A-zzx8npx.14t@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758178424; a=rsa-sha256;
	cv=none;
	b=oFP9nQKCs89I1KyTOv+Vqa+GnE3OokmWHlJcHEJQ/HQ1gQjvsObJfrdEgPQo5q+UZiESo0
	EutwFvPH56WB8TRCm/kZJkpglj9bmEEZle19lBziSzdIT0UCnSjtRVEoqD6ZjMuygZzYG+
	jCQ5ynMly2K9Hq5m0LsElAcR5+oO/rE=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-269880a7bd9so5672275ad.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758178423; x=1758783223; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kdY8CdA7D7v7QlqIXdHWhklcBLDBGklkP9F/ba8VEO0=;
        b=LOzeWRUEEq94/QvhMkWlfLnaSgUpnhRU3IY0C8U5wmZ4Ve/V9dMJHvY40IoRbi4p+s
         cwm9UnxbRjdtBnNX+BxpecFt18U7mBw2+6Y2ssv4+Khyjop8znKmlMJFk0CGIpJla1bd
         A7iCWnBm5O20DGWUc26bzTIvYrWCbLU46gr3J05ETb+UouotGrXK6Lj8/6uqdqt7m42X
         70YqKp7Fu1CuHC+Rm3w/CU5y+ftsmCnrKgAPiqE71Rxc8FQd7eur9N3XGQlJaQivhPWa
         VxRa1JJhrXLg2Gjtlf9CUgASqnXyyw4CKhOanjnRya/tCs1VciALvCHu5tPo0tWMxcGl
         v3Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758178423; x=1758783223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kdY8CdA7D7v7QlqIXdHWhklcBLDBGklkP9F/ba8VEO0=;
        b=XLGpr+K3+380yInjPFn31dejb70hmEtO94ciE34Swm/2zhsEqgbxZ4LfZ8AYxEx1Cv
         Nlb6sHdNEEZuc5OUkTRWdQBb1F2MbiX1tfdl7byLJeZO5G5p0RH3Xppz+jleDSIk/vfu
         ZcpTwzv5PERUDJyB47qeKtVxWkaZEHXNwXnvEPzeEbvaLcCv9ZsR7lriRQSbYc4ZEUKd
         eegJdecUAQ+DYTuR2pWFeSfMpWCKWQKJKQDa87i23+QJFoaTXscpDzffm4Y+0ZOaHnsj
         2e89pyh1VB1La7M5aVXQJ7rKCYYLdgIFVyHT1xqdfh6HQ3rjUdvZp5BAkmx5j4Zl37WO
         7UeA==
X-Forwarded-Encrypted: i=1; AJvYcCVyPka5Z9rukGZe9+xC2/HLWbuewfAtOUMCV90BYCTUkkjjJ+HkDbvGmtrzT09KZG+JtFPJNjkDEw==@kvack.org
X-Gm-Message-State: AOJu0YxfH+2kkafcqw6gTlBbVSnoofRMUfyx8WMjcnaRnAJ9xd7LUHyB
	6bdBq9XqcGjtIxn1s5aW3fXmHRcFEFSB57Uxe+Wo11e77MnjByLpPwgsQ681yJrr2Hl+tptZM+S
	fBcPhJIsJr3GBlA1rfppmuxR1gQ==
X-Google-Smtp-Source: AGHT+IH4/xFas5qH9WkGtquuXdWcMilu78LEjzqF2BsDWfyKCYslt2SGwsXQ1h75MU0H2eQyEYDJZApNSPXmxa7tZQ==
X-Received: from pjff12.prod.google.com ([2002:a17:90b:562c:b0:32e:ddac:6ea5])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ef0f:b0:24c:965a:f97e with SMTP id d9443c01a7336-26811ba541dmr70869245ad.2.1758178422688;
 Wed, 17 Sep 2025 23:53:42 -0700 (PDT)
Date: Thu, 18 Sep 2025 06:53:41 +0000
In-Reply-To: <20250916222801.dlew6mq7kog2q5ni@amd.com>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <2ae41e0d80339da2b57011622ac2288fed65cd01.1747264138.git.ackerleytng@google.com>
 <20250916222801.dlew6mq7kog2q5ni@amd.com>
Message-ID: <diqzh5x0p7yi.fsf@google.com>
Subject: Re: [RFC PATCH v2 35/51] mm: guestmem_hugetlb: Add support for
 splitting and merging pages
From: Ackerley Tng <ackerleytng@google.com>
To: Michael Roth <michael.roth@amd.com>
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
	mic@digikod.net, mpe@ellerman.id.au, muchun.song@linux.dev, nikunj@amd.com, 
	nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	pdurrant@amazon.co.uk, peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, 
	qperret@google.com, quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F0299C0002
X-Stat-Signature: 3o6jnkjt615k35zr4pkogsixwzowajo3
X-HE-Tag: 1758178423-870223
X-HE-Meta: U2FsdGVkX1/E8Q7/0ndsCRXN8X7PI0yppO3v+GlX+lTBYxD98gvUl9ZBwOsk85CJ/LReyXkw49+Jb6TgW2LCKyyqOnqiChACAZ4jmUdFmcdFl0pS3vy8tDs/Gx9ypwjz5Cset5XDGrXw9UCEzMd4sM17eNjbl7MGMDT1yGlM3vBb+53S7TpfvzS2f15dMgSBjXt2q6MSkmbMqv0Itfo23T46y2H0xPE79gmfvSdSYpwfQ0zLXbsHjHm9zMQ76OnqWOIB6drz4SWhRwcHs5KqIJxEPAUFtmoMxLiJNNZiLlQt9t4xBuD1IBe1cAyEsG7+9JRkkE3rvnAYCCGsoqjv97lqjKPnDIvC8/wTKHEV9F5vBHjfCfF5HNo+YYG4ECUqjJ4elZFVKk3m1KgUHQ5okI2a4GAiqWsWTv/xry53QyHw+mYAi678+XbdoNi+ESdS3BCgQbaMrwFWxwd6U7nn97COTbi8RkW3uiqstZixfUONOPGwjatLhAoRJ8xfggtlElADd0JloNXMhUpmBablJ1xxWkzrf9qdWoK/2nrRXOyK4NXS9xiZ9hxcMNzigSgZVEpw1ULq+cN28PerDgugzWT4s9xuDOFIakv87h8UH20Zjip7TnwKJRUaWCncipRD/ZsqRmVMAAvPJxAtOQatRthVlWewbVXVhvFQp09uZdae+XXryeV1JOsaIP8Uhl7KN2ACqfCLNBOt9/+6r6+i9ZY2+ErOcOsXGftTFSZRcy2pdLFYJOjxpywB3hinws5tPzDHO+7q74/rPc+lY7SNsyueg9PENQ0fRLCcqDdJLy25Hig9rP9524zUg3nQRD08mXCIlhI/hK33PJT0YuQvUbx8deIBwQ7Zp7lu0XGCGxXvKGtIA+HO4PfKBbw7zFdTExsiJClIlL0zp5tYUnpHczxFFOuiRvqyA+WlocGVpU/it5bsbJF/CL7VnTr1PasCJEFABZ5H08qo32VNuBu
 KCNM7ZV3
 GFJjJCzu/FKn7QHcjmpb+ocleTMEDcbVNRmsbBkoSEU0hCaFjVjjxkFUGkogZIp5oyH20YE0S2LN57wSXwCr5x5sU0yM+29KHtwCQbD1rUP2XvpfvEPgyZveVUO2kR2NtFNdIe8TpO/pPEwF5HvbDLrS/Xt10+o/PJkA5Yck7Rl93s4eDNQGkUOYMpMVLzfLLdg/2kyD6SkwQLwlqxm9qU6C4vVKY9+K1KuI9VV6xr8hDxahLI5Oh6NjQSjpbO/wjgaxixE4duS8hC84dZlJUXgie6m0Xkc1v6XRVjqtUrc6zmiKScPBW/TwRJDEnNGvx8Er0uckDJV4AOOZukOaEix9aJcMx5YZGHVQhAf/rZjE1yo58E/cbrzH+GeD4k4OjnqEC6WBL9FRUIWOJXOC1nXoj1xi2nD64Uu42AmyUHUib8IO0YM+/+bO9wf9ve+sBK5vEN3Lw8m3k7jOlIo+rBkRQRdsBZBEojU2xFJTLAeDbgcFPUpZ+/q/3XSeA+YuvrHop7J+mqvKo9jz1xIP5xra8co4SMTFfzIfZ6iOZiFPXk+jWy3gutpTyyGvMfvA0ruhYg/6/DYeR6Qlx++ynTGJ9+VG09+m8Fv+9KpJ/30bWFS8DzE+eiGkLeeRYZcCos5anCk3hibkQuYwFaMy4vUI5RaW5tuoT+fPzjxq1VwkzKr7qdAV8kMKI7fA7Uz/rtaxV5XXg4kuKzvLOzKrwMhQP7NyJwGEE/dgyvRb9+1tRZpj+edXh3YL9UAo7NtwAB0TT1V5EvhBckRYtfKjaR3o2kEptjKyoFgbY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michael Roth <michael.roth@amd.com> writes:

> On Wed, May 14, 2025 at 04:42:14PM -0700, Ackerley Tng wrote:
>> 
>> [...snip...]
>> 
>
> Hi Ackerley,
>
> We've been doing some testing with this series on top of David's
> guestmemfd-preview branch with some SNP enablement[1][2] to exercise
> this code along with the NUMA support from Shivank (BTW, I know you
> have v3 in the works so let me know if we can help with testing that
> as well).
>

Thank you for offering! I'm quite backed up now with some internal
work. Will definitely appreciate all the help I can get once I manage to
push out an RFCv3!

> One issue we hit is if you do a split->merge sequence the unstash of the
> private data will result in folio_test_hugetlb_vmemmap_optimized() reporting
> true even though the hugetlb_vmemmap_optimize_folio() call hasn't been
> performed yet, and when that does get called it will be skipped, so some HVO
> optimization can be lost in this way.
>
> More troublesome however is if you later split the folio again,
> hugetlb_vmemmap_restore_folio() may cause a BUG_ON() since the flags are in a
> state that's not consistent with the state of the folio/vmemmap.
>
> The following patch seems to resolve the issue but I'm not sure what the
> best approach would be:
>
>   https://github.com/AMDESE/linux/commit/b1f25956f18d32730b8d4ded6d77e980091eb4d3
>

I saw your reply on the other thread. Thanks for informing me :)

> Thanks,
>
> Mike
>
> [1] https://github.com/AMDESE/linux/commits/snp-hugetlb-v2-wip0/
> [2] https://github.com/AMDESE/qemu/tree/snp-hugetlb-dev-wip0

