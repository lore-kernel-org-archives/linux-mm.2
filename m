Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29717F483FB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 650346B0005; Mon, 23 Mar 2026 16:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627F16B0088; Mon, 23 Mar 2026 16:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53D596B008A; Mon, 23 Mar 2026 16:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41AF76B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:43:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CFB6413C23E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:43:50 +0000 (UTC)
X-FDA: 84578504220.14.1528D3D
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id F2EF340012
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:43:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eWpqYdH4;
	spf=pass (imf01.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774298629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jv+paj/zuCW/4wO6DwQaFbEbko5bvaSd+BgnRg2Mnpk=;
	b=UygYgbIIiOWgRFwcA8RgrDf3JNotzXUYztIc5+sY4N3hsXbVqBwQsTX7JZG2U0zGX1F3VX
	r7v4IK9nw4Q9UJ4HmrmUrXopaE2c18FyS+xceB9SLvZjyBvLXJ1g3k5QnWbxoJnN0kXYXj
	+0BzSvdwOQJfpzKmJTtk3DVqM2RdvqU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eWpqYdH4;
	spf=pass (imf01.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774298629; a=rsa-sha256;
	cv=none;
	b=Vq2c1nyURKIp4hMkZYi8izsLIKkUyJN/COE6JjKo4hvRUGgawRI0S1yEKeluHdBrbnJ15Q
	Dq2h0yOrggqC5TnSGtBGgORe/0klGmeVa3Rsw99FdvsBCc6Lq/8XYg1cmmLDEFUi3QPUjz
	fxyZIAW3GZy14kYTpd0t7eAVsqR+VA4=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b052ec7176so6985ad.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774298628; x=1774903428; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jv+paj/zuCW/4wO6DwQaFbEbko5bvaSd+BgnRg2Mnpk=;
        b=eWpqYdH4ZkRnMytLm5BSakUDxXFCQK7cBdKUg73PXMNe6+VtDrHFkjfoUaQrT+Fgwo
         P2SLxYUKIIR5Ujz8AF89DiHBcpDD6y35JMSWRKbivcQBVR+p4S+GMpKkNAWixoqaWD1m
         BKJZYuUx3Qq1+TJveWED++98+foY8X2MpSIwSAvXzgKeI5ofvBbDVJjKHi2sZzNs55th
         45RGLCB1AQo0xHsFzA5C8MioS9YXHxUSWgqpyAGxH7lQFHUa9PAXkKBH0pzLF0gxaSd/
         UYGDtHacW4cxEnQKVOi+HEcg2lAYbV0xiTbVnkUfgNCwppzf6MKGVz+7ME7fIbgv5/DA
         +daA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774298628; x=1774903428;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jv+paj/zuCW/4wO6DwQaFbEbko5bvaSd+BgnRg2Mnpk=;
        b=RNleHYdGeI9P0zTm122YJ4u2lnp+KWktmfCMG0/Y9cGU1usvgOH7OSbFK1fiQtTR59
         LEFkWW+LVQhxfjm+7GHXfxfBg67Hat52FHZ9XGLg+omlvLhm/sMu0YiTBZLP6rG1brGq
         elwH/9E9LVKEO2OihZ6D1yJAa4diHBRi/o+QiH2FSnrjlnnUIZVu2PdBSwQeyRhQ3vTA
         zrEufgBSmEGH3M5RL2jrIYShUTV9Ezfh4Y35MOJil7/mrkGL70LpPwAlw1a8K2sPbvzR
         +sK81BoS9/LxfLhEsBZZfqH5Y51NeyOsK5hEMnUXokNk97TthWBHF0/qwha0Ug8FpS9u
         rxkg==
X-Forwarded-Encrypted: i=1; AJvYcCWHvWr1qPIC606I/8N2hhB6QJDILrC8TcKIlo4J6HDJo3sndWZVPeEz0p47mjoUvwX8d1e/X9rxgw==@kvack.org
X-Gm-Message-State: AOJu0Yz8kWE6u7TfDMbA8xT2y2668CUgxCEzL+f1W2qu4FuBBNyBfacm
	X2+KAtg88XQSM2p7mt17bf8/zeFTBSZ1m+tOe/DksVIGWsLrs98kCl6rNMdBcIEfxw==
X-Gm-Gg: ATEYQzwLfyhM78/U0q88je4b9Rh0lo/PjJVRo0jNgib26VbvzZOJGYPLHLZ0hBg6Btn
	HYY4raFE1VsTqvzU2mlnySVnpchT8kfsxF0RovZ8Fqi4Gz+L0UTMCpkOnMFyniKpFxARskTjVgp
	jc5ZELtAlEIn6PkwKy2mYFErPqH2vNulI7LLAMZW1U32v428RuDZ2JjHGjnK98iOnoAWTBJOfs+
	1Jb2/EQUqsKa8u5qNjg/10aJsPbO8vWuRWh7Kh+9v6Fk/t1eKTnlXH62XXB8TFzSoo7RAHBuA6N
	iQzODdNFPTMAHFUUiVZj6usMlabJJWjn+LROubajgQfBF+5TDo34ltHZ59gAmBJPfvTeseW5n3S
	NHgqMW96NYflKTp7Pu0e9rYpgup8TgPGRgutUSvt+mB+/U8vpB2dYmeyk2qPnc5s2upNn2asrGR
	CKndX2FNwSAw/jIXuVbSppOzsd4QARRoM8QGi4vlK0zBz5I/3Kt8Nuy6uVIFaznQ==
X-Received: by 2002:a17:903:22d1:b0:2ae:c566:bd99 with SMTP id d9443c01a7336-2b0a54f45e4mr765685ad.22.1774298627093;
        Mon, 23 Mar 2026 13:43:47 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b04108a1dsm10366461b3a.54.2026.03.23.13.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 13:43:46 -0700 (PDT)
Date: Mon, 23 Mar 2026 20:43:42 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	dmatlack@google.com, pratyush@kernel.org
Subject: Re: [PATCH v2 1/2] liveupdate: prevent double management of files
Message-ID: <acGl9KqueRpnbpQY@google.com>
References: <20260323203145.148057-1-pasha.tatashin@soleen.com>
 <20260323203145.148057-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260323203145.148057-2-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F2EF340012
X-Stat-Signature: qnziyyzz5pyy6f8r61qjqf6o5kez3aia
X-Rspam-User: 
X-HE-Tag: 1774298628-655356
X-HE-Meta: U2FsdGVkX18WdBVTrIadSTSSDpRXLI9C4kSTysw77HHasqKdWxcS+zAV+6rl52qL8PtkZuwI3boadRrT5wQb5pnB8BHSkaX4acWpjcCBwY+KHMZh50VNgXRfsbxwWCcTV8rsXB8+Qqh1A91uxr67xCNK1ihbiUTgyF3cUbLQg4wgS2C5TxfitKp/AeF18lvoPt2rx2tY6AEdgGY6sG4nGlIyEtBTnDVK3RdsVM2uYIE+H62Bxq9MDFJUoqoRVj46y9oDiYC9HRxlUL4vr5jIbhbRYVgltM0rY+c5PRIjQ5iNokjYu/LqJb0izoN7qoKU28q7A+oTui/7OGILJxWkjJe0pXMAfuDPUTiQy/9LUIHmYWsel68oNuJ3cLpZQrU6NKxsW6R0tdbyfwY8Xwy+eTqdWrPqjrsOeKzgCKSTsQolwf4t043GkAgRtKtIxXQshCqnJ4vvZpilLzEfpS0RxuJ+ByB9F0w53Vkx9dOZE6D2CvfGpm2fN76b7opKm1kUP0Xn6lUcC24QEN0Ju+bc8gHXMGedBqgvtOK6WPj0DNKHzzl+ryIOYJ62Sc1ck/VC1NggKb21CSew4ngZHJQemSrfkAEispcV5PxGjuOL3MOgDxyJKre3tV1aZsMDGBH102pjkrB0INz9y8bVJaegUDnxqK0wMt9m0Ibasmi8ids2t0VBYFhFrUbBQKAQ8ipw/Bna1vDqiA7FblKeHxg2o+3f8dljXHmkfGd8tVH/ce60wwCNIB/qix532oLFcoIRfvImrDB8tfERh4Fh6V2gO3I8jdExzdj8ry/kklj6t1P/G7t0A0CY2TUoKKGU6ws1Nr/6tl1VEX2mF0v7ePbl8yreiRcr4SfQGv/ynpaVcfYqOVTvAUimC7r3sAeJQU5bRSnKJezgnNB6xBcAD/upoUFm0oEQ6nA3ZgrAfiAopppniuVLgb68mWA3jj5+9NWpPA7+XFkOFiJZSO1zAdj
 L0nKI6vo
 k9J00dJly61x/dk6ErILPFKXdkphCMoAfr78ziBh+0DCE89QM6MwgKpLylNYZGBWBhoLFTEzdoGhtv8S/zubwu41rIJPdkeaqAp/2I5aeBQkViz7HdzKQVpnmrsT3WfisE+/NAYjOWyiEXS1K/P4bP8IAvlYwv8P9DQnpF70E6xHC6fnUp9feTP4os1FUs5vgdORyQgftLnDGDjltWryFmGCgRz4ek2aIXEu1bRkGAcxV0mZaKUvEIwh0AvQWgNXMMx4H/8ZVHZgEFdhdN/bICi+WjQL4SspNmdYuc6asFNXBFNfvjbd/5agWFbCGsH2jK30PsmZfeMAdV7Ex+DtTlGc+DAVsb8hgj9q93de+tnGvNJ4Bpow22SSzCtC2Ncg3c4EazCJKUR4sMRbGoe/RcmmFsFnTusKMxei3xDuLiO7hQwaMjut2ZD7GSfB0C7zV7+DW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 08:31:44PM +0000, Pasha Tatashin wrote:
>Currently, LUO does not prevent the same file from being managed twice
>across different active sessions.
>
>Use a global xarray `luo_preserved_files_xa` to keep track of file
>pointers being preserved by LUO. Update luo_preserve_file() to check and
>insert the file pointer into this xarray when it is preserved, and
>erase it in luo_file_unpreserve_files() when it is released.
>
>This ensures that the same file (struct file) cannot be managed by
>multiple sessions. If another session attempts to preserve an already
>managed file, it will now fail with -EBUSY.
>
>Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>---
> kernel/liveupdate/luo_file.c | 17 +++++++++++++++--
> 1 file changed, 15 insertions(+), 2 deletions(-)
>
>diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
>index a38ea4975824..5f48c3c8c561 100644
>--- a/kernel/liveupdate/luo_file.c
>+++ b/kernel/liveupdate/luo_file.c
>@@ -110,11 +110,15 @@
> #include <linux/sizes.h>
> #include <linux/slab.h>
> #include <linux/string.h>
>+#include <linux/xarray.h>
> #include "luo_internal.h"
>
> static DECLARE_RWSEM(luo_file_handler_lock);
> static LIST_HEAD(luo_file_handler_list);
>
>+/* Keep track of files being preserved by LUO */
>+static DEFINE_XARRAY(luo_preserved_files_xa);
>+
> /* 2 4K pages, give space for 128 files per file_set */
> #define LUO_FILE_PGCNT		2ul
> #define LUO_FILE_MAX							\
>@@ -249,6 +253,7 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
>  * Context: Can be called from an ioctl handler during normal system operation.
>  * Return: 0 on success. Returns a negative errno on failure:
>  *         -EEXIST if the token is already used.
>+ *         -EBUSY if the file descriptor is already preserved by another session.
>  *         -EBADF if the file descriptor is invalid.
>  *         -ENOSPC if the file_set is full.
>  *         -ENOENT if no compatible handler is found.
>@@ -277,6 +282,11 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> 	if (err)
> 		goto  err_fput;
>
>+	err = xa_insert(&luo_preserved_files_xa, (unsigned long)file,
>+			file, GFP_KERNEL);
>+	if (err)
>+		goto err_free_files_mem;
>+
> 	err = -ENOENT;
> 	scoped_guard(rwsem_read, &luo_file_handler_lock) {
> 		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
>@@ -289,11 +299,11 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>
> 	/* err is still -ENOENT if no handler was found */
> 	if (err)
>-		goto err_free_files_mem;
>+		goto err_erase_xa;
>
> 	err = luo_flb_file_preserve(fh);
> 	if (err)
>-		goto err_free_files_mem;
>+		goto err_erase_xa;
>
> 	luo_file = kzalloc_obj(*luo_file);
> 	if (!luo_file) {
>@@ -323,6 +333,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> 	kfree(luo_file);
> err_flb_unpreserve:
> 	luo_flb_file_unpreserve(fh);
>+err_erase_xa:
>+	xa_erase(&luo_preserved_files_xa, (unsigned long)file);
> err_free_files_mem:
> 	luo_free_files_mem(file_set);
> err_fput:
>@@ -366,6 +378,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
> 		luo_file->fh->ops->unpreserve(&args);
> 		luo_flb_file_unpreserve(luo_file->fh);
>
>+		xa_erase(&luo_preserved_files_xa, (unsigned long)luo_file->file);
> 		list_del(&luo_file->list);
> 		file_set->count--;
>
>-- 
>2.43.0
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

