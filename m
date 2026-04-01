Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F5D1D35171
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548006B0005; Wed,  1 Apr 2026 07:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F92A6B0088; Wed,  1 Apr 2026 07:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7A56B008A; Wed,  1 Apr 2026 07:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29B7A6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:23:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F5CF140233
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:23:07 +0000 (UTC)
X-FDA: 84609750414.26.E0A6E41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 92A2F20005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:23:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OAYiie9x;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775042585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6IYT+Gxg6Ov6vp9RfC3eCg4oJkS9ZnVnGQITzPj/Ec=;
	b=H+ec0+Xzk03C149O40QmpzLZkI3jNZbHHpInQuUXOOlhAM+omOkK9HfoShDlZerLfJryyW
	kWxh8ux7JEkohWjkzXtZytGhT25behzj13SFqxqkgvrT6R2khuXVkubK/p13f+DhS/pRBP
	tjFXP1ZNKPQE4MHQ/+1ftLTt6ZGULRY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OAYiie9x;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775042585; a=rsa-sha256;
	cv=none;
	b=RklJwpn9m7REkiYaWdTMJn7UXjqMGsb6mPnZZoJAqQaNURNRgOVeiCtXXMwqm2vg5DgTur
	I4k76oh1+uiICeoXQvBis15ut/RNlXqY4zjLlQRCUclxfzoeHILUqW8tKUNUF7De/i4bpj
	pBaWwl157X8jtrk1n+s4culbj3VI6t4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6DC5408CA;
	Wed,  1 Apr 2026 11:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA60C4CEF7;
	Wed,  1 Apr 2026 11:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775042584;
	bh=J0EmuxBv/Kz9NWrvoGinSM8UV0p+xOj5OhofK5if/u8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OAYiie9xMgfT6uDxgfp0lBvoMUkXBKZEv9Ad+PONHhE3osiVap6EDg7S83N6dOxG4
	 BOhBKX9EW+wWtspp3GHKQuJPhXcHMrHwSiOen7j+dXdYfQoLg+HvR+Rlut+b4Vs8Y9
	 hiHL0/gZ1FGKpgzoDI84Zt103PIGfijevKrRKZSnaoN/8zLX978yPK3Zt6nJ6mIjFH
	 SitOr1lq0lBz/bhpbeYlZJ6XyfWqbAlu4zC2eWxfL5grIzkHHS9Y0GWFOl3ZXCacq0
	 yHrBkUWwSILHjsbB0dxQqzMEYIc6D57gX7vk1/uEhLHkYkPJEHILGqeeA8RyWUX6cl
	 gjPALjSfzUSzg==
Message-ID: <38a347dc-8a1c-4d04-926d-7a6318e93ca2@kernel.org>
Date: Wed, 1 Apr 2026 13:22:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in deferred_split_folio
To: Lance Yang <lance.yang@linux.dev>
Cc: kartikey406@gmail.com, usama.arif@linux.dev, Liam.Howlett@oracle.com,
 ziy@nvidia.com, syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
 akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, npache@redhat.com, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com
References: <f28d968b-1d09-4db9-9f4b-55205f43c951@kernel.org>
 <20260401112049.18634-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260401112049.18634-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 92A2F20005
X-Stat-Signature: iuw4ffqi8z31znp64w7jq57xr5z5fjw6
X-Rspamd-Server: rspam06
X-HE-Tag: 1775042585-553396
X-HE-Meta: U2FsdGVkX1+3AhuMIqsVZlDweVsdBeO5kjPEi+ptpD6HI1t2v60zkmljElmZ5Lo7+saDSFdK5NhkG2NtifPscfQiAt4JacWogCF/fnH9ezBkgeZR5ZV/Loasoh7wsMxusfLA8iQt+4eqzDFgCQD3pykMyy7wJI/RQUfjvjv8Td5lTUOm4lVT6eFJ+mD0qk5M72Cn3U7F3FigyO4C1kFXXOOaP4BvPthnJ2rUdQPvPf8YxehLY1RBcqC+WqLm/jjjGEh/ZY0W8BDDKE2D6WILvqeyKNdXij3n/Cw0QFgv1LoAzagBrbTWb1tXfeUEyXlhh5+b6FVj8Z4fKfrQhik0/ksI6uV/SyoFPcUzXdpuOhouX8mR6hmFumOumVHrSY5VeA3knrLlvxPz77hVLfaj6kMUCCY3KWp3q9y/ofOQuNAoEO8UNmjCRidOzIQHBorkt/lOhFKA/IS7gTFXH09UJ32t4LBgXPv4HrOIlcaOQSgU0kjwFMfVTo9EnDVfjrujdwKDr0JT/G9z00LI+q3z+fP3elRmX9FXoyAQ8MClQj2XKC5xae6FCl0RNH5fKosFv+FDonAcmwdyRCxdLJOuzRxBik/7oSoYmpGqHgMX7bP5k+yEle3YUeP+b55bvHflc2ko5zwrWjVSME3O8HM+Um3N8J0dAL+Gc+36M8g55OcFhU3x/xj/Swc5S34GloE3MG5dOrQZxQ4wK+JSLmQ2n6TwSiw+hO5dvbhe5hLS+tdrqXwyXiMs4nrrBaHVPUS0A+PCo0JxWFpvEI/VrWLH/55IThlZDclOXLYRpsrWApyleqjTmC/UIY3e+ktUpZfa7MrWF4/RGrmPnrUpXDa5bonouGB5JW0lS6sgMDyjHTKLFiqmdbN1eGm6DJ86BgkeHo9HUON+1qYpxM4huOEegB4LWLsRZ4pFYp16FQvbkRSkUaLo2yF5HYdWyTjUAtyWU2/cTatSQ4oJmuRYgPB
 riiOkOGN
 X0o9qKcwsfTYU3o0PksQSpg21vvsFHrq9ACmqhG4IU3/KKR8E/fbUai9oTiFMdxSmHNY2u/nwp7qVCVSuTgBVBxSKbze8c5mfgBD9Vm5/CTjNVAa9rWSYAKNxdpM8SZ07nLfg2MikYTJbGYjp+iSNcgQnuCLieUU+JHxGqFUA3iDopWDzFCv2K8tfBK1wVG4E8QjC5d5wNUsQOK8CCIqVfaVhN2EezCtmd+EZY1ok/MTAAmZMYxR9wXG4sakXcFaPn8xAaz0vsRfjboZc+tamaMAYPXZeFWhi7CmHAbxfPtekVxrP0v9GnTC0jFlrqaeSazNb9QQhl2GGa0hBDICHPtLB9e6oSTPqYphPYhpYqYdjH/zsybF901PQtmnq3z/owNfVguNR0CaNIkhjI8SLhUX0+S2DPUt7jFiQVj8BH9RRVmSg48ppC/OROmtovU1IqawM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 13:20, Lance Yang wrote:
> 
> On Wed, Apr 01, 2026 at 01:00:13PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/1/26 12:53, Lance Yang wrote:
>>>
>>> +Cc Deepanshu
>>>
>>>
>>> Afraid not, it closes the remove_migration_ptes() ->
>>> deferred_split_folio() race, but opens a new one with the shrinker, IIUC
>>>
>>> Once dst is on the deferred split queue, deferred_split_scan() can
>>> pick it up immediately. The shrinker unconditionally dequeues every
>>> folio it visits:
>>>
>>> 	list_del_init(&folio->_deferred_list);   /* always */
>>>
>>> Then for a non-partially-mapped folio, if folio_trylock() fails
>>> (dst is still locked by migration), it falls through to:
>>>
>>> next:
>>> 		if (did_split || !folio_test_partially_mapped(folio))
>>> 			continue;  /* not requeued, dst silently lost */
>>>
>>> so it is *not* requeued.
>>
>> How is that different to the shrinker just trying to lock the folio before we
>> unlock it and failing? The race already exists?
> 
> Ouch, you're right, I was wrong - the trylock drop is a pre-existing
> issue, not caused by the reorder ;)
> 
>>
>> To sort out that race a trylock must not result in the folio getting
>> discarded.
> 
> Nice, LGTM!
> 
> Given that the "trylock -> drop" behavior seems to exist already today,
> do you think it's worth fixing that together with the reorder?

I'd do it in a single shot if possible.

Can you craft something? (cc stable etc)

-- 
Cheers,

David

