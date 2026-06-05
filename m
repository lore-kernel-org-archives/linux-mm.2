Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91024CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 11:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689BA6B0005; Fri,  5 Jun 2026 07:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661406B0088; Fri,  5 Jun 2026 07:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59FC46B008A; Fri,  5 Jun 2026 07:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC926B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:27:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 006D81C230A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:27:11 +0000 (UTC)
X-FDA: 84845632662.22.A7D5F51
Received: from lankhorst.se (unknown [141.105.120.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id E3256140012
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:27:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=lankhorst.se header.s=default header.b=N74i+GGN;
	dmarc=pass (policy=none) header.from=lankhorst.se;
	spf=pass (imf09.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780658830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0Da9jRwUx4KjcOW+JjC/ZydKxjKsmzaFHb8paJRVqA=;
	b=avExLVWnVlOSiNBQolBDqPQjRfvv54VntES1D5VQZc1lsuU874rlm3Eu68TWKAqwgUzlcg
	m+it+p73gXwxmfUSuuCDiH0EOe7O2OLQg42ehEDrSnw2yJyrSEdrpzPRcSfQYVx6z4Kee4
	DHGPTztxCj/afs4DPz3oeIbyPtHQ/DA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=lankhorst.se header.s=default header.b=N74i+GGN;
	dmarc=pass (policy=none) header.from=lankhorst.se;
	spf=pass (imf09.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780658830;
	b=aLySIkVkbhy0QhhpGqpI/AbCTRcWHqlukfkJ+mNfKSXw16LdRhKX3V9/GkBjsJwNokG0RB
	19v1VxqmBfB6aJ9CKpwQOf4I3/0YqdFAtZKKjRxvuDeRugYyFXZT5ptDh0Z1rXJ8g7s5uN
	iEQ8RMSg8kOz5wgRDQLHHqGB+wfzId0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lankhorst.se;
	s=default; t=1780658828;
	bh=grJWHPyWHk8AoQrPfPCjbyowZDDAMw3aAx81Y2+OkBE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=N74i+GGNoRR0g17Ffnu3NiFljaOwuwpxqDTJa+TTkHeJKzoXGffMgGBLgkNZy6V9P
	 FW0Imepg0M0DhWM8mTNCenAbBV4/lME5xB9WI8+e/iouz18LG0s9xNjLqerAsABoEW
	 LlEeOcceVMFODm5FuCtxrHcqbrh/PRJCZ8cEZVOpemUnWLXhoas7Bkfmkvai0zSHKV
	 0xCxUlhn1ewaBnBdUNOe1z1vXFWJaJyL1CE5/0svZmq4cTKPhwiTaqDiUfkrw6AuPA
	 Mqs2bk0KvRWGChOHirz1VP6jjLrxCeFCQ834fPxVyLumz1+ltC+Ptp+UXJh3KShG5r
	 8gU5ZyT/srkBg==
Message-ID: <158bc103-7f99-4df4-8d3b-2da9b04ac0ed@lankhorst.se>
Date: Fri, 5 Jun 2026 13:27:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] cgroup/dmem: add dmem.memcg control file for
 double-charging to memcg
To: Eric Chanudet <echanude@redhat.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Maxime Ripard
 <mripard@kernel.org>, Natalie Vock <natalie.vock@gmx.de>,
 Tejun Heo <tj@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, "T.J. Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>,
 Dave Airlie <airlied@gmail.com>, linux-doc@vger.kernel.org
References: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
 <20260519-cgroup-dmem-memcg-double-charge-v2-2-db4d1407062b@redhat.com>
 <ahBxB5a9sX9DEWvl@localhost.localdomain> <ahXKFYBdCMDBvc_N@x1nano>
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <ahXKFYBdCMDBvc_N@x1nano>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E3256140012
X-Stat-Signature: nbyif4b6jqow4y3pdi1pc74w8n1wte8t
X-HE-Tag: 1780658829-584523
X-HE-Meta: U2FsdGVkX1+hjhjPwiEAi1b7gaiMEWULSHfDnYWbpUsKq//7vU96u74Kao+0CtbZZGVGUIpavzAMuKOlrS64LEbSNWJF/Xjxu0oand9Rn9XZeZvoOOGiN4JORx9ujv6qcNcxZbArA8dXzgo2RKTVcQaPXnp2CZ97GCp4ePtLzwLKgBMzFh5Vyg20jJs5MHrxyp8eJCnnvHuQiWoreMWlNdBXiRSU1TKq5MDaoGG63ikgRaMohC1WuXyf3okuFir44cW6xluk0FcdRB7VUFmLimxo/3jz55jXlJyF574+F1TtGp65rXIbetU9wLL4s2Z0qsvWcZAkT5dQf+Z6Y/YTvGywXT/vLgrJK/03no/3NhhCNwQObo9jotx5wFjBMH+k1l+SJLkH6YQQOs7hT+nvk3omRGqrmGgGiZKJqWzFDao2qtHnZ1DXzcyscviTxosQLM/KTsi0tiYzgT5CjtXjIP/0yAGPPIcUG7Ug40dfAHJ7L3WqjI8nWI3ZNa3o/BMn13qhqZtzomTHmZZM0QGmPOlovedak8EgJ4YaAEfVKbuLK/Xei5cr8XIAih1CvuTN34ZeHn65FQhuxeXTBOFc+XminDEo6GjGSduXmjRLPSPf/Nolf7sn/xvpoj7my1djkmT6cE1hH1JeZMvWVavVhhd+xt7H9HEP5ypfBw4PMid4n7Bt21DGveKQ7vRh9M4dUZA9ssG3pcW4k+n7JDe4uKN+WNSUJ4TP1GXzlMCtN1cYlaLdHs4X6upkWez/xCJoVY7yEpa8w00ySeMF8reQ3vkMUhxx4RD1yGDTc1LQXn4mocRSVQf2EiMQced0ykR7D4SSTsbJHYeuJIL10om3qcQJWpoJ139qsCdOw1SoAX2kSTjfFCktgZ2GQnd7MOx0JWVPezurTm3CISJsQ020OOR8OkgfkXnnlXKjLNe5mh+LTshHn/9PVMsr/H0kFPlzcqDMJ5q+j1u6rXO0o2r
 kKmrX9ie
 EemTw9cXPudzRHAzXjAxu7fCAAMKSrIn7GtI+t2vLSK9pkmuKYQ4Pt1gaHRRSTkMgKEMHpVUb9KDd2uj4p4NNoK4L+eEuds9COLn1rxdZ0RCqFwXBDAfnpOdSsQsglZfcWgDl4Cln76OkUtyEfbcWmunmIWvpK4EeLihSW/jNA19MM3k7roZqqMFIRhjLevYCKzuXU+ZRrSIKUEFWe39Gy1WKmDhEwynaLzUl42KEErEbYzKa0SpvM1ncGkXSGBGM72GrmIVynly/pKf8MbR1zpS/0mTgOhMa5UVo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,

On 5/26/26 18:59, Eric Chanudet wrote:
> On Fri, May 22, 2026 at 05:26:16PM +0200, Michal Koutný wrote:
>> Hello Eric.
>>
>> On Tue, May 19, 2026 at 11:59:02AM -0400, Eric Chanudet <echanude@redhat.com> wrote:
>>> Add a root-only cgroupfs file "dmem.memcg" that lets an administrator
>>> configure whether allocations in a dmem region should also be charged to
>>> the memory controller.
>>
>> This kinda makes sense as it is not unlike io.cost.* device
>> configurators.
>>
>> Just for my better understanding -- will there be a space for userspace
>> to switch this? (No charged dmem allocations happen before responsible
>> userspace runs, so that the attribute remains unlocked.)
>>
>> (I'm rather indifferent about the actual double charging/non-charging
>> matter.)
> 
> Yes, this is intended to be configured before the user space stack that
> would start allocating things is started. Once it has started (and tried
> to charge something), the configuration is locked
> 
>>
>>>
>>> To handle inheritance, dmem adds a depends_on the memory controller,
>>> unless MEMCG isn't configured in.
>>>
>>> Double-charging is disabled by default. Once a charge is attempted, the
>>> setting is locked to prevent inconsistent accounting by a small 4-state
>>> machine (off, on, locked off, locked on).
>>>
>>> The memcg to charge is derived from the pool's cgroup, since the pool
>>> holds a reference to the dmem cgroup state that keeps the cgroup alive
>>> until it gets uncharged.
>>>
>>> Signed-off-by: Eric Chanudet <echanude@redhat.com>
>>> ---
>>>  Documentation/admin-guide/cgroup-v2.rst |  23 +++++
>>>  kernel/cgroup/dmem.c                    | 158 +++++++++++++++++++++++++++++++-
>>>  2 files changed, 178 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>>> index 6efd0095ed995b1550317662bc1b56c7a7f3db23..1d2fa55ddf0faa17baa916a8914d3033e8e42359 100644
>>> --- a/Documentation/admin-guide/cgroup-v2.rst
>>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>>> @@ -2828,6 +2828,29 @@ DMEM Interface Files
>>>  	  drm/0000:03:00.0/vram0 12550144
>>>  	  drm/0000:03:00.0/stolen 8650752
>>>  
>>> +  dmem.memcg
>>> +	A readwrite nested-keyed file that exists only on the root
>>> +	cgroup.
>>
>> Strictly speaking this is not nested-keyed but flat keyed [1],
> 
> Indeed,
> 
>> which leads me to realization that this is the first instance of a boolean.
>> All in call, such a composition comes to my mind (latter is RO):
>>
>> 	drm/0000:03:00.0/vram0 enable=0|1 locked=0|1
>>
> 
> So per[1] 1 key, 2 sub-keys (enable RW, locked RO), that looks better
> and match the documentation, thanks!
> 
>>
>>
>>> +static ssize_t dmem_cgroup_memcg_write(struct kernfs_open_file *of, char *buf,
>>> +				       size_t nbytes, loff_t off)
>>> +{
>>> +	while (buf) {
>>> +		struct dmem_cgroup_region *region;
>>> +		char *options, *name;
>>> +		bool flag;
>>> +
>>> +		options = buf;
>>> +		buf = strchr(buf, '\n');
>>> +		if (buf)
>>> +			*buf++ = '\0';
>>
>> I recall there was a discussion about accepting only a single device per
>> write(2) (at the same time I see this idiom is still present in other
>> dmem.* files, so this is nothing to change in _this_ patch).
> 
> I would second that. When setting say dmem.max for 2 regions, with a
> typo on the second, the first one is set, but write still get EINVAL.
> 
> Also, I just notice dmemcg_limit_write() returns EINVAL if the region is
> not found (this patch returns ENODEV).
> 
>>
>> Thanks,
>> Michal
>>
>> [1] https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html#format
> 
> 
> 

Perhaps a bit late, but before we start adding this UAPI we should enforce a
single region per write?

Kind regards,
~Maarten Lankhorst

