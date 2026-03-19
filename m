Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 713F5109023F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22F126B051E; Thu, 19 Mar 2026 11:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206AD6B0520; Thu, 19 Mar 2026 11:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CDB46B0521; Thu, 19 Mar 2026 11:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E91E76B051E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:58:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8A8A1A061D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:58:02 +0000 (UTC)
X-FDA: 84563268804.06.A4CA319
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf29.hostedemail.com (Postfix) with ESMTP id C8955120010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:58:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b="W5gcWnu/";
	spf=pass (imf29.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773935881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqBZZsdChXPych6lUYI4fPOHNYXnLYcU1he98Py/HTM=;
	b=qg1IBWiiWukhNUIton48Z2wg8cSSg4talU07yAIuMRJUqHRwcCHn0irnkhzvv1soF+gQCY
	fIxE6YhZW+KeIGxwRPPUjySxTCCtwPVhnIhDk7mJIyYOGGlTbKs1/S9cBdbZa+dnHfuKJC
	SnJq7SRWnr5PqF2b/uvarS/v4fpE6E8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773935881; a=rsa-sha256;
	cv=pass;
	b=gdnT3JNSdO3GwrUs1JbsxfmymHxhnp13lZwghbmcx5BUyu11qq+Cyj5Eh/Y6d0dhJQ0nIY
	/rWY0HtvIfyRQRCYKr75+93nj03zDn3j+naRARanY+984rYYnzhPIAYoY9qU47GbqRaiyb
	gEpgbycr1IVa6kOjLQwL9xH5fmyoG/M=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b="W5gcWnu/";
	spf=pass (imf29.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1773935868; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=c+tKqOHY9UPTynVSBbutAl+9RnHzVGguG2Um28Y7dXBKuOWFS1y7jnvi/52w0+QfEFHdrddMrknOOSKHCqwIPHWZ8rbXdPIpMDbWxrAfmjz/KCSue4h2kGYKHBIR7Hk4/IMRjluq4REqhbGoKI5bFDblcOHUpg00ic5bwaNZzKY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773935868; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=IqBZZsdChXPych6lUYI4fPOHNYXnLYcU1he98Py/HTM=; 
	b=KguRJssY07DB9GtFnwQrBywG8WzY9Lmd0r4H5hR8QwsvyKAPEdOHNw2SOGaAC3HIgANTnmR8ZgK6od0S4UJm8Ss/ezcAimhUnaYlcsIguxpzIa07UGBQVS9lRUla70oo6WCIrOYprQw4vRigydSfUFfc6rWlaI5QiB6XsYBLxjo=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773935868;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=IqBZZsdChXPych6lUYI4fPOHNYXnLYcU1he98Py/HTM=;
	b=W5gcWnu/w4EL90obqxJ2PnFbcQYOeauhiDKhqN1sO6UBQ5uZBb1ofNh0Wz5t1uOf
	h+AJCppag9NSvtLfHBWi3q/8E2SsGvP0NypykQuMnJYa/zBqOxy1b+v5dR76b1wBvVI
	eWIE3hzRkPLnt9EtTICS2CbkErWJ80esNjmkU4YY=
Received: by mx.zoho.eu with SMTPS id 1773935865417260.7882034743719;
	Thu, 19 Mar 2026 16:57:45 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH 2/4] mm/damon/sysfs: check contexts->nr before clear_schemes_tried_regions
Date: Thu, 19 Mar 2026 15:57:40 +0000
Message-Id: <20260319155742.186627-3-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260319155742.186627-1-objecting@objecting.org>
References: <20260319155742.186627-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8955120010
X-Stat-Signature: umq5h7ahyeoprdqcydiukfa1zzbt7ytf
X-HE-Tag: 1773935880-215544
X-HE-Meta: U2FsdGVkX19nvcUzjhXplMLjXXANVDaf7vYsW1F0coXdl/BjNdeKIH6rIo2DikCODIAWBvQazMMXI2+m49LOvNuyWNqu+Vkb8JDiGfmUWHmE6j5gW9q2BESAhMoWuWX2BDzbWYTHUiNChJ/Enz3vLDnl11QVE91NXJGhM5QJLntIfPKI4zHMoBeDP7drjIHUbq0uil3DHMG19bf3rXV7oBV1c0v4dr9pevSOO9Xrp0GM/uKKutAFuEyim1Pc6vAML+jGA0xQHNiwfqOSR4EVShzYEQVvzWxu/+qYG3NME8eklxa/vzMTBTA4csVKJlGWAnFemUYmqPVboBC0yvzHoV+CzEm37k81QH2jRhhVfW4Odbs4qKMqKP/D5k9A7+MMAdjjp/T50Vr0qu5y86MPiopIWn243z3zPZsAk29h7jje0nFgtAbOycJ0KPKlaR3PY8e2UKewLReUPo/x4F1p9fB296IFyTd3LL5Do/YGE2OeGnksftgDe51B1GJj9HFZ31QBQIOyc+GCYRKIVH+XtohTr/zqEJ3l47Q8YKnlWBwZqnUtiP2BanSWNOySDtag/dB4Y/4G2fFeYb4UAxq4lmSzfzdW2Nt4bZGUH7xLLUQCsmiFKwcZDms+h542E/EpQbdkkgXBFedphjcpH/eLD7baFLZiF2hbQduXHpHPwvkhPiF3+e2dY+ahbh5DF4wWcc94JddWgIss4pHmkXjd0VjLkFJHwC2R13JmWeuSKJjv3lDevVo4IkvZ1YldOybVn6ZHThpGfHKVdFHBsQrNX+7CdxNEu+noCuxI9jRDYgM5w7tKt9G2s9NTF4i6NidxBODijwqdgRgGOA8kdi3njegIfdc4+KAlF/ZCxZC6LvH9QGQIJ6kARsXveOx3QBg9jH+fjsJnsoaFuFgWtLIkR424DDtMgXXrPm43Nph4oGQUUJzWdWC7JJtV4ELbGV2YjIqMtqzVvjdKCcoN6ks
 xLqk1ZBH
 sxAK4gYwrdXk14+hW5rhja9kIU+fsffG1v+VEXQhk3/OWsHV4FkqDx9AsIlsXZ+cA/zfHvVOKdXWcl6bsypEXU4doI8ES2ViBvjTMc0mZEQexlJVuUnI/+hdnoniom7LYsA0qdlUouc5RQN9cTPGL1Qi4egkADBI8cD0RkDg6ClPNwdh/dVGR8fdXFR5h3Ky7bZjNZ0dFhvmdGf0ODEleo6yIvOndpXjGEKbwUaOos0g9ZKMJm/Bwhphqt00uySL1JcGuWEgO50XgtEjk7ujxnAyJneS91cxCBALxDPMu1EYOVoZmfp32I8xle+Q52qYMGwujFm2i0YEeReEQs1rCFKd1FxbSN6kU6rZBspNUwetNEGFF/ZgIxWenyysKGnkHaO703zC1FrrFziQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CLEAR_SCHEMES_TRIED_REGIONS command accesses contexts_arr[0]
without verifying nr_contexts >= 1, causing a NULL pointer dereference
when no context is configured. Add the missing check.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b573b9d60784..36ad2e8956c9 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1769,6 +1769,8 @@ static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
 	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS:
 		return damon_sysfs_update_schemes_tried_regions(kdamond, false);
 	case DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS:
+		if (kdamond->contexts->nr != 1)
+			return -EINVAL;
 		return damon_sysfs_schemes_clear_regions(
 			kdamond->contexts->contexts_arr[0]->schemes);
 	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS:
-- 
2.34.1


