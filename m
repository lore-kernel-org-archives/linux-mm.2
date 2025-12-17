Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF6E6D68BC1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27C9E6B0005; Wed, 17 Dec 2025 17:23:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254B46B0089; Wed, 17 Dec 2025 17:23:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160B16B008A; Wed, 17 Dec 2025 17:23:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 065626B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:23:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BB4360DAF
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:23:40 +0000 (UTC)
X-FDA: 84230391000.08.6E4F7EE
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id C57662000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:23:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="BV/phXeB";
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766010218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ialel5HFQhh2Hs/dEsLq3bsC4I7cFx6qt8O4tFD/kZY=;
	b=c7dNVeE2QaKI7Kefn0Bq5588mc7oBfRx0aJ3YRpORDV013zPgTtMEXlFpRM/BlKCWjIPNh
	Eg8UGpUgxdNiIYWDt2nJEM9sHcOQQNlLmxn5G9Faa1cL4nNSbuoh7FZUWrdtjLOo1Y1NDV
	fzFtKWr2HulmHerrZFL8iugryO/LFAQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="BV/phXeB";
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766010218; a=rsa-sha256;
	cv=none;
	b=JXyUb1lrxrS0hdH756HX8SVkx9racfYIBSbGh8XBolKJz66h2usZ/PzbWji+7Ukw65POp6
	Oul/JBjqfK4gK2HpFWBG8Rs0BYEZdEuhMkP55YmEu0oqRHejoaBCraGaUMSLIymhS17ALf
	Tqd/JjK2r4edPBYB+jyDObC+ivAld+c=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b31a665ba5so1590085a.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766010218; x=1766615018; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ialel5HFQhh2Hs/dEsLq3bsC4I7cFx6qt8O4tFD/kZY=;
        b=BV/phXeBxM5YfeZdqxunWI3idUX4WCrQNEZlskl+eBNd5/goF5Or6DDyHOLTvyAJmL
         MOjJBYVFt95cndG7oEbyAjsoCWzysgHLdd/OJapnrY1Tk2X9jBkADwxOl06qdDGeQHCE
         3yUc0r+nm0c950a47XUOFzh5rhccFkPgkDbS5mKDRSxOoeeP+XVnuT9Vwsp49z99TQsQ
         NEKB6d0TAo1oqfNmFQK+uOAcfYerP8NdYGEh4mXbAd3ZZD2JjC9UsfSoL3pGJYcHMJ4p
         uKOryu4IpKvSIF740A+dURd13qWmoerIeG3FseNtr8JRbcr1HyUugCEIlvnh+gni21zI
         LLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766010218; x=1766615018;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ialel5HFQhh2Hs/dEsLq3bsC4I7cFx6qt8O4tFD/kZY=;
        b=N85k16LoRjZ715kDlVcCZQ5C4lZoVV99MmKydtehXamZdkemw37OgafYg/Gaa8E3ji
         uXrTzLeZEf+loD35nIAc+Ou6pIQsdreuQv4iRDSsU7R8mtFUFQUpgspeznMrK90u/gW3
         kl3XhAmEy4bxwAPMZlvf0wm3jeWmP9y8LsGdrg9ehf81lMHSNTsNZqKpAFK56X4JeEcR
         pig4/35E0AmkYMUDHxedyuatjsyi4iKySPaElU7bnY66SGh5kKdcrUMT4XUibxdeJs4o
         czsk1+nXhnFtwr1+DcwWBVSd93OKyicZCKNOCNOkEn8lbHyGEweTMPDfuxHYGvVHwr6T
         OwjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXt25El76BbPZACQtDFRfaHboTqZaE0l8sup6vqGiUc5M1M5ph45vMU9di22iv573zu6KIagCHtzA==@kvack.org
X-Gm-Message-State: AOJu0Yxn+iV/iHl2ZfCsT79udmgx+QuUYhd5yUZFD440Fsg+GQWF4wMW
	aJmyfmCAbiUO5kYndeWUfQbu6W2UBGEDt0oN3koLqjf4NMLP15tUVhZZETCtVyasM3I=
X-Gm-Gg: AY/fxX7iDLUuVFDEOGgGkaesGC6ksua45wyuKsU+MpLYkELfDbDrDpIofQ/RKufIHXy
	HvZYoUTBgxAkw7mDAXTx3K0ALWyLNbBJHqCjj0XZtQgATaNiYpJiAq5IEoaTxj6/3d90p0wjarV
	NQXKqwCUdFZqSKHO7kacX6pAnMTFNsXlYkyrmpNVCdg/LLTQIj2JPlcGqgrJpF3oNK4720KnXB0
	O5cdC730Po8Ow3EAFWSuID2/a7wPBi1yIIqAEcR4kMmHTgy3ENKD/DIFTCTJMoRhU6+X8fDezvr
	3t0+WqRxBcEKpqLhjokIIBW4TcBfEWKXlGFbkk8FOH2/5NSkmPHfPOS6HxMawIMT+0DIPhslmEs
	/q7MTrbP2XZuZHor6XBu47W8zyiUYVqgztvHaw9g3SyO6uzMs20Jcty86huFBzb5cryI/jnAlG2
	88JOacoxZlOg==
X-Google-Smtp-Source: AGHT+IFLj5zSyMWH1DU+HU4kh5upIQXL7c073Q7ukSm1uBP6f4OKMTG1DoPUCq8OYLFaEqdy3dOhPA==
X-Received: by 2002:a05:620a:414b:b0:892:90f8:b59d with SMTP id af79cd13be357-8bb397db77bmr2800409185a.7.1766010217662;
        Wed, 17 Dec 2025 14:23:37 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c6117f54bsm4237146d6.45.2025.12.17.14.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 14:23:37 -0800 (PST)
Date: Wed, 17 Dec 2025 17:23:36 -0500
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
Subject: Re: [PATCH v2 16/28] mm: workingset: prevent memory cgroup release
 in lru_gen_eviction()
Message-ID: <aUMtaNfU7jd-kIV4@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <86b0573753db20e40315c61f5d6e01bdc6a8313a.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86b0573753db20e40315c61f5d6e01bdc6a8313a.1765956025.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C57662000A
X-Stat-Signature: c3ikmi1jfb538yyypwcn89jgax1g5ko7
X-Rspam-User: 
X-HE-Tag: 1766010218-563751
X-HE-Meta: U2FsdGVkX18/JTwSvrjtonVmZCEO8ibD2nVw10g6OBPgZmtnOc97097Z3K56hE17Hkp27YY6RcSpobnJkfh5O288B/X0xFQzf5SDOUd1Iybm9UksTw1hMTX4zHpouVFK4umllH3QYP+I1TtLgWdaC+tUIv5OA+F8XfCtgsB68+XRrVH9wLvMstC2TgLMLPDK7IDBAkWl72R8emkT+fhuKmUIZagmQCwE5cCS0iBZxDNgueULS7mg92wmtu4EYv4du9ICR4KjSYpMshN57L1BfVXxel/oH4N40Zzx+5GXI5Qmo/kTyBAhcvmEu48JsKD5ssJBRGlrimdixxyO585PpIak8yD7HYNT11hszUGNCgcjeuthiRNe1PpnPj2Q6TEgqkfjsqdg6MiYoir1TRrX7Nsx/8/yzV+t7CblGM4lfj3xAUkGoh59UvmXpyoYBEWhCTNxo/sir8H+NnRDa52PdPxZGdN/br9/dIerQxNGcSayviup/Yz8fh+m+Qf5fSHcu+5s48/RNNY+MYvo3W2z7c2+vrcv+iaQbvLpPtCjw34xQPqBFPg87pamW9CqMSRsAW4cNtLJZku3BZRuCvKfyrseMt/4nOwkYgDkhaBhQT2VFS/8RoFDvIz2mraayqXXu5Owr6Hdg5Wgc+6B9iGsDi6+WbS/sLhDSi2+x7pfqv3jCTkWNB5o37/1MYlMdTSJisiI6qlROa+Cip/X54QtfjjtcfsWv1ak2sAE/X60jM/eQ6TmkYp3HxeqHjQ95QRlkVN9Ob8SEkz4NB1zfT5VpW/4paltBR2W5w8BmIzB3mgtJp+A1l2dNu/3B2UGwjPe7LZdxlhX172GRFtuGzBbobcIWb+Jd3NppShoCWoNF7/Fu5lddRxz4BuLz13Wx5jbUVH6JXs7zYtsEGENM44dJjA4e/qLt0oEofWys2myo49B8DhM9PMbXl8Ukt0Vn9jgd9a99HwrkrzTZRMarYd
 bYB/tELW
 eIPuKHrBcsGAETNJYA87Lycx2YmUiDcqz6q7ZddJfAzdoLF23ZxomheXxI8nM7CsEXwrs3CLcshzNK6rZpkTcVjHKBc56RQWm+0uvAVq01HhIN8JQybigbrpoTmP48uEwKVpi+OgVN+odHAq+20UPdM6DwuEoKkqSqCO5jdTfFjkQaXhl6OY34zCVTQVyYPnEZopi1pwTGstddKlmEYwnXwSEvAXzko0GnZ4cmM+n6GfBLRshNrx5//3+PFIFnpl1/OkEbE+lQHFh5kipAsN38aGs2YsxECTV1AQh9SjgIPXE0sJI/Y9aA4JKAhYiQhru969g2QV4Smhk1wK3l08AZfaTjUH7ObAwNY6bndr2DjDxbnKvgyQU5jf4IgEqXWP4cnGSZi/5Lx20tpUkYr7mI5zhaVOaUUUrohKIEHKRTmmAH33uJUFsZuvsZbzf5AjnbjKu+7B97R+7QuH2RF4tjbWBP4PZsy2joyLqquBFZezMRwR/aVz/PXcV2WuKptzEBl5Zsw22B7fIUP01wEnoL9eStTnMFGEX78ivS23yE8acabM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:40PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in lru_gen_eviction().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

