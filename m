Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60D1F606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 01:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ErUHXsRj
Received: by kanga.kvack.org (Postfix)
	id 6C5266B0191; Tue, 20 Oct 2026 21:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676396B0595; Tue, 20 Oct 2026 21:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565686B0596; Tue, 20 Oct 2026 21:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24FBC6B0191
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 21:19:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8FBB8120427
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:19:35 +0000 (UTC)
X-FDA: 85344875910.06.C0736B7
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id D480BA0008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:19:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ErUHXsRj;
	spf=pass (imf15.hostedemail.com: domain of danishkhateeb03@gmail.com designates 209.85.167.175 as permitted sender) smtp.mailfrom=danishkhateeb03@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792545573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yGhEhiwx/DAjk4ecDWk0fGMz5/0MGUCdDypcHzAbbM4=;
	b=b0HGERWIHWx8Y1+FEwf1LQSE1yTmGLKzYiTUEXnPgpx0Uma/DY/dSOqp5FjqfaH/isI7vm
	Cs5zUDuFRl8H3M0scBQ5VdnWHCbAUJZK2xfQNjCa9vjNjpFPsxiTVYT0XHPZQ6PcO21J7P
	jDCs9QiNIYb27PwYg3A4C3qIZ0G5QfA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792545573;
	b=qBah5kgMduYG8wSiYdZcvGErfTIq1WxCb+YNcCl14njixe+p4C5fiz6MEqpaALVPQAvQF7
	XHPod/+acxB3Nav4ltTbELhCi0snMn2gQKRPphWYjhW7pez2YH20YaHqQAGZ5oaGAx4igf
	y1NAkBUgQtMrbBhmAg4/GRR5VxnwOvg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ErUHXsRj;
	spf=pass (imf15.hostedemail.com: domain of danishkhateeb03@gmail.com designates 209.85.167.175 as permitted sender) smtp.mailfrom=danishkhateeb03@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-4a451915d8aso134938b6e.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792545573; x=1793150373; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yGhEhiwx/DAjk4ecDWk0fGMz5/0MGUCdDypcHzAbbM4=;
        b=ErUHXsRjlbzrJhz3gUM4fsE37EUGAdbxzqzH0Z0RPoSgVpzImO4r3aTKoIYr6+htju
         tWDTAA+RrSLtJUQHWx4CCCIb+MewQ9Jh3W9YI6cIcTf1xvMXmqZONxcgsBo1r1uLuyI3
         xEGnNd4HhBOBd792LSmzXhahbtE0TB2Uf0eAGP8HzZjZ42C2HsfO/4xGwBFTCO6/q2FV
         VgnGz+fbZspD2RJLK9G5obPapwiKj0fjMYF2a1g7FBQ7PJEe5u1DT56Ew4y477SGsKx8
         nDSv59OYNcJkOe6+u/2OWQIM+HCedWkojlekhM86YxsqiQC/U+Vvbu37mvLo8W+rIDna
         dy7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792545573; x=1793150373;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yGhEhiwx/DAjk4ecDWk0fGMz5/0MGUCdDypcHzAbbM4=;
        b=TgH3gifKtps6+IWvP+BNRs5Uzfx5+A+dCIRdN2YlebHyPT3JxNQoPvFRNOsM795zMT
         UugqqDLFmF6f1G6F8L3KipgYvAvNKP6XL1XA9LeHGyzb+xV/Ob25jJUcjm8m8KXZxEUH
         fToFcUi2Tkp5opSginUEhZ0Ac91qqFmuT0xrFC+SU/l8cvZvcPYNyLds2UYczNiWUVrf
         aBi41GTWGDvHpGXqBSiGunnCjS//yOlPOxf/uQbCCPMURfY41vU5hj1HtjrbEH7Kmqti
         gbHGPex2jjVMtfDT9B9ta1KMarxg43Kjw8qBTAz4KfSGmnVfyRuZehBoyPy5KALffDtw
         aNfA==
X-Forwarded-Encrypted: i=1; AKwUvByWdTq/uGN2hGbJGpTEu9O8M/RFywzDeoWLB66+TPRQWJmqE62bgk6aAnWvWY0fW9OdzLqqkO/Pfg==@kvack.org
X-Gm-Message-State: AFq9FYJr/Mpba5Kx2l76FIKeBjrp25glFPdjVFECjiqnuFicJ5kVaEPm
	mHY7DOeeOEn9aGCbsHNpQC2b66jnp7j8ShfFmQHz1+Zkl2V50tVdBDW7
X-Gm-Gg: AYBFou21IdIdPj3re73B/didAOQzJY4Zyz1riWk30VEbW7NmoQR1HGFcaFmeUiTySes
	Amul6VS8VG4UJ8rGiv9i2FPGmF3Onc65OYJYAvEUQ5Z8JtZR0GJ/VffVnGQndeaeogbUiFiAAhh
	vSLF0/eRwxGLS2A9WZ+yQOMEpKkDZuTpnbVWtE70+tXWHkS12s35cOpQCC6Q9i1kezi5kCR9ktq
	AsRkgBHjbTbkmHnWFNXHRSw6dRmFjJyCF5cDl7euEbl5Dxsrny3Yt5Cc3zIEcZ7IZ006gYmRO8F
	/mbV19eXBvOtc9Uw1YAQPyR31haITyD2mfhYNC5AoGG0+3KrF1WBDESEGKVbZaYEKWRJiDjyYoM
	f4D6cRWhBLDA5Vy9qDdSKbFRtRToeK2I3E37ZZfLtG+jknatnm5fw/rEZXqD8EG67T1Y6pqCRZr
	BDWrQ6GFKlO5FLpK6S1vJczRcnGCBgPXspQxZ4wu0QCEhxMjvNPRMHlhplU7GDIl3Fpb+EdH8um
	BJIcYibB0kgWX0DzMOmdpKORPjRptODg50KanIlAPve5qPNsgWzdJgVIAzKGMmCMGIiS6d5duAx
	299zoyLBL354Vhgm0W3+hg==
X-Received: by 2002:a05:6808:c40a:b0:552:9d62:f1b6 with SMTP id 5614622812f47-5535a767ef3mr353032b6e.51.1792545572736;
        Tue, 20 Oct 2026 18:19:32 -0700 (PDT)
Received: from archlinux.lan ([136.34.156.120])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-552b4104048sm800659b6e.5.2026.10.20.18.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 18:19:31 -0700 (PDT)
From: Danish Khateeb <danishkhateeb03@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Danish Khateeb <danishkhateeb03@gmail.com>
Subject: [PATCH] selftests/mm: merge: reserve the far mremap() targets
Date: Tue, 20 Oct 2026 20:19:29 -0500
Message-ID: <20261021011929.89150-1-danishkhateeb03@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D480BA0008
X-Stat-Signature: o1kbcgxn7cinprei8r7oap97oe5t9ky5
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792545573-263533
X-HE-Meta: U2FsdGVkX1/v5+G8hxEfrgsRumbeaCCr+5YmXbYhV0Rmiuc+atlkX2JLDZfB/blm97iq6Kwaw3PRKyi/rtiaDxZP08mvgm/fqTw46Wrqakl73AbcdR5n5yTa1IqxBJR5nSwDEJdPGazaNx0qlljaUrzhA0eVt8OHpFHJbDtIMXy1kKzH1z6rmfB8MIyQ87gwA7azWC9Jtw2eoyzNhR7myyTZpaQdOj9zw4GQqi20ONsM7BvcXBuMZlqwt2F4CUB7CcfmwVYG5a+xteNoQCdijYXu+j02yF6ApSLkLiAwvRaDdcfqD/heUF6NTWlbBqkJg4q8AXAWyR1vUukxeXk9sM4hAK/RmcwjK2cAslDWSVVNPO+GH9dG8GWcts0CZvSIlSGAh0HM1X0P92fhuqSVME3xW7U89rtzS0N/OuvkLnfMfaVTGioMz+GYd8In7ZimldWf51lFlwUycCwdWWl1ousYGdcuzP+Pq5G49pqqHiIOvI7yIm2J7sti9u+jF+W6hMfW/NQKaIFJ1TOIDiwPhgGweQjN2Zl7551us57LHW+/XUYwM6OjDy+wMGc3GeaObfdSjY1nm54VeJcV4jUmbjld3kZvEVJaW2ud1BAJ/U50pqOchCFqLclDBydccnnSv4mXHogMDOMCz4zWO3+76zidmHS7Yk9AK9QhvoGBld/lNIoepns8zCPhyDOGNm7Q+Q3Y6I19xcrb8SN2t+dAK3eeWv3GAaIEvSBwOnQkAQBAc+u+e9zK0nhxrpHA0OjmM3edL+oO0rmQSokgHxGiZ5GpM2mMfvdRcC3IrDpBig5nl3v3MesVdY+mLjlZNGIoSja3o/hv4TAtj0cH9ACK+aiKjygYWY6K98uaqvolL879xd1zRrjW0UOxqIMN/LKSi4ei0rcqFhbb8rUnKkAEoZet3D54iBBlGWMJPzq7u+lFnuR1w9CpUyfMvXrvSWCkmqNLU6J+BMWQovP62Kq
 4ufoQfzh
 gh3TdWCt0pGPOhYaSZfOmyPVLdl4skevjo3KSPyYYaTxh/bm78s74nEpdHfQbNEUbVVs1N+b9kKeOnvIpsUaSGlaIMfpmpBMhguZQsFZD5ASafeHtplPIJe+2g2dOwuKdaPYqStucli+rA2KflGuhfRRHbt5o/dOA47BDGiJn7wyiir57AemZ9tdqv2aLpxMOFaAJJQNwWlHMJVnRRfHZQqquf+t9hiDXFovAdHQt4gZwbjVE4ySvrLuy1ZIFizC6HVGbTYeJqJEp9AV8YhyvcZoJTAKlYZ87WaqPP6o/QPfhz/i1khWATwOaXrtn3nGfFNo+rnLrGwCeEC7dZ2UWioxOqMVcKhgDfhC4RwOJ6SU//JZTiTqKY41z6Ng0R1V9WytZVyEHa8jEVqsUK+af4tgPxpyshK98kOnP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The merge tests map their areas at fixed addresses within a 30-page
PROT_NONE carveout. Several mremap() tests move an area 1000 or 2000
pages away to separate it from the others, but those targets are outside
the carveout, and MREMAP_FIXED unmaps whatever is mapped there.

Under virtme-ng, the shared libraries are packed right above the
carveout and the dynamic linker starts about 4 MiB above it. The moves
then replace part of its text with an anonymous mapping, and the test
crashes in its next lazily bound call:

  merge[6980]: segfault at 7f7ebb3c1e60 ip 00007f7ebb3c1e60 sp 00007ffd35fbaec8 error 14

Two to four of the mremap() tests then fail with "Test terminated
unexpectedly by signal 11", depending on the exact layout. On a host
where libc is mapped at a 2 MiB aligned address, the targets happen to
land above the dynamic linker and the tests pass.

Make the carveout large enough to contain the targets.

Fixes: 4e25f85b9f85 ("tools/testing/selftests: add mremap() unfaulted/faulted test cases")
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
---

Notes:
    Tested under virtme-ng (9p root, glibc 2.44) on next-20261020 with a
    KASAN/lockdep kernel, three runs of each binary:
    
      merge before:  pass:22 fail:4 skip:1 (SIGSEGV in ld-linux-x86-64.so.2)
      merge after:   pass:26 fail:0 skip:1
    
    A /proc/self/maps dump at the first far move shows the target inside
    the text of ld-linux-x86-64.so.2. The same tests crash under virtme-ng
    with v7.2 and v7.3-rc7 kernels, so this is not caused by a kernel
    change. On the host (glibc 2.44, libc mapped 2 MiB aligned) the results
    are the same with and without the patch.
    
    An LLM was used to help with this patch.

 tools/testing/selftests/mm/merge.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 7dd2933417c1..8291c208f0ae 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -22,9 +22,17 @@ FIXTURE(merge)
 	struct procmap_fd procmap;
 };
 
+/*
+ * Some tests move a mapping 1000 or 2000 pages away with MREMAP_FIXED, which
+ * unmaps whatever is mapped at the target, so make the carveout cover those
+ * targets too.  Otherwise the test can unmap its own code, such as the text of
+ * the dynamic linker.
+ */
+#define CARVEOUT_PAGES	2048
+
 static char *map_carveout(unsigned int page_size)
 {
-	return mmap(NULL, 30 * page_size, PROT_NONE,
+	return mmap(NULL, CARVEOUT_PAGES * page_size, PROT_NONE,
 		    MAP_ANON | MAP_PRIVATE, -1, 0);
 }
 
@@ -73,7 +81,7 @@ FIXTURE_SETUP(merge)
 
 FIXTURE_TEARDOWN(merge)
 {
-	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
+	ASSERT_EQ(munmap(self->carveout, CARVEOUT_PAGES * self->page_size), 0);
 	/* May fail for parent of forked process. */
 	close_procmap(&self->procmap);
 	/*
@@ -115,7 +123,7 @@ FIXTURE_SETUP(merge_with_fork)
 
 FIXTURE_TEARDOWN(merge_with_fork)
 {
-	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
+	ASSERT_EQ(munmap(self->carveout, CARVEOUT_PAGES * self->page_size), 0);
 	ASSERT_EQ(close_procmap(&self->procmap), 0);
 	/* See above. */
 	prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);

base-commit: 59d7f9ec14ad4b6f38c04d254f8f2bfb991e888e
-- 
2.56.0


