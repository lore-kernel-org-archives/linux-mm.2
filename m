Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5AF9CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 14:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19BCE6B0088; Thu, 28 May 2026 10:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14CBD6B0098; Thu, 28 May 2026 10:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03B4E6B0099; Thu, 28 May 2026 10:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAD8D6B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:03:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 949661A0887
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:03:17 +0000 (UTC)
X-FDA: 84816995634.15.C175516
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3F2EB100016
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:03:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Vsq40Sr/";
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.167.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779976995; a=rsa-sha256;
	cv=none;
	b=skdCUdQuBOlo5QjmP/dQy5XW/zG62I3qf7bVAdJgsF/zVbgt9fEYCH0Pafaoc+p00sNYHn
	cAJkNRDy08W0hcw5Mgh8Pl3TwsVpSRtgloF9gSRUzU/vBiY2WMkBQBOMzQW+gAn316olnJ
	xeDNNqRGVO/xjXSaudqkY6qapZmPiqA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Vsq40Sr/";
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.167.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779976995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rO+A7GjX2+2QgmOEjNdtI+NV3B5SN9zhDQg6nEMiyz4=;
	b=IDND0EL5rWrx6oBAu8iMnPpTWrT5yUv1obwH6S5yed8RFqqBvCESMI9PSJaV4C2vuVrFLq
	yK+uaYyMJL+Tq/R8EsAguwNvfKtYQk3WoGwKfGIArYw+pJ4LXsPrWyhR7uFgWeL0eYDsIi
	JinkMqm16n7Pu3pA3ZIIfupJKHE22yI=
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-47cba53479aso8280626b6e.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 07:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779976994; x=1780581794; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rO+A7GjX2+2QgmOEjNdtI+NV3B5SN9zhDQg6nEMiyz4=;
        b=Vsq40Sr/rR5rgTkhv+NhWCZwUcWXweoQz40+y/2QQJHfM7xGDZqCKMhZRMpLzHIWeF
         TLhyOAGptAKybGXqiCJ9YWZTw9Z1RyNWbM+b3dovLK7i++pccY78qXGbciusfGVCtZNJ
         /xy+8S9FLTf/NfqZN0wlyvecP4y59LuXGU7j7byFXPbPVTBo/b2ycp6ayZKwkyRFN4rh
         9eHX6Sw37SgR6tQ25nAk8PRYWtQVH1bn5fqQu8ppbHAj3qE3VjRXuxlc1M66E3C+iFYs
         KOpalnCJrq+/rpOb8Re58vTBjoXp08HFbET/sEGqFeIu8sVlSAZPk+1W8Pc5i5EU7TpR
         ujfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779976994; x=1780581794;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rO+A7GjX2+2QgmOEjNdtI+NV3B5SN9zhDQg6nEMiyz4=;
        b=MWkV0RtlVlHPjxT+1DZ8hiHEfdbZpRqujf5SnPuv8+1+jbLltgo3crRJRhIYbOB8AU
         SWQvNaXsVliH4gtNsHXExXNLU2JkrOaTSJs/ARh/n+/P1g/0fJr9QWg/fDfdtQ/81Vwu
         2I45SvSAUFrHVQewjwiQIPInWHssyP0TSeWKtLhgD6I1Zm7fa5Ig+Of2dsxHs9+LFMSJ
         92PXZ0bugtjItsIPZIxtAPN+Y6ImKX9fb3SAxgODftnCZOx6Q22Ra0J0AtkARPFfN2ra
         ju1v8yKqnG5P94cR8tH9Sh3ryfQMDI4NCeLvlWpsDJ19SFTSk43jv7bVn4Sm+7onhgxK
         w0Fw==
X-Forwarded-Encrypted: i=1; AFNElJ9zaGoiThyho3XqcPvMUaVTd0sJ1jWVIvcLYs3dRyS9yZZyow5U16bhYZTobkiUezkkB3UUPzCNQA==@kvack.org
X-Gm-Message-State: AOJu0YyYS/yZsWJ3byP/+yigEMAb+Vv6sOtzv0MHnotqygJ/nP5gk6k+
	W+BiCTIfekkQ45uMB5sb+EseXUcudXFnzFcphphfTTEXwPI+EcC7JjCiAcHMFSUT6gc=
X-Gm-Gg: Acq92OF2qni5DDBtp/TQ/eAgFE9ScOsA4XlflE2GRB5ib0qhS9lk6VhWgXchTp2ZUi8
	tQi97k5gJ/G+ykactg1zWDSzc5WNnaat85f5hXlpQWSpCxrkS12pkh7vI8QzVOe8lv5p5WYxSPw
	Equ9THHZCp1fUJaaXeoN/rYeAVUFa3uHCMgl6P/nvlH1PsqDXGDd/XEq65SHEgt8XijnHY18Rmn
	jBlv2ItdQ3BJuYZfJmc8e3cOhrX7j0p6STRuZj0oS2WMrBusOmzeaYStXPftJsRH8SsLFhfgb1n
	qEMjyutAS1WOkBNDCYlS+gO3dSgmgIs1afDdp7EHxfbGSce9a7AAv/2H+RDx0Q7eE8DN1TYaNuM
	IWfjBhQqnov5fCuRscJxLVFIju9cPm9+It6W7+65F/RjgebMvWkst5uXxq0uV2H0qGyXDUSXEXU
	lnlfeARhd/69HabPzAisFRIfLpxHZQHiQV9EyybnRmJ6g=
X-Received: by 2002:a05:6808:191a:b0:485:48da:132e with SMTP id 5614622812f47-4854a224419mr15508945b6e.27.1779976993865;
        Thu, 28 May 2026 07:03:13 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51706af4fd2sm73661071cf.25.2026.05.28.07.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 07:03:12 -0700 (PDT)
Date: Thu, 28 May 2026 10:03:12 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
Message-ID: <ahhLIBSC7rxgXSEU@cmpxchg.org>
References: <20260527204757.2544958-10-hannes@cmpxchg.org>
 <20260528070807.144064-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260528070807.144064-1-sj@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F2EB100016
X-Rspamd-Server: rspam03
X-Stat-Signature: 7p8w5cde4so1qr7k1qaqhir87zue1fq5
X-HE-Tag: 1779976994-999540
X-HE-Meta: U2FsdGVkX18QZ8hVSQ4pRLLnkwI7VuaDPgKzyVdyxILoOsExZYxSG6wjfxAybU0MK3Id8a5CXztJIhKYpWeMvSGEP51f8QgUt6xSg9SKubodAiKQLaLfPltHS7ok6srrhyI4LupQH9DX+TbNN/r5eteaSHtczrnZDz1cdVtEqA2ZDP9B2Be3I/VQNoSdzckRlRDvvQE2EqvsF+Pk84WR2Vadq+fKzo5S2JYHSNRPMEhf8UR5qmLicuJxd5y4NK0BmBdMZN/XMtYOeUDZ2G1Q7Qsoa8I4FGyEHcYb2wI/HWLqnOu6QL13XpM6/SEUuXocEoxBmaRVXw10cya59b4DzAAH9QfZomSo1oG3kllx2W/BdDIuwb6DhgiaAhXpk/sHP9PR+X6H+FvsOjGUUxLXP+E91Wjxv5VdXiGyr6FvwJyiVJ5D6jfhBieJSHpxImoYOEVMSQPkwql7Xn3NBN1svlvag8f1eKUBphE5d1pCd36Pt+9eaObgG7QswCnKd6V3276PIkzgFOWJd8zZtiI9WCPGg1osk7RnbKpFaWM9b3YFlrjg+4PC4FbkqW3ktmBnZfhDrEqZlSsOZC5YxBxyUrMn29q5nV3VlNetFFZ0gkvbfSoN9XTUWvmx3Vsbr8h9YeFtXRmDMx/3sVkAie7XgK5WIEfl7i6wmg77wneelnUU3AbhmJhIuf2CHC1tFIdQ1ucMafutHhhzO2aZee4VIoq3Pt8ZvH2y2/RUZ8Q0b1e2VAtx8RTJybQBTEzzyYLXr4Qe1Dg6aYm2/um0tZbfqHx4smB0RTx3XFmPiTbWXusVHF2B8L0AGeCCc6NGSCk4cNgGNWUEkNxhWXhvD5HmHi38AP1mM3GzamkMIMjAn/hpCO8rc7dTIAbqP/K7BUE4jtzvZENBCtf1Kc/DH7scXDV0fjoTYew6RVgZ5Vw+68KO0hgXQuO5T0D9Syjx82c8otuuPpj9f4aeB9IaR5L
 AodfIFsf
 A+pyxEuhsquaiFqSIzBSoQOklhm9YPxy6o67Y4eqtnOk11Tbh8NwCvm8/epl1PiIFdrNgv+bHYdvEXnjRxElYfHT3KIiNzdlrLhwN7g+2fDJfpH9iutgSe9WJ4sfsrxVi8olIElnu5zD+LL9OF1B6JVd2svqYgpxfUFM+JBNeoHONYilVZeRXEaRNDWvMqBc7OgP+vsVakEVT9imSjW85yrVKA0BTER2wrj1MRavfNv4kLqPJW3p+Wwxx4uG2xFPQhWMa9d0cv+L3k+oYo2EqLrDqFJhB1+W/hpIwtTFUQvbelHPIYY/D4NHmaWmqRGCFRsLlTD3m7yeCPTnkVjKD9+2O2e5JfKYgwzwfuclNhhYEwTYMbtpKvOpThEe/g8kUhZ5Cht5piB+HHZl3INB64EJgj49jWVqpY7QiAeOS4N/K8FpX8EEkd+Fv/OJ70Su1V/rdVCfJrrHc/HFNVk3E5FYkAMuEgGPxK6AJgfqDhmvuOYFGj1J2bhP+cm4JPVYhzuU5mVRzoddC9xxPI4RrmhoPdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 12:08:05AM -0700, SeongJae Park wrote:
> From 23b5800dd49085707baee5774b74782c3e424f24 Mon Sep 17 00:00:00 2001
> From: SeongJae Park <sj@kernel.org>
> Date: Wed, 27 May 2026 23:58:07 -0700
> Subject: [PATCH] mm/huge_mm: define memcg_alloc_deferred() for
>  !CONFIG_TRANSPARENT_HUGEPPAGE
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Without this, UM mode kunit fails like below.
> 
>     $ ./tools/testing/kunit/kunit.py run --kunitconfig mm/damon/tests/
>     [00:00:02] Configuring KUnit Kernel ...
>     [00:00:02] Building KUnit Kernel ...
>     Populating config with:
>     $ make ARCH=um O=.kunit olddefconfig
>     Building with:
>     $ make all compile_commands.json scripts_gdb ARCH=um O=.kunit --jobs=8
>     ERROR:root:../mm/swap_state.c: In function ‘__swap_cache_alloc’:
>     ../mm/swap_state.c:468:26: error: implicit declaration of function ‘folio_memcg_alloc_deferred’ [-Wimplicit-function-declaration]
>       468 |         if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>           |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~
>     make[4]: *** [../scripts/Makefile.build:289: mm/swap_state.o] Error 1
>     make[4]: *** Waiting for unfinished jobs....
>     make[3]: *** [../scripts/Makefile.build:548: mm] Error 2
>     make[3]: *** Waiting for unfinished jobs....
>     make[2]: *** [/home/lkhack/linux/Makefile:2143: .] Error 2
>     make[1]: *** [/home/lkhack/linux/Makefile:248: __sub-make] Error 2
>     make: *** [Makefile:248: __sub-make] Error 2
> 
> Fix by implementing the function for CONFIG_TRANSPARENT_HUGEPPAGE unset
> case.
> 
> Fixes: https://lore.kernel.org/20260527204757.2544958-10-hannes@cmpxchg.org
> Signed-off-by: SeongJae Park <sj@kernel.org>

Whoops, thanks for the fix, SJ. I'll incorporate UM builds into my
final compile test before sending.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

