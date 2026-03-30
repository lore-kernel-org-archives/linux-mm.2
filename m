Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B49961061B17
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214DB6B0098; Mon, 30 Mar 2026 12:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6956B009B; Mon, 30 Mar 2026 12:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4896B009D; Mon, 30 Mar 2026 12:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EACF26B0098
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:56:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C87EE06EB
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:56:58 +0000 (UTC)
X-FDA: 84603334116.07.995AE0C
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9AD9B8000F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:56:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NsHGO4qk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774889816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDYEULGBlCsIFF3UlEMjXf8hzOYpl6gbeZeqwueHYJU=;
	b=nP/hv4+AbgBDTtfGc+x5z141At88GsaQ0QohAS9Yg4/dYxsx7/KBv5wxt0m9FxdUWJP+YD
	NFCUcptLYlEcUZeXJOhVtVeMBhOFFqqm2B8pTCk43579iRZCTUFlbMqOESUlVEHSXDyDBI
	9Tbgyk8Qk84jFBtyPrWIIGOuX5zAjp0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774889816; a=rsa-sha256;
	cv=none;
	b=TVkp/InFkyxpznYTl5FtU5FrvlUfTlXtVR4MuI/JTY3/V2E8a7mqtOPEeTZYa69SRmSFof
	z2idkVypJvFVZ1J/jObCoNQtGndJmzA3tEhHlYJ9Y8hcpunQZ/Yf2pMfk90QVs42dp4Fwm
	2YTUZhe7fuybUF7DtVDU3APa1CcHFuM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NsHGO4qk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2b0b260d309so2435ad.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774889815; x=1775494615; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wDYEULGBlCsIFF3UlEMjXf8hzOYpl6gbeZeqwueHYJU=;
        b=NsHGO4qkX+dPee+pz0Xohmpr3gmVVWjbxGRLlrS/eREqgkwQMwnguu1nTG4kl0aQ49
         ljgdSghMv5iO3PwnwS2pzG6LOX5Z0Lce0qXqdkTtCi7GtuI76zFk4ubu751E75sVkMl0
         J6UPZikfwqin5zUHjy8s7Su7IpWD26Ez5nEnZXRWYcAZYK/bKGWIf+niPhRUkTNzMpzN
         w4/TeWrpuf5PGJeKpbSfG0WxN9BgACm0fCnUvbpmFCN3SKu73ryfg1iPBwIb9XF+Wraj
         xfvsFVepUPkOtryswzQRRkfB4By50DXDKVEZ1vf7mCyr9HmbG2kLVRN1A7/IAxJSBwdf
         XRAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774889815; x=1775494615;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wDYEULGBlCsIFF3UlEMjXf8hzOYpl6gbeZeqwueHYJU=;
        b=VBYxU6J5JvBUpR0uOC8LvE8RX4JHk9T4BlURCQKAM13YIoEdCOP5ti476Rns3HgyWe
         djT2qMPBGUvW4GE2qYAXpGKOuanC91Cw8m2kic0HJqWWcRYV/Gf/19+vIVlf5r8nbk8c
         nufwVbq/x0mblPucxWgogNleE0fV1J+xL9Q96qGXqAdHjb8UghGISi9CFhQ6A4nf4B1M
         Vy4RmoFOzCzwod7tz8Ma07TMQK0Ch57HmOpdkhgh1crb7+iTA+VyE+NAJ6/ZQvw9DaHt
         xEgq4jKaKAntkADB0NXqzNs55ck466atcTJ0tUW9oYEYBxMWncCy2QteY4ByBMnpSV8k
         lN3A==
X-Forwarded-Encrypted: i=1; AJvYcCXV+448JDM7HH4OFpS/GPhEYNwWvueedj15FiWxKdqX83tPb7OKK19XrgjthZY3/Lxd4NOp7cXcjw==@kvack.org
X-Gm-Message-State: AOJu0YxxtqRfc+fmmXuj18/kZac+PvsjNoxY2sbMuiwX7wDwieoz2zxY
	YfU6XLRqQR1+rJkMLNTCUwMgZSKctIcNSA5MbXsgfcBJmmhlA4HyqzRNlrYDA+l6nuqeZZH0JDt
	ub0L10g==
X-Gm-Gg: ATEYQzyj5Kswd+I3hcoB326Qq42TC5K0OgkPSocv2f1zBUqgl6CF4oti3nStikYV8eQ
	vAqepWDclek4evd9isEw0VAAQnRer3//qkfovj6N0eRnP3MqSRNffkE1d0z79hNFjo0GwjAwRhI
	Aaeujnnr2wnndr/0B3euWNLtad55VQG/5IiVvhpQY9kChgKJXchwmsDymVk4sfY7FTrD1EIXfw7
	3DbZC4N8v7vSYFE2L8IkREqNeuXiPY4BsM8g3rGQxe3jU2GmdTL7hbVy3wGvnM90vl7K8D6bJVC
	+giVH9ngmDBixIxMUBJZ5qSOV5wMZG1FxswI2nvE4WYz+pRDBpor1Ce1nfaRq1oBN6Wywf0oSuW
	VEr/piI56Bc+Eyy/Jtrwp2piH1sXoEmITnAJAo5gx6SdpL/uwY0iFwEXfag1tX3eJ81sECRGEsm
	rlrUbCNA9bzIVIFRi1X0n9c1hqhLOCP0DVqiHMn2+hNp5btZ2g3EJ4ipLdS8cHtqHArFhEjcB5
X-Received: by 2002:a17:903:2412:b0:2ae:4e8e:954e with SMTP id d9443c01a7336-2b242c79fb7mr574715ad.5.1774889814732;
        Mon, 30 Mar 2026 09:56:54 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24267397bsm94018185ad.27.2026.03.30.09.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 09:56:54 -0700 (PDT)
Date: Mon, 30 Mar 2026 16:56:50 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, pratyush@kernel.org
Subject: Re: [PATCH v3 05/10] liveupdate: Defer FLB module refcounting to
 active sessions
Message-ID: <acqrSaBSDdcgDmUn@google.com>
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
 <20260327033335.696621-6-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260327033335.696621-6-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: 9AD9B8000F
X-Stat-Signature: gqagru4ginoytpjtgjg64koz9hnxe5ob
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774889816-479378
X-HE-Meta: U2FsdGVkX18IyOmtfvFCkoNqFXJqI+nZ2Bd6jqswRCm9E2/FqwXGdWj+OihKbXlejfY94/1rIVep+7knNqNafWW9Bcp6+Dpn15/FkEoIfnDW3+MenAteY6jnAhi0HQT/88/B9NozQU7PlSH1iym/066tlPBKzgTB3xgWfweFtNq2u7MAWgQL9gkGa1NHjig6zNhFI+RrdSRm70UzxgU1Fz7ONROp0H1NnceVXXcBivbs0KPMxm8A+k+Ct4DO8h4Tkwlemei1TqodNf5t1wJVl5VQ21L2nmzZrFyxUvv99RyrDXCaem9p9mjha9s6IIBGL8mPYSqWYvqEsGWsYd+yidBEVR/Ap7pt81ak8HJupfnj0beR5PymGDmWQI9GJv6aa/7gjgdpq6zBJPstHwLQJFcE0T5dqFRcjn+dUQBFGUHycjoGa1uI9JEpMEFw/eBCYGE283QBVSny08NSWMazfRl45qXyjmH5W9IpHVNDwz72+aYCmU+bxUhmhMTXVmHLeXVfDmXtGiLwXNFflzyXyfLE9Qy+bfx7QUe1G5YRJWLKfANJa290uoCQNWtFIddU6t0RW9wLkp6uRKFyieF3/WRp5Qynv1HzG0VgaAmfXUGyzv0FbvqWUR94E8+uRpn/Wm9Ho1zpgUan2jmoTczxuV+YBIClr1Q1rnuybMjxAGCnbNAhTdkQbI8YXUGHmMNVZeWLxp9aBvtu0xCzmsa710/xEM6FQv7WQHGf72mD+YpTxGcw6TX4fU1IwnaPj2Dl93JtiC2hhPSSwcnd7uBogEyaHB0mRysz1hZ3sU+U85n61dfU+TVOvEHM0bmFtfCVND3JuhvxApI9525SpomHHCNd2GBqCDFcUn+X0bGCrCwOW/97L0MLQ+0jWizKk9XlV7O2seZNa+AoICKrF6PMC+nnDjt5T8X+LtJ1GqX8CmeiS1xzM93mMUJtzxhxpg5oJIgcOu08UwIVJCgk58J
 cq30/7Kr
 dc+KZwxOknywNi2c83/p60/fVsfsvY9zhSolg02jbmUMBVEm4wb3mjcxGiap2iPPTEVjGNmpRqsaAsA2hcacxGel/hutPktKUU1NroLPrUIR3IFm0IN8tw6zgAgQYSHq/RRf/4MPlotLpowS/8aLlseFBYF5KDM2nW3/TU97pf78djfFdrj3B0iiVbrV7tEbToR1Nz1cS84REnEE0afdUrsZlHJzAoioMoqqSoLqDAphdTg3VO7/k7M+umEOCMaHwEVt4fIVIBCrCDL/YF9K2RUSrAXgUnQTXqdAe24aXq7X1vnbh9X71xbYufDm1JUm/3wK7ILaE4ylqEhxEpQxrqbQR7QBaWhnKpmbxMPPJtSlWy/x44ItmVjtqMdjfBhwMl6f4gzrcbXzxAvQow4rbcStX5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 03:33:29AM +0000, Pasha Tatashin wrote:
>Stop pinning modules indefinitely upon FLB registration.
>Instead, dynamically take a module reference when the FLB is actively
>used in a session (e.g., during preserve and retrieve) and release it
>when the session concludes.
>
>This allows modules providing FLB operations to be cleanly unloaded
>when not in active use by the live update orchestrator.
>
>Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>---
> kernel/liveupdate/luo_flb.c | 27 +++++++++++++++++----------
> 1 file changed, 17 insertions(+), 10 deletions(-)
>
>diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
>index 3c91d0008eb1..ce28ce9b113e 100644
>--- a/kernel/liveupdate/luo_flb.c
>+++ b/kernel/liveupdate/luo_flb.c
>@@ -115,10 +115,15 @@ static int luo_flb_file_preserve_one(struct liveupdate_flb *flb)
> 			struct liveupdate_flb_op_args args = {0};
> 			int err;
>
>+			if (!try_module_get(flb->ops->owner))
>+				return -ENODEV;
>+
> 			args.flb = flb;
> 			err = flb->ops->preserve(&args);
>-			if (err)
>+			if (err) {
>+				module_put(flb->ops->owner);
> 				return err;
>+			}
> 			private->outgoing.data = args.data;
> 			private->outgoing.obj = args.obj;
> 		}
>@@ -146,6 +151,7 @@ static void luo_flb_file_unpreserve_one(struct liveupdate_flb *flb)
>
> 			private->outgoing.data = 0;
> 			private->outgoing.obj = NULL;
>+			module_put(flb->ops->owner);
> 		}
> 	}
> }
>@@ -181,12 +187,17 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
> 	if (!found)
> 		return -ENOENT;
>
>+	if (!try_module_get(flb->ops->owner))
>+		return -ENODEV;
>+
> 	args.flb = flb;
> 	args.data = private->incoming.data;
>
> 	err = flb->ops->retrieve(&args);
>-	if (err)
>+	if (err) {
>+		module_put(flb->ops->owner);
> 		return err;
>+	}
>
> 	private->incoming.obj = args.obj;
> 	private->incoming.retrieved = true;
>@@ -237,6 +248,7 @@ static void luo_flb_file_finish_one(struct liveupdate_flb *flb)
> 			private->incoming.data = 0;
> 			private->incoming.obj = NULL;
> 			private->incoming.finished = true;
>+			module_put(flb->ops->owner);
> 		}
> 	}
> }
>@@ -412,11 +424,6 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
> 				goto err_resume;
> 		}
>
>-		if (!try_module_get(flb->ops->owner)) {
>-			err = -EAGAIN;
>-			goto err_resume;
>-		}
>-
> 		list_add_tail(&private->list, &luo_flb_global.list);
> 		luo_flb_global.count++;
> 	}
>@@ -493,12 +500,11 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
> 	private->users--;
> 	/*
> 	 * If this is the last file-handler with which we are registred, remove
>-	 * from the global list, and relese module reference.
>+	 * from the global list.
> 	 */
> 	if (!private->users) {
> 		list_del_init(&private->list);
> 		luo_flb_global.count--;
>-		module_put(flb->ops->owner);
> 	}
>
> 	up_write(&luo_register_rwlock);
>@@ -527,7 +533,8 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
>  *
>  * Return: 0 on success, or a negative errno on failure. -ENODATA means no
>  * incoming FLB data, -ENOENT means specific flb not found in the incoming
>- * data, and -EOPNOTSUPP when live update is disabled or not configured.
>+ * data, -ENODEV if the FLB's module is unloading, and -EOPNOTSUPP when
>+ * live update is disabled or not configured.
>  */
> int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp)
> {
>-- 
>2.43.0
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

