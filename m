Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5676C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 01:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EBA26B009E; Sun,  5 Jul 2026 21:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574D66B009F; Sun,  5 Jul 2026 21:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463916B00A0; Sun,  5 Jul 2026 21:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10AAD6B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 21:05:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6FE8BA0237
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 01:05:33 +0000 (UTC)
X-FDA: 84956558946.01.0ADF12A
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf29.hostedemail.com (Postfix) with ESMTP id 600C712000C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 01:05:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BIHzjixm;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783299931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOCNvl8EQR6ktCw0SI3mmPnpMy8PIkcXnPTPovWGLHg=;
	b=Hsf/CFHFSE6M7Bre45pvPzIzfSn0jSdBEqvO2UNp9LVjsthOVGFbZPWbj3YoFH9iblhg5b
	osshNkeGVYTbg3hFv5Kz+hzQ0XxfwpxO7mEk099oPL0lTzPUlRfleb2tFAs9hkaq/TTweJ
	uzwHjUDzH0AQ3jiJblhvYT8MDoUBvyw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BIHzjixm;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783299931;
	b=J9rpMRv+MtLwg2fhjqi04xvOSr0sk5hfBcP/grTvMFrg5sLarDWOO4JoOLpMSpDF91uGpP
	nZhGHb1wUi2axIt3rE5gnx7frSVlt5sSxoqPja2nyXG46cY3EkgzzKCNeiGSN/6uevTYLQ
	iXTCa4MPeX4yxoZ/sPVxBbwcgQoTdXk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783299926; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kOCNvl8EQR6ktCw0SI3mmPnpMy8PIkcXnPTPovWGLHg=;
	b=BIHzjixmIUI+RlkHWRNNp0lYZnWpEqolYlJTjUSaR9f1Xo9nD0c5RXj/W6Gpg1OLkXOmRcPwocxIzg2IS1aUFvn2u+GnqP9XGTvG0PSXp6fOCrxjZD1gOyQodelS/QXFajHtmUxxSMelQSKB43rM2p+OY2ZOHnzFGOXij1MQ7sI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0X6OzcpQ_1783299924;
Received: from 30.246.104.96(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6OzcpQ_1783299924 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 06 Jul 2026 09:05:25 +0800
Message-ID: <2b7d965d-8079-431a-bb01-2f722eb02c47@linux.alibaba.com>
Date: Mon, 6 Jul 2026 09:05:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] userfaultfd: wait on source PMD during UFFDIO_MOVE
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, baohua@kernel.org,
 david@kernel.org, dev.jain@arm.com, lance.yang@linux.dev,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com,
 aarcange@redhat.com, shakeel.butt@linux.dev, hannes@cmpxchg.org,
 riel@surriel.com, kernel-team@meta.com
Cc: sashiko-bot <sashiko-bot@kernel.org>
References: <20260705131231.1499198-1-usama.arif@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260705131231.1499198-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 600C712000C
X-Stat-Signature: n881tpcnrpe5y19d8p3ho1hhfx58szt7
X-Rspam-User: 
X-HE-Tag: 1783299930-704887
X-HE-Meta: U2FsdGVkX1+bB/c8ktRlaUNHJtRRChoj7rjbI1kwpJtDHdL6Klx8o2nq8ZA8v8JdsUqNGbs65aAYtcmB9PPPPnw0DHvSvVXyhlhiK9wluU4W0gt0+qyLX1eTPNRl6BF2COT12RtwuGCX0IH147sNB7K7dsbnWTQlx8sxj72bNss/HZmQi8W5Ue0WQgdvsF1WkGMJC2efI2bhqS4KHTW9WCg0JHe4qfSzqg9+FwvZn91sSzZvKqaAN9mfFHWH4QtG8NqhmlAP1+xUuY4pfoyA2/K0zKuuktkqc9aLTvQRnO9aNAlV/c8IXpHnaXdryzxUCpWCVDbE83f8RM4tM+Nc+GzIiZDfO9oFnI+TYd3XSCjVKP83Ab38mqz3Zkc4ZgaUTJ3O4Jj0F2WjAmoxpEyGbjzF4ZrUfn4MqCOD1eqsZSky5q8y1mYmjU7okOiLRTQDU3i4+rLZ7VGNcuE/KBl8uwI+KZfKydY6qNsBov9FaFf6c7aHIFiAnOn6MyRuC7tEpIc7HBGrEcLLEfQeB4H6ftGWnIrHJ/5CD7zjFZAc0BaC4R+bjzGUuqhASNqHKeADupd/u92wkLPeIAZHrhl3oHE1wXtHzTSvA22sp/9Rhptx1gspetAEEXwry8eSHdNYEctZ4bn3Z8M8eaO4Cm13qi7na2juy1mt6vuAoMd49IBDTuI+0QGl+QByLCm8diBIbHXWMivw6hSd4Kp4LTN2dn5+YaiQsLDypDSOXwdBWcxFtvNI7ywD2ydmUvJGUlKAObvXigY5tfDfxWa6kNZXVE6L6ey8atJNxbmNdr3IVo14v/t54RzGZnfqjJd4WuwtWmYRD4pqxxlI5AsmF9D9C/EB6vIVBAyrpx9UTLpN2Om0U0MV0cppnLOn5D0vBhyMxtIJhuA1FP8xkWQocGvWX0A9shtVEWYTdwcZVdNoCOzhelojtEMXqZbK+yAOLUupMDUeZ+jJojeOpHf1rLe
 y1hLNN8D
 hQmv4PImGbI+e5ynpkBYTSMq7UymY7K1Pb1TxEJXOD692TipNqPU8Ao7BJy1y33BzArmbdpJY6RwzamvzFY+R6vioB8jsTe0RjH1swbICfVuGP2tKwQij6Jc9Y/7cYpHcbRXdT9Bt6bT2tS2/4RJZV2Tl8X9RaNoKD0iCWpte+P1CD6fs8BTp/TFG5/l796WYpjmGTd3Qv4bLELxBsSRFqMsmuvU8sTL5eflEsFFhMtZfoC68PTRKX9qXCtyxkcbsRZyC5kUteQfamHmbcLzQsbGzR78uhvE0Nbk+DLoljBx2NPDnMN6R+ZRj2Pg45NOQYcE6asERPf6gP6yqRTOqc7w7DmmtadT6jyQE+pRlZQRjjmz3z4HS9+3uIcgnuabyV/gL5wbFU2yPD0KH6LdcGYN77jSs1jUAwaHG5Pggd5P3ahJ30gVuAYw3uA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/5/26 9:12 PM, Usama Arif wrote:
> move_pages_huge_pmd() snapshots src_pmdval under src_ptl, drops the lock,
> and, for migration entries, waits with pmd_migration_entry_wait().
> 
> Passing &src_pmdval is wrong. pmd_migration_entry_wait() must lock and
> re-read the real page-table PMD; on split-PMD-lock kernels, a stack
> address also resolves to the wrong lock. softleaf_entry_wait_on_locked()
> then waits without a folio reference, which is safe only while serialized
> against migration-entry removal by the real PT lock.
> 
> Pass src_pmd, matching __handle_mm_fault() and hmm_vma_walk_pmd().
> 
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=8
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

Good catch. Agree with Andrew that we should cc stable.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

