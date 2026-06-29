Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB8E0C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 819166B0125; Mon, 29 Jun 2026 12:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0D56B0128; Mon, 29 Jun 2026 12:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72DCA6B012A; Mon, 29 Jun 2026 12:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 487CD6B0125
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:38:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3E011C112E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:19 +0000 (UTC)
X-FDA: 84933507918.01.84E98D4
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id E534A140008
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZW8vI0Ww;
	spf=pass (imf26.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751097;
	b=FLf+i+lqHD1E/muHzICtlojtnf3bfqJPReyW4do1D47kyI0Jy9iG+IhbtQ93F8/rbybWsy
	HnyZDcDzXzggkYtoiClglVh2zQBaHdFGe/k7Qf8aJheCMATfHc1CfvPwS6MNbxc4tPM2L4
	J0pL5oLzLHr3aA5gG+cp5I1zSzUl4QY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxV5fEpsJGHhE3L8vdcj3Th/5v0heJ6mrreI6jrRPh0=;
	b=D2RK2VQwXdOw9i3QUIQC4eWKXKwKaOY0yzZmXyhxkghq+A9VLBVQoXs8oDQuXtFy82dIa0
	plhWtdtztTEuE3ZuFpe0O98wIOcXwTw6e3FK/dr9wm9MUhgmxKB9Sjopu5xSs1mF91ITUP
	eYi7dbv9226E0BbYCL6zHlazA0VNIT0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZW8vI0Ww;
	spf=pass (imf26.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c9b373d5af0so412620a12.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782751097; x=1783355897; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RxV5fEpsJGHhE3L8vdcj3Th/5v0heJ6mrreI6jrRPh0=;
        b=ZW8vI0WwiEVlBJ0gGzaSlUxwvvWVwveI7+CZt4wn7vTwgD1G/nITAUa0A5MOhUWIG9
         TO47BGUmT85UOTOsBU5bD0sn8z+Ib466T/YgjLCxcf2tMXJSVL2SGjBVwfZtn4ktf7q+
         y1Td6X3SzPwoFEneNt6uqgpvyKqXNz5sNtdgREtjXcPx8AlKUxvo0DgxZr7Mb9+BeWBg
         CdkL//ZHGEy+SnhDx7Q8BTp7FKRX14rl20TZYj+T9cZKihFG3kYP7EEnzve2NHflVxBg
         vTC25f98GE9ZB7NWLWfrShOJVKrTuVwH4TO/UJDD1z5PjK7xje5smAXgulbUjijoy0HI
         G5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782751097; x=1783355897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RxV5fEpsJGHhE3L8vdcj3Th/5v0heJ6mrreI6jrRPh0=;
        b=e/n3q9/jlzlYuYeV5kbJuxCokMnC9qdoDWW0Kuyix5tI+KbjzXsW7+s9gDP1q53/OK
         B0kAbrhZxAHDUNkt/PQlwfj3so/1NY8GOE58D6ussDtQ7Zwq6stYSfMa0ADkypDZF91i
         vZQChdPUMlvB3uMYjWjcqrdSn3BGiG3n1XGWz+7F3NWVrjzuPiyRe+RrZuRftpMqFFhx
         Bx7HM5GbQK0Etpy1bb5Eynky64JLt1cyhGuGdvb5PJynx4me/bNdaKSwtM0XB55UP9fv
         sxrBeEPiKVwbx2CUeLYjDhdNUKLwayYvKcKFGCYV4ypfMb3yGurKosG7jYN5hs87Mq1S
         fd2g==
X-Gm-Message-State: AOJu0YzCeTTP4GyHRrawDjT7Jt7IZP/wthOYVB3pYNTKOcVSyBpOvbQE
	slzVb+q/RqDWMuQE0Ga/MES5negxhXCqer5rA0GrZJpF9RCMjvZ08KZJ
X-Gm-Gg: AfdE7ckNl/5xSSvRXHfDHXbN+rzYIJ1Cm7jTcoDDiGLQfweKvHkQCVfDPIycA3+/oV5
	EnihrANoMs966Vq0n+z9cNUt5xqe/OLgXHB967jo/vISjoBR0IdhiYtkRBvSHxxPUtApLZUeDEC
	2rXhEU2AN2EsLri2ffKF2bsbtpX1CH/XH/dsDsQDQqeDrmAjD8jYQ/cU9D0fRzicuPAoaIRUtf9
	drajFtzgs5Vk4Li8Ud4ZBqQp5ThyHFccJDXW1+54NveGlyBn8pFO9ZQGcT//BW0lbr1NJ97WE0Y
	opT8E0IXPy820TV1He/8zMzJA+FND/gtbjJfTMTKakqrYqwaiwPqksjHFf/U2dOHhYFr75NjyMs
	DU+yGOucnvnSmSiKxeeqspNjA4CZ5q9gmBFgFlxtTphHGSMpSOHcstJa2bHrzrjT44pgZiSBlev
	Z8XqR21wQ=
X-Received: by 2002:a05:6a00:2d8c:b0:847:8504:9946 with SMTP id d2e1a72fcca58-8479f152246mr185629b3a.25.1782751096795;
        Mon, 29 Jun 2026 09:38:16 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847a02d41c0sm18474b3a.33.2026.06.29.09.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:38:16 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Russell King <linux@armlinux.org.uk>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH v2 5/8] ARM: remove unreachable invalid range check in kasan_init()
Date: Tue, 30 Jun 2026 01:37:33 +0900
Message-ID: <20260629163736.1606688-6-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260629163736.1606688-1-ekffu200098@gmail.com>
References: <20260629163736.1606688-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E534A140008
X-Stat-Signature: miuy1e76zg37jwchj9sd5njf1wgdn3rk
X-HE-Tag: 1782751097-111144
X-HE-Meta: U2FsdGVkX18jdxMwE9o2So7bPLfItn2N2c4ECIneGwUqeI+izr7Qcid6nM5J/fygef90lg1TBjmUjirdizFtOJAJSBnKgJC0RgH8p9E8Yl4VtBAHYP7osoLYP4PdFzj/A7ud6zr/xXGiNry8VUjXuDe4W/QPuifjl/JXovIhL0aZI5C/LQaNLiv/LEg6EzEUCJLUkX2CQySvaVcUzD46PttTHOCzM2Fh7WjM+JGzIWKyeuNI/jTjdDqcf1JO7T5r5A4L0i/iRM8Wnb1H2A9q9B6xk+W8RuJcF7l1skomaxhOGQfpY6oEJZU6aM93nSJqU11DB3CLVXeLph5P7DXdBLx284QRiiAgOe6qRQkhWeDrPPIg1Dthcqw8XVMJSTH1aGgbGi4CCtroT1S+BDeRLNnYFLq6vYs/oB5K/+MpvM2wXob6KzGhqw4QmTAH24Jdy7VpNBvoq4SNPr5nZwa0xHGJGIanEBxBQMbAH7msJarwU2jkGCEBh6hxRPTrPrnW4uAOaxL9pIWAyQxWoIuwJghNjYRK12M+9iT6tFBTm9Bugm5KyZk9I/orLV4ITSUAQCY+qXEueWRxlntHhn0GmqigajGDfUNyZkRlks0ri13JbWm+m4jwEY6t9iFOTVBTJwau8xFTOOUJzYbDcPSN5eqkAiBrR7siIvBr9+lQ66GZ3y0jE1CEkYx2/szn4YmS6chEbJJVDCfXN3hRJhcKydF19FY1Yec4OlmCgOZExL46PTDWDx/ZY0vMH214JiKumckvm+iAB6TYGLy9YCkOzAJAxUstPoQQdTiOSCkNAgH9p+Dp88L77VyF3daU3xRCYE6dGckGB9WeqlfxxZ3ETv/87/P6xi16ZH8FaqAOLcOjzKbdJx5YrgHuaTWLBSRo8SIqLnRanLdeGwyYXp/S/BTz5mPFBn8NIPoW87l5KnPOXY3RFXV1MMFTJwSzT8ucfSk5/3YNqPj+OuVDxPY
 Dz3Pzskj
 VSGoJnmkLkyYciecFhnfMGsXR/+UNBFPgxc85yWskT7ILr8MxSMN5t1rIxaudwBSEOR/8v2jyDGucRvDoVd0mccje/KX1cwVF53KHQnEGtx7mquEoTeGLdVUArw/ApuzNIJFajEzJMdKVlSh30npePxRB0Ng4mV0ZVoKN3CZu0FUQMNYnpY/13kGUOjLF5R7zXuF/pvTEWhMFdZJKTBPYBmS+uk8MtXgra4Xu9OOoq9CJwhQVzg0Vk6sZf35hrdugWIBRRYoVLE+lKql7ipiLsN3lGzstN/oFnrjOfRvohnsSbX9REzZjk+t2gQ3d/rBwyLlDJyt1hzBq5cQ1CJHVQGLYRDik1z6zl3YXnLPMDfA5W2JbxWEnStWpHSv/i1DIesP1ySD2cGF51y0odurGdeRCkacRhhU3VFI8ngocuobEqjBIvTvET0a4N5cnXAVVZxYPVGExoQp8SwmwPEN6faI8vgI/9uD7jupd2DFKbyKJCrafVW4GsygLJEzAXw51s+Pl7C0TP0366DyiyCQuKGrkK2kkthNE45Dk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_init() maps each memblock region with for_each_mem_range(), which
guarantees pa_start < pa_end. Then it skips any region with
pa_start >= arm_lowmem_limit, so pa_start < arm_lowmem_limit is guaranteed
as well.

When pa_end <= arm_lowmem_limit, pa_start < pa_end means start < end, so
the start >= end check is unreachable.

When pa_end > arm_lowmem_limit, end is clamped to __va(arm_lowmem_limit),
and pa_start < arm_lowmem_limit means start < end, so the check is
unreachable as well.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 arch/arm/mm/kasan_init.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
index c6625e808bf8..1f7c74c5df9e 100644
--- a/arch/arm/mm/kasan_init.c
+++ b/arch/arm/mm/kasan_init.c
@@ -262,12 +262,6 @@ void __init kasan_init(void)
 				&pa_start, &pa_end, &arm_lowmem_limit);
 			end = __va(arm_lowmem_limit);
 		}
-		if (start >= end) {
-			pr_info("Skipping invalid memory block %pa-%pa (virtual %p-%p)\n",
-				&pa_start, &pa_end, start, end);
-			continue;
-		}
-
 		create_mapping(start, end);
 	}
 
-- 
2.43.0


