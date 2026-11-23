Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF4F606A331
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dRt1pSJk
Received: by kanga.kvack.org (Postfix)
	id 4CE396B05C3; Mon, 23 Nov 2026 11:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6806B05C4; Mon, 23 Nov 2026 11:27:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC806B05C5; Mon, 23 Nov 2026 11:27:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 197136B05C3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:27:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF09C80927
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:27:55 +0000 (UTC)
X-FDA: 85466915310.22.97DD9E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DA5F240013
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:27:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRt1pSJk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795451274;
	b=YRLQMH5BiWz9np6QbDfa+bK7Pu++J77PwVu8D/pkfewfXauI3nii+laJAweDQY6Cdfzqhs
	RxMnCAy8yTSL68yRyRq5r3KC1GFSvT5h5mx0VpiUwXUc9G31o0RAC5RxlxkRKwbO7esK3k
	JtqlkQkvmJW2jy09KHAGW6ax1IjYM70=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/edZpvtocFnokGsp1EbOcZhOe9y7g0/5yjPiAkc0Xs=;
	b=cVjXLeleS7Pv6ZjNCAYnAAAK0/lBNXmNqRUyvJoa/oUMyEVvxqvLBtzWS/LM3/nNZQQi0V
	izayfomoK3OBoqBQ6V63lD6vqljQUciuAdI0JUHPIUmqPN9MbC6OGTDCiBswb7gObD1IdU
	mI33ohavSaIm/+HUToeFQdv0CeE6Wis=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRt1pSJk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 320DC40C36;
	Mon, 23 Nov 2026 16:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F7A1F000EE;
	Mon, 23 Nov 2026 16:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795451273;
	bh=v/edZpvtocFnokGsp1EbOcZhOe9y7g0/5yjPiAkc0Xs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=dRt1pSJkg3WkBlKowWpBq/jbTKfBWyj9XEnrUs3NKtR+jz+Bpv6GF/MuOL6vSsTiI
	 HBlYqvgoKt5JamaQhQFerxmPkO5Xw/A9rCd7hD6IwGmiYkKY0E6ausvzsUUZvRf9qU
	 gy3uKYujnbjOpNsn1n1WTvKjE41EBJxYpbH7BHeXtY5TdUpLFY9YA5QYl9o/mvM+XL
	 EJQMWDEG9VBOn7uQiqAk0dRewbRobG9rY1Cl7kqz1lKwoUUTjg3cftmUKTe8riaKHy
	 IGe2sBKcZggb2llkwny5HUWn8w8rLcM5OObj1VZy1nKrY4i5TknPy/9hWcf2D6U0Mj
	 mVzK0ScV1yaxQ==
From: David Hildenbrand <david@kernel.org>
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Heiko Carstens <hca@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
In-Reply-To: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
References: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
Subject: Re: [PATCH 0/2] mm: fix deadlock on the folio lock due to inode
 eviction
Message-Id: <179545126490.4660.6368553899167259961.b4-ty@b4>
Date: Mon, 23 Nov 2026 17:27:44 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: DA5F240013
X-Stat-Signature: ifub6qppwiczmwc5suqxa35dki5pend9
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795451273-460190
X-HE-Meta: U2FsdGVkX1+jXQ3cjbJumIm/oLJcDSnBzrq74IQpSB158pYINW7PNN2rbz7kEvZFTUlYmXs6lUbVQEP4Fe/GARwWrscwFWmqTXk5FdCdrKfMup5KMbp8Zlo1rzs3QX6DxK9C1Oq0xxCmo+3OC5VwszV6dJITN7F6H4nZwj98d3n1lyxpGcgYd58ncsr22Lo8Z8M1qaw0BzTk/tL6m3cD6PIL7VziuyL47P/XDNeCxc7rXxHH5+z4d6BqfAQDIyq3ooyb4VpnWaoU8yz7NrUPqB+UohCl0sWKUi4D2uwn7HBph6nuY0S7wtaXJtR+0Rq9nSDJZk4PHw+OCwVpDWeVwA1MJ6xaS61Rw6lJOF0kGRi3V8EjkwgjdEw1fAfzvqSfmq7NpyPb9o5z9NHWkH17zpAlHJVgHqZisbaZKO3KcWFjsbkW5F/BlbsJoBPP5EGdErdNb2YBzqcu/FH3Vxq3k4hoYWUtGfZWgePHFgSLAZEG2Yw9xlYzMhS6uDa09f/DYdkOwWng/icvC/zHeAeECJm2fjp9p1Fvy6Em8FyqCluG2vMLXEQ4e42RGn3KOvAk+LLuxXjESqoiAYGOJXb3nL7TLYFcJg89IQaeBv4cfImLv1OxHLXy4ifClh69qH76zILyZRJwFmqOV+gviAKrqfRoVjELkXd45TbEGIz5VG5psLKxGYeffezsHEM79TbekvGDuGywLEUPQXGjlxvJubmb5E+n4aH9xmwDoUhGLpcG3+IwTzb+UnUEWue83l1FOidzj8Nqi0tjPylU00yFf2Y2/0ZvFpGg46uWhIbw0fsGBLXdlzu8l0vBIRd+tEIlyzT9dsYOnveMWToiGtzsIAEGUNLU3hxRrlwcAXuEH/iFcc11ifqpQxYc4e/HX2ccVdIpBT3P/Fokfp+v6uvFNoGsoihx4SfOAjBk+DV5/d4FSy+v3WGG/TzI1MSqas1/ZXVPnxHvzVoUji2d6pZ
 uuf1rTJe
 Cn8W4GwPuUbk2+g5h2K9tj70fLVtTZzdkAr0U+V3HY++FCaYsVvmzkIJD6DuhZ9dYsqCz4iJQMNsBE36LIeQFMSwhdMB1BEVtqNyL6ZkNlTb66i2vT4ZcYzX/Fde7p/HP3vtFXfLYa61GX/PAJ3pt8bw3PoZ/9iJUzWM+siUnFxMlIZ3dDGdW2vu3iecgR3yuD4Vldh1tmGM3Lji8YNnwoKhM2mU+wf4tUQZ0xQWFVhlHytXvfphJGYoHpM7QFBso6lTzMjUDcNAtLlcWyZgrg8ABtSm+PthP3iI0+dH2LWE0Wb4fs/J3YOBDL4fmXkJ3J8RCSDW9aaXtk6Psh8Gw1azvEPiRm+/A/xf+/g4+VFxflU1Vc3EKGb78XTEz1iKG8FdGujlyTmOdMjOVajE5rJgWGHha3hWYaHff3nFgbmb6VHEvvYedGWPydxxK7YZoU551G6LKmAxeq+Sqm2z6iPCacjnpciM6XZ/9jkdhn0lhJM1/q+5QqclCpw8gxEemPnrtg21nICvVhXtTXVTjNsXFEPmALrPFIc5c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 22 Nov 2026 13:42:16 +0100, David Hildenbrand (Arm) wrote:
> Whenever we allocate memory with folio locks held and trigger direct
> reclaim, we might end up trying to evict an unused inode. Evicting
> inodes with a populated page cache takes folio locks, and if we happen
> to need one of the folio locks we already hold, we'll deadlock.
> 
> This can, in general, not happen if we also pin the folio's inode: for
> example, through a VMA that cannot go away concurrently. However, we
> have some scenarios where we hold folio locks without pinning inodes.
> Examples include page migration and some folio split users.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/2] mm/huge_memory: use NOFS when allocating while splitting folios
      https://git.kernel.org/mm/core/c/acc29031
[2/2] mm/migrate: allocate destination folios before locking a batch
      https://git.kernel.org/mm/core/c/15f32855

-- 
Cheers,

David


