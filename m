Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F671EA7944
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AF386B0005; Wed,  4 Feb 2026 16:08:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C4A6B008A; Wed,  4 Feb 2026 16:08:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CC66B0092; Wed,  4 Feb 2026 16:08:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 53C346B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:08:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 048BA1B14A0
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:08:55 +0000 (UTC)
X-FDA: 84408013872.23.3C91E38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 678CE140007
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:08:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mj8+82Ig;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770239334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QsI8HZjEiZi6SMM2mODTE2c7Zj0pkzLKVbPnQ9vPFHA=;
	b=cCkn42XYwMir0suNNhrQDsLaHgE8aKcuXTAPkQM/LDzDON/QOffUDg+5BSB+Lh4cse1rji
	jIEMUfcaPqVb+9cW8KxGqc/1qTUUUGzDqRMj97RMTKCFztbLmHs485fpahML3QzdngoD8Q
	zFvoolz2H+BlSraDNUUnS+6bRr3M5p0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mj8+82Ig;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770239334; a=rsa-sha256;
	cv=none;
	b=lj25cgFS/HfkltGQo5AOKwew6539EwYbaXfUjsLMF4jNZMGb6NSYZJotd+Zq6OxxGaCRGV
	n2XpES47J7sqEr3kGsL6Di8DZWW2W/fp3XYXp9HAjIfFy2S093LdrpbMdlWaubRwstpmuQ
	zarx2YksBnlOduyWb80WryEfLe2ddpc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E3CC60010;
	Wed,  4 Feb 2026 21:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F8BC4CEF7;
	Wed,  4 Feb 2026 21:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770239333;
	bh=L0yw/ZVXlFtoQTEti0lXJnZOK9g6qlS6ZDzawp2mTxk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mj8+82IgGzyI6MJVVLBy57BfvzFo3eflS+GZ+P1hZLQt56+SpuW1qDVqN8T/4ok0o
	 Bo/rnJCkRFxA2hHtsudRKnNMpNYNBdWsAmqfrIlIfhZc6vHsQIb+ZAhvYwZS2jZXLM
	 wWtnZJhzQS+BE7Rdsf9bzz9zjQkPcsWgu2dBs6CjaDd/qr8NqBAXklQ8EJcKKwXa9n
	 eeu5Nk2sTeurjCq3HR22POQH3xW9KiCL/0feoY5DwVCs5gR6vM3oY8Mf+mfvpsaFmN
	 PhQ4IDgGm70galBMIGm9sKMnra1XxFhBP8QX6JfIgJE+Pfho5g5dqLokt2mrFwSNH4
	 PBc5rPqWtN5pw==
Message-ID: <3424eba7-523b-4351-abd0-3a888a3e5e61@kernel.org>
Date: Wed, 4 Feb 2026 22:08:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] mm/memory_hotplug: add __add_memory_driver_managed()
 with online_type arg
To: Gregory Price <gourry@gourry.net>,
 Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
 dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com,
 ira.weiny@intel.com, dan.j.williams@intel.com, willy@infradead.org,
 jack@suse.cz, terry.bowman@amd.com, john@jagalactic.com,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-3-gourry@gourry.net>
 <20260202172524.00000c6d@huawei.com>
 <aYDmor_ruasxaZ-7@gourry-fedora-PF4VCD3F>
 <20260202184609.00004a02@huawei.com>
 <aYEZAUJMLWvaug50@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYEZAUJMLWvaug50@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 678CE140007
X-Stat-Signature: s5gzfz1x3oncady9t58e98dq6tghuz9s
X-Rspam-User: 
X-HE-Tag: 1770239334-981186
X-HE-Meta: U2FsdGVkX1/rui56la33euJ5n5oMSMQMnnVZidmH86D0rX8ulMcPgE2Uf4EEeZ+YC24b5+Zq/CNrvRZGRaU+1jTymYL3DJxJVnR4wb6bi47Lkq4ym6MtjwxNg+wWCYN1Z0XeqWbEuV5eP437PdxPdOIm+hI5DKcGXpvbyl4BvlqE08LYQtnxn4hx2PLKIZo+4/hIgKLO6vKitmRU504WDY+DugaSnFf+a6CO5gSNVkKBVkbv9UkmrEuy/fQpnL+DiwYq4WsZT0mRPU/3tViZcEj7dzDBTY2ZfRLs5bCGtfRzaW8//iiCCO3axu3CafsYLlIvcafRp8meEgShOdedeCR//IrlvY/LSfuwWgZUojaswew1764zCl/P/ezSfoNIZF9LOh2VuToCBtKQSjqExhsgQk6D91viroqrinAFLP4EYUAhw0ODezPF9MAO76Zd+sHsH3uvptTTGjzf5nIKm8BnG0d+VuSJy4oJAalu3ayb5B3nV9ZbI5GgPCTF3RQ4URv3vEYuZBGH2Ezzcb4f3fWuKO6od/1h0osUWv5y3nlhAFgsmCiDatNdsRUdIIl52qC1dLnAkaGiSTKdF/xVT5qG7vB6bX5YrQCXsfC0nlXILYs7MhGl3MJ/zAPqjyF9o/zYVVWg8uasmbReV+MROfWFCwZS1Z56+/nJfit7verX2czww49SGGpAzPud8YJKpl8yi+tnA+d910s/sM4RoHzrfc9J3waj9fF4lgQ+IEvZfGMNtTYYX7PaKYSlCk8Kgvzgc5CXNOvW+FGXYAWCZPw7Dg/it/QldwNjGQVm0Y2dzuMOWyt4FI7tPVz4Br6I+VGBrT3+BPfP61Zbw8OqPBWNMPlsi0zkDpsBS+BwCrYOKw8GYWFJFcw1JBjoekk71+bhuEByiYIOn0plWvNI28Uu423laR8ZsUErP55EEbCgzZuUsJ8iXVLxs9BpNGPQ72iEfisMOh14sCat5FO
 2vrSycVr
 vryl6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 22:37, Gregory Price wrote:
> On Mon, Feb 02, 2026 at 06:46:09PM +0000, Jonathan Cameron wrote:
>>>
>>> I can add a cleanup-patch prior to use the enum, but i don't think this
>>> actually enables the compiler to do anything new at the moment?
>>
>> Good point. More coffee needed (or sleep)
>>
>> It lets sparse do some checking, but sadly only for wrong enum assignment.
>> (Gcc has -Wenum-conversion as well which I think is effectively the same)
>> I.e. you can't assign a value from a different enum without casting.
>>
>> It can't do anything if people just pass in an out of range int.
>>
> 
> Which, after looking a bit... mm/memory_hotplug.c does this quite a bit
> internally - except it uses a uint8_t
> 
> Example:
> 
> static int try_offline_memory_block(struct memory_block *mem, void *arg)
> {
>          uint8_t online_type = MMOP_ONLINE_KERNEL;
>          uint8_t **online_types = arg;
> 	... snip ...
> }
> 
> int offline_and_remove_memory(u64 start, u64 size)
> {
>          uint8_t *online_types, *tmp;
> 	... snip ...
>          online_types = kmalloc_array(mb_count, sizeof(*online_types),
>                                       GFP_KERNEL);
> }
> 
> So that's fun.
> 
> I'm not sure it's worth the churn here, but happy to do it if there are
> strong opinions.
> 
> ---
> 
> David do you have thoughts here?

I guess we should clean that all up where easily possible, but I don't 
expect you to do that.

For online_types I used it, obviously, to save memory. So I'd expect it 
to stay at least there, but cast it to the proper type once we take it 
out the array.

-- 
Cheers,

David

