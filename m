Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E3F6CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B875D8E0012; Wed, 24 Sep 2025 06:02:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37D98E0001; Wed, 24 Sep 2025 06:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A274A8E0012; Wed, 24 Sep 2025 06:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC298E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:02:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 038091607E0
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:02:19 +0000 (UTC)
X-FDA: 83923703640.16.04B2079
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1A1A040013
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:02:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf27.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758708138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=/wfld7yM35iF4eykosNij+4fQzpSY4Hz4bM+X89HdJE=;
	b=YIEDq2Ssnw0pLFffBtLG/rOH7ymnUfaSi5K36zMqLsCmauHbeAKOVGlEXhJA9jKC06pDhD
	z1jG4uiwlLsMmnTTd/PQkz3hW9JLBZYw5rNqTe3tDIrSmAOjgoWLYKeEhcmMKhrsJD1sVb
	38nxYyapbrBif7Dj2AqZdwg0J789tqs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf27.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758708138; a=rsa-sha256;
	cv=none;
	b=T96UsQpa1+yOq8OGhNBCtSTGOd+0nLYkqjaTCNPUxKsXbqXxtPsPqLo8+6H5jsUPY7+PM6
	eY2wyCdV5Y32dtjMewlXlwV4KD2enu6SFvMXM9fXT6jdfQgf6AGKXKcF+T83xtofiFTFRJ
	0NoWtT70UuWmLgwhofNavr5mLwe97nM=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46dfd711172so25417035e9.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:02:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758708137; x=1759312937;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/wfld7yM35iF4eykosNij+4fQzpSY4Hz4bM+X89HdJE=;
        b=wbs40tZb1fRSflgOCptycHF5DcB7Ws12Rcx5w5WdFJKd/NbvZ2n3lzJgK81D9eY/rv
         Ag0LWVReD4+1VdNwWeO7ItQnxzfZohnsVVJeTaeXhgs2Yzg5z509abBVbJwhuFqHmK1C
         iT9YNJFOwSM7DerQlUqtWy9lRY5TH2BW7MKyWGowY2tUMY7Bm6qjCShg87tDe45OIaoi
         9lW/8ZWCHjHG7RftevlDOR3JqQyhjP67UZPVriJ8VlKWg1TpO7xSgnEIDG40KmqvIa3w
         ZyxFCwj/mz564exVVqRrKWgZjTpgy8W7kIYcMScUzF1wXZ8sgYXcoUusCWprD9ll33ty
         Cwlw==
X-Forwarded-Encrypted: i=1; AJvYcCWPtZhbMgXYOiBA4F1y6aE68L7j4mQDhLWo5YRJ2fdv7uvTk3aOWRmw/kjh2M0mIV4jcqxOdqgBCw==@kvack.org
X-Gm-Message-State: AOJu0YzywvrvTqcBPrEn7ixvezZpvDeog1br2E1vbPpsER4tXPeXNyS/
	AgdErZzJ+5HOH9TP6vWBnPLuVjOywT1+l71To19KyeRg8T7XcooSHc/f
X-Gm-Gg: ASbGncs9SuIj7qhg7OIH4hQyRmMJQeYN2fQkt1O64Rgd+p1m6mVVFeipnViS17tCGxa
	Dj+WndkSPi+2kYthiSWTnZ+/TcasVQb0qxi98xMXxKG5POUt5NfI3p7SD3fUcFWreOoSN66YgLJ
	bYMVo/JzEoHuj6zvK1ysAeZULfHSRabC5dmjru6OnnY6iZxfEuKtv4pg4D4q1SbybsQx7NrcgNo
	pSzVXLJb2xX5lD35+eMQ0eCgXQXtm3U8aIHXXFmn28M24q9KHY3Ondl/3aGqT4mpoQhMOCtcFEr
	p7Lvy6c7BXvsvqZ/yI8wf+g8+BgfbKAVaswYaoWPtQOjnNEPXKoFFxcaSzRNizan7HGCNMoXFZO
	itxG5oAPx
X-Google-Smtp-Source: AGHT+IG0l9FwrHr2FXigUei1Z73tk2/AIuntnaq3hCJrBsDnPmHcKwjEZkFDPT2mKtWHyzEy/pQ/qA==
X-Received: by 2002:a05:600c:620e:b0:46d:27b7:e7ff with SMTP id 5b1f17b1804b1-46e1dacaa19mr54634455e9.36.1758708136399;
        Wed, 24 Sep 2025 03:02:16 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::3086])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2aae3d58sm27644895e9.21.2025.09.24.03.02.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 24 Sep 2025 03:02:16 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	hughd@google.com,
	ioworker0@gmail.com,
	kirill@shutemov.name,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mpenttil@redhat.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	richard.weiyang@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new 1/1] mm/khugepaged: abort collapse scan on non-swap entries
Date: Wed, 24 Sep 2025 18:02:07 +0800
Message-ID: <20250924100207.28332-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rm8isz3fu38h3npfts4ka9rqh6j66mc5
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A1A040013
X-Rspamd-Server: rspam04
X-HE-Tag: 1758708137-681987
X-HE-Meta: U2FsdGVkX1/2tSmt0kfSl0zHJ29aOr82lvSp8U76AIWxEbG/0XfalcK9h++f0h/7ntOwjzoDL5OlrIyiLzNwWkZ0slo9InaLgGaCgN1740MR4BKGEXTAxGH8S4h1EBPwf9jg0pks9H3GpeKwB8E5oCGcwTLvivcc6MyqldPZyjL+oSr+50I085Rzcasb+TxMIUQZUxVDQiW5YZJU+ePttv1JhVYii3MGYbEgWsM772erJqtFPyNlVpP8lwa/DYU0xoW/dZIiTc+/UHgMkBQ8QKB9/Uw7MwgEaCQt8UEAxvvWW4czBAQDtK1KSuEnAm+Jv62sMM5tUV3FtvMI+kXsDG8klykq2Q4j/JEj1PP12uSczZ1wGoPuu8pitXqNRNRc247B8ID9lazY0sjA0htilnfjVB1jOTOR8qfV3GhamIBUNvD0+KQlB43lW/HL8/kIDnIpvVgCQYMb0etoJjM77dcCaG/Nmr0v6cL+Imt1BmGI7GakZStGwz2gNVoDZcoXxwjkDjv/DsoXmWaLkj94H4zlW9rD6VyvKvYaL+HAheQvvuZwdGlAi0V72uIKHzFZ4FGYdvjO1VN/ru1eVPqlvoiV2a3Ch8VakVOeHUJb+WlY6iLdv3fo6L+04+Og/Y8TuMjTGDfkEbJKWm3tGiuqQMEalZ/aj+8FP/23Oo6kRKzYRcVMRa+DbsrYi4mbbhPbmYTY44lV7IGUDfm0lK0CoKsUxF1gOQ8owj+DmzCPrNIZ3bHiD2xU9AGCXwdzdWvqnd7AcMPMPK/32mmalzIVi2KTfoCP+6PyiPOyGgx8aFFzqtOnic7p0PPAonVL0ojkY03+ug9APGxHWYmr++qiGQ9jJ0gQYdeT6sX9pwbnuDeCJMdJ6CCyjQSLDuRrdCsADb2pqLdqlIZS3KMpXVF0aag6Hx0WtxvFBRlNs6IhsVYqAyX7T+3g9ZBVBIOFdZafPThscPknW55V0g9hHeA
 ll597c6A
 FtZEuAIMYKjZNiKvpFyINR1vwKuUMtlLSw6EEnGJuhsbjSxZ7Uo6N4i8zHhEBjZ4jX/0G6KulWre6FJ8fLq/L0GWcfXJKADOT+53IxJAEwmY+tFBniON3tqmWWTCNGg+zD9XpKf22vWuzZ+IFapUuvr/IqVRtP9VsrAbFHfj/KB8Vl9PimIYEyvZXZ0HKrJcQAPaSJbEf+DpMtN/K50ZkR3u68tATGBjzMAxvBsyXnaBdbfYfssCddGaGbWyLSg8FjTFDM2gD54zX1X+E17f0cNt6hydX+24qW9l4O7/evIjNwM+RHBwpA8pQ0trhB3jjSTUjqyk3TvBY3Bw8klPJxhg0zAMmiKOiXiOHQ2zuM5KXiFpm7sNONwXoZwLUMGa4OVkuJMe95xCOTW8urdLrx1QlTSpuPTfwTM8ZlN/4dywoW2srEm5Msz5hG6ZJtDJi9KWeFV00VMhFV6bnyyKAmr9apBzE9eddxhK6yVUYO2q7erdDqY7xu+ARc9BswUUG9fzheQZ/ySAn+BPCR1OMbTqdB+ecuOBMPQS1QS0GgX1nVHxowh75g5t0TSVIb0KligiCrtmS23H7URnWdToNr2XY5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

The existing check in hpage_collapse_scan_pmd() is specific to uffd-wp
markers. Other special markers (e.g., GUARD, POISONED) would not be caught
early, leading to failures deeper in the swap-in logic.

hpage_collapse_scan_pmd()
 `- collapse_huge_page()
     `- __collapse_huge_page_swapin() -> fails!

As David suggested[1], this patch skips any such non-swap entries early.
If a special marker is found, the scan is aborted immediately with the
SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
work.

[1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com
[2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7ab2d1a42df3..e9778e7734b5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1285,16 +1285,19 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (is_swap_pte(pteval)) {
+			swp_entry_t swp = pte_to_swp_entry(pteval);
 			++unmapped;
 			if (!cc->is_khugepaged ||
 			    unmapped <= khugepaged_max_ptes_swap) {
 				/*
-				 * Always be strict with uffd-wp
-				 * enabled swap entries.  Please see
-				 * comment below for pte_uffd_wp().
+				 * Always be strict with PTE markers, which are
+				 * special non-swap entries (e.g., for UFFD_WP,
+				 * POISONED, GUARD). We cannot collapse over
+				 * them, so just abort the scan here.
 				 */
-				if (pte_swp_uffd_wp_any(pteval)) {
-					result = SCAN_PTE_UFFD_WP;
+				if (is_pte_marker_entry(swp) &&
+				    pte_marker_get(swp)) {
+					result = SCAN_PTE_NON_PRESENT;
 					goto out_unmap;
 				}
 				continue;
-- 
2.49.0


