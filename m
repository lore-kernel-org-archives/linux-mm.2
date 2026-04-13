Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F1AF531C6
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5696B009F; Mon, 13 Apr 2026 14:51:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B32896B00A1; Mon, 13 Apr 2026 14:51:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48616B00A2; Mon, 13 Apr 2026 14:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93F306B009F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:51:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B4041602A5
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:39 +0000 (UTC)
X-FDA: 84654426318.22.71B51B1
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8F9B280011
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="efX3i+f/";
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106297; a=rsa-sha256;
	cv=none;
	b=YiH3bcq4qFpDE9V/8aaVmkp4NxWtgyd7TsPTMJ3ti8vqimuQPdw1Rc1lq+rkbmCGJ5IkQF
	KEHCIzRf+s1rmT7BkbhsywJnzSgcPlfU50iJKsbqlZQPY8ZcUJwoJK0bLfNCAW6nqaEibC
	qHR1efpyZ6cPHHvtm6uVs1L43QImBVs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcxL2phgHX3P6+H2aXIyKXDTUm0lhVC2d+qr2+0n4tk=;
	b=5AoYWm0AnmPjJP3Ph5YIXA5tsUnnScRPKuoKTa6VAQbp2o3y6NLTkFzu6ZpkLkoSrHyF8M
	30JHT0sqvFJdkQhAjJ9ee6m+CUNbdAGAhBOQk3EBtoGJ7lKzIK8aN2BTCohlJ3CreNA/J3
	Qylv0SqjPRYZ+EQF/vBCu9V13SF7slA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="efX3i+f/";
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8c70b5594f4so467314385a.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776106296; x=1776711096; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fcxL2phgHX3P6+H2aXIyKXDTUm0lhVC2d+qr2+0n4tk=;
        b=efX3i+f/6REbUAsiOHtQocOAAegXFG59154BKvdG5XKiLU8xipB0/ihNKNkCPP7KDQ
         mN0+gJJ8THQtkZclZOD0tYTa0tdO+JQdRH3MLvTyeYA8N5f6WKKCW+MujBCagO40LeIO
         VYZ3FFB24IJz9LV06QByRy8gIgQ3RAcwxwX/tqaWn/RRhgX2A/e1ad4IvUMtueiPcRr4
         2LSz+UOIWUMihFSnYeY98XvlqHw/LzzFaVVwYHVX8MTFveir2bDEpi3AHzRtIjlqoTIE
         y41aavzznKQuF8f1yUq/JrnOwDBapyThm6P+cBXmlxh0sBfgA1/qnaO9gNseHFhkpn0P
         6N1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106296; x=1776711096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fcxL2phgHX3P6+H2aXIyKXDTUm0lhVC2d+qr2+0n4tk=;
        b=pMx7I+m+JOUhd1Xv3xeD8wy264NxDmxY00zCHteAVjqwoYbO3VQMkt2idYcnD2iuPn
         jL/8yH2q+yDCUuv+6l3NtW04nHvn6Y3lE1dRZbNPjEBjW46v0Q3yBnnDraGFMx2XlSFn
         7LO1k6smKJpBQdJ34Sw8+23eXa4xflSa9rLzioeJkZVyizLeijd9OxLd5UMKtF9wuWjj
         iEIwr0GGzlIrbn8vb6ECF5T4hwifgWQ16/GsDYuS+WprkuVUriCESzQTRgdBvs+pnrqv
         VMlLGRDhXBWKuE1i5xfKOaZQzh8sqjZn7FVvPYnOQvpEHmyTX2yyBQY+Cp0XCOknfC7a
         QX/w==
X-Forwarded-Encrypted: i=1; AFNElJ+MqoIJAm/hT2PG6KSb9KA7A/t/yrzcRCdoOZDvslVO4k/SKT55R1OmqW5HNZO7uZbyjHzt7dn5Nw==@kvack.org
X-Gm-Message-State: AOJu0YzQ5s+AjHF4dVlQ38/R3htksTF/aJUMQft+A34kd9TYDdK9zqoA
	biXmkDQ8YyjRxi+MTQYYcYmmLlqZ8H7tsOUpe8E1U40qOt7TFxxJTsxWhsXRI4xtwic=
X-Gm-Gg: AeBDietU+D+0C973WuI6GfMdJ8UwAcyaCWScLZTn8Usr6cGx7j2Ytp+UQZkSN1UL2G9
	Xd+qXMk6p2qWq8TriC7lHDoz7PoT1KBrdZPSLhGZ1c+RY3GiVNwbAVc5SHQFZXQVNfi0Bj58Z2C
	xvnIYl3TMRsR2BINyY/GNm0OOIPv54MFfB1nmKq4z1f6NaUyVoAlIlxA6+CGCYPwH+QtfFZ5TAK
	nsviNNwx7sm7Z3BJJ5RuSmSPjz77jtyc4fHxz6IPtls0eOm9+efK0ApCvnrOL+uN85E/ethtFLD
	VF0auIFFB7zoj5C+UJyTLml668i5vG7hJTMD//oNzMQrq/YJkABcB5Bz/Gj9WwEhWWCyMKui2LN
	uGtfLDxyNEdbwET/WjloZX7EhZau54N/Z+HH+cYGKbZRb1vieC4Xj6OA4hPGWa+MF3F9GxK2WUm
	p8q1Y+NzTqdYsOSHEpUp464lLgdqdazr2yiNmY7LOEjU4j41MCnEppJBQInUoouTuhYw==
X-Received: by 2002:a05:620a:254f:b0:8cf:de26:91e2 with SMTP id af79cd13be357-8ddd03a2c5cmr1852376685a.16.1776106296523;
        Mon, 13 Apr 2026 11:51:36 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb6372790sm943206285a.12.2026.04.13.11.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:51:35 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 05/11] liveupdate: Defer FLB module refcounting to active sessions
Date: Mon, 13 Apr 2026 18:51:21 +0000
Message-ID: <20260413185127.128180-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413185127.128180-1-pasha.tatashin@soleen.com>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8F9B280011
X-Stat-Signature: bq4ittufstbfwmk58wr5j6n3ypcjwprr
X-HE-Tag: 1776106297-166972
X-HE-Meta: U2FsdGVkX1+RqamG7IPreMYfYz4w1LNyzrp/SvT2oZmkHbgGHnfGvC6Z7JL4iuiqApqXJxAbiRB9j9ckGJfc9KYLc65JnFe2imCYfkEbAvN4IAuktRNdue+uAcrZMfk4TR/QjMJDBbPqEM5oFw0HOjWTpx96ny5dAHXdm6BU4Blbae/aIyt1TGfxoyOIEmpOgFvo1Yu2OerOEG/1ALbanW0FqKIKQypDgDbPvhTMfyQMJ37tiJXIu5D8LwydoBLFHkqtmcx6m/6LFFEBpSIZEtdnRKsU41SmKiZNE4ejm0mQht9c8Wm5BqyUs6MxULIDg589rbdtqEL4CtgLSk5hB0EhZoxZlLhcSZaZhzwl6gr4gtHdQHO9u87obj4x8byrkerp9Of7uGXEArY3t6SCarCem5Z3ZyAMF7CbEIACSVwAoz4c0dQKOLg/B2uM2I5BNsEj69ZDoUcctkBKWOc+yaOheVdjxEUX82BC9G64kkD0qEH027d97+uuNclO0+mHbMjuG4Y51+kI/qik/SJPvyrGzzx0DNzw5Dvbk3J6URCKaJN8HMNWPRt9XY6MadBywmVQi6q7vgfmSsSNrUpMcc5m/AIYJBxcvKfiCiAj2B+UZT3i/HLQqViA/EbjICgoFPNhLpkBwARG+R9ekArF69p+bMQRVlVfn5EkS48iHwhOMYaxgh/xPgKXnglrrkTlrOZmRUHgspcvuype3sb/l3tmQ7cbNoDl8klnxsOyz6g5IodirI34hQlZjmED3+dHJ9EC0q7pka5saYzcJ/H3Qgjks1y9B+6KO1BuQUA/JUdJ0NAJPJkVK4CqSzPDHMzPzdzSgaJ/ft0aFXzlXcHvUzSvt9R9BVnb/Adw/qSD+cvImHCIMomElnyQelttfTOxKU8OcFzvrS8RTdcLDoC+BeEYMpeOcsvXnDcvWhHKDb3ARQh+MQfZMPeeKOnyIfZHBIdW2gurUnDLMmJKWYQ
 XdbeLGLl
 /4nA1lR26SJIx8YLGG24H5bHr9EzLeO7TCm2RppfS1Gvtugd9Jt0dIdjUPYLpgWzUXia/+nmfi5oj+fIKm0MMSWgF/3wT8W9AzvqEVg4wYpnInsHRdy4R7+hxEdGu19aj0wt+rk+nLT2JZdXDyC+8C3heZRfqIHsR3J5StkIwfSQaSu5HeMauo9P0EIwQjWVPPhxw/2NuGz/EuNcooAGPGMPiUCi0p+20vfbHCZ2PVElVk3XweTasd502LSlBSMkK+nyzsJ7hkX92WjEEJvepvAW2d1SZFZ7kv6vgOSNIHHMdM/Cb45MbfcJqrBw1pyXNciNlbt8epbGuWASrpbNYKzybrKfSgkjuLfAJkuo3CUSDJlM2atOhtVfmNQ==
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
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/luo_flb.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index fdb274410e8f..3d439d1c8ff1 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -115,10 +115,15 @@ static int luo_flb_file_preserve_one(struct liveupdate_flb *flb)
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
@@ -146,6 +151,7 @@ static void luo_flb_file_unpreserve_one(struct liveupdate_flb *flb)
 
 			private->outgoing.data = 0;
 			private->outgoing.obj = NULL;
+			module_put(flb->ops->owner);
 		}
 	}
 }
@@ -181,12 +187,17 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
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
@@ -220,6 +231,7 @@ static void luo_flb_file_finish_one(struct liveupdate_flb *flb)
 			private->incoming.data = 0;
 			private->incoming.obj = NULL;
 			private->incoming.finished = true;
+			module_put(flb->ops->owner);
 		}
 	}
 }
@@ -395,11 +407,6 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
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
@@ -476,12 +483,11 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
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
 
 	up_write(&luo_register_rwlock);
@@ -510,7 +516,8 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
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
2.43.0


