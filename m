Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15EFECD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3EE6B009E; Fri, 15 May 2026 08:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795086B009F; Fri, 15 May 2026 08:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CC76B00A0; Fri, 15 May 2026 08:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1156B009E
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:44:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E085A120313
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:44:13 +0000 (UTC)
X-FDA: 84769621986.28.19A6354
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 099861C0009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:44:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="j/OaVQN+";
	spf=pass (imf21.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778849052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44OAkEa1iWy3QKChD7zwC9IwZGlw448V09DhbTLSUUQ=;
	b=RY0ESVNc+Yq7x2eQLBz2XPtK1fupSim0yzN3IeLoSSu8dB9g8qrQb6OSZqKQg/9fmi45JT
	bWtPJUAtZy3Uhvagj6oZ4jbu5IrZXVmIZh5CyidTds9N38dZVSIHGLUbBkpf4UyWBf5oR6
	BkwFNrWvZ4QuFvLAdT+9+ByRUDNvDDo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="j/OaVQN+";
	spf=pass (imf21.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778849052; a=rsa-sha256;
	cv=none;
	b=dvXuH7iask2Qbjk5oV7tlGU2OIfWKI0KC3lTDvFFf3wIO8oQej9YqUO7JDgOovR2pVZTLQ
	boed5CKDVcjLXTbOs86W+JrS0Lufqmn0KZ5k2CW1Qx32t96rjFe8y4AEwgnkk/mVK4sYIC
	PzFhCOHqKtUtnhn0oon6RcLlqxdvMGA=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso62471205e9.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 05:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778849050; x=1779453850; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=44OAkEa1iWy3QKChD7zwC9IwZGlw448V09DhbTLSUUQ=;
        b=j/OaVQN+ZcMveWSZiKbYZt//SvoZUeINFU4K2RRHGea0bjftcM1dfy1E14lNbE2j4C
         nZH8YgO+n4AhHHZmUi8+XMCnKSP6N5pOjrySTMhvKKiWMwW3IWg+qLioQJ4vEQnt5D3W
         mQqxCKOn+HKytp8eiUS+7jN5xdrkjI7b/NFWjeRFdq4YOMsE0C+TNpn4fc37DUBjxdKg
         QpOyiWgylAHrJPVMV/g2jxzS8Lz7G0mnDqsBaJBpSB642Sa4VvKtaWJf35Nmo1FK7iOa
         LWIvJZDV/NT4a3dJ/R6JIxse3KI6Nro96I3Bjyhb/0ZUa1Thwu5nsnpIYlW41R2R1J1s
         GLiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778849050; x=1779453850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=44OAkEa1iWy3QKChD7zwC9IwZGlw448V09DhbTLSUUQ=;
        b=i7huXvQN6TCSOThF5fBJhRiB0vUyG1mAV8FshKDxwvkG9ZEqjbrlB8nWT/7AQIVc7d
         NLHgf6zX76xTGgtoKqOJyAHdwZS0USIqbrOSSPHkteIefY00oZhip9lcW/1z+BOmqvqd
         TqBH9W7gD41ShSZlwTO9iFyRe5t5H+WPVOY15VkUibi36yTE7kaVfWdioDrA7w/XuFWV
         kTns1DwrPyctSc3EDKbP3+ka8YYT1pN6tU+TaPfcPRD9BdLiltg3FoPD6CSkolfYoJ71
         cadjvdOrDdQs0uvDP7Ohg6xmKiIbv8+oEDoQdilVN09qvZAYFkKvAVMeOfOe+sKsn+Pp
         hRNQ==
X-Gm-Message-State: AOJu0Yy1kwJmCujVEdpTt1doR9jeBB/DYzjEnH7Ft6LK5DiFi4lyNOML
	C9mHSLSvvXa4KDTaRFTcOdU5o7oyn2xHkY+inNxHbIr6jDQjvWB9yjDZ
X-Gm-Gg: Acq92OE5Pc8fE9UdLNRJ1jPBGYAePW72hfOs9LoGw+waiOBD7W8SSaxuvVdO0n8UkOj
	IN3IJVh7taYz2lJmjjfXielAcXbfP9QkmYR/1jGXLwLc5XkbNzfvFh0eT4Xv1iMl+yr36IwwOza
	ugwcAJyJlSUdjLuTycJIHo9Bfir754p0vsQoM3QKUvTZoFEgy0Z2UVhqsOCZosUa8yQAjrxGslj
	+K9Cc229nWHdQlq18a8tIRiBrUO7cvCa6fxT/nw2ln1CcxD5KzCPP8YVqqPVyXwi7tALyC1R1kM
	GkBiwFYCBmauFdFFbm9pyyqVg7l7idS3/mTTu0bpNUcjii977Lura8wt1z23TJ/GiD7ZAbIzyPU
	ipqBzVfYETSIwDtCIU+XzLsuWBFrCloJYi7YdZTAP+vyUgogBW0Girjlt7q0sA67XdChD+/CsNk
	Tx+4EQ+FpIyw/bf5Ma4io=
X-Received: by 2002:a05:600c:8901:b0:48e:526e:1040 with SMTP id 5b1f17b1804b1-48fe63021f9mr43573385e9.23.1778849050237;
        Fri, 15 May 2026 05:44:10 -0700 (PDT)
Received: from fedora ([156.207.183.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c8344asm100188115e9.1.2026.05.15.05.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 05:44:09 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	avagin@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Subject: [PATCH v4 9/9] testing/selftests/mm: add soft-dirty merge self-test
Date: Fri, 15 May 2026 15:42:19 +0300
Message-ID: <20260515124218.151966-11-elaidya225@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515124218.151966-2-elaidya225@gmail.com>
References: <20260515124218.151966-2-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7qcegfdobw9j9j9a4yf1d48o6xgj96xy
X-Rspamd-Queue-Id: 099861C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778849051-177949
X-HE-Meta: U2FsdGVkX19TcvF9z/EEpvghhSOYq2L9Mg3du01+e6f98ZL+U2sihKOV3vSxBPSj9mGvAnSIudLdf16xkSfhQzIzoReBEWdjpIgGozXU2nr+yoUJNAaNDK3dG9JDwDV4fuG8r8pg5J1b7T2xICSHdmjbA1QiuN6UWjtZdpjbScmGKKC9IwDg5di3pGxfrqEa1ajvgkm2QejRbpvUitL7EahRGisTdbiMv5oIvy7igScWOdNIZ1rk81FzVsuKNXN7NIo7b0kwYTWyAafcr5LFeAlADo+F6EO2steBXKk4rwVTX8I+SXC0oMG6EwnM6ZfNqqoMC3RDZTd+fXRDRvicKxrSfwtQuDsQlB2qhjOA6M7FkwZggy7nOPSAY71KKt/8qVnKd5U4unS9Z5YPNg199qvgs8j92zS17Wf8fscicLbMgvoDg7aWXTu7ay3Svd1grJmi9NyfaEidx1TPgJW667VGmun19gAy4sCF7prVfB8KlinzRLSswkD8PDGg2W/ruh6dIH0n/wtK5tfJ3hfaPNjUypOzXXsR02vbIwvNit0uhHViePKnT+NSDEhBnYi/1PBDOlNVF1IY/vNoHV740Gv0B/1XShrqeKFHR+2iFqTfanOtrrtzcyPsOp7l6II1ANgaCSlalOKQiFeafeZAEv9/3RX81xu9otrVdq5VJV2GVl81Bir5Un492xJI39mwSE7FrC23Ea69l03DLvrdpLDHweH69bxlVdG2TJxlEV+Lg4pjdSIE3/MgrWIznzrga0TSS4LQPgcYds3HbdgWuFj1zSl4qJw2iDT5SJQ6SQ8nVrzslvw7QQoPlhopM7n+Ph+7qfZhOmY8IFQ6CpqBeE7EgDFT+R+wMC6z0EQ9a9aMxsUFxVPJgPXy0ZnYrERGJzP4+95kiWTnytS1xN8lPzaAl8Ub+8MfY8onIYQRwNC+18TW11p7qgiYejJA5gs2/p5ceKNF3dgPAcxduaU
 a9pmUIX8
 R5ZbtRdq0wHC2LGWQjvEOqULLrZfvGHTj68Ym5qLn/1JO/gZGddkboMSX91XZYojGecCU5C4cSoeBTFUI1mfrj+3BZa+AoePPUsL8Fil7DSyqapMjekCtvWsAvCpKEh9vGc42zznF/5DrJstDdouwwRBdmfJoQvLA0ay4gqTp68wr+ZWYWrvesvvvmtLHbbazvMLbTFNd3jU+QBWfoWMEKyvfUuVb2WOOkOs5lwFZZqQUW45fTX9pmYwwxsRVQzSNRg4GAiH1BmrZYMW1gFra1Hl6xv8OJRDWvzdJ9eUL/pumVYkd4euxCkFJnpOj98uWVIqhYkQTd/o3flNqBwAIS1f2dzYEuNjhL8/ABpbKvDnv+CnADBMDnHEOvuZabxySiciOIQDXXJxTWW0sOzslfwdAZ1keE6vpo+3mkh6yPQZrcDFLjSVsX0xgCEbfC6Utsvw+IG4uE8Y8eTBX8/B+Nge5X1GePMco1d9wVxAjjZrAqid3qmnJXE8oRhJGThn7UnUPJtAOXg51Lk5i4YuvIHaPolZsL79vn28Vdt8b4+mLc7cFLWmo0qZ+4icmewqF0Pqm5MwEDbxVvL39yUfSziz7UJQwh0J6KioD
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

Link: https://lkml.kernel.org/r/d5a0f735783fb4f30a604f570ede02ccc5e29be9.1763399675.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
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

Cc: stable@vger.kernel.org # 6.18.x
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
2.54.0


