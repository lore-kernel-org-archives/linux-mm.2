Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68BF2606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=CYGsoGjk
Received: by kanga.kvack.org (Postfix)
	id 994A46B05B3; Thu,  5 Nov 2026 09:02:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945196B05B4; Thu,  5 Nov 2026 09:02:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835A66B05B5; Thu,  5 Nov 2026 09:02:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5270B6B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:02:23 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EAFC71C4445
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:22 +0000 (UTC)
X-FDA: 85401230124.28.6E0B18E
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id D4AA916000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=CYGsoGjk;
	spf=pass (imf08.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793887340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Utn6x3rxxZzER7UzhatCzfSahDSMe+iBJxrvoLSAb0=;
	b=13dt4Tt/5KTiJbWX8xi9HapxiioaYFBFMVzQll07RcbsJQTvmi6uLd8OI528e7XQAYhQJo
	rJ2+z4QCmiDvdDaiXDA0qYEiJrgLGTYTLpQHxOxgvBOGc3ik5LelanwlSx62+onrrRMAdd
	ltGikArVCgSd8cBIUQ9V7AK/9Ah8ySQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=CYGsoGjk;
	spf=pass (imf08.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793887340;
	b=wuOdRERq7i+RTAcCtCZJRdP9cY5p98YynbHWqSJ5vQYM76J92XHUe2p1NY999zSFvQOIS6
	0YFtY+ztCch50lid67MBK9ncSMUoVxh5dosvWceRCm9VWQ/ufNzqF87abnzagmb8NeZ7bV
	kkS2k/T2EeeDR6wPH6RwKNLWBpqnDvs=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b32bbd39d5so6030527b3.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 06:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793887340; x=1794492140; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2Utn6x3rxxZzER7UzhatCzfSahDSMe+iBJxrvoLSAb0=;
        b=CYGsoGjkUIbMWiZs0/JkvzSiT2wUjAJ1PhvHKQZDne4dGOIatfRrMgSmWgirh2f6DI
         kqJaTheqO4wVFxzvuJkKqdNocVUZ1dezk6mqovZe6ez/CBU5qknszIq1xgBFrr/2csBI
         qR4K3RvgXpqP3M7tiIqtaFiRo2pI1U/SF8KbRe6Pz8fU++N5dzsy798zYJb1s7BtbTc6
         da6qZlYDCGef1MNu5xjQRUKkPl7OeTdKXC0TyWLqWsIBGLonIks1L3L0yoLyaVlStDb2
         oix3zNaiSPEPwSBbHI7BJcoX9b5rTcyz3vofAkX5ZvfjozS3/mMPQF9gt0dTma2DxSdK
         5C8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793887340; x=1794492140;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Utn6x3rxxZzER7UzhatCzfSahDSMe+iBJxrvoLSAb0=;
        b=s565Hckil4UDHpEMPN1axdEtrhKVv2RHd1stUiQYuNYiKZl5kfKoGkQw7Uf7rYuStZ
         ojldxa2R/ScM9RCjBNAT+hurry+z+VYuOWFbcJIl4illwlnIbaDIPfL0ELU19iUdl+mm
         0QJI9OrmmkVa1jdhXRj4fjjVRy9qAniC2eQdFWPcCgH5Bak5DpbM+fKGcnOKpYcEG1fe
         uIpdwyH03dEGWnmJ6oX75oWUFtztJbtXmHCZLocUC6rJAydAz81Sjf5vAMyOOyfi+kI7
         eMamkOMKF/52aQxwlZELPdcDXowP6QAsf679AgABZ2XJs76cfQLzRUrWYI6Bk1gcWk3L
         2hiQ==
X-Forwarded-Encrypted: i=1; AKwUvBy9wqDYIxtSdZqj1thvqS+Hc6yowQkIcSG+47RH5HzaYUoVvtinCUBL+imqYszcKyiDNdi1UCtBgg==@kvack.org
X-Gm-Message-State: APuU4Z9SoZGN1o+Vlb8Tc690mo2xTSJcV8xTH4O5dzQhejJmpKzLgZlA
	FM5IPsSvgrcugIEwysqX9uB6/lMc48WqflTLcTIFThVz97Om4Ce/d67+o959Y8qDNq8=
X-Gm-Gg: AYBFou1FJMKh5Ri6973HXLk8OuEUCY5zSUabsBoSEjviwjXyWv0zbR1yW1E//3tujpg
	I9O4aPjwFh9rFcmvKpALXCSCfF3PsB2A6keReFUkiz0DW/MO+4InFAfs7QOQsImrwcGGmB4nXph
	wiqsvv03jKYlc5p6QEy8Dwuv+2o9x/2lgcHLEYKsxjsUmGCQGbmP9Y+3lfLzIWB01PPzDhYA255
	kUxU2XjqgsEL4p9DcrTxa5iTW2jYy4eZletQe77gaRUCluXvB6690ejLK/lI2JCzBDV1ue/kD5j
	K67vrhPIvRqm/e3cys8T5HwleXzj1QwY5QHb7Me5FjKmbSGwF63qEHyAGhmX+6C4shBvrmpW5mT
	IgMJORhUeuhBBv+6jng3Y18IsPU4WDCG3GbYGnTn2Six92GEmxMLqy1LQR7oLhHPxnsvqxm3Nex
	FfImm9LHfUFOY8MEZntpLMptekmeaDoBh0VYz5XDALQdp7sNzyi3hF5+cXGFc9Ro6J8pZ5gbWXA
	20vFB1UbvWNMvDAgkATJvDrs7yVqOlJ0f69sFSn0kD/3UTwm6cQuJkKLSGotzdgBUar5lvTh3gK
	f7KN1Cy0DdgiSkYi0glF+x00ljtFSCSuyPgd9m8ph2ap0w==
X-Received: by 2002:a05:690c:f87:b0:8b3:2d9f:e5fd with SMTP id 00721157ae682-8b32da02168mr9472927b3.27.1793887339767;
        Thu, 05 Nov 2026 06:02:19 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.248])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b309bd35c7sm40848757b3.44.2026.11.05.06.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 06:02:19 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 05 Nov 2026 14:02:04 +0000
Subject: [PATCH v3 2/5] selftests/mm: test a partial mremap() of hugetlb
 memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-b4-mremap-pre-split-v3-2-f8789de76849@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793887333; l=3232;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=vyJtn3JSRQ4DzNxOHF69tD6kEgmjTZhlzhXXwMjnOlk=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QAH6jYpYiFAfEpprrjvugqL6USy3AbtPSp4Kv9C7SmWV/URUN+yxBRyajzOqpqmWqrZpw6gsJKZ
 DURb9wLgGKAY=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Stat-Signature: cyqpec1z6qytkjcefi8x4ekspkf55zwc
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D4AA916000A
X-HE-Tag: 1793887340-868654
X-HE-Meta: U2FsdGVkX18NH7PdwaTCymxih/y1qRJTz0PagzarjhEscqYkNwg1iYjPsL/1EgP7dE4rJP47XFsV9opSNqOQaWgX8APMi1RtLdE1+2CpRSet4BcL6IGfpOPMjKFBRogLWpOxq93+IA4YXr4flnWDzLufnLYUNgmopVGA5ELHQsGtFRu7OnfFkgPOGQAaxkabhg5HUmvG6LhaARBBaMmTqSE1urMJkz2VQkAY2IhTXTR4hT85A10euxuZo8umW+P4CPIguiFR+gFoKoCZDzNoeuN/7BSd0Q0WUxPbbcc4j9BgPZ1PqHM9noQG75+3ANJV6NZiKN2g2zfZRPE8vOChZJjRWc6tqVgqDMM6+4AKHR28/fKjbzDCWENiN3oiQ7CZ4spRk/HhkgVFBGbACrxLzUtqzsW3pMq9Qgli/LL/70/AigwHaCCEy9GuXe0i5TBp3th1ydCQmdZwdG7zJVh3zenzBNHu+3b4MyJVigI76u0xfgT40hXFrOcNhOfLTh5r8LvsM+6shy3Xb8da5f6bFAjcdOnGApvn/E8btM73smGpcl5M6bRUWomlyRhvYw9495ozRnPXtDMYB4zD9aFKgpA2T6CEhZroYFi772pKDs9FOYb0pcVXttQmuLr5uMTrcJldhWgvKqkneHKmbMKRV32yuYXLsY476iQOvkNYU7CT5vtW6vcbLAAFp3jVVi3LhHaN2F6p8MTMXXOdGY9RwdQijIa75q3cUoOZ9K71mZy4Nc7gve35kLOHQEQ10WQQTmImFvi1SzPYYkO0yKC1zYSEaQE8z/OeCCasI62yOVeq7crjUy9L3mCK020aWjQVOco3H+uiipBuzz1A2RbUffvrV48VF5deSCGW6uvvIFH/XGjKRCk2qrTKvYDVwRz8O+pq2xsYqLCKV5gtt8ajAv3XWKSkYs4u2Xv36msK5takU34NRSNCxSS2iGPpNQEkET/sCuds4ceKJs49/A0
 n/pkQOtr
 ZcooC3G4rhHyBVMeDQJ8RClbis/6xEqpGm3s8tCiCsyjjYHxEFz6xLmdZDJ989gzSouamp/oG6GjurksC4PV+2aRja2s2eWn0Fl0AXknyOBDfvWFTLJSrLhWcDlDRyJFyq/7LqeiU3ueE8O8QE7uAfzY5xIaZ0DPo0PnZ2ibMfhcXnXAHmPTxkGBr4fU3SO3Ing1x5ZlQgQ+ZIVxdbnKnxm/WZu2S8w7KN40lz9pPBCzqfgldWeh7RHzCYXvSoQdTNpz98aHjc9e3JctFctz+Zv7hFOE2vlOuK9q7oa9QA7p8xmo6Ovugap6wPtb9Se/Nk1flwpKagYMmda6t83ScbEMjvQ/H7ahVavuPnpoYW1lQElJDrPpE2Iu5ahoX+5H1WY13
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

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
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


