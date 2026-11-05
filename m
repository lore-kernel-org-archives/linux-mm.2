Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8363606D81A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZEk0xcPG
Received: by kanga.kvack.org (Postfix)
	id D651A6B05B1; Thu,  5 Nov 2026 04:49:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3E106B05B4; Thu,  5 Nov 2026 04:49:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81DC6B05B6; Thu,  5 Nov 2026 04:49:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A61B26B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:49:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02C90140966
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:49:41 +0000 (UTC)
X-FDA: 85400593404.16.AC967EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 38FB6C0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:49:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZEk0xcPG;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793872180;
	b=zTdDMF2HphzGeKIqlVLVFq+T7G9N5UyF8plq3vfGmQAZkOBmxq3OZlS/F+ZGO2egUTk/ba
	NZY+GtXSuSsTehMGuEVrYcFyaNbd7DE99PqepM7z9ul+2K6Vz7zvO9YMbiBjrcQomRE+ZX
	JSDJM5nauKYQIhtX7PxJMd9YhZCXX8Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZEk0xcPG;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793872180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hxTX4TglBlcnwRKNy/gdxt9lj2TmNDvqrCwVL+kxWpo=;
	b=23oCMTOoj7xxMaKn3YvAhwqf8tktiX8mJmpSuRweiJWZ/GenGJHm355u1yYxGFSibYO/tx
	iiQdNghjb9mnlCat3qCiF8+ZhqEQNk5TXdzGoAQrGBHt8yzlcQRng26/A/fHeuevq+/lI8
	QQG1OihEEGuSzQFUOv4616cmlcztVsI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73A0944628;
	Thu,  5 Nov 2026 09:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEC51F00A02;
	Thu,  5 Nov 2026 09:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793872179;
	bh=hxTX4TglBlcnwRKNy/gdxt9lj2TmNDvqrCwVL+kxWpo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ZEk0xcPG7OcMzIf2u14VAVOl6GpPUYHf+L3nCdkVQRLU60PAc7WRZtHHkhgxN6H9i
	 Djsp294G/kXjLF6vHuZ16WK+JN40ZCPORmwNUt5ZIcriAJdL8nVvjBh5XSVRXL6i4m
	 +mvByiuJmSOoigV1uFzQ4hq6HgrKva2jDRPW+19sVV7Smj9DjexTuecxJ/uDEyL32O
	 OzvzN6nQOiWC+janptzA6iVisgRTq8hfM4vC65U8ZkSPmsU49fBKWE5auGZ46zRO0n
	 nxo5YTL6/Hpum/GpGVNpvqqjqp6NTRGC2+b9Nr3pd5WFPQLvLvxTb+jW4sMHZO8GV6
	 O/8WO/IU/44rQ==
From: David Hildenbrand <david@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Tal Zussman <tz2294@columbia.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
Subject: Re: [PATCH 0/8] mm: remove newly-unused page wrapper APIs
Message-Id: <179387217134.14545.11514432570963852326.b4-ty@b4>
Date: Thu, 05 Nov 2026 10:49:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: fxoq9je5djwdcdyynwhrwdd6sezk5xdb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 38FB6C0006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793872180-111748
X-HE-Meta: U2FsdGVkX183glIOCYZ6qCijTPN6yFH7F856ennx3F8t4ASLTJH1APYPfCxwDKehSDyCErUj0UgPXfRnX3ZzTeJsglU4/GEwtVGHFpuZnWWz+6FWyBqA+7KR8y2DO+2Bykc8wE7zx7G8lkGks/hqoPboyeaPvfQpYfHRGER4+RcJPy29JkrmGTvsBswO4OXSd3HHEbmwzNqYSr/Kd1LOcZNpWaJpQ1yf8r2PouNyl/cu/dOYCJc3ZYhiWTXq6kl8FggRlWiK7z+owEMZqVWR93gQV8t/uUPXrUGQaJsLox8YCHb0uWpSeA1ggq7jderEvXY/WzXPIrnlzVtUNGwh7f6jvIDKBR7SnW21jr4bPviJdTa0D7nT3bsdLLMcCxHKUES1SFNJU1qcqhGOyn++GOHu8zAc7lud7KHpzdMTCN4bLfX1nXDIX647CPZMmtCcXKFe8ZJ6wd5q/M9Z1ocamHqL/3xZZ6M7xtizJtoNPCiiN7pfGP1sCuHSeEmlqZFkJHHrKkRXMc5HVhZvA7yRS9bBcnmR+fi9kQGZWo9F8P0y46oCesGyhBirxMZpGyGM1OYtWY5bH8XZO+KKen6EAdWKTJCgtSjzqKRQsBD8pixeK1COTkFc/CML+ZlTTlY554YB7eiXULL1zFPLP655/3sJGHSoQYIXPp6shbqYASkmVmBFt2mqO8YEhD+1wFmQfVztdqZqNcZerKEgpjs+HLvHtMZAb/X3+9Mr27xTHQJCF/CcjiqJaatriAB5uCuuG3DphMLuoxEGIWnmo6fgPUN9J3GZLJQEPTnelp77b6PQKlWQh5Oz9tdTYUVpyVUlPnJyP+BifM6Xm/cCLtTI926dP7gZGIRWjZE74lH9as1BqewRe07BvC+7gt6R+unAorixOXLa849dDVMEvfb/IMwPDggPxX4tk53t71zaUe3qcWXujQEabScAdpIoVyq+ZHpOTncfBQp0QqgWrU5
 9BGnXZP8
 eD8LPdy3ISxwk9pGWK+tnpdDFy5OfyE65hk7T9ngjEkWJgKECM9TAeklmkwg77M+mg2noBuTqc2JThU4jmZ8U3MEDMOHpZ0RW3u5nW9MegMOO5PR++xUo2ArfMeiQpNN5RGtizyCBBczlPbt3+pivXtXF6aA/D5aTTOBvoOXK7V1qMF6+vhcBj0IEpvC9SMTjHM7e4jKNM5kEEl7P4EvsnMYEPPXsq3RqaOH1akKwuHK+33J+olz+NsdmmDIElojRCqLaZdTwh6zV+1WM9mkWUHhwJ/6+s3e9N4zVw1DZ/M9ioed97RD+6dn6rryPcAN95PrT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 17:54:05 -0500, Tal Zussman wrote:
> After some folio conversions done last cycle (namely ceph, f2fs, btrfs,
> fuse, and page_io.c), there are a number of newly-unused page APIs.
> Let's remove them and update comments as necessary.
> 
> Patches 1 and 8 are taken from the ceph writeback folio series [1],
> along with tags.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/8] mm: remove wait_on_page_writeback()
      https://git.kernel.org/mm/core/c/88e548fd
[2/8] mm: remove end_page_writeback()
      https://git.kernel.org/mm/core/c/57733524
[3/8] mm: remove clear_page_dirty_for_io()
      https://git.kernel.org/mm/core/c/447d4798
[4/8] mm: remove attach_page_private() and detach_page_private()
      https://git.kernel.org/mm/core/c/555b63e1
[5/8] mm: remove find_get_page_flags()
      https://git.kernel.org/mm/core/c/47a09332
[6/8] mm: remove find_lock_page()
      https://git.kernel.org/mm/core/c/9919cb21
[7/8] mm: remove read_cache_page_gfp()
      https://git.kernel.org/mm/core/c/1fded4e3
[8/8] mm: remove thp_size() and thp_order()
      https://git.kernel.org/mm/core/c/4efd0e4a

-- 
Cheers,

David


