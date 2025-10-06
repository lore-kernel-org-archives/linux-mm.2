Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 681A4CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 04:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9C28E0006; Mon,  6 Oct 2025 00:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1998E0002; Mon,  6 Oct 2025 00:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FF028E0006; Mon,  6 Oct 2025 00:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7EA4F8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 00:48:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20BA51DFD64
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 04:48:18 +0000 (UTC)
X-FDA: 83966457876.13.9785BE9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2D58E40003
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 04:48:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759726096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WR5z416GdyHVMtZv8PL/xhfJeDMKBMQyDzp3mXaNyaQ=;
	b=z0VZdCNJNXxsJ5Cfqd+INTdLkNK7PMttyvu0BGIg4ZYLsy31VhF/8QjERSLJhIfmwhVyhm
	B7t3zGeeJnR1oP7V1rWeQ2N6boiqtytpAh22jvtyQMUs3HBfhaayiuUEBn4tF8cK3RnS/n
	ZrMQ7jqXV20SjxOfDnLUIbUIeIDdXkc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759726096; a=rsa-sha256;
	cv=none;
	b=kS96D8PXLaa1Uq7l8ucUQjneLYYkWxjCqtUqxenJgDZPezZCWZkw8m9Z3cRIBVJruxU6JB
	YFRKx+1elF7EsjGbCP8bXcYYM8DWpc0f9bRCvLjauwWSk5ojKbJJiG7csQ8YJXyq8k9EtM
	ab7Lwekj4GgeLmAysNsCeZ9+t6Lxmps=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30E551516;
	Sun,  5 Oct 2025 21:48:07 -0700 (PDT)
Received: from [10.163.66.9] (unknown [10.163.66.9])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B81953F59E;
	Sun,  5 Oct 2025 21:48:12 -0700 (PDT)
Message-ID: <3c0169a4-78b3-4deb-b991-14733b5f0aff@arm.com>
Date: Mon, 6 Oct 2025 10:18:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: readahead: make thp readahead conditional to
 mmap_miss logic
To: Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org
References: <20251006015409.342697-1-roman.gushchin@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251006015409.342697-1-roman.gushchin@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c8eicxx7k8g6kcq371cd6adaoko1xkok
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D58E40003
X-Rspamd-Server: rspam04
X-HE-Tag: 1759726095-329206
X-HE-Meta: U2FsdGVkX1/CCFGxDUibjD1XdQ5HozwdOpK7LPWNrVRbHPqcXJaqwQUXSLL5IfpZ820RajxIwP5BOGEV1Ch2gCTDz98G1CQ7ZeJQN/aeMkOKpBUGyFrzU5VxHCwveoiprCkA56rOJBjl1YgaLbC2BmSIG8AuZzZbc9L9syajeT/033NZeBB5bQGYcOZRIlaGQo6taN3LLXi7cq10QhCK88yuUMrGiN0xWxkhGoWCDIBSrbgFhS0+51dyIqUiHVz+Xl8Csyf7Hes5Qd58U9Ui1B991gYm8k1uM4Oa4laGBvrn4sUcuc8svLHxQ1VngeBMWKkB70VypHwDkzwpuS1TtatR2kjfoaNhiiGhxudC4AuiN5eKnV9vBJ6kxmcc2UfllnhFBXKVmyNBSs3QN5jHzfSy7IDSXvvvfTwoT6w2B5i89G0QzekvLdkyKNncq7hsaYLYbfM9UO6QTPsYr02jtjSyHia+xHDJHwHeUhTIUBtaDahHFvNX9ZtekCf3D8A9L5txvol6l47HJyZjDizaAEKETInTL6c06i+fH9R/Ad3ZQtc16vsQvFFB3YXz3+p7e0IbNCfvh+oUshj37TNu6zmZPE2zam9QN4Rs8sXKYvOqMrQMGe1+ruNpezkxi0Bk9aNzt4B0QiWBsegxYorTOzEMwgCp+N99tByxLW1FVNk7Rj2O6slakbKsmKZSN7B+uoeDmISJBFvCgCyJIhnWldI5v7gul/bxXJedgmI7cwxi7MCwNdoxqJgrRkfGA9RMPQHJ2z3/tX9GvAIR//6Fn4oa0BAfMb3lsHgWK/RrMRzihmBiUW5E3t+s4tpIcuQffn6bhhc1Sqf+6JlcFY/nLymS1VJ++OTTthnvrAkxQnS5lVn4CEy/0a0vvLwdpd+aJH63URAZ1UP4lT69g6Og10Q1+/uiLiPVLxNgeBjybT3XZ/zuKDUVtzK1qvXuSVg0sMnCqbxoJiZKvbYjiFz
 z8GozlMH
 HxE/0lb/SY7isLL/h5Mui221k4R598iumJzQSaO2oeDn+bINA3HaN7ZDyII6jGBPJkJvFhtKrhB06zvPK9DPBzSCEZKA5cHlSvMCEDwh4C0PiOOelMu3bIjOeyah3PezCTQrERZxtSva9QyE3/vmm8+qGPxVs0JdWgSL62BzDzzICIlU/aBHyDKDk2FuCH2zrkuF0D64APA5X7jIJEAfSlTW4EPZcza60GrO2GSH7zSWOLcRCRnKo5OrIAQC4SuXELT6A66lYdujWlbT4BgRU6D1rsdeuhrLxcpmzEBfwUfHrtZzoEXGpJ4EbnFUQ3SXexWz+UgZnk0dgToARs9iaKgIFfoXhCwjDsLBqZquNcsluT24=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 06/10/25 7:24 am, Roman Gushchin wrote:
> Commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
> introduced a special handling for VM_HUGEPAGE mappings: even if the
> readahead is disabled, 1 or 2 HPAGE_PMD_ORDER pages are
> allocated.
>
> This change causes a significant regression for containers with a
> tight memory.max limit, if VM_HUGEPAGE is widely used. Prior to this
> commit, mmap_miss logic would eventually lead to the readahead
> disablement, effectively reducing the memory pressure in the
> cgroup. With this change the kernel is trying to allocate 1-2 huge
> pages for each fault, no matter if these pages are used or not
> before being evicted, increasing the memory pressure multi-fold.
>
> To fix the regression, let's make the new VM_HUGEPAGE conditional
> to the mmap_miss check, but keep independent from the ra->ra_pages.
> This way the main intention of commit 4687fdbb805a ("mm/filemap:
> Support VM_HUGEPAGE for file mappings") stays intact, but the
> regression is resolved.
>
> The logic behind this changes is simple: even if a user explicitly
> requests using huge pages to back the file mapping (using VM_HUGEPAGE
> flag), under a very strong memory pressure it's better to fall back
> to ordinary pages.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: linux-mm@kvack.org
>
> --
>
> v2: fixed VM_SEQ_READ handling (by Dev Jain)
>

As you said in a previous mail, we definitely need some other way of measuring
memory pressure here. Since your workload is doing madvise(MADV_HUGEPAGE) (which
means it expects to take advantage of the hugepage by accessing it frequently) and still
getting lots of cache misses, I guess it must be due to swapping out due to
tight memory.max. Anyways, the change looks correct to me.

Reviewed-by: Dev Jain <dev.jain@arm.com>


