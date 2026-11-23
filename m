Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B872606A6B2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=vjEARtx3;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=Bv6jhs2k
Received: by kanga.kvack.org (Postfix)
	id 054AB6B05BF; Mon, 23 Nov 2026 04:37:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9696B05C0; Mon, 23 Nov 2026 04:37:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72976B05C1; Mon, 23 Nov 2026 04:37:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B158B6B05BF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5476E1A07EF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:31 +0000 (UTC)
X-FDA: 85465881102.01.607FB93
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9BBC340009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=vjEARtx3;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Bv6jhs2k;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf11.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426649;
	b=Ben3MWnpiykouIOBWX/xwdVBq/8m8qLyWvyOxvgNAoBWHo6mNSr1DAGGowd/nXUqadFRz6
	BouuHnxPwRmDIs2iZAb6shoBcNKCWif9GdeJjCFazycNa7CZE6TEsdKeDg1Dir+qqhPTnY
	xm+eNAXcN+Ypal2nUUnUB/dGsn3CG6M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NCInxSxfWY/baS2gA67JI3oLj7pEl3r5Kks368DptXU=;
	b=ly6rv/afWB0KSKc88WSbhOQ//B4jybtS6ZOYrcgH3ZjG6695BlOKhw8Hg1hFvIM25fLVoa
	c1sY92/tmQ/kBVNzS3DlyeU+XgFtqpX6Q2hn7/KiFAT9cmDO2RXlDrz4kT0ZvTLCyMujVJ
	Ia077sE9lEZvIWQkjW0WE/ivnqjImiM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=vjEARtx3;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Bv6jhs2k;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf11.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NCInxSxfWY/baS2gA67JI3oLj7pEl3r5Kks368DptXU=;
	b=vjEARtx3r8J59QJskATSoUZ4rv6pYKWSlfmjme3JMa5M4SMhc00pFtHMCDgyNo/RDm/jek
	LH4qTgii1hs/98kIl27mTmqCtZSi005DRO4Cjlc2DLVLNphLx+AmEpvn/Bo0ob0YX9+pRi
	JKPkk8wRQhRAMHgB6Hz4v/feQB1i6l2oWyVL0g82/uAuUTmASb7KSJTYlmmOGlOHSxLuDI
	qTwLjbVU4BCKhZW3Nr+zS+wL99k9eWL3ahDiUUJ9i066kUxhW342oFJsKah/cVGgfHJMKU
	gagoIjvT4cj9bTpv6rBImolLvfLwtzW6PjLz0ZdIa6vTYCH59nQyLSTMVlIjwA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NCInxSxfWY/baS2gA67JI3oLj7pEl3r5Kks368DptXU=;
	b=Bv6jhs2k/3Z98uYG/xj1eKvxvDv2iFmRJNmQwdjgG+GwwWdPZh42RSCDYrGiOJfkoCQKPE
	FuYdk9Hk+TZrO+Dw==
Date: Mon, 23 Nov 2026 10:37:09 +0100
Subject: [PATCH v3 04/15] ARM: drop custom asm/auxvec.h
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-4-d342dae9e843@linutronix.de>
References: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
In-Reply-To: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=523;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=QV8Zwqe9GYXvbZYqVlVdwaxoS3NHmxQrRwiam48wlog=;
 b=fdt6Vfk48wvz262HQNr4SmvfAA10Ohk3rYDAIpAbpM/sJECol2LaeV8FpmmHNEQ1ymuzZ847s
 ZXFLZX7e+kYChBQotTOoDfC4e+OHkTMGZp7VlhKb0y5EVgfS9lHxPxn
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9BBC340009
X-Stat-Signature: waakeob18epep9soqzezizb1abatayhn
X-HE-Tag: 1795426649-520014
X-HE-Meta: U2FsdGVkX1/7/Ilbh3NEZU/QwtBHE3oA4IxnY2F3sO+JsxEvWrZx5jI3zMmdcGVsIKVCq1KGwh39l0kJO+DEktNK8dfymUnfhFMuZ24adb2BZnLc5n51SEDXKYwDrGTOqxEhZiWInzJbxG7eWM6BPIKes9Opn9s+5yjFepnkozBTKZWCCKeJJ6Ci4U1Xf29b0eBFALcYQQT/aWeT6mxfDpi25OFt7lGl1j5+Y+9X6YdWvFjUlokS+9t0IVzbmzYF4xPec9wkZj9y93/agSjIKMc9AUYlYqzShCVMx2eTZNFj0DV/g5Qpg+/ieJfWpMScpSCPwllFgnYHnkg2JjLbHvjlxSqKpwVhIiOXjkrfMZ251BQx+x8vF7JFsd95J6L0sETcT1MwAP6343xbeclLpqqNK1gKrwu7FMTXF445IPBwdlHH2j06zjOsRL5QGSBNJWAU4FYKCezNToVuwVUPjzg5KEwWUs+7Fn1SZ1rMj4j27T8/gLklY887HSRH4H5zkChVF0Rmx36T9WraqbHLo5pm/zZLJroHyt/60eoDuiskRrmZseLG8VOX2lpzR5rnwFarlcphfCvs+gyTbUIBx7p8MZ+cK2aX7jS5eIw7RXBlOOK/9giCn8yfUJgA6EqHtWwD1FQaRnrP+MIoBlrGAC2mSQeCPr5WZGP/sDqz9jTmpP+gIrfcMuWRZORjAA1FOK2v9kMEWpKkxwrkGfyRLNH0ZHxtXV32HKdrQdtAtKNnFSccI9Yr/BApEVNXqu/GgF3FareD6ryvXdkpGOLJP/oL0W/yNg5MyU2uBUGx1v0xPVjdjkq4xTMrHz2Qddhpw79k4QBeEF02gd8G10dPkfxnVn+cunO7klJ0VJ9jwhU/xcEdldHTwscOuAgTB0EKS9axbyWWz12EuMRD/6UQ218LINeBcKZV4g99KpF+AE75/9XsehHWU1l29g7VYhPsIVc1Va1k91SZJsx+XHD
 LJgFKmPQ
 3MloKnT4EwknIKV2ddMRHpY+ZlqWhsDK2Dw5GhcYURnUysHVxg4E+lSrZjUSSndBn/05Kv7IkbhYKqERQD5rZ7n/5/N6SKr+HJPIdderNnGJ2lM53DCXFtIlWp8Ye2TWN4m+CgBH6Rr8d46t7pNXVlAilAjOjk6Vqbp5Jp34BZNbkZSGNXOlyY+76o+Rk9m/MhnN6SlLEXt15+qeRdWQC3vtqrKdlvYqmK97WhMckKWTQpZJxctOk2g+9SDNQoxp1AqdD1H/YZwDF7+9gNahBFDvwVzePIqWByMG7LsXiP7aq1eqA3I8obTojk3cKqjfwnjuL/OOTG/KPQ9DvxjQAGU61IN9tnfNwBEI94OHZA/KBjzTUBKXrh2rBYg+wZLCz8g4VSdBFkBJK0lqB2nYpJjs8/6qTjk0kQ8I+ehV9qekgFZhfBg3fiQ1zNp78nY1SCJslXFEjS5td3AN/CFz/734yalXuxTkxlsVhqq6ishuMbQXmjV5J+smGe/v+D9svT4TWSoRFDDe9B34AsBCBHnA7RS3aH4gZR0jTtWvi7TqwKFaVyx1lQR0JxKSDbnedm881ns15XbkwstouyS5kzeByk05WntVqbsvL3gNnz0nCLc+YrOga98d2r0m2Kfx2LfuSBlXKYpO6mqzu7MAnI4Zf2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With the introduction of asm-generic/auxvec.h, this header unnecessary.

Drop it.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 arch/arm/include/asm/auxvec.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/include/asm/auxvec.h b/arch/arm/include/asm/auxvec.h
deleted file mode 100644
index fbd388c46299..000000000000
--- a/arch/arm/include/asm/auxvec.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <uapi/asm/auxvec.h>

-- 
2.56.1


