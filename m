Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0829EC98311
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 22:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D2446B008A; Wed, 23 Sep 2026 18:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306716B008C; Wed, 23 Sep 2026 18:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F56F6B0092; Wed, 23 Sep 2026 18:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB2A56B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:44:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BD7EA0170
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:44:25 +0000 (UTC)
X-FDA: 85246507290.08.7FD2EAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E2724A0006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:44:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TLDWEyiH;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790203463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCYcL1R5NicLL/NhwgzYeBgYTteRbyS24vJmmzlRDaw=;
	b=z8o5lSNqEk68TjZAJGPzta8CWxQVZXcDdU3s5S/v5Mpw7jf6g2sgE01nfLc/FFg9/41B6i
	g1yuhgMySdEe4O2WTJWH3Wr/6cENqFbldruefm6aKLYdkHyB5UpZMgO76cl69EoK+0SXQJ
	3H5azks6v4dwYfOjCaEJPxaZknARlWY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TLDWEyiH;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790203463;
	b=W/aIRaYFsRCF7WQMeqNdwndDkJv0HRFdxPihMMBh7JkK0j3cIXaZSVLzRW9M39EEZh5nFT
	ncBqfwy2H9Y+/ZKF8ZYyQvere0IH0i4M8yyq9a71Cn4v0SqZpq2RiKGtaQN+uroADtGmFK
	i7okStglCfy1yN6kmiV7+2BPYikKhp4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A22B360209;
	Wed, 23 Sep 2026 22:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117221F00893;
	Wed, 23 Sep 2026 22:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790203462;
	bh=XCYcL1R5NicLL/NhwgzYeBgYTteRbyS24vJmmzlRDaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLDWEyiH4tsSHQ5jJ4W2INbg6NtCw24Nd55zZ1YffQlaEZPAogYwjP2a/jc2DrkPj
	 fXfbbY0AbOWflZJduor+NXDIF6D+FNeJF7fl8dSS/E5uP0Qr0d96bjebpX+f4ESMn/
	 iPGrG7bYGtfPO3T4UR+BK/3sz9bYHuMUdh/5T7cjpw4U7scGJJsTDgxf2jodSDjEoI
	 sKzZnyHAKe6jGpPk8E3MGJqmqx+C5rJILC4+9pbw+A1ID0OAaQjT1kgvaS4YzT/Y1G
	 pojgEXXMxey8NvFAyaDGkdrYwSbl0qyYLPQj7yrknb+ildxh1CLxjM3OlCEiyPkYsh
	 qIjtHZqFGtM2Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Matlack <dmatlack@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/6] liveupdate: luo_file: look up outgoing tokens by id
Date: Thu, 24 Sep 2026 00:44:00 +0200
Message-ID: <20260923224408.3745689-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.rc1.310.g51773c2048-goog
In-Reply-To: <20260923224408.3745689-1-pratyush@kernel.org>
References: <20260923224408.3745689-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E2724A0006
X-Rspam-User: 
X-Stat-Signature: zsma1qz5gdth16f4d9f4q36do45bc6rr
X-HE-Tag: 1790203463-888651
X-HE-Meta: U2FsdGVkX19S34gVNdZWSaQi2l1SbeH/3LcRXUEM8MO1OeN3couUJI4WWkVS1DaVLMiJdXmjeCzuoVM/FEwPDHLDO/arQxoYoBxubLWVWchLoFIz9yK0yKEMdlkT0/T9Lkh9ZVIT4fK3/stA0QSeNtr6QqlhN7hnX6Mvgd7tZhKHr5JQtLEJOg49wRGeOH/c6jzJoE8uyyK3yVdeCaguDrYDOypdz6MBeQZ5vwrZ69bMWrXhdokHtNjWRlk3g8k3nQXrg6DpanE9E1rvhb3WsHfZYr4ZKBp8JOSEivPA5ZN1Gs6JdIXE2e5DNQGD9z4drH6BqC6KYE5Ef1TIG72uJ4yN+WwOKTH/VnTHxQAy+peCqCVtSZ5QTsCmWgaPWJGUBWTCXO98XvnbdELIQ59wOArohhqBTr+Naj/M3cZlCTW1Uz0mNj38eq4tBDimFe5cujcHdFtF4y/7pa1A9Ht3Fotdz7q2MGCkDlUc/Mptd40Ib9Mhl+yJB5kjeC8Kg1xAL88/5YnmlzHeTPaVw/txcaW9CGMLHCxO7URdoaC3lw0kmMi5KiTsluwD7HSkU8t4xh4Zf0sbNk3p3Ob9YF9KY1fZt12Qo7LL7g5XeNZwwHYZrDbbXBim1udyM6uVyxNPDJl+V2s9JTHtWRGcmEij7AIzRm90PeDs0QGSg38r5higcpHyQ0bIo7+B8xGAIYoyoT+t/DP5Yso8vmnKWkJytoKxUEr1BxE1CekO1hZ4sWqNHpYtg3GwV6cBHaOmvtOkEesoYd/CHd/R/fNzD2Z6MKj80FZXNitd9Z7x312XJ2hPz+hw5iu17QaWox5MEAMdZVCocvUhxoY6+J0m2VI1RnpZo/Ll6dVf1XKUEnN4nfrFiD823dKtgqC8J6sdUcyZfd1+s7PTnGNN2f7aOjhHlLOjMX4CWhLfXz3wq11xMHKymyJdopLd36rNrUuFsXChE6o4OgwLIdMakj25R29
 Rk2dwvux
 bTXwSg3rQdAgtidgxrWog5WlgHbm8uF/pbG6MvMS3B3OxLcotHEnmmmJfwygzLpFPAbuSFdRystFtRZX0Qgue46cERblmNuCKctJGV/IGX7NFwv4TqvBTHIVYhRitWhlKqYuF7X1yXBbvfy+pCd/VawqtheZNBa6d2CEo+x19qjc6A8dwXfjm300OV+memAwra+oYNMVvSXONvyRiDSaJzi/XQ/rZGp5Lpr3GDpxPXigrOIOP1fFKUvwCw2f+JHjVxWdTLwTLT5gK8WGkfERGTh9p+fuAis5cveSx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

liveupdate_get_token_outgoing() is used to look up tokens of
dependencies. It does the search based on struct file. LUO preserves
resources; the files are only handles to those resources.

LUO provides file handlers a ->get_id() callback that can return the
unique identifier of a resource. LUO uses it to ensure the same resource
can't be preserved twice if it can be referred to by multiple files. The
default ID is the struct file, but file handlers can implement the
callback and return something else. For example, memfd returns the inode
of the file, not the struct file itself.

Use ID to look up dependencies in liveupdate_get_token_outgoing()
instead of struct file. This allows the lookup to work with handlers
that use things other than the struct file.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/liveupdate.h   |  6 +++---
 kernel/liveupdate/luo_file.c | 21 ++++++++++++---------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 6051abc0612c..1cddbab50b98 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -253,9 +253,9 @@ void liveupdate_flb_put_outgoing(struct liveupdate_flb *flb);
 int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
 				 struct file **filep);
 
-/* Get a token for an outgoing file, or -ENOENT if file is not preserved */
+/* Get a token for a preserved object, or -ENOENT if it is not preserved */
 int liveupdate_get_token_outgoing(struct liveupdate_session *s,
-				  struct file *file, u64 *tokenp);
+				  unsigned long id, u64 *tokenp);
 
 #else /* CONFIG_LIVEUPDATE */
 
@@ -316,7 +316,7 @@ static inline int liveupdate_get_file_incoming(struct liveupdate_session *s,
 }
 
 static inline int liveupdate_get_token_outgoing(struct liveupdate_session *s,
-						struct file *file, u64 *tokenp)
+						unsigned long id, u64 *tokenp)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a39992da504f..51817d202ce2 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -950,29 +950,32 @@ void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 }
 
 /**
- * liveupdate_get_token_outgoing - Get the token for a preserved file.
+ * liveupdate_get_token_outgoing - Get the token for a preserved object.
  * @s:      The outgoing liveupdate session.
- * @file:   The file object to search for.
+ * @id:     The identifier of the preserved object to search for, as returned
+ *          by the owning handler's ->get_id().
  * @tokenp: Output parameter for the found token.
  *
- * Searches the list of preserved files in an outgoing session for a matching
- * file object. If found, the corresponding user-provided token is returned.
+ * Searches the list of preserved files in an outgoing session for an object
+ * with a matching identifier. If found, the corresponding user-provided token
+ * is returned.
  *
- * This function is intended for in-kernel callers that need to correlate a
- * file with its liveupdate token.
+ * For handlers that do not implement ->get_id() use the 'struct file' pointer
+ * as their identifier.
  *
  * Context: It must be called with session mutex acquired.
- * Return: 0 on success, -ENOENT if the file is not preserved in this session.
+ * Return: 0 on success, -ENOENT if no such object is preserved in this
+ *         session.
  */
 int liveupdate_get_token_outgoing(struct liveupdate_session *s,
-				  struct file *file, u64 *tokenp)
+				  unsigned long id, u64 *tokenp)
 {
 	struct luo_file_set *file_set = luo_file_set_from_session_locked(s);
 	struct luo_file *luo_file;
 	int err = -ENOENT;
 
 	list_for_each_entry(luo_file, &file_set->files_list, list) {
-		if (luo_file->file == file) {
+		if (luo_get_id(luo_file->fh, luo_file->file) == id) {
 			if (tokenp)
 				*tokenp = luo_file->token;
 			err = 0;
-- 
2.56.0.rc1.310.g51773c2048-goog


