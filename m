Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED190107526C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 387946B040B; Thu, 19 Mar 2026 03:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3385F6B040C; Thu, 19 Mar 2026 03:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2276D6B040D; Thu, 19 Mar 2026 03:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 140F86B040B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:12:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9705B925D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:12:25 +0000 (UTC)
X-FDA: 84561944250.06.96E49F8
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id E223380010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:12:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bDZsWDQL;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773904344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gc1cC4mzj8DKUjeHQ7B77RqbJqPY4RP3mNQb6Es+S9I=;
	b=ZWHK8KtsczNmHg2yEhM6rCjMfh6JQ6OF0qkn8aTCXgndyiNtJNrb4IJMyok6jU0Y7eSHuY
	yzedq4EI7CVjKpGz5kmpF9G9DpAj9XUboB/cA3X+WB48MpqBstS1qqu3cFeBXYlNUj6UP+
	CPKKEXA/OrYOIGkc2Ol+TL5qQH15x3g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773904344; a=rsa-sha256;
	cv=none;
	b=n3xfUX+Ari0hFq9SpeZm1NNhxxverT9ToUZhpRQkF5lLeOrtNhZECwDfrL/Gw+4XmNUyo3
	iT0lz21XxODuVhaMAsmdtTscBZ5XuRfqfneIDCYAAGJ18V49TWfvvt63OzVHTUWS7BW5e8
	m6JslTkfBn5lcVq48nIp9kALB2Q1vbQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bDZsWDQL;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773904339; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gc1cC4mzj8DKUjeHQ7B77RqbJqPY4RP3mNQb6Es+S9I=;
	b=bDZsWDQLBDeDN2cVYl/vDLE+KPHG+vSEgH9B5a1GTwnzB2HXji1OziSZA8WsXeOa9P+cowOG4vLv0cIZfUCDZuCIS0NHBjuqDax7yF4UpsgDtImNysehTLzE80Sin/ifFWKqPFEdTtNdULNpedDeVOX6P3Iw/Md+NZUwYEO/shc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X.HWEU1_1773904337;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.HWEU1_1773904337 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Mar 2026 15:12:18 +0800
Message-ID: <07368afd-05c3-48f4-89a0-c1349784f62b@linux.alibaba.com>
Date: Thu, 19 Mar 2026 15:12:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] mm/huge_memory: remove unnecessary VM_BUG_ON_PAGE()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1773865827.git.ljs@kernel.org>
 <56df2cf900132ae12e8b71ed95519b5b476e1618.1773865827.git.ljs@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <56df2cf900132ae12e8b71ed95519b5b476e1618.1773865827.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ojq7fiemzfakh8jusx7zyo9rx8eqizdj
X-Rspam-User: 
X-Rspamd-Queue-Id: E223380010
X-Rspamd-Server: rspam12
X-HE-Tag: 1773904342-69805
X-HE-Meta: U2FsdGVkX1/0xVBKF3DudY0Fypz77285abQ5DR0IAIdNlCvhAHTmF0Q8ahbJScjeNAD2+yN0CAHttMzE2tcgakWUbpe2g1vUWTr/iRfH7V6+/iKrUsbjMJZDCeUz+vCQC0+mGzcnv84ZsLxppshCpfjkDA/HnmZCD7X/93HFsgy5mia9eFqGyyFyt27vso3pCJgX0WKyzj3PNCn6Zzh09tU1PLZt4PESca+XssCHCtjrOrLElk9o0lBzVErjXSLMhP4eQnIjkNznQ1BFPR/+aRlfnrl7KFOfxBJ6Ecst4yx5LyHZjyvwpP9ibd0Huca0mWwW8+FFoygAU0p/atyhvt9+iseHoGRfYSWFNxMGaClYtG+fOrN/xBT8abmJfSE49WxlwZjzs8OatVcSo8A+NVM9lpoOAPSmFVH9hgBAYqXTUfsEVAqphP42E5echciTIwo0xfxpzJ77HniprfOcg59uPe/RyPRpxHit83rOS8C5kKVtzJI/PI3l7ttp+/EPXXaOBQrc/c6HddZMrKgtrSENIT258jlfnbzqqlHU+crcbqTHjWJQADZQVWPkp4XRRKj1TE1wS4tkKtErR9PnPLj2z2g3Y9YcyGomzZT8EUOCfYzaqgxadMdMhQ0FAJbQXRkTyexhvnDbd9e31mPbTRokrZGvRBX0Ya7Jt5jIDxWTjEY4oTjPWV71UxGLnSFHpQoQi8fr+Hg92v2QH6vYU9WWMaibuN47f3Gpuz3Zr1frdk4PwtqsloXu/aM/0ggMLQhuhpsNlrxnlGyy7czLchVF4kyl7zM6tuLUzrO55msvprjtpsp0H9w+VU13SA9cVVjP7/LaGEmT5f4tErlypWWJFfHPcM0YELWG7gN68xDqXeZPja8wFxge34TSq4/0P9DDzfJ2szPSuqACkJEVBEyHgW01OiclYuZU/hjqUcXjxMrEJJcRh5+jiyoTEZViQVSwSKgBKWYa6xhWAn9
 JWP0CxfS
 zlNSgpJlZMug7dmK44ngfW6uRgGTcnS90tnfvlkgLPOJ1GfskA1dzxQLIbG+O/HxvWD9cHJRqcyXjtYchdxpurwGGRvgd5FnMLkZVYrWrwUGWm0ZgW0PvXnrBkYbxKFIAZWgLRDq9+fjei/ae73ZZ9U0FFPjnOd6zvzfbSTd18akIRawbVPNgqzLmOHL/LKLvUPizaWAY3bEcfZpu8Af/zheaeYje01zGE88SXIBAKVGO2LYpPki6EvnJd4wANn3+LRJiYxhNagVzw+sHaut3r+GYLQ1VoB8moxgY92HXFcu+2NS00U2Vtz+mmEVqluYFepxTBzurl8SiifY94LpoSpsA2ULDyMvyGiTNg8SC0pFZJPhdjxUzzSfPhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 4:39 AM, Lorenzo Stoakes (Oracle) wrote:
> This has been around since the beginnings of the THP implementation. I
> think we can safely assume that, if we have a THP folio, it will have a
> head page.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

Yes, it is under the PTL, so the PMD entry should be stable. I also 
can't think of any case where it can be not a head page.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

