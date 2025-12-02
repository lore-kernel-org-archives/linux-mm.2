Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8795CD116F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 14:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3A66B000C; Tue,  2 Dec 2025 09:28:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2D406B000D; Tue,  2 Dec 2025 09:28:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C716B000E; Tue,  2 Dec 2025 09:28:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8C0236B000C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 09:28:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 651E586EFA
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:28:07 +0000 (UTC)
X-FDA: 84174760614.01.D475D63
Received: from mail-106121.protonmail.ch (mail-106121.protonmail.ch [79.135.106.121])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9F3E98000D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:28:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=hi1S9ZUC;
	spf=pass (imf02.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764685685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gnRx6DH/kHtIbGyXyRe/fabVRjG6utJSkpf40juEPlY=;
	b=qUcjw2wY18o9lY7OR6U8jgEh/7pDbaZWN7B2pruDCttHAD4MPDJRkb5un5F+7YPWCDd/T7
	NkAkGXVKf8aImzj73ziH45zambP/Ltqe284AA6r20jSWPrkFyIwL2kLnhOMfMyWSbPDa2h
	sx4R4IzxZ/FKF7go3q02z8GLL3HBBB4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=hi1S9ZUC;
	spf=pass (imf02.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764685685; a=rsa-sha256;
	cv=none;
	b=Rbt751N1o3lsmU8ieX18mV0BpoVsxRGlTRpIOsp6xROzrftAVJIcZV+BFJaSJk1x9moiPh
	mtLUkQLvRrTYd2CGS1Lk/hxsuKgWMGHHfDPYccot0UtmzcxBUI6UMObJJdMEPPe/0TkZ1Q
	bkq3UuTa0oxrAKNrevEsubxQSUxPDEI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764685682; x=1764944882;
	bh=gnRx6DH/kHtIbGyXyRe/fabVRjG6utJSkpf40juEPlY=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=hi1S9ZUCRJfmuQXnO8tPJKyAk1vTEFoDhiooP2VypGox4xeM+y3Otr5V6rmFmDLeY
	 TLV0f6jlHR0ynMCYpRZTj9JdZjmH1kZsTrW5h/K1rYllkP8ZVLLJ5GoWMatIqj8sn0
	 dHe0JDu4EJqdn9wFY/g8nXGBDpdL8PPZ5phvGogwJRSAwCnWK8YnzudfbEV56go57L
	 8j2gECIA3Kgrp/vVc+1CPYMuFyE0ITKm3orIDGEuMJ5xwejJahva4xi4PEzAzZZvuB
	 1gntSIb0BsX1TAEqjWI73L7Vq7A0A757twD9q+BakKRpEw0c0EBDs4xYpCQ/NXrmMz
	 pT8/8yAQqHg4A==
Date: Tue, 02 Dec 2025 14:27:56 +0000
To: urezki@gmail.com, akpm@linux-foundation.org, elver@google.com, vincenzo.frascino@arm.com, glider@google.com, dvyukov@google.com, ryabinin.a.a@gmail.com, andreyknvl@gmail.com
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, maciej.wieczor-retman@intel.com, m.wieczorretman@pm.me
Subject: [PATCH v2 0/2] kasan: vmalloc: Fix incorrect tag assignment with multiple vm_structs
Message-ID: <cover.1764685296.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: d9334a187d17bcde8e960ee9982dde07d7c67d37
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ee8wmupa7h3wpwf898rftnocn9g93is3
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F3E98000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1764685685-186188
X-HE-Meta: U2FsdGVkX197EzSVKtInI4EOPvuPBvh29T4HPRcw2SvT/Evqkti4GqIBEUEvhJguxIk6Qw9u+j1TLJPO8xWptzo7m6hEv5CfcA9cHSu8VCiXYOzmKAnJCjObiIoyg5hFSycHMidYRhCWEovYumquNSLPbKYq97S/jqNBHPhWlIq5NpSYlqlYsGiV7Ywvfu22YZYdrJ0NF+/R04wVDV1bKhWJURr2GhOiH5yhFIlYIjaYbRiMAIdN9dsue8qFsBnzuXDTJJskuiWQBQnQcVbZDizxVU+TSNBL+8DWbOxPY6I7PU0dPy5GBg6kS8R2KEr/cYhtuqIDoy2o7Rj3JweFKXGB8qSV/pMJjQ7x+67CAeT5Cy6wdBfmhGHlfMu36HWssp6xL9k/HAl19jN/05PTMxlw1s2sE5GM3Mo93x/ag3M7Mn61CAxBvnOlpXRyfYfxml60xgjDMAgY/128YRTyK7WzI8mvB7eXc+KWZvAZtdJ4+3LzXtDKvIXOYRg5MByEeCYXvzghb0qkmnCfQ8Ra5BUaei6fRd8ic5F6G8BOC3DXhbCrigyjOy2SeWV+O63gVvTw8nEmUwhIVJPm1/+vBMZMahdx/8x/VMhmdRz4P4MScmawP/RYYXjduJ8CsWP2GhdAAWUPG894AZFCSUGcLexio941LE7VXn3crBjLV2T05mPMMc+ACTQWHzfGMsmZDItNIamKgjhBCRMWpjiMZOSOtvS44qVaNpB0VULW65gygMPnuoWKVzmiMqpc3B1cZi1XwBqD5rGXEv3T4Lq9IwI95HGNVNtv+jQ+1P+0mra3zp5Go4iYyQtQ/v5oTypYnGq73xp/Xyl+4Tb9zqPT0UKlZZcTArAnduCCgdEnleJC+7tVTmcT8bpLXw9RdAwRVLaLC4wzVh3ox5TmtOiorfC61bTEvBsHBXwO95D77MYpu0dsx5RBLzq0pkjAGos+xB4YTxN4EIP2To/nUb8
 Y0Uy3/Q+
 wxUt62R/dZlBWH3CM6oA/TtLMtM8Q2UHFefexq+gew37MzUUCCIg2vpmwe55w9JYz0QpjbMGV1AKyb2zAijCvmYrK5SmzNw71BXv1uXbL9FpG7bskY0/hw3hu8buMUPbQ4CCO4VtUodbwRVYr8xfTAx5Hf3lLoxphcUnUMjPLFuKk60wrfG1YOV8kDt5+4Dc4L9Xb4spEin501CNAQSny7IfVncOu0EZlZOtOfl8WZce7OLaDVBDaiyby0n/nWW0Hh614HuM8sYkQ460wA3h7hPXLvraqHquzXu4e1OiFVKr8c29Ixy5z4LpWJF3rHBxchGBmtMhg+ntpWnC2Xf9Yy8jd3PCHv1Rs17SHvDSlvLqTeRJO6hO1EGOYfPYJdXvqef23j8ndWRznzSc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A KASAN tag mismatch, possibly resulting in a kernel panic, can be
observed on systems with a tag-based KASAN enabled and with multiple
NUMA nodes. Initially it was only noticed on x86 [1] but later a similar
issue was also reported on arm64 [2].

Specifically the problem is related to how vm_structs interact with
pcpu_chunks - both when they are allocated, assigned and when pcpu_chunk
addresses are derived.

When vm_structs are allocated they are tagged if vmalloc support is
enabled along the KASAN mode. Later when first pcpu chunk is allocated
it gets its 'base_addr' field set to the first allocated vm_struct.
With that it inherits that vm_struct's tag.

When pcpu_chunk addresses are later derived (by pcpu_chunk_addr(), for
example in pcpu_alloc_noprof()) the base_addr field is used and offsets
are added to it. If the initial conditions are satisfied then some of
the offsets will point into memory allocated with a different vm_struct.
So while the lower bits will get accurately derived the tag bits in the
top of the pointer won't match the shadow memory contents.

The solution (proposed at v2 of the x86 KASAN series [3]) is to tag the
vm_structs the same when allocating them for the per cpu allocator (in
pcpu_get_vm_areas()).

Originally these patches were part of the x86 KASAN series [4].

The series is based on 6.18.

[1] https://lore.kernel.org/all/e7e04692866d02e6d3b32bb43b998e5d17092ba4.17=
38686764.git.maciej.wieczor-retman@intel.com/
[2] https://lore.kernel.org/all/aMUrW1Znp1GEj7St@MiWiFi-R3L-srv/
[3] https://lore.kernel.org/all/CAPAsAGxDRv_uFeMYu9TwhBVWHCCtkSxoWY4xmFB_vo=
wMbi8raw@mail.gmail.com/
[4] https://lore.kernel.org/all/cover.1761763681.git.m.wieczorretman@pm.me/

Changes v2:
- Redid the patches since last version wasn't an actual refactor as the
  patch promised.
- Also fixed multiple mistakes and retested everything.

Maciej Wieczor-Retman (2):
  kasan: Refactor pcpu kasan vmalloc unpoison
  kasan: Unpoison vms[area] addresses with a common tag

 include/linux/kasan.h | 16 +++++++++++++---
 mm/kasan/common.c     | 18 ++++++++++++++++++
 mm/kasan/hw_tags.c    | 21 ++++++++++++++++++---
 mm/kasan/shadow.c     | 25 ++++++++++++++++++++++---
 mm/vmalloc.c          |  4 +---
 5 files changed, 72 insertions(+), 12 deletions(-)

--=20
2.52.0



