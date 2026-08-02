Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB244C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 19:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 115256B0095; Sun,  2 Aug 2026 15:53:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09F826B0096; Sun,  2 Aug 2026 15:53:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF74D6B0098; Sun,  2 Aug 2026 15:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FC926B0095
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:53:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 417AC1A0568
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:12 +0000 (UTC)
X-FDA: 85057378224.20.C220FB0
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4F686140003
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=PKtD8dK9;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="I S99VJz";
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785700390;
	b=IxUPXbz24kAdBSxnIgXL7Jx4rLxF+ahgyEy+20SJqsWOVE9oIf0KADNsEj6gd/OtHR9VpF
	AMu/hg9aoHZQ4uIV7rM3j2HrrHRPMzXlLjFhQbAqOAgWzSy7vaxYFr6h5XTmnl6IEKkUgm
	unjCdw7NcFGjjQ6BoYBMMEAfdTZQkyo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=PKtD8dK9;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="I S99VJz";
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785700390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dYi27N+i5b6bGNiVCS2C3c2A+E2bw4kDWwDej24J7I=;
	b=Id3Pk/ZPiyBTlY2J0uLbHm6c5H5GEpwIsOI9ANN/X4nTPSu8j8TaVTCPBWqTZkTwImhaUF
	pXJy5RtmvKSSi59WnBOCnK7mV6s7qwSBvUnBToO7YYy0bXyZkpaAMrgwBRD/H8dxtKQZSP
	2gjZ93WeV2Nv46ngomEuAdGh3ohyKNI=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D5D3B1400051;
	Sun,  2 Aug 2026 15:53:09 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Sun, 02 Aug 2026 15:53:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm1;
	 t=1785700389; x=1785786789; bh=0dYi27N+i5b6bGNiVCS2C3c2A+E2bw4k
	DWwDej24J7I=; b=PKtD8dK9m3RfY4oEkfEZhEjqQ8c8lFutW7eHyajN+koyWJgf
	RIQ5gZNn2B6jEyS7AHX1P8zJkHK5Wr2hLGeeL+z0pvZgUNSNwkEIItH7P0+o1NlZ
	I8AWCmjdNX330Yf9mKESvPtGbkdpCptbf0mTKtV1SKJXy/hFcgvufI/B9Z3+m8wC
	WtWxrCvo45MNNUQgGls0CR01xNWEkv2WIAegm4aH2/XKI+l1kP5GFrkB7QBkyaVE
	uKw8n8HKwbyJkmhIIwVR1j9kkXHPiOSpMM8aCIIWjGQyzwd7v1hPEKTHpzfUd29G
	ODhBgTBnoY5llR5+yz78vIM3DyoRO7Cog3oeUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1785700389; x=
	1785786789; bh=0dYi27N+i5b6bGNiVCS2C3c2A+E2bw4kDWwDej24J7I=; b=I
	S99VJziokR+RVM5fsh159gi0ByR5jhH0TVn0rqe6K/sCBqzJjkziFTbYghxnSUSt
	4Bj0wpQ+/O6UvtXO5ScBTgDjJkZlRLQSceYOfaRzFhBW9ANRImdVnLXBn/GsrMok
	FhXxwlGDKZIgBhSdc1eqCgZUpxZOEXJdmqZx89u/sxBmUJ9B9DIP7bms6ByV38DB
	nntFiMtD7BC2dmJGRIAsq5pRu2UB/CxjVpyh9vSKqQ2UYRLOlB0bdLMQn+KUVzGm
	TAOLwY5cQQ9SUGHxbzptZL0q6ObJZFDeB1/dtvywatxDnc0sc/6SyZQT3TCxfeUP
	s/EAb2tfl4FdV+VjT8H8w==
X-ME-Sender: <xms:JaBvaoSenmzrlzXgxQA0OjdUnHrV9Tl9DR6XoIFIJGadSyiZQ5YBWA>
    <xme:JaBvagS-Xwb-E8C89xPBwHYGrOVNQ39Af38zE1mjnW-eMvjlcwX6xNfs9CFh3r1hA
    eO0EY3ytb_QehNJD2fzJ7YzkzodECot8gF052W4U8054k-6LFBZvHM>
X-ME-Received: <xmr:JaBvaiwdUaXQ6OBvbVmrd2n-op4NRGPSc9AtfrbtzdR86phXrTQAd-SKatI>
X-ME-Proxy-Cause: dmFkZTF0jcSSKFGDg2KrIu5c43P4SsiipwcvDQBe+CHxos2n8PFgvSXAdv5YVW583HVAOz
    W5evq6qe09LpHqloXNM1K7VWF721j2bpam5IryqVMcYz9qouNwbpBEKv3Y5gifbeJAqW/Q
    YZQrbB51yLEk86mWZaGZ1Drq0Xy949i11wvFP7mkSWE3f4+XiyFqs+bTi+V6AVpUjNMMFr
    yeY2fCKzWlrX4GavSe/JRyGqxABGArlOuRBA0IP4mMA1yNK8fSDYGTdjzDrtr8AjwNqVIi
    3BcHDiClTVSc/WD5f6J8XCsMYF+6dE+0Mr4gWnl6eMmh6FUU5GqCPEjsceh07AxGuRDdpm
    WM7Nc126E2mM/l6GiCehRFrkXzZFYZ4Ebb4FMbkX8kiMzGgzhz3DJpPl8z7yQZt2FsjMNw
    HZCGUFJ4vSj7vlngG9YRDlHJ+iO3T90jqZJ1YvC6bLwgYS7ApCXjzbhsjXb3AKnxIVwMTc
    VTa9+dsRanC053hSC/KEkGVMv+bZq+4RAGgSslAcMCCgZbfrx8Eb1xaE3qi4LjlljmSd0Y
    3P2U+IEdMkzLs4n6ZYhjvbIvhLXKy3hrGxmvbBm4owHGFA6PiRWfI/gU9KKTY+jYK2AuOg
    AXjDt694f8YIpUefYRDa+UP1Mm7hyQQobzGZgwbPH/0juoEglBtB3Lj0X/Mg
X-ME-Proxy: <xmx:JaBvauu6u2vHxvNv6WzJFV_Kb6Dv3d0YCnIiXsA6UjjPr2M5k85UAA>
    <xmx:JaBvapz7P3ipfF4qOhemKBSpGH6gTOfHcBmw8BR2kHISYj1xMLjrjw>
    <xmx:JaBvamegVAGYMl4jfn4NrxebmlB4PJVwokumgoBR-GyD0-p4ppMcZg>
    <xmx:JaBvan1O0MELVXdNbjxSHqMn6h2HSfJkXmLOkW9gnA6JwtGKfGZLmQ>
    <xmx:JaBvajZb7ZOLlaIFY9NSdkVWU7P-V47zsbOJi8atVxSccUKh7tpiyHgP>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 15:53:09 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Nico Pache <nico.pache@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 05/16] selftests/mm: add khugepaged completion barrier helper
Date: Sun,  2 Aug 2026 20:52:37 +0100
Message-ID: <20260802195254.1937477-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802195254.1937477-1-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4F686140003
X-Stat-Signature: 439nnnggmxuic6zas6w3hj6im7hj6et9
X-Rspam-User: 
X-HE-Tag: 1785700390-212691
X-HE-Meta: U2FsdGVkX1/edCAhd+vxi9ozX4gWWkZfhw9uXf8A7zdImuZVGC+QP478NfhoO59Vcey/tMDpCbydbofo0usRaDtphe//T0Jy1svwgxHCqmhz5qDkT8zSPn9vLX6EuYc3Y/mwiVb6CBwugw5IEtlP4dlzinFVA8EEXiCTt9d6Dzj74/861Llbe+48topuuX0GwdjWQonDExrvBuMw0FPbBV2vP8TFt/jdO8AaHdI0EE3U0/eq18M4b0LSSMK4SuiCmsl4C6Bym2vAANPa3lZUytGwp9JzRYMtVCp38J73jrVI9CQ3YaNGx4lZV+wx9Ka6C2Be5nCROQJg+sGDadIvfpWWYmNvHZcsmYGXrLYwKHfukUTtzpazEhviVRdsUifsjnX0EOYuD3IOvg3D3KZ7Er82Imogvp2vyCAihJp5ZpE0pjWERiEQXi4D1YkMVtgKIjnP0fp2CVAVjQUstq5j7IacaVOp2POIDUKqkzomvZ2L9jrrkfXtl3Cce9hsC8RHX9lH6XfgTzBsK1NlE+vQVGpmtii9tID1unCeXVtkJwjWgtPD06hF22bniuU0d5nnMqmpxErQQ/jj6Z/dQmVs99vc6Tc2p5Wf+i6DSj3cBAYy59x8xGlwRPetAuJnFQovX1uKH45Qf0nrysSUNk+gwYBGczw+yZ/Xwojpst3SSC33Plny1bqr239y+2jkZtRJPIrhuisoZ0wFWEhIaoUp2Zzge6UcdS7grcJew0Tf63fNdelDCK5FyCb6AniKJ42UcwWSFkgorhlB0SpsFq6n4EAseBYGb0baurckX/DWbkjd4WgmyY54ZI4AUQt0rQi8lleMW+0hUUFZlDUm8GzFCapiLkl9Mwyh+UoINsi0LsOMQUvPI+939+lCJx1WUQ1/OvT7HUx9oAqkItkUF25tWgnaCJIsGKVRTil18NQ0Ae09JuOoTX+1HkByFHWEcYFivieUMWGnSp9R0ueQmD2
 B1hs29ff
 olh4iQdGudfS3Qn5XGL1n0CmV59KpGVMrwJHjKRIYj61bFatv27yE1viaA8OQbmvJEQCuwsC4D48wEKXnUPlUMoA+CYx1l9Mz2/dbBCrS1es7OROXO5ztkmLBqXuIFJhSAYCJmHSem6fIs9ysvUPbOyhYK/KL4wUq88AsUeTSA//8NXMtqB7Bz+O6jGH6dUcJXSlfnSiqk+iuA8sJ6TiNMvh0tHHiF5lqZzI+KuCxqZN1UJwMgvVMGpkciPZ9hbRX7C0OeiJjHbi8qnRheWV/wv5CMYz59Du1033vb7KNjXGdW0x1GoDJKFvkMfe36uDcOq3IBRTGCiDRvgi4cOHrT1AwIkrNmtzdd87qeTrJZjCjYHyt/fDpgk6o/c41d7mct9lWAUW7W6OJsxWW2J9E1HFxXQsQSgd5GgDqQ7UNzmOaxLUM6uAU/umuUW/4ad5XM9i9+xuwKxLhoumz5Dw4pT+Hv1dgmddpv/iIeYJJXt3Dnr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Race and functional tests need to drive khugepaged synchronously: set
up a layout, let exactly one full scan pass over it, check the result.
The khugepaged selftest already waits on full_scans advancing by two —
a completion barrier for one pass that started after setup — but it
relies on a short configured scan_sleep_millisecs to make progress.

Lift the pattern into a library helper, khugepaged_full_pass(), and
drive it by the sysfs wake path: any store to scan_sleep_millisecs
wakes the daemon, so the barrier completes promptly regardless of the
configured scan cadence. Wake exactly once per missing pass:
over-waking would queue a straggler pass behind the barrier that
overlaps and perturbs whatever the caller sets up next. One wake
completes one full pass only when the whole mm list fits in a single
scan batch, so callers must pair the helper with a large pages_to_scan.

Settings pushes and pops must not start passes nobody asked for
either, so thp_write_settings() now writes each khugepaged knob only
when it changes. Switch the khugepaged selftest order-parameterized
cases to the helper.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 .../testing/selftests/mm/hugepage_settings.c  | 66 ++++++++++++++++---
 .../testing/selftests/mm/hugepage_settings.h  |  2 +
 tools/testing/selftests/mm/khugepaged.c       | 17 +----
 3 files changed, 61 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index d7917dce3aba..a26a0cffa9c5 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -183,6 +183,17 @@ void thp_read_settings(struct thp_settings *settings)
 	}
 }
 
+/*
+ * Write only on change: any store to a khugepaged sysfs knob wakes the
+ * daemon, and settings pushes/pops must not start scan passes nobody
+ * asked for — khugepaged_full_pass() is the only sanctioned wake.
+ */
+static void thp_update_num(const char *name, unsigned long num)
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
@@ -230,6 +241,43 @@ void thp_write_settings(struct thp_settings *settings)
 	}
 }
 
+/*
+ * Completion barrier for khugepaged: wait until a full scan pass that
+ * started after this call has finished. full_scans must advance by two;
+ * a +1 step may complete a pass that examined this mm before the
+ * caller's setup was in place.
+ *
+ * Any store to scan_sleep_millisecs wakes the daemon, so the barrier
+ * works regardless of the configured scan cadence. It wakes exactly
+ * once per missing pass — over-waking would queue a straggler pass
+ * behind the barrier, perturbing whatever the caller sets up next.
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
+		thp_write_num("khugepaged/scan_sleep_millisecs", sleep_ms);
+		while (thp_read_num("khugepaged/full_scans") < target) {
+			if (elapsed_ms >= deadline_ms)
+				return false;
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
index 726c73c43c05..8de446affeec 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -83,6 +83,8 @@ static inline void thp_save_settings(void)
 	hugepage_save_settings(/* thp = */ true, /* hugetlb = */ false);
 }
 
+bool khugepaged_full_pass(unsigned int timeout_s);
+
 void thp_set_read_ahead_path(char *path);
 unsigned long thp_supported_orders(void);
 unsigned long thp_shmem_supported_orders(void);
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 971e97a7330a..65fafab06410 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1126,23 +1126,10 @@ static bool range_not_collapsed(void *p, size_t len)
 	return true;
 }
 
-/*
- * Completion barrier: one full khugepaged pass that started after this
- * call. Waiting for full_scans to advance by two guarantees it; a +1
- * step might complete a pass that scanned our mm before the setup.
- */
 static bool khugepaged_wait_full_pass(void)
 {
-	int full_scans = thp_read_num("khugepaged/full_scans") + 2;
-	int timeout = 60; /* 30 seconds */
-
-	while (timeout--) {
-		if (thp_read_num("khugepaged/full_scans") >= full_scans)
-			return true;
-		printf(".");
-		usleep(TICK);
-	}
-	return false;
+	/* Wait up to 30 seconds for the pass to complete. */
+	return khugepaged_full_pass(30);
 }
 
 /*
-- 
2.54.0


