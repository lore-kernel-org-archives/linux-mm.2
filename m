Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94687C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0F56B00CA; Tue, 15 Sep 2026 07:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9866B00CB; Tue, 15 Sep 2026 07:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908216B00CC; Tue, 15 Sep 2026 07:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 716F76B00CA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:36:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 095591203ED
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:36:25 +0000 (UTC)
X-FDA: 85215793530.22.16B26B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3758712000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:36:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j3rMRnP4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j3rMRnP4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472183;
	b=tbJCQ17MOfUB1oQd4Xdmv38rSxHrZAo7SZBapfEXCquZqYFk0JBR4MhYKmoExGyrQ6Ot/9
	y7gXkSwbxZCv6OKS1JxdWL6PSaVakI4tzPu5dwwoQVGquBh+NX04PdVzfYfA8+2y/A0F4I
	5qqQigGSqsaFFf8SqNWeoyMN+wTQwWA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZh0vLqcxduUWTFynumJFhxFNW42oEX6Rn3UwZlew10=;
	b=OqCP4RGTHEvEBG8MaaXyIIAE6J6LByc/IXPioUf5R4+iwwpaMXb4qU8+MMXyYDyWEhty3y
	1HaETGyZ+6ojscVG2U2mn7QKdw+5EzicqWhvsXl2nGSvemd0Dx/bP+c30nJUWOFdac4AtF
	NOrc41NCuwsVAoH4sicfQWiL5zoEWPk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50DB3433C1;
	Tue, 15 Sep 2026 11:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5001F00893;
	Tue, 15 Sep 2026 11:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472182;
	bh=oZh0vLqcxduUWTFynumJFhxFNW42oEX6Rn3UwZlew10=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=j3rMRnP4Yq76LugZgcTC3Qf0Ci80ZsR1Bjf4RalPTu0XQJWg3exDlCNJpfFK/5MxM
	 WYaKKc+iEEvUbRPZPKxBSCicd83hSTqA7oZhBEyYRVXy1eWTpEG9V0qCpYWagSWyJM
	 LMC9aTfO6/vIRu0BhEoAicivAddy21JTUJ9Ey/WFXSkOgO7lRUm/69w2OsJiTlTGJJ
	 PVaIxbRP2QqlmQ8miseIjAxpQqw4BFWTU0OlqdE4kvqHra2NIRZhFlj+TvL3m+l5UE
	 la7dnSw8kYUKUgJ4W/pOpOV1l55Kv3959gLF9FNT0wDZZqyVfgaqZTmzG3/cOJbMQV
	 93dOclKCiZGPQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:25 +0200
Subject: [PATCH RFC POC 39/50] seccomp: stop putting the listener
 descriptor back on failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-39-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1590; i=brauner@kernel.org;
 h=from:subject:message-id; bh=SoVog+6B8HBuyIDP19b0KqkTeSBHFQ/u5Q+O82974JE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Kl7drfm0vIrUa8YdK4pvXG67XDtwdnLWZ9s8lgOH
 X5/t2WKdEcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEGD4xMjwJva2x4G9RxkHX
 XU1ZZuuPNKZYpJh/z8h6/EhWU//pvNcM/2vKj01as7z7q8HKc/dLTVZVbHkiJn/kXu5zo+cFdn4
 LL/MDAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 3758712000D
X-Stat-Signature: oi7bb8iet8wrm8w8uqs3nidq7zrr6fxs
X-Rspamd-Server: rspam01
X-HE-Tag: 1789472183-851466
X-HE-Meta: U2FsdGVkX18F2cjLv2PsVwJx8iHZCuE5A7LV7d85k15VKUpknahVMHvgfEC0rR/SILF2940e5uRU1pm5IfNjuvlZKy9NF+6ELabI8iEua7T6El1eOvR8Ktq8T87taff/5hfy5Epc9aESLCUar7tURBkR8C7rbzneMDgBXyQV7lQ8uBLo24VzL+WK0jL+zN+axKIuleqUDtUFJIvg1RD8CSzAO5pVQW6D0bE1L9O5rlI0nv4cTIAWszLx6XBcCvcQeCYPJGcg/kyxZwtl3TbMJ8v4CL/FdZ75qQLYB9NtqgtGPNYqk0NfPlAZu0MCv5fBc08jZpl9GHvafYiSjNOssCXtBbfchcSSDG3kBW402XlWJDtE3LqvC1UNJ4vMOFq0mWr5tAXwb4oOq2GJh7a0cqVWcg4KWP4utMLl3BfWle3oZqUdJJ3JuwusFTMw1MxNNLOtj/GFSg+ornQ4uXfQVk1k6ynk8LVIfJGTZgwX8Fcu+UA/QXLtcdCd3TAH5CcJXsCj+5UsX1ngQAnkWNJJ/eAMF9gCk/+fNDET+MziDB6Z1tbz7KAsrXETPrgLfE2DVigEBT8cSoz1F8mfRkN8XK4fDPjjP6gUrxDR5u9zPM5lR0fjCi+zRSeXjPC+HxVIezVoBMlBQT+t6iEVn2fQd2UZaMHjBCVGO1WT2PYgYjq4xgf0WhZurVOTn2id1Pu8n+G77gcurR6eCsN2pcPYeAFayJ5Ir1NiVwgLc0kXaZWq+R4ElZ4so9aKw/pCjyatNAdnCcNHsgy9PMJiIc0pxKbQXkCUtro2EQ+ro2Qiobn8NWEjthQ8fS2CFIEReaKL6zVx2K73xxwtuyAQ5RmQWXmiwY8yx/c2LPGgGIsKmDuhUwmOnSe6PkSIYZbCp9A9ks65cmf1/RDyG82/ybAENCvAzUkWvn4fzWvG6uID+DyGJBDJoiYFMZLpuo/DLmnSKphX709nVQcH1EPKOwl
 kKrLV129
 bb1NylECrmf6vKQysZKw5R95ObeS3GD0Ko8pGMZtJdeZL6UB4FwJR/gFB+toHf7K0U9EmtP7BeFO0C0Hi08jAc7scXEaVQ7Fz6HPqia1alFelbHjJGl34o317Xd4oxBAtC4z2u+t0L5Sey3iZiDOl/02KpKbeP8SFYUfGQh5pC4P1/qwam6kfcWg6IAjhNuV4yTwhifJC4IqGFvG95kHnG0cwVkh/9KOLa2M2yBO0vIl/uakgGSvFuaz8Kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/seccomp.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 86cf4460d69e..dc275ab1e031 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1957,7 +1957,7 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	const unsigned long seccomp_mode = SECCOMP_MODE_FILTER;
 	struct seccomp_filter *prepared = NULL;
 	long ret = -EINVAL;
-	int listener = -1;
+	const struct fd_slot *listener = NULL;
 	struct file *listener_f = NULL;
 
 	/* Validate flags. */
@@ -1990,15 +1990,14 @@ static long seccomp_set_mode_filter(unsigned int flags,
 		return PTR_ERR(prepared);
 
 	if (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) {
-		listener = get_unused_fd_flags(O_CLOEXEC);
-		if (listener < 0) {
-			ret = listener;
+		listener = fd_prepare(O_CLOEXEC);
+		if (IS_ERR(listener)) {
+			ret = PTR_ERR(listener);
 			goto out_free;
 		}
 
 		listener_f = init_listener(prepared);
 		if (IS_ERR(listener_f)) {
-			put_unused_fd(listener);
 			ret = PTR_ERR(listener_f);
 			goto out_free;
 		}
@@ -2038,11 +2037,9 @@ static long seccomp_set_mode_filter(unsigned int flags,
 		if (ret) {
 			listener_f->private_data = NULL;
 			fput(listener_f);
-			put_unused_fd(listener);
 			seccomp_notify_detach(prepared);
 		} else {
-			fd_install(listener, listener_f);
-			ret = listener;
+			ret = fd_stage(listener, listener_f);
 		}
 	}
 out_free:

-- 
2.53.0


