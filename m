Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B10C88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDAAA6B0095; Fri, 11 Sep 2026 10:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64886B0096; Fri, 11 Sep 2026 10:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D550A6B0098; Fri, 11 Sep 2026 10:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B08D56B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:14:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F93F160137
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:14:47 +0000 (UTC)
X-FDA: 85201677414.02.F0CD5BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5BD148000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:14:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RG3+G+x2;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789136085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vl7wtwlKjWj9kG+1Rk8/BQ+oiCTCw1b09aebu1WqEcQ=;
	b=azQepihyoPCJQcqLDNQ2M2vdgHCCDd6U64FLRHNHJ6mN3fGHoxHyXgEEjw636BNcHBjRrE
	jmc1LM7bZwcugtc+4UslJYPonVRC341Hnov8UgxLOgjFJ4QBdkGliaKmZpyCKDLoOLGGrO
	Edk806R2CU4rODXEG8Xcro8YYisBjGo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789136085;
	b=hkHkMOgsgSGbUVPiVOqtcyD+ZE65k/ZEx6AIGXft8waqqRHK6TQX33yvuQo+dfZIpNRnc3
	hLvD54w35C95na/FAagp3TsenQAV/I+M34FD4l0cFL2etPrjRB0BHQbXI1RIn4Q1EHToPX
	wc7H/Kz8uzZMztUx8Zg/LvyohdiwlvA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RG3+G+x2;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89F47419F6;
	Fri, 11 Sep 2026 14:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2B91F008A2;
	Fri, 11 Sep 2026 14:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789136084;
	bh=Vl7wtwlKjWj9kG+1Rk8/BQ+oiCTCw1b09aebu1WqEcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RG3+G+x2UV6fCbVtatMP+dcn5QzA2lx8x95K/GC88eWoQ+HywGLGvmgbTuT3oaiL4
	 H+989DvjJ+e8s6Uv1XIsCznIYTj/g02LxIjqW1lQOGH85wYg7Cunqujq3COmyamcPp
	 B0SWH3AqlpPqMXcX601xGAcB/Z+G5pNZIQ0BpoVGmXliYUkNdyli6vmGc2W+rSSnHJ
	 cjba6gQyGjeKqsxtIH6CWkV3D5RvpikYR+BI7dGPT7v3OEH1vU2Q7scVZCpcbVEGj8
	 XXS2ILR9st8du5Oh9ihnzojkxkJhJLPDiYDOIWPoIlkzSvvIRTrZqZgFPluFL1ymbP
	 6y/RsDdju71Jw==
Date: Fri, 11 Sep 2026 15:14:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH] kselftest: mm: fix potential failure for merged VMA in
 guard-regions
Message-ID: <aqQMKAjwpvf9dMfa@gremlin>
References: <20260911123534.1181501-1-yeoreum.yun@arm.com>
 <aqP29-H0iKl-2CVH@gremlin>
 <aqQDbfMOVasuejA3@e129823.arm.com>
 <aqQG5LgqXnrmY1_l@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqQG5LgqXnrmY1_l@gremlin>
X-Stat-Signature: 9japkpms5ut776od9tftfkizic1ikhnq
X-Rspam-User: 
X-Rspamd-Queue-Id: 5BD148000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1789136085-770885
X-HE-Meta: U2FsdGVkX18y/jPJJK/PHd3QFCJz+iqoD4IlE45Rymii/+th1cGEOAlqeu6yhPpn8vzWR1VpGgZuwlRnv19eoTY1ktkOvHyBNCZBMFxu09fWRdHp7xXodWvjkuGStQ5TwiRUWxZJJHv2oK3arVPcJzr2s48XFam05buCt4ccEd11TjhAUZT0jccRUlVePHXJTsqoqWSJnGgge8m7PhRf+AGZkcu8gxgiiWKpRBNF3MFTWDb9VqcciPILiZFjk4PX3GnGHtoNIOFFOhCxs7pZgEnx02KEIBr9JycHPjN2yOuUcd/jLL9FqXrSzBtgv8b7CwgxoekJ/SV+IsjbMY/t/qGNUN7S7GhB/HVC5MOEWtK7Uj9EItw3QMh5cGJZQ3GcaG+MCjcJWBVbQeHQ3L+T5Hm1mMsisNnf98iMAqDIHkiClsyyqLWCfjbEVh3pfY+UbEHoKleVaDr5vN1QhwW6lq4TELtZFj1nkNa+MD46SNOXi8ZHhuQx5PoJFIAzXtnJLEBl0TKtd3bcPgefXXdvU+fSQ8/4kEPJmqlut63ySvaZP3tgyejrXbUkerB6SHdi+q/uhiQbUuJrP5cgPCJjt+ZMbI8HfFwoF/5fN9jd5DSUxtwX9M/RX10S0ZmT+/+JbmpjvRMAUPbeu28ata/5W8RVrMOucu87Aw40+cOo6ycttiOuDEYg49QKkRSM1oCi3F1gDesIj/8D/lx6nzO9Bv3q2kGvnyYAYy+yh/uogesk7hnhMc5AX5tweuzzC394lZOtOpfWLEZDcTgLiyWN/WLEnRmwz8ynvHrS+ms6GjDks7atOXSrJPqMY6ZdRzwXu7XhPsIZkFQgayLx1nOFzH/xT2qHm518ynlb556o3m7up8lOSJMkSGVSVubD85sOfHKLK3peECYnkhXb1Hz+mTV2NSXayyq3x7/PTNntwoPuF3tCHBMe0bs58W1B1z6972b75/eehn8HFtIjSKv
 rTlgStWg
 nrdrhNjDMD6F2GSUaFWXOQ4V0Um6GZ9uYdIAgTpvC39426KLZ30n1sGn2Jw2kiHt+kr74RaVPUTQ4RLuUphXHj8RvBrpVZ7MhF2hAQKwv9LBhdNDViw8xFgwU0MWKnVPi5Cn20GRPifZQnV12xbT0mm+DBGwJc7JgNG4vgIQE9emBHqDRQffzLtoppcWIJKjwYDDvG6WDXOELhWqKLF+ySpy3V6jf+QQIlnn9UpA6slc9LzzyvRwqDJG+ahuDCaxgGGb7INEOT27Lve7dRyTlV+8G5MgcxDhiWgQ2gERZmm4OnPLWwCaF5LvhRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 02:51:09PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Fri, Sep 11, 2026 at 02:34:37PM +0100, Yeoreum Yun wrote:
> > On Fri, Sep 11, 2026 at 01:59:31PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Fri, Sep 11, 2026 at 01:35:34PM +0100, Yeoreum Yun wrote:
> > > > check_vmflag_guard() uses /proc/self/smaps to retrieve the VMA flags,
> > > > but this can fail if the mapping is merged with an adjacent VMA.
> > > >
> > > > To avoid this potential failure, first allocate a temporary region with
> > > > extra pages at both ends, unmap it, and then map the test region within
> > > > the temporary address range, leaving an unmapped page on each side to
> > > > prevent VMA merging.
> > > >
> > > > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > > > ---
> > > >  tools/testing/selftests/mm/guard-regions.c | 14 ++++++++++++--
> > > >  1 file changed, 12 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> > > > index 5c8ec3ca75d7..a28a57d34e97 100644
> > > > --- a/tools/testing/selftests/mm/guard-regions.c
> > > > +++ b/tools/testing/selftests/mm/guard-regions.c
> > > > @@ -2257,8 +2257,18 @@ TEST_F(guard_regions, smaps)
> > > >  	char *ptr, *ptr2;
> > > >  	int i;
> > > >
> > > > -	/* Map a region. */
> > > > -	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> > > > +	/* Try to Map a region. */
> > >
> > > Map -> map
> > >
> > > > +	ptr = mmap_(self, variant, NULL, 12 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> > >
> > > Should be PROT_NONE otherwise it'll merge with the below.
> >
> > It doesn't matter. since this memory is unmapped and then second map
> > at ptr + page_size.
> >
> > IOW, though the first one is merged, it unammped and then
> > the second is allocated at ptr + page_size, it wouldn't be merged:
> >
> >   after unmap:
> >    [existing VMA][ 12 pages ][existing VMA]
> >
> >   second:
> >    [exiting VMA] [hole (page)] [ 10 pages (for test)] [hole (page)] [existing VMA]
> >
> > Am I missing something?
>
> Yeah, unmapped (unfaulted) VMAs can be merged with mapped (faulted) VMAs.
>
> In general it's also better to be explicit by specifying distinct attributes
> anyway to spell out clearly that the VMAs are intended to perform that task.

Oops, I missed that you immediately unmapped the VMA too :)

In that case it's fine but I'd still prefer it PROT_NONE to clearly single it
out as a placeholder.

Also a comment above it like:

	/* Map then unmap placeholder to avoid adjacent merges */

>
> >
> > --
> > Sincerely,
> > Yeoreum Yun
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo

