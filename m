Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CD9CC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 04:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79CBB6B007B; Fri, 24 Jul 2026 00:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74DF86B0088; Fri, 24 Jul 2026 00:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663EC6B008A; Fri, 24 Jul 2026 00:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3468B6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:55:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E344802A4
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 04:55:34 +0000 (UTC)
X-FDA: 85022456988.01.75D0907
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id CB47340006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 04:55:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=P0LobYvh;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784868932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mymr4wOyF1eBzp+BDc9Q36kn6q3UnnG+2ist6zjbpA=;
	b=z0O52mRO3SaKWO/UYXdFq3AHlYXm+dCbg3TSMHOySBskShEmYH273fZI+W7r6O/NgmioMm
	7qFUuV6bYqbfBRSLg0J6q4PBnwYDIkbfDf65WtjCeBjwUe0kMeNzlvNgm1jWxAcsAgboqv
	BjZHZ99geB4f+mC7EAHaTgST3YCDt1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784868932;
	b=LdXB1BMylXXyBbHQGfKtFlMmZacrdmH/yZQx/Q31oGZVXuR5Ss73HYe96XAoXNZ0nAn0u/
	a+KrZWF9YoMP9siNjvertOnT26t7mwgTBOJbAKe9YdqwLpWRN6H1Kf34toaQL89C8iXg/j
	4zB5QTGwBlDr7DvjxOg1ZG1HBMPvC1o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=P0LobYvh;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cf27856f9cso544025ad.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1784868932; x=1785473732; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/mymr4wOyF1eBzp+BDc9Q36kn6q3UnnG+2ist6zjbpA=;
        b=P0LobYvh0lwp+kcJ02nGSWdtVD/iHwH1gi9JJXC1KLA31Uisj5cjXgHKjwKdytK0Y3
         LFgUeCDKlQSdIF2lEk2PK33KMy+JMz1UUaNbyv/DGKfvMbox27aA6bwzfVwTArWXXey+
         r8PnISUiPR3VogRuocXHG3xwRvC6P9nwgJhFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784868932; x=1785473732;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/mymr4wOyF1eBzp+BDc9Q36kn6q3UnnG+2ist6zjbpA=;
        b=emdk9lk6l+odJGHWdXbo/Gc3pWA43po9JIb5Y11FNwwtqFZZ+lwZGrJI/vbALlVn88
         jgBKCOHEPn5LaLw/pHULiXP7lqO4wj5mZRzTbDgfpes48uS6OUA8BdWLnTXCu7FZ5MoH
         vyMM/6eaEN5D4tZaGsI2p62oW2q3EqElxKL80Y8RZUKElylCi0PF8Vi+olGjVV4wSyVH
         HNLtCANII3T0JKGM6Djg0BEn2k8KvgO2IZ7xpo+JT5dkGFaMXgXfAvMlUFcCO/HjXuhj
         2dtMNZchacLEUSN1SMbESN9qjrVsk1TbZjS8qAJLychr/fR/At2JtxW45iyEhAa2bFEG
         +JQQ==
X-Forwarded-Encrypted: i=1; AHgh+RpXqIPiIyXrZ71hWQMKsVN4hkgRSgWINvI5YOBGpbvg7jvM4QvJq+0AyyiyohKmD1pm5X3mwdMidg==@kvack.org
X-Gm-Message-State: AOJu0YzN0I+j1PzduElFiz+UHp61WnLEodKK+53bjRZTtJM06bbRC/Aa
	sajmyW+VM5+hc6epP/HTVfWzmZB0lCm3UH2VLiLa0EOjz2snBGQ+ai1J4MLays5brg==
X-Gm-Gg: AR+sD12Uc23pqxe12xdep3DAJbtfayTbVMhOpKGaPK2vB0bx7OxQxGGOhapKkD1MWBn
	nIXFnwbe71e1kHt0w48u2LmJtusV3Y1pNT6IhRjZrEubem7eNpM7nPkXWVvzDqrkrkTqpXZrkPD
	7n9A1YwOrHDDu4/pqEyXGNWW8j+hA2gp4O09dgZLSEE5jTHDv0uAoG7BCxesX+cjmAPVRqeqozN
	s8NbLNrJp4yOIRTNk025dckhO9zd/UXUIWIUbr6eYvo+eTXkmncvmGBs+vD+eySOoh6LViuLBg8
	dj8/2dRJ/alRRe0nGppmjsat1BSoXoG0nALQjmjMwhoObnZEfVUzIVrAbrndFAOh7p657xTqa5c
	dP0sVJFGebhOSPTAzaPDNssXGdbJYDq7bTPF3RCyCKwxidcYpN9bjU+RG0V1j4MbMdP8ZNTvFJ2
	IiA1P1Wa/hlAiSz/HBRGxxJKfE5s4UBO/R+a0OgovPHC+aLHRt8qEJ
X-Received: by 2002:a17:903:468e:b0:2c9:fbde:ab66 with SMTP id d9443c01a7336-2cfa6c72079mr67795515ad.37.1784868931715;
        Thu, 23 Jul 2026 21:55:31 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:c102:f12d:5168:6be5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efd76cfsm45209895ad.20.2026.07.23.21.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 21:55:31 -0700 (PDT)
Date: Fri, 24 Jul 2026 13:55:26 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Wenchao Hao <haowenchao22@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Nhat Pham <nphamcs@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Barry Song <baohua@kernel.org>, Wenchao Hao <haowenchao@xiaomi.com>
Subject: Re: [PATCH v6 0/4] mm/zsmalloc: reduce lock contention in zs_free()
Message-ID: <amLm7ztljcJEN-9d@google.com>
References: <20260626015003.2965881-1-haowenchao22@gmail.com>
 <20260627213600.eb072ba84382807a8242efc9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260627213600.eb072ba84382807a8242efc9@linux-foundation.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CB47340006
X-Stat-Signature: 95xd81fdkap7mcppbsjjthok5r9p9cq9
X-Rspam-User: 
X-HE-Tag: 1784868932-222786
X-HE-Meta: U2FsdGVkX18b2SfLb7fRNP1NrBpyY+b4okR0X+xNe8ldwN7bLzRnxUOcKL7El5O18lmyVMu5VPG+8Im09lDvPQ27rygIRxEVjrB2ljvh5IbUvVOiGlA3QE3fuh4xWK+m6BlAImhCSkCBAjwT4BZyf9nY/D3ad9lkrWtJb0pI+rTeCji935LPFINcQmjo2RIRpsyWrL45uFjXUaj5Dn5jpDcAXCCoW81F5bLB+PcJULcWcLt2O7XZU0saePwrPSoVew4xwr9aotZ+t+8yl9q2GRPpRe8CNtQZopFj/C8R6smLfl4KJe66LerlxdgVONfFEz8NrQeYNud3II0IsNQrcDdPrEoYGz7PH0HIc/DesQARi+csguWWObEzFcuvhFd0F5gd9L4VdU7Rzm9ywpJZKIVQZOLqXF6O7iWiRBnareuIDveIO3UOopKxcJR4nDbvNbRWUTQTEVjGj+XoiZArYojVX302stGdCkNOGU6hFMP4wZdJUE26dI98XB+axMjUfRqxDLZfo7feRqjnSOAvyKVUH2e+7z28BwLFJKXoqra2lA+YF7UOhs2VecZAppMMvVI0GoM8KXCMe7yNUT3vuUApFthfc6CTJAlfqOjwZ+XH1oRKRJulONxMCHDKMxATY3amBzwkuhnJQRP8cutZ6CZ9P4+Yrqncr65D1dkjXNDpdiAEa6RX4vryvpVN/7kFQe8xpsXUlYBKrmoVSw6DyqEniDWv+/HTm2vzKgAyD7bXbbgbp9qhJbdw5ZBNyFCMOZDP2zprpJCUxiM5vmcxhnJPj4tCw2WCT6+/DbcxKbGZ/obttJQOTP0gKUOxvFvShhxMMslxWJeCA7Rdpa/w0SmjmbIf11vgQfiDsj582yK581KUojzUE0v3PZMmUm4W8VUadDgpywGLLFZ+qJtUUyYVsdWzbe2xulgpLr+ro0dkYw57rG3YPPQ2y/jBhHjExBvxm2DxaVnw5/MB07y
 hFG4a05Q
 MpD6PhmcvPBjEL1QPFpQYAXIbYUQPJCHgwBTZY6tiqG62aID/ZsQO01Rjeq+wJno0JetYlftOYwfKwDdkgt4p8qmqjHjlN+NoR4sv1qf2GUxgIvmQKVR6XNAGGUdBjRfyYDz3GTzhUL8wJ/PTsIPOuHW2rXfuHWPfmbaifEPoPpD4WWVxFPTjxBite0wDncuy2RiKpxmn/SMvohrzwk8n33sIejBFDKwyOz+5EkxVIgcR3jnrX+jd+S4hYczHAiZigAVABKqWs+ciUeg/zv9HPeGRHyDVuOihpPr+B8buzTVpgJTs9eq+SBQybZxg/YEnf8SNqIVwY/6ieeJdZNcvQJ0DdGTS1Vxqq8Y1oNC5shVC1ghoW9onvXew5rcgywWPg0Up13cMlyLC1bhEN/LAbJrXhFsDO1QcO//4j0B6CBxy/kgRbxB82avMCU8iiw3gdXUPzA8ja+BKGmeO4I7t3SOSRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apologies for the delay.

On (26/06/27 21:36), Andrew Morton wrote:
[..]
> > Raspberry Pi 4B (4-core ARM64 Cortex-A72):
> > 
> >   mode        Base       Patched     Speedup
> >   single      59.0ms     56.0ms      1.05x
> >   multi 2p    94.6ms     66.7ms      1.42x
> >   multi 4p    202.9ms    110.6ms     1.83x
> > 
> > x86 (20-core Intel i7-12700, 16 concurrent processes):
> > 
> >   mode        Base       Patched     Speedup
> >   single      11.7ms     9.8ms       1.19x
> >   multi 2p    24.1ms     17.2ms      1.40x
> >   multi 4p    63.0ms     45.3ms      1.39x
> 
> Well that's a nice result.

Indeed.

> Sashiko AI review said ....  nothing.  I don't recall seeing that
> before ;)

grep-ing the code, I wonder if we maybe want to tweak some comments.
Namely, zs_page_migrate() says:

	The pool migrate_lock protects the race between zpage migration
	and zs_free

which is not entirely true anymore, as zs_free() has a lockless path
that doesn't take pool look (when ZS_OBJ_CLASS_BITS permit).

Likewise, __zs_compact() says the following about pool migrate_lock:

	protect the race between zpage migration and zs_free

None of these are critical, very minor.

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>




Unrelated to the series, no need to do anything.  Just because I'm
looking at zs_page_migrate() at the moment, would something like
this make sense:

---

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 3d566a3ee96f..a6ca93ea1eb2 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1875,6 +1875,18 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 	 * the class lock protects zpage alloc/free in the zspage.
 	 */
 	spin_lock(&class->lock);
+
+	/*
+	 * Migrating an empty zspage is probably pointless as it's likely
+	 * scheduled for a destruction anyway.
+	 */
+	if (!get_zspage_inuse(zspage)) {
+		spin_unlock(&class->lock);
+		write_unlock(&pool->lock);
+		/* Same jusitification as below - we cannot return -EAGAIN. */
+		return -EBUSY;
+	}
+
 	/* the zspage write_lock protects zpage access via zs_obj_read/write() */
 	if (!zspage_write_trylock(zspage)) {
 		spin_unlock(&class->lock);

