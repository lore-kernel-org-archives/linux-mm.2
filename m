Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D8D606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 05:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=E/AmkrY8
Received: by kanga.kvack.org (Postfix)
	id AF4126B05B1; Thu, 29 Oct 2026 01:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA54C6B05B2; Thu, 29 Oct 2026 01:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB156B05B3; Thu, 29 Oct 2026 01:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF6B6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:35:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D520DA7BD5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:35:37 +0000 (UTC)
X-FDA: 85374551514.03.4C2C31E
Received: from mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
	by imf25.hostedemail.com (Postfix) with ESMTP id B300EA0003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:35:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="E/AmkrY8";
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.220 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793252136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63NDZq8Cyb35cDuhqqHvr+BDCkAeruK0XwrO5RdM9ZY=;
	b=whwP3KLaEMlfhjn9WIhMl5rcYMm7emT6VYZe8CB7PE+/imE3VK0y0wE1B6j/RAUvxMaM6c
	amZK4h+mcLISEkFnzddLVRc0QlKAJUc7jE8JCvOF9zhYMOpjmLXG1hFF+vX2e9SIeei1xX
	vWvuTUsDjrlsFEH/aor2Qzwsz+U+26c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="E/AmkrY8";
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.220 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793252136;
	b=atUTXt1ARgDj7tW0PAeiPqLgRoDPVAhpEAkf+MA6REkTW4jbrMgOzUnoADTfpcEADgi/+z
	6Rmap2phjjxLuNvGZCgpO6Eg4KOydeUCLH2fSgzJVsB6zOkJ78y9yfCm20dWcIP0a6CmtZ
	GqCFoywU9npIkOyRdLodX1rCbIjq1wo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JWxFG3qn2YevCpVcd3JxV3GGyjj+u2htHokQ1v3x0Pw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793252134; v=1; x=1793856934;
 b=E/AmkrY8zj2MdvEWmWN4ZE7Err/HvTah50oUTB3R7Fe4qK9Lh4KjjGNh8wT48vWIcKTHTHJY
 HZfIiBrKYNH0CpfU7ddyXH9knzUPHFLeylxbC3ZOM8A0X3UliJ0pCVcB+e1sugSVLLc2OMOXOcH
 jyxQzR7fV+57Dl0py4Xzdrok=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 24f16e16ac99131d;
	Thu, 29 Oct 2026 05:35:31 +0000
X-Mizu-Trace-ID: 24f16e16ac99131d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261029030511.12004-1-trilith.zheng@gmail.com>
Date: Thu, 29 Oct 2026 13:35:05 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dan Williams <djbw@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Pankaj Gupta <pankaj.gupta@amd.com>,
 linux-mm@kvack.org,
 nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-cxl@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Mike Rapoport <rppt@kernel.org>,
 Ira Weiny <iweiny@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>
Content-Transfer-Encoding: 7bit
Message-Id: <2E5C10CF-F3E0-4694-965C-B0E432A1A962@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-4-songmuchun@bytedance.com>
 <20261027065723.66564-1-trilith.zheng@gmail.com>
 <4c9741cf-ac62-41d4-9c7a-7d5ceea4a8e1@linux.dev>
 <20261029030511.12004-1-trilith.zheng@gmail.com>
To: Yilei Zheng <trilith.zheng@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B300EA0003
X-Stat-Signature: uzqy7phx3zmkkpeoe4tnx9931oy4pm7b
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793252135-736534
X-HE-Meta: U2FsdGVkX1/I6YMBZJ1acBtmD7Ugzt7OWs126yT5ZVjRbgmFJYJcoDSxn6/kICmphjcFz+/jjl0evf1jrV3g2NHtZLk79j0CLW/qIAoKpRm6CXVEo/2Qrn9QWwdCLQEj6Yp21jwDZdaPJd5Po/vx++7Z/0nvQ9jQQI3jbtNHzmChcO/969AJYlc8YEaIdXXBxnu6vnyyNkPdxgwMQo7WjLXVzZ5chjVuY8hBJV/D3HecvPIwJBeheyhrQNKBlYctN2gBBWYja0hidevCaiErx7wQATb92n7uE3OB5WnuYeEApnKttRtMTUElndA2itgdNRKmlsBoGJgXftWZ2puPpOl4Cu/6lv7Mfr1DyEkuyh6I8353hGWpbG8yLOJugp499ZVPl4CqcnsunWXREdsuEGseeN8jl7HkW39LaFlBbTMrWvbZeNr5G98685Ok5sH4cqUdhK7KLHFujX+JEyogz0Xnjcn5dI0lv5FVSgxiO6SYDmE0nfcKNyKMq+zU90xmL1CaRZ9E04yUuVMznQe4tT7f2/AR7fbY/FMOaw/d4YwrBU342PRdHXnWc2yzVTqZ1S7SuTSDD5Z3nuN0X9jsOo0h7aXgj3w8d3t/FT2s1E9VFOZ6cB6HuhLuTaaAzD4pOOJSpWZMbmh5Rlh58OvaFcXvlM4NIKbHnR+pTQ7jUQZ30DU/KB9n94Q6y3OWuUS9AeTEBrW3ABDGlFP2w2gk29ZKR73r/KqyDbiaGZkJ+qCzRTXSFQHZLUlviC7FOOXMCjq9w7ECikuAXRdrK4UjhuH1v0cH32EKF599WxN1wacQCwedvwayyJ5BBzmeF24hfLgxSm27Q/C1a9kG4T7rMHjYf0GGHisg4v/fpmvqUWmVQP3fPfxxnaib18tiYHltzlt3zO2JX5hsVHGicuVuYmJOEVwF7VJmdGvFGugTzckAd4nZaSwKtzDI2zlpcQwDFiqSY3VyGCavsKLDrKz
 gezVmZ9k
 kuRe9GtTgcbDKNZ0lEcqiB0ora4KYonkdeUENbOoMqpMXD/rzo4qj2wWkQQTs6BqSyLSOHeVWC39jKvHYt6KA6XbZUUuzmjNs0b40wteBGXWjJpgjZ9RNXL+80lbsmQhlELZb59zs1daub2jx/AqOzComNInPEcRMAxj1Zfh2pXZRYiZ6f9TtHb5VVm+PKZ1qIVeIQ5PQjPv664MCKW/n8tUmsivJClHfa78OTlXPfH8NAf5T/IHH6ehb3LJgcW3lJx63Ufyy9a5bwFokp51by/eChe50bO0Nr5OLVWIutQopgMkmsrqjDypIbTL+d+/6y/+8zpiv978Bu/Ca4rRKkkgg7BGWLTukRnudQk49Q8DjvUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 29, 2026, at 11:05, Yilei Zheng <trilith.zheng@gmail.com> wrote:
> 
> Hi Muchun,
> 
>> Thank you very much for the test, so in your scenario, this is also
>> the behavior of your real workload (mainly read/write-based, rather
>> than mmap), right?
> 
> Yes. We mount read-only rootfs images over virtio-pmem and FS-DAX. Most
> file access goes through normal read/write. mmap is only used for
> loading binaries and shared libraries at startup, which is a small part
> of the image.

What's the size of the roots image? And I just want to know how much memory
this series could save in your workload.

> 
>> To be fair, it does fix the issue, but it's not very clean. I might
>> do some code cleanup first to solve this more gracefully. I want to
>> move the initialization to where the template page is allocated,
>> similar to what section-based vmemmap optimization does.
> 
> Makes sense. Initializing it at allocation time is cleaner.
> 
>> Thanks for the analysis and suggestions. However, the reason I
>> haven't sent out v2 yet is that I've been trying to refactor the
>> vmemmap optimization logic to make FS_DAX support cleaner. I think
>> I'll probably do some code refactoring first.
> 
> Understood. It would also help if the refactor could support subsection
> (2 MiB) alignment, so any 2 MiB-aligned device can use the optimization
> without padding to a 128 MiB multiple.

I think I can.

> 
>> I'cc you next time if you'd like to help me test.
> 
> Sounds good. Please Cc me when you post v2 and I'll be glad to test.

Thanks.

> 
> Best regards,
> Yilei


