Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0413ED66BBB
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 21:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E54F6B0089; Wed, 17 Dec 2025 16:45:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49B266B008A; Wed, 17 Dec 2025 16:45:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390B66B008C; Wed, 17 Dec 2025 16:45:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 282B26B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:45:57 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81F1FBB035
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:45:56 +0000 (UTC)
X-FDA: 84230295912.26.9DF975B
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id A9F36140010
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:45:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=tc4mYIS3;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766007954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DEWFBDgpTWFZKv5MW/dmLg7TmGtq77uIIkaqnvXKLbE=;
	b=Jhr6AdQKkHdHHcRcBjKRXa+bwHcS1eRjTHCTe5ORAJKCv7OVApDdHCNywZCVOhuoMyKPnC
	NvBCRU7a8wsckgEmkhMkGCyYqdybZEEGPMo/GYr2gW3GjcHyHLbjX3T24HGyE10j0jwh0F
	Cp0O/GdOkthOdiEgsPXRtn/w11Bx4ts=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=tc4mYIS3;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766007954; a=rsa-sha256;
	cv=none;
	b=MEdSUwT0+1viXblwvw2DkBTv3zqukUor4mxpl9NLNKOjvb4EqmVApwQJaauD97+TzPD1eP
	JlQvQcyFrvgWqzdF/D9NeZEKoOGSI1ujushoaExPvkch/Y4zySAbChYVTpnukQGvgr7qk9
	+oqlC5S0lt0LJFbSM33nOG9pwMnZ+D8=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88a2f2e5445so47594876d6.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766007954; x=1766612754; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DEWFBDgpTWFZKv5MW/dmLg7TmGtq77uIIkaqnvXKLbE=;
        b=tc4mYIS3JRxKbiOjIRT4CiYMSIo+AOwfgQbVG1gT58NlCDCh0j1ZEqmmNVGDFJ5eYJ
         abIeyXdHypq1hEJn5C5QM/g1+5/djntWv6VKBiyJobmGvBKAS7vwLqpp3dG4dyZbh2Ie
         IvysvLerYFZTD5NKxoc0LLgAc4E3+T+WTEcpFrdTFtL4S07wCcUHo3WWDGbgsb8OVKkE
         qkln4l2kwM+fjNQdJGaCdlggaOmniIFlGZeZEPkg262M2p86v/4zbyc5EO7SCrKUxnSM
         CbzGkJk8sU6MuXiYGTX5LGZnb80Aum2ZjLUuvPJJCn2qhd99JJqS4nnD0K+WgneY3Hvh
         Y0Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766007954; x=1766612754;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DEWFBDgpTWFZKv5MW/dmLg7TmGtq77uIIkaqnvXKLbE=;
        b=C1fwzxMOruXho6zfnqZSMVGbpg7e6yrNfMX9949Pqg/zvNeIo1ZWXoPd7XxuAunh5l
         Lmm1ByLXzwdTXnFbnPaHG3Hg8jV9ryQG42Fd3GYnMsE/YiFvSikVftTmyd4HKvpAWyuJ
         itNYN2uwOXWVmY1ii0ab5cIZozU2VVRMQmEWa3RA3MWSDtXth2uz/eH2Q0YfnpwRilxD
         eDmWyJy05er717h77LyEADJSutG0gD7cofF7kCgeLo/89s4u8dE83s/5ezPMavTvkzf/
         CSW6EQlPRantVv51YEVQ9uH31eayMk1cWUmAioiIBwb0EQSfGynBcZWJ0iyPYd+8KICA
         qrGA==
X-Forwarded-Encrypted: i=1; AJvYcCWgwHSq2zkEn+QBjNoFHI5VbLtoJTWBUAcf1XaGJqrd6RBrFsauf+FVv4q6dk/fBPJZeydc8VWEYw==@kvack.org
X-Gm-Message-State: AOJu0Yz6OoQm6VSlxbVxn0FJzO+gtbbD8lJHJsHo4rxCoHT0R5Q1t9j1
	0/xKDNS0rA2S7+pNf+kChLqKC033BAn8/6AM1Fl5tpO2TyeEaarqgP/+nMXSTJj048U=
X-Gm-Gg: AY/fxX6PUFt3J3Z6q+Mprx6Dq6SgOmnHQeeb9XHQCZd2JMCH28tW5Ot73DA4Aydgtcg
	oB/fIqcIirk0F4YHlmKp1rw7KZ+jC+7IBZ2LdJJ3d5DqdWuZvc8p/d3rzqioqhcsq69LZYDJL+A
	kV9VbD6OA58B9waWcqn8Tceuc7Rnj3ht/y0hggV78biNBPS4x3IZYJNO5qyhhLCAE1B1abtNKkp
	KtPtyTpuIk6BIat/ODUIWpJ2yjZDRy5L29KXg59WUgvfNszOHPyPLXr7TuQ0lHK4XvkwMR53xgV
	1auoeOy9S4F+BXvoJVPjDlz1Sssr2YCrzefzceHqA37dumxwvmpMl9mN5kf9nIC4AC8OBj1Our7
	xQ+rj0xl3snTmfflEDFPMQoDeXMLTYkKKnn6N4VUaJaAvV9TAoMKt9blqob8n6HGjthL8lraEJc
	4OhA/u+NMAq7C3QpAXv4wh
X-Google-Smtp-Source: AGHT+IEiDeODVgvUicYejjhF2iZLpk651azh1P16FItpwxPM4pdgA1TPCGdZ9Yz8otPLEoSKD5SFng==
X-Received: by 2002:a05:6214:3005:b0:87c:152c:7b25 with SMTP id 6a1803df08f44-8887dfe38cdmr293393766d6.13.1766007953662;
        Wed, 17 Dec 2025 13:45:53 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c617699c5sm3733236d6.57.2025.12.17.13.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 13:45:53 -0800 (PST)
Date: Wed, 17 Dec 2025 16:45:52 -0500
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
Subject: Re: [PATCH v2 09/28] buffer: prevent memory cgroup release in
 folio_alloc_buffers()
Message-ID: <aUMkkHrgjUOV63Xw@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <bd87d13b99c159de77f23f61c932724a8b2d000b.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd87d13b99c159de77f23f61c932724a8b2d000b.1765956025.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A9F36140010
X-Stat-Signature: c1u5g9apgzs1c817pnbbfxqso4sdjpuh
X-Rspam-User: 
X-HE-Tag: 1766007954-264736
X-HE-Meta: U2FsdGVkX19qE81MEkhqG8pcXtRuFxxom7LWYVYKBnQ9kdvNQWGKaXXBpLACeWcrQfGANV+jSGxcsNlgDkezqLYauBBh/oeeDFExfRNRHIBd2MeT7KJPpQ1zIPfFfhrng+8jS/Rrec+svN1g6JziFFmd6lI4tO5S6XMquZr4/6XxeBacQLalCXTYMBBdwEymdT88m8PdLR5A+51nhqIt9iA6mUc2b3eyJE2040Ly8FULc2TxJyYPJQc0KZzl2Me7N0wZ4pqNw24FrlmhEwq2P2J43rdWDOKoBjc/Zi8zILZ2CLtQ3EECuJ2knh721TsDB6ggGQtDC+XmUMbZ+wQ8SK4xOH1bvaaU6i+Ufj7p7bC1/oU9z6FtNjUp27Ajj2zPAdBpIawIgyMnMmXhPOZ13mbJjbni0v+9ts/DrElwlwHmLYWTdPJiofK1KCCOq1ToEHpFHlE+sBYiwYcMZ/qHpEzLNiRdfSrLhtYUrJnEcPkSKtmdtDtLY+R1+1c+2klyzdsjJoxwmHTZ0t4q0vtJuXxbPbtScYom2rBRMYGn9ytvktfrp6uFVF/hAXklHdOK7LVvRZL/ZD1VzJtkhpVH1QMFtq+hTw8qxM3U9bBSIen21Ca/BSkTvb9Ueqa1ldumkV/Q8xwF+QMP3MiKW9dartPJdBu6SAe3yV3Jguq3SziZzYSCW4SmkccUT+NzqjBGY4lb4A+Kg6X75jzWdw9/kvmPHEeJkeK47dLkwR09Ov9nsUtd672GkfOkHBdUVGMaa6BgGIyxMGv8qc32q4FG4UD9iZ92cQnLMi6o9TYL//MlChhQ9j/ossYF7WDNpktHAU6qQ2SgDsRGVxVC5FQg6Bj11pjkxQQUR+PrnsGtDQozO2gxfx4v4gqKGlu641l9NpFc6KUilz77vhcUCy9nHpGxJrPmdx2l1IeL7AiaFnsmc4NH5n9JVz5dECqxtTNq9Ci+yzFl1VojS/UVIPN
 ZB242jMI
 lvAdnhp7GAURc9LMHpFacbA82+zjxr3FbTCSnheCyRWuZ6e48bq7R/z5bEb2tecOafNfGiO6QK78otcmqfvRutNl48+o81rf+UDF3syTKlQIra9gHIStzxvl2WpIYGNxBIJwLmMsPNIgiP5FCJAWpo+OC+eNag0PMfbNODgPg+ulfLRAewWmCyXY3qs14/KnjuumEJYdxcD+49BPyWr4r+dArBGIZZsU9ECo2DOTeXcYdTqUcgOM2NibTsmyC2XCL4e9a2nyeqYMQR/+fOZf2BHLi81uIuGOIvqyt3DKMzdEP78IL7tcRGKEzwGf3jdgrzI1+kW3VrsfjGhQGFvYCx6Xs2HGC4ifB3sbm80vvS0z4Al7fwDIcZ8Ee2y063A4oCPy6Y9x1rHqaSrGsU4oEUCGRexKB13zd1FUclDLH1bwddI2S/n962wveDo++EGzzCnagM8To72en1lMppFB+dy5HpFIo/njT6vbYwwx8fDKSkIapOmTZn6G62PSzMAnkqED0pfuWv/Y1f2wA4tnB7xjEe01FVtE0+P0KCErBDRCPMIf3Who/Kd5HqhJKLiLK6eAGEGB3vIulZ608lw0qN35P0Z5cPy1U1zN2+1yZtXodiwda46WIRHr/LG50+awqszaJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:33PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the function get_mem_cgroup_from_folio() is
> employed to safeguard against the release of the memory cgroup.
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

