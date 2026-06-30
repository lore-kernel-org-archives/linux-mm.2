Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692B3C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 21:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49F96B00AE; Tue, 30 Jun 2026 17:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD40F6B00AF; Tue, 30 Jun 2026 17:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4DDA6B00B0; Tue, 30 Jun 2026 17:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 749096B00AE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:19:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF1EA12012F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:19:01 +0000 (UTC)
X-FDA: 84937844082.29.11F8D98
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 31A1840007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:19:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SQMYVLUO;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782854340;
	b=S8zzllwLb9L0qjV2YuR1ev943YYXSch+toRhm5ZTB2RPtfdQeHGotCviVL5f8oHsQLBGND
	XzsRc+UpukRY+3LptMTHOd5BSkp51dVpYGMl8BqIofweKvnEVr/7iSpdkrZdYpwXwAjL36
	yp0GDxRvS03rLPSxZwUByp7mtJH/1Iw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782854340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IlH3KkL8/9MzSzFxKUCH14o1Ashb5MOZ1jESfo9s8Rg=;
	b=QZCalCxN4vu9/SlhI3aGlYQShZupMDLp4Ms9RQI+7AGgYQw8jBoD2O+1EDMd7hXFWi8KI1
	iTUl0DBmmAt8oOROgCaILJRz2rWU+qrfmh0u0N4fROJWmFRzrbDg6Z2Pr2lYd1PgVfGNlH
	cyu7P/Lq6MTssrTh8MVCJtErVwAlhm0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SQMYVLUO;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e663c828dso94589285a.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854339; x=1783459139; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IlH3KkL8/9MzSzFxKUCH14o1Ashb5MOZ1jESfo9s8Rg=;
        b=SQMYVLUOInrB/SOKRKiqIG8/xHyqrtBvqsgtUsooenVyKYcg4/aIMw2veWaf5XiNtG
         AuLekbzsOZVHtUFzP3JsMNCpGXk943iWwl2Pj8aSgN6CU+sm3RD2C2lsyNKmOy6IjOLE
         GiHAHmc/rzGijJp1sWffsIOxVotNm0+tYEOYYK4GhMK0O657t2EED5qci5aC3+yBEzxu
         EtzSMV35+zdn3bAkpB8286YVmJjTUzKE4QoKbHCGuZR1HQlRFkv4tu5YnIApG2tVgWoA
         TPmpHosHbyLhoUiIxUtT2KFDYTMZj0bNAx16JywWFpvpWddYvIQggWvzZ70mM2bd/qtS
         REzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854339; x=1783459139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IlH3KkL8/9MzSzFxKUCH14o1Ashb5MOZ1jESfo9s8Rg=;
        b=RmdzvRgE7AXWITqieBY3J/xVeYolchoWuIcllb6ZjNzHuAfj0J+Sc8VyqGyDCYr+Bx
         IvUYs1/LkrGx6DriCER+oFyFOwz6qtwDOV85DXSyb40+hM/wuzVKIC8HSgL4GSnkaFwJ
         FGFMW610d+wPF5hPyUZkFEG/o+dYVPoc5SQoRFhKCGKg8UrIGup1ABw6Gl1u+8A5hEYM
         FanrUpxde8TzI+khf2RTBy3aX32TuROlJqhdawMjVlgu7K+877/nhg50hLI5/kiWpTNJ
         S8MMtUypkxe3hFC5/6N6GPMsLi1FR9s8hJCCAzJP2naBxo8acfe3KLAVF385iLeSJL/C
         Vxsw==
X-Gm-Message-State: AOJu0YxPlSdj60/PkqqPc6ODf7XU2PtzuufsK5ePYwLLevBEZz1Wk2dy
	W6eHa20E5yY89GFp7sf+erliDc/Rc5spIv5i/NwVnmZ6VqI/KqoJcRJ/r6noWMAmOedmWV30Cku
	W7fm/
X-Gm-Gg: AfdE7cn91gmVFtCHZGllNoRy37FgX5r13QwDJd4nYgllcB4VS4t+3qp2oQPz9xEpGvS
	iZXlryJyponFWlEGU26yqQEaqZUyB7pa/3a/l31OvPcjBDgXspfhWzKq6v58WoBSWvdlgjlEyGs
	bhQdRfXOOnD46EQ1EJXudoyuT9p8/5LOeEa9IwuJQREoSiBu361gOgenzP4gtFjm2W+lG1Z8Zul
	NWq39gC82l7SkDsOEEgruO5TGfx4qCq5HHPmP4sv/kWHuGU3h2sXakigQycgNupTQrvbQ22gN0u
	UPLTOwY4qeRnbUopAPMG0c6pBcAmQCfG4Y1I1ymBm2XqtgEilgxpLoALnNDASzKMYi/PrYc02vK
	+dVO5tMvWPj/nhRafhmZa/oQOhzXL4lKyYiU6Q8NM0AFwlHfVjl7+PRn9/aYnV3/zHeGEWl0VRd
	wW6l71abN3q2q1GF7Bf8pYDOo8cRaCs/jfxY4fW8/hQZvmdHLN5BQTBgHGkszGuj83Fo1KhAXne
	A==
X-Received: by 2002:a05:620a:29cb:b0:92e:5b63:224e with SMTP id af79cd13be357-92e697c18camr444975285a.22.1782854339094;
        Tue, 30 Jun 2026 14:18:59 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:18:58 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com
Subject: [PATCH v6 06/10] mm/memory_hotplug: add offline_and_remove_memory_ranges()
Date: Tue, 30 Jun 2026 17:18:38 -0400
Message-ID: <20260630211842.2252800-7-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 31A1840007
X-Rspam-User: 
X-Stat-Signature: xft7yt68j1zm4mydzsm5ooxexm88pheo
X-HE-Tag: 1782854340-376280
X-HE-Meta: U2FsdGVkX19facy3nxYbrquKszr7JLPYzGEVYiMlfVgJB8Sz/rB+oj6lW13B1VPiCa4cXg3POWoC9oxEbty/Q/mzgXb9kzUg20wcYX13Gxm/Rw33u/vAK+z5UeWBBjMv6S7vTDBEV5/JTs3TKxZpyuq9UxCii6YeSkkrtPcB++UaQmr4VCA4/uJOggo7wuabIQzKsBMKR3eIoAhqvUgTCXilXuQt1OI8et2NT6NMRdLaWHTc1qOzBuWjAbTnNmkb6gUULcaWA79mRWN+CC3RB+J4vVYtHw/IYwQwW5wQC4p+VzC3Wrm/QKxdPwypMpQCaAcJXtIO4yrLGf1isbqrYcC1Cuwm7q7XQcF8bG3nb8vbeal2i+AhU4HurQG9+BqRP1mOXVQgmgZJY4WzHTd1+71o/VId14F9Vt/Qved+d03zphTaScxXcrttimq0edh6xsf4Svtj8ZCjMADtXTWoxivdN2EXZdeA+dEwVk1vl2j0KyhEgsgd3ZyOn5ZJCafei8HCFHYoKbYMfHamUm5gpvEo3pURG+0y0BLYkVAIeoD38ItizdmLNtxF/4OI+dVfpVd2Dut8F9ugF8lnpD01QpemwoNLZ9WFBgG1aYG6zsZORvfmwRbDVZxyrVhgPx1vKcVE2FOs2RVy8qRhpIKmvBXLtbEhTUn8KuC0w7GcTEtbRyrVAKSpMLkkpvODyRLx1tXvbL+T6ATSwWmcA8RHfRYhmkd/3gPTUNrlo9cWqGB1egZ+muSwQj2uVgVHg8eJiwlxCiF19C01moN6cO7HRORyHNBXy4YS1it9sRrHdEmC8XP3AjmOnGvw86ppq6CQica+MxbEFqp9yoYvGaRA1Kxxdh1diQtyjAnLCaDVL4n6XtjLFWcuocr0LPIFQ8vcMX3v/77Pk4DILK/SQ232obXPzUdGj8asf2+KNOOHixSNI59Xn3DduhwJO82mtxpxM7sV/5DiyANyxnupUVL
 1GkzbpmM
 yocfWYkzMeMxbJwOqO7z3JYF79osGr35HmYyALjN8QTuEar62ye0L5EwCZSJKKaIxYhpFPcNpdSWZXOKAGK0ycbZicpwsOvIcb+jQFPatMNcadrLgSLb9LHLTLNfyiRyXy8Js8HA+d8jxNXfSGJVl8S2D+u1v+OEy6JU/lKH0qdXUkwVcC/GLUxXLbUVHBi6TrIuNY46ss8s2kjWnOtfcmTTSOpv3sMczhEzOw/x9I/7ZmbSkdU2GmmaIIsvg2w7QjVLOjEG4YcaKinG86p+X+O6tvUngqjp608zpIlk2CHfu27HyLzPUEyOwiWd2sc1r4Ssz/s3GHQrrQHeGF460F2nvbXa9P/Tbnxc7UakuxTeE6cqaoCvlUq0uPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

offline_and_remove_memory() handles a single contiguous range.

Callers that manage a device composed of several ranges (dax/kmem)
currently have to call it in a loop, which gives up atomicity.

In addition to pushing rollback logic into the driver, the lack
of atomicity creates a race condition between system daemons trying
to manage the same resource:

   - Manager 1:  Offlines memory blocks.    Removes device.
                                        ^^^^
   - Manager 2:  Detects offline memory blocks, re-onlines them.

Add offline_and_remove_memory_ranges(), which takes an array of ranges
and processes them as one operation under a single lock_device_hotplug():

  - Phase 1 offlines every block of every range.
  - Phase 2 removes the ranges only if all ranges are offline.
  - If any offline fails, the whole operation is reverted.

This gives callers all-or-nothing semantics for the offline step, so a
failed or interrupted unplug leaves the device in a consistent state.

This also resolves the battling managers race - the second manager's
operation simply fails when the block is destroyed / cannot be onlined.

offline_and_remove_memory() becomes a thin wrapper that passes its single
range to the new helper, so the offline/rollback logic lives in one place.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  8 +++
 mm/memory_hotplug.c            | 93 ++++++++++++++++++++++++----------
 2 files changed, 73 insertions(+), 28 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index ff3b865ea7e7..db10d50f30ae 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -268,6 +268,8 @@ extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 extern int remove_memory(u64 start, u64 size);
 extern void __remove_memory(u64 start, u64 size);
 extern int offline_and_remove_memory(u64 start, u64 size);
+int offline_and_remove_memory_ranges(const struct range *ranges,
+		unsigned int nr_ranges);
 
 #else
 static inline void try_offline_node(int nid) {}
@@ -284,6 +286,12 @@ static inline int remove_memory(u64 start, u64 size)
 }
 
 static inline void __remove_memory(u64 start, u64 size) {}
+
+static inline int offline_and_remove_memory_ranges(const struct range *ranges,
+		unsigned int nr_ranges)
+{
+	return -EBUSY;
+}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a66346def504..3225364bec2f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -2429,58 +2429,95 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
  */
 int offline_and_remove_memory(u64 start, u64 size)
 {
-	const unsigned long mb_count = size / memory_block_size_bytes();
+	struct range range = {
+		.start = start,
+		.end = start + size - 1,
+	};
+
+	return offline_and_remove_memory_ranges(&range, 1);
+}
+EXPORT_SYMBOL_GPL(offline_and_remove_memory);
+
+/**
+ * offline_and_remove_memory_ranges - offline and remove multiple memory ranges
+ * @ranges: array of physical address ranges to offline and remove
+ * @nr_ranges: number of entries in @ranges
+ *
+ * Offline and remove several memory ranges as one operation, serialized
+ * against other hotplug operations by a single lock_device_hotplug().
+ *
+ * This offlines all ranges before removing any of them.  If offlining any
+ * range fails, the entire process is reverted and nothing is removed.
+ * This provides a fully atomic semantic for unplugging an entire device.
+ *
+ * Each range must be memory-block aligned in start and size.
+ *
+ * Return: 0 on success, negative errno otherwise.  On failure no range has
+ * been removed.
+ */
+int offline_and_remove_memory_ranges(const struct range *ranges,
+		unsigned int nr_ranges)
+{
+	unsigned long mb_count = 0;
 	uint8_t *online_types, *tmp;
-	int rc;
+	unsigned int i;
+	int rc = 0;
 
-	if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
-	    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
+	if (!ranges || !nr_ranges)
 		return -EINVAL;
 
+	for (i = 0; i < nr_ranges; i++) {
+		const u64 start = ranges[i].start;
+		const u64 size = range_len(&ranges[i]);
+
+		if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
+		    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
+			return -EINVAL;
+		mb_count += size / memory_block_size_bytes();
+	}
+
 	/*
-	 * We'll remember the old online type of each memory block, so we can
-	 * try to revert whatever we did when offlining one memory block fails
-	 * after offlining some others succeeded.
+	 * Remember the old online type of every memory block across all ranges,
+	 * so we can revert if offlining a later block fails.  All entries start
+	 * as MMOP_OFFLINE so blocks we never touched are skipped on rollback.
 	 */
 	online_types = kmalloc_array(mb_count, sizeof(*online_types),
 				     GFP_KERNEL);
 	if (!online_types)
 		return -ENOMEM;
-	/*
-	 * Initialize all states to MMOP_OFFLINE, so when we abort processing in
-	 * try_offline_memory_block(), we'll skip all unprocessed blocks in
-	 * try_reonline_memory_block().
-	 */
 	memset(online_types, MMOP_OFFLINE, mb_count);
 
 	lock_device_hotplug();
 
+	/* Phase 1: offline every block in every range. */
 	tmp = online_types;
-	rc = walk_memory_blocks(start, size, &tmp, try_offline_memory_block);
-
-	/*
-	 * In case we succeeded to offline all memory, remove it.
-	 * This cannot fail as it cannot get onlined in the meantime.
-	 */
-	if (!rc) {
-		rc = try_remove_memory(start, size);
+	for (i = 0; i < nr_ranges; i++) {
+		rc = walk_memory_blocks(ranges[i].start, range_len(&ranges[i]),
+					&tmp, try_offline_memory_block);
 		if (rc)
-			pr_err("%s: Failed to remove memory: %d", __func__, rc);
+			break;
 	}
 
-	/*
-	 * Rollback what we did. While memory onlining might theoretically fail
-	 * (nacked by a notifier), it barely ever happens.
-	 */
+	/* If any failure occurred at all, rollback any changes and bail */
 	if (rc) {
 		tmp = online_types;
-		walk_memory_blocks(start, size, &tmp,
-				   try_reonline_memory_block);
+		for (i = 0; i < nr_ranges; i++)
+			walk_memory_blocks(ranges[i].start,
+					   range_len(&ranges[i]), &tmp,
+					   try_reonline_memory_block);
+		goto out_unlock;
 	}
+
+	/* Phase 2: Remove. This should never fail holding the hotplug lock */
+	for (i = 0; i < nr_ranges; i++)
+		WARN_ON_ONCE(try_remove_memory(ranges[i].start,
+					       range_len(&ranges[i])));
+
+out_unlock:
 	unlock_device_hotplug();
 
 	kfree(online_types);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(offline_and_remove_memory);
+EXPORT_SYMBOL_GPL(offline_and_remove_memory_ranges);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
-- 
2.53.0-Meta


