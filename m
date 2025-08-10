Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8815AC87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 12:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716846B00A3; Sun, 10 Aug 2025 08:42:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7AC6B00A4; Sun, 10 Aug 2025 08:42:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DCEB6B00A5; Sun, 10 Aug 2025 08:42:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2846B00A3
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 08:42:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B79D8B9B50
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:42:16 +0000 (UTC)
X-FDA: 83760810672.21.F8CB743
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id E8519180008
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:42:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jHBQDfzD;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754829735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TcQGvKOIDHORnKmX24vXxaChAnLPw5HFeXu1GYRj8bk=;
	b=xMmL+4azaaSdSFt1yrALMsDT8E5kPUw6Pu8lAcMW8JNK7d60J17do+BHxjEmFyXUDgwrTx
	muRy9INZ0kFPVprCNkVme6EqRUb6dnuIctSoafXYybcwzsPORFATSnvzoMIE30PAcr2wGl
	c6GygJ7h32xKXcJIyfu1FpxBpgFXDpw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754829735; a=rsa-sha256;
	cv=none;
	b=krQn2dFqgePufQT+ixpbGhPRYLT3aspzGX/lFhztZ030sufXh63IPkRNFJh8Qb6YQ6CM2M
	gHsu4a6jhyIr4JLUOUQDUH/3jCU9MisfUdg0C5VDKbmi6ZBfPNNpG8fYuGmf/gB5qE/q4H
	KJrTGUEHgcd1bi/lpvwASGlVnsI2ATI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jHBQDfzD;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-240418cbb8bso22051105ad.2
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754829734; x=1755434534; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TcQGvKOIDHORnKmX24vXxaChAnLPw5HFeXu1GYRj8bk=;
        b=jHBQDfzDZXhXYzmArkX4887hKxY96+3VDSUbpA5GQTwEzHf4ufobySOUNCc0cEzH3l
         os8I/lQonR3v6HOGyFWVGBvNzOV7G6s/SPk0P9r3pzveB/P15PIRhTwGxACN36oniKk2
         E7TP0e05uSAo/H+XpIkP+yb5jhdkzwKZzReu8FzyeX3nfgI/Xi0zYC+o9V2QPNx7QOsV
         sex04hsMjkscDr3JtFZQvuFhJhpK0QCFOmmDfFGJLIgQvp8NjFIJn1CtbM0AObAYX4/t
         ANvTX3SAbVl4vMPC3hF6Dw2mFQ8mfP9RBRHs8/sMEo4kvOAk3AvbZgXZHhXxtzcnkG6c
         2SKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754829734; x=1755434534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TcQGvKOIDHORnKmX24vXxaChAnLPw5HFeXu1GYRj8bk=;
        b=aWwG8V/BZUthaZb2kZPyoZ2gvLN3xqya19WZnHuZWYuN8mjMJVpA0BMsmZ9CveEwld
         KIEdP5l3v4rUCBLN85aWemOwKGlFFTVYgO8J6KxusF1r9PRA9ba+vnQOTUy8j/DIjC6H
         ARN8TPryK1+y/Q3kGO5BvHJHFiW2fcH/Fivdvwxs/0z96beRa8nSzu7jYJg94wXGQdU9
         N+m1QWD9pYzToSAdBAKeg0/FIDZxhJNARAnqIBJ53QryQvxX8RxmcAJ9VIP38Xv0Zx4M
         X8IFzYHg60EzDlkorfc0ve6YrlKg05eAcgXOQwpODgBQ0/BywyoQjldIY2RZBW/NZuIp
         lZkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMN6cZSqDDn9EzovnhnHcpt3s90GeEEfC0ax3jy1u/vLXTl0x4VmWCv3Y58U+r9gM5BGy4mVzYlQ==@kvack.org
X-Gm-Message-State: AOJu0Yxy02ZyX6/5FSDn85C/8CBpn90KOlQFlNR/ZNmFVn9BhKYG0ZHf
	vOaVyGyo/AyskVGLdzpCJ8lSFbjXEfDfZtc5qFh4qV1ss0z42x6d0mLG
X-Gm-Gg: ASbGncvx510OqiKIqtNbIg44Iiu/kJvA2JTSB/hUO4LFAem2opBPGVFBb4VKaytQMzO
	enj6jhxc9wc8MilvkxUqMDfuI0sj3mGboNG4Lyj5cjl726e8chQ/9tUtQVlIu5qyZPQQCZ7oAJR
	wVlk2xpuiKaOn3QdGj9Q+ED0aIKINf+EjPsJ6BjxOlbWJ6MxfvD69XtBMKdB65JzEtc8hHFc01K
	G4Q9m7gCsXt81DnHTrTZOsR9QFEgRT0iBDslowUz1XjD8ApiqFlfNDJIialy/IupYZYPEyr6QhY
	Ex4HuPVzS2VFZjZ+39tt65TS83V9oQPfERsWWOyko+iLK/q7knk4wQwNnEy3M5/aGABE3cD+nfO
	dWH46CrZ9LtluKst0NFaHkevr6rk=
X-Google-Smtp-Source: AGHT+IHyMhJfJJH1ELv2+P9EgJdV62MYhw2oG6J17PQqZcdm5A9jDNNNKFQVpJpCFbBu8/2aysNFkg==
X-Received: by 2002:a17:903:3b8c:b0:234:986c:66bf with SMTP id d9443c01a7336-242c20037f0mr118041635ad.11.1754829733612;
        Sun, 10 Aug 2025 05:42:13 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e897690csm250583105ad.99.2025.08.10.05.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Aug 2025 05:42:13 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] mm/damon/core: fix commit_ops_filters by using correct nth function
Date: Sun, 10 Aug 2025 21:42:01 +0900
Message-ID: <20250810124201.15743-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E8519180008
X-Stat-Signature: n5yn8nikcwouhckq8cfkdyafqrg4pdqe
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754829734-974137
X-HE-Meta: U2FsdGVkX18fCiGGlCUKrQLWV0xR1oQgwM0bz6PKZQGbRoYmFOoxtVgHfXmLd9llcsP+iV4FomrFjwqI3z8UclSB4IITmRCvuQrMIRCNkQYjsqm+I/IZi/Wx/k2p0o1wI/5NoqWJrwxDZDH1nzoFk55La8ypnHlRhfL1vBHKdQNICn+oFxhIKgNpV5Mxo99554/9NVpBl7LlEpOkgo8fv7RVd0BkIgNWtUu2UZNLviR3sn8ztBMU8H7M5H4RX5JyjgDO6cwuBOiOO0odimrwTgKNnr0Pnzqx/JfBAILQfEBfoZDpmt4DBqHs4uX/+l9+Sry+Bq+W6dqAPO9sAlX6A27AY6RXjfL9vJ/zkiKoxoQtTxFHqSP0caTcSndLQ56MnRNxPzU0Q2YNDFiHIO0Y1L7Z1MZt5YSIsStbGn0yd+5aT4SaKuL6AYYippcg+o8pZYIMpAt+cimxK+Ur9B0iYXq7lu4Za5UsjxrQ9kvH9ljZ8gJNXoajWneKnvBv/qLC4ZxnfzgpTBGnUR9p6CyAfOC1pOTEQyNv1HUdfP00PZdNpNJkkkWBsOdB/X2Sh5kJkROgMMcvJ2x5RzTri7RQZ66VTDbj200InGewxjdwXQgsmhAPr9nSzGwBOwNzdVWrZDTl8grglpVX86TNhAHz8dHYKSDkkNrN+Dkq7Qv7He6Ok4JLnQiKgjEePabXSVF7tldLTPtMfOXUE5KjP86Hsz1r9sL9kZMkuVunihVLuO7lhKBArFVWJBzJFwpR0wn4+fHcli18ZnGlTdbQAruc1/odI0R/D5NTydfJPyzyjXvOB3SkDABqYzZ5TZnELpnli5HESDcm7O2YziIuPa43dZQKtGNGTsxHTRfui3ZHKc9dW7NHmNmfMjHQr14U70KE6v4d1ZoTdrbwtoJ393tBaBMoJ+IMdb+TiZPkSwyQnNaeg9Omq8tTWGLabRpaY1i8MTXHskWIOe8l4KIN3mq
 aE+5O8Ah
 3MR5FuWX+Tx4pUD+tHzBeOnsfTVykdgpgMJgZ0t8bKI9Bh9ibWM6R2rGt0xjKZG4TdVMPOeJ/GJ+yLb6LxNssKRQ1MCxnbTMrXdYzGk62QTwqyi4yUyHgrtrfdXPQEfsxYDUlYYPn8ug5mdKZOoqc2wWWuozGcRkEu2K3crjd4IXYqYMcUUPr9DGV4WZl54tMxrFsG/gKqBQ1mec6u0VYw/1dfkQVSRTCwjDZlSvuRJ/3EHp1/FDPbdLCfMmDypnB2T5DSPK+Wyv0/6bNlIPFr7YiZaERxVExf8IJQLhW2SCpycve9MNLDo638lodNcvGipVehuH9L4Wk7yJSCf7LlpXV0Qe6NJA4mqT9h/JZQB4GldVAvf4IEQBLr5POWlqK7hgyePHkATAxkUnqfXx/HC4Q/MO2lQFsYbhBE6wi0BjSkxSzUyF4cuDgxALW7EQ6pnmH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_ops_filters() incorrectly uses damos_nth_filter() which
iterates core_filters. As a result, performing a commit unintentionally
corrupts ops_filters.

Add damos_nth_ops_filter() which iterates ops_filters. Use this function
to fix issues caused by wrong iteration.

Fixes: 3607cc590f18 ("mm/damon/core: support committing ops_filters") # 6.15.x
Cc: stable@vger.kernel.org
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/damon/core.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 883d791a10e5..19c8f01fc81a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -862,6 +862,18 @@ static struct damos_filter *damos_nth_filter(int n, struct damos *s)
 	return NULL;
 }
 
+static struct damos_filter *damos_nth_ops_filter(int n, struct damos *s)
+{
+	struct damos_filter *filter;
+	int i = 0;
+
+	damos_for_each_ops_filter(filter, s) {
+		if (i++ == n)
+			return filter;
+	}
+	return NULL;
+}
+
 static void damos_commit_filter_arg(
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -925,7 +937,7 @@ static int damos_commit_ops_filters(struct damos *dst, struct damos *src)
 	int i = 0, j = 0;
 
 	damos_for_each_ops_filter_safe(dst_filter, next, dst) {
-		src_filter = damos_nth_filter(i++, src);
+		src_filter = damos_nth_ops_filter(i++, src);
 		if (src_filter)
 			damos_commit_filter(dst_filter, src_filter);
 		else
-- 
2.43.0


