Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF85CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 19:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58AB06B0092; Mon, 18 May 2026 15:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561586B0093; Mon, 18 May 2026 15:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477696B0095; Mon, 18 May 2026 15:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34FEB6B0092
	for <linux-mm@kvack.org>; Mon, 18 May 2026 15:12:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C69901C1F36
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:12:20 +0000 (UTC)
X-FDA: 84781486440.25.B2D0885
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id A692DC0011
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:12:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bm0qcV5V;
	spf=pass (imf22.hostedemail.com: domain of mshcherba2000@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mshcherba2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779131538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGf0CT4yKcvvme5mdnXPLSkPCDM5qKcEM+nXnBaB49Y=;
	b=dVGPf+lCbpZrx6Jela5S+5kdQE04Cn973U7ZK+/8vtZR+qEB6DiFxxVkmytlrFsceTSsCf
	ppTE+d5KXMa26sNsXGm/+11L0oOOnLikYuZJmV9JLXdrvyk9SI/uF/3prv2AI4qQ7Yyt3f
	NatTxVyxHSwhKO8bg+NM9HZpdFCGdAU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bm0qcV5V;
	spf=pass (imf22.hostedemail.com: domain of mshcherba2000@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mshcherba2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779131538; a=rsa-sha256;
	cv=none;
	b=UdOX/L4/GYUSg17Bd3JhefZVpc0WQ+zWwCOsVwx4QQYfzqZRdSLaM3Pfj60KELax0y9FHz
	M6UFXdmmPyKMxEPjimHDbRnZmmoHLZCzcSOXekU+BF1vatGJSU8XVw4yTaXEenaeOcMwzE
	SsMfnRd+CAa3gkrpRVP/0ozjlcj6itU=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso16397955e9.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 12:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779131537; x=1779736337; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yGf0CT4yKcvvme5mdnXPLSkPCDM5qKcEM+nXnBaB49Y=;
        b=bm0qcV5VMgoZaEDac2bP/KBmg9ekQlKdQ3vb1KyvZtPMJJyfG3i8vyvAxCzNhz0lor
         Mmoijj6T0ExQhK1w5fB4/8NC+iN4pXuN6hmxYKFxuynLnD89sjcX8TAtkLi059RT0U4f
         bP2zuuylIBgv3dqNn3ZpfFcTIUBNgDZgL+g2elG0WiXTdhVTe2hZPXuCM9vF5q+GZUsX
         6Gm0jENdguVnJ2wybFht350drQ2unE8WLRiDe5IwW83zMmi9tqJqiXGyqRKH2vSBzGmw
         tsiKpbGfuuDAi3L2Li3cDCqzKNpbMEViUg1SzsWafjqnvkz8jgYxFnd1s9k1D8s+J4pB
         vilA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779131537; x=1779736337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yGf0CT4yKcvvme5mdnXPLSkPCDM5qKcEM+nXnBaB49Y=;
        b=qvfH42KOAOAyii3gBWj3y9eqHNodceoa1NVCzwNPNcpLBT0r5H+dWQ0h2xFiwmSpU0
         y++wPq8BHcRw+munV04Dy51xg/h4LEmbMVQgFFnun6Ykb8HX3/6xqi6yjTu6Hnbw4ftM
         y2HbCtwSratTmqKrZqVcySw7cx785iovcOlwh/CB1sJlNeZfh97Wif/plysDRIxnmCQi
         HeRmVP6JTjX5PoJaqUws0IJdYrWrAhIryPgCxc/HQLQ0slCa1QmSL/5Chn2beyTiSXIA
         AXt6IAfcYh9VkQrKQ1KSFRLr1I0MlGBdC8toIN7JGIVfstMnRMAqnOhX3AM5az0si8/i
         aC+w==
X-Forwarded-Encrypted: i=1; AFNElJ8PCmBamHTT8Vc2AFREsQKJ0icuiRDwfjNTGLxUVdDn+Ri0hPVLILgjxhyhCGHzag9WUKHqkGd1pQ==@kvack.org
X-Gm-Message-State: AOJu0YxACdBujkB6QGx5/IgYZMxqD8SU/goD4gj/WMfA97l6xQmaDmZI
	Cvmyf/sxwoRI6nmgkUqCwZeItyDD3ZSs3RrREqevy7sWDscqi1KhY267
X-Gm-Gg: Acq92OH0NvT9RQAMem9dAarwfEvja1j0+D0NfpKetjURgVcZ/rpEX4WQjLXKZXcJv7y
	y9DAB+n0okRcz/ZEUVqKlznQo9zGEwCz0mW+NH79SxKwdeLMitzrDjHYLgHG1+LOd7x1voPKWZo
	8JX24+w8bgZOCoJ3QwknQnqUPw8+4PTDzNe8uRmdrMCA/vXM8Nu5v8X5F/+4ZLzgR+XpaJADIu8
	lBuaEK1LGrCcrGRhm70dbTUPZoLKJmDvfZ+/1ztJH6FTAks/bCAvmZrOGs5suvempwT8CaMw26h
	xoics7wjShb6uizbCM9KmtG2MHpvkGXc03SSdccO+TcirJXUIyarvIw0fXxCF7C1dzkN2VYjEx6
	LjRwcMQ4YoCqV7N/Ieeih0fcL0MbVlaXbm3YZ5lf+M+wbOv7n8XgD4+Z8knbHb2rufc+LWh6pR/
	tpC8S00rJgA2tju7uZg4Ab8D++mKc2XWbz8qB72lMKVPMgWbLEXmI=
X-Received: by 2002:a05:600c:a11c:b0:47e:e2eb:bc22 with SMTP id 5b1f17b1804b1-48fe5fd536amr192002785e9.5.1779131537200;
        Mon, 18 May 2026 12:12:17 -0700 (PDT)
Received: from mshcherba-RedmiBook-16.. ([188.163.115.207])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm40043167f8f.34.2026.05.18.12.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 12:12:16 -0700 (PDT)
From: Maksym Shcherba <mshcherba2000@gmail.com>
X-Google-Original-From: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Subject: [PATCH 3/6] Docs/ABI/damon: document update_schemes_quota_goals command
Date: Mon, 18 May 2026 22:09:29 +0300
Message-Id: <20260518190932.42270-3-maksym.shcherba@lnu.edu.ua>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260518190932.42270-1-maksym.shcherba@lnu.edu.ua>
References: <20260518190932.42270-1-maksym.shcherba@lnu.edu.ua>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A692DC0011
X-Stat-Signature: fxay5wtpb3z7r4p7g4t8g8zda8sj3d7m
X-HE-Tag: 1779131538-450686
X-HE-Meta: U2FsdGVkX1+YgiY/AQu8LvPgvAX6ydQUwV9Cv+qdPEX3DGv5pvwerSjvBtMcTRkPqxdGlz8GHqYnGRxjfrQ1rTdzBzzmMAT+tjTa9FQVJGLdoBdeY/ZtFgChZAh0+59UXqSFWe0KS5HLO0k1rJSU0U0S/WeHAdPxdnok3NgN/Kjebg5MFanpqWVZxlkfnKDnoDTshK37NhYRJ8l7pEDdW1VhNVzOma4rthHcw4FKLo3+Fx038rno7mR38fT2rfgTK6vwA6pElz9vUnmbMzNuSF4i0ntzVZsQ+hW45jCKlAscSkzFVibaWD1eB4SLbSoI3A+bzNM49zfOfq9MklaFpuNuLrIGK3f7ZFio4fM2SXol/x+L2oJlAim2H8gxNzOUYyZ+MvwYfku6vjJYg+ESog9UY/RH/BvRC5vqS6pPdkOS0yZ+wIAYu4nv1J8ubLldjxxlkmEeF2L/ojyvcg6Qf3VTJA+kPf0nVmhsicyLDuprKfve2RO189tPEgpdwkYRFewQHHSBcK+6a2cvpl6VkkrfpYcMq43qtgr+R2qVexs0vYfK6uJ0Niu0F1NAWVACgI3sePn6deYtcmasXNVwT20i7vrFaD3khSAPxMfAGU3m79wYCyIRec6GINyzzvKw487ph6HEoad848KLdgO/lS9Lae33dwC+6OjGumcMdH3f0l/V7YbWIIwaJy8SP+ljhv0JG4n9ktlBo38ZqYoRuQHDhe9DDuYyi/5UQ8Ka8ZDSKpXFEz/canMalipIbjGD57/j0QeG2w8//WZpD8AymclwonCIuS/hRTSsMebbKCuupZjzXqH3zR/8er6skcKZ60t/2c+A3KSmBqKptMmPKQVT1WVgsbdXZJZNDMPQUycb5ACWqgfbOCJozgz2CoCQJbt/dY+vZiFkPGV9BJKauR4wK/mCAc4SsEK0VW6hwWK8Uex/pXZIRduMGkz3N4cHFr1IgSeD1JmCgRC9aN3
 DnGMW0g0
 xzelx9ommhB5hsCBRsdPVgNGNzNEA0/QuxfG7vmtVTNC24R0JmyIK39aE4mwSzKabCIhgypuhRU3nUz3gcDeTQWT9a21tTVVsSsDnz1xAP1cKvbHEoxBxPoAZYJauBseGl3ifmOIU9nGQkdUJ0HbfGLwDwn8TGDhrxtM+9BWIv7x8f9/Xr5GtNwExGyZXfR8PHMsGRbRJlK9wlVTEXFvgeg6QY7iv91VjpSu3EXpEbLzGUt6aVp3YChAXcwCPvIfCFbxzOTaLpV8N0FXCou//jOwpTmWVqr+bA9MCa7XFlz5cl2v9ENmmJhSdZm5bT1nVJi/SZ32Ikt83tUA862kMIehqYKcxmY+TcSYgwVO9h+lEKWkb3UA4i8qJ1rwE3CvvRMFC9QOxo2+TwvCP7fOmqCAcQgN58LD1oyMkdheG5uoT1vA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the DAMON ABI doc for the kdamond state file input command
for updating the current values of quota goals.

Assisted-by: Antigravity:Gemini-3.1-Pro
Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index ee29d4e204ff..0bd33c1e6790 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -36,7 +36,9 @@ Description:	Writing 'on' or 'off' to this file makes the kdamond starts or
 		kdamond.  Writing 'clear_schemes_tried_regions' to the file
 		removes contents of the 'tried_regions' directory.  Writing
 		'update_schemes_effective_quotas' to the file updates
-		'.../quotas/effective_bytes' files of this kdamond.
+		'.../quotas/effective_bytes' files of this kdamond.  Writing
+		'update_schemes_quota_goals' to the file updates
+		'.../quotas/goals/<G>/current_value' files of this kdamond.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
 Date:		Mar 2022
-- 
2.43.0


