Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 410FAF45A1C
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 05:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874B36B0088; Tue, 14 Apr 2026 01:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B3C6B008A; Tue, 14 Apr 2026 01:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C366B0092; Tue, 14 Apr 2026 01:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 624426B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 01:19:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F27591B7D38
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:19:35 +0000 (UTC)
X-FDA: 84656008710.11.F916A76
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id AA594C0002
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:19:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=F1gFYKm6;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf10.hostedemail.com: domain of create0818@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=create0818@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776143974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WouCWQZQw2wWCXfxw9TY2LZlejrYTTJjmaYv9acBuZw=;
	b=ThLtflPUQeXu6hlazIvqK1UDkpS7UDaTLaRjgeu0Y6NSbdFX9NHOH1CGz74OF7el0umOVE
	bEUkvQsJlLhnFXF8tCjFigTnE9rx1+dws2FWYvEhCnLLmvAdEliFdKitrQkwKbZ5gkitQ3
	M+JbnTGh8LJptS8Dik32qK2eSMR28VA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776143974; a=rsa-sha256;
	cv=none;
	b=U1rT2XjWMjgm2I31g9ubaI9J7t7FaDh9GI5G2ZoGnzC8qhPGg2Un90FQ8cGLLyE+cIaqOF
	S6iLVmT6KwmOtT0zQtKen5G9VB1T/ihZz5VnRXNC/HZhn2ldtsKTClI2bT7F7e6tDfVr1m
	Q6fRWr4clysJOZLNLyliCqgE/Wq8JK8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=F1gFYKm6;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf10.hostedemail.com: domain of create0818@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=create0818@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Wo
	uCWQZQw2wWCXfxw9TY2LZlejrYTTJjmaYv9acBuZw=; b=F1gFYKm63ZQIZDYNl9
	j9X7ip/O4JvHmcMbAf1dwvklOUcBaABPgmG9oXv5kvj6WpH+8m3vNAI/w2Ejxgkc
	3y7tI6TFNFBEv5jqByyWdlYnNTK82Dtkw/FpdjVT4zp3XAtWx6nwK4Vy1OT28ldo
	EMZwqPJg++vcfcMImhQx6qXzg=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgCnPNFDzt1pZ+E6VA--.2975S2;
	Tue, 14 Apr 2026 13:19:03 +0800 (CST)
From: Cao Ruichuang <create0818@163.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Cao Ruichuang <create0818@163.com>
Subject: [PATCH] mm/pagewalk: honor action in pgd_entry and p4d_entry
Date: Tue, 14 Apr 2026 13:18:54 +0800
Message-Id: <20260414051854.18487-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgCnPNFDzt1pZ+E6VA--.2975S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFy5uFW7KrWDuFWxuFW5GFg_yoW5AFyfpF
	W3Cw18ta1DJFZIyFn3Z3W09r1Fvws7WFW8Ja9rKryvkw1Sq3Zaqa4DXr1akF1UCrW8XrW8
	Way7Kr95CF4xZw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pizuWJUUUUU=
X-Originating-IP: [39.156.194.234]
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbCvweWz2ndzkcmHgAA3k
X-Rspamd-Queue-Id: AA594C0002
X-Stat-Signature: 9d7kmfm4hpwz4ssp6ueikpnpndpi6s5b
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776143971-178633
X-HE-Meta: U2FsdGVkX1+9h9d8U2EwBAsjgco+oa0U/QpATjNOPTXAoPnwAJcUwX6u7xOtNpK6Sla5+UJsOZ1jThDPRdZvG7GcrloKCmvdC9wXNp4MFyKadLg3ZKMk/t2B/j5c1oE8aZblhfA9AGqrLuPoN9QyUnpBnKZFEvEwSrn7kTgnLryuyew+PhwU1jZrNO+Dil4D2WpXnAkNsixTsjUrmJfeZury5zb9F1j0v95l+fYzMgEnYqKcwE8FN6EOSHpr9uDFTqaXDHTiqMIPMuyWl6Yu4hKtCNQ1H06hGYH42XyzZqlD4oco5v7oToeRtMnT1xN4fpiETdcOo7ishs836B/SqtB3Rt9xvp1SnRxYFn2djBf6vOj4F8tn4IjUBvD70Oueq+gsjpszQGPSJQwk3uJh7lJGXj83QrCUpg+FdxCm9+ZVzLdxIeX4mGFiA3+Dfgbd9yZxbduo1nWf1gqd0CsRoZw86stiND6oBUv26mUe2uLgjy9ixqiPJO2HBEvAgWBt+ZZLDzcyQGmDWitcKY/l6tPajmhByWYppZDvY1ho+aQLmAvczEzkkuoEaWgRqxcAsEqaH68huggU+e8RD7BELkXNoq6q1KIwgoqq8A7kltgNbezMQJAxGKlUu6GyMjIJp5fb2FbE50f/htqz6vdS1QRNxSJutoc06ajoZonI25/hmNMNVpU12yz5Tv0KnfA28Kpe0wUeCZZFdzMTHE+b1lM7IvtUMF6LR4yhcHRUZtKQx7utbh/1oifOdk8XDuFlZaN7Hm4BZUVixWpxppf5ZsYPcMtHkWyaoSs5FO6uSxTzFyj2W4KzduvZBxORsXzm2UJIuiRYc+UaQB+cLH+ANznnHD8KcwffOS9jXY7oMO0bxnl8MziEgp+jCUmGh5ZfGHzv5ing22jzBUZZkz8XzmFu/ZFXM+QeK1DxxlkXw28cNkTo2/v2gEjDMcLcgKJ3uh4RigqYIiZeV9856BI
 GoRh/v1U
 op3V0WZrAzqMcKhaOykOu+ox7BqV3JEntOVJFTtlRs5h9Nnr1Lyhw8G0vS89SlLjB5zT+rUp0+wVq+4Pm+wSOA4OWXLIK+1XDZ7iFwoedYSQjejflrNWao9gbsTwuRxScPaN3yzTaHwy+2y5mZN/kM5Tn5PAZNMAiyJ5JptQhc4lMXEUGRPDa/6MYMePRSxz4jitDQhqyhHE3N4qOX9OqIqYHpDS9iFFI6NVTwMTmzxn/QOc9xZlsmovWlnX1C55Wfc+77wXUqQInQ9vEeGbPNOFv9c/0LoGoKCxyiBi3bSQTKC2XMkUSkFRGpn/kZf6LI/a55Cdp5b/1OnMFbAY9GrtPoyqdL10e2xAsFenGx9NWLFHltXRtRsA4t2aIKIvaJyfiw0FCEzWIP4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

walk_pud_range() and walk_pmd_range() reset walk->action to ACTION_SUBTREE and honor ACTION_CONTINUE/ACTION_AGAIN after invoking their callbacks, but walk_pgd_range() and walk_p4d_range() do not.

That leaves the top levels with inconsistent callback semantics. In particular, ptdump sets ACTION_CONTINUE from pgd_entry() and p4d_entry() for leaf entries, but the generic walker still descends into lower levels instead of skipping the subtree.

Initialize walk->action before calling pgd_entry() and p4d_entry(), and handle ACTION_CONTINUE and ACTION_AGAIN afterwards just like the lower page-table levels do. Also update the action comment to reflect that it applies to pgd_entry() and p4d_entry() as well.
---
 include/linux/pagewalk.h |  4 ++--
 mm/pagewalk.c            | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index 88e18615dd7..d3f84781792 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -94,8 +94,8 @@ struct mm_walk_ops {
 };
 
 /*
- * Action for pud_entry / pmd_entry callbacks.
- * ACTION_SUBTREE is the default
+ * Action for pgd_entry / p4d_entry / pud_entry / pmd_entry callbacks.
+ * ACTION_SUBTREE is the default.
  */
 enum page_walk_action {
 	/* Descend to next level, splitting huge pages if needed and possible */
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 4e7bcd975c5..4268e08eabb 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -261,6 +261,7 @@ static int walk_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 
 	p4d = p4d_offset(pgd, addr);
 	do {
+again:
 		next = p4d_addr_end(addr, end);
 		if (p4d_none_or_clear_bad(p4d)) {
 			if (has_install)
@@ -272,11 +273,20 @@ static int walk_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 			if (!has_install)
 				continue;
 		}
+
+		walk->action = ACTION_SUBTREE;
+
 		if (ops->p4d_entry) {
 			err = ops->p4d_entry(p4d, addr, next, walk);
 			if (err)
 				break;
 		}
+
+		if (walk->action == ACTION_AGAIN)
+			goto again;
+		if (walk->action == ACTION_CONTINUE)
+			continue;
+
 		if (has_handler || has_install)
 			err = walk_pud_range(p4d, addr, next, walk);
 		if (err)
@@ -302,6 +312,7 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
 	else
 		pgd = pgd_offset(walk->mm, addr);
 	do {
+again:
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd)) {
 			if (has_install)
@@ -313,11 +324,20 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
 			if (!has_install)
 				continue;
 		}
+
+		walk->action = ACTION_SUBTREE;
+
 		if (ops->pgd_entry) {
 			err = ops->pgd_entry(pgd, addr, next, walk);
 			if (err)
 				break;
 		}
+
+		if (walk->action == ACTION_AGAIN)
+			goto again;
+		if (walk->action == ACTION_CONTINUE)
+			continue;
+
 		if (has_handler || has_install)
 			err = walk_p4d_range(pgd, addr, next, walk);
 		if (err)

base-commit: e39f5a33eec1a4ea03358d82e861d6bb0a426b17
-- 
2.39.5 (Apple Git-154)


