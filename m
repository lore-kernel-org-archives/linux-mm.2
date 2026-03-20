Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA6C41091931
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 00:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174D36B0475; Thu, 19 Mar 2026 20:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1266B6B0477; Thu, 19 Mar 2026 20:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C646B0478; Thu, 19 Mar 2026 20:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E59CC6B0475
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 20:21:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 969C55ACA3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:21:09 +0000 (UTC)
X-FDA: 84564536658.18.066FAA8
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id B01F320005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:21:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vee+ZMpj;
	spf=pass (imf03.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773966067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bSWC2c+6ov5jVqWIkd0yhypYy89vs1IKdCrAW1Ebqvc=;
	b=ABK0MhuIE0YDuU8RtI3E2SekBj4X2CjGDIWXGk2ogowpcU0yGGnFY0F6pvWYpTKxMGu5lo
	8xUT1ZHxMoJ4erXcipXtj+drgr+Cye1u6FCrl5zudQz/SxRcRlt61UX56DcihWyMvCbULG
	E2kc9AZWFKE6KvCozQRXNpX1YluzM5c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773966067; a=rsa-sha256;
	cv=none;
	b=t5DFSUx+DvBpKPjwIJu6NQg22XJxPJgSlTpBULBxtXsVvUcT1e2MeFg+bxK/AOYw8eJyvb
	CSUE2KsCTIz34GbkEyFjVJXkRXsma4JXoitzl5+UjQHqlgKifTmNzCTpFklvWaAJKBoyXy
	b01BdEolbkxYdmUApqptCXwBIgnO/hc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vee+ZMpj;
	spf=pass (imf03.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2b052ec7176so22455ad.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773966066; x=1774570866; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bSWC2c+6ov5jVqWIkd0yhypYy89vs1IKdCrAW1Ebqvc=;
        b=vee+ZMpjtIUBIlIRb0uvPb3A1r//Lhi1DOuvwlhboISe0CZnsmM4Bb3+AUgdXNlwkb
         ci2prBfWHRnU5sz8vAuMHk+8gBYuJSqtOcs6lL0u2IFZytrtIz0a1IygeJrzmk4nV6O8
         V2hpPoE+55EtbNQ4mAlBd9N2oXU82nPwQ0jRv3vllBTvLwgw7JMHv8CyGQHJZvLN10LZ
         axlvIHg0b5NfoRtBF1AN/hswUn9MNzvcpmOR5L6PBieGgTqCGOOEYSzq6pLlVJC52QHf
         WD6X90BdVXvez8oh0P2XoMJphY1WcDvQbn9JkXWmABBsgHjgRDB9C7MRkxHo9064uGwJ
         TwLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773966066; x=1774570866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bSWC2c+6ov5jVqWIkd0yhypYy89vs1IKdCrAW1Ebqvc=;
        b=cQlpJDlqssEvVaE+gBUL+zepE4rt5MbJnNkou+EuSv9WhyMuVv609VmFEUwk2jlmI4
         LsdC+1xS1XTxvLUmD+pJXFrEDMlexDIwLV7Ythtf5FdF6tTTvGsMkpu7DdOZ3FN+RUZj
         Rr/VGQ5mrsTTuySALwEyos8CfDJlFlu2Aod+GPG4zYPMF0vSXz3NuKOnb95kNTi/yNDr
         5AN67BrYny8YrMGhyvqAL0DZH1MLGKf7eOCGPoV5vu3RcEy/k6ZK/rur/mZ9cLYKxGYv
         ofp6rOl+k97YrNfTxW1bbc1DOYaflKtMeyoj5DtNy8JUiK8CXGOHJ9YFLCPFJYyYskhk
         czMw==
X-Forwarded-Encrypted: i=1; AJvYcCUgzFzQs5E3jxT23BSJ5xaVHmQp22s92RkeG/jud+8dKQCMRxajuT2I/+YFTtRw6V0oCqr3bvKjxQ==@kvack.org
X-Gm-Message-State: AOJu0YyIbYJBL3F5H0vR8yh1xY0wVosZPQu2A6woa6xL+h1McH3foWPC
	O4otEKUdszL5zKg7+cp+i/5Ee+1H8XsdwNMbKXEib9yXi8JtflvDAUySlhuiPJWEAA==
X-Gm-Gg: ATEYQzztc69Q3a3mtRMbuaF76Q30dFbr2ImSQDB9hdrIpcgbars0yLG4tod/vKqP7KI
	6gB3/G/CfvZwo15Kfnw5+OwOskNSueiYoDbA0NAp8RoOHQ1eg+60+/9IMlcWKfVUHnS1HQeo1R7
	gkTLI4S5sB7XYqDR1n2EwSM3oIog0vBrEWaw+3+p6tCiBKJXM2D4ov0ulGCdVuqc5aG/0wzLvQv
	gOEPFj5dCiinWd97ZxT3UN2WvSKeMs/AEVF/0+9nHJiU3XsJuYkpFcOGFi2FwpRAGha4MKhKcP4
	lbgnzP642yoxYykZeI+l0LYPWEogf/Xbalsatu72q2n3ARJ8cPtLw3FZNcb8Auf7Uerj0Hqfk7g
	3q7Oct+gCmfCMxwrqnSIn05fDTh7juZidfR7L4Qm2K4NHs8M16MfU2w+6JgriVTFv0Lxxr9QaBb
	QB6t0mjYjD9YMfhTB1cj/arfAqPuw5uziVaeJviBbgfU2HacMxTTqreSE8KYdMvg==
X-Received: by 2002:a17:902:cccc:b0:2b0:4d40:ce18 with SMTP id d9443c01a7336-2b0828a92e1mr1264855ad.14.1773966065751;
        Thu, 19 Mar 2026 17:21:05 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b040da3easm319482b3a.41.2026.03.19.17.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 17:21:05 -0700 (PDT)
Date: Fri, 20 Mar 2026 00:21:01 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, pratyush@kernel.org
Subject: Re: [PATCH v2 2/8] liveupdate: Protect FLB lists with rwsem
Message-ID: <abyQJ_9xDg6GrU4X@google.com>
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
 <20260318141637.1870220-12-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260318141637.1870220-12-pasha.tatashin@soleen.com>
X-Stat-Signature: xim1d7aakjz9bgy37qmac71y7718xogz
X-Rspam-User: 
X-Rspamd-Queue-Id: B01F320005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773966067-898025
X-HE-Meta: U2FsdGVkX1/Chhu5YeLJLauQiBe4DzBsIqyz6bVTsvrQTnWVrC8mP9OD6izMfP9EaUcU8OZNITueqVnQdGd8UHdGlJBsP1rRUz5cvn/STglHnxTJaF1SYAlx1P9fl4MfIK56SiQvaETcG3h8oAdEu546XHc8wsccqwzwqcd56kqqnZfehMozga6kc6/RC7cvT8OasugOQ6U3VXXm559H4tsmmQpvFTWfeR4Vd7tnhvgROxLxuTVjjoxTDKv66MqjZVzZxFGDSEjOMfyefZDwXeOFFkfltsHaMVwG02oV4f84XxcMoHf/tVjoBrJhYXzcN8VD61dW/9t1O0qHVLkfQ7fux7gEPpa71houd8onGCevh4kgaxh9ZR+SK0N3yIc1sVo3zAjMaOpf7oUV1sNldZnxo/P17e8m5bR86MWTugmIOMvY85VVIkn14HAnTldPfWGF31rXxjjHfXMVUoakeIYSIbCmsePUqUXSB8k9mUlHH0Qau5joUTG3i6O8may1aTZgp8aS/tzKPVLkNh+qr5sNmhBn5ktiFgwPgmj1mPfgOR4bBj0TMgq/Nr656VnmK5oxL8JdkpIADgya+P8owgjwann61wnMXDiiXm8ctQnM+vTgKLkXLMrhek7EgpEt4m+0TpB/paWbao8Lc0wgHgtmw/7alzOgfDcOM4AYdC2C4YusViC9zoB9iY8SizOPy0l6wjGebUPrIOU3/P47jxcCRgcfeqAGeLvrPjWM4EokfAn2Zny1iZSOUEu5z8HO4I1IILMsoixUFKjYxC4oAK5HL38mLlb0kLkHUNAV7nWeoanoz7Vq+I8zjQMqBX3oMMJ/XuZFsOEZg8TiyjKELCm6lQTiNHO1cEHmfZY2pLJs71ArUK8Q9cMRZhZKQBc2sp6jrtyYaD8CT2ohIlXA0rYd+G++qmiNnUt5K9j/KMIbZInGBCQhNc5Hxllb0JQexkic6/gsg3pHb5uxPWo
 zNLzi5Fp
 pBYzdvJ4zoF7uvNfbHiajsgoTKiZM53PYKBRVzdDcXaL8nfjwvBaX7ynfxrJkrQOf6BU/bxzlG9EZuLm9uUQaCaAGO1si7IgRnq89E9mqjt2ujH6QhOWGScyROGlAFDXKVf24D0abmqwaaOOGcmcsCC8W3XPdNtH/OyXhUvp7l5IE4gUzKBopr8xBcAs50DmzTOIJjxYj0ybLnoOB+4U5vKrc5nDOFK94aZQqvIpbINLg10fYu1AAtDOnugldntCeto8IjwS1SWFdq7AnCk3hgnmzBVN1P2PiymBcINwhHHJE28KBYmY5JJ2Vtru4NEay7j3EHtEYOa5SHkyQ0Q0vzAyvwH1e0JxT/IlV1X2K6/t4RU1J8i2s4lHPZ+g5p3j7qJSlr+gAGEUXAwAOr3uIA2O3Pifx3fd/vLD72G8YvdS4Z3TPvJCxMzDpI7s3yLcQfArzjFusQhbympc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 10:16:40AM -0400, Pasha Tatashin wrote:
>Because liveupdate FLB objects will soon drop their persistent module
>references when registered, list traversals must be protected against
>concurrent module unloading.
>
>Introduce two read-write semaphores to provide this protection:
>1. A global luo_flb_lock protects the global registry of FLBs.
>2. A per-handler flb_lock protects the handler's specific list of FLB
>   dependencies.
>
>Read locks are used during concurrent list traversals (e.g., during
>preservation and serialization). Write locks are taken during registration
>and unregistration. When both locks are required, the global luo_flb_lock
>is strictly acquired before the per-handler flb_lock to prevent deadlocks.
>
>Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>---
> include/linux/liveupdate.h   |  3 +++
> kernel/liveupdate/luo_file.c |  1 +
> kernel/liveupdate/luo_flb.c  | 16 ++++++++++++++++
> 3 files changed, 20 insertions(+)
>
>diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
>index dd11fdc76a5f..8394fb2d8774 100644
>--- a/include/linux/liveupdate.h
>+++ b/include/linux/liveupdate.h
>@@ -12,6 +12,7 @@
> #include <linux/kho/abi/luo.h>
> #include <linux/list.h>
> #include <linux/mutex.h>
>+#include <linux/rwsem.h>
> #include <linux/types.h>
> #include <uapi/linux/liveupdate.h>
>
>@@ -107,6 +108,8 @@ struct liveupdate_file_handler {
> 	struct list_head __private list;
> 	/* A list of FLB dependencies. */
> 	struct list_head __private flb_list;
>+	/* Protects flb_list */
>+	struct rw_semaphore __private flb_lock;
> };
>
> /**
>diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
>index 6a0ae29c6a24..96fdd5790dcc 100644
>--- a/kernel/liveupdate/luo_file.c
>+++ b/kernel/liveupdate/luo_file.c
>@@ -873,6 +873,7 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
> 		}
>
> 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
>+		init_rwsem(&ACCESS_PRIVATE(fh, flb_lock));
> 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
> 		list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
> 	}
>diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
>index f52e8114837e..91910d806d1d 100644
>--- a/kernel/liveupdate/luo_flb.c
>+++ b/kernel/liveupdate/luo_flb.c
>@@ -49,6 +49,7 @@
> #include <linux/liveupdate.h>
> #include <linux/module.h>
> #include <linux/mutex.h>
>+#include <linux/rwsem.h>
> #include <linux/slab.h>
> #include <linux/unaligned.h>
> #include "luo_internal.h"
>@@ -70,6 +71,7 @@ struct luo_flb_global {
> 	long count;
> };
>
>+static DECLARE_RWSEM(luo_flb_lock);
> static struct luo_flb_global luo_flb_global = {
> 	.list = LIST_HEAD_INIT(luo_flb_global.list),
> };
>@@ -240,6 +242,8 @@ int luo_flb_file_preserve(struct liveupdate_file_handler *fh)
> 	struct luo_flb_link *iter;
> 	int err = 0;
>
>+	guard(rwsem_read)(&ACCESS_PRIVATE(fh, flb_lock));
>+
> 	list_for_each_entry(iter, flb_list, list) {
> 		err = luo_flb_file_preserve_one(iter->flb);
> 		if (err)
>@@ -272,6 +276,8 @@ void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh)
> 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
> 	struct luo_flb_link *iter;
>
>+	guard(rwsem_read)(&ACCESS_PRIVATE(fh, flb_lock));
>+
> 	list_for_each_entry_reverse(iter, flb_list, list)
> 		luo_flb_file_unpreserve_one(iter->flb);
> }
>@@ -292,6 +298,8 @@ void luo_flb_file_finish(struct liveupdate_file_handler *fh)
> 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
> 	struct luo_flb_link *iter;
>
>+	guard(rwsem_read)(&ACCESS_PRIVATE(fh, flb_lock));
>+
> 	list_for_each_entry_reverse(iter, flb_list, list)
> 		luo_flb_file_finish_one(iter->flb);
> }
>@@ -355,6 +363,9 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
> 	if (!luo_session_quiesce())
> 		return -EBUSY;
>
>+	guard(rwsem_write)(&luo_flb_lock);
>+	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));

Since FLBs are linked with file handlers and the file_handler can be
unregistered/registered while this is running, should the luo_file_lock
write be taken here? I think maybe we don't need a separate luo_flb_lock
and the luo_file_lock should provide enough protection if we acquire it
here, as a file_handler is supposed to be registered first and then flb
needs to be registered against it?

Maybe we can have one luo_register_lock?
>+
> 	/* Check that this FLB is not already linked to this file handler */
> 	err = -EEXIST;
> 	list_for_each_entry(iter, flb_list, list) {
>@@ -444,6 +455,9 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
> 	if (!luo_session_quiesce())
> 		return -EBUSY;
>
>+	guard(rwsem_write)(&luo_flb_lock);
>+	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
>+
> 	/* Find and remove the link from the file handler's list */
> 	list_for_each_entry(iter, flb_list, list) {
> 		if (iter->flb == flb) {
>@@ -638,6 +652,8 @@ void luo_flb_serialize(void)
> 	struct liveupdate_flb *gflb;
> 	int i = 0;
>
>+	guard(rwsem_read)(&luo_flb_lock);
>+
> 	list_private_for_each_entry(gflb, &luo_flb_global.list, private.list) {
> 		struct luo_flb_private *private = luo_flb_get_private(gflb);
>
>-- 
>2.53.0.851.ga537e3e6e9-goog
>
>

