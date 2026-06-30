Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2951C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF90B6B00CD; Tue, 30 Jun 2026 06:45:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA9976B00CF; Tue, 30 Jun 2026 06:45:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49C46B00D0; Tue, 30 Jun 2026 06:45:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91BE96B00CD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:45:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B8C4A0419
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:45:37 +0000 (UTC)
X-FDA: 84936247914.23.0671C81
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf11.hostedemail.com (Postfix) with ESMTP id 657EC40002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:45:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="V4g4L/fj";
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816335;
	b=vDx1GrKXj3cxIJ5Zu1xvKJwZqkpJBk3/lSJU7oyTbCyleCyFDdi63j5SG12K6/pFxKvtDT
	VHKUOOdTvhhhqs35OinihEnwSBcPYYgTGEPHpVh5TJeAN8apPDJdKip5Bii2A8AIcbRsl6
	qrtAHg64ZW7TjRxp7rb09ppguaMfMPw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekoAUNistv8Md48TkYFgLR/cdXxzwmCGfsoPMwYS1Q0=;
	b=VorJE75U2z1H7I0cUrOEFOD0hwS0TdY7Dx/tNoRAhS8D6KmgVMjzazJkm2qYAVi0vDE1fr
	+pp04uNQtLKDfTkh0heyWhi6QUnsJrtjCChDHPt14AskJ5rexw24JAuqqqcJ2r5eUdypze
	fecknRiaS7aGDnZnhE2ZprdAN4mJpGQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="V4g4L/fj";
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782816335; x=1814352335;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p7ttWHTIJD2B+YvyB5/VMyFJN3tiZnBMZB/A/uANGBQ=;
  b=V4g4L/fjpy1qPmiAdNjU7ZjfLXfzXucyW6BEy2YQS8mgkrQnDOUQ7woa
   BRy+XTgalg2KrsTynq64xICGh9SauIZxFMJ8tkuPeKX1WKtRiy+PLElAC
   /CNP7p8ILPjnBI7qAdtXeXr++j4jylAkdb2b+i5F9jB5Kk6E/V3khFcQK
   dpOWU07mUJsbA+LZ55yemwjk6xrfrfEtiPJC/jCmugGLMIKOkm9pQedO5
   c8AyM7LvHskqhlwuz0qc+Bh1gAL7NF4Vq68rp37Ik0t1PFxhxcJKd93jP
   CHbrP7vuIEI7sp/+TsfAHrzTBbcGxnxscbMTFTX2O4P5Y3OXV0YnzPML9
   A==;
X-CSE-ConnectionGUID: AVj/YP9lTwGKyg11GAYcbw==
X-CSE-MsgGUID: YdihBpyJQnerV3YMgoKXgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="94676778"
X-IronPort-AV: E=Sophos;i="6.24,233,1774335600"; 
   d="scan'208";a="94676778"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 03:45:33 -0700
X-CSE-ConnectionGUID: G0umWb9HQS+An4zhZ2J2GQ==
X-CSE-MsgGUID: 7pJP5KKLS4CYFPJWUNGiXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,233,1774335600"; 
   d="scan'208";a="251179200"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.239.158.70]) ([10.239.158.70])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 03:45:19 -0700
Message-ID: <8206e8f8-4759-4dcc-a764-1c7b0ab0a757@intel.com>
Date: Tue, 30 Jun 2026 18:45:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 02/46] KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to
 KVM_VM_MEMORY_ATTRIBUTES
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-2-9d2959357853@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-2-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: br3ebxrp5djd3gb8464nr4joge74mkof
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 657EC40002
X-HE-Tag: 1782816334-578394
X-HE-Meta: U2FsdGVkX1/LjfTQOnYi1O/OycioDiLQlkCJHVBOU8A7BRYTsZoeA0zxDnIIBHryGD2SsV1o/NewL5oX8KXhq6GtJIz2bbSFMLabZusMaFwufkPpiuw97nKMivBIZb4taDUuJuqlyCKdnsFuW3qGt7wc4CJcjTl1WwxuRQy2V0Ktmd5p0RvDe1lq7wkt4/gW65vYCpxD6Dv5lv7znIgyQf1EuuA4PC7GfOjgpnpe6yz5KTeW/lrl4kgVr+rfkRAMQN1Ism63ygOxIUa/nvFloLLAGisr4j59lfOw4qq527c8GP72/cmhdL5z1dcGHEKh9aXYNo6D+g8lnD8SZeEncB0t5hmAt51qmdXPh2ddlKhK07902SVnUYT3hsxYTOCJoByQRdzl2w0x9jzCLskwHPsx9xEY+fbEnKepEBPuwILVwkwGEjPVT6Sf/nsR8Hl11tPIDqyjvelgdB/wVuP2CDjbvok1FujXBTZKY/aWTsdABxH4bH7MEcOJcSHZLJ77MRZAZFT+NaPS5pQvzNNqq9XrhxIBqlUQVQ+N6itBbLTVOyxAw3UmO/otNfk/FscSPGmGKNoo6MbeRGl+4VriVf3p2p11Ux90C4U44Yqo/t/jsynyOPNjMpfcxw5iiqBAWvtaY7QoYjCgh8Fh69ZWX29hSHDFf6HoDNr5ffmjPQK064Ocj0uEVNdDSgd74qxuZ+WxOKhurNhCDZBa8FY6Wf1MKO+PuNO0A6AmkV4SaqZb5+BQeH15ZHvabsyPSfjS7pyt5HWAobFGFU91u7AtKeBlADxsW50nqX589276msUzADapjy+PqakRBvbq8Q8TgwKJ+1BSNthFwcF0sUl/YaI6crAISpLO1LaNddLzGFIkweJJ87QWunCsDFyM/EuHVxosKBEBscvsEoWLcMcbNtnuNp2GZm4AfLhNk0IkUbm1N5Pye6y/Rc8jENpAjfYZjy3G5N4dHYC7IyTtsbV
 SWdo191A
 S1nsSnJJw8++hBm8SZcyooTYV0/gG0XNStgnR0C9tuhVPlWiStwbTLuLf4Kx3zk1LTMAuef5xmGOOVdoBr1R+xJAyfpA1r54VPMOMjHQ7X1LO/JLm0F0SuyRWfuB52OhNlykwgq2r35vq75CG0CwIf2WcEZwziipzrJWnHjFH182x2zk16HTc5Dch2e4HE/i8za7mOn4Uv0FYiMUHHdH9sAqG1jCcg5kBI9wLIYxZElJzlsFtAgW+lDHahMJCsLfvBCg9iiAFCoBaousOuX5772Qa2yCB7umtFoVzi1u/FaFBuoM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Rename the per-VM memory attributes Kconfig to make it explicitly about
> per-VM attributes in anticipation of adding memory attributes support to
> guest_memfd, at which point it will be possible (and desirable) to have
> memory attributes without the per-VM support, even in x86.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

