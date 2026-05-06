Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 292D3CD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 18:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2202B6B008A; Wed,  6 May 2026 14:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F82B6B008C; Wed,  6 May 2026 14:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16976B0092; Wed,  6 May 2026 14:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6FE06B008A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:20:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9771B40135
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:20:54 +0000 (UTC)
X-FDA: 84737811228.19.92C0BA5
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id AF6B440006
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:20:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZgZLYDse;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778091652; a=rsa-sha256;
	cv=none;
	b=mxhck/hzEL26BdlZFaH7LnnoF32R7bnWaaaonnUpn+AhhBEWU7kb/8A6FTwhVE4yaVDpQv
	8XzvVYZ2xH+33Cmn1xa7stTsPfGmuzr1L54LvH8Pb9H98cKIWt/cJOBI1HiTi9SvTI/q5T
	nBIjQWeHZY+KQqs6qbaf9VhYlXT3JAQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZgZLYDse;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778091652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXruPKT22GcZoZBEWo9YHDYe3HaziWhcMG5AGyP1PVk=;
	b=J0gWT+KqVcLDEuKKSvSSko6sAbGGjA/du1oCAzWQCZYUh4JzYMPlCPVOSVMgx0eDDom3JW
	gtj87O4X2qHBacFGAWbHkNdAucNY556o15E350sSeY6UglNdN1NWFWAZ7hcIHtif7sFnLH
	agXXPd8XTcVw4D5oOwr4y0+NuU7mM94=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-651c5d525f6so6644417d50.3
        for <linux-mm@kvack.org>; Wed, 06 May 2026 11:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778091652; x=1778696452; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WXruPKT22GcZoZBEWo9YHDYe3HaziWhcMG5AGyP1PVk=;
        b=ZgZLYDseBQLBMNSBwvSk+WaENi50GSvHHhKRn1upiOxbF70T0NXjhUkifzcYLaz57n
         QVk1Yj/2hYMI1znsOLQMBj8P4nRFTHwVsoW2eQAUC01uGuMGSi+FoXVc4ELUY+MLMYAF
         hDRy+sQYYuZ5un32elWkCJN9JZVNGEFhYARvmWGWoYCdkG0/9kPApmTJeLWsR7jc6ln0
         DV+wbNGvVokpfB1TYNDLNvEK4xXidvBIv0/ao3ipQtaZaa3hLGriivFsxEZ2cRVUanEC
         ABqNjSAG5CxOnXK4yVDBvPXKxW6gXoHrVT7xJ3ccr88GfdjmnIZvNyaXA/g/BvRHxjLz
         /dag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778091652; x=1778696452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WXruPKT22GcZoZBEWo9YHDYe3HaziWhcMG5AGyP1PVk=;
        b=sRPrBZei3oCLpZx+9iVzky43XLzSMDfbgnlGQmkq/Ybem06yFO1aSrIH8Zo0g8F+wd
         /nNTrlREJJGqsNmp95ptVzC5OFzzW5gXIcBNLGSsC+tkeyYDQGWVowG7abyiFL3qPEED
         0w23p99/zvpWvdIHVguu+lnTG6jQBqz3Mi0AyhmRn1zV0GGzxkJv4JpTQGIp3ByR8f1k
         CrNbyNL1IPU6N/Wx0Gh1WegRTsGZl+s8/GqqNLy1Z3S7KpY8PG0pYlZ//hIuQPGOryQg
         5O84ExM9J2Ed6Ft+0PgBoYbwdJVII50CZWLBNIltD73It1zz2ztmn0mpnLtMuQXjIbnG
         bm8w==
X-Forwarded-Encrypted: i=1; AFNElJ+jEmtfkODqhpj4PrrUwzEIbAOTUvHCsJXRz3ZO72zPdFelbxKqR0BsxSzGeCqyKizD2VKaQxbOIQ==@kvack.org
X-Gm-Message-State: AOJu0YxN5jBu66aVtZZpvu/EbD9WvVcxpmqV1kiCSQ/e5p8hJMXDxY+V
	ahsEgMLLmMJqtXQJ2408wmgfVw3F5+OSIjsJMVpb3gPU//OE+5wppK+XDh4AMEQiK3E=
X-Gm-Gg: AeBDies6yOyJJHrPj1CJWEb32Y2zwKdJh5S7UL8PnnZJ5EsBRbYWn7+1SVVqJn+aIOo
	nw1dYlqQot0dpYry8Mrmkr61TPvrelGzgsik4NTvGXHC7lkXJuUJqrQqy3Avug9w8y1OxiJFIhg
	xP7W3Qb8+ZsYn77EGD40d9dfiP0F17KQszSr4qUzXp0RxdyEX3SNUzCg/SlARASJeO4Xay8gc2t
	2uRhf5xVwW6MVFx33gSmi9iYdrz/m3EFORGE0ppheRbfKtnAGcMs41Np+1ZEfKHQGJjzKmutAUo
	gsmKNpON73cGC7qLMQS/GwK4Eyu14e72nCGC26rkvJrpRkysapLsoMzXqL2mr36BrLdX7wtZzLL
	WqQJwpv+30n0t/PbSd5bnC1pYbY/OFBdcTNW9Rqxa65N8QSi0todfZtX3KETdgsNVZ20CmR/LnC
	q+7l33xfGa5HyUgsmLvp/W/WbcnGd5HaxncOFt0/eKYmRwfbBgyvYDH17Yax9NIN3jbGvM6x3+/
	zOG/lpHMB+mlhuZ8/S1h2CI4n8rZGA+6dk1nAUmtzi5ZtSzHeJVonjL+L03
X-Received: by 2002:a05:690e:1408:b0:65c:468:7b6f with SMTP id 956f58d0204a3-65c79cc750amr4971855d50.25.1778091651551;
        Wed, 06 May 2026 11:20:51 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65c7af9f8e7sm1389917d50.13.2026.05.06.11.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 11:20:51 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	sourabhjain@linux.ibm.com,
	jbouron@amazon.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	bhe@redhat.com,
	linux-kernel@vger.kernel.org,
	dan.carpenter@linaro.org,
	pasha.tatashin@soleen.com,
	rafael.j.wysocki@intel.com,
	piliu@redhat.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com,
	changyuanl@google.com,
	mario.limonciello@amd.com
Subject: [PATCH v2 1/3] kho: skip KHO data for context-preserving kexec
Date: Wed,  6 May 2026 14:20:41 -0400
Message-ID: <20260506182039.2623553-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260506182039.2623553-5-pasha.tatashin@soleen.com>
References: <20260506182039.2623553-5-pasha.tatashin@soleen.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1169; i=pasha.tatashin@soleen.com;
 h=from:subject; bh=r96qoJEtxIi6x6BSFWD6mxFRZtdbqcya9kKoQBtHdO8=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBp+4Z5Tck3diRefZlq1FRnNTXoLp2lad+1ZHT3t
 t9owY4Y1YSJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCafuGeQAKCRC7dyhM23N6
 3iGqD/9IpRjWwY21ghxceNus2gj+Qh4gN4GTyj9FXrFqEmDf1sRQDWgRDX9x9qYdMIbwCE3Am13
 z5xxwWcofya6hV88JipQVuFuQneRFXnpB1YDJv1LNCtHng2Mq0Vg6RFOWgAQr3cn/ns0UcbMoqp
 3h6HidKEwWa2+aIXee1PEQxeSQngYi32xbl1nA4HP2kyNW0696f13sImu6TV+KgeynuuTLxQuRO
 r+AeCUrLqi9yQoCW2+hDYOpVbckwDWpQ9aU+f5JMSVmTNGaxQ4MlSPdu7dluK/sZ7TXHEdlhmC1
 AkfNABwGlJZsLDt+RKr/XLjg4qnSSG2+bYNApI0KFZTsQQdD02KU8Bal6DvyqzD++q/AFHWjClG
 +ca8YvfT9V2bubrk0a/7QVnMOqy+S5Myczv2SE0/mkxBJmoWKDeXv/ondj/RQtSRIxeyIB7Sskm
 59k8x+nOoQEaDeBseXyC7KWfoHLNiLA/BTyj3VSeRLyXqoc6AYKwi00rMU745uAe0+PB1Nnzjqq
 klZSWk4m82q2vY3dXk1IGmuIE6QSmx9RbT7kMgnaI6MTsFC3vx1AJttSXjbZGNgqqm4ag10vnoy
 hZh32dsvRXwJ/O5yeRZ/VEgNPJaiIXpjNljyWKa1zPVroFsHvdGtq6Zd/4eVPdQ2wRiqC1g5iSi lYj8ob7Y4oMrD3w==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp; fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jgjuasp69b9xu36ueomn6xf1d7se9q5d
X-Rspam-User: 
X-Rspamd-Queue-Id: AF6B440006
X-Rspamd-Server: rspam07
X-HE-Tag: 1778091652-38209
X-HE-Meta: U2FsdGVkX1+t3P/z3SWQ8r+zS4+qagjoZBhp6eczxg8rjEc5+UuWzxT2A3lRlEOOH5IEiDxzvMyjUJO4F1vlLoOd2HjgdJleP39A6keLzEm/jJAURBlLcQDz1PD09j2Jo3o3QCYWeH7K53u8pVl0+Ed4u3mdQKYtnPo9YkcyK+D7qW23tSlucuzYgDKZ2KOM4BnhVeUFRPIbJr6WwVDDY7jkKBAJjDv4dRUVievot5JK/YE2CMPdSrN7koF81zLqJMjjOln5sjDOi73FMiF+DmphgUv1ZBa6THFdqGUtSO1koJn4pEdEtWhkTiEQQ2zQQwTsM9ksM3WSMmhMFiI/95m8H33p7IMfYO7aUlih70HgVsO15V5e7Z0RLtfKEw4tulNWxsyS+9nHlin1kdVeGOI2THfJ/5XvVjaWkMonjXsmfEtNyX7iZpzIbfk+AABnq29AcmmAeiGls/slyDI0VdA9rJxEA5RgS5CpEX+IcMAykwgRWazFRHjkzGUouiekehzgV8srz0Hgn5PrUOadRwkzqxB+vTb0nfakr8JYwhEMKhlHIu1hn3D+UpIWAv6hAbXx95x9WNfQFPGlMq6Q5D8BZt+pJwv7/pezpoRhO4UyNCborMMChXYnEksvDqrse08H39wmtNBRfxaQmUSJ+haudQE9JJXQtJOSG6VXfi55egbmno8M4B0/BaiK2+UuEoiJVUuN41SN51AKLRSum8T2ZOcnSnA1HUDOBe7Ls/Zjee036One1psUMY8tPKWOogG29lAM7ee3/LlNtFDKp7gzSNKjplRXR6CNpmQyIqjkpSokuLQaZAcfup+cqFCwX/lSeJCmoO66b+svW0VvZPV5mEZbmFT0NhUMnayamNgrB9tg5myrrJkCa85gRFiAgMJECqcYEW3KM58SSsr4/PEFoOvYIf2nML96G+YXNoWpqDyhezFB6v0wgHT5tX+4TSOy3EvvCtoXBhLvwF7
 c0q8r8wr
 mlT4Js1yxBJ0tKb1UzBbGOvxHANImkGWu7SZBa5ZrNLMQhvNLCpQWp2VhOEEsfLCEttFTALvqixiEH7lz9+ah4vPGk84dBvM5HiEqWOl6ALGhGgTg99wKfFLR1H0521mkdPCo3XN315nbwAtwNCDDPmciBLaj2gYGV5AEuINSDKsajYnPMRUZdlFm2l4Y6r2CzRXiNLnV4sdcxoTtWzs2npHtlkyfBo29DaSWhSrwYuIW/tolPp54EBGdjz0QINHZ4uOt2wElSqVp9q450UdWD0oz1j4calHKLU6n9/JsIaXZNcWHMVNXuKSsDO0raasiG+rGRhqalT6SdHE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A preserve_context kexec returns to the current kernel, which means the
2nd kernel does not use KHO data (and their memory spaces don't
overlap). Passing KHO data to the 2nd kernel via setup_data or
devicetree is unnecessary.

Add a check in kho_fill_kimage() and return early if preserve_context is
set, to avoid passing KHO state during context-preserving kexecs.

Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4fde8325c49f..2eec2a169c83 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1702,7 +1702,8 @@ int kho_fill_kimage(struct kimage *image)
 	int err = 0;
 	struct kexec_buf scratch;
 
-	if (!kho_enable || image->type == KEXEC_TYPE_CRASH)
+	if (!kho_enable || image->type == KEXEC_TYPE_CRASH ||
+	    image->preserve_context)
 		return 0;
 
 	image->kho.fdt = virt_to_phys(kho_out.fdt);
-- 
2.54.0.545.g6539524ca2-goog


