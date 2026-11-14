Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4866A60A3810
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVaFfwiA
Received: by kanga.kvack.org (Postfix)
	id 741966B05DF; Sat, 14 Nov 2026 08:08:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719A56B05E0; Sat, 14 Nov 2026 08:08:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630456B05E1; Sat, 14 Nov 2026 08:08:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40F856B05DF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:08:57 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE89140406
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:56 +0000 (UTC)
X-FDA: 85433754672.12.22B26AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1F442180007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UVaFfwiA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVjzjsuRRB2UDEz9oF8zpvzwY092/ejVSFo+HtliIvc=;
	b=iMEzpSpW3kYLvDkXf9y9Qn+Peal23xd4F2ZDA7zZ8qq7fXxhSNo9Qzuc4jVMILVak52Ii4
	grkbNKDCQtjevbUGGVR8bgxftyuHobuuSciapj+lXYe3XklHLcklA1J0vMtLOFI9P7TUiL
	3aoEHns/lM5RRbt8fIBwxyFSEU5Kr6U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UVaFfwiA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661735;
	b=J+3ckO7W1zu0I8SMH18hP36IwSu70Y+sIoLE4EI1XgGJGQ8qhnHDcS95RW4mkM7euuuVwi
	Gj17h4Su9FN1wW3En3VeiaMOI47Q8cCYO7KoiPnAI081QLNkZ06597ad2f9A8D/dNmPuqJ
	IAhsDBsATqhevQclrnsL6Rtrt0DYe9o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BCE543CBA;
	Sat, 14 Nov 2026 13:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93491F000C5;
	Sat, 14 Nov 2026 13:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661734;
	bh=NVjzjsuRRB2UDEz9oF8zpvzwY092/ejVSFo+HtliIvc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UVaFfwiA5zRIimVEAgzAS5LMrrD01HUXKaMpbor+Rz5AOd2vHoPXCqbvdwGWBTrIB
	 m5kX7dz7AGGAwjJjuW0l/5mNTBXOF7cquK+ncIk4FTMBAgz4L/swi8yUiHI0e2qgAr
	 6bp+zKbJsJ9HY/cYKdz1lp/ddP0/dfUVi5m/8oneZVxiQWMDTgO2bliKT++Ie3Uv6a
	 8l0UllhuQ7TbovBebBzVOisEiB4Ok49OQ9H6KpFib98QFm6PM9KhfCivOUR1UsxvCZ
	 9aPQWq9qVax1nQI6TBMVoXocUs+GlzxhB7TqjHWemtwD7yZ1EJQ9uSokpve4k0Q1J0
	 aujFNglRVEFlA==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:09 +0100
Subject: [PATCH RFC v2 28/42] ocfs2: use fc_init_pseudo() for dlmfs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-28-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=949; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+FO4Y1ymqMYAnXNVc9VhiJCBK4eGvv0E7gd9oyLRaz4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iGk7WjSP46SwS3e7d4Kv6MyOb6bppW3Xqv6V7uHTL
 Jc4cvtcRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwESUxBgZnt04pCb0syGDj0eq
 f4e31jfLPX8LHQNWd/7buu8nC9PpW4wMu0Xb+E2Xc3o2TOOI4xToZ91mWvKBzUnka3RtdNyx738
 4AQ==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1F442180007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 55agxkp9hw9royqh7z5tjyp5or674hk1
X-HE-Tag: 1794661734-357558
X-HE-Meta: U2FsdGVkX1/52uzOIgh6V0vk2Q7uGyr2K/6urhZuTXF5+6nFts6Yp61zIooVNHiYA4BBQPJt4x+ddVgT+hR5NzxC6v8hFSGmbnP4dcpR8ucSJff8EAT9h6nXNs7JkjPD9a0nxqu/luj+i+ZPBaT7r54SUZI0TMLKviHkUC0ASiTttL6raFs8tguUiLRhFFi23Pc7DGKFNuZKvsHjkyFMFmcCMuNwN4+A8yTNRQoVzvt8dkDQgSmgehMDUdU//wGmwfTroAHvUbSU5riFLbzQ5m3G0REDErxKIQ9asibcWwwtZ8iXzEC+2zgR1daE12DRG8IvETRg6+uXkyR7QhLpeBSdQ48ujyCsNoecYmwdZEUEMvr/LGDPbB2g4qtQ/etaz2kj/GTUnOW/dJ2G0E5ZLrVGBJU3+yEhU3162kzgSqKItuvE2Rk7V/7Pz5tBYUuDFLXJd0T9n+/4Y8/XCqSequQPTpbYGcJqVErc7uNHdes6kdwa+MMCGxXcWi7l4xFqBB+JqmI5SWbg58Ks1T1e6i5l4UpJTfkP0nACWSDrpJU8BnaSJqZKYcsxUNczjgWiSiZnlVeJMOIPTA58QqDDs3Yi/qx/raQT3SumSrWjd7Hx+DAQF/RSLAbh+GixOtgiEYrYeB/FBnazIuN9S1NKmbHFfqiFUzDAOZS6PLyHag9wt1m/G3xZq8O8yze/0W2VijWuw67jziGee4+BO6WWig8z+LKhUzc5XNw3zck86957Xazwz6MHNPyqciScOOW2SJ0D50SnDA8k3AKcNI5q4r8AkDypsC89t7ULiGQ7ipzgDj63SetoVsJWtjUMBZXcIMolrEuQGGAObEYfwpiMj/tFDIe35DkGmRjC8zWP5DUyK2H4RATANY5Ey2OJZktejXcQHsnaddgIcshe4HwNsHV/IOCsJtoZXREcuC5ZHdliaxyel69zxe0aQliiWgFTS9C/6VqGOQ6x7VFWr0O
 x8evVtiC
 I3UmZ0LnmmlTcY+0/DeMJoPYM5ShKQEQ4fI77797b8Q9zfs0tNQr3SBeFVOnwd+LydE/pNv7NK+GQOm+wJpLaSR6rIJToSTu5znQp+X/pvphVysW486XsVTw8CIwDjgiogcX4HI3zaGgbl42JVAuKhZ9C+0X1PJ8ec6L1UZsIoywWcWUb5JEuiUqBKjl2k0dD/5UevFNDmdS4smaC+1wwu9u6FrPUun2P7nNtPmu6FMhI11x1aHauJ0/Lyf3NqPC62ruXa9lWVFqzQQdFXQNVlVuQlGBuLkRNuVP8reiAflzkis+eSN0NDhkG4tO/bHLkQLpw8xfGx3I594TaEAEZI4TqEOV9PQuAmcBx5kL8o8jJ5X9tyIn0bRaI8M7wozqfjg+LxBsfsizbP6PjlvlYGUX9D3Uj5jfI1RAlS/a21DYWF4MvdWaD01KRs2PbF6tqWLyD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize dlmfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. dlmfs never holds executables or
device nodes.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/dlmfs/dlmfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index d3bfcada3e3bf..1789ec96dc130 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -563,6 +564,7 @@ static const struct fs_context_operations dlmfs_context_ops = {
 
 static int dlmfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &dlmfs_context_ops;
 
 	return 0;

-- 
2.53.0


