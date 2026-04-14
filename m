Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD9C5ED7B82
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DEA46B0088; Tue, 14 Apr 2026 04:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5AD6B008A; Tue, 14 Apr 2026 04:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CBD96B0092; Tue, 14 Apr 2026 04:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1D5E6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:15:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8657F13AF8D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:15:06 +0000 (UTC)
X-FDA: 84656451012.19.57D9C6B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D2C6E100002
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:15:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OMCkt5Vj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776154504; a=rsa-sha256;
	cv=none;
	b=8YoZuJ0XGbkH+t45w0Wo8USC/TP1CQSQoARv/ew1hEAF/SSkVIzf9s9Jbc3vF96s86qbdZ
	u65xfh9aLaOXfcK57T94M4DXkJ81KUFibs+zalVEShxxpgLzcOGOgVjHkUlHvVDU8v5/Ks
	u9mXAqKH+cXd2GpiUDjKYyL/gT5oVkA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OMCkt5Vj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776154504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivZq/2U7C+DYMo/lc2sej3cLGew4fj0yy6e/zDClkf0=;
	b=Sno6uCWY7cZLWDGkvooVaAHz/nqfJnywCxmakE/4Rd3PxVBT1BJEW05d49/QeV0Sh5YFSU
	GCDe1mc9bSvfRyEyyFcGJWuHMyWGXH6GQiGzfFqU/qzxKwXmDbbdqoCMI9WZCRGbqC7Mc0
	WUOT3azYpSdHlGY/mz+0rq3urZqt4ws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 41CAC6012A;
	Tue, 14 Apr 2026 08:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD84C19425;
	Tue, 14 Apr 2026 08:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776154504;
	bh=i+61MYwPhyBU9c2P6PAHwEwjeACa/kQ2i7soG6qp95o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OMCkt5VjSw6kunvIIqZ5OYLfnoIvIQ8TBCG06q1EoPeLYvh7fia6rjTK7MCT1AYhO
	 mwz/6KJOe98IMgnm3lpvLQ5tKWZKZ2QGtjhl5F/IMgm/rKKyvjYsFwubauGFtR+/p9
	 GsHxJQuE3R4+sq7g47rBbDOpxpHIL9ZPoGYKjaheuLzvY/6xHLh7z/MoxMCgo9zvhi
	 +CmhxEARIuy5IbMpPW1d5e7FJN+faRgWl8LAy5RBqoKYEeCYWwZnfvLBJrNSEc4eU6
	 gLh48F3XacTq72Ikk6Nwfe6GSMfMNQTXlOYflZUshbcfStdNlNYa9CyEqDC7tJjWQr
	 b1FrDQTMndxiQ==
Message-ID: <e6cceead-04d1-401a-84f1-e5f2310e53e0@kernel.org>
Date: Tue, 14 Apr 2026 10:14:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: fix mmap errno value when MAP_DROPPABLE is not
 supported
To: anthony.yznaga@oracle.com, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
References: <20260402003417.438037-1-anthony.yznaga@oracle.com>
 <20260402003417.438037-2-anthony.yznaga@oracle.com>
 <20260401174440.0f85ea303f0a027b50d99e5d@linux-foundation.org>
 <ca14b239-26db-479f-ba58-11e15f2379eb@kernel.org>
 <2f59c4e3-303f-4e13-a0a5-e1b5e5c1a37f@oracle.com>
 <43370425-00b0-4853-bc82-63064eae2b8e@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <43370425-00b0-4853-bc82-63064eae2b8e@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uwgjeq45ruqnk3c5nyzokop93kph8rdo
X-Rspamd-Queue-Id: D2C6E100002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776154504-83025
X-HE-Meta: U2FsdGVkX1/K6PMEkHDV1f1ZoFAeppjyg27NAxhusnbBD5bcNo9LD5YBlRKPxbfdydTJbLgignsQrCN8FKlNu50W87v06B6qCZ31A5XhM0Q0UYejNJf4AnJ6zwBUtkHQfr4GQZEfRM3TzFxEOx+MjYQw/+tbnrPnjHWrdMu2d5P40BaFaQgJ8MftZMj4Ax/OX3XCzk487T0zLmipbQ9qfNDsz59+k6imQNac6BKi7LW8ur8h76xKxW6PYOoMHdwDtaW8hKjjb5iXTwi8pEnbskvMBykWW5oIQdZzdAKPRT+s3UwkfvYHrEARa7hrA0m/PG9v4D9ao7A120PEshPgFwRa4IWJBHAkesjUd8qqvEvLqzKdbHEtS++KfGtox+Iyrr78w1FIlBkaYAiOCXe7wicG3DLS+hEI1gRlMQVWj+JotkkixJQqKmPHMKlpo9NXhwUN9VGZJWdEtXGE9n8MuPa2aGWP3dvEVL5DCZCfvdiDY/x0cA9Mx/4jUbqOzk9bGbLQRCwJxRHczqs6egIVgG0fBJF5qq1YC9XhIMt64tSyunZz0knINJbCl2e+dV6NBs5/b8ciD0nYaxK/BtCbUrcLtmjOsHR9HlfWSL341q3Ed2hGVS34FQ7AsogR4f//ASdwDLcpKXVqczt2667Fv4hv4VIJAEt5PDDpuntG+f6vvjQro4SYfrHH7q5kZvPRLH4YPk9u0PYhUXL2z3DcEjIA5KZOBlxd7gxG1Kp2LJ8j6ApIdUMIpF5z9vcfcGKL2FE0tJ4q8GeO1361tc4jMzFmHiROALeKdlFQD7UlU3Yv/egneN+y6j2+xg3aIW87JeibaFm6avewjznWBgxvOA7rfo6TyDiI+F5xLYBnKdY0OH4dR85hoDOQoiBUaPNlUYurb6lqI25zaBjCh9evEhIblfWAptAXX+DgaUJ5abN9yo/1bgpqwuRQWJht8QOSrY1PmeB7bAD1S9NBAuV
 DexmJzvw
 GkXMx+vqI686YbZ2OQb6ZhUS0ddeuI7UVqXsja10yGoshmnV9E6FE4ZzB0PO5UQi5dp01xwsDwhOA3t10yGMsw/WKuoy92S4ay81ceuylXsYdltuToC6uk+WmN4dSclCJ1Uf1bTP1SqxkTq9uxIkOfdwkxZUqyzE9UuBEuonNVzZFVa+vlBQJybEiwm73hkzU7KyyYgrzGOiDgCJNrrvRUaR0tXQkDG1oAzQ312NbJJZPWJQQ7D4qxpNfGSTL+KfmOUq4F9hisW3xNL1shvEIfBpiGyKL3y/bEv8NHA5r9YTl3BPLrzDqN8/p5umCwME2Tzr4m48dWB9WDYogha91lp+iOao6MUKlLglNNSV1sp81e1jhuwi+FJlKiXCVSXoqPk5R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 02:43, anthony.yznaga@oracle.com wrote:
> 
> On 4/2/26 4:13 PM, anthony.yznaga@oracle.com wrote:
>>
>> On 4/2/26 12:17 AM, David Hildenbrand (Arm) wrote:
>>>
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>>
>>>
>>> But
>>>
>>> ~/git/linux/mm$ git grep ENOTSUPP
>>> hugetlb_vmemmap.c:                      ret = -ENOTSUPP;
>>> mmap.c:                         return -ENOTSUPP;
>>>
>>>
>>> Should we fix up the other one as well?
>>>
>> I'm looking into this. It's returned for the case where vmemmap
>> mappings cannot be split/freed because they are self-hosted due to
>> memory hotplug. Many callers end up ignoring the error, but there may
>> be a way for it to be propagated to userspace as the errno for a
>> failed write to a sysfs file. 
> 
> To follow up on this, the ENOTSUPP returned by vmemmap_pmd_entry is not
> propagated to user space.  It is used internally to ensure
> HPG_vmemmap_optimized is cleared for a hugetlb folio when HVO cannot be
> applied due to the vmemmap memory being self-hosted.

Thanks for checking, it indeed propagates a bit but never seems to leave
the file. It would probably still be better to just clean that one up as
well.

-- 
Cheers,

David

