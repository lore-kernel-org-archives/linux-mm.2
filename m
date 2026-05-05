Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D1CCD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 19:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3C46B0005; Tue,  5 May 2026 15:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC1B6B0088; Tue,  5 May 2026 15:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008446B008A; Tue,  5 May 2026 15:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E84A46B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:00:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7EFCBA0192
	for <linux-mm@kvack.org>; Tue,  5 May 2026 19:00:13 +0000 (UTC)
X-FDA: 84734281506.12.F12A86E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 560F312000B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 19:00:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HrzyDmIi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778007611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Htf66d4oLd0DYRTpMA4rDeBjq4uVOhGd70uZCwJP86g=;
	b=jH9LYs1aws33jf8OhXpQ/V80PRkgHGtoTbeThyHeH9ZWi+WuIezVH3GN5ZfsoGzs/w6HiH
	k668aD0gEDrhr88aJA6+eDSt5/To88LlOepYaA8Vakl6SqMUGUXWUq7saJ/CCDU7wMeZ5S
	q1KE10TQysAsI0deymRycn3tA9iQhVg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778007611; a=rsa-sha256;
	cv=none;
	b=IF5oLeomKucsqcbOL5x5Wr0Uad0gpO+y0M1Q5k5gP2p2ZmHFNxhZPA9mgefeHGhhuRzN6v
	zaSJe1JAL1BWd6PmL/D4CRJY1fV8UciHTxkUxDmpBszd14mbv/YGmAVA0BT9b8cVlGWl1/
	Mpyvu/ssT/zCj2TIuOwDtNcy3HyILHA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HrzyDmIi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 08F5D43509;
	Tue,  5 May 2026 19:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A648C2BCF4;
	Tue,  5 May 2026 19:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778007609;
	bh=hUj4YFzyO1VXcjqqW/XO6RlSLO5yLEQJ7wt0RMQ7kic=;
	h=From:Subject:Date:To:Cc:From;
	b=HrzyDmIi/+ayr0xH1WwgbouUwEqFC8bCu87Q2Vsyqpik6u3B2amiBcibYEJOAAHd4
	 TcI/Re8FV9tRgjkPEjygpHYLnh2nowtaKL+o+A2qW5ORWlAcGz6sdClgD4iCx3LwJC
	 apNag9aoicNru0W117LCEgWF6wcE6IFDzAZkGodw8hWICUank7K88/J6YOHhm99O0F
	 NKwFBiWe2g4Dlv5C1ddhdThbqmrPyS1OBtIXuQXv4FP90gvzYJndUrAiABf5yRPHey
	 rgDlgHsrKH2WCSMq5jkdX1IT6Hcma7Y/KYDRZR2XPe+k2XTNaJ8/Lb8TX/aJzEGdnB
	 7cq6RDQxX3XbA==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v6 0/2] mm: improve write performance with RWF_DONTCACHE
Date: Tue, 05 May 2026 20:59:47 +0200
Message-Id: <20260505-dontcache-v6-0-66463805dd6a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23Oy07EMAwF0F8ZZU1QHnbSsuI/EIs8nGkEalE6q
 kCj/jue2ZBRWV7L59pXsVKrtIqX01U02upal5mDezqJNIX5TLJmzsIo4xQoLfMyX1JIE0kctKa
 SPYViBe9/NSr1+9719s55qutlaT/36k3fpv+1bFoqqQt6cCVE8OH1g9pMn89LO4tbzWZ6OvTUM
 B1hyJQ0eXTxQG1HjeupZepHitbnMCL4A4U/io8PA1PMSC4nr1O0B4o9hZ4iU9DKEg6RTz9e3ff
 9F4+r6G6PAQAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3145; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=hUj4YFzyO1VXcjqqW/XO6RlSLO5yLEQJ7wt0RMQ7kic=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp+j4ut1McCVLFPCo4dnsOZJGkCnEndrsyYF/ov
 9xNqF5D4CGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCafo+LgAKCRAADmhBGVaC
 FSXyD/9Ab7U6obJOZVWw7dNHbbxmdELBm7YXZHN+bn0wBFwoMj8LnuLVgv9qzU6BB1iH8cwjSxw
 uIooxJ++hQh8paEqfZJxOb0wGg/SvhljFvg3ClKT5twqy0/uf+MBunz8MMiNgZGEYns+m/Ip2QG
 FIBVdQ9Jwavv7s7XffR0Z4I30uo0TIYNgA+iE+MC9YAQBF3Jldv+uWLtJNK/VI0a33x95PSH08r
 3yzXhSP+9zm/2TKeow2JnqwoKMeXCSoRsAujGJ8HWjSVeavOkFp1tgWhF8hildAohpnYVOd8zG8
 nEeHwA8noNTnO4s5VltTqf5P2FkPZBzOvW1Xe+1Ecxt/NSQdMGQ3T/wUdOeZeSQhHveJ6JktJV6
 LrvHxfsS738cNfr+gM/6FbPd4l4TNgdJlOzsQkybiRhj/62/3i+x9DrEl1uy6d0wa1o3SrOFnKP
 nK4Jb/6tJzpueCWu7NwafB8lI/S8l9ZXeFzPi/Qg/baSVF4yavGKIXI0tFnAz/cb3zp+lCyZXni
 ifs0gDEz1lH0n4r/yrx2xbFy+zXKu3FaXT347PWK+F3zwOQq4PodXAVLXce7YyNR3zL7LdbI3TD
 in1EB020peBLAmtzhm+CyNWNOTpGjPfahPjO0pD8XRHBwbyakYeNigDU1b/T//hUzln2NxpQzTR
 fJIV5ho33fvdWdg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: 560F312000B
X-Rspamd-Server: rspam04
X-Stat-Signature: 5m8oteidck7jtjq4s9u5ag1m5maq6dnk
X-HE-Tag: 1778007611-71089
X-HE-Meta: U2FsdGVkX1+sNPG5umVxwaVFVIjX+JJhDCqEa4Ubl66c7nSXYWYWTgZUwW8eWQox0stqOTbBtDx2vsSIEIj2E+4VIYVzr5u50JR6Xmm8WYza4utBgDHZhZSf6uvWHX2NgRFZUAp2nwE22rLSjHJcRbB4FwanEtRwbfida7471YBXUilBAje5+onuY54XZzCmcpMBXK6Pomx1QiKtSPPnGiZmiuH+qL7NHWg6IyXPtcioDsIYmAjMjl5hXkzPYkGx7xLFdDPVZJyH71k1uVvIhtsCA11TlsHNlRF+Daqs8kVQGFbiuWlQntdMV5vKe3TNI7yOHG46dMuGMgWlH+ggO5x0PupXBjwjkOReQpyLaIw+6ZZ20D9zl/Dbc4LRZRMblDxGdyw6JzVMr+Wi0PkN2ngAgd9lC+2vfmVrv5S0DW8fybxzrIwBiVgdKZuythkUSwbqW45cgkLQvdvuok6rwJQfCEsJO5Y7CsFiL6ejbrHR4a3guWXSE5HOUX84n+Xn8a/k9X2v5xczwS9GxfwYAdQTa1kqzirr/bffAGPG30f5pTiGahZL1th3Spx436elmOCNJVuY/Vq0DeI+fDXwi3bvvT4Gsr2L/41f39Wa7zwaZPnmsC6eV4xZ3BaC6kEcfDq2FBipIENF0gvAKUZn7dZEAQX8sAc3YJqoa5a5WP/b+dWy5eOLu6+vz1R5Fwwf+TlAJtqXRl591nEkFe7llW1oL7COfSyGkPXGcvHrRZg5jKEU3/PL1/xwBqSQRiE1i9A6tpQAlucuC11m+oE/sQ4mvdv+ajlRF1xIWwurFcBx1bvLdfhNHdBffrZvliSRfQb0eMdO4j9hqBXmfePSk9FAOrQet/ymXjzhv13O+PRNdYHIlPCxlWaysbBZva6pI0Q1nOyHmmMa9/NNAde/d9xWpduhBivrKNPXHqVIHIP/lLxXNrr2zxgqNvWTyEFP4xMD7qoqQyqsSzma9Py
 fYa5/VWR
 thafsGPzLptwCmtvTXsEq4O1NMUl7s8tf2DZuzYW0Lhfu6c3JZkrLEF0Y/e1W087Y5oKE5x0I7L7uqtILOuouJbhKRs5Og3gNRi+K+J9BavNNFXcAtpO+jkB1Y+Csy/jyGWYcYF6MiA9obdTTn1Og49kT5kd5RdXzNdkayVJ3wOFBx2i8P8JtrG9XR2gw2rodAdl+iMT1NKP1vMQcs+ooKCQ1krNeblujuVFgmzuv6Kee1r3p0BfVxcWny99d3vHFma37fW3tL94imSm6Po6d7iyU+PaTAIWCfdIG2lXYPKgi2dsvKmmxB46B1pcIPHvmqdtPKdrzu5yayUPSgrJyWHj/9Pl7YHRNor57zMlDpb6xVBY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series is intended to improve write performance with
RWF_DONTCACHE. After sending v5 yesterday, I decided to check what
Sasiko thought about this series, and lo and behold it had found a
number of bugs that I had missed before. This set should fix them.
Performance is identical to the v5 set.

Because there are some substantive changes in this set, I've dropped the
R-b's. Please resend them if you're OK with this version.

Christian, please consider these for v7.2.

Thanks,

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
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
Jeff Layton (2):
      mm: track DONTCACHE dirty pages per bdi_writeback
      mm: kick writeback flusher for IOCB_DONTCACHE with targeted dirty tracking

 fs/fs-writeback.c                | 59 ++++++++++++++++++++++++++++++++++++++++
 include/linux/backing-dev-defs.h |  3 ++
 include/linux/fs.h               |  6 ++--
 include/trace/events/writeback.h |  3 +-
 mm/filemap.c                     | 15 ++++++++--
 mm/page-writeback.c              |  6 ++++
 6 files changed, 85 insertions(+), 7 deletions(-)
---
base-commit: 7e2326f4275c11652e1fdaae11de06159fef1d90
change-id: 20260401-dontcache-5811efd7eaf3

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>


