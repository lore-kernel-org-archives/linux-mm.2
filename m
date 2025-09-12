Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0401BCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0046B00AF; Fri, 12 Sep 2025 06:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56EDE6B00B0; Fri, 12 Sep 2025 06:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438146B00B1; Fri, 12 Sep 2025 06:13:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FD636B00AF
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:13:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8A1D13BB25
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:47 +0000 (UTC)
X-FDA: 83880186894.08.23D38D0
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 128701C000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="E/GtuW92";
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757672025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I55bZq7ZFzzpD1DxoyTRdsSYeFKQhRWPVd7TpHbtt7w=;
	b=dS0RNlVZuJPRydLSnzvvn41pE1bkrSBodV9OXUjomzzGjLcAeLm3/+iFAI8Pq7xEchs5QB
	OsbfcV5W/z9aoJbi3tJlX2y3re7pvco2/+eA4jUiALJgeQxvBxWfCFU/GtfYiaJeclp5OZ
	7QWuSeeW5hNZlcBuU9OFO3OuKXeb8eY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="E/GtuW92";
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757672025; a=rsa-sha256;
	cv=none;
	b=UesOpy5YilnoMAiMp/n6ym/xrElEBIgBAIF/J3XMNqp/tKFILQKzKjfi9jeQxSfAbJvxF2
	F4LLQw9Mx+zfXNpcbs31m0UFWE+twSww9ryC1+ZQ0e595J4GUnSlMLkqKLPuwc26e7N6b5
	Ss8XHwqpqoKNeS7gfnWhMsBvsAN67ug=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-77251d7cca6so1708200b3a.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757672024; x=1758276824; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I55bZq7ZFzzpD1DxoyTRdsSYeFKQhRWPVd7TpHbtt7w=;
        b=E/GtuW92DXrmFi6OVJK6l4Z05fYLAhU3ZuQk542hAxLjdNwyAOhfxoZl0nVTpFvcwl
         fRmYRGP+qgryZ8QXPvbqAACFwmichTSeT85ECn3FSiD8v6vZzqpsqsrn2ExrXy+0RHys
         bJBnbeyY2YOv7x15r9o6Wj/RWOCESN1I5RXTqpDE0jHk06/faRjk6LGIKfjxaVYWvHQ0
         iWewiirzOoHA8Keu0BfEfWTuUx3UYLDmd/e+80K5ZtIgUnWywVLmHAinFaX8PqChE8eG
         YocDA/m39w2eKWe8nwZnP/FoJxWLwq95MySdMbTUSaNTb1+tpkN6WaclSCzKU2CoW4i0
         JvMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757672024; x=1758276824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I55bZq7ZFzzpD1DxoyTRdsSYeFKQhRWPVd7TpHbtt7w=;
        b=il0xWyUnBvv9YpvkK/PEMmaqnugEoyq+UqDLeMUjB7/6DTkQazYvI1AptBzngRHgt3
         rV7cbcZvtE10JNR4PXT5qqzhbar7qJVPITCK09k5/F6/WUs89x/YVNOdsUFf/m1+McTM
         AcOrseD1VwidBj8lCa3k6KMPoEPsetpx6I0AclTleXGC5OEYba1coisXoz2Dl0G7pzlN
         F5fR5ebhEA6mkJwcR4seYv36mkKD9pqXdhsj5Pwwa32LEQEn46G3Ic4D8ULNQ2YTq3es
         yErvfEtA1/0fWPMn4nSk4DgeVUvTdEx/LswuGLIfGixPIVZr598pHZYaiiFjqdohKX4r
         nyyA==
X-Forwarded-Encrypted: i=1; AJvYcCWtW0DT/QHK+7h5aZcCU/zPlehQrK1btdON0Iu7I/4edWk0DDpRy2TXDd/SEUeCA7UC0kHM7/Kdqw==@kvack.org
X-Gm-Message-State: AOJu0YxBIYJRSDwxFxBLJP1JdROzS3vO8rFSscKrSFlUH2d3rHLQz5xV
	CYlAwUTZu3d9N6NLVHUnFkEFQjxCfPmLr27xSpMktHHl5xk/XVkgc9UQ
X-Gm-Gg: ASbGnctovMJ3nzHlsRrmT+TdjXsgeM75VY2V5OshoTGpQulLU2HOfdejxuF17gCWqCQ
	fqWuwCjkOhvtEsZDf4jo199VugG8mPZZTyX8lsVWeHc/cfGO5MWLalbgs7dDfNr58EHHRA0TeSf
	c4eVsKQg02hB4ohUBt1xQwJUvAGxF6p7yhQptTAJYB1Et5prAFhxNuql49Y+C+qlNoUBP/zLL3I
	SjIGTKF5M9w7fqp79p2gnRShEMfbUUsuKRWKaQlJ3b2QV5OS3kzodeUG3Qvk5VjDbNaV02zlpV/
	tWhsjveLDIhlYT3FlRTVlzqFM6zC6I34+dmPkylGnaEm4YoB0RUCw2RwoieeSJoBRaw3GVY+YJe
	FAZTUWohIVvtdBI/HYlicGUFXcMGIYAkC5j8yZ4/wS5Tcaw==
X-Google-Smtp-Source: AGHT+IEmU8/7QYE28ulPnmQWl8v4TOjFN/LND+vjp/ORoshKulgXE7ro2NJTOczUKB1xsXbgHPgJeg==
X-Received: by 2002:a05:6a20:734d:b0:24f:53e8:cca2 with SMTP id adf61e73a8af0-2602cf104d0mr2912224637.60.1757672023846;
        Fri, 12 Sep 2025 03:13:43 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a3aa0f8asm4307035a12.48.2025.09.12.03.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:13:43 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
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
Subject: [PATCH v4 21/21] MAINTAINERS: add entry for KStackWatch
Date: Fri, 12 Sep 2025 18:11:31 +0800
Message-ID: <20250912101145.465708-22-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 128701C000A
X-Stat-Signature: i9cjsiu8y6idfa8kg9cs8syu6nz9hcq1
X-HE-Tag: 1757672024-398472
X-HE-Meta: U2FsdGVkX1/jbQ6Gy/Ztzfi1EM843NR6RlO8ZLWVqujC2BJCwZJiy7Y5w0VLefWZi1csZOTXdGldGXkCO/QgeoPuF8h/aRRjQAz0/m3HmxNbc6BvD4LftwaWeOzdb81mEBvAhxjiF+RvhEFgmiqFq7olAkq1gd96gnI6rJMCAV0HpU/drHnrxazGf+kQ0b8l0lhFrt3ZrqeX1gjXerHkaj/34bRTzlS8ZJLJWGOHuhHeeunjk8JLOcE2SeC62YTKBHkgJJ3rAn07cLU+H0YZLZNM2jhg2GxQGSfqwJpwPNOXac7VaqhVexoq1ZhIf9cRug5vW33WX2B4M+boTDg/KHnl4h63Gt2Myt/TCuETtXn0/9da+UFWRHRCFzM57ORQymCtJyhHvfY7tY24nkMlCdtcujzYVWkiETP7LPWWqX/BVPDV4HwjBy6aJDkMoEMLz2OafMqsR1Clkti2Livhd//lpnPZbgIwl8Pzg/hHeP6ypGO2GYCKfIZv1VygkIupK5UDQywghA5G25pN575WCh7hst/KfC5Oev6aP9uWDJJgQpCbjsRmMgMaja3Ndj9VXcOq238s1T8PzGG01sDXPkhEPXi5FKJ2mXjZYfB/b+cFREIZHmb/nlNYUWlsyzlkI80TILIluSH3EmEbSMHQFYX35QohlKpfX1jgqNrjbmsYBUYN1SoKxUnPIYddvL1bYFjglbsezBkqqMQqpfr0z3FGzJv+UTem0UrlVdLH5kDj2OX2QFxsfZyOU/gw3VfY1VbI5qIoixUs8D60vZ1ko/A6RLhs40wagIiIsBEX5GamN5YO3xNrQT16AZe/XNe+s0jV6k+7t5lDBZdUx/k0DsI+ONHjmmuGzw1ElJRvz4ybxHJ/PXbeEoFXoxzY69uOC4H4EaaG27HdPvhsmEqVptPPayPERxZiJtERvF4O++UpeBxopZByMedJi+VmXOE2xliNCE0J6cIEx86zm23
 KWolJMzX
 myoDz4zs4NYZOuw0jLl+tHqd2hqXd3kpBCi5AecDoAZY/G0nKN2PGEaK6E0nikXGCSUeS/xghbZNCTm6UGjxjfJb8JwTMK4H0OMYeUblLf3LBjo/DGLR67hM1DU9dw3+ERD9HtNoEr04W0RkhKTMve4H4QIe6Jgkt1zJN81Jhzr8smpwE+UzcCH/FtVSP5v5MrpH5Al/EUovwiHY+gWo/u/nFyKtTgIcA8udbhqvLubm0s4PntF1ibMawonOsQ2Tkg0Eour1pRGJZX3iSjgTEvoUH/QpqVSVOOQC8ORLGonkuxntZKb+z8lI3GXyNg/jWdKzLM/OJtCJc4Xudo+D35cz1zk9Q+/WfyuOP47A0SUTk5AzXHB31AQpJTbP5CZkrjtBroFGt6v2NSrqlco3Cor4gLxXJ6XkQUDZHENxzT/K+vF7XrfvsZTXkwR8oTVrylVn2mY+c5FJk0nVg5zjHgmBkQ+XVlLTpYbbq2ykCzsL1vhZIuq5+k0F2T/FwaqI2THVDv1pW+WYpSICs6+KKvi5U+XrGmRLrBWZfQUbURn3MAID29gMAj87QZo2hafhRUZCnDWsEoeL9KRSlB+YrhMLJbvabVLhgEhTw
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
index cd7ff55b5d32..1baa989abf2d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13355,6 +13355,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git
 F:	Documentation/dev-tools/kselftest*
 F:	tools/testing/selftests/
 
+KERNEL STACK WATCH
+M:	Jinchao Wang <wangjinchao600@gmail.com>
+S:	Maintained
+F:	Documentation/dev-tools/kstackwatch.rst
+F:	include/linux/kstackwatch_types.h
+F:	mm/kstackwatch/
+F:	tools/kstackwatch/
+
 KERNEL SMB3 SERVER (KSMBD)
 M:	Namjae Jeon <linkinjeon@kernel.org>
 M:	Namjae Jeon <linkinjeon@samba.org>
-- 
2.43.0


