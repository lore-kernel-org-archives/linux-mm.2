Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B4AA107638D
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 17:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95ACB6B0005; Wed,  1 Apr 2026 13:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4756B0088; Wed,  1 Apr 2026 13:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC376B0089; Wed,  1 Apr 2026 13:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 662706B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:44:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5EF3140177
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:44:53 +0000 (UTC)
X-FDA: 84610712466.01.1E772DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3792B14000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:44:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aJ3GOnzd;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775065492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KNB5frWkrA5cqoaTlpdNBmHvhA+jxtZslFCB4o2KRJc=;
	b=gFhS3xPTtCSze+hC1Eqq/0t6vvQM5k9o3OMF/GnqWer6lzD6FfQkxaAeBk9TpS99FG1JGG
	p7CeSaX5LE17au/WI6DpXd3EEpUWnQ88oIA/2TK9IYmP3xkWeMXPpHAk8l06y/DQU0EuVd
	KPU5z8z25EhKQKQrFN81W7dpfP8OKxE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aJ3GOnzd;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775065492; a=rsa-sha256;
	cv=none;
	b=w4KLp0AFolQ8DoOaXYuUpiNx9HgAmRSxXi91KxLJiQtfLKmOUdG9iQvgt9KnH2vBds8kDG
	HExw1kOSz3vEHoPBMxln0MyBHRVh8V09Pgkt9FS4fUzXSHhVw5P9+pblI/z/Zvt7mbeotd
	cgVK9y5xr9RHRzuI1K75d65VjoHWNGo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AF01408A0;
	Wed,  1 Apr 2026 17:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52224C4CEF7;
	Wed,  1 Apr 2026 17:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775065491;
	bh=Vpvl1hwrUz4+8zrhaW+q8G2QFNcvqrZBxlmzw5hbjeY=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=aJ3GOnzdtftQFcgGw9LludNc+Xqz3IGUEX7Lf0U40Zix6m0fF/Xpu42F6o8fJHoyp
	 Z9ML6t9FO5UsakhjGV1dEw0su9MpAtZYy3RJaD7lm9L3QNFbQtuHnMtuRmdpkSMYAs
	 ycDV8UG4IaEXWb0L1dUtni6LsVe1CLO4csZLl2Kc=
Date: Wed, 1 Apr 2026 10:44:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>, "Harry Yoo (Oracle)"
 <harry@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Andrei Vagin
 <avagin@google.com>, Axel Rasmussen <axelrasmussen@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, Hugh
 Dickins <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Lorenzo Stoakes (Oracle)"
 <ljs@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal
 Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, Nikita
 Kalyazin <kalyazin@amazon.com>, Oscar Salvador <osalvador@suse.de>, Paolo
 Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, Sean
 Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v3 02/15] userfaultfd: introduce struct mfill_state
Message-Id: <20260401104449.42123600e33e08b5ebad10a5@linux-foundation.org>
In-Reply-To: <20260401103717.b236b271a2856d536a48663b@linux-foundation.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
	<20260330101116.1117699-3-rppt@kernel.org>
	<actxscYZGFiyvUcs@hyeyoo>
	<acva_NKf7T5rbIC8@kernel.org>
	<acvnEd3-s6XI26vb@hyeyoo>
	<aczK4-vrULRiTvyh@kernel.org>
	<20260401103717.b236b271a2856d536a48663b@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: koaahns51ep3t531ui6rrdyyuhz59e7w
X-Rspamd-Queue-Id: 3792B14000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1775065492-59277
X-HE-Meta: U2FsdGVkX1+Gufi2xnGfmjSIv0AOpJcTAJSmgRHG4iCXv4td0c6xXyUFueFZGFIWDacxWW2OeyLRCi08AaJTmzoDDsDW7KCs0N5xb3wS6gSfRYCSB/e2PsLh/dMVsAnSVuA+gaUj+sYQVTkkFbn7pAwmu1ayJ0dBq4QnIcSsjrivR7qPBq9yAk0TVOm5z4QY6b1dOlha6GiDQ7zuk702DMJcONfJQYacZ9GVBUg+4/T123SrjCFom/oc1GKtja03BWWadCnc8Z+i7f4iRcNCVKbUUOhJE4bLJBSiaJddyVAb29TzqzqfAvdC026k+BdMY/8NN9hRrFV4oS1be0zLtx8waLZBas2/18n6pMXbHD0Q6z1XQZW8WYjTAHZ8NJpHC+yoK42/TqgUHTNOoB1he0OtRoWauUAKx4u7A9/fVxfsZB/DOhutkPNZ+JQSAjNSvyct4X3nRwJkko48I0y7+/682Zf6zDEnwmHDjRVeq1sgMC0wCvaRPsJSp7TdgkSqBY+um8B/eXXBqYzBoF9LEIblH+XbgL3ZMqjRAR/dRZbuVNa+OwrKYWdeJEsdqmTRUWNyRSnKSwgLHiBuIk9/cE8q8rEC+8TittVkl17Jpl1XQpDPG7Lk8ViVxr4P+xAkkOBa/GlnUTV6yEDOH55TUOEW03CbF6gAyKVFUsogsXht9XMLIhTtiCBYdY/fR6YxPSp5Gttbg2aSTTaAOAZKtPxDchfuAZAMAX04IslNcL5qR2F5o7QX5qNgDJGAtUUOq8AyahVDv46UT/MOHqOpzfHzQFPGCMYXXR1XOLwfDePAAJdnEP8VjSqfB/kMIehFZ0sm40rH2etgNFxe/2fg1CsWBIlMxJ0P943aHS2ZkvabSfDN7BsjQw2iMY/lQraQOiATJ6kSZ761zfiSp3ywssRHlltbX1OADzjAn2rMDRpT4wJZTkyBKXWtP7xm0uslEcFllEmj7h+s6ceOa9/
 kRHovvEp
 cIzvTwgRxPgu5eJyyPYhWSfFt+dV8fKKbqYKaP4s1aXlJKH8/WmzClPEGns52tPsgotg6QuSqnDgxrfNoZ+PptL2viIs2qPqmYMlObs95Ea1C8MBCa0tC3GUxAfW+QGZQ6tccV5O9jLKBq3uptmjcmEXbC/nfjcxwMMply/ImidMu+RTCbKJ1GreCceqQysmwyYhOSi6EvPgIDkfQs3lWgh/zoprD+DP2MSDK3iIrudeHVNjYBrFOcyyYopvi5xkA2u4EC3o0mPO4LC+OvandiYgh/oIVsj2PgmhwhCoFY2bduhD4rRNQBiIjJGHdBqkTw+ji+CgZsCCLnN5cifuJza1Cx19rBhhi5CiIKaT8qLtIHwWSg/afinfqtf42snGUY1xrdoAJV/Tpiv1jh3uXnCPAVXrXcnHSjXW6lXHjHh4jJy7Tbq5dENdWegsFBPjjM2Fr7iByaj38Xa0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Apr 2026 10:37:17 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 1 Apr 2026 10:36:03 +0300 Mike Rapoport <rppt@kernel.org> wrote:
> 
> > Here's a fixup (it causes a conflict in patch 4 though).
> > Andrew, I can send v4 if you prefer.
> 
> Looks pretty simple.  "userfaultfd: introduce mfill_get_vma() and
> mfill_put_vma()" now leaves things like this:

err, actually, it gets messy.

Can we please have a v4?  I think there are a few other things pending?

I've noted
https://lkml.kernel.org/r/acqrtd7E6UxrX6Ji@casper.infradead.org and
https://lkml.kernel.org/r/202603311743.uZYPu1Gn-lkp@intel.com

Alternatively, I can leave the current series in mm-unstable as-is and
we can add a fixup at end-of-series.  Not ideal, but it's OK.


