Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F22BCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BAEA8E0031; Mon, 17 Nov 2025 12:37:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2287A8E0002; Mon, 17 Nov 2025 12:37:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096CE8E0031; Mon, 17 Nov 2025 12:37:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E31788E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:37:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFA52C0218
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:37:39 +0000 (UTC)
X-FDA: 84120806238.11.068B581
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id CC495140008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:37:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CEqh7B51;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763401057; a=rsa-sha256;
	cv=none;
	b=cLjURs3Y/St3rwKb9R1HmUc2WB5xnYP8tiHOC6638BwjE8bCertdP3vxrwPlzfbFLERV5A
	QFE4VF2/wJ2gKR50zDDNEAnpQaTrKq7TNrlb5DOpNX+IdJ2UVcoFby4QsvKYRnE7cafHrE
	4nDCCLGdqVJJ2qhprAQ0qzQMUco9Q0s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CEqh7B51;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763401057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vF/oCzsCJVfQ1QNnE888AU746+zdxfjxC/Ij11uSPgk=;
	b=CBBl8p5oJh8SzMs2axFKQwD3yvQM2zIi0wsC6XDR8pqtiO4lduLzdKawejX5lMUbxzfN+G
	JrpYiawZcbZ7RYyZMKSDKpfh86TPldMFiTRy1ZydOMtpIzf/hL1+ym0h479dQ6NVHMeFzQ
	YkYf+kMIScBlzLjAA7qZICyagX2Snew=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so4972834b3a.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763401057; x=1764005857; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vF/oCzsCJVfQ1QNnE888AU746+zdxfjxC/Ij11uSPgk=;
        b=CEqh7B513aCSNDrmpjoXnm1dQh+7WOaUV4UfNmuL/CmxXJtRuTBJlGYT1JHGRmBlrx
         iUnAH69KyIFSLMNTrTUWKFs9xq/HphlvRkiXrAkIQem7tYTaVBneT2DvTgXalSaHSDHi
         NAlRWiQwHkrfek3W1QbvnehLQMJoz4MhRZO8ViJm1pGH/BBq3u0spN6c4CydbR5KqC49
         xtnMAkFho5Yk1kR4ZG22Iprym3HC3w+aTRBZG05gHWuFvOF6EJNq7/U6xOcD2VSoeq5C
         JgxhYVUYAHPG1oYLWuUG/kS5Ae4EoKzGu3qP1pw9jQNZSaIHf8Jjj+/WJ1mSOJSHdsBQ
         g70w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763401057; x=1764005857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vF/oCzsCJVfQ1QNnE888AU746+zdxfjxC/Ij11uSPgk=;
        b=a+tIdn71Ur/pn6qMXDfO2maOmsZBiTlDXNBLO7TtHW/rh5rj6li97ewhpp7UpnD1p2
         cTjgzh2sChRsfZI8YU2O3e5ojoCiGRlWjXAsWmbV+KLd9fIW2+gpTpePVB7nDD9rQev3
         wHBjRMW0VPrBfqflQ3j0C/Flm8npHUImR16llYXF0Nu9mu0GoRNRZk/Q9f5N6ml1jsTf
         sSKMRT2zZnujm6BsQZ2ZKdPiiS6b0K8kaXdds0w3Wc8JGjOoMU8jnMaN0W9E6oJc/KWa
         8BQmmD7OjB6wHazzbiVb/ELKQ5cb9QK4Lfm5OiDBui1Vz61pIRa3llmu2wHeAFI+TTI2
         bxmQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3u8/ghHdS6zYpunIx4BpUhw8ff1QEZ3O4GOIIHJM3WCKOYIgTE1K3r2r6Pfab2VIGdPOzsPrHKQ==@kvack.org
X-Gm-Message-State: AOJu0YwXDzEb8O8WATb7tce6M2jTGrNJx+9ZOGiCmgQwZIP9HrhpteWt
	QEgWFReNkAF/KQKi6or1DPgM6e8DDnOQ9J3uL0zA+faJx5i7/sLiMuUj
X-Gm-Gg: ASbGncuuArIdtpgJNW73RlbDRS1O9cwkulRBNmXTdehJjepGL6mfoQk7PlWa4BbRjit
	A94JqrIMk1rnGazejnf6iUrSYoLk/Ytuv7cF7OXCyDfLt5rrM4K7gUoacfH2KByOrBp9jp8Pk4R
	ocp7WAWSz6rXcchRXYFxd/48gEFTbBzQlveK1w5OSdw32Jo8PYAyZQd87Ngi1iq7NQZY3whp9lK
	RQeQWi+UcAaYEiMCx2mnqMBO1EruYbaDD5oLBf+FMbgDr5vGk71s5tsyfyb6zXvmB6QDYE+0kbo
	UqjlaMkMO4O0qBDyKixQdL5f1hvS3uT45t5KxpAZEIE46+kE2egDpTOvNiXVp9snKAtglo0Nx0c
	7or6hAzbIlOJCIIODghamkjDNqn4hXEzfEjEWuzvPYA17T/hzgxTZwYHy5shWCJxFVtjKKSzOqo
	Bi78Vye7NDy0yVs06Kehv6k6alB90Z7487geCYhfToypgn/AUbme1N18XxpefUdoJG
X-Google-Smtp-Source: AGHT+IFYh76XnkGH8ZPN+SodrLUUb6MouxEfWZLQ+VK6P5yiR1d/domnXV9JBxjTuI4H6aRFsqsiNQ==
X-Received: by 2002:a05:7022:662b:b0:119:e569:fbb7 with SMTP id a92af1059eb24-11b4120f544mr5937733c88.38.1763401056525;
        Mon, 17 Nov 2025 09:37:36 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-11bf23d6967sm17190077c88.3.2025.11.17.09.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 09:37:35 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v3 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
Date: Mon, 17 Nov 2025 09:35:30 -0800
Message-ID: <20251117173530.43293-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251117173530.43293-1-vishal.moola@gmail.com>
References: <20251117173530.43293-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CC495140008
X-Stat-Signature: bn1ssmdpykzyqhccjcu5zu6ps3c8wf8y
X-HE-Tag: 1763401057-243161
X-HE-Meta: U2FsdGVkX1/DtiQUUr42f6d3mvhdk1bANtTWhkRQ5IT0rL3MAbMiVvMSx4PvNiA8BX1uB0UuEdvLln2urJNbDcL0nYIdAkokot+fx4y9p5tQGw65gfXZMVEYndMqzmfWsOPin0EkSGTH8z1FvgvyA2qZK/GLoWUj/C9zYJyhbxUuFiJxhYJbS4MsxaJ1/yU5/7QTsMZAcG53RGXwWCBTzREhnxU7n0dD2BcOJxxQ9y9xIxXJMFI6lvySZKP54Nkls51JDSXkWKZG7sJJYQlxBmp2Pqy0kdQJf+sCAPTCejnhtUhm12CFvNWBzPyAAP7hjRkR+ahAtvSiLTVc4JCapah6Q4svBjo3kcx1jMCoQFxSI49cmFVwL5HlJEHE2nm2fKeCP1wE3WtY8Q0pSWwWpSgj/e8waQttBs63s7uNafcyLiESTEZV6HXtlGNugZudYtMhuo4Wuj4iJi/QL2oyvkHrtIZHKptzNB3yoGXrICkK0wLJoyv27NDPedsyU1VA9hR0UPkpa2dWS5E7ifQ9aMU7vm+dAU0nQNDdUnKLYRau0LNDKcwMnswHd1k8Ii3UrtC+PSZ+n0VJAdah5YHqRsaOyCYEfMKbdBDc1ho7DllfZDkyDrvVigWhMx4wB3fQACCXab4I6ugTo514kLo6Tc6AKLo6qycSnzUCNgoe2MU+STHWvKYG8TLAdotLsr66Vt0boMQtgHZ06MFFpV91ohUmT8p4fpmxHyv6cMUjNPLxpIp8tfSxpbbrlFL4QruGYS+AgFL2iFooA5ZPaBhIfqf+j4+BESsLuLNfjiI4EB2z6EGE6DPZBrARV9IGFRbLN8YhqZsf1zcp4BRRYwjgJa0ZgfcCUI+SXwn6gX9Jq7JzSIL2a884FDRblZaGwBejkttgNz2lj88OxNbZT4vM6TKUJPjAQ92l+7udZ6k7jetC5AmRBbOW4yAo5kSiglcuey7v7K0hpq7y+WT6DZ5
 nmGXBWOL
 HPz+b+ww2V7exOvRiTBXntUbBupJkdg75Vxy022Y15C7iUy2C72BNs9qG/TypMsXUMkV2kKjN9KYSc4BtJnLSAFv3YxlWrqzNlp46wBL8NK/7yS326cnLzpHjF/TubiZPQtQeneMolA8TFB7bfO6kMIO2qpQfG2SVTAwQGYZGaRlYDMeOini+Q+yk49dyxhOIB3FmD8eniqMNst0pNCdzXPXP2gV5m/q12b+QtWiJZ1ObIX8AxuBJkmt8kiCqQ+ZIO8CVct/VVKbLbOH1pvpdAT014potAtHB9AyayjHMjiHBg0lBQt/v6p+9/71VxUlIxY9U6XCPmybUVL05pHJITbjIZpeDPyyvWdH76QKkeqtjjJFt9umLtxM6ct+soKL4PLjI4vehfntDmOb5RU0PKumxcz93qrz8uptB7+LHajqUA2pqw57UadM03EaA25HwCfeHX93lyVNm20CFoQJYI+VhHS/Ixfj09iSrujDReh+3ZnLQZo2HVqKqch+MBERBtb0F36D70PaBmUdMCaNmEfHciFDHSA8qEsqI12Y1fjqp4EiB3rdmxfpQyZNBSDchKS8RdELR4CfgFcIikrx+xduIYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only caller, vb_alloc(), passes GFP_KERNEL into new_vmap_block()
which is a subset of GFP_RECLAIM_MASK. Since there's no reason to use
this mask here, remove it.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d343db806170..d55a77977762 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2699,8 +2699,7 @@ static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
 
 	node = numa_node_id();
 
-	vb = kmalloc_node(sizeof(struct vmap_block),
-			gfp_mask & GFP_RECLAIM_MASK, node);
+	vb = kmalloc_node(sizeof(struct vmap_block), gfp_mask, node);
 	if (unlikely(!vb))
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.1


