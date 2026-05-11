Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E775CD37B9
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A786B00BB; Mon, 11 May 2026 07:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01266B00BE; Mon, 11 May 2026 07:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D168D6B00BF; Mon, 11 May 2026 07:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0EAB6B00BB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:58:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8DF6E1C109E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:58:45 +0000 (UTC)
X-FDA: 84754992210.09.3DD6751
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DE329180007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:58:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BcDbZEb2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778500723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FjHLAHQOtxXzOjJ0uQcxEXIC7aF57b3WYudvczUBokw=;
	b=HUuhiP2ngIGNm3c7ruQg+d8v3kOq9bto9aaZS7XArltZHOuVIkKxXmfbk3avl8li96FjJB
	JV3kDE5pC9wcLYehiXIm9vYSbC9Ho7+LD1cnG0jVNhAZ23JPjFcBgfA29pCXayena066BK
	9A/JYPhUCm+0OaPQar8sq9zq6++psHI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778500723; a=rsa-sha256;
	cv=none;
	b=ahRWrVTCfKbU8EN+x0jEENmG6DkhoPT0uNkb36eDYEYKZZyNnbztWdCK7kNVal0rXcZo7v
	5kImTUsar1QN4saybHEOJaEnpZJG3yCKN1wwUwNe9w9Cup5Da/I1GeW0rFxQ8cWSzisn2q
	US+wKGilf/PfVZTZAKRYrzqncpxeRRM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BcDbZEb2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51A596001A;
	Mon, 11 May 2026 11:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409DCC2BCB0;
	Mon, 11 May 2026 11:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778500723;
	bh=vzbSctaA6rDHZ0Wddj3/2akgAPlm5EoTM+A96NJEf+I=;
	h=From:Subject:Date:To:Cc:From;
	b=BcDbZEb2314PR0jE6xKZa8a7PwI8Sj64t/sUXhQtUxdx/8F4KucT1wTtx1OXD/KYo
	 clvEB1Z2+9We80sSiwNPlN0E3S9fneZys1Y+vtTn96QSHGMfBxiRtpmJq+OQub2lF9
	 grKKyeXEJRVPMBJyEEv9l6c6mWourhcVOadOfK/hcD1Oq3M9i1poKGHuwKU0kW5jQu
	 FxGucI91mimy440r4oNCrM9zgJVyIAbdg37FNbCCJFJAYych3ZJ2nRFe2nxsh7aA22
	 XCmmqv13a7pGycgvUOLREiB+iiYqXeZgTS9QMAo2eYWuEG78FM3bwcsYk97XlC7www
	 1SbU9xGF/t+3g==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v7 0/3] mm: improve write performance with RWF_DONTCACHE
Date: Mon, 11 May 2026 07:58:26 -0400
Message-Id: <20260511-dontcache-v7-0-2848ddce8090@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23Qy07EMAwF0F8ZZU1QXnZaVvwHYpGHM41ALUpHF
 WjUf8czGzIqyxv5XFu5ipVapVW8nK6i0VbXuswc/NNJpCnMZ5I1cxZGGVROaZmX+ZJCmkjCoDW
 V7CkUK3j+q1Gp3/eut3fOU10vS/u5V2/69vpfy6alkrqAd1hCdD68flCb6fN5aWdxq9lMT4eeG
 qajGzIlTR4wHqjtqMGeWqZ+pGh9DiM4f6Duj8LjwY4pZCDMyesU7YFCT11PganTyhIMkVcft2J
 PoafIFNGhHRTkjI/ftO/7L5G6tbDKAQAA
X-Change-ID: 20260401-dontcache-5811efd7eaf3
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3839; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=vzbSctaA6rDHZ0Wddj3/2akgAPlm5EoTM+A96NJEf+I=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqAcRpYaCPni00FFvtxSVSnnmM/vy+6GNFafFcn
 CWVlf9dxH+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCagHEaQAKCRAADmhBGVaC
 FQqhD/40SlOmg1H8CUFB1b8oL5Qk5tCaRTKWcDOv5SEo7KZsR3xzUhkGO33w454UNXg2fQYXIri
 ulXqUf1WuS4/ONecC4Bsf+e7+nMGXriBWYxpwn54azH3jbir0rLR6q9oTPVGH41l8lDw1KgbbSr
 AKsK7ifiGLEHZWosRMUQz0jsdAv0JRWocf1Vwcp3xnwYARHXnlAid5vLojTqWmQPXrLASStTI3c
 LhoJU1TThSCHqNOefg6rMsTUy8S0uHQLuRx5Zq9WKnDNXqSn8gzCIQh+yH/fkeovMygWRRVy4hB
 HKLGXKrOjqs3WFHexoU1PF3I+BiOh6orFB4RGYFjsVdJCkl2/ATCVCGYBX6VSnVlhcHJHjcf5Aw
 zrPeB0fzg4vtOYRzYmR21SAghIfAbbIZ8B8wCBKIr0g0QMeojFP3/hwy1G8ERHlxr1DF5Zax/Hl
 bVtg+9lM6Wk2Hot+aLOll8CJczXm7KU5WBcL8YtprH0iC33G3R9EHj0JbbXTI7NCp9GAJqyNJr8
 eUKzUxpZshuymphkO90a1Ti13tNWQ7Qu/I6dwc7MkdQKL6F4xfwLPl5m+9GE0oXFreT5U1Oh8vv
 bAWDnj8o7CJio4O3qS0Ahf08LIFpQr4+2wAQJ4PMiU43vdYPuZtJIMf+ok6z4U1DFvZyZbqybIN
 11sjAss4sqWxSLQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE329180007
X-Stat-Signature: 9fji1wmdh5rmk84oub38znq7cijz1ohu
X-Rspam-User: 
X-HE-Tag: 1778500723-574063
X-HE-Meta: U2FsdGVkX190rXi6TmrdTjR0cimaTbaSQwGi4Qxv9sr0eaU4gS75UWwi9FMUhi1AhVTN7w0FwKbHI6jzw9kRUZBuYNpCmUmKVzzOJRkD6pTo5WfVZSrckZ8zvIC2Fxh+3NuG3DwjPftKO1Fk6IjqPUmJ9kz4c3ZktR+xV0sKv3Rr9FLVLT6ywrh5TpbuzRAGC7yBKat2N+Y2MBcpw5ykvdVKORCkhCGM1Fd40dkhkrY9R/QY8JUeLsxJNsFghfuKJp9XQZUseUcbkBYzInhTOuyEGIaPshkiEOehMY2LCoD6z1IwxrEBAzQ3HZRPeKck3Vamc2YcRCZCpOwgZn9LdzIqlgj0P3RyBqrFwwak7g7qGXBb+5J1g7W+1/ehVfOlS33nbt6Vr7dVccTvWqPSJCXzcY1a2dz78qY0vNCvEqi/uHlxmfnlbUBHAlWsG/ZiFLQ30+EhchzoPSXWsiwJqOFFpXeUNZSXFkyhlVGZQKF6ZMBMfeDB7emyBFg1DtC7/Ix5R2bj7Y+i4G5F0+WL9n9sAoTfJ31mwreMdW/LvalejogguGXJwITOxtybIcL5OdE44laLuds9TQXLmQBJspR9omvlTy6D6cjPoT6ep7gn2YuMlpENhUfmLlPPGyYIWY+BevtgyRc707yBqmOtE0vanO3HnV89r6S1Yn3fBp4Ky69F6rNngrA2cqQrtOsbrXB/QZX9SLwnk2hb63s8Pigsznb7g5U/eFscwcVrGxUtd9xLq4I19R8qDIaXApS8YOLFnIflRSmVO2cScAvI198y02+VL1XABtNmDePSY5s7HvELZK9yD+YnKXsfbBFcmXheQARbfgjsplOlVfzYbf9NR4oftU+xh7WgJwDdp27odujd7dci3EQyiHpr0aoffpSX07wrfZfa6JlE9i2nUDHEqke40obn0lsQ1stCTJJ8TdSj2hJUi8pkEYozyD7mVsA+UytTZmvCkM9Oojh
 Y0xAw4Cc
 GWg2mfaLJR+PmmUFz8uYIEDL5ak2AHX3jkIlmQ9kBAGFwNTlq1Glvq289JyPRkU9XzPvQAgA7i7irT8Tq1L0eD/3lIadFJwXh7+8fPPHHaGufeojnw2+rqC2HRyXk+So5wJrppPaBi8ijxm6jcO3Vey4DyuASGglab+YZXCcRBYtmyOn86UpFdQoHc7pZ4brLYvS8nr58jnRLgKBK/AuGYD1VgSv/rv7JKCwKaf8FAlXzPr9k7mi+bmL4lusf998RL1YLD1oKXZcqWmyAlul7qw+AcBnUBjMH0vYxu2KFECIlotG2G3dyUQY4+nMHszEmELrrrb2kiuF6qeZ6Tnkhj5o1637C9D6cJMBWJE5W6kqy8/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series is intended to improve write performance with
RWF_DONTCACHE. This version fixes additional stat accounting issues
found during review: integer promotion on 32-bit, cgroup writeback
domain migration, folio split flag preservation, and a UAF that could
occur in filemap_dontcache_kick_writeback().

Because there are substantive changes in this set, I've dropped the
R-b's. Please resend them if you're OK with this version.

Christian, please consider these for v7.2.

Thanks,

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Changes in v7:
- Fix integer promotion bug on 32-bit: store folio_nr_pages() in signed
  long before negating, matching existing patterns in page-writeback.c
- Transfer WB_DONTCACHE_DIRTY in inode_do_switch_wbs() alongside
  WB_RECLAIMABLE so the stat migrates with the inode on cgroup wb switch
- Preserve PG_dropbehind in __split_folio_to_order() so tail folios
  retain the flag and are properly accounted when cleaned
- Take reference to wb around unlocked_inode_to_wb_end() to avoid UAF
- Link to v6: https://lore.kernel.org/r/20260505-dontcache-v6-0-66463805dd6a@kernel.org

Changes in v6:
- Use atomic folio_test_clear_dropbehind() in __filemap_get_folio_mpol()
  to prevent double-decrement of WB_DONTCACHE_DIRTY by concurrent readers
- Add mapping_can_writeback() guard before decrementing WB_DONTCACHE_DIRTY
  in __filemap_get_folio_mpol() to match the increment path
- Use wb_stat_sum() instead of wb_stat() in wb_check_start_dontcache() so
  small writes below the percpu batch threshold are visible to the flusher
- Use test_and_clear_bit for WB_start_dontcache before starting writeback
  to prevent lost wakeups from concurrent DONTCACHE writers
- Move wb_wakeup() outside the unlocked_inode_to_wb_begin/end section in
  filemap_dontcache_kick_writeback() to avoid spin_unlock_irq() re-enabling
  interrupts while the i_pages xa_lock is held during cgroup writeback switch
- Drop Reviewed-by tags due to substantive changes
- Link to v5: https://lore.kernel.org/r/20260504-dontcache-v5-0-4103e58bb377@kernel.org

Changes in v5:
- Flesh out comment over filemap_dontcache_kick_writeback()
- Drop testcases from posting
- Link to v4: https://lore.kernel.org/r/20260501-dontcache-v4-0-5d5e6dc71cb3@kernel.org

Changes in v4:
- Track DONTCACHE dirty pages per bdi_writeback
- New benchmark for competing buffered and dontcache writers
- New benchmark replicating Jens' original 32 concurrent writer test
- Link to v3: https://lore.kernel.org/r/20260426-dontcache-v3-0-79eb37da9547@kernel.org

Changes in v3:
- Track dirty DONTCACHE pages in the VM
- Have flusher write back a proportional number of pages after DONTCACHE write
- Link to v2: https://lore.kernel.org/r/20260408-dontcache-v2-0-948dec1e756b@kernel.org

Changes in v2:
- kick flusher thread instead of initiating writeback inline
- add mechanism to run 'perf lock' around the testcases
- Link to v1: https://lore.kernel.org/r/20260401-dontcache-v1-0-1f5746fab47a@kernel.org

---
Jeff Layton (3):
      mm: preserve PG_dropbehind flag during folio split
      mm: track DONTCACHE dirty pages per bdi_writeback
      mm: kick writeback flusher for IOCB_DONTCACHE with targeted dirty tracking

 fs/fs-writeback.c                | 67 ++++++++++++++++++++++++++++++++++++++++
 include/linux/backing-dev-defs.h |  3 ++
 include/linux/fs.h               |  6 ++--
 include/trace/events/writeback.h |  3 +-
 mm/filemap.c                     | 15 +++++++--
 mm/huge_memory.c                 |  1 +
 mm/page-writeback.c              |  6 ++++
 7 files changed, 94 insertions(+), 7 deletions(-)
---
base-commit: 7e2326f4275c11652e1fdaae11de06159fef1d90
change-id: 20260401-dontcache-5811efd7eaf3

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>


