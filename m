Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CA5C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 15:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54BFC8E0005; Wed,  6 Aug 2025 11:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523D48E0003; Wed,  6 Aug 2025 11:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 412358E0005; Wed,  6 Aug 2025 11:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 305E08E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:00:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 863ED16061D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:00:09 +0000 (UTC)
X-FDA: 83746642938.09.2159C72
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id B00C3C000F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:00:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N38gjGC3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754492407; a=rsa-sha256;
	cv=none;
	b=tVWYVXjO15tD6OaDKsFe3lrr4Y74o1emNhntlz9Wke+Zv2JR2RTUpY/Iy7V4t/8X5kXmpT
	7C/B0i8OK9togxVzkQsOAHZf4bNVrn9nioSXgqQkGFIeUyErCEo37F74vAX46jvLq1n+Sk
	qkmGWeRyoMGMOJyE1vHwG/F9LiD4EZU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N38gjGC3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754492407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZB7P+LR6z9Zxc9rEDL62l6M20YPI12NkjExjZ6NWpno=;
	b=nl9N3G+1ZRxb8UKaK/qeMb2iTJa8B07KG2+de7uHHI2/8ckMQe2x8uJ8z/omYpUF3NGoiM
	9WoO1NEhg0CTTDtTimA+a8k7vj6ysZj06FCbN8iuxGHu+m/HwwSj0ZitZ4T73B0f6ZyWZe
	SwG7Okvvd1VvOYyP0a4A92RjPklOP+M=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b4272ea5dbbso815436a12.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 08:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754492406; x=1755097206; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZB7P+LR6z9Zxc9rEDL62l6M20YPI12NkjExjZ6NWpno=;
        b=N38gjGC3xBhIEoZ6+LcRYInCR0JKnaFIOpqO7qGpxp3is17iYzTLfRBF11LIw7IPlF
         Ga/KcTYDOh2Gcg8J2bvz+CAkn+IaOZ3C/BTHGDAMfnV3zI2OTBuG8b9G09TQjUMFZdpj
         fcExeJwSKfE0LWhS8/V+1AbllO5no7tc845GV3oBXjAXd7rvqHinx0J5w0kABqVjKeDk
         Pbz7/HUjxIKBvlyC8oSOKu+F7Kp+aWKtoMIQD0Lxs5ERX0tHMIupE6oV9wjMjrf6SPEK
         z4qAk8drCVIJuOmuVkGJ+tfSeyCm6fWUpaKdJxakTEkLV0V+aNVMl8OU8H6Ld/dz8izG
         T3Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754492406; x=1755097206;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZB7P+LR6z9Zxc9rEDL62l6M20YPI12NkjExjZ6NWpno=;
        b=oh4dXMn928/Ds5fqyXjfbMwEe7qXVvDMFhR1a8ZAIKz/Ff957X1iglF/w6ShYEV3oi
         CESWOs+FQFPHAAUPk7AC/XFr9bENet+aC8P/OpEDrfrFwt2Y0VOISXXg4yz/UtwTblHP
         FPEjR5Q0rJVcfle8vdwJwGHWpmPpgQS5VzOK/+miexx4MIrD2V+nApo7gc5BuR9yAw8I
         8TQxfBz77q1LVvy1GFktD2YaF7nionEvdMkBhZq8eBBY+jnTVBLaNUu3uhEj2708ZdCN
         U5i6Ur/zoyfGPLIzwrFJMDZqiFWqyUy4tbVvLKoj/mlD9m4CcIaKXMhaxKcANplW5G1i
         euMg==
X-Forwarded-Encrypted: i=1; AJvYcCU8L6KdjJ0YcYJqoELguQSIT3g9N5Ib/bTlaeQfdyh6sfjYJQyd+wZMkzffDQ1gkuNfXMqXaj/cTA==@kvack.org
X-Gm-Message-State: AOJu0YyHpkjXe4IoO4uBqeiENRA7kfaU96SJS/htqAImSNFPgcxV1M73
	MJTxDPeCFxRi/0MkKpX1SYKu5UECI5sLJhIIVL3ehpYe8X+UzDxIGfK0
X-Gm-Gg: ASbGncsui/qRYvTp/pjA20gVrmY9//BhGZscdXXvWSoXUvWXfl11kTGz1Q9SWB4TxT+
	0Ctdxc+AaWBfhWZg0lyjn4zE+00TdEUwzttkQ5dupuP4YoybpkkpBT9AwV3jvSEshhAYvEspVoB
	j/PaX8wbcvn+LfjFnEquleDs0N577MCrLJwKXHpm1/I478O7G/wY4qEgGgXm4u8+m9M9ScbZTlr
	8Zc/QTawGguQYkvS/LrHLChqWmzI7+eOGgN98/B/q9NgUsfplwrLAYBB8SotF8P8tcjoezP8pnr
	EL0wPHwHE2rLb+QpB3vywF4jjqz5S978EN0R6KIUM/NuEl3d4eaYGD8MwR6wNXUhlTpxQgnpOO8
	QJbMuU2+smlnKbVCVhxx+E+8EtYoWorxVLRmw8wuC+7imzet8M6INXjHWMykMMSD3QugCMCjjF5
	yVjrZ8nxb4KbGozxzbvsr+8ZZTMNv3r0p8GcAv
X-Google-Smtp-Source: AGHT+IF/zb4p8uMDpctBooDw3w4OO1dxizR+VfBzQU5WXXX3PuwBSvSo4mc81Nt/Sb/Ar2TwYOPqMQ==
X-Received: by 2002:a17:903:1b30:b0:23f:b00a:d4c with SMTP id d9443c01a7336-2429f8af5d2mr38722975ad.2.1754492406205;
        Wed, 06 Aug 2025 08:00:06 -0700 (PDT)
Received: from AHUANG12-3ZHH9X.lenovo.com (220-143-195-113.dynamic-ip.hinet.net. [220.143.195.113])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2429b7dfc23sm29204985ad.105.2025.08.06.08.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 08:00:05 -0700 (PDT)
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Liam.Howlett@oracle.com,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Feng Tang <feng.79.tang@gmail.com>,
	ahuang12@lenovo.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Adrian Huang <adrianhuang0701@gmail.com>
Subject: [PATCH v2 1/1] mm: Correct misleading comment on mmap_lock field in mm_struct
Date: Wed,  6 Aug 2025 22:59:06 +0800
Message-Id: <20250806145906.24647-1-adrianhuang0701@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B00C3C000F
X-Stat-Signature: iyjkuh4mc3bst6fx9m67yy97kmehr4zm
X-HE-Tag: 1754492407-598263
X-HE-Meta: U2FsdGVkX1+/WA552wh7KfH9KzB+fIsVOuBkEiZf/nrGtVhhC8kcB7B3dn+uemJviVX2Dyna+9hvZgHnMkLf2i3IhDgMSoajj9DEXVow/rGiF8u8J16b27UUKcK0fCWi+rwAiAt1UUuRbFIW7973kJr1ljaSGPKwENWqYHrzEx5m9nNESkBhRXabDFh0lglC6lnXrIjSYHOpH28EMOvuXzJdFTqrFvOoWIlkL5YJfH3ZOfih9NXoMAmRXQ2PWEZp5BDD76HQlOTvlkgNy8MQV/LJBVlINOB/w8Yj34ODR9i8vlXqhkaV+YRI42B/U5/+O5IFm4Zb1h8SJv6WCBFQYEC/bcj7PDCm7zbirWvOeqxINi9BHEbQMStnxynSgzp2yi0AmYu8Qtfxue1hle2FlJlCs+XrRYlZNkvbzMVXiHVxwAaCsCLrfhxITHsAV6el3LFjYMVXuRk3hvB9H5RrTwiT9UMP1OxpX+P0MTMot6MbouBxQCspjCuGsEmQRuhUmXa+Oz4c3f2omuYYRMgv5tHfYv+z6ztqRDiWwdeljQAPaBSSX2Xw6v8T0W8s+2oTaAdr80i2rQGpoS5bCBsou2LCACMXtzhE+Ybz1+RqOh7Hg1thQq88PQvglupnykQWsZJOB5soGb1+i6jN8F97W17pWbXKSZjxYZMV/in78aZ6AfzTINixmE0QHC79zkcAa+sgs8xOytbqSb7Uh5mR4K3YlL9yg9I81/Z+m0lZFbHki8CFjbNq3KjgHxZTmbY2nWu+qdYQE4V+06SI7usT20cKHLTtm79tCMAmYw2tDDqFiiXTF9o2eD+fjwKjrBPU2lfkX/srIWHKpnpC75IaP7av+SWyuO41/kWjglORARkkvzOdP+O2/AjvIPTNcHEBiWkuWhwTNutk7KfGMKzqXw39gAOmI4P69kMEjakoGMNZOMY7UMVCnGhXcKwG1rxwFdG5SyLuahCZcdkKL/G
 P8ijjtIl
 wgYF1tgg0NuLQRWpwCsAwSnwV6D/nDWUYV8lGqyUmn2J0ZDwdcRgNX0y5uWJgAjqemoXQSlb6XqFJsgQ2SHcnicLf+pDLKzQKVJAPUKWfo0bAxOWHJdKFJvO6K4kwY04ln2jk3PRgyxF1qsQhbwgJalhson1FGJHzHN6Nbfw5pLpI7iCNfRsHG4zwf7aJWWAaf8cA3Y2VGLgFjt3x2knHDAFXfGV4hmHPPof1sbqAgxnFc6xDhRdp53yE8RFbW/WS8YLsmJYYj8U76fXxqs2hMSPiia7QTyS6uYkp/KtSE/gvAyPU6t4Mk7AIzf+09RNFTXsBnwZtRzYNaHLyPTll9p27FHd0M/mGknTVun6PKDfag7FlQfq3W3ID0hy7E5Bjg8raZsKe/yXzhai8lcN9EONl5Ur/21pBKwoLSfLK4LqkGPLuitpFiOYx4OmDiyvJ+NbkRkhbWX7zwDgSZ0yxWq1jALIyhWolW4gQ2cNh43lmfSWCySm+qXbdNJC2wxw+8lx5MSn3Zwe9dLDE6kys4ZiJe7NBoMZjO7l8hyflrohE6U0AJdC1ZTIGJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment previously described the offset of mmap_lock as 0x120 (hex),
which is misleading. The correct offset is 56 bytes (decimal) from the
last cache line boundary. Using '0x120' could confuse readers trying to
understand why the count and owner fields reside in separate cachelines.

This change also removes an unnecessary space for improved formatting.

Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
---
Changes in v2: Per Lorenzo's suggestion, use "56 bytes" instead of 120.

 include/linux/mm_types.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ec273b06691..c9c3d0307f8c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1026,10 +1026,10 @@ struct mm_struct {
 					     * counters
 					     */
 		/*
-		 * With some kernel config, the current mmap_lock's offset
-		 * inside 'mm_struct' is at 0x120, which is very optimal, as
+		 * Typically the current mmap_lock's offset is 56 bytes from
+		 * the last cacheline boundary, which is very optimal, as
 		 * its two hot fields 'count' and 'owner' sit in 2 different
-		 * cachelines,  and when mmap_lock is highly contended, both
+		 * cachelines, and when mmap_lock is highly contended, both
 		 * of the 2 fields will be accessed frequently, current layout
 		 * will help to reduce cache bouncing.
 		 *
-- 
2.34.1


