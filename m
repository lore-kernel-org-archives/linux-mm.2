Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CABDCCD19A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305058E0067; Wed, 15 Oct 2025 14:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A52A8E0005; Wed, 15 Oct 2025 14:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06DFE8E0067; Wed, 15 Oct 2025 14:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9C068E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:13:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3293140268
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:13:56 +0000 (UTC)
X-FDA: 84001147272.11.AD28D4B
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id AEFF6140010
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:13:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NAHM1olm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552035; a=rsa-sha256;
	cv=none;
	b=eWVkD31hstYk3gN4NbAFQtvfldqkhS2xun2oW7ypklNBmmhXcYWayGjx01RG4wJ1in3NIc
	sxElq75omCXCWWFO4nJgwG4RZX+4yxPSYBQQHI62DNiE8r2eJnxgffmKpTnolOlAzo9vWw
	SpRuzZgVFyNlNnurIf75JXknscrceUw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NAHM1olm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oDsh02qbewzSlDYWVBVvoBK8rVznFkpLkjpUNC636rA=;
	b=rCsIebIiCBRT+8VqG8SCmO/EzW57/TtjKHz9bv2WRCGMxpq5XkHFsp//hui9wRChucT+B5
	nsElWyIrL5+KfIJJ32dakDYAKsOrHh0EImcrvGqvb6jP1oYRL3XyJpYDa0i6z0XBpzpoRt
	SUVduLp88cN9wMfim6pRv5SQIljob2w=
Date: Wed, 15 Oct 2025 11:13:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760552032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oDsh02qbewzSlDYWVBVvoBK8rVznFkpLkjpUNC636rA=;
	b=NAHM1olmXpEQr5qQuoLB5PapFs+mzWhfgze58nPBWRn7EX9l27GhL0IaH5KqmUBbKhZiwE
	bH2v64/OiN85fLWxfvIHZttlxpkhb9Q6+89YjtdYwtc0IucCOFKxExMArmvGIwYyD54ARO
	kR1Kw1HtnoBhW0vlA5OEc2Uq6PM7VH4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Barry Song <21cnbao@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>, 
	Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>, 
	Jonathan Corbet <corbet@lwn.net>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Simon Horman <horms@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Huacai Zhou <zhouhuacai@oppo.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network
 buffer allocation
Message-ID: <yisxjdnn73ebybkdl4tisji3d7ozmsm4se2whenidjwbn2z5kl@tvigrv54qp7z>
References: <20251013101636.69220-1-21cnbao@gmail.com>
 <aO11jqD6jgNs5h8K@casper.infradead.org>
 <CAGsJ_4x9=Be2Prbjia8-p97zAsoqjsPHkZOfXwz74Z_T=RjKAA@mail.gmail.com>
 <CANn89iJpNqZJwA0qKMNB41gKDrWBCaS+CashB9=v1omhJncGBw@mail.gmail.com>
 <CAGsJ_4xGSrfori6RvC9qYEgRhVe3bJKYfgUM6fZ0bX3cjfe74Q@mail.gmail.com>
 <CANn89iKSW-kk-h-B0f1oijwYiCWYOAO0jDrf+Z+fbOfAMJMUbA@mail.gmail.com>
 <CAGsJ_4wJHpD10ECtWJtEWHkEyP67sNxHeivkWoA5k5++BCfccA@mail.gmail.com>
 <pow5zt7dmo2wiydophoap6ntaycyjt2yrszo3ue7mg2hgnzcmv@oi3epbtyoufn>
 <CAGsJ_4w-=MNAKyNk6hvAYMbi_tdiehM4dFtz3x0-V-0kCh83PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4w-=MNAKyNk6hvAYMbi_tdiehM4dFtz3x0-V-0kCh83PQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 6bjarrod3dtfwnqyoisdmb3btnkchgt9
X-Rspamd-Queue-Id: AEFF6140010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760552034-59038
X-HE-Meta: U2FsdGVkX18dtNxBCwMyRvA97H4zS0JToL6ZpFJcOepIStAijDRxvRlZPD8TraVsPrcUtapPt1lqbr/5p5bBWBsBIcTLAHICOcwA8lCtutHoRA5VP34eE80sNdKKP9kCZvCFipYBb7A7+owEjknfcjwItW5qEmW4KjZGl+KhhAkxS7lLDOQH8W7iVy5GDZu3Nz5YixfH+h5PofkJKxFkdtxCxU++9Tv4AOxJGanTqeloofPzX4mlzdZ7QdkidNDA/pkdF+5VaLdkZW8Uvx4m46rV35+WTwfMxdG25BG7ojRE2dpIDN6fXz6mwf3doNpqnYiMwYEPp3bnx0Tl6KkCL/K2iGZZAcrJeSpWByJsiHxPJRDQFcwrgy57Od8sAjkVY8Y2XwfbEGFVW7zW8I0NamARi2umAwUCrthJOltghJ5/Bo1YW8m2v8uSHvc30Sc2w7rItWYX5gMymHHfF/rLxhzNoSlKAH4XmDORxp0jTERUCluhxYXQ87sfxhIcjm4EszRRPjT/+Fz3GCJuhDBWB8/Wya5VOTp+YpcxWaJ+BTHa1XSvDfUru61Zjvg3Bi4cNjOUsLQqDMSeNGjEUbjs7i2AWNx76oxaN4ivjPm99vJz7NMaXDSAGrpo73PwmmV4XIOU2jfsKVaw2bDR4UaszhF2uTtJYlyN7L+Wb+DPEmu1PmvfPt9yHi+qEEkODCNqdMvzhjHdf1j5vIv2s+8iQBK9dOLi/SYaogYOqobsHoJEMHfTTeN9CYoIuc9Zk7CeSp4libhhjaQbMZp7kHt1OqGgr04sshMN16wMXLBKBAee29fXws0UDltiQGna4tmLJLsvPD5ljzDbzDYCbFsR7VS1h1tE/IvpOae5tVR5zjtaY1KcAm7/Y4g/sKphickWiaBrRDxV+ffYCbR4aeJdD8Yx8H2udfezlbdMNGZpC8S2cZ+KHX675C4YzCH7VUS0YGwcRuvYvQ9XueGSbl5
 SWY8parL
 vGJNTeZ3F1rSh1jxZ94VgK5+ytBjyuFonAXmlr3NLTTJiTWJezQUu4aEPLELxvhEiAECoub8BgIyYv6jfhv2tAzvLYrVioT7/bosaVpYh/zLoyQ6ZpD3eEkaYs05wVcqcbjnyD8Wasvc77vjbMtDKOZzAnEyfnwvMbZDMbVPdKLv34kFfL5XDXXu8B3CPoc9q0KIH1cfQzKY4yhNWKXOEsiJx2zeWjBE8s2DdWYkVtHRwl7A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 04:28:17AM +0800, Barry Song wrote:
> On Tue, Oct 14, 2025 at 10:38 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > >
> > > It might be worth exploring these settings further, but I can’t quite see
> > > their connection to high-order allocations,
> >
> > I don't think there is a connection between them. Is there a reason you
> > are expecting a connection/relation between them?
> 
> Eric replied to my email about frequent high-order allocation requests,
> suggesting that I might be missing some proper configurations for these
> settings[1]. So I’m trying to understand whether these configurations affect
> the frequency of high-order allocations.

If I understand Eric correctly, those configurations do indirectly
affect the number of memory allocations and their lifetime (irrespective
of order). In one scenario, setting tcp_wmem[0] higher, allow the kernel
to allocate more memory even when the system is under memory pressure.
See tcp_wmem_schedule(). In your case it would be up to 0.5MiB per
socket.

Have you tested the configuration values suggested by Eric?

