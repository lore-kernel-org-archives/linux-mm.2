Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60154E9E30D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 14:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09076B0088; Wed, 11 Feb 2026 09:21:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996176B009F; Wed, 11 Feb 2026 09:21:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3596B00A0; Wed, 11 Feb 2026 09:21:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7BBEF6B0088
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:21:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30FE11403F1
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:21:51 +0000 (UTC)
X-FDA: 84432389622.23.413BFAF
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5725840010
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:21:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cTNcurcr;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770819709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dEL3esNNatCbr/bkbGQf1MBlSa4lnjGnRCnp5HwHRC4=;
	b=HvRk+oKYzhePGYpJnv6SSNkD7LBFGnQClADEkeJ8+kdtZ972q+R/cqOFzHb3Vzvcu63Hpe
	HTyAWe7bNOqTfIXbUuL/tclMiRwhcxH0qT2J2ARditWO+gf9p4EpLmwmqssTX2BcQluvds
	fKqzZyRLpeUYf8nQ2YdTNownXNXmiGU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cTNcurcr;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770819709; a=rsa-sha256;
	cv=none;
	b=IwjoanHUSUFL1O0P1+T7EROTQ4Dds82wDefpRDgRPP4GwiottxZLgtuj1q26bjlwu4BXLp
	2Derp+OgonhnQD+Rh3V0umDT3miBLKAhbB8t70ylP6STztUMK9K0VoQ2KJ0/Aa6Ler6/2+
	jEhsA5oyOy0Cu6sMM+YA8lC+RkC320w=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-505a1789a27so11578111cf.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770819708; x=1771424508; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dEL3esNNatCbr/bkbGQf1MBlSa4lnjGnRCnp5HwHRC4=;
        b=cTNcurcrJRnMtL1FhIU1jsqI/EFA5kbNLVoNIbRbGLykhi8Nj2cX9yFw/ybPDrV6Os
         mU6NzIQ5Thph+1dkgONUFRB6KfF0rIi0IocKFSN4zbFyBQIAphpK345F4s8Mi0jqos8k
         sH54izRu/FbrQd9OX3IDLP0sgTELZrL64Fq3SEl3e9t8spEMuymfuUS0iYqVInBl3gyr
         bTaaYcevSrMMTuJBQWoZBVPK499fS+bUlFRgeWqXtL2V/Pz6wkm3c4cPNsFmKQ/KrGdr
         AgtuTINBu8Rsw7gXnTGFeW1XxR/f33YbsacvyRFDnWujL8/GMWvnPGJHDxctch+73RTo
         AVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770819708; x=1771424508;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dEL3esNNatCbr/bkbGQf1MBlSa4lnjGnRCnp5HwHRC4=;
        b=JbRdXaw23hWfze+TmG8Fs+zjQGlRu8wXQYCagFLH2u8Uy4EsYt0EokBPKpu5O7iPaa
         0TUnX6Hj7Ya3nLROeDjgBMw2bLSkyQ3sauI1r+YUKb0R9EuXSyJA9k8oW7BEnH5+3hDR
         wuLhYedxWU0BQDFhrUkNk6NyPFycinSN2A9TPEtrN8da+DvULlPMiPYm1aMqVbI0Evk5
         nK8WXe7uIqxpcWujRDTvwLI02H4PUcdYusdgjReTRf5N9pztcmyBFANE35evVRi534sT
         8VAklnLpC43pU3z6JraB6KPoUQZ0eFTCUuAhsrAwvX/GConSqu6m/RB2yLbfbPwOOHOi
         xKsg==
X-Forwarded-Encrypted: i=1; AJvYcCU3AL6mUuzDE+nkjx1LHvkLevKYXN7t2EeEF/G8/Wl5nV2DLcpm6miG6iWMVgeBvHrcgAlQx706wg==@kvack.org
X-Gm-Message-State: AOJu0YzhnI7U0bRNFATM+Dk3RPs8el9I3kPKiKZrCyWY5PBEUEEbKBtj
	03amW1RzfJfAMI3darrNkzMrKJnFHMFadrJHkDsWP+WQ7oM4ymcF/Zmo0tdseoaCbbk=
X-Gm-Gg: AZuq6aLkTsjcUrEJnjv05H5Tm4DHaeFKslsfCFFVt3FtIfEsqsOG2X8swwY0sGZ666p
	dBkviEFY6yIEGMcis4Ba1+XMMbk15qWupeYEn7cV/Ynj6bXphsAnV+oj0k/5QxOaANPSHh8RnXt
	yMy/JZwDmXtVG0yhLHqx6hItcagPzTJDvDyrV/CtYuiWU/MwxmOMjmqb1raOTaf1gyw30NsGXnf
	vqnkOUc2Lkp1RSQVOm251AiQIvu1EPfIb4X0+ReZb/iPQHrnMsLRU5sWkwEnoug69kJpckmFVdX
	M1vp2xOj8U6wf/u8dAfyg0NfNbuGGFOIDhFDNLLY0xOeNoOYgK/4OBA0ZtKfoHlAu/PFv/+0n7D
	8PxsZoRhXyxhP++BCmF6UH61WDS6uRVB4jCtWV4ae2uK5qoTktSm3XH8RIq1f1H/dLhF/NhEWoF
	IAwvniFfVAwx4AMJFRcohAEf2hImQSV0ADCrnquEuT+X3ky1d3hBa60fdhk0mLdl7YKyoqL1Cqb
	AY63EyoAQ==
X-Received: by 2002:a05:622a:646:b0:502:6ed5:7b04 with SMTP id d75a77b69052e-50639a199b4mr244208631cf.74.1770819707999;
        Wed, 11 Feb 2026 06:21:47 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-506847d7bdesm14877131cf.6.2026.02.11.06.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 06:21:47 -0800 (PST)
Date: Wed, 11 Feb 2026 09:21:45 -0500
From: Gregory Price <gourry@gourry.net>
To: Cui Chao <cuichao1753@phytium.com.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Mike Rapoport <rppt@kernel.org>,
	Wang Yinfeng <wangyinfeng@phytium.com.cn>, dan.j.williams@intel.com,
	Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>,
	David Hildenbrand <david@kernel.org>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	qemu-devel@nongnu.org
Subject: Re: [PATCH v3 1/1] mm: numa_memblks: Identify the accurate NUMA ID
 of CFMW
Message-ID: <aYyQeSzSjBaUjMCJ@gourry-fedora-PF4VCD3F>
References: <20260211103320.2064211-1-cuichao1753@phytium.com.cn>
 <20260211103320.2064211-2-cuichao1753@phytium.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211103320.2064211-2-cuichao1753@phytium.com.cn>
X-Rspamd-Server: rspam12
X-Stat-Signature: fki5wg5kutaxtn1wgypde4acsw41ro5f
X-Rspamd-Queue-Id: 5725840010
X-Rspam-User: 
X-HE-Tag: 1770819709-160907
X-HE-Meta: U2FsdGVkX1/Phqt/ElxiCSBuNTOj8LzzPkxcy7BAFtYjBPGRHJ0BDtXiLXPj28CvQhdhXyVGFw2QvrCKPpbJrBDW/I/wRL0lswLv0CZobnwmiOKMFWyLDQdlKco3/LmRNWHQYg3xfTuN2d8REtCQ4ebehCcQ4mW7vV0kmL1bJjj77XtS+zz253rpvcwU8ASb8B94zisz7/cKLjdK9B4aGki+w6ZCCxbe30Zk0l+O6fGlJ4gQAGAWP3RPk6eyYJbwsWptWbeidm3Nq9iTgS5+areKBfsH+DsRx02xFEl0oW4ZrQj8gKxftr60QT09gL4YEpzdVpcfaPORw6Un00AHeI5zalMdM1ldEJ/vtfPV5KRP1PX5deabkGK8af3TnrmATTK2K+/TcAox/8ksHF5ylujmm2uAeikC/hMe/9ttMIDIMAVmCeYBR3A7d0ij+cqRzW+kkxvt0n7pIoY5tdJaWBFQsF/AcmiJPjAB7ampe06CGLM32mLhNs1fGar41AUA3GVf5gv0J8ttgwna97SCqeAsJXMPLDDVSNs3tpu9VpNpEy7xiZawsdDJtDBTKS6kbAOdTzmKB79XSO1ckzpsKm+Vx1bd/eKPbcwuSIjUT53QxMFZ8EPvMydqM0njLlkDdxM8bR0VaeXctfUgxkndqxuUtiomXudxJd/uuK4vTHPlMjlCosbxzcgyF2URDKuCyg9H08xvlPxmnCNVtxnAJWWgOTFOPH6F6QIniScOnvQKe3ZRLOeAeg5fdkvQT0/w6A0KlNHib+zHMTCku0n/4mQXny5LjlqofT+YnF2E994DL96mckeMdn7B1L2A6CPOHGMuqW/3pJ8pdbYPJpnMjZKtsvztQkfbiK/f/ZFo5aV6PmWkaBblVQeSgWOjMpudyFTM4KNi+AWtR+MCplGW/nDt/vVQGzkP7THbn53eViV0Zsa0ZNTCg56MpB6tpv/T59nfj9ko9936AmyF141
 BJTWxEFC
 8EY3JHTLR7W5fB9bWRiNATcDsaK6lbEd2GHN+Xtie6FWCmx5bBAxcZuRv6sZXE8ZjgKIoTvxUCv73riVC4o5t+zD5s1hQPFhd/XXOsaxAWUvrt9EbFcvjOC44AVYL+H48jLZEVetSOUax7BIhT/92outQBdhjaCyRlhBS/x0ZxDBCCsFZBym23Cgtiw+SWDeA/5TOmrNWEWEf0FFZ+PMokvTRCq64peFk432TL3FjT+c0DdoGpDwvRLCy1xIYV4Q/RK1B2npIiCMwR4RDt3Uu0lkyZs9e609RDFeTHsZRKAPcdXt59ZRDtiSIhw9p8fTbTEaMr+uF/ZIItFTtomCozh7LAuzcozwIbFmkh+NjfEVdpdBGgKYjcLbfgN5oPlM3FCAssmHZJR+yRWSY3+bmO9dNtl319wQdWw02y+5QXnENgTo3vL4oDxIUkFNHmCYXU9j0L5yyx7PsqBb4vb5T/BVvK2Eytq2ou+Vnen8lJH8fYny+FM6wVQOGJHMT74ItnhV6ePty05KVCVQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 06:33:20PM +0800, Cui Chao wrote:
> In some physical memory layout designs, the address space of CFMW (CXL
> Fixed Memory Window) resides between multiple segments of system memory
> belonging to the same NUMA node. In numa_cleanup_meminfo, these multiple
> segments of system memory are merged into a larger numa_memblk. When
> identifying which NUMA node the CFMW belongs to, it may be incorrectly
> assigned to the NUMA node of the merged system memory.
> 
> When a CXL RAM region is created in userspace, the memory capacity of
> the newly created region is not added to the CFMW-dedicated NUMA node.
> Instead, it is accumulated into an existing NUMA node (e.g., NUMA0
> containing RAM). This makes it impossible to clearly distinguish
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

Changelog comments after this are a bit much but other than that

> 
> Fixes: 779dd20cfb56 ("cxl/region: Add region creation support")
> Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Reviewed-by: Gregory Price <gourry@gourry.net>


