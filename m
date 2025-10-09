Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC147CCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 379B08E008E; Thu,  9 Oct 2025 06:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32AA28E0002; Thu,  9 Oct 2025 06:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2618E008E; Thu,  9 Oct 2025 06:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 085D88E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:58:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB9005B430
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:42 +0000 (UTC)
X-FDA: 83978277684.06.15D2EB2
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id E664F40004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N65v3Zjx;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ApAR8xSadwKhwismNq+uPz91ksCPHZtzxjh6qDdbHI=;
	b=ZhZ3u9vaHq0WtX9mgD5Etzcqa3bLNZkqYTqD9oQ11NsBa4xZ2qK2XKZm+XSEoKedFEUtrE
	5tPob3XvtjLrfS0wtmrqh9Lb4OaC8/s64MfJodDTzSmj/qwp5EuwpvZqG7z/FoM9FJBoFI
	8MHIl26u3Sx5215rFX68fMId+LIkfNQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N65v3Zjx;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007521; a=rsa-sha256;
	cv=none;
	b=TZkGUvM5DGsYUF9LpU2FFxM9dvdZqFignztVJ92RS0QKvGz3l0KVWPHg0Tcu8jZTt7lLOB
	AMgvq45Sstl2Dr8c6TvURdUpDn2HT66h/V3etgBUsMLfhjajqaNqUlt5jagDZakY3MpAV+
	Ve7N8gX7RnlvUBmLGcuj1HTYMC2P+jQ=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-794f11334adso721939b3a.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007520; x=1760612320; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ApAR8xSadwKhwismNq+uPz91ksCPHZtzxjh6qDdbHI=;
        b=N65v3Zjxoa1xuZapcf1se4LYNDOzdxVsKDXmJ36CaUCBQLmBMjaHVSa/WRLlSp6kyt
         s/Qc167r0gX8EwYsGs42R3VLMRmqZoc3UBKXGpHf82/hzjNqj8W4XlTAtkpLzcgAlBZQ
         DQLxVYedyA5sgv0QqGmyINb2V4W83oeN7O3hxGCgVDWFdzOPeaxAL7vphelwrdyi0Crj
         xgC4hCEom0l8A58WxOKyoTXBDAqiwSXLJ22mIWDe4Oud9WsQsTIB3H5UiDpBedEIQvfY
         9PvOrNbH6e/WHbXoY93i88fo3awQtUw/vUjZVnt8+RHyI9eOQYLwBBv2+Ih6g0yl8nUL
         rqpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007520; x=1760612320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ApAR8xSadwKhwismNq+uPz91ksCPHZtzxjh6qDdbHI=;
        b=U6W/L+FtxhWUgGpsxfYtcevBxtql5BkY42alZmnfFn6C/yTJJqKvCHizE4sMRpkr9f
         P0Bur0e4BZG8AUz3XK3KwxnDl5YS1YHtZRY3+F6X5hgpKdxq0hxDrY0+t1LXQImu9SPH
         RcG9ivFLilLRlVvVBykli0Sxj0DwqOxIJQYvENIvGAEvdVTYT2HJiLK2lNTVx4/8+gRz
         a8yRWopUyQnWbl1/74hJkQX8wxrKraXYeQzh2l/gyPpzOOdwodTgIKucTyIAKDyTFbkh
         poXw0a60S13T5N6Lz55BiTNtcxu5Nj59oA4vNW+Rznz4f28SYMNd1HCzW2SO2OU+zXao
         9ndw==
X-Forwarded-Encrypted: i=1; AJvYcCXKJAi1Ljx8jhV9gnGfNdJ9qbEO5ZB6jv5YPq0f/3+x0YsDED2RjZZJTyNTu+NYt7ktHG9QFf8ovg==@kvack.org
X-Gm-Message-State: AOJu0Yz2SranMdHCTHMMAiZHmNMeDi/qk2NJLULRGa1cDDXlH9G6Gkd7
	yhC9fGizbJlO1Yx5x8Tq9xxLqmEUPcpJPNjA8iTXXG45RlsjbscqaOgV
X-Gm-Gg: ASbGncs/ICfbH31I/8lwDqIua5gquVGzfJQFxhOd9qqXTa12TwXX4OQEhrms/GcwGT0
	XpOGzzeCaGi4AToyTyR1R4dqcfNOlgcHruDE51UP/ThMo1iQctPUG2i8Yq5iYeoGM1JuFutTCrY
	wKsvrHqeGiz0RqJ10CKsnFG3nmJi7OA/SYWu9BKaxxVfKF6DS44OYiQ/1wKrp9f+JezPOQ9NH/u
	W7XoG4KRzThIviCLKmkyzOgRa0matyBLoIcxZhv4gYArSFm8shXfZyjfsJpECDPcWcxE6V2D7W0
	IjaRj21HqIBONnp5VZCSJOqGJE6apAy8rcxFYJ5vNWhtwOrOZvnrx2ZnOvC6YqP5IMZ6v/PXaMU
	+1bpq0jHoDQ+N8YXl2ymlPr+2LUYxf7WzlXbFx03jURXEaLJ9HeiBOyq5sDDS9YnDyicWs2E=
X-Google-Smtp-Source: AGHT+IFNGlIpEHO7TMNSv14SEeeL37qmV4fa31y9HfqA5Z8RmIIJBkgU1nSNu4enoYA+m8tb63ySAw==
X-Received: by 2002:a05:6a21:6d99:b0:262:1ae0:1994 with SMTP id adf61e73a8af0-32da845e6c6mr9710336637.42.1760007519707;
        Thu, 09 Oct 2025 03:58:39 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6099d4d324sm21591393a12.27.2025.10.09.03.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:58:39 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Rong Xu <xur@google.com>,
	Naveen N Rao <naveen@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Nam Cao <namcao@linutronix.de>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v7 23/23] MAINTAINERS: add entry for KStackWatch
Date: Thu,  9 Oct 2025 18:55:59 +0800
Message-ID: <20251009105650.168917-24-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3q7ekpmckpq6r6yhrq7xd3uoh4gw9r9z
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E664F40004
X-HE-Tag: 1760007520-585405
X-HE-Meta: U2FsdGVkX19+UVua7wH2eBtrCseJq4ajrxGNXiKih7bkke/iWz4vzjxyZcfZwLT9AqmCzkoND86K2lQv0rCgokzqFAWudqg4Koae2EF3uUEj1ffXqCN17ugxMGg9ApAJP/sIu2tPxet5SxvxHr/0sdZ/N06hbNGaa9KvVtojrT3ufDq7tnHqS2nYn4KbKKKxHnVcyL4n8hJZB9DX7Nu57YidiGyF1gzrNsSopO0XOeYGqf20Kj8OmerklbAusZmDMl5e/QiUmSYWHZ8lY/UK+9gu7e9QY5PG1tc1kqrcMOI7Y9ooz6Zyd3mEPF5ndohF/XWMdKninRI1T6GAMrmhuDbfwKqOrAohDca3PrGdooZzzMXn1fmzhWQvXtKPheSp+IGXOBO+KGNAX3IdhDPVoJ3jjebQAE0MbLjHSLb8IpVMj3jJ++UG2pPjaZadRtHACGH0paVbMsGrsz3HkQOXwcxZ471bXagHSNoXAo2BvxxhddeLb296DLosoGWfNB7dl8odJ5G0jhN+6BJapf6wuuGScPDMDZxLXY0KVWA221mEKCFNhiWDvI09F6EbhIeOqQovIAweNnfM9YI61tdpWMib8uncHV9bUc6AcwmDSAaJjDmPpoIiu9lMOT11GGlI261OhhXimCrvH98sVvw5u94Y9AwwFeUBqT31GjqpV6NwFFF7P3a5+DgkaCCxjfpaBSbuocLT6+g+Q2RBOwFe6wvlizF+qZN6miNeqH4zPmGdvzCoCMFHcaQi8vsNQr3h4V28X1XE0ZHB/j1rRlpOokFdmq43+wRwcCiaqzZV48me1Chq8EpenqvlOB9CaBXjCkSLnhqiep+usQckOX3PbGeBCif8rhdDVzVZlx5keaaK8LhSZG3eSVPt119tU1vp1lHm5dr0+hy96o0CxP4LME/Jgf5bV7g01B1vLai5/HtMkW1Eif1QEeSVzNZkfekbVhtCK4wtCIc1ftEwNpQ
 FUoV/k31
 VuEpLjq+xfK9KwtjRc/FsqI8vepdn+4dpn9A0JRhGi7b6LfHsULgENQyQGqd0CBo4rICl66ozMKMl7I6ZqPiqUqC5AZMifN5uPu8FkQkodSViQPM5q8/i6RuDgoojajr+Ujsv0x8MiM/EUd2ZUtSN9gAn+xAjJbnubAynJuecjToYEPzZtcgZwbaQJbbCoPzBf/nI+Hh7SS7kX4XNe6JieS7lTkT3tIn7V5SJ0bp31V8HS2c/dePTLy5hG3belVb1R+JnU3ZgtqHuaWO+yTInjDY9Swbm4kKelPuWhWPIsBDAyJQLos5sS4xrx0mYaHr4p9FOHmtOITq7XJS2GvyZm/7QDPImpTTm1Br6ECdm+8EtItZea1eh47bnlTLLHhipa6cWUuCeKcBl4izVpQGpSQ4VHLpslSKtFdRVOYHO7AdiQDOdLCu92pkihIq6iy6/KC7fKRpamAfnjX9khPoR6hSZR1BpFPkBiL9+rHRrvT/xh8Sm9c0IN29wN290xFOu5nbgHkBg7CtfmfiGYAou3u9NELZNqtVyU/kWUCv7FkvMfenyv59U1grT5pCwbkBuIy5JV3T1+y7BMC8=
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
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a27901781c2..d5e3b984e709 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13596,6 +13596,14 @@ F:	Documentation/filesystems/smb/ksmbd.rst
 F:	fs/smb/common/
 F:	fs/smb/server/
 
+KERNEL STACK WATCH
+M:	Jinchao Wang <wangjinchao600@gmail.com>
+S:	Maintained
+F:	Documentation/dev-tools/kstackwatch.rst
+F:	include/linux/kstackwatch_types.h
+F:	mm/kstackwatch/
+F:	tools/kstackwatch/
+
 KERNEL UNIT TESTING FRAMEWORK (KUnit)
 M:	Brendan Higgins <brendan.higgins@linux.dev>
 M:	David Gow <davidgow@google.com>
-- 
2.43.0


