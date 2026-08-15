Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD2F1C5DF6A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 01:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B21A6B0759; Fri, 14 Aug 2026 21:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689606B075B; Fri, 14 Aug 2026 21:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5DA6B075C; Fri, 14 Aug 2026 21:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC6F6B0759
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C85C1402BD
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:28 +0000 (UTC)
X-FDA: 85101846816.22.E98E52C
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf27.hostedemail.com (Postfix) with ESMTP id A898D40004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="r U198r7";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=I34fodJa;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZeRnpjSx97tLsIjgu0PpuEyM1aG2ncyWgDrDsC6Hoo=;
	b=MtJ8jhgnc2snu4UrJ2AnlW9paErlanFNFSSf8A0wTiU3xO17krXOUHFl+J2KqxA8tqM8k1
	W714Z50s2//KTrVztd3EAEVxQRCv+MleRHFfmnzS/smBozSdK6j1PSwo5rwv7vV7pos7D3
	TYhigaGjEA3wh9IOUThziJzoQYVdUks=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="r U198r7";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=I34fodJa;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759166;
	b=6J+vfPy1ijdYCf/Ytcr4CPPMtwDZT+a/m5mfUIz+5RioSf8nUHiCyiKj8TEh1XlswbY1up
	la6WqdpyCIRH9D8H5kTDNZB7krQDAN3d+tF1x2+Hc3SBbPDSD22qpf/CRaLmHrXx5/3R2o
	FWzAFk6t2hTz4hvkd2iEY1QqR2/3M8Y=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 51902140011C;
	Fri, 14 Aug 2026 21:59:26 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 14 Aug 2026 21:59:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759166; x=
	1786845566; bh=CZeRnpjSx97tLsIjgu0PpuEyM1aG2ncyWgDrDsC6Hoo=; b=r
	U198r7rP/Vc4FNI1a1rsYY0AuCB2FeQfyW9Ri/4ejuwfJMpi3AYfcdrJB0ZXtqBu
	ZeGi2R+yMTFrrsnIo/co7ZOuqesSYpNeyLVvxg64gFVeItTPa8rKFYs1xe8k2OB+
	HO+OPSHVMnwTl3z/yyk/bT2uc0KfGjI/RB0i4KKrg43yXI8f1Hholgg5kPw8ZhjH
	0cHpcADSCIBupi7ToBr7GBqPA8az13G46PpE6FY0dgjit/5D7tt+OhdroKhxGGrD
	LSKIAa81stZFgFwUGlBskXv5thasHWRnU68Bczjp8ehsE2I6//C5z7LjM8m7402q
	tPAZftuJJuP4hJzB0Uwjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759166; x=1786845566; bh=C
	ZeRnpjSx97tLsIjgu0PpuEyM1aG2ncyWgDrDsC6Hoo=; b=I34fodJaX6Ch2ggTS
	A+vh4cgl2R5Ef3LjfuLTe/PiY2DiSng9Hz3KZaT7RjpP26/Lf51K3RUo3AChNCVJ
	oUS/U+Us3urjBDykrmAaEAVMlTHd7Tt1N0lVBk8tE/EcQVI3PapHSSq0/QS6BXBP
	vZ8sAzRXefCs3yUvUXQWFLlxrgji7DmsmXEEH8H4LpJ04b5tLOKVYy+gYIBEnhiJ
	dVgNys0iAa1gPVP0cp40n2QxaaAl3rHUWRVjlOAWaURqJnZ60Io4WNd5JTPhgKoM
	llSzhplwvz50PR32F7hBqKMT5InxPRrf25Dutq7vUtsJQ/PnqErUK2o262OxA0ti
	RAijA==
X-ME-Sender: <xms:_sd_aq8ruvr_1ZmPG7PJ7p9vJQztGbIYCtuXocfXolcaih_tqQsVYw>
    <xme:_sd_auoaAtorVqlrsVCkgb974dxYeFOqGMtd4qNV_t7hlEkB7tvV2GCg2p3G2JGNI
    zT_54k_67sMN0-pcOCgKxQVD9txSFiXEU7Sc75p280CZHEb-TmIcok>
X-ME-Received: <xmr:_sd_aojxiLvo_gbJoOL904y38r8J695MvtQzP30o8IBTfncYcY6qF5ESRrE>
X-ME-Proxy-Cause: dmFkZTGF7teVIHNqoa5p2A8iL+trOmU4pExV0BsGEGBxavUqSy3vvyW/t2uVaC82ybAhbC
    FZe2jS418ApiE9B8lCjDVAvs2O/1hVxxIyd2QmVeomYKnxIQlXrdOkpVI2/A6aay1R5wM6
    752pE1oD84VvsYvCM8wHufwfHzQzVg5WF64m0thPV1o6CCL0N8QD0816LOjK9LaF9KdRdp
    ShDgDyNTb/bU59JqJj/g3oSWXYBnQXQHEYh7kafl/PHtgQjoSit3F73LPXI/q1yj04b//y
    CUybFuAxuhlNqjceRELXNaCNxBn+qS4c4JK+cmo8T/HSoyzm/Kml9mcKob58Fnvz9v9Li7
    CoAEwNoLKJKn1qX+J1+9JwWz88Soz0MhWY28+Pguh3s45O9cQLypQR3KYAcDBhW6yE7XiM
    IyLtH1lmqZlpPb/jzlLd6/i0Jk5epL1pZtK304Xa71zdyS0MDI21QIx3u3gG0UcrR26/D9
    SkQYYRyecImQhU4ldepeg+YHoG4G0/PcBdHE016KA0hy6E33QauH0LyoPx9juZnXgLF7/4
    z9Q7Evr1kSl9XtCYmVfPWcO7x6pujAbU8SvmOSfEfvTyj8vgAPZSxLsx3PFEbuY8tiMQhz
    w/GIfiAugxuu4ruNTl34Ng8To0SmNlHuT1ksGvmpb2iecpc9aigE6lCO6c1Q
X-ME-Proxy: <xmx:_sd_asAXi-1vyYPQP11MTeh1J_0dYzaPsnRL6XudAswt_m5_aWyjBA>
    <xmx:_sd_amvvV095Ulqy4sxA4YtAKKGql_gLcYPuqNwL3FbLtf14eGOEkg>
    <xmx:_sd_am4keEkjIhVvTR_6k0nRraY2Z6nY86HFhKnDoiTkZRFrp2FRdA>
    <xmx:_sd_agd9O4KG797k_fbNKObllU87Jl-koN6EchLL8aSJbstYufHAyw>
    <xmx:_sd_avc0El1mTe_s5C3PyethQyJj2NiJxoppBXfMD1Gt1Sl9xzCZrKb5>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:25 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v4 10/19] selftests/mm: add khugepaged completion barrier helper
Date: Sat, 15 Aug 2026 02:58:52 +0100
Message-ID: <20260815015901.1236937-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xuqc4rb41bbn576581dz8es3e9risqze
X-Rspamd-Queue-Id: A898D40004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786759166-141899
X-HE-Meta: U2FsdGVkX1/1tJw5WhSZnVM+bOgo5RZIOX/dMZrsqkFR7SbhKAYq+ZMPbtJe/Hc9/q++rgq7ftk8cOphgytkH5H8xbLxfJthE83pcsY74GomPctuE6dCeJ+0J+//x9wdcQwm158e4gyKyBlOK5N7YbKnjvdqyYLiUz5BJ9W7sXc/yYBFIiCEIie4BkKnpS0INInLAgtBat6nviH8//+jr5tJi0wux/Anwfch8m/PG5s1sVkGaF4D+b++m5ach3r0ZaUX6A9li6+U+T30gLayl8TFs6w55kgVhSFcurH78gL7aRl7616mJfm0rSfbOlPgJVz9Wh3wni7pdCWqzivVuCdbO046YA/Ev4H8vk2Ijq2UxL6mXFGcGHFYdLoWudrs2FJsmnfaSqUIEpeu141Aclr5AooT7QguPJCCgVW0BuczhoGvDUGo/qMb1SM1Rp4+WQ1RQmD5ChugkfzhQmMcccOXBr0KK0sItoM/bvJutfpwKtBc0mVKDncYLebGXMymWsJxLs8UQtO9zdoJ2AO1xhbwkybrKT1hY9xcnUfd5UKrTbglfV3EQ/j8AXd32FjmwahSyt2Flx9V1g1ZwpnZ4LXspeoRyhRnL3Gyx04jWqHj2Jfcqmqa+F12/4JKHvuKp1DZ0yrHs3csKDWLPEi6ViQN3cfkQxQ/qvPR13ikoB6qqGnF0ysnMs/e/R9BXkySGDraHrA4fOemZervExV0pKTrycO4Je368sJ1Mmrged+oOiWg/8t6T+A8i54t7iH1XE1iSs4MimSQ07BojWsS4DNmK7223e7O9IPbeUgVRYlj1nzUimHxHYg5YQzX4mV2+kYGMbWlWqFbzOoTbHPlXihJvQSfu6UDJz5hZJQcZvcMp/al80R3jVSCVu2h7oQzXtcQHoZTpIq/y/6b/6jICwpi9AhfVuTPgUeghaHJWbymFq8xzi+DCXLnWsDSogrzZNLph9k59XIbDPcqAfK
 mvzD2jhg
 EhADYGpb4Jy85huXIJp9ajm6SgKNohiEKemMgKLR5XfW7c2AM9RyDcV2j2Dv/NzAZGuYnzNuqziORRD9u5E/G/8GY8qIJ5eT/TObgB9O/WS53nEoSDaOLqe1P+mdHrxPK8DX9CL5p7bojyUjmCKWWn0GpnrHrdXZISPNnctOZaq6GEAN2KzXuog87sfEKCRMo7nah/lQq+pCnNJk9TCuM3HAjeTxE/h+AJ03jumrZ7J0ZlLX4eFs6aCiZFrVglDNK1NlTFCKyhQV9BGJC3YQo3yGLlkXxthKXa1RfljBCGvWu+RXMx7od4lEHZxAp9mABHdxrrr/3CuvjeWuNr7mpwTSG9ZckdQtB8ThOUP580r1w2N0Li6Mo9eX4qpGdnD77VF1W9X3Kc79TWT03nbCHpj/QXkn+za9Xr9V9lTqsr2h6lw3+1PCpKIFGFBg6G2LP0Th3D/qqUmAEoDrFkELYWJBZoHRK0k6LkWGZYMeCQdZstuScowtDCuEX9IE66gKRmZMT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Race and functional tests need to drive khugepaged in step: set up a
layout, let one full scan pass over it, check the result.  The khugepaged
selftest already waits for full_scans to advance by two, but only makes
progress if scan_sleep_millisecs happens to be short.

Lift it into khugepaged_full_pass() and drive it through sysfs: any store
to scan_sleep_millisecs wakes the daemon, so the barrier completes whatever
the scan cadence.  A store can be lost when the daemon is between scans, so
it keeps storing until the pass lands; a store to an awake daemon costs
nothing and queues no extra pass.

One wake completes one pass only if the whole mm list fits in a scan batch,
so callers need a large pages_to_scan.

Settings pushes must not start passes either.  A store to either sleep knob
wakes the daemon, so thp_write_settings() now writes a khugepaged knob only
when its value changes.  The other knobs do not wake, but writing them
uniformly costs nothing.  thp_update_num() is exported for tests that want
the same restraint.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 .../testing/selftests/mm/hugepage_settings.c  | 74 ++++++++++++++++---
 .../testing/selftests/mm/hugepage_settings.h  |  3 +
 2 files changed, 68 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index d7917dce3aba..992efee17b71 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -183,6 +183,19 @@ void thp_read_settings(struct thp_settings *settings)
 	}
 }
 
+/*
+ * Write only on change: a store to either sleep knob wakes khugepaged --
+ * __sleep_millisecs_store() clears khugepaged_sleep_expire and wakes the
+ * queue -- and settings pushes/pops must not start scan passes nobody
+ * asked for; khugepaged_full_pass() is the only sanctioned wake.  The
+ * other knobs do not wake, but writing them the same way costs nothing.
+ */
+void thp_update_num(const char *name, unsigned long num)
+{
+	if (thp_read_num(name) != num)
+		thp_write_num(name, num);
+}
+
 void thp_write_settings(struct thp_settings *settings)
 {
 	struct khugepaged_settings *khugepaged = &settings->khugepaged;
@@ -198,15 +211,15 @@ void thp_write_settings(struct thp_settings *settings)
 			shmem_enabled_strings[settings->shmem_enabled]);
 	thp_write_num("use_zero_page", settings->use_zero_page);
 
-	thp_write_num("khugepaged/defrag", khugepaged->defrag);
-	thp_write_num("khugepaged/alloc_sleep_millisecs",
-			khugepaged->alloc_sleep_millisecs);
-	thp_write_num("khugepaged/scan_sleep_millisecs",
-			khugepaged->scan_sleep_millisecs);
-	thp_write_num("khugepaged/max_ptes_none", khugepaged->max_ptes_none);
-	thp_write_num("khugepaged/max_ptes_swap", khugepaged->max_ptes_swap);
-	thp_write_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
-	thp_write_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
+	thp_update_num("khugepaged/defrag", khugepaged->defrag);
+	thp_update_num("khugepaged/alloc_sleep_millisecs",
+		       khugepaged->alloc_sleep_millisecs);
+	thp_update_num("khugepaged/scan_sleep_millisecs",
+		       khugepaged->scan_sleep_millisecs);
+	thp_update_num("khugepaged/max_ptes_none", khugepaged->max_ptes_none);
+	thp_update_num("khugepaged/max_ptes_swap", khugepaged->max_ptes_swap);
+	thp_update_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
+	thp_update_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
 
 	if (dev_queue_read_ahead_path[0])
 		write_num(dev_queue_read_ahead_path, settings->read_ahead_kb);
@@ -230,6 +243,49 @@ void thp_write_settings(struct thp_settings *settings)
 	}
 }
 
+/*
+ * Completion barrier for khugepaged: wait until a full scan pass that
+ * started after this call has finished. full_scans must advance by two;
+ * a +1 step may complete a pass that examined this mm before the
+ * caller's setup was in place.
+ *
+ * Any store to scan_sleep_millisecs wakes the daemon, so the barrier works
+ * whatever the configured scan cadence -- but a store can be lost.
+ * __sleep_millisecs_store() clears khugepaged_sleep_expire and wakes the
+ * queue; if the daemon is between scans rather than sleeping, it sets
+ * khugepaged_sleep_expire itself on the way into khugepaged_wait_work() and
+ * then sleeps for the full interval, having never seen the store.  So keep
+ * storing until the pass lands; a store while the daemon is awake costs
+ * nothing and does not queue an extra pass.
+ *
+ * One wake completes one full pass only if the whole mm list fits in
+ * one scan batch, so callers must pair this with a large
+ * pages_to_scan.
+ */
+bool khugepaged_full_pass(unsigned int timeout_s)
+{
+	unsigned long deadline_ms = timeout_s * 1000UL;
+	unsigned long sleep_ms =
+		thp_read_num("khugepaged/scan_sleep_millisecs");
+	unsigned long elapsed_ms = 0;
+	int pass;
+
+	for (pass = 0; pass < 2; pass++) {
+		unsigned long target =
+			thp_read_num("khugepaged/full_scans") + 1;
+
+		while (thp_read_num("khugepaged/full_scans") < target) {
+			if (elapsed_ms >= deadline_ms)
+				return false;
+			thp_write_num("khugepaged/scan_sleep_millisecs",
+				      sleep_ms);
+			usleep(10 * 1000);
+			elapsed_ms += 10;
+		}
+	}
+	return true;
+}
+
 struct thp_settings *thp_current_settings(void)
 {
 	if (!settings_index) {
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index 726c73c43c05..ba7d38370d43 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -70,6 +70,7 @@ int thp_read_string(const char *name, const char * const strings[]);
 void thp_write_string(const char *name, const char *val);
 unsigned long thp_read_num(const char *name);
 void thp_write_num(const char *name, unsigned long num);
+void thp_update_num(const char *name, unsigned long num);
 
 void thp_write_settings(struct thp_settings *settings);
 void thp_read_settings(struct thp_settings *settings);
@@ -83,6 +84,8 @@ static inline void thp_save_settings(void)
 	hugepage_save_settings(/* thp = */ true, /* hugetlb = */ false);
 }
 
+bool khugepaged_full_pass(unsigned int timeout_s);
+
 void thp_set_read_ahead_path(char *path);
 unsigned long thp_supported_orders(void);
 unsigned long thp_shmem_supported_orders(void);
-- 
2.54.0


