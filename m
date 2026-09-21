Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68E9AC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 19:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FDE16B00C2; Mon, 21 Sep 2026 15:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3966B00C3; Mon, 21 Sep 2026 15:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59CAE6B00C8; Mon, 21 Sep 2026 15:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31FCA6B00C2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:04:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B413540291
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:04:33 +0000 (UTC)
X-FDA: 85238695626.23.CEA801F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0764940007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:04:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QJ3+MjzP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790017472;
	b=IF6682d4Lmo8RqjU2JEYHIbTf/MnKjaV7vGglya99fMY03fJ8YhZVus5qCz58pM8ddNP9z
	hSNZk52sAGycPyldLKCjT37oPpfRd03pEzHB+SIi98RLjP/FMMyInULTVwGNPAxS9HiUAz
	QWrdP2nhPs9T5+wR59sLCOJKQVpR8Vc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QJ3+MjzP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790017472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HONTjVdIawnS9OZFEKfpfN7ZS4t2FLaSysdX/D7tdUE=;
	b=6VWe61dIJQnQu2tNWml2NYnebWqjj+8TjRUE1T/Y7NZVT53Y52i8r1BVrg1hiR3Kb1AiIu
	BxbMZ66ibFB9gnCOSZOSdgI9946KgxE0nut7y45D48A5G7jHdJ4F7I2dG5bR669JZFLMn/
	XJ9z5w1WR2JK5xhGjKKk/x5IYBVU9+4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F4E060008;
	Mon, 21 Sep 2026 19:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7A01F00893;
	Mon, 21 Sep 2026 19:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790017471;
	bh=HONTjVdIawnS9OZFEKfpfN7ZS4t2FLaSysdX/D7tdUE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QJ3+MjzPgDkeKuSrv4SpqyxYPNEmxIKP5wF/AHUxIjmrP3oyrVErYktvhec3YEVHK
	 lijZqldReiaYl3L2hOmRf6iiWW7z7jJRPfhAQ9xlaZ65QohMiicsNgjN4ahmT6bfAA
	 lIxjqSIRTKWjAXyHlIMnuhALF1vr29ifj/07QF7P94nC/RHNMBK8QOVy27ngiz2zVX
	 ZPeGo0ZnB+HxxWATYk7hsdLEmCArw4FsfU/43yCsGc+gRGCdQwZsC6w8P3sZyxzOIc
	 7t6KRLl7kSRyoWJRmHhKPA9EprBmzeG1TbHg/gq9QDC8/bVs7OTYByZA1To4uSIrov
	 McWVvDuZigCyA==
Message-ID: <16c8eceb-69f4-4115-a2d5-70db828d07fd@kernel.org>
Date: Mon, 21 Sep 2026 21:04:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/12] mm/sparse: remove SECTION_MARKED_PRESENT
To: Seongjun Hong <hsj0512@snu.ac.kr>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-9-008fc8d579fe@kernel.org>
 <aqK9S1hBpPnujgz9@gremlin> <eb5b465b-c256-4454-84de-517aefcd6d59@kernel.org>
 <vpz5zqg5nwbpolxbkip45vxxdt3lni7j2haal7q42skc3b57tu@uh4cec4x32dq>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <vpz5zqg5nwbpolxbkip45vxxdt3lni7j2haal7q42skc3b57tu@uh4cec4x32dq>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0764940007
X-Stat-Signature: dw7m7iw3njpig5wu7wq44nrxc94id1xq
X-HE-Tag: 1790017471-924949
X-HE-Meta: U2FsdGVkX1+V/SGL397cnkLypjbGQz427qVxS/QmD7Hc/cdgO08cSFiQtHVKqkPVFuoOcUu4xuhH86svIZl+tvfhLc3pULemvg9qGn11S0t4oWKZe1OIPUSzUzo7mjysQqzowmBC9/J3mj3YSJbiYPNmXyHR4TKXX+fotJngpztPF5Mh5v3u1K0Gtu7HvZI+tMbff//6E8iemC7qAcwmiuUtHK5BirQJaa7k6Ya8CH7SvJd7rxnL1qquwCIBcV0G9tDhwX1ii3/3inS4hSvqJvW7VFncjAweJRiBhP6SyLJeGi1V1K7s71M/aWBuKMb2C/c6F5BqoQiXiSEIN9/NBMNSNOa0uxVKSvZSsH6HpZrY4WTtps8kWSrTyIkgtlwo3hiO2wbtjqXuKLDWuFWlS1Pita3dSSjpsrka9GI73rNh3hfKpglp89Wd1CWvqadWpr3GCQySNum3ie7C8hOYZ5I6hiNANty7Py8WDmzIGbx5079fGcpRzP055kWbHctQQl3pRlNvxRgQ5rLI6+oAWgBpOPvu92sisrTawFkpplByQnI7JekIRtfEfA3C7tC62fuv0CIbKMh2zpsNPyDOjNOrPBX3BRf8sUHIh4lXFAjw4feTcXwldKXmsbP32fVl1pK7DZhQCRMY5xEuVIP7YIIHSY0/H9gmPSBKSJAP1ZkJTHOKnK3QATGONW4JGVzE94TTmpFwtjNAxVTNEe+BoWmxytMTWgZRCALBZC3/kYXsuaoZTL/U5tT/+yp9Dpv824DisE/MUsWGR2f3x4pNYaJFwlhrTved6vwV+Tq9NPsEOlaxHaAHWjKAyFJtTHVihvu747eYy2BMaaFUSfNrwyYUgf8kCFWrykEeZUR1gsRlzu3iTaW4XVWOFCMC+wfGrpYDaTU8b0+EIEQUTcd1oUD+O9hXjqoWCuI5Xr9auVE6Sw0hnRHECiLDh4vtibGrGgS3xL1yuS2cmqVA0wa
 lR4PDpJc
 pxOSzrKZag6eptBaKFl8czWCJxue1qoeidwwGnIDODSVrsE/ydUZLdYJry2HjRWzph1zi1Im3IzDNY3ZrkHroo8SURFtTlf3Y+lYETI1LnROimVKj/PszF/8LGQbTgLtWL7Uo+dOEa9VnztwkqqAkYhRAB0ao6vIQFWk6x6aqewfAU433bLuhq9+RJMQM+oLOGpt4DgEwOCGqxHriV49+lxc5Hhd9oYehum6D1WvKy0Ux2gK3Wqrb3j6blN8M+Tn7xAmtJoKssJQ6bzFCAdkZ3VAaQv9LbE8NLIwtuDJHx5mIei6FSUQ9YtYSVVYTxxBhRc79gIvT9QU+mjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 18:48, Seongjun Hong wrote:
> Hi David,
> 
> I'm sorry for the delayed response.
> 
> On Thu, Sep 10, 2026 at 05:11:36PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> Seems a bit strage given the code is:
>>>
>>>         try:
>>>             self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
>>>             self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
>>>         except:
>>>             self.SECTION_HAS_MEM_MAP = 1 << 0
>>>             self.SECTION_IS_EARLY = 1 << 2
>>>
>>> Whereas other variables must be available with no try, e.g.:
>>>
>>>         self.PAGE_OFFSET = int(gdb.parse_and_eval("page_offset_base"))
>>>         self.VMEMMAP_START = int(gdb.parse_and_eval("vmemmap_base"))
>>>         self.PHYS_BASE = int(gdb.parse_and_eval("(unsigned long) phys_base"))
>>>
>>> etc.
>>>
>>> Is there some weirdness with gdb? Or is it maybe because there are some configs
>>> without these symbols maybe?
>>
>> TBH, I have absolutely no idea and I was asking myself the same thing (but
>> decided that I couldn't care less about a python gdb script).
>>
>> This code was added in February:
>>
>> commit 55f8b4518d14b7436f70defe27faba4eca0cd4e1
>> Author: Seongjun Hong <hsj0512@snu.ac.kr>
>> Date:   Mon Feb 2 12:42:41 2026 +0900
>>
>>     scripts/gdb: implement x86_page_ops in mm.py
>>
>>     Implement all member functions of x86_page_ops strictly following the
>>     logic of aarch64_page_ops.
>>
>>     This includes full support for SPARSEMEM and standard page translation
>>     functions.
>>
>>     This fixes compatibility with 'lx-' commands on x86_64, preventing
>>     AttributeErrors when using lx-pfn_to_page and others.
>>
>> @Seongjun, why are these conditional and the others not? Trying to support older
>> kernels?
> 
> No. TBH I didn't look at the gdb script carefully at that time and just 
> wanted to avoid a symbol lookup failure. 
> 
> It would be better if we remove the try statement.

Will do, thanks! :)

-- 
Cheers,

David

