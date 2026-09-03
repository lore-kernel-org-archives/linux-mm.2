Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B01EC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ECD06B00AA; Thu,  3 Sep 2026 09:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29EB96B00AC; Thu,  3 Sep 2026 09:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B7B36B00AD; Thu,  3 Sep 2026 09:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E04976B00AA
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:38:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA1B81A0533
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:38:17 +0000 (UTC)
X-FDA: 85172555034.08.221EB0E
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf25.hostedemail.com (Postfix) with ESMTP id A67D6A0002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:38:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=l3w4IgOW;
	spf=pass (imf25.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788442696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fiWQq5+ihJfXwau/fHxalzj9WsMWUJ0C6TkAvMp/42s=;
	b=Q9gDkGX/+iROwZEBs+JPX/B46Xnj1sZMXCTgF7lftnNxwn5Cv9KKa7EosG3vc+OIGSqXjq
	3KD7kFyHGXmvIB5nTMifIcQZYMR5slusKSPuh+KJd5CSAgNceYnA1ZAwqmI50xCVUNCrPL
	KrADgPhGHeKXwFaQEN/1/aOK06bi1Fc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788442696;
	b=667hf6/DgApxeuE5qbRNrTwcTFHJ3feoFjvKMpFFZ1ndXli6Om8RbQ/n7yhzDGzzAC3cum
	xowkQNOBWypzXehifsnSrwt4Dngk5rrtPjYfhuIz3nZ9e76vr8k+pDM8NklKe32aJCVuT5
	rkNVL05Z8y5QqIvS35WpmAI4+FOezVs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=l3w4IgOW;
	spf=pass (imf25.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fiWQq5+ihJfXwau/fHxalzj9WsMWUJ0C6TkAvMp/42s=;
	b=l3w4IgOWPc8+ahx7EWh/E+tBVIL4lmWJdsQM+unCvia5mFwFmSn8FQmNfnyqzo6pthuO4fQL3
	Bmj8t/QIqO2pEVpQ5D39fStsRY1nmHyKog/ZrmUamS+2/OSzUTewwdLWGzylB/9a3ExM7VTCpMC
	dcAv2B8OawtchPBPvMUiYJE=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hbL403QLXz1prLc;
	Thu,  3 Sep 2026 21:27:12 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id E01AD40561;
	Thu,  3 Sep 2026 21:38:04 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 3 Sep
 2026 21:38:04 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH] xfs: fix NOFS state corruption in btree split worker
Date: Thu, 3 Sep 2026 21:37:56 +0800
Message-ID: <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A67D6A0002
X-Stat-Signature: etzrm8nu4di6dtqrizm4yaysmo34oc8s
X-HE-Tag: 1788442694-220617
X-HE-Meta: U2FsdGVkX18F46cmt4aCjbclSVZ5gR0eofbzWYbHOTREbnfQRVhKqmFTbGRdsvIx7i6XDKV0HuO24jf1otmMXMWeCcihH4S/NLY19LMcUSrUuu3S7PsweaO5/zznbZKKuHZYZy5F6LzkBfWG2DwRxq3R12s8CubHsnA0J72jTisdQ5hdAi6NDBsu97daMjBsZ2lcIsvwSGZXU1mn78wEtHGr1ucQ5NVeEFIBWyg4ghev524byH7s6DzmOy60YDB/rzMZZ30PkxEAiv3JugARDTSRUqVlgadGuuR7XcBNP9xBmfjrztji5Z2IBzde9HsJmWPvzH0ayyMHE+7ih8L9X1a8JwGxxMQbOuCNQqngqIbir+lGo2HReKvQ4fsmsEdzG9wnyh73ZZ78re3lI9JWSyZcPwVxhqwm0iQHC2ofH0H/wsmK4hX8+th0Sh/j0ghkC7FZ4gZ0U9f364ySmIWUnfu6ywGwvAADecycYiutqsl7wTraA/c8qS+YcgpR0ifMeQsWvyhueVDjV3b2v/oWT/I0o0Arx2uAXWkoUWoD1oXhxv9BvukNQddDlmHAIb2CDPY6ZLvliN+4e0XrMylJY1ycMKdOoGsxwlm3P+bP32sqp7HlD3GgGfR4aJnetRnBJ4T+947tGxFwTedQwaEBJwpGcAQabwrMQz6AVraS5UQ1rF77lVhKXIGXDFvypUYpa8jhG+mZrLxq8qA2hohvjeT8i46pV/zOZcXqUqrN3v319NmLjP8HEZivqkl0zuq/QgErerJAE/hlNj6nBRrJ81nF8xgZs2Mw9z3QlkgOu+JORt2xCi1aLWYmiATzcC54VT9nlBO2EPNRpB7ZTNj1eLPGMpmVEXMJcY/DSWhT62ojs8d7mLsmKkmwdsA7359l5Iy593va8FEn1J4gj7JjAj6bUhDlWeCXH9B4BqdMY24Gd2XwlEufGvjFDkyj6dR8S62cYyeZSzBjZ/8DRfd
 94HCVp7h
 Gzx8CGCp3rczrCIIilvkQOIf5cRj4ic8b6jgpiP62lWJk8izbtp28XqgaAuOZL/lqm+XBa7u96F912SWuLtQBBgyl7dFCmPWlN5f+gVVlCKH/C4rJtMPi4gM80eU5Y3HrLnaYVTWZ/3CTqc3sYybV63B+bXKg+aAi+Pk4oIcIMSUToeGtlPQUvM6jnnTx0OhirD1HOh6SLW5wofU55woIAIdIl3QheIj6Z+uCGasaVdhMYXD4FzEpKFBJK6DE6XwcniMvljS+SED31RqkzbzhCiZHKyXEP0tDN+Vv54tWwa3fVGjXZnEbycojnU+AK4yd/bTlc1Rp30FF94sh1vDFGBx/va04OQXrcYHC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xfs_btree_split_worker() calls xfs_trans_set_context() and
xfs_trans_clear_context() on the caller's transaction, overwriting
tp->t_pflags with the worker's NOFS state. When the caller already has
PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
the caller's NOFS protection.

Use memalloc_nofs_save/restore with a local variable instead so
tp->t_pflags is never touched.

Closes: https://sashiko.dev/#/patchset/20260902131653.1338227-1-wangkefeng.wang@huawei.com
Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting transaction recursion")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 fs/xfs/libxfs/xfs_btree.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 6738d9d1511b..8ae4b94e6995 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3007,12 +3007,18 @@ xfs_btree_split_worker(
 {
 	struct xfs_btree_split_args	*args = container_of(work,
 						struct xfs_btree_split_args, work);
-	xfs_trans_set_context(args->cur->bc_tp);
+	unsigned int			nofs_flags;
+
+	/*
+	 * Don't use xfs_trans_set_context() here: it would overwrite the
+	 * caller's saved NOFS state in tp->t_pflags.  Use a local scope.
+	 */
+	nofs_flags = memalloc_nofs_save();
 
 	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
 					 args->key, args->curp, args->stat);
 
-	xfs_trans_clear_context(args->cur->bc_tp);
+	memalloc_nofs_restore(nofs_flags);
 
 	/*
 	 * Do not access args after complete() has run here. We don't own args
-- 
2.55.0


