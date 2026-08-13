Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 091F2C5AD5A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 00:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F36BA6B0187; Wed, 12 Aug 2026 20:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0E306B0188; Wed, 12 Aug 2026 20:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4B4B6B0189; Wed, 12 Aug 2026 20:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7CAB6B0187
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:16:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35C8CC043D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:16:31 +0000 (UTC)
X-FDA: 85094329782.07.793DA30
Received: from mta1.migadu.com (out-162.mta1.migadu.com [95.215.58.162])
	by imf02.hostedemail.com (Postfix) with ESMTP id 130D380003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:16:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ix61Dtv5;
	spf=pass (imf02.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.162 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786580189;
	b=Q8+dycuxyjblwmCes35JCyLVQkstTYAa2bK/OqtU08MiXzwxTcC01o+7AVvPuwdBttPpJo
	j0j/2t1doAUFqTpAeqBdTsVkf3balWnf6n+Ze9P8sBxTvB7JAqc9M34teATcwX2tLDw7bx
	rUSD0/au9qIXOpmBPrKyWkCzBeZ1JxU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ix61Dtv5;
	spf=pass (imf02.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.162 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786580189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RM1opCt3bTMLMVAQOm7TTS6elHcJpQ66VH70ly0+eJE=;
	b=XXR+5UW5+Dl99MZ0GeGa3UGWfEtJb2GAP9g5mKKuqwCSVzv1MMZh5T9UiOJbCT1IkONrs0
	ebN9aT9cy7p34shZHCoWqbHiM8rgtWk3w697T9CR9Hg/ypOdtPEjvwis9C2bpY9KrPHrYW
	Um7mv9ifMDn3hGXpsKfwjEDdx/fEzno=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IGDc5JnDlKO6wxRHzSc4CLcLw+wBmIxrqKstmQPFl8M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786580187; v=1; x=1787184987;
 b=Ix61Dtv5X/Chlc9xhIQNZDPdnyocCmaNcET4Wv46vwkGx9WACBqKDn8FBBoAbkYTQIu640KN
 BW0XItR1CzG2exljehKuimhTexQz1NCuey+x35mLVfCaTn9DihcR/Z7SirhG8d8jo7Km0Xz37Ll
 6KStQ2gjoimhYMWpGow1/Aug=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2601:282:1e00:c920::47f] (2601:282:1e00:c920::47f)
	by smtp.migadu.com with ESMTPS id e7e4f0f7b6858491;
	Thu, 13 Aug 2026 00:16:27 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <cc0050bd-1b79-4993-81a5-f70bcd0fc7dc@linux.dev>
Date: Wed, 12 Aug 2026 18:16:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/7] mm/khugepaged: refactor per-scan state clearing
 into collapse_control_init_scan()
To: Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-1-ddac39d61c4a@linux.dev>
 <anw7F4FAHEIaW0nx@pedro-suse>
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Content-Language: en-US, en-ZM
In-Reply-To: <anw7F4FAHEIaW0nx@pedro-suse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 130D380003
X-Stat-Signature: apa4x9q3de1u7x9m47c4jrxoox7ctxu9
X-HE-Tag: 1786580188-698152
X-HE-Meta: U2FsdGVkX19Zm5jfzFu0gDgw6YvOzTVyH/+l/+9lPbaab4m1LhSGqQk6iDsmsts605Aw68zgbD07mEPvTS7kLBnxkxlOikIRTnheQHP44RXZ77dujA3ajGl6NTf8SRI6iiB367hRR4PevezDeB024YokIaGZIgE31SeDmE3lO6gWv/jv9B62lrYSZJs/Satv6n0m6tKa3cdLDwO0F8Wa1b6aZeoGrjRglJrg2zrAlFvuOHGdPHtFCGJP5b8xmJeG6gl07OqXsp32TtqW08zL4hZCkKZpzskcsJtskq+KiWY1GFui1OYETKK6dyJGVzdekGqY51xLCAdOJhBUs0rX6oWD9Ywi/CbxbGXkqhJ1avqi/Oj3hljLgrt3Z+pRwtzscRHwAuVxhVJxOX0U/cgvaXoCIycNrV5XzCNLiUXGQAPYeYYqvTmcdqOJ6VuuUY6+FifQxVDbf6FFLI6MANEto4OTf3VQCj6OqjJGkHkQTI6B33qxhpFMLuhrxAG3CKVnU9jeEd2kNj4PvtCIgqY8wjB/6Mmw7KZInufOaUkPXTiOkxgPHyeOpygRUDsuss7P428OolgRkKe5iKbHGMoJaXAsiYKYKBM3DQUyysvpW+YAJM+4traMm7SiItlf0EJXC1y0sm3y3x520QqgfAIGB65X3LjWnHKH7iWUD9snz/tizwME4AOTT/jWwi/YRI7TxIoiKOJ9yszvNTyPPn1Fe5zSuuPtlvjf2GgFa2V1DNnuLwKH/TjznU37POIC+bWXWL+zwpyn7DkjjVVgQfdnHLjTuhmm1+Wh1OGc3SUos+femXdJlzRIGJatIZiy8RvMmBOm+qcF1iNUA1tAA5mxMOQamR+qBQWEhJw7CO9jKnKqE+OyNESQRM0c35kalRRbbpLUJ9bBzRZdFEiWkyP3VEr7pVXY/cnm/w0y1+7lLX+m3p5CGgLEmdnRwgnaU6y8s0g2d9/YeRC9PNnXP1X
 3d9m6KDR
 s1Hk2rjELCCxQNSC2C9mLux+rxo/Y3faNf07fXPb7Z+KE+3YaXtNwoK/iAibS3syO7lR7npMvQTnATdi+8ZfNIZSpoPwbbp/GwDEdiVvsH+TUBD4RPEumwLuDBMxUZithZLjq83AyqUDIUzda8xwNi6r5QYCwlT6DTm0KZLE+UHHC6AeMXpjujMX6HKwjDnvYEYxEv3HwBHavRTY0DPSnOOcSNIuaSAZnT/1eU6cK2DeXzCgg8EY3Ssjmar+LNRV75fiXDdtIA3m8pXNBGCr8EbOvxSD8PMbhBZEXJ0kAfzXlwHSuCKeJNYY3bdMFcTNpFOdUKnOi/IHsDOlGv23ozJ9Sakg9yT2bxnqMVvD+WyqUOjco7cQqKfBJ581q/E2cjgJxEWaRFVPoZCNfjPRQsf6w6Zhf4vSjMgBU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/12/26 3:23 AM, Pedro Falcato wrote:
> On Tue, Aug 11, 2026 at 06:48:33AM -0600, Nico Pache (Red Hat) wrote:
>> Extract the repeated clearing of node_load, alloc_nmask, and
>> mthp_present_ptes into a helper to reduce duplication in
>> collapse_scan_pmd() and collapse_scan_file(). Althought file scans do not
>> current use the bitmap, they will in the future, and clearing it now is
> 
> Will they? (To be clear, not opposed to clearing this regardless).

That is the hope at least. Baolin has a series for this:
https://lore.kernel.org/lkml/cover.1781083630.git.baolin.wang@linux.alibaba.com/

The plan is to do these cleanups first then Baolin will base on that work.

> 
>> harmless.
>>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Acked-by: Usama Arif <usama.arif@linux.dev>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thank you for reviewing :)

-- Nico

> 


