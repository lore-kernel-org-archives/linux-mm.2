Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F2C60A381A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BKlN1ePm
Received: by kanga.kvack.org (Postfix)
	id A8ED56B05B4; Sun, 15 Nov 2026 09:02:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A401C6B05B5; Sun, 15 Nov 2026 09:02:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0186B05B6; Sun, 15 Nov 2026 09:02:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68D0A6B05B4
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:02:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00AA7C0740
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:27 +0000 (UTC)
X-FDA: 85437518376.17.F2C243E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 10F5080005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BKlN1ePm;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794751346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5oUYGBoKkBqpSXIVcJnlDk8QcSCyfAXF5SKIMuUlOHo=;
	b=wicueO4046c/dOu6YqgK1te1YHqY2Fr66cgeRUqYWIGpKCpo1SbIUub7nHj2EkdFTidfLF
	2vasEWIjyiQz5wKS79FlU6GlPJNb5ufGa+rL5nufYted3k4KFo3P3t9tkwuNM0KuiyPWle
	Jrj6CsncBKGuPjgLNOcyF9SlmcDmTOo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794751346;
	b=MfHeHvetdPBURzZv8TPuvF98wcHpBXwpaPluvGFjo4Np8NCyBgPlA8Jqtr+dXXOI7cRmEN
	YXVUXxd+ruAzRju1JkNHnPb8ETd7dJmgbr2UD5cfE1vPeA+Q2vR34V3JES/kUeqMm+DDqb
	qBwL6qP9VuhD+FCl7YSoArmUyWkThLg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BKlN1ePm;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64C0445AC7;
	Sun, 15 Nov 2026 14:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C463E1F0181A;
	Sun, 15 Nov 2026 14:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751345;
	bh=5oUYGBoKkBqpSXIVcJnlDk8QcSCyfAXF5SKIMuUlOHo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BKlN1ePmcvZPicZgSvyq2gFmq0LHU3RqhRWTkS89/oQQ5sMgH2mlZnbAGJYFYdVnp
	 CiTplMFlor+54osiSyJdokh0dOvWtdDkgTOa98BfA+GMnITM07Hd2rXbsZG9gez7sa
	 6smUBtR2bo5UYS3zvF7Rs8jMyJNBChu+d8PChicys8H7WUCvMmlF0BypywlI+bzR9J
	 0418lL6aBSmkiaiVMSy/8C5P617iY+VppR2k82Ks94lnFi2ANSyYohUGS3pe12PnUI
	 2jJ8sQmlCN2i+kjtTZX0Xcwta4TJe2Q4BMSUOfI+TQLc2rl4zkN7kvUe/uHGs+1IuU
	 8mpNAyJ2rZ57Q==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:34 +0100
Subject: [PATCH 04/13] bpf: handle errors from resolving the real inode in
 uprobe_multi
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-work-ovl-d_real-v1-4-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1988; i=brauner@kernel.org;
 h=from:subject:message-id; bh=viYx97t2m4wJXNi6UiuGqezFK69cu1tybe/q2U/ijp0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B3S/t3wrMhMnloe3abb9kvuuKtx7+HYL3pxQ6Jg5
 VmbwiOFHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABO59ZqR4ckGD1OzKceyRDzX
 x5zvXScud2D3F2ct1/hcAdnEP5M0lzMyTLvkMYd5xS5PswO3P2jqHnzjWqf4L6PSyOTV4Zggfe+
 D/AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: i7z3nys1z3qozx1ieowxydbirrp7k5nt
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 10F5080005
X-Rspam-User: 
X-HE-Tag: 1794751345-591917
X-HE-Meta: U2FsdGVkX19ll36QiCyKoR8kmGeNFV18/PlH83P+9jLnUgyGsUNoGRdbncncpfsQ5lrmi1YnpGtSGfZmwANdUJ1c14MMWwvPPzS2qkNSiWfCK70Bi+nbdCwImHnLl+KG8R5ODaXJVCtZvZYrIgJ8ItUmquhimHdt8aXGjzLDe8i7Nfii9Y2ACkCrwtEVtB2+MOc3sUujrPjhgkFv6zfCAbkhzU4i6my/+nxyhZaWCL+GxxEnKpjv84kfZcpmptzymINTTOHLbbHF1JHBwvxkxSPBEfKDWZ24gqcjKqCfcjA3BjeOKhOUmxs3GqiEt1c1VtPk4oWHkqugs7sB4HAKfJmJL7k6x4R5Iy92IfQeVoRWtGbykB+h8gVDNIMll7WQNLJo5MHfbo1Xn5jygWfgk9ogVjSElVuTaf8xD32I/n18tyBwqWkq6xuuEBFhZs9zz4ks+dMxAzBB1wO6HnfK0Xxj1vQYKlcx9dhYWLF0FwENX2nHNmeI9AGNe5/CuyQqRlAq2zSZHOEexqOSyBs0TTdsX27wUQGobAMbzxm2YD/XJiliOnP2Q+hB1zqDNZCcu1HR9UJ44R99dcT3fSMZ7ZTskf9OU3F6pTM4/3kjT2VkYJQ+vRNfeqiY+5i+5bA7vy/nktTAIolPV1rbxj+fyS9C5AhWE+Bwq0AmvAlLoLmfQ8GAvYhzxoC8Yuk0sCMoVlfEAVEpOso4jpNPRV2vzxPzhqAMrJ1tFhujxYwtyjlddCvtx+DVgjL9f9oa9/6aB7KaCo+y2rdhzL12diOvCqN4vJYwzPMm8c2pv8YMouXG6vhQTwaCKk+lRhCVhut0oILsCumKwY2eKroivQwiv+WfWMvzSikDdJ4IT+lqZ1TxLT1cKfVx+9e+eeU65HZ/hT2EVVk6wvJ0eLYifmsmmDQBeVyh/FXw8pnxc1HwZwBbgadhJIWHv/EtIg6a7RBQtIpar3sQljQvqv8tzSE
 +3HYTmaR
 wrr+8+tToZd3YJosCQK8kRU8E6Npxncp5TChYcvPmXXl+sWtAYFKs9YwhDhNsUQGQpUfVnXFmYRETJwL2LBTBH2Oz+C7z8iADRhPelITlx2o+yQ0po+bwSjTWU9IuSmO1RSS1s1Mgq9jGIlkAxRQqpPfPAMufcTZ7EHPjuGwPPYGTYSDfbllbUjIOP7AZY2FpYu/Xeh21b4eKnfPQT/VlPUTMY2ZglrAbdg3yFOksi01dsL0tRMPumPojnqaoHVRuZaAuYfqPruy0LeOUygMC2ksCYSA0C/BzopK3jdJbv4fw7fIcPzxK8v7e+Ttcb1cB6lSs3PaONATb8o8=
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


