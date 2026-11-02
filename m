Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 581BC606B1D2
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JDsGn/hF
Received: by kanga.kvack.org (Postfix)
	id 7DB346B05CA; Mon,  2 Nov 2026 09:25:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B49F6B05CB; Mon,  2 Nov 2026 09:25:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0ED6B05CC; Mon,  2 Nov 2026 09:25:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 535746B05CA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:25:21 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C993B16012E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:25:20 +0000 (UTC)
X-FDA: 85390401600.25.6F3C311
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id EFE0F4000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:25:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JDsGn/hF";
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629519;
	b=ZwTPi4UiKjaMumZHIVjaj4fvm6M2etqkHCAynaxiy1Pwo1xLWnHKIbRH1avmsQQj+0ZaaP
	8QvWO+3P9NMsRT5AmBs+VpQeTuY0tkkz6G1tbKp+lAJlXiemjVTGGR8o6m2x7lYuflQfID
	5KpNcZuJUf3Zb2UnyXdemHXH+sxzmEU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JDsGn/hF";
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JNpsr2x/IJiEDPfvFWvunpncxqTaLkfXU09AZqKel44=;
	b=m//2avGvD93mKUS21zPJBN+44C2C4f5wUg7tVp92UAqlqgEmAagzZJhzhvmk0PrBVvqcQG
	9fyF4Rh7OuvRBq/xZ/B6SoKqYcj4FtPAy3nC4Qc/Gw6QdaHsXSCMdhLLjQxc9c6NqaUj+q
	GTUtes4jf9DNvsmusp1qKWFtsq4PjrQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8678160234;
	Mon,  2 Nov 2026 14:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3D51F00A1B;
	Mon,  2 Nov 2026 14:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629518;
	bh=JNpsr2x/IJiEDPfvFWvunpncxqTaLkfXU09AZqKel44=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JDsGn/hFVn3jJgZZN+vxWeK27seUWBPs1wVOE+JNEu0HLhYAOJ2nqrTO6haz/TYj6
	 YNU6ClCHb69/Mwz3VGSMP1SqtEUNb1kZQxwlphv0C3QTgmSWa3hvL0K6Nkv8/dDbQg
	 lIAyZ/SG/ZBazLbZqMfdobAk/no6q8xju7R/ZEgKZSmu4XDjIlEdZse+5kbC/M3ZOb
	 YtyZc+thQ9HPKnmDmp1ArUqwC6t6Rtew7taSAiLHDbNBCUSXLpeUtxzb4vHo6JVhmo
	 9ttgQP7T/cJcSArxgsr9Ra6D/o7FD6CAOwSHHtHKTQ6QSDDqKkrHmSX0e7L0CksocJ
	 AnCPlWoxZKPDA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:30 +0100
Subject: [PATCH RFC 15/38] ntfs3: don't warn when a huge label is written
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-15-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1211; i=brauner@kernel.org;
 h=from:subject:message-id; bh=hEYNyHmJEt75byF8qjmUEc5I4mCCp/IJRi5GCVbZqjw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJO9tzXzBHuGhvXirewzzGdVv+3VvLvcMMAstP/LI
 s3O1W3PO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZit4nhv0u6nc6mlExVhhyr
 oJCt899GB1UJL32g2bLt+sHUcj+ddob/CXvLet7P7ZCO8VCLPuikff9GTLZ8i9e6xds2/Ct79T6
 KFQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: EFE0F4000D
X-Stat-Signature: b7enq67sndqakpzpqm6aju6qnkz6k3xg
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629518-596745
X-HE-Meta: U2FsdGVkX1+924hQGHW0gwrF0SPR5u/aohAFa45QXU0C1vhjAznNr1mXeyP0FzxdgDqRWEjgubuBXwH16zZnLaXiJwe1n65HBQPLJYUKiQfLgMuA45pCiyjQjEVZ4EzzqOZAk+5jcGNsyaixsMVc25XQ41QUELcRZ6oJr/u4jCSQvebYEbPcuKtSEgbik+2GXHvP7CwTnDM4Mdvj8IuZde3GGhZ6PNfoccRkaDpkDywwmC7ULaZJfSFGApT+ealHSCEZdkObaEszbeo0iKkorL6wz6HJbWqQUCSYvNXJP7Rpapf6dQPpAUy9c/GIBb0Pem4u26mEwVlWQWjaIYKVo9zJhDCbblpj6y7z3MgAVGS2vnuXTA068L4h/Zdsyn3u2c4ki35+dl0Is4rGz+n2rQjNpOF38ca1BOuw0Wf2Mz48he2AqH1g/gwGrUWmXmPVtaTNvKKLTz8ySLaUH2ogU0Gz1v28+4r9e/9nBLv+9pY7A1CiWeweUfdTpOm/rP6cAp7Nnky3W81bWrIXzr4ePG5cAEp6QddxR3vCHkQrq9eYQUf6z0UarqJBCm4VqmeFMuxpWWj8CXTh7el6dG9xX29ucvONDfvNYIFvSfdv0bMpy0KHxDMfj/y8CqTbcefW+aPMtglV1mVZWf5yLg6ItVQdQUo/ZUYDfcaagJU6kO0tIUqWEvWxi986Ra6ZwmtxhYnxkcL+LfyGSPf6euNJlp5DqlJSWhd4WeNQxpuH+FzNf7LbgkfD6IRy9O9+vMbf7NfIyDVlXhBsNdv5q8+1cEb1PgVFDM2mId3TSVfpTdjJNhGJa7vWMHWZm4HsTbPBRXkynSfcE8cb4qeQyKphEcJsMneoVWZ4mpo6grcf9eJTqaBnBL43QAuR1ZR8Lz7hEcCe4C+6WIBT4jBvevUvlG9pYkz6tdWFMrauFHOhcp2pzDqA3s+m1ieISKB3k5EhJ7nOyCuLbK6yMbF5s7o
 gTWukCIW
 I0Ih26UkMBk+HH36hneJphW8JFgdcuBs0OLdFouM1Tb8TV0spY6STM8pSlVXEo5rd8SM7TPsC/eOO0EoNOexjIHykHLrkPT229rBfhoEVaSKQFbR3VWyv0OIzV0kEW9YNuVfYphve4i17WX4ASoy7O9PdwlqFUkiu9nPpKBC0sfVboMTw7xPjjLQP7W/YG0AMlsvSSjvg3C3knedO154m2VReoxh0LdrisyABmAzNZhFZ7ejb/oyd1jLIAJ7KFby2/4Md9s323ab2U7dgYVcHXm9CDoHKzWA9Fv1T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ntfs3_label_write() allocates as many bytes as are written with plain
kmalloc(). A write that is larger than what kmalloc() can hand out then
trips the page allocator's warning, which panics a panic_on_warn kernel.
Use memdup_user(), which fails such an allocation quietly with -ENOMEM
like before.

Fixes: 7832e123490a ("fs/ntfs3: Add support /proc/fs/ntfs3/<dev>/volinfo and /proc/fs/ntfs3/<dev>/label")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ntfs3/super.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 58ef6be3286b..b4479cd6bd65 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -552,15 +552,10 @@ static ssize_t ntfs3_label_write(struct file *file, const char __user *buffer,
 	if (sb_rdonly(sb))
 		return -EROFS;
 
-	label = kmalloc(count, GFP_NOFS);
+	label = memdup_user(buffer, count);
+	if (IS_ERR(label))
+		return PTR_ERR(label);
 
-	if (!label)
-		return -ENOMEM;
-
-	if (copy_from_user(label, buffer, ret)) {
-		ret = -EFAULT;
-		goto out;
-	}
 	while (ret > 0 && label[ret - 1] == '\n')
 		ret -= 1;
 

-- 
2.53.0


