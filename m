Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E81B8CCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 10:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31ADD8E0002; Tue, 21 Oct 2025 06:06:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27DB08E001F; Tue, 21 Oct 2025 06:06:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1247A8E0002; Tue, 21 Oct 2025 06:06:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBE548E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:06:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7D9BB97CA
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:06:15 +0000 (UTC)
X-FDA: 84021691110.15.EB87199
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 858F340007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:06:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T5V41uSV;
	spf=pass (imf12.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761041173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/5MqLTGooWfwQQt8bVLn3RBEegrtdNGSt5bbFt4WvjM=;
	b=PGGFi9NTcwiYxJJkWHS+/VTGxIHyPr7AQcQlHefKdtLhzeZq8l+vvJZr9lIjaZObD2EMMw
	Q7I/ZyJ2E+O3+NS3WU6ygCE33R/boeeqUUQYEeC3nKz4QUQ5l4pK7HNwt5NWdXjfJ1L8GH
	JSXPGupjA2c+HX/EP2+Hk5KW244lhfM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T5V41uSV;
	spf=pass (imf12.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761041173; a=rsa-sha256;
	cv=none;
	b=nPolStlZC6tvA9ymea3ndMn9hIpvGy0tr0CM/IvsUNuIWjSEs44xPVc7hiR1ppYRBs9+Aj
	QejyV35KjxAXtRwU11G5tAVD0D6Ced3iKvhvusdK2vVzAOp8OR/mK8wJhtR8iRxpGM0C6l
	JQULE2Na5VoUU89uIZV/Ir3QzXEbWvY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761041172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/5MqLTGooWfwQQt8bVLn3RBEegrtdNGSt5bbFt4WvjM=;
	b=T5V41uSVUjCNM5NfdiTeDLnSkUHL4YNRE3Kd93WMpdVQmBQk3VsWdbQ/bd6VdzvwfyxqeE
	coiwI4MMgEDcR8xXaSfvG88GlEladG4A4R2iOpuwa4rjlOu+wUyXt7ZP79JKP1PinoCfXr
	jqBm4bWz5PZyn/jEe7d0B2agHLX3mrA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-CqqB5TycNYG-Mps8sbsCKQ-1; Tue, 21 Oct 2025 06:06:11 -0400
X-MC-Unique: CqqB5TycNYG-Mps8sbsCKQ-1
X-Mimecast-MFC-AGG-ID: CqqB5TycNYG-Mps8sbsCKQ_1761041170
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4270a273b6eso2839072f8f.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:06:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761041170; x=1761645970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/5MqLTGooWfwQQt8bVLn3RBEegrtdNGSt5bbFt4WvjM=;
        b=qNCKaaNO9QJk1fs7XQwTFth4VM2oSLoC1BoRMctXow2ulcAp0UvxCr4wLQnAoIeRFe
         iuQvbmgt4f1Z2/xltJ55P3dFsafx4zlPNpyk+sz784f4fiHlDyH+f/K1Inds33KKV3ZH
         JV6DkLdPpItiB0OUIVCrwDDHSFBI69T2u4i92tiS1OpKF9ZJhBHQSbn27pmj5okr6eyj
         rc82zPCfUXJSPAogAUbC0Cl0mTdrW2TgRbJ8WuMrVHoc+UmhdeP7cSjjcnq1KkBwNJ3m
         tUTCAxLUxV6K11NYSp1DuwhXjcWl8ugbkD5eaANiGX7zRNy8Yu2mu9+IBjs7f/7Pv9CF
         pkbQ==
X-Gm-Message-State: AOJu0YyRzBmCxRD4ZVSbKGV9zxaPYF14KspVrBF4ul5FoJxPR/DAi6n6
	v64M5PCklJLWnvGCtSCHUy8DL1xdBSHy97VkPiSdFhe5Jz5NHjix4FpJT299eYlgH2CARE5Zvx9
	Yv7J6BeD9PfF2Mhq0XzIPnowBYhKXuC0EalBHVpSiy7Zu1TNM2C7RrnYZbAxX
X-Gm-Gg: ASbGncu9/oa6lmS4Jn1NVoTWLDTbigyD/awaheuaOVkoHC1Umz6wGu6qJxydqMTNrRy
	7Nc4rVTsxOgCi4+CpKVY/CbesyQa81/BqdMMT1O/ku5ju3HZ8Gx5aic2tHLEbrUWY4ze8bDxj4K
	VwVpn+115Rh5AoxdjtM+fVYjkW2BQ7BDKGGK5wgOzJPdNzUjYXhSHo5m5HxKD/Q+bm5+rV4mUOR
	ehrFIOzzlM89JwFJOYtbzAnHA4lRFEhxK4AepiFfTxR89E83nr0DNJcHMEayKiWZscFJTZGoYSP
	v5X8+825IfmCnhZ4GMJeY0kKruG75KnJ/1dY/otlCrWfi4yrXT9Oa2nUaUlJMR1lCLbgs/J33tz
	LIO7VY7A4UYR3PRb6kWQ73ZxKDJVLSRPh7bCP039sQc0BlOZpQ3nx9VIhyCdP
X-Received: by 2002:a05:6000:4b08:b0:427:526:16a3 with SMTP id ffacd0b85a97d-4270526183emr13034330f8f.29.1761041170165;
        Tue, 21 Oct 2025 03:06:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdWAfWri+zwLuauv8PrjZF1aMCEwE+dY3BrO7HzQ43FnWYZr7+OQSBPRdaLGioAsiSvfA5Zg==
X-Received: by 2002:a05:6000:4b08:b0:427:526:16a3 with SMTP id ffacd0b85a97d-4270526183emr13034300f8f.29.1761041169744;
        Tue, 21 Oct 2025 03:06:09 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-427ea5a1505sm19854508f8f.8.2025.10.21.03.06.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 03:06:09 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	stable@vger.kernel.org
Subject: [PATCH v1 1/2] powerpc/pseries/cmm: call balloon_devinfo_init() also without CONFIG_BALLOON_COMPACTION
Date: Tue, 21 Oct 2025 12:06:05 +0200
Message-ID: <20251021100606.148294-2-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021100606.148294-1-david@redhat.com>
References: <20251021100606.148294-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XNWce1IuGgE3-cvPD3t8rvbOfwDQwUAo_JmAmwOHQy8_1761041170
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: mcdapm71ipjedc5ptsky7pxyn61e6a11
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 858F340007
X-HE-Tag: 1761041173-307139
X-HE-Meta: U2FsdGVkX1+k/dodtKsJdMIK9K5y9REio74WNOo0hgH2onxDm9+9PB68ivyPUsolxg0NalUSdJjTZaiD/5zpJbU21S5/MOH6U1So9OdjbyNhX4YPbNwsoCdcNLGMXVUzTTE4fXZRlkL1T94Quu8KvAVQZ56MIzRa/Sr+27bGS+f5wYzKZeSUsqSBLVv6xWtnewxif7cn8B47Ee7pKOug/zK3QnaGjmgx3i0nh7zo7s4+pd//KmJxrKvVXfhY7xBJrgat4fdzhhYRe8ddmsbNVtFcV9j6OCmJqbb0tfEmqNIn1EzgSbnKEa6uimJtj4yOt22ulvE/rUh+khhl02vG9arLRWMU1OklsFJJ6wvzmZ7ioeTDFQbE8yApvvHsPylFSBESPeuv9V8M9WAcZ9OpV81BSeO0kinq8P0rQ1aoA6iMQWDpWsWoBbW6Kr7bCA1p0+if4hNmRKTgBb+XR1xpI4RnsmWHBdfWt+uZfrzDkBKoi8UWVqm2LMZiil/HjH/3e6HV/FyiRajUkrVEyheCHpNDIp5+4cdHnSyDJXtySvTvT3/Z+e6tznFSTfMhbBDlfiWveIIvWXjVrMI8/MtCsKFTVVG+WQYFSHJQYlkMPUKAD9RVkf5NSBkn7BfyxRktmvLfw79rKiXZlvmETIXnj+juVhlOvuCvlMpeBcH6D3M77UZt4s+Vev7ikEYTN9CEU/MYWPENXVkKXWvPVdRa+UShnf9s9XSJggN2ywOBr53laCX1cIHzlP6qPJhVQpP6DWYNvjW+OPh8qgwkS9ynuVFeU/gEOJnGnA3Xwv0gzGDi70IKksDX8ZsrYt+5exBFhUBqRLYUHTEcr9hSdwXuXlmxFZD1sBUf3WSzhRM9D48YhfU3CPLsZG8JIvlAE7h/IyBYVtdWNfdKGxiM7XiQf4YyVen7CA32hxY82JStmwC/83XolfgDcRALzV1VRxWAxZX2G1syQAtRDfyTQM6
 nVuQ3qbF
 WYCh6qAL2L4n7KusuV9xrXRXqtqpU87wUtMN6+x2pyuTy3nK+f4fDbFtnuv9GLgTPxbnG5jGLV6UVJYDUtK44BEZtNo03HG3GWh+5dnK2K7IbZoZHFNN5KCOBsniydBgYvW9kK52aWuLX3DZULjoPZXNjslNhdbGLre3EFxjTebs51Y8+zEJ2EDn3rO/ssbdJTDZ6lRmz5eYfaD/HWm+2/YVA+FF36KMrfWjSSg81h/+r/Tn/dHGe6isF3vrS0jdtDEe4aD33MFYbs3KtDKFiulM7CP2MexQ78XxjH11BK7bD5nyuA8zHqvkW+AkRwFaGrKBIdpbtrsgk+P8cSm3yjoYoBDM+Qp74IcLoNeSkNsLduppPmCd4vNuelxxHTaubhuMKbRnqkOPfe3oBlpGo2IPlX+HyfMsOtoQKJ1su8Nr/Udxl6P5LGPb22qrnwzBxrxq1lomFC1/KwM1wTovTl9fmRm8IUt8raG82j4fPpG4HqufAdpZdjzWjNKJ58H8wi76OIHGpB2pTn8bs/tLzzMCFaKGcOWdVySH4U2NPU+Rs29TukWHrFyZvqKJeUaB6wvNtXNI3q2Y1s+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We always have to initialize the balloon_dev_info, even when compaction
is not configured in: otherwise the containing list and the lock are
left uninitialized.

Likely not many such configs exist in practice, but let's CC stable to
be sure.

This was found by code inspection.

Fixes: fe030c9b85e6 ("powerpc/pseries/cmm: Implement balloon compaction")
Cc: <stable@vger.kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/powerpc/platforms/pseries/cmm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 0823fa2da1516..688f5fa1c7245 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -550,7 +550,6 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 
 static void cmm_balloon_compaction_init(void)
 {
-	balloon_devinfo_init(&b_dev_info);
 	b_dev_info.migratepage = cmm_migratepage;
 }
 #else /* CONFIG_BALLOON_COMPACTION */
@@ -572,6 +571,7 @@ static int cmm_init(void)
 	if (!firmware_has_feature(FW_FEATURE_CMO) && !simulate)
 		return -EOPNOTSUPP;
 
+	balloon_devinfo_init(&b_dev_info);
 	cmm_balloon_compaction_init();
 
 	rc = register_oom_notifier(&cmm_oom_nb);
-- 
2.51.0


