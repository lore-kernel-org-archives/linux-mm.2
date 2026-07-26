Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF00C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 12:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD90B6B008C; Sun, 26 Jul 2026 08:21:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C622A6B0093; Sun, 26 Jul 2026 08:21:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78D16B0095; Sun, 26 Jul 2026 08:21:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89A466B008C
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:21:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2385160477
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 12:21:43 +0000 (UTC)
X-FDA: 85030838886.20.59EEA94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1091620007
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 12:21:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gi3JlaCg;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785068502;
	b=XJdsa5zIWxrO7YZ2H3yZdpTR9cw9E7nffzEWwFbsemZbbVlMscoHamDmVtjklSyOK6pWAi
	xrFDz0xr8kVaVso7J0c6c6FBuAJMol9jYu5ZitVrVpasgxxJOdHo21NcJRdPiR4c+e4806
	C8RWGuLL+rjnK28oF/2ZlRcMUq7Da7Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gi3JlaCg;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785068502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LkwAEEFWY7JzMw6txcP0Z68llfDTMNlFyazJA9AKKho=;
	b=0TzkOsrmERT4t2HHx0lXyj6nGIOmY9hjcfw455seu0vcuIAeZs6pnD/ZQS6XjFaDtZ9s86
	y1L70lLGpRqBGZ6EPx0h5Ewy12+CQDBro4ZuEZtcsSm4X4s9gTxf58iOk4UAw8r6OEs5wE
	kA2v5zwKnePZSjutjt4uwNJd3CL/8OQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 558A4413E0;
	Sun, 26 Jul 2026 12:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B95F1F00A3E;
	Sun, 26 Jul 2026 12:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785068501;
	bh=LkwAEEFWY7JzMw6txcP0Z68llfDTMNlFyazJA9AKKho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gi3JlaCgRLPOXMx+AwXsw4LLuWg3X4Ew8OKpudKKwXilVxTjz9UtB0Q9gOGu5vOvx
	 OKptOJJRSqKIzR+001p+ldbXjw7dwSGac4XPp3XaoLeQtdbGSO11jmrp1WGFJ4MS/A
	 h4Dnfr2xVR3fUlEFi/9Th3/EBMbzqd24e/25HJHAdSuObYt5tMNX6eynLZlsgX3Rqp
	 Rx4fd2CuNY7g3R0a056G7pvPDU29qBBJHbbhqaKiTdhFTkvLtCgapZfRIcUTMTCcim
	 l2hGgHzYfZfquVTBBhovaWCDyddegRpoR1eU/2ZlfbXKZu7Y6PK8Gl3ndqdFsdQFpP
	 F4n11GqsHUAXw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-kernel@vger.kernel.org,
	lyugaofei@xiaomi.com,
	stevensd@chromium.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v2 3/5] mm: mglru: prevent min_seq[type] from pointing to an empty generation
Date: Sun, 26 Jul 2026 20:21:21 +0800
Message-Id: <20260726122123.7614-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260726122123.7614-1-baohua@kernel.org>
References: <20260726122123.7614-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b8deqe6pqxt3jdkrzfa4q65jpjom1b15
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1091620007
X-Rspam-User: 
X-HE-Tag: 1785068501-571736
X-HE-Meta: U2FsdGVkX19j0SRyHFZP7/43PnADqiCCDgDK46CzFC27qkP1KB/LFBLreZE0IN0dzKqdmY6fwMCpcKukj1aBPHmGOS7Iblr1FGP749MDQ3+Td3z9uaj+s8l9/syxwCQTAn2ecegm+RpMneERe5YVcefKvV0BghNl8i/6Pg9/i8Z2L3BHkYgabxpqrjF6wT/6bDDI4DmYro2c4zjpnswkp9iy1SKGaP1SrPu3A56yhbCgNFwOQ+hGlZeXrL8LQYiJyMmGRyghQ9EjN55wcdQ2l+NfHNa0sOcd80zvRRvK632b65G1Ed3bzvYmYAvT2QpEC9jwFCFL544HZWrjFAX1eb2SC4GImPO5Kni5Vk7COo1URUvwa0UOr3hKqN2/tC+p3f/+fsXavR0S2Nt1TXRGZkvkjpvyz2WiT0v2iskVRHCLXVnYfSi7iwhnLo5gCXhNL9z4l2VEnDaKF713r8IvnpEl7bblFpG/bszPhR14VYcwamXG8chkJnU0wig6qbXXz2PkOfASV8kZW9t0Z75l/RZaPj7EA06byrEfxvaPVoK/tURvOlGE6gdr2/iOBrFiOqVYayO9ZnHU94fw3Bq5Qq5ql6Qni/j1tk7Q/jKeVm0bhKGGzck55zhBXXMhqLa7hbUuThjnKbIxEus3clYIO64nyHbIB4e8zG8bmCJlJGh5PM6/klJ7t+Tdu0RLWSigJCpSn3vxKM2GKOoSDIcPwlf+v7pAVghlBEaWujMFfXCGpI440vluUD7pR32JoQpYQvbgK8MTPFWI5lkyHWQOYS/Gg+Ju20t482VLtRwVXohBQI4Pu/vEe/MqG9LwBLxGI23+u2v5kBMsu8/PffmygxSeINQndFBnk2JdlEIi+BlqRuZ6uRrkKlxDm/+Gf04y2pplYlVYyUALiOHaWSAfLCiz32Mh6xNOeFHhOX7zJPJGr/aQXyOr4Ubj23UNr2wmgaKuJ3p8lvvK9IPYorl
 yzI76zS6
 6JB2NYmK8W/uHhcGFm/HKgh37j7r3HlRaPkKnlwKN4NZqdc81buojlkvGmX8bz5Ewr6O1j4/1TNaFY4P5hIZydtL3z6Vrj5kz+KwjQUDpLy2+TtudZN3EiNIUbzckvPs47vBDC1KbbrbMD3c5VR9PLErW4VpwJ7ldO308LO9JftHX1eUbgQfPCJIHv/IU+bi5BV5N9H4sRt8OLM/KwNZXj0s4sL9ReMak06+iEmua+HuGPN1PsCupBobIkGRfOQlKtt6nABl/w/iGN1Q9UTeVbwnXISjFNZIdQvsU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In try_to_inc_min_seq(), min_seq[LRU_GEN_ANON] and
min_seq[LRU_GEN_FILE] can be fixed up to point to empty generations
in order to keep their gap within one. As a result, scan_folios()
may repeatedly scan empty generations. This is confusing, as I
observed scan_folios() returning 0 even though the following check in
scan_folios() doesn't take effect:

        if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
                return 0;

There is no need to adjust min_seq[], since the reclaim logic already
triggers aging when the number of generations reaches
MIN_NR_GENS, and reclaim never reduces it below MIN_NR_GENS.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 include/linux/mmzone.h |  6 ++----
 mm/vmscan.c            | 10 ----------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a26c8b855222..233d2006a541 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -552,10 +552,8 @@ enum {
  * The youngest generation number is stored in max_seq for both anon and file
  * types as they are aged on an equal footing. The oldest generation numbers are
  * stored in min_seq[] separately for anon and file types so that they can be
- * incremented independently. Ideally min_seq[] are kept in sync when both anon
- * and file types are evictable. However, to adapt to situations like extreme
- * swappiness, they are allowed to be out of sync by at most
- * MAX_NR_GENS-MIN_NR_GENS-1.
+ * incremented independently. For both file and anonymous memory, the minimum
+ * generation must be at least MIN_NR_GENS.
  *
  * The number of pages in each generation is eventually consistent and therefore
  * can be transiently negative when reset_batch_size() is pending.
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4a387cc4145a..d6bd64b4dced 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3972,16 +3972,6 @@ static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 	if (!seq_inc_flag)
 		return;
 
-	/* see the comment on lru_gen_folio */
-	if (swappiness && swappiness <= MAX_SWAPPINESS) {
-		unsigned long seq = lrugen->max_seq - MIN_NR_GENS;
-
-		if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < seq)
-			min_seq[LRU_GEN_ANON] = seq;
-		else if (min_seq[LRU_GEN_FILE] > seq && min_seq[LRU_GEN_ANON] < seq)
-			min_seq[LRU_GEN_FILE] = seq;
-	}
-
 	for_each_evictable_type(type, swappiness) {
 		if (min_seq[type] <= lrugen->min_seq[type])
 			continue;
-- 
2.39.3 (Apple Git-146)


