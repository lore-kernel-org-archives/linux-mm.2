Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1A72606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fn8u7LCQ
Received: by kanga.kvack.org (Postfix)
	id D6B256B05B4; Fri, 13 Nov 2026 16:45:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42706B05B6; Fri, 13 Nov 2026 16:45:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C588F6B05B7; Fri, 13 Nov 2026 16:45:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A43A06B05B4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:45:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E0331C2784
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:45:43 +0000 (UTC)
X-FDA: 85431428166.21.EA621B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6A0C610000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:45:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fn8u7LCQ;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Q0tWAXinCIgLv5dttmkNHUIbP0pSuN0NtpeU2dsb3tQ=;
	b=l1g11YMLuXrWR2fINvLTqr8rexHlEPbnGPw+Pe93BUYF5m7Ip38ezlQuqb3q1BdW4jy/Bl
	5rDwhf0Uls0R/3ARBwBt7wl7ZGK+6qwGq12X2ZfeGAW6E1Go1BbjqHE2+j7Ue0G5GTJIr/
	/LS+oOBLGQdRepZTVemqJAL7FMDpM5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606341;
	b=Ste1n7BLxhQMEwyCMzmNk4CJ9r9fJzTW6eFjRISK9SJuxDTGst8UncInM8fvM2x56bQdXu
	YioxZtfEd8miYTMVIsw+kWHmVv+lelIhRRL/UPjGi7cA/MsrPFsiSzyUPRnD/bpFGad60v
	HNX6RiCGg2iPrUblpethsbcG19RhUX8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fn8u7LCQ;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DC4744829;
	Fri, 13 Nov 2026 21:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40EA1F000C4;
	Fri, 13 Nov 2026 21:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606340;
	bh=Q0tWAXinCIgLv5dttmkNHUIbP0pSuN0NtpeU2dsb3tQ=;
	h=From:Subject:Date:To:Cc;
	b=fn8u7LCQR8nMJZBtx/n+P4sWBF0VR0jTAueDT0Kw27CAclWjmhQl2IpHuHNF4C8MM
	 ugt0dqKUv+L2lSkFpRfmzzIoPiUJA+wUdOXVRgo/jMskFOgwkLAOvm6vIFbMgxUt/f
	 iN4GIHbkW5mm6V9AY2D7zBp6NUhIMfi0bl6p2ixusZKmzFosVckwZe8aAf/rBKf4E7
	 RM7kbiY9hkwSbY2F/O9GLb7dvi1nr9hly4cEQmfCOgKzat8LvvGvf37BeXMgRBnFT4
	 ZYIW6LnHKVBtODdm1YOCKKbrAHtnM3cIbObeELAzVsf2nf1dgNm+3FZmMr/FsLs5VN
	 S77fwl6wjEP4A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v2 00/13] mm: batch of (urgentish?) fixes in oomk,
 cachestat, dev-migrate, percpu
Date: Fri, 13 Nov 2026 21:45:18 +0000
Message-Id: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32NwQ6CMBBEf4Xs2TVtWRE9+R+GQ0NXaISWbAnRE
 P7dSjx7fDN5MyskFs8JrsUKwotPPoYM5lBA29vQMXqXGYwyldbqjKNNMeDoO7EzI89oB3z4Fyd
 UdCFXUl1TS5D9SXgvsn5vMvc+zVHe+9Wiv+lvVes/q4tGhaUzdKKyMly725Ml8HCM0kGzbdsHe
 25PYMMAAAA=
X-Change-ID: 20261107-mason-migrate-et-al-fixes-0494d34884c4
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
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2478; i=ljs@kernel.org;
 h=from:subject:message-id; bh=YTbJV0/mNdYsHn7jyNW9SuR23YhuI1Yfpt13SCQKfeY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+t3wNYrrWVpz4Sk/1zqKP3gzhMVUlRlVJBuJVCucy1
 +VOn/uso5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABNR0WX4K52k3XA4Vvzvvcvr
 n+bfuvhel/mN/HWuddtf2NYkPNa/4c/IMGPfLwdrdSFrlfTDftPYJONzzlXpHK/rOv1MVjw8ZZc
 XAwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: t1161otd4c6fnjjrpuoa9dismgcihm9y
X-Rspamd-Queue-Id: 6A0C610000C
X-Rspam-User: 
X-HE-Tag: 1794606341-859852
X-HE-Meta: U2FsdGVkX1+1i6b5/zwDkyPDXQvDfmrETUDOK68cwCVUuksIH2Naw1iKJazVqE0A1X7wWjPZ8ZrfjGtIKWAafJAmOFY2C80CqZhz/knUv7hnOzqbQDstargNElqKcyqGbjxv/Q18MtV4vJMebMWka9xPMTiLI7seUnL+zoxTGr+rySaHf1naQc6CQRTKdureW8U6dvS99B6JCyHx1/cqBaoMiydX+c0GGMZKwqkkQXt4zwywhuehQcWZSex3SyzOzgxDxm7uy4vgdZnB59AvMnwhchPqvGJ3iWuz+CHsGsoBmZZW2o3nOC9vkYK+ZXguv9lANBIEgO1Oi+dJLukqwkdFfN7RfNYu0PGeHpibteHcqCZyV1dxsLYjWYaoMfuUz04+yB7cW1/sXAfRO6Dd7B7vhZc4pP3HJPf17DsjLvvQHuy5m4txxwSPdu2L2PlFt6WKmiEBHCdxjyTAWBHx8E9nN7kI9bfrcwGomVETZrhDAYXT6PGHgNlN6+0UQNjTk7Nq8IJzpSZky26eGdNxm93nMdGoMP5ObqHjKVsdVphz22i/QVUCFY4lwicpIF0614qBA5fGjKgXxUsd+Sh9MF/mZ0LPMDag9Lxv6ojqJJoxwCrt+ZCg+hNN0j1AJsYE+t7cS9V1sSxoPSE0smSx8yhAr2tFXV6XF2Xpzf75ePteqgMGcBwCdkPZE1QpUx87kfDB2OXQl0nMri2PUtNrRO7lX0ASY0YN+bK0YLftqx3b95LCAz4Dy9N5VrIJVc/M+XVAyREmKAVpST2svMCAp8tHg8PzB24bJ+DA82qL2QUmoZ7Otm0Q+ovCO9FT73LRTCl9pG94l3lvjAKVmZvxJUOqY1DlbqNQfYLWp+uJu8dRq5RMMRSwqqbNwJ6zB1SwfzlcX25U9+Bhca1rDNTOheslz6y/ELeMShWyNx9w6vBBFbOTqXyJdpFow0cXrnTjzWwSFlqkQ7djsJwqe+k
 dTJs5KvR
 RpbV4NIRQn11mYnhHieamtBtOiPmLm5+QGp8BFwo26w1s0KFtDd146sVDJgdQPkC5Ul5u5sVJclvznFW2gwJRKn7SMM6F6YJLcfp87s//+kmwO48E980jX9oA3k4hk/DZXph4RPOybHHcqRCBxsbcM/TcIRYcIqIfolRZWyyjrCgmbKFTYpaoqIqcUs5JYk3dyzBYUqbj8rcRcUS7YbEJ3M/PuGOrVDBOdMuEwtZ9bn61yvGJnRfkjhdG61rSOgsvjS+OoqxLj22zoi3J0uSfLQIEJyr7Tk53EToLsYBIMJkMN7NcWmL72FYO7COWR7ndA3cOYvHsIuG0kLPypY+DZatMdMWGbwCKDAlzQsDhZFLzuc4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A bunch of fixes for oomk, cachestat, device migration and the per-CPU
allocator.

These patches were originally AI-generated, tamed into upstreamable state.

Some are more reworked than others. Those which needed a significant
rethink are submitted as mine and marked as Reported-by the relevant
original author, others are smaller edits which are annotated as such in
the usual fashion.

Please check for correctness, sanity, and whether the cc: stable is
warranted (I have not included it for 3 where it seemed unwarranted.)

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
* Propagated tags, thanks everybody!
* Clarified commit message in 1/13 as per Michal.
* Added a description of the fix and its performance cost to the commit
  message of 3/13, as per Usama.
* Updated 8/13 to also refuse to migrate KSM pages to device coherent
  memory, as per Sashiko.
* Added Gregory's benchmark numbers to the commit message of 13/13.

v1:
https://lore.kernel.org/r/20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org

---
Chris Mason (5):
      mm: cachestat: count each page only once
      mm: cachestat: restart the walk after each entry
      mm/migrate_device: fix ksmd oops on a migrated KSM page
      mm/migrate_device: refuse to migrate shadow stacks
      percpu: queue the balance work on an unbound workqueue

Josef Bacik (4):
      mm/migrate_device: allocate THP deferred split heads
      mm/migrate_device: don't collect a range twice
      mm/migrate_device: don't let go of the fault page
      mm/migrate_device: look up fault folio after a split

Lorenzo Stoakes (ARM) (4):
      mm/mmap: free gathered pages before MMF_OOM_SKIP
      mm/migrate_device: fix use-after-free of the anon rmap
      percpu: fix contig hints that are too low
      percpu: search the whole reserved chunk

 include/linux/migrate.h  |   1 +
 include/linux/mm_types.h |   2 +
 include/linux/oom.h      |   9 ++++
 mm/filemap.c             |  21 +++++++---
 mm/migrate_device.c      | 107 ++++++++++++++++++++++++++++++++---------------
 mm/mmap.c                |   9 +++-
 mm/oom_kill.c            |   4 +-
 mm/percpu.c              |  69 +++++++++---------------------
 8 files changed, 132 insertions(+), 90 deletions(-)
---
base-commit: 7f04048247a69019ccaa9c152002d3601b19453c
change-id: 20261107-mason-migrate-et-al-fixes-0494d34884c4

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


