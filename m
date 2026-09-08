Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC0E1C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AEAE6B00AF; Tue,  8 Sep 2026 08:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860D46B00B0; Tue,  8 Sep 2026 08:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F126B00B1; Tue,  8 Sep 2026 08:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 530BC6B00AF
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E44E01405C4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:46 +0000 (UTC)
X-FDA: 85190581812.27.7FE8106
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf15.hostedemail.com (Postfix) with ESMTP id 16A7BA0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="C en3VCr";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="srxBstZ/";
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871905;
	b=YtttP8jAH+eEUaxKLS91XOXqmzsheKFMwvlS7TfUWCY+U9DhMh+vcOSGLgbtUeDH+fndUJ
	rGcA5c7hj/l2wWlrIr+FcJiaH63SsRjOlREk/67um29JSqniS830nv5vr39PBBUvOY4a5O
	RlqH7nqTcg3tg2Nb16ti4rlpNpkIHZ0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="C en3VCr";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="srxBstZ/";
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbCvvEeTGNJUluvqL2n+kCyw5bEenmwnstQ3FSwOS9I=;
	b=tnj4cu/iMy0nFFqV2tCr+ZoCZ+ygHCNAS6K/vFXupgZiZWNYJv5lcMQyEIRL3HxR00A1eP
	Fl89uG6dtRboJ7EsX9TcAvNeWF0I/zIMKx4Npbo6Vssl/FjksmDxacRg4kqhtuh6ivQiXR
	vvRxsxWa3sa1eRG8uYUp7zx982QINMs=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A38DD1400068;
	Tue,  8 Sep 2026 08:51:44 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Tue, 08 Sep 2026 08:51:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871904; x=
	1788958304; bh=zbCvvEeTGNJUluvqL2n+kCyw5bEenmwnstQ3FSwOS9I=; b=C
	en3VCr9mXESspPmSzUs7MHT+mJvHcm6vgknu1Xu5L/YIItjs+W98YEnu6RtbWi9m
	FOx5327IK31dXKcjveHab/Ji8jDpeyWFqJV8fjlAVEiVXnxCA9bUpwOGKxAQa/ea
	I9r08baLelHbK1KX99lBEJYNzYlQhk3+imEnWWl0pyh3c4eBvUUjVz0XMAZbjSJn
	/A21txCc4+Q2umLOWBeXgw3jGKTU1Bge/xw7VydevjJvOQygDFRSVbmGHPY2azdo
	OjjNBWNNW5EJaEvxkJgMcwv1G/q08OwBvHfjLs6MNN+BEdnNQ3LEBRAOIsekYgHd
	M8kYJnd404soEtU8s0fiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871904; x=1788958304; bh=z
	bCvvEeTGNJUluvqL2n+kCyw5bEenmwnstQ3FSwOS9I=; b=srxBstZ/a5I3zrcpX
	CnX9UM8oNW7jIh+h9f2IPWcukw0AO8aC7fMcCzx3oCAraYT5fWZ0buEOhL9IbLp4
	kyVZciL6mr2RXGJJVZIoQ1HcrLPwwrDN5fYoxCCH32J+NCX4KHshi4EtOAM0mA++
	dnYz0Ui6bzMxtUWmQG25O9LjGTLPvMzjwmaEuhiUSY1kjcKrVd8vJv8fhX0I9ZVD
	k9T2gto/vZ57mEPTbiFChJOzf1XJISI3B6fhL+6rVaWvGjR9og0dA3cyHqrjSnhu
	UJx+y2PxqIVwCZFlyw+Wqug+mpvRxNjS8zuZhf6HbXi36Y741uKyh6Y2spuuzYhv
	YRicQ==
X-ME-Sender: <xms:4ASgavCHMneS9i1S18jALXAn7oBj1EeWMC64Ybh1eQ3gA9AHhoeLvw>
    <xme:4ASgat4ZKgIHqYYodj1AIrAiH1BDY5mOKXgDuca9zlwQbhHZ4vVG9uoDp794d2avo
    uLjHuC7ShXDht5WMPM2Dzpy_dAWbiz6VYQDI4i7eSXV_AvUUSNMQxcq>
X-ME-Received: <xmr:4ASgaszPlkbUbklH2h-BnUuDCwyQpLMe9pKeX0QV0sNJ-udcuYlQR-m0nTc>
X-ME-Proxy-Cause: dmFkZTEFE5qoX+UuF24uzYsEDVhBj7K7PVNhp/QrdS9IridywNr6zbUVHRTwEJHEkegH78
    2Q0FzpV7Ffbkv2IdJy+2X+gRr5j/GVU+OmQCyX7TrMKkR+B67hpV4qik2kuPcySyPVfL0N
    fjj0puKIPOVKC53VUKH1AFABHK+HgKXG4fFGTm0bttO6aht4AByKsMi5q5m3My1bWaIsHx
    VvWLDqNEgw9NR009yUV13rBPhKD5hG186SgbvLIVXWjVzTBDRGAi2tS1solDyldiLqdSzW
    Z7lbjekX5xhyyUWYdDppP3CJdHwaOTYUEqdi4pIet3xRU1rw2DJzUGF3Njycnc94ehWzmw
    R2sVtQqcjql9WndhmtChSoeg8JgqPt78nSih4/C1Mx3BlZ90urh9FBsiO6UWAUNJwRUGjc
    8pZA9NVuO0gT2YokndUx/YfQS18X8XGNethIgxEH8zreKreLc/5QEgljrUNGtZJ/f9boOw
    wRcMCRaWqx3u9UU2hS4og0hmE3v1ab0++imJ7UI6HSA/ISHYzUecwxxqq/SvydyNBmHIFz
    hH/4J/13str7Xs52hP7vWlXtSeZ0hy4TIP77Wy6vvHRi2xUv9pzc6s88yXAWoav3Ojh8xW
    JAWrV9qOhpvWiPBqrPc4z6Va90tfBjV0yPSYDHGWPwyCfksm9cHADsVtfO7g
X-ME-Proxy: <xmx:4ASgapnzVfb1HydZ6RMfqQm5wkkyEzOleoBvKHmHC08kNI9dbSByMg>
    <xmx:4ASgamWXUaSdN7lz9x1Z2K75_a_zU8oMEIcckG7iRVttegFBlsdqXw>
    <xmx:4ASgakOT7a85P8hl5cdWfy0tK_5n8tzE3UI2dI1uXE_6hPr_6fajaw>
    <xmx:4ASgapGPK9ocODrWktac23pzsLbLo-3MC797fhNQaXKHndrdhCCUdA>
    <xmx:4ASgatCEwEuXL5CaALsdwJaS8MO_UCRtkyZWjSNnTiHzaKlLW6HP5FTD>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:43 -0400 (EDT)
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
Subject: [PATCH v5 17/19] selftests/mm: race the collapse of windows with holes
Date: Tue,  8 Sep 2026 13:51:03 +0100
Message-ID: <20260908125105.1510704-18-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 16A7BA0004
X-Stat-Signature: ugypigeob4obtb4iknxrix4orbebeckz
X-HE-Tag: 1788871904-822996
X-HE-Meta: U2FsdGVkX1/WOsh43MnZD04WWPKU3gI4NhJzDrtG6OCHyxsUyyBmXsLVi2J5XW2D2dLVWgGvgcg02oY+4j/qOkD49glkXHLgsSv2LUJyUuCenxfDZXkFBvdtUfZiwBZy/yEbWAvs7DBB8yYdu9ogy9jF5fDGhfk3YHXyi0pzWSSqLm8iNAe4Mw06m42xWKwslbqVSIw3pM9zZIwM5IhYIp6XFapDV4Gtg/psm/JO1z9vG9R0tExVIKZCr1sb112RU5MVlolu3nBfQGIJ3J9QteltDtyf5IqQwEoHSj8hnWnqeGhPLLs2Xs49BkQCkmPzrej1KubNgPNyhJyr123Rv309aX7VOBU0xvpg+SEc+GqSeAeuLjjEP4alPRGUqpBYCuqVOBSVrDsxnRqL3lYjXdFyt+FA4Wt885ANBGHBrv8AdIuG16UA1Gzq7wIC41OudkjVhZshxlO1Sdse+UhA/f9brfny9tSK4Ket2yzU55RB4pKdNMJOdu/iGBL/lkxP6zf9cedO5KDtogijmmci3BlxODi2vAMpjzYHh1jPiOJWrQcEdpFyHdzGYNT/5zYgrc7Adtknvi51BFR+ZgBeLeRFrykmNo2NTz/FLej7YLJZyfocPPKQHc4fxhmlr7KdfiH3hbjGOC7KsTeYvbfbmL2njRHsavSPTSPER/eJpFh3RkIC6vExEInNH889DkvCNT+v3Lu4a8qyzFLkzhw+ZxvmZbyWrr+TWH0js2gTetFRpG4L8Dh4fqO6PH+WycHpBY+CJ0NQ8nEUHCX92iyEN57b3IYfJ76wHMM8H1fPrYKn16mqugVbwBiqHs3k1Dyzl3SpFJzKhWZNHiTPpP88/MifkhXGY7cF4iXaJtsdGDd6oavgDoTX8qa+S3R1rIxEH7sjNYpK9SjuTW0iHSprzXzd0rjLpyjRC8xpaJEpXjdaSEec9Daq7XTd66D6qyoN/UIGeidUR+5cp7bQl6D
 nbhROQzl
 iHUQ12R9Vhv22hE+LcAncUhM6pUtNJSxoqs9Bt6cklaz8Pn5Q96VB8HVyICOOEusbpHm86LNcJBa0o9HCl0QLjtIcW9lJPvSvWhGTmJYe2ahtGg2C4AYaMyf1DgT4TdWQ6d1leRpAxnDCIBr9Vee6h6udcO9l98v7giqHqAIq4WheQNf74/81L7MnN02HLVzj4vEDflXrKDgjHArgkIxcG2r29fLr8HT1Tg/Wv/6D+mOcRxgpDz7uBFYQIuPtb1sBj2NVteZD8045P/ILw9efJbT9idVvvN0Sv/XYVfXY9az/Fquz7HXUR4aRK0GQqiuNiHgVGuCo4lJwGSFJJCiEf/RWBFtFZOtFAMOS3ahnTLkElxBeUVBQX5GGIOZ++uem2A5px/nzuErWWwqICj/M/+NQ//+LIBGCNNbkzzB+0ZBmE7Zab+y64CXmNSF4s82IKradYhPxU6iLn+B5j4EaWl8KUBZuDUzI9Hut/NEVdWm0vUixIr2Bga8/laMuE95MD2Oe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The harness pins max_ptes_none to 0, so khugepaged only collapses a window
once every PTE in it is present.  A window with holes takes a different
route, and never gets raced.  A hole is zero-filled in the new folio
rather than copied.  Which slots count as holes keeps moving under the
racing MADV_DONTNEED, right up to the moment the PMD is detached.

Run both ends of the occupancy scale for every driver mode, one after the
other.  mTHP collapse supports only those two, 0 and HPAGE_PMD_NR - 1, and
coerces anything between them to 0.  Each result says which end it ran:

  ok 1 stepped/strict: 5s, 231 steps, no corruption
  ok 2 stepped/holes: 5s, 194 steps, no corruption

Assisted-by: LLM
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 32 ++++++++++++--------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index 448256704ef4..f31f12fc0390 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -231,6 +231,8 @@ int main(int argc, char **argv)
 	const int nr_threads = ARRAY_SIZE(thread_names);
 	pthread_t threads[ARRAY_SIZE(thread_names)];
 	static const char * const all_modes[] = { "stepped", "free", "madvise" };
+	static const bool occupancies[] = { false, true };	/* strict, holes */
+	const int nr_occupancies = ARRAY_SIZE(occupancies);
 	const char *one_mode[1];
 	const char * const *modes = all_modes;
 	int nr_modes = ARRAY_SIZE(all_modes);
@@ -298,7 +300,7 @@ int main(int argc, char **argv)
 		 -1, 0) != (void *)mremap_scratch)
 		ksft_exit_fail_perror("mmap() mremap scratch");
 
-	ksft_set_plan(nr_modes);
+	ksft_set_plan(nr_modes * nr_occupancies);
 
 	thp_save_settings();
 	thp_read_settings(&settings);
@@ -306,8 +308,9 @@ int main(int argc, char **argv)
 	/* Base of the settings stack; the bottom entry is never popped */
 	thp_push_settings(&settings);
 
-	for (int m = 0; m < nr_modes; m++) {
-		const char *mode = modes[m];
+	for (int run = 0; run < nr_modes * nr_occupancies; run++) {
+		const char *mode = modes[run / nr_occupancies];
+		bool holes = occupancies[run % nr_occupancies];
 
 		thp_read_settings(&settings);
 		settings.thp_enabled = THP_MADVISE;
@@ -317,12 +320,14 @@ int main(int argc, char **argv)
 		settings.khugepaged.scan_sleep_millisecs =
 			strcmp(mode, "free") ? 1000 : 0;
 		settings.khugepaged.alloc_sleep_millisecs = 10;
+
 		/*
-		 * mTHP collapse honours only 0 or HPAGE_PMD_NR - 1 here, and 0
-		 * keeps a step from being spent on PMD allocations that racing
-		 * MADV_DONTNEED will not let succeed.
+		 * mTHP collapse honours only 0 or HPAGE_PMD_NR - 1 here.  The two
+		 * ends race different paths: a strict window has every PTE
+		 * present, a hole-heavy one is mostly zero-filled.
 		 */
-		settings.khugepaged.max_ptes_none = 0;
+		settings.khugepaged.max_ptes_none = holes ?
+			(hpage_pmd_size / page_size) - 1 : 0;
 		/* One wake, one pass: the playground plus the forked children's copies */
 		settings.khugepaged.pages_to_scan =
 			nr_areas * (hpage_pmd_size / page_size) * 8;
@@ -388,8 +393,9 @@ int main(int argc, char **argv)
 			check_page(i);
 
 		ksft_test_result(!corrupted,
-				 "%s: %ds, %d steps, no corruption\n",
-				 mode, duration_s, steps);
+				 "%s/%s: %ds, %d steps, no corruption\n",
+				 mode, holes ? "holes" : "strict",
+				 duration_s, steps);
 
 		/* The next mode maps the same fixed address with its own settings */
 		munmap(region, nr_areas * hpage_pmd_size);
@@ -399,9 +405,11 @@ int main(int argc, char **argv)
 
 		if (corrupted) {
 			/* Memory is suspect; the rest would prove nothing */
-			while (++m < nr_modes)
-				ksft_test_result_skip("%s: skipped after corruption\n",
-						      modes[m]);
+			while (++run < nr_modes * nr_occupancies)
+				ksft_test_result_skip("%s/%s: skipped after corruption\n",
+						      modes[run / nr_occupancies],
+						      occupancies[run % nr_occupancies] ?
+						      "holes" : "strict");
 			break;
 		}
 	}
-- 
2.54.0


