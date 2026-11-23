Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E568D606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gYPiHZXO
Received: by kanga.kvack.org (Postfix)
	id 0787F6B05B1; Mon, 23 Nov 2026 12:21:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 028E96B05BA; Mon, 23 Nov 2026 12:21:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E807E6B05BB; Mon, 23 Nov 2026 12:21:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C83E36B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:21:44 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B3D8160922
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:21:44 +0000 (UTC)
X-FDA: 85467050928.07.AD8D368
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3B0071C0011
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:21:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gYPiHZXO;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf18.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795454502;
	b=yK3uMVXC6TCogzPiEowjHQ7fHFeUgXwgV13hXixVroD263aKhCndQ+r5owRhxfV19EBqhB
	EE/nvnN2xsTsV9E3YoPA08LQg5I1O4nlJ3ngYNp5pPU1pzQWMFjgbj7cLgfHc+SLumI1f3
	ljXRtroneestxO8UcW++ZxHXjUeAOHc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795454502;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yJ5tdaDKAQFPPpobEHTb3m5msSlT/95ZPGIa7uQNwzU=;
	b=7GaOMEzecLM2fU/5gmNJpiZ7E4RgFayPruDDot2BhBs3zUFru6ked7QVlQZUSWkTo9FSmg
	XSoS08LhbZh/3P0sUL759iRX2iewosFLTotbaQA2H59i2cM1OtH46/7KGIn7dI2lAv2RXa
	Byd2moyGhdZ1IzH1/d6XybPEPET3DvQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gYPiHZXO;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf18.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB8F661D1E;
	Mon, 23 Nov 2026 17:21:41 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795454501;
	b=uFzMR40oaq2oPYXahHxw7cLxEzwdbkUNVaNoS5fhK3kHFG0FP6GeYU1E7G8mBkaa05+Q
	 3TAcfLfQ3PnRJ2ajFCh+0jCSR/EyCmG4xYhvMnrvf89HlTuCpJ5yCRcYaGRL2Z7aaF5hv
	 ptMvohuIpT7q3sYxR31evs6U2jeN1ub7aqRQiVeIPXWXsR+7QXJJ4qGdlfPfbete91I8A
	 RGOGRGZ+IoGT0hCKK6L0Zi/WMKv/STZOC3zWPemOgrwaVVMmX3IElkONr8200E5dAGFeL
	 cJCfket4SI7LG0RI3WNwAZfAdnx+SxUiORJIdz26jaFQ/RYu3PUS+7NEHf4f7joXH0A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795454501;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=yJ5tdaDKAQFPPpobEHTb3m5msSlT/95ZPGIa7uQNwzU=;
	b=gGXYN7xCKNyQ689zozuAbrbbtZ8gcze98fYvrQzrDRmcxvYJXYnvxZjnqypm/SBrfDD8
	 27bXvzT/25cVxBl09GTeDxkcXURqMzQ7Xy15Cy7oIknIYia6mLoppe/++wk0PbuWyHrPg
	 LhM2HokH0NjhhY+FxX92jGBUvjKIU6jnAUr9lCSQqT6hXrmirOacI74IHzS6KftrdYyPD
	 fuumfa7xDhIK4VoyNq39/Br4/cFWMS3W5m63tDkNKWtIfLBpdfpsffG922lIP31bwbKOv
	 fVFte+wv+JU/jGOujD0DpbH1g+Bx9U8QwTMCpikBGqYpPIcy8/nFYbRcOD8iceIsw4Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BAED91F000D3;
	Mon, 23 Nov 2026 17:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795454501;
	bh=yJ5tdaDKAQFPPpobEHTb3m5msSlT/95ZPGIa7uQNwzU=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=gYPiHZXOsBYul424C2tHonPOl2PUFVErl5MJKKs5meCWR3SCWIVrVW7TwUN7+k788
	 htE/P1KKvAIxp5SbhTkHTW7stPvzlysM+qJjGsspq54+LItHqU+J1jtnrtupC6P6bw
	 2KBbYGPeL7dZZ8Iaj5QlT2g/pfdRRBOmgTCR13NWhhZh6KI/KT6hXtR7HLG6njDZ9R
	 /cBmgdtAMa2xFBtIRqqvHVxANgxoDUE+zMSX5x24zDvHbkfDAZ24njq/WSH1Sw/UOo
	 bBsYe5S+PS92YE+trbrCK0DiEuzGkFqNMFDHd7rkd4kIrGGGvah/gjftW64QohI6P5
	 NmljdJyJ4CfqA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4262B4C581;
	Mon, 23 Nov 2026 17:21:34 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Mon, 23 Nov 2026 12:21:34 -0500
Subject: [PATCH] mm/shmem: don't drop a folio whose swap write failed
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261123-shmem-swap-write-failed-v1-1-41a0115dfbf1@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQ6CMBBG4auQWTuJHQMhXsW4KO2PjBEkHRASw
 t2puvwW721kSAqja7FRwkdN30OGOxUUOj88wBqzSc5SOScXtq5Hz7b4kZekE7j1+kLkJiBKXaI
 upaJcjwmtrr/z7f63zc0TYfruaN8PouPc8XsAAAA=
X-Change-ID: 20261123-shmem-swap-write-failed-bced285e8526
To: Andrew Morton <akpm@linux-foundation.org>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>
Cc: Chris Mason <mason@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Tal Zussman <tz2294@columbia.edu>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795454494; l=2695;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=YZkS8z4nKi2wuUKuI1w38QEIWGBn1hka4U2KKfBBdd8=;
 b=d1A2Jbz2YdcvzAkeX34oY+L/eDQiZJwjs+Ba8yDMxbqQPOWBbjimDgjlrMGcsx8rIoPhofk6v
 r+eHSy/2jevAy45EgB0WGi0sTG14AtoEENRVU7lykD94wVL2tH1oNET
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3B0071C0011
X-Stat-Signature: srwm9tykef9wn9pim4x83op6f99mfcmh
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795454502-221750
X-HE-Meta: U2FsdGVkX1/gv+5MW5kKypI3uDsy5lzPW7pfk474/Azf6n/oUPLOctGzHiph+boF3Sh8PnUP/6J6aF6z0apjtmZv4ILJlGQrtgD49PPmDcDRxHBYO2/WhfCmnBk+SQKykyJ1JCX1b85AiYdYB7Dl85dlCuJbpCV5NjYv3jMxtu2eGlbSw1NSqgEHR9/xmX+cdTITtEFDROy4MGeeqrcryoBYHBA5xDziReB9ipmxpocR/uu1Dn/c0RMLBNZ+lVYy4EZX2suhLfc1BYLuE5owH3J44WoIU54ZZz/UQXqGSsv957cpJq97X/jTokAmj5lp5Jtsl38/kZiX058U+53Bm7Avf3HZynxGtsvpP0wfAKQZroxHH1C/8agQ7Hz5b5DwvAexQWBFiF1A01W0p3ZqrKEbDy1KSnda1TyTc0IdYqDwtlzLhj0HoSMm7BwiHyjmWGF/4yirjXub3MIQdFDkjRs4P/VvAvZdi38ehW5ylMp8Q8494DStshBg26DPzJTyzhBg1xhRRKyZqIhO/7mqRRloM8mkgOglWWSVRJ2Dja+Jkpxp2eiRU/dR7YWUatkU1Mr8tkkJ+vdg+85bsrihOFQ187oleItKdbNL/GVRIvLBu3h6O/LV0UWn9fxwauHn81WWZk8bZqHb/5xj8EVysypiMULwA2AfrMyWNRA8GJaoiU9zg5pKsWHnYAqPGwi5wdH4Y03IjQwxzW/3aqrHAy/HvnVpJJuUhH9wImjSj2ag0K5VqAamw8sXpPgUJwPeZc/GFlY4X9ICnKGw79WK31fD2qiKE5XWxS0ojVG3r05zoyh/etvvWlJO15OtADbb/Zh8O4yIyvPl2SNMd2g98mLRhA+q4p9q7jJeVgOq560M5nMFHnNrtxhPmxdg5KQqOPRyPD4ZDr+3JDWx+sJ7u0GHaQMZrTtWERbuqEBgtDMEA81QxPWwO38BMciU/i9/TODPPiMJWl0nZgkx5AC
 sCuoZlHt
 SuhPXf9fTWLSSiGrszGT18oLD05JAeI2rrtPXzXuv3uNBzjzS4hxOSbAdenMsarblPdOUWn0Ox7VVvujBOPcfG/VmWgymtGjNtG7nDvkZ2tt7ISjrDtSk39TIdGrAM+dPTHiwRgyPnFJkxEBZErOf1pwZcNOLbFVLUWhokrPmm/xy+RqccppSVEWineI4v6FTuUdTS00h5zbeQficVAuc/q4jugHAaQhpIWbDwodzRDwW43FCa3YJRNgCwxG3UHh+V/aoZnZl4dIZJ5+YbUYNDnH58/7Hy7Exz2kc62iKHrBQF6Wk8nHEG7Xtss2XX0rs+/P3tX5E1+TjQadsFemmazpVUQOHXjedBX4gQ2sp5difojTn8mFlm/ygLwF3i5L86qKiW8tDyAo9SfJcQi5Y61ImUoNWSYP0NGAR+maUBXv+Ozgb5zkt7CktsGdi2e690cn4hnzsp5m3v7Fqhbq7wQ7pyII9PDwqr9bu+eoIY9le/B10TW/welSgEjsNAlQ4UsxRH11G3znDC049SOIGZiBh7vy1kLqUUTG5ueiP+eVjBFdUyNjXuETs7vtc8gWbIra3R8xGNz4RgR5ijp7l2K92lGv63//quVZ7NR9cLHdH60SOwpxK7hEfGzU5K1Czx8A44LAQLG7NG1KSFs3FXyuzmXguzyWyJtZ7MGp2W/4tEVIu/VyBd2dyKHvA1qW7RcRhf+Oz0sBveXg5BVkmYahIhNoQo0CyrlOKFK1eRRA5GsxkYdzZEw4vnw4/QbwQczz/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mani Tofigh <mt4022@columbia.edu>

shmem_swapin_folio() drops a large folio that does not fit the mapping
from the swap cache if the folio is neither dirty nor under writeback.
The folio can belong to another file and be under swap writeback, when
the swap entry was freed and reused before the swap cache lookup.

Swap write completion does not take the folio lock.  On a failed write,
swap_write_end() marks the folio dirty and then ends writeback.  Since
dirty is tested first, the folio can look clean and written:

  CPU0 (swapin of file Y)             CPU1 (swapout of file X)
  -----------------------             ------------------------
  shmem_swapin_folio()
    folio_test_dirty() == false
                                      swap_write_end(), failed write
                                        folio_mark_dirty()
                                        folio_end_writeback()
    folio_test_writeback() == false
    swap_cache_del_folio()
    /* X's data is lost */

The next swapin of X reads the slot whose write failed.

Test writeback first.  Both flags are in folio->flags.  If the
writeback test sees the write ended, the dirty test then sees the dirty
bit set before it.

With the fix, a folio whose swap write failed stays in the swap cache.

Fixes: fc2c19648d68 ("mm/shmem: fix swapin livelock on a mismatched large swap cache folio")
Suggested-by: Chris Mason <mason@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Managed to hit this by forcing the order in a VM, and it's gone with the fix.
---
 mm/shmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e351cd425d69..867f43315af1 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2664,10 +2664,12 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	 * A large folio that does not fit the mapping, e.g. because its swap
 	 * entries were freed and reused, would be found again on every retry.
 	 * Drop it from the swap cache so the retry can swap in a fitting one.
+	 * A failed swap write sets dirty and then ends writeback without the
+	 * folio lock, so test writeback before dirty.
 	 */
 	if (error == -EEXIST && folio && folio_test_large(folio) &&
-	    !folio_test_anon(folio) && !folio_test_dirty(folio) &&
-	    !folio_test_writeback(folio))
+	    !folio_test_anon(folio) && !folio_test_writeback(folio) &&
+	    !folio_test_dirty(folio))
 		swap_cache_del_folio(folio);
 unlock:
 	if (folio)

---
base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
change-id: 20261123-shmem-swap-write-failed-bced285e8526

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>



