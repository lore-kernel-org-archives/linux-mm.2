Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1F43CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 12:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301726B0088; Wed, 10 Jun 2026 08:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289CF6B008A; Wed, 10 Jun 2026 08:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178BF6B008C; Wed, 10 Jun 2026 08:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0397A6B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:24:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9554CA07FB
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:24:58 +0000 (UTC)
X-FDA: 84863922276.11.82ABD40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id D8F5814000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:24:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fl8WohK6;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781094296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rv2uiNyfe6aqprunmzkSLhZnXso91QbLT7zxe8Fk2Bk=;
	b=Q3+uT63GELZq6InhEpQk6FZFwj0AiKBPSu4ITj6aDrwQH19mv06mysVs5fiJupNR11H0pe
	ICdGCgDTUbsdRnGMMSOH3MyrAfL3jPb7msCgWXBS+SW2IFs9gEqRtz5Wv+uIUnKzIgwc27
	xPhnSmazNan7+9ahveuYRV7Cg8eqaks=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fl8WohK6;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781094296;
	b=GZiCg1WB7IyAZiH4NgL8SEH0ksIcE0Y664faEmn0IN8FEy+i8VU59hiiUGROmHwdVZJiZi
	z3CDniBl+qTW+9VP0LwERqUSiP3LRDhk5gECTkshtAZBIstDHQ/31WpBDeb6XqkZd77hR4
	/Of0KpH26uyg2pUf5EmWl4YNZIgl2FY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 647286001D;
	Wed, 10 Jun 2026 12:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDB61F00893;
	Wed, 10 Jun 2026 12:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781094296;
	bh=Rv2uiNyfe6aqprunmzkSLhZnXso91QbLT7zxe8Fk2Bk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fl8WohK6hMDbqkTU7FZ8gnSxVBJNTQVrkjI5ttp02N6VPnZiWZYQlaqusUVXwRO25
	 F478DkFkPQTvdpVekQ9x4pJwrJ/2o4ji9i65U4DfvEftmCOuvE6y9lUqlUhOTQ1ax+
	 +ad/oUef4yJdFt/j3CQLd8/L46gtP5EKkTnS0rjvDB7E0sw5sXT8gEJwJHXGrpZ8YK
	 nu+1IVS4wbWQlLOKmbbUQ5DIoWRMKXs+BGiPPjzhOXjQ6GNMivpTd56YSMaeNwsUzD
	 Gw+cR4puvpCxf3II5Mol8V29lPdpQubSl2jcdYJxEFud7vLQYoDIFP4S7GXmJsg/h1
	 gBgXH/2xrwyTw==
Message-ID: <52cb5ce7-ece2-4e52-9e4e-5e476c34f8be@kernel.org>
Date: Wed, 10 Jun 2026 14:24:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 00/16] mm: PMD-level swap entries for anonymous THPs
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 Linux Memory Management List <linux-mm@kvack.org>
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com
References: <20260602142537.198755-1-usama.arif@linux.dev>
 <aa712058-7b4f-4421-b265-c3173fcad87c@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aa712058-7b4f-4421-b265-c3173fcad87c@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D8F5814000C
X-Stat-Signature: 6sp8ta1ak7jsf949dt6ns1yb3z3of6dh
X-Rspam-User: 
X-HE-Tag: 1781094296-322134
X-HE-Meta: U2FsdGVkX181g9L/ww+A51bXwvZ5Ea/F3xj3kNG5B7edym39idquJFotzAPS6MydEZyYPYZ7lGnAvMf3Go7W52zHRvrGIIXLQjVkW2PhcQllm5g47Ef9SSf/La/1XSqlgHDTLn+mZwN5uC9sWKG9UgIBAPxjqpjtTlCoUf16Hnp+ONXSjUT3foA96HXYdWaOEjv+8ccBq2EQx/pbA2+Jmz6nLaFcTOGlqxLRFwK1TIuerors2b6lt+udh6femevzt9DE0PAFImYRpVSoT4/8vSUB/z3oCANikoqpEbVzzwLRl4u40EKEDJiiZWxRHxyF+m54+H0vGJkDmXpyc8sogAr7sLCmtRKltSvvawM65NRAyvsJ3mtf+SfeJS0JpjuGf2Ew7d/aynWFKOm5VHVHiGU9no+2VlML/IGe73YBMGEhb00CwGe2OihpfF0zBrVAG/gqCP7nxpNeqEQKemZixRJPUKYD9EN7pbAka1zT6NYso22OZVRSdSK9GjLeU1pXLCngZzQPC2v9m9dfysC2/ZA+qCQaMQdooG6LClDJhDuKV1+1zY+G03RouUMjELMuyUiMNUXIMjLbiHcucDBvOPTr3MUY4szp/UWHjeWUDVmuunyzjeQgAYswlNmCXki9MMPR1RfeqDGe80CTvTo2+pQ9SxemI1B3YXEbjkUGfFXIv/bR5qW51XfXU/CF5qcX9hHnlTTJGA0H76/IRpmqbOaAdTUVF3DCy+kubQ1+ItpI78eBKbPT5aHycerbiwgz13Sb4jmJa5auuJmE9DZGizE3G7eQIi8qaUk78jogzQL2mr5zb/qAeuC5xp+IZsaK+swyn6cLAOTH8ubyQxIGxT7PKY+pf76QElJChDY1ktePEGAeiuo0EBDXgySMOmQSPncb8LYswYOMS5xvBxsm31Cj7nTIJxedzGZSD8843LfZUHz+JKUApDA4Md+qmyYCJJGd07W1/WMuiyHzBBL
 /fDCAzTA
 yKgJUteMGKkXPvhNNK0WkP09ELL2E2wi22DwYvrsQVL9ay4h+8dJMkI6RhYPXDe1GfCUCgjczYuSzI2vMKazTdMn4ySLD6ubZgQfcgYv3q6AiVSlRMoGkStR0Ot8WAkFEoxOKqJ9gJGAPkKmpHehOBMczmE+aKH6CWQb7rBcaM6kY7irKErfMdw8gKAifTTj4oRpXBiS3YZE+EVe1+Nlf21Xli1ZNhHEYl4eh5R+ydSx00OisKODGW8Wr9X89XgX74iy1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 16:29, Usama Arif wrote:
> 
> 
> On 02/06/2026 15:24, Usama Arif wrote:
>> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
>> split into 512 PTE-level swap entries via TTU_SPLIT_HUGE_PMD before
>> unmap.
>>
>> This series introduces a PMD-level swap entry. The huge mapping is
>> preserved across the swap round-trip, and do_huge_pmd_swap_page()
>> resolves the entire 2 MB region in a single fault on swap-in,
>> no khugepaged involvement is needed. swap_map metadata is identical
>> either way (512 single-slot counts), so the PTE split buys nothing
>> on the swap side, it is purely a page-table representation change.
>>
> 
> Hello!
> 
> Just following up if there were any reviews/comments on this series!
> 
> I know its a large series but was just checking if there was any
> feedback?

It shall be reviewed. We just finished the mTHP khugepaged review to get it into
7.2, so we've all been rather busy.

(I mean, just take a look at the THP-related flood of patches we are fighting
with on a daily basis, it's not funny anymore)

This is clearly going to be 7.3 material, so there is plenty of time given that
the merge window is about to open soon.

-- 
Cheers,

David

