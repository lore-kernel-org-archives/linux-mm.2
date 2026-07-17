Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE289C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 21:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A2F86B00C6; Fri, 17 Jul 2026 17:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9725B6B00C8; Fri, 17 Jul 2026 17:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83BD36B00CA; Fri, 17 Jul 2026 17:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 555766B00C6
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:33:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B97A4120287
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:33:48 +0000 (UTC)
X-FDA: 84999570936.13.42BDAE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0A1374000F
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:33:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D/K7sVXh";
	spf=pass (imf17.hostedemail.com: domain of namhyung@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=namhyung@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784324027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5pFCIT4SNwJq0lXNXSiPb7aTP435Cfu/ZjktQHShKLM=;
	b=uBTSoi6J9zAOq5GsdT/FArArRDLMO0+Ou0gQwSRtNwOUMJE/BTLutPBjWctOTsRnW6r4lZ
	oCORFh7Kbh/4yw9TbPP8jVeilxmzx86PsK7IFIZ+XGcXB/0pUPlPA7M5tiKcOKqVX1FpO/
	FR2PPueBboWY9MdWff8aTHy4wEYJWHg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D/K7sVXh";
	spf=pass (imf17.hostedemail.com: domain of namhyung@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=namhyung@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784324027;
	b=D9yq3SjfHpAIlQBzI9UFoYIeUfNuMJ4aKMLejlEJ8SNXdq2rRN7VC6IwhhCnsqgLtukg2H
	fM1vKEfOsLfNuVkki7+odu4ffkfhSzdsGT3EJwUrAqdfiEfcgR7VFh5SPU2elkYFho0usL
	GEQhU6CAiNZE+kyqSPwUdXrJIzN2ltE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C224141209;
	Fri, 17 Jul 2026 21:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7583B1F000E9;
	Fri, 17 Jul 2026 21:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784324025;
	bh=5pFCIT4SNwJq0lXNXSiPb7aTP435Cfu/ZjktQHShKLM=;
	h=From:To:Cc:Subject:Date;
	b=D/K7sVXhBc59xquZXDMKGwBeKv6FrkYIodbLj1iUEz1NKtf69yRoDXTBzJ9Y+ZTcY
	 aGWB2EBUKNnxeniVhT30ykgHaZUCHJzESfHUyWYParABd5y9djnVkiygNO3DvcPnNz
	 8subYepgKLz9kBXV5FruejBVkQ9Pfai8GaQKoEssCsdX54/pIl3RAThV80qeyx2tQo
	 KvRffD0aquZzioQwk3uKSoCE/gqZkh4CH3SE/Zmvtx4/qPBgwpaOB4M/jmbMHJwZEg
	 FdGYzu2cisCROLbnk4pa0XNOYk4XszUQzQ7BE5wxAxCh4HST8nqz2zCEJE+qEcwxMl
	 R/Coy3XT4vdLg==
From: Namhyung Kim <namhyung@kernel.org>
To: Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linux-mm@kvack.org,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH] percpu: Add missing DECLARE_PER_CPU_DECRYPTED
Date: Fri, 17 Jul 2026 14:33:43 -0700
Message-ID: <20260717213343.200497-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bt5xzpe8779hroqg375ozcx96qqepqn8
X-Rspamd-Queue-Id: 0A1374000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784324026-531428
X-HE-Meta: U2FsdGVkX19hYr4PMTojNVQK2vWZ95MAXzSaJ2dFC+N246m2Z2KTrAjQCeDijTljwld+CCdbdVzcMip65QzNQrZ9Q81mYnHfxCXgVLIzCB4NAcUWIMup9cFxUJhJ8N/53ydSoA1v5y9WPIKiGotE2zCd6tJud4k7SMUvfy2j0JZAeCfpB4fvEhgtuWo+Vkiu7jXPiCXs/Rl9+CXKNMqaj67bR7Ej6jF18GyZPw7T7eForyqdAihoQz2RckJrNDrgvsoIRtQgObv8yMqksrLiyLcMNPi/VxGjlLZu8386OusJ1IJqKRCH56OAxabbythoZEUvHEGOxgV4Q9MhS0e1EDN67STX2beeoorMO7TwvzwTHAeay+ucBTeqR+mx2sri2WggxMNjOXDU8t50DQSJTkbKGgf/vyWFZ+t3b2uNf95vxsdJcmHSLgzBbmMJOFM8uwkSuLIrLxCSw3tso569cVNVMWmG0lAq4gdyrPPlG57tFXTThshKbXAF3fIrxXwA5zauuGxWkTU6avNAW08bNgHv0jhdvzldk/en6WC/3mOjUb9JnF12IdUbP3BcDuAF9mMAh8mbbbar/B4DWOBomgLH/9b46y+9H4V6u2Q+uvMvIfsY0KD6lGE77iH3koE1XiJvBTcRyEVfaYkt9KBh+iCFvwaPEEDLY0OYIGB6IXFzAi8Y1vMMqJd9gcIczj93Co+UTD140xjaAWaTWPzXp1v4qrakzmxMGAmRwz7jkl/f9b0VWGoj1QX+ASy8gZbZilrJPCTOQuFkbSHo6T3hxgFvfWzioMUjFX0Tupef7hH5xmF87DPbBvB+lAVia+tq63g47hAXiLSn6s2Na6l/30ODgNNIBI6703h1kPL94P8Sl/Z/GJRqjDz/L4T1PYxGxnPm6677v4aSgsOg4Y8k4b4eMXfzzvYwDEq7VSpkvj/P4sCwroqY3zCxL5JQT5Y6GXqbyYwghFu8DfOpdeQ
 /NiYRscQ
 q4uWHeK4bsGCX0FhQvp2pjFOb38dfOefz1P43N5dT0/7l+/Yyaabh4+bFP8fltxyCKlmv+dLnnbgblKNTKF+caTpzm9lXTt80bonlExOYw0kSDa4gGzKJiHJzo5UHXJZk5T0FDCD+tkQIBmoDy93MVBNVyPCPSsCqul7tcGa7HEjaSRg9LOXfIDvfqMFggy/kePiSdJe31fKt9BmjqTbPqVuEg7cDHPqeX8b1hbYkPYGohJbRkzg/xgfgqk/O6AYP5xWZZtEaziptfPo0JL/gdnXLDDiqJxuIOpo8HSgpC3mYbRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The commit ac26963a1175 ("percpu: Introduce DEFINE_PER_CPU_DECRYPTED")
introduced the DECLARE_ macro as well but it's not defined when
CONFIG_AMD_MEM_ENCRYPT=n.  Let's add it.

Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 include/linux/percpu-defs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 43c854a273c3aa4c..649f31e34e810eb9 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -184,6 +184,8 @@
 #define DEFINE_PER_CPU_DECRYPTED(type, name)				\
 	DEFINE_PER_CPU_SECTION(type, name, "..decrypted")
 #else
+#define DECLARE_PER_CPU_DECRYPTED(type, name)	DECLARE_PER_CPU(type, name)
+
 #define DEFINE_PER_CPU_DECRYPTED(type, name)	DEFINE_PER_CPU(type, name)
 #endif
 
-- 
2.55.0.229.g6434b31f56-goog


