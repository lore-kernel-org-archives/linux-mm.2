Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0991EC61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F027B6B00A7; Mon, 31 Aug 2026 23:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3116B00BA; Mon, 31 Aug 2026 23:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEEA86B00DD; Mon, 31 Aug 2026 23:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFBFD6B00A7
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:18:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47FB3A02CD
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:18:23 +0000 (UTC)
X-FDA: 85163735286.07.7F6254E
Received: from mta0.migadu.com (out-244.mta0.migadu.com [91.218.175.244])
	by imf29.hostedemail.com (Postfix) with ESMTP id 48662120008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:18:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iQbqfgik;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.244 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232701;
	b=8QO0jF6zLVNmdm5CJFA11m35wBdcGZVESwGrc6Gw40fFzv+RiinGi6KmXDp88wVBDBu0Va
	rq56bIRMuMc/QdH5rvPbH6CetJOYk8ChWmUkEwjTkkjQqQ7pYRiDCSP4P/va1Jo1+gCL2L
	SAT3pAtO62rjPP3jG5M/yg0ZphsL0UM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+uXxSLnSYb27jssXKT5e6hDQG31Ju9yhWfa0Ltirbfg=;
	b=7PWlx9AFQ1KdFD8VLc2d4vkvyZ+oSkCd38JjYtE+IDRtJgUGH28MwqlDPJTmw+BEEUibV5
	G0OaWDgHDDgFFmJ8++/zBlVJRPZcXHoaNulqgY7voG7xFouf2AcW5xS0W0BM1O9GwRQpU1
	xzpmlKm7YDYovhL2J+hicLmHMfEvfX8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iQbqfgik;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.244 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+yvmAaiXJSQhUiY43hR2AcbPXHGoUIEk5aWBZqakNg0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788232699; v=1; x=1788837499;
 b=iQbqfgikHpVpyMUUAMrHyUTlOaqZLRJR77DceWjUfb8vdHqANraDf/0tu3DdPGi8ibjxO5PH
 ZBY8IevQGiEhRdzi43/7Dl7dQ7HElvS6FHE63AoRFdOmr4mdBdaDh5Bq5pXKhI0PkBDG3xUQcC8
 DDGCKvrhqABzi1za8Zqf6tQE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5a2cff3d3a7044ca;
	Tue, 01 Sep 2026 03:18:19 +0000
X-Mizu-Trace-ID: 5a2cff3d3a7044ca
X-Migadu-Flow: FLOW_OUT
Message-ID: <56119ff9-26f2-450c-bff9-8a4169027ba9@linux.dev>
Date: Tue, 1 Sep 2026 11:18:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] mm/sparse-vmemmap: open-code init_compound_tail()
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
 <20260831075342.57563-4-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260831075342.57563-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48662120008
X-Stat-Signature: rne95u97gdmjogtpyhrqam98ojjfttxw
X-HE-Tag: 1788232701-467682
X-HE-Meta: U2FsdGVkX18GrXaSJgLjoy1Dsk9o2/03OiY97FOUOsyneixIa2RCfhDQDa/Plqc+N/feQLpdwhBOeeTNaSxtCqI6hEISgbSUqssBn9oFiU1q90L5S7O/LEMFvOAfy1NF5+PDRQ9ALSf6qCdFVFKovcjMLeIvfg9al/S0tvB6ADGpYunE3Yri8jTmaIVcWdFh9cxSTRpR3CmFGEqaOq8jCJXAWgnRmz0GuPaG0zJpZ/yHoEldKlMTkNMJLPXzpuua2Rbw9ymwZuWputv7ULaSimvQ6id+pK7p6psOvLTLlgxA7A1mh8fkyzlaBoBmcazCwgehIW6wEk6tfrSKc8/yLRVt/sV4lOFWxcIrGspn5oMjx0LDxOxZ0FbbkGc+ycrK2TFGnL5afURrjxkFXnOvNQ4LtI/jkP6gJsvC+MO2ocI+F2hLgmtTbnCWM/EOyDq2aM8dWDYB3EGD7UJnLpW6QvgdK6nS6H/C0o9oOniFB6BmtjWRcZjAu8aQGQhUywaWW7bnr/jCCqZIxLw5dTc9han5vDlPm3BYbx8rZHil0rChlb42cTulYqvu89RiChclDGYYrj/YM0JxEW1vn/0qfLrzfwWgIsNPg0e/g6wXe8SpfyiQ4d/53t2WJYfox3aMj8UfcjD/T36sd6hks9Dapoi+H8TZdd2gEDMAZHqb1BhvorbnEqDz+KP6NVXMIx5h6ZKdKRMyGx7/TVb46drp/euw0vLI2jMtrYMTp2auGRDyz5YKKWHzHpzfkwBNErVkQARv5nWksTxgjaqDbmr035cEqiLLNusw8bEuICI/5scX9cxE3feAd0ezWB5ZUWDNv18bULlqgaC/DXyceWNjxW7h4wtGZbNHS7gQ9h6c9WUZBT6e6WkX1vG/4LT++1fffyXsWG3AZpC7zMHc/q9Xu4cXlK7kgtw4r+7GULoYbnyWO8/hOe1uNQTcSv3RAmc17yLy5yULEAPzPNAnuTh
 kGTTho78
 W63fwG1ORDX1R3SQab7TkmPcyimE5yXUmd6+VQsTTLUQcl4vhAEB66v2Z9YvavxpgbBYBj05lmNqAEdpPNOTRXTtnr/zD+5RxYh/6+H++2gp5AWqWm60fr8gOW32LHxIv0l3W1IeDFmHOrZE5gxgKAeBbQZmTjj9TT47wYJIpFhP6sNMv06cGpBjS8Ouv38Hj+/cEga4PA6l2bNwmoyu3bqD0/p5Iu2pjbQeBvrvsR4YvgQWukCRoSydBxxK3LphqIYJk6qSgPNYw6ggtU/fFDnn9vyCjfmQZDGCx8da8Z88bMsbGhsXjL0hts0bTjUgDzmU05y0n0QQVg+Yz1z9jQIdQxZjr/oh17H9U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/31/26 3:53 PM, Muchun Song wrote:
> init_compound_tail() is only used by vmemmap_shared_tail_page(), where
> the shared tail page setup intentionally passes NULL as the compound head.
> 
> Keeping this helper in mm/internal.h exposes that special case to the rest
> of the MM code and can make the NULL head argument look generally valid.
> Open-code the initialization at the only call site so the special-case use
> stays local to sparse vmemmap optimization.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/internal.h       | 9 ---------
>   mm/sparse-vmemmap.c | 5 ++++-
>   2 files changed, 4 insertions(+), 10 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi



