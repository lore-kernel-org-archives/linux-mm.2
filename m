Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAA7FD3EE75
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 15:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4456B0252; Thu, 22 Jan 2026 10:48:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188C36B0254; Thu, 22 Jan 2026 10:48:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 087576B0256; Thu, 22 Jan 2026 10:48:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E8C8D6B0252
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:48:11 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8163C1B8C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:48:11 +0000 (UTC)
X-FDA: 84360031182.11.5B3D888
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id D8D7780009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:48:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=l4QMB78b;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769096890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOgrnPYtHMAx/9LtfscWXXY5ApZytnoL/bZF9/NnH6w=;
	b=Y2F6zJS0kjwUE2CUEfDPnr4uNDkqnyLcpjCbAmq7V4p717Idn3JyDScOwAEwd06VyPCef2
	TOxK35NK2X+SNGKk6wcKmdAVOaQlCaWWrb1nqJElEdx0OL8fd5NLceiaKBoQSELg9/mw2K
	HfU+0/dTvLUpkL1q14X2sp18MxPeyeY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769096890; a=rsa-sha256;
	cv=none;
	b=M9fh7sbuSI/voJnJ//WF1hfcp4xUDtMC75xPNQ016HgqnzuaWrSmBnsZelOFUsAVUqsWbB
	LCAozPpC26Lq+PMwJRHpZK7DqMudXNRv/IirT/DFLltmkzt3wSVFnkDNuatjEMDxhJbEdf
	cafpBw+ytz/Pf3IXa/Kf6PoOcJnK7AA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=l4QMB78b;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBE9C40200;
	Thu, 22 Jan 2026 15:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE7EC116C6;
	Thu, 22 Jan 2026 15:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769096888;
	bh=frTBB73MtDuQNGKP1yVGyB3uz0vppSL5U6DQ3n2mzpU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=l4QMB78bZ7KtXFeTJFMisjm/v2/Uhby2DQLmbJ6xYqFIETYhOZOrXz6c9LiasJWKf
	 ym8LbAzXoRVuRSqTeTyzJbDyqh+tl2SNPMBew9TzlkLero31X7O6FztQVEgqUXqRiY
	 iAeJUcBRMJO6HENvmZd+NbtHfoJtRmpk3Fn5WgdY=
Date: Thu, 22 Jan 2026 07:48:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn
 <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, Ingo
 Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng
 <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>, Sebastian Andrzej
 Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 00/10] mm: add and use vma_assert_stabilised()
 helper
Message-Id: <20260122074807.eccc6080b8d8ca5fc37b2a62@linux-foundation.org>
In-Reply-To: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D8D7780009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 17g4koa3h8kxq6qwe4i8pk9butne65qx
X-HE-Tag: 1769096889-11874
X-HE-Meta: U2FsdGVkX19LIfPVDdehYFNxlgXfJ8BwmIkR9NKtye2wVw/pEPsi6FTS3vXRiSvOOkKInLtGfFqGzitu5pT0OmIscb8BXQkrtysASWK3dqFueKX+LcZXiDg/W9EGRt4im8PDP0exxGWq/E63os+ve4ycp26q5aViyvjZM4n87y+TH6Dk2ksGkwFXhlpXYk9zKZ4TQLew0bUQ43PMqxbFek6FL11wcjBKk6qHoPllsk2DF7yYpbORpAaVtiYidM+w/gooonajw6cYRbySVC3ZTW7I3buvo8B0eooIMW3SMpxI7HIn8sK39Msa/1PjHmdyadHtekHDD47IaFW9oqIL4sGzg8VCaH3KqltMp62CqciLvQu8gkvRFcTAHvGS4QheZMfg9yZ7nBKPzz3GI95Xqj+mZRcv3yEwJ2i64joXqU7ncBlH04Jq5MaTx4LfyRsMqBUULsA3FztAUgB6jTZvlvTC+ou9Jiev57hifxP+0Y5Tz4Psv0MB/cpnVtep2MR0WJADL/ecqBgVT6P/zPrCQC+arGgmmqKlrhQ1jmmv1NThxbUtPQhTyPE4TUy+x29R/Aa383CckPKWLkoiQXgOjhNb+egNR/qtNv1O/cq3wjLhd+eIKPmbrZaPePa0jxDGEisWQ1gVCUyx348ph1w//IfS7zJ4qv93p/3SHJpdd78AOcc1mTTLq2Wb+L1taSbYF9/lgglpG5PghWe0J2bPNh5lKeT5wWqQagp+92oMPqstqX1kpx4zv3SCnYnvW7HdPYEurup6LXmFF8Vjirnj6tx2usbVnN7xiW5AU/aFlvNwCmM7ZqHoNzLqMnZR0ykjFgQTa4DaL3IQRAthmOAZ96faOtHJhkQ9KPwU/gCROtHYPnwsTI9eqRFr6SVmLFRhdAu0vJNVBTtCtVXwHF0om1/5VhRZ0eJsgzo/AIUmU2OFmS5dwrFn6YpAimX/txkOagLf+yt9XbFcTpe2C4I
 Yt/GEdbw
 504w9nzRgR5UgMHKF3TJTEl31jbYmCrls7zl7j7da3iUi4l7H2NJcHrhvWvaY9xuPlidO6fgTk1pNTu3zNA30teb270IBVSBkX1YNwS+B2eq+oCkgvxAbGr3RrSztJ+fNaXp88/nwRMt6ATfQ81y/NqatLw1ShZLE9bjUV6rHe+SwnbiRLgExt0kICReTIlxzDEX3YNUFMR8EBxTVvnXRVQkZVp7QrC8IteQWXBUSW0EX1oGfVDNQpgCFTAZ+ag3DM2JPXuFn2SxaEpebkbFLPd5hpTsNevsl0PvB8+c4MmFTr6qO8RsfEoYBOs5v4VjackJllpIG8CpVv6S1sk528GRIjW5WF/uWaGdGRdJI5sOHZV31yu2FYz3zKZopMdSRvqSXzZpqAid9SW490wYQn6CZUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 13:01:52 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
> be changed underneath us. This will be the case if EITHER the VMA lock or
> the mmap lock is held.
> 
> We already open-code this in two places - anon_vma_name() in mm/madvise.c
> and vma_flag_set_atomic() in include/linux/mm.h.
> 
> This series adds vma_assert_stablised() which abstract this can be used in
> these callsites instead.

Thanks, I added this to mm,git's mm-new branch.

It conflicts somewhat with your series "mm: add bitmap VMA flag helpers
and convert all mmap_prepare to use them".  I believe that a new
version of that series is in the works so I removed it instead of
attempting to fix things up.  Please lmk if I should attempt to perform
the repairs.


