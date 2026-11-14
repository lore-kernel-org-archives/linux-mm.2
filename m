Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD0C2606B0C0
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RP6bdqxg
Received: by kanga.kvack.org (Postfix)
	id D337F6B05CC; Sat, 14 Nov 2026 08:07:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE156B05CD; Sat, 14 Nov 2026 08:07:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAC8E6B05CE; Sat, 14 Nov 2026 08:07:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97E896B05CC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:07:46 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35E11A03BE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:46 +0000 (UTC)
X-FDA: 85433751732.17.3D77E91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 74A0AC0008
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RP6bdqxg;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661664;
	b=2wvSE/BPHWbPCO9w8yUg4zM9Il0qXZlZcAhbK+N3akR4gfN7uuDDWVVoYtjh4CG9q/dhl2
	ogXbfdXRQq0CTitvlTtv1SjLEPDIfZbb5Va+N+SseCD+Wb8eukYxwVxnzAnAXQgamoRkJD
	vN0OCVQYsD90onHfKKWsGV+D9Zk/kJ8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RP6bdqxg;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PsEZAEo2EWjwlrQyS8FDrkYLrSxc4EoXaQ3VAa3T0to=;
	b=LQV/kFaRrOAtCMCNG0iZvKhQ0QmgOUOApuS7E2R4DiX0vTVtigp//DM7PZRsmqPdXbCY/e
	VUcDo7A/tmaSlYeuFsmOn5XpAvG+B0qZO17/u514PrjUgylKb3unU4UzxlKdGXUcAw/Jgf
	FJHlEdu5aSlPduNpyskj4i22wrsIW/c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EA3F6272D;
	Sat, 14 Nov 2026 13:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254A51F000C4;
	Sat, 14 Nov 2026 13:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661663;
	bh=PsEZAEo2EWjwlrQyS8FDrkYLrSxc4EoXaQ3VAa3T0to=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RP6bdqxgYdTOvKQFb6NUJlAnzP0iuFZn14JV3dopj4eOhvt4mal1MYZtl7BQYCoxt
	 w45XbT2grNM6Qg55/tsCLUdM0CQBOxLR2Kunja7yy54lP9Qfg63cbpj/uCek58LMdr
	 2g0icThdvpsN4HTsfTKz9VeiMePWjWf1Q1K5NnEjU8lTRxQrEHOb8z5qeiSteKne2v
	 cZsD/rPxnGg04mAtEBHiWHv5l/XXKkWr1ku1sBIHTZe1CFwHTqP1ghScoLp+fr2OPo
	 fJrxBzLLgHTvheGhtWCqgnNRz1198UueTs5pHbgLcHIkedb4JvrikevLf2qm5DDpBH
	 /871dihUSqoKg==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:59 +0100
Subject: [PATCH RFC v2 18/42] selinux: use fc_init_pseudo() for selinuxfs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-18-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1689; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Eg4JynB39S+cJriPMxPoEFKswaAikvmz7VyAKkVX+DM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iKlyMVy9yP1TKKNxrIjSmW/cGdIrJik/frn0dv3to
 /8K4+ukO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYSMIHhv2uEhSiX6eXHduxb
 hf4+qrT5tnTptBUl2zO0TXL7X/736WFkWNSWEJ/+ZOJcg73v3vA+s01c+03lUdAuJu+uVeeshCM
 ymAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: c4qef3oixzjf8jrap3y7nynebjuhykcf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 74A0AC0008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661664-778093
X-HE-Meta: U2FsdGVkX18F+canhYlFj3SJbN6rWX5AcTdDK5vNueGNf78qGvRb73LvdMQwTLtLvmK0WxmVvIhpKNUvNTZzxKJ4rX1YRggqucX0eGRT0dAxe6uCNZKw0Do02RXnugZI5ZQhZGqGqB8PmnZsuOtWbUv9J2zjqyON0lWQ/W6iXvOEiEoYVkr2ap6MGCHJcZdG0IjEJI2MzTNXUv8PwOGFkDAPpI8IDLwYxWyZZ2NaUMmyfIqpxOC3vlB0Nu1qRYTc8vGiFKaTaZDFIE2roAZnq5cOMa2MjjktpH35Ii58Tci1EhVl+uHvzQ9iIjPgNYjr1ucKL//HAR14WcqOjldrUNclQUWhYKM3+CUBjEFn2ZbLHw+F52XdjTQwOZee8mj/ARjAq7mXKAZVDZ7Nod3+V0oMmxdHBMBxVZhfB1TnrX/MUHnEj9NeShU2AIcZneHnIlmtu4fP0dkcOp2WiwFqqC7CWXI4m5O3WbGVQE7M8JCaqMz/Su1MMEnoO9GT4BLvj1BsWN5DpvHtseYFb+96jDHY8+CcN2XG7dJd2j+cErZadufb0PyKVYwlNsxeK6+78vAdy0gjdul4yE0w3rIaIGKkmgqXa3jXP1mlkGhp3PPfKbYxVALyCWBcVD7otHL22AENH+p+8vccHNmkMmHVv5OET9o4segaGN1BiQ+iwbe0hZl9kXnpHkZRCL7vbaU6Ds8XMn5wNdQIQ270I/sX/PxbnRmYMBUOIe8pQHRv2Rv0C9/gBVPu7YYP24Jq+6jFhJPVU3sRzPM4Lbc12olpOeL88OZ7Lp6omIn7ezWUjovc0SYoAMRTmf23VEy1/BHIKz7NNg9WhhsSkTIi3/v++8eZLsbb8HMIFd35/r5puPKVDiOTm0UrOQZcaEVB+Iq4FvihzSv/yfu/YsyZrEwEs+qG4P6j9l7LHb9newLX1b54on/N6u6ALj3UQpxgKy+bCs6QPOjG3T5abZwrnWq
 6tG0V+rG
 HqKXPa3VMrcf46Ckmt59iBo14CEpIp67Xzw2xDt+usixnNLYOGmVlY0zIB2rKXZc7fWgYWT9F/lcnJyWMSdR0Vj+wUC3OC8w18z8JyB/pzPrw1Q0gZNXLEACIpi8rhkiNaBoYpsqEtdQrkuW8wcQMtQ21pPaB8gba9VZCmIL2pvIEBN/Pxa3ej/sCLf3e3CzwUvCwkgFkC19+57na6Ni15LSb1f9IGz6K3v05G1bbeVhpAcV76OFgVgWdx+Ji5uccH1hPel6iVwgGDGdPHOJMQQSdkp4xBEry/t7TaDWU3ZDCmFn/svsdnErcCJdZzURDxRxYnQGsGC4UTBt/BhRSa8gl3w3rKd0mhRhv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize selinuxfs as a pseudo filesystem. This raises SB_I_PSEUDO and
SB_I_NOEXEC. selinuxfs never holds executables. SB_I_NOEXEC also
refuses PROT_EXEC mappings but the status and policy files are only
ever mapped for reading.

But selinuxfs needs device nodes. The kernel replaces file descriptors
with /sys/fs/selinux/null on exec via dentry_open() which doesn't care
about SB_I_NODEV. Android init however opens /sys/fs/selinux/null by
path as /dev/null doesn't exist yet at that point. So clear SB_I_NODEV
again in sel_fill_super().

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/selinux/selinuxfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 310e19efff1d0..d7ae853b6d685 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -18,6 +18,7 @@
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/hex.h>
 #include <linux/mount.h>
 #include <linux/mutex.h>
@@ -1852,6 +1853,9 @@ static int sel_fill_super(struct super_block *sb, struct fs_context *fc)
 		/* last one */ {"", NULL, 0}
 	};
 
+	/* Android init opens the null device below by path. */
+	sb->s_iflags &= ~SB_I_NODEV;
+
 	ret = selinux_fs_info_create(sb);
 	if (ret)
 		goto err;
@@ -1955,6 +1959,7 @@ static const struct fs_context_operations sel_context_ops = {
 
 static int sel_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &sel_context_ops;
 	return 0;
 }

-- 
2.53.0


