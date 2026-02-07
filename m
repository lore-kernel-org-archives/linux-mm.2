Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 626BCEE6B7C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 08:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3C06B00A2; Sat,  7 Feb 2026 03:16:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAA656B00A3; Sat,  7 Feb 2026 03:16:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99C86B00A4; Sat,  7 Feb 2026 03:16:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A88F06B00A2
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:16:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 79E651A025E
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:16:58 +0000 (UTC)
X-FDA: 84416954916.08.0F1DA2F
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id 06BBC20010
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:16:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="DK/FFfGk";
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770452216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRPloOPmIvdTkQu3q4j2KYKMkvQYHLzGzqGMt4kDAVw=;
	b=Mpha+P6xBKgeknuQyxhuXME8jnJAswwGkTiBAOZ4eWHcZtZFwAx43JeGPXF6eW4Z9Nzh8d
	oc/5vtO1GCr7w+bAQAdTjy4LREsmITwYv4WltaPVIhtqYoijjHCBIOXIEXhlrzkBZ3kZ6x
	7xdwSpT60dAPwY3kqqEPkgjQXPeDUqc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="DK/FFfGk";
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770452216; a=rsa-sha256;
	cv=none;
	b=Vm/zTCZVKlmQ4vZlMFPd3ri1tQ3pLG9Eukt4muQxjDBEkLj+uPaTEidSwtWadehTymPh0D
	2vpW/dN2SxlZs3zSZB4xfnTLnlX/g6/o+Hd90kKsI6EksRD8GcVRkTo+WXLK8c/WMkx3S0
	kOopjGX3EN4QMLVgwVStxOh4Wk5I4RU=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-354a2d107bfso708022a91.0
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 00:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770452215; x=1771057015; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sRPloOPmIvdTkQu3q4j2KYKMkvQYHLzGzqGMt4kDAVw=;
        b=DK/FFfGktNmYQyAVfg6mU2iZ4WPs4AcDLPNso1qNpgM0qYc3JPsGWKef/7BFEkVpPc
         juLuLNYwp9aVw6I7wqyJA2AzC7iXJFSm2UNivxtiqTuAkyJBwXqXG94x1zoWT3GZgKNn
         LUxym5HH1qnpTtD18uUpTdnkWZLHz4CXXZDcoG0F6HjhWN99Q8DZz+KqZholSNjiomSh
         xjaBBAaUzWdk3TlnTXgFi6/uJrsyNqqyaprjS/szlAUcSYibTkJToUVW60FwWdFNq/PW
         n61oOoDb27bcM2YzOMibi+j59yo+UPDdLVB/+YD676hRxUf7Ap7Qo6HjWMqyryCvX6n8
         mJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770452215; x=1771057015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sRPloOPmIvdTkQu3q4j2KYKMkvQYHLzGzqGMt4kDAVw=;
        b=M5CVK2A1hzJaS0SlvPS2hSfz2IJkQLExRGPR0wicZ7TNJ8G5vob1K0tFswx7lq2O2x
         dQzEFgvLCHHHRNoTWCNxjTZy0P7vNQKQPXLshXgN2H8GpfpE7uVomiSvRRYmzDrVIqDW
         G9OY++Bo3ZbfpGeWYKnTcSpjmw7LjHswWsGMqwvCoP7xl16Y6+EJIeimlA8cDefn6tQk
         CmZHtVo8RKbaCivDsv6CZ3pB1lnLfTdSKTdd3Pbp96Wnbw71NJn+o58TR7JC8URYvc4x
         Yu5wZ2mQQquwi3QV1tUPWEbj5h/qCI/VLE4li/hqLmSvz+WhJmkqFn00IjYLqwPjtxXL
         EkEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUtcw89seCRW3gEhnZRwQU1Bv/nvrDZ8L6alS6V9/l3GWiSQ0BJJ+lSUWk2w9y9FW8mhoYZd7Fww==@kvack.org
X-Gm-Message-State: AOJu0Yz1EkQFGLo6Yr1abd89Spgv9QRzDnWmDvB5Jrr/7w8K5VD7tEbW
	wJ6yGURURAPRY+SujqUAkg/mjKssoAaXZPmzA1O1sLGBAubjt0MbLI4T
X-Gm-Gg: AZuq6aI+2Kfh60HYxjFNKTCPGqnYY2c0HomOrmv1r7Gtq63mgXSrxwenTMZB8fb8lql
	6llkbsG6rj9uwZbJvPBH+AtSauhgFSHqxds8rLoMblZ3jf6SModimnPSTeuAvjnTPBZ1+C+g2Vx
	tTNiZ6xPnyQXaLCFAeqrG0gJKGGpziaWKKWXseHNSqB/q5fK4XachJ+ASHqXgsrp3EXHf0WjL2w
	qnwePfbJsbsDYFOckaMplb9S8egz2IboaBIySoyPxxzGaeJ70o9RjCoJpjCPdWXph7sJNQIHmm1
	9cb+/AL6rlZczFAPgGnXK3w3uOUmecuY9dQhedBj5WkhCBPqK+FJJR1RcdE1998+jun9ZlB0zAd
	IWnXurGrBHFzgX0VcfsolKq0C2h8EW6XYEYDuPHDhn/0Hac3Y6u3d1eOcgigmpXpSJeWLGkHKfP
	moaEmfMuqR5Y1KSgGPuQKescE=
X-Received: by 2002:a17:90b:1b51:b0:341:2141:df76 with SMTP id 98e67ed59e1d1-354b3c81322mr4971509a91.13.1770452214869;
        Sat, 07 Feb 2026 00:16:54 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3549c5955a7sm8028189a91.17.2026.02.07.00.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 00:16:54 -0800 (PST)
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
Date: Sat,  7 Feb 2026 16:16:12 +0800
Message-ID: <20260207081613.588598-5-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260207081613.588598-1-vernon2gm@gmail.com>
References: <20260207081613.588598-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 06BBC20010
X-Stat-Signature: wn4kay7phudsgad88fxogme87zdt1ot4
X-Rspam-User: 
X-HE-Tag: 1770452215-690591
X-HE-Meta: U2FsdGVkX1/zukk197o/CEHLVXa/ODvywTtiuZHcYAicg3HlIHu6GW/WMxFFhO8TDBmbz+yjiLMANb4AJZVaxr/zuuPmfpLTMvzsWZLfi0mIP4L0E1CdVrf5rH79javjX/EdwjdpSYP75NnQeV+cl6Er1tTe4vMYAmWa+4SSyZkCrxvV3weCUFDrtta/zMomnbLBdcAoLh9dTaJFA6ZoRvlI8kwnDKEjLV7P3VoBGQw81yXl/+GSyhlRAND0uimQNEo4GuIWaciGU/7yryDFxLPwYqEGXrsB7rvbLgtK7qpdDVU97s4nWPSl5DDlf8rnWBBYzIUJtlxMRjI5zCRo684ToNKzjbdu1YTKIG4Lzl444+6u52xUrN1tyQu9hEQC0QmGf5Uii4didxgoLqucxbKtgZJX0M6gn7GW8njXHannV8XVXHhbgmeihjKVGAGC5QuQqGcXwVxr2sZq0zHVGHC99K7mHY9LvtbWe3LtMgTC2eRAhbTIcaVeD3PcgqvtnOWcXgDp87gOkMFIpcsLbQOUH61njtWGQgciUzcrtoaF1ZoixC4S/bhiU+PrMBGyjWZ6n0fnL3FZx4sJSRkhTFVuuehmhb/A+YjqKPOnerMDTr7DhsCd5nvGZEPFlJJn1xUMzygrGoOrNrlm8ZBOEZMzRkymWaSp6jxYPPIPUjePlaGnWk2nL68/rJdWxX8T1rj8tcshE5n/XPlhIXRYuXQyTUp/LKQVkpcsfPTmRd2Ajh+c3BCjxMhKYFNG0e0aysZEIA3yEPSLlzkqqPiFhdED+nlmo7M6sN+19cL0jdbtc6xyU5sfgzzRjNeN6Z1k6Pm9QpTMduJSdd4VPH+59q8Mzgg+3Tq/KqDflo9yN+bDFpwG/N3xc6trVAXxIxdNVFEG2cGIXkr15wGqz2wr/KdRPQPN0OIBjqt08fHEZpzTCckaBH0+PQsyiW+cHSIxgHm+7gX+Upbrkck/wnc
 NvHOUrAL
 TzHoEv4dN083BGE4STc1wuwv0THsGkR26wWZgpiU33f0RcghojomwvnoTk5aUFClkbECtBYs6YAQSH2jiqUbzFr/pnCz0ZTogbqaJNiJjCowROICguoilX1yEIanu1nMHGUKd0FOZSpLK+HgS7y4PKXEeSd50Ihorq7ivqUWYb75TOJIv6KNieNdbQ9Jtcvvz1ATx/5W8AdF233sL3DTPFYh8Co+cfBN20cZ2WZok6A6UD1YZsm1wyUyrnDwsPSEXWmvBiLx2k1dmlgJpzeStSksnnsS+0xwEtmFan/o8FfYFqZxldMJwPagenO2Ehykk6zQagOMU7Se9lHEL1UlEiTNjyYuCSjXdb2Ey7ybaW3h+rIkqDj8wuKUY9skPGwjza0TWx8oCkKqh5Sq1guongoALvskIRONjtCJrDmoBexO+9lzerulB36qUedpfV9FLaPTCv4OG9bBbVP4tQJGnYcESYBStAQVIHHf2keizo1vGT1R4t/dmfQdkqlytg+xNmvHqDt2PtjdGbcDITkZQtL86YlT/y6M5Tf8V
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


