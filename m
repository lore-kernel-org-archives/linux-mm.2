Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FDD5FED2CC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EEEC6B0089; Thu, 12 Mar 2026 00:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C8F6B008A; Thu, 12 Mar 2026 00:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17E836B008C; Thu, 12 Mar 2026 00:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 08C7D6B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:56:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AAE59BB467
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:56:36 +0000 (UTC)
X-FDA: 84536200392.01.903894B
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id D7BF3C0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:56:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XFqMhSoG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773291395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x1tEDPuTvzknNpligi1k9Mta8WIlso2FgXG9KdlwsDE=;
	b=khYkOYTIF69wXtzvkadziOP9skIvSlYYtzcD3/GwA6oo7y+xB7NDUeZ2APUtzZOLAWnqt4
	oGT8s9qc66nRYeZMy4IEj071IuGjV4tABuFMnZdUexRMhIJJxLZuKysDtb0W0mZPdSP9OC
	1IUEqXCPvm1uwVAyO30tHVqb4M2RMFs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773291395; a=rsa-sha256;
	cv=none;
	b=EQmprRiPm5BPqS+NbSj2yrgOnKxwJEnCD6mxxiNcBYD9IMfIIX2mfbeNxBlIiI9ieXbdko
	DJpzfhjO/ApnG9stHKu566/xmiZ0emUIiCF0Ih7Vq7UGHzYDIHIg/+GynzBGTpyDHOj8yT
	l4OC9p2yjf4ZLYHFLmfMUu2kBridNWk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XFqMhSoG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev
Date: Thu, 12 Mar 2026 12:56:25 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773291392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x1tEDPuTvzknNpligi1k9Mta8WIlso2FgXG9KdlwsDE=;
	b=XFqMhSoGasBx0TvdYcIT4iAhUEKkGcE3Ya2lXngHfks/Q1X7hQTxRbbzdD9dg8uEuyd1zU
	iNBS1wK6ApwMaxB3R23b5lZFf/DpCSHE0RSQo+/IHm+WtJTQum5WbIXtoNVjELcxxLfsTV
	ZI0FmVvrrlSMoA5lEyjxoAFGXvsoUB8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Qing Wang <wangqing7171@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: fix memory leak when refill_sheaf() fails
Message-ID: <gm4xpvw3qr3kniayxfm5usek4heudkwqxjv7rovhlxtlr54ytt@xd323stchmji>
References: <20260311093617.4155965-1-wangqing7171@gmail.com>
 <thhmlnu6phtuucz7jo3xoqeiv64rs4ynkt63qoxvtwgfh3aofw@lo75dus27vyk>
 <tak4kjtw65fk5r4inuvddqt2pooqbfu76i3smzxsfjoiz2p6oz@qwpmlhmpqlwz>
 <272f1848-e2c8-471c-9b0d-e6706b464d11@kernel.org>
 <abJDoVkMBRFxPdLe@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abJDoVkMBRFxPdLe@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D7BF3C0005
X-Stat-Signature: eqg5zn7ghnqpzi8fdio9nn1eskcyduqn
X-Rspam-User: 
X-HE-Tag: 1773291394-216778
X-HE-Meta: U2FsdGVkX1851zpUUtC5P89sS2C3JuI5+61iaRXJFLY5knNKElJ1dMdL0+Uqk/EzmvphtI+62kksNmLU6Ii5tKl6mpmDv8UIrC152hETQmyka6qmOu+jEg6wV1pv0YaTgq4w9CZ57w2Lb+xueBpvYXjjJckYflFrxWe0CJZDLmqBprfVwrU2k08w88vLpRmwax02hSa+vwDR1/AaRmbJA0Dvlg88V1C6BlIZae5XjfaFeM570FB8yYweTE8zTFzkyA7Kj/YwRB+lG4qNE46LYK4ByhZ3pN6A/cIwuYJwYbgGqt4ijyRl6Tzcih2yjIhb7cS0Q7eTzrxAdtnbsCF1n6IekdheuB1wwazTJRChLvZqXU9xHzGvVh7gMiL1Amx6X4GMj0dc21kJ3eu4wflLf7XbMLxyVs1mADycOX/7EXNhOCM1bmvIef3kGn0Rb3lNsVO63NbkJYCDhl88TB5QtA16KL2JkZLg7eXAukTmVjVgZcx1BnWnuBn71pJGCEqeahbj85irTX87ZxHlHyPnwyMHIF4sr1RW0C6caF8yH8z/ke2Xbba6DHniznULxxrlVHcB3kJ0uGZB67xbuX2beEFErVX6lAG80TtHm09Xvt/eJy+dOczsVn6QEJqVovTcVI6Qvy6Ckmtszpto1djUF6rKKyn3REf98hzrxPYTLterwrRrMTmF7Co7d5JSuyLrxIgT24/9Uf3e3mnwg/A6TkRN/3U4nBC7vSaSG5pbiVCE9h4a05ZGM8Wr+7mBfIqjDfK0Q5aZ5CEzZpKNfa9PI7B/cBanh4lES8OQqNlZ8f60tcuOJif0jv2bbyaJIbl+8O/Dn2Oj2SeEUlIwEfAxCZek5DVuagqWO3MEKrWRHexs74Es0xSEQ7vrdXwCXmL0syIfoj9UZLKqnqi7qDf0pPUhXlChsj5n8urcstGAIu8e7brVlRmwa/2L3VIfw2HXVCc7yCCZxo+rz+Zdwui
 jwy94Awo
 kQ65IINRvwWPWfJJq+kIRC0ptMJRh1VuPXO9oJEfvHqD/JMZ3Dv+i5IMJMigm102XUEkiPVcOc3G+ETUgTi4GD0/iUFC9GHVuhsGjokqrGXuYSHdMhPLrxAi8RqmTH7D4PLrsUV+vz+qEuYBSExV7hwTG9LwQL5bvKy9cK1mhWl6SIhezU6Q31r3fykAu5hucQAa3SQ9zsYcaOmOz7eRfW0jqrHFCMwCdbnKKDErsOFyBWCt0xikl8bNCCxSGiO/dHwgH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 01:40:01PM +0900, Harry Yoo wrote:
> On Wed, Mar 11, 2026 at 05:54:40PM +0100, Vlastimil Babka wrote:
> > On 3/11/26 17:30, Hao Li wrote:
> > >> 
> > >> I also want to bring up another point here, although it may be outside the
> > >> scope of the current fix.
> > >> 
> > >> When I looked into the refill_sheaf() path, I found a refill failure does not
> > >> guarantee that the sheaf remains intact: refill_sheaf() can partially fill the
> > >> sheaf before failing. This non-intact behavior propagates to its caller,
> > >> __prefill_sheaf_pfmemalloc(), which therefore also cannot assume that the sheaf
> > >> is still intact after a refill failure.
> > >> 
> > >> However, the comment for kmem_cache_refill_sheaf() says that "if the refill
> > >> fails (returning -ENOMEM), the existing sheaf is left intact." That means the
> > >> behavior of __prefill_sheaf_pfmemalloc() - where the sheaf may be left
> > >> partially filled on refill failure - contradicts the API contract of
> > >> kmem_cache_refill_sheaf().
> > >> 
> > >> Maybe we can add rollback logic to __prefill_sheaf_pfmemalloc() so that it
> > >> provides intact semantics, preventing the non-intact behavior of refill_sheaf()
> > >> from propagating up to kmem_cache_refill_sheaf().
> > > 
> > > Looking at this a bit more, after checking the current callers, it seems that
> > > the existing callers of kmem_cache_refill_sheaf() are not relying on the sheaf
> > > remaining intact on refill failure.
> > > 
> > > If so, then another possible option might be to update the comment for
> > > kmem_cache_refill_sheaf() to match the current behavior, rather than adding
> > > rollback logic.
> > 
> > I agree with this option. Having possibly more objects than before the call
> > shouldn't be an issue for the callers.
> 
> +1 for this!

Great! Thanks to both of you for confirming!

-- 
Thanks,
Hao

