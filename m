Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37C0FCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 13:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E2616B0095; Tue, 29 Sep 2026 09:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4937D6B0096; Tue, 29 Sep 2026 09:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AADC6B0098; Tue, 29 Sep 2026 09:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FFF86B0095
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:15:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B2ACA69EE
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:15:28 +0000 (UTC)
X-FDA: 85266846336.21.383A40B
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1B51F180019
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:15:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Bi/PaIQp";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gB90BWbs;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790687726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dln44ETuiXwXPmOn5cFsvpQrPsJf7dyzZ/xlI0gN724=;
	b=zbKAgaPgquk6H3MDlkPV0i10bMmiTRLxAbqav2L0yFcRDtpE+NpS0C2Fptnc1Q+nUoa639
	p/bZs+crhUcAY+tj/BQa3n0oed6Wrk8l8Hz+IgKjko162t7kB5EhvLErDR8E1Kh5YN01oF
	8SpveLSjjzhMuxlJWuDpV4TzPjn6SKc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Bi/PaIQp";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gB90BWbs;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790687726;
	b=Ap5fL2Op9uWHua2Nmz7BaMsxGllr1yyDzn2n6oxCoXBLIYos5SVxgOWKlupiAaRzA8KVO+
	EgY18zgFwlbILyIXGglZryDZ03wUeWNzNYOp+Lgwtubs2VPIxXZP27yZf+bZ0bGALh9Yyc
	dWry808mkqEn0PcZZ+iw0hlyYhTmE8g=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 73FBF1400DE9;
	Tue, 29 Sep 2026 09:15:25 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Tue, 29 Sep 2026 09:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1790687725; x=1790774125; bh=dln44ETuiX
	wXPmOn5cFsvpQrPsJf7dyzZ/xlI0gN724=; b=Bi/PaIQpgq++yJqpVx/Z33jNvb
	SvAxltNdXLj4vsR0g5jLhrfKa7jM+wDPOJVylXdFfU6yVZF+civwcp+TS2IMl7zk
	Mpwn8WD3YXhQwjrttuH0HjZHRaroT4gnD4uH/ONjGWCdN6Ftp2zoDLCQKTzF81BY
	Rz4lWPlGhoMBMmVP7Q0woy/pWrjhlGuGsm6HvwNVDPyTpRWJ7pPRiDjnSyVSZAq6
	jkCfH7vLGfw9PEq/MoWwHt6TrLEfihhzjoh6MagFMc3RbhbOXqOGfcdR3Ml3PR4m
	D+XNmXCZXtTq2zrV00Kox5LUUJ1XT/pKqmM6QLduZwzqsbVt3aZbcoyp1K/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790687725; x=1790774125; bh=dln44ETuiXwXPmOn5cFsvpQrPsJf7dyzZ/x
	lI0gN724=; b=gB90BWbsm1+K0aSfQ6hhzHMwBkWDLYWVSNdRONEfgAzPHgkH5N5
	hrHfucS/MAr1iQDxuPNc6TwGWs73SHPiCnjLGJxbUe/4hRIM3BoUOKqOOxcejECP
	aLXn+RznCMumAZ7LRkPRLEsG8whF3KoH6adBqr+iOwtlAvUjbALHOEfHkXG80xo0
	KiHxKFPcXhPjnMm0iw4K4Ld8nojmO6pbefM/nbxNkNzMV4Id9CA7l6AHy7q0JjRI
	gmZdow7U+P6zRMlMoHqsLTy1A5nSGWq7Z+1TDRM+LWXpJGMqKK+jubGjLBeDZsDl
	XWNz78V4Xoas6cNMcUQnfFoV1nXBvNDyJbg==
X-ME-Sender: <xms:7Lm7aj1K495RalAp36TemdYS50cOON2KImp5lxK0G2cY-p_dpBvG2A>
    <xme:7Lm7ajtxfocCtCXro7xsFyASeIzxa2_cyN2tSk-I3aVixQeBoyBCEN8XmaH-WnHAX
    bWwsNC11QqT1HPIdPFDuVmhGhzEyrdZjGEO-3yoUtmKNlrEVIRMseou>
X-ME-Received: <xmr:7Lm7an8dtz3x0XRlB5N7q8sOTtyI5JPQswEn-CjZnCFi9wHRZet_FNdnccM>
X-ME-Proxy-Cause: dmFkZTEdRzjebqwEyKUsmCMnVq/d6i3oNDeazqWgQUaCchZvTgbioD5tEK+m1B45sYEP7u
    TntqU8fdl6QP5zx5E69fZ51nHWl+I26EBc2HC3WqwFRQ63udJjmQqPvC1EtMFZ2vLEDK8A
    jjfmS8b69efhc3joRYo74vNDRZ8zClIgdG5l2bRF/M6NC3hbjvylUFvA/MvgT2ujD1YAZh
    IzkQbFH50g9a00b2iMKNZkMTpFzHG/hLdMdg3VRS2Uj6FQJTdX0Jsjit76F/1Pzs13p3Mk
    cbY9gO59pD4jGkwsD6g/gmAD1FIzaa6+dkemqQYDHhLKebwqbPYD7ynQiPvWsaZg0z5SKk
    /or2nd2ppG//ZDj05dGdqm72C1Y4QT9bmB1rPVs3uM1g5pLUlh3ZNiXVUtj6PwLGGByivR
    3/f/MWtgldm9D0KnOLAFqh7y/S+6zOEvf0qgTi5rARGK8xeDQMoAFhqx3RM9U+VPSTAi8O
    r+M6FzHvN+8MI210952MlPgAipoxkYrWni9LVgNHrQCIUD7RrI15C3penw+WmMKTuGULK8
    zdeEWQQ5VgG7WnMsFTNxDb9NDBsq9mzz9CkFRk+xn6hzuMj5SdPQEo+is4YAIR4zgDuWp4
    ZtFEgBdh3L2icI0Vmxm5mNCS/6UGOkYhcoydVBIblgsfofnUI6L/+Knvn9Rg
X-ME-Proxy: <xmx:7Lm7avRPneSVcBJVWT_JjXNBbWegXjyfwdu6-umBDyNWCoyqvnuWag>
    <xmx:7Lm7alDfusfvHescl9rIxVFniotiqVAyeA9f7VU2YEsaOIMoSIpMYw>
    <xmx:7Lm7aoboQy9LsGd6e9psgvdaslroXk_sTjIiFfC_gUpNzrAK6Qgq1g>
    <xmx:7Lm7auJ1hgrn7tUVnSwqmB2fj7dCAOdwdeqPyYJBqM-ISvXJMtjorQ>
    <xmx:7bm7an12QHvh6yInRK7UjF5L1PldHoYcW7S14J4xm-F1kGsifmHspSP7>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 29 Sep 2026 09:15:23 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Shuah Khan <shuah@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 0/4] selftests/mm: check large folio results through check_huge() only
Date: Tue, 29 Sep 2026 14:15:15 +0100
Message-ID: <20260929131521.153079-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cnet9mqknkgiegzd4wthyos4j1zam3h3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1B51F180019
X-HE-Tag: 1790687725-760808
X-HE-Meta: U2FsdGVkX19kOtI9TJUPBveaIVd80jrCDnMRcSqXG6tUF+NpkvIY6qyTZ9xUCD0ae2vKc12bWfOC+cgSK7Vp76G+z3Bt4c3k1bLm1WCA4E4de46xtp9LLfTPuf6RL8I9cAS9D0qLRhzFGQVskp5y6KQ+uYq0/dfGzbfn8jCy6KxcLMF1C0TOFthsOzAwaYtzkcnDb3Mpsohvi7rHJXo+5VgZBTXUqy5+0qU2pPArgMWk8DaDpwmc2wGTYCgIf1D4ZyeTGCVQ/u7i8bbBWLWg149Jsr6BjBGLgJNxg3k0kqJTnsCKng5FXdDB8nY9LjksVcHO1IdjErKu+rykMFykkyjin65qVWPoefSD4n3C87yCqElaSZblXC87krkrmLG2iJebrwgdOigz0ak+2Ooq2632dMD1/JR8YEooGw/i2xEud2q2jqcEh9IVZ1NT9VLv1VNpPhr7UDzMJ/m4XYSLuzpSIy8ka3CCY9VGMpQY/ZjVwkWV4t1KrENzsqJKJ30LufBSkl/CfZHZsYpoNwF5iexfnJUNKLFdR7tjkmKalHjPJGzaZRxwKWAmimpUEzIaEl23XJc26Mnz62cYIsEQvzZTlxRHIPB7Z3yZLmGWQmEJax3uNdiHlXx/uN+y7flN20UwpynYxtRNaxnU+iDLVCoiXvm0aOEL56xfJpHEjc721kLz5Bwd7a47486RErX6VHqmfznetSEQO8yfUtL7HFbu/52s7BZRBQML5Md3eglP9rThK5kEBZjjBinjq+3w0YNX26DyIPKixqLRmyfjrM9fhcTmrYclBPehzn/R9AmMIqQrhmV+PD6Ah7kTxaVbApB+MZdTHHqE2leHHuqd4DgGqExXPhtoKP8zmUX9rjAKgKkPPNpQOluWPdAyDZd0xeN2Mub1HvPbIR1b3KDUdZNLaJOC04wHOJDGOjEINPkAXRrJr1EWKSo/ArTZin+TQsK1VbGpcuoly/tCd3K
 tGATL3z/
 ROm5rJZpPmaQ4JSFH2b/H+P41GHJgWbyxtcm6l8F+3l5pwAoid2Iu3XwCMpV7I/ijHRs8z24axv3EzX43i5h11rm4+Hlyau/ADJ2XD/MxC1nNvWIDCmnIsks7wDTVdVAOzb2T9QlD/SQK0JWu/d7ky4QCVGSrkZ89GiI35qG5JyKnBi2/hB/DHZk0sKKSHL35wQ8mIzSconxjfFDgthm9+6SiZ2/B90vr+s8f/eqiZXjftPoFQMwrvAbU7hgNY8mEhHqXNVPn2OrifIzZ0+yvDjkxcfbkEPmD1AJoDEFwgVPfnhqjOaEubm/HnzmixZt6cFrz91aKL5QbOAWhvcp22IkyAS434FpdWKbf4IuUFYuz5XtYZ5slLhBJvfiLkiAfU0C+TzgdaH6GJQ9IiOLnhVqZ1OeGa10gpOvBLyjQBiATgOU2hK8YEMpd80FO+Iqq6Y0d2Fn1SFu2YttmQbrHBHLp3K5clqnTHTjv5Il118fdi2AxtvszlWWkePhgVfKsKpO89S2qb6mZJMQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The mm selftests had two ways to check that a range came out as folios
of a given order.  check_huge_anon() and check_huge_file() counted
folios of the order in the range.  is_range_backed_by_order() checked
each window for a folio with its head at the window start.  Baolin found
the two sets in khugepaged.c confusing [1], and the answer at the time
was to merge them once Yeoreum's rewrite of check_huge_*() on top of
pagemap and kpageflags landed.  It is in mm-new now.

Make check_huge() check windows below the PMD size, route every caller
through it, and make is_range_backed_by_order() an internal of vm_util.c.
The split test's count-based check goes the same way, which also makes
it notice a split at the wrong offset.  On the way check_huge() stops
reopening pagemap and kpageflags on every call, which was the other
reason the separate helper existed.

Tested on mm-new 2589c5593c20 with KASAN, in 16G guests, x86-64/4K under
KVM and arm64/64K under TCG: the khugepaged matrix at every order,
split_huge_page_test, pagemap_ioctl and khugepaged all:all on tmpfs pass
with the same counts as before.

[1] https://lore.kernel.org/all/65bf1722-c1fd-452a-88c1-c030b042cfbc@linux.alibaba.com/

Kiryl Shutsemau (Meta) (4):
  selftests/mm: open pagemap and kpageflags once for check_huge()
  selftests/mm: check sub-PMD ranges window by window in check_huge()
  selftests/mm: check collapse results through check_huge() only
  selftests/mm: check split results by position, drop
    gather_folio_orders()

 .../testing/selftests/mm/folio_order_check.c  |  28 +-
 tools/testing/selftests/mm/khugepaged.c       |  47 ++-
 .../selftests/mm/khugepaged_sync_check.c      |   7 +-
 .../selftests/mm/split_huge_page_test.c       | 104 +++---
 tools/testing/selftests/mm/vm_util.c          | 320 ++++++------------
 tools/testing/selftests/mm/vm_util.h          |   7 +-
 6 files changed, 176 insertions(+), 337 deletions(-)


base-commit: 2589c5593c200e5146db848730baa1d7dd0c9f4e
-- 
2.54.0


