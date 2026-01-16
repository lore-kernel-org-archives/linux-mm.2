Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0217C982D1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D39E6B0095; Fri, 16 Jan 2026 10:41:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49DC36B0099; Fri, 16 Jan 2026 10:41:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 393816B009D; Fri, 16 Jan 2026 10:41:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2189C6B0095
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:41:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BAA44568B6
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:41:07 +0000 (UTC)
X-FDA: 84338240574.03.109912A
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf06.hostedemail.com (Postfix) with ESMTP id D17B7180003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:41:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GHBQVDxg;
	spf=pass (imf06.hostedemail.com: domain of 3EFxqaQYKCMM1njwslpxxpun.lxvurw36-vvt4jlt.x0p@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3EFxqaQYKCMM1njwslpxxpun.lxvurw36-vvt4jlt.x0p@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768578065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbz4P0q8LjyF0OVI7OVejj9Lnkf5fBOIA9+hzT8ibrU=;
	b=sE/xivRUwQHE2xi2/NjrWY9BZ2NaN1gzrfQchek4tBiMwfo5DwOckEy8vJL0fJUBT15HII
	XrmPnizhwv91fnvP6JKFkbh/YTPUTRVTuOCE1nA7dtiUmXB6kJBFpJST1lg88ygwI5a5eC
	5dzywKMKdRrlBAJ/D9IiolaKcD7lXdg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GHBQVDxg;
	spf=pass (imf06.hostedemail.com: domain of 3EFxqaQYKCMM1njwslpxxpun.lxvurw36-vvt4jlt.x0p@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3EFxqaQYKCMM1njwslpxxpun.lxvurw36-vvt4jlt.x0p@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768578065; a=rsa-sha256;
	cv=none;
	b=d4uj/CcMuDZr344h0arv287asrvIZKfscdvUqKUncq1JFuJk8kjEEGxpV30OlUYN6bOkJT
	9KPbE3Dnt4fNXQnTl7tXLa4GKix1n4moP9SbFPdBUdWq2S67DbOEOXcJQSMuXFa8b2XLjV
	OTcgw5/5n9knUyLq8AErEE16LaGoOOs=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0d59f0198so23284225ad.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768578064; x=1769182864; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cbz4P0q8LjyF0OVI7OVejj9Lnkf5fBOIA9+hzT8ibrU=;
        b=GHBQVDxgepel9sUyYztV1+V2t9WWTk/V5nLmjOqgzT0zLGQnQb17zg6POI3oG+JrqE
         gVKjvzbDELbuT6Qj4OkV/y576Isrr5DHjLJhmxw+KzvlzTFIZka8YcVyrlcG73RabgYo
         Qm5JJTtncBnaHtvNwm3P1nZEhd6XODt3Evd5J9yWAzSFi+WFQa8lcu2uGhivVE922YjU
         tAQ1g4FyGXKp2fSWrINY0dc34pv6nKRo7937LzbY2gNhZkMqUev4RhX0I6sTdFM8Drp+
         Ij0gepYddr5dGjc5Tgmk4sN3fT6Yacf9/fhyz8l1p5Tw3eP8NpFFdd48AcZKMaSI0tek
         HqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768578064; x=1769182864;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cbz4P0q8LjyF0OVI7OVejj9Lnkf5fBOIA9+hzT8ibrU=;
        b=MuW+0SkDaj6TcBh5tWj7NWINk9IeGkj+gk38Z81L02q6aeunhtRaHnuWcwcwroGldt
         OnAldVAGNMz9ac9F9Kd1lfjvXnkuNOpOWJjxiTA8sPcHoyg5DL/8P/ouWYFI1ng33IQq
         WGpwmOEEHcOTvvgL9DeLpbDO/dKYozr+QAa7ex73jWDBkWHgzhYusTZdY7E6cPkcYV8D
         if2z+UdmnJ4rPMORffc677x8/3l1PNK7h23GlI2R8iI4Mxo/jbJb1p9iJD/NtWainXDp
         mJJBHTiLR8qElwMSHTNV1ONfZV0fynxLOps/2jXSXwCNSRTDGjx71zmFQ9sELFwsHIoO
         SqpA==
X-Forwarded-Encrypted: i=1; AJvYcCVPPfb6Ytic9enqP/r7dJwjacxWcRH6x7Z/C7pEBc9SQGFwa0porJ7yuCWCRYAorP3BHRxDoBXcgQ==@kvack.org
X-Gm-Message-State: AOJu0YyOJMQdEFlOrJn+bsto2DK2T+Q8wVVzTAmxXX1XCNLAy1rHlV6y
	XlatzfaMwUxecwWTV5GKy+uoYalrvaG8QOFtgQCPcVMcp1VfFAnMVDkUJdWjoHoTIVfFeTW826i
	41Qn9mw==
X-Received: from plss10.prod.google.com ([2002:a17:902:c64a:b0:29f:68b:3550])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf07:b0:2a2:bff6:42ef
 with SMTP id d9443c01a7336-2a7174fa860mr37848805ad.7.1768578064299; Fri, 16
 Jan 2026 07:41:04 -0800 (PST)
Date: Fri, 16 Jan 2026 07:41:02 -0800
In-Reply-To: <4781ba9c5d16394cdd785d008cf2a2d81c5cda35.camel@intel.com>
Mime-Version: 1.0
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
 <208b151b-f458-4327-94bc-eb3f32d20a68@amazon.com> <4781ba9c5d16394cdd785d008cf2a2d81c5cda35.camel@intel.com>
Message-ID: <aWpcDrGVLrZOqdcg@google.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kalyazin@amazon.com" <kalyazin@amazon.com>, "kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "david@kernel.org" <david@kernel.org>, 
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "jgross@suse.com" <jgross@suse.com>, 
	"surenb@google.com" <surenb@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de" <pfalcato@suse.de>, "x86@kernel.org" <x86@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>, 
	"peterx@redhat.com" <peterx@redhat.com>, "ast@kernel.org" <ast@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, "pjw@kernel.org" <pjw@kernel.org>, "alex@ghiti.fr" <alex@ghiti.fr>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "willy@infradead.org" <willy@infradead.org>, 
	"wyihan@google.com" <wyihan@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "jolsa@kernel.org" <jolsa@kernel.org>, 
	"jmattson@google.com" <jmattson@google.com>, "luto@kernel.org" <luto@kernel.org>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "haoluo@google.com" <haoluo@google.com>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"hpa@zytor.com" <hpa@zytor.com>, "song@kernel.org" <song@kernel.org>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"peterz@infradead.org" <peterz@infradead.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jthoughton@google.com" <jthoughton@google.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "shuah@kernel.org" <shuah@kernel.org>, 
	"prsampat@amd.com" <prsampat@amd.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"gor@linux.ibm.com" <gor@linux.ibm.com>, "jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"andrii@kernel.org" <andrii@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "joey.gouly@arm.com" <joey.gouly@arm.com>, 
	"derekmn@amazon.com" <derekmn@amazon.com>, "xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>, 
	"kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>, 
	"jackmanb@google.com" <jackmanb@google.com>, "bp@alien8.de" <bp@alien8.de>, "corbet@lwn.net" <corbet@lwn.net>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "jannh@google.com" <jannh@google.com>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kas@kernel.org" <kas@kernel.org>, 
	"will@kernel.org" <will@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zrbf11pg6mjxkg85agaob3n376bxrg5p
X-Rspam-User: 
X-Rspamd-Queue-Id: D17B7180003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768578065-536111
X-HE-Meta: U2FsdGVkX1/O27fjCZjZl+WfFhv4SVR3ho/22bIl4iO4DG7Lvk71TUdwojkWBljejECzk1JwfMIJ+pttbKG+G98NrRIYGadLBMxSkSddr30olbGwGpCo6HKGXgmZK1sIYsYO14XEzN6CkgWsQWYo6sTHf7iLIDIgVz9qH5Xc95XP2q+93cbHPQTRvuUAeiRBWoeX+BnH6MQmAyvQrkK+UUHtaAMGpya+4RS/JWUUsyzwPSEwpCEX/oCkjsYMyAHC2jlJueS+nIYanbeWhyCGGw1WSdnVSk8LGKaGfFl5jNtV1hrsi31BhyUOf+73NrsIuGPVUWjZjGWNLXuAbKGJz1yWrwoOvFuxQ9ZyhLUT3gCzh+TN5DPPxc/xuNuFr3bctHdm9on5tS7cyAb7Yag7lXRrsl1C329wE5jEHnS8x7KlJ/TQzuRE1++8asZphz157j3TI/y6/A1e79QaWJTU9/UjeYmpfihiENd2Awy5Eg+b94nONbOIbiifGpzCu/q4CCJo6/UGHYO358oRUniWW3hNzteVA84VONHvZeGYfjuVyHra88CjKYeCimtgL7n6lpLTHenV/+wXm63EsYHl/+RhnD0d7/ISpWWfyk7Qt5jaPNPLQ6hfjgZoIyloedTCll8IwSR+2WiXKzKsT8np5qyJVu93LWD94/ZBv4GqFmFLQ+aXBmkXtBSnnHN14ALKCfXYLkitYnpqZmAwrVtkpKCp3gYxvywSN63pSIW451OJh9V+yhMJtaUYvS+NshkbfU6y229h8+Lgd2HyKnTYhAyVYaxeUQ4hDB9qWudr5wH6QdML00V4bfu+ZUWJoi9QZiDuih687uK0P/RGTZcLiRSpUP5nlTwk97Z7q4SnqzE/v22Z7cNKgRz+fNHMn+Czherv3wYc7ZyA6PxG8Az7z1Hlqs9HiZVe1yXbDgsCD7xiEp19+lRW1K7dKyxTINVGRadCVqoXY0nZvXs3r4e
 QAlNB2w7
 zm4I0Ugn/DsDXf1HhsULfvmMLKIrkNo++ekLEP/Xd9glLj+QAvkG4+6eJDOJR7enqe0FlguLuYwEWRCcDPIuMSWepTRdY1RNiWvLg3Srv0N0KW1AdIk5jIXAdMASEWr/6Sd0SX4Knzfx3cydRnUHJMxy65DtqnPvQfq10kGvd7jpjINyljfs5ilfoJ3jQJu1RIRStRnrjAEW7akcxr3uGwyri3GrHfCZnAUBcrmE7HYrNEbG8UlocTEyFB2+/UvxKRcsqJBkh2x7Z8gRIEMnA8at6Uzp+IK6ephMR5cXSjDyBTl5ey62kCShMh9+eRzNHHMl8x8fEyaYuoYEWgvLndmwPNeSQrXNyP2/P/9xTwqDuBNOewJw/w2Y5OC3WaO/1/BA1b2WTOQFKgNn+1wJcBR2BkRA/A4x494XwlvEOc5HIqToo41TT9ouPGYsjCibEIg1D3mrr+EoTvMPEVHdBVGqijgvGa5ttvasm87TQYBBIaCm0mLbez+lBqAhOD6eOxYb71PwNFBStN82Eme9ra3JeEQtyViRQYAlAJbpr5pWIxwCs3sKVH9ONR5dIH3XUNHlfs2HjpTrzsjgw6qe2r2WQmlDJz6h7HdLje4Uq2cubW9u2X6lIW0lwl6N9MMuhVMJx2oEEGs5eFnl70yMOTYTgDG/if0nSC1AzvNPFVANPYoigSL/bpgCXpoAhO5WN+qdpfqdal65w9uvfZPIxRMs5H7od78B9qFNlDSrJmwLtlicFJlFcn8jZ/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026, Rick P Edgecombe wrote:
> On Fri, 2026-01-16 at 15:02 +0000, Nikita Kalyazin wrote:
> > > TDX does some clearing at the direct map mapping for pages that
> > > comes from gmem, using a special instruction. It also does some
> > > clflushing at the direct map address for these pages. So I think we
> > > need to make sure TDs don't pull from gmem fds with this flag.
> >=20
> > Would you be able to give a pointer on how we can do that?=C2=A0 I'm no=
t
> > very familiar with the TDX code.
>=20
> Uhh, that is a good question. Let me think.

Pass @kvm to kvm_arch_gmem_supports_no_direct_map() and then return %false =
if
it's a TDX VM.

