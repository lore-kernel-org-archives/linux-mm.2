Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E1BCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF7838E0014; Fri,  5 Sep 2025 06:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCEDB8E0006; Fri,  5 Sep 2025 06:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0BE98E0014; Fri,  5 Sep 2025 06:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC7A98E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:59:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FAA61A0688
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:59:20 +0000 (UTC)
X-FDA: 83854900080.11.CC9F685
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id CE4D4A0002
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:59:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UibJNCIM;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757069958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiKzcnLj/5f/fb94zeDKtFDrhCDanQzLysHFXXN8LAE=;
	b=WIFIO1mEYPrjoemBebqrm5/V8rWuuZ3xK4PYiSrBj0DxREUJtXO3EH8ol7NM1aWrm22lJR
	cmTWaslG/CW5xzu7sXc/bk4ASQ7y5VW23w3hXrdJZgCAhlgtS8Cjn4oSOky1eKlGcPEqw/
	cljR4Tf6qga0I0Br30Bhm7/UKL0TMDk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UibJNCIM;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757069958; a=rsa-sha256;
	cv=none;
	b=BDJExKNWAc+MQF//8Q1z9GsCKBBqPxu+H7JQCz0UGAEXEXH/YVP5lhyKfYRuBglyx1ia20
	ZcD35pZUvIuKATcZXgtZBmnOmzPW2CR4Jj1ADML+uThiCEWw9CPYaljsdk64IIXYaIZs3b
	We9cw1ByMG2Mcg29uPFtkDDilykWmiA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F3CC46027B;
	Fri,  5 Sep 2025 10:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11036C4CEF1;
	Fri,  5 Sep 2025 10:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757069957;
	bh=VqDiJJ3zcAyAspTBcpOX7wWvNuTzmzG8WHiJyJZ+R7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UibJNCIMiztHwlV16QILNWLiAcVKVTqlqVFUQDYoiGDny7s80qphFKZ+KkIlW6OaA
	 u5ciLJgj2pKCKLVQoUVuSKwUUPg4FBEAleG36sbsivSwRpP2I2G0xdA1A5KSbvOd0r
	 IPho5uTS2aRoj2F5JIHk0LOr/AC+r3VpszP/yFbI40nD2yIbLnFT/eBXwaeZAkdEv+
	 u1MVUKJxHBtNkHjHxUG7jmR54D/zhHD+DmFMC+tnQTOhoFxP2jl0BaUpUpC0FYguDV
	 CH2YXd3xgtlCEsODQGgHGI7KOuuLARGziJD17tYQzcXhaVCnsC2Mqu0pCUQf3VkQ3a
	 J5fkYCablGnhg==
Date: Fri, 5 Sep 2025 13:59:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: kirill@shutemov.name
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	Usama Arif <usamaarif642@gmail.com>,
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <aLrCfvlhWRCEmwXc@kernel.org>
References: <20250904175729.1029735-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904175729.1029735-1-kirill@shutemov.name>
X-Stat-Signature: 6swd3mufmsd4ut6dwk43nw7yioo95134
X-Rspam-User: 
X-Rspamd-Queue-Id: CE4D4A0002
X-Rspamd-Server: rspam05
X-HE-Tag: 1757069958-68080
X-HE-Meta: U2FsdGVkX19LonNNFQ2LdUPs/IJG1G79nv/suUjcSZ4Y+bbx35pQhD2zFjbGT/e8co1yh/uvDUrpkhV1vqzBP0ZFnLbZsz7aDoLPW6AAR6mCPCbgsvqVhn/gZKfEW1jGbzTzN78tuP37YfEjSkuwzUVyXmMxguYwMbrGvLcp95BtGX0Y+VrqFm6Y5M+NyMm21sz3jZ98EojvIszdBMbyh3i3hSxf+xykYiOt2r3R5BbGcIm+0LHgayv2++uL0GrDq/7Ay8aJpLkGkq4We6ihTiWgNEZ6bLgA3n/LNhhal11lMn/4ZH0Zq5c45oDbFOZx+y4B5JUZEMNec2nRK8s/VY36XvjBjrqwC4xjhhKkhfKV81tiMvrw+4P12JQRnyK0bLJAHc5CfQlLQxqo8ntiyuzrgKRyJWLNfeBJPPqj4ELi3IjSFFY6JjHsIxy/UhBgE41LmJ3TlcAs+txMOoPHhwTr1E6a2Q1v+4U0gdLwvFnguArkps2QNVZLqKMFU5sb4p53hNaN7G1VKsOQrN1AOYy+QU7ul4uuo/lWKmyPlaoeDw6BaSO0qrnlvknogE6u5+ZkMlIJ+MnIrk/hKzjvql2H5e7FU/GqH9NRDwshch7+KcAfbILlrDHQVkCYWBDQV55X/yDdQwrB72eszyD1G/DlS4m8CEDHWr0ZuvXlehO5i1D4Tl/R3iL3mDyQL9N5wIHqrZLVWf/Wdrt2WWQ08KTVhiK9hp+M8ZEZZPCFmVfFLYJH9nrtba11LyL5w2jx1REtjMMPdxMmRQUBOnUIAydtf2TcW97Ni/Q7haLRNOvk/kZ5fP2jxSkVUAjhl0eAbvpTC5oExc886j9dA0D77dD80sMCZ9hUhJu7oFqTpFlZVlKoHhlbJPmcprdAeDnc1BeWAXsEaL8p/dNM1uJl3O63DnZvmEG5IxCFokx1LsfVZ5cax+WCsb+PSh1mtM/4qPQtnq/kHnDwTwu7Hit
 utOg6I4I
 f6jXX+LqF/iuZI89xduY2+38G2qE3isqWGDqME0+C79+vyFzyupSCVXihhRGYo1blRBpcFY5q1EcvNCOoP4Ihuze5g0OEGR6DoMv3ZyVzO52vFGi2lga3D9CdXJcnxaeXL71A7W5JV+sMPsYlTWNLk+evjdhA4dEjHsMa2KMIYaFIzfgUJ3ukXhhMr+5BqLzWXInsPrfio+72o6h+ipMVl7etinmwUP8l4i2XN9h4huucnJKux2OWjo0fFUzSJaNeh48oMl6sSeEW5now7M6IaXDEGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 06:57:29PM +0100, kirill@shutemov.name wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Add a simple tool that allows to issue an advice on a process or a file.
> 
> It can be useful to experiment with effects of an advice on a workload
> without modifying the workload itself.
> 
> Only supports advices available for process_madvise().
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>  tools/mm/.gitignore |   4 +-
>  tools/mm/Makefile   |   2 +-
>  tools/mm/madvise.c  | 170 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 174 insertions(+), 2 deletions(-)
>  create mode 100644 tools/mm/madvise.c
> 

...

> +		unsigned long addr, hpage_pmd_size;
> +		void *p;
> +		int ret;
> +
> +		hpage_pmd_size = read_pmd_pagesize();
> +		if (!hpage_pmd_size) {
> +			printf("Reading PMD pagesize failed");
> +			exit(-1);

Shouldn't it fail only for collapse? Other advices don't depend on THP.

> +		}
> +
> +		// Allocate virtual address space to align the target mmap to PMD size
> +		// Some advices require this.
> +		p = mmap(NULL, end - start + hpage_pmd_size, PROT_NONE,
> +			 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> +		if (p == MAP_FAILED)
> +			perror("mmap0"), exit(-1);
> +		addr = (unsigned long)p;
> +		addr += hpage_pmd_size - 1;
> +		addr &= ~(hpage_pmd_size - 1);
> +
> +		p = mmap((void *)addr, end - start,
> +			 PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED | MAP_POPULATE, fd, start);
> +		if (p == MAP_FAILED)
> +			perror("mmap"), exit(-1);
> +
> +		ret = madvise(p, end - start, advice);
> +		if (ret)
> +			perror("madvise"), exit(-1);
> +	}
> +
> +	return 0;
> +}
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

