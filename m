Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83BE3EE6B7F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 08:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6296B0093; Sat,  7 Feb 2026 03:12:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E605D6B0096; Sat,  7 Feb 2026 03:12:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8D4C6B0098; Sat,  7 Feb 2026 03:12:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CAB306B0093
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:12:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A4EBC1AC1
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:12:51 +0000 (UTC)
X-FDA: 84416944542.24.2508F87
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id 929C280007
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:12:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M/5iBuqx";
	spf=pass (imf30.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770451969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRPloOPmIvdTkQu3q4j2KYKMkvQYHLzGzqGMt4kDAVw=;
	b=OySlELvRmc25Yg7ZIebykRFg9fzc+Xh0uIV4IDaRpt74KzS7FqXXyA05SU26hbV2w/YCAv
	vysWyBVGfMKGz/w0Wls+isLl6XcaIDXNyx7p1TY8pW4oW2IdC17rBYJWUE34KXromr90dT
	G1+QsakOvmADTVebo84zBZ1XdPJu9A8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M/5iBuqx";
	spf=pass (imf30.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770451969; a=rsa-sha256;
	cv=none;
	b=BBj1oWNOUFpzyh644HdK/CELBNa3Y9Ri1BPSuMM7wxCdQdKnxJwvT0UmZBuPJULuA8Ov+R
	30KdzgMRvLpOBU4SEVKreU7rs4lAZduNed3jHWKr4Ht9LBdP8TYReZ9PGkFPF17q5km6N3
	+YQS2h31H8bw8LAKo0IfTt4JBA71FVQ=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8230f8f27cfso1295222b3a.0
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 00:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770451968; x=1771056768; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sRPloOPmIvdTkQu3q4j2KYKMkvQYHLzGzqGMt4kDAVw=;
        b=M/5iBuqxi0IeOwYgUSvMA22LCeX7HHt26tY7X/DesHho4r0+MO3Sv5E3zOpE5+Rc1j
         oV1vUmI8ofmg+Aqgqsou4KiFlfpWeECXKM5lzSR9rmRoyQKIHy0tfczD6XFg+nNc7sOJ
         YLEjziF7pA7IL1vuGsdNkPIyG36iB/LyIFbcC0c6287RGiDJaRkI1xPT0KAACWCwa9z/
         54mAdkR2Zi78wEZIv7GkVVouS0T32TjIQECjguGLYuagD0NrjnjNSxSjU0JFd7nRmnn9
         ZE9sLyL/jKNdUenWYNZy59Al5NT4oNvEhSuP14pW+CkiLzUTpM3m9uN6UWWGxStTVqf1
         nNIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770451968; x=1771056768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sRPloOPmIvdTkQu3q4j2KYKMkvQYHLzGzqGMt4kDAVw=;
        b=LKMWjumWAr9o0cOUJW383WPeIslmt2FpUu+0KHA9m3NpUZ5J4l3s07xwKlsEswiZZ4
         FyQ4cXIxcMDZIHhU3hGEkupbfr2ThsOfpqFg6DQogvNSe+Kx89WyrPGLTs9iaRzgR4sa
         JgAQIL1fkYVbJ6CFJ6sxlEU8hRGf6amwAsEq3nwK2gI4PMLTIEtH4uMq3mwYCk18V6TO
         bvuNCiLxxteG61Qob3dSa/a6T2+WpPSLWJ58ie7Y2iS8Yz+P+8EltAREr1BqamvwmT9I
         Z9dMAfr/L1RStXr1zVBvmsSghzPTmWXa3cAT2D+veUjFok736MTTXFQ7stAlmHoV3Ved
         s+tw==
X-Forwarded-Encrypted: i=1; AJvYcCVwJWAGs9TLWYycD41GgDikez9YWPhSmWrCekhU4aYhMkeYj3LnP13+3yVzz/Xvc0M80BGfbyF5BA==@kvack.org
X-Gm-Message-State: AOJu0YzKyT3jPvbLsZxZJ7FYkMc/EURvWn5FIgjICH+WJNpZaAZnrrck
	I66wbdygFZuVKG89Lc3f+agjhFqHhm3nPIbqehP0svO60GudwSsP2OXd
X-Gm-Gg: AZuq6aIZTFPcokU3cckrCUVgtNy/qK9f22SdSQKJGW1tQpFygtbc3UJaPS4su5GsYmO
	obVpTdnwQpvQv8yScA4SdUDa2huBHlFpjrmUE0TbZ9+KPltDET5ERojVW/fAm/4Ee+Sxiyiq0Rb
	WqyWrychUQMsAwCbanVFyPlrFYJegh8U/5vmYWW4/Bpgu5RI8Sqxtkr2yZKpNLYIRZjMMyGLJ0z
	XpPy6GiH3Ho2lFZr/6oMSA9794PZOkwhf9Tru+EOi3hzYEZuCSGVzrHFGg4wcMq7g+t+TOO5Dyq
	BF6u9dkQMPVTpsu/fn6eYMKiKD3mH/LgbPGyVV6G7kYHr+bw4qtD7qNo4lHLLGEXrxnDc0hcdjn
	Rqkw7eF2z4My8jed/2elVf9fkPjmEykHxvbj5yvHrjJ+O2Q/QbM1qq0SFbWQc1rzK3Tabvphs7o
	LWrgbWScOP7XguMy1Fw7qzrDONilHjsjpXrA==
X-Received: by 2002:a05:6a00:349b:b0:81e:b2ba:5b3a with SMTP id d2e1a72fcca58-8244160a918mr5234998b3a.8.1770451968398;
        Sat, 07 Feb 2026 00:12:48 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824490442cfsm3951466b3a.16.2026.02.07.00.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 00:12:47 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v7 4/5] mm: khugepaged: skip lazy-free folios
Date: Sat,  7 Feb 2026 16:11:43 +0800
Message-ID: <20260207081144.588545-5-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260207081144.588545-1-vernon2gm@gmail.com>
References: <20260207081144.588545-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: wn4kay7phudsgad88fxogme87zdt1ot4
X-Rspamd-Queue-Id: 929C280007
X-Rspam-User: 
X-HE-Tag: 1770451969-872883
X-HE-Meta: U2FsdGVkX1+yCZhWDmXZXsLJNOpCrPLBlABA++Vhfmui1qS2sT6cxe/z9+7einXOLCZSfbhL7DIuWRpyU+CKea0hJthGjIDhw62NrvGcQakfHl2p4Z86G4zehF3JRqCsIRajYJ9O/haiDYEB71rV6TCXW8IbmYFR7+/jmA0vikL8XkAZS4N5THO9aang0y+TGIY+iKTxaqO6BW6e4QxkSHav9DBl0PwX3dfGihaZJcOOvi644oo6zs4ahilPNBFlYzPHsVQuUkD1psWAf4fsj+WWRpaOZguHeai1if5bvdyR8n1DRpUY0LONcsnFPCFtl5UE1JKGNdTAl0RV2HsYWZXoo+/S4z45vX9upWyNgOpnu/cxVZd/ZY0gQth+ZhPV1O/lSDT57KkCjDI5W0KlaG3OSOMpjsySVvpO5qobWFoNaebA6C8rsRAfEdadUOcwCpZaSYLkikq19h8XAOWvAu98266G0QvpAYwZoTIiH/unvc7baT16Gp7aVx1zOwqWOIVgzf4Q6eiQKWD38tH2ybkvHdpcgcBF4Ot+FddHlF8wtnWoVyJfuNRidDGZdVPnd7BwAhHfv/KfyaJ0n7OWWlqDXxpPAfHiCu1WVVaj+akV+a3uTQY1inoD0+uX8BzsaRrI1iGSwtqDDAWRPvjrW7erUy1t2TRJP57EFkhgTwBi8KP8D//pAakCnNzdrdaWVj6WSfcjdLA9jIQXMomRw/yTNLsZWzxonXN8qxqw+msNKLGFRa235icghjfEfgW746Ex+NE8OJajca2ROG8+7S2NvoUMkJwcQr+PpBXGwMKte1XQX8yRvMFJIxSotYAkVLT0SCZPBuL0grVwjnN4xTKM0xXatkYIEx9U6LH/JaZgpIk4LkQId2HoBjlXFXkJCfKPRF25wJKBBl9Bvxonw7rBl2WleTyi05V+wwBykYFQ0U7Hwc6Pt1w2Wsu9MY19oV1uAVh/3FARAIPzB3Y
 eJEisxvt
 cUPtSLfClEEM0uoDERqrMLslTM4kzLee/VpkxlAtBKPYSGBtXx371PjDsYj3x2RucBptf5PInMlopowNSqR9p9K7P63zZg9OIBHhOrrbdEMi3YK/cKBrk5bElr1Vc/nooo8IrW6AdfeO6tx01edqi4lvsJdGFhLNkNbAecKDYvk+8h4GYKrOO1F6DlXBYPeF0erfWo4+6WUU18+7pS0TWfInIYhwsu2DW5R19vr7p40PWAWyX+0tdKIQHmMbJanjBHcKipoUxxS7Pqyp1StMNUQKCLugTLxgEhNL1YKC48g2yVU52WPunUOhFjJJSaZjbQBmXpLsAT7ZEjf551LgRMUQ7KlE2KYlLWYCQl1ZLoGYFXbzfkznOP1NZZZ12pQQuefZAdRKwWVz6Tj/ZM0Q3uutNI3q16pPt/pdoCFAAYDDnozinh7E7rIf6bqKpY1ZFAGQgADkMVDBNK0ai8XCk+wNdd3zJZC9qWP8SjLAcO8cEMWDt7RbLL18S3gjA7fU0LLsDyU3cUUXGJMA1D10inwegtn6bcKJqN1ttMKYAefSSFWWZgvTYw8O8bSiVGnLpqYGu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

For example, create three task: hot1 -> cold -> hot2. After all three
task are created, each allocate memory 128MB. the hot1/hot2 task
continuously access 128 MB memory, while the cold task only accesses
its memory briefly and then call madvise(MADV_FREE). However, khugepaged
still prioritizes scanning the cold task and only scans the hot2 task
after completing the scan of the cold task.

And if we collapse with a lazyfree page, that content will never be none
and the deferred shrinker cannot reclaim them.

So if the user has explicitly informed us via MADV_FREE that this memory
will be freed, it is appropriate for khugepaged to skip it only, thereby
avoiding unnecessary scan and collapse operations to reducing CPU
wastage.

Here are the performance test results:
(Throughput bigger is better, other smaller is better)

Testing on x86_64 machine:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
| cycles per access   |  4.96         |  2.21         | -55.44% |
| Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
| dTLB-load-misses    |  284814532    |  69597236     | -75.56% |

Testing on qemu-system-x86_64 -enable-kvm:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
| cycles per access   |  7.29         |  2.07         | -71.60% |
| Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
| dTLB-load-misses    |  241600871    |  3216108      | -98.67% |

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
 include/trace/events/huge_memory.h |  1 +
 mm/khugepaged.c                    | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 384e29f6bef0..bcdc57eea270 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -25,6 +25,7 @@
 	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
 	EM( SCAN_PAGE_LOCK,		"page_locked")			\
 	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
+	EM( SCAN_PAGE_LAZYFREE,		"page_lazyfree")		\
 	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
 	EM( SCAN_ANY_PROCESS,		"no_process_for_page")		\
 	EM( SCAN_VMA_NULL,		"vma_null")			\
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8b68ae3bc2c5..0d160e612e16 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -46,6 +46,7 @@ enum scan_result {
 	SCAN_PAGE_LRU,
 	SCAN_PAGE_LOCK,
 	SCAN_PAGE_ANON,
+	SCAN_PAGE_LAZYFREE,
 	SCAN_PAGE_COMPOUND,
 	SCAN_ANY_PROCESS,
 	SCAN_VMA_NULL,
@@ -583,6 +584,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
+		if (cc->is_khugepaged && !pte_dirty(pteval) &&
+		    folio_test_lazyfree(folio)) {
+			result = SCAN_PAGE_LAZYFREE;
+			goto out;
+		}
+
 		/* See hpage_collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
@@ -1335,6 +1342,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		}
 		folio = page_folio(page);
 
+		if (cc->is_khugepaged && !pte_dirty(pteval) &&
+		    folio_test_lazyfree(folio)) {
+			result = SCAN_PAGE_LAZYFREE;
+			goto out_unmap;
+		}
+
 		if (!folio_test_anon(folio)) {
 			result = SCAN_PAGE_ANON;
 			goto out_unmap;
-- 
2.51.0


