Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C345C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 07:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2112B6B008C; Thu, 27 Aug 2026 03:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C22C6B0092; Thu, 27 Aug 2026 03:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D88A6B0095; Thu, 27 Aug 2026 03:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEF636B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:19:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6852840218
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:19:12 +0000 (UTC)
X-FDA: 85146198144.21.D238885
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	by imf19.hostedemail.com (Postfix) with ESMTP id 58B291A0003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:19:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YVkW448i;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787815150;
	b=Is1o7ddowVG6zHCs836vdxPkfd2OcNYxq/1Zcee7ynSr4hrB96vEgkQp2VuQaruX76FeuQ
	WpIDPO81GXmjr4uT67am6L9NOtysLOdPKA5v4MwuXYUNh77lepwsHdNZk+THgb1eN9mEie
	/SOJ+TSJoSco6rAeTmXmnAq+wH0QrZA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YVkW448i;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787815150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qBd+aIWFcEy3Cq/BUllFLKps/0sU5CK8ukuGA1syZC0=;
	b=OVFdqFmIxDKcUWg8qWvh7NQFXPJasFDofk1zKsg7YvkbAWF5YckEkwx+ys5eLsesE4CARO
	GbkmnyZ92nEHZNw/a2sf2+8UTNv1FJnB73f/m6HXo3S4JXZ3EA7W6EyAEnP2DypNySVfMF
	HBrwG0bMT3okIet1jI83HdY3l00gn0Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HN+3sbUNbycWz2IO1Ch0ptieDL2g4IBu4VoKtwdN7hM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787815149; v=1; x=1788419949;
 b=YVkW448idKOe+POBziPtzwnC4ioTs+k1elyy3bZse34SLLX9GHZddetXbGMs5gHIICC/q46/
 hWsNvEnZOtCO2F/TV/rQU7cnwVFyRWzjDEpMQjDvyV+K1cbbVTlXvZWV3E5jtLHwHYR0u0pRomM
 UhPA3LC9neOutfr0CkAj/csI=
X-Envelope-To: linux-mm@kvack.org
Received: from fedora (117.129.78.49)
	by smtp.migadu.com with ESMTPS id 2886061bcc752116;
	Thu, 27 Aug 2026 07:19:08 +0000
X-Mizu-Trace-ID: 2886061bcc752116
X-Migadu-Flow: FLOW_OUT
From: Hao Li <hao.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH] mm: remove unused anon_vma_trylock_write()
Date: Thu, 27 Aug 2026 15:18:06 +0800
Message-ID: <20260827071845.17636-1-hao.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 58B291A0003
X-Stat-Signature: cy1rxy1kx9kokahmy56rf4xii8m79fjn
X-HE-Tag: 1787815150-238660
X-HE-Meta: U2FsdGVkX19/I0YKt2qXRGRyygusuY8hdEy184ES5Ex0laEA+kvk0WYgrcXHYN1QhEqMefogaghv5vL+976OJj21EtR1O11Uxfhe9x37XOMkAOqJPmSrlyVDB+GbDMbWxObsv1dNR4Rl7wqV6YPukXekkkYY8E5Oj/0MXxMNyi58WUlDm1IAqeqbcPPJW9lYYRJTX0yPfMegv+/nb8FLk133TWLWdXnbxuVZqgVIVVqEh4KQdiulnOQ4PYvdWmeWc3TUdmTxgMAJCx9VvYuqb1F9QWgoF6ZHx8AfXCMcWK3eqm1OYfIHbMch96XbrenX2JwBl6l5TjOURXz+/WYz1OyUxuktfXpN4/X4PmfY1YlO9jryYDGIMfAY42apUnzz9EkpV6cDTXwlw5U0KfqezczqAPNbr06twG7gsVACITWtUivfdjIppk3BOHnwz12VvAyhzg515CZFhkpgm/ttaAz+jIHv8Em0WpYXzEb/IfajTAYENtZlrReplGy4nnUEPGQaYKrosJW/FOyHAChqLkvTLKNDtBKa1ZDmXkgtFybHX0F/fAp0oNjHBUPYioWFyUoP6B3WkHW5gUNyrs5nEC+BIP9d82dIdgPNtPPAr8d79YBKekFucKXk0hHjMQHP2YZurJyNRIkRB4SEstBv1aWirdAZdxreNs8inX5CDqy3UQ63XTuqV5+fPQ0eEmlOeCc2N4Pvz6BzNGA1MrIRsVLuosHXCqfyaZF4rdubdHLBgro1sxpkHZmimxYgn0CoTELpSslsVqsX1Mtq6spkDf8ku/K7rL4ZpPrK23KWNxKvnEmP4PA133UhohYgV7VY2BXpXIpb/pnIx7gOleKE4jN340Y0ZtdlZGlHGC6u7MuoTd+HgJDxBLN/ZqlNEVDgDF+ctDuF4p/HleNQh6lac77lF0mKMU91VZ8ii050vfRfbihTEXMGT5WN4l6QYUULNqoaorIfn1oJwSTKZXC
 zp/7yYsI
 VSpmcmBUOStkDQSwA1OfnGx1SBHejl6fNvjZmzVm32MmPb5ZfOrYjkQtw+XGrYv0f3moucZku8U9GfiOMdVctATd4AmNYA/GyGuh6x4hxxKR3hNuhTXo6Chf/hX6Tg2IMHr5pEQMR6MNzvfCI7aYIPmSikAx8xoYAP6qvZK6U/VWt9AbqtHbc7MfWHdcp80MUNG4Uoaq5vFd9zyQucoE8lU4d/NH/vNDnbpbfRybZiid8r+HlZ1aPudMdIvymJSBWMQnQDR8CKsSApk8SLEmYA4YSZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last user of anon_vma_trylock_write() was removed by cc22b9978509,
leaving the helper unused. Remove it.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
 mm/internal.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 68db5abd0a4c..9069013d191f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -298,11 +298,6 @@ static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
 	down_write(&anon_vma->root->rwsem);
 }
 
-static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
-{
-	return down_write_trylock(&anon_vma->root->rwsem);
-}
-
 static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
 {
 	up_write(&anon_vma->root->rwsem);
-- 
2.54.0


