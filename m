Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E81CD13D2
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ABD38E0031; Tue, 11 Nov 2025 01:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0352A8E002F; Tue, 11 Nov 2025 01:55:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4048E0031; Tue, 11 Nov 2025 01:55:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D89DD8E0030
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB21458EB8
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:39 +0000 (UTC)
X-FDA: 84097415598.14.1F6A255
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1D006100003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=cSIskRnD;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844138;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wj6NtuoUx6rorSoJrKwRjGX8DQ+3LbRm6UPbWp7kXpM=;
	b=ifKvDbrz3AX30I5CeAuNpS32yAAQoj6JTu8IdcoNTUyBLHD5W8OkDsTu3yGEoiVh6amkZo
	OtUHYITb7xeJ+x6HCKc4NOco9g25GSr4fDm4+nEa+y/+U5ZEnvygJBzFdtHn/iqxmf5WMw
	iTSvc8uv83nEglJEZzsOtQOGMrVTvUg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844138; a=rsa-sha256;
	cv=none;
	b=JGfpd0MTkj/ToyAIWJ4WhZLxZV9HZTdscmbc9XT9x/nTL7//IU0BBp4gaJSpA0+ms06C/q
	nUJhXCMdTmIOKFLHQ6PgmddGmYuCL0Nz28ZLHyRBNP19tUbLqQkizdx9GBXFhau4zogrVg
	dm81sKzXGIeLVUEKDUaIZZFBWWxZgFg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=cSIskRnD;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Wj6NtuoUx6rorSoJrKwRjGX8DQ+3LbRm6UPbWp7kXpM=; b=cSIskRnDj9I5POptPLG9Ky8eus
	Mixrz4PXfoJA4mym6fAA8eR5i4IsHvS6qbvqrYnPJ1csPDlbSa+sMnkpnRzDC9gkmSh2NtFm49jlY
	sAWx40Zc6JkQwYb78IPIqw5K+H2ZOuAVYNP/CBuIKLRe4rRPfwgivkoDxJv5tInuD5dyjZMTCcEiY
	6h3dUXU/D6eNt/05Byng0INiGwdAwDIWBeY4jN6PINY8gCEb7uhek+3CZW75NUSf7oYyPw3jMQiRT
	DoeMVklc6zcDvbYBF3D9uLL8mWt4ryodjJdkLhKdOM2Qe6ieQE0QVMEijYRqlb62e1wiEfp+aPR0E
	y1jDlcfA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHt-0000000BxQU-3Vvn;
	Tue, 11 Nov 2025 06:55:33 +0000
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
Subject: [PATCH v3 49/50] kill securityfs_recursive_remove()
Date: Tue, 11 Nov 2025 06:55:18 +0000
Message-ID: <20251111065520.2847791-50-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1D006100003
X-Stat-Signature: eb8kbwmqkqjof8gm96mm1kp6my7cm1fj
X-Rspam-User: 
X-HE-Tag: 1762844137-587128
X-HE-Meta: U2FsdGVkX1/qPV1zmvNDKhSx6CjC4iuDUzY2YyjYHaff/GjR8faFYn0rEtGc8FRw6dqt2BTNYkCP/hGtD+Meu6z+O3+zrWXA/1c3MLZsJ617y/2o7iWFyBob3ntmE2+8kse5IipJyaQfCPaGq8+4clwaYWTwrNL+eRkl7S4bqP8VSi1aZipq2gMhVTn9z6Uxg1xMiCVGfUTupv64WvDKkeNJYALsL2GKDudBYFLZVLYltSq2RSSY6yqvSY3urhtkvns1U+4NUjmQLYj80yRvBwos5CilhR16JF718H9LjpFehIW1C/4eZb8tXFDR5HVi2Vggg9CUYnxk1cz+VB/kfbTIs8WpRjh056cO0xlv01awtpGptt5CVpqGJYsne/2fLGOSKBrhfprKVwhetT4VERGIJvImnqF6jC/HxOuv/CV9LsMOdsHEyMSOTcxgO2RF2IMNhC6XrvfyVaI07VYJ7gCk46gr1GJITyOq/bUCJ7xAvfBdYkKOROxGbc28jgq6Eh2impdUeFkWYpwTsOVRyZ+2gKSvClUytfZMCIRseRTdggtdbc2q2C9X6LlTVShIrRWPUdViN45/ODYX+fATM+3o6n//XXEM0dMuYhNzwBHQXWEjE4Z/3vDElxgzd3uJsDfkWBiNCNAsaZ6Q26zdkXHYxt6BSCL1cc3/Bjn5qCEYMKnlyH1AlGgKUM2XkX+q7QPZXubbU2vQt9C2Yh8sbdyKrbiU2AyGCUpz0vd455Q66ls1XOS9FU8Krg6396VdAUlukrFGZpEoF8BR5fN1Kw/7rjoHpjslxnDrhyyn8X2zT3ezKYJTSEhsLSqN0A7wdp8WDe8yWS8e9JUMVvFF0GkWANYOu8ssJ/zNVdQGS+vNmrbLXZB7os0rHDx3GC9lpoFhdDYw/jr+pLlKvlixdzyCwoWExXzBFlA5BdX3n8uCCmasYZKUzbMShutzHVdUacJs/SosbjpxpVUem0X
 OdkFTamh
 7NZw+lUg3UkNCFKZbIXZqap2/YBUTgSykh18a+fTL5s0g2ZSw7c7IAcZzVK6su4W5HS0nA13fh3WXg4oGusu2p4a09tMjNgv/wE6IgqUtWWx3nf9QGFH/evkj2QWkxenb+fApiJ+HbsH+2Dzzug/y0rH3RQUc6xtm4J1BArz1u31BOvTW9A6WK0DYoFb3Q2trBcPuBPR86ak5oROhLuqIAvBqszy2x2Pg570RtkwUKMf+/uzUVE81q6y+7zeKpKgL3dpV+HqmrT6uNHTyeGTvw0atfCwbBjXYf/I068FiFUc6hMjujgNMYc+L9gxD7Ufri6ULt/PnNYEgfTiSA5NysIh2TCGufhC5m10SD2c0fIKjFP5s2LSAKgivpeSGZYNBPuBDnLMNn0vllM4FwpsUmbY7Mw8RpdE4ZOTX1q2ZHLdry0p6ys4+7qOQ2tPDHllzfG//UtxF3Gam94ERK50RFc2OMxnFLCF+0Ejsqqwgt7y3JgB0HSWKX1TpDplgjIVoCAUyvYDfXMOFgFjuHJKUUR6FBu5+v28AN7MlQdIB6gWizi9WSyBTE5Ui0vikupR6QF81EIqfuNYpTDE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

it's an unused alias for securityfs_remove()

Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/security.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 92ac3f27b973..9e710cfee744 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2258,8 +2258,6 @@ static inline void securityfs_remove(struct dentry *dentry)
 
 #endif
 
-#define securityfs_recursive_remove securityfs_remove
-
 #ifdef CONFIG_BPF_SYSCALL
 union bpf_attr;
 struct bpf_map;
-- 
2.47.3


