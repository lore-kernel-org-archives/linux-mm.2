Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9514CA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C80286B0093; Mon, 28 Sep 2026 11:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F736B009D; Mon, 28 Sep 2026 11:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B46AB6B009E; Mon, 28 Sep 2026 11:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99A666B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:19:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C0511A01CB
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:19:58 +0000 (UTC)
X-FDA: 85263531276.02.33619F4
Received: from mail-pj2-f38.google.com (mail-pj2-f38.google.com [74.125.227.166])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7134240003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:19:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e3lKZj2A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.227.166 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790608796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQrjkRZQeuYzERNWt13KrmtO7dHmdt8dryvfZkIliO0=;
	b=x+5otBlTLBmPxXVXzkm6wc6HIhiByVqygg7Wk26Gbp9c0+Ph/P9aJSiEpFuTvbXi7SJ5v1
	VoWJ8qEY/rXDtALYlENm3ULcWIMVwXZzsAMTkiE/deO6Fagbe781soP0a3At2Gu48RYznC
	pKLLZ3D9yy3rcCJqQ9/wARBdbOMd2Hs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e3lKZj2A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.227.166 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790608796;
	b=uCXpq97QivL3OeT489mec/9/zNRp//f9m03qW6cZZGbulHzC4dvzjkiZ9Yb1pCHh24Q+Rx
	FnMzHOW/gPBjdK7IEc4TSIjEApFbq31kWSjhg8AO1LVASw35FMQVcQVpZinOJ6Z2TMIsNy
	6Z6I9kFNfI222N8uWxL49amhieNeQ8s=
Received: by mail-pj2-f38.google.com with SMTP id d9443c01a7336-2d747ec6185so13642175ad.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790608795; x=1791213595; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EQrjkRZQeuYzERNWt13KrmtO7dHmdt8dryvfZkIliO0=;
        b=e3lKZj2AMIqTXL0FPMYgHNfDfkOlgv1HIBPNcYNIZkhxIUA1zLYroc8zL534HXQpSm
         ys7JTkWXYReiMLDPEpMSqT5VxiFNdShalzBB248FNyNA5VcSWLnEdt5WWtdYOPmZVmX6
         5rDSHVq5WMqsdPQC4lF4Ktwx8iIPOBZfVq0mlrXd0v3K016DCafDfSGWJrCLg1B6pAEY
         AKPTkYEdbHhl7t9XTMj8IByAU5fG6u0foKK8jmmU1MV2+MKIZO/+6JEMQjZBAd3kzRC+
         Qtm4yWgPlxjCXgSVNRSAH3vDZ8P0jJs3FJ9Mapgv9z/LkRsFqtnRxKsqwiyh2GRvqiXy
         lJww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790608795; x=1791213595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EQrjkRZQeuYzERNWt13KrmtO7dHmdt8dryvfZkIliO0=;
        b=foxAbYm2kT2cdX/3e8q9Zg1dPwp8kwsS7jCk3PtKkl2il9LrOsM5mWjA+LZ9pSBcXV
         idW+wd2hjt+K42SucDRP+D7qFNhlcWnExq+hJExBHD6Zh+FYHcNo4H1wDUGKixKcFpF4
         lQjEpetkUtJJE7XxG5qi/RPLI9AhM4C2UKNvt1n/kHp0A6QBtU6r+kLSXTInORZUpocj
         3mJh49KO2fh2c1aZw9EnWo9S93ZtAjeVjqa4JY8S6wVIxl5hromTKbd84pH3esK6mB1M
         hMpBHplKH3wgKSbh/9W6JpThtpIsF/p+Da/KsS6pluuLoIXtVeoBNSW135b0SvLLGgSL
         22hQ==
X-Forwarded-Encrypted: i=1; AKwUvBwuRRnWfRgHO45NK+pD87YfgzbhykkFOIzKgS8XLUMChs2hlp/GayqTIUcZWJILCf1LOqENEGYnLg==@kvack.org
X-Gm-Message-State: AFq9FYL9pLASX2egvHsOBOcxtmxnEWlLOQyxg88RXUL+641278QyDlBy
	ui+yqNnPfZLTkxssfnW6mRQQwR22v/Y9kzfqmw0Jf2Uohxn3AIwqCqej
X-Gm-Gg: AYBFou0VGv4jOvIvOG8n6b4HnQs+uy8O+NM6K0vkUG691cu7kT+6KBgjWyKTlbUwORg
	OhQi6GO9RQ/dAmu+quXcaHayLhYXj453HyFXFgd21M2qw+OhiZQYjG59A9eCeBQun9O72tuqF6w
	PtVek5hJtkLuZLxMZoNQJkyWQQqfITv4G+UjUkPp48iHkNL7E3tsUcUU/MMNIHpQVUWsqRp8OQx
	WF8EG2dliPtltJHRDHlWSprXnPxrxS5nLyJj3ggWOoe7mexvPgfnsxAx4CxIDLv2PYxgD4YKHmY
	sltLTegMDgss+SfC6l/vs0eYZuEfP8IyFvF2K/Rrc0YV73p4EGXnXQ6x06F2RJf1ur/+KSh171C
	dREqRWuWiBZXN4XXfk32bQoTZkuUuHDMow8t9cTqXoA7O1J9/KCfk75PNvborUtAokPYmQSxtzS
	mjJMk5jaFnGE85cFSIoodvxfBa9BkZJ7PRycepfgndzwj6ZmFlFR5PDW6+jVeNk9Bx//DjVOMeO
	amtT2fm2L41XYY+84WIRSgn+VlfdsIK8MHED/RhO5A0EIykgc0ILK6Y+a6cqcnDp3XGJSXLkELR
	k0z7lVCNddoTOAu28LbNFE1U4VD0fYKmtW2Aj/kPULjNQuEoOO7TKiRbhj8=
X-Received: by 2002:a17:903:1987:b0:2dd:3ddf:b87a with SMTP id d9443c01a7336-2df7da68a41mr101388085ad.0.1790608794891;
        Mon, 28 Sep 2026 08:19:54 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df91423df7sm43558615ad.43.2026.09.28.08.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 08:19:54 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-api@vger.kernel.org,
	Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org,
	Karel Zak <kzak@redhat.com>,
	util-linux@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-pm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
Date: Mon, 28 Sep 2026 23:19:44 +0800
Message-ID: <20260928151944.2686626-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAMgjq7B7jem_dwtUEX7ZJPQm_pKBegR6WS9+B7nFp-gZugpUng@mail.gmail.com>
References: <20260926045517.3458413-1-matthias.goergens@gmail.com> <CAMgjq7B7jem_dwtUEX7ZJPQm_pKBegR6WS9+B7nFp-gZugpUng@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7134240003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: tz9h63qw9gpwgkxgbsc1of8smtcz573c
X-HE-Tag: 1790608796-299795
X-HE-Meta: U2FsdGVkX19qiMlis21qRuM0YU6IuvB9FkHWg/K+M4A39lgusI2Lnh4v5VSP9FPKITcFxxw+ZaDr5hm0MjHshw99+HlnBtrNN0zafQvsPl96qMe+qMXPmwxzqhdFqBLuyfA9lF355alqgxHnGCG66Ol+ixoBb9hNiXYh+8tj6N2kEQYlcThuDkmL1h/O7KJfQgHUDRinD3gSpshecyBnlnJ211u/x6UmRFkALJuvVdoaL8cVnSkwRQI1FiYG2iv84iaLD/emaZ5oSyRdqHzek26gb02bJxFZGOMM5sG3cnZaQyuVLv2CmL9O0SpOFoRvjuiSZTJFREmp/80A6sBtJqRp2HNkutydFT/hTYjYplQBZG35j34iUQ+n9hfZk4lEVu/0ubXMnYQAwvRtR42qX5q5oNQwqI10E/T0olAdeEyhTZ5KNoHZipQIHvqcZbIOxLpY3K1mEaoo80CgzQupIWHKO+SpU0eoNI2W1Ga41wGHMXVTK0pA6UZvHgccdEuiN48GI/H1HjMhi6vo5E7nfRfBkoM0/ENGvNuVzgNeJL7coC9vnEtcyM5PhXpUVxTsw9LpYTUNK+rimOhT0uitKrrkSBH+UIRY1+Stu8bshBk1nfsqqsbXn0e8lKnvGqtTATB3HK7FoHobn+3gAB2VPZt0cCUJhrREjWvDh0Xav5JCCX3hMfz1A9RULukrhT3x2UveFsBwfTOfAGwvxeALom0RqJ2uLVJIP3oDlksX8aHK7vWnMDhHtrPw1AnlWXIbEMMaRVxx/P/KPWb+aBz+UqafXhbffr2Ikef6gvbcz3oEKm7x1vtD9yoAvjXTgwZx4f2ZsUwhopGq0aSVLBzjgHagx1mhv45DfRyNlilRboBCXoU9BiZQR5AGkAxmSycip3qRme60bS3Pewp0y6J71N1DHPuATKfueV69om9lkAx9R3XgWODTZ2UVRliwwC214g2xV7UjJYXzstx9bA9
 iXZzkroh
 axRqdTdE6FEobgR9hnXOEbsVqQEkZXLUIeqjBrBJWfB1l3VwhcH2ZeSYkCa/Q7+dcJ+wUwB/kw4pvz1O/tKgR+8cCEJ7jnzTYnLrKPYazzSXASKQqPb57DQC033hDRja/C3LXQyRPvbgAVNC03WVBdQ5yVdB1MjVaKLvu2DNQFKIq7wL97pKT/WJEQz+Y//5SSacI848CsYmK4tstLlH57I8/RIZ3mln9EgAhJcnzUCBwBXSgwWr7RBwN+27NZwFBHp0r0JEeXOuUFidD76fhwZJF+LSz0Ynq/HYUyAJUnTLqX8/aURegIakDvmIzfz9f4H4axLG1QrvOezJ4OrxLxtA8UyvzT0J3BWtwApV9mF5LiNjzqu7phvBg4bt0ZHsE4oS4twkQRYsh2uPI3xSzNRc5Apm7v20Uog7A4tt0EwxEf037CW7XRdopr9XQ1pRf4u5gyZo3uzSVo1m2ZHUPzqFrk28esJwWyRg/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

> Just like we already have a "swappiness=" parameter in the reclaim
> interface, perhaps adding a "swap.tier=" would be better and much
> cleaner to achieve the same goal? Based on Youngjun's work here:
> https://lore.kernel.org/all/20260916183437.2946306-1-youngjun.park@lge.com/

Thanks, I think that's the right base.  I tried it: on top of
Youngjun's v11, a "swap.tier=" argument to memory.reclaim is about 40
lines.  In a VM with zram at a higher priority than a disk swap
device, and a cgroup whose tier mask allowed only the disk, ordinary
reclaim in that cgroup stayed on the disk, while memory.reclaim with
"swap.tier=" pointing at zram went to zram only.

What it doesn't cover yet is reclaim outside any configured cgroup:
under global pressure, a cgroup nobody configured still reached the
zram tier.  So for v3 I'd like to add a system-wide limit on which
tiers pressure reclaim may use, on top of the per-cgroup settings.
I'll wait for Youngjun's v12 and build on that.

Thanks,
Matthias

