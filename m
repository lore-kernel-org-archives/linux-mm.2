Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA3C606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=T2rEkFr9
Received: by kanga.kvack.org (Postfix)
	id E7EE06B05B2; Mon, 26 Oct 2026 08:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56E06B05B4; Mon, 26 Oct 2026 08:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93926B05BB; Mon, 26 Oct 2026 08:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B90946B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:23:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5AE0B1406F2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:23:23 +0000 (UTC)
X-FDA: 85364692686.06.4A630DD
Received: from mta0.migadu.com (out-30.mta0.migadu.com [91.218.175.30])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1DA06160003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:23:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T2rEkFr9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.30 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793017401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uNvE5oc4Xse3xSyFyz6zBJNRG+aATYG2iHGRqEHDTRc=;
	b=3SSGYdiXAptU1njQ55VNh4wxQcGP47Q4kBv4b4dJZtX8ZAWdC5y4JHXQexsZcfWcUVfi5y
	CkdsY+vz5Vdknpg4S1Bd6LcHyN19hySJp5bNlPAygUFkwYDhHiZFQtNkQrXs2pwzUDy5mz
	GquJn1W5ec/D0/xGDipoucYgRClCeOs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T2rEkFr9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.30 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793017401;
	b=PBK4bfikXjSa9EeSAUO3Qm+mWFXEt+aZdJs+pjX5ZnGaSvqdIhQxXWYNqVX1MxGH81TQzs
	8sC2fkNRYECEaUSZvJ/nfDkFXpt7BQehCF76979wapm6rPBI38xBMzFILLssMqASxdeBpM
	DwVGEDVskn4Xce5k7yeAYgUmhsXPyKQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oek5CFzsQMOFXzsaKjRlVhUbIAcYmVvBZKP6KqcldqQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793017399; v=1; x=1793622199;
 b=T2rEkFr9di4ZamBHyg807diMfjLXnB4MFXndxFxzWcJhklTJWqFJu94xV3P8I3lf+akPHI6w
 qeU895DsxnhT46GgyzpNOKI41zp4jEGc2+qaodM73EehiUB5ROtoqzjp1S2l6kpNfg4wBcDqL0D
 jZ0P8rjDIsMWDmZvF8/zEOgg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3b1020da94ae3f13;
	Mon, 26 Oct 2026 12:23:19 +0000
X-Mizu-Trace-ID: 3b1020da94ae3f13
X-Migadu-Flow: FLOW_OUT
From: Jackie Liu <liu.yun@linux.dev>
To: glider@google.com
Cc: dvyukov@google.com,
	elver@google.com,
	pjw@kernel.org,
	alex@ghiti.fr,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	muchun.song@linux.dev,
	liu.yun@linux.dev
Subject: [PATCH 0/3] kfence: fix pool allocation failure handling
Date: Mon, 26 Oct 2026 20:23:01 +0800
Message-ID: <cover.1793017073.git.liuyun01@kylinos.cn>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1DA06160003
X-Stat-Signature: f4r7wf4cahf5z4rfrn4bkdequk8cz7b9
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793017400-264713
X-HE-Meta: U2FsdGVkX1+ejKrBDKHA3a0DjbPiKLhlU1cUbRQKgwC6KBpr4XGREYxFqYUfoReReoPHHr5GWK7dmTJd7JZU49r1WcBfbqPpciZAzdGyQ1UsHDoPB2iNGiv3Do/CwBq4222n+0lOIBCnVnwwn2vUVX3IqenYp9qddBaU2bF4zKQolYESGba7jGssWHYRLfGUAujiL0fKmNf39DsRYKAU9ASkedfjxhFoz7BWS3XeXu7tQI7rTb1NVQ+DL0xMZIU8PSNmyLLfzsr5us1uiMCVgFl1q7WDA+K22pT0Dm9wMqAeC6VfAlgt1Uv90rszV3ZCYyZijervC7+lqVfDSUldYKUOCIQzIzTkZYME9o4eSGLxKUiQ+CSd6VK/61GnAlhVdj+hwjTB6C9EscovooXCQYqp+ecPRX+vOj2rNuqZkyoLm+1HpGf/+5XFcN0i5UTUn9lpOsqVlTwMEIntamnHFL7CEhS6WLXVhuj3gmnA8Z4Skac6T4BdyuJTJLqtOCYqknZZAMzphXCeb5dX/Ylc0FDIDY+gjCGLNsTtxElpyfxoUrtYN76aAnQsnORKvHBWzf4qSYTBH0m69AuBn+XEaWxms4lFDyJtSJaqQ898GKfAmW4WDj7SibdGT6wmOfet/JXXQktmT5BzUliwlvW8BWpWpXMxHeG7kMR3tUGy0sQ4dSa33XVJisi4tGh42Wim39FUd3Zm8EWlFtTxJrpvF09GfANw+LozEj8vuCb85pPmcswQ47yNvg6yb3ReAZbqc5NlHjdyL/dTZrukO3SFDsbVUztxQkN37VIvKpuMVCKrVJjz7gecp0eZmLmX0Pb/O0vulTuFCRvQ+P5bUSAcBnQO51RdS9rZBOKMtUG5hvD+oB5TZZLdaLJtUFp7KdDn1T3bevODGEoEp9xmWj2Yl3h4Y6/ixHl9xU3Vs7pYJUdVlAYk52ZjtB2X4NGdQVTwJL4Rb+tR6t+m2KNItyp
 Siszapqc
 fi2DxIImHvP+ENyj7eiJrCVuNtNQXq3AAcYxFk1QUTrnAUlOT+x40HQ57FhWS0qzMo34v7hVaD4AalZQuO8QuKyC/DixKEHdo4J8Mq/lsM60kS1iFJfdaaAa3UP3ilRhWMTQ1872u14IvfJID3nfLSA0MAMKWHi3uglpM1quuwFesJfMBJBAE8dhRjx7NqRDNC7v7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jackie Liu <liuyun01@kylinos.cn>

Fix the cleanup address and page reuse window in failed late KFENCE
initialization. Also let RISC-V boot if the early pool reservation fails.

Patch 2 depends on patch 1. Patch 3 can be applied independently.

Validation: source review, git diff --check, and checkpatch.pl --strict.
OpenAI Codex assisted with review, adaptation, and commit wording.

Jackie Liu (3):
  kfence: fix pool cleanup on metadata allocation failure
  kfence: clear the pool pointer before freeing pages
  riscv: keep booting if KFENCE pool reservation fails

 arch/riscv/include/asm/kfence.h |  4 +++-
 arch/riscv/mm/init.c            | 19 +++++++++++++++----
 mm/kfence/core.c                |  6 ++++--
 3 files changed, 22 insertions(+), 7 deletions(-)


base-commit: 7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614
-- 
2.56.0


