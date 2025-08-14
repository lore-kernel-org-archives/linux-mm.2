Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C47CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1CD09001B6; Thu, 14 Aug 2025 13:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7A6900172; Thu, 14 Aug 2025 13:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C968D9001B6; Thu, 14 Aug 2025 13:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AD9EF900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:44:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35B8DB94DE
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:44:08 +0000 (UTC)
X-FDA: 83776086576.20.6189E51
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id 23451A000F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:44:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O3Hvbk99;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755193446; a=rsa-sha256;
	cv=none;
	b=Y6eZtdwklE8y4pFRawdh84l2vkY8OLNuLZ5Yvl0TzCVCnENxT9Ae6ZAXJc2qeya2rATPXR
	u3lASxCoSKXs1f7mlJcsYdJLBBwObNiNi8gb+CcNUwrcRAeidz+EymzWnoslNQQd0J8Sze
	3ZJEz7uyWL4YMwdQJcDbXr75TUKMTos=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O3Hvbk99;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755193446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPqZ11vpcoRklz9QYq4kh+2Xloc1crac2d4cWurYTAw=;
	b=yb6a8Ux2N9weDAmmosw2rx7wirz3GR5amt4l9IG/Xn0595+hG7tOKE7Gq6Uemyid6P6ZoN
	0h+u4zDeuI+OsagNmfWnY7N6cLnqJ9mhh5cslPJcq+x02tHN106BdE0ac/ajufYTOSC4bb
	3EvPEBb96IZpEN3pYq8+C3IEtiSmiNY=
Date: Thu, 14 Aug 2025 10:43:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755193443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPqZ11vpcoRklz9QYq4kh+2Xloc1crac2d4cWurYTAw=;
	b=O3Hvbk99j9KPxhil/aCjUAoy8Wol7HQP4nDBpa3lCDAejGlYIDhslkt4pnJIi5IGTLLrdL
	r/FzL5iuW4xHMETt0+kz+unxWqQZHb55cbmw7dZMuOK9O+66fAyq9rqb9Y9oz+IQcMOiY6
	59/FNZI76uv8vm4442ykA6BSbdL7z5w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matyas Hurtik <matyas.hurtik@cdn77.com>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
Message-ID: <heh23oulcubeuqssykmb6i6uh3vazzpmcymqhi7kif4i26waij@pttojulkfgzk>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
 <CAAVpQUBrNTFw34Kkh=b2bpa8aKd4XSnZUa6a18zkMjVrBqNHWw@mail.gmail.com>
 <nju55eqv56g6gkmxuavc2z2pcr26qhpmgrt76jt5dte5g4trxs@tjxld2iwdc5c>
 <CAAVpQUCCg-7kvzMeSSsKp3+Fu8pvvE5U-H5wkt=xMryNmnF5CA@mail.gmail.com>
 <chb7znbpkbsf7pftnzdzkum63gt7cajft2lqiqqfx7zol3ftre@7cdg4czr5k4j>
 <0f6a8c37-95e0-4009-a13b-99ce0e25ea47@cdn77.com>
 <qsncixzj7s7jd7f3l2erjjs7cx3fanmlbkh4auaapsvon45rx3@62o2nqwrb43e>
 <4937aca8-8ebb-47d5-986f-7bb27ddbdaba@cdn77.com>
 <okedwjaepuw2b55eki6zyn6l3ngstmml2amoebyvc4orzsxqjs@45tbzonckct5>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <okedwjaepuw2b55eki6zyn6l3ngstmml2amoebyvc4orzsxqjs@45tbzonckct5>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 23451A000F
X-Stat-Signature: opma1j5wefdjrngcdg1395ysag46grw6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755193445-587995
X-HE-Meta: U2FsdGVkX18u6EPhFg+hat6+kFCsOCrZ5VZrL1/ZySRyi8CIhGTf8pl7m8kt/07ESyDwCu6LQcvLwRgm0CFIbiSoVvrOoE2nw7NEmA/ze2/WcBUq7aQzsdNDYZPo/phx4qpxXFj+9pFXTgBG1cqIoycKvGjOsFWITOrSKTqhqqUdt4GU+mwwDcvyqvfCMsFfJjqZGfvHOPHQVf3GUF/WuuvU/ohAEBIxhngeT/2yboOnLoyGINsngqydWTpKYf7k15p5aYth1KXRxAYlSjJ23P1VNFRQHbUQSAGOOjtbFmpDnbOqEGybK4PEdNNO81YL3s/224L9D/noCDW21h8FTRqrXKKkgdc7ueQKjFOwyi3XAQSuTET9rNAJZqC/RnIbguQTyHjg7Ojd8YuspWwvzeu5A7XdT1vDg9oa9ENf52WJ5jwQDoOQRNUMGaV8yr9HM72GU8K8gddBSJpuLP+bLgGzLfn4NBvfkhe3HBHh0KQqTQNFKHaMDRz3sSsLKcp+8FhKpmH26XRKYHm/+qqNxBBAEAe0nAsv7cwBRVS1SIt6xwfXkeh0lFWRJhEEGhW7VyyTpTkhBQEZzjtKDHyIoRFslrRYMetXBQ4adT7eOiqmv5wBBVm1AnJvShbEDo8kD9WXNt+V41jMREAnmDEZ1Lya7v/UJ8XWqVorb5VTPOtEgXtG2Dd4zH+26fWWMuwk7/tJWw27cue8TnIm1Lkj0MQVavUat7zHE3Z4RkpYwWSIXg87uMRpTFIvj4IGLVShqojb0ikHfOVBKXDdm3vh0ybNqGz9WvvJEP9c3a20JaywPqYdip+5oR8Ro61Xsl1s9D0vFzCQBYOK8PGc8tv4r8L3ZWQ4e1fUPJJfoQeGJNjV80ZfutfZv8JtCjDuTTTkn5y2FQ5AklUNEO2r9xSOsRkbhs7l5bDyFAp3HUiqKX+/hK9/rIbU7lZiAUAXqmXKONbnDHcR9VqKu2pAK8m
 2zZKdDCA
 SHhSvRhkNU7oEFXf5HB1GmQnkOjhEWmJ1gQSJs8i5o5GbedpdCZjfNqOHuNpaU9IxLJEmzdmBZ92TkH+hIgKY7rDuakY5+TIPryZLVcOFvLVxOCG2hQAz2ixP4l6IrnbRap1JxL2Fx6kVTn6iHRGTeICvL/5tnkd4paHsALjCjxy7BFQuKW6mVtgCY4HY/UAd+xpnq8pxiRWkadfWC/dxf9tk+AkOC1jv1ItG1s7aV0rNllo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 10:31:39AM -0700, Shakeel Butt wrote:
> On Thu, Aug 14, 2025 at 06:27:22PM +0200, Matyas Hurtik wrote:
> > On 8/7/25 10:52 PM, Shakeel Butt wrote:
> > 
> > > We definitely don't need a global lock. For memcg->net_pressure_lock, we
> > > need to be very clear why we need this lock. Basically we are doing RMW
> > > on memcg->socket_pressure and we want known 'consistently' how much
> > > further we are pushing memcg->socket_pressure. In other words the
> > > consistent value of diff. The lock is one way to get that consistent
> > > diff. We can also play some atomic ops trick to get the consistent value
> > > without lock but I don't think that complexity is worth it.
> > 
> > Hello,
> > 
> > 
> > I tried implementing the second option, making the diff consistent using
> > atomics.
> > Would something like this work?
> > 
> > if (level > VMPRESSURE_LOW) {
> >   unsigned long new_socket_pressure;
> >   unsigned long old_socket_pressure;
> >   unsigned long duration_to_add;
> >   /*
> >     * Let the socket buffer allocator know that
> >     * we are having trouble reclaiming LRU pages.
> >     *
> >     * For hysteresis keep the pressure state
> >     * asserted for a second in which subsequent
> >     * pressure events can occur.
> >     */
> >   new_socket_pressure = jiffies + HZ;
> 
> Add an if condition here if old_socket_pressure is already equal to
> the new_socket_pressure and skip all of the following.
> 
> >   old_socket_pressure = atomic_long_xchg(
> >     &memcg->socket_pressure, new_socket_pressure);
> > 
> >   duration_to_add = jiffies_to_usecs(

One more point, this jiffies_to_usecs() can be done at the read side
i.e. keep socket_pressure_duration in jiffies.

Also TJ suggested to expose this new stat in memory.stat. That will be
easy by just adding seq_buf_printf() at the end of memcg_stat_format().


