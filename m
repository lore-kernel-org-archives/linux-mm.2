Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE0D606B436
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 17:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DXyUIae0
Received: by kanga.kvack.org (Postfix)
	id CE88E6B069A; Thu, 19 Nov 2026 12:09:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC06F6B06C8; Thu, 19 Nov 2026 12:09:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFD5F6B06C9; Thu, 19 Nov 2026 12:09:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96ABB6B069A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:09:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C805120BAD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:09:48 +0000 (UTC)
X-FDA: 85452505656.27.BECD9F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5809A160019
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:09:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DXyUIae0;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795108186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjTIY2UGx1NhgSjOcEomeCUaUU2lXIF0XQz2S9XVKnQ=;
	b=WPwjQ+rdYL2rJDgRAMOVsN97dmz77q/xLesrSmMWNn8lxi3L39U2dnI8idhGqi3YFyXwcm
	2ZV9BE2ezyenjC5X1W5X+8sybthsQnh4D9b3vc5FXTuYjkz1Rj2MuJm3TmFEHQ11IgK8WJ
	60NRKDjLmEalm+5qYAA0YGU9g18nPa8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DXyUIae0;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795108186;
	b=OUN9s9PW/N9D2mwR/foBEM+a3/drdJgE/Gfg6mk4P8WNZD9hOFzqOLsd9FHfoT3ZoCjhE9
	Vd51Sxh5jepKjiPu7v9Hc4B908Qf9U+6zHt9Pkdh/xTZcd4mCGupOUq6uGFBw0dpKV2GXn
	z+w2PKZtxiBYMQf9XHPQyihst31jEfM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C71F402B2;
	Thu, 19 Nov 2026 17:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F21E1F000C6;
	Thu, 19 Nov 2026 17:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795108185;
	bh=kjTIY2UGx1NhgSjOcEomeCUaUU2lXIF0XQz2S9XVKnQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DXyUIae01T8Xa859KkxQde5Jcqqz5g/qInarIp6L4ZYzYFFQ9+0xEtGhX/UWCo1vT
	 QiBN6T25udIt0yP1xSZ/bE/BuXPLlatRUp2KwVXdVQOENKb1imYQ39kK+K8Dd3lrh4
	 WhjrANW5+l+vCNu2TDg4DFfQYsP44jVxhn0+9CRbNH6V1nhDpyHNfIMLtq+M/R/Q8o
	 l/wQaF/vEKaMwVkHFbc47y9VcxiSdVl1jjyLmB4PsNERY9LsxJoDLxjvZfU/63w/s7
	 DbTH37N0wq2TGfBtkGPmTySsX5Pw0lt4GjJPmiOE6OmAx7Bg6RFoOwcS8aiLZvSUeh
	 85oIPYAbNhA8A==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
Subject: Re: (subset) [PATCH v2 00/13] mm: batch of (urgentish?) fixes in
 oomk, cachestat, dev-migrate, percpu
Message-Id: <179510817294.6189.11093382716469445160.b4-ty@b4>
Date: Thu, 19 Nov 2026 18:09:32 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Stat-Signature: 9ysy14rtp7ooumaci5pr6y7mu4fjd4xe
X-Rspamd-Queue-Id: 5809A160019
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795108186-238436
X-HE-Meta: U2FsdGVkX1/cDCX79bUvy3E6eJkvKylV6oAgvS6Gm7k9Int27sTPF4XJR2SYte4hcPjSViKh1gx5AwvJpwSPxlNZvCz3hXmo3F5gceaRfo2Go7cs1q7VnTOoVQFS/9z34WgN7nYwpChZbVvKmiAtSKBlzD6tojQqYTIPNSmlBm6iTJNTUGPAsI9YQTU5THkCwaLeLx1hKlh0g7jNseZWTZ38n0D78KjDdkAe5ghTWQ6NZ7PZGKC275l72C+kuu9J57Iebnnr4k7AG5IqBXBmh9inWP6up/kr0V3aAFZvosUW2X0cPjuHAIvAVqQmfoOVCRfJ6McIEWo/wZXnSlOj4pqtIMAiqIquaBRTrc0b47YMeYedjZ/q7dVQ+Z31IujsKhRaR2lu6a5DNV3zzuM1ws2gCFaS021J5nMWEix3znyM5rZru6h7uAmiyijS4qZIlwS9+86wVp0t8kpBMoINmbOQm3Dt4F5PdwDnR6+vGwfR4rIqYUMu/ZiTQKtOHhmeoDZB8Fuv5BULkbNLSllgaonc941btC020bj+3Mv9nJ2rYbMRdgNMIV3cWYWnmzN3DVvKpGYMBo/bdlZAAhxeJNT73d4Zi6uROpk2YcaJG69PBjtoWx1MjCxxEEmavxn0yVwD3XuBWzQUD06MomzYM2GhL/uXGBZCdgWf75SkG/OhEpthmzAqxD9Xn3/8LV8eKzAYMbe6YBZH1gsnS3aw8w0ON9A7yANxKr81HVimaxeML43jkNSgJiXP+sH5/TudVtOiRyaO2Ql6Amr7V+KNr1A56s023Aa5Xx7oaktT9R5/9bYLcPagN+4rCMinIYeVfRBvYC83mPbyXOdvqoT6mXDF4roBFvhksr83E6rcB4JoLB3Oj1FLcuTvXh5tVn3UYdqIM4ea3V9qu2NzHUDMpHYGlQHbWxPG2pYrGxi4afgzcWg3Ql9JNscqEJRlKZvLfSp5YLEO6Tl2dWisgvy
 pBpxQCHa
 GdTzqizHk8X7ftk34uy62KUYDOeouxFHh4FMPlJo7HrGHlMV3VboZxo7m8K7rmo9q+t0jG6PELZkcX3AyUc9p0nsBJOqv8D2ROwl9niFxHpzQoGJlHNrcMUTJDuySrCAyiK8u2pD8tIikqVvOjFcK/9FaDfjQL1J0re9KnjiBr4JT1tsyaOwQqRpTyrnLDXfkxi4oqszkJ4D6JHC2xTB2K/Hl/PP5PdkzDkl4WYi9MD+JLi1bqayYJGa/7L9/G+Hw6nxnJHj78X4zitxFimjRNlM9eXTKI9nxxOQvwz3cyUXDClF9JJR6iGsVk41SmBLOifaQLiWEJ7sdAQY/mZnhy3ZOjzHWFjU2G/PJfnmcwvPUWig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 21:45:18 +0000, Lorenzo Stoakes (ARM) wrote:
> A bunch of fixes for oomk, cachestat, device migration and the per-CPU
> allocator.
> 
> These patches were originally AI-generated, tamed into upstreamable state.
> 
> Some are more reworked than others. Those which needed a significant
> rethink are submitted as mine and marked as Reported-by the relevant
> original author, others are smaller edits which are annotated as such in
> the usual fashion.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: migrate-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[10/13] mm/migrate_device: refuse to migrate shadow stacks
        https://git.kernel.org/mm/core/c/62fab3eb

-- 
Cheers,

David


