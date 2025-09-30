Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2721CCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37F798E000B; Tue, 30 Sep 2025 06:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330B28E0002; Tue, 30 Sep 2025 06:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246598E000B; Tue, 30 Sep 2025 06:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10D378E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:13:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C214D140635
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:13:41 +0000 (UTC)
X-FDA: 83945505042.23.8BA65AC
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 96381140009
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:13:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iAeOnS8f;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759227220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZmqSQC1HjW/If1x8PYxKuOR/oWq1mejmSvIWyDl9Gk=;
	b=51oyw2dIaKJ60qv3ntxU24x+NRgHaqyIaFnfiHYrXOAiZ6stOpqy0Ojdsj23/uAbSmEyI+
	YPZQomb2dsQyQD8+BZIQE53qtG4qy/LRsb2goXLx/HvIyIWmavTRpsUr6cfFazP6HNeuAI
	pGOllUqBYAGLzHsnrXvUdF2VFGS4MRo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iAeOnS8f;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759227220; a=rsa-sha256;
	cv=none;
	b=pfRxFsA3+9iBANNh9ml9wnkc1BmxH7AQcxsUAZbPpBYs1Tic8AEqSU9jFaJZ5emzBhwzgQ
	qnamrngWCl5ha8C7aUoZWel5VYwvqk6CLtAgybbtJG82u1mv9paP2rCVVqQoiHF5/1gXWy
	HSDlQj7OMUpTjNAkNEo5/4p30kY0C2c=
Message-ID: <f637f793-7979-4817-bfb4-732ddb7d2e32@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759227217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hZmqSQC1HjW/If1x8PYxKuOR/oWq1mejmSvIWyDl9Gk=;
	b=iAeOnS8fKLsSALcaZT1eCR+NEP2Qc+GEKd9yDnqSeZ4USGAs7Z4te+iKr6fGiraaAMLx7h
	kFbfnHSm1htYKvpBBXMnL1fzMM8sD4Tp+n5dXTz48B4vubJgAfbuEqM1XNA6kfCL0sZHtM
	VnYdniHNblgwbzdi/vzQOd6qjS2ct50=
Date: Tue, 30 Sep 2025 18:13:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm: prevent poison consumption when splitting THP
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Jiaqi Yan <jiaqiyan@google.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org"
 <baohua@kernel.org>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "Chen, Farrah" <farrah.chen@intel.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Andrew Zaborowski <andrew.zaborowski@intel.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <CACw3F50ijQ20Vg8ycMROSCccf_XtjB_fFvLGxvQZ7eaNQoLwGQ@mail.gmail.com>
 <SA1PR11MB7130ABC25E060D2CC4749E45891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
 <SJ1PR11MB608350E5169EE77F86A51E2FFC1BA@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <SA1PR11MB713082CA93E9B1C5F22CFBBE891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
 <c1294b63-eeee-4d99-82b6-93eb3a6d0af9@redhat.com>
 <CABzRoya5wuXoMWuGb_+F0oBc0mCDVrjbXTZsoMwcfRT99Y5z7g@mail.gmail.com>
 <c980f6ae-ba44-425b-b7bf-511cb6957c2d@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <c980f6ae-ba44-425b-b7bf-511cb6957c2d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 96381140009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: mcqon7hxfzpg9wwtqk7an41ej8rsq8cs
X-HE-Tag: 1759227219-854784
X-HE-Meta: U2FsdGVkX18+ePNc+s3AMoXmTS+ZVZQFODIkfHNjeuSeJAwmwjLwbl73iwu2lI3+n+RIAxzxuGUnllahKBs1gXdrstMANoWSXItpIkXZlzeLl2gp34hLijNlLMhbZ+FC+TxqLx/+M1gL8Vje6I0rHNgGK+nkXxZp79vpK5SJJNtWniuuEmgIaIMYfsSPhK+pXYJ9SGV31aU+bUioGUAr2YuG/qt3OyrnEOz6zkw/2qDF7voCEP+EMn8k3sC+eKN6mWjeBAQTNZkTC8oBvfm/9HBDPiZHelqLGTqx2jhS5mw3m5NXuzwE1hKekIWi3Ijh4kAf1cnI+k/K4HqCnvQ1mrNqmQfygVyrmmJFahY8+FUBlAPuezW7WdpHtIAjN9ixPcXDyyAaUriIrgomBRlmNuyTsjBawPGzu7bFUDnsb/MFq9Mf0HhRGC1J9soKU+8jNz4up8/BbWKIf/T0zASgJH+XayCimSp2T6KIJt0MRjp34XSqkWmUeWNzbiKH4XhuGho55zIjdCL9t+Hcu0gaX/XzpDLU9RkIedZO82+Zfja4CAhJID6BpsICjsUhYwd3OokAABtQFB5VbYZVvTNeVx3Ogzftx+Ry0EajsQNZVPjF5ygkfr7s2X6cV/RJfQcfBpytFw/1ChCdqEuZN66MHmrtKFzONs2ZuJVSJMVyuDS1rhSFP9sRY61GRhjRGgQUPIMPjZ1rmRTyuPTsHbhOHWPNUsI99kVOW/fh0ThDaUZlhi20YJjuFo5HJ6xDHekL6R1gXsfg4lqYUhEfilXZrIYs7ZB77oxJMYP01DCFV2tcOVlU5HrkJbUFm7mpdFzDCUs8u/qtzuCazT/wsCKYi3xDdkIbLPkbEBhsGEz2ZtJQT7ybyyGR46gVBUZRMlBfowlFrCLs13A3ghqUsTQvywo7s7ZVLHCH7iveroDxNepOcHttY+6SE4bBToPK87MB3l+sp/18gCg2Zj94GQZ
 oC6mJcrq
 Ler9jYDiPM3eXZi3J+b34t7r9KsnQhzefLWUMqAkc4gS9CEEP+GUqqvgy33OGH3C178HwFVTBb4pN4mCFEx0NU/YcBUUwsmmezRgxGjcfazN8GrPFJOSN7DaGzjaxyPUZVLmHY+1QbqkptNOnthc0qYBoE140TaKMsPnPCePAeT/QbbMQLvCFXw3LktbDWGHLjohQ2yvckeb0scn8cEhN5kX+X04LOufvNflGQpYoohRuhUfNwg4AggoHsR6j7x0jnPtLDlX2slH4pd/ULB6I72MQi44a/UCcK/bgfwx7AdZcUjO6mpc6tbXa41sthUjaQXI/WiiuVtaN5CwAmwjhk+ujTr3R5WmxD1PUoDrGqrYHvAg+75J5ALzAflR/fqypv3PLVIRIkX6+vJo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/30 16:53, David Hildenbrand wrote:
> On 30.09.25 03:48, Lance Yang wrote:
>> On Tue, Sep 30, 2025 at 3:07 AM David Hildenbrand <david@redhat.com> 
>> wrote:
>>>
>>> On 29.09.25 18:30, Zhuo, Qiuxu wrote:
>>>> Hi Tony,
>>>>
>>>>> From: Luck, Tony <tony.luck@intel.com>
>>>>> [...]
>>>>> Subject: RE: [PATCH 1/1] mm: prevent poison consumption when 
>>>>> splitting THP
>>>>>
>>>>>> Miaohe mentioned in another e-mail that there was an HWPoisoned flag
>>>>> for the raw error 4K page.
>>>>>> We could use that flag just to skip that raw error page and still use
>>>>>> the zeropage for other healthy sub-pages. I'll try that.
>>>>>
>>>>> That HWPoisoned flag is only set for raw pages where an error has been
>>>>> detected. Maybe Linux could implement an
>>>>> "is_this_page_all_zero_mc_safe()"[1] that would catch undetected 
>>>>> poison
>>>>
>>>> This sounds like a great suggestion to me.
>>>> Let's see what others think about this and the name (though the name 
>>>> already LGTM 😊).
>>>
>>> The function name is just ... special. Not the good type of special 
>>> IMHO. :)
>>>
>>> Note that we'll be moving to pages_identical() in [1]. Maybe we would
>>> want a pages_identical_mc() or sth. like that as a follow up later.
>>>
>>>
>>> So in any case, make that a follow-up work on top of a simple fix.
>>
>> Yeah. IIRC, as David suggested earlier, we can just check if a page is
>> poisoned using PageHWPoison().
>>
>> Perhaps we should move this check into pages_identical()? This would make
>> it a central place to determine if pages are safe to access and merge ;)
> 
> I would have to go into memcmp_pages(). Would be an option, but not sure 
> if we should rather let callers deal with that.
> 
> For example, in some cases it might be sufficient to just check if the 
> large folio has any poisoned page and give up early.

FWIW, one idea I had was to create a unified pre-flight checker, like
folio_pages_identical_prepare(struct folio *folio). A caller could use
it before a loop of pages_identical() calls to pre-check a folio :)


