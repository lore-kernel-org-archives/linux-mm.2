Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F15FC606D45F
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 01:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PXlBDSn3
Received: by kanga.kvack.org (Postfix)
	id 1AF236B05B1; Sun,  8 Nov 2026 20:23:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186F76B05B2; Sun,  8 Nov 2026 20:23:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09CEB6B05B4; Sun,  8 Nov 2026 20:23:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CBB046B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:23:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDB1EC0529
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:23:05 +0000 (UTC)
X-FDA: 85413831930.12.4146DC1
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1D9BC180004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:23:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PXlBDSn3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794187384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XX9ESCVfSBNTpp12XWWFYyZTazCHcyRRL6wSEZ9nPSY=;
	b=GvANPPqXDsEM315v+kqRPC5B5zUoSS1ip1v6BFXEhsJQW6gYWaHL5+mRX8OERX6CxKz/Mx
	HseH2UXxr96eZYBHGd3r/gRDoUGTTbHcnRbOmh5FQ1wGtGTThgutX03bbK+tMJXk8aVxHY
	iI40BXG8D/x3673a6NpFxLJuN2+slP4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PXlBDSn3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794187384;
	b=c1a8/JDY4XidxOYsu+s/bkonMyNusa6R6SD+Wb3o4/kTpNIXU7eoamZOoMvO3Y83p3uA1Q
	oMQag3lfWp/qsNbpT5VO0OWPvDSuE9HNUf8oxZvNdw5Uu0rEa7Zkn/cK6w6areybkKeriy
	iPsKgHV6kbOjYK8cbpkLZJnP4oM7zdI=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1b244fb7fffso364282c88.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 17:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794187383; x=1794792183; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XX9ESCVfSBNTpp12XWWFYyZTazCHcyRRL6wSEZ9nPSY=;
        b=PXlBDSn36hXJNJ43jaYDvp7r14kYqz8THQwBk1J6KZJS3UYFuqPFo/1qz3sLduHjYB
         We8OIvgsHOD2Hx0JDp5APVfivariznxkFeLRLwoBaLy0aYlNBRcUwa0o+BILxoV798IE
         jVMfyoFUEomfHjYqK05b0tSKeb2mJ/xt44l+hErMAKwFaPk9yLf0JEnR2Jh9KYTA0M0/
         NUqgMsfqk+ZFd7XQSvLAMbY3T6YfrEEfcmVh7oZA6F2wuEH8MJjkpxmXrB+GGaBUtEKO
         o2NHEhZfWt2/2eSEdiLaEELR91RoM4luxJXEc/lOdK/lj/msWhFWGyZRKQJChT3fPoVG
         R1GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794187383; x=1794792183;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XX9ESCVfSBNTpp12XWWFYyZTazCHcyRRL6wSEZ9nPSY=;
        b=BIg/OlZ0iczmtlhhKUenxUzOn/WFot6IQ4GoXqB7Y4Y9dXBvdD8Rqsjg9eBk4bF+f2
         GBjHoJlfdnY8mK/KgwZeeaooeDnnAeOUbsEt4EpOJU161m/KYSodL54KXLMMwjp0Q3i4
         mW/EenomiSr4/gJGJ1tDdnWLYKM/eNahneingm6YqTpS5wez0YdoaxMl0ajvnx3P4JKs
         ZQ2MW4UY2IdB+aO8WzSLb7YoGhIzcX6FVioR3Q4kAuq1B+ehchHRF39P7d8BZdTvgf7i
         jv376X6dXb6c1zja802fYEcpLhCENcLn7Vk9K6Sd+mP/Xmc3pixEFVmITKRqb8sLdRby
         6EKQ==
X-Gm-Message-State: APuU4Z+sOtPN0Z3BYu8pLaS9KEeRJkuiS17W3d2u06xGbkRzW5g/ABa+
	TPFgRQBU/aNrXaTVRYNGauX0+3kDkgYKuFMIVhIM1bkJZ3BNkX8455ZI
X-Gm-Gg: AYBFou3O5S+nM5NyexynXD37dxJTArA8Us25FiK0fm9IobBVlhQQdTQ+E6SDQvA/NNW
	mWSneM0tWR5oXtJjnGjEoridx2VMNsFPOXzDPBPmphKttpPib2GeQmRs0XqNaa3zvxuGbO6Xvlh
	whqur0DesqbASLLa0/ZBszBrNAzofUDWg3S31/IgIZKjtU/UHgQ8qnA8rh957nkF7bY4B+gaNOM
	R0/f01mPfNzQ4p9B94U2n81eSuGvUv3lu12ZofoZNWNe7Z0g/hASw/jje5iKvDqWGCoKDKG/qmR
	RZwvDLwZgMg3NeV7FTaqwfXNjc9asP6DW8WoedtT5Yxv7+zqsq3r6BdrJjb+pTchdoRzRi7kadY
	YpNe3weXTGCvpyxqEvXt3lWeby3tnD3c/HwrBknP9EKcQqA29q1AltzeSpaZKvNI00txrrKe4xw
	79gcHccO4NIC56AoAfcdlH2A6SDqS9T1Pfqb+5BjVn8PeAlIqhOYIyoH0t9Z+oGIw1V1gruL5Nz
	ElbHbvoFKFqyGxwGhZfv4g5JlCKIXGgUcscmqvfZbBjejBWfAljK4LsqeHYgnF/asgUL/giQOMr
	GCOwcrkr4ps1sraHC65VQrtq6w==
X-Received: by 2002:a05:701b:2306:b0:1b3:a22c:7f68 with SMTP id a92af1059eb24-1b3a22cb4a4mr3636286c88.29.1794187382778;
        Sun, 08 Nov 2026 17:23:02 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3771ea85bsm9428226c88.18.2026.11.08.17.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 17:23:02 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Sun, 08 Nov 2026 20:22:50 -0500
Subject: [PATCH v4 1/5] mm/ksm: align smart scan skips with the scan number
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-1-86be8fe77e7a@gmail.com>
References: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
In-Reply-To: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
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
 Qiliang Yuan <odys.yuan@gmail.com>, stable@vger.kernel.org
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1D9BC180004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: cz7iqtizrmyrpjdsy83wu6qpineancy4
X-HE-Tag: 1794187383-503667
X-HE-Meta: U2FsdGVkX1+wb6yBxZmRhiSL3YbHY8pb+WkoB6b51R2S/FuKZbsSigHKKVGbaIIQngTdACObH8ItHlTfX6pcIhvaT1+BwHcS9A/Y7OcUhVYma23tkJIeNYn+mvfX3ZQ1ydcyKsJVzyTP5Bgp9u582FCZdlL3epUaQb5oKZn/mS7yGQvSrU1rLSKzF7MbZOgKRaD3tBwwe5IJSymPMmzDY9nRQhRk4MsnR6kcEwZ41mE1ZNdVVKSMG8IJxmwJRZLtMTO1fad6Z/T4HPFo8V5Ttb2aGPbze2Kb4a1sBVGBfEpQUHTAoA3zAfJItDUizz0efOc2rE4lB4tQenB208bnoQbSqE5mF+koMLVlX1uT3CcyzrljEjBPMixRt4syeyqBgg14BurgcaTWUCmLu7NwODnjvUR94T/d4GlJ0dVD0Cu4OI+iw+mCqWXLmq+z+bqszNmuAJoe2hswJnBASi7uXnLSuBn+I2u/gP+qeM9riPd06bkR+say5LLLl35QfkE3tcUCXJZ+SKNt4/f+ehPaWRCr74WzLpexnHKKM8ITWJEYnnZ3I0rDue41oBzkdJx0GoBugxzAzk01iu527Ov2lXBx7bnAXrq9sPx6JrCZmJSh/WBIRwkO8pyFQqtQRvhtVdsO+LgribbpnPyc1qeTC9gfwrd0cS+yhDd8QHukAvFP38MbQNNZfAyZHuPfHcIhHLPuKAQPQDfstpj2SXAfDhQHi8Y/n52biXcBEReWxZaoDyUog0XtV0VmN/Dxformwa5DQbZRByc4hqIuoZ/cb1JkkKcFC1/bVsYfHVcXmSOmA/6WyIxK19pZm2gV7LnE7Cpi7EwaH+HNhGoimu9N33Gw4mEV5AgVRKR1ymcMug9qo5+jdzFOXmgCWsT9Tdn919hQH2Vz5qnf1B/qyWnpWu7GPkkqAopgNUka0cQQh/XfaYk1Nf7whTEmhsavgAtXX6P8giVx3SBYqlu2Vuo
 LO0R6DHe
 6nkvlYtZEvwOF/pmDj6ZuTotyxS0ZxhHxW9hC1sgiO8fNeewCkdSOxyrizfiE+FgeVkcmSZILSYD8sr7flDq99N6UghO568/uEjM2URxoe9IDa4ZCTpB6hdPWgv0bShR+ia4y/cdkwVzLSjEf5RivlllKmJ96mQ28MgMY6IrNms5bGflHDZJ9gjMltH9GVUWiUxQTSAyE7vkS9JlbN2nU1iuTuGCurZeg7YJxU3iv4CUq2oqAcuQAvdtfg7zcn8qCvAEeCiA+C1gVgsnRBdIbuVruAfQNMvN/cTUw0sF8eOMeNKqFIXxtmsIkJf+orXTHKIL9ho4zK3aMidmLCKDl1ypNSyWPJLSS51Jwic9e3+MeRn189CPqZ9E1t5XQ0nNuUSSBQ7lffN5OjFal3pPfyN54qSV+BDdwDcsoRMtIcx1UqvdR6h7AN9afIfeTSzFDalscGvGlwqsPq43245THCf9b7QE8TyeEwHT7RQDu6vBOPksGEvOJ+bWZKJIZM3hn/QPVDYVrxKVLu9FB8U+NT8oZLn2GUXX3Ur9iuDbfms6shVTPFyOu/MdRO6y1xD9KT9EsISeb1lRg8L8=
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
Cc: stable@vger.kernel.org
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Xu Xin <xu.xin@linux.dev>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
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


