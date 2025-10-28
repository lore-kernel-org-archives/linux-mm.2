Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D206CCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7B9A800ED; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80965800DB; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5224A800E3; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0CC13800DE
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AEFFD1402CA
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.22.B684AB1
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0D8B418000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=vzCgEELU;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXGw1nJCnekakkZR178NLSh8+iviODtKUClSm5rridQ=;
	b=GaB0mYLHg2M/ZL9GFH46RT6juVxTCw/HuDMuABBaUViMLe6+WVU+ADmXsG+tv0DzgWJ7fd
	rXC3rQwgEGpcNOyXuztawxE5BHkYSznj+tSEOm5t0ERHAtOtRzWZ1JunsdCCSDHneJUla0
	gIXf5Nonvocbs5AWgRT18AvoaSlc4yU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=vzCgEELU;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=GqGl5kE0OGSAQ4/Wa9tv/PvQHxYf7yZIqo/p+v5s4NLy+FxtSrcbd6v8UcYht+Hj3eyXTL
	UBsXT9jgwcZfQQ84aOp0FwAumLtZLgmwCXrSl886Z+9H7DbNSlOw64XSbLwlXZfz3IZdG+
	4yzM/VRiMJ4N4s+S6puN6lc6jVWS+kA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nXGw1nJCnekakkZR178NLSh8+iviODtKUClSm5rridQ=; b=vzCgEELUGe6tOIUa7WeJ7YhA+s
	5c6ZIT31hI4iZnOZW9UzVEy3OxGrhNtbk9SPpsn2oIvmtpDhQSN8o0YearlyhHWFsCQncURHA8ML9
	bO0rCDTnAYpJweWWYrBb4EE93WNm+zD++ge36Qb8HKHMbw4uDIUK3AyT1zZnjbctdMBKT5T5jl9p5
	VLq4YqF9hvwDiSDYa5zoG7gyfIFp/sXe4MmWGMMsGWo6lyvCX4QWnF6sue5IzQ1gfA1UKM7oueXen
	PyXfLrj1glksoV95uJELodWugftLKOP6Sed8t/8wlrkZJU65tKHK6lzEN7/ZWzag5V43JwcV09a1x
	VyPyWf5Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqp-00000001eWs-3Iwc;
	Tue, 28 Oct 2025 00:46:15 +0000
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
Subject: [PATCH v2 11/50] convert xenfs
Date: Tue, 28 Oct 2025 00:45:30 +0000
Message-ID: <20251028004614.393374-12-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k1rkbkokwjctsxfqg5kr8dtsrw8crntx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0D8B418000A
X-HE-Tag: 1761612383-204008
X-HE-Meta: U2FsdGVkX18NbUP+33lxtoWuBikyK4tidm0ggWK4Gvosdl1WzdzEORBV03aNjZJ3pDYcr0WW8xDf+M5uA+pJNLAv+ypr0WC2n5mbjxWDwsMs779VkGaclzUf1XvtIm1KebC4f/JsTnL7oXTsGxqOCQabIT1H2Bvc13I84b6BLdUSZV2X9JHBbvDX9vcvvb7NULDu8V05xyKecC8/1Bk8zVkatO8gqnXGJWptTF7JQMkSdGSeAKLvXlXruZOOiNxOkBfsthROdudbESb+Mx05/cOVNb573FI50UKLF0s9gLNrbInDN028bplkOYxxhno0Dz0EqgxNuexzDfaNADu2d6D/CWpV9x4lA21H9PaQUG0MPCp00NWmLxAVuPAzm0loD04OHsogOTWyNcFPd7zVpeTOI2Vl0slhneEhwwqBigfXjxE6q2XGHungjXIWHcX5nnXMiMq9wWYmuigOjzcYy4m3SPR7kGMPiock+sfcjD78GotB7q7tcNku/DN37WtDjHfCKixm0+nvtwM/qCftl1yQUxz2Z0gNbODGmq8/zEJ1HFh5N5PLWlP4Thq7+sMxTGSfzHsJJswGlAAS//sC/tyjPfesDN0z7TuWrkArAsBkwLBAHBqyAei1vGyKdWY6mCj3SFS5mMBtXehoOi5owzWI6/i3HIBe3DBzBwLesmSX1kV3UW8Hdpv4e8jf2Kegr2CiKRo+Kqas7JQMgpoP9bPm/R8z4KxUUgLhr1vx4Unsa26dqhIIlgxBA291FZ18hPfNsh3Iw3vz8FBLIBLMEGfp9eVUA6mIXQCDlgcgIYiEoefqq5q6x9INQHq9Ip+4S0Dx5iOPQ38ItzXEgynFTXdXP7LTPwgAIPeQvjkBs2j84aCvyPFxIw5wU+8AByTWqJsycWHGJ0zJV8G6q54sGL9MyI+k2YNeuFZTEyv9dQon5YHt2xzhnoOcw6mlaxtcxjsJndd0yn4zQwy+8dn
 ZDJIt3Ft
 WzZIUoc+m0hdP1VZB6z28nXHNCXe5/+aTqmX0LfNN3xmQgd0ni3ZRvYus4FNMaPrhj1BNLU6t5lV2VqTX/qf0MM7tW6ahNqPVvqaPjTfRDdTfvNBqtT6l3WyGDrIgsGYA0tngLNUlQhhmz/fpd6ePK/d3vYpISJyR5DGa5Wf+02XS9+evrOd3ukDuNHxXawhlbVDSwdoky9OsNfPn4yeYg5JVmCXY1RzVsrz3ZyVA1eSRT8jeqeGfzo/Es+41uX3UwnTCvQIhJPv30qIJtL7vb0d6r5a2vumQQUs8U9ssWxI5bLpVAAHuCTa2KPE+ySBeXOTo6ZtSQGbsI4zcuppxjLrJ9hzyFpeVqkCIxIQuDTLG2HiTkTMgXEkN+G1f/gsXINH0OCTFdmoIUKQxitCWp9dH9QJP4yVA94JIy1nqKeaD4xCQAtQb8VGLUbPheWd0C5AdyKYXfdcC5B0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

entirely static tree, populated by simple_fill_super().  Can switch
to kill_anon_super() without any other changes.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/xen/xenfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index d7d64235010d..37ea7c5c0346 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -88,7 +88,7 @@ static struct file_system_type xenfs_type = {
 	.owner =	THIS_MODULE,
 	.name =		"xenfs",
 	.init_fs_context = xenfs_init_fs_context,
-	.kill_sb =	kill_litter_super,
+	.kill_sb =	kill_anon_super,
 };
 MODULE_ALIAS_FS("xenfs");
 
-- 
2.47.3


