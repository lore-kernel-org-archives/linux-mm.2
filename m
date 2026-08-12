Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFC83C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 349CA6B0119; Wed, 12 Aug 2026 09:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321806B0140; Wed, 12 Aug 2026 09:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237A36B0141; Wed, 12 Aug 2026 09:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6E4E6B0119
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7BD66C037F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:35 +0000 (UTC)
X-FDA: 85092684390.10.20F6B8E
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf26.hostedemail.com (Postfix) with ESMTP id 81974140010
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="d +bIRM8";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=kvo68HBQ;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vEcbFcHSc0RIpAv6Xeg8b8khiwkn4nugTeMN0M/IuN0=;
	b=eSCEWvtAju9QBMn7RFXlGw0HHx3XeqH6hRvsrESgv5kitx8hPf5rgiMCoIdU3Tjy9kqL3E
	wjQOSg3SWpejbX1InOh5s1b+zUdx+YPoVnZXUWKkMYYIHApWQ+BK35JA+3b2Gi0x/zVbH1
	dUKHa/jPtNRMjP3yXuZLcCFV/hKY2gM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="d +bIRM8";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=kvo68HBQ;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541013;
	b=pcCFu7hR0YIdkNJNbF0RX8FmYZUZfm7HJfapzGarn1EGgKJ/QjMZmxoOY1zS12dMhpt1IH
	tEH3ikOGggHfkP/J7Ggg0FzdqjzLVnvWrKpetc1XfPAaQVBrPXdWzu2zjKwYCMB+Y1zJZJ
	Q2I0tP1JvDy7Rv8F4S1MFgMMeCBqIZY=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 586F17A00D8;
	Wed, 12 Aug 2026 09:23:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 12 Aug 2026 09:23:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786541012; x=
	1786627412; bh=vEcbFcHSc0RIpAv6Xeg8b8khiwkn4nugTeMN0M/IuN0=; b=d
	+bIRM8DtQgQ5NhEwnn9zLY5xsSRcpLiMaKCWyYH4Sl09LYB1asLwLL0ed7bTbwfB
	EHXtzvhrVVnLaabR7/z043cxfbXCE+mVZlZktcVCq0kstHW6fCmJqflBE9hzjTI8
	C46BPRFOgu2oSav7g5jJZ8NIhDZFnViC6gK/r5XGl5dDXuMkAKih0eeAtlMFapl5
	2BjErd8yBqKa38WIOIS0rnQZ3abtkxcsAukhYkhktQML+uTMwQpcVNWtIJOqygxz
	VO7eKH3FfqjKbIyBxQcrIeioHfg556xw3XDR7f5SE71+i2L/j4FsvoY94mBAawj6
	iRl+7GZJVEfKMOCsSUzvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786541012; x=1786627412; bh=v
	EcbFcHSc0RIpAv6Xeg8b8khiwkn4nugTeMN0M/IuN0=; b=kvo68HBQXjgCRBQN7
	6heYYkKOcONSCUBx4Ut0vP3ILxs21c5dRodLxl7kck4B02RT98jHxUUdml5AxheJ
	zbWoCX6u0BHb0qeOiphpPDASK3qoIVJ2S5rkALrM2akvRKH4EovQYtN9YERxs1/3
	iCXzFJeB7+oLEeDIgfl8hxm+9kVf6/Rw1XghYE4Tm45HneIsGtZqD5MAgwHKw9Wt
	4bFncveQ27pfCoTx3/43QEC5HZVWQdnvaG1PLbK9TLHB4oqRuz2Ra9fEnF2IL93E
	BcuO6/Ywx4NOFW6CHn0zTa2o1Hy4mvakkygR9nkEF0WyPOg0Ky6/UL7rGMttBE7j
	bN7Iw==
X-ME-Sender: <xms:1HN8av71aGlnR-4k3L145mVFhwav0CHioolNqOeGkRbeSDAwc3cTow>
    <xme:1HN8ao04BQcgBX6q8jpyaLsu_BWUg2BrNeE8VDRISld39960DMXpMwO0ZSvBTyCAO
    Xtv8NTx695c3YVPCzGsJ9ESXkr2OSQzPYbgyKsv5Mtipee5OOngnXkJ>
X-ME-Received: <xmr:1HN8au8BwV6jQEGL0bgghThNvswvHV5bBsoxT26ar8H1hgsAkE_f6Q3G7Dw>
X-ME-Proxy-Cause: dmFkZTGK88F9UMnXZ5YHCfZ+3CEyhDPNn2cwpG7gczg1QtUW3+KH6lRiOTrWgwtmC8SwM8
    lS9N2AAOkbX57R9oIGEGX/Y22a2ZgCAGYteUW+bA41LZ08JSUTSnxLP4aLeGJ+l2igRpiI
    z056Op0LI1NxVlka48nXFKSS8a/uwNZK+39708VFH13YHS1sNHrX5zvuU5299hb11Ao5H/
    zQrZEfdZM4G7c0rNyXZ30syjB6Y8P8LTAhLTAHwdc8i3T8CZWzvPOusg5fBb0jumhRSeE4
    e5clat+a+U2DXBe0wlr1aBcOwBQzkKo/UFV6TzMBSg5j9cF+ay7ufreZHSHrXPVD1XvoqN
    nGajMc9LFlqtqdyNBq16ebJCwpL9n0hNsyrSX0E74XPEhuZsPSQdOcHhjksiUT7jfzCQN5
    iBSxH59wM/CgQqAHSwNJhfxAEsTymBgLjfOffondkWrzKSe/7P1mH45ya+i7fOvTeG2e3e
    fEy3DOAGUCoQH+fXGrmdf9ulLu/vDnqrnyQ5qo2cAEtLiHOdRb7M+36TZHrFYXvfiHPGsS
    k7XZ/bEBQVWi5ABJ/mqzgHtU3UbMZj7i4qYjKCY5tyD55E+dJJMBuh32mh6PN016C75DzM
    RIVwsXzmayy2BQdFdA4CL2hgOMrG2qzf+dNZzV8Y98BEZ36/pwhrKN0i9c1Q
X-ME-Proxy: <xmx:1HN8apudGjw9y5B9yiy7BZ6UexIDIbDjPpdW2GPGYxf92xlLIXzIyw>
    <xmx:1HN8aqqvmgQ4qLZnN9QRxmIC-c_uDHaRSPxXOwlfCd3Ow1EjZx5wlg>
    <xmx:1HN8akGZsEsQ7syxbghqarnLmqnsT3iGepACvf7YE6fo2i5ctKdeGw>
    <xmx:1HN8at7MvtkJZ-wUow3sus-F1CcdDM7HTvWO0dcN9kTDMx0MAF0Ylg>
    <xmx:1HN8ap8UzARxZXCmW6A-9z9oq-Dl15Pc6E8TODhU-XghdYtR8HneKDe8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:31 -0400 (EDT)
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
Subject: [PATCH v3 09/18] selftests/mm: add khugepaged completion barrier helper
Date: Wed, 12 Aug 2026 14:22:55 +0100
Message-ID: <20260812132304.199287-10-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hfpaotnf5fbadmxzs1w7ft564tjm84jj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 81974140010
X-HE-Tag: 1786541013-234704
X-HE-Meta: U2FsdGVkX192tgoL28bR3ANA7Edu0wA3XqDzSteua3BkTUjDKdAM5MmaNJeeNlb7Mh0zlWbY+6zpTJf9kETT7eUmGBBaOEzD80D4El/tn3UqgUSYXmNb5w8nL93SLIQuW4e82JHkoFI9IK7uALpNJRS0B8Z9uc2+ye+rWaWmgBNQLXbYjWI+oTESQKfeSs5rJRE7gcIKqRa9AQUsfKbP3NhBRiZKOHt6vEA+2r8ip5QL7Xtr9JctkUMfb6SlR8t7sXxPP0/YgQN/ISLqLmaJiVMueV78a6owr7MwMZ9Dl0Ub3tmJt0LtsXIFD+ZaSd2SvwVViIH9tFCtxIp5UF8E8PdX3kek1xiJVsh3rR2wUSa5/EOFXq4YrYST+5Q8+Lv5bxhoz39gu25DD4xNO5p+zJgaK92WCmoHPXbfpnnVdewzQCUqfrl3WRsP7lUpMfirBNU6Hex/QEZqafISPOKS5VNgbrED+vbP+3MypDWMUwmBQ3fW6MEwu1Vq3UqYeq+h1PuoNjdyoelkWRZrhcc41RpQwdV/iA6KEHV+reKNmExcxdDA0sPphNa56AAKZkApW9s1u8e3yG+Ox9RFbiVQjm8YaUlnef5y2hOLz3IQGsH+pOqWZ5CURiaC/x4zUypjD3IbPDe9wuvJWN2fB3r2OV3bQjY/NfrETxCbUSiHQbNDijx1z2NVlIuQvGQ6KfWvle1zprCe77qSLKXiMIusXTTKrVcs4ESAmiVa7fH0r79aJx6xSWbLKEC/IGx5mpxY9nGtsMlbqsWKEKKdBRTI1vQjmaVGdBDRDfrkWB71YnrssCuf4iT9qiWHWwdPBQKwN1e4h6eGE4qEPLsSwia6QdsqhYPJ5f+jKcr/DCw11niJZ454V8PTV5bEW7DkBLSCmjToMJpttLroJItz75yRQHZio89dqmhXDnSLgFe6UjFOP1Mtpx4DwbIQ5m97oOGtKl+v0c09LPMbTofLYtp
 wPWldlM5
 ZEiWuIUKdUG6UYhdMoQZNNSSo142REwQ23cCYgHa5XbuIQLXIgS+gSnu7rbi6xf1wGxpn3GFvJnmYgEZ3NF0w9+DUyl9oW+or/uJaxFQrZSnwfDcl2Z4mMR7eJi3DkW/rr+4wemmuZGf92Shz9B4LS3sME+NrnaxHwDT9j58tc5HzPmLren8I/q/dsr0SZ0/21a6tsRW8D0rW1Zn8luGPQWQwk2oeteGS/Kviu9aeTJlv6SefyQBcp7PDTXvJ3SdT49sUmqk2OV/FnH9TbuMcTS8vdMW/v/FIuACFJegCehqfi+ahkCcwLuRBNw9d1ZdJx/S709/FeQ/MScT93RLJsA0jNr04Amvn4F0+QD/R988NoWdZX+BK9hX0ri/uXMM8SQC+MBuLfg4feeNAhOOmRWONmSmTP/BCZXqCKTI0I+sRPSd6G7G9jzYmjl0BjuI7CKolh+dE1CmmvDtH+i+HS7D2t/K6iuKrJl9MRRNymMqZs3YXXINcd+sJeNAqrPnadDOD
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
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
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


