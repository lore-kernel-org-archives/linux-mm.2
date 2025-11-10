Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD1A6CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7774A8E004D; Mon, 10 Nov 2025 11:38:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E8A8E0003; Mon, 10 Nov 2025 11:38:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6169C8E004D; Mon, 10 Nov 2025 11:38:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 432F18E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:38:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BE6C1601D3
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:14 +0000 (UTC)
X-FDA: 84095254908.14.C105846
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2F1FD140012
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YRXFvBLJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjEoXPNXhfVJUSFrtIZUZPOp73U+hEWiDpkQ2qC/SvQ=;
	b=m3zFOSW5zwGsOr5uoo9Uu0GyqHsYQ2wojO0wgr8ajgAaQQa9XxKcua3fZSsQlNi7NARED5
	VsWHEDBxgOBhlEEgRZxNKsT4OSS+ip006Lowmc5+dcuoXkl7fLOgHsM2cYsUbThMdikCPR
	cpG453qa+u322HwK35A9EEFHnRV8wwI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792692; a=rsa-sha256;
	cv=none;
	b=ba1aV+i2T/prgwL0Fn30vhhioVVqqsydssdBIL1FDS2lVx1mbxncmcO1zbiMLfWb6C50wF
	kOgURzLerQzxV5nwLy4Bl1JEbs1VJvZEqfUHyryJ5iofJgDfc9cg0+aoinKqwM71/4+BPr
	0dchL96lRPNlvZDk6kGl5J3l/DFekew=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YRXFvBLJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2955623e6faso27683275ad.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792691; x=1763397491; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tjEoXPNXhfVJUSFrtIZUZPOp73U+hEWiDpkQ2qC/SvQ=;
        b=YRXFvBLJjwaDy4BO2C89scHAoyrebtqMugIMWgraBtSZ+wprTvBirrEDW3mytPqMku
         UjOCXc3mFTfEpaS00NwcViWjmrgegmXX98KDh6TL4NFQBqxXx6P6QmVVnzPkxvWB1hFJ
         wQgCPagtrJXrumL7+ZR2UEdYOCS9qOoAvKnj2PBuY7virSOBlIBI4tYnEc3Gi96yUAc6
         gK4agU8ni3wOzcIY0pMsFdcXn98WvnWFz8AGGCWpwDKSIX6mPvzdwr2oFSJZGB8iLIf+
         nLvfPtwXP816CNwautnvscagOYS3HK7lIuIqwf9xrBMSVfKWPFyGf0uMOed9SCLkVHkQ
         P+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792691; x=1763397491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tjEoXPNXhfVJUSFrtIZUZPOp73U+hEWiDpkQ2qC/SvQ=;
        b=Hv/yxSXkSI48Z3yFkPRaSOqwu+q8xVgBTIOL3BlryDW4vqzWirp2TZVmuswPJN/D/u
         VVxvREDrohV1nanF/5jm3WmC9eznxD9OHxH9Kvxq3Y1RRehZuGO1wQCNQg5wOL/Wr32/
         U56m5e4roOx1Utzu4/H7xilm7OamrlaA0OA2OGgECi5K/SSBKBWoqhNeGiK24yeUgHqP
         Tl/76D82HDPKRsQbHmkDworC4T8jT4FSz3IuM0QG3Ozuax6AQoToIXOBAjXoPGEjOM/8
         2FGIv0iEkVNGLJCmlwYCnkgu0FF3jtxenpXkCRWNEdbrpcPVkpmQPSiB0oPVlbXgch7U
         MBew==
X-Forwarded-Encrypted: i=1; AJvYcCWuJH39jKmQyURDK8PDcWYk1wtMisGZWG2d7x9j+8TMw2eQ37YQFsCLagBbn2qK1douaGxPpRK4tA==@kvack.org
X-Gm-Message-State: AOJu0Yw9Jf7o4dApl2ZC4gaup4CijWYWqRAaEBlYovlJWkieEqIqdZBJ
	XmDUpLMshCfpABBzyH6O391lNeI0DJPRy2pEcIcHaPjkv2aTbZPjtBb4
X-Gm-Gg: ASbGncsCBCvbdKLSEMhVY9VhLX3qH1G7JrjBQ0frV0YGhYa4QE2itYSW0Z38fkpTSUH
	oBPwxI1bTxgHF+1j0Bj3tNYhvEW2RN5+vwONV9zcPZM//H5eSmmlGyQMNH+JcWtUUA8LW8b0G/j
	veg1gRblNKsbYd7S0hGB1cyXMW+djb8U2FLDCaFroykln55ecvhLelf66bU+nzdHmEAEj2Sgg6p
	MQzySCeJe6w5vcIJes8F8PT6e/SbAjbYTO57f6pPpVvAzdkb8VFJwr6EgKg45l0hrg+m+CqumPQ
	5iTEx1zA/mLJSY2onuWYMIYa4jsC5wt9BN6XzRs+cvoR4O7L4aGlfvsTSGeE/wyczSlqjkr1Ofs
	x60rYJdglEzVIQV9AvBzAMC1e2FutIKfo18viOnWm8SDvv+nMtPVyOKg5GybQ3EsjAP1uf3lGzj
	adsCwUNcyaRCA=
X-Google-Smtp-Source: AGHT+IGgGEjFRVaat56XCDxopiL8+SM4HXr1TFRgWsca/knmSVG340IyJkWxuGKU2hwaDE2EKORtXQ==
X-Received: by 2002:a17:903:244a:b0:25c:8745:4a58 with SMTP id d9443c01a7336-297e53f933cmr112300665ad.3.1762792690825;
        Mon, 10 Nov 2025 08:38:10 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341d0aee149sm8572006a91.1.2025.11.10.08.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:38:10 -0800 (PST)
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
Subject: [PATCH v8 20/27] mm/ksw: add self-debug helpers
Date: Tue, 11 Nov 2025 00:36:15 +0800
Message-ID: <20251110163634.3686676-21-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 34tgioah657fwpexxjotobt3qt8g4x8b
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F1FD140012
X-Rspamd-Server: rspam10
X-HE-Tag: 1762792691-231253
X-HE-Meta: U2FsdGVkX1/Qn5RnsvNPLtODiHN9sZqpJ6X6sW0Fqpmj2HWGuGlcztjZOCL5OriaFpTefrMBnpAvR+JryBhs+ijGJBX7FC+ary3CNFrZ4Oz4MpNxbbN9aN8DZN0AnUrtHX6etJ6L4p+V+Jljv5ggtjJ1qr9/FKWfdq6BOGVhxHgSf+fxQazZ0zN+EkEST7yi9Yx3NM//B/+4YYjeeel87hUn/SGjts/0KvxBkw+AUIQGg9UTUc/VMPRvL+c2bf8+4Wrhka1+U5n8YrGeBgynNUTsX0pWFYl/DrkiCJHT/REXi08W/VuBy2x9loBY/uNaYsEPJ8qAc1219xXyrQvHxMoS8IAW2XxTxy+fCj4s8z8JbopXhLiEnLXNwPlkUNEDi08U7G/5XOPBtxMRwBH6YuPvXV/U2hDc87LwqEiz0YwsB4KeJ3FdeLLHoly5bsyyru4lZx5hbZWXJvYxkK0HkusyRuikSRHfX1zMLOoa9QVhTfnQW7z1ltcw8/Ay1Y1iz9Pa4OUwkUKypFrlIW4ckIS+obdg5jRKPnkuJs6X6xsS0PPY9BnF4C05j9Ek78wH01oi0EmtagxeZ7wKZdc4CmANzcJKJfCMQKCrq429giAHDwA6HW4uGDMXf91XUSurjgT+2ocbhu95MPG+YEtsbKeDLSsvHGRRUiuNfgrT+sB+uhwQt+hz9HiDGAKMPozJ2f3x2KHQGw4eT39nHaxzwEN3++pn/yrgpgbPOZHL+eMzq9jLJtdW3SR1TJ2yQn7iYZg50tXU0+hTsnUwk1IpAn6w/qglD+hBEujQT8Ai+axDO9vjNi/Og3d6nooVr8oXd0Z7mfA2xBSJnyaEPzPBf30ba3069g/faxDU1Cje1YnsRJyQlXvFvEyMND6n34fDhZhH18kzRoh5hrI4rfnKbssyGtjwaUup0bHwaaQ5VW2G2I9WSbQIJ5DSvKXVa5ZpTW2y/vn07IcFPmxlNwq
 LZNlvoEV
 o6ptQnMYhOkOotBcl+nwr3ZcjfKD+8tyO2jotytUu1SZVZ13Ox4GeOYzMI/bUtGhz7WfHw/tyiq0MeIH8AH1zTpYGn7xDWGvsOwPuq9g3AH08SIaW7lvPEQ1RWVi27yrhKe25ZqKNUWs7Pq2ocl9gmr8KF3oFovD1AFhTvKClDcjt9ZIFakCT06Hzkh9LgUxKTzoU0r1+IRrDw00No23sOMO/VTktgQNvnmn7QRBl4G3Sr8NgWjklWpkOI5UgGoxIAj/FY6hmfh95hRJPxeVejdmmxEMIOn0J1M+34ypql5ubDO0SgGURUcOjTVYyF01kSzow2QjmgOzA8bbVC06f+iUwsDqvSYJnuIJb5yjQtOOhUmjqPuLwTthAIoZSyGh2eFbzC18u54SNmAS6iTAPOahpateZS381tdJShtDvVrikEHepCnG3olsT9pdQcQjZn4i5N6hgvZFen2cnWnzcgJdDBQEeTjWGvq8QYlcDKWnD5q4P+x8oXtCrmNREDhamB2cLByW+rfK2r90I9GK/lUwCRqmz75fRWl/KM3/5dnMRopjFSDPHjtUTgLTtagmdVNx7+7W3/HXcB/e1RGPhXVtu6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide two debug helpers:

- ksw_watch_show(): print the current watch target address and length.
- ksw_watch_fire(): intentionally trigger the watchpoint immediately
  by writing to the watched address, useful for testing HWBP behavior.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 include/linux/kstackwatch.h |  2 ++
 mm/kstackwatch/watch.c      | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/kstackwatch.h b/include/linux/kstackwatch.h
index ce3882acc5dc..6daded932ba6 100644
--- a/include/linux/kstackwatch.h
+++ b/include/linux/kstackwatch.h
@@ -60,5 +60,7 @@ void ksw_watch_exit(void);
 int ksw_watch_get(struct ksw_watchpoint **out_wp);
 int ksw_watch_on(struct ksw_watchpoint *wp, ulong watch_addr, u16 watch_len);
 int ksw_watch_off(struct ksw_watchpoint *wp);
+void ksw_watch_show(void);
+void ksw_watch_fire(void);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index c2aa912bf4c4..a298c31848a2 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -273,3 +273,37 @@ void ksw_watch_exit(void)
 {
 	ksw_watch_free();
 }
+
+/* self debug function */
+void ksw_watch_show(void)
+{
+	struct ksw_watchpoint *wp = current->ksw_ctx.wp;
+
+	if (!wp) {
+		pr_info("nothing to show\n");
+		return;
+	}
+
+	pr_info("watch target bp_addr: 0x%llx len:%llu\n", wp->attr.bp_addr,
+		wp->attr.bp_len);
+}
+EXPORT_SYMBOL_GPL(ksw_watch_show);
+
+/* self debug function */
+void ksw_watch_fire(void)
+{
+	struct ksw_watchpoint *wp;
+	char *ptr;
+
+	wp = current->ksw_ctx.wp;
+
+	if (!wp) {
+		pr_info("nothing to fire\n");
+		return;
+	}
+
+	ptr = (char *)wp->attr.bp_addr;
+	pr_warn("watch triggered immediately\n");
+	*ptr = 0x42; // This should trigger immediately for any bp_len
+}
+EXPORT_SYMBOL_GPL(ksw_watch_fire);
-- 
2.43.0


