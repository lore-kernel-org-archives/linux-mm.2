Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5F05606A6E1
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 20:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=U2Q004YD
Received: by kanga.kvack.org (Postfix)
	id D45FC6B05B5; Fri, 20 Nov 2026 15:04:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6766B05B6; Fri, 20 Nov 2026 15:04:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5B96B05B7; Fri, 20 Nov 2026 15:04:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8061B6B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:04:22 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8E78A7487
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:04:21 +0000 (UTC)
X-FDA: 85456574322.04.332F7D7
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1977820010
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:04:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=U2Q004YD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795205060;
	b=XM+UEyXWLWY64LNC+24h0gTYBI9q0Ig6ANIP9vT+2i4CGpHnw1pfMVWDdv0I73dJyK7SkG
	dGlvrpf5iwW/aFqZSpNu//0ZsBU/XBz0Psq00WgYCt503KT3gWGTXEm2KLsbl+jrGpKcf5
	qcTaAiR70BepBCG3Fj1nEODGgaZTDsk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795205060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sbS+kHys+ZROW4VWeSHfOuIQU9MpFrnjpn+wgap+dRo=;
	b=N4r3cmWjZBl2xOfcnqgdXcCljRVYXOW6IoN9KPctZ7v/eNNHSpf9hH1EY89As/y+faDKAq
	AmJJo/3SQ0DcGjoemosvJ50HbWjazJZTeIQMjQT3eukpixRFSPxHSfQetjKMb5cLPhDPNz
	vBK45yWY3gE26NHoK4CRvxTrxR5DTes=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=U2Q004YD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=skhawaja@google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ee254f6eefso14995ad.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795205059; x=1795809859; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sbS+kHys+ZROW4VWeSHfOuIQU9MpFrnjpn+wgap+dRo=;
        b=U2Q004YDTStDSN0M8hOW9dYhhfJ7SK9VAIC0lYbYqNttvODg31niXEum3S06FV1ekZ
         WKnphCYODQKvmuBfpI0Wvdt/L2in/fH0IhDJe6UVZXVtY27GA32ZVAVlipPkK5ohGVun
         A0OZldRVBvn2Xjp5WDs/b9474aIxqvDJdOjgL9ab1kSS1q4hhFyccn10rcpZMspf1rog
         XNF4W+GIX6MgCRSbaWnAWkp9eDobtMg6YSFiTqIuX/mRj+ztyCT1yr7uqd4fj6qLb6Yu
         pnWuFtp1IwpAIN6qYyYuK2e3abeS6sJRmmNLvhuJE8BUGobGmktTts7cvbirDShi9IWJ
         x/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795205059; x=1795809859;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sbS+kHys+ZROW4VWeSHfOuIQU9MpFrnjpn+wgap+dRo=;
        b=IM+1/8jy3G2y3wLm4b0KrnDbr5c60qDMJWRaloyLVBhXGnmkrZf/q+U1417dMrEcDd
         5oBRtebfyRZV6g5FaQ0hDYh/Y9qrUpK9Y+IwnuWCBg5sHRUJLgMTUqOG5ULsh75fL6n9
         HVBFiF+fJyYHCEE1wF6JHBYwz53Pz1KpEWOXL4MHfHO7kFDWNhWNTNqU+Wvem2QGM+Fv
         Y1neWu7lylJyXGPQBFLV+wd00KloxxN/LNGjHjL4M3pVlizW4CMGbneTMubgKr7aq7a/
         CjV8g71f13DwoNs3NvY70AkPwFtIEi0+ud3AmXKQvWzEwJrztpXAyojN443yestOfDKI
         I7lw==
X-Forwarded-Encrypted: i=1; AL+hErFdLu6GtunfGRlCM5mJSRChI8z6QJZOL2aj9X4TMdao6acV86+M97l552o06WbG9881FzyLBz4w3Q==@kvack.org
X-Gm-Message-State: APuU4Z8bKK9h49pqCb+GaDpvPveCIBfuQi1/uBI4xBq3HDFWOcWGT6WW
	iLTBfaLrHBY48yi6+4/18mQvjbeJr62rb4banL+C2QViGGDrXrZbnADXM65wp38rzg==
X-Gm-Gg: AZFdTZdQu4YrGPYB2r+feHD9s0HZY2gshyBhneJBMduGThL29iN7oK/kuFEJRaBDHZ9
	C3yMPzcusU52wUKhB2iVbd8CVnaeOiy57I4WX/KEthkeSlxq4HRiY9AErSkqwBlCLKRIcWO2i+t
	5EJDv4CWWs+clOoni8AuNMYxabotCLl1135Fg4vsXJlwEFuLENPKXqu9+SMOgCPZc8ld4FSKghK
	PeK9OOAHOBHmEhaNS4eNwQmOp8ozSlm9phSxkdVEm8y9DY+Sc/UXu/RXuoFGMX7GUB6g9H4a2iy
	hmXi1FBAVm2KRB1XUHb39VcQXLN79r5WLmHSkhloanKoxm3aOPJI9/zMfD/sicKNTUN7b06Xx1L
	cuexpR3yv2aztDRnCAg1nUyWZs5KdER7L3kDOU9SvbZUI1iEwvbX2kpPRknc3RNuu+i0s86dqNj
	sqNhVV7bqVqNcvary1n+e/H21LrclHULXX227QIZhMdcWu/rEsPOm69tLcGNJWDIQzxbrhCEWlk
	J+JS6fa8N262UzZ4pubm6SncXfmca46/drCqeWg3/GmRHA5dg6ro8LzdA6ceaAanbXcya6od2Xg
	cRhmoZ45pr+rB/5VyRveq64TKX2JQ8FBBV9AscLd2nrmHKNrr4/gwIXDz+T6ObTJxtL7yCejDEY
	KlinV9eYjollQ14yiWPHUAg==
X-Received: by 2002:a17:903:1a2f:b0:2df:42af:2f9f with SMTP id d9443c01a7336-2f06244fc41mr646965ad.1.1795205058450;
        Fri, 20 Nov 2026 12:04:18 -0800 (PST)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee84294sm18409345ad.9.2026.11.20.12.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 12:04:17 -0800 (PST)
Date: Fri, 20 Nov 2026 20:04:14 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Jiahao Xu <xujiahao@cmss.chinamobile.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 2/2] iommufd: only hold references to files
 memfd_pin_folios() can pin
Message-ID: <awCntbf8pgcBZcg2@google.com>
References: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
 <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
 <20261119163531.315791-1-xujiahao@cmss.chinamobile.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261119163531.315791-1-xujiahao@cmss.chinamobile.com>
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1977820010
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: qxfinjmtymj9h9ks7jxoakf4y78phcns
X-HE-Tag: 1795205059-653949
X-HE-Meta: U2FsdGVkX1+Y6n+S6ri0A7inxeqXaC8wFiKbil0L3YosuAbkDYlzNrruOICw97fj62LXSs5NMajZlXfTqVEa21vRH0H0z0IlIKNzFX5aOe1eztAHGIYkdKj/VsDf8ANGFS0MMjMGFMDXQ8hFHpzykpMG+EPWjCmaVxHPM/Q6GVvN5ZibA89hTz/LioOjhYA81eT4IBZkuBahi3OC+OR0IGGcLC/p1Rs1q2020/RZ/nJgdXP7g+FI+sRkJ2+vch9ETjnuIu81jM1OrXDZhMNF1NorHhA9Ypvh422/XDsukVOWOuwL4833FyrmXKdA5ovRK/fxOMcO5nVXFVjm73Oyi1z1JuwmwRQhKgzkVynVaXrlRjGfELoDMBB5nTYOU8CdjmwouJ8N97SMmlKAYcLELC5R9GdbVX5z/Lef99w7W94fIsDZK2Vb/EiUc1K4IEQV+3tPUyoM7zfuVOvlzr0pdrI7hZwjAR30s4KTULr0/SdhXjZirwFhP4X/Ze1ZGr0XMnjNv6jmblAVZEypkJiOLLdM3oxGDRbHzh7Jv71fpaxHKAlZxf5Ge3huBGDQi9JzPcsh5su0TJNDFcOaGUvS/6pRtxkIpiK6ZPnxvPvd/r78ABdyTaBX3TTeeBlT9hvdnZhwpdnDE/AD40UuRsPc9RYwYfxqG4tySdyqW7b9YOztk+9jkRHAqYROqFelxYSfi7mJSbYY+WiallCNwXYIaezdp2eF+//lErA/bqwJ1rmvf+NQh/tiBPxatNXgqCiRQlSJjs57JSW3/fhYW/fRgIiA78o5hekvcM6m4VI/Nm4pEOdrcJag6IuRAh9lt3/oaUmDytszcYK9VPxWmm0ZpSyfJIdyzbrbr+2R80HzzxCf3MiCyrQFPhuFxn3U6whyGSOyluaYBIFdfv1CZYc4zIsXL7mPBOJfMonfWR3ZGrRk8CTJDU/8dp+8UUDZw/9owDTHlHPuOhP9Tt+mQLU
 JdC6A+8w
 jc3fnNTs7aM2pbw+pekYdMhr15leh/rG5jat8vbvVHfeJ/SvKX17ddl4JN8lm9Ti1CIoicgk0oTCrrNQadi6cb5PmFBsbnCYOGU0T9PKf8+70SssF3pB6Qn7ub0PEAS8m2Q72szjT7CZQTWFVeauQZD/YZX+lS282ZzUJBYcP6EQVV1akk0NIoGL8gNttGabAA7lrVpsXnTA+p5v0V8FA8N8piAhcF9RsLAavl/dnU+uTWt4oSlIuHW0/yb9yguE/Y86NdvKek2v+L1rU55WngMdoyU4TqNCpqBbFZ+BXSOr1T1s+EanwoT1tcDXI0XhU1rSzpml+Z3y67LBWuPNUc8VCn0HwzeaEDWTN42JMRvU5gOgo5C+im9X4gXlJu9cu5dH4ne3EOIWXqDyibcMCowHYqWy/3ojPp038LyNDfj8xW1g7Ad3H0/YUrHEtXHYKKkXHrKQ96qsWdPtJb7KW/g4EIS/Jg/rXj51VRvFV7vrbd4h6htON3lkYZnsegfMmm1jL1sBQiGHaxIouMmIVCte69GugvQrJVjJB1qd/Mj4qwWd2tNPoDItAwAlFsZWhFjLSnSnxrsG2RKigmD+IK8LVsUSJ4g0stN4gh9TbVzKAQMdn1uti18ie/2kU7SHYC4GWB67qIJy0nW0wv89Ne6Rt/RYmAcrySuf0WEeCZglksFTZggr2V9BhKqnf+0f0rmO7ZuQM7vkNeCFh3NxvhkXCpH0kwm8/z5yd/UjK2wg1A0AeHIZgOBtYwLVilamyTEGlRKcou/PNKzY3ByLUo5AynRg8sxyPDtJfhc3Bn2WbbR7DSxuyH8Hm311LgSKQFHfpSzWEKQ7FaJXjjdotBTiQ3PfpnWE3Dyyxi1kg9v8sF2qrzQSLxpnti3bWNV/viKl6l6moBatFuV4mzNyG3VtkaeIVudqlM4Y3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 04:35:31PM +0800, Jiahao Xu wrote:
>iopt_map_file_pages() stores a reference to the file passed to
>IOMMU_IOAS_MAP_FILE in the iopt_pages of the new mapping:
>
>	iopt_map_file_pages()
>	  iopt_alloc_file_pages()
>	    pages->file = get_file(file)
>
>iopt_release_pages() drops that reference only when the iopt_pages is
>destroyed, which for a file mapping happens while the iommufd file is
>being torn down.  Nothing restricts which file can be passed, so
>userspace can map the iommufd file itself, or a vfio device fd bound to
>the same iommufd, both of which own an iommufd_ctx reference.  The
>reference graph then contains a cycle and the file, the iopt_pages, the
>IOAS and the iommufd_ctx are all leaked; kmemleak reports it as
>"memory leak in path_openat" with the holder taken through
>iopt_map_file_pages().
>
>Reverse the test instead of trying to enumerate the files that own an
>iommufd_ctx: accept only the files that memfd_pin_folios() is able to
>pin, which is exactly the set of files the mapping can be built from.
>file_is_memfd_compatible() reports that set, so the same test can run
>here before the reference is handed to iopt_pages.  dma-bufs are
>unaffected: they are taken by the dma_buf_get() branch above and never
>reach the file branch, and iopt_pages holds the dma_buf there, not a
>struct file.
>
>Fixes: f4986a72d6e4 ("iommufd: Add IOMMU_IOAS_MAP_FILE")
>Reported-by: syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com
>Closes: https://syzkaller.appspot.com/bug?extid=7666ed2c3d42196bf7e3
>Signed-off-by: Jiahao Xu <xujiahao@cmss.chinamobile.com>
>---
>v2:
> - Call an exported mm helper instead of shmem_file(): shmem_file()
>   became an out-of-line function in mm/shmem.c that is not exported, so
>   calling it from iommufd.ko failed at modpost with "symbol 'shmem_file'
>   undefined!".  Reported by Jason Gunthorpe.
> - Use file_is_memfd_compatible(), renamed from
>   memfd_pin_folios_supported() as suggested by David Hildenbrand.
>v1: https://lore.kernel.org/all/20261119104417.459962-1-xujiahao@cmss.chinamobile.com/
>---
> drivers/iommu/iommufd/io_pagetable.c | 12 ++++++++++++
> 1 file changed, 12 insertions(+)
>
>diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
>index 5ac736cf5..c9aad275f 100644
>--- a/drivers/iommu/iommufd/io_pagetable.c
>+++ b/drivers/iommu/iommufd/io_pagetable.c
>@@ -515,6 +515,18 @@ int iopt_map_file_pages(struct iommufd_ctx *ictx, struct io_pagetable *iopt,
> 		if (!file)
> 			return -EBADF;
>
>+		/*
>+		 * iopt_pages keeps a reference to the file until the mapping is
>+		 * destroyed, so only accept the files memfd_pin_folios() is able
>+		 * to pin.  Any other fd, in particular one that itself owns an
>+		 * iommufd_ctx (iommufd, vfio, ...), would put the file into a
>+		 * reference cycle with this iommufd and never be released.
>+		 */
>+		if (!file_is_memfd_compatible(file)) {
>+			fput(file);
>+			return -EINVAL;
>+		}
>+
> 		pages = iopt_alloc_file_pages(file, start_byte, start, length,
> 					      iommu_prot & IOMMU_WRITE);
> 		fput(file);
>-- 
>2.43.0
>
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

