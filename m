Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5285EE83EE5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 07:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27316B0096; Wed,  4 Feb 2026 02:40:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA656B0098; Wed,  4 Feb 2026 02:40:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A98E6B0099; Wed,  4 Feb 2026 02:40:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85AAB6B0096
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:40:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24CD958C3B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:40:07 +0000 (UTC)
X-FDA: 84405975654.27.FC195EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7288EC000D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:40:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jvnootsH;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770190805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrCrHu45f6XTw9L4zOJW02CMvSOp5gMXN+ZtiD4ZWrs=;
	b=ZmSVoGW1e1XSysOhSqzxYnl0Mq1Tuwu8K4p2XZ4a9UCZQltn+rSsFoIGdhDfpN5eSGZOMt
	Efpa2ofvTEzt0coviacZmnbghF5wi+bN/ejXYEqk0+rvpV0nR2/XfJg6rSfZjC8yadreLN
	EmJk4Hd9G1YsELp30cm17f3WM/jbId4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770190805; a=rsa-sha256;
	cv=none;
	b=Y3z/QsWfDKVnENl/vV7QK6pc8XTQ3se3BXE2Cn0g0A90n8POLbvDb0ky0oN6z/qwbZoQbI
	6PHZF7jtRr2rCVsv0cCGsj+njwVabfO+YhdvCvmjr+oThd1ol0z0/3yDDhoRHHX6v8qMEF
	9s20Lh1NKP6S8d+GGD21nucR4II0SgU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jvnootsH;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A0B2C60054;
	Wed,  4 Feb 2026 07:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD52C4CEF7;
	Wed,  4 Feb 2026 07:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770190804;
	bh=vzbSaJNKR+rpV49HFNHw52Ph7PvyREVWfxF2vvCj64Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jvnootsHf44SEaxRydr3AI21+hmKRzra+Mdzhito7HfCNOsFOXGB1uxofbVEuPR+P
	 JqsqxJ4HAdEZjHXXdVvrs3lIKCPb8YTnYDv3OregiTr//wSsxZfB1atX7/cYWFw3g/
	 A3ekjixeyjvhTtI7Ojg5ldIVq952Fn/YvsC4XKrF4pR2cxZ0TFTDzLvG1hpaWxQFrP
	 Kf9XovBKIJMIN+/4BIbf0j0PoCPZv5gaNZwxO5sXih/VSOvZygss6KNygKLH2f9YrD
	 +M7gSNK+iV6yZCmisRyKvVxQenHVbeaXcfqHmvRHYBldjnYiqQB9alRZs3gft/QkHM
	 VTv1pvXoKELgQ==
Date: Wed, 4 Feb 2026 09:39:59 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
Message-ID: <aYL3zxuTLT8N7C8-@kernel.org>
References: <ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
 <aYJBBs17B-SQXFqq@kernel.org>
 <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
X-Rspamd-Queue-Id: 7288EC000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rm6e4dzqsg6ohpuxngaoqgeqpaoi3pis
X-HE-Tag: 1770190805-870923
X-HE-Meta: U2FsdGVkX199rqg91sabl2ItsFlshApSdCEZU6GdofZSYjLhKjBxdshNG1QeqfWP8tcXNoDLfmUL2fBr1fy6Ql6gB9Q1s4hDODLAhX+d+796GIs9Cfjm6Jbc9OamCc2CvS35N3k99bh1o1a4BXM+d27yDahMuCXhsAK1G/+s3g0ZXyS5oNYTb7Qpjd2OtI/sN5ZPW1/KH6VKfZzHVnz7jv498l1mB5nAG9ZnVgjszik17mMiBqvJ5OvB1WxKt49E5NDXlx+zg/BsLi0RQUMHm2BQbg4n6uy1iqlyq7JlTJ4UcxPwYBW/EhDSUtNHTQ/5ZzvGeA2jEGYy34QWEoHkHyMPW6ASa8O4n+VakRbIS6TiOVmJVuMDx/Alq4AcVzGH+M/MihVdtLwBvSQ1n53Yu0iMWG0F6nfhj3JzjcbDHxh0eOa8u9rze98y+U16SsAEP0U3RLU9BIWKBJBsT09OWK5+eNext0UHEzudQdSzRm5g/nNn9pjs0VOdAUapGfkVW78xg3fkzoiq+E6h9QxnU/U5Q7VBR/vLeIvY9ru4miEs2VcuEeaeif+0aC28T+kzg4BCab8eiUUokDN9MamLL5AQyHnj2rkexrFRPX1qa1rej1pydR4BWG7NaGc+80caqbl98b6wW6Zt5e6JCRckUO3nGSFarTxApeoIZ4z2b1ytAJujrynO38IYsBcP6jJvW4voKisiBZJfe8MMmTn9fRlif8O2NRT0Yn9B/mmk8rELt5oWqJldBw3egukb0LUziAZB1+wZEakl/miTQVJu3KUaxsMnc3PRET7+9jzZ6FRQ8KtomheVTTZxV4+azPKYaA/pU13l+Q/fxtXW5dMMaOXseW9/tTivBegrKreR2PoIMWRW/amQvDMy2k98e2JlrtwjakUmwLKPnRY0tkAyRfcAj3Ez3jfd+4NlVJJZ5wXuFSdU65WPCgUYeFqGsQu3XC87bGSXWSmWRKVrrmc
 zgAerA+e
 Fc09OaVenKluzoCSh95I1EoKbUh1yE6vwU9KAI6LR4t8EgKsQiIE21AY6/RE/JVFEXZ8787s5YDUyqRvd+i780r/6XGz1zqQqjGg3cz1C232iq0BKBxUU/9gkhxaoSwagKYpjfHjXXCSyyDS16GeynIaFNvgtw0b12b5+zxNmFxaq7Ad7iqLI+8jg61j3eA8hbisJZYwDfAVDX5mA2ITywr8acIYKA+GV5Q8K+AC05FNpMrLU9y5xhNdaBN+poSGO9wJqKt5co6VPfXrDAg9lJGvNRMrtChQZLNdRiu48QCS9KRAxXaEMNK6CeDtVxL+PJz3F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 06:53:29AM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2026-02-03 at 20:40 +0200, Mike Rapoport wrote:
> > >  void __init memblock_free_pages(struct page *page, unsigned long pfn,
> > > -							unsigned int
> > > order)
> > > +				unsigned int order, bool reserved)
> > 
> > I've been thinking about after more coffee after our chat on IRC, and I
> > believe we don't need the bool reserved here.
> > 
> > Since the assumption that memblock_free_late() should be called only after
> > buddy is initialized, all the reserved pages should have their memmap setup
> > with PG_Reserved set. So we can use PageReserved() instead of passing the
> > boolean.
> 
> What about free_low_memory_core_early() -> 
>              __free_memory_core() ->
>                __free_pages_memory() ->
>                  memblock_free_pages() ?
> 
> I might be missing something but I don't see what would restrict this
> to the early pre-initialized struct pages other than that
> early_page_initialised() test, so we can't rely on anything in struct
> page inside memblock_free_pages().

Right, we can't rely on PG_Reserved being cleared for uninitialized pages :/

But I overlooked an easier and actually reliable way: use
free_reserved_area() instead of memblock_free_late().

> Cheers,
> Ben.

-- 
Sincerely yours,
Mike.

