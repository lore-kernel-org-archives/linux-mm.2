Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93180CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 18:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFF078E0009; Mon, 20 Oct 2025 14:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAF4D8E0002; Mon, 20 Oct 2025 14:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E4F8E0009; Mon, 20 Oct 2025 14:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C528F8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:13:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D0531DF4C5
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:13:09 +0000 (UTC)
X-FDA: 84019289298.19.852C5E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id BDD9840003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:13:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VZtyQQ3n;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760983987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MApuaCIAeV7AMsv0DP3DwjkpdF4L0tExAatI0wVwJU4=;
	b=c3Ev7l2TZf9p44WZBCNAE8ximhw4OBPLP8KKoQEE6MsfRRQTp/qVt/o4Eu3bOYZKBBLtmY
	M48Mmu3ifk5MIxbPmHootgAAbIjSBi8adbMWywLoIQsy3PsK2b+5NFGGZzje1zmJpjl/oo
	IJ3OrBMEU4lmKwwFWpHYKqcheirN8tk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VZtyQQ3n;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760983987; a=rsa-sha256;
	cv=none;
	b=bUWBzL6Oh0B/uLf7ng2oHbJcUw6ocrrvCc6kR2EUtUsiOSZDaiBQZuovwGT72KmeCPn0vf
	3wXgw7pxn/ew/I8yACl36Z/eHmu85RiNKLqmY9gVksj1gDzmv5bVnTpjxQu1y+VpTovqCX
	U9hY8MDZslqw/l6ygvbU4Y6e1jjp+pk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F0E1D620DF;
	Mon, 20 Oct 2025 18:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2739BC4CEF9;
	Mon, 20 Oct 2025 18:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760983986;
	bh=j7luj4XAb4ynLV8eONK0lTkWrRoe+RhoyCODmNv+y1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VZtyQQ3nD5oN+qtaEmIPfZybDgLjmIo0NNlWUgDn+gwy+1fGDCazcDPtuxajmmLkJ
	 mFrSnihA0DIRn10GaytskPJlK+7+zvVcGmuHYAtAaAYUZ6tey/ddGIBFa9iy5HNjW9
	 8vsPUSfR6nh7clRy41g/MnzRjtRLPowuK0xwRiyBG2zVm7IYEi8/+OxbtTbmffk9QJ
	 LLc598HBkww2ZlDBkDm0skDd6DClFK6Ojpt9ZUuPnNptCWLrQ9e4On5ab08izr5svZ
	 9LEHOZueUJzBtluHXKXOAm0irIbra43PmnuEurT8vYGAEFSRRthrKKb40WstS0jmod
	 aC77Vz9N3UQSg==
Date: Mon, 20 Oct 2025 21:12:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org, jasonmiu@google.com,
	dmatlack@google.com, skhawaja@google.com
Subject: Re: [PATCH v6 00/10] liveupdate: Rework KHO for in-kernel users &
 Fix memory corruption
Message-ID: <aPZ7qa-Gs4OPLhsT@kernel.org>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
 <aPXz-IPDRniMHN0u@kernel.org>
 <CA+CK2bDMc8RdcNq_qmmW02DNzLePxQNWBgdOuwrfJ=jmr0YK8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bDMc8RdcNq_qmmW02DNzLePxQNWBgdOuwrfJ=jmr0YK8w@mail.gmail.com>
X-Rspamd-Queue-Id: BDD9840003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 36f7s5rb44wkj9aw1a916xeh4pp4zmek
X-HE-Tag: 1760983987-662869
X-HE-Meta: U2FsdGVkX1/RXaQK65uFIaq31SDjAi2rJlxAmIvxFwZVefeB/sBs1R6lGsZtBaRJBVyrjjUw2vumMrWahNBpUN+rwS3x+nOmFaQw7dncL1G6EyShmktcslDSX6Nzs94n7P05JCIzF1VhEqFW9vu9ihDzC/3t8nokuafplXs6wX0zv5gdY+o9dspL1/VfD+ALh8x9Oe1OKhwp5MiHwDwg9q8/TlGv8RzauBi0Yubu8DUzTWztFKtq9r2cWtEaf1COJUZsFy7pKRiX+iC7LJN08RlCDKetq01aK7URfMTVENDRxKKc+oK8oA4TnZLim22bL1hZJ3s0VSBq4dN4jnPtcRvddIGYJIDDut+DUwMPNaaYtoY4YGrP6Irnp+7AfhFFphSA0gBqa+yINtlr5ezQ+oLn79numOVgZ2kU/mWRNOCWEJFYWaZP/DsL8A3qheuV1FrpeFgCV0XIKMY76j6JSs2l26laYBqjUNJxGbJnsxdHhqoL0Y7fhrCAEfU/ym90uMlHQZY1At/pvxGW6Fl9QFhq5vGLiVhD/jdQ6K8A70ru/xn/JkBWOm8nLE5gc9cc/qxctTYlWuL8dlqm1qrU6FAx9W7TyIQtAsF0mLOf1kg+kTmSckmGdKEup1tOH+e3yjnbyrRSHWvn772fAsxC85yhSLYK3MMAfSXrDFm7+GaJRx+cHkq7/RkUBlFrT3NffToFNiLCMSvxv+Jrc6bmWJ5L56Il/pXVUUCqRftcxYTdZ+wX73MJNrlQJXq8a6MPf9XhkWo3t6usuaUDbXdKFMT5lt3E/nL7a2Afm1nUfDaF6MTfnA8XaI0rAaXOq7JmmGeL6Si6HPt3pEFuAz1xNiYblGXqh/DwqnZ+ghtnVREhXfVUK1pBbfrNXX6l8C82UuNWqaO6wve04nZBmMk3GhMr3STo6CFg/Lqxy5IQjCABCxnMyUxG/m8iRI+4Nb2koD8/SIoNtHgCjAQSvdB
 P/OQsPEz
 Cjn6lbHjfCJIGxlQJOgpo5LynIQdLu9GY9FlRCPSJZepzXdOCoho+cuxaM7gA6JpwsLYb0O7HpYqNigR2AX8tlXFEvsfsomuZ9AbotoFsS6bc9fNYxDBeDKcy7U43u7y3xXCKR0SeUUp/6014utBYoW1CZCEWOmn4tVIZFa2D6CbndNE740ojtFAkgJpNHKmLGKEe5SIckpNNg4EtK6lYW7ZhqqkY31gUxo5QFVO4K/MC5ZRQRYErtVAGuCshy9vZsxbd9VLQ7Y5tXQCi8NE+LnYy7638i07/fHFwHb3cx5O+kDdqci96Sdc02lAWLnkgG8HyC+VO8VI2/i8OW6faNRCsLWeKmM8xyy79v/5IXfEO/LQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 09:46:17AM -0400, Pasha Tatashin wrote:
> On Mon, Oct 20, 2025 at 4:34 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Sat, Oct 18, 2025 at 01:17:46PM -0400, Pasha Tatashin wrote:
> > > This series addresses comments and combines into one the two
> > > series [1] and [2], and adds review-bys.
> > >
> > > This series refactors the KHO framework to better support in-kernel
> > > users like the upcoming LUO. The current design, which relies on a
> > > notifier chain and debugfs for control, is too restrictive for direct
> > > programmatic use.
> > >
> > > The core of this rework is the removal of the notifier chain in favor of
> > > a direct registration API. This decouples clients from the shutdown-time
> > > finalization sequence, allowing them to manage their preserved state
> > > more flexibly and at any time.
> > >
> > > Also, this series fixes a memory corruption bug in KHO that occurs when
> > > KFENCE is enabled.
> > >
> > > The root cause is that KHO metadata, allocated via kzalloc(), can be
> > > randomly serviced by kfence_alloc(). When a kernel boots via KHO, the
> > > early memblock allocator is restricted to a "scratch area". This forces
> > > the KFENCE pool to be allocated within this scratch area, creating a
> > > conflict. If KHO metadata is subsequently placed in this pool, it gets
> > > corrupted during the next kexec operation.
> > >
> > > [1] https://lore.kernel.org/all/20251007033100.836886-1-pasha.tatashin@soleen.com
> > > [2] https://lore.kernel.org/all/20251015053121.3978358-1-pasha.tatashin@soleen.com
> > >
> > > Mike Rapoport (Microsoft) (1):
> > >   kho: drop notifiers
> > >
> > > Pasha Tatashin (9):
> > >   kho: allow to drive kho from within kernel
> > >   kho: make debugfs interface optional
> > >   kho: add interfaces to unpreserve folios and page ranes
> > >   kho: don't unpreserve memory during abort
> > >   liveupdate: kho: move to kernel/liveupdate
> > >   kho: move kho debugfs directory to liveupdate
> > >   liveupdate: kho: warn and fail on metadata or preserved memory in scratch area
> > >   liveupdate: kho: Increase metadata bitmap size to PAGE_SIZE
> > >   liveupdate: kho: allocate metadata directly from the buddy allocator
> >
> > The fixes should go before the preparation for LUO or even better as a
> > separate series.
> >
> > I've reread the LUO preparation patches and I don't think they are useful
> > on their own. They introduce a couple of unused interfaces and I think it's
> > better to have them along with the rest of LUO patches.
> 
> Pulling them out to apply fixes separately feels counterproductive,
> especially since we agreed to add the new kexec_handover_debug.c file.
> The most straightforward path is to build on what's already in -next.
> Let's stick with the current approach.

The fixes are 6.18 material, the LUO preparation is 6.19 material.
 
> Thanks,
> Pasha
> 
> >
> > --
> > Sincerely yours,
> > Mike.

-- 
Sincerely yours,
Mike.

