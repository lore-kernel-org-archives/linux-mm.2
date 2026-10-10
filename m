Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31703CA9EBB
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 02:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23A266B0098; Fri,  9 Oct 2026 22:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C3AD6B0099; Fri,  9 Oct 2026 22:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B2886B009B; Fri,  9 Oct 2026 22:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D19216B0098
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 22:09:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6484F40708
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:09:42 +0000 (UTC)
X-FDA: 85305085404.28.252B196
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id ABB82C0007
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:09:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b="e3sjz/Kf";
	dmarc=pass (policy=reject) header.from=openai.com;
	spf=pass (imf28.hostedemail.com: domain of kylebot@openai.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=kylebot@openai.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791598180;
	b=e5nzFZBipHstluQa6tzNBg1ZjTtGm4LPmRUhkv5S3gQJ8fVDVDzmYuhZ7R8VBX53fygCCs
	9aGMWwonPwvKBGyixGWdiHe2Oejii8WdrrzDLouedQvwGd3SjzSmI/Uwf8hV+UyRQexVUl
	P20+H5a7r0av3rgFL+8F6qpLjEZoB9c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b="e3sjz/Kf";
	dmarc=pass (policy=reject) header.from=openai.com;
	spf=pass (imf28.hostedemail.com: domain of kylebot@openai.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=kylebot@openai.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791598180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uD8coseHJ8cbO2psrmuf1ZffJ2GQja8vTBxGB69y3bI=;
	b=H3O0ft0uYpHfXL+MJMaGHNIwNFGSUAq7F8+CCR3Ak5dvEl9VvXW/Q+XbbgjrdqAtek0Vum
	s6RseaZ0uPUu8ZyWsKb1SpAZDZ/W4zisalLRYegheJI3B8y7U6wF8KKHpL3JnWEJzzBQkt
	e+/17qMOMwx8hEyxJirhefepYx9gjA4=
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-82395ae2ea8so294246a34.1
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 19:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1791598179; x=1792202979; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uD8coseHJ8cbO2psrmuf1ZffJ2GQja8vTBxGB69y3bI=;
        b=e3sjz/KfZr23KFiy7KXXKJc1qY7dztlTRCYBuGwfhZVhbquy2tAgo57dO5oAXV3LBx
         x00oWZjQfvYwXrIEh1MeHSkWuYnlqCKVxXQJkPfnpZEQpnmQFmZkMu1VZTe+zXRFSpZ8
         xgNDT3IGMIwtjMlvN+hfJjwr+CM2d8CyzVueY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791598179; x=1792202979;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uD8coseHJ8cbO2psrmuf1ZffJ2GQja8vTBxGB69y3bI=;
        b=inqIiDf1BO8s29PKt3B4kLACkfAAtO/V1Htymg63oqHHv04paE7y+JuvFj0tZhZOXa
         OGAJVfCoh8BvRRJLeHUfVtbb4nk74THrWrvV2SlN6ZX03uxiuUIiHzP5sg/PnDdF9fnY
         9anNTW06t7Cj8788kuY4VkNKyzIXTtpaGa0cjtWt3KhLgigiDEcE8jI/5lJzlH6/CMcu
         r01l9C83S1EECTTDeBE3mcTrhLdCxGG38GEpY9SRtVgX+0M+rWpKyIeBDu0MIZtKREsE
         gkdl18VUffp6B1+bTO7wR+qEZjtmeXuUtpc9/9DD8Z802WTWLumq8YYBxiFVyE2kxOkA
         7atg==
X-Gm-Message-State: AFq9FYIuVctTj4GSukPWHBgd2Bq3TcQiS/TM1gwjNl+3y5+MdbbsU81H
	5A96aA+ePq9Cn5SURJ5EIihbRp5S2SreO/KzqrNnipuWzuTrKH3dZpG0bcl6Bx2kel8=
X-Gm-Gg: AYBFou0oFgJpeIVSskCPeXbZ+BtENDzUjK4JrkLfX9H3eZ0x6/Dj8ZNVC5bGCHP18Wa
	Qb6BUOwouaOkTolmMpMXLRsUk4IBe+UzRDFUkNBH9Q/2tnIgzJitmTHkZx+qP+FsGZ+xhiAdiNt
	9ddCWyyDjs3dijtR9umE8GrXJb4wjPKVn58GTL4fx5/Ozpg+v1PqQy40p4ULaQnxVvSz50bx6xN
	Y/2d5UmesalGBswwD4gIAcMzJcLnVvyThL/iVTHKr5kzlVTXhUj3h/WydOliNxGRpOgOZsKj92w
	EHeWv5onQM0FfMDWvKCnA7ECWp6y88cG5ccrHPf7MWnIiHBLM9jf5sLPkYHwrZBUZfRrJipfG2u
	pXqkJDK81f8bynnUvIjBUcVgF3t4ULmFM26RjR4gCbk5QItIGqZUXapM0bDItVP+sw1gi2Q2PQ7
	nf7WGjQWia8FfF9zfC9PIcBG2ZFxx5tmaSUPc8WCBT8zDBhptWvnVl8aW6XswASdSPi6KKjT8LH
	XrwCwvmy/OD0PXtuLknvA4WCprO0pTxY4SQ8r80dsQiWnkvZoJhz4rKeIJHmg7UDE0i+tJadVQ=
X-Received: by 2002:a05:6830:6816:b0:806:1e7:4167 with SMTP id 46e09a7af769-83095843911mr3366701a34.13.1791598179659;
        Fri, 09 Oct 2026 19:09:39 -0700 (PDT)
Received: from com-75606.corp.openai.org ([199.47.143.7])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8303a515aa9sm3580257a34.25.2026.10.09.19.09.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 09 Oct 2026 19:09:39 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Kyle Zeng <kylebot@openai.com>,
	stable@vger.kernel.org
Subject: [PATCH] xarray: initialize the offset of new root nodes
Date: Fri,  9 Oct 2026 19:09:34 -0700
Message-ID: <20261010020933.83051-2-kylebot@openai.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ju8fpuc6izm7cqj85zx9tq59pj4k7ama
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ABB82C0007
X-HE-Tag: 1791598180-937710
X-HE-Meta: U2FsdGVkX1/3lDBGQWN19kWXzBXMl1pkN4pKfyTgo0H4MpZbpGZqdnFbUyEpxEHQ2JgoZFKBtU/jF9RZWLWiI8Eb5+DjSpxVNGOv5pAq1A5y/KTdKFQ8Doi61jWBkVWf9YF5mRi+iXm5BszzkiBPT1KSVBw4vBq1DWqTW5+S4DR+uAMRP0IAJ5plF2ODW+CNHHWZEhPOMqOQAEWjhxIFQglNhCdZUuwjaf9d0cTr4MZrDJFKThechX7+Pr/67zvovXdMfe1r0MXFqNKI3HMR8ONKU4F9e1gTJuhuqpXhSbNGVmPEefv/SArU+Nqg2LZ9c9d4HwXeNqBlaGcXhw/nUB1fzXSU5of6CtPNEGlKjQakZE6CcqXmylUjCOTEOG8plJXl2FK+hg14fo1odTxRr3+dvZoNhsXz9zRxDeVp4dpA59Ne76XB6qIHuqXGHIaL226PH9LwHZfOPXluXOox3kexIXyxUryFRUndhiEIGuJrgk/ALawIQKF+fh/Sl3wB+eT6onJBgv84hAHO2PGk4wzxas1UlTSHhTxwX0m3ElNTCBiKl+rqqq6KMozKUzRDX5dld637tjHitjnJI6/2udEFMqQbQYOHusNPcCPxUr/CBkh8jlVy16cLnHnq1yldKz+aYtiMtHVaq5TmdVgCl8yRtpBoZrv0xakTO3SOrrINugaCn/FfpwlmnimtPygNjUdsrPBAHOeuzbQIIV+B8Aav4eisJuJg1su6uw2C0rB/Fs8kBM+8WegEfruWZ8y1CJy7lgl+oz03FNp8+dneIc7N680/4w72bsWGXZbgTP3kpmGgWSyyvYX1CJG7uUAcp18IZ9RNWqbY2lEAYwKypy04yoWGaCkpZQbUYBIrxNZpFZEE1m+XhllVBTweB4H20iWs7yL3nn82CdVTKLVK1eVaxhXWYxqdDVwxUzWqduPVLjpHj052vGLhxDLWlhu4mzf03fKBLHf8Xr6Zqaf
 tvjPcnJB
 uaDexEyogho+sBuL84+B+4uN2EAEPoaSDG91WICWw/8tTYFDVISFkEld2CDctRZHIM/M5hssn9ElUqpMB8naKGLZ6dO9y8gaJLcepfEZZrClwgux9SUEnGxo/X3SMaovrzRXJI0Fm4EkREkCB0N4lLdGb3BZeTai3bws75HIBK34eDT6YhWx2NoPDnojuNpKNbV0Ptlj4G3JZBNTmHAMIR8cXKm4yNBNWXNc4OFQk/K9nIJlIbW7LSLhoGUpVaawGVRzPJr5UHiDrJe0olBr3Lm8Y9xKjm3xNV5EQyQNA3NpzBwr4bbFD/vRbfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xas_alloc() only initializes node->offset when the node has a parent.
The shared radix-tree node cache clears slots and marks on reuse, but
leaves the old offset intact.  A new root can therefore retain the
nonzero offset of a former child.

Lockless iterators read a node's offset before loading its parent.
If xas_expand() grows the tree between those reads, the iterator can
combine the stale offset with the newly published parent and descend
into the wrong subtree while retaining the original xa_index.  Even
xas_reload() can accept the resulting entry when the offsets within
the two subtrees coincide.  Page-cache callers rely on that check to
validate the folio they found.

Initialize every new root's offset to zero before publishing it.  The
offset sampled by a reader will then still be correct if the root is
made a child by expansion.  Non-root nodes retain their existing
initialization, and shrinking only promotes a child from slot zero.
This fixes the forward, reverse and marked walkers at their common
source, without changing the iterator or page-cache APIs.

Fixes: 58d6ea3085f2 ("xarray: Add XArray unconditional store operations")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
 lib/xarray.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/xarray.c b/lib/xarray.c
index bfe7bef80f34..509d7e4157bd 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -382,8 +382,8 @@ static void *xas_alloc(struct xa_state *xas, unsigned int shift)
 		}
 	}
 
+	node->offset = parent ? xas->xa_offset : 0;
 	if (parent) {
-		node->offset = xas->xa_offset;
 		parent->count++;
 		XA_NODE_BUG_ON(node, parent->count > XA_CHUNK_SIZE);
 		xas_update(xas, parent);

