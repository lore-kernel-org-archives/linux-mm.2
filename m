Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F80B607612A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XU5FYslU
Received: by kanga.kvack.org (Postfix)
	id 841B36B05E0; Tue, 10 Nov 2026 04:19:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819976B05E1; Tue, 10 Nov 2026 04:19:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72F466B05E2; Tue, 10 Nov 2026 04:19:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2326B05E0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:19:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D139CC03E9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:04 +0000 (UTC)
X-FDA: 85418660208.03.C2629CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 056F1180002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XU5FYslU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V9O75TKfTcHeHVPMLenNiZqGn0S/SDcuL2HVenCDHeA=;
	b=ET+Ae9aNbH/SDbOgLKKiXw5zVg2siKxvJ/T0UKo71ek9tBeX4RpWQa+eJSVBYuBFBnZ+FQ
	HLSbKyMiMKgztAJ71ZB597HA2sIAER7t0A0ATYFOX4mco252dBsJyjIJ/BHACrWNJpzKBO
	MB0qSihPpMdCT5ehaDl4tGzh7A8yjw0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XU5FYslU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302343;
	b=eN+Fk5E55WhorXTyG0IVwViEP47YwtyR8r3QaZyC5jXScZu+Q1oH3sxCPRuNNMdG0MgBcC
	bFPdkra+iKfGcIFvOYukgoIbuj0JrxOlyj2YfIVkwUt+6RzRX/2ukoA1yDes5L5Vrjp2Dg
	zAB0l60loYZIv+lmEWx7oSoDTFhjrpU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52889435BA;
	Tue, 10 Nov 2026 09:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D685E1F008A1;
	Tue, 10 Nov 2026 09:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302342;
	bh=V9O75TKfTcHeHVPMLenNiZqGn0S/SDcuL2HVenCDHeA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XU5FYslUu/QycaxvYDsVfiLjksSb23n6kAsx0C4TwSSMJEdkUorbOifqhqCOqU1BZ
	 tmBnCWeUwFgQQ+4ZAkQAk/VjPzQ+RPHW3/AblZyzH50Bb47hCUnqPVxJ/GU4Mc1JiA
	 5FFUIjTt/J8XmL5z4nM4R0/u+A/O7oMn8+99R0NQQoD9YRGpBmk26SOy2wcjejpGHl
	 mr0KKFrE0VjNzX1I+Ubt/meHZXfZj8kp1B2dkcgv3kCLJkAik/ieVBt/S0jkqQRk4B
	 ZyDYntU3Wf2Vq8yKC7h12DmuYinSiJ1I+4nWRIhPcZEmr+7PkRUVFiiLnUd0MB8tP5
	 IiA+GGSFyG75Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:43 +0100
Subject: [PATCH RFC 27/41] openpromfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-27-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=930; i=brauner@kernel.org;
 h=from:subject:message-id; bh=HbK9i4t197PzSxP5CKS5JO7XvQ/k806ZQREmy2rg/1Q=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erB5yxKrdqWdTL6/ROTOpHFZfYk8FvP4V1D53MDzH
 Vaet0xOdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyks5eRYePLZ35LS2WzX6Wn
 +D69nf1re86D6lp5E91F/Asahdd+rGb4Z1YXc0BUZ9rZoskiB0RU3Nyq0xSNReXOZtV9XNcYHfC
 bAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 056F1180002
X-Stat-Signature: zf98wqwyz6gh84w6eunyd7xu3gq4hwmm
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302342-829024
X-HE-Meta: U2FsdGVkX1/mgHYRCQ+7jKfq5BwcR6VDGlsxCNg6QSp5KYlLkFiISYNFPvuhgqjlyexXBhVy14mKpWRdG9KKghBv1ynHrA+KaImtc6wHL2uEcWqXiEINXUe7DgFy3jnfoJ2VgA2JIB/WVkQkkGn61KlLx0eq9I/ratDXmxXBzFKnAFhBh6eq84+eG2ItLuJ7j6t0rT45OFLY/cthrHklVfi7IMCe6ZnSEKr+mx8GPFqwGowJyVweuukJUR7hTK9o/o+A9/WrLMf8x575nr5dQEvQXrqmGQ29i4L8D9xKWwVZIMj2f3zDyWx3IpjOmEUPlfEwQKPhzvGynmYigP6tZk2zmoRVV15gXrUXhOnidoPuFNcsKWF7nQQfO4lRdqyToC5UbPi5s1d0h0Aqk5qWIYSuDg0+KHrDx/LXn2Ae9IsaVVbQ3zOgX/K3pmI3TBIrKImf1d8thoV7mZ1vYq4zMYXj+btHitai/jnA9sPS92kzh+0qGBZp4rtQ7mmt4x7gKBCHpzgvE+Mo03wFI+R9jK10VI3DbSYeoTcgOphExV+qTdVe5InAUdp41CAxApoHopvC1UIU5yYXzSwec4hLTdtsrxXUgYvz5BEQhDq3mefgDilFf6yzW3r5dQD8dccQvawstTd79Do+0sGN6h2Ag/GYPKbtcjMWrqLzNz4lJZ4bwo/yaoRDfp3u8+O+HUBJVTxW8BeFnmLRuVCrwq14hRbTTYiPPpOo4hZHoJAnIp+wBX/d/hgMWn8POkO3nsPHDOAkvqiK4dvoMywlPeTdbQwUI6oJyQtASh0HtE8zJOQPhz2zt5lGRfh+MzFdMSUaWDmydUPp/fm0gqebNfwWGxQApmcuHK0khSfFksbuRXdcbJWlqAur5DQKhbvqumBN2buDEkdQFbQ2n+Gjjoyh2EjljhOxpjtyw6pXiegdtL44s4rIRpZNwco7HBoYxuP6aaVrjHEwgrKNfiZIhIJ
 C/P2mEK6
 jVwo8FzjFYV3MbZ9GGfSUl2hWmMLXn0wFLz1aZXv+GtH5h+HLbzSm1G0w35kVxRBLXIDooPiHck5LdXzNghDlkU9vttwuWu6FJqqUk9v0R2wfNBQ26WFC6I62IGTTOD4IlNc4nqMIjmwNjxj6WvP0x34iBMSUMov4Gw0seZEt3GYHmNgGqbPjJchLNmpEFqHN0cVQIgHf7aL1iWSr2+IR69xRpY3QmEXAWFwrjp03aVx0f/GOmNYTE4KFZ6D1CVUjXEpqSud2OEYUPXx19YEtvpDPeVYVQuVemkGS8CS6rzShkcN2jjcnxg0TsJmTkeeRMbazNaVIQbPYxEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize openpromfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. openpromfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/openpromfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index fb8d84bdedfb..6cd02d456bac 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -10,6 +10,7 @@
 #include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
@@ -419,6 +420,7 @@ static const struct fs_context_operations openpromfs_context_ops = {
 
 static int openpromfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &openpromfs_context_ops;
 	return 0;
 }

-- 
2.53.0


