Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC49CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 00:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9A36B0093; Wed, 30 Sep 2026 20:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B28A6B0095; Wed, 30 Sep 2026 20:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6A46B0096; Wed, 30 Sep 2026 20:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7C16B0093
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:57:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B79031602A0
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:57:47 +0000 (UTC)
X-FDA: 85272244974.30.849DE6B
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1DBF820004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:57:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wU3P7jNE;
	spf=pass (imf03.hostedemail.com: domain of 3BrC9aggKCLkrjgZvZiZfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--skhawaja.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3BrC9aggKCLkrjgZvZiZfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790816266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/jlCmxwp3o8421DzN1IIl9qClV/YI1XzKtXgp14OcM=;
	b=4Bnpmb7zoZlty+F1oLBPDJavjji6fdi8CMqF3lV5o2hT9CRQ8EI6MxhTCBooY+y2WOZH3v
	q8S5kuLnOjjatgt4JAt0sSJ40sUgBgPMN+2yWpAXhQsQyUJ/PzrotLco8oZIx1C0KyGHxw
	A+bIU7cBeH5RbWQn8q1yd7BNb6vnAcc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wU3P7jNE;
	spf=pass (imf03.hostedemail.com: domain of 3BrC9aggKCLkrjgZvZiZfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--skhawaja.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3BrC9aggKCLkrjgZvZiZfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790816266;
	b=pSdOb0L2M4xFuiXEWCYV2kRkxAN7+XaihJV36uZjEkLH4Ui8/sXafWAcFeDJ0xssx7a225
	BbQYiZOmAB5aWweAoXRCaxcp/39ePg01/igomyb2WXQAyIvyNr+Jmrf2fzWQWMUQCaLt1D
	U89e/rPLYaSqiPRNzt9o+H2appS4sGY=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ccb687f82eso39170495ad.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790816265; x=1791421065; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O/jlCmxwp3o8421DzN1IIl9qClV/YI1XzKtXgp14OcM=;
        b=wU3P7jNES9xYvUzDfkCcEZ15CWzrumBkNk/iVgz6u0O364BZJfYquTocHUJ7MnvCTM
         TH00AA+UElWSmNFFk6l2iYUqyq8r6eUaxDTQyBwY4A5vJvnD/kKUqJ617v4bw+pLcC9o
         89CRTkXp3lKyQgc8ZamhW8tS1ByCan0qUDF0Gk8RkJnNWA1DlIZ85ozAdy7418OEDx7y
         Nh4vJuk8wqduc7OQRmFpLVyrK/X9i4mKvibCpsOxFPJ5PvlXSmEUniKHkWCmhJlLS2eC
         BH8rdDegXxqCHDh2Z/8b9Tcqd2edcrOopnyHdsVCtRsDUeJhJCpzriJ9E0OtCACky2MM
         WUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790816265; x=1791421065;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O/jlCmxwp3o8421DzN1IIl9qClV/YI1XzKtXgp14OcM=;
        b=aK8sdeGakpO5K8UCjYWcZe4Jo8PgT4yd6G6udvgzTyP134ew9jzRchmHfp2crUNQAk
         BjzGnX5/5R+rZe99Oo7bbYOeejCxywwrAazxV5bUGq6f5JJT5moDRsrjBQPOaMVLm5pZ
         wmi98Ioiyh0RQ1ceGWsc5lpZ/5EUmBPAYQdvVsPym2JDrW7UAFls/WUd8cEsWFiCYA0l
         tg1Fg4AMKqJbqHhUXwLFL0AaM+saGX1M69o7CdBKRwRGKAUbGqusbBBo86Xsd72sPHmY
         o5bzeyD90pXZam6f7kMvGvRLPwYT7/rKDQc0vFVLMyFp5Ny+AZmXpjQiTTvpRPv5Trls
         HOPg==
X-Forwarded-Encrypted: i=1; AKwUvBzLh6fTTv0TxgVqwg6KLhONMOoyQWJPIP2qDC7pP8j7n2zEP7zPB44NMLnEC4SNuP4TOe4dam/W2g==@kvack.org
X-Gm-Message-State: AFq9FYLnk02dJeGM1crTrzS8y2u6UZWlnyTvaGZ/JQU1EatP4jJe03oe
	7Ws9Vof0PT1wWrOufvZ16Lia2zDkMJoYfrjfDwVZXzPYBXltjQjyEwNDA4U6piJGMhM+dMKc5Ez
	OOvzUii63voekng==
X-Received: from plar13.prod.google.com ([2002:a17:902:c7cd:b0:2e2:d259:863])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f603:b0:2df:8e69:1d5a with SMTP id d9443c01a7336-2e2e49fe3b2mr22721995ad.21.1790816262839;
 Wed, 30 Sep 2026 17:57:42 -0700 (PDT)
Date: Thu,  1 Oct 2026 00:57:31 +0000
In-Reply-To: <20261001005734.1033516-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20261001005734.1033516-1-skhawaja@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001005734.1033516-4-skhawaja@google.com>
Subject: [RFC PATCH 3/6] iommufd: Set liveupdate file handler level
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9ghpj6huistgmsmck1heegykisiy1h51
X-Rspamd-Queue-Id: 1DBF820004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790816265-515163
X-HE-Meta: U2FsdGVkX1+NZhRjl72AqEINjeJA1zHvFioSIwZSAcuM420P83CC/1vc74thZoVilE7oj145YZzzODaC8CwjgjVww5fMOyzeR107eewpWpBsmCOGKxJOB39nUXNvyfiJVCtB8C8otJYM521ghTfrc4Efja6L60CofdVxTU9diCPDoOW0JGql/VlZJFBs8M0eiTn0HjDx2Pd9YjalkjbqHtVwI8H91O8JESjBIg3o+OtnDxt81GBq5gNmkFk02qnpd9v1Tvv16b3BQKz5j26AjzGIdmHJr6XHAZqtZlevDFB8jzZMNUpZ9ly7u/PhV0BwlPOuJTlBsKxuXjalafkJA4x3Z+9VuQz1Z+1WkszHt/mCJyE0sV75G9emyDRh4magUsSjfMUrht1QZU5RQ/AjnQd7uTmABFqjpvj7lbQjz9Tsm3vLMEs7BgTbhkx2xmKgW6DZiv+ojqydzxlDkFdoB5U/5fzJoyMqftqVg5/sXbR6eCwcxIQLawBCitF/HluKRFFIXRcgY5nbopol3ifHApTuzHf7vr0EABkF1sp0h64Nv02wmlFPadEFDlCgJvqWTnevjtPZpZBPKL6wMKOw4d6tyqBsQjQewlHVNIkAx5w+STKva+XxGq0X+uvkeilLgRIS7/bOHCngvFCyXaIyTMOBZWsWnhK8XpPvJGyxbh+bov3flDC3AfR23RPyFj9M0J+VDQENX2AvdQotSq1Pt3gkqOheDeAzhoOkUpjyZ2UZPWHCtwKoShYgcYfkMnSDCFi9h2wnIv3/FxoD3J0aW9TwyH3DJXVniO6wYJJWrncHLCHijy5oIEVIxRMq5Ukb8mJyYrU1G5SF/0PRRaPGRRr9yMPkkbwuBiQ3ZJlTvL3cNtwik+ceRazxRLrbyJHNgLBdmqQ16KB+pl04oZc2KLP+G1lTrL0g7i4YxQKOodBKKphUBge95SvE23PAVX8iDqzW4YuXMR+v38JSo9F
 JiPSzOZm
 YCzg5B+UxGX3KBAqrKexvtggN7SR71lJVatA3HIQ+wE6SZw88gQcca4+PK+EhoSucgHmgPPYD3/w0HJE0yEde2WbdPPPa096YVUupKXRx5AakiT1g/lQkFwRbHJD5mHm7/mbipMkM17Z7Np+BdCy/APWEmMJhvrrEsFJh6nk1Xc0cp/d27Pk8voy0bI1W0PAdj6t/6/54FpCYlanG/M+l87hC5xAKU9D6kMakio38wKFPgdF6kG4uQXnr71KYTsDFRcWODA9+gJ9R/B9esLh2/dzZylfF2owddXBQgfwqUawaMkLUfnzNN3RBCy1rEoapgEwgAsLN7qbIEzafEBSPoMxtAKgPP4oXVgFNI4CpoigRvDcu6SA8XDFn6jshJoinC57fGRAYg8u9DSj6qHLkXJh7+RDlN8VWzBjo91+ZghKte4gsyWCatQryMVFeLEm8ZbmiG+xny00MJwlhpDKIJslgUGDPhwzVcrH2bc+Fb6/G/rpODbciY9a9xBAZKZkW+MtblIjY7cHkNEGmClndp14QpqrDNe8gjc42FYvYCqQDbZzIlpeCDVtJTY5KQmqNH2zilKMp1wqecj/NDbMWOOaQcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set level of iommufd preservation file handler to
LIVEUPDATE_LEVEL_MAPPER.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 drivers/iommu/iommufd/liveupdate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/iommufd/liveupdate.c b/drivers/iommu/iommufd/liveupdate.c
index 423369e3a8af..2f2ae1a52be4 100644
--- a/drivers/iommu/iommufd/liveupdate.c
+++ b/drivers/iommu/iommufd/liveupdate.c
@@ -351,6 +351,7 @@ static struct liveupdate_file_ops iommufd_ser_file_ops = {
 static struct liveupdate_file_handler iommufd_ser_handler = {
 	.compatible = IOMMUFD_LUO_COMPATIBLE,
 	.ops = &iommufd_ser_file_ops,
+	.level = LIVEUPDATE_LEVEL_MAPPER,
 };
 
 int iommufd_liveupdate_register(void)
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


