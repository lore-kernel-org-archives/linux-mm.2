Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE26606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=BmAQhhA5
Received: by kanga.kvack.org (Postfix)
	id E0C946B06F0; Tue, 24 Nov 2026 08:53:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD2A6B06F1; Tue, 24 Nov 2026 08:53:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CABBC6B06F2; Tue, 24 Nov 2026 08:53:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A43F66B06F0
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:53:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A0A880B90
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:02 +0000 (UTC)
X-FDA: 85470153804.12.B6E1525
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3DBC4140007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:53:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=BmAQhhA5;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795528380;
	b=FUfHFfwkiw0QRq6rLlH1GWDk1ksdjWTzt7Dc7E2qxDonGBdkDBYC/XLGpU15cxRqDKL1MX
	0BqNyMvEXvaAm/59hw7ySQIxqmQ2Xbxm+0VsD4t+XTM3jlBEiGMKCTTcQgCCOMdYd+GnWT
	muv+dorgdcA4JhNsNEypGyBw1j0JpaA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795528380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ervTDQvCqZVrcHY/akwPcAXB3ZloIorGLfgD/yjQ628=;
	b=hUURN8rgbkgsBBnydUFM37j0ufDWSyXDq7tMkOBUcvI453arRPxx+ErIOnsCtXdJJ+bt/6
	gWZrvcx/qzcLjQM+hiYcSEk0nkQSB157kjpDtFc73cJkg/STgyaH6703/xPjaSCHN0L/D/
	88A5iFQ0FNYQBmI0vbRE6hdir/R6KVk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=BmAQhhA5;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-921318b2eb8so60523216d6.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795528379; x=1796133179; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ervTDQvCqZVrcHY/akwPcAXB3ZloIorGLfgD/yjQ628=;
        b=BmAQhhA5p8Ag/jsDT01yHs9u4r1hT/29Q01z60oEcuC2L7VCLryO1qr0ZA5b3rDE0U
         fn+P8KxV572tgFN7qnqjMBwloHsZ4Ej9i+OODrlGL0+P+R1upw2goLTOYCMWpAuV8152
         VEKhj+jXcG14qAig0r+JOe1UMVlxaqiMPZNJnNc2ng4B1G/CbClQ7jsPAJhtr1w1Ei4v
         +pkvJXpxZNQSx/ok25i94ruZuOf/q47r49BLYBku9kg0+TqUIkbF0juGB9PN7mKu70Oh
         uuy4URy7s3mnaMLmzGEjE1R1J+6lKgOpO1nKxPVIxOPnMByFCawfYe51w7ppIAcD98eq
         EbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795528379; x=1796133179;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ervTDQvCqZVrcHY/akwPcAXB3ZloIorGLfgD/yjQ628=;
        b=eHw3LE08AuZ9ZuRD4JVEspeBjSaPwoly0TlYVF8of4zDutm+QYn9FdzMy3YGH6lKuO
         UXG1cvQ3sVKyew7TGqLp6KfnMnaN4plnSxE0wFDpYNd7LMDfRtHOSQccQPXrWZn2pZ68
         TNODzqrmwXcYjW7HeLGrsTrEyz2uyKlv+W3lZhEXvX9RQFbep3gvD3gmm2Q6WZo6N43R
         IEuWywlpZS3/W02PBwsvziUxI2qMGVLALkhCc2rTjxXJgUA7qb4dtxIRFiDgHJdWudXq
         okgwtsl5OdyE/04xZTl1sGCA3AYN+jTxgu7VJqBOCun+ZmqLiM8S64Qvt4v784KPNTAM
         Y4+w==
X-Forwarded-Encrypted: i=1; AL+hErFZYvS9GefaYwI4DlCmD29Xd2u8TIKxHMeQn745UWRM+xW22ukJ3gIyrgLP+gkhFZ0FirU4ZKLJ0A==@kvack.org
X-Gm-Message-State: APuU4Z8rHrpC9CPX71i3RtrIAhp4T/JygxQs4EsmBfLV++kx8n2pSekZ
	NgEQSeDpwbANKNDEbdqAyysS79VWc5zcU2MiLQgE0E//UUU5lMxosuzJ1V+U6BbluUk=
X-Gm-Gg: AZFdTZftoOXLy40qF8Fs/VhdE9Law/L59jUXxp8/9qgdcbi2oNXE60lQnnbcBG/bpd0
	WGQDjq5cSnDppPJK2T8K5ejMlEEL0bOoDUmbqVWFlrAnVXL77j5FF25eHm/y2gB9wJdzyq3Umd7
	uke6/W4c6JStrQlYw90UhIHaD5Sc3RSk3/PUSfJNkPv6Yg5Fpn2r/V6n0BcnWuSiDp/Ap77PgsO
	kefT25so0pay+lu6FGsHH9rB7o1cO/OIAisROrk5HgD38wTcyNDngPi8HGll19KuzWX9NiOwu2N
	kyn/vwR4EAO7ZZUCanoDS8GGYFGDAAf3sLDONggG4j7oPea9z8lUcP7GVMjEZok3eiSFxR0V6aC
	iAL7CVmInF8NLsYm0MwfaKK2ZE1b4oBmAXIdJSY3hjDwnRKD+VkZ8iMrvggm32RSkVujYYhexPk
	4iDArKPU64wijjSRhJH4oVApMyPBNX049Sx6IsPKl6O/Y6tTfCrkxt9jukRnz/Yer9HGfsIVLBQ
	rBTA2RKpQ/TMDX9sQGfFvXQuZs1KlEXv7eQyNq0L7iJD4u1SstOE0yZRqvPD/z9yl4daIWANg2p
	PhHN916blMiGyhTSvzOnvdzXrt0=
X-Received: by 2002:a05:6214:1d03:b0:921:4c11:f6ef with SMTP id 6a1803df08f44-9214c11f800mr175124426d6.1.1795528379371;
        Tue, 24 Nov 2026 05:52:59 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134796288sm133191406d6.6.2026.11.24.05.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 05:52:58 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVqx8-00000000QWu-1KcY;
	Tue, 24 Nov 2026 09:52:58 -0400
Date: Tue, 24 Nov 2026 09:52:58 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Guanghui Feng <guanghuifeng@linux.alibaba.com>, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: alex@shazbot.org, alifm@linux.ibm.com, ankita@nvidia.com,
	dakr@kernel.org, fengchengwen@huawei.com, kevin.tian@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mattev@meta.com,
	ritesh.list@gmail.com, xinmengs@nvidia.com
Subject: Re: [PATCH v2 2/2] vfio/pci: Align BAR mappings for huge page support
Message-ID: <20261124135258.GK9566@ziepe.ca>
References: <20261124073048.268988-1-guanghuifeng@linux.alibaba.com>
 <20261124124004.457441-1-guanghuifeng@linux.alibaba.com>
 <20261124124004.457441-3-guanghuifeng@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124124004.457441-3-guanghuifeng@linux.alibaba.com>
X-Stat-Signature: icoyyz8p6wweeodn1z7q4qxad9r9cdz7
X-Rspamd-Queue-Id: 3DBC4140007
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795528380-373456
X-HE-Meta: U2FsdGVkX1+sdAbjCkWFSUyTIAURdXfr4MQN54F8xsJO1VJ2831tJD/JjJRMYusJr/JiPn/Jv0CfQEuTBfng3CgFjlquAw9kmXqf8kX8BFuXc4JMb45jGo569qSuGf3xEaLXKw3hHbQNGuvKsous8lqdUnFEaKLq4jSngYd2aTNWXVWxSdnrmAMcKjteNtC5nAHYKUXFXs8ioH2Jk9sOZlj8/LKgJ918scyeFTCAG9VSns+Whxnh4uFRKWq9Y5MK3e92BxyFPmt1xLqnAYYru603iN0KXlv1P337pBFWb3Uew8Rs1TA/zRQB5GrXF0l0veCkmuC7+tR//HxPWicE89vKHtA62c4c2M207LemRo2MFEBBDXjQCMDs61hMN26SZguDoxa+cWbFNMm50fLuw1pj8LrZ8keAt74UEf0CjzQMkY0UYmgepuJJlsnT/mbzUThTh0aHdhJuo4PNSLfFz8uky/b8xU1Mi6MD4sq8c22Q1y0s4gCqoMtamqGRPPdct9JQq7j8IcbAZoCU8Yp5wEfn/CfgMOHfJnXDvLgsM+GrxYwMdjS5DOuJuyiQ9v20gqpZmiNz3R/FL6z67WFIrgl3oDm4lCQNtCn9/OchoTVrN6CuwstXEOvYeqaY8MxwsWLhHFrCeDltGizmuiUngTJiV5qBTWEMDLqT7vQn78caLo3qZ9+DLYviVSsXlRbyFE/Ei9qvUg/6p8vsYLC5VutGbkbS+FLpTfrlaYDo6ZH44OIhwVz5X0cp76cwG3UeYhvo/1uhxxDN55lls0uaKrgeOMr0XROa2x2/E9YBk50aTJSMDRmMH5gIp/uOWtQEwC5UA6cBrNN00FYB+rgt/aZtBXVDcoRFnkbWGz6E8LRoz37jT2jmOe9VBRi+ijue2ehL3Q/DVJBImHqFi18/fl/10ZE2zWI7kjS52O4ITFTNUUNlA7Vi89B50YpzOfdCFYupC73Qmo5v4XexVhx
 PcuuZ2Is
 fOuXfYOixI4TzlkJxsLg9ADiZJJq/uM2vzZspdG9cpzJ8wdqLviIIRyIbTOhaEunLEHrOktscVFlNvkSrvk2Y+kA6t7pdz8E4wxqq4icBmUUqh9JgSjxU31P6wqub+0OIFwvptOZsJU9rnYVdro6o4z7nksE386C3Cq9RG+1WXgIgf1mh/vCYPPLf5cejwfc+19b2z5JqiLDE0Y/ojunS1QSbsfS2b+DWFff4Z88YX06MmeKqi1eOqj1aGptJQY1XT34Qa2oiS1dgH2hFLqAn3tNkTqldYSgNDa/H3DiPU8EdYApD2tSQycdPAC6L6LKshM2HKoy0xKgjb/+/1Pfo036n9I/bqX40hobafkTvoBPC7dv1T2LxPWK/oArDkI0Bs4LVEvMzDUXtEweOIwI9o8XLzmlOOmKf8JP9Hm6ERb0jO4Qh1V5JeX20d8qgCB2oBLWK7S6LDaMwT6Hrxp/EVOlGxZLTPXn1gA56KIe28NGwYx+m1ruhc4Of3kyYg3tZXbXs6y4tfzPj32y+mdCzTA/nva4ZArUTn8Xx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 08:40:04PM +0800, Guanghui Feng wrote:
> +unsigned long vfio_pci_core_get_unmapped_area(struct vfio_device *core_vdev,
> +					      struct file *filp,
> +					      unsigned long addr,
> +					      unsigned long len,
> +					      unsigned long pgoff,
> +					      unsigned long flags)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	struct pci_dev *pdev = vdev->pdev;
> +	unsigned long align, off, off_end, off_align, len_align, addr_align;
> +	unsigned int index;
> +	u64 bar_len;
> +
> +	/* Don't interfere with explicit address requests or fixed mappings */
> +	if (addr || (flags & (MAP_FIXED | MAP_FIXED_NOREPLACE)))
> +		goto out;
> +
> +	index = pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +	if (index >= VFIO_PCI_ROM_REGION_INDEX || !vdev->bar_mmap_supported[index])
> +		goto out;
> +
> +	bar_len = pci_resource_len(pdev, index);
> +	if (!bar_len)
> +		goto out;
> +
> +	/*
> +	 * Select the largest huge page size that the BAR physical alignment,
> +	 * mapping length, and arch support can all satisfy.  Only PMD and PUD
> +	 * orders are supported by vfio_pci_vmf_insert_pfn().
> +	 */
> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) &&
> +	    bar_len >= PUD_SIZE && len >= PUD_SIZE)
> +		align = PUD_SIZE;
> +	else if (bar_len >= PMD_SIZE && len >= PMD_SIZE)
> +		align = PMD_SIZE;
> +	else
> +		goto out;
> +
> +	off = pgoff << PAGE_SHIFT;
> +	off_end = off + len;
> +	if (off_end < off)
> +		goto out;
> +	off_align = round_up(off, align);
> +
> +	/* The mapping has to span at least one fully aligned huge page */
> +	if (off_end <= off_align || off_end - off_align < align)
> +		goto out;
> +
> +	len_align = len + align;
> +	if (len_align < len)
> +		goto out;
> +
> +	/*
> +	 * Find an area that can hold the mapping plus the slack needed to
> +	 * shift it up to the next aligned address, then apply that shift.
> +	 * The shift preserves the relative alignment of the file offset,
> +	 * which is what makes the pfn alignment work out.
> +	 */
> +	addr_align = mm_get_unmapped_area(filp, addr, len_align, pgoff, flags);
> +	if (!IS_ERR_VALUE(addr_align)) {
> +		addr_align += (off - addr_align) & (align - 1);
> +		return addr_align;


PeterX was working on this previously and last time I was not excited
to see all this mm logic open coded in drivers.

I was hoping to see that the core mm could provide some helper scheme
for drivers that already know what they want to map to get a vma
alignment that is optimal for the architecutre.

Peter had a design that seemed like a good exploration at least..

Jason

