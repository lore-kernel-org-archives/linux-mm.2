Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 028E6C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 03:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E27B16B0088; Sat, 29 Aug 2026 23:25:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8376B008A; Sat, 29 Aug 2026 23:25:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9366B008C; Sat, 29 Aug 2026 23:25:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D2596B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:25:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2FE0C80252
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:25:18 +0000 (UTC)
X-FDA: 85156495116.25.0DAAAC6
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5EA3A40003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:25:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="g6/sj2n9";
	spf=pass (imf12.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788060316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xA51xnVuOwWqj9zN/LsUIC3tuEtKTMPy7bHuw6GJDJg=;
	b=zRUGvs4WP+9K3vm4HXAZ8py5VK8LycDKsowZ4CDl8t1gcn7cqlMjo5tLCg3WO2+FWiXoPz
	4BNmTUaT8ZI//jIsKZNlZ/njE7kASdrQqlT1XvvoCxuMbd3xWsK1a8xh1mtBuhs0667Hg2
	2pN+LvVZvGo4Ys4FeDr5mntMvfHk0mY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="g6/sj2n9";
	spf=pass (imf12.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788060316;
	b=zVF3qZbVG2iDdwqiO9ad2olsqD7Q+zWtnyl+1//cXOvHvNPYz2Qwd4ub0cvuysYhvVutu3
	nMk0jE2RUEEswfatPNtm2TWzpHSoTO1NapjpLFn7M3sG4MrOicpl7J+matp/lMZ56Bq7em
	CAxqgtXEMA2tBrFoGH9KioGTQkkwmOA=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc1c3c90074so1836195a12.2
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 20:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788060315; x=1788665115; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xA51xnVuOwWqj9zN/LsUIC3tuEtKTMPy7bHuw6GJDJg=;
        b=g6/sj2n9aqNUDRv+q1TIf4o4895/ZyeCvTG7YjxgGXOWv4ACpXWC40ic8tZJtrh4op
         6VzwEtoXPys77FGQ5lHswjWQDof16o5wxXeY6bFpcebKORbT+Y6VXwmQF64kPMZprFdT
         BS7X63G8YxW/sYvl5/LN8TQ2568I6I1iG0DGyT1YgwnArzITX+lhu312HIWGa11n8rCS
         2VEks3wo2rSQzeib/3iM8aADSTwsa3by71iF50a7eoJxJPUNBcjb6SehOqEZtxv3XqaS
         c04UI+q506Pzs4MdIQLJ7tguJ+UZ2MfGb6cikUVQn0+ff8Kws0Q9aVLYJLWNyPYk3rAi
         1AHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788060315; x=1788665115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xA51xnVuOwWqj9zN/LsUIC3tuEtKTMPy7bHuw6GJDJg=;
        b=cTgCVjvJ9ePbXOWZNscQr0UbD/3le1hzebmWBwOCw2vFsER1H3dlDZNUjS9z1VGsin
         QX6h3pwtMcFXJx9GNuNXcVMOGp0caEUyv1er1B+yq5piCSeOW2FloDGzXjF9SEFOs67Q
         qWrSEzDyOkzc2li7c2pf21OpefVhfyvxNY/0838yRaTUGJLyKCKxwNMjjU+il+q4gnFb
         HZkLdca8AuVWWWP4uONFCGGYLYfTtUM5va7iXu1Jx4dALqd5PXcpUNU/uP6dcQhF6QQT
         S9TN0ZSQpQsAClmTKeOr89RInJcdZC+rBViwwHxm13v5ta1oSwB9ERPHSI0xRdbg09++
         uhwQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp7xYog6H7u2ndfLToCsf4FaI8A+FDEsphFv+Wmiq4kK1x494qTzcHYucAEDaFexZ5LtVeaVw+yVg==@kvack.org
X-Gm-Message-State: AFuF++mZqaiK1nRkbeVjCBwhqQ3ht8b9B7gE5IvMCPEIDyuHjc0J216D
	MZK0ppb6g/WW2+qiPXwcjTl4MXGnfo2I9PHR4jYBddiS0pOchGYXOIyU
X-Gm-Gg: AR+sD13OcXO5pXKYBx9a3yfglH3suFNjBUplCz2tv9T/H1sy6zp8R4+091yIkC5RlYL
	YIAx4l2HqHy+1Fi6PlUIHCTs7hS411ci6i+mdeDAwhuX5qqxf3Fo5lQuRK2xmHv9FM2jVFv/0mp
	4ObmxdeHMDpiO7wvrJTYw6UyXDD7JJZRzCr6d8LL7APMxlAhjcDm9eTYzPj7zdRgn3rajUmJhbZ
	3uONcxI9o3rDHhJowVv9z3QXhRFkxHHSS3WzwMlFtfOhUrP+rh6pVGkKpSEgK8jO/sBbXdprq4u
	QksvRJgT2Ea+LALZ4ZWJLFZwMB7O+sSvZGdCRKfHTsc+/BDvOccyQV7IekzPsyhG59oUkOgyUp1
	+qBR7m40aSE8+xnOv4SU5CI02bTJu90gwgUdjxYMIqtMtSjaW4tcVLwRTmFTxQydSWo89Kk+XWf
	P3xYhEKclRb7Fo350mGzrn7PQMRl+1FXdN8CA9u9qyNba8t18166iJ/HX7zgUfT0HvXFJThjKnE
	c47yjcxx61VU4EN1SABsg==
X-Received: by 2002:a05:6a00:1c8a:b0:851:8394:1696 with SMTP id d2e1a72fcca58-8562b49995emr32076993b3a.12.1788060315139;
        Sat, 29 Aug 2026 20:25:15 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f3312146sm2287261a12.8.2026.08.29.20.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 20:25:14 -0700 (PDT)
From: Wenjie Qi <qwjhust@gmail.com>
To: willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baohua@kernel.org,
	axboe@kernel.dk,
	trond.myklebust@hammerspace.com,
	tz2294@columbia.edu,
	jaegeuk@kernel.org,
	chao@kernel.org,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: [PATCH v4] mm: filemap: retain mapped dropbehind folios
Date: Sun, 30 Aug 2026 11:25:07 +0800
Message-ID: <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org>
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com> <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com> <4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com> <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 11jdjtg3pffx1hzwcn8wdhmejyi9t3xh
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5EA3A40003
X-Rspam-User: 
X-HE-Tag: 1788060316-386225
X-HE-Meta: U2FsdGVkX19FKzNTKmd8rnpzcXzQkG/4XO2/roD83VoLwCpgH8whOfuYJNIa6JXwr3eHpiLwlaZtwsTMFuAdxcVVQ/4jkdGokO5+J96IAsUaTYlcD9cwdMfNMximWtfBofnh5nfKE78/zly4Beh2OlvxD+vrnpwDSD/4Z2iuAts3wN7zVg4dpL+37v2Qvm0yYEqIbD1JC2uf/XUbkIYL4YHw5bEBURCEv8PWN4RzuAJ9iWLygoYTn1k1dbs8kt/66Y78py9T0+xO7zNwiQvwFh4n6/HZLeurkmjmHTprHOnVzyMrWqovzmYa5VhLErFcB7+ST2bIEk1c8vK0tnpJj4l1AB0BJI8PVrCAOnfH+HFuGhzk5JwdMP/J5aW4uQohlkhS8Xnnuqga4wtMY/RoNKyKz1bCtkL43zyC1zpcfH5hdskddXUX531S4TZAsazHvW3u6bj49ArztOWMcU6fKDMST4tdI1kM7+ydssfDWE079rVuvtlgthyeyzgkqcOy02tp7BGSvMchBU0rzq8kEd5pQCNe7gMtH/4neWRTd6+rzIRoHOSHFmL6zt5MB9aV6bLoFJp7nE765mSiT21CZHh1XFWjtWr2M6/gUdK1wsjEu4805OzG+LO9NMj+NflqiKgcBNahQ+Yetfb5f7rKl9gw8RkwUshDsXbLuH/o5oJzOjJ5IW16spnnYCnqGZbUWCJmNX30c+ESrWqx92kqyHUl4BGZFjyTxALOezIBIhJtb4oCW9O7jSo2+O6TfxTO+oUR2Z1W1KhYu825aMInGBi3G0QNyQp+2lQJrsNtoH1G0Q1YmHJopYFf9NdzLHuEceusWqJ+iYo0x6yFg9/BEZMZ2Fn27N3lDjjpCslkzVopTUE6uXy+r9BQmDy7+qoS4txGq6cS6AoLStXQwxInpl3VWa9hnDhZam+NO6lW6VmslvmafdiCRKFrpEcHLsNV9dHtSzK49+Jm4Cuc8EB
 M31fQLzr
 NS03u/U5Q1LlVe4EPPp9HLNEDblIybjeckpdSzBh+oAn2THIyBjGm2q6a3bTTyA81TKbpBYdGIejVcIGltLeaPKyuV71w0FGOAf5eEcWNHY/SfPakjFusQd6ctH5BpGYlEpMTYzaXuN/UvoH4iYVvFDCRSgVcwlrhR+cv9hOJEkM28Dd4viAl/O9UUIhDH2mlxFs4CP5vuyA6lKvytxBIt1DE+O+DIqlaFprVJkyYDkhJMDSB9K5xEpOL4NqE9KaEVlsf6NXOnay9W01YjayLLzk5UlhcqHCBsy5BtxM6nqPZ1zBFqheHHAb/ePDGntNbx9fLJX6tZl1U1tOlc3WxExJDQhhBD8F1NdCbGoJ7hmxoaLgKxAe/YqB+LODY/AhER4LeKHH/ugnUlZREenJa+ANRHmLWhJtRucoInvYVgdRpiN8FTWXN5hLdlVEbUkvDWe1BAwzXIBADtoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wenjie Qi <qiwenjie@xiaomi.com>

Fault-around can map ready dropbehind folios without going through the
normal page-cache lookup that clears dropbehind. A mapping represents a
competing cached user, but writeback completion can currently unmap that
folio. A later mmap access must then fault it back in.

Retain mapped folios instead. For a mapped folio,
folio_unmap_invalidate() can call unmap_mapping_folio(), which takes
i_mmap_rwsem and may sleep. Retaining the folio also avoids this path when
folio_end_dropbehind() runs in non-preemptible task context.

Unmapped dropbehind folios continue through the existing invalidation path.

Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when writeback completes")
Cc: stable@vger.kernel.org
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
---
The mapped-plus-dropbehind state was reproduced in QEMU. The patched
kernel retained the mapped folio and continued to evict the unmapped
dontcache folio. I did not reproduce the sleeping-in-atomic warning and
am not aware of an existing report.

Changes since v3:
- Describe the forced-unmap/refault runtime effect.
- Record the reproduction boundary and add Cc: stable@vger.kernel.org.

 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 6afec636881f..00fd89cf6f55 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1616,7 +1616,7 @@ static void filemap_end_dropbehind(struct folio *folio)
 		return;
 	if (!folio_test_clear_dropbehind(folio))
 		return;
-	if (mapping)
+	if (mapping && !folio_mapped(folio))
 		folio_unmap_invalidate(mapping, folio, 0);
 }
 
-- 
2.43.0

