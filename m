Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AE98C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0D76B00BE; Thu,  3 Sep 2026 03:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A626B00C0; Thu,  3 Sep 2026 03:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601C76B00C2; Thu,  3 Sep 2026 03:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F00CE6B00BE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 992DE1603FB
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:41 +0000 (UTC)
X-FDA: 85171656402.23.35CF798
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf10.hostedemail.com (Postfix) with ESMTP id E7BB1C0007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=2n1aEsew;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=amGLpWRC;
	spf=pass (imf10.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421300;
	b=U9QxruhOz0RINOVilzraoMSQKXvTyfBsqT92d01FKDNpEGdVb9Wp61b5xMLLhFNR92AvNR
	/LhoLewfvlx64Y6heHbO/DC0DnPtd0BobrPthVH/kbpU5NELaefzDQ+L3mxv46Iv/BlonW
	eOVt3nSrbuXrr0EpoE0NFePKwxh4Sww=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=2n1aEsew;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=amGLpWRC;
	spf=pass (imf10.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0aZut8kA+4chJGGwM3gCf5+HQ533NpmMKcsyR+MQing=;
	b=ffhEET+HiuYFtHnaIDvJ7qD4crS+51+Xb9L+cGzVlvazAyxBojWG3/w/YueMYh57uUM13K
	f/Ly0Hgbh8tWBqQiMNRuJcCyi5W31Quqo55cOPqMUNk/TnSnquJOe8h3v/Dj7L3azu9iZb
	SF/2Pd1Cbh/7M+x5a1SylY+MDXSNz3o=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0aZut8kA+4chJGGwM3gCf5+HQ533NpmMKcsyR+MQing=;
	b=2n1aEsewcEY2O/4HmcehE0YE0VieS3W2Gs7Xi6wKvR4tHUFLZZdAgWR7QSYOOUkhJPQYgK
	Kf2YukB5g2gEpDitBxuqTpqVK1ts0CgTyVz6Ft/ZacoKjUo1xHG5dq9fA1bxtdIte/vSMa
	58oCWjCpgyI39K14Qkp11rzvyd7YXsrvwZGArqXZ/wa7XZbFvsNdzIviRN6F3eu02VelMS
	0IR+KoFKvbjgJLQBuTr2jCrJ0mmGsc4gS7EcrDz4+L54rrwo5R2h8w1UoisMF/Lh8uc4m0
	RuqlyQoxX8m9GiTcSRlUh4IIaO/IBeLdHZwcZlUEiN865f/h5LeGkrWqIAfMTw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0aZut8kA+4chJGGwM3gCf5+HQ533NpmMKcsyR+MQing=;
	b=amGLpWRCPzszmWf2agPqW3Fg7V59XzpRILVaIxSaD3ICIskVDU9Cfpi1H6/i1xn+cRW6Jq
	FawyH8+8sQE1GjBg==
Date: Thu, 03 Sep 2026 09:41:30 +0200
Subject: [PATCH v2 15/15] auxvec.h: Drop fallback AT_VECTOR_SIZE_ARCH
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-15-5bc32a71e3d8@linutronix.de>
References: <20260903-at-vector-size-arch-v2-0-5bc32a71e3d8@linutronix.de>
In-Reply-To: <20260903-at-vector-size-arch-v2-0-5bc32a71e3d8@linutronix.de>
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=772;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=h0d3/9vi5+RkvDv34sEYqTWGje2TjQ5iv2oSp1yFOKY=;
 b=JaGBRkuyra1orRqWHzX95kpMA0xW4S8rfsJ0pler5rGlI0La87KEeut8woUGbU1ptSxEISgz0
 Ljvg0UEOZ/ZBH8ervfYSiUK0bZeaLfogWTUGiQhqsWdwyQWXx54SvJ8
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Stat-Signature: jhewrwdsryfyf9fsg9tezm9ismqrgexg
X-Rspamd-Queue-Id: E7BB1C0007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788421299-196147
X-HE-Meta: U2FsdGVkX18QjrdijJ7EiPQ/YRFl+XlRtbw3Xe+FgA5ml3h23+0rS1fsAxAKpsv9W0KxQOfoo6HljpytZD+pf9QO7P9l+J0oCeMmFKVCdrI7sP543knFZ2GBd9b4JQsVICfAz9hmBLdKZ6qVpSTG5IdGRzmM3jXC8DaWmZjACB1HKa7O5BwHeX2YEh0Qt1x6Nd00fgEhSVYpFQbIPwZN/tRNYZQuAnUcE2BgdIvjup8xNWf2sfyrc7LHCdP4+M5vKSOfg37L0602nstvvT1igsln4OeWzzPbN3HT149V9gJBrqwXreazKf0n4ErfwT8hef/i4mYGchEaFFMz8LOri4JQ+CcIh3zeafZZ1M0mopljUaHO6ENCES0RmE8VnFnq09N8aunFfM+zUY0qjBb44hasjqpYfn1L8QQFezdV4rKw3HI/VrODJ60XopvILmI2JvqEyxI/de5d+mjmw5R3YRG2IMxvLR4/osQAEhd2NTgqpc89j+DmjAu6agluYhLnU+9sz4ApE+wQNk4szklBnZwh3drW6YykNwZ5F2xIEPXCTzn1cVc+YWj8CtBtGMk+JGuo/Kn2ZEJQv9HM2T2rBzuhpWHPOzdr5PgdoCjClkwSq8q5nw55azh0vUNmx8kt7RqLUJT4iFKS0HmBPUtN1vfCj3gZYoiSLlKrSoy7ZsJEW/hujpXrpKByq4UUEDcfQX2JZkK2j+K1Tn8qBImqYfxs7wP/6QJ4nNxQuN2NW3lBLQSAPIboAD3yCdgKzK+8W6cDCwiitF6yatOJBqNkHOBCgtgdXOS0cWBx1YOaurxzwoB9z7zSFSg62HUJUzUe+RFdTVvIK05Ij9bgGF37u92VBAPITEHKelKM/dOlL4lc1UIse0znjDmKL+z6V/a8KZ76bXPOrzz6slJE4iquehDPAvOIMzhaVu6E8NQ8GpDibY9yD0XN3ggVZzr/Ubff5t7+Cbt/JKWbwbJjGJu
 vpIL02mF
 RhLa5V7BYq+iaUm5K8eQaiBNyyKA1GJScXui5kwfdLezm+sWRiGdZNAjo7kWYoGZeRSHjYUqtgCA8F/lJ5MbW1Gb5XTSFN9WnXUTMHWlxEDFe7A6DNbGzniv2DNZ6B2Z0tIraby/vBBpAS331p2vXyPmWHjPvjCD67qvsmf10xYwBPBrnnemxlxLyHrx+rJhXbRcWZ04TQVbsmK/BGRk+FAb+kYmUCMS31VZctG/ylI6+BjebadYmAQMvrMtIANgS40LP0FjkO2JtRRHYdzWezu118ZZMn/sB1P1wCNK4fruUzQ1Uh6GP/ka3w2IN1hvC3HvHE7Q0QXyLykL3iqIXKNA0gEpbGbOV6WGj2Z0h+U8CY5l7ZzuDDrdp4MUpzMAqIgmR7fH9nE5iUGXgXsUJeWXkJsgfslAFU+q7ebBz9wFOwuR4de1sh2F4VB8FgTaFiOU2AGjLqxpzRFO9AZCzUirg/tODz2jNPZWciR9pSmDhDbAVQxkN5A25IUFK5cvsAm1eMrj7iEnnfm1r5/dBbZnsg88X1FOyTMPVUxXjFujI33Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All asm headers now define this constant.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 include/linux/auxvec.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index de1c33c4a256..f7ddea1dbc8e 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -9,10 +9,6 @@
 #define AT_VECTOR_SIZE_BASE 24 /* NEW_AUX_ENT entries in auxiliary table */
   /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
 
-#ifndef AT_VECTOR_SIZE_ARCH
-#define AT_VECTOR_SIZE_ARCH 0
-#endif
-
 #define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
 
 #endif /* _LINUX_AUXVEC_H */

-- 
2.55.0


