Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19B6ACDE008
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA5CB6B00FC; Thu, 25 Jun 2026 07:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E577E6B00FE; Thu, 25 Jun 2026 07:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6EE96B00FF; Thu, 25 Jun 2026 07:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B32456B00FC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:26:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A94240668
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:26:12 +0000 (UTC)
X-FDA: 84918206184.10.5F8ED37
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id EEC25C0002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:26:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y6UyviYp;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782386770;
	b=bBkvFhsh1Ett6/ZH620tZZ4IeJerxqY4lAdahkwq1sqHZFqei9hJljmSszkS/k1P5uJGq8
	BSu/mxPLH41Xb3a8RSLVFo8NCfIVBV1oL7Zs1TsQk0ciGVJvrqempNTTgcPuDvDckgEeC3
	zNv2pH+BlaON0FAviArLc9hnF6ciZGM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782386770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8lDCA7qPRr9jNsO+3q9qYqPG2WVRS7I1dNqVMGwaE8=;
	b=sr7f5X9jU8xFgAqn+N9tgwKud0HVFaw839izk+DJYQpH/7WUmBwQtzaTDxEx6s12SZlZhy
	GiPIt384yNjJFSncshybwANUjKS59v++VP4x158DnF47IUjVAcycwE8WFalLg1JFGxaRkx
	3Haf2y+tcVd1WohDb2iLJzFPVKv980k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y6UyviYp;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <b6c11065-8e4d-4d27-baf6-e94c1db51175@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782386767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c8lDCA7qPRr9jNsO+3q9qYqPG2WVRS7I1dNqVMGwaE8=;
	b=Y6UyviYpeIDfCsWOPdJyWLxNNBjydnptTaNt2p5gWx23Z2RluaCf6poV/r+diWTABfr+I0
	HIH98jXon0jcczHx7fpTBUxLcBLzRXSWHMwF4VC1cTs2Pyb/R8J9B01RgCv1HGo/3YLJNC
	J3ycJAZ3UrXM9cEZ7Csv2aPEimTX3kQ=
Date: Thu, 25 Jun 2026 19:25:45 +0800
MIME-Version: 1.0
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private PMD
 handling
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, balbirs@nvidia.com
Cc: akpm@linux-foundation.org, ljs@kernel.org, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 ziy@nvidia.com, sj@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
 <20260624085756.6598-1-lance.yang@linux.dev>
 <20260625095728.woikmkxb6gskth3b@master>
 <2252683e-df5d-47ce-b15d-1036bef8d063@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <2252683e-df5d-47ce-b15d-1036bef8d063@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 36bjkuej6qdz9c1dnp7ijhgksn1hipft
X-Rspam-User: 
X-Rspamd-Queue-Id: EEC25C0002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782386769-7956
X-HE-Meta: U2FsdGVkX18wqghSm4CwaGUGBa9HbqU4AoGVoklqBdeW8cJ/tqIYVNmdeGYcRDM99i19dq4c9Q9UlQji6w/DJCAnAJB6VITW8PQBUUvZgyUIc34dIhf6IBOfAOU5nyBaWt6ZNm9zsnTh2eyUfWraOZmMroQ0dsCHH6ywI3aRrIjQb4pu+5kliQCOvPZw9gKDYB4glVxcsSry0WuIEv+X+38OOyDs3DY1Zkodg9k8novaBHlJVwwBpKVCb6e991HBZk2O2bLZHHOQ+Ceoo/bRZrGc6UHD+/jF0s82EX+E8QJ4fcm1ExETGylCKEU1/Z3qibCgtL9SY9sezOdFPTFILLChCGFymvlVISVojOFohVTnkfwOktvWHt88rU4IGiHy5hm1K2/wSzHXXUm6DUlXtaMr33EFEwj9Sx0G0CgGYLKJOsXEOS6lMi0aUx/LgUyWcxSq3VWo34nhfjykBFdKcJx0kPh93Gjg0ap7hrdq8r/d2nNq+osUaFKfH5YJDIN3d1ECsr8Zqew/zBVBIXvnzxDCA0N8IJg7E1jrEvJ+L3hBetlNW52PncYgOnQDb4m2LjzDSfT9J4ON7Z7gY/8MTZ1d3aTONojmRk7dkpaF3ZZNi8VCKk7FOJHDDVrJ9zDV+cfjKSmp5RLNR/BTKKLI/aIUW86KDeGHiJgLC8fU5UAOXMofXT8/LtYr+IzuGJvL9t0kMN3/cyU6eAh0aEd0TK0cdMmQJ/Sh71LamvPjImgWIGi+dmiFcnYgdkP7LdeoYLFq5AHiP9gNa1eSZe4ZjLCs5YsM8XF7Tf8L0rNFaQXeiYhsuI5UQujQHbkJ+BTvmETAQyJj4aJhYU+XC9yW78FilK1BF9/16GPvo+hC1wD6BAHknBA14HWiKpnkLJDLZL1yu7IeFtbkP1Xj62wBtL0zHUerupdW08c6AOlhOxpsm672MWuNNNmmaGk4LzgS9jrhhkR+z4PFhF7+pjS
 V8jStmul
 7o19HKSzZ9VUX+0lcUbg5GUuXW2JCWH6P8DlEYN5iaXeSsvzagQi1eLrTNBPvcZ6XclA+ap0E6LywAqa+/x4bO54f/0PA5kTBQoYD/UP9gnPeIHZFw1uHyR5dgzml2BtC+n1ZZVqa/egorHkvheBQykxXN2mTW/9B+c4XmkhIkPRsEP3bSCccGVRwfl+YCYByja2jNmwJ1fhaN5dRBR85kR+kNKaStzrD+m33BTQtDCjPptWf08s/vkxPkbgt6zjkpD3MQagOzb8CA7DtCKuVbEB3ZoaMicfN5e51DHR5wHQNDp1FjrbxTKqEvmSjtNbhmPxAlLbqbP4VVRw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/25 18:37, David Hildenbrand (Arm) wrote:
> 
>>> CPU0: pmde = pmdp_get_lockless();   // sees PMD migration entry
>>>
>>> CPU1: remove_migration_ptes(src, dst /* device-private */)
>>>         ... via rmap_walk(dst) ...
>>>         page_vma_mapped_walk(&pvmw /* src, PVMW_MIGRATION */)
>>>           returns with PTL held for the PMD migration entry
>>>         remove_migration_pmd(new = dst page)
>>>           installs a device-private PMD
>>>         next page_vma_mapped_walk()
>>>           drops PTL via not_found()
>>>
>>> CPU0: takes PTL
>>>       pmde = *pvmw->pmd;            // now device-private PMD
>>>
>>> So when PVMW_MIGRATION is not set, current code can return not_found()
>>> before we even decode the locked PMD as a device-private entry.
>>>
>>> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
>>> device-private entries") made the
>>>
>>> device-private PMD <-> PMD migration
>>>
>>> transition possible.
> 
> Doesn't the folio lock help here already?

Ah, yeah, I was too focused on the PTL and missed the folio lock ...
Don't have a caller like that :) Went over the fix again, nothing
else jumped out.



