Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E4A606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JfHtDs5L
Received: by kanga.kvack.org (Postfix)
	id E07566B05B7; Wed, 28 Oct 2026 14:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8FFB6B05B8; Wed, 28 Oct 2026 14:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31666B05B9; Wed, 28 Oct 2026 14:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2B46B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:50:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D4B88021E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:50:45 +0000 (UTC)
X-FDA: 85372926450.20.64F6CDC
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5540FA0003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:50:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JfHtDs5L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3AUTiagYKCHAYibWmiUccUZS.QcaZWbil-aaYjOQY.cfU@flex--kuniyu.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3AUTiagYKCHAYibWmiUccUZS.QcaZWbil-aaYjOQY.cfU@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793213443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+UVeUN9zfkatX9aRBqcQooe9pOmTFVR27qwKTlMgs/Q=;
	b=XHoTmAXG/gdAg13vevtPo0oIlYKONGfJMsjlXNPSHE08infw8M/nWLPIRxrWnb6VgQRAaa
	NUJkv0/hrEqOoDriZhwR4HJM5bgwyJv8zWkksW36s5M345FFTJABETFoNDGJS5mJYXdTVD
	BFii1b9QQaLR8IuHWaDGB0NIFVZo3go=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JfHtDs5L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3AUTiagYKCHAYibWmiUccUZS.QcaZWbil-aaYjOQY.cfU@flex--kuniyu.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3AUTiagYKCHAYibWmiUccUZS.QcaZWbil-aaYjOQY.cfU@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793213443;
	b=Og1wvz2IO40klfFjfdh3T+H3sV+yUFfzIX0p0YL2B7+Xsg/btz3ZmH1BEtlFrs3rB91oDE
	phLYNfCRR6pJH9eMfcdAASfCYEjJIKHPX5vwUpDhKsJMk6nqekFXNJc+uKtCKwT9Pi9hRG
	zk/p2Gf2zV7LyilMbeW8VMnGhXESkvs=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd8b299b0abso829397a12.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793213442; x=1793818242; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+UVeUN9zfkatX9aRBqcQooe9pOmTFVR27qwKTlMgs/Q=;
        b=JfHtDs5LRN436NG97ztZkhTDsc2gX5kfqH/VzI70NI+YhwF/MBRyqnzsx0r/B4xWA2
         NVT2sU1gfWXHv4zJ+rbWv8Vaym2DZfewZIXgfQD3YhjTOryxbTsunLl9dVpagFIGTJ1C
         ZNVBNbEvg5aNFlkiTRWvpNbFk7SzhSznjOU7BEfjBdlOmeYoLlQ0mHbj+watVBZmZ/MV
         gAIJwNNXzYt83Ug5EuOiilrfOIZz11M7W6IWPnpLMpfN9Gk6wgI9BR3dTh9Asdk2BRJC
         +qq1eav0gLqvY4bMXkYbUu2sEAAagw210TjDJl7lhTOAvXl+CHcLFnxGHMVOAxWEvAXa
         vJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213442; x=1793818242;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+UVeUN9zfkatX9aRBqcQooe9pOmTFVR27qwKTlMgs/Q=;
        b=RRbmZ5IU2A06b6VlR99HOQnokuEDzKI2qc9toUT89W1u1rcR0eeuKP3FaeQcrReMP2
         u0Og/0VNyQ0OoSOcLALtVJFo9GSGtRZi+T7aIwkgk8NQINRdlmwpFjIy1bqBWAZeXsyT
         wX8XFA8eJhnpqNBj/0y3THYnhHGkAgtB3Ue09lcFPMQoFXwPuDwGCcYU4oLFTr+rHrED
         N1YAiUItgOdur9tz1djnufDbnY3fatX6sUOR15ptoaSUQ076QdNbjkyQBAD7WCdwn0ke
         Hu2SbGfyEEjuxPP7fBsz+hpQlC6pMcweO0YbMaPF4/cHdOauubeYl2QQ2ldSwJeTgeHb
         YNzQ==
X-Forwarded-Encrypted: i=1; AKwUvByGFfkSYl+0ycVSjxgHA2jKjNPffE1vbAXjutrnr00iziKmWnUKyVXGMeOLhQlcnInkaISqcDM4oA==@kvack.org
X-Gm-Message-State: AFq9FYIYXg14XDDZiQ+9TmRH/j+djV+8kZjI6PiB1eiF5pAGhzUF+yaf
	Sm2PhDuS0tnuiYCJSbRYU41wan3vEjXijQjodivD5QRWTPyF7hvQhJ22tqbEUg0hCTMgqAsDgH/
	HxePsJg==
X-Received: from pfrg14.prod.google.com ([2002:aa7:9f0e:0:b0:89e:6029:204b])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:918c:b0:3e2:117a:62ff
 with SMTP id adf61e73a8af0-3e9023d6b5fmr2794333637.61.1793213441975; Wed, 28
 Oct 2026 11:50:41 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:50:18 +0000
In-Reply-To: <20261028185034.3607746-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028185034.3607746-7-kuniyu@google.com>
Subject: [PATCH v2 6/6] selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5540FA0003
X-Stat-Signature: nwowttxoxcnmj3szs1pd94j88reeootj
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793213443-652215
X-HE-Meta: U2FsdGVkX19ZK2DEg+rIfBhyoML0SZ7KtaKrWeKwohlXBKuBg7m8ije/h7rbdu/IImlDMUpRPQZsZJc2gs9zGAo0k4RAq0wMjWe/XXpTSGr1YRe0zC+TJXKTom+E+/R9gUI9O95Yfbwfm1KS6uM+hlostb1e+Xtk1k7mFKwGzE0dBTj1zkOosQP7DR1UANoc5kb/jIs8rspei141LUyxR+SgwcDQLs7OawLBFiPJBigQRaDWawz0iEaoFl8bWC55BMg46Q5hz50lx4yYztvbt8jut/1nAvoiCOC8GYX3QM9diQanjpoTRpuMvgXP1TMwqjolQbKC/31pv4jIqyHKNec3+2uTrPkQfgIvwES0CDosIFzjLVnCSy25sPq8UkQp8x66x8INYs03pHC0/4ZRLygaIafxku6s8yB3AFsKxScsneyrcU+MbxaIQswx8874OoKhHonr0P2cWShwEwdL92SBXBI43Bl4e1Sv+fj8M49vELN7IYvWxxV0eSCJVeeviLvc/ol3YrbSUYzOVG9gfffVpgfdI7mvMk5myvmyOjlT6tzm7lvZjnBIrrzZi5YZneQGBGED4eMrflKXfGAbj14mitFDT/qqPEfoTUjzO0QzgGbWCYbeVmmf94nKvecL5yqohu8mfmWb6KdiWgd8el8lRksUxNc8VON5CGpqv/B11LLRHf7HldFBpHPj8RSu1NNWrJZ3RHfNOjRJcRzNYtNcbXRWXT/hVUd5AbaImrQS+kWYFS0k4LXFua4lCQ+L9nnhDXykxp3NP1sVJeV5W0aCENV5LcAUs12Au6KnQnGM9OrTUqeeLziDEklbmC9ZmKp1QyvRBt88cIplDEpV8tShk+ArL14UXqVzXpJ7Jqz2Lo02E09iWTUYm1aWOqEInOQE8Ca190agkH3JDyOvYA3PoVXyiXTrN+evWT42Lka5uVnP+hFOv7EWbwI+lhqU1UaP9mB5w688tPHTTZF
 PH6HPxLu
 tDWa3R4p1RyBJCBLncMzzfEhyvog9pZ+kA7CpY2nIn/GtdOdc23FmYlxDXVvjH14cO0zOGWURvl5lLGq6eFiItT3CfqqCheVmm0OvB4yYXQ1lLsHzX+l7C4IdCvkVixJQoIHpPSHN54gjBmg3R/9INRAViHYYXmuz8r5KegGol3+NpGgOkcicvsQbd/MfGI6/3mlTNeir2aiCdt86ZWdecSQWTbvHadxdL3ZFWL7fdh3vxYH6FVJ4tnhyFJCyqSk0uNAL82eSO6MPRYecxP46GSIiRfXh+RzSveSTUmsaKDsmvANL5ZCSTkW8M5GRkC/z9ZMcJhuct98Efbi+BMhrX4pEkw1//iBn+XztlEXQIpgzBIMyhTqPwGuDwbrWUgjWsrrAC1QPWNJaEzJnVBtz986tmG+fhZe6NK9lx6/COvW95KofHVh+X7lFKXL5N0qIj7r89VZ6u00FBryin32+wmK6gL77RnPM9Vl+NjpgeaRYEjcIOa17a8PBmAGkMcItr71jaXvXO/XHPud79G2ugPjg8OMvqYWEGqtnsWcFpSQ37Y5Clr8fjH7ZduRww3UPCStuZX0aLYYhWypyYO604PRgOOJdgQYHGYplRAtTKsRE5SHuxtkFEzhdVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Now, MEMCG_SOCK stats updates are batched in per-CPU
memcg_stock->nr_sock[] up to MEMCG_CHARGE_BATCH (64) pages.

After closing the TCP connection, test_memcg_sock() runs
alloc_anon() to force an rstat flush and verifies that "sock"
in memory.stat drops to 0.

However, alloc_anon() only charges and uncharges anonymous pages
(nr_sock == 0), which trims stock->nr_pages[] without draining
stock->nr_sock[].

If a residual negative delta (-63 to -1 pages) remains cached
in stock->nr_sock[] when the socket closes, "sock" in memory.stat
stays positive even after rstat is flushed.

Let's write "0" and then "max" to memory.high in the flush_rounds
loop to trigger drain_all_stock() and flush stock->nr_sock[] into
per-CPU vmstats.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index bb673012dcf0..62cb0278168d 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1483,6 +1483,14 @@ static int test_memcg_sock(const char *root)
 
 	/* the uncharge is done, but a flush still walking the CPUs can hide it from a read */
 	while (flush_rounds--) {
+		/*
+		 * Drain per-CPU memcg_stock so cached MEMCG_SOCK deltas in
+		 * stock->nr_sock[] are flushed to vmstats.
+		 */
+		if (cg_write(memcg, "memory.high", "0") ||
+		    cg_write(memcg, "memory.high", "max"))
+			goto cleanup;
+
 		if (cg_run(memcg, alloc_anon, (void *)MEMCG_FLUSH_BYTES))
 			goto cleanup;
 
-- 
2.56.0.313.g2479322e68-goog


