Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F362F588DE
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF1A46B008C; Mon, 20 Apr 2026 10:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2BC6B0092; Mon, 20 Apr 2026 10:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1C626B0093; Mon, 20 Apr 2026 10:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C1F216B008C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:17:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D217E57D2
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:17:53 +0000 (UTC)
X-FDA: 84679138026.15.1809527
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id AE8A380005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:17:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eAd2JN+L;
	spf=pass (imf02.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776694671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjAX0smE41BTNjnnRZCLx7DL1jbmxY9+auerdTALqsI=;
	b=cfR7RN7ZEiVLdrFInC09ChfMbaowou9KLwQ/tGqAL5ksCki3RsrvinYprIBdm+2CWWF//4
	ynGKvCUzLrcZLCUy5RbQQfvuACT8dLNEBico33+hUq75QuxEiTPR/m9YiiZExXElMlXWOA
	91TJL4hqoNDb9YARovKYT15V5HFUWzM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eAd2JN+L;
	spf=pass (imf02.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776694671; a=rsa-sha256;
	cv=none;
	b=gek1Fc9QDgNaJuhTnqket+172DchmsyVOdi4FCGXnjNzS+sLRJj8nQew7WwSIBGwFnQf1w
	SQ53xKmJAt1rBHVKrHb2FMuUqzBNxRKSYLZwWAT5AGoXqFqI4b//omhT861weTs5w4d1Er
	jTarX3BJX4R1YayAsdMk2gLQGlyDmww=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso42833075e9.3
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776694670; x=1777299470; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjAX0smE41BTNjnnRZCLx7DL1jbmxY9+auerdTALqsI=;
        b=eAd2JN+LlZohZVbcdiPHjBl4SQl5jUBr0MbSNvaJ2Piyjo7EjBwAicaDVjpzEUDMwB
         BtozSAh9U2rWHf2ONFjwFTOJS3KLgEh0Hgrxg9HIAUe43aRnpkk7PPVYeh9I1PhgOAG8
         uEMjAEVfIRf6e3VDCgYK/zmV1I9ZkO8ZLGMU0A640Ow244YAN9qgOjHqruvikeFvi9IL
         bcZwFNUZp/I26MfvA8u1fuzssD5sgBEY2Oiz7GyYgUP4yD3qjJm+lLEMqx/vLbIgJIXC
         GcePQdEfd46+KIK8YA5ExAnK+y2vrlv/OGUCgNtHOrc9cllKfv59FvhNytwEUddz2XUj
         4F4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776694670; x=1777299470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vjAX0smE41BTNjnnRZCLx7DL1jbmxY9+auerdTALqsI=;
        b=LKQGFncEBdt4LSz57lO6Vj7rmRcXCs3gmUJ2bgwdPpK7nIto4/DAKukPjufs3t+bIU
         ODr/POf0DN/qEu2fIDuWJAjkBoYnxmZk0Zih7ermA4+N83NLO6j/z9XBZJ0L7PfhkMoE
         SUkE0S1fL8BI83Z0RiCwE4KaxeE7pEqi+Ulto82qbGkVnjwBACt3qmrbe6FXuQ9wDehU
         JEI8PfVd449le2/WypDWOtOTtNON3FK1A3bQv/WyoC3GNpyrixHYSy+uMzvAcCHSlG3S
         9ObLY7N3NGnkTXBTZQ1lx/45rr2Djz8hRemVZYhgLl93L4e2JMu8NnvGwQPs4XRO6qNj
         j3SA==
X-Gm-Message-State: AOJu0Yy1s2qQXHDXeNURQjBdLWtvaGUsq92RRoqC/fw8hOtsYw9S/bbA
	pCA80hPuQT23y9RmfdF6AV1nBzFwz56+4ozuxytkVbfKjwPRZi6sPYZn
X-Gm-Gg: AeBDievcK5aKQZFQo/NI98OJaHXE/i1lFeaMwip2HDB5Q4tyB4eFI/qgi7XuzGMtZGl
	AAb6zU2iveIypcYa88RRddFPwkMb+pnkZyGkWKI3qH+L5Zm6Wo/ZlI5pgY8EG0FLdA/a0fRC48D
	1zH6RLk5flqYPhpIAbMoyFGcopizJaIrw4Swv2Otk5SNSsdQDgOQn6IpPrc9vSjQzHXwzsOWrje
	qmaVQKzF0cTqIdS1wBFs/y5BR0B2mjh/k6GAEN1mgGS/r6e+7mi8wotxt1mT0wzfNRmHhSo+zAj
	vbNKLwSGhE8151uF+vra5mwR5btb2i6LR2RoVP1tDF1XypIfuicoG+OvXyUL4izghKAqimT34bw
	qDXT0SyebyvKe2tTflfOhfRdZ26MIpl5GUadJTnxv2JNJJdBHS2WbJk32ZY7P2i8tKVVcmgd2Ui
	KCTIzZaqj/js3NdxGMRmpHzDQaErfYvsdjS6Go0D8=
X-Received: by 2002:a05:600c:8b38:b0:488:b14f:b8ed with SMTP id 5b1f17b1804b1-488fb6e815amr205856885e9.0.1776694669910;
        Mon, 20 Apr 2026 07:17:49 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:355d:3be4:308b:c943])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-489207ebd3asm23410595e9.6.2026.04.20.07.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 07:17:49 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v9 4/6] selftests/liveupdate: add test case for LUO_SESSION_MAGIC
Date: Mon, 20 Apr 2026 15:15:12 +0100
Message-ID: <20260420141741.2688371-5-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420141741.2688371-1-luca.boccassi@gmail.com>
References: <20260420141741.2688371-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uogu7muakwf8qjebbakaui4r8dzd4q8g
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AE8A380005
X-HE-Tag: 1776694671-664887
X-HE-Meta: U2FsdGVkX1/KOKWmq8mb8u5XBwXH1sl8vY/Ar7/3H5lcDq2ofSP1rFFuLJo1rpcAjPGiqV58jpj9Jkxb75I7xui7gGRoFk5CUDqaUWdqJSsP82ZBf8q88Hwu6VIWy5ZZMrn5BBoQI4KAXTCEgqqCjL2xnQ8zq8wGxVKhb4vJlEgLer4REBt4xRHXahRvXsVodFWEQGwHXGwmtdiS3X0GShDVOuGByKd2ePiGCDsE75GpIyVU7VtWX5928IS7C9iMxwNiHt1oxlBJBiF219cNjvC2X1GE6AfaMz4x0zcBEWIqtUn/epQCiPjtQrFELk215o9FPKkj1sqC0SpuLewFA9Am8SGNtP4MHga7XIzOXHETF8WyrH8vUkQXQPyJK5YQh0zT8XgyENeUmMMiedNby85j93vapUyPT8MmSlEsOhy8eqnOMwwC+bND7wPbNRF+yxFX4jImG+lth1kPK/HmkjdFhA+NjMqUd28CHK55rMz7uiJT8TwNlcRzSdESMLEp5P2FqRyNKDiP1ukQr8RCaF0Bw+sVAJ+h+NL5BkFKVTe8GklmVYyBI6zXtS+hA4BhX+UnsR+txA7epqnou5aKbdeEJLPhdyu8nQuQmE0baJB4+ebitso+e72ZgBa/NkV7qisJJPDiUok9YgCbpsXVfHizOEQ5No17cvH4FQUVWK1UZBfj2hOSE+uSneEPGujUZEFlsmRqU/+yOaxTrlUQFKvd5K/5gfizjiB+wFwzv4rkfVR97lV4FmPAG3JnlmLAxm7pbPh6X+WTTorrLDnH2TOGHyYupI5DLDtpINChrRtufbJaEohMvrUR8j5dUA14gxPllfrgKv/mvgWkKOH2d1NqG8sWlwGUQcUKL0f7s0VA9AW4jeMqBQcEhk6gvyC/A6Znh+PDBRnRkvOFyvjMy6vg/hKeh0kq4oYR58bRryhjteAfl3ZEGVzYgVMwT/TF2eDlkQXR+R554InK1sH
 YVzFxhLb
 3m8bRHg1P/YTx38FLWHPI3C5FevrTQGvV3sCSEjbnherWAbn8siNeTxFxKTghcfswhwIHiN4Z/DqI8uxWDQZSDVwWQG6bDj9+yakRCBIWCY9UqeGRzjFYyitvLM2DvLCgSLPmZchz984WiG1pl+f/gvD7vSFrULENHhZTTs4IEgQVJd0kZJC3p+N0ARa8vb4dcMtzAxArz51kILnAPQ6ryVCPwVZPgeg+lsNsonvTazTVRp04SZRl0yIC80vu7adYZknmiRWS/BwYHLStieXb1E5igZ3bpTKAcvrTWf973kyLkk34TrPOOquVuSiFfrPhWHTXmavCdHKjrwBZ2uVBWyoBDpfnDv90kqgW61b8dGGWinInCwbBgzR8dWzypotF45+HHhmpRPkzIwd6znEUz4VdJm5rZexnX/vUYe73MzeHle/IKVYz/N+mJK0vNrh0wOitw32NFY45SPvuJjgKZvxz0kZXh+NYcHbd9zQeSC0rmw+0nihuL1ZYj8dqehW3IcsktgfkiwJgZ/6PGUGPvtIn5RDVZTZoz6xrdFEq04czLXnORUQTGMo7QGVUT7Lcdo6t32jnrJurpU1LX20SclkGOb56eno7gWMjRiEREQB8QKA9uG/8Sh+avm9sKeNzC1iSssfn/FuoCdVLPmKtVCAnMuxZp3o0iVq7ll6Vmcrqr8x66RfJ45bRdtQSt/ttc7mAwzjs2sLMaQgEnv9aKrFOYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

Verify that fstat works as expected after the switch from anon_inode
to the new magic number.

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../testing/selftests/liveupdate/liveupdate.c | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index f0a8e600c154..5e99af0cc6e9 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -22,9 +22,12 @@
 #include <fcntl.h>
 #include <string.h>
 #include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/vfs.h>
 #include <unistd.h>
 
 #include <linux/liveupdate.h>
+#include <linux/magic.h>
 
 #include "../kselftest.h"
 #include "../kselftest_harness.h"
@@ -387,4 +390,41 @@ TEST_F(liveupdate_device, create_session_empty_name)
 	EXPECT_EQ(session_fd, -EINVAL);
 }
 
+/*
+ * Test Case: Session fstat
+ *
+ * Verifies that fstatfs() on a session file descriptor reports the
+ * LUO_SESSION_MAGIC filesystem type, and that fstat() returns consistent
+ * inode numbers across different sessions (shared singleton inode).
+ */
+TEST_F(liveupdate_device, session_fstat)
+{
+	int session_fd1, session_fd2;
+	struct stat st1, st2;
+	struct statfs sfs;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd1 = create_session(self->fd1, "fstat-session-1");
+	ASSERT_GE(session_fd1, 0);
+
+	session_fd2 = create_session(self->fd1, "fstat-session-2");
+	ASSERT_GE(session_fd2, 0);
+
+	/* Verify the filesystem type is LUO_SESSION_MAGIC */
+	ASSERT_EQ(fstatfs(session_fd1, &sfs), 0);
+	EXPECT_EQ(sfs.f_type, LUO_SESSION_MAGIC);
+
+	/* Verify both sessions share the same inode number */
+	ASSERT_EQ(fstat(session_fd1, &st1), 0);
+	ASSERT_EQ(fstat(session_fd2, &st2), 0);
+	EXPECT_EQ(st1.st_ino, st2.st_ino);
+
+	ASSERT_EQ(close(session_fd1), 0);
+	ASSERT_EQ(close(session_fd2), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


