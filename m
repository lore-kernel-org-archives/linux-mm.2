Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1101AC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 11:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA356B00B4; Tue, 25 Aug 2026 07:26:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1D86B00B5; Tue, 25 Aug 2026 07:26:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7F16B00B6; Tue, 25 Aug 2026 07:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC6F66B00B4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:26:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4BB51A3647
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:26:52 +0000 (UTC)
X-FDA: 85139564664.17.57C2FD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A4A9618000D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:26:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GoXlgVdV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787657210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Kwg1vlmpiXfsrVuG+kXUemOecdCeye6XceIRD4GCkc=;
	b=xfls9lM9IFy6TV/9ohgPliMq3UP47PQWoWi5oM9BL7RzHotJt+XYBY3Djx0SNH8wIbjJk1
	X+UZ25KgSQaSLQ6I589EBCbClU1OIX465OAXVyGbd8H5N4uw8JoEWIRVAyZCWxv6fHaEL9
	h7NvsvlKCgd3hBIUKc4FVSVTHbiiLs4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GoXlgVdV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787657210;
	b=EQ/9yW/8aMqVWLf23hSr9M//ZW3PwGVIxlvnwLcB7lM3i/PxuFes6zsME7RpQr4mzRE8PR
	3Seyutkn/DcUnzm2hjOVmbXd2z0MMdjQpzAV38la991M602E+8p75LQ/kJRaKt5x6clOym
	Il/EiGdyVWh+gYmj2DRhJpn7ZEffh+I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD31C43DD4;
	Tue, 25 Aug 2026 11:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F260C1F000E9;
	Tue, 25 Aug 2026 11:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787657209;
	bh=+Kwg1vlmpiXfsrVuG+kXUemOecdCeye6XceIRD4GCkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GoXlgVdVnQB3UIKDtlCK2MeqgMCYQLVg5a+xp6sO3+cbWgVd5+A/I2aV1BFeUM7k6
	 BVHc7H3QnM5OAstm5ICZF1F8UtUkOy4StSrkX8dng+bSYclRRQOkGUeYGNXJIH+4/P
	 l6uMBxScbiacbX2oODUOkqBBoDvwqh6gu0SouefX1HJd802b3VnwzhSPutCafbEAgU
	 8TdZqHlqFtDqM86XjkQzIPwG4CoL+2UmnlHJLOG1je/70VJB/I7p+JYvsI646XL6a8
	 Mci0t5DOw3pDjpm/SEMAL6Qcu0JDgf8r4KMhu5L88J2MrpMu0jWyZHq0dsDmDpecvY
	 UJWoV4aI7U0Kg==
Date: Tue, 25 Aug 2026 12:26:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] userfaultfd: use userfaultfd_*() helpers instead of
 open coded flag tests
Message-ID: <ao17rY2r-01wJxy6@gremlin>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-3-3086981b33cf@kernel.org>
 <aoxdWWMEeQbcG5Pq@gremlin>
 <ao16WPoLpdIdU3ID@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao16WPoLpdIdU3ID@kernel.org>
X-Rspamd-Queue-Id: A4A9618000D
X-Stat-Signature: 9jpkeff54kihafha9s6aeyptznun9ypn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787657210-312938
X-HE-Meta: U2FsdGVkX193W+HjVOxCH+1c08FAdu3TLwuFdBG3rw+3VqPii52mzR9uoprGgszFbW6gBZ510L+DfE+DSpTB9hl5i90yNnQOoDpZmkUBgW7PNktH2Yj9BjpPOdwj39yqEz/EZBXyBA1RaolN++OsO3ScrYmclA64kZZwRSR4VfgSuhBts7swHg6lbDp2Af7QG+mWdgS2O4e6moXgD9nlWQiiYKHRAku67y8hWPzNsbv8DltziXjxemglgdglaxjTIZTPVQa6cgfsXAqA8X2BqzjVQaBiF8YcR4tNOrYD0ITgxmEvJuBnFi0RDkganZCb+E8ofSv1+TBYukGQbJS7nwngc/t3Dd7jxe+7ZYm9WeoDftaazO5wtXulCvcLAoGF6MGq5lyxlUGp9KZo6UPez5zRqHvotQr6WQTGelhJTp2Waqscr7pAQHbxfMkcaTXuoiQGhoT32b2x8Y5NXPk1QGmDWwxX6c2HvOC5ZZ0ZdmspY+GQX0CktTuXlRMdmF4YBWBOqkYA2okGp0CU0H0PY30IT6mlXYGX6yBPiiuOQCdmUVzfrCsb/IeyUfFVvTuOJk56i7Qcnk91iGH74MCYZObzLN9EIdhLmIjxGMBD0ZX7rCYCy3PRbwNXda41fetXoHw6u27I6qe2Q7g4uga/sHTC3RgBXIoTaOLIMxXVWBj2I5Sx0qG6di02INPdXmM4dVL8fOewk9bp91eNXs62Ijymu2iTlQgZvq0esxEv48wnTvakw6UdaVKda5+9S6/sUvr465Lm0IY9GQh+YBm9DvYuBYnl1gX2aQ40VydDMY0OOmNetvzHwBAdBDNEycwjvGfv0o7R65bqYGboLIec75rHyb360EFZ+INYT8QocwRONXhVA9M9IQc1nGhkvGPUOilSUt75mSp4GrzjecYgeDQ+BF0N4/wb/B19T5RTZtTZT4sW9O8WLaNfMNNHLz7TqCxNiHWnA8eng3Oq1FP
 ylDMmUsz
 FQQzbym/Aq3LX7fNVCLchOdUlLE7IUesGKYL437Bsgh4fURPqyU6NGq4FYNPhl37qS/N9CoU3+qGaHLpYkB2iELUHQmD06L/wLDGPIe7dFFrlcFWhrST3oNWVxb173Fc7SiGCtv4MQawlvonEJhP6SEtL1PqZ9JSDhT+GjzVAI/Cfs7KipCXukXaqj7LoBlYP0daNa6duTdFzvhWVpAaF+N182iScHC7NhEtV0/nWgd7F89rQ5HKcnkaz1OmY0nE9XrFw1nWmgTFvF1/C1Cqe27e2UEIPLtqwWp5KD6itBJv6bQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 02:19:52PM +0300, Mike Rapoport wrote:
> > > +/*
> > > + * Don't do fault around for WP, RWP or MINOR registered uffd range.  For
> > > + * MINOR registered range, fault around will be a total disaster and ptes can
> > > + * be installed without notifications; for WP it should mostly be fine as long
> > > + * as the fault around checks for pte_none() before the installation, however
> > > + * to be super safe we just forbid it; for RWP, pre-faulted neighbours would
> > > + * be indistinguishable from accessed pages in PAGEMAP_SCAN (PAGE_IS_ACCESSED)
> > > + * and pollute the tracked working set, so each page must be populated by its
> > > + * own fault.
> > > + */
> > > +static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
> > > +{
> > > +	return userfaultfd_minor(vma) || userfaultfd_wp(vma) ||
> > > +	       userfaultfd_rwp(vma);
> >
> > This is changing the logic.
> >
> > Before we were testing only the flags, now we have:
> >
> > static inline bool userfaultfd_rwp(const struct vm_area_struct *vma)
> > {
> > 	/*
> > 	 * Callers gate PAGE_NONE usage on this; PAGE_NONE is a BUILD_BUG()
> > 	 * without CONFIG_ARCH_HAS_PTE_PROTNONE, so fold to false.
> > 	 */
> > 	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
> > 		return false;
> > 	return vma_test_single_mask(vma, VMA_UFFD_RWP);
> > }
> >
> > I.e. adding in a CONFIG_ARCH_HAS_PTE_PROTNONE check.
>
> Without CONFIG_ARCH_HAS_PTE_PROTNONE VMA_UFFD_RWP is hardwired to VM_NONE
> so it's functionally the same ;-)

Well then you're explicitly removing logic and not mentioning it anywhere
with a NFC commit.

So please say so in the commit message.

>
> > BTW side-note these:
> >
> > static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
> > {
> > 	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
> > }
> >
> > static inline bool userfaultfd_wp(const struct vm_area_struct *vma)
> > {
> > 	return vma_test_any_mask(vma, VMA_UFFD_WP);
> > }
> >
> > static inline bool userfaultfd_minor(const struct vm_area_struct *vma)
> > {
> > 	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
> > }
> >
> > Should all use vma_test_single_mask() really :)
>
> These are changed anyway in a later patch.

Yup, but you (potentially) break one of them. Will comment there.

>
> > --
> > Cheers, Lorenzo
>
> --
> Sincerely yours,
> Mike.

--
Cheers, Lorenzo

