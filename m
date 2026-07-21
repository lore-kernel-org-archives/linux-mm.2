Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A243C44520
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5B4D6B007B; Mon, 20 Jul 2026 22:00:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C333B6B008A; Mon, 20 Jul 2026 22:00:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49A86B008C; Mon, 20 Jul 2026 22:00:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90D026B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:00:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2166AA0AD9
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:00:54 +0000 (UTC)
X-FDA: 85011130428.10.5FA88B3
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf05.hostedemail.com (Postfix) with ESMTP id 119FD10000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:00:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="XcxrCj/b";
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784599252;
	b=ro5ImiuE72dzynYc6N5P+0Q7hTAyuKE5hMyuYr5QLJYCCsiha5n/H4NeJN4Pz4o8FXaS9r
	9zdqykeSBQ2k78ImYuoEM9qS52g3t12+/UnGuzsllwOvPPTTLunwlxZuGnWNDsGBeLH8Zu
	BmycSKmJ92TVs7hi/Su8nSy5GgG+p+w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="XcxrCj/b";
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784599252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlysOoCIXjYG93rTZNcC0H9AwdEbo6YYMEzcZG/AOR0=;
	b=1l/zv9nioKRsojSKcWHmkkDAdIWamVIJpVllnSNw0qaqb/JOhL5fk4jpz0J0K5RwRs7ggZ
	r2m2eQCZJpSZAJHGoKSiD3oWybjHdvdJrVGQTG/HyNA1LYD6uxnS2hkxkM0wuysujfzJRO
	klYa2baBgPvVqlaRBh3jyAco3wAiyJ8=
Message-ID: <8f3a6021-0ef0-4ecc-bbe0-0be1c3c6834d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784599249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hlysOoCIXjYG93rTZNcC0H9AwdEbo6YYMEzcZG/AOR0=;
	b=XcxrCj/bUTneGioyG2EZFHXlkOr5sWmFJtrpdY5cXlbMtg9+xzmmkP7P/4yQ4DgrZgiwol
	uqJ6unUEaSjvr9KUH3UMdFIFh5CPLJY8mAPPp6a0zklQ6HvZ8QznFjOgIfHJsDF6WcDLcj
	03e/k3nnsStroxzenosktp8ixudVCzY=
Date: Tue, 21 Jul 2026 10:00:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC 05/12] mm/slab: abstract slabobj_ext.objcg access
To: Omar Sandoval <osandov@osandov.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Stephen Brennan <stephen.s.brennan@oracle.com>, SeongJae Park <sj@kernel.org>
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org>
 <976e4d7b-24d6-4047-a405-e86c2feb45d3@kernel.org>
 <1784596208654455.18988.seg@mailgw.kylinos.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <1784596208654455.18988.seg@mailgw.kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 119FD10000A
X-Stat-Signature: pp5kzyjxcynywnuiapsf4qahcnson7ua
X-Rspam-User: 
X-HE-Tag: 1784599251-774473
X-HE-Meta: U2FsdGVkX1/7ePXHeO6grV1LaOQfuIE2c/F4EzvJxsRsKswQdNFgG9CG6ey+ipmFAkN2Nq1yBDge5jDIo+2In71sH9J5j/jlCaSBGrRUBNyLtvsj5lAWTStzlS/W2X1R0mqoKmo9qA51Hrf52XFdPvFzetCIXxXQPALYDTB2GuRARxvO5vDlg+yu0SmWPamvgi1iETcR+0tn5cJru1khwB2CF2cEBi5ep0SEV+2wTz9nO8xzzJnAVldt1eVuUBElLsUvWkLhvp1T4S7oXhf+jwk30Th9vTn7tRUao1/+w6GJi8Ms3YhEluZ34/Q6uuE3xgKV4u2eyxI6pHb3DZXX+U4DOWgio3+BX5dE8T0Mn3/Mzq303uixbIo9uvgVG0r7YnenscyTxeqXs285sTrdvkj/GH6wPpcUDoFkSFEkpMN7wwRK3Ww94nsJVY9PcaPNGm5EJoooqbknv0Ybt5VPp971AHxn85JZUlVwmTByTmg8oxJ8coB48lBanQEivWYmycEnGD5DVFLWKFXwAA6XafyMCZvUVIUFgQA0UJPm1Ft5RxBHiDQ6UsS0iWPjXkMwVKWed4pWBghx1SGCzfrj076LwvgXA/3H67oomu96Do5uIKP0vPOV/5m6VbzxpXx9CspheI90AK0lmyCS/FQVeDiq6SQAm+MUHKp+1qV0VL05S3MQphMQf+Mj1ZG/bmBOLpqXc4o9jYoO2HGKLViMLtXJOrSDs0yDtaHQol5+GSYuUDGFntQeQ49eu6L6gzI3J6ylzlkDkCHs2AC+9uUAG7GR5k3snkWKOmT8Z0JpkojQTyYs+IyOTxm1ZEoxl9wVln60AX2hNR7ErTDDvmmslG5OQufbbmlikYiz3hTQ2oixTdzaUd0YeEGSGXLGQR8iEPjq6cK5ZSwTU7eEcaROsXgRG+IcYIhgAE13yk9Lplvd4tCPDP/6Ds+FkDY9owb0VJ5I//8Gi/hsPKbNXW3
 wq7mzit5
 yRh2dBukWgsl4DY5SipQN7HK99YDNWs4aU1FLqgf4Zi2l0KMkg2D12cNTKqJIfamJWF3EUnmjfCef4WovE1MM3DkDUM+YoK6fYysCJBjQIHVh96nVvgsJY9gzuprZNZLvKbvU6WuWJn1xLxYujWu6fZKFiQSd1l2GNjmWKn4NUPQsCCC03LFhAAbix0N6p/Y1VywRo1ZwfwcCOyRh7grWaTsl5lIpIzkKZRmUAs/tvT+b1uIXgPPqz9ulrlOsTjX61EZZDJYgW7bWxI1FAZK46EN9MwyXkqd63354shSj/QvEWZ/ezIlo1XvtLBfTQgX6yrLBJW28VGRVMnjDI3I1dLdhBpeGZSlmrsT9FfrY4AVQvgI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/7/21 03:58, Omar Sandoval 写道:
> On Fri, Jul 17, 2026 at 12:00:29PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 7/15/26 12:10, Vlastimil Babka (SUSE) wrote:
>>> In preparation for changes to the structure, abstract access to the
>>> objcg field with a slab_obj_ext_objcgp() function.
>>> Rename the field to _objcg to make an unexpected direct access a compile
>>> error.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> Hm sashiko finds [1] that this is breaks tools/mm/show_page_info.py
>>
>> But I think it was already buggy. get_memcg_info() is supposed to return
>> memcg info for a page but in case of MEMCG_DATA_OBJEXTS there's no such info
>> for the whole page, there is only for individual slab objects and it doesn't
>> know which object so it effectively gets the first one. I think it should
>> just stop handling MEMCG_DATA_OBJEXTS, but that's a fix that should be sent
>> unrelated to this series.
>>
>> There's also tools/cgroup/memcg_slabinfo.py and that I think has been
>> already broken with memalloc profiling as it assuems slab.memcg_data is
>> still a raw struct obj_cgroup * and not struct slabobj_ext.
>>
>> I think it will be easier to fix it at once to handle the layout after this
>> series than trying to fix it first to handle the pre-series layout and then
>> update it with every relevant change.
>>
>> [1]
>> https://sashiko.dev/#/patchset/20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org?part=5
> FWIW, if these scripts were in the drgn repo with test cases, these
> breakages would be caught by our CI and someone (usually me) would fix
> them up promptly :)

When I first used the drgn tool, I noticed that some scripts were directly      
merged into the kernel repository, so I merged show_page_info.py into the kernel
repository as well. Later, I found that merging into the drgn repository was    
also a good option, so I merged it into the drgn repository as well,            
and maintain it there. Therefore, I currently use show_page_info.py regularly   
and update it promptly if I find any issues.                                    

-- 
Thanks,
Ye Liu


