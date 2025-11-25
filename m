Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD95D0E6DE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 13:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24D166B002F; Tue, 25 Nov 2025 08:15:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224D86B0030; Tue, 25 Nov 2025 08:15:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C156B0031; Tue, 25 Nov 2025 08:15:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F166A6B002F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:15:43 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68DE11DB1A4
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:15:43 +0000 (UTC)
X-FDA: 84149176566.10.CC62848
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id A6536100019
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:15:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ndwp9VZd;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764076541; a=rsa-sha256;
	cv=none;
	b=oGqY4wc1pibtuqkCb7vDLLTRRrrj9sR1N9lktoIsssHx+8Tgi2oTohZPfUHS5UwBvrACND
	8T34B52PoT0xjwUKPnUTFAywxwBw+xJitlH9K/b14JnIi6zWUS1EJ4K94GqP5Z4Ry6LlzH
	CBiIZEnjUmDg1g3rNiExN6krJgzzKBg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ndwp9VZd;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764076541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MqJFkhl0L43eMzXGvABpyNCOBKIt0bFnkmovp+axXg=;
	b=b+bf1rbyruWsVAB6/Ap+nf0s4dBoO4NDZb3UOsNnjPTfGghyTRDfx2ySd+BrmhYLwjyFHS
	NxKKkiV1TdaNRS1+0Xu/kMK/p6A5T8DUhW7WkgUJBpjFCu67iPvvROrFOOVFWn+fO6ipCm
	n+cA27XeUzmNaLHq0XYjFdiqrsbdgIo=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8b2d32b9777so716800185a.2
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 05:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764076541; x=1764681341; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0MqJFkhl0L43eMzXGvABpyNCOBKIt0bFnkmovp+axXg=;
        b=Ndwp9VZd/knVHV0TXxeSDCmqQSgiCpxtVEw/Cuvy02x1p0dQe5Ww8jwXaUR4VEIPxT
         lMEO+8452aC1M7k92K3u4CmjH80U8gNHGn6+NfCxdS5Z9KdH4ulKof9JcqjHD8lc7A4o
         8t/SceQFl/efr0M5MuSxP6bC9UydLSl2iJX0uPp6+DBlOPRSFlR0BOAX+AZ4ArJF4Jhv
         FQHdJhwsUIWmw2GOVkfL7DIVMOCRySjuljToK5gHC4qzZbm1UkH1Fad9qNsNRaCRlESV
         A75IfsN0YayswU1VyShINeuQCZ/5B8h7LNGeLBC/WRbKLquKoiWxpn5MhGBTibrMH/jM
         xzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764076541; x=1764681341;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0MqJFkhl0L43eMzXGvABpyNCOBKIt0bFnkmovp+axXg=;
        b=NPUGLOe5U8BZeSei/4+oG3FGfpolBi0pAQCEMZzikkPOG12F1lSPoucdKEWAUIRiSJ
         /Ml8Dn5ICqDtZFC92AkqtSp+OJ0cp7wpB4JrAiAbJ/uHU70POu/8zp60rU9r7RWyCROQ
         sl/USx2r35AbtFmIh6hoNMOx51g8MoD6w4Mh0PQrCYKECXvUhHYP/bb67ALHuAWBTg7y
         KpM6VfK/NozgyIA91H+mHXu+hsxQCASaCZ6T4YGh9OyQfJxg4WtCq3tFUInW1+1CTQ+B
         ZGtNAGAvSoGOYJb7sTOKVZDJR5LDAgqctBQzWX+JkDtMgm4Mkj4DSWxoIS4sxfZdGiH0
         kMrg==
X-Gm-Message-State: AOJu0YxGCcAAhbGean6i4qxJc+6tDm77R022XPqkRS9OR4EhzZtOMeNk
	f478DkC3oyOuCKrAsCCh9S/VlfHAJqT2LrxXHWnLtSds9K70BcZWYgYeqUVgfxnid2o=
X-Gm-Gg: ASbGncsl4Rlzn21ThXxo2IqkhXsS1Hdu6G2PV3SM1I1oHlggn1AD4ffcomX8jfsQyvg
	o/qcHBe1evr2M32Mb4JpG/jXUzD8K0dpKhYn9BWCEhAemcJ0RIOCL+BSlJ628r30f33dc49nGMi
	uTWgbFHj8u5JUare/Hu0lij/iQlk77YPOMi/FnHhgdHhk3G9hfSzX46BKKDgImAkZcFwpY3L4Ko
	HkKBAwM4fdWMATPiV6TwXSIEnDBZrkxxUPq/f4YsrMdSlftZXIqydpzJ+k7ZmHn3+wSw9+Zj+2y
	3SUD3IOdXxOKRBh2Z1NRxfw3uzoelWQZaoW1TJM38yasvi2gwsTSrsKFEs6fst3Kcol5NhgVnkj
	88B2KkmC+lpzU0E1bZjxV/0/Odw68egc2uuDiEsyRROWfSF35wVGqU8h+wAsaiWIdxuYFqgAogf
	mx+rjohlIMQk6y+adAmDqB6OtiOWzs8BYbY4j5pAlWMhwuNf3/u2w5rOKgXV3h0DXm9nm8uA==
X-Google-Smtp-Source: AGHT+IGAAZOJXlHdsJDP+6wojbdyqCrS4U9S5bdS2KMveA3e8JsrsdjB2WfIHQ7wdoMRe0ws2YUr5g==
X-Received: by 2002:a05:620a:1a19:b0:8b2:7435:f5ef with SMTP id af79cd13be357-8b33d4a77eemr2077542385a.41.1764076539751;
        Tue, 25 Nov 2025 05:15:39 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b3295c32fbsm1179032985a.33.2025.11.25.05.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 05:15:39 -0800 (PST)
Date: Tue, 25 Nov 2025 08:15:37 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kernel-team@meta.com,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2] mm, hugetlb: implement movable_gigantic_pages sysctl
Message-ID: <aSWr-frCzG8_z3S3@gourry-fedora-PF4VCD3F>
References: <20251121192746.256051-1-gourry@gourry.net>
 <c309a251-5d14-49a9-a3d7-5c60d100c4eb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c309a251-5d14-49a9-a3d7-5c60d100c4eb@kernel.org>
X-Rspamd-Queue-Id: A6536100019
X-Rspamd-Server: rspam07
X-Stat-Signature: sn7agptdgf5ja4jfnacdpdszffzebtmi
X-Rspam-User: 
X-HE-Tag: 1764076541-17351
X-HE-Meta: U2FsdGVkX19/KBV6YLSRY5AWQUzrvMQhdBdwgQCiEBXi3F/NNVZzsfMx3IW0KdfbwOFU94WvVDUsjplVlS3ISzXYiQdnNs6O5AHEXADOot07aDDAHvSK7AGei7UAJs4Q34h+9PVh+OeG33aDkbS2Ag8NqvDmC3E5X9jo/ihS7Jyav/d0xZXp15ETB9qUMEgpEP74Z05i6uuyCVS73DyVB3OkqzkQJ2q2IINm1B3dkpSiSSQvEV4ugmhriK0BtAUDcq0nAA/dQnapFEyAfbDXLpE6/Bqo167ZlwYkIlgNxzWJL8vg22iHKRG/6Sp6WLHQtDQOXeMshF/E8dxZ+8YebN/bNJtdIY/U/jEMeMV1JqLJw75fEKA32miVWh/ulR1wX+XVIoS+PCeAqHrI8cJdq4xDWKt3n1uarpv0/sSkxwJqW+w+hGhNSw7tMnkMxNtqLK8jnriy9VoFR7yGCB+yUV2NzDGZ2ZMyFMXOzbKc6FqhtgInUlIOf+EBg42F0b1S2UNMOTaoSDYGZ7I8adBZ/DmXtIjWk0V5VPN0dTNarr7gfhkLMTb2JPS2W1ebAgTo10Dnj76nNwdZFw2aXkp82U0yUWbdyUuZEUR8oNL/g1UVqyUygYq+/oe1Zv4kWP7FsOOFWx72MSee3JMCZj7opMCHcMO2hbKYgpwTYBRwZYREqiG5q2+5KGruyd4jJ8gzNmReAYzF2z99qWcqBZ6OK4Kn5hyxPkHuJqSyegfgFls0kxHFSyozTjT10QRfiVS/RfhhHnxjdCMImbNwD0LqjmtBzXmKPpX5YNfQ47iHfBsyXhqvhoTzQwet9o3f8wShxUrdbx4Z8VIo9pGfOcDMADycauv6K1KfbIpwj2JA0XzAEYYb8zBfRHwXmiqVCpz2eww5WrM7mEhMrX/F2lx0+UM61eKL+IVqC6u6lHDgqONcc0pNntEPzx84kZKICeIcwMXIMGKCz8cXQld0Xen
 MlFMzrWw
 eoENLVl/K7M6Ko0vJlNE4a7BJ3W7oljQh7rjDiQnIjWcKzSDfaJ6yJg5Ydc685VvtQFK+0hQSbTNNSHlgYy4tOnHsXS2CHg4RX9dzhDzTB+Omfu3ezm56WLukACitc7gYi4SM+iuCyhWNpAaRH6wBJZW1yQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 11:24:24AM +0100, David Hildenbrand (Red Hat) wrote:
> On 11/21/25 20:27, Gregory Price wrote:
> 
> Can we also reference this parameter here from
> Documentation/admin-guide/mm/memory-hotplug.rst?
> 

Good call

> In particular, there we also talk about gigantic pages and the interaction
> with ZONE_MOVABLE:
> 
> "
> - Gigantic pages are unmovable, resulting in user space consuming a
>   lot of unmovable memory.
> 
> - Huge pages are unmovable when an architectures does not support huge
>   page migration, resulting in a similar issue as with gigantic pages.
> "
> 
> And then later, we talk about "Even with ZONE_MOVABLE, there are some corner
> cases where offlining a memory
> block might fail:" where this should be spelled out as well.
> 

I will take a look, thank you!

> -- 
> Cheers
> 
> David

