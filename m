Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F47606A331
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=S6IdhD6R
Received: by kanga.kvack.org (Postfix)
	id C0AA16B05B8; Fri, 30 Oct 2026 10:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBBF76B05B9; Fri, 30 Oct 2026 10:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2B86B05BA; Fri, 30 Oct 2026 10:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 864F16B05B8
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:43:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10A3D1C40A3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:43:18 +0000 (UTC)
X-FDA: 85379560476.17.FBBDA01
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3C63F80012
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:43:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=S6IdhD6R;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Jwaw2UleKbt3+Hq4DNJ57UL4tgRoFdi0qcWUCznp/0=;
	b=WxRzAt6JbAbu30PnWtPh35ha2ube189DA3/tgJh2V8CMMJvXUctL+yoL1J+DY0sogrObxJ
	RPxr3uLozctQc9LRfwmFkhK2IJiR3d5Y6UYAONUvOsD6Ogg+VfdHGrtWlW+0ycv+GR51N+
	aFtpK7knjG4ThCXRBB1S+GMTI6SIVts=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=S6IdhD6R;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371396;
	b=YSALbK5zJiJ6GUxw9bFufnjeRazNaNjCyOmXNEdpBPRtJvyKWK3JvYsZTTMz1dgzjZqkMV
	g6FDXG3SYeacrqW9Q9rYGG1Tmx+WM5iZ79pkoVhGR1cprdTNKn7tSgkbFCR6Kl0g5eMLwS
	GG6pK5YGpxwMQs5egjOPYRGOxTFr69g=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso4990435e9.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793371395; x=1793976195; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4Jwaw2UleKbt3+Hq4DNJ57UL4tgRoFdi0qcWUCznp/0=;
        b=S6IdhD6RbixphlTZ1kZEv88zIIr3VQ8lMJpLOaBqHCWOOBRun7Ud6QnaBDpEp9QoJ3
         7desh+yLQCsuo35SXmbsxOxG5I4rk1h0Xy3kZ6ajMVyS+mN4PnOg/pjy4x6G2eO5bvNs
         xGZWYsHpTYkBitAG/fESjVhHlczosO4OPN/U2rLyymkY8HjgwouaNKYjmPdpoya7xUg6
         HsBpfQhoi6q4+MMx9pbbz5Czs6NAKYyou7KJve3RcI0AgOJmkwka+4Q1uuWElTFjBhFn
         WUpAjcYEl5x9Ym18axmtchM3TL4gCD/PyzROo1FegHu1dhZuGyWCWg6kiB64/0/W10qs
         sNUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793371395; x=1793976195;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Jwaw2UleKbt3+Hq4DNJ57UL4tgRoFdi0qcWUCznp/0=;
        b=Ps/aU5me1O1K/fvZ6W0cp6o6Rh7JgaRTOH6mKfY+pjX4f0LjAYR8rEdvilG1FOHVwj
         kB8Sa2hip5tiGF+DKijYPMkpIAZOvnp6IOJyQQ1u6UUMAlpc4MMkIqX0dj1n14LJZVbC
         pMrQm5/3zDiAxhPI0asPui+jtB37Lua/L/WNuAxYWUfKBqMnJupyAGPa6SjkkYSn4ZUi
         +OHI3pmo0QFklFj2jL7vFT+HIy228pP1yrlO33XuJ5sADDMFCSeKNouxbN6VbA2bglDm
         E8fz3ZMG3Ks+eaWgaGwMWF7OOAkGpmTCrtvr6T1ZTV56nUxM9/SQlgckVFj2g38Gl416
         LQMA==
X-Forwarded-Encrypted: i=1; AKwUvBznNiVnxEKw2qbuFQSQm8GlCcie0PNJUdes6sR6OkCwyOGx1tdweTLm9x8mUYD+i/79QsfwXn+U7w==@kvack.org
X-Gm-Message-State: AFq9FYIHImp1/aYZKk/5jWNZZMFV/4SA64hdxeqaIxJFpJaMPP1BPFL+
	mG1IrqCdxTp3CG8gUqJqSijrQNiAGtsIntOB8OhfSDXPqmFuBfrAj9E/wEzVLX1SXKDjZwgPmGg
	hHC26VrQ=
X-Gm-Gg: AYBFou0aUMn5aQwL1VWPuQgFfKIzWDYOisA3fehl7caMbr4IHdqPMnyDO1SIyil8QKu
	1DTgy8MBy7Pw6RM0g3N5Ywj+jd7+/yxCnCz4g//WDaeiil82ntkhXbulBxtd8UsMNRcWjjX6H72
	4yiGKNhT5Dlw8ZcdInKxqgd64+izX7SdsWMqzQD974oV69Cu2nPQk68lU9bYSb9lqDlxIwZgOnv
	sc+Ax9j9H1gdl+8LvTfIUdlWX7TGsmu74HaNbEcl90FH++LjYZ3Ngjpjeu3W6CSetW9Eg9XY30X
	eRmeIPSjjCsNcLx6Vqm7Zrjo0aED/rL/ogqDhi8h8+/IeWbqTIWKcJ37XaEuYMUZgSpufokYWlE
	o/UQfKOh8sR/g7sR9RxVrZXzVdfMWTmV1zPh+HjkEStBlwpJtL84/tP9v2aBkCFG45n4q/Pdc8p
	ruTMB8GtXiua38UVnocTbAWk/YxrqtGZCJwC071RibNIkyU8axKRLEHoKhh9NKpfZv0Y1i86PFc
	yv5Gs6r04b6ow1Dhd3KERq28N4GPs2AVB+kPePoOtN1r7aJaFtV8ku7mwprZ3UXYyI7O32WlJYZ
	78lFv5Ois1KEkKq4IfDMCYqrdkZw68V6S3sgRLUy5VYWNg==
X-Received: by 2002:a05:600c:848c:b0:4a1:f99e:f22d with SMTP id 5b1f17b1804b1-4ac17471091mr59608195e9.6.1793371394932;
        Fri, 30 Oct 2026 07:43:14 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.255])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abebe33e79sm48149185e9.2.2026.10.30.07.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:43:14 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 30 Oct 2026 14:42:47 +0000
Subject: [PATCH 2/6] selftests/mm: test a partial mremap() of hugetlb
 memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-b4-mremap-pre-split-v1-2-c1829811aed0@toxicpanda.com>
References: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
In-Reply-To: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793371378; l=3122;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=QkeZMYQh4gDeDNlflvDbRHwNhuthYdJVeGDsjtdTxvk=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QMT0lIas7GVYEwZcpEiD50+/aaZJS7XBMjWN9Lp3Vk3L1dm5nl3ggYxT8xjjexLglYqxDJujXpb
 Hj/RmAB0ObQ0=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Queue-Id: 3C63F80012
X-Stat-Signature: yh4wxf3zcc67yzjqkz3eg81bamx83fgu
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793371396-755273
X-HE-Meta: U2FsdGVkX1+CXJ3RCWIGXbb5pDve69f9BpbjTdx29aezsu+Bv3/aEYLObxj0BnaFZaqCBkv1dAW6rpBRxFdoeUaBg63+KAMiY0CSPPOohLnyKZ2o+CLxgoBcYgrB6aA6ZvLxUsjg2ZCiPjvR5ITfviQJGCm5iAuiwMFytoCIZPYqpfPt03jEhaVABSzepu7abidvMxnmU45VVVRzifOqQ9DOhMw6VRp98WOhGmyG0HKcloQ4Q0zSaWfuiramU1F8flLhdXA5HGZduNg/b2rdoTEkMIrk+5okSM6oluh5NSc4h6kM7PTWr91goH1QIgWJahTx737d2Y6NeMOCxlgnlAucrDS2Wn0+RSYRE3xi4cegnbdr5Gc0N4h+Hc1Ps8R0fIfurAJBReYClFwhUOGHCVOUXRIhr+cEKJ6/ETmxkNggd7vVtU+7ih1tDCAzKkmDnIY+4EuO69c/9pn9R89darRRK3gsa3A9ZJjgFAbk92TV6SF4B3VTDiLLxh7/ju7HkNBrmZhXG6lpdlZrFQFZM5VXKMm1khTujS7MrXwUL5DGczOoHCoUkIMNJKJWEp0qHd2g36tbMmQK/CxPUgKLuvLcTRC49/+BO5EU+OraMoKlkisezK+HZ5GhGS6h42k3u/MIf+kHE4Z4nZJy/MlefbWbHcQwHvJmzY8U8IH4T6yskjzMoMWjvsUCO65E6W4ZEkeh6F7qrDMcMNcHq+3JRM7Wi4p2e5pt0Ac2H4fNSz32RLK54uqadt124050UVGzGveJKAqJbYMY2fRFHGRZfu+F/nk/tovxhqv5LjKrqmDpN4c8toJuNXytwSmz9PXMtrxDz9CCc9ionmRxRu4hqi3R66rMyCfdQD9pmhE3/AGeYNLHc0PvHqSrA2k2t2SL2AWbbtlRcfVygVLkHypCdFFSuC3CR88VjV+C9hC4LGWSpYgoIWd1ueYtfiiFmkVO8t3RWtuBO4Q0YfiE2gW
 tAnqSFyr
 iD6rZ5EHuCnNaRqf9EtFsdAVHsaQXvk42Ehdur3lY6UVblYYuBWpm7IkKa8rRWs/7QOaoZmQmrtaZvWDxcbsNASKjJg2yri7L66EFiKh/bYf4+0kwQDaZPDEYg3aoeG/0brdnqyRAmIW33TH4gN/qR6VBV5W+ifmisPLiQrp3Mja8EGACkjW264z6bNYF2knoYPldQ2MHRuNbqENNVz+C/V+B7IsBdrNu+G48F5Lq+lyWwiHtw9JDo4v2O+27gp8QgnirC5XZVc2Kt4+V3+d+WwhvGWc+VnbRdX83KRkabyF+nlEnsSU+wbxFmLLdtc2/MIusU69wNMaJCn8=
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


