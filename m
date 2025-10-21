Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68440CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 06:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 744D58E0006; Tue, 21 Oct 2025 02:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F52E8E0002; Tue, 21 Oct 2025 02:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4248E0006; Tue, 21 Oct 2025 02:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4924C8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:08:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E2E1C1A0418
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:08:05 +0000 (UTC)
X-FDA: 84021090930.26.60BFFDD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5A13B100006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:08:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lRELKDno;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761026884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DCWE6hNFexufbkWR8smCeK+2Vm4TzkJhkNbu759JgZc=;
	b=XP7ruDmBE5PLTweIgN4UwKjI9IjafPOZ9wtEwUvD0ZChK2DAPq8KCb+e6p3YrSAvlpsbe2
	sD2vtChz2vax3m2O1u+YEaz1TVFYe/pzBwUDyGdT3IxJVbju0hTAyi/Rdc4tdcPioIx6cG
	stw6m5RzkSzNaz0zJ5xwInc4gWeb+UA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lRELKDno;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761026884; a=rsa-sha256;
	cv=none;
	b=qzRNjX3SnEckCAqRYtkZFLkawhOaFw6APfDCrX0GvQ4F82zAMgxIayq471VUCUHnYgC8zj
	GVCu6ujUegBy+CnwzsPt8HDnprvdZnysKRYnOx+O0jQIBI1vvK+LGLLgA1ZqJCSydGT4yk
	TOxPFNUPUO94mzCH0dZeGamoMwCeTD0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CFC3160376;
	Tue, 21 Oct 2025 06:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC12C4CEF1;
	Tue, 21 Oct 2025 06:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761026883;
	bh=KX+JYKF1y0Dvw2h+Mz2I5TfkQfSSqKYj/0y4E0pO12E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lRELKDnoWkRV9xEm8QzW+zCDnlJvcMIKB/wq+0XilgXo6YixAy0V4nqwPQuvlc0wP
	 jR4vi6ygz5NzIzL30l50of4pIRqEpkcm9SNGj1xyFWavoSdJMPk+qPHLbP4qvN+N+y
	 TN+DrzWCGi7OHfA7HGPXujE03LZ5rZjDAK4dZH8/jjWQGh4MAzVOHYZPPW6MCBZtLL
	 Km9v+O2ZvdD0v7FfchZLTxSdTVYqr24TYdXWbMoVjEqgvcxuZgnt2uskC173awwanx
	 FJM5cuokbtizUMfwBOUroprhu6A7coUGHHFTyoF/sDgE9NWbrLFGh0Xk06mK8Tu8NQ
	 L5lXifxoDmZUQ==
Date: Tue, 21 Oct 2025 09:07:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Subject: Re: [PATCH V1 2/2] treewide: include linux/pgalloc.h instead of
 asm/pgalloc.h
Message-ID: <aPcjO6pCHZCZiRZ1@kernel.org>
References: <20251019072509.9488-1-harry.yoo@oracle.com>
 <20251019072509.9488-3-harry.yoo@oracle.com>
 <aPZKuOKlb87yX0du@kernel.org>
 <aPcVlz2Auk4JK2ds@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPcVlz2Auk4JK2ds@hyeyoo>
X-Rspamd-Queue-Id: 5A13B100006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 3yqx64ri9how8ji1b9c7axywxiwydpcr
X-HE-Tag: 1761026884-198624
X-HE-Meta: U2FsdGVkX18cIfeV0ophvkq19IvoVMB4hvPURaVTkqIcAWWTyrV0qNYpXz3f8jP99HobsCdEtsHX8nJVfYmT3jDxYL8SwSIc9LO61zZQT5hu5pQb/WAXCjG7Pi7aDOfqiZ6nzqUJlUWxaUg9owEdosp2c/R8IWszmT1rETmrEGoh9vcMWspqljEJb65NpW0CxdBm9ONtsmUdQlPuYtFzxOXiw5YZM/2kjnaMHmc5j9PDLJKtXxvkKQ0XrEWNYVPgXIWrhm+mJdPlzvvIz8FVBD65ojGYqHY3jOWgRPQCmTLlHI5htlIKetP4NxyOs7WteeWWBe6VOg6/yG4o2RHE7xSby/DiifKWTadNSyl0zPDncKdkKe8eXqHGG18Bam7Z/IwZW7s6P5gjACDzU4JZMpXIrHbWqWLhnZcTzQhf5DH0F9fGVWvOx6Oll1DFlC3CqiQXPcEIw8GcnHMXBRuGvDjbYoe+mgQSjrgJSQiaq1ruJu8MRqI41UNV8lVKq4WOHFCeQIoTJtZ6nl5CJT51446h3FKnedly9gUoGXAhReKXyR/PcSPOnJdu28/75kS81p8xIHImU/4h0aNm2wTg73tRjVsyU4P/Ja3vKn6JR1Evh5I8S5n0qV7nWeoZOvlXQ+YNH4JI1hHRmBaPFDnH2gE3ovcW9BOeYEHHiTqTO5tiRrjbrdTyWffGvRmNy5ti61oCPW+nqIi/7AzU+Nc+V31DlKh93M4bdiveOyRC5Y2rrwKtXF6/E3LXfqkeSjX2p3pcvk3QL/Y12Mbyhq+Ad5SNHH/MZ8la5mzNR0q95zI1sXChIEzUHbfFvDARSDbakqztQmM0fHkpYq7jNkS4fWPTCpR0YcdAvJp1e091I4YtyVDPEIBJwR7/bASYNu9rbSe+Wp8kmqTWXQJiVzTE8XAg8H9yRBjCXd8Avfl46YYPPescaFEwLw/AW3YCyjVk7j7qgvhVJFRXLafYZEL
 4ORiWrWh
 usVvatD9dZl38xMeLU1BGN90O4hsqKTHX9d4wvcymFhDK/ae2PEcLC4NfB8Mv5xQmGRw+xdlowzeZlt3koPXZjF50kcVNleiHwklALXkhnhNlD2cNpWujaLTO04cC1jK0dwWuXa22r9fanDTZvByjCr3QX1I9TOHwYDDynYB/OQEo8LGFK6Uds2veJYK/WHmrTznq2TeQg97M21LRUt7IQoEiuE8OcHKXOIc5GRxAiCMmMqZb14/KDGhDsKlWPtrLrLtWCHoLhR1m9KR+GkMVtTDsBhI0QIm2hm5k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 02:09:43PM +0900, Harry Yoo wrote:
> On Mon, Oct 20, 2025 at 05:44:08PM +0300, Mike Rapoport wrote:
> > > diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
> > > index 7e9455a18aae..ec6fe4eb2644 100644
> > > --- a/mm/pt_reclaim.c
> > > +++ b/mm/pt_reclaim.c
> > > @@ -1,7 +1,7 @@
> > >  // SPDX-License-Identifier: GPL-2.0
> > >  #include <linux/hugetlb.h>
> > >  #include <asm-generic/tlb.h>
> > > -#include <asm/pgalloc.h>
> > > +#include <linux/pgalloc.h>
> > 
> > Please move it before include <asm-generic/tlb.h>
> 
> Will do, and in this case no empty line between #include <asm*/*.h> and
> #include <linux/*.h>, right?

Won't hurt :)

-- 
Sincerely yours,
Mike.

