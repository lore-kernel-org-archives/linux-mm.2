Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DE92C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55FE6B008C; Mon, 14 Sep 2026 23:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07606B0093; Mon, 14 Sep 2026 23:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91CB36B0095; Mon, 14 Sep 2026 23:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 718496B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:48:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4A6EA02B3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:48:17 +0000 (UTC)
X-FDA: 85214613834.23.BE6E4B4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id B56F640005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:48:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gtMBSMt7;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789444096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnSzcMrJLzIwbBgSc4r1h5wi1qOW8IjhyVNA1VSwOYk=;
	b=PuL1vLmjc79X/2e+e4TZHgJbQCCWKq1J9XhxvnnLXVgf/9mSmMqfZBCbnRhjJD6iqAPfqq
	n4EqIA7+LOlvDekYHBgtrr6wFASR/sCZ56797Hv1uKgiknlVN7Fvfdf9tl0/jcK04Bk3xS
	vuP+Sd313qr+L3S2+DwN8bQvS2w793A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789444096;
	b=LKFbNGgvHbUySU9HqXPIAncJTTj7lO5LA+TiP+jgSOqUUZZHxxIGv/ZJGIOSxA6BIi0kQz
	xizs3NfZOcM0tuilDtYS8WH8dHwQVMSmQ926r5mvo4fcV9vEq3OMCjq+jgqB/R5+j5zcI2
	dPKmckD/L5gID2UoNiXC1XCXtd5YDYI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gtMBSMt7;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F11791570;
	Mon, 14 Sep 2026 20:48:10 -0700 (PDT)
Received: from [10.164.19.33] (unknown [10.164.19.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E17253F7B4;
	Mon, 14 Sep 2026 20:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789444094; bh=KgjqZoWoWF2qzt6t1QQEyEyqBSmp/mCKv/Xm4NSLhic=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gtMBSMt7KQpkpEw4uf2tV+eK0xJnhIK+UUdPXXSlgHaKB+doyn1hf0yIbcbxVkeB7
	 gZ1GkGl+e4POIgoV86zRSfkJa/jcGhzGkpiswTbEjIPWcJXI5jFPP01aZfXhFDylb9
	 dCn3om+7wQ5Fg4wBewetvePHdKhyIny513KDRR2Q=
Message-ID: <5bafc4c7-6902-4015-8f74-e2f5773086de@arm.com>
Date: Tue, 15 Sep 2026 09:18:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/vmalloc: extract vmap_insert_free_area helper
To: Ye Liu <ye.liu@linux.dev>, Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ye Liu <liuye@kylinos.cn>
References: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
 <20260914-vmalloc_study-v1-2-526f68559706@linux.dev> <aqgow3u0GSlj0P1Y@milan>
 <fc999f45-fcbc-4d6c-a0b6-2bea4da98013@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <fc999f45-fcbc-4d6c-a0b6-2bea4da98013@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zfymizobc5aj8fr8eh4yaskdrycwehwn
X-Rspam-User: 
X-Rspamd-Queue-Id: B56F640005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789444095-77915
X-HE-Meta: U2FsdGVkX1+1BMjFzYeuZnxLg6dnZLFfHivHv+GCgLqU9HAGAf/UwQF7aa1/aG1akXTTDow7YL1BohycuVi7Ru9bMOthnf5r48r21ZaUkRrNEYv3Mh8PAbYUBqMrt0JmtcaUsblbo65rVWzYluBKwEK4L5WoqJoUme/RnHdFj6pSSPHay5Pj04pGOfnphxAeh8XBQojz7OMCqpJLN5zNWKNDPaBtURbVgIuCXIwxKDE1XE5e/4wm05Lymvqq+RfcPWx3Lh8h36tchbkwx3r2VXJg4R3y4TPd7qqBQsNHQddcOAGL4x6EG+eXM92kmPjErt7PKMnf8ri74dQGOuvffwXdIiaeO009K2zneN5tUJmbDIcPBVGKi82cjn2Rgc0zPtpUC7CLUqc9gdrxKqMzuHThQf6hINIKdDsV0jBkawmDkEyRE5TOqkdXYE3zAI8g+O72VzbT7v4g0N/PnZqETSGXpsT9BcTquaaY1iCBjwwuBycNx27Tl3lxLKM0G/SnZUthICTd0KwrvoTne7IH29j9De+ng4nni6eKet5UuPpvFqvYmIgQmvpBkKkV+2u3FPAlNWPVtMvPVgYdH7vOiRiH9YE7Hraq6BcMpfIe5B//LI9AhDNgerqt9UPgg5r6+SF5WKXbfvGwubTUTlDxIB4gtSHaZB9UrMNCjZq3um70JP4caxhY5QCA2oRN/Xpob1BBTp//sI5fwgMXh9MoWT81MQscaLZ5KXxYZ1BpHaQdEM3vmmw0uM+nQsAVZEVKT0eoqVrYPYvF4EWe5XoIy3DQX5Eig4csUML9lOp/1JOzSJJv+54i9mlIFLwxVBbQYT5vDloHr/WmiHgDiausiOEGkBxykKyJWA8HJ849w0vcwJhD4aQnh+dg1HNNP1UiY9assTlvgQVek9olTdZjUBJGrGVdHAof5La6g3CM8S0r1+IerZi5E5pEzI+SfxcJTIa9r/VwkDlcDBSHsmT
 8vcfkWVX
 yLjt3WKxZv8oIXDXpOjG83R0cfJJQ2jI4do/oncysp8KYXngL59S6qkFnJlK59gHfxmo21DbbHyZscKKwpIulHQLQKlG9aSf+q4E5W7pGrGiudTy8tUhzOAUxQj6YDnqK0Xtt/9L90xdLjlOHeM83IilCv2UPM7QSShmEa7Y5hbz6YJ6EBVNKMZ6ju6YpaDGXp30PfwJOH5+zuP/dlibyLrtOUWm9EKFQN6fjAzuyaHwenm1MRgZnGGdI7LUD3/WKPz6VkquuTog3/OPap2YGifZDeChCTqoDHIsY2aw59vbcxcH9duJaxEq8xRMIQHYRzuUrVO/tsYsOPRQNTWQMGoVN5Kt9zIzL7SrquOWzQ035n5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/09/26 7:55 am, Ye Liu wrote:
> 
> 
> 在 2026/9/15 01:02, Uladzislau Rezki 写道:
>> On Mon, Sep 14, 2026 at 11:34:01AM +0800, Ye Liu wrote:
>>> From: Ye Liu <liuye@kylinos.cn>
>>>
>>> The allocation and insertion of a free vmap_area is duplicated
>>> between the loop body and the tail of vmap_init_free_space.  Factor
>>> it into a small helper so the main function only deals with computing
>>> the free gaps between busy regions.
>>>
>>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>>> ---
>>>  mm/vmalloc.c | 41 ++++++++++++++++++-----------------------
>>>  1 file changed, 18 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index 117483dd048c..797933ba9451 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -5433,11 +5433,23 @@ module_init(proc_vmalloc_init);
>>>  
>>>  #endif
>>>  
>>> +static void __init vmap_insert_free_area(unsigned long start, unsigned long end)
>>> +{
>>> +	struct vmap_area *free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
>>> +
>>> +	if (!WARN_ON_ONCE(!free)) {
>>> +		free->va_start = start;
>>> +		free->va_end = end;
>>> +		insert_vmap_area_augment(free, NULL,
>>> +					 &free_vmap_area_root,
>>> +					 &free_vmap_area_list);
>>> +	}
>>> +}
>>> +
>>>  static void __init vmap_init_free_space(void)
>>>  {
>>>  	unsigned long vmap_start = 1;
>>>  	const unsigned long vmap_end = ULONG_MAX;
>>> -	struct vmap_area *free;
>>>  	struct vm_struct *busy;
>>>  
>>>  	/*
>>> @@ -5447,32 +5459,15 @@ static void __init vmap_init_free_space(void)
>>>  	 *  |<--------------------------------->|
>>>  	 */
>>>  	for (busy = vmlist; busy; busy = busy->next) {
>>> -		if ((unsigned long) busy->addr - vmap_start > 0) {
>>>
>> This line gets removed and then re-added below because of removing space
>> after (unsigned long). Maybe it is better to keep that space.
> However, the '{' is still there, but I'll add a space anyway.


Just mentioning in the commit message "while at it, drop redundant whitespace
in "(unsigned long) busy->addr" should suffice.

Reviewed-by: Dev Jain <dev.jain@arm.com>


