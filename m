Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4184EE20B8
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 16:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B766B008A; Fri,  6 Feb 2026 11:23:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD106B0092; Fri,  6 Feb 2026 11:23:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25C36B0093; Fri,  6 Feb 2026 11:23:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD4B46B008A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:23:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 63DFE8AAA3
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:23:48 +0000 (UTC)
X-FDA: 84414552936.24.D700F11
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4257518000E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:23:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770395026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dFRLrqv+pNOxJCpBToaAJlT/rK5FN5x0WJrt7asUyyo=;
	b=HV1fuW0G2HXQsEk2JdMMltyflrCK2u+M5sZgiCuVwiKlFZNLuyHVCzLV7rR2hh4Gd0aoNa
	+uJ6s5zz4vKYnpUIg0hzcsMH4XFEo0/f3+F0Q1NpkaL9bT4oEdPzar0wdL2PhSL1unEF3F
	hC0IGnb7LFn5WPDSOKUeArfGZzOatEU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770395026; a=rsa-sha256;
	cv=none;
	b=aUUTm6Ov1oHCsWI5lfa+KHqZvQcOgLL9+WRnrcfLw0tEgoK1wil5wQhGm/KFqOOWEscaUB
	nudyIW60E/axNWpGGd8pJKw+dKLf+mzUFJiUf57n5AxjS9hzYu/trj4ZPFGfc/jG/l6YBT
	+W89aobEdrD9qKG/OsyBRre/LZ4Q3Bo=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f6zs36pkgzJ46bs;
	Sat,  7 Feb 2026 00:22:47 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 7D15F40086;
	Sat,  7 Feb 2026 00:23:40 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 6 Feb
 2026 16:23:39 +0000
Date: Fri, 6 Feb 2026 16:23:38 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Gregory Price <gourry@gourry.net>, Cui Chao <cuichao1753@phytium.com.cn>,
	<dan.j.williams@intel.com>, Mike Rapoport <rppt@kernel.org>, Wang Yinfeng
	<wangyinfeng@phytium.com.cn>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<qemu-devel@nongnu.org>, "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID
 of CFMW
Message-ID: <20260206162338.000035c8@huawei.com>
In-Reply-To: <20260206075709.0f4b60dd5dd664894cbd15c7@linux-foundation.org>
References: <20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
	<9132054c-3017-4af0-84e0-e4359b0794a6@phytium.com.cn>
	<20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
	<696944eca1837_34d2a10056@dwillia2-mobl4.notmuch>
	<2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
	<aXOl9CN_66HywIjZ@gourry-fedora-PF4VCD3F>
	<a90bc6f2-105c-4ffc-99d9-4fa5eaa79c45@phytium.com.cn>
	<20260205145842.efb90572a902ae4c481e6ef6@linux-foundation.org>
	<aYUjf0OrD8f_bJCy@gourry-fedora-PF4VCD3F>
	<20260206110305.00001fbb@huawei.com>
	<aYXtHa4Y2y_5xgcS@gourry-fedora-PF4VCD3F>
	<20260206150941.000028ae@huawei.com>
	<20260206075709.0f4b60dd5dd664894cbd15c7@linux-foundation.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4257518000E
X-Stat-Signature: 8bob9p7xo7871y59c8iuypk6dfa3d51u
X-Rspam-User: 
X-HE-Tag: 1770395026-480444
X-HE-Meta: U2FsdGVkX18x3+ABq7nA2IG0eGdyWuuNQo44UTw+3QiFeyZOifVnUUPoSLJ3jUw3A3iKZca9HzsdzwW/Pnt9yFhUrPzlIMIWpa/h6T4thpypg8eM1ro7NJeRVf+VqXFqUzQaoGGEN6e0vWOhpFy/OBNg8+Wl6DTisGtG65jV1/Nair5zjAPnhvvcQZuefUFLG/7u8ZPO8IwaWwjJ6qndL3kQR3BfNZk6361zGura12c59n2JYneLFRTaNpyohsZdEqyYdovggDDQiRVN31xYQC/mIwh97DMfJsT+51YBrQWYIOCO8uQHgxB7b2oLT6WAQT+FGEaCyePbkkwkwP6juSs3AAqExvAHbNESQupBj/ylcszTySDO/sCn88ruYMOLBJBK476+95a5+H60qJ5Jeaiw8QOIxHshaRGkMKrPqioJetKkm7aLKmUZZkln7DQ1V611as5WaGUlc21AL4JiramjfkGlRS3ofym3LAnNgbe6IwKcU6+FpREHibDR89AyiQYgxZfMvk64zuSpdW2IbGYSeS3IeqiPMiecmyFHH1R7qWMHbJgnnZqVB7b1+u7mvAuLxxfGYJ+AmN6RyannSThzuzDvrBbUw2sncuPstEOZfXSzKCM8EUfYzN5wj9Tg+2MQxpXHGGbTnzFtS7gz5I03sQCkWwT3WGBhFsatyt4fpwrsCKDFazzAaZLNmYmRqJ76EpqaBgPkrnFJqnlbjg/rrBSL3eiboMGh09XmEeqq2dsXOSynW4EWZg2K+DYuN2SIiXXCuxYOJNlUO/t5AvkPB1G5Vu/Azk3tOzY7RjUFBzsYVsjD9MpFZPfUBcvFJsMfbjsAwWu1X93MzGSA3hR3OBWhtagJoOkti6A3D74La5iBqlT/9KG2berYDgr2uC9y68cVK8+fJ7vggAD4q9JkYWDjkbo8mFBZI38jEGZgWeJJzKgkuJ/ml+yfQnI3EKkx0/Tl36iob6GqE+R
 VpRYAzkJ
 oPYNfsIYA1KLSylmo1vExmffGN05J470XxJp2v9MmeAYpjjKSSUJZpX7UeDBDbDguHn2vk8btlGBOlpBIBD6Ov5LPIEMoMukZFq/Z0HHfJXQWz1rNuX+cfjAz7JMJdCUYVe+C0k823AFRIRKE5yoWzmqlOWqN/bBhZA1pLRnTcoucbievG3vGK+2h2c7Elqz0gdE3q7jWjFX6RLzOGlfzg3oeU6AQgTFHb0tIpdvD1+IHJRTh2V87h/MkDA/PfMCL1m+Av3j6FiNZR01t/YWHASoEu5fTxqZR3Fpqbtf0wYhuKVBE1OPTIDM/QTedfRVuz3gGY2hELtMG7xQoUrM36fzDVAeaUZjgRRN2fABNXC3BfaU6uFXM74wrYgUR8kVtVSQmqeW93jaUVoIslZQvwT+Eijm5rQ+I9nikXLfZconpQpiG7IEtMWENPMf2EuzPdIFoaU373PERzhiE5HyaHPe+nJm9TGYTyCWED72prbsTgsfpk9M6iQAMdXZeJUdty93V8StFON4WR2Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 6 Feb 2026 07:57:09 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 6 Feb 2026 15:09:41 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
> 
> > > Andrew if Jonathan is good with it then with changelog updates this can
> > > go in, otherwise I don't think this warrants a backport or anything.  
> > 
> > Wait and see if anyone hits it on a real machine (or even non creative QEMU
> > setup!)  So for now no need to backport.  
> 
> Thanks, all.
> 
> Below is the current state of this patch.  Is the changelog suitable?
Hi Andrew

Not quite..

> 
> 
> From: Cui Chao <cuichao1753@phytium.com.cn>
> Subject: mm: numa_memblks: identify the accurate NUMA ID of CFMW
> Date: Tue, 6 Jan 2026 11:10:42 +0800
> 
> In some physical memory layout designs, the address space of CFMW (CXL
> Fixed Memory Window) resides between multiple segments of system memory
> belonging to the same NUMA node.  In numa_cleanup_meminfo, these multiple
> segments of system memory are merged into a larger numa_memblk.  When
> identifying which NUMA node the CFMW belongs to, it may be incorrectly
> assigned to the NUMA node of the merged system memory.
> 
> When a CXL RAM region is created in userspace, the memory capacity of
> the newly created region is not added to the CFMW-dedicated NUMA node. 
> Instead, it is accumulated into an existing NUMA node (e.g., NUMA0
> containing RAM).  This makes it impossible to clearly distinguish
> between the two types of memory, which may affect memory-tiering
> applications.
> 
> Example memory layout:
> 
> Physical address space:
>     0x00000000 - 0x1FFFFFFF  System RAM (node0)
>     0x20000000 - 0x2FFFFFFF  CXL CFMW (node2)
>     0x40000000 - 0x5FFFFFFF  System RAM (node0)
>     0x60000000 - 0x7FFFFFFF  System RAM (node1)
> 
> After numa_cleanup_meminfo, the two node0 segments are merged into one:
>     0x00000000 - 0x5FFFFFFF  System RAM (node0) // CFMW is inside the range
>     0x60000000 - 0x7FFFFFFF  System RAM (node1)
> 
> So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to node0.
> 
> To address this scenario, accurately identifying the correct NUMA node
> can be achieved by checking whether the region belongs to both
> numa_meminfo and numa_reserved_meminfo.
> 
> 
> 1. Issue Impact and Backport Recommendation:
> 
> This patch fixes an issue on hardware platforms (not QEMU emulation)

I think this bit turned out to not be a bit misleading.  Cui Chao
clarified in: 
https://lore.kernel.org/all/a90bc6f2-105c-4ffc-99d9-4fa5eaa79c45@phytium.com.cn/


"This issue was discovered on the QEMU platform. I need to apologize for 
my earlier imprecise statement (claiming it was hardware instead of 
QEMU). My core point at the time was to emphasize that this is a problem 
in the general code path when facing this scenario, not a QEMU-specific 
emulation issue, and therefore it could theoretically affect real 
hardware as well. I apologize for any confusion this may have caused."

So, whilst this could happen on a real hardware platform, for now we aren't
aware of a suitable configuration actually happening. I'm not sure we can
even create it in in QEMU without some tweaks.

Other than relaxing this to perhaps say that a hardware platform 'might'
have a configuration like the description here looks good to me.

Thanks!

Jonathan


> where, during the dynamic creation of a CXL RAM region, the memory
> capacity is not assigned to the correct CFMW-dedicated NUMA node.  This
> issue leads to:
> 
>     Failure of the memory tiering mechanism: The system is designed to
>     treat System RAM as fast memory and CXL memory as slow memory. For
>     performance optimization, hot pages may be migrated to fast memory
>     while cold pages are migrated to slow memory. The system uses NUMA
>     IDs as an index to identify different tiers of memory. If the NUMA
>     ID for CXL memory is calculated incorrectly and its capacity is
>     aggregated into the NUMA node containing System RAM (i.e., the node
>     for fast memory), the CXL memory cannot be correctly identified. It
>     may be misjudged as fast memory, thereby affecting performance
>     optimization strategies.
> 
>     Inability to distinguish between System RAM and CXL memory even for
>     simple manual binding: Tools like |numactl|and other NUMA policy
>     utilities cannot differentiate between System RAM and CXL memory,
>     making it impossible to perform reasonable memory binding.
> 
>     Inaccurate system reporting: Tools like |numactl -H|would display
>     memory capacities that do not match the actual physical hardware
>     layout, impacting operations and monitoring.
> 
> This issue affects all users utilizing the CXL RAM functionality who
> rely on memory tiering or NUMA-aware scheduling.  Such configurations
> are becoming increasingly common in data centers, cloud computing, and
> high-performance computing scenarios.
> 
> Therefore, I recommend backporting this patch to all stable kernel 
> series that support dynamic CXL region creation.
> 
> 2. Why a Kernel Update is Recommended Over a Firmware Update:
> 
> In the scenario of dynamic CXL region creation, the association between
> the memory's HPA range and its corresponding NUMA node is established
> when the kernel driver performs the commit operation.  This is a
> runtime, OS-managed operation where the platform firmware cannot
> intervene to provide a fix.
> 
> Considering factors like hardware platform architecture, memory
> resources, and others, such a physical address layout can indeed occur.
> This patch does not introduce risk; it simply correctly handles the
> NUMA node assignment for CXL RAM regions within such a physical address
> layout.
> 
> Thus, I believe a kernel fix is necessary.
> 
> Link: https://lkml.kernel.org/r/20260106031042.1606729-2-cuichao1753@phytium.com.cn
> Fixes: 779dd20cfb56 ("cxl/region: Add region creation support")
> Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Wang Yinfeng <wangyinfeng@phytium.com.cn>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
> Cc: Wang Yinfeng <wangyinfeng@phytium.com.cn>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/numa_memblks.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- a/mm/numa_memblks.c~mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw
> +++ a/mm/numa_memblks.c
> @@ -570,15 +570,16 @@ static int meminfo_to_nid(struct numa_me
>  int phys_to_target_node(u64 start)
>  {
>  	int nid = meminfo_to_nid(&numa_meminfo, start);
> +	int reserved_nid = meminfo_to_nid(&numa_reserved_meminfo, start);
>  
>  	/*
>  	 * Prefer online nodes, but if reserved memory might be
>  	 * hot-added continue the search with reserved ranges.
>  	 */
> -	if (nid != NUMA_NO_NODE)
> +	if (nid != NUMA_NO_NODE && reserved_nid == NUMA_NO_NODE)
>  		return nid;
>  
> -	return meminfo_to_nid(&numa_reserved_meminfo, start);
> +	return reserved_nid;
>  }
>  EXPORT_SYMBOL_GPL(phys_to_target_node);
>  
> _
> 
> 


