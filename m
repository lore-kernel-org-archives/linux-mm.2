Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87D3DCCF9E3
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 00:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0608E002A; Fri,  7 Nov 2025 19:09:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50048E0006; Fri,  7 Nov 2025 19:09:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66748E002A; Fri,  7 Nov 2025 19:09:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C285E8E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 19:09:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83EC813B877
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 00:09:41 +0000 (UTC)
X-FDA: 84085506162.04.2D924BB
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 87823160010
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 00:09:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rKOWtDUy;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762560579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBJT4/z1hj67jfdfBO/RFvyIJnHDFcqSunY1R03npJU=;
	b=Z+vLmDDp1G/8+O7BSurSDlTS+on87Khrfk8Cc58tbbwG/w5N4dsFty6gQ4TN3IZxByi3sd
	sRqtHDNniJ2JTjyOxr/v8ENjHp4tEbVC1OIMM+uSwIhRz0joUosWPb5HRVAXQJfdiG++y3
	KEvx5EO8kR0B3tb5NU70wASWXdFQS4U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762560579; a=rsa-sha256;
	cv=none;
	b=MeNlISrZ6fX8sESxJaQbwUJbeVtgqhRRpx3bDnsuPlm+aOQP+ZGBZ9MqRMtbu5ojtbB8T3
	eCAFWTRVhTgghjgGYcjgF2No8Jogv03wN7y0udceoDiX9/CjAgQr/O9FhdFIaO5eMZEREr
	6BlPn8LlFZ1LVOjoAMYW+iIOCeFUGeE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rKOWtDUy;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 7 Nov 2025 16:09:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762560577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zBJT4/z1hj67jfdfBO/RFvyIJnHDFcqSunY1R03npJU=;
	b=rKOWtDUyluopFvaWjD5VtJGiw3uuJLeS1AQdApXn0Ysp7Luz9ois3pFwBBZdFco5dngJvf
	2b5L53OquL+RROkxnHgq05LTzGedjVJbLWtXE3+/olsb/3vEJ3D56ZOUxWWMc7K07iiga7
	pCCV5h2HAIeHEIH1g53CpQ/NGpNZXHA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: Add retry logic for cgroups with
 memory.low in kswapd
Message-ID: <v56ql5ptxyx4x2j7nffznhs3osjghkoj3dlkfbpohotuof3yiv@gf74er4pf34v>
References: <20251014081850.65379-1-jiayuan.chen@linux.dev>
 <aO4Y35l12Cav-xr4@tiehlicka>
 <a6cd4eb712f3b9f8898e9a2e511b397e8dc397fc@linux.dev>
 <aPEGDwiA_LhuLZmX@tiehlicka>
 <46df65477e0580d350e6e14fea5e68aee6a2832b@linux.dev>
 <aPE84XfToVH4eAbs@tiehlicka>
 <db4d9e73e6a70033da561ed88aef32c1ebe411dd@linux.dev>
 <aQ3yhmsT2NHeNwLi@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aQ3yhmsT2NHeNwLi@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 87823160010
X-Stat-Signature: gp93f8xisccs6gxuhg9wxkqgdaoqcxnc
X-HE-Tag: 1762560579-295847
X-HE-Meta: U2FsdGVkX197e5lhh1GJFjC9CtODhIhTA153/NUyUv1Z9931OwhEFyBwIJdhNUpo/+HjRK+Z7zab2D6Hka5v9QKOLCMWddPwne6thTrpCUFBFTKKYCUCW2ma03ITGbYfGk5AX7VCkGnoaNir4JSr9gay/D4dFZBNB+PAp4VdWpe4Ahg7T2oCr+RQL2V4XR0aHfgMcDd81l9jBqPopigcVh1Wc3sPAF0zVZDQLLdk97VJId4+K/My3wErcKiAHzVkQ4rSllAMW8FQ7aKaZhGZuCO+uf1nNWTNZ/4mDPDMlM/hETyM/oVhrickrz8Y6KlvoeUS/+jBs/EyT8nTU7thJuBmdaMWUbqhPHRlGWSaWkzEU6aBg76rkTdRIj3eKlQ/Sw1XZ18rYMmwHzWsDjkmK39hl6FyyjuhOcpXxgR+M7TPVhuxRipfshWjR9pqkjEQSuRB3ZegTHchTW7i6N/BrxfwPZDlOu8CsQXBw1Bj0qYZ3LQeAndLgsuoWAUsoSA7rj7csim0Ikrzktqr+U+Lz78fUpuGBTi+laV8zxWsAfylyx86m0C4zJMQV+S32g2xGKcXMtG3qzKADKn4Qlkfobv6B93wJ6JX2EWVYDBTAjjiuBk/tZvMUnGtv+Y+6G4yim9GCx3183ugtsfRUHRIEPr6qHQ9TxiHy0mdy6r+DhujTCeDYao6grQ3BZ/gIJ8AFnLQ87kkDxb01aFHbFHflyt3T/r1h3GJC6clCeziA84/3vNppx1aEdAYOuv8nc3EMPWFuEKjC3toqBPN3EFPpej5h6SBgaTQ3IdStKAIqufjhqDWS1CXhntBIjxY6IsbSLeQJ7uhz+Scw48Iffjzise/BKQ/OC99fmeINsNOdgxSKrRAefPzWKnzxgKhL6rZC1ajAXVf7y4O7/ZmlyKtrLw2zeSJWMPCBe6uUCA5XdEMhetKV+TNLDFiJyXlPBilEm1vnKG/AEA8lPy0gMf
 xB5Eh8B3
 IjDKzznOqVjXXXkqwT72goekNzl2jaCYzIO2HmG8LGWUCSNs0pnxXZd/Z/hryVCKZshPSJwPIac9fU7ZfJs1pU7PUlVz8+ls8O38X8jwfSFwq4Rw79kgfsJyMOhjoS9BdF/JNeBu+rJh6BUM4kghZXFh5j5E2SohTL7yJmOeeChPWIQKByr7lC4oxoElF1rrlrond7rJez/A6lj1b5ycqO1d+Qwx0emwnzl5REAf3MYgappKZyd+VAtBgswHEhZ93gPDo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 02:22:14PM +0100, Michal Hocko wrote:
> Sorry for late reply.
> 
> On Mon 20-10-25 10:11:23, Jiayuan Chen wrote:
> [...]
> > To provide more context about our specific setup:
> > 
> > 1. The memory.low values set on host pods are actually quite large,
> >    some pods are set to 10GB, others to 20GB, etc.
> > 2. Since most pods have memory limits configured, each time kswapd
> >    is woken up, if a pod's memory usage hasn't exceeded its own
> >    memory.low, its memory won't be reclaimed.
> > 3. When applications start up, rapidly consume memory, or experience
> >    network traffic bursts, the kernel reaches steal_suitable_fallback(),
> >    which sets watermark_boost and subsequently wakes kswapd.
> > 4. In the core logic of kswapd thread (balance_pgdat()), when reclaim is
> >    triggered by watermark_boost, the maximum priority is 10. Higher priority
> >    values mean less aggressive LRU scanning, which can result in no pages
> >    being reclaimed during a single scan cycle:
> > 
> > if (nr_boost_reclaim && sc.priority == DEF_PRIORITY - 2)
> >     raise_priority = false;
> > 
> > 5. This eventually causes pgdat->kswapd_failures to continuously accumulate,
> >    exceeding MAX_RECLAIM_RETRIES, and consequently kswapd stops working.
> >    At this point, the system's available memory is still significantly above
> >    the high watermark—it's inappropriate for kswapd to stop under these
> >    conditions.
> > 
> > The final observable issue is that a brief period of rapid memory allocation
> > causes kswapd to stop running, ultimately triggering direct reclaim and
> > making the applications unresponsive.
> 
> This to me sounds like something to be addressed in the watermark
> boosting code. I do not think we should be breaching low limit for that
> (opportunistic) reclaim.

Jiayuan already posted v2 with different approach. We can move the
discussion there.

http://lore.kernel.org/20251024022711.382238-1-jiayuan.chen@linux.dev

