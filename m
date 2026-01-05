Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A2D8C2A073
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 01:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC34C6B00BC; Sun,  4 Jan 2026 20:43:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D844F6B00BE; Sun,  4 Jan 2026 20:43:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1B266B00BD; Sun,  4 Jan 2026 20:43:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFC046B00A2
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 20:43:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE6121AC370
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 01:43:00 +0000 (UTC)
X-FDA: 84296211720.02.FA3EC3A
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id DA10C1A0008
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 01:42:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=lLf0HEZ8;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767577379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+gAO+yv/gpp4aH2e7rkoPJP/n/Hsp6z2VtvqOcpwbVM=;
	b=W99jeqKvW4cQwAIgaSmQvQlsbvMrEFP72e19mlK0dwmaBTjXsb7wB9PZNC8ypZOSt7dvhx
	s/c5f4xeXFV4LBC/RirnNEMXwBdYif95PDcJI4KfQzeEYKYSL31CaykfUC7qZGiMNYF8N2
	ESPUCtaSaYnpRbfWJGY9q2QG/nMTQZE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767577379; a=rsa-sha256;
	cv=none;
	b=lsearmI+JQszERKxYwxLP6v1hKoUOSzi/F3vaQeE3gi3IiW+dhg40DCW8oRI/+7/VQTA0z
	tUhHqD9X2mAhVeetqTXAZUrkmO/EpHaXBTdwM89DdsMCjRFMZ06ri1OpCtqkNBsQhUml7M
	WNnfjEhTqtPkPvo9on5ZNNMq1cTuizI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=lLf0HEZ8;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a0f3f74587so192585775ad.2
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 17:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767577377; x=1768182177; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+gAO+yv/gpp4aH2e7rkoPJP/n/Hsp6z2VtvqOcpwbVM=;
        b=lLf0HEZ8HMsoU0M5stEBNRl2IZipxBD7tEd16RuvOY6d7MGdXSJm+BCUO9jmje5Wf7
         0TE4VkaxJTVQw6UJrQyCJsBRTaWA/EMM+waLf4vIRm1F0EqxhVoxB50CjV4p2ieUTnoi
         /FGkcsVsI+7oxLuV5M6qESTvtFDBDWAuu8D2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767577377; x=1768182177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+gAO+yv/gpp4aH2e7rkoPJP/n/Hsp6z2VtvqOcpwbVM=;
        b=D+abJo+ehqJUBGu+h/56G0FAqgJ/vZsAyyE9Ra7psogDWgJ6zUDHuETMFrT4tBkAyA
         EwqwJR/8eVM7cCOLplAkvy9hTttu2WifoXwQOnK4uySwqtsA8mLwxnl+97MLtcX3uSXy
         T/1E38rGM/u+fg5zgtNIvqYfVi71jQK7/JwNc8AY4zZupxOMW/079bKsx9F5jf+MMNj+
         RY3vyilhVTm83WCJB6se5mbcgU7nY6F3RBPqazszQNR9BxdPkDOrbWaEHr4baaRjMCwB
         SAJ01UuzBuWV47b0wPRGNg4TemrmDUIbMTPw4SIiJ/awsqhpORxfIetKXJLOCXwhgQU8
         JU5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXGMfSdJQg18N9enF+OVdr42++1GwuNjHiLwvAULkOLjYEqCGjeI/D/950iFokQJwIfNM4gDUq3RQ==@kvack.org
X-Gm-Message-State: AOJu0YzalWE4SfPaYh7JZXxlaY78F+jfz5IW/g1PHjxwa6avgv0COfSv
	Ij9wLazFe9XUPjKWbjl5R8ZXucUAkpFXyq3TVds3vlgc16TorHjFhZEe20Kg30uEcg==
X-Gm-Gg: AY/fxX5hnGtulz59xT7sj/6g3hHV8s/ID53cCbmX87zzseQF1Rb+e8uP+OBDv/f9cQZ
	cXIdIvv17Ap9PxWrKk27xVdNyYNlozQNyiWxjTCOWeSqiK4Mkx3Fj1Yo8yeGITmCw+foPQsXBra
	69tz1Lg7r7NDHDClgmjLf4z+9GQcyktmjEKK8azYsJCUnOPWMaMwqnczkkKQgTddIX3aACt9deK
	MlqVbOaidbHM9QVxjGDydFFvlEX0dRhSk9iBBT65pyQ0ui86VrW6Xuo3kU2TJ8nBLLIb0DvI+y+
	j2ES+WdZubDrLgBXaL7EerONVK+thvhnkLNXUyMJWVovJFN8esFxpfiCevRM8aDWEnzlTWwbDmy
	8/3bY69klEsqYxh8+/tnz6qVV3RjNrwGqjxOCZVB083lly/cokw5LxPDTf9PjvL4j0UO1HnOo33
	Fl66ht061nrA4FaeqYHK3GjX1W9aUKcE14QCU9uz8queMM8Q0MLik=
X-Google-Smtp-Source: AGHT+IHRq6ioUewrYiODXdqjDXOR3KSfjOptUP5zM2pTAnvbchFEjjOi+oLwUB12rewWFbfrJtJFWg==
X-Received: by 2002:a17:903:fad:b0:271:479d:3dcb with SMTP id d9443c01a7336-2a2f2212bc9mr512621455ad.6.1767577377431;
        Sun, 04 Jan 2026 17:42:57 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:3657:db4a:faff:666f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d7736fsm440160085ad.92.2026.01.04.17.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 17:42:56 -0800 (PST)
Date: Mon, 5 Jan 2026 10:42:51 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
 <20260101013814.2312147-3-senozhatsky@chromium.org>
 <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
X-Stat-Signature: nbsteuychab6zeetcjf8qs78d5cixcza
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DA10C1A0008
X-Rspam-User: 
X-HE-Tag: 1767577378-801565
X-HE-Meta: U2FsdGVkX1/WtKfga+xUbFAVe+vAvDlcZ11Uxm9M8evd63kHZCoi7JIFM8P8CzLHdNM2awdf0985XPaNT9n9utANtWnhCkRY45tBPlFwQhN1zkAsUobtpSC64gemzLHT8dFzEpoj8NazDzACXmje9uNBeJcbQwyo5L5OVIGFEQ1l0kq1e71kj9M8FZUVxqsJBmmkJzieuWNQtbi2FAnO9lF8LaDVnD/lW+VJu1j2MOHeRt+HtNI3gASKmqsjH8tKr7mQo/vBrW6TjxjwM1uu9ccmBi3ZouotL+yxkL/X+llpyHBjCGb4Wk7v1Bf1NZbFnYFsqn94g3dJVlhNB8nIBM2q4/t9QfsLTgsJ5kERIdUo7iNBMiNfp6midA9tU0B5Foz/dQnK4bgdIlYur3W+4sjLQNM7jWice/sGJy3tEryLuXVYkoPqOL8c1yWE6xVrMQAipukQWUDHnibOTutqD+sp8Y0um4ocSPyTch9ndQb8YGAtVXyGwLeU1IMrDmG5ToZU447pMzgxzqCChe8FCIzUK38K0DEEEqjQBOGnaVXUrk6NA+zSTe6Ttt0jzpHNq8LPkmOkwhH+Dq0bakPLczrYkV7ySMOm330JMahGFj6LUSALLtM7bsuVh3JFBypg1XLzcfr+yGCOoGDpJZaxVn6o/oBLkwTMKmKYcq3lYwVUS9FvlJ2X4WEmql54GuHWnmCKtCfbAEEWwiJZ8dmvyv4Qzbe6fPEhpyK9IQFonejHrn0e8hycKKH8ix17o8qHUY0xQWFWCK+n/CNU0FtC7MO+G7pQJ/HAZJeUQpNuqybWWN+jfSX2lfCGMJS2HaJv2uHZkBOZZW+Z1Az2hHEvEceaUiUwWmfcNpwBpqzjHqrTSaOti6QlRHN+lMIlZ6BiYQ70HwI6+LvkiTJ2CR1+aelj4sjqXC6QtSdDqrmQvHky/8bNpgN8479A5EsZNQyEk4/ta10xGqPShcRVeUA
 pRF5JLAV
 KmFuj6lx5Frff9ewGUaNwCHitrdQDsgWd38WudtXvSv5K/YYJKL8forDNQKmDPf75R0PKtt0hHd3yQhuICu5HYQ7uV9ogCNR0cTiIrKLPucpQp/GQTfXsdvUWTlZ7VvGnGOerYJJe0iJ5Faewtez40HIFWhSgdaM3BgZWapvlwzwMnVPfqICPhokqpcvr9Wu91igt5VEjQ2zJlE4SXtl8hF3Hfn8LYiUpyOG7iKBUwoSKNF/uN2VgY76Pt7LxHwvFXs+811Mjo/ZgBeMVjXXavlZudYFuICp0kARrFKZ9gKAzbSrhqPQjh4b0OVRjXlTuFdwJyQrbhVvZsMDNv7blNmlp6KM2tgcSdArlIG5B8AVpWYM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/02 18:29), Yosry Ahmed wrote:
> On Thu, Jan 01, 2026 at 10:38:14AM +0900, Sergey Senozhatsky wrote:
[..]
> 
> I worry that the heuristics are too hand-wavy

I don't disagree.  Am not super excited about the heuristics either.

> and I wonder if the memcpy savings actually show up as perf improvements
> in any real life workload. Do we have data about this?

I don't have real life 16K PAGE_SIZE devices.  However, on 16K PAGE_SIZE
systems we have "normal" size-classes up to a very large size, and normal
class means chaining of 0-order physical pages, and chaining means spanning.
So on 16K memcpy overhead is expected to be somewhat noticeable.

> I also vaguely recall discussions about other ways to avoid the memcpy
> using scatterlists, so I am wondering if this is the right metric to
> optimize.

As far as I understand SG-list based approach is that it will require
implementing split-data handling on the compression algorithms side,
which is not trivial (especially if the only reason to do that is
zsmalloc).

Alternatively, we maybe can try to vmap spanning objects:

---
 mm/zsmalloc.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 6fc216ab8190..4a68c27cb5d4 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -38,6 +38,7 @@
 #include <linux/zsmalloc.h>
 #include <linux/fs.h>
 #include <linux/workqueue.h>
+#include <linux/vmalloc.h>
 #include "zpdesc.h"
 
 #define ZSPAGE_MAGIC	0x58
@@ -1097,19 +1098,15 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
 		addr = kmap_local_zpdesc(zpdesc);
 		addr += off;
 	} else {
-		size_t sizes[2];
+		struct page *pages[2];
 
 		/* this object spans two pages */
-		sizes[0] = PAGE_SIZE - off;
-		sizes[1] = class->size - sizes[0];
-		addr = local_copy;
-
-		memcpy_from_page(addr, zpdesc_page(zpdesc),
-				 off, sizes[0]);
-		zpdesc = get_next_zpdesc(zpdesc);
-		memcpy_from_page(addr + sizes[0],
-				 zpdesc_page(zpdesc),
-				 0, sizes[1]);
+		pages[0] = zpdesc_page(zpdesc);
+		pages[1] = zpdesc_page(get_next_zpdesc(zpdesc));
+		addr = vm_map_ram(pages, 2, NUMA_NO_NODE);
+		if (!addr)
+			return NULL;
+		addr += off;
 	}
 
 	if (!ZsHugePage(zspage))
@@ -1139,6 +1136,11 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 			off += ZS_HANDLE_SIZE;
 		handle_mem -= off;
 		kunmap_local(handle_mem);
+	} else {
+		if (!ZsHugePage(zspage))
+			off += ZS_HANDLE_SIZE;
+		handle_mem -= off;
+		vm_unmap_ram(handle_mem, 2);
 	}
 
 	zspage_read_unlock(zspage);
-- 
2.52.0.351.gbe84eed79e-goog


> What are the main pain points for PAGE_SIZE > 4K configs? Is it the
> compression/decompression time? In my experience this is usually not the
> bottleneck, I would imagine the real problem would be the internal
> fragmentation.

Right, internal fragmentation can be the main problem.

