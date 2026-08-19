Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A5B5C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 16:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC576B009B; Wed, 19 Aug 2026 12:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3C36B009D; Wed, 19 Aug 2026 12:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9886B009E; Wed, 19 Aug 2026 12:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7A1B6B009B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:05:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6891512035E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:05:45 +0000 (UTC)
X-FDA: 85118494650.19.D0FBF89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 860A1180005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:05:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nahEdsYl;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787155543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vf0f3PGKan/4S6xEejIt2PzoJqC7pONakFqilBMSKTk=;
	b=BFkWyusM4Xz4w2wW7k/zGhDBEBVEn6s/+KgtNAr3zkUBLWuLvThUdm29+KEblIr7FDWTWo
	wMutfz3mvUHiOyuoiIBUuLmq0HUVGAej1UDJscihw3fYYUZB4i4uO+Sd8Es8k8I/hcDFvi
	OOuPAPAMpY2U204MJT3yPxtmmTOILcs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787155543;
	b=DfAc1sr1lPrwC6DG+OWdEsjrVuLX+rfDocAHnNFSbTVpAfBBolwKrFRs+mQj6Jgh7PgxjM
	Bj3gI6QzyhwtgR0IIRfKIhhk9z1+uF9N6s06HiTQqIv1ogOtM+cpU6flOeCD4GVeAGjHGs
	WnJlrXxNYXNLnbYBWUSGzRd48KNxiuo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nahEdsYl;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B67FF43AEE;
	Wed, 19 Aug 2026 16:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CF41F000E9;
	Wed, 19 Aug 2026 16:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787155542;
	bh=Vf0f3PGKan/4S6xEejIt2PzoJqC7pONakFqilBMSKTk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nahEdsYlsG3rbPyDM9rl9kBATN8xlKU7kK4EKxaVfabIh3qfqvQuD8fhASRjQ5Jx2
	 haC+r8QeEM51ZmMix0xeLlkvYDTZQ1EqtS8vFLwRe48OR+X3nGzktC+oXqqDwu4JNK
	 QvpquFdeeU15xE8EHOx0oy2ylPd7GBPFOgz3KkhpiLCGLEabF2IxQJ1lZMCjMFT5CQ
	 VDJrKyBmhLuSekOsvByXX9bCZwOpMJV38G29pman9EuthDMUL4LrdzUgDxdouq5lia
	 fvhIykL1lQ2/LGNom8uYhuzwF/Jn9Q1doqQoCt22CH1VpjAAgnOhuTisAzPxr3pHtE
	 0GV+wPS9tSqsw==
Message-ID: <4a609aaa-d08c-4625-8097-dfe4f7b4961a@kernel.org>
Date: Wed, 19 Aug 2026 18:05:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/12] mm: add PMD swap entry detection support
To: Usama Arif <usama.arif@linux.dev>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ziy@nvidia.com, linux-mm@kvack.org,
 ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-3-usama.arif@linux.dev>
 <69e8469c-aa7f-4141-be3c-796c9cf11f2f@kernel.org> <aoSmlTH8e26xAYLp@gremlin>
 <fbbb6dab-71c2-4f8b-b7f0-6c7f73ddaddb@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fbbb6dab-71c2-4f8b-b7f0-6c7f73ddaddb@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: d6fzfftfatj5jp8swqcx8khg1miygb98
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 860A1180005
X-HE-Tag: 1787155543-883100
X-HE-Meta: U2FsdGVkX18tt6Yo1SIRZOSEqmUZzZQYoU8sDQSdGzuM1pkyB4eXsxNMnJvdOS/Ebv/7RpGYa7mzBq+FDYZa6HvVT/7mz6/e25lCioTwddft2d3s0Aci8vveYQxfb4UrsOB2o/kIV8hTxfs3IJG87gh8BlWyqdwCe8c4ZRW6tVHUxlW7EtlSXoPClzRrNDCVnhhZtnT3qk+Ct3qptPgni+pVuoRJ4vcWjFxOO8OOzVieApxMYi8AFIVKzRwU1XKL4ViRBoiDKJieEDIzC43GkbcFLkosgskJb/BZQRmAsAY8O6W2olzJk6JMbSVlPZrR3Bf+argtFZW9dNmdTL2M5BY8t7+9KjEBf8v3p8qTwtG/Hrq1I+HVYD/nk6cqu1auC36wyTMDn8aj8w6sV28xq2T1iQWueu1ZDFgpMCGM4ISdJfD+3wP6JzJRRt6q/CLPb04vZmEBZYbe37k9YemcClQJc/cfFRPHsS/LKvj/1CBHjU66YgemylO2ZXnUgT/PQ5rBXt05yDFbSnlfeAwgwCzK+B5IeVIIZG6juZN77HWGQsNF51Lxfzyy80annnM9BL46S4bWflIciNt6RTj4hWyKfMvcfWP232s69f1NV4x2SYyYL35rLroJfOacqnJ+jeNFNhDH6Oom8FTzn/aMwDEtqGjXcm+Oxk4LPehdMflo5W4wBP9sFfaf9kSG7GqgWqQqSlabTasIrHwGdwqGHGmvINxqsO+spohcfhWYgOm6vxHL6PTTaZIMKJSR+R20KKciZi8YcR8GBwkUiUO6nEhgKDlWggfnzq2eNyM5nGDEHjG3N1ajPvkKZd0UHUBche8df3pHXvp3ylr/Dg2MKDQgPCpFmRHT0eEAMvDxmy/k9frccOcnmJ4YudOT3hVC8v3M8/pgOLOmCNtLInzfVSu5JO6pOAWpFDjDlhgheK6C2GzXV+DawTPwfrcCoZ41bCxpywZjmhv25jllSzm
 Jd36XUdE
 0SfznKijy0KKAVKA09bhtdaPNmt8R1L7IqVbQ0pbKE1hBOAMkhGVD82RysZE3lBOeXB7SLQGcijPZLRyjIGV+Fsr5DwaUOAago2vW9F5kKJq1ylwaP+K1zjmDppGFlZKspFNGOSSvI2GCiSiTjCOAJAGzPZx7SrSHuFNPDxKimfWv1Riz0qrsGCNokdwFis/ntBgUNyfZ915h7lSienKIzp3adVoEGgIBvxEj/Ti/+5v0wFFOzCJmO+SD4jwr4KD6+ajq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/19/26 14:33, Usama Arif wrote:
> 
> 
> On 18/08/2026 19:42, Lorenzo Stoakes (ARM) wrote:
>> On Tue, Aug 18, 2026 at 04:40:25PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> Ah, for migration entries we still use a dedicated migratetype. I actually have
>>> on my todo list to move to PTE bits as well.
>>
>> We do seem to have rather hacked in PMD level stuff across the board
>> previously :)
>>
>>>
>>> (likely the _swp_ part should then be renamed to indicate that this is for
>>> softdirty entries, not just swap entries)
>>
>> You mean softleaf?
>>
> 
> Yes, I read that as softleaf as well.>>

Haha, yes :)

-- 
Cheers,

David

