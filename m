Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D462EC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 21:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2D66B00A4; Mon, 21 Sep 2026 17:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C886B00A5; Mon, 21 Sep 2026 17:26:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91B486B00A6; Mon, 21 Sep 2026 17:26:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA296B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:26:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB865402DC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:26:58 +0000 (UTC)
X-FDA: 85239054516.09.A2CED07
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf04.hostedemail.com (Postfix) with ESMTP id 349F840009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:26:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qI3MKHUh;
	spf=pass (imf04.hostedemail.com: domain of 3H6Gxag0KCIQijpq0pmsjixi1owwotm.kwutqv25-uus3iks.wzo@flex--abhishekbapat.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3H6Gxag0KCIQijpq0pmsjixi1owwotm.kwutqv25-uus3iks.wzo@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790026017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sGtqedsZp9Mv9p5klFEFRiNUNOWdSEz9xQsHh22BPzw=;
	b=K6xsE33BpfWt8bg9xl1Dqex2a7crMytasZjGj1MjokKG8Edoo7w+Tutgm896TMlWw7nijU
	jOrSbInrazylnPgbIsxs6Vj2MEKZ9/dTju5D6d82kMzukjtwGa8SePBOsLeYD8/iZJD9wZ
	VAxIW/P3nEYTUH4Bi9CNW2FGpBDm08U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790026017;
	b=H3al8qvs883o7noCeN9AAiblRM8cRJi3wxgc6SOKN6lSb+g61sS3lwicXfl9oW2MQkMo7o
	yKGTVCFOw2hAzey8EGoVk5kyr7lZNnPs4fTr7jUsC36hbfVvzAOkuF/Okok12gmm/NbuxD
	OEGlTADLellElWwVoiRP5LjHqpKg7U8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qI3MKHUh;
	spf=pass (imf04.hostedemail.com: domain of 3H6Gxag0KCIQijpq0pmsjixi1owwotm.kwutqv25-uus3iks.wzo@flex--abhishekbapat.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3H6Gxag0KCIQijpq0pmsjixi1owwotm.kwutqv25-uus3iks.wzo@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2db3734d06dso59908595ad.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790026016; x=1790630816; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sGtqedsZp9Mv9p5klFEFRiNUNOWdSEz9xQsHh22BPzw=;
        b=qI3MKHUh4GGkRQxWZ9Q48P8O92CurbW6+cqxMICZRqI6XJEd3CNEo5QX3pwVfbv45z
         x5hySp79j4Xtlv2rgTvLDihbIpDzB62T5BXyHsH0J7TtshWVgdjzbruLYdnVuR6ZCqNr
         ZSo2YnxuXca2Za2znAVWmlehTMOmQh8UYOT1ik0XL+SHL0UGSYr17eqwqAP3Aezyz+z4
         cUf7TnhiV1OEq6HiXztjonte2aABcdKZsxvr/lhTKtRKvMT74vUv2BsmBMY8QNvkgBPD
         1zO1RWDXfcGTTVIIh0KHplDb6xjlwMwDpdR7dSwVPaGTYy7/QaQk8H8ugNed3M7M+2RY
         eMjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790026016; x=1790630816;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sGtqedsZp9Mv9p5klFEFRiNUNOWdSEz9xQsHh22BPzw=;
        b=QiizWQNfUp+0NF/plsQmE+0bhtYN28iKteKVC+cC+uQZNzZVzIz6u9xrskkDaqc326
         1Ti9QAK2dBheGMZ8HHy3zsI2XbRD8d0z31uQiCwcF3qV1NHwQ/8fTnjQg4f/+VOJcke3
         HSpCbx/ffJpbQro2w54nA3TY+IBh6x4tdfx/FxZw4UuBG9B24E1YtXxbdhaVj/V8qIDJ
         o4Wv4CMzmC+c2n3oQdOZq6v+oMHnJlf3bSqnSiueT1RiaCNyKBtz9SvJ/GSa/kMLUnqO
         QzccEohfoh4M7f9IG0pe5TN9lhOLi5FABH61gZyYnGxBJh1CtGIpvTd2C1LE/NuOLvvx
         GzNg==
X-Forwarded-Encrypted: i=1; AKwUvBzO401P6+gffI887Kn5d3pDizzz+kcpHvs5SA1dRLY9BApgWj0tZ0HAYtLItQljMfhMyn2lM4OFFg==@kvack.org
X-Gm-Message-State: AFuF++nQ5FbdZuS0lMEQ4FEmyjlZSwR/bfTnndrBrIQxuTz3eUi6hhfS
	wdeKrfAKBb7aZaRxZHF7G7Tljj6lx+KRdxhzYsyrqrafV17SryXsVcf+mCI+eMSd40dbTrZ5hfK
	iKWXGwjbXJwF94BRfcdZcy+RVb8DfaVKytA==
X-Received: from dyx27.prod.google.com ([2002:a05:693c:821b:b0:33e:5767:2163])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2f89:b0:2d9:3850:2741 with SMTP id d9443c01a7336-2df5b0edd73mr4636595ad.0.1790026015752;
 Mon, 21 Sep 2026 14:26:55 -0700 (PDT)
Date: Mon, 21 Sep 2026 21:26:37 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <cover.1790025465.git.abhishekbapat@google.com>
Subject: [PATCH 0/4] alloc_tag: Introduce selective tracing for MAP
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 349F840009
X-Stat-Signature: jxokcm4z4m9zzdd9kpeeoghz3xncawzb
X-Rspam-User: 
X-HE-Tag: 1790026017-709307
X-HE-Meta: U2FsdGVkX1/t9pj/dQXbhoWRf57aApiOSOQX0C4oGMmVXI7mWr3wJdP/tTao6NEyGZJ6lXIxrT5xq7SqXZNWhNEEYAKERNtEKZFYWmAeoEgk/LxYPbtM9E5hYfLnmvqdLiOzX1v+gVgrxLZriwSkDpZIzmkjHkfyWoyMgmG+Ja14LJ/xja1XvLtta3tA3yMaD/2sWJ4dnJuNlL2Eu2Y0gHlLIqjC9CPnGZFpieDsuAlRJ4vCav/8ZSmVCTWzl92uxEkVw+F8zLUiLjp6dD7r8imYIWdEeGeNz6xUh82XCtAnn8s6QSrifMklQyfimf12jk53U3oHRkocRj3yuXjpciFfVmswIrHun70aOLPjFXFvMs+L9gGRiTwnat/Exauh1zJeBLY/OKUp+C1h7TCOMIkllHmp65WZby0nZdDryboHyCHYR8AKxR/OJEof1XaF8rNybui+/J75In1hpLbpwrcE+uxDATLX8ZZHsFxwRG865xKoEoqki8NzyWc9/g2Co4JB9AAinIuu1JI2eHO/XLZEWeQ35xlP+Jvf/frZPkiimE2tXFJRluVYsCaBOzGcdaVbtgWX/FDLAtHKVWvEwlEeYvH3JgSXQViF6AE1u5cCkc2iOKBp2HQgGQeneQhMl6YcN9H7VKYA4+C6Y3xOuYPp1yvDfhS1FXO7KXqsSYe1AKG0J9ctEnpBB1OZesnnhl7vFVVbZoo2u/UXuTgC33L2NV+T3L2HP1gezxzlPj/cS+pR0sOYehGP0lwB8mSQeX92kwUR7dCxfeEKVDNXJJkqr4VpZEzoi/ueoq8ne8xaGSlG1E2QchS8AlR6i5Gs0iDgKAN1maK/IaqtsQ+P/KszgsJvLJcuHoJR5adnU+kkogoOiwung6fCD0K3a29nqxUgvO6fmx3kYw/tCqwHC68MeMs+4FTeAbMFnT9bbr7Z8x8AMKp/TepQnbm7QUU6ynlG6JgaCGvWBc7Fp3p
 y3LVYRNL
 gQiQS17GBzTtqXnDwDsYaaWZxKOV4JS91p1vMunYMi2L/fEHMdn9rD56Q+pKYUcDQfQnyVo28sV5RCJSLh27e195m0xO3iKlll6ZiiUlGmzxeNY5w46I6vQquDvWT/z0XwzzCkqVmLulGXvk4NZk0o3AHWRr2C89ldrnyBu5bcpXOo3h5BIIVmSUpv21ijKj4QRrhbueqxjOgxIkM0snQOiGK3PtH9iEyhelBxI/GMdl4+y59UQkRKnRUHiEZAv3Ro69T26trZm+hMMYIGFvkgk7Y5YS3Eb3f9qAR9FjIiEzoI0HGBZ0Gg3r3rzKgaBkQWssTyeGW/m2jYnJBQzzlNnf3hE0ghQS5bPn8yrrTznhaWj9pvxc7WTyOyFT1qUyJU93w04DJI6iUeWC0FyDQC0276cUjjhtFrqFvaBoYs5mFHVvAz/ssPT2HJUOBvCaTJtXukrKQLGzif49P6w/4Tg13od/OjQbd0W42lI2IdSunV/wbvNfad6gzMnT2EzdnpJ+XMS2a48dw9oqk5rvoXIex9GSpRSxDNRwFBlJngtDl2Dh7TNwa7umvcsAdqA/1Y+NMxbqE4Jeinoqk8+v31iHefgMIZulj+JR/d80aiv/4/B9okFi5uq2Qeg7ThyhTe8ItqaBQCi6JbGx1lCmjuDYqSdFFwmOuFM0OgN8UksnKpk59eN0m5H9wm30lh/83y7Y+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing memory allocation profiling (MAP) tool accurately maintains
aggregate counters for overall memory accounting. However, relying
purely on aggregated counters restrics the visibility needed for
targeted debugging.

This patch series integrates three new tracepoints (alloc_tag_hit,
alloc_tag_mem_alloced and alloc_tag_mem_freed) directly into the
alloc_hooks_tag fast path.

Enabling trace events globally for all allocations introduces a severe
baseline overhead. To limit the performance overhead, we let the admin
select specific allocations to be traced.

A new IOCTL is introduced to allow privileged users to determine which
allocation tags need tracing enabled. The IOCTL utilizes the
pre-existing filtering mechanism to specify the allocation tags to
enable tracing on.

Abhishek Bapat (4):
  alloc_tag: Add trace events for tracing allocations
  alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
  alloc_tag: extend allocinfo_filter to support tracing queries
  alloc_tag: add a test for trace state toggle and filtering

 MAINTAINERS                                   |   1 +
 include/linux/alloc_tag.h                     |  94 +++++++++---
 include/linux/codetag.h                       |   5 +-
 include/trace/events/alloc_tag.h              | 122 +++++++++++++++
 include/uapi/linux/alloc_tag.h                |  17 ++-
 mm/alloc_tag.c                                | 142 +++++++++++++++++-
 .../alloc_tag/allocinfo_ioctl_test.c          | 111 +++++++++++++-
 7 files changed, 462 insertions(+), 30 deletions(-)
 create mode 100644 include/trace/events/alloc_tag.h


base-commit: 8d61431ed2607386b427752505379536eb634ce8
-- 
2.55.0.1082.g2b9226bbc0-goog


