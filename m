Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8606A606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 23:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=H836kyXQ
Received: by kanga.kvack.org (Postfix)
	id 67A396B05B6; Mon,  2 Nov 2026 18:46:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652116B05B7; Mon,  2 Nov 2026 18:46:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5685F6B05B8; Mon,  2 Nov 2026 18:46:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2513D6B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:46:35 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E3411402CD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:46:34 +0000 (UTC)
X-FDA: 85391815908.10.36334C0
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 74A2A1C0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:46:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=H836kyXQ;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793663192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VEhr29c8gyijeO9qEC0lOLq275keOso6D95qcCo+TBs=;
	b=wQeVbirK8lPLfvAOYtqbrbvHOadhJ2wFjSuWv6Djto884ZJyh8dEUoaxU62qClYkp+zsES
	QW4XWW/2f9aaZec/PGkMJbHLmRDKB+ySWNlYCvkzUiS++ZJ97Ir6ZouyUKilSP2XCN11C+
	vATGZy/f8XzjPjGtNUMDDz9QWkQfiZY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=H836kyXQ;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793663192;
	b=3bVTv5BoUZtsBD/c1snbX/LSpq+tJKTfBwIUhwkLnvOyiNN/uOCtItTwEgfWB5y3H9n+Ji
	j8P8QxCTTjVGfbuW7wOPHIQAk1agMVzJGKUvs7zzOoZmDegQmAYjOQfItIfvJ9PAyfdFPn
	f8WjLHSLffaEeNx2r36HD+1mifZ8gNY=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5365f9a04c5so60780791cf.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 15:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793663192; x=1794267992; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VEhr29c8gyijeO9qEC0lOLq275keOso6D95qcCo+TBs=;
        b=H836kyXQwgjauejdUomQBPIs5/eRfsgjXB9xDbRBfl70249zH6XKVQ/EzKwUVl6n/n
         K9O7R+hJhLGUSDGErzRoodnG4bmLjeQiphmaljrvBe9duABtxS08jDZaTJL0sBVPTD2P
         Xj6uxo1KjNUQQsJrgy7auHi56peKqb4YLVaZQLAvKP/g4bRxXlfmy6tIu0zB21PkT+ov
         QoewwVghKozY+jq/hw29vg+ewmKU/nLzJvWAq9TWZANfZj4onDeRpRJnx53qV9dTTtde
         2ShtTGM932D4iuwjZbpzdG/+kEjbg2M6tHm4epJT/C2xXoku4O5JJ3gPGYgN5NWzihaJ
         qsFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793663192; x=1794267992;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VEhr29c8gyijeO9qEC0lOLq275keOso6D95qcCo+TBs=;
        b=n7MQuqiy4IAQ6t94mJuu0A8FT3clBptEc+gi4c8CpLgD6RALuQ7J8bm599wHG4fVq2
         Obnnc/N0HkqewN2PV5xF2sCwpt7e2lY+rQGDum8j54bKxE7Ac6e/vWwMtYGipCM8f0p8
         E4XJ6yvotsgGlyf0zG7pSWg4U9o0n4edy2r4usUVJi2ggOPrkR3muG6mLAGb5Cisfg+A
         oyhhLTGtw60W6jMwBRdCbEs47ixW13W7gkunupfXsvOkaKU3rqfZdAwwk4sEgDnmIWzO
         lpvoWjA+BPXoppByUe9OBJ8HHO1pVQeKUfuguIn+UaKmyo1RB2U5V5/x3HFvBCNTcO1t
         Q1TA==
X-Forwarded-Encrypted: i=1; AKwUvBw0rSnlu/We+lK3bhZmND8EtPpI/2+KvkwZBakHI0/RW5Cpt/QB1ab+oSL+/o89M6U66+F3SEAz8g==@kvack.org
X-Gm-Message-State: APuU4Z/EWGxIpnO/gBkzoZpAWgukTsdT7idf0JFkIVBi4JSZ59WqTpM3
	PJ2vfAPIVJe1eOPVI2xyA7hkZdHXmIFVuUKwGVX8UIfyAvAj3mF2KbCCPcnNAn3OPp0=
X-Gm-Gg: AYBFou1+KKd2iOatfhzAMqvrvvILphN59E1ogN08i7TokSfFx8TKv1U8QHNVlCq07u6
	9BRVNZxfMhSW+Ku6ng2jhaHNWXmq2hTdbiiI2agcekXzAqbV1STcDcMSCpUsFwFT+ikS7vDtBqx
	RUgcO119t99bGq7pg+M8TYHjoag38PiTjp/ljkTS7FWGaXMLK37ue/cUC1PslY+vV0ODp9kJ1rh
	Yc/Cv1R3LM/IHd1601QRBfQMVMvPQ0m84fiXUZPEsphlmL3go4NfjFzxX119YjN76MRvCd5RxBe
	csCHcX34zdyMv/QeAyuUoBLGmkrDb4HxYdkMOPsnxNxs/pOVpN5WAwOokGRrAybSJnIcthISaxh
	rBCGKY8x1dFad3pEuUjlx5ODoG7OI+mqK33f5eGvnj7LzJRs/+lo0iahvr7rHf0nDrnVVnHc05h
	5enZ4BysQHxfAdiKADBUQbsEtZFyfSIfcDKS2c29nK3j/YDQ01pOw+S1mzNpplnviS3q+eY1HX/
	tlvco9KvmeIfAwVvJ0r+B+xoB3e1Ju3yGP2VxpW6K2jYPMp2I7MeZZm3UOEDX4W0TP/SWgjq0oy
	IqyFb8o5GZv5fBiNcig3h8UZMKvX8g0spNnVM7BfyhCbaQ==
X-Received: by 2002:a05:622a:248b:b0:535:2447:3d02 with SMTP id d75a77b69052e-542b6d60babmr187204621cf.33.1793663191685;
        Mon, 02 Nov 2026 15:46:31 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.255])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5498bb96c13sm10714041cf.14.2026.11.02.15.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 15:46:29 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 02 Nov 2026 23:46:01 +0000
Subject: [PATCH v2 5/5] selftests/mm: test mremap() with an old size of 0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-b4-mremap-pre-split-v2-5-d281dd11ad7d@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793663165; l=3127;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=hfsVQrc3ae2sRc/4XoeY+GmaH6z28nRum1xczIzHD3o=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QHa6V9/Nnk71siY2GCoPWV13AN6v8FYZXdoY/kJ0kNFO6CqBE29TJHHhJBmk6dv87jSvRgQek9X
 x/nEJGYd8iwY=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 74A2A1C0004
X-Stat-Signature: 7aqz1qjsxk9a7e4pinaqmnpqsok457sf
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793663192-6888
X-HE-Meta: U2FsdGVkX1/yOhawOp6LZUx+bLvKXPWtoB46ZPN1NC9jlMlrE3DmjjNM1DxL5TG+wy3Mf3pBERz0cQwnurQfsv4AcYh1X+ucIjpL0A4xMRlDTqjS/BOoAzoMHXpNAsQe/L+eA+s7hvvVtvyehXy4izZIn8sD/PYVzp93JAQ/6k1qNPL4eUwfaqm2J/xcIx68fslTdysByxxcDx9oPUYueXl8LdbzmNfxrNVI0VYgnxIj1lYi3U8aX6HHbAMG7cPYjsZ/NTRmHiERdm3BHMlSFUWg9CxMn58h7n1A/6KIRaGtmQCX9oJJq4VihkHTFTLIyGvOs8A9rAOe/4E7xsDQsLPXF9BWND9wB3mDXB3j+3XkqPFrDafJl6dzhkxvBPSgttlwHt1PGWVEPjriThgNsmAPoXvkII1Fyiv2tz0Ek4mfjGn8jqMuoWMvrxTgsKc2ElT6finWMU/6v+auAy1KXizi+TH1S20D0piBbq2ub/DA7lvjX0eyhFG6U/8pTSFgF0lblcZrXYx5dROdWst9Hhw6mu/NPY2cBmvSWv5OtBANl2IjZ6ZF3RW7gIBrnEm55kwFDwrLmnm1lx9+yT/3Hu93A2fxehgyi1GMWuxk060bXWZpKBH5gi8x6D2I6q1IRrx61hddNa2NyEAGFd0gXke/V9otZntlfyCu7c705d+3oWW6L8BITBNzXe23pw2nmO4/m+3PzGwcosWsFtRBTVTjXVP0gQWfexMLJT2fcXsUX8cI9JB7a8bkqwvIYq63FfzlwXYWtotK9u0xJ0KxVbS9QOisAA8c6p8xyxuaaPC4YiQCzfZakrm/knFJUzKsAbE5y647G+xRYY5QdJLKOPFsAIogtWepaZDp5SiV81e29GlwNMEU7k8dH/HwshN2hLnx7aVpzdU2ItXrTwLu7sHG7tWMrjQJzoKN6ikt3BpkOP+RA4tViFllkDDmySQ3yLcuGSjGAN2kVXf5ktA
 Wvr27TtM
 40qMcGAjq2vQHNr4UDHgWgBnHNH6WnLb2qmqb2eFi2yj6eVxhXBDQRIcgTpw8qidASzooyQY/XGC77IkmsMJzv6d/3EBBfe0s+PLzC0eNFPqogEGGo2qECm3kToG4K3Zu3N/EQr8Q3dyD4jeWSfU//S7g4L2leuyjM8M2F9EE5iQ0fRxpLslJrEZVTpERWF20cFjRAXMAV2COmNc7U9wlvNcVAP/zPhmvGLWccRqJvhWWxkOqw46JPp4hJESmc93w1NMEtk5wbUaKPb8VUMc6u0a0Qxhoo6OsDVmEczrrN8yV/OqzpDyf2GjSJogGcZPh6yfvDIk43VlrbswAoaZXLqxBgT8g/udSOw38OlhOpQ/1hvU=
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

Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/selftests/mm/mremap_test.c | 52 +++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 31b484517bda..92960fff9537 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -603,6 +603,54 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
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
+		perror("mmap");
+		goto out;
+	}
+	memset(ptr, 'a', size);
+
+	dup = mremap(ptr + offset, 0, dup_size, MREMAP_MAYMOVE);
+	if (dup == MAP_FAILED) {
+		perror("mremap");
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
+	if (dup != MAP_FAILED && munmap(dup, dup_size))
+		perror("munmap dup");
+	if (munmap(ptr, size))
+		perror("munmap src");
+out:
+	ksft_test_result(success, "%s%s\n", test_name,
+			 offset ? " [from the middle]" : "");
+}
+
 static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 					    unsigned long page_size,
 					    bool dont_unmap)
@@ -1248,7 +1296,7 @@ int main(int argc, char **argv)
 	char *rand_addr;
 	size_t rand_size;
 	int num_expand_tests = 2;
-	int num_misc_tests = 9;
+	int num_misc_tests = 11;
 	struct test test_cases[MAX_TEST] = {};
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
@@ -1385,6 +1433,8 @@ int main(int argc, char **argv)
 	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ false);
 	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ true);
 	mremap_move_multi_invalid_vmas(maps_fp, page_size);
+	mremap_duplicate_shared(maps_fp, page_size, 0);
+	mremap_duplicate_shared(maps_fp, page_size, page_size);
 
 	fclose(maps_fp);
 

-- 
2.55.0


