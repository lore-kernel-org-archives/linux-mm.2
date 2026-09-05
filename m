Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885F9C624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 01:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18D476B008C; Fri,  4 Sep 2026 21:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164F26B0092; Fri,  4 Sep 2026 21:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054596B0095; Fri,  4 Sep 2026 21:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C36F46B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 21:55:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32CC214012C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 01:55:25 +0000 (UTC)
X-FDA: 85178041410.24.B49712B
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7E7B740002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 01:55:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NnAGey83;
	spf=pass (imf17.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788573323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bGqr/uumCH3i/wD1gHE7y7ihUxVOE4Gxi7P61fIxB4A=;
	b=Icm0+71bX3xR7K2eArLL0/E+yoYq464NO0msQKV4/8eCIDKfiKPNCCMmyMQe+h4lfPpaAf
	XTaTlruWS3SOLO9IN9Edoh0NuvjYGdSNkbNdxYz+KtjnJf7rJdRSW/LequN2yTUKK1uRwH
	ZmkTspDw/e1S7vF+iDWJtXLtoP53XWk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788573323;
	b=jrG10D1NEPJPA5dqRk5NoqixOfK6x8UMAze9B6Exab6fRuYw/0K4+Ah4h8W+QjpTeg43N4
	JENsXoWdTPBWU1mtyLjpEUIVMnIoUDoJVZ2MEzyha6NLbSRTNv/HHB8+tolzZ37mKh0/jg
	Wr9ADIkWvp5XlsHuZUvRFxz/mbPhSuY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NnAGey83;
	spf=pass (imf17.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49b0dbfbf7bso12979205e9.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 18:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788573322; x=1789178122; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bGqr/uumCH3i/wD1gHE7y7ihUxVOE4Gxi7P61fIxB4A=;
        b=NnAGey83dbb6SzkHIFC6f62lklcKFb8C+dhqVWe/Xa7OuQXkgIf76qo8B7pSdcY47s
         i+rIBQ70gJFqCSQlhsfbDloa5rfEP3T8OsWmJ2H9vm7lycnGqCHItt+BnlZiekifQ6aS
         WEEPHG3+fA96HzyZ8sq9F5C+yrrM0xJLHlW2vQeuj6x8yDpt/cwIgkMTUNIik/vE6U1m
         hkH3Mvoq1QC7A2cyvDwx6bO3m3c9ixZKR4z9JoXRHYOJxhP2FRjC9nhIXvAYHsSFG68I
         C1XFPzeVAzJhNcugr1APDlGBYZQTrw2ziYj4VVJsodZtdnrn8NFpG3qDrtjT3X8Y3D+f
         gMoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788573322; x=1789178122;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bGqr/uumCH3i/wD1gHE7y7ihUxVOE4Gxi7P61fIxB4A=;
        b=X9nbArO1VZTdFKCPOZXIO/fTfKrQ8ECO8ko3WykVVimUWShdocTD7aORRbrzBjT2gs
         n0i/tBCWUbCgYmDvK4pkE/O9RiBss1xs/MqO5FGKeOy/38p3vXhOt6IR0Yw6+9dTL6um
         miBHAbiG4h7loi/DKkhJOHQtWCDBs//d8g2KBRU+9uVUy4OsI7YcPmZl+bx/hezz0CoY
         DlsCQA3NopnQo0+8zoWTBOMWVzt3C0Kbk2R2jT7i9zUxcfddPwYRjwzbtS2j65TpXQDY
         ZmI3045790mCvQ76M4q3VGrIUcz6rMleXvD5yqN7vShDRGCnPuG7KsB0Jdz+S6eRt4Ga
         iGnw==
X-Forwarded-Encrypted: i=1; AKwUvBzOTwioV1OQ9EUrD2Of+6D1s/zioCMctqASkbQJM/23R/dLpOnZy2jfN2lbKr4n4ouDzjoL7Qia3A==@kvack.org
X-Gm-Message-State: AFuF++kVpVgaSToMONiqX0hv4CSoWFU4qrcv6+36x4SRbCj00n5rJd12
	iK+QldhlKVkRPVfXOiVL1IRSoCkreXQeOCdBL0Iz8/jUDGVOQ7Vy29jy
X-Gm-Gg: AYBFou2osQJgNedFWwWqbAwnkZaxw5iRvMp0pQl0tY6FMszhT5cwyViccY7YMIjoObN
	/9czd44XcVUaf8LkaA3S824dNWxcuUQBf9NETKgJ/Yj7gTqwt56xu71GoMoxUUEYLtgINwDVk2Q
	CrXbLjM38wsmNsjuG4K4GdKQGwM4gMiATbE249e3y/TKmwTmzpOUWTS09ncbPi0+5/8OjStO2eM
	rac2mAQTggDu8gWY4MJKhj/ENzZd9Z9ZMqy/tbIpatZ0W2H4nu5PNVxI+/5zyJC5H1iZMGbaUCo
	5Bj6mdKiOpn87PKjDP+n6gRcmzL/Lk+Lu+DauXTOCXBH+I4lA5BZVhI49gWpe71ia27vyfgtXjg
	mEODruMH/+K04pkOjdxm+tF7xOfGq+vGIxOBtn//hfWD7g4pOjJKQZMVR1jLi+lWnMF1F9sNek0
	tXWlB+le1qFUWltXw9jZ9/3slDkqNe7X+n1I70Uoqe3O6jyz3jn9oOWBucczUe7PaEOv7YSWMhN
	NIPjIyuzGwne3wZ/RljJol9bQK+3QC0wSyBHsO6pWFja5QeRKy5Mn071HZzGW/2IcM+2ilJdtVb
	dkM7utHeEmVhDraiBBNgLpTavEX9V/oxkloHbZk598N4rDXXhx+F92HCei3aDpucDt8=
X-Received: by 2002:a05:600c:6290:b0:499:8174:9f39 with SMTP id 5b1f17b1804b1-49cf7f3d239mr199069625e9.0.1788573321755;
        Fri, 04 Sep 2026 18:55:21 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a4eb-3001-c06d-af27-9fa2-ea53.310.pool.telefonica.de. [2a02:3100:a4eb:3001:c06d:af27:9fa2:ea53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cff8195ffsm51258345e9.14.2026.09.04.18.55.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 04 Sep 2026 18:55:21 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: "Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] docs: maple_tree: Replace removed bulk insertion API
Date: Sat,  5 Sep 2026 03:55:09 +0200
Message-Id: <20260905015509.76265-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7E7B740002
X-Stat-Signature: cwa3gwqnnmem784yc6pmqfihsgmq4gaf
X-HE-Tag: 1788573323-170455
X-HE-Meta: U2FsdGVkX1+MloO8U49vCFd3a30tHG3uGayqpOzvrCkpPLq32aZmdGwccBc1TwhuOER4DoXBfP1qNhx9NkdleEaa98UkpNIIgA8bd8nLawTf5Am20ocPu0o9IpkFtvw78Gs1jlj6YXiILSfWFBaoRWY+SwJeRTS7KeH5WOb6UjiJWc4+kvPnjFvMlLSDciqyEQsZkao5ZxVh8FNeP/U+Sk2/P9jJ8soIyDkj4MmKltruNvBiTXWweCpVmoohxxoGlXnx+Uj9gpt1cRDjuMfZv+yj+chB2EFQZsJmoD2DTF40QOh5+UfRa+TdOv7j/sEdRXMzb2ZsMhuHPPl91eCIIcpOXeCI2ZUkWPW0FDEud/ZCRKiqyG7yySyZ+3tp91fOV87E8sdykurUP5EsvEQK9J/pwDo1Xn7vqirzu6FDAdLnZ0/45716CuXLnEWlhOGe7Ai3socJIaQFGO1gISR3u10qtGT/nSzVX9rcX8/xMwT9eu1Op5aWBMmQd7qq9bvsNC23Z7+AclQeqNq532E4IMEMU/pYNAY0BvimkrloiYfs/J3oM0HIkCYbNBTnhJzeexorzubP+709zTLwHhuuvkuNoy4cNqFtMBEB57ZCgV2k7axrCMjL/X3wR2aZaZZrQUmmbu6WSzp3xzP3r+PIs7z/ScuN5aS4A6MrX8nz7yXtuh6RuRY7KxkAgJLiLeCa2F5rMj+yjTYTcVmgUymlDIxLgdgo+kL39bliqQqCxVFXaSv/c4wO73peOOfgrV01Js776omRfjd5vX4Oo2v/Qh5ULOsuTd7DZv6U/sdjbjTHjQ/sq/IG253Jt5HHeVonIQos92GlEVgL3CkOPfjRySh6RcNi8sQMTnO97/1HxQTtpvVKXpp7qqrJvxBiMQ8GMCGUT9CEkCktsCnRAjTnGXJpRQ8w25vmHV9d52nTFYZMr8Mxd/t7PhzpUhIwa6zTTGpXWja8b3CcY5f3jzC
 lc2LQ0Zz
 HbBWZ8b6ag9tLsfKomZd8fLJWNicRkNS0gQGm+H1Mj4bTDNGMu/YMrPgp2AdmbgceOQsBxR5o1vVd1NZm5gSifACNxFUyWzvAQ9X7dRvcDlmRSVgO/XYHIUBZVslYjV8niMWwH7LcF6Pa20Bsx3CtR8OKbRyRTsg+6xdDD6CeoUpNeOXIjAHWROMzwTCNlpBx1X5M+IJU114K+7t5bK1Cxq15QZgsNY+Pn9yaanBFWE5tmMPw0K8V7d+BWeqFjuZX2sVJo9TSYjlbryIlZXyVXpc9+HmtXF8VCpoE6UP3tpMwGSTfOfuIN6v9T58HyzSP0Z0Ar1OOWqYJGNP/b7H9CqMQwIAkNlp0IDKKqN26onU4rV9Lz20tY+jTcNpr2J9Wq8HyNLjO2VB+yiuy8Soz5FFFFdyXxY5J82XwdlzflO3Lo6U8B2FnwVu4UtSlH/+VxisIzAlbvTmOs8wRpyxf2tc+/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit e3852a1213ff ("maple_tree: Drop bulk insert support") removed
mas_expected_entries() but left the documentation describing it.
Document the current preallocation interface instead.

Fixes: e3852a1213ff ("maple_tree: Drop bulk insert support")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 Documentation/core-api/maple_tree.rst | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
index 12bccfb6aac1..836342fb1eec 100644
--- a/Documentation/core-api/maple_tree.rst
+++ b/Documentation/core-api/maple_tree.rst
@@ -214,11 +214,10 @@ Advanced Allocating Nodes
 -------------------------
 
 Allocations are usually handled internally to the tree, however if allocations
-need to occur before a write occurs then calling mas_expected_entries() will
-allocate the worst-case number of needed nodes to insert the provided number of
-ranges.  This also causes the tree to enter mass insertion mode.  Once
-insertions are complete calling mas_destroy() on the maple state will free the
-unused allocations.
+need to occur before a write occurs then calling mas_preallocate() will
+allocate the nodes needed to store the provided entry.  The entry is then
+stored with mas_store_prealloc().  If the store is abandoned, calling
+mas_destroy() on the maple state will free the unused allocations.
 
 .. _maple-tree-advanced-locks:
 
-- 
2.53.0


