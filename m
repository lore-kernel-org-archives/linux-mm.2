Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A219D66B87
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 01:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5730A6B0093; Wed, 17 Dec 2025 20:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0DB6B008C; Wed, 17 Dec 2025 20:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357DA6B008A; Wed, 17 Dec 2025 20:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 273656B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:59:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3EE6BD7A8
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:59:08 +0000 (UTC)
X-FDA: 84230933976.30.CD585BF
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7522F4000D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:59:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766023147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=rm+M/uxyWs/iVekWljIjPDYeDjOBTK972JK/hYCgjwM=;
	b=bOmg/4KyVh2KDe15HbG6Bb8BwvZu0t88pYGkLAadhvvMKqOncngqV3nqJMcCJ3TJ1W+hk0
	JcrYxxy7NToyN7iktjLTyxfMCqhL1OIo3gAdD6OJw3MGyGwNnLGLMYq2AVnjuTvpiHpFuE
	giVCj37Q1u/4a45TZK5lL+1c5R9rGKQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766023147; a=rsa-sha256;
	cv=none;
	b=LrludQV9UyiQ9Uvd7VwAiR62cKVCx+wvyFqWVuKpQpSn00XO4VGktIHBgPlX+CSFP4u8wE
	sc9OQL6OtUmotY2w5BNkF3MoA5ks2CloYbqkCrGErwGDpSsj0GsdMhhtK3a6KBcvApESxV
	ZxHLkapF/15WmRdgDgBnE4+BHJAhg8Y=
Received: from w003.hihonor.com (unknown [10.68.17.88])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4dWv0T0yGbzYnWDP;
	Thu, 18 Dec 2025 09:56:25 +0800 (CST)
Received: from w025.hihonor.com (10.68.28.69) by w003.hihonor.com
 (10.68.17.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 18 Dec
 2025 09:59:01 +0800
Received: from localhost.localdomain (10.144.17.252) by w025.hihonor.com
 (10.68.28.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 18 Dec
 2025 09:59:01 +0800
From: yuan linyu <yuanlinyu@honor.com>
To: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
	<kernel@xen0n.name>, <kasan-dev@googlegroups.com>, <linux-mm@kvack.org>,
	<loongarch@lists.linux.dev>
CC: <linux-kernel@vger.kernel.org>, yuan linyu <yuanlinyu@honor.com>
Subject: [PATCH 0/3] kfence: allow change objects number
Date: Thu, 18 Dec 2025 09:58:46 +0800
Message-ID: <20251218015849.1414609-1-yuanlinyu@honor.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.17.252]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To w025.hihonor.com
 (10.68.28.69)
X-Rspamd-Server: rspam02
X-Stat-Signature: i6mqr1thswwbuhnj1pcawiqoe46xwobg
X-Rspam-User: 
X-Rspamd-Queue-Id: 7522F4000D
X-HE-Tag: 1766023146-973689
X-HE-Meta: U2FsdGVkX19mM9Qnl46g/DOoc/1YJ9hxTiJv9f04mRngSUck+yHghXXKcFPbFY+CaGKCgSOllvhnOjvH0vEIEVGr2kR1rPINXuStZJFANCnVVqluOxIvgXt0YEurcPbtKFDPlpTyF0wYizD3xaOZzGv9hhOJcDTJ9SJ7RlW8i3JgJveh+F/TVYd38EtPoYdwGdnQpwEwsDOgWyiOmvIs3CE8FozO7mLv0cTkEG4xC3qXUXEPlFPvfE8nXflTSv8cIHV5+yOQgXaIuuVrImAaaFnFF46qAn+mEOBrvn26SUBpy9Jxq1grO/wkdjppq/lvVGh3BIg2K0r/4q8wCOZGBLPJSDwX2lp4nQnvkItqWYGLBeqjr0LQqnUC18kBz+viyvtntVWEy8ZfF7xxL+Ga0EtXsTV2dcazj8B1BKc+cu+UN73oFMegqi1ifCUM95NWLOUpDzlWUu1LE537dYdghr456HVLk5GyhypML+/Oi97g1u63NdgXUPTkaoMIl13Qiz4TQMw7iObp5gnVet1ZB6Qp7ZI/5YJF4Ywz2xP75z4i2ckMx7ZyFQ6RnrGyxSMCsMGyRiC8zLW7Wb1t7jq2z0dZ19XH0+aCpJqWhGMzRK4PJ42QYqLHpIJiRv7T1VQg1OmmDAsWIy1qAVEMbyiXWRp0w1dmm+jPBA7PuFksHjqjTq7tT4vY7utTUW6ZxuaTHDUKbBS12fbZPym0qW1M4boEw+z98DN6lZOfTS5FqN+Hb3An7ifoty3mCNeccxHP+6RvOWdJ+NUOOM6LmE8XktW1MuXgsW7oPMNiKnmilgfRQnlUgBGeI4EjL5vqOOTovPgucpo9oJ9gnllKsdhbkNpidModCXnkygFm8Td0XpGDjjJe1y5ZosGm5XwSw8RU0ky3wYXuQ39Q5iV5lNJo5rcWJU1TL5SZhM1EFKPIjnS4VzMhDMog3DkZXVCZU+nfLTGogyrP+hwUXLoJEaM
 Vs014gJo
 9xWAQdBEFYbP4vMjtdC+mu2rBfTT+r+5ZGaY9q8GF+oiIENYAYSo2gyaPrJIFdsebZpA05j6epE/+zOpuOlyfeK/sUWTF7R2Q5YDRVo2FXtJTofEAzuEl5zP4UiMtBl8VJIzkN5Ebm3GPetgHCVW+FBVqr6IOVaR590vPl9hlaflooLtg0reZTCMMimRU+NtzkA4Ll9XABy5y1dTVa83Hd1Jfbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

patch01 use common KFENCE_POOL_SIZE for LoongArch
patch02 always create kfence debugfs dir/file
patch03 allow change objects number

yuan linyu (3):
  LoongArch: kfence: avoid use CONFIG_KFENCE_NUM_OBJECTS
  kfence: allow create debugfs dir/file unconditionally
  kfence: allow change number of object by early parameter

 arch/loongarch/include/asm/pgtable.h |   3 +-
 include/linux/kfence.h               |   5 +-
 mm/kfence/core.c                     | 125 +++++++++++++++++++--------
 mm/kfence/kfence.h                   |   4 +-
 mm/kfence/kfence_test.c              |   2 +-
 5 files changed, 98 insertions(+), 41 deletions(-)

-- 
2.25.1


