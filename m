Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE276FED3E6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE10C6B0005; Fri, 24 Apr 2026 13:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7766B008C; Fri, 24 Apr 2026 13:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCCDA6B0092; Fri, 24 Apr 2026 13:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDD136B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:57:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AAF289872
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:57:28 +0000 (UTC)
X-FDA: 84694206576.06.C11DBAD
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42392140003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:57:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=DiQX2jKS;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b="yZIE/V/i";
	spf=pass (imf23.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777053446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jpFSfh8pkq9hgF4XdFn4gci7nJHZiQrNi+Cn4q3ldM=;
	b=URAu2rQvKhrszml/3F5srW5Dn6n6gpU1MpLkRGb/OY/pf/Dbf13PfyIsLJDYv+NhHlxnb8
	tNa4Ys2UsrYrRhbvUH6oU0K26qfGkXoVN9Vcj27WAnJ6JsytmEET9fixQhCb+/1vlxgSY7
	BbGj8q/ViP9lnSNHGk+6bz6qDVLoKJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777053446; a=rsa-sha256;
	cv=none;
	b=qIu3qOBqxhFmEV2BcF8tkxOYca+l5EiGDP6JyosmyX34PaFNQ+0odlYA80FIAXZgM29+Ys
	U5C/LlyPKnUxKJjQuWejujNUZytquMl4KZkQcz8Y9F90MaxXs+BQ0S49PA4BMCi3FQTPsO
	ekKNmX1qegPO8QkJRSCKouvVundTcjM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=DiQX2jKS;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b="yZIE/V/i";
	spf=pass (imf23.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4g2LJh3bK2z9v09;
	Fri, 24 Apr 2026 19:57:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777053444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jpFSfh8pkq9hgF4XdFn4gci7nJHZiQrNi+Cn4q3ldM=;
	b=DiQX2jKScEebIIsItGKvTu8w4TlEZEK5EJ1cxL3qtrx+u+a2HefIH/spvYOFb3vBGn0jFu
	b/yzMeqBhVwiTKCybbQgn3Xc8l3pEuk13jJfhasxbf8PVZzr8Igz9hONffM29xo2Ie+PkR
	DdRAxJC6yaGuDVmK7S4+R8DzzrAlGpT2Es9hCmvf4HCd9Mo9OFlAXUXmwUXgM2uuIUMZNQ
	GqrhqgRi5dqkC3V4fxxAZnevI3pZU93YyALt/u2DI5yA8yY00XAVuEHZ8vQuuMdmZlJ3JM
	pSVedQGOW3NtKUWCeErAVWrABI1acLwhtk2tsZLdRqtRGjNjnGKxb12NZCwUcQ==
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777053442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jpFSfh8pkq9hgF4XdFn4gci7nJHZiQrNi+Cn4q3ldM=;
	b=yZIE/V/ioNkek2NIKv9qymxY2/zs5EY/Ens7Jn/IXiZgh3TbOvxIxXBNGpKIXLyDrYh4Nw
	8fNtIgEqZ14LnwpG7p0lznCpCw0mXseRzZQfhCtA725d1PdsoG85VUolU5JxlU2JceNoRy
	Z0mDPkaFsDne21Vn9hovQA0x2+0b9NhmnbvPa6cGHdCeEZGOCZcoFhry4ivyOyoqEXVXzT
	prwMsZYhvlDV3R8HzoEV3LrAxPpqf0DsNRU+D6nGHlL4QhMNKwaG4zFbUj6yRUXGsPntwt
	YGOi6b/yyOVxTXdmqLG6lIUCNYzSknnJG9WTGAQ+orcXjeZyghqfEKCUlNJscw==
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Manuel Ebner <manuelebner@mailbox.org>
Subject: [PATCH v3 2/3] Documentation: RCU: adopt new coding style of type-aware kmalloc-family
Date: Fri, 24 Apr 2026 19:55:55 +0200
Message-ID: <20260424175553.258412-3-manuelebner@mailbox.org>
In-Reply-To: <20260424174743.257951-2-manuelebner@mailbox.org>
References: <20260424174743.257951-2-manuelebner@mailbox.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: e0518762b50c9cfe4f5
X-MBO-RS-META: fexjjn3ftc9wehobct5zrowsq8uu389o
X-Rspamd-Queue-Id: 42392140003
X-Rspamd-Server: rspam07
X-Stat-Signature: onnxtp43ckaxmwoohkmb4hkf4c1qdtku
X-Rspam-User: 
X-HE-Tag: 1777053446-130690
X-HE-Meta: U2FsdGVkX1/aZKfoEkTPVth/RAM0LfS2m/ekhvtsoDiR6R9QZ4yoFSKgKmwRx4Y6ledw0UAslV0GCj5Kl0QewF4BQaT3TJogcDtsvHJtIHbyk1r3beHCll1Z8InZjGhfcEiGuZA158LtwphvuXb9EPexlTfhx0vTC3K7IBggcrORHNd4udAQyHVBWeE1b8A2yl1EmVvjuiAuSoYrczuRQXjvTY4p1ySldd7fxRE5/oVEh1WPkQfmnf/LyUYOpKvp4/pDiEM6gqNamZf7WCASQADAd9ZMOV3JfDtRW1BYYmKGV3epyMcnFvNAGDkOxmQioIeV+5VhqEz/rhCLDTg/+mR63U7TdH77lWMtIBM0+69oAsyZCAipIyRzVRB9HenjDXKYfCfUT8DL65qK5jk9g6zjR+skrRnNRI3mELq4nEpr9i4RyAAZwc4XM0dbvnnmcQryPlgKB3dhIgob3rbzY+1ISQ7ZwJiEOMbga99U9SsjuTIcKv6PgPHk5Ho6StW5qCynXecYDev9YA3MkCQAACev0m1n5Q+iwldmga3wY0iopyfjr3nvyWxAuY4tDs/UmaZiAotkD8hkIMHXSfrke0bT4Q0DTrV5Xxr4H1/OAVYcVuiDFfjHV5ZK42twNS3XtBdYhrsCudh49tt4h4EGGFm6W+93BxAn4FgWWkHfQSdxXSNOYIiN4Hg45QT1sGXWk0Gp1QjyuwffPUif6hseBeFGd6C1zfymOcOFrGHhLTCtb21KvXud4cA1OzXMh/3bRBu8SPR9foGhm8SNyRp4QCuvCUcWWWgOO6PIgBCnqvYLkHQsA6zd+6pCOodaR9YjiXe8Orsq59rYy1kI2G0rRPwh3HhoUfuia7acR42AOHSIQ3WXZh5gDZ/jopz7jIBH1WkaB9jAVB7ZhcShtDt2ozI1xtqxSwVdIPr+ePsxab31rwObQO2LvAUAGg0tet9lVkP6pYEyIV4ysgJ1nNy
 BZk5cGZ9
 oEx5+XKWrOlM41XGn6z8VCgplUZlbQp/RMANe9xzGqAuna6UKXu1MricoF62f0d+yz0kkfKCI7q6PMyXNhbDuz5iZOzPe2x0mby5CC3f2H5lmYTlNLFtekG1fFNmwgEkl20QKRnK9+H9Jj5zjvojVvYZoQSNj+tWJiIWy4f1bN/77fm/EN+yr6JGjxfXm4teafkp8Nj7PpBGU3zqUanll0YMjjGqmXKkh0qvkAyvlBG4ICb+8PYtDIPOloTufBSbpTtYMcdtoXvidCYfAlrcg1TMHy5ssKUBoAoSiCXHUmkdJOJ8b6dn9B2GAOtr8oE+wFkMzz+PF88De6W8=
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
Acked-by: Paul E. McKenney
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


