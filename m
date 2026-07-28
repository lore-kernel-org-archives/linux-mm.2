Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4495C54F4D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 17:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4A066B008C; Tue, 28 Jul 2026 13:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24336B0093; Tue, 28 Jul 2026 13:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3A726B0095; Tue, 28 Jul 2026 13:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99BE56B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:46:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2AAF416047E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:46:54 +0000 (UTC)
X-FDA: 85038915948.05.20A47A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 72C53120008
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:46:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IN1C/6TA";
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785260812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oGzCyBQVNAADahTS9j+taObDqgyrjdBmVF7/If3BszA=;
	b=PxSbdt2N3lbruM7ggC6nmh4xiPlVeWLaO+RIWDTMVke8vqxV2v/804ZiYU3TTtUD/q7Rrd
	IX+FCEjvP91BIW3E0dgNFK9cibZduzRcC/X9vzv8MlZsEhPaiznfOkczg9Mg+6+CZM6Nyx
	minCTzI1iVloeUlzo6MQlCnfPOPwGkU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IN1C/6TA";
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785260812;
	b=K7B27kGpuYxCo8jG2E75LIlypMLtmlcQKyWlFL23YOcSgJ/oZXD3z0u72Pdrt/TAG2FKBl
	OCZn2RqoQaRfdwwhosq9vhOFJSaBTynPgy2YEUpXQ+iSXgWCzXXgJtI6P+AYcJJtxNLxHy
	S/m50tlWAxcyD/Q75lbSix+qDwps8Rk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0965600FC;
	Tue, 28 Jul 2026 17:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DE41F000E9;
	Tue, 28 Jul 2026 17:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785260811;
	bh=oGzCyBQVNAADahTS9j+taObDqgyrjdBmVF7/If3BszA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IN1C/6TABX8DJkmlH/pqQ3Gh9ymlJQAXHBqgl37UZuJxbsCwEPm0kfmtHidqBmwEl
	 jWh7R+7qKBg/lB0fJrNNBM6NJIjRIdhVVlRUiIQGwWp6v+WR7PtBLQItV1bt+bW9z/
	 dclDTxcN0nwp0N6cZuSALlo7luayIE3YE6m3x/ki2+lbsqSuoDBO356VcmVh67fnkR
	 kkRbMdsnba+Vl7LPK5jOFZq+6iFRSHQR28znFUBw/PBuZJm1tEQWUNNvi/OulePmB0
	 F8cWOEfewGKnP3E4anDlgWZQmbfa7Acp3+3cvp3JvQgiyHjev7Dy9XQ23UhEV2CkU/
	 9eX7q8Ad/mkng==
Message-ID: <53f59eaa-efd8-491c-ae12-510e2b675533@kernel.org>
Date: Tue, 28 Jul 2026 19:46:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/13] mm/slab, alloc_tag: reduce obj_ext memory waste
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 72C53120008
X-Stat-Signature: gjhgyn1yo6khh5yrcq6i6w474hktm56w
X-HE-Tag: 1785260812-325893
X-HE-Meta: U2FsdGVkX18knkoCoYARISOEDDAXTfj8SL5qY37H1A5S97MaiAcMQHb8J2t3jAGi0pgsyCVoc1YZwMr4RpowlxXbr2Zq8y+gfYDy/ZEa+3tn/lxmNfwcDQmagfUKPZV7Q5+yKPlf1uRLl1/cjiIjwYHstsF7Vitf25sYO7Me/82sxs2NLX0XiLXDmFiwJ1X9FCrLEX2qREZck+/9oSl8jTQ8jv6FV9irsf6dCxJKZ09LUtgeHWlVYuGmU/N2944qZzaO526BhkAn1wrL+C/KjkPHl7fqXCYlc1/4lUphi/UNTC9rsismPENP+sII1SlFeS6DT3vhnK0wJlDurb+sL3A0+ZMezI9TAvfzrwqTUU/B/Of9UPpn+y2/70Ufw1DtcBeVDomNTX4nawZ3B257lhLUJ7j+6eb4YKi3NL3biRiBW8YBdju2BdT77zP1REPVFO0H6npFein4m75v8+c+Jh/xLpU0yPi/y5SItYqrE14zv+yps/INp4xNTVVBGmL79EsvCsTBgratglL6pq4iz9YrDJSws+wO3YbYhfGHRfQXD8AjDf0HG7s8kib8w9JotmtXYclqlqPiVLloZON4HisGtEDMpRJPIGh8gwJy1mserV4uEumQ4z0xi23kK9W1JnVUxeQN31QqIOJFZQ9hl8rGSavtA4SYlEYR8VYgRU0QcZSs5I/aqo0omtIcfmN1Vh8u0fuazm/9e4458CRWzB8lVvocqe9Wqo9bqvsVNYy8yJ4ewwj2IxLLFnQgQ2CRfCtOKBTryPK99t3jxzB4pBkFMF1E7lgVtc1BbywIqJdOwToGNIA0zP8hSzAW8FiFTRkFwSgIt7PCKs5FkqL2nHi8mPxDdoEiVah2+rmNfoyschT99IMRhqMgXwYQiUBL53rczNK6BzAkhTFLDkv2fIOvBGZq0SrXf2Q6vDkLHHJGKv5oiA0MkaRoZ1dGiNTZmfaOhVcagQAoK9BKCkj
 IZvvL7Hp
 6iCu2mTo57N0TxXmnfiqui0jdT7boL+HwGFiA2bBoCoM233IFse0GBf2R9Cf/xPkZq892dxPXR87yLkYTpHvsyvzO3sStbTbTFvblQPI4E86a3ptbM+GDoFf9njAYOHBMvDUBdWFpZhCSQb2SEj8AqUKEVDLoCzXZrsWm+yU4d5rhLdOZ13Cn+ID78wiUMkARgc44LV44omNp13Xh5ne0uIp8BTExpYFCEIrlkktP7dBe0+1SGimlXrlyR05S8m4aLUf2z7QV1O9/3bKHWXGPNABytYoC7A3DQlsnrV8qNle8c59C+05amUUgCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 14:53, Vlastimil Babka (SUSE) wrote:
> ---
> Vlastimil Babka (SUSE) (13):
>       mm/slab: skip kfence objects in allocation profiling
>       mm/slab: remove objs_per_slab()
>       mm: move struct slabobj_ext to mm/slab.h
>       mm/slab: make slab_obj_ext() determine object index
>       mm/slab: abstract slabobj_ext.objcg access
>       mm/slab: abstract slabobj_ext.ref access
>       mm/slab: replace slab.stride with obj_exts_in_object
>       mm/slab: change struct slabobj_ext to a union
>       mm/slab: introduce slab_obj_ext_has_codetag()
>       mm/slab: reduce slabobj_ext memory with allocation profiling disabled
>       mm/slab: add cache_ and slab_needs_objcg() helpers
>       mm/slab: stop allocating objcg pointers when unnecessary
>       mm/slab, kfence, memcg: completely remove obj_ext for kfence objects
> 
>  Documentation/mm/allocation-profiling.rst |   7 ++
>  include/linux/memcontrol.h                |  13 --
>  include/linux/slab.h                      |   3 +
>  mm/kfence/core.c                          |  12 --
>  mm/kfence/kfence.h                        |   3 -
>  mm/kfence/kfence_test.c                   |   2 +-
>  mm/memcontrol.c                           |  40 ++++---
>  mm/slab.h                                 | 189 ++++++++++++++++++++++++------
>  mm/slab_common.c                          |  26 +++-
>  mm/slub.c                                 | 184 ++++++++++++++++++-----------
>  10 files changed, 325 insertions(+), 154 deletions(-)
> ---
> base-commit: 5ff172f6c94d282d83cb88bdfec5f647ad9c6105
> change-id: 20260714-b4-objext_split-da82426257d5

Applied (with fixed up 10/13 per sashiko, and 09/13 with a debug check per
Harry). To slab.git slab/for-7.3/objext_split and merged to slab/for-next.

