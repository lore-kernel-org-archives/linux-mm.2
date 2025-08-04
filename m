Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDB8C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 19:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF2F6B00A1; Mon,  4 Aug 2025 15:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B66E6B00A3; Mon,  4 Aug 2025 15:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC586B00A4; Mon,  4 Aug 2025 15:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE046B00A1
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:18:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E73C115810
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:18:30 +0000 (UTC)
X-FDA: 83740036380.22.29A2DD3
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 03FCF40002
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:18:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bgsrxuny;
	spf=pass (imf01.hostedemail.com: domain of jannh@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754335108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UiTfAb9cnMOM27iD69XKZ3u4igfynQ6rP5nLGl75Z/s=;
	b=XbNGB9HnCSfbcRh8Pn0CpoKoqWhV2ghznoMLED48X9aq+IxR2I327xM/ZR1JvjDYHcaqUB
	jqIfGFD8IiutrP82zustbESq9WamZApaf4N40QCsl7S5qYUPI5wMICSqipp+K8mvOVlY/d
	jFQHNLODQ26zPxYg/3DxlgZpgAeLNJ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754335108; a=rsa-sha256;
	cv=none;
	b=SV8TpY4MWHNzVhVSsYfNs4Z61C8BumWJP6BXRAYJyukqJjrDGa/q3QvOlAHkFuYiezW0eh
	xnGvWbnzKhCJIChfoW+MlC6W50xPTpzNnIRFrh3V3iucOI5HjcD6d8Jvp/BLWC3LrqGpO7
	SFAa9wKrlVkvN5glPfL/ALtcznUx/iE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bgsrxuny;
	spf=pass (imf01.hostedemail.com: domain of jannh@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-458bf57a4e7so165e9.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 12:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754335106; x=1754939906; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UiTfAb9cnMOM27iD69XKZ3u4igfynQ6rP5nLGl75Z/s=;
        b=bgsrxunyIxDYE2E8bZEI5sai9kt+xyMgCiZ0HDsy8rNdzfQ7cEaCBtpp3yE/TAljVZ
         VqEdhoc2gepOlDomje3BjWsOXE2wb8gEaGIbaNTXUJtKUFbc4W2MkC2V7jjGh6zXhjTJ
         ewKlxeqZE45lCkfv7lEJFXmNg/p3/mMSIqXVJtQkFkudRZnYXiNnToEN7xYMfVRXinu/
         XKyoIuROX7DXpJoCB0a+DWKwLYD/590gwwd1Qkx/dbKBohLcQe4PZg91UtbCDqWDTflL
         XoP5MS4o++Ta1K0dDVIev3/rAYJJib3Y0DeYpvOC3kBTjqlL8SgfS+THArX4wuIW1PwH
         6S4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754335106; x=1754939906;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UiTfAb9cnMOM27iD69XKZ3u4igfynQ6rP5nLGl75Z/s=;
        b=Rhx1G61uJ5q6xMgOBri5trOcY738Fv1m2JXXX7ywbT6HIh3nHCD2IAl1c2l9RfD4wK
         vEc6xvNxzfH8QOX9AnqlE+tBehdA6JOj2alBP9NQg8iqYKmOVk0/xeGgwKda4Tbg5h2G
         q12VGNRfIPq5Czwosdno3LEO1jploVdgaVslHfBzuBuiRUFz83UC7e3und0dc6FVugjZ
         taElH/aWYKZn0leMkz7EYfRXKpHN8SpCjZxLfPDriIq/o5U7MvYGt5T7qCkFyv57Z6Lk
         DEFGipb8x4jiDkDXYx8swVAVVTfclflpnzhVpGEWdOIo4bvN+1A60qRdlcWf1YcHVEiq
         0Nbg==
X-Forwarded-Encrypted: i=1; AJvYcCUfaHJ/3f8Bfs3DECJP9UcB5jrO5f3JV0TDJ8JkMGCh+1tje9nR7ga/ZeHloZWfkz3paOrx5y0NKg==@kvack.org
X-Gm-Message-State: AOJu0YwQ8uxuLluQv/o+gf2+0EVXd8M8Ekr3Mn4hmr8NLDLCj/9Dx/Ch
	/lY+HrXtto/89tbNiaWfOs3igf3oopeWrfOvPsW7pfi3y9i/FnCBfrkFnQmX2AZrcA==
X-Gm-Gg: ASbGncspr+cQWFNMGh9r0PbDg/rOfZ/yDiMhnuIrmx62VDvu7865rOEr5RScp7+C+Nq
	fR+q+9gL6e4pFJyKS0izdmPN76i74a+498AzuVAmYGwiE1p/tc4JXz4lsUo1BerMeSPkVO86zZC
	eFcdphdbF2D4n+WzNpSRTESvgozvjZpvhjOWtouxh76jJQx0QnSgjD7gmaOJfpkgdxwmsTGYoyw
	qvesVYvgtT+exPUKWscvjcJyghQTIs7Ky9Cjw+djmcJzj7pQfrwSGpY0fyjxAOGp0tkb1HT9cOz
	S1XScZXhuP0gCfInRKjf+oMuFURtlDCbTWHHk6wEkLD1NJNryW/mOcixhGCTMdDKo4pbhohfn5O
	C8ew4J1NIQw==
X-Google-Smtp-Source: AGHT+IGv48sGeD5VUgCauZAiE/92kma0rYRuzmY0NHuib68VVw0+Cdvc44IEf/hoe+8yq75/M+2y6A==
X-Received: by 2002:a05:600c:444e:b0:442:feea:622d with SMTP id 5b1f17b1804b1-459e14ef635mr140015e9.1.1754335106255;
        Mon, 04 Aug 2025 12:18:26 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:2069:2f99:1a0c:3fdd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3b9386sm16502103f8f.18.2025.08.04.12.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 12:18:25 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Mon, 04 Aug 2025 21:17:05 +0200
Subject: [PATCH early RFC 1/4] kbuild: kasan,kcsan: refactor out enablement
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250804-kasan-via-kcsan-v1-1-823a6d5b5f84@google.com>
References: <20250804-kasan-via-kcsan-v1-0-823a6d5b5f84@google.com>
In-Reply-To: <20250804-kasan-via-kcsan-v1-0-823a6d5b5f84@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754335100; l=2094;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=OF7LyNhIL1EOuOn5pfi758khliHdObXKjDRY6+iPVTk=;
 b=Nj7lWb06h7SXCifoXeKMs0DUlOqOdP4H8VnS8Otq1aKjtHh/Kl7wkBiRiTwimSc9Mb/vQL3wz
 G/GTNIUIiYQAgciu1KMGaY+kSTClICVFU5L25WqzmjcvA+7+WE4fbAH
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Queue-Id: 03FCF40002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: a5ckzjrg5cy8m45u8n3fpnmeohkirmb7
X-HE-Tag: 1754335107-691549
X-HE-Meta: U2FsdGVkX19O3yvFLkGs2tdqxIuodZipGgct6jibBeZUlYEI9eVOmR3RS4hl8HZFG2kadLmYS7jQxJd4QP2lRV7z/FqjxAQzQ4dU0b+zIHsLmQ04y1bWET5nqAo51xOJqgRYarZwIgDGG4xIiq8p3Ug83Q6EZ8kv4N74CiiaYm/k8Z4Ag4luoKQuPVql7UW3SOv/1P/pFSPYHACycGcPWJNZpCAHZo1qq9pU2WSG9QnQ5MntLUHOvy1/3sR1lKzQ+/Y1crIEVqe8tyVn2iXVFULB4O0vRr5x+0JnJCl6iZmF2AR2MAuF/nj5Hfc5M9H6di9KiUQRJA1XVTcxLujgot4TtPbjAeMltfLEXIiaBHyISOjqW5RqSYXuEMBSin+eWrn3A/P7zg+8PQjtBLkE5HOVVYQQuzbcVZ1anKcFQDLPk0X1rl4wKia4q6Him1koT2anRHiCs3NKGfjOFhZvxzcg4dPU361QjYFSuwKyu6BepkYFuwc3IO1HYbIiyx1ISR0y+8OLU6W9NqUeQmS75046A3sCaOC69i3vqOZsWHdST/oAr5Di+BPz53QIz8XyZb9mL+cMcNn+rVR8OdXRyMxit/6FhUyVC+AotgBnr/8ESrxFXNmdrCal3vec7Cy+lqKrH+KTrLJQIFAkCUZQvbJirbupgsbGq78walyy1+hmp/zTm1/ypdfYYq2fd3vruBLzTv4Ss2rrwzoHnHqStlG5gPuhN6WSozzwbjkH7X+qJHK/7y3xOmC3GwQMOXRd6ocv/Hag1iI23hjM9CGVm0vRyr2sby1a/1v5AZileSmGQgtk3biGc7YmhBMNLTctKiGhaYoGQ2PAIemSwQmZqZ/PAyH2/SED7Ds7CpFhwc9riBsoBEDtu0E8HnSusINbbHRNY+HPOS/6Sn6jUQJJV5J6+CGvUN7LnV5csLzsY8RLz41uLzb35UmwmXz5bNTPKmCFqOMNzF1DPEaBJ7w
 bctJfF1r
 Wx7LMpfqDUNTRp+qib/MBFgY0xHSlNeLC6JMIoSnO8mr2ajaWXW/AVaxGckl1yB3DnVXKIze+BYLHxDjAv3MeC47Zj+iN5NbS0PZYb1iFKcKITI+lDrzOjn+gfiP4jeU5Ma7tdp7s0d+/DNr0aKJQWRfnQyiODwZUje3NVDcIMroWhpwEH9qPQ39YR8ua5sukygaEQKTVXbO6UiDeIgLx8QjNIZYx9PGi6wjXoXHLU6CLNspzRjXghxksWFVmP+Vave+uX+U47pFlUNveZhegioZ9bl3Umu4Doo0ruleTKBYA5b25Vx4A6OrswYdJ5nDHon6ktt6J42FH4WnsdGomoJYTRXYxqAa7gbSTRYjQf2h/tqf/I2FTdZXu+9QWmwPT5xEX7AuUW538dDaU0XDguSGFSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for making the logic for enabling KASAN/KCSAN compiler
instrumentation more complicated, refactor the existing logic to be more
readable and (for KASAN) less repetitive.

Signed-off-by: Jann Horn <jannh@google.com>
---
 scripts/Makefile.lib | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 1d581ba5df66..017c9801b6bb 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -52,14 +52,12 @@ endif
 # Enable address sanitizer flags for kernel except some files or directories
 # we don't want to check (depends on variables KASAN_SANITIZE_obj.o, KASAN_SANITIZE)
 #
+is-kasan-compatible = $(patsubst n%,, \
+	$(KASAN_SANITIZE_$(target-stem).o)$(KASAN_SANITIZE)$(is-kernel-object))
 ifeq ($(CONFIG_KASAN),y)
 ifneq ($(CONFIG_KASAN_HW_TAGS),y)
-_c_flags += $(if $(patsubst n%,, \
-		$(KASAN_SANITIZE_$(target-stem).o)$(KASAN_SANITIZE)$(is-kernel-object)), \
-		$(CFLAGS_KASAN), $(CFLAGS_KASAN_NOSANITIZE))
-_rust_flags += $(if $(patsubst n%,, \
-		$(KASAN_SANITIZE_$(target-stem).o)$(KASAN_SANITIZE)$(is-kernel-object)), \
-		$(RUSTFLAGS_KASAN))
+_c_flags += $(if $(is-kasan-compatible), $(CFLAGS_KASAN), $(CFLAGS_KASAN_NOSANITIZE))
+_rust_flags += $(if $(is-kasan-compatible), $(RUSTFLAGS_KASAN))
 endif
 endif
 
@@ -94,10 +92,10 @@ endif
 # Enable KCSAN flags except some files or directories we don't want to check
 # (depends on variables KCSAN_SANITIZE_obj.o, KCSAN_SANITIZE)
 #
+is-kcsan-compatible = $(patsubst n%,, \
+	$(KCSAN_SANITIZE_$(target-stem).o)$(KCSAN_SANITIZE)$(is-kernel-object))
 ifeq ($(CONFIG_KCSAN),y)
-_c_flags += $(if $(patsubst n%,, \
-	$(KCSAN_SANITIZE_$(target-stem).o)$(KCSAN_SANITIZE)$(is-kernel-object)), \
-	$(CFLAGS_KCSAN))
+_c_flags += $(if $(is-kcsan-compatible), $(CFLAGS_KCSAN))
 # Some uninstrumented files provide implied barriers required to avoid false
 # positives: set KCSAN_INSTRUMENT_BARRIERS for barrier instrumentation only.
 _c_flags += $(if $(patsubst n%,, \

-- 
2.50.1.565.gc32cd1483b-goog


