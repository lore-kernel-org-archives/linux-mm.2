Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 768D8CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3F88E0054; Mon, 10 Nov 2025 11:38:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E868E0003; Mon, 10 Nov 2025 11:38:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1848E0054; Mon, 10 Nov 2025 11:38:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCEF28E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:38:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A438A12C2C1
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:45 +0000 (UTC)
X-FDA: 84095256210.30.B134F44
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id CAA73A000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b6nkkA86;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3UfdW5vQJBbw1wKbWsFdhhHcBKlPZrTKHywEKgKhNPc=;
	b=rYU3XgbcFsef42+/Fr/uDzLIf9+Z38IVan1aUC2jC9skbITI5yixXorJ9SaytFFeajkfOr
	2q+tjJAeUTGMdj/uHGFQ6JbCT/d5xuE3PVK7rfl+8Lbh590WIbyUiCLyMSINHPGyW/5DMS
	NjCWRbs5l3jWGdwfFa85GGbDwao0cB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792723; a=rsa-sha256;
	cv=none;
	b=tknZTn9qquBh5nej33YX1X/dfHiLt7m69jLhk8MT6NtGxniUdRTms/pdYXA3tyLvmlMQ1E
	ucf5rCE9EGF2m++WBHdT9+AsqvqYN6Fbx7OiSwVjUVbR194K/OLk8jkkxGL2XfmkQGr7it
	2DI/X31r8BsL1rR2/ElZDi9vN1ICc1I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b6nkkA86;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-343806688c5so1521452a91.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792723; x=1763397523; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3UfdW5vQJBbw1wKbWsFdhhHcBKlPZrTKHywEKgKhNPc=;
        b=b6nkkA86u9snDS5/yPVPJo15x8qtbZ7kdzwVzY+kV2KcxDVd+GEAFEPbXSAVChmmND
         Vo5wdrLw2CdlpYO+A5p2N4a7IWsxrxDPyveCPcnHnhUWkxzCx7sWkt5TTBHEQEU8N+PE
         92M0veCxOEugwxXjJxKADpAIHPXWSOMpngCb4lZU2yyjGI/0qJX9slAeQgHRSniOKi7z
         jmGmkQYD60F23Op6J68gfa5jaSnV2wync/YmUZXI80SXTNlE1YCE0qNoYTPCNrPs5Dup
         9KQqLDfGoc6KprLwFKY3k0XYTxqIjip6WTjzbVBNw3NkphwVbbwH8pMkdqIQxMvFJwkl
         G8Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792723; x=1763397523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3UfdW5vQJBbw1wKbWsFdhhHcBKlPZrTKHywEKgKhNPc=;
        b=B3xQFYi0NgmPtBQbl5CNRRK5Zf2hoNmPThVu4nr2lkPUWsBpksgnGciwjwETxsIYkA
         nLkUb+wAj2ZUrFLKGar43OuQ/VcfEQIki1FV7NHw8GVwqYTwbtmq+IxiChlN3Zxs8tLe
         Oa6osE1RqyHIInBw7GtasAyrboiYCKoJulZW7may3yT+ikPK0J+g2K+duzQyIwk9YJH1
         hqwSEN8I7z2nGev4Irz2FZJXliT+yIqotAz93fit1sGLis2hJyrpAKwAYFaIhgsGPDDA
         01O95oVq40tkoyscqV+p26tdYhdwG3cm3Qo4BUG+h1ihzqTVytlzlDvLPYd8Qran4c3X
         ItdA==
X-Forwarded-Encrypted: i=1; AJvYcCXfj6V+Cwl8IJ58iHQg1KBk46ot8R47VWP5Sl8F4u9XertLOe5bk0fyZQoUiKHyjM+xVJhyxPX4rg==@kvack.org
X-Gm-Message-State: AOJu0YwuOc+OqTZiyfXnshsV53H+gNI5e4sgRMkRp+sVDVdszDi03SGE
	cc8yqDNzhl77NdcTaCSffw9SuPQWQN9xdV7z5RqMm9+2XZsMOwzLCd3c
X-Gm-Gg: ASbGncu4rv3W69Xcr3uTkoDsSepBxwKVSAtrgMayR0vmZgtdyoDgGCHpPxz1rzHS4r7
	e+6KEW0/bMqUu1J49PUORNuwQhGcVrx6+HHQutNeBrJn5kC/ZRRxlY8gkHX0ZQN6Uv+4wEwIbdr
	KLThRyuklnoBIWYNM/WTywlqb9R4j9iNqpaF9BrCi2dXWuy7/kvN/a6+syhhHX2c+mPAwYMJ6lj
	u62+p+W7MIrTC5K8ALQEDhi8hnXF0CG2Wc9kysaXIi2kpj4XoYOc5YKJtouIX6yXoXuDJz0frhx
	EYK5KWmNXgV1Xw/ym28TktFagdbDRtgx6In1BqVG+LMp003rmnD9gY6ryxSTXik8OJGdFXqesLZ
	vhSOtXgq0dF0f1u/9NMLCK1jhKcj8Pe85MKt0GPa6lfsMggQV7TXVsMrSkH7XA9Afs3omBQXfs9
	SML+A26JoPZo3ypJvwHF+q0w==
X-Google-Smtp-Source: AGHT+IFEhL+ivOL3mJYmk2GKHVq/7v95YCugColCvVCwbEtQDJoAIyDrMPXTzpn3mUDrpnLozW3jrA==
X-Received: by 2002:a17:90b:42:b0:340:7b2e:64cc with SMTP id 98e67ed59e1d1-3436cb91daamr9486479a91.15.1762792722638;
        Mon, 10 Nov 2025 08:38:42 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0c963613esm12684061b3a.1.2025.11.10.08.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:38:42 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	David Kaplan <david.kaplan@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	kasan-dev@googlegroups.com,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Liang Kan" <kan.liang@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Naveen N Rao <naveen@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Rong Xu <xur@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	workflows@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v8 27/27] MAINTAINERS: add entry for KStackWatch
Date: Tue, 11 Nov 2025 00:36:22 +0800
Message-ID: <20251110163634.3686676-28-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CAA73A000D
X-Stat-Signature: o4fekd3w6udg8j4u4pzjwska5js1bozo
X-Rspam-User: 
X-HE-Tag: 1762792723-436598
X-HE-Meta: U2FsdGVkX1+yRoQSoE6qbF7WQfbdSPIy6nungRkq56Z7zQSr001BudDPg4bdqiA0Q5/Fac6hAdSpV0YCvKVlJgBLor6SeLJnuhqBMLkgsrwfepCRhd1MiPkRTgVckctkzQEyuN+6lCbVLxqS8H0XnWiGqVLhjDmkt0O5itzQ3NoIdRvR2hZoJY+tPkK6ZmHkdHuECnVUAddQyf+AAU40Tnanb60mnSHJyQMo1rnN14TyS4kvy7nO6b4+jOnaMTFFxDDFOYjK4yuG6y0XwOyGecr1uB3pyMkWis1b/Z59I77g172Th7iLuilvmGy6CorgbIBF42Azn4m9qKkqs4CLZowbXGbbwJv98c6qMIMS31zuuMoQJfyA2Ko25VU4aD6TuCoIdG0RWj0ZCDbSEgVewCA9XcZdkMp8PZ9c++3R7J9eBN6YWLenl6Yl8fspfupczf4FV9K9YidiCT0AzYu9jcs3OG87YKCNC/euHwCNbs0L+/VZBm1N4xfX17Ma/SSH0P11W7sKXOaa8saHOiqgTjeddGHtfyAxlQNlhqhKj4+RulijoyntJnLC1nfKNpCG2oFOXm5xEn4AvGKxogn7Q0/SV3Ce8HJcmWWCOL1GRLEKdE0NRpi0RtuJMKU3HU/figLAIvOfw7atf6J9Grc1cslN1+qjuXJMmk1W8xb82H931XjZrvqgKp7AaY8M9PfFr6daWwrC8FGq+adsAB5iYKqoTg7QA5mtblgm17+mWIy8w4pI95C9V4MEi5nGjx9XbNyxGgvAbSxIRfZ2uy8zov7NcZp6QVGHuHgJc4EQ7lAzOYLrQl3Nr90KFzPjJa1/aOl8x6IlHFOWt1NDq0m1YAJeJKhyKJ3Rn7F3r0uxvjJA7RKIjkeVvY5gdve6Hn2rjCxHzxA1/LUWWvRp238aAd1FFla0SGCzqSgH1XxHrtoYNBquRYJ30BX2yojNgcVX0AjP6KQK3qJI6+5lZLL
 +OCeM4kY
 1j3tDXE4Q+0jjWHzgSB/4jCIwMy5AWBx0WLlawBPBi8u6jBEkh0jIHGrn3cbuBfZwd2dN8jOlxvfiVoq9CnMrpONyaly1P26/kzqVfEi5RI5FTNDqJG8KcqauRbjcuRDI+/TS4zi/6AONmJIX8+kWCvpwt4FCwMAGn4r3v6tjlTxsU1DKWuxAuOvximhSUs/gtQQ5vop/YsCQAX6Y+x8kFN1P1KR0cZC7+f4XntuULPp0o5BA9YPR92Dfcw1xFjkvnSqiYUzfg9928AXh97vapbUCsVTab9Thw0Tbn8Ndzy8QtrfAqo6WYzm26H7mB4rDYDJKTRNXVlhFzw76lnuLdfbPqPNnujKftdRcllbMJ4ZHJHibydBwGmHzHo6Bl5msELbw9uLjHCWLOlY9YGLHV0iKmTvUZUuwHCRq+gomy9/Ky1JYoA8hp2r5pmke13kni5mpOor2dT6LHogJXU1Rr+Idvngtm8nCXOlwZgXUyfsj/PjD868Fm0NXYCRzhQrtHFZ//D2ZUw2tAvki+wdFzbef1Jwqhnj5IUKfl8qzUARheMCAjSJc/woTcO4I9cDOq0YWkErtRLMsBr8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a maintainer entry for Kernel Stack Watch.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ddecf1ef3bed..9757775de515 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13615,6 +13615,15 @@ F:	Documentation/filesystems/smb/ksmbd.rst
 F:	fs/smb/common/
 F:	fs/smb/server/
 
+KERNEL STACK WATCH
+M:	Jinchao Wang <wangjinchao600@gmail.com>
+S:	Maintained
+F:	Documentation/dev-tools/kstackwatch.rst
+F:	include/linux/kstackwatch.h
+F:	include/linux/kstackwatch_types.h
+F:	mm/kstackwatch/
+F:	tools/kstackwatch/
+
 KERNEL UNIT TESTING FRAMEWORK (KUnit)
 M:	Brendan Higgins <brendan.higgins@linux.dev>
 M:	David Gow <davidgow@google.com>
-- 
2.43.0


