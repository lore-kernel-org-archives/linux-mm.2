Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31BEECCD19F
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 16:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0798E000C; Mon, 20 Oct 2025 12:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A11A8E0002; Mon, 20 Oct 2025 12:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58FE58E000C; Mon, 20 Oct 2025 12:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4281A8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:31:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E7D3FB7285
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:31:02 +0000 (UTC)
X-FDA: 84019031964.01.5F546F7
Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	by imf15.hostedemail.com (Postfix) with ESMTP id B6345A001B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:31:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="PBpui/It";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=B6zxy14j;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760977860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZXqgQTmDECsjgcK+mqROvdAj9L7HPXL3OBL6D8o0jX8=;
	b=TJtpeOaAhCG2nqDjroZyapafIhbJVq7WDxBtP0KZmB7AoHjDa/FxULccM1IINl+fE0U0E+
	/qYJq16GjUHJrNT36s1TMsZ0IsteYa78SbtMjDX+aQlszQJ52ZwL3YKLxONzTEEKsK9qGk
	fCczKEc6cmrHtjsUhhRn6OD7Fei/b+4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="PBpui/It";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=B6zxy14j;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760977860; a=rsa-sha256;
	cv=none;
	b=BVP9bgVRtYFIGgCpaGt6qHvQ+rtRYZsh2FQH6RuLTW9TwV+40FoEK0SGaBpK+X0Mfbpp+o
	QS93sn14o8vGQPb4rRbrV2UVDe4zFqZNV/jDmceCkIVmyxbPDI/Ps2Jknvam4ukzNCmKbX
	WsupOwok5AJjcGkNketME9BH6keWnEE=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id ED40213803F7;
	Mon, 20 Oct 2025 12:30:59 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 20 Oct 2025 12:30:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1760977859; x=1760985059; bh=ZXqgQTmDEC
	sjgcK+mqROvdAj9L7HPXL3OBL6D8o0jX8=; b=PBpui/ItG0Dz0gEq24nr9/U2Ct
	+LyL6JuW6DEF+F7K2jN3INZHke5HfWDAkeyyWDxmRfN7jXuY6ojqQP0pQTWfvTUo
	ozpFBI8tb6qGtWQ6/QVykqkc/SD94ZjUBEzR8Z9j1rvkN9WAF9c/v/lkaSH+Quqh
	v6rlSs+/NAaMj7sDcN+8oyEt7hReImgpTiqOyj+rQ87XwGPtYTdWF2eeIuKZn6CP
	gwV4+gA0w+jzp5aMp1dC2zQAAsFzg2K2qol2yPIcKiGzr7glSbP7BvfwTdbgLpwb
	FTRVO6J9vYHMjSCmf1SIhwQh+LzsXNydAZoeAPR0mvUj+tcs4pJsoaJK4LDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1760977859; x=1760985059; bh=ZXqgQTmDECsjgcK+mqROvdAj9L7HPXL3OBL
	6D8o0jX8=; b=B6zxy14jXgENJdrrfbrO9Wym6KBvpsWTVLHctDOFybRV+Vt8tqg
	oMT0x8qWsk4dUlkcBa7iwVgziG/asNLXgswGIoDi8JnJaIVIovY0P0DcgHkOy8pj
	Xz463otovez1SExf7HLqb0ZlWqwSr/p8jfK3smsgfeNRE1ilmDpQKuyfJvwliF3H
	Abvqze0AregGZj7PaWSFTCEq7wqZK0KWbFGPjXKFvFW35PmpHK7uLt9mL64emjMA
	ne/8qz2uSAwXt5dTKk7jFTuaGJ/sGU37Zm5OjPFG/JozoAKjShQNzkQQgu2yUnZo
	1BuiOwo1Zzdvdbz6M0yR59R/vV20wP1/T+g==
X-ME-Sender: <xms:wmP2aO6gDWAZmuys2FloIkuECbW3puVDoCFIutRK-iUGvL8hwD-A2w>
    <xme:wmP2aPjRgtsLq04aCGg7MJhSU1ZiezZRS6UhkbdYyIlpELGGhWshXD_fMFOMapp5U
    yfoF_Tt2bi5OJh2VybioBw2kOH6N__JrIrYGP58WiPxExvaRWgu8g>
X-ME-Received: <xmr:wmP2aNo9wbVNeCxNYgDJ0E1gjRede9RdU-zD8RlckeJFROgo0mEutqSETAUANg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddufeekfedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrf
    grthhtvghrnhepvdehvedutdfhkeetffduiedukedtveejkeefkeegvedtteevkedtueeu
    hfehveeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpohhpvghnghhrohhuphdroh
    hrghdpihgpshhiiigvrdhmmhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtg
    hpthhtohepvddvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhi
    nhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvug
    hhrghtrdgtohhmpdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghp
    thhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehvihhroh
    esiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtohepsghrrghunhgvrhes
    khgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesoh
    hrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghl
    vgdrtghomhdprhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:wmP2aDIXk3ie16Gw-5qxQA0WsgTyiZow9hkxwgpOSr4DKe0VQdhbBw>
    <xmx:wmP2aCtzoQF5fOoYxl4BXJRFn5HnoPEFWa1k8g1e6wP0NW0JdvCKpg>
    <xmx:wmP2aLtH1QIFINGnIMOX5oF_b9FwoAhdHNUJ2Hdf7VYeY8ed390CDA>
    <xmx:wmP2aBWA9h-wFEaEZ_xYN6B4rNLCiZMM7Xokd8bN2DvtyP-y7ZSQaw>
    <xmx:w2P2aHSQyHmH-Hg3Nn9XKxLD7FuKXe84gLKoyRHg48g9nRSadC2Y5H6w>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Oct 2025 12:30:57 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [RFC, PATCH 0/2] Large folios vs. SIGBUS semantics
Date: Mon, 20 Oct 2025 17:30:52 +0100
Message-ID: <20251020163054.1063646-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B6345A001B
X-Stat-Signature: 8yxz1j7y56g3qknjk7pkw99whoc5tq41
X-Rspam-User: 
X-HE-Tag: 1760977860-538101
X-HE-Meta: U2FsdGVkX19uFvNacD0S/OMYLG7fSIjau27T5wR5RLvERnwCzJm37obFr7nzYGut1ta0EWyRx+wGfIZDobvjzp78SpCv8+dOdkuG3CNBTyoirc3lg7NiyNePmXc0c4Ic/HfkTTMWY4oHocdoBTgSNj5IYUgiL8FPjt0ED9I0TIJWi0f0sJq3wnZphmKOu7BxGcwAVmj3urRyyzaTYJXlpFn0h7EE9iHmef9bqWHYcloBEP7FQWUaodaEej5xQiBYT274+0nae+3fdjWjTqlyPauidzMqkoDuXlMI0/DMRuCkmk22OY863MIwNiBJ4KEYWDGLmwsX+0stdlFOY6m6NcimEaNgwH+696dFATIRj/Ja9JsfLQskoXHWzIswV9oNLq37gar1u4A7ZmOwZ2OuvYXydo0zDsUD1y3Bh1FtLZ5xPw0xYxSEDh+pxjSFP5AvPzQ4x6XU+U9XCaDtJzkYASX8p45Vt9LWfXiyLs5WjNP2UktoaMfW/uUBgfBGf94JzruPZ6ysF7Jy0bUZf4T7S8bWxwGWa6ymfYQNy+fzWWLEDeAwOA9XxHf9b5Ts5nAnOe95sBfbUXJGYzK2xtaPa//K7/KFCojU17lOP1UCDldyYzkydpFOWjKS7LWNbI0Up+HzNXEHnpEjHWoW55q+2beWdUyqgtaRqeHZMzGaI0dKTqM/5xfV0gi10YdVgbW46ADM6a9FVjYkv3V2PQDbOsmBnY8y05AtSXWdYjUWHa2qXguaphcOotz4UO//X+bPxvxU5LSmXeI5pNudobrQDBSm5QmRAG+dRQC6czByWgiqOSGE1bAQbAbDoJiZFADsoGUuN2EbXSn00/jxlNN7nyrs4mjBR2C6+nblV/j7eXPeGgUbdIdARU1O0jSRy6bWQQQCzOaG99lEP1gi//i3DcdoLYR3nl7csOgTuZjjc9ivGJWCAnyo1p0SqDZZo5Rf6w6iKruzDO1UUd6kwdZ
 BxfBqGpz
 xz8yyE2OnuXL7eY8ka/LUvdzrwRXblwC4/1NBBnF7jLKbtfKin5cZqqNitf/7nT1HOjV5B9nW2NT+B4568jG+tWScVK4Kot5qfLBx9da9897x1ExiIVmNlYevgVhdsAxg1vtlff9tyGF7g5WZTYiMad6KeKTI8CarAVYkJE8ZQUwD4uN4ZVJcOPfDoPUf1HJFxAo0A+9j8U6rdUltcEXYznkh5fsuCI6UTHicToXDNmJhYrGnnci7z+OUNTZUDuyHXyfQAXuxdWEsuH2PRRZQJgtSf1TwV4yB6iAvhw5ZkNLdNHTXVktOq///rDDqGQigmBnHjcYwiK+fYEwmcjvkw5lVq8I123ZdNiAidk2XZ2oQDSd/U6hyroJCe2TGA0EmL83PScZk1EVgKv6AvM2rsBIPYhT5L0Kkro3pi7ZAPlEF3xYNmTg1On42EwlwyL0nhqKm6qmWD2o9sv+p4oJqbawk5bHZHtko0T52pU6zfk3ayiDX4qrK+Ntgy0hBHNltllV8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

I do NOT want the patches in this patchset to be applied. Instead, I
would like to discuss the semantics of large folios versus SIGBUS.

## Background

Accessing memory within a VMA, but beyond i_size rounded up to the next
page size, is supposed to generate SIGBUS.

This definition is simple if all pages are PAGE_SIZE in size, but with
large folios in the picture, it is no longer the case.

## Problem

Darrick reported[1] an xfstests regression in v6.18-rc1. generic/749
failed due to missing SIGBUS. This was caused by my recent changes that
try to fault in the whole folio where possible:

	19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
	357b92761d94 ("mm/filemap: map entire large folio faultaround")

These changes did not consider i_size when setting up PTEs, leading to
xfstest breakage.

However, the problem has been present in the kernel for a long time -
since huge tmpfs was introduced in 2016. The kernel happily maps
PMD-sized folios as PMD without checking i_size. And huge=always tmpfs
allocates PMD-size folios on any writes.

I considered this corner case when I implemented a large tmpfs, and my
conclusion was that no one in their right mind should rely on receiving
a SIGBUS signal when accessing beyond i_size. I cannot imagine how it
could be useful for the workload.

Generic/749 was introduced last year with reference to POSIX, but no
real workloads were mentioned. It also acknowledged the tmpfs deviation
from the test case.

POSIX indeed says[3]:

	References within the address range starting at pa and
	continuing for len bytes to whole pages following the end of an
	object shall result in delivery of a SIGBUS signal.

Do we care about adhering strictly to this in absence of real workloads
that relies on this semantics?

I think it valuable to allow kernel to map memory with a larger chunks
-- whole folio -- to get TLB benefits (from both huge pages and TLB
coalescing). I value TLB hit rate over POSIX wording.

Any opinions?

See also discussion in the thread[1] with the report.

[1] https://lore.kernel.org/all/20251014175214.GW6188@frogsfrogsfrogs
[2] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/tests/generic/749?h=for-next&id=e4a6b119e5229599eac96235fb7e683b8a8bdc53
[3] https://pubs.opengroup.org/onlinepubs/9799919799/

Kiryl Shutsemau (2):
  mm/memory: Do not populate page table entries beyond i_size.
  mm/truncate: Unmap large folio on split failure

 mm/filemap.c  | 18 ++++++++++--------
 mm/memory.c   | 12 ++++++++++--
 mm/truncate.c | 29 ++++++++++++++++++++++++++---
 3 files changed, 46 insertions(+), 13 deletions(-)

-- 
2.50.1


