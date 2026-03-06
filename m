Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D608F01828
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5B376B0092; Fri,  6 Mar 2026 06:22:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A7C6B0093; Fri,  6 Mar 2026 06:22:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92A176B0095; Fri,  6 Mar 2026 06:22:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3666B0092
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:22:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1CE121A0553
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:22:45 +0000 (UTC)
X-FDA: 84515400690.25.BED2014
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8357D80007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:22:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gyjoiYFu;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772796163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qjEPDZzLdKxg9oBPChZA38aKdT8rDNCWfPfrCLIRwL0=;
	b=IJ/1AqA6EM8wqGy11Ql1NTXk9O2oMVqm+0jWJ/wQasyIR9blvQBmBOGRnv35d4msrohsVl
	aZneQ1/bn65KFv9Ssz/2WKvKKw674RwBpESBN8Hvm8eMDp8T8r+mKRG2ucqzNbro/tRQxz
	GUWPywGvBQpGyOzUQuqyqA37WgKb1ic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772796163; a=rsa-sha256;
	cv=none;
	b=QHU++QevmZ9iIxNFcobbA8LyWx93n/Cta+HASQzvxbT8lDbs8NioIz1x5ip6QQomiR6RFR
	tT4S5MVzAB91ytZF2druPhSRQ57aheWJP4mIiu++R3v8lIK2VTliMgy9ckdBpW6Hw1wBg4
	+9hsxdEB2kdhLr1Vg6VbHjaAw7Vdr4w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gyjoiYFu;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D23D460130;
	Fri,  6 Mar 2026 11:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC26FC4CEF7;
	Fri,  6 Mar 2026 11:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772796162;
	bh=2SvhT1C5WjYcV9xC7T8OBnpoJjplcky3WZNU2kHXa10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gyjoiYFuU4oiuz2tYNq+r9zAk9iadm6YZHQHzpCX5QiBvcEpB6pIdFgJAxebfYj7x
	 Oj4H921zSgUgxKLYNKeyvI+Zgjr9cJy0KErbixhrR314dNcs4LXpTtFPW4M+SSPaDT
	 JoM92ylJ40Xm7OrGLf059kMfnjPqaQJrquvq55ikIR21YFjmaRmbssSruJavTL8Eu8
	 7faK5SHU0LbndcgZpQram2X4BlI5DhsAT51UAv2JpecON2vimG5dy3KDvMTNONIAln
	 34KYdD2MUqkPLy7XZle17Lrw8hxflv0rLgkOWYpfIgK0GhB4yEdqd08Kfj9HlGpnQ7
	 cAnlIiSg3Sh0w==
Date: Fri, 6 Mar 2026 11:22:39 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/3] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
Message-ID: <789df8d5-7d03-4e3d-90b6-08f27af330b2@lucifer.local>
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
 <20260305-thp_logs-v2-2-96b3ad795894@debian.org>
 <8b238664-4375-413c-a8cc-105d98430362@linux.alibaba.com>
 <aaqr6n3X-KRP_tTp@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aaqr6n3X-KRP_tTp@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8357D80007
X-Stat-Signature: 5ueha1hpa8q9ihjgh3rf733mbgrmbr18
X-HE-Tag: 1772796163-690414
X-HE-Meta: U2FsdGVkX19f6HnWVS4M0R0Pt/tKkQCWupM668d3a7U9bbzg0QyMVho0UvWRZwTMa7ZETTslRozqgrZYu7aQDyo9KZOkehqaSPnHjZKgrQ0+yQiMSmffy5sn2+Ottr3eCGYxfbSdxNms5q5r8c3lGOG0PS13xAPNu8M9Y+bhNyUFRs7WiRVOwPGEWi97beXWAbdFAnz6OB9Mhf2QDBRB1Nwz+JKOxmGddrRFogRQLXafQlPgypXoM4dtvieeomNBLA/rVVQnb0sv1PnBgnm24nS4HIOm9yPjPQvyVPV7fQDMca9JDzGfTzxnqx3Z+GNngE9RDEJuBPJmXibcUn2Mg9k/zqDfKdvKhUs6lnZlH5Wtvs6Nk2UOChsl+9PP92e1KzGp6STYbg/UKPKziaQgndSqweevum5tK+bkyRiisEvhBYRn63tKMvXK+AD76ysD+kPDiTfp2RwLAWIpUwcob1nuMLvkFMWjXRfxJBTDhXiBMsEqUjLj/j0ZyrgIHsGJBPOMtkDbpniOnwf+zvO5nxUMID/Mh8E8hy5r5/qSLuCtrWW+I4uRAHh+RiPfz0Bx6ipi+Kcr71GFIy46fcz3eOa1OfCSoUQOUT9JaMdJ8pFBW7iM6k/oWGXOgiyR8OCMD6Ncgmg1veAbuzJsJuqxG7RIuZcJls4s4BheR6m5wBqRnbow8A1nzBsz0O03Orm+RMWFqhMfgPv/DG13NmAD2vsIe5zchnu2FdJMkDtus9cXrpN4glCAZ4vDqo42R9cS5ExkTt72Z/aTo07CROAzaDpXzERq/mxTa2uPavh7YDlDPcOrMa4y6DSRZRnrI+BijhcGUCC1Qn7FzrV5qS7F7uGkuE/XONQGPuZTKaTnoTHxu4OCLBR99W9elKM0paCf9U5s/m3lRQSQkdzN/nnn+WX2ngbyK3d9NbPih5d2evf+a6xpMF+0unt6ZPKYQQeyMUOg8WNkICqHQMz5/Xz
 feU2BGdX
 xSmW9E0EZdGmoO6mvB3ZeBxhVOVCo7Q1q8/MCfq1XlvweUYvlcjbHR6X3D1eFFqoXwXRjHEsN0j8vnWLoi5UXzJmJCg/vERyqrJWFCw1JFfzM7d+qpZRSuin9OOOC6k9B5MOzOEJL810pQpb08IpQhXFkCAjYnRbrw4exN5xE+oYqbmYoPMVLvfuCupY6mqHsri5d3vLopspH1DQBb0g48I4ovTOYJOCYp1S6Irg6JniG+zc+FwtUcbySBYbaqMmKgGVGXgBwSigJQnQxEQjiZKsd4XRDmB2Qauy9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 02:30:22AM -0800, Breno Leitao wrote:
> On Fri, Mar 06, 2026 at 02:07:50PM +0800, Baolin Wang wrote:
> > > +	mode = sysfs_match_string(enabled_mode_strings, buf);
> > > +	if (mode < 0)
> > > +		return -EINVAL;
> > > -	if (ret > 0) {
> > > -		int err;
> > > +	if (change_anon_orders(order, mode)) {
> > > +		int err = start_stop_khugepaged();
> >
> > Thanks for the cleanup, and the code looks better.
> >
> > > -		err = start_stop_khugepaged();
> > >   		if (err)
> > > -			ret = err;
> > > +			return err;
> > > +	} else {
> > > +		/*
> > > +		 * Recalculate watermarks even when the mode didn't
> > > +		 * change, as the previous code always called
> > > +		 * start_stop_khugepaged() which does this internally.
> > > +		 */
> > > +		set_recommended_min_free_kbytes();
> >
> > However, this won't fix your issue. You will still get lots of warning
> > messages even if no hugepage options are changed.
>
> Correct — this was part of the earlier discussion, where the suggestion
> was to retain the set_recommended_min_free_kbytes() call even when it
> is a no-op.
>
> As for the warnings, I see a few possible approaches:
>
>  * Remove them entirely — are they providing any real value?
>  * Apply rate limiting to reduce the noise

I think rate limiting is the sensible approach.

>  * Something else?
>
> Thanks for bringing this up,
> --breno
>

Cheers, Lorenzo

