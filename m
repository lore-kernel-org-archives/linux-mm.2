Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7EDC606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sXZNwqIa
Received: by kanga.kvack.org (Postfix)
	id C534E6B05BB; Thu, 12 Nov 2026 02:25:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2ADF6B05BC; Thu, 12 Nov 2026 02:25:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6A586B05BD; Thu, 12 Nov 2026 02:25:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93D2F6B05BB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:25:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13E8F120507
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:25:51 +0000 (UTC)
X-FDA: 85425632502.24.CCE9309
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf27.hostedemail.com (Postfix) with ESMTP id BF2D140007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:25:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sXZNwqIa;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794468349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gcbzg60BUmwgQefKURo3dOVz/J0aYIf5oGU7VN0hQhc=;
	b=aY3UzeCgILw/umXmnUOk8hEqIBwBe56m6cezgPsQ9cnBV77d6l9NxTRzIOdCBm0wrwo//f
	dUibahoBuUeoOFRZvwfSk7ngNG2WYSEM4R0PdbVTdmTkTt66ee6zPB62UJaR9sIulqSHBy
	e8cJVfYhBArN3qF95kO4wGJ+TOIdMnw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794468349;
	b=tjAor6IUj4i0zDrWDIBnEUwnpDiMIktcfSMmv3V/m9IDwDJO0zp6iteTFgvuMBKF/1PVko
	4AQyMWsg+dBQV5p9rPvhJ4wRLv81kfHzjxiLQNNI2xvR9mQX3yldwtTaEBVUI40rm91gn/
	H5kD2cR9aTS98JUASZwi3LwK5Qr4zpI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sXZNwqIa;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794468341; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gcbzg60BUmwgQefKURo3dOVz/J0aYIf5oGU7VN0hQhc=;
	b=sXZNwqIa92f9Bzr3TecgccK1462rTpZ9C9H8dYnzMSwCrI5nM6AwUx+asuig7w5o3iH+4xvjrq6N0xVp4pMurfBk8naZH2ISPXYXfjFPXeUHwzTpmdX7ZIUZ/wH9MMHpge8Ref7Ng61AbVIdaXtA7z3mBS3ru4ylQd61k3iGIcg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XEbCMpv_1794468338;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEbCMpv_1794468338 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Nov 2026 15:25:39 +0800
Message-ID: <c31cc8a0-c098-4784-a843-f13f51914094@linux.alibaba.com>
Date: Thu, 12 Nov 2026 15:25:38 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/rmap: fix PTE table overruns during batched
 reference checks
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Lokesh Gidra <lokeshgidra@google.com>, Barry Song <baohua@kernel.org>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org>
 <20261111-pte_table_clamped_end-v1-3-2dbe339c487a@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261111-pte_table_clamped_end-v1-3-2dbe339c487a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: thns1h7yim5gaenwtdspmrnggz5b1sbm
X-Rspamd-Queue-Id: BF2D140007
X-Rspam-User: 
X-HE-Tag: 1794468346-634685
X-HE-Meta: U2FsdGVkX19rRlQZfXVqjYZSPn6AmEyj4XYdVdJ6ZaZc0zTp6GvQ5qxZJ8+Y1lhMsyULhTPTFdzzgWe9Ah8PVMlgMaFTWGm2oaCSS7+Tu42Q954pLaLNiDBXtl4VYTAnAG9wuDY/3PLdliXqMXMYCF/i3D6KDuKc4dJ8O5xpGCktKp5ydyHJ0XQh9+dDBhj/xotYGt40L8lSqsFQAVlg9zlkFN+sh/PkiEvNZCK/VXXYUCpSw2nRuqpotV/X7ujyZWNddKuzLyhkcxpGhB41pdzQVZpBsUHbxZo6xP8luiIK9wU4OZo3TkFCquSEFislpqulD96z3h4gIPVZcwVHefLC8J+ryi4NbvpWsJ8cwNBeAUcBRPw8N63p+Bhm/ymZWCFN9BJc0ffw5s+9Xv2UyLhH1IT2kbRqcaDhTCFBB81aAkovcCMkuVN7iQPq5Bik55oSCA16kcpWcqf9u4EvoZg+k5g/3SWDhp3ArnPTlfuwwlZ9lo0dMr6OT7JZCJ+ix0xsv5/sXJQPyWKrZQXTea78WBb5IAldXyLxkLq/mmSel3ELSSK20E9O9FzEFpHvYQ9dl5pyR3dxS5N9f5SLF9o9nTQMfLSo5TGpXd0SCOYSAcDQDfss7ZgQYhS7O605rUngpIvGuT6mGYhqJWl/ssm3d71J0/5DpHxQQ7whmhg8hVXNx1RUBFXl5AAYWKsTnOx+mYXUKvAuIOdTlugQ9SrkH/E6Oh0CpydFwVxdZm+Z7l9hKNcgAo5gwCX7gSVQvdWmNRFTgXuqIs1l8pjCUfsKb8kTMMy2p33R+jupkiHVezQ19FLJn29GG61sADMCGJBY9OUI4B4wav3eMKLwHyY0Tb4RuuCSbVuVYDsJKw6HbZUa61O0NmEm/ESBK9mNtZMav4ehWhmcGNSTee0j3Ywx/1/vVhmZ8Qmjx5S/DFdsOX771TxpX50/CEGnFptvVFksK/IjpFWejUuT9Uf
 +8mgGfJs
 kzq8eXdAtXRzHv0dTemifFIUOY0PLndfl9MG+a6kmvFHqcUt70X9uoPdIpjLUWMDjcsbk/mwf3cBa4iAqIEKnm7I5rtaL21j1cyu7raNvTYRUkYvyQ8TcwmgfqIZrx4G5EKu+LFCMjbEHAUmeg85NakhVqHXhAekCy2bVVRvAB4cC5Qw5IglauYi5uTmQD+KpTdhpuaDfkgXWvxAeDVC0hdkZkfdfC9134LJIsHaGTKzfz8O4cMWM8n1Dt3nAEUuj8nTgF+kZVaTDfjubT/J5SBrCzFUctN/uRfIqCvi6dgqHtddZC1u66N7Z02WbgWJlfuZDyvOW0IO4vuiF5YuqglR5bFah7fCZncQy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/26 6:00 AM, David Hildenbrand (Arm) wrote:
> With a folded PMD, pmd_addr_end() simply returns the supplied end.
> folio_referenced_one() can therefore walk past the PTE table when
> checking references to a large folio.
> 
> Folded PMDs are uncommon, but can occur even on arm64, for example
> with 64K pages and a 42-bit virtual address space.
> 
> Use pte_table_clamped_end() to clamp the range to the PTE table and
> VMA boundaries.
> 
> Fixes: 52e054f71840 ("mm: rmap: support batched checks of the references for large folios")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

BTW, the 'end' calculation for the batch operation in 
lru_gen_look_around() could also use the pte_table_clamped_end() helper. 
But this can be a follow-up.

end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;

