Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 027ACFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 07:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6B46B0005; Wed, 29 Apr 2026 03:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F686B008A; Wed, 29 Apr 2026 03:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0DDB6B008C; Wed, 29 Apr 2026 03:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0B496B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:24:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5BA2F160705
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:24:27 +0000 (UTC)
X-FDA: 84710755374.23.9967B1E
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1E201180002
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:24:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=LV1JzEdS;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=IIDVJIer;
	spf=pass (imf24.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777447465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLZGA+GoMQmUnCBWDiqt4bvKANNT1G+HMTcCqRQTHDc=;
	b=kIBELz0FaL4PIoUhBRDqOEWeP2LtWuQ9hBnujxwggXDVgq5fiBTpIM3C5w/49dGWL0Q+GT
	0sNZAsF5+gTohQOCHF6NrrFk1js7VeBWvoMEUs9cVD3OdxYOK6xDqyhq0BfyrCMKnootUU
	Tf33TtMBIzTzjJ6D7cp98L6de7NPwz0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=LV1JzEdS;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=IIDVJIer;
	spf=pass (imf24.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777447465; a=rsa-sha256;
	cv=none;
	b=oqHazeu6LVFqZuLqiAqB6DOow9fMsUKZZF4NyhVPMdeJxnbAAa/n/NZ2C67tZRhOAYRDRn
	EpmOxOgwuJockQAOifE8Ky/a4KSSjpY02z726VJ5iRyF0nE9BdanclEnqGnkVnk0DQgHI0
	TM5w63T0poSbTEUWcgiCOE94x/sN+tc=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4g581y5gpBz9smP;
	Wed, 29 Apr 2026 09:24:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777447462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cLZGA+GoMQmUnCBWDiqt4bvKANNT1G+HMTcCqRQTHDc=;
	b=LV1JzEdSj0StBn8WhdlLca46jP7oMK5XFb3p8eeT5zyDzdb4/aPbMx5Qdyv1e5+VOhm2yA
	8uJSYTg2w/XDwOX6BNGszT+0HRL9Si0OPjDev/NHESaAAnCnqsNpeVCFVX6wCeFLuvQpE6
	6WOBJFV+0t9ASpF1nzWGoZfIxIfjlS5Y1qhYFu8PTpaTVn+chlSYUbXICY7xS/Ye5yfXNX
	nSxbvgwfWpfYKZhWUj4SH0dkMdOT67jBjD50FbyRVRBkpNDaWd4m0sNCwc0Bza5KesOzN4
	yUuK+WacVrnzc6a+SdyZB4fP1+3IV0F0R1pKnikfyq18gfHYEQUEq3Dspr4lVg==
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777447460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cLZGA+GoMQmUnCBWDiqt4bvKANNT1G+HMTcCqRQTHDc=;
	b=IIDVJIeryqFSNmcHYDo30TAn08Ymcsoz2iobD6qJowiBs64rt5mwwarsJ5Q6HR1SrsVder
	chaq4pvCuqxsdXh/WjcHCywib1WmPcY6BcXoD7hek5PIBkBT2FTLaj5XjjNKAi2E36qx2A
	0F6IkQH/3RMqu+rWwBwHNg93JkwVkjTl/wmA/+HtlLnG4YTgbCC4Dav1yXOzd4LfalX3PS
	geq8Q4kENOfInic5/4Ga57q3Rz8cpK+p1f/Hrrhg466jUrT6A0drUlowdTLPOjfRd1gpmm
	Y77Q1g4IE0VyrmUBRu4ptQko3bk1VcztIUZn9nGmWxkdy5RlOeIAiSb6M9DKUA==
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Manuel Ebner <manuelebner@mailbox.org>
Subject: [PATCH v4 2/3] Documentation: RCU: adopt new coding style of type-aware kmalloc-family
Date: Wed, 29 Apr 2026 09:23:21 +0200
Message-ID: <20260429072320.310817-2-manuelebner@mailbox.org>
In-Reply-To: <20260429070759.309110-3-manuelebner@mailbox.org>
References: <20260429070759.309110-3-manuelebner@mailbox.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: tg8wij6mm8gp4fotxfs97s8xd5ophxue
X-MBO-RS-ID: 3f314db930c67e0afdf
X-Stat-Signature: cjr34b1s5zy15bffcpji7yfjybyptsia
X-Rspamd-Queue-Id: 1E201180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777447464-817407
X-HE-Meta: U2FsdGVkX1+z/usm6uN6tID/aK2eiiQOqmt5w4SSXAtayzaSBTmjD77VgrXd/QyejJ1I+yyEcgiODo3JlvATsvtv3bJq3P+fJ5I+R6R1+kTnf0D14Qe5Oy+4WbePgYIY3nXKmAwLxny+sLpmFQh3PQzCafrRsijliw6d4PvkbmFqxhqu3sjp2TzWFja0sKsiCwxhpwH+CCtbn9DByyrRPTZAf2pPrtRZED70w8jFlgUoGL6Io0Wm7h5X0D9PmgMqzHO7F4wa/qlMSsKG3RF1B6+bOePjvSpYfYEUoTcYcFsck6TotIfX3jG2B3lnwJe/6hgU9x5u/MD1h49//OAubR5QVvshtwAhXMNoXnqN1imCPAhy7beL1qxy/fOciiH20Spo1iLUwAJC5ywNJsoeAqCfpnp96PFuejd7xb49gdjvXgvIT9oC6zCKXW/VqEcdnUi8eMI8yC8qo3DJcfXKZe51iLO1o7Td/kCYEHNERieoVOFiwQ9KJGKj/u06Iuqvvo4b6p3eRETcwLtCszGRw97cZ5I6eWELHAbn+DK8V5yZ6domZ0B59iO+l41bKnQ//Dl61/Y8Po9YdMDM9et3LdNmC+MUT4hfS+0Z2UHMDQBk2w2v41kVL2OhuwMW75TlBuWKSrFqtxC8wlzprvIrOL1S04/sxGTDWoCg9wXrYX86wh5JBjGmQANPrSXaEhKZICLAWk2yD52uXRisBeOKJ92BSgT0LY0uCE/VFj28xROcDSb49AqR5VdVd2MpqH9CnyORwLpDSKdy/TXeMjyYMzvWLPKGS4ldd3EOIs4JBEVjQPJP1XP1bc+N/QmKBaFaTSU/gDiwlFQs1brzfVkcPU88ZEPJm5oUyPG0u79fKyy82n3RslLqkHun41I+N4l1IBECsHYyYP/dW8Skvs5w/7q+IH4cS1wwy9NGzEWlWc9Vj3n9XO62LhhWY07xZq3FUURzOH5HiIQluySxWZC
 Excngsts
 /j3NrU6j5HlWdUUzvqlvEqr9S5/62pwcbfgc7nJXwaaJPdyu1vqcQ/MAiPYndHiNcMqffbYdzcMLOPLoubigk0D4zqeDW9vqy2OSa3/bN5LlVDwkaN1sn7xAl+qrDEs4/6dSUxiXV/P0+JtMhc8y7dHF5W9ih94vhUHVpONQxb+DwspI3YnbnhWAKzF7vpuG5q2e1cijjW99f1vRY7G90tKxm7GnuLylebZ7b17PlOjxDkPpo7UEb2nvL5blsKajDhtc+veH3dwP3YjM8Mt6MB7FX4BGzTmOrJG6gAvXnbI1I5iOGhquHs9QvavBWORjr3xAh8+AXS6Qw8eE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update Documentation/RCU/* to reflect new type-aware kmalloc-family
as suggested in commit 2932ba8d9c99 ("slab: Introduce kmalloc_obj()
and family")

ptr = kmalloc(sizeof(*ptr), gfp);
 -> ptr = kmalloc_obj(*ptr);

Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
---
Acked-by see 
https://lore.kernel.org/linux-doc/7a49fee0-09c8-4a48-9506-d9172ef024b0@paulmck-laptop/

 Documentation/RCU/Design/Requirements/Requirements.rst | 6 +++---
 Documentation/RCU/listRCU.rst                          | 2 +-
 Documentation/RCU/whatisRCU.rst                        | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/RCU/Design/Requirements/Requirements.rst b/Documentation/RCU/Design/Requirements/Requirements.rst
index b5cdbba3ec2e..faca5a9c8c12 100644
--- a/Documentation/RCU/Design/Requirements/Requirements.rst
+++ b/Documentation/RCU/Design/Requirements/Requirements.rst
@@ -206,7 +206,7 @@ non-\ ``NULL``, locklessly accessing the ``->a`` and ``->b`` fields.
 
        1 bool add_gp_buggy(int a, int b)
        2 {
-       3   p = kmalloc(sizeof(*p), GFP_KERNEL);
+       3   p = kmalloc_obj(*p);
        4   if (!p)
        5     return -ENOMEM;
        6   spin_lock(&gp_lock);
@@ -228,7 +228,7 @@ their rights to reorder this code as follows:
 
        1 bool add_gp_buggy_optimized(int a, int b)
        2 {
-       3   p = kmalloc(sizeof(*p), GFP_KERNEL);
+       3   p = kmalloc_obj(*p);
        4   if (!p)
        5     return -ENOMEM;
        6   spin_lock(&gp_lock);
@@ -264,7 +264,7 @@ shows an example of insertion:
 
        1 bool add_gp(int a, int b)
        2 {
-       3   p = kmalloc(sizeof(*p), GFP_KERNEL);
+       3   p = kmalloc_obj(*p);
        4   if (!p)
        5     return -ENOMEM;
        6   spin_lock(&gp_lock);
diff --git a/Documentation/RCU/listRCU.rst b/Documentation/RCU/listRCU.rst
index d8bb98623c12..48c7272a4ccc 100644
--- a/Documentation/RCU/listRCU.rst
+++ b/Documentation/RCU/listRCU.rst
@@ -276,7 +276,7 @@ The RCU version of audit_upd_rule() is as follows::
 
 		list_for_each_entry(e, list, list) {
 			if (!audit_compare_rule(rule, &e->rule)) {
-				ne = kmalloc(sizeof(*entry), GFP_ATOMIC);
+				ne = kmalloc_obj(*entry, GFP_ATOMIC);
 				if (ne == NULL)
 					return -ENOMEM;
 				audit_copy_rule(&ne->rule, &e->rule);
diff --git a/Documentation/RCU/whatisRCU.rst b/Documentation/RCU/whatisRCU.rst
index a1582bd653d1..770aab8ea36a 100644
--- a/Documentation/RCU/whatisRCU.rst
+++ b/Documentation/RCU/whatisRCU.rst
@@ -468,7 +468,7 @@ uses of RCU may be found in listRCU.rst and NMI-RCU.rst.
 		struct foo *new_fp;
 		struct foo *old_fp;
 
-		new_fp = kmalloc(sizeof(*new_fp), GFP_KERNEL);
+		new_fp = kmalloc_obj(*new_fp);
 		spin_lock(&foo_mutex);
 		old_fp = rcu_dereference_protected(gbl_foo, lockdep_is_held(&foo_mutex));
 		*new_fp = *old_fp;
@@ -570,7 +570,7 @@ The foo_update_a() function might then be written as follows::
 		struct foo *new_fp;
 		struct foo *old_fp;
 
-		new_fp = kmalloc(sizeof(*new_fp), GFP_KERNEL);
+		new_fp = kmalloc_obj(*new_fp);
 		spin_lock(&foo_mutex);
 		old_fp = rcu_dereference_protected(gbl_foo, lockdep_is_held(&foo_mutex));
 		*new_fp = *old_fp;
-- 
2.53.0


