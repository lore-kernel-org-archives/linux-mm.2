Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA980FF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 05:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5E896B0005; Sat, 25 Apr 2026 01:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0EFD6B008A; Sat, 25 Apr 2026 01:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE7C6B008C; Sat, 25 Apr 2026 01:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE2D76B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 01:46:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 519728A6B2
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:46:55 +0000 (UTC)
X-FDA: 84695994390.27.574D2E7
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf08.hostedemail.com (Postfix) with ESMTP id 292AD160005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:46:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=GJ0XVQmP;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=uwnlv62W;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf08.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777096013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1U+Lzz1qrYnndGzgY0hK0tfu2XW3iifx6J3/jCY6ZA=;
	b=XaYu6/3x3T4RyKiqMb6jeTdVg/l1v3+uBBJU+gDByHgvrYMbxt+gPIgHlwah3bwXdT+ObL
	fYhJhVJ1hDaIcC35SGWgYW3A+oJlKKZPxNXGo1kMi4iB+BQeAAi4i6usx7dmeT9y/zM6Q+
	UDsJXGV2A3U3PioDKxVbDF1tsL2sVYs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777096013; a=rsa-sha256;
	cv=none;
	b=AWoHewqcAQRjg2asV34rLXK2BDxDW7q6egQMj+bZQ+0VMq0dBg0RgxDkEwfiU2VS7WZgJq
	BLPsv3TCgP2LhEeX035bZ08kjfqwcNEFR6C/Uhmi1GxzsvIuOUdggT8e7ZXUD9BGjKalNB
	mhfCZ4TKJUiE0JWyrsekKsnrDRn33Hc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=GJ0XVQmP;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=uwnlv62W;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf08.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4g2f3G1B5xz9tjB;
	Sat, 25 Apr 2026 07:46:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777096010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1U+Lzz1qrYnndGzgY0hK0tfu2XW3iifx6J3/jCY6ZA=;
	b=GJ0XVQmPVZ3C29V9VBzl1FqGS399NvjW9ZZ3Czra6gwGX4whf9zFV5hgdEw1oKpLtx2Vrv
	nOXr0u1WiFNxSOlWBJZkxz39rjVqiQyYtumwli3ddvkY4e0tWQCdzP5pzDJWY6DYwSJVhO
	fDs2HQ5eOXNs6kFxoluFlnI2S1htr6BcfNCCkhXPh6AbZ4uWMKZP2z8m9BmEQHUS3rbONy
	JKjGz2+vXemyfx8PL/YVHLryudAG4KWcs1jxi/BGdMG/88M9FlI/ataiI5t3HyGvJA906W
	P6ETUPC3HtEqGg0bc8v/W05+GnJWhyxaIWbLa/FiXFNjm2bcDj5KppO+lFSyzg==
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777096009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1U+Lzz1qrYnndGzgY0hK0tfu2XW3iifx6J3/jCY6ZA=;
	b=uwnlv62WEPzcPWrQ5ZoaPqt6xlfYJLtO8XDZ46qQf0Tp3LSBPrknlCmYXpVhTgI3EyUV5A
	lElEPJo0PzvigUjm/TwgKEgzqD4q7XAHeC3bvyy0YIZ30oeYz2i4yovhysO26IQ3JLUhhD
	kgTXPpAXchi2m+OmBWEvOk6ocrVn9lW9g42g4XmLzERtZXzCYpwCuTLu5b1E89WhOlo1LB
	9U1vE3A1PQ5VKeQd5194wA1rmfSojZpyB9TWxoezmi4J+Ex42PiXen/asjwsU3sbqSIAgE
	d5ycbOektijgf7+dIkUSkcFspf3q/6bUKhFzYos3cDwNIYKE3EJCc/AQdsQSyA==
To: manuelebner@mailbox.org,
	corbet@lwn.net
Cc: kees@kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	paulmck@kernel.org,
	rcu@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: [PATCH v3 2/3] Documentation: RCU: adopt new coding style of type-aware kmalloc-family
Date: Sat, 25 Apr 2026 07:46:31 +0200
Message-ID: <20260425054630.272707-2-manuelebner@mailbox.org>
In-Reply-To: <20260424175553.258412-3-manuelebner@mailbox.org>
References: <20260424175553.258412-3-manuelebner@mailbox.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: j4corux7dnuf8pgzx97gu3oi9rymqth4
X-MBO-RS-ID: 47ae089f101825f15ed
X-Rspam-User: 
X-Rspamd-Queue-Id: 292AD160005
X-Rspamd-Server: rspam04
X-Stat-Signature: dzjfzjpux3fnnc9fqd6moux7dxkqfnnd
X-HE-Tag: 1777096012-653006
X-HE-Meta: U2FsdGVkX1+0znI/6sczJl+NuwS6cDZAuzfl0V9d/288Zg9j7TD/01tYwpxLZWP8ji8FMdTwOSQJOU69cQe3AObr8AsFwAObkUtW52q1j/s506VQYN6bueiERP0XH6sWSlV2ascxTim1zGqu8CKnM4Mqel3HekxwBu66EtCCzSYHiumpYJVR9HH3lwokXcClYlJyzNxu/5YsERYqyWX9ap6nLyt4dw2L+jMsCZQic3ROcH+v3ZU0jlsQYaWczvgxlv1NmpalS2q8wS10nPypxjy/TcM+3xRSNfXaZR/FfrT5ZwrcEkZWOJhkSUb/dll7DinOsb+W0wvmCrKbK5v3YpnvF+g7+dvtdnf+H24C5e8UQz6NiJpPIIO9LTwi+phj69rkbaFdFHXu7P63HPmXawCa12+o8nftiyaB+0SVd7isURhSMiNF/xx5HTaYrYwfzmAD/uSEMW45X6SCeDSTuAr6MD/5cWbpoTVhSs+420cJOKg+BKpPFIGwHqIsK0aqxwxjVJz6vrrq3sO2oc+bmMMrYJv1HPvzFb19fqH/hNgwftmph98ySo/UrYq/hP9xYzSMsvVyVHlyCq6u1joS/3yee3nHSJQMMiim7XTrfG4TkbYM9noLEOEcA6axZCJjby1uowmPRNEaIyohhn83QkAwYSO1sN4OEVNUYRLjI8grd/LPRN06R4IDnHh2bEHBcExrYNUi6Wotnl8dG/GdfmgAttHrRH9GwVO3gnHje4eX1Kz/iBvSMq3JB9Bc0wUEyIqIgEQjRPZV16CSN2hkgxtxi+D7GnVxtpmLZKJYpKphJ0FLZ4Df7ogME353y98yZCy2A0nHbnFpmONzuimmdJlT0bSa5KKprw8ZlBYSTOjTfuQ+6AM0FvDB3Tmm0dwEXYn//udn/uuvAAk5rZ/Cpk8Fhv6EdNRpS5dwoFR/eWB+rZv7YJOI+OQgWBalVxKPTTgZHpoSXcqbfcRnV8D
 deejMwFK
 pjbT4PbfU5mEhOIaZygUP9AOMDRWqejr09MV7QP/R56iUg9Mkr4ZOlxZMP3Ra3WcWiWG/ZV6OCEsFJ+NiCXlW5kHgNx9hkPr/zeWVGMorlC5BhTkiRojGj1aPGuMwl4IPqoFwjyCFIwnmSFdRmOTkYa/lRYCKTBEhOpa/XL9r78GKJk/NbpI7nEupMCjSAMqCavt+7J9958B50lCE7s2u7Fa9zlHwpU6OEJzkSiP4DTpewkV3uHNUfSwhHFcHWifBJVdqvlKbjRnBoksYNYrrbvYDf+KLFuxO7K3YGra3Lzr1T70nWD0e7TrBdDkhIKTGS4pVOx4JWzVMKPU=
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
in the prior mail i forgot the e-mail address of Paul
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


