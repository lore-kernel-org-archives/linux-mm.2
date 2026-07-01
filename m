Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2EACC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 17:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A5D6B00AB; Wed,  1 Jul 2026 13:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11C96B00AE; Wed,  1 Jul 2026 13:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92ABF6B00B0; Wed,  1 Jul 2026 13:27:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6ABF06B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:27:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E20BB1684EA
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:27:32 +0000 (UTC)
X-FDA: 84940889544.07.732437A
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 241E140007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:27:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dSY+AHIl;
	spf=pass (imf04.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782926851;
	b=59rjcTGjqTYb0WKvS2ngtlcJdkznwq1BaVF74Vw10AxfI7B3s+2z6D5Khy3/tyJs7+bT1i
	kBCrRY4vmrDqqSsympTBymZ86Xc/MHceaOGDdkMPpU9eJpdutuuYHRm32QBZkQCSJH3qcv
	ekfqJARvuUWc1mPflsn1UxmufHzqjTk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782926851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEAivEsfeo8Fq0sNWZpHlLBA/MD5F/SkLxOz2gsFyHM=;
	b=fqGITxedXLvtGh8qH3dATD7hxkB7FE1UfHthlJwU4LqOGrKsvXzgtkCoDi5piY8/ozzDFv
	DoOAqyYqbuFu9FrF57ZxpKMpK/4PN4hISLmRoZ+K4DcyYoGYXzrrk7dlerMVqeS1fHSiLw
	AGJPsamhCpi4cH32h/OcAbgaiOn7Ym8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dSY+AHIl;
	spf=pass (imf04.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-664d22d7337so998449d50.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 10:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782926850; x=1783531650; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xEAivEsfeo8Fq0sNWZpHlLBA/MD5F/SkLxOz2gsFyHM=;
        b=dSY+AHIlFgOHU9RP94HImNg9ffmrEp6dG+BIAbwp8WmEzICXujmtrapTY3aysxnyUq
         ETTstLmpTUlunQx5ZV55CctyLcd8AFwUF67KwFxG3/ZkUN9UplwO/BMyXuGQg+dYz3yl
         ReFkLJ4pNuDt33sWTJ84IF3wuoYex6Z61OGTToYTk5iJgsKvi4/EiVS0uZz3E+Ic7nZF
         grS5EuQvvUlBBFx/gKafrH+AkoKeq8Ea0i8hJcx8I7klzOPAmlTuAaZ8rjMlptpj5ihm
         sW9iRL9IDUQwNV+ivaLPiPBGt1FcYFxYBdbGxiU1QQv84JaovUMYYtuGr2bQuGHJVTZj
         mMuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782926850; x=1783531650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xEAivEsfeo8Fq0sNWZpHlLBA/MD5F/SkLxOz2gsFyHM=;
        b=Ar5ARk857CL1v4YAZnWjS/IYEVGB9VBDqy0y8IhFRexmT3S2GdLzk3xkVUkPWD2ZGz
         BJXbrgOh/qm9Nag5K4NWjAh1lHnk5AqQOYPce7CmLFqtTlsNjPzA83y3nnPx64BvP+0s
         v0iu9mrUC7NDpdMveS/e3NHNbCo6hT+Kip6Lg4AffnqzC0dSvq+JEqVZhvnpCl6rfcfr
         2GzNhh3zXaGpRbyuMR/Z/xxx4i9f9JDJgmXJhrIeA8idH9acOnjUJkNeJXx3HgCHhmc1
         dM6NbSrFOvbugKI4vs72PfClenTthtCPmkMdm0m+OdE2ttywV3mQcRJeETprxuUHzbAw
         0rmw==
X-Gm-Message-State: AOJu0YzWWrTau/6VTtjCJUDhGmXa1WJWl9V3sV2BfLGAfKyvCZg4BDQv
	M+utujxpadDbhiDSUoR6eabyO1uqxPtx3xge4KjgEsxRk3rZrebZhYZuq4tUOA==
X-Gm-Gg: AfdE7ckDtB8XV7K19dH9rokTiMp5pSmWs0y4tSEtpE9IUnB/IYq9KyAnJud37kSBuri
	MKqAKbDXbiUJSTYuO7naq6qr80L7eJrhH04WXRpLLgf6lcCAlmrT+6At+e9jsad4+8vQCqjh8xt
	5dHtvHQP2rsghUmNN/ciTHuVFR/BITJ9BX5nSFB7NzFfCqxQolDj4r8f61cv0TNvCGNV7D95IOq
	U+hxwC14zjy8Y1xdCWe9674etFVnJ0Uv/kiuM3+JD3xaXViGZPQGUs24ztT3aJcRdANrBd0jLeS
	hHaobspMpBALlKM85Ez3/tjRJyqjTZRtJsr57VpQ9qWr/eflbLomKIdNuPstsFtjL888C2VSm3p
	CC29Ug5yNmBPbosWnEZP9R+E5Cy2b1mH4ymNPVdmfOaXdADqjtR/OPgzEX5y5CMFXWWpMqG0Bc3
	yr+cUmU8hdLJz+vNUApw==
X-Received: by 2002:a05:6a00:1910:b0:845:a390:fed6 with SMTP id d2e1a72fcca58-847bf944a71mr2486907b3a.17.1782926353391;
        Wed, 01 Jul 2026 10:19:13 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94ab79sm105719b3a.31.2026.07.01.10.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 10:19:12 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 2/4] sh: set node_possible_map in do_init_bootmem()
Date: Thu,  2 Jul 2026 02:18:49 +0900
Message-ID: <20260701171851.2447626-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260701171851.2447626-1-ekffu200098@gmail.com>
References: <20260701171851.2447626-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q6hd9grk667uzufirkhsqpb5nbi4icf3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 241E140007
X-HE-Tag: 1782926850-707274
X-HE-Meta: U2FsdGVkX1/KjXLJR0qTQUPJa/mO9gfDmHKd1Ve6nJlRUUh6cBjlXTvmioFNK5T8nS9n32QpxxNlvjqUvdpUEqwkCFQlhJg/7L4qI+aWD+dqkrSAtZ+rC0C+KpGxn7EA5MjIyqsrtA4Wu1X7ZTUiCoxvmb4HYEVhTjpXhPNvVyDqvyLQz+1ke5UgmHoqkTBXV6A87Dd3XdeEcNeNuKtEwBwEjF4Fut6qOjoMFgVZH1jrotPM+Gp47mjJ1lt7Upwb39bwr9qIuVc/SmT0oKf7mYOxV8/SwEjXwM3QBllaYmyflf8mxICER2tekBF8SGks1Ng3YPncR9rgxFTr+SVw44MD2v3uOgKa5rvizciMMwvMRfOVud465cYrSh703fug4Sm+W+9tc7v6IuFxk0jO4llEm9OrAKbsw87R1KmFctSpi0JjQQ25xDB8rlVTxAmFqgrhsgNFv8HMfLeHv3woz9W5ipIvsPR6KETf6yh8Iu13sLc1IE2qvSJHFpwkr43Ia9Gd51cnisHlmXis6b3GT0f+gGs5vN9SbDcyRD5k3rtJn1IaxOvtlno+MVowgF0i+8ASpNeCtTcsJFUbDKuPYzzFQTAGVRy1xjpWJZGxzWUgBO5VfE/ahZkp8TssqYBQOaBaMpirfwpMvlLaY3kF2xnrBiZdLbt6BILM1fFXr30p5l2jNARLYe4e33iResrk9+PBlY+/8HllbDzNClJYNNh1rjS+5Xr/Nd8wN9MglaXR3rP6/SaSojH3HLQKpPHjiqwuB88dKMP5V2z9poZLrFMggMDV8XzwVHCXCHkbIovS9NFetxI8mZJM48p3RJ3bFa8SzdVMSj2y0kSVOHTVidVDmHIV6BnUuD90/iqnxWCIa2GNJI8wIfEd8Ox/1OLoPkJ+YtP5z9pCLnbp/TFSl2MuvNQcnNPYjf0s/rYWv/GpWvn9zkh/69plD1ADOdWsLeQizhbVeWKwaRU5j7a
 BKUNbsFX
 tS6WRcCOkLwqb/rjifZsT6jfXMFVKeXbBBpLSOTlO0avbON4n0EAg12myBWC3shAsb/GLPszh1ZcwvYG46JbPcUduF/TiLwUcwu78KzjJBwpCr3H5s0cl+Kg5g/XcVvtaCnZrf5NVZbsC398f1rIxeOr7KVDDcrDHgfVURBETrkYkHLEMaasgMfx782VhYZHIbH7Jm0K3hW7RBDvuLxJy7xXs5JLfh1uTD/+lPx+sVLOlynG5lBnj/D4qROx/Nbh095aN+3AWHevfp5iGRlExD6utWh5QuCu+JYUmz5LcbF8f9gs4r9RoUGZHcevvm9WeSnwlwl1pnGnugnhmiyZrL80imujjIKszAov95IcBRPd6xKQ4LNeqPzv2x96L8lZVGShxbWVqJdhewQ8/IS2wYVfOkVCujP+QvdSv6IyGt95/cx1KPa81xc5nQKpZ7D2mi21fH3ZH7AalklE0YkR+AqcxVtiD7oTX1oA2LTqMAtbF1a2cCSGtrMi75oF4GPlgj5ENSRk3P1CJ/VaWYfg6wgKYMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unlike other NUMA architectures, sh never sets node_possible_map.
do_init_bootmem() marks node 0 online and plat_mem_setup() marks the
rest online, after which node_online_map does not change, so set
node_possible_map from node_online_map.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 arch/sh/mm/init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 110308bdef01..13954d7bbdae 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -227,6 +227,8 @@ static void __init do_init_bootmem(void)
 	node_set_online(0);
 
 	plat_mem_setup();
+
+	node_possible_map = node_online_map;
 }
 
 static void __init early_reserve_mem(void)
-- 
2.43.0


