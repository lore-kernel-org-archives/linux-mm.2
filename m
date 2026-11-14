Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D13D606E0FF
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZBduMUGq
Received: by kanga.kvack.org (Postfix)
	id 6A4F36B05C5; Sat, 14 Nov 2026 08:07:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E746B05C6; Sat, 14 Nov 2026 08:07:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E906B05C7; Sat, 14 Nov 2026 08:07:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30CFD6B05C5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:07:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB2C31C3B70
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:17 +0000 (UTC)
X-FDA: 85433750514.08.52750BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id F058220009
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZBduMUGq;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9s+j/qnomdsSfV9A9X1jZ68ytQ1y88uXgL9lPJcnQQ=;
	b=VaNAp7Uzwh3hi4nYf1gyE2tMOT1/6qnfx1/pLAtpkhspyUc+oxg3fgT5ZtaGYOpKr1oXEf
	pV7vV33rmrEmUjXRK3VjDmOsCLfrNCu8s/RM1W/QKmtKFMuEPOEvpHrGKh4wr3iFWDlCl8
	Zayl4IzjNcHM58YVT5iTCc70WNULJV0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661636;
	b=f22N+y9EakpqY97PDXxrn/E9voUt2ZYmjHDjzMlBlYaJItsisjntGzl2jBgJGLjXO3fEkW
	imD+1PrqXxrFdsS2T3QuRJpe2P/F7TDBl+FWpUYAvGQp6w1yfBoASj6c08NDMVmKQf6O4q
	0m2Pgn1BFY8fMfiT+GeK0ha0z4Uxaeo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZBduMUGq;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AA016271C;
	Sat, 14 Nov 2026 13:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB521F000C4;
	Sat, 14 Nov 2026 13:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661635;
	bh=J9s+j/qnomdsSfV9A9X1jZ68ytQ1y88uXgL9lPJcnQQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZBduMUGqp/qi5659mADzFX9+8wf4kVV3NEMIvBS9gKHs6MAUqEHt8cBzj3ZNgbS6d
	 Nf89OZFMZUZCn2jJ6Mafo9wRMxG9W4SB0eAJp1Mg0VKarsMFlGa9zj428VS1a+b0RY
	 D6CTCLMwH/+Gy7FwbJfcjx3qkCoh6LyEfI7rfX1ekkbjm/2l1cn+9zhnqWbhtfdgam
	 Y+PAnxkHWZsnELKY9cqaxrXaHDYmDIwyumXSSeFQKPXZI1w6p3YqMu2+y/31W4BSbI
	 KTWrP3vhpbirbRroyDnQuVG/W+XGJp6QhDHB9PqcU/GjF+Dz5Sq3c8cIAzqE/bRgNS
	 ehuHrQrWIS4kA==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:55 +0100
Subject: [PATCH RFC v2 14/42] debugfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-14-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1131; i=brauner@kernel.org;
 h=from:subject:message-id; bh=LYVXsmqnxJmzP/zdkj81mpuZ8VVR49+0Ejm2rZDTrDA=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGr4XHWh3hAo/8SIEYNT/j2jncgmX+7HWMmgK6bgfx63CtOSR
 oh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmr4XHUACgkQkcYbwGV43KJ5WQEAzj30
 a+DH4tqF+HU88MmhFrWuShGbUZ/WYvxekVK9nkMBAMzhgdjjYON010GwrBYO16UXD9hyZA5dodO
 zboH1iSQL
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: c6wepdhgt6sreuideuwmosja9w6wkfs8
X-Rspamd-Queue-Id: F058220009
X-Rspam-User: 
X-HE-Tag: 1794661635-165296
X-HE-Meta: U2FsdGVkX185MHvdqSh1BCkRJr7Ues1KZ3ruMRT4orHmgFBrXuTV9BZwvvHvGI55KOReJ3r9A4TC8WttHN7t8KmnpjNzeOceXlUMLoL+wTFdjLC7WGIqUEKd5S0St6UqYNWWnadtYMUIJe3s88djUahhS9c+K5gqHrpgCd6axkjAObW6LST9fuNlRzK7fTmqQU4XHapT8Um6Tz3y4nK3DIgPjBXMsszkKPAS6QVBDeEQQTqTlVFhoKi/eBeyVWkw6C/QBR44NEj1MGN2rwO7EizHbb2gIZ/rO361j87ZyvvNdMHabphKlDjMDgXxJqmRmsFcnzdO6zn89xb3sOcOSi2ag/86fGxZVcT9Se/vPTNHgr3lfBLOySSRv7DtNBGwqEZsyhkrMm8YrcKr2q3WJfINU5swPnoru/bVaQlooiLEI99PBDG+Gwn4ZJ68lNz4zfvj3Rd21hunB/q33njGIl99sFcV3NwF07NsAvcC71aADcseo/EA3aFVxbPAbAJViTnXa6bvhVWnVni5JmIbrc0xOY1DTp4Zimf2mzIDmF8PNxpJR6z67ro14f5iCwW+toqDmf0Bnz8AcHtLKWbHHveAWy5Uv/MhHEAQeKdqma8/ecWDpanIHvei1XxVoTfa/GJBwL6vpgmC1IeNSVOz6bFShv51llqj8buIbFEylUhy0aLiZ1jWnVNxzP5Rdq6SRHo4CDcfoHLl61PLLh6MIIaHopttbadBfIijJNQm/xkr/VNzHMsaZqwj+VOwWC1oWR0TdJfryBfzbKx1NYGxiKw4l+/+pniclxqUepaHj9nAoesZ0d2rOgoT/EkE91KEjNwofKd30PW/N5DllNjgP9EhcIni6QcB9OLDC1t0JntVv/OWS43OXmlCMIl84udYxssWnA0Pkm+/qM1B80c1p63pTqff5SRVMTR+QGqjXMO6takxAYZEPgrbSPYixBzJ4oCJmfkhw0WUpGb6sYl
 blYWupA3
 dG6FcXZWNdOhAICdr0cXs9k+wA1+oGV4UA1E28D3WV+DgIkK73hdPJx5DZK52AkbMQe9CRKrPBdmJsfNcfq4i1P2lRfSKhPmuNBtsncDuT+jK2Fs+ZSlo1d1G1QH4dHCiVenHtyQOGdHvuNUoYK7f649y6bH7sWcwgrTomN9tkihb6S25/5z9dvwRjw/KEx45JxbhklTv2qxJTGW4+4/BuA18C4151HC73PAcwVGA5XsQ5I/2lGPWQ1Qqga+UlCIzz0sLTRfSfOXFJN9BrLjriIZmLCts1F+TKTRc5CRtcQe0JPMXzWbeH48/t/H9k1maTBdZVgOocJUOEBJbgRKtJH6eJwn8xNtgArnI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize debugfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. debugfs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. The debugfs files that
can be mapped, kcov, relay channels and powernv's memtrace, map data.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/debugfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index b4915551ad315..f163f0bc5703a 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
@@ -317,6 +318,7 @@ static int debugfs_init_fs_context(struct fs_context *fc)
 	fsi->mode = DEBUGFS_DEFAULT_MODE;
 
 	fc->s_fs_info = fsi;
+	fc_init_pseudo(fc);
 	fc->ops = &debugfs_context_ops;
 	return 0;
 }

-- 
2.53.0


