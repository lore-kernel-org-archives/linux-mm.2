Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BE9CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 16:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8AA58E0027; Sat, 16 Aug 2025 12:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60E38E000A; Sat, 16 Aug 2025 12:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9DD08E0027; Sat, 16 Aug 2025 12:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B36288E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 12:41:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55A6B59146
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 16:41:39 +0000 (UTC)
X-FDA: 83783186718.27.61D3FBF
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf28.hostedemail.com (Postfix) with ESMTP id 24FEAC0008
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 16:41:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755362497; a=rsa-sha256;
	cv=none;
	b=D2hWiV8UFMEFm9aRiDdiY4gMpNAGM1mkztsajJbTpt6H/n7ae0NyiZvQLwfbmx0h9lRjbO
	EbNe1b5tx1insP35aVQeaMUVGdmKUBeqLE6A1988kaYoHeCxNX1XT/QBCuCD2GgtJLPE43
	FWLDUjd8c0Ghqof5VUu0ap4U5DXC87g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755362497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZkzBrgDGw/3dggcsgZvVLVUB+THoethtutrUhMkk8TQ=;
	b=T+slXArbKtALmEsp67JLyZM2O++64qg97WZVM9N9x0eHErc/B44XdHTWENUfaTZbSP+y80
	DX0GpzXbRxYHQ58ikyO+qp9fpGTdmaQY+SoWpyOP5hQIxQAe72SMGE+e5rp47DoWxuRBC/
	UIVKz6gemSgwaWGUrjBrWNxBf5f+I38=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 17 Aug 2025 01:41:34 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 17 Aug 2025 01:41:34 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, chrisl@kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <aKC0vrr0vIdRV/Ob@yjaykim-PowerEdge-T330>
References: <20250716202006.3640584-1-youngjun.park@lge.com>
 <20250716202006.3640584-2-youngjun.park@lge.com>
 <jrkh2jy2pkoxgsxgsstpmijyhbzzyige6ubltvmvwl6fwkp3s7@kzc24pj2tcko>
 <aH+apAbBCmkMGPlO@yjaykim-PowerEdge-T330>
 <aH/baxIgrBI3Z1Hl@yjaykim-PowerEdge-T330>
 <uyxkdmnmvjipxuf7gagu2okw7afvzlclomfmc6wb6tygc3mhv6@736m7xs6gn5q>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <uyxkdmnmvjipxuf7gagu2okw7afvzlclomfmc6wb6tygc3mhv6@736m7xs6gn5q>
X-Rspamd-Queue-Id: 24FEAC0008
X-Stat-Signature: d4pacya3hp4kwun3dhuj1f95njhzbpda
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755362496-789565
X-HE-Meta: U2FsdGVkX1+UoGBL8tE/LCS/Lgb94VyvJaWe656NSlpT3l3Q+oYcW3rGuZFMJq0xrMBukqeBpAVGZsYo+wJAtjK/e/Mb8a8aNauUN7W+cb7kQM7PKg5Ujiu/9IUYiH/r4k6Gm3YQFMe8+OBqfQYSn0SscL3FavV48X9lQek780E6ddWnGukdTy5VlwF/tN3bMywT0Iltog+UeGwZpjYu8gz83Jf+EardZcQoL2cC8IDypoTCnUmOvfwd/K+fL9rE3C/CRhwbqIYrWMsuMLDB7bsPF9E9OdLSsaSLMbdk6Cy2EAmV8Z3pp4mVMAa3evFHiSXMTZFXfrFUdikGvYR760SGoBWx+5OUAWGJ+aD83q+UpQmvxzrggOnQqnhNaPZpzgu8fxWqj4VCr9uEQMy5D8u5RFWrcGn8eomECCK8vUlDBLuRjCk0LrvtFgvQ6HdnDUsrhAtnOCWp1grtsKvXz6cDs7sMTmBidOTzJjr7qOSOnHqs+K1jPtF7ok+qEiXHNC0Emz5DM3B8JTEiKWBsjrHcW3ybdzUfc38cHBYs0/7GEIIG4yIIWFpZDMB2m4ybcPn8oGSrzGE46x3qJ3cY35REAMZheFEVfLWVL8wWAy06llBWNS1kpAK1j3jNbARq4wDHD7c0GZg3hUlGNqrLwF3pQcD3Wljtyxd5wJWfYBzWNDvDisjaPEBygOTOUf57wn5fC4OP+GL+PDeEnYvBaLP2vIfBFwluruu7eqPIj2uufyv678j2L+VlG6oy42w47Zi+lclWg6DoZNyKxgzkRe7Q2+vZiHw8QnedFJoORxjRfwbVIyrj5kSWJapgE1gfCaEiMTfhmo6OzsMX2pIQ6AscyF4tt6W/7cbABVlQJ4pRps0WjNt5Kw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 04:03:36PM +0200, Michal Koutný wrote:
> On Wed, Jul 23, 2025 at 03:41:47AM +0900, YoungJun Park <youngjun.park@lge.com> wrote:

> Let me share my mental model in order to help forming the design.

First of all, thank you very much for your detailed reply. As Friday was a
public holiday in Korea and I had some personal commitments over the weekend,
I only got to check your email late — I hope you can kindly excuse the delayed
response.

For the points that require deeper consideration, I will provide detailed
answers later. For now, let me share some quick feedback on the parts I can
respond to right away.

> I find these per-cgroup swap priorities similar to cpuset -- instead of
> having a configured cpumask (bitmask) for each cgroup, you have
> weight-mask for individual swap devices (or distribution over the
> devices, I hope it's not too big deviation from priority ranking).
> Then you have the hierarchy, so you need a method how to combine
> child+parent masks (or global/root) to obtain effective weight-mask (and
> effective ranking) for each cgroup.
> 
> Furthermore, there's the NUMA autobinding which adds another weight-mask
> to the game but this time it's not configured but it depends on "who is
> asking". (Tasks running on node N would have autobind shifted towards
> devices associated to node N. Is that how autobinding works?)

Yes, your description indeed captures the core concept of how autobinding
works.
 
> From the hierarchy point of view, you have to compound weight-masks in
> top-down preference (so that higher cgroups can override lower) and
> autobind weight-mask that is only conceivable at the very bottom
> (not a cgroup but depending on the task's NUMA placement).
> 
> There I see conflict between the ends a tad. I think the attempted
> reconciliation was to allow emptiness of a single slot in the
> weight-mask but it may not be practical for the compounding (that's why
> you came up with the four variants). So another option would be to allow
> whole weight-mask being empty (or uniform) so that it'd be identity in
> the compounding operation.
> The conflict exists also in the current non-percg priorities -- there
> are the global priorities and autobind priorities. IIUC, the global
> level either defines a weight (user prio) or it is empty (defer to NUMA
> autobinding).
> 
> [I leveled rankings and weight-masks of devices but I left a loophole of
> how the empty slots in the latter would be converted to (and from)
> rankings. This e-mail is already too long.]

Yes. A single slot emptiness is enemy..
The problem arises from two aspects: (1) allowing per-device priorities
inherently leads to the possibility of single-slot emptiness, and (2)
depending on swapon configuration, empty slots may be inevitable. That’s
why the compounding rules ended up allowing this complexity. I’ll review
your suggestions carefully and share soon how we might simplify this
direction.

> 
> An very different alternative that comes to my mind together with
> autobinding and leveraging that to your use case:
> - define virtual NUMA nodes [1],
> - associate separate swap devices to those nodes,
> - utilize task (or actual (mem)cpuset) affinity to those virtual NUMA
>   nodes based on each process's swap requirements,
> - NUMA autobinding would then yield the device constraints you sought.

Creative. I have understood the overall concept for now.

Thank you as always for your valuable insights.

Best regards,  
YoungJun

