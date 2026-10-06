Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91FE8CA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 22:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A6C6B0092; Tue,  6 Oct 2026 18:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB146B0093; Tue,  6 Oct 2026 18:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903626B0095; Tue,  6 Oct 2026 18:15:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 644C86B0092
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:15:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F17BDA0322
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 22:15:17 +0000 (UTC)
X-FDA: 85293608274.24.2F39AF6
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5111F1C000A
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 22:15:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b=Re4AwauS;
	spf=pass (imf20.hostedemail.com: domain of kylebot@openai.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=kylebot@openai.com;
	dmarc=pass (policy=reject) header.from=openai.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791324916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3b6Jf8//LXq1nt0lrU3uzCZiYGb3bLhSCGzIPeVAOUA=;
	b=jHycICqzcmZa2qDfpy5kdKcgHlREej7R7onaq/KTAAMtGqXtlYmph12LScaTnkM2cMJUY2
	VzIUkpfBQ0zm6jcxBrkaQN5thmQFqwy0xNz/CxBcqfugobb+l78ymKqzwCrinKsQ0E8qFQ
	JWAbXwgdymkMpuKkjzy35iS/CuWLmsU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=openai.com header.s=google header.b=Re4AwauS;
	spf=pass (imf20.hostedemail.com: domain of kylebot@openai.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=kylebot@openai.com;
	dmarc=pass (policy=reject) header.from=openai.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791324916;
	b=kMRuUhOnx9AUnFs8oYL0yQsPYRTxOD3hOHk9lCR/NpcjqTInJg2MVWFcl07sOJvU3w+3MT
	iUulr6X5wkMFvjzh4NlXfiRHwn4mDnKEflfUcZMrK16ffyd9T3ODs4SQeuij8kh81iPSlN
	+vyOtZMZi07NzOkSywDgt65uOK/8EWw=
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6d7e06dbcccso729802eaf.3
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 15:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1791324915; x=1791929715; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3b6Jf8//LXq1nt0lrU3uzCZiYGb3bLhSCGzIPeVAOUA=;
        b=Re4AwauS9ew/f5ctcxLYHKNLfmL7JhEg83qYawyinM42b3afvnkgpT3+AMTGVTM4zm
         baDKd2xWAoDujqlansns4HjRigZsGr1CD0fvyubPEHkQv5ieoWVi8DtyFmUqtVfIqGkl
         7QUMFqYADzueurNe5RqjWY6PqUqxMynV90Dac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791324915; x=1791929715;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3b6Jf8//LXq1nt0lrU3uzCZiYGb3bLhSCGzIPeVAOUA=;
        b=wgVjzjDN3PkPgiheeAhBOYZsa0ad7qUVzhSsXo+N54vY/boX0CZbfSfXn/GpSRFwMD
         Voa8CKqB2iSZU3cBxKK04sblFzlyM3kVVFFPdY0xqo2/HQ2oLJQF2xlJKv141bufoVv2
         Hq6ixUg/SfOSuEtw5IVTAT1rCigAtOXnGZUc0MCrRpSSr1bho7M7QQnFnCQwqVAjz8zG
         pEO5yOuxQ7q2blzYifCQXPgei7Qf5v0PMJ5mfwYhPb6L+ysnUg4XCsMdVXVimOLBqOmR
         6JAW+FHcfCEAiyJr2hfo1a+oFJQzyjmCLHpT34GJsk3RREIEKCsizJA8K30iW1QgeIOp
         +Xtg==
X-Gm-Message-State: AFuF++luCz0q9tlLs6Kbc7xXBt0lZQV5Do4HE4g8g1FfmEjc62PkbJ8F
	eQPuLOdOQ8Lh1BCjtV0S5UPsfOq3y9GqPVsE3tXmJTtC4BvRbEdIQPVK2B5KvA1oGoqJemyIVaf
	G6qNHX2A=
X-Gm-Gg: AYBFou3xQqlJSThKSYpjuVZR52uqlAwIamvlmB76YUwLmvX6JuniM6NzLoIThY4PA+P
	guOz5gWbI+qoX4iW72sCI94ssfQ/wyqZETNw9c84SF6tPTIS1RLCR07mi8fUSdRRBjTD4M/PrSQ
	kkD+corr5yfAyBtR5ujNT59stIoY4YHmj0/0jN0FS7TzXDHQt78m6FUDyaW5Sia9166mqCn9fvD
	JIm5bF8yP0r7hgvCU12uGVvXQ+RfBD2Mz7J3/by4homrZT4zcA31O/MMZ0M/LRWwHa9YkCyOkDx
	wa++EUYC10vdG6/Ri3Mqvm6u1oclikFaxkitTKvKHgLrZoRC6rC+sbbGeWxYZcS0d1U8ZHI1xMG
	oeOIuHka/dq/ptUSyKdYdpYYp0nobW6+hR+IBYKlmoLDwozd/8nCTTOSX1rNbyMXnas4YsRmYz6
	HAEs+XraAz1mP1w6cx/O2r3X5UKlLE2Da8wI4nZHpv9jW116B3EJyJkjk5sqSXLpqHxiCLH+C6q
	RiGtnmeE8WlFrzO3qdb5MTgVYqAccxzI/LxfdeO3WwFIVVMfaX19qQeZLiDBCLxEKLCqe0Y46x/
	DbUkIP2/lQ==
X-Received: by 2002:a05:6820:7090:10b0:6d9:8fed:b732 with SMTP id 006d021491bc7-6e7a8bb924dmr455388eaf.56.1791324915076;
        Tue, 06 Oct 2026 15:15:15 -0700 (PDT)
Received: from com-75606.corp.openai.org ([199.47.143.7])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a2571cab91sm565412fac.11.2026.10.06.15.15.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 06 Oct 2026 15:15:14 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kees@kernel.org,
	outbounddisclosures@openai.com,
	Kyle Zeng <kylebot@openai.com>,
	stable@vger.kernel.org
Subject: [PATCH] exec: snapshot the dentry name before setting task comm
Date: Tue,  6 Oct 2026 15:15:11 -0700
Message-ID: <20261006221511.35798-1-kylebot@openai.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5111F1C000A
X-Rspam-User: 
X-Stat-Signature: 17cpo9eyg49uewy6jnsonauy1ofq3de5
X-HE-Tag: 1791324916-367029
X-HE-Meta: U2FsdGVkX1+kS6hV5KNl0MVvtb8yU+cSLoYFwCvz2biZnNz4ftA51yx+GcVZ8YQYSS9pznRC7EmbInLU6L71hoPUgGb3JVoXn6Ai6K7iQA+kX1ge23KkVlRX3vZ7xWQ5KIiGTUafoK7I9wYhxjVv3Ac9LMqVmAXfRJ0+l1dCmZm1qK9vi2L04FOn0QV8MdU8SsJ6fuQfiXQWb/2gNso7+9Y2cc1KtKElYTW0zT+00P+C9bRkmR32iL3QBUSEoqx8p+q04rtt+u7hPs/4Ln9aLc3ftVvGWgSyKwP2B/nfm+E1nnflWL3XGPvfnU+FZsaTnpXpocFUvYy8VyiuFZFRbId3/giH3/nTFMqlcFyyt9r/gSAew7eUDTrSTN4QK9nnN3usva29CxBedrk+hWqntzPYS9TOlp0B7JbVI4xL89zCiLM/chT2+ro0axY+B9y6QWCuCLmFoxnuCczNI97uPaaLRCTTbasy4/kNccRofXcZBQQH/zk9kiu//gGrmkcArYjFbU3fuHNOLJiVB9NekNUw9cZQ/UdXSCntTy4uY1zKobT+mRWAk7F3Pu4cXHu2p63BzVFaGxvIatwNndgTzpqxqfC/nHhoNNLenv65uP26Cs5ODbswmMAhfzNRr1FaE50kZpX8aJhGhbZ649hcH9PEf+VFRVVr84LZ1n+vp8B2nKQcrhmh4cwiBvJ8VAbDvXnIx1bcObABW0v3qGJBqmwZZereA543ISGSYafalsHoijFFYdDkb3Yb5fhk1DFxPjlYcC7KLO3FLKN5mCeM/IXArGjgRsKBKunkXk1G1uQbx8LbA0D0H9siyoEDf63Hc9AUCaorr9j62Y7haNadF25TJCLTlkG9DPGQyrnp2g4NuycqdhBCSbVGrcrzKnwnDGJJLoFW7R3TaLnI77ccxP7aHrdqbyk3zuyvUZ4+qsKYgP2CiJOfR++uy8jbpSSMJNnkbQFoNAR6erieEB0
 UDwQTrJk
 pfJL/+DCIBolTRFXpgVz5BR/qrRRpEHtDpXBE5/vd2AQQYd8TNrjIGRMLKoybEBlq9yCC7p+5dMIbow0DaS36CKk9eMTcvT+vDa9YZNhvFws+2XXm3WnSepA0MeMWdPGqlgIra5vzsXDOmAi34NCLwBSzFxm162UhjJi4CX8eA6t+Dvx/jVe1kuBIcm5AeQJCgX4XlSrrR+vRR/mhn89c/+S6WAAj1XNMu8UXAOv4XjzBIP7tTjXAaLJQBjzaKQad7QyhkkssmYaN+OSepqOgNilyHWOul4bE2n3lSK1d/NrJqwvkXCRx+q+F0+ztk8vE7dbMjawcghglvB6OryzO2oSQPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For an empty execveat() pathname, begin_new_exec() passes a live dentry
name to __set_task_comm(). RCU keeps the name allocation alive, but does
not prevent a concurrent rename from changing an inline name.

__set_task_comm() measures the source before copying it. If a rename
replaces a long inline name with a shorter one in between, the copy can
include stale slab bytes after the new NUL. The subsequent padding starts
at the old length, leaving those bytes in task->comm. An unprivileged
task can observe the suffix through a count-only syscall tracepoint
filter such as COMM ~ "*pattern*".

Take a dentry name snapshot before setting comm and release it afterwards.
The snapshot retries concurrent renames and either copies the inline name
or holds a reference to an immutable external name. This gives both the
tracepoint and the length/copy sequence a stable source while preserving
the selected executable and the existing comm truncation and padding.

Fixes: 543841d18060 ("exec: fix up /proc/pid/comm in the execveat(AT_EMPTY_PATH) case")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
 fs/exec.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 819643408e6d..34cf557a17f7 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1279,19 +1279,16 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 */
 	if (bprm->comm_from_dentry) {
 		struct file *comm_file = bprm_identity_file(bprm);
+		struct name_snapshot name;
 
 		/*
-		 * Hold RCU lock to keep the name from being freed behind our back.
-		 * Use acquire semantics to make sure the terminating NUL from
-		 * __d_alloc() is seen.
-		 *
-		 * Note, we're deliberately sloppy here. We don't need to care about
-		 * detecting a concurrent rename and just want a terminated name.
+		 * __set_task_comm() measures the name before copying it. Keep
+		 * a rename from shortening the name and exposing stale bytes
+		 * in the inline name buffer.
 		 */
-		rcu_read_lock();
-		__set_task_comm(me, smp_load_acquire(&comm_file->f_path.dentry->d_name.name),
-				true);
-		rcu_read_unlock();
+		take_dentry_name_snapshot(&name, comm_file->f_path.dentry);
+		__set_task_comm(me, name.name.name, true);
+		release_dentry_name_snapshot(&name);
 	} else {
 		__set_task_comm(me, kbasename(bprm->filename), true);
 	}

base-commit: fd179f8a05be3ccae366b9b96e176b51fbe54aab
-- 
2.53.0


