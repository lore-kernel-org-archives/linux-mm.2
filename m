Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C56D60A2607
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cXxAi5Nj
Received: by kanga.kvack.org (Postfix)
	id 3E3DB6B05B4; Mon,  2 Nov 2026 02:44:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BAA76B05B5; Mon,  2 Nov 2026 02:44:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D0A06B05B6; Mon,  2 Nov 2026 02:44:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E73DF6B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:44:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FBF180B9D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:44:27 +0000 (UTC)
X-FDA: 85389391374.09.D943D0E
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 92DBE140004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:44:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cXxAi5Nj;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793605465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frsPb1t3Wa1UoN+W1OLcN+MUypjNEa6QpG2s8csovOc=;
	b=vnfOkrjd8KRWKUynEWmHSyTBpn4YMP7TTlEGwpA0m895bZE6WYun5TnpF0TIqM3v3+fvkV
	RYRfKyGWsMLTHGNrCxtFXABovS/xlGdsRJwNya66mgbPCW58eWE66wJhzwHvBmHps0ojR6
	DcckI3zraun6hRl0hUqSYWiKeEneKtU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793605465;
	b=fpMqbeu0mDnOf/PvLsxolBCSV4o2Y3Sao7vxv0l1mMhKz+Q6CimgHY6WvBwMm/nZ3Kbx33
	zj/aecRuoZ5RjQi1Vj9z4b+PjA2teIlQgDqhNrb+vOHfq5QhjVXtyu8UVLAp7m53R1Z0d8
	G84oorn1qztJ2vjNdy7Swt1zfrsCJwA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cXxAi5Nj;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48c4be28b82so2790726f8f.2
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 23:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793605464; x=1794210264; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=frsPb1t3Wa1UoN+W1OLcN+MUypjNEa6QpG2s8csovOc=;
        b=cXxAi5NjajohKS6aSJt5Ud4NZZ57tzE77teaaps9zC3LfzLLnu1OwEytH+nHYhEH20
         Kpl3uNvpvFRtfRHJzr5ImgMYW4V+M1S0lryuyuhe53nOWlG2mKlCkOkyhcyES0N/RfYi
         l0mnXyD/unpQu6oS6ozsLeQqEaQM7DZh/O+CIlVCWIsfYEJ7Gk7X2JCKvq5ekspJI0Zo
         6oTYaf5GvNKZbrGzNjqpd89QLuq+9swteGm6+S/SrAPghcURmULe0Jlx5fXHFlbOLipR
         0OBkBkl0ybklbfkaJepxg0WE9VqWt+fVyYLOBWCRLIPBaDJVuqnT1FoaOZPc3Zcgqjrg
         qAmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793605464; x=1794210264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=frsPb1t3Wa1UoN+W1OLcN+MUypjNEa6QpG2s8csovOc=;
        b=268RzWFigsmyHhtpqlbo/Rjy3w7fe/Y7CPCIOrZa68mrhRLFbNIj3aiOvvDe7EtO9s
         gUsdyGZ2RgxQOw6T0OeMGb/zqbgsRkpt+ATx7a1ayH+FSVgsZ6wlSdM2mIUUMFKTemLZ
         F93RrC8y5txkjDrITCNdVNEbe52LmuIPmmr6Mev0UnExJqhNOJPASIf4PSYDPjeNc7WO
         UCH1jP17R2PpWsU50QyVlXQrQH/z12hG9SMDFKzse4ZZZEg8N1V4zNbPhYjP5zfI/p1W
         S1oYzQS6u6gjVT7IbAF6kvyCQuGqI0GOixW2liDSQZiZoD748dutyyOX8VnobT/GGlT/
         kCoA==
X-Forwarded-Encrypted: i=1; AKwUvBxLd4QWjrHoKthjncoys41g+0ygglwEhq+y2BxZ2Itk4CxVNKV17onwZWiOu1PCnbiQPq6TqN8GxQ==@kvack.org
X-Gm-Message-State: AFq9FYK0D9t7RYC/wVvrbBDoBdlqH43KTOF6MILljy1lxK719g6EnPl5
	IzQN+xk4f3BctqlyXIINyijm8GZJpISkgfhkRWZdM6j54PxkY8j7pVZU
X-Gm-Gg: AYBFou1ormaWJhFEnJsPpXiUeHI7kxgUGNMHpyEHmIBU6TBjv3jilKNKdqSJ+BOscJi
	YD5oT/J+E4zVQTPkT97T356cfCd/P3iYFdW6132I/gqe/HU9xyNYzNSByf011Gvpmr/V1fzWlic
	W5zX+Cg8pPs8vy4oI6qktQze6lHMtRzM6CX6dymxjG+QM0WCIfwCxoHznGndYy1bjQjzX2+ZS9I
	9Yz5lJVSgSe9QKalx9/5DLgYltlbqCwWVuMdtDZvgEkGMpcxle3e9UWDPYfv9vJNW6uJHxeWJ3n
	9ZpUWXNukxoHkI8SaZhWJ1YRT5HZOInIF4d/i/95veTW3VIbarwqqW51CW6y03VLDrR5iTszxls
	Tyi3nFIzVQNov/+y+uUlLnCmIPfo7MGP+O+xbZKjxev/mav0BYuHX116+zmC7f3y5TlaoGdD4Zl
	rCjXAijMxbXnRDquSmh758NGMRbRMARlHDmqcsefQb9dIBTbJ1dhYP/RFICJTDPOhW6vt4wZmtB
	I4xLpd6MXhflTzJk3YaelH1DDVQarfDWT+ebZuPghi1EqwZqVz8h67f8r7ZwnBxqwU37PaxRxsW
	MLa6wvPNWJ8sVg==
X-Received: by 2002:a05:600c:1907:b0:4a2:1a:a116 with SMTP id 5b1f17b1804b1-4ac16fa15edmr211678515e9.0.1793605464208;
        Sun, 01 Nov 2026 23:44:24 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b81c74sm18050374f8f.36.2026.11.01.23.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 23:44:23 -0800 (PST)
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
	ts930@dgu.ac.kr,
	alx@kernel.org,
	linux-api@vger.kernel.org,
	linux-man@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH RESEND 2/3] mm/mlock: reject ranges that cannot be represented
Date: Mon,  2 Nov 2026 08:44:00 +0100
Message-ID: <20261102074412.189554-3-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102074412.189554-1-azpijr@gmail.com>
References: <20261102074412.189554-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 92DBE140004
X-Stat-Signature: zji8s6wc1c4rtpsufudsd4yoiyutsob5
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793605465-905166
X-HE-Meta: U2FsdGVkX18Oym/tQ/KJY61bHsFrKFq3OIB5sDuF5gS+d1YqEklKZ0DpQ0Nd2H+TM6pbeTk2RChp4OLnsoTELyTm5H2vxcs3qHv8Zlhq2rh+NqyKHCw6j2Wa0Pvah3mg7+NiBgTPtnhRqJnmyZ72QvPUNc+t9XlTOzzSPOnuU2bKfF4eo09wlW6bjG1ePFvNuichZOyjxHzbj4yOrULv5FcluR8NzQlMEmaj8OpShs4vRp8JU217UGtI8ySm1RMzKyYUiOIsZ8UNqe9oyZvSaSLOFP+xcQsFwUef3rP1bhaYxWAXXs6F9QDHI8G1P4R4FAkNyCAOa0eNip66HmF2COf3OBOJ8+evn8CtL0tCt/9khPkZAdZ5J3lLY3gAjvK1jc3yJTcjolEoPRIA3guqLGa3t4c+sbOCE6/7VLrgJlOwr4YJQcWdsHftgii9jmJhtqHBXL5WU6VBlf+/X8gMVADyFdBdPfenM8GFYNzgAarsdZQmQNd9n2TVPzTMWUxUgxWImclqL6e+ZJ6X4dsAIAZ+DtIQldBnNH/a1aqt/2TX8wDfNUA9mJIcFr07Nv8MndIxSy5gByaWPT0RR9ldil9i3SMNfe964/IU556khaTpCfed+31RzoMh/L8Ayb/bW4QiywoGdP6ljYmGBdMwagKkcm8pM/w90KQUSzrseY4qeOY3TFdx0VTO8UCNV7rXSP5dYlXdojkEUl0fDS4/ZjSmZ0R2fMELTlEaGGn/37I+bEY02jft9DyNR1fErjo+CPW4rdSN61An4+j2KPdVyM4NkJaw78d26JlNXlwvrvn9fXoefuvjs/WZQFUQQyRFs4J6Yr/tTQ4rX074rECOMQbZ7a+63/I6CyN1wOIOI2qz8qUV0glIjgDl0QVr16k/BTguWV8wBV01ylqG+ocprpu4EzUY0Cb4ka2cfMdHr5qKmicuGqoofBj3ZSjXjwDo6N3SflfT3HKXDD4EsSX
 msMNv8Fx
 0PWhON9sS1Sz6owLqTpbE04xO6QQ2QLQzt9z9jSE4G/hbKLL3GUqt907GUdEhu4nVZ1bLUYBEyrDc5Gbfqei4PsIKiDfcm4Uv44d4uPcWdC1E3q4Jpqkd4AzmQk33t/14rm04SprvOtE56hBVVR4Z8+2ijETSOrpBoxA4ZIvnNxO3Lzi9pvsfdL3DddGr2cfHy5imNZAAHVdM3/UTV9JL93g6XIFACcZU0d4N+qIxk+A4KfFJg+pFBMFYhouLa+iiFjfQbGugOqE6j54F21fhMWVQTiQzie5ZMlEUPuFt4mSFwBT5vEq1QGioCX4kjE0Vnw2jbYcnV4c3Ff8/APWUvEI5T7LprBT3HISAzNk5hQ/oHcUq3aV0QqNg9KCMPl/U01qTgcDS6EYJVUGR8e7pRDUy1F+MePnRrIp2yj2clAeB7tLxQEBTYXTfNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A length within a page of ULONG_MAX wraps when mlock() and munlock()
round the range to pages.  At an aligned address the length becomes 0 and
the call is a silent success; at an unaligned one it becomes a single
page, which is then locked or unlocked.  An overflowing start + len is
only caught in apply_vma_lock_flags(), after the RLIMIT_MEMLOCK check, so
mlock() returns -ENOMEM without CAP_IPC_LOCK and -EINVAL with it.

Return -EINVAL, as man 2 mlock documents, when start + len overflows or
the end overflows when rounded up to a page.  Doing this before
can_do_mlock() also avoids making the result depend on
RLIMIT_MEMLOCK/CAP_IPC_LOCK.  Requests that get a silent success today
now fail.

Reported-by: Park Tae-sun <ts930@dgu.ac.kr>
Closes: https://lore.kernel.org/all/179066531783.50175.13377521828379196177@dgu.ac.kr/
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/mlock.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 673a8433a0a9..0e9d8c110152 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -608,6 +608,7 @@ static __must_check int do_mlock(unsigned long start, size_t len,
 {
 	unsigned long locked;
 	unsigned long lock_limit;
+	unsigned long end;
 	int error = -ENOMEM;
 
 	start = untagged_addr(start);
@@ -615,12 +616,19 @@ static __must_check int do_mlock(unsigned long start, size_t len,
 	if (!len)
 		return 0;
 
+	/* Reject a wrapping range before can_do_mlock() and the rlimit check. */
+	end = start + len;
+	if (end < start)
+		return -EINVAL;
+	end = PAGE_ALIGN(end);
+	if (!end)
+		return -EINVAL;
+	start &= PAGE_MASK;
+	len = end - start;
+
 	if (!can_do_mlock())
 		return -EPERM;
 
-	len = PAGE_ALIGN(len + (offset_in_page(start)));
-	start &= PAGE_MASK;
-
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
 	locked = len >> PAGE_SHIFT;
@@ -676,6 +684,7 @@ SYSCALL_DEFINE3(mlock2, unsigned long, start, size_t, len, int, flags)
 
 SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 {
+	unsigned long end;
 	vma_flags_t flags = EMPTY_VMA_FLAGS;
 	int ret;
 
@@ -684,8 +693,14 @@ SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 	if (!len)
 		return 0;
 
-	len = PAGE_ALIGN(len + (offset_in_page(start)));
+	end = start + len;
+	if (end < start)
+		return -EINVAL;
+	end = PAGE_ALIGN(end);
+	if (!end)
+		return -EINVAL;
 	start &= PAGE_MASK;
+	len = end - start;
 
 	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
-- 
2.56.0


