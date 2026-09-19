Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B38EFC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 15:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A87B66B0093; Sat, 19 Sep 2026 11:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A38E56B0095; Sat, 19 Sep 2026 11:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9275D6B0096; Sat, 19 Sep 2026 11:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 719596B0093
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 11:15:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A813B1C2172
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:14:59 +0000 (UTC)
X-FDA: 85230859518.07.D7964C9
Received: from mta1.migadu.com (out-98.mta1.migadu.com [95.215.58.98])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8E285180013
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:14:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wx4ObIXb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wx4ObIXb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789830897;
	b=wobLnNEHE53ZLo8IU0kYQQaT1Mds1deg9bbtHS1sDByTrO4COeMOJy4R7BxocR+DzhkLHV
	7zh9JobB3jC/VRRlD56GdnZhd1cxbqN/frhaAXCvBRo6Vw/o6h0AqUg/p+Y8E1uU7OJkwp
	cOBN21KPTOZFTnOsWe9Pt0SPrPQDGKs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789830897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0wLhHu/y6IbSnOL43oK+GHp0hEIdZafNZcrfhNhszw=;
	b=Vif1AN1nGF7ieky8ISG6x5UE7V3KmaoWREOj2EGaq7j1vKHKNLi+DCffp1tQbMg7v3VLsz
	WWVg5/inYEWuT9Oo9PgL+oDE+iIZ6U8Ibkeve5ZrZeEiSuSJF6WUoI3sulbfgK8Pj+vAkP
	3Dg7QNCaM7BAadsebUq1v4u4r8U+GAA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9b2LPJKwDAP26Jyo5JqSNmJl55dEEIMEug+87i/rHb0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789830895; v=1; x=1790435695;
 b=Wx4ObIXblzEO9Oh36mlY00JUaLE6SvPAavGE0WzQXoBjllMWXsbnQSOZTL6WDmCt9F7ry0Kq
 cWlCHS+O8/CKI6fD1Vtcga4tRDN52LhSm5J5CJ8RX3e1IItyqygobjmQXklgsHKaAmv5PCjWB40
 00mg6fUbxspm+Mtzmm6zTPew=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 605310dcde608050;
	Sat, 19 Sep 2026 15:14:55 +0000
X-Mizu-Trace-ID: 605310dcde608050
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: lance.yang@linux.dev,
	kas@kernel.org,
	akpm@linux-foundation.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/huge_memory: disallow raw PMD mappings of the huge zero page
Date: Sat, 19 Sep 2026 23:14:46 +0800
Message-ID: <20260919151446.5741-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <c0979ad4-9fec-49f1-8442-d90061b79504@kernel.org>
References: <c0979ad4-9fec-49f1-8442-d90061b79504@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E285180013
X-Stat-Signature: 5gk4m86368ystwojaqd6jksdg5m3wxsg
X-Rspamd-Server: rspam01
X-HE-Tag: 1789830897-397526
X-HE-Meta: U2FsdGVkX1+a0iAcse+OB5w0SP0mMDQys9U9Kfr6rcocWem6OoUEV58kQyKYKnr/uhp4tvHtIys+LxG2BSHptXXWlm+cCqrTzTExeYVOCZvDZKpa7mFlTc7Yx9akxCPFK+01n8tCI3Sgz8W1dZMOHJqI2m+Iz8T+WVCFk4nvXUlDWz1gL6fFbrMjuQwKHoBk8H6VX9v0WMsrvvnVqlE1MLQCJMUusMMnc5Uf7xiXp6EPk9MkXvBk+grn8YBuCA5j1n+tzcPzxlBNmFGvPeSa+t1rcE1lvB8H5JmegiMx/Q/AvnykhZwc/0ssE4eozKrUm8Dh6URcfsAL0ZUf98Pgsz1d8CdlRGqCmc7o/pph/Z84l/zALxjqk/3cGqfqIAJzXoovtcSKSgU2MD1ojbBOzNQ/hLU9HHHXbPe/KEuz7SZq1zKv34qPDuNVi4uysBqChNeDsUP82WMVrI8G9FiNmsukEdf5ngPwqrZu849X+O0tm1vwKnkyzyjAIhWPQ7tDbQ9zfKbdNl3U49DdLNBppXMxNWcxL+qnxpuX6N8lIE+bMWEo/mDCXqSTiq3/sAswTCURc7aBUNranlqzXSW0NOUYUPIzo0UFfQgozs24/uSDmuTC0ExPmrnqXj5e56iqVAWDaXq4Y62UM62ma+jtDNsEjN0SYQNTsfFCNZ4xqdhxmUkj7DuaLkL/k5B7MJq0vqnwPCRFOodhybYjo823Uan1GX3DNu263OjaiSK5UCXssevuR4eaLym+ncNjoYlnIwRP996D3fNq1fGWKliFWh2bAJucSTBNSkh+gLV12SDK+9Miw2bm7A5PV56fSRqBN6A+iYuZTFDLu24H1ceVYAUNaIFrWK+PdUZ2D3SwmBSWk69qPi1Ku9eR913akxYiDOjTZE0y/d+xYGOlCKGtDWljR1lpsEj3RGvXiceAHJurq+joqyCQrnLPpasUfmEcHx6Ig8uanKGQfgNsUFi
 AePFAP7M
 8E9Lu2Mdwe0rQDhJ3KNuc3aNOkhSJT0Yq3WqM43pX7DJF9nqX1IrKOTGe81VrH+29pxQCYWVk39rSP4D5fE9HfjQbGFJ983FbRlJY17hJ7xN3hZ49s8KgnBhy/POxPtbJseP0UJc4r39UlVrK22WJJMa1YFiHfKNOVrkXb+GZH47KbbCmoBE/g/Tm6Y/XkLUlCMXg0UHN759ueGk3vOlOk8oRv6JamT8+zTGpsSZsrGs/6Q0mPy+PcPl76Bad+S1AWo1Prdb6r/Uun9Q+doHjtDy6xVGc0o6er7TtlMqhjlQx4Dcd70enDwv6QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Sep 18, 2026 at 10:37:27PM +0200, David Hildenbrand (Arm) wrote:
>On 9/18/26 04:52, Lance Yang wrote:
>> 
>> On Thu, Sep 17, 2026 at 05:03:09PM +0100, Kiryl Shutsemau wrote:
>>> On Thu, Sep 17, 2026 at 05:29:48PM +0200, David Hildenbrand (Arm) wrote:
>>>>
>>>> Why would the zeropage be a problem in PFNMAP mapping?
>>>
>>> Nothing enforces that it is read-only.
>> 
>> No in-tree user inserts the zeropage through vmf_insert_pfn_prot(), so
>> rejecting it there should be fine.
>> 
>> Something like:
>> 
>> ---8<---
>> The huge zeropage is reclaimable, but a raw PFN mapping does not pin it.
>> A PMD mapping of huge_zero_pfn can therefore outlive the folio.
>
>Well, just with any other folio that we PFNMAP, the mapping would have to hold a
>reference. mm_get_huge_zero_folio() can be used for that, or just grabbing a
>folio reference (not so nice, but works; GUP uses that, for example, to keep the
>huge zero folio alive).
>
>> 
>> No in-tree user needs either mapping, so reject both with VM_FAULT_SIGBUS
>> rather than risk making either shared zero page writable.
>
>That is the better reason. You could also just say that handling shared
>zeropages correctly is more involved (see vm_mixed_ok()), and as there are no
>users, we can just disallow it instead of trying to fix it.

Ah I see, thanks! obviously, I hadn't fully understood that ...

How about this instead?

"
Handling the huge/shared zeropage correctly in vmf_insert_pfn_pmd()
and vmf_insert_pfn_prot() is more involved. We would need to check
whether the VMA allows it and keep the mapping read-only, similar
to the checks in vm_mixed_ok().

No in-tree user needs that support, so reject these mappings with
VM_FAULT_SIGBUS rather than complicate the code for now.
"

Thanks, Lance

>> 
>> Link: https://lore.kernel.org/linux-mm/f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org/
>> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>
>-- 
>Cheers,
>
>David
>

