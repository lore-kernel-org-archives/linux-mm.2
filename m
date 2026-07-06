Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F0FC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 16:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8226B00A0; Mon,  6 Jul 2026 12:38:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37EFD6B00A1; Mon,  6 Jul 2026 12:38:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2956C6B00A2; Mon,  6 Jul 2026 12:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E32186B00A0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:38:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DE6C1C1078
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:38:56 +0000 (UTC)
X-FDA: 84958911072.25.3233CBE
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8F0F3160012
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:38:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RJD0iMfG;
	spf=pass (imf08.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783355934;
	b=gRNspve7zOLhaMcaMHhDmK1gGYUmlpud2/r2jg9M50TubHFL0CDmzesk2aJlPYlW/xqQF9
	2mrV411tk5xmrq+Dcthq9qQgZAMQKd/Io6Wj7Icj5+OJZLnSG7Yq8nhjqH5CwCKjz6H/RU
	UJmOk97odMF7SKsPlsl5bhllkvQiNOo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RJD0iMfG;
	spf=pass (imf08.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783355934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtnXNaxn+fspW0Xw1nKXB6TGSGdVBv01OAGdj8wNpN0=;
	b=gsDRufLwf1BmYc92em5MsHfIFOnFveGgVzfHM/9T7hzgglMZh7cbD1jm05rXq9p9+Ik8J0
	9y03uzLLxB9ZJfFCIvpoOW8QU64u9UJdEEoBEqd24X/yy6W1ISPLPUGNJ57JWpSVKktYso
	GpVvrw7iPqQKBKO0aZXHmLywGIj/6s0=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2caea3f742bso44522755ad.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 09:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783355933; x=1783960733; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VtnXNaxn+fspW0Xw1nKXB6TGSGdVBv01OAGdj8wNpN0=;
        b=RJD0iMfGOaBuloGgN47iyyCv3LD4VMfS0zACCyVHRbOzcPSCD4y1sXa4mWen9/SYFU
         lMR2NTKmoNn7c02GmbTf5ulD+m6BHhQWs/idqerl4X+tlnulBHvsmavX2DyyYvPneW9x
         1cVSUxSWSezfYLWXKaQJZuref3uX182tBaU81dL8y9fXLSkEmRndKp0rkPhR0UQh2Zc+
         +ZaBXpQh+lqYZBkNemz4LYQ/ywomPOAZiPZDq5CILMBU6QR3XF8VlWbCHlkh9qNN7G6J
         nO5vioY7KgfZyeNbIjGDZL7BWMz+hrfrbqkgVQln/9+bhv/adhur0nv4jehQKYRWgSlK
         INiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783355933; x=1783960733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VtnXNaxn+fspW0Xw1nKXB6TGSGdVBv01OAGdj8wNpN0=;
        b=TgTBRNvV7DhBbJvwizSbWxOl0grLK8M8dCZlflKLDhnA9O2JCZvGnMl7aau8gGpP8b
         qq2EYqXSkCrl9JnsKnxOsv1kRAaosHUWhux9QhuJOlTLSwyZZ2XYQ164QhZbUlXT5hnp
         Qa3vHuJmlCMSIkqSa8lNGZ4MrvBj8ah3sFzyIA1owvex4DI3AIvt8D1//MBYmqIqOsId
         ZqNMcSz8mx0lgmdpmr6rAn2/eU35VU3qBJQs6P1xb6dauFaDON9iD4XwC7oxGGNgFFew
         AYJfjXD2yjjxFOr0aScLnfu8Rqi3n2BxOkJUBc61deG2sw8tRsF9Ur8oK7NnEdx+m+P5
         /5iw==
X-Gm-Message-State: AOJu0YxpC8h3RwwPlnsfl0CSeJ5Lc/ReJxn1q1d+yWTg6bSoW+VczrdM
	Qrh4BOTgEMtjheLXEMfCnNvYEvjfrsFItfFNBTS1EV6psILb8m7ViAv0
X-Gm-Gg: AfdE7cl0KPOSkyWCtXYfkRjytPMRlwgSi9QP9Mf9+Li/280mboXzqkOEBbEvFL6QXZ3
	zG7vj2e0KJqby+agRyf7TG1CVw8eyNBSUsKBH6gnS6EDJta80VBlNtJ9DcbPyh8MsCvVkEl1hMP
	eWA9EPlxSkryQ4qeQ/jhjkdT7BBrlBgaILWmUKyau026u8b7BYs/bS2X9GmoH03D3cTL2oWdEb9
	czYwFvEZTxDQYxZL0QiQQcBQfL+W+c0G2Fs1DbPOAdst0JFhTf4U4Ap/n4IW36ow5LeMx/RKzDv
	1bKcZc3/YWyKVwEcGY4Wutuqca+Ux933AeDWQ+HBxcl5gotoSo4r9xgKsHOn6/ll5VHKViPjMsS
	1YM3dp4mK/pqLBNavb5jWhKAqNpj9qFh7X8WRBOb7eiq8TLhHifNZPqj0tpe8cdViGI5Od6vU+W
	Ffyku3M3A=
X-Received: by 2002:a17:902:d486:b0:2c7:fae7:8af with SMTP id d9443c01a7336-2ccbf0105bdmr14950715ad.24.1783355933532;
        Mon, 06 Jul 2026 09:38:53 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad7893a8dsm53103305ad.73.2026.07.06.09.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 09:38:53 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH v2 2/5] sh: remove unreachable memblock_reserve() return value check
Date: Tue,  7 Jul 2026 01:37:50 +0900
Message-ID: <20260706163753.193875-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260706163753.193875-1-ekffu200098@gmail.com>
References: <20260706163753.193875-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F0F3160012
X-Stat-Signature: ab9shn7s14g9s7841wcoi55dqtcxqnz6
X-HE-Tag: 1783355934-486554
X-HE-Meta: U2FsdGVkX1+7qj/MtxvDM5+c5LZ/s4kqH/cp/BIid8aCQKmvg0WMVgrh/wdLO2Z5NmtA9n/zrayJBoFuE0mlW7JkAzfwaoqcZXsHDCl7Mg3KRW+r8o2U2uhwC64fKWgylf03lKC5HIIyru7jpo27aPm9tLQp36W3DpEJE0LA+1HwySZ94v0fJYYlQIEw88vWUKLWfmNgqcz9IDnaT1mWqCAqgFRUXUghux3b2NEcrUegmfDHLcSKoHBcKCaT6dM4wjgiUmdR6m4DNZjm7h9KcQQtL5sKvXqqsiHXCkStftdh3Hsk4uoOzyD4yhXTMquxjeVHfLgWwf4LF47Q6GhNblhF/ZFLcp7LNkIOi7x6vaOsjxqgbEH0W1CP9hEJgZiTKEyLIoU3yIHdkGM8oNbD+KX4CbtaovY1xd5zhS5nEQlfRpqmruYOkHOYFEe4lZO5ySmYX2NmZV1nae8fJan3xmU22pYHSF1R56y87BfjbDaREvBgHa0JhmBH2PePsJsUNHb7tRH0Z4yErn7+f3JLTZouwjB10Y3Nt3KjTTdseBCEAgKdk6v+X+DHtdSaZxcIWZAyVj1p6WdvT+2pb541qhwpISwE0nT9nB+1Y1WxVPu09S0aez9bJsG99D/u9nMxbZDnNMgw1PD5Uaw8MA3Wzs7xpNpqLXvvwOWHqYF5es+afSDhj66vaoeTqs7XUahyxpAKdh1ohSXlPExhABU/pvT6Xj2vZKPVfbdPWpBZmpB3O5hOJr5K/mHYJF5KqQGMo8EVBSHeBTEat+MdDTMOVIc1fGUIJatNXg+x3bn5abYZAtZKls2SsXYBc2Zrl0hQUCQFWioT18MkHJEG/NuXue7vmDcsODyYDZJi2fWHfB+ayL1C782RLiZewcfuX09kOaGyuHzf1A6Fgq3HO7Edloph6PHjmNrqrGcv4xcqykXzbgEF2W8NQkddeYrBfBmIeY/jWULzDuY8E4vXsRo
 NX2x8xZE
 s+BOr+O5+4k+08wu9C9nNAtOkO7VUFueB+s262g7XjOu/rRZMWjWXrJUb23maOLu4ABc15fvqg5wOmRDW8fkOYgnsiMQhp4Z9DH9d8FPpsxe7hOOw5Kl1L0w/757yWRKIwz5TKfz03dQq1n70ygZKVJLrsj6o3qwZYAnRVG9c2YOJvfit/ew2ClFIWsdR7UNw9JIZOdvx+9x8NkIrJHtwCYSH6LAtzUJqCVeG4gobSr9zj+33C0n4NDgj6HR6CVzDkyKCE1LjnkLQ0uRxoKe7WGrFlKSHZ37l3zDWTIrr0uUQstsjtKNdFftPHFcXM4M9mfYXyiGsx2/WNq0SiTKvkXM/d60FY+cxm8g16OMhGyE7RAaUzzLqgp2fXNjD9f5thOXE+GyETF7c9H0up9G+8/xHMaMSRtfhyiFRaaKYANbnYnLWILQySMcneVTFj3U8o7WH1tSvQPoRf/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

reserve_crashkernel() runs from early_reserve_mem() in paging_init(),
before the same function calls memblock_allow_resize(). At that point
memblock_reserve() either succeeds or panics, never returning an error.

Therefore the return value check is unreachable, so remove it and the
related logic.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 arch/sh/kernel/machine_kexec.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/sh/kernel/machine_kexec.c b/arch/sh/kernel/machine_kexec.c
index 37073ca1e0ad..ba9c412f14d9 100644
--- a/arch/sh/kernel/machine_kexec.c
+++ b/arch/sh/kernel/machine_kexec.c
@@ -165,12 +165,7 @@ void __init reserve_crashkernel(void)
 			goto disable;
 		}
 	} else {
-		ret = memblock_reserve(crashk_res.start, crash_size);
-		if (unlikely(ret < 0)) {
-			pr_err("crashkernel reservation failed - "
-			       "memory is in use\n");
-			goto disable;
-		}
+		memblock_reserve(crashk_res.start, crash_size);
 	}
 
 	crashk_res.end = crashk_res.start + crash_size - 1;
-- 
2.43.0


