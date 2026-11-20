Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B84AF606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 03:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=d9bqzlgy
Received: by kanga.kvack.org (Postfix)
	id A878E6B06AF; Thu, 19 Nov 2026 22:30:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60466B0714; Thu, 19 Nov 2026 22:30:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94E426B073F; Thu, 19 Nov 2026 22:30:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9496B06AF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:30:25 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18C78A09AD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:30:24 +0000 (UTC)
X-FDA: 85454069568.09.00D9393
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id 39A3718000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:30:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=d9bqzlgy;
	spf=pass (imf16.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795145422;
	b=kF9KxKKpr9Np8NLMYqxADzKDYmZDNF/p7NohgXtU/mDHpdzsRNUKaUpkVB4IjpMJUfrCZ6
	pJAF0Ocr1uj4daBRJ0xa9lIOLUAlSsdhgNW5UQ24YRbc4SXpqfpcVAiM333Ec0k+HX/78j
	kQR0nb8LITZrYeDcg6EbGXPQMYj5Vjo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795145422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4CRmLsM2FeO2FoUhWeUWlm1ZB2WhalSLCCny6IP3jc=;
	b=ZTCa31A0MD/kOCGx6pRwaLdD43ZlFldzTcW3/Rp8g3Kz1stsCOJ6fWFXHItfe7jC1x/kZW
	iZkN2skPUB1COM7YhX7CSwo142tdeEH9ODcovDeJHHGeWdD/r2QNoztrXi2OYxNG8l826W
	JSrNuFy0vuBDMw9Ehd99M6K9dsXgzCw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=d9bqzlgy;
	spf=pass (imf16.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-36f936424f2so85734eec.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795145421; x=1795750221; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G4CRmLsM2FeO2FoUhWeUWlm1ZB2WhalSLCCny6IP3jc=;
        b=d9bqzlgyEYQbf3DhCFxVaihSRzQpWomnDMVqjYPTXSd5gZlcAf43i0lrO7O/uzj3NC
         JXN33NthE3PsT+3yfXBDS4yAX68FY4LCRPnqjC0YHdhHUMi5jEXooGQEXB80FJrHQlSp
         Y/qxRXbUlo1FwrW1WLfvVCFqEdBsJjgLMQhhhiLBmygQq/StbphnRlJglrYAiD+/GcPe
         ApOJFOKC4G8w54L6npm94wc3op9do0q3hQ8MNpzH6HfP+4hpcGQYSxslXx2NTpwk/Za6
         LuUN0QbiewdHPPTJ1TF9DwjQ4Pk/bFLGUo8UGxaY40GIItQMCvl5E7Ta7qdwfAQIXB9T
         2OZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795145421; x=1795750221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G4CRmLsM2FeO2FoUhWeUWlm1ZB2WhalSLCCny6IP3jc=;
        b=eaowLqmkSdAdmg/uCF6RZQsY0nAnU0tViUIqTtlK4wLlsvXhl9rbJ8h+BFVegDnXpr
         tnMQjvgANTmmAtzgn0Yjt4OCwKzo77sI+60C+8M2n1FnhnKIT4ZDsk/JplE8IxBGge6u
         i9bFQ8P5AlzhKt9U69uUsWsk9CowtNpOX0yKwiMdGhXXh8WvfTYeQm5IH5zqSMiSLFbR
         90pGwaZh1Fvavv1en2kI6UfNzr97KjtwQvEpWwgRiLg6Jx+LL8ZDyktGPFiQuGr37AQQ
         6R59dFQYo1kDhbvmMc+qcKaO5WmQxi3UaQtdA5AkkgMuGdY2sBjNz3wP5eBcmiDV9q3t
         CSHg==
X-Forwarded-Encrypted: i=1; AL+hErFPCc2rC0/JWFhMhT1W5X3q/d1kG6Ell+eFXb28Wxuu8wOrWeFsmnvW8egtVkxEQ2Amoeqw6ZWjWw==@kvack.org
X-Gm-Message-State: APuU4Z/D4JaKOpv75NuGajFT83EsN/MxYd1+3E2f6Sg+qs2WVB51caV1
	AIll4jep+91MNubqJdFrkeDfzef12jkQ6mWg5rv29XHQboWbNRYdBOn+
X-Gm-Gg: AYBFou0ZeJp5efHsmU1eqJEVqX0OpMqc8cl+6WJFZSfeP8jHJTVrSzde7vaiHxE11zt
	Z+BArlNaceOoWu9hUgJ8wJSXHwWJ+3F1QtIeHc3+LMIluKvTa5Td8+3NJJhiBMkEa/lq73s91Ba
	GtLN5vvr1TsPaj3M93eu9B61X77/i8/+KmjxQbnHOWsfe89bc/by4zkGtCahNtVHypBux0AKWY1
	3N0wGN8oAPTcZQKGYTRHKYv2xRCJ8A2825jy7QahSHyUI3h5dhyWLIRQp6Z0dTUdQm+3TpFc8Ib
	d4vA+/7Wt7V0JA4HZmG1lpDVFpgG9+owZT6LBsUolvo7NoQzmIOs2a6ZuHY9a6t1WVKc7HoCz50
	/etSqN5TjEI9FCG+t8d4X5Tc88fiBpL+fOflfBEDaMwoLWL7tJWzmjtD4gF/X7fg5k3Wxz1dbtH
	LCRc8UQbD+2BsvwWgBvnrCn7lBFSIRgdJgOsFfJQ8nbL/whigZOZUGi94hk/cfmXwtKrU88ktHQ
	XRoCPUfQUZ5Lu1mXBRQtgezF8tLz43k5l8OMKubPrA16X+KXBi3Lu5kfFUAK7TZLcyQF/qSHOKU
	s5HANPTSeGwMfriXWqOVZ1XATOevio59sjrScVr8Rg==
X-Received: by 2002:a05:7022:1187:b0:1b5:31e4:9970 with SMTP id a92af1059eb24-1b55689ee2dmr1602946c88.8.1795145421007;
        Thu, 19 Nov 2026 19:30:21 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567e644dsm4362507c88.5.2026.11.19.19.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 19:30:20 -0800 (PST)
From: Wandun Chen <chenwandun1@gmail.com>
To: david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: [PATCH 3/3] mm/migrate: batch PTE restoration for device-private folios
Date: Fri, 20 Nov 2026 11:29:49 +0800
Message-ID: <20261120032949.2036731-4-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261120032949.2036731-1-chenwandun1@gmail.com>
References: <20261120032949.2036731-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w8mcqp751kmpzxm7fmp7ai3zaj15jib1
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 39A3718000A
X-HE-Tag: 1795145422-356857
X-HE-Meta: U2FsdGVkX1+D45FgYBk+uev0ZiVZzKz+G+VdQ6Ni69UEChYvOJ7a5mS728zDWNeQ0kR9grhPkk1rLNAS5WgjzLIpB6DtdMOptOjIxSINmTTk3U8X0UEO2TdfgoRhC4vezsohfTnZ3igrWz7G6IFNR5y0sxBCkPfmPAqrEHGpDIIDW+cDSytY6Mi3fPkXHEhlz35YYXf+SMAUytWdcxKSrGxdobLnbGMw9jegkGvzZCoq9M5zkV98L/TxAAUkytCJLt0rOl2akeKIcoQOKuYVbGVD95tugaTJPGtwiwiZRDVhYHVzDPFm/JMF6+ueCOhBRMjIeZfNb2PegcaBKDcSv+uI2Na7PyDXryh+K+sKPBpS4/HgKa54mK0Pb83Wm9zYqvz8YbKuO5TkBYYQwwLqr9QHM1gMaKNubx/W3BHXkbmzhljF+WTTON8cex4390aul8zrDrGZofu04Ra7e/DfI22Js7k4yWg/Z5BXu7WifiHhDUAHbx9BWAuDlqbaurei1Mfg64TVFu7sqjmqjp8js2HCj1+2XaR/DhHhIWXdOxOWDps21PEb0nrWV6HEQe4HgHxO804ESkFGpwjbueAj1zRnGsaXYcSoBQvy3bGM3FWQqTfl06NMI1tDklJIydVfy7k5GavHi3C2MFc7g/g27EgwwHPxT0XzW/Rxn+PRWWa7ZB0As8aK5PMtTIiHJrd9nEjsKwvogiZfL4DBXtmXHytRnHRoeE8/iYkgyzPy8AQ+lAQikYJq441uv56M0nSZEXRoz8sPUnCHoZIYqW8jzzq+lWY+N3Iy21f3cT7mKpfzpSdr5IKhLJqnHjW7Nzk9wN+rODnfgyRArzwmpTiBtIeFtcZZYOlNIdvbdtsYb59dRx0JJH/zV4P1m9ERNM0J/iLOY8U01BmKG2XIBfMBPnu9+1r+MVYEXk5uL5TijQTArTL9OWbMZVAI0zVehHrSBZyRNp7B+idOgJ+7vDZ
 BXecV64P
 LQA4+WcnJnnBpCutIMCoGzzm5J6BGNs6OmWsVZXrvMM1ufQIEtpyHw7+1n+J2J8ct4sQ3x3rc29Zko3BLeQ3cXVQYz7jcYtODxW7KZL9EgW2ZyRX7w+nghwdMQ5se1/9rifak5DGHAcQLyItNaYd6y2Wj7YAAwnOnPtOkboaLqBf/y67S21PDKUnnLUtju/wa4mdUbSgQjUrvbHycjS/tsOnkgZWBEoqb3QQjrgm3ToWP6pOUJvmY9ZLDbBpDU++03/uFM5ZZLz61quQ8PrjoBU1a+q54C9q/tJ/NRxJsiBiagy5wjin1edODPdtSgNy95NwLFlWjnLsHcRpcVygsRsDoqg1RcR8aaUZAPrRRYXNE7yCDY/4VdV6K42h0qPFPMmHHjuK8c0KmvKnBlHq8BBEOI2vSEK5Fatg+6S5Mc1KBXjrFoNxZ9RYbwRaTwSJw8WtU4iPYAjziMAUzphUoAbU6eEL8l3K4V6CdvBIqKQSx78J779oHIoKUxia67SXndcjEAM5j3gyfVaMnLRXStJASV5g6Ginswi2wf+cmBHWNddDSZ34qVIT4S2VLJ+++9rS7CkoC1h8maumuotuBMx8DggQXlfVaKe+XgAZvDjkQJ1O6IRO8lgOdv9mcWQVUtQFuQDLb9w9Mt+U3iIU08s1GEr3Y57HHPkOMdFg6N66lTzYuI4HbEfWxXwSCO1TNyi8rGJs/Yc9PT5fHwMzzEXdW2vcO2v3ni/cwzzSypVwvcZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

Device-private PTEs encode PFN as softleaf offset. set_ptes() does not
handle this encoding when constructing subsequent PTEs, such as on
arm64 with a 16KB page granule, leaving device-private destinations
folio unbatched.

Add set_device_private_ptes() to construct subsequent entries with
pte_next_swp_offset(). This enables remove_migration_pte() to batch
PTE restoration for device-private folios.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
---
 mm/migrate.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index e000ef77ea87..3d3d91fd61c7 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -345,6 +345,19 @@ struct rmap_walk_arg {
 	bool map_unused_to_zeropage;
 };
 
+static void set_device_private_ptes(struct mm_struct *mm, unsigned long addr,
+				    pte_t *ptep, pte_t pte, unsigned int nr)
+{
+	for (;;) {
+		set_pte_at(mm, addr, ptep, pte);
+		if (--nr == 0)
+			break;
+		addr += PAGE_SIZE;
+		ptep++;
+		pte = pte_next_swp_offset(pte);
+	}
+}
+
 /*
  * Restore a potential migration pte to a working pte entry
  */
@@ -442,8 +455,7 @@ static bool remove_migration_pte(struct folio *folio,
 		} else
 #endif
 		{
-			if (folio_test_large(rmap_walk_arg->folio) &&
-			    !is_device_private_page(new)) {
+			if (folio_test_large(rmap_walk_arg->folio)) {
 				unsigned long end_addr = pmd_addr_end(pvmw.address, vma->vm_end);
 				unsigned long max_nr = (end_addr - pvmw.address) >> PAGE_SHIFT;
 
@@ -463,7 +475,11 @@ static bool remove_migration_pte(struct folio *folio,
 							 pvmw.address, rmap_flags);
 			else
 				folio_add_file_rmap_ptes(folio, new, nr, vma);
-			set_ptes(vma->vm_mm, pvmw.address, pvmw.pte, pte, nr);
+			if (unlikely(is_device_private_page(new)))
+				set_device_private_ptes(vma->vm_mm, pvmw.address,
+							pvmw.pte, pte, nr);
+			else
+				set_ptes(vma->vm_mm, pvmw.address, pvmw.pte, pte, nr);
 
 			ptes += nr;
 		}
-- 
2.43.0


