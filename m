Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DA06D58E73
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 07:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41DDA6B0005; Mon,  2 Mar 2026 02:43:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A18E6B0089; Mon,  2 Mar 2026 02:43:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 279256B008A; Mon,  2 Mar 2026 02:43:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 14ABA6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 02:43:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AEB351B8761
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:43:09 +0000 (UTC)
X-FDA: 84500332098.14.30F9CF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D3DC5A000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:43:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=udKdOqVG;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772437388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+si8fOzWVCE8p1xtMql+YPyJL/u81q8ze7dTVbEocbs=;
	b=ub2U/lwZ+fc/gqr31GfHrHixvsEmz83WcCkG+dpqiPJogjmHDpWuoSqgj0xu2KRd/qhmPa
	G8PSowoFfrQb2ydQXjUA9VD6gMc7BSV9kBznnPxHBRLHau+RoQH6U2M7IqfmUWlTHKXlWA
	YRTKORgjcm5lDAf/8D4avpETLIoZxGo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772437388; a=rsa-sha256;
	cv=none;
	b=O3J9WBlwtsH8XVO8s/mGe2ag8ZolYVd3bYhlk2Sm36a5OdmT3LvbAA+cbYDSbrAXUTOIDt
	x//hZ2Etefrsf0sJlY+xH4M5LXrJ59iT56UJof7Lutkiq4U0kHkXQDAviVTNdxNsEkDhAj
	1qFIXRAiQAUuhwqx0WjkY+Ov7XdgDi8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=udKdOqVG;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CD11343FF3;
	Mon,  2 Mar 2026 07:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631A3C2BC9E;
	Mon,  2 Mar 2026 07:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772437386;
	bh=h4vd67w0fuuMwxwBTUXPN4v+6iOyEsPXL80rum2E98Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=udKdOqVGE7twa4wsV/WME0ZgmzBxDsuJltPh8za6s3sw3PeFVrz927G6vaA2WVq2W
	 iZctCtcQFJ5OEae7twJ3AQpNQ3OjUEKiN5ZTNaP6JTn2neCDx8OLoFmhjyXXeRBE4c
	 txUnSJ2LsLSsQRD3e/rqS25lU30zGAWPqjaJ9QkLpyJLGwIjtUEKk0eIiyJtNzTeZZ
	 0WbV6hp0l+9NmOWL4s5grW3/whTzbJItTI8N13QihXflt7V5mW16iJfcp5DyJAoyG+
	 6kX1RTZuz/MiC1DtwgNA1s67dRIy4qrgXiyPd52Jkt/5Ji+3PN99LuMi1xRJ5wP5O7
	 AmsGeB1Xgng4Q==
Message-ID: <b1390b24-eaef-40e0-a16b-77c27decb77e@kernel.org>
Date: Mon, 2 Mar 2026 08:42:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/4] page_reporting: change
 PAGE_REPORTING_DEFAULT_ORDER to -1
To: Michael Kelley <mhklinux@outlook.com>,
 Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <SN6PR02MB4157D37B3D254251F0135B04D47EA@SN6PR02MB4157.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: z6ampwa3qe3ugzg37jrwugez3fjxnn19
X-Rspamd-Queue-Id: D3DC5A000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1772437387-988597
X-HE-Meta: U2FsdGVkX19sPbBZBRFxI7smUvifUnXAF4pqzyZmqaOW8nQtoMJkMxZcuws+wIGn/h18d3IxSLVqYY40PYyCd9NPTCUDwzhLz6MJ40jXgs6Ou6PtlnX9koYDxEPvyezmLLx8Rt1RhuS3zjqIA08Kk65UIDePHSQ5/rqVcUfn6yHhNkcwVKnTZ0Pu+fEw7ZFVE9Zns6CHGI/oCCoUVzxxBWc8mCaL1/j+mgaJNeqfDjegkNyoeGX8ZmaFkvtq6WhtfHVhVnH0Kb2lGKycVfg0zZvT8SeSn3l9MxIHCMSS5KRyCWtZkkfkeB+FsuxyaaX6lH+M5Q/4W9Xk5f2pfQd06cjjqLm8yRVUEnnIOHkf9U7yZbiuRHP78per0StwRXVcluBXTUGSJ2A6btibFP72RD9AxkS+DFRnpTCU2vMX9mMhIvnVbFo578zOwo4r0q180JN1gSGVhaK9DKKp/tUC/zWKCsN5Ofk0av5LwCbLzz5Fc25FP0tCz8rv1vP2mlQBQFlvSuagCcVcWPz0CoTWxZvlqhOQA8tCFno2QAe0cXZDYu1chPtsUKf9RGze+7eX132+bkLnl9ClE2FvNN+0Ki9kwGi42uQI3Qx6+qqg6IAUGJh6lnkQMw7qkN9ttSHwEvlsX7eBDmxZNC88+iUdn5ZtkZfJTHFNIjuaPOAgygWxQ+2pCfHTfR2z/dCkegziSBjCk+W1Ap9xW/1RwRoEwg5l+woWapq+zRLOUVVoS9s0bkHP0ZljlI9eC2/YZWeNWdCLkInxOxiZGkE/iqka08fiwU727ruHSnrg0u4rI2ClkoceWiAjesGUc5TKqqdSTXjHgCe0fL/m8cM5ukBwS1KP+0fTc94CEZ7J0Wa24B0xoSUNqogGLGO+dq2sX4hSgNfEx0SxqJsJME9ewx5S6DUQJak0/rKg0EGiVz+shO0/grf+Uu08kFAB8es7QYNg4aUDi2vj1gnUo+OuGHm
 BU4CqIaa
 bWKRYK7/q7T4eezeBXNkmyCsBhwo2PD/h4c4Rc8ZwTn0dojBv5B081dYST929dYYdNf+kVC0q4gmMJrlCCmDho300o2/PMvCVs1ywS/um7dEdxDZ17Z9mzAvKSKlrwflTRpXr21oAgV07lG5Q5LSVIeRpaetHQuKyxq2mY9b1Jz7fnOECteY3v1sYgGGG4fupjCyc9hnZ/qly3XQ7q+LtHWik9zeTGxc4d00LuI7bffBQUyju4SzAQgvPOvhGov9COdlaDluWsFbykEbE6ZyBa4xxjy8SgUAof71yAHy0MQdT2aOEhytQd806AhzSucVP2HEwF8gOovNiDMn4QmeiNStWTFBeEUz9O99ugZ04c5DxybZYuLdJFBcFZcbyipLHGcpWZFGulolMang=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 06:25, Michael Kelley wrote:
> From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com> Sent: Sunday, March 1, 2026 7:33 PM
>>
>> On Fri, Feb 27, 2026 at 09:50:15PM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> No need for the ().
>>>
>>> Wondering whether we now also want to do in this patch:
>>>
>>>
>>> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
>>> index f0042d5743af..d432aadf9d07 100644
>>> --- a/mm/page_reporting.c
>>> +++ b/mm/page_reporting.c
>>> @@ -11,8 +11,7 @@
>>>  #include "page_reporting.h"
>>>  #include "internal.h"
>>>
>>> -/* Initialize to an unsupported value */
>>> -unsigned int page_reporting_order = -1;
>>> +unsigned int page_reporting_order = PAGE_REPORTING_DEFAULT_ORDER;
>>>
>>>  static int page_order_update_notify(const char *val, const struct
>>> kernel_param *kp)
>>>  {
>>> @@ -369,7 +368,7 @@ int page_reporting_register(struct
>>> page_reporting_dev_info *prdev)
>>>          * pageblock_order.
>>>          */
>>>
>>> -       if (page_reporting_order == -1) {
>>> +       if (page_reporting_order == PAGE_REPORTING_DEFAULT_ORDER) {
>>>
>>>
>>
>> Sure. Now that I think of it, don’t you think the first nested if() will
>> always be false? and can be compressed down to just one if()?
> 
> I don't think what you propose is correct. The purpose of testing
> page_reporting_order for -1 is to see if a page reporting order has
> been specified on the kernel boot line. If it has been specified, then
> the page reporting order specified in the call to page_reporting_register()
> [either a specific value or the default] is ignored and the kernel boot
> line value prevails. But if page_reporting_order is -1 here, then
> no kernel boot line value was specified, and the value passed to
> page_reporting_register() should prevail.
> 
> With this in mind, substituting PAGE_REPORTING_DEFAULT_ORDER
> for the -1 in the test doesn’t exactly make sense to me. The -1 in the
> test doesn't have quite the same meaning as the -1 for
> PAGE_REPORTING_DEFAULT_ORDER. You could even use -2 for
> the initial value of page_reporting_order, and here in the test, in
> order to make that distinction obvious. Or use a separate symbolic
> name like PAGE_REPORTING_ORDER_NOT_SET.

I don't really see a difference between "PAGE_REPORTING_DEFAULT_ORDER"
and "PAGE_REPORTING_ORDER_NOT_SET" that would warrant a split and adding
confusion for the page-reporting drivers.

In both cases, we want "no special requirement, just use the default".
Maybe we can use a better name to express that.

-- 
Cheers,

David

