Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 612D0C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36EFF6B02A2; Tue,  1 Sep 2026 12:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3466A6B02AA; Tue,  1 Sep 2026 12:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25DA56B02AB; Tue,  1 Sep 2026 12:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC0D36B02A2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:16:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F0E3A4294
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:16:11 +0000 (UTC)
X-FDA: 85165695342.21.4A28209
Received: from outbound.ms.icloud.com (ms-2002h-snip4-11.eps.apple.com [57.103.74.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 78A8440009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:16:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=RfeGA9Tu;
	spf=pass (imf01.hostedemail.com: domain of bfguo@icloud.com designates 57.103.74.43 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788279369;
	b=kNp9QyVHjy4tmJqDvnKcFCbylXQTmVTHFgBGGXHgJ9V4VNMhbG/GY2nGwrDz0GmqJYDoFJ
	M5Vx233uP+5WGSDkFpUyosObxBCfAFhNqRFbIYadyt69QKyUV+nszgOjHtOrflUTdb2Zv8
	qXdpJ6OUetzZAJklUsSsjIAZUqyIBi8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=RfeGA9Tu;
	spf=pass (imf01.hostedemail.com: domain of bfguo@icloud.com designates 57.103.74.43 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788279369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=92qr28gxcvqaJAUGFwtri5MG2JfmT72Ftu72VmuCjoI=;
	b=149fB2apQx1f3AVRMkT3Zh+/TKpF4Y0L5ADA/sEx5WR6i+jMeX4PTdNR0XffADINgPaFqy
	Cy7VWSvtzn/fXjTdkWJoeqbGaVP3f54Z+c4f4z6avmZByWdpb/jCVb9WlqmD+Og8JiWJGG
	tIO4e516opx6gzUdamb88/IkZvixa1Q=
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-100-percent-6 (Postfix) with ESMTPS id 7DE5B1800498;
	Tue, 01 Sep 2026 16:16:03 +0000 (UTC)
X-ICL-RepId: 01a05dc1-9780-74fc-a8a0-dd5f50e2776f
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQtPHV4PRQNECFYCVAVLVxQEGlUKQgRyGVoUXBhTRVEfVFhVCQoCURxWDVdDVARfUEsbDlwOS1oVVRcOAkIfUB9MFldDWhgcGVoUXBhTRVEfVFhDGUVWaUELTx1dGVscQmRYVwkKAlEcVg1XQ1QEX1BUEVdQCwpCEg83dCxwU2IlQSJZXG8rcDl3P3UseSx1JXZVfi4HVRIEQAhWUF4IXh9MHA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788279368; x=1790871368; bh=92qr28gxcvqaJAUGFwtri5MG2JfmT72Ftu72VmuCjoI=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=RfeGA9TuauXRozQTLe9xY/kU20nyeZq81kUUcXlM7EejF7S2n/yO5GMEql4LBO1qqdWUpVFsWrZjskpxVip0+E7DWmg6+yIveonu8+5bgFn5RoUQ13JvVJiMTAH/Y4s0yUy188WwWqp9MdKjGdglsbV5fOBRCa3TbGM8iUTU9R2/XeeNmjLwv1M70JuAmAY6GXC3zWLV4i9mOED6F6KhyO7B5/HP3uE3Nl9slgON3WqgGzgU2ghdhAcRL56lsz0HB7Y84si7uKicJbuhC+uXYuknzjvVrXW+A/qIgKpO7nipqgrzx8vNx1ac2xisbQP/N3Jf7KPCMyOobZx+nw4BBw==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.156.208.39])
	by p00-icloudmta-asmtp-us-west-3a-100-percent-6 (Postfix) with ESMTPSA id D4496180048E;
	Tue, 01 Sep 2026 16:15:57 +0000 (UTC)
Date: Wed, 2 Sep 2026 00:15:52 +0800
From: Bingfang Guo <bfguo@icloud.com>
To: bingfangguo@tencent.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/6] mm/memcg: get memcgid reference only after
 swap charging success
Message-ID: <apb6OGAG8PUxZj1X@BINGFANGGUO-MC0>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-2-8edd7f7a7251@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-2-8edd7f7a7251@tencent.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDE0NCBTYWx0ZWRfX++g7zNO1O3Nb
 Tegk+uvcq5Wc/U4O4nvpW+alzAoZkzEFWcTpwXXC7Eif66wj9YsRp5FljjQyqVKGW9jjqTj89SB
 QMK5uCFDxdBBW1C9VdSyrqani1+gUT3fk1qrhb/bg7ynSH9ukSR7Ij3MDpTHhG3eKiwkk+rJK3E
 OaGTW4grE7Og2WtHt56PLl9dmqLnKbVgKk+NkqSMcz8Kw1JKZdtPLb1V1SE1r4qn3ZaHuYmoRI9
 uVBuled2e+8aLnc3nUXP5d985b4ENi+C3/2SiBAUkxv+wne50/J50weI7GP3l61STe/r3iew6DF
 O5MOaK52ZWkXZAmbgV6okUDYqY/zWKtQ3iGBU6yrTJnfvbstmv2YlPIl8vMihM=
X-Proofpoint-ORIG-GUID: RMguB3f-L3dL71g5JI9oNuBIeZ2Q4tjc
X-Proofpoint-GUID: RMguB3f-L3dL71g5JI9oNuBIeZ2Q4tjc
X-Authority-Info-Out: v=2.4 cv=SvydKfO0 c=1 sm=1 tr=0 ts=6a96fa44
 cx=c_apl:c_pps:t_out a=kRaGL2Q7qLiahLf3O6OaIA==:117
 a=kRaGL2Q7qLiahLf3O6OaIA==:17 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=kWxB-xFdqsxXOBgkBTwA:9 a=CjuIK1q_8ugA:10
X-JNJ: AAAAAAABr7/9GQ5TggZcjHunDR2Vd2DrQpW4NpfLI0rFWEd+2c2sZMk7Iac0b4cS1Sc70LvYYpTHzTTfFpqEtcgi0UP22nBx5HWtpYaTj1xJan4OR5B87OzsGVQ9o31U11FEBzTXrDCZEKS2xrC9NSuEOfyfJHHiDcUpfNmYrwcVm0L2BUWniyJ/z28WPpEN0hmiLXVXJClUepHynvTZ0/OF5uj/fMbHgQdtuGqw0aaN1J1ZNeCMTiN3eZzIqdDxjlfaPxO86cTPk6f4qzHcjsq+mpU0AZ36hVoL/iTyePu0qWgcMcjPJWMJ5/YPLxiHxJEj1IO130W5cvCsFppg1v5QqR4SVPUpZoq3Of8+Dv0nvyIce+SbFbSdGcLcD5B2SY/14DAfYkXk+BVXKQCf83Jyx3KdEXqi9NDAMhVmdin4fyTslczsWkTnlLztY+Xk6HAkIGvfK8dNVzsCRVVzEPyGZl321P3/V+w+dc9YBnTCCNjai7orQfggu3JrbxBJ18Mg7Wa1Via/jrEglS0cn9M6kxaybilRczWVV3NnP9oulF4Ga9l09/mJNgoKrB+lDP5FCp+Mi3TOIFAn8VpCu14mw3rL6YRALiMV+i9q+8KUkpQ/jD5YYoSQYEKeH2yOroChoAcD5iHemK7UbuVN2a7T7M5BzeFTbmH3la+DXdeqmFmTNIDQpPOdeMWaJPOvcXbwfDuyaTaAdv6igdqRY4y7XK770u/90NPlEVDWw2DZjhFPmPxN4M1OuzE4tVORG9gnn2c+UGBXvGPK9GKVZ+JE7gW1LCqohEafVjnCVrse5kUBoQpf7Wb7aWenhkb7jhKlqmTt7LuIM07/ROb9zoN0s+sNCFFX2GfFLJk6Y5gsJNFDWrBL14PMVrYAEwi87wENCJ8UtHcgvepkYo297dbIKKE1tl9WTpabvVAJs5hOfCXx3yu1iZmngLsJb2QH4FOyNzexKBcjzVh6gF39gKH
 QBiWXTXc
 U04aZhQ9hhFhs1ypRSoS8+Mjp3TEB39i6PTYNn5dYDpMrIgO4ZeAiTAJHMF234B9/sNoic5K9T0XOELG7SycnCjDGsvZnKIY6Cq+CLBbDE+RP5GShVQoYrWxAM96S6sOFwmX4gmMgNL+FMiBePYCMbDHh6CYk8VxMdDr02eC+dw+vFVciu8DTufMUxa66Z7JP9fciVVjFduVc6KGYac8RS54TRKrZry+YwjUtbZywv6VbX81H2r+Z2hJWnUCq1XfEETtnOs1LH8SkJK0O+ea+HT+KxazGUg5NQnyITuPUlfBGPujwQuw/bHgo+VfdkhEAjP7Z/D24kq+0rEG3vZcx62VkNPrZSQ+lGxJz9QDAgUfayvGLrmuqTI8YWEUY9lYpoVJp9+y7g6mVTkeuQ3js2hzzz4O7KKN7ydsR/Dzpz7/3QyrmNzDVV6QUcwNE5eKPllX4tAkVKmv/W48jmA==
X-Rspam-User: 
X-Stat-Signature: t781ae4gbgo8ggkm6t4mrgm9pcmgyhaw
X-Rspamd-Queue-Id: 78A8440009
X-Rspamd-Server: rspam06
X-HE-Tag: 1788279369-591644
X-HE-Meta: U2FsdGVkX18+o0j1o6Uuq8dKypDHmTmQRUph9w8PWS2o+i1mX6WuZdl3+Bm4dmXLT7DXciYpwZOIBjBenOpzP/0f6KVFPpPAZTTC7nR7slV1GgKhYmisVZdZtNlB4xSjgvr+ptMT1JxhBL947DgDVdPWcIIOSX81Z7vCmG//rd5s8Yr2QCc/bklnjPRtKaQH2FJbC4GqC7Y4cI47tHLtCiHdEuxgvNUAgrJUH/JTURnVTyNQcLVuWfEd2+dmb8ioXJGT/xkSgoYtYemqjDhfr8Vrf+/DIt+2RIk5eyQLB4PGTSaYZhafiI0rJDdyz4a8czaW/bMtUnNltlNRcXlR2xYgp2ViwrwbRU5MMsvyQTkWbLhcP3+pdIarA4Hddl8uMRtqRwloqfoNXUt+3fb5Foe+WoLP8p1IFENWUIkinRM1XQ0tZqEgBSYcqMb6EiWbqa8vno/fQCwDWSekDkkoFMjh1kMpZvoCbD9UL+0PGNEWzDJuYZSk1w0Ld41ER+79Vy3kXcL5RBCAO3usGmTvMS1atQ6ekopENvmDgB91iDXVfREqoPM7H8qSxXRqofUx+I1JkZWZcCbRNA/eryfkqqgagEYRz2Ke8SZquLfjJ4AyzsXF/7rGINc2umJ9zGf88f1zqfOiP7NoiPAZm0zbRC7uva097xOhHNr7K6GGuZnodTAILi8EwuY1L6lQ5hJcdv9EG7F5xzXi5HqGbZ366/wPRf+ouFglcUuxomeLzj1QOKWrWrsmtpR0Pb8+Ndvjao8/fc9f+nukWCFvxdoBgTIw9fEeBZgQrnSjEk/fmuGEMNRKRD5HLKOD51LcTX0Vuhqlq6DcfbftUUZwsG7NNFByGi+ULRtZ50UninThoW1au8KZiP8Fsed4DTRUgmy/UkiyHiEiZ9LwZhqGiREmODB49WIZsurrtF2CsddYKrWzOgncmPdlbjNlNNue2UhFlhByOKNue09jZv1ZPUB
 n3YSGRyL
 s7nNzcu9O8hpuUVH3mbCLvMkS88jX+Y+fyykIgQit3YazU/iir04+tIpytnnMnd/BNDZ3NL/ptyV5R9G0wKCGWN5z8p7eoZa9nZGvKL+n9am94vn+nDXPCNK9iv2ENB1RmOedjaP54+uLIU2UBD0fdER86QUu/wfNQ6gHMgZOflSpQyU0Fxl/faeRa/X+hBzvMroJh4hNYd11j4e9+KXS94uc2PX5uJUDns3Zi1Psg06jN9paCPrNAom0NX9OBaBENU3yTQHbCbMECtKMsnyZ40Rfv2OoIB/HLkVCXBCbVtVXEZ3eOSn7xQfz73XYd5fO8/MR/8eRi8+elaC33YsFgkhdPKY0U8eDL5/wDzaHr72EVTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding reviews from Sashiko:
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > __mem_cgroup_try_charge_swap() pinned the memcg private id before the
> > swap counter was charged and had to undo the pin on the failure path.
> > Hold RCU lock for an extended period (which should be fine,
> > __memcg1_swapout() does this as well) so concurrent memcg release can
> > be avoided, and take the id reference to its online parent only after
> > charging has succeeded.
> > 
> > The failure path is now a plain return, and the id is only pinned for
> > entries that actually end up charged to swap.
> > 
> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > ---
> >  mm/memcontrol.c | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 31cec9dde55f0..ecb4fb07d7735 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5755,6 +5755,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
> >  	struct page_counter *counter;
> >  	struct mem_cgroup *memcg;
> >  	struct obj_cgroup *objcg;
> > +	unsigned short memcgid;
> >  
> >  	if (do_memsw_account())
> >  		return 0;
> > @@ -5772,22 +5773,24 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
> >  		return 0;
> >  	}
> >  
> > -	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
> > -	/* memcg is pined by memcg ID. */
> > -	rcu_read_unlock();
> > +	while (memcg_is_dying(memcg))
> > +		memcg = parent_mem_cgroup(memcg);
> >  
> >  	if (!mem_cgroup_is_root(memcg) &&
> >  	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
> >  		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
> >  		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> > -		mem_cgroup_private_id_put(memcg, nr_pages);
> > +		rcu_read_unlock();
> >  		return -ENOMEM;
> >  	}
> >  	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
> >  
> > +	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
> > +	memcgid = mem_cgroup_private_id(memcg);
> > +	rcu_read_unlock();
> 
> Does this introduce a Time-of-Check to Time-of-Use (TOCTOU) race?
> If a concurrent cgroup rmdir (triggering css_offline) occurs exactly between
> page_counter_try_charge() and mem_cgroup_private_id_get_online(), could it
> drop the child's ID refcount to zero?
> The subsequent ID lookup would climb to the parent, recording the parent's ID
> in the swap cache while the child's counter was already charged. This could
> leave the child's swap page_counter and MEMCG_SWAP stat permanently charged
> when destroyed.
> Additionally, could the parent cgroup's MEMCG_SWAP stat receive a spurious
> uncharge upon swap-in, causing it to permanently under-report swap usage and
> corrupting the memory.stat output?
> 

Just as I replied in patch 4, offlining shouldn't happen with rcu read lock
held, so actually this won't happen and we should always get the memcg itself...
And even if we are getting the ancestor it should be fine, uncharging can be
done for its online ancestor and stat will be consistent.

Maybe we can release the rcu lock earlier or remove the retry logic when we get
the memcgid reference?

> > +
> >  	ci = swap_cluster_get_and_lock(folio);
> > -	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
> > -			  mem_cgroup_private_id(memcg));
> > +	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, memcgid);
> >  	swap_cluster_unlock(ci);
> >  
> >  	return 0;
> > 
> > -- 
> > 2.43.7
> > 
> > 

