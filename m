Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5934CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 13:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993DF6B0088; Thu, 25 Jun 2026 09:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944616B008A; Thu, 25 Jun 2026 09:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833CB6B0092; Thu, 25 Jun 2026 09:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5B16B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:46:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAB3F400FE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:46:06 +0000 (UTC)
X-FDA: 84918558732.10.CB9573C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 20D78140010
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:46:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Avj/XC3r";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782395165;
	b=8AIVmuUsuN9dIrS5joBC2N9KXIguvbmaUis2q6OBiyFiE60usRNVYoWZKLhK7gzGUNPHtQ
	vlN9fNwMpjFZUDfM+9WocaEKU1xdAuK1D6wm/y31dfosZ2JLAKDO6rwQRYrvriTj1tKz9Z
	vHbIDhK+Cnevx7/gu0gUFUXo5sWwPyM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782395165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7vCmlcktu/OIt286nnCz+UC1Ri3OuGM7sGaYKvlhpg=;
	b=pDBzl8tUzn/Vima2TitCEEACf1GdPrDu7GwCsoZV/TlaKAamHlAWPPKR2u/JR1s1BimN7N
	yEwxkKseTmuSWDVkOdrT3PdlU+6b4MFN1gY6sHywwe+uvy/F7NVQtp9MbTv3VvQXmXYBL8
	JkWXibP0PCxXy/4t9S76G+P4/P4HCdI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Avj/XC3r";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF60A60018;
	Thu, 25 Jun 2026 13:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7F41F000E9;
	Thu, 25 Jun 2026 13:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782395164;
	bh=j7vCmlcktu/OIt286nnCz+UC1Ri3OuGM7sGaYKvlhpg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Avj/XC3r0JOxKdtvE2KK5ni2zOCBC6VC9iuKOzh7w0PvIotLT/ZkBBpRkBBwV0Q0Y
	 0ajS1EJviOxR03Qr2eRKs6UttA7u/nNrskxDz+b5cl6dqkOs68ZnKPFteFqOggO7gd
	 Se4F+1NBBgTIss9OgyCE5bb4WYtE1WCwlds3W75Ma+uJYVy0W8axyk6o8iIDPv02wr
	 std9SB3G/CBDB0Z3nCUsYYXSbIUIpAArTsfeFqc4BurNFSsqZsxgGfoQ8EVF012eNu
	 K5DDQ0/6n6snlPg6brWF0CD+lc2o5mC/nIL5UgXJVkeBEZNXbdqFbd4cdqzkGcv8t/
	 TdbOzjeKrJh/g==
Message-ID: <3af41c23-2365-4ac1-b1b9-076b6ef7ae9e@kernel.org>
Date: Thu, 25 Jun 2026 15:45:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org,
 axelrasmussen@google.com, baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 kasong@tencent.com, lance.yang@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 npache@redhat.com, qi.zheng@linux.dev, ryan.roberts@arm.com,
 shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com,
 zhaonanzhe@xiaomi.com, ziy@nvidia.com, Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <5790c4a4-d502-4180-82f5-47de5809a4fe@kernel.org>
 <20260620081017.89085-1-baohua@kernel.org>
 <4aa8350e-712f-4380-b3bf-2ff06cf2a35d@kernel.org>
 <CAGsJ_4xR0Ge707s8JAfd5Fw10+U+25_nuBGuVayx9qnxR+NnGQ@mail.gmail.com>
 <c29f90c6-2075-43e8-8f0d-0d6718a0f124@kernel.org>
 <aj0u12N_GzGtQT6K@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aj0u12N_GzGtQT6K@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ttxsuimrzngzawuzf3a6jt5hyrsans8c
X-Rspamd-Queue-Id: 20D78140010
X-Rspamd-Server: rspam06
X-HE-Tag: 1782395164-124776
X-HE-Meta: U2FsdGVkX18HdZeBBA3RjaO9lpMd9X5Naez5AhqyN5qlid8reKla7tvl5o9FLQdMFzTIsRh+ySf48fm4il97z01kc14QDi0liHDnPsOCEycB7TU1wMtS9KxhCXjxrx9KsMlj2ItxieCeQ9XmMcveDEdX1mlIZx46Tyx7MD39KiwqAAnnBor7pAvUnIdm4hzcMqT/vqk4erAFb1+Bm0WZxSW7pjcUGnBNT04BA0+WAVFwD/O4LuVPM9hJXF70JIZ3sQss4jAY0NB6AFHUjr23r+YscEakBSZLU8c7OlnABDPaLWfU613veJtnyxK4cc6rHJVtoPhBK1a7HFemdiBCE2ULns8ziiUmQMcs0ly/OjAmipxtWBm9d2e8DT9rkDXvbp/w3mwLUqkHMB0h+nImhBKpN+xS93VAPgpak9BsDA6bWGdOYnZwjlQGTvkursG8qPQ7BLh+sgYd3jkqTo0c5baFH25L0GruZUfJjwhpcELOwwbDWbEmeW3keVJM+Y60NVYcT37x7JeUGOjDI1ZW/3CV7PcXVkbzxNstOdFM8Pt/7/UyDuLSjmdWMTeh/Yr6AudiXTkGu9z4jb5wampJTwnC0PwsVYQnI+BH9ZjuIvzlqBI1gzxQbDdV3RdsUm8fxt1Ahu05qKuqA5kH5ci5yuI5leLTr+VvzHCdMoD95GwgqHD5P4xPH2R6HKpaYF57aBNjWWYQlz0terZtZXYdO7iE2WWU+e+CqkhJmRyFvzBEhUIwERHb0SD9U0MwSbbQI280sARZhhTSA7I/TXmnkd71Lkn3on/gX1fMnHEEUJAQmBDXswge2BLxXoSPlG7NULYtcnmqudjMfQOFOUkzGbsYo9r+nYzOzJ+LzjHm/ppiZHD8MT87KA5mu2G4ekdXSPFYkiApG1LFETuEBIjwG/BIaTkTo+hy2yk1wpWpYeX2/oHAVfzluyftvUXc4rrs4imGoTSFnM/j0CdcXJm
 D/NnnLYG
 nh39gFlsJksHAKPC9cTBjQ1/PtMs/eAOhcmWFvf6YeZg2t6q3iDVVDjBdvS6GT9uhAbK1GgvM2a7tzUqqTTeJi14B0iSivzXTPVrPM1c+9hBzLE8VBlBPpnK0jlHrp76jIAYmSSfM0HKmuTRTn73TUnDjPQRtiHHqcaX8pIZJm4rOOUh8V07YvoV2VAs/8GC0jZcyZFf7rPNByLIKep+x6dd6JDdj7S4lual4GKOsMQ0soHD/6Yi2uLxJam17CM3STKq/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 15:36, Johannes Weiner wrote:
> On Thu, Jun 25, 2026 at 09:49:56AM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> I don't quite understand you. get_nr_swap_pages() returns
>>> nr_swap_pages, which increases or decreases as swap is allocated or
>>> freed. I guess it just reflects how many swaps we currently have
>>> available?
>>
>> Indeed, I was confused by the function name it's "free swap pages". So all goof :)
>>
>>>
>>>
>>> Yep. The tricky part is that mem_cgroup_try_charge_swap() cannot
>>> return how much swap quota is available in the memcg. Do you prefer to
>>> add an output argument to mem_cgroup_try_charge_swap() to expose
>>> that
>> That would probably be cleanest, if that is easily possible. We would want to
>> get memcg maintainer feedback on that.
>>
>> @memcg folks: we'd like to know whether splitting a large folio would make
>> mem_cgroup_try_charge_swap() succeed on a split (smaller) part, to distinguish
>> "there is no way we can swap out anything, don't split" vs. "we could swap out,
>> split".
> 
> It's technically doable, but is this worth the bother? The remaining
> headroom is less than a large folio. You can split this one, but you
> cannot even swap out all of its subpages anymore?

I was asking myself the same, but when we think in terms of THPs on arm64 64k
we're in the range of double-digit MiBs.

> From the cgroup
> side, we don't need the limit to be obeyed this rigidly. We overcharge
> temporarily in other places if it's convenient to do so. A fuzz factor
> around the limit is acceptable.

Thanks for that information.

> 
> But if you still want to do it, here is how:
> 
> The page_counter_try_charge() in __mem_cgroup_try_charge_swap() walks
> the hierarchy upwards. If it fails, it will store the first level that
> failed against its limit. You can do the mem_cgroup_margin() math
> against this counter to determine headroom. An ancestor *could* be
> more restrictive, so you need to finish the hierarchy walk to the root
> and use the min() of all the swap.max - page_counter_read(swap). Then
> return that in a return argument from __mem_cgroup_try_charge_swap().

Thanks! @Barry, up to you if we want to implement that right away or if we're
simply going to assume that if charging fails, not worth splitting (changing the
existing handling IIUC).

-- 
Cheers,

David

