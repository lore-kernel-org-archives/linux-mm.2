Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4092CCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 08:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2128E00FB; Tue,  4 Nov 2025 03:38:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172B98E00E7; Tue,  4 Nov 2025 03:38:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0238E00FB; Tue,  4 Nov 2025 03:38:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFA468E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:38:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 979F658F45
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:38:02 +0000 (UTC)
X-FDA: 84072272004.20.175C883
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id D31961C0004
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:38:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TTNsfDWP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762245481; a=rsa-sha256;
	cv=none;
	b=6x0kPKmxYthJz1VA7l6OeQPutgjcqYeEFsnNCQEhSQPpvLnsUGoXjC7jXpEwYykge+WC3i
	NeoL1cP00crCJ+m7Z1UFtEf+KXi1IpWlrr0VHsPCcX9kw8sD50JT8rTJLKI/n9mTgStuMc
	J91CNrMGEJ7eYMy5tWpaednj3ulrQQ0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TTNsfDWP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762245481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OgNnOMsS50KZEW2Uu5LLuchS1BcFg93kxAnhG0zifF0=;
	b=KjxfsmbpzjJN7wrv2CIF2DwE9UKERhHT7+VTuvs7WnIIWXzGLeBYO7mb6lGq4OXbvZd7HO
	ang+ln5Cl37TG7xU1Ydvty1VE1CV6zqVY2Qr/NKeWTH4WadJl7iceRD1tLnYLw7l24A2h7
	anGa6APO8C2zxXQZ2DGpM+2T/0nrbrA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762245478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OgNnOMsS50KZEW2Uu5LLuchS1BcFg93kxAnhG0zifF0=;
	b=TTNsfDWPw4SN7MyW7OwQGbloCmpkQ4GOZn86TPZAjHsddPG7e2W8c65FrBum0rATGdfa8H
	0/4NV6WriY+ObP9+5vFDgWgNT4QwnbpZZ6CHvKC5Mw5fWKwM94z3ZOV/y3ymInTCNXuy6u
	lV4zLs2mxsGWY0Uf26e29y97bu5H4Gg=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v3 0/2] mm/hugetlb: refactor sysfs/sysctl interfaces
Date: Tue,  4 Nov 2025 16:37:41 +0800
Message-ID: <cover.1762245157.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D31961C0004
X-Stat-Signature: qqq7i6qq93msak6ap5zbxyqi3h8nzkf3
X-HE-Tag: 1762245480-606246
X-HE-Meta: U2FsdGVkX18ILL8D3CEsu90pcg6woeqeqKRIqlAOVzG2X5+cAxR7Zc+Er+aAu+rKqMWFC3vZdy2bozhHuyHWxZEvUSBktnnxv9ijjTrhNvBdtLfiI9zi6V7Hr1uKpmVFLTEvnv14b8mPNvs6vDZ4Nw/B87drhMeMgJY8K4YKK/YZwM/SFb0t/Aj1s7EfqsxFONFaEltO9oXfsOJYI4MRdtZ0YUWV+/NyXH9jIPLb4mvuW65PyVWGWKQU71+4rIXARrFaeb+qrmfxjTqVwZKqafxaRRf8eGHlIh5FnL4aX0goYJ/lQlnLSpCn1rYA9NPblzatE+PXpdqfCoJcpmXkW8DkQuBocsBegiG+tisPq8eBUd6YxdDiYKlPi2wC5nvRWwQ2RBm9JVgzp6n0hwvKJ2G6/oBSf1/LSeX46UKSQVCTFv2yvWw/oDTMPJrAuKOhU7DZfyCPIpw79rY6VEPsfOnEFFqLcK+Q+hM+ylQ7eNdxa9bK5SnoMzn0pLvd717Jgq6vObIxM/Hp04qFrOGcqqvSemfmp0GxxHeToNv9aCSrf3VqV3xnlQn8QY5uzBWrY9tAbXoIomzkMWGYyne1cAXK0FfMC+xjLgu5u8NJIUJSLtU3mgWna62QwcZunY8JsWUVj9YnN0PcOgQSa/OhjkG8Gu8HPfaCqQv3hs1rlgMwUblS6VQIRXuun3QmqoSH+siWloOz0LSLGj6n+5r/ltZI/Vkchqkw7v9Q6OQxVvsdaFc3Gzozb1YYErarLupPJ+SuDj/9J7N+51ii+11zBXVEiupI6oGTKjyDWehU8T2Ro+cBjrfAH6C244rXCRfmTRNMyQWVgp05jAW+nDHHTyppU+Ys3HAXToEXAdKG8gq47BGDOGhyyqblXHPa+XKs7E7jwdTRhxinsQfjHeVbq5nn0VdNjeHtyjzbOEjOwAYhv2X0WVC7mGwhRGOBOLEehEQPO9mAu18b7EQYUMd
 jfzPzfWB
 eYER9y4Q5B+9w4/4mnQff8RuBCNZAEpNtHVaF2icTzIDfMAgAyXnNaXFUSURb9JuEKG6VirvFzXe+Nrq2J/JFC9cyxxtdBW+CkHmzX0tg4dCEni2yUWyjRDWRaXit+aCr68vMSmJ36Leh62FvozpmNreDag==
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
 mm/hugetlb.c          | 852 +-----------------------------------------
 mm/hugetlb_internal.h | 113 ++++++
 mm/hugetlb_sysctl.c   | 133 +++++++
 mm/hugetlb_sysfs.c    | 629 +++++++++++++++++++++++++++++++
 6 files changed, 887 insertions(+), 844 deletions(-)
 create mode 100644 mm/hugetlb_internal.h
 create mode 100644 mm/hugetlb_sysctl.c
 create mode 100644 mm/hugetlb_sysfs.c

-- 
2.43.0


