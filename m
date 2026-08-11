Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F61C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9565E6B00A0; Tue, 11 Aug 2026 11:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D8E6B00A1; Tue, 11 Aug 2026 11:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8431E6B00A2; Tue, 11 Aug 2026 11:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FA536B00A0
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:27:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB53340478
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:27:54 +0000 (UTC)
X-FDA: 85089368868.06.17A4187
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2FE1040005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:27:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHzFovP2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=scXxx601mt6vWMI18eOyOCejMZkwRvYbtnRftKjb/YQ=;
	b=zm6dY3kuUamYgaW7Wu06BkDMTyyCqWlYH86uxdRF7JDXM0gvohmER10pcUlKncIYISlQlU
	kPbEKSSfpQA3sO6anlvUhFhEqSAhJ5Q/2kwS5L/UXGVdpLw5ydhpmdZEtRJi9ObG31syaK
	HlQlbuAcxW8Xs69PaB3E5ULZQC0aEwg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHzFovP2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462073;
	b=0vujd4DnTaMlhGDHpI4RX6GhgHniHcAJtV2Hsd6WkoXV6sv4NCXTGg8/Kg0PsrJhfCpvjP
	tGZBONVTY0OeoSgzWLQg6dGRz9J50CkS74IOw29ISS9Q1fH6gS+/bVp+neWWTrVQp8OpYc
	Q9S1le59XJJ5iO/+5yroYlQogMnDcuw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3400600AE;
	Tue, 11 Aug 2026 15:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310B01F000E9;
	Tue, 11 Aug 2026 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462072;
	bh=scXxx601mt6vWMI18eOyOCejMZkwRvYbtnRftKjb/YQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FHzFovP2ddptgqb3hUEvdYZm6detD/ssggmG4/VehxrJFPlKYr3AoHpl+Cl061n/Q
	 XwHNbmac91L5kjKEbP44HyUcCzpoFZVEQOIFI3jE1qdDLunr+2K2rpPKO7nOQWJd/O
	 lCtxmyXeNzFLG5fKWBCQSBt6Ym7PbgQACBiQ/OCxgwLrSiwgtH8vQp1423vDzWY1Ca
	 /Fi8ttEuz/NMACiIjb1Ev/Ssa48QEZdVsKfjMZI9/rvwFE731aPQuWt5tlQm2wsNyo
	 W8E8lmiDjPnUZGb+h/iWbPwEv3lffjvcpoI/bbcOmS5WjuthK9+RlPBnBRonENDli7
	 bXol+3srViP+g==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Aug 2026 17:27:25 +0200
Subject: [PATCH 04/11] coredump: move the negotiated mask into struct
 coredump_params
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-work-coredump-sparse-v1-4-cd3e8b1e356d@kernel.org>
References: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
In-Reply-To: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
To: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3058; i=brauner@kernel.org;
 h=from:subject:message-id; bh=K4UcjnUezF0qgQQhwKLrhjcWPbcfz3yDCnnpkkFGKnU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRV2ycEOEd3hNmfvLDqgNbj7Ue75e40zstJfHnv35OdK
 4wyj3z72lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR4mhGhstCNx/da2gS2O0z
 o7nKW/+dkFpcRI9pk/RJ/2V8bgye0xkZtn56VvldIHAfe1rbjNR4A76EJanPpX4mWJW7PHvy5U4
 ZPwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: g3883imwrua34q577ti9mz91ui5hzg6j
X-Rspamd-Queue-Id: 2FE1040005
X-HE-Tag: 1786462073-202566
X-HE-Meta: U2FsdGVkX1/s+v5XfDZTasPSLQLReH+qUFJxsg8jb+E3zIX5Dg/h0ABlFS4P1mnsfxZPuAo5AbNCn+t9AQy0AuN1sERVD+OLME1ncJRYayS52NFReq9/03TLFIuuspFoWKpZrJHB7Ww1mREeCB2nqmM9vFwXZ6pA3Hs/CrLJgEvezsi31WudaJJ02JRB1orZTQt9FbUzmvuzICwPwJ9oFEI1xixvjTrgtXYrIju4nI8QBxRBygAHGtDaweeWy0GIVFx9kQcgJN8xau853utIFrviumY1a8ft3BwnQ6Oaq+w66QVBcLDsrJGyRu/hjno28Yt9PdjF+S6SYfjXZpvJCq1wpP/+r+jr+cAtQG7kRgqOIeUYZV8bx9DVkQRKKHkdY856ek5bgUnWlT8xcgTGBNx/3jkE6XheZmBHUff3uA/5scnfnm0tzzoPanhgDRgGJTgLyvM7D5g7xJNkrfs4OP6mhcAvwqUPtrrUYUolSo2J+c3/0A5O8T5V8tO2SAcmi+D2YmjuBodgO9cFpuQ5QB4TuRVZlCimtFGs2eDOqgYzsGtso+cCQ1kvrYOuo9aic7EE2xvsFux8v4JSFMN93S/6XM7rrEVCbj2HR6EgtNc1mjnPLVXNG9GIPYXXZ+Jo7T+qYGhuTuFwonZ3gpAITVqzdXgm5yAXV2bfoLyerhvdA/a212//KlDBF8gMVCzi5vyuovV5p6VzgGdiNKhdsaGy7bD+qsKv1ibxPD9q5fg+97R8fCdygiVKslNegGr2Zm1oDyDjAJdpV52BLHxC4q/7GJenHBSbRc2aAHz269BNZaCULjB8F2QGhLheFx2iyySSLIFiSms6Bg/uerUI30eU3+7l2vaK3Pe8ohw/y+x4Jg+RbB9snYapMttDRVCfPu8b57VHY2YdtDPtpwtpXFKc9qElPhnSdLx29pORsuEk0kTMNKvRztBBCcohoLZscHMrzNg1hWny0Z/F3lm
 a7uCX7Vs
 7P0Dnz20EpXFg+ACdz/PsMeiUXl08K2t69Bbogb8CMCQv1Wl2V8mgxdNDiQGDqWzybGc+hg16XS7l6loqVdUCNd/qvAaLwd9xZGLgGgKa1I+9C0dSDcwiTuvEDfvMsH0wYOh0kVRA9W3OiMc5oaDQPpKWyWnfSHPGUrOE3PI+nX8sLYhiC4lrDezjV6y1om3sH9x7NkL//5tKPczKTt7xR3yBZdLRrz8/p2DybQ1jmJMZDbXKlfujW0f7Q6NmNedWsM1Fmh6HFejBelP5qqwRvvVQHvUyAS/sDOZL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The coredump server negotiates a set of COREDUMP_* options with the
kernel. The core dump path cannot see them though.

Move the mask into struct coredump_params so the negotiated options are
available to the core dump path.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c            | 15 +++++++--------
 include/linux/coredump.h |  2 ++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 235b54484107..e5463e3b3f4b 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -100,7 +100,6 @@ struct core_name {
 	unsigned int core_pipe_limit;
 	bool core_dumped;
 	enum coredump_type_t core_type;
-	u64 mask;
 };
 
 static int expand_corename(struct core_name *cn, int size)
@@ -245,9 +244,9 @@ static bool coredump_parse(struct core_name *cn, struct coredump_params *cprm,
 	int pid_in_pattern = 0;
 	int err = 0;
 
-	cn->mask = COREDUMP_KERNEL;
+	cprm->mask = COREDUMP_KERNEL;
 	if (core_pipe_limit)
-		cn->mask |= COREDUMP_WAIT;
+		cprm->mask |= COREDUMP_WAIT;
 	cn->used = 0;
 	cn->corename = NULL;
 	cn->core_pipe_limit = 0;
@@ -853,7 +852,7 @@ static bool coredump_sock_request(struct core_name *cn, struct coredump_params *
 		return false;
 	}
 
-	cn->mask = ack.mask;
+	cprm->mask = ack.mask;
 	return coredump_sock_mark(cprm->file, COREDUMP_MARK_REQACK);
 }
 
@@ -1122,7 +1121,7 @@ static void do_coredump(struct core_name *cn, struct coredump_params *cprm,
 	}
 
 	/* Don't even generate the coredump. */
-	if (cn->mask & COREDUMP_REJECT)
+	if (cprm->mask & COREDUMP_REJECT)
 		return;
 
 	/* get us an unshared descriptor table; almost always a no-op */
@@ -1130,13 +1129,13 @@ static void do_coredump(struct core_name *cn, struct coredump_params *cprm,
 	if (unshare_files())
 		return;
 
-	if ((cn->mask & COREDUMP_KERNEL) && !coredump_write(cn, cprm, binfmt))
+	if ((cprm->mask & COREDUMP_KERNEL) && !coredump_write(cn, cprm, binfmt))
 		return;
 
 	coredump_sock_shutdown(cprm->file);
 
 	/* Let the parent know that a coredump was generated. */
-	if (cn->mask & COREDUMP_USERSPACE)
+	if (cprm->mask & COREDUMP_USERSPACE)
 		cn->core_dumped = true;
 
 	/*
@@ -1144,7 +1143,7 @@ static void do_coredump(struct core_name *cn, struct coredump_params *cprm,
 	 * or usermodehelper to finish before exiting so it can e.g.,
 	 * inspect /proc/<pid>.
 	 */
-	if (cn->mask & COREDUMP_WAIT) {
+	if (cprm->mask & COREDUMP_WAIT) {
 		switch (cn->core_type) {
 		case COREDUMP_PIPE:
 			wait_for_dump_helpers(cprm->file);
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 7b38ee2e7913..dc7a05b1bb0a 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -26,6 +26,8 @@ struct coredump_params {
 	/* Snapshot of dumpable at dump start. */
 	enum task_dumpable dumpable;
 	int cpu;
+	/* COREDUMP_* options negotiated with the coredump server. */
+	u64 mask;
 	loff_t written;
 	loff_t pos;
 	loff_t to_skip;

-- 
2.53.0


