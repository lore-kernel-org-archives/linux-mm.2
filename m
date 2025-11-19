Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E7CACF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 274B36B00B6; Wed, 19 Nov 2025 10:45:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2254A6B00BA; Wed, 19 Nov 2025 10:45:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6ED6B00BB; Wed, 19 Nov 2025 10:45:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC9086B00B6
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0AD716051B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:35 +0000 (UTC)
X-FDA: 84127781430.20.4DC6ACC
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id D2DA7120009
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=gVTv3hYC;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf29.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.45 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=THAjTq9x4zT81mmTnIarOvW/kNy7ppuR0bAFxzz05mc=;
	b=b6+mMIv7CzdyDM4rgYxXJOap8su5GrX+EQjhciax6u8QiRszp9MXKLrX8t9TZvYMvWUbQO
	dd7i4Jp9E/wN3ViCcK83E9abj8Ts+RgKzzSiA4gp6eRzo3Iu/fFvp7eV6sHXy8+tsax7tV
	dYTbSqEBTfLuILSVXNdw0WA0Q1aEyeI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567133; a=rsa-sha256;
	cv=none;
	b=HTlgUaGygN+YMg1Px7siCm/q3vI0hNk77hygwpOHJY/rSnbabxhmqtjt5TsS4FX/izN5An
	0wiCN08XNQn/ff++Rg7yWX7BiDdLtf7Y3wCtIWlsKuPSj+wppq+nlARDcUG9wS9NEr15J/
	gwb9CXY8AB3jVU6Hw+hP7vpPw7txTXE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=gVTv3hYC;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf29.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.45 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42b32a3e78bso5589216f8f.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567132; x=1764171932; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=THAjTq9x4zT81mmTnIarOvW/kNy7ppuR0bAFxzz05mc=;
        b=gVTv3hYClUCkWvLRWVb31MrQHLnRnE+yUEwBbxM/5SOcE4iiVTxaUpWoiNlrRCBfxr
         PS928ncRwkqKnCeBpjokrLSXKy7zmPi0Crgg/5a7aAOdo0OYtKaH5wOSvZAHvEhfQnub
         d6lCdWINqa4DB4oOTVGUl9qW1LL6o5Mi2eiDZ+m666CKeE1iTE/GFDfL0nUHot6aZ73A
         mISr4QSAdiKKQNCErm32Wr23Buj8zDD1PDfwKeAkKFsUuR7y6f/vJgQngIQsIX4dv/Ul
         mmS2PsNeiBLaQoh1i4RU+LAgPURGnx8QnSlAlUH+CrV7rdkEhFqS0ogsFSLP9GfsEvr1
         EXlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567132; x=1764171932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=THAjTq9x4zT81mmTnIarOvW/kNy7ppuR0bAFxzz05mc=;
        b=C1t+xqWOAzHwubHcvL/6cpIXGhvaFqAi5TXwDOLyDfgZkpQWE61xYbF3O1Zds46Y6z
         qM7DH2PNYk+yLABkSONUQKrnAZN2B1rgWF6gQQg8i8a/fzNXK4CpPN5R2pi4YcsAaa2X
         0PH5H7b1p0A7qrWa0kubpvfWictMhdJBSLtP0uUBnkOHcR8dqe7ccF5vinMfHDF8ExL7
         OLzwCMdWiFwDkNFhiaaUJNcBKXfJPqz0ZKToUVD/Ns/cjPBsQLT/hKFHDOFJMcwwY62h
         9RhoEGZ906ZTuNZFFgALd5a//eCIXaHx1StnPoyIehKHBi4Lej6nZM5deKp240UBiuLI
         fNGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQ0e3EehLf3nzhGvL+8D4rcChEjmH0i0p2BAqJ5TVDnsF03qqYRq1fTX68c9qz9XusE7Sm7nwLkA==@kvack.org
X-Gm-Message-State: AOJu0YyvyUc8AHVfPUmZrjWBenFnB0z7Y780mTIR8g6d5BxNugjTyiOT
	ovPjxzqYReEUkWiFK2Dp5ixHFCqqI3Ke0lc2/yAdtt/IhVX9k29j9Zfc1FFCsHFWWII=
X-Gm-Gg: ASbGncuEWMIHNLhwvyvzgCT7RKN4eJ0G1FhNhaeuaGxkx5qMoqWw/XOexjf7LQpNXYQ
	g7Puh1boOtvQJ2N3nBkjijghG6psdlLz6s85LL/V/njevEv2CB+FJb0F6Twsq67efU0lbZJKYyZ
	rfGKWGfNccdyAKVyMO6KTKxJb5216zAvg+z1Cl9+0l4eEeUN9shES2OGJ2hieBQgKYk8iHobqdk
	oofHEUfWB4vACLUKnfC4KP2OCcUO1bhe09KlwzQDsk2bxnPzcBFoaSwKQBGNnQIbYtjT2zKKH+k
	G4K2mkU1F8f9YQPVGWdsT6QPptTQCZrC4UwoU001+XJcoMFPMlWAOR+SK+Cau3jm6TwxKWASfOK
	VtPHH1oOlOEstPafSvwYPp0uf07oxCbMvHJfbwwthzLxiGEOEgt1bQtb9lV5hWVWqUX5oEvrpEx
	SNAl+EiIAw/z8hhZNoGota5jUgXqXhNg==
X-Google-Smtp-Source: AGHT+IFM/SLutYeAmIo2p7oRt8B5TNnuLzBZ4qt+3E18Kli5wgQjVTHlMxDsxZxKW/tnJD9yRmbxGA==
X-Received: by 2002:a05:6000:2a0a:b0:42c:a449:d68c with SMTP id ffacd0b85a97d-42ca449da11mr9102186f8f.30.1763567132399;
        Wed, 19 Nov 2025 07:45:32 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:32 -0800 (PST)
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
Subject: [PATCH 09/26] mm/show_mem: Annotate static information into meminspect
Date: Wed, 19 Nov 2025 17:44:10 +0200
Message-ID: <20251119154427.1033475-10-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 53neb9w6gqcdx59thyphi5om79kktb3n
X-Rspam-User: 
X-Rspamd-Queue-Id: D2DA7120009
X-Rspamd-Server: rspam10
X-HE-Tag: 1763567133-155172
X-HE-Meta: U2FsdGVkX18K4c4wBoeOoW+XZ4Vi+Nt1G+ssL3tv5b1icvzw3lLj/n+IqUYG7QXnxXN20QZ3Uvgr6gYpAPLO+iZasBGVYdXOZR7/QLzaG0psgZ+oc4zJvwU1ykoYR1lS6dHcHHxQy9rhLDz9VZGsSkC552E4JwiFMTjWJxd6e7e+IJeAsJK1tr1aBrkh0iwy3s6tkUhcseb1eGG6sc67RC+ziE52xU+L6+jMbsfwj7VDSS9MOTJZfPDzZDyxfq8MmvC1XC7cBvdkSjGT+ILagk0apAVXmgxaBq/kiCTJt0HFK81jmlWBw091eQYRajzALHg5sKlo4vSQ4ML2ELWDJWhVF4mbfXfeIgiiED2ULYbqzmMdJGBLDU3NoJolh/Siw+ZWZE9LBUFyOYzGjdA4NN6pSyDB8Uq65pAeMgVFbQTwOWKQJ0PY7hI0hnV3CrkRp9/h9DXoczUp+f4Y+oyK0hlXGjWK+XHAYqhjuky6GigzrzgkXln3VV9tlcPVBkENYqEW/0ipfu1lhu0Ga1wR7Go/qzG1g9HYp+dFWKXdqirUF/gbyyITaAm0BVzgDjoRkgg3FjAyTC2G5G1N9D5EcczIG1vGYiqckU5CalKv1T0YY9+sDFUnn4kO3eZ3R3eyHK4k0euaISw94jpyX46MLvNpnghWFk4NXJIq82K5hKmF7cracFDGrJ/A/3o4/R5Wr3bWcp/L5LKYeeLpE74P9WXZMn35k949p4l0gFUOjPc8t2Zj3AvnNIeMr1rS42r8+pHdNYQaKnSwafu0K34m9Rr8V8f0zpMjADevAMjhRbpnZ/2qzl1eBBqWUk5C29PJsW7/tZtug6rMWo/OVmRj1Yvc8LLaZRfXMPLR3r49/l6t28FqSrUhsjFRRT6mS4OgRfDTvXCmCqmtmejJfFm7x0ET8NVdq9oUHqbuql7WjngFveli9A38cozssu9ULE9glCFHnjDQ9rm6qM2douy
 eiJzwZuU
 w44iBH26Ye7ej1xFzyp/fPaXmyQpBHpl9oeho1ITr7KkZWhIIEH8jcjH50xZSpn/BNsztPoWh3J6Z+M/ZY474IXNyG/sjNIcBC6SOf+TC5yY9aXG3Q82zfSVPcBMiUR2tFRDj8qCCaWjHmNfrQu7/K3qxRj16Gpm7yQ3da7SqZoCAy+Yo3q32dUBGYXh7TKSUz43xjmqTN1lJKuImSHcQLBCljj79fLY8uPQFzZFIDE90VhbCKOXUcyoTeWLKVP0pANaoJaI85rafJwtkHwTk01oronBXa0Gb5lXE7+1KLhhOBBzDWEICN5CT2yIGTu+pFKHv3od6HJ8bTiVdX4MbOKP2E1pXxLOoODsvOChQHuekjPXWV6v4mP5NOV570ISe02e2q1XrLJuDZ4Kyr/wyUPUQW2ZBONcn99yMFPa7HawiFIwlJTjnYQ9ObCgVK/wMerG+99QIx6Kd70iocB2LE29eiHZXog1m2i7Su/SMRLEE0jQymGEDfi6xRRrE1QzENALGiPPYxQTF/4UkHiv3bT3VkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into inspection table:
 - _totalram_pages

Information on these variables is stored into dedicated inspection section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/show_mem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index 3a4b5207635d..be9cded4acdb 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -14,12 +14,14 @@
 #include <linux/mmzone.h>
 #include <linux/swap.h>
 #include <linux/vmstat.h>
+#include <linux/meminspect.h>
 
 #include "internal.h"
 #include "swap.h"
 
 atomic_long_t _totalram_pages __read_mostly;
 EXPORT_SYMBOL(_totalram_pages);
+MEMINSPECT_SIMPLE_ENTRY(_totalram_pages);
 unsigned long totalreserve_pages __read_mostly;
 unsigned long totalcma_pages __read_mostly;
 
-- 
2.43.0


