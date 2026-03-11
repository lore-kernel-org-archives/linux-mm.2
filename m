Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F406EFD0650
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AD966B0005; Wed, 11 Mar 2026 04:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178D16B0089; Wed, 11 Mar 2026 04:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067796B008A; Wed, 11 Mar 2026 04:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D997E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:11:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 850DE1CA7A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:11:06 +0000 (UTC)
X-FDA: 84533061732.06.CA01504
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf14.hostedemail.com (Postfix) with ESMTP id 208B1100007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:11:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gZtpidJb;
	spf=pass (imf14.hostedemail.com: domain of rob_garcia@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=rob_garcia@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773216664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=11rxilNzodvuvzCLO3MeHRDznxrP0FHOC7bmEuqJ1b8=;
	b=CUq51AUk3q5I+728QUHBpaApjSTXsBjwP4/E6h2kjS35VuEg/Ibez9A9jcE+3xuOcFPoPM
	ttjeuCGp0fo7TjPljVmqvY7ze3Ph14+We/luxVzNyUDgHytp0G5bbQHz2iGRP1PWs8o3k4
	wIvxwt1BespdO/5bjzvBtHvVJWr2DUE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gZtpidJb;
	spf=pass (imf14.hostedemail.com: domain of rob_garcia@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=rob_garcia@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773216664; a=rsa-sha256;
	cv=none;
	b=xMKCqxMZmLONPxKKUDA4ReEmFXr1lz9wsqwsed9Kn92HzkSPpQbLCKQFVM0BnFTvXA8ebF
	AOpglcsnm8h2oOXQMMT6G+X79vSvVS9sJP+vXOu7YJEm7HmnG1DGf1OLuJlxdUiI2cYxuy
	QOvzbn6EoxnlRzqEsuYoIxDkl49JfEQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=11
	rxilNzodvuvzCLO3MeHRDznxrP0FHOC7bmEuqJ1b8=; b=gZtpidJbqu4n7DCX9M
	y1MOcYlubfMsNlT+LZFEqmgpl/36dSR0LIRlnMVAS5pys8b7t8827OwBL3kbkOmh
	LgCLRKq/dW6+gNLQOi2CRc3leEJgSY8iQdJLkirx4Dg8UxzRRkngM/3NMzydaufs
	gEaiGpgWYKDdgevh3mCNsVRRs=
Received: from pek-lpg-core5.wrs.com (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3v8OGI7FpmUFfAQ--.47091S2;
	Wed, 11 Mar 2026 16:10:48 +0800 (CST)
From: Robert Garcia <rob_garcia@163.com>
To: stable@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Robert Garcia <rob_garcia@163.com>,
	Jan Kara <jack@suse.cz>,
	Eric Biederman <ebiederm@xmission.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Helge Deller <deller@gmx.de>,
	Lior Ribak <liorribak@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5.15.y] binfmt_misc: restore write access before closing files opened by open_exec()
Date: Wed, 11 Mar 2026 16:10:46 +0800
Message-Id: <20260311081046.1668003-1-rob_garcia@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3v8OGI7FpmUFfAQ--.47091S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw4fGF48tw1UurW8AF1DWrg_yoW8WF4Dpr
	W5K34UtrZIqryj9ayvyas8XF15G3Z7Gr12vr4kWw1xXF1rXrs0gFZ2g3yj93W0y397A3yF
	qF4rC3sYyryUAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UxWrZUUUUU=
X-Originating-IP: [60.247.85.88]
X-CM-SenderInfo: 5uresw5dufxti6rwjhhfrp/xtbC5gmxHWmxI4mC7wAA3c
X-Rspamd-Queue-Id: 208B1100007
X-Stat-Signature: 83zikfjqcaf7b8tzpmgmu9ytmqxte5i9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773216663-332490
X-HE-Meta: U2FsdGVkX19HaIcadIxrN9+TMp9dtrWGrvPPj9Cz6YYL8TQsfJKT5My+3JWVgAFFwQWZjhrcTSEjl4dvDC8RD6s6nQ3iVV5gn6DsGzjkc7lw5228YpvKjBNvY+KjKpMd5wjNMy/GBOvWLqy8t/tpDQSlI7FTKIPk/lD0vSa1dM62Jr5X9HEIUn462NwZYtuTiw7ktZe44Zmw8RTE4/Ee4/H3PMhtGBvjabgC7N3ItA1wuRCug2stySxd6M/0Xkp2n5RxrAduqEG7EFE/jeeVJz6xvrxmcGinip/lsydAz3GAoxRXiYej6DHYq5OT0KTfMJt0mU/2Ds87MrdaTNoDh6KR3dC8QweoWagaECx6qLT3uglcslGK8fW55j3Zi3Mg/qTIEq/UswVKuMvE53INJ8s8yM+rk6UMznuEpXcCFTeE8fdhyRrJVOMiSrwFPIHaWtQXmi6JLb3D4+pVXO79nQjuZ9hZWVtyDNUyPeSWSTMQaSSpJ3ap14wivMtBHV1Q7aOWzD1fs5GsV7j8XafR0QycFyi4p2Q5Tj09yGD8efAXdIZJtuyITcZ9FxOCMsQtr+4wVKEQ9QcazWg/ThkhAJHd43ff1xL7C16r0BFdpFsIhB1YtTdW9L+DtiNkjMLAUbtDTDTv8Kw0MKWD+cIkq+//liUFqUMn0MvmmqGIds82qJnkT/gzh1fr6+zPgxf3FH/e4zvMSbcY1yipVScTJrMyiFj0bA4BFbVirchE9f+p0l64JedG3sKIGDpKYZyn/aE3PtRqfj7UjSYPRByXS2+mWjY/I6M886fJqKfsCvzkwG41uXAAygPABDUmq+OlxTreyM6mzIS6dhcayju2aXhzEHY7ACw/M83x153dZ4SGqclLXr+cFExv6ZvGxPpv46I+TjA9l4cIMKQKQaBTFi1J6I28erklQ5Vz91mO6cDRRoLF2S06BnVYKbdkiyv2GGKV3uWJHChS1sZ72CT
 aTr8cGeg
 Hw1qjuxgHDkLppxwwrg5/CsV8lirPlXTKi2ZgA2+dXEQuu3zKYlR2EhxhCS6TmbMB1m2g+odDgTc9UrWjiMsdBmPzIXCR7KhUxVADwyCPsAzX8uTqqbxw0Vh8cdm/0DvOTSkLxU3tvskTiSaUMguQi2ArawonYcB70cz+0A78jNKTlWig0ZpCf1TH0D1f0yyT7XHqlUQADp9YeQlEc014aAN8Zs1RCsbdNpxUA0MeM39LZ2UhfegZZ9iiZBUlKAHRmT363F9eCWkb+cNSL9cXlZemy//DdbSjB0lH+YH2Eydmtw/RnDn+3FtDkoKpx0nKIdfR2/1VRUoXY1ChUwpPsR8DGZFG/Ag3CyRzbmt/9XlXMJZoYeCFJwCg0fc+4bVgTpvBxmwafO07conHTVaiPIrZMfak288GmF+fxu6fgdUa6TKzh7F3pUpEwvF+9xhW23I/nkJ/v5QNwOgv7vilqpoEl/61XTu9IzoTs8PmPW3R8ijQcWeN6tijtTsJgnOBPnu0HX3jHC/1SQiel+UwknXihjA3vsfrOJmS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 90f601b497d76f40fa66795c3ecf625b6aced9fd ]

bm_register_write() opens an executable file using open_exec(), which
internally calls do_open_execat() and denies write access on the file to
avoid modification while it is being executed.

However, when an error occurs, bm_register_write() closes the file using
filp_close() directly. This does not restore the write permission, which
may cause subsequent write operations on the same file to fail.

Fix this by calling exe_file_allow_write_access() before filp_close() to
restore the write permission properly.

Fixes: e7850f4d844e ("binfmt_misc: fix possible deadlock in bm_register_write")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20251105022923.1813587-1-zilin@seu.edu.cn
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ Use allow_write_access() instead of exe_file_allow_write_access()
according to commit 0357ef03c94ef
("fs: don't block write during exec on pre-content watched files"). ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
---
 fs/binfmt_misc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 740dac1012ae..05c235309421 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -816,8 +816,10 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 	inode_unlock(d_inode(root));
 
 	if (err) {
-		if (f)
+		if (f) {
+			allow_write_access(f);
 			filp_close(f, NULL);
+		}
 		kfree(e);
 		return err;
 	}
-- 
2.34.1


