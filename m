Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD4DCFA446
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 21:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5E26B0011; Thu, 20 Nov 2025 16:37:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7DDC6B0012; Thu, 20 Nov 2025 16:37:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6D4D6B002E; Thu, 20 Nov 2025 16:37:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B24A26B0011
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:37:59 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A0BD1403A1
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:37:59 +0000 (UTC)
X-FDA: 84132298278.26.806A356
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 39B3014000F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:37:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Ig1olQFf;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763674677; a=rsa-sha256;
	cv=none;
	b=pszLNeqlyfwtVssJuu+GHFLauZgG+jdM/LK8719vufFrvQ0G40GI5gid+fksi+DYxoLsPw
	eIIZDXpdF8lIITAF6swX88tZykgTC/9Dlw082yXjc7oGBvGNEp6MV5EazrTKs9jjxxXzHK
	hTmtjzx+MT5ZGcs1G43+phfcPSgKMBQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Ig1olQFf;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763674677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4yhXQ9GulKnB8nV4VH5JE032ZQQUQfYPouYE6GX0WU=;
	b=6PxHO6JLq3+jbaZ51ACqpqax/BEWtJD6SHF2HEqZxEPiSL3xdXqrr9CD9gYZ5dgSXOlYMi
	dxZ6elhP+CVlM0+p1KxzS/qoc5MdmXM65vn+cI120xpXJkipcXavWBx8FSKjSi0cNyPHVX
	TFqL/0LUwxAzNmjwqDeegsVVITg8SPc=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b725ead5800so179402366b.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763674675; x=1764279475; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v4yhXQ9GulKnB8nV4VH5JE032ZQQUQfYPouYE6GX0WU=;
        b=Ig1olQFfF0Fc/2mforw4Yax5oxVChiQlQfQku3Wd5FudNrDXKhuTaVDhb6UKrCvwNq
         4kMPsi9dboYAJ3ksJjSzlrmB5qEqy+/lJ6lBB8QmgXu9pbLD42QI/OZ5eqmWFRrOkOVO
         WCYwnhdiou2PYlaNw5ZRQAITTGJAK87O3ZGrc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763674675; x=1764279475;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v4yhXQ9GulKnB8nV4VH5JE032ZQQUQfYPouYE6GX0WU=;
        b=vW8z2IL2PKhY4tWtg5PgLSO2qurp73GGGXmhhBatV6qxHb35ex6J3dv6wiDmP8OO32
         ziXT384Emy6dLWcguwjOy/hjVJBkMYwdLpQSQudZ0xZWHn6qEQIxQz6NqQB1c38ptsii
         oWIE28Jh7xAmwR5R3VTJGbDX3T6WcyyUM1qDbjt/JzJIpfAnxKfZOvZjyo5ofEBcfokb
         o4yCJpng3NxDayeMXI6PeoszrJ6Xfzr6c/QiTuLYqkH/niqDdgDEEAT04nnq36t5NHtG
         jron1eivWXjA0Umtf+nQZouZuKg0HG3iu+t9QBvP+ft7Jb15E7o4EyLtlCux3nZnY1ra
         vPJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhBXOaY+0EvTGaoB7gAduKEevBYQE7pJ/KZT51pcQmEcLkIck7UoYUCMarDGks394ZV1H6pt3TfA==@kvack.org
X-Gm-Message-State: AOJu0YyudqJvTggklDnd8yB+VyYzXtMEyWoe9Xpq9qNrP3FtzBlEqI3A
	iuusa8vO+VIhnoUkd/kcuovmQ6d08z0+kBJ2C3F+DuDsUA1ZkGi0sVt1CC4a3xWl4YSNLsdS+fw
	nPRhjBYTCwQ==
X-Gm-Gg: ASbGncvuMqVWLbU+0JsC0DVMdr8Pbxlp3qnPBKQAVvdrOkI/br3SEuBAkBo2lslXrOj
	I1/FrH3zmuVnjkO/u1+dbf0RfSpdn+K82IfPw+jva+HnZsQB13DfypJOrq5wCZk0seUzaVy7UMg
	3Ppx7AlcYRj+7gtdYWyHOeWQ5mxqLA0UFtmkyut8XFiwOE/QWc912mnosKpzU21SaeZCVK730xj
	PD4q59jZGn6eN7bxzk3EKdht3+MXKRbLr/QMFSO2PdN1r4zgCmANSSjlwtrM2QmANt3yX5gozqU
	/6jzOrch028/I0HYdb/LtRPEG9+7+P77EaP8mdQkoy5p2yEftFd7G8oIR03Sm9tzlVWiTa+pYkc
	k/9uvhhyByCw5eXRueVFqPrrJkW9JTamp6I3cay1zQd+eK77zdJMTONnmnNrZ6wVlQQH0keNb/K
	imQFjbSGAct4v+Zar/GRWeN+MXQ1HGMQmBnmqkWQpotcVqrlXZ9ibqeTaYBIed
X-Google-Smtp-Source: AGHT+IE+aw2QXa/02oXuxAQZpJQby0zAzIPBDYJY9n1kYCu15sf8KKnfxQ7zAbtEiF/ur0NuHcosNg==
X-Received: by 2002:a17:907:3f14:b0:b72:134a:48c8 with SMTP id a640c23a62f3a-b7654cfd448mr471795766b.14.1763674674996;
        Thu, 20 Nov 2025 13:37:54 -0800 (PST)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654fd4e6bsm291444266b.34.2025.11.20.13.37.53
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 13:37:53 -0800 (PST)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-640860f97b5so2058547a12.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:37:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUbkWV/qkoGE3fBtDc6Ar/oMFw23DyCGoKXAPoQ5WAjCsmx1JQb9stQ6CrGauD0RpBh0MVxIhaNxQ==@kvack.org
X-Received: by 2002:a05:6402:90c:b0:63b:f67b:3782 with SMTP id
 4fb4d7f45d1cf-64554692891mr155989a12.27.1763674673251; Thu, 20 Nov 2025
 13:37:53 -0800 (PST)
MIME-Version: 1.0
References: <3f4ec3be-0725-43cc-a75b-72549ebdc5c9@suse.cz> <CAHk-=whUBuZmRNGCxjnAkFQLO_HVV8SgWEAUg+3z4EARD9MM3Q@mail.gmail.com>
 <aR913JM35YDVSCjF@casper.infradead.org>
In-Reply-To: <aR913JM35YDVSCjF@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Nov 2025 13:37:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=whk_gUfFKtZrjd6TbaR0YhEmhOAs9wXFg5Je3FzQ3adAw@mail.gmail.com>
X-Gm-Features: AWmQ_bke52G7Xf5XSH-fAxcjB8H4OhPHmCg2i731CLXDdQlXY8OHLgDLjc_6dog
Message-ID: <CAHk-=whk_gUfFKtZrjd6TbaR0YhEmhOAs9wXFg5Je3FzQ3adAw@mail.gmail.com>
Subject: Re: [GIT PULL] slab fix for 6.18-rc7
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 39B3014000F
X-Rspamd-Server: rspam07
X-Stat-Signature: xfokbzmmrm9xwy86sk5je6a3eiyrc8oq
X-Rspam-User: 
X-HE-Tag: 1763674676-22793
X-HE-Meta: U2FsdGVkX18j66/Bdgr452vLBHNstsEjpIkO87zhipz0MPj8ku11AsyYSx+HWpamLBvyxpVUrrxcEcMdiduAo9PExXgKZUjk86pxKLYz0uxMJxTF23cI4Rza3hVdcHwUUDIgEh3uqAInuv6jT+LvGcL6OoOJFoFrlSjtGAeBJnysDsDircSbdd/D1ZkEEQWlGwqrPY86tqxqyB/2CL45pNPpxWzn6xyaNOcZCPlv9N5Y6rZSIL/gdCSJBEiaJtvRevyrkPqs8Q/B9JdZ+DtEq2C/a0tOGKVLx5630M2A9LNHR20QeOi25u/pNXwjRtFKaqQr1ec3M3LzJ5PN6iRN+LkWIigBKhgesmKKFAbUnoBUEAqQKaPb3uZx1qnxGZUmNSj78zl4lbcamX59aU7JflkM3YrJDdCLbhSL9itfbFIxaetsY8qCx49oGo57qJRZzJp5pfMGwIQ1JSLI4y4dmzf/LTPXoixPull2zbPWJswhF81+eZzCBGjdlo70EHSrQygbVbgjCdwQa4KpPAS27YPJgxvS5rEWaFZw5b/ZOui0NlIhgyFPw7wgPfCtnMlNDhQU8H7Vql4a4z4m47KSpwN5YFjpptd2U1Fq7jZjc1/6hUZ9lyCu6UWS1nCvEEuYphovmvSyyG3VhQSB2lYML9Yh10dZMsxm7j/HPHHpXA1kgSw+PwOvH09MlSdjmz4pcMOyyK7xnWhgaiPsAPfU4EKRbGPv6aYuewEVHYVr4mPp0qowsY8M0x/phgSsZeUknQW4jQkwKXcwDotoAS4HEL0j5AHWeMx7Y16Ac6mUjiatmD5nznr9HERRWYPGPmIpDMDPUvOBmS02ZKvJ/7RaWtXUvJfHl5nZZt1AJo1FDdjJiHqIdsm6vDjIpx/KlbbJh1LqGvEMfEj+/Riwe30AyvbHIfISdUuiFDz7zZz5tTCMtULnRjxfBYUL7y4HI8ozhxcAZXhuca8/m61JQM3
 oPW1ukdR
 uFkjUUSWQNcT7kOTIP38fYOLHVIROhONxySr/xWjpyLy1rMKwUu+nu0YvoyhQhMEsy2ozHWrO1IPORKIMAvMm7ApQzuPpdLnsB7Iyd9treM6csszLeCBPFWbQTkzfJGGN/HY9fB8PbexJHhu1JK6xw+h7c0fxuvfi1XdBqfVVoFZYh9WSLVqqUXM7EV7HiQE7GAXxWUVhYMdfKIa6W2B6pkIHpB+l3ZtCpL64jXUq3tK/imh1qt7fNEm7eWiz3wTIv5oZkkbAQ5hmr/AdFyO1R0QRFIsNTVTL9vk8Vdt2v9bA63lbDD3lrzf0DUsDnBfJ8yi/URLHQuJimLGXwgb+2iQ/3+EQDd+MUlX6BII2MKcFo/3sFCh64pllEuFD3iDKafkHFMntto7qNEd+XlvB2DW+BC5wB08qP9zqBunB4naOuFMIV6Rlp+AlIhjf0uEzBGE/LDK1gBrKBdJqAVbcNIj/ce0Dh2IK6zZthewoLm8FHl2nRVfzMF8i1jmqpH5vSp3113JZA6n+f8sXNF+Qcm9+Y7+W97BPBEXLBD9aiZemcDO48EV01KYALe9GFwiODyJOfYRf9o9J4cjFx29N6cIGtQyfW+KvasOKBY+iohCvatbO/3mBGZgxvUwlVaICCJ7tAnUrXM6Du3OBA9dsLrlmEGFnC/yj7WqI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Nov 2025 at 12:11, Matthew Wilcox <willy@infradead.org> wrote:
>
> Would you rather see something like this that hides the fact it's
> dealing with HIGHMEM?

NO!

I would rather see us stop writing WORSE CODE due to the abomination
that is HIGHMEM.

> @@ -67,11 +67,19 @@ static void check_element(mempool_t *pool, void *element)

You just added more lines of code to deal with something that we
shouldn't spend one second of time on, and that we should *not* write
more complex code for.

IOW, I think what should happen is just something like below. IOW,
just remove the useless garbage.

Think of it as a small step towards the eventual bright future that is
lack of HIGHMEM.

HIGHMEM was a mistake forced on us by bad hardware. We should revel in
the fact that it is not really relevant any more.

            Linus

---
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 32b65073d0cc..ecfb65c09651 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -58,7 +58,7 @@ config SLUB_DEBUG

 config SLUB_DEBUG_ON
  bool "SLUB debugging on by default"
- depends on SLUB_DEBUG
+ depends on SLUB_DEBUG && !HIGHMEM
  select STACKDEPOT_ALWAYS_INIT if STACKTRACE_SUPPORT
  default n
  help
diff --git a/mm/mempool.c b/mm/mempool.c
index d7bbf1189db9..22157d23cdd9 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -12,7 +12,6 @@

 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/highmem.h>
 #include <linux/kasan.h>
 #include <linux/kmemleak.h>
 #include <linux/export.h>
@@ -68,20 +67,9 @@ static void check_element(mempool_t *pool, void *element)
  } else if (pool->free == mempool_free_pages) {
  /* Mempools backed by page allocator */
  int order = (int)(long)pool->pool_data;
-
-#ifdef CONFIG_HIGHMEM
- for (int i = 0; i < (1 << order); i++) {
- struct page *page = (struct page *)element;
- void *addr = kmap_local_page(page + i);
-
- __check_element(pool, addr, PAGE_SIZE);
- kunmap_local(addr);
- }
-#else
  void *addr = page_address((struct page *)element);

  __check_element(pool, addr, PAGE_SIZE << order);
-#endif
  }
 }

@@ -107,20 +95,9 @@ static void poison_element(mempool_t *pool, void *element)
  } else if (pool->alloc == mempool_alloc_pages) {
  /* Mempools backed by page allocator */
  int order = (int)(long)pool->pool_data;
-
-#ifdef CONFIG_HIGHMEM
- for (int i = 0; i < (1 << order); i++) {
- struct page *page = (struct page *)element;
- void *addr = kmap_local_page(page + i);
-
- __poison_element(addr, PAGE_SIZE);
- kunmap_local(addr);
- }
-#else
  void *addr = page_address((struct page *)element);

  __poison_element(addr, PAGE_SIZE << order);
-#endif
  }
 }
 #else /* CONFIG_SLUB_DEBUG_ON */

