Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CFFEC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7761F6B00A7; Tue,  8 Sep 2026 08:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700396B00A9; Tue,  8 Sep 2026 08:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 503E46B00AA; Tue,  8 Sep 2026 08:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21BA36B00A7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4978140614
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:35 +0000 (UTC)
X-FDA: 85190581350.20.A74D597
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf19.hostedemail.com (Postfix) with ESMTP id B414E1A0008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="M b78Xke";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=hw1SwZL0;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871893;
	b=uStAhdcTyG353s/fG2SkYIGhPOsTkHwsYy/y2UJAl/9Avguq/n5w2LO52TM8Izx1Z66xX9
	dhpBA1FEBw3MeUw57+eJgcrNf6oMQoBRkgjf03nxmO9qCmx4MCEb37xFuAgLhUWlpmCrlK
	slKW6jB5NqLWBXCGS85ovmckWgfbvfA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="M b78Xke";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=hw1SwZL0;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZdwyABOaNmEF1DzIgN++GAqrNvL2Pol9IuJicRUy5c=;
	b=K4eeJ6qVghEnetjaysSJUzEVG4+BhCzmw8wEitc2LWhV49n17O7f7fDXmTSyS/fljlWB0t
	CttBMlcpA+nwL9TFeVe60uVIMAk3ie3rOrx9Lpn7y054ugkuMOIjwYaJCAr+hgH0nfbz3q
	ZBksaUFDeSw3EDBLmKRdUqg9383GLzE=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 4342F1400044;
	Tue,  8 Sep 2026 08:51:33 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 08 Sep 2026 08:51:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871893; x=
	1788958293; bh=zZdwyABOaNmEF1DzIgN++GAqrNvL2Pol9IuJicRUy5c=; b=M
	b78XkeAnXboPXQjTmvKBc03Twx79GMqtjyueOvDCw7zAWsEsBql7r0ENUqaLb40z
	K4Elz5yYzUAUJYuFRDk0qMrbFbUDcjqFmNNAlrYAbHYEty+fcv8VlqzUmjsrYi8Q
	bK9jRj9oBS2tPLfwRzNBQo3YhDQ5YiBIJAWHW9OdaUn1Oz7SJIFiXheMO+EN6KUF
	Sf1GynOCBUoAX6TTifGs90a/3vESuA5bMyERL5Mt00PyTeeBcJL36ALeFI8+kOzL
	eXTrUSoOEuV8Dz3QjaNaKsClZvsgOdr0+MCwQWcYoN3UnO9Vcw7zgsV+kIYxt6wl
	RfSLk6dfH+tcLotESXtAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871893; x=1788958293; bh=z
	ZdwyABOaNmEF1DzIgN++GAqrNvL2Pol9IuJicRUy5c=; b=hw1SwZL0PJF2OIctz
	p7ojpTWonQ1IpAh8GxmlodNHM9Wh7vxYijwlBTEUzkusFxh1bgEhGp0zTt11pkue
	NYF1FiB5Gfel26AByPnELaogPr6Hwz9MXE87aSdQMwTqxGOoHtwNiPk/ypJas6On
	LoISFuk7HWimKApQIWzVviDLxGnWE8dsq9tTTZisHE9XDafcauFXavU7tTJdZ+TD
	FpSAFOIsh8znnR/Zos/yIzZbErRH8i9rbmLX6ddhYeFu9sZPNXrgK0/EcVT7NAPs
	nmI7d0pftwEw+VcdASAozQsNfaJdaNiwbLw6XCzNQZKasJm/whPGB5V4C+RY0kwT
	QqG5w==
X-ME-Sender: <xms:1QSgaux-yXTB5i2TAb__lpsRPzce2z1bQGbuQNA6OKaHGDHz6LjUgA>
    <xme:1QSgaiqrp9WkSCj4KoZKAR91IylpGD3-fFUSp4SC2i6ArIevywKXQoSjVDueZXPS3
    UPnJfr9XBwtklPAtqGUQVq7U2apo3RgxOstjqJdHUdeYx-SA83GmTA>
X-ME-Received: <xmr:1QSgaij1p_1asTRPtVxtO7L6PQtUW5NqM5TgiriVzmvobvtrXYrF77xLALQ>
X-ME-Proxy-Cause: dmFkZTG2QNbEXtfY0NUH9lclFg4+7JIhiWYHukGkvnVSObSRwNQg1Sx7FYcKV3VpQKoNMX
    4WQF58dhUXXs244+umMEX9jrGkMDwRzzMVgLkyqRYe3luiAtSdPaAslf0s6HAW42eLUNv6
    Yph1/7mYlVaPCfn2xuWU60bwW6XHYPjfiiyNarJsdoAUaCUYZV71ky6dHMPGvGVuM8xvW4
    m6EUOqtp7REAN37ZPBvE9zNKgCyv7ortpG0xd0B3rAc4044T4WY38XKdTr44RA10FWmQd5
    JtVQe6/NLKa8+LTeK9YofjDIdR1CHuwVtlVlxJps7ZJJl3uGOhbQDTam1VDoGFqiJQ2gsh
    e39YrcQvUq6AYUDrO9sflBa9KyEDsXs89asHcGNvRuUrQ1LmHXFCAxVgEYhtAw6VUVxcWz
    dLhg1J2V2OGEMz7wwDo4lKPHRNRqEku4lCyl/N9v9Khjf1nonvSVZBO56v4OknNo+C7n69
    HUdxgGWOZyzcfYVEUXi3FO+ss8/CTFx/bD2NczSg/G7LWN7BRqghdjpTIqwN4NkUo9Q0zf
    295Bfqpf/YN8QzYJx7CsYum9LbB1y2YcdyBayR19vk+6ZWLG1vremh5qvb2fS2Rfd8G7B+
    hq55TiTknTDV22aWsxOQtGI5CRE5gmfFJzo8yzAmYeFuMPuXTU69YiXH1oCg
X-ME-Proxy: <xmx:1QSgasWDA4lEj1Y900g2ehbNAdVOhh0QG951seI8nOpmRJcf5Vl4Qw>
    <xmx:1QSgaiGCTxgZaydgSKEQJ1zUvo19UpbIosjI_qMIq4mdorFZ1LaWww>
    <xmx:1QSgak9tP6HGG3hqiEjJlWFoEdP0JIxfpRJvxPsXuaYdbOeX9qIW_g>
    <xmx:1QSgaq0u_I767w4DkRrdrtr4tY1IuWb4mkqW8TsLv05x5jEktOcGaQ>
    <xmx:1QSgarxiUJzp0Upf742kCg_BI-J1HFVeUlk2k8NBua34qZLc4_vLks6v>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:32 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 11/19] selftests/mm: add order-parameterized khugepaged collapse cases
Date: Tue,  8 Sep 2026 13:50:57 +0100
Message-ID: <20260908125105.1510704-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B414E1A0008
X-Stat-Signature: a81h9djarjeja561we9rndg4k989eoti
X-Rspam-User: 
X-HE-Tag: 1788871893-883702
X-HE-Meta: U2FsdGVkX193pptamKxK5YgKaA2P5RcFy62DMug75cIMyRy5WEndXSo+N/mCSWcXlLDEMFN7ZyQmQFCqLyYGYr2ANAoCfi9lil41x/rKm2sS3HobgAiiee8SNUi7JAIY8mt7SY+OZBet1dllVgsjj5NFPdX1S3oyDlwpg20PtVozTkPKY8K6aAQg/Xv+GEpTNndyq4h4R8L1/pOum/El468tHaXmbefdGR5t54yHB30WA4vmr54dkCQK2qCjqK3IwSWGgOifvT0o804lQsbJRQoiEUwlpO6/eqE4IBUEj0hOaS6prIAxOy0h61CeBP+g9Is9wNys0qvkJ8aP26PKIt0dhos2XltpJI2DakYF4om1k11J1xV1nUJ5IaW2kSxSpUXJjazvBwq6zGq9gIh6To6xpdpbCEt9oYhEHvCcs7g/ceQMsjkc2nQ9SHqqGRpFwnSzOmZLfTbmRsUBbdAt3NiyJV9FUxqkvCf88fzwClttfKbWqZAgNrNqtBQZmGtn+IebmVOeT4P7hcbGqRQpqLF5kYWFOSoIHK2BQs+wd8WT/kvNdBk3Xfn2SHv6awGhWShWaUSWN0S++amtDonZmU6E2ZdHDfNvOS1WnxTUKtFduejBGwDwq75id4H4IG597b8qsjuYpJVsgWl7TdIZisWK+p8kIbJcDKuaCI/x6/zKjbzhZEVbYU/6NMgvsrsfR/VLguSQq/7aRMCRjjM7vCemt8143ZKawkD91rzs3fjKQzvH1jgLao7u4qgMyFrbILtwCRhC2KdQSCH7jDhoF7WKiS/uLur8Tz188EXc09POfyaBMic9h2cWso1JVMpPeQfpG7JldUbIrMLGbLai6gPp0LF3mpQa0Dxif533GmMa+n74hpsDjyd2YmNVCwDUqKbzCG/6RXQGpsQCfRTJtnp7KTbGBMu2B/cDvXQxkgeMq87bMyGWFr435qA5b4vhxqoD0jlfowFwRbMGRLL
 g4fPRG7G
 CORNubwpXL+INaLUDypRwUr93o7N8RMDzrjlG44VIfQA56mWUunH7FV4uAtehVIH1Meqr9u5ceeit6DYnAeBV2ATwb0PV5V7MH46l6Zjtniq/gLFtMwJFiSII2XzwNT7ClJfZNe/dkQtS7rks5gZFTjd2KDWPty4AByvDowZB6lZd7Yhf8hHelWKDEu6BeQpPFayqf9wXEE6Mg3mLX73seDs7um3ra3ZBuAkV518OW039J+wvLmyiJ5998CjYL554v9yTTAWMHBTLifDjY+xcex4p9FE8Ivs0MIJPZlHmJp8k8h+gW839ayYW3WBaiZXtcF+aeNO6scXDiBxWDbuMJN9kcf+XZhB5Wdy5TvLCNn4tJMW3ZjW62KQOa4l9DYLfDVg2h6iIt1EkqDbtuIM+NwMeqxHX/Wa3hS0nvgqImeZwPC3+4Bja51GScFnoC+rm0xWYcNz0urIUP5Mz6CFNiRiDKA4CYskgYtt1LeT2w9sz6oveJy+0gdakQYk4LuJx+QR8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The mthp_khugepaged context runs the generic cases at a sub-PMD order,
which answers how many folios of that order a range ends up with.  It
cannot say which order-sized window they landed in, so "the populated
window collapsed" and "the empty window next to it collapsed instead" look
alike.

Add four cases that check each window on its own, with the folio-order
helpers in vm_util:

- collapse_order_single_window(): only the populated window collapses;
- collapse_order_partial_window(): the default max_ptes_none lets a window
  with one present PTE collapse;
- collapse_order_max_ptes_none(): with max_ptes_none=0 a full window
  collapses and one missing a page does not;
- collapse_order_mixed_sources(): sources that are already large folios of
  a smaller order collapse to the target.

Each case faults its region before MADV_HUGEPAGE with only the target
order enabled, so the sources are order 0 and the result can only come
from khugepaged.  They wait for a full pass rather than for the result to
appear: without a completed pass, "not collapsed" and "not scanned yet"
are the same thing.

Assisted-by: LLM
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 212 ++++++++++++++++++++++++
 1 file changed, 212 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index e9bc8fe8a1f8..fb4efaf67c40 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -31,6 +31,8 @@ static unsigned long page_size;
 static int hpage_pmd_nr;
 static int anon_order;
 static int collapse_order;
+static int pagemap_fd = -1;
+static int kpageflags_fd = -1;
 
 #define PID_SMAPS "/proc/self/smaps"
 #define TEST_FILE "collapse_test_file"
@@ -1207,6 +1209,198 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
+/* Smallest order khugepaged will consider for mTHP collapse */
+#define MIN_MTHP_ORDER 2
+
+/* Time budget for one khugepaged pass in the collapse_order_* cases */
+#define MTHP_PASS_TIMEOUT_S 30
+
+static size_t mthp_window_size(void)
+{
+	return page_size << collapse_order;
+}
+
+static void mthp_push_target_order(void)
+{
+	struct thp_settings settings = *thp_current_settings();
+	int i;
+
+	/*
+	 * Only the target order, and only for madvise: the cases fault their
+	 * region first, so the sources stay order 0 whatever -s asked for.
+	 */
+	settings.thp_enabled = THP_NEVER;
+	for (i = 0; i < NR_ORDERS; i++)
+		settings.hugepages[i].enabled = THP_NEVER;
+	settings.hugepages[collapse_order].enabled = THP_MADVISE;
+	thp_push_settings(&settings);
+}
+
+static bool all_windows_at_order(void *p, size_t len)
+{
+	return is_range_backed_by_order(p, len, collapse_order,
+					pagemap_fd, kpageflags_fd);
+}
+
+static bool any_window_at_order(void *p, size_t len)
+{
+	size_t window = mthp_window_size();
+	char *addr = p;
+
+	for (; len >= window; addr += window, len -= window) {
+		if (all_windows_at_order(addr, window))
+			return true;
+	}
+	return false;
+}
+
+static void collapse_order_single_window(struct collapse_context *c,
+					 struct mem_ops *ops)
+{
+	size_t window = mthp_window_size();
+	void *p;
+
+	mthp_push_target_order();
+
+	p = ops->setup_area(1);
+	ops->fault(p, window, 2 * window);
+	if (any_window_at_order(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
+	ksft_print_msg("Collapse one fully populated window...");
+	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
+		fail("Timeout");
+	else if (all_windows_at_order(p + window, window) &&
+		 !any_window_at_order(p, window) &&
+		 !any_window_at_order(p + 2 * window,
+				      hpage_pmd_size - 2 * window))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, window, 2 * window);
+	ops->cleanup_area(p, hpage_pmd_size);
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
+static void collapse_order_partial_window(struct collapse_context *c,
+					  struct mem_ops *ops)
+{
+	void *p;
+
+	mthp_push_target_order();
+
+	p = ops->setup_area(1);
+	ops->fault(p, 0, page_size);
+	if (any_window_at_order(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
+	ksft_print_msg("Collapse window with single PTE entry present...");
+	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
+		fail("Timeout");
+	else if (all_windows_at_order(p, mthp_window_size()))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, 0, page_size);
+	ops->cleanup_area(p, hpage_pmd_size);
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
+static void collapse_order_max_ptes_none(struct collapse_context *c,
+					 struct mem_ops *ops)
+{
+	struct thp_settings settings;
+	size_t window = mthp_window_size();
+	void *p;
+
+	mthp_push_target_order();
+	settings = *thp_current_settings();
+	settings.khugepaged.max_ptes_none = 0;
+	thp_push_settings(&settings);
+
+	p = ops->setup_area(1);
+	ops->fault(p, 0, 2 * window - page_size);
+	if (any_window_at_order(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
+	ksft_print_msg("Collapse full window, not the one missing a page...");
+	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
+		fail("Timeout");
+	else if (all_windows_at_order(p, window) &&
+		 !any_window_at_order(p + window, window))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, 0, 2 * window - page_size);
+	ops->cleanup_area(p, hpage_pmd_size);
+	thp_pop_settings();
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
+static void collapse_order_mixed_sources(struct collapse_context *c,
+					 struct mem_ops *ops)
+{
+	struct thp_settings settings;
+	void *p;
+
+	if (collapse_order <= MIN_MTHP_ORDER) {
+		ksft_test_result_skip("%s: no source order below target\n",
+				      __func__);
+		return;
+	}
+
+	mthp_push_target_order();
+
+	settings = *thp_current_settings();
+	settings.hugepages[MIN_MTHP_ORDER].enabled = THP_ALWAYS;
+	thp_push_settings(&settings);
+	p = ops->setup_area(1);
+	ops->fault(p, 0, hpage_pmd_size);
+	thp_pop_settings();
+
+	/*
+	 * The allocator can fall back to smaller folios under fragmentation;
+	 * having nothing to collapse from is not a failure.
+	 */
+	if (!is_range_backed_by_order(p, hpage_pmd_size, MIN_MTHP_ORDER,
+				      pagemap_fd, kpageflags_fd)) {
+		ksft_print_msg("No order-%d sources to collapse...",
+			       MIN_MTHP_ORDER);
+		skip("Skip");
+		ops->cleanup_area(p, hpage_pmd_size);
+		thp_pop_settings();
+		ksft_test_result_report(exit_status, "%s\n", __func__);
+		return;
+	}
+
+	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
+	ksft_print_msg("Collapse region backed by smaller large folios...");
+	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
+		fail("Timeout");
+	else if (all_windows_at_order(p, hpage_pmd_size))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, 0, hpage_pmd_size);
+	ops->cleanup_area(p, hpage_pmd_size);
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
 static void usage(void)
 {
 	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
@@ -1375,6 +1569,20 @@ int main(int argc, char **argv)
 
 	parse_test_type(argc, argv);
 
+	if (mthp_khugepaged_context &&
+	    !(thp_supported_orders() & (1UL << collapse_order)))
+		ksft_exit_skip("Order %d is not a supported anon THP order\n",
+			       collapse_order);
+
+	if (mthp_khugepaged_context) {
+		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+		if (pagemap_fd < 0)
+			ksft_exit_fail_perror("open(/proc/self/pagemap)");
+		kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
+		if (kpageflags_fd < 0)
+			ksft_exit_fail_perror("open(/proc/kpageflags)");
+	}
+
 	setbuf(stdout, NULL);
 
 	/*
@@ -1425,6 +1633,10 @@ int main(int argc, char **argv)
 	TEST(collapse_empty, madvise_context, anon_ops);
 
 	TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
+	TEST(collapse_order_single_window, mthp_khugepaged_context, anon_ops);
+	TEST(collapse_order_partial_window, mthp_khugepaged_context, anon_ops);
+	TEST(collapse_order_max_ptes_none, mthp_khugepaged_context, anon_ops);
+	TEST(collapse_order_mixed_sources, mthp_khugepaged_context, anon_ops);
 
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
-- 
2.54.0


