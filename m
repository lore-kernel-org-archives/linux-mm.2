Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C2E606D807
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=P739lgGt
Received: by kanga.kvack.org (Postfix)
	id 611EC6B05B6; Thu,  5 Nov 2026 09:02:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C32C6B05B7; Thu,  5 Nov 2026 09:02:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D90D6B05B8; Thu,  5 Nov 2026 09:02:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF856B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:02:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DAF9E1C4456
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:26 +0000 (UTC)
X-FDA: 85401230292.29.C4F5C6D
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id C717A4000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=P739lgGt;
	spf=pass (imf12.hostedemail.com: domain of josef@toxicpanda.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793887344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rsuh1trntORa2Bnh/nKHx3QFpJDgmdnm57YWbiv0xFs=;
	b=79VC7AZmqrGSVDQSEh0TrrehV4hFJeHBX4m5ItNZzzEIg2PvbPbrDox6xNaGLDP5d4ARic
	iD2YSbBh10FWhNMovamOTvKfh7HSBdWX5sOoe0/2UKnutQm09AMw60u/wh3PCmPLBVQrnB
	q/SkUiQzz+MDNnhj2hj+C0VCKUNH0q0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793887344;
	b=2nuLsIkVC6iQIMF9q5goOpx1B3HHLXWS6A1glJSj0igBfVampVH7vDiT2U2idI2q0aI8Xb
	0cB6dIVg7ekldLIuuOYqmBF4pdw8H7JCfjGog2+Z6Tw+QbZk3JyUKQaNseF594ZY18O2X5
	OcODpKX5155Ympi3q7BZG2Am0o8NjpE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=P739lgGt;
	spf=pass (imf12.hostedemail.com: domain of josef@toxicpanda.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-679a2297c55so2522079d50.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 06:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793887344; x=1794492144; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rsuh1trntORa2Bnh/nKHx3QFpJDgmdnm57YWbiv0xFs=;
        b=P739lgGtrDED1a7FRfGWMrXnyYSd+6jilJuxtftW9nXoGKIAxirtITSMX7u1xOaMFh
         OWXXWMzCeRR6Tly2kukP6vxZmWYqBpPoUOCFDOntAwGnCQ0Y9as2ESy5kOgb1uVvDbOl
         x/H1QXSTS9/Grvv/xUp4F5QCiAWE587+U2xbmsy9vQOB+Ata1BcSQhKoPCI8n5kTy4op
         7E6Aimv4ssGmF5991zFf/55cjGwhwwh291y7nYSDbTQz5D9oG/GEf/6OI6MC7xjBFT+f
         UerQ3QYeh2taxpJFNZHFjSw5EpeabSmLPwcgWDLTDMyA5oj3rdeWGRz5Qafuxz5q/l4M
         1gBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793887344; x=1794492144;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rsuh1trntORa2Bnh/nKHx3QFpJDgmdnm57YWbiv0xFs=;
        b=J8ug2jzKiDzWAULB0NXOh5Nm7E1djsnRn6s5SKpDbShtybo3GJxKPjk8ogyR/2yeDz
         A5y3WUGhoO7xs5GDvLjZYGNYz2/SX+NLY1N5mh7r8NbIEt9d1zVzAVvbkSekoLEQDkie
         hb4D7jlTKvcPw0CyGoBz8QGP4bSq2arT13uXXnSovVdBOsKPrnCcNh6BgHd28CnOUcko
         wv+/T48rFE5NyDjMdB4gV4ZorVRGdYTxF7N2jGfgJ5x/Q0CRIP7Vocd0Gkl6rhDREwkN
         +cfwDuoEcOlgyzruB6isuNwt1ffreEnyB77sl4zUlOmAANw/cDRwmZZG54/XD18+3LC8
         POXQ==
X-Forwarded-Encrypted: i=1; AKwUvByZCNL1NWumNleP7dhtX2lXnTirkQkoeUISUzH/g60LNtBss4m0kQfy3snc1y2mhTb6dykA7KtfOQ==@kvack.org
X-Gm-Message-State: APuU4Z9ct7K+px1c8b5CzZ2Obq1+BTIjtcGLIy8I6okCNHH+A75CkOBm
	bgtSUt5CA596jmt+5T9icg3sZpGx2+SpPVlXPENzsojOHvnlRkk8m2zPbRoXVuhPGFU=
X-Gm-Gg: AYBFou2tw3ms7bbNjaJeHGaFhHNoCKxO7k9em3eHL4N+h95sEpPUIQC5+vWX6+WYMv9
	IMTQxHpKvE6bqZfFyruZPFKeEN+vtuKxvgBXfOLu+YatY741Pky9VE9td0jZeC3fbAhEwU0OtvC
	kCSDIb2jJD68zn5tS9ZsnCywdguRFVvIrT19UeYfgb+7saxhMUiQ+7s/b6775NNDNW82kwzAAV8
	sPawXixLnX90p5R6IB+mTDaT3x3b7OolDd31WHdds1ON+tPmBGuXEK21IhhVqQicmssJmgULAmC
	goGpZgKgmHbJlDtx1BhwHWRy7cPbX/Eny6q6eTYRynO/W/qNDRdpsNp8WFY7NS4bcZZBvqvaQQc
	wTv9tVdqwHOcMyGxXhkYLiWd6rVExz6QuEOHxuonkv/A8h9p9V3WS4F8NGsAu66jsvNLs54FiWH
	A9FC+1S/CzERBZQmXoZJxcqm6YPLF16QVHWuKUvIZA1TtsN2ls0uFHKpS0sG5IhuogUrGF+OYMn
	UrV94yghlpeYqlqYHO12NwLhsrL2hK0Qca4FQta/9s+ciDxCnKg7l4CvTT5y6B8oGlFNauh8xC2
	aJD02pb2QQC7dhv6PbXcW+V6fFGLWfyfmMGQ53wVJPHpng==
X-Received: by 2002:a05:690e:809:20b0:677:d9a1:f055 with SMTP id 956f58d0204a3-67ba4fbbc6amr9317901d50.16.1793887343879;
        Thu, 05 Nov 2026 06:02:23 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.249])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67bee273e69sm3588786d50.14.2026.11.05.06.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 06:02:22 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 05 Nov 2026 14:02:07 +0000
Subject: [PATCH v3 5/5] selftests/mm: test mremap() with an old size of 0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-b4-mremap-pre-split-v3-5-f8789de76849@toxicpanda.com>
References: <20261105-b4-mremap-pre-split-v3-0-f8789de76849@toxicpanda.com>
In-Reply-To: <20261105-b4-mremap-pre-split-v3-0-f8789de76849@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793887333; l=3141;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=UPSVlZkvuk+wQVjnYokFon8pgCczm0XVk+5aTGfVono=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QCN7B7RAl0gdH0bQSZgnJDEnZX+puHImRc1Y1J+CsmzCbc0k4yErvMUf3K7EoMGmNp0Q86ZHno6
 L32tytLO10gg=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C717A4000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6zcsjyojp8isgb5xnbgdutgnij6xqhbm
X-Rspam-User: 
X-HE-Tag: 1793887344-48458
X-HE-Meta: U2FsdGVkX1/uTscaRoig0//jrP4UC9k8kX0ZR6GwB1QCdiLljB8NQ1txo7FXH+UgE/XFEOiTsMyfiW9dgq2PocOSnayz/HBD/iJxXfqi/fbSwVCsfnn+993Djg9oEDVGdT+y2FQJZxMd7BLDW3sq22Cnql6cpk0Oy2417+ig3UESaqmxgHiqp0NeI0GE2tXxMGInfkuhwWkMFVKAcFRmeLqpKpS4tVaAjnm/1GtKPwtTQ2Sw/IghAIf5wyljsotANAzOOH86RGS+w04gFc0H431I586fwmEg2KGfsaSJGabh50LVN1kGm+xv8wZ6FfKFeMT1K0Np5KE+FrMTbdadJ/xSbx7E5e2lgna+jLzlIzk2II6me/OAJKdfht2ygvGtBSQ570SNwWpFOgFRqW26yzfhzuGmZU79GgmDtShwe8GuBQSqPmtuUTQY3CYEDmbo95pVki9NT7n43cNdvlBsmtOuW8Mp4VmELxCnYXN1egBw4Z1d3Vqd+Sc9ZNb+lSjiCENzYLRu+50aOdW+T35uFaymY4geJ5ZeQmGeqrRPyIG9qsa8Id8XvL3yTyITHdKoraOSzNLlMOdQLW816ZuhB0AzSYOQYc74QL+WKVQWFQ+sobWYzADto8c/CAQWsA5xFQBN2y67XinZggr7mRDlq2GPygFTNr04CntMwNElUGB9sATToAJrb/VhCO7jIbzmpBFtCnPd3Il7K34kqcULOkb9zAwSv17LnKPDa69RLGbF+7rVQ4NtXIExfC2FtFbkgYx1f7ECFSkg0e8xhLv7eE0RwWs5IufAG3qXwJq2wvyqgHahOH/LreS2BWGMl5jXCRqPmrV5MlsiWc7X+GnBPqiUeHb0jtR0sKk/xYqQk4G0XkgnNJBBDSJfl+aQQ5MG0qTyBHttzMO57kltWAoQpLDdFD6yWfJ+Yyir7215Cuu1bZOh9MdIADQTVchlKhZTv5jrJAgxfOfP+Daqz9f
 MLSp2WZx
 ACTsd+jNjVBQP7WkDCnByMghNhXJQ6WrzhgCwvbzonJenao4/XyeHLQ0e0dxAtBzzHDctdZ+fUvWwkE2YIJZT0gAqVbxMHbpBFBpnOFWC5WhkU5WWymomjGIsZuRw9iy74f7aLy41THzo2nHg/X/ntEJD9gHXfTK70UftgTN2QPSMmmhzFM9z69pbNNrcXoUhhhYdzWyiHkKyN0oZnJLUaOI0JWI+PvplnA1ZR1kx4Z4iY2XfCpr3vSpCi9nz0v+eRc0oMs2b3LHFpGzGXIPj8DSBXyerJNzMFsRrB/JoZbrfNOzfkYwF5gBPcvJCa4PWFID2+OaDJJQpzLDPvLGAhmXFdGq+r8pdU80tDQPlH8vsNt8fJjDP/372DdEEfd77jkeZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mremap() with an old size of 0 duplicates a shared mapping, and mremap_test
has no case for it.

Duplicate a shared anonymous mapping, once from its start and once from the
middle. Check that the source and the duplicate are mapped by one VMA each
and that they show the same pages.

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 tools/testing/selftests/mm/mremap_test.c | 51 +++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 31b484517bda..df030409488b 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -603,6 +603,53 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 				      inplace ? " [inplace]" : "");
 }
 
+/*
+ * An old size of 0 duplicates a shared mapping: the pages show up at a second
+ * address, and the mapping they were taken from stays as it is.
+ */
+static void mremap_duplicate_shared(FILE *maps_fp, unsigned long page_size,
+				    unsigned long offset)
+{
+	char *test_name = "mremap duplicate shared mapping";
+	const size_t size = 3 * page_size;
+	const size_t dup_size = size - offset;
+	char *dup = MAP_FAILED;
+	bool success = false;
+	char *ptr;
+
+	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_SHARED | MAP_ANON, -1, 0);
+	if (ptr == MAP_FAILED) {
+		ksft_perror("mmap");
+		goto out;
+	}
+	memset(ptr, 'a', size);
+
+	dup = mremap(ptr + offset, 0, dup_size, MREMAP_MAYMOVE);
+	if (dup == MAP_FAILED) {
+		ksft_perror("mremap");
+		goto out_unmap;
+	}
+
+	/* Both are mapped, each by a single VMA. */
+	if (!is_ptr_mapped(maps_fp, ptr, size) ||
+	    !is_ptr_mapped(maps_fp, dup, dup_size))
+		goto out_unmap;
+
+	/* They show the same pages. */
+	ptr[offset] = 'b';
+	dup[dup_size - 1] = 'c';
+	success = dup[0] == 'b' && ptr[size - 1] == 'c' && ptr[0] != 'c';
+
+out_unmap:
+	if (dup != MAP_FAILED)
+		munmap(dup, dup_size);
+	munmap(ptr, size);
+out:
+	ksft_test_result(success, "%s%s\n", test_name,
+			 offset ? " [from the middle]" : "");
+}
+
 static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 					    unsigned long page_size,
 					    bool dont_unmap)
@@ -1248,7 +1295,7 @@ int main(int argc, char **argv)
 	char *rand_addr;
 	size_t rand_size;
 	int num_expand_tests = 2;
-	int num_misc_tests = 9;
+	int num_misc_tests = 11;
 	struct test test_cases[MAX_TEST] = {};
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
@@ -1385,6 +1432,8 @@ int main(int argc, char **argv)
 	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ false);
 	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ true);
 	mremap_move_multi_invalid_vmas(maps_fp, page_size);
+	mremap_duplicate_shared(maps_fp, page_size, 0);
+	mremap_duplicate_shared(maps_fp, page_size, page_size);
 
 	fclose(maps_fp);
 

-- 
2.55.0


