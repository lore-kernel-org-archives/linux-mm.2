Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 973FEC79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D89586B0093; Thu, 10 Sep 2026 13:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3ACE6B0095; Thu, 10 Sep 2026 13:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50B46B0096; Thu, 10 Sep 2026 13:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB0E6B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:16:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 046C51A058E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:34 +0000 (UTC)
X-FDA: 85198506750.20.F4E6D77
Received: from mail-yx2-f10.google.com (mail-yx2-f10.google.com [74.125.224.138])
	by imf18.hostedemail.com (Postfix) with ESMTP id 390D21C0003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="iRgRlY/f";
	spf=pass (imf18.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.138 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789060593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQvOpBVSB7EFzma+xoAdOHr/Eyr0ApRMjSY0dpxZAoA=;
	b=hnW9LYyKrC5FGay2XQ5mmKCWwNzR8ZCidNEojMujjpQMSCtUOzI0tiV3eD/mg8E+LnM6fR
	x48UHBdK3JEg2MNnH7gZ58eGeSabB/RyaU08h6Vl4G99Na9w490jrFTG4uAgq0yctnhheG
	EvwOJuh/iMvbKgvmLmx3XQf4QglYxIg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789060593;
	b=ZgtpFM3HOGjOKGfLcXbO6SGg6kmY79VeLQZriK1VO1Rzr7gBr1WKL2XmE6U7BYgUhWYqWa
	Y14bAi5mJlEp/cLMNaUR1WHh5egbTc5US/uHJ2A+5cyeeVL0VHlv6krbl6mv64MeZdidEc
	N7CxSt0EEqjqTH2i4nMN7vZ2vcziAVs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="iRgRlY/f";
	spf=pass (imf18.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.138 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx2-f10.google.com with SMTP id 956f58d0204a3-66c711552cbso2234034d50.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789060592; x=1789665392; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yQvOpBVSB7EFzma+xoAdOHr/Eyr0ApRMjSY0dpxZAoA=;
        b=iRgRlY/f06jfFsb5l64W8cZ19Z/CSqFJK/2xJ4YPETlalN3vySzhU+BL/PLjXK/rNj
         YnOQmCEizWo0jKlGmOBZ/sknzqGNi9gw+PVpqAW9FDMBBH9H5DEUajdq/OL3LUBoDsn3
         dDMOK2A3XYiZ/eJ4zoD82f5QSdgIPsgY9uaAEOP88wZ152upeJLy9gUHcIMVF5w753Q5
         QIdGI71gbHQyC22zRlNUIhSWMTEoq5fovDy2grKpFC+z2bnkc69tWczKWl66mOsm/JP7
         vWSJEC8QfGYvHXDrdTXtb5XzTwsaCT1cXVuRxcv5Q/S58Scuj0y+4hHwswCZckCBzWZS
         aCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789060592; x=1789665392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yQvOpBVSB7EFzma+xoAdOHr/Eyr0ApRMjSY0dpxZAoA=;
        b=UF+ZPfOhTuHXIzMCaUdwjLd9rvUZJ41iatv2oqEHpP+TdeHsWer9RmOzGRuy37ep/V
         XMaW0jeCe6oYQ6kxj0oLUOgw69+y0I5m9cztX1Ret8LX9IvQCzO/VOiA/Cr5F2Zqic9L
         JM/+LovZ63Fmw7IkwHqKRP6QjTzJUawf9S7cH0d7wvsmTwKv55sX2W46rqdDzgfcq++x
         rMgXKAiGd0hjfefHKwkzWK40jeROgUamOmB/Js11hX0t1yvD3EBIqJV6idT2xex4e2PY
         pmfUX74vs0T9ZQ5yE8N5Z/eDOpW81OVn4WcQke5IE+qPG4lP27lVGUkQ6Ol3fbuiHuiZ
         drHQ==
X-Forwarded-Encrypted: i=1; AKwUvBxDRXZ4OlgqVDnOib+IoZywg7B8rpZE2cY+cNm4fAu0rsMqI3m5SCs6mihwm6rtaoLtVjs5UjXBpA==@kvack.org
X-Gm-Message-State: AFuF++na6wmyrclH8N6QGGOSiwvoLgt791TY0KnXQEhGglgs6IIxbO+B
	QGJ31+dBrqLuLKL6hPD0iDzmRMmyWV5AJ5DkdZCnOaSsl7Mwkb2XmwQ=
X-Gm-Gg: AYBFou0fiaWNVQOexqG5wZ44T7FeMzp2eJwUkEpvz09TmgggPEgZVSFn9HbOnK16Glc
	+GvaTS2MJVGm6OIOPCSyWGLQ4BR60Dq4tNs5DsEbOa+7cA2cPOJgV3jDNpXRHZk2Up+0yjePMiB
	qXIWpc/hfDuqpBA2skER2Gwdlzy6JpBvZUb+nX4B2DcqNoFHqjjtMCq59ANbwv7ZQG8Gp/blsy1
	juz6Bj98rEUZXYGrQUZiOpeDaRJg7VJ1gKGu5NJqdJ8ffIXZP6UxcBOBg+dnJgdWE6p73Q5VvJT
	KuT+NSzr/BLaZqHE22IqqWWHEBUiBfLTh72GKzMw9DCrTWoAT1UGrqoyWGqVwcet3jo71P2XoPa
	ZviHZIQqywGgFT6VxFM3dY7oONhL33tSRKLLUdrGkwYzL/N3tbKaNDnhQ6u/S6M9IGlyJIBOzCY
	jg9bwsF1KJWYTvWd3pTDF4SxFACA2CLbSCq0ka2prE5JGBgMXab1mF1nwby4tOLNKPF+QM+adoT
	tY/4ZjEd4/V5R+gypPUsdbyLAMGAohnhQ7ARTWc9jSiWdKrYA==
X-Received: by 2002:a05:690c:e289:20b0:858:41d4:c28 with SMTP id 00721157ae682-884afc19817mr1025287b3.8.1789060592200;
        Thu, 10 Sep 2026 10:16:32 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8848608617fsm2387337b3.9.2026.09.10.10.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 10:16:31 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com,
	rientjes@google.com,
	weixugc@google.com,
	jic23@kernel.org,
	gourry@gourry.net
Subject: [RFC PATCH v2 2/9] mm/damon/core: read the CPU number with preemption disabled
Date: Thu, 10 Sep 2026 10:16:16 -0700
Message-ID: <20260910171623.6638-3-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910171623.6638-1-ravis.opensrc@gmail.com>
References: <20260910171623.6638-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 390D21C0003
X-Stat-Signature: artzghan46m9uufgzsapknybymh1zbqd
X-Rspam-User: 
X-HE-Tag: 1789060593-386057
X-HE-Meta: U2FsdGVkX18cVMKqxE6JEDs3msmlWqZ0eH8bCg7fZaytkcYB5jAKFrxjwC8bxpPcmoGbjpDJlgrZ4IDV+LBv5wj7SmG3RIYLJKTj9KhBPrxR2i+v9++xfdeLvSPkIrrpxqe9o/8pK1l0GxvRi+yj6i84Y4WMEsRbij1kx/Ny2yqjutqnkLwdvprK+i88/baXIkkKUB9L3wiIGtAhiynEhXa93MzmmSgClYXzoVajlGc2MGUe9ggi9BPfUiVajm2DthV0G1K35WlCR88BG7uEbQDKvWP6v4EvKiTDOB4WXDHfWdWckS5xhkAFePtwlAJ6byTdOXUIbsZWGv94Ffubd7f1byP4y/UqH4X3xYFVovqTDd6QIu460XiRz1dAUoPjeBjKMPd/Bd5R1G2+XvY3EtWvnkt2ayC5H/4b0f/inHxrfDlVCuNVLG1JVM5VPWjUh8mm8ODi69bS8uuJBtmSSauNJVQegWuTOYwoxv655BDEtRV55ZXIAOV5ySS9DV3FFUL5CLs1RYdrre22LctN7ANR9oE9CNGM0K7jSBaWUskotuN7jCqVuDZ29DjDG4R2l16aEYfzIsOppiF8sr6QVm59IQnV/buTXuJdTt98FWUjus2diQZORZ1fB3/0ElA/Zl+bl4yBOndUS23BkVrmIX6d1B0W3RPVKfQYs13LnxFrPewU1lsDyVetx0+rBxhNjP6uN8D7smgGnv8KLi6VW9e7E0C6Yn4Z8RA1fOVmi1a0//rAA5ViJNZKNvW0QwETvOtrSKLCHlqMXHK9m6uF1e3Oijg0ztDqD7aF9rPG12CrvoxV9mY9gw0NkuW6HZH+MTPWYUMOYQ3SUOiKacpomsfs9WPsWFwFiO1SUjFrpsrq7QBD2T0LgzX8CxNL5SUtKJta9hwqhTZCg12eiZxt9sfxf6Q9Y/IH2WVU0bNOmOvJCngnmmh1iImAWS6CRDWeQoEAL0yB9iwlsJ4n2V2
 szqyL089
 //LEM9uZc0D4Rb4URW6sc5LlUDJBRmGOcJQ8OP+GqvX+3OKLjc88bFZST6RFApAMEEnZb4IvaaJAw6Z0GLToRyAHzdISMBaR4JyrW/5n30gdIxgeOjNiG12s3CvW4JsrrHI3DtMPrBKNTHMY+NjoXL3csVw8qmx2yEwed01TvpW3d0enIBYH35EcP+zRh2ro3zk17yBumnezDYFVeFPDMTcR/lfxtoicms4E1KF4R35KBV8WBshDWro4uOS7CKqgFHJYjnxRQjOcynYFWeEGImbXEWZyB/PPha4TFYbI29uELNPiQUjjzD50NbaN3Y5Mx+IFRuDt5nbnnbmPYqimLS0HbxQBmYIJVJaDyPtqFAluWXNVGx886rrG1sY5NgsorGcq68dB9AJ1nF/7DqFLrGHJETVm5yyqAQ5Ufkq4m6IF98+4bFgbZ9RbmyPMPydXJoTcoYQrsWnZD6rmEZIOZgyFH91pfnOuWlGtnUfIV5axukycpi/o2OJL7/hhdlF6KACDn+EBEmZo74enEipDa2eJd6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_report_page_fault() runs in fault context, which is preemptible, so
reading the CPU number there triggers a "using smp_processor_id() in
preemptible" report.

Read it with preemption disabled, and keep it disabled across the report
so the recorded CPU stays consistent with the per-CPU ring the report is
queued to, which is selected the same way.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5fdb5922edb78..991ddb9a09414 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2514,7 +2514,6 @@ void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
 	struct damon_access_report access_report = {
 		.vaddr = vmf->address,
 		.size = 1,	/* todo: set appripriately */
-		.cpu = smp_processor_id(),
 		.tid = task_pid_vnr(current),
 		.is_write = vmf->flags & FAULT_FLAG_WRITE,
 	};
@@ -2524,7 +2523,15 @@ void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
 	else
 		access_report.paddr = PFN_PHYS(pte_pfn(vmf->orig_pte));
 
+	/*
+	 * This runs in fault context, which is preemptible, so the CPU number
+	 * is read with preemption disabled.  Holding it across the report also
+	 * keeps the recorded CPU consistent with the per-CPU ring the report is
+	 * queued to, which damon_report_access() selects the same way.
+	 */
+	access_report.cpu = get_cpu();
 	damon_report_access(&access_report);
+	put_cpu();
 }
 #endif
 
-- 
2.43.0


