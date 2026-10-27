Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB82606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TvXXwyCu
Received: by kanga.kvack.org (Postfix)
	id B97996B085F; Tue, 27 Oct 2026 13:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47D46B0861; Tue, 27 Oct 2026 13:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A36846B0862; Tue, 27 Oct 2026 13:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D28A6B085F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:30:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B93BF160AD9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:30:51 +0000 (UTC)
X-FDA: 85369096302.02.9B1EE26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 25085100014
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:30:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TvXXwyCu;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793122250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=k9SppgYxlUdd5nAVm8BiImH/4wxn+yjRYEqQSQtPBHU=;
	b=VOHVcoEqKx3wnhBqdbi4FM8F1zraIw06yrDhagpKxXJGgxrfqWEsq2/LSh3mOVPlB93MAd
	d97fMHxJZN4w0cRfbjX7Xm+LOxXNhT8NlS+zjKa/kwSC4uc0yij1kCpHPJSpD0ypPI1qjY
	69hMaXAsz9j88tnZNBhMOd6VcJ0nReM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793122250;
	b=sIKv3Kk7b8qvynPYxzPONeF065bIeEcqaKu0HmF4HeFWfglriAY0oeMo5hSgTQUG5K4Z1l
	EEk+zWBeo/Ozrn8WDvzwwOcM/nC/G6F3inGkjRC20Xpc3CkANmYdvNtD4pB9cH7go/2bt3
	meEHlVGUHcDBytTr6KTZ0CQU8n4ZPTY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TvXXwyCu;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A813860142;
	Tue, 27 Oct 2026 17:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9671F01825;
	Tue, 27 Oct 2026 17:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793122249;
	bh=k9SppgYxlUdd5nAVm8BiImH/4wxn+yjRYEqQSQtPBHU=;
	h=From:To:Cc:Subject:Date;
	b=TvXXwyCuQe+su5CB6Yk1L0Z5PYM0JO1lcGmzJpnwcdYC9fH8qSjHWcjgzspNCzA9d
	 sjPwgTN4D6lXRKPJvrp2VaeOd4k/mwuDnwsigLs0aZwaF1n0m5leaFQcaUfcWyZNxO
	 1MLfxUUBrPPJIqiPlPIZ/j6avZmhv9eobEHrUKu9BQNGofiP5mlBtGXvG+QitNd6pV
	 8W57j7e3/U0Fbp5gWTQSLaaeia2bkiMkAm/imNCpfaDn8aqKVMdrqk/TfD5MisQ6Kc
	 KtMcLTCERiXZ9tYzaQSVyNrQZ4bVBF5ZfgNS3SOs78yXqp8F9DUlEBwat2cB/HLSAv
	 84xUsHMOVUyRg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Subject: [PATCH 0/3] mm: allow freezing mappings
Date: Tue, 27 Oct 2026 18:30:25 +0100
Message-ID: <20261027173031.763213-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25085100014
X-Stat-Signature: yf64exkg9akrdq6j9xj5ks8g3i1s58bj
X-Rspam-User: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793122250-44355
X-HE-Meta: U2FsdGVkX1+dSm3Rjqtz8TgY38d5xXdf4dcPGexN3TSPclt1eTZrglfSoQvc0NK9dwp1T80nG+jilTlNteISthLuYKuFO932liWq1WI1U3cf0p0QO8fb9w0s5RcpkAoXJwTo1hNSdnjj7gFmVE9OihwBK1I3z54ExoJ1EO8skCuzV0tL5glRJeYiJ4rJBGeIHRGDzjmdKnB4opwYNdTOgAQnnkdfXGB8Hk5N1rU/OFYoO7k2emn+bl6krSRP/mBm29R/s7vnwYLwDu6h5/yj/UmqpTtcBEgfuERFDUXs4IgpKHjPdxgoOq5R1FOJp21nm9Emy5sMMYVP003HFCEzPZiBVOwJrnFjQAZaZOUrTyIRtCueBbKWUdmaM8OHZ+5QjoU4YgG4uPxNxH5xANc1UUTwigqGNP32UF9OsfKtv2c092t0F6XHKiH8Qgr8pq7uKnMQbIz56R2YZMdUZxbePzX4j6twSb/S0iEJNtN/eB895IcRn53TfxglxdZGrhtO5y+0lxF+mfw7LS5DEUpmHofFM54yB7ZwjTeleiSaiCXL5kGl8J98G/Nwi/7FGCj2Tbh78HmTxVznQ5X7DNP7LdiYwvWnjOL9Xq84muEltuzjC3k6sQUz4m82krxTiQ2+kYsz/pyh38qfDf5wbCgKzz1Q4Brkoi4JdllpNSV6592rLZ2m/HMrGOkDTrx9e4Ljwe27RE61ZlU52aOLzC4m4r1QE/6vHoywo8JXFqlPf43XpJg6PhmoqrI+ixBb1TgD5oBx8KHkczuyzziqugIYv8gu8RAWjIVBuunvGCQRAv+PZ6ErplGNyYeDAoucHgL152kAoewf9TQ4WPvagK07lnWbiY5YBi3U7yfhbMiIchLvytYYCs3e9fnFhBmMbrn3ILcVu2/20yuAQdFfnBMA9lAch8PXdSGMiO/RKxGcAs28HSFQ2h0FGnXHRhB9x1yxUXoFULS6CHrt6b5+obE
 +wVoAYLK
 Pc+3Pn1E0fULuHYhnw9UTWUZEb8zb2K8Uf/lcvd6m29aPns3ydTCUedNyyR+wmeoqE7KluOHPDTGWdlhVFbBcwd+hSLe8Cqwxu++6xNGypDzYJk48E4zE0tXDCjuw6fIsVVE3ZcwOXqNTn05mHcpE8VlESm6aUPZDkeSlpQJuf2j17kNX3FcThbnjH331kjzv85CQd9UQGOPATOeJT8cNrPeNiaDcL9Kfnd8ES5s1/UxfLe/X1hv27PE2FW0mnYL/E7KVhhmc/Gq2MDeJ8pzKHQOWVfZZFUsDhbWPSPhVjEUSY+Jz+t7RtHjj2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

This series allows freezing the mapping of an inode. The main user is
memfd_luo. It serializes the state of the mapping and needs to make sure
it does not go out of sync. Currently it does so via a combination of
pinning and internal flags. But this functionality will be used by
HugeTLB and guest_memfd preservation in the future, so this series makes
the feature generic.

The idea came from David Hildenbrand during my presentation on HugeTLB
preservation at LSF/MM/BPF this year. He originally suggested putting it
in the VFS layer, but I find the page cache to be the appropriate layer
for this, since it is the i_pages that memfd_luo serializes.

Patch 1 is a cleanup that also came as a suggestion from David. It is
useful for this series since the freezing change exposes a race with
shmem_writeout(), and this patch fixes this, along with other
improvements including preservation performance. It can be taken
independent of this series, but for now I am including it here.

Patch 2 is the main one. It adds AS_FROZEN, and adds helpers to set it,
and adds checks in filemap core.

Patch 3 updates shmem and memfd_luo to use AS_FROZEN.

My local sashiko has complained about some more minor things, but this
is my first foray into the page cache and I am not even sure this is the
right approach to begin with. So I'd much rather find out early if this
is the wrong approach.

The series is based on mm-unstable. It has a minor merge conflict with
liveupdate/next, but I can fix that up after the merge window. I see
this mainly as a MM change, so I think this should go through the MM
tree.

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (3):
  mm/memfd_luo: don't use memfd_pin_folios()
  mm: allow freezing i_pages
  mm: shmem: use mapping_set_frozen() for memfd preservation

 fs/inode.c               |   9 ++
 include/linux/pagemap.h  |  35 +++++
 include/linux/shmem_fs.h |  17 ---
 mm/filemap.c             |   7 +
 mm/huge_memory.c         |  10 ++
 mm/khugepaged.c          |  12 ++
 mm/memfd_luo.c           | 291 +++++++++++++++++++++++----------------
 mm/migrate.c             |  14 +-
 mm/shmem.c               |  34 +++--
 mm/truncate.c            |  16 ++-
 mm/vmscan.c              |   3 +
 11 files changed, 302 insertions(+), 146 deletions(-)


base-commit: 39274b454e9993cea319f4ac342a8082a9ee1730
-- 
2.56.0.307.g5fe7bd680c-goog


