Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED31ECAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 11:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C87D8E0007; Tue, 16 Sep 2025 07:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052C48E0001; Tue, 16 Sep 2025 07:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA1C8E0007; Tue, 16 Sep 2025 07:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA2068E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:16:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8EAA4C09C1
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:16:12 +0000 (UTC)
X-FDA: 83894859384.17.94E403A
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf01.hostedemail.com (Postfix) with ESMTP id F34C540012
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:16:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=jjnHESx7;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=WncKLC5s
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758021370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pP90yeaFqjeMBYG9e5yov+4PvbWY+bRrEFrDgqvDYnU=;
	b=D3GR13ZtN3tSG5Xhacw4Vh0KiueV+pxLBU6xLf6rxZfagqFfK4ENZY24ENCyJovXxDTfk7
	CWuuypcinIHJsvAp+sn16HGeGcFtI8U7ZNRv9wIoZ5OR976S7SC1Tj4dxvDu0psBfTKDyk
	2Ke1wNFs8ET8/y4Q1gX4aXBSDEwawWk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758021370; a=rsa-sha256;
	cv=none;
	b=P7XpDnhVyLOKMPfUL0rfw2q9R5b/zDdtyDmDsyfuooIeQOfsPD+yrZvtunY7sF+jCm0w+G
	37W7Fc4NaFTAlJGoN6KarzGt65mc5LwgfGKlDGtbrmH/x0qhZMHDiSd454GnNdARMDpLl5
	dKKzVNEPpE8a1k0JACYlP6n1qQ8lvpw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=jjnHESx7;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=WncKLC5s;
	spf=none (imf01.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1758021367; x=1758626167;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=pP90yeaFqjeMBYG9e5yov+4PvbWY+bRrEFrDgqvDYnU=;
	b=jjnHESx7Xjtip5gTpkigaliDQOOBC0kGJQS07xdIR8XEv8pp5RYgYARz6asFJfCdI2FGtMhMNPG9Y
	 w68YhrJkkNldZQ7FHueWY+TnDkA1WSaUS7aEg9pqDDFpEReEn/NET0e87B0yPFZAlLye2UdISqxQpb
	 4pC+FA0H2FTvU3gHPCw4MF3Ei1zhtpOHORvHyva/+7qLZJ9rkTt1t+Q6zivSB+9kV8TduUmkOQZ3Bp
	 PRxVkf9JhNvouhKn5SPa+CwKnAFt6TmoLbIPsfIXGS1r6vSuO+1L+Xm64yUNldJMYjMqXC5ZiKxB0v
	 CB0hRWwONCp0ohcGGidW1LHU/K7qE+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1758021367; x=1758626167;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=pP90yeaFqjeMBYG9e5yov+4PvbWY+bRrEFrDgqvDYnU=;
	b=WncKLC5sQQIoPcUhDtoVTqr2wAuEUC4ig2CqozfmaMPwCyyXFHcSxy3Hp4qqUAuQGZxDwUzsX4jBN
	 l73vdKIDw==
X-HalOne-ID: 8932b5ba-92ee-11f0-aadb-494313b7f784
Received: from [192.168.10.245] (host-95-203-13-255.mobileonline.telia.com [95.203.13.255])
	by mailrelay6.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 8932b5ba-92ee-11f0-aadb-494313b7f784;
	Tue, 16 Sep 2025 11:16:06 +0000 (UTC)
Message-ID: <be7fbc94-cd3b-41b3-ac20-5c46aad9aa84@konsulko.se>
Date: Tue, 16 Sep 2025 13:16:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: remove zpool
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Vlastimil Babka <vbabka@suse.cz>, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Hellwig <hch@infradead.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
 <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
 <girukcvvzgbtkxt4aftfz3lw3glvf2qsof4mx6wf5perolck5n@vaxlrtaeuzw7>
 <dh74mr7bjtpzk7frviv6iqqno2u2b27p7jiagp2dtnsz2wrfhr@wlb5vqg4majs>
 <tbvushbdn7nzitey3uy6humdndd6247r4544ngqkds3cr447e6@prnla4edwxmk>
 <f3ufcsjvvxhi5gzw2wglkpedgyyi6tiaje7em3tbxkzhklphvh@sv3dbo4yba5p>
 <98B3AFB0-EBD5-4779-A5DB-FFA6717E83C3@konsulko.se>
 <fui4gqm6pealaxooz3xv3dnnqxscefyvhw5bhntedwh4tgjvdq@ootmbuoc3dpa>
Content-Language: en-US
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <fui4gqm6pealaxooz3xv3dnnqxscefyvhw5bhntedwh4tgjvdq@ootmbuoc3dpa>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r7n8ahhts5pa96tgk864wrakinoio58e
X-Rspam-User: 
X-Rspamd-Queue-Id: F34C540012
X-Rspamd-Server: rspam10
X-HE-Tag: 1758021369-38805
X-HE-Meta: U2FsdGVkX1+CIbb0pKqr7g0weXWH8J/n6O1gVJ75MP9n1wLjt0qLSyXuaSzUdk3egj1Cal2HDbjBh9TyZoaTLCgsFV8+vZO0n1xwphvhYa7RiY+LsFYMeAJf3r+ww6NTykZPCHZmA3qvb+LzIiTUsBEy8osWa4PC5986fqsiLUjIDxu41qtSagucK3GUcBgu/tItjmwTWREHJdYj3Bf4GdFgXM58pG/ubkaXlUGio4eSTiUHg006q12jcF9rTevrkcyZAc9TNgZg6dtslKQFkLSTH9D57L42u9enjTKAkj0Wypr/py5fU6CmuMsr4BOTwnNuUIZE615dSkKDOYKxrmzxtmx5BRdSxc7jBZ61BUSvQu8HstHRMg1qF3iSYpydQeWez4IY9LEOM9RhSbiPjswVO0RjBoXJyV5XjnfJt4Su2xkkJHpCyMbUaMv0UW0JVHHqTYV6/MwehoAWhTu38zMRrMFEMQc4yywJPfk8DhwGZjluYYqbiMPt//u8sqyZDlfJtbGFxGJ6GlPzweOT1EWZ4zAftAVMZkdd3nUotEcIlOU3uij0b4e6JnD/6N84PPZ4YHbVyahy+ETwA0mHt0ZMHitEjP1Lfxk9lx9ECAIrJlEJYkolLeRB3oZbVpMoNei1k+6IUAsJXeQLu9x/KvqTYYAYck+Ucbqf6wVhRgR62CJvyzGxGmd3NO4qjok8LcCxgenYL7qDd7JTlOmy8zsrUuo+E4IUdi812BzOH8rlcSmn/tOA2EpFPMZpWw43jM/kQ8lLaj5FIXpMBMZc0ReT/60ltHBg7tCG5xoVdawQpdFrUgO0WzKP05LmoyhJRIsZkHYSOB9BHjQHWXVq1gOAo28KBBLiXiJ2Bml9VDkTtj8V7cpkcy/jtblnLsk9xBvxW6sYHNTyc6D5vE6HPr+XLwS5iUeAi1yCUHa9wtEmkwRbhT/VRdd4zDyuNH8wc9W5ozFZid3S+MstPmu
 bM+qVJOe
 W1CN3ILB8825Af52gZZWlxJmr8efJmqX6Sqq/zACp9S3IOMh/nPjMjidSmJGPkgRzpKTxLrlsLAiMnJUD2wLw5WGv0q6pl2PNLwJFotMFd+zUWbF/kdBKkLQW6l0cA2evdDmcOGm/B2SKjKiZbAhypqT1ubWmZqvOpuURC4enYz1BJmoQaqZOvuVFrJ6Lemv8JWfMwyjK6+lTJ7Awm0N1QhgX8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/15/25 21:37, Yosry Ahmed wrote:
> On Sat, Sep 13, 2025 at 03:55:16PM +0200, Vitaly Wool wrote:
>>
>>
>>> On Sep 9, 2025, at 10:12 PM, Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
>>>
>>> On Mon, Sep 08, 2025 at 09:18:01PM +0900, Sergey Senozhatsky wrote:
>>>> On (25/09/06 14:25), Sergey Senozhatsky wrote:
>>>>> On (25/09/05 19:57), Yosry Ahmed wrote:
>>>>>> I think Android uses zram+zsmalloc with 16K pages. Perhaps Sergey could
>>>>>> confirm.
>>>>>
>>>>> I'm not working on android directly,
>>>>>
>>>>> I can confirm that android uses zram+zsmalloc.  As of 16K pages, there
>>>>> was a way to toggle 16k pages on android (via system settings), I don't
>>>>> know if this is the default now.
>>>>
>>>> While I don't know what zsmalloc struggles Vitaly is referring to in
>>>> particular, off the top of my head, zsmalloc does memcpy()'s for objects
>>>> that span multiple pages, when zsmalloc kmap()'s both physical pages and
>>>> memcpy()'s chunks of the object into a provided buffer. With 16K pages
>>>> we can have rather larger compressed objects, so those memcpy() are likely
>>>> more visible.  Attacking this would be a good idea, I guess.
>>>
>>> Yeah I personally think attacking whatever problems zsmalloc has with
>>> 16K pages is the way to go.
>>
>> Well, there is a way out for 16+K pages, that being:
>> * restricting zsmalloc to not have objects spanning across 2 pages
>> * reworking size_classes based allocation to have uneven steps
>> * as a result of the above, organising binary search for the right size object
>>
>> This will effectively turn zsmalloc into zblock, with some extra cruft that makes it far less comprehensible.
> 
> I think the way to go would be this, identifying problems with 16K on
> zsmalloc, and addressing them one by one in a data-driven way.
> 
> I don't believe there will be opposition to this, or even adding more
> tunables / config options to alter zsmalloc's behavior based on the
> environment. If there's indeed extra cruft, we can either clean it up or
> hide it behind config/tunabels so that it's only enabled when needed.
> 
>>
>> Another option would be to leave zsmalloc do its job on 4K pages and use zblock for bigger pages. But it is not possible at the moment because zpool api has been removed. Thats’s why I NACK’ed the zpool removal, at least until we have a replacement for it ready.
> 
> I think having a separate allocator that's better for each page size is
> not a good option tbh.

I don't think anyone has been talking about a separate allocator for 
each page size. The idea was that zsmalloc (as a well-tested and 
well-performing _on 4K pages_ allocator) stays the default option for 4K 
pages, and zblock becomes the default for other page sizes.

