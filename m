Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05119C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 10:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85EF6B0125; Tue,  1 Sep 2026 06:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36B36B0126; Tue,  1 Sep 2026 06:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26DA6B0127; Tue,  1 Sep 2026 06:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98F7E6B0125
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:59:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 042AD1403AA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:59:28 +0000 (UTC)
X-FDA: 85164897258.19.3A0D3EF
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 49EC2100007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:59:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TwQ1vxUU;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788260367;
	b=Za3QKsQUaIpMU4785F72/yQWx759Fq4xMk4QGxgn9HHl84mAuxOo+exioegn4CON3znxm5
	njE0S+jrDwxW5Bs1/Mpzy0tTB0Yx8m9gz7OiQoaTsSqV9NZ7hm1S/y9geAY/cyztV2Hqdk
	GV7lgF33MGtgGk9VCvtftNHIaBRf104=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TwQ1vxUU;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788260367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cX7EjhloMvh87ibhYzHTwR5IMqnRMYO6qnjKtDs5XDY=;
	b=zLpPH2tQrtDd8UwHwCx8qWwTlqMQOdcKalosinOvAl971C4ggN3Clg6TazsMmOAVcir98w
	FaYl47jwvXaUU4LqqmmUu3uCOr3iA5E2BQVeMDSWKM0id+nr3nOQBMjc1u7gG+7s3BuZJ+
	FMicWk+74YHX+6LWAoIyqXPj+aneohU=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ceab75934dso54471565ad.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 03:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788260366; x=1788865166; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cX7EjhloMvh87ibhYzHTwR5IMqnRMYO6qnjKtDs5XDY=;
        b=TwQ1vxUU6NsENmb9Dy2epQfuH889Wy1cqb9CmxFTBLosc8RfPrTWBHDLNDQW4zOjEl
         iYJVb6+0JZ6BQxLV/aLzhAcB2L8hCR8krgUtofCuXLCc65LMx0ev5FnxrduSUS52F5yW
         2KxDcaNs8vJhoV9YZKCoOoBQIhwquy2HEBG2nc+mW+4Xk4Vy5nBZ5Hy2GKR++H8WkP44
         fAJMeX9yteraw0m6ej5HH/1fCeHBRKSnJIJK/x332IBf6JArd1LzV39i+B3O58mLfyL7
         SgA1LxzaxldPU7GSXbMKDlCYz6cPIBkCkX1uHNhZ0WeMQy7huhAP8GaL6rPfccbrrCby
         KIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788260366; x=1788865166;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cX7EjhloMvh87ibhYzHTwR5IMqnRMYO6qnjKtDs5XDY=;
        b=bNWGHQTTQySpadAyXc8SfsNActzz2xo3L1nI7k1pXim0LTwqO8Wvc1vXIgYuRwsnO8
         Ik1Kxe6dIATQuMQm5SP2XKq47OqUa8nweXwv2hKO7Zzv+T9LJQbbAfW7jkCr2ZRfSA84
         UN0UgnzZMt9FflyhpMNVmKmpKws4ErfgErqL+qvRHxS9OnJvJLrEo2+cu5XAO+5H6C5i
         Pon2AWW7Upm4KY4jft60nbIhdX2TVizqOuev1twOK+SO7G1GjwU762QY0tJa8OFJN5LO
         ApN7DNufg3dQB4Lvl53llfl3FJGvdnZRvfSN3h/6MQRC9NTGAvFjIT6gF9eIhcuPN9Kr
         TgIw==
X-Forwarded-Encrypted: i=1; AKwUvBx3oCPFzw/u0eO1T6oVv5YBO5UKU+QHVF7hLdnyF684eJIZnOPK/hb4AX0rEQ8Y3FNmwdTyZPA4Aw==@kvack.org
X-Gm-Message-State: AFuF++nmQUHAMv71ij46oQ3x1kb9+RcPYEtumGHEq0XVYlzmlg9jeeH2
	BAi5LETWv+d82O9RiHy+gg1JcKWLK07bjUVmDkEPCBx6jMLwAVXluSfW
X-Gm-Gg: AYBFou1PsDPVwPfy0wuTIMa+qlLyEypLQMy6xK4daajazyRZtO4IxRuKQ8kiwu0nSqT
	nFmv6M3IkeKP8abFF3MPXROA54tzM55Zv18elFUBPddN3O2vdUfs8JithNeotWmVPu9HsskyL4E
	o1TAJ9mLNyVHmWrRK++B2SBMaArMnEjKJFN7YWFAZNQQ1yjk+q/pdSD8kZwiiu9Q11TJN3s6YkX
	ufUizsIk3mjXUctAcn72o3gBJfwmfup58DPyWF4h2yT7jStj9HDRrYFa2i25eUbZ0pYZORLQQfH
	jtoRekeorFRLDrL+yaebkQRqHUsykVEiN1obT8u8Xf1nIA7FbUal0NDUq6xZHmQI1+4Hnl/lHGY
	TOlPy93qpcvjWkalmzdSGx1+RV8csyAUrYImo6v/y362exSTk9MCyUKM8owM4I/q6wmsIuLPgIq
	MraE9luNV99Oq9kiRsC0wd2QdtbHx1tH0khdRHic7JThHqe/CKBG0vQjtgpNuILGezrxh9tLyvx
	isU
X-Received: by 2002:a17:903:458b:b0:2d9:51bd:534f with SMTP id d9443c01a7336-2d951bd58e9mr63941605ad.10.1788260366011;
        Tue, 01 Sep 2026 03:59:26 -0700 (PDT)
Received: from celestia ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d9458299aasm20706695ad.43.2026.09.01.03.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 03:59:25 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/damon/core: always return false when esz is zero
Date: Tue,  1 Sep 2026 18:59:25 +0800
Message-ID: <20260901105925.106186-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 49EC2100007
X-Stat-Signature: f9pwcfcqf5trejfi4j4o6z81tgmwn9f3
X-HE-Tag: 1788260367-235815
X-HE-Meta: U2FsdGVkX19cTMnWr0fcD0xHefZuQRGQOGqhIgqNF2FGd7KsgYtBdipyopI8W/DwArY86VSCsN4zhVDaCfyo13m+/fTvtuUyAiUHCaohBdRhgxviAaAQCzLhducHL7rfTvkQBmBOLDrTdAcNb4RiW854Uq05yHOzM/sUhnqZt5G06qwlgco/6oEpo7cQIDwPs6yvXnCd+5mtapBWaYYVFyrwpGc1+v8oJdW4YrRYj7+vkFrY7+kDJy2nlyGpO47HHcgmjzs0CN5Jbgr/YO//lnPDtO7LQtnZEQtF+8cJW36UetZ4mmdFQz7e2zTJGxhBLSuk0/bPaT8BnJ5bgcG0u98cKe5wJPExaCudrpwtauh+CUNlSBeQ3MweV7uOL6qe/Z3dvVFZKoNihsvAOb4jKF3qVVVRotZQ0n7J2LKKxFO958vCvXpDiEctW15KvlrnARncy2w+jYz9C5uIqfKbotDHHx3J1H9f6R0ihdLW7JL/Z0v7rIfxZub18KuJKAbQHOHaUpZIEdfO7uNsoPQZWwWXAQPjczfMjsLycWws9XP1BCaoGQccE/iyK+3tgAGEb0baV/uX+Bp9SgkgpMhuZs+eubrs7Z2jR0QBCpDaCpA1O/1ZB0k5mEUcCGpCF7VxO/KiVzowMD7LrNJKdfXLNgd+PwHHo5mPRmSbhLgtcTZoJVqF17zsBkoqr17w/U5SH+XoNNK5JvvTxXmVTWsVXuMKWNLqSiMxeF4mnajR+Y3WZqnjUvUr/cLOPi9oyhzsgNIP8CNWCDJDqsLkqQGsFZLTWC8vDwQS+mcpFD7oBWP2LzrlNBCcSHmdCgF3MLJ+P3Fb7CD8B4vITjFmhg7VrB04c45dDTxgG0nZ8TUnhUw5acMt1iYCNg1cI7eqwlc+ChXK1gUV5FSi65dlHuXsNTN44IDzolgNV+KnBsBDyD4Ajoaw7QP+7saNzueXCChYUDVCpNoLI44RfrGnYhb
 x7QBOhAU
 u7kuxEeJOUDieaxrYy064zGSF7O7LzxKEhzBzxgXjyoOK+Fereg0CteU0iaUyk5Uw8o8eaYZm3w7fjwzwBizk0cyGRKgICGV02ihzPVcPiGBgdhJGCaG2+VGcII8iURzd3b1qYkmPq4HIe+z+YVB+6egBbv97qs8EcpUX5RslAv/9Lq5XiN1Tz8cZRz7W46NvCI056O06KV/ceRKrjBw+DQJVQYQYR/G+oaVbg2Rg4TAY23nHTXD00ZQo73GlE24pxvlrzCU8T8jW/LZYSq7uFSPgCeLb+B81ML3AYgYv8E9VLzOHL73rUla0bpnD8WPv7N1j4qHaVjQ/Dio0WcvnHhUBc82+1i3aLQgK7kVksy+wJECR67Y1YWDu79d+833KxZi+Rx3TB4r+B+MgrX8sy1+IdyGDlaaIe9E2eLxWAlBovLDWls8iGMgAlHwJs1EjO6Nm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After setting goal_tuner to 'temporal', if the goal is achieved,
quota->esz will be set to zero.  In this case, damos_quota_is_full()
will always return true, even if no regions have been tried at all.
This causes qt_exceeds to increase unexpectedly.

Fix it by always returning false when quota->esz is zero.

Fixes: c7ec7d5f6b3d ("mm/damon/core: handle <min_region_sz remaining quota as empty")
Cc: <stable@vger.kernel.org> # v7.2.x
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 644daf5a1656..53cf32f1d515 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2560,6 +2560,8 @@ static bool damos_quota_is_full(struct damos_quota *quota,
 {
 	if (!damos_quota_is_set(quota))
 		return false;
+	if (!quota->esz)
+		return false;
 	if (quota->charged_sz >= quota->esz)
 		return true;
 	/*
-- 
2.55.0


