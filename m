Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2FB2CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 20:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0378E0041; Wed, 15 Oct 2025 16:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D904B8E0005; Wed, 15 Oct 2025 16:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7F9C8E0041; Wed, 15 Oct 2025 16:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B50DB8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:17:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4696586A78
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:17:51 +0000 (UTC)
X-FDA: 84001459542.04.379E4C6
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5691C16000E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:17:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r5NurIyW;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760559469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AuLkftPTLJewXmjuYq/pzFJKexCaUt81R4Qe53LhJss=;
	b=gcFiNng5KP6zSpOLY2mXkprgZj7tcNiJxxXn+LeT/y30BdzvtTmS695Y8dnXVs1TKGJXmC
	1iKJStuW5Rybs0o3TFuPBOFsypj+lPxqD+5xk6HnklETQV1055U2Jq6lPRz+TbwgUBwaRG
	TKlT3DLqgrEKN606auLzo7pfea74GR8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r5NurIyW;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760559469; a=rsa-sha256;
	cv=none;
	b=8o7IPScHl5bcG8cwNSoT2TfgvPMxzgNxmVRQGBJjB6kyGGvsVcy7G9NV6QKy9p0/uI3n4Y
	FbShr6EKXSd+AnfHqUAN5QDRFvrLLxuR3TOk15CHApDfTlnxsTIWrJg8rSKIscC4WdoSsY
	EgfwTOwwx8VBtZKAnalGZMFUQ1+sQN4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760559467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AuLkftPTLJewXmjuYq/pzFJKexCaUt81R4Qe53LhJss=;
	b=r5NurIyW2RIqeEEVAE7BbOgH4HGJpRaAU2V0Wa3BgTTIyBwiZNQ7kIIxqvLqZQu55aTfC1
	TSKyn1N1LR6f9uybzu/QC5UZAbVVciFtrS22W8NXdlMy3kAVc0oiPzSwpZyvvEPbbHhpSY
	qBD0JvnDagVDf/nKfUd6umK087STJ4Q=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,  Daniel Sedlak
 <daniel.sedlak@cdn77.com>,  "David S. Miller" <davem@davemloft.net>,  Eric
 Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Paolo
 Abeni <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>,  Jonathan
 Corbet <corbet@lwn.net>,  Neal Cardwell <ncardwell@google.com>,  David
 Ahern <dsahern@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  Yosry Ahmed <yosry.ahmed@linux.dev>,  linux-mm@kvack.org,
  netdev@vger.kernel.org,  Johannes Weiner <hannes@cmpxchg.org>,  Michal
 Hocko <mhocko@kernel.org>,  Muchun Song <muchun.song@linux.dev>,
  cgroups@vger.kernel.org,  Tejun Heo <tj@kernel.org>,  Michal =?utf-8?Q?K?=
 =?utf-8?Q?outn=C3=BD?=
 <mkoutny@suse.com>,  Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
In-Reply-To: <CAAVpQUCNV96vOReAeVHpwbUg9XJDLRTkHmcABh9dhm=f8p5O+g@mail.gmail.com>
	(Kuniyuki Iwashima's message of "Wed, 15 Oct 2025 11:58:23 -0700")
References: <87qzvdqkyh.fsf@linux.dev>
	<13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
	<87o6qgnl9w.fsf@linux.dev>
	<tr7hsmxqqwpwconofyr2a6czorimltte5zp34sp6tasept3t4j@ij7acnr6dpjp>
	<87a5205544.fsf@linux.dev>
	<qdblzbalf3xqohvw2az3iogevzvgn3c3k64nsmyv2hsxyhw7r4@oo7yrgsume2h>
	<875xcn526v.fsf@linux.dev>
	<89618dcb-7fe3-4f15-931b-17929287c323@cdn77.com>
	<6ras4hgv32qkkbh6e6btnnwfh2xnpmoftanw4xlbfrekhskpkk@frz4uyuh64eq>
	<CAAVpQUDWKaB6jH3Ouyx35z5eUb9GKfgHS0H7ngcPEFeBdtPjRw@mail.gmail.com>
	<cfoc35cqn7sa63w6kufwvq7rs6s7xiivfbmr752h4rmur4demz@d7joq6oho6qc>
	<CAAVpQUCNV96vOReAeVHpwbUg9XJDLRTkHmcABh9dhm=f8p5O+g@mail.gmail.com>
Date: Wed, 15 Oct 2025 13:17:36 -0700
Message-ID: <87a51rapi7.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9tkqquwwo3fg6jqjt837hwkp4u54f7t9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5691C16000E
X-HE-Tag: 1760559469-546530
X-HE-Meta: U2FsdGVkX1+DhYjRjUqQGcQ7wbmK7ZUV+aps9y4/ICYYYqpAu3Il7Yy9gkvBS2pU4iuqVGMdaaiwgDtp/O1CpjFjsNg6QnfUgHeiGWXKpTfIZkcxC9mPdj+WyzqxuCwCJdJhvGbnXonRE/n91d5/Vs5DqOdEzBGGLvg2tv48DEMwz7qDzZxwXlTlbKnx4sszCLLVrhw2mBHoKxPL4lXnzTygkWVf9O6H1a48bbSvEg6WMjqFI6xAGHg0xElRGFAAzor7sYMpfUYn7S95IGl4zbj2BKH0FlyLl9YwgEwwpEihI2MsSWoniTq5l9ZezPd+VLpxQkq148kLVdWxUPnDOH1zG303HFY+XNSQDKuZgsqj99UAmQrN2e2srXoIJVmkkCtFs0SVFJVm0XHey7MvOEVX4f8fTuXN9gNJGv2vshbrkpr++uc2BmQvaxSNdgfExMnCUYgdHSfx9fAQ71L1SpJh4ZcEosyarl2SoOLh4JanBxDezRVMXKHw1LCG2MYr1kTZEqRJZVqJiiahkdDtG4Dcjp0rEPfLFXy//odisvdO3SDqWNXHLgSBFupRPJN/5BVnFCc3PEdrSFZSQ/r5vzjqrjJP6AztTes24gLkB3/JLp1jtUPWpqK3TJlOKfcyHtbFwQn2JvVFRlwkwSRguC9JIHmiiJ2egFFoXv1mvviUJ7kGP6PqX/UnI4vXgP9CTmxeUh/0UA3v3x4iGnsMWiSx01ViJXLt3g+UHQxx7xL7GV/3NCPH+eYSpotMNYchzbFh1b3osABhDkGD8TJsRQ3pk9MYqE+03SgEn9PxAuOHKlU0643EKSDZVMA9We8X2djhhJFON84ff+1uXffITCYsxdpisX+e0ufEeUrr70MwYDePFTg+xlYIUPq3URyzNaa8C6fggGTD4xCc2j16kVLcpMiFRd1j62SfYtd6CPqaTyy23e6arHf0QvShrik7wzBHKrd/ZQemi/RtfMH
 wO8x9uxh
 Y6YLEmtbKlD4VfvnRnrhGoy8KrjlFxCuS8FISnyyYYkS+bW7PdCjzq72XouwIS5iHq7xwBwo3fLy+emD8+CbUaLgmLY5bs5blhi+YoMSYyYwtYB5tDjkkyXrjKGsE/O18BLB7p37CCD7zlr7S+D3NAIHdbdgjjKDSybXZ+74FD3EkLziihLcWqA2PcBjwLYh4KiSEhpstqI1BvF2cyzP4Ew95zr5ZkhEJ/j9tPmiH7RqD1FU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kuniyuki Iwashima <kuniyu@google.com> writes:

> On Wed, Oct 15, 2025 at 11:39=E2=80=AFAM Shakeel Butt <shakeel.butt@linux=
.dev> wrote:
>>
>> On Wed, Oct 15, 2025 at 11:21:17AM -0700, Kuniyuki Iwashima wrote:
>> > On Tue, Oct 14, 2025 at 1:33=E2=80=AFPM Shakeel Butt <shakeel.butt@lin=
ux.dev> wrote:
>> > >
>> > > On Mon, Oct 13, 2025 at 04:30:53PM +0200, Daniel Sedlak wrote:
>> > > [...]
>> > > > > > > > How about we track the actions taken by the callers of
>> > > > > > > > mem_cgroup_sk_under_memory_pressure()? Basically if networ=
k stack
>> > > > > > > > reduces the buffer size or whatever the other actions it m=
ay take when
>> > > > > > > > mem_cgroup_sk_under_memory_pressure() returns, tracking th=
ose actions
>> > > > > > > > is what I think is needed here, at least for the debugging=
 use-case.
>> > > >
>> > > > I am not against it, but I feel that conveying those tracked actio=
ns (or how
>> > > > to represent them) to the user will be much harder. Are there alre=
ady
>> > > > existing APIs to push this information to the user?
>> > > >
>> > >
>> > > I discussed with Wei Wang and she suggested we should start tracking=
 the
>> > > calls to tcp_adjust_rcv_ssthresh() first. So, something like the
>> > > following. I would like feedback frm networking folks as well:
>> >
>> > I think we could simply put memcg_memory_event() in
>> > mem_cgroup_sk_under_memory_pressure() when it returns
>> > true.
>> >
>> > Other than tcp_adjust_rcv_ssthresh(), if tcp_under_memory_pressure()
>> > returns true, it indicates something bad will happen, failure to expand
>> > rcvbuf and sndbuf, need to prune out-of-order queue more aggressively,
>> > FIN deferred to a retransmitted packet.
>> >
>> > Also, we could cover mptcp and sctp too.
>> >
>>
>> I wanted to start simple and focus on one specific action but I am open
>> to other actins as well. Do we want a generic network throttled metric
>> or do we want different metric for different action? At the moment I
>> think for memcg, a single metric would be sufficient and then we can
>> have tracepoints for more fine grained debugging.
>
> I agree that a single metric would be enough if it can signal
> something bad is happening as a first step, then we can take
> further action with tracepoint, bpftrace, whatever.

+1 to a single metric

