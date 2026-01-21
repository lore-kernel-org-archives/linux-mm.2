Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAD92D262B7
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 03:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338FA6B0005; Tue, 20 Jan 2026 22:44:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E5C46B0088; Tue, 20 Jan 2026 22:44:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4EA6B0089; Tue, 20 Jan 2026 22:44:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4626B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:44:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 960BC13BA0F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:44:04 +0000 (UTC)
X-FDA: 84354577608.20.CD06935
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id B2C2020013
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:44:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Na4E4y7R;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768967043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwFI19rHKuXMHgysj9bfGW48tJBo1CHyFN+/G60RpAs=;
	b=VKVb/kvBn6w1+AluZSZi+yPZiww7Tht/iYk6Y1zvmXIpvFFL7Q2m4IdJi/iVuppQ9OSjVJ
	NqKo67ojJfkOXSPERsG8ynyoUWE3twer0flDvN53tTX0pab5trBT1P/+PC7DokFyI1Utfm
	QIPldYMrZPdrKt3/0gSnzKZ2zdCfp6s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Na4E4y7R;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768967043; a=rsa-sha256;
	cv=none;
	b=kHLqGBWM3F6cZxLTljArD86tZdtUA1nmiHIB35wSb9NsIKuQeqj7pYgLci/zrV0kDko9zq
	il1EtsYOMV5ZweWNqfA0V/eGWp9uvpmC6wX/1um8uEjPp6gEIAsSSKyA8ezqTK79RLbbVe
	0BaTbERgZytO53RUVBymY5VGgdnnPpY=
Message-ID: <37734a82-1544-4015-b4dc-30583441a7ba@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768967040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dwFI19rHKuXMHgysj9bfGW48tJBo1CHyFN+/G60RpAs=;
	b=Na4E4y7RhOpKWm1ULIll2sSG85tYL68sEW3f6Hvb1fr+XbIegK2R6fEGdm32+KOAUCMoVz
	dVxDtmmujwNa4ugYnRTV467zixs0i4F1VkAmcRGhagZdGLjJVIIe2CA/+SaZXNf44bxClx
	bVB5eCBt1made05ad31kGVo+G9fxQ2w=
Date: Wed, 21 Jan 2026 11:43:50 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 28/30 fix 1/2] mm: memcontrol: fix
 lruvec_stats->state_local reparenting
To: Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
 <e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
 <ifcth3hxyrwmmeo3nejettdtkw2ndxdjbylszmhq3vohuhsncl@k23pew6gywko>
 <5a18658e-2076-4cbf-bc53-5b6e99c1035f@linux.dev>
 <A13923AA-8200-4863-8080-EC4B254BA3AA@linux.dev>
 <moupi2ch2cpuyrurthk66igh275ks62pltjk2zfngxozj52oxs@64lxvcgh3ays>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <moupi2ch2cpuyrurthk66igh275ks62pltjk2zfngxozj52oxs@64lxvcgh3ays>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B2C2020013
X-Stat-Signature: 7538zg9npbgdssxujm8ke653tt49iz7a
X-HE-Tag: 1768967042-933937
X-HE-Meta: U2FsdGVkX1+r44gw4SCENIvgP13bUryFVVm9WKtDYbks5b0lEMin4pYaZCz3cdzcHh1zWHsMuxVntJkBTxRwUv+tgoZOYqzfWPZ5jcALgrwdyFT/DqnIXdixEEqccLZkqsLCJhxP+SR4vKqkVXbWi7dlQ4ze81qmoBfWkDJfAuQVSn3+O81AEH/mbRPMzKgv6HmyVhnSHahBow5O5o9E7Qe1wRgzkJaVgvU+F4bAo3QP0bFZGdLOHm3K9xO/WZKfKwKvFgikGxOMV2jrcPt1IMhqEMSpitaXBgklGNYOqYFezEpGXrBJ4f0G14Z3RTMZO/uk/PmnsGyd35GfMv1nFTS0q2DXsX3f69Ohs5G+xPW+//+67MWQ9lKRpJ3Yp6j4/h7UU9OHRIsrD0wkEHwAF4ogRZxT5juuN3zwtAHIN/mtevLFs07p8iBS0qrNXYB5gZaSGrIDKkNQ/JrSp+NGol52AfVFpPpe9yg10WP9q+Iq9JsZR1F77yYG4iXa3l76ReVnJRXEk/fVappR1S879zPjoVw/jyKrDHL8PviP6zzhWikEYjs4q0m19g2OkgZdvUy8A/At+gh+WZ8FmnQbHxyAY7TUz5Pp8SW1Zkw49mydFQ0dX7+9wsG59NdBStwTP9ZWiP1XleCt6IOw4fjJ2rm6hFjoBirRgxjoEkknmsvj/9goqc+2IKCQS6SYH0ILZyw/0AJ2+Hcmfp7spJ7iA4HAsTPH1uOEz2ZOYcrEv9sCUuhNl9GeDaLpJW2s7f0JYsMkmVXu2qxP7g1uA41UVgsMpap37qCnzrkarhV40+gLfMbY37/sIAtYlLtRkpMrnzoSbuG+PyKXbLFt7/VPioC4j3YZYyHhgOvxRoSZ28rN5mcR4rwFkKxsx1xCo5Ldq06j+G9cljxV0ZXNik2uAxJdGMh7UyckWFHAbPygifklY4RJX3CiLaThaUResBh3d7My7F3IUycYmx1oefe
 isn6eKVO
 9dPgHCnzpLnC9jcfdaWiXp5W91mKckRQ2Imn5hBni2SR56HSGx/wiqno+dG+SKclUF3hrn3l5dHzog52z31n4zO3xgZw86xgiCoEe3LPck2nRryoEi3nEBOf1Nwhpg2RlmRd4OzKjw3RS5kWPfJmGOGvG5srHYCTC/9tz9WUKeelywLFFAmqAf74gvbNF1d+LPRWFoc7e/9enaR/1BsBaad+0kQaqVRQ/ZlqlrWjOQ+x3BmSP6474CrtAysIHlRoQBsH/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/21/26 2:47 AM, Shakeel Butt wrote:
> On Tue, Jan 20, 2026 at 03:19:00PM +0800, Muchun Song wrote:
>>
>>
>>>> No reparenting local stats for v2.
>>>
>>> It seems that lruvec_stats->state_local (non-hierarchical) needs to be
>>> relocated in both v1 and v2.
>>
>> Here we might need to elaborate a bit. Specifically, in the function
>> `count_shadow_nodes`, the use of `lruvec_page_state_local` to obtain
>> LRU and SLAB pages seems to also require these logics to work correctly.
>> For SLAB, it appears that the statistics here have already been
>> problematic for a while since SLAB pages have been reparented, right?
>>
> 
> Thanks a lot, now it is clear and yes it seems like SLAB is problematic
> but now I am wondering if it is really worth fixing. For LRU pages, how
> about using lruvec_lru_size() defined in vmscan.c. That would at least
> keep count_shadow_nodes() working irrespective of LRU reparenting.

Do you mean calling lruvec_lru_size() in count_shadow_nodes()? But
numa_stat interface also reads lruvec_stats->state and make it visible
to the user.

> 


