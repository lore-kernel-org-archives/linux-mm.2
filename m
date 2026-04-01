Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBD44D35162
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1E666B0005; Wed,  1 Apr 2026 07:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF306B0088; Wed,  1 Apr 2026 07:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4286B0089; Wed,  1 Apr 2026 07:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEC5D6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:34:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7AD941B8B3B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:34:59 +0000 (UTC)
X-FDA: 84609780318.26.A3AB5E0
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf28.hostedemail.com (Postfix) with ESMTP id 16BC7C000D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:34:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o8y9zbXB;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775043297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4YecgBCUmpzx5iM2OYMXpFYsqkJvvJVMsW6paYTTsE=;
	b=s8kytq+d+kQMrlfixjVNSrw7q2lrPG8IiffNAvYxWyHVAeV4iCKi0dUfo4ehMmassfP1SJ
	u5zo8VU4yJA136VM0RosEcaDEb1kevbax2jWdXrmOOyp06slbDVUXfXOyAe8lKhJ+AR3tu
	jjrY7LXkHUpAiYrzNUYYbgjGFl6dGWc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o8y9zbXB;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775043297; a=rsa-sha256;
	cv=none;
	b=dXSnZCwa5HxIJzwbC9ppBWYjpk8bfkLNVillXhNQRjdVXPjx/7VJXlHVMH2ujiU8E7A6DB
	rn6mteVDV6hsMPP6MAXPzfh7k4El5AAkY2rR5FgBHegecgYEaftvahkb7o1JaQM70IbjC3
	Vyi/sztRm74Fjzn68mZbx5QDyjYNfvU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775043292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U4YecgBCUmpzx5iM2OYMXpFYsqkJvvJVMsW6paYTTsE=;
	b=o8y9zbXBNoaEyhU1Becqm4FeWL5e/y/pa1XohYUfFM7yTiy2Jd15j6BNoRJw/HWHZ8WVEO
	YZbA7EeIk41/v+9bwaRyrBaWxG6NtunV7DlkUrpdewku6xdF9CZI1cZYnZN4egrjmj935x
	hObjK7f32DlLp6IjGmytU3pFcEtsiKg=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: lance.yang@linux.dev,
	kartikey406@gmail.com,
	usama.arif@linux.dev,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in deferred_split_folio
Date: Wed,  1 Apr 2026 19:34:34 +0800
Message-Id: <20260401113434.29369-1-lance.yang@linux.dev>
In-Reply-To: <38a347dc-8a1c-4d04-926d-7a6318e93ca2@kernel.org>
References: <38a347dc-8a1c-4d04-926d-7a6318e93ca2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 16BC7C000D
X-Stat-Signature: k3h3dw9o6hus1afp48ads8gqdnkwwcje
X-Rspam-User: 
X-HE-Tag: 1775043295-790717
X-HE-Meta: U2FsdGVkX1/6Y4dE2lX++TaehRt3XYK02cfHOtJ8kBRYlbgBSVu2ikYFHNWKYPlgBGh4u557nyDsebMG4e8v7x/LkdqqR7WddJJp1Gafe4deNqLagq/ll6mlMm6YszeGwaKszzRAwaVnuNCSysjOYUJ6B9326n5VtjdSWW+qQwH6YGVoiFosRyTYiTjZwiUx//ru6S9OirajLEOxsgE8FISdk8F1O4dxLCcStorHba8gMEgfuR6ve3Zf45JbIpibzP/+cq5mFIbH5m0I3VhEuLN62UZ6v1LrNSXm+LrwGaLUysnsq36x0TMk0J9nipNqGUhxz/+X/afMDVBwCRhwlpql6X1yKg1wRoYhZ2MZAPX7VupUBfKt+7S1uZxbztg+hA5LjICVm0lVSbsP7IbU8vRMHuqQSjUMU7Nxl9kBc0jf3l/7EPCWonJFt3bmY3kXcZZhrkgfg7n/MCyEd4uysyrfzOT05HSYo4nKhzNjxTaBAeDzM+W5hhUXdkcbZkmjmYW0c3Ke3xCBFOhj5gCK0erKHG7xv8fsLT+g1DEbyX/eKh6lXePSdZJeI10ZvxShi9eB8G+212smMcUHvDbCVuU6DxHlvdvRdLaKgahDtNgNB8xtbXsrNvJlrZuAmK4wJnUpqD4QGeRfRHYXO6yMiSvEDfMhnKvwnC3sjpN0dxKPR7oat1w6lHImiVtxesG1x66oRqTJSsvamDtGkO0KnaXMcPidI1hEK6qVH9W/hYBKFX+LXTC13CNz1mYndehikUDTbdhGshxB3WDXMt1bVp4833F15q9yDMd/6nPykbUWMDNSsFF+Wa2XKc1jp4mxTIRGIak5Lb0+8kkAXFBwf7Dm2uALyS+4S5hGPp2yUNqlbL1pOrv+vEBrWlgu/wX2v5XwkOpeH1LXLz2UF6xmgahIh2qh057cJbVGag4lLExf3+DzK57rVUyBwyehGZhhq/zGRz/JZ9bZJbCm7N/
 EpGE1AjI
 ElanJJ1pdOHybNG9L7/BuHZsXwSx7y3q3IhFTyQqgEV3E5IixRRBfvZMw4iM/e98pYVsDW5ooFeWRtnMfmo+UAKU9Q8nx51p4xvjCKXN8ix1a6jcsHIcSEq4UcbcvVazMP2x1gtJgYMB5v2T10v3Xak/Gr9GqFuNFVcBoGZhFlm2R0DvCrcdhj5TylrKlkJGGaxv/ERY76H1nk9ZjyZYTAO8hd/z5O6P/U8Kr6YN3igZKmMYojte/afWxWorsAo1OP0xPEBdOu0NzMeQiVOL0zgGVCTKMP1UGGn4sBdSWoFRDsKvlr8BvpNGkCoSVTBrmdGMOvOX9F4TGoo2fCymPh45Dyf6M0lx3eMu/2BieE3ZIribPVr7CuJ0bnnjxHAt3Pi/mjLZdHs8gf1CGWQtCtLn8Pk3GfCmb3TWy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 01, 2026 at 01:22:58PM +0200, David Hildenbrand (Arm) wrote:
>On 4/1/26 13:20, Lance Yang wrote:
>> 
>> On Wed, Apr 01, 2026 at 01:00:13PM +0200, David Hildenbrand (Arm) wrote:
>>> On 4/1/26 12:53, Lance Yang wrote:
>>>>
>>>> +Cc Deepanshu
>>>>
>>>>
>>>> Afraid not, it closes the remove_migration_ptes() ->
>>>> deferred_split_folio() race, but opens a new one with the shrinker, IIUC
>>>>
>>>> Once dst is on the deferred split queue, deferred_split_scan() can
>>>> pick it up immediately. The shrinker unconditionally dequeues every
>>>> folio it visits:
>>>>
>>>> 	list_del_init(&folio->_deferred_list);   /* always */
>>>>
>>>> Then for a non-partially-mapped folio, if folio_trylock() fails
>>>> (dst is still locked by migration), it falls through to:
>>>>
>>>> next:
>>>> 		if (did_split || !folio_test_partially_mapped(folio))
>>>> 			continue;  /* not requeued, dst silently lost */
>>>>
>>>> so it is *not* requeued.
>>>
>>> How is that different to the shrinker just trying to lock the folio before we
>>> unlock it and failing? The race already exists?
>> 
>> Ouch, you're right, I was wrong - the trylock drop is a pre-existing
>> issue, not caused by the reorder ;)
>> 
>>>
>>> To sort out that race a trylock must not result in the folio getting
>>> discarded.
>> 
>> Nice, LGTM!
>> 
>> Given that the "trylock -> drop" behavior seems to exist already today,
>> do you think it's worth fixing that together with the reorder?
>
>I'd do it in a single shot if possible.

ACK.

>Can you craft something? (cc stable etc)

certainly, will do! But commit[1] ("mm: migrate: requeue destination
folio on deferred split queue") is only in mm-stable now, not yet
upstream/stable ...

[1] https://lore.kernel.org/mm-commits/20260329004127.334D2C4CEF7@smtp.kernel.org/

