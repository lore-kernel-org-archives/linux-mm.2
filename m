Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E18E6CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E151C6B0095; Fri,  2 Oct 2026 10:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78316B00A0; Fri,  2 Oct 2026 10:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4216B00A1; Fri,  2 Oct 2026 10:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 93C1C6B0095
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:26:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13FBBC0793
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:26:52 +0000 (UTC)
X-FDA: 85277912664.19.FEA5D65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3CE984000C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:26:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4NVIkYY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790951210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v41WPIaDJ3L0NMm68dV3mJzy8zuOhzTrxEWsr1nESBw=;
	b=2/1dxVz/7Qty4wYpRFhYyeMtJdXlALwzFjhWhc/krgHEq8/LYZ9cfSoG48Mk5j1DuWe537
	JQQE9RCmQ10ktQvCHql+V4HHOTERM1nJbBhdMqBLNVbNBFOL2hjQNoUhjxFDJ2LKJ0KMLt
	Yopz3aFA5K849jwYS8NOb4zCRLkKSkU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4NVIkYY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790951210;
	b=jl03vcLbdIHCSyMMlrsPtQVJY6Bpy3QpaV+yKGqVIl8SgFVqIpVruZYc8tW69gk4TOF2D/
	db954zwbx3NTTH+ZCxE9M7GaTvJHO0AYnBNcCvA+VXIZUnEp+p10dnbp828QjMrQNtE0nv
	/j//Igx+4+WPCdmsruhhQ1Bm4tnnRo4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A71243B3E;
	Fri,  2 Oct 2026 14:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C821F000FF;
	Fri,  2 Oct 2026 14:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790951209;
	bh=v41WPIaDJ3L0NMm68dV3mJzy8zuOhzTrxEWsr1nESBw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D4NVIkYYfKTLHNAaRXc6SujIt9UCWspisz0EDi19o3anfRl2NF2C4Bh/TMg80rHRD
	 mOuouIvnWBbxzYOHc4yrdqMK/LbJiC7SEf6HlhXVL5ftfFsm8KixrlV425ibAPDye+
	 /0H80aSuxIlUC9Go+cy6dB3TPQckDdxTvz2y7M5JjKWXMVVawvaZwQ8NNnN7vcFdbF
	 1qADLgx/87As509MttzR65d94uphJikgDugdPOJnsRuHcV6886KD4wONXuhTJgmjuj
	 Nzf/uEKv5RpGe+86wcuTyn2Cqdahu0D2I8B3uLaX6rRlEjxTd94znGfU4izNM4pMLI
	 JU6/j+Gw9QAAw==
Message-ID: <6659669c-d5a0-42b1-809d-95d18937f662@kernel.org>
Date: Fri, 2 Oct 2026 16:26:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: don't ioremap COWed anon pages in
 generic_access_phys()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
 akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, peterx@redhat.com,
 dave.hansen@linux.intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
References: <699ae98c.050a0220.340abe.0d31.GAE@google.com>
 <20261001152524.171115-1-ngocthang2710.1999@gmail.com>
 <32fe40e2-854a-47ec-9d95-93e23f9a7af4@kernel.org> <ar9omYD3HcTDBpGA@gremlin>
 <c6253814-0cf6-48f3-8f81-3285466dca45@kernel.org>
 <9d43234f-93cb-4c86-a2a6-a3cdebf48f3b@kernel.org> <ar-Cq0YNpQ6_3fDG@gremlin>
 <494d436c-e3b3-4b65-8a6c-1059d9f468d4@kernel.org> <ar-5iLzr-1LH09pa@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ar-5iLzr-1LH09pa@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3g84kmogf9o4rziuakk48jjjn6yhamyb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3CE984000C
X-HE-Tag: 1790951210-194656
X-HE-Meta: U2FsdGVkX18Jw0hlCLiZh5hENsIHRSGWiSqbKkOsX9IAoqUF4JFcpiaQW+ugwFYHV+PvU+HuucuAcMh+xwELPVjU2ShIIs/ThxmUkfizODS8q7YydZ0ex64Jl3KHfujJvFmC/xKljcxOXhqRpbXgy2AjfpuGK2Wiaa7+SABAZqyv0/sh01PpmbdLsbrqWlj9rfUr4VeD5JDqfKO8t6M5IdIBlKHOUCxxxHfXv5TLEm5ufNbOE28SdVYioSg5xaY/hLB9rdpoegqahLvb017Nyh/dtFrWWvPVzgT7EgR5oJt0YV3cCiDhBpW0AkjnFcCasT5p3iHJFBpqbpObO5GJM9ZjP6XV0es26n7gUsLUxGz7tXMe2AYVsTr+NMYeFvHW/3phpq1iGU4/yFokGxG0J37/xWAC2lhnVxf9JqMumr+hsk8gQKx0drzo2Il9mZ5KV8Nc2S7iJ7Nfz/rspKYR5b+7XgxUCit5Qo+4+IbcGYlZNB6343cMzcNZ4BVDAgGBt+D8YmpRjhWryoqZHsPXKVwCmw0osYNXeWQqQuB3P2bj1xu8U60GDLaPP8B1msYvT0V4OebViqorPrmdxTWHnFIjNFYUS5NpCcRedjxeABlqSxzqFFdX42pVu53QNcLa1E7Yh3qD/PeBAi4K+LUMouvX4wXfNj/t1uTTiDbB9scZf0++i80dud62ELgK2JkveXn/04LidQ3UjGQ8r3al8+kMXWc4xGxe3QHctZ2QO5qseNeP0L0+xQ5TmDLVFw5DKN4MOwifsWmQZU8LuyoSI/5K8QJv4/2vnjLSOSRqwwwlkk/VjTtG3DL/llemd7HFNSNgWl3w5g0YY7DvtpOJHRYBnjBZdrIgW9CZICt/bv807RB0Sfq18S9hM3buwu7IiiDOh6mD1/z7WXguVkQhQzFCnUQomO7habrXOxUk/HTn+P5y5YfQhhcDZE9uT6q7LokKOAwFst9CfFCAEJQ
 kygkOuiC
 496P6NarvT6P0Usl+OhvSkwNIAwd5oy/qD/IWSDnCyAMWPwMK0dFdeGUsyr3ky477cKETLplWj3zgbkG9eUC4NITKMbesd7cEzwCnsG+YmfgjZC1WMclTcsHxjk47cNGEySFHWSfJrPdcMGAFlOJkrWmYnQCZmgdCNog4SauSUTLs5R1HL6aTNJp8lil7ScSrZsUdlEZiPb65zGx0Q03CydcVwEY5E54Tktl32204kDOPiVkWXlvVRz1zt61dc/kmQeCKwHjTXxI0qN3Ze8Stz2goOLX0HNxJRaY24Q+v9+e9KON6arSjga9uSG4kQwOgjLoNaf0agGP+uoQ4S3lGUQykALjhATew4w00pUDAefBhaIpMDyi/dCdZ9UalZiycKD84i8XZYapQtlVCn4AKnkaVt/4eUtE0fs8Gj+apOB/EpGeTpy77UyZTzTHJ9Wq4fW7Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 16:03, Lorenzo Stoakes (ARM) wrote:
> On Fri, Oct 02, 2026 at 02:19:00PM +0200, David Hildenbrand (Arm) wrote:
>> On 10/2/26 12:09, Lorenzo Stoakes (ARM) wrote:
>>>
>>> Well, my series at least makes it easier to reason about VMA_IO_BIT!
>>>
>>> Though not sure if it really touches PFN map cases specifically.
>>
>> I'm more concerned about someone using this function on VM_MIXEDMAP | VM_IO with
>> a memory page that has a struct page but is actually not memory. So we could get
>> something that vm_normal_page() would flag but generic_access_phys() could
>> actually read ... I'll have to explore the generic_access_phys() users once more.
> 
> Hmm that could be a problem also for struct page's that are there but you're not
> supposed to access for other reasons to as well?
> 
> Definitely need to be careful about that.
> 
>>
>> All way to complicated (and you series improves things).
> 
> :) well there's still a lot of complexity in there, one battle at a time...

My conclusion so far is: indicating is_normal should work when using it in
generic_access_phys(), as it is never used on non-VM_PFNMAP VMAs.

follow_pfnmap_start(), however, can be called on some non-VM_PFNMAP-but-VM_IO
VMAs from KVM as it seems.

So we cannot easily restrict follow_pfnmap_start() to VM_PFNMAP only (weird,
right?) without risking breaking some weird KVM use case. Gah.

Anyhow, I'll prepare a fix for this one and send it out likely later today.

-- 
Cheers,

David

