Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66389FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45C46B0099; Wed, 29 Apr 2026 11:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959F16B00A1; Wed, 29 Apr 2026 11:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABEE6B00A2; Wed, 29 Apr 2026 11:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6013D6B0099
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:03:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20613402F9
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:03:24 +0000 (UTC)
X-FDA: 84711911928.04.12AFDE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 41356A000C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:03:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPAseCjg;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777475002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxtW6Kli3Sic3XH89y9kl0VVuaLbu/hqqvU3S8hWBqo=;
	b=dSaDhzLJVQEEWkqr4njsc/fspV3Q3a/gAAbJVjIz9l733QPXNOzE9muNtiw66iT80WOEbQ
	UmK9W8C07zEPBkYFbOFxj/IktT9RHDnGv0Fw27GUMSNN4u/YDkZ9xyWzp71odFGBrpU9ur
	UOcEhhytPKTF9+mAsmQAZmdGhmB35bE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPAseCjg;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777475002; a=rsa-sha256;
	cv=none;
	b=qqeue4cCWNIWjv/sHcA+UlppOlA5XMoT3UkuyEwJg07MgHTscN8x4izB/B558RYCF3ZsPL
	NiMTlUh8+8sctAIhmBSCs0jympR4dTVTbiAvDmtTUZRr2NMIqC8lcvRhUtuSZYgSN5d2Yp
	AcbV270hf53LVZsodsZ5SsN+3g25T8o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E21F61330;
	Wed, 29 Apr 2026 15:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD45CC2BCB8;
	Wed, 29 Apr 2026 15:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777475001;
	bh=58RqIGxjkE+DGlcSy5aHIfF8jnvuEdtFZZsL+mLllnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPAseCjg/GflYBqZYScNCegotJmor53iPafezKOPzjzu+ktkbKlTbH8y/NRcUl1ZW
	 eatzswkn4KKfFGcmkzITmBwDpVrrkjNHBuES1alBIG/PU66rIiS/IY1XlYnQe5i0V0
	 qMwN5Dd7zqZl1JRyNdoaKb9asKLhH+doerwF5nPm2zR3cK+FOKh3TUfN/mUg7oGadx
	 rvRGP4n0XY2uoIc+lX1sOeBvvJRfOKX7BHd0kLntALhxohmQge45f6a86J/bsgoN3g
	 8UECIEGU9930Io2H7zmc0ebsSJnRCK7wEiatFGrNE7OZA6+s6K4BmIwRdHFUZo9wip
	 xtJiQZXQnPSGg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] Docs/ABI/damon: mark schemes/<S>/filters/ deprecated
Date: Wed, 29 Apr 2026 08:03:06 -0700
Message-ID: <20260429150309.82282-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429150309.82282-1-sj@kernel.org>
References: <20260429150309.82282-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ix813zom91idtc38merghpz6p9k3mk9c
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 41356A000C
X-Rspam-User: 
X-HE-Tag: 1777475002-558757
X-HE-Meta: U2FsdGVkX18iyWeWSuncjPzP0Uzb9+NLW/qbq3fh5Zmr/7jPZqkHWTslsAdKKPjd0V+zYpsF4FJA2s487un87zDc4ehelMktQIqGrwdpKTez8CaC6qggfXDKjKps6xppIedowOshYchgSGGa4u7wOGYAPFWRaolUiSfqh7498aB8rfUWHBnk7+Y3rL0gZkXYHJsTp/N//sLU3FXPuJAJGGqq52J1RY5mychXu2nX0hCXm7HQhW1kL+NHmzhNMtullQDamXDKT6HD/3Lm6LOsRFTiE6x85vz8gskOTgNnll3vTSfR4uiVnGs9SfIczBrpuHd3R0fLCFhpCw/hp3H2inS+yDHy0J3vRcnQFyVSh8YWPNRCCUCBHeuAU33MmbEFZabZ011IYKCzBbXXhnYWQ2O0x7//K3X1AGt/tiGqnEuLqOO1J6VitUXP9aTaFjq1U+B4ABpL1v4keB2OH7GUFQrNy9BBu1Yp97DoLsF79F5MNvzCJU6KqGS/giBwaOTffmlrHb6YgQU0+ZRoqypAyjVu5LNXt7w54WRXJhwCCn4Ns2zKC13cmv3/tUGFnMuNoIpzx/z3GqmnLTCC/jMAm846UUfJnMO6EEbXMP8/AF2V0XO+VLRrtYrnTQTkWip9LARaIVxSglw/ZVohRiBboiAQZP+OPNQc0BfgtKnhNMym2SWIrHiZH7Q7OkoO9ym5y2ex7qXtbf9c8T9XwkAqbJyhvIn4yHqjiRcqgZEGkU1qHwaathsf9HhYoamjgJMfIh1DbcoYscJvC+JwUIY53lb+/RcmRZkZH3Ch97TIbpesxChMy/r1BBUzDEbOXHtkkOf5qT/+7ZPj55T3NKQMZzQDwSYi0i7XR+tzIfRFrDgGpsftmSFPDGsUtxzEK7+3aSj8+u8dy5p9Bj+qcOrv8wpefdj9C9d63m05AG3fdpbRhz6/RCUuyeJs+eL82FTRHQiE3LBpKddQ5K5kRNz
 HGWHWQH5
 v76BF1A+sjlZwK01x6d2TEss3oQ06m1dvHDavm/I7a0+fVkENPg2g9TZgf26I5R1yIv6/U8Ft5NKE+TUMOJj+9Y8QZvnBIcPxsvtp/Ls3e8nVCIwF7Y59KChQMxCK0+vvNQ18VPw7+12n9Y6bx+5k3Eh9LWK+SBOFGsKLBBpehWsKG1Zyuqc2QKwrBuh4CRGgplim/Wy985fNsFi4sKAqvBb4OFvbv3/va1gT9EvZBJg/fhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now the 'filters/' directory is deprecated.  Update ABI document to also
announce the fact.  Also update the descriptions of the files to be
based on 'core_filter/' directory, to make the old descriptions ready to
be removed when the time arrives.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 .../ABI/testing/sysfs-kernel-mm-damon         | 62 ++++++++++---------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 971c22e34e722..ee29d4e204ffa 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -396,15 +396,20 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the low
 		watermark of the scheme in permil.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/nr_filters
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters
+Date:		Feb 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Directory for DAMON core layer-handled DAMOS filters.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/nr_filters
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing a number 'N' to this file creates the number of
 		directories for setting filters of the scheme named '0' to
-		'N-1' under the filters/ directory.
+		'N-1' under the core_filters/ directory.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/type
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/type
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the type of
 		the memory of the interest.  'anon' for anonymous pages,
@@ -412,77 +417,78 @@ Description:	Writing to and reading from this file sets and gets the type of
 		'addr' for address range (an open-ended interval), or 'target'
 		for DAMON monitoring target can be written and read.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/memcg_path
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/memcg_path
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'memcg' is written to the 'type' file, writing to and
 		reading from this file sets and gets the path to the memory
 		cgroup of the interest.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/addr_start
-Date:		Jul 2023
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/addr_start
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'addr' is written to the 'type' file, writing to or reading
 		from this file sets or gets the start address of the address
 		range for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/addr_end
-Date:		Jul 2023
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/addr_end
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'addr' is written to the 'type' file, writing to or reading
 		from this file sets or gets the end address of the address
 		range for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/min
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/min
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'hugepage_size' is written to the 'type' file, writing to
 		or reading from this file sets or gets the minimum size of the
 		hugepage for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/max
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/max
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'hugepage_size' is written to the 'type' file, writing to
 		or reading from this file sets or gets the maximum size of the
 		hugepage for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/target_idx
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/target_idx
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'target' is written to the 'type' file, writing to or
 		reading from this file sets or gets the index of the DAMON
 		monitoring target of the interest.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/matching
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/matching
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing 'Y' or 'N' to this file sets whether the filter is for
 		the memory of the 'type', or all except the 'type'.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/allow
-Date:		Jan 2025
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/allow
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing 'Y' or 'N' to this file sets whether to allow or reject
 		applying the scheme's action to the memory that satisfies the
 		'type' and the 'matching' of the directory.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters
-Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
-Description:	Directory for DAMON core layer-handled DAMOS filters.  Files
-		under this directory works same to those of
-		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters
-		directory.
-
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/ops_filters
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Directory for DAMON operations set layer-handled DAMOS filters.
 		Files under this directory works same to those of
-		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters
+		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters
 		directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters
+Date:		Dec 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Directory for DAMOS filters.  Files under this directory works
+		same to those of
+		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/{core,ops}_filters
+		directory.  This is deprecated.  Use the core_filters and
+		ops_filters instead.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/dests/nr_dests
 Date:		Jul 2025
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

