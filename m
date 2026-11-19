Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42759606A338
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 11:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ESeamVz8
Received: by kanga.kvack.org (Postfix)
	id 338F96B061A; Thu, 19 Nov 2026 06:33:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B0B6B061B; Thu, 19 Nov 2026 06:33:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B52D6B061C; Thu, 19 Nov 2026 06:33:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E81FF6B061A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:33:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AA60A88A9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:33:33 +0000 (UTC)
X-FDA: 85451658306.25.34F7D28
Received: from mta1.migadu.com (out-216.mta1.migadu.com [95.215.58.216])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7A16A20007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:33:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ESeamVz8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.216 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795088011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KX30YIKysEjviC7uy6yBrw8ek3mIvfrRCKEIHjpXldM=;
	b=sPFSUX5L2YWb27OyRkXFQRRwOZWyRvyh9erW7p/DNgUFXm+iN2/hmAhRLUrHmT4qwCznPJ
	j000qYlKkCo6/tgY7ejagOSnLHz4n3RP6lQQtRbKKksAsvI6Nfp47GaAWIxbosdfRebaVm
	CoCAjHmSFJ9CXC6KT0DiQaSYL4iRb6A=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ESeamVz8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.216 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795088011;
	b=D4Wot6nTn4wjzAsY+7r2Gp4JSMulDgl5aYYToC5rHTvWFpHHrVBTydY9qNKpBVDqP1mFrc
	4wEuCMhUIu+DB1kUtiqD+HC7ntNvJ9AaUPgRTOJnNylw++CDkfia0GHornavSIz7we1Wqo
	AjGUYkxgyZgE9Z+tTfYAYpn/ABmWW0c=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KX30YIKysEjviC7uy6yBrw8ek3mIvfrRCKEIHjpXldM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795088009; v=1; x=1795692809;
 b=ESeamVz8o8JMhOQKuR9+pstKHBaOO66+irTjF5emMOmb5pLh1EI0d7hkcqXn0y1WcphXdlwS
 EWMox7W8TJomFdA4529f6F79N9qHFOp0AofPRVmWbVmctvbTgebo1CuZeJh7d4IRCV+0/zFaXlL
 iB85fKD+GOnNrjsGq60aaVQI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id ff153b33dccacf45;
	Thu, 19 Nov 2026 11:33:29 +0000
X-Mizu-Trace-ID: ff153b33dccacf45
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] mm/mm_init: don't subtract managed CMA pages twice
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261119-cma_managed-v1-1-385751505e24@kernel.org>
Date: Thu, 19 Nov 2026 19:33:08 +0800
Cc: Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <11624A25-E7B2-467F-A617-21EE56DFA722@linux.dev>
References: <20261119-cma_managed-v1-1-385751505e24@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7A16A20007
X-Stat-Signature: fgh1qa354cjrizmtqyxnra1zp7jkjth1
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795088011-899769
X-HE-Meta: U2FsdGVkX18uRk6ppsgMZOMRDNDN3HYwFCytVaJXg3u3p9XRc55bnFnaq5q7xufai9zYBWD6R8J7KUxeB06eU04fOG8yy52hUmVjCfXelYa1jtTI/h5V9UQKF08q/JkhufGMpq6lSZ+Te4v/SvlL5UBJ+jtYsZUbPFCwEN15vQhH7oK3uMdcgCNonQi1fCb+F/nhINgedCxC9n4jsh8S9etkmQ5PCI4MC6snqHbjL658fx6xiwaXP11SostqQ4fOrOjEwtmjkT7RLp1i++h16Wu8Nc5dBwUY04l85KE5URpy2YgDuPuQ5dBqOC/VLP3qTMCBErgNSv3H1C/h0hhpC3CmYYldFb3/xrFxjv/hESIGIaUQ7YUdalm4JmQhEqPjgCUNOtIHtkXnKYvtTkliStD9XEzc4RL+FJDRSgrFEEUpYJAGbr52SobZTcyyW1n2FxpCvWMNHI4KZDMBK9qlP/sAIwdRfs4mFF8uRrw/x8CPrXZNdrBR9XdE5wCkRh0GJ9bcg0LcUaJP32EfT9Pv0X0XYsQ7kZypqB+EkxwiTQdHk6iucWWEfeYwRawz23FkCnSwxmhESchR+0ZBtzn7bBtgufY9i3Hdxza36NobbaPbWvyLeIlzD217sQLV9VXOAl0VkjKnOXVnFwbDurABSr99u4H8NukzjU6rAhiOzPbdccj8SYzySNG2jHgb1eKiYOVXf2ZjcxWzDYjGgyUQddZuUmLoMoLytspbt0EwYaecd3kcX3XZ7LhqaxPFE1ldwkYBKYmoMI3ZKC6t0zuJDd5PmCfFSw/VX9+xVpCVRq/eeV/nHZ1mVq/yIajXeqMK9DiQe2NlNSvFJFVFMKypSmkoVvpy5hoo71Mm/YrXdh6cfDmkfGWPvcuRs04EnSNACXbVSr/yipy+jzsSDQDLpdrcgrs6c73dJ3uXspA9EdFuT4pI+TbtVatOoGXgbAyJDf7jLfm1SZDC13+hexe
 GezrctYX
 sM6IWwC+ST0jyZ6wLDDRg2X8U9wWTLKVW7/1g2aslNLhmQudH7jZgHqNSMkFk/HAUaH/nGQ7CocCLImRwNFnaw7/geaMctBW1Tde1HuBiABZ0GKNzLxwLn2HM5TnF1sLihvlGyEF8wJ8LM/y/dObHI1pTdZprs667m0LgVO0/DIQlqcYFM+IPHd/QVPvNREwCNpbvUibnuPmGMFj2B6GWWw1+EdCoOszmlY2cSHM65NtZYDKLp8zRzglUu+R1luDHeo1WqZNIXzjA0vVJy/dZfN13Lro/j2xv4QUXtbaME/F0VVRwwUkCuQYOvTx3jxnsKCTTLqvQtArUyU2+daZLDskpyxUWIe5wfh8eXZ+q+8u5DJVWCfhoGnMlJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 19, 2026, at 19:19, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> From: Chris Mason <mason@kernel.org>
>=20
> With hugetlb_cma_only, the "reserved" value in the "Memory:" boot =
message
> can be wrong (small or underflowed).
>=20
> When mem_init_print_info() calculates the reserved memory, it assumes =
that
> no CMA pages are managed yet. However, some CMA pages from hugetlb =
might
> already be managed at that point, so we end up subtracting them twice.
>=20
> Fix it by only subtracting CMA pages that are not managed yet.
>=20
> This has very low urgency, as it only affects a boot message.
>=20
> Fixes: b1b7c045e808 ("mm/hugetlb: initialize gigantic bootmem hugepage =
struct pages earlier")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: improve description and comment ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks.


