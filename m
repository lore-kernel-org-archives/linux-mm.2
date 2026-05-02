Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91DD4CD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 15:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 866CE6B0005; Sat,  2 May 2026 11:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818046B008A; Sat,  2 May 2026 11:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D6E6B008C; Sat,  2 May 2026 11:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 643B26B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 11:49:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0510EA02AB
	for <linux-mm@kvack.org>; Sat,  2 May 2026 15:49:57 +0000 (UTC)
X-FDA: 84722915676.24.76304B6
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id ED47B40002
	for <linux-mm@kvack.org>; Sat,  2 May 2026 15:49:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="gPyf/dfJ";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777736996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SVqOlMyjv782QwH3r0yX+YLQuP1ZcJqdDcRKQWrk33I=;
	b=pQsYv3QaAX3xPUEeEVPXgUF1rGRmsIASaVzjB/uXj9oK7Wesj85Z5omifgoE2asEBkVoum
	p69I8EPbMz/6NQzB/XA8RyEQwxttAObaPDne9fAapVhD7aJ2qUqiVgR/RKqN75Ky2vEqe+
	Kj6cUQDNGv1140unPHStcNfcZ9pDtyM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777736996; a=rsa-sha256;
	cv=none;
	b=vWhmGq+jzSAQwehdekb2FEDH0QzBiNSmGjVCqEFZPojdUtvSHUJJikyEDe72Piq2pIxxB6
	WyGKYHSJZ7Kdfm12ifjeKzGn9YD6j1xxi5OzD1giOxLR8HnC/Ag7gg8+83mjslIRdmE7Hw
	A4vnnq82U/7A/FeEcUzQyguDgue9kRE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="gPyf/dfJ";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48a7fe4f40bso27845055e9.0
        for <linux-mm@kvack.org>; Sat, 02 May 2026 08:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777736994; x=1778341794; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SVqOlMyjv782QwH3r0yX+YLQuP1ZcJqdDcRKQWrk33I=;
        b=gPyf/dfJ62gxEZQExsW++dhrh86Wl8rYiWUfzTkKquUZ5j5D+bT5wq1MIO53w1HtYY
         H6EpxMnQlOpgSe8t0mmlXzj1TFAy6M3o8VZWZ7cDwENU3bGdN5ztymB42lLurq5pFuDX
         aGqvoDSse+ceSl0XT5lqkl+myu47FoYv1nSCQqkdrnIZ0o/QbbuJe22DKv/iqGtv2+8K
         UIjsa3stYj6PFghDYl/Yhtvp9GAPFMVPE1JSUDnx/ChIK8o1lzHQEvVN/RJJ+OJTIAER
         voRqYbXAfH9dxyxgJbs2kksHj8zDThKlIrplKDBOS/GMcbVgDz9pV6SE6j0sdawpd/VU
         IJFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777736994; x=1778341794;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SVqOlMyjv782QwH3r0yX+YLQuP1ZcJqdDcRKQWrk33I=;
        b=ML1I8gl69cXsUOHwifxGj28sYPPioJuyp0s215FKHvEIfxl7fLKa6mfuEzp5w56Vde
         4usX/b35tHOFrL+ZopBVZPUi8o41qn3pxS92iZzjryHpAqRr7ERMDAYqV6YTYZSvW5pk
         SEaD39T0zCfjNKSZS0Nog2XS54ug7Zg6zmD8mZCdR3dg1Y1nLj7dKAWiMnupGXZltwhZ
         PG+GasMrv13EBnNqBh2c3V7FChdNjPpnT6+A92GwvjEe9/aYRK1Xvy7i4JNOMs/6tkFw
         3ObC2R+jAzIjMLnx4WtaYslEPT685JAsH3DYLEdBNBsMk5dvXfR07Bs+SePpmESgBLNl
         HWVg==
X-Forwarded-Encrypted: i=1; AFNElJ/jjf2yhCQXfPuRNwxp5g6Lybt6RC6gPpGkCQuGNLMq4ILkSJLSMvA+rb4BcB/6ZZfXbbCU0IGxhw==@kvack.org
X-Gm-Message-State: AOJu0YyRgWM0WnSzrKn2iAk3aaB4Hmjc2dETj6zuHg0EdNZgy0ukDn5x
	+rZ9pWv4csdGwLPndxgHvJ6Smx4vHMVMabXN/VU1cb2oVHmIQ+fnbCzvdbwJo8LkNrY=
X-Gm-Gg: AeBDieuqlCKma9znFg8EyX+yxdBlVAdUhKd9D/Oh+shIJlPA96a2ysAllVnJwuNvhUv
	PjoF9be6vk755Y3JQf/2XKBXCkIKouK2tBqs2hrOd+aLwvaxTzXdLR8mHchfEwoI3anl9thDtTt
	ep4tQbuOATlMftKKqDgI+kYt/XQg80h4CAzS8GagoC7KH+AczaSjt+yRAp0GKllZLAp95g+THbv
	WxdJRhHxLaFLlIagA5LVszyy3tCisRY8UfcGawURK7FmpdIhbpWlwsy2aFpUxcZ16NRQbefK4RS
	zle/dF0Lx9siJ6eFflZ8ChHbQOiHk44Lj8LXHiBvRo4h7K+WGev/9IwjSAInMlI0QYYzgzv2BCw
	7yM4EKkvykQizrvEdnaNV7L20tA2/YIpiz94ln/LSfyOAn8dsrlWGtRIz5MFAwqHC9KW5xdE11p
	yxWV1zS56wryZRzqWpuqlfWOa7sjt3JQtCHp7XVluQG+0/
X-Received: by 2002:a05:600c:c0c5:b0:48a:72ab:f88c with SMTP id 5b1f17b1804b1-48a9865f865mr38957905e9.17.1777736994019;
        Sat, 02 May 2026 08:49:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([213.122.39.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a820c865esm190089655e9.5.2026.05.02.08.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2026 08:49:53 -0700 (PDT)
Date: Sat, 2 May 2026 16:49:51 +0100
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	lsf-pc <lsf-pc@lists.linux-foundation.org>,
	Bharata B Rao <bharata@amd.com>, Donet Tom <donettom@linux.ibm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [LSF/MM/BPF BoF Session] Numa-Aware Placement for Page Cache
 Pages
Message-ID: <afYdH4Alu9QA18CO@gourry-fedora-PF4VCD3F>
References: <h5ossmwe.ritesh.list@gmail.com>
 <afNV5wbhsFQJLzxi@casper.infradead.org>
 <afYQz3YJdWB2R-1q@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afYQz3YJdWB2R-1q@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED47B40002
X-Stat-Signature: kur5h55krxk8q5c8iateuo1yj7cijt87
X-Rspam-User: 
X-HE-Tag: 1777736995-266774
X-HE-Meta: U2FsdGVkX19C30ewA+oCbGJtPd3BUxQbhBtPKni33N/re+jY8jQhJ10xgSu/J7mdoNXsPi93whMzV96OynDx0jaKSUO1a2M4WWYREUjR3YTHdNUlf1inW8gPhJLoL33V7xsZ6clF60oZ3zICbM8eQrYVAi918YIyVlMMFyXif6ksiw18Zo628mvq9H31Qff+zWuvz7InAE1aX+g2DZY3UN603PAyav9lEJlbU3gizNXDZmFohPdfJ2VAVbV6ENpI22ufX25kjXw+A42aYuPyNrV+tbieXPP95AN9VL5Wg6tQWQIp7Vb3l6+zPphZtn3ugRqVDtQ2LgZ/hCK4crik7+9cooLNuUhEXCoLSxfS7tPmEL1aJEdYXxL+Zg0qESvt4PGfVMGAsrwkYEGGogCPHNaczVcd/cpT2ww1L7hh21q2rf/kAAbHYyXCbuYQad7nh36JwsinrDsw+dhzFy2kRd9NAa7bKNlamY3P9QWPEj2xXWCASN9bZeFBeaPF772dT09clZD5pg2/rDWSNNfQA83waRknBhy/hoGSvnI9qBiuYRaqRYaiUWZ95YkK/6qQmooOV9vbtEY0VPCFIAXSn8JsK6U8+1VvKHRf9+wzJXikHDIWc1CyQUbUXOdbDRPT1Nb92qCFsTprJmYKKrOCf6usH1nZLA/qbRAD2iDCU5ifeBWnyMJQG3tBhCl6910Bm9/nk30195ONdHmM7pqO9udrpBRNOBTAb5L/PgCx6lNHZrepMKzzr/4RT9VKrgMUA6SBIhWy+avE25e/HWPkGTaJy+8xS6H/n8CRSxbyhgHznxRSiQiUk8sImEdiVFkV8Lw6wiGxKafyL7HQ55T1FHPKrJiJfyeAb3RHfKmYFVsnqE/3au9CQexaQmFY8Vftv2GwNnryloZUk/qzHZT41IaIMZlJkU/DqlpCMrbnlaMR+movVPrAzkOf8Hf1XJezFpq9kPYjy+FT02DMnXH
 gzXfY6Ff
 LRKpekbvr9EyaJrDb92zYK7hY9hiVkOfcKfIz7AHfhvuHGhvB6/xS3G9ROSOmepEEDbVYsBnCzcxihbQM5RmWUz22WsFNNO2vo+Ao7yd5N8ryjLP6mtJrxx8lN7VpN7FgHepoEQWlFFbD5hxs+0MKJgjVSKodJxdaYZxgcunFWqvRiLiQYCZSBCYyEGG9l/Et8NLdyzsR8QtOgTbxtOyFNkSsO391xD+aH4QOBoy07tUTiIG9r6J0l4fxOVcJyaNie6fRVxxTqOxj0w3GHwNhbHdc6nNnaNm+ahwXbmYniAICWV6oc7eqmRh6IA75ZpVXBWfGNIZYYZZEHdCF2TDq5pV0lohjAAfHnKy/Auk2W7SXx6fiqCQBlV0qTziJW4zRnuWKSv5OVuz7M0o/w6Jll7yP8223+CmFD/LzWhXN0CZr82yWqnyPGG/81UKiNRuFuW7AeyNP9hH0fRve+my50Jq1KtSxyvUP0S4N6d2cyCvJntY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 02, 2026 at 03:57:19PM +0100, Gregory Price wrote:
> On Thu, Apr 30, 2026 at 02:15:19PM +0100, Matthew Wilcox wrote:
> 
> fd = open()
> buf = mmap(fd, ...)
> mbind(buf, device_node)
> /* fault file pages directly onto device memory */
>

maybe more explicitly, something like this

fcntl(fd, F_SET_FILE_NUMA_NODE, gpu_nid); /* pref node */
mbind(addr, size, MPOL_BIND, ..., MOVE_ALL); /* move existing */
madvise(addr, size, MADV_POPULATE_READ); /* fault the rest */

