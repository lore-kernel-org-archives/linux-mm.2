Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F24CAC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 19:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235686B00A3; Mon,  4 Aug 2025 15:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BFDB8E0006; Mon,  4 Aug 2025 15:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 086848E0005; Mon,  4 Aug 2025 15:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAA886B00A3
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:18:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C58071609B3
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:18:32 +0000 (UTC)
X-FDA: 83740036464.07.232F33B
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id BC7D440003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:18:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PVv1na+b;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of jannh@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754335110; a=rsa-sha256;
	cv=none;
	b=lvSLo1vLAJ3MDAIxEuc4vfFix9cCSK/AiGczhsRLCxpQC0OZ3zb5veNZ6A6ehlKWpi93hw
	KCRF9yqOVksqQL5yIKSBnAhPLR2vaoJyOVsR88ApMfD9afGho8tF69Wj6Ah7aGR+bPPITN
	wehcw3cmLa1cr40rTxnasUtI2WyA44E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PVv1na+b;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of jannh@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754335110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+ElZLVKoAO1zlP8cjrF+LYIULpb9l5O5jbMVWAEu58=;
	b=E3yAsBCcNXDrhsR1hk3JbXphkLwNKgvEPXCzKqLGz1yAnkJW+Gll/bemEwZtTh7ZiCqzfJ
	m+H9107TfvSfVqv2fkoXsHpr+uH23QNp00SdjgKpno10OAGjsK5/n2aFA+GkE0NeNjY3Me
	faEkbhLnAbKy0JN4yxSjNAK0IHNUNRM=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-455b63bfa52so10635e9.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 12:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754335109; x=1754939909; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L+ElZLVKoAO1zlP8cjrF+LYIULpb9l5O5jbMVWAEu58=;
        b=PVv1na+bDc7fie0esmmwfGFRW8cdscsiQl0bU2IYohQ6J5hDSRjmlkHqaLLZ8PIc4w
         Wk75vt0bvUSqZwdOz2svEX3RoVJKvA47bqQCZzAOfvvqIYrq6igtNMMNkFPXKv9xq4WZ
         4N8fnz8+3YcBVQhOEoBGJJ2j4K0kOw2+frYRvy5C9AK5GOtMAlHhawXMUToyq4PkYt1M
         mmfOdfejgmrr7u6YFHXd2iF5fPJhxaX2zdkuaBXUpthRAigQ8+If2mZJcWkiFRljgRaT
         mjMB61OpWWTJ7C2jsr2zDssJdd8KfsZG5Xlky3vLG18t3zc3uismy/DmY217gCYkEK3P
         aYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754335109; x=1754939909;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L+ElZLVKoAO1zlP8cjrF+LYIULpb9l5O5jbMVWAEu58=;
        b=GrDQcrTF03hbjqC+iUnaj96H8Q0cGgwYPx0ZyPwd4nfNEQJ0QcOUPZACElIoGYbk1B
         GVJ+8fnwD+duO6nDU0zAR6yGm0L5OTtn8tWdAeMzy8IjWICisL5fUEiNYrRTzSMND/CZ
         qKAOc72bbtBAghaKoKW8fPKfgIcO7xYnx+yJLXawEPKFopD1DXOrfeMHe9gCXj/6UTw7
         bUvB8Zo8hyKgTcD27/63qjfGlCBYjIMPqG1txPJytfC5DBg/vt+tcuVEcHhLCTlwwHnT
         LD9Fz0AFFl3dtliS37H0CChbnOOJGoLxEwwyNLNuZyHDV8THbnyH9gxNo5wxompjr4E5
         h8rA==
X-Forwarded-Encrypted: i=1; AJvYcCXQHreA1KIbDdv6AHaGUh2PHTLjcgg4k3Y/eYpydJyIR1bQ0LXK81nBtq0ZoaZQRgFahzE7INvDjg==@kvack.org
X-Gm-Message-State: AOJu0YwYO5mMpADSZfxv2sod2hkg2dDT+QQg0WEjdGsdEDdpK0YMfwWe
	ogypKnqbF099EJzNiwND+tGcNTZcWntnX13wxzE68If8AppoutZVdTbWxHDfuGBFTQ==
X-Gm-Gg: ASbGnctNk8mxNCgj0khiaymJPJmp9y1WMNXhu7fC+rstCkWgksyOnYH7u6ui7xJ7bZ2
	MD0IdeUZwE/RAbMwXMcQY2Uy0VjhjV3MzgFKIX8u/pOo5xhxJNkjcSXBxK5FXlfx6nGoRmMnRbj
	x1iCa2R3CStPvTU68l0iN1yKSFyyxYpgC0m/eZ7SusnlEosadeblxhR+BHA78vmS5uZX+vIuK+w
	pYCWRjimpM8BhVcY+QoN2qPWv6kKlVxNKU+CXnj7SkEtEruzcu/xYyT9VwOLpn8vg3OoY+K7OKg
	mxjAKPL9oHzydBDJ3ySuFBVt0+Jy6uDrfIHVBTXyi1Z5JoLFY25EAEv2/w/SNEMyhp2rW08dptS
	//fsuG8UFTRrbZgROdeB48A==
X-Google-Smtp-Source: AGHT+IFXIw0hETMOIcFdZZPj95d4g3PWYz9SZjzY0rqj09Zgdh9l/ptS5MqTJPdGntxa1C5rvhU2+w==
X-Received: by 2002:a05:600c:4f0c:b0:456:e94:466c with SMTP id 5b1f17b1804b1-459e162c21bmr99265e9.3.1754335109094;
        Mon, 04 Aug 2025 12:18:29 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:2069:2f99:1a0c:3fdd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b8e0bfc79fsm6386856f8f.56.2025.08.04.12.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 12:18:28 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Mon, 04 Aug 2025 21:17:08 +0200
Subject: [PATCH early RFC 4/4] mm/slub: Defer KCSAN hook on free to KASAN
 if available
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250804-kasan-via-kcsan-v1-4-823a6d5b5f84@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754335100; l=2111;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=rDvA4L4QbNOZZHJ9ypWKaY7n7K/aeq1dGeCN1JjgQg4=;
 b=BNMFpmS4euz1y5tN47fZ/MPB/oBGEwflQjmjyeX1N1RVfc1GB9ZCh7BojwIDDdkpsHaV00kuS
 UgRf/ZcDTKmDULwqSbKBaJxSEXdp2iwg5oMuT9N60I9e/Fr6RrmgtHO
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Queue-Id: BC7D440003
X-Stat-Signature: p3gd1jt6sn7rxdhqx9fe8udjn7w9qd4i
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754335110-464243
X-HE-Meta: U2FsdGVkX1//qmzkjPtM1qYVb/exlUq92ErTUZV0Y6XAywuYYzyk6cyOXZLgsppLhqUD2eoAzEPVa0h64gRDdGxwWDsafsXKdpOoY2hk7oo67d8suAymX/XiMug0QUjsQYBvCJsK7bUkeCFvyRd3FsNhB+5i31/kNKmt9Y4CBbGK5NPZY+V338OgLGF6An4rw6QokQ5nOmDMAdlIfnPbVBDz5sZMcIJHked5qumNbCUJRhfR0KwBO93mFR6uyV6uTAltgbv7xYzqiJOkOh2LOFWeo4BVtXnYmVqq8qLK6r426aoZ1+2WwlwQ117BAg670GVKBNmkjqRt8j6gkL32tWc3Hyn+ZzewtSCcveX+hJ0ziXRjnTGvpIRDbmHQXA687Fk0H6e5i3fOc/DzF7190wnhwWkLvrSTVMhlQoFe73RK81fB1gB1D1zf6xnm1BcdhRd8KNxxVUosdSQNKwd3SD4wbI4XQ7ZwgYv+HmLiJwOpycEUpJQf8a00bfh7xI+bcZe17PxtGS5tYaeCP9/MG7GB13eju4GqmsxFnbhtnMWZcUGa/3GDqWx/ZJ71QymSs5+2RyDoiR3rTdmTXhyl/zP+/gWtCdllGUgL8T62JpojekTkwSR3NqTtLKag/PssF6jelYYuW7hCBUTPvNR1oY0h94AubDd5lxJpsjDBJo5XZnfOGEyUu/55EmusSQKwuP+gSHQsDf2l3lzRIckycCE5PoCj3TqWkRZ7vg/iv7g53YUZ2dawTv2Zc28MQv6F+m/18/X2wgQu8LtA1DQ0uXIKqAJnm3W/yp7zZlpm5XkWU6oIkVheYwdEAc8qSrKHTKEtavKCtYIy3ddSECpkmjUi55zUIi+FVzKiqYAoQRUKBnpOQBMcukWuQJHpH/or7Yj/VgfhbX41GNlfL+DlCr5hiGeDTEf4zzZRVaXd+eJ414lm034CBe3DJ+Q+4QbxyvGLPQquEfP+k+xlWuu
 cvXRgjmY
 LyECAxkjDEmeka/LOcqZAmmaIKouSLj0d/9QnnD9pVZ6YtBoB8m/lmTPRu0Ohm5Uw5nTfiXk6QvDLnRbG2MD9bmUAUInGkLt/cBi8I4fgBX5LdIbjqFQAaR+9xDnxAMFeVLokT+TnkWRr1QgO6ghfdpGUJysw5LGFAyGQGDrhBqQo6gg8G7mlVMlwj5hF06ut9bnCFNvUX5mSAswtxkGNJcUKLdUmXopw6h6kS36fUkjYGEXwkTRdmuDEOs74D4/KUm3HxhEAVe7Z3e0+fOM7PJU5gWYmPSajrL4GKHjR1keKRiQTzckR4Qj/Dhu6bDa0NEEFxazmXz8+UIE1md0gihRGdCJDK4/1SG5nbqsJegeapFtsRoJsMmotd3R4fEG7IWSwv8mBLf1ZgstPW9byJDJZyOUwFJnizM5U6zQQlWCniVvTjze9u7LOKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SLUB calls __kcsan_check_access() in slab_free_hook() so that KCSAN has
an opportunity to detect racy use-after-free bugs, for example by
delaying the freeing a bit and watching for any other accesses to the
allocation.

When KASAN and KCSAN are active at the same time, and such a racy
use-after-free occurs that KCSAN can detect, it would be nice to also
get a full KASAN report. To make that possible, move the KCSAN hook
invocation after the point where KASAN has marked the object as freed in
KASAN builds.

Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/kasan/common.c | 5 +++++
 mm/slub.c         | 9 +++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index ed4873e18c75..3492a6db191e 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -263,6 +263,11 @@ bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
 
 	poison_slab_object(cache, object, init, still_accessible);
 
+	if (!still_accessible) {
+		__kcsan_check_access(object, cache->object_size,
+				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
+	}
+
 	/*
 	 * If the object is put into quarantine, do not let slab put the object
 	 * onto the freelist for now. The object's metadata is kept until the
diff --git a/mm/slub.c b/mm/slub.c
index 31e11ef256f9..144399aebdc6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2311,8 +2311,13 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(x, s->object_size);
 
-	/* Use KCSAN to help debug racy use-after-free. */
-	if (!still_accessible)
+	/*
+	 * Use KCSAN to help debug racy use-after-free.
+	 * If KASAN is also enabled, this is instead done from KASAN when the
+	 * object has already been marked as free, so that KCSAN's race-window
+	 * widening can trigger a KASAN splat.
+	 */
+	if (!IS_ENABLED(CONFIG_KASAN) && !still_accessible)
 		__kcsan_check_access(x, s->object_size,
 				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
 

-- 
2.50.1.565.gc32cd1483b-goog


