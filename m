Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F06BDC5AD5A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8636F6B0193; Wed, 12 Aug 2026 23:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815DA6B0194; Wed, 12 Aug 2026 23:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D6E6B0195; Wed, 12 Aug 2026 23:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44CE66B0193
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:07:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A59EE8023B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:07:08 +0000 (UTC)
X-FDA: 85094759736.08.00DF6EF
Received: from mta0.migadu.com (out-129.mta0.migadu.com [91.218.175.129])
	by imf05.hostedemail.com (Postfix) with ESMTP id 930FD100003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:07:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hNdQ83oH;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.129 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786590427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0/WFmAnmHcIpa8jJwJMv0V5dDB22ZDP/N9IEjE8VPcI=;
	b=IILkU7y/NysoIk8uzYa0Eyg1NdkN40VD4RzvjJoTujIEvH598VmHwqYpeW9AEGY6r6Ux3d
	LdHoPWEgP6mdCAmhNA2y96yXTVvkECEAhrb2TtsLIe3eLrmpSGyVuylSAe/s+lOQ9+wLBL
	1TG4SLWnBpaeMvUap6kAYkCTbFamKDM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hNdQ83oH;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.129 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786590427;
	b=LlZGl8detIpDUAb6AVkF4B8DFEjACLjLu/V2Rug2D7c1YSe/wH1QiPukCILbwpYzISmatB
	FD4TCjor6rcpPdw+mtIaiz9eRWNlIonb98PG1vUSNok/2f4SyWFvrR90t5VCicFCM0aGMK
	1cEHEZstrT/Ts3ne/7sIQ76Bph8g8bk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ttci0L82/KRm+ruQkSVERz6ZOoHOrD4BV9vjZHSrlTA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786590425; v=1; x=1787195225;
 b=hNdQ83oHHmH8q4zWZwRPiQaUcVuScST+MycjAYbOI3JP7Isa1+FARRR3MXw6cqh1cr7G8Njd
 AaM8Qdgh1dI97NORutxmLICcAOLJpeBnXdYtOT/QYLhCC2wDyZvFutUy82fTYEICbeKCQGbJmP/
 vj5bFnCkpwBvy98b3mmYoHRE=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 421e72884223c082;
	Thu, 13 Aug 2026 03:07:05 +0000
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/oom_kill: fix stale comment in constrained_alloc()
Date: Thu, 13 Aug 2026 11:06:54 +0800
Message-Id: <20260813030654.320269-1-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: piduqzxtfgd8wkugroi77urxk9s9genp
X-Rspamd-Queue-Id: 930FD100003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786590426-690670
X-HE-Meta: U2FsdGVkX1+9e0xvZTNNRgVgPlOXTuP5L+7EjsKWCkSIbYCI56xwjwOYX1I3/U8sYSAOnMD+tqJ+5drHhZMtAxVDCxCypMAyrxz0Wl+C6LHIm97Jo9MjBjLTXAPUaZ1YChe9+t1bu94g1zfK/52fDOA65pp+NJZVkvFwpcg01GvCzAsc46Zr4KzKxl0dbAV8z5vTmGM8uSKCNtFm8v8sU66Qzk+K2xW8NFb7RR01FUmGRUwcqzNxhQT8IZKfegV2UPGW6bCIKryI+cttExt/l+KXvzX28H9adEwXvuian0NIkzuA5BKjVA0Po+QbUmTpqCAAyeH90OfJ3H+KVte0JU5rgrc2nhi0JWaHuMrltHpAc1JHqjlAPFu8dRB9eU73YKuGod53TvPJgTKZXZJBVH3TwHt/wRH6waAdtt8S6L2PsWFbsFvmEfpkaVMsZ2rLwvHqkz6i7qcw/zdjHnlVeJObbNv+7IGzwVc8bdQtCDCdQ2XnDTRoomDZ2gWyRUjPjNGCe2pdn8sLUH+B52QoTq7IGf2JgCl8QTsGAb2xodA+j88vAm+ao/Y3S8VXCs+Dr+Y3RjdXMW1SOc4RCWwR8iofrXnW7ULOpJeZVbshGHj6/83QqA67tpXayHvGUkw3abCvq3DuBN+OoJaPRxNcaKHcZrwtlsQnmqNCZLihzWRXn75Y4bWqoXG5KN+sBSZGr66iv7mNqDk9zfPdUHD8t8yn8yGcySB6kACvQ405zJfHM/44YXJNG9GWfdrScRIltJJjrWiA7ZrRymJlC8ltd3R4aX16eGxelzc+9Z7wm8tu0MKiE9YDYChL532bz26SE3KT3lXQSCNLIH3ftzOdd1zBvEiOgVxzjc7XgwsWMhfYX1vXyiC5zLEPucvY8gPStEooJf6s9AfU5LGc4PJTnlywA3IwlRdc8xzNEhn+D2k4GzGrB37D6JS846I3Td4c2Y5XOfCO5RxW2sJHG2s
 OunBMPdf
 H6pENqbtMxsxYoUEqaP5lYN7tamYsoRrDwKTC2dQ5xptwQBr58DFpO4/Vl5pxCdU8KISQCsWwUKsWY7E/iwKffI9LErTsyPM5A6MrfYEheeQnxYmuLpophDYIjwJ0neaNErHbNqgH4lzOuqa1Wdgw7fZLfIBrgJt+nbmZKZ3QYQoCtV2Wn8XfFVvzb1nw/EJqoQFvPG4PXc54H7laems83TveBPIZ5BRTNFc1vDe0C865bf1k2gXPptzyqZCUoRf/OcRfBq8R9OBpFo59eMVrKJDasw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The comment above the __GFP_THISNODE check in constrained_alloc()
is stale and inaccurate: it references __GFP_NOFAIL (which is not
checked here), claims the OOM killer does "random task kill" (it
uses badness scores), and mentions CONSTRAINT_THISNODE (which was
never added to the enum).  Replace it with a description that
matches the actual code behavior.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/oom_kill.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5f372f6e26fa..4b5c70aaece4 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -268,9 +268,9 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 	if (!oc->zonelist)
 		return CONSTRAINT_NONE;
 	/*
-	 * Reach here only when __GFP_NOFAIL is used. So, we should avoid
-	 * to kill current.We have to random task kill in this case.
-	 * Hopefully, CONSTRAINT_THISNODE...but no way to handle it, now.
+	 * __GFP_THISNODE means the allocation is restricted to a single node.
+	 * There is no dedicated constraint type for this case, so return
+	 * CONSTRAINT_NONE and let the normal OOM handling proceed.
 	 */
 	if (oc->gfp_mask & __GFP_THISNODE)
 		return CONSTRAINT_NONE;
-- 
2.25.1


