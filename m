Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C6AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E251A6B0088; Fri, 10 Jul 2026 05:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD60F6B008A; Fri, 10 Jul 2026 05:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CECE66B008C; Fri, 10 Jul 2026 05:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B11DD6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:13:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4DDDE8BBCD
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:13:05 +0000 (UTC)
X-FDA: 84972302730.18.0316441
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B71C7C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:13:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Zapqd/L+";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783674783;
	b=KmgNVWRAvW01RdWP1IrrdKnfANBfyPI4DSupjVFPmU2XWwH+uHiw/rh5U7fIG99hFak15C
	c7Yn8lwt5MDDZgRbr8P3oGNDb4WtWga7gyABorCidMvpgoqUU0O7c1ovQE+c+cTYSxE7cH
	ZtlRbRINxdr1kiHbjBm7XhdCAVP0QGI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Zapqd/L+";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783674783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4DsWnWasA8h85Gsu5f/xy2b9ecOlCuQy+slRnVs+gQ=;
	b=b3YLp/N5GJ9Gi9Mu+7jesKm9Nc7fRzfofb25KBtTv7F1jtcIAhVuYFnncLmFosDXbXBNa/
	pS9tFuP9S+ejPN/hg2WBqjIzlc+GEp9Z8FziN0AiR6aQ2ai2NVaT3tgsdfuywTb5kPCJ0p
	A9tRpJmZCppSYiw5Rwha5pJ2bUpH59s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8883C403F7;
	Fri, 10 Jul 2026 09:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127BF1F000E9;
	Fri, 10 Jul 2026 09:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783674782;
	bh=u4DsWnWasA8h85Gsu5f/xy2b9ecOlCuQy+slRnVs+gQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zapqd/L+c4EJRqbtdJXls25prmMPM69KR+behI08XwP7Zvf6QZAqU7MiOzZtFHRF/
	 wD4iJaGNt8Adqf0+BR3WQ4gGuuKCKQPbob13gw2XF+IwWUuAJC53l5NtARu5EgnrqO
	 2s+OVM2YpE6+2ky0X8MAtBRzo0TLixGd+xwQf2zQCIqpcqzKd7rH17c8Hq//DpGAjK
	 VX1oMzXzF9r/Ezcb6NoQiu5uEZXcE0v7sYESgSiNwMvQEQUnX9X/cbJYV2J6UjOOxU
	 eKf5qxR79Cu00qV8/YxzDNqW3yviZQ4UK9uTlc9c8F0hRNVzdmRfLpn3XDSxvfvSx2
	 0r8QevW6jbmAA==
Date: Fri, 10 Jul 2026 10:12:47 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: David CARLIER <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dev Jain <dev.jain@arm.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v8] mm: pgtable: free kernel page tables via RCU to fix
 ptdump UAF
Message-ID: <alC3HqLVTBA92Prx@lucifer>
References: <20260706203128.162335-1-devnexen@gmail.com>
 <ak0YI9KjSstnj9rJ@lucifer>
 <CA+XhMqzvFtLq1OT-qh207aJhSf+okdE8o8Joe8e_KBvdCjcQfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+XhMqzvFtLq1OT-qh207aJhSf+okdE8o8Joe8e_KBvdCjcQfQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B71C7C0003
X-Stat-Signature: e8f16ze9rfn4sybf4j1ryigbdwj6i5ty
X-HE-Tag: 1783674783-215310
X-HE-Meta: U2FsdGVkX19zsIVOHWrIYYwyOhStrRhU9V0zVbUHAgPl0ml9Ox61VBKujAE0a8vA1QZxYWjlLftXQ+Vphqb567Cz+Uq9+YyQdSMX/fIFLQSRsSNumdcK51kRDhD3Jpwg6NzwtjYtTYumMDxo+WB9Q6ILX2tYdbn8kTyCk4u/qL/JP5PsFQYfdoNoS4d8SSZ4LZac+xEK4vxLojaZYC6GikRP8SEh+PuDNEQN+Qroi31iOrSff6K9RrPbns/SSB29WJ9i077nxe0oFZYbTP3eilTRRm07SrdGz5VaypnemmE+XpzpyQK3kcpZTLZZcVgvaBgQiENLSHeWzZroEkLmRZ2qjtd0oZQhFSASOhT0NbNVAyafD6KKhStLkDS1lG93N805ISScS2nnj/KagQqWO6mcI4VW4Qd7cyUud4tNuXffoBYginDdptaFmChSa4rIXfvIKpzE4IB5fISvf01qqd4suFGhXquMTGXDPnF0MNlrHWU4gbEt6pTPDrwEXxGYK1qSwEkxufzSVzxueKGBekdyVivcaferrObA3PsV4zKN4SEs1fkol9/Hui9DUlUwzFsTs2i7iR58YbpDNMEqlEWkUi73DGoq9UgN2OM/xsUA1MYQmvCq68AqkVsu9Sykw4C/LCsXRBJhjazZSsR1vnYrygqO0S04HbMpUNoH4gvc7SoUZUqY8T5VAiyc2lVH7Jyp1Dc2P+cukQeA6vdfF1vdCQrsDcHfGF/ddtZUt0eJFXLD1zNaLJnPEJnufNAwrslr6gHgvIQm4eD/siD7X09Ua8tCT9XAoHFurxn2aSQ8ekJXvr2vRBAM5LEuJWmt5OL2w7kztYIUMQcpuA0XN46s6W6+xY2P4fMSEBuyizuDCEyigHzclMXIEI2jMEmzJdAp7kPZcMP+XJ6rUfMBL2w3c7oqNVvbck+1s3yJhGD1yMDWR27+0Vwac3SHWjatCxbq6xTVqE1x5zq5TXy
 t3RJ3LGE
 b2p74Koc47uw2wQS2PB3X/qO+U8tkZ43K8VS9E3IrtYeFaVebe/j08w+IaT3FFUw0IG1zM7fKtghCLUryJksmuwpnGAFS0mQerEvmB9EeIx5+D1GWc0W7yz5eiNetEtI/nTLTLE0kmPFIwRONRIvis7oKLEOY1wCAfG7EWkyQILCFh8hsqxjXcINiVVolVWCFnR39rePuxbl9XthyTr7lBkOzKE3ga7zoV/vpqVyl1PEKtQURD/wQN246z17dDZbZmYCRptYp+CO9MGZGbXEPwBRoH2I39/9FMcmd32Woy4606D9eHC5vcuth/B8mqLfTS2xcNdY1fWHT6JJktjP+BaLIrqNOipfU6jnxOQBv4GQYfbaM4gZGahJ1Qqn7u4eviu3mS6JbNHdLvKT+pWhyb6A8YrrtvFKwcrOz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 06:08:49PM +0100, David CARLIER wrote:
> Sure thing :)
>
> On Tue, 7 Jul 2026 at 16:19, Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > Hi David C,
> >
> > This has been through a lot of revisions so I think for the sake of expediency
> > the best solution here is for me to grab this and fiddle with it a bit then post
> > it out myself.
> >
> > TO BE VERY CLEAR - I will keep your authorship and attribution :), and simply
> > stick my name on a Co-developed-by tag.
> >
> > So this will remain your patch.

Apologies, but the approach I'm taking is very significantly different so it
would be problematic in terms of patch provenance to do this :(

I will make sure to credit you directly in the commit message so there is proper
attribution, this patch and follow up stuff has grown a lot (been working on it
all of yesterday afternoon/evening + this morning) and need to ensure the stable
stuff is backported etc.

Thanks for your contributions here, very much appreciated, and sorry to have
messed you about on this!

Cheers, Lorenzo

