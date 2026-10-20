Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B9FB606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 12:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bdJq9qel
Received: by kanga.kvack.org (Postfix)
	id 96C006B04B2; Tue, 20 Oct 2026 08:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91B946B04B4; Tue, 20 Oct 2026 08:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A4F6B04B5; Tue, 20 Oct 2026 08:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 510866B04B2
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:30:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D720E8014C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:30:55 +0000 (UTC)
X-FDA: 85342938870.20.9722787
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id 181CB40008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:30:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bdJq9qel;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of hwenwur@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=hwenwur@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792499454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=r7W1rJt9IDsmCTMPs7E6cwvO7KQhC7QspT2DHRypph4=;
	b=18ZrXrwEfj9h2+0+mboE25Pgo2ErpV9l2pMaFVfBWVChWf6PT7GZTJ1PKeMdfhtEIxrdzr
	EUFxclC/73KLs6OeBJG850wcNyb8aLnq9uGbbI0pOe9+yCC7f1yXO2RbXu1OGpMt7EEBBz
	3L8Ny5qiJQPXxf/orFRsfYNa1sNPRas=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bdJq9qel;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of hwenwur@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=hwenwur@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792499454;
	b=SLKZEsjGjgaiM72ccDFx00heE0knj0r0m/0wGe577VnYRu/cBqo7g4lgmON1Mgr4q8Qmw3
	gMSD70y8PW4IeHmJg01zzZvddyUch23flBhpjHj1xlCK3J0snIGC3MFqVp5Qjdf5qYf7DY
	07RUrdNf61Dkx93bGq1TaCnCU67llms=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ac7a053626so643609a91.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792499453; x=1793104253; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=r7W1rJt9IDsmCTMPs7E6cwvO7KQhC7QspT2DHRypph4=;
        b=bdJq9qelaOoxZ+oZ+IGUDX8edc2a5sPA6rkIyjeV9cni5qhwLxxT8i0riaHxRIq6Ou
         phWxw2xjsJj4mWPT/XZQZTyNv9Lic8vxB12n6+zC+Wnt5aoDv4BABC1exxyxi6p7qUkD
         LCzewnVmMTfzapngBhHriwgY0INmcwcchO5Tmm6Wtm5W6vSZk57PparCfucL4vuETCPW
         QV2yKyLvA2hlCpVUvGM3A82LkI+ou61UwDCya/4IiOT2HpEnSHypaUZfDkyD/K1+bEpC
         TIvwGHH/0JX491XQyk0Y1cdl4d5yLXRJcxM6c3wSLvZlVP3PG+km8n+uYIQYHxFWKdKI
         MlZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792499453; x=1793104253;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r7W1rJt9IDsmCTMPs7E6cwvO7KQhC7QspT2DHRypph4=;
        b=z+s9CJBQDrf22v4YCp7dLN7iSkg9HcC3RW1u5aTwHENmtD4yGvB0VMjyIGQ3LdugeK
         JqNy0AHRGBniMsUnyU12aDd1i15dUCWye4arS00S/s2t+RhXBghl1M+ssebRA4fP4LEP
         GIwjZGjMEFBn3dNUZACzImI/y9VhrqZwwZTJc2Tqbr+OtCtMc8209Lzu2lr9rspY5/rY
         MEA/IIBPj/gO569YivVXxeIOA7ifibUnK1Du/gporI2ChzSWYLITDw4it8jGTybbLhwU
         Rv6ahHjFF4A8aXh3u0OWBbdyPUVKp1vGVeI6BTpb0Dl8zAdRRObBR++SbIb0ZbnAR2Td
         ZAEw==
X-Forwarded-Encrypted: i=1; AKwUvByOmexDFNYXqoZ6NAA16MxTQAYMtJzpT4pLXBqzjfvhIWwxJ5BsCxHIiT22my/N0F4X91+cICCyYA==@kvack.org
X-Gm-Message-State: AFq9FYKxndn8lhi0NPYBjTh/VK3O+Xhqlae5Uid6Jz88otb60R/ALZuP
	K8WCKz5d3XitlTHhkPgwHu1QH+oNtY+9+4AT0HZhZP6tq7TEbeU0N4iEFPPtKgUmFcA=
X-Gm-Gg: AYBFou1vlCAys8s9ns6trDidCf3rJPHXj+0MiRzU/sKlXWEFqM55T8iZt89Pd49Woef
	jvkccH6rMG3TgDIWoq9c6wRcaAH6gLj34DDlNN317XDNaD6sIVLLC9+PGtZmVcZInbTII4MnF9t
	WO9fAURKdl2ozChITON9vGx03VplXis0vqDjdPm7QDYCiy8C/5zaO3JW8mcYqpKBk+tC0OqjG/2
	w95gf/Lts342nPhGx4vC1jEy09yb2UCgHqt162XqZDRntAJ0N3DcaUlQFw9qm0XK55oZtzqk3EV
	l367cRrME7RTc2cBZPqTOFACREdBq/n/SDAXjUq1KwFUBZkpGaQQW06uUQsBPb2+6B1QzsutjLi
	kUhEd7TeIoYCLXBeai7nMnPth6TQhroRPa9cT5ow7CNdNIUqyP7v5kVudzxQfSMOx1v4L4sJhg0
	hrwy70A6ll1UIg2OleBqPhlgmL/3eceCdSZWnxLbp69wYCl4FasXTyiqwexpxo7WPAAo+ogaLwV
	wNFtN4UXJL8QafmvXiRMgC47MFlbXS1T8ttlEYCfFgXgoyVO31moVuELDq6R5HH7l7m5AfaJFZL
	VjPWhQ==
X-Received: by 2002:a17:90b:5111:b0:3ac:a7ee:6785 with SMTP id 98e67ed59e1d1-3acee29305emr15938113a91.1.1792499452686;
        Tue, 20 Oct 2026 05:30:52 -0700 (PDT)
Received: from mi-ThinkCentre-M760t.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd65497e28esm4783715a12.7.2026.10.20.05.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 05:30:46 -0700 (PDT)
From: Wenwu Hou <hwenwur@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com
Cc: chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wenwu Hou <hwenwur@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm: zswap: set zswap_ever_enabled when enabling zswap at runtime
Date: Tue, 20 Oct 2026 20:29:42 +0800
Message-ID: <20261020122942.3477541-1-hwenwur@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 181CB40008
X-Rspam-User: 
X-Stat-Signature: spioa8y5nm8e74oqecaep875hewbijd6
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792499453-666043
X-HE-Meta: U2FsdGVkX1/y+dAqxmvgVV1v2YyB6FKOvXnOr8XmTiPLE7MTtPy+wNT2OW8M2uu3RXK6+oqpYZiQmfkHXNLAlkio5uVewzqdLtFZ/KTTspJ/UO/99D0dYhOXz7JH3cGhjSCCw6h0rAKj2NvVU9WC5IpmgvbTb7dqfZjrfuBZO8mKOLGvk00b7WQahPPZLtxmhjP1waCye/2ee1lFTrJrkBp6LBZc9CCK5Nuxkc2/CgssQPAxl0JpTH5Vh8jdRczFZW8l8eKupnou8PKkVYSvzrYeZr1MTVDWOIvvZgmHhGnf7Oh6y40xBSgz5JSv7lgNuomXKXT3OH3r37l4XFRLkcA/1IwTkF8ZgBxa43x37g0tI+tVpf495TPMEeEnx4PXCCsA++xZAeL6Tk9IGl12YjXtJkx5+eLpWbAN9NuXd+QgVEYIfjoZhRYxAMVuIwH+Uu+bt2hIef+Yc0l6ZVszHy3O/3+JmiNRUoWyBLACICOvgPsf9W4tCVIpyy08FTbZ0+CBp7Y3qvwTSTSEnEpfjpwj0ajDRnOl661vz06Hvl/4lth4fN/h7juCNS1E3x1v4UPHkxkaqUJE3OWt7UkMWYDp+DSbTIVIaOLiK82YHHqspUylVyGDVfOlJJm+OHppRErBLAtVd9rutAa698KjqgTsc2jSVGOARMCsq9TCDSMIiXjymXHGD3Jhxbx583XrU7Q0uu1oB7tk1P8gmJdxfK8BrhLLQUlAaDPQ/HJen8GXGpTm1+lx+U7wIfMbagK/KChho8Ht3cvNoS0raea03TP/O+gL4j9XfeGSzxbjmCoHnBAFFBOQUGWNqjWrgh+jrdks58aHydfwax2vKsENgtwlrRgikISD58Mq9WeqjJPuqEzxQIPNSK85odi8CVgqQLdPuhCXsm00z/SR7K1I325uRWswDNV/yKS26qIqJYeOQjPrz/ryw6afQf+JyZHiKHcd8doG91+C+jnFNsx
 34KetfBj
 FvewwE0XIXRX5G5rAwRyUzy036shwPh6TK5ca8hRJs2eNijnv6+T7mskCAZY8DOm3no/U4sOyi5ol1JTUg2/x+l5RPgBpUyhxzVM5lZI5EleGXREh8GEADMcraRYPWU22EHPNrhF20ajqLVsHFzcteEQinIgETZ50/i/VY2ytzz8e3SnpADnmS9DfGu1Z5pbUrVIjMkUNTbB5pGfbljsBrcl6CAPUjGY1pl6l+GQ4GOnWi1NV472JvPr4lRPUm+TLmgSNDuMZJL+a0hgqAYzadvKtIbgfwNW3AC9kXspBHIXcz4FZY6SQoX5kz5D5BGcer7em96fQLaJTD8AgE1AooXqAoVy02uT52SDRCZlFukI4/Nej82a3gcxEr8iMxYXbsazEfS26S1dTLCOwGWxbbIekQ8sic2Ab6WGTLEsYdnOmARPfU5ujzXPUzAKP4S3MC7g09AqPA9W+MklReuSbmOMooqbRUn/2l4Qg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zswap can end up enabled without zswap_ever_enabled being set, which
leads to data corruption. With CONFIG_ZSWAP_DEFAULT_ON=n:

1. zswap_setup() fails to create the initial pool. Setup still counts
   as successful, but zswap_has_pool stays false.
2. The user writes a compressor name to
   /sys/module/zswap/parameters/compressor.
   zswap_compressor_param_set() creates a pool and sets
   zswap_has_pool = true, but never enables the zswap_ever_enabled
   static key.
3. The user runs "echo Y > /sys/module/zswap/parameters/enabled".
4. zswap_store() now stores pages in zswap, and swap_writeout() skips
   writing them to the swap device.
5. On swap-in, zswap_load() first checks zswap_never_enabled(). It
   returns true, so zswap_load() reports that the page is not in zswap.
   The page is then read from the swap device, which holds stale data.

Fix this by enabling zswap_ever_enabled in zswap_enabled_param_set()
before zswap_enabled becomes true.

Fixes: 2d4d2b1cfb85 ("mm: zswap: add zswap_never_enabled()")
Cc: stable@vger.kernel.org
Signed-off-by: Wenwu Hou <hwenwur@gmail.com>
---
 mm/zswap.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e3..d2b4c248baa67 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -629,12 +629,29 @@ static int zswap_enabled_param_set(const char *val,
 		if (zswap_setup())
 			break;
 		fallthrough;
-	case ZSWAP_INIT_SUCCEED:
-		if (!zswap_has_pool)
+	case ZSWAP_INIT_SUCCEED: {
+		bool enable;
+
+		if (!zswap_has_pool) {
 			pr_err("can't enable, no pool configured\n");
-		else
-			ret = param_set_bool(val, kp);
+			break;
+		}
+
+		/*
+		 * The initial pool may have been created later by the
+		 * compressor param rather than by zswap_setup(), in which
+		 * case zswap_ever_enabled is still off. Flip it before
+		 * zswap_enabled becomes visible to zswap_store(), otherwise
+		 * zswap_load() would skip stored entries and read stale data
+		 * from the backing swap device. param_set_bool() treats a
+		 * NULL value as true.
+		 */
+		if (!val || (!kstrtobool(val, &enable) && enable))
+			static_branch_enable(&zswap_ever_enabled);
+
+		ret = param_set_bool(val, kp);
 		break;
+	}
 	case ZSWAP_INIT_FAILED:
 		pr_err("can't enable, initialization failed\n");
 	}
-- 
2.43.0


