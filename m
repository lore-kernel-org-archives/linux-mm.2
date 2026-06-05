Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 011CBCD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAEA96B0005; Fri,  5 Jun 2026 11:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5EED6B0088; Fri,  5 Jun 2026 11:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74406B0092; Fri,  5 Jun 2026 11:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C75416B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:53:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6EBDE1A01B9
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:53:20 +0000 (UTC)
X-FDA: 84846303360.23.F312D50
Received: from lankhorst.se (unknown [141.105.120.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2651A4000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:53:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=lankhorst.se header.s=default header.b=HKtT4aia;
	dmarc=pass (policy=none) header.from=lankhorst.se;
	spf=pass (imf12.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780674798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLryhwFngzdLEruCB/iVB9f0uVf7W+GPi0/Zb4M1y5g=;
	b=dgAu3Uo4h7nYCM7tnO+N7aKey/UdMtB7eau7n0dI7u4Wmo7g/YMQm4VyhkNbrHUmcS6Eui
	U9ySNfwuVEJoA4vPfmNj3GK+RBA08AqWMLqQ9qmtphevvk+rb0Swt7i9rCnYMZ5gRADnzG
	tatz1bGyrXdb8aGezcVBZfN7l8jxZsI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=lankhorst.se header.s=default header.b=HKtT4aia;
	dmarc=pass (policy=none) header.from=lankhorst.se;
	spf=pass (imf12.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780674798;
	b=fwIrf5LstaLpQHbIRT//597ij/lLCZg5jiWM4Uszkr6c/Bsn9833KJBgU/XLuz2G7f44+C
	GUC0/NKdJ5gDJ5e7FnRp44xN8btAk27jXKtUCQ2hLmnYNVNuuhP7kG3EhlwAjpNQDXyo8w
	CW1sVrd4LNMK5dGdxnYKabQkIMrRb4c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lankhorst.se;
	s=default; t=1780674796;
	bh=KHV7Fhy3ZcWBoItd6My6nFLOPmYf7jB0k6jodzEWg7o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HKtT4aia3WWT2tzcVXI+3VWpQ23gDCQYrXrrNZBhkl6DzG+UDBwgl/CCMoXyPVsOc
	 hB8jBZvWwgIg7zVTRHwtYVYMbLfzuVVJIQlOipw0ztzvLaBOag/+Pd1ydQSQglviUM
	 LOjTWStzoANoaNrme8SUVMbfol4zc+gR9LGIfqCS6qACDLRkJIEG0hxooyNHBDJ2xE
	 bQIoXuqoLzdGfJrs18kvYf9Gly5Zk1AwbytFbmPVuAZASDjSGS28j95+ATMW9AwW06
	 I/2gELsdMnVao7bV2lOmZYjYguEv4V1OL+E+CNQMWP0XI32nrAm687iJWUBlUM0Cyv
	 A+5mxS7AWf8MA==
Message-ID: <9c59cddf-0a1b-4110-886d-477d7f334f08@lankhorst.se>
Date: Fri, 5 Jun 2026 17:53:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] cgroup/dmem: add dmem.memcg control file for
 double-charging to memcg
To: Eric Chanudet <echanude@redhat.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
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
 <158bc103-7f99-4df4-8d3b-2da9b04ac0ed@lankhorst.se> <aiLVbQPxK1qI1h4p@x1nano>
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <aiLVbQPxK1qI1h4p@x1nano>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: tkh8z6tbe1ux9jipr48pg4xg9w7hkcks
X-Rspamd-Queue-Id: 2651A4000A
X-HE-Tag: 1780674798-77422
X-HE-Meta: U2FsdGVkX18jhZqEE1u9Xe/dcixwYJpo8PMh14BusyBiqKwmi432fxnGUUPxdu4U69HtNQbpzxH5gbv9fVI5dmz8ROySRe67CoLy9qf8SFXwzTKAiOJzsey4nf3pQBULrYSlF+h34jYa5E1TZjVgau42SFsr0t8RV6ez7m03FoZLbIH8XBi1tvD6iA+d3vxLuXfoDYOG+z7TmllXU02pIZx91ROLEM3n9o+rz6Qe557ug8SThX6qYUtoy82Uw9wvc6Rji/06TK78b5Z7w23N8VSSdqh3ibJ0U1HgxagSqDBfYOVxIE7PXjJq+BC0PTqd8U6k/gn2cIXeROFaa5D9KnD8E8fSkp6Wh1iWDAzJcNhb+TDSYpKtnsW9KWmn7EJ7mwnnXn1CGJ5a0c4IKmvV6L5lefhI2I25iUR6WUQD2lV/1Y0EVmmBU1oExlxWlcjKwceEWQI/2lwR33dPmQJ7BZ2XLRlfqP7+7ySncu2BJJme6Z5bbxGb5oi35xRO5gSsA56Qo9wOIBJVemitMH98lRMsyw4S7A6xylg0pMN2YSgFsTbuP9rO0dzM5QxRB+7JxiiKr+hQ1RcxJayvuzze6Afn3pjhQ0XHYOpT82QM3baA4ddbwWokVDHY+cjkL+HarRqfQbSNIMHqLGO1CoOQtNDvbV2DcjPQBitflWyUiHdWiXgJ+GzWVOx9Q0KW0Sjv1bN+hJwAa2nuER1MHHTAXalMRyCf+NXqHGFWn9iXkbUr/QrovX/YJESFhb9pdaUk48IdrZRXg5WncFWQCixwPeSJtI/P8mzgQ1CgmAVpUV0r40HdW97779y70KMmN99JRghzSWoELIo0bXDqB52ezXX8wzQy/6Trb18xU0zI4gTrAye6mN7pl7R9qs0gHiVxhxHhSW6wWpZQ1/7qijRoh/hMyNvS/fno54fGRhqbD9sRMo1ZWhpXaJ2is2eHCexHI+U6+Yl7zDokgcRoQQY
 OyTeqSri
 u0Yu2JiYAfnekIAHjKeAGGYK3T7ZgrHfu5lvlII8PGYzwLT1+h4fVRmUtzuommmTqai3uG24ipUANV/pofoY946LVrOPOM1qtNbunJtNkbpuWkpF+uUmbbm5Ym3e5VVZXzRNQsL1OA9RL6dKsDKAx+bpy0MgOanQcW524wKVSIoGjN5I8v0mDw+2cqMT5PqIkMSGNDK1Tdo3M2ZVtW5vmFYsys1SNM+rKyR8MqDiKMUNeuVR1fp3RkQV8IOu+VsGcehsjwi/eo0J8TanSVwjMoxT+tj46ApRK9mdH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,

On 6/5/26 17:42, Eric Chanudet wrote:
> On Fri, Jun 05, 2026 at 01:27:09PM +0200, Maarten Lankhorst wrote:
>> Hey,
>>
>> On 5/26/26 18:59, Eric Chanudet wrote:
>>> On Fri, May 22, 2026 at 05:26:16PM +0200, Michal Koutný wrote:
>>>> Hello Eric.
>>>>
>>>> On Tue, May 19, 2026 at 11:59:02AM -0400, Eric Chanudet <echanude@redhat.com> wrote:
>>>>> Add a root-only cgroupfs file "dmem.memcg" that lets an administrator
>>>>> configure whether allocations in a dmem region should also be charged to
>>>>> the memory controller.
>>>>
>>>> This kinda makes sense as it is not unlike io.cost.* device
>>>> configurators.
>>>>
>>>> Just for my better understanding -- will there be a space for userspace
>>>> to switch this? (No charged dmem allocations happen before responsible
>>>> userspace runs, so that the attribute remains unlocked.)
>>>>
>>>> (I'm rather indifferent about the actual double charging/non-charging
>>>> matter.)
>>>
>>> Yes, this is intended to be configured before the user space stack that
>>> would start allocating things is started. Once it has started (and tried
>>> to charge something), the configuration is locked
>>>
>>>>
>>>>>
>>>>> To handle inheritance, dmem adds a depends_on the memory controller,
>>>>> unless MEMCG isn't configured in.
>>>>>
>>>>> Double-charging is disabled by default. Once a charge is attempted, the
>>>>> setting is locked to prevent inconsistent accounting by a small 4-state
>>>>> machine (off, on, locked off, locked on).
>>>>>
>>>>> The memcg to charge is derived from the pool's cgroup, since the pool
>>>>> holds a reference to the dmem cgroup state that keeps the cgroup alive
>>>>> until it gets uncharged.
>>>>>
>>>>> Signed-off-by: Eric Chanudet <echanude@redhat.com>
>>>>> ---
>>>>>  Documentation/admin-guide/cgroup-v2.rst |  23 +++++
>>>>>  kernel/cgroup/dmem.c                    | 158 +++++++++++++++++++++++++++++++-
>>>>>  2 files changed, 178 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>>>>> index 6efd0095ed995b1550317662bc1b56c7a7f3db23..1d2fa55ddf0faa17baa916a8914d3033e8e42359 100644
>>>>> --- a/Documentation/admin-guide/cgroup-v2.rst
>>>>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>>>>> @@ -2828,6 +2828,29 @@ DMEM Interface Files
>>>>>  	  drm/0000:03:00.0/vram0 12550144
>>>>>  	  drm/0000:03:00.0/stolen 8650752
>>>>>  
>>>>> +  dmem.memcg
>>>>> +	A readwrite nested-keyed file that exists only on the root
>>>>> +	cgroup.
>>>>
>>>> Strictly speaking this is not nested-keyed but flat keyed [1],
>>>
>>> Indeed,
>>>
>>>> which leads me to realization that this is the first instance of a boolean.
>>>> All in call, such a composition comes to my mind (latter is RO):
>>>>
>>>> 	drm/0000:03:00.0/vram0 enable=0|1 locked=0|1
>>>>
>>>
>>> So per[1] 1 key, 2 sub-keys (enable RW, locked RO), that looks better
>>> and match the documentation, thanks!
>>>
>>>>
>>>>
>>>>> +static ssize_t dmem_cgroup_memcg_write(struct kernfs_open_file *of, char *buf,
>>>>> +				       size_t nbytes, loff_t off)
>>>>> +{
>>>>> +	while (buf) {
>>>>> +		struct dmem_cgroup_region *region;
>>>>> +		char *options, *name;
>>>>> +		bool flag;
>>>>> +
>>>>> +		options = buf;
>>>>> +		buf = strchr(buf, '\n');
>>>>> +		if (buf)
>>>>> +			*buf++ = '\0';
>>>>
>>>> I recall there was a discussion about accepting only a single device per
>>>> write(2) (at the same time I see this idiom is still present in other
>>>> dmem.* files, so this is nothing to change in _this_ patch).
>>>
>>> I would second that. When setting say dmem.max for 2 regions, with a
>>> typo on the second, the first one is set, but write still get EINVAL.
>>>
>>> Also, I just notice dmemcg_limit_write() returns EINVAL if the region is
>>> not found (this patch returns ENODEV).
>>>
>>>>
>>>> Thanks,
>>>> Michal
>>>>
>>>> [1] https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html#format
>>>
>>>
>>>
>>
>> Perhaps a bit late, but before we start adding this UAPI we should enforce a
>> single region per write?
> 
> I can send that separately, although that is a UAPI change. Is there any
> user that would be affected?
> 
> This series is hung on charging memcg using memory objects from the
> context of dmem, when at that level of abstraction it doesn't have
> access to the underlying pieces that were allocated.

It's a uapi change, but I see more and more interest in the development and usage of dmemcg.
I believe it's better to fix this before users (perhaps accidentally) start to rely on this behavior.

Kind regards,
~Maarten Lankhorst

