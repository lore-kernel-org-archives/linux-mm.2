Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31BA9C61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510D56B00AD; Sat, 29 Aug 2026 03:48:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8FF6B00AE; Sat, 29 Aug 2026 03:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8C36B00AF; Sat, 29 Aug 2026 03:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 211D56B00AD
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:48:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B70371A0621
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:48:48 +0000 (UTC)
X-FDA: 85153530336.27.7C7AB28
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0824120003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:48:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O6vX7pnx;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989727;
	b=0L0+SEHhzuEA5R/uRNPJdB4rpJZjLtj2tOLX4n7xgbs02abVFfNm2uVJXElWq/+ZrV2hxG
	IYfy2Iy5lTkVTBtABsGKW1mVnuMDfcbTkbet6kTDnNDizsm4Nc00h9TQilozar/iGLnyGs
	cLewizsqmEefXeBNiIAeGevanD+zB5A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O6vX7pnx;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V58LX9cQfAsn8GO5XE1VypHteINKmbZsjfFFi0DDS4w=;
	b=y8SWi1LdHZQer5wLsHMc9kukCwgtM2/xJ6mLQoxlSbdiUji3JtYg4CxtrVqXZq2I4z7Jzd
	uayvwJEoEa8qowo+ilcAfv4Qjyc3sivP/03SPoguzQZdVhDSaWQh/MryB66guQNHotQWL9
	Td1raHvwyCTFHQdvCZZBvH25R8opN+s=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ce7d2adef4so27469015ad.3
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989726; x=1788594526; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V58LX9cQfAsn8GO5XE1VypHteINKmbZsjfFFi0DDS4w=;
        b=O6vX7pnxTwO8kX4KJ1+ls6q1WL9RFLXMp7ZOeYUY21x46kM3u/CCcfkMx+VPgI141r
         lXc9+kfCiKbjVo4oipl4GB3azK7pxT17m4vupGuiw+6ImuiHhvdEbIgFILoGiSNxW3gH
         gnMSMU3fzZvX6MeN+2d7Esg/RquL1VbIlWPSsnShiU8p20TbHYODA12XH9l/WGKeR5Zd
         7fGoGbR0Cs1c9BY0YcOkogvV31DwcLyxoPwFCAPQ9ijghnefDkQ3/MplP7Hlp190aA1+
         LAeus9/ileGBOh+vXy1y8qH4KWlYykepAKgm1c/x4sgwrYUFNYemsVhhXfUofVWAS51F
         fINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989726; x=1788594526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V58LX9cQfAsn8GO5XE1VypHteINKmbZsjfFFi0DDS4w=;
        b=IwyycfTs9APwk5meKShP5FH0nNcifvYk8qaNq2tyC8/pUCg/EUc/ZjBhb+r0pQej24
         pfQWOlASrVbI2N8L9kGEnAS8QpIMRYVGYNTP/9ykisSHghf+o6dEYmHFaYeB9U6HqKJc
         nGRkZKvp84uuppjWg66kLXFD2my5tyRoLEJ4aBdkK6oUAm1168yuUd6Uib1eqcUNyz8t
         vXU0IrpaUk6wbP+8LoUOgno8Q2sCIrGGff7wsYLzq72xPhG0/BURp9e92nepXwvmrx6k
         sKZnGk94+XdROopxDPTqcI46Zj8XCx74x7Qx8JJhSJQ0gQzdcoEp597BtwsgjTQmKYRW
         m78A==
X-Gm-Message-State: AFuF++n4+6g3cKQdMs45dO1g/M+r0gNypP7gH3OQQh1gjW55a0R5oI5o
	95Tn2bwD4sqatIUr93BUWmqqV9T/oUGolYeyGz+zNM7VWwMT+hqwNn/ojt14BA==
X-Gm-Gg: AYBFou3I83KHZ3n7DS4e48Rl8qrbGIfSM2nWZ9+vFIUjGz6EOEmRmbg9TK9TmVHcLT/
	AahWgNUPK/zNonAZRDRV6DKEw7pyB1GzG2ixAAbJbvdYoSEAnPAR+Vm8GLjxYWN3ZJ3WChr5/29
	vFSNADAUmn8PkAsPX5JuGjXnR4hNCOsscJo7H1P81htBTnz9A7PRwKhNTU30wZPGM3We6Td/VQC
	YoPi0i4Tjj3RurnmWJkIzZscN8Eq5sswuIZnZCX0c3xDnXsxdP9n7Q73sudwldn89aRXdEM5GiZ
	AwweDHNAULrRXNcQzGog6oIgf8h0LN5dl8JyLwsunDbUPRH6Gir5pF9R9DIaMuVVI0nfRTH7s2C
	Tn4ddg+bpT6j5c4F2afINqAJOvw0fftlV0rKJkF3/a5CmfdbdW2ZrI4P6Z47woxm79AqIs1qhOt
	0Bwgj8JugqqMWbTiOXq7DgUSSRtxj4wAGCz1TbdvngqCFqdAkuGK5HgMA5f0qaU6BFhLuojMlxz
	u4m0zPBFHykf6e5+XTwIJb7ZmrG
X-Received: by 2002:a17:90a:fc4e:b0:395:5eec:b932 with SMTP id 98e67ed59e1d1-396d0f8fdbemr24035986a91.11.1787989725941;
        Sat, 29 Aug 2026 00:48:45 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b186809dsm10748234a91.10.2026.08.29.00.48.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:48:45 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [RESEND RFC PATCH v2 13/13] lib/plist.c: remove requeue function
Date: Sat, 29 Aug 2026 15:48:37 +0800
Message-ID: <20260829-swap-pcp-priq-v2-resend-13-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0824120003
X-Stat-Signature: mk7ckxx4yadt98zpd8bryo45coisew3c
X-Rspam-User: 
X-HE-Tag: 1787989726-898009
X-HE-Meta: U2FsdGVkX1/Bf5PomokFfdSv9bHoO2yAtexsXAsaRRuDMBWKte+9d7fEbhrYBGkmPxh6mjnjTbJmigqQJMj8FuXth/Wn0441cJFVn/iACtPkITkTv3vshQhfNOGTcdiA1nN9TPWd8wxKmNVYv3ojQAclkfI7rGwgoDHXyebN90Fn1FnWO0SdNw87e2cfkAdUm5GtczgAGwTOfBTSd+2asSZdcrm86T8qpV7ImYAHe6p2SxNqJU+v71+VYc3eVcSg+JSfELMjYNsqXC+O+E1h8gSaAQ9MGcZecUcBTIulnAxaw3MeEYpWG9bAvUhemDEZ2zUGAaMJrWnB6vvM6LthGoNmRk/nb5O/WESBKLwxwiIWdLGOgPrgyJ8hLSxq8DMSHtbZka3yNanBWRmASXH9okbLEfV5ceySi+kgnO2G5IQFkT27QKB8RMQXSuGRUTwnl+ML7CTjvU6WcL/jeqFXf3u+p+1ZfdJdayXPTZb6WL96sHxVU0GhYRJflfwjJB9r/E2MUXUHV+6yn/GKWP7X3sChragH07VnOjbtzEl5T5Oc+gACpw2rOVq0KKIPqUKBnbftBsVKX3NPJNe5BZBXE9vJpho7zDtwqPUbkFmcEgPeRihmJOUwbZxuiVHgG1I9a7pTNbAs0Z9ShPvztHVBDKlLsWDQRcO8+1FjZ20RQmWNEjBfbnAp2d9iktukNfpX+/FIiX8f44CwDDX4Lf23SjBZSdKWC2bgRSLawpqqIG0H851lNoM9PhIbojRTFFsbiXmHFnv1tS/5OsoDy+FuQyO18TwY9P/hhL4t4934Bj9p7m2RpYq6dLcAYsiTni/Q86gyPX1xvxV/zw95zLpvdbKbPsgyOAaw6JYM1nR1x+weMULuGm86HZPzASYUo9r04hsQXExkiwoPjEctTZbEYkQK++u/zSxjITqMjnIco8Fe1qmeVds7ZrXse9wqhRB9LV4vae9j1GpJqpNitxB
 W/akouGs
 jCPPNkAtyEKDs7AYttyzzJORwmvJyMMj74vQcwmz83X3769ggQ06VHinULZxi17RDBa7TZq3ObkBwdpNDAz9ocaB14mtGQl8YRHWNGKZT8W7mmdJfc1XA54QWMrmcq9/rkCu8K8pWKQTI0btJvxlV/p2hK9T1H0mGekZJnVtZYgAYxKtHn97elYVfP/jEfbH6gOWF4+dfl4cFph2sNast+lrtM1oqj6YjLmKuahmBeTFlYliH+MzumtjWq5zFaaq+J9iIAmuA8zXbDdbtmG9mvEJQpcgUJY+8XUlY+mQjIjXVADYHZRymSz7nSxJylFsb9yxe0iIT5MEJl9x0asJ2d27XyhjDMByXNYn6a0f8Rr0f3Fn2gc1Z5xdfZnj8YNH2+T/1g+M0JQ8Y2TEJzqhE5Zy76+wA5YqQZDx4MZBtEc7JwILBcx+0b6wzJ85CRpL8DjJlr+YSoaOW/cqc0ut1CBbT9hDdmgcITOG/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now the last user of plist requeue is gone, this function can be
removed.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Tested-by: Kunwu Chan <kunwu.chan@linux.dev>
---
 include/linux/plist.h |  2 --
 lib/plist.c           | 64 -------------------------------------------
 2 files changed, 66 deletions(-)

diff --git a/include/linux/plist.h b/include/linux/plist.h
index 16cf4355b5c1..73d359c1a053 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -132,8 +132,6 @@ static inline void plist_node_init(struct plist_node *node, int prio)
 extern void plist_add(struct plist_node *node, struct plist_head *head);
 extern void plist_del(struct plist_node *node, struct plist_head *head);
 
-extern void plist_requeue(struct plist_node *node, struct plist_head *head);
-
 /**
  * plist_for_each - iterate over the plist
  * @pos:	the type * to use as a loop counter
diff --git a/lib/plist.c b/lib/plist.c
index a5bef38add43..b05ae7ffea87 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -142,58 +142,6 @@ void plist_del(struct plist_node *node, struct plist_head *head)
 	plist_check_head(head);
 }
 
-/**
- * plist_requeue - Requeue @node at end of same-prio entries.
- *
- * This is essentially an optimized plist_del() followed by
- * plist_add().  It moves an entry already in the plist to
- * after any other same-priority entries.
- *
- * @node:	&struct plist_node pointer - entry to be moved
- * @head:	&struct plist_head pointer - list head
- */
-void plist_requeue(struct plist_node *node, struct plist_head *head)
-{
-	struct plist_node *iter;
-	struct list_head *node_next = &head->node_list;
-
-	plist_check_head(head);
-	BUG_ON(plist_head_empty(head));
-	BUG_ON(plist_node_empty(node));
-
-	if (node == plist_last(head))
-		return;
-
-	iter = plist_next(node);
-
-	if (node->prio != iter->prio)
-		return;
-
-	plist_del(node, head);
-
-	/*
-	 * After plist_del(), iter is the replacement of the node.  If the node
-	 * was on prio_list, take shortcut to find node_next instead of looping.
-	 */
-	if (!list_empty(&iter->prio_list)) {
-		iter = list_entry(iter->prio_list.next, struct plist_node,
-				  prio_list);
-		node_next = &iter->node_list;
-		goto queue;
-	}
-
-	plist_for_each_continue(iter, head) {
-		if (node->prio != iter->prio) {
-			node_next = &iter->node_list;
-			break;
-		}
-	}
-queue:
-	list_add_tail(&node->node_list, node_next);
-
-	plist_check_head(head);
-}
-
 #ifdef CONFIG_DEBUG_PLIST
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
@@ -231,14 +179,6 @@ static void __init plist_test_check(int nr_expect)
 	BUG_ON(prio_pos->prio_list.next != &first->prio_list);
 }
 
-static void __init plist_test_requeue(struct plist_node *node)
-{
-	plist_requeue(node, &test_head);
-
-	if (node != plist_last(&test_head))
-		BUG_ON(node->prio == plist_next(node)->prio);
-}
-
 static int  __init plist_test(void)
 {
 	int nr_expect = 0, i, loop;
@@ -262,10 +202,6 @@ static int  __init plist_test(void)
 			nr_expect--;
 		}
 		plist_test_check(nr_expect);
-		if (!plist_node_empty(test_node + i)) {
-			plist_test_requeue(test_node + i);
-			plist_test_check(nr_expect);
-		}
 	}
 
 	for (i = 0; i < ARRAY_SIZE(test_node); i++) {
-- 
2.55.0

