Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A637CC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C996B00B6; Fri, 18 Sep 2026 20:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0750A6B00B7; Fri, 18 Sep 2026 20:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD3E6B00B8; Fri, 18 Sep 2026 20:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFB8E6B00B6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 05EDE140143
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:21 +0000 (UTC)
X-FDA: 85228617642.05.19A8D8D
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf04.hostedemail.com (Postfix) with ESMTP id 25F6440003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y yYYiDI";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=OG3pXCew;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777518;
	b=4k7FOIzmw4/qJdvZj77hgVpQniTeQ0ZYhu5uWizwB5vW0fUQsM1ZaJjbGlzqf/XVkRf6pS
	62eDTErUIm1h6FiANH1OI/A1ViGQzQOAKIVmOeYRu97IkeCvy1XG6hjGDxggjUa1tGZxnK
	+sjoIi9OXznYt0MLyd0B3wyld0ap95A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y yYYiDI";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=OG3pXCew;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OrQSW9PySTD5pqcXZKw4HeeHztfLYLHLZ88GO+dc7EA=;
	b=krpUWbE7BGkTyOJMbTfuG5Lq3xTJtnccpNKta3zSlhw8c3wU2gIO2plz/7ebyU0lxQQo6X
	3zdDFL8TAxJ35PbmElWDcOVUaJ90MvtFc3P6kDtU0N06nMURtf5fFPKFyy07jjsW8F+uxr
	8orKNlJRXUQWQ8LeoR7AwsfMZOtrk3s=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id B0774EC020B;
	Fri, 18 Sep 2026 20:25:17 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 18 Sep 2026 20:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777517; x=
	1789863917; bh=OrQSW9PySTD5pqcXZKw4HeeHztfLYLHLZ88GO+dc7EA=; b=Y
	yYYiDI3Q5HTbw/tbAfd8rDW/2Kzi8T4+aoFUJbTMd88hjoSGBOKD7sbiEyvJ8Jpb
	m/l8Ly2mhl2+c/lhnEkzKc5QOBwKryezfTZfZBPbGcLQbDqGWu6naXJ+9ao/PsD7
	8Joaxcb4r1SMQxlxpsD9vo3EzRcWKOV+VJKav7kAcwG/OnpKLF0yFf3FSsqcsNLo
	It5ppUBxc6Xbyt1ZZCw1OpQjsyoeQYC/fTWNzJ9yjTTRmxPLgbJnWRmK+phXu+8j
	wrFTa4rULui9mCUr6pXIFi/UDEhXQL66+8IIEiz3PRbUEXhbyBSedz89j3MreGdq
	fz6MNO+yZuiUHRWJ+u/MQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777517; x=1789863917; bh=O
	rQSW9PySTD5pqcXZKw4HeeHztfLYLHLZ88GO+dc7EA=; b=OG3pXCewdhljr8JHr
	YlH6l8CooCxcfLobrHKScUPuGADBAA718f+YWA56zlFjCNaw/IcUL5wrAqHDXwu0
	ABGXQlqANJGVE9Cvoak5T4ABiD+Xqymx/Vv5tN5PSNbUlDRf8r4v5J91mrtI1JLt
	KbZbOFMiC29sxwWuylGJ8y7rVKcjSmLb5pIYJx8fW0zcSACEQm64bCwuWR0tHhmQ
	qKAfgQS/3UULY/yDbwp62jIEA4zJs3oaCwewsSK4EpKFAQ5TKHraHeGU8yUoBuaM
	gM6Y65XkbjxQYpMnLO2R/kgy2DegAja/mP1tkNGaPmYBWbQhUJRZe59X/LEDKmyc
	0FidQ==
X-ME-Sender: <xms:bdatalhvenWA70PwFZvHMU1RAqFBldRm68eHr0OlLQcEw38iHVTwoQ>
    <xme:bdataiYRj2SG8NxJkYMugMlsmq3g6V5N2h_aruXSymhNnoRS3RfBzxOWQk6_fPFFP
    zKClXB5kos-kt35i5zWrNJQDQm6x0n5snI0AulSfjrgbgJLysEKtg>
X-ME-Received: <xmr:bdatanTJHkjJmj79Vj84lX8xzzu4iUkrmSCsYfZrP7_9wrOmxQe0iN8KvdI>
X-ME-Proxy-Cause: dmFkZTEzseHgHAxanvosBbYuJPOsY+n0X5UbYs0PPazNY//kQZ3NkUWvwvZaeFG4K6MaM1
    51QpOH4aelOmHBptEhruNIkMmEsuOQeZbGrvL7mQj2kdmmCNYrJ7V/Gxu8ar4BzJpo5rV7
    vKP2ia7U0+Vm59vAPsz2JcwivFHP+0OmSoqV+JfA3yKlcOkTPrhdGkX4AgOHLm4XJUt5mM
    HeqMESXl6ibr/xrgjBd4IZM9oAbU6DWk9Q3+fqdUek4rHv8tNSmXbmq+2iLXuPMZjgN42W
    gGRNasGU39A5UL6wnmEy31YC46agADHTZYQX6KPmc3+B0CXfmIhRtSns1d+buSvmpYlDYa
    Ea8F6iMJgeQKGBr6iJ6jS5t/l5kFUJnfWycrqY24cckliWVai2FLR26JRYV4iw4sX32X2i
    EfEzbad5eybuXifwnMO7/nyVEQbt6L9OQsQxevONb3UmKp3N0K6snWnX7lTO2MJ66Mbb0b
    slMcJIV8yM6ej+537hiz0S4+IctIiyGVy6byPF1QrbNmJisJ2MPp6v9lpvP0vwF3Q7FXRI
    Z2sJIQMS6uXkTcnCkwcV8MQ0b3yHsVQ9xH51hEsMbxMwVPHHjfkyMMnQxNsc8pzBomEkfY
    5HGoXJzje8BjlIPd8fmeLOd/xchC2spbg+r8krgCEAGrEh22jNHSVdd32VTg
X-ME-Proxy: <xmx:bdataiEwaJ47wcwh-YVjQIIohd0eGIO2393yP8NSoMEp6bmdi-_aEw>
    <xmx:bdatak2N11NAf8qa1VgNyPIm8u1l83pwwH5ZkWYpPqas9TapygJSLQ>
    <xmx:bdatagu3xaiW43j9LgjsqpWOehBdpx48jJypEvW_ILpyvkh9dbWsAg>
    <xmx:bdatarl7uGrtTS6lWpBNlssEjZvl_5WX35ZTXKMCex3NeD39og3gtA>
    <xmx:bdatatLf-mGqw6-soCAKOMm-FKpomYwM1onQoUXWOXRc0GIHQolGeA90>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:25:17 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 10/19] selftests/mm: add khugepaged completion barrier helper
Date: Sat, 19 Sep 2026 01:24:40 +0100
Message-ID: <20260919002451.496763-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25F6440003
X-Stat-Signature: jkukywec1ygbxxnam9ho3n1uuujkpbte
X-HE-Tag: 1789777517-80837
X-HE-Meta: U2FsdGVkX1+XuxlimHhITZ34SFPcmQubQMRCCy0fcKpvs2c3qrWZReupVaWvy3LBRtnMRcc6PA2C6w0WN8DYVbqLFzShH1CTRoxM/swG1tTOuw9kxGIj55GxIc7DC57MVEwK0SnOBJyl1j2Fs4SvETpF04EfFdvuCvLaL9z61a902VmZ+n2THYJHZ/EBry49G/2OiUr09BZivHXtBduBQ82A9JjOMabDvyY9JFCHKGui0KTydP/zydHARcMGccOwBknS4DQz5b0ygZBXB9lM3EDS9r2CrZXZj8XeCsf7pKK7QZqm8NQ4Wqiyjnv6jlkIos7ps4STjSj9yCmuhl4WekLvWaUn3E1c5Fi+dj57VfxDjQ6+5CSUFH6vOG+5gRg6v+0Y8iEq5Tskit0DQESra9pU3FqDaDvIn1f3FgqebX0cYwpcnxCx8GZ5IJgZi2V6CxqITCdAbgyIvq/OJinN38LmY1CHoP20l3YWLLqXyW17Uk/l5TJmag+IMccrYpSsv3BO4SJWQgi+zBirNQde8OoRHI6Fkv8Q1YscQsG+FYDByPWsv13jnxKHhaqu1e5Jj41XwyQcQL/4U3EWHBmvDbYSXsZj8gT/L44u7hvTWT5t4F+kcMjSxzUvDgmFyHDoz45Jm1UK3WKR43UDDIXYxCamCrcfzACHMw61gRRP7yGIPSjn0fmk2YATUYxoiUVVm95o2GnUQIFqfdfzJUZlS9EZs9Z0tpUqMJvUqkIOxpS8pT6nyMBV8hSmBSKE87JeYDhlcTyQDjix+cb7+1bDxlrA/dkStoKLMy+NSjhq2o6/vIPD1J/gwOqXq5Lr99yYVvy4RaXK6G81SQMT1KM7SitDuio168h1/5XoITKrEcLsp6TW6FC3rExroYAPeCtC37zMkBDtI24C9vlbDZddSNOVuIkvL1HLpR/pUs4bAf65KvUdbZp7XQl1fO/3hGGXgQhVEv4vZPzPeuCV4N6
 9mSnskxs
 JBK6IFkXaHAqaqTepv1lS2zf7nAntrounLyrYvl6QUm4RzQutRjzyplMugjdb9jpytepTBeNWKWRzSbkfJEBmq10PPcvfNLowBa9ms6RhhxLYTUGR7uvSHsqsEnpxIIqLbL+/qkurLdgZWg7rzyVKqsbbn3jLGPr4tGCaSoJA8k7wi489hTn515sMvQb8WzZVTMJ38L3ldk+4Be88WOqlCef2MlOmkB1DU0Dix9cK1jRX1NrA5muxvpXolBc+tBctpxtTlOuxZ6EDuI8Sohgyzy4+bHnNrvGJ2ACzK66p/yPjtVjKzE6BPzM5TfofZklSGzg+p56HqKpdFk9HTrc4UsPh1SotZwd07Oj2ekztJh0Nl1bow6xJBVcgQJn/E9+j44MvLyDdkPfr7NfRJLtcU6VYwsFIWLqbf8YYhO12bELuC6kt1EC9cNHGo0JwKvLoWlNWZbZP5NRbCgJONhsniAvH5vSyy5DV7suoo5LIyyj4h4r6tIi4OWMLM2zeDyAwPEd66LKtDY+VXyucm7K3SH63mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A khugepaged test has to tell "not collapsed" from "not scanned yet", and
nothing in the selftests can.  wait_for_scan() in khugepaged.c comes
closest: it polls full_scans until the counter has advanced by two, since
the pass in progress may already have passed the test's mm.  But it only
returns in time if scan_sleep_millisecs happens to be short, and it is
private to that one test.

Add khugepaged_full_pass() to hugepage_settings, built on the same
advance-by-two wait but driven through sysfs: a store to
scan_sleep_millisecs wakes the daemon, so the barrier completes whatever
the scan cadence.  A store made while the daemon is scanning rather than
sleeping is lost, so the helper keeps storing until the pass lands.

One wake completes one pass only if pages_to_scan covers every mm on the
list, so callers need it large.

Settings pushes must not start passes of their own.  A store to either
sleep knob wakes the daemon, so thp_write_settings() now writes a
khugepaged knob only when its value changes.

Assisted-by: LLM
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/lib/mm/hugepage_settings.c | 60 +++++++++++++++++++++++++++-----
 tools/lib/mm/hugepage_settings.h |  2 ++
 2 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/tools/lib/mm/hugepage_settings.c b/tools/lib/mm/hugepage_settings.c
index 656442c8d395..77918677a9cd 100644
--- a/tools/lib/mm/hugepage_settings.c
+++ b/tools/lib/mm/hugepage_settings.c
@@ -217,6 +217,13 @@ void thp_read_settings(struct thp_settings *settings)
 	}
 }
 
+/* A store to either sleep knob wakes khugepaged, so write only on change */
+static void thp_update_num(const char *name, unsigned long num)
+{
+	if (thp_read_num(name) != num)
+		thp_write_num(name, num);
+}
+
 void thp_write_settings(struct thp_settings *settings)
 {
 	struct khugepaged_settings *khugepaged = &settings->khugepaged;
@@ -232,15 +239,15 @@ void thp_write_settings(struct thp_settings *settings)
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
 
 	if (dev_queue_read_ahead_path[0]) {
 		int ret = write_num(dev_queue_read_ahead_path,
@@ -271,6 +278,41 @@ void thp_write_settings(struct thp_settings *settings)
 	}
 }
 
+/*
+ * Wait for a full khugepaged scan pass that started after this call: the
+ * pass in progress may already have passed this mm, so full_scans has to
+ * advance twice.
+ *
+ * A store to scan_sleep_millisecs wakes the daemon, but one made while it
+ * is scanning rather than sleeping is lost, so keep storing until the pass
+ * lands.
+ *
+ * One wake is one pass only if pages_to_scan covers every mm on the list.
+ */
+bool khugepaged_full_pass(unsigned int timeout_s)
+{
+	unsigned long deadline_ms = timeout_s * 1000UL;
+	unsigned long elapsed_ms = 0, poll_ms = 10;
+	unsigned long sleep_ms;
+	int pass;
+
+	sleep_ms = thp_read_num("khugepaged/scan_sleep_millisecs");
+	for (pass = 0; pass < 2; pass++) {
+		unsigned long target =
+			thp_read_num("khugepaged/full_scans") + 1;
+
+		while (thp_read_num("khugepaged/full_scans") < target) {
+			if (elapsed_ms >= deadline_ms)
+				return false;
+			thp_write_num("khugepaged/scan_sleep_millisecs",
+				      sleep_ms);
+			usleep(poll_ms * 1000);
+			elapsed_ms += poll_ms;
+		}
+	}
+	return true;
+}
+
 struct thp_settings *thp_current_settings(void)
 {
 	if (!settings_index) {
diff --git a/tools/lib/mm/hugepage_settings.h b/tools/lib/mm/hugepage_settings.h
index 94d9fc747f49..8f4581099b7a 100644
--- a/tools/lib/mm/hugepage_settings.h
+++ b/tools/lib/mm/hugepage_settings.h
@@ -83,6 +83,8 @@ static inline void thp_save_settings(void)
 	hugepage_save_settings(/* thp = */ true, /* hugetlb = */ false);
 }
 
+bool khugepaged_full_pass(unsigned int timeout_s);
+
 void thp_set_read_ahead_path(char *path);
 unsigned long thp_supported_orders(void);
 unsigned long thp_shmem_supported_orders(void);
-- 
2.54.0


