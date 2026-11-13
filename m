Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A646F606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=OTPEMuve
Received: by kanga.kvack.org (Postfix)
	id 7A3086B063F; Thu, 12 Nov 2026 21:19:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753E56B0641; Thu, 12 Nov 2026 21:19:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643B26B0642; Thu, 12 Nov 2026 21:19:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 035F86B063F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:19:38 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92504A01F7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:19:38 +0000 (UTC)
X-FDA: 85428489636.10.A51917E
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id BEC44120005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:19:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OTPEMuve;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794536376;
	b=0t4Gk9OOxKPP8MxDPlJqZS0/80IzFzR4mxXkvVvSaAeDlLvm8szNW8y6P/wHIy6dx4Lv8O
	36ORwsfscXR3Vz5O+jO3d5D11/eSrHv9ISASlMTp1mBDLRgrUKZPqhzXi+b51RVk3APc1+
	vQbjrbi2+4EO+wmtgz1bcJDMEDvKhnM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OTPEMuve;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794536376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ebdv6ZUT/HH0C8QcvPGAmiBNBGZr0ii2abVsK2I4hFY=;
	b=ZKznCcY4WXtu0Q1JzhDV/y+J5qvYNdJ7JRham5cABVEneCyFGnSWDwKAVXkof+Y0Awi0+c
	IFN4XQICblyaDYLljAlrEN3guPLPVpIK9J8SK0r5RrWVfET1tiXmUahUsKk0yeu8A4qQIh
	dK90iPa441IXgEZF36U97iSHJFbMIvM=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-36dbde64409so773056eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794536375; x=1795141175; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ebdv6ZUT/HH0C8QcvPGAmiBNBGZr0ii2abVsK2I4hFY=;
        b=OTPEMuvep2beaEZP63Y9AhRhEwbi7SV7KimUl1CoKl/enG4FiE5XvZaMcgz90gp6XH
         WwmQylaWkEw6pmkLg6TjOIowDBNvjZcdEPTys2D7kikrToeutlGQFZXqoeHA/5j/bLxJ
         IMqSXrUhvm1tyqYglaLcHaJZPYus5O1SD8lIw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794536375; x=1795141175;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ebdv6ZUT/HH0C8QcvPGAmiBNBGZr0ii2abVsK2I4hFY=;
        b=HGf1ntWBJslZGSMn+Tivb0/KjxteGzXC3HbWjqMTzrrRl1P/d4aGvUPmvAQS/BF3uy
         VTH60wT5Loy9xkrRAwyl3NaNFOZlY1VQ/43Dmk683T6+ZSxfOiCgUe8rJkfhTMDnoF6K
         VYYdpLv1IOAdXYAtNtJWC7VFmGYPr91Scdi6ZX/JJ4/2y/EdAXjmoKeaRWFR2PpI3Tpu
         kNYqnmHcRFvZaHsnUexQWw+qStpF3+PQXV9xpewmGMuCS7K07Jb3kjLWP0Thn2Ouhkky
         BGwY9PzS4P+ZT//x9mQqzj+0WPGOJ9+8ijdU05R8MX7zs0Bno11flBujmH4g8upmddE2
         HaUQ==
X-Forwarded-Encrypted: i=1; AL+hErGtyIuArJxGZiL/OnXRKM8z7U+gtH/N2PqdcGC4tlQ6ZtYDWeMsyXIOFKnbfZVlyLzvBQF3IcMdkw==@kvack.org
X-Gm-Message-State: APuU4Z8PLlVZGHrelNheyTP//RUTtiY+S8+uChOBx8VJEYv6WVrhsj0V
	mjJEArx3NBt51h1jMHd0AIIv0FKZpgle6CGTcxT2UaVBZe13I9SUnviS9d2Yp6tQtQ==
X-Gm-Gg: AYBFou2yl1mh5chXH3kqVqcML8m8wHQnQmD8DWJuQkpZSBncjai+j6838LNCg4c6exN
	PkMbekftMATeM1Rcj5Inax8qVbi2UvDBP9AX6KhIC3EhVWJ6NX5QJwc7LbhYe/63wjwZ9V3fpHz
	1NPu8eqPdf4xK0Npm9zaNuCBWLFkRcBa9ONOv3My03g2gpm8pp2j+vl6nfhugHNff2/h6aJEWC9
	0hxZDuxSG92WJ7LhrLWvTzyY5qEY9R8BBbR7vMul2VMSs3dLOPIoTAWGYakVQf9/8DrHCdXIHZS
	SmHDlDjT2MM9JjH978eKsQbChJ6nYStYtLGs1ddoZWh5mlpOLh73ovxMsU6UEyjFhEEFLD7AEab
	089bbFF/rLF0PPCbyEJIbcaOKKzJgSAogpxEVLKLPlYEW4h3e3U097v9moo+L03NkmhJOEHUlR+
	0DcNxlWO2VcNEivoLpRIg9q8pDvW1GQxukAWZiWyA3NVvIwlcNjVoztyuYU5Bi12rE9gElZVccw
	WulouJHHRfLoUXLHMaynzzCU9ffRjDVOPEQTtU7LxKX/a0L6vcIX1dAS4ZP9D8x/7zTvJ3qD5Lm
	OmGmd8dwCr8X3/eAfBP39qE+8wsK4vjGo6Msp+V1mWow4687FIeQZzQOP+f09HUMVtTF0w==
X-Received: by 2002:a05:7022:3a03:b0:1a4:9eaa:d01d with SMTP id a92af1059eb24-1b50315d8e2mr1234175c88.45.1794536375046;
        Thu, 12 Nov 2026 18:19:35 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:3f2c:d0f6:e2f1:e609])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379565d269asm2477887eec.23.2026.11.12.18.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 18:19:31 -0800 (PST)
Date: Fri, 13 Nov 2026 11:19:23 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Alex Shi <alexs@kernel.org>, Yanteng Si <si.yanteng@linux.dev>, 
	Dongliang Mu <dzm91@hust.edu.cn>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Helen Koike <helen.fornazier@gmail.com>, Vignesh Raman <vignesh.raman@collabora.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	Nhat Pham <nphamcs@gmail.com>
Subject: Re: [PATCH v3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
Message-ID: <avZyo_hCRonuhXW6@google.com>
References: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BEC44120005
X-Stat-Signature: zjhx7thah6ci1ufbxhbyrnhr55so8bhy
X-Rspam-User: 
X-HE-Tag: 1794536376-319254
X-HE-Meta: U2FsdGVkX19hB0lCFeDvJB0rRWQn2e471OKEBqOYkMc4m4qZBXPbOOii6Nbd2h8g1MWpqfgIUpjGy6KbLFDLOLpNquwzdDX0fp4U/eRAznavfYRY7Iuw37chlZNokGdgbgKW5xQeagJxAT4uv9TPbaD859/w2dD8np3nRs8cHdF0oC+3+/kbTbJU9ynXZU6gqhbCRqiZOZKvrX65fYbeAVQSNJJ6bx6jSpN0PH3GvN3fMx3gDLWLQEpf7w9pgleZLtpDSbm+kzd0svV1rTbpz3Ft2cj+G9FL+Oc+oFCL7iK0SunxnrJQKUBp4n9RgrefSFwwmgw/UDsxW7ur7sPfWMbgej67D0f1lsGp+FAjEUsi3e+Jiw6VgJQ2ssLSYLG2B7a9K46WzIiNnZU7B5IdmuHwyPL+pTEHUujiunwPyFPVNxRAinA9jiiv3CELVl/6UQRn5kMnJ8c9ANtVGk+gcH/PQEEu6TxCuNrhYoCvWiozrb7OfOH3jTIirjyPExUL2xOqSv9Xkh+fHZ9fLszcEzIa1VnSDm6+UlyCUgdRHw/mSVeyLxNgd9rReUxp/5+nNg1j3UvftnruIdRd+xfV+cVh4djMdEnUhNekaDrJ3XRdQydwAvg63sO1mBuJ7eXL3hGBRZH3hgFKAd1yVuyWFrkDlHymJfmomR2iYDnu+stgvUc9zzsK6AD6umftJrdhXWOl+7P/JnBB7wcmrTdnA3A6XFkPV3jbjvOzAN2E77gimncQpNxLGpd7CzkVuKnVAaCrz5HrEuvibDtD7qP8dmYTA/+r1JKgZQ58mqNe5hq+BKe0lFlJCBt2KNr2shylyvdWTJ5J/vBHIyPnNeR2GIoIV05zPqHosGePbbM0PKXWmAC8E5wncwDtddV57mBv6B76qtvDc376lYaX4JjmbbrT9w1oCc8k3q1bZtP2b5TGyVnlb44OMWhbu+nmqSWHQSCXhn5X4vtYwsnBSfP
 grGDsguF
 /Wi2QvDEbiXj0bfDVsRfizix02tCtbYKDNnRUUpJl03Malx4M7fMtBm5LGoNkrvlgPbVTzJUSJnqLSCaP0mtoMr9y8Qo9SeXrLd66b5c6mZZkHpmlZHp7yL92iXw73Dd05J9RCi5RwuafGydmPKcmXWVF01U5zg8OSsYWzOPEUfhUawir+ozA6djYSKteeOT0tys1ICSidHcwZcS8ZsxlVZQ4hrlWp33aH/huPglXRkkkP26a/D5NdsULaWu6US1ZQj8KnvYzv5U0QYf87xPI0HYxjR3BZSUVq4Agv7XlDinZoCLmXKANn9OlLkV7Ndf/olo2b7Ilg6cD/RrSa0Zf+6QQ6Ntqy2VxOZ7fmf3U+HceaN64UQrr+Dz1luzOO/ezMN7WO6hDJCveyOurvotZYGwezOM251L00ijcCPZS8n+leMKz0mx9FZlXhc7uhrd3L0Un1MghJQUA/ZOrNOjRHgOJS1WabHkvxYe8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/11 20:41), Xueyuan Chen wrote:
[..]
> diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
> index d2bbecd78e14..4c0786378dc3 100644
> --- a/Documentation/mm/zsmalloc.rst
> +++ b/Documentation/mm/zsmalloc.rst
> @@ -33,8 +33,8 @@ proper handle-based APIs.
>  stat
>  ====
>  
> -With CONFIG_ZSMALLOC_STAT, we could see zsmalloc internal information via
> -``/sys/kernel/debug/zsmalloc/<user name>``. Here is a sample of stat output::
> +With CONFIG_DEBUG_FS, we could see zsmalloc internal information via
> +``/sys/kernel/debug/zsmalloc/<pool-name>``. Here is a sample of stat output::

While we are at it,
We use zramX throughout Documentation/admin-guide/blockdev/zram.rst
and in some other files as well.  So let's just replace user/pool name
with

	/sys/kernel/debug/zsmalloc/zramX/classes

Here and in the Chinese translation.

