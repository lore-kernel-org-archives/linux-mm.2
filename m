Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060E5CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 21:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FA928E0215; Fri, 15 Aug 2025 17:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D2178E020B; Fri, 15 Aug 2025 17:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50EE98E0215; Fri, 15 Aug 2025 17:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF458E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:59:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ABF49584C7
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:59:24 +0000 (UTC)
X-FDA: 83780358648.27.6ECEE2D
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3B0FC0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:59:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yLaVzIhm;
	spf=pass (imf28.hostedemail.com: domain of 3ua2faA0KCN4AXELRASMUSSENGOOGLE.COMLINUX-MMKVACK.ORG@flex--axelrasmussen.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3ua2faA0KCN4AXELRASMUSSENGOOGLE.COMLINUX-MMKVACK.ORG@flex--axelrasmussen.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755295163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DeW1hinUZFH5xo0Pcsfyi8Qr/5QxONJwH9+uEctWdNE=;
	b=0YfJuergWcxaBB2Pu5/PnxZ0uqGQbLsfIl0ysVP27kXxxv/LciM2aN62KX5Y6/e+UMJL7n
	xmqVALhEsRRVpwbmdLa/pW46EWZviseptYtbrul7EQHsEflG9+I1jK6ilM92VLPNAM4GUK
	fHQO+76rPhtnSDMSgoum0W9RgWpmHaI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yLaVzIhm;
	spf=pass (imf28.hostedemail.com: domain of 3ua2faA0KCN4AXELRASMUSSENGOOGLE.COMLINUX-MMKVACK.ORG@flex--axelrasmussen.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3ua2faA0KCN4AXELRASMUSSENGOOGLE.COMLINUX-MMKVACK.ORG@flex--axelrasmussen.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755295163; a=rsa-sha256;
	cv=none;
	b=IKKIV1URm8RwMVoi8aSMazJrPsYQW08mQqD34+XAe06NIESLBDYDDXoOeIPyeYcewExa0G
	QsSMWlaXl5pIuUTF+rm3G18+H6vdPhkD0JLfJV7QAvqJTf+kQP3B5peBxNVtAXpwGrWrTZ
	KHSpwgx793NoPBputfgNZb41F3LizSw=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-323266d8396so2249153a91.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 14:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755295162; x=1755899962; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DeW1hinUZFH5xo0Pcsfyi8Qr/5QxONJwH9+uEctWdNE=;
        b=yLaVzIhmuOTYOeNxe27yg3ecEcqf+wTofs2nIox9q/oST0kY4xKOtiBrzlCtBg3diL
         rWiriq3coRgqo7YcE7XynHeHfh8E9k2iMMJjG661u1F7dPR7oaLqMfskRr97s1N7Ra3B
         ZM0Hx9W31cRYl1pge/BBBm7ryHZ6tao9/1ov3nOrfcjpopXHUCaTYNeF3QbzaOaaSxkA
         mEjEO4SJBvcx3rnIDwstvcjn3ZyYPvTMtW5TR0bVRxb1HrVg0odzi5oDw/7vMc67omnr
         MJ6uRtXPYooFKnLgGaIaNYwEEJ4a7uaHJvSun6XntKwTvjivLgsVat44zIktG/M3YWB5
         USOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755295162; x=1755899962;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DeW1hinUZFH5xo0Pcsfyi8Qr/5QxONJwH9+uEctWdNE=;
        b=XltqbmZXTs1zJbn37ndXtHbbFVbvJobf7MZJH0dSVh6m91kwS98abQb6ESj/DY2pP6
         wOm4ZvSpYNgqUCKNTEyKJ2Lj/OE7Qj9Wk8rlfXbzWZPvD6BGdc4ockvXiDXUVaxqL8+K
         wVBbJiroGBRlLnvsvwLIAzERX0tOifqQnQ6BYPgyqVVBrUk052J4LGn22PJOkEU/vEZ+
         HdjW9ccneSzFHLYGZ7+LnhrN/yIjlgPg5gIsRl26Hv6PM272UWFDbCZXlapuTZyipLvc
         9WlshmICZm3O7cPdJUwBHtLJP1wUN9M7MauEcaS28tavjjy1q3gtHOY7moY4Xc8xcVnK
         2yDg==
X-Gm-Message-State: AOJu0YzSdI/KXgiPlcYw0ygUDCH6jM6Z4xcWJUOw+popNC7VdyxdrRQw
	CUXtmSgqg25ty+RGyGpTG7WRJPlv+VuNwh3Vjdvy11cT+gxtTqhOCSVEsFLIrAtGex6k00jKHJV
	bi2kKg6XK9E+SUF3AspMPINHsDluAeOYpzg==
X-Google-Smtp-Source: AGHT+IF7W4Ic4QzDVW1k6cnS1X7CAqCEfRJLNt6vJbRlq09rPQM7OjZfHM6WC0Rg3oYE7E9w+5p83hp6sRXF9TOTaF4m
X-Received: from pjbli10.prod.google.com ([2002:a17:90b:48ca:b0:321:cc91:ad5d])
 (user=axelrasmussen job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2808:b0:311:c5d9:2c70 with SMTP id 98e67ed59e1d1-32341ee3103mr5225173a91.15.1755295161789;
 Fri, 15 Aug 2025 14:59:21 -0700 (PDT)
Date: Fri, 15 Aug 2025 14:59:14 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815215914.3671925-1-axelrasmussen@google.com>
Subject: [PATCH] MAINTAINERS: mark MGLRU as maintained
From: Axel Rasmussen <axelrasmussen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: F3B0FC0008
X-Rspam-User: 
X-Stat-Signature: wc1d1cimjr33zr3h8xjqgcegttj1ywws
X-Rspamd-Server: rspam09
X-HE-Tag: 1755295162-215813
X-HE-Meta: U2FsdGVkX1/D/HFctDYmoS4bbpJaBo+HyWLm3DLK/MCUpIBfK6H6y3Tp8x7EkH2Uwgs6a1cm6pz4OkigWOIAfzmWo3blVxPwcPOx4pY2NtjiljMikLuD9/Uy5p6V8k4ujN186rMNqmrxgGaKYJhiFVRqyo4l0l8nzP935SBeb1zyuZOHaspNVFUY02q9MD8P7x51lR0z6FoUtLUJrnAK2VDynGxnBHqtXohW6Sp8Q63RXzbOutcuJHSUQw2rYvcIfW/wLRn4VDu2/ZgUELGlgURaLa+zd3eOhEc1pbigDVgl5z8AgmBDVBKV1G80+roBE6IRxzeEoWISk5+flDg7lD8WXUI/piLIsZCkmEhtx4d9oLOr8Sk8JK52/soh4bP0pgTxSL9oXUUnOHNZWze8UN8us5kPoaqr/ALdTwbHXT6SZBs92biMxZoT5G6lbKWEScUzCG31aaM2U8sC4uRask/U8uSeFWlNPgHCk7Zxu3Ok0k4dBEYOroIvLH41dE6tgaRLx/+XkCh6q/ZyvaqmW2gFbwZu4vvvMI/7Dw3vaqd1/yVetZECIqmLX+MYu4vEH6TPbHDqJm8VdhBIDid/gggmFoLC/84tePM5AJme1/BtgzetBSNLAcq5NQ8x5GZRmFxHKct3nYmmAxTHUUb6f4nYKOeHKAAkJAlOQsw6EBr2KGOfNlW4fZKtd75lelJycbdTj/3g+Mmu+5oHGeUmNWAmg23OJucEZlOWYNXDivUCSqSASsqmU63+OFnfqj0hjxj2pKpYRC6wrqgAYRxGdWYF7VWf+ezJSEmBHSAm8dBFGXAai2FhW58KZ7SJKtSqIHbAehSuAIJRd1kGlWS65tky8NJFzT69phNbkvstSgCp9Fn6CZ42daQyk4FUugeAN0XovpjARQhPPhtGuo6xqaYHOgcxpC/ZrBzW5+Zn4OV0aIa1fEWOoUdqx/64mnMTBPO2pufEwS0zQjAM1vc
 PMeEzBG/
 JOkuyh7ksuB2/Y3fPCVQgKx12Y9Sw2xscL1DCOWD/7+qYr3mEqjXHJAjQ5j3HYpWSTtbz/y/mQThg1DUqSEsPcWYnS9EaH6kyRTWLGnkYVYseOUHLlWqpN8qHoRBu+pFdSb3NLkDXug7sHsq+niVWhLEqEQj7E9WekSP2s7DV62v9mVFEewzaqOZQ3D/nwBFszTVCk8hKw9MF1PRDYoZdWipL+G6jws6w8dz9MGZjO9LYvIeppyCjBODvNhsjJhozYECdjsFu2pqqqDuKGqpgZWU0oaiCvo0susGYXOBDNLovpmkZ3GINCozLsU6XqEcS14l4bZHYjlUtjXVtJjRBltg67dNhw9pZjTeqaGEnyq8+otJrBteRs4j9tTEpUxoHYI5weciigg893gPfwwYAkpQbzHzZU0MVjJefsn4F8JaXih6vANUmmM+tZjJibv/0Czqza2GWkJOR2+QH84+Z8qlUKna9Jr9HkZRsW0+udKXlM/OBo6R4D25a1DGnbT/utk3/JZ4gh+GWjdvYWIGy+vQcXolnHFBKZT8hsw6pgXCvzBdKO2vBk6xhmTUnMpadZmz706URuVGeVaBBrnw/Xp7Rk0afLaA9u4K30rNXNO7yIFvCcNkxO20HUzAmBJ2ADZf0iUvnpSuUC6Zc8Co/o0DwllBnIEr9t1bwmC+M7n7BoHsw5sFda5fXEFzjxuNLIc0N7O/6rmZjt4xU9bNqVgSA5MXMHIG2xvPcY4t8gb7GH/sXSB4DJXnz14GHYe9UtWRPBN1f6IhvSyNYVEZlJuDQfC/fLpkpSFpsXbtZvaf/RWcXYcSQIYV2QpxPmal7AscxKfOoSg1cyOqrj/98IyWRy9eyXDA319K4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The three folks being added here are actively working on MGLRU within
Google, so we can review patches for this feature and plan to contribute
some improvements / extensions to it on an ongoing basis.

With three of us we may have some hope filling Yu Zhao's shoes, since he
has moved on to other projects these days.

Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
---
 MAINTAINERS | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index daf520a13bdf..8e987f2668cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16058,6 +16058,23 @@ F:	mm/mempolicy.c
 F:	mm/migrate.c
 F:	mm/migrate_device.c
 
+MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Axel Rasmussen <axelrasmussen@google.com>
+M:	Yuanchu Xie <yuanchu@google.com>
+R:	Wei Xu <weixugc@google.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/admin-guide/mm/multigen_lru.rst
+F:	Documentation/mm/multigen_lru.rst
+F:	include/linux/mm_inline.h
+F:	include/linux/mmzone.h
+F:	mm/swap.c
+F:	mm/vmscan.c
+F:	mm/workingset.c
+
 MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@redhat.com>
-- 
2.51.0.rc1.163.g2494970778-goog


