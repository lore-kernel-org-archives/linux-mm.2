Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74686C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 16:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9F86B0096; Tue, 25 Aug 2026 12:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59ACC6B00B8; Tue, 25 Aug 2026 12:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417C76B00BB; Tue, 25 Aug 2026 12:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3146B0096
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:14:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 902B51A0459
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:14:08 +0000 (UTC)
X-FDA: 85140288576.01.5A0259C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4463E8000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:14:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W2zGUb9B;
	spf=pass (imf02.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787674446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r0kIhyXEQeDrTtZ0tzLW2TBw92M6L9IUWtnw69wrpBc=;
	b=sydJ8T/32WuI7GPRGuFYsaLjcEuyiBguUj2g1Qk5dE0Omn0TZwmTmkoyTabDhEUItwSxEA
	jf6wvgViPNJ2du6avUJHpS+qUDfRCaw7k9bfjxXoPvGPGouR+la1YSSTp5ZNeT6xhxGBQi
	NnDPLuJ/GCjB1/+eBEgwC8kNq7PtC/c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W2zGUb9B;
	spf=pass (imf02.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787674446;
	b=bl4JrFIz2kwfOCODt8PEsaDnQPAdL8KkrJBeAN/NjkihWg4RWcN6jl2+tR1R6vpHlL5LQV
	S2dZjWy1bzU4QCaYTGB959NxN9/NHJ5Dcenlr/QeN142O+u1F1S/tG3tYLm6qp7GbzJYm8
	uFGnlh2MC9QvAlUu9FFkb9HZSwrH56A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787674445; x=1819210445;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TMHDnAbv6B5815V9xDG8AMy+EDrsmT6X7HPtL1sNbf0=;
  b=W2zGUb9BO0xKo2zLTgJSITd925XJnKluhzmGw7RYNt31tCmoMR8ZrU2F
   Ow+LMbu7FtOk4Qt63iiIRpRnD1lBfFRTpEjNTyYuT9f9H194lxC7MR7P4
   nSw4B0zKg+UzX3+iASBiHzO1jPIAa/ozW9H207nNzvcPSu8nqgsZWG/ZL
   kXxqrtUziyBBUhMHFcp8sQ2LWuC78dDwYO9cTnV6hTDWGw96NzdiLdan2
   HfU+F6+zxutgq2DW67EFNdbAjbZJyZALSa1gPVEznco9iVK8rd9iFwZ3/
   9SsnULWWvEQd8Y+w6VCDwr0CSDSPEsg5jLU8U3R1r30KaCf1VABYCKEEh
   w==;
X-CSE-ConnectionGUID: Zyh0JOAOTs+hazu4ogJkeA==
X-CSE-MsgGUID: lydUQ7lxS3qyKwgwyZ56Uw==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="99671159"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="99671159"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 09:14:03 -0700
X-CSE-ConnectionGUID: 1Z8oyHIvRaCdZRwP1LfjXw==
X-CSE-MsgGUID: /mJMl5yPRFOgp7AaoGyB2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="265538212"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.119]) ([10.124.240.119])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 09:13:50 -0700
Message-ID: <7eba513d-cdae-4832-abac-038dcdd88517@intel.com>
Date: Wed, 26 Aug 2026 00:13:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and
 private when invalidating
To: Sean Christopherson <seanjc@google.com>,
 Ackerley Tng <ackerleytng@google.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
 linux-mm@kvack.org, linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
 <13ca60c6-e154-4397-8092-09f861e90fe0@kernel.org>
 <cbf5f7ca-a960-4fb8-a760-2d2794eb6864@arm.com>
 <CAEvNRgGOyQHnF_b8dk8E0d7_=CcwXtYUdU3ko7Qbep+_O7UC0Q@mail.gmail.com>
 <aoZZMQ3Uc8yQWPNA@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aoZZMQ3Uc8yQWPNA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9j85fy334ff73hxce9gisjqfktis7czt
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4463E8000A
X-Rspam-User: 
X-HE-Tag: 1787674445-190804
X-HE-Meta: U2FsdGVkX1+BkDht28jesjy3w2iYR6auJN+bb49zBRTS5ba/XiDhIxCT/g1nq4HC1MxMTJ6XYiicCFTgkL6geFjsXJ70iUuJ6LEhJsWYWxbhhjykso3u/j68aGAVBsmW0pTP5YJfobgJIPSFQCDUrKWEZTcJiq7zNUWzK/1FjxP2ryOIwS5qLk6lEX4znhH6d5BZrK3XGb5JWxUXRCDpZtss9wfpNabtcjhESLI9V27xDwVNEs0VN/wfg+ACQGHLUx5N8Yr/VSaYK9EIcThslioZyfwhsgKaAztGgLQq2DjgukX6UebljeT9kVprUVlkRPN/gaWXIV3dmLKnfEhI+/CTs8M84btp9hQ9oLOZBVPasDwC1COzlZmnyleaZqqI9b1PryXCLtpWLss0M5dapDq1KM3LThS2SgQv4gUKq1PdIT0BfJKO5M+WDWjuZ8gZ+4f29uaJFNWpDO+zEB/AnWdKkg2Z10BZAUjMJscBJn4jFo63dlw5noqRpXibNaovatW62COQoifK6NsgT8JNH+xYwmkCn3e5clzGBoA/OhZFV0RxpyWDWr+OfQo8t6A4k/enAkotnOluPvKdSQGyeHdCPziQlv44JRUFg+ODBjaRGkZ2C9UGSLbuPErbyECVAJQ+5+f8XR3H7i3o9rm8ptFB+NGCDfzavUVRiFnoZ7T9tPLow2vTQJX06zLqFRe93ltnoYdCvobAe/QH19EvoADS2XMunL1wxKu5GKBNpFnt8uvUEnq50snm4B5FwWcRSXPqCTa0A+DIjCzhfm728H8nRw0CyugxDr/Eu04UZR+3Pwq9r5dbVpsLdFdRL2WlXcFq76ki1jGmveQJTnP3KHVaVeTY+cwQKCQG8T+viSUYCvaH9rtQ2TUAGkPv3Q/3fAZqZl5u04zv/hGa7bGm8anDvQPDTmwlVXj9QUS9W9M6ebINI2mxsfoXAyz5DDCobxBWR1UyhYeSr57wtEQ
 cL6Va2m2
 PgCYX1RSq6CbTBJrzniuUZbdRzUk7qnV3EBAAQXuDjEAbUwuPo45reI7a/PHI/LOcc7k5U+CDWNxqAfpxA1Vre087bC8fWmTL1R28YtmrOxm4MijywjZpYrwHfTGyfZ7gTkY3c6Jssv1SYB/q4ZUB63KZ/VU9lpaKjmTxaEs5X+TIwUbPvOUG+sZvG1hDBDZLxGwSesHoCTBH412R1efO9hX90AtT6xdK4hrj0dFfl4fg6GDHwsUUZ1iN3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/2026 9:32 AM, Sean Christopherson wrote:
> And vice versa, a PUNCH_HOLE on a SHARED gmem (if userspace is
> using an INIT_SHARED gmem for the shared branch of a memslot) could invalidate the
> PRIVATE mappings (of a different gmem instance).

I'm wondering now how this could happen.

the requirement for PUNCH_HOLE on gmem to trigger mapping invalidation 
is the gmem is bound with the memslot. But how can a memslot bound with 
two gmem instances?

