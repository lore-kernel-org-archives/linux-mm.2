Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3C55D1D480
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52B806B00C3; Thu,  8 Jan 2026 12:16:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5162D6B00C5; Thu,  8 Jan 2026 12:16:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB4C6B00C6; Thu,  8 Jan 2026 12:16:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C7846B00C3
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:16:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06C94140213
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:16:40 +0000 (UTC)
X-FDA: 84309450960.27.55234B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 57B741C0009
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:16:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XTcrMvWG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892598; a=rsa-sha256;
	cv=none;
	b=hbxoT7AfEtO1S4lrVln+3He17+Am/jVSbWKhzJdPFgEPRxkG2ZBm3tmKUGMM2W9cmhnMmW
	qrREpktHeBtF5qBz5iaEhyqOlc0sdtbBeRJXTciuiskAewi+ss/JmavvmynJaFS/xuVQPB
	gWs/p0UeVFYUI1Ev7AvRyVZyNEWWQLg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XTcrMvWG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PwAoht7a3jGi/5dXz5pEQXMhfplROvUnQsiXMkqy754=;
	b=fGbSpS6v61X5JE8eq0eWIGfGrLq8g0sw/rYDIJZ/CUXMBuVKsXEHCB8WgUFSs7DuPNs3Wm
	nBRCJFSF9fo+JWwAqqWa0cBrePfps0i/EOoERk8MOSMRzdu3f8ow6EfO6Mr45VYfN+jcFm
	l1oql5I+QYahQWcYZYDqGFCLFkX5lbE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B851B60152;
	Thu,  8 Jan 2026 17:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F2FC2BCB3;
	Thu,  8 Jan 2026 17:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892597;
	bh=NID4NaaK8cNH28A8Rn+v2PbCj8aVd6A2vQHcYBl6XEc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=XTcrMvWGmKFvGwAYstJ6dpq7B/a12oideedJX/ThejFncpxpueWE1/8kcHPOQeVZk
	 QFWvIwhXvIK0f0/19xSsSvLDZxcpHacHvMrpL8K57jbA0ztziFoJOozdl4ej7Srsqk
	 IJ0ieRHWcycFHrOQpwYkkWmJEgEeCbWiiqP+kKLCTvF0rMcz4DTKBtnopfo9o+a7A/
	 ALxsVks9p4nDFy19KiMt5fsLyvATj5/h0UOqcjT4fVOW8uedPPmXkZ+k9zyu3Gb0t2
	 f/xnx08CLyXtuwL34A2sbbQNfdmTKLQZ5rLqii0Ytq9MzeBjv1sgSo9/YY+39BK1uA
	 i2jzGPW/BI2AQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:13:18 -0500
Subject: [PATCH 23/24] filelock: default to returning -EINVAL when
 ->setlease operation is NULL
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-23-ea4dec9b67fa@kernel.org>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
In-Reply-To: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
To: Luis de Bethencourt <luisbg@kernel.org>, 
 Salah Triki <salah.triki@gmail.com>, Nicolas Pitre <nico@fluxnic.net>, 
 Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, 
 Anders Larsen <al@alarsen.net>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, David Sterba <dsterba@suse.com>, 
 Chris Mason <clm@fb.com>, Gao Xiang <xiang@kernel.org>, 
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
 Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, 
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
 Dave Kleikamp <shaggy@kernel.org>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
 Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, 
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Phillip Lougher <phillip@squashfs.org.uk>, Carlos Maiolino <cem@kernel.org>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
 Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <chuck.lever@oracle.com>, 
 Alexander Aring <alex.aring@gmail.com>, 
 Andreas Gruenbacher <agruenba@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Eric Van Hensbergen <ericvh@kernel.org>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
 Christian Schoenebeck <linux_oss@crudebyte.com>, 
 Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
 Bharath SM <bharathsm@microsoft.com>, Hans de Goede <hansg@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, 
 ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
 linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-mm@kvack.org, gfs2@lists.linux.dev, linux-doc@vger.kernel.org, 
 v9fs@lists.linux.dev, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2888; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=NID4NaaK8cNH28A8Rn+v2PbCj8aVd6A2vQHcYBl6XEc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W+cLBRWxzgtw9xiO4SbRJTFDfCZwbur8vgI
 DrUAdciXvKJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/lvgAKCRAADmhBGVaC
 FWxwD/49jq0dpl0tpEt+oaAFd4j0e/fid44vjg5imuwIhXHfcwsVVI4fUx/pz3UE94Qammox6zt
 upvbtem5sWsRhamPvtqVWrJjw3WEV+gTo/v2UllfbGPmh6jphW2/TcVyvTFMYjQZBfVyWLbN3jA
 3EVALc5vqNlMGchvznz54yLVU2RChzyx1XvCDhHwRAeNSAOGO8/1o9yXbGLyvPjSBJHE/68d6ki
 r/PIpu9JbeJugyz6HygQj/YOpchUfZ6FXD6KzyRcth9Fr3t5To8fhQTanvnQzTpe38PVFpxwy8D
 xwiuSY/o3EnGvPHb5b7HRRKCgKbOlvFEDfJWwiUCM6pZumnUrF7XAH3v52LionbfPxfLmcvOU6L
 gpLLdRy2M3uTOACsZavhy0S9lVZnTo4goZFr4ev0RRvmsjX+YTeV2ow/h8Vg4LKuFXUFR+5H3rG
 W30w4jQ5zSEZduWe5iGwnzyrIHJUB1ZloMPctMrzuCHbdMt2PszPfjsvqBlm7yLyj+EsqcH+7eN
 ipQkLEkHcqrbFNjwLbqEKEjK64Kjp9khIJv4PaXVv685x1D7zSSXqqq2QocKVPLs6RoSmQPkUDF
 N3wB/LHoG5Est1DU0o3AQeWJkEbKY5rRS9DAPXxFfP4CE7C7/5Ho4WFA555yX3b5D55WwWYyXRr
 /Y+/b/w6+wP/HzQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: hgqo4r1mpzrzjwjei7dqgf7aziy7of97
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 57B741C0009
X-HE-Tag: 1767892598-27621
X-HE-Meta: U2FsdGVkX1+bYoDNrdz8fzPDlU0IPForiqYXiHeUBitT95EvdLfKqAzdWEBW0gLjuX7dh9ryxl2VJ0icxuuBFV4FLm7PZIFZyojAvO9+fkW2Wc+LYne8nuQFFZZVd79JdojjwdIQ4afUO4Zz80qkTNSwa7FFahYe8hOd9cXewemE8Ffan6JmSQmf1KphhSWolDB8z6PK438swwQrEbFEFgjZGXraHLMuQ0hrlUqBM1MOwXPJqLYWmSa0eD2zTJfI5/W2+9f3I0Rp5ZYbVXWQFuAhWwddDGheaET6hqmDFS0+jwnBbXCgpaDPMPhtja34OOu7pyLTIZNM20XMLkxO55VVOil32NHj8zfHt7Rff001I8yiHut1sWE/cZgLICWJx0LqmTVw/IVSGWsCCsUiGybWMpAzyXo4OkXmNTvpDOc3R2A6YjVSMTN+4LhYjyD7SY+QMFw3r3EElgPZZOq2O3FdNyKbZ3+7o0XrVJ4GtHCOuTu3bvO9oQN/CaB7fMW3cDFwSMR8NgY8yYtulqPDM74ihKYZSvRh24kt16tB9RyjD9JMT8p9P5h4APh7RixNukCjFR9b1jIuLA0hSVXUgXbWVqo7t+P3VRyJdbOGKweS/x5m/pW3ZTvyETQlso0wk4na37BjLxQQkIOTDEykbkgJKfhY9HQmgWEDAEJIpxtMpEDlT7fApI2hG9IWFdqoKQnhaD2KRiVCSVOb5Njuc2ZYrqZb/PKcnapyZKLuuBkqycN1L6isox/64U3IVseJ8GqtZnj6kVMRy0cVO19F8R4jB9Y19YPGyclkZUSKECzliroKhVDKCCj9sdS8zrCeofsFzQp6yBeFSyjRKCgYGNKJL4aUB0RSOi95cKs2lkYUdZCwvuDNht03Fv317McuxDMaurZ86XHz7OGElRchFEuzAB/a7u7rQtRH521PLcb4SGqNoXGnF2/HXfZkGuZ31f7bE8/6zrwBZEo+9HY
 LMJXbisa
 M8GwKvV5fyBa3CpqtIc0BuNeeesKwVk41/Nwu1N2JGCMlMRdss/rrATs3EM6WpAsALoaYhK82yTH3/0pYCA09Mj4bjX8zWklLZX86oHeasVsg1UUv8Yt0+eZUGUn57iWTeuCBILVRC6F9csobjKKahrJ75adhD+g/wvmscmXJlneuZnZZmjgRvDdSGsbM2/5rFj7CuQMoeenb8bZ4e3Er3DWELUuNIIYArWBX0EHYq6mgZzQ6QBdFBkIcTk4xUXcbl3TGryklJZTFmeavl4bGPAj1Zj/IysF2B0ZB2FF/N0qNEpDJNkjolY5p41Iq1F+hL5PF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that most filesystems where we expect to need lease support have
their ->setlease() operations explicitly set, change kernel_setlease()
to return -EINVAL when the setlease is a NULL pointer.

Also update the Documentation/ with info about this change.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 Documentation/filesystems/porting.rst | 9 +++++++++
 Documentation/filesystems/vfs.rst     | 9 ++++++---
 fs/locks.c                            | 3 +--
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 3397937ed838e5e7dfacc6379a9d71481cc30914..c0f7103628ab5ed70d142a5c7f6d95ca4734c741 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1334,3 +1334,12 @@ end_creating() and the parent will be unlocked precisely when necessary.
 
 kill_litter_super() is gone; convert to DCACHE_PERSISTENT use (as all
 in-tree filesystems have done).
+
+---
+
+**mandatory**
+
+The ->setlease() file_operation must now be explicitly set in order to provide
+support for leases. When set to NULL, the kernel will now return -EINVAL to
+attempts to set a lease. Filesystems that wish to use the kernel-internal lease
+implementation should set it to generic_setlease().
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 670ba66b60e4964927164a57e68adc0edfc681ee..21dc8921dd9ebedeafc4c108de7327f172138b6e 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1180,9 +1180,12 @@ otherwise noted.
 	method is used by the splice(2) system call
 
 ``setlease``
-	called by the VFS to set or release a file lock lease.  setlease
-	implementations should call generic_setlease to record or remove
-	the lease in the inode after setting it.
+	called by the VFS to set or release a file lock lease.  Local
+	filesystems that wish to use the kernel-internal lease implementation
+	should set this to generic_setlease(). Other setlease implementations
+	should call generic_setlease() to record or remove the lease in the inode
+	after setting it. When set to NULL, attempts to set or remove a lease will
+	return -EINVAL.
 
 ``fallocate``
 	called by the VFS to preallocate blocks or punch a hole.
diff --git a/fs/locks.c b/fs/locks.c
index e2036aa4bd3734be415296f9157d8f17166878aa..ea38a18f373c2202ba79e8e37125f8d32a0e2d42 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2016,8 +2016,7 @@ kernel_setlease(struct file *filp, int arg, struct file_lease **lease, void **pr
 		setlease_notifier(arg, *lease);
 	if (filp->f_op->setlease)
 		return filp->f_op->setlease(filp, arg, lease, priv);
-	else
-		return generic_setlease(filp, arg, lease, priv);
+	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(kernel_setlease);
 

-- 
2.52.0


