Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D83CC5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 02:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBB996B0096; Tue, 18 Aug 2026 22:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B20F16B0098; Tue, 18 Aug 2026 22:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E85C6B0099; Tue, 18 Aug 2026 22:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 729066B0096
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:16:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFFD4C03EB
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:16:29 +0000 (UTC)
X-FDA: 85116404898.01.78E5B84
Received: from mta1.migadu.com (out-133.mta1.migadu.com [95.215.58.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 278AB20006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:16:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xLERms1Z;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.133 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787105788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ph3PoeSehbKJc7yMBqellxAJIZ/Uys+u6YbOsWtBIPs=;
	b=qqGNP3HjEXoSlpRq45QEfe2mmBv4aawV4BFB92dNEScWFNQJ6/REtKDFlPJza+sOY/wdxZ
	k6vCeHsEraSF4YnDMv9JXiioeUj9+cegWuRXaGY2fouU+wk0gaDd3YkU0gOo+OU61r+eFS
	PmgqhwF45dBehsqSyNU8hJtf9Cxs3Hg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xLERms1Z;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.133 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787105788;
	b=INf6kjcZOYvTUDJk7MCtNuMVQ5dbSqe+Bqt3Zv1QqdOuxC9TqOf4nBvJJ8T3GnC7hPUQ+Z
	usCgX5HQEZdwPJxVmkUQ8BZTgTMUe+jHE/Q6Akqg0Widb3i0g8WfMCUZKlq4VsHT4MUAq2
	7/rarEqVGLJFHfSlO/SKBYz/RE3I6Hc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4q4HADBiida0K9D2Blnlucj+RLJw1l5XMARr9t3DAZU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787105786; v=1; x=1787710586;
 b=xLERms1ZStVNyJECqcs+S38NM+juZSWlJ4+IVPrMDDmXKQSUpr0vw2s1mgwLYZ/+SDIRQMjY
 q9/OuH80KdbSRlf+b6WLqqBU7TITJVIgMfp6ClrVs8D22F0j5KY8TGak/GwbmmzhS3EUFfs32a6
 w3PdNrfB1LYzuLAF/qcMXrhs=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 817f9be3478d872c;
	Wed, 19 Aug 2026 02:16:16 +0000
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] tools/mm/page_owner_sort: fix --sort, add module filter, improve usage
Date: Wed, 19 Aug 2026 10:16:08 +0800
Message-Id: <20260819021611.2910835-1-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 278AB20006
X-Stat-Signature: yr7cpqxwwcfscupe9jgkqh79ncyji1h6
X-Rspam-User: 
X-HE-Tag: 1787105787-9432
X-HE-Meta: U2FsdGVkX1+ZRn0OO/q9dukpWwZQfkW88IoO0Cb5RhThZOM3f7o0dE3AD/weOzCfwNNzf1r0KWplPjgwAmojWMGalXQ1XrIdNr+PxpgOo4BGI8n8iaEJ2J8vyHCZmyEqBIZ6twUoBCqBl9eMrvibPQkV5pYgiGMxUTB5tig7MbONpDmwKGr7t0Wip6uYuFsMl7D+8kj630kFyJp7m51WAWU4OKlJQ+lg2XQhlEw7I4GJwQDHtg0q+7Lb3zpmTD6PuWPxneR7rUPerr14eE3fGbrgrRSL6d8BCHiAzp5J8ns3Mk+33+5UbLdrZjJbj2TvPbQtskhKgOux4ru7MZolFrmvUCosLnplB6rksdE8BFY+hU/rgSSwitxUgMdtedc/6Yed2Xrt+7msXlaIsWeP78d/FDZNuzLRc7Ms8mtjY3E3Il3D+7Ch7C/RqfZHhIT0q6h2BR8fLYnntv+xsupA1AEvCCjlZcv3d7KA5qDGzmjLdmBwGVF0WZ1nJTkUFdS6y+t7zeV64XImak7UDjAtMmyWDmzXFdMdHMVREf9TwpJUgIgvi+OLZeJnpWtMOKeEgpHcFFyqvoXY9ycy+mRZFIWVtayb6+GZw9GlumsuHlc4CPAVcKkx4UHQ4xAqQJpcvY8veboeALpuPkH6DHGdV1RgJX4FpaPPY9Cziek8eGn0NfCc/yQvj7UWQsN+BWwS5p98JVFB2uQKSyqk9FuzAblCEbEO1rMmOs+kDzq+n1dwQEUMMj16ZhUSyG7GgL3lJyqCQFZaq7vjjKUfi/8VwL514TCZZD7Cd225O0Xyqgfn7OqnHva0xgqVOO5mfskHXD6iZV3YJpIehFTTMXSbH/h3jF3HJ5sNF74Be+rPPUqUcfmj5/QQTTslJ8nCrVN27bTt2bSoIEl3Xux5VfzZ/9KiTl/uUtMMF0pzElaPiipfa/OeZLemQvf+8AYKOv8t2yEOBsEZq24HGBoWloT
 VNoz5GDq
 6LYOSguegb73if4Nvv7/Qwmf5QIuFiFwKLovzKRL1tqpo4Q0wS/SYAWbwcbeAFoPyXDGssbHej7iGX50hB9yfhYcTOpfSEJUQwpNz2RX5ZznyDfszefgw/86255szoF1cOZIpkbcKrjyvG9z3BD1vT4npVsoXFiuFhjOf7iLjwAW1NlaXEZwQ+riEN5NyPvS61wW3CEnUAzwkulapG+XKvLABgnP7pQlosRdopwjSHO/nNZWuZC02ZLU/HYLKxcIAuwypbWG69jyJ3YiFgeyUURTCK5nbiGG7kWQSxRVsY1Ik+jRpdXkN1SlSeo8ArptwEibY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

This series improves the page_owner_sort tool with a bug fix, a new
module-name feature, and better usage text.

Patch 1 fixes a long-standing bug where --sort was silently ignored
when used without a short option (-a, -m, -p, etc.).  The COMP_NO_FLAG
case fell through to COMP_NUM and overwrote the sort conditions
configured by parse_sort_args().

Patch 2 adds kernel module name support for sort, cull, and filter
operations.  Page owner stack traces already contain module names in
the "function+0xNN/0xNN [module]" format produced by %pS, but
page_owner_sort had no way to use them.  Records without module frames
are assigned "vmlinux".

  # Aggregate page usage per module
  ./page_owner_sort input.txt output.txt --cull=mod

  # Filter to records from xfs module only
  ./page_owner_sort input.txt output.txt --module xfs

  # Sort by module name, then by pid descending
  ./page_owner_sort input.txt output.txt --sort=mod,-pid

Patch 3 lists all available sort keys with abbreviations and examples
directly in the --sort help section so users no longer need to read
the source to discover valid keys.

Ye Liu (3):                                                            
  tools/mm/page_owner_sort: fix --sort option being silently ignored
  tools/mm/page_owner_sort: add module name sort/cull/filter support
  tools/mm/page_owner_sort: show available sort keys in usage text

 Documentation/mm/page_owner.rst |   8 +-
 tools/mm/page_owner_sort.c      | 134 +++++++++++++++++++++++++++-----
 2 files changed, 122 insertions(+), 20 deletions(-)
---
v3:
 - Patch 1: Use fallthrough to COMP_NUM per David's review.
 - Link:https://lore.kernel.org/all/20260803062056.1518070-1-ye.liu@linux.dev/
v2:
 - Patch 2: use regexec() directly in get_module() instead of search_pattern()
   to avoid excessive debug spam for the common vmlinux case when debug_on is true
 - Patch 2: anchor module regex to stack trace format "+0xNN/0xNN [module]" to
   prevent false matches on kernel thread comm names like [khugepaged]
 - Patch 2: add '-' to regex character class to support modules with hyphens
   (e.g. aa-bb-cc)
 - Link:https://lore.kernel.org/all/20260722023726.600200-1-ye.liu@linux.dev/
-- 
2.25.1


