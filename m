Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E1BBC5CFD9
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 10:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B406B0092; Tue, 11 Aug 2026 06:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4AA6B0093; Tue, 11 Aug 2026 06:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9E96B0095; Tue, 11 Aug 2026 06:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB7C16B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:18:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57F89A03D8
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:18:47 +0000 (UTC)
X-FDA: 85088589894.11.1D2AD9A
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8C79D18000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:18:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gKbJuMCE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786443525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=of6+kQGm9cbK2+HVarcGd8ynPzUZKOBVXR775F0b++M=;
	b=VoZR3MRIlcf9JJ7MZbBpnwg6Ovj/EAsuoa1KFxxmmoAo0ukxC2xvHFQGtLqbxWE6eYyarZ
	dstIYVTYWEqfg0ZbzhmdI2Ar6f8Put2oX1ff7PHOisf7QkWh8bCoyhEfwVKXkLHJDgMKso
	ghKySu6xSAFnfu51mWzAEAHrn9Gp8SE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gKbJuMCE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786443525;
	b=8LrmDAojdL6hukXJxpwQNoNzPzvQMcF0Rk1xmduykBdLvhJPAhcTzJevJcYX1OfYH/035p
	S/Ea1QAxfKHohOyCsvjOZ+Ne6oEVVOIX7nw9NzmsnqW0ZhmoWnfii0bAyAVyoHdxTuv+Yx
	v3p2fFnrKdptLcaJFO2yxh0v8U6csAI=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38e347638adso3230120a91.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786443524; x=1787048324; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=of6+kQGm9cbK2+HVarcGd8ynPzUZKOBVXR775F0b++M=;
        b=gKbJuMCE2hYfBrfCbZGUEMuxhIrBNnCfjG8rbRCBgMZYZa4dcecNj2HlO0FhAbkC79
         RG03AJZW9nGSVCOE5go+Eng34pC0TNWvWMEa4jA+g2+jUrk4cPtMpxKXqHML5zbwRtLF
         /a82ClxpDFY5slV+3w3WTN9moUdpOGOHE4epUz9QnTR2QU2TxhhNg/mZcaP+n5WCImEh
         6IKSG5yCJ3KJoSA7ArpJtB9WQflPeI9p6h+GFRrX/CagQgR3QjxUnctWm0HSocYrSwkq
         Zj4oQK4FrbjdTqG9D0yr3TFVFP3F0Orhw/Hg5kuLPwz6GQCpu5QuvN15zx0KmPwNuPhQ
         ZPPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786443524; x=1787048324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=of6+kQGm9cbK2+HVarcGd8ynPzUZKOBVXR775F0b++M=;
        b=hpO2b1Mga2h4pIzoKF2STqLIv3MRxWGtX6mymnQ95JPfPjSxcX16PJdnRuU1pPlPg7
         QWYXl8jurBz0cMu+3AQTjQr3i/J8N6OdxWFTg2ffONwZh06dzX9lIq3EiBWhcxWkoybM
         ps/wzJH0gROp267tp9m2uXduLd2sWMGCzCBW6spd4+sKRpsjkh4aqdJ5//m+dFsegNor
         qenkQ6sNFi/f4ZYEwfoAzy8szrGJgFkou4SSidsHXl3/CeZVCfEuH+DakTV0IBwyFhR2
         uh0M4gAuKprLu+8Xs19rKas8HnUIZp+C+3gw1UkMSuolE27b5eTxEYU7eJmJHry4IFJu
         pCDw==
X-Forwarded-Encrypted: i=1; AHgh+RowV+XeljFwbq0E92Ztc98XcUdrBin/ztBps6xTW9TTDnP18TltwAaAVnQNLLh9JUam/v43nJLSgw==@kvack.org
X-Gm-Message-State: AOJu0YwX0m5TGXHiZvR8ZeyKgSJqtwKfQBdlgMXY5eSaC+9kc1q68UaE
	HtNYnYhvAd8FPKUh9uFg2pvqPGjoG6W55moKXimIkeHf/vofCIh4FGI6
X-Gm-Gg: AR+sD12M0aTA+zs9M998OKPDYoJ0aFtxumOz0Tbgvoq8EFB0nIPGx5xRYYgeYa3RkoN
	AFh8Q62T/OgP/bhSPSQLBM7L/WD4QSwZDgdN2+mTGm3OhIaUqgNwVpLKMslG36mu+mt8u8aoxks
	KXKtmsoIPqMvZ8zQViFuwTWM2LqwCnaCcTvKZNC5rLGDoBlP/tSby31Acbi/ytlzeEYihBbJ+GI
	26Q4UJpKkBvCb+W/88sudKhPidlCef0Pk30QVhBYn1c/32bYSDooOMgFSTMesR50VRcnlHV20T4
	4VoCclpV6JlhEDmW5EG6PZHv+vKwB/k3zNFnJndWeP5FhnN8ZnargXrJLDQ5ocRnuGL/Trxc6ZW
	yqqXtPmM5n+tW+SXDko2Drmzn98EgAg14mQi5V9BPkY5c6uTNEcYK9ZV3pGdpHFLFFXugLLXIKU
	eUaaiZ75yaXN5c5ZfnUhfUdlkWqDq9hoDRLZwqQSYU9+4oAF39HzisXXxoFXQZXyE=
X-Received: by 2002:a17:90a:d2c6:b0:380:7688:fbe9 with SMTP id 98e67ed59e1d1-392ec50d0eemr2377078a91.8.1786443524387;
        Tue, 11 Aug 2026 03:18:44 -0700 (PDT)
Received: from celestia ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1412042dd37sm3752328c88.11.2026.08.11.03.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 03:18:44 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH 1/3] docs/mm/damon/design: accurate semantics of nr_snapshots
Date: Tue, 11 Aug 2026 18:18:39 +0800
Message-ID: <20260811101841.804596-2-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811101841.804596-1-aethernet65535@gmail.com>
References: <20260811101841.804596-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8C79D18000F
X-Stat-Signature: rnfrmd5896buxrzxz7oeun34u6ik58kj
X-Rspam-User: 
X-HE-Tag: 1786443525-212042
X-HE-Meta: U2FsdGVkX18TuAGbaTHcHrmZ8rDp+26m09TmWW9NbTM7zEd4xsNTWYvK39bq+D4xQVyAvmnPuWUf9iFD7rL2xMxorhmA7BiQqQLQ1Ma1r8MaATzURaQ7wbR2TEqdeu/AfpUyqWsfHLKvbcivdCYwyttdOgGTj7ROET80mrZARXizQ1VOm8eVmTQdhDCbE3Gg0iwmYFFnI2gTIn8fLOU1t0v3OB/TkB/zvS0/RDY2X3VQDVJ/cEjlETH2Hj5uydiH4eUP+z1z/0huHNjoKSK1QRqsD3+rlhlLNbkumgCOTPVSNU6nIy+STKSXrv6XuTfHlKSfz8m3Ss3AFA+ucxwauVPZa8bSEq11Dg4mWHPDh+pKr7deMjVsnQUeUVYDrnU822a0wlMeyhjWVPDvso9Q5Kb+IsR2as5rwE0Y5BSRwZeVTvXLkfGkYVdI11eoG7rKGJNOYo9G+wJf9/fm7qN9eeIaPiM3jQgjvTnA0WQ93W4SAeHGGaLVJVhD/q4zT5eS/rfgunbXOCk8qPrpVD9ZbGNt1DZZCavgDcPrm8CgG7egLii84Y5xkRrwOfZFKDC4wflIW3t3R6fUBxzGRmmP3+jzmFNJx+ZT/RliGBNR41Dch0Z17tw3dQC1ea5MmDCwaIbYwOMhqzetZ2S1Zv1P5TXVPBBGyfzurmjR9NKY5WerG4vVth0BZeiP7PPplx2dxiCs2nWkSXoWGAsGMxBZStNqdMTFdCyIagxhj0RY7O93LdFkuao71L2UgN0A2N9dMq18uUBkyNd2fN6MBad0pjnO772os477AAuBlRUW+H2bmKi0W+k+KtSec+rYZhTXJ/DP9GEots8R10X8BKUqQd0j/hQ9oAaRg1Q1DYn0SP9vIRb8ogZ/JOst5bc7J9OFgVZDwrEQNB+FK8NKEoa8cHLcM2hKJkAibrQWjesJ43fQ0DDwT4LWPn450LZU3Wb7FVkAKNQz/VHDFmgrbsq
 zo/za8Ei
 UaAcSqudmGyH+5Dq4YuYcjuCvR3YLUZr4PtLrj+WHb9JVSBKEyZ77XdTptpMCfjEQtoBUfDnS+dF1feIRe+z67ojgT5WuLC+IX6NxWqEu8kW0OGdLiJ9FdVrgWhSdHkYg262m62ZQdzvW73iSSaNvYFKeNAnph2aPYOeo8cFpKJZdvPAx8XL/ScK98Q3EWjBBJWBFwqZJHrqLxou38Q6fBVa7q/rbg6R8uohHQCoYigsrSypaXeqhR37T+6L9PIGm4tPwWCqet0YGq/DzytVZKHNlZmoiODSCEyyHQBjs0f97hlSmKDiUvFUdyerwArG2RqHswPnJ/fbLbhBNcZqMWk6o6OeYZAdH+JZ39RI3iwG54elg1+ToQ+jfso6JoGyA8596OCSciwiVwLQYEo6Zl6Nl2SnrkYI5Pf9Nl9cdrSlFpP/A6q83WHNs74brZxttZFjK1XazWO7HN095F6t7bo8hxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change "tried to be applied" -> "tried to be completely applied" to
maintain consistency between the documentation and the code.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 Documentation/mm/damon/design.rst | 2 +-
 include/linux/damon.h             | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index aed6cb1cf483..939298f2a9b9 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -847,7 +847,7 @@ scheme's execution.
 - ``sz_applied``: Total size of regions that the scheme is applied.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
 - ``nr_snapshots``: Total number of DAMON snapshots that the scheme is tried to
-  be applied.
+  be completely applied.
 - ``max_nr_snapshots``: Upper limit of ``nr_snapshots``.
 
 "A scheme is tried to be applied to a region" means DAMOS core logic determined
diff --git a/include/linux/damon.h b/include/linux/damon.h
index 0c8b7ddef9ab..d642ce4fc83c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -357,7 +357,8 @@ struct damos_watermarks {
  *		Total bytes that passed ops layer-handled DAMOS filters.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
  * @nr_snapshots:
- *		Total number of DAMON snapshots that the scheme has tried.
+ *		Total number of DAMON snapshots that the scheme is tried to be
+ *		completely applied.
  *
  * "Tried an action to a region" in this context means the DAMOS core logic
  * determined the region as eligible to apply the action.  The access pattern
-- 
2.55.0


