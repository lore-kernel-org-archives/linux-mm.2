Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D63FDEE32
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595006B0088; Thu, 23 Apr 2026 13:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546006B008A; Thu, 23 Apr 2026 13:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45BD26B008C; Thu, 23 Apr 2026 13:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 347CF6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:42:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D90501603B7
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:42:11 +0000 (UTC)
X-FDA: 84690539262.17.AE8FD71
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 16FB018000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:42:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=i7kLlABe;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q8pH7aIhkAAd4FmOdPYp3EielDOR+Hmc79iCFACzh0o=;
	b=mbLjuwJnWpKzOhc0LhonRYUhFU5xgRoyZ30CnTuk2O5XomPZ2fNnxRdV+bCQcrrVb/AZHv
	ysw6pvam2J6B5RiqS1guMHb4YJJ61Sf/w6ihnr9rvgNAe4AZ+KVjQRmnKNPcnonXFgrVlY
	7cqYZfwfsH/sINBKEm5+XV4OpSYhxb0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966130; a=rsa-sha256;
	cv=none;
	b=rtHP/v0zPP9njjXVV3iX+cm4LATs+JkxIHrDIELDdAYdylOMW2s+ZFmwB36bz15Yko5mST
	xNv4NJ0MVnpWbYtJhAtrobpT1CidjNB8JkB/fT+W0LFuQHqMg6p7KjNC7CtECsJLtU5YEP
	ExPaYNDgM5YXY1f7vpLicdjj6nweT/E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=i7kLlABe;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8a5800772f3so51112686d6.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776966129; x=1777570929; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q8pH7aIhkAAd4FmOdPYp3EielDOR+Hmc79iCFACzh0o=;
        b=i7kLlABeePbZu+L/YJyjbMDDloUr+WRKR0srW2lIxNNkUueCiM0rNmRCko6UF/DIyb
         d51RX5y2C/KbiFSGueqE7s0GLjWuZug/PnRfM3+6MRuNds22sp4FgFIXxYmRRI4UnNRS
         wHDNwlgpmTQMDLFRb67ZOw9j/GH/pRunGQUa5Th0hmReuxRL5XeWUa0PeMMw2ouuXjBY
         1crgt35cDzVVzCp+qFKTB6jMNx33hgcD/nZnQ4FhQLJHrnejJ7FGZyRiP/G5r1WYwFBK
         z+Zpz977H7om9GeYqMShoF6Kw583hNHgDpJFmqrQXby6HLyoS3FB0zcE5mLX92vAD28/
         v2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776966129; x=1777570929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q8pH7aIhkAAd4FmOdPYp3EielDOR+Hmc79iCFACzh0o=;
        b=YXbDZuGLV2IWw7ZvgAk+ubMfXlUikJ7/t1ff54CBioQdlRVwvgHp/wDwBN0+CPReN5
         0RbCCHJSGpazybMUda9n/Mk7h9cfhsXZYn3Vtvjnwx3ou8AnIX2olDsYnNvT9gGEEDZ5
         iWAzSpTpFZQlrJKB3pMlW8IqAaBxAC6URnyStRow5iW6d2ciwfhNXycrQTfyWCnCosau
         kiOTtOKSEmjF77B1ai6Rh/VXspvDgJKrEqR99o3LSf4+I2hzCOrJCXAoBE9li47NGzaS
         deDiRi2zL/8rWCEJMuj2tGPIvHu5vqfJ4gJflx8rN+v+RzEddsI3VOBObX2G2WA4vqWT
         V2oA==
X-Forwarded-Encrypted: i=1; AFNElJ/3MoxJdJeUWaMwvfQhKpHLFnX7vIGS5gBU4YRKnC3rRF2hR/K7ytEJOT8OXedBm1bLWSPA7CzufQ==@kvack.org
X-Gm-Message-State: AOJu0YwqUML/OnIx+DTEUgRV5Gc2GdH9vE822XxXXLtlGjw4UMFfnNwy
	IM+KySK73M370mE4BE4x705VGUwKMi/OhQnnpdpXNI4L2XZi7JxTB2qvp5Dc2mqC9Jg=
X-Gm-Gg: AeBDieutPQ7kBJTMKd6dnmQxSHS4CMCcuAK9XNtFD0XUa6dIPTogYSECELrsQbn522G
	pqcMjJ+2YBeriTH24po+9jzxYZbTUUqFpuQk9Zm1bBERKWZUrJDNPMRDxlF+FjWFLcldrUw9opm
	2crnvGUwHp9/I1+U2KIBsEYBRT2J7V86TqVrEWwx3q4Eg7h44NDBCy8gHvCgRTn/3UUsK3mcEwT
	QZLDDATcG528jYd+Z95k2QI1X95r+C1md9nKLCbwd6XDajcYAh0dpGj74pcMHbhMqZCAkBM07qO
	2AzAxIBFqPHZZg3VaD069Mo7iqvNCjIq2PFSb5yZYoehxgru+3Y9yGM9e3krNBORBY3OtbOEsTl
	kOU7WdS4s3k8JrozAPdS5JiK2YH5LME7u303etBnFSShe/KMmvPTpi2cXkjg/1YIBbe5Y/YIjVr
	MeDzBu5FAw85AqN4vmvXcMtvVQj66ne7nhqh89OhRAkJSW1uygIZvT0YkfVbjkcA==
X-Received: by 2002:a05:6214:8016:b0:8ac:b328:1314 with SMTP id 6a1803df08f44-8b028012885mr364606876d6.10.1776966128995;
        Thu, 23 Apr 2026 10:42:08 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ac78513sm164398756d6.19.2026.04.23.10.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 10:42:08 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:42:07 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v9 1/3] kho: fix deferred initialization of scratch areas
Message-ID: <aepZ4BAmfJ6_CtlG@plex>
References: <20260423122538.140993-1-mclapinski@google.com>
 <20260423122538.140993-2-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423122538.140993-2-mclapinski@google.com>
X-Stat-Signature: hn4yffjgisywmy6nwu8os9mk88h6gy9h
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 16FB018000A
X-Rspam-User: 
X-HE-Tag: 1776966129-480377
X-HE-Meta: U2FsdGVkX1+ELOU/TVI7L/7JOsiYyfty+rOiFi7jEHmozKFv1nI7kFflCvECSYOHy4Tg5h6GHv1vcDclrcaOeYEVSITgGipDAEXRCYnC7bhyShNOR42nPACYzjI+GlRNzwSAKCauyNp6f+l6wSo8O1zCEgMZ3+VwuerbB9dBzz8jsEAQV8eD/8GT8Mdc13r55Bl4sPdvLOssGwtdTw0Qu0Cmg/6FZ6FQtpOEu3RJAyqx9MYLl7lyACUbL0qPp6+qZ4sczJi92B+Cv2p35zPhWvYuDL4H8ECw/EqVdsXM7iajhM4H5mqmeIw1VUWrpdoNp/OW9YNRnGAfbLi6o2ED43nC5emzi4nrR9ogvHsazWR7qpP86KwWJ2O6K3tQiZUDtgKFCOaQYOKf/P13I7UzA52D6nFXXKtklrQGkWtwP+7CM30AEsAl68ZvI1iSMC00i3hfaqBgpegBkUFmiJEh7KR0HDGKO9liw+YMVtWK/8i3G7h4hqDYFqWoZF1iznq9C1mJ3wvEA6LLVr9DmBH8ZnSIYH903FhtMItjIlPN78RvfVE1nAVkBTQkCdbP1AaSQ6cUp6FPWbmgxkG+HmNC2d4PfvZysDAkkajg1x+4apd3fdo/jJ8VnNekX9durQ9lNyeSgzFZCSscuCMtf11HKKLIwNIBDAKzisSZ8rnFwzz74kRTESMnQsJ8rxWaklVbYCZp+a+k7UGCCWfx7CzM+ro5QQk6ctdpEL4YzIIR3vZSmjHzZhenn2/U04M5jRroAngDx1+8RweNvK9bQcbra9CUN7WnoQm7hvI+c7d28kQV6SkUe6t6CWudlQHxDZRavHk/QpbAVsUu7C4xsdlYnvHCj7o6ylqKsKYQwDrmWM8ITAqacRtv0LV/Mbg1BdfZklkwKrlJw0MB8aFkJxmPLyG7KsDIiV/PfATuomAO49SSzo85UWB2+D/N3hgX2aqvowKh/BcHMPkBoGRsrj7
 x+O5wbJI
 sHRV+lMAm0/bX5ltavDuT6qnoj4jVb47/yGAoitBHZLLj+70/PT5B7SUYrDLeHN3f6Bn697t90tc9yHcErW8VOo4dfQqSpCdD83t6PrgIe9lAZubPsfpTlte7ZGFDfgNvlr33co//Axi3VzyMHHZMkg3SlkpFC99BYRFQuwyGMapCaJeIkbstK5YbqOOLTIsoS1qLoJo534h5XM8UviFE6vGuiuL8gDDq+O3H5AG99/p2xiagKuEk8eMh2mjtahI+rdQNM3bD65nBAiAJQt0vk1UioPA2onhsdNFywicZItcAj/T+yGwH7vOYSyoq2q/IYb3tafjVBF+ayvaYFBfujHk5aDOQ2Swhqu68JnozQlR/d64PIPvJjfduT/w4WbIzAU1Saq/nlFVARjAmHRGRsgVMldvT32XJiWXs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-23 14:25, Michal Clapinski wrote:
> Currently, if CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled,
> kho_release_scratch() will initialize the struct pages and set migratetype
> of KHO scratch. Unless the whole scratch fits below first_deferred_pfn,
> some of that will be overwritten either by deferred_init_pages() or
> memmap_init_reserved_range().
> 
> To fix it, make memmap_init_range(), deferred_init_memmap_chunk() and
> __init_page_from_nid() recognize KHO scratch regions and set
> migratetype of pageblocks in those regions to MIGRATE_CMA.
> 
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Michal Clapinski <mclapinski@google.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

