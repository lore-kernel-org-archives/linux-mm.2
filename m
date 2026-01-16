Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F064D4A615
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 09:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA1076B008A; Fri, 16 Jan 2026 04:16:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4BED6B008C; Fri, 16 Jan 2026 04:16:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94DF56B0092; Fri, 16 Jan 2026 04:16:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7EAAD6B008A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:16:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 319391405B3
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:16:33 +0000 (UTC)
X-FDA: 84337271466.09.3126369
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 74D33140008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:16:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y3YrR11v;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768554991; a=rsa-sha256;
	cv=none;
	b=VNTB+XNtHQdJNGhVqFlRXbHLLWNr5T2vBDRwvO+RHtUiqI9OHWm1HeJSiE9xHCvFJxPOF8
	/vaGgPA3PzVBghg96/HV6MN3N2svQd9buId75ZYpY0HdMerEzBHf5x/T91pgf1T9uZGdqj
	xTpuR6fDzLVI+yQCerFr61t1/a3ehy8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y3YrR11v;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768554991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KRwIZX0eq636l25pXbeUZgFScnTLhuS/E1INCedyBdQ=;
	b=Ir/vXC7IP46Tm+LVV2D29PuR2urB9GAXLhZcJA3H2Ne1lHjdpLVe1N0uQUQ5/vAkOfKYJp
	3PFOa3iIRzgBHaG5WG85KNjRXDEoVzj/dyGRV3qJsNPrThHAKygOmjUCQCHs64gNastWMy
	LNVtljnqTosoqh01CTZyyYU1vzTJAgk=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768554988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KRwIZX0eq636l25pXbeUZgFScnTLhuS/E1INCedyBdQ=;
	b=Y3YrR11vlRLyyN8aX4FMxfR6XpZJN0u+0pACJMy8KXfCAbF+fMnATJBFlWsW5/yYC66+le
	sK5Y10w067jdW3fmjGACqdp110vNAsgFE7KZ4sDW5pim22kEuZLZjBB8ljPM4A8YhSPXAh
	5oLQoorRJ4IA4N4z3kIeF5s620d0IRk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v3 17/30] mm: thp: prevent memory cgroup release in
 folio_split_queue_lock{_irqsave}()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <061b1110696ba51e454ad0f7549603ec92cdb5ea.1768389889.git.zhengqi.arch@bytedance.com>
Date: Fri, 16 Jan 2026 17:15:36 +0800
Cc: hannes@cmpxchg.org,
 hughd@google.com,
 mhocko@suse.com,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 david@kernel.org,
 lorenzo.stoakes@oracle.com,
 ziy@nvidia.com,
 harry.yoo@oracle.com,
 yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com,
 axelrasmussen@google.com,
 yuanchu@google.com,
 weixugc@google.com,
 chenridong@huaweicloud.com,
 mkoutny@suse.com,
 akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com,
 lance.yang@linux.dev,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: 7bit
Message-Id: <394C2721-72AF-44AE-9953-C7C6DCFC8038@linux.dev>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <061b1110696ba51e454ad0f7549603ec92cdb5ea.1768389889.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 74D33140008
X-Stat-Signature: pbno1ib9r3w1693e5hfccd4f5m6hgd5k
X-Rspam-User: 
X-HE-Tag: 1768554991-253464
X-HE-Meta: U2FsdGVkX1/z3E2hWpo1B+UUkHquK3iiN68lWKln4RgZNGue7LXTzeWQTESozOwfKV8ye7YZ3lQolGtfPZ6CHKYM+87G7ueDr+s26lmVyNxQK4i2JSr8BJJMNdmFovUV4RL0wOTnxJaUh8R3IC1kD7XGJIp82eqWTSIJXPfGXV8wY99Pg0lPscfW9BMFXO+7eC9FOrKYIljXynKyGn/ubY6JzfJJ2itWOCwVTIEYooC0a3lL13PgrbWKL1hKWwIuwT4InwYGvZaEkkGCTCpDqVLOEFN0NxKBWr+qq/INdpsO4f0NjQgHGeANuj7MM4tlc5gW0K7/BXTEhQvM4lTY88pSN7tqmvfyY6/Q0JHETFKijKW7pfN3HZ07PLer1D6fJLgp3aYyUnsaFSImgNJnN2efzRGpEwWiMtgMV0wqeW1v3Q2jm00aEsW2+kq0l7BN7vxzMNhlZGtQfQyopgUOm6YQ1Yr2EWNuYDrK6bZIxKWkHh5npOw11qFuXBONvmn7WJxQvlfvBTPKqRisc5+jAZBljixDu8DkJYKeb0xv1B+KteY2Oa/xnVV/oGVgiK0of5pqcBWkllpgHItC3UGBbavZhjDMokx7al+AGnKvQDHHj/Eyjwdr770lWUx8A/zL0/ZDMmreHk1h8et1nHzhZi32ZAdoiPtSErPMv/svl7g9sfnh4u2mWb7DsYlEK3qFc5VlL6RWIjaupfpRbADlljhW/tWu1/l2S+86ie6BwkDkj0vchydWDOQ6CFZx8aG+L3P7FvkLQD2x0O6trB5H5SUXOLNFq+NM6uXO7HO+WKvywXT637RWWYJRuNPE77dc4ruwjmIrXXBP2t33+sOmta8dcsU4rx/N7ZGO+9pras5kry2a5vlg/CyPnj4uuzCiAHt5MLNUEAmMJlBlxVehbpw2Q1TnX60qKY+vRgxGIP08v45btzRgJifDNZvg/j4HPb5syo+6bdQwT1a7fOZ
 QbVFIq4f
 oTMnmLIBS/sn6sBzFJ1f6fN0XQhSkARHYQFAM34fFwebvQKizxIe16Yd7R5IzYB63UMWKAOwVAU6yB6PuqHJNKXeVZEdKUdfSkXyjyJ102eRAgLy2mvTDpuBoo0q04vSrs82E5SKqcGZHWcjolQBWMDdmtWWPyET3SJCKd98R5wSJpC0FloJULuPGP8zLEIhHHd/SEuxC0Rtes6m5Y5v7XnQ25qi+lJZ73suP9w3BLO4bH+EXkxoetWdzZWHLFTJFfuoIYAdsa1Xnddw/Ync9CCQrmpVst6BnFlMEfdzNavEAciXEbTPE8J6PERYXT4JyH2XlbLEla0YZLNZbgNhnM1g2C/KmDlum1UGnNE6b2HywsjNikRS1PXLtE8885qn5RKGxuLYemSK/DomcrksSNxZS14dkUG+Wt7cJIbkeWqfEs40sLfObwX7LqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 14, 2026, at 19:32, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding memory
> cgroup. To ensure safety, it will only be appropriate to hold the rcu read
> lock or acquire a reference to the memory cgroup returned by
> folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard against
> the release of the memory cgroup in folio_split_queue_lock{_irqsave}().
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>



