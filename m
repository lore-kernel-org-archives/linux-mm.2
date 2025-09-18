Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13B3ACA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 19:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C88A28003B; Thu, 18 Sep 2025 15:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679308E00F6; Thu, 18 Sep 2025 15:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541D428003B; Thu, 18 Sep 2025 15:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DFE08E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:46:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9151160436
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:46:39 +0000 (UTC)
X-FDA: 83903403318.24.72B41AF
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id D6995A000D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:46:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=oUvgxHX4;
	spf=pass (imf15.hostedemail.com: domain of "prvs=5356f0da48=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=5356f0da48=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758224798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNnQo0sMp5meQ8eMdhpYCpDIuJZVf4B2s9e5frOewII=;
	b=P4lfuFvBXwCh5XKNjQDNKzzeCR8//e1YT5pNWLVyH0CeAu7fXo32472djrGPncycZ3OE2v
	mjx185kvVqr+S97YqRlMJaX6acTEG+PO0rvzw4i6FeeAAbZgInPSXqSGLlwxFEd3K1cIP+
	QkHYv/ztMHeCtOlO8fK2bzw1+jqYaA4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758224798; a=rsa-sha256;
	cv=none;
	b=PyFEHw57YZGcx6iBwOvueifsiQAo8CCdmIZSwI8+VuYLYZbR605Xu7fnsxmtol3D/Subvr
	TqE9MEJU3AM7+m6psSbppOjFkOf8tNOT5CT4VauD0oUSFxFbYzpDJ7yCz6tQSP0/x/B4wq
	1RT7Xw3dh//35f1KHZ7qkpsmnwe7wcA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=oUvgxHX4;
	spf=pass (imf15.hostedemail.com: domain of "prvs=5356f0da48=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=5356f0da48=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58IEpiMR2943542;
	Thu, 18 Sep 2025 12:46:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=BNnQo0sMp5meQ8eMdhpYCpDIuJZVf4B2s9e5frOewII=; b=oUvgxHX4Zvag
	QvZfvT5qsSg7XUUNcEKSGHGxSpk1x6xVdjCczVBB0sDEs21e34wV0jIolvVbNYkN
	jTgvyrHUUYwV+lo6u++rCkGbO2ffVmXnU9nQyCKh24yMCSSEvr42Bh75J9IwX/o6
	ZAMcfYDTc7pK2dypZ8HhlzYDN64uYjUg4u+fxTFlpDoC/odFQWOZTvcKC4A4hp68
	PF1Pcn5X6fKmq6NSA1PbQHzCAk0OWb7eyHWUkOL09qiC+8w9o8+rBip4NJAIBH08
	tXqKtlvjXykOV5OBQ6V2VEvoNjk8ciX51kX75Dg+301sFyrxCmy9z2VXMMG5QHsq
	FEXUxCTt9w==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 498m7fjkq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 18 Sep 2025 12:46:16 -0700 (PDT)
Received: from devbig091.ldc1.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Thu, 18 Sep 2025 19:46:14 +0000
From: Chris Mason <clm@meta.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, Guo Ren <guoren@kernel.org>,
        "Thomas
 Bogendoerfer" <tsbogend@alpha.franken.de>,
        Heiko Carstens
	<hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
	<agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S . Miller"
	<davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann
	<arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Dan
 Williams" <dan.j.williams@intel.com>,
        Vishal Verma
	<vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre
	<nico@fluxnic.net>,
        "Muchun Song" <muchun.song@linux.dev>,
        Oscar Salvador
	<osalvador@suse.de>,
        "David Hildenbrand" <david@redhat.com>,
        Konstantin
 Komarov <almaz.alexandrovich@paragon-software.com>,
        Baoquan He
	<bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Young
	<dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Reinette Chatre
	<reinette.chatre@intel.com>,
        "Dave Martin" <Dave.Martin@arm.com>,
        James Morse
	<james.morse@arm.com>,
        "Alexander Viro" <viro@zeniv.linux.org.uk>,
        Christian
 Brauner <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
        "Liam R . Howlett"
	<Liam.Howlett@oracle.com>,
        "Vlastimil Babka" <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Michal Hocko
	<mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
        Baolin Wang
	<baolin.wang@linux.alibaba.com>,
        "Uladzislau Rezki" <urezki@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Andrey Konovalov"
	<andreyknvl@gmail.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-csky@vger.kernel.org>,
        <linux-mips@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <sparclinux@vger.kernel.org>, <nvdimm@lists.linux.dev>,
        <linux-cxl@vger.kernel.org>, <linux-mm@kvack.org>,
        <ntfs3@lists.linux.dev>, <kexec@lists.infradead.org>,
        <kasan-dev@googlegroups.com>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 16/16] kcov: update kcov to use mmap_prepare
Date: Thu, 18 Sep 2025 12:45:38 -0700
Message-ID: <20250918194556.3814405-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <5b1ab8ef7065093884fc9af15364b48c0a02599a.1757534913.git.lorenzo.stoakes@oracle.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::30]
X-Proofpoint-ORIG-GUID: -nb3wVnAtqomihwZ5BzjAk2px7ex6dUi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE4MDE3NiBTYWx0ZWRfX4Y8q+OJtcR0W
 +oYOau8ot7ilGTzu5PMGr/c3x1bedT9B3gqOZHC7hM/Xi6+uaY0+lHxn/Ka9lE213kL68CII/7K
 z3B5d+3wpbiSc/ygeHsIhiWDxHAwN+fGFwFsRE7UhGTUUvWkFkY05ELfd3kxwScqvazqt9rbonW
 bOXl1lczG5Z9G+teTpxDti5TNxhuajRiwYF0JOVA2rBw9NRviqGPh4HP+n9iXtIIMtm1GoToIaT
 Hu39ICr9dMFPAjamuD3EgvUaHLFY/4+APB4u9SBfeGw7HWZlMuLwY/AgydoBSK6opKQCrvQOWH5
 3JASKIaygraugixdHv8cWWJX9wRaKGzhstUShrgPXa9rw8BJZv52JiSljT0Adk=
X-Authority-Analysis: v=2.4 cv=G6AcE8k5 c=1 sm=1 tr=0 ts=68cc6188 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=auZRGODfdbgPxNsHCnAA:9
X-Proofpoint-GUID: -nb3wVnAtqomihwZ5BzjAk2px7ex6dUi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_02,2025-09-18_02,2025-03-28_01
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D6995A000D
X-Stat-Signature: 5qb8cdxeggnnzsmmw7xyx7b3pz3thj6d
X-Rspam-User: 
X-HE-Tag: 1758224797-503921
X-HE-Meta: U2FsdGVkX18hrSVoemjAiM2ON+bo6XWyqJG8M2nS05LiqSZRRlcQOXskhGNUN5MnlxwUIytC80QW5nH+7MHprx4oDq6FuWhYN0pj++zBLTi9T//j7DgIA4DlbCLz5V3zMcLvmN3BAoHlCpokIVfLYcllIHcAPzrLFg6daoL3w765G3t/H+eHwYQDO73YmAruHjqAv4f3+Ck9v5P4PGOsGjBNRCZ28qtpJDCFg9UnoI4dZDn8H9kDPpCQ7l8iHj1x8b6NYWyP1UBmjU3xiiaWa8KnAKIBSOr2yTasjInbw+Fw1cqQmpvb8lGJ3DEsY2hWp/4fh4b/9hUyzitU/Bxn1ezFTygEyPmXAC9SycztL7jo1N5BuLH0zM9vrbYCwKA5Bu78+OTxbvg/P0vxVuy7wBwj6W/vaVodoWVvsWX4VPa+dYD9tSs8CiMnaA5CtNn3sw4Rv89N7SZrjyL6aSFcHAIi5B8ZLy/2d4zum6V3gqK37DOtg9P2FgogaXwOCORvS05J/PwWKE9U9VF67fVS3PH8ezbrRkMsnHkkqGZz0FOEx0FfiTb+D0pUKhbIy6qrJc+dOW0AGiYuAxPFsb706FD5DX1qLNfw2yoy+51tUCvTqqIysFIWmc+Qzsxgo6Rq9DixRJX+ElCF9nwt4kD8XLbao4D640uEXNt4vksNKaQuQ8Lm987zwqXVrvTO0VJxftMWqmZeOFJT2p2A9yVtxKNzXoEu22GGUTVFRUmn46v3FNGekv43Kemtx9LUzFOmIeAoJy82Xbm/PNYmVHrT0NEHQHLezZQVz6Ms9zthB/WHvsNE+NTGnH4M+g0rcw1y0Ejuwk/Udi1Ajxi4AULe3alYNKos7o2TezQqC2lNeXIgTFM9p/qw9O9GnYM59BSc4gCWY1i9/zJTz+0ljwCBpSWnIUfdgmwp5repKhs9AIiwVVXyweMWh+Y46iQU3flUv5lr9Ag54t6v7pmcGTw
 wA3Y37D3
 BazfFBpHOGXuWIRSpoBRYwODv/60lFq3Slphrnq04clQUhXEoieNhJDd9q34ydvS46JT9xHw8/T5K9gBA98Vf4wX/s/hOxZT6qW/JsNZ7wOVSj+2LPOvrggaFBLxtTm4nIfyz77CnkZLNdCkLdHAB4+8KYplPSVgM8saaVAc0TyZZ5YWSZQO2G8xdyBvpehTt17f93n7MhYhbdE2qci9iC0URaSNIpaSMAu7HcLnroOSHsdPskOSCaW9MlmjCYQMOBTJxiCzTeNFk8PtDftCIU2SNsxBl1SfYc/Dl0SU/Xn42NhU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025 21:22:11 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> We can use the mmap insert pages functionality provided for use in
> mmap_prepare to insert the kcov pages as required.
> 
> This does necessitate an allocation, but since it's in the mmap path this
> doesn't seem egregious. The allocation/freeing of the pages array is
> handled automatically by vma_desc_set_mixedmap_pages() and the mapping
> logic.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  kernel/kcov.c | 42 ++++++++++++++++++++++++++----------------
>  1 file changed, 26 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/kcov.c b/kernel/kcov.c
> index 1d85597057e1..2bcf403e5f6f 100644
> --- a/kernel/kcov.c
> +++ b/kernel/kcov.c
> @@ -484,31 +484,41 @@ void kcov_task_exit(struct task_struct *t)
>  	kcov_put(kcov);
>  }
>  
> -static int kcov_mmap(struct file *filep, struct vm_area_struct *vma)
> +static int kcov_mmap_error(int err)
> +{
> +	pr_warn_once("kcov: vm_insert_page() failed\n");
> +	return err;
> +}
> +
> +static int kcov_mmap_prepare(struct vm_area_desc *desc)
>  {
>  	int res = 0;
> -	struct kcov *kcov = vma->vm_file->private_data;
> -	unsigned long size, off;
> -	struct page *page;
> +	struct kcov *kcov = desc->file->private_data;
> +	unsigned long size, nr_pages, i;
> +	struct page **pages;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&kcov->lock, flags);
>  	size = kcov->size * sizeof(unsigned long);
> -	if (kcov->area == NULL || vma->vm_pgoff != 0 ||
> -	    vma->vm_end - vma->vm_start != size) {
> +	if (kcov->area == NULL || desc->pgoff != 0 ||
> +	    vma_desc_size(desc) != size) {
>  		res = -EINVAL;
>  		goto exit;
>  	}
>  	spin_unlock_irqrestore(&kcov->lock, flags);
> -	vm_flags_set(vma, VM_DONTEXPAND);
> -	for (off = 0; off < size; off += PAGE_SIZE) {
> -		page = vmalloc_to_page(kcov->area + off);
> -		res = vm_insert_page(vma, vma->vm_start + off, page);
> -		if (res) {
> -			pr_warn_once("kcov: vm_insert_page() failed\n");
> -			return res;
> -		}
> -	}
> +
> +	desc->vm_flags |= VM_DONTEXPAND;
> +	nr_pages = size >> PAGE_SHIFT;
> +
> +	pages = mmap_action_mixedmap_pages(&desc->action, desc->start,
> +					   nr_pages);

Hi Lorenzo,

Not sure if it belongs here before the EINVAL tests, but it looks like
kcov->size doesn't have any page alignment.  I think size could be
4000 bytes other unaligned values, so nr_pages should round up.

-chris

