Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0225C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 794176B008A; Thu, 10 Sep 2026 11:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7449D6B008C; Thu, 10 Sep 2026 11:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633A26B0092; Thu, 10 Sep 2026 11:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 395186B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:11:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B57EF8053C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:11:51 +0000 (UTC)
X-FDA: 85198192422.05.1A50C52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0858540008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:11:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VO7pExAE;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789053110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m8oPxLNbD63jwykdDjogfzHJQI7uOPBa9BxKyoPjd+4=;
	b=dqmOf4FvYftRnSuuUkYCyL2rjiMRUNN9LgDU20gC+4GQOKdpqCzFmnqehBrfYvSgouyjcS
	9V848pt038b8cCVDxW1BD8Uh/BoR/MFlGrYq/fBcqZJo5LO7A2VpoR3l0yE5+qcbOsutXo
	AepxwNf6oJH/p/x9z9lOuPq3Op2ULeE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VO7pExAE;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789053110;
	b=p3KaBGSKAlrcjC85a1hdHqZneM9jPmMSn6FyUDKTfHHxmPztkFqdoFucMpg3eQwfSlqhQJ
	Wxek4lZfBOWfgsx+d6kvp6Lv5NG2tGx/cOqhlffZBbGAV81sjFCkSjWORZczB1qXGhWNI/
	PbdmCZ+PgrWWGLktRoEQQEATft/nu0E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60BFB600E2;
	Thu, 10 Sep 2026 15:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080341F000FF;
	Thu, 10 Sep 2026 15:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789053109;
	bh=m8oPxLNbD63jwykdDjogfzHJQI7uOPBa9BxKyoPjd+4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VO7pExAE9tLKDaKHb8xxcgxhPCuKZtJ6zqhDrvjdmuD5ErR0dFWQ+W4yXO85uiR/G
	 VLfy0Ms/MhbB4PHPzIjKj2tKCdJUX6RZH/qbmjZ0B91Cfmt+JfqDDXa/L1WnPOVqei
	 fV9VKnEzVUX8aeK75ayqlZuQesHZecS7vI38Dj+y9hTwqI1bAFZyxeLDSjUm4h5pen
	 YEIZHAS2N3LiejXO8NXe1I4V5AI7I+lTbFRaWxg4MsaN/aGjuOhMu2T7i6T8pFD/8I
	 GbYXY08QYFSc1G6dx1AmcjR+4rPenkEG973Xr8FBUtvk3WCo/B9Now/Ghs6ZlWDuoU
	 AnTw3vabHbp1Q==
Message-ID: <eb5b465b-c256-4454-84de-517aefcd6d59@kernel.org>
Date: Thu, 10 Sep 2026 17:11:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/12] mm/sparse: remove SECTION_MARKED_PRESENT
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 Seongjun Hong <hsj0512@snu.ac.kr>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-9-008fc8d579fe@kernel.org>
 <aqK9S1hBpPnujgz9@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqK9S1hBpPnujgz9@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0858540008
X-Stat-Signature: 5zyu18h3djmri8gn5q8sf6z5x4oc8rj4
X-Rspam-User: 
X-HE-Tag: 1789053109-46019
X-HE-Meta: U2FsdGVkX18xWwb92u8KypgZIqBozpcN8l6zdB54hnVz5/legXR30kjOJJB0Q3tvvA6/4brLvSO7NiDI5W7xpGNWBbxB2RN0qPe3PTrkSL/NuCennv3t8Lu0fkl/xZm88NFgxaXfVj/fpEiLD92h8EBdvtIhTbC45wJMmUHtJY9CpKkuD4URwsQLQofUbadCI9h07P0bSYozMOzPhObLjNjYxFgLFidee/DJviiFC0F5mdWXA8xGGE/ZdIYaasi9TpsRYLcryiXNKkaSEYpkxcpKWPGtrP5LUvayDLQfnlRJi0du0AgyVsfRFYsNtcVto9GZKVKKbL/cdCviKRUHZCVhgu347NDMkSnKbhYT0siI6Og4L3yxd/6HPdTdy1zr7ermhVXZok2ARmjiLrm6ZBioCAKfQ8sKTMi2ybyKGJgFWNz38gC15PXQVKMMs1CLibZxK75nXyByibZdSXht+GBPZzN+Pv9CTLbl1r3fvjGTT58Aw95JtoISE9no5oHu0ExJzghfykX0copgILWsDpg/f2hIpiKtXpwuiSRFJXbshcPWgrXG6b6hm8qzUUqw0YogRflcvnqKWo3sd+F2Ho4Lv2GuVxRxF2SQC5ToLj/tHYTGRVS7XXd+qGJwHq7OQ4Atgekl/fn/LhvgRoTwDFmguCOHeIVNIh7UpNn/jxOt9oXxyCGs1HU6FeYWIsZQjV9zWWRdvtNijTS+fOBM37zVAzYb7XYRmjm7voVP6LKnRd4ol6XRfIhIBbM28w4BvCGB0vTnIxgd478yQW2Hns7Zxjlk/pYydX6i9Rp4Ngmy/lrVRmSl6ym895qWYjdLy63exs+caeArbKBic/0ynAcgJOheLP+qzl4Tkpvru1CovFnXhYz9hUCn2zZAercsieJMGaeKS+EQwS3j6iUoBo0e2eTtSR+JlUFkqQCgVCH8TcHuwVH2NVX+VmW+SZSj67tyr3QuwqmVPv2GtMB
 dCwNFv41
 4Lf8p99A9CPPX5gtJdAArdKqLMCDOQyraulNic1XXbLYP9Y2jc7JOf7qWf27sduomhwsQoRHv1dYqvgE3PRfU7PJKi5E7zgbFCYrlXspYfEn4ayYWO8rXYew1FWQ6Us9jeEkvkSP16BTp/m3lUHrJYFiEGnxlVDJFWI9X5piME39H197FwaghCmPJaZ2L4jRn3qusQMxwpl42k+SpU6U30SROFRDAQD8R6EOHfi5baM3Jw3wBC/FEPKPtrx1m/lBk8yO4KZb49AOHnIoHmOnRgmtSDYWf8UWPGuGWWeEgp7+vcwkacQfGHsQqxj+m+1tDAsWV/tg5qU6mToXb1LKIO6mVYGvrsE8/h2ME
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 16:32, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 09, 2026 at 03:33:02PM +0200, David Hildenbrand (Arm) wrote:
>> All present section iterators run before memory hotplug added any
>> further memory sections, Therefore, we can simply use the SECTION_IS_EARLY
>> flag by setting that flag earlier in sparse_prepare_early_sections().
> 
> Hmm? sparse_prepare_early_sections() doesn't seem to be a function that exists?
> 
> Do you mean sparse_sections_init()?

Rebase artifact, thanks! :)

> 
>>
>> Get rid of SECTION_MARKED_PRESENT entirely and rename
>> for_each_present_section_nr() to for_each_early_section_nr().
>>
>> Also update the gdb script to use the updated value for
>> SECTION_IS_EARLY.
> 
> The change seems fine.
> 
>>
>> No functional change intended.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> With commit msg updated:
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> One small question type comment below.

Thanks!

[...]

>> +++ b/scripts/gdb/linux/mm.py
>> @@ -76,7 +76,7 @@ class x86_page_ops():
>>              self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
>>          except:
>>              self.SECTION_HAS_MEM_MAP = 1 << 0
>> -            self.SECTION_IS_EARLY = 1 << 3
>> +            self.SECTION_IS_EARLY = 1 << 2
> 
> Seems a bit strage given the code is:
> 
>         try:
>             self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
>             self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
>         except:
>             self.SECTION_HAS_MEM_MAP = 1 << 0
>             self.SECTION_IS_EARLY = 1 << 2
> 
> Whereas other variables must be available with no try, e.g.:
> 
>         self.PAGE_OFFSET = int(gdb.parse_and_eval("page_offset_base"))
>         self.VMEMMAP_START = int(gdb.parse_and_eval("vmemmap_base"))
>         self.PHYS_BASE = int(gdb.parse_and_eval("(unsigned long) phys_base"))
> 
> etc.
> 
> Is there some weirdness with gdb? Or is it maybe because there are some configs
> without these symbols maybe?

TBH, I have absolutely no idea and I was asking myself the same thing (but
decided that I couldn't care less about a python gdb script).

This code was added in February:

commit 55f8b4518d14b7436f70defe27faba4eca0cd4e1
Author: Seongjun Hong <hsj0512@snu.ac.kr>
Date:   Mon Feb 2 12:42:41 2026 +0900

    scripts/gdb: implement x86_page_ops in mm.py

    Implement all member functions of x86_page_ops strictly following the
    logic of aarch64_page_ops.

    This includes full support for SPARSEMEM and standard page translation
    functions.

    This fixes compatibility with 'lx-' commands on x86_64, preventing
    AttributeErrors when using lx-pfn_to_page and others.

@Seongjun, why are these conditional and the others not? Trying to support older
kernels?


-- 
Cheers,

David

