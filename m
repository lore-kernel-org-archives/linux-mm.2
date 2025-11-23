Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED7CFCFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 19:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429C46B002A; Sun, 23 Nov 2025 14:55:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9C26B002B; Sun, 23 Nov 2025 14:55:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316266B002C; Sun, 23 Nov 2025 14:55:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 214A36B002A
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:55:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99E9A1DE61B
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:55:15 +0000 (UTC)
X-FDA: 84142925790.08.41B7EFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id DEC8C10000C
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:55:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=skTlV8tc;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763927714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONzvLa3ZaViSZ5gG52gKU5AhTjht5Jg3NT5f81KKlSw=;
	b=fjpW4tzvbg24H3HW5UUrGKE11CFoqmqla00tDbI2prfkdIGMmGd/QEbBHgfBRSsJPL31yC
	41Em//QKNjAt8zlFtksgFcfHB3GfMVuVKszmpCIxSrwEoKR7sTJT2s33E4XdPTInpqqVDu
	KxB5bxVOYrB3DMIEd3aomHhTb1WefQE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763927714; a=rsa-sha256;
	cv=none;
	b=jOWi37oAlwPiBlRBgIJHXJefiAGfCB5kerYBDzyfx2IbkDBKZZDJkNuLw0dnL8bAXMRBIB
	rPQNcJ6rGy5ijFqM+45KC1k0wFofajxpPxJ+QbUOOvaY9k3zsdz4VVIu0D3yIHxZSs8YrO
	jqTHPKUSQCvW/LZWcgcqhOjNKLtH0p0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=skTlV8tc;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EFCF43699;
	Sun, 23 Nov 2025 19:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75FCC113D0;
	Sun, 23 Nov 2025 19:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763927712;
	bh=ONzvLa3ZaViSZ5gG52gKU5AhTjht5Jg3NT5f81KKlSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skTlV8tcUzDnx2NS3oZTafwFn37YIjjnSUVdOBv824NMHQ+dj9G0HAp8SEFSOrXTa
	 Vm6RwVSDxdU5umROdYBSsirLxayteUVafAXZo3AbG60PFDpUDeajJitU5UVbG+3IfZ
	 g8WG5HQIiQbHNZMhqCBJcFzTEHG0oL1zdIloVCRxiKWjWLZW0yTUrbXFRsbqmYv37M
	 WTD7XlpSEIi5yc+d/whvBmMDK6vGXzlC0vRmzxl96b8QjYTOjfl+ZhGT7Hx2zdklFM
	 izzBK/4PQb53PSkWoUsuMoOAcfpOPln+yrqaS8MfKbN8s0TcIQE403itH1Sw6ViSWq
	 Nm1xpdMvXtnRg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/12] mm/damos/stat: introduce nr_snapshots, max_nr_snapshots and tracepoint
Date: Sun, 23 Nov 2025 11:54:55 -0800
Message-ID: <20251123195456.24755-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251123184329.85287-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e7iwp8akaxr9acjpm7woqde9qk6q1nhw
X-Rspam-User: 
X-Rspamd-Queue-Id: DEC8C10000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1763927713-5759
X-HE-Meta: U2FsdGVkX1/1yfoaovKs/RjMrsEjD2LF0vbiOf4lbkcLA4188LxB/Jd095x+3viKadkf8blD0Jh0oeXBETfnWG+t2XSnKIycQSgqGQADfsWm7qJeFHy3IDv779xNVSdUvVvPsKYOE/bLc7W5CNyPHa3G5reFeDwrXxuAswQMDGhfxYPAhU7AAJ4c5GwrTeH1dgUh4JSkUpDNa2K7ygo2WTz58Y0VAT4R9lTO89Yn/nHtdWUcLHGLLdc3jNFSq1QbsgWUSTg3OxiT8ya/Ijtpr3MD1f4rR5XyujzAVVQZBNcHxu+1ATeWTsG4k9OFH8X+7F4BIb+5p7ePDqsNKIwU3ECyZCDnImqRfyzzrYOl/GI0JfL/bzLreTAwtJfqxuY3hNqWCed76LK6cqXLwWpxy4DzWsUHQwvl2OOyKkQ9dzX1PJcW850cWNlBlV6Ma9JEBQ2xQcVBltelZ9AjVNKo2APtcsaciC7rrL/2PQ4d35aRwYfxdQouXgpWJJYB7LGnZHM9tiOFcomG2GLb5TgP/32PLxlhGBxWANTnzkbd+Rdf2AA8fEyQvTp2aPVkcodmaooGTL+/iWUCnLmKk22dw5WcGVbnmABBclhlz8ikbyMSCltXtUhOQ9hJhKonsRMC5lQID71ByCQOnNhuQyAiCUobuZ2JCFTFsbXuXlKUDU/wY8eFSTCvunwHHc37vqGVFnOQbz6sNCoT+MpF1cSw//uA0kf77h6BdVyGCl3ZI5qzxW58Ex6ejUBHuuVy7NxSqk1EIglauntkmpwhQA5SAcwCBdVC00M1kJfWGE1P2l/XRUdV0pBxtlP+RF3d9NSDkDgha0ysC+sIKC0AWnD1eZkL6XEZyVm6p5OetfGRA2GkmFLTX5oqemYvuJpE8D18KwvTev/1PoThkN65/H6Ar/ugfpMRJavZs+eee2ZPnaz9Sk1TwAi/PqlMJ5loILUoAUjlunLI47cjHB2kshB
 4axsHdLn
 Mpvs3j1EoLS8Mncz8m+n6h+uWWR6QZ2XR4BN8fNYUUekCsTqcrD9zE/2cvIHsBowwPoooCAcq8ECs7Ly0GdMODcsLVe+w1XtpuInxXeFh5kwaANVcVZElez2A8BbWGVDG08+UZT8G8OsX76Zgxe33q4DtrSWDW3sW56+M2xUlrXTXpBXUL5Izx/kbj/cRNxj/1i46CscGy2ZEMWZYmlUG7MRLMEynPYhgI3oT8XC68ptWtWwwe7OVz7TaFoqbG9qORNxUDD7AHhXr0ptsQwxXsw95gg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 23 Nov 2025 10:43:14 -0800 SeongJae Park <sj@kernel.org> wrote:

> Introduce three changes for improving DAMOS stat's provided information,
> deterministic control, and reading usability.

FYI, I'm not aiming to make this be merged in 6.19-rc1.


Thanks,
SJ

[...]

