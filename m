Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A865ECD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F5C76B008A; Wed,  3 Jun 2026 07:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CCEF6B008C; Wed,  3 Jun 2026 07:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE3E6B0092; Wed,  3 Jun 2026 07:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE2926B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:51:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD5DA1C144C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:51:28 +0000 (UTC)
X-FDA: 84838436256.06.8F84B2F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 83E882000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:51:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="QbdYIxe/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z08nhYPV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oFyz+dhj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8+ubzr4L;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780487486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIeJZpdX8FCDjWAXiU77ogVQ0B8VkYFjD6D0OQC7A18=;
	b=nfa6JIZxT7sl80cSUx3j24cc8xlxAjaVUJWSfQFPSVpnWepy+3BK8FKoLKQVKrg1RxcR+l
	9qLG1Bskdg+huP1i59wBx/GJIJbSeYpMxvBcauVTvVP9fgn0F4RuW2HAhnEgOFounCiaPg
	9aVkp/BVUQNz6meUjmvVw4oK2EjWb8k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="QbdYIxe/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z08nhYPV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oFyz+dhj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8+ubzr4L;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780487486;
	b=tSbyCjmm66D0+GbLbbrKy3ua5dauBUOhEORhbX/euVmanaqoGoWhv39RcaiVE2DUmrXyst
	xmHh137N1CUuhF2dF1vPabDmq6/fPtwFqD+GB5kHfejRuuExCSmIFyMN+HiIEBF4NW/dyg
	leMNsHAY1HYraW767ShdZDf7PiMHSyY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EC7C56A967;
	Wed,  3 Jun 2026 11:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780487485; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uIeJZpdX8FCDjWAXiU77ogVQ0B8VkYFjD6D0OQC7A18=;
	b=QbdYIxe/Gs/9/BoTeN7ibvY7dS8gkSD+ySmZXR3ZJiaWbT4eVFOcZf/Jj9iwSY0dtbs5fG
	Q9m6Ep6bYwT1tl9MDgjfLwj46KNaDwmJX95T4RaOS4tZmxmTInBiiSG7+w7y25DWFf0Ah2
	K8G40+l3/dVpOh8xBDjwoyCWP1Xusp8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780487485;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uIeJZpdX8FCDjWAXiU77ogVQ0B8VkYFjD6D0OQC7A18=;
	b=z08nhYPV1E3pSjmY8dnj/KUsuV7AN17ldgtTRzfkW/DiBQD8dzONmIhC46Q7J8idHUlHkt
	JUUY+3VLSPA4/mCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780487484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uIeJZpdX8FCDjWAXiU77ogVQ0B8VkYFjD6D0OQC7A18=;
	b=oFyz+dhjaeqWT7Truzwz4h9no5m6xSisEeu7H4N6wTmSn4R3Y/OsJi0AQ1HpeF/tAKk5Ye
	TmdCqKwT/sbDV/a5iQUF21TUBq3QdDVCh8ZKiWVwNaBniEuMghV7dLEUNde6yIFVttdnqB
	bIaatVvaryXEIZxJ3tKzs6NR9L6I9U8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780487484;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uIeJZpdX8FCDjWAXiU77ogVQ0B8VkYFjD6D0OQC7A18=;
	b=8+ubzr4LKhjqgIw6B8HAYIBMlI/o1uUjb6pNV7y8iq23Vl/Go3QS/QWW5T0LjX8dhS5mS2
	+hI0sxVvmnd7LeDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D22DC779A7;
	Wed,  3 Jun 2026 11:51:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id doglMDoVIGo+YwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 03 Jun 2026 11:51:22 +0000
Date: Wed, 3 Jun 2026 12:51:21 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Usama Arif <usama.arif@linux.dev>
Cc: Jan Kara <jack@suse.cz>, willy@infradead.org, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ryan.roberts@arm.com, linux-mm@kvack.org, 
	r@hev.cc, Andrew Donnellan <andrew+kernel@donnellan.id.au>, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org, 
	kevin.brodsky@arm.com, lance.yang@linux.dev, "Liam R. Howlett" <liam@infradead.org>, 
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com, 
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@pedro-suse.lan, ziy@nvidia.com, 
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v6 2/2] mm: use mapping_max_folio_order() for
 force_thp_readahead order
Message-ID: <aiAUoWiXNpUY_iIg@pedro-suse.lan>
References: <20260528165635.2068012-1-usama.arif@linux.dev>
 <20260528165635.2068012-3-usama.arif@linux.dev>
 <ahlh2vdHEGo6ZSot@pedro-suse.lan>
 <cc9a1cf7-7b96-439a-b0be-ecdcf27b5da5@linux.dev>
 <ahmSolHvUChl-3vM@pedro-suse.lan>
 <185f1caf-b33d-4467-beb5-51bd8520ac78@linux.dev>
 <u52xvwk2fjjk2izdb4wvuqq2zhc5neb4q6usimcxejluuyngxw@d64sc6rvojyp>
 <ah8Qcxuugn5tTilK@pedro-suse>
 <68ca2764-ca7c-482e-8e78-8c112ce01f99@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68ca2764-ca7c-482e-8e78-8c112ce01f99@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 83E882000E
X-Stat-Signature: gasqszmugwqu89rric8a6dfagzdzpiyg
X-Rspam-User: 
X-HE-Tag: 1780487486-609017
X-HE-Meta: U2FsdGVkX1/XcAMlvG9M+74CEEL2ogIZzXKG29cBAIoA+NhRfTpNOUBS3vjvX+IgXXFNTQ/iCy5qbYl6HFfg9mLhnSyNW1yAolojMTIqFGxK8YcRYxtfTVJA0mven5kC32Cbc+vvduCOj5GzLDkbvrwlLea46jqtrC9V1bacEaFO+o6bDXqdPMXVxaj8jaqZKLKbqSeCVwj7b0av+pKgP/CdI9YahvYKbrJOHvsyUJGYG2N7ut14cHtpMMRfPGmr5BQyp3iXCEhEThaG5cxuc/Dw0wQFWZvA2yCAYMA9tCplt/dHekNCLs/2Evn4hsrzq24psB5anJFFGlxTL1Icc/njZWGRyqRHI+3sMTsYhysMVCterzAyVlhlPa8k3raRtGgVi1JXaWfs6jN1+R2pH7Q2SeLto0k3h8kD8/mJiO/pZ+lzQyC3TQN5zUa74pSvsMhICbgb8Wx8vApX6klwQ//R446W5oh2Zc8SRq4jExxaFAWV1G4b8whDxAAE8u7VSwF1jb33jghTb8BZIWKRNf84JieOnOHWMiwniM1UEf8HqAUoAjI7Pzqv3FhQ2UT/twNIt6R/4yvmw/lPjv4he/SKTNquXt5eJaDkedRPuWr+AdO5DoGkXT0nhftuwi6/s4tz02pjHkkYzYKxs/IbaSlcTvis5SJLOlTSM7qcxEj6YmCO/aXIt3rq4Qjp221ZdFMaOFlmeH2edPjxcGyc5+v49GE5pBG/UI6KYaqBwcbO3AnOPpKsTE7d7W12DdJQIVFezHFdLYXBqQmwqn2PNcfO//QunrR0LymXQASOOga9TGOia0LTFqAqyFApW3LxPpi8OYMA1XZhLaXZK64kiaZanIlQ3+T0xBcS0JAop8NKXXcKOEbrYlVAhsvEVmoEIKcuBZmnZMteMOu792Sm2+/0kEGylMjx/ZKKDt9Ny7th0QSr/9CRa6PR+CaSAn8Wui9O6YK5XdJt5fGdBw8
 d86iFLB1
 BaQB1Y//jKNmv4C9H1hsEvguZPoniLo5Gl0CcMC1mdgxYUGfwYfO+KzLMUxxs9FnsNI5txklgy+ocJ9q4cmYJBMnGVsSrqeKMTZrwuDiRQ3faFJIlvPOg4SFugVVbK76XGso9Oq+M/aL5oJG/oeUDRVKFkaRv2hnvNUnRbIe37XZoJ+FFDRysOuQhRHPU7/kizeUqbQhDOxyZmLkpiuPiPmoRtLhYrQGzSPUL0oF+FySwli1GQBecSOIZbkvy3pdxweVYR2XqiuVW2icXCYXal5EhZoToESRdOudwNDEuFajD2ZUAfR8bNt+6V6EnSi8J+aWb86h52mAD2DHZydRhSeD0UZo9Ph4MWVUsEWKm6/rR8vg5gf704ftXHkX8oMyCbV44zf4ZvfHRyBi1HCBEnR3I69tC/0S/ih0eXU+NKrh1rkM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 11:10:45AM +0100, Usama Arif wrote:
> 
> 
> On 02/06/2026 18:35, Pedro Falcato wrote:
> > On Sat, May 30, 2026 at 05:16:29PM +0200, Jan Kara wrote:
> >> On Fri 29-05-26 15:11:54, Usama Arif wrote:
> >>> On 29/05/2026 14:40, Pedro Falcato wrote:
> >>>> On Fri, May 29, 2026 at 01:19:03PM +0100, Usama Arif wrote:
> >>>>>
> >>>>> which means mapping_max_folio_order(mapping) <= MAX_PAGECACHE_ORDER <= HPAGE_PMD_ORDER is always
> >>>>> true, and you dont need the min3(..) in your diff.
> >>>>>
> >>>>> Now the question is if then why not just do:
> >>>>>
> >>>>> 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
> >>>>> 		if (mapping_large_folio_support(mapping)) {
> >>>>> 			force_thp_readahead = true;
> >>>>> 			thp_order = min_t(unsigned int,
> >>>>> 					  mapping_max_folio_order(mapping),
> >>>>> 					  get_order(SZ_2M));
> >>>>> 		}
> >>>>> 	}
> >>>>>
> >>>>>
> >>>>> This is because this will regress the 16K ARM case where we already got 32M
> >>>>> folios. Someone might upgrade the kernel and start getting 2M folios now.
> >>>>
> >>>> So maybe limit to 32MB? It's still arbitrary but at least you get simpler
> >>>> logic. If the architecture does not support 32MiB folios, it will clamp
> >>>> the maximum folio order to HPAGE_PMD_ORDER, and you get the same result.
> >>>>
> >>>> Does this sound correct?
> >>>>
> >>>
> >>> Yes, so if we replace it with SZ_32M, it sounds correct. I just think
> >>> the 32M size is too large. But as you pointed out, even 2M can be too large...
> >>
> >> So AFAIU the practical discussion is about two options:
> >>
> >> 1) limiting at 2MB with a slighly more complicated logic to keep mapping at
> >> PMD order for 16k pagesize on ARM but use 2MB pages for 64k pagesize on ARM
> >>
> >> or
> >>
> >> 2) limit at 32MB with simple logic which results in larger (32MB) folios
> >> with 16k and 64k pagesize on ARM and thus larger memory overhead.
> >>
> >> I'd like to maybe offer option 3): limit at 2MB with simple logic. This
> >> will reduce folio size on 16k pagesize ARM compared to 1) but do we really
> >> care? I.e., is there big enough practical performance impact with conpte
> >> and other tricks ARM is playing?
> >>
> > 
> > arm64 16K contpte tops out at 256KB TLB entries. It's quite a lot smaller than
> > a PMD entry. Also, something that was discussed at LSFMM was its effectiveness.
> > Apparently, most of the gains seem to sit on actually having a larger page size
> > (perhaps Dev/Ryan can comment; sadly the slides were not posted anywhere on
> > the ML, so I don't have numbers).
> > 
> > To me, the question is quite clear: do we trust users that say "please give me
> > hugepages" enough to unconditionally give them hugepages? I would assume the
> > answer lies somewhere between "yes" and "no", but 32MB I would say is not
> > particularly excessive. 512MB is... much worse.
> > 
> 
> I think the other question also is, if the userspace asks for hugepages, is it asking
> for the biggest possible one? I think the answer is yes on 4K base page size when
> largest is 2M, but maybe not the case for 16K and 64K. 

Yep, fully agree, the interface itself is limited. Though perhaps userspace
itself would not know...

> 
> /sys/kernel/mm/transparent_hugepage/hugepages-* is supposed to be used
> for anon only, but maybe in the future we could use that to determine the size
> of THP to give to the user for file over here? For e.g. over here we could have
> used it to determine what the biggest size is that has madvise (or always) set
> and used it over here. Its probably a much bigger discussion.

Hmm, I'm not a huge fan of those toggles (that not many people know how to
toggle), maybe using those would be a mistake. Do note that shmem already has
its own set of confusing toggles, which work similarly to these anon ones.

But, yes, it's a much bigger discussion :)

-- 
Pedro

