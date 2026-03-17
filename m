Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A8A9FB5EA5
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 02:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878D56B008A; Mon, 16 Mar 2026 22:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792DE6B008C; Mon, 16 Mar 2026 22:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9A36B0092; Mon, 16 Mar 2026 22:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5ADEA6B008A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:51:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE323C1C30
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:50:59 +0000 (UTC)
X-FDA: 84554027838.28.54EA33B
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 36B5E40005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:50:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZtlICZTD;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773715858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kZn4gLBXu3j1qaebpHUHA9zxqcEZY+fBddtxI5ASzdM=;
	b=MZiB3tc59jYe9GXgx2WTRHaI9FEAv+PPWs6PVVybctqNkPYQeC63yHajeYGvpUV1K/AKyo
	9MzV8xi0PihY2v86ZqbMlqmwSHpckfvvwo6v+ysPHkEjtDR+a90/iXTPgXyCdVrl0XgIwe
	hc9T517FZst4i6XGt1Vtd3HELDU92x4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773715858; a=rsa-sha256;
	cv=none;
	b=YvpN8YPUgg6w45p7vqpKF/ttXKRpOJbRGhLXuwQCrYLxeArv2/b8KnNwQJ1fMOSg99MNVQ
	+t9Qkfi1/SR8ToXC8z9iLBhSekbnjWRYMGivHh6XYmgOfpDNtkUH5MHQVX9528Y/KS3OYr
	A/Y9dsLsWH4YynQcD6S2LbOLtJu5tXo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZtlICZTD;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-79a46ebe2beso16990647b3.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773715857; x=1774320657; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kZn4gLBXu3j1qaebpHUHA9zxqcEZY+fBddtxI5ASzdM=;
        b=ZtlICZTDAjz168qchhTfwrcvZoBzRe7fAPeJaRTMNx78MXuIEH0K6jksJDbHUGfl6s
         Z68/k9Igap+WtHm8IOzAxehWdmBG590KpGuy8LMqLmTbFfheKswIZ5w6fWjafNF4uotB
         z+dJ/1FdWYHQVzSoLiMqAgwcxNwJzRwuKmI9IVmz43i+0bnFGfD0HpXB70f/5/XSkH31
         z3WFvx6G91w63Y9+1g01hQSI+MHUQUXef0NBhdRWn9DgIsBKyFRQU2WA8o54xKDTaHN5
         9FqjO1fZqPRGO/bKE0z4tp6tA5goDSxM7HDLuH2otmPZkbpxJE16fqD+0amYyTklqJhY
         Rekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773715857; x=1774320657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kZn4gLBXu3j1qaebpHUHA9zxqcEZY+fBddtxI5ASzdM=;
        b=jwuHgG9C7grU0m1Nj7NMyBBzq02DsI8IlKfdm2w7PJzL5oVXDLopbwrKX+b2iBunP0
         4QHJeQhGdaOp9j98EwFEPGH2TZ+NihEXGXS1XK6a3m5qKvCU0s+2lgt0FEktVh6/gYJd
         6iNXJeXBLgpSZHkQ5VzlLPtu63RBYwyHN/rcjVVBld5wIgJzMNrxJ9dlmP0cw4/PK+9q
         znxdHDvia8af07pw1umFCF0d2wkMTvYn6sxnHX/H1yNyEsXUHptRGDCsKOER0kmUCJvG
         /y6Qo9v9IMJS5Gs3Jn+EHT2qYgNr06yTWmiCRCDp5VLpMHzokM+DKN1vl0PCzjXCMR70
         QWrg==
X-Forwarded-Encrypted: i=1; AJvYcCWiY8EsE0hUcXeJnXuqKOYtTw+3Jiy8VroiUdP9h+LAtJW//461EwOh74pUV9l31hQKESkdXLN4qg==@kvack.org
X-Gm-Message-State: AOJu0YwdY1QFIB1xDDAgslcwlH1l7K1vSPZJDMk/SJegoC/0gXdlj7N+
	3RqJ3yEKXWdnFRM8rLRC0ow6cm9s3EvnhIDA3R2fECXzVjzwbp7xsIxbp1qWQu0d9dw=
X-Gm-Gg: ATEYQzwoIrOucsPn/jIRHKK9SFSKNf+W0iP58esdhPGoOUpgUfpn4Q3u5xuWA+rlBan
	JUr9dH6wXfWlvbGhSMrpp4rGzOsI1UhXmUOuMJLLQ45FesddAxFb3lVxfl70x3zEqwE40qR08tx
	nr2q/CHgxKu9O+4KLWA7/qbdEVbCJQ+1Cbfka3hUjUGXN4DXoczAXm2Bel4tqZQaTqPoTPzDGjY
	yhjmeJoSnqCzeOmyN85nc73yDBagnKQiwvlCn588Ga4fars3Ig6JlFDObJbZ7oeC0aWpHylnt7m
	0d8XseLgzENikgNqHqp2EPvVfLvou/xkZ4IUfDU2PvjznJLYXhlSM/cUyB/j9jeEbYvmm5u1NHS
	rsRPCFLwzsY3XNETCtL6QQQGQgy0+C0eI9qNIZhsMCpgeZeC1X+kskV/iLu6cmq+AFWbjo+VAzS
	sxz8Oid/rE7Ut+AyASFq+LxEfdz5hguEtKx18z9r6Qwq2B1ra1LInUENo1LY7i/GY+N8/2HaAp/
	Ca5HpQ5JZJDC8SV0MGO+zO6MDIRBoVGkPbbLOKNcFW+p2RHvw==
X-Received: by 2002:a05:690c:6891:b0:79a:3d7f:e8e0 with SMTP id 00721157ae682-79a3d7ffc32mr86614677b3.19.1773715857192;
        Mon, 16 Mar 2026 19:50:57 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a5a866c85sm14951757b3.35.2026.03.16.19.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 19:50:56 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	dmatlack@google.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 3/6] liveupdate: Defer file handler module refcounting to active sessions
Date: Mon, 16 Mar 2026 22:50:46 -0400
Message-ID: <20260317025049.494931-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260317025049.494931-1-pasha.tatashin@soleen.com>
References: <20260317025049.494931-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36B5E40005
X-Stat-Signature: w5xerpnepto4rt66mc8i7pxsacmhq5dd
X-HE-Tag: 1773715858-289839
X-HE-Meta: U2FsdGVkX1/wWcQJUxMdnF3Zr7mNNqPu13idUOazyquSUix2lv+PFt3VAlbzOmFRJUXI5WCzwpe5v+mLm8Xkg2pdq3NgIQ/Aop7MhCXJ3nVBInbNjrG0Zs0jpeWl7SgdG9RjRbr/4N2ez5Bgow7iKdi54nOPKTSiYBYHNHvGzmy9g/3SWyTq5QuJIJbw+4Ah8dt9LnTrfUwMfMdhUUWQweFIskwRFQI7DrLXgbIP6mbNkooo79w/jjpSSArBsQVD6KXT8/Tg4vw6G4wugkzaEHLBB4urfOLt2wETiLca88xfkecoygeVKhKjg+16ISoXRSib1gOadVlS5G20C+YdS4Yckoecxn2VqLiqPWz7Kc2W8tc8Vv5o1HHS2mqwVoMXo2FeJ4zcIOpxQ95TKytQtxWGArae78QkjnWRoXFlOnXQt5RPWqTYj2p4wp8LJaasT0lbhcJJRhVm5FAfiWjakvD2OCNOEh+NdUinludYn4pAlC5X8zGjAedtr2pKI6VW0OxauqEXGCYVrAREn5b3R0nig1yimzvb6OB9W97cmdCb+AN8OaQg/YkEKJz1dGo48EjWbO9TcugTbjzWDJJrchq5kDmqnx5wtHuZm9lsMPFhTjtt8XxtR00T94I7zZW2Meg5AsIod9rFjqKDqP+heHKHIuF5lGH/yEpJluTzg6djZku99H/2lFpEdVRP4ivzLIYTPnSueNCJL1LUWZ3/SMT7WOgKhifnZDCLQID80pQDvdA4EequJZvNnmHUtQf7js+HFc0Zg1ErmpfGsGzQgxoSgC8rEJCMDejNpsEzr3ghH5cn+I9D4q+ymkRd+lz5MqxxtzSt7aRdYg4uYKBaSVAsp6v3jr8aWsTwFziyUD9vxANMGnKCK+cP7sPP/S0jDXIqHtia8g12kM7y8xGtKZAD0nAW7QrzAEQT6wuTzbe0Qcbwn56495peVDRIs7Px/dgsGOnwRobe7PZ66s1
 bts4L6NN
 j3+8dgMIuwcYjoynyuolk8SjF6gHeXMyfJzMq9bDiB1wUwH9wvRKt1c2ERlMpI1+zUXIVKpdoXDe9e8W2w1kQMUjd+TtV8ESKmr1WhhTLrxKNXFFVNugUO7tK9neKpAxgMO4pja5vcZRXkWVi28EnRxy720ZCjf2l6C9HVVTP/61FMDGsE+L5FDpzngzpZUZ0sNga7NDHTmZe3ypF5Comoo/rj5kOT8w7t9CEL87thBm0p7leEX5jX67KKJHrZBREDDxmFFdDMpEQQS53YAUsWabwvaaRgoIiZZH9m+7YfR/ulISltXaZ86WyFTbJYJzKQ022BFzVqoRHikE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop pinning modules indefinitely upon file handler registration.
Instead, dynamically increment the module reference count only when a
live update session actively uses the file handler (e.g., during
preservation or deserialization), and release it when the session ends.

This allows modules providing live update handlers to be gracefully
unloaded when no live update is in progress.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 6a0ae29c6a24..6b2b49cb375e 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -253,6 +253,7 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
  *         -ENOSPC if the file_set is full.
  *         -ENOENT if no compatible handler is found.
  *         -ENOMEM on memory allocation failure.
+ *         -ENODEV if the file handler's module is unloading.
  *         Other erros might be returned by .preserve().
  */
 int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
@@ -281,7 +282,10 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	scoped_guard(rwsem_read, &luo_file_handler_lock) {
 		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 			if (fh->ops->can_preserve(fh, file)) {
-				err = 0;
+				if (try_module_get(fh->ops->owner))
+					err = 0;
+				else
+					err = -ENODEV;
 				break;
 			}
 		}
@@ -293,7 +297,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 
 	err = luo_flb_file_preserve(fh);
 	if (err)
-		goto err_free_files_mem;
+		goto err_module_put;
 
 	luo_file = kzalloc_obj(*luo_file);
 	if (!luo_file) {
@@ -323,6 +327,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	kfree(luo_file);
 err_flb_unpreserve:
 	luo_flb_file_unpreserve(fh);
+err_module_put:
+	module_put(fh->ops->owner);
 err_free_files_mem:
 	luo_free_files_mem(file_set);
 err_fput:
@@ -365,6 +371,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 		args.private_data = luo_file->private_data;
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
+		module_put(luo_file->fh->ops->owner);
 
 		list_del(&luo_file->list);
 		file_set->count--;
@@ -649,6 +656,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 
 	luo_file->fh->ops->finish(&args);
 	luo_flb_file_finish(luo_file->fh);
+	module_put(luo_file->fh->ops->owner);
 }
 
 /**
@@ -783,7 +791,8 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		scoped_guard(rwsem_read, &luo_file_handler_lock) {
 			list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 				if (!strcmp(fh->compatible, file_ser[i].compatible)) {
-					handler_found = true;
+					if (try_module_get(fh->ops->owner))
+						handler_found = true;
 					break;
 				}
 			}
@@ -796,8 +805,10 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		}
 
 		luo_file = kzalloc_obj(*luo_file);
-		if (!luo_file)
+		if (!luo_file) {
+			module_put(fh->ops->owner);
 			return -ENOMEM;
+		}
 
 		luo_file->fh = fh;
 		luo_file->file = NULL;
@@ -873,6 +884,7 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 		}
 
 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
+		init_rwsem(&ACCESS_PRIVATE(fh, flb_lock));
 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
 		list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	}
@@ -922,7 +934,6 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 
 		list_del(&ACCESS_PRIVATE(fh, list));
 	}
-	module_put(fh->ops->owner);
 	luo_session_resume();
 
 	return 0;
-- 
2.53.0.851.ga537e3e6e9-goog


