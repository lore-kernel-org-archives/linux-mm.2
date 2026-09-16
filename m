Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 136DDC982C3
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B9806B0088; Wed, 16 Sep 2026 08:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26AC36B008C; Wed, 16 Sep 2026 08:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1815B6B0095; Wed, 16 Sep 2026 08:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F32296B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:40:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B34C1206F8
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:40:12 +0000 (UTC)
X-FDA: 85219583064.07.6ADDF36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id DED3C160003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:40:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JkfV+N+o;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789562411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2VfEaYHyIVoe3fw5ftSy9zFU8N1gxbnFTfXwIrFe9uo=;
	b=qwGASqjl11IO9LDzrLTbKminv2D6qGl67fSOW1vNPy6TY80M1/AzUTts1IVqRlaDA7G19q
	MA6hhi9we4359T5T+N7lcn6fyWJzxjABZZiSGYE1pL2XmpJJgUDEVKbIxPyKg0W6/0Iiqs
	HimXQF6CFfOp4K4UKTPfux1MzhUDOfA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789562411;
	b=WLshWLpOFipRbFwFbyFI1Ji4lSg+3uJ+yDjsK5K2l7mXDd3K0yQp3M2AubcRMNNr7MysZ9
	ZAqrPfLq4T3pjs2uPCNsvBW4EMwjBOoUct17Y7ZeWRhxCT/TWGUQ1AYK5ddvEKyf16cWWM
	Y5g1R9mnqA36LPdr2UPA7MgqCyB3bJk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JkfV+N+o;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CEAA240371;
	Wed, 16 Sep 2026 12:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0DA1F000FF;
	Wed, 16 Sep 2026 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789562409;
	bh=2VfEaYHyIVoe3fw5ftSy9zFU8N1gxbnFTfXwIrFe9uo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JkfV+N+oFrq9B1Uk3LnchmoDzP+hzRJYL7aZ10FpUYvor60wmppvJZH7RV6WjHDFu
	 vfSvQIlVYHtDThN5DPql3HVIkVFzDyjSqc+fZYgr2oK1swS/NnH7Z3/xqrtK4VWcoH
	 RE8f7YgUoywN1A9yRPbOEIEXLCU3ECGb1f7rwVSPA99Se7SUAaxLd8xHDV14yiZUNt
	 FqM4bU3tqNk67os3o+G1d/kBvHK+GJHuoIBKx3Eb98kUw+LzemahlMN44k8q3aFTmj
	 TErI5q8STndz0+Kj3+puhnvT1HrhpOr7JGq5giCos0jHFLoz3tUNXGOUxV2CeISGUk
	 QytjWyxt/H5iA==
Date: Wed, 16 Sep 2026 13:40:04 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH mm-new v3] mm: mincore: use per-vma lock during page
 table walk
Message-ID: <aqqNBHYvB5gsrjBw@gremlin>
References: <20260916043153.2631696-1-wangkefeng.wang@huawei.com>
 <9da6298e-485a-41af-a42f-7dd05c571125@kernel.org>
 <1ddf7304-70d9-4e35-935a-9d622b022e4f@huawei.com>
 <aqp4Uvem1MWQOUZA@gremlin>
 <aqqK378rhs5g7Wua@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqqK378rhs5g7Wua@pedro-suse.tail5790ac.ts.net>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DED3C160003
X-Stat-Signature: nqt1rzo3dprdxsekbqcj64cikmchmtxy
X-Rspam-User: 
X-HE-Tag: 1789562410-38589
X-HE-Meta: U2FsdGVkX18z90+dr0v0ROQjvDs2cCag8z7fzWyRBnQZ7QqvaDYRT7vLWLM7NzpcCqY9TmNVz+wyxT3bJ6FELjqqaFlaeLKZk0UTPnusU8s2WWI1tNJ0t9v86lqfegi/JufAbKmGVqSYkiUzPzlUONDFwY5nrv5Hb8TB+E5ATtslNWofIg6m2X+aJUgxove5e6nBTcNpHLQZiCcX0z1kWqrfhiAFOuw81r6QJmfggv0/nIzP6YMESWPlR7d3YeQXOlTQQLn7CR6CeGmbZ8jwYxVDxsARO4pbUcN9H1x7k8p9J9dL07vGKoFKAS3glHd4lnw4dFoOvCQazy5jzXoQrYeqiVTKlmWEcO7/xTrZwEcjF2IC4SkxHO1FCdPpGp4+OYvm/uHwOhz1dt1NQa3tGysIMIDFLrAMHeC+w0la3MHLrtj8IlaBsfvJTqgoAg9ARytZycwcusGjRc6yv6K/bFrjCih+O8PsX3yb1d0cUGFUOog4cGTTf7wZB62CL/dzygnkDeCmbeksmPnJQTZ0jmfpkdvH1H9skKKCMaKEuf24+09U810ZItkHV3xCwKZlTUUA0Tk06KEAn27iBfK4H+3/5idDf+v7+Xu2gPqMDwpFe08MXHGpYdKSJ06spMa30TtDlomL+gIk2+5FE3neOw89W4XvbxtJyG4d+/9MjKrS+fK72FnjwpHJeEDYwqaU1kgiAfGHwCl6FKni/UNFgC24VKgaTac1sN9kAG/ijfZtBdsF2thX/0Q349pdBR1t3yPltqT14ZjsswlyZqFTBcN6QWw6Y3utkTsQH+rJfy1eS3F5M7bBSKLase6LAwGG6uwaaWGDsEpQ/8EIvyC+d60qXfYysOtUCDiko2NSunvF4jQfaQtfK+0GPWe1aLlSBIk4pOwLnIpJR7c73xWZQ8BjBQdg4QGStwKwPySJDWrxlyi1j0fgixgPJPzf06DngaMsN/w2tQS4OMwLqJI
 B5OfQBez
 PV8Ev7PoKldBxs/kq2dmnPs9tsIvgGrywu1b9XppucBNRFwCI5O/DxXpi0kGHGc47er4u3RX+4WTzY5IjhHT9OKZj+eHW3ywxb+AlZLLRSj5gIeRZkLi3/8BaWhcsuPLkMET3QDDA/rul82t0c+ZUDSb0LhXtsJj5ENUgP9IuFSzaKoR6b54RXli1SW26jbevwfmhddRdTgS/6b6ltEXYojrdQg2mT6l3ncT2USx35uqELQnCty+v1T2IZQeQFpvja/FO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 01:30:53PM +0100, Pedro Falcato wrote:
> On Wed, Sep 16, 2026 at 12:19:50PM +0100, Lorenzo Stoakes (ARM) wrote:
> > <snip>
> > It'd be pretty broken if the VMA lock provided less guarantees than the
> > mmap read lock in VMA-specific operations.
>
> Well, there is one big case where that doesn't happen: cross-VMA operations.
> For which ATM there is no locking scheme for "lock two or more VMAs" so any
> operation loses atomicity.

Right yeah :)

I meant at a VMA granularity.

The /proc/$pid/maps stuff that Suren is doing speaks to the difficulties you
encounter when acquiring a VMA lock over a range of VMAs.

>
> Which isn't a problem here, because mincore() seems to have been written in
> a silly way.

I saw that it was explicitly limited to a single VMA so I wasn't worried about
it ;)

>
> --
> Pedro

--
Cheers, Lorenzo

