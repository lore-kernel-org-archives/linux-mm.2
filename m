Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC24606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=wVw6Iv3l
Received: by kanga.kvack.org (Postfix)
	id 769C26B0A24; Thu, 22 Oct 2026 19:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7198B6B0A26; Thu, 22 Oct 2026 19:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62FF26B0A27; Thu, 22 Oct 2026 19:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 363056B0A24
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:27:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1A89120201
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:40 +0000 (UTC)
X-FDA: 85351851480.15.12376C8
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf02.hostedemail.com (Postfix) with ESMTP id 24D9680003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wVw6Iv3l;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 36ZvaagsKCOgcecOOXNbKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--suseendranb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=36ZvaagsKCOgcecOOXNbKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--suseendranb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VDRZ+CQOwSmX2v/BIgM0gLF5iLJG2Nr4i5jrVs22WNA=;
	b=aUYz7JWL7fRoTByY+ppnZm9HzOYYwoRJDxCH+pduu+I6TY8OG1R3oGenRX3PelqcCT/mu+
	YcK4oNZMCXcw2d+lyeDctB63Avr0jAapAEsy3tv3jaDSMUHxDTdPvZh68QxS9XToiTZB37
	hYymTQEuyJTA8mBghvMA9xa/cS/km2Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wVw6Iv3l;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 36ZvaagsKCOgcecOOXNbKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--suseendranb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=36ZvaagsKCOgcecOOXNbKXLQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--suseendranb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792711659;
	b=C6gR4Wsco+RWgK7gL4yuRPPW1BZEnTM+22IUO+IE8GgYtY+8zX7PpJB152IX77JVZT95gP
	MQQubFKwWIRo6PtauW3LH0qll/E6WgZbzICR4/oTm9h04dvPf0CSTcjr6WQdfBe68YP8z0
	GZZSt//gYdk+poFej2Bu861Z+UNqvdY=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3acd21ba24eso215025a91.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792711658; x=1793316458; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VDRZ+CQOwSmX2v/BIgM0gLF5iLJG2Nr4i5jrVs22WNA=;
        b=wVw6Iv3lcbKbehtzZrc3P/Uh8Y5z2CDWqK0nZvz1Js0doQ2IYg70JrJlsLPIcQZMDy
         gXLqXCqYvIoU4EIZJuoBHzaWJherv82mTqTfnaD/obuVTzdzYnWC4/uAOsGV/97LECV3
         egKAQegNqcEfFTxXUOrazDiGrdLV93XZwu3AeIgVxZtX2Mkm4RPeS08nENc+WU5EQRiC
         /yxsxQTKMkf82P/6ZZakXtBvpcKwN1vgvA09OBOjoSQk/YxOvuWb7u+TXIcBZvABAWUJ
         TQwKGRAzNQsHej/ddXGCyRqv76ZgIi/5A7CWgFW+Ng+dD7f0H7z7kL9EobhBtg8Fz/Su
         LaZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792711658; x=1793316458;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VDRZ+CQOwSmX2v/BIgM0gLF5iLJG2Nr4i5jrVs22WNA=;
        b=eJfbcZuVjK+PpgntQSlABPtQeJhMgTxFlSaN0o4SLDeF+Bhl6O2h4LQmIW0DOnYFmc
         AZjmTv/ouwBNJTuYf7IgXGnK7zAR5WbWHn7qO8y/1qFQ+o5uZtC7oUxQhWAgbXQ2rjpH
         KlhvU5rdyPp2wDvQJxSHWC5GMGDyKQLjcS2bl9mK/gt5LddDaTCJ3C4z87oOTesG4U0v
         HlFxzcmt3JqXi1JB4LRETlm0JXHB4nv/2fvQ94dHf+DFN95pg7P0acsqyX7L7OJc/SVI
         jg0Rf6cZB8+UgYFcNYgvvMNLF2AymOq449WA+vpoegdP+ZgJUlb0C8hXGSt5yI7R+jV/
         ijlw==
X-Forwarded-Encrypted: i=1; AKwUvBzca1TFY6uJ31tkMZ6B5zvJ9QYqDIRvEp6v1q13wWexS8/tqLcd6tFDNiOETagqJ2l3P/F6eWAKiQ==@kvack.org
X-Gm-Message-State: AFq9FYLXDr1ZbBY8XBaI+w1YYbMT1TPNuz3DKV+RmACO1+B1/OgeB1f4
	42x/ZkpeCl3B9RaysyWmvKJcuEuhBu0W1KAu2fUADEvThMA046JnYP5JingwlNvUNWUDvYbHmsM
	1WL4UJ1prXQ+AtYiEegz3vNysgQ==
X-Received: from pgp15-n2.prod.google.com ([2002:a05:6a02:62cf:20b0:cc7:d8ea:a7b5])
 (user=suseendranb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3dc5:b0:3ac:9c37:942e with SMTP id 98e67ed59e1d1-3adce0ccfb4mr376742a91.49.1792711657929;
 Thu, 22 Oct 2026 16:27:37 -0700 (PDT)
Date: Thu, 22 Oct 2026 23:27:33 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022232734.496064-1-suseendranb@google.com>
Subject: [PATCH] mm/zswap: validate dlen and normalize comp_ret on compression success
From: Suseendran Bhaskaran <suseendranb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suseendran Bhaskaran <suseendranb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 24D9680003
X-Stat-Signature: aghgxsxtiijp6536hb43pjif4c4irc9m
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711659-545242
X-HE-Meta: U2FsdGVkX1+ukT+RQPr7j2zVL5ZKKn2epdGKQEozJQTiewZaLncoZo6Sa4hXKc80+181ESoAwhSM55HqTi+vMo4KU61GgOA1JEpvcWoO85K8b/K6NOFxTk4u8EiPD4QsT3XghE6vejsJRNdDqC1+Pl969nt1Ok2ewnaFsf7hIn1ugZF2kMYIMaACMVtpjFgDjMnqWptpYzS3E/A+HGDmciYbBDGoFcKbqHgw+e4cTPQKrd42n6tHoCBUBhu8EhB2CrfNlIoYz4SIn8TxfejSUPysSarFqXOYJzg6mNbXM7OP5uNKB9sAGiGx6GHx6D7a02Kk7zMtk+uI+BABgle0fkDwZi/yjjby3YsxcN2DvR19S39sJU2OCChG64vHvDGvcvnyW92M2960oCxOfHgqIQUMvxoIvPm+jo3mz3qAqczzH3mVBhRc+AGRT5ndeaHE6+wc2Xu/uy3WbXHTeWYRztuih2GQxanGkAXhIYJ7n3fZlfnpYyqk+iC+N5R/gHA9zpHMG9WzTAUwZLsWXStrcFRb717HlpdtodAs7Y5cLWOeflUvIVnB2Hz+sy9dGSjU1oh0umqBHJDB92JkT9tNI5VMfjBxgFyhNMwgZy5C5e2cdDYdLH0MTfFUif0woMQSSWZPFTcY8HiJsXQkVT49AUVXTkEkLr3uovGK+9QsEyNFFdwgTncFSSru33Z55E34qGu2grybS+CWWluxlt4NLUpXvtS+y4rutbCJ3zwWczCWR4COGA3YSawFNjPjFO83AGEuHyGLZzDzHVjtcRfkWMBCfJEW5QcRPvdYEHeuRHSM51YyAn/dcvmT9xu6tAf209m+RJV3B4kdbqPoj8KOBspB0Cw3rIi18aVvyt0ICwHXvhaJGP03WJ7Zua9j1J4Fsjg+yeTaQLMhadkRsKN99RsWxRxxtPC9Dyhuf/PbAf3+NtXb+IWOG0c6gn/Cjp0/2Cb96vPt7k8J6otgbJ9
 dD9TgVQi
 48lNOfgb7j3OqpQRLy4cNZu6ZlPahrq2ghI1l5TmvbtKG4o868/mxPC42oxbtVrAQv32KCfDhwuTzk2oD3G5VeRgks5NWtD8MtJ0s7RRc6kYgJTF6UtyWx3JjcVTI1U5pMliqyCOx87k6h4RODTuUu/RKDGOdzs1d3J4XZZM0NXA2kTEn9V35V63PRMMO7Fmy9X2X13okQcGR4N4/4ejbjeRbPrFus6QXeQzi988qbZSTaIoH2HHqHbtbbPjjsv0A5drElUaXfuRCL7O2YSySVWpmiWJi93vBlMO4ef5kdZ1FsbsQ+1zGzRQ+QYqauN1F1Pejc6yNr4mqaMZ3Bb5iG33SQghA+3oOnpt9U2JeoRAmdwrNw+6Bvgbil9SCHB870QRZucpN8Wvvv+nonrVymM2Cn/vQo5lUwZ6ujez4jJh64caKKDu3irCMiBeEgBhusccbQTrQLVdVHFLqgl+TUxGsIK5XowXEvbgCsH7/zONLqkEL62aZQVGWXQDix042ruW1Sx2ipGj9FPkhRGfRCZcUT7yBoG6rZXyr9pz1TyXD82tWuuI/hH8juDoKRstvW1is7XpTT0i6JPaWbWC56MelxeMvHyyak6GAzCsXoT7Oh6NBpkAbQjD6odvj6Ril1SxInjkVKTiQ6oyHkE0WGoRWIPslm3OVpiJ3ymGczqnoeVOWNL5iWtJbxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In zswap_compress(), dlen is only meaningful when compression succeeds
(!comp_ret), as compressors do not consistently set req->dlen on error
(e.g. zstd, 842, and qat set dlen = 0; lz4, lz4hc, lzo, lzo-rle,
deflate, and iaa leave dlen at PAGE_SIZE; hisi_zip sets dlen to the
hardware-reported produced bytes).

When !comp_ret and dlen == PAGE_SIZE with zswap writeback disabled,
zswap_compress() sets comp_ret to -EINVAL instead of -ENOSPC,
miscounting the page under reject_compress_fail instead of
reject_compress_poor.

When !comp_ret, set comp_ret = -ENOSPC if dlen == PAGE_SIZE, or
comp_ret = -EINVAL if WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE). This
allows simplifying the failure check to 'if (comp_ret)' and dropping
the ternary assignment in the writeback-disabled path.

Fixes: dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")
Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>
---
Previously sent as [PATCH 2/2] of:
https://lore.kernel.org/all/20261021205626.3286270-3-suseendranb@google.com/

Changes since v1:
- Split from patch 1/2 (which is going through independently).
- Keep existing writeback-enabled behavior for comp_ret != 0.
- Normalize comp_ret under !comp_ret and check 'if (comp_ret)'.

 mm/zswap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e..1e727abcf9fb 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -873,6 +873,12 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 */
 	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
 	dlen = acomp_ctx->req->dlen;
+	if (!comp_ret) {
+		if (dlen == PAGE_SIZE)
+			comp_ret = -ENOSPC;
+		else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
+			comp_ret = -EINVAL;
+	}
 
 	/*
 	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
@@ -881,12 +887,11 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * only adds metadata overhead.  swap_writeout() will put the page back
 	 * to the active LRU list in the case.
 	 */
-	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
+	if (comp_ret) {
 		rcu_read_lock();
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
 			rcu_read_unlock();
-			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}
 		rcu_read_unlock();
-- 
2.56.0.257.gf7497c7d27-goog


