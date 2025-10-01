Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA89DCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 09:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D638E000E; Wed,  1 Oct 2025 05:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F39B8E0006; Wed,  1 Oct 2025 05:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430E28E000E; Wed,  1 Oct 2025 05:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 32B1A8E0006
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:17:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7A1714096F
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:17:05 +0000 (UTC)
X-FDA: 83948991210.02.C3C60E8
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D1FE4000F
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:17:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mpRr4YrQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759310224; a=rsa-sha256;
	cv=none;
	b=JAmfW/TaJigGAvFAlMsou5rw5WR6354NFhe0LsmkjnhNt7z6TS7CEwEmYFs+NMT/cs2w3N
	tFZpCfR/xerx2LSO3+HlPDg+i4YcQxnTg9vfLH46wHmIrmVrLD3DeADfA4znGiHPYnn42W
	yMclXnYaBHVAqt7oyjYr1FwxJNam4rM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mpRr4YrQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759310224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=w2XxZ+xl14l9r3XHZiZ+ypWVAtzLOudFxqCIGOf+QiU=;
	b=jG8fEZyoDxZKPKbD+86KC0jdze07VJ7HghgdoSxNGbE2AUo00Jm72SseqbjCFBWafr3z2i
	VkSi77ydCai62+vpPC1nDoHRZ9C0SzTGe+MjwKPkEa57CICmYopCsu8DJnCyAn9BBfpkxV
	LMDQdULs0RyeV0WpQTuInd8vtGtx49s=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b457d93c155so306487866b.1
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 02:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759310222; x=1759915022; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w2XxZ+xl14l9r3XHZiZ+ypWVAtzLOudFxqCIGOf+QiU=;
        b=mpRr4YrQNCzWUglY0AovejtY9UseyyFhScsbM3qJz4BYxmBSnzGsyZoGgPtChnVhyj
         eMtxgyLrTVX+us/QAtK3fHZt1yHRPpX9otMXafpnIli+GHOpq4A7jgz6Ie0vl2qwk+oP
         w4+YuoFoWYT7cEmdFhgRS+N2SKhWqyGgRirXsGl4jYvRNehKGMDqxgyyjWP+NEeWCpbu
         oIy2B7S7d2aGPtCPlfMD5IMRrNQT6rR6sJVGmc1g7BtpRRKZ3ine2CwGPt5m+Eornd2l
         ODMSW7Ba9W6IyiuNgTKdtWlfIi3KRmKAblwcQ0Msys5oT8m6FiMCbkqBR5vgs8wZ39hX
         DLfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759310222; x=1759915022;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w2XxZ+xl14l9r3XHZiZ+ypWVAtzLOudFxqCIGOf+QiU=;
        b=wWnUjf2YCE3vAPIlGheZZUl5rVSGljEgKDusAosFghomYWlgcHOCDeeycbxmmKdn2h
         v9/bvLxPc+7cTrkZz/HrMSGCGK3w+JiQDqFUTR6ShlMu3ATvsvezxyVEvIsn8U5Nc7xy
         6H8kD2W3ba7AK/nVofyrPvwq1ttrKoMxIv+hti9Hh3JOA9nJwYD5PXqdIPT5Lp+uXeGu
         XMC0dc4qgnkUiEiKBRt1Tu6SM7kSe3QTKQrdjaDSf7zoaX3HjOuKQrmwKvxNJWefC3eQ
         9nXeW2Vfx+8ERuSPeyYw7rcyF7cLPdO0eWQ2QfyVz+zMYFFa71pILok9qGtnn6k2ZkrC
         Zhdg==
X-Gm-Message-State: AOJu0YxC1YSRMqoRYuYcnfIghpMmD71hRwlSBwykttHJtO804CodFila
	FLSZcGD3i+NtUDeI5xLtfZJh///Ae6Jv4BU24jm6l6BIjTvq3+qxS4M7
X-Gm-Gg: ASbGnctkRZs0TvDmBNIpF6Jb6XpR8idw5eKCvTcPCh0dG0yY+Jt8qOm3RSv6JAnwKjg
	8iPFmVcyXKj0rsX/3ziabRwNx2eOjuekHTy/vcKI2P3nDRVbAXAgGVnu6ZSK/52KhNTRphi2rDO
	sZAkIqHrEqnzmuntjAAZb4Kdh9OeAaX2DWuHsrhHdmyA6JGsnHanVsauAmHYBTF3NQ9k0PSast/
	DDjlormtSrkn1553cC0nM0dh/kURd3yZbLqR7zVRJIZ1Ct3ijyvW0HOMWM16bya5fS+ozU1/LbC
	MGtl7HkBs41x7hE8SpBGYJcWObHrrV74Tz3HxA2rxVJA69DwMu1ZuRDFo5psRsBMIBNJVFhRsyR
	euXp+RtYg3GFh8TNi4cTUVOGb0aKcguJ3GERLLbGa6LjvcvOAuMq93BDC+ZMx
X-Google-Smtp-Source: AGHT+IEJv6nitWzPBYwGmv8rQTSCRru6Koh/TEN43yqsLED45anbs3/2upqA8ege8o265otuhjO26g==
X-Received: by 2002:a17:907:2689:b0:b46:897b:d759 with SMTP id a640c23a62f3a-b46e6031de6mr343443266b.40.1759310222393;
        Wed, 01 Oct 2025 02:17:02 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3545a96977sm1335697666b.93.2025.10.01.02.17.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 02:17:02 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev
Cc: linux-mm@kvack.org,
	kirill@shutemov.name,
	raghavendra.kt@amd.com,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 0/2] mm_slot: following fixup for usage of mm_slot_entry()
Date: Wed,  1 Oct 2025 09:16:55 +0000
Message-Id: <20251001091657.19940-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D1FE4000F
X-Stat-Signature: s3i6qowgpziymucz5cfer8pnkm7ocmbr
X-Rspam-User: 
X-HE-Tag: 1759310223-859795
X-HE-Meta: U2FsdGVkX18q03A2W9mYidEaKWOTtXQlityYhDORKJHrROL2eS7xUs/QqnZfY27xjG7R+S6laVZI3PxI0IvC0um+K6sY0GOaEHC5RXAMWqwU09wpwyo8czjA8JwK5NFkg5mYUIqCoIuxcjJWfMm+2peBVqRat0+4Ze3V2VpuP45j7/NhvxLTKFZZy3Bm48pNhK2F7hcwUVq0MJBZ1S8xvmJI/xXMd4hicZ+ujJR8l+LqsSX/aEcOWiRwEZ0vrzEPLeasLxUJo47b2CiyiaQC+mhTd20/MCVgSIRm02V5bWLLsKiXU0hAi/TZQ95OInEYxlLGFX4UrAwwdv7IYkpflo1uoqsNW4EiR4HBKCTp20osV5dDKDiXYsplncrwnieJ9Om8AubnrbbmJPI67+p7MvV7XFVd4ci6sTSuutPBnxAOyOlAjsOj+A9ZkaLkJ3/8ofj75zhiu4V+VMFlEqhIBaYTcHGKyVPX2DYN1PU5LRaps1YExR8+fHKgoku+9W5+DDgB8vOG3KFJ8F4Dc3/1UleTtMt5mWpRvDHCHjkfrkX4+pYmsjjvphBYuoGNQuADZZnZhvbTMcTcDoF2yhmJGB/jhPL2FGtGQJr7TXabqu9AzaUSHIiX4Vy/3kLLCu9dRQndWGqM1PBCZsm8+ungAobBS1eoGQBQTOnEoIy6QHQzM6nvIZiibHxdy79RdUInHm3WNMcKcRPgEYQBss8fNPH2QlPMHaXGCcjwSEbtshivWEZpsJmE3gQrfGAuQJfgazGnx/eNgyxUkbhwQC0sX/K8DIi4mEzKoLMg0hDpgqVeeuj5tdvIHyoodUex+qCEhvzd64zqThATKpgfClActsd95UBcZxBY4c08a+lAIeQcYIhz+MvNFZ079c2vW3uORL8yb0GHuIlwobXx3zng8i2OskwncrMpTs5oB/fPUM0Co/ModWFCC1q2d0cskUTYWZrKFCFALuqxRl9RylZ
 bvb5jzPg
 sp9BWmphuNnNM0qzgFQ/UGiWIooGl8upbWzQHnKDyXojh9oJ0DPzYGkn0vgzC9Jh/+ZLNn1ZacFcyJHZp9pUUtRrmahAEM5n2FilXMj3dh9p4SZ9mprX8kgsB4CAXVQljd11j3Px7T1y83GAvjtMbTdCWjZCTDRX9pYiYmF7r9Ora+bd8dwGWpmlGkysOC+6fsLG+hr19mcdom8bSDBQotykjSQhSo/tjumTtDfxcZbRqd8B5MdTngoKnHF2CjcbAHftd9+b6Xypq5aVF/a9L95KuybiuWv+Jk7Uop93OG8keWRJHjARBRW6iRfW5BS/Ip05wbE1lMoJZWAijKolqjIpLOaZaw3Tx2HrHvg90kN7Ay5V9Qw8tmbDT+/95cTR256HR9kvUwbq6D/x5uthGFIq9KVmMB4rRRRh8MBbpXimyQKC6DznwaBIswJxIB4TRxpFIFVFlmqIXTIZ+oMYi/AfWsHV686NjOyF+QEP53XwZHBMlXEJOUYihVtoiNzR7bCd8tNgG+jz5wK03H2ATkLSNFdVzST3Nro+bRv3ei4rC9gbNnikQqtfHDcSJF/RkoRz16cZUMzZ5FoWDrgtQHdqibg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We got some late review commits during review of "mm_slot: fix the usage of
mm_slot_entry()" in [1].

The v2 is merged into mm-stable, here are following fixup based on current
mm-stable with last commit 1367da7eb875 ("mm: swap: check for stable address
space before operating on the VMA").

Since there is no code change from latest review in [1], I preserve the RB and
Ack-by.

[1]: https://lkml.kernel.org/r/20250927004539.19308-1-richard.weiyang@gmail.com

Wei Yang (2):
  mm/ksm: cleanup mm_slot_entry() invocation
  mm/khugepaged: use KMEM_CACHE()

 mm/khugepaged.c |  5 +----
 mm/ksm.c        | 27 ++++++++++++++-------------
 2 files changed, 15 insertions(+), 17 deletions(-)

-- 
2.34.1


