Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E98FBFCC05D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 19:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEEC56B0005; Fri,  6 Mar 2026 14:01:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA58B6B0088; Fri,  6 Mar 2026 14:01:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCEBB6B0089; Fri,  6 Mar 2026 14:01:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C65BD6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:01:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D8741A06F4
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 19:01:13 +0000 (UTC)
X-FDA: 84516556026.20.F3AA0F4
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 573E8100027
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 19:01:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DSUPcnFK;
	spf=pass (imf05.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772823671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=egP4uheYvC9sMPollgo9xc+pktivTQM4ujp0h14jJjQ=;
	b=xB5Hxr3Ui3dvs1kPnMVtwP59sKwwu1uvv4yrNCrplAwdNUF8TULt4GVr4zKcLxdDaAqoea
	jZTHUwyA9+GUqTsP/MAzPMeZv6FMnwTGPWEmSB9pixMt0r6vW74hV4/F4hr+OWwx2XRT50
	Uh1G5k+BpdteE23KF1qKAyzQnkTZEC4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DSUPcnFK;
	spf=pass (imf05.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772823671; a=rsa-sha256;
	cv=none;
	b=QKfn/70zlntOU6pevB2YbVVPfSmLRbIBcXXa0TvIM5qMutp7elwP0+7Sc72UQDV1w0E7n8
	rr35B5KovGQvnrbr3rLancNk3zbpE3HVwErq+YwGBiGvYg8P/W8EmROnW24S+4n6ntzsFa
	tqRZXAEdMsR7Psk6o3BfIRkw5MHNHEc=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48371bb515eso141758995e9.1
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 11:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772823670; x=1773428470; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=egP4uheYvC9sMPollgo9xc+pktivTQM4ujp0h14jJjQ=;
        b=DSUPcnFKr22GuCxMjkfDrCQa4o3Nl8C5F8XpBdbuaH3uIHTCHfQvKwMCRgkgcLBFJ3
         wJjsS9Ryf86ryNEWUoTUX+XVd+yVYScefdKoKhPSC5/rd/URC4CqhqzcKpayX3Nz1rkS
         F9wKimds7IFu/z/zQ5pYzLUB+O/g+vLj/ZQezX7WlnqXkoiQXHip0UsmHffE0suTK+1g
         NXfz9JNgr6kUtMxQb8VSHgppFZf0u2zGKvsdqAIE9KBtStm8o1rMSI3/nCHu3ZnU5B6+
         DEfgBbA36mbkHzIXnGV+h9V4wiMYr95HcYhbbBcf7KxNAq6j62YxwLkj+R36GevdTVdN
         bdZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772823670; x=1773428470;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=egP4uheYvC9sMPollgo9xc+pktivTQM4ujp0h14jJjQ=;
        b=IkK/gTD42Pl17DS6SctVCxWcIkyhgWj8bYZXDj9BkurfVQyO8E+T1WHhP0VVE+onVq
         X+Vqr76V2L4oEUX7ZZMhOeuK8YzqDAecUqkvyOJ2KwSZk2Bdv5aT5xDm+d+0lHTSVPae
         uP/6i3h5mL4PAmP2ubxkRyE7VocN3hNxsiB8cAt2PDdTnViOopBWxNyGCarxUDY9VXym
         ECDWFAaY6EerdVCo5s7jcQdKX8vzvRg5PEwUWa4uff+7xUMM8p20YwdFjTYySp78PZTg
         vWZGAZRZWkwXX+6zF91MwGVbrtbzvGwRBx88x+9DKJaHH+vXNFNqobabYDS4na1g/ON3
         WwiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFeitx+Ju/URv77MtZrfK89mQyVbNTat2ZoNhoFcjLU3NvW5quTxmBadCJpcAmyvq9UQlakwtdIw==@kvack.org
X-Gm-Message-State: AOJu0YxppLIq+31/79LUOF6vlil0sV/cruvNG4RxvrX48QDpDWGssPjS
	sWDrolLvYzOWieczBp3QYjdfIxvJ7d6/bh7KzqH9PoNxLSkFdSAdPMgZ
X-Gm-Gg: ATEYQzxRvkRV+sjYIW6Uoyl2fBXJnKMDXsb/JnzpsdMN8vndkQvrf2gb8zJThB+QUUh
	WcasynPx3a/6t/8jCqCs3SPYFxPTUQOT0gHtTIn2Emd81u3RFomVbvtIDo4Msdz8oO26bOkdk0A
	M6FBpIMcmSmRGr+fhzvj49G6cMSC52T3S8VHdtutEjYwJwM9GBi90pT+P8fTQ3QXHvIpbR+8BxI
	di3u+XqGnwc2SgQ6ZAt+2eFXBe+lyFyH7ReY8qMfwep7Y/K1C0ky2dVFAYvc32MpfIxv+HzuARL
	GO/254NKJ0t7xyYKC0QY/p4Jg/H0wik1qJoi+rK7TbUFGXTzdehTu2y+8NeYNLE69YWLgDRM+Ay
	tTCVbf6qUc3OsEKue8zVHjn1xfNj2fb5QipSJagy74HuCX8ge4zQg0NU8WVaF1yK2fz24kWEiwS
	9meZRy0KacVVs/BjNzOX8wjjsqkWsoTYFgBil2XgjSnkFXatCrKWh5PgASv0irLseBPPgJFaw4Q
	GYFEd54NIxV
X-Received: by 2002:a05:600c:8714:b0:477:6374:6347 with SMTP id 5b1f17b1804b1-48526957d50mr47893785e9.22.1772823669332;
        Fri, 06 Mar 2026 11:01:09 -0800 (PST)
Received: from f.. (cst-prg-92-188.cust.vodafone.cz. [46.135.92.188])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4852767d8e4sm50717025e9.2.2026.03.06.11.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 11:01:08 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	oleg@redhat.com,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH] pid: cosmetic changes to alloc_pid()
Date: Fri,  6 Mar 2026 20:01:00 +0100
Message-ID: <20260306190100.1900572-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 573E8100027
X-Stat-Signature: bykx19ssns56hbkthscro6gbma6nxcn3
X-Rspam-User: 
X-HE-Tag: 1772823671-258261
X-HE-Meta: U2FsdGVkX1+ydgwibzWm9o6v0q6BzAEVL4A3ikkjCLqZ0CCS8BJkm0GYA/gVCkejExpiU64uDCbeHp/cOM1465R7fdlx+ZnBru8ljjhZPXLxkvZVUV8dpb1CK9CG7npZcUe8bFuxxrzzj69wrbACWZox/K/g4LwZSWGQ239Nb7MzDJepyltrE9E9M+iT0mq/rLl06XScNc7JJD72ITG8kweNbHFn43kG4xhleYx2eJjYpCCJCgE9zKbVGqjqwbiKIUgapDPsdUUPZUIlg2MXamE66NQJcGy/ho8Cs9fE6iQ1HdKzctQTvXbe715jGd9/xxMKRI0Q2WRWufbI+rhNGiT4WBcIE5C31fy9IKWEKCcp9cmiGf+Nq4BHNohZY2ZzvPCYieryNOxtXkUe/TgH2h4JdZzcGDP/n6AMYWT+AOzTpwcXVtV+XKY4tlBhE9LY0KdDYdHeh+r0kq1ACtvOaisGsS7eoFB+axBm/h1OaFrj+f07Dg0QKXp/adf953hGzUs6GA/jsxS+ejOwfejKV0k4880JbmSvjo9Dra6ZDRxh+9f5+UMPi2qPZdN1KMBf+HwsPivuyrIv6HVfej60e1XAgn/dGbBGBJanlBK9M6l8AUXOvZj415jbwLLCv5QVyvwlF1VsfGKTy/Oklhx0Lzeb6GNEGHj2WQ5+6Hz2v1GgvdMzSEUQOiUgV89fyfJjtkVEl98f0INoTGihv2zsbcLqzE//Ei3StGo5XsiDG/cFxmPktnB0I9lgM8ZzuFVqWH+PFO/ggKhzyYfcL0pj+sWSXBrtypmRotKjNgC49rQeFkg2OOana3vbGFB8nxh7voMDhQM3EqEM3rOjDSyvJBODKYhu4wFAKExg9CnYi/FquUUJ/qF1IB7EgSwvvTNVJOJK4c5vyZ+YvfgdVSIIpaZuUnX8X+KBoLqyNY7nOgRQoUrfnqUE0z8IY/L32U5+5SYKoC7NUKgAQkazO+W
 mQUvrFX/
 k0cjwqcQfYSwpQRm+yv2QxPAGBcyedKJ0fAAHTFQwhdxTm9yugwzLrbEn/2sJYhWeVZ+LI5HPLATKPCgFHIyZQFe+yGFUvq9eY6DDhZFH6Tl1PmfvZzIiIyQtZt70VPjeZdxDDSryeB4gogcsBYS/x570kpO5uxuWRKC1RDdGF6A9H9MgXxpqyVtT2mgCezVhgME1XA5IyD/4pEVUeO1OnjlJwlJR/QN7DtikXdqOvSJTiUBhJHB86Yncm8eHnlIbgYWvLprJJkuGaFm5AB9uXa3lMlzSWT0Efy8Ju3vwZ6vbQK9Cx6ZuTVmwwwLInoJtaf8otCXVSbDbHCJuSeXMq8+L/k4WAEFpJNM7D0BjOJzV9dSAigFHPJKmyybB12RcCwLYXiLhGOFgxcNzGb6taH8hjOhuquVHsa3p+mUcLQ6u5K1Gcl9XOQ3Sg2bLs4LElwOXdK7KbNTPUQk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 6d864a1b182532e7 ("pid: only take pidmap_lock once on alloc")
landed v2 of the patch instead of v3. This patch remedies the problem.

No functional changes.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 kernel/pid.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 2f1dbcbc2349..dbe82062e683 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -177,7 +177,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 	 * for a process in all nested PID namespaces but arg_set_tid_size must
 	 * never be greater than the current ns->level + 1.
 	 */
-	if (arg_set_tid_size > ns->level + 1)
+	if (unlikely(arg_set_tid_size > ns->level + 1))
 		return ERR_PTR(-EINVAL);
 
 	/*
@@ -186,7 +186,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 	 * 1. allocate and fill in pid struct
 	 */
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
-	if (!pid)
+	if (unlikely(!pid))
 		return ERR_PTR(retval);
 
 	get_pid_ns(ns);
@@ -205,7 +205,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 	 * This stores found pid_max to make sure the used value is the same should
 	 * later code need it.
 	 */
-	for (tmp = ns, i = ns->level; i >= 0; i--) {
+	for (tmp = ns, i = ns->level; i >= 0;) {
 		pid_max[ns->level - i] = READ_ONCE(tmp->pid_max);
 
 		if (arg_set_tid_size) {
@@ -227,6 +227,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 		}
 
 		tmp = tmp->parent;
+		i--;
 	}
 
 	/*
@@ -247,10 +248,9 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 				       tid + 1, GFP_ATOMIC);
 			/*
 			 * If ENOSPC is returned it means that the PID is
-			 * alreay in use. Return EEXIST in that case.
+			 * already in use. Return EEXIST in that case.
 			 */
 			if (nr == -ENOSPC)
-
 				nr = -EEXIST;
 		} else {
 			int pid_min = 1;
@@ -276,12 +276,11 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 			 * Preload more memory if idr_alloc{,cyclic} failed with -ENOMEM.
 			 *
 			 * The IDR API only allows us to preload memory for one call, while we may end
-			 * up doing several under pidmap_lock with GFP_ATOMIC. The situation may be
-			 * salvageable with GFP_KERNEL. But make sure to not loop indefinitely if preload
-			 * did not help (the routine unfortunately returns void, so we have no idea
-			 * if it got anywhere).
+			 * up doing several with GFP_ATOMIC. It may be the situation is salvageable with
+			 * GFP_KERNEL. But make sure to not loop indefinitely if preload did not help
+			 * (the routine unfortunately returns void, so we have no idea if it got anywhere).
 			 *
-			 * The lock can be safely dropped and picked up as historically pid allocation
+			 * The pidmap lock can be safely dropped and picked up as historically pid allocation
 			 * for different namespaces was *not* atomic -- we try to hold on to it the
 			 * entire time only for performance reasons.
 			 */
-- 
2.48.1


