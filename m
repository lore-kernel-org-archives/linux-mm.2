Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02216C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 05:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57106B0093; Fri, 31 Jul 2026 01:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08656B0098; Fri, 31 Jul 2026 01:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7CE6B0099; Fri, 31 Jul 2026 01:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 881076B0093
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 01:21:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15808160339
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:21:21 +0000 (UTC)
X-FDA: 85047923562.16.3356138
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5F59840005
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:21:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FTRgX+Q/";
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785475279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJjBnEkh+nKHKY+8/SylN01ajLlOLYOCTOua+gFNFzU=;
	b=TiLjZw4kZ0fZRO6RyFjMrwNlXWsGL2ESMIOua7EfULIbxdLW+m4I61vaefti4NUMtasznt
	ladbfP2jaSjj/T3Ry09SymaTgCtj4R+SRp+7I3n1mAe/MfBiL61hMLa4hF9zpDI9WXaTe/
	ut9qV5j03Ls37MMkszjBzzCeF8auC6Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785475279;
	b=70Sa6PgwW/4h4FLN2JfzTBQA/CJnzWJxoBAZNFuAMvN/5GcTgQbXd0y+lcNeKvcI/zPzhg
	5qFgaIDCJWycCClsdeJL122CqQXOA8IDnGtg17TgjzL+GTVbBwOSjgICa8uBpWJM1kdfKn
	lD7wmzj2Ig+ALfgsv2NYver56yf70ww=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FTRgX+Q/";
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27F7F41E5B;
	Fri, 31 Jul 2026 05:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3B21F00A3A;
	Fri, 31 Jul 2026 05:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785475278;
	bh=YJjBnEkh+nKHKY+8/SylN01ajLlOLYOCTOua+gFNFzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FTRgX+Q/6LPx/bvDmDU2kJ8GmAsSNZui+PwVv4w61rL39dDN+2G4enh2VmRozbYn7
	 GsJbcHWY2ijfeq1hNqCZi/+5CZNATEMUGN+NGRIQQnZn98SGbEuaON+JGNeIPrSQn5
	 86T3bIan+pShYe5kWz5wOKhgF1CL11s0XSD0NDhY4U1chBowSHfKcbIRmGV028Blt9
	 D4EmmcMcsX2VpqRWA55TOBkh21SUAIw0ENDA/MKBMTJkU5ecuzoQEtRHTQyWcp3Cv0
	 yvm+vszfZbuMimHyJy2OiLJL2e04N4YrpSkkGy/laeVYd9BQVybLMKHZC/IsISTNXD
	 r4+/mJDA/Wp9A==
Date: Fri, 31 Jul 2026 08:21:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>, rientjes@google.com,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev,
	"Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Patrick Bellasi <derkling@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Nikita Kalyazin <nikita.kalyazin@linux.dev>
Subject: Re: [PATCH v3 01/26] set_memory: add folio_{zap,restore}_direct_map
 helpers
Message-ID: <amwwwe4eYeXtniFu@kernel.org>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-1-6f5729aa9832@google.com>
 <amu1KN8uJt4aaZAM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amu1KN8uJt4aaZAM@google.com>
X-Rspamd-Queue-Id: 5F59840005
X-Stat-Signature: 9dy4kn87nryh4yxofsqxmps5gsd7p7xi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785475279-512420
X-HE-Meta: U2FsdGVkX19yRPl+RQ9XjnBiQZ1FIWX4XWaheTchR6waD02r7DV+pByKgvpYc18A+wa+gvQmm13AeansHPzt4W9zR+e0fd/03apq95H4vtN8TRbQsZLpySrr7mVWr2YfLOIY5KDaJC3XH/u7cwg5it1bBCRtuy4o3WWtYIeDcUnB6iBKxWa6Hr625MDwx17e14DdwBEkQSkhasG1lCbx8znLXJXCXhGy2OTWJ2RS4xuACNF6YjKRa1gRobehe3VMRQGrdwf7swJdVa5YXh07Wdqb2osBtvWL8RpqeucBUmhPOZ8bPTSKTm0VaFFCNXJDrpU309fWMbQzsODrqe21mE6mORUJg/RWcS2Qa3JS6wrhsHMm6RZrLL/2GEzc0mJsCL5qm748EYhLP49BpKYjnpr2dgzEdkYstKQFMM9OVTC/JDsB7z3wtDjUPkItWrMqMORMKqwHVL0lMcri4+tzj4w+ai1l9qrmVrXxAwqMrhy/UzEsaM0Jfag7KdIvk1RkktR1Nag5LohwWDliJEq+u8SNLFhG8QHX5h75uoGAkDwITp9Ed3kUgQUm7ohaSh5riR3tS66XnBJhK25JNqbTtX+1C7Ry1TbJ39P1x8f0TmHb3K3OYaLWfsCPCpzwK4kJ6c54DybkVYMvg08339JhAjjM4aafmgy/Wr6efHTzDw4rYFH2zbymMkWV3LY6uHmXPOzoMxDbyadUvoMBZLrr9J8S1JdTke+7V/AxzzmzYyrk4IlMC3UzvQne7D0dbT14l8cJux1jGBshvGrNKvsxCA5iqCzIkvJwPxggOJlesoPuz7rceFshPvXb2NMyXrSx8aM9nzvGc22UR9ijIiMbcaqfkobwm22VLAa94s2dlCvzjaL67yKNlmI6kkBibJiNxcdpH9BDHRcPoekQf2iqj17AExZYLviGsOu9mQDcyrtQ1RcK7NMCQlyNkB6YuIeQqVvmoK8xlHEgc0XHVcW
 FAmeITfW
 e+qS4+2si4BdYkqoKlpaHibNHCSvF3a3McpE6RHH1GTznbaFrmHEUtnlrMGG6dMSRILSy8BgE0wukt0rkkC4gsxxaUZNY8tb/FIDBbZx0FUFtY5UMcyn25wAnJO8IupotRKJe46aJ7Cnc4FORukFZkoQ4mWeAaS/OdgB1YE0+x7KkpAoZufamhQsaGFUF+G3UTLHpRkc56G0BstZNqM//BgyqXpAKZ73sfsHHv6X0UlLZGy6DabhO9oA92t2HLUmHry+/jXs2i9ocbzmyEsdznldRyxQlR8ez72wyhzZIaXWAFAHjBpC2+98jmUM7TIl5j3lcoSwHtrmL+UCVr46vaVX0iM7zoxSThUG2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 08:34:57PM +0000, Yosry Ahmed wrote:
> On Sun, Jul 26, 2026 at 10:22:34PM +0000, Brendan Jackman wrote:
> > From: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> > 
> > Let's provide folio_{zap,restore}_direct_map helpers as preparation for
> > supporting removal of the direct map for guest_memfd folios.
> > In folio_zap_direct_map(), flush TLB to make sure the data is not
> > accessible.  On some architectures, there may be a double TLB flush
> > issued because set_direct_map_valid_noflush already performs a flush
> > internally.
> > 
> > The new helpers need to be accessible to KVM on architectures that
> > support guest_memfd (x86 and arm64).
> > 
> > Direct map removal gives guest_memfd the same protection that
> > memfd_secret does, such as hardening against Spectre-like attacks
> > through in-kernel gadgets.
> > 
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> > [Added comment, dropped modified set_direct_map API, added highmem check]
> > Signed-off-by: Brendan Jackman <jackmanb@google.com>
> > ---
> >  include/linux/set_memory.h | 13 +++++++++++++
> >  mm/memory.c                | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 59 insertions(+)
> > 
> > diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> > index 3030d9245f5ac..1bf2a15bca118 100644
> > --- a/include/linux/set_memory.h
> > +++ b/include/linux/set_memory.h
> > @@ -40,6 +40,15 @@ static inline int set_direct_map_valid_noflush(struct page *page,
> >  	return 0;
> >  }
> >  
> > +static inline int folio_zap_direct_map(struct folio *folio)
> > +{
> > +	return 0;
> 
> Should this return an error (e.g. -EOPNOTSUPP)? Seems like it would
> silently succeed if the arch doesn't actually support removing from the
> direct map.

That's the pattern we have now for all set_memory APIs.

-- 
Sincerely yours,
Mike.

