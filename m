Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91C35CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077CE6B0005; Sat, 23 May 2026 13:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04FC86B00A4; Sat, 23 May 2026 13:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECEEE6B00A5; Sat, 23 May 2026 13:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D94EB6B00A3
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:55:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F77693486
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:34 +0000 (UTC)
X-FDA: 84799436988.13.3BC9547
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1184740007
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XHmgC1IK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZp/X5zLgPC9r1L7fUvb/ePIYWMAGoK4GAELkUrcd6A=;
	b=VYHC6DqRNwGPLz9NMHKQoejS7pEWQf8IuWQJQsLvLMRSlHUSJKARAUnVhMxcTT5DqJhkk1
	cnLRdxGlHjTk2nfBQm0dexAT4FYGlQ5SLbgmwofAVvZoe2cDBIh95I+cy5bVRH6wbNN+XE
	FJal/9TkSdZ3rPwdwBJy9gPjm1Wdp2c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XHmgC1IK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558933; a=rsa-sha256;
	cv=none;
	b=3I8YOUZFCJZPZfHQMN1u+gTQBGugVO5C1nGood0PDed+mjW69+DmR8CXn60kOVVcVQ/TB+
	a5inP0rHtGPq1BxViIm4dwPOMVlB8+81Q+3bkgeR5duEZQGgBvGR/TlfPmUteDg6FwQEwJ
	9aVyIiKPMVvvrXI9FpLQaji0qGEtrGA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 965FD60125;
	Sat, 23 May 2026 17:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B621F00A3A;
	Sat, 23 May 2026 17:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558932;
	bh=CZp/X5zLgPC9r1L7fUvb/ePIYWMAGoK4GAELkUrcd6A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XHmgC1IKsMvTM0+2evr64HcGx16lMmVQxeLsbzqY++DoYRk4cRBp7HalnPlBMftcC
	 SxgU0WB5nl4VEdUeM5DqdHgEmCtWE8ZmMoisQWZNGjx3UxyMH6kKnLIvIknCvqG78W
	 9DPcb0sWiVFHr4pXHDqNUdCcMRGeXhGZjXpcsRTFz3ktZ6U/o33frEVAMUboeAO80b
	 9PFdW5yU5Zt7qNf8QvoeVI82N62fOcPNRbE8s6REYzOHoqb2rMh7xwyEZKzOLHD1en
	 wFbmxmiRtlOWQQbHfw+BASgeYU4qs4yBf1qbPCNlkrIdRKKwbaAfuq5qUKC9ar0XYi
	 QbnnugkUrUatg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:19 +0300
Subject: [PATCH 07/17] NFSD: replace __get_free_page() with kmalloc() in
 nfsd_buffered_readdir()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-7-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
To: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, 
 Kees Cook <kees@kernel.org>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Stat-Signature: qjqfkx6okefcmfb6j6dw9mu583asbyhk
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1184740007
X-Rspam-User: 
X-HE-Tag: 1779558932-148980
X-HE-Meta: U2FsdGVkX18XRKj6VsuucoAfP4gN/g6Yog2B+ctPb8kD7gfgpDln9cWKccg/4Kz4XUPbZtH8N1wcbm9w5wkW2yRfYlZm5n6zRHAoAY4ak1mVMXV8o+1cowDmhSKqHe8gfVMslSDzmXuwsAEohiGUiBYVesDaOd5DLn2euIoZyZeXe1bh8lhURASL+7d/g/yhvpO/C+V682puPrEdRWnxZGSm3ca5lkClE+KbNora6QU61KKGiXoiq6mxrPiTHNFswBLd+KZrgKGvsaQbknMGoqwmn7JMWfNNKnqfCLiuRkMAeFPcz2DoopW6Y7qEX4nZkRtSzya15EKqY2ECerUVx0mga8LgvVP64erHlbYR6k6nJwUdE3jMlDd5wWlSA39hMH5cl+NFzVrx7omEys8yPlsNbvpmZKZEWHPNK7GesOcbnGBWq3bdZiIz3grG4B0lnabyYEOY84lqOy7f/hPgFWded4ceIVSoLiC6ZNbYNQ30cHkjoAZ4/TNu7/h25LKcZwF3XrzEyJ+INoO6bpsNlYytiBdsKwx5L6xaZcRi1rNIIkQ2pse6PiN8ryfyQjrScU+GUo5Egq49b7QmcqAH10VCtoiaL11Nw+Wv0RDXiWXZ6NyIOMxWGR92tEJ7xyZ2EQhtonyxaW+2dlp8jjdcAvArebUxLI+t9cT/9GB/fFXNEKAVsVz/3WRWkvxItIAQ42Mcvx6Djy3lbv9mT7VbnB9fOAJXKDrGRB57F6SsC/O5zl9RZROIJ1bvEOmJw+3o7RkgolztPPtzBMWyHzebJZeQhin7pUCR8gjMNa+zPPJNR4AhyJmdo2q9N/4P+aN59Zh5EtmZVC8tSBwxhuuw3/QksmMDr3c1XWsP24K84xzRmQlJdXviutK6HPElcVJRJakskb4IHm8V4TwYGJ6/bGq0Y2jofIsLK4dFu5HLSGWtJ12SKwWcXwpv3bbxdjoBfSNHU0PxEqdTc6tflVl
 Q+9+4KXL
 pyYIsGtRdmn+ieSgwsQ8QK0OGMNHw0Am6P1sG1qw9dwj9VxXjVI88/if7Grus+Ok6LN0YJbSvUHh9GE9SuUp2JsnBEX1ITgaEFkIeySUJB8FJ+0PMFvwo0hlz2rEPtSDLWasg9fZItkkvNoLUaq7qMhWmAciskXUQAFwIfJzbIX+6TXGDHHDUJ2yg6NruKspVbxNXs78FGhIDms1nqHmEIR7pW8vSriNnEI9ou8pRkxHP3YxokVJtdZ3uOfIimXbd+Cg71tLD1WVAysrU9N3KRBz+19Gw8fXQlJRr0aPZ8A6xwomxDKLt1nmr/Xy0yCOJ1tyeNjJG1UYwGLNJS+arpmVOL4pQVnWR90ZlnqbNe7zfFEQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nfsd_buffered_readdir() allocates a staging buffer with __get_free_page().

kmalloc() is a better API for such use and it also provides better
scalability and more debugging possibilities.

Replace use of __get_free_page() with kmalloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/nfsd/vfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index eafdf7b7890f..c99e54b23cd9 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -2407,7 +2407,7 @@ static __be32 nfsd_buffered_readdir(struct file *file, struct svc_fh *fhp,
 	loff_t offset;
 	struct readdir_data buf = {
 		.ctx.actor = nfsd_buffered_filldir,
-		.dirent = (void *)__get_free_page(GFP_KERNEL)
+		.dirent = kmalloc(PAGE_SIZE, GFP_KERNEL)
 	};
 
 	if (!buf.dirent)
@@ -2458,7 +2458,7 @@ static __be32 nfsd_buffered_readdir(struct file *file, struct svc_fh *fhp,
 		offset = vfs_llseek(file, 0, SEEK_CUR);
 	}
 
-	free_page((unsigned long)(buf.dirent));
+	kfree((buf.dirent));
 
 	if (host_err)
 		return nfserrno(host_err);

-- 
2.53.0


