Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9BE3C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1D36B009F; Tue, 11 Aug 2026 11:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9A266B00A0; Tue, 11 Aug 2026 11:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB03D6B00A1; Tue, 11 Aug 2026 11:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3966B009F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:27:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A48A14044D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:27:50 +0000 (UTC)
X-FDA: 85089368700.03.17934B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6152516000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:27:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7buYwgU;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462068;
	b=VsoZ6S93nnrowxuOhsfV7GSSvYUVQiFuA42jUsXh6I3iAfsxN7wphSv3b2pGXfMg0E2xrW
	NnGcUWzuAOwXfDESeowd/AByCeG4aJxPVAu+xg+2nB1q3A64VkXlyI2mrQc+2XnCf/hBS+
	YGfDKl2gmesF6A8MNqhrmfOSic/xzHQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7buYwgU;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0X4qAQGOj4Ws5+MdwykOepn652tQT1tcVQqlter/BI=;
	b=msl4azLVKlCnR0DSRxc/GNnqsmycG9nqjFUlksfWZrm95ODdzHjaivLrCcAGhTxfy9qkNh
	7OvrKQvEuDNtUyWH3ZI1RLlmrhP0ziPrLMobVlbxJLZ708CwgUc+dGBuDyvBLPR2q+QG+L
	9N7Zhr+5/9KUseruVJFPjPDRHqWwAR8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03FF5600C3;
	Tue, 11 Aug 2026 15:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711681F00A3D;
	Tue, 11 Aug 2026 15:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462067;
	bh=X0X4qAQGOj4Ws5+MdwykOepn652tQT1tcVQqlter/BI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=e7buYwgUaziBc1ANvD2UI/ojDa/PK9hy0xEryGVTXt6hhAv7BxZr0pk6eXRo0lUW5
	 H9sZllbu01qd/GbMN5wZ33oz87qkFzZ1py+pMuA0BLhmM/YI/Y3RHrBrj96nzs//4r
	 tddLT9TnZLRlv7mEEKH9BI1kOiCWw9TOljnV7zOi20v+29vzVrK62DpFJzoNmYpVIB
	 9o8B79PymbbumxLEcysFVZWMb3grWg5R8xsmCG/IhpRQeQ7sglY3a4/vq/CY1wkdL+
	 HHB/NrYicMzwPdAmIEUZTTby0tNrYO7SRCl204XN/Jtfk+cVR9EtxNaZpeh4aFUzsC
	 Eb3CalwVNeCoA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Aug 2026 17:27:24 +0200
Subject: [PATCH 03/11] coredump: pin the protocol struct sizes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-work-coredump-sparse-v1-3-cd3e8b1e356d@kernel.org>
References: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
In-Reply-To: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
To: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1989; i=brauner@kernel.org;
 h=from:subject:message-id; bh=SpbEtOACwAfhrvnTo3HVdvq33xeffDHxwIh3irpBTA8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRV2yfsmr3WqlU8LPaH6vTjssqJdXo/M2eXLTouF8eXW
 Rt102ZbRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwES+JDP8MxP6V1N1ZL7jwuMa
 ltxbn3vKHWFcHCyzaEKda7fdOkn1x4wMbS+mtx8/v+HX7U4+hR3Vr7wZIlMn8D7/Gxb10aR7V+1
 GJgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 6152516000C
X-Stat-Signature: k17ysb4qzu344xd69kj8qhgt6myhst9e
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786462068-296739
X-HE-Meta: U2FsdGVkX1+1gODMoDvsW7ANCCGIiHZo5mZjtZeTAq17dHQ154w99byUHNuHRNBke1g+oATBmhCB1V+nciDR+0hELD6v3G5NPxdi4IhlJIhx92ooN4A3zwERsAMtzVZIKRK6Y5R28SjkDBxcBkm7kTckk55oi+1lZmgxPv41XkBRWJD5fJ4zM6hZByyyX1kwmyHUPAs146mHoVzq+e5AaRGfkPZGoZ5S2YyqVtgrBh9uxXGetqli/CHAX/3/5mUyTlnRMHf4BNj+336lOVIy8oZcQiLgOvb7BFysf89dUzA4TvxABZbM1ulhm6+ElxLmIuimth2UI4n25+N5WgdOdYIDQ0qVbJPmqlumjD69OVSa/8YHNePXuty5LWh9raEdUVqtgNPZ+k+ANyvr9DmLTTHlDxNOlS5hQvRip3FhqNt7/PfKGqEFF+oxJ1AOGdj3Nfyk2wPRRIXtNVCV+jCV2EKTh7xjYuCJ9FNM/oLyw2lKyhlo/6/TylL5kdpIlOd1wkMMkcAvvrCQKjYP8NzzUVoBrknfdgjhCNQI6/VT0M0SiGaZWcekfQ2Mm8r35v6MQpFPx51d08Qgma0dp8mZP5hGYTJMIxEZaXDnO4zt7K/ISRF3t7o6wvoxS7wbx7SDMuFPUmbgyD93e4YEpIw48m+CWUPl7kFZLChWZh3P15lhe7n5JnRi1mHyUupXgXlY6sneIHV8vBQ97drZMPCFmfEvANRRN/Chf8jfmV2k0307COdJrr7OJ60BqpOvjL04yym2g6Ofe5cEeooGad8QdTwVkO+OFFozHBHfU6CEp2IClGS38w0y5NmZOVxgCgf0QronxUenWRE0El6R0eoi6PEdjtk9h+Z+pLfakZZXDCc20MeHDPLmSbwQnTmzhPEgTHg5lks7qG+is3CGRx+EOPLEy3vX8pbIUYI51Qu2yRj5WK6oUOIttYmcg6kFvOP3JSDSDVTEGHdaZY0ZOl2
 NoO391MW
 HIK8csokLsHoTncdRCHQb20vJcIwZOTgczLNOmRLqS1GKwKUdjhmRULFPXj1WgP//qMJUwVTnp0ehFSb76oCmMZ//0dRUnK6dhdIAawifkxfty3tt2e8iCZxNiD64FGYbck0dClfzHwp3IVKTrF1zqp5SAtLu550dBOJxBEJaMEV0ukun43zywSSND8CIDXK+sBjWN/6T+b37ceLPv1UbSh3zfxHdYj9wRca8Jfvp1nC1hb9zVt7B5tmRbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

COREDUMP_REQ_SIZE_VER0 and COREDUMP_ACK_SIZE_VER0 define the initial
struct sizes.

Assert that both published sizes still match their structs, next to the
assert the coredump marks already have. While at it fix the "currently
know" typo in the doc.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c                 | 2 ++
 include/uapi/linux/coredump.h | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index e68a76ff92a3..235b54484107 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -752,6 +752,8 @@ static inline bool coredump_sock_send(struct file *file, struct coredump_req *re
 	return ret == sizeof(*req);
 }
 
+static_assert(sizeof(struct coredump_req) == COREDUMP_REQ_SIZE_VER0);
+static_assert(sizeof(struct coredump_ack) == COREDUMP_ACK_SIZE_VER0);
 static_assert(sizeof(enum coredump_mark) == sizeof(__u32));
 
 static inline bool coredump_sock_mark(struct file *file, enum coredump_mark mark)
diff --git a/include/uapi/linux/coredump.h b/include/uapi/linux/coredump.h
index dc3789b78af0..662e0468da6e 100644
--- a/include/uapi/linux/coredump.h
+++ b/include/uapi/linux/coredump.h
@@ -30,11 +30,11 @@ enum {
  * member is set to the size of struct coredump_req and provides a hint
  * to userspace how much data can be read. Userspace may use MSG_PEEK to
  * peek the size of struct coredump_req and then choose to consume it in
- * one go. Userspace may also simply read a COREDUMP_ACK_SIZE_VER0
+ * one go. Userspace may also simply read a COREDUMP_REQ_SIZE_VER0
  * request. If the size the kernel sends is larger userspace simply
  * discards any remaining data.
  *
- * The coredump_req->mask member is set to the currently know features.
+ * The coredump_req->mask member is set to the currently known features.
  * Userspace may only set coredump_ack->mask to the bits raised by the
  * kernel in coredump_req->mask.
  *

-- 
2.53.0


