Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0798DCA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 08:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 033076B008A; Sat, 10 Oct 2026 04:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F264D6B008C; Sat, 10 Oct 2026 04:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3C0E6B0092; Sat, 10 Oct 2026 04:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C32B56B008A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:37:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9EB65C07FE
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:37:57 +0000 (UTC)
X-FDA: 85306063794.18.0D4429D
Received: from mta1.migadu.com (out-169.mta1.migadu.com [95.215.58.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id EB91540006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:37:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QBA7G/g8";
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791621475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PRO4n3F+OyGen9J5HY+faBhF6ZEkZwsHa88ihF2mE0=;
	b=lyKqxZ3uqsTBlPhEeA37CnEhhV81SFtatkp76lvyC36Phry20ghx2J+69VDy8sFwavvE4y
	xSX++tXPVa9Yi6WTAKTJ0a2uC/+OOYAlRm/AxutzmUEaToLNjVeOPYfH9zOspadGD57LC3
	cr+UdJylms6/wO5io51ZEinridVu1AQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791621475;
	b=IzNw3NSV4brBFFmf4KTg/h0PxqGBzcTMjDh+plZppcHry1+qj5BAngx27hDscc6tKUHbTM
	YTSO+aq9tK/M1TCWlitTamGDRVTCdbJ5CojseIZZQzCUJxHPIPx20lC0WI8KpQtxlNTaPo
	BhBE614jgdN3kL9it3IFGhaOol7DjKc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QBA7G/g8";
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+PRO4n3F+OyGen9J5HY+faBhF6ZEkZwsHa88ihF2mE0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791621472; v=1; x=1792226272;
 b=QBA7G/g8sj2aYCkQ/RrD4TBG3enwlM+9wuP8ceggjgLRHL+yuZGvT8v9XkQ09Vou5kbLFuPe
 eb7prH1fGSWih6UfTArfuOJevMeCkymOpNIFhdYM/D22cAkgVDsG1mr+XZJM5OVPmiPGxFvWHoj
 1zfdabbJKhtVYlFfGxS7mzpM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 15e719b1ad28d653;
	Sat, 10 Oct 2026 08:37:51 +0000
X-Mizu-Trace-ID: 15e719b1ad28d653
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v4 3/6] mm/sparse-vmemmap: drop Device DAX-specific
 population path
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261010075755.83339-4-songmuchun@bytedance.com>
Date: Sat, 10 Oct 2026 16:37:35 +0800
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Ritesh Harjani <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Lance Yang <lance.yang@linux.dev>,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <42099448-FB7B-4885-9DE3-DBB6C96B88FF@linux.dev>
References: <20261010075755.83339-1-songmuchun@bytedance.com>
 <20261010075755.83339-4-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: EB91540006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 38epeowjpxedus83r7o85ymthkr6utxj
X-HE-Tag: 1791621473-301115
X-HE-Meta: U2FsdGVkX18ukDRzPGLo66PpRmYCcM3A0T53HExRWxjj+ooLP7aachDxBnCfxK/JYwDsYkKIGDcmlu8x72zKVBcBHNPZ10reyx0Z9bWjfYL6SbcoMl+LqnQ1pW+orFM4IQAxqZixArU9YDBOqnSAzgrBba1COQ/Jnnsmy5sEQHeM+KOQULzlCX9CvIlRRUuZ30RHqRHBsFty3Y6lCvK1Ghwr0G87fPxloO5MBcezKz4iEGRhbh6jKme44TlIuho/YEAItMu2N5MIlJVEIdW9It+sJZUiu2wCRgAZgxIN9mEOXTjdnk7cISsMcLtnkE8sLTqAyTNX8/E0yrwqoe92JZnD1+Xr8nsqEQ+J36VnSwbZ+0QttFraL2M7MYE1gSGWkcDHKXhrfT3c3Kp8ZGiwq1R7mGIJYAhvNJponA24XKEi10xg3m/x02d0F/qPlVjjGATCOwzLx7I/NCKoAB17VpCvBZgOrY0qm1wDIw6Le4qdF5qS6UHZIWCKdbsP9rOb5z5l5oVhJBC9yzbh8WDc+n9jjY4JozyDEQem44TWvI3BjycFzyIwsShorki5In28Vd6VbY9E+YNDkpPIuGKCRfzcxJXdRLzOIc/qBCVnj4MidoqSMh7znt4fImAn53e/MJ94++UqSWi8WOsDoxM627lIaCKtjgElW676T59Qk66x5PfDXyKzGF7IYjcuMD2Y8t9jzCllpe29b/tX1sByeydid5FioQpAihQpdf0DG36dLsqusq8FZYe3ojrdBk8aLbBhOg0EmKCF18K7ukgXpsxR9SkVq8dBSdjoFihfEW4IjHa05Lo/7GILsZ0yJJ07Q7pmDYolNzRBqEqBdabkRpnvcQAjClvts34OeT6W6PGA9AhXMY7ZrIuhcu/wRoAsa50gLs3peZsIQE3wOkH2I6UphmeHMG1OMOfRMQC+uZjADvDTzeJaewApd0BJK3YhAm7ft3Ls4Mat+ltG8JZ
 CjFoNu98
 xwoty1/bEp79fo7ijRBUhrnwBIyQnlsxJIXi2tI3t42OEgrysLruT9rCOHc97Xo6GNBM1pbcY2pkWQiVF8PZnLZENPDjyf3u65GjKzIO1/ebxUGMj8lhJEh5tuhMie8vWiWxksnAgQDzxKYwjlKse22tByNA4j1+JxRrN3/cMRvGViORtKIGyaecqfX1MkScduwrm6+4HJrkoU2j3DxZrNYnvX0aTlr8WcbpH+jnNLNDY4R/l7xw2d70Cl6SPsICK2fj0TmJcpv3lOrwHmZl6FGTZjG7c40VJ0brVSfI8/uR9flWzyVxvv2zCWvqB7rdwPxqXdcz5epmVgyxD7ZA+Zli+JkBzvJu+FRZnTYO0lpszpwJqO+htQvnT/cLGVfumaS+v8u+ZqfapEcDfSxGY/6ve/BpoxL94uHPYgU88xHDTmNbaCm1TS/Bhq2E8+GH/bHqb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 10, 2026, at 15:57, Muchun Song <songmuchun@bytedance.com> =
wrote:
>=20
> The common vmemmap path selects the shared page for optimized mappings
> itself, so Device DAX no longer needs =
vmemmap_populate_compound_pages()
> to find a shared tail page and pass its backing PFN through the =
generic
> population helpers.
>=20
> Remove the Device DAX-specific population path and let section memmap
> population always use vmemmap_populate(). The powerpc retains an
> architecture-specific compound-page implementation, so select it =
directly
> from radix__vmemmap_populate() for optimizable sections.

Regarding the issue mentioned by Sashiko [1], it does exist, but it
was not introduced by this series. I have already fixed it in another
series [2], but it has not been merged yet.

[1] =
https://sashiko.dev/#/patchset/20261010075755.83339-1-songmuchun%40bytedan=
ce.com?part=3D3
[2] =
https://lore.kernel.org/all/20260924025035.1265035-1-songmuchun@bytedance.=
com/

Thanks.=

