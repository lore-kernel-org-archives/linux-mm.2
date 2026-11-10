Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A1D607F09E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c/Ap+R4z
Received: by kanga.kvack.org (Postfix)
	id 1628E6B05DA; Tue, 10 Nov 2026 04:18:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13A376B05DB; Tue, 10 Nov 2026 04:18:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04F566B05DC; Tue, 10 Nov 2026 04:18:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D50266B05DA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:18:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EF961A03D1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:37 +0000 (UTC)
X-FDA: 85418659074.18.E752808
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BE9CC40009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c/Ap+R4z";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8RQTNfc/eWS72nZHsD5FmaXKvsQcX/MHrv0MZNEckg=;
	b=DP7ntqS4q11Tq9sRo5fvRgQh8owHDophTjKMRswYiWsXcdWjmWuJQoYsZFES06gsbd56xO
	GnKZhYcM8EzYHQpq34Z1qSPy8k8DrOw1HYFTe3Twu5kRQp/BRUs2dc5QlHjGU0eHh4cAlr
	RNbfFLWTPZtS3ExLLQZO/xSHJYn0EY8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c/Ap+R4z";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302315;
	b=LVmiRSComVmtodsM+JSAj9IlGzzT7ZSzNueMtZs9Xf5pCDIVsNuicm9m8QKDR0aRtrjlEu
	Y1UZi4NAVhPoKB69hxsmTlFtRO6BroKQA2DXUYHHe24QLK89uyuRnldSo2CALQkDymfO5S
	tzWJVODbcghsrBcMuXIULNjdamHX65U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FE2D46A87;
	Tue, 10 Nov 2026 09:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20071F0089F;
	Tue, 10 Nov 2026 09:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302315;
	bh=B8RQTNfc/eWS72nZHsD5FmaXKvsQcX/MHrv0MZNEckg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=c/Ap+R4zFMvV3/8vcuIEPdB/Gt2XHUlHZTBEX28zCRTGUeuDJCvLmXS2bTYSdzi9R
	 0gr12Xdu/wNWC4bbLqs4TiHsR/YcW9JNs28CEkwEGUBB6TGWOirP4sbeOuKd4a7tZW
	 afM3jYlHN6+MVYSwuAcf1MRkadLxCZQa5Ry8f4ildqJfo+Wt7K+lGKrO7TizAPDeis
	 lj14KsNBHSrSqgHUxSQyH2WPPe6YEGnglY+yEWWsL8vk8c3l5TKaUlKahI+HbhISLF
	 nnD6YXeLZZD0ZUXVgvIwonj2iwv3yWDlAmtq4vfzLGXczqU+vQuxgOQWxGbajWp8T+
	 zqYWbwys3SKng==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:39 +0100
Subject: [PATCH RFC 23/41] fuse: use fc_init_pseudo() for fusectl
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-23-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=893; i=brauner@kernel.org;
 h=from:subject:message-id; bh=hjM1iJ4vU3paA5L4OQPDkADa3AqUdKJFLW5EmBnT+kw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erCuT2albMuTpuPqTDYzVbc45F0XFJ6y9xJTg/iJB
 vndWrxNHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPh02ZkeGybnbLv4dlnla2P
 zh+U1FV/fVEjuEXs+QzeMzuWCLwPtWVk+PIs8Nv5vXPYWX98mZbrdj9iVbPCut91O9M+rQ7YuNr
 gHTMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE9CC40009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: j195qs3s9ynsi84ribam5o8rk3isie1d
X-HE-Tag: 1794302315-311512
X-HE-Meta: U2FsdGVkX1+6S+5n5xI8Rh4ijliu0/uM1VIBw5YEmu1gYtIuYk5SB9siMEImaBM0BQ5TdTCOrQxygtlwsfjR/HL3ZBs0WF0t1DMisxeX2FgFfF3mrKDgBXrtAhnhzxPBFmHQaOLLHs3oeifLh21cPEEyErAvuq9cQAkZUjpW8iRRWhTqsucU4BZV0bnodFeLkSk7kuI5PPe6khaTB7ApURjpofACdRR/LixGuxNM2GSNJuVShw/ZNObfdNtJRgGm+eak0fd1wcLa+LA0VtkrOjsZoXol1268lv7Z3BFrjngdNV3Yhi0H/vIAJguWyScPzr9veyCAWU9uXKUOYodvnhGzzqrVm7NSWmolrGeo1K8UFn8+3JhKw/bko3os33lzwdYV/YFi3lU8mreUDeyDRp0pk6mGLZEkkLOXINgOR2NScWrCL2TRDOsEK/tko+QnTnntkr+gRMbONiaKCuIkSJdtgIj5DTaBkw9QAInrTdqKZnHA25Y0BZ736SSV+nwxo0lOSVQWh5z5AzaPyE1tyZodzw0OdNE0FFO20ZT5LFVltz8tMlrrRGe1tDGlr1VDIAibBDzzWXA9RL+JtXjBNrgjlxDQm1+IU5ag3NN9Z0lOzLJk+zCn06o8nyTHiVH5rrAsO1BWjr6uxGsfESG/0QAveM4aGb0YoMbOsy1Q3QTGYdtyeEUQxEjtnaiuVFyhAHvejyDBJonjCR8/X9ylwLxyucpnxu3plrBglig0BSlS78A4Vh/qnbmMQ/jlUeAHJFdu0EzDKdhrKszpX4UPrgYWcq9UX2EK47QtzImIk8Sok7xnPti7ZG29WfvlGEPC9zL3ejAfdAPUqlIoT8abVTOHgfiIuvSyyfH2bYuiuzWzuqmxuAQD0SamYdXHfZ0gWt3mFO7Emd/7rNTuoPldeaTEiPTVHZkoMDO/jtEyGJwRr05OKqaB4QYJPr0lSjjVhSsMdZhucajulLI4wLF
 dA8OeB44
 ex0XrvJwqsO3H4uUA8zDE+N+oZn54FKFvYMp+tM8+JZdMrPqV3UYgDE13f42xm71W6mFjHkkbQ86YrNvk3Hrz8+n+EdOmXHya7JiFzp30EKg+WceegWn8rdgJdyg/MWWLK+ZIIidy6qt0Gh4myYuZInh5xkejc/I9C+F6mJiFIs9Su4y7dM5t0KSgkMKkFM8JxlViIYqdcEgBObSRCFpr5wv21EnhXh4YiiohqpxViUxypImaqXjWzrLSUFzv1MavKnCu9wno03C/Ic1d08bBXhS24vNfG67lcvEXN9KsaEpJZaTtJRsMfwwh+ujVfI8pU6KK5brX9fZ7buk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize fusectl as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. fusectl never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fuse/control.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 21ffde596d61..4497362e7df0 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/namei.h>
 
 #define FUSE_CTL_SUPER_MAGIC 0x65735543
@@ -334,6 +335,7 @@ static const struct fs_context_operations fuse_ctl_context_ops = {
 
 static int fuse_ctl_init_fs_context(struct fs_context *fsc)
 {
+	fc_init_pseudo(fsc);
 	fsc->ops = &fuse_ctl_context_ops;
 	return 0;
 }

-- 
2.53.0


