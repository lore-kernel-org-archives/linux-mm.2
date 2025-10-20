Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE0DECCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D498C8E0013; Mon, 20 Oct 2025 11:52:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9CB8E0002; Mon, 20 Oct 2025 11:52:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE8B78E0013; Mon, 20 Oct 2025 11:52:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A95C68E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:52:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53BCB139C0C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:52:10 +0000 (UTC)
X-FDA: 84018934020.12.0A068D3
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 88DFB1C000F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:52:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=A6RaCm47;
	spf=pass (imf18.hostedemail.com: domain of 3plr2aAYKCIMzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3plr2aAYKCIMzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760975528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUxEjev6w4f1umuBxGfAcuaZR32QUUEbuSMBs3oceNE=;
	b=VBCJeEc2tbJ0MIR0uDBj9u0NfgGf5Dfwf8fHSt5snxiaDqQGpvZo2wyLNPCX8ViSJKdtkD
	bdc2KGsv0kzVNE5LhdNsnsfdkxGEu/EZVahsAt8d2LV0pZujlWu/RDPEo/cHHgmTpMIzT2
	lnXwRctg9h/ekifBAMLNMO1fEGLRLb0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=A6RaCm47;
	spf=pass (imf18.hostedemail.com: domain of 3plr2aAYKCIMzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3plr2aAYKCIMzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760975528; a=rsa-sha256;
	cv=none;
	b=StuwKzVR90BOa1FLtWzqyyQBmwkwOp4K6DxdEXSqz+Exej/wiE5wG9u6Dzmw6eYkA/pH91
	rzwEXbTXqSUnnt3BRz43lGncrZRDe3i7yTOHH2BwNW/vtNXj9NmE1WLm7bYiR1K8QbjRCM
	tbBx5vTgVnDmkxWtLIOayOZNvgORyvM=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33baf262850so4461659a91.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760975527; x=1761580327; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YUxEjev6w4f1umuBxGfAcuaZR32QUUEbuSMBs3oceNE=;
        b=A6RaCm47KySJzu3brAzxmjWh69OeaxKzCJr3Z/YF2cJZM9Yo/DOMYi6Xa9dXuTKDji
         M4XOi9uaR1Nol9dHvlwQy27OnJIi4gu/R8e8TeItvZhKo5ND/KrN/gm34KGEITSnlOFJ
         tNFJOKb+AXRvLU/KLACtC9NKABuLAgk2r+RXtug7HsSQGdnkCyDymGwemPSe6kMVLjqE
         eSYOgOqMfkn4Wafn9Q6BW7e55cWI/KKR2wtLrN7X7ctkWopmlOKqgoksOmcOmv41ZmUD
         sIfzDIXWJtRdZcfstoZQbjqooQduKQk4dFXlU/PwUUnwbpIuCPfy25mzqMEy3PUrwvri
         PNeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760975527; x=1761580327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YUxEjev6w4f1umuBxGfAcuaZR32QUUEbuSMBs3oceNE=;
        b=kRH/WfBFZScAJsxpeX3lDYaYJp15Wi42AiyCqWMgYZfh/0hNaGle4icIqsbMXrnUmh
         pn0AfS89guBt8b2bMqDf+NJwQfpjFXeMmiyNfqvHjHXgsomXxmajimtmEZlWAMm7pTF3
         a1yGV95Gq+vsu4xlkpCCMBZA7gLn12yIqcWb7ehh0pdyM28KrocxNjOOrLRup73g34IG
         kzTh5w2Xp+XqGYJTLqfszNvzVD91iAkZgT3ph9AAPCZQE3nWQ0WSpYrz6epQB1UEZ1DW
         /0zI2twf6RDJrRtWxytmFCuPzC+nMOxsMJ0Een3XUDhRJhAhd+yOfrPCYskxKiBFzOPL
         H2JQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeD2NAegAHcx02b9Zfhqnun8CCLFRN9uaJEQrglf+pRq40wTwOuR7ZmY9yc8MMPcaM6GvWnDXt9A==@kvack.org
X-Gm-Message-State: AOJu0YzUsDAjMxDpywoc32UoWmn5FyezxxxfNixvLk7SOX5qtYg/TdTu
	9LNUUZ5tFdvrrGYRmTOfNG5rZuWJxIUavPLcKscYEliLrk3FoiKs+0kw/ydcWwJQKJqDStRmgHt
	Msve4Cw==
X-Google-Smtp-Source: AGHT+IHcZobfkAMYLqgP+952/xufHk4lZqraqyIEs0BsZFGgLzowAsqRVArAQbVQNZgQWXn7bmNPNT9qaaI=
X-Received: from pjbds19.prod.google.com ([2002:a17:90b:8d3:b0:33b:51fe:1a84])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d85:b0:330:4a1d:223c
 with SMTP id 98e67ed59e1d1-33bcf87f421mr15625676a91.15.1760975526813; Mon, 20
 Oct 2025 08:52:06 -0700 (PDT)
Date: Mon, 20 Oct 2025 08:52:05 -0700
In-Reply-To: <176055105546.1527431.3611256810380818215.b4-ty@google.com>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <176055105546.1527431.3611256810380818215.b4-ty@google.com>
Message-ID: <aPZapWWFGyqjA2e3@google.com>
Subject: Re: [PATCH kvm-next V11 0/7] Add NUMA mempolicy support for KVM guest-memfd
From: Sean Christopherson <seanjc@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, david@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, vbabka@suse.cz, 
	Shivank Garg <shivankg@amd.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com, 
	xiang@kernel.org, chao@kernel.org, jaegeuk@kernel.org, clm@fb.com, 
	josef@toxicpanda.com, kent.overstreet@linux.dev, zbestahu@gmail.com, 
	jefflexu@linux.alibaba.com, dhavale@google.com, lihongbo22@huawei.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	tabba@google.com, ackerleytng@google.com, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, 
	vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, 
	michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com, 
	Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com, 
	aik@amd.com, kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, 
	hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com, 
	rientjes@google.com, roypat@amazon.co.uk, chao.p.peng@intel.com, 
	amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com, 
	ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev, Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: yybstiu4573i87z5qr7x8na54mz3f7ik
X-Rspamd-Queue-Id: 88DFB1C000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760975528-611877
X-HE-Meta: U2FsdGVkX1/o/uNR+gk87e21BtXFxzTTmhhKzzQ/KaFmmfUUyfH69vWjeICIXhkh65OTybds7lJAxDV4bmHR2pgMT0aTzs2jlyogUpaOCf0HpZtj3SQF1NG+X5YAM+UIuilnzuf36HnDovRnkaSopsP7LxDl8fco8t2YU7SZ+SrO7QxYGq2l9hUck0yYILejWp5iMppZVbPQBx4PC6MDm+yAkWfXqtIa5TPwpMMTbrrF9vtWa03+7AVVLfvqMonwGeQrxneKaBANPswepmuD77o0hzZXc8BE7RvJ4r9f/LSlx1op4vd5UP1N+k2RfumSxWfJc170JFni/ZY+zEWV2hxJXfLTKv0MWduYXQxIkXqOq1okQVLTMpthqqoWp11S+lYFKYX2d+wmJkYkjTdDon33D3fpwhSrxH5LMWTsOQ86zG+zxN0EHIoXrQ6o+34CLGecw3VMstBHel8Eu8MocXSWGUFAo7nnFtE61uDDhCorAzQx8E2eLEjlfohW74HN+ABsFSwNIjsnYGwPMpLB6mT3VNpTQxx3iMp7FpSMThHIHK4kyEiNCRUW+F7hyLC3+FkEgC0/BpOH31z2eCVNQEnIV/FsouRK5D8BnrENsJfWY7IM0r2YxlASNnrKm2PIv1SdF7OafYHq1cs02QQfAczNGh8ud3nKTYuS4Ss3sCK5Ryla/L45uipallBMPlpe0ZJi+DnxfnENGHbixyrYIc4ScWV5B9qETz7l8NaDjD4+QA/PfLOw5GEwqpbUJrusmCwYsCaMY43+pWYXoMbed7gq++Awih9xDZsM/8tUwh7hGNbRi4IlGX8bssyAKxKLAVVemDoWWPgG/YyyoOSXEydfyZqnnTb2c232WrRxQ3Qna6wIeYtYOAbii7JMfiOUqbsST20Q8ln2ZOd3n9ayqdXTxynWLVZTzqs/iwlzx8WLEciUddQZoRCWl+JeGkrjLgIpAV2oTZbiUPQHMra
 g49kt2zs
 R/sGdJrgbXejh+J58VVnpxUUxrcq0U8glwO7kZVUt8mUvknKkad0uwBd6NTYqL2jSLrf8aI2aF6Lh+YV5gsMt4jpy9lVqvVdxhCOuz1i6ej5XNYZSwZp7ccqURlf0aNUjuVgR7b5VY/Ua/SrNSZaU7tN6WeshIJhyupppUR0bDhdQxLRePdcWU/qe/w4tqlYLWwmdxkcOv882QFo9ZnW6CRUhGw5GYWjjehHCe4um1zN/aLRiqetGU5HPYWbucPc48BvGWh5lzW/l3aN/xwsRgx46ei3L5Ibucrshs225UqKb/j/nqrDKGLH7l4wKeEnEX+/ezMyeqYxf3EOmwzoDj1PD3xFmZXuekuisofvvrPG3DVGJG43JQ2gcHB0LB8cfM6H4dguiQ2HfueP1k8iyGp9mgTqE93QFX0EabS5awJBFFQknxifNLGHPEgmc7gTatlmW/Qmtmu/YraAnwwv1rdTY3YEx26V0+xiGXP7QaoKOx8Koc1h2EuIuwM37CeQYHynMs3G8w1MfYChcrqm4W9PLN8bbR59oc6+3hHBvrv8plj+w0ixWb5FpINrM772r8vbhxJgWeuALS7vAqNKH7zdS9iqyuKUSDKd4pT8XpUzmnAfiD5Y8B3usRmEi4wJQa0EH1Np0KdXG6z96EvI0GjpoE1Pln70jJemOeEIKAoKM/uiQW52DdXRPKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025, Sean Christopherson wrote:
> On Wed, 27 Aug 2025 17:52:41 +0000, Shivank Garg wrote:
> > This series introduces NUMA-aware memory placement support for KVM guests
> > with guest_memfd memory backends. It builds upon Fuad Tabba's work (V17)
> > that enabled host-mapping for guest_memfd memory [1] and can be applied
> > directly applied on KVM tree [2] (branch kvm-next, base commit: a6ad5413,
> > Merge branch 'guest-memfd-mmap' into HEAD)
> > 
> > == Background ==
> > KVM's guest-memfd memory backend currently lacks support for NUMA policy
> > enforcement, causing guest memory allocations to be distributed across host
> > nodes  according to kernel's default behavior, irrespective of any policy
> > specified by the VMM. This limitation arises because conventional userspace
> > NUMA control mechanisms like mbind(2) don't work since the memory isn't
> > directly mapped to userspace when allocations occur.
> > Fuad's work [1] provides the necessary mmap capability, and this series
> > leverages it to enable mbind(2).
> > 
> > [...]
> 
> Applied the non-KVM change to kvm-x86 gmem.  We're still tweaking and iterating
> on the KVM changes, but I fully expect them to land in 6.19.
> 
> Holler if you object to taking these through the kvm tree.
> 
> [1/7] mm/filemap: Add NUMA mempolicy support to filemap_alloc_folio()
>       https://github.com/kvm-x86/linux/commit/601aa29f762f
> [2/7] mm/filemap: Extend __filemap_get_folio() to support NUMA memory policies
>       https://github.com/kvm-x86/linux/commit/2bb25703e5bd
> [3/7] mm/mempolicy: Export memory policy symbols
>       https://github.com/kvm-x86/linux/commit/e1b4cf7d6be3

FYI, I rebased these onto 6.18-rc2 to avoid a silly merge.  New hashes:

[1/3] mm/filemap: Add NUMA mempolicy support to filemap_alloc_folio()
      https://github.com/kvm-x86/linux/commit/7f3779a3ac3e
[2/3] mm/filemap: Extend __filemap_get_folio() to support NUMA memory policies
      https://github.com/kvm-x86/linux/commit/16a542e22339
[3/3] mm/mempolicy: Export memory policy symbols
      https://github.com/kvm-x86/linux/commit/f634f10809ec

