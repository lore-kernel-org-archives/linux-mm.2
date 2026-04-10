Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0902EF364AE
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722806B0089; Fri, 10 Apr 2026 06:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA366B008C; Fri, 10 Apr 2026 06:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636DE6B0093; Fri, 10 Apr 2026 06:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50DC76B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:43:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA13B13B04C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:43:12 +0000 (UTC)
X-FDA: 84642309024.26.DDADCAD
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf08.hostedemail.com (Postfix) with ESMTP id EB36E160003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:43:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=TLF2iwZ9;
	spf=pass (imf08.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=TLF2iwZ9;
	spf=pass (imf08.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775817791; a=rsa-sha256;
	cv=none;
	b=xBBo7CMyxmFVAmVDKS4r+XziURlozitgIbB+QFKCIzQe0cmXK4xHHFVYmOQY4OpKAm2xX3
	iWYX7z5jXTsoDQ5VvsvLHgjowD/ONxdA+K26MF5Bpqk9FbYpJmTWt8rLXGmRTGoOuW3Tb4
	aHJrqBTnlhkeekg29FqKgzgItGDuqi4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775817791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSG2xsdDRphI9FEycXoH8kdn7Dk+kPIVj1MEg4OQrU8=;
	b=lfPqJlvQZsppRws1jJB3HPvMY4+GOtj3FwtirkOqMkMJhOj4JuZCWBchYizR1RW7vWsPIv
	W1Bt+FW/usoyRKFC2SacxO3TVQ1JKr4zWL1/Y0W1ud2WJy0cUkrMG+7Otej3SgNeT4ZRN9
	z83CMsurUbO+1ohrNgRBIzuiHS5YHJg=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 296BEBE886;
	Fri, 10 Apr 2026 10:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775817789;
	bh=CSG2xsdDRphI9FEycXoH8kdn7Dk+kPIVj1MEg4OQrU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TLF2iwZ9keVMUtLfNwChan/MK4VXF2b0Q70mM4jIFeW/sl/58NbHVD5+E4dVQDKiV
	 aT7DykZBxO/UPFFoLChIZcqb2ghX9uVWRam0kXqx4OFLrQjHVOOxlLlZRUh50nZVC6
	 ChtPBvGi/9VAAf2MjVDhYcTC3JIGCMoCiLC53Gg4=
Date: Fri, 10 Apr 2026 10:43:05 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Christoph Lameter <cl@linux.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org,
	shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/vmstat: fix vmstat_shepherd double-scheduling
 vmstat_update
Message-ID: <adjUObY8rFqm9bgg@shell.ilvokhin.com>
References: <20260409-vmstat-v2-1-e9d9a6db08ad@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260409-vmstat-v2-1-e9d9a6db08ad@debian.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EB36E160003
X-Stat-Signature: auh71pg79bej41ufj57x4usymczps5tt
X-Rspam-User: 
X-HE-Tag: 1775817790-146634
X-HE-Meta: U2FsdGVkX19Qmdm4fWtIBBa6LyLjACjWTL46bUtCxzoYWLtIKGE4vGNvxw8VZBVzpkjzl3xQxI9PeO3nPhzWlnA7t/s5WIb0Gzhh4jTLBeypupae4AKGgIe6P43gJa2zhJjvIzizSYqF9kE6KIinkSSpCrgMBGYOmrBJA8lGFd3lPV8ZrQ+IgCit+jLLonB/eST6AXKlwp51WDWnoDPf4uPOYA9IYe74d7eskCM0Z62w1HgOuluL5K0rMQ0WC2PbEiZsXyHNFSDl9yIBVIHjxA0HZsIUKfBU5x/7fAfzMhawPrLKKVk6SGfw3Ot1zq6RkpkiWhho6Qjt4yZv5xf4MFTto+fOsLaVE4cTgIx0EwB0J7Dl+0TjzMSCP48kHMsNy9HMqEzYu+X0thFWkQbuBMDLbDKYJODVyS8LHuNH+hGFdL8MXK3EwLvsvVdNLCfsH4S59GBXvYUzqgBMQt3E8Ge/U++fNXRSQm6cfM3r41TMCatLjp2zK2EdPX5LM8fVROSR6imHh1XyDFtGGhO/qhVV4D0M+iEJd+f9/xAjp3zVVmELnrS0EbddcJcNxd8YlP9FQ0dDi5u1+e4JmfkbUqtkCMocBP44qbTYQQ5uawowJ7boYZEqk3FKR5YYjkPo6N37dVxuc9ho/2QT7wz68usyjP82wfJ1m0u9YRSKnbp4J+ZwbI7QbdxsKzPM1v2tE4YnA2OMU9GvgCD8RFWeyJL58AflJGKQukvJx8F8GkJXncS73fdG1EAOkY+Lcqj/Ta3eW8sq4aEdyPsp0OP46FKCAYV+dsSmhdE4L4HafILk3WDxMeNdUg9WLVuOgvqTvQM4IEG3eo2XDD2eApPFqDwMdoV7UNlXzhdhFR84XP7ywALHVk/52C8vSQqjtC4KfNY1HaE5Ol6Tyz5i7aWHOKKxQCR62itoWf9BTNd26sI5sAx0sb2fpBN/rX4iw50QXnIFVMiUcyZiSkwg6ju
 COtPTy4J
 H9HcXsGkuNcX+LURvdNBiVNJXhVXgZHccyt3+YTnzXuwljgb0QuXomvcPczzmBmePtlmV1AE022+NEo+2uNtwBoK+2ArC7/T/tiklMJEJ9JtYj3hAxl5coBReTl/jhq6bnjseg7dgqwhG0X7b3nApAyYq1UGEAR9rNDKVvI5QYAPLPY6coW4NXFOBnRpvYTKvJHgT37iUBOYBbD8ytU+H3zcPKCl9DiVLyOGTYpCB/n77uLNbH+NX5uipx1sUa8qGKDfPv4WRNCggxwpcZ/Ie3QYf3zxej7Mn3A+y+CvcKmd+O3Kh7SZkij8wp7YykxeZDP8LjDeKTGXx6snOBtS8+J1ohhOhHp8KU/E9Z9HvZ5Cdl6TlsDljLQi07onoY27zjJQM7WVpg1AeBT88kNxMt2UPcseYgmGgJW6C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 05:26:36AM -0700, Breno Leitao wrote:
> vmstat_shepherd uses delayed_work_pending() to check whether
> vmstat_update is already scheduled for a given CPU before queuing it.
> However, delayed_work_pending() only tests WORK_STRUCT_PENDING_BIT,
> which is cleared the moment a worker thread picks up the work to
> execute it.
> 
> This means that while vmstat_update is actively running on a CPU,
> delayed_work_pending() returns false. If need_update() also returns
> true at that point (per-cpu counters not yet zeroed mid-flush), the
> shepherd queues a second invocation with delay=0, causing vmstat_update
> to run again immediately after finishing.
> 
> On a 72-CPU system this race is readily observable: before the fix,
> many CPUs show invocation gaps well below 500 jiffies (the minimum
> round_jiffies_relative() can produce), with the most extreme cases
> reaching 0 jiffies—vmstat_update called twice within the same jiffy.
> 
> Fix this by replacing delayed_work_pending() with work_busy(), which
> returns non-zero for both WORK_BUSY_PENDING (timer armed or work
> queued) and WORK_BUSY_RUNNING (work currently executing). The shepherd
> now correctly skips a CPU in all busy states.
> 
> After the fix, all sub-jiffy and most sub-100-jiffie gaps disappear.
> The remaining early invocations have gaps in the 700–999 jiffie range,
> attributable to round_jiffies_relative() aligning to a nearer
> jiffie-second boundary rather than to this race.
> 
> Each spurious vmstat_update invocation has a measurable side effect:
> refresh_cpu_vm_stats() calls decay_pcp_high() for every zone, which
> drains idle per-CPU pages back to the buddy allocator via
> free_pcppages_bulk(), taking the zone spinlock each time. Eliminating
> the double-scheduling therefore reduces zone lock contention directly.
> On a 72-CPU stress-ng workload measured with perf lock contention:
> 
>   free_pcppages_bulk contention count:  ~55% reduction
>   free_pcppages_bulk total wait time:   ~57% reduction
>   free_pcppages_bulk max wait time:     ~47% reduction
> 
> Note: work_busy() is inherently racy—between the check and the
> subsequent queue_delayed_work_on() call, vmstat_update can finish
> execution, leaving the work neither pending nor running. In that
> narrow window the shepherd can still queue a second invocation.
> After the fix, this residual race is rare and produces only occasional
> small gaps, a significant improvement over the systematic
> double-scheduling seen with delayed_work_pending().
> 
> Fixes: 7b8da4c7f07774 ("vmstat: get rid of the ugly cpu_stat_off variable")
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Dmitry Ilvokhin <d@ilvokhin.com>


