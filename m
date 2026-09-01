Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 596D1C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086266B0203; Tue,  1 Sep 2026 10:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0361F6B0205; Tue,  1 Sep 2026 10:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA4486B0204; Tue,  1 Sep 2026 10:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD37E6B0202
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:07:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1BFAEC041E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:07:08 +0000 (UTC)
X-FDA: 85165370136.07.85E8858
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf25.hostedemail.com (Postfix) with ESMTP id D033DA0009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:07:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MPdwjkFW;
	spf=pass (imf25.hostedemail.com: domain of "prvs=6971a9248=itazur@amazon.co.uk" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=6971a9248=itazur@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788271626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwbUYxXHQaXTXqslqakO/JmHO0leSCcNPKEN6HpwsIg=;
	b=XcgOGtf7+eedPwi0bQaxwfpFf/Yd3iiiQ2E3Ckm4aJ4PHYVTFYNkCfct9CstKDtASVT0FT
	n1kJKthvISDBaSXVwDE3tGXqPeSQ44YPtGtefpsSMuwd6BpBrdkbX1kvHHAtsoTpJt+Ixu
	Pkz7aRbBOihy0N6ty+u00UeNMGA0Lu8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788271626;
	b=smYefdCNJwH2QJsSHgoKPNLlfSsv5F5m0Hi2yF7NVkD8jxiLQyMCT2sERdQyNQOyZwJ5V4
	B+uUhgObgl6l7473IF0+SnO68sy7jc9V1xtQQiSCdb70FB9hiH4RlRHWxh0P1pGLjUCIXH
	q7OJtEZhW/BmTa26zoLHUivNBgFTJDM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MPdwjkFW;
	spf=pass (imf25.hostedemail.com: domain of "prvs=6971a9248=itazur@amazon.co.uk" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=6971a9248=itazur@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1788271625; x=1819807625;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gwbUYxXHQaXTXqslqakO/JmHO0leSCcNPKEN6HpwsIg=;
  b=MPdwjkFWrfa6dJPtq/YabRBPOpV1UTECJbQ2tvIr9ava77J0n3RMlptQ
   W8Nb0tH3Y9nv1v0ATx+yBnE/jjTK9efjjoCcU8++SdjQNI0a0yZffFK6i
   XbbFsjCrl2BjdExAg7P7PbhLeWRE/yDXbrDvG3+K4AsTNmIxr5Z5Zy8fZ
   oHnoXeDKlhlkGJPX7g7aD35y8hccpgpFwsB1MpTNitMO6prunD6xWrBpB
   DFdM9pInal6uudq9FU8f4lH5sLtTrEqxwaRWOA4yujughApzmnmtM9heY
   pXtDctQywq9ISwqoBN3/Gbgl/wbqraZF8aVpu4PekkRofQtTqfaBOnJg4
   A==;
X-CSE-ConnectionGUID: g7Zx9TRQQvWpTs8W3wP04w==
X-CSE-MsgGUID: 9pLg4PSzQd6ZYHeZKQt6qQ==
X-IronPort-AV: E=Sophos;i="6.25,256,1779148800"; 
   d="scan'208";a="27537013"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 14:07:01 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:11398]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.146:2525] with esmtp (Farcaster)
 id 8f131d5e-0695-4138-b720-3dbdcb1830d0; Tue, 1 Sep 2026 14:07:01 +0000 (UTC)
X-Farcaster-Flow-ID: 8f131d5e-0695-4138-b720-3dbdcb1830d0
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Tue, 1 Sep 2026 14:07:01 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.82.17) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Tue, 1 Sep 2026 14:06:44 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: <brendan.jackman@linux.dev>, <maz@kernel.org>
CC: <Liam.Howlett@oracle.com>, <ackerleytng@google.com>,
	<agordeev@linux.ibm.com>, <ajones@ventanamicro.com>,
	<akpm@linux-foundation.org>, <alex@ghiti.fr>, <andrii@kernel.org>,
	<ast@kernel.org>, <baolu.lu@linux.intel.com>, <borntraeger@linux.ibm.com>,
	<bp@alien8.de>, <bpf@vger.kernel.org>, <catalin.marinas@arm.com>,
	<chenhuacai@kernel.org>, <corbet@lwn.net>, <coxu@redhat.com>,
	<daniel@iogearbox.net>, <dave.hansen@linux.intel.com>, <david@kernel.org>,
	<dev.jain@arm.com>, <eddyz87@gmail.com>, <haoluo@google.com>,
	<hpa@zytor.com>, <itazur@amazon.co.uk>, <jackmanb@google.com>,
	<jannh@google.com>, <jgg@ziepe.ca>, <jgross@suse.com>, <jhubbard@nvidia.com>,
	<jmattson@google.com>, <joey.gouly@arm.com>, <john.fastabend@gmail.com>,
	<jolsa@kernel.org>, <jthoughton@google.com>, <kalyazin@amazon.co.uk>,
	<kas@kernel.org>, <kernel@xen0n.name>, <kpsingh@kernel.org>,
	<kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>, <lenb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-pm@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
	<linux-s390@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<lorenzo.stoakes@oracle.com>, <luto@kernel.org>, <maobibo@loongson.cn>,
	<martin.lau@linux.dev>, <mhocko@suse.com>, <mingo@redhat.com>,
	<mlevitsk@redhat.com>, <oupton@kernel.org>, <palmer@dabbelt.com>,
	<patrick.roy@linux.dev>, <pavel@kernel.org>, <pbonzini@redhat.com>,
	<peterx@redhat.com>, <peterz@infradead.org>, <pfalcato@suse.de>,
	<pjw@kernel.org>, <prsampat@amd.com>, <riel@surriel.com>, <rppt@kernel.org>,
	<ryan.roberts@arm.com>, <sdf@fomichev.me>, <seanjc@google.com>,
	<shijie@os.amperecomputing.com>, <skhan@linuxfoundation.org>,
	<song@kernel.org>, <surenb@google.com>, <suzuki.poulose@arm.com>,
	<tabba@google.com>, <tglx@kernel.org>, <thuth@redhat.com>,
	<vannapurve@google.com>, <vbabka@kernel.org>, <will@kernel.org>,
	<willy@infradead.org>, <wu.fei9@sanechips.com.cn>, <x86@kernel.org>,
	<yang@os.amperecomputing.com>, <yangyicong@hisilicon.com>,
	<yonghong.song@linux.dev>, <yosry@kernel.org>, <yu-cheng.yu@intel.com>,
	<yuzenghui@huawei.com>, <zhengqi.arch@bytedance.com>, Takahiro Itazuri
	<zulinx86@gmail.com>
Subject: Re: [PATCH v12 09/16] KVM: arm64: define kvm_arch_gmem_supports_no_direct_map()
Date: Tue, 1 Sep 2026 15:05:21 +0100
Message-ID: <20260901140520.78333-2-itazur@amazon.com>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <DJJ28Z81JTQI.1SI0CNIP7W1JQ@linux.dev>
References: <DJJ28Z81JTQI.1SI0CNIP7W1JQ@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.106.82.17]
X-ClientProxiedBy: EX19D038UWB004.ant.amazon.com (10.13.139.177) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D033DA0009
X-Stat-Signature: ifccqtawxftazmcaj6e66uapxwizems3
X-HE-Tag: 1788271625-742698
X-HE-Meta: U2FsdGVkX19FNjo6mMxvT8cPv5Fk/MYRI9Tklpy30LCz0+UXQfR+5kG5MCoivoTN4mDhvCDEyUP7IhSblbKQkaN8486gxXByc43rS5aHe85/UXnHDkXfu5WKX71MJRFAbn2n4WzaHbfmRSWov+CFwmfiw9B/bXKscij7sKQOaGcYEoAsGdc8z6f/bV6mxvCjOx7rfVHuqDMYjD9iIz9FSH2l+RuBEO9LlnbeRarOZTHDd/3wz4KGSbGxSWcfbvaG5RW/FwoKLTKj1/z7QPBjOm85wWzbxl/wEqOTmWTepe7OytjEFF2OSNSpzYbPly3SkndCj9CBY5JMEGCDY1wyybk/WlgGM7jKlr5sP0++cI13SQImlQTUI7LB8Rj9zY4Zd7HRuxet1UD4jlf65buYLXprddqKRFdf4RJoN8ZOGUXGD+pbGUbuz/JIzIqkp+JTPENmakQfQgdRAIiail5pLOiB+2Ia/PscXRuu2d1QTv+IFnaI7k0ufWi+LOhI1qWhlk0gABkrP+M53ea+brwNb+CRXpCVkdh97fr4OdBueNACQgfqf0aDHuFNkeH12Zm6A8nw6g4y23S26PCzVUL6fHjUcCPaEAEIpjFT92icg1Xo3NR3vcYlPBm8kgCJIHlo6z08g6ZtgNGGI56k2UHumtFoQjQuqetwv5HMnGTvqTMW3mDMW8HLY/WygUF3fPCZmkYr+LTUHBIRPNhNiO750pEB4Xy6sJfzVewbQyDSVYlmeczv0Z8qVN8d7RdUTYHKcNtXKojy5FUgSFRJat8rPyQpvps/SnbLDS/44dcAikV3M5HTFacTq3ccPBzDTAIHHnU/aXLQ4cXWTJIS9uif2oYqIEyr+Nib/+GF6arD437/zSZyPZJpw9fQ7+mnwpLATXNntTZ3ip0rmDucbgZXSbdz3BaEdSvBBz9ERcz1lktUNtfiGGOnfnseOnmVk1gQzZ+xSyyE6v1E1S6lFDO
 6bl3KwV3
 JvrREca9yh3ePQjSpjUnKmjUsNmxouLggEVACuOE/zoryjerIF0mBrTPG4uupR1yOqM2R4j5DNDFW9YlSOgAFcCmd/mdzzrU0QccWfkiUuabzgsdk+Y+S/WKzb9pqV3AowpPqwCndWfDcyav+9XEw7YkDgSCgasj8y8x3lwuibVczUNLpsspQbqS+A5L9YJ22lc1/vLE25mASAi7oZ3Tcjg2hzIGUYu59ZSRHUo0O9u1nwrDtxD2YGh5vvOyPnruNJXyljI1c4iOq8b0s7tNXG0W7vVu598xlE5fQtXpAgl1nG1OjBeCUng0eDra1Dr297JbdlB/IrkMdm0mYSd2ji71uqaEZyisGkXT9v02egmfWmETkaXvfp1fsYs7ecV9eDLFdOab13bq2VLP89qghPtMg2jwjdwLA/C3Z+S/y8PNwIyEKGb3l111LxRPFFjDZ3mW5cbXagVQAxnT/w/ivJ9v7LMNP0kA01X/cP0EXOlWuWgM10CtVZIeYxSBV9GVyMo4jRK9fi/61TSx4UccdxFIpoZAtEKWcN3DQmZtzC/nqh2buwSJX/x10db7oaBvbpUV/lASkA/FpIfuNB+it5REem4CX6SseTW5XbjqokBn5aJDI8ljqhmpJtgf4kV01iDaMX5k0oUA7b8eyrUZaJ6JJz2r4APxa/svREIFpRgIrMs2EJ9fEubaRJW2pMSyo06QtthZF5NM8WS3GLkWdDQnEy0EI8ujKHrL9+F/1aJT0S3VnM5LNbywLXzE/BIw965uuGMPtNm9VuA7GupmLrWi0FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apologies for the delayed response, and thank you for the review.

On Fri, 26 Jun 2026 14:45:45 +0000, Brendan Jackman wrote:
> On Tue Apr 21, 2026 at 4:55 PM UTC, Marc Zyngier wrote:
> > Support for GUEST_MEMFD_FLAG_NO_DIRECT_MAP on arm64 depends on 1) direct
> > map manipulations at 4k granularity being possible, and 2) FEAT_S2FWB.
> >
> > Where is this 4kB requirement enforced? Or is it that you means
> > "PAGE_SIZE"?
>
> Yeah I believe this means PAGE_SIZE and that it's effectively enforced
> by checking can_set_direct_map() in
> kvm_arch_gmem_supports_no_direct_map().

Yes, this should say PAGE_SIZE rather than 4k.

If I understand the arm64 MM code correctly, can_set_direct_map() is the
capability gate, but it does not require the linear map to be built with
page-sized PTEs from boot. Without BBML2_NOABORT, force_pte_mapping()
builds the linear map with PAGE_SIZE PTEs. With BBML2_NOABORT,
update_range_prot() can use split_kernel_leaf_mapping() to safely split
larger mappings on demand before changing a PAGE_SIZE range.

I'll update the v13 commit message to describe this.

On Tue, 21 Apr 2026 17:55:05 +0100, Marc Zyngier wrote:
> KVM/arm64 has:
>
>         select KVM_GUEST_MEMFD

I also confirmed that KVM/arm64 selects KVM_GUEST_MEMFD, so I'll drop the
redundant #ifdef in v13.

> Why is it an inline function? Given that it takes a kvm parameter,
> I fully expect that you'll have to evaluate this at some point.
>
> But since struct kvm cannot be dereferenced in asm/kvm_host.h, it will
> have to move. How about doing it right now?

Agreed. Although the current implementation does not dereference kvm, it
makes sense to move it out of asm/kvm_host.h now. I'll move the
implementation to an arm64 KVM .c file in v13.

