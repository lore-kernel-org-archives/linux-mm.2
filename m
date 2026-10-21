Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A438606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dzxUeoNA
Received: by kanga.kvack.org (Postfix)
	id 7AD126B077A; Wed, 21 Oct 2026 15:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785136B077C; Wed, 21 Oct 2026 15:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69AB16B077D; Wed, 21 Oct 2026 15:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 426296B077A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:58:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6386B804DA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:58:34 +0000 (UTC)
X-FDA: 85347695748.06.47940B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AF1F91C0007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:58:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dzxUeoNA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792612712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u+4xmbdLU1mrrwnt1X/d3bWQL9p1KJ5CSL5nr0RSS6A=;
	b=6FSrbW8Go68mffS848XZdG1p0fiiAzLYuWLYkDddhJEDlvCFK/xekqeaMgdQV3+iA0g7Nv
	Se+6JdL/EsLa3llPxTI0MDzJLtAIhrazpjG8xQQrYdrOb+B+V5u/HLKrRzUNnd9KjL3Mhi
	wKpJRgmcPBxy4cYPPkpqBHCMpCK3zq8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dzxUeoNA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792612712;
	b=ZhRb+0EWB2CVktUKoqOxbJkas7brATLr9JQgdyrbGPcFugZOr2znGXO75v462vbjGtuLLB
	iOc2x9Q9c4BpC51V9ZTSv2Fb0ot7ARuPZfikOkIZP/C0cq2fk6166fyj1zzTqHm3KCRBfV
	9FAGs24pY7W6zooUltFK9mGLbu85UDI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 063F04323F;
	Wed, 21 Oct 2026 19:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59201F000C1;
	Wed, 21 Oct 2026 19:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792612711;
	bh=u+4xmbdLU1mrrwnt1X/d3bWQL9p1KJ5CSL5nr0RSS6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzxUeoNAVzeREkTXx4wpn4Qz9g7BTqmPmF8DOIwyFvv1g+LB0blfX5Y57KNABZV3A
	 g/2/BZq5FB2fi4SqTH8eeQH3T1SB7A0SrDT7nGObuHcG62icIencAySky6nGXKpq/2
	 R+9IzIjT8qrlXaXGzWWeehkxVZQZon14itVD+u1iAvpxC7Z+BTCz81RFliiVDfL3DB
	 YX9QlkVG+ZNID3JwLLjIAmAQ3YKlf+dptoW308wFGqrtufjlooN5qUCIOv0wYOIXas
	 0wJPDbnWuSP0Sjzf1rici8Dpu956XQPnaMdKE8UIKBEDwtyNWDATkLxKhjR8rmygEf
	 a/U1O3MJ9GYMA==
From: Jiri Olsa <jolsa@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [RFC bpf-next 2/9] bpf: Add uprobe faultable user copy kfunc
Date: Wed, 21 Oct 2026 21:57:51 +0200
Message-ID: <20261021195759.119421-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021195759.119421-1-jolsa@kernel.org>
References: <20261021195759.119421-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AF1F91C0007
X-Stat-Signature: wx5cdh8q6fnrq71ek3yaj7h34seij3qg
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792612712-225752
X-HE-Meta: U2FsdGVkX1+Jg68S5CWCGN2NTH1pECXWVnWQvc1lgSHU/2L+nqDMnfKi6dbMIk6vebNGsHTUemTHql3oOlunH1NkxliAYfW6a3yOmULhipAEwt0GmgqwsQIug8VzawvGY0itJOpdxir+OGsJ+7pBYOUSbC9Emmr5aeYrdSt8vqNkHnAqgQTME3I9IdOolms0pDf7bizWg/riFi+hku+eXxGGSj8EQ19ki4qcmVTsZzdK4JHWK/nKJTr6zO/JjFfuYJp6Dlr8ioKbTpZyfT5tjjzeBkH+K0LDvj2yIQto6jSQt7yKe6NCxiLpSRG+aXhJsels/QZMdB1fzD/a8W3xEasPCwMgAAeh7qGsgz2NaU0NsSEGZefXcegvLgjhFgUv9qUecCZDIWPfWijxhgTkSN8vASkIx0mMyoO+KjG4tZG+sJaVwP/qKEnBkEDHUsJzUdMGnBZLVXDF/+uL2JYM1S0CtByo5++DdHamgvoNljC/vP+DbYaOzFQH1J2U0GqerTADpIgANACz/2NT9mgyznt22/undvKW7Tvccnd2JzRigksJtLA2a77NzQQpiCCcnl5ZoYS43mnmZrunGVtUo4RN3vj1TUHM3ARastmB4nRBVddMWSlDS+dfEDJnmLPZh31ZkOb29q3kdKunHyG+E5639zMTTQuAbgRDeftN1RgTklI8wtENfXemqSUZlFNpYXd67TaJ81N/qihr8+wscn7srFl6nyYcQiTi/b3z/vH3G5eogFB0h9yjJyOxXdko9lo7QCFeOHYm7e4ioJm0zGAd+JgS2L6WRDDvCGpehsv84kMMtANzsn3ZHrICpSe+44S3ufBZBOyp6faOiizN+ZfbNHit1P7CqMlYVgaDcD1ZAnlllBo7ic2bU7rStB4fTzEcN300JNrHe4HMJnf58otnMrkjVjXzGP7+9Es3BqqJ/IzWwYWJBUA27tzaFGngEH18Bwm8KT+KoeCosDt
 gtbCY/MF
 vKoovFyF/UpBVhypj8moyNZtGIW5pW9/CUjfd9IqX4Tjzsujwx2a66u7lI14oftHa8+/e+fG09u1d0lB8Nor4Zbwy6OXsdbb8JhMjl+d8Dqxx1aJOXsS3nfmoSH1+Uzpf745b9hDCKO7jYgP+1YolrwT92cnkj7AOo6TKMUYXyS0z18Ixvhc1aHF21/pjS6FC/Co3P7ryL2D/7drw4Hs7SbiUUNATyRrFbcSZG6nJfLaNsy7FMyM5ux3TUL6cXfBSWAUrnxNju28O4jkIr1e5Z4bwq3u0e8TmvW8QckGAxPL15AaBM6K24raNlXcDjTQmLPSm/xJ9zST96brPNBVt9J3zsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The bpf_probe_write_user() helper uses a no-fault copy. Adding kfunc
that can fault in the destination pages while copying to user memory.

Restricting it to sleepable uprobes and to LOCKDOWN_BPF_WRITE_USER.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/helpers.c | 57 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 648abe1ba63a..4d9e9423826a 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -29,6 +29,7 @@
 #include <linux/task_work.h>
 #include <linux/irq_work.h>
 #include <linux/buildid.h>
+#include <asm/tlb.h>
 
 #include "../../lib/kstrtox.h"
 
@@ -3738,6 +3739,36 @@ __bpf_kfunc int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
 	return ret;
 }
 
+/**
+ * bpf_probe_write_user_faultable() - Copy data to userspace with page faults
+ * enabled
+ * @unsafe_dst__ign: Destination address in the current task's address space.
+ * @src__srcptr:     Source buffer in BPF-accessible memory.
+ * @src__sz:         Number of bytes to copy.
+ *
+ * Copies data to userspace, allowing page faults to resolve the destination
+ * mapping. A failed copy may have written a prefix of the source buffer.
+ *
+ * Return: 0 on success, -EFAULT if the copy is incomplete, or -EPERM if the
+ * current task cannot safely access userspace.
+ */
+__bpf_kfunc int bpf_probe_write_user_faultable(void __user *unsafe_dst__ign,
+					      const void *src__srcptr,
+					      u32 src__sz)
+{
+	if (unlikely(in_interrupt() ||
+		     current->flags & (PF_KTHREAD | PF_EXITING)))
+		return -EPERM;
+	if (unlikely(!nmi_uaccess_okay()))
+		return -EPERM;
+	if (unlikely(!current->mm))
+		return -EFAULT;
+	if (copy_to_user(unsafe_dst__ign, src__srcptr, src__sz))
+		return -EFAULT;
+
+	return 0;
+}
+
 /**
  * bpf_copy_from_user_mm_str() - Copy a string from an address space
  * @dst:             Destination address, in kernel space. This buffer must be
@@ -5139,6 +5170,31 @@ static const struct btf_kfunc_id_set generic_kfunc_set = {
 	.set   = &generic_btf_ids,
 };
 
+BTF_KFUNCS_START(user_mem_btf_ids)
+BTF_ID_FLAGS(func, bpf_probe_write_user_faultable, KF_SLEEPABLE | KF_PERFMON)
+BTF_KFUNCS_END(user_mem_btf_ids)
+
+enum user_mem_kfunc_id {
+	KF_bpf_probe_write_user_faultable,
+};
+
+BTF_ID_LIST_SINGLE(bpf_probe_write_user_faultable_btf_id, func,
+		   bpf_probe_write_user_faultable)
+
+static int user_mem_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
+{
+	if (kfunc_id == bpf_probe_write_user_faultable_btf_id[0])
+		return security_locked_down(LOCKDOWN_BPF_WRITE_USER);
+
+	return 0;
+}
+
+static const struct btf_kfunc_id_set user_mem_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set = &user_mem_btf_ids,
+	.filter = user_mem_kfunc_filter,
+};
+
 BTF_ID_LIST(generic_dtor_ids)
 BTF_ID(struct, task_struct)
 BTF_ID(func, bpf_task_release_dtor)
@@ -5266,6 +5322,7 @@ static int __init kfunc_init(void)
 	};
 
 	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &generic_kfunc_set);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_KPROBE, &user_mem_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &generic_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &generic_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &generic_kfunc_set);
-- 
2.54.0


