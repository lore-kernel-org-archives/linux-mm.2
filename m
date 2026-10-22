Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C562606A33F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sinW6Sfa
Received: by kanga.kvack.org (Postfix)
	id 373096B081A; Wed, 21 Oct 2026 21:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A076B081B; Wed, 21 Oct 2026 21:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260F46B081C; Wed, 21 Oct 2026 21:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F34796B081A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:57:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 471B9803D9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:57:24 +0000 (UTC)
X-FDA: 85348600008.12.7BBA131
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7DA6BA0008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:57:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sinW6Sfa;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634242;
	b=rF5DLsr2qBR8XjR0bSuw8GGWTlF/uZAjAg1HviOzWSx0w1SVvdmuX5MoY4IoCge3BfQrFn
	gbpvX515n2WuTwzrS9DvHYojiFQbeSGRaoIsHx1LMbIpYIS06dfc+6Fsdhcu3l7rNOLzpx
	jCodw+P5AFP7Flmgrpa1ScC6e0/Dxp4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sinW6Sfa;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rrt07MWuBvKNxCUpcIHeF6DdyBR4Zz5NXlnZyJVxMUY=;
	b=0A/Hhv6FWjMRyKFDa6mk7t68iK0AV9ndp58z3kZRQandoxlpRr10kUIQ7xntLCtzENXcfV
	c1U6UUZw8I10JGPv/W8gDk1PhEQd7FLzR3RktgMLkEDHYljBg17/38MGGFLOl030fRYhlc
	cRsrIYSqnU/dq7Kz1p1S7qOgHEg4EBM=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3a4b3ac8fb7so721446a91.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792634241; x=1793239041; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rrt07MWuBvKNxCUpcIHeF6DdyBR4Zz5NXlnZyJVxMUY=;
        b=sinW6SfaY/rGQUsDSkv3fECe4sxRXnULn57EJS/JxdG7mVfWoZijbEOc8ckQOGVY5k
         peS+FuEML2MbqHQ26necvnP02DRi58w4f4EP4x5S3DLfhwPd4pwMhY6DTNstDkFpx0Tq
         5uu+yqIES4fT0zcT/Amn9Znjyj4Gl6F3H06RZdDIs/tb/h9FH+oQAa83MT8TokjE+bE7
         Sseww7oT+N5F5WQxBMlUwbuLUpH35ppkhl4oDFUv0I4nvna5epU2tcdDZozidiQKeHBN
         xY5KO1l7LvTsif5HcGXhrm7o4/RqYCPY65NaFx1pVc8fgjvdkSKUemBwUzU+7H1O9Jqn
         cuYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634241; x=1793239041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rrt07MWuBvKNxCUpcIHeF6DdyBR4Zz5NXlnZyJVxMUY=;
        b=GZEYewdT8/hyQ1lWOTHz5kxXTse+85bU8wXs2MpT9vUbBcyol75FjJdd5/ZdWCd246
         hQAOVrRusBybYucz6gSVfLZbB49tIN8l7k29PrJIlBdQq7IU+sGOPnkAdtDA/j090O90
         TBM6pah/Oo/96oE92C0INncx5YPKKcb/BprpWmaatk3Oa8bTgd6mXJslHWEdSwDxrGHp
         R5U4D6EoDXERgwYDcO+ea2nX7XWmFofCFgK1zlXNeA3+AEVgmspbLtAUIeiyqFRGYQ/a
         SWpDEX2/7TKEPyJyKzWjezYWhvqfpyL/QF74Y/aJZKglB557lKqLXoqiXJ/I51a/vMCF
         4XGA==
X-Forwarded-Encrypted: i=1; AKwUvByP8PoGdaJoDZ0x5eJvAaj60CTq3UmcjbpFTL+la14mUh6cYAjPXa0dj1mZ0BPlsJYVj/KPMXDMlA==@kvack.org
X-Gm-Message-State: AFq9FYLJ3parHJ6RA1I86KWFkWytlaciobyy4/hxsrc+ycRL6qlKzIVy
	C5rmsizxNZnmbzsWu/zst9b+IdE+6fYdeViZO/cWJDLNQ7UiP3aY0Sm2
X-Gm-Gg: AYBFou3ztLSXOUVuT42udUoNgh1kk3dc8m8lHAttkdwUtlTFNlyUGR3wV2Kp3zAsdCX
	7ZPXfPMMCHmZC5L1XQPRtOG+35fD9CZ5XKGoGBh6fvGPNySp4dt5eNQOKLrDYBU49GusOehc/5U
	vX/bULM8hgYQ6LlupFGC7P8EALt6Iwes0IJ+ZLeqtu9I6Kgfk7QGqzNEl6Tds5LZpUet/IR3V8d
	q2RydeE+yTBHGbecR0yzwVivAsKJJQaMmiQiSlDVJomeyOQksOtloCOdKr9ud047z7yXaH3jj6s
	3Rf6mNk9cJhIn7l343S4XCmOqySgs9fcnRRVy5Tzzqg6pZqU+Pqv55PmAmre7ZciSiiYKtQQH9T
	nk7BYVtcD2jShquRZFrSy3xPDwnOw+xEgeaYAnkXEpGycQ/LOT8FDU/+2DRMF+eSigWYU9n9Luh
	HGtrReNuY32ReOMr4foQBbyMOZZqWf9WlfLK3PeI6vkD507KwdMJgySkXrvLgJ7v+ImLM4BrXYc
	/gXjivKEBkANoIVmG2Wfn6WdN6yyLy9+ec+Psw8VhFmCj94EV1Mf0Fvh8gWrC0fXwQcc5Js2Qkz
	3D6vLEVTlh882BVM2nlZl8RZoRIS2I6qX8Mz4XFybD18+WJACifSu6UXnJPqUSoOs/Shcoe+TlM
	cTjCrAcWM5Rr6dOce01K8fP7O
X-Received: by 2002:a17:90b:1801:b0:3a4:b74a:795c with SMTP id 98e67ed59e1d1-3ad86c79098mr3189121a91.16.1792634241278;
        Wed, 21 Oct 2026 18:57:21 -0700 (PDT)
Received: from coder-ast-ast-dev-ml-0.tail2dda0.ts.net ([153.61.198.255])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada48ed70dsm1701803a91.4.2026.10.21.18.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 18:57:20 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	oleg@redhat.com,
	peterz@infradead.org,
	mhiramat@kernel.org,
	jolsa@kernel.org,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	surenb@google.com,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	hughd@google.com,
	kees@kernel.org,
	mingo@redhat.com,
	tglx@kernel.org,
	x86@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 1/9] mm: Bring back mmap_write_trylock()
Date: Thu, 22 Oct 2026 01:57:04 +0000
Message-ID: <20261022015712.1297331-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aabr8i9n7faimear8bnfip6it9piynr9
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7DA6BA0008
X-Rspam-User: 
X-HE-Tag: 1792634242-611918
X-HE-Meta: U2FsdGVkX1/mEmb16WIclKULddR3CEIRG/UMHv9F0MAdc7NPBRX6Th4a+bEaRqNEp21DHR0fgDKrK0DT5mBB6Sdt5kDP3dI+CwZnN+oZd/oi+S5q9/PbRrfHe4WCtmHETkhuk92MDGioIJXkIg0UIuRkuMoXllKBnbzHYJBPrMEr5EL0+3GJasPT3LfP6sMiwarAAiYhEvm8rNeqsxf94YTxvDGfx0qeKptRIWNRd6NQF1hm10y/bCh9tS9n65Jbz7XJzq6DOy68UcK6r5HZEkdRxulno/hwlXpTeFm2zIVqdOLLjU04vCmjq9Cmz8cXR6clVFbQja9LHBbVU3HGlwg8iCKFzACrG6OF8RExWgaTABU5PPFnw4s5LRy/ItPl5TaJTnePBfUCOqPOwv+WfztB4BCWOo3muiItiLek62nbesBxvLEh4dZ/ze59dyats56kCS0uYlOptRlJK0nnOe8rdWJRAtpPcH9noVFVTAaY4B7i5veW1MBuGH81Qx6zlez7mXT6q6Ma1MxqPeAK5rsV88mRjT2JbPfwn+o25d3r6Q3ZeA5hF/6O9V8GlHHAVwDexex9OHJSP6tIeMAqa82isgbCnSmok6XwKOQzLfHXyJaiHZMEZ5SfGV75BD7IyPRy47FWBm3EcYqHDlkUdJeiLXLm0K0eViQZ3iyxe8Sf5SK6mz1ZWmPahcCvzw3PVp7QBlfdPYzTCeqclAFOh0foGBf9sn7fps3gtaTJ99JAin2gGngDqv2YkHHNu5pmoG+rSd6F1plaqFgxQwMbkSe+Y6GrWzBcmeUvITrkDVIDyjOg6ZRD1z6TkV7m8rmeABED7+NTZ6w3w7YTkAhyvehDFR3Z4xYz4pYvYxLOV3TN0PGIv0AqpInr19K2zo4aVarvpEH6HplEgiVqxVX2Na8VUPQK8SW723XzVGnE5Yo7wgMeHjCu2HLP0BqcxtYVIw9W9JadxNqEYE0R6cL
 h60YvDRf
 B9SwFfdzA7g0GYdlsJfshmU6veeuZrirei1warLDJ5aykr20IDlYnrQocwYRSIxJUm5FfjbtCz7SNITDxY6qorrdtzPjlF8sKyzjcnifIXp4kv+D2tCx6Bquh2P8SONZE7WYNZpCQBT3ackGERMq/7cphnk/R/ii6+QcJ6UP+FLQ54r4Be5ydXi2oSdE/zgiuse68W6e+DX+Yppb8gfIwN9Al4RiJl4E5hlYvza0uA/RKlNNL8NViupc2/xqZ9PVdT/bMbozPiacdw2SRp1YgvkIzBAt/+7LeKV4MbfApouT2VXtxfS2Tyf7P9PjUVqYxelqlWjHLXKfOwMaZvdP0dB8gaj7HMJtg4pNCQVyWYlH6SuDZtPpHMVoGNLes+xr9IdDoSMhmAidDcuPuW9YqJ6Yr9Ksrdc5OIvynjsqjm1mF6cJJ9eUr7ZI1jpB3vE3HA9vU1jHOEo1sRD6iAkQqSwUC0nshtxNYqI+CHM0rYOGk5ZbM9/lpIyPlPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alexei Starovoitov <ast@kernel.org>

Commit cf95e337cb63 ("mm: delete mmap_write_trylock() and
vma_try_start_write()") removed it when khugepaged stopped using it.
uprobes and dup_mmap() are going to use it.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/mmap_lock.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index b8a13b8d36a4..e5420b0ce61b 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -566,6 +566,18 @@ static inline int __must_check mmap_write_lock_killable(struct mm_struct *mm)
 	return ret;
 }
 
+static inline bool __must_check mmap_write_trylock(struct mm_struct *mm)
+{
+	bool ret;
+
+	__mmap_lock_trace_start_locking(mm, true);
+	ret = down_write_trylock(&mm->mmap_lock) != 0;
+	if (ret)
+		mm_lock_seqcount_begin(mm);
+	__mmap_lock_trace_acquire_returned(mm, true, ret);
+	return ret;
+}
+
 /*
  * Drop all currently-held per-VMA locks.
  * This is called from the mmap_lock implementation directly before releasing
-- 
2.55.0


