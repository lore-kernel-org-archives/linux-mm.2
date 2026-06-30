Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E74B3C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDEA96B00B5; Tue, 30 Jun 2026 11:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E8C6B00B7; Tue, 30 Jun 2026 11:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DDA6B00BA; Tue, 30 Jun 2026 11:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9DA6B00B5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:04:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23CB0C185E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:04:54 +0000 (UTC)
X-FDA: 84936901308.25.E225974
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5833EC0012
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:04:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hcGTnTl5;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782831892;
	b=FIuZ9HdyzTjJ+T0GhVwjBGpzu0k+75VwzJ/VxPy0iQpFlwZHWp/1HjjAVGV22nvdkiP8Aw
	Lh0i6U7O7U/sGCQzaXHmijoEB9+9TeEhR2TmV55QTUq5xNTuUsI6AGQtCFJsw+77trDzjT
	QqmeOSv3/ZNq6GdVsTQo0fbd5qysIaM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZ+KouBHR2A5cU5ulbS52ssZaf2NlH3yq/de1XOWkF8=;
	b=lYE6BHXeAg+YRSsxeRVQtK7kSE/OoJRA0lZWSFwC/hELwKXeILgHDaTm6XHq18SJZh8upP
	uMYKh1MRrucvlyPxbcqy1v1q3t9sq9LGn2HE86E9EUoFjv2S28hSiIflrg4IrLudeXzz5L
	YVuqBFxfZ3PaqRTm/2eBcB5CG1nbbBo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hcGTnTl5;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38005a36edbso1352460a91.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782831891; x=1783436691; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OZ+KouBHR2A5cU5ulbS52ssZaf2NlH3yq/de1XOWkF8=;
        b=hcGTnTl5yT5CPWTdpPqmMKNxlrEbpY9xBZEw/PM0Rq0+Yu764BCMycfudoRsIJJfRi
         nMBvbGvNgWcZ7/JTszSYG9xpRK/DIM8KzHq+YKAwwSF6LEwYRj4dnZrgsqB2+gCvv2+Z
         LWAf2sr2nr5aGkUJ/nGSX2jqWIkboyN1ccW71277xqp/maOSTjplOHj7T5rCDZ/WnKIV
         UA/ANWLVUl/SvH2CsPeORES/ZCnsNYEWZODLVEl6JDXVrRWSuHq3UZdZGneYI0p/6xs5
         aR52VY832GT3gYTttL0vrta0V0g6Yv/K1va+/HhZ7z5CqA2s0VbhJuGYQnq47Mi+BfYt
         Q18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782831891; x=1783436691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OZ+KouBHR2A5cU5ulbS52ssZaf2NlH3yq/de1XOWkF8=;
        b=HNVS0oNP1wDRhaWFprJzWRR+NzzRZAQO3aXSE6FqdlpJvNcrtfu5isZzZ+h/+6vLLL
         v9vzm5EjaNWqs1D1nLG0lTU2C0QhyYItU4XEPW1MkL+GWpctib1o4cTq8RnpIarkOjmv
         W/GPdRiwRqjv/3qf7MBVRFCxRfGErToTcI/CqVt9kb6Mb+tvKbqW45s8OtVg7cBiFHGm
         3omk0i8I46C4bJ+kQQ+3FThzy+PpU1EvLzl5Q1ZwGghU1fZlz0W7H7AtyxNri4UhopPV
         9krKLxw9CwfLknY0XlgKJ/gXE1ZUDrdgfVyHOW/kt0G1PV0SrqBEMU1b9Kx6wKWWmk7q
         GZKQ==
X-Gm-Message-State: AOJu0YwONqkuljkk6wirt4ZMK5qhqTsfmC2w0yKk4BATXZgAKeMK8o4p
	kwOfcvTY89X0wgfvkxstk3qBqhfI9MgS3OCFFNE05FcOpGRhtgfypB48
X-Gm-Gg: AfdE7cno3l+hBIgj4kmNyHjt1Q362uHXqqyIzczcrHnYvFGsbQWLLLIMkGATkIqAlCp
	PayItZH6f60Gsj7iR/mXKkgimAAJkr1Zd7Zg6TDOnUa3XiZjRsjoCSjjkgYZMTHjj9gG/r8dQLI
	9XJ0edibBoag8KCSeFPC81TFUYMyRL2lTDh239ZYLczdBfpWwKMez9NjyG3qw398xpq66ek+NCJ
	N2AcaWETkv8R8GyyKBBfdrqUl2DN+n1T4OzsiAbNxOlpzNZlmXnqfzaFk1OCFzMrMiZo+KWyX+h
	7om+SDBJuLE+3gkf6vmDGLa8O+3houPEf1aKgirHTUpYFWkNvEeJoAFxysptTfKq/pw1hqG8N7/
	MDPs8IWWpfFc/L1VRpo3C/b1jzG6ExM2lcwSqOvyqwts8aVo2jPD4+vIU5D3kE60fwa9GrPwLPj
	Uxs5rXaf0=
X-Received: by 2002:a17:903:3c0c:b0:2c9:feea:4e4c with SMTP id d9443c01a7336-2ca5a55308emr7483055ad.15.1782831891075;
        Tue, 30 Jun 2026 08:04:51 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37a70bc0sm16250465ad.10.2026.06.30.08.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:04:50 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>
Subject: [PATCH v3 4/8] riscv: remove unreachable invalid range check in kasan_init()
Date: Wed,  1 Jul 2026 00:04:09 +0900
Message-ID: <20260630150413.1718632-5-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630150413.1718632-1-ekffu200098@gmail.com>
References: <20260630150413.1718632-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: py6yz33e6pj5t6c5fpgod5bopz5r9441
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5833EC0012
X-HE-Tag: 1782831892-79552
X-HE-Meta: U2FsdGVkX18f+/u6zmWosuVdl2uxe6te4A2z6mqLpDYEkPkFg6j2KsAISjLkgiW5+CT0l39j27/iNaqiM09CTNTKObZv56FCyg1i8cWNiwm/95Crp7cAebEgNe6H0dSyHyI0wBAg8FIZTvTxpPIh//MWhRyJ+Iy66TrieH172P7j1ZCAKFZpsluEqb6own3XTrVcXErcegkDo0Y/nfhDp8ja82PyFVNCDAlaxfV171mUIGPD9vCeQJq/TAgXhtkDLsr9tUEs+NNDc9V9+NDrGvUTftOK3kxoc+DHAp37XsiPk7pvKvXA6EwvlXju6lx1Ot9FsieZRYgrfKAg6WhrHTtnlOc6taTWzMb2/osomuh/qFejakruZgRJlwoH0K6Zq9HH52UjmnHasrvodkZxiuiZTfBVtEjAKEqoyHYaKFP3i/4OZTXE6CljdX5/tU4+T3rNSZkJiqHY2VLbmChfXw6eGydu23zifIdsTqMCP0/NhYtZIc/Njua8fZLv9iPiAoxL4xLiIfqWsJKnCmyQUrBryrWj0n2fiuYVcKn38EFh1PMaByBleqWOM/lQfvRPFZkT7FjPIPC7OH2p5zyq/SNyTlGTcqAZRCL7VTwit6a7+SPCjcCOigBslE8b4E7D62RozwW91r1gRlWkoEoFgYw2n+OaUgiDRHjd9QJ5tIpgviU+Ype2oPdWT4g+fDRsyt7Znc/kpQgbQPsVFTgvyEqDkxPwKlfwgxkFQuWw5yYZfn5j671UIbpJoa0D5dcJ1d40M6kr8y4ojIWPvVAIYBBnrNnU/oeZEvf4Q8xufXmYvS+srP8hA8PSzuWfeDAuvhFI0tD4+UHlnuKaPjRRAJMWdSUQW5T7D5RGpbChjDGydEp25fs2QbAE6Tm6/9rxUcfTOYQ3rW9se+GqzPhVze6VLvrwVnerZmf/SSpVbDAeIu+ne+nI3Bd0E+WAldUW6zGn4dbkVfACu3ZjQC+
 Ct4xzW8e
 KDtjRWoVGaThuuTvK00AetHnuTNNZZbhcJlbdm9Wxgp9ljeI06szfoUicT29FVajY8ATRkd73P82EY/L/xTyskXcY33EizgB9zNMu0mQpD6THq6DaHIVaDaEetN/ranmTaFULOf3rb2E3CvqidylsDdgFoKIrxnOCkRiCBynExrkW9Vi5KecrHO9AHse1Tb+DW9Y3GCeN3cEGsqRI6WYzcnDrmbrdEotg19a1X3Zn4DFXWVxIXnQC3z2rRJD9pSNkW/2vme5fSz48hO/r/tRu8U0mGps9lWa2kWPpRm7fRVuXuYS/rBiW5+lyKXeaQJCqIlPKk3XNthTRUAiXxjERcEjy3t9JeW3DEzOl1x34l5nuShKJg9Eg2r1O/BwVWTnmu/Z84pXzMFAcyRUGnrOlLhkXDTVmducHgq8w591gCw6bbT/aEx4yb/PING0Vo3MuPARzfz1VVHYF1bnoMg4nVGmgdPBDXlpRgDwlDD9nN+HpsL+luIZ7X3ZuLNFPDvIYV1aoR28h7I94Y+JNARUtxQWp2kUJu8ffoCTQFH/rxP74R+Dh8vx0eFaDOx1TjHae0wfc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_init() populates the linear mapping shadow with for_each_mem_range()
and breaks the loop when start >= end. for_each_mem_range() never returns
an invalid range, so start < end always.

Therefore the start >= end check is unreachable, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 arch/riscv/mm/kasan_init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index c4a2a9e5586e..1f3aa9611187 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -512,9 +512,6 @@ void __init kasan_init(void)
 		void *start = (void *)__va(p_start);
 		void *end = (void *)__va(p_end);
 
-		if (start >= end)
-			break;
-
 		kasan_populate(kasan_mem_to_shadow(start), kasan_mem_to_shadow(end));
 	}
 
-- 
2.43.0


