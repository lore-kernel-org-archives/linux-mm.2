Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C46FAC4452B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C65B6B00BD; Wed, 22 Jul 2026 23:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876E06B00BF; Wed, 22 Jul 2026 23:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E1E6B00C0; Wed, 22 Jul 2026 23:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C83F6B00BD
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:08:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1195A03A8
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:08:19 +0000 (UTC)
X-FDA: 85018557918.17.BDEB3F4
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id EF76AC0002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:08:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oeTLMO1b;
	spf=pass (imf10.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784776098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8Zz05wCKFzzF+ciP95erphYzHKZwgsI/el6LqogE1p4=;
	b=tAVImfR/n0Q1jyje4OzYvp8n2Y2+Bf0F1XbAVY53n+ibtubLTVyndxsBpAuzJ1R7orBshG
	s4ZU/CnEiH5JGeSb7WUwfoN9gVQOd/p0FN+GnKBW+v3bjEsFiTE7fyCXUyV8bhWBZxHzUY
	SaMMZ+qejuEm5ZHm9S/g37iWTcPKAWY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784776098;
	b=7uFja0Z2LQdZQ9XmlFF0V9LeFLb5iXlbnnuuHRMDy7zpW0TDIiqpBdMoP6sKErqoMuYFtz
	9eV3D+nQMQd1ABlC1pmNzdguoylxAi/KDINmfVVv8Bw4NlpDO7oq0ePK2N+PlyDuTrUxzK
	9qqoy0p5wA6l/id+u+m2UYnxwkZmi8g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oeTLMO1b;
	spf=pass (imf10.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784776096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8Zz05wCKFzzF+ciP95erphYzHKZwgsI/el6LqogE1p4=;
	b=oeTLMO1bRbRVs/+iyKqBKgZVSEuHswyNHKcHDd9Lwll8hBtHGnpA7xtrxjfhWUq5W7kEFv
	TzXlW7WeAsfWBWarCzLEKZdqAf+zCWOscARjEieJ++SjRo8tkx2auzYKUysPZa9xSGbgyi
	aLg3vUqU7A50FrE5qBCDEWtSkZnl0u0=
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v2 0/2] mm: folio conversion and refactoring in do_swap_page()
Date: Thu, 23 Jul 2026 11:07:50 +0800
Message-ID: <20260723030752.16979-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: teqnmy39d1xu8xb1sdjuqzzq3o9oo33b
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EF76AC0002
X-HE-Tag: 1784776097-676544
X-HE-Meta: U2FsdGVkX1/Rc5kdrHlOoJmdiLYFTeFzvqAVEqMyXKxwhBokCTc+UFaLNtubkeAaZUBd87sFDiZNLpWS31krflAQJXKIDT1qNsbxWtBLTXrHxPVJ29a1o8h4SMK125tO8ZpE5A2L3IoBsjbCHVVJs9LFeCqFHoBDz+eeSglZOOJlP6bft0zRIQ07qQdP769Eep1c/5f31j3+eg311DMjj5prMhEO1+8YrQaIZMK7V2eSJSc+3lKswyIX6X3ewlDFzlGCgNUowyfDeBJAXFFs2g3tH6CO2Uxo56I7cpdM3FAm8krO1WQluU5KBZjsQXPYGjtL3EDjjvkMmxV4f8yCrVkCg15FP/v8XKe9eVQKOkmfh5o46vJPBiv/2NN9oevQGHGTJf2O8UVvB2l4fNtZbM3w2hOZbRC6zNydsixNevD5YOsTx44ocp9fsaZQZkJMbsIp9V/7kbPRTLq7043ewhgDFQ9yRH8CKFe+iVmrGZ+cqglmK1TabAWuRWTB5/RtLJOnrJOISkiLTEeRHa76G1rF9QGjQX+HB4B/7KQ1peJI06Tj/ScWX1CLCiSHGljvA///CdoeroDzJMQYJpaQexDzftM3xyWDe0LztNCpN++RE0ujll5jyzUy39q8sLWDLMTaNOAOKyKrjdWLhgcNjvvVIU/+lqTBxs4MB1NAS9bJKD3uPGgkfX5BlsEYzqItHYe7cW1pEDKubIdoYJx3Trc0IqVHUjGiKP3KWv3kC7cHla5zQGqzz7/OCZD1UmVbZHPWdeqrP4CWW/Ca6a6W1N3UfZYyNcuFzAnoT/6rAPu/+r05v7HYU4yKOaQZc2Rwm2r3d8uRh7yXY7VtHYhtZUD2UP6jXc1+45Rr9JcOU3gxNzA+UmxeySoww0D9D1ME/KoNTIuuiN4TuVxZXH1Dg6uKBDCOQKA8l0AnIy85LSHb6v3IQ7oOXZ+T52CyaVK1eMEyBhtQV1F1a6qtRt1
 1hO2mN3a
 CslAU0KOCfUEZV6u5Nkha2uYAQ1Hh2qIy+D9sKhkAFFamACWrn4PdBxyRvAkuo7kxqiqCqklBFXj5zSuwSzZsXbm53GlTldZgjHynW9aX5uztgb7WX3P02aj8GJ/cufbO2JnwWV7XeKC2YL8NSb96EU9ra29nRB4fYdhzuyyjubeFmQSyNmStnfJWLTkvFSXtWP/SXaueMNr8rRgg4Aqt28jq7K95bNOrdkOc9FTDMWakts9rdFMQiLbE7NB0BPu7llvM0QDKpu4B8ZemIKIfA6QooQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

Convert the device-private migration path in do_swap_page() to use
folio APIs, then extract all non-swap entry handling into a new
do_non_swap_page() helper to improve readability and reduce the
size of the main swap fault function.

Hongfu Li (2):
  mm: Use a folio in the softleaf_is_device_private path
  mm: Extract non-swap page handling to do_non_swap_page()

 mm/memory.c | 119 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 50 deletions(-)

---
v2:
- Drop fault_folio, reuse the existing folio variable instead
- Refresh commit messages
- Update comment to use "folio" instead of "page" in the
  device_private path
- Add Acked-by: David Hildenbrand
- Add patch 2/2 to extract do_non_swap_page() from do_swap_page()
- Link to v1: https://lore.kernel.org/all/20260721013347.65698-1-hongfu.li@linux.dev/
-- 
2.54.0


