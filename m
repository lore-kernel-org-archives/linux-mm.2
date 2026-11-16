Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4A0A606A334
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iI/0Z97T
Received: by kanga.kvack.org (Postfix)
	id B70456B05B4; Mon, 16 Nov 2026 04:44:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2B36B05B5; Mon, 16 Nov 2026 04:44:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94BD06B05B6; Mon, 16 Nov 2026 04:44:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1B96B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:44:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4D64A86D6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:44:51 +0000 (UTC)
X-FDA: 85440497982.28.98B425D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 44801A0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:44:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iI/0Z97T";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AskB65cJoQPi1ReB9/fhm9DblVUbyR84Mt3cKfNU18o=;
	b=utuxTTRzwvrhOhi3NXMVNDQuaShA6Ay//+ibcin9BN8yyL6LD9Sb6Br9uchnqaC3CM+Thx
	KBvaNIR2SCb+c6+chT2zbXrlT+crkjmGVpypbR3KlfCTPV4gbLpexqRjadVjxX6uHEUy41
	nMYBDpcNW0g3G1JFqJD73OSQnevgC4U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iI/0Z97T";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822290;
	b=I7QF9Bnko6TQF19xiiUT+ausGEjy/+CO6l15yEO3Xrw9UJ5dQ58hKOg04Bmg+VbMNYVHlO
	Y/ZJEp/9d7hfMy+HTtOOuNhnK0mw2T/1i3rLUsRrAuiWcWaZ1uiU7R+LUtblRZw/TppTQl
	FnO1DkGYEDeIQTCAWLD5zggxwbPxBcQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D89546062C;
	Mon, 16 Nov 2026 09:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9776A1F000CA;
	Mon, 16 Nov 2026 09:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822289;
	bh=AskB65cJoQPi1ReB9/fhm9DblVUbyR84Mt3cKfNU18o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iI/0Z97TWHJleWpplJITR8BJD2TN+kysLffD/3YQi1CrI0V4jhZQmJIVpvC7bmZHV
	 TM2A1F92pLjx8FyZxIVb025qs6dEIrLMkpEOhwpXqWalNqgCObsQS92c7qgKsOhAtS
	 NjzAGLscXobqFbaRNu5MHELODgktDkuvis9XMQ+M65lh5FPzLvWIv3ZXvc1HvF/Cmx
	 Ibsmwpp9zUNOG2yB7hHJ1BFvimgoJ8PUEQD1B1RhStmVOS0tM3vkrptvJWm7f45yVN
	 RLdzaPkT7LyB7rnec8t/XwNNe8pV+QnH3WAshQ5cVBT4guI0jRCHPvkkku/CTj8PYj
	 OuiIKWVpkm1EQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:01 +0100
Subject: [PATCH v2 04/13] bpf: handle errors from resolving the real inode
 in uprobe_multi
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-ovl-d_real-v2-4-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2035; i=brauner@kernel.org;
 h=from:subject:message-id; bh=w0jMvi6Aqw5YdOXmHKxBMEO2g+Q12/7kbngiQF5xj0Q=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulC0Ydnb74y8sqK8fcc3z3rrHDNDYoZzSrDLvWz/h
 LXSG3yYOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACaScISR4fSDtNDa6Mf/Q/j5
 V9zjnL53d1CB1bMmcyPXupyX1XpHMxn+Cr1fp/5s5tyHt+9GmlpF/7wd+oNj6b/6P63Wu49opv2
 cyg4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 44801A0006
X-Stat-Signature: p98is41j4amff6buem4bj6brb4hi14fj
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794822290-965336
X-HE-Meta: U2FsdGVkX1+8F6lbJDu8uCOCUV+WtNPFu/4FvwAEcAkjnWQ2F01CA3Xz8XPy6ulrvYaXnuSk8GyvADsJ82ng04c93GN1CQeZQBTLlgJ708PnR7Oh+CFJdiBZ3teR4z+1onjXKyDzy0s2z3FG6paK1z8/8w4SJSA1RnHE8ZUHoTPCrFmzjQ94sRc7u18+rjs3UqTNz2ZaOuVNRDCccORR6t2EGT1v9opSYlSE40kikzwg55A4fu+nUQhRe1xyDUUWxiL695Z5KabWAlFeFfguYvCjwwwGn4uaH/I3W/6OfG9fGNZEj/2fVENkERwkmuozOjT5FcDDU3tpsAc9fuj7vHIASTmyopD3W1Xc1G/El39FDHWnIoXMYUe8n4pF9eoltk7o79YOc619XuEiTClybGxrTyPsCBCZtRzChY8HvsDLhNyhQq8bRQ1mFg86leGfSCeF5xl35c9WiZCnAyxcnUOjRs/PMHhKMEEJdYx5GxrJ/wa/+kAAINkIUHQVtXneP0JaJKpU9F5aBeO2TN13ZJrMDQ4YyVhPhxRF3ykfh+PNbDJOUIyPgR1HnMz3vfGj7qDjCb/sK7OTVKsbA6KUb6Oj6LsOfQ7pm+uH82X6mFf4/RiSnqI/mp2ST+8V0RHtNEjrm8YlXPAN0ABNUlmWeDwHH8Emuq9ffK9/un1N+SRMsgei08t5iDMvcBZujyNat+6VE1hq0p5kyB8VZG7R+lMaxr0YC1AqwYr8JMqiO+QWacUjFfTlQMJ25Fkiv/i9xGWeHth8eil/JV/OV5byxFFmqdQKITqtOBJRGF+yzIPgQoxC1/Y+IqiMPXyfycSQVmZLyZZQ6P6/tr7R5amaOW4pTC5HXImZH15VaWPOxa4DzV1eQP3fEQJUeUcaQftSo3/SiEFmIdGdlG0wM3IfOYjq3z9LOvGNhBia0t80I9QzaGjl8LbMQkkHntG4vdd0AShBPn8u32rPIcwB/y8
 9gee0bT+
 R116aye/3k3itp0nBmYmBv+WURVUfy977t/mwJjk4/Yb+XbC3L1cCKiwb4Alx3qXBVxRjg1ywGWBeBKh2V0xWqcXh6KUF5cXeOrEo856ZaiSFQAp4Rnrkmo9UYz2QspcuSHPcZjVekbfL9PnOSligJIkmZi6nNBZWgPJpepG/5QOy9VjT0Q8i6XjESR+jRiZVbanhDtjp9Cjkz4uANHlEOBjOcEHAsbhrITBvwn3OYTf4LeCwV/g/WdJOM7TWI+cTnRth7qZj32S9RqEP5+mb1n3ES6C4uM6wOldTb/GwlG/F5UKqiTFcHFEt4yBidTteb+XZLJFH6rjz2vg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

d_real() is about to be able to fail for D_REAL_DATA. So switch
bpf_uprobe_multi_link_attach() from d_real_inode() to
d_real_data_inode() and deal with the error.

Currently, the real inode is resolved again for every single uprobe of
the link. There's no point in doing that. Resolve it once right after
the d_is_reg() check and fail BPF_LINK_CREATE with the error if the data
of the file can't be resolved. Then all uprobes of the link are
registered on the same inode.

This is a no-op until d_real() can actually fail.

Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/trace/bpf_trace.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 2aec56d7f3d3e..15f32b971326e 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3280,6 +3280,7 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	struct bpf_uprobe *uprobes = NULL;
 	struct task_struct *task = NULL;
 	unsigned long __user *uoffsets;
+	struct inode *inode;
 	u64 __user *ucookies;
 	unsigned long size;
 	u32 flags, cnt, i;
@@ -3336,6 +3337,12 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 		goto error_path_put;
 	}
 
+	inode = d_real_data_inode(path.dentry);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto error_path_put;
+	}
+
 	if (pid) {
 		rcu_read_lock();
 		task = get_pid_task(find_vpid(pid), PIDTYPE_TGID);
@@ -3394,7 +3401,7 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 		      &bpf_uprobe_multi_link_lops, prog, attr->link_create.attach_type);
 
 	for (i = 0; i < cnt; i++) {
-		uprobes[i].uprobe = uprobe_register(d_real_inode(link->path.dentry),
+		uprobes[i].uprobe = uprobe_register(inode,
 						    uprobes[i].offset,
 						    uprobes[i].ref_ctr_offset,
 						    &uprobes[i].consumer);

-- 
2.53.0


