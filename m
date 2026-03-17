Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC024FB5EA5
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 02:51:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767236B008C; Mon, 16 Mar 2026 22:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0306B0092; Mon, 16 Mar 2026 22:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E0AB6B0093; Mon, 16 Mar 2026 22:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DFFD6B008C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:51:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04480160406
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:51:00 +0000 (UTC)
X-FDA: 84554027922.13.2F3C555
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 617DD180007
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:50:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CwaZI9zu;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773715859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjOdhUZ1Sfc2pBNZkzIv/+F2L8hy1jAjYMY22sGDTyM=;
	b=R8GFx9zwH3SIda0BFFQhBFWULJjlusAU1TKzdobUqjNzF1sTZTpjL3ah1rOjONKCU72hHK
	zeIwARPwIGE/1e/WBH+p7T5u2Lz/7UxHCIQt6ObQUEgVEXjUDILI6ljvwslmPShU0yaHKL
	DD9mx3i1Ko9xnfeXOLoWHhu/ewkkivM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773715859; a=rsa-sha256;
	cv=none;
	b=rmHQhZsSWxEqAtT9Mx4lFyIKtnhktw/4TPEZwNPo0mszGNaFUEDzSx7cu0EJMq3j9MXVMI
	k0Z0DBFqlxtQJZAkCol6JSaXs2nOw4EKmp37RtBcMRmAaLr3i5daIMpRrBQ4x/2tqXmha/
	wAh4Ne9kWnXZ7In24QrTsBfhpOrsmbQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CwaZI9zu;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-64ca9ec3ee7so6145229d50.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773715858; x=1774320658; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PjOdhUZ1Sfc2pBNZkzIv/+F2L8hy1jAjYMY22sGDTyM=;
        b=CwaZI9zuv+PY3Rk172O4uHDFqqjmZHpFzmKym4e2flt0dBbVYsv3KZNglnhuCh9yBw
         CapUinrH75nhcYdnBs4W4O+ivx0LGLEUxSDouqAs4Tz2+Kz7IOanaIxbD4w0p+cUIGZW
         kJpvDB2cxDyHM8k3+PY5LDpOPGKjQK8iqHSjUTzV3ptTX0cyRgQ3kEre821UQWcH0nnU
         YW1IuW9121VqrQPztL65jipjs1slQKhXtNYc2Rw0XboLEInhH6SW3R8MHE4TNws+wT7r
         SFSZj71QRw1lGGfNtMVq8OYPMpgCeVHkuOCo7usQvzz/LpV+nUZ9QPNZr1JDvXn63BEo
         8NvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773715858; x=1774320658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PjOdhUZ1Sfc2pBNZkzIv/+F2L8hy1jAjYMY22sGDTyM=;
        b=OG4RR0L8rQcUGHCECZnhXPALJNCt/qkhiDfY0D8cPI5Gf+ucPYanidgUDPIfiDiirA
         mT308vg9TZfbkUYpxbxWvqT9KyWMuIhyXac2p0kJhlfCsk+WSK6XcZ4UwH8fIy9M8FSb
         sQzpzblRJEtYH7mDbPo0iA1iVo+mohVDx1bUok1fc98OUMfWArlZblrwo9ax9tJMKTrb
         l56icC42QsCPTPOCr5NBs0fIklujBpLGOIH6b20A0nST/1B9xbI6Sw2wxTiNZtZXO02L
         qEnGJiROw2/x4jripFcNYm4sBvYKuU4LEPaovp11Ftp4d6FpRKs5JmYn2Ey4Qzsbyvph
         z7sw==
X-Forwarded-Encrypted: i=1; AJvYcCUJZWCpIBIw3P0uXZrcTzJaQgLbpW6NJgpRUsTLPxPOYpyyKOEJu/PSyXUcptqC3AXb3mVTqXIVCg==@kvack.org
X-Gm-Message-State: AOJu0YwSn2IaoKk3VCpjxAVQ+W7CuQ22l0ykg1Dyt+EmkTBlZytZ50An
	QhWiIBKM+oZ7/b8+qhsO1B1jwGfSZYWMazIxDyQrWLYdZZNPZQQlEUGFYEC+d3DSkNw=
X-Gm-Gg: ATEYQzxw1X2XQ3cqiy5sIIDVfk1boaPaPpCbGWBhnFvSsLrjPtZrvY3c4+2KHAi/Ael
	YuaFZpFmpXjkdFrd9JbcKViIbYUau/eJn9zEfr1h/v144113L6Y88oXAN01y64fD4fyPRWSNQ+T
	ffc5/TnZEryyL1V4BiTsE34hBzrpUmMOzXTAEMS70bCVLaCpDe+INQeoLjpP5PQDTlWgZdQiZui
	bXnGVMplcg6qizkMHdlayrx7n/fCw37ffD+cid1jMdIPOMH+wXhr54ZZpCPQdJsFbproIYBqB4p
	Nb0ME0g6VhcsPocF7CxfLKh/yvk1s5o6kcAGvOnZrJf4cU4pLxd2NmTCkomyCGBa+TLuByFiLqu
	lh/kaUNnTJQ5W8u4hjh16v/RX2PcuTsBpcDgJxwUKpc1lUtgSonBn8U5m8QnICY9SCoAGy/7vts
	GTED428zl0gGZYggHKlEraDSB7D5dwsmMy8sna8KeId/aRGpLTTZ9iRvSIT4oq04HmVIG0ThaDZ
	ZvUvCLS9y1KI33yD3Rx6WPhZ/KCZBgMle6JzUOZau5Zocrp6Q==
X-Received: by 2002:a05:690c:660d:b0:79a:51df:6a0a with SMTP id 00721157ae682-79a51dfb37dmr49247187b3.60.1773715858519;
        Mon, 16 Mar 2026 19:50:58 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a5a866c85sm14951757b3.35.2026.03.16.19.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 19:50:57 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	dmatlack@google.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 4/6] liveupdate: Defer FLB module refcounting to active sessions
Date: Mon, 16 Mar 2026 22:50:47 -0400
Message-ID: <20260317025049.494931-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260317025049.494931-1-pasha.tatashin@soleen.com>
References: <20260317025049.494931-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xydt6cdfgeskmzsc1kc3eujf57yzkez6
X-Rspam-User: 
X-Rspamd-Queue-Id: 617DD180007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773715859-771696
X-HE-Meta: U2FsdGVkX19c8o6+Fcek9Ya3no43lar3uLnWmIjtJfB1w/W5nUdxGVAsbO1XWiEM+ISAx/kNb7JPM3lRBWM3jICZkQy0hBqS2lbaJj466XRjnzoK85C4JKh+c0GVmuEIP3zKyAyuvTEHdHKfzDZdvHPSX//NVgshrcJu5kEiIS74S5Ipbo/ChzJNrhEnwWipsp2SmvfNuHfdeFqqYzkxHykQ4iN0bhhAWQSS9UPlcugVA5lRAzfYVRctn/fM1gL7g7aKsqr6tlPQuctygnwUhuSgeWBxCfp/wrtOyWKrrrJ6osFoa6DF5VrcKvWo5UVIiPldrs8RWZ0riT2YsSrA2/r9Z7GK1Mm6XpaimB7W+8TSpRUsta5clKUQhxXz1bC1EH/A/RWQnIOvGsZh341FWJGOjwob558Fx4M0puwHTs8XjNCXT4d00yUakG61o0r7qaZ3yJ/Hm/OA1EedQ8vke8SKCESsyf9xHgpq6bo/iwW92wM9ewRpjd+kWQA020v+mQ407V5SHW6k8AUC0zz166ih9KlRbu/Th7yUR9ivEm3AVk7KXLqYhLYm9xBzqsXlk+BP53lH3Ue4Why/gHmiaAb+dvCQ3e+nV6XasdOXeFDJu+g1wVBBIirYw1ySPM8RGVvDZ73EwjVSJYGMY8iSYVoXw7avLHRaHd8e37IJr0xk7+7JKDkyu0UMQhVulVCgi1mhPO4dVrcMHPPrPTrSu5Uss1mWi1PoclhhvBWMQJ+yZhrXq9T0zYAWVvqZcd2t1lHNzEmrIAR6i6BDnDA+MWrQwGMl7FhNtwY5rYOAf5E1uXFe+As8V3m+VPLKZvA38gBfgHkBDIEJAGcowK10R7yqKal0GTibQS/49+VaHW3QXYbcxfWz7E0PZRKrCWtyto/D6qAW1R+BXg6btD8GaGtLPcMvzWlvG/H7n9UmtMRl4TjaZkho3X0oHRNvDptW8gu+TJEoMjspzX0tFMP
 ItvEPuE+
 5PLKtJnlF9dWL7M/Flw/w4QUpRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop pinning modules indefinitely upon FLB registration.
Instead, dynamically take a module reference when the FLB is actively
used in a session (e.g., during preserve and retrieve) and release it
when the session concludes.

This allows modules providing FLB operations to be cleanly unloaded
when not in active use by the live update orchestrator.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_flb.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 91910d806d1d..daa852abdedd 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -112,10 +112,15 @@ static int luo_flb_file_preserve_one(struct liveupdate_flb *flb)
 			struct liveupdate_flb_op_args args = {0};
 			int err;
 
+			if (!try_module_get(flb->ops->owner))
+				return -ENODEV;
+
 			args.flb = flb;
 			err = flb->ops->preserve(&args);
-			if (err)
+			if (err) {
+				module_put(flb->ops->owner);
 				return err;
+			}
 			private->outgoing.data = args.data;
 			private->outgoing.obj = args.obj;
 		}
@@ -143,6 +148,7 @@ static void luo_flb_file_unpreserve_one(struct liveupdate_flb *flb)
 
 			private->outgoing.data = 0;
 			private->outgoing.obj = NULL;
+			module_put(flb->ops->owner);
 		}
 	}
 }
@@ -178,12 +184,17 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 	if (!found)
 		return -ENOENT;
 
+	if (!try_module_get(flb->ops->owner))
+		return -ENODEV;
+
 	args.flb = flb;
 	args.data = private->incoming.data;
 
 	err = flb->ops->retrieve(&args);
-	if (err)
+	if (err) {
+		module_put(flb->ops->owner);
 		return err;
+	}
 
 	private->incoming.obj = args.obj;
 	private->incoming.retrieved = true;
@@ -217,6 +228,7 @@ static void luo_flb_file_finish_one(struct liveupdate_flb *flb)
 			private->incoming.data = 0;
 			private->incoming.obj = NULL;
 			private->incoming.finished = true;
+			module_put(flb->ops->owner);
 		}
 	}
 }
@@ -394,11 +406,6 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 				goto err_resume;
 		}
 
-		if (!try_module_get(flb->ops->owner)) {
-			err = -EAGAIN;
-			goto err_resume;
-		}
-
 		list_add_tail(&private->list, &luo_flb_global.list);
 		luo_flb_global.count++;
 	}
@@ -479,7 +486,6 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 	if (!private->users) {
 		list_del_init(&private->list);
 		luo_flb_global.count--;
-		module_put(flb->ops->owner);
 	}
 
 	luo_session_resume();
@@ -506,7 +512,8 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
  *
  * Return: 0 on success, or a negative errno on failure. -ENODATA means no
  * incoming FLB data, -ENOENT means specific flb not found in the incoming
- * data, and -EOPNOTSUPP when live update is disabled or not configured.
+ * data, -ENODEV if the FLB's module is unloading, and -EOPNOTSUPP when
+ * live update is disabled or not configured.
  */
 int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp)
 {
-- 
2.53.0.851.ga537e3e6e9-goog


