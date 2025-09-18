Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2CA6CAC5A8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35A098E00FA; Thu, 18 Sep 2025 07:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338DC8E0093; Thu, 18 Sep 2025 07:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247CE8E00FA; Thu, 18 Sep 2025 07:48:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 15BD68E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:48:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4B71551B9
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:48:21 +0000 (UTC)
X-FDA: 83902198002.16.1F49BBD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7F07640015
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:48:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NsIOQ9dm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZggasU2L;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xkWzZFbk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fEARIWCP;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758196099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMOUNhsGvHhAUf+LAQd/OeevBQv2Y/jWS09GwOJd9iM=;
	b=4JtUqcWO17v69+P4+9Q17kQ8mdM09+epFkKYw9cDtfrlvLUBt9fIUF3KZ8+g9yoEulddEM
	oSjUw9Sk6bNSxO9p6BkEhijgqf5ogYfqADdpVkHSFgIFAJS5Msni16XPkEiftoiWLNmN/l
	1lUxQcViSASEafmrrUHI4FP50mD2w68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758196099; a=rsa-sha256;
	cv=none;
	b=LRnRJTv2/jiV7VFoMDHxO9GNr/zFFy4MDUEcqGi9wY5jqCAYOe3ME3akn8K+VUuu0LF1Bt
	Dc0vIqLZV30vkOA0N3B/RH9O2S0BuZhk/hLd4t+HlH6170g8+J45o7xsypJVuvrIU5uPbU
	bkz6/RHYM9JyvYTSybNIoHTBsVp4G+k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NsIOQ9dm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZggasU2L;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xkWzZFbk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fEARIWCP;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CBAD13370E;
	Thu, 18 Sep 2025 11:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758196098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UMOUNhsGvHhAUf+LAQd/OeevBQv2Y/jWS09GwOJd9iM=;
	b=NsIOQ9dmZFWlj08ASM+0tOMuI4uoRfRClAIqbSviXN95afpsSEv0/k6us7ReW9EDQbMATt
	DO4pT8FNhprSDvzHqGokIQkpNkIDPwrCROySAxvUypdJUG7nowS6fJIKV+lI03hjePLg5h
	my7YP9F1oR4x0Q3UTQm5r7xSSDr3pvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758196098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UMOUNhsGvHhAUf+LAQd/OeevBQv2Y/jWS09GwOJd9iM=;
	b=ZggasU2LVxHLbH3HTpFmVQH4zVMbSmnK3BQfjhGyz6PtB65oXsT7FG1Ol9eUat9Kty9Orn
	gq92C7/av8p7a2DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758196096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UMOUNhsGvHhAUf+LAQd/OeevBQv2Y/jWS09GwOJd9iM=;
	b=xkWzZFbksNveYnTPRm0DcByD49XuDyxamylUpbKpu0inMYFysqgpyG0smmm6q9aoco6Rab
	wa95agUh4EP5poYjiP1I1rkJocMxNwckXcYDriQaTYSVCg3KVQGhIRyXTxLKPeM9E3nvU4
	nfsOdVzyH1/Ozc4zX+/MIS/3WekAXfs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758196096;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UMOUNhsGvHhAUf+LAQd/OeevBQv2Y/jWS09GwOJd9iM=;
	b=fEARIWCPoiFLAGz2DBjeHMdArIdFQp8TGO5mUnjbbvWOaPJ7mWYgBEbtYOGrZPzdR/byiS
	tRVFCXVoMDw1ecDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB6D013A51;
	Thu, 18 Sep 2025 11:48:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sN1MMn7xy2joCgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 18 Sep 2025 11:48:14 +0000
Date: Thu, 18 Sep 2025 12:48:13 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: David Hildenbrand <david@redhat.com>
Cc: Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org, 
	minchan@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	rppt@kernel.org, kernel-team@android.com, android-mm@google.com, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 6/7] mm: add assertion for VMA count limit
Message-ID: <4n557wud5bb33jxgiale6quhnxqoqf2ykwqxv6yemmosz4uxjh@ommmu37yiuc5>
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-7-kaleshsingh@google.com>
 <eb7820ed-3351-4cb5-8341-d6a48ed7746f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb7820ed-3351-4cb5-8341-d6a48ed7746f@redhat.com>
X-Stat-Signature: gibg66tkjdpxac4wr5q5gndgzm9okyux
X-Rspamd-Queue-Id: 7F07640015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758196099-619027
X-HE-Meta: U2FsdGVkX1/Psj74C0gQuspsKpASRbDr/TR3DAGaQ+jwUdN7q1jMLlFkm7jXGB23JiCIlWfDNeVzpC67Glq9KDEX9dVqrkyMPAOe4JfYax+PgwlyuerUI5l61PKvLgq5C8fBcIXj3TCpSNSettIB9U+m3X2MNp/PMvDaXNV90gNUHeJKPdjs9MIbPh3kXMLW1SXN+Xnb+WZW3qHU6G1Ol0xWFcg+MvAqA+/b6Aq+MvZWv6I0KjuF0hy3IHutRtRD+r/cOPRuFT0SCiXTzVWaUEPAPE9WvM6iajTy/hvZ+PW6Vy47PZBWc14djUzeu+3bsZBggM+YGFuobAvojKYud1+x9Y1ExasO5Ps3ZT5Sdqyz6+tIXoPWJAgxtGmLMgaHeh9i53KCnVQ5dwx0wTJV2bnHhMnhTrNuz7rsuao4ixZ5J8BhE3XatE7rGpmh1NhGZIUL177JCn+whOMWjyfFsl4Wk9DwU2652Wy0BlahPyJAHptFcW8njo68TMEvmOrkk1Kb+B810QavQATO2XNx9FoDC+kPRhNQJLDhIqXmMcvnU4QX4D2jQSQpWa9Mt2apCA05S4feez1q61WjyjM/NMyZACviGe5L9UsuAG+dg3i9egpIklvJCKZx4VwoQiB30cgk3V6hAliZp+aUDwYXGXQWLENtdo8bavRrJhi6UTGbgrVF1WIf0euRWoVzsQ5GCm0Kzn1nxUCAm56/j+qHnTAD99wbmTQmWiZbOJ8r6vM2UPWcP3/xLQWBjA2aZ606ppLiRsTBWp0aNDBQ8j1HaQ9lDyuDqa21NW/pTVZXjgfC88HFPlO4q/WGutSQgcG1ZwOuwwWy/ItNnCRXy+rKFqc5Xd2GYSRMuuEm7tlFrKrMs8nK7UkEzQUs7zhLb9ngkjIDsDfQgg6FZ77xHKGev10kVqyPC0ixxYapBF1YqQy7luTXOb50rL/qR006z8nuB8lRZXaaeOYQs274D2k
 Gh97jvd0
 aE9xfwqME1my7N9gsElWJjeOUboX7S8xYJJIOoY5oUFXDPFR5lSI3inNydR+my7tm1F3/Ctn6IoFEW3zwQP6OIax0Xtb/N9HziIIPN6aHsCh8p/IgV2sVE5LuuknECXN7v+sYGIY2zBZyawh47RZVDDUdVV2cfAxom4KlrltCAY3ihaU4S4+BgQFpKyhiX1y7HfLWnIumQ8CsJgq090OLDIDmVVM/ElvxjTNmQhDsDgCby3zPB/JcY2b1qhSNeM/5M25DKZuzuJLg11s9gujvthL2y7J9tOE17TwX2Gs2XTe1YXo70gV7nGva0xTMYuuu6D3+p48asXS0RQfds2+NYXmQ50V5V5V6CCxew5h+bFLLXXNBDqbG2r/qtj9jDS+zA6ry5xzSxSACDERFaxePPCIPofeMjz+3fyvoq/efXq17N4YZTFguTnMNMtVSnaOnNOhDlXeA/EI8xiGXm6rALYp/nOMaZFOJwzoadjsxzjE3kSc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 03:44:27PM +0200, David Hildenbrand wrote:
> On 15.09.25 18:36, Kalesh Singh wrote:
> > Building on the vma_count helpers, add a VM_WARN_ON_ONCE() to detect
> > cases where the VMA count exceeds the sysctl_max_map_count limit.
> > 
> > This check will help catch future bugs or regressions where
> > the VMAs are allocated exceeding the limit.
> > 
> > The warning is placed in the main vma_count_*() helpers, while the
> > internal *_nocheck variants bypass it. _nocheck helpers are used to
> > ensure that the assertion does not trigger a false positive in
> > the legitimate case of a temporary VMA increase past the limit
> > by a VMA split in munmap().
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Pedro Falcato <pfalcato@suse.de>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> > 
> > Changes in v2:
> >    - Add assertions if exceeding max_vma_count limit, per Pedro
> > 
> >   include/linux/mm.h               | 12 ++++++--
> >   mm/internal.h                    |  1 -
> >   mm/vma.c                         | 49 +++++++++++++++++++++++++-------
> >   tools/testing/vma/vma_internal.h |  7 ++++-
> >   4 files changed, 55 insertions(+), 14 deletions(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 8bad1454984c..3a3749d7015c 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4219,19 +4219,27 @@ static inline bool snapshot_page_is_faithful(const struct page_snapshot *ps)
> >   void snapshot_page(struct page_snapshot *ps, const struct page *page);
> > +int vma_count_remaining(const struct mm_struct *mm);
> > +
> >   static inline void vma_count_init(struct mm_struct *mm)
> >   {
> >   	ACCESS_PRIVATE(mm, __vma_count) = 0;
> >   }
> > -static inline void vma_count_add(struct mm_struct *mm, int nr_vmas)
> > +static inline void __vma_count_add_nocheck(struct mm_struct *mm, int nr_vmas)
> >   {
> >   	ACCESS_PRIVATE(mm, __vma_count) += nr_vmas;
> >   }
> > +static inline void vma_count_add(struct mm_struct *mm, int nr_vmas)
> > +{
> > +	VM_WARN_ON_ONCE(!vma_count_remaining(mm));
> 
> Can't that fire when changing the max count from user space at just the
> wrong time?
> 
> I assume we'll have to tolerated that and might just want to drop this patch
> from the series.

Ah yes, of course, userspace can dynamically change it. Good catch. I guess
we'll need to kill the assertion idea then.

-- 
Pedro

