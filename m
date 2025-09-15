Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8870DCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B5C8E000A; Mon, 15 Sep 2025 15:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12C88E0001; Mon, 15 Sep 2025 15:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28B28E000A; Mon, 15 Sep 2025 15:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBA0F8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:37:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54249BA166
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:37:08 +0000 (UTC)
X-FDA: 83892492936.29.48D56EF
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6979518000D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:37:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hdxpg6HJ;
	spf=pass (imf24.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757965026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXeOMSLnAh+Y5BeziIMqNMvsY4xASMxyysnTBr1a6P8=;
	b=7IN9fnyQNlfllFLyDh6jfsP1GiMVVqL13dJkFCXz0mP0VTiOYeIAjhj8920agsEX8LoLQU
	sinR0gVMtc8Q8QNrq2kOf4b6IvO5NkEIsebVi8H20FnNdwnMS6h03VjqfLwELdU9bSIs/L
	oHz5HVy51jOCGJtl8Nhc3LEjSeamZfU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hdxpg6HJ;
	spf=pass (imf24.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757965026; a=rsa-sha256;
	cv=none;
	b=YSXGhLSxBipPbotu61NSF+THhgr5y0EkshGQZ+7SNEyoxtHQgDvKwEw2zNMRy/566MFEze
	L5ZGj5Tyx2X9uHtPfJv10wZCviULu4EHGqq6SRj8hBEdyOe7sLEDoktnxv/B4CHzil0KTO
	25EbvmS+TJuEecSh6YXTslruKMGYPgg=
Date: Mon, 15 Sep 2025 19:37:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757965024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GXeOMSLnAh+Y5BeziIMqNMvsY4xASMxyysnTBr1a6P8=;
	b=hdxpg6HJbWKd4pRTY2Hd5oB70cnSFLXa36br3d7dKMYl72300kdFaP5zfRq7Q6q4nlRaEA
	4DOx7PlgtzfHi2setFqia0My7+dt9YTX2+tk1l0wIUwOL50fBEgDJmx2i7rzH5wy+Nk5e/
	cnTCzEoFO7YEnZjk+RxhybjIQYLYQA8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Vlastimil Babka <vbabka@suse.cz>, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] mm: remove zpool
Message-ID: <fui4gqm6pealaxooz3xv3dnnqxscefyvhw5bhntedwh4tgjvdq@ootmbuoc3dpa>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
 <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
 <girukcvvzgbtkxt4aftfz3lw3glvf2qsof4mx6wf5perolck5n@vaxlrtaeuzw7>
 <dh74mr7bjtpzk7frviv6iqqno2u2b27p7jiagp2dtnsz2wrfhr@wlb5vqg4majs>
 <tbvushbdn7nzitey3uy6humdndd6247r4544ngqkds3cr447e6@prnla4edwxmk>
 <f3ufcsjvvxhi5gzw2wglkpedgyyi6tiaje7em3tbxkzhklphvh@sv3dbo4yba5p>
 <98B3AFB0-EBD5-4779-A5DB-FFA6717E83C3@konsulko.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <98B3AFB0-EBD5-4779-A5DB-FFA6717E83C3@konsulko.se>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6979518000D
X-Stat-Signature: dibet3caksysk4ux1jmfg769i48uc7jg
X-HE-Tag: 1757965026-859260
X-HE-Meta: U2FsdGVkX19Cc+XM2+5WD3VKMG4Vu9JCyUlM9hNKqvnrfhyV7PeWdPKFQ0m+LKEalAf1J4v3dNQlLlOHCYmJLzgjROQ8iSH6pLf82ZLBvigkBDYYcXpRlqZgmXqjrpvDc4HCgYW/GRjx8gYSBdL1APDOdqUdPdlS+F+8G0T76Nuqe5kRpE4P5qDvzdMv3oEL9pIPmQK6HsUOuILTdXcilZM5V/a0TrpVhuOpDGX1IhUR3ba/6/7Vf/FA/eHs3XdoK1tenljnttvRW2T8J2s4wHCF4gpJ0lRnn3XmiVzFNTHJ8LnhZ9W2z4IDkVo067EdjsajyW0FxOje7MM+5aarjVNhExi/29kn7q5rctIgX5ywsmk8Yxu6b3fIKiWv0IgyRqBgbZd3CAruiqBlT/Fuh8F3N5CE0Xob6q7jko5yd8W5qtzGT+R/Q2vDfTov537L0/3JRxCqTlnnYCFaGulJHlTeJxdCXcmtxs2OOGoZh7xdwdZjbqZCqDp4nkGmpVOLvxSZTixKKM1BsLPfj3uCzNcCX1FkTP9Zgp7cYIU7nQ5QfwXFgESJg9DqBSsRpW58RNfCtSrn/BZHY7Xci877HMabipjOIdBtc/0JqxnFr29EJe+wvE9kuhWv7zoVCr6zCH54MpSHWnIBDnXnCS2JDhMQCzBF/rV/EuSbye0eoYDIa46RM/5iO6Snj2cpwllV+cHg2fw08jQCiMyxDKgi1v/du8q/3KCmawDd8cOgNSAxfjaBrgYSvDK/LDXEQCu/joR7RvSanSpKZEgObR6L2sAfeiZUyM5vKgA6+8arBw8Whe4V5C3MCPjVEc9/LckTYb8VcP4Dx3bpqOLAn9B7REdEqEhoIRzZOp3kJgeiv9210ztDFFsTP/BAAH1WWBe52knzGlgVQmhyktAFEU5bWqhEcQzWGc+ZbThWCGedH2s5EjfOj1Qm83v7+rzvouzyH9geaHTxlB6sVpoGLjO
 hi1/nN18
 APpXxjW81OWKUCnpcLiWoSYOplitSB8GYx5HaY/LCQgM0a27VbdoVg7LltB0PJWWqRN6qgLLLsd7Z8bdCqKDMEFd4gH4TocrZu4MXQje/hUZhxQBEYkXSe/fKMmTlwL3UOom7QQTlJcd71V/lpkamh/WgbHuBDOrjg6srjMQj8PK0DFKFjpqc0mh0z50DH3HtuV+8gIgEBJWxp71yyKv1LQQcmf7xnIcDAstQDk3/gYBq480=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 13, 2025 at 03:55:16PM +0200, Vitaly Wool wrote:
> 
> 
> > On Sep 9, 2025, at 10:12 PM, Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
> > 
> > On Mon, Sep 08, 2025 at 09:18:01PM +0900, Sergey Senozhatsky wrote:
> >> On (25/09/06 14:25), Sergey Senozhatsky wrote:
> >>> On (25/09/05 19:57), Yosry Ahmed wrote:
> >>>> I think Android uses zram+zsmalloc with 16K pages. Perhaps Sergey could
> >>>> confirm.
> >>> 
> >>> I'm not working on android directly,
> >>> 
> >>> I can confirm that android uses zram+zsmalloc.  As of 16K pages, there
> >>> was a way to toggle 16k pages on android (via system settings), I don't
> >>> know if this is the default now.
> >> 
> >> While I don't know what zsmalloc struggles Vitaly is referring to in
> >> particular, off the top of my head, zsmalloc does memcpy()'s for objects
> >> that span multiple pages, when zsmalloc kmap()'s both physical pages and
> >> memcpy()'s chunks of the object into a provided buffer. With 16K pages
> >> we can have rather larger compressed objects, so those memcpy() are likely
> >> more visible.  Attacking this would be a good idea, I guess.
> > 
> > Yeah I personally think attacking whatever problems zsmalloc has with
> > 16K pages is the way to go.
> 
> Well, there is a way out for 16+K pages, that being:
> * restricting zsmalloc to not have objects spanning across 2 pages
> * reworking size_classes based allocation to have uneven steps
> * as a result of the above, organising binary search for the right size object
> 
> This will effectively turn zsmalloc into zblock, with some extra cruft that makes it far less comprehensible.

I think the way to go would be this, identifying problems with 16K on
zsmalloc, and addressing them one by one in a data-driven way.

I don't believe there will be opposition to this, or even adding more
tunables / config options to alter zsmalloc's behavior based on the
environment. If there's indeed extra cruft, we can either clean it up or
hide it behind config/tunabels so that it's only enabled when needed.

> 
> Another option would be to leave zsmalloc do its job on 4K pages and use zblock for bigger pages. But it is not possible at the moment because zpool api has been removed. Thats’s why I NACK’ed the zpool removal, at least until we have a replacement for it ready.

I think having a separate allocator that's better for each page size is
not a good option tbh.

