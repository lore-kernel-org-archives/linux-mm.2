Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45BB0C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 13:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306BA6B0095; Sun, 28 Jun 2026 09:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B7356B0096; Sun, 28 Jun 2026 09:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F6A6B0098; Sun, 28 Jun 2026 09:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1ED46B0095
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 09:59:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52FFA8D98F
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 13:59:14 +0000 (UTC)
X-FDA: 84929478228.03.5729EFA
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8E90D1C000C
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 13:59:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P2bU9OD4;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782655152;
	b=bVWzzBp0TnHaxrT2Yac7zBzyFjG8Mn25bGtdW6fTnQQca2mhnpFVXbUAUTbnuVMyXcQonb
	+DzDaQVQOF2WOSxm+jJ6LDrCxenBYQMEu3ayiEO6Zr8kEz1V/KEkNubGnGinTpyE1cTyS5
	8p8r6rw5NWoe36LrIFWMGl8bFa867g0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782655152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WFY9cDb45HErok5D/WdhN98ODw8YUBOJt9scCSZvHik=;
	b=Coam6oNsXMmcyhdkLqF2RccfWbuaIdUvKk2acB8/1FnZ1s62f0SqfPnuJuqvZEAbZbxA71
	HqFaNxHqsM91TVrPN7tUG88PKIoi+yAwNQxWy3GO5KxHgvN20hUyVEkWptYJlGxQp9Vox/
	By9HDjxmotgTEfivD8kEMAFaZPA89E8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P2bU9OD4;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c8b49639fbaso1722828a12.0
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 06:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782655151; x=1783259951; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WFY9cDb45HErok5D/WdhN98ODw8YUBOJt9scCSZvHik=;
        b=P2bU9OD4vzy4wtcj95bZODinvtvWDcPWepWRNWb7vCFzhi/+zIIRwnj4N5yEt3jBYr
         FDlgITOonbnRG3I/RnHHu3yMKWReOlDzfJ+Y/uUk0lp6jFj9EDWmyxDTXowobK/gY1qB
         hJYrYepJhZmIo52mnnaKIUt9XBsOu7LW9sj9bHLSqrJ4Do4aQZ6xfaWmxeunHoAST06W
         oSAOx8iii83Jxa4c/Suvhr8hWAu10mZE1HURKncNfUbXFP8jnNwrQ0/+UbT2LPO9RS2g
         oWvLlLmYtFP8Wib+USMGfxCyVwUCVn3D75DT03m5WGGUnjZrD9SPfQvp5aRdkPVC7kVt
         3xRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782655151; x=1783259951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WFY9cDb45HErok5D/WdhN98ODw8YUBOJt9scCSZvHik=;
        b=FiUlcOs6Ey/xY6HbOU78xuyg4YEGXDWh56NpnN8BDV3Ww1VZxesv1D4AlNRe4zxigj
         w/6MV1m5VH5XWJarGdaW+uqyE2w0ENv70fllEBdK9ndwscsrdpnYkb8IYR7BMv82TY//
         QvoP6QE/VIe3zsZ6rBkw2Y+O0a8HV+ZegsRKntxjf6Gdq1izr8e8HTb2mnGqMYAfW3sq
         vd7NMTwS4w/TnH3CAAHDu/2akoU3whbiV43EPgGX+8+Sj+R5A7w4jxMlH3NsCrXxgLiI
         FYIvXnR6jZplM/sBY/4CXOuk+HZfkKD8dnri4F8nDeDPJojr4qEE8TiSS79/jafSu8gY
         to5w==
X-Forwarded-Encrypted: i=1; AFNElJ8OT87x7G2prbeH44u2vzaW9TcYEqI3BbYcDOqqs4Pagwjksv9IIGLw7m/kbydIi97rzmrTj/PCig==@kvack.org
X-Gm-Message-State: AOJu0YwPooKxda6W8Z36qCpnB821OD8DuqVtp8sxzuLJm3iTBXHe+txA
	8tOpdfZ/r1iphj1WBZT0gbgiciWymUOvFBz1APDH/8FeFdBiI69VInA4
X-Gm-Gg: AfdE7cl+bdCl74JQvwIM0uMEY72fn8GpkqMQimLJFV9w2SL+WpEjOxhNOajd1xCPDV7
	au8bNC2bHOqRNr4PDsCPtdK6Oqo2zwUwU/irxXBnUELpI6XZBTk/FE5MKIaEyWgKEJ0fVM3uTJ0
	aLatKBhmXR2fbLdk9xbpbPumyG5XYnb8y74Ugl5Bu1vcw3zGhMgBZP4bquT7O6g6Pu1IDV/LF6J
	TEKZRUP3tAv+vW5+/ElVEg8nvGhUDX5LSnoOAQNw37DS65A3SLQqKjjvxVq2XtXYLnBPF7fHCg+
	Z5hVEX9pV/Qkytxxg15ssfe+yZc1SczVfGdkTUdnk2isb3JhQpPZEhMwgIIE6FLRCevj14oJU2m
	LIUtQd37FUYy3DhaMUeEUkW5WN42nF153aOGnWmRpL9NRrXiLkkLwuLlGE8T3gNL/TIMWtEVagO
	2B83b6QguZBDWhmABfww==
X-Received: by 2002:a05:6a00:4505:b0:845:d274:bf9a with SMTP id d2e1a72fcca58-845d274e578mr6168865b3a.49.1782655151439;
        Sun, 28 Jun 2026 06:59:11 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40d23d7sm10041108b3a.30.2026.06.28.06.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 06:59:10 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	linux-mm@kvack.org
Subject: [PATCH 9/9] mm: numa_memblks: use numa_add_reserved_memblk() in numa_cleanup_meminfo()
Date: Sun, 28 Jun 2026 22:58:23 +0900
Message-ID: <20260628135828.1393120-10-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260628135828.1393120-1-ekffu200098@gmail.com>
References: <20260628135828.1393120-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jua5zxj3p5sqziqoxpue68o4crbg8ewb
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8E90D1C000C
X-HE-Tag: 1782655152-714151
X-HE-Meta: U2FsdGVkX1+Ky94LsHth/Uev6ZGgBDTef6hMdyHXBgs4iN/psTRJxqVeJf0Q81/WAdxeSCHU/zh9CymhkCNZPpWe40FRTIbsLLbBNrieBdQeFcSRrtR5M9Kj8TvCKmorCs9lEzyKTzZRTkuPRlJcQAlgBAQqNLZe+GvQN27tF9gq01Qm1P7WRUdyXSwQ8b0eStMq2AZmfRBTcJH4hKGNcZ1uKjx9Z2f9/cFH/rxMpMh3TNdFkgmng6sWHF4XPIy+UsAVL7TZeiUgbKKoVIL3SajNpamJqikJzdmzLNWmaGdw2BLBxpyhf/dELZWMeFrEi6b494VD5PQsBdf8D2GDQfHbPwC+9+6FcsOMSClxDy9pjSPgPcpa+vWWnAZrF9keYQZA40OuDRQW8sI9Zg1XXuYL/wx7R0F/2zBHr8FtgH3x5q8QVJVmKz4u79yG22lA6EBoIjYvcbOWEWSmUGnT8Q9Ml4ZPxks/CuTpQutlq6aF66bOkX5rzJp8KHk/jW0C8tZiszGDumviHpJ2pZUW/lMMHytLzswDLRsJWi5w+Qm+5mFA3P6kARkaxg6ZgWtyZHqO32Pj4CuJm/FP8QDMm1tkrbmmrNdPjlLMnf/hMKnBXqlyF5WKSjilaZHH95TNeSm6wQAF+lfdpm5WPvY7zSpDLM2poLs34pkNFnHIDGoi3sfEJBAWzW/l2RB8yf7a927uHRiMnxQURftnP/7rRza9//5vwgttPWkWk+Kwpsk7gAoHQfa//43yqgIpKe7EjXFduJAKkidfbkSnB/b9Grk1i886pQw6ehJE+fnAcpzeawbWJC3nflpn48ksl61DNksDPuW72oUD5Z4tIaMw0GP4tqLYdgYjrp9rNYyQmJ09zvZqXrq7v3AbMb70sPNfcHELbQWKbEZlGOoaDnQzFEmMs+a7MU+CDpC3Cg81OcGS7y6PtI9wdFHeKLvh7XKUh/R79gy3jF95YEXpL8/
 A42k2jak
 IsJeNi6zMGvYYV1AjvrVKYGpYWGL9vJsKoSBIFGpTA15iFfPJklGVpWwNoscor0ChIItM7GmFOE0B2XlSDL55dOBmgPG5U9ryEagDm85XjZNakb+UVsaUFX5paGwQAnPFl/ob3Iq6oZ1ZfkfhYXY90dMkA1O00HlNFMgARVh0cMsgqZNpDVfksk49Yv6zVw1V53NTEmz3wWzbth2QytEZ0oFxP3mG3XBmXs6TtTdOdYBHTlvMni0NPrT/71nc6SYWghfQT2wtDH52xOwBZtg5CWF85PJTVeLsGfY/vSdeGg4kL0djgt8mdxLOJui20/CbxlW7F9nW0jV8/MGbuMtVNRDuLhHupsL23hnfaEuD79yG10wUafyKKJ9s7dEzgv1on6eON8K/Hr6QMO1+Eva5ds6xt+gOiuhx7d6XluUksfa7x9HJ8i1C0y+FezfdN0d4oZCPm/4PCVayTns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

numa_cleanup_meminfo() calls the internal numa_add_memblk_to() to add a
block to numa_reserved_meminfo, even though numa_add_reserved_memblk()
wraps exactly that.

Use the wrapper instead, so numa_add_memblk_to() is only called through
its two wrappers.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/numa_memblks.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index edc231538954..86b84a89fd9e 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -251,8 +251,7 @@ int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 
 		/* preserve info for non-RAM areas above 'max_pfn': */
 		if (bi->end > high) {
-			numa_add_memblk_to(bi->nid, high, bi->end,
-					   &numa_reserved_meminfo);
+			numa_add_reserved_memblk(bi->nid, high, bi->end);
 			bi->end = high;
 		}
 
-- 
2.43.0


