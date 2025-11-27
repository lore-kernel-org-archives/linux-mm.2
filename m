Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B22D8D10375
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 07:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071636B0008; Thu, 27 Nov 2025 02:21:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047DB6B000A; Thu, 27 Nov 2025 02:21:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6F26B000C; Thu, 27 Nov 2025 02:21:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB9186B0008
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:21:03 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DCD35B97A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:21:03 +0000 (UTC)
X-FDA: 84155540406.19.9CF4FD5
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id AF8FE14000F
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:21:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=fLInNBs8;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=dk5SuCbO;
	spf=pass (imf26.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764228062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Ad8ik7IFSyx7voLIMN7w0BRCBgrkaim2ypdKamKnu4=;
	b=Q66LXItj7szQbX3JX8eD9u11TElYPrxk2B5laTIyupfY/u5Xum7m9h2g3JqljaMLM2A4Jr
	ENhFrth6hGvgEPPqi2v8+GW0zNyd88Yk2tQm40iCQqp3t7qj+pzfz1Q0gwWxxOLXYzMdGI
	pbIEKEbN4e3LdNpJ9DSGtG6WrxWnaig=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764228062; a=rsa-sha256;
	cv=none;
	b=DXfMk7hxe9hdsisY6Flz/bEhJefemaMTe1zp1XBLRyFrwR39L+XN1Nsi6H7u07CdZVBOwk
	/1eICMJ8bXwMoUcE1bupd/EeWBiNZ1cxCVf3+nuiIHI2w4QjJRcbgc1Y1rtjFIJN9st662
	R7E67jTtBgLFVKHhAN9JCflRJGIGTiw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=fLInNBs8;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=dk5SuCbO;
	spf=pass (imf26.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Thu, 27 Nov 2025 08:20:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1764228059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Ad8ik7IFSyx7voLIMN7w0BRCBgrkaim2ypdKamKnu4=;
	b=fLInNBs8TXqUHGtP3Sh1sI6ytVwTqfBLr12hBnrz+MA8vrF5DTVkSUXNqFbzywP456lNeB
	ez73iUWVfEsf7FI0j6ikXXxHMfwNimMtiy7rW8tC5ZhcKUxZU29BYos4u2BXpsCC5Ald34
	Vs0GfoQublaZnEOiSv48K7uNCrPlu07CIS0rI3lgaEBNIk8gpzEjvWrfezSP+0BW7PTEpx
	J8wjLrzxdRXyxoQKeZi0kBumr+eR2LmUSOrGj8xPUOqnMccqZfx0+qYvS5U941NFYPFFZS
	PrZb9p0STUdw3Zxv3qYbCkZlJXkHt0KmsNyzGv9MQX3zaLVbHr0vTtdeG4MNJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1764228059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Ad8ik7IFSyx7voLIMN7w0BRCBgrkaim2ypdKamKnu4=;
	b=dk5SuCbOQvbURXCZeKYw/C9ynGOXmOuzOVf9ofmc8gtUWPcmsiNWWOsyOjHAZ0L3i9i8YU
	ZNHJRX1mAseyi7CQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: viro@zeniv.linux.org.uk, linux@armlinux.org.uk, will@kernel.org,
	david.laight@runbox.com, rmk+kernel@armlinux.org.uk,
	brauner@kernel.org, jack@suse.cz, nico@fluxnic.net,
	akpm@linux-foundation.org, hch@lst.de, jack@suse.com,
	wozizhi@huaweicloud.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, catalin.marinas@arm.com, rppt@kernel.org,
	vbabka@suse.cz, pfalcato@suse.de, lorenzo.stoakes@oracle.com,
	kuninori.morimoto.gx@renesas.com, tony@atomide.com, arnd@arndb.de,
	punitagrawal@gmail.com, rjw@rjwysocki.net, marc.zyngier@arm.com,
	lilinjie8@huawei.com, liaohua4@huawei.com,
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com
Subject: Re: [RFC PATCH] vfs: Fix might sleep in load_unaligned_zeropad()
 with rcu read lock held
Message-ID: <20251127072057.EbvhUyG4@linutronix.de>
References: <aSeNtFxD1WRjFaiR@shell.armlinux.org.uk>
 <20251127030316.8396-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251127030316.8396-1-xieyuanbin1@huawei.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: AF8FE14000F
X-Stat-Signature: 4prn5ri7ogxcfkftwgzx1gxbefoujt6i
X-HE-Tag: 1764228061-350115
X-HE-Meta: U2FsdGVkX18IhrcIVPCjXn8gNqowq+FmHiCT5KvEVFpKd2RfHkkioEox6j3OtKXZlkWIIf2OJ+hRrovfsqPf+TIndXsMKdl7tZP4GIKGYn4oWjlrkM1FPaqfYmVB0DYRSzs66F95HvT2WUgjpiAWOTpnftY00oWFiSAX0Z9sDQhGJabNvFA8Bm96wZUvvKXUsEz96taEjgfe52qk0hprU+17vyncJRZKEeYAv8PRmDIMoJA6O/QjVVJrSDFMZ1awN7F1zV6QH3AStqsUY/4HhaihszhiRAHlF7RPEZFbxgNpE9KLHsLnONPO8HhhfyBzudxiNq0yUwZPJZDRD4dBELXDZDKYkUJHAiWnS8Ll5ioVgJaUqWItF6Hy06ECEeKjZw39qZP2tOqg8xaW1ndDCZDuFUW/iaqGC9ze7gc8xYog4pALlfNXoIwN7rFxugeneZl2pdYE25Mx2JGThgv38/N/2Z8fP6lZR+qR8vMPluZ3bzhatABcVocvs6MGjAXQMJ9pEg8PNexNKpumrzA1PITaPCiBpHnBpDcv/ZwUytIMCzjE5RNBKPnURdH1w9mzKW+IDKeBHARSeDX38AZD2RVkf5r1EdAy5AZkk/I4184g0CBc4ukbSotS2TAF+5DzDnl5sPO6leH3O+qLrh+L52OljVzsTIhC8G46DSPxGCXvjuG1piA65Bd2apu3EsGugHp3dy8tg5L/3q7BcYr+IdHmKSs3TvY1E/B6FFvD8+QA8xz1zohCTg80/kbVOWcxmGMUOfJYmeVCdRNUyCEKvOGUCAEbh5DL53PTge1FCS14wb9e5+31aGKOwT8+7PBNZ18reJq9DcDexLbhC/XET2sqOwpYgDVelfr8ZQ6hfhoWgHcUms/0HX/dkC/Xt2pUBz7FKKnfZJgh02LK51XsxcI8AtVI9fYjAeEiARW3tcoYmewaRwP90EPNLRYsN6gytR6u4qt2haFXiD6tkW7
 BaaeTTBP
 QSYE/wLMd4LHhZWiKNCDZLmhFF+KpCzzwt3OYewf7vvRfjK/4PO0tiiZ2EhKajwGgrxVZWw2ccbwxyU4Tme66hwdFdbt/acmW3Xs/a27urTudkaByaxmq6BHCosd8mf8bDjXYIJTE8fgaLa5EFqvonY4oEhAgsbBRW+uC7WRaTzvXY+s2a9B2GZvUPCNdTxkRjtRYhRsr/9wm7hc/5YRw5neIrq0x50NLY1vXnxzH24CBAIhACjDjnuo2/calSIxuESuwkKo4IQNd87t0MSwstMooo7hZxjn/srRqPDLTwYz3Oj11HuEtkm7rZ4PT7S9SfiC5uoFw6A4CTDn52t4qHlkgXcGHKTKWvG77NfClJaOIeBg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-27 11:03:16 [+0800], Xie Yuanbin wrote:
> On, Wed, 26 Nov 2025 19:26:40 +0000, Al Viro wrote:
> > For quick and dirty variant (on current tree), how about
> > adding
> > 	if (unlikely(addr > TASK_SIZE) && !user_mode(regs))
> > 		goto no_context;
> >
> > right after
> >
> > 	if (!ttbr0_usermode_access_allowed(regs))
> > 		goto no_context;
> >
> > in do_page_fault() there?
> 
> On, Wed, 26 Nov 2025 23:31:00 +0000, Russell King (Oracle) wrote:
> > Now, for 32-bit ARM, I think I am coming to the conclusion that Al's
> > suggestion is probably the easiest solution. However, whether it has
> > side effects, I couldn't say - the 32-bit ARM fault code has been
> > modified by quite a few people in ways I don't yet understand, so I
> > can't be certain at the moment whether it would cause problems.
> 
> I think I've already submitted a very similar patch, to fix another bug:
> On Thu, 16 Oct 2025 20:16:21 +0800, Xie Yuanbin wrote:
> > +#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> > +	if (unlikely(addr > TASK_SIZE) && user_mode(regs)) {
> > +		fault = 0;
> > +		code = SEGV_MAPERR;
> > +		goto bad_area;
> > +	}
> > +#endif
> Link: https://lore.kernel.org/20250925025744.6807-1-xieyuanbin1@huawei.com
> 
> However, the patch seems to have received no response for a very long
> time.

This all should be covered by the series here
	https://lore.kernel.org/all/20251110145555.2555055-1-bigeasy@linutronix.de/

or do I miss something.

Sebastian

