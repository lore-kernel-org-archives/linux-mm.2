Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC639CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 06:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFEF26B0092; Mon,  5 Oct 2026 02:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAF276B0093; Mon,  5 Oct 2026 02:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9DD96B0095; Mon,  5 Oct 2026 02:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6FE36B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:53:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3AD7C40164
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:53:05 +0000 (UTC)
X-FDA: 85287655530.01.CACB811
Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7499D40003
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:53:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cpDxdDFj;
	spf=pass (imf27.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791183183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNdiFKmiNwVXREQZb4H6BvkiMV9G9eQw2TPowFW6zrs=;
	b=xUMYFSCPMHgLVA12wkaw8EJ6DgP2mkkdNTanHu0x541U05hjkHWtVgg0t3FcDnDMTd/U4v
	aEBTgg33CKBtx8JNN4sYKzHR+zfXuQ4sj9UQ4QhLMuN+zh78wNV8nnxruDAQonZyIuHXSX
	Qjp4RYaH4myF3LSWAjTwIfK8z6d8U+U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cpDxdDFj;
	spf=pass (imf27.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791183183;
	b=V5zwNoY/CpFVcQ85PhjKA1GVc77ghqXWHptIMUnaVDwWATIoZI64UCs/PUzxAyXp1HznpA
	99H7IMh4GOMaKWeQi1hOwS2orpHKW0JYFRGau9R7qfPu0enVaSnS2tQu7WmNZ/3Xg+/g9o
	V+a0H7PG5NRGZFRZwq0JJ5hJJHnRgn4=
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48b00a0ac65so620668f8f.0
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 23:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791183182; x=1791787982; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wNdiFKmiNwVXREQZb4H6BvkiMV9G9eQw2TPowFW6zrs=;
        b=cpDxdDFjRGsfPec114b/nqJX3Uy5LoTvt4fj/+Ek4ZxeME7ZfKEIVM5okQ3y7ftFMG
         Bq4D5ZavOr7VYPYte9vJiZvut6FU9xFEKKQbOjHsOTMhEW9AvA+AL5Edz39Aa4VK9vf/
         T/Jp0RPUyYVb1xYFKYm2k6NjYVXStpZj1vPHAwvUKkcEhJR7wNv7dWSdRrJINI7DRCxK
         PfjVnIk0uJxR+/zRd3qtVgHF5fNU8xeED2pBvf3mr/jBkpmx2nkteNPXXJRzKOtjDBR+
         fPxWab0SOqqIi53GAMwjXYndjdObKKyiv61bF2XUvflzRBKc0HNVG6BIbvQZRjqS0ZgI
         uJgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791183182; x=1791787982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wNdiFKmiNwVXREQZb4H6BvkiMV9G9eQw2TPowFW6zrs=;
        b=A+k7zK6h8JQQ9tn3GGkAYLbrXnJ0lclVqVvCJmwQdCgdFQd6AHhV+1/BfMM5qgyr0+
         wQ1sAmGFT9TW7i4xIpejGb0ZTfSWsd0T/xZ1XEmOND7YUKuUclcV2GeiNV8o0IPOQX/k
         Z4qs/324stUcFFHC1tpkEpdOgzfwS2e5AHc/i2vFuZOVeA3gtvYE5gvfJezjkrBwTY1z
         fEfmPcI/iLheQCx4GAWN9Qx8MB7xBb6uf503LdJOyHm+OO1oQMJdTB6V3nfkD16Ibcho
         MfsFD5LPHOasbHtgpqB03KGr9PyzxfNzjP4sXzNWJE8gP7dOpp5iAB7XkUH+u+XUs5BD
         /J3w==
X-Forwarded-Encrypted: i=1; AKwUvBzHuykWUIrVmefDdXnSxJjQR/0MNEt6v/Qt8ZVjfZHmxYSBqZU8RlwRfxw+Q1iienX/hjrQuJqN6w==@kvack.org
X-Gm-Message-State: AFq9FYK5ytsvwTGopIgbPSkWZq2n/+P/laNMiVdiVe/07SN9aPBVX00l
	X62gVMryqgz2YlGwIssDrw2QWMLpo2nCNSJqTN0m4H83kLuz+1qFjwGM
X-Gm-Gg: AYBFou3jBCR8Zlh2wzieqZ2mQ1OEigFv5ms4o0mpfu2RPiQRX5ubK/jbj354y3UHpwk
	nu8jtD/a2K8LZMDERPUGsany2NjbP0ZpTJQIuXL0/P1B2NNODZg7u8AVjuvBgyqSxh+XGDxLC9J
	MREyUft4iOfAfvpYWQZVTErDIgYk5ym9+izJ42Rm23smq0M2vhHNmHnYAsQF3SEyiljnivhpzLz
	ZQLEtIxY8gx53+MdML0ITIR9tBDL/3o4qE6wy6AE4rGw6rhn+l5m6F8sNPaQ7JZl8cIymr6gRZq
	wVOUDRyb1kPdOcm8qz3LEpjBk9KWPU8bUi81AQqywjkcohHpRtSRQ5Np9lZpSxj+aBzrOVdzFbl
	LpD2ZhG4zUzoQaBE21xswhLb3RHcXXxNb9g7LK8NG2xSpzYe4f4wAW7CZqqSu2Xt6dqrpwxh/r6
	mb9WYIPzuYKgnAPNpPZBDQ3fGC419M2PMlDkL8Zm4s35yX8O4by6OA7Uo=
X-Received: by 2002:a05:6000:4301:b0:48b:b1a1:a002 with SMTP id ffacd0b85a97d-48bb1a1a2c5mr20641697f8f.24.1791183182123;
        Sun, 04 Oct 2026 23:53:02 -0700 (PDT)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c6308481dsm1247436f8f.3.2026.10.04.23.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 23:53:01 -0700 (PDT)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Park Tae-sun <ts930@dgu.ac.kr>
Subject: [PATCH 1/3] mm/mlock: make a zero length request a no-op whatever the alignment
Date: Mon,  5 Oct 2026 08:46:29 +0200
Message-ID: <20261005065244.6935-2-azpijr@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005065244.6935-1-azpijr@gmail.com>
References: <20261005065244.6935-1-azpijr@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7499D40003
X-Stat-Signature: fhbjf9jaqokcyh74p35dzxgqq9jzf7cf
X-Rspam-User: 
X-HE-Tag: 1791183183-363443
X-HE-Meta: U2FsdGVkX1+5yjfvINAf772WGJ+xn6xGVhCqeDY21Y4LXwgatzpfx+xzA3MgHcR1GOSY933NhJF0iqcLnMUunDdRr++S4wKNFbQQkQJd/JFoExaUWA/zSwhaAHKvUMjhuCz5vt1UoLrfAzHlkqEk6R3p6chPJ/iRKpwouRQn+bNPqvUcgvbDR0JeAFCW4GmLcDNRY2H2TQklH2hj71IWGPDcwvUJogvSPyKptb6Wn3Krt7K5X7jSTFmRojWIJmegLkiwHqD/iNahsCqhB9sbRDujAoSwCB/ho544ED2y9XBbS5tsaivW3DXh17Zisemxa4Ong3MPHAztVtfeCoIHY5cLxCF99fIWldkYToBnDT3yHV7Uw1xueTCmOkJTY7A/X1pAYBlUJZlfg1c0LfRueneahyto31pKwe93Eq6javezN14heFDdgAnCR+gzZmBgK3QIxEh4cAZtbkwDG9FxnnFS5oZHJcG1NrV+2tPDnMYafZBhffNsYV0txS9wW9Nz4hi31zxOUPZv6i3ApsNcUCImGLguCfctF2cTcPlYIusKzCt1oQdQrS2lCNJCkP0Mg/JG2mx/vk2XP5NWAgBN+r3DehoZOUnWFAsYX8bdExpsmIMUgxrCvJvUKZaW4TxBjJyLVu02bAPkNY4KW0c9eNg5RXnIiMqIJoTbe36usNrzymPd2A+fKfkilnaNYRVS3NqnJ74ZvNVhxQvrbfXj47fzd5q6zb3AtxRoiJB6R1ImPgIiYMMQy1fQKiJFALEjzYf385b0hMJnSjtBcjHHlTJpo6g5rZa+pQGvw+L347Wi+prJYmQU9UgZtdNlCO+fJ7QTsrA7T40oFdMOBWDhtaA8UVHAmGHsCbEH68e556x034Bds8Lp7Avd9kwNumDpdzmZYQTXgY+/BS+fBbjilkrkDyjRgmNmE2GzB5uikga1d8bSvwmL5jpk7pZIxrzJNTdQnDzxpKnLxovcbI1
 ZHpTZXJA
 R8+VvpmE/AsPNY8qolTMPzlAMsI493sq1IKRm9ztx+WNCPVc+OptbRcP4dnxdy3EqoBDYumSL+H3wM0BQs0gXQkhvzSBvBsWe/u+oLV1TOM9ls8XhjWnsjUBIBBUct0HNzt1YaW/U49J9M8HI/FzulN+xVifSLl8tV4SYWkIhb7FKrh6xMgr6CTwDpECYqoM7FNTLIwNA++3HycUVx8P/dp8lIjMdgy9D40Jn5dQLief4uRv8iSgP7bzUL3JvSrVIdRIlHEta5W0Y7WMsLW4dU9VQGU9ALj7BzR58TAP0M6mo7IOI4d75/H4NHwzP3zCwzoE5l3NefiUkt/zSn+gHJ7AvKXEbvLEcI5DKb+rlvUwMihNIxD5j8IG+aYFwOaa/y8Ob074WOVryPaMpNltABQqbNi7TyEYcS2TWZApoczUBsDbTob4136MjELQvywEjhL3L3r1lL5TaeOS0a31zQRQWxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A zero length mlock() or munlock() at an unaligned address is rounded up
to a page, so mlock(addr + 5, 0) locks a page that was never asked for,
and munlock(addr + 5, 0) unlocks one the caller may still rely on. An
aligned zero length is already a no-op.

Return early for a zero length, before the rounding and before
can_do_mlock(). This is a uapi change: with RLIMIT_MEMLOCK=0 and no
CAP_IPC_LOCK, mlock(addr, 0) returns 0 instead of -EPERM, which is what
munlock(addr, 0) already returns. man 2 mlock does not say what a zero
length should do, and -EINVAL would break callers that pass one today and
get 0.

Reported-by: Park Tae-sun <ts930@dgu.ac.kr>
Link: https://lore.kernel.org/all/179066531783.50175.13377521828379196177@dgu.ac.kr/
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/mlock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/mlock.c b/mm/mlock.c
index 4235a1518fc9..cc28e5d7413a 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -612,6 +612,9 @@ static __must_check int do_mlock(unsigned long start, size_t len,

 	start = untagged_addr(start);

+	if (!len)
+		return 0;
+
 	if (!can_do_mlock())
 		return -EPERM;

@@ -678,6 +681,9 @@ SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)

 	start = untagged_addr(start);

+	if (!len)
+		return 0;
+
 	len = PAGE_ALIGN(len + (offset_in_page(start)));
 	start &= PAGE_MASK;

--
2.55.0


