Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEF78606DAA2
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fljzn/eV
Received: by kanga.kvack.org (Postfix)
	id 0076F6B05F1; Tue, 10 Nov 2026 04:20:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1FBD6B05F2; Tue, 10 Nov 2026 04:20:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35D96B05F3; Tue, 10 Nov 2026 04:20:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B87A36B05F1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:20:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 482EC120141
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:20:20 +0000 (UTC)
X-FDA: 85418663400.17.CA0B55E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8839980002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:20:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fljzn/eV";
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ed8TTuJF+sB6Lawh6bnyp4GQ+ni/YzFsRx+ZLMEdz+g=;
	b=KJavia1/4GKXIHrCSO4cXPxjZq1dNshjMG5mXmGQI+bm6sJMyFipTYN6cWn8M27YjgqgHk
	0gDZTBy60jdYCiAEWMZNdumU5WYpfkwy5rZSz9+8/5Z0VqErbmHqjdVrBIqikCkOmgiDHR
	jXMJ7FJ6XeEd9KjfA0oIxSlAVlZtdJo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302418;
	b=UI3BD9s2ZAu5hGgV3iWLDNHMpNxraCOE8gMWE8uPTQGGI3yC00QuEFABf1tUpLXqFBjV/U
	52FmmzIOkqoXkvvIGMT0CYrkh2vXfRfS5/H6pJkJSeuvKImIw1vVJZZQ09CuEolWoHpznQ
	WGYmzZaUTndVKmDUAf2ztpjkHRcZvTM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fljzn/eV";
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2879863813;
	Tue, 10 Nov 2026 09:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712051F008A2;
	Tue, 10 Nov 2026 09:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302417;
	bh=Ed8TTuJF+sB6Lawh6bnyp4GQ+ni/YzFsRx+ZLMEdz+g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fljzn/eVvhxziu7rpDchbBxswirw38dG5Hh8oraieWnFAikJKROz9NNo3QUniq7JH
	 k0pna/SGi6vkmSevbTXH/7hF6ngRgBZPZ2ZczHXlmyUuIpK7skK0i+Do5u+0rc1eoM
	 1QCt2YoDQYnkiJfUqROif2D9EGzsXbQfijTNIK8+ganjoCxI02/hoEZKq3MGmCMO0h
	 I4/M12qrVolo7dcfHz+wl17JewslqYT+EnXNgtBY6b3e8843u68sorNH4ya/h/+lAY
	 VJNr41AO+Mw+z1GcGf7nSnH75QEpkg5/KlZsgid6ulxGcD7CIdFmk46YH/y/seTdPS
	 T75fjFnSWG6Bg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:54 +0100
Subject: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1037; i=brauner@kernel.org;
 h=from:subject:message-id; bh=rMGXR6zdtbG+6yYmwIdklnSltQxsfLzPwY1iGb1IBiw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9enDgUfStKvuJ/w6Jptq+5PlSbP9KPn63MV/6gs8ZA
 ckpeuf/d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExEcisjw4GLdt6JSusi2NxU
 1iey9qUufZbz//uNFbOOedou29eyzJjhf+TaNUei0tLOZd18O98+VMavi+/sDjvd9a28azc/0L9
 1nxkA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8839980002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gaqc9pc7rfy797odxcbkmzeq6n8wekne
X-Rspam-User: 
X-HE-Tag: 1794302418-264008
X-HE-Meta: U2FsdGVkX1/Y1tRjR/vpQcoBN0xvGjPwG2vT/s4qRUy7jYomyVL9YyyeBwwsi06BEuxNUaT/cNJHaYFSvnvGAyStJsxa+KgeseDEgcoPNSqA27SG82Z9GrV+ZpUZoC8cO/sfdP4gTBegOktzkS3/BbAnmh4/0ONhEkLGQF+7HHQatpF8DYhTeo7VeDNNdRgqEfrFhnzSu7FbkbtUQ7EL5SWPfMydfhAvxpTidCzLmE7uSOm5we6UOQdxciQGoTGrm25KLz8236Dow/wxu/HqAZCHNlgIsVq+s2xu9YdobsihhWUPC57kUEpmWHf1RUY52vqSonQQASl+SjGU05IjfsYQdW87SPliX5vr7scoGKHjSEYhV4xoUfOrl9/57eFYo0U1q1PpftmXTKfv7y/rOApLcGHzS7f4DYC0hW7Q477p7+ZX9T70oiph+j3KN3XNAyfu2c4ylCujJGs5Ta2F3tu4Qhm5OHQ46t/b5BESb0WmvkO2UkayXhSkJY1LCU5f+WeJreWSCAZhk4XpLDlNlBJLU1ldUxi2RjtZ9Gvz7R+ggIvzWdr9QoUJFBu75/2KT4e9+WLh62weYPby9twL9b1ztX0TvcfM9AalHM5T2YXzno11DZJrrajlYHUHKblnqwI1fqS7OxADVcGnsSYznfqjQDoUhior8+31AmKagPP2WWh8a1cFQcBNsdHCXLU0FgEh3IYmWHTJgPsi4Bm4HAhwTpOjk+AZZVDUTao4qK8UMe0cXYk/at6F19nM5c5EjomdKLexrcwyndolYtp+HqfhDtWJ/XDojC9eyBZbwXBNn0v2fPeOvG+ta9wq/oTxmKsF/vmtm1f2YSNAhqNzZzlSo1hqbqZoOKJJCG4sW8QDMttHQHQOVEqC2Xn3gTrj1KP6GKZ74g7vJAv44RX9rTMGrUrml09NNVeTr76JMfA3Q+zuLY7522vJweOkcT2ZOOovPZgZ730/oAuXxqy
 1LpkCf6a
 4Lpf1HitjRzRlOXxoTaLGta9zLpk8fbbogRosLkmohEDTV31j2vlApYZrogg69k2cAKi1gnZ6n5pPJysphPEcNGCifSJsGa36bSjmYcf89vRyEjqWf41QVKRkLh08Rsi/d2M96ZB7VjWECCFXMxUOkYvE0lfOEbGTE2Igcf5nO162CWVYKGvCEgfkidZypBQK/olSZxngVv+bWrAvDjRCewBirUeAgtdrVs/3GGcH67zTwBLq1rYmEbD3xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The fuse server can register any regular file as a backing file. procfs
and binfmt_misc files are already refused by the stacking depth check as
both set s_stack_depth to FILESYSTEM_MAX_STACK_DEPTH. sysfs and the
other pseudo filesystems aren't. Reads and writes of the fuse file would
then be done on the pseudo file with the fuse server's credentials.
Refuse files on pseudo filesystems just like loop does.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fuse/backing.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 8c21a8a74efb..4e4fb810ddaa 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -147,6 +147,9 @@ static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_backing *fb,
 		if (inode->i_sb->s_stack_depth >= fc->max_stack_depth)
 			return -ELOOP;
 
+		if (file_is_pseudo(file))
+			return -EINVAL;
+
 		fb->type = FUSE_BACKING_PATH;
 		fb->path = file->f_path;
 		path_get(&fb->path);

-- 
2.53.0


