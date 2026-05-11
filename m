Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 847CCCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 21:37:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C103A6B00AD; Mon, 11 May 2026 17:37:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BECCA6B00AE; Mon, 11 May 2026 17:37:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6CE6B00AF; Mon, 11 May 2026 17:37:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BAA76B00AD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:37:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C9D31C017B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:37:47 +0000 (UTC)
X-FDA: 84756451374.21.52D7A0E
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8349540007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:37:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=feivQ7ib;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of contact.kartikn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=contact.kartikn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778535465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gzrGj1+ay1/Q4NFiw9lIg1LRZRplXcIVizS+d71NPgA=;
	b=wsUi8t1oTfkedqggyWz33Fw1yXiNGAHq/VjPB60RVf6b+9M2M3Nj9NL1PzI4RMBoaojV9z
	v/DzeEnxNYpgkKLNZQpVAc1NJWBEDuCju3zCY4DCDIURz/lDo314pwdvDXZ/rCb6s/itmD
	mBPhufjuUDSguVBsLNOUzX4OR41SHOk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778535465; a=rsa-sha256;
	cv=none;
	b=NoyxTTdanyUaF3hsn5ac93OrDytl7fqKIjWM6VivrsJQk41Mfz63Tz3J0I1Y09rJlUYWDK
	ptJGo5dDZsiixLoEZLyMuGdWvos93bG3LgXS5SFLty0HefjW9uC76/WNIVMHismb4WQbeV
	h2RrAwAmCzlOr9panb2A8YqM2yReb+s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=feivQ7ib;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of contact.kartikn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=contact.kartikn@gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-362e30526f8so2346004a91.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 14:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778535464; x=1779140264; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gzrGj1+ay1/Q4NFiw9lIg1LRZRplXcIVizS+d71NPgA=;
        b=feivQ7ibVsC/q7+n7v8/ec+Z+uwvfwvSK5h901XvyCCraFSHy1PyJr2xyZxIZ/K7fO
         ZQ5Ks70L2wHcZb/V19RZBHjPtJx2AYtlBMxQYCtwBqOUwDUrVR5RfO9vQG61U+K9EuK2
         3Es6x1TmkNJjSiWpkrbJ+rzxbm0T6RsMJeUVAZkT65ohG4zF3SgG15Aa0lfy6hnZyJC+
         SaWxtvfdtHp1KYoLB/opbgmjM4/UBfqpG3QARU9c39ytD5OE/AX2EGXEoLkUzCtBwz8B
         fl0hVHhJJImDOzlbGjb4b4nd4KbG6pZSaKIijJTp3OreX3PrmhZu/Xkn0oGeuq0nC3Du
         0pow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778535464; x=1779140264;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gzrGj1+ay1/Q4NFiw9lIg1LRZRplXcIVizS+d71NPgA=;
        b=bNCaFsnR7HEUiVKT0WCmzf8pq706TTwa64JRcKKUhalcXzA781V7IyZttj+abIWuiw
         6HPY9Lo62I9uoaUSYXSGDIYQEsyHlv73pvHLQCECxAk8eB4EqbBltQUSMe95v31r5CP1
         0+QmERqhozxVfbaJ0WFGcuiA1N25c4leof3LfZxj/h5Ww37Ay/bVb6lydhiOC7LO06bS
         +MZCj+ImP9ZQOFRtktVyihModHQFHCN5eIlZAhhEx44M3YRTwifN/jbIPkrzGWxlxYYt
         pggSGm+wLbIj7JaC/fiR6CatftDEbpIUSK6l/7V47nQhOEKQx4D8OJNKa57iVF7/Icwr
         /gfg==
X-Forwarded-Encrypted: i=1; AFNElJ/z0Yn5uc6mvJRIxGqT0XHR0sQ1x+I4KbAi+4KFmtQWssUjdOdW+AdVUnKekiy50rTE3sZsFJvthQ==@kvack.org
X-Gm-Message-State: AOJu0Yyp2JBoFqqrBsvRk1iBD/ph4MQKpezk+ox6cOOa/USDHI0MMlK4
	NmJ06y5yl6RM1w7R6ase2CbmBlvEBPOBbaaIaOvsyYIqWYK6sH73lbzV
X-Gm-Gg: Acq92OHHofpsp/Iuvg2pMZv0I8kR5alqdv9B0tYObwIeIGZyTg3v5FkohYsXZlOFerz
	OEtZPI84+yh9J6yUv0qXRQnqOtZ1IgsbJbIN6cbByxvU/LonCS7CH/U9i7xCq8kzMLFU4UlCmdZ
	rky/PnfjPZqoOMGsePogmTBQfkNVBYcJ2qkTT/J5fHwDZFilKPYkJUqZiDhKWqKdHX7kYpjfrYH
	wH00NcHj4mfYT/6pbj2phb9MSEY4irGpEQgt6HefmhUpDsCOibbqb8v/MQk4fSHjOIpyxRwbSrd
	Iq6YmlTMyuTTzGU5zgow03/n91aqzZhClQ6PKqKY8U74ppB9IBwzOkXhaV7seRZ5CQ0taIoyMLq
	CGUDYkHOVTiI4l0Z9bSdB2PRo8WkLujBnktXwVxydynYO6f7WaOEzgh90MhASHEx06+T7PB5T/Z
	hYmMUOI6jSI1O4X1GPyOj/kIzyvWxN3AXuJsdkQoO/HVbxcY95NnKEsEyhOg==
X-Received: by 2002:a17:90b:568d:b0:359:d54:846f with SMTP id 98e67ed59e1d1-365abae26a7mr27111229a91.7.1778535464259;
        Mon, 11 May 2026 14:37:44 -0700 (PDT)
Received: from localhost.localdomain ([171.76.86.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367d625ef70sm9048591a91.1.2026.05.11.14.37.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 May 2026 14:37:43 -0700 (PDT)
From: Kartik Nair <contact.kartikn@gmail.com>
To: minchan@kernel.org,
	senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kartik Nair <contact.kartikn@gmail.com>,
	syzbot+8f77ff6144a73f0cf71b@syzkaller.appspotmail.com
Subject: [PATCH] zsmalloc: zero-initialize zspage memory to prevent KMSAN uninit reads
Date: Tue, 12 May 2026 03:06:58 +0530
Message-Id: <20260511213658.25273-1-contact.kartikn@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8349540007
X-Rspamd-Server: rspam04
X-Stat-Signature: dt1r3adddsoh8r8tajsfmxwe8z9p9mzk
X-HE-Tag: 1778535465-917854
X-HE-Meta: U2FsdGVkX185qWAq8+M2DfY75hkHQYT2bDJAGrtGLtLHrJ/HYOEdr/lS9gouJwoRMc7PuSjwkAagmPhPCUjXUWPOnh/nwsKZzO2wzCTfNN7sSjg2qDv2TtVybQk2cnN+2w+dF4ccIDSuu1YnyORYH8V6ZthzTm8ylK3v2zPzFTDC35AtVTTk8inq6izHZ4lKkOaGm4TVkneUh/Jf/+IqmmdxTaqrGWzS5IsfLNVGVcU2eTINrwJL/KDwi7SRRNH0S/7Y55RxGTbOBbM+QAczMyLsSR3S7hsiipQvqwKIVtqFO/VZI1iup7AOKVPQtY3JjxU9GGQ67m4ZLee5pCOJHZDB5QqyVuFxTVV2ohOkmI4iMnuR9mxPBN04v3hg4f8JMoeg3V5ZUWFpvCunsj76RMw3cOaJAQRqYUER9+lyK3vY7qKU7odhVpzX9Uwe/tng31R5Oa3W29Dlj5zXvamRjcIwFBNtUCnE1nMzaZckF9j+D2EoXaLE6wGLIZyQQwe/5NSjCZC2rTeao4aVuRJQBwPZtZtGglsmGO6PaaeRlJhoRKWU5AFRwRS8s6MK7DoMYWpLL8Km6QkcI32aS2KuYUxxpEPTMhp7JY7Joiy6a07oLHoYKNMMUAo0Y9lsC3IrzHuW5YZirfk7PoJOLPVbjespp33Ae7U8gRZdy4gYxqORzaIx9YgTNR+7fkOkJlf6xvOuZW6hSqSV+daC9VrSY47nK89MxEEE+BLIf7uCEuwwQnP53O4eRrCt2IU7twS29B92K6OjqU/nfAtwpqf/HctYWMbp28X+9XyKthFXAY40gs1u4RSdlnXYDDvlrKaEnn9zLCnFARvRSWXkzllwOS3VzG5f1ESR2buDTf8vEfUGGLkLNFSlGw81xwCuh5dqyOxeJNPHqf01IqTMq/Cgsd/Q8WnLkWReGqkOytXfeBCzEUpK0YoCkcGkNlYUvD7JnuUPKjHKZNGkgb65fa6
 ebO3p0cW
 pEE5BlXXc2Ovwjq2Ca8MR9kPYlwtFEqj6L+RTyV35vqryPvP1Rrwoz6nl2GYZ+8xvujtAS/rqbRRVX5l3J3CTNTxl1nmOu10bif9ejIj5iU9iwFO+qgOYayXKJMaHoqsPM5gmOaAJXeFHBMSU+GkLiBhvjXbFiH9QINUMUy8sskeOlBkOWdlz0kDCxn/5pPgTfDl8CeV1iaJFU506TmbwHcvzaUiyIj5S5+Wu6iTc8YjHS70m4TFsG856eK5yTQOJlf+dv45mKs7KHghpIX89xH7A3j7E7DwpPS14p6ndnBsrMccPoJaLf2TrMVBqgZJ+xjs79DctBKh74gc4ThD796gjLEC429icBiXQQaZ9x2fmsHaxA/MNIq/XuGqdxsifsK8/JmTu0rfzqgpI8eA/ONg/qgBdeIAdswgSDlCEhWff/K5wEa2C6o71BM/gJKp1HPJXSxqPkDKQ5gJK0XHtgVLE+Qt3pU5H/sHE6vHnlgwPix0KCum7/s7X64v/5QgiAhu+loz3uMuDuoUXWstdXPvflCs0j0CT1xudLNOJwgrWFtOEdemhsmBfYNah2Ra/oAbS4RhenDZMKvffd8RtEu9+5ART22/r6AgjlTrW1QZtkvDnBS/GX1PdX7EUDOVsszXu7kivJz/dg9iULJjCYfutshwM0w8MDZDd2GRKS29/y4yv9QcuFEkeBTnhlGAJ/8PMRQcHng4GuEGaeotR+7r9ogBXFVFvrfk2hcaF0uyAjd2i48nifSlbGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pages allocated via alloc_zpdesc() use alloc_pages_node() without
__GFP_ZERO, leaving physical memory uninitialized. When a compressed
object spans two physical pages in a zspage, zs_obj_read_sg_begin()
sets up a scatterlist pointing directly at the raw second page. If the
second page was freshly allocated and never written beyond the object
boundary, KMSAN detects reads of uninitialized memory downstream in
the decompressor (e.g. sw842_decompress reading the CRC trailer).

Fix this by passing __GFP_ZERO to alloc_zpdesc() in alloc_zspage() so
all pages backing a zspage are zero-initialized at allocation time.

Reported-by: syzbot+8f77ff6144a73f0cf71b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8f77ff6144a73f0cf71b
Signed-off-by: Kartik Nair <contact.kartikn@gmail.com>
---
 mm/zsmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 63128ddb7..5bbd417d3 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -951,7 +951,7 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
 	for (i = 0; i < class->pages_per_zspage; i++) {
 		struct zpdesc *zpdesc;
 
-		zpdesc = alloc_zpdesc(gfp, nid);
+		zpdesc = alloc_zpdesc(gfp | __GFP_ZERO, nid);
 		if (!zpdesc) {
 			while (--i >= 0) {
 				zpdesc_dec_zone_page_state(zpdescs[i]);
-- 
2.39.5 (Apple Git-154)


