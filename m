Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93306C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3878D8E0086; Thu, 24 Jul 2025 09:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35F4B8E007C; Thu, 24 Jul 2025 09:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200078E0086; Thu, 24 Jul 2025 09:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE1A8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFDF2112CE8
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:50 +0000 (UTC)
X-FDA: 83699308980.07.F1B67EC
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id E3BC11C000E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=FvCWLdd7;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.42 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365409; a=rsa-sha256;
	cv=none;
	b=HzOoz3O2sS21WmjeTIOVdrolrE6Q9p16BEBlZ9lBNiiuLWf0FVvphXzgusKasJgkW3+GND
	iLhbe5AVdb0kWljGrUe3fnFO4KT69D6zQfFcuo4Is40VTA1y8ZZTdjhyXInrPeCPsHsDQM
	+bgo8EeOZplJKc69tIpE1/snZXwcNtY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=FvCWLdd7;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.42 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GVVaZTfA71hNG0BSuf2xrM/AfoVAw+w3Csdp+8nmO5Q=;
	b=UcGcmmPWNjmDq0xmtDI/Nb0QxJxm+Y9RPk2RmxL2EzIPZbTbnoRKUMa8A6CPAoh83ru7AP
	rbj/zfhzleMw6caN2g7OzCUuwmlk6IxHxHSclGBjnRDigis8uuBc14evbJrPlCvPQXpdx9
	fEvWuErVss6yUILdeIfOH8WtKKCXDxg=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-455b00283a5so6424315e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365407; x=1753970207; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GVVaZTfA71hNG0BSuf2xrM/AfoVAw+w3Csdp+8nmO5Q=;
        b=FvCWLdd7RmU4osnPKFA+EOIXjIcjf/LViT6bq5RTUaWSfti+UGz/HDPkXtzcqAEuXJ
         qU8BhT5t+tkeJIJsC3PMZCv3jTobZ2Juh3hOy/zPKbV5qbT/jS2L05d4Of4nL/2lqHAp
         n3qZmA4LESj8PkJAF2BhjpNVDZ3ftIb6VuWukUYDmEnG9cQlM7110kGpQoUcD2qfdCUk
         Cb7Ywg4RGlThY/K1R8Z7p7wZ8XpTpjfPkNTAooWosp3dFIU2CyTWFD+rpuTktxsJxUNS
         n6dhJDq4OSqIVi0qQNCYPIN9GyMqFhCsOhB5rfIUTxDtvlY8Qv03GGcV/khglHUcY3Sq
         2Qrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365407; x=1753970207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GVVaZTfA71hNG0BSuf2xrM/AfoVAw+w3Csdp+8nmO5Q=;
        b=sIRaDgiUxbZDBddM6v4gXTPAnK2mvoFemibbSOObWkeiZWewuLCl4sGmN2xmJDKqjk
         61+p1pvdERejm/vCncUOVYo0zkTiKEm4kRhvbEThwixq82bTDw5JL1M0NThP6scx5QVR
         6F4O94NoS4fj5msSS02RInK6bVllHUZ2hooLXQMzg3+L3HomdeSH1cpgOAHqAXY0JmDJ
         wtqsyt1UI4RNF2CrD6Cwtc811f0J0Q9l1pBvu2j5wFGtVIGdS+LxAvT4iNctwIBbIMn2
         DqyI5DmuV2b+av3PuCgsiGnTZaxkA/oSx/1fsEiWj23+WWZ3jUcpGbjjbMcssKL8+JQQ
         RgBg==
X-Forwarded-Encrypted: i=1; AJvYcCXDIoOajYoQhDyrCk5ZSSFb88lW8NWkyIbwkUsQGInScef20+MsOkhCjogFc93iQUbKLvZCdcKRfA==@kvack.org
X-Gm-Message-State: AOJu0YwUev5z4qpFudSKIHgkmCQYAn+R7Zif7rMXujtJGWOh1EZaZN1/
	4O0PRkjRiUw5Hy+V7f1uwGNdpz+yAiyu+cUzfNdDiILWp5wtiL85i1OTucxd3uaYeck=
X-Gm-Gg: ASbGnctZ0Wjz7TjJQ+8xte/0ubLxDCHpddvya5JVzxcv83lVNoPzSiA8OS7S25gLjtp
	YRTdtpKnyOYjcCwAsno6M3jPV1fjRydgNa0tDitLEkdPHvczLHM94tqkNNw2wv2IjSNl2AWqp96
	dKoa6X35/NejAL761xBGDs+UGteKJzb3nr6RscFv5NC4VLg2VJGck+VnoDneESXnNgDWa7BInFQ
	V8J78lRnRCPmfnc+ByFJewyQ1HRU6a8YtpO9EsUFV7di1WMBUpU7F1wuq6+ko85UylFqy2C93ZO
	nnfURgP114xD0QsvgfLA/SCkjT3KztQrSuWoDmWYGf3FG9ohxFp2yWh0XxFrGVBrtn924L/Qc6E
	p/EvhWj0K4WFv6M5LEk4ZeqstXFQme/AEtv/Rj9XhiJt/fnN3VqS/+HCFRy8vSR2eDR+cGlk3mn
	zf9KFFtLPx2nOg
X-Google-Smtp-Source: AGHT+IEY/sSxRS3Okztem0YstmxIRhVbZi0Ba2eKMOhhVazzTllUuYgXqZyOH8eoFni3mxJ7gmSmCg==
X-Received: by 2002:a05:600c:630f:b0:456:2bac:8f8 with SMTP id 5b1f17b1804b1-45868d485b0mr79331075e9.16.1753365407522;
        Thu, 24 Jul 2025 06:56:47 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:47 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 28/29] mm/init-mm: Annotate additional information into Kmemdump
Date: Thu, 24 Jul 2025 16:55:11 +0300
Message-ID: <20250724135512.518487-29-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E3BC11C000E
X-Stat-Signature: ys69tta1ihxa4iucpcunuftzqc5oym7z
X-HE-Tag: 1753365408-746165
X-HE-Meta: U2FsdGVkX1/0ogj/kaVKVGny01baJI2svkbiO5vKrwpNrh0slkEc3y64UpAnruW+f3q5AN+CJDt03oaaMk60sVwtsfNwBsiUSPfhbJCmBjS1r4Ap+yNOSu7hZIQj5RMuick1mO0Ln6DKnGXhtSegxk0LPctOGVXy4YLfc5GIG2/tSEvWRvXXjcfSUjBdX0SHzBQcrFqfUEbDT6ML/4VlELH+C1QscqnUpkvGBz4MvKLrLhTvqVrx3IbBHMjxFdxfA5nwPaob9CifwK5ov+eT/as/416lXPrw6F8IYB/fqzFZT7B2r72sH+uQY5J2mKtZbgN2Abs6gqoJI6LMyUOiSVbs0RsXS7KBUPPb0aEHVu6lAo34TXoZLcezqi3P28WP3BILN2qCHLUP8CqesdhJHKRMsz9P07e5IiEw/+ZZEUi7cMQTbcaZnam7OlTzh+Y7zjYRgUI+vuQoOywBg1bdXgJYj2fPAaFhqHkAXoqUgHhjkJvLxzvEfacFtjh5XzsjTHEgumNVGwCbW/hmDZi0qXc6m1ZSL95SQN6937wHJ0LGfWy11rhFyNpLSxoWGIPSAIMzC1GN9yeDTXJh/uQLQ3fqcgVckeIpaLg/KYnlSj+0sLyp6FSfyvLGv+bCll0qAG7Oj2tgwwIkT5HJ0jzQosD174YfwHGAHeL7q928EqboC8G0Bdlk79/Jg4SuPWG7/XwtJZYwQQUvD/UAQXKSpIOe4xncBxeZJVWFr80xLrX6s3EZ0Uh/W/AJ/iPAsc3sN+SlxEsRU3GmCeesxiSHEAvzoEP6nLc8UMpj/jGTibJZTUMpHztwakrPw8QXt3+q3WxuE2Lz1Wpqt53sojaLGpWe8X9LNZpPUc4bzUPlvaV7tzRlv82b1UvF6LmpdC7zI/fBVAL7LOjrFgt6ZOk4v83pimLjwYeZzDsrGTyHKC3FkIGz/wdzZwirXVupAzaR6oPGG6eVP6/cj/U2QCM
 3m/a4l0i
 Sr7FOBhttqLrk9OXsADQZtfiiKisxNbHUjUe+lTyed9QJ7qs8qsF1DGazNdfLhwGRfciL+K5kvF6DUPXRAwHVkv38PMI+vZskpzQOhYBJ+Qf76mDLZazkqJ1Zt5DQpKenauO2Lt29tP6i+eIwQG8Ej5qhCyanYQYrofOFs0b8LxRPD7pruVzf2aC4QyF7jsj8isVc3fKANJQ1DFejfx4pwxQd0B69HPvS/NDguXtm7IKFvLXjd+49oZk2wK+aBQjP342dXWXfQR/+9Ol68ZHbDXxzyngHoJqUGtVourPX/jwasFleFV0jFj8ARHkao+3b5+UEC57Ec6TfPS2JGf5c+V8IunmfSLOk+ioJlcwRiEixVrQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate additional static information into kmemdump:
 - _sinittext
 - _einittext
 - _end
 - _text
 - _stext
 - _etext
 - swapper_pg_dir

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/init-mm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/init-mm.c b/mm/init-mm.c
index 2dbbaf640cf4..01ff91f35b23 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -20,6 +20,13 @@
 
 const struct vm_operations_struct vma_dummy_vm_ops;
 
+KMEMDUMP_VAR_CORE(_sinittext, sizeof(void *));
+KMEMDUMP_VAR_CORE(_einittext, sizeof(void *));
+KMEMDUMP_VAR_CORE(_end, sizeof(void *));
+KMEMDUMP_VAR_CORE(_text, sizeof(void *));
+KMEMDUMP_VAR_CORE(_stext, sizeof(void *));
+KMEMDUMP_VAR_CORE(_etext, sizeof(void *));
+
 /*
  * For dynamically allocated mm_structs, there is a dynamically sized cpumask
  * at the end of the structure, the size of which depends on the maximum CPU
@@ -51,6 +58,7 @@ struct mm_struct init_mm = {
 
 KMEMDUMP_VAR_CORE(init_mm, sizeof(init_mm));
 KMEMDUMP_VAR_CORE_NAMED(init_mm_pgd, init_mm.pgd, sizeof(*init_mm.pgd));
+KMEMDUMP_VAR_CORE(swapper_pg_dir, sizeof(&swapper_pg_dir));
 
 void setup_initial_init_mm(void *start_code, void *end_code,
 			   void *end_data, void *brk)
-- 
2.43.0


