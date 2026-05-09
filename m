Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C2B4CD37AC
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 02:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1FF6B02ED; Fri,  8 May 2026 22:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E628D6B02EF; Fri,  8 May 2026 22:31:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D786E6B02F0; Fri,  8 May 2026 22:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C97996B02ED
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:31:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76EBFC1CD0
	for <linux-mm@kvack.org>; Sat,  9 May 2026 02:31:46 +0000 (UTC)
X-FDA: 84746305812.28.2B7FE3D
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf16.hostedemail.com (Postfix) with ESMTP id 39DE0180002
	for <linux-mm@kvack.org>; Sat,  9 May 2026 02:31:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t7OBeIUy;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778293904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=isoMVqmiA39mM7GIpQVXu+Zu5R5lf1TBBevgqgkjmOE=;
	b=0RyczqgjpWDi6+A1HieyXtbJbEL6wmjjdgk0w+Ngh0sn9OTq1uiz7mGrDsQ9nuP1Atzq9w
	UXpWhbV/CGZuu7uvd2CKhMqBJXWBpirQEgmP8xDv59H/YhiyqMHZrF+hFWA8m59VZm4teR
	PJcsS10HLEWzTWPmW5a1MMPyUeTo2mg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t7OBeIUy;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778293904; a=rsa-sha256;
	cv=none;
	b=4zXgiZ8kgdNWhbVVkQxTSVL0neMjnEgEDRxLqlKGKa8eRE+ti9gUMxamouMtilJPDCiW97
	3DfKsNM64XmWKU2ZIyDf5dGerwwuD2aTP5t9j/1yu1o3vcTOMlDES/EVSzI14OxTODRTrG
	ZQQky7tCfwxR0RDLlqQ/TTfpFdQe/I4=
Message-ID: <ede39af0-e5c1-4cb7-8382-400e1961d9d1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778293900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=isoMVqmiA39mM7GIpQVXu+Zu5R5lf1TBBevgqgkjmOE=;
	b=t7OBeIUyKK8fXSiN+xna9GkR7p4NwqefMbij1e8D74GOypyjdZDkhoArPhuZVaLhL59w/0
	JQgmkV8WJTeALVBdGfHmqe+M6Yg/X5UDJ3GmG14SQvxKPFrA68miMpu1o1BtToCsSNDYK5
	9+Dlr2RHsXkZlRF1zG1jBTqfzlJSJW0=
Date: Sat, 9 May 2026 10:31:15 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 0/5] mm, drm/ttm, drm/xe: Avoid reclaim/eviction loops
 under fragmentation
To: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Brost <matthew.brost@intel.com>, Dave Chinner <david@fromorbit.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Carlos Santa <carlos.santa@intel.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Daniel Colascione <dancol@dancol.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260506033300.3534883-1-matthew.brost@intel.com>
 <20260508170355.c937b91cdd63a11e56d2225d@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260508170355.c937b91cdd63a11e56d2225d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zai8pjhbzs6um1iwg1gf7qqqkppw9j4b
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 39DE0180002
X-Rspam-User: 
X-HE-Tag: 1778293903-956802
X-HE-Meta: U2FsdGVkX1+L3/UoojKMEsK375SNaiWWqKNS9yxIfiAhoPvIg3kNdboFAA2+BkqDOgpKYOPYcT/0OWEeL2b3o9iPJI0kjJ3+8KEcNlHPfGgMiK/s3VQIXG9e6ftTMZ50KmDSryYbpg2uZipWPLJGSG87qUk5r1mWHlKvkJ6t0r5ATL7ypwL2M9CwyKshn1YkR2fAvodQ8uxZa09ivYWjzoJIotAe/VjPELbPDwKwlhMQ1y/oMrKbCr+3jjhNy/DNprBZG+iTM0OzPkLZgFp8c8UQCI9Ea0jxlVbQs4yMUj38hwTgIYZ80t9U22sIDBFBrp/sArynbCiFKIvcwMdmMSkx90LGupSstVismaUVUpzQ2t7a83Wd2x6ZOqNrqCP4nPLJcLJgWMdV6UOLDnBh7QPWn970LwHI7S7sFnAya6vVffOizXcRKUr8a4GXRsvyw9QKmGSHfKZCjuyu6lUXRT9TroFqP258fujl6qjHdqkeeXB6n4ZFF9SdRx4qJcTmWltxFARQHetvfeaIX1aNxXzJ+Cmd8cvrQFLQzRziIV3maDJ7/95QjuaCA+5IiqBa0sjB28go/O9w7dazaG2V3/iNnr+0ir2gjpwoUXW3qkiIDNNZNBq3asW98hYdMsZwKLHwftYdCRFtdeuttq02U7FwHoZR1xNkQf9T4wAwgouLQzvZTxJfAKNJvilESstaBEyc293mwiCuK8kbW4CXf/PvWpMA7nAAK0eJ75r9mX83zg4e4zPapHUISLuTP25DjngccUpcT/UzsE5/bwunkLPq6cAfUal6/sRmDo3oEuccDk5i+uhCRrK8c0DkPxi2FY0dvXFL8b5gaek3i4sEnY999iqKX6/FRYlkP6/EiSh79/5zibxqIAZWx3ZiyKHpIdZP3ecj3wc4HbXWCXE4RlV92cJcy0eM/g7xAp3f35dHwnLgAwJMxtO/Mmq7f+q0MhKhfRq++vsqxps/OI7
 afjPlW7R
 SPE4ka56C7ehyHgiy/rPcQ+rjysEaxTuSSMhlzlBBwaOTytryGt6hzB0q76DPo/9/Un+p7MpJumE5ZgVczTiijyrA2TeusErBIwg0M/kqG/bX3TcQkr/VO5UcCLazDDYm2jyh4PAMlzFnlTs/h9dNesnLhHEeR9fcUa6s2S9NZdgVJI5fTNf1LK04j7f4q0BDFrJom09WGw4dlOSl3C3BZsDO6ast1zzInJ+xldORh/SXqQOhDFpeKULo8qf0Qg5r/cntDOSkc4fl4Dzc84NMlibX9Gy76o33gTKPx/6hdV/LPbTuemapc0zc9bIadUhdwO7d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/9/26 8:03 AM, Andrew Morton wrote:
> On Tue,  5 May 2026 20:32:55 -0700 Matthew Brost <matthew.brost@intel.com> wrote:
> 
>> TTM allocations at higher orders can drive Xe into a pathological
>> reclaim loop when memory is fragmented:
>>
>> ...
>>
>> This series addresses the issue in three layers:
> 
> Thanks.  AI review asked a few things, nothing looked very serious to
> my eye:
> 
> 	https://sashiko.dev/#/patchset/20260506033300.3534883-1-matthew.brost@intel.com

I recall Dave having concerns about the design itself in v4 [1], but
since he wasn't CC'ed on the whole patchset, there seems to be no
further conclusion. Maybe it's best to wait for his further feedback. ;)

[1]. https://lore.kernel.org/all/afQE-2JOzfOm8enM@dread/

