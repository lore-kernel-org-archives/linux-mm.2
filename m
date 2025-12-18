Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C9A0D6E2AD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40076B00A0; Thu, 18 Dec 2025 10:58:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2F46B00A1; Thu, 18 Dec 2025 10:58:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC886B00A2; Thu, 18 Dec 2025 10:58:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8926B6B00A0
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:58:03 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49EAB140276
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:58:03 +0000 (UTC)
X-FDA: 84233048046.19.28E5482
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 776E1140003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:58:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Y88MlzTr;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766073481; a=rsa-sha256;
	cv=none;
	b=wahkjoPejSEGyZIMgqjT2+nFBtpvzkZSt8ToLmrIBs5jY3xlR2MYmqeMNHz1PZMt1jP6BJ
	ICVdzXrjFnibapCP5OKFwBs9783v0OOugeCOL93Gzblt1UHLd3NbaUXg/XDbZLMCfJTxuF
	llYbL+8x5SLZOTHCmlv0pvRZnEAqcAI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Y88MlzTr;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766073481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4Z1msUY2rAxWdAtpYqttwDLBLeupKQK68y4s4x3GKw=;
	b=ufSygYnfOfjoaYvRBXV2aQ4xoK3+K2c4ZaM9vQnhwMdgxr+M8BNYsJrbRECinlj+j1TMrL
	AX1dJGEARYj2dAMmD7DNORSqqk9dDKXPZp19X7E3AhLGSlPRFKMG7E0sWlTXqT9aMyp+cg
	y6XWGqtk/AJ7MeItDHfFkqTaw1OxCkU=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-786d1658793so6567037b3.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766073480; x=1766678280; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t4Z1msUY2rAxWdAtpYqttwDLBLeupKQK68y4s4x3GKw=;
        b=Y88MlzTryZl6NC36WYA7VstyJ4n8pbNK70es5ERnF8BmpMp9LZksDuvyh8EKe0Z9JD
         kNC2cef1O4OeycGJgZBCd5bOEE6JAWXueP2RmRHxUXEsKq14TZwdViwELKWoGU25uKT8
         PuSbajvMjTfVhLDxhDyPUGXU0zKHWvmtyWqJqeEFujl4l/v5rhXJMz2pdODNEr9znzYX
         AxKi/yKOfFpK0b3hHfhDT+x3YNiPn50zareFMppZ9BtA/2KvAYdlTdLPMZl04ndUIbit
         81IwQea/sqobdEr50IH3E53h5rmu61E4WHQGQ5Ne40Ybdhwe2D75mf2EKi2v4Lnd9W7q
         g+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766073480; x=1766678280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t4Z1msUY2rAxWdAtpYqttwDLBLeupKQK68y4s4x3GKw=;
        b=oCadIkWBeAiRTA+4R34kXnAgP3Qeqw6sbkzsuO3qoVzxohPyu62JZCVNDuwPScwPl8
         VMw3zrvlT9RV9kr7wSpUonXHLPx+BO4by7Xahgy337b4Ts25v0r9fvw0AY9d3Ds0ErC/
         sSN+cJTgoEA05Lfi5FIxhrFEEVFmQvLOce7ywfbUYokQgJzNN3LaLPEzyTueZmK3KoE3
         TezSAMnrTtxlFkdsOnu2hnKhQWIDyYRMN5LqJitTtRq7ENAN4Qga1OA91x/EagbR+xyI
         1XYJW4jgpXUxLO+Nvt6I27D/Abbg4pp+Td288oh/oizrgPw9n2NTXmfbng9ScROjYktV
         svag==
X-Forwarded-Encrypted: i=1; AJvYcCWHeaWw8c7fUOOX24OZ7XF8KMSHDcw0dBH+rJ6ATjJfE3nso0XJmUyPWVFU7PMxGEM+g4e3K3UNwQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+JgAyLtM8YxRpJkfN1XzJX8/Dzn9qHQJ6bDQPob+jyeqS5wUo
	CYR5ce9iODDNGvnX39sxT1tt9B/semhx+xoGolNIySy/FuNVnWnzz7MJ+B022At8b9U=
X-Gm-Gg: AY/fxX4gt1jsPbAJrCeerjb39ayFM4ZGo5m713llB1cBuheRs7ysSlauBYv8w3kshNw
	5cxx+5IhnW5R3LZx2m00oE52pGUFtDb4mqwiDtK7EQ45offHJFnH40IHErRuqHo9VDRy4OKV3B3
	yy8uH0Iad61MzrNUMqC6sObYs4XMf6uJrJFEMylvIjCZ1et53owlMvlHEJudeU6NNTCxQmzVKEF
	4a8htzm4x2F/mspnKa0nuk6mMuqOrI9D0bxkpQjbxW6vmgBRGPahIG4y2C5plr2RQc7noRJOi3a
	+SEqQEFxlm7lXfEk9CvOZFoi7eblzxyvYsng7Ic5mc1zohZVCtIRYFIAFQ5aBWpsRcdorr1diZ4
	KHfCLCJMXpwlhbymywbpsYuwQTgAyVwJuRVl0CCWRHAFCayh6UtPOyQepe+lJBh4jKliALS3Ehs
	Wsw2jdCw2iEYkXaIpkBScn1JSuFrDhWWXoOZdy5xwD5YVtGk/xoHZ/Id2nUcaUV8eP4+x5Ai9eK
	FFiqlgpfL6tvkQRxaRrgR3mDIDwKh21QjflvA==
X-Google-Smtp-Source: AGHT+IFWhdACNbagBIHkwDyaADUMWOMF328GmPZhKrlu7OopueUq4wR0Bm9AacSAzm29ZXOrWmckMQ==
X-Received: by 2002:a05:690c:6505:b0:781:32c:b359 with SMTP id 00721157ae682-78e66dc90e4mr367785787b3.36.1766073480552;
        Thu, 18 Dec 2025 07:58:00 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fa6f52bb2sm9348467b3.16.2025.12.18.07.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 07:58:00 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	skhawaja@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	akpm@linux-foundation.org,
	kees@kernel.org,
	davidgow@google.com,
	pmladek@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nicolas.frattaroli@collabora.com,
	linux-doc@vger.kernel.org,
	tamird@gmail.com,
	raemoar63@gmail.com,
	graf@amazon.com
Subject: [PATCH v2 3/5] liveupdate: luo_file: Use private list
Date: Thu, 18 Dec 2025 10:57:50 -0500
Message-ID: <20251218155752.3045808-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.313.g674ac2bdf7-goog
In-Reply-To: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
References: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 776E1140003
X-Rspamd-Server: rspam03
X-Stat-Signature: dznz9e9xc6nmo53uncqqp44n949zz4ts
X-Rspam-User: 
X-HE-Tag: 1766073481-504668
X-HE-Meta: U2FsdGVkX1/xSs7z6ufIRbWIVxN26hvleEZNbO2nnnIPxK9Rb4zZuW2G6sTjh8SSsYE19+9yOvvNVY8KWDNxlOuJq6dGzeWQspGS8zf1I/BdW8UXn3Clb5GeCfn5eJnH7lp+8cRh+0OPS1BcjvDuYvbm9n0q/GEHzmQVzsyxcECMW4eqzLt0J30bbVHr4Vh8PS7YW06BX8MOjz1R38v2pw1PpW/2aUVnTS+4hqoWkaP8NBj2kSvtGCwf83RsOtWO0hBjRgDiqVWLzROxdeOYvsW9xl2IZkEbC/D2g1HNGUnhP2ck+5Xi406fD1/Sq/55ORVxbGqdlnA2Hq/oQgatM64/Cie3xFmt8W1cJCkbLj3n3chzZUI9Nn1k8aWHQUBAFU9OnPa8OBnev7rEe9RtqbwCdzDxzwwXgHdP1iU+hF5rviGqAJ5Uj4kgR8RdkLQ1XEhXVs96X+9G1mcW/ISOtAtazxuIQm10o7fIPH9GcPYmrIrQZ7g5FLCW1KguF0LdZsH0ogpIH7zp7m7fLXqfdJxILKdTOypmK68geH/fOvzb7V51AimOz42/S8MSrmqCAVEj85AJBPX2V5/RBfD1yy055OqiLqg95vjjAuZd/CNIflNCCUd3i8md69TeBAg4VX5GSZs0kEPH+9dmfIqbQgHF9VAigyjturQKj3aZoi4yII/lZiVrQqby0MH9v2bqOl8bn9uxMsr1HdpqFCQEcjSY073aCZjGrjOCrq6AZlodHxSLR2YwWAQjGg7Oa3Q9K5t2LCK/RTywCwY0/85WOGqb+/L/oGC4YYVPbYDMFNqGYg7Ad0fv97Pn41IVjdYltIlbjYNo0k71hqw+rs9r4TssWoD0YFe9V4MWM9vODbMwgqGS9DdxtfCj/wvh+nfL3/yxpJaNDdHyHonsvKIaE7XTI866AtX2/xI6TGsf5efZwktitbp4U9slbDnYsrfNWy05wJuVagRlHZiYF3I
 2ijpemNy
 yhY+Vw03eFbNVYoihAPkBWoCa9hn5lo4uXyBkXyp0zdiGjZ8N+lRdgfo4ZCMpiyXXsXWaZ14Ub/5uNYUq9VdoRJrs56bKaXko2rDqknHPl/jvIQli1K/CWV2Ks5wcKDe/W/CZEtjDeeNJR0MtzLYEWpebOGUINj1soMr3YVHOTARbi2iQSyxjCTO9weX8pOOJzQOEdk6fqjnh8XXfGNyjd+QCoa/FXim7VhwTSu5ZuS+Zh5PwZhPgApX3EV9c/R7uijSF8J8KkfNDK+VWYr217QgIa11gsYsvzhNqQ36rOSoQY63GPmuVX6J3ZKMKxHCgGi6qof9mJ5j+YOkyllSypa4YbZAWq/t0djM2lFdl+WluKoRQkB9ia7+jK4vac/wrztmll9z5iN824pwh4WvORPCKIr0vqtaDTVbJvYHDvojGM1t5yZFnoNSCm5tf7HQZhTQu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switch LUO to use the private list iterators.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c     | 7 ++++---
 kernel/liveupdate/luo_internal.h | 7 -------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a32a777f6df8..1a8a1bb73a58 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -104,6 +104,7 @@
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/luo.h>
+#include <linux/list_private.h>
 #include <linux/liveupdate.h>
 #include <linux/module.h>
 #include <linux/sizes.h>
@@ -273,7 +274,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 		goto  err_fput;
 
 	err = -ENOENT;
-	luo_list_for_each_private(fh, &luo_file_handler_list, list) {
+	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 		if (fh->ops->can_preserve(fh, file)) {
 			err = 0;
 			break;
@@ -760,7 +761,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		bool handler_found = false;
 		struct luo_file *luo_file;
 
-		luo_list_for_each_private(fh, &luo_file_handler_list, list) {
+		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
 				handler_found = true;
 				break;
@@ -835,7 +836,7 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 		return -EBUSY;
 
 	/* Check for duplicate compatible strings */
-	luo_list_for_each_private(fh_iter, &luo_file_handler_list, list) {
+	list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
 		if (!strcmp(fh_iter->compatible, fh->compatible)) {
 			pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
 			       fh->compatible);
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index c8973b543d1d..3f1e0c94637e 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -40,13 +40,6 @@ static inline int luo_ucmd_respond(struct luo_ucmd *ucmd,
  */
 #define luo_restore_fail(__fmt, ...) panic(__fmt, ##__VA_ARGS__)
 
-/* Mimics list_for_each_entry() but for private list head entries */
-#define luo_list_for_each_private(pos, head, member)				\
-	for (struct list_head *__iter = (head)->next;				\
-	     __iter != (head) &&						\
-	     ({ pos = container_of(__iter, typeof(*(pos)), member); 1; });	\
-	     __iter = __iter->next)
-
 /**
  * struct luo_file_set - A set of files that belong to the same sessions.
  * @files_list: An ordered list of files associated with this session, it is
-- 
2.52.0.313.g674ac2bdf7-goog


