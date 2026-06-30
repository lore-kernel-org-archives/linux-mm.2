Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF200C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0FA86B00CB; Tue, 30 Jun 2026 09:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7526B00CD; Tue, 30 Jun 2026 09:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD2B6B00CE; Tue, 30 Jun 2026 09:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 882656B00CB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:59:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A92CC27E1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:59:41 +0000 (UTC)
X-FDA: 84936736962.17.6A50188
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5F82EC0005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:59:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UAhQlEmE;
	spf=pass (imf22.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782827979;
	b=avLuaFx1X7vlbKOW8cozAM/tFi2a/2vxr2t/cYoO0Q7+ubDtdtERG/s1+ZHS+b8cXrogfW
	qj9duyqCJJAZGQnlkswrwAqQQnlLJrclo7qfunkvwMLU8RJp6rQPAby09VRkS6QCCHmI0f
	IEqO4PTNWAr0GpO4m2Y6VeNoMWci3rA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782827979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FNxMPYAPB1SCc8H6vQceHbQBOb/CT6PbbdmBedYh/I=;
	b=d54Wk8XNr5VWopI0lkiioYP0/9EIcW7/xU0fS+9kd+HY6Kk5Hj+w8yM4+zulAzN+FFapf8
	DwZhtNsFvozV3pYOPcyInOoeNR40nrzIWQbwztjkfjivt/5Ls1DpeJsKc+RVlph7kNSjQw
	FbOHXY0yaMiehgC2A5Ev1u6viuTzVA0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UAhQlEmE;
	spf=pass (imf22.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782827978; x=1814363978;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oyLhme8KvYEs+zNfk1TaMsiBVBInHTNQshUzxiUOTew=;
  b=UAhQlEmExZmpF/hOujaLy8qhDCjaIgkS2T1t7Rjuv7ZZfi7M8Rz84to/
   dRTiSVeLUWxlnRg8SyvQK/RgUcRclZFGsrg22kC5rlZZ2XorhMuDFrWJx
   55QWA5bBOKMv2klj6qFDqO9pFgclT/c1Zd1hnhik7L0x3OP68TnMi0ixE
   yTW1bIr15G+sEedQp17FVG11VuwF5lZylaanLIoHuD0LycHJ1Ucvo7Bji
   N7zbLf/b33fqW9mDyDDewixr0vAK2LQxZzQOl5A+Ph223wL+YpMEzVA8B
   p392MrXpVXY5oWpGsERQKJkiCSDlqC4F66EY9ZmZXyTogha50LMByCIQ0
   Q==;
X-CSE-ConnectionGUID: bBk81RknRx+cXZ7jGV2w2Q==
X-CSE-MsgGUID: U4E7iVMSTAuBKuVKG7Gw5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="86090771"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="86090771"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 06:59:36 -0700
X-CSE-ConnectionGUID: b3oTOdjFTX+YTYYJ9hCptg==
X-CSE-MsgGUID: SyZ3q75eSoy2xfs0taI2NA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="282337011"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.232.239]) ([10.124.232.239])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 06:59:23 -0700
Message-ID: <3c287ccc-a574-4617-aad4-1f8884265cbd@intel.com>
Date: Tue, 30 Jun 2026 21:59:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 11/46] KVM: Consolidate private memory and guest_memfd
 ifdeffery in kvm_host.h
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
 <20260618-gmem-inplace-conversion-v8-11-9d2959357853@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-11-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5F82EC0005
X-Stat-Signature: krxyk9747b1ffade5ar7rbph5ehnooka
X-HE-Tag: 1782827978-985346
X-HE-Meta: U2FsdGVkX1/bBbnso+GYvW/+bpBt+j/miKEDJmZvIxrp5SbtSGY6BYXZTm2ooDbl3uLQyld9FM9BN5ggHkBdnJhqtd8P5TvPHzJLcjVPcHWYTFxTI51L6UAPB6Hq5wSHsbIMFlVrDZPQQ1JJtnbwRQmpFYpp0rSGEvLNe6qD3yQa6AtH9CXoW+1xoF5636HIqGWNdhq8WDtUujFf1prY3/AXKhyhcrTKDwOxhd2GlATcdQDMMdQyvWEDDqSIPQXtMrKLDiOf8rqF7BA+vm/jpDpKAUuqMp+S7XNnJ80hwCPeMv6TkT7mHiREcIfukJNdBNdEpJ3tYa+UpANFM1Znzp1KZ1S62Q9v+llEolcLaQDVZo6E4inZBmBg1oL4mbwmfrDTzzr1z3KlhA96UpAAJ1KH9XBqvbN5LgMWUwHZA1+scPieD2LRS9/7+UxYJn9Pqm+Etm5NgduCZykRU83gMYEzL075JQ0wzejxkRCeeH9YGIE3sQlazpR7WKNREe2LTW7qqNAjLwqSgWj/OkU9QfqrNBEeXm0XXwdzridkgkQA8/fmi9TzZJFSfeIE5VdUj/A5os/DczUZn9jMrfFZjVE32Y1fNEM656/VdhmOFx5TTuXBG10GE26gFIRoQrgGgyK5fo8Panbpz99RalCcIFdRUsTfd+BF8CIyTAoC1ymblok1efivAaO8sjChZxtUxw/Bbe+ysgG3URwsI1k/vAle8GN/WrV2p6z/FY7JaGdOeqzhpFNEaAtA+IitpkuaTMUbtepNnNAqy+1PCA5Owu/e1cDIsxpuTkO8tpa6xLQnDnYxlILAt+tpHd+YIPJc315BSQrNloByqknhkakIM33R1h3rTPtdmwVUkNsxU+OSsQk926VNfVim79MqoTAMz0ziteo5I59vgXcdEK9sZrNnov+4T6lUuVoqenIVYwPn18snl34sZZc6o9Lp3FuDORto6PRiidP35GlWmwa
 4fSgVpJg
 5XY/dzvKCRk4XCg9QKvsUuPyz28I/b97T2+H22EFjD3KsnhDqHp7tCNCfMOxV8TkiyBYtYUm3Pg3Ktm5ej7DO5HWghTmE3irLr9OvKrRJG2+F6K5RtX7gmv1b+B0zTxkk6+CE/1vXE19fnNTGudl2ZtFYulEGj1aT4xbwKE5PsTHYyyIX6TMhf+Z5RcZwWHUk2JJvnIvT97bgdUrSowh2juFXXEn4ZVmVZEBxz0fIH7qbNbQRiFOU5rY42dL2befv6DBySU/fGK2VrPYSgjNfPbfbLVoLRTelgEUbsQZR2VgUQuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Move the kvm_arch_has_private_mem() stub and a few guest_memfd function
> definitions/declarations "down" in kvm_host.h to utilize existing #ifdefs,
> and so that related code is clustered together.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

