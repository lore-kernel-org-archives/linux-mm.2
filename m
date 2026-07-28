Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 189ADC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 040056B0099; Tue, 28 Jul 2026 08:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32C76B00A0; Tue, 28 Jul 2026 08:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21A06B00A3; Tue, 28 Jul 2026 08:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A79076B0099
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:26:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C52FA1499
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:26:47 +0000 (UTC)
X-FDA: 85038109254.30.6A72CAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 750E48000D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:26:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G3P1nSxh;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785241605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOO/fvJ7DG1Qmdj7Yuqex/IBD7jlB9A1fJljGKz7X10=;
	b=a/zGLTxz1+NTI7jCLTMj3zAzTyukSF4tdP9AXmbWeWHniiSRStZLcoccEDe3L0zda+rJAZ
	pNY58N0aKk5hkKwFWC6KdmKNz9+JHQqgmSyz7ZLpHgIYTfQb98vJx/Rylf/Lk9d1H7aeYC
	3KoqGAoNQXXMh5C3tHbH7VroAfYXyCU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785241605;
	b=tRgnlWJfCSuxXAt2w1YPrkMWhlRMpWTQdZMLGKh2rkfbZe2HUBFHuc6cA+veGuGMBJpOql
	zqncyKdrTCZMJpUvel74tbk/F5dNWWJ7FcWlzLFgjPGcGtMesV8Z55iaqgAKflBbIeJSz6
	MmS2jyPerkBOMSc4uQAJtrFPMpjesPo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G3P1nSxh;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7C4260A9B;
	Tue, 28 Jul 2026 12:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50FA1F00A3A;
	Tue, 28 Jul 2026 12:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785241604;
	bh=hOO/fvJ7DG1Qmdj7Yuqex/IBD7jlB9A1fJljGKz7X10=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=G3P1nSxhVPxurB0hXGcymQNIEpID62NyMfMi5ia4hR/TCslXYZT5CRps4prOl91oj
	 4qQ1TMDOeg3iVpKehzT7KCgOaBJfYnTzQNrpg6A3yMrZhlQk5W60GS3xyPiXXYz9P+
	 ZoVc8BsBcwuksx2Jq7eBm3G+48T/UpoDv0wBjxvmxfPzK8L5nXCpJ97zHmtAUFaGes
	 bW3TLLazliO4JLuW6FBnBHH92mTQbcP6M9Ajo/+a3CjdpyYskDeXvDj9GH/BRsMaOt
	 fc8fsXr6bw/l1PdRxois6hzsL6fRxDMlzToxV2X4ixW9Y5O8CC75XyxjkXI5fcfGBE
	 cOO9ksEZjwrOw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 28 Jul 2026 14:26:32 +0200
Subject: [PATCH 1/2] binfmt_misc: don't let an 'F' entry pin its own
 instance
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-work-binfmt_misc-selfpin-v1-1-74df5daeca5b@kernel.org>
References: <20260728-work-binfmt_misc-selfpin-v1-0-74df5daeca5b@kernel.org>
In-Reply-To: <20260728-work-binfmt_misc-selfpin-v1-0-74df5daeca5b@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
 bpf@vger.kernel.org, jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-cca4b
X-Developer-Signature: v=1; a=openpgp-sha256; l=2835; i=brauner@kernel.org;
 h=from:subject:message-id; bh=p5zN/lX5gZshphxpWwSeheHCCXVxHIFs4aMnBTfCyPI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlzP8n9UuLk8El0DM516b0iUPhgjfZNbPEZuuu/Rr59
 fiUmA1XO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZiocXw3+fktLR3N29kXE8+
 ve+5tOPuGA41zXAnq+XM1/8Yv02ZfoCRYUXGq0cZK3TPVwibbvrKxijkJRBUEBE5Z6PsP6fi6mU
 zGQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 750E48000D
X-Stat-Signature: bfn4gdqj5s1e8jt7xtogksm4nujkah3o
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785241605-165706
X-HE-Meta: U2FsdGVkX19jbKK/PAsWBi6GMhl/qosk+pvlEqBY0CH24dnLvzVZpR0tm6qJ+EBaANQwp6wbwd+vuwmpzgKalM70+8TaBMPP2qJzMm4lXA6BJCa2Jf6YMJ9UTrFDZks9mCCXsr0p1KzB+2ZoskaYh7FO7yccMNeIfZPvyQC8GYm+8BaNCEONETUQFqib8i83SZFOkgMj0fCBD3MHUYg+P1La52rB59Aige41hK3QYxPIAKclO/A0KdqSlsadKt2wALHNSiaHBEF9HS482TapznX6Nw0lvjqgpugls+PKV1Askyxl7dzUEzigv8KuJcnICiK0CXrRDISn31iSvmG9alde1xroDEn9zVqCZ0pDVhC8KXNzDGLPw8+h5O4Zx6EF14s4wveVwxd/1fi9L07ddlmRbFksJXSFtIpsNuYT/y6iHaNHMRRfmbnkowjo9xrV49jhRLbgorZwSdmha1kwidwoLUhwoNeuJ6MsiMXHt96hDn4jHlwrltf9JMvBrgxlgojgrBhmD18/aPmnCMeEo42Y801v7NDmfUh1Xl/dHTcNLiytHQmq/8krjAo7Ubs8rHewKMcmRaCMKSbs82Y3yCdnFZSzUp7Jhv6+2i8HSJAmEX7I6qQ/3z3jYIhIPDlSPqd9Wg0prXeQR7ZvfDNwQlk+JEtst8fuCyK1cJpFNu5u/lIwD8JD5Ul7zGdhPWpMTh2GivBhbwYrYKae8oslj4P+0E65A6s0EMvPtLSCfcwED/fYp1FnGIPpcaz4DNaF3k7if7WfAjBcNWrVgVqrjMJFmtHEqXeBQX6VdN0HllfhPqKrVq1IsWf+KHZW6HbD+ejHInYGb2mkvfBTVlc8o4aEFX4hGw5+pss5a+qHbo0hhGfKS4uBa8CwzZRxmMRVoaxHeigdF9kWABguz04C7gWBX8Jr912iPZo8lLaNitT65PjveahQXLI89mCGb1PGevwhflBtcE/ACSsWShc
 B8ATloYa
 L2jcz94HC+aK9b3AE3htnXOfhZuXdGhuwsX7jYjT5rxvLsl6KBmoFDpKRYwrRUaf4q9xBhaInlycku8jsnSJMv+dR0/1bPEKHnA3mjo4lb1XEsU2UlpAFRd0aVa9IqwsTtuTcVj1sqb19iQOk+GCxkzKnB7MXHCvYEU+m4oqQGFdGRXfR+QyhkKq3k/cjKh6U88OPwLLmCLVv7e5YAjI1doeAfWrD71Le1K2Oo4zKU08T5CflUeAsLBkHa0O7S2hv0n6c2E6iFOtxUPwfBI87Mkv4wOncrzpLwIrKx+oEvLJ4X8DDJW3re96fL3cgkNF8z2x1qGazl3z1tsuaz7IoOmY8COjuM30lq0otRmKEZzhr9B221tz2P793BFl6CZPLgOmB341ksf6zQjU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An entry registered with 'F' opens its interpreter at registration time
and holds that file until the entry is freed. Any entry nobody removes
by hand only gets closed once the binfmt_misc superblock is shut down.
If the interpreter lives on a mount that keeps that superblock alive the
two pin each other:

    binfmt_misc sb -> inode -> entry -> interp_file -> vfsmount -> binfmt_misc sb

TL;DR the file is never closed. Once the mount namespace is gone there
is nothing left to unregister through either.

There are two ways to trigger this bug:

- Point the interpreter at the instance itself. Its files are regular
  files owned by the mounter and both bm_get_inode() and
  simple_fill_super() leave i_op at empty_iops. So notify_change() falls
  back to simple_setattr() and chmod +x works. We never set SB_I_NOEXEC
  and so open_exec() accepts it.

- Use the instance as an overlayfs lower layer. The overlay superblock
  holds a clone_private_mount() of every layer until it is destroyed and
  that clone is in no namespace. So umount_tree() never reaches it.

That's a DoS. And it isn't only the superblock that leaks. It pins the
user namespace it was mounted in, so every iteration permanently eats
one of the caller's user namespace charges.

So let's just do the sane thing. SB_I_NOEXEC makes open_exec() fail on
the instance's own files and s_stack_depth makes overlayfs reject the
layer before it ever takes a clone. That also covers the ecryptfs and
fuse passthrough variants. What 'F' promises is unchanged.

The stable tag is narrower than the Fixes tags on purpose. Before
sandboxed mounts this needed global root against the single instance
everyone shares, and the change doesn't apply to those trees anyway.

Note that SB_I_NODEV is implicitly raised for userns mounts but raise it
explicitly here as well.

Fixes: 948b701a607f ("binfmt_misc: add persistent opened binary handler for containers")
Fixes: 21ca59b365c0 ("binfmt_misc: enable sandboxed mounts")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 5de615ca7a75..47aeb2b68d3e 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -937,6 +937,10 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (WARN_ON(user_ns != current_user_ns()))
 		return -EINVAL;
 
+	/* Never exec off this instance and never let anything stack on it. */
+	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
+	sb->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
+
 	/*
 	 * Lazily allocate a new binfmt_misc instance for this namespace, i.e.
 	 * do it here during the first mount of binfmt_misc. We don't need to

-- 
2.53.0


