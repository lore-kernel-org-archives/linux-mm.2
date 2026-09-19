Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAD1FC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CBAC6B00C0; Fri, 18 Sep 2026 20:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555226B00C1; Fri, 18 Sep 2026 20:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 444926B00C2; Fri, 18 Sep 2026 20:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07FB36B00C0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:46:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 650F240157
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:46:46 +0000 (UTC)
X-FDA: 85228671612.03.7D3FA49
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9F3D7C0007
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:46:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NrIwfloX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789778804;
	b=kNCh/wjJxZzvnXmNkzMasRb+qZA0Lmudlo8RQhOzPK1aWoeQXS1tQRo8/r7eNXbYgG/iWg
	SSPsWs/+mRKLI2TuUxRhvDZ8R5Pdl6OPKCzU8ylhbCwWFznrlO8nen73SlOy/i4EYSf1UW
	mf/woU/LyOEaId0JgOpu6qDB1NOT/rY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NrIwfloX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789778804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uyjZLL0sA6T5K+I6SLCzFZO+c82gRPna/G98UbpeCXU=;
	b=IjarDjjlMEuni9MTmPEEWvKsqWaiogj8UxtcoN+7W1s3ZJ852VvrwYTbjiMx6IMobbcWVQ
	vCkffjmIdpuIPrm18znWS3dCSxZisoocbnb7u8+uA7HsMPD5B7wDfZziLtjhY6pR1YwzLX
	F3ZWlgdZ3oCfqA2bWJgQiuHqU92uz2A=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396cccbba91so965352a91.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789778803; x=1790383603; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uyjZLL0sA6T5K+I6SLCzFZO+c82gRPna/G98UbpeCXU=;
        b=NrIwfloX2T3v+mSSXO5zt34LjFYZXNb44k2hSfFBEf+44qGL8UaVeIj/V9vLo0QVYF
         Rnko4MZm3u54Gw93f0WhZQryomq6Ozy/MyJKFwhbU5Q6yMcIh7sMB+UwrZ5iEMmtzL/K
         aXyp0rz1ENnqSsUiSwIcHja0J361knFfDdWQU7mw6rBtmqPPXU7elbbf2ctyZuqDY+B2
         QJAKPdkyYUcbnxF725OAIloQi3Snxqw1q5ruwj9/l8mkL49a66518n0crtQG+U3YIdlU
         MdTK9yppa4zPtWiubqeqivmPHjdveCbiBqAeBbiC5zDI02rnv7GoD3uDEY5vrY2ZChcT
         lI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789778803; x=1790383603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uyjZLL0sA6T5K+I6SLCzFZO+c82gRPna/G98UbpeCXU=;
        b=DDWgoMo7NjT9sw9qxiJby/JJ9IeUfaDzIqSGkTTagFd7xgS6VPP+E8o5AjJMNYJ5hN
         WjBjYpk1FrK/zsuN7BNm9VugiPT0vJiXtYkduL+VlQOfOQIjYlsyUVWVkWVT6A3Wq8ku
         x/sLUMJlXLYWF6Hk6AZpQBy9BQlKJIYVyS62APOm1ybN90S8QHO5zhTDYhWYp7iA8p0v
         dNRBEs0DVfHuDLf58RkAFt9l+t+/x1QTaxhPPYlxBQIqdM/hFc4E8r+uQqvPd9FHiEsN
         D44aY6iKldMVd6W3kltb2E14ewQxok2bIMpwGAjnQYQ4dEYXXxSE63KQoJRie4on/UNm
         fK5w==
X-Forwarded-Encrypted: i=1; AKwUvBwS2LCZNkvUvKoK+y93JeMVnD9GEGqZiRWsKWaJi569qMn8/kIYtCC/fWnG7L54We8WZ4CqZCRvTQ==@kvack.org
X-Gm-Message-State: AFuF++nS60SLeVlhG7NGjDbkD5m6VgCq0Zq/5cG6wm+LGCNpQxolU3O4
	Ti95nvaX2e4ylsi4L3TXGKu4yUHfTIgCBo8L82/PuWuLZxqNxfNWAkc=
X-Gm-Gg: AYBFou38vOZ2rQ467HzLawpO6AUSdZo8fjGaGoVhh7LoH6W5RP8QhxRHJpLncSYkIOa
	C8prqK9dRsST4twBpP7NkWCkgTtRS4OlyhiJw/7iNagHQWbg9nKKKjMtyFPfEI3ecMUWujLzTwJ
	KzgzaMdYBKREc/OacsWhgAlwh2pLZK/5Dbks3EAobZMvBqiNuFYZKv4hTK3Oy8nMxaXOeBBFtH+
	BlAvJXRHmuAwBADhe9ORoWoZNA/RR4jWYnsw4DBJwLlpvXst5lDensy60t/+hFXwqSRlrIKDdZc
	7pVz9E1Oi97PXLxkQP/VQYv2shKElbgDjh+aLssszbDyJnp9yjwm0xElwS4S9r7EwG2BqlNCMeo
	Ogoak1VPACJqApiZneljR4RgFnT9mGFrmtEz0iglL827RFmMTb7NaJCRJTsXYltXIiBQHTlYp10
	UIPq4x6sR5kSuNS1/DeHCwVl0J521Fe2GQyqUKfw434Ov8U2eo0ZlYVTR2qSYNgCVT5/2383ylv
	5FAyZ+sbk7/WTsByJP+2fXnJ/pl3cQwNLHjJw==
X-Received: by 2002:a17:90b:37cb:b0:39e:6c6a:2090 with SMTP id 98e67ed59e1d1-39e6c6a229fmr1913904a91.49.1789778803484;
        Fri, 18 Sep 2026 17:46:43 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:45e5:9e39:6356:6164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c169dcdsm1927166a91.2.2026.09.18.17.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 17:46:43 -0700 (PDT)
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
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v1 2/2] selftests/mm: add a test for UFFDIO_MOVE of a write-protected swap entry
Date: Sat, 19 Sep 2026 09:46:30 +0900
Message-ID: <20260919004630.1159895-3-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260919004630.1159895-1-donggeunyoo.kernel@gmail.com>
References: <20260919004630.1159895-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F3D7C0007
X-Stat-Signature: t5x1owsoj46ohof9uurqzourifp38ori
X-HE-Tag: 1789778804-671746
X-HE-Meta: U2FsdGVkX18psWWufp1KU7myS+Nc/vzid1Ai1lVixAZnAqdBMWygtOwvJ+emnn1CWUq0dcJj/TGl5rpRggcOka8hDdw2HnHJpcPCluBCDnC3kNOd/Xm1lVHAuhaLqO6WLfjZMZzrtfTwA5Pt8aO2z58agOCMfO+10OhWJwjzYE/qWwLDaduGJgXVni5HBuIGmh/8E6F9ur6oNQajryc7kqXRLETRSEZd/bjhxmSQ9I4Dq/VROkoLSpJ7jBNPbE8USTyu2tqpMpKw+vhf1VXAIcOvXH9YqyFJLBOrzAPArzEm52y9Vzlw0nNQV9VSAOnktQ3+hd2bfKgRJ/cZU429CaVj8el0Xuickpfa/i1RSxbjP8EwL0RY8CeWXvU7SZFSdnPNVk/vibokoJphNzQlvIL1waRwtUezSIv0PXiGLlYZCZZaW2jmFwPS2arke7wfzKzLJAulLAPYnTtlAWol+FkvifHs4EmRXEBVHd6ul9S3XcEc2wt7nM8B7QvdZzv1uAxu5jU/6JWi6n/o1L3lhkisRnnBfyUuEMQmhIjDFC234ppL/ShEFCPeCb5lnebdTR1EX2BB7Y8u7Vx4wQF8Og/mlLQOL+Uv+UGcuFjtoabldb2F4aFRYSj/01NMKe44fr4hG9RVjO57Ao23m5HLNVWBBAOfFGiNJlg627CSpTrWE5nYGAeNCvOYMlWu61rExL1OqRow0n4UhB6D9k95wp8+Hh+ckP57pVrD5adKkuyQfGcRzsqpvCnTP4fHCI/04vJ4wBvCph0F8uX4zz04+1DPXrwq4u4STPBKnjZKfjQ5TT4cdexc3Ucbi2k4LkySvhwJQtBJQB6sgEW+DF9C1sDcKZSND21B/WlIm+XZbF2MMeTEWmb1hHYPffbJZ293PaJ5qNWZLA4xE46TuBNE6lqIxIPYVGG4xsG4fivOcNn+mu9FzttP9O317o7BbQH6MIcyIBy7ElJN+4KI/Si
 RKkLIn+l
 flt1AXlQFzWt7VoZHKPc7XtOX5D5edWzAFVptwUX+qpjCGxG5IVtIX6/AUhj50zHPL4EmjhWkJFrheEwaQFO7kFyGccITOojE6sSSA2uUJCmoX16DQlVXZVbG5+yvw4ZYFOE/Qp1qWtTafOZewAPUrMKFKwbEfr2ehl80y+SKRfT/8Cr3EnObkr/c0pf4fUfiFoIZgTTSgLHD3PYl7V2slmRgpIrsVDox1JCGokQtgYL9in7g7sfHQ2EDLcuzw8bKYs776yqI9zefAKt4OpKVthMcL0e+KDrMabXvAU7mqTaZheAE1PeC1p8ceOFa7AXMC99M6Wtb5VHjjMjvTWrmX7I7z7HFRy0nXOV4WBCGO7xE1baDjW2hGiNACOxxy770xIF2QMoGiY+KMKAmpGuMefLsPhofRX7ggQIRT6KqEkDPHjOlohFKgbJ7vdZ1vpetHMOtzvN378zWPweqh0u4pWwzc0EAM62tQ21d8KaU3sYeSoglbQ50zbwaH1kYkZMC2NGO9785qJVzLLoCMbExjt0zh0VvSSC+Ogyut/VXmHMHa6gbvJDXUOeLYIa3Cdms1vtq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move a swapped-out page out of a write-protected area into a destination
registered for missing faults only, and read pagemap bit 57 at the
destination.  The destination was never write-protected, so the bit must
be clear.

Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 61 ++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index ef9b3956bdcf..ae8b718f0a27 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -2037,6 +2037,59 @@ static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_a
 			      uffd_move_pmd_handle_fault);
 }
 
+/*
+ * Moving a swapped-out page out of a write-protected area must not carry the
+ * uffd-wp bit into a destination that is not write-protect registered: such a
+ * bit is never cleared afterwards, so pagemap keeps reporting the page as
+ * uffd-tracked.
+ *
+ * Needs a swap device; skipped if MADV_PAGEOUT cannot evict the page.
+ */
+static void uffd_move_swap_wp_test(uffd_global_test_opts_t *gopts,
+				   uffd_test_args_t *targs)
+{
+	unsigned long page_size = gopts->page_size;
+	struct uffdio_move move = { };
+	int pagemap_fd, i;
+
+	if (uffd_register(gopts->uffd, gopts->area_src, page_size,
+			  false, true, false))
+		err("register src failure");
+	if (uffd_register(gopts->uffd, gopts->area_dst, page_size,
+			  true, false, false))
+		err("register dst failure");
+
+	wp_range(gopts->uffd, (unsigned long)gopts->area_src, page_size, true);
+
+	pagemap_fd = pagemap_open();
+	for (i = 0; i < 100; i++) {
+		if (madvise(gopts->area_src, page_size, MADV_PAGEOUT))
+			err("MADV_PAGEOUT");
+		if (pagemap_is_swapped(pagemap_fd, gopts->area_src))
+			break;
+		usleep(10000);
+	}
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
+		uffd_test_fail("uffd-wp bit moved into an area that is not write-protected");
+	else
+		uffd_test_pass();
+out:
+	close(pagemap_fd);
+	uffd_unregister(gopts->uffd, gopts->area_src, page_size);
+	uffd_unregister(gopts->uffd, gopts->area_dst, page_size);
+}
+
 static bool
 uffdio_verify_results(const char *name, int ret, int error, long result)
 {
@@ -2359,6 +2412,14 @@ uffd_test_case_t uffd_tests[] = {
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
 	{
 		.name = "wp-fork",
 		.uffd_fn = uffd_wp_fork_test,
-- 
2.53.0


