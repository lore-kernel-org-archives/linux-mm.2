Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217F1606A33D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jxKjanWM
Received: by kanga.kvack.org (Postfix)
	id 834FE6B05B9; Fri, 20 Nov 2026 08:42:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5A46B05BA; Fri, 20 Nov 2026 08:42:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FBAA6B05BB; Fri, 20 Nov 2026 08:42:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D619B6B05B9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:42:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7ABD4A8DB4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:42:41 +0000 (UTC)
X-FDA: 85455612522.09.C59B550
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id AF498140007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:42:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jxKjanWM;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795182159;
	b=LoC7DHSCeU2kfN1LHnvBu0R5NADiFuBqd8yMCu7j/So+yGmil5QrJMgLiazoTX3PjxEUMo
	FYepJ1WkXVeps7nJkp6opkoJThRI9Txie96fBq+rEWlkvJI1reh3lPs1RZULZSR5kUyT8P
	pVQMB0jAzDCRBgfjeHxrvwom4yD+ufc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795182159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HpEeM9v9uPq3z/TDaX86swVoOCfhYmVoaoGwpnzpfrY=;
	b=Vtz/T1WTIlRxW+cx7QmQkJrc2tl+wVs4ihb0CfH5cuJ/HhQGVvBLt8owxiViK5G39YI/6S
	5DnsrN1+sZNTAUSPJIbEkd2KewaduO/1rlxuYcKSoNNYRSuj1sLm1TPh2lNpKM5yRgMEHF
	UeBLE2215jlYeYshpZWdb+Tq67k1/vc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jxKjanWM;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 522D161D11;
	Fri, 20 Nov 2026 13:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D3E1F000EC;
	Fri, 20 Nov 2026 13:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795182158;
	bh=HpEeM9v9uPq3z/TDaX86swVoOCfhYmVoaoGwpnzpfrY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jxKjanWMnXDDySlRMAZSi1CbsPnP9bd1DrZouEcSxL2M4GMSUwo79IXgce7mfiKnz
	 kVlb9FXdhqoKFkOcCwE6aStkJGJCF6vtaVlneqxOT3/BhUsZdrKNhjgXbNgdatp74V
	 b2hY3pSvqcpVg9q2E8igmGkq3Qol0bUlZgVc4sLHEFf23Ikg6GGMiEXf+ArkO6NJa6
	 cYNdgq6hWKr5+rfes8ZIQ8p2ovzhGiklfyOu9itsE7pbj/cK8ozF84RZQiT5B2MUDM
	 u1FEk96jh3bSeA8xwWgh1QXRktQ8R50IrjQoDiEPXqe3pDW07w3A3US2LMvzuLFNvz
	 2ujV69qet72Qw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 20 Nov 2026 14:42:11 +0100
Subject: [PATCH 3/3] pidfd: restrict pidfd_get_task() to the caller's pid
 namespace
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-work-pidfd-pidns_visible-v1-3-0e82d08469ae@kernel.org>
References: <20261120-work-pidfd-pidns_visible-v1-0-0e82d08469ae@kernel.org>
In-Reply-To: <20261120-work-pidfd-pidns_visible-v1-0-0e82d08469ae@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jiwoo Kim <arpe1618@gmail.com>, Chen Linxuan <me@black-desk.cn>, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=2678; i=brauner@kernel.org;
 h=from:subject:message-id; bh=yYLCei2hd6WAKtp3LPJuTk/v4Dt+/iYgb76wg9LAdOA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQz+DkwvLz8r6N2uv+lJfJ6xWUqF3tWmgpnF917olsp0
 MXTsrqoo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMYEO4OAVgIk8fMTKs/LXNOkFgxvl9qZy5
 /SaHnkSl2R5+ZyYfv9JQ8FqF6uQZDL+YtzzbucGin2lzlM2G/9XrN9rzXp/97ZFWgUSK0d2zcZI
 MAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AF498140007
X-Rspam-User:
X-Stat-Signature: rcaysd4jken3a1h4hyr8hxniusnfjk16
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795182159-997989
X-HE-Meta: U2FsdGVkX18/g5XRAnjx1nuSmeVPq0RAYqnTg4FDZuAI2UxtjuJX3xXaBToWeGHbwZsHITST9LjZD05QpQZe0A7aCeUMfqycBstPLisgRCRCCC8z/PGUmQiIDHyA5H7ARRr0UHUI5E3MVUGcOjJ0mCJ6Yx0YNGp758MDJUj1q3vBnvzUmi7hDHuEo4mmip+QlwP3ymhOLeNjeDmbu0ImQnwJ1lLHQASM128ejh4KoTHavWXUjumHBwgdLve7mhA1DNpAOJfCJazn+5BKASir5j+Of5VspfPIIOrMQizHTZ6Ui+TDbt0N7I3byPL5cEMerlHwaCwBznKH9Qwg/D2FkhYi9ehrLg0t4QRrB2VWGUHgoSxJ1+bzmF10fcwmhZbdQb1aiOLLu7OFP0V3+fBmXboCsJH1udJRyRcF0b99viznoqDH0hpbn8Yvnb6r4Q1S459EAJbnBbs9RWYDNezOvGSpCFgAj+USJgiNtLJFxe1nEhnMzuEtbF2r6QB20+cF/eGqPpaQ+yTPN0MbGSOFvDpdUs17Ei9lOE8SOhxhbt51n5bN4cMDbi4p0M0UvfpJEFVC3jc0wAUQrXvYBEuKxSBlHbEJsAmJ9o3828lAjGk2eFvP2ndJR71mg0BTdbLSHQrCjZ3N4Gqnl4yFa//D2NG9YE3Et26pztQsBAST3xfB/WTZtJY2vXo69Hb2+zZGhDbXiZknNde/ImMPmuU9Z0912HOXhIsq/bXLcjjZ5gBeDl2qWYudwfngrWPZBuIAq9Y8k1rcxcwaQTlmbkNjj9e3xzFS1Y/Xs54hj56jST/UnSSl7IL/dspeuE8e42yhRzuFJcpk2RLACIE5inxp5ysvGcdvdsLB9p0lEPK1vzAxjuvrrP1B08/yNfMVvuIR44t2OcdVtgH12a2mCg2qJmm6xo3wEfsnvcskD1PxUCvct+PtZXufZBKPnmGEIrDrQ98I5wHNz7SdKk/kb2P
 +H0yI2Jr
 UE4KvKhog5mKSCLnwlr+9EUn8HBsYsQmYq4NtyRA2EYoWOvShOJpVxEz78pagb55XV1nyvYW5EF+Yo6n1m0NB2x3i0nApXZ6IuUx2shabYjvcaVs0RmzJstT0EnYPxkT/yRDO5hqS+l6UqIU1apUBYMQ2bXcgxfPH6Kw8PiR/fdHpEbmEUbS0U9/VQoZBnbPAs7WZcgIBjcpmggLEbY9BuFtfspDv14oln4e4nah+ioqLEkjBn7TAoLHWcNUy81XcYwvA7XYXPVJVTZcjHhXaAQEz69Tc/PYqOtOiQzcOGrtsgl2XFHVuqgVte8dp8O9iIdypfLbC9qqTWoLmTWLvwtvATOJwAXghc8tsaO+5SuJ/cm2/QVD3OynoDVh5kr2JiseQ+8e3BOd4sDU24ixtVUhPx0hd46FqqGpZjgvl9ybPjhcLZHIB7mnKthU9X39rC6fpQ/41gWZBU0wl6gWSYqyetT+jYkmOl8NnBHat6y5kO1+ZDvJXLKWGq3dJOv1kHzOZY4LAjTQADlY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Similar to the pidfs ioctls and pidfd_getfd() let's require that the
target of pidfd_get_task() is visible in the caller's active pid
namespace. The callers of pidfd_get_task() are process_madvise() and
process_mrelease() and both act on the target's address space.

Currently, a task can receive a pidfd for a process that it can't see
in its own pid namespace, e.g., via SCM_RIGHTS or by inheriting it
across setns() and fork(). process_madvise() only gates access on
ptrace_may_access() and process_mrelease() has no permission check at
all beyond requiring that the target is already dying. So both work on
processes the caller can't even name in its own pid namespace. That
doesn't make a lot of sense and it's inconsistent with the rest of the
pidfd api which refuses to hand out resources of invisible tasks.

Return -EREMOTE just like PIDFD_GET_INFO, the namespace and task path
ioctls, and pidfd_getfd() do. It's distinct from all errors that
process_madvise() and process_mrelease() return today, so userspace can
tell that the process exists but lives outside of its pid namespace.

PIDFD_SELF_THREAD and PIDFD_SELF_THREAD_GROUP aren't affected. They
refer to the caller itself or to its thread-group leader and
copy_process() refuses CLONE_THREAD if the new thread would end up in a
different pid namespace than the caller. So the check is only done for
real pidfds.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/pid.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 72b98d0f35ab1..530aa93d6fdb5 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -636,9 +636,11 @@ struct pid *pidfd_get_pid(unsigned int fd, unsigned int *flags)
  *
  * Return the task associated with @pidfd. The function takes a reference on
  * the returned task. The caller is responsible for releasing that reference.
+ * The task must be visible in the caller's pid namespace.
  *
  * Return: On success, the task_struct associated with the pidfd.
- *	   On error, a negative errno number will be returned.
+ *	   On error, a negative errno number will be returned. If the task
+ *	   isn't visible in the caller's pid namespace -EREMOTE is returned.
  */
 struct task_struct *pidfd_get_task(int pidfd, unsigned int *flags)
 {
@@ -660,6 +662,10 @@ struct task_struct *pidfd_get_task(int pidfd, unsigned int *flags)
 		pid = pidfd_get_pid(pidfd, &f_flags);
 		if (IS_ERR(pid))
 			return ERR_CAST(pid);
+		if (!pid_in_current_pidns(pid)) {
+			put_pid(pid);
+			return ERR_PTR(-EREMOTE);
+		}
 		type = PIDTYPE_TGID;
 		break;
 	}

-- 
2.53.0


