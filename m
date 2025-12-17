Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D159D68BC1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61F9D6B0005; Wed, 17 Dec 2025 17:14:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF356B0089; Wed, 17 Dec 2025 17:14:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1296B008A; Wed, 17 Dec 2025 17:14:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 396906B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:14:27 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA7EA1604C7
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:14:26 +0000 (UTC)
X-FDA: 84230367732.12.5A78341
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id A516180008
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:14:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="dSr/1ZEr";
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766009665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGo5RkEniLnoVlNdAAhpzsAz4q6lb7BEV8qHSPJsHsc=;
	b=qE9SILfWtPbg7G90WaL6pW0DbfF2jzW81tGriAyupSlZ4OE+Z/axHNg5zP9Qq/1zfpvkeL
	x4ZUOZmVNF7eCDHfFy+sUYvUAAeKZPkdKDMbwR0qf6OMErMo6XiSa7FdoDlkffb96rVzJY
	PAFCNv6EXiy3PnIsLb3bjLJZNj1LkdM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="dSr/1ZEr";
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766009665; a=rsa-sha256;
	cv=none;
	b=iq8JAfNv3IoF0p+3uQRQBY24RcCnEy/+9p4C6Vw4EpaORvo9nkmmZyp9Z/2xO2P1zUAFKU
	VhjWaQDHxXPIPmnpXXlRATTWFKnTZoWCgFe84+iwe1jj1MXT2dJ4b/D3HKmPkB2td7xQ9D
	tLJl4iDr+zkEGvFOpRGM2pUHYkG+5Ig=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8885aae52b1so100366d6.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766009664; x=1766614464; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aGo5RkEniLnoVlNdAAhpzsAz4q6lb7BEV8qHSPJsHsc=;
        b=dSr/1ZErcn2kGQU4XbdVWGSJyg7/SCBIkEbkG5tqUb1eboHlNUySTlEXGJOje7RkSH
         RfZWOGQI2CikAPByXtHz4TyUA49pczTGbPLFUSKZb6exvIkl6lFZIy7mPp5EvipIxMsw
         fctnFb6cTRbNk/BnVv//G2Vcm0ZN9F7QmfqtQHZdsLVIOyKg70hZFLcd+bZgt5iSXq1+
         i5H9QpcE7oshvQ54yd9KklEOKIz2QOnFw80LPgixO7HiX5ceEN64Gv7s85etiN47yYG9
         I3N70lB+OPCxeS5rH7kO79mmOOEo/5zrCSOcJWU5CwCRUqkxemVHtImIs6IGR5bvb692
         Jb9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766009664; x=1766614464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aGo5RkEniLnoVlNdAAhpzsAz4q6lb7BEV8qHSPJsHsc=;
        b=SrN7vOvbWN8FgIpWDL4HAJeNay9EL8UTEDFlzwQk7AduXtif/iNPQptr3q318E5nJG
         rL6ouK96DU8UP2XGvQyKi0t741Hw3BaTRkMeMEG1ekwcrk2KXFixk1ySDUgVGqj+Csui
         Fu15LAUBcZgesdZfqpXoTiJlP91+Kzh0ti4NLaYIkuImjXIQ1HZ9EQogvoGLQo/sD1hQ
         EkpUx0PR3xzq9PczE5PScJUdxTWDgR9CBcLF5wZhcCMHv+cSJl4RPVuEbfk/1MUG4KZD
         aYLnOQNXSiKLNis/GrK5NnxzNWiiU66P0OJnBFrYXeJCUR7dBFi5HD0Mpp5eEpNzh2q/
         Y+Vg==
X-Forwarded-Encrypted: i=1; AJvYcCULEcid09XN2WDUis86eSP3ohectvapZWBXOw6mSe5630gCnp9PA5UOjFoHi0sWRv6sWvP0V7QlaQ==@kvack.org
X-Gm-Message-State: AOJu0YxQfl+d1/7N7DBgl+QAiIMcU4+ntXlhK4XBngBtfNsM/5yfHWbc
	HBvjEljYSR0eOItJhBAgOj1wPFTIm6eFsklkxlcv300PO6r3gMF68bqP9Msgwb/XYbU=
X-Gm-Gg: AY/fxX51GqbhSJRa6WxYGUYkDCTkh7s9w7pW3Hn1xcuew70H/FAnypVPZv9mfndJCTA
	EPHkttv4TD2yKEsFPJJ4etz3APnQPxkZUVZywgaEOMHvQjNURFy/dc8jd7R0WBTBOcxNO0XbXkj
	P4yVmTv+IHvHb4wKeRzMGxrkJIFS14VCGwzR3CBfIVvPd7yCcdHC7FkkZQqLx8M8ko9i1CrGAMU
	veazPsBp2M5py7S5ybyr/0aAHtAcsqepH9VtklZ2cJfA5zFHe97zb3iEfIE/cEwrAHz/Z7uB8+9
	2YTcdW8zJ3AUKI3cgRzZTjrdjYfbcJDb/C2u2ZWaorLifiwYK1qgSZIkSs1kayIQhNFIHZqgXpW
	jhCZ8sKNE8s1e5GJpF6CcPEf3d+oS7bvfA5hhEJHkdhHLtznHsPujiFjvn6Klj5122D+J0EjCOO
	sQrfuaSYW3Uw==
X-Google-Smtp-Source: AGHT+IFS0hMSIg8OqTULT2EjwaYx5tVuyqOEnUFZpUlrOcjLRS7kG+GrEOBoyYRa59p6kqOffpjgmQ==
X-Received: by 2002:a05:6214:3d9f:b0:88a:2fd1:b582 with SMTP id 6a1803df08f44-88a2fd1ba98mr210156126d6.47.1766009663688;
        Wed, 17 Dec 2025 14:14:23 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c6089a7c3sm4446836d6.27.2025.12.17.14.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 14:14:23 -0800 (PST)
Date: Wed, 17 Dec 2025 17:14:22 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 13/28] mm: migrate: prevent memory cgroup release in
 folio_migrate_mapping()
Message-ID: <aUMrPm-ylp-6_xNg@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A516180008
X-Stat-Signature: gh5nc3s6saxep14ffxo1rxnf8nhse3ge
X-Rspam-User: 
X-HE-Tag: 1766009664-88357
X-HE-Meta: U2FsdGVkX19HAIrZ4hqI2f+61bjHhSMFqGa2sAH3nww520X4Ype4Au/humtd+8BDMneVg8rHEcTtj0PsqKrQhkUsonuvsi90tREpITvZaV2Dwi9Yg8U9CsIvfmwjxbhbwhoYrdyl37h2h7LNdsuH0PRGhJbxKpsaI2PP1hC1MNq7QrQakOp//cTJZ260L8O3HoKeKoRJFYNYHC6UQ4YsCs92jTcQdAjA8fBwm6KlFRjAKd0ScxlfFzNfZVZ3E8ws506mnMURrdcU6i4MSUxCy5k/DdC4uBUe6uZyX1osGBCdFlKBgmbSIV4z1Hqw/rKOsy6iGFeDxIYxtnCKudIky6DHcPKQSuVKHlTyEl5+REhlQhlnZN406tEpS7xgAlyPY7ltOXfEyGzcuaNqkbhsuzJMcQiY3h2VFckr116K7ca0crHGruJHklhfoFfGGuIKnqwL6k9yJV/6gGrxWS/RpWlzQuN0iF6SQoJq/9PRUiXGx0EoUBgjubXDLlqxh9/VgZqq1N5CBjlVdKJr/WrX6XOTjwpCLlQvTFwU8OnMOEQQrow5Ft3tqYO4uOJJzb6IgXkmH0wgmfWlcw7p5BSoubpIUM5cZyr5geGpm/tfO5LCa6DIHgxFikFoQX9acapytSnPRrN4fFAvX0GDDiU7fYAGk+0rWBGJWJCVoSFzr90Awkte+mLwQi10nkMecTh37q7Nc4BJXNe4+6qG5H22aD8idl92NjmyGL00S0c0CZduEToJgC+xvlbwVeFVpecDhzHzmNdjNEKrGj3LVI1TKQbcSF/rK73EmMMguZLXNTh7oeyqmbYGCUlAJ1HvvkiutKiWJFh3RwW6t3t8wlx/YhDwfSYxecEFIPXUuOrT/q0NvjYhv1n7Ti6lG3c/rpnONNaYYOYuwmRZuPErIhc8jVfXOQqkNRYkpo9+PaVboP3GzxeUMdoG4vl8aSrnYJs9BA44L8rfRgXDpBXEj2/
 F02VssMb
 qLdTjh+dWT9Tts7aGEwB+xSQA0jVmQ/u+B+0mH5AVDFHBdy6PsXscWTqpz5RXfY8/t/hfyw3/mz9J85fpfrIOTRVtvrkVL0kyiRZbLEKUl+QHJlO6XLTwq0pslbbIvL8PlZfmYnHff0m5bK8YnrSw8cnCkPt0VMjVI55eY/dLAlcvI2SjdV9PNhvTWvvx3TGvLJ6YpOF0b6lDaD1DyiXNatmxi0RTZ+6OuzRTBksBn1/xiA5RRA1rUNEwAE4Wd+u85MBTVciastpXW0VjMFtRr2yQZFPiqkhAOhpuQ0YI7tUp+yER7ATQAwHWMrvbJpYFXzddkFvElla8PO6DCavGXPlRSA4IEcpC3v6r+ijUd/opuBsez6kuMA3Kpyd6rUpwfPeBt1Oh1QfYvN87J+FGMF9XNXeA/QZCs7tS0vFZz/ouFE/N1a+dalUOS4DU3RCYVLyDkZd5ojsqqjgROggS/E1qGORm355r3nin8tkO3UgUXYHTEjLqGHIma9CTS0B5mKn5T6wlGA4/5JPe7BZ3fOaKOj6cKRvOmSr/Hrj2iggNluo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:37PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in folio_migrate_mapping().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

