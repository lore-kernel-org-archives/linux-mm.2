Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 510D7C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D616B008C; Fri, 11 Sep 2026 05:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7126B0092; Fri, 11 Sep 2026 05:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46E786B0093; Fri, 11 Sep 2026 05:20:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB0B6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:20:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 087524016F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:19:59 +0000 (UTC)
X-FDA: 85200934518.11.1B567DD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf18.hostedemail.com (Postfix) with ESMTP id ADCBC1C0006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:19:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Sx6j1Or4;
	spf=pass (imf18.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789118397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZUPN3Pscum7R67EVTIi+WteWopzHoJQ+XH/bbwjmHk=;
	b=z76cF1T5a7dgW108BRfPHf643d+ufkKELolsqxowiDL86cL5a50bxxyLcUJwjHxaY+kyo6
	/sN6Len2uSF0rPxGk0Y2V1eo1+unO60mp2PBIEt5eJSZTac7+Zfofq++IJnzdu2Yz7Wdxc
	lTFTaW2dqDLSgt66K3NFOD8gm4gxW24=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789118397;
	b=R09095I36Q2YiZv6Gwdn8rAMvWgWYHntqUdNQ6xQXMLzXZQ9FR80Bh6xqEwgMIJYrSkn9e
	KD31IUSP68zdHWJFRT/EuScOl+Dy+ezZtX4pjg+Jqjx1Hee5DYWYhRphpfFvt/J1vMZvF2
	7OknNXvqdisZKgJvOYIPq4/QmKp/RqU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Sx6j1Or4;
	spf=pass (imf18.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789118396; x=1820654396;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=x4HjFt9hC9MVbkBet+CRb0bKBH7jlDEbqN+Sd6H1xzQ=;
  b=Sx6j1Or4xZ2sJbAGVx5L5IYdIp8vrigX2QIn0wOIC046M8wPdRQCPKCo
   UBRM5KYSv1Squ817ziFYGsUbVqBzyOvYZtLZ1Ivd/5xAxdK6s6qaZEKf8
   qGV8mJluLeSSKdSv86bVdBsmM2FmZRQkW9+sPRGKkObwF/bTZBwP/m2HB
   xxFH+ng+duB5XhmJnnRfQNZmM2uCk/fJxYECjK6NGOHBWaPDwJ7RdbosE
   JSkHiFh1W6Uax3ar9odZ7z6rfnltUzoVtE3u0rXRSsfrHUClDZHcBJhwj
   9GAZvDNbtNKPZtwP+bFwe0+GZz+BRiMzk5pdsc96n00fO0MReEmzBfrE2
   Q==;
X-CSE-ConnectionGUID: VMBQjLskR92i1nqDzhjIWA==
X-CSE-MsgGUID: Aa9WYJ+9TY2dfnoxscgqDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89451031"
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="scan'208";a="89451031"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 02:19:54 -0700
X-CSE-ConnectionGUID: MskVPNAUQaecybhe4vi6ug==
X-CSE-MsgGUID: MyILX2DsQcKOmEi/YU31iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="scan'208";a="238657"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.119]) ([10.124.240.119])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 02:19:37 -0700
Message-ID: <e84d09bf-2c15-4d2b-967f-e6ae47d0e87c@intel.com>
Date: Fri, 11 Sep 2026 17:19:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 07/44] KVM: Rename kvm_mem_is_private() to
 kvm_is_private_gfn()
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
 <20260910-gmem-inplace-conversion-v13-7-dd6fbf94f4e1@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-7-dd6fbf94f4e1@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h4gmfmiww1cyukg9i5u1tjqrcg8krqqw
X-Rspam-User: 
X-Rspamd-Queue-Id: ADCBC1C0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789118395-978588
X-HE-Meta: U2FsdGVkX18ndHPXCSm+EZ3kui4FqQjzkK1UpqmNBXX+aClXXAfYROVlE/17qHIOMrdLLZMAFb/hk1Kx+lS30UB4Bkm5dlvDvBXm4OV3ZZohqXcJQs28ZLMK/aWl0DvzVoeNZqyg39IiB8TSWOJqix+cBWPABR3LF8jE1rb/QAzxFIFENR5CmWBMy+GqBsBiPTKxUX3jZ9G4sZmonzz7VgX6DfQ/3T0YKtcizP4WWARJ17dd5m8f/XVzukMWwjsJXxOVioKzM2kdksS/vyAi3ihHXL/nKqgW4qpl570GQy9iV5q+kjQGE+zdWXsIhn5V4eDtEiCso/5NJVHDvcTrrnN1UcxOt1BpjOmK0ynfB0te7wqd6leyxfY5jHO4z9S7LE6jilPwlyiGV3uAomS+BdfSTbK6vS7t9E4RViEQ3M86Ed3bXzu30GiJI12ZtFdAjYGXYKmyeqKg2JZf+02BsAekYZ6hc2vE7xHASwHGPvzRMG1mQR/qVM3sR1euQCWCyAkVi5vSLTVZXNs3olbDJ1tM1g/6/rlWygwON7zsXdadlxdAtALekKXe3bh7WnGUqL3ugBbbbj1y1ivZxUZ7NOAS1uFC/+2Mlv01hXg0Eh7STlplR20KiZbCUxwwf8SfMsDWlKcuO/t8wmjq0uQWYQf7D6LuMhVRYDW5bISNN8YX2KzMvOdO4AR1uwEGTuh5Fk6t8N6kHck8Veqo5ApSYh/UB7Lajcsxw3/x7IdNKEGrZRRDgbSmq27lru4TS0X1IzF/EqGDwzY8Xtl46OXY7NdXk06gQcIU9svoZkYERluhLWOIzlGetTlJ840Urf0+c18SRScaJoFtaKEqrdymVI4rZ7CXrb6xVBdcXMO0NHm7iSU3ADmnjl0WAzzVtFgVOWUnuugP+I3VOqzYe0232b1mNej99Mng6bEpehkg1ZbvbDuwFLeMhoHbq2++CcPhBzxOe0Z8xdQRnuH4gAe
 COtdzDeP
 omDw6VFqBpSK4Ps1gB3lpNgQPnZH7wy3G8c+PSQBi/2RSnH6qm9Jpg+/l8ovaNOF8ZCyeEl38QLrAHP8Ax5RgVI8g4NHYKar0FewTLFyiAQR/kanVWBrTaTnm2HB5YYmDOfuIndAn7W5iS4a/uE1vRlDUM6DKO7SBsRsuQzLhUWeN3BFw2jJc3M7GUUxsqbNkgKvGMcPpidVM1e2dIoHz64FrTr5mixYfMxEPfQyj2xPauxMBOM0uzRVp7zfKRVaCxHwhoG3Df4UaBUYGvje5pnAV/jf/YVDP3rD2qnvVPhg6wAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/2026 7:55 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Rename kvm_mem_is_private() to kvm_is_private_gfn() to prepare for in-place
> conversion, where there will be two lookup functions,
> kvm_vm_is_private_gfn() and kvm_gmem_is_private_gfn().
> 
> This renaming allows consistent prefixing of "vm" vs "gmem" for
> kvm_*_is_private_gfn(), as opposed to kvm_gmem_mem_is_private(), which
> looks like a typo.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

