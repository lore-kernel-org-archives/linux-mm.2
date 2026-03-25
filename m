Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73607109C036
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFAE86B0093; Wed, 25 Mar 2026 12:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD27B6B0095; Wed, 25 Mar 2026 12:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE84D6B0096; Wed, 25 Mar 2026 12:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA3466B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:24:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 576071407B9
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:24:07 +0000 (UTC)
X-FDA: 84585107334.12.2F86CA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C153CA000E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:24:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BSBG0LH7;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774455845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+cQS26H7vyCKrxPAvHHZDmBa00xHiwKvNzjQXsWfXo=;
	b=zC6QXe02CmG79pD86Y4lIT0JqPVGyyXtehDNV5xr4jJKGsufwvDWP1XjTpDuhKMAhQx9dT
	vI6e5IJOCGS22la+2eEJMGIYtrWYBW1hgJyV84b5Lu/bTwyJE9NoPb3LM+6oI9b3ZZwsop
	JmAHyX+40Gie2LhjGc9aJSrhRrz02v8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774455845; a=rsa-sha256;
	cv=none;
	b=c2idJ1A8tR+IjTlUOum79p9GWjv4zCx7ebdWMnok+KsMZx9wzu5CRzpMQdSPWmwVAk6ojW
	Fhhpb6OQcsoUYLl5S3MTi2HXV90jEpJhnlYOm/Bra7lJFWkaCiaFbqDvWkKNWXO3Uziz16
	23Q15F01bYd7flAJyMUUlHHnQ/Dk62E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BSBG0LH7;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 21B2960121;
	Wed, 25 Mar 2026 16:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D21C19423;
	Wed, 25 Mar 2026 16:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774455844;
	bh=6GGVqV2Zd7+GdOihEp+etPbPztUZ47vsPoYBsuWNUJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BSBG0LH7Uew3Sjq4jNxlJrWFyT3Tna+tc7X4kVxxF6w8nzX8eer3lHMZB4zswcXfP
	 xjHkzOmcSkmxm5eq/3iXOohApbujl5UruoOAbbfHvSjozo44xQoYWVhODuTf8D4ju/
	 nswtqxxY1kL35DBhTNfPo8+tdKnNJWFnrh75P90LL0UiKYaoZJsqSgFN8aWmgBP6Yd
	 Jo+unrnO+Cm3t2c9upMUBSuKZyea42E3Gj+JOALgQJRcR8Hg2sh+qphdGAvmbalo2h
	 LRQWxtM1B5CccqDCpGhuKpefdNbdPDiDGiXiEOVqRKqyR2IZ20vieNQOs5dGac3Dbc
	 dhKvxI1+xXZ4A==
Date: Wed, 25 Mar 2026 16:23:53 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Tony Luck <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, 
	Babu Moger <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-ID: <959b34ea-69a7-4fda-a494-0b9a1773ec1d@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
 <ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
 <d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
 <20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
X-Rspamd-Queue-Id: C153CA000E
X-Stat-Signature: e66mcr6jkkmha6iocs11ioxazwsy5rs5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774455845-573773
X-HE-Meta: U2FsdGVkX1/XDa6GzfB2fIzbovSBSIzmthjYmv+LsO7EpPkdx4cczSm4MeKFfZxX5eeAwzxAHvvJl4ylzdlVyt316MgICvgLaFHX6StLoFxoFrHyYwrRku7/szcW38WH21gzes/OP+Gy1MAOlViM40IzkVIFdsEcqrrb08f8CM+2ytNloV7/6nRv00aiVRxEdYsbAouo3W+yJQr7P2GOnApyu8+sm8ZQNZKrnwgZB73pL5MOADrEKa1zLscu3ptPe4ixHcBX1Aq+BkKkrapuI9JyIz1QlUyu/wMXg5uGtTyCPDEROWmVxzzu6uhXqL/Ec/7t54yWV881zbP4YnFEA/WSCX6q9QL0sVoFZnrq+w/O94bj8vHTiBi8oqdu+c5YTmDhl/+55V7dIC1lLHHVPmz4KY42p9moR2D3FfCcYkscLgkMr0yQ5PM6FLtBIQG2H75RnImRjiiMFlsSmYfGBiTZJuqtrdb5r7GzLRj4xV5p7HlWdX4IxVoAqSyyHU/9s1ZrjGfvNDh7+x7JgoBltMz8dVJLrgDU7c3tBaTZga6uz0FAp+pft3IqdNm3DNqqt5uMRs3nX2vltS1Ei9j51+KreBZsT95x86Q9Nlo9pMJS03QRqePljsH/x/w4g6k/Smrba/akkdBPFIl3+E0Y2my53DJH5BUEssM+AazX6pJ3SJDlTd8tHeGBqkLq7mGrjtERy/jtEVXAaqaHTbQWNf6U6y25ZohXWaZjAirvRlIRya5V0a9g/1VBnHpiMh8M4XRISZNGdHUmZu/tsnFMSydGL0di2MGoaqx1/+WdAbiLEC0ma7Vj+bkDkdS2QYaUzqutRpRXjR5tReKxJWYFVvbx9vpqvJZHKWacASnT1HQRGEVmF0J5FHMC+Lam2eB7+Rm6oiERoB0tK/C7TNMOV5vOK0D6MxA7AAOu2tI9rCYPo/1B8XJ0nFV/YsJ78+oXMkE3CbgiZzyveR9oFrm
 zc5iwgNt
 HVk/oB6Mc7VXNMAvZdy8rXxIRltePjdmHf82a+EYYjDGduChReIyNO4CodH1mZQGp4aHTIUSkVvrZrfU9OcGCxWGtrpX1Bgne1nO09WGVHxSnaSLGy3ViPru3lpCoLz42TUPQBKv9vCAJ3U4hlFY9NADL0yPRCsKdjCgZQ0Fxjuq34pUV4S5oXpKJsgn7ONBQjVUtUnJWIB0VQdQ5EO0zalFa3oEOgR6BUlUkhc0BIvnhMSSgvg2lsgdWuJCDDQAzota9BEurNFQG1rnqYneMd7ekndmCe+3/tYjR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 09:09:49AM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 14:58:14 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > On Wed, Mar 25, 2026 at 02:54:50PM +0000, Pedro Falcato wrote:
> > > On Thu, Mar 05, 2026 at 10:50:16AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > > > Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> > > > macro) always being inline, as we rely on the compiler converting this
> > > > function into meaningful.
> > > 		meaningful what?
> >
> > 'into the equivalent compile-time constant code' probably fine.
> >
> > Andrew - could you update that if there's time?
>
>
> np
>
>
> : Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> : macro) always being inline, as we rely on the compiler converting this
> : function into the equivalent compile-time constant code.
>
> what does "compile-time constant code" actually mean?  That constants
> within the code are evaluated at compile-time?

Yeah, so effectively the compiler rewrites:

x = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT);

To:

x = (1UL << VMA_READ_BIT) | (1UL << VMA_WRITE_BIT);

And then:

x = 3;

Various efforts at checking generated assembly has confirmed this.


Maybe 'into an inline constant value' is better?

Thanks, Lorenzo

