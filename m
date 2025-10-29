Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD606CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 17:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 386C88E00BE; Wed, 29 Oct 2025 13:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35EC18E00B2; Wed, 29 Oct 2025 13:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 274CC8E00BE; Wed, 29 Oct 2025 13:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 126D78E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:56:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A41F614081F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:56:12 +0000 (UTC)
X-FDA: 84051905784.24.7B261AF
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 809FA100012
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:56:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=Vimp3MtE;
	spf=pass (imf14.hostedemail.com: domain of "prvs=739771b859=amastro@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=739771b859=amastro@meta.com";
	dmarc=pass (policy=reject) header.from=fb.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761760570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axoW2tDkGrfDi0xS9qbPyqJMFDakpwS8BEDWgEzRujk=;
	b=cfqlEul6TDnsV/zbuwAf1+Kb01fvwmqBJTbfWOyUC2UPz8jpGHDcH/SVbBIbAAxAgnyDpU
	bsuwnCenIF5zNE3qXaJXoZJ3dllxWfmO56zVjW++HlDa6/y5A8sgO30VwGwRgcKeqx5OC+
	ADuwgkfwptYXVCR/vkS31je7Hp/O+aY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=Vimp3MtE;
	spf=pass (imf14.hostedemail.com: domain of "prvs=739771b859=amastro@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=739771b859=amastro@meta.com";
	dmarc=pass (policy=reject) header.from=fb.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761760570; a=rsa-sha256;
	cv=none;
	b=IVkxGGlJFF3JwMKiiSC6EkS7HLlF4iESFIw2hyFuvzZ30z40Lrm+MywDQpIhzIqCOFInJ0
	HNWClY3LZSGcpaqtVBircsCS9XdQno4xk39XBTbz9upf/WZUni6uHpivQP+ZtbCLFenEzd
	n5yI7xShh0pmTc+lT3xRM4iZv5KnS8s=
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59TGKFth939323
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:56:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=axoW2tDkGrfDi0xS9qbP
	yqJMFDakpwS8BEDWgEzRujk=; b=Vimp3MtEiLcB3sIDutf/dt0xLjuxMFAtPgHh
	kBbqoq+A7FgV/3BOzk2A0pcySZYW1gVuba0ELYdUabadYPC13z5GJO5kmIIOdgfe
	sOqkzemMaOG/esAsoMDH+bWQvVruLGBU4PQKzboPIPw+KI4Y+iQYEVncNsRWha/0
	n/jHSkb3aJ69G425kJ8eNinvtX25q9Lpz/GGB8qpEetwO840t2hei3zmBX8GR26B
	ZeMU5ns8YTwhmu787EU/t36oDAynpzAZDaA3F9SUriX6DijXtn700wa80E6sD3iY
	F73l2dd80CCr6BsPtJEvaCQYxUbve2NM/e7LA9iGBXPXe3QclA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a3fb1m51s-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:56:09 -0700 (PDT)
Received: from twshared37925.29.prn2.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 29 Oct 2025 17:56:04 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id 2C7835A07EF; Wed, 29 Oct 2025 09:50:31 -0700 (PDT)
Date: Wed, 29 Oct 2025 09:50:31 -0700
From: Alex Mastro <amastro@fb.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky
	<leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christian
 =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <iommu@lists.linux.dev>,
        Jens Axboe
	<axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        <kvm@vger.kernel.org>, <linaro-mm-sig@lists.linaro.org>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-pci@vger.kernel.org>, Logan Gunthorpe
	<logang@deltatee.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin
 Murphy <robin.murphy@arm.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Vivek
 Kasireddy <vivek.kasireddy@intel.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <aQJF1wiWWWoIgHI0@devgpu015.cco6.facebook.com>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: 6Q1eKRgXjc6fkL0UljSkRKgFTK8Mf0cr
X-Authority-Analysis: v=2.4 cv=W9E1lBWk c=1 sm=1 tr=0 ts=69025539 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=lyVsTYTlkisTCRK468AA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 6Q1eKRgXjc6fkL0UljSkRKgFTK8Mf0cr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDE0MiBTYWx0ZWRfX8qFZejiop1bh
 x6Qr3bo5QNXJBjImLwEqDMPuv38b3bPQJNiMh7yqbsPbP9yyzlUMAWvczdJs0NAare1c09OBHmC
 zHgl1ysTW9wZK6DTKfn44A7pjm2ghZpSSsbPVrXDahOsBabQJ3581dTLbf0RFEqO/EoMKecsMii
 oI0ObTrTonSwGM7cWWCpyAbL82ZEQJ9yLGKqMCyUwqnZ1x5V6a6usOXXQlaE0nCOwC6cgZq9P6J
 TK5YWF1IpNREWVN/1teHjvoZpR9gcj73ILccy7p4xmw85e1ecEkMGb0HhAnRxZ3NLWqfmBkZoDV
 7fTHQaI8HHJ1eIIH8TuQL8BIOK9FZv9RZagbP5ov8eTfBJSQaQamDPb4e+895nzt0NhwFvJ+ZyE
 hoCXrei3VW02s3d66wf/z3cghunQ+Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_07,2025-10-29_03,2025-10-01_01
X-Stat-Signature: 55b9fhtrw4ksjutsthniu94t4zh15pwd
X-Rspamd-Queue-Id: 809FA100012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761760570-923623
X-HE-Meta: U2FsdGVkX19kVB9sngyMgGHDeLgoyc2F9fjN+GR9A9aBZq5wiZkSVik3LoJOR/Y/eZuF4AYowWQQ6CugwXqvqf5V8A48Alc0Op5jV82Pf+w1XuppEQPP6qJlqxouscvjG6Yj586DT/oMBdDHZIjH+cgu2PEn8h33yPglSputgyJ//Mrr0vRUKMcky/qSc7R3FgkRyVvtraD4+01RMTy5u3ZeCvZmJiebMrpV2bsc1DpDFmBn3b6ho2lEwN/x37mlvRuCPQ5a/HqEMZ4ydrveL0V140tozd+sulvRU3bmj2kVqPTmb+WZzAMkABQVAuBzeXpGknxT6KuTOyQyhWAB6n4v3Iu3+TEDD4b/ngzWIdK5ZXmX2VEDC1wDH1RGI0XMrxmcFoQHl4cPiLvtpuFaGPmacFFnX/DaILvzf1/LGbdyhwnQI1sezQqNqw0C+VBpm8CjvaZJpMGlABjLJSNHqW1VG5CCZgqoHwzq9wnIjQlEhlQKnqxTnXFFMJDnMwyKG4iZdTQxBOrwxkbnzZH99V/IUxfcw/HzTRne5/5q/A2o03gojpxx90qsz12CCmDsNJywdokkLOrOKeoRag2ED95DeidPPpnJqf0JM7AkI1cL+5/ZOGaaKugyxW2BD0XnoWCdbawQ8e+D0Qdia1WQsm61bpVJ0goN2gDyNnhVXT3/gjwnD8hse64US/DYX78+8WRDLdhHyO06PxXPdOJzWGVaEu83Jnmno18FkUCdz48jB7xBI8kfgbrl+pc5CTKCH35hqbnC3kliwTWa8T0DO0r/8JaESMDGC+7Bz1dh1l5PEN4Hov1giIW8JYejvWoMgC1ktPRpb0Z0/wwCO10i50tMh7e6X2kGYEb1rfv+3v/cFOBzXLjzIdxYc/meyEgogV6zSUkOo8Uh0vNsYDnZz7sLDUxzuT/FD3KWuWU9zFA/yXBl4aAJgsCNCcTmiFgHyqN2otjnW71DezMpbGK
 6/ueh1nn
 FZ3S+xBJkp6SCkrQpji44FEirJiCSD/QRGKwwkaJbdgnTSeOcBQY4gjfto41shKRV7JO/pNHGnyCoUngfUqaggfZLzmL+H4d5125T1CP602P/3f5BAr4SOlEtxTh6uuBruDq+3h0NgxZT6Fr3co8j7O9J/vMWn3BcEUdN+3ilLeFUFyQBILs7AcO3i6kpgQL6H0UrZJimCoNhdrYmhzCMzCy4p5PFqYGPFK5rtX2fMwp9wFyLoYsEIOatxTr0GsoMdKVNcOGLa5h8Pt956+yTHkJWIT7Zry8h3NGh6wAx1IJ7AXtmlESH2m4Xuc/L1I7x0N7g00nUaXd3viiVSSL7wAqARg1Awkw9+MFveXLZJkseWBkuhY8vNN+/4ckKI3JFWyR+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 06:26:11PM +0300, Leon Romanovsky wrote:
> +	/*
> +	 * dma_buf_fd() consumes the reference, when the file closes the dmabuf
> +	 * will be released.
> +	 */
> +	return dma_buf_fd(priv->dmabuf, get_dma_buf.open_flags);

I think this still needs to unwind state on fd allocation error. Reference
ownership is only transferred on success.

> +
> +err_dev_put:
> +	vfio_device_put_registration(&vdev->vdev);
> +err_free_phys:
> +	kfree(priv->phys_vec);
> +err_free_priv:
> +	kfree(priv);
> +err_free_ranges:
> +	kfree(dma_ranges);
> +	return ret;
> +}
 

