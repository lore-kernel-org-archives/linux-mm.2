Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A677BCCD193
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 17:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3CAF8E000C; Sat, 18 Oct 2025 13:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39E78E0002; Sat, 18 Oct 2025 13:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01C58E000C; Sat, 18 Oct 2025 13:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFBD28E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 13:18:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62481119B73
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:07 +0000 (UTC)
X-FDA: 84011893014.16.850845F
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8D3B714000C
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=K1rRTr6o;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760807885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MeSkThIp0BgOUgzAnruASuFbTYnRMFC8HwaL1xWtkt0=;
	b=iUqU9GY9ck1aKjepKK4ZSEMjCH/44skxCEBmuDbnJ2E7XFBt+SRbYhCM9FTNLkarv6J3S3
	qvFomToezPH7kuvASVIqR5ppdXUAgR7qd8LSiTBdWOzMt7B4OE95b4jW6e/Hz0Pn40w9p6
	MxDRUG27avqJ219CnKVVQoEvX1QyTdQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760807885; a=rsa-sha256;
	cv=none;
	b=SDLwO7JDtpzwnIlPO2GPBbthzIbpmx5jRQK0rjTKSWzll2i3le5Yu3fMe+zaLYqsnhVK4a
	CRhRqp1GKVVcsEshFi5YBhzVWfHWd57kWrxvXDe9/gDt6LuNiKRME8YTMjVlMIVZl++p/E
	FQ+JvQNtPIkQojvbLoObLuoINf5yGuw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=K1rRTr6o;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-81efcad9c90so54406316d6.0
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 10:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760807885; x=1761412685; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MeSkThIp0BgOUgzAnruASuFbTYnRMFC8HwaL1xWtkt0=;
        b=K1rRTr6ofsmBrHTUmeIvUq2fjncQUPswprCzX73pFwaPuCS9kdPyUw5K7sEFW774l2
         EhQ5Xhl9OZOFVodD4g4eCj6Kz16Uk+kytdX4qrVxgNMxNcPh+QfpLN3v/u4y+4UHvfDH
         D38MUOKGPrn9l7TPYaK0XG0p/HOaGQjIZuI3GVHqL7xMK8lMYewXH3bfav5BUfMctcBF
         ezij4hBIRXE5b74mktOh76F33CY3ksis10576fHxhNsncK0XpxkrZEMJWuWxRXlTDpLs
         hUw4HiJ0enE8Z56kf8AXaJr5riUNWKv2DGArjlG4duaxftB1u156WNYEjEBzu4dAtH58
         Uglw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760807885; x=1761412685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MeSkThIp0BgOUgzAnruASuFbTYnRMFC8HwaL1xWtkt0=;
        b=CJEUUt0d8o1f9pvL267A1EFcd/rN++w4UUP2vma+n+DKx8TMnlrqCuLTdZw3JAVujm
         aIRAPvAR+yM+bRI/64YESywkq7QuVtsFLeYJFjgTy10LBtTaLDUTQZYGDwnQcyhjI5NO
         cEdXr5jOIElVQYDVXLTKYwtqlJeJ3SHyc+LhDAwbiL6OCykkAH4TyEFOKhuSopl4cfyh
         shDbgjsurGgiNlBFRspCdz56SkWQo207i+HngGKjHaMEQer8/lMp0Vt9wA+laCfoIRH8
         5y6hQu8lJdys2D1Bb90FhfXWtslvLjGRhUAUSTn+VlOT/G42ACu6STJsAgCt/ulbSIAp
         hSxA==
X-Forwarded-Encrypted: i=1; AJvYcCXMVKrRMlaFHWriN2eqxFsqAXv2zOZ15p/kNAv7vtKntK2W+5A/SEIneVxrcRU3MNX7XdQIn3KcvQ==@kvack.org
X-Gm-Message-State: AOJu0YwZqAf+LmIDRV3c/5N7Lf0u7VY1wFpHI8zyq2+Bd/gUb/zJiGfJ
	9c38hWhLeuaB1gPLQ3HeUpB4HZ6wgsv0nlL2fe/RfR8qRg3dK5USHKcFrdZg/PPBM4Q3ByKppJV
	8Pc5l
X-Gm-Gg: ASbGncuO14SLt8bWC3Xx2xJa1Wvzsjgrj50DUz4hqVxcnty6b8aq7KyF2DnsBClrILx
	aEb3f2xMODIJXJOXYKlKG/lxixPXgNSSz9Aeo2AYS/KHGUadjNH9HIs4Y8umbZf8pmyxD8HmDhu
	naa7r63A6/FlCg8pskguk/Zt45omqynaxAf2FYC3odLSvNtOHiMfpFlV+JbzR49Dw9D1WjeDu18
	Tc5qjQSth34KRWn1u6qyi8Qg/SQzl8ytjnSaVO19kZW3tOoKLhaGYXW8yL17kN/Yrxu2X0mUOKR
	gVchwkd/VTvgVoQLBLYt53GnwfpIpxvuyM22AxLyGgHALCQelqN02SSiI1MS3HxGSlPGxqf6f9Q
	lVOLT/5eH/SkeGrJh63qSBAD3YnDBP7Pr4WsU0lzCKqwm498BUUzbgoYnKMU0ra4YhyQODhMk6G
	9PbHWWWORZocyWfTRwCEK2XOeAqFwAr22adU8AJpjaXxcilHNogRg8YIHXOY186UUVZbxRP440R
	UEGMvWpsjqzLE/fnSwIWg==
X-Google-Smtp-Source: AGHT+IFdBNVKA7wbdhBQt+CIgKi8/22s9Ed+9OmPWE+pFu/N1e12A5/0MkyaV4HSpQyJ88+n0QIffQ==
X-Received: by 2002:a05:6214:319a:b0:87c:20b5:6685 with SMTP id 6a1803df08f44-87c20b56795mr116436546d6.55.1760807884708;
        Sat, 18 Oct 2025 10:18:04 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d02d8e909sm18478116d6.62.2025.10.18.10.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 10:18:04 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH v6 05/10] kho: don't unpreserve memory during abort
Date: Sat, 18 Oct 2025 13:17:51 -0400
Message-ID: <20251018171756.1724191-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: ydmmchj7auwmzkfb788suph9wjbydcip
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D3B714000C
X-HE-Tag: 1760807885-360494
X-HE-Meta: U2FsdGVkX1/bjDyH2FoLi4EeIvdHfpE/AYVBqxgCkX/Su5Inm/817tFD1MsPm8suBmvKE93YDW6aYTQbq+DEkFZPy8OfjHuK6tBoe2YAF9o2U1+YzQMhWXcvKyRwaGJfMzQdbmYytMcO3M9tMYLmgF5LD49tIBCKn7ULC9AaW5iNerQhrLTLT/A/hhtxDfRqBgx2tWqIqqFx7OeFsUlint6BOzYqkyLBhV3hUQeTMSs9wyOCLarn+L8WfUOg6jcMCoQAjjkveCTWSZ8+xSg/W1J6Miz9f2vg883Io7mlLZm7lkJlIAsyEdliJyIcZer+CLFO+NgpBdm1tj8/VvSGGVcLdAldyF4TiLheD6AxhjU1Bwv+KXDcsD/N0Zs7lPlXdml8NNPAvwgRVzIp8/nLV0+GtZ8KbErVBt3l4wGh6ZRFHJuMENdcE4zTM4dLbEOcjTNSljVgC6Pq9rLYdSI0ieATBvB67DDt+q1JM5uBipmV/qqgR0QklMlj8zoMVQF9wMausjuRs7aG5TI7DYxH5yYKs1EuAHl6C8pLEGyJP3vwbC0Zz27yyOsizQHKdSzmPDpXQbpWSJskcAVNTntoNaddbDLhroNTam9ceAF6wERG25IBAIBBfFgHfrgP7fXH36kPLWr6pWvcDylL9lzF7dwA/Cgs7advMC8evSwF0MAmEBRSzKDOf2UkvqlPL8GKUda4JCp2HJd0MJjkv0kwRwG+TI9CO0/xmL+6dMOldZ8d9kWKJlD8gJHG8bsT4/9PRPImn+UaBOsG7g6TVLi3ygnhtiAf4dPpVX5y8/V6S/B1tvFuS+N4GxtGizy+EPsP9fMpj1wGl18SUMxCcXlC4xmrU4SyGAfJqJVxTyjosZCZdaO/4QervllWS0Y3u4DCuE13AraNd0gMoIizsJk59t3VlCvY9tCUdbw9rMweXwai1l3D4SAcm8DNffsM+ThSciQTxmTLQKDSd1XrUDN
 FaS3z3Fg
 Uq0+jSXohlSRJEwvn1LtZm1ncl3Iz+otGN3OwkSld7FYHOWkr1IpcUV2McO0a0kKwwg6i714j4aOmfUV+790LlDApTTZIxi2HKGqqcUxSwXTPTnm65+4mMCd8phqjenQGrastIEWOE7dBiJZLDGrvghvhNr7IM1Co0YiNZ34rrUbNWRvT0XmlsPVRDWPLUqOLqihPTM2D+P1yGMAsfjvJaxi+KgPEr4++MqgftCzWhxG5rsruAS+asALECtlnejl4NGxy1qo/sdgPajtQk7LIqH9IS1X0wpWzp3OM1h4wBw3zgUa3yyPNBEsskSDpVX3l7Ln/ysr3WOVw2ZU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KHO allows clients to preserve memory regions at any point before the
KHO state is finalized. The finalization process itself involves KHO
performing its own actions, such as serializing the overall
preserved memory map.

If this finalization process is aborted, the current implementation
destroys KHO's internal memory tracking structures
(`kho_out.ser.track.orders`). This behavior effectively unpreserves
all memory from KHO's perspective, regardless of whether those
preservations were made by clients before the finalization attempt
or by KHO itself during finalization.

This premature unpreservation is incorrect. An abort of the
finalization process should only undo actions taken by KHO as part of
that specific finalization attempt. Individual memory regions
preserved by clients prior to finalization should remain preserved,
as their lifecycle is managed by the clients themselves. These
clients might still need to call kho_unpreserve_folio() or
kho_unpreserve_phys() based on their own logic, even after a KHO
finalization attempt is aborted.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/kexec_handover.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 78acaa218c12..89a8f839346b 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1083,31 +1083,12 @@ EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
 static int __kho_abort(void)
 {
-	int err = 0;
-	unsigned long order;
-	struct kho_mem_phys *physxa;
-
-	xa_for_each(&kho_out.track.orders, order, physxa) {
-		struct kho_mem_phys_bits *bits;
-		unsigned long phys;
-
-		xa_for_each(&physxa->phys_bits, phys, bits)
-			kfree(bits);
-
-		xa_destroy(&physxa->phys_bits);
-		kfree(physxa);
-	}
-	xa_destroy(&kho_out.track.orders);
-
 	if (kho_out.preserved_mem_map) {
 		kho_mem_ser_free(kho_out.preserved_mem_map);
 		kho_out.preserved_mem_map = NULL;
 	}
 
-	if (err)
-		pr_err("Failed to abort KHO finalization: %d\n", err);
-
-	return err;
+	return 0;
 }
 
 int kho_abort(void)
-- 
2.51.0.915.g61a8936c21-goog


