Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ECE61061B0F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8376B0095; Mon, 30 Mar 2026 12:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AFEE6B0096; Mon, 30 Mar 2026 12:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED096B0098; Mon, 30 Mar 2026 12:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3F46B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:48:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1A06C2355
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:48:27 +0000 (UTC)
X-FDA: 84603312654.09.1F3BA46
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id EB6B2C000A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:48:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VZp3yRYJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774889306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sG9DgsY3olsmyDsu0A4WoI8JUqxgp2EL2EN+xPxq65Q=;
	b=qZX71pcZliBYgh9MTTBhFf2ZKmibYUs/SLIC4g1kJcWF2gMYfgYIHSK6+t3qmjjtnfme3h
	YwcXSZhqSrsjSTA5cNfF0CLiyHKCLfHinTu3oHZji3tbNPG3o3aCrNJ1A1s3PMcWQd0SdB
	7NT0BBA6NPg3zImwUsOE+RJZ6l3fEo4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774889306; a=rsa-sha256;
	cv=none;
	b=KWHlDkcB6UrEZKhDavl0EbYohcpvQIQcJpkAAImznwAgfuOVExDp9zMG7PsJyJ0ZZ7Dv4y
	I4d0YmeHBqaCcPhD/fMb7GlRVKumInNohFl6je/QvhD1xEvgFrp9bP6OoSEiV3ouko4t6t
	95H03a0VhCqz0j/w2Fc0x1YHZKtuv5A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VZp3yRYJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=skhawaja@google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b2591757fbso4675ad.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774889305; x=1775494105; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sG9DgsY3olsmyDsu0A4WoI8JUqxgp2EL2EN+xPxq65Q=;
        b=VZp3yRYJR1FOAm2TBQoO6c03ClEfcbyBW2rxspbgLrpsMOfyD5XMkti+KxaO/lm3C7
         yQizubhArpqMTp1u5L5XsjHbwpalVgExEWJnQHmn9PIFjZUlM3rafd/9bNa1wHot+kor
         Do3Hy88gIdqAi6u00f8iChvpraP6ODTLRm5XfXUlTymMYjruXDIubMHWoQL4bPePCdDj
         rjjWCpmSgVyybaYOMheHDNOqpnPSsNkfgeSvWMGI6ZprfTyrnsB0j9+Xftc3uao3WAhO
         gTzdfvD2ydmWXjRsT1Mkz2zA4qbxQUvC+WH0ajltoRXC6XZ1RcKoFibcoHVD+IUhsi+p
         z5lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774889305; x=1775494105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sG9DgsY3olsmyDsu0A4WoI8JUqxgp2EL2EN+xPxq65Q=;
        b=kR+FcRCdAQOnkBUqr3Orx7R8+P4X4eqIALsTOPrfo9lKKzjy09yNjy8Ee36p6M9fcZ
         qRaZUUcNTByjRmbcOru22vLuitLlVfwcV+v/+fLEsFMFEA3XKEPHWsT83CXBrkMt/ERQ
         WjDjiml8uqB+EQd/m//9YWayi2hQKnyByrmOlbsH92CGyQoW2wVSE+8ZQgPxkqV5fLza
         99Bz28kXyizYC4Po/+IOEguXAJf75kRVZ23QtXdln5CGlxo2Rj7NsZnZZ6+quTA/nDpA
         X3VygZvuJFdGQjI502cmeaUN0A1RRnntMnOsNNnmHWOKUu742Chg7DgH1r9RtojzIeeP
         CRXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxYRI278M2HQcPshWJiFUB/vnFigz7Oc55t8LoaJJOjg69fJgTbGMiZBCOYlMKGRCrzo0EXfxYvw==@kvack.org
X-Gm-Message-State: AOJu0Yym6uSqhJ9aqVa0UgB7CZJ1yH4Blmo3bIMFwfGNw4HQhuTbkTQe
	YXGNW25KQEYd7tRe8tGFqYRYxJ8+PTHw9PJerANdOr2iHCXWiSlY6qP0YYA8jgkHhQ==
X-Gm-Gg: ATEYQzw2zu3UN3tNqbCFKdgsPzRtardFcYIUhfkPFHayaxKNXR7BfjBFvPArA8vgj2I
	FhlWqs56lEcbFHUwEP8aa9Laom9W/bhk6uc3X9iAuruZY4iEWfA3ZDllSLL+oUHxWx057CNu1SH
	I+p7u6JuLvI8RfJmzIwDfBWTbhNqIyDFSWIsYH/83XMVqRJfF6dE6AznRzCfYvKa0T3u6kFw0Pc
	r+rgfGS9G7reVZQusnDc1Uc9FNeuo2D725pBshE7FZx1HN+NZPOY2ZgQxxScntJqF2YrfQlGDba
	kSyVpaXPnbznR1Eo48nVZyu0Tuyzx/Qssx82EZX0UHQK5Srow6jfRQ/DU5jO/xJ5iwu0rNmFMrD
	ygQltLnIuajH5o3vnqoGxv7+KboYhAQIopfCcHybs4DFhDN6zHfTwV4Gq5Ps0GYoFqi8ZFKwyav
	atY8jI4C4Pi7gOiYYLhkpigztUeoRxibM2yBEkhkE6bPZT0pRMafKB6gzBdam7gw==
X-Received: by 2002:a17:902:f78a:b0:2b0:be7d:a25e with SMTP id d9443c01a7336-2b241d59313mr775145ad.18.1774889303958;
        Mon, 30 Mar 2026 09:48:23 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242676e13sm89196535ad.28.2026.03.30.09.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 09:48:23 -0700 (PDT)
Date: Mon, 30 Mar 2026 16:48:19 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, pratyush@kernel.org
Subject: Re: [PATCH v3 03/10] liveupdate: Protect file handler list with rwsem
Message-ID: <acqnQ64U8Cxst-ce@google.com>
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
 <20260327033335.696621-4-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260327033335.696621-4-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: EB6B2C000A
X-Stat-Signature: dgfit8tmkg4x5foqdh1yw63qk454razk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774889305-304594
X-HE-Meta: U2FsdGVkX1+1beJHPVv6Zp7FUM480p9XbjVGMRPXGKV0UYDPviIOJcEb5vpNYtBwlLkkJtL/yVWnSGDWlgim+E5LnKj/WU+klW/c7tsJYfHBx40qimHt5ST75NQ79xDDhlcNwlS2oRz9DJRfnmM32meHxovnSSS50BsY5d5tRs/YZyApjkP8mab6lzAonXx3zDlf2xi/c9QWbJ11ZEtQe/m9zI7SI0Mpm+jGIjuAE1NYdheGUoCWfPkkiUEEM9ibs+fdlGX4OOcpDk3Hr9lmb0WCMeKzCEVWIwhQGmigK+Zf0m5BnzUYr/X7ZMFp+F4M5oKvNUwRl+8eJ2q2l13fDwkzYXiChJFbkM5XElIbWhi36LqBqylAskn+MM3q3eHhksXRauPLJ8e1sIq1gkyNGR1thsK0YNv9PMiZPYGDUhyQPh53ZybqiwQI08abyqdrtLzuo0dInnHTI0I9V/fpv4yfagBiNzZOcybJtBC9mpWHikELbXV3g/Eblx2z7PAugpuDO23iAHKhA5oKzveLZD4rXX8mSqowL7Ls5O1sTeZk5uLgX1rPsx4asgYZj0b9KIIfyZyKkazxZB9GHebZ5QwuYBZ8bAhgscJ6vXLHtnTg9Q5X6SJrBWnDSKkS49qq+Snyy7P7LBF6unpZH0zN30zOPgc45WOzJc+mbjEVMahAvJSI76aL+nVlv/eh9ylxpK9il4JoS1OMnbrXs8075C8VnDuzOPgmlS/ZMG0zJuUCStvlPxnmn0SVEON1YCvegLtI5PRcMW0rLi9N5m9/jYrOn421F3u7c79facUY0H+X1rufgHQ8tAuDJ+8Zf++iJyDLsGGmylxdX4p9Tu6ym+idYmCxjTuWwM2qyHvJEadlOuUfmn6eIcrhrGnShVRlDiHqGmc53luTtFnuGYYpJIyUZi4Lz1cUH0c8R1zhkG+I8m59Clf7cJmsv5mwcwUp5WW6Gx+bg2Q7SxqWqOt
 sglv89a+
 86cLzeVMyFW2sH/ZPSF4XdvLr73YrdFvraYNPjBzF+01583CZUdhrXFoniOk83zkZavrb+fC0ZRI9OPvmQ1NYRPg7bCIUgp2uHYEhuufCn3513Jeyhn1mtThS5O+VK/d9u4fUiTzxPeljRqLtHVy/P7PGauK+OxEmqR027CTSj2sM+Ojw2ISJqQu+mTvPhTzpqJ+Shz06qtIqMW/l/2Q3xFb6ru8oLjyCBOLRMgrFo0FMDSMYqKAWpZRGj0C0u7Acp3f+XF1aMw5MGTTLDw63Tn0mRttFCzCy3K7WqaTf0oSB76QwNr/trQ5XzECAftxkxM41I7Myk4qy78ueyvTQy6ahU6YU3FbOmD2C86jILFsgGFFlpuyAr4Ry4pKOYYBB8eXr8TbiLuOd3XLrVj4HO0cregBt7Ja6D+n4VYY8LWg0aa4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 03:33:27AM +0000, Pasha Tatashin wrote:
>Because liveupdate file handlers will no longer hold a module reference
>when registered, we must ensure that the access to the handler list is
>protected against concurrent module unloading.

Nit: Here we make an assumption that the file (and flb) handler
lifecycle is bound with the module lifecycle. It is a fair assumption,
but maybe this can be documented somewhere?
>
>Utilize the global luo_register_rwlock to protect the global registry of
>file handlers. Read locks are taken during list traversals in
>luo_preserve_file() and luo_file_deserialize(). Write locks are taken
>during registration and unregistration.
>
>Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>---
> kernel/liveupdate/luo_core.c     |  6 ++++++
> kernel/liveupdate/luo_file.c     | 22 +++++++++++++++++-----
> kernel/liveupdate/luo_internal.h |  2 ++
> 3 files changed, 25 insertions(+), 5 deletions(-)
>
>diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
>index dda7bb57d421..f9ae9364a962 100644
>--- a/kernel/liveupdate/luo_core.c
>+++ b/kernel/liveupdate/luo_core.c
>@@ -54,6 +54,7 @@
> #include <linux/liveupdate.h>
> #include <linux/miscdevice.h>
> #include <linux/mm.h>
>+#include <linux/rwsem.h>
> #include <linux/sizes.h>
> #include <linux/string.h>
> #include <linux/unaligned.h>
>@@ -68,6 +69,11 @@ static struct {
> 	u64 liveupdate_num;
> } luo_global;
>
>+/*
>+ * luo_register_rwlock - Protects registration of file handlers and FLBs.
>+ */
>+DECLARE_RWSEM(luo_register_rwlock);
>+
> static int __init early_liveupdate_param(char *buf)
> {
> 	return kstrtobool(buf, &luo_global.enabled);
>diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
>index a6d98fc75d25..4aea17a94b4f 100644
>--- a/kernel/liveupdate/luo_file.c
>+++ b/kernel/liveupdate/luo_file.c
>@@ -277,12 +277,14 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> 		goto  err_fput;
>
> 	err = -ENOENT;
>+	down_read(&luo_register_rwlock);
> 	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> 		if (fh->ops->can_preserve(fh, file)) {
> 			err = 0;
> 			break;
> 		}
> 	}
>+	up_read(&luo_register_rwlock);

We took the read lock here when running can_preserve, but then we use
the fh without taking the lock later before calling file_preserve. This
is safe since the module reference is taken and fh will not go away
(based on the assumption I mentioned above). Maybe add a comment here
that documents this assumption.
>
> 	/* err is still -ENOENT if no handler was found */
> 	if (err)
>@@ -777,12 +779,14 @@ int luo_file_deserialize(struct luo_file_set *file_set,
> 		bool handler_found = false;
> 		struct luo_file *luo_file;
>
>+		down_read(&luo_register_rwlock);
> 		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> 			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
> 				handler_found = true;
> 				break;
> 			}
> 		}
>+		up_read(&luo_register_rwlock);
>
> 		if (!handler_found) {
> 			pr_warn("No registered handler for compatible '%.*s'\n",
>@@ -851,32 +855,36 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
> 	if (!luo_session_quiesce())
> 		return -EBUSY;
>
>+	down_write(&luo_register_rwlock);
> 	/* Check for duplicate compatible strings */
> 	list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
> 		if (!strcmp(fh_iter->compatible, fh->compatible)) {
> 			pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
> 			       fh->compatible);
> 			err = -EEXIST;
>-			goto err_resume;
>+			goto err_unlock;
> 		}
> 	}
>
> 	/* Pin the module implementing the handler */
> 	if (!try_module_get(fh->ops->owner)) {
> 		err = -EAGAIN;
>-		goto err_resume;
>+		goto err_unlock;
> 	}
>
> 	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
> 	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
> 	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
>+	up_write(&luo_register_rwlock);
>+
> 	luo_session_resume();
>
> 	liveupdate_test_register(fh);
>
> 	return 0;
>
>-err_resume:
>+err_unlock:
>+	up_write(&luo_register_rwlock);
> 	luo_session_resume();
> 	return err;
> }
>@@ -910,16 +918,20 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
> 	if (!luo_session_quiesce())
> 		goto err_register;
>
>+	down_write(&luo_register_rwlock);
> 	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
>-		goto err_resume;
>+		goto err_unlock;
>
> 	list_del(&ACCESS_PRIVATE(fh, list));
>+	up_write(&luo_register_rwlock);
>+
> 	module_put(fh->ops->owner);
> 	luo_session_resume();
>
> 	return 0;
>
>-err_resume:
>+err_unlock:
>+	up_write(&luo_register_rwlock);
> 	luo_session_resume();
> err_register:
> 	liveupdate_test_register(fh);
>diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
>index 8083d8739b09..4bfe00ac8866 100644
>--- a/kernel/liveupdate/luo_internal.h
>+++ b/kernel/liveupdate/luo_internal.h
>@@ -77,6 +77,8 @@ struct luo_session {
> 	struct mutex mutex;
> };
>
>+extern struct rw_semaphore luo_register_rwlock;
>+
> int luo_session_create(const char *name, struct file **filep);
> int luo_session_retrieve(const char *name, struct file **filep);
> int __init luo_session_setup_outgoing(void *fdt);
>-- 
>2.43.0
>

