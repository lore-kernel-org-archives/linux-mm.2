Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 056D4C87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85F146B008A; Tue, 29 Jul 2025 21:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836E06B008C; Tue, 29 Jul 2025 21:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773D56B0092; Tue, 29 Jul 2025 21:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 67F4D6B008A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:27:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2E0411384B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:27:50 +0000 (UTC)
X-FDA: 83719194300.14.69DCC70
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6866C80004
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:27:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="dX6s5/kz"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753838869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqJo0Y4jq0wed5EnAFkc9W+LR5gtcBNRm3C9RAj6lqM=;
	b=Hxm3MODtaBlZHhNyByl8RryN/0pLH8O8YNNUL4Sv5DdL/o85XMdluWgZA55P92Md7LNj0T
	JwkgsRZLliJe3gfn5EBZO99hpjgOnfzvn4QwT5AuBmoYNgAM5S9zgT0xdUfA485BiLF41j
	c/5pc33iFJZgo0x4Ji5rftHCCqLWXQc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753838869; a=rsa-sha256;
	cv=none;
	b=Vt9zrbI1P6+czHMdnQRzgfK2bCtXlnPAtgB13Hgm3osWS98RfaqJvh6xVb+8R8MSBSgYag
	XHm5EGMxK/ERCaLnAjr9Ej/HhclVpmvY6eotHKjCYm7nO7a5utKKQLD+WrV8PSdsZUJhZx
	qLJmhR1Y4mMUQQWqQuxGMoavc2O/NdI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="dX6s5/kz";
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BqJo0Y4jq0wed5EnAFkc9W+LR5gtcBNRm3C9RAj6lqM=; b=dX6s5/kzKLlo0cGDY7TRaTBZmf
	ETcOMMlGUJ/zvUN0FuXvvQFnD0S0NhP15hWiCtPjGzBSGUyhANiaptZ5jrhR/pmeHSSbPXbYP3RH6
	IvVgL3E54W7KroseoPMOaBWf35LWmiahGrkNpmrCvvfP81njyFE2siROdpapawtH7GMKTDBINMf6y
	/E57+5sHe0V9uj1O6bBJ3hFKh+GU6iNWerZt3x7iua7UFYE1GPkheIymYpbitRX84zWmiNme8P4cj
	FX7i07Sf/at1CyrtF/uxuRRucnlbQl1R4BRIEgSmXga3a7xYxltw1zu7K3lsn6xcsScGRJiYBG0ju
	2vJPn+TQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ugvbN-000000040Mh-31AT;
	Wed, 30 Jul 2025 01:27:29 +0000
Date: Wed, 30 Jul 2025 02:27:29 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, aliceryhl@google.com,
	stable@vger.kernel.org, kernel-team@android.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5.4.y 0/3] Backport series: "permit write-sealed memfd
 read-only shared mappings"
Message-ID: <aIl1AbmESlTruw7K@casper.infradead.org>
References: <20250730005818.2793577-1-isaacmanjarres@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730005818.2793577-1-isaacmanjarres@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6866C80004
X-Stat-Signature: hdq5y4x57nydjokyuh8ig3i1ndef64wo
X-Rspam-User: 
X-HE-Tag: 1753838868-687032
X-HE-Meta: U2FsdGVkX1+DUK+PfrJ1L6IoI95ptZmHcup142QKZH6vmllaMsV+uosWM2hrPErxuVDUW3oKKG1iGy1FIE9lGDvGsTHYZRn3Cw9Fw29dw7TlykFnW/DLIW0fUA7+qnodQ9tf+AygxW+ihBXuZxnWr/nWUdihEUCYT39/a8o9vrXMUo4qSJOUtxzwHc5TQv81tJ6jgtFlSuG5QXD175VojRNUh3CtI6GJxaW58e1D9RhkYC0ECvwcPm0PAJIEt+q3SmZL34xFH7XNhNEqhD3H3uTwIAEMmDng2M8DyVWVvnHJ+qWiyXnNjniSNt8GgAqQfSf0bm8Egu0cEVNDO36ota52qNHoMsCkUoFul3LJ1vrJTYPHWGKc6w6JSYIoOdK1k9Mmli9E9MWp4uBTHv2h1lIEelx8q5FEcLYPa7UbKSC2oaAyTl13jZIF9WJeMEnY3tYd5tnKmXyOWe3eFqJRBIAnpAfNE1MGJHgq8NmDfwwhLUp6kIoadwIVVF+RrXzcHHgdMGZjM4BBactMFgAxPOKz/ziwBuTuLQxCE+gggk6fqXSuxZxFWYM+JEDD7XSrtrUmKN7DYo7ROuMdI+jOCMRkeXMM+8dxauzV0qRvVmh/QvWr1V83+o6qzvRDlYe0m6GH4T9xMtLeAcR4siLfzIMYDNMq1x+9kaS3ZYuRWHkr9QsPXkfiSM2rfiNT3Ux2oSHj8/PGPlDbtCqAZzDF3NcxiKoN5uQd8b+R4VPI1gRw3QRYEy1WsyUD+29JJh0NBqrHOe7h7D6vcLHxcM9TPYh11ZmKNmEV4nfjCeKppOR5xmSMKKjexgyOnsGfKn1GJsVlLVgz3cE2Ak0B7SyJztzenPnR6BbiZ3WI8QEHQXznCL7Ctd5hrJI5UQPRa7+xR0Tc5xXNL0RtCXwEmNub1kq0+mCKBe+a6Hss0ospFXqsSyRkgzaGZlhTGk0G47gvU7HgnsvX4rPvChz9FMO
 vwOOTQmR
 4FJ3Hju0f+KNC8YSt2++b+eySDeA3JZO/RQoLWurumZyDlEeU9rv9CM0Ww6p7V5MrSxnvgORdUIVMfgjj58vqdSi9Gjcfm4venoktZx/Pl4LWdt9siNeZa8wPrdEhY9KJeYpit53gGNIOZ9YPlBHWTBQ+HemehCtC40rgvLJjCntd0xW8lJ5YUsvgww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 05:58:05PM -0700, Isaac J. Manjarres wrote:
> Lorenzo's series [2] fixed that issue and was merged in kernel version
> 6.7, but was not backported to older kernels. So, this issue is still
> present on kernels 5.4, 5.10, 5.15, 6.1, and 6.6.
> 
> This series backports Lorenzo's series to the 5.4 kernel.

That's not how this works.  First you do 6.6, then 6.1, then 5.15 ...

Otherwise somebody might upgrade from 5.4 to 6.1 and see a regression.

