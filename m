Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03F2AE7BDBC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E4A6B0096; Mon, 16 Feb 2026 08:32:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644306B0098; Mon, 16 Feb 2026 08:32:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56DB16B0099; Mon, 16 Feb 2026 08:32:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 458CE6B0096
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:32:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12B2913C276
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:47 +0000 (UTC)
X-FDA: 84450409974.07.63B071A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 48AD8100002
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IKZnc2bF;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SZ2YMtw8gFpWp3YCsugKkrsUEtLcDC4oDh9qRJSH/2c=;
	b=6JKE/GfZvrAjdaKJ0q18FNeSzuAI5lBS3jXDvPIdBJ7Fbk+B/1ot2YfESjnlgtJWQlS1Z7
	hPhiwS5du5JrXxGb8ZRH2uFuwz/1jUwweHTcgtKQ52H7fIypzf+hHqLVj8aSudhUA7mmh2
	SFNcPSibLrJRzB1aENt4fBn0+rkD1FU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IKZnc2bF;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248765; a=rsa-sha256;
	cv=none;
	b=qTwBGWNV6z2FgNxIO3hT+fteSHnuLhaaaHpTh7CMVkAiiSQRooMcbO5qMm+Po51TnxNNS7
	Cib91tCmz3L7no0rytKVsU4R+zwBM6KX8cfmY+hP+iv+PdFPWbfdT5Ev8p9buSA6h4K6oF
	i92ijhh7EFsKPflp0qJ4AxDe9STcEz4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB972600BB;
	Mon, 16 Feb 2026 13:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFF5C116C6;
	Mon, 16 Feb 2026 13:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248764;
	bh=96SxHSPi59GBrRPEDM8gKWYEJ+q1qKqGM49g4nTkdB4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=IKZnc2bFfW0W82B1axiPsfeG/OH6odSnFk6t29PyOLxGZNrqeUK0mUj25LUOU7Ziv
	 A3zbGKEOFHiWHaPfAokCeFQZSRrILdRzwlTIqUvTzIT66H6l0g8ywsCy9KPcUuLHFz
	 jipGl3KpcuDtIWn1Pys7kE7xAoeXNKM95L3+1Qzt21agvqjmsgRFT9JK1az3ssdTT7
	 nDH5BQpoWz2BrV2zXLAJiN4JvemlPD3Vk+7+LOFvQEaHzXbWekHzZxk7D8a22pJwu+
	 Y83CBOWXA3QPiDwb9CBWSo2vt7UnEwVQja7kxsYT4mgSUwDYRi2WCVXoEHON8i6Ofr
	 QY6gb/Tbu+rEA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Feb 2026 14:32:03 +0100
Subject: [PATCH 07/14] xattr: add xattr_permission_error()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-work-xattr-socket-v1-7-c2efa4f74cb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1499; i=brauner@kernel.org;
 h=from:subject:message-id; bh=96SxHSPi59GBrRPEDM8gKWYEJ+q1qKqGM49g4nTkdB4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWROlolTurXu/ddPcs+fdk/9U6Am8MhlAv83LwnD0mgpY
 42qf+tdO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACby35+RYZHzvxMMF7deDl7+
 Luzuz1ger61N6y/bPDx6d2PX1idffi9l+Gd9eG9O78xDSiUs5hGruR/YiesulhGeujJ/7rPiMA6
 u+fwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: eukzfhp14qxrcx36r3ahfy436gp441hy
X-Rspamd-Queue-Id: 48AD8100002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771248765-666441
X-HE-Meta: U2FsdGVkX1+REMNPuqZ4sBQslA5ctrLgwlI0XYbCOw0up2Ysli9r94AM2noKqBwk3dcjZhIMfILV038OY8lYM64nl4LeobWzDGUMTDnU0pQd6qk8L/WOEFXfYGSOqAn3dqplx+IKHsWEBnuSrd4jbprBn5c4MCT8nVZb3AJRX4FPDZ9C5g5/HjO5Ani/ing5653cqSdUcPQvjVoRMLM3dAmCNc5VWPpINTk0jlkh/4XzIYqkenmCUDzh0F8qdncOkIm/ODow19AiRcponKJqbKORHuOnZB6KGjD71bifctuSKM6xlZkQY4hpaZEXzwGpZUhEldBGbKNPXrN4vUh6KT/n7auY9zYse8onITFTjzjd426EZU5fF3UAxl/UsLNs6ELb+BOvS7OCuDl4DvzMztKdnH5H3/Dqje16xdmxAYnKibZW8WyHi3Q6CwRpggx0tYC+jkpPT8wbNh3Mt3KVEypRxprKGUQBCcjVucaameQ+aZ3IZFjIGoIttEKxuPSvXFtcNR4JTRUHrACK9+dkFguSAFiDxHQVtHlO65yinY4X6M82kFiy6LxbS9JPz7EAl3qFJ1jAbWQkv0vF1vQ51HZpKcZ5h84g1IIUQqIxCBoW9l7LTV6/qOV3xWKD7EM6FWb4Fuq2W6hAKgvMdsE5U5+y4JcAQfcQh8+knl4BJ67xhRyl6CwHT2VcL3FiMPkK7oX0OMO0Guv12l+qZg3i2LLWOpCCwfDySTQeGO1OsHfYaFb28KjylwenY/yBnCB+xb6EwgiTQsWKNPvIh7le+SfqXGIDQsFkAUinANkA2mKZNE5+hiz574ZVifksUiPYoIC7C90OKpzfhZiHt1HObuRrXulrbx9xymj1bmviFaIz/0Hq2XmddxJaFz9XdUpZGoeC2MAtjnYVm9I9s86ETUstIlp9P+U869kc8jQbFMlP6J73CHIp5D7qwEP3WxjjHhFYgBGa8T75lRqnX7e
 HnnqDC5D
 cUQP0Cnnu94buYmoJ7ZxMy7sIE0RW5IM7Iue3O/ES2g58yED28qBYCBd0CHTfZ5veJ3pX5UMNiEZ1s1HCgWU9Xiao2dtEp/qE1gfKCeh8vM/fNyt2ZuHvUOxwEATs4369pR5jkG8g5G0L4ffra/UQS6ZnyTe5pzk1Tg6DdZ/lsftJlM/p8UHPgEGsILZbQnh/qDTw6PZndk9y3pvF7aQrDJLDGniQplSq9m3jbMbSxswfWX/P8AaExjodhO19mWQYRu7Lve7ZJtkIA6SVhCmTyRQIMbYGhYqdUWIk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop repeating the ?: in multiple places and use a simple helper for
this.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/xattr.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 64803097e1dc..c4db8663c32e 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -106,6 +106,13 @@ int may_write_xattr(struct mnt_idmap *idmap, struct inode *inode)
 	return 0;
 }
 
+static inline int xattr_permission_error(int mask)
+{
+	if (mask & MAY_WRITE)
+		return -EPERM;
+	return -ENODATA;
+}
+
 /*
  * Check permissions for extended attribute access.  This is a bit complicated
  * because different namespaces have very different rules.
@@ -135,7 +142,7 @@ xattr_permission(struct mnt_idmap *idmap, struct inode *inode,
 	 */
 	if (!strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN)) {
 		if (!capable(CAP_SYS_ADMIN))
-			return (mask & MAY_WRITE) ? -EPERM : -ENODATA;
+			return xattr_permission_error(mask);
 		return 0;
 	}
 
@@ -146,7 +153,7 @@ xattr_permission(struct mnt_idmap *idmap, struct inode *inode,
 	 */
 	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
 		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
-			return (mask & MAY_WRITE) ? -EPERM : -ENODATA;
+			return xattr_permission_error(mask);
 		if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
 		    (mask & MAY_WRITE) &&
 		    !inode_owner_or_capable(idmap, inode))

-- 
2.47.3


