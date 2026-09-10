Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8538C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2EF96B0092; Thu, 10 Sep 2026 07:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A069B6B0093; Thu, 10 Sep 2026 07:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CE9B6B0095; Thu, 10 Sep 2026 07:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7016B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:22:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8A101204A4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:22:51 +0000 (UTC)
X-FDA: 85197615342.26.5FDF626
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf19.hostedemail.com (Postfix) with ESMTP id 049A01A0008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:22:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jK7ChX8L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jK7ChX8L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789039370;
	b=AdBvl2rX6OT18JBBTC7nZjxYci/gV4URusUXrC4AaPvWKoaiZbtoFhrQalqRFdTiFJVMxp
	rDmb4vGpNtaZvjfJ/ehiEJQuE2oSofUk9DmbnLO6Jc43pPVhWA4aYFT6hitJp2Id5lNTI6
	TlD9q9Eo884RSVRRmTkMfAPuUQDvyNw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789039370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2ad0A/Rr65EAuzEvke4bbMmbpC8hQdLLHmef4KcXvFA=;
	b=wGH+8LdwNfF4Ees8O2c3O5uaENfy98v5kTxJeztsCc3MwADwFxlxrs/sWXUbDLLJwTeT6s
	3hFiRa8b7o3teGPBdIUz3UZyO1vOR/tqO8O8Wx8npbPcHG4z3ZoagxKmgCK+HCCLeyEJDl
	9jORmfPQiYHyY8ldbh03cYT4m1xFdZ4=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469b2e1d7so1537580b3a.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789039369; x=1789644169; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2ad0A/Rr65EAuzEvke4bbMmbpC8hQdLLHmef4KcXvFA=;
        b=jK7ChX8LmrODLL16grbUoaCPosZGJrFad1GAT/4UEitAvF2kLyL128MDVjfoYo2zVM
         4xgBpes6XQaoGG3pfwWByA516DE00CI+rF3uQwytVKrjR6nXGsjk9eyudpsB/zetrPhd
         pZFfcgrLyVnVemd0mXDbxwFIfNK/E6la1hmerWl/iYKaLF4cH2R43CDV4GVdSyp7mgvD
         MRT7TxakHW9S8f1r9Zx8RMLtkaQxCJEKopWn5j7K2KIjKxGEZgXtJkqj1YJiPs5o3cY/
         FEEtJ9qQTjeZj+uTvVoZ/f5dXdnr1JuD31iufiBUcEG7SuRKztsnHg5+N7zZDQ13KxGk
         IJKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789039369; x=1789644169;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2ad0A/Rr65EAuzEvke4bbMmbpC8hQdLLHmef4KcXvFA=;
        b=W/MLZ0UfqiwMhO2M/H4Iv0rhUI6NarmNUoSm9qNYABTdjTPST2wYBEMTwSlmDONvb1
         WQNo+e2+/vd5+wzv6eAfMq2cp9rXBj/KXXU8WdE0rs3lT51B6vunZeZo/ahIwzKX5Dy8
         k/JmtzWPAmiVt4Ac3OzCZrON1haKWIPFt6YO25+P9BwPsjvNzkS4feYBTBpUNCurT+jX
         YUTEzMKIkqttaiANKlvheagrheByNGpQcJNxKLd5Kq5OfLx24YaE7LOuL9QEUAuXgU6w
         MMX+QSY+YwSt+3+8WkOCQ8ozPK7q+Pjwqhd2HXLhJ2BYUsDjPXMy+ERCTmd1r2YeNyS4
         441w==
X-Forwarded-Encrypted: i=1; AKwUvBxSWOTvirSkGSm2whW2HUhshZIhh+8+fdmUn/iaaiZUTWWhyD9U3ByxHYv+o1wDoOynNLaTwBODIA==@kvack.org
X-Gm-Message-State: AFuF++nW7OSVFBxrjH168P4r8ATRjNsV9n2pYfcNmueQa9PdqxkcQESn
	rFCyd4HzJQenmIQE66LHq9ZneQgXPOUZNryzpi1Z5VZFPDPleDV76ln+
X-Gm-Gg: AYBFou0jI/1dWUgMJYcWZfzI2cuWvHCSnTtGAJdXSJmesEFSU3pwG7qKRzh1KernFDL
	lB6PDkyZlMXvBAPntZFqpxu1jiKJZ76qGb0p5WuBaRpiBVJSA3dNKbDxVZGzwYmxyObSClnLe4e
	+/FpElh8I5lsvlVrhD2h0yyLY9Uyl/6hZCPbDB2prU7ggOAwOzeMnM2tK1WZTLWKFYf9yRGG2lb
	d9e4Ktd2bM1Bg5oz9v9AY5UJfxXp1YJf7t/EiWukRZniSPVhA90dC7xxBw0cXppeb/wtjhQz5vD
	Dqorfe97mxX4ruTvKnizKkJngoF02Y0VMDUfiNNjfwRx1ZTvf5Agmqos6xMnWs5V995feuSQeux
	ICrzF0qKm3p3YaywALNxKgUyS9R710u6aArajQTqGZTL5T0C0jyrXTWb1FA3csIus2NYHhlL1Z+
	PSpy1NoWQSvDVUKMXJ8UlskrY3zlCiUGld4dQnrkKtd9+JUg7yYjHL8nP5qPIkyEdvdH7lSFWCt
	gMS
X-Received: by 2002:a05:6a00:300f:b0:86a:8e9b:46c8 with SMTP id d2e1a72fcca58-86a8e9b6359mr2124764b3a.0.1789039368714;
        Thu, 10 Sep 2026 04:22:48 -0700 (PDT)
Received: from celestia ([2402:1980:885b:4183:b098:c1b9:7033:be8a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152045e8dsm7926904b3a.20.2026.09.10.04.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 04:22:47 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: 
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Docs/mm/damon/design: clarify when qt_exceeds increases
Date: Thu, 10 Sep 2026 19:22:31 +0800
Message-ID: <20260910112255.157012-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 049A01A0008
X-Stat-Signature: 1yeemgubsswpp71my5ojdczanpk3z9j8
X-Rspamd-Server: rspam01
X-HE-Tag: 1789039369-770024
X-HE-Meta: U2FsdGVkX1/a8023WN8llXI9G4QxSwC6dM2pHijGFQrcoJ9Gbefa0V4IYTkp7RG2r2fiersNy77n/rdEpNqKqDWdBBQPHHx2mDjbmxE0ifQMOrR1+1t4hxWNsmVbtbY5ettjE262EvpI1/u9t12XGlWEBxSW9oQHdwAPw+MFKyJV1G8/iCV719KjmxI27wQLG3NHwVk2OMxnLVMw9uQg4rXXPWOaJfJQs6b/tFfNCor8NGUnakJ0Dc6c+w58TtpGQtgYsG+hlGY5i51wNPVzY9MIvEOudQNIdS0i4WBgVihOyHCuMXPLjZx8sCvqAZA5pkTBVZc57KJ+9YNYmzd4hok7DbE8YcR1R/IIzDWPwpMQPJOCkrmD40uZB3ZgZScvLiFtsp4SkLqAqv7EdbwP3d7ddciWXVohf72EODcV7KWZqgBa30dm2Haddr8BuMUlpvIxj8VZXd5H2PZTGUOr7/Akb81wTKBF1RglXOzBZm7/4CL4k3R7sSgUecAjPtGvdHaVabe8p1DjIKGXeT/xWhzwnnjYaPIaI5nL/2kaOQChC8Dw0blssLTaKZDf6c0fZqrKdzmknVgH67RcIWxheBesgA9YLdNG//0FEmMI8kgeosJtXIPbw9/0CMbHbwyiIiftM72wgMugJsQmPqZSmuFDJZ+u9v+ODkqcbw+qm6MKRHPRmIritf823kiKmpL2HdDaxU4voNosdwNMQ9VbYKbpt96OYxIEBf+PdymtsuT0Gyj+mHhTenfRWdzPy/DVZb8qrq8fXhPFemeSLCn/O88oJI5sthS/KgpirpDR/cjnhJcUNCK9T0JEYwo2SwPwvcSVhwhs/vs5fnN2W2SXx9OVtZZNyfyGCxaavMwMYJnLDs3+UJ+SDRSQeKtqAs3CP2DODdKyQdO8FwsHKIwJiGRdyrjzajeEIUq0SUnv48nrBQvy5sNTK4FdHT7FgP64NqLDROz7FhUhhaEVVf4
 e/okBX0b
 HFr37jrS7fDwOBlsMvpuBmqR7BpzEalCemRF94xxwoaFDYJyxPMUb4cYf5j67/q9ktbk2GKj2/RqIXki3IAflJjA1wUJEsn3Qg7MNsV0PJR9uWhYMUNtpa746nxvm7ncVhghNVniobPQPe86LRtibUfxOKfz1KEMAFzEfdNKPH5CFDunqPHsW1zdAhHIGTh7yFeDtyM14WazZ44ba/YKbwf5twR9KFvL4Fthoonzh1LHzpFqFfSe7qYBOPwN+OoM/hYJJllXnsfbtL7BLdOe946EeXuJvCE6f2JicZUfX8/UECvy3IntxN4HUYxJtoFFrMgZd8iuSn/JKOFHA4n0Qd5Iiiu8xfTWdIOmQv3A+9FClYfnoQg9I6Oi6nBPvE9vjlBwgDHcsqA1Z1IJqV/CTu8luVqxtqdQpc09rhIZqjqYXnvpfuerGFqqa6dQJzk1KGD08MaXkzzYtlOiCzQSw/cLPQ9eJ8xMOVXdPrRKl+LRVzldXTZZ7csh2y8AMUxZKAyl+7jkO3EVfm9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

qt_exceeds counts how many times a scheme's quota has been exceeded.

When using the temporal auto-tuning algorithm, the effective size quota
becomes zero once the goal is [over-]achieved.  In this case, the quotas
are still set, so qt_exceeds keeps increasing once per quota reset
interval while the goal stays achieved.

Clarify this behavior in the design document.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---

Changes from RFC v1:
- RFC v1: https://lore.kernel.org/damon/20260908175105.42558-2-aethernet65535@gmail.com
- Simplify the explanation.  Do not provide a complete definition of
  qt_exceeds, but rather explain only the increment condition when using
  temporal auto-tuning algorithm, simply to prevent users from becoming
  confused and being unable to find any explanation.

---
 Documentation/mm/damon/design.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index d036340dae8a..3f38a3cf68e4 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -695,7 +695,9 @@ There are two such tuning algorithms that users can select as they need.
   fast as possible, using maximum allowed quota, but only for a temporal short
   time.  When the quota is under-achieved, this algorithm keeps tuning quota to
   a maximum allowed one.  Once the quota is [over]-achieved, this sets the
-  quota zero.  Useful for deterministic control required environments.
+  quota zero.  Useful for deterministic control required environments.  Note
+  that the zero quota is a valid quota, and therefore ``qt_exceeds`` :ref:`stat
+  <damon_design_damos_stat>` will keep increasing in this case.
 
 The goal can be specified with five parameters, namely ``target_metric``,
 ``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
-- 
2.55.0


