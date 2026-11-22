Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A736606A333
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kP2ZwKLJ
Received: by kanga.kvack.org (Postfix)
	id 6F2536B05C8; Sun, 22 Nov 2026 10:55:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67BB76B05CA; Sun, 22 Nov 2026 10:55:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56B4D6B05CB; Sun, 22 Nov 2026 10:55:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 297366B05C8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:55:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C0741206DE
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:55:28 +0000 (UTC)
X-FDA: 85463204736.06.C80AF9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6FAB340008
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:55:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kP2ZwKLJ;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362926;
	b=oMrZrBCGu1YccWFstixqj14Sap9mS9jajqgOO4aoqF7xdzpKvDp7LZedhEeRF5hTTQc15O
	S8yvpqWLmzrW0/nJ5orDbVP8koLgutati9gkCBC71KXWMpzEAFoU8f85xRxTSPQFEKNKjD
	/KGS9m1ov2ZFnmuQsxfrI+n8H6z3MT4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8uB9TUoaK0EwcPdykqZJN2k18gBtw3+WNOXzc7jc1Ow=;
	b=SZagpozLtpw0feH42xLprljpdx2Wx4gEgdr4/4n0VdlhQnmeWMcmBA7rrd6N2+cj5Ho2eq
	BRBU/azMzKle/uh+OqYoAEdxY/fhjuHWWB45AzLRkC+6W24dAMcGqzKpWTyZBdcwsCj+4+
	UyWYImTfvBxxyc0SOO6HfmoJByG/Ue0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kP2ZwKLJ;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 517C140748;
	Sun, 22 Nov 2026 15:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932401F000D3;
	Sun, 22 Nov 2026 15:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795362924;
	bh=8uB9TUoaK0EwcPdykqZJN2k18gBtw3+WNOXzc7jc1Ow=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=kP2ZwKLJeJwsViHkCX55ky7IhiP+3smbuMwEBInHWWEEeV0ZYBqcpyzNJsHW0A8Ud
	 dbFSRCYH+rmB9iQO/qK8BRRXxxLwuT8E+geJ3YT96hQM2XC3Fjtep4GLnOB0/68u3u
	 T6C4MaYFNMXm6sJ8L5+3WINBpSQ7t4huLi5QujFMpxNG0H2chHfkOAI+2ldb3weOYQ
	 UlnSGFKGNIIaXFMmJiP9PVZ/1MPe3bdvYvG176oICuUDESTclpsAv1VcM3mw+58NrK
	 YWVrUOSzuQ4gTQ1MGe3nmHDuW3rqdivJ1gqgZbE83diZwGVNEGLSUOBb+efHS4q3NM
	 BbNj1+gez26JA==
From: David Hildenbrand <david@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
In-Reply-To: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
Subject: Re: (subset) [PATCH 0/7] mm: reworked AI-generated VMA and mremap
 fixes
Message-Id: <179536291830.3243.152389320315927715.b4-ty@b4>
Date: Sun, 22 Nov 2026 16:55:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User:
X-Rspamd-Queue-Id: 6FAB340008
X-Stat-Signature: sa5cii5ti5x4oafxpkfid5otyszxod4u
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795362926-959362
X-HE-Meta: U2FsdGVkX1/yhZx+9a4Q+/p2bKBmXqd2n/lIlkJEePiwhNkCIXidBZ+FtMItLgcAGL1HzMIvWE2HGjQ6702PI588H7Mn3SJYPhzyO8T4PZcBHLUVZnx9SypPRHNY9S9p5V8tYWNyBbRSyKOd+UmUE8kRhdTEbzK3eOJ6R9knSpX4xa8LbZ2B/VcAoTDBjSKDKEFGHIhhQcRRiLWKr5omfKe1Wk9x/q5w6DcdoftZfEcoEyrzs603i5u66/7N/NFajUDct7FUrz0DxddeINUYYVkOkGP3EpRnG8rkF0+lgXphcFStkszR3Dovlcv2aQuK+rEKH3G38jmMX6kWJPuF6/0ruC9wYrg0ZOf2zdv8zycQXA9R9Qv66w1AV6kw9eMRCv1KFp2ENiUKUYG/ASfGbg8LCzEg0kSj5yNSV2kEQmQog0IfHkLc4pkVSAVIwXcv+EYFM3pjcGaXDgfMKt1W0lxQ1aoVxdw5seI1TOU3ndv0cuiXMGhklGrZnubgM2Ux2U8GN35WxMyVFYzCSQkvD2i3AH6wnhd7yXBA8Wl425atxhJE+vN4kW5qRDRsWb5FBwROwrZkzrZ0Yn8psAVlbmc9fMG6DLAtaGkSzfKGBvLIRviynxYKpD3l/4W9bCFO6qs/1hnkTKV3Z44HRYCOgFczJ9L8A4J/ZwMWrpo8xC2GgUi2k8y5rvw0pyUOhGQvkf30fYdIO0+WgG9wF+8YTve2sJYim+N9deL/odFmQI92NxKW5dnMZoAySC2MXEIIJxZhs5NwVf2b8CFhpvSPv2m6rn2JaeLHAtmjkQdFavmvwpycFhnde0wZFjcZ8MAnwpAWxzQas0fwZefgIRde7VCkKr0GSkNGwAI60eDQdfXW7AlgNRnQvdmMpYYrvk+f5u8n3dSls64zazOAo6kYm4XOS9OY4eUv/yDI3+BI7Ivt12YR2fMcQ+lHpBU71eFW0Ljt05U4JcBjdUJnx+m
 EdWSSNIF
 GNtxVKBSHvrwGquhJjz0fGtw+0L2yuYif/hgW9L7G8nNWvfgfYlmJ4+IBY+n+tkhwMnsF1j1CKeBz8wmwycVzbw9idjtNvRhkaPJGkY+GqM+F6qjw6EvRlv0xYVtDLTiibcDAEcTIS0MLqnHERaW0USDnk1vfTv+mfffn1hXPgFWOUQDq6OYWaiVjt7BM4TV8K+qEqomaply7YMF3X7qHgh+vEck7YzDcZiCweGGpq5dVYalRWppWOtETscw+m3ALRmnl/xNq2TQmo4IPEMX7PWYssZaffCnMeDvF9yDbeRtMiIBKpJ748rp4g8qJjzJpkZgSiVeLGn7oAx2T0A3cJtUzVmnqBf+xcbBYD/Sm018p5a8U6aXESVZO37oDfY0KIrcj4r3kPpdYiAc0OujzuP4nFtAJ3iwEyILfolwM6T0f3gapp9guvbBcQYF97AdljqquZv31eRc4SR6XPSZkZAzV4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 16:02:26 +0000, Lorenzo Stoakes (ARM) wrote:
> I have reordered the patches here by priority, David - the first 2 should
> be prioritised as hotfixes, the rest can go in 7.5:
> 
> == Critical ==
> 
> 1. unmapped_area_topdown() invalid bounds - possible memory corruption,
>    triggerable by any local user.
> 2. Lock VMAs before mm_all_locks_mutex - system-wide unkillable hang,
>    triggerable by a local user with FUSE.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: ksm-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[3/7] mm/ksm: only interrupt unmerging on a fatal signal
      https://git.kernel.org/mm/core/c/d90efc5d

-- 
Cheers,

David


