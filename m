Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEBABCA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08DAE8E0014; Thu, 28 Aug 2025 03:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0175E8E0001; Thu, 28 Aug 2025 03:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFAA58E0014; Thu, 28 Aug 2025 03:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D07B58E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:34:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91DCC160A38
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:50 +0000 (UTC)
X-FDA: 83825354340.19.45F1B20
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id C11671C0009
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Du/ru+cv";
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HWJW+tuPYyKxysGDOHcH2OoItBTHApdsbmGOaraLm0=;
	b=JGpiUqRtmTWr7sDyh9vBfmQcMV3iopCAg7fKBkR52VyKUM0dHlTlPachqkKQfM3KEo12sf
	TkwMrAM7qTc/hSZrF4mgtUL5+Q+6+7/wX+9QVtPZr3dnzQr5RViAzSmJFg1Va1x6CWFiAa
	YX7hZAW64r92DQNoprJEPQ8lMN9vApI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Du/ru+cv";
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366488; a=rsa-sha256;
	cv=none;
	b=y3+k7fEsHwI+bsf9AgXuQugBSlgTLG1aClZop+6C12MOlyI5xdmiECUkokLeEZEj1euupY
	7XEJhEuvmR3YY3hxZkPsMInB04IlHkWi21bw1MoOh4Ad4zj4XTf8wTazE++qaaF/03HKX5
	6b95bCzrEFgdvMdQJbw7/Aos5t4CJP0=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-77057c4d88bso607863b3a.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366488; x=1756971288; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/HWJW+tuPYyKxysGDOHcH2OoItBTHApdsbmGOaraLm0=;
        b=Du/ru+cv/otdnRxkzCxzKfuMwdgq5wO1qSe586GwOPAaPNSdTStPp+LXbyxP6BgxrH
         k9EsxY/oYOjcE3kMrHXHVWv375nPCsB/n7gZQd30wbHmS3ENtIUA3CCe1HC4P795yFUH
         bJCW1uyNejbh2jihdfnH0Y+ih/A+stuzDJsyYfmq+o7Mhh6MJ6u32qfiG3domY2ingkq
         kbyQavFmRO81d40NSnumwUo7xSCpv97CCyp97GAqizlwXX4Pl2kHPWTCfUfePl1LknDN
         Xuq1uJfv40R8Iv12M5wL0AeOT00zKG531QCzxHAv9g5Pc9T81sw3Vg+7kmUduoOep2KI
         gDmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366488; x=1756971288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/HWJW+tuPYyKxysGDOHcH2OoItBTHApdsbmGOaraLm0=;
        b=EAL7ljXwmLopkecQuQ1w8kXB6N5ion9qOwVGBwdHj0vTc2dYsWoBe0inLk7jRcyb+n
         FMaYpFnMdzi0r2qS+6qoidBKAZb8Vm2XWgq63M4MY49WvZTRtBRUsasRmKfkyNNGenRS
         v/G38S24qlM3gwjLWyAccWPUaiH7xnZotOze91c5MMlL9fsREFLh+DYk/xQU1eJyZs6x
         X4DlR/vT3flhuGEXUdw/L/kC+Mu0S0IJUTFyrHnIaGGCZqImDvwpLh/WS5Q5cynDygi8
         y5xNhBpgjoFF/3KvQPpQqshp5KRFOo4qjUAQdHWzwFV3wE4ucscrVXAET6PWqee8nmL4
         u6rQ==
X-Forwarded-Encrypted: i=1; AJvYcCWz5B2C5fgSRGO4a0EO8ProszhhejcCnNKwNWDDoB/LH+prOqBMku3nExGzGLgHV23Ey1ZeBD7Hpg==@kvack.org
X-Gm-Message-State: AOJu0YzXjCsKbqXGHoEbceb73Bbj0wKbWDFQSVLyumAuwEHN8Nx5br0b
	U9tJfzYpygKqdzQ5kFRF+F37UQ8R7mqyUpFdPAtQdi72nM/GeyTgyUIs
X-Gm-Gg: ASbGncumtlfcsEwY9W1WE8i552MRtedNV5yltRb54EvbC2es14tDWbWRh1S7mf/+Ryl
	41GA8pw2+6C2eq/ZAEf3gFhgHkQlY2xGqyGxXdLfF9ICuUzQ5rx+bh8HQQ0M7nPpEgULU4b4Ioa
	FODkruS7c8NFKfxvGwr0N8qnLDlWZIoEIGNuCtxScssB0vcnOqz6HmXAM+qQcgBKFNSETCYpmNg
	79+LrzPFS3agbmhmMVBmI17pigT5yKKIQEJtbDznGw614cuGi6PrfqrY09UeZvtau1LBZJYRFwz
	TKkpFLtNeRv1HbFqtoODTnPkOWELOJOwqibKZlhUPF8lRm0BtL+YCnZ5TkrilDaXQzIpPEYgkfW
	QjZg2LG2stQQA8vxLVxlI6vRScAamh9ZNaHnVQKO5aKlGu67HuMr3GRub2I2P
X-Google-Smtp-Source: AGHT+IHMS2NPWoxRpnmY3flLVzQUfw/v5SMsqEM3beAW5o+sLJcBBLfDbzGyGozdOk7sQZB2BLTNOg==
X-Received: by 2002:a05:6a20:3ca8:b0:240:750:58f with SMTP id adf61e73a8af0-24340d91edcmr29392145637.30.1756366487573;
        Thu, 28 Aug 2025 00:34:47 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:47 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 11/17] mm/ksw: add self-debug functions for kstackwatch watch
Date: Thu, 28 Aug 2025 15:32:44 +0800
Message-ID: <20250828073311.1116593-12-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C11671C0009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 7n6oqxc4souzpmgfos3mmjn3p9qn64fy
X-HE-Tag: 1756366488-726916
X-HE-Meta: U2FsdGVkX1989sEi5YW9MkOzEgLfv0/I7A19HVki4n7IStTY4j9RXh7YdF7uOYpq9HzWLSYHPbCGj/yTWIAinBCqr0OMe6jJ3u0jCCbm4/SOj/xFebXxkfrbszqh0MBjv7HNbUdfGJgDPuiidhT1xednJDuMEbRDyC1Q3YKqaXCAssTS5T/3957KxnMeXJgQD7wpyHv6jm1KhfK9qNxz3sxdNtXKTBo0nbmkjRoR1/an6PKgKb20w0pQjTzWF+ppW3g1ol3httRtVDht2GevwCsy25S7FIG7QJ/HsOqbeY3VqmCVKJ+dlOdhjKsiTwKEHCJcge0rYIbmqPYalg4LAlfgJZ+I1XvVpQRJfgxjLFO7fofYdRU/qbhgVQGMwoO0M/WMhvb8Y8oWcn9br7yZHjiR9mMb5ma2Y7TrsoUEj+PXEJN8mkvSsP2M4Q9UWWSGV3BTWtVgEhklAzaD/T0J4B9xZoYZz111GpxhglzKRAVN6thMhCvKSHmiXqWJmZZ1hSOn/NFKkiL9slOh3sJWQ+Asuv+unnhKYAOEK/pF8SuPsppwK464xv5RlF33yA3U+20lAxtYyfzIMWRDMaiftouX7famkXACVJ+ISTesVYUUT1TdTwjDXhKZGC0DHhSJAtieQkoZekIeoXOytZKs4rLC3Z5PwDuUk/5VZXaiLZu2zLUzqcPtHFm0zOb3AZvvBXtDTCyfT/f0FVUSssfs1b05EYKS3mPSE1lNZC7KQATFbL4OuMzPPKIEqbtGrUbWibjDV/ls+Sl+zxv16nQLlNF1qCWvXmKPr2Ela6z0mrP2Nzy1BCKp4N9fsDfwNf9PFJlSb2RH/SI8Z7T9O4rBqLILx4lZnsNL8q6qt+1gpOs9Q0DbIsnwV06+p1icIelmkeFHSiuecriRHB881WGxR2LSGumH6sVccVXLAMjdmtFlcdSje/KU7GvNSpDU1IcfSOpymdwHr8ZzUdQdGLV
 z66jSQV3
 QTJwarWh4W3JpgmgaJfeRJSZNVi9PXpBU5Xl0s06CsNBP14OXjz5JDc7KDyDZ2u1DUcUMqwp9pjGvAjlOPkEpTmU4W3dfPBL4Sn+pKP4GWNmjdKVJKq8Hu5vlydVqgc9ehWRRbvBJiUSUrDqSHDPClXDSa7mn2oOBxNckxohPrWiL8drMw1jdHdLiYwsOusfkbCSfxiFcU0PjkxpQZXWH0IuvdOn4qzcExiP53kDOXaWJUz6qoXUQG+l4ihhEcSaFo4W6e/pIQbRnYJAGSLrQ4Mc4nEKfeA9QzmIEfF+kjgCst+XrMEfxYYh53t0UiVB+r2T0UM5R18k3OwM/x1bxTVMsCJlUcAOfrszH7P/0YCLNPT6SF4IFkVnXB9/Hc6JjREsmEGiodJYzj+nILXR10DfYr9vz6hzII66Ffy+rw9Y1vQe3X5gOPALV2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce ksw_watch_show() and ksw_watch_fire() for runtime debugging of
kstackwatch's watch mechanism:

 - ksw_watch_show(): prints the currently armed watch address and length
 - ksw_watch_fire(): forcibly triggers the watch by writing to the watched
   address

These functions help validate the dynamic watch behavior and facilitate
testing without requiring real events.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  2 ++
 mm/kstackwatch/watch.c       | 17 ++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index bc8664af4fa6..d1bb5ae75aae 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -47,5 +47,7 @@ int ksw_watch_init(struct ksw_config *config);
 void ksw_watch_exit(void);
 int ksw_watch_on(u64 watch_addr, u64 watch_len);
 void ksw_watch_off(void);
+void ksw_watch_show(void);
+void ksw_watch_fire(void);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index 284facaac8fc..158843876958 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -118,7 +118,6 @@ int ksw_watch_on(u64 watch_addr, u64 watch_len)
 			ksw_watch_on_local_cpu(&watch_info);
 		} else {
 			call_single_data_t *csd = &per_cpu(watch_csd, cpu);
-
 			smp_call_function_single_async(cpu, csd);
 		}
 	}
@@ -160,3 +159,19 @@ void ksw_watch_exit(void)
 
 	pr_info("KSW: watch exited\n");
 }
+
+/* self debug function */
+void ksw_watch_show(void)
+{
+	pr_info("KSW: watch target bp_addr: 0x%llx len:%llu\n",
+		watch_info.addr, watch_info.len);
+}
+
+/* self debug function */
+void ksw_watch_fire(void)
+{
+	char *ptr = (char *)watch_info.addr;
+
+	pr_warn("KSW: watch triggered immediately\n");
+	*ptr = 0x42; // This should trigger immediately
+}
-- 
2.43.0


