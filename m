Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60A2CCCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 22:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8B9D8E0089; Mon, 13 Oct 2025 18:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3CCE8E0024; Mon, 13 Oct 2025 18:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78798E0089; Mon, 13 Oct 2025 18:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 95E0D8E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 18:47:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D392C05DD
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:47:09 +0000 (UTC)
X-FDA: 83994578178.02.D4995A7
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf13.hostedemail.com (Postfix) with ESMTP id 61E4B2000B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:47:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I3e+5SHF;
	spf=pass (imf13.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760395627; a=rsa-sha256;
	cv=none;
	b=MPG6V2wL23XuSjXZarpiL7amrqSx/Sm7RuYZAUoiKh2056h5oelkgoLPQVQUQ2LGe/mdEy
	lXhMOXWYxCRdB1Mdn/hoGDpdfT6V4U1AhmgvuG9O5tvzoEpORHWAfksrt8/IuFc4tmeTY7
	VWMdTE+Q+veHeusdXYIluGHlbZTWGsI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I3e+5SHF;
	spf=pass (imf13.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760395627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WvVrgqE5UCoUQhWcYn4T+nWyANRYtASSr9LcpzAHUuA=;
	b=0Ie/WDO9htTvfHXehspiYBRn0DpH8KzM7CLr42VxnaBLdV/htECHtf7ClgwsWmokaQtwI0
	lwYtUxoUpuXLnAxxP5OdIwTvUtmyfju3LGKAc/6cw4WRrjiQQz1uH8mp79a/D/UUjv3Keq
	aqyt8Pj/m22rydss/2HcfriAcfmjf+M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760395625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WvVrgqE5UCoUQhWcYn4T+nWyANRYtASSr9LcpzAHUuA=;
	b=I3e+5SHFTgUvTqFeG/5a1PCCaKzBtf7GtUS8bYY/Hk6NPHCv8U3BRHMHvuPl3cD9tHs/Dq
	tnESMYYeNWKpp7T+21L/NyVh0PIS0d7053jHpSE7IK9gPgA8kyZyI/PRHQxAxl84dUnqtZ
	KrS4TcSHu1uRIcx43kjX79znlQhPiDo=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Barry Song <21cnbao@gmail.com>,  netdev@vger.kernel.org,
  linux-mm@kvack.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Barry Song <v-songbaohua@oppo.com>,
  Jonathan Corbet <corbet@lwn.net>,  Eric Dumazet <edumazet@google.com>,
  Kuniyuki Iwashima <kuniyu@google.com>,  Paolo Abeni <pabeni@redhat.com>,
  Willem de Bruijn <willemb@google.com>,  "David S. Miller"
 <davem@davemloft.net>,  Jakub Kicinski <kuba@kernel.org>,  Simon Horman
 <horms@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@suse.com>,  Brendan Jackman <jackmanb@google.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Zi Yan <ziy@nvidia.com>,  Yunsheng Lin
 <linyunsheng@huawei.com>,  Huacai Zhou <zhouhuacai@oppo.com>,  Alexei
 Starovoitov <alexei.starovoitov@gmail.com>,  Harry Yoo
 <harry.yoo@oracle.com>,  David Hildenbrand <david@redhat.com>,  Matthew
 Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network
 buffer allocation
In-Reply-To: <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz> (Vlastimil Babka's
	message of "Mon, 13 Oct 2025 20:30:13 +0200")
References: <20251013101636.69220-1-21cnbao@gmail.com>
	<927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
Date: Mon, 13 Oct 2025 15:46:54 -0700
Message-ID: <877bwyxvvl.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: ynbxyyoznojwwkbmskdduurd3h36eira
X-Rspamd-Queue-Id: 61E4B2000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1760395627-786134
X-HE-Meta: U2FsdGVkX18wLoQlpFV50K1NOeIf8XVisrZSMjSsJC7cRFIsl+6pcRfWWVUT2dLEOWWpOSZhDNJ6W2B7fwzbBRAEAwVWyBowxHSuQZlxSX5QITXruZRA+0YnotHFy0DzuBG7iDRNSfqi3WHlscOjd2x7lf8ANR3Xv06SaabzpfzpSxLJ1+1iKHDbYtzL80mIdXZjVpbciwQTOTt9+TwsP4YUKymWWfEfDQQP3qvgHzhAeM1mufEtQgB3Nbwcxb/MyFk+rfq81ubtzXerLZtchtemIZWfcWfxNAXv2PtIl2mZ3midcgBIzA+F+ngZ86/Rden9t4kU0/CiU1ZaoZVU/BxrC2dAolqqN33G/xP25lEVQ8L1SjbOxuvMcGma/umt7rzlgr4feh6C2ayfdJLkcx9KVR+zBZvoT+CmVr39QQS4KyriwdCSgYjbtplZkS7F+JpwZfstWI/R5fINRVKQQOjwDj1UuN2OQKh5eYxsqdww1dqw362QxGsMQL7rLVITCy5f6qeiKE5cRcDitnsYR9E1TZXs1N4bTuvSqMIbbPDjDmJR4v/imu4wDw9SorOwnAoILANs/NjUfQKeSu81qmsKNWNBO0ArGsfDLkOa2izG0mtNN2UdsMmG8gqArpFBNKM4Lbn3XmORPtgMAwNFCM5pKEKkmrvNfnAcAXHfMjDMPCGaBTLK2mZtBi/8j7/yq7YYSv07gXRNmOW+7FB++zsJL/j8NtOk8e3PdKP5RyKX+4sDO0LCvJCdGmDt36HMIJHZHaaGijWousuJjzEkFo0Ug4gjIg6N2k6b88B18vjNG0KiG/+WCtwTAh7N5ohSDt/tPEIAtTWyLGx7U5VOD+vmiPEiDjKP+nUu21WN3ePW7nrx7HWz1gWc0G/wfrhEYQmcHl7iI/tTly2hbb582kfeziwafAwz/Rm/1QAYdrfQiF9ytvcdnpB1MzADQtoFjVFZ5vuK/qL6KwdMVHc
 sKEq4JAv
 YzFugj7bXZ282vKjhjwofNbfWPeTcKJHBtOaYx5wo901Hmow0ftJ9ineTw/ng2jk/w+iRv2G9ut1MvZjXqEdxHTJ0xeC/9S64UlOn/rQlBdBNON3IFHUGMgm6wCCSo/UtioYwXJ4F1KTSt0vL45b6+0Kp/suB3uBer5W4SkaNYC3EeojcuROc89LCba2q4aEu74JOI/hY3y6MDu3ZbLbB72Nl167MxfMdmmxZau+JqD18bFb29JhbcyNERcveZ9CxJMl8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vlastimil Babka <vbabka@suse.cz> writes:

> On 10/13/25 12:16, Barry Song wrote:
>> From: Barry Song <v-songbaohua@oppo.com>
>> 
>> On phones, we have observed significant phone heating when running apps
>> with high network bandwidth. This is caused by the network stack frequently
>> waking kswapd for order-3 allocations. As a result, memory reclamation becomes
>> constantly active, even though plenty of memory is still available for network
>> allocations which can fall back to order-0.
>> 
>> Commit ce27ec60648d ("net: add high_order_alloc_disable sysctl/static key")
>> introduced high_order_alloc_disable for the transmit (TX) path
>> (skb_page_frag_refill()) to mitigate some memory reclamation issues,
>> allowing the TX path to fall back to order-0 immediately, while leaving the
>> receive (RX) path (__page_frag_cache_refill()) unaffected. Users are
>> generally unaware of the sysctl and cannot easily adjust it for specific use
>> cases. Enabling high_order_alloc_disable also completely disables the
>> benefit of order-3 allocations. Additionally, the sysctl does not apply to the
>> RX path.
>> 
>> An alternative approach is to disable kswapd for these frequent
>> allocations and provide best-effort order-3 service for both TX and RX paths,
>> while removing the sysctl entirely.

I'm not sure this is the right path long-term. There are significant
benefits associated with using larger pages, so making the kernel fall
back to order-0 pages easier and sooner feels wrong, tbh. Without kswapd
trying to defragment memory, the only other option is to force tasks
into the direct compaction and it's known to be problematic.

I wonder if instead we should look into optimizing kswapd to be less
power-hungry?

And if you still prefer to disable kswapd for this purpose, at least it
should be conditional to vm.laptop_mode. But again, I don't think it's
the right long-term approach.

Thanks!

