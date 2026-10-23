Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 105B7606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=gentwo.org header.i=@gentwo.org header.a=rsa-sha256 header.s=default header.b=oLAMtts9
Received: by kanga.kvack.org (Postfix)
	id 9B0906B0BA5; Fri, 23 Oct 2026 13:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988ED6B0BA6; Fri, 23 Oct 2026 13:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E496B0BA7; Fri, 23 Oct 2026 13:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F70A6B0BA5
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:11:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5C361201B2
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:11:58 +0000 (UTC)
X-FDA: 85354533516.02.F91F59A
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf31.hostedemail.com (Postfix) with ESMTP id C5E4720002
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:11:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=oLAMtts9;
	spf=pass (imf31.hostedemail.com: domain of sh@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=sh@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792775517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTTA+YbrbBMm9z50z75gsdicdlYW7qnqLdRemdmWzl4=;
	b=2NAjmchT6ldpA60+KOLOYv9lKpGYDKCU+nacHDXYFTjZA9NNexnTGDGpXa6rhMR1ItyyMN
	1hE7MBSE+e5Q0vY166pk3mluxmhdHJPnrqiAj6XzS8DG9Kp3kmKr9dglTnPxw7MSaEkY6z
	21J41Q7CnfthVgD8wyIarQ0UHlBxcIw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792775517;
	b=70DvkrmmOGlQgCzfjIwrIU2Ta34vAKxuzChe5vjo6oPss7u2eoKo4W/uhThk4COS69JLgZ
	3AN8TPKQmHPUyU/0mRPPOSWOcRIblPPYt+gMho3zVFq1UkxEjubL4PepgiuLCDPSQ+hILd
	lRhvf/MDfP5uPyr7vqPFCpgaeIgrHxE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=oLAMtts9;
	spf=pass (imf31.hostedemail.com: domain of sh@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=sh@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1792774952;
	bh=j3lnnu+XwJ3IxgiQhhhYJRK4pj38bqA5bxE8+qnusw4=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=oLAMtts9sWUtxc9TQq6u5hWDNCmmVutWKxG6+JOk28oNqzJJQu+zjTjPyYIRq2CCx
	 zmttuwcM4oIMy3Lo1batINoIfXpF8n1NfIBOB/AT9ZbZja46SOPFkkDVcdr6ww9VaG
	 dUz+80CNt++Md3IzWWxo/7SoIauw8QyW4e3e4M0A=
Received: by gentwo.org (Postfix, from userid 1007)
	id 66FE2406D3; Fri, 23 Oct 2026 10:02:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 64795401AE;
	Fri, 23 Oct 2026 10:02:32 -0700 (PDT)
Date: Fri, 23 Oct 2026 10:02:32 -0700 (PDT)
From: Shubhang <sh@gentwo.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Uladzislau Rezki <urezki@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, 
    Shubhang Kaushik <shubhang@os.amperecomputing.com>, 
    "Christoph Lameter (Ampere)" <cl@gentwo.org>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: reject overflowing vm_map_ram page counts
In-Reply-To: <y5yuwnmvq5nouoitqj6lloz6hepha6cf6vmh42rer2zhgv32au@vbvr3ohn24tf>
Message-ID: <a8931158-460a-9ec0-28d2-44f3a4956153@gentwo.org>
References: <20261022-vmalloc-reject-overflow-v1-1-5fde0042ffb9@gentwo.org> <y5yuwnmvq5nouoitqj6lloz6hepha6cf6vmh42rer2zhgv32au@vbvr3ohn24tf>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C5E4720002
X-Stat-Signature: ebxuxm3izj8ubg54cfqdu4bqyxn18o49
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792775517-774017
X-HE-Meta: U2FsdGVkX1+ALun4Kj4JqYJ7fDq5POyd5Ns+nwa1+ZkiT29/mwUFBz+/IxV/IWPGZgDxe6haB1Pi42BLr/379jaCo8tD8OWKyOjn0WzoeFaX6oeFuvMEJHYOI7h2DV+27dG0omEbvvXuewIyzYxTbnKgmH8t6gKDh4b73rK0eM4i/h7QaVn8beDps5hvM3EUT3q2oa9DIaO7VDuzTOQaTgZIvfw88amKK7KOIVcxPTYGPgoBMIkSq4XgcHUcDJ2zwYtIHiWJgo8cQc2EN8j2RRX0f9Ii6V3ikNbp8HROwMJrBhYX8GbFHmc1S5oUMs0YcsoEnLIoecMFUvPFA12tJcI1u2ZK4EuOKVrxjfJqOLNsJWVnVIgh1mAY2LgFyXPTm/5Q6qo25lUBRRkEENkPAuxbRz3L+nRWYYW6GGq3s7pNSMy+4ltO6hHnRpzaIqLvhQCPQ+pfqmhJzATtp1LVA2Hv7Avmxz4tjAnj0Tz18joSwdQsJSy1r6XSECFtIkD4f4Hh4SUmYuzw5jbKhjE7fgaHavv0Qtex+H5++SvCNE4/lQ7IAn1aOBv3yRwiFTsGKH9Y8NptQBVyJ0Rr9+YWvN+J67sYOgVB+Cd4T50vFAFBgvC1BTSIaB9ee0WFtXYQaK8xz61OIhoAHqOMVkhr38VwvLQKc0AZ9jebuuuFcbuDnmKKslz3hNL5GrM+mOPQGrDrFNZ7v7NX2ubo2PBsYLGNAirDR/auCby80WBFTQdZSRR5ctxw11+Vlwo6B0ZAFAjhZGawQgwUwpPGO6IizWQm4LRJYI/aabL/1tKTMPLELnPfo02671ygds9TjdiD1+6KbXgANMAK7KYRlstR4JN9r4afAKOMgQejtRN/EjUK2pd5VNsY+BgArDOMYawamiiihFyb9k8j1gD6nuBC7tmqpI61nG+zOmRt/NXEXvyiVJjifDVxwKHZ3dnm9cWaQb2ZPQEUAe/Xb8FdpqW
 cilzQumo
 EbCD6J+GwaC+moRPB9suzZ51qAnBF2MeCli92YufuWtNIFzuleYQn8haIahjNESBTpgMPip0hpmk+f37Lh/zsxKjABF0Rhg21ePA9Ne5o5Y4RzTH5v+NIimipZMFKT/Kof98D3I+PJvhbqH/jXrMcRu5JehOaDzTPlU/PXjY8eBFl+U+rx/UgMD+NxKEYG07An7p5qr1YONgW+HkDi0SE1GSrfjaVqlY101wmH7lvY4dZFVFijNgAI+AhAlQZLvYzxzdONXOgKNMQWVHJ6Ok+PlneEwkRep6T90FsLGabrqGuNXLJ7wpVUKjEa7vUZygk+e98reyZfPV7EHFIN7rWXS2osoE6aNNavciUSWTmVhYBIqKJYHVXmJgDDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Anshuman,

On Fri, 23 Oct 2026, Anshuman Khandual wrote:

>>
>> +	if (count > ULONG_MAX >> PAGE_SHIFT)
>> +		return NULL;
>
> Could vm_map_ram() ever be called with such a large number as count ?
>

Yes. I checked the direct callers while respinning this.

udmabuf can build such a count from userspace-provided, page-aligned
ranges. It stores the accumulated count in ubuf->pagecount, and its
DMA-BUF vmap callback passes that value directly to vm_map_ram():

 	vaddr = vm_map_ram(ubuf->pages, ubuf->pagecount, -1);

On a 32-bit PAE kernel, the default udmabuf size limit permits a count
in the overflowing range, subject to sufficient backing memory and
successful pinning. For example, 1048577 pages with 4 KiB pages is a
4 GiB + 4 KiB udmabuf request.

There is also an in-tree import route which invokes this callback.
DRM drivers using DRM_GEM_DMA_DRIVER_OPS_VMAP call dma_buf_vmap() while 
importing DMA-BUF through PRIME, which reaches udmabuf's vmap operation.

The same overflowing conversion makes udmabuf advertise a one-page DMA-BUF 
size and build an SG table with a one-page byte length. Therefore, this 
establishes that vm_map_ram() can receive a userspace-derived overflowing 
count. However, I have not found a current in-tree importer that then 
accesses the returned mapping as if it covered all 1048577 pages.

The v2 using check_mul_overflow() is here:

https://lore.kernel.org/lkml/20261022-vmalloc-reject-overflow-v2-1-0db7a20c53f0@gentwo.org/

Regards,
Shubhang Kaushik

