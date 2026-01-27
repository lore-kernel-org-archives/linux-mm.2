Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B81F6D2FEF4
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 23:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EE1E6B0089; Tue, 27 Jan 2026 18:15:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6806B008A; Tue, 27 Jan 2026 18:15:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D0B6B008C; Tue, 27 Jan 2026 18:15:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E72356B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:15:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 889AE13AB4D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:15:51 +0000 (UTC)
X-FDA: 84379303302.16.BAC91DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id F0E4EC000E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:15:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OxfFvnVl;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769555750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0y+5SmBqnLzkyAPOZPk2SPnDaVYvk5ZSa8bdyGxT7w=;
	b=CMoKwX7K8DEl8S/Ol1TRYdT1kZrr4r/peFx08dk0D2oYqrOL+/eM1Bwp9e8kAWzLI6OuxK
	zi7+ZLnDEtAB2Fg3Z558uFb9xbitqgFOHojNai0in7MtsvdBNezWMzh46WhJb6jaIrOUz7
	+d3M/IFsuju+GAGcREEZhOu+4aaEuo8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OxfFvnVl;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769555750; a=rsa-sha256;
	cv=none;
	b=VlxnUrKP3OGPGOKQU2T9/Ud2Iy6asPAw7BLYTw37IdH0LBLjZLzVQgWWU4J68Amr+ffcl0
	N02W6qFoXzeSnnM2nMS84tmqnMNTeRSPHJ89Kef7WGPeHEHvZt+o09qTL43Jc9c/b+WcdU
	t+3DNcQxuYf1BWbdkM5STDNnluFe+EY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 68E7A60007;
	Tue, 27 Jan 2026 23:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A7EC116C6;
	Tue, 27 Jan 2026 23:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769555749;
	bh=jAG5EzF+Cm7Ii8y3KSZYdeZ50dIRSVGg+ZhYrx6mE90=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OxfFvnVl6abOeknXe3dQ3T9pkihwDifP+qa56OUrA6XClh4ljf3+9433rMBjsHNa2
	 RkNL6UmpLEJjBsOrNYqNYiN/lHfFv7AQeZH1QOI4dpT0+ENkML/ZFdSLSoh8wRA8Jf
	 nsYKPxApFiiem/5GFPF6SvfBkRfl+qHPNGjqwoNw=
Date: Tue, 27 Jan 2026 15:15:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 maple-tree@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 Matthew Wilcox <willy@infradead.org>, Sidhartha Kumar
 <sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl
 <aliceryhl@google.com>, Kuninori Morimoto
 <kuninori.morimoto.gx@renesas.com>, Geert Uytterhoeven
 <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, Christian Kujau
 <lists@nerdbynature.de>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2 22/29] maple_tree: Use maple copy node for
 mas_wr_rebalance() operation
Message-Id: <20260127151548.b57825c664d36fbff70ffa7c@linux-foundation.org>
In-Reply-To: <bd1c3356-11a1-4d0b-bf58-47eb21bfd24d@sirena.org.uk>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
	<20260121164526.2093265-23-Liam.Howlett@oracle.com>
	<bd1c3356-11a1-4d0b-bf58-47eb21bfd24d@sirena.org.uk>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F0E4EC000E
X-Stat-Signature: 5bhpbemzkmshp94xj7b4rh4rwgigbp1c
X-Rspam-User: 
X-HE-Tag: 1769555749-344000
X-HE-Meta: U2FsdGVkX1/frmJvAIYYBOxUupaUKpdGdFd74Cv/CUPLHQGESymgeRdAaWC5LcYMAjS5gDNWV7wwHKUkgXR1gtKkP2IA0IcfFku7zzigFFNxBy8ai/2QKTmfphB+TmjYGRzNM4stzKlGgYaPu9H3H7knnC6Z+iftc8uleyELkKkRWc6D79zrCl6Uhz9yF73YUuZleRAaXXu8x9xsh4TF711ueH1zFNrLLGL9QdF420PqNPPt9dZaMtK9uc62sJ4c6sK0KRFYBzRQBAOIKs1MBBInrUUpb6xXSEkBRj0eoWegWsHOIrxx/xWafRv2m2d56m+BSHkXbunTDnqSvuHV0uWrR/saceibgGBoOZvGParJ8JPuRmDAMTJShKMItQunfQLuIJ91plEPlvZWfJKSZ9Xa5gi6i9aU/AvtaS8PjxGmct/Sd2CEjviRvSs8+Y0mRpPMHfr+uH2QSitYuazXg02e0N2qAuL6B+GwK1oBKb4r2wiCujqYhZcLZwcd6rsw6gMB43TJOkjncssByPuyo6MUUF5UOmqTYhNS8wrWB2gN/EXiyZ8L80GFkbak8u6jmreby7C+ib5Zmam4o2Qxh2xew2YGwMwS0jlXsCgZppnRRSdYD2DNOkU95uvkKoOv0X7oIOR2jIpqkaz2WbjTIj8NeuXkm+L8SpwUUvwK0Dn4ZeKl6ZF5qqv0k2wibOdCFyBKZwU+E0nrzUS3rBRdywKnTbCusLr1KNFgzV8PBpSfwHwWz8GpUiOEjx2DTL7fC5H7uMjcebYD1daPLJ6Bk8eOnZ4PMZ8ApeOnzqAg4PADQqThoMhN73Og7+vhNzMOoYLEk/+G3P35NeZZgRtN20tKYw4YC45QNo2tq2gPjA0/1X8cNPgT7t0Vf4d4aIwcOWDmTc0rJmblxfZLkn8pyn+3cJGfAkSWzq/Rywnf9NBSIqBcWD6aarR/kzZEoEX5OzNI3YnSujvgKeTH1xF
 iI+MY2Er
 dlSth
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 27 Jan 2026 23:05:48 +0000 Mark Brown <broonie@kernel.org> wrote:

> On Wed, Jan 21, 2026 at 11:45:19AM -0500, Liam R. Howlett wrote:
> > Stop using the maple big node for rebalance operations by changing to
> > more align with spanning store.  The rebalance operation needs its own
> > data calculation in rebalance_data().
> > 
> > In the event of too much data, the rebalance tries to push the data
> > using push_data_sib().  If there is insufficient data, the rebalance
> > operation will rebalance against a sibling (found with rebalance_sib()).
> 
> I'm seeing a test failure in the LTP linkat02 test on arm64 which we're
> also seeing on a range of platforms in the Arm lab.  A NULL pointer
> deference is generated handling the syscall in the updated code (log for
> the actual next-20260126 commit):

Cool, thanks.

Liam, I'll move this series back into mm-new to avoid disrupting
linux-next testing.


