Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9FF2C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10826B00A5; Wed, 19 Aug 2026 19:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E86A6B00A6; Wed, 19 Aug 2026 19:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8196B00A7; Wed, 19 Aug 2026 19:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66AED6B00A5
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:10:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E7D47160433
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:41 +0000 (UTC)
X-FDA: 85119565482.05.2E0CD0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2D441120003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Heen4TOm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aaMUb6PaGUkY1uYWWgN3cAeUq6l9h+PWt5o9AmFAt0E=;
	b=8nfDqigY2mc7y1/iuf5wern8NPh+hnGSe3yRVUnaQP+iLsY7dHeQaIBtU5dl8lobjxcmDj
	Bva0R4q5crKzJ3J2oJ5NHxP5yA0pD6uO5B7jBjmW3Wvac/sn4JZfr5o7I0ey7pN/KGvDb6
	cicaXHiupfHsLDVgvHAvTbPZgZsKUp8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Heen4TOm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181040;
	b=gZeoAs5VmqGBI2Uy1xd6g0FFesraOPfQ7HY4OzCR9VetP+yNTHXb8cLai/Cp5fRHllkrv3
	SkL5FqWzujf6pjDvo611iTlQA2ggnHindRkdRYcUf6mH9Wr7f8eoVEzJlk8yXIt/930TkT
	eOZsTdFFHRh/MyNzTYqvabx9C3V9Xyc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C6F940876;
	Wed, 19 Aug 2026 23:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49BC1F000E9;
	Wed, 19 Aug 2026 23:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181039;
	bh=aaMUb6PaGUkY1uYWWgN3cAeUq6l9h+PWt5o9AmFAt0E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Heen4TOmnIFtyQjYyv7+PIzwbbZz42Npc0GW51hx4ud6x7Rqf5vC43y2nUEyf6ECq
	 pcOtUTCa4JHCyEcCor01N2FsrVzY4Xjm7i7SOASr/nhmsgg1panWWpwognCtck7bki
	 amyCR7G/xgubDR7CnBmNhnmShiSOXhCZV/EmhjyDGMOd6gpBaEBfm+7WrYTH4VOLe6
	 tXsyvPISipyoCmNDuotbnVIf6lTR6kOjJNL3xCZyYHZMVbKMd4DQD80VHObnZVHCMI
	 1Y1SlAo5BoouEupVho6PfMbHhNiwNVamHrCRweaUELDn/awZxVfgZVA4v7U39hHat8
	 ey9XD16ZR5ocA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:25 +0200
Subject: [PATCH v2 08/22] coredump: move the negotiated mask into struct
 coredump_params
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-8-ba32dd718c51@kernel.org>
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
In-Reply-To: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3018; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xonH5OEmjGZ0T+LJRAZWyQJ2cLCDz3LlxuOJfpmUo8A=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me978e91/5SSmW3Hd9p4NXx6qdCyYpr/+dqUjoUst
 1Q28tkKd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkdCIjw42MXtMq5yP82dzF
 ZmKXY/pZpcJSc2XNFfnOrl+sa7iJkeF/EmfJzMjNwrER+n7NRrdtNXuSDntrCy5pULGROCMwcx0
 HAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D441120003
X-Rspamd-Server: rspam07
X-Stat-Signature: gyoxrcn8eey9rdty75t3xzhwctx5nms6
X-HE-Tag: 1787181040-628957
X-HE-Meta: U2FsdGVkX18/LG1Ifz3dJ3LAqeAHOf1kM08SajI8tAlAX7gdjGLEMwPPsBuMciWGSowGW8U2ow/ekC/sHWUnsTySLUrNtWUPFD+PfKWwgYgDmPJxNkJ6m6x54tg9PBv4SHttWJC48sKv/11WvyWnxpEpDZ3EIhc/anqNchlFVeBRAtP81CDJTgCWB6rzE3RWq+mEQvfDL3V3qaGbmuFMs5jJru0kp6HYxWbGgc0z1ODvO2phx0MvI0QxTiByi4aPHLcI/KzYmPHMm3tcjIytEX88clswZJGAjn0Xhe7WuCzfYlq3hnGA65ohNfxqrshx+f5pGmho12JUxiCVQjSZf1jKggvmxMe5bZej5nWTVVZlbg18o2HxMLcYdaCNQpH5cKkrLOcBnbrRnymZrrWhLLdrUoKbpV1SbC6F+S88fJtWT9tc3ql6dPVYQN4UdK1F5UtBxfFwe4Bya5vHnAu7565LjaGCkkZ8gVqUbQVEbF0WRydnOEK1Vs7jwPAVWmn922HS0dleYI0pY1dRI/mUSs1ZOC0aWyhrmrJv6AVgm9eRprHEMqqGyrnVgA9nbf0nl98tFgqpuVJvpqTZXT8sq+5tEl9hKjP92EabDS01TcZwGhQ7qlAUW8pwFpjcoOnvwRUnt78t8dBv2pAyCbXcwDLsj4e3eQiQ5AL4k5HMQrfn90P8VLK1fekth9QGK8YVeH5fB/rBPNXtQNplpHEnS7B0afxJIxLjwATYV7JxPvZhm0ZT8fCVuJ6MFunPTJSqADEF5Imj7ZY5aOOml7TmuQmeiC8irvR/qCofkmnDkIle6920KWsBGzJ/TTyOUefWU4qCmGFYPXEQiI7jx/IKVQk/xSNhtP/T4PhiiCHlmMQzd9BfyaWYnPjbwHQ2iFvqQ3Dhz38h+RyXVjVmOUW2CwwneLXvFx9xLiy+l9xfGkUtG+2iRyFGp8koOIwBIBV6u9CmzYkoFXDzJgHz87Z
 dNaET13e
 UbOKCidu0qil3mH07HCgjXxEDSWWXtWpdOVarL6AlAZXAUndm6wG3Epsvij7HMBoUIZVDj14H7f/nD5mQtJIaZKsfWr7OKPO0EKf3uw3zWPB7J0AHBVpxZqe5jjFM+Q2px2yHxqwsGKQM6aPozQ6lyPPi0CrzP91ydllDuiszSk7v1cbRI7CeW47UouVbd1IU9zhOAKSzY1kjwt3pwycVBXA5RDorXpKrm0wgOVge3ppwr++v3dgq/6eHJH6M50zv6aX7CeOAMyDsE9Nlcsevh/JabILThmFMBLfA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The coredump server negotiates a set of COREDUMP_* options with the
kernel. The core dump path cannot see them though.

Move the mask into struct coredump_params to make them available.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c            | 15 +++++++--------
 include/linux/coredump.h |  2 ++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index c696b46c97ff..156688be3df0 100644
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
@@ -860,7 +859,7 @@ static bool coredump_sock_request(struct core_name *cn, struct coredump_params *
 		return false;
 	}
 
-	cn->mask = ack.mask;
+	cprm->mask = ack.mask;
 	return coredump_sock_mark(cprm->file, COREDUMP_MARK_REQACK);
 }
 
@@ -1129,7 +1128,7 @@ static void do_coredump(struct core_name *cn, struct coredump_params *cprm,
 	}
 
 	/* Don't even generate the coredump. */
-	if (cn->mask & COREDUMP_REJECT)
+	if (cprm->mask & COREDUMP_REJECT)
 		return;
 
 	/* get us an unshared descriptor table; almost always a no-op */
@@ -1137,13 +1136,13 @@ static void do_coredump(struct core_name *cn, struct coredump_params *cprm,
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
@@ -1151,7 +1150,7 @@ static void do_coredump(struct core_name *cn, struct coredump_params *cprm,
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


