Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AFD3FCA16D
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 18:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94A516B0005; Mon,  9 Mar 2026 14:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8006B0089; Mon,  9 Mar 2026 14:04:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D02F6B008A; Mon,  9 Mar 2026 14:04:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD496B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:04:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E70FC1A0300
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 18:04:49 +0000 (UTC)
X-FDA: 84527300298.04.7CE6863
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 12D544000B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 18:04:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gTcYTgfA;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773079488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnsZoTHqPlFZnEEzFa42610iNi8wbEfxZ1jSz4BbHMo=;
	b=J0wsGfdKt0me4ISYHPcyMCy82TM5zZxQz661NrbWg073iqksfx54ACEeixOmJu7+SlQy7n
	1wOMGC7LwQ2TXysi3xAO4kGWbpm946O/HJOVFeIieOl4NX49SumLOwLWxSlZhg/FrBXjBQ
	+Do+zT/ceI1xkI0bv4KwyaPFh1PkMU0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gTcYTgfA;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773079488; a=rsa-sha256;
	cv=none;
	b=bnIoJiS3IOJBg61t7XbVRRp9mp+c87oWRNiMSUV/m1r1i3IiRrozwqts4poxe4TvJqU6Gy
	L1EWuQ41mzmVJebzpCQyXhcLpurZI64GLqLW/nyYZ4V60jZlNgoo930MVsl8/VVuyB/VVs
	E1MZQhWYf8zFhbmGUQ5d/0ORJwypaB4=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8cd751a4e93so163480285a.0
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 11:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1773079487; x=1773684287; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EnsZoTHqPlFZnEEzFa42610iNi8wbEfxZ1jSz4BbHMo=;
        b=gTcYTgfAasvLBv/0iLrVWk31AJRw5WQQswG4B1KQDbfiyFi0oGbEDokHAm40NvaXHa
         cdEObq8ovACnc5b8oX+CPjz6lqYgHg4pzJyO5qbcCEX1BSxvV4Z/nsyxmMR5poaUTzQv
         RPocrsqg8OQv+QwDutN5zFMNxNMk/hX5u4Oy0xC/rdv4szRnC15dajNF6rQVLl+6/R1x
         givtBHAxNgmBGc8+C6Hn9bGzSeQqi9AI85Pfw2kg/FrWuu2D+ryYyAWZ6ROwPQobDcxs
         hlwO9hZvfvHcrIoudKyXHV8axIwFGtZABc5AAsExySVBy8b7h2C5WZ0hK530IeFe1iGa
         0Mpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773079487; x=1773684287;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EnsZoTHqPlFZnEEzFa42610iNi8wbEfxZ1jSz4BbHMo=;
        b=qcQV0w8YFBffIKMBHF8Qe5Hbn8qYTUZeC+PytI/jyv1/sABmqW7fUAHPc//MSAs0gr
         HCROCZgi6vt6Dit4RVQHoQfpk8MzkK6PRZOl1PLebGEy8WtS4xyoqoreyCM5mpITgmpz
         i2mMLpiHezNhbMSgw1xSfPhF8JkqzihbEiJz7yhCqaF6sPWBq4eTLJQ8ROhcVAlsvoF3
         TZRG41xJ+/ZL1l4X4Ez0OwQyhbvgkFRVGCHEA/SoqYFYdcoK+PVpk14DAZmMi9AD55RR
         34XWOsraviqWtC2hPIMqXTd4RyGc7ltbScrHHT7mDdfJSG5fT5ShC5Ei4GfvX/ynTR1N
         NS9g==
X-Forwarded-Encrypted: i=1; AJvYcCUzhS/OuLhutENPf8SZdbtrll1v7w57ioRQnqCQtwyyuddutxSkWQrGlHVol9ZiAkRPbqqXR6s6Ow==@kvack.org
X-Gm-Message-State: AOJu0Yzxgx3sIlGnfugyIopgwwZLd2jHiBoISPKLqc2/BK5THHwZx5Yo
	kTWCTCRqGhEpQt1ZjhDjZPmEWNIgzj1LKioZamwAcIuABkImeWtp2QZL6tmdqhvIq/A=
X-Gm-Gg: ATEYQzzVrf16V+myHyQUyKloOzBr0LmuvbFBXcaTjdJq2fUByTSOpHRZtgd5oH42Ilp
	HMgQXU/gulOdte8Olwv6WdYiBajKmCwr4UiXsCqmRuHf7QK6TbC7coGQf+B+r2kSjjvyt3UvcIg
	sdzF8CCCzKr3CcQ7X14sWqMTsr1ZMULQb+cJ33JN+o/F2oWtIbL7SgJvuNix2/SxgF/oJJQvco7
	qPxECKDQ4dQVoy71CvQgEamrIQWuo54Hw64iL+9TJOiiUVQDKMaRbgAqLR7/dQYPAhwMXoHAWgL
	O5jmMz4UxsciVw2kDEIDPdubV+EkyIKgkNtHNY/A4/UPZwenCzTcxAeaGBzskJlZBhW+A9mmA5T
	s9Z6PPWteWPyVVnuQpyl6GRa6XXGYV7+i/Ss9V05J0yBM7np5aMqhHLTIOK06VOcg+oHeRkKAL2
	OFim/s+Izw3fw8wpiR1m/8Ax0vK49o0NcKHO4de7/hgGx9kFPYEhhDd7zGGuND+RlWHB2YrvpO2
	rVHH7YG1g==
X-Received: by 2002:a05:620a:3911:b0:8c0:af6c:fdfa with SMTP id af79cd13be357-8cd6d322a40mr1382538085a.3.1773079486979;
        Mon, 09 Mar 2026 11:04:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd81aa2eefsm376234385a.42.2026.03.09.11.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 11:04:46 -0700 (PDT)
Date: Mon, 9 Mar 2026 14:04:44 -0400
From: Gregory Price <gourry@gourry.net>
To: Shivank Garg <shivankg@amd.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	dave@stgolabs.net, Jonathan.Cameron@huawei.com, rkodsara@amd.com,
	vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
	weixugc@google.com, dan.j.williams@intel.com, rientjes@google.com,
	xuezhengchu@huawei.com, yiannis@zptcorp.com, dave.hansen@intel.com,
	hannes@cmpxchg.org, jhubbard@nvidia.com, peterx@redhat.com,
	riel@surriel.com, shakeel.butt@linux.dev, stalexan@redhat.com,
	tj@kernel.org, nifan.cxl@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v4 5/6] drivers/migrate_offload: add DMA batch copy
 driver (dcbm)
Message-ID: <aa8LvK8COQwFuAeg@gourry-fedora-PF4VCD3F>
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-14-shivankg@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309120725.308854-14-shivankg@amd.com>
X-Rspamd-Queue-Id: 12D544000B
X-Stat-Signature: i14smpcy8bh4gdn8rxdr8u747ya9irdr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773079487-198936
X-HE-Meta: U2FsdGVkX1/qfcvMnFzQB3NK8EoOmzQlT8MUahxEQWNEyczWvkysBjl6X3qrs74pvAAyuG+kgFHN/xwYrvGYCSwMtfdCST7V0aLPr6wjfWpfxVoOW/BWVDUTVSaROOf8yguclY41alwpOZiyHAkckhHttIlnTBWxhL8CAQE7eTX8aLqJFTuBDl1xWZYp5myE/AeL92R6HNscaR7uxPLSuNjWBDbClUkiQOv/OLtDCNWmmlLnuqk5OmG89BKWpqka/R26yNELAI1ja0c+p1P0/Mc8+e193bXU6rhLS5Kzv8D6eMHYF9W4RdozvoT/M/UeE/UmDDs3sQ8qcdfdETOoyYKnlJTPrQq3ZLcRMc6rHFCzaexKiqQFQ97NWjpyw/FTmdKS2pJs2ql1FKK9bMSBOGMqpBdmQpUe8cGZL6vEgLKxhbNsZMHO8ROV+G3zLTXzci0DaIdwfKva+TyXGGOMyKxFzbeYxCOUALJNVn7p8FL6CiK9TQO412RUrpZ+Agfs+FqYw+p+iKh8R+Wor7AwFnxmNPuzPKuou7SsIydIPBKKFpZzFjFv46cWjlvB/wUp/Eaf9LZYpohekejbx4XLbcLSFgkZulA2AutGEQcJNV0/az7cRPXvrmf7FeRFBRW5wier/QSf4U9W6pc5iF8TzSh4HE2nO3l2vZutpSFpUAt221s+0fxH5i25Kj5MmFS0ECch5W4qBB/hkZXSuYpmgEUwhsVEBLCkpjl72VkdRie5lCKsMPEbPXX6qcxezX+mNiYJbwACVA4/L1ICUV9UFtVNCv5CWrl5DcLxHk9ieGsaB1nR335xUVz1ziAsUDna0/gVQyAAEsZVG5pR92esrJhYsWXuO2ZZDHHGE7mdnsyEeXYY//krvYTXJeodnTi4c91t2/iVKjskQ0L3PEWnLwmxFVe8exa+V2mBHXAHF8MqmwMtIZbY8sgk8la0bjS5ao1ulUTxw66EdY9NMat
 SIHp6mGa
 R8aZB4pNZ72Wulk8lrI+WPv3PPRY8ycLehYYZvTdy4x5G8zNkxV10nv2FiSEjEDRrHtOCJaBmBJTc7m/L81Dx49DPg9+tBwIGFufRgysbdoi9NBxzalFEZ4OocVs4R8PWOehE9h1okFa5ybpPjhB/FWxszzZ0IO4v+A42QcKiUMWw0Pia6V4QGTxwPLVMFdits/uqdX9SExMimPlZPRr4ZefbKfDG0WROVYwgt2FzXQ2GIS4rAOqQX3TcOZZz7YVCfTlSr0d33QBLQ8y6X40S01R+0qIeq4O5pTqxsgzPvYFdynSWJtYnklT3IuRMdU2w0YTlrIpMALa4p8I7a0KBRBmJ4sZBQplhku8qTJ+Fr4nhAjP9zxx2IlyYSrl8561E6iuO1AV+0KooUPh0vrv+Ck39zyGxex68OOsJhxl7O3o/VUpRFq6buahpFYOg38weZxQA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 12:07:31PM +0000, Shivank Garg wrote:
> diff --git a/drivers/migrate_offload/Kconfig b/drivers/migrate_offload/Kconfig
> new file mode 100644
> index 000000000000..0bbaedbae4ad
> --- /dev/null
> +++ b/drivers/migrate_offload/Kconfig
> @@ -0,0 +1,8 @@
> +config DCBM_DMA
> +	bool "DMA Core Batch Migrator"

Should this be tri-state or is built-in the only valid state?

> +static int setup_sg_tables(struct dma_work *work, struct list_head **src_pos,
> +		struct list_head **dst_pos, int nr)
> +{
... snip ..
> +	dev = dmaengine_get_dma_device(work->chan);
> +	if (!dev) {
> +		ret = -ENODEV;
> +		goto err_free_dst_table;
> +	}
> +	ret = dma_map_sgtable(dev, work->src_sgt, DMA_TO_DEVICE,
> +			DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
> +	if (ret)
> +		goto err_free_dst_table;
> +	ret = dma_map_sgtable(dev, work->dst_sgt, DMA_FROM_DEVICE,
> +			DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
> +	if (ret)
> +		goto err_unmap_src;
> +
> +	if (work->src_sgt->nents != work->dst_sgt->nents) {
> +		ret = -EINVAL;
> +		goto err_unmap_dst;
> +	}

Fairly new to dma space, but I thought the dma stuff could merge pages
on iommu systems. Wouldn't this check hit fairly often?

~Gregory

