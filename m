Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9039C5516F
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 06:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9116B007B; Mon,  3 Aug 2026 02:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A3C6B0088; Mon,  3 Aug 2026 02:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A909F6B008A; Mon,  3 Aug 2026 02:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88E666B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:21:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 18308805F6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:21:57 +0000 (UTC)
X-FDA: 85058962674.26.110E526
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id EABB94000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:21:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eDIQEkdK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785738115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WHgL7q6z3CErxPHvG+ihsc36p4rExS74ePzEBVIZczI=;
	b=efAiXYXj+5yt3zI+mfKnw96QQ67HG+auO7jiFqQDA0ClVCSOiiEHsscWlnROiioh6DpjfW
	YSLx31IpWQLu+Q0jPlJoOgLEEAyDGYinTJICsQaxuGS45H5D2LKj/kpf+3t+JaoPYWO0RB
	Ot8001/L5l92KXEWwjHp/MkSPy+3xzM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eDIQEkdK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785738115;
	b=xR7Hh258RPRDvxKAsIhIn24naRXHm9SFATstVsRAFEW8nQ70H75Weq92cM0cL1yQwLtk6I
	Nz8/lfKdC/lUzDJEHF7VhG4CTDmFDyfMts7/kNu7KDrO4Uj66Tig5MLW3b05OAAyoSDLcG
	0uL4DP2GsEz/SSLhVl5SQCf6yBEjZZg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785738112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WHgL7q6z3CErxPHvG+ihsc36p4rExS74ePzEBVIZczI=;
	b=eDIQEkdKSqUxjkFWRpEuniHO0LGOE4/4kwl/QPsPV1NGJ1SFLv1Mh68jSLjF8zpw87rZsO
	TKuvN74DSwzpXsYdXhDjSshfiXAS4f8TvZ4VW8bULIjJMMpvaOkGL6FgXf+isjMnr6TK4h
	HB+0yntqP7v481n2+yWdFQC6Ot1bxno=
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
Subject: [PATCH v2 0/3] tools/mm/page_owner_sort: fix --sort, add module filter, improve usage
Date: Mon,  3 Aug 2026 14:20:53 +0800
Message-Id: <20260803062056.1518070-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EABB94000B
X-Rspam-User: 
X-Stat-Signature: ifgap7rjsuzx88739jwbb7ooysby3gnq
X-HE-Tag: 1785738114-957190
X-HE-Meta: U2FsdGVkX1+U0ejmIzCwHodj11JfDCrPSemULn2r8vCFIlaNZGJDBc4zOy1j9UyK/JbuqSVQHdq5HqjciuQjeVnv0bi568PQswUgav91bFRZXaGV+V4YPBRXfruADIzj1Y4pOLU49O26NHMVOBE+Cyi1tjCgjVxc5/4oz0yDSCj2n0kZ5WgNntmBLHNL1Skfqn5miWS5qdNye6xl/Ro471rOEKUwwbaYuRHuOM8pd03Itbn2zkdV2rejDhSCS3EnViYFWTuOtVTBxZpeqmbhzbhKZfA33f7WPckcwMl8uEWNsE7oETBBsLdrXGxcdGHl8E1l1irIhy9dOzN6dHXEzU76OUTXyCN2y2HvqQ98CO0TLAXtlK+4Tas22TchWg4QNlFj8khwkR4AXKtcCkdwnsyI+0K/NQXLu19PoEz3n6GrJuoa1RgDoPxcQKQbJ4tzamy20EV1F9k7q1j/24nZ7Xt8zPXPfx6rXBS+hqtu3BOZhWXxRV9q10bM7KIPxoZoEDGo6pon5VAoYqX4kLS4aB4Bx6Za51/PzPmzcpb2242LGQ9EPNsbhcCmlzU9T5LXj7ygNt0Nsa3yPHRUj1+rN1FVYoF6+5Y4c0Je1qs4e1OR2vHv6wJ8fpmX/0cp/TfD6s8I3Wm3+FRRAhDYvIpCOvWT559bJNJKb1BBWMLdosBo5JaBlcBne9oGgrSmN2s6dUK4xmoA2Eovxc8/SzsiFhkVT6G/jfNutqTNJ3T1iOovJo/tU5EdzqAJc2SplLqqmAL5wFFA+QlsLpFzKF42QdJRlD34bDqE1vRBc8Vam62Y/G+4eI/s3ArMDIZ/v3aXaxHW8qFPJ7UhY1aXemG88ibt8/Qft5YtaDl0gYRZibovt3G89CzjjC1198orxg9RspDNDbCaFJdjMgb2cxk7YxrmVn/RtVsDNPE0dsgNvR0mtbPn79HUlwcwCoZK4p2rqD/OWdOefQTww0YSzAn
 yVv/7GZH
 5jKap2uqmLxuf5uOY5vUJGwWfDQ8CYLTpBSQJvGLip424X7CPsNwDN9ubBuE5vS/9X9nhBv49ffJnxJvLRdRP6aWJ2JLIGDOC6V5rJiIOi6hkkugHHjdhfbfhKvPkrWOY1nU78yAob5TLiby/yPZ0kpH4sjCIR2D5Lkmy+fcQkr9wAuLfyMsGlf9s7WFF8F4zBG39/b4KwTSZQ/a7in+V/MjWwKdAh5paHCSm9hV9peGXUMG9NRh+Qo5nbX7rMXUHdxKh8Liv1jaebbbmwlLChFrK3aX02ocpv3mCHDDQwaLjQ18=
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
 tools/mm/page_owner_sort.c      | 135 +++++++++++++++++++++++++++-----
 2 files changed, 123 insertions(+), 20 deletions(-)
---
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


