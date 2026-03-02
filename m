Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4445BC624C6
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1676B0005; Mon,  2 Mar 2026 04:18:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76EE36B0089; Mon,  2 Mar 2026 04:18:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 646E86B008A; Mon,  2 Mar 2026 04:18:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 514EF6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:18:34 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0A28140A15
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:18:33 +0000 (UTC)
X-FDA: 84500572506.13.ABC7D80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 409A6A000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:18:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f63X9Zu7;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772443112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AHfv/6iegt4JjX4BgSA0Eo8CEXKOT87RyWuJ7DqJ14=;
	b=cuVecmjxlKYKIVGzMP8CKPOGv460/tPaPb70XyaaNR0DeuEzWqghcyDXBG+06oENR75BRl
	v80xDuqbwQx7Pxi2FXLPyweUgf48APDNpn5Bsu/prx72jtN+FGtI95YkPiX+hoFnLs1kfW
	Rh1KD3+5C4fM7apX8qnmrTzKpKgMBxI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f63X9Zu7;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772443112; a=rsa-sha256;
	cv=none;
	b=SxvM3z5Z8BE/7PXEU9rPdvNpUzMEb/6BGpOC5yHSVmw5PHb5ddC5nhmjZje58uXurcrBHz
	jiOPkZ27n0A9Sr6FrrIJSv2BDaBPVZZzA5hSG3WDboXVEbyZDmb0MBDVLDjpuMu2hepO3b
	R4UtsIkCJ/qewkcmyz6EDYYw8+pGT64=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 84EA760008;
	Mon,  2 Mar 2026 09:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D805C2BC87;
	Mon,  2 Mar 2026 09:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772443111;
	bh=Hx6ptSB6ZFmCX4cO/KP1aDbPdSw6QQy9NbWFTmrXi+c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f63X9Zu7YNmXyMUaTAFvqbxzoJkekuYETpxFg3R8skFFkLnvP8TImGjjrNDIKxr1u
	 kRhEOHtLl62VFYWV+au5yuJFevSsPvOgEHfOxRFzDOpyR5L9pxLiAAQzO5mKK4i9vM
	 28yPxhXdRxpdvk7oBCvxAacSFjaKg0TsBx+xJ9KtR0cANeaHZQhepTgNJ2O97ZF10T
	 LpA5xIevqOgnXSdDw8VwUON3/R2HMj2UewnkoFpWCXKzZJiU7vEoDv7PUWw3znKZR0
	 Q2mSkamufWZlZK2r6UnhfvKh+UvDzYOna3GGaMLY8DEUTqjWOrIehGx3p2HcCeLFZa
	 e9A5Jmr1iF/bQ==
Message-ID: <571547b0-007a-4cf9-be1d-95a0ef871cf8@kernel.org>
Date: Mon, 2 Mar 2026 10:18:23 +0100
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
 <a0133403-8ce3-45a4-987f-96fb7421f920@kernel.org>
 <aaVQXbllLVBLZCwQ@hu-ysakshit-lv.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aaVQXbllLVBLZCwQ@hu-ysakshit-lv.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wcbqjiur5bd1euyqhn6bzw4ahmea9hq6
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 409A6A000E
X-HE-Tag: 1772443112-477371
X-HE-Meta: U2FsdGVkX1/UPLE9MwIfYWZC91givBzI8KKRvfBGCHD5/WLchcMP09ldA+vUVIeYBU/IEiY/h4A/Awt2nEOAu8nLmDuObqbq7qYAjRQXsqHsJpdw2IW41UoY1fibsH24FFtjYJfjsEZpxE9AatziTKg9a4+xUlLd7OJfLAJGDpJ13AyBu6WOp/ooWB9rucI7idmvnn9CRrZe8CKwH0pMqNQQfg/80uWuFsMKz3IDwD0l1DBDvOXJ2hE3aGsVGZMXviDKs3B0oUCdMM63GMUOlT/joASZJ/nb8H8c/yWuh9iuU10NGG0aCZ2ceKLIjNMGwlkfdmyKe75a1Gf2xFGrJe5Zp0NnU/vgrYIutAp8u2kHt57FUPxL4ROfhIhq0AkyLmMHPYMEMTr5xMxc6dvF/zJHr7OJD0YsQEJ4lNRuUlo73fjGPlpTmO/WFAawhxrODtV9cAIHmEIEXcr+9U11Dxg4QQYgkY1B+CkRSVCZFRFFWmW2SRqEmQueODimPT6TCcppE03d39AVMagZIgFVu3sKTBu6J5BAHkWtE/6WP61yfDQroWHkc+PnHvUQdOpqb13O1x+Q2lkqFjfwL7Hj9kEF2/3Pu7UlSyrYBX86RiprpvHz/ORz8EHN63hUtldI4y3uD5jT/aqrRK8r3mXeUZhTxUB06tV3kW2pujKLhKwAE2bWRmBgmSeJN27jIi79hHnrZT2bbK48AKvAcU5bCy7fc4T/2I57ojc2h+wVfy9EUB+RoipQOlG4KqN6Fnq3daog+LNTNL2O7ooMB7P8bfVFEiXPoROSe6CS2XD+MoO0bD1dNGWlzKkzbhrMn0qqI5q9zdnqAXoMVYJtsBocCkpd3RhIdjpMctLAD3AG9gwFG3LFWhJVdWvI7agwtVE5PbuZHgVH1gMEV6d+tPlEWTZWZc4XxNhWUov1BYgZvWDnmLfzGFXEVCuVYv6zI30amFU5GT0a/4UjgbXJy5d
 GpePEMuV
 JOtETCVfLELli2ocNxpqOnaDlWZDEDbxuDymsWjpVfK9VCSQtaPvA1YwnpIZ250EaXSy52NHq+vqLGTZ0XSbjUrg7USzb0BeoWXPgRFUmqx2QCJq/KReAnuK9q5zXp+yDTHPErAlOMfn4g/fCN4kw0uEECUYieK6HoZVrypRs9Pfb5Fjp2TKemyrihMI8ZktmB8PdY7ScYouVVH/bIHH32DnnClgqlAxwyPfIK5GZcUOmF2oNHXVgYu/zxyEDO+F3HL2TMs0DCBwB5rKdewWQ80xvu+YOpUh8Da3Uz3HS1EtJDH1RxkUous6j/w6lq+ytU5I45q/nVBj6SiaqZuQQ7RoQ0oZFa63aQMcd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 09:54, Yuvraj Sakshith wrote:
> On Mon, Mar 02, 2026 at 09:09:13AM +0100, David Hildenbrand (Arm) wrote:
>> On 3/2/26 09:00, Yuvraj Sakshith wrote:
>>> Option 1:
>>>
>>> if (page_reporting_order == PAGE_REPORTING_DEFAULT_ORDER) {
>>>         if (page_reporting_order != PAGE_REPORTING_DEFAULT_ORDER
>>>                 && prdev->order <= MAX_PAGE_ORDER) {
>>>                 page_reporting_order = prdev->order;
>>>         } else {
>>>                 page_reporting_order = pageblock_order;
>>>         }
>>> }
>>>
>>> Option 2:
>>>
>>> if (page_reporting_order == PAGE_REPORTING_ORDER_NOT_SET) {
>>>         if (page_reporting_order != PAGE_REPORTING_DEFAULT_ORDER
>>>                 && prdev->order <= MAX_PAGE_ORDER) {
>>>                 page_reporting_order = prdev->order;
>>>         } else {
>>>                 page_reporting_order = pageblock_order;
>>>         }
>>> }
>>>
>>>
>>>
>>> Agreed.
>>>
>>> If we were to read this code without context, wouldn't it be confusing as to
>>> why PAGE_REPORTING_DEFAULT_ORDER is being checked in the first place?
>>
>> I proposed in one of the last mail that
>> "PAGE_REPORTING_USE_DEFAULT_ORDER" could be clearer, stating that it's
>> not really an order just yet. Maybe just using
>> PAGE_REPORTING_ORDER_UNSET might be clearer.
>>
> Ok
>>>
>>> Option 1 checks if page_reporting_order is equal to PAGE_REPORTING_DEFAULT_ORDER
>>> and then immediately checks if its not equal to it. Which is a bit confusing..
>>
>>
>> Because it's wrong? :) We're not supposed to check page_reporting_order
>> a second time. Assume we
>> s/PAGE_REPORTING_ORDER/PAGE_REPORTING_ORDER_UNSET/ and actually check
>> prdev->order:
> Oops, typo :) I meant prdev->order.
>>
>> if (page_reporting_order == PAGE_REPORTING_ORDER_UNSET) {
>> 	if (prdev->order != PAGE_REPORTING_ORDER_UNSET &&
>> 	    prdev->order <= MAX_PAGE_ORDER) {
>> 		page_reporting_order = prdev->order;
>> 	} else {
>> 		page_reporting_order = pageblock_order;
>> 	}
>> }
>>
> Great. Much more clearer on page_reporting.c 's end. 
> 
> Don't you think on the driver's end:
> 
> prdev->order = PAGE_REPORTING_USE_DEFAULT; looks clearer? As compared to:
> prdev->order = PAGE_REPORTING_ORDER_UNSET; ?
> 
> I'm thinking, why would a driver worry about page_reporting_order being set/unset?

Maybe PAGE_REPORTING_ORDER_UNSPECIFIED ?

In any case, we should use a single flag for this. Everything else will
be confusing once drivers could use only one of them.

-- 
Cheers,

David

