Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6DF3CE8D4E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32CFD8E0018; Fri, 14 Nov 2025 10:54:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DE138E000E; Fri, 14 Nov 2025 10:54:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A5CF8E0018; Fri, 14 Nov 2025 10:54:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 055298E000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:54:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B258A13ADC9
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:08 +0000 (UTC)
X-FDA: 84109658976.24.503DDD5
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id E4C501C0011
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kheeLeKq;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNA42wzRtY6tumJLzcBMrDKp0mvbCSdRF1f9tLE+ESU=;
	b=4dPxH5XLgXsoirnQl/V+k39Joz0FOxDXeNA4kjd/9QEdYgwGWDy7VKgZeAYiOFDpBeJiFD
	EkgjIRKSXhACigr09RtGAZQvsPICoD99Bq3sD7VcSW04fQIyg05Qz9rRRLQZXryEK2qu8D
	h/JnQT0AAHgsQ+UMde675Kw2eD+f4AY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135646; a=rsa-sha256;
	cv=none;
	b=kqfNw3NKBWRzqIBsbLvbvdIB2CxdhHsd09sb1XSr5xy07mqhFrOHMbLg05Oxne7AuxtBOX
	nIWW4jKOgY+wiu7C+6WUFNYSgrcIFKpd2Uz5psQXQqozhxRCyyFACuiN9ZgtOXtklJQqMH
	zXzPatiaBTDllODBmY6Q6i6rzsKYRHA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kheeLeKq;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-640d0895d7cso2705359d50.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763135646; x=1763740446; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BNA42wzRtY6tumJLzcBMrDKp0mvbCSdRF1f9tLE+ESU=;
        b=kheeLeKqHpEZRDgkxh4xcxzMOCOfxywssgyNY7CeNs6mrEKZGvAkVcatBljbTbuPe0
         2zNAqK9Z4hx6tCuVsaLrfHMer86n7I8AjyxBzSAOnf+RsD06SYWcT/AHUy2642uAEAJA
         szK4vfpDcYX0xAc6F62p3qGQFLAqUVrBms6H6/KtU8hur4JBF27vXMNNlY+0STlSp/ep
         gO+FUneYTqmIGWTCb31NkFjZxU8V5UeifW7EgLdMljlMIhKUAuuS6Uiadc4DP/KhcPh5
         ghVYEcOZmsjXaYL+xXNvKQ82vTHgo65mRpAkrroKA1QgwXOai7d+R0x6LOuyJYTcFaD4
         XKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135646; x=1763740446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BNA42wzRtY6tumJLzcBMrDKp0mvbCSdRF1f9tLE+ESU=;
        b=IdkZjLW2lERMwIggHInN4C0cRP+qN2d4xU9roV5j5okzzDydHeZjO+hLk3eyKVzkBA
         WRj4sTaD8Lga47xnb/PY5lIW7pLB3i/dVXZLER6zXcVdAv6RaDnyL7zgpM1/MLJWyXo6
         wB56bCooHzoqwJL+nDg7/272UtR9GJgOd6U/RE/ocGMokYerkl4Xj4IaQbms59w4qSHh
         F/XD6kaXuT07VtZVq5U6Av7S0fnL7fvI9OJms8O323nyIj0k1Mf++WGyIx5p6/vR5uTG
         keE23H2eZKw+kVN2RUppxDQN7T+5KYQypLsJwGZVxtiW3+mh0A1ZTAB3gmjy279TxOaz
         SnCA==
X-Forwarded-Encrypted: i=1; AJvYcCWEkUKuDP4eI1/x36iIdqvADUZjEZLnY6V4Z1xD627GTl0Cv6msdUtDpdpSgTsYplxEkuRxXf+P5g==@kvack.org
X-Gm-Message-State: AOJu0Yws/t5s0hOWkvn4ntaUd+eBi1SUyxkRxw1i6pG9fhrk6oJgDA78
	mFqDGfe6wrpPUYyeIopaot+aPNNanKwSMcpvdEAqA1RP5K4YyiFy/uG7WEGB38Ux+Cs=
X-Gm-Gg: ASbGncvSYeIpXefqvG4eMOHNcsWfE2wCuuO5F5jV78hT4Bd61CkWDtVqRT8I8lqHaTT
	u/w0T2xLadGLqs/G9UL5XXK0j0I4v8XbSYJh/t0Q4vRvUtRP9z3zhQAt4scOaLHQw0P9+mdHuIY
	xNd+4+IOwxyqL9bwE6lweJdaa9T7nLyLSo1f/LYHDFOqMqjaZmnWOzSb4cDrFc2/r0scgCz3BNW
	gFlfOJDMm11M8HiTz03f3yXWnKLFsfcqnkyu0DBxMK+ZwGa/H59PG4sleAZyv8GxNhVe8x7M56R
	J0B3Yl36mq42V5hIuZF7PJIJV6SrTeiex7mvJdatlZXSu9L3HQpNN4ah1hwmn85dAR7Nj8aFuHY
	wz1xC8HW0/9ylZdn+ICHVbI19cYs6KK7mWX/R/c89bDKdol/PAkMWjz+t//iOh9xcHNsIQN5J04
	gPqTDSlJOMMmFxSRdBT7wQh3N4kajPv6jcallX2FyXhVZTKG6JP3L0SnbKVTM9Ct8lpFBV
X-Google-Smtp-Source: AGHT+IFexeZ69gOmsixo4URTVxxOjfKW66ZjvkgEzVhORcXdny0LfmoMUzobq4DDg3SxMb7wc7hsuQ==
X-Received: by 2002:a05:690e:4008:b0:640:d864:6e64 with SMTP id 956f58d0204a3-6410d0acb20mr6556525d50.14.1763135645970;
        Fri, 14 Nov 2025 07:54:05 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78822125317sm16468577b3.37.2025.11.14.07.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 07:54:05 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v1 03/13] kho: Preserve FDT folio only once during initialization
Date: Fri, 14 Nov 2025 10:53:48 -0500
Message-ID: <20251114155358.2884014-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: E4C501C0011
X-Stat-Signature: zs1w3x8towunnfppb56rcqjeked13mfq
X-HE-Tag: 1763135646-362262
X-HE-Meta: U2FsdGVkX1/pAHWy3VpP2z0MM7Wv/aHTpTDsKgWflRX0vOiPIx4yqjPY9s9PT18NLLTy24txko4PuoCEgyaN8em40wu0ZAO9sBJohCu1u4tBKupUIn/dy8qJdf3hU7p7LKxoCMP+Nl/2JOvK7qfnaYrp8/iroJ7lmC6MwSU0zICNgd6QSqhU2qB4nwB3jNVKM7pDTEwH7elk46Z6krjL0+mDOxH6F4In1rf6Ju3NHBoqc6sjCM8YBIvjNzRzV4hFJP4xUFMefXr7nQuiLiitAyfVOa8m1z4PNtVLz8Esye4PEGkK09LLO5LSroPG2vs33AH121slkgQHCZqoz+g7J5kJGjxmoof8VS5kRS563ORQT7uGDtuV5EUvMsswGION9wOMa9TDWzOKoYlyaxY6NjMQWatwHGUG+aaZEUqQqOgFqTz5oZTxRPchTEQw09ybmIlIS3Kvb531NA6R8UeLIrVqnY4ticQDhCOZidYHhk4scIDPu6b5ZeAYN7wnhGoEeI+mqUIVe51RtbPonQdMBWls7D21Oqs4kXq5y0XNfEkraHJ3LZ++7aFKYVL/FnKXV8dRrFUGjQ2RFTkMUrWE+fikRh7xy9J8kO16MbTnrMT56lZxEHLomBT//hFb5UX97CjZA6Qteewhyfn9rwZDz0nRRQOll5Rf4pDg+WF1U/1LeW3UYwaq5mEQl5Pg2jqhVQNcOr6QMY083eKL+AVHQN09qJfFsflSZF5zGTyOSf+nvsYSb5k/yTSkAqnXEFMagMdAqGMay62JRz2szhGGadilITQkBFcBLfrZ8drF0vZ84NHwiaXOUvYZatL50erMo/HB+oXCDXfEVqkggPgPOLI7lnGTHFgjEni8g0RchtpXTO79USjEZPj8gxSKUywam4NO1ttFcbeTG4NLGvlhEMwU7tYUfnJThr06oD5yHFc0ZZKZOUdVZLs0f94mj5oa+0nxxUcauc3dSsbWGcp
 BAQHBDCp
 +GgAJyhsIeXSRKOZwbU5jTtNQWiZG+h7i4YCbIqYzkpwoNELEM5uiNZAA0u6aa8GJM/NSPeQ3ZIhBOUaYv37qECy+2RYDNv7mpOjYhTYnz0+90VdAx0E5ncIcOFbEKPmezxmOvnfOKg3HsWiW3KOVek6YEMWCKbGLKJmg9QJ5QboeSbjyVqlQRZ6ZhAPPpD2bK4T+CVdjtYFh2TFk6/H2+ZHrexsQpbOPvaJUv5GYHUjtpuGs58SoKLu5PLZBtFEkU1z3wvuf0yiJM7IrQokM0E57EwcTwmA43q1aF5Gjc9NjSOthbyReOU6mnGEH8IgEpjvrdF73twIFp4vFIYEsWIeV1E56hoEeqKGsmK5tgPJQD1s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the FDT folio is preserved inside __kho_finalize(). If the
user performs multiple finalize/abort cycles, kho_preserve_folio() is
called repeatedly for the same FDT folio.

Since the FDT folio is allocated once during kho_init(), it should be
marked for preservation at the same time. Move the preservation call to
kho_init() to align the preservation state with the object's lifecycle
and simplify the finalize path.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index bc7f046a1313..a4b33ca79246 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1164,10 +1164,6 @@ static int __kho_finalize(void)
 	if (err)
 		goto abort;
 
-	err = kho_preserve_folio(virt_to_folio(kho_out.fdt));
-	if (err)
-		goto abort;
-
 	err = kho_mem_serialize(&kho_out);
 	if (err)
 		goto abort;
@@ -1319,6 +1315,10 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
+	err = kho_preserve_folio(virt_to_folio(kho_out.fdt));
+	if (err)
+		goto err_free_fdt;
+
 	if (fdt) {
 		kho_in_debugfs_init(&kho_in.dbg, fdt);
 		return 0;
-- 
2.52.0.rc1.455.g30608eb744-goog


