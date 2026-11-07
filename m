Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA703606A330
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 16:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kwtoYxpa
Received: by kanga.kvack.org (Postfix)
	id E66D26B05B2; Sat,  7 Nov 2026 11:57:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3DE46B05B3; Sat,  7 Nov 2026 11:57:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53E76B05B4; Sat,  7 Nov 2026 11:57:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93EFF6B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:57:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00D48A7F6F
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:57:17 +0000 (UTC)
X-FDA: 85408928556.07.69E431E
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 21D7C20006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:57:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kwtoYxpa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794070636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivuY9EEI4xJsyai8BcC5oRsS+qnZmw9EkgstKaheARM=;
	b=HpgNyffRr/YQ7oI0xpjDAYbu2lHFuXAyW9VUH9j9P1suN3Bl63PSiK29S8WTUNEPg75jcT
	xhc60ceLlzW5iwg0RNAF7ZhXTLNh5hCc/Q6NHgi4zUiqHIQY+BFJWFW/ZFfpHOjs3URRaf
	72iJG+NHoErICzYff0Ixozrw3rBdL8E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kwtoYxpa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794070636;
	b=jAv5fLoH9iTicePRB4/RHzE020Xml71hbOdqdek9BFk0rvDvGr8p70PTVULqU0/pBOLcmM
	/ETTVFI6VXmCjvDWGLUT7B5vRnL1tcCQrA41nNa2MgEVtdVADJmA5nkrvZlUINUL8AXuWS
	7gX6Io0qVTha5oEIUdeKP/IInp8r4zI=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-170135e43c7so2859624c88.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 08:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794070635; x=1794675435; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ivuY9EEI4xJsyai8BcC5oRsS+qnZmw9EkgstKaheARM=;
        b=kwtoYxpaJXQkOCVXtwlk5iWgm3KzxJngcZoRvMPj5GlB8im4LKBDIxvW0Y6tDtkcIx
         7bHFvj7rXtey+etHEl6ZknvDR821xCeTYDLmD4fPrcVHS73jr+JUImpdO7olehCjzG5q
         Xo9zDE9x8O45LFPfnHEg3IJ6lDP3v68o8GsYHTEd5Sq1oobBHUTW7eJYgUefHK9tMcFR
         NtKe7ccvygFmkKj0enXrD0IoAuLGwJ6gUcAfxcACmVodbAj6DKF9r/VunqsBGhv8AEd8
         dQf8H+mltWOjiigck5aQHuTUsi6i9IZq7xnl+Vho7RXAe/DP6P/CGqDWgKJgznOaI6Rp
         SoiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794070635; x=1794675435;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ivuY9EEI4xJsyai8BcC5oRsS+qnZmw9EkgstKaheARM=;
        b=2DLOq15z0dvkU/fbOiTQqHqZrgK7zpGlRGjSOFKb+xNV9yT/O4vwsM/kJneLDkPWkB
         EntVaPHuW1d34CWbP0cmzxgbggL6j0qvVO1eRl9AWsxPoBt9VrvCd/HjTJhFeBoEFOWS
         poaCmHB7CvKmCk9eu3tRM3594KJ/n4ou2xSehlC1ki34IoKkD5FKAnrgOjwig/M9z+u0
         Dw/H5O8V4B4LCe64oLoOlb2Z16wvgBYsdtRxXgGxLxjMjXsLOeNsSfm4gO7SGok8g0gQ
         PJwY27hgR8aP8bLklYSOIUkv2TsaMy4R4Yo2qJAC/44qKZKk9BYmLRx7m1lemKoY8zkR
         pVew==
X-Gm-Message-State: APuU4Z+uZf1dCkE1QTjEu3szm0RqYZF9h2BueHCbStJZX3qFfNaGU5ex
	gLpMUPu5Izzxl5LboBO2dEZ9Dj1TP8+ZR8fo0y3a74ao8RMv8dxscGdL
X-Gm-Gg: AYBFou06ZLHs4Juh0fziJDMKucMvgb0ka/nM/WqCLD2iVmZ/47wdNPdVJQSvm9XTsTD
	w/7rxVPr4FyzTwEgMCsZ74ywyegZl0N/MGMd0fJQbmvelGwzl9wHBzSuA+QsqXmozTQFAYoV4y9
	lI3ehrqxmqPLhXpnXKkMiWMfuKK55VHUtZ9L/ZTxUw6r24+1rgCvO68HikNjTnyOe4Z3ltV6oWA
	HuSVudeLhM23zP4iraKRpgwry0bEMDMHutAej0jOnGnYlsefQTvHWe1NVfCE/7VA6TKd4barn6c
	J6amrah1gow3g4Ay1g1HLsCUzsrYw71/ySSZmNE7s79VgaAqECmVJ4YYI0ok+z3UxzR5YBN8iOA
	72NbHQ85gBZjjoiu4w8vrE2Ww/7/rUOPrLCY8yoR5bxhFZgYtcgzfQ1gp7keVZB24TYhN0OhWzF
	jMK7nVgBPkUfQsnOy8V0twxgYl1LhN8uE555KNnO/8651/GiWL6MFdEBZjHCV1mics0p5D6dVvO
	6BpGR27FoaCcQ9H/gHRJFbD4Ya4W171ndbiEE/SHjFTHqBANHaAqhhH+UdvpQ0OchQa+lwWMAcE
	yVSiROvAtWRZ0rxxJRrj0Nrh
X-Received: by 2002:a05:701a:c902:b0:1b2:6cba:7f48 with SMTP id a92af1059eb24-1b26cba843fmr2296822c88.31.1794070634776;
        Sat, 07 Nov 2026 08:57:14 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4b4aa7sm15456126c88.13.2026.11.07.08.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 08:57:14 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Sat, 07 Nov 2026 11:57:00 -0500
Subject: [PATCH v3 1/4] mm/ksm: align smart scan skips with the scan number
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-1-16d5ce8b5fd6@gmail.com>
References: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
In-Reply-To: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 21D7C20006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: shzajkm35cmwxhjxqcm4obd7ibe41deb
X-HE-Tag: 1794070636-4413
X-HE-Meta: U2FsdGVkX1+CN1rBlu3x/t52J290YL1iLYqjcD0yfDJPl12n8f7UxFOneBx/qSRfXMhiEjtiNqTWzdItKJmtxNhkBRQ1L905d9q2LVHLJa2gqdmfOoKw8p+MQ3QHjPiYLuRZkxP+eSh7PQSgtqEbdgvM8sgq0u05XzuiKqlfDeSCHI5QiiBC65Jf0bo/yq064gYD7voHHJlXoeAcZ4F5IcDFE0FCpk0gZ2K1bjlYJW+2sYF4l/NbvoWVpOqLWpRu31L4zPJsp9ux7SlVylxJLPwhMVztb8K7zS+aJfWhjFQi6DUyKUbbz0kFIbljQgUUh9ILwPBGGzPYbP0MZlIcHvER/M8LIm+3jnZuzkxGcPVsGw6Fmf2Y+Ku87xB5gg8nmDyRZety7lPENN3JL+Uzyw+PKd9BQcN0SimR0POH6K19iVfGmF7eH2vaxmrjoS7eoGdhnlhOcNH73VFP+kB/vA7S1VOETMl5J2jCSj6XDe56soni2g+Rk0vT3Ra9p1c7yE5wE/0wiQDs0fRv1OaefsbjaxWdfhucF273PJJJIF8RUWDHadHZ+iR1LORd8oTmfVs81iQElxhsVUZ4a+S5j0cI1zoKBUFLpuFW00KYRD/V7p7ZzhF29h8jKAjDj1yYYevqsb72zlGfzYgQ1rTGJT4gkNzvtMQi1zyyV1rSAffQDx2Cg19eC/8yQzRmW26qldRItFLn8UxgwlvdGOOyiclVvbQ4B4nuvgIVKmNh3Z4rwGLx9dAwIiihgjIGXgpcZOdtJoK46VDOgQ7WT9CcL10NPVsBvVUqotGs5fGxirx8Wcm46c04sXH4ca+33gSsmDv1WHKF3W0Oe9xmKHM0NHyB4hVz/voq1ydL+lVsZ9DOp45UmLsQQWgFqsIuYlHQJTP2n4i3I28O+IBlRTPY2sdZM79OaWwy8wiT6Xnz549QivoSEt+rj/ADvPq+tKrm+YcxROtOVpP99BehB1B
 00TxQlqu
 DFeIIvM08DpDGB3qAeL+8gm0AI8+NK3Lw2G7QOR8U25RWyap6GKdjiJbUiK/4X2VReeCl1/KL3RDT7OX1X74H8zvUcbYuuCrPesjQPAYWS2WU/Z4EQ+1iZzXZUj5vfA248Hd3yg/a4/6QvdgN+TkIUr7VFnAEaqDVBTfA8EysGk4T70LaGpVz0g3Ci4sioUOGty6SZ6CE8KUZRv5LQizYnl/qi0eQ0/lfGqtaxxanwAkjTr6k0JfwkqkvG/7X8kicxH8V+LKs5GBhPAjucB83AQ8IY+91+3FdLG1Re8HKlXRPsc6ecQBk9rEj5I8uq952zOaYvQ0KMno/2LmWD21ZX7fUAyGj5HQyRkQCWYmMk9sa7Ii7v1uaycWijeLUVksQ0NHc5zLzdKHNnKUPLXPQtxHNyYvGBrJ2Rwl+BdGOfwGOUqdydj/gfcLeVEYAbnJCFaMYA+93aUmJ3Ee7bRVfDQDfZNI9gpdgo38T/Rzgg/VHxt+bNCR0RDiNYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Smart scan skips pages that KSM has failed to de-duplicate for a while.
Once a page is three scans old, its rmap_item counts down its own number
of scans to skip, 1, 2, 4 and then 8 as it ages, so an old page is looked
at every ninth scan.

The unstable tree is rebuilt on every scan, so two identical pages that
are not in the stable tree yet can only be merged in a scan that looks
at both. Each countdown runs from when its own page became mergeable, so
two pages that became mergeable at different times end up on different
phases and, once both are old, may never be looked at in the same scan
again. They then stay unmerged for as long as they live. The pairs below
are counted by making a page mergeable, waiting for 0 to 20 full scans
before doing the same with an identical page, 20 times for each wait,
and checking the pair after another 64 full scans, on two boots per
kernel.

Pick the skipped scans by the global scan number instead, with periods
of 2, 4 and 8 scans. The periods being powers of two, every old page is
looked at on each scan that is a multiple of 8, whatever its age, so any
two pages meet at least every eighth scan. The longest period goes from
nine scans to eight, so ksmd looks at more of the pages that never
merge. The rest of the table is measured on 64M of such pages, median of
five runs of 256 scans on each of three boots per kernel, CPU time from
schedstat:

                              before     after      after/before
  pairs merged (of 420)       361        420        116%
                              334        420        126%
  pages looked at per scan    1792       2048       114%
  ksmd CPU time per scan      6.30 ms    6.88 ms    109%
                              6.40 ms    6.96 ms    109%
                              6.15 ms    6.88 ms    112%

Fixes: 5e924ff54d08 ("mm/ksm: add "smart" page scanning mode")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Xu Xin <xu.xin@linux.dev>
---
 mm/ksm.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index d24b129932bf7..3053b438e9c10 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -197,7 +197,6 @@ struct ksm_stable_node {
  * @head: pointer to stable_node heading this list in the stable tree
  * @hlist: link into hlist of rmap_items hanging off that stable_node
  * @age: number of scan iterations since creation (unstable node)
- * @remaining_skips: how many scans to skip (unstable node)
  * @linear_page_index: the original page's index before merged by KSM (stable node)
  */
 struct ksm_rmap_item {
@@ -214,7 +213,6 @@ struct ksm_rmap_item {
 		struct {
 			unsigned int oldchecksum;
 			rmap_age_t age;
-			rmap_age_t remaining_skips;
 		};			/* when unstable */
 		unsigned long linear_page_index;    /* for reverse mapping, when stable */
 	};
@@ -2457,16 +2455,14 @@ static struct ksm_rmap_item *get_next_rmap_item(struct ksm_mm_slot *mm_slot,
 }
 
 /*
- * Calculate skip age for the ksm page age. The age determines how often
- * de-duplicating has already been tried unsuccessfully. If the age is
- * smaller, the scanning of this page is skipped for less scans.
+ * Calculate how often a page of the given ksm page age is scanned. The age
+ * determines how often de-duplicating has already been tried
+ * unsuccessfully. The older the page, the fewer scans look at it.
  *
  * @age: rmap_item age of page
  */
-static unsigned int skip_age(rmap_age_t age)
+static unsigned int scan_period(rmap_age_t age)
 {
-	if (age <= 3)
-		return 1;
 	if (age <= 5)
 		return 2;
 	if (age <= 8)
@@ -2516,17 +2512,17 @@ static bool should_skip_rmap_item(struct folio *folio,
 		return false;
 
 	/*
-	 * Are we still allowed to skip? If not, then don't skip it
-	 * and determine how much more often we are allowed to skip next.
+	 * The unstable tree is rebuilt on every scan, so two identical pages
+	 * can only be merged if both are looked at in the same scan. Pick the
+	 * scans by the global scan number rather than per page: the periods
+	 * are powers of two, so pages of any age meet on every scan that is a
+	 * multiple of the longest one.
 	 */
-	if (!rmap_item->remaining_skips) {
-		rmap_item->remaining_skips = skip_age(age);
+	if (!(ksm_scan.seqnr & (scan_period(age) - 1)))
 		return false;
-	}
 
 	/* Skip this page */
 	ksm_pages_skipped++;
-	rmap_item->remaining_skips--;
 	remove_rmap_item_from_tree(rmap_item);
 	return true;
 }

-- 
2.43.0


