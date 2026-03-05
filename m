Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F0ADEFCE53
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 02:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542C66B0005; Wed,  4 Mar 2026 21:38:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F07D6B0088; Wed,  4 Mar 2026 21:38:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8836B0089; Wed,  4 Mar 2026 21:38:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9B56B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:38:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B02B08C259
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:38:38 +0000 (UTC)
X-FDA: 84510451116.01.12EAF86
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf14.hostedemail.com (Postfix) with ESMTP id 04219100003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:38:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gSmQ8gEQ;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf14.hostedemail.com: domain of rob_garcia@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=rob_garcia@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772678317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9RlnR5jm9PhBAUJXCN4QxuMr47fR0FrOXWZf5lEzkxk=;
	b=X8aNapRWWyKYkC4tdEQ9yjkYytvVgBtL3uH90+VG8b1JH8ne6vwIMVAWr7iUhly6HXzVmP
	dF1lVhz8mkh7sD5jgEYqfb9uYOdUHEP3XTRB5nuNH9gtz3TdVniqUU+1iarZlQoSoWDSxw
	LW2av/DeAB7fJEf1PJr29tcP3du4H0g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772678317; a=rsa-sha256;
	cv=none;
	b=CZmAhBEyIe1OiJRDKVKt33KNCGaYAStEIyac7UW0LFQS0ltlRxw9ohXg4V+zwrHqRlP/sV
	o7QsMYLKSgL/uWoXp6NQXJMX2yeOjmYLbaKCtjKNT4HxeyQx84yslTWFwYAMwiRd3Zap/v
	6mndk9+Q17+g3UQ8jLcQt6Wr8O2MFqg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gSmQ8gEQ;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf14.hostedemail.com: domain of rob_garcia@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=rob_garcia@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=9R
	lnR5jm9PhBAUJXCN4QxuMr47fR0FrOXWZf5lEzkxk=; b=gSmQ8gEQ9WbdBwE8fA
	yTjww1L29EOpFp06fbZel4LBArgsy2LE2GP5xVtIIhG4o8Vms+0T8ELDE8oOGJ1G
	Wb7slHvsxDINA0KLN4R/KHgYutlR/8sjWyC6qifUXVtYYRFZVoQ81bG0LOdg7sjO
	5cgks1ZWtI1ET8h/jFN6DTxz8=
Received: from pek-lpg-core5.wrs.com (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgBn393V66hpNnfqUA--.606S2;
	Thu, 05 Mar 2026 10:35:02 +0800 (CST)
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
Subject: [PATCH 6.6.y] binfmt_misc: restore write access before closing files opened by open_exec()
Date: Thu,  5 Mar 2026 10:35:01 +0800
Message-Id: <20260305023501.4003943-1-rob_garcia@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgBn393V66hpNnfqUA--.606S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw4fGF48tw1UurW8AF1DWrg_yoW8WF4Dpr
	W5K34UKFZIqryj9a1kCas8XF15G3Z7Gr12vr4DWw1fXrn5Xrs0gFZ2g3yj93W0y397ArWF
	vF4Fk3sYyryUAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UoCJQUUUUU=
X-Originating-IP: [60.247.85.88]
X-CM-SenderInfo: 5uresw5dufxti6rwjhhfrp/xtbDARa0IGmo69acswAA3Q
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 04219100003
X-Stat-Signature: cezys3rxy9sddbnemkio4pjabbipscar
X-Rspam-User: 
X-HE-Tag: 1772678314-460887
X-HE-Meta: U2FsdGVkX1+aKvQCj6SwPWE2wkSG+UuRLuAKqnroCSICXzyIh4bKpvuFW5AySblIG9Da/dt6cGsLLIWczH6aOri7LXGGqOrJneAlc5YWwhm/XQs+sitr3oioeQeo8I/ZtWCrBLSil4/zXdh2Ve2d3WnVUANtHwdgEiy0bc27pqydY96FlkOCXb0Ssbrk/KeJfukk2ptCjdZJ549S2a/EI5IfzmTmgKvMg/yy7aptE//YhEpGFQK6hsNTL8lGry1FJjThXpEKgNGp3smBIEYlmRUw5refnCSQgR8rKidBc8Wz7ofyEJwYXMVvJLynJnAAu0HoXZ+L/RikS5SCBz9MVHUkHGyCdY3pampY7sYxJD5CZdzeWd2K7N2oTar7PerMOguWNRWIS0ViSYy133i7Au2u3RnVi8dQqhjV9htHrgY6SyaKHhQhGXM5EgoSiHwwuzbfFQihkmMGKNzGH44EbY9U+dq67rdx9Th7ReN3y976fX5i7xzSYSCZdgYzXjV1PyAdKOLGGFhpbn9SKKCmLg5SVon+WCk9QEH8TC1UMdsJvWDTHhpHmM0ahXXlthonTOgzEbeftiOtIfIEtKV8vzo0RiOaiZKxs93CtGUiiC+R+p7bwTDsrtNbLvIBwviYu9vqCmXp+0iLcw/eNtg1t1alYRyp7xiwqxs0KbreLGJkV/9CLZBFtuIHxreaH5ND+d5TIyDB5ACinYvmYjis9kNy8sg3WvhFLmFUlfQW7qiAd8gArJXPDiRlEAUPxRZAJpXxB3BZVvzLCV80AIgTp7fZyz+VXicGz90yEKwKTRSBXDECXO5EPeqtpNvEMWB3eeVee+wn0cNkv+F+waOBfE3HD4wEDSw6oqxkyh8fjCA4LcB6PdUaTwh8WRoMrr615RIB4D3PRvk7yKcIyD4q1cSRllAwmHayn59/4rTOfoelUTu8dXK5blWBw/yPDePSaS08ECrVUqcnLRm5h4g
 XaB09JoK
 ktKOBC/OqvNYESI+/rwrvxdhM8I0hjF684s6sRGdHa7lDGGb3A7uTs/OUt/ngONccd544Mah8OTTsly1MjiIbGi8kxykm/8jhZGUMEs35sdqh8Bf2nZJJjsQop4Pl5bhHXxqKh2ZrJ+8qSzwJA9C/FhQMC8Vuwk+PHUg+g+JpFm0iTdP2kBuORtTV+Awj0A3clHvVqwntpmivtD0dzrMibUMmZhmY1izboPyInUVXn3is5m3DegWBkFSvjj6O18qEhbS/WEMhZDMnXcSXmQM9Xe32SEb4SWvkj+y0Zu0Xa8flcjqVJEvm0RYi3eb0uM94qapB3fkqoUbD8plYmYvd3JfcguhV19HiPeqxIMKp9a+mYy9UheL9OcQXvTUBKovCyJ5tsj1AvcZcHbIHVxCUImNZ3zbliLalw7qQbw0NWSrlmeheBh96i3KguIvQ93Z5KmUCpjLRbJHfVAwdKfxpFJvCta5nMdQc0nPU5NRvgMsQbhEwySCkKGbo3XmbgJ5MPhibgnC127WkrKWVKyIDAX1UATIkC+8KY4yt
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
index cf5ed5cd4102..a45b5ba12a9c 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -815,8 +815,10 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
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


