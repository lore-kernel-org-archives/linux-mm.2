Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DF311077614
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419D86B0311; Wed, 18 Mar 2026 16:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1166B0312; Wed, 18 Mar 2026 16:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32DEB6B0313; Wed, 18 Mar 2026 16:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 246E76B0311
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:20:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D043E1B6E33
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:20:48 +0000 (UTC)
X-FDA: 84560302176.15.4C99F11
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id CD3ECA0005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:20:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AGPJdqR8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773865247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bxij6mVCRTnlUykaXUvSflJ+OI3kIm5C5tdfjXoBy0M=;
	b=LUyY+EH2JKM1wn1iqb6bbMgQhrelvY6SP8sOvmsh7c6mW1H51cd+ZN/1ig+7lGvesoMwR9
	/+IjsrWVUrpST+VnQP3rI9ZFQXA2lxaDT2SUkZmzr1Vgan72kp6R4JDKfo0yvRrFs7G/MM
	0fr5fP+sheDiW6uGwQ0dORZt26lCz64=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773865247; a=rsa-sha256;
	cv=none;
	b=e9AiEQsn+WwYf+I8Mmsy5s52Uepd0in3RlznpFT4DxpP2UYY0uZqxvalm88OksdGNaF90T
	KbEwFUgtuB3Q1+zPqiUAcp/0Dz/9Vu9uF/rYaO/9mXBNVMrlvKqL2xlQMJq37rGrhW322w
	VlOh3QlsXXLLl+PwTN9VsYClGefNAzo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AGPJdqR8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Wed, 18 Mar 2026 13:20:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773865244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bxij6mVCRTnlUykaXUvSflJ+OI3kIm5C5tdfjXoBy0M=;
	b=AGPJdqR840yx7hCYhDNUHhQbLZXhnhtqWDSzOrzyNM2g/ftgiV05r8G1Eznli34ZBqo3qS
	ieBww6a5LWJpQcvU04CklRPkuEuayZPvE8sM4JbsKBaB/F3Qw4ArY+LsWJvgvxJ3DxaVqd
	QTmyYSxQkBVFhFvvfsa7VqX60mWwGoE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/7] mm: list_lru: move list dead check to
 lock_list_lru_of_memcg()
Message-ID: <absI-U8-3c63pCIT@linux.dev>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-4-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-4-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CD3ECA0005
X-Stat-Signature: pahztzykqwzbcs7q1hxgztmd7cyfum6x
X-Rspam-User: 
X-HE-Tag: 1773865246-4970
X-HE-Meta: U2FsdGVkX192Twt0D+Vsa8GSAv4CUBKQIcnsBog+SBEY5JiP5Z2BpadzrvVSh49QQ1huXMQ2FeeodyEj/OI1nNPwxtpMRKh4QhjlZEmJHk87Hk3GWfuAVDsq+8XNSUo3JQbrngK7nQynarmGR4IvqEm2WCsX7YFb9qC+Bp9gNWB7DFzpp6I+RW6MjI+GUXHxeemZwFzrE/XyVfNmgFiKClJ8VKvfpKyREdeFTkzWl16umXQxJjLsS2XziLN6MSeYAMQ9ahsd6YON7qHgjN8+7xBJeBm0cipTptvVe64/Y7+e7oKUNrnD6Zc8bFPcBjmRINeDbWz8lAhXpBraVA3oZ/TwLhpoCMO3+Ws9baYXhh38pC2AnhRGF2pE7QnNde0wBq9K0S/iDC1Yk5mZw6hBoDgD3ajpawOHdj7FUWshoEhJYRH1cYeUVfyGd7va+4BNIl/p6p7DLV+FLguDFBn95acfXWxowenaiaf4pMLIYcxDhY+/b5eglrtKIJI7PaXNDYdO3gK4j1rGau3Qy7mmYAVisAiBhaD+w5ZOD31d0a7j5G804kbgD4czXGFmQPnB+zWVhMH+X/6EmkI2b/J0q0+f2J7WbHoujlky//2k5pOYTPk0270bmzkdCuwQSjeyX1yGx9SMwcdZZDnTtjNnIVwG8CuFWWXi/QBD3iLvOh0KP+B9f0s/X+AUP602UOjlWmOw/knWk9kDUb+5StN2JhNRzC0NRYwWAhuJ/UkWe0ZDt8vYLEpVBv1Wf5ZxgfY1aj/YrFRSOIEAVa7aVruww1Mpfgq2nOmzFEpyALjoE13mlZK7DKSqTBLOZqgIrS5x0I98iAbDE9HIxGH73BJ2cLCe5wp9xB125Xdx9IFqPXe9WylbPJLytuMjkvnnj4HYtxsBvnqIzCH8osjO1NaOURI4ufgD+pUTF7j7xV6o+TB7PLAC8TqxdeMY6piCX8Jw49fmhHHUXj0aPdg2Qn1
 VKZZBxB5
 RHbOjmXpRDCSlVfU1m/Jw9DmdOs89Ktfp2DtHLIXpugydQ57AIb6XwF0kT1kiDp7drfUDDs4RoPFjHod4p7CtI0mVV/m72sNlhyhoIjivovv7wluyrg1zP3lMDSUwj62Ct1VMj/zoxINZAIVwMPp1u+ZasvrqegXDRTFn6cElVQDb3FtJ9wavVinFiPrBxV45LwiNCHhrEaYp6dHkpf2wBkRJtSKwUQj60DDBKKS92b5/QXPWBg+C0p1bARPbuYHcTFr7ede3oAoQFwFLVhnxcrPG2jWPkygVXZ4MF8hWzvCa7witSfkjoVO+swXBRuOlfBIv8ZHLx0qtO5bksJjnHbbltg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:53:21PM -0400, Johannes Weiner wrote:
> Only the MEMCG variant of lock_list_lru() needs to check if there is a
> race with cgroup deletion and list reparenting. Move the check to the
> caller, so that the next patch can unify the lock_list_lru() variants.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

