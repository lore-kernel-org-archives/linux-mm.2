Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA05E606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 23:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=De93wQx5
Received: by kanga.kvack.org (Postfix)
	id 1A8866B05B2; Mon,  2 Nov 2026 18:54:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FCE6B05B8; Mon,  2 Nov 2026 18:54:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06FCB6B05B9; Mon,  2 Nov 2026 18:54:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D59EC6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:54:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B8B81402DA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:54:08 +0000 (UTC)
X-FDA: 85391834976.01.2F4ADC0
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id 11B824000E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:54:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=De93wQx5;
	spf=pass (imf04.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793663646;
	b=IkcH7Oy9TybSyHnLTq89Uc8wTkKqMD2wNy011KQ/6b334VBbh4u1gb/2gz4mvKQ8j3gQ51
	Lw/ogy3MWRDqcPjYZfwI8bEsfYM9G/unWb8bjf2iygu6bnMeOoLkECsqITlJ/AxMwPhTtC
	jEXOFTdtnR84zEBdKCrV/Zypjoe7LyI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=De93wQx5;
	spf=pass (imf04.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793663646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1xg0WQbGocMtwKeE05GguXzFIm0jqtzl6Gw06sQh9Hw=;
	b=tbO93sPb3o0X9Po12G381Zv3wfZbgDVJSg2Pm8uk3FWfULT2OR/J0zTTEh7JRDuyF5LWlZ
	7ItTxcLo6vzwV7eVN2pId9PODqIFeUfQsHbdEmaGIYHybAZ7brjfWpr9/9ZN0gAR10t8t4
	J+bLpZmBC/zsGQw9ZiBXcIKzTcj9Skc=
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-84e513877a3so163378a34.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 15:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793663645; x=1794268445; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1xg0WQbGocMtwKeE05GguXzFIm0jqtzl6Gw06sQh9Hw=;
        b=De93wQx5HW7fV9VXRYi3SN2wl2Tojh1gtFhCJzwvzMP8jX7BYKF4RXonIs74QPl7Zi
         ZLioXKr9C4bjjyX6rrl8wJo2fC5IylW7bfXhA1ySBfMCKNcbECovFKuGwpavWixW+B4h
         sRHiYPR6G/EjX2o9C+WZyls2YnlBYt3Kcz3FhfnF5DgVJa0u9ArmAHhso949sKrAfPRI
         WUuRD1o0IVB8Efmu637nJ8MFCBRJwAwmuU0tCc1Z2/VjECuwMuLZePJeiiRn5QLxV6Px
         eEBJb8EmezTiMSoYGUrcCq99WUIkeqPTpX/i+4xMYhXr4LfD6uw9ua4+JCE4bOE6OmAm
         9SfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793663645; x=1794268445;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1xg0WQbGocMtwKeE05GguXzFIm0jqtzl6Gw06sQh9Hw=;
        b=yKeWHHB1wbSKh629yMLd4bvkC0SpgwYGXMEX1bsfjsIkoqYCWOIe+0orFm/uOFQVuj
         6GYVgcPHZbZMYgOtJ1kNDvIL0K0FP9LWvaYdiSvTxDfc+ZWer72hFt8FsIn4nw5GxBXd
         NEGjn/KNlg7nwggakEYTUsOrVGS0cxIOBA92A7S5UiTdk3SZ2YmfQBKajE+vmnp5fKvE
         n2o8UTPknsOwosxPo8Deg8yNxxbNxCLylg32VrEg77ZJeFw6FgYXNHN4G85d9PzIwGiN
         XMUQr0zwc93bGpgqOqIWwNYR5eSb4FTfCJUOGQzcB916nRXnZN0icTG5bdbGubftkoTd
         rMoA==
X-Forwarded-Encrypted: i=1; AKwUvBxbdNyxlK8C/mYetDdpeE1QI6cbwD2pqn3TVbGvRPe6xlq0guyHXS/2JA5CfaH6rUE1nhUMoOnvQQ==@kvack.org
X-Gm-Message-State: AFq9FYL3+rtFbvSWuOqFd1rn47sSFx3m/nXX6ct+vigK2mj4mtHAWM4B
	7FJUQwPDH1NjVjILSN/0zqmJUioBVH71x7Fiew4enYwwJw+e2fmHii4JMTmBSxH7wDJ8bd4pvgM
	agpX9EuM=
X-Gm-Gg: AYBFou27mrwTBFQuRQ0ZBae/gXtZIiKpOUk7NkTrfAv10ky9IWOdgpYjd8M82Ra02Yh
	MRhS4sFsPLfhWIQExHP8Thuv6JvGqOdVPrXBlhb+Zj6EeVAZriElLf8JDrg5iYvZQvwJ33aHpcP
	m4i+ma5JeBjFw+XOTwRq1m5WGeyjl3BBJ2Q8qJEOvrZfjoxSdALc4FXwXqQu9I9SmHxu1UsBZ9B
	vcO+j2tuVKsXRNu/qcFWcStW+UKpihdgADVL6sRbC8r3BAhKasimRGlslEa9HBBUkdfTsSisg4m
	LZE+c9G7W4v64GBDtptZLK34hkHf2r9Dd5/e9q1uNAneF4/SItYWxG0tzKv9BfGKSA4YyvTIoUW
	eYe3nKSsVhJXRnEKGDEXXLTqK4S0PDpbPwwG0jagG6rqCzzuDzn6GJL1RyBlKLUpgZULlysa/Ax
	OusnskUTZe1iYUTgPqmrPN9JGJOBKErO/97Hpu9/F0X6dTV5BjppBr8jqPEmAj8gAQ/J12Isae9
	4x/JXYydWuXXnvn2PblISokBqRsLRWiXdOvugmkSj9cHmobvXle+40m8sGZ6m7kL7q6AddMHLJL
	Z7Pf91uyvXzZr9PH4Pq+WNjh7ujCCGs/mF1y5oeAO1FlyA==
X-Received: by 2002:a05:6214:4386:b0:919:56b1:48fa with SMTP id 6a1803df08f44-91ca4b710bbmr196747126d6.20.1793663179954;
        Mon, 02 Nov 2026 15:46:19 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.241])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca7f27031sm103490146d6.15.2026.11.02.15.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 15:46:18 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 02 Nov 2026 23:45:58 +0000
Subject: [PATCH v2 2/5] selftests/mm: test a partial mremap() of hugetlb
 memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-b4-mremap-pre-split-v2-2-d281dd11ad7d@toxicpanda.com>
References: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
In-Reply-To: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793663165; l=3174;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=x3L6YKR3/KKoEI5B/HR2bC1x62L1t7fxLfNQB1ssEXQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QBffnADOj2rZA/qurr8KZ1+tWUKRfhaU4ce1Q/HAMnMfHCkCwtf07RSUuqDYg4ZMNL7/DQP3ZBY
 SNrq7/5apxw8=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Stat-Signature: of94q6pmsmz1ybynt57xysxj9pqd436e
X-Rspamd-Queue-Id: 11B824000E
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793663645-772055
X-HE-Meta: U2FsdGVkX19RimYLSSngOvLHc7zxQ/zEHXI/LkXgITS2Nnc74JuiZj8Mbs6kM48YCq2sK0jYa5clNn9RUBXHTpNhKPFIQTnLDluz2jErjN/3mYNoPqdt3Lsik1zm7fu3tUrAvRBEamzOdyLFraSOGFqaMkr9Yw11XedA/6OP5O8ws4GeA8oXg3TkaeH7mcFbfJGLHerSKWbHiy4j5Ps9vRuiN0N+SFaBWbG+Y2g9WbJpv081CLsDdZVRLIzK3oQIUw29D658xBoq07OxVImzC/NolfQ3PUcQgfBSEjSdQpYWStjsSDQ0LSM09VBF71GCdtK8LRojoOS1L9pE3kcsuwynDfeAkaEIkceKebkpFEURWjIpcTzR8wqGHcm0Y4uekARTtksTbdsqW9BLTBskZihoWykQ75JS53fxu/oAvPGTLxOjjWXH3KiQJPV+0AoseLi1aWYod/z6DWTKEjUjfG/ISDBdwcKpEg3pnpii/1hDgpaRe1gG9KZzcCFa58lw9YmAmOSY+9ciUS+HviN1yd3vtoxpcf17YGmBYC4tMBC/rcJCUH17EO3mhkSsj9j5mZWt0gTDHoG04/t03iHaDl5Xb4EyqJ2G7es9zNlacMseBIyyBfL0JC9YP/MO1AgJN1HdiikpBWHefGHyPzn/ilTchv6kMFjlcWsN7hzD+PtFd9qE/ZHI8ZIJs9CVPXxn+lsu2tSSdCbarFVaCD/n0gYULcvOw94+E9yNmoNJig7lM149Xdx1iHVLsXDe0Kyx7IHA/2sdCfpOV64DY8vmjQVSJf7w6H5bmHIwcztVTlUailvMbt2NDtkPCR+8VxWTMji+PzyVg2hnqR0wru/Nr3EblR+yjf8WvwakQRX/BmSFldlKepfh//oReAgNvPRQvQB0N2KZxj06FsdjKQJrByyz/V79xXbELORhf970pHK0tdENbrJ+z/eRoqiy4tMVk4EDCfv3InBGND4Ocml
 4VE4gg3Q
 PpFqobXD3ZiJAHnbC/Sh3K3dgDRxLQrW+mH41BigUMRYZxk/p1G4TF4Wf9sVAdLgQTJoA+aOXz3coicmiIftDkgZmWPt7V6DNqpe0waB10dS705cPR4qBRp9MbJOmEXCbMvbGmn/xHrrTv4HCGqZiHymrkeGIx0ewRt0amcF0wphvJI8Q0ZMDM0naKWTP4ahTEKicMRLQZYXwYBOkliN7Y5PHPLHGB2e6R4wxGr40XuGvYAi4EQ9a58iiEZKjyIGrKhkWS0nilhi4c/1potKM/Sz6Qi+g9jMYljnxC5VBBQYbNurDG63i8UjeQe9Pd37QbqHAoozZP8skwqnOWWjCNevxYuFxFkr7DePJySTlCY8okW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hugetlb-mremap only moves whole mappings, so it did not catch the
reservation leak of a partial move.

Map four private huge pages without touching them, move the second one,
unmap everything, and check that the number of reserved huge pages is back
where it was.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-mremap.c | 52 +++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
index 9b724af66e93..9f9d6905cd6d 100644
--- a/tools/testing/selftests/mm/hugetlb-mremap.c
+++ b/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -95,6 +95,51 @@ static void register_region_with_uffd(char *addr, size_t len)
 	ksft_print_msg("Registered memory at address %p with userfaultfd\n", addr);
 }
 
+/*
+ * Move one page out of the middle of a private mapping that has not been
+ * touched, so that every page of it still holds its reservation.  Once all of
+ * it is unmapped, all of the reservations have to be back in the pool.
+ */
+static void test_partial_move(unsigned long hugepage_size)
+{
+	const int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
+	const int prot = PROT_READ | PROT_WRITE;
+	const unsigned long nr = 4;
+	unsigned long resv = hugetlb_nr_resv_pages(hugepage_size);
+	unsigned long resv_after;
+	char *src, *dst, *addr;
+
+	/* The pages of the test before this one can still be in use. */
+	if (!hugetlb_setup_default(resv + nr + 1)) {
+		ksft_test_result_skip("Partial move: not enough free huge pages\n");
+		return;
+	}
+
+	src = mmap(NULL, nr * hugepage_size, prot, flags, -1, 0);
+	if (src == MAP_FAILED)
+		ksft_exit_fail_msg("mmap src: %s\n", strerror(errno));
+
+	/* The destination has to be hugetlb-backed, mremap() replaces it. */
+	dst = mmap(NULL, hugepage_size, prot, flags, -1, 0);
+	if (dst == MAP_FAILED)
+		ksft_exit_fail_msg("mmap dst: %s\n", strerror(errno));
+
+	addr = mremap(src + hugepage_size, hugepage_size, hugepage_size,
+		      MREMAP_MAYMOVE | MREMAP_FIXED, dst);
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("partial mremap: %s\n", strerror(errno));
+
+	munmap(addr, hugepage_size);
+	munmap(src, nr * hugepage_size);
+
+	resv_after = hugetlb_nr_resv_pages(hugepage_size);
+	if (resv_after != resv)
+		ksft_print_msg("Reserved huge pages: %lu before, %lu after\n",
+			       resv, resv_after);
+	ksft_test_result(resv_after == resv,
+			 "Partial move returns all reservations\n");
+}
+
 int main(int argc, char *argv[])
 {
 	unsigned long hugepage_size;
@@ -102,7 +147,7 @@ int main(int argc, char *argv[])
 	size_t length = 0;
 
 	ksft_print_header();
-	ksft_set_plan(1);
+	ksft_set_plan(2);
 
 	if (argc >= 2 && !strcmp(argv[1], "-h"))
 		ksft_exit_fail_msg("Usage: %s [length_in_MB]\n", argv[0]);
@@ -170,5 +215,8 @@ int main(int argc, char *argv[])
 	close(fd);
 
 	ksft_test_result(!ret, "Read same data\n");
-	ksft_exit(!ret);
+
+	test_partial_move(hugepage_size);
+
+	ksft_finished();
 }

-- 
2.55.0


