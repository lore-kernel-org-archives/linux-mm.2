Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704306072F57
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GU5e1n38
Received: by kanga.kvack.org (Postfix)
	id 8668A6B05D5; Tue, 10 Nov 2026 04:18:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816B86B05D6; Tue, 10 Nov 2026 04:18:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7061D6B05D7; Tue, 10 Nov 2026 04:18:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC3D6B05D5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:18:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E00C540138
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:16 +0000 (UTC)
X-FDA: 85418658192.22.6FD6321
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00E85C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GU5e1n38;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmz9jtGW0ywIGdBu3NtUNt6417QseUuUlLq+Fyk/468=;
	b=OwCTlyOKzFYOsPVbHOTxiUZ+lfP4Y/xcgVXrctKTsEx5jUR9KYrRpCX06dsCQLF2GzZ5EH
	y7wOQvWRNpgvv41+kCG8CgMU5hNuNLWxC23xtDr5kn7hEzvwCrnSGoEo2Dy160ttoJDFVl
	cCZwli7g5949ahZHFJNYmS6yi0Xke2Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302295;
	b=qelMHAtvoh2fdHh90SM5rj8g29Inu3Il25S1b6YzT7938u2+IEo3p2Y2Rd51ybKj+9pekK
	ClEnfBL+6n6ydCb0h+/JWmMaFLLhsxLNPlkTO1BlcepAWBHWf0/U0C5fpT0NfDINybkBVN
	Zk/dvgMX5LIQX47uIBuZYMcKrboAYFU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GU5e1n38;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45B8340942;
	Tue, 10 Nov 2026 09:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9521F008A1;
	Tue, 10 Nov 2026 09:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302294;
	bh=pmz9jtGW0ywIGdBu3NtUNt6417QseUuUlLq+Fyk/468=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GU5e1n38Lz1+Pvtlp7ASXPOHCHk1tuIpx5t08Oh+PNxIh+4HMt2Bb5r94Whq3GWlo
	 vECtZ0duG5TPPJDG1ybdWsZsjAOMuPW/Hb9SEcHwoBF8ATO9BDk3/jhbKvQrg3nc5L
	 1FQsP8KdRKjEyM/BeO40ervx/1NH/WjEJwBb2dvNJPa1GvI7Agf8ZAOGTuuFGlrw7z
	 D4QQjfoUytG04RFCySWSZrW4de4972Y7Kl9IuLxvGElxSqCx/Kci+Zh1lbu+K45JKy
	 ntgiJAxTVhCEzFNboe8IF1iAKS/5NRv9CmLgmQlqgdr6yjLdjFnSiOaCzyVTXMbBQg
	 iNtELDfUm8+4g==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:36 +0100
Subject: [PATCH RFC 20/41] apparmor: use fc_init_pseudo() for apparmorfs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-20-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=975; i=brauner@kernel.org;
 h=from:subject:message-id; bh=eM74gHkw1JzhCTiSqpoG3xHbWPNk16urIeNgeqxQRac=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erD6usJ7lpTrW3d7tqQWr39pN+HRX+O0+aeqRP44P
 Ht3WOOFS0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBFvBkZDujeP1XSFJdyYUFQ
 s2Z8R5AFc4DNtoZ3s+yre146fp5mxMjQc+SfqFrmzJ/TQj/NlTx9oGXNEve39ZbnKwSC7mx/vmg
 eJwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: 53ij7ke14dskyubepw6dcr78juffdp9b
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 00E85C0005
X-Rspam-User: 
X-HE-Tag: 1794302294-843834
X-HE-Meta: U2FsdGVkX1+n8lx5CGYsD14CQ26rlSIO8n3y0bFhuK1RxTC9eL459beQ47zijKNLIFD/oxa9jNFPMarbp4CE+uRmQF+Eom3HIhrZ+b2Wzluq0y7oiFaULpGWXa6wYjafCodleZSegcfXbTcn6XyKqC+aqg/ApE3/8ngmDcv/IUv73LNn3nrrLaoDJ11ckD/5d0FGPwV7Ziy4Ra09vheklXQ5Q9gZfAb9Tp+JYP2uljY4zG4FvVWWjV+XPEbOFrwCE8uwBm4vdGKKm6vJ16mU/3TsBl8q2YMl9N2gODyhXZkAHF7zhGwC1PoqCK/zX2krpRl7slbqolwF1ZBLkfVnL/4w/34jf+7dlJh/G2zvL4jjyc9RBuaXE286hSDMaOhbRzeKc9fnvcbuxpSwSIEZr/pvJboJKK9XDJaI8kHpCBj6yRwImBtthfSH1j5RF5ItGhwXGxmk15W8fVnNu5/f+REx7r7l3KpYfEbqFoMWRqQ2Jo+LgNFsu4BT8tDgSz2j0qClBut72Qfbgw5qq4Ak8t88grsPnKbzBsaGtFYomMFHBiw/QigvBjNkMa9PD/rsR36K4fpJUPQbCsTBkLfKxhkIBpDhUrXlaCQOY1pxu5wBa8RFz7b4rr00pozupjB6SqFZNnJgZUj/t+GOzK1CP3761RRfFcqJWemi+j7zEupbXguzzuU4cK2OJnQPOxocgnLIQw6O7ZI0SqOCAD3L5Yv7/VgShnRvdMBNs4Dx2ma0GRqMCzHchfRLSWvOLoDDTus54c43aoqimJtWoPa3hMjwTRCqur482eTetB4c9rD/EfDHfu4enARlSXdw+6Ywa96edw790qyp08ORYkuP7KsdHFMIvSJWYoHr7MHxefmLFzzGwry5hpdYPe3IwXuqUoeEhazIgaowwIDbkC1Co5HRtBXV7HkRt412Kt14iGQxAEYgjcpv9G/RK3E/vYSkS1X6Y9Wadm0MGi4vb5y
 7pYOwzzC
 fGLjG6ijmyfyoQ1ASIp2BUxwRYrpGE/mT09wOnfcSJq+AURQ8NyAUJGWJb9CmcjcnZoHqkEsSWG/Qu3ZHcdoA5ZhC8IHSNlI09HqhK8tHNALnwgGYGH5JAYqbDh4ksbfdsS2y4KbNThvZuanTWPFmFs+LPJc3iiJhjQpHB7tQAYIJHbz7V49wqPBAiYkzsVU10mpPgNTN52tZFFIzf2l1veEOu7EpZREt1Z95ecOUJqxINJqy3TR3yWdyGF+NyyDduPmLmHTjdaK4sZRndg46DF03bA/nycfLVINv79YIT+VuJXFaIO06ghIQq2Tp+z3za8frJaYaXqOv8yfE3eWpKCF9+5FpMBEHBq+8dsYGZSaMBRY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize apparmorfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. apparmorfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/apparmor/apparmorfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index a99366467217..351ea3a7120e 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -21,6 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/poll.h>
 #include <linux/zstd.h>
 #include <linux/string.h>
@@ -263,6 +264,7 @@ static const struct fs_context_operations apparmorfs_context_ops = {
 
 static int apparmorfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &apparmorfs_context_ops;
 	return 0;
 }

-- 
2.53.0


