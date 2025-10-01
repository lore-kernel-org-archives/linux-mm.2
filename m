Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41578CAC5B8
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 01:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A9E88E0007; Tue, 30 Sep 2025 21:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015768E0005; Tue, 30 Sep 2025 21:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18758E0007; Tue, 30 Sep 2025 21:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3108E0006
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 21:07:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C4C787F21
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 01:06:59 +0000 (UTC)
X-FDA: 83947756158.06.CAAA8B4
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7E45F18000C
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 01:06:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jB6LDIaQ;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759280817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=edhJ1DK0JG/MkiciK4D9ZVQkkUUNMgMQL9Oyscag0fM=;
	b=p1XQZAaFOKadOzuAQVFt7i+h9gfEqOYwK8I76/Talp3p8YFuDTbcilRvZPILn43rPAGekt
	y48dUsuNk2DJCIK+XvwdDN3tunHJN6tK4e6JyGwLGEsOGVGqV4Y5caPRhXko/BRO1JSb46
	mN0iPc38QHL8sN8xLntNjLzDIZsCjrg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759280817; a=rsa-sha256;
	cv=none;
	b=Dc4QIoMWbl1Zwvqgev6sdPsHW1DFq0xwnLnJzTVGhfFhbYqA1vEn9+O1ZWXmzT/J5i/S2b
	wKzAXCVeGn3qm35K9aVb96UrtwoMPShgr1Wikjx/HxvxYuVbVDSKa8sl7gymwZiBfg/jc8
	kQY9ZjNe6M+4BPlz+9QDlXeVbnrkTSA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jB6LDIaQ;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-634cef434beso881404a12.1
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759280816; x=1759885616; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=edhJ1DK0JG/MkiciK4D9ZVQkkUUNMgMQL9Oyscag0fM=;
        b=jB6LDIaQbjq2C+33SPqFi7ba3YBlO5oLRKSq6lPGHP2tmybpUBUOEXk8kI4ejHMFS+
         A9zZhDpU5kIJ4yQtZPo0VStY++TZrnhITQE8Ep3fu8EaToN5vjIqqzR3z32GJMxZdogV
         /a7oUENPjLctG6kaWHMm6eCqhrYYMrSoy+1qQWEfT/dxthrIZ92fuCZNhBWAMZY2svrQ
         Al+Vta7QSwcJowjl/9uaTDT/nXC5URUuTeqYdIt41Krr385f6extU0Nx0gKRW4IqdBdH
         41OwZ72BG+331e7e0ykaEygfAONYSyL1OsBgpUGj/A8kL0NrXQsR/b8oSOI8tPXHWG1X
         DtSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759280816; x=1759885616;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=edhJ1DK0JG/MkiciK4D9ZVQkkUUNMgMQL9Oyscag0fM=;
        b=wk5mf1st+ghmlTDoxgAqgBJ/znWiuTG8Pf38ScRL/woKls6xbGBg/CzkLc/PdbJbDn
         AiFMBf2YQkB0mi2swvcY8Chq6GBVf3CgJkmEUxDSpFpEftJFG2BXzX1DLXWwZD/LDhSZ
         HeD7OA59GNCimmnPB7bR7luevflmFUAzl7573/f7Y1pVJ4r6vcyazwQLs4IFy1E4xOYM
         mafOOsaDOTJ+M3B5O3AUelgUwxykEpSsFIr6LTztq1Pww2jDIvj+sgXkL/87+QfqEu0f
         XDuu7YIwR/lI5stBzMnoWtoEI+fAGj6B7VkBki+f/F9O2Q+vXGw6NgxG3amwnDvZPEtq
         1wdg==
X-Gm-Message-State: AOJu0YyNWB4CR7FfqwwhhjXjnl4yfjzgR06yJNq12Uwkc268rgHpka56
	VUrxhkievdP4QeJXkOwFaanRAjNK68Gy2r68k9yD2igU3OLHPCM2EUvp
X-Gm-Gg: ASbGnct5svQwUKeaUmz/P0UYsvSRRxSjKp6QZpwhK2MfRoqBldxJ9zQ3J1YO9Gp/qM/
	GPw0O/WnWdeGBCcAAx87FlsIgNDKMezu6SCrqy8DSQYtOWrhJlUMz3hofPFRReEOnromuuAryy+
	eTeUpKUcBWJPtVjSs6pj7CQu1Ptnw+NxhdhhIU3rcbKTE60h97NiZUq2pflku070GXTcJtriBuF
	v1dbz1NLJzOgH0NzMwzNIarDqBoVoxkbKHjJAewFlF1sAvAA1z+aC0vwxa97A7cvH4+s55ueMBY
	4WVoXGFO4MBKahyA/PvZJsoV15OfpPxOw4m8DCWcJO4bFyAkTjagAZX6Q3wgnhieSH7XS5SkL3H
	W8MVeDi3ITH1PHooECpnC8/HV5L1EwY8b3KXeJp6hCteQb23fPg==
X-Google-Smtp-Source: AGHT+IE5x9J201GHjxZSl93LekE0LG9yzqJiqPO0FbpCaHnnYwCsT+VBgmqZW035WCysBunLEwpbzA==
X-Received: by 2002:a17:907:c26:b0:b04:48b5:6ea5 with SMTP id a640c23a62f3a-b46c75b4ad6mr246608566b.17.1759280815654;
        Tue, 30 Sep 2025 18:06:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b353e5d2f92sm1248805166b.18.2025.09.30.18.06.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Sep 2025 18:06:55 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev
Cc: linux-mm@kvack.org,
	kirill@shutemov.name,
	raghavendra.kt@amd.com,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch mm-stable-fixup 0/2] mm_slot: fix the usage of mm_slot_entry()
Date: Wed,  1 Oct 2025 01:06:49 +0000
Message-Id: <20251001010651.10543-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: 93abmcy7qtmmzyuo3pbbtphuuond5qux
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E45F18000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1759280817-693457
X-HE-Meta: U2FsdGVkX1/IhX1eH6tWrhA0suQg3DRpKV+3P1l+KTSfSKC0RsLOwBlNIqB3KNQ4cQKQ0DJpMnc1c/mJDINCLu6KdVerjhAegaB8JSI5Rqk0gJpD8BCct7eE+/4BHPRzowx0KZOXt99LpIVezIX+DnjS9QSEvMdeTJr0p/w7bAg9pcjvN4VOU19wWTeOXtHe0/4X3HX+zQXA9pb/xpiUR6H3Nxle1T1gF8b4Tq/HpA8VTHnum2VaYKd+BIquHqSFz6xhYzqnsQ5m2ECeRRfcteXH+l8gC0HD6SriioXfX8h4EiCA0boVoCQNVAwY+x9cjNTFPQGiUY9UqZqQvYOY3SXTK0Tye1F5smW0fYH6M1IOLy6MzByKJPHWZ+OHDtvXRUIeqL6hk4g2iz1MuPXm+O3xaCWypmoxtT+SQwpGTvFCwk6M8CL7qoq6cDnYriksFDgUqvdecUnUJ1OSXhg+XufsdG2YROuw9nQyqb+vGXeAMSJLNCAlQGK/LcTbT6CJ5TaqF1QFYiXy0pxHBOkst5E+3N1TAiuZg5g862mvMYfVz/opqQWZT5wGSOmpY9StkyCkvxLz/ACmyUl/Mklpp+mhHPtEGgSZt2FODHt6z2xHVuAHSwStUu5JhXCGj8B6460Rl8BPkBBUEXiTW5aO5DwIlxRaoiVPBTWjOAjEdqiHzZHalpvEjKj/3NPCg7ZTTk5okoiKT9SfsHNwYal1zt/kGOzOdVIQBEVSR14mpgkhhxgcNUQ4VyvvD9OR/TWi9gSu/DEQi2NKYfYlyZIpivL8sLCyEDxPCvwGRO31ESFP2TBgC9AxIRKiJ+bRbqjayBztkMc7fLvibZUvMlQOEZlVyuqJ4Lk0zDviIY9BowU65VPijaJ5aVimrMo1XcIAD72gnPifeG0Cevx6ZHu+1XVLAL6SQVFjjI3xrU53zf8TYHpCr7WvDfogLgWhjUZkLPqcjQz5PYySDnjAerA
 NC+eu44s
 0Vr8JBS/jJ09nxXkLieML1zWbDERALqj4NYullhLyfmLQUACXCKRvUyEQp2CWU+XxbMfLm7zkE85Z0k2LY7Bg9EIKCwp0nj5fbF1Q1oEFEOca+/DguG++clxHATAJGNRMjVIwS4sQ9FDyTjFbRXKarsK4DxzxUf5oRqAjfYHA1oI+w1xRxBueunJ2myTs2fgOZ3BLuyRqu0XEet7QoxB8uArdrC7rYvs/v7bp1IBfaFKh0DYjaGzBJtrhUW2b32as10Psjx+lD10Yf7+lJvA40qkDF+JzWbm7if4g+1Aq5GXh9ECHhWM0APYeMarbeArCOa9hYPKdesRXY0cmOPAyjiWu23egetDPcJLRjYXaplWla/k6Pa965IdtDa5XS/bBjfo2yvCuxgjG00IaqjGVTkNDGjEbXaJcgGltcw7gLD2MzOpHQVMz9nvEVqvGRVQ3RbIc3qhJovkglKARcHyVEB+Oe6xl7oJouvOpnMbJeJi7VfwrB8DrDjKZwZTPRJFyVpqMXQ3T9YCadvesxlvTfC3Z7bNSjp5LfuRqy414QHI2324nLz8vlak6ULzyiAfmTSFTPAauSh7qBfU5btNJVRGJzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the fixup based on mm-stable.

The base commit:

   mm: swap: check for stable address space before operating on the VMA

The reviewed version is at [1].

[1]: https://lkml.kernel.org/r/20250927004539.19308-1-richard.weiyang@gmail.com

Wei Yang (2):
  mm/ksm: don't call mm_slot_entry() when the slot is NULL
  mm/khugepaged: remove definition of struct khugepaged_mm_slot

 mm/khugepaged.c |  5 +----
 mm/ksm.c        | 27 ++++++++++++++-------------
 2 files changed, 15 insertions(+), 17 deletions(-)

-- 
2.34.1


