Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29448EDEC02
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 03:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651116B0088; Tue,  3 Mar 2026 22:02:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FE616B0089; Tue,  3 Mar 2026 22:02:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509ED6B008A; Tue,  3 Mar 2026 22:02:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BDC66B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 22:02:03 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6AC358927
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:02:02 +0000 (UTC)
X-FDA: 84506881284.06.67E84F7
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0D3DE40010
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:02:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=esfkyEBN;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772593321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FcjGpUWgpy5ugKM30k26epuHpLCHbQSZovXNKoic3s0=;
	b=1DOVeiGDQsU9U0Fn2uwF624R8DBi8pBe/yBw7hEgtCBHHVOsukC0i2hVOoRRqT5UkJQPUm
	BWXssuEAjFE3oRxy/GOmP14kPc+kIfgw2Y1mcdoZpVe72HpydutrXFkT+UGUrrSw+PbnsD
	PATSIq/bzagd1JKotkr+joaNJGd/ofQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=esfkyEBN;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772593321; a=rsa-sha256;
	cv=none;
	b=CBX1C673CJ1/kHgfwYhWsrfgrnzDZeM3DFWCOZec/TyVd/OloQ3UE0uw3f1/yRDRmTbSha
	PCa01FB1pz0QM5ZO1J9rmR4kGs9irs7DI95veNL/TY22LVXsLb8kkRzFYGaN9wv98WRA2c
	xzssBkU+JdPv5G2oT6+Qi0I70ASxFvw=
Date: Wed, 4 Mar 2026 11:01:46 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772593318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FcjGpUWgpy5ugKM30k26epuHpLCHbQSZovXNKoic3s0=;
	b=esfkyEBNoTRJppjn9am8n/yIaGI/7Foyg+towY0W1MFfm2XesINzvh5g19pXRFRUXPIckb
	ix64kjX8sQ5gBRQyK7nHCnGVI6ldsJQOdSj3hHdyNGAMkIdQrKNuM0+NL2fRywZvro53Gl
	l64utXXg/hsBgcw3fdliiY5ccYk8wRw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: distinguish lock and trylock for sheaf_flush_main()
Message-ID: <yek6rgfynwx4c6oel7wmdfun6zrr6tpvu6w7cywjvdl4d4gwjt@rdkwypxx2iwp>
References: <20260211-b4-sheaf-flush-v1-1-4e7f492f0055@suse.cz>
 <c6e94e2a-34ac-4515-b4df-222f2c08c992@kernel.org>
 <3016b42c-643b-4e65-a6aa-67a91676d3f7@kernel.org>
 <aaeFV4TWm2jGzVl6@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaeFV4TWm2jGzVl6@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0D3DE40010
X-Rspamd-Server: rspam07
X-Stat-Signature: phg4wt9brwbdpx1rk98ndi5xsc1iajep
X-Rspam-User: 
X-HE-Tag: 1772593320-655718
X-HE-Meta: U2FsdGVkX1/G83LDxMtNIeQHJYF14iYiCBgC8wpKfJWsvqliBLbl26KJ1YXjfGE7KTeuA3TgenLsBeuRr1rzyehZCBedkSCzIcaBouKXVholhagHwCtvL3M1FnhGLamSnM2xaGMqBguZAvYAHg3uQu/Ug++gmjtzzi3roCbI9vui21Z2dHh6VjWbRFPRCL/Je++UaowSEHirEY8bpGKZe/vDw8hM/AH56gSzpQtM39Ikhwk3Q1ABTMZXsuV50lKq2Ky8DcQiwb62+AeZ9Fsv33r+duZSPYBJyU00oWqrcJHYWrUEtGtv76SnR9ZDpNLXerh94L8ltOa9z7CRxHe+WxziPjz31nXhQ2YN1odCd4nqLAwT6XWw9dST8cDJYH8HLaVhRIDLN2r2Sllzb3TksJ8ZyBEzbpxdQMBKvfgTcqVJwXtU6lhL2TbtQSCcu8d+QoUFf4g2gT0zBCuQ7RXvHHKz/2lrIX2jtmM8IFgU6pE6rIeUqVLkTwkLiWYPMOQXNxliUtWNhaS3HVkY8XUWSd58/TKoEjh5trXFQnW2rIw3QQ2gz1EyxTUCIjZweClCHGRSn/gp+BDsmGb0euI9J4LeTNpwj4m5NnsyHhKyBc476I+ZS8M6qH5eU7cC6Vxkunz8/JCOKZj5QZbwHMwBhCrU1Nguy/go4wu+RsVxfye398TbIBbdcw1QdPrSN0UsleXRdEhVJIo3V7RK6qoYgmBuKzGhqkHuoOcdP4yAvLVipXBkcgntr9U1F02ksie7Bn0DHnjGYHt5valNoKcSrghxNolpbyJqOztIeMGNh/Cu9b1KdAiWR7XewajM4vU6KmtN3pir4qcA1HuAvpEXRKcIfAqPvdxlVI19Ing/m8bIxyp+D6AAcQ/225qEv5j03FuBuuafzP54rpOClNhIoKs7BCRchXQt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 10:05:27AM +0900, Harry Yoo wrote:
> On Mon, Mar 02, 2026 at 10:56:44AM +0100, Vlastimil Babka (SUSE) wrote:
> > On 2/26/26 15:50, Vlastimil Babka (SUSE) wrote:
> > > On 2/11/26 10:42, Vlastimil Babka wrote:
> > >> sheaf_flush_main() can be called from __pcs_replace_full_main() where
> > >> the trylock can in theory fail, and pcs_flush_all() where it's not
> > >> expected to and it would be actually a problem if it failed and left the
> > >> main sheaf not flushed.
> > > 
> > > Thinking about this more, I now think it's not a theoretical issue because
> > > on PREEMPT_RT I think pcs_flush_all() can preempt someone holding the lock
> 
> Agreed!

Exactly, not just theoretical.

> 
> > > (on PREEMPT_RT it doesn't have to be an irq handler preempting a holder),
> > > and then fail to flush the main sheaf silently.
> > >
> > > The impact is probably limited though - if this failure to flush happens in
> > > __kmem_cache_shutdown(), it means someone was destroying a cache while using
> > > it, so that was already buggy.

Exactly.

> > > slab_mem_going_offline_callback() could be
> > > where this matters although it's unlikely someone would do memory hotplug
> > > together with PREEMPT_RT.

Yes, given the semantics of slab_mem_going_offline_callback(),
sheaf_flush_main() really should ensure that all objects are flushed out.

-- 
Thanks,
Hao

> > > 
> > > But maybe still worth tagging this as Fixes: 2d517aa09bbc ("slab: add opt-in
> > > caching layer of percpu sheaves") and Cc stable and sending it as a hotfix.
> > 
> > Added to slab/for-next-fixes with adjusted changelog:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/commit/?h=slab*for-next-fixes&id=48647d3f9a644d1e81af6558102d43cdb260597b
> 
> -- 
> Cheers,
> Harry / Hyeonggon

