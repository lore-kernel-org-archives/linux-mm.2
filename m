Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DBD8FF8850
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15F56B009E; Fri, 24 Apr 2026 17:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A1A6B009F; Fri, 24 Apr 2026 17:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C946B00A0; Fri, 24 Apr 2026 17:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6528A6B009E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:13:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 342ADA0105
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:59 +0000 (UTC)
X-FDA: 84694701798.24.C35A700
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4D099180010
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=go+3U7lN;
	spf=pass (imf24.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777065237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SCrW5HFYPqr8TJuXxIupeIWbyph75TP9QqH4Asf6mk4=;
	b=z9JLMTuzyPX9ZjQRhjep/uSOe4RuvFMulPfSgkPJLNbPBsuTX0UzRskpHCvsHUCFjgGoDV
	OzqWx38W9+6lI4APdT/K46M8ktdEkZI6/CgddzvcrwYGEY8F2rYHXBP5T6kqazYQkMBFoI
	pnuvaglQY+I1wcpl44aUqSMYjLuxxfc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=go+3U7lN;
	spf=pass (imf24.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777065237; a=rsa-sha256;
	cv=none;
	b=X45CI7dseOrD5VMmbsBssvE3woiKTWmoxviQ/gs8uA7R/aOdmw31kFwIC2CKkuK9LWlh1b
	XYskuooRTB8m+O141iLNUA+/ZcZRI5WByZTNifm7cH417CO+VDmgobNMDuqsdryJZf9Fex
	PySOwAmh/pcN9kDyaXtNqMik3odT1uQ=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43d7e23defbso4990880f8f.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777065236; x=1777670036; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCrW5HFYPqr8TJuXxIupeIWbyph75TP9QqH4Asf6mk4=;
        b=go+3U7lNxQL/4iVXG+yxz06zVGcjhxn9yWTVJzfihS/GaRuZqiPWIbw+xou2Q9HDAV
         Vw/0cyyTxjU1alBUQhl6YO1Tk7gwtXWWAQmh918OWnSnSpVQ+31C7G5/WxkgtrJZpeTc
         DxjjzdoaZvUFrgO0fLRmvxg1mfomvn5st/oYPLFy+0y2c225Ng/H+bjJlbRxws3xa+Q4
         zgNaU/7Tbqm3mWoFu4NSN5tjX5ZFde1mkGoScY+Em4HofV97dOAAc0iEHRtcrA8L0vi4
         JywHfv52FSheEM591+VHxioaeujpvB7Pq4O4aULeMleo2FYR6op/dJkP/CHb2LhG6tMI
         Yl2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777065236; x=1777670036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SCrW5HFYPqr8TJuXxIupeIWbyph75TP9QqH4Asf6mk4=;
        b=IiUpaclsC6QSMQWlS2wLQzC2BW11YPZXfb8ALolXWOtwqF/c9EfP4hmgIpKgbXUwuN
         rHiW7Ajz/3y4eVpOHFtLKov2/u9WlYhO9AfcZqJicYG2lVzODPWC9D76YfIHL9bwK9K6
         q2R1ASArpX8KGfhEEurrG/9Foga1BRvQzAqbH3TiNWz/f32bMQNFwwRbMY3r1Cqr6et9
         fD94ZziWPHwHavXeVtDPJY7mgGY9+wW7KmjXAt648giJLlzkKt8Yt8uvXkVMxLDcLap7
         2Yb+rkaFs2rmzUE1ivszDV9HFVJeiBsCpbhTF5hoA+JU3xx6xB9cNu+u6bR6WQSkvq6W
         SxgQ==
X-Gm-Message-State: AOJu0YySE77inlt6CJcG88jw0H1EBgDhQHNKvnL3JJ3ApeoGK8N0+DT9
	V4oBlwb56JHUP84AaGu157T5tLrxGaPeoumBZNGG2TM/RriWoBOYDUXoWc/gmdG2
X-Gm-Gg: AeBDietWH0kGQdtTLqxdNPq9r1snrem8FpLsVEKgVkA4EaF39PyRhgH3FGopqEA8zR3
	Yq6NCuDeecIpea+ijqco8r+ZU5VtrQmsNQ/+weV1PsmLua/CCmGJCSB+psS4/afYMs4qFXIPX4p
	h4W2JELj+rOtIgmlJapQAVGD0bi3/CVX/nfWWZYxO2kQftdbqkYD7wm0FeDbPPfxF7W0mCyLzZL
	kC5avFJYckDq2z5NjTMDKg0WJT8QXvI5htJaz/l531wraWptozTodP1TlU/vpfYLyw7FBSqIoRl
	0Kjnn++MqlmFCM01UxE7mhqL7S8NTeqTYdREVstTgUjSJ4yVTVwtwwzT/Nj93KqDXIc9EZUPdJ1
	KZQMGfMNsJKRRWfsFQ9anaaTzx15EpItlzDyw2QjuA6m465EJjrlf7od5iVvZwfHJuCefKsi5Ko
	LQip0Bub9BbYvAg5wPSjwYWB2GAvWNtvm7uxqOrd1t
X-Received: by 2002:a05:6000:2dc6:b0:43f:dbbf:6d93 with SMTP id ffacd0b85a97d-43fe3dfd5bbmr51149032f8f.27.1777065235722;
        Fri, 24 Apr 2026 14:13:55 -0700 (PDT)
Received: from fedora ([156.207.128.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1176sm63845677f8f.3.2026.04.24.14.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 14:13:55 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	avagin@gmail.com,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Jann Horn <jannh@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Ahmed Elaidy <elaidya225@gmail.com>
Subject: [PATCH v1 9/9] testing/selftests/mm: add soft-dirty merge self-test
Date: Sat, 25 Apr 2026 00:12:43 +0300
Message-ID: <20260424211315.1072123-10-elaidya225@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424211315.1072123-1-elaidya225@gmail.com>
References: <20260424211315.1072123-1-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D099180010
X-Stat-Signature: n76pimcjpqyxqdixau7y7cqs7n7heire
X-HE-Tag: 1777065237-994550
X-HE-Meta: U2FsdGVkX1/pbzX4vKDQd3crF52ZZj6wP0+DH2HEJDFOEvSVWz8hpuNhys9s5X7oPd21EbS18EUF6DzgBwgshAE80SMOQGYId3feIRkBJYqsf4qOvx5JZ+N0TYiKwGZMOia+Ihy7f/N04bV/6JGe17U6JAdXE34ZQ1CMwEmJr9Xb8EraPdIpwyOSDE61i0xeww04VnlLe14ewX8Yq8D0R8YEPG9bz7TCsBSVjMqu+ntvmIHOI661SaSYN5L9W1dBcmywFmebkJnkwPxVU93U33AlrnvDtfIsnpo0iODCaoYHWHEezpoHdckSyaFOAIjbzNqBXB60OoltZI6B157UGAcPVjINL7t+TPQSvNcu+QekEYI7L5lhsjvTMQiwl/tLO8GZVictU0e20ktMFHeOPoyeF5DQ/060gR6SjT5IplAEgc1RL8/LhzOoMXVI9QNPVYR23DbV3gOhqz1SfzwGU+ZN8M+/a95s4EDNwHkrYZZB1lwJfUxhoTVBFpF7duV2HPY03dpFjkdhJ38Pt2n1qSnJNMfGogkQ21z7JWKnV8APv9n64MyDbEq2c9jZqkohgRAj8ajABOuDvM6d3LBPBQqBwO6cUHX7PaDfQgTJSCumTqMUcV048Pc0H/Sazm03/7j2f65fK5ykbDy8JsqfyDx+EXPDszdm/bYhZ8TDnk8INhA2iv5msgul7eojBX+0tTXr8pIyCvrwUUb+96mhcO95fou7L9OurOXk5AQOF+Wcm2Tzgo/6bb1fYLBuqXgL0+uTuu9IsGRNI/Em0abtiTi1G7gnVImhjYVZIulj1kO5d7UuTWeM6A7sJz8IW7XJGNQQ3nzqfDKdS9GFhLdeBmAXPUNcjU2JmwYZcE1w4bRZh6hQG4nyoiV2ofLoQJT+jRLSJgfx/DNDGZ70WjnVM4A8PSEMRNyIlLk9HrsciyDvX6mZ14OLL63XMDNB4LhlEYdj3s+b6FlkkEFbxYc
 gUqq2+R/
 IljfNHIVNIa7PX4nXTE9ocUpr3Y1ABxlrv0CRFYoe2CvBzXQ3kOH4w3DfT1pjW2yxuV/relRjRSov3Xh7vlLyOOg52gWl6lR024AlNphjh/kyIaxrCN1bzdnsIlNwxZQrA6up0tIo0pBHOa089Tq9j8DlvJ08LZhlPd6bei1D1UEL8stBs3F7fGgIZwBGknb4BesYBXoJlNmrI4b7UuCowU1Xg8HToFRlnHWXYtRmhibmGoeftBfi59PyyTUZ8dkGz0UGvFqI0PQqSmINDGb/tJ5xINZ8KwS5/MvMizklEgfSBU7pre6QYZfloG4hi8ktC8yTOpkwU9UIXKB+VakfsWWC++Ru2YoHY/xxY8xovUP82M1fANvJcL5cNF7HJFJAWu/0yJZUUJC/I2Gyw9n2gEuRo4LrPJdzVGNQjZxT3oeLphyoRud3raPXK//sgxRylolABEqTk/2bR3a2EWyIQS0eUhGjjgD1rrK90UoycOpPrv91TTmp4FlzC/ay9gYx4kZZDylReryYEioaP3cem7Tj5yJZjnwi/A3TuUyFj/SQHX6s3hGXkahwZrY5Y10ObhosR8UNMXdXJtpVmjoMn92ozDsCy0gi6bze
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Assert that we correctly merge VMAs containing VM_SOFTDIRTY flags now that
we correctly handle these as sticky.

In order to do so, we have to account for the fact the pagemap interface
checks soft dirty PTEs and additionally that newly merged VMAs are marked
VM_SOFTDIRTY.

We do this by using use unfaulted anon VMAs, establishing one and clearing
references on that one, before establishing another and merging the two
before checking that soft-dirty is propagated as expected.

We check that this functions correctly with mremap() and mprotect() as
sample cases, because VMA merge of adjacent newly mapped VMAs will
automatically be made soft-dirty due to existing logic which does so.

We are therefore exercising other means of merging VMAs.

Link: https://lkml.kernel.org/r/d5a0f735783fb4f30a604f570ede02ccc5e29be9.1763399675.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrey Vagin <avagin@gmail.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit c7ba92bcfea34f6b4afc744c3b65c8f7420fefe0)
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>
---
 tools/testing/selftests/mm/soft-dirty.c | 127 +++++++++++++++++++++++-
 1 file changed, 126 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 4ee4db3750c1..c3a9585de98c 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -184,6 +184,130 @@ static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
 		close(test_fd);
 }
 
+static void test_merge(int pagemap_fd, int pagesize)
+{
+	char *reserved, *map, *map2;
+
+	/*
+	 * Reserve space for tests:
+	 *
+	 *   ---padding to ---
+	 *   |   avoid adj.  |
+	 *   v     merge     v
+	 * |---|---|---|---|---|
+	 * |   | 1 | 2 | 3 |   |
+	 * |---|---|---|---|---|
+	 */
+	reserved = mmap(NULL, 5 * pagesize, PROT_NONE,
+			MAP_ANON | MAP_PRIVATE, -1, 0);
+	if (reserved == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+	munmap(reserved, 4 * pagesize);
+
+	/*
+	 * Establish initial VMA:
+	 *
+	 *      S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 |   |   |   |
+	 * |---|---|---|---|---|
+	 */
+	map = mmap(&reserved[pagesize], pagesize, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/* This will clear VM_SOFTDIRTY too. */
+	clear_softdirty();
+
+	/*
+	 * Now place a new mapping which will be marked VM_SOFTDIRTY. Away from
+	 * map:
+	 *
+	 *       -      S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 |   | 2 |   |
+	 * |---|---|---|---|---|
+	 */
+	map2 = mmap(&reserved[3 * pagesize], pagesize, PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/*
+	 * Now remap it immediately adjacent to map, if the merge correctly
+	 * propagates VM_SOFTDIRTY, we should then observe the VMA as a whole
+	 * being marked soft-dirty:
+	 *
+	 *       merge
+	 *        S/D
+	 * |---|-------|---|---|
+	 * |   |   1   |   |   |
+	 * |---|-------|---|---|
+	 */
+	map2 = mremap(map2, pagesize, pagesize, MREMAP_FIXED | MREMAP_MAYMOVE,
+		      &reserved[2 * pagesize]);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mremap failed\n");
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 1,
+			 "Test %s-anon soft-dirty after remap merge 1st pg\n",
+			 __func__);
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map2) == 1,
+			 "Test %s-anon soft-dirty after remap merge 2nd pg\n",
+			 __func__);
+
+	munmap(map, 2 * pagesize);
+
+	/*
+	 * Now establish another VMA:
+	 *
+	 *      S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 |   |   |   |
+	 * |---|---|---|---|---|
+	 */
+	map = mmap(&reserved[pagesize], pagesize, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/* Clear VM_SOFTDIRTY... */
+	clear_softdirty();
+	/* ...and establish incompatible adjacent VMA:
+	 *
+	 *       -  S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 | 2 |   |   |
+	 * |---|---|---|---|---|
+	 */
+	map2 = mmap(&reserved[2 * pagesize], pagesize,
+	PROT_READ | PROT_WRITE | PROT_EXEC,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/*
+	 * Now mprotect() VMA 1 so it's compatible with 2 and therefore merges:
+	 *
+	 *       merge
+	 *        S/D
+	 * |---|-------|---|---|
+	 * |   |   1   |   |   |
+	 * |---|-------|---|---|
+	 */
+	if (mprotect(map, pagesize, PROT_READ | PROT_WRITE | PROT_EXEC))
+		ksft_exit_fail_msg("mprotect failed\n");
+
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 1,
+			 "Test %s-anon soft-dirty after mprotect merge 1st pg\n",
+			 __func__);
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map2) == 1,
+			 "Test %s-anon soft-dirty after mprotect merge 2nd pg\n",
+			 __func__);
+
+	munmap(map, 2 * pagesize);
+}
+
 static void test_mprotect_anon(int pagemap_fd, int pagesize)
 {
 	test_mprotect(pagemap_fd, pagesize, true);
@@ -204,7 +328,7 @@ int main(int argc, char **argv)
 	if (!softdirty_supported())
 		ksft_exit_skip("soft-dirty is not support\n");
 
-	ksft_set_plan(15);
+	ksft_set_plan(19);
 	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
@@ -216,6 +340,7 @@ int main(int argc, char **argv)
 	test_hugepage(pagemap_fd, pagesize);
 	test_mprotect_anon(pagemap_fd, pagesize);
 	test_mprotect_file(pagemap_fd, pagesize);
+	test_merge(pagemap_fd, pagesize);
 
 	close(pagemap_fd);
 
-- 
2.53.0


