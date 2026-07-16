Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABABAC44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F3DC6B013B; Thu, 16 Jul 2026 11:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CAC56B0141; Thu, 16 Jul 2026 11:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E15B6B0145; Thu, 16 Jul 2026 11:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 595556B013B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:47:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0003A0138
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:11:24 +0000 (UTC)
X-FDA: 84994524888.28.6F894AF
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf31.hostedemail.com (Postfix) with ESMTP id 093CB20009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:11:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="xoM//Jwk";
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784203883;
	b=4ie8A4+h75Gq7NgbdK6HnjpfCSpY635U5TwPwVgq1n2e+UmyRFXlkbz7E6XS+HLwfU/r6e
	zXaxk7mZaNIuVfbGu4yb0Do/gjCaO6VJk7k3PT0tAF06y4OzGXbzhpkoiGpghKkORNkMGu
	c/lG9qVPyJz52TJRIyi1Gqlm4S/F1pI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="xoM//Jwk";
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784203883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22TDE33CcMaK/6oJLmhRk6PtkOBzLjo6hgniVsSgp+Q=;
	b=TdmFDnNvEsgqzSHnX57rkPJndT4USZ9Ez8+D5w6vW4lgYJmYmXcoDpWH/gzq3cCBw+tKmE
	3HpPPcx9PPFKAXUJrM6U/iIZ9vNMaRhaYj2PKbgArBhpG3mW4kE+tXoQeK2ClylvE7dWb/
	9gFnOtotw32xqoN4wrH1N6KSV1VuKnQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784203877; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=22TDE33CcMaK/6oJLmhRk6PtkOBzLjo6hgniVsSgp+Q=;
	b=xoM//JwksrfXMsHakxHrGdYRHyOht7GNE4aSAaeo1pHNHMM15qw4Udm4hVyuC/GjZSLjQqIwr/MfDqYwdhapZNEdB4COuP/JEaMvwJ6OTesqUFhS69PWjt6ojwxqOxPqx2hOh8AkqNzyW0oGoFsHTxhiBUfNqfZXd+ATQKp9Bgs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X7ENwPT_1784203874;
Received: from 30.120.38.205(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7ENwPT_1784203874 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Jul 2026 20:11:15 +0800
Message-ID: <358e6938-9505-422c-8765-d8244f4c875f@linux.alibaba.com>
Date: Thu, 16 Jul 2026 20:11:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: mglru: promote mapped executable folios after
 first usage
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, hannes@cmpxchg.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, mhocko@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1784197559.git.baolin.wang@linux.alibaba.com>
 <7e3a5f6bdf70e0237027025f4593a3874d411f65.1784197559.git.baolin.wang@linux.alibaba.com>
 <a00664d4-01a0-413c-bc33-71c86cce7894@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <a00664d4-01a0-413c-bc33-71c86cce7894@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 093CB20009
X-Stat-Signature: aiq4grkz1jfijw3ts8d8qypdeddhxzeo
X-HE-Tag: 1784203881-421078
X-HE-Meta: U2FsdGVkX1/UQiNXns+nZm4Z0/iCKmBbKDWDOaeaQiA1nCw7+NAkbQeTvJoqqQkJ6OetrKyifcqP4EOy6quCh4EP0VHrub90dIbX7HmIhmt4//6Q3pVnmyj9Msq3NdlzmDTmMIAo89LcuLsm5XN4FSMIN3QewGCaAKmXOwum6dUVJ7wE1zwl0+igiSRcVoZvuoqn/3I6gTZF8bj4U2u24K3fZfe0eJPus/Ncm9D0+dVA+yHGNllhPmgxpBOv+mk6xOVCMbnvI6/kfbMJJu5wSFKD85UiUl35YAeduFF+8RaOugMRhQIegQoVtHfpOrt0fZVxrMegeLdpRRJ42f8t+QSnvCkeA5JCtFM1qIkpDal8XDbRg+9WyLTm66xEgx2QoLnYhJGDs+v6pfsWTfc8AYW1fY/POBs3A80UinCgoSkzOCQNvpgMyC63MTyuJYkWZj+2t+H5DhVe6cu65tFCKm53FkW4pKTipXsSMi4wGOR4RojlprtN6JHx35lqqKccPVs8O8TKSQGZI8oeTuTsy/OxtABOo44qxPKR19cYBxWmkvvpEFhXgC8twDn/at8Yj2zUa3R3meFWMmOAHVsLWxUUxvGih0jxPoy+h7aj5zix65YlRERAPLHwV7jNCCw+47BQSvD4WVPPWoTQrUhs5k4eM4MYv3Ht5U7wy9oHNZOhemkVV2SVHgXg2xAuL7BMpxT3uxABwwQrgC/8jKoqi6ztJ7n2ctH/N2TlAghiHWxDUD2AAaLC4moXdNC1MwXjfwuNBTbDZHdilMG/RBu9H6gcRen/HR1yVhT1twgcI7yWwXMdti7VFafrAhEJ8jxr0a3MMjlPrf8qXrLgjQpk3I92WiY5hIbaO6EakY96CTJ2qXlfVHgOF2bPgOsR5VoKBSuA5P376VA2DOik1Qa7sVANaIlVZgvoPAr4J6pTlgvXuv6Ghtd+OSo/YNvb4DX+N4PJZD6tXmPJ5DhZcMS
 GlyS4wxe
 CPCaiMpxJzbF+hLY84iH0kKXkKPd+PYTPQs8B39BdZPQAR19aGr/m5bV8dD6qdIhPdGNolidvsgUh6wv/rpyKLARZIRUvxaPbo8hrsLIgTkJZfefpr8Aq84yBPYv0oakcpLg+u8WY/zp7p1QoesGTaiPoMtn6xTnuaPkQBXKs6lEz2jRz5CXdThGQ6piNCplkR25gC52ctgYreiVG3kIM4HO9kpvvzNtZru324FhG63MG7ql728532GSdiA11u4f0n2hA+5U3GGG8LhKBZUXrNgk08oJrti07yF1iq2vsnST3gtM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/16/26 7:10 PM, David Hildenbrand (Arm) wrote:
> On 7/16/26 12:46, Baolin Wang wrote:
>> Classical LRU protects mapped executable file folios through commit
>> 8cab4754d24a0 ("vmscan: make mapped executable pages the first class
>> citizen") and commit c909e99364c8 ("vmscan: activate executable pages
>> after first usage"), giving executable code a better chance to stay in
>> memory, avoiding IO thrashing and improving workload performance.
>>
>> However, MGLRU's protection of mapped executable file folios is less
>> reliable. Although shrink_folio_list() checks references, the access flag
>> of mapped executable file folios may have already been checked and
>> cleared by lru_gen_look_around() or walk_mm(). Additionally,
>> folio_update_gen() or lru_gen_set_refs() only sets the 'PG_referenced'
>> flag for mapped executable file folios, which causes shrink_folio_list()
>> to ignore the first usage of these mapped executable file folios and
>> reclaim them easily.
>>
>> Follow the classical LRU's logic, promoting mapped executable file folios
>> after their first usage in folio_update_gen() and lru_gen_set_refs(),
>> giving executable code a better chance to stay in memory.
>>
>> On my 32-core Arm machine, with the memcg limit set to 2G, running
>> 'make -j32' to build kernel showed some improvement in sys time.
>>
>> base			patched
>> 9248.543s		7861.579s
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   include/linux/mm_inline.h |  6 ++++++
>>   mm/vmscan.c               | 41 ++++++++++++++++++++++++---------------
>>   2 files changed, 31 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>> index b5c4dc0f3fe3..30fdf1056312 100644
>> --- a/include/linux/mm_inline.h
>> +++ b/include/linux/mm_inline.h
>> @@ -30,6 +30,12 @@ static inline int folio_is_file_lru(const struct folio *folio)
>>   	return !folio_test_swapbacked(folio);
>>   }
>>   
>> +static inline bool folio_is_exec_file(const struct folio *folio,
>> +		const vma_flags_t *vma_flags)
>> +{
>> +	return vma_flags_test(vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio);
>> +}
> 
> I don't quite like a generic folio_is* helper to consume vma flags. Whether it
> is executable depends on the VMA. When called from a non-exec VMA it would just
> give a wrong answer.
> 
> Not sure if something like "is_executable_file_folio()"/"is_exec_file_folio"
> would be better, to distinguish from the actualy folio_is* helpers that are
> independent of context.

OK. 'is_exec_file_folio' sounds better to me.

> Also, can this helper just go to vmscan.c?

Yes. I originally expected this helper might be used by other callers, 
but for now it's only used in vmscan.c, so will do.

Thanks for taking a look.

