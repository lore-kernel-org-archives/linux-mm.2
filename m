Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E89AFCD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 00:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C6FE6B0096; Thu, 21 May 2026 20:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59F006B0098; Thu, 21 May 2026 20:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4B36B0099; Thu, 21 May 2026 20:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37B006B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:37:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E06DAA074E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:37:26 +0000 (UTC)
X-FDA: 84793192092.30.F8AE569
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3CB7D20009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:37:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="z5SgS/6S";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779410245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vb/NSjxWzcfzykw7RUnxGmgm9FcNB+S5bWotyUmGLbs=;
	b=tKmRdKumIDjXemaccTG24pTxCxZyu01fes2GJpmnpGQDf9f/EN0xonzTCrpXZloo6Vooc4
	SK+XwglWj2fwOMdNJx+t2/CzocqqEiDD1lRMcrKIqJrbWrr+47cqBUdVbDGcI0QZ855EAG
	dvJ2ioOxfYVpnqRvoQ46AYKcu1ryaDk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="z5SgS/6S";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779410245; a=rsa-sha256;
	cv=none;
	b=EJGtTB1XGMmDGroh7tKexEonldDvSBi0ATPrBUQSl7R71VFwKvaszShPDYOywpiGtR7gr0
	/rgpOvTn8dcjo+8/o0uhcczoFsL4NUVULwpsbMtkdS3fFzy5+Pg5jFo3VJ/QD1B+/coRRy
	9TIRWnoBxOypYQ+XjVahjI4SjHYgG2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A36E40C31;
	Fri, 22 May 2026 00:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876041F000E9;
	Fri, 22 May 2026 00:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779410244;
	bh=vb/NSjxWzcfzykw7RUnxGmgm9FcNB+S5bWotyUmGLbs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=z5SgS/6Scs6gzwAzXAZZj1I45LFxR/DzznVoUZCb+cdL3nccZjKp7KpekCUjegkEd
	 /20d6Ebtmf0sLshuUdhOu+VOqnZDAk67uMPWyLjF8bNcvmYBlxAW2ifoZUHhoXwIQo
	 x9V50ZEJUNAglos3nfAHHnv0vxWhBq3joMNAgv6I=
Date: Thu, 21 May 2026 17:37:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Juhyung Park
 <qkrwngud825@gmail.com>, linux-mm@kvack.org, stable@vger.kernel.org, Lu
 Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dan Williams <djbw@kernel.org>, Dave Jiang
 <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
Message-Id: <20260521173723.ab1637d13848fcd2738be480@linux-foundation.org>
In-Reply-To: <78ef8003-9c86-4969-95b9-589127b30be2@intel.com>
References: <20260519151008.1399226-1-qkrwngud825@gmail.com>
	<e9a08bed-3d5f-4606-8d17-80a16a4c82f1@kernel.org>
	<CAD14+f316+wMZNm_sJF6ULRDUD9EbkdecdDwhGQKcsu70Bdp0w@mail.gmail.com>
	<9c0e3e53-d284-4675-89d8-943f93436e07@kernel.org>
	<78ef8003-9c86-4969-95b9-589127b30be2@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: drod94hjrcdrqod6wmsw1ysaqfb1ra6f
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3CB7D20009
X-Rspam-User: 
X-HE-Tag: 1779410245-608687
X-HE-Meta: U2FsdGVkX1+A/h9Ahtq/y7lVq+AbD5vatfbgq1WGGVasGyQZg3oX6tPTUorqlZCA1fRnZ0atvQDX5nCmMc/3Fc1URQMuiab/xeomK6r9PS76bA7a7JDXJAqCkPg8R5/PqozNyiFXTVO7Ya4K8BQ3TPtIX2tu6a+xRwmUEWM3MY6Kvl+1T/4URpzAJoXa2NwLmJCKiSZOnVQvjCVS4WsSTfp39ruR2/biYCVPyRd341vHQA9Q8Z2rRrB6BGcS1iEnnea0nHnuwjfQ3b+ZRYrmk7Di5APMxKLcsJUCW9sk4/a02bC1C37Fam4qfgwn+9MDau2VfkbLgWf8twFIHU10uq3VGP7RCcDiy8m70WKbf6P2Ivp7eO650DWsDye/Rh7UKijpDqjYpgT5osC8+P+M0S8b5FrOH2hKu8aiB704BCqe8o1OULcEN3m70AONeEGMb/8gyKcmv9RS+yNEINp8Cp2JkIEF6M+/uPMWUdtrnw3FTqn+Bear1CCAoBzlhCCeXd73eTpRIqYKTHm7xW+bsrBky/aDy9osSyYuri2b58eqnk6ibcSPYPz+GH2DNyLnGGAncSBWxbzTUinor5sxx/4f9TdCqc0KYWXL+pUpp9qiRspIcG9+F+UULufyWj2pqPydWK4r6j3opWC4/5k2Pf5+4fHinkbnpK/gN5AzTfPZV7e8imvahrZFjKOb1j5HTGLdx5fXENCA2au6hKtrc87o62JZ84SyFrPMTqEAQHDVLpUwu0VSai0/te+m32o9Hd4QvmsYUjJQFYGtB/WqttFC85Dc+LG7Yth3Ftecw3DbjEDKQRooJKiZA4hm7XfPbjSZyZfbZSTx+P7aaIFH1dfdVxa/OTV120Vfy3gJi7GPu9lgklG4/0W+bEcnWKo8cqB/LSsKF061DlsbLRD2jkrXAI77KmRLb+S3ts/cARM2BGUXakTh3jXWyBaa8QX7SJYlg7iKG8ULXxStqif
 7ueD+fDe
 YT5MRsijHxWld27zrCiNFmdBozUKXopXlkClmP03g58gFAJVkIGUlSPhaw/QtWXKUVbLi1RqrRgTGGJA5z4MQ7RU5O4v/REZ1NP00B2mK6wt5FGdp4MJUuWbHEyqmfGIcUPMQ7QRAUSzi4j57bqXN7bdomZAmGBR5szfv3jYngWl8lnBPYd6VWLgpIvcktCqtop+f+1DfGLPIl7F1RkTv6nuy3jMamnahYu3SVJmhR1kLrbt3OVGM33sqRmjTTYtWyhOEsiwfdIqOplsIt3Ck9fIhjfVZDy6WgH8A0uewwwYqLFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 14:54:30 -0700 Dave Hansen <dave.hansen@intel.com> wrote:

> On 5/20/26 14:52, David Hildenbrand (Arm) wrote:
> > On 5/20/26 12:33, Juhyung Park wrote:
> >> Neat. Any sign of it getting merged?
> > I hope it will catch the attention of more x86 maintainers soon 🙂
> 
> David, thanks a ton for that patch. It's in the queue behind a couple of
> other things, but I'll definitely take a look.
> 
> Attention caught, I promise! ;)

Oh, there it is.  I'll add a note to my copy reminding myself that
it'll be upstreamed via the x86 tree.

