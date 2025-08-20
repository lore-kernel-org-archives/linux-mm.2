Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8EACCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 19:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1148E001F; Wed, 20 Aug 2025 15:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C89F8E0010; Wed, 20 Aug 2025 15:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4058E8E001F; Wed, 20 Aug 2025 15:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 312E98E0010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:32:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91917160638
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:32:13 +0000 (UTC)
X-FDA: 83798131746.20.1D2BADA
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 684191C0007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:32:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AM8PeyYU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755718331; a=rsa-sha256;
	cv=none;
	b=rJFpvqvVQG3sINY4lxVCxSldGmbEmLLEJ393wlzcpTsJdZGuL0srIr6kiBm+RicH9Lv+t4
	vN+tlMUEvmlHpEXRyql/hl9NR+Pno09ccYJNFPq695MU5gtZbz1cpPg4T9e4Sy1iZBKVav
	xl20gwdFsqn1SngTlOZn2WEEDIe26dk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AM8PeyYU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755718331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOyuOaWYAFtKnuh/JpQ9JhhAptxR93x2Tx2hSXqcNWA=;
	b=yalawA6HTewtam7s+t+WaZ8CbekqSp+GW4+99kEHARgJ1gawajrt0km1MKkmd+9VBKkYQd
	1uXtj9lo01s+oocuyGYM7D71+vufiT2LB9agTXf3BLgJG/otLtjPVrIDSbJxz17a7JTppP
	DNiwacRM0b4LQRhCqGMlE/f54hGTHNw=
Date: Wed, 20 Aug 2025 12:31:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755718329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aOyuOaWYAFtKnuh/JpQ9JhhAptxR93x2Tx2hSXqcNWA=;
	b=AM8PeyYUIFxQSds2E1ti4q5gOD0Jo2OmKPSyT2r4q5JOB5E5vzCXxr5kEY6Onf4RejPq3n
	cNjwZ9xAAsLJahg8aYdLCnre/a9sjbjNbhyy1+bcKBxa7ADpHa7QnKcZKDMJiFOr2CkrFJ
	xdnVBIDDbLgfn/ccp94IvkMfvAPIKUA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Matyas Hurtik <matyas.hurtik@cdn77.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Daniel Sedlak <daniel.sedlak@cdn77.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, David Ahern <dsahern@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, 
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
Message-ID: <zldrraxaeff5gaffaltgzmnsgc7kvnlltubkaury3mhqlfmgwp@jinkxqagerjy>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <aJeUNqwzRuc8N08y@slm.duckdns.org>
 <gqeq3trayjsylgylrl5wdcrrp7r5yorvfxc6puzuplzfvrqwjg@j4rr5vl5dnak>
 <aJzTeyRTu_sfm-9R@slm.duckdns.org>
 <e65222c1-83f9-4d23-b9af-16db7e6e8a42@cdn77.com>
 <aKYb7_xshbtFbXjb@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aKYb7_xshbtFbXjb@slm.duckdns.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 684191C0007
X-Stat-Signature: ujw159ubwg17d9qsezui3xhhsirkzezn
X-HE-Tag: 1755718331-721257
X-HE-Meta: U2FsdGVkX18vZK//9D8dIBf5hxnQan7SNSxfLHWqgtpW1HMpP1MLpo9Z4aIsKBQQLJ/9oWwm9765vaGGRxCvYIMx/W3Pez6cB2EKNJeKmdIIzzuJlJMWooZVyswnBD2IED8SowuPnNpgrPWJa/+HE80+j8+F1SxHryOi+E9dyfPswFxzGyBRa3Qt8J1rPnMALjJdhV2OgLvmCtrXW2GmmoEWrcvUT6vI72Fat/dTzoeYom8o8QYatQDV21y8DrpyGYyPB95dOCWHVrQ+h3jpfoCyBOgSaxtNGl7MN/hJYrup0H/iq7fbBpBEeBnsU8zssIBoAGaX+RfoJHG0wTmswpkz55rgMtGkCOVWzUCloKTF2aqpH2dIZsMtBOu8I0LOovfAR08bpvdS6p0/3WueRN8LO0gQlBRhfJZXQoLqLq9XdoP391Wn1/HecVENY9jb36V++RqsK5R4TWO5G+vi/CzBnPcArGtH8zBe9bvH3KDdHwoOfHWm4gjX4SVoCa3IkPsKo81vALmNZZfe2i7Rpv7Bdxh/vor2pVMwaikW2KoVsZUENmtNwb5zLEq2yus9JS5+MhaG0MZC2w5+pic3GjKlLxDjaaMI9kdlLkxD/uIZg26hAC78rBVe92vsLoxwA66FUY4c9ssgMNOHZYf8z6bcQXmP86qLBcKe/nvs3bDtqkX3X2008Hp97NKSRyZfdKrpKLKGEVxfy1gqD5V2qC46AFXzaYYRGGy+SBnZOQHzedIBDrPwCBaIk+bRVI8TXCreevAYdVKt4wep3AwNG+9lL7NW8pezo+KDzlSZAnC9iRyIqzv6Z9qDdEPcSJmpOJU/un8rf9mLaCnq/AM6fykaXoDeWnR/N8+S7IHquGRHcjWcRRTbjvdcmhzId/1I+YmT5S/WYTLLl+r70tMCscKmsxNuQ42u8UX0x5bw2e6fwUmHpC9Yj7jiTJAL2t1opI3kNo0elymweLi0ja8
 UCisQWhD
 bFPVdX+TY7MEuJAnjc61l3rwRaz2ssk9ndGyl0KuldHdiozr7FhEnBKo9uMHyQpJ7bnysIqU0MkPAfR1BXoNTrl1hCtHrzKrpGBmhq3hm6rgWt4jyGFniFkg9R463hBocoN/toZWsW3AOIytL6kVmBgyaQcu6UtL3ycmIVLMUzKLSc4mpf6vHEySH8ESBj3RT1FRrrrdggVzJcJuQ0lrxiQ8jdNIEeZyECVd1haOmiEjc/FQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 09:03:11AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 20, 2025 at 06:51:07PM +0200, Matyas Hurtik wrote:
> ...
> > And the read side:
> >   total_duration = 0;
> >   for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
> >     total_duration += atomic_long_read(&memcg->socket_pressure_duration);
> > Would that work?
> 
> This doesn't make sense to me. Why would a child report the numbers from its
> ancestors?

I think Matyas might wanted to do a tree traversal under the given memcg
and by mistake did this upward traversal. However that will miss the
already deleted memcgs under the given memcg.

