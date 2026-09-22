Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 604E4C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7184F6B0098; Tue, 22 Sep 2026 08:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9876B009F; Tue, 22 Sep 2026 08:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8616B00A0; Tue, 22 Sep 2026 08:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3126B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:31:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 39DA91C29CA
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:31:58 +0000 (UTC)
X-FDA: 85241335116.19.5E1091C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A44D0140004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:31:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fY5Arxmc;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790080316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wgfbzJ9oPP9ly+/ZofI347OAniIHtGHDp63c7r9RtT4=;
	b=sFQJxzW6PSQjI4ugzqkTvAmxviXqislREGqJt1+2fiP0EFSWkAkFEB2CW07K/Qu98zWjnx
	YRm38ZH2SDlQOKRDZNkMtbIQc/zPH2Hi9w+sV/wuDd/Czd+O8qOTHpDLdou+NMydNBxAbl
	2LqOn6auQ9dpt2OoJZvwq8/8BIIunas=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790080316;
	b=Yi2ND0jjMOlWuf8uQAk6AIUBmYd5eVDguK6i0qaVp1fia7LVr+RTP+39OJkEWM8Vg9Gkh9
	s+nOWPVYq+XxCthqSnfR87KWyhjuQZY2PdM2/g2Q0sWp3FK4/PtcKvTosC204jDTtKNin7
	qQB8jJPnseMilEoipZv/nQPIRcR+okQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fY5Arxmc;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25BB76021C;
	Tue, 22 Sep 2026 12:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CF41F000FF;
	Tue, 22 Sep 2026 12:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790080315;
	bh=wgfbzJ9oPP9ly+/ZofI347OAniIHtGHDp63c7r9RtT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fY5ArxmcNAiTphDnL8XETO7h7c7so5WH/19YBz/+V/PjJVShyMVeAUSsML9ehwWb4
	 PyYOkN0udxEuDF7kj8k0wNJ+deK8I65tG+zisKoRb6PNH5vT8iq7SvQP6GVDcf8F+D
	 iDYHJpIxz0nqcVpZW5pSICkYuBHeUkFUGVWyCx206oW4OXhsVSyIY9TnGJ1i2t92wW
	 1dI/c3n3/QFD1q4zaBmJgZNGtzyyw9koY0FKXAb3yf07LR8iJ8j7oDkdfCQO8IAuJU
	 bZYGEYHqi9iAOYBKI9lgJq2Fa8U5StBWZXawA81BG7U/bJ6qQk0VQmqmIKqrPvG3oJ
	 NfxBE5kbHsPKg==
From: SJ Park <sj@kernel.org>
To: Zhijian Han <hanzhijian1991@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Alexander Potapenko <glider@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix typos in various comments
Date: Tue, 22 Sep 2026 05:31:49 -0700
Message-ID: <20260922123150.2763-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260922031843.2857104-1-hanzhijian1991@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A44D0140004
X-Stat-Signature: chhjuxr1wnk9snq4ac9y7fk48uympqxk
X-Rspam-User: 
X-HE-Tag: 1790080316-258786
X-HE-Meta: U2FsdGVkX1/t0ONz205zG64NaT+ANSmTPoh/4qDZ2qII+PaXp/kJ3VqjShSKqz5wwfh7XleMxcf79G6t8Jxc9MFJM9aG39u0XXwubvvugqMM9XSV9xTJQTKTLs2elpULL1MdVmBGe73p2sL7jjVV7t68Kc0Si0OCnQ1O47sFodrVovh5DmVhKG4A/Atm79rGGAmsW65mYsnzwlKQe+ONdlypn52dIurzK3aFk0bnC4o/T2xS7yJhPlfMPyjt30bcE7cew9bF24/foD6eSI+6wX994BpN5pzL4Ho9uu8oXdvUKDN80QW+rK472NZRfJbriDKuvHrMT41jqPR7L0U9QCMCeko9XL74o+/GMN8BaOUy5CN7nx26/RpnduDfxrXUz64xDKMS19tsVPYoqBFZY0d7UgLYOEO9NmJLuHJNBh2xkkbpDU5gcWac6SEFtOCRmHN/pUe6izNQJeQGdFOZNtHxqiamACwBOKFN/B/bAZBYwOSx5Mjh2dkZ8U7RxfiQ2nDQ/xPYfD6Dzpe7988NpDHNVCKnozfwX+K8N5LHapuPDyR4eK8IuiPebahfWXYwIB93sY2KT2W8ojOz+cwfZMck4PRU8y8LDntS6Ah3uAHn+NEeeoZLYCubT/n6211k48jtYWXxCbQxkEWkVcmTwJfhB+2DEyYcQyx8KSKvb0KgKwTLeG0IW1gu57joEdQRe6VoEb07xZ6oDAvl74wiSdyUAW+erYUJkedskG6qjUwQ+oj6mu5cZrwQJzGtkGr8uG/jYx/bzztn3UvFAx7XbOUUT5lhHz0jjb2rldF31jfg5+hl7gCCFrjqitFK3W+8hx1ayXXTEI9H1vtdQt8gtCes2ymLReWA1ELEY6jpYuUUQlVrhbHkmvpQufX5/ESfIYNa3Ljkg8041Jsj/uq1obFue1++9K9g0Hwi+5CoUgw+Ni93MZn/TzQV4DvduKoyNGyuP8B8pHq1u2orsAt
 aNyXbBpZ
 3dojo2As73CubOQIbZnKa1oDDh/KAS3Lq4mnEfeDpdNxk6PXgzfJ/bKrUGtDOk5mSs1uJwoMRzReDf79aR1RZQW+9KGJ9hfYJM5s+W/XvhQDhfEisQm3ZPdbEBYu7hi2cdtQtCJY7u9usKi4D3c93t6NaedyhpCZa8nOdV+SCNUinBhbfyMzpq3GFUFvfRPGoA6EPx1wXp33fNw7R1aee339PvOKD5cNo/h+EKVduW/gLcEJmPE4Jnm0ZnsJnzlJOsDDG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Sep 2026 11:18:43 +0800 Zhijian Han <hanzhijian1991@gmail.com> wrote:

> Fix spelling errors found by codespell in several mm source files:
[...]
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2328,7 +2328,7 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
>   * This function checks if a given region should be skipped or not for the
>   * reason.  If only the starting part of the region has previously charged,
>   * this function splits the region into two so that the second one covers the
> - * area that not charged in the previous charge widnow, and return true.  The
> + * area that not charged in the previous charge window, and return true.  The
>   * caller can see the second one on the next iteration of the region walk.
>   * Note that this means the caller should use damon_for_each_region() instead
>   * of damon_for_each_region_safe().  If damon_for_each_region_safe() is used,
> @@ -2486,7 +2486,7 @@ static void damos_walk_call_walk(struct damon_ctx *ctx, struct damon_target *t,
>   * This function is called when kdamond finished applying the action of a DAMOS
>   * scheme to all regions that eligible for the given &damos->apply_interval_us.
>   * If every scheme of @ctx including @s now finished walking for at least one
> - * &damos->apply_interval_us, this function makrs the handling of the given
> + * &damos->apply_interval_us, this function marks the handling of the given
>   * DAMOS walk request is done, so that damos_walk() can wake up and return.
>   */
>  static void damos_walk_complete(struct damon_ctx *ctx, struct damos *s)

As I replied [1] to your another patch, the above DAMON side change cannot be
accepted since the same fix is already suggested and accepted.

[1] https://lore.kernel.org/20260922064216.43053-1-sj@kernel.org


Thanks,
SJ

[...]

