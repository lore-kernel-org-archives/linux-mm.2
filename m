Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1934E109C046
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A846B008A; Wed, 25 Mar 2026 12:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C276B008C; Wed, 25 Mar 2026 12:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A816B0092; Wed, 25 Mar 2026 12:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19A686B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:47:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C443C3265
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:47:41 +0000 (UTC)
X-FDA: 84585166722.12.FC98FCA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6D44040006
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:47:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a4Rzizqx;
	spf=pass (imf04.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a4Rzizqx;
	spf=pass (imf04.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774457259; a=rsa-sha256;
	cv=none;
	b=I7uh8jk0pHvP9+tZDO2TeL95sDDZ3QTiD9NtClMhLd6q9erBiBTApkK8GrlsJkoR9Q6EmF
	dzRMaDMj9iAqdMIAwjZB9HdK3U+CN0zWA/gnwuXurKU9xxAPM3nMyCuvg0eWfuIUmV6pZ5
	1dStbWiff7Si3W3gKQu7M9V9IJ/pZ40=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774457259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qr1ol5vgsFYLsTQCwug9Kc0NRV9WjDpLVa+vxqFIkA=;
	b=10fYQMHQ2/9GnQFH/gJCWHihEVNXO507ouEMEod7fUre5lXH/QoSSsML9NkunGjvIseSlP
	1m0OA+KjE77m4zqjLKiYFrCfAGxUGsMs/7P9dBZ3D+9pVDUEmnoKI1ug1qC6vY9EnZyfic
	M+zpPeHzITzH4jzooCXbJpLprukxXFU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774457258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1qr1ol5vgsFYLsTQCwug9Kc0NRV9WjDpLVa+vxqFIkA=;
	b=a4RzizqxMFvslvxVVkyQXz1r6+BX1xIG36d5kuLHu7fIG65wqKdqxFixCHlXZx299fLvu1
	hsm6vhYP2SjxEnx6wCDABX8vcZB8rKaIgMe2Qbn1nsh1KlNnRvztSo0z04/Z2T9DciiUoG
	66F3b4A6mXqL6R1szg3lma0EllvxYiw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-510-LZwgIJoPN5aDYJv_C8P7yg-1; Wed,
 25 Mar 2026 12:47:34 -0400
X-MC-Unique: LZwgIJoPN5aDYJv_C8P7yg-1
X-Mimecast-MFC-AGG-ID: LZwgIJoPN5aDYJv_C8P7yg_1774457252
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73AC2195607A;
	Wed, 25 Mar 2026 16:47:31 +0000 (UTC)
Received: from [10.22.90.27] (unknown [10.22.90.27])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4E61D19560B1;
	Wed, 25 Mar 2026 16:47:27 +0000 (UTC)
Message-ID: <f7159388-c13f-408c-8cb5-02da8b474f57@redhat.com>
Date: Wed, 25 Mar 2026 12:47:26 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] memcg: Scale up vmstats flush threshold with
 int_sqrt(nr_cpus+2)
To: Yosry Ahmed <yosry@kernel.org>, Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 James Houghton <jthoughton@google.com>,
 Sebastian Chlad <sebastianchlad@gmail.com>,
 Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
 <20260320204241.1613861-2-longman@redhat.com> <acE2MoIZ0pl7U7PX@redhat.com>
 <CAO9r8zOTYPgqc_7TVWjQ=adn=pH1TLLX2cBNfa1Y-x=TOFJT1Q@mail.gmail.com>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <CAO9r8zOTYPgqc_7TVWjQ=adn=pH1TLLX2cBNfa1Y-x=TOFJT1Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: exgmwRiGd0MVnorEzQNiG_5VyXAsneBEjNM6EPLm-Ko_1774457252
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6D44040006
X-Stat-Signature: xwwdhafmd6skizuanhw3r157zqappwup
X-Rspam-User: 
X-HE-Tag: 1774457259-712974
X-HE-Meta: U2FsdGVkX19mAe60BFLjfhMQdBsFZU/Ru5wcptdTv1wGOBMmXWXvUeEBtlYYRoXX08awZCgc7sAKNJQO/5XVfwrP91svLkopil0ZDf7Y0pEGHe78I1XhUAIhlms6p0eVVV8Ikwd9ZG0hRBTfhMEwQ1DqdNtzSmZ+2lVof8ghDTtKeUGtMVCb3KLfOkOLFYb6zOyE0/VXjSfga7BEBJ6rN8Ct+6T1APsxIOERbvU+Zpv+J2j4xDd9S//yKA8jzi9S6Z4G8qY7L6zT4qqKFJDEJ5Kc8JFrDTJrDmxybuNK65IWyLQGTvG7uvVjIRKTFuKdRNxYsgNdBsQ5QvyXFsiElh00FV8OIY2S4Oe863Il6Kv0m8SAy29Xyp/bhEHOpsELDLSj6/kOi5LY4yeT9sgTfYD0GintbGObTvzamPqSasI8MT0wa25nA2lEqymEGWk3bamR2RMKojyUu7J4VZjg29zAsLqjyktdLJmTn7YWdIawmMKLA9b/Y9lBaqw0osrDjAAxRfUsnCz1lQ0XTMWL2QyyyUpFmSK1lmwYc53fQrB8HvhvmVJqC5hR7SAWUkxEcwGxisQJU1ucerbBnk4JtTKyAtXSn7337RRHmiFuLkyL3TSuvo80yuoZgALFbTtziMSuNkO9UepJSZuFufEG5pF+qADnjTBPpIfNdSZS5+HEFH3sQkMZMemFIWB2+Yo8qCIE58gYKy3q0dhtg1Vhj45/zqEeuxAbW9B89tB9nPyqfezq3/cNa27nKnDLrWed2P4/DMOwKbK4xvmgB1PCQa8Su/uJZmi5nzFfINz4RhjCCodPh1sSSytLWZnXu+RuGjA+nXewZrYrlp9LxAxrmD5St/NEOkf1jQC25+9HuRWV/y0lJhs7F2pwykzMgmTZ/cuhlPaG0ADySJKy6cNIme2u9wkDDjUZgxJoQHPExfEx6iZcy1j13wPslaUXyrwFdwyZNYn4C6j82eLtSNX
 QI6emkSb
 8D+Uf0qJFIRc2yZa1S2Kp3Nae0AJ2XLfD8lpKuhQoZHPtKc9hd4v2bXRv3/q+wMdJlCgG/IhINy/UVINhFxWOK353pMJgQg+Beib5iz0f2TUjHAaNRXUsPwkD3u/zE87Wzvovt35UdvGskjp2KruF7uVoKVBcffiHor/lH6vN4p0qVUZAoxs1hZcHG87pa61nqKPI/Vdw2VcQuC1LUQlPUv8yYKh+4lpS9PiBRNfD9qI9kwJIYsQvVQF2gZSrISAnIrIjlYk0n+mW1g5GIdEG4h96/A54YCDatsRIAPfnMnJwT2/wMKpI1VTRxbggMoK381nlB53wJmjWoSNzYWaZAFI3e3Gp80XFJUaoHBdYI6YDGidNPy0eM/cINLnbyVUxEf6Ar1XYAz5Exu6Bttbs63DbMdrLrYQ+xsiuaB3ZtNBGt+wt3n5KNDTrZk+XPNSziypd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 8:15 PM, Yosry Ahmed wrote:
> On Mon, Mar 23, 2026 at 5:46 AM Li Wang <liwang@redhat.com> wrote:
>> On Fri, Mar 20, 2026 at 04:42:35PM -0400, Waiman Long wrote:
>>> The vmstats flush threshold currently increases linearly with the
>>> number of online CPUs. As the number of CPUs increases over time, it
>>> will become increasingly difficult to meet the threshold and update the
>>> vmstats data in a timely manner. These days, systems with hundreds of
>>> CPUs or even thousands of them are becoming more common.
>>>
>>> For example, the test_memcg_sock test of test_memcontrol always fails
>>> when running on an arm64 system with 128 CPUs. It is because the
>>> threshold is now 64*128 = 8192. With 4k page size, it needs changes in
>>> 32 MB of memory. It will be even worse with larger page size like 64k.
>>>
>>> To make the output of memory.stat more correct, it is better to scale
>>> up the threshold slower than linearly with the number of CPUs. The
>>> int_sqrt() function is a good compromise as suggested by Li Wang [1].
>>> An extra 2 is added to make sure that we will double the threshold for
>>> a 2-core system. The increase will be slower after that.
>>>
>>> With the int_sqrt() scale, we can use the possibly larger
>>> num_possible_cpus() instead of num_online_cpus() which may change at
>>> run time.
>>>
>>> Although there is supposed to be a periodic and asynchronous flush of
>>> vmstats every 2 seconds, the actual time lag between succesive runs
>>> can actually vary quite a bit. In fact, I have seen time lags of up
>>> to 10s of seconds in some cases. So we couldn't too rely on the hope
>>> that there will be an asynchronous vmstats flush every 2 seconds. This
>>> may be something we need to look into.
>>>
>>> [1] https://lore.kernel.org/lkml/ab0kAE7mJkEL9kWb@redhat.com/
>>>
>>> Suggested-by: Li Wang <liwang@redhat.com>
>>> Signed-off-by: Waiman Long <longman@redhat.com>
> What's the motivation for this fix? Is it purely to make tests more
> reliable on systems with larger page sizes?
>
> We need some performance tests to make sure we're not flushing too
> eagerly with the sqrt scale imo. We need to make sure that when we
> have a lot of cgroups and a lot of flushers we don't end up performing
> worse.

I will include some performance data in the next version. Do you have 
any suggestion of which readily available tests that I can use for this 
performance testing purpose.

Cheers,
Longman


