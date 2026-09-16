Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB5FBC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359596B0098; Wed, 16 Sep 2026 07:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C22F6B0099; Wed, 16 Sep 2026 07:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8556B009B; Wed, 16 Sep 2026 07:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E78C96B0098
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CAB3FA06D1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:39:08 +0000 (UTC)
X-FDA: 85219429176.23.5A5EDC2
Received: from danaos.cslab.ece.ntua.gr (danaos.cslab.ece.ntua.gr [147.102.3.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id 90E4F100005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:39:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=d47+8HVT;
	spf=pass (imf14.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789558747;
	b=pVZfvNcQYpMuwkAa7wf3U4ZWmPZZiAdODooTJFFtUU8usbkYyeNlMjdZlgG/Z7in6DdvNN
	4aD9IfQlhC+cGiauarmPzQR6F/2I6u/7Ox4bzQr90huvnPXscc1V+7rBufGLNjp6McWXsy
	l0kYelP0py8KniYV+McKdt6gLJkL69I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=d47+8HVT;
	spf=pass (imf14.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789558747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lRPq1ivvZV4kIEoSXDhOve61Vb7l7C50HeVP6eZoF0=;
	b=5oe8taBp6/LFBPdhdM1k0YpyeCbVgFtcyAfqQJXSqwRL7O6tf8w/Ed+eJmxMDvs7HIwJVJ
	zrV9tKIBhRLDiVJgbiZUN8KY/AzyToSSikVB4nv39HKYjaLjEDzbpXL7PbU+ss/Nz0RarY
	AMK4zTT3X4WgjKWuOrCUv5Vdt8BQMfA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cslab.ece.ntua.gr;
	s=smtp-cslab; t=1789558744;
	bh=iTPbgi6TTWpSnIYUxKADxzx4y1Pw8y2qclg7BMPDqWA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=d47+8HVTgyT/i/Hi2bUgm9y0um/FjGxgtsCzL2ArQFbb8d+v1ZL9I3nvIgQTAY8CN
	 Wk+ZzIZ7AU8UkFUBUIIYN7y68xKkXeHQItTNLM1EHiV+zwLSjHMbw7Sz8q+XtuEOAJ
	 2fFMAIeiLC2DlFvC+kDAkn7DzmxSaik5QQ0BRVgQ=
Received: from [127.0.0.1] (armor.cslab.ece.ntua.gr [147.102.4.33])
	by danaos.cslab.ece.ntua.gr (Postfix) with ESMTPSA id 141F9120BF6;
	Wed, 16 Sep 2026 14:39:04 +0300 (EEST)
From: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Date: Wed, 16 Sep 2026 11:38:44 +0000
Subject: [PATCH v2 3/4] maple_tree: fix invalid memory access in
 mt_free_walk()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-fix-maple-tree-range64-rcu-v2-3-0b09de37eb69@cslab.ece.ntua.gr>
References: <20260916-fix-maple-tree-range64-rcu-v2-0-0b09de37eb69@cslab.ece.ntua.gr>
In-Reply-To: <20260916-fix-maple-tree-range64-rcu-v2-0-0b09de37eb69@cslab.ece.ntua.gr>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Dimitris Charisis <dchar@cslab.ece.ntua.gr>
X-Mailer: b4 0.14.2
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 90E4F100005
X-Stat-Signature: 33f8aeccwb87ossfp4adzkzr91eytb59
X-HE-Tag: 1789558746-527285
X-HE-Meta: U2FsdGVkX1/tltT8YgTNXcNZgIu4budZcohzgrLqG27vlNG01kTYd42pNlYm2kNqoy9O04lIuhX0LFLDRgUXmd2Hqc1Yj5wKneKUVdS7EKnWZq/Ih9HQoKrE2U50LJyp7B9aQghKjdPcux4AtoSRZIBHaAMJa0yLcVrpRoiWBG/2AZHV9IWZEZ9zLHRov4HfiSvnPXR0EoOZsI1tj39DTRT0SZDl5hEobNLa/1+vIDmOb65WdfUMsDC+d0W0A3o9CzIlm8XWGzrNIa1O+FUyBe458m4wUzTDPiQHuglEZF9Jdz94d5Kuh44YmcxG8GgVP9sjr5wUnhywyZrXlUaY460x5lrlf6DysXeI/SQr0+RFqF2uIgqNQ7QWI5JlF6VHkI/W64bA4hVhEFv6sGiEaJV5A1F3ZUwa4hCPua8aLOUQGI4ezL2UpiraI6SMTS09FuWfQvtEYfT1ysXTy8/Vsbj6STV05FTa/xiTLEop3RDm4/BS4kDFNiRul/G+Bbu9GOhAjheGlLvk8NxMm7BE8QBPEf9A2MZd9ykJVGxVHl81o6CEg4tlXPDs0WKY9lklnJkFIjR7cmvM3zkScqUCPcarPp1rYRqqh3EhMj3bOPEHZXSEBSO3g9qVSbJJ2DDjaI0ipWTQUHANFR53MyoDu/3vxee8/1XAgqCGEXnJZl1VOytdhdBAvxsqcYzbRCbwkVL1l6IB8hBHnhpUDOg3Ji38cndjuC8l9i9WSK8d1yF1O3sVNBVp5U5ccCgTAhzxLKKMs2GTON7+rvbPY4wDNv2xPI9BwNfhoSrg4MzOAwJqNoo72VkNphd9AgdB3ZIhLvtQaBYSyTB13V+c2+cbLg6yGAV4NEwwuEJqlZZXQI84pSccNCtxXDZDhbHysrOfCC/9b36UiVDkXAn8gCeIs88Oi4G2OLXrFtLcj66PwTIJHEVDO9iAAf7ry2LpPNKqrqoW4yQFJccxAeD+E7X
 2lyrCbJu
 yFmuf4NCzoQSIxvCoaSaB+EuoyoOY6torYCaPGkHM/HeBujpotMBbIAw94u4+Hnrw6gTumNBoEkef/K61Dnb/d1+jvaLcCaS71mQoWRFHNgU/FUGpaf26/KsF14j1zb81Rno02DZg/pB28EP5WuHFWRuApg23rRKlJZdZ0yngZhW9m7IO0DnY/Fe+3vGy4Rv6KtHGv7eCXY3Xu0KLCQ7TRIUp9bf9vNjCuQ7ZF7sPuwRIZldOjQITp0ZK0wSCmtnn7Kk0ugcAEST3vv9s2YM9ahYejm5OBbPVRiLlZ2ko7SCcHqF/ysbFQXwoppv2xtzl6DhWNe03+4mhUE8B3wRCu7cmjgncX6iEA3lc7GN7uzzTZF06ZNJ8sdvGsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mt_free_walk() descends to the left-most unvisited "parent-of-a-leaf"
node by checking the condition:

        if ((offset < mt_slots[type]) &&
            rcu_dereference_protected(slots[offset],
                                      lock_is_held(&rcu_callback_map)))
                slots = mte_dead_walk(&enode, offset);

A maple_range_64 node has MAPLE_RANGE64_SLOTS slots. When it's not full,
the last slot carries a struct maple_metadata holding the offset of the
last valid slot. So on a node with MAPLE_RANGE64_SLOTS-1 children *all*
slots are non-NULL. The first MAPLE_RANGE64_SLOTS-1  hold valid pointers
to child nodes, and the last slot contains metadata. The above check
therefore passes for all offsets, and mte_dead_walk() dereferences the
metadata as if it were a node.

To trigger this, a node at least two levels above the leaves has to have
exactly MAPLE_RANGE64_SLOTS-1 valid pointers to other nodes.
maple_arange_64 nodes cannot hit this since they store the metadata in a
separate field.

Fix this by bounding the descent with slot_len which holds the number of
children of a dead node.

Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
---
 lib/maple_tree.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index e86eee43aa0ada6963995cd74495d9344f6ccd06..0b0036c9f848929a7c9a26650ccd935c44aa1376 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4752,9 +4752,7 @@ static void mt_free_walk(struct rcu_head *head)
 
 		type = mte_node_type(enode);
 		slots = ma_slots(mte_to_node(enode), type);
-		if ((offset < mt_slots[type]) &&
-		    rcu_dereference_protected(slots[offset],
-					      lock_is_held(&rcu_callback_map)))
+		if (offset < mte_to_node(enode)->slot_len)
 			slots = mte_dead_walk(&enode, offset);
 		node = mte_to_node(enode);
 	} while ((node != start) || (node->slot_len < offset));

-- 
2.47.3


