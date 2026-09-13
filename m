Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3CB2C88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 15:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D37DC6B0088; Sun, 13 Sep 2026 11:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC11D6B0092; Sun, 13 Sep 2026 11:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89D56B0095; Sun, 13 Sep 2026 11:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 861A56B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 11:26:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D56C12076B
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 15:26:56 +0000 (UTC)
X-FDA: 85209116832.18.B758F79
Received: from danaos.cslab.ece.ntua.gr (danaos.cslab.ece.ntua.gr [147.102.3.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id 06B231C0002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 15:26:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=ocCjD+M3;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr;
	spf=pass (imf18.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789313214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lRPq1ivvZV4kIEoSXDhOve61Vb7l7C50HeVP6eZoF0=;
	b=aMfv9c3xDZb8ecHXPT8pwHWehMEXBB4b4WOYV1eASEM863/Fe0kDbJh/1+dBrUL/0iqvqV
	KuLjKLynyiPPEbGoZS0+tFqdiwN10Z+wvxJjsooeWJUi14mg/pdUCOgJ4lxulwD1Hdyuad
	TOipHBwC7W/Ltb7D/dCUFuwE1iba3sc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789313214;
	b=1V57whSnrJHu5/pKr2sHzm5FISRIgTjYSI3P65jOpgp1GZEtDCZOh80AS3nNjtgepYQR70
	0keyp7RNHyfHQduj5ygXRk2wOyMa+sO1xnW8WFykIhksHDsPlBmKHW9dwbMb3jIGY0vcOC
	ItRY6mXZOgdHb9OfiL8GzJvOwC/+7Fk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=ocCjD+M3;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr;
	spf=pass (imf18.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cslab.ece.ntua.gr;
	s=smtp-cslab; t=1789313206;
	bh=iTPbgi6TTWpSnIYUxKADxzx4y1Pw8y2qclg7BMPDqWA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ocCjD+M3XRKIeHFL0PLzO2juIWlIdesrKS+H8mAALwL1HK0v278xB+2Mee/AraY51
	 zjCStwdaQj0e+ZsOoCbBvK+4zAfl4pjVep01QOwu8hoj2cbGLXCzJpoxSy+1B3CNeQ
	 fJoTi7YLTd9a6TNuZfpclmer45zhLLEKcVoNdKvE=
Received: from [127.0.0.1] (armor.cslab.ece.ntua.gr [147.102.4.33])
	by danaos.cslab.ece.ntua.gr (Postfix) with ESMTPSA id CCA93120BA2;
	Sun, 13 Sep 2026 18:26:46 +0300 (EEST)
From: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Date: Sun, 13 Sep 2026 15:26:19 +0000
Subject: [PATCH 2/2] maple_tree: fix invalid memory access in
 mt_free_walk()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-fix-maple-tree-range64-rcu-v1-2-31a130bb8cbf@cslab.ece.ntua.gr>
References: <20260913-fix-maple-tree-range64-rcu-v1-0-31a130bb8cbf@cslab.ece.ntua.gr>
In-Reply-To: <20260913-fix-maple-tree-range64-rcu-v1-0-31a130bb8cbf@cslab.ece.ntua.gr>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Dimitris Charisis <dchar@cslab.ece.ntua.gr>
X-Mailer: b4 0.14.2
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 06B231C0002
X-Stat-Signature: jwg1j33cse5n7etuu5r1ycinzi3ksboe
X-HE-Tag: 1789313213-710126
X-HE-Meta: U2FsdGVkX1+7DKidnH9arpou/iNIVddnRKKBmisNFJhjjRGF1cmZhCJKjlCwLT60fT1R/Yh7sAGPxCXSxB+VUz+VRD2U7gYjI4R22Xo997ZWn/uL8fwyNCfEbZYag1Q/gSzze9eP4ye8cje3IA2DVcED0lsiLFGsa3+a+AXjSb44hcuGuK2Lwjj9CpFQJ3UL/sy5HKvr7NyLcrPkzD0jehbcLDkbo2ubCPGJ0nzscVb94Ib4hcY+wyvZKzOWOdim5HeLfs8bsQ1h6KrSzflVXftbKY2HaBNlSdCK/S+PlatRHGNTuTE1L9+qXD70jbOIMGualqc1HziNzskvCa4MCd7mckVvUG0QqcRaAbva3PMMW155Ki2kybf1/MesEy4i8m94g6ZQ2teGFKTpwBR+K+wiVcBHrvw4tVhEiyzrvQq8Y2mE6U0eOH41wcqun9UAMPcV4DYxMADPcqWABhlwz/7g6c0bbXZzKoXlYFVPfB0CsDjaOVANiB9NiicwNDjhLziJEvmfkE7EBTki/C2HXqg4OTLq1rvgR6GhmSkXO+zMoufajxrFkUsIBoGVIE1cxiaqmdmfMB5vBOEZBfdESWOWLcdSSidm1gF857AqQa4b3sBULCDWFyjrN/cfyo2X6009g4gjGrx2Vd9TmtqWgaBXk9bpCIhBmo69eEpDP3pjr8PsldzBOkuHXm8hA8KsUq2/7Bxit9yw4tIkdjxtLVlPDxxue/gtzV6qSV2xla1I3/ule+R3NMZNzYOEySSZ1wsE4mpstUmLKWzp0k9sbqknxtcCmxv5mL9QO+mIZ59SRsLdu1pmWY99rm79crGB4IYdD1AipYe7tuK3mdX+DtWk8jEZ1JUdReZbun0HbV2JPIA+cyi324xLkV868tYdrTJ+1xtg3j5r+oOrPfN7+OjfgXYRp2Jr9hOHM5G9Lkw/YQxx4CITNR5OdVkN4c/wtVapsjmcPSRCxlJQ0KQ
 tQmrQ0x6
 Kdh0hMwro3Ar3Su8QViezQ559jy16rVt4/5diessslgYAM+ypTcRIzpx4FCRsHTGMWarSXgDiKaR0/fBf6P6B861hfg/UKB/6YYlWGvy7uG16jrbmTYuT6U5lHChm3FY2J6/hPURB1y4JV6jqAK7BjNNoJYYmbv+3XnUR16TR79hZOgfYHGiOBGXNfrgrfwdljlbe2ObuxUU7z+XS6YRpU71BvjMbt15OunvkzENXAq6V9ZmdYPBfpH4CEE9li0vY8LgTRDXgTv6snIIscu7mMMZOvNcQL0xky8pj7R+ptQB5ImKKQLBlHrTcSSPMCzvXD7hZjZ/Uj3KsoRAPB3DbR8BKp4lJoqep3xxmiZ97TR4k+0p8u2iOTtYKBg==
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


