Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A80C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9067C6B00C9; Tue, 15 Sep 2026 07:36:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DEEA6B00CA; Tue, 15 Sep 2026 07:36:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5E56B00CB; Tue, 15 Sep 2026 07:36:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F76A6B00C9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:36:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E94B21A03BF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:36:16 +0000 (UTC)
X-FDA: 85215793152.19.07745D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2AD8A140004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:36:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fXxOaBNd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUM43IO6qNWvRdNooAPnPsLAAH/RcolhMgr+hyP1MvM=;
	b=XGDw5m4OXaH8ypjc65cBazLEDdf7BPqHT7PvdS/lAhKkVb/C5z3XARsY+NG31ZcAjUZTKY
	6wITbziyLTuBQCcbk9MFsvA4zRuwqdrySQQajhhsb3KVz2joxTXVlG3tF18TRkPTzgW+U6
	Oww0mNahKWKWCum6wEXqNERPFrXqb6c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472175;
	b=syVwisn4RFXUbxs7wZK0IqsPWzBNFAmke4jw1ZSAwv/M1wg3T3m9iUJaOG9bOtwnZi6iXn
	Rk47vu2i2bJ2fcy89h5LbvQ+/IX4s1XSViOnn98OLe26V9dsr03qmhvl009q9yybLjrU11
	WPs4oLzApcZwIUe0v1qFiUn3kBQfLCo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fXxOaBNd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94A71600D1;
	Tue, 15 Sep 2026 11:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F6B1F000FF;
	Tue, 15 Sep 2026 11:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472174;
	bh=SUM43IO6qNWvRdNooAPnPsLAAH/RcolhMgr+hyP1MvM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fXxOaBNdJwFX/Lk/E/kRGTURHefQKpPPy4SOimei8WnuQFymjQ54Osu1qX23oVPTQ
	 m0A8Uo6l6w4qKA2hJ3urgORqbpweOp4clPRtYTGkNID+oymAFlp8BwoOHfWgXjq00g
	 2jaCNdDGKnUTjAY9tG8l6AGYNW5fihLVRuWziN2I32TvRehjGk6CF4lsh9F7JKNwM8
	 v5WKv5XKjGiJgpuTC+6woLjedYHaONUBygXryBe6w8FmgPTi4h5Mt5Fbn+0QCTmLSc
	 1dRRPZi0WCjS5bVpj31Cm7wGEaPUy3iJpp2OQokIUXhIHQiwa1Leonc8PLtC/JB8/R
	 gVXIBaAx596pQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:24 +0200
Subject: [PATCH RFC POC 38/50] perf: stop putting the event descriptor back
 on failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-38-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org, 
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=2461; i=brauner@kernel.org;
 h=from:subject:message-id; bh=gBId4KwT9HjrpRN/GtoshdJN45hNk2Km5XhUS+Rx/dQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Knz3yduOPXT6cQYVeXHZzbnqs7Zqcayytk3qHiay
 eV9UyYIdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwk7jIjw7OGE8fOrTS3bVvT
 7m02I8bx3+9MntLGq9z1gtyNvPx5jAz/fe684tNnVrol8LfYa7a9+/c7fcJ8jXoa4n6P/MXywr1
 5AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2AD8A140004
X-Stat-Signature: h8r7wdd5a7qsctydyzwmz8c9dwmr9ksr
X-HE-Tag: 1789472174-519497
X-HE-Meta: U2FsdGVkX19kFiz1LDHOvJyHT17zzWSxPwzNz+1+nuuGalFSO8y2Ul+C2m42T7L903DG+qAszvoqvmV7kaU2gnVTTbPgT28rU2MnAGa1EbqhNGrVKTOAjQAD8He2bZhQucaVkv/kcRvzntyzYu6+r4E52K5c2t6VM3mOgjca1H17bL+LzPeKlliMOeN1gcNEeAiuCkblQeS2r5JRJurqbWrw5U1kTlFXuF4JUfyYNAT97fpgLfAIHLK3wfSTqaC9noYooGcro6EUfYE/TP1dcPyTFrxOZgPH44lrbkfWYtFqOrVo7CD5LtTWJ9jOgXpj4H8NspuG4jBfDQioFv1OisbgEpN8FaYM8isv/igBmsEpZ+ze1SmJewxk+bXyO5gC8JAloxg32b5kty8gFOsd3D0A44HLlKmXk+fV5E3c5k7iJufnxc4aewnnW1c7D9+1K6Jg6jB1IY3/RYQ1R3AQQm6niqY9LSFURBSoHcrwj+LdfhrKIGFBo/nD1sa9/ZAnobuFYmGgySG1GFGs1OTD7tzTKlanSEeABTSVZK0mnhN1tNmnF/H0gLV0835F4BW2a942WITUvG8HdkQMyYehlbSbz+cECGAAsZPcgMRM+FkVs/uLWxNv4I+ME2J9MzzUVa2nRdm0Ap3DoI0YOqH/vUDP1DQuNCvrFJGFAk4NHow4YLpcboZ2/0gW7fvBvH5PkkSq/xWA7K4YFdoWSl+pdcJFfOJrMi3TZgmfTYzUkXJpYvtPDUYRhM1RQ7B625Ed986jKsrhu+cLsz07QQYSeKLa/tfhOc5TCbXGYvRhxdiGfO+CfjN3mf3VKtuj3JCHnzorERSFiEFTk5sKOkp69nB02M5jn0aqiguVxJqM+OeHpertsRTstvva4K+sfmgBlfwLEeHpBAkWtl8a41r0FT9HzWfE466MHSKLlPT6ezLBqJFZf0Yil0U91V1KNHjRh+XSgxmiCRk4MU6sJAD
 gYFyevRc
 BetNzM+Zzhfp7RVaZyezID2JHXZ919jzx92rmmvm5GNQ9ZQeDFZPv6Bjjnb9LDK8Q0cctH24b1bBViXASePoK9xX/CnuR42Pr0joK5anK4JO1hX57oiECyo+c2B/KdFgMFmzYW09KOO8rv2z7LSCZVV9M4v5Gc4DfSW4bIKObMbwEFChpxk5brGkw05vd0Or9NxnU5XnfH+Ma1qRb3+C6Ki/UcywmM28ZaBGQlKslSL0IzpAHq+t2kor+Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/events/core.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a6c8e38a3110..54834a7aca53 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -13924,7 +13924,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	struct file *event_file = NULL;
 	struct task_struct *task = NULL;
 	struct pmu *pmu;
-	int event_fd;
+	const struct fd_slot *event_fd;
 	int move_group = 0;
 	int err;
 	int f_flags = O_RDWR;
@@ -13990,9 +13990,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (flags & PERF_FLAG_FD_CLOEXEC)
 		f_flags |= O_CLOEXEC;
 
-	event_fd = get_unused_fd_flags(f_flags);
-	if (event_fd < 0)
-		return event_fd;
+	event_fd = fd_prepare(f_flags);
+	if (IS_ERR(event_fd))
+		return PTR_ERR(event_fd);
 
 	/*
 	 * Event creation should be under SRCU, see perf_pmu_unregister().
@@ -14001,15 +14001,11 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	CLASS(fd, group)(group_fd);     // group_fd == -1 => empty
 	if (group_fd != -1) {
-		if (!is_perf_file(group)) {
-			err = -EBADF;
-			goto err_fd;
-		}
+		if (!is_perf_file(group))
+			return -EBADF;
 		group_leader = fd_file(group)->private_data;
-		if (group_leader->state <= PERF_EVENT_STATE_EXIT) {
-			err = -ENODEV;
-			goto err_fd;
-		}
+		if (group_leader->state <= PERF_EVENT_STATE_EXIT)
+			return -ENODEV;
 		if (flags & PERF_FLAG_FD_OUTPUT)
 			output_event = group_leader;
 		if (flags & PERF_FLAG_FD_NO_GROUP)
@@ -14018,10 +14014,8 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	if (pid != -1 && !(flags & PERF_FLAG_PID_CGROUP)) {
 		task = find_lively_task_by_vpid(pid);
-		if (IS_ERR(task)) {
-			err = PTR_ERR(task);
-			goto err_fd;
-		}
+		if (IS_ERR(task))
+			return PTR_ERR(task);
 	}
 
 	if (task && group_leader &&
@@ -14298,8 +14292,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	 * This ensures destruction of the group leader will find
 	 * the pointer to itself in perf_group_detach().
 	 */
-	fd_install(event_fd, event_file);
-	return event_fd;
+	return fd_stage(event_fd, event_file);
 
 err_context:
 	put_pmu_ctx(event->pmu_ctx);
@@ -14316,8 +14309,6 @@ SYSCALL_DEFINE5(perf_event_open,
 err_task:
 	if (task)
 		put_task_struct(task);
-err_fd:
-	put_unused_fd(event_fd);
 	return err;
 }
 

-- 
2.53.0


