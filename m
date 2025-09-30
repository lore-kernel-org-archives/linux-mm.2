Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F3B6CCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50F18E001C; Tue, 30 Sep 2025 06:08:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00D88E0002; Tue, 30 Sep 2025 06:08:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EFE48E001C; Tue, 30 Sep 2025 06:08:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 788AF8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:08:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E5EC44554
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:08:02 +0000 (UTC)
X-FDA: 83945490804.27.2BFF312
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 73120C0003
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:08:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PPFoM2jB;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759226880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CvoiLqxxKQ0jT9slf+t6DRAd/5akH8KBN9CMAMdhcA4=;
	b=Cw7y29sSA1BvECRMcp1pXNQOQArr7r63aSynZ13L5k/1/0fbk/5lXkgs9jNuUiU7qfIM9a
	RyCOgb+R8dstO2u8MM9OfAa/W3FJRNBQesG/LC/msRoRvBgBYureSKbLGoZKsAaW1LTzpD
	bQKor4oUPHosAcNMjlUjIrQStn3owf0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759226880; a=rsa-sha256;
	cv=none;
	b=JwfsiSOCL3noZFd8Ep1GVolZTztAksNuo3ac3Nh/GkWBxOgcWnkgSlHlY2wcOn7boHZTFD
	pz0ZMbpVsspiedLQAkB4Z0XFojqqCxMf1WSFKqSmCdWuyVzUe7WQPZmfxq2HUMsLyyRKxg
	M4OkghG2A3TnbWeRk5BnPRvg3kJL01k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PPFoM2jB;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 151B140127;
	Tue, 30 Sep 2025 10:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3040C4CEF7;
	Tue, 30 Sep 2025 10:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759226878;
	bh=iaTYo42AMbeWEpSjWoHhR0ggf4sFotfptbmlFUWCPr0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PPFoM2jBVRv5qpyhc8HiiNBCJxADagb8/rS9CmNMB1PjEYIY9FJqprLktYosCrr4d
	 MJICc96nK4yJ8BFPoBDCLK53IsCOeKrVVGLkkTCdMO0AOyZwvvLCUeDUZgyidmJ3d1
	 l3QaFlvxESd3dsppQ9sMTAkZO3QLqHjhuHlxMDmXRXiqP5gDptFbEy4FITjKGk48Ys
	 mcUU2RrRkAm9w00OJZxz7mV9BDkAf0cWZncSX0Eg0szswZXYfvJxOoy/JsDEghgq2I
	 YMBnUxgJg3GUhhsGPiQFD0oND8EgMRh650+Qsw/WNyBV00Wlq1uFsnC3xgEKnu/pPZ
	 6Z76IJLF4SVDA==
Date: Tue, 30 Sep 2025 12:07:50 +0200
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aNur9nbdnlykqbU7@kernel.org>
References: <20250926211650.525109-1-peterx@redhat.com>
 <20250926211650.525109-2-peterx@redhat.com>
 <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com>
X-Rspamd-Queue-Id: 73120C0003
X-Stat-Signature: kai6dob4sc9gup5icfh4eiqc16gsxrrm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759226880-994570
X-HE-Meta: U2FsdGVkX1+CuE0HmXkSol3M+qsUEwLlZ5TVPHOb5bJbOBuid2sJbhbJ+dGQhl8Mt2r58lpvtCZ6Okxa9DGIo/lNmei8uB+O6+sVBZJZbpjNjmEa5xsLrb0xIdn1eGJcAt0XVkaIINonJWJQW15cW0QPAEYj3qDvfC89A4Dw8B5l7M8Cgyj1F3eq0uxsLMX2dDNWLsJci9mmXBY2t8+LQTXj5B9zwaLpT6JadNpd+xAOB9fw1WVjvDCufsAvQOirpzy2hnI3GEhxz3lESamw9pd3fkUoXsbSbS0bBV+G2uiC3I94cn9qkDeckNcxJeaTphPsICOL3oNN2xHq7wfnxG/aU4Sq2/lsV+5xMf2i7jKISkMu7tv60Fb1aDot+IotdrW3NFHEDcllKZVinGBfycxXg6L01gX0jgoP0F02/krMXjS9BqOR39ZgJqdVnU6wAnv4PvwsjwMCXJ6O3CSp6johQqXy4TRWsr/BjMDvqy8XaPzipsiHAuueQdQWjMABaR+4DEMEYgT7oAAbC3QD5xq1yHHR4kJw4cJVIPiXMsNqyHjAas9iW5CePDdhes6JjnA+a/cljoX/a3AKx/cxmPTzLbiu7/VYZKqn4SIMQ4vGZr8BObG5nsKY/hyY+qF5c7UE2pxRm6lDlu12A44FBYF2D117UGiVs4KHtUBmnJPfKD6CupavD8pYS10L+qocrOrrOPXFVd2mHqDivn14D0l3xIkOzc0XadGAcRH3NCTsi64REKrjh2sFqmLp/JpQERMMmjmKrX5wPgoaVjcOs1fJkWlyqc1FgwCDqnh66I4vLwVWFSD7rI914Gm0Nl32d3c/7/+E6rjbRMQI/CG1v5JMR3s9UjHrHfz7YpNXTuiJqrs/MzMLOUn3v/lS9QKVRx6Gz1vBpkTjougryVaK8FTj6VrYbOvNuUnMhTf9clphlih1GfMio6RAZqiF5dKuZmutP+hssTwSA8muggY
 nzS2XyC0
 nNV1puM80q7yNX2B8xNBXHha7G6RFCaiTM+nWPDrgbznL0XoUZCbPfKKy24Kdcrbp4VkWwRs08OwjrmmX/yOetEiARqJmqBGA+1mFTSz4u4016yxxXwpPK8QAKqshwpVARhunYKjKDAudYLo9mA6nNVAj1oJx6D5sT4/AAgZHUtr3IlFfFKebhHRMwr14Rkhd+CJQiovzpgixiw6A07GXNZggVXcVMiDoDm6d/rsYmj42VL/WTA2bmgus8ECFB9Sxc1X8JFyKeQ4RtomWP/5EYqO36J6dN4c9URrFP/GJGFqU25SF+dJW+L5ZbDPbrE0HeT5Xb4gWeA0URvo7T/VDmK/qvcIoZA5shQHG+xRNA5GE4YCWJdSyvBmBAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 11:36:53AM +0200, David Hildenbrand wrote:
> On 26.09.25 23:16, Peter Xu wrote:
> > +	/**
> > +	 * uffd_get_folio: Handler to resolve UFFDIO_CONTINUE request.
> 
> Just wondering if we could incorporate the "continue" / "minor" aspect into
> the callback name.
> 
> uffd_minor_get_folio / uffd_continue_get_folio
> 
> Or do you see use of that callback in the context of other uffd features?

If someone picks the gauntlet of refactoring the loop in mcopy_atomic()
we'd need a similar callback for uffd copy. And as I see it it would be
different enough to warrant emphasizing minor/continue in the name here.

I also think we can drop uffd_ prefix for the callback, as it's called as
uffd_ops->get_folio() or whatever it's be called.
 
> -- 
> Cheers
> 
> David / dhildenb
> 

-- 
Sincerely yours,
Mike.

