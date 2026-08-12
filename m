Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD3A8C5B567
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 05:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710F36B0088; Wed, 12 Aug 2026 01:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8F66B008A; Wed, 12 Aug 2026 01:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6262A6B0092; Wed, 12 Aug 2026 01:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 406AB6B0088
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:34:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC454A0319
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:34:09 +0000 (UTC)
X-FDA: 85091501418.08.2B2EBDC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf04.hostedemail.com (Postfix) with ESMTP id 163E640002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:34:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SA0P293G;
	spf=pass (imf04.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786512847;
	b=51nTJCPiIXv1pAxvgg7flzcSvoKKZZJKRegMFCx4Tq2c9rBbzM3BGk9wEw1u/bxnwnu+4z
	DLl6Kf1+8Vs9Nhia5KHQ4YRGSxWdiGM17BWp+d96OzPGE9CW7CDLA8QKAnYb9/doMRuPl5
	5JEw0KAEkeYM2LE9tr3+Qwj50bCSGMM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SA0P293G;
	spf=pass (imf04.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786512847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4nTkWec/H8k1AdZskvzeJU48xWFGG5+HV/WJUcRVYM=;
	b=pSvsEgXqBfHCepDik/a5f3qGioeG6L/qGAESB4yA7WZ6NcCaul4Yf3+v913iNXt0PIHC2J
	Wfr9l5VFZ1RPMbgvNgvxPcs8wi4n33rN7tqqLE9ruNQ7EF7Cmnar8VsOhBt2g8n0/j6Sk8
	LaHZxlOiAeoRU9Pq6Hij2gAc4EM7JRk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786512847; x=1818048847;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+nEGQQL5Gn+WI2vY6/f7bvYSr4WEHuPAEm+UsH53etw=;
  b=SA0P293GJ8+kL8SHHeVg9S+LdtKdr0zzzXiPh6RxXeMW3ki4P80ZHbev
   o4QG2K7AKPBYE8Nqov3xVCvbyHZbhR7VWHo1P3jLqn1ZMar7Q43gleTlG
   MNZw/lUaBvGrfZCpnjBruVX0Bxt7TkjmrKeBuzpTkbT/owP+toFWlvRqI
   4pJ9dktIprX+R6OzE6s9bGoK9HND4K5eiuCwIcL9dhWO/FTmxVKwm7piM
   +Rw1CxRZEQdX/VXEyFteteeqW2+Ak0jMuOkElQzMfQlv8GIP4UuBzDAhD
   sMMvM+0zkOne2dO2y5a5xsqStdg7RR8PWOlWCWAMA5DWaDKlCbjwEK2Ok
   A==;
X-CSE-ConnectionGUID: ZjBKdAjwQLSyY2YPDhi8EA==
X-CSE-MsgGUID: oJwD24PoSXegPEplKhv+aQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="112600702"
X-IronPort-AV: E=Sophos;i="6.25,218,1779174000"; 
   d="scan'208";a="112600702"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2026 22:34:05 -0700
X-CSE-ConnectionGUID: fPXyq4LvQsCVdziJqFJAOQ==
X-CSE-MsgGUID: K7I87BFVSgisT8D/7Pn29Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,218,1779174000"; 
   d="scan'208";a="261787286"
Received: from unknown (HELO [10.238.2.33]) ([10.238.2.33])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2026 22:33:52 -0700
Message-ID: <079c36db-003a-462f-9877-5361f10d9571@linux.intel.com>
Date: Wed, 12 Aug 2026 13:33:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/41] KVM: Provide generic interface for checking
 memory private/shared status
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-6-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-6-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 163E640002
X-Stat-Signature: ew197u74dh44fdn6g6cafq1k7awuai17
X-HE-Tag: 1786512846-571549
X-HE-Meta: U2FsdGVkX1+VVSo3j67WTf0KPBaGhFovKZL5chXAhlt0PjrvO9J1Gs3PC3v2nXzP/F00CuUVxrDlftya38frL7W0PXwldWFfgQYWhTMcs7oxHYiuRbo8eLjHLX6i8XKnjwOoAXfqsHqEMUK5BzPmtBcTcapc2VcVNCWnIyU2TYRdpiFQO29uTtfH9RgKGElD1qdd3i1hwNbKvPmwrXOPD2TMrJfF0nsRTHk9lL6XWG659Hc3fk0NxNCX5+Z6scCDVdhvP9R62wAhKyZ/bzI80M9dRxA+kvntGd14jr9GefXbw94HAdzhOMEnBEO9X8LV+qWoFds4uwrGzTFty5FdayrlAdZ6Z6IQ3cHuCZokYDP/FaQS7QGRCbXfU1NLItpFrQ+VkoTuJgeuM3OfgvThW7/M6FhEbBF1PlU6LV48JRpvDGfnF0DRvWvZembie++s+UATya3WaZmPb4lW1YB2l1y20584emjoZAbdNKaWpTnrQ0DG0nuZR+qq9YvN9ki3MJbOHyIwDMa9AoUGEmTXDjbR5Ez+jx3ZDmKprHP4l+eNgjlOfBuozQde0kXufF+kj4YuxpqfNEY51bSRcrefLxUIzJX/YO3VSnfGJJmiZSlSCl3fgmNuvw8pBDjr/Y4xytr8Q2U4SbrgXcrAUuS2dqDCnlFTUppCWMqMdZ197Q0AC6mI1DEgReT9p0OYw/LDCCMrpVlDaNGQRtTCdOcwvcRnU538VKRGVBhcQWpgZE6VrVCV9PAm0MgyIj6KjUskRapMVYYbh7vyMjzLeD5RouIpXlPbEGtcaVc00nAoUa+BG4ZACQKvy3tXS6GDjt/qeQYpCjv2k8VtZWL14MpmjlHfLX/i3UMh5IT/lTbVUhF+NV8Y+T3DurBIhmukshtlrDqOhSNSI47JnS7xXuooT5+gZbNOIYkzLVzvi+kcRmEfgWvzjdwxmg1B/gIvVdrm0VRf2mFxr9akOxI041O
 /ubMT99o
 4n+PMmrtfdgLUfQDk+Cgv1fXARes5zqnZNWMVfm3UCy8cEpOCs6FrzpFXc4eeQQp1wOlcd9zpFZarkL4EAmUHnoeQpDHPtEU+kr4yEib6/WgWxxXGn3o7IoGW7PwS5W1KRrudfIM+JtipY0fHOIbleGrku7zN4ZfWOk8I9L4rGhwLm5STHceyRis4prWBM8zKhHumhf00v7d4r0NR8liKHwTA3RiH15RYuTD9h6eongWakAvOg3Cx2rhwLzf/3/fb7E56aSpK1womcP6DA9cWvhsmL7t/t2812CIDmiMiyx5Qxcnu567/qcwGUkm9m/L8g2Uk9izMwtm64O8naYdtVgyITw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Introduce a generic kvm_mem_is_private() interface using a static call to
> determine if a GFN is private. This allows the implementation for checking
> a GFN's private/shared status to be set at runtime.
> 
> In preparation for choosing implementations between a guest_memfd lookup
> and the existing VM attribute lookup, rename the existing
> VM-attribute-based check to kvm_vm_mem_is_private to emphasize that it

Nit:
kvm_vm_mem_is_private -> kvm_vm_mem_is_private()

> looks up VM attributes.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

