Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10F92C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 12:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDAC16B0005; Wed,  8 Jul 2026 08:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2CA6B0088; Wed,  8 Jul 2026 08:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7CBC6B008A; Wed,  8 Jul 2026 08:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0EEF6B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:58:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 35C6B166C85
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:58:58 +0000 (UTC)
X-FDA: 84965614356.30.EF8DB37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 71CF820004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:58:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hD7+plP0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783515536;
	b=jAP2yTUoqV+N8KWI0aV79TtwLERhhEzqDu6HdqTolhVw6h503K49ctf6dQHBbcXMiCFxmT
	MKkr6A7f9exJahkotrxW51RTiCXR9oU0xgrDJm9tvSLSfy2upnZwqZrWGEgRTfgIeG5fJX
	znCdWPGAUyvjCsM25igx53U/773yOgI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hD7+plP0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783515536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c71gD0d/GZ2315V+PSrCspFISJs853XXy2rIZMBL9EI=;
	b=3FvzEcYBxe+v/WZxNB8Ygky9aat1bmdFd86R6DL+iP/QkhqKgmLqoOaEKNbTHHrx2MCDGA
	EFW2MEPWqmTSAKx7CGvOR1poBqBE4d2J/9CrYMG29NLLtbaxLXi+0mBhKtRtPaO/PNZwBt
	A2duRa64suaz8jg3aozAZB2kKH/3/MM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9FC360008;
	Wed,  8 Jul 2026 12:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646631F000E9;
	Wed,  8 Jul 2026 12:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783515535;
	bh=c71gD0d/GZ2315V+PSrCspFISJs853XXy2rIZMBL9EI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hD7+plP0P6kLRZCuR6dVAeMRNGWiRMlhBjD+F/qOgiyxaCP3z346bJ6SG1rxDZUrG
	 UfUjPvzR4ZsWMMp166QoObWv6jjDhSLyYbEnDPVz82E3Tq8yFEo2dKegLX/gOsQtcX
	 I9kxnfdxgdz42KAVVRzldK37LI+YXb9k92XLNrKXalIo0j/fUwru0X4bdsSumrFRVl
	 bTMWeO7MD2mrfwpEDDRMK0aCAnLS2WUE7rxXE4XnV6gTq2vMoevpL9JIRLVJkORjUO
	 oQK+ep+DaEmRR7AaaLfi7/0mTClbILu46cd6m4+eW4I2GZ56odhxPwFAcBVmmzfyl8
	 018tFXp0trwEg==
Message-ID: <1e6be746-44b5-485c-8adb-4a21b7a3d03d@kernel.org>
Date: Wed, 8 Jul 2026 14:58:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm: Standardize printing for pgtable entries
To: Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: andriy.shevchenko@linux.intel.com, usama.arif@linux.dev,
 hughd@google.com, willy@infradead.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260708032824.969752-1-anshuman.khandual@arm.com>
 <25cde246-540f-4ab4-b541-0b7313c57954@arm.com>
 <76f24730-46de-4583-9189-ff7ba28c741d@kernel.org>
 <724a080a-bd4b-4fab-a890-c6a97ebff77f@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <724a080a-bd4b-4fab-a890-c6a97ebff77f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 71CF820004
X-Rspam-User: 
X-Stat-Signature: rffm71jjoo8y6kmguxixeapg9sf13ito
X-Rspamd-Server: rspam03
X-HE-Tag: 1783515536-399874
X-HE-Meta: U2FsdGVkX18USxtx8rhegpy+mYUr1LiJypovIl2GPcgYa6nXVCuaq5o4/Diy9JCJbw8Bi5tOX9stpQCVxq82g3IanQxiC9VTMPoOzcczvhMMAyq/13APBghYvXbs2QhXz61vf2Y31ltL0I/wpuZLHWhY5atae8rMb98MDraDcRACn5/258ed1VN8E5rRuOz9/gFbsmCgNcux2OqAeFmoJ3nvIkKRu8UolpIdnBcUBkTqpcPb5NFtD2aIHr1e9Oiqxp1E+znKE44JMEmdwaPhxYmAbJ8M9zNHW1sFMJzZ/MnfmqxnF07QCAiAWDkA9z6eQo4Otl8giU6ncn0rE+btZY9ukBP8BqGYDbArwdkl8t+Pz08IrI9+5osMxEOfwb1D5l8CkoZI6izzBg72ckyEWGZIDwZswQsxCkB+xEXR1VCGC3PXe/uD7PinnKGVss8aFyVg9wmii9sbmZPOB09aTSMflhcYpmYZzh4dQu0GKl+EW8AgPYmwubYGsAEmwcMkd+5Sqw4on1qd0AQMikPdDEFXjcPp7oiyxZA5NUVspHe0F+hawvk8Szo7wY0v10pc6AqzcIdzVk1NyrWBGvzbvg1fTw7vYmfVW/yB1DWomuUQ2quPj1GtFcPM/kfvTvttf4FuDiNrpoY5+2LDqqgqct89gOYg8/zliMWIOTQzowdbCqIGdl/6/vL3FZe/VSZW7TBtUJCysS+V5PEoIfpFNhH9faQmzIXuHjGG+B6pPwU1wqXMYmjmjb4ovqd1qdi82PNHqbBK6Q4AF15gaTUhEXwa8sJeJv6PynRtD9nhPtt2bQf95jWt1+wDb3vAZ/lcmHl7JJaC2erH2SPqZkomlj2zJHOun75uOh1mR/XmNv5p0G3BfNywf1DQGUECAI2A6UDvjvJC7AA590tlBLWDP4ju/OTKQmXReBCmTefgPdyqniz2JP8xATzKizWa0LSjixklYK7kwIIYdO6ZuXm
 OYYWfmzQ
 2GCFzWm+OoiJZzd48WGzVhBXG6YAaNGqs1Lhrmta6FDn1soK4YcgTaj92Z84c93emOBCX6Xk8xrT9tjo9XnJXMtemrBcl5sjtSdOdPdLSCr+auZzIusJX1tikrE4QglBvuZdzhle2Co/F7rptpHVhUucGsN+JK+rSNG2BxrRmCZ7so+2XdD329vWIYRmvjbx8QQQtvmxFxLJi5365X/JkKQJ8ZBgkeLv1hq5L9JygIMtE6ykEpNga7bm1pyxokHaRVIiu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 14:43, Ryan Roberts wrote:
> On 08/07/2026 12:27, David Hildenbrand (Arm) wrote:
>> On 7/8/26 13:22, Ryan Roberts wrote:
>>>
>>> Not sure if it's worth doing something like this?:
>>>
>>> #define PTVAL_STR_MAX						\
>>> 	(MAX(MAX(MAX(MAX(sizeof(pteval_t), sizeof(pmdval_t)), 	\
>>> 	    	     sizeof(pudval_t)), 			\
>>> 		 sizeof(p4dval_t)), 				\
>>>     	     sizeof(pgdval_t)) + 1)
>>>
>>> Would probably save stack space for 32bit arches?
>>
>> Do we really care about that? This is about a corner cases error reporting right
>> now.
> 
> Fair enough, it just seemed like an obvious and simple (very minor) improvement.
> 
>>
>>>
>>>
>>> I think arm64 code also does pte printing, which you also need to fix up for
>>> D128 support. Perhaps this could be moved to a header for reuse?
>>
>> We could do that as a second step, right?
> 
> Sure, but why churn it twice? Anyway, no strong opinion, you're the boss :)

I'd say, if we're going to reuse this code for the arm64 pieces as well, we'd
best send it along the arm64 pieces, and figure out where to place it for
arm64's use right away.

If we'll defer the arm64 changes, I'd also defer deciding where we'd be moving
it to.

-- 
Cheers,

David

