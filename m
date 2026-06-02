Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E0DACD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 23:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1D656B008C; Tue,  2 Jun 2026 19:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE946B0092; Tue,  2 Jun 2026 19:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4356B0093; Tue,  2 Jun 2026 19:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE1D06B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:08:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7203DC0320
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:08:28 +0000 (UTC)
X-FDA: 84836513496.22.9DB0CFF
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7F8401C000E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:08:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MCOfDu9Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of richgieg@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=richgieg@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780441706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0GIZuWEjzdftbLCeg+S3fT6BmWp6abBdPT28rO+NPEw=;
	b=RihPorpf7pxv7kibiicGyG9myOqeLrnPifixIi6HcA8mKXoiisti48vImntbiI9NmXfi4d
	mncHV+MKm205b1kmI2ZHBDt6+Dduqw2hA/PGAkzc656ZX081PAdSw8HVcVoqxaew00BzHd
	lFF/YZn3sdJT6qpSyhwWkNT07yMCgK8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MCOfDu9Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of richgieg@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=richgieg@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780441706;
	b=bBc58sBOIWJcNwVsyYjP/80bDS3D5Yd41xizyntxqULJkDro2/vYH0NXDTPIfPuHPEd40n
	9wVlbsq0KlCsIpypWe1FIhllwUPeZbWNz7xNqpk5nFMlEAJlNtSq9oSKVns3VGUcByn1tT
	IXmDMtdTkMSLLArfXie3gYlk8yTDwxM=
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-304e83724bfso6599209eec.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 16:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780441705; x=1781046505; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0GIZuWEjzdftbLCeg+S3fT6BmWp6abBdPT28rO+NPEw=;
        b=MCOfDu9ZUI1RnPEa+EFk1fHRlNL+26jvYoraE0BYVKf1GiBSQ7+RFRF6LaX1S+I5/n
         smAElmYNYCrNlnzRn0OFko5gb4dQLdBzjqn5EWMDHpF/YsiQTjDDg8y9oCZN722GtmnV
         IQe6ZgO3dLqXx8IpaU6ZAk/BU9+QOdahGIgLcHmyCIKeBbk/3okEvCLlvlDT9VaegQJc
         basf9AYiy1tK3G+F3L/TLKU+IxnxHIVNe2o6zjbfVbGbYh41N07iFpzx75sEwO047P3f
         T34nVT7RUYdpmz0IjIM2P04K0fzIFT+VQhnge/mBagsw0GzPT83msAce4cjSv03BghoL
         kJhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780441705; x=1781046505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0GIZuWEjzdftbLCeg+S3fT6BmWp6abBdPT28rO+NPEw=;
        b=rEhZJrFu+3ZndbX8kkhKFy0KtCCWwBZxoqWq8l5/fTPm4LKnrkesHa5wzL9I6tJCmT
         cASEyW0X4jMkG7zFZrXQ6tpUEfTctVnZz9XiP3eOPsnn9nQprj/Lg0N0/97ZPlLQBuYh
         dyPmj9RC31o4sjpmtyOuaG3LFS72sNKOUEuKyXn8Q+6d/eRMmysKsKzOwu22d9C2eoTF
         gb/Gf2SLZHm6qDBfXWQREZnDjZzPPHhImaxUPSTSxUH36EsPpokPA1OIaPpvAYgw2s3J
         29IYB12CuB4Wg5m17edl2v0CVQUlavUkJ/apVpR0nKIjt/b20cbjipFFz+06LttdBx65
         j8pg==
X-Gm-Message-State: AOJu0YynRT3gj14A2ivhJeBIknxiqQzd9JLJWBuq8hPHQ+3hccmBMOx3
	bTTNz/UG93gO09m+DfzN265W+Q8dzl6nLHETcnmL7VMhu5oZ2X907Lt8
X-Gm-Gg: Acq92OGH7oLio40tiAS3u+LDUINh4xEdmpi7RMFOK7EmOWiir4GNubP9StLhJwI1U96
	6AuiirbfsWYmSi+Wbnm4l3DzUJWVQxMkg9BCWdScj8QW5xacXA8EtT9Hmd3OPIxLNpQQM1Ecfvf
	31pdTk2ZboTaClfmn5GeBf6XygauWWIyEYwsQ+YDsADJdQLd2JIyjAg6TsEIm+po7N7oZCNeiOU
	BXpwpUJ8eFsLaA0NMJvDpqZcCaJ71DsAbeoQf3tWWlmkmcOrt7U9jqcYa8RQ9fXY3PxgxHBQIZT
	Lusmspw60vXbyMKNI0z/d49pVqpGpw9Sh/3nhgf7hq338ck4luxemERPsi6kkQojsF4Df/REwM0
	FjqmwwQE6E5NnPUDtP5StEc4Khmg7aP5J/R2h+60HmkyZQsM8+4RFH+CofA4rtpImLBc4gXdPU9
	v8Hv4m21MSUcwhLotReMPLSyZ5F1TToF2YwKaM8FYQQQ==
X-Received: by 2002:a05:7300:3b05:b0:304:df0e:9dba with SMTP id 5a478bee46e88-3074fc8ad5emr410149eec.31.1780441705132;
        Tue, 02 Jun 2026 16:08:25 -0700 (PDT)
Received: from linuxbox ([2600:8801:81:fa00::8f23])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db85f60sm1168068eec.8.2026.06.02.16.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 16:08:24 -0700 (PDT)
From: Richard Gieg <richgieg@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Richard Gieg <richgieg@gmail.com>
Subject: [PATCH] mm: fix "accessibly" typo in GFP_USER comment
Date: Tue,  2 Jun 2026 16:07:53 -0700
Message-ID: <20260602230753.174715-1-richgieg@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7F8401C000E
X-Rspam-User: 
X-Stat-Signature: ssqfsfq3yoat38pqrrqtc56dw7955tdp
X-Rspamd-Server: rspam09
X-HE-Tag: 1780441706-787980
X-HE-Meta: U2FsdGVkX18sI85jF8OV6R26uzQahOcuztxAQjzj8Yd9ZgDLJGArisrWL15IBzghi3MgAMdxTBzPT1BErxVTA/VC7IlrirQqcv+Upoga0kSaPIOqiexYJx2d6s2ex9NodtlZqk9E2rho3LhiyjtbWsBdJzNPWAxquLTdmoQ6uX6REhQlkHKwnCu+BAX/8L8Q2FuynGy7PSpiGb5TypkTbxz7s/IxdefzBaZfDLaIwywyMal/XMVL/kfYBcipI2X9CLfdrOs//+kuI+BLdLwmtwwaSwaZdaheyrEqvsquZCCVEX10UYrXxkTkrT8CkcmX3JbpgitPNLQLTnX/k2MzfTyw8Q1eUhMe5yg+jsN8haIWoIkHiTE9thOLF8RZ3IPGaO79B3+a9CnrTqE+uTkFy30ZrsFqEAt8/JLVnrGhgAeitW63NuzpmFGBcyiXIOIMxP9ap1SDRsnuxCKCQSFroVDp1iAfJFU6wINrEM4nQGRuj02snAmVG+/J6SgMdukoqG1RPeQYHVM5vgAr2ogJBsg1qIq1BuF48WvZMrDqA6b5o8KcciRAP3M8WPB4Tyr3KIeF3BXeUChzv9Awf8N02s0COQ7kccbiI5l7SjAlxZ+CmM7S9DZzJHJ/wDhqKVtokOgVWDb/WzOs8DxuEYIqGkDJcGWsfH4uUZHV1ndPVB87pcIDSnvKpzJ3I3mtEdvtxnxJKmNFtXqdUHvPqxfk1vbnO6sb2uYDQY5GFxWECdrYgFOle9QD2mEDn6nF08PvUKVVG0cD0aikxgs8XgnXEAxAQhJ16KDKEiPqVvLBgLD7xO97DpQUI9LQ92QVKFW9BxZ4sPYpsYaBgNFTF6DeMP5v2ObI7LQv8UXtOiPeIuYlhYsM09qPSXb+Wb5G2nw46qA+FTQPpnI/ig65GtfXg3tKAPoFxvtHrpWRqL3ASBw8dfiE+GApFXzBgfojxdpLQXgMnVnDYo5FjsAHvgg
 zwqQj9h1
 cKLoqNfvCmSO9bu4+aLYSi6licMPZdHmdFnRZux0rCUxLvk8I0BBV235bmKa+aQaSlGrGQJQdDxcR6hzfZ9vKDfUbR+8wkBPDuDgYviReci/UlAKc63v3w76lb8Qem6IAcWu/CkQL6mtJiIekjG9QuavsIDhQXAqDDaiNnQ82Rp22FQ2L6JsTvzp6UR7PYvBAmnENcncJ4AMZErFn3JP4i+eUzXPUCg9yps20CP1GcYkCR03tkZk1owf5YJmJz4T1mJ9/BHZzZtHSpcT8NYNwStbjZBMyJGvUzI9gPSb3Se8jWbcVcYMdiiV8PYY8YFfg7wrxtATM8UMKqp7+pOqnum08fNXs1WLG6duqItcJoGn1SJfxGsZD6cwj2oVwQLu4dIJwrLLnQgobjkqsdvP43lvlkXe6xtIRPLjiklk2CBvrgNFWaGzaYrU1w7KB0+tTAlSJhQ6NqAnxmhmiUSK1j8/XcYpLJE92IChNxppqVuMMje0E5ym8xNR7SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix typo in GFP_USER kernel-doc comment.
Replace "accessibly" with "accessible".

Signed-off-by: Richard Gieg <richgieg@gmail.com>
---
 include/linux/gfp_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index cd4972a7c97c..d245a6b8b45e 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -341,7 +341,7 @@ enum {
  * requests will inherit GFP_NOFS implicitly.
  *
  * %GFP_USER is for userspace allocations that also need to be directly
- * accessibly by the kernel or hardware. It is typically used by hardware
+ * accessible by the kernel or hardware. It is typically used by hardware
  * for buffers that are mapped to userspace (e.g. graphics) that hardware
  * still must DMA to. cpuset limits are enforced for these allocations.
  *
-- 
2.52.0


