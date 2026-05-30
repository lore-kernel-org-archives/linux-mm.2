Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A830CD4F54
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 00:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444C86B0005; Fri, 29 May 2026 20:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C436B0088; Fri, 29 May 2026 20:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332876B008A; Fri, 29 May 2026 20:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24A3D6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:28:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1D7C1A024B
	for <linux-mm@kvack.org>; Sat, 30 May 2026 00:28:09 +0000 (UTC)
X-FDA: 84822199098.01.FA6556E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 29BE780004
	for <linux-mm@kvack.org>; Sat, 30 May 2026 00:28:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B9YP5sjw;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780100888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=05VuIf28x1kwUtDQQxztMZ5Dutlt/L3Du+VseyWwTYs=;
	b=KNuFRnQY+y6QjqukVlQc+O0CvJK6e/MAjl6P1TdSFeHKcDenJZ9Kibu9rIO8cdVtpUUC0G
	8t1hiIzya3+6wW+8A6JltXXqjMJ1P7mm8Ps0PtVoETvHaeCndL0MX2gaI5qzbxl4ry3L+C
	l03UgvFGd9Uu4D6ccYKXFC08GOqHLuM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B9YP5sjw;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780100888; a=rsa-sha256;
	cv=none;
	b=OqU11bMbjhLgGmwGv5eBio8+In7FWDU/er726MUZ0WfNgSovBwErUiPSRMJs1KsZZ58u73
	TpKYc0UrNtj54DXR9BEnGQvLOfXKa/qFZLPU4nlSYKCf/rZM1BYT//lK4O9xzmVkndPz3u
	DhGoBYz4wILcibd3hvV3Gl95oAbTxZ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A48A160103;
	Sat, 30 May 2026 00:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FBE1F00893;
	Sat, 30 May 2026 00:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780100887;
	bh=05VuIf28x1kwUtDQQxztMZ5Dutlt/L3Du+VseyWwTYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B9YP5sjwCnpBB+zSHP5Z25aJX5n5GnNVmimq2ROR/HujPd5/3lU4JkGq0fVDunhll
	 yW/5zdkc5utsLp130I6WWKQEH1hrMFa2VB1XiGWj69Pg6g2PGZOw9YkXfiqjM009/J
	 wfm4OdbnkbGvZ4NbXRG50OG3U8o/PSw2Sent05iRogy5vzF48+0qVpn8XL2/nrp3T+
	 hzX/6Cv1BOyI277ip+rYOaZT552MAIPejqSI8pVN9sSMMqWSzvwBKuAiilPjVNwWAe
	 Gl38eRoaHUfFNsEK+O7A8zQx/pQ0gu+AAFI681XDP6gojyIAQyqdv7FN0kXejRi+xe
	 OBmzfJERHGl/Q==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/nodemask: Correctly describe nodemask operation return types
Date: Fri, 29 May 2026 17:27:48 -0700
Message-ID: <20260530002749.87977-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260529202755.1846800-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9kqpr9x7qgfwfw1up71yt7zc3y7bh9md
X-Rspamd-Queue-Id: 29BE780004
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780100888-564585
X-HE-Meta: U2FsdGVkX1/52fpM27t0ULmqKFRJwc9mj0GV2NRQK3pe7N+1dqKgTdhjXtGu7VCchgatP3ckY18EQvuxIdjFrVp4i7mcgAmITGPclqvs/33jfvhHlxgjVvNA4fkDCZOGqJdRftcwC2XgaA7VPutlKk3WdieCp/u1OVgDT5WahHdZGgHV5wCxml16PU8bvbQH+cv6Of1Mg+9JHnmhE2+EwieZ9pz/MlcorDUEOm2YBR8Yw/yDVJGfdQLuq7tDHu7TQtorVucrVBdVQ6Q829jwenrbd6itzNDcr1GFAPc9FfdG8cdtH2HuSqwIbrdrlQ7o5x1VBgwV8hkJ4L/VcQW1Cyg9xa1vOQjdM3eZU8i4TWPFkKnYkt0/b3lkrrD4ANCzJYZOD4bYybXVy7edDsMJ+TShl6zT9a2Y0UBxhxFDrdyN6VLelIQMMusLgeuds/XpRTBAJ3jKPzEn3nPaTWHPHAwjRJmHh6J9TgOsK8ILJN6YerbphMEEak2soorfxeTbsI85w3J/HjY2HBx97sBtQdkB/fYUUywSudrw4Hfj5mKXLpcFTJXtfOBT6E1euEXIjTFga39lxGM45x43laMIJeIus4+yWSq0uPddlA7fNdzGd9KSL1bucr2BJAwjdO+ZAkPe8ptRkHZP4P5vLagpqdQzCIF9MNwkH3+Mi8ZWI84jeftyWq5H0/VQ5+/+weYMnYMhd7Gf3cmII2HQnfPjwaFY4S83OHzCodPPueosc3PRVmZvMhjskFFOAqrA8o8X5Uzcb/7RZlS/+FxoTE6s4ZPqTcstlZuLWJgsXVKwi+KC/1z9eY5+fjhpLUoPVX90Ygegp8c+vtFm+kqzZwqOHH1rvkSX/62pJ3PCyBLXx+1/YQCrl4iDUkwnyHtVqxbKP0XsVdzsdcNRCPD3homOrYAq6OfnHux9dK95kD3mHrkjJeLHJzeNGzdOYkuAopv16LxvaAH5NDSUi/BNWEV
 J5nJy11p
 /Bx9JhY5pZLoelqzn9OVK/YzCboIEVT3zssIJM3B9Ia/1rsHGXngncuggEcvzg4qCd9vBvhHXMlLDMnSy1a4B2ox6rVkZLG2GpO46xz2ODZ0SCu+DMiTq/yL2MEnjhSuB528P7sJb8ae4LT12tc/UcHsT3S65Ss2oVxuMWA7VHUnLFsYJfCYwbw5SFw9qA5SXg/1pAenDXRTgX2zL8JEukrdA5RxX/3R9/FUq2eF11mOT6CVtjNU6xzB7NSFkBFcOhw81ILLs/n2Pzfaf3TkFsNlm4bllJHirMHXGx/dYGUmWtrQ/TZxibIecEHFSUKnwzoQ1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026 13:27:54 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Commit 0dfe54071d7c8 ("nodemask: Fix return values to be unsigned")
> changed a number of nodemask operations that used to return int
> to returning a bool instead. However, it did not update the comment
> block that described these functions, leaving the documentation
> incorrect.
> 
> Fix the comment block to accurately describe the functions.
> Also fix a typo (unsigend --> unsigned), and fix a callsite in
> mempolicy.c that did not get updated during the conversion.

Nice catch, thank you fixing this!

> 
> No functional changes intended; changes are purely cosmetic.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  include/linux/nodemask.h | 18 +++++++++---------
>  mm/mempolicy.c           |  2 +-
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index 204c92462f3c0..b842aa5255464 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -24,23 +24,23 @@
>   * void nodes_setall(mask)		set all bits
>   * void nodes_clear(mask)		clear all bits
>   * int node_isset(node, mask)		true iff bit 'node' set in mask
> - * int node_test_and_set(node, mask)	test and set bit 'node' in mask
> + * bool node_test_and_set(node, mask)	test and set bit 'node' in mask
>   *
> - * void nodes_and(dst, src1, src2)	dst = src1 & src2  [intersection]
> + * bool nodes_and(dst, src1, src2)	dst = src1 & src2  [intersection]
>   * void nodes_or(dst, src1, src2)	dst = src1 | src2  [union]
>   * void nodes_xor(dst, src1, src2)	dst = src1 ^ src2
> - * void nodes_andnot(dst, src1, src2)	dst = src1 & ~src2
> + * bool nodes_andnot(dst, src1, src2)	dst = src1 & ~src2
>   * void nodes_complement(dst, src)	dst = ~src
>   *
> - * int nodes_equal(mask1, mask2)	Does mask1 == mask2?
> - * int nodes_intersects(mask1, mask2)	Do mask1 and mask2 intersect?
> - * int nodes_subset(mask1, mask2)	Is mask1 a subset of mask2?
> - * int nodes_empty(mask)		Is mask empty (no bits sets)?
> - * int nodes_full(mask)			Is mask full (all bits sets)?
> + * bool nodes_equal(mask1, mask2)	Does mask1 == mask2?
> + * bool nodes_intersects(mask1, mask2)	Do mask1 and mask2 intersect?
> + * bool nodes_subset(mask1, mask2)	Is mask1 a subset of mask2?
> + * bool nodes_empty(mask)		Is mask empty (no bits sets)?
> + * bool nodes_full(mask)		Is mask full (all bits sets)?
>   * int nodes_weight(mask)		Hamming weight - number of set bits
>   *
>   * unsigned int first_node(mask)	Number lowest set bit, or MAX_NUMNODES
> - * unsigend int next_node(node, mask)	Next node past 'node', or MAX_NUMNODES
> + * unsigned int next_node(node, mask)	Next node past 'node', or MAX_NUMNODES
>   * unsigned int next_node_in(node, mask) Next node past 'node', or wrap to first,
>   *					or MAX_NUMNODES
>   * unsigned int first_unset_node(mask)	First node not set in mask, or

I feel like this comment block might be easy to be outdated in future.  This
comment block is introduced before the git era.  I think this was the best and
great way at that time.  But now we have modern documentation tools like
kernel-doc.  I'm wondering if it makes sense to convert this comment block to
kernel-doc comments in long term, after this patch is merged.  If we sure these
APIs are quite stable and expect no many changes in future, such conversion may
not make sense, though.


Thanks,
SJ

[...]

