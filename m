Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05F70CCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 03:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05C8A8E0009; Wed,  5 Nov 2025 22:08:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00D478E0002; Wed,  5 Nov 2025 22:08:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8C0B8E0009; Wed,  5 Nov 2025 22:08:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D34CC8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 22:08:43 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 724ED88AE7
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:08:43 +0000 (UTC)
X-FDA: 84078699726.15.2474F0D
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9961D1C0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:08:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DIL/yDdm";
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762398522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PEgt8dqODFgqWZubV0P8rSJ5eXEFZvoVCzJWLxN7M9g=;
	b=xZM/rs9vV3pkQwrAJAWQEEm5DFJxLGUoKdeCQvDkjjUsV5bl8xv4f52zcPnYIoPhkDcD6p
	0VKCEqCuqmp9O04ZxxVOwGI+xWwXp3pAZ36cloBJTsWMixFz1LOYbvOgVH+I1tC/wvFBAl
	OgVidPTQBt0j8t6VykK2yG+POMEZAYU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DIL/yDdm";
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762398522; a=rsa-sha256;
	cv=none;
	b=wjMECOuitLU1pM6zTseMYa2ilXWPnzzVM+tdh2fI850LqIRpIzAB6qkxecFOkevqOnNb4a
	OURO74lGz2/DlW+Wsj60PrBRPEdIBF3vY4MzZeS6NPsSpywkqHY61nXB2s8rHvwhkLPvKc
	3ekWSb/GUUdUDelO706dk0SKA0D+/VU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762398519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PEgt8dqODFgqWZubV0P8rSJ5eXEFZvoVCzJWLxN7M9g=;
	b=DIL/yDdmEpqocu9ESUZ8W9uH0Vh1M18a9ktyGr6YFz1Xeg33wl10vdqdtMnUxSz0n8Tz1v
	J0oX93sKbVpg1ERQjL2zMnLSXwPGdaZatEpcBqBmULRgRYC6i0hvSU0olk/Q3El75yX0Bt
	DVHZ5+MQ98DgLhm3nSEYY8NH/oDt9Oo=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v5 0/2] mm/hugetlb: refactor sysfs/sysctl interfaces
Date: Thu,  6 Nov 2025 11:08:21 +0800
Message-ID: <cover.1762398359.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9961D1C0002
X-Stat-Signature: earnydhwuarzf1o4fpjb7c7nw87qj7hq
X-Rspam-User: 
X-HE-Tag: 1762398521-712405
X-HE-Meta: U2FsdGVkX1/4ozBLPl89q9DMTz7VFWVsCqQFBGdjoLWOCCt46IJ4EuA92WHPQwuBu9NNMVeuj1npZPKWPNmD0sx+bvEDvcAmOpDbCpWHCWylA4NtJ+4CCBlpHGUagC9c7wVJzhq4r/2fQ6Gdz9GHeRqy4aaJk4pD6tV9i3YH0R26t5khYphM8JR7pjCnC2nu+mJl5glXkMNWTqki3mDsu0s5Ba8+SvS2IC2v/D7eAX2r6BqTCa5nPqxqUACMRfyLQtYC5rl7LIzUT7qRAA8S84kb/iqmuhe5vCjHjRfz4Jly61NmoobDOxzI4ZwDWXzb/bwmBXxJGJI946WMRhBpG12gmjqEqSBkxvozAiHrsx2oucTP6v2asHSzZZ58b4MRsWlKjyhFNfn4ftz8hPSnoOXkKzY47IZnh6g4Weu5D3krM6CfTAhN33yG189XZ04Bku3PuXkNBEsO7EmVC0X0z4BGWKwkMh9rJstgiNGVUu+wRtBVjhDOfOHd481McWk6GaYApruR+BmmFg0XASk151mpVmhlWSu66oMCTJXUKXkdd1chQnCQ4Z6RhvY0HM8GQr1G84qjX4+3s/z7RAS/sHUHqYxI0AbsYtR6l+edgl35ZcOgbprovOXa/cw73cSNz/vkYh1UUILoi0fSRx1hce2W6ppVMYvIZ3dH7sxYY9FV0fet1OXaT1eUIx0MDNG2DTgyBpsi0HsDBH7kwSzIO5dgfaBULQfpEmna1+LNjyoIi9OW8dZ9+Ar4OtX3POe5r2u2HMAfSsYRQGlHiXI8KoOAupzgYF/9JCiWDXwRxiuQW2n1rbjmUCmy6+AwPHPTqhcH0tWwsPU1ZeX2+3LEKiAqTljDsiOEaBnkxzIL1dvgRNLAsy8LSisK4V5HhyFlaS1RpHuWMVSPS/RfBqA0KQiCLRWvDa0oJx6vHOi354AP8aIm8FS4XQKK4ChUe9ZgEGJOlc3XRCXATGzA2p0
 XP29Lfy0
 EIKZZ/t1VF7IUrVO6RfSp0KdJO/E7Ao1/M5589KsMBPcSwaVwq1UtSsdlDJ1B1zgcjZZyjnw79SVKbgs/eBpAav2TCdAV8UHNxTZQXLpWlhdQM/JiAT+072kVlPLJbslfpNGISw7azJAr6VAgKh1glbdYNCJEYD5nUpYN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

The hugetlb.c file has grown significantly and become difficult to
maintain. This patch series extracts the sysfs and sysctl interface
code into separate dedicated files to improve code organization.

The refactoring includes:
- Patch 1: Extract sysfs interface into mm/hugetlb_sysfs.c
- Patch 2: Extract sysctl interface into mm/hugetlb_sysctl.c

No functional changes are introduced in this series. The code is moved
as-is, with only minor formatting adjustments for code style
consistency. This should make future maintenance and enhancements to
the hugetlb subsystem easier.

Testing: The patch series has been compile-tested and maintains the
same functionality as the original code.

Changelog:
v5:
According to the comments of David Hildenbrand and Oscar Salvador,
move demote_free_hugetlb_folios and demote_pool_huge_page back to
hugetlb.c.
v4:
According to the comments of David Hildenbrand, add copyright of
hugetlb.c to hugetlb_internal.h, hugetlb_sysctl.c and hugetlb_sysfs.c.
v3:
According to the comments of SeongJae Park, updated MAINTAINERS to
add new files.
Removed the wrong copyright in hugetlb_internal.h.
v2:
According to the comments of David Hildenbrand, removed the wrong
copyright in the file headers.

Hui Zhu (2):
  mm/hugetlb: extract sysfs into hugetlb_sysfs.c
  mm/hugetlb: extract sysctl into hugetlb_sysctl.c

 MAINTAINERS           |   2 +
 mm/Makefile           |   2 +-
 mm/hugetlb.c          | 728 +-----------------------------------------
 mm/hugetlb_internal.h | 117 +++++++
 mm/hugetlb_sysctl.c   | 134 ++++++++
 mm/hugetlb_sysfs.c    | 502 +++++++++++++++++++++++++++++
 6 files changed, 767 insertions(+), 718 deletions(-)
 create mode 100644 mm/hugetlb_internal.h
 create mode 100644 mm/hugetlb_sysctl.c
 create mode 100644 mm/hugetlb_sysfs.c

-- 
2.43.0


