Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B3CC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78DF76B009F; Fri,  7 Aug 2026 07:37:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7190A6B00A0; Fri,  7 Aug 2026 07:37:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1006B00A1; Fri,  7 Aug 2026 07:37:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 380816B009F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:37:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C857BC028E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:14 +0000 (UTC)
X-FDA: 85074272388.28.545B464
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf21.hostedemail.com (Postfix) with ESMTP id D91EF1C0002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="N qdTKVr";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DxM7IqhF;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mkj1cRzazH/pmulbL8egXXcAWCNFw5TBX1ao39pm6/Y=;
	b=tQgy+TK7VsWgQyVsDls4mf8joEM5V5gqSrtekhcnR0wsUMRV3qhx2V4EmJ57PCyk8uzu1K
	BnRyLfsQ70oOmYT6xMwDPJ7k3NgcnBVr6KgEjMryey7D63Ny9JVoFjXSvzRww6+8+niLJz
	TmqPXg2sNY7q3cTo+5OAwgWlMxmmY5c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="N qdTKVr";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DxM7IqhF;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102632;
	b=8MHmlYXVVgFOX53bjjkK82Ko010BTp3HawRBGMER2SY7pCxkDKzt7BP9SF6yG50yRKNdP4
	9BFPpbhZ5qJiuuPp1PXHE6kzDawrEATT4Hy61kl27O7YfH+YpwZOeMmbo6bizvDSHN3UMN
	E1y5fSfhnB77EsH3I9Kg8fHqlsomqm8=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id AAA667A00AC;
	Fri,  7 Aug 2026 07:37:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 07 Aug 2026 07:37:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786102631; x=
	1786189031; bh=Mkj1cRzazH/pmulbL8egXXcAWCNFw5TBX1ao39pm6/Y=; b=N
	qdTKVrU6cJA+055lbDIi8VTIWU5S2Cqn31BcUjc3ydVqCjAWKSL7yCHYMUYjm8eE
	sRRhxhLsLDgxpSIC8uV+d4WZzukvaa1nMzvOuhADzIwTLnf8GnkpmFI+6vBoXEqY
	wwDuV3yw/i42DKp97Eo/lerGGChERO1qFNmK1lGZX3WMKEsKnJ+m4TCDKO3eH1OL
	MrOwKO+5LbA4+uO+2HV4lx45EmDNlPTya0NnchIYEsU+dAq6azKBq6dx9J+Xt7d/
	tHfWQ2+Gq38m1TgLkxk9ga7H1melRX2NIJIw+GjESktskiixYUuR6iAbqoPEJCYy
	3wgx5g452/tDuWJphDCOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786102631; x=1786189031; bh=M
	kj1cRzazH/pmulbL8egXXcAWCNFw5TBX1ao39pm6/Y=; b=DxM7IqhFYchchtByp
	rG7R3C5VR7g5dWmducfDxa5JYuJwitQTsVw/cVNZsENZtwBtPx6Lb0mM6TFY4MSH
	ZcWkPUibhqirCdvKKLce9hpH3gr0Q7OH4rnDSpnIB3V4w9fDPgrD872Unb4HdS8V
	Ctt3advfVw/VTzgfqIftrACrHWtvl3GgxYmWY28Lp79+KNe1W579W2s/jPQW+N/P
	lPoDxnukcSTGk/KJthssSHDxA8rlQ/pDLO3HAGkidGuSB+V5feuhjQCsWsXUWUPl
	94e7y6/gjG1g7RS1mlNaPzFAKdQVx6Gl9BPqkphq3MNPx5mAx+j1ifauYgxx5MXO
	AuyBQ==
X-ME-Sender: <xms:Z8N1avO2UoaGgazzNMCdTdl-SSAa4DP3m_oxPREU9aMtXwUCNt1GRA>
    <xme:Z8N1at5-xLFGBGbP1_CdT5epMyMZaZfQ-StlggqjBW9IhYwuW1bHJXrJjFwc_dBrh
    65n3AWXGxexH3q7NwIkGqjQSSq5i5McA1v-0IbPpxyonEjvYa3boh-t>
X-ME-Received: <xmr:Z8N1amy4Cvx-qXE1eI_bfb9hVN5F1JF-zGq4yztXHvUXLQv3_gxv8wqZVig>
X-ME-Proxy-Cause: dmFkZTEfW3x2Qrq7ELqxlr/x69vk0aYaa/E/2AWrFAl7yu0Vg+jIGlS0mjOCk5J5e5/NJH
    T3J+l8M+cQ15gxg/u6FQhwxKudsrf7tN5cWcEThveGDS0KcOU0uMrzGx0YBmylEV4PfT2X
    SbTqClZY3SINVohR/2NzYRxeOu5tU+SgKqY1sS5oM8U15+ky277S+G1Ww7YAUM5Z6EK46p
    TQK1COWwyEQl/dhwe51H5lWCLFzTj8K9hkk/JBO/DvOgEgoe5sMihzFP04eKTIrZCF8dte
    tQwhoNU+zszgTlPncqprVsvTwAgpjyPciGBDZXKQScTz4u1orAuTZg8Fi2VomZsbF2qQmF
    OdzRUWGH1aHPNSXFNkQ/9PAn+XNG9LuR9hRuKwh3bHLmpo8AjE5RNKZxmxAHfnSXBa+AwU
    NZVpbkZwjhB4n015qbMJHOsCvHvddJ8UVQ2fYa3VOWJxfK/oqZN2ML932kSF8d8J99W3x3
    o+SPkkDRD8K7lYB2uUqdFwVWHQX86G69MIrzYZbXCVpDUU7hRm63rOyGVst5i4y0M3mQ+2
    iMuCZB/JTKCqnPiPhC62N4N/GNt1VqqDJHecDFh9/INnRIgs6I5G7U23FS1xtjQDfC66Ok
    zmxZB47lUcPyXWWa+lpTOoZImAqY15f+xjqwc1ioj6I7dtteISjLxjlltKbA
X-ME-Proxy: <xmx:Z8N1atSerQ-RoMhSCpIise3LYL2dhJm7qi9XVHDtQTXhV1aFs0Hfig>
    <xmx:Z8N1au9q17t8_ZQrpidaKMqQ9LsnPvC5GjP7eL4lRTHxXSPe0dw24A>
    <xmx:Z8N1aqJTaFpfiPHFMIJurNqiofulDmxgI-Sgb_27LtuknVHzWODcFw>
    <xmx:Z8N1aitO2B6az2Du1LMjrhU-A4GFEnWAv1fLmxlBxiKvdOzwaS_LlA>
    <xmx:Z8N1anscwWp3KYOFwf7vuNHRF6vCNVd5_Gk916KGdKsAwy2D_nK-xbHf>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 07:37:10 -0400 (EDT)
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
Subject: [PATCH v2 08/17] selftests/mm: add khugepaged completion barrier helper
Date: Fri,  7 Aug 2026 12:36:38 +0100
Message-ID: <20260807113647.3744609-9-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5kqbt4uzdawxdc8cg9xb3sc66dep6cxu
X-Rspamd-Queue-Id: D91EF1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786102632-490463
X-HE-Meta: U2FsdGVkX184yLyrunVc0WvMTr0ytr6var+yRPw1odxGmWnP+HwVzJgOAbQaJBcx2+5rVKXcjhWx/hK7Vmh1+ZcXxVgf6w6boeuhhQA/HWn4XQ8CZ3VcxZubKrYgwA8/+yLxxdvTiZY55EX3B/WZ6dKuuLaSHqVI4z1l7oX33wM3NUbdBU8ZZRbVCnkUg7TeEHvEzW/q1k626yRmP7tHwe1p13NxOztKKABd7j/h1ZMiFx+uz7YSJCzzJ82+Cu7XlYzMlNXzMy8kWc6pGJf1H9EIewfXxpjwm/iZZGiHyC/9spFcOlpG+VrNYAkDntdAgOxW/On8D/ZyeUjSO78AM0aS9E7M8sBz6xyH1s5uAzXdIdV436l4/gfBwn2R6DbBWV+zsYCCFXBT5yEWXIMD7mJp5fe1WfQk2oZU9rPP3CXZmV1bFjEiVhOmh32sdAvikvZIyzlz4mWJQgKWJoR09k9kV9E4u0dL17ul5bD6wHO7LfS5dYGO3k7jmZhlk0HrrzQNAQH+Xab6R6WKsGjvOSRgkn9bIlg0Bhhq6fKbQTR23W/eXD9UPEOYf55iBXAshJcKbNaT8eHNZdebNw4/zkCws+Kr2qkVZmLajpOjvjyjtCWZcWp5slgigc0NkxMvFUqi5tZQRh7wGjDbVIohW3cUObQy87Yx+kSVTbVwjA6J6W31rn3dqbROWUvJGad3BD/LHicj5zlhAEvwzjSzkqyTR09VMCswnPqviuhVpcF6m9PYvSunV6IPDc2l46N+wkcqwqW1+q2EayGde9q7VHgU9uRlU+sFjv9K3tfp31uY7RH+mgqrMATOKfHJmA00zsmZrAu9pax6DGcn7IvwsyUugVzeTZtkUqC4BM1TEvkgpmjmBaXvYfKljwg6VpkC0KET1aPtwIV8T5KxelVr8uWU3k6IDlJl205Q0zDAWwAfUAXZqfloTdlV8Jz5spQFMN/i4Fz7rOQZ7oXjQsF
 nWCzwd1a
 sokjL7t0aAFFELvagooGNMa4nKKgkuYFos9E81YDBKO7XNGYLAEyORZ/4vUhdGeb7pS/BfsyVIXrIaVB1pGtyRhOoXjpwb8o8pf7cQ7PRusQiIPKpASVmK0iQ039wSWiU+oSd/oiWjsAY8P4It8wQkj69/xxVXmkiUmWf/mKnh7tkHxItJeC96PN5ctGS9FbyEJ/TKkVRISuSV06B+CC5DJsjcJBBv6CssFCcBx3GlWPWE1jm9QNWp1XU+hg3sdlmhFkrICFqJ+BrU/NVYIZd4+PPSoS2uZcun571vX3+QIW3WWN3HjEzJvkkWR/j8wOuFgpde1+nuq5x+wQxQicf2GPcqL8yRvl8+sxM2MS2UdC3CZ3X7ms5Ovt2xa0jDVOX0Ju0oR6rtSk8LCbITSkEGM3mSq0RKvDGF0xxvy7mxyIuhhNIx/xozImONxH8QB44kbk8wp4p2RRO/9I=
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
to scan_sleep_millisecs wakes the daemon, so the barrier completes
whatever the scan cadence.  It wakes once per missing pass -- over-waking
queues a straggler pass that overlaps what the caller sets up next.  One
wake completes one pass only if the whole mm list fits in a scan batch, so
callers need a large pages_to_scan.

Settings pushes must not start passes either, so thp_write_settings() now
writes a khugepaged knob only when its value changes.  That helper,
thp_update_num(), is exported for tests wanting the same restraint.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 .../testing/selftests/mm/hugepage_settings.c  | 72 ++++++++++++++++---
 .../testing/selftests/mm/hugepage_settings.h  |  3 +
 2 files changed, 66 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index d7917dce3aba..8afcdf9793bb 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -183,6 +183,17 @@ void thp_read_settings(struct thp_settings *settings)
 	}
 }
 
+/*
+ * Write only on change: any store to a khugepaged sysfs knob wakes the
+ * daemon, and settings pushes/pops must not start scan passes nobody
+ * asked for -- khugepaged_full_pass() is the only sanctioned wake.
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
@@ -198,15 +209,15 @@ void thp_write_settings(struct thp_settings *settings)
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
@@ -230,6 +241,49 @@ void thp_write_settings(struct thp_settings *settings)
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


