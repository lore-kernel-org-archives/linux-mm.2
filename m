Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E562ECD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 14:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4A686B0088; Wed, 10 Jun 2026 10:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A219F6B008A; Wed, 10 Jun 2026 10:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937566B008C; Wed, 10 Jun 2026 10:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 837116B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:54:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B65F1A011A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:54:51 +0000 (UTC)
X-FDA: 84864299982.24.67263AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 314D218000F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:54:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HV+JRSbH;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781103289;
	b=sgs8r1JLttp3gD1G22eNDVyZpmAUOxpqNDO5MRD6DtLVmm9soFRBgGuFHk898+l9S8hWmt
	MqNRIy95zi10Ce8IqBP8cVg6Dq6iX3OHdP7MFZKGSsZp1TOxwCUeugauJhf8stMkHw1ZQ0
	T6XAl2b8N9NXkRj6etV0mHOlz4XO+U0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HV+JRSbH;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781103289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XzvATamoarWbKL+9WgzetuIll6aemx7kmaC8tNAoMZY=;
	b=O4g4/UuzVkySeL9jEsprRJYTx3Gi64G9hLJudVgeRQbjc9leYspULjIPxEtG7wS5yg1Vmm
	D94hWaRTus33iRykh+NlOe0SA8OhEpMu227NTOvvRAizEUV8+enALUHF27bDm+mH8uWmxU
	/8X9BO0GTi6uOJzUvRBEl436C+kQ2ME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 80FB6600AA;
	Wed, 10 Jun 2026 14:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743721F00893;
	Wed, 10 Jun 2026 14:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781103288;
	bh=XzvATamoarWbKL+9WgzetuIll6aemx7kmaC8tNAoMZY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HV+JRSbHVx4wJyaho5Cscn9BT1B6SP6eYEFRpshwrzIEc2MveqOT8QmWOFB59HGHy
	 MfvkBTqBmg7vZCEqwILgKDZVLc24+M5P8T15Ja9h7IdJXTA+N/xbHMm4p5G3ML4Ibp
	 DGk0zAvzpIP1LYL02fp+hEC3P9n7WQw+tUryHsT9UhWKMJKYG7yD54XRpbin+bseRM
	 gqcRvJG7wqsx+k8lgVMgILWlE3VKE1t6Uu+mPRadUOcsibB/WMgxq6C8Z38wd3SVmv
	 x661c3QeoxOEym8STSd65eT3MBinyC65dYIPBjsnx4Ecfg7fQdMUaxAsVmt/3YDG4N
	 khpWh+t6eVaWg==
Message-ID: <a49dbb71-98d0-4233-a0ed-bc4157a83911@kernel.org>
Date: Wed, 10 Jun 2026 16:54:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/15] mm/slab: introduce alloc_flags and
 slab_alloc_context
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
 <DJ4QLD7TWSOU.3LEDXKMML5DMK@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <DJ4QLD7TWSOU.3LEDXKMML5DMK@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 314D218000F
X-Rspam-User: 
X-Stat-Signature: oz6nd69xw5enecgoxi8os8msuomiehji
X-HE-Tag: 1781103289-374410
X-HE-Meta: U2FsdGVkX18TQP5Jrj5Dyo+4/LOzgijfFuXcibv1gS2F9lKJGAsB+HWA9U3CVCnzyitocM2r6rCT8bs7Wjpw5l2c/oxiY1zI+JKNLbsVHs/XOgwtWCLLQ7IMA1t0Q1pwGFHoEgHcJ9v539ft6Lfd5wvzDrZGvUzUIoE07++EkkPzObWBkmBdt1tJh08qZnE0hfEUPkzrLezBTAn8o30WCKRMFAZKTiXDu0eCvSzfzOEm7lYpc8dKoA7znx1TdhkciO9vDCcCGy03pg/AKHHgwcyRxJ7WF0cywcgFt44z12rbTUeVqMZEJSBjYh7xdHES8jYqvBmyt126YHvbmfS7VNbKeCFfM1aGgS8AqtnSwd3f+nqoR2SnpKCjMKionWLB/ki5+aMoKgfCBp4Ahd1bWVBzHE3brCySfwV2cLoqLoMtyCoABSa9kDH9mfhEyqTSsOivFr/2bWlhHORoEesILeBkHY8fVjqZwJgLqg6mKdGIpI3Z5h6jL9pdsp5f8S5f1b+JUqoWQuGV244WbTdGlha0sWf4KvPQGD138QG3kCjzj8A5t1gfBaOAaVerGi+U33ZcykWxb+nifufEZhxKkfU2RvbT/na7pBgs/l2lHLLq/SSdQNqP3UNmsanKyZlfPt029nQ4+EQQ0drTWfNeeAceP0S+YAB6F2xmqdGbRaeLMHUtU1qyFGIIJyidznsctY5iaZ8eZQw4lvKQXVvW4QOI/bae8XKXt91r4PnuCM9DGGqPa+j45GBQOpSHlphuKCsL10Ov9LW21erIUCJHOwlCQvA2NIPehZfYUuYtOPTLDsXsWI/VhOlRZntv8vcv8b5Z0dbksR6Xpnly0pk+XxtTrlAtkGgcivk6/iT+WlYT00lzsPlhlbCO8YoWrCNT6TiSROuaXeeDmGRnWouvqqceIULAEsP0M3mI3IgH/OxoBFy0eMWd4dojdMY/No2+9Bd2+RV+NIwUEYn/A/3
 H30oHBh7
 rpqgZjM11VUxTO+oacSfnZmvgJfLdOtPCnGNVE0ZdxCm/NCcTFbQqnLUUGHq5+Cn+j3flXWaKKZ2AH2KzoQQql4K1LJInSqNwGlNrkYQ4L8rGkaNo3w55n+fpv6IzKHPcgaRnte+XS+/T0vgDfMaqhecUzq7GDLuwv7yfV/lB5ZIiBhlVNv1KIRfTP6GZZ6I9b6OLnHvCRe6EHfVZdUfFPEyDYLiqMJoohz7HOWNkuHGfYPzMwBHWEGspOf+hCqQKT/SCe3KdqvpgG7p53U4Dhn0CZBjLxexYSgfgvje7i5biMWXAuMjXX2M56tUVEfQfLaDClLvW3aD/WuVJ/L4AjYlfcwNFWZ3fSfOEvKkep9VU9ceMEb6eVWSab4pBecJTvGba8hV1MegZg29S/uDne36wdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 20:40, Alexei Starovoitov wrote:
> On Tue Jun 9, 2026 at 2:17 AM PDT, Vlastimil Babka (SUSE) wrote:
>> This series is based on slab/for-next. If all goes well, it would
>> hopefully go to slab/for-next soon after the 7.2 merge window, so any
>> other work can be based on it to avoid conflicts, as it touches a lot
>> parts of slab.
>>
>> Git: https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/slab_alloc_flags
> 
> Overall looks great to me.
> I would ship all patches except the last one for this merge window,
> since I don't see anything controversial or dangerous in there.

Hmm that's ambitious :)

> Especially since it touches slab so much. My slab-arena changes
> would need to adopt it and I don't want to delay the whole thing by two merge windows.
> Harry's changes would need to rebased as well.

It wouldn't be a problem if they went through the slab tree as well, and
just be applied on top of this series already in the slab tree.
In case of bpf tree there could be a shared stable branch.
So no delays by two merge windows.

> So the sooner the trees converge the better.

But yeah it would be simpler.
I can try exposing this to -next ASAP and plan to send a second PR
separately from the series already there in the second merge window week, if
no issues arise, and see if Linus is benevolent.


