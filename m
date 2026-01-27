Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6406AD25940
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 05:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2D3B6B0089; Tue, 27 Jan 2026 00:53:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0F266B008A; Tue, 27 Jan 2026 00:53:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04C96B008C; Tue, 27 Jan 2026 00:53:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB096B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:53:33 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C012BCF1A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:53:33 +0000 (UTC)
X-FDA: 84376676706.17.F925A72
Received: from cvsmtppost29.nm.naver.com (cvsmtppost29.nm.naver.com [114.111.35.39])
	by imf20.hostedemail.com (Postfix) with ESMTP id E403A1C0008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:53:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=naver.com header.s=s20171208 header.b=FnnSF3Ct;
	spf=pass (imf20.hostedemail.com: domain of s9430939@naver.com designates 114.111.35.39 as permitted sender) smtp.mailfrom=s9430939@naver.com;
	dmarc=pass (policy=none) header.from=naver.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769493211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eEJayvnBqnf1pCYsriZJ8N5TFNJVSOE0+d4vtwpqJ+I=;
	b=xGk+zVbSTmjgdcSlVti8gotiNnh8dvAURQyh0FcV2soDwZM4fEqtpd0V+vUbCMAlcaSo7b
	xAp+ib0bJq9x9ot21FAzyYQbxxZ7z6GbXFHqVCdI1dSftZH9JZncnUWoLX53gmBPgFRJ0k
	TYFIw4DETGoEH8A6y/iKpNF3o7wWaoA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=naver.com header.s=s20171208 header.b=FnnSF3Ct;
	spf=pass (imf20.hostedemail.com: domain of s9430939@naver.com designates 114.111.35.39 as permitted sender) smtp.mailfrom=s9430939@naver.com;
	dmarc=pass (policy=none) header.from=naver.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769493211; a=rsa-sha256;
	cv=none;
	b=vN15eV18hJxNANiLKT2rKMtzta58+05W34+2g9mFfY7EPOooLqqS7+Cr/8DfI1AHwC4yKy
	6INfDeQvzqKuBVoeXnL288PjS/SKAUI2Vravbv/2cRi/eBjv/cx09bERuFttmmqVOcUzyH
	cUUzxTgT84gMHzR9RCCRYfvGRvx0agA=
X-Originating-IP: 14.38.141.199
Received: from mvsendbo01.nm ([10.179.34.201])
  by cvsmtppost29.nm.naver.com with ESMTP id swHPuUE4SqKpEwHdiK6iFQ
  for <linux-mm@kvack.org>;
  Tue, 27 Jan 2026 05:53:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1769493207; bh=AUEJuWVp64JJlkuZGTU/lbb35aMFdxP3nt+OQ5aetwU=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=FnnSF3Cts69Z0IShpXCel1UyZAlXing0K8J4+nvACe2eUg3jjh1YSRkuxC6pCttnM
	 GfOXR+t7y+IlnHk46VZXw4j4twZ73TWdRi8+YPm1tZ5j5rronK7ohbxpiVzhIblFv6
	 wNyJUryPW4ti6sJKhT+Ee3nLj3wYVz0OasFrQTJq0mXkGwRGYBHQcL2RNDGu9q6/nl
	 Aci+XOi3D7DuPkWO3L6evNQFwF48b8kAvG3Jq8ign0rLfXOeiU0SkniiQt/gtjkWlO
	 UVk4okPetwgZZfxd6iuLaKTulSE9oQ+0hYxTAF/jW3uXapcl2zEhU5xYjaIsmzbqOj
	 qXvhVvuf44nBQ==
X-Session-ID: 3ptl+01VTsepfVkW+3ZiTQ
X-Originating-IP: 14.38.141.199
X-Works-Send-Opt: xdYZjAJYjHmZaAKqKBmmKxbwKqpYkEljxBmwjAg=
X-Works-Smtp-Source: IZbrFAvrFqJZ+Hm9KA2m+6E=
Received: from JMW-Ubuntu.. ([14.38.141.199])
  by cvnsmtp008.nm.naver.com with ESMTP id 3ptl+01VTsepfVkW+3ZiTQ
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Tue, 27 Jan 2026 05:53:25 -0000
From: Minu Jin <s9430939@naver.com>
To: mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	kees@kernel.org
Cc: dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minu Jin <s9430939@naver.com>
Subject: [PATCH] fork: clarify copy_mm() comment for kernel thread
Date: Tue, 27 Jan 2026 14:53:21 +0900
Message-ID: <20260127055321.2400480-1-s9430939@naver.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1ytowfn6tn37x7mahczws7c56zef1tj4
X-Rspamd-Queue-Id: E403A1C0008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769493210-420897
X-HE-Meta: U2FsdGVkX1840ITIo5aFYt3EIUtk9w7amUNQ/oMD4e23GaHEAUj8+PQzT0IwyKpmeitO4lDd1JywY+I5eFOhgZA62nS0qlXiGLa7l7VfnKHLo7W1Hhii01D1j0NMcRdgXpIZnsagq8rjIjRewwXzkuw/tNwYE5ahuCXOi9FWbWviD95pQObbnCUmHrNowmLh4cvMhG+37ErhrnNW+1KqEbuK3qoOW1dv8F7Eebz76nXl2jLJadlJ3ZEotrBZcsRQ9/l96ESRyloehfvAvP3QRB8kKcKdEdbeskRBTLKUd02qy0Zvi3XZoHwJhMpfK9Ws24OUNDdbP6mC61Ox20gDu3xA0e7kH64f6OhMfsjw2ZSx3/9v7kcZ45axvsRrV2BOVGmzfrvYtUlcjfR1MO+VsUnczBk2chzBKXWhqwfsjuLNnEhFzeVHyLkYXIgNRxvhy6Sugp6EXEWKgnPKKlLlaRz8KEprJxYNSbxXhOZLjB/e2xPcskGk/IL5drQoNAS3OMwcNLZBU5TGzFT4OVymBEgUHmma7pefVA006gy80HQW5bjt9NKP1VDcKu5/d8JqqH1DPJsk0QdkMP0WMTYRkf7YzJWYKK8ZuyTFE96gQ74w8xzYA7EIn0HkOzeQTsho+TWwjloNdLtLPc+tyWXEMVjzexkeAfPeusBtJ44079+AEDvi0fHg36Y5/TFdGf8vp8EuJJolvSFkclkOJQ5laK4PoqX7utv28+4PtiW8Xh/eKiwQDs6YiwOiLDUrjA3a3yVr3kY3aXg/OaEyEFuMD+/V+3bjz5iHQB3M9/a16FqXkw1DCaAUvhQAjc4kA8DlAn1ykfy0Or4JOpZ/eZKLHywrkifjwatPPFhuu4DHPC3d/wcTgeZCPridaEhhS9kXP+g3WUGGhHAz3HsbVjZbvRyHAQBSX0/NkxSXbJAfkvAkDiLi2oAOXI4knmTLKWxXSNXFLcq373/MNwBl/xY
 tLfgLcnR
 Fe9zKks1/WAA7561iE5Roi13l4TOV/Gy+Yd3iNMxKSuWRzdJVUX34BuJfsN8aAKXP6uskyYZbi/u5svvZMj8gq2423ELVwXY2VuTXS3wBc+TdAcIT5w61F8J89ldeOaSqpD5QIbwPvAeZJ5nNBW+RctbILMl2WCWBGf2tskuLvdJQhH8CVVRzsjY/fZqgtHUw6h3NbpUe0Ae+YE0PLpeSa8kEADH9gt3FyG6dbDyX9vWr4a4SADxF1ms4tEqE6lYsStp7Kgw4Q2yS6rQ8b6xd2E5UTnyZkeqYHUI/JLs5DxcwNJZlDPmjGSF/ScfpcbMJ7AguORM3I35gnZoqCeVkVP01IyNMqaV8AmcWNlz/law95xlBp0zpgeeL98pJUghcJsr19d31KFEfkYmfrB+i338QKr+w+qcg/o8llm4I93M8PyjptMRoCdf8gudhH5ocQ1wPXA+NBUgM/85gFGjuY263ng1rfGpFA6NS3NoupdYg6r/mCTP6Ig8tc72sI5pQRuJdQQKc8umqLEc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.344741, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing comment is misleading:

    1. "steal a active VM" suggests this code performs the active_mm
       borrowing, but the actual borrowing happens in context_switch()
       where 'next->active_mm = prev->active_mm' is assigned.
       This code simply returns 0 to skip mm copying for kernel threads.

    2. "active VM" is outdated terminology, the kernel uses "active_mm".

Update the comment to accurately describe what this code does.

Signed-off-by: Minu Jin <s9430939@naver.com>
---
 kernel/fork.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index b1f3915d5f8e..4bfd606004db 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1566,9 +1566,10 @@ static int copy_mm(u64 clone_flags, struct task_struct *tsk)
 	tsk->active_mm = NULL;
 
 	/*
-	 * Are we cloning a kernel thread?
+	 * Kernel threads have no 'mm' of their own as they borrow the
+	 * 'active_mm' from the previous process at context_switch().
 	 *
-	 * We need to steal a active VM for that..
+	 * Return 0 directly to skip the copy_mm process.
 	 */
 	oldmm = current->mm;
 	if (!oldmm)
-- 
2.43.0


