Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEEFBC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 07:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEFB86B0088; Thu, 27 Aug 2026 03:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78AE6B008A; Thu, 27 Aug 2026 03:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6A966B008C; Thu, 27 Aug 2026 03:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BA096B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:14:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2907980362
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:14:26 +0000 (UTC)
X-FDA: 85146186132.12.72836F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 84A94A0006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:14:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNddaP5u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787814864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Raso+76RSPHx/Ucjk+/qBSNVKh7+vQJnbwdEuNJBG/U=;
	b=2wvi8If75Hw72y6y68q4EzRuAcCzCPVZX1+xVVZWpQVuIviB1Do0Q55jgO2PFQKjFAnbCO
	rVrgsG2ElX4hHTNSjPULNfyEUhAzz8AgcTV7LdBunHL5D2Czaf3DWEkEbDH/hfDw7UZYCp
	zhs5HRG86XisOQwpy/6h6Dpa2f5E4yU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNddaP5u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787814864;
	b=6kkUyOX3sZudUvmsyqmEOAYrTBm7yqYz0C2ymIW6greJnhFq11biE+SadRrwmHTVURW6aw
	0yvQKU2I++2er74d1wMSYtQCI38T8LfD/dIGBrxUhjhpB7OXZOhphSvjlUyx7zCZGi9SIO
	hdy1zpKD+SBTCuz6p/qHEPDfTr4LTCg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08544600D4;
	Thu, 27 Aug 2026 07:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037CF1F000E9;
	Thu, 27 Aug 2026 07:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787814863;
	bh=Raso+76RSPHx/Ucjk+/qBSNVKh7+vQJnbwdEuNJBG/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fNddaP5u4ClF4IxDP5h5xr3XP6tMYYeqDdj9zpbu5LHBY7nbpaoRRntLYSgV7jemr
	 b9eLgRPTDx55zngs9LXGmNbvEDH/S2ZXviXqTGjqmMO18aqmlUKhwWsgR1XWSi+/0G
	 rwQSwYcLJ6CvN57sswjLw5O5CfbNZF6CvrJ9z/3LjnO/hU7zrUdVLmkjQvW7ym603+
	 shF9ZXkrNBWluvZrGvfEWxHokaZVaa8X2HYN57n2H4s2ocnLV2KnlrBBib7zNEk8i4
	 1AlkgpTeTZgRm5MwacXLRcAE1gc8MYWCCVB+RwCd2LHQ7Em+lyzBK1JY1/n1207Nyi
	 X3uuqMYW2BQCQ==
Date: Thu, 27 Aug 2026 10:14:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] userfaultfd: use userfaultfd_*() helpers instead of
 open coded flag tests
Message-ID: <ao_jxMovVtj8UWeP@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-3-3086981b33cf@kernel.org>
 <aoxdWWMEeQbcG5Pq@gremlin>
 <ao16WPoLpdIdU3ID@kernel.org>
 <ao17rY2r-01wJxy6@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao17rY2r-01wJxy6@gremlin>
X-Stat-Signature: qx86yuxbn54wwh5zgpy6fr5xux1zhw4j
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 84A94A0006
X-Rspam-User: 
X-HE-Tag: 1787814864-447490
X-HE-Meta: U2FsdGVkX19D+6Xt7C9mdoYpTMGIaykQG7OiCgBQraZuD3tn+eAuGsBAMiXcrTakCk2gu+9ZxrjhkHsmVC2qGoDojT1fmV28yfMQj/NgTGIcNOUKnPfnmQi9ZM6VUba06HtCUidkwP4SpILl1r/oPdqtvfj9hsarCA+dujo9plxBZWGDXIzIf3nLzCDqAFdkbKodf37z/5/5VE8NbnfO3Eyw0QG1ZaWJd/l8YlSLztKpHZymMDYWOhnMN0119TgwWGvCCjS0kHoIxUa2q65oXM2M9nlo5AFa8Kq6IbU+goGeOwYtSQB03qBIkdGVRWpYCbspwRSgxntuwQDVaCty850ycFYgrDBFG1uWG6dZsOQYt3pmzIm894p+LjpTXWaX2wwgTEepQxoyi0JviX8m+pslbYoIMdgoxs33QSQhJ3zmszkFYONNFu3dfPITRgQLeVzWXCchioRQUuwmBvtedvAmpQQaUI+CMYHSQ6HUVdvK4ngiVaJySx5bjf7ZcNGZLkf0KKgRZoCuLluD+y3aXclJHlcNAMHWDC+XkzjFZZRc7YRcUDKQhEHosKNN+0kI5AFafO7ZLuF709At8zwk2cypCZK6V3QAc+gvywdltbJCEbohESda84jHhefqCWu/Skzo9+Uq5xUuNxuJVGxTYYduC/FWjkohMAEKq9EzZuLlgPCyIPxbNKuTRMMu5z2SsFHxHipR1WpBotOSm3hL/FCc7mjbJQ7jEA4Xl+eO+bmt+7yDA/6yDqhjLHmpNuwcsL2c26DCDhya5o4lwQMEZ2WH2owPZBZRMq+Xww42Jwswo1EczrlLQTsXPk7S24Wbj+LB32BGmWOcNrmfHuuIqdD8f6saY8QO47ZcVDLbq3IOFDGWoVSVHdcInHWqMXKwy8U2JoBxRzhjKz1q9KF5m/Tpv/1D853NfaS3kZGzPCyyvxhBo7lZQlwHhoS6B6mOJGudEcqjQcwl8jeJeEB
 MFEZkvG6
 oseQ/zXttk97AnWWAiac7k9UrGNTz9FozyvFxN6/nqobYULGkGyAvzv0UocTjpeGTkDesNQN6880S33uzi+lGGIyeFBUPhlOHGUec0+o/jvTBMgLSKeoZfkyLw8OmMi5ooGSOH6XQPC6KkFWJGP63SNHYFoJlg8OOwc6IoXJ9uEaYFJUWI4ObCIh/dtWu1g6XJx0s9Inx+Al+ttQ8BaYRytmN0aqAMepCu4Nr5O+Y7CmEoheB+ovMqlJfoo3d0IRUA4CyaYHICVHsYoZGk2xrlDTFiWf2Lh/wR+8YCG4Lit8xDgHSrm9d/7Z9yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 12:26:39PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 25, 2026 at 02:19:52PM +0300, Mike Rapoport wrote:
> > > > +/*
> > > > + * Don't do fault around for WP, RWP or MINOR registered uffd range.  For
> > > > + * MINOR registered range, fault around will be a total disaster and ptes can
> > > > + * be installed without notifications; for WP it should mostly be fine as long
> > > > + * as the fault around checks for pte_none() before the installation, however
> > > > + * to be super safe we just forbid it; for RWP, pre-faulted neighbours would
> > > > + * be indistinguishable from accessed pages in PAGEMAP_SCAN (PAGE_IS_ACCESSED)
> > > > + * and pollute the tracked working set, so each page must be populated by its
> > > > + * own fault.
> > > > + */
> > > > +static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
> > > > +{
> > > > +	return userfaultfd_minor(vma) || userfaultfd_wp(vma) ||
> > > > +	       userfaultfd_rwp(vma);
> > >
> > > This is changing the logic.
> > >
> > > Before we were testing only the flags, now we have:
> > >
> > > static inline bool userfaultfd_rwp(const struct vm_area_struct *vma)
> > > {
> > > 	/*
> > > 	 * Callers gate PAGE_NONE usage on this; PAGE_NONE is a BUILD_BUG()
> > > 	 * without CONFIG_ARCH_HAS_PTE_PROTNONE, so fold to false.
> > > 	 */
> > > 	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
> > > 		return false;
> > > 	return vma_test_single_mask(vma, VMA_UFFD_RWP);
> > > }
> > >
> > > I.e. adding in a CONFIG_ARCH_HAS_PTE_PROTNONE check.
> >
> > Without CONFIG_ARCH_HAS_PTE_PROTNONE VMA_UFFD_RWP is hardwired to VM_NONE
> > so it's functionally the same ;-)
> 
> Well then you're explicitly removing logic and not mentioning it anywhere
> with a NFC commit.
> 
> So please say so in the commit message.

Ok 

> > > BTW side-note these:
> > >
> > > static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
> > > {
> > > 	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
> > > }
> > >
> > > static inline bool userfaultfd_wp(const struct vm_area_struct *vma)
> > > {
> > > 	return vma_test_any_mask(vma, VMA_UFFD_WP);
> > > }
> > >
> > > static inline bool userfaultfd_minor(const struct vm_area_struct *vma)
> > > {
> > > 	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
> > > }
> > >
> > > Should all use vma_test_single_mask() really :)
> >
> > These are changed anyway in a later patch.
> 
> Yup, but you (potentially) break one of them. Will comment there.
 
Nope, nothing is broken, will comment there.

-- 
Sincerely yours,
Mike.

