Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 701D8CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 06:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFEBB8E0010; Tue, 18 Nov 2025 01:09:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5A48E0005; Tue, 18 Nov 2025 01:09:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4B08E0010; Tue, 18 Nov 2025 01:09:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7A3A8E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:09:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5159BC038D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:09:14 +0000 (UTC)
X-FDA: 84122700228.06.F692705
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 72AA6A0006
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:09:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Zroe/pm9";
	spf=pass (imf15.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763446152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YXlPCNHcHu+mXfLoteEDoMwQfKA/2ats8mxhobWyW6o=;
	b=vs9DGo+9ViV93Nb6r7gmwN73Xkgz2n67E8z0tIHsfBW74Y2x1ERk3In0cqR4EoCT/Ho3l9
	yDBBt0rrAu2yokhULd6vd+OUzGscweajsAO/g7FydykdNmWqC58T7UylTX3JbTjcBXRToS
	gl/wGdNd54A6AcQbV9HXISc+Bcec81o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Zroe/pm9";
	spf=pass (imf15.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763446152; a=rsa-sha256;
	cv=none;
	b=TCY1SYUtGMmAEFDJw+4DEUBE0wtIDTBZ/53CAU0k/6ZorQWQXmwnmUjMviu4s69mhPZSkC
	/OW7qOVo5GCbfVIwNz79IeQiUCFjReL2P17mx/lG9WvpDd1+2gBPFvm0n6GZEAYubOKBs9
	cAJe+n7i1FIWhiSaM+FiEGaBfzrg2zs=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-297e264528aso51382045ad.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763446151; x=1764050951; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YXlPCNHcHu+mXfLoteEDoMwQfKA/2ats8mxhobWyW6o=;
        b=Zroe/pm9T+HkNOrGChH1Uma06blOFv50lPskyl/cJsihS9hjjs2fxwmXnxYUGC/pmT
         xuiB4dBuEteEMiLer3GcnjLnJKUgYH7BHjR7J5BlDsvyVvAnUN5Y67Q72A4e33KbZd9+
         3W1WD6jLYlkaGou094UjBALSjcogw4t7NexAFGmRto9yeXhQZ0jGf+rlWMkhHLS8n2Sz
         /s2Cd2gQbM7PpCyIaas0nFJCyR1KQI3QDBLkoaZmXO+VkSSaiP8szvjRNhKoy5dcIxX4
         4mp3dF6ZaYNRXHMomVJocRpJsTB7YIFjxJukToeoKPb73GGtoM4l3YMJFvitC3MFsQAF
         1YLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763446151; x=1764050951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YXlPCNHcHu+mXfLoteEDoMwQfKA/2ats8mxhobWyW6o=;
        b=Tq1183n+YaQcqGriuM+DVMXUvpl9SY1LPd1F3egI3WJv08R6A3xUG2I5xsnbBfOFFm
         qgMAWVSz8NvidoZx18x0fYcjyQ+xP0PHHZeJDlgM+vg0ATw9xUk+hznUnlBjMmDOclx2
         UUf72Cx4RKv+K80qGW1ItTp4a77jdhWNInCbFlJMN9hrZ3FzXcBz8vkd7roeLXT+Bnia
         QUiLx6xbd0d+lL3kgnGkazop1pOlIqhNMbtS/rGZDisK12oXF37e42BUbgdNVJhxUZvZ
         1XDM/tqLQzHb/YPnRVm9XEi0uK80Q+NTb00L3EhBgx/IhIQpna1/B8WohFJQaxOAHPBm
         yEuw==
X-Forwarded-Encrypted: i=1; AJvYcCU5cfZ7e1WZcxpVHY01D6rr34OaC4uLrhAvIi1ury66NuQsCjHdtU1994Qd8dPjSEfL3NOTyz3vOg==@kvack.org
X-Gm-Message-State: AOJu0YzFgTdrg10ekowrtXPdpRkACqhMC9oO61ORG8WmHbfcdhBITuhY
	q0WM0OaqWk9cpb6FJ8kGu7G0YER0QRWxgLft0kAjEy8lNYpXt4kVLQR9
X-Gm-Gg: ASbGncvmCjAgJA7bLCfbPun24J6EH0XWsHtpdZLEGx+5X37/sZUbTNb8XDitjzgJevm
	pUcPGoslbfnX3QBGgfKR9kQrnEQ7772Txi/KL+5VBJ1EaDlGJzDW/D5KZ0H3blHCnEVjoSZVwjM
	nplj8X5nnGxG5aC6BNNaNOGZ0WffLZFWZ0aKKkycLqURZaKtr05kOZFbEGR1B9p6eanFOVBgc5B
	Nfq8729QOY5lHMbutShubXP1YXtQR48GM+9qMJwXhdF0iNH0uIzjwMCmjv0OD72XCdB96wsfhwg
	gqhxYi40JLuq2Ah/Mn2Ny1MTJRunXCqBU18KmkxBgM2//RPp7q1jGGviJt0a/dbLP3FZ19lUh2k
	5EGdD5m0yo6N2fAqnGbCEmXRrlMNNA4egggtdLfbumYZ0RzwFatnHs+co8ezZ0ff1TBodXl9MBs
	Xqy2y3ljA8qyGf0ls=
X-Google-Smtp-Source: AGHT+IHPRPHN/JR7QsnfqNP2VmA3YHV0KBbt7fIo92C0Nn9NJZqnl52Cn87ACOFGrWTY9ArNxjJ/Ow==
X-Received: by 2002:a17:902:fc4f:b0:295:7f3f:b943 with SMTP id d9443c01a7336-2986a734435mr194879715ad.28.1763446151213;
        Mon, 17 Nov 2025 22:09:11 -0800 (PST)
Received: from chandna.localdomain ([106.222.230.39])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2986e5ef32asm124461135ad.39.2025.11.17.22.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 22:09:09 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sahil Chandna <chandna.sahil@gmail.com>
Subject: [PATCH 1/3] mm/pagewalk: use min() macro instead of manual ternary
Date: Tue, 18 Nov 2025 11:38:49 +0530
Message-ID: <ff24b3c573b766b187b55a38497fbad0a319b9f8.1763227530.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1763227530.git.chandna.sahil@gmail.com>
References: <cover.1763227530.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 72AA6A0006
X-Stat-Signature: pkrwegfgzmminunicca5tkh9pstndyms
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763446152-857382
X-HE-Meta: U2FsdGVkX19zdyKRfdtDlaQ7zgirGpAtW6d3y+uuGR7Y7KUMlrwHG3ITilJMBd72n1wPeSgFw5prDIyBGPUxTmQULcB5e0u98UrNF+sYjCzkJahtcN6+8FBaf3CP/A3d0DcjqF6w/TV+j2HE18jjpEgtlg3K2yIypl5Ji+spD4XvGjPHdj6y0bmaRkGFrGEjekhVvbuTyyuKj/e3L283tyFr0gO/QqippYIlAibbvASAB/YRh9pV0jvPH254ZaD//yiCA4oJdkT1PsZeqXhoxmjwzJ8XD45GldOWRcsdPAlCI5wHZ7Z+l5HNtGu6Si19L0HhrlGUbEl13mLFPf+iWGnfbSaLl7Y06jvK3VineDiV/T+ys9d4aOnJ9U/rMOrHYIzh5biwk0sT372Fm9XH7lVxj+g2fPDNnQ0p0zAV57uMKuIk9DvA2iMafufavvJ4otSzWIpynQiitpMYoDF99zy5VZbMxWEBQANF5iu6S5IQJTLKMPIT+i7PC8QxMMZs/0o4zokviTTcnFeKm3xiYk6j2H9UlaQQwSLP1Y0rRR8azS6JIZ26cLWFPuj9/c0EJa8fTVqxXvQNMpVfSQcMA6s2rE6/H4+2/dxWPeshDlWsV+R6bNmB+ss8S+4dWQ+dbr7up6Bj0JE+wVuDEcpqU7UQCSbzV14k2lzryoxOBHnRh9NaDDM+KVAl/XjOu7l3J22iVK2lRPvxzLNLv9vCuM9MPoAY+h53mu3jeKPtmJdwYBtz69nKIjFONfKbqT1nXd5Q6QWE5yEywBaF66TJl4ndN8/plYTR4LeefA12uoGevQRd4h/Bw5ZMXd55/TXKHmnV+R5qDDIq84dVj0n/qDqBXFdvTh7dGB5lcCasH4WkWs4ZzRT4+wxpP52O3Y2CQE4DjPh/zSxy3HUrqddO57qa+DStJv9/ldCmWI5FPjrnFz5tOHn8VnMVPoYa9WSkBw7gsbNklIafzjfO08j
 AF//almD
 IlmV0bY5PTdoPw+b7+O7GWfnuNUuR95bOEiijnw+TgqoVgtCEA2Zq2xb4Vy7M9hyxM/UXKBV/J3eLJQxXeWo1oL6LJqNIumvlIg2wbppqAa9Z/sZHdl5tgbSSF8r86TkLp7RjeT8Z1f976WbekjqTuyOu9bT0zg7U3fbFKG9QNk32rrd1tv005c6wiNSXEnKBn4dlGy9HVTkhxROXOHl45RtcImnxP1wviMqmFeW2vKPKaAEU0E/uytctEuArnqrjxaY7QxcGa7crG7DPxurMjbXjdKx97MWwBcLa1qRUPVXCMVfWRMA3gsfC4t6/0fCC4ub9DvWgoJhqyr7GoXsero31qFv6KwdLSUf5eU9pLLpAOMPRWUqRcywv2hDrra0UmZ4Zt376iXO7i+yT0wzuzw0fszvYDt8Gf2p0B4EX0EQ0b4OuijHVSnBWfX6Be9cay9ONsPgCuauOxDoPTYJ4weInU6D2CLDTEfGO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 mm: pagewalk: use min() macro instead of manual ternary expression

Use the kernel-provided min() macro to compute the minimum value instead
of an explicit ternary expression. This improves readability and matches
common kernel style.

This was flagged by Coccinelle
(misc/minmax.cocci) as an opportunity to use min().

Found by: make coccicheck MODE=report M=mm/
No functional change intended.

Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
---
 mm/pagewalk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 9f91cf85a5be..82db421b5b34 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -313,7 +313,7 @@ static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
 				       unsigned long end)
 {
 	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
-	return boundary < end ? boundary : end;
+	return min(boundary, end);
 }
 
 static int walk_hugetlb_range(unsigned long addr, unsigned long end,
-- 
2.50.1


