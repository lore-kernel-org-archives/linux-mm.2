Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40C71C98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 12:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8876B0092; Sat, 26 Sep 2026 08:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9246B0093; Sat, 26 Sep 2026 08:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE6A6B0095; Sat, 26 Sep 2026 08:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E06AE6B0092
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 08:42:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D441A6F97
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:42:05 +0000 (UTC)
X-FDA: 85255875810.14.4755A02
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7C1F6100005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:42:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XRge4rog;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790426523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UuPio8yVnMFS6iISF91e2TRt3XkbnhyD4KTt+debFho=;
	b=K1M52AFqlTY+CV7Lt/d8DR6w/X7Ql+z+XPes/7YMpUaAORUVmRNGSsDQSSSpjA2fGGtBbk
	HO55cSO5tI+caCsIeq18AbG0ftkDMQJ/JNPeD8Wr4eW6bYicQDYuax1JFGpGFdPqy3s+gD
	i3tKhl33LICLoqaCcJMA0oG3yL/10O8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XRge4rog;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790426523;
	b=8pLOtFCTL6HJmZnGZnmKTGiWoBZcLVXBk8jCBBXThO/rjMgpPjjxxYQvmLgAVS3xKPulNB
	JfNpnfQZ7JSqY/IOp3MoOPXOq8rMWCKST2x2WYhSOHFAfRBHaHzMUkCGn/cGritEFqHozz
	yJwvblTGI/qNqUqueNtVptJNXiibYtk=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39dacf053eeso885443a91.2
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790426522; x=1791031322; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UuPio8yVnMFS6iISF91e2TRt3XkbnhyD4KTt+debFho=;
        b=XRge4rog0N7BtMHEPrdAHvrhd2sBtXKMpXXlEki61V7KqPy3gZY2XlUqMNzvlsk3fr
         qNcv3POngqpOYbjr+B0HO2tOrFYxt3L/zMSOvLrePjxJM574w5cPl31dVf7i8ZLgM8TE
         LyKA44y2U3cvornQVZ99iJrT6uLdfEuQAhrbJUasbXPD6WwSkCF/vkdGiyY37muGr1W0
         y5dgAwWVfPbtmzAIW0Ic1T3aEU3w6hSQraypQ5qdgwDLLfgvmoCwZvrYMQQQPIyYS8Q4
         1FjRd1nS5mUMGkuNahMtDLdGrXHHpO7fY3ejz8y/yBQBkHO8ReqP4HLuAhlE5PcaWFtf
         ue7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790426522; x=1791031322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UuPio8yVnMFS6iISF91e2TRt3XkbnhyD4KTt+debFho=;
        b=lBXhhuXPkkdfQ18rCen6HLYlN9WsiBYLEekrUacrQvLKjsto8ARyemrj7A0qk23It7
         quyc9hhwbPTPCykvQQ1qA86CJY5nnGmPKQio9dDlc0+zM9rHG+B7CQQkuTbJWd1/QWkE
         cT3R2srb1kXgnHaxqt4S/73RhKhatSJ6sd8WvvezkldMVXegMxm+4Ez0Q1k15qo6hP/M
         /dD4HrZaVnhOi5pUcZgRUtu21/5Ktj3/v3Az/rikQNl9Apso66JSgZ4AiRIzCXo6nC0t
         YECE0EI5GcTcwWHSL0xT/1TVJa562CDb+tDHi4D1nQLFQI+2wodTHn17gw53hv/+mhIp
         53TQ==
X-Forwarded-Encrypted: i=1; AKwUvBwK2x++xAlEzFBqzAR+UURZdF/PQ8nqWTyrOndKPnGeB/a+mZJ9eZ2GXtChBbztb7kWCTz6f7DoWw==@kvack.org
X-Gm-Message-State: AFq9FYLsWUJJ4Kw91HUX/734Z4P+QI/Bl9x+Q5qX01upv0L/d+TZh5ND
	KoQncUGntGHQB7etDW0xU5TTTgI9VygpxIcCcVLI23Nt9Voo7dihBoQ=
X-Gm-Gg: AYBFou2NWSu4vakbYKrk1SY8sNrd2cmZV7HaFjtyD0gJDOyUwNMzg7W0tw2fgrw1398
	MltSxCPI2AWs2g3T4/NbFoFpAjhbHTJxXlo1JRfD7j6gcDQCo8Jh904ro8MPWYzwNGa2ryonNRs
	g39sNaSbltk2/y4GlytF59lwPx68YSbwRjxMtImD8ibG7DBdCcaaKDmpEEoiFGenL/KUuYgSZ9D
	vawvagN/5i+oVQVSJXx4/3QlufvITtYDX/00D4jCKYBX0xTOu+xWdT02a5X7AsHbrTZEs95P3S1
	j6lvDP0bDfvSXq9VsoCJCHWnJXfQ/CtCZJndUwlBWm+fLwFMGoLuGihgSdtI6HZq2oqUd45xq//
	d79na6W95kO1RIIs6Lrl2ts0x2Fr4Co4wGbR+WzpXHHd4ynyjAtyFwJmXJVb0PGGTeinhif/M7g
	mGHycYFjXYeouQebZ+yf+kQdEEHLZGS4zACP6rNSD7VJ5yjUem4+5YadKd5EBCqsHNIQEMEb6/B
	qWquXjwVbUo4S8kE8rdvMj+
X-Received: by 2002:a17:90a:38e4:b0:3a0:b223:6830 with SMTP id 98e67ed59e1d1-3a0b2236c1dmr2901997a91.7.1790426522302;
        Sat, 26 Sep 2026 05:42:02 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([211.230.25.193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0cd1c4ec9sm5965212a91.16.2026.09.26.05.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 05:42:01 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org
Cc: peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	kirill@shutemov.name,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v3 2/2] selftests/mm: add tests for UFFDIO_MOVE of a uffd-protected swap entry
Date: Sat, 26 Sep 2026 21:41:45 +0900
Message-ID: <20260926124145.2878520-3-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260926124145.2878520-1-donggeunyoo.kernel@gmail.com>
References: <20260926124145.2878520-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: byprnxsbhwn17ocy3bmfputzi8x1t1as
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7C1F6100005
X-HE-Tag: 1790426523-548539
X-HE-Meta: U2FsdGVkX19MaY+ejBWW2ab5KXJKz3CJSVyL+3Umc9hYhhN6+s23gPHBU/Tpjy38CF2jsd14FxpWqdI2wMvqgO2Xew3sDDr/bZk+U9tcSDwABl6gO2dMfXDsGzb7czwplOjq6rLdm09P7vaLWTf/b9hPiIF/eRNF3JUns+/pry130eNCJmv1lGYhmtl9l+zrfHJYCajx8wbIixVs0gocx7RGT44FoJv8uzK5wR4Rx/75JXnoCirF3gOjRkNXCSTvT2f5DcA2BgA3Wo+J5SfB+j30oZ7R+yRgWVQFrzSHaeVxlpSuxNEYGTktNm7JwbkoH2jvSkj7ZiL6Ms8izGgYY9UKt+x/FZyXhCv9jfzwGIqfCe1nOe47XJSFNeR3WUh8PkZcNM/X+xfbXsnkECBKUrzQvbKQF+Pe2Ca8R5UxC943Jy4xTDP1ARGWwskv/jJamakbCmGfpba7hIfD5ZlqsyDKTwmKz+EfvEyERdnSHJdAwcU4Hb13bz15fjAyDqMf5GfhKdcgxff8gJg6cHQJEp9Ueiwj32vT0sOjYnKKIm7dIhkR9Q5/9GdpEI9qujMM0NuXxtAayg5lBTt0xj3tyoXeQ3KpIwZZbS9n2aRxN3ahvDUivOdm83xTpDbtTpj8siBAieZAh105THGTs9IvKK+vt2+bPkpkKX+ao4b9OHAAdnvLtFT78S8potAPkeaQmqnsUWSxIAfXmIcfDmlEqIvLiFF9YjeMDSLF6koUciAiVggf4EolrOrnBpMrhBUj9gomo0A5A3qqt/OkStljFXUEnLRSCjf4xa7dcjKGgCKp0hcecIRlj0XZXaJm/+qvGQfd19PYasvxRH4YAiEqH/8MKpRXalJvKAKpSJzD6UizQqPuiEWfZSRawqSL73hcYnK/7kWIosnMKOGv5ZtwGUasiRmR7Nvnu/N7KOcADzApB3W61gCJYObEFtuIMPMta1cRpjzqZZFDP4UfhIY
 5RLiBm4X
 TIjY/5abx1/1rDzg0r69+kf/ABHsmlRAuQTjcNi+D+ii1JorUkwcZtPaq8f8Cv+uJa1k5n5s+Avu3lpCUfwU2cCw88IHZTN1IV0a0BYNIT22tTdUoWcRItEOCiPBsTzZqimv1kDH4IfeOaoGiPXqUYSnL7GbChnTC6W1JSEwVNAUSEc1NMUQ+Jh5WSe3b4ht6w5jFfDmUgGwKj+ysK8mLhHuXObP3jld4Im3aOS4Q6oe++N9P/vUdbvute9BVFYhMxr5w+533ADThrFFZenRZoedKnPsHGZiP+jd6P9o5FGBsWxZn0JqsGeIWCtKYVRDcYoRRK6VlJ22rkzHpv2hGFeuibrQYFPIknqHEjiq8nfjX7gdJEPtDIg7HsAROITPDRIcKvOwCyTyK6lwvukVt1YYxfzq07LrilBadVASpSqyu52dWuXZ/7VEe9uyUywlAvYIGbLd4TAWS3G4cK6Dnmw47GhkV7hy7BEH4Y1uIO/NdhXN7+694Zk2gD3+Rlz5+LNpgPAYb01NAVNRij5p1lvBkBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move a swapped-out page out of a write-protected or RWP-protected area into
a destination registered for missing faults only, and read pagemap bit 57
at the destination.  The destination was never protected, so the bit must
be clear.

Assisted-by: LLM
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 84 ++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index ef9b3956bdcfd..580178630eded 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -2037,6 +2037,75 @@ static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_a
 			      uffd_move_pmd_handle_fault);
 }
 
+/*
+ * Moving a swapped-out page out of a write-protected or RWP-protected area
+ * must not carry the uffd bit into a destination registered for missing
+ * faults only: such a bit is never cleared afterwards, so pagemap keeps
+ * reporting the page as uffd-tracked.
+ *
+ * Needs a swap device; skipped if MADV_PAGEOUT cannot evict the page.
+ */
+static void uffd_move_swap_test_common(uffd_global_test_opts_t *gopts,
+				       bool rwp)
+{
+	unsigned long page_size = gopts->page_size;
+	struct uffdio_move move = { };
+	int pagemap_fd;
+
+	if (rwp) {
+		if (uffd_register_rwp(gopts->uffd, gopts->area_src, page_size))
+			err("register src failure");
+	} else if (uffd_register(gopts->uffd, gopts->area_src, page_size,
+				 false, true, false)) {
+		err("register src failure");
+	}
+	if (uffd_register(gopts->uffd, gopts->area_dst, page_size,
+			  true, false, false))
+		err("register dst failure");
+
+	if (rwp)
+		rwprotect_range(gopts->uffd, (unsigned long)gopts->area_src,
+				page_size, true);
+	else
+		wp_range(gopts->uffd, (unsigned long)gopts->area_src,
+			 page_size, true);
+
+	pagemap_fd = pagemap_open();
+	if (madvise(gopts->area_src, page_size, MADV_PAGEOUT))
+		err("MADV_PAGEOUT");
+	if (!pagemap_is_swapped(pagemap_fd, gopts->area_src)) {
+		uffd_test_skip("MADV_PAGEOUT did not swap the page; is swap enabled?");
+		goto out;
+	}
+
+	move.dst = (unsigned long)gopts->area_dst;
+	move.src = (unsigned long)gopts->area_src;
+	move.len = page_size;
+	if (ioctl(gopts->uffd, UFFDIO_MOVE, &move))
+		err("UFFDIO_MOVE");
+
+	if (pagemap_get_entry(pagemap_fd, gopts->area_dst) & PM_UFFD_WP)
+		uffd_test_fail("uffd bit moved into an area registered for missing faults only");
+	else
+		uffd_test_pass();
+out:
+	close(pagemap_fd);
+	uffd_unregister(gopts->uffd, gopts->area_src, page_size);
+	uffd_unregister(gopts->uffd, gopts->area_dst, page_size);
+}
+
+static void uffd_move_swap_wp_test(uffd_global_test_opts_t *gopts,
+				   uffd_test_args_t *targs)
+{
+	uffd_move_swap_test_common(gopts, false);
+}
+
+static void uffd_move_swap_rwp_test(uffd_global_test_opts_t *gopts,
+				    uffd_test_args_t *targs)
+{
+	uffd_move_swap_test_common(gopts, true);
+}
+
 static bool
 uffdio_verify_results(const char *name, int ret, int error, long result)
 {
@@ -2359,6 +2428,21 @@ uffd_test_case_t uffd_tests[] = {
 		.uffd_feature_required = UFFD_FEATURE_MOVE,
 		.test_case_ops = &uffd_move_test_pmd_case_ops,
 	},
+	{
+		.name = "move-swap-wp",
+		.uffd_fn = uffd_move_swap_wp_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MOVE |
+		UFFD_FEATURE_PAGEFAULT_FLAG_WP,
+		.test_case_ops = &uffd_move_test_case_ops,
+	},
+	{
+		.name = "move-swap-rwp",
+		.uffd_fn = uffd_move_swap_rwp_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MOVE | UFFD_FEATURE_RWP,
+		.test_case_ops = &uffd_move_test_case_ops,
+	},
 	{
 		.name = "wp-fork",
 		.uffd_fn = uffd_wp_fork_test,
-- 
2.53.0


