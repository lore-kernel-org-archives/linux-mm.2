Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E6B606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=FgvmAElR
Received: by kanga.kvack.org (Postfix)
	id 072DB6B05BC; Fri, 30 Oct 2026 10:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3F836B05BD; Fri, 30 Oct 2026 10:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08256B05BE; Fri, 30 Oct 2026 10:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A01AB6B05BC
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:43:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A37C806E2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:43:27 +0000 (UTC)
X-FDA: 85379560854.26.C55F1EE
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2148B140002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:43:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=FgvmAElR;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTuzWtQbQ2HkxgNHq33EPK3TwXUuv2v1nQRDpVue04w=;
	b=64FECM5K9kJv6WH8azMVrCS/AIQXcAmBODrkZpfYgRGzUNYx7i+ovFljmcz/kc2a6qhZ5D
	KqlbQhwf6/jPXvdkzX7yw8EJhSlGtSc1lGr0UBc2z9U5dLIBrS4Ydqua4mcPmPVF4WMUs6
	mNMLOZfVAUuQeVJQEGeFu9eJsLdwYig=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=FgvmAElR;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371405;
	b=LDqCz2Yj4021SKptNTfTNmSYuiU0h0eh+PxYJh9c5I7du5i2LIZmwMSMm32oEGG0PVKN7Z
	HHuBf65pE66T+CVPjv5EO/Ev6iHa+FDSJinPSlxIARgGBETUB3+RPDdUN8wiSS5f0EhnXd
	A7KTpX25iTPZUogUglGMKnSUIvgPgG8=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-53fdd2fb171so8774131cf.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793371404; x=1793976204; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RTuzWtQbQ2HkxgNHq33EPK3TwXUuv2v1nQRDpVue04w=;
        b=FgvmAElRpPceXWdevd24+O53RAtTa6d7Q9tox5ohX+ATz2AmL0uYXpIKb/HbO1+lM1
         Eui/41CuqvqzXFYJK2hIEH6wNUM5YtO8mbj15zJA9w4i7DSpDeWMlc25IFpMTxCnHTVR
         HXOjjQezjgjj0AYOYFZKj9e3J7r02ztL0cgT/02cJ60HHBygvkj7hnRAMLTTure/A6sS
         5/HE8/PEsH5SldCuh25W1ld0HWWhs61T2Jf65LJAWAkOq6oCjxx867SxVGko8AednVxS
         zYv5C6n4k880xa0b3W4Bylc9JFxJz0RZG71Mf4pJYlYrraDAtCo7ApakCXZO+SnIYYOn
         hptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793371404; x=1793976204;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RTuzWtQbQ2HkxgNHq33EPK3TwXUuv2v1nQRDpVue04w=;
        b=YYesRdbsrSHeCAt5LwdIkJJEGY7g/6hQDbSO5OiRa3Yvg+MMVm/iFPOKbgyoFdeNbF
         L9FtIMc3w5CiI1sm+IVAx4fK+x+Z4R5yAgjRkRmy8BSkX/0ERhV8HoljaFO5Qrc00sbc
         zXCLbl0a+p+Yn7C9s8MO1EbtcIZeEoPjYE/MCRrvV+ptQGxc0dEdrb0BXbbkBUgenecO
         fl+KX5gg6+ARa5aYJngW8XVWTwNML5mFBcPRtsSzb6f3QTcep/NDD5awpiH1avIkbIKP
         AfT83csrPByrcHqeOV9InCG80Jbk+HRQihqxG6eqU5jWZ/ONLS9XLLi5b9ittXzQZziz
         B6wA==
X-Forwarded-Encrypted: i=1; AKwUvBxJWv4voUoJkeKjclhXNr9Dg4gtJHI9yGhkjENjQZv3HmdtoIjFS9A6cYr/Ocw2gj0fhyFjVNxDXA==@kvack.org
X-Gm-Message-State: AFq9FYKs3HdYNP55pRrbY7snTfm9m5PaBVwK5PapO78k/ix4zlow0QSk
	ZFG3FmmaqLwRi3gtBxKxX4y2p6ffcK0xlipT8GF64iu0RTqd1oLDwfn9J5ZF9H1eqVRNuNxRvSM
	mCPOTxwE=
X-Gm-Gg: AYBFou1YbiO7BLpVoIAsSVFtK7nSB9jCyPsAAIIExZ23yTFCL6Fd2PwpEfTO1UcO+1J
	I88sVBE6U+gRcCKDEiA4Lp4IOwJvX2ikve1I7NuAlQqoxZRcSKTHofC3w9MQJquvi7+5GVF7PfL
	mmED3IDA1zn3tn0MN4yJmETPnxuQ3+w0GK/ozXBwhQOpcTpyu33rtokDfZXRbw3RqbEFf0DgsyE
	8YQhPW1g+jZlvHSn6O2ZsMMFayfF1SNTROcOGHD5x/ZZ9FJpN2DHmE0j/gFMRbfimBtjIhoA3/3
	l1rc0B7/dajlcHqx8M8UZc/x3jK9AiRKrTF5o8epRtQOo/AU+dsjJmCItKa96TL4IfDcE8X9igU
	HYNc/b+AduyrOAxYaWKxu+SJDicHTxLYv3Lp9jiH8YxryXW4sSfKRXBBvRnGz/ym4g+vgohq3bK
	cNOqvOTl5VS0a17A4W6hJWAH2r5+3IazjpFD86GT2TofBV0rhJxP/tVb/KvZrA4BbStxS3LTlhB
	+VhPPcgX7BWHmyhUgWV6Qh8oWiwmQBPGPOeXRPiGWXlPg5yvjdFIwSZOeQux2PLb+QuMITQWB3Z
	KI0VOOj8smqi9kRtRIHY1H5ZXh2hflNLisTUXnwjh6gTryA=
X-Received: by 2002:a05:622a:1c19:b0:535:2e9:e474 with SMTP id d75a77b69052e-542b3d6f370mr37043051cf.4.1793371404076;
        Fri, 30 Oct 2026 07:43:24 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.241])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca7f26f1esm17036516d6.13.2026.10.30.07.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:43:23 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 30 Oct 2026 14:42:50 +0000
Subject: [PATCH 5/6] selftests/mm: test mremap() with an old size of 0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-b4-mremap-pre-split-v1-5-c1829811aed0@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793371378; l=3075;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=v1DGv0oagVEI2iIdtyqpcgvCANS/oPqwtHXQ57ZdeSM=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QCmnCdqYbSZC6rQLDgKLHFo3GWFSFtXmDUWK7+Gfk3CNLh9NCptwSAFssJKzU19K8bM+UP7IO3P
 ncZxlNz8+mgk=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2148B140002
X-Stat-Signature: 9wk3xu1a1xfc5p35nw3icianahybyh3p
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793371404-340508
X-HE-Meta: U2FsdGVkX1+BGOXaxMvWk2aItJZU2zLKuDrAHmTAGD+pR3k+SSEHh1M4kFxH25+6lifbd6sdGzR1jtQuIaGnBQdExFykP8VIrdB+ceUulwrfB42XaCxSj66LtBjI7hNliz/5d7YDPVee4akrJfQ6bGX2LPew8lhD6xBc/6AhmaB4vS2RPabYjs8qayS8/dDVHCCD/lqr+CUbR9Z6v0mW/FyOBECjTmj0gec0fDxuuZVNWWR1R2EEUqSCYm5u6DCzikSdsWkOYN4E2c4bbYoeyB2Hbq6KMOHQBcOOgNCgkhAZfjMS05W9L6FSI/B9UBN8CuK3KbwIm9ArU5B2fPJLaCyKMl9sVQtF89ppbYIKTCsbv0z+N0cK3/CZHPznxJOU53RTVmWVY9OYBeup6fRX4e5U0pr+SpPc6g/GdfXdVsCOcXPF50k4xxJWE+OPSLqwKH2sSWUbdwgw/k2qf5q/lK8kIL1FXUyXqGSxZxPwp7tyFzoNrLhJrs21FyRuCGVcZ32LLgqrf3m5iiR0YB8qDGCWG8qCW4sq31nbyuuhqQEgnVzSdIaKvdL2kKdtXOlMIxpq0IM3iDqU8qUJnBVtZ9n4CR9uUCLlUtWF9fmLTtLywmkn1BSlA1B3RHJHXMy9f9BM5jYvUI/hYfb+iy/kqmEioE6ZnzdadEWAu33IzQipt3PX3kmQRjPJskM5L9Th3HYJgfdlGl8kc9PNWsM+Z4sXRsCfhodkfqI5yYx1C++9GtjgRRkMmdgohUQp14xszghQORd2N31WR8rIoO9jIZEZDfM4Px0dQnB8CfshwHAtCvmpi1YgkdMbQ0NrO+refOPsooxExENB8UMdi3ut2360SeXc6Zp0+vSyfAoZV3c2BJW0JEE4fHViTjPuJBFDsJNO4KeQT49T1HwCa8NLKkPaxOey7+J6fe2mIxaU+DRnXASf/Qz2O9K+EQPXxmq9fc4lHGpQFuyBERqpslO
 Kfe6WnAD
 f2870JM/rxnFTv7J4iu51bg2pw0wvb88kc3BwoKAzJEneF+UfpxOpe4Uv+D9YraVfVylw2MXqMNtsByJvkPEr1VQUKAM6pWeri3973k1N4QOVNHQWuIITahLTFgAbZAR3ox7V2rni+DaAz2xTIPH7d+efoy4L6wbiD6gt6OC/l6DMWfP/MTqvAyiKrR9K72eeO9N9JWfLywMgn5uqz2RSfy4pNk7qSQIm3o+P+qH73zS6fOUKyCm7IMY9iPjEc8C51M51b50uDoUfDv6tCf5x8r/snClh2CKPgr3EXsxcty7vwtyAAMlb9lBU1RQZ63cCrxyuwn3W0XMetfg=
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


