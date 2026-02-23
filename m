Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02553E98DF3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D496B0089; Mon, 23 Feb 2026 02:34:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C84F6B008A; Mon, 23 Feb 2026 02:34:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4080D6B008C; Mon, 23 Feb 2026 02:34:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8686B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:34:28 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DEC2913BC0A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:34:27 +0000 (UTC)
X-FDA: 84474908574.08.CE9051F
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf06.hostedemail.com (Postfix) with ESMTP id 23D13180004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:34:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LgAriT2M;
	spf=pass (imf06.hostedemail.com: domain of 3AAOcaQsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3AAOcaQsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771832066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTzyqQEPt79Zpwhd6jWg3UfI8Z+bf/09VsUr7zJytLU=;
	b=Ft96RDTX2wtYjzAAtFdaqsrcKEbzz/LiaMs+8u6p/HgUx+dsVZT2gjTWLcMXXfSeWjNto5
	I/4PGHvOpZH1LG9EhMnrIJwxgYT+14onviwhIanbr1b0yL8DZ9K6TjmCUWBy5H2JJXk07Z
	hDTIP8aDLeMMZTWRbDebQjjzyMQpELs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LgAriT2M;
	spf=pass (imf06.hostedemail.com: domain of 3AAOcaQsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3AAOcaQsKCMkprzt60tD82vv33v0t.r310x29C-11zAprz.36v@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771832066; a=rsa-sha256;
	cv=none;
	b=UI5sKcyn8TWFGbZG8bDRHm/YRdjQ8Wbm+qoXKtCj6Wu2JYBkdPzyBLUUg8LOLwkLA7Rzdh
	3UHDe4qnfZte0c/5HrG1GrmU/y45TS7Yx+k0qGZddAN7zT1QfccCB3B2hkL0I7CZgecHWW
	2YY4EB9+z2+jPg+ets/vo4kJS5QuIyA=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6fd07933aaso2450769a12.0
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771832065; x=1772436865; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sTzyqQEPt79Zpwhd6jWg3UfI8Z+bf/09VsUr7zJytLU=;
        b=LgAriT2MgEsZV1gk9lAqgSVH/RUyZjq5Tpc2cY0R3PzXnyJaxqLr9UmcGVYA4WP1x0
         SNn0TjeYepIzl4UuNhd/G7VTl0icj+RpI3XZ1+EPCMkB9E1zsw5LBPtFPe8BTjR93hmL
         xIwJvHu9fEXjNou6DAFQ6MmQENQ1AUi3B0qLWlk7TQZsnNVNpssCsTKojjsTMRuPbPY1
         tY6YV3WBNZTf5W6myG4jtgdwuRRDZGyoUMSjtqu5J2OAc9o4Q+sw17n1B+/V1wn8UuUz
         LQX478B487iS8mMuz0SsJofmGiTpFENqc8n0h5znaZTsKK+aBqt74HlxLqdKuPFZJH50
         x+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771832065; x=1772436865;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sTzyqQEPt79Zpwhd6jWg3UfI8Z+bf/09VsUr7zJytLU=;
        b=Vww0bFfBNx2gDGsFIZL93lxXHHuyEN+LGXsguzk/i30i4rUEIU4s7R6csYf/+xCMj3
         yv3btQetmBKUpkThbTQJ/k/iQlrtddw4mACxiyDQZTUoKdHkKDVU25c4/0tlNTpQxoXD
         9vNYKR7if5f+nOU0SsUMNFF2d/427MJHYgSfuz/FzmHLXsPdWHnUVrNPOC49b4JthGQ1
         4TGEmaVJqtx1sUkE+Ns6QGSQfF8sDTxNnlThs3iPDLopo5PZ5LAojbur/gVu+IpJisNw
         rkHtzYq8W80cQ5ME5rgiLAvGAfz2YTPatoUdjIZUmWe3HmGRQQbPugV2hJogSPxK/A3K
         QAfg==
X-Forwarded-Encrypted: i=1; AJvYcCXPuz1EpSEEtuq3grPy8NspE9sE1/QGeVt2lYtIYnnTSMistObw/YzG8Gc187FwI7pguPpZjas1FA==@kvack.org
X-Gm-Message-State: AOJu0YzFsS0/I0DyTV+pfEShfzXuXnTRQ1ZK6z9xUk08Mx/TUQyWQ4Ii
	1bTvMXPnUGz8lPjegFxq0Gy2nsU3r+eqoabNCGLrqwFfmjWPo3oRy/1vbujTXOYjhW1njKzPjsv
	f8PiIvPdkqSHIfSonTYaRXVpnBQ==
X-Received: from pfbdo13.prod.google.com ([2002:a05:6a00:4a0d:b0:824:b4f6:5f0d])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1495:b0:81e:c67a:1a79 with SMTP id d2e1a72fcca58-826da9079e7mr6244452b3a.25.1771832064755;
 Sun, 22 Feb 2026 23:34:24 -0800 (PST)
Date: Mon, 23 Feb 2026 07:34:13 +0000
In-Reply-To: <cover.1771831836.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771831836.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <3d698e6fcf052628629d9bd928fcef5fea049a76.1771831836.git.ackerleytng@google.com>
Subject: [RFC PATCH v3 1/2] XArray tests: Fix check_split tests to store correctly
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@kernel.org, michael.roth@amd.com, dev.jain@arm.com, 
	vannapurve@google.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 23D13180004
X-Stat-Signature: fr5r9g7ib7whqun744hdhxt3drwr99cf
X-Rspam-User: 
X-HE-Tag: 1771832065-385702
X-HE-Meta: U2FsdGVkX18BAw15fZQYfz+XQCINm+5XSH9JeAEzUMT1P+Ji0/gQxUn/RCV2sxRFZcMAsvedRYxQXIm8k1nOiakC8MPeuOJ0wskXLgbQ4vFs7By9Zwz2cyDpGYW6Ff7fjLCMZjJza9dYiXakpV3A0j+Jfehu4LxdPmoJwfamybL3yy7LaKYF82m/Xoj39t0d+ob86qPipW21v74t3Zjjh6ZmYace7fCLSBBbTapVsJdWHAebaedgyO+cLKcYMmy76/UrS7l5ntJQnbAxzyhWlMdlw1AjOS5WO5fckHCcNT6HYWuGSy4FwKDTD8DC+f1MMpiNii7plehi9UrUk2l9zjJnLULx7qgTpXjZawEybLAPZRMcyMO80Q3GZghqQFMXizw+pXfKV0O9wJLC+KPSe/C/Wl6n7YcuqGUvEXrkOyqdAyfxXnLyUWErYhofZphnaAZSPLs9Ji6b4OcOefpbTpvny5TnQ/e8+NynrdSb1yHNPTHQ/MHutPTOutkAYxs/fokfHM48WKwYpz0yuJmA8u90+Np6ZBKwG1idlmbGeh8U6vtvfr+FDeA2XGxwFpTV8Zq4tQKAxrUb/cBgdZnoAcG2S1mmENlCzmE2bD4diBlmuTtQbGa0dShdhzjAP6tjNg1oWRws16DSOb34hfpNRaHAGyx/e+CDzYSnCo8CPaZskyLATSO4EVk2bp5mVc4HxHmczDCr9npnYsevwr2c9tA1PNfApS7wAp1mDc5q/YiSJ285dZHCe3wepRax6DixCH7FLL4oVmS3NI6cqmYha6jTfF3tmBEWm6rIZxm7sGXIDAgyHRe50xQTLfZtQ0MWp52DP2zcf9N4JZgajWsyRZtH5HpkKi1gOvQlnpzfLnYeQqh6T1KNQ4RW3QfnoSZiHj0IxydrNFUOMUFt+TDgMKSjV1dvare9nq8GXIOZzXTXb+DwvfpMytqG/LlXRrWnKLge5iEewsSxBYIc+MH
 2eghAf/l
 5U6G3Y4baP1g/3M5+SS3QDE7oVMGLNO205VRfoRm8KalFtJC4ukeNtXYmfqyJs+9PNSYwSYRuUklhamh0G0e+lllBLOsTSxeI8OQipowvPyxybCtFwXQF6jBm4A3dFIwhF4Tx1/T5p7G4VBAu6+sho2Cv5RMWSnJjirTXdeZjlfCDxNYxshoSrMJi4nQxKCHXLCXKJ4oBYWO96tOf2dNuPfIFgixxV4YlH+pruaWeP/YBV2/1QIcnH5/2kNLRYGiIJmyF7ehupf+RpnGZ8yTGUmBMd9Ao/OQnis24qge71GTPfk7J6BS433HvW5PqTqIOYKiLdcfRZAGkgNgc0GDahvinxsyvgVq3HRzrzyXm6PcnQzXd7q5G3HM4thIaMYHV2EtEiq5CQV0FdzDZru13MaTjH5E/OWYF6dWhlUMYbGaLHXpyAkfAoSCw9p9fqgNPm+1WSxx1sjgDVzJ47hSzxT+RxpQBEeJxjZ6AytWFWIWlIIP1B7hyAdrd6jZhps88jMcar9DfbzP4r7vTEtdpjj6pBuPOfwHksS1CNr0y/O+qe/HayXJpmDlu6E9U4RF9JwjMniq4Z7Y+8jyjmTETvilKj05A64xQm0MB9HQJXwXEkzkxPmE6utYThi4onqExkZUFGrRywnislP3qFdgS1UMHS4jJ/aTGvdSb7iQfZXO/YNA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__xa_store() does not set up xas->xa_sibs, and when it calls xas_store(),
xas_store() stops prematurely and does not update node->nr_values to count
all values and siblings. Hence, when working with multi-index XArrays,
__xa_store() cannot be used.

Fix tests by calling xas_store() directly with xas->xa_sibs correctly set
up.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 lib/test_xarray.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 5ca0aefee9aa5..e71e8ff76900b 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1846,8 +1846,14 @@ static void check_split_1(struct xarray *xa, unsigned long index,
 	xas_split_alloc(&xas, xa, order, GFP_KERNEL);
 	xas_lock(&xas);
 	xas_split(&xas, xa, order);
-	for (i = 0; i < (1 << order); i += (1 << new_order))
-		__xa_store(xa, index + i, xa_mk_index(index + i), 0);
+	for (i = 0; i < (1 << order); i += (1 << new_order)) {
+		xas_set_order(&xas, index + i, new_order);
+		/*
+		 * Don't worry about -ENOMEM, xas_split_alloc() and
+		 * xas_split() ensures that all nodes are allocated.
+		 */
+		xas_store(&xas, xa_mk_index(index + i));
+	}
 	xas_unlock(&xas);
 
 	for (i = 0; i < (1 << order); i++) {
@@ -1893,8 +1899,14 @@ static void check_split_2(struct xarray *xa, unsigned long index,
 		xas_unlock(&xas);
 		goto out;
 	}
-	for (i = 0; i < (1 << order); i += (1 << new_order))
-		__xa_store(xa, index + i, xa_mk_index(index + i), 0);
+	for (i = 0; i < (1 << order); i += (1 << new_order)) {
+		xas_set_order(&xas, index + i, new_order);
+		/*
+		 * Don't worry about -ENOMEM, xas_split_alloc() and
+		 * xas_split() ensures that all nodes are allocated.
+		 */
+		xas_store(&xas, xa_mk_index(index + i));
+	}
 	xas_unlock(&xas);
 
 	for (i = 0; i < (1 << order); i++) {
-- 
2.53.0.345.g96ddfc5eaa-goog


