Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F4F5CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080378E0020; Tue, 11 Nov 2025 01:55:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628A08E0023; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59B68E000F; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCC5B8E0023
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7CFAA14043B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.16.03BD545
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id A924B80008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=af7kWl7S;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3maaNWdAFQG6lKGkg4q4mAf3fnGzZVX1VVI0dDX3CYE=;
	b=b/IJH9a7jDvWZ1YFQ7GOwIchFDVKjmL117ZuMy0QmAHIlztpAjKCjuMfQz+DfIzq2c9oHA
	T9nvM70vz59QF8mekBWxZCIQbKrPI5vn6y0qXssT0lbOxzbvtFgF2b7kOKsU3KwF7l6r4h
	3fYS4aROHDnhLdXw9ETFLZN8Hconugw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=af7kWl7S;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=HDYbW467uwPxtzBITaNp1nqGsYpXL+CgE/kT5Og4/lXKJBGKnwBzi1RULLIBEBMDwmG4Gr
	/am/tDBRD05GpBurRnfShHvcwx8h0TnoCsfWN1BFxzeKLf0yh7urU4v9HPHlJ2aTeMh07k
	KCSKlpd10/MnpumP/mP2T5cYP9pUsZU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3maaNWdAFQG6lKGkg4q4mAf3fnGzZVX1VVI0dDX3CYE=; b=af7kWl7SJFjT7QdFsmwd1bB+oa
	7VF4d+2ZD5Otiraw7rQJvFktfdYbXy9putsaQRRkXkOvJ2RRHpQeOkz/XScblzy4AWTDnYkqxk7jI
	xvXI50CDcJ3cX8iE/4vQHVzOqyIJoFi+dUf84KaD7SvsNct9FO7YtW9WAFxGc7FQ396MDz96SPgRz
	aMN6g8qg7qqSneL1FzADG34DExFPBmzbA6yQLt0avegFgzzf5TaGU9ndWTrScPkLhVV+zRqofYjyA
	6KZLqZMKt2p757dZqbtqzRX96ZIr1csj7b+Z3fPzh75G6phFt8ewveWWPDJd8CZfUOOwzM4Ebj77C
	7W2Byy1g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHh-0000000Bww2-47vE;
	Tue, 11 Nov 2025 06:55:22 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: [PATCH v3 04/50] new helper: simple_done_creating()
Date: Tue, 11 Nov 2025 06:54:33 +0000
Message-ID: <20251111065520.2847791-5-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A924B80008
X-Stat-Signature: fgwd3xh5ec4iwkfmrqsu5tua1j6hrqdn
X-Rspam-User: 
X-HE-Tag: 1762844130-364535
X-HE-Meta: U2FsdGVkX1+0+Xs3NqsY8CP60B3pNfQL+z9ql5SUHMppoSwaGM7x7ZtgxSvf1tQ9LeBv2zAoXjV3DSCIsMmMn+2zwUOdSbpaxm899guSm5kxbqIaZcid58cHyjgxy1PoR5Pj/iI2IhS9bNkneFkB9moCavUY3BgMTP1QwGtwsaNWgXOuItb/wnVXuJel7l9hrxR8oJcFxzqgdQ8M6UAqQ/QNdueoQ1z7kajsMHxHG5rlr/ur0k5QMnfb6seqIjzqgyU9KS3gquoQ53HETrGSoynBcVS1cqu9tWTDBVxj/VE9W/Vum1k8JezbPVhn3PQaytkggCxU+T5hGUA40/K3on5wxMP9hFFLypPJ01fywUAX/qUbQvGuonFEKk0Ecd9FNXxVcN8teu8S+NuU065ghTLRXI0H/PreT7uo3/6SzBgiTl124ct/Sv9NQEM8bj7DDSDXH0zd3B/zmbx+lhXi99bIMvDOBuYPJ2cNwggyesjShxEGon/SaZhyMT+zZish6XXgIuc+v1NkRq5oaGso80DMBY3gXb05VLk8lICSbSBS1NTLGVEDXJ0m405pmzjO3kK1+tbPYBSxHQky4qy1e21Bzm3C5obrqJDR0MT+19VUsB2YEGG/mU4gLXMwuXsT7r/r+romr6DCrV9v7rGBJEBlAUZi7fH9UY+2XD39qeHTx8AD/VrignW99zTGH0CCwFCA+ThpxnEdd6L/XKBHWjZ4qHmmHd1wgKaNOb/75nYac1VCj9VunkKGjgvEsTXT85oDw3alVhqc2U1Ifpl3i5mz4K+BFlvSbmiL0XiQqDQhDibwRaxD5Mchhfny1glW9+2yjpyuwJCRAu0J3pFbmKD8hpDaXOIvPY+r2437MG5b8N+Vl146rpFcmvTW7LvAU65n2M58pEZzU5R67tHFRUFzAStjhdeh7wk5nNzWxTL7co0tfRqIM9+8louqvLRuhbDDJLWLxldmTjrAJqH
 yWnmzCPi
 HYn4d0MaDTJzWHvKytoUFiN+4cqSdxdIrbq+tguAAGr3LKViI1cQlFCZpU8chLo/RLlGoUQaNCjOKrisVxSZZ+mJpR/AZcuoh3XkS/o1GZ0Lb2xjovAR6s7OQ9sNGQyVZ+3pfTjrW5MxEbjI/Z1ENYJqmnEJELfr7mgMq9dypgmtOZN9MFaPEY8Ru54grjI0JpBSYifk7ZzJItTCfC5p/LEawgqcozwxoxnNiReqvsAlW2yhpQu3+eZY43wfCrJvrcd/nVSP8dKlphfa0Uu1EKeX3LNyAWxAtMHWYtpj1iTbqMlL/UDAAte/ETTzqV+NzTMvh9R85UO2uH/ySADxisEcP3yzjcdN+1JH4wmt6Tkli2F6/ZFqzPo+ax/ncNvoRu1dUz4PYs9WqecVQS1bK+qEn1r0nos3cxpJwCqS/AuqeZ9np2PyipZMcWR1ooYqhNfXm5jllh+AiKVw8Kbt1k0PZaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

should be paired with simple_start_creating() - unlocks parent and
drops dentry reference.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/libfs.c         | 8 ++++++++
 include/linux/fs.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/fs/libfs.c b/fs/libfs.c
index d029aff41f66..a033f35493d0 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -2326,3 +2326,11 @@ struct dentry *simple_start_creating(struct dentry *parent, const char *name)
 	return dentry;
 }
 EXPORT_SYMBOL(simple_start_creating);
+
+/* parent must have been held exclusive since simple_start_creating() */
+void simple_done_creating(struct dentry *child)
+{
+	inode_unlock(child->d_parent->d_inode);
+	dput(child);
+}
+EXPORT_SYMBOL(simple_done_creating);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 28bd4e8d3892..f5037c556f61 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3662,6 +3662,7 @@ extern int simple_fill_super(struct super_block *, unsigned long,
 extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
 extern void simple_release_fs(struct vfsmount **mount, int *count);
 struct dentry *simple_start_creating(struct dentry *, const char *);
+void simple_done_creating(struct dentry *);
 
 extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
 			loff_t *ppos, const void *from, size_t available);
-- 
2.47.3


