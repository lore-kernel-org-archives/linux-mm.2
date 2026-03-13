Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FBD5105F7A6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 13:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29BF56B0088; Fri, 13 Mar 2026 09:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252266B0089; Fri, 13 Mar 2026 09:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17E896B008A; Fri, 13 Mar 2026 09:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06CFD6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:20:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A7F41A0115
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:20:31 +0000 (UTC)
X-FDA: 84541099062.26.E4ECA33
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id D5D29C0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:20:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KVh7RJRk;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773408029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QtYxAWvnxsRsKhiXmWj0Ro8VXp9REalj1qqx623yKyQ=;
	b=3Y/04SEGuXhmeFY4dlhu/IEVFFDdS7ZqiEwxZSsZBO+2/PGX3veR7Xgg+9pPy8/wAdihDn
	EFsH2jqJjY3Ycv7qurGXo6WJhRuDsk+qy/HSXXFBckzml1PDC0UY2jvjUBo2JTfGvgDrfG
	qL2xGrC8ZGxDkqVWWd0yIOeeED5J6M8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KVh7RJRk;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773408029; a=rsa-sha256;
	cv=none;
	b=uohUrWf3aUQ/NpYc82Ufs1zInvs9CsEYaYv3qGBCBzTempwjqshdv/HMTLZXXWmokNtjPF
	O6MZWV9PaiuKTcFUkOtPe0w26LmERS2XMjday6wU8tIpAp4PmpDLrFDjMkgEyxpRu9Aqtr
	kMD+EVUn3I+quMAfLWkpkWt2eeJC1IA=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-829b8b6c4d0so1828518b3a.0
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773408028; x=1774012828; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QtYxAWvnxsRsKhiXmWj0Ro8VXp9REalj1qqx623yKyQ=;
        b=KVh7RJRkbUhBBBEzU9B8hSl2IqmH7/jHRa1g4OoPEbyVj7K6+Z4SSVO+AQC3ZXLccn
         B1PGrf0mC2qNJzFJrN5+9vUvZoWbQwfa+Av0uxyDN8pWGgKdGgCowpfd7z0eHpNEE7od
         Qkw3gxRAxmB7yL6HTHAf9ZW0P5oFfif8OcQp4XR2zB2grsVVpYkqZE7lO0mwVfJLAq0D
         DGNPVfHskNtRsoAHYHF8ChEok+Qs+ceWAdY1vGHKftA8EPkbDCBzQf/8JlvO4vSshDAQ
         T/xJedcbPAfNvzQ92ECAySdzUiT0ZBBWC4BDPWyp2Lxz7Qf48UzDNme8ilYpwmVtUyXp
         meQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773408028; x=1774012828;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QtYxAWvnxsRsKhiXmWj0Ro8VXp9REalj1qqx623yKyQ=;
        b=GhFD0Pdh8COOEXz0hSmTMF8/edsxeUxYkyEQvYoQhp4b54r7YeLapeJt4bgn1YfFho
         IhgqdXy+8YJo9b9q4rSpFpRg3MItoHxM8YgFUeAuKeV5J+GIuS5HuUAvvPfqeCmHyzpO
         cpQHP7CNHKx4l6glothosv0YMUm6wzYqBxENceZ443fnV2fVzYVeyrzSOB08RwMZvDt8
         DIhSsENgr+PMRaJrsJ/giqy/OfnTg9qc/Th5FxRRVOyZyLJLuPPmEwigOOznQmJibHEi
         Ta5UvOBPuuC1nY031iCXBuAUJe3lm1npEdIXtvB+UBD7hMaBKE5S0fzpMBhA4JvNL+JF
         WurA==
X-Forwarded-Encrypted: i=1; AJvYcCWmSWGqO/FVpuK70ohoyO3SetZKZgSFJZnpxeW54YhnOBpcdGarDtLYZV0Boh3JUY+s7j+rFJxoDQ==@kvack.org
X-Gm-Message-State: AOJu0YxxT0dzZYLLGM6qI9cMZuaiPYDZDQ/tWwuJiYZCy7Svpmpkg+KR
	rgzwnf0mBBI8vePSXwwNdrhIoyRfgCycoujTzN9KnW0+yc2zBCHaIc/0
X-Gm-Gg: ATEYQzwY0yE6+c4oY6lHZA/bQZi0crvHb7iyjUGsu1DJROV4sUZUxCd2ZX7f+cCr9c8
	VyI7vLf821cWvO6OMS/FIDwsOiXCpJ1xBz/56JI/nrwS6onm0+Z9R8kOl2mI7ZFQn0KbB5SrArT
	Q417K9R3pM9VVt2koo6cUAQLbskGKBgQJ41z5p87vYb+kHG0xNIIT6qjCb1yOVqbTZw9tviHiwB
	vcoowcAyDEiQ0uqvbDF2XI/6+jWI/FDv6a7CFDsxeKyEFdDFPmDQ/ErOSsA7VyAtYeuRD8JTA8i
	Jo1KfYNi1CBRc2WXznnSOi1kHKBbNdlKx5V3YSdIEnZz2NwN2Hi0BZw0AqMYLC0+qHIpSDNaKDU
	ydsDk+DoBIdm5emdF6wfjjeUIJ9tdXy8mk2/GGWCNvzolLKraa7D2I7pu0qlUn9pAP9cMMfLJjx
	a56X/+iTf2We/9Wx7vE+hAv6KeevP2Z4EjQX6AOyBxIDpX+wWelofifGdRaVU=
X-Received: by 2002:a05:6a00:3699:b0:829:72f5:29da with SMTP id d2e1a72fcca58-82a19704709mr2714792b3a.11.1773408028404;
        Fri, 13 Mar 2026 06:20:28 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a07382e6csm5967044b3a.54.2026.03.13.06.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 06:20:27 -0700 (PDT)
Date: Fri, 13 Mar 2026 21:20:22 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev, 
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RESEND RFC PATCH v3 1/2] mm/swap, PM: hibernate: fix swapoff
 race in uswsusp by getting swap reference
Message-ID: <abQMiv6Y4WEKTLng@KASONG-MC4>
References: <20260312112511.3596781-1-youngjun.park@lge.com>
 <20260312112511.3596781-2-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312112511.3596781-2-youngjun.park@lge.com>
X-Rspamd-Queue-Id: D5D29C0005
X-Stat-Signature: rx8nq31nbfhdt4eqkpxidk6db8tht76g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773408029-19705
X-HE-Meta: U2FsdGVkX1/3UZvZa5evn91j7z4EINgnJFrCw6aeu9tgg6QXFl+62qypSN7X4//QoD1xKjBW+7ZBbCSOTCmFFvEfD91s5GvXqDi/iki9oHrfAmY1wu1pZoHgMVcaFKk+okN6mRv6lKaamuYkPUKzM5atAqvLz9QYodth5sczCMRn4jHiApfuTTmz1AHjcldIMa45/bzovdNJcroGyQQ/k9a+RQsn3z8X82+rYEO/Cnvii/DcqyndvrNr8vgC2I1CtfaG68IpXy7FkGq1lVA2jL/NA7BRqtPC5qmEOmPi6s3aeZDVyGjh0bwUINwG3xkTzGMqysEyZ6skKdILN+OZtSGscgI7eUi0BMb1gC8gIeTWp1d06PcI/IJLrQnJ4p2/GwWZKQsvBtxkIn+Gr/4WcmdIHArlqGm+1LG701PBbapE0gcdaYgsdA6KFFte7hPl289QSbcrrzgAdKwH0BoiyArv5P/pU7lFuL6PISOLeGuZs+IikH/2qe7MJAXitVm5PXCoxnnnRTd1B3yCtCG8k4Cm7pzOeKxRaqgXYueDE8ONtcpt5i/Aadp1xfRoztigLMc5AFYk657PF5q6EuorX2pBlytvsehMcZ4fOZIv5Z3VsVtp7k6k11LGOUzcdypNb5dpqE3EuT1dGB/tkTDFdqqlfkjJdKW5xmGY2nCmJXtRdhKDjEYTJaxPH2Sade43xdfocEN5UZ4XSxIizuAL0JRcwjWnRYuWoR0Nk4bTSEM2FEdipwb/epsJIZrB6vqA/e23LnaEjbF42HJEmDOllD7bCvk3eP+XX5ZVwkKkAtURbjrNWdMFcHv8ulAt66A2rB7elK26+sq5X5Q3YaOB9wgvVpjELETc6SM1N4AqLtol+ZvjHkNut+O9JtLr+2ytuE2mQqEYu1ZwNCRRkI/e+1HnhlvoZs3ojrRcppoOeRu1ZgXyZm0h9es7XN4dIojjK9LlOMkDeQfwRAMMdQ3
 DASQAxXm
 /7Y5tujFf2dfwIThcDDa8cC2rtnnkcvBuz+iux+n03abdvPgIM0PeyAKFBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 08:25:10PM +0800, Youngjun Park wrote:
> Hibernation can be triggered either via the sysfs interface or via the
> uswsusp utility using /dev/snapshot ioctls.
> 
> In the case of uswsusp, the resume device is configured either by the
> boot parameter during snapshot_open() or via the SNAPSHOT_SET_SWAP_AREA
> ioctl. However, a race condition exists between setting this swap area
> and actually allocating a swap slot via the SNAPSHOT_ALLOC_SWAP_PAGE
> ioctl. For instance, if swapoff is executed and a different swap device
> is enabled during this window, an incorrect swap slot might be allocated.
> 
> Hibernation via the sysfs interface does not suffer from this race
> condition because user-space processes are frozen before proceeding,
> making it impossible to execute swapoff.
> 
> To resolve this race in uswsusp, modify swap_type_of() to properly
> acquire a reference to the swap device using get_swap_device().
> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  include/linux/swap.h |  3 ++-
>  kernel/power/swap.c  |  2 +-
>  kernel/power/user.c  | 11 ++++++++---
>  mm/swapfile.c        | 28 +++++++++++++++++++++-------
>  4 files changed, 32 insertions(+), 12 deletions(-)

Hi, YoungJun

Nice work! Thanks for improving the swap part of hibernation.

Some comments below:

> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 7a09df6977a5..ecf19a581fc7 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -433,8 +433,9 @@ static inline long get_nr_swap_pages(void)
>  }
>  
>  extern void si_swapinfo(struct sysinfo *);
> -int swap_type_of(dev_t device, sector_t offset);
> +int swap_type_of(dev_t device, sector_t offset, bool ref);
>  int find_first_swap(dev_t *device);
> +void put_swap_device_by_type(int type);
>  extern unsigned int count_swap_pages(int, int);
>  extern sector_t swapdev_block(int, pgoff_t);
>  extern int __swap_count(swp_entry_t entry);

I think the `ref` parameter here is really confusing. Maybe at lease
add some comment that some caller will block swapoff so no ref needed.

Or could we use a new helper to grab the device? Or better, is it
possible to grab the swap device then keep allocating it, instead of
check the device every time from hibernation side?

The combination of swap_type_of & put_swap_device_by_type call pair
really doesn't look good.

> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index 4401cfe26e5c..7ade4d0aa846 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -71,7 +71,7 @@ static int snapshot_open(struct inode *inode, struct file *filp)
>  	memset(&data->handle, 0, sizeof(struct snapshot_handle));
>  	if ((filp->f_flags & O_ACCMODE) == O_RDONLY) {
>  		/* Hibernating.  The image device should be accessible. */
> -		data->swap = swap_type_of(swsusp_resume_device, 0);
> +		data->swap = swap_type_of(swsusp_resume_device, 0, true);
>  		data->mode = O_RDONLY;
>  		data->free_bitmaps = false;
>  		error = pm_notifier_call_chain_robust(PM_HIBERNATION_PREPARE, PM_POST_HIBERNATION);
> @@ -90,8 +90,10 @@ static int snapshot_open(struct inode *inode, struct file *filp)
>  			data->free_bitmaps = !error;
>  		}
>  	}
> -	if (error)
> +	if (error) {
> +		put_swap_device_by_type(data->swap);
>  		hibernate_release();
> +	}
>  
>  	data->frozen = false;
>  	data->ready = false;
> @@ -115,6 +117,7 @@ static int snapshot_release(struct inode *inode, struct file *filp)
>  	data = filp->private_data;
>  	data->dev = 0;
>  	free_all_swap_pages(data->swap);
> +	put_swap_device_by_type(data->swap);
>  	if (data->frozen) {
>  		pm_restore_gfp_mask();
>  		free_basic_memory_bitmaps();
> @@ -235,11 +238,13 @@ static int snapshot_set_swap_area(struct snapshot_data *data,
>  		offset = swap_area.offset;
>  	}
>  
> +	put_swap_device_by_type(data->swap);
> +
>  	/*
>  	 * User space encodes device types as two-byte values,
>  	 * so we need to recode them
>  	 */
> -	data->swap = swap_type_of(swdev, offset);
> +	data->swap = swap_type_of(swdev, offset, true);

For example this put_swap_device_by_type followed by swap_type_of
looks very strange. I guess here you only want to get the swap type
without increasing the ref.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index d864866a35ea..5a3d5c1e1f81 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2149,7 +2149,7 @@ void swap_free_hibernation_slot(swp_entry_t entry)
>   *
>   * This is needed for the suspend to disk (aka swsusp).
>   */
> -int swap_type_of(dev_t device, sector_t offset)
> +int swap_type_of(dev_t device, sector_t offset, bool ref)
>  {
>  	int type;
>  
> @@ -2163,13 +2163,16 @@ int swap_type_of(dev_t device, sector_t offset)
>  		if (!(sis->flags & SWP_WRITEOK))
>  			continue;
>  
> -		if (device == sis->bdev->bd_dev) {
> -			struct swap_extent *se = first_se(sis);
> +		if (device != sis->bdev->bd_dev)
> +			continue;
>  
> -			if (se->start_block == offset) {
> -				spin_unlock(&swap_lock);
> -				return type;
> -			}
> +		struct swap_extent *se = first_se(sis);
> +		if (se->start_block != offset)
> +			continue;
> +
> +		if (ref && get_swap_device_info(sis)) {
> +			spin_unlock(&swap_lock);
> +			return type;

This part seems wrong, if ref == false, it never returns a usable
type value.

>  		}
>  	}
>  	spin_unlock(&swap_lock);
> @@ -2194,6 +2197,17 @@ int find_first_swap(dev_t *device)
>  	return -ENODEV;
>  }
>  
> +void put_swap_device_by_type(int type)
> +{
> +	struct swap_info_struct *sis;
> +
> +	if (type < 0 || type >= MAX_SWAPFILES)
> +		return;

Maybe we better have a WARN if type is invalid? Caller should
never do that IMO.

> +
> +	sis = swap_info[type];

We have __swap_type_to_info and swap_type_to_info since reading
swap_info have some RCU context implications (see comment in
__swap_type_to_info) and these helpers have better debug checks too.

Maybe you can just use swap_type_to_info and add a check for
type < 0 in swap_type_to_info, and WARN on NULL in
put_swap_device_by_type. How do you think?

