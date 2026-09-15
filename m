Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F217BC88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C15296B0092; Tue, 15 Sep 2026 13:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8536B0093; Tue, 15 Sep 2026 13:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1F26B0095; Tue, 15 Sep 2026 13:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF8C6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:13:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74A191C26BE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:13:56 +0000 (UTC)
X-FDA: 85216644072.20.58E9DC1
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id A9D1C180003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:13:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=uYx0502O;
	spf=pass (imf06.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789492434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YjUHfOUDrYPjLwDx00t8Narh0DuwVAVgRAmMLLFkTFY=;
	b=FtgbC8uMOgsw8elHCcNR4NtI8bA4dL/REIJ3Z13l0alvKsEPfsDbFPQwquibLfjn2EYXHE
	yJanEy/CH2jjbOzF3rK6apxCy7YVab3EyalqM0u6CqY/RUh8KM2JE87Kt1XdudynwS3ZwN
	RzhgQfLl0pNEnkseTc9ANCI9mhiL6kA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=uYx0502O;
	spf=pass (imf06.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789492434;
	b=vahHC3j3Z7XMQ0cFPM/kJ9o1mDdYlTaniPDeuX/SmL1HtMtziok8rz8QkmbniK/Bndy2Cc
	lTsL93xr1vQBb/2H1cPrJ8qaF7IeEhYdHt+59v3LByxZwSi2yIDGu5oNJWeI81i6D4xyN1
	wesAtcKUZD6LuwPndwInbkzWYjpFOSo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YjUHfOUDrYPjLwDx00t8Narh0DuwVAVgRAmMLLFkTFY=; b=uYx0502OpV1W4MIwCWgQnuiPwM
	sYiPyp+DDLijndBGWheIGilVK5gKml/LJ0zXqgLclUSaQRMarRWBfHCJd5piVw+y9BhlUO8fuhu8t
	Wm/y595hw/JvMO4w1smAveqIbV6074D/0XvzfQc/pghg0kMMq8o6cInK8ES/+tDvwlI+Peze9c9Y4
	6mj+QujbSeETLh9iAAekG3byYqEA8dAbxdEbDnNrowfMOm2V1H1s70Vl0nRnVykkC+aJP8d6O83+0
	XTZ/45GmDz0ZZXnvLlcZaYp8h/ZmdoycshO4aioQSnvmhwwQzCt4usjON7IicrYFm9PF0OVVhc70b
	JqxN0iVQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6Wj9-00000007YVz-1IEN;
	Tue, 15 Sep 2026 17:13:51 +0000
Date: Tue, 15 Sep 2026 13:13:34 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	Suren Baghdasaryan <surenb@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] maple_tree: fix maple_range_64 crashes in RCU mode
Message-ID: <npw6xqsjzsdmtezkca4osoncnle62wvde7ycaladk3xzlmzguf@d7smzgbzsmpj>
References: <20260913-fix-maple-tree-range64-rcu-v1-0-31a130bb8cbf@cslab.ece.ntua.gr>
 <3aqxp6zcomm3wzfc6jt4nhltutnvoatqqsjxlxpxlo3j72eeva@nkqwz43zxsug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aqxp6zcomm3wzfc6jt4nhltutnvoatqqsjxlxpxlo3j72eeva@nkqwz43zxsug>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A9D1C180003
X-Stat-Signature: rxe5ft3h545cbzmm3y1dpqyiym39xiay
X-Rspam-User: 
X-HE-Tag: 1789492434-788151
X-HE-Meta: U2FsdGVkX18a/RFgXnVAWD0208WbHMmrQAJUoNCpJAw+4HoO6iee4ihTEpDCbaiy5nmKJc363UKBaCwnzwF1RiGV37GKtUjXu+ZZqRBEgdT0EjBg0xvgglRSeHsEgqjraYb+pYUunFIQpSNVEm2y63pX6jmV+lnPytGvo1VzKiGFsWvgZG2OkuuAqNfC0NmDajI56a2Vo+mtMIgti+vKSxwme31kQldjILVocbBQlsBoPrzQd+mrsKrC96+LRHHD7owFNsFqkwrdnhpBIOTO0R+tx7wOlaCEJXRTtQbe7GJAUAA4BW2Owhnp1ztJHCcfJRCyEQ/7iyajoGex+LieXS6wYpv6EejWSlWYPBCdyhLzCyoJ7q7pgEJNs3b7fFw9AhXkvHHkuMLYQeVuu1ttYkgXkLCtflUpst0rvCt+8v04rFKti1OmvgCBVuhKViRZ9Ec5riDCv0mXu5qvz5qS5kooxj4bCVEuhciwnxbUGSOjE/dj7trj/chD2rOqpW8iH6JAIwcgklAjeq+CxnYEvVue47neBWbN2parTJ7wmPF070nVy6udn2StG+VlkV+ejmiof5gO7Tc2OdVt77dhIq+/gxDRmrM22qwocB66n1n111v8d8+NSMNyj7y0OwKd27qQKkumqFmLkHzZWrGc9id+wOq4iGIzkDAtoadiUyc00SHY0pfH7z5WLGaXlC3odHoMd9v3uV1Wz3HjXV/sN308ZH2LN21vsysTGS6Xcfsrvve4SSAcQatXC7pj9svVtUm5RMfAzxnrnJkqzePR//z7t8kpM4Iw6p7ybtREVYxYFTw8uBUf4MipZx9T1aX+7yUZkm5Og6As5rVw4c3G8ks9vq38K8mesPwtH7QXFDQSqNRgILqOgE62LqKAQchbqTgUpZjoIvLSjZlpHuKzgr29L3xQiFusVzV3z3pCItTuk0rVTVNMCr++Cq/XhJZN6EXWHEL43JCpZ40q83d
 SrvqC4h0
 KBa4zJverBxqlsKKbZ6CE6cfmRyWSvv2mhE0PY6RjNHDXW/x+v+dDzzBxQ2oq54jAwVexFcPpUSejdqb7LHEM64Dx2XPmYIVMj7jqrSna6pyd7LmsMd6pCte8FIx4Yv8k6J1sRrCDCZRoFLC+vPV7ywrq5EbtRR5qcX1ia4KH2GWLx5GExDUfUtwUheoQIHtHefx5eOek4b6ut+j8VGhtus8xLqoAw+3pOBedO9KyKygsNy3MKYDnMbT9fI00d84PD44b5FPg100eagx35A/CnKJmu8EoQ4kVteosSKj4RqpFcbLUzNWYzyoDgX5w6r3n8dETaquDWiAs93Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/09/15 11:23AM, Liam R. Howlett wrote:
> On 26/09/13 03:26PM, Dimitris Charisis wrote:
> > I was running a patched kernel using a maple tree in RCU mode without
> > specifying the MT_FLAGS_ALLOC_RANGE flag and the kernel crashed. I
> > switched to an upstream kernel, and after some investigation and
> > debugging (thanks tools/testing/radix-tree/maple.c) I discovered that
> > there were two separate issues on the RCU destroy path that were
> > responsible. Both arising from the fact that a maple_range_64 node that
> > is not full repurposes its last slot to hold metadata. Each issue is
> > addressed by one of the two patches.
> > 
> > AFAIK there is no in-tree user of maple_range_64 nodes in RCU mode at
> > the moment. All in-tree users of MT_FLAGS_USE_RCU that I found also set
> > MT_FLAGS_ALLOC_RANGE which makes the internal nodes maple_arange_64.
> 
> Hello!
> 
> Thank you for your investigation and patches.  I will have a closer look
> soon, but for now I have a request for this series.
> 
> > 
> > Below is the minimal reproducer I used during debugging.
> > 
> > static DEFINE_MTREE(tree);
> > static int __init maple_fix_init(void)
> > {
> >         unsigned long i, j;
> > 
> > 	for (i = 10; i < 4000; i++) {
> >                 mt_init_flags(&tree, MT_FLAGS_USE_RCU);
> > 
> >                 for (j = 0; j < i; j++) {
> >                         mtree_insert_range(&tree, j * 10, j * 10 + 9,
> >                                         xa_mk_value(j), GFP_KERNEL);
> >                 }
> > 
> >                 mtree_destroy(&tree);
> >                 rcu_barrier();
> > 	}
> > 	return 0;
> > }
> 
> Awesome!  What I ask people to do is to create a patch for the
> tools/testing/radix-tree/maple.c with the reproducer in its own patch
> that gets added after the fix.  This way we never re-introduce new
> features and the testing keeps passing for every bisection.
> 
> If you have one of these for each bug, then please add them after the
> fix.  I understand rcu is tricky to test when a race is involved, but I
> do have testing for many threads (which you probably saw).
> 
> The testing is less organized than I'd like and since this is RCU
> specific, you may need to use the testing file and not the module
> testing in lib/test_maple_tree.c.  If possible, I add the testing to the
> module, but if internal poking or threads need to be used, we put them
> in the userspace testing.

Your fixes look good - Thanks again.

Please respin with a few changes:
1. The message in this email will be preserved by Andrew including it as
part of the first patch change log so "I was running a patched kernel.."
should probably be removed and made more into a change log statement.

2. Add the testing to the userspace testing patch to enhance the test
suite please.

Thanks,
Liam


