Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D774BE7BDB4
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 409556B0098; Mon, 16 Feb 2026 08:32:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BF926B0099; Mon, 16 Feb 2026 08:32:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313856B009B; Mon, 16 Feb 2026 08:32:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A8CE6B0098
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:32:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7CA3BDF7A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:50 +0000 (UTC)
X-FDA: 84450410100.07.EC771CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1572C4000A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TiPhr6vn;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+W0CZMoEVVVoVkJfZ+ffo/4RV9C0CRJ7Y6RhlRp3Gss=;
	b=06Krm/utXeSjd+AlcqkLnMOw3glYvUEiRgajvuahPpy1boPqootQX7uU2IUR/uJRf2x0U4
	4ructCq7m6JevpLwbEhJPYWggglscugmxsBeBNYhU8wSPBIk3n4IjDPxBhJlZ6HN/eConV
	NTyESzt0jqnFBaQ72rnuFg3HAeJZoMM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TiPhr6vn;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248769; a=rsa-sha256;
	cv=none;
	b=T/Ab/ufXhwI/3VA2HHsbSJpPLxUSae3fVKJ5BLnKfgoB5IMemU+6wSPHvGWOQU+48ljeOC
	H/8yTSfbjfCK3LT+fOqIIzwEAZdzUdY4wl1Drz1xeRjNWH4ZdJzs7YbEnqErK+Kcq/QE4o
	77cwUHGK4P7FHBoilK+2iWXByjCxTF8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 444A2414FE;
	Mon, 16 Feb 2026 13:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26B7C19423;
	Mon, 16 Feb 2026 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248768;
	bh=UGS1CMJ2ZqHjOV5UFVesoa2erJ7ZK4K3eqstwjrfN6M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TiPhr6vn5MwWVSkOJv3YQl6S+YMB3GTyKrqaBvoIHCOVFVlId5zQ51AYLutQPHDNM
	 hEE37rv7bajB/M8roxxMiv+JcR4Dv87prqre4Re+6uLLj4/gV7NVVYSOtNyxAJ2q2T
	 mI1+iVb5sRdT6hybvU1q1a6FZK13ieKXJIa5c24VNOw8IRdM6t4sh3apUfmvVeWszK
	 9JpwsGvTrks93gn24gx05ZCSCoUPOvl6bDV4Ugip7ehjkdc2DDU+ta89hyBoBMiMsp
	 V3M/6wdbAciIt6MDl9acNM1+IrEPlEh6ZAodpyeYNhNtd9+RvyG7bT3G1baMhS9wGe
	 WtO5stfcFvORA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Feb 2026 14:32:04 +0100
Subject: [PATCH 08/14] xattr: switch xattr_permission() to switch statement
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-work-xattr-socket-v1-8-c2efa4f74cb7@kernel.org>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
In-Reply-To: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jeff Layton <jlayton@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
 linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, 
 netdev@vger.kernel.org, Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=1182; i=brauner@kernel.org;
 h=from:subject:message-id; bh=UGS1CMJ2ZqHjOV5UFVesoa2erJ7ZK4K3eqstwjrfN6M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWROlom7r3xTgsWCs13dmLdvkdeWCf9iTmy2fslg9iVwN
 tdipjcPOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYyo4uRoctEMG7jo3uVzvs8
 3/HZrSnvMPGYJ3W90fNWyQG297WpZxn+V75jVduyUZ/vfIbm8ee8ckdDSgMmPxaYkR79/Zxx5dI
 JvAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1572C4000A
X-Stat-Signature: g9pr75rxu8txwoyug6i9i6kzn8fniw7x
X-Rspam-User: 
X-HE-Tag: 1771248768-227282
X-HE-Meta: U2FsdGVkX18c/mTcVNpYpNv1K8sHYr61yPwAds/Q4gPMD2uXQwY/mBr2qKg31mPvP3DVzdDYK78eshfJsE1SuqKrNlDoGyRkvYCUoe++03A6zaVcp1+9kFVau6Rp/YoaDKce0qBP5QaMqYHr9nsJovWdE52gweFngsuFQLeSwfpBcejnydOaqsOcMqdR49D0x5UzMR+vFfRayrew8EAQZ3jOP0PQeKS27P0yUTsfWpBt/w3QsE7eoNO+fQDy184lCMeFVosYcznkscr4DMUNptgWRv3AmrVHNQq39glFbz25yX2QegVJtQZiwH57Hw07eoH+HmswWovzsLgV743kaoTV10Bk4AtB6wnjnzjBUwHkpeEPQA0FLUzNCMFqKczrg2Viy1im/1jyqw2DVlWyxFBhmPOB+3G2d2oXeKtbJylecmfRe7o+E6Mu8LzuUDLsUNiNIDJe+hZ8b3PaARPbkGr5nV7GumCMfLWZkI0XGH8B2Akuew194BHk4IpZhcSAUEYX8sVD8W4XwMTuMVqBYCM7eR3jsc+ufuhJ5U/m/9g/3Mxe1chLKjmt1U3N8TRvmsXP41x8Pl4TzWhRg1kt8IZN1D996osn3Sz1VlIeJMvh1yZT3JOvDdcoQZnACJXsax8J7+GAXGQP6VfZN6t5HQT9uL9KYnbqBdFikRezN6ybcT8FDYijebRjdvmqnVVrCYw7JzCECyBp9uaBG9riPPMv7j5LK0deNODL2dJfAPVNJKl1w3IWqw6IJBe/TK1H5fAmL7elMck/r/076VWXYZMstFcUCVNxOZBQAH2eZtD9TLjzHGfy2l6euKun9yI4yPm4eAqFP1KJro9jLJVcnU6vpdD9B2RfdDzbN1B6tRejU+93c1oy6wXc8PT2nSkPf7cScPEeRuWNrNcbIij55nYwiFgWMborT5mfCX0yrJfkzV0Ox7hpa/D6/YnRR5Jqxr+T6imI8AmY5U0CbbK
 t5F+omXd
 QrIn3sJlZ/4cMughLafqHWLy0yHbmsSefOACWDLT/Ops9I1iHdz95cgkcof07bhLaKNyqKAyHAsmNJnJs4wiXLycdMOl9ZyiKjF30qT8rfBzIXSOoz80GYx+ptUjR1ElKwMRrv74vpTljrh+W3BGI5Q5odtjCmOd8KwqxgF2PRI4IAcU0Tdr4ch1aVuGdSL+uOID/g2TQc3lBixQGuxmYZ2YiRqoeGKU0XAPaMX1X9dwUhbJDJD9Ug8O829kGGwL4WsN8qnzmWuYyjY0g3KtFcOknrhlQMdMpSWZK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simplify the codeflow by using a switch statement that switches on
S_IFMT.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/xattr.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index c4db8663c32e..328ed7558dfc 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -152,12 +152,20 @@ xattr_permission(struct mnt_idmap *idmap, struct inode *inode,
 	 * privileged users can write attributes.
 	 */
 	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
-		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
-			return xattr_permission_error(mask);
-		if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
-		    (mask & MAY_WRITE) &&
-		    !inode_owner_or_capable(idmap, inode))
+		switch (inode->i_mode & S_IFMT) {
+		case S_IFREG:
+			break;
+		case S_IFDIR:
+			if (!(inode->i_mode & S_ISVTX))
+				break;
+			if (!(mask & MAY_WRITE))
+				break;
+			if (inode_owner_or_capable(idmap, inode))
+				break;
 			return -EPERM;
+		default:
+			return xattr_permission_error(mask);
+		}
 	}
 
 	return inode_permission(idmap, inode, mask);

-- 
2.47.3


