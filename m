Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CAAEC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E49376B008A; Tue, 28 Jul 2026 09:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA146B0095; Tue, 28 Jul 2026 09:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8846B0098; Tue, 28 Jul 2026 09:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A3BD56B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:08:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 266CCC033E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:08:13 +0000 (UTC)
X-FDA: 85038213666.28.164115E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5F5CC140017
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:08:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SdJvjp+d;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785244091;
	b=Z3s3dVFGXT2VUXgAfp/Dz3d8zm5p2EI0VTqy5VUlldRaFFhIyVVrpP3887ZVnaUQ5p0Vbm
	eEQEOArxY+iooRn5m/tWbaqSs7YcjuorZGPwgyJNvp7duIyMaSv+fSgWJpSRKhwysmCg1B
	oAzWheJPkqJPGUUYJ+8uEIO29eqhbR4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SdJvjp+d;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785244091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OrNn0+AoJsT4fnoiy11cQIXKSP43P9bDOeyyTlsXx8M=;
	b=lPX7nicuWNT3ysRGPhmsJhylH+C72Hk+HgFst6yc+88XA/vlzpC1lSez3KuFHAtO0vmMtx
	SVwKbYZzjhmVinZaoC08lm3eAPi6m1BGX18vd2jMtsy8dm7Vp8loABNEFgXvuhl6w2yVnO
	KD5zZJP3G8mhvWNgCWGkpNABmOkscvY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2347443A5A;
	Tue, 28 Jul 2026 13:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44961F00A3A;
	Tue, 28 Jul 2026 13:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785244090;
	bh=OrNn0+AoJsT4fnoiy11cQIXKSP43P9bDOeyyTlsXx8M=;
	h=From:Subject:Date:To:Cc;
	b=SdJvjp+drwuDXaqChRVRyODfl0G/+o4sQ161wCjGjH39syvXqnUCInMNz5oYJ6tno
	 tGbouXzMCxKQeTH3kpHHyuvmX+VwmTsx5ly4dIp+mwV/Hg62AoOSjOq1lmXLAMrOFY
	 UlDOg87C5Lcvx1D4UJeQ/q7chzGF8uowORBf+95JdxtrJFX0zzIChRlfWQJHfUCfs7
	 gaE7L5pdr+YNZBMw8G8HWpSCVp1v8j/1/DKTv3gLJFSLc3BQ/fRSxN0KBQOhf7xAH5
	 JDivhnvJ5uSPrA//JExL7jErLY64F5TNi0+WhRovjsP+IJJ+QDmU2lX0wd+uI58tP/
	 8VyMMrqTedzfw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/5] x86/mm/pat: CPA fixes
Date: Tue, 28 Jul 2026 16:07:43 +0300
Message-Id: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJ+paGoC/yWMQQrCMBBFr1Jm7dCYYiJeRVwk09GO0BgyVQqld
 zfR5Xv/8TdQLsIKl26Dwh9ReaUKx0MHNIX0YJSxMlhjnfHWI+WAd1lZcRzID2T8yXkLtc+Ff0P
 Nr7c/6zs+mZZ20IoYlDGWkGhqapHcr2fXzzPs+xf7Fi/FigAAAA==
X-Change-ID: 20260727-cpa-fixes-d3c73c075672
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
 Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
 Mike Rapoport <rppt@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 stable@vger.kernel.org, x86@kernel.org, syzbot@syzkaller.appspotmail.com
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5F5CC140017
X-Stat-Signature: eth8mrkjhk1gqiiz6ti5kf1uobftoasy
X-Rspam-User: 
X-HE-Tag: 1785244091-936430
X-HE-Meta: U2FsdGVkX1/UNJvZlGY6h0d585wTff0dp749K/cZesZr5d7Xn003Ku7NSjjFqFlmyav93EQ+DMzWFyABx1gKwG4hWGgKJE2Oo/MLgQa6qWly5c9ZbEKEK69aRzOWfF8p2AkElP7GcLuoTUknI1jadwMrIbMpiJvn4AafLGWQ/fIQFTqsqPwdQvvzhRF3cWbjZvaJCaoG5M+hszbhuLhZv3xW6RxJvQMRTeLCwvCTgUYWJy0HVXgVc4aA0E9uyalZuRpJ9PCPsl5y986MISwXruQ6tM3/DHfMRLrxmTVbRl0pkUKUHGE/RO9IySPC8ztZxnWoeaQzB947zb+VYXzyLL92QogHjr89WKfN/O5PqVgbTw8XXA/Sl/ADnxeihOL8mCxfYhFOlARbUovtjuMXScjO05oFrMYWbYhpEEjFxEhIgVHgZhINHEO9v1Rp13cEF5ikwGo96bYcZI0xvpaglkGod8BAnjBuou/s7Az9ErCNqN8EGBNychpGdrHK+LheLtdTbSvfe0/JuH5uwDZ5me/RJFZEipnLVdTrYJAG5DZh5pZVjrr8z/coQjPxguMmZ+LRsHUP4zjSZZPfr3xlefLxIgA5fMBZZHi2It68ZO0oQIWLeFYkkmJze/Dn4PGphPilYBnxJX9Aw3ccuPDqhyjQALOacls+oAn6E9t7bzoTQIOYBV9ainRH6lufTi3n3NqD//5YKxnPxO+MuZFHPbF6VMftqmxq90AZF6A/VSKrwrh+G2ZDDvWgTD8wRBPmAT/fu5JFkYw8Mo4iBgBS1/jBD0QW4m1WUASKWTeHftW299PTZJTsGo9nDz4NBIpYTOactyka/+Wd8yGhbF1FfWs5+jsDNaP1aHFGyay/0ldgM0Ump1gIlz2AMEKu8lC8A0+hyunCNwMv4wbAW/YaprwyMHaRIHXYigz0ikFTpbxKXOeSCYNiwD41pgZ4xHt6ftsW499zlIJt8DkmHs/
 0WTffTth
 Nn4ojkdOPzCF/DnRQ61ypsdODocs5ZKKu8DUVukLTtM2dAjrIlWBivKa2mGeQtQzIMpIAgNVrHcm9c0FrMPaZRdJP0sfDzdDUMQczynbNugQZA4/EBBcQZDfVgHQHc+3citw3P5V9HjEIkUoFaH5F74syMWPugQKI5821Bfq6B2rH+JY58fERCRAXxXyhSKwj+kcU1uSigc1JTt96gn8W3qPv8Oeb3FN+V9uR1AAUnB2uQdZ6JLsGAkrIL+UCn8EHqeeAgA3+PQREH6+ng19WIVtdRK0/4tDWXlPxkSJr/Fxpv32PU0qOUYychuMEkNa91mEey+hhnxgup70UXW2lb3UUzNJJ9l8RcLRVwKzeQidyzg8Ng8nfpgCLBa8oRJSicK1h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are a couple of CPA fixes floating around:

Denis Lunev fixed races between split and collapse of the large mappings:

https://lore.kernel.org/all/20260715183453.2381141-1-den@openvz.org

Lorenzo Stoakes fixed UAF caused by races between CPA and ptdump:

https://lore.kernel.org/all/20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org

and an issue with stale page tables in IOMMU:

https://lore.kernel.org/all/20260721-fix-cpa-kernel-pagetables-v2-1-2b255deed710@kernel.org

Mike Rapoport fixed a check of RW attribute in lookup_address_in_pgd_attr()
used for the verification of RWX:

https://lore.kernel.org/all/20260715144519.934289-1-rppt@kernel.org

Some of the fixes got merged into x86 tree, some of them got merged into mm
tree and some are still hanging in the air.

Beside the fixes there was a supposed simplification of cpa_lock locking 
that looked like removal of an optimization for DEBUG_PAGEALLOC, but it
turned out that it was not an optimization but rather a correctness
guard because with DEBUG_PAGEALLOC the locks could be taken in an atomic
context and couldn't use plain spin_lock()/spin_unlock().

The changes here are collected from all these fixes into a sinlge coherent
set on top of tip/x86/mm:
 
* update to cpa_lock handling with DEBUG_PAGEALLOC
* fix for races between CPA and ptdumpi causing UAF
* fix for stale page tables in IOMMU
* update to the fix of the race between split and collapse of large
  mappings
* fix for effective RW computation in lookup_address_in_pgd_attr()

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
Lorenzo Stoakes (ARM) (3):
      x86/mm/pat: acquire init_mm write lock on collapse to avoid UAF
      x86/mm/pat: acquire init_mm read lock on attribute change to avoid UAF
      x86/mm/pat: allocate split page tables as kernel page tables

Mike Rapoport (Microsoft) (2):
      x86/mm/pat: introcude cpa_lock() and cpa_unlock()
      x86/mm/pat: fix effective RW computation in lookup_address_in_pgd_attr()

 arch/x86/mm/pat/set_memory.c | 95 +++++++++++++++++++++++++++++++-------------
 include/linux/mmap_lock.h    |  2 +
 2 files changed, 70 insertions(+), 27 deletions(-)
---
base-commit: a5a162fe1ae130e3d2ceefef3f43afe3773c1d56
change-id: 20260727-cpa-fixes-d3c73c075672

--
Sincerely yours,
Mike.


