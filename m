Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AFD3CFD37A
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 10:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6925C6B0006; Tue, 25 Nov 2025 05:01:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669F96B008C; Tue, 25 Nov 2025 05:01:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6D66B0092; Tue, 25 Nov 2025 05:01:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4CFB46B0006
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 05:01:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F101E1A0705
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:01:10 +0000 (UTC)
X-FDA: 84148686300.25.3D6442E
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id 02CB0160009
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:01:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hKUXqUXP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of smostafa@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764064869; a=rsa-sha256;
	cv=none;
	b=bc8pDzC6yrSQJXPEcpEuW2lnbnK9HpEzDszBmsmzIJ7cuN0n5UMlPldR4FSJVQjbskk9Ed
	n1T12N5Bpucze1wQnCEfAOgARTVgojh5U6QbmfVLimQt9rh1Il2O01uQ2RdVZok6jxSaf/
	3nzszvXnRlmshqZq84c1abb3de08hno=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hKUXqUXP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of smostafa@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764064869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1XHwcWfbvKNkFkLxt3DIv5QKK97k3U/xNeeijWZm2Y=;
	b=IKA6b0etELG9jVSdLpoIUcqffUSaBY7/X4mVDIjZhrCydKyhWg/RW1K7WiT5h8KAV+6O4W
	i86mpddexAHZF07MY7kEtczkb4MCxp1hperYAJXD4O9tLq5w00yPu68/HheW3KWDPAMQtw
	D4O5yfE3K5aANxK1r0EGqnstaCzG9X8=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so42525e9.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764064867; x=1764669667; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B1XHwcWfbvKNkFkLxt3DIv5QKK97k3U/xNeeijWZm2Y=;
        b=hKUXqUXPfMKfzih+Etih30gZ9J2vScPBSnbAKTfyabyof93WU7S9qY3X3Bl+ybUypH
         p20j8RGbU8zq13jp6cWVl/fljI9BN33QCt7TOkQPiY2/d5Fjl+mfD4qIPIXDaNQppYhF
         Qmd+g5gcLYFr9uZe4XmtngmSgdkvOvn+3oeS5G1fAcxlL3kcpIVt/6bkm3ZUfx8Mz/UV
         pBF6KHemwrj/V4haoHmMPvAQ1ltSAOpyuNnoQeZUIUNTmSPjK8xskwlZF1aMjBuvhTC+
         nEtzoGxV5m2QjhmMxJgmDp/jikvcGeyE1AsO2dJJFmlwXvayyuGrKT9OF4MZuBZsWKJS
         71IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764064867; x=1764669667;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B1XHwcWfbvKNkFkLxt3DIv5QKK97k3U/xNeeijWZm2Y=;
        b=m1eSZeC5cMfENfajeuKGOjpZgiy2JrQA0DgVdl+I/AKRrn2uZScrs2pNfhON2qQVxl
         gsEGv81qg5G0WDZMF/UDgAesLuF/M0ZQzOiLbniHuhT6wZ7eAguwJuHQakuHpxXI2iWP
         7UKdnOs6LZF2WbIzujB/3DgZlv+3t8sGa+iIvy59YaQ7I3pSoPj1gstq2/CAG8JqSsO3
         qhV0BnrOH7nDUtQyyAkBXBxsZzRd8sGF47rB1DepwdHEyUBPpJgGiIl2jfFBkgz5T+df
         02agJRskhLA6SjyJu677Pq8ZyQeD8Gjt5EL+4cWR1eZovdwBpBqeCjtsCwpV5vxV7Pv7
         NDkg==
X-Gm-Message-State: AOJu0YxfXP41bfvZy9VP7xyAp73v8wXTk7jeUH9rA/LvcOUdznDLD9c7
	5bqcIX4VaXZqUJDGwt0d4S/hdLuOaJsqGN0tRiECMtiCvcvg78FAF7zwK/LPe9WydQ==
X-Gm-Gg: ASbGncu4tFMDz/4g84shmoHiCg8Nyp5AlQetREUzIu9WQLjXg9gp3vaXwG4dnxqX64R
	1PPWTtoyjF4Ajtw82FeQlo0tIVo1eJV577tm8LilhsLMjz+lEH5PQzs/7t428SQg/XtUqex+zy2
	q7V4xFsQp69azmaQLBVnV+lcGcvsqq1t9x2H2TvQXV14TqeAHzjBQ2e52IzAQpUgtNLHzDvBM8F
	adIEFyE2nX9q5i0QVoqXROFY3Dk88OkzsTacOYhJP46JfTR3A5dZwM9GZ4WdUZ0FTxyh497QEDr
	PPyT9wod1/oovcmi9j0ad84gWdmVndOIgohhbFY75oHtF3jV86cM3UjlDvb9AMEBdBEnWTc7fes
	w5z3oyA/AQ1NEibwhN8YoS8kUHdd4Zo8zW+dwBXVNWNxCm0ezbKfko2vycUnkf4Pj4LzRUlrwVO
	ZUWm9/fnUf/o9/0ge9nACrD5lXxqAhG9WSbdI6KOxLE/lfDfIVFrY/BP8En7IK
X-Google-Smtp-Source: AGHT+IG+KnTaq24FjuTie0tLAx5tjS9go61y7PiJSmroIbPi5FQrw77ok8WdDc8ABTUNJc0zJlZa4g==
X-Received: by 2002:a05:600c:1f90:b0:477:95a8:2565 with SMTP id 5b1f17b1804b1-47905265293mr341685e9.16.1764064867219;
        Tue, 25 Nov 2025 02:01:07 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cc231dc6esm24521687f8f.7.2025.11.25.02.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 02:01:06 -0800 (PST)
Date: Tue, 25 Nov 2025 10:01:02 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com
Subject: Re: [PATCH v3 2/4] drivers/iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
Message-ID: <aSV-Xi5uMJcMtk1b@google.com>
References: <20251124200811.2942432-1-smostafa@google.com>
 <20251124200811.2942432-3-smostafa@google.com>
 <07434771-3233-4c88-b505-ee02da72c905@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07434771-3233-4c88-b505-ee02da72c905@linux.intel.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 02CB0160009
X-Stat-Signature: 7pja7ni9gsgwnw5d81ixswaxbyne1xbd
X-Rspam-User: 
X-HE-Tag: 1764064868-347596
X-HE-Meta: U2FsdGVkX18rjIcxtoG+VTjLlSwbZQ3CAKvYsGacKR5vBjsVfDONUG4mVFn9FGybibvZDx+lbTzRm6hvISA7Z0agQabCn+iiDC7AsXTS9NggJxn6gVKypVRcfmDV19dPteyaQO/tS11I2sBTuAY8ZDX9viV9MtsWjgvyqXfXTGLZXJkLeTl847UwTaV79S2RYVvsN8aF0SH3T/dvfq1KB0CieatXgaIMdTZzTk69T686BIHPKPDL1qcs5tszccuqDN3Ix3eKRV3v9Be9jWAD/X7zHSxoa56p0mBrG/Actz9sllLiW6Fh/xSTiVqIjaOgTcsUZ3ty3/pi/wLamRnI9pCtUW9YFsG6wpEfFxzg14zqD3ZObSdyLoloviO0Ra0y/VVG7QU7ICBTtgbkSOhRwYHFYKGgxIQNV0iYX9xAENftx1pEaIKtXS2mXaTLMhiucDaVtZ3a3lLjcdwYw9Eb2sPcApp1DaoJj8ALY4i8bVIECFLLu2+TrDcX3wx544JgFKw5S06By2psruE2T811g+fUHhEuJV3nGpBQgNHesj7oucD82tm5Dg8f51yWb9i/G7XyUveCFmSoh16T0HfL2JJz4/mywUloCBfPCcfjx/djhNdV6gB1OTfIP29MSFLCCYcj3Im8vtxU97qwQj5uZft7nShobcsthPOY8TKZJD/5LY/DF0kncLPp3ocUHqWSloHmvOd8K+L2j4JIUwCqrDl53UVMGODMgrpipUDxwLo9Ttcdeas1xLF9UYYI1rXCVIKATCIsMxMDNCMpjEqpU/jCSuLSqFkM5mcMp197Vov9WjNaZVvS9s4X9cut932EJQSZ8Z0tFnQA1vw3xmb9+IRqCicIT0CXj6aYYcL8GTzIrCfjh7tDS/3+mYx4nBPyMSyZoLQLM/9W0gMNL19b2nGwHrX5wUu9NLbTMxj7WF05SHbrc9S+6dwi/AxtYq9OVcDbbu18FoDjBCVuC5L
 CQJyAVh1
 xgL91R8ioHBcviRYYkN2Q2kA+HD1S7Uq5yWRo5lxuoGPXs7Gds/y6cBvUrTfGdbfcqOp4dFjQvCGQG6vceFn0Y/uETpJHx+DTfGgDJHYAepzlswVaxAdJHu4PWsuV1eUn+6/Wm+ijGQBM8GlD0UZt+iUo2vc05k3rrdaR2Z0MH9OdNi2KZ6PJN0Hwl4s5R1G49CzAzRwjStnXLKaGJ35rT7ZtDIf49niJrxYWBvhwljsRbE2kfIgRlrptJdFNyfnO1tyrU+QXW+xK7voU3hI0Y8Vfa2e4M8tYoUoirjjCxexk7aNkPbrlX1mBdY8y0xEpuWERZPdpBZ+TdrdLTTQdF4ocVHOiE00hQR3ZOZYpb8gEiBiphMlZLtdhzM2Q43tFl1h76FokYoY4Qiq4SIglv4G+OD26K9eu767e7gQKDRCYfKNjbOfBF9brRVqXMfnlu2l9Hwo14XUmiKJ+/dMxkikNwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 03:35:08PM +0800, Baolu Lu wrote:
> On 11/25/25 04:08, Mostafa Saleh wrote:
> > Add calls for the new iommu debug config IOMMU_DEBUG_PAGEALLOC:
> > - iommu_debug_init: Enable the debug mode if configured by the user.
> > - iommu_debug_map: Track iommu pages mapped, using physical address.
> > - iommu_debug_unmap_begin: Track start of iommu unmap operation, with
> >    IOVA and size.
> > - iommu_debug_unmap_end: Track the end of unmap operation, passing the
> >    actual unmapped size versus the tracked one at unmap_begin.
> > 
> > We have to do the unmap_begin/end as once pages are unmapped we lose
> > the information of the physical address.
> > This is racy, but the API is racy by construction as it uses refcounts
> > and doesn't attempt to lock/synchronize with the IOMMU API as that will
> > be costly, meaning that possibility of false negative exists.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >   drivers/iommu/iommu-debug-pagealloc.c | 26 +++++++++++++
> >   drivers/iommu/iommu.c                 | 12 +++++-
> >   include/linux/iommu-debug-pagealloc.h | 56 +++++++++++++++++++++++++++
> >   3 files changed, 92 insertions(+), 2 deletions(-)
> > 
> 
> Remove "drivers/" from the commit title.
> 
> $ git log --oneline drivers/iommu/iommu.c

My bad, I will fix it.

> 
> [...]
> > diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
> > index 83e64d70bf6c..454303ec09c2 100644
> > --- a/include/linux/iommu-debug-pagealloc.h
> > +++ b/include/linux/iommu-debug-pagealloc.h
> > @@ -8,10 +8,66 @@
> >   #ifndef __LINUX_IOMMU_DEBUG_PAGEALLOC_H
> >   #define __LINUX_IOMMU_DEBUG_PAGEALLOC_H
> > +struct iommu_domain;
> > +
> >   #ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> > +DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
> > +
> >   extern struct page_ext_operations page_iommu_debug_ops;
> > +void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys,
> > +		       size_t size);
> > +void __iommu_debug_unmap_begin(struct iommu_domain *domain,
> > +			       unsigned long iova, size_t size);
> > +void __iommu_debug_unmap_end(struct iommu_domain *domain,
> > +			     unsigned long iova, size_t size, size_t unmapped);
> > +
> > +static inline void iommu_debug_map(struct iommu_domain *domain,
> > +				   phys_addr_t phys, size_t size)
> > +{
> > +	if (static_branch_unlikely(&iommu_debug_initialized))
> > +		__iommu_debug_map(domain, phys, size);
> > +}
> > +
> > +static inline void iommu_debug_unmap_begin(struct iommu_domain *domain,
> > +					   unsigned long iova, size_t size)
> > +{
> > +	if (static_branch_unlikely(&iommu_debug_initialized))
> > +		__iommu_debug_unmap_begin(domain, iova, size);
> > +}
> > +
> > +static inline void iommu_debug_unmap_end(struct iommu_domain *domain,
> > +					 unsigned long iova, size_t size,
> > +					 size_t unmapped)
> > +{
> > +	if (static_branch_unlikely(&iommu_debug_initialized))
> > +		__iommu_debug_unmap_end(domain, iova, size, unmapped);
> > +}
> > +
> > +void iommu_debug_init(void);
> > +
> > +#else
> > +static inline void iommu_debug_map(struct iommu_domain *domain,
> > +				   phys_addr_t phys, size_t size)
> > +{
> > +}
> > +
> > +static inline void iommu_debug_unmap_begin(struct iommu_domain *domain,
> > +					   unsigned long iova, size_t size)
> > +{
> > +}
> > +
> > +static inline void iommu_debug_unmap_end(struct iommu_domain *domain,
> > +					 unsigned long iova, size_t size,
> > +					 size_t unmapped)
> > +{
> > +}
> > +
> > +static inline void iommu_debug_init(void)
> > +{
> > +}
> 
> I suppose that all these should go to drivers/iommu/iommu-priv.h, as
> they are for use in other files inside the IOMMU subsystem.

It seemed better to have all the feature functions/declarations in one
isolated file, as it is included outside of the iommu susbsystem also.
I have no strong opinion, I can keep them in drivers/iommu/iommu-priv.h
if you think it's better. But then we will have to include also
"iommu-debug-pagealloc.h" for the static key to avoid including extra
files to linux/mm.h.

Thanks,
Mostafa

> 
> > +
> >   #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
> >   #endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
> 
> Thanks,
> baolu

