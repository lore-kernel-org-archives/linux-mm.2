Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BF04CCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E636F8E0027; Tue, 30 Sep 2025 06:20:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14108E0002; Tue, 30 Sep 2025 06:20:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDBE18E0027; Tue, 30 Sep 2025 06:20:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B8DED8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:20:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E25613B7D1
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:20:50 +0000 (UTC)
X-FDA: 83945523060.04.8709B06
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8A51510000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:20:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NNL0hfTJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759227648; a=rsa-sha256;
	cv=none;
	b=8kUOZPYeWt6ObM9/KpZHJ+qkhO+AbmX6ol8WnRq3QVqQhltpv7bm67XH2TVL/mkuftUYyz
	eit1P5YBBWT6isX+pQxbnuCj9JUD055tp+CAsaP+7ZC4uCpdy3F/oZK37YToeGFoLsePIE
	Rq7qo1mnNAjIrfpi2vuKpgXAh1MdiZM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NNL0hfTJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759227648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nwA6u49447YuDOIMZrCrR2s4XPSl6QhTMgSFhdVbXjw=;
	b=qmC0E9FCnP9xAjRDvn6FHh4ePxmWt1NwIUsoRfnPhDdU3hkfRvArc9NQs3070Yx6L3FSP0
	mGTwlP3U7VcDRnca44wrjxumsOJts1/xGlGBtnVfMpSvDuiV6Kgd3YBsdqfjq09PPjl89F
	5KTeldTmhR/sKhzVXdCzroQ+xBva7Js=
Message-ID: <a94541b0-7c3c-4551-a03c-e1f83445baa7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759227646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nwA6u49447YuDOIMZrCrR2s4XPSl6QhTMgSFhdVbXjw=;
	b=NNL0hfTJNEJOyG/WREtxDv3XQZ6Om1fe75rS7Qa6x0eMdunVGfnCCDcto3DunGClZ38eku
	yuqjoKqOudck+m7hSo7Vjjpv9rHLnlqqMBnRoikjunUt3/YetUj0loq/SmaT+lQ+vilygS
	13uhlFCPzGwhKxnTpAxHJOck24Zzh24=
Date: Tue, 30 Sep 2025 18:20:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm: prevent poison consumption when splitting THP
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
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
 <f637f793-7979-4817-bfb4-732ddb7d2e32@linux.dev>
In-Reply-To: <f637f793-7979-4817-bfb4-732ddb7d2e32@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A51510000A
X-Stat-Signature: 6s3wq1nsfny4kbi3nacpcp3b54g5cfn4
X-Rspam-User: 
X-HE-Tag: 1759227648-75656
X-HE-Meta: U2FsdGVkX1+pGdLf6sZZ73jVanPuE+2xGPfwxJNZto0vsvVJ6TzSe8EOnX9dgp1WSfADzyvtP0Dnbo0aoYOfYQi0iekwfFdWRico7ZNRQ1jLU1FPny1RPwnaDd42jwq/6m8Uj4mP+U0c2AhSe3VPlNdTPbkhrmFk1YXiSuGRGAfISfyTCtuQ+iPQOO1Rnv1lqCjsDERxOu8Da2FYD8Jb1Ok7Q3tqWvRYM/Cgwu+jlEEC2iy0Q4wh9GGGzCBBDFQqEhDy6+MH66i8uXA2m9LjelWiHZMRMoG7IallpaDG6v6Bp40WFyEVAQi3e19TJs+Kad7GE8rnfiEIDoHN2PzvctB6ujtyPYud9C2GPS/oGe4DJM1MRmJk08CqyzGhrVyUvVPYdwUgfAJHgeztcKuMXTucCbKxyAMgKaBoOyIJwT5NXamCqQ/lZO0ZWoJA0+vJZ0/BQAYxFbPHk3hH1Gn5bFZo0/i4lkW4ucoxecXOctwozJP1Q/0+7x7X6CsyS/mR8KqNeReM3SnNWzu/ScQGVOML/YpfTac4MkKsdjOCJQmsUQFKVSRlhEGuI+reXMKRiyXlg9px8lM9D3DZZy3XyZMfuxPbn3UgSGsLCSJd5BSxyF+MqIJjSNew159vcLeSgtFMtuAskvs8Qai+/WBN02aCs2qLvdAt0KDA+kBEnjVxjwQVaApqU8V5fUuXPeyFbJzqalwP7UJsdqdrTO3njCPGiAaCewLr+H83Alz9JZs5/MrXmzG3UMWfen6OLPC/WBli7SK1cJqIBCdnbGXOQQpw/trK9pV61Uxs48RsPR00VxBiQvPF80Th+4nhmIV2h6F6Ac6wxa1j30rGBLJPBPf+TpUrzopJsRrjFAY3ThwzvbX16Tu9+KgDEfkfnt84hZhH/39asNB3QTzU8J5DkcTcpFCEJAt44VaY403IVVJTgIIM6J+jyib/ssoTl4VpH9b8ULHgKlQKyE+4DDM
 YvRpLpG8
 NfhVgFLb5ZctlIacnXb+LVkl7kYkiUopClF/KIJcwMytWdItncPMAX+/O4FeCeXUeSBIV7W42eiAQUBZyDrlQjExMyH7uQ/wSEde2vJ4hILhq9c8iW36zPWPHrB1vvu4fCjuMyioPDJQgu5RPMCdm88z87gZwY5bSsDh9tOj5jsWg7xEJl4csTXRElfwjasVhreE6UYvhBgx2KkEKcrmpc5yX0MPClipfmCft38KbBHoM7LXd8m3sjevCfZkiGpu3EN60nCK8siGq0jYnB5qWkWoyi7HWKHQ4qr+yzNOPUaBScmMLR3M/uiTsfp/hc+1x2iYC9rYgegzDdZFABYHvuPHODPGKiGohIFLRpMjb6MxQ7NqchxjC8PpZuC6MYcPyJDM5dpcdyHWa4Bg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/30 18:13, Lance Yang wrote:
> 
> 
> On 2025/9/30 16:53, David Hildenbrand wrote:
>> On 30.09.25 03:48, Lance Yang wrote:
>>> On Tue, Sep 30, 2025 at 3:07 AM David Hildenbrand <david@redhat.com> 
>>> wrote:
>>>>
>>>> On 29.09.25 18:30, Zhuo, Qiuxu wrote:
>>>>> Hi Tony,
>>>>>
>>>>>> From: Luck, Tony <tony.luck@intel.com>
>>>>>> [...]
>>>>>> Subject: RE: [PATCH 1/1] mm: prevent poison consumption when 
>>>>>> splitting THP
>>>>>>
>>>>>>> Miaohe mentioned in another e-mail that there was an HWPoisoned flag
>>>>>> for the raw error 4K page.
>>>>>>> We could use that flag just to skip that raw error page and still 
>>>>>>> use
>>>>>>> the zeropage for other healthy sub-pages. I'll try that.
>>>>>>
>>>>>> That HWPoisoned flag is only set for raw pages where an error has 
>>>>>> been
>>>>>> detected. Maybe Linux could implement an
>>>>>> "is_this_page_all_zero_mc_safe()"[1] that would catch undetected 
>>>>>> poison
>>>>>
>>>>> This sounds like a great suggestion to me.
>>>>> Let's see what others think about this and the name (though the 
>>>>> name already LGTM 😊).
>>>>
>>>> The function name is just ... special. Not the good type of special 
>>>> IMHO. :)
>>>>
>>>> Note that we'll be moving to pages_identical() in [1]. Maybe we would
>>>> want a pages_identical_mc() or sth. like that as a follow up later.
>>>>
>>>>
>>>> So in any case, make that a follow-up work on top of a simple fix.
>>>
>>> Yeah. IIRC, as David suggested earlier, we can just check if a page is
>>> poisoned using PageHWPoison().
>>>
>>> Perhaps we should move this check into pages_identical()? This would 
>>> make
>>> it a central place to determine if pages are safe to access and merge ;)
>>
>> I would have to go into memcmp_pages(). Would be an option, but not 
>> sure if we should rather let callers deal with that.
>>
>> For example, in some cases it might be sufficient to just check if the 
>> large folio has any poisoned page and give up early.
> 
> FWIW, one idea I had was to create a unified pre-flight checker, like
> folio_pages_identical_prepare(struct folio *folio). A caller could use
> it before a loop of pages_identical() calls to pre-check a folio :)

Forgot to add:

It would centralize all folio-level checks.

So if we ever need a new check in the future, we'd only modify the
prepare helper, not all the individual callers.

