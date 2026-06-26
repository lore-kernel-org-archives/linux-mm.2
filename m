Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F27AC43327
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56E1D6B00B6; Fri, 26 Jun 2026 10:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5456D6B00B8; Fri, 26 Jun 2026 10:59:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4101E6B00B9; Fri, 26 Jun 2026 10:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE526B00B6
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:59:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A02D28E459
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:59:27 +0000 (UTC)
X-FDA: 84922372374.27.2565F5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0174B40003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:59:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UEXyo0RY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782485966;
	b=BSozkbvM+vvdaEhw/zSmuZNKqVTWpY1votO+7BRaHz/GPGjgWPgKK+tmbdfL6lqD0fy3Ll
	qBjvk4xqqfaApUDGfizQoXFy/s3qmoEpLNchIKO92vZOy36Dsb/y6TCSoSbLJDpIEqlpCV
	3mdBi0ocX7wGfK2Xa7w5/AKIjuMtx24=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782485966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9LvqpwysSqofZzAIdP9KQqPtkdx0PkmmB9N5eDhoqM=;
	b=UkBYRV5LUIXOM0P/0ex/yh8LNSYBhqOd1dD5rOZ+RwMLU1nhqUyjNQFbeXpH/D9rm9eeCm
	cH2Co9k0ZuG9DvulE04bIkbtrdLCSg6KQ9AZ5i6qKrnKUQ9csZmQKh4P/UddMnKZjLU/uT
	dmP21HE5+r02CLLLk17NVggT3nL38xU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UEXyo0RY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22AE741616;
	Fri, 26 Jun 2026 14:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BF11F000E9;
	Fri, 26 Jun 2026 14:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782485965;
	bh=x9LvqpwysSqofZzAIdP9KQqPtkdx0PkmmB9N5eDhoqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UEXyo0RYES2I1TolfWEle3jihyB9LeVYjE/KYQdQCdqT+zL3Thznkkv3+9IrEe/a8
	 evwMe7Gs5LCKcdkQLvgCj89zymBD9J4MPUtX1maookb8ha6Tu8ngb4DOUoBiiSwLky
	 vTZQ016vyJVG366HcrGkJAERZlbWsmkR0Dg2P+330kGOV0uOPhw3tp7oOrJqIf2dBw
	 uOfkl7W9abmkfAjq0GNZofBAGtUBELMINSMd608F3NkHBldl5goGzekX7clHPUFSZl
	 S1IhHB6VQ+H4BoDoVmp4/+3tRaZHRW7t7WHCyuEEtvr7F8nm2TX7iHevmyDlH7a/1C
	 h5FpbmULqIewQ==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	jiayuan.chen@shopee.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Shu Anzai <shu17az@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/damon/core: detect internal variation above max_nr_regions/2
Date: Fri, 26 Jun 2026 07:59:09 -0700
Message-ID: <20260626145910.88535-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626085851.70754-1-jiayuan.chen@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0174B40003
X-Rspam-User: 
X-Stat-Signature: xd61gozmm18t3c67ax9xh5won9u9eshd
X-HE-Tag: 1782485965-82268
X-HE-Meta: U2FsdGVkX1/iwozBkZwdCzYWjClb5rkFq8a0828C1R5fjv0vAtNs7Nwr0cnNht5RspIWw5DDluHjgGww2v85UQTmfv2RNciSTyY0saj5hS+OWsiUxByySvmv/vlHqFvbhGAdytsPNF5Sb+AYgkCyD2I8Y5Ip4CDUT7rTDOVW/6Cb1Ls55QPS5UqUIGMETM3H9RlYR0bZQuz9Us7rUM4utd12lZFGc1RQxkFd3t/8ZUfhqCFZkaj0UB0vPqbXXWT2v5asTFzDHy1YYpwz7tSWAeuVeQ1Vt8Zig80YhMi66bdwAhjaeAO49kgA0OLfWR/dlNt4vDJSxdeTrdb7tbGZAU0JS3zuLrbwTmlzx7YYEmt6qhMyDXZ5+4QcXvZ+lCf4qHwsnL617qx059LdRmjlaWsM/B6CmEJFr+vDMPxdWntupW6QAXj3/Gj+HglbeWDgC/0RgdM4JF4Q7HxP3ln8VdRf6y3OIYxv0GEXFq0++wDid5XVuRTfYVYdSPVcnpJjA3aBK/QKvttihMDNp0PWv5PuJQhqViBRLnUnej1veLyo/Kcj+WtcNtw0GZ9CPC1gAh1sDR3mV73qBIF90r7KTF8wPyIId2mjWzW89ZGz4cQMLzorn0LUdNF2lrF+p2wWf4mqZe+6XhUkOLWr4H7U6egmsMKU7e8MXs/R7xZuG87aVm5VT7yNX13+TALC8q+0M/Hoyl8/kUQYyR7lPf/GjWQ48U3BZZdHxcfjMj4Znq1MlMPT+L4PyMrtaeltTQcmwedkWi1xwWgxevkGSV/i1W1uwnBA9ZDS2zw4IkUbNAmxJWsEaiGbcBHHIQtWIptyccCTMIKrEJr6bD1a0Atj1WUFhKxihfQiTSWAHQuNOgVfhf3AuUoyQmnqRUYuBmPcBK+JWguO8EUeTiDeOY9IkSXY/XSQCvw6aey7uBfS1mynCnNq0szaZmaeRRi95nJtLmWL4tAl1l2EBPwy+rT
 NoThfD3k
 I0ZApuaYWmYKnundtVwTkazRB9ixoZ8C/zDiGNVAaoTYkv3btUI+UyKoBbZDoy0XjqEjm9B97LkuPOsWAUIZjsOs4onmSDWf0aLZbxVbS49A6RD1gh/tWGu2LFWop5urRF2QCBrM+nNzg+u7OcGEuL/II/prtuxdg6oxwgQHG6aPe6spkrhdJWUieN0KrclgE0phDi+VPTuUBFndHOLQbvzhIviiqva8ZHusgIxi2RR/WVTu57pmHUu2mMSmc+D/8PsS6qL3EIDFX08BqRm3UKUS/ijYdV6L/rSqekPep4uuDS1wPnUYqr4NZbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 16:58:36 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> Sorry for the late.

No worry!

> 
> kdamond_split_regions() bails out early when nr_regions is already
> above max_nr_regions / 2.  A large region that picks up new internal
> variation after that point never gets split, so we lose visibility
> into its hot/cold structure.
> 
> We hit this with damon-paddr on hugepage workloads and damon-vaddr
> on processes that mmap a large anonymous range.
> 
> Example with max_nr_regions == 1500.  A target ends up with 799
> small hot/cold regions plus one big region (an earlier merge
> collapsed a uniformly-accessed range into a single piece):
> 
> H:hot
> C:cold
> 
>       r1     r2     r3                 r800
>     HHHHHH|CCCCCC|HHHHHH|...|HHHHHH..........................|
> 
>     nr_regions = 800  >  max_nr_regions / 2 = 750
> 
> Now a cold subarea shows up inside r800:
> 
>       r1     r2     r3                 r800
>     HHHHHH|CCCCCC|HHHHHH|...|HHHHHH........CCCCCC.............|
> 
> The small regions can't merge with each other (their access counts
> differ), so budget never frees up.  r800 can't be split because
> nr_regions > max_nr_regions / 2 returns early.  The cold subarea
> stays invisible.
> 
> Patch 1 keeps refining on this path: when nr_regions is above
> max_nr_regions / 2 but still under the maximum, it splits a fraction
> of the regions instead of returning.  The fraction shrinks as the
> remaining budget shrinks, so the count approaches max_nr_regions
> smoothly.  A useless split is undone by the next merge cycle.

I assume you confirmed this change is making somee progress in a test or on
your real use case?  It would be great if you can confirm that and/or even
share your measurements.

> 
> Patch 2 adds a KUnit test for the case where nr_regions is already
> above max_nr_regions / 2.
> 
> Thanks to SeongJae for the suggestion to drive the split fraction
> from the remaining budget rather than an age-based filter.

I'm glad to help this grateful improvement!

> 
> 
> v1 -> v2: Some feedback from SJ.
> v1: https://lore.kernel.org/damon/20260521045236.115749-1-jiayuan.chen@linux.dev/
> 
> Jiayuan Chen (2):
>   mm/damon/core: split a fraction of regions when nr_regions exceeds
>     max/2
>   mm/damon/tests/core-kunit: test split above max_nr_regions/2

I have trivial comments to the second patch, but all looks good enough.

I will apply this series to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

