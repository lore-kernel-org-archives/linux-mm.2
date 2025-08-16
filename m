Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C9ACA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 14:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75D378E0021; Sat, 16 Aug 2025 10:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5CC8E000A; Sat, 16 Aug 2025 10:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4E38E0021; Sat, 16 Aug 2025 10:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 497B68E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:46:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C437FB993D
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:46:07 +0000 (UTC)
X-FDA: 83782895574.26.F9F7B85
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id BC096140009
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:46:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dE+xF/Ku";
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755355565;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lj2xlwN8FaYSBmnA8nJC1cMfqZAxHNyF4eUqmUL4BG4=;
	b=6lEwGf18GZP57KzLD4rfzZyEj6q/tTU4JA7BhGN9HJnVSKakU0PQT3LKu2W26WGEDObKmU
	Ta+XI62LriXN5D8HPIm1hirh5KlDFAjadcDq8DJ8oZVn19XfvOxYWPyeDZ182WSRe93+Tz
	w6SK3e/gBwFIL7OKyGZo4KHuafiecYY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755355565; a=rsa-sha256;
	cv=none;
	b=OGD7f/eixjeRqTw1eq/hc6rxuVnCtLw6gN8QAXwOd1ceS8Vvh8NjXMZq6SAp8/dnu6EZjF
	pONZh3qSJ45XLiXvN1RpA1qmmjrdogcj6S4FrqHfzXWNe4AVdlcvMaek1AOVP0l8X/L7R1
	me3bH9Zx1b56GIn+wGy4BYMINDcYXDg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dE+xF/Ku";
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb78c77ebso450972766b.1
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755355564; x=1755960364; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lj2xlwN8FaYSBmnA8nJC1cMfqZAxHNyF4eUqmUL4BG4=;
        b=dE+xF/Ku3zkWhrIxYguAsmAj1qg/v8FmWVEZXigJ4pzO0YX/OxoXq+Lp+C8NUv0RFe
         qMLFsGaQPlrfa4D+Zmr4g4fss/mNKIapm/x1W7ppbwM26mCsunXnSV2iRJd2EdTAuKi6
         lrhaXi9NtITXi9HKTqw2EPO0CclErsGFkZKpwnbQrpk6Cw2URb1SiN0rboIPdfn0JNI8
         z6/ORZ9pSP+P6pi94j08TsvfzM02bvE4Qeq05nXLSba64E+VOCDRtu1GmzR2NOOQMMnc
         To67W64+TMjIirdTflV532a7cXUPir5NVQHbQgn8vy64NuKqiPAHxl9Xl5r0fyZTiBts
         BRSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755355564; x=1755960364;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lj2xlwN8FaYSBmnA8nJC1cMfqZAxHNyF4eUqmUL4BG4=;
        b=XEWbYwLXeX8HNKlh9c9gaqZSR9U9VeDhUXlAB/0MdonqhBD+RGpvPG/6/YcRvbopor
         e7yduQ0EF5MCnbhKUroHVZiT2DF6/iLcSpTl2WsRuNR86d5IOrwWePUYV1MDKskjZ0Al
         YnZzfb8aEpUlXUHSsciSiQeeYCFTXio+XYn/bzXU0GV3srW77LHz6bkANXCzO4SZKyvM
         MsWKygbn7t69uynM4/qdkB1cApYY7p9PK8gINz+9nlImcyeaf+Xv8FGaXFieWzp9WdQ/
         aiPapMErwlf2Yhcp/pSRAW33t+d9hpASJZ4XyX6HrILDSmlsreKsXFh7+67YCgd6C0ow
         SZLA==
X-Forwarded-Encrypted: i=1; AJvYcCWpx201N0j/6qYOl9FHfxHJXUvkJMGj3JKPPMCY53jbjyKA2xAOwRmk3FD/atZQ3bSqAWHIgdG5eg==@kvack.org
X-Gm-Message-State: AOJu0YxBzSq3efLy95wwiVwVrLjM8dV/aBMshEiOglr9VxmmKCKaqqfa
	iI/5CPFBUIi/m8BEVhs27Jra+aVmI75UYOzJwNlz37GjWYQ/wEOInu/a
X-Gm-Gg: ASbGncvXG65xhLhYkj0SVvBSb5u8sqlkq4rTApBUKB5H8uWwEP3KxpA2K46TsBAiDyq
	s+jRC7woG+cYsy3sszmC9g7A0j5+Yw2Sr4ZEDYyS9kLPF3D2P7j0jM3ZHgNTkQRp2VJF8xhZ26T
	xKgRinf5Z/lvo54ZN+HT65b3ayBoRfwV4lBSueO29C9/byM8DJ9bb1a5FJ6nIxdfqksP6csnLvL
	M2x8O3c0a/86FSizaM3QAKn/mMoCry+pEjqtJ/aTtgi9zxXnkd3yK03UTfjyc5/M3QGCFuETC1y
	W4GvpHtAwQpmXXCEc6uNipHI/yT9ltm602TzaB6h40OSsR6JQYH8bm7m4l7PKlgMHI2OGbYM1F8
	eT/lgq0diRL3CiVOUy9NLTw==
X-Google-Smtp-Source: AGHT+IHYzSam8oaaPBGoeoFOYde9ZA5LUMifw8sPAmxG2jXP0i4Znt5bpM3wACSxr0qigpThqDMa1w==
X-Received: by 2002:a17:907:980d:b0:afc:d3f5:c40c with SMTP id a640c23a62f3a-afcdc362bc8mr521879566b.40.1755355564222;
        Sat, 16 Aug 2025 07:46:04 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdcfccbebsm388692966b.59.2025.08.16.07.46.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Aug 2025 07:46:03 -0700 (PDT)
Date: Sat, 16 Aug 2025 14:46:03 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	donettom@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH v4 6/7] selftests/mm: skip thuge-gen test if system is
 not setup properly
Message-ID: <20250816144603.43nxd74hz6nrockz@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
 <20250816040113.760010-7-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816040113.760010-7-aboorvad@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BC096140009
X-Stat-Signature: abitc5qbbq5a3cfq8z7ey1bqti8zzhmy
X-HE-Tag: 1755355565-141773
X-HE-Meta: U2FsdGVkX1+blz9qHtZR7C2BDcwnKggtZaFgcYhltqNJ8ikZZJk6PWqGlC8W3LyFynMJsMf7LUlz8h7lVln+XBMc0jREIWPs4ROMzr1MQ+7O5jLE83H3rlE0KC1h7T4UcuwIhL+TvxXCMAL7Va3c077T/WG6BZpmDRo70HZc6VwaoiyGmit/o9T+ugo5Yie9upgG39mcxAXy5fzDIQhcMZULQMwBHILFR4itPAIO3CN1D6fvY7YlZggAHWPl3g5ubew5+P8qmm63mQljG6EKXOOr/8XIuguyaNt2tTaO5lxwK+jGmBh75LGPRPZKv0xyEt1G7gyCY4ir1oXtnkkWKggm6F37sAUmfbQ5AuVHDhlHswlw9MmqlO9O1wjnLhewI9VMyh6oRD9vO6niNfdYKIyPvnxVwO2HC5Ucqxq31CoS8cTNQx9/8hXL/4uDQds14phth92sBxPLxHfhtL4pEfs2viMT2j1FFMV0Z4lmir3FHS1pkWq2xnkLNxKW2FHVy3wYONYkk2sJJ9zYNh3dSpYkNeKHr/LEUknTKq7gvkFKZPoNgraw5o0RDo0MnfblVXxze6weNSie9iupYw54yXtb61LNbKWmgdcXwiPUx8i9ZQP8yRABoLzlAq4jr29VI8I7NJurbS9v1K6jST8XAx00+LBj2OcSs/U5YxiwPdIm9wtyImMjr/R1x+8jnK4BuLJfV65pALeK6JuvHTBpCnBqv15Fn7eY1NB+xpUdAyvuniPwb5E9s/aT04ZQP0p2rMvzueieBusRAe4kMglK3cKBnhIDfBG8gSKoWzihGIQeFo0FRnuaXBJxWPqK9k+xcqcR3FOvNX/WMfDaS0G+IE46G6od/FtKWux6EqOkS1cQub1X+DORBKvDpXQrIwH7kMTCTjBNHqfEHmH2Xlja7dDWMvLrirGXLFWEdP4pbjRhg3U9oNCVSmSelFQlWAlPPuMsqSmF7THJqmKufaE
 t8zdcc4f
 q0rdqhkGBdzpHh+N9CAuNlI0IlyeHwQDJZj+/fMIoIWvXVqLdxH3Spy2sx9zwzZY9fwUzYm8cvg8BFyGM/LCk3hItuHtBbPGcH5HGfp9HDOTymsWxNOh4szzmU3NpoYe10tITt/3wNzODGpJXnxR1I3W5Re1555FhVOgd0RYiP03QyUbzSmvuSlrSXCmRgPmykIdrTWcwfGdVXO/0g4vN6M22cMMHHyH0mIH3H+DiEpx55weHvKfDyR6PaaKv3eycqB6DSWICq6AfODw48vkrig5c/nUD0ToXbKoDey48EuGIybQ3Bu5Vo1wb6mVitLv4TgB04wWRv0x7zo2zeHfHBGzyqRrbxTDBdrteuOP4YkQ2+mm6ipI4xpbK2sFuh2KHOipkIBWwzoKnFkgFlmogvJALxS1B957/NOufXS422m/IZKGdaQIXeixOE7unI8wLiNphMFD5Trl/M52wzE7jo3U7vcS23MUIfBF9yinR6YlUbKQgGSksIc2O51E3X36/qthVryl2CWJS77zijYrcLmLgpWTOStBC1bYbgy+Dr4RYj/3CmS+Z7ESfJ4ZpELejVpaW0ajZ3TRcWfGV0KGsHbiNtOhh2Mgezw3IKI5RCyYirYBtuS3XnX/Oh8grwzedzOgD0NyLwRHpqqB2BV9i5KRBnflw5vWBtI5mnc0/yzrbVLpEPizIQoc/+IbPZIG5su7xUptMPivKvVDI1v2IZiLLDSTqBSWJy15wPvqqgci/iM+aGsnohzkPPR4sp/NwqLLZNmaELrwpY3YlxGkMNDZckU9ZIt0TxkjwRbTr/AgFnwbk1g/ksb2BvpmWxJkpgtBN2YMJSiqOfdp9xsXl3bubno5NgFPCiP5qPnOvh0T6nLA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 09:31:12AM +0530, Aboorva Devarajan wrote:
>Make thuge-gen skip instead of fail when it can't run due to system
>settings.  If shmmax is too small or no 1G huge pages are available, the
>test now prints a warning and is marked as skipped.
>
>-------------------
>Before Patch:
>-------------------
>~ running ./thuge-gen
>~ Bail out! Please do echo 262144 > /proc/sys/kernel/shmmax
>~ Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>~ [FAIL]
>not ok 28 thuge-gen ~ exit=1
>
>-------------------
>After Patch:
>-------------------
>~ running ./thuge-gen
>~ ~ WARNING: shmmax is too small to run this test.
>~ ~ Please run the following command to increase shmmax:
>~ ~ echo 262144 > /proc/sys/kernel/shmmax
>~ 1..0 ~ SKIP Test skipped due to insufficient shmmax value.
>~ [SKIP]
>ok 29 thuge-gen ~ SKIP
>
>Co-developed-by: Donet Tom <donettom@linux.ibm.com>
>Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>Reviewed-by: Dev Jain <dev.jain@arm.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

