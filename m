Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E244FE521D
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DABEC6B0005; Fri, 24 Apr 2026 08:24:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5CFB6B008A; Fri, 24 Apr 2026 08:24:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72A86B008C; Fri, 24 Apr 2026 08:24:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B29606B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:24:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B60DA01AC
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:24:36 +0000 (UTC)
X-FDA: 84693367752.23.003EA4A
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7C45580004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:24:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=bSrD78zk;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf02.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777033474; a=rsa-sha256;
	cv=none;
	b=tRU4M/mDIfq2V+Etdsn/xY7AlxUYj+xA4Kx2ePYBaqI/sMTBzbKLTV9iK/ayQLB1gT8HsN
	yvd++JRv2dpGxFCkf0g3g2+Nusk1J0e/2BCn5YxhJ9BobRPULrVxwS1v7vn4pM009VUYh+
	mgG9xyroj1QvJ69OHLHaHA/ay2lbBkI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=bSrD78zk;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf02.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777033474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7gOUZBYoVRPaxWe4o+yvogsDm8mw2e6s7QwNm3stTo=;
	b=IhQvqHV0qF8tYQXdf70wR84Wcot5IWoFKAk0tJ/vHM0Z5O9Tid/kpqnR11lWLCfLlV111g
	p4IdJdXsmaz4BnUjNCDl4LASuoXGtfLzZcg5iBksEG5GzNP8/By638fYiThLFEguHPC+2J
	s7tssSD3XaxRBPsMFWw6CahtvGQ4kfY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=p7gOUZBYoVRPaxWe4o+yvogsDm8mw2e6s7QwNm3stTo=; b=bSrD78zksL+9G/yXC8/A6BkcUW
	O9wMV2oEqTSUawDnArmaHfr2L31kSmTyNxwOYLPCRuMVZPhgCzLz69mYCYAJE84CzN6g+szd1Squq
	TlejHmQnXQSmD+CIf5e5bUrdQDpmrogK+pctPFEcvwWZp/U5FHwl/agrfBTC4q6Soqv/IsNi2tqgL
	DD88AQZN2k1eIz/oDSSQnTrijfgtp6dJl0DGuIRRMp+ClR4L81HcM2ybCCzFZLp2sMB+MznJi9nOh
	h0GTf9xsVfNIZsrR8Yx8MGuvLUWmRAQZXKlnO5ybUt3pmytDTqvBMJY7jy1PtVn6ot7i/8T93Lgq6
	rVrbig7Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wGFa5-003APa-1U;
	Fri, 24 Apr 2026 12:24:25 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 24 Apr 2026 05:23:59 -0700
Subject: [PATCH v5 1/4] mm/memory-failure: report MF_MSG_KERNEL for
 reserved pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-ecc_panic-v5-1-a35f4b50425c@debian.org>
References: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
In-Reply-To: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=1179; i=leitao@debian.org;
 h=from:subject:message-id; bh=7lm0oK+mnNa7lcfmncY/+Y6+e7vu6VbtV0bCxg9C0n0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp62DtcfGBW7vwyPonjrr9fSNlpZBREuvDdKhph
 ZviCP0L3tuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaetg7QAKCRA1o5Of/Hh3
 bUCXEACJqvZ/QZYA5IPrGQOS+grYAiPtDz9AJF6o/NUfAJR6p6eBswB10uwO/tIh+Q56AJMhTlP
 Z07kLsY1FJaAZya2IJHIIUOF00JLN3evkX1vPWmR36hK/Jw3Ucn3L+pEsOXp3n285jXpEZvXZpg
 7kbL5An2Jzfm1oIePV3Z3it3pvrgaeKpdR+98VWzyVQHrzZ3d+SXFilMV0Km43Kr4HcG67fkpDa
 Ez/zdvSQ5K9OxhTd9BZE9iXQbHCfQew+2ZodvitIVXvWcE706C9LMVWzcPOpidnoUtj4ko2GG2M
 owqkxFMb/d+dZgCqEA8+HiOdrCD9qvlF2/0IXFLCJxZ88L8/du67Dy4S0kHMvStPI5tPzDmOQNk
 ERdni2NuoAZTn6Crw/B0sewKYhJJA1Hjz7mYdVLyLQ+T35/DCeMNXuSOlx9yhH8/e08X11dMAGl
 6HxbDlBPCXiE31rQCDKP3JOl5EHloCKhe9JbyTRYl3VhE6zHU5b8Ii/96TZfLlOuVQrSd70DIR0
 8VH3PUgUlkppx6ZzhXgG8AJyMzcQ//7VOKAdOd7TB7TVhjjLrWRAOPzkzmRx15HEfJwo3Vovcr3
 cp7Wu7rkd/HmOgFNE5KaeiOBt2MG0Vv3EvApuhK0erFvjWknkg2wiX/sraFP8XdS9dyZGWt1CWL
 DwdKnTzxxZ53SYA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 7C45580004
X-Rspamd-Server: rspam12
X-Stat-Signature: 8y8sqe8pwst3acy35ih7ug4kq8d3nf3h
X-Rspam-User: 
X-HE-Tag: 1777033474-535257
X-HE-Meta: U2FsdGVkX19cQN9tgRlhynICtqIj95QCtSuYiyUto7X5Uq0/+xpHk0kDSqXGueiCR85f2f2iizXbbeb3BTmHQF1vQ2wmIm7ITYle0V2dKioVDU4eGzgMIno3GHFZKbAExGDxTPcWdZIubRe54nJ3T4egJxv3uxVhDwwparmeqicK0tgTlglLeRpWzpVa6RGRNqmyIEWSLY8s8G540Pr11TtK4BlTKpXTKaXn/4BpEdCc9HV6zkt6L/bJaYSdQnflBlD+PBMpmmLMqHe8v7QyIJvF0vvs4FyB42i6+EZPyNdEAfPsww/eZMVDjRQFyD9UnSbrQkIvcP3GrniiSUrPr2VFgEn9x1NmjPK6tzsKt/7HjamgPUZCjZA9D2Nta8ZBTiX0XVtHaFxB7zPhuCJkpufvI2mIV4we6KD+5w1GuEwL862MNV6kvfvAbcUFMbm6xVFkuXt9O7ywL8i6ra1+AoQtEPeoMuvHnJ8bEDw7EXTNWQjk6LCR57s2fyCzIN4Ted2995HnBXNdYQAjEYkDre9am0LawMn+/neSopqKP5BNVjcu9l0BvTQAQhvUtM9qYyPAnNoA4KFAH62AfnlwFnaaiwyx3C126xVE22qcu7zfcIF4rwr/2tj8KVlDYVjwbOBxsCPOVb2z4RJLh7K+OrA8gxyTPZE1qrFGbQ93bFxNdK2VXwqOJgOjW2bbCVokUITQr5xkXs1z2Ztcpov30FborIdyPjLBfta4c4piWYCBLQuh6sJnHwxML74mkF1+rLEaNZZlhGjfCRiG2Q0z7/2qRzY4DZrmeKB88oV3WrGq0Sse1KT9QldCH+oLKX6Y7KaFD+nYCpI20h2pAugONAxiWJKd9s6qhpifynFk+ZA3P7d7PNS+aTdA4ZideH9di7MXBEcDgOj/vUwBZlIH5icU5oL4zAKcUyAJzk4uB5gLRC9ImaKruOeLhkYT05+k/zODOx+ktOt72w0efRE
 r7kvEnS5
 Y5TpjuTugcvlFnb14rQ9W5h6pnL0vcdyeSxd4ycdfHQ7ggGe7K0WSLHATlfBImsBP4OFvYBsmr/+xgb8ZcrWbuY1QEbvSYzP60xp8hB8PGSUBK4PXhTkKbdZOndRXeNvbNElPZEuHrqyjUq0sAUfqCSsd3wtX802tEXt06YwytxvaJqP/Si+z/o9pexhAFjj61OkaXa9YnFTK2OWDlj9VfLSUm1PYvvq4AngnbM3XqJM5lrf5MyUOV/fx06nxdufCfxaZNja+BHDQs0AaH4PGBUzP3LDjs2CTyODCWhkYBaqVUKMw5p0ULn7qYmCAol25lP0m6yaIFcvjZDjINkRhC6BQ9lP5sp4Mm/S0aU5ZKi0lW5LFpEVZLt7Oig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When get_hwpoison_page() returns a negative value, distinguish
reserved pages from other failure cases by reporting MF_MSG_KERNEL
instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
and should be classified accordingly for proper handling.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d43613097..7b67e43dafbd1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2432,7 +2432,16 @@ int memory_failure(unsigned long pfn, int flags)
 		}
 		goto unlock_mutex;
 	} else if (res < 0) {
-		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+		/*
+		 * PageReserved is stable here: reserved pages have
+		 * PG_reserved set at boot or by drivers and are never
+		 * freed through the page allocator.
+		 */
+		if (PageReserved(p))
+			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		else
+			res = action_result(pfn, MF_MSG_GET_HWPOISON,
+					    MF_IGNORED);
 		goto unlock_mutex;
 	}
 

-- 
2.52.0


