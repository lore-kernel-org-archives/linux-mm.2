Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0895D58E78
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 530AF6B0005; Mon,  2 Mar 2026 03:09:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DEA06B008A; Mon,  2 Mar 2026 03:09:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C3A6B008C; Mon,  2 Mar 2026 03:09:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26A866B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:09:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45089C2FEE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:09:25 +0000 (UTC)
X-FDA: 84500398290.27.25533B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 68448120004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:09:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TF6xmoM1;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772438963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3EW502Ai4m9SnR7c/+uLrup92MDLZfgqK2HsNoUQ7Ko=;
	b=faORCpUcVtv/HgRvO8qiiNFCkvQXG0uKUXJVEBLugz/PrP8ZbuuhFT8cdj4p8NMtACnz8w
	eVz9qDjID8eWfx26EMBGXj6akTHy0zOyxpee27mvlH7rlMxLAai4e236L4eGulCE/Og/u3
	Rg/QITQJ+WPVyoVKtlgpODX/XhokAI4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TF6xmoM1;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772438963; a=rsa-sha256;
	cv=none;
	b=Gj2AMN+epem0LcJYv++EjQjA6uiAiaGh/YfrtWb2kD7OH7EL49LenZu57eSIAG+evBeaPO
	8M3DW2rvm4FsWhXu/PxeDTw7UQAtP16aXEw9v1KpugkiUxWdMPSHqMx67v3j7VpDolNtLx
	NWEWYAs85Y68slv4xwA8SdlOzcti+Ag=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 60526440C1;
	Mon,  2 Mar 2026 08:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35630C19423;
	Mon,  2 Mar 2026 08:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438962;
	bh=FqBCPiof80sYQVn6PUFltJWkTioFCV7WXdE9UKQ7PRc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TF6xmoM1xb1BmDnHJGEYYK4djC4sZPGpc5YK/nAz7HzJ1voYUouiCetVuo4MDwIpB
	 6zABBzdYxHDeL41uNqVAX1tuBhYFK91ibtgQRO3fwM1RvwD5iMZYlIFEuIDv2pkz/u
	 UfmnJhWi16+xkmfzi4Mr6GzFG0kCrcEryF3fjlWJ94GUjDYfn+xqfI4lLa6y9wv3l2
	 CDygaFMQ4D+7OXNntYjczvYmpenkTHXU7sBr1ZEaL3BTj5QsLgUPSPuPc0ohEzyIF8
	 Y6Fv8UYd+pvl01YZ4KQwdKLNNBRMW0+MN0Wc1pYz4LP9dyabdnwudPjvSu3mkYbDAu
	 mI4cxujLVJIAA==
Message-ID: <a0133403-8ce3-45a4-987f-96fb7421f920@kernel.org>
Date: Mon, 2 Mar 2026 09:09:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/4] page_reporting: change
 PAGE_REPORTING_DEFAULT_ORDER to -1
To: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>,
 Michael Kelley <mhklinux@outlook.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "mst@redhat.com" <mst@redhat.com>, "kys@microsoft.com" <kys@microsoft.com>,
 "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
 "wei.liu@kernel.org" <wei.liu@kernel.org>,
 "decui@microsoft.com" <decui@microsoft.com>,
 "longli@microsoft.com" <longli@microsoft.com>,
 "jasowang@redhat.com" <jasowang@redhat.com>,
 "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
 "eperezma@redhat.com" <eperezma@redhat.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "jackmanb@google.com" <jackmanb@google.com>,
 "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "ziy@nvidia.com"
 <ziy@nvidia.com>, "linux-hyperv@vger.kernel.org"
 <linux-hyperv@vger.kernel.org>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260227140655.360696-5-yuvraj.sakshith@oss.qualcomm.com>
 <c618e7a4-42c1-4438-9bc2-9c41450a81a2@kernel.org>
 <aaUE7M9QkfnYh12e@hu-ysakshit-lv.qualcomm.com>
 <SN6PR02MB4157D37B3D254251F0135B04D47EA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <b1390b24-eaef-40e0-a16b-77c27decb77e@kernel.org>
 <aaVDiwEPl5t2UPX4@hu-ysakshit-lv.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aaVDiwEPl5t2UPX4@hu-ysakshit-lv.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 68448120004
X-Stat-Signature: t6116qi6u53mbk1kh5481p3y4889m1rd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772438963-430653
X-HE-Meta: U2FsdGVkX18VjOsoymgVoLUCoYeYoXh5zpM7NRzIXYK8tNLSpbNm27/YHmYsezQ1TVo9/8WNNoPj0LlaXGdnEii1ni+QbPcFJEWrgTKcPRY7GekO0hGJ6Gmwz4hFuP1BAAjGDE3jFaMUiQIVB0QuNwj/yS7igbQIl5OugbnMVdiil5wBHTSh0zix2bkHp2jOA+HsPgoTjv/gsQRNY84YgD2H/g9F9hoPJiTPyGnzcM5llNNn0xb+RMVtR6kNnoZsiwmEeEnJnk7kfUYAB4PsrUBz0oaZifKvTtRLkP7xvSHB0RRfkg0p4RCS7eKQMyv5brDDtw/SZlOPHztihz3xJBAXE0HA7PN26hDWmqnNV1VNo3eSX/QhffVBd6yVVgz2kA/DwdeP6vVihAfCAa1w1l0yHQu56uuVFcVyBwuWJDuQqzegF0LWsFNEFDHr/dO9mtuyUVT4C65zgDoQttlughChjCAjLUMUCAD0Tu+ub/v0zftBiReOK5F0NG8Sw7vlNbRtKoRaKfBYcaBt1UEmSfWlNKoDj85nm+W4bnRoIGLW3mNaCkavqEa+0odKUHpLxldRpbacq48A82Kdnv+u3kX9pTW7hYw8Bs49RLA6/JRyAcNeKyNMkER8ClePhBgrpgN0LyWFIqvGctR78iqpEDEBX8TvRVNAmFfUrAn8rwl8cdjbQAYBIDWdxbOOQ/vK99Q8gX156+3mxNcEop4wKxq2q4oDJTTU0Bp+Ly/6JuNAsczHyoWoI83nc/YojfhwjaVRQ4ifVE3X3NLq4zT2rOCqjSdfJuCP7D7mUZMW6XJQjd9ycIsn4HoKWJ9kU/GE3uZhC75LvRP9VpUKGJ3psj8OIvopXFLTn8CeCskugxZX0jJVofjrfSbiiK33AfP/q/nUZV1DUGh9o/gzd//mELnBwhY/BD3fOGOoh/HHMrTcs/W13MTTfHwFSRBP1L5vmhsnTY6DI7HKVM2kfK1
 rzHkbrks
 KhJUZwUgiwHEirnZFnF1cPlqq1qNJUkdigh+Mw1VurzIPcZKOcShNrp8aiNCoSOmNQJAmtDI2N4Y5lelS9rItmsAMY/+D5Vx4qQnbZ0ZEOT3KrhaEu8nVV5qxroudkqCnTeWiZ/cgIGolTlUr602Kp2sNG8e/igYm5ja0ksLJCN0t+Whb44zDvVOWkkpsbkmRXL3H4Ggv6uGY/1qbXZ/IzNoa5JWMH2ehJm6pU8tTxXRKRzXDHMpFlIOUfmRFqIHwFFhoshiEkRSvWmvUNYK3848zCUva6KblYdt+MjTvnuyJFB9lqXWcjZcrh9JNesQFxYQhJU6Hv3Ywo72yAcDIjL1NAXdDS1r7mDiHp+HMXLhOmAcZFyAgzn0VKHpOBipfGv5PjotUNRDsFyGYGiDR6I8FQQ42DBdvpHkO7klzdf+P6JzODaL9+l2Hqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 09:00, Yuvraj Sakshith wrote:
> On Mon, Mar 02, 2026 at 08:42:57AM +0100, David Hildenbrand (Arm) wrote:
>> On 3/2/26 06:25, Michael Kelley wrote:
>>> From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com> Sent: Sunday, March 1, 2026 7:33 PM
>>>
>>> I don't think what you propose is correct. The purpose of testing
>>> page_reporting_order for -1 is to see if a page reporting order has
>>> been specified on the kernel boot line. If it has been specified, then
>>> the page reporting order specified in the call to page_reporting_register()
>>> [either a specific value or the default] is ignored and the kernel boot
>>> line value prevails. But if page_reporting_order is -1 here, then
>>> no kernel boot line value was specified, and the value passed to
>>> page_reporting_register() should prevail.
>>>
>>> With this in mind, substituting PAGE_REPORTING_DEFAULT_ORDER
>>> for the -1 in the test doesn’t exactly make sense to me. The -1 in the
>>> test doesn't have quite the same meaning as the -1 for
>>> PAGE_REPORTING_DEFAULT_ORDER. You could even use -2 for
>>> the initial value of page_reporting_order, and here in the test, in
>>> order to make that distinction obvious. Or use a separate symbolic
>>> name like PAGE_REPORTING_ORDER_NOT_SET.
>>
> Option 1:
> 
> if (page_reporting_order == PAGE_REPORTING_DEFAULT_ORDER) {
>         if (page_reporting_order != PAGE_REPORTING_DEFAULT_ORDER
>                 && prdev->order <= MAX_PAGE_ORDER) {
>                 page_reporting_order = prdev->order;
>         } else {
>                 page_reporting_order = pageblock_order;
>         }
> }
> 
> Option 2:
> 
> if (page_reporting_order == PAGE_REPORTING_ORDER_NOT_SET) {
>         if (page_reporting_order != PAGE_REPORTING_DEFAULT_ORDER
>                 && prdev->order <= MAX_PAGE_ORDER) {
>                 page_reporting_order = prdev->order;
>         } else {
>                 page_reporting_order = pageblock_order;
>         }
> }
> 
> 
>> I don't really see a difference between "PAGE_REPORTING_DEFAULT_ORDER"
>> and "PAGE_REPORTING_ORDER_NOT_SET" that would warrant a split and adding
>> confusion for the page-reporting drivers.
>>
>> In both cases, we want "no special requirement, just use the default".
>> Maybe we can use a better name to express that.
> 
> Agreed.
> 
> If we were to read this code without context, wouldn't it be confusing as to
> why PAGE_REPORTING_DEFAULT_ORDER is being checked in the first place?

I proposed in one of the last mail that
"PAGE_REPORTING_USE_DEFAULT_ORDER" could be clearer, stating that it's
not really an order just yet. Maybe just using
PAGE_REPORTING_ORDER_UNSET might be clearer.

> 
> Option 1 checks if page_reporting_order is equal to PAGE_REPORTING_DEFAULT_ORDER
> and then immediately checks if its not equal to it. Which is a bit confusing..


Because it's wrong? :) We're not supposed to check page_reporting_order
a second time. Assume we
s/PAGE_REPORTING_ORDER/PAGE_REPORTING_ORDER_UNSET/ and actually check
prdev->order:

if (page_reporting_order == PAGE_REPORTING_ORDER_UNSET) {
	if (prdev->order != PAGE_REPORTING_ORDER_UNSET &&
	    prdev->order <= MAX_PAGE_ORDER) {
		page_reporting_order = prdev->order;
	} else {
		page_reporting_order = pageblock_order;
	}
}




-- 
Cheers,

David

