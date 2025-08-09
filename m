Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E0AC87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 19:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3A5E6B00A2; Sat,  9 Aug 2025 15:42:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10706B00A3; Sat,  9 Aug 2025 15:42:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D5B6B00A4; Sat,  9 Aug 2025 15:42:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B4A766B00A2
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 15:42:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44859B7BE6
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 19:42:17 +0000 (UTC)
X-FDA: 83758240314.27.2187399
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9B8D940005
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 19:42:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jL7T0+CA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754768535; a=rsa-sha256;
	cv=none;
	b=3BlkdeIzWUWTr0KZ7nnx6m7QPLtwRUkP91/0oNLfVz1M5q1Yit574HOb6OVtX1+uEhZJGH
	QdMqfj0i7jLpAbZYKvxCCC028KkqCmOlnbWw+2buwgITWcHNWta7CTs9s1wGZUdgO0imap
	J70kX6AMOlYQ9ores4zZjK4lFx3LRpk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jL7T0+CA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754768535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Ic3K7UCH8w0cHNlR6jBGkNggzwSb+Jje246b5cUnyGw=;
	b=ueMoFy/nULfs31gTRg5V8ITjO7/Tc7ZHXpUhhGTyqeW87n8ZN209XdwsTjzbzpIWahz/WG
	cJiFPb99f09JG5q06lG+NgMTlhmuNS45fi3eVknIhemC2jX1s/IT+WuSPLF3uCuEeyxseo
	fzfDAdLu44RMxRpK9Pl+1QUENK7y3xg=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-af98b77d2f0so596826366b.3
        for <linux-mm@kvack.org>; Sat, 09 Aug 2025 12:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754768534; x=1755373334; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ic3K7UCH8w0cHNlR6jBGkNggzwSb+Jje246b5cUnyGw=;
        b=jL7T0+CARQK8F7bNw5NtUzIejN88N9iFmPiIovwXbozSo8qa4bDPBKbS7OlPcMNfMc
         1/FvdUhjjWf3vWMl14lHhYlNuTXC83UMw6YXv6BbAgFggwQj0mNjJr91BvSvJ2G+xyxb
         Nrdmpz+l49beN6elgTE8gZLbRYjZpPgHQAjxTGHId2eub06asTqs3ggZ465yzvI/7e9E
         0VR370YjUNtz71ZUFUbgeIoKvJmGVDwbZq2SYeyI1eXUZOfSHXRhsc5i8AL5m4uYkKv1
         AByXQnBm7UAMuLwH9EHzRKAro3k/Le1ygzZyKy45emqOTYsHSinLWwjZDtgoy+RFCckh
         wa2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754768534; x=1755373334;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ic3K7UCH8w0cHNlR6jBGkNggzwSb+Jje246b5cUnyGw=;
        b=EFSH9ssxAe4a+M4OHhtcAM7f+0DYKmtAIGY+u0ljSCSgBAjj5fqlE8qr4+Nn/A9OvT
         BR3A20VWV6/HLisiD/NSuaI0AEpf3eGYVdRkhmi1f4fDAtzkC2HTpvV8l6fkXGy4wbhx
         uXz1SerfcMTQhCNEN5DxN2vjyy04lmNCV0+bdji62/rAOVHxuQxvI6ocgspfO3mV9AxB
         sTmCpussoTQFCNqDftf1DqFys7NwA3ugI/ost9R4oTPq1n+hUSnhWJYVzSo9kxJ9TAvT
         J0NeEdNQ1vb9TKbRki1LQTLW5OJKpjCxPTEWZAozvGzexJ9HCEksSzJBJemq9EGkE9Ol
         Likg==
X-Gm-Message-State: AOJu0YzGLZTwejZYfZN6XjVVu9C7+FFGhZy0Sdr38tc8Uw2CIWSx+WmX
	+c2pJHiLvnzAErojMNKaUnc6IjcNuBmviGrC6o1w8qwDOXc+66XF3AGR
X-Gm-Gg: ASbGncvzxPfbvS579CZwJAX40NU9RwNrL2a71iUEXjgy6HxzNJdXMENl1txMP4VtOcE
	J4a2mvbtK9BcUQVhEmrKRWZtQ+lPfSUZrKh/EUg91jgwm/EOQDmz+vw/EfHMhDts2dTtvm7QFc2
	0CmAn9GINCGMwCDfVQuANuXaza0/97rA4xOroiMbseaTYWLCmZ5AFVRZV8JjeyUhis9bZOVtq8D
	7ynTUPb5XQYp2+j45dXqTg7kEpQiCuY/94L18siP8gFg692Jqa8Nv19m0bf2cqcjDdlkBfWwD9z
	YAOZROw/RMDQuAGn8o4HLOUlTEx3DPg55V228IwuDbJypllzWONUQOwTOuO5WxcWwozOuTh0r35
	CVtggKe1vH8FCmweoozcOPI83nZtfDS5l
X-Google-Smtp-Source: AGHT+IE7x1UXlTbQaKb/FHpNY+rq/S0rmCS/wR19xs1S9zT+TQJ9dYKv7J4ktAbnBOq5oVMDmgkn9w==
X-Received: by 2002:a17:906:fe05:b0:ade:4339:9367 with SMTP id a640c23a62f3a-af9c648edcbmr748294866b.26.1754768533931;
        Sat, 09 Aug 2025 12:42:13 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0a3361sm1711636766b.39.2025.08.09.12.42.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 09 Aug 2025 12:42:13 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Donet Tom <donettom@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [Patch v2] selftests/mm: do check_huge_anon() with a number been passed in
Date: Sat,  9 Aug 2025 19:42:09 +0000
Message-Id: <20250809194209.30484-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: detp1azwezej1ocwryadx4ubjt9nw7hi
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B8D940005
X-Rspamd-Server: rspam02
X-HE-Tag: 1754768535-541895
X-HE-Meta: U2FsdGVkX19PfP+ee45oGlASqB2pu+xa6/jYOjtePmoJH1vtLoHQmPogZFprNxI5JQeKwOO4kSC1sDRtbGsy69zoJQYV1GyKEXUfIEN+2tgUt0FbPN0kQeCWU2+wc5NzDSxFYw2iTSlVHNfkwOTpE5SbDXc68fdYl5Arw33n9atM6vLtaW5n1LIQJYvVBpJiBAkvF/pLALL47A/MdJipQm9q3QpMJwK7O0jr/3vuRNfB1epYf1qVWDJ0+tJLNUXfrc/gYrrxy5Lo6dS62JJHyJ1StHa3hnwtX3ukiMCMKiUV1GISp5O137RXU3GrdAvMBNGSbFJnnZK5Y+/OLG/BqBxNNi7BUzOPzUYEaCqCcrM2BNo6szGVVwC24hV1KGTNYoZMwPS4ZRmqPE/aUsoxG6aJpGX/2O6UQdXdDCrE2znuGSXZUrp2fZw2XtoF3uKBolVrzmx0nHUdrqCMq/eRqvgSsOSZu4xXun76jYv6rsDEa0ZP+TUqTj23iU1HHB/t2yjgOyhi6hAL/X9V+Cs3qwJcWInIMiB1bquoM1zk73YFdjHdj2yGXrS9GWGJwYDKj7qk97oJhoH48MyHIn8umIpdTM//PiMCerpFTRDaPBG11K6rqKIzvoKPGPtThXUu0iNp0103rzLL8qVWEBus6Kou8YsGm3LAYNujKFsm9tagSwxXZ27ZkSiKPSsaMqeMg4XC2M2S+JU3AOMXcynLZ82pBAe4368T7+xr4O2dlcS24Eo/NZyWmUtBKNkXPe1JPLGJ1c/RebxNhRwXi63bhMqE8OmiDUSu1nEG9oZCdWEWbcspu7fJ9Tl/4+G+g7vzeX1zRQprELgj91jbV1RKDZcPTdL8Vn4SHWw4A0sgZAOVc5X0+N5UpByMQQ8KNYB6IiJG6wCn6zLY1kgy3bLFqgu6spIjz+zlVvTO/6V1vz1Cja7T4TqejUhUg8y3B+kuuKwoxJKocal3Pg9cy14
 4W8Lgkx/
 /Pols8tTlhZnrEba+FDPycfDW+7stkPVQ3y6ilfOgIyVwyzbGgAprBxWFr55a4HhMyQ6jFIODr0U6CYXJ5N3GXDFihTb59jDF3L3naBVxaiIW3WOnx191iwJd0Y+0SiyVX97YpF3VpkJ9b/xzah98ru7X563b1tlqk3FLLj5BdmG96VL2Hv99DSircj9KhdsFHRZtIBbiJw2Nq1JKQX5IIfk0QpC5VkyB7h0dGjPbaNFsc/OKSEvLSHXMfKuDkp8hkCJeL5TC1nqJaMOsNZ87IR1UAKVe7YGVn9vF6PFSNJwMw4ctOGQf2FBh0CrDnmuJpFNnd1HGNJP8Lk2+cxGrawttPQ9ndfYhKytn/dok8ATotK5hXRwmIVRrRd95WBatPqsSVxSqZq6wK2InAJYzKOCCU6bneKAtJ3ifBwLBua2OTL+Yz5NaFE/2AgSDzv38fVOcrnhTQ8IEA7vdc81yqqSLpqheE1WF6xyX2PqkXE4mA2n3xNw/RSymKj5TK0LPjLt1ZIoahCjEkoA/VxkwGVzjO5f7hdA+NAUnf3Xe5cvW1VvEovHdylr8UxRwwBP0/2W1H6355shiF/zxyi35cclZ9m3AjoTutm6FW4Nhc19EUaz8rfiK+AcmW17I6cD6vuY6s3htWFhjsGhMGX0v9OtaoWA4Inz1oEMDgBEN4+DHRLNJDUUSfVT2TeyVgARTP9mXZGpEwpP/Jsc9aFKYpf4VOLK6DHGRb4PToEEgB//2umSTJ6LqiiPlIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently it hard codes the number of hugepage to check for
check_huge_anon(), but it would be more reasonable to do the check based
on a number passed in.

Pass in the hugepage number and do the check based on it.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>

---
v2:
  * use mm-new
  * add back nr_hpages which is removed by an early commit
  * adjust the change log a little
  * drop RB and resend
---
 tools/testing/selftests/mm/split_huge_page_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 5ab488fab1cd..63ac82f0b9e0 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -105,12 +105,12 @@ static char *allocate_zero_filled_hugepage(size_t len)
 	return result;
 }
 
-static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, size_t len)
+static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
 {
 	unsigned long rss_anon_before, rss_anon_after;
 	size_t i;
 
-	if (!check_huge_anon(one_page, 4, pmd_pagesize))
+	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
 	rss_anon_before = rss_anon();
@@ -141,7 +141,7 @@ void split_pmd_zero_pages(void)
 	size_t len = nr_hpages * pmd_pagesize;
 
 	one_page = allocate_zero_filled_hugepage(len);
-	verify_rss_anon_split_huge_page_all_zeroes(one_page, len);
+	verify_rss_anon_split_huge_page_all_zeroes(one_page, nr_hpages, len);
 	ksft_test_result_pass("Split zero filled huge pages successful\n");
 	free(one_page);
 }
-- 
2.34.1


