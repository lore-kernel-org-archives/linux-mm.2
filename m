Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3417CFD9E34
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9EA6B0088; Fri, 27 Feb 2026 01:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6265A6B008C; Fri, 27 Feb 2026 01:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5253F6B0092; Fri, 27 Feb 2026 01:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39BDE6B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:42:11 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7DF51A0541
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:42:10 +0000 (UTC)
X-FDA: 84489292020.01.4922AD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 31EBD180009
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:42:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vKNKd87k;
	spf=pass (imf06.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772174529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZjRSfA1J0fa33N0Re9W0GNS4OAn0Juv79uWe2f7kUiU=;
	b=p040sOwJFdZDlQ4k3Q8w9f2f7aH9utWM0j0DvNQkNqcGxhkQ2xIYrvPZa2qJR0U6cutqvr
	G+xcqOFL13gMW/o+54r9bmSi9TaVl3l5zoQVm45m3j1Op4w6K3M44vxeL4eERTqVHOK8va
	yoFRnR4szfz2aCcBkr10dK8zM2ouWWA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772174529; a=rsa-sha256;
	cv=none;
	b=PoAvwCyqVh+vaaU+2w+/4HzDl0J+ayofQlJIv9HrIsA2emkSYsQ36XL5eWmAAtALV5I/tB
	IztWQx1sxyofPpbdEeC0NmsSaeSpj8xuPHNS3pEQOiTQfFrOwbHn3DmAG1t9GdG4pE974O
	vt9NodDyxyV1Hd60tlt7qEY1sGwFYwQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vKNKd87k;
	spf=pass (imf06.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9357D60008;
	Fri, 27 Feb 2026 06:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E06DC116C6;
	Fri, 27 Feb 2026 06:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772174528;
	bh=l7o5vW4EQFZ93oUhFFbp3DYvB6UsG9r2GGJLzb9y3sc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vKNKd87k7g9018XjH0D3CkmNwOrKrNd6r7LM1V3s25Qm6Tpromm2h2AyabbuUj4i+
	 Hf/1bvJMM3gmHKUoF1a+3iudR/eskf1QQ9m0hTdphlmbMJZxMJutEnkQdrcqWOqFna
	 mxGhRAdy3nt3hBGmVydrDWS+Yc8IUU0TCL5KUJ3fSU6/5o64tXlJA1R2q+0TbaWZye
	 FEzshG1TBa/UdwaEZK4WZmFr5QWtnGi9k/+qfNkjzMmI8zbuCiGdRDfp++hgB60BzW
	 Wn7Q1zMkDebyVCNaAb3LOtiB8IV/fW6CRHRt75z59MiuV9aYiI13fsIe/TGfNWiq64
	 YvooidiS5oG3w==
Message-ID: <a864b2ed-1a77-4aac-b0e8-d97b4bf8be47@kernel.org>
Date: Fri, 27 Feb 2026 07:42:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 1/2] drivers/vfio_pci_core: Change PXD_ORDER check from
 switch case to if/else block
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org,
 Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>
References: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 31EBD180009
X-Stat-Signature: 6icseegzzzny6q14mdzfcmkktmskqorw
X-Rspam-User: 
X-HE-Tag: 1772174529-896192
X-HE-Meta: U2FsdGVkX1/IGsOaP9wpcoDCNd2ARN87f0kL6tTuIJ5XaGrOuT9hsOO4eoSA4Mp1Y++p0Qx4yTDV7B78oZ9JeyZ8Cpw10p28/D2Ld9PvH6l3fIo8ZB7jOYGuZtUmAgQ5lin4CnoQMFF4iJ565g2BV1Zwo1RvPa9RXU1gGplIN3dV8jb1lx3OEygLH8A3OAUbzf/z5Vn1q1m2kVM9NGS0eUyMvenodfH+b2PVEFFUqcJo437PTpAeIO/wfCe0PAXTkAgdeE+waPtGG3w27/cjJN8nc3Wnlv9FgNA41HjMhPgwWXF9TqSHsSMaZ+ZVLYvHaCR36YGrm8Ne53RWKkswCSsQ2pZ7y8OwapHgPT6Cfrb+znKcwkooyZgrf0h2SKvpozorYKi7NXS8r+Fnco6qvlkQimy0L7hpAt7gaAIgVhDRgtaMn2jrxt6GWe23g+3Bzl4T02r0xMcSDu1R3Uj7+/ET7cCEIJ/Vkz/sCLqsARWgT8sn3MLeKpIVxOCT1ofCz1Tau/f/bPUH7+YU8bS5TAaOyO0sVxIUpTHksYRc2lGIQoA5JLvNcv817EGwn9xQ9uRWCLsVzaB6rv4seruGKzEuPnnR7QUTlWHIpTPDJGdKI/2fGWyXVP0UD9klo9LBWNO6fzJ0acqCb/s23hfEkl5ljHz9lZgGh/Vb14AeSdEzp18rQqiL+z9+XbYJv9+e1wT5ALn1bVOKfnbdL/wViwCGgPucA3ZZEWbHXsrdOESWJPcOamvCjZhZ/y3zj7MNcVP7t2PN1Idgg8I5a/HAJTYA0t58gr9awS57yPwNHMqalqustzpYz7qFZ75RFpXCbM2hREx3Sc+nm/hloDj6OgkKDN/4NIxEjShJ1W6wzfabcgME5spi4tCNyGFhIFS4LE69UpVRbDhyyy/36QKJ/YWuMh76VJjSeR87mrHUXTbT2XJHgT7qcHHvn+K6IFOLhYwjh9Y8eiF7NOT7u07
 vkRyyG1y
 TR9PpUlCwyfkTXZP0hI2qbkzVi53Jr5OcABKwtY1SgI1V8Lb3wCO3wozg9vqGkm90u/zgN26BoPEDkDNP/h+A9WKLyetPnElWc/09kXdGTS/2Rz2VyrQE4+tl3QsvKIwIwJbZzr2E6PgSbpRVNWjnNtXqsLQPdTGNMlFJmaeZxA07C/2Jwv2K+7j2l3KnFV1NdayoCNZvtt3AYViwG5pSzoo+ByJsmSvrHCyIwaykBfnWx16i0abNSA+MCNdhVp1cp4fIUd8QfE0AIYF+jwuowD7OiGs+04CglaCyfbomEgqLu2j8pBf3j0NjZpKdJ7gyE9cxFTwDkZ03K6nyOxcoOfWRePMbkeI4xlK2s+Z9D1HS1dba1WNlzt8vAfO3kxZm8blSMVLYWUgGMAPBh7oBfGuZ+wNlQrZrAcOs8F7lNNjfgyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 27/02/2026 à 07:16, Ritesh Harjani (IBM) a écrit :
> Architectures like PowerPC uses runtime defined values for
> PMD_ORDER/PUD_ORDER. This is because it can use either RADIX or HASH MMU
> at runtime using kernel cmdline. So the pXd_index_size is not known at
> compile time. Without this fix, when we add huge pfn support on powerpc
> in the next patch, vfio_pci_core driver compilation can fail with the
> following errors.
> 
>    CC [M]  drivers/vfio/vfio_main.o
>    CC [M]  drivers/vfio/group.o
>    CC [M]  drivers/vfio/container.o
>    CC [M]  drivers/vfio/virqfd.o
>    CC [M]  drivers/vfio/vfio_iommu_spapr_tce.o
>    CC [M]  drivers/vfio/pci/vfio_pci_core.o
>    CC [M]  drivers/vfio/pci/vfio_pci_intrs.o
>    CC [M]  drivers/vfio/pci/vfio_pci_rdwr.o
>    CC [M]  drivers/vfio/pci/vfio_pci_config.o
>    CC [M]  drivers/vfio/pci/vfio_pci.o
>    AR      kernel/built-in.a
> ../drivers/vfio/pci/vfio_pci_core.c: In function ‘vfio_pci_vmf_insert_pfn’:
> ../drivers/vfio/pci/vfio_pci_core.c:1678:9: error: case label does not reduce to an integer constant
>   1678 |         case PMD_ORDER:
>        |         ^~~~
> ../drivers/vfio/pci/vfio_pci_core.c:1682:9: error: case label does not reduce to an integer constant
>   1682 |         case PUD_ORDER:
>        |         ^~~~
> make[6]: *** [../scripts/Makefile.build:289: drivers/vfio/pci/vfio_pci_core.o] Error 1
> make[6]: *** Waiting for unfinished jobs....
> make[5]: *** [../scripts/Makefile.build:546: drivers/vfio/pci] Error 2
> make[5]: *** Waiting for unfinished jobs....
> make[4]: *** [../scripts/Makefile.build:546: drivers/vfio] Error 2
> make[3]: *** [../scripts/Makefile.build:546: drivers] Error 2
> 
> Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>   drivers/vfio/pci/vfio_pci_core.c | 15 +++++++--------
>   1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index d43745fe4c84..5395a6f30904 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1670,21 +1670,20 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
>   	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
>   		return VM_FAULT_SIGBUS;
> 
> -	switch (order) {
> -	case 0:
> +	if (order == 0) {
>   		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
> +	}

Those braces are unneeded as all legs of the if/else are single lines

>   #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP

ifdef could be replaced by IS_ENABLED() because PxD_ORDER and 
vmf_insert_pfn_xxx() are declared all the time

> -	case PMD_ORDER:
> +	 else if (order == PMD_ORDER) {

'else' is not needed because every 'if' leads to a return statement

>   		return vmf_insert_pfn_pmd(vmf, pfn, false);
> +	 }
>   #endif
>   #ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> -	case PUD_ORDER:
> +	 else if (order == PUD_ORDER) {
>   		return vmf_insert_pfn_pud(vmf, pfn, false);
> -		break;
> +	 }
>   #endif
> -	default:
> -		return VM_FAULT_FALLBACK;
> -	}
> +	return VM_FAULT_FALLBACK;

So at the end we should get something like:

	if (!order)
		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);

	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
		return vmf_insert_pfn_pmd(vmf, pfn, false);

	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PMD_ORDER)
		return vmf_insert_pfn_pud(vmf, pfn, false);

	return VM_FAULT_FALLBACK;


>   }
>   EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);
> 
> --
> 2.53.0
> 
> 


