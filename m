Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE466C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D099A6B0088; Tue, 15 Sep 2026 08:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBA586B0096; Tue, 15 Sep 2026 08:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA85F6B0098; Tue, 15 Sep 2026 08:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A02B46B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:46:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49161A03EE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:46:51 +0000 (UTC)
X-FDA: 85215971022.06.BC5A7DC
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf20.hostedemail.com (Postfix) with ESMTP id 923F61C0007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:46:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qOCq7vXt;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789476409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=f4zZou9G0GO5cZcybgt12UlI26seICje1hbKIqqh7wE=;
	b=TxuqX7Q2EAU3KHl5dHiqsgpfM6dUsKqWCfaD7ma5ZGlO+wflHR8l01quKrmVu8MZAbONGm
	7/fM6e0CdJHguU0on9Et54D6SLIsrMosVkQbGltwx9zqCP3bY3EHuBws0fFXYRZUrkM3JZ
	SAeiocfZtE6K5q00TC8yRlO0EIhkL7U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qOCq7vXt;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789476409;
	b=uxbcOEDVVXFN+L9LlWZntmYkobKWDGQOHgL6dzKWnS9bqlHhGbnED1kyiBMW4Z5krXGwiM
	ayT6xyWSw0tpuQf7cFBXvK/Xn7nJh4e2/VSkIhKTz+z+oNVLgy2EInwebcb8M2qTQzYkSi
	cEual6NLmr239XEvQB30nhCS301A+jk=
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-39ded0d7f52so1316654a91.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789476408; x=1790081208; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f4zZou9G0GO5cZcybgt12UlI26seICje1hbKIqqh7wE=;
        b=qOCq7vXt89meTDgYdCC47HJNMC60wpMXfTyolMmilNfOLR/dF2Iz03B3o0DAt2Fo2t
         CO+xJyJ+/zvlMrvOivezrJOA6P+u1jHf5slCAWW1ctpye0QbqJH4+tmZaUncZfczQbd2
         jXa7y++baIO2VeDuPws/0lP2ErE8O+A8FSgDsO6oq7MLBbF0MyyL5nUKi4Nb0H3TfTdQ
         9mp/Xxn4hA7XwAtiK9u+cYPKkW0MHgUBcevTPY7gZcgb+2Qhc1lrJyHk4hsh7WxtSl4G
         vYRmmCQj1r4ImRUcGJbB7UyKnLhewn7FdE3Wewan1bMcZQlvk+zfd5z1uInpZgY305tW
         3c2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789476408; x=1790081208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f4zZou9G0GO5cZcybgt12UlI26seICje1hbKIqqh7wE=;
        b=W4FaWoOua3J9KnjdJ6W6M2LL39ai6nejjL5Ld3Io1TuHtZaVEcLDlU1k+kkE47WI2g
         XKGKdQ1+TYtLsHVmBtkKzX9/Z/q71ZPmKt0j3OyTE3q7kUu6qnBxHdSnY5TkcCtqQtSB
         va0UibbrsjFakPaNIAjRX3iTJXUMYorpKk7LzZ27DtVjW9uyshpasmQ2XVBmLvtxKrOA
         V9NPPKECbdQpWsIPaIJdOsSNtdK7bIVH8jRh9P7zkLguhA3azIY35UPM7G2RSwG5GOst
         tUbw713ivvI7FOQwVQHvGAeCcnn3pJl4MYxw7/fdWKSp5RQW6HQ+/CuqXB37X3ph/jz4
         cmPw==
X-Forwarded-Encrypted: i=1; AKwUvBy2lV0pr+pVqnqPIAfY9Gn9ayd6IEpeULed5/66pw7rNfStHFSfFevhL7iZl+sSDonVhO+BJcUVHQ==@kvack.org
X-Gm-Message-State: AFuF++m4mxxe42rD4n7HUuNA9auYQQfatOukbbJ3BGARe6QTYfGVNFl7
	HBJE7V5Ow4l1AnulDbG+CM4fPDLkF9XHF9FkmrPcgI6io1CIzUZD0/Gc
X-Gm-Gg: AYBFou2EncJ2Mtg0mFMnmVT6hgRz0KQ9GUglIyI/sTmgsDoDz1HkR6bmiKXKchOxeQU
	TVufNEIcTjqG2p7qkSbspSC+CKdKe9Fy0IxqFx/WhUPMifyoqoO61Jp0ZEu4HStUVa0MTz1sGOi
	WgNzJfrJrUBnteSCubl0ylEvV+OKJU0ZfSHphSr8ayoX1D2sTgrIyvuD8ROLlxaXQktDS5Y7cNL
	SP8ZOEh84VZI515URfA4GFIfC3z0/2rUdrLTFc3p+XtqSaGCDd+Xg3JkEzcPPoUYhbmysZqCikq
	fkPhhfauQG5Wvhp70zGa++g8I9cPTLozTQva4NwMqOXyFEe8vj4NNkX2bw4a4aBvb8Le7yzGp3j
	PLl77MZ50XK0SW1vFCy/stWCAJQysntQ2UwWdbuYFUN1YWPL2gHsYs9IEbZvYn/c4o7oVPsbMhD
	rVzh9+hT+LrOIvwwzwTs+ng0L2R1sFcf8TZmeVtTkVwwbSR2uxl0PUdIdmyU0QoEo5IQ6QcI9Sh
	/PA4Gp9xBY=
X-Received: by 2002:a17:90b:4a46:b0:399:ecd:d68d with SMTP id 98e67ed59e1d1-39e110ed019mr1426128a91.22.1789476408264;
        Tue, 15 Sep 2026 05:46:48 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39dfda249efsm5268049a91.6.2026.09.15.05.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 05:46:47 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: rppt@kernel.org
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm: memblock: add missing HugeTLB flag name
Date: Tue, 15 Sep 2026 20:46:41 +0800
Message-ID: <20260915124641.2498280-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xo3h13144tect7hdp68173d3es8butm6
X-Rspamd-Queue-Id: 923F61C0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789476409-440036
X-HE-Meta: U2FsdGVkX1+kRWm81wj3zV/F/vryi3jcrNTVeSgEwv7qdLpcCu2Y1yH5wwNzoJvCY/U6Xz/2xWczqtHIMcF0sungpHMhDHeCMiqz5GXT0K1mv2Pqnf87e4dJOXXLImaeywVcmHpKZ79BNakwmUesc+9GKIgz8GL1ZWx8ltBsfNDg0E7bNEALxalrmmivMQqbl5/jLweWt+EYhwQ/cVYCm0it1kA7+zWndyydPSOswNiY2rq4OL/8JVyt6cS+tSBjNywEgEgSGHT1piB+cIPMyxZy2zLBIxwWhV+nv4/crz+zWhxq1Y7pcWvpBnyZjxmin84yVhgytBgMT4Lo3JHpna5Xemh9wM+OawAO3lPLp9YGM0fk3+DnZ8ae+xouyrpovtFt/HLBECkoK1PPTflsMleluqvfO1pBoUiqJtnIjAqnM8J1Ga5I7rrAVRXCp5LBaW8rT7iHqtfAzC9aBemF2F4T4ECWc/A/63yY6gl8sRewBTJWx6I1c49HQK+1CG5WYJP+0eDkWJ5FPJpmwzvnAutlX27R3XHOHBGBzm0P1Ggonu5ViQ6wINKkFbxPH5SDd2UyQe+sSQvqCWwpo6IzcI/SwLLCLFvryRHIwgS5yufv8y3t8XRazL/C4NlASSqsRw4OLcyrNT+Co5UkZEiY5GEdpGIdqiLqU3EK2sV+roEFvE88vrdsIf3dBVJ9UEo/X1l345AZSf0Cg/+qDr0azTP64XNt4B5Dx/pXPgW3yg819xs8xpgedjchPbi2jqWui0F4bLKJoUz++voHORdgyaQEtzJM5Cf9R0uRcAVCSP+HW8GlrZR0XILm7W3TYUav8e2GzldLn1S9+X5JUD+4ggyvBkIP1x89i6+i2ffndKlGvDNyVerjJLazI+yxotfvIn6UFHon0LvjCYXMsh0gECU2I3nN7FYO75Djv72wp81h3onj7fsI1pIwiBeA31uddlTO1JEzpvyxSSRES6D
 71PJWDJy
 +FGZN26WhvBDKGzNf4xMBs9k9TjZzRe5bL9ijFkjcItPb0KWDrZ2SLiWs3VAEDoy6rWOCry8r5icGQJUC95QI+wtGI61OX/xCMcWENnG+BipbDm9ojVnsMFrZfLP1RUyHlKJfhthptjIxBLTyS8dXuDcFM+x2QryPs9O8FrzRkPwUIh+uV16pO8D8mpoiTp4suAUobtf9NQqcw0UHr6Kq2UHbmTsCw1TLwAX+dZi1FZKey2R1xwMu60EW2j5sefw24fY6hGDQnc6iUfvS2BaChRt3bK9tP+OZLrfT8C8a7u1p2jHceVKFt3iGa85K7CLvPvaNwYIM+6NTO4zmymqBPl3QJUn95AeL/kKJxa2h0MiRTMngqL/UQeMa7V07d2qAxgoJz/1C2z5fs5Chx1sxdxADZaFx9HwfaOpjRG88oGkyX7dLi3WB5SybNvh0glmRLFhinkU9NGW5XHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

Commit 7d163a75f821 ("memblock: make HugeTLB bootmem allocation work
with KHO") added MEMBLOCK_RSRV_HUGETLB but did not add the corresponding
entry to flagname[]. As a result, memblock debugfs cannot report the
flag by name.

Add the missing RSV_HUGETLB entry.

Fixes: 7d163a75f821 ("memblock: make HugeTLB bootmem allocation work with KHO")
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://lore.kernel.org/lkml/20260821020910.3428585-2-zhaomeijing100@gmail.com/

---
v1 -> v2:
Split out from the reducing vmcore size series[1], per Mike's suggestion.
[1] https://lore.kernel.org/lkml/178936321614.3691424.10386784926753862087.b4-review@b4/
---
 mm/memblock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memblock.c b/mm/memblock.c
index 31961ed628b0..f51811db118a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2874,6 +2874,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
+	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.43.0


