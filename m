Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB21ACA1013
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 01:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1A68E0068; Thu, 18 Sep 2025 21:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB98C8E0008; Thu, 18 Sep 2025 21:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6AF8E0068; Thu, 18 Sep 2025 21:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A147D8E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 21:06:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48EB1C01D0
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:06:41 +0000 (UTC)
X-FDA: 83904209802.19.B6D97C2
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf16.hostedemail.com (Postfix) with ESMTP id A5465180008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:06:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K4PKUmhO;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758243999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSiTM76aEl/ZMy88fSj8fEpGw2fldtJUcgJzMMiasas=;
	b=HY1mE3mNmyj0ekiovKP4UdvvnFdYtpk2nejcu1WxY2ryB0/lMrouywdXCvUt3ujkl1bYS7
	7z594/PzuHri5A8Voepb3pykuojSzEETLjZ1TZbhKJv9eVlEaEGs39R99eABmtqcbH7etO
	tXdN3DlqpUd7zXd7cdKQC7zUk8Ad1v4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758243999; a=rsa-sha256;
	cv=none;
	b=2OWKenRvWwo4kC0W44HwP0gzuI2G87zs5fMPgYehs/b0RctTyZAVMmF2WHSOPo8g2F7Gq7
	QTM+qaUY4L6oeElWHbuzVIBojoM9LvHBaxxkPldvWJvkuXWrQaQiNRrgxu6wNrs15/S2cs
	RZ0vsXMLJldn6+V6ZkfaM2bOAkjFcIU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K4PKUmhO;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 18 Sep 2025 18:06:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758243995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eSiTM76aEl/ZMy88fSj8fEpGw2fldtJUcgJzMMiasas=;
	b=K4PKUmhOJz3QkN43tWm8G1oLXgOMrz1mm8x1L4DAY1mO9FqzASio6LRsuSsxzz2EdCdJir
	f4ppZEuogwRwqYPF4xqu8z96HPQXzTSeCMtLgXPLA3D6N48aXuM2ZaNLy3xPCK/4eQxWKK
	zYVRvSPu3bhpkVK40cK8926QwQfCYlM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, mhocko@kernel.org, zhengqi.arch@bytedance.com, 
	lorenzo.stoakes@oracle.com, hughd@google.com, willy@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
Message-ID: <tombfifwrhx2n4jnj2pgcdcpj42mdv7yizkpxrppnqrtsxd5fw@epnrjqgmmy6z>
References: <cover.1758166683.git.baolin.wang@linux.alibaba.com>
 <9ef0e560dc83650bc538eb5dcd1594e112c1369f.1758166683.git.baolin.wang@linux.alibaba.com>
 <17d1b293-e393-4989-a357-7eea74b3c805@redhat.com>
 <4e938fa1-c6ea-43fb-abbd-de514842a005@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e938fa1-c6ea-43fb-abbd-de514842a005@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ewsjamiuc4x4sdsz1zbxz664g8cb88ft
X-Rspam-User: 
X-Rspamd-Queue-Id: A5465180008
X-Rspamd-Server: rspam10
X-HE-Tag: 1758243997-951939
X-HE-Meta: U2FsdGVkX19zXhwY2XDvfUUQLG9SNsf1SzK+3ig1Tbiu2WSxOAJAWCoYNuphIQ0XZSlmHXs1surM8n6gfvbm4tYARr4EkjPRwDmUYK3o7YKKPacR1jvUv6bFnnb/b5X5SM/evQO4H1ZsiWuKD6Tp7cmF2j5yWKsnutQkuYbNWeWsJLPfeKp8vKDRZdahwG09AZoDABR/WiJJHgwLEUF6p2g58EErhC1ciRP38Ggws8snsub96ur36xWtFU6EW2aGt1sXxFY+zY3OQq+xlqIXgXTSeDgkqOAUlDUn+RluGeTAMQJxlQuRNGm1G6jY7a2a2fVP/dyz3WRIEwxVkjH5litxb1FQX/GIYHYxSgTWSw1wHOo2UQzqz7Rh3kuSp62t5t7jG51ccs4guYsdx4cJpyg/6DhsK/6J7BbdpeuVIpwpHlRtcYpVhgtzp+kVlk9br7XnqgLHLngevhwFHaRsAwp+LuwUrtwzWYyxcD1dnYwC1caj7HDaU+hUUoy4j8lOQoeM7HyxeIXypTCCvY2K7qYBT3Ez2T7eLHXMHXA2K9rrKrtPu9ur6yjUcp/Yev8WPOMEhH+bc7h2wKVvHXLND+PCfPH9yoHXhsIs78RdBiyQ6IlCnFH5BQ7TB0FvhlbCWoSxP1hIc1AmjJkgasD3SGqNp6aFK/OG0nZykRh5xQop1RcjZ8asi9tyitIsG5b9Uyl+sne8VI5koL2B4RRPlgEWYlFarGDlP846gjwjRmzlJaP5CKuP3wn0jYu3uzQ5mX5ingdTeAtss20ZJuNY1QZqhCspfXo1643eUcszk5VdfD7OpQENNQ0Lp8f2NDVs+2oJL/8LU+J4FlVx3Lh+DQAySFYyTLYAajVdgoySaRTQhnJNaFfMUG6ZOyoUOinpTwXRCa8HJpjpTkDBeVMcUYBsXsLiJqTjzX6EeoNVLloWxW4qFloWXrJSYUfe84PnWWL1LzgpZxsIBSXYZlM
 FvRXknVp
 7bjvvYdFqzZttX0Or2Jda99KLwo213o6Np4EwBgH73zPtf/VsehCQXqMmaV1m3fThGzxT5MdUnCFy2TF2vDlrHyPP7IogjebrY5sUrxJal27aLyf2sVw8yCGmZ9WXn99LAYkIO/ozAenLhm3jo7+WjfAy1xr0YVx0IQKv4fKxwkhTaUp/K5rGOfncUrovWa6lKwYyUQ6allaKrCcfhjjkscNhplt0jd++/aBsOKGX+39se9YGe4/NChQMSzf9Fnfy9MuVT+YGyd4QMUIJTQDtAOXJvdyt5AZ9TVuKkA+iOO/g2X/buwsRbaDXLgeTqPCogcgQ8FUU5iRKTGQgYw+f35/jSwamvJNvUmbK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 05:36:17PM +0800, Baolin Wang wrote:
> 
> 
> On 2025/9/18 14:00, David Hildenbrand wrote:
> > On 18.09.25 05:46, Baolin Wang wrote:
> > > The folio_test_private() check in pageout() was introduced by commit
> > > ce91b575332b ("orphaned pagecache memleak fix") in 2005 (checked from
> > > a history tree[1]). As the commit message mentioned, it was to address
> > > the issue where reiserfs pagecache may be truncated while still pinned.
> > > To further explain, the truncation removes the page->mapping, but the
> > > page is still listed in the VM queues because it still has buffers.
> > > 
> > > In 2008, commit a2b345642f530 ("Fix dirty page accounting leak with ext3
> > > data=journal") seems to be dealing with a similar issue, where the page
> > > becomes dirty after truncation, and it provides a very useful call stack:
> > > truncate_complete_page()
> > >        cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
> > >        do_invalidatepage()
> > >          ext3_invalidatepage()
> > >            journal_invalidatepage()
> > >              journal_unmap_buffer()
> > >                __dispose_buffer()
> > >                  __journal_unfile_buffer()
> > >                    __journal_temp_unlink_buffer()
> > >                      mark_buffer_dirty(); // PG_dirty set, incr.
> > > dirty pages
> > > 
> > > In this commit a2b345642f530, we forcefully clear the page's dirty flag
> > > during truncation (in truncate_complete_page()).
> > > 
> > > Now it seems this was just a peculiar usage specific to reiserfs. Maybe
> > > reiserfs had some extra refcount on these pages, which caused them
> > > to pass
> > > the is_page_cache_freeable() check. With the fix provided by commit
> > > a2b345642f530
> > > and reiserfs being removed in 2024 by commit fb6f20ecb121 ("reiserfs: The
> > > last commit"), such a case is unlikely to occur again. So let's
> > > remove the
> > > redundant folio_test_private() checks and related buffer_head
> > > release logic,
> > > and just leave a warning here to catch such a bug.
> > > 
> > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
> > > Acked-by: David Hildenbrand <david@redhat.com>
> > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > ---
> > >   mm/vmscan.c | 12 +++---------
> > >   1 file changed, 3 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index f1fc36729ddd..930add6d90ab 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -701,16 +701,10 @@ static pageout_t pageout(struct folio *folio,
> > > struct address_space *mapping,
> > >           return PAGE_KEEP;
> > >       if (!mapping) {
> > >           /*
> > > -         * Some data journaling orphaned folios can have
> > > -         * folio->mapping == NULL while being dirty with clean buffers.
> > > +         * Is it still possible to have a dirty folio with
> > > +         * a NULL mapping? I think not.
> > >            */
> > 
> > I would rephrase slightly (removing the "I think not"):
> > 
> > /*
> >   * We should no longer have dirty folios with clean buffers and a NULL
> >   * mapping. However, let's be careful for now.
> >   */
> 
> LGTM.
> 
> Andrew, could you help squash these comments into this patch? Thanks.
> 
> > > -        if (folio_test_private(folio)) {
> > > -            if (try_to_free_buffers(folio)) {
> > > -                folio_clear_dirty(folio);
> > > -                pr_info("%s: orphaned folio\n", __func__);
> > > -                return PAGE_CLEAN;
> > > -            }
> > > -        }
> > > +        VM_WARN_ON_FOLIO(true, folio);

Unexpected but better to use VM_WARN_ON_ONCE_FOLIO here.

