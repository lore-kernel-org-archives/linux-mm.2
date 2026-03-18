Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D987103E18F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50966B0248; Wed, 18 Mar 2026 10:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD4C6B024A; Wed, 18 Mar 2026 10:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4EFC6B024B; Wed, 18 Mar 2026 10:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 973E86B0248
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:17:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 454C8C2853
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:03 +0000 (UTC)
X-FDA: 84559385526.22.358863A
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 56BF540017
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Kl+XEn90;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773843421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+VqvYB4/DwM+CB2Xe5IvCpNGUCzC20aSBPm99ZSf4E=;
	b=dM/x7LIgHOdKeCPtcyO+iSBo6jAd96wcekq/pQpQwdFGSG4wewmbG1gap/Goc1SNyZ2JS4
	SfcAc6uxkTHVlYaWkwM11iYdWbN232uFA3uzmfPxWi4bxDyeXiNQ8p9ZVA14pkcw08blkr
	SVFPKp47lTFSTAxsiq6UJUjit2FDsk4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773843421; a=rsa-sha256;
	cv=none;
	b=oLuUITwy5m1DLQmRWgNNp/0v9kI3OukMOqGlweFEhoid9h4qIF6VE90w8P+aUK1MfzessB
	4Glz/XcYWoLxAVdyPvxJfkqUGNxdl9R7Id9EgEVSnP1oEVIFCKG1NCtV9kEbiOu3V9QCai
	0wMfPVpChinpzbLEzez4suSbVUv9OhI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Kl+XEn90;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-64aedd812baso7040740d50.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773843420; x=1774448220; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r+VqvYB4/DwM+CB2Xe5IvCpNGUCzC20aSBPm99ZSf4E=;
        b=Kl+XEn90dxaVA7P9wh6aEo7ujP64IA2l0bfpJLsqyWls3pDHbsGa0bgqliKIJ98YMq
         wCgTEleTjT79VO26JBfCeJNxoevOBYjAx/vhrNN4tc9YJlFBTnPVSt9S4BLWA9XE+U21
         YZpTgibCa2RBP2JWtfrhdQMK6lAfrgUYj6VweabQhm86pdzxIsT/eFzWVM9ZJlhL2XZc
         8MAQH7PA+dwf0NXfmAtbFJ+8eW8d7UQ+Wg0dnKjWEEgf0npL/Se8S2mawpI1lUx6AOS6
         AMjg055srfJ4z4lrjhyRykGddWY+DMCzNN8UKLCoA4kutUPQ8j9sDbuWZMGPZE/6yZXe
         5Vuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773843420; x=1774448220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=r+VqvYB4/DwM+CB2Xe5IvCpNGUCzC20aSBPm99ZSf4E=;
        b=eBf16MhgmqMz79ag1BaYmzdUTtL6LWYkbEd2LhGp9IdMxND8WZPv6XbjyEHX8OSMLH
         /86oj6p+Ioy+j2GUe5cUEzByhzCzKzp3jIrnNO9RC1AQmJzd14bv4+37jsE5gAUkIY2f
         1Zr/ibsf/n/IjA9MeeQVvrf4ECk/7BmKHv2X7DbNp6MFgvOxA0mg68UEuMzCrwSEEMJj
         Fu7mLxpxgxBohAd47CQdk/9JCBb2tSr5SG9jxbfuk4FbCXB7/Tf1GpIwR8aBblFZtwm/
         gwDJPIMClTLrwnM8cs1tLMorZC+RnWnh0OjzwLQmlDSLkYxR/COQlDQ1k+kRYv1/dgua
         4h6A==
X-Forwarded-Encrypted: i=1; AJvYcCXJ5DefnyXzoxYqJ1k6jeyaXfvdO3fOhofJOVrr1CguMa57kxTeE9/91Y8+V0SGkcTo2yHcstauIg==@kvack.org
X-Gm-Message-State: AOJu0YztAE5xS0PFHsVKKHPa6N334P8lkoErU02tETHLzXoRUdm7zIHS
	3cNvKqu3rineXzXsNihirvF+mT4R55tDM5Hgfnq1NtQqvavZsvozm+5oZVjuEBkbLkk=
X-Gm-Gg: ATEYQzzlKV7a+TlyMgQ90kWlTag+q12A3hoAXNkSIN4Sp4eau0NpXmKH0qjs2bYBX2U
	jsOYGKM5v1FCG/qU7O9J7dxGouzdYJoHe/szoShbIK87wHrAnmmcVI3VKDQNxonBten3EqDEm9c
	AvtjS4aE9UEmnenUdsuWxskY74dRYubZ0FPD9/efyFTq7MJ0dnKS6fLN9JW6yUORpjgsY4pTbrZ
	rrMDcUS9X5dGNbbbyf0Th0mbfAYck1wOBIE5EiSab9BSMlsOE3Jg9WFy5sEFOsOCWfsH5K6mTy7
	v66iyRCVy04iOMLJ7v70El5UELlhvNi9sOhUVrVZzQJVXVwMhMEwjCJHp6gamDydPbxhQkzFZdY
	ZzD5srIOxcKdup+Ts2k6ALUQBV4lOjut7Y6F9+RNjrq+FMUL7tjwWwbjctzzWAB9e67Z9d/HOEs
	VHYKVqQkls6MQ6D6hugVsw8WwhwHb+DmJzYcuVN3THNHww8BvVWBncPkqC1n45C9X6PI3D8Qm3m
	sH+VIgKtk+rAVBSSgvpFo1OG/TPzx+tHVQg9KK2AN6bGEn/YQ==
X-Received: by 2002:a05:690e:4466:b0:64a:e799:1d92 with SMTP id 956f58d0204a3-64e916017c1mr2847774d50.61.1773843420339;
        Wed, 18 Mar 2026 07:17:00 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64e91be0e91sm1672028d50.15.2026.03.18.07.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 07:16:59 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org
Subject: [PATCH v2 4/8] liveupdate: Defer FLB module refcounting to active sessions
Date: Wed, 18 Mar 2026 10:16:42 -0400
Message-ID: <20260318141637.1870220-14-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3373; i=pasha.tatashin@soleen.com;
 h=from:subject; bh=iR8I+/StaBXxEZV0NdnOtDjxL5dTWNF5Ps57FdSsCf8=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBpurPLbaFvSonT8zodhVCWfmkfgUrhZ5neWD5Yl
 lk0n7d4NhSJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCabqzywAKCRC7dyhM23N6
 3vfYEACHkJvJO9RYAfuX2GirFrKaaIB1vkyXHVlN0h/nFzPddsyK5i19XDsQTcvXCge6ahu3UTH
 QG8HNKcbZjJvx7aDk7SPLi/2X8jNZInKJMQN7qOQJpByfZlf/7EFZkPHlhYp58nXtiHhatYpfiM
 1ijBMgNWE7matlz77/Wtwl9Ui2Nm3W/qO/cGQZlOXcS7bDpvv7eJYvtHKwc45M/SUB8j9ZElMMT
 kab0YWyftiMI2k5iV53LW1maimBM2EqWBDHHzwEFc/q7lX+2aEuZ4U/6dJgO8PfaB8VEVQS6B+U
 DUKqln4zzhSZmv5w4h8fYJA1lIsYQ2HW5CexIApQwlwC0bsFY+N+FrkFlzgMHTN+YuHiijvSMyx
 1p/1y6B6icDeXAdqL2cOJxfiIlS/QqmyuScGvYXzOTvtEzI5fLc/FVAQCVOA+3WWv+VXPqMik8K
 yGMGAkGLyLMAVhaU+yPZfmYwVJa+28qAv/mmu6s5VTiqKwENAYH3b/y++dUjr0be30fGrs7Pyt3
 RQ6HEVxKRgNN0bK8Odx6Z81L5oYtb9gxXR6ZQiJvvEX9hhDo08K22fuT1fBx75a9C/iYz9ZfV3X
 TEBKUim3pjj6/SLjNedVct0R0tJsvT0hef9EGDz+wj6t5ceKKI7UTNLu+99dPhkBHwNXdh+n2yn CoT+ZEqbfukS3Rw==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp; fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 56BF540017
X-Stat-Signature: w69jobqa46epigen374ebxfm8xa6wmk8
X-HE-Tag: 1773843421-83624
X-HE-Meta: U2FsdGVkX1/4E9I7lXpzOG0xBs2LEcTD60+xB5XDU7/KBsx4Weh6ErfV7HtjBhZUuSbUIMtgQhlp44n1R39jsQ2mzjOnpEmz2ZtJYJtNDhL5HeTPAwisCZH5jCaFA5DRjaOjd2h8fLENlLhY8KvcmZ/2sumDgg/rsd6lP05a0MuvlILf7+08ds0yQI96XmP7OsPaIY1ecCVZCjXHGTNxP/TJJXwwDQuwK8KBnEIqymmlnLgdY0zsimoh/NL65l9Mq5dAM0N3IKkJr2hqgoZsPXb1L1vaJqtbb7OCYprIlyrxCXeTVoiPOQ16y+J46uxYabA7d9CwrppffZRyjoUgTNGWEQ4V/jjGKUtrB6hjyGSW3duhTtRQTnZoRCCrIGanlbo/sURdkV4leYsmqeyUwZu32d5mfD/ZNGSSQcTsss4jczeR/rA3VCKKYGVdAyQMBJZVkKZOc/Yqt9LVB+xtE57lkRX7c46uohKFyj+5NTn8KBjWVlyaYkQVo1Q3M/C2/K/NQDfoCmNG7wEi3JFP/Nj4eOKgjpEfgSWJehi9kaNK1hCsHJbRaYMmX6OgSTimNTN6OATHD0bgFEzkXwe4r1uW6R8rO/rE27s/tpnv2kty7amFXz2M4t66o28p5pLYBP1UI4Lhr4664YdX70a/Xsrf/fsoJobpMHxI9c+7Npv6IP5LU8YjBTwdkC5UU1/RMp/lCBnPCtB1047liHHFMExvaCQ3iyHIZE7ENsNe2bqaJXtcAYreBYpVOeu5lfBXd/EtnDPp/vqWo5LWOLRRvda08K2E1FTGqjW9GqkYZSQLRvTJHTxS7lcgDvoHjJo2YAGWwpZqNfkqSleDxavDyFopT2ChapPzYWfOZwkcnZ18MSVomb6HLwQ7srLxmKsw3oPyIjGNy4UrtJKZv6O9DubYhI+5SK86ewgmnGAfTtpxg09EOhkNb7cR/mnaAHivDP7/bJKc440KYsJQp+h
 DQ/o9HSk
 NoSNNJt61CR17db9o9GBZ0DMeXTSP8qJbwfW0jddXGkOZVBLJC5kKxDm1PPfURUYhIq4veBOMOUSximmARw1KbL+1p8n/swbdBsGdHq5frR8+p6AjZVIix/ZJl5bAYrfC5NqeeOmP7sJrW/X1+zmn1DQXFN+dDAmmlbaN6+B9HzoDodlktT9VdlgDynt5dYYkT398sJNyAJubNNR5J7yRqbtqCeO2KAcUWT1eOCmPZnL7t4Mxz7Qxo2bIwCwrcmCJCPvagL/PEfqInzcB2gBL8LP0t98u1m/MqKIFF+hp1kbmFZvYOzJhKa/QR4iA6l7cFCMW
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
 kernel/liveupdate/luo_flb.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 91910d806d1d..98336cd23aa5 100644
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
@@ -474,12 +481,11 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 	private->users--;
 	/*
 	 * If this is the last file-handler with which we are registred, remove
-	 * from the global list, and relese module reference.
+	 * from the global list.
 	 */
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


