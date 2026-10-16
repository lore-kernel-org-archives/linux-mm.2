Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C9E0CCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6068F6B009F; Fri, 16 Oct 2026 10:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590096B00A0; Fri, 16 Oct 2026 10:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4587C6B00A1; Fri, 16 Oct 2026 10:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 210D66B009F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:38:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9EB1EC049D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:38:35 +0000 (UTC)
X-FDA: 85328745390.05.E349BF0
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id DF8CA100005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:38:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CWSFsjoz;
	spf=pass (imf05.hostedemail.com: domain of adrianhuang0701@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792161513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VzZTNMyuwZMv2FtdIQag5FG4n3GogIS30Eq+umwptRE=;
	b=wk9jHT3dM/ePmuRoxje/P0nUVIcHYnU9YZuDFIL3K0SxyS4+xFTDNUjbN1JWFWylJRca6q
	zIeDuzrQnYtYtz9sTgBirHa0Z/gy3C6FrzLeT15dtvEE+E91Cw20X370IWv4oAGDhi21rt
	32W9+59IFIaV/aRLoW7sbukpRiTjW/I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792161513;
	b=TI708s1ERsbyEvYbp8Jgw7WCAdbgyI1x1lTRBS+MNH8aj/IiBgB0yaUHKbFl0okLJFfMGO
	IqrDAb+MhXW9RjjvmopoHWX7dHBxp675EwwdiKQU2k2s+LkQQ8Br05g1PzEmoGaBcBtzrO
	EP+cjM6iP4g5bRsUo0NmY04ElQ68FUY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CWSFsjoz;
	spf=pass (imf05.hostedemail.com: domain of adrianhuang0701@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-35aa0cf7c40so6915630eec.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792161513; x=1792766313; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VzZTNMyuwZMv2FtdIQag5FG4n3GogIS30Eq+umwptRE=;
        b=CWSFsjozqPKZVLlTPMy5hq3iZy2pygPqhtjxHR5y9+Wa5M2y85teCOEupyzFnSf4sn
         a0oldvWV+yWajC6X5XQlV6i+I0JYI4ivTiM8W43DwVUhkVsiotQLdpNExiR4UNqcm0/z
         hFgLDlgKscAnqW3b/6GlYv5opuiyQSJgAY0dvtYiNQKKNS+2m7MFtZz+PXuhz/Gi51eK
         bsN6xnixKim5MYkkFjzZZibuUdt6hEydOoaUZOE5EcdTmwCVSlwekP/QOSyH6FqhSVUs
         Xh4psAWyM1OyeOq9Va7m0cIX2NmfaXzrymCBdR6mg9Yap882WYPo2DpdGlIwQUwOd8N+
         xurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792161513; x=1792766313;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VzZTNMyuwZMv2FtdIQag5FG4n3GogIS30Eq+umwptRE=;
        b=E+Xs40wDMidqinFa/LB6EGqIFut6NfW9IfJGe1k1i+OgXvPytS3SfifHd0XGHim3Ya
         p6fW3hz5aNLgV3+YzeJ2SyPQk+upaFsGIZUMgNGwRetOvKdmrckFsrpZLUwKhinq3bLl
         svNPvNRnSldxIYd2e0+o7LRVFG43Nxh996qWrjyCAyLTphi19x76tOaM0Xbnjf+kqg2r
         PSUwxJVFZ5FMZ4GLA33BEaTM5ilbjPt2DbLoFZPH/EIbCb0REGmVRKlJ3CyhDaAnVI8I
         UF8W6lqeFAb3M7pjzojVpTYoZ0s2DvjBV3A4PvKnAYJMFDpR3xBtwOF8EK2mVmK6INp0
         ddkQ==
X-Forwarded-Encrypted: i=1; AKwUvBxcr/JsmUlPk3wLai3+cn6C+QaCSiFeWRPc8dqz+8lIdAAgYIlQqNgGXZq5XgyD5FGxUBNDdcBsYA==@kvack.org
X-Gm-Message-State: AFq9FYKgncJHUNRnB+iAcSOa9pBoXPBT4KCIDtdjUgueV+Br/59VgNT5
	TwjeRKwmv6aqBMiMAfjbMuECVybU9kUvIvcAxC2Er7sfd/wUNKBbPtz6
X-Gm-Gg: AYBFou2+1/FQQYlPUktvPMWISGNYVP3dUTZmkZReQ+e++5AGnC0PXomFzoBw1uDzAyB
	EFlojks9izNqhzjhtl5AfGNr6qvRecmdWEIXJwe6/4rV8CTVSvRptlPP8B289dKMQ7Ib1eQ8kW4
	DOJArS4tKV8Qt1oxx8lnU69GY8zO/oOei/XfIHN7lg/EVEiPkGwnWTsKSTieqzsqxfjTMYLfsU0
	dHDqtlcY6rfEV01pMNaUo9lic/nZp7bl7oMh7wfnS110Uf0ot17X5C12TM64gHQIGH4AttjxyAh
	HY/Kz7PAPdTljNa+lEKyjQlqGlliuNOwfKUx+UHtHfjeTYLdV1806lCPAirnyWdz9v0rox3PMHt
	GUWFIGEys963QbTi0FGklX2KATZTCk3hc6EsJr2rcs+SFyhUWGEmbl0XMkDF8T0tUHd6RUWQoJM
	Hwbqd1wL6h35kkim7BqXL2598v2GKus6aZ6zplHlScW+WHjR3M2AexwSiV79U3DAcumg9FgABT+
	J9ElrLCalDim81YYt44sD7ZudSXY2KYFhJRTUDr9f3CgzPYotfjja9FoGAGUUo6ZVJn09/d8Ovd
	/9trhdoDeEiT1+0egQ==
X-Received: by 2002:a05:7300:7aa4:b0:35e:43fa:eea3 with SMTP id 5a478bee46e88-361a137072dmr28441eec.8.1792161497077;
        Fri, 16 Oct 2026 07:38:17 -0700 (PDT)
Received: from AHUANG12-3ZHH9X.lenovo.com (61-221-208-111.hinet-ip.hinet.net. [61.221.208.111])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36081ea7e5csm7069382eec.15.2026.10.16.07.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:38:16 -0700 (PDT)
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ahuang12@lenovo.com,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: [PATCH 1/1] mm/damon/core: Remove unnecessary zero-initialization in damon_new_ctx()
Date: Fri, 16 Oct 2026 22:37:33 +0800
Message-Id: <20261016143733.320-1-adrianhuang0701@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DF8CA100005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 736p6thtdh4j6tfeyodxz15bw37iw1tu
X-HE-Tag: 1792161513-242298
X-HE-Meta: U2FsdGVkX1/tsQr2UaNqdRRn/cF7JCydB58bSR6AQfNGuvN+a992OQHAiS3xEB2ADb9TSC0cOSXm6QxW4NkBcCeVzzTMyTfk7tBE85pG5necAX+RkwXeV6UHn55WyI6Y+L64t7SAUpnBnCWOBdqCPP7C9GmYrmnBcO2Pxp7kBYehFhAv+lMwWkE8vpN6mnE0Z/zmceyE70BhPnaA7nmmpNEA5Es3xyelqzAkUTQ82ZlCJHVGcRfmpdjALzAISK2jGpUJd5Nt7afvUxyaPMYRzZyofHoAL53DkXumjMlRpJE+jE4QEDl3MTLY+eU58aLjU8gRPG3OEbe05MB7CioL2DBDHzeLgronmDH7BJJ0jo5U43DgWZSgzuOBwWpIzhBujwdM0FBNH2iD/FsQiR7Eir6K2/VJYAzQcI0HKhqJ0V1TIyicriUFyFDj7IOVLVg9vbGXvM4gxlqxP/jYEi8xuWvBFxbRNNI8FZNwfi4CXUJgYDe+ZvuGHz47+u48LLmx6LBSbiH2e1KHC7Ddrb8Ruh6htPrX9EHY17+XNF7Y45yr9+ZrOI2x8ncI7vwAIhoje94cyN51g3Vf12puowAi8XrSRTe1lOVIaXRelURKHa5CjEIwODR+Qkhu5o2KubDvZ3ZVXSqxhrgVWmJQZJrrWqMYycxTO+3vcNtnCuhkY+/GYWjO5hc8rsNLBxntIn/o9fCUbZ5gatadvB4GmKAhIGhImcKnw6AdmzapDC2+coiF3Jis5EOZpXRsYhzVHwfQcbIlBOkB7MG6/T6KpfLJuh96cbXdZVVgqVkLrFgKNjP6kh5xa+x+xPKNY2NrvhCrgVZuGICRlyHIG2sfMENlNpN4N8K6A8OA+GKtJ4YlS9ahHNfvBm1ggDKeMfDsP7d9WH2NjZAuAkfbzxenHwmM+gCnVtUD5CHCtoutPvbvahriNQWJONh8ddicpWqewoQ1De5xAAAJe3BXkuMqaZa
 O9FsfUDb
 oclBVOhcxaqvGqjIlND2M/e+B4khHcPjvyLh7Nuxu3ESrz+ytakdTSt6VEVoy4wuKkJ+EHNdfQTQvysU2tUu2yzCRcnQhJsjD6m7HNt9pWrb5BN47WvOgnehYy/rXDy09P3Sp6cO6cNDbzT9m8UPOVoHz1Yzfo9fQv2AXMxewdjFd4MxnqJarRGbT2XPKvZ/GrVAPw51mkthNRxWqDoCDOHtk/h5li3/01wAcD/YneowkG9FVyXc5ODy1qM0OsGopuadR5D93LVFm2mzJ2w39zIdFDyI0fdAwkqWqJuE3OdYglljEEPrq1IKVVB+ac67BJS0Nd8+C2bo729gcUBpJ6MYZIJlZYzanwGixk+XTEPPHgRZVZz8kEELU3h53L1BJHwlPwxE4BoEpBAtXVEk3tcv0juxc2Do2mSnqQr+ZE/GskzqHjQ+YA21W5P8q2rwHeIHNwsMk+x0/mFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_new_ctx() allocates the context structure using kzalloc(),
which already initializes all fields to zero.

The explicit initialization of passed_sample_intervals,
next_aggregation_sis, and next_ops_update_sis is therefore redundant.
In addition, they are later initialized by kdamond_init_ctx() before use.

Remove the unnecessary assignments to simplify the code.

Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
---
 mm/damon/core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b63e60ef8990..74e6022ca137 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -918,11 +918,6 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.aggr_interval = 100 * 1000;
 	ctx->attrs.ops_update_interval = 60 * 1000 * 1000;
 
-	ctx->passed_sample_intervals = 0;
-	/* These will be set from kdamond_init_ctx() */
-	ctx->next_aggregation_sis = 0;
-	ctx->next_ops_update_sis = 0;
-
 	mutex_init(&ctx->kdamond_lock);
 	INIT_LIST_HEAD(&ctx->call_controls);
 	mutex_init(&ctx->call_controls_lock);
-- 
2.53.0


