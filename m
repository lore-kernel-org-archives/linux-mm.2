Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10648FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70C1D6B00CE; Thu, 26 Feb 2026 10:53:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3E56B00CF; Thu, 26 Feb 2026 10:53:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F00A6B00D0; Thu, 26 Feb 2026 10:53:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 474C76B00CE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:53:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CFD6E8B221
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:53:51 +0000 (UTC)
X-FDA: 84487053462.05.E6232F6
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id DA4E7140008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:53:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wc4zCWkI;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xU/P/E3V8lwPxXOwsXyNuPVZtz8N/+iRJGqIf9l5sxM=;
	b=ZbVkSd/jiNi8oqthBkUCFfxFx1k1mrYaa2NDLoDKjp/da3q4S8hd/FtcqjftP1aweryvxO
	lJiAththi9LQreWPtFg/CmfbDLHSX/pWFRcpIW+3Ugbq0YFYizPpqWOKFqAZTvG49i/Tja
	pYvPCUNzx8nPBkoCt8ppBupafHDjVZ8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wc4zCWkI;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121230; a=rsa-sha256;
	cv=none;
	b=vITqIXOBtzYya5D4wmYaYpxgtzXgOXN76xe2eZQA/m4MplHXUHm/5JDUPa0Ec5YnpoXozB
	m4FJpxSBEx0KeYd/cFNq1svpXJGKXp4+6I0yh112u0ykGe3S4rZOQ8QEMYDKeWkTBJjF/n
	EmdmHTcFHJLk7Frib7LyVDAQ79jx9Eg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772121226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xU/P/E3V8lwPxXOwsXyNuPVZtz8N/+iRJGqIf9l5sxM=;
	b=Wc4zCWkIgS5XtJECh5aP5VvL9yKzmdpAhKr4PRV3POE5wHpRbD6H94TOtEmbaEVtkxtXws
	oskHPmMw2POJ8xoJSPtCb2TUCMhPX/nKsJ+2R1cMI2eIiuLXW11sH5+DbgyYJtvlcyA+ih
	J5G33RbH6BBx/N4/J71ODoeh7VIN34A=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH mm-unstable v15 12/13] mm/khugepaged: run khugepaged for all orders
Date: Thu, 26 Feb 2026 07:53:31 -0800
Message-ID: <20260226155334.3373953-1-usama.arif@linux.dev>
In-Reply-To: <20260226032650.234386-1-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DA4E7140008
X-Stat-Signature: wyqywejs9cyffc9w93amezzbburk7xjh
X-Rspam-User: 
X-HE-Tag: 1772121229-955440
X-HE-Meta: U2FsdGVkX1+8JFrl4+YQLi2bZXI/Eb7Upr1pKIBCRwRcSoTbpSvJwSY5L7VSZ2f66CHlUg91W9GWyLwAKTo+GDwGoDK0hG5xlrRaf6oFYeR5BU7+9s+YcH16i8AdFFu1T9RprKEvaVMEIOK9c8jxxlz9UY8lIU77+Kk2pNq22LPAuok3C7xsyp1IbKdEZ9rltCMPs1uztePMxoXrXyt7Nku24oXXuK+cM1Crw4HARdqfwS23xisXeI1Z2kJ3TXhCxXH9MzUcKh8hXNnCYKzvPJKsbHdZ72erSAc/v4o9/NeORqyuKXj3C4DwgSmXWHqQNJakqx9tFbus81Ibuj2UOA2AL8N9iQpqTsaNXKbvIUMUCua2vG5nE1Q6dkBm4v6QBiIzKg5YuB+lcvtWrtVSXq3IEX1ypAqPgsDW6Vil3aw9SCdwpLKvG6ZE6uO2pLh55i9PlPZ8dMo/8pawcVDl1gBnSd7PwIaYmnBTi8OgWa/iq1ROYSdQxobwiZf0AZ1eYFlMlYuBYW+XkoN1mcZXJi+XN6GlKQVdrdFavGfRGT1PDzfhJUzYgal+pVKJsHJPmyhz5DDhPFoPEqzbQVJPo7sddjQkqc+WkqWJi8rzj1cYP8dEjIKB4/tntLuKit+2Fg622auRFSg2Jhgmij5RzxlhAS5k385zmKrgH+t/C8ItMJMdL9Y1M012qaQosV/RRgvJOwh94RfMNdwdLhMqOGzj8xTQo4imOYsGlzrT8PjtfNWEanRAhZrc+VC/XH67aTMucf4SvhZYyari3+uNlZGnp08RuYdfMB+5Vo6B/zmCtTYwH5krSZoqYs6w+FwPJXapRnIYlbY+vwsQmYfxpylF4kHCPgopL4CriZlIwijN9uya3pSFrR0u8KXDIQpYEQX5qJ4ZHTxOWDRFbO5XnNThP3tvE3bwPjBb9MOZUnEAnjrhVKZVVfC4H5YWidF6R2Rlx1Owl2vQ84JC5li
 w4odxiLw
 /mczxXGRGAbN+x+I80t6raRbOM65VqvbdBRmPXCk3DMsXy3F41/gMIjQbX+T80jBDvrRApjOjAsi0CjE6vhn1rFYl13qkm/AW0gfvKp57VPaXxoXssoWti7ngziJD4nHUsvO8VY2AHojQHRN8YLg3GyjE3m6y8s22l0BdxMgq6eAwdSBuNW/G6wnbGiojB6DDXmyyPAJDJkfu97OLOUoSOBUG+RTLc1WPW2lkJKyLQXT85U4hKdMmJfRZZ9KvYSkEjDM5nE7wefzP8ElTvm217u8XyJIvNp+sPI3je4lY9J7VdN+LwZwOSJFPXxb9AQxkSKMK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 20:26:50 -0700 Nico Pache <npache@redhat.com> wrote:

> From: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> If any order (m)THP is enabled we should allow running khugepaged to
> attempt scanning and collapsing mTHPs. In order for khugepaged to operate
> when only mTHP sizes are specified in sysfs, we must modify the predicate
> function that determines whether it ought to run to do so.
> 
> This function is currently called hugepage_pmd_enabled(), this patch
> renames it to hugepage_enabled() and updates the logic to check to
> determine whether any valid orders may exist which would justify
> khugepaged running.
> 
> We must also update collapse_allowable_orders() to check all orders if
> the vma is anonymous and the collapse is khugepaged.
> 
> After this patch khugepaged mTHP collapse is fully enabled.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 

Acked-by: Usama Arif <usama.arif@linux.dev>

