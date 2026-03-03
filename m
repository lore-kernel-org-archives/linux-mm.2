Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B026EDEBF9
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 21:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C296B0088; Tue,  3 Mar 2026 16:41:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CCAA6B0089; Tue,  3 Mar 2026 16:41:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5014C6B008A; Tue,  3 Mar 2026 16:41:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40A356B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:41:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB73BC17DF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:41:02 +0000 (UTC)
X-FDA: 84506072364.12.D1D3D22
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85D0D14000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:41:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b=o6trfUCS;
	spf=pass (imf23.hostedemail.com: domain of greearb@candelatech.com designates 148.163.129.48 as permitted sender) smtp.mailfrom=greearb@candelatech.com;
	dmarc=pass (policy=none) header.from=candelatech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772574060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6r5U7XP+8nT8ae8pOwAUHdXnxu9zRttJKeiNwVQ+oZg=;
	b=xc4sm9jnHust4ytmQ3bACgGgdlF71e9IT4ae2Fb9z1Iu+WDOoJ2BBpGY19gwoREmWV5RsQ
	FtYx+uIbG19TQkch7wzlbyLwLPRys0l2rBw+AE1cqK4V0ofoR9HHu5k9ktq3t9sFpi8vCu
	SnO4wg/zcYYOOz2VZmlhnd3cZ0KFSBk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772574060; a=rsa-sha256;
	cv=none;
	b=VONhzJKq0uw44DpZKX4BXXcOHR2lX1aZtq2QyZgCLRXzoX9W0qYWr0aZt5ApdqVsOdMnbg
	xCYMRb+ekdvMttv6HYpULKxzOF015RdnJXs73XS+bhmMlvmiti4rcufZd1LUHSJXvN4OJ7
	WUb5k15lNKjZOu+Fthhejaopw+H01hY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b=o6trfUCS;
	spf=pass (imf23.hostedemail.com: domain of greearb@candelatech.com designates 148.163.129.48 as permitted sender) smtp.mailfrom=greearb@candelatech.com;
	dmarc=pass (policy=none) header.from=candelatech.com
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 41CB4340067;
	Tue,  3 Mar 2026 21:40:57 +0000 (UTC)
Received: from [192.168.100.159] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 8F1A313C2B0;
	Tue,  3 Mar 2026 13:40:54 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 8F1A313C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1772574054;
	bh=znA5tqnvgNYmnwGDlFG5uCbSpnh0UQ+1XGZxgDBaB24=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=o6trfUCS9Pnbs4ZJ5ybn4kCHaW9unuQkeruCDzHtDQbLbgJ9u9CLuBto6S4K76I6o
	 F5FLhn5/g3Wjk1YMoMm7SOoF3NvguD4PxqkSkll3tLW9kEA5g4ZkvN2knqlGn2sOey
	 EZHc9WvBaUruCH/8nHnqDxrDZHFMm9jQLsxCLDeY=
Message-ID: <35a7ebcf-862f-0b3a-a245-c32196a58692@candelatech.com>
Date: Tue, 3 Mar 2026 13:40:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
Content-Language: en-US
To: Johannes Berg <johannes@sipsolutions.net>, Tejun Heo <tj@kernel.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
 "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com>
 <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
 <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
 <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net>
 <c616fc41-3bc7-4ddc-b65c-a622111d8548@candelatech.com>
 <35779061f94c2a55bb58dcd619ae91c618509cf4.camel@sipsolutions.net>
 <aadKDCKGHk1Ua-7_@slm.duckdns.org>
 <3303d57a4ea6776dbc66ca72441023f76e6f1234.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <3303d57a4ea6776dbc66ca72441023f76e6f1234.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1772574058-GeJRA8u8Q2pf
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1772574058;GeJRA8u8Q2pf;<greearb@candelatech.com>;e39a4ef213bcaa75c219f509376588df
X-PPE-TRUSTED: V=1;DIR=OUT;
X-Stat-Signature: 8dbbuj373rxcsi9iu7wwx8ry5qfdgaff
X-Rspam-User: 
X-Rspamd-Queue-Id: 85D0D14000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1772574060-283306
X-HE-Meta: U2FsdGVkX1+ZsT3qRpTbxeUtA+bg4OuX6YTC2k2taeSdMqoFHr8GdA8292jJ0cocPdwKkndNHJ6vyimm931dcK12YtKZKrftw7EOPDq1ZzcpL+uadbfOdly0e/IuyOWuAyb9My1d6EyK+QEk6K5YZyvauoevECEYkx/ovMoQz7jRoK8DLXEF3FAP3fIN+HhTg2mp70/lzOJwLWH5SiASqAIw33IXIdxo7CHol5sf/XH2YiSYyUj1k3ioHCrBrnRvRPrAaXQ38iAinVTqJRBnPZ6caAmp9q9c5vsr0f+R1NGZiDbrE075CKXQlliqXg436t3nGsM9/qwWUoOxVhFsK3MPi7s3VHybeKJ/hliJy+TbhWwmDAVJSdIy3G7mq+3QlHHqBHdX/LHcN2dUUmX39JuTB+Qpp2RHU09spgH5NkKovAW92dvITJigJ8cv/wp8n1JVeqRxyW9r3yo0jZ+Hgm3ZddF5XiTS2mQJArxhjxI+bt1RNX3f9tDJ+hLV2Fe7gGdTbenRh8oJnSsbeIw2fa15+IyXJnIwc87YZMvh0mE7QFSCS5LXwY1Vg790YrfYX4G6kzPhAXCNVJVxFdHJg273fqOZIO5Hkh+k/113da9wse5NuMq5qKhNVnbWzOQSIAJDTzNIKJRKBbboM/DMqo05mIcWGNF7d4dt65rT3gImMTGRIl7BsYyP1ofb6DbkIQa4R1zcFW73dJUdOoGkMtkW2y6cEToyNjYmTahQp+hq4VZ+alEaV/7pvRKAQJQLJvA0QVxPB+waliJXyfXmPHU1+yW441x9Y+NHe4RgBXzDzEZ+BfX6erAKDkGRhL6xwNASdH/M579M+tRDu+B0aZ8QQJB9R2LvX3GAGCSgDTQHqfnettySgGLVUV60rfHOumqqx3K4YpgQdfT+Jpdzgx+7Kw4e+5wIh1A+rUIcfVdlbvJsYvXF7frr3IpEwY3nTH0uHaOyOs3/9yYw/qn
 k1Q9a4k/
 Zg3qCvAl5hb0L/jOPWizWUt8jgN1yUJkEuKCNENTVb10UihorTSR/2TuPJNDFzGxGT7Or0sbKXDQqZtKXaWQs5JdgX3mNkY+eeiOY8qpEhKxtsHrQcknzdVL66H9rJXxvMi6IzUAVODuLu2vWzvvtxONbiuAzvy0HnQs72Vywx/lae2QOoS5/Ul+2iXAA/ZdTtg3K7UIePS1JwdeJwUqVPiuh/OhI1yNTZC8puBIV/87PZDgvyZWP6AmWxONJXMkg0VvDCGhK6lu6LN8iJp/KvDXxmihpUaTkKH27pafxl3Nizp+oC4dcHg9+LN/IrJgTzKLBWk4BJLoTFwQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 13:12, Johannes Berg wrote:
> On Tue, 2026-03-03 at 10:52 -1000, Tejun Heo wrote:
>> Hello,
>>
>> On Tue, Mar 03, 2026 at 12:49:24PM +0100, Johannes Berg wrote:
>>> Fair. I don't know, I don't think there's anything that even shows that
>>> there's a dependency between the two workqueues and the
>>> "((wq_completion)events_unbound)" and "((wq_completion)events)", and
>>> there would have to be for it to deadlock this way because of that?
>>>
>>> But one is mm_percpu_wq and the other is system_percpu_wq.
>>>
>>> Tejun, does the workqueue code somehow introduce a dependency between
>>> different per-CPU workqueues that's not modelled in lockdep?
>>
>> Hopefully not. Kinda late to the party. Why isn't mm_percpu_wq making
>> forward progress? That should in all circumstances. What's the work item and
>> kworker doing?
> 
> Oh and in addition: the worker that's kicked off by
> __lru_add_drain_all() doesn't really seem to do anything long-running?
> It's lru_add_drain_per_cpu(), which is lru_add_and_bh_lrus_drain(),
> which would appear to be entirely non-sleepable code (holding either
> local locks or having irqs disabled.) It also doesn't show up in the
> log, apparently, hence my question about strange dependencies.

Hello Tejun,

If I use a kthread to do the blocking reg_todo work, then the problem
goes away, so it somehow does appear that the work flush logic down in swap.c
is somehow being blocked by the reg_todo work item, not just the swap.c
logic somehow blocking against itself.

My kthread hack left the reg_todo work item logic in place, but instead of
the work item doing any blocking work, it instead just wakes the kthread
I added and has that kthread do the work under mutex.

The second regulatory related work item in net/wireless/ causes the same
lockup, though it was harder to reproduce.  Putting that work in the kthread
also seems to have fixed it.

I could only ever reproduce this with KASAN (and lockdep and other debugging options
enabled), my guess is that this is because then the system runs slower and/or there
is more memory pressure.

I should still be able to reproduce this if I switch to upstream kernel, so
if there is any debugging code you'd like me to execute, I will attempt to
do so.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com



