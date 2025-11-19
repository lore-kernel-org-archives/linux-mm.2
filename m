Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA831CF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71816B00BA; Wed, 19 Nov 2025 10:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D21F66B00BC; Wed, 19 Nov 2025 10:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0ED66B00BD; Wed, 19 Nov 2025 10:45:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5E426B00BA
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E61313B2E7
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:39 +0000 (UTC)
X-FDA: 84127781598.26.800ECEC
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6DF53C0015
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="f/qPTTjH";
	spf=pass (imf22.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EgUtWpxUoehpDvVbPcVA+GkHlZFESzHxIeFdx8HGLc=;
	b=vByyHLbiPmgsafQ+SxkwyFgWKIWZLgyqPyyNpYAUal1a3Wb/IG+aRffHM0XB3T5JtZoQmg
	5V8F9yTd8FPTB35aTwFpjLUtEQhg1EicimwViVtoMj9e8k4Tba9tLD0jKm9afXMpTA2DZA
	RpdCRkF2Gkg6P2I++9JokqAuJrM3xQA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567137; a=rsa-sha256;
	cv=none;
	b=kXh/0F2ieTcXsyGzeBmZy4zdyvY2hP6vDQWPpRdJt0jAg9OkLtDBk2GrCqR76R6I2sGlsw
	TxNKRUVCUltRcaC1j9OYrZVbRoyKFTDvq8XZHZCmOOqz2/AoJWJF/9tvCsjPz3Qi2fdwyo
	KL0+rcillATSjxA7MM2F4Qm8OcN4gXY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="f/qPTTjH";
	spf=pass (imf22.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42b2a0c18caso3706250f8f.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567136; x=1764171936; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1EgUtWpxUoehpDvVbPcVA+GkHlZFESzHxIeFdx8HGLc=;
        b=f/qPTTjHsgFCcFYyIX1Edc21YIu3CO+cKVcKoE9qnhJe2ND5HXMowqU6N953Rc0AqZ
         iaK+AUNbY6S98sC/JhvPpbMikYlsp8XdH4QYfOLD8XQ0J3lLbP4rZRcnQ0jkwJEmz5O4
         WEVvCi39WOXHriAFHV+iz22xNdhQGirnx3TiemSAet7i8DrgcVcNYyVyag5EECHSugyQ
         pL5m8ErRfTI6fTicnc/0Ez0EiEyXhAhrtYjWpv3t2uDzP6uof63F39V1M0JqiuuhJiaD
         TIs7FYi9EvUqjHdPLf4yfl3pnyTW3hHHRn/zosp5GlCl1KHUvf499pamnXNFPuTuqYbJ
         FbmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567136; x=1764171936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1EgUtWpxUoehpDvVbPcVA+GkHlZFESzHxIeFdx8HGLc=;
        b=oZj1kVhL+4h1M+0/8Jdn/xSuhzktc16d9VIUPN48IPgIXzgMcebYyHB8yaPrdZpOpG
         D3eNOSw9Oiu6CkbkOl4qLhV60wEIH0iSmBEYpj2YhFwbBJNcstqZdnmRzZF1DMcnyZ7I
         Ie85VPt+rrRU8VyugfNZb7rEb+OZQYfUviGKboSdz20tWK+WMETxsc5nxCUmFcc7S8/w
         0R8Ud+QOHaCHX1lOGg05DQ6I4TmJ41IRwJXbIulnNw6tm1RpNy80bOITn209fCM5D+M/
         LRVAIp/rNe/xbXbY1ZXeELwxVoxPyGbrX5EPTPmr+LBh2KXyH11+BB5l01M6I92jYBg3
         wcRA==
X-Forwarded-Encrypted: i=1; AJvYcCVFFxLXBOieNxZRB5BHk0HhXRtrxjveuvaeEj4fVDdKRzWkXlxzWebdB6I0fFRSl3NRR4xbkxJM8g==@kvack.org
X-Gm-Message-State: AOJu0Yxl0Z2rYBfcTAkBlM5dmXXEjG/eIk9CfN+bzqxxMMf/bn/3O0A5
	k1pzrEb1ltC3S2bW663aH1+uhlBE2k3jClANhx7oDoscn3RZnBQXREEMUdrHxX+fgiY=
X-Gm-Gg: ASbGncuEqliDMkRD1kRXhHj7kaZZMnygc88J61P28iz3tjSuSbyya4zQw5JSVoeMMRe
	3SZab7K187etF1v+V/lNwYaCrPSVfBIzP1ftqnQibl5r2jfadFe2oTMIlbYovGZwvQy+Ood0bOl
	FkFL+dVT48trrmKS5AsRVh4ys3fnlaFGXgGxHHPaCA08+GITyKQ+2jz2Kyz6Wl2M8P//hLXNrvz
	AptmXfTAv8d1kpdyuBlDD3dTXwKIX9hzvNXu5XuzvK5ZXlbxfU6KFmoamPjSUYUvxW4QEXBW1kp
	gpaT0iumgqPCWRbwy7lB6kJQsrJ9CDeD2gmnap3pRfjvEl2WtQ3UhcG5bbOav7YHl2mCK2lf3K8
	weMv9ER8CfwCw6pemPw77vbcNbWjle2+OhQvtiwpj8diGstTVW14KhxpLZvOi13lHXvFjInpDs0
	90I1vzydiS2nrz5tbCUQlcPaPXdopXfQ==
X-Google-Smtp-Source: AGHT+IGKFFWZ+AqolHJ3imLY6SMDSF30b2mMpFX+Q/YU64RzAj2P3ofwp9AZZn8blv/guB2oFBfRQw==
X-Received: by 2002:a5d:5f93:0:b0:42b:43cc:982e with SMTP id ffacd0b85a97d-42b595a497fmr21650580f8f.36.1763567135863;
        Wed, 19 Nov 2025 07:45:35 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:35 -0800 (PST)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	tony.luck@intel.com,
	kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [PATCH 11/26] kernel/vmcore_info: Register dynamic information into meminspect
Date: Wed, 19 Nov 2025 17:44:12 +0200
Message-ID: <20251119154427.1033475-12-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bkz8yi5ug5da1poy3kdiy8579ya7q9gx
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DF53C0015
X-Rspamd-Server: rspam01
X-HE-Tag: 1763567137-257822
X-HE-Meta: U2FsdGVkX1/Hb86p1O6h3tw1FYOH94W7DgNw4aQXwFJwaMfaub0T6sgZuw5SNzmj46pY3BGB4jB0OdqN4sgZS25eDoz5bua2im0dscesPBWdrclfS2qIbO4xY4eKroOfhP6VyUCJrRbQQ20QLVsWdege3pgutrcFrrloueAGUtqCGtwnFMEdDN8qhXnpD8MplqcsX2YiRqut5YgxK5x8qqquXwevg5JQYiGUOflJf/jRdULZtgYnGhu7oBbQ+hi5I39C00Lvld9lbY0HpXdlTUflcRNiFpSTMI2l3qVKQvWbYkb8ZPhT0zT7KKVBLsLRQNRBvf1B2AvBy0wSRzalFpj2gz3AU/HcCTQRCnyJE56plqnPV4UwUf4A1K4tm/iekAS27MieKlnq3to60LLvqoX0NAdrTHq7H2qa1vbnnSxFSh5Ty/iUkRSGf02E43KvureKkEFXRVTEJjMcxgNU6Ue2/fp0Fn8u0NAgn8wSG3kEiT+rlD8pMWIGLfIHQkO9Uo+uOPsDRUPBHdljsA6EQ2B+tEQ/Bg6R56Gl8B3YYTBo4wyI2BYNRpuBR2CjlosWI0CwkE2QT7ZoR2+Mv9uiDRL2dFGqNC2eHuegam0IzqcaAe76zmMv3BcQgKYbY+59tOuDrm0VW+phvJZGfu5KLfU+rEeTzr77qzo1GVBVjUta5mchgs0xq+FFUW7RkZekBYCKVHsiynqsrhTrxxbpbVdWz0RXUIRTw1Sj1SaR7bOXibQr3ZxiTmOG1qrpTJTyr+kjPFCHeZtxsGPsXdKpC6A43ooDKU1ilvs4N2szdEHIyz5cNchelGKmSqkfr/A+Cb75HKQKj58w0ksXnCQeF+as53zRbebRPnv18iOt7M/e5TeGKefDEaAjC7uonNE4GeWAi8WWxi09qW8Zt9nalivgZj9htNKBb+TucF4feppxK1B7k6gLiA4ax0gBbLljzQXoYl5sbKn0PsTh9ms
 Mpi7dmfR
 bNNCtdA3Vi6DFehm8RqKYvjV3aDNOvUTp67wL7xdUCIFSLqOpUvQULVQ62ceiACSNGyFq6jIToY+6233SdcQje5I/pw2w6cVyADjwx6wbeeBx9IICgYg8v+r5Rh0R6Eze2d1ykAmDFn5SOIlmePCBX/7orNCnWVdraiFc8rXO8ctr7nEtMQxcMMFPqAnT+vJ5azh8RKz5A5YfbE6TK7LFjk3CIHlCSymC6q051dtTRW6bSKzYUVOUl3ZBnO+fC2Mx0ZwXg4ZURw5B9keaUm6vFxSw+cXf6NAPuQAi00BWpKa84xMC6DcLGtfblPKOvwWOYz7efCNETENVVGjDDrefKS/fo+a/1eOikdizRdFNhOQMdlAyyAg+2KQADZzkUroKp43l1J2mTXRLACDUGf31/55Uza6mx+sfZmSysGJ80JYXJV8ST/QH46hGmk7Izsb8Tuj00hnM4QIYvLVoavUL4sYRMIXumuHhZpQM8f/hLVtZfgma1xidIho5CMtrQymXdapocnKhcfQTh3KbTe1oQ8tU8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register vmcoreinfo information into inspection table.
Because the size of the info is computed after all entries are being
added, there is no point in registering the whole page, rather, call
the inspection registration once everything is in place with the right size.
A second reason is that the vmcoreinfo is added as a region inside
the ELF coreimage note, there is no point in having blank space at the end.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/vmcore_info.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index e066d31d08f8..6a9658d6ec9a 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -14,6 +14,7 @@
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
 #include <linux/kmemleak.h>
+#include <linux/meminspect.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -227,6 +228,9 @@ static int __init crash_save_vmcoreinfo_init(void)
 	arch_crash_save_vmcoreinfo();
 	update_vmcoreinfo_note();
 
+	meminspect_register_id_va(MEMINSPECT_ID_VMCOREINFO,
+				  (void *)vmcoreinfo_data, vmcoreinfo_size);
+
 	return 0;
 }
 
-- 
2.43.0


