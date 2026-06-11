Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97DA8CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61C506B00A0; Thu, 11 Jun 2026 13:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5810D6B00AB; Thu, 11 Jun 2026 13:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25CA6B00AC; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0976B00A6
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3ECC891159
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:29 +0000 (UTC)
X-FDA: 84868280658.17.33CC1A5
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 943D61C0008
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=IHrrkH4u;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781198067;
	b=oMHUN7Beu48b7RSlUQQikzakxqwNWFl6yf962hYGEQ2uD7JarQwk3F9AZrqs2OC9bLOYKJ
	9rjynI1mNqXbAYUcKb2k7/V6yZg1ftrBdi4cKmFiqrmuVNLUkomw+OB7pjLkFvEvDNQpcA
	jEnLo0U0SZBd1cdoQ4GNXI/3rSZ1Gz0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=IHrrkH4u;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781198067;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6f3OoggzlPIzKQe/th8iqmFArhYwFRFyJgw+Gf2/5vg=;
	b=MH/TlxJ92Iup4OxHbamxafUhJiIuAt+QGqLE097bnwbFm7K4JNT6yNKXPsfnAAtsXNv9RU
	xN6SngWgtYGrT6edYapblxlSj42K7haClsr/mOMHA6szZmnCo5OfkrJRj/oFvpArNmCgTH
	osAOONp32nWv8Eb1AWdXq5d8Zkt+NLg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6f3OoggzlPIzKQe/th8iqmFArhYwFRFyJgw+Gf2/5vg=; b=IHrrkH4ucrsE/zwv9FmFb5rN8d
	KyDGjDcM3kNIF+bPDv/68AkYO1QJ+g5LmXcANlfAzq6rjbqq6bLzb5+odtbSuNOg26vFDIflJJkgF
	a+RUra/3ewvu8dzDl8J0gsazEfu7bhAa74kt1LU8CezmufSn+iFTiCY7Z5s4CynbaQ8IZCaSfFNii
	XSTSevQIEmHrjRtRb2HDgikC+QRlI8xBcl8U5m6lx+v80icI8p3jQg+GMXB7Y0csuA86SbQmSlvxa
	GnODq4cM7Wg/HHNy97u1Q4DKuviS1iGSTVyCiCzPcLffyHgC09/kLXjwpS2KB10mSgL+a2Wh0qHhC
	iF1L8ytA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wXiz4-000000070mf-0hpl;
	Thu, 11 Jun 2026 17:14:26 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/9] make inode_cache statically allocated
Date: Thu, 11 Jun 2026 18:14:19 +0100
Message-ID: <20260611171425.1671254-5-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
References: <20260611171309.GN2636677@ZenIV>
 <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 943D61C0008
X-Stat-Signature: 9yg4cd7twinap63xc3j6spntanpf1j6m
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781198067-40628
X-HE-Meta: U2FsdGVkX1+DphceJPsUiqMUqIeKkgGmwJJXniNEs1pnAwh55S31h3gwaKlGiFlXwn6694z0nyc8zTuXacVLCxDbZaNoV3zw7fsFMGNqICFRGQdZ+Penp0bVVZAUIO/tC5Vm1qsTdz0XbYmOaAyMItul+9QoclnuUP1QvlPHE5XMbT8LCzhdwi01suZeEw19tU/eGRpy4ny+jU/3aZjIeLPPl8oIlNTRBi+xqG/PjSiPrrtmNtlWkd22Pha2LB2Vs1DX5xpy7mTVicMV55lG8TlMHK6b1z3kRruhOnpMm8Vt6UuDfg9D5kifG4QF/38sgnD8unUQ4mNthFZp9bRzjzeQn+I5g8bjUC9vfDB75EENto3hjqKYr+/FgPHCG/Q4aPkfM4ditmFGL90wN8zjN1584l//PyyfWc7k7VWoVM0507WBMbcDDyW51EVWkgvbRHzmN5SB6CIlVzlgnbIxvyUvuyYz8YJbegrtUosbMl2RnDBK6XuYsALQZdlXrKtzvDg3Y4Fh1Iiqonmi6cH9zNn7diOim4zKmrPJjvt5Xg7ckJmA6HN+ei3f4zEXQYsrByuzpJ/pAQjChsARPt6D6FDq1TfGnH1trVvn5Ts1OT1NLuD79yPWVBy1OjcdpOjvwT2mcjudqa6HaGLz6jc1UtXsYXav4vJvTLyBLkffMu/fMygVwIggfi9bM5wqZxTWmh+JaAFwLzNgpwKxfzHYLd1/2VlzPj15oS6at/x6hWKsDff2S5oTVakmYeW3lfrmRxymWyGnfqvuNMforH5ir0aiOWCji0/m3YK/0qmRTgkze7A24JVqMOtki48FDxQdSvTX0idVZjvkvtvui3yAHRs1M6V1N6pk1wrcIWzbDx2YC/8T/F+EveGnmL7+psto9HgkK0lAiiuqk7J0ITCoSWaSyxg0AfGik4wGxjxiyx2R8VbqxAMYF4bv2F663AwdUbW9uN/GovteLTKuVkC
 2jX9O/Wz
 zqoZU50gsViSbWrx8tqa+aNPTIzNVX7QFLpT9Pg8MC4urzMDiVnEcSN/IH6zABIlDaplZjzfqZVWCHQJ5ZEN4azcp8/KM8HX+7Uj1M24iOS7j12ufTVQ/Jy7ZMiI3LizgjOb3KBAmDDcmDAgMiPdWJuW7JPCthsOEMPX2aS0XZeBSiwkBZnjC6kLzJHz8SBh9GIwahsFMiyixDuIn6nktw+qysbnhIpu7TA8xXsnY2v605glTrt8iJQv0HA4jnLL1ocTB3nw5oRUEfynKR7TyntqZ/z2csviW9kK7Uu1SXgc30p1HPzTmak2jfQIgi/561ECnCg6v8PZF9ieqvHqAeFLBafBxkEahWR50QxMzr9ZGGqb0gc/BVrJ7RmNFMvQ8RRSHdGUv/lrkZWAGB5ErGjWITyzeJCGC6cJFMl4X+QkwpYuQ1n5FRqPlwEKtWK4Cc0foAe9m9G5WF/T2jA+xmMCNQSMjFc4rzmBNjoErCLAWWXKQQByp0CFvvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 62c579a0cf7d..1c657ac99084 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -23,6 +23,7 @@
 #include <linux/rw_hint.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/slab-static.h>
 #include <trace/events/writeback.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/timestamp.h>
@@ -76,7 +77,8 @@ EXPORT_SYMBOL(empty_aops);
 static DEFINE_PER_CPU(unsigned long, nr_inodes);
 static DEFINE_PER_CPU(unsigned long, nr_unused);
 
-static struct kmem_cache *inode_cachep __ro_after_init;
+static struct kmem_cache_opaque inode_cache;
+#define inode_cachep to_kmem_cache(&inode_cache)
 
 static long get_nr_inodes(void)
 {
@@ -2598,7 +2600,7 @@ void __init inode_init_early(void)
 void __init inode_init(void)
 {
 	/* inode slab cache */
-	inode_cachep = kmem_cache_create("inode_cache",
+	kmem_cache_setup(inode_cachep, "inode_cache",
 					 sizeof(struct inode),
 					 0,
 					 (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
-- 
2.47.3


