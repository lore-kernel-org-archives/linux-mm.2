Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A21A3C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D66C6B0124; Mon, 29 Jun 2026 11:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E636B0126; Mon, 29 Jun 2026 11:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627246B0128; Mon, 29 Jun 2026 11:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2C96B0124
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:20:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2D761C5C61
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:20:23 +0000 (UTC)
X-FDA: 84933311526.12.EA6F6B0
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8D9F9180015
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:20:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JihvDOM2;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782746422;
	b=kHlvjP5GkF/C262q1/CVbMwvjtTuLq0yF8KogzzHtWK/2SxiRvkwKaMvh6Kv2muLoOjrQI
	Wq5NDkK2sOboQp+a09OAO86lNgKvWSrf9osn0GKtzfGZ8o/n+WvtqE7AwgCmCvHFI4l2mM
	CrQHEUVQDlrqOhN9EZrWZRptInbwYgs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782746422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zY/GriVJLynATGzgCugUthPblhIxqMm9CgqWiWmlu5I=;
	b=wywx2ZehgThrBh8DIHgz5hSgMZjkHIHURqQnrM/h5qeDbqxJCLQuypdPoIQDpzrB5Bfm/p
	ilvwL7ttp8rbSPJDySS81nZFcR0AvJuIMckHF92CQs2YOKTUvc8RKFwK3VqXdSFX2szf11
	llNgtmHByVLnSW5sI1OuDtniYfWzzfY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JihvDOM2;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <fb9af391-b991-41fc-a105-7a3008860c07@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782746416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zY/GriVJLynATGzgCugUthPblhIxqMm9CgqWiWmlu5I=;
	b=JihvDOM2HtqiSQAfyZeXmqsiw/qMEe5kcK6/aBmqOQ6JiD1jy5K3slgNtD5PpIcF4EKrsU
	ntfMVLFqWweMVpB1fEd/I7/Jk9lThGT7CGs727xXTX2R5F6Ycwe7mTwad43arPQjvHRq1f
	+bm02FfrILjYkgEqnWaF183fFZKAtJM=
Date: Mon, 29 Jun 2026 16:20:10 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] mm/vmpressure: split v1 userspace eventfd code
 into vmpressure-v1.c
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org,
 shakeel.butt@linux.dev, roman.gushchin@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org, kernel-team@meta.com
References: <20260629130042.2649505-1-usama.arif@linux.dev>
 <20260629130042.2649505-3-usama.arif@linux.dev>
 <akJzXU52XJ9-F2IB@localhost.localdomain>
 <fb000c9a-add2-4c31-afe1-b6ec416c9058@linux.dev>
 <akJ-It8m_xm1WVLY@localhost.localdomain>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <akJ-It8m_xm1WVLY@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8D9F9180015
X-Stat-Signature: 9d1wmxn7towatbpiitmumudkqg5zrxyp
X-HE-Tag: 1782746421-143404
X-HE-Meta: U2FsdGVkX18ribgNoAtVDTRBhOyuCemenLeP+mnv4TKqXD2AJjss3XTmJV6UlqCNP6s/HW3nz7sGfsDnrFJR6A1XhMJ1QpBxKBYZUTbTwzWnORocK3O1MTUUC94msMJ4VzQcbqmwCVVqMj7Z7xi1IzURh0U0XKX2jNHmssAxliTzO/Al6rI9rh1YMdCwd1KRzVD9BIYt/QhrvtqKJX704JltmRo2pS7za7iDJoefVgcgsPReLhEtCDYvRH3pVFaXToPAtGh3Kb0fmZbFXidfAulkg9PAqGYhLAcfPlV4ziHqehs8aZSJJRo2ZDMkFhVhajzfdCHA7ReUbxFy+qk/e1EtNS/8D/8RcJ1UDyITx0V3vEg8qdavfMk2JlK389T1gFXBTacYyPY1WCLi05cy5tDLpC2VOuO3oeGKoAEch1scwPl+fLTSRkxwrFdsha7/eY4PfK0R1PS6YenYdhewdKaF6xZfVx4e6i66on4g9NI30rgA1/8NLx/ETbr+j/2TosaiOtTbadxod8cd70RWsuAptVE6w2BBvISh+kj+a7fRRDCE8zdLGu3pszYBq5L7f4uyILEz8WXOfH+lA8iTIbzGYu3Zka843/PxbXJ6X8xdldorTV148C+Nd+B9XahDa9tRZrzKvBttPw2N38LwAEAKALmavIKV/zR3GlHdJo/Gi3CRk0fF4RvWZ2uXpugBCfTlOP7hzxb+6lHcLwnE6bWTT47n25IltwK9QJ57PvCvvsDW3IR/tk5Ulimu0CZPfqHH+C7/I666WY4nfehNOz3xwZHJq3V7EyZ8u6mdW74Z6y1yrasVzIdBj3ssw2tsD3xGSZW+sc5vn44PHgaKQeHevWsnhpBOpO4SpNnXgQbe7496oE0Z9nYdKoqCZuclNe0K8u+0GULekCul109NJtEhdotQUwHY0Bix2XbGnM1ZJpikZVLbwNMt0BeKe1IhfAFJPBmLFwJ5UdHX3DM
 q7aKyO6E
 qYKj2hP2+o5iJxYcIZoQtoMbViI9buLBaSb3dxhoFjjYENjN15Iwk2OeCvg0+paz+y4nwQKuTpN2+bJX1u9ZEGLouxFMpq5W5Jsw/DwJclTPasKHzpE6z/ifLU/OpO77szsKHhrPVXx3WT4YPWQOP1T2OM+kPsKgD+SK3tQXzPN49LI4L1PfHz2tNwJZ0bvz/GfsCu8NuarST8sPu0sL3kXtrpfIvn1LNvxGcqfQ205QXovg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/06/2026 15:29, Michal Koutný wrote:
> On Mon, Jun 29, 2026 at 02:55:57PM +0100, Usama Arif <usama.arif@linux.dev> wrote:
>> On 29/06/2026 14:34, Michal Koutný wrote:
>>> On Mon, Jun 29, 2026 at 05:59:37AM -0700, Usama Arif <usama.arif@linux.dev> wrote:
>>>> This split is the first step toward eventually making vmpressure
>>>> CONFIG_MEMCG_V1 only. The v2 in-kernel socket pressure path
>>>> (tree=false) cannot be removed today immediately: PSI is not an
>>>> exact replacement for vmpressure, and switching networking socket-buffer
>>>> back-off to PSI
>>>
>>> (Here I understand PSI is a different and differntly scope metric) but
>>> what does it mean when you write that tree=false cannot be removed but
>>> the other patch bails out from vmpressure() (i.e. nothing is updated
>>> anyway)?
>> So the first patch bails out for cgroup v2 for tree = true only.
>> For tree = false, it doesn't bail out, and is still used for networking
>> socket-buffer back-off. I think that is a whole another scope of work
>> switching to PSI. Hope that makes sense?
> 
> I've mixed mutliple things together, sorry. I wanted to actually ask
> about your response:
> 
> | I realized when trying to swap the order that the splitting off v1
> | commit will end up doing more that what I think it should do (just
> | splitting off v1 specific code), as the tree = true code will not get
> | compiled in at all for cgroup v2, and it then ends up changing more
> | behaviour.
> 
> tree=true won't get compiled but v2 doesn't care about it, so the effect
> of patch 2/2 should still be same (regardless whether it comes 1st or
> 2nd).
> Do you refer to the invocation of vmpressure_v1_account_tree() that is
> affected by this?

So what I mean is that I want to keep the effect of the patch that splits
off v1 code as just that and not have the optimization of not running
vmpressure for tree = true + cgroup v2.

vmpressure_v1_account_tree() compiles to an empty function in the split
patch for cgroup v2, so if we make the splitting out v1 code as the first
patch, the commit is not just going to split v1 code but also do the
optimization of not running tree = true cgroup v2.

I hope it makes sense?

> 
> Thanks,
> Michal


