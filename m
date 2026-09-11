Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD41FC88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F06CF6B0096; Fri, 11 Sep 2026 10:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6FB6B0098; Fri, 11 Sep 2026 10:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE8A6B0099; Fri, 11 Sep 2026 10:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7DF56B0096
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:18:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52BC9C027E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:18:13 +0000 (UTC)
X-FDA: 85201686066.30.A77B0A0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6013110000B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:18:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Bbhpiekw;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789136291;
	b=7kQ0RJyDltwLsq1I8ptpB3OI/FyQyOWQOzV/tvEkK0LiKGjG1kpcK+wKg8x9IWNlcrkhyn
	Uy3YZdYcKQd6w2nR3wXBDW0IG4+uOgmBRBSAbrxy7yAOLW3EcitNvDrO8cEoYknV9t17VT
	l+HRZtrhj1jh4XpNufE0kEwkycWM2KE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Bbhpiekw;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789136291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vREt7n9/z/hh4PnMDFuOngpAV7chC/QT0Zx7hnnFb2Y=;
	b=LUBruQ6arBxNhlMoO4OBB7jnz4A+3L0nkNGHFYJrV7+SCQyMXx9k+n1gjmx8GTXRoaJWqX
	L1PnY/u6SSdY0dTGtbaQp8HkT1+D/T3jx3vvYz4jLWa3u6g6C0b7of5GGfW3UubINaSPLC
	xtUzVLdPuP14l5SlhiukSNc3ogMlJI4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9AD9316A3;
	Fri, 11 Sep 2026 07:18:06 -0700 (PDT)
Received: from e129823.arm.com (unknown [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 535DE3F7B4;
	Fri, 11 Sep 2026 07:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789136290; bh=SMWTVWYkHCdUnE1Ea2H43xOdc3TkjyJelBC5ssmIAow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bbhpiekw4vPtMuSsZQAsZFKlWtlBiNZqWOGJYa2TIZ7tf2EDzfoA4yJdja9s9TwSC
	 aqPhmIMiLGxUG3I8yFttZOXdPfb5XYZmn5G0AD0U1IgwHhCMWc2scpQNxBeJ9pr5g/
	 t3+tyW6g4se59IaKlJahdDLa4IbzqgPavRxnjBxA=
Date: Fri, 11 Sep 2026 15:18:05 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, david@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com
Subject: Re: [PATCH] kselftest: mm: fix potential failure for merged VMA in
 guard-regions
Message-ID: <aqQNnTe3TGkyzjqA@e129823.arm.com>
References: <20260911123534.1181501-1-yeoreum.yun@arm.com>
 <aqP29-H0iKl-2CVH@gremlin>
 <aqQDbfMOVasuejA3@e129823.arm.com>
 <aqQG5LgqXnrmY1_l@gremlin>
 <aqQMKAjwpvf9dMfa@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqQMKAjwpvf9dMfa@gremlin>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6013110000B
X-Rspam-User: 
X-Stat-Signature: qmpbocdqxurmyxyopk97hbidwnmiarkc
X-HE-Tag: 1789136291-608801
X-HE-Meta: U2FsdGVkX18+BcXycwg32tZsJJmwnfLfdV4MmguXmSU9989ESlgGvAn+HWtpCKGnvIVdpZ9bFabNVNAKCCbQ24H9cxXIra9vcf4i1etmhnt1mPHRnXFpkjVDqZ9pjVOdtvOFXDyQItU7Cql53watGxni3UNKwXhUl17d7n7yfisRmLuVFbNSCHVQUaiJb196ddITtOJSbMZi2lDCFm48IUYhOTdHnv9Q5Tk0bvrwarzSNlUZmxSLYHs3j5KMNs/WgLdvKjdjo9kgi+kT4lHxXzFzZFIVNkzhbNpJAbVEtsPNlWK0AjiTESCxYVxnarP0JEMFCS2nfVmY2TwuS3q9Xe3W/vKepCe2Lm8Ylczht8w7oBQVDdNZqMdhRIH9I/NtTbLOScrk3W6s+a22/VLF4zAVkrFAKIOZsCp5gCJ3FCub5AWX2FYAwb1Ivr980J+VpyOtUazRNLZWpjjWoyp2pM1Hign4X1HuCvm3xxn84F+BjpWs2vwsTFp+UUV7ylQ6jhUq3ahW9fFwFWYI24Lq2KgVAqzjeqfmNLX+thiQZir1+zzxuww5tLD4wvM1gVTNAljtPvDuXHz1rQ9m0Ne4l85etYlkQm8+4fY87odyu4nqaRvOopsDCR6i1E5e9c7kmLmvhvGU8Z159HS1/goC1NrVndd5xGmAAq/RsMOTvcfpCABhSftZ63SNOCedW18QP4u9LJzWb7RC5Mm+adEEU/ZUS2lxzrESUiLgbdBpD0AkrFBhPVFrKd+J3CvootgYGvfz5BzwGfNqa1b+VUtNGAtmFCQbfdAsmQf+y4+LWNHpY+Yb/dL5I7hAwMufLKUOiEj+ndDPjxh7zpGdRmjhvJdi3WgFNJfnB1VkrN3rXpC2ger3bWb9WxmCW4ivZorqe0tGxxKS7MXNlZE0gS7Jel34BETeoUvR9QJzQ1CTLv0sNF5YkeQu5oBb8LIhNZJESzRxOhZyU9J/tQ/VGcQ
 cInRzrbh
 t1jOWIiTfd7OMuMLf4r2iwaNQEoAZnkuoN74NI4JdFsVjfQBYHGsmiLQtBkPX5EueRD/8H6tUuXCtjtRVrefC/Rzm9bRiGFA3srRlV/pczk4uvUrYwJhHKFATZSGtvcaeA1Nnwm/1lsVJ3Pu8IltuzkbyeH+/Gl5EU2+9o4YG7zdVzoiqk+DDsUA+o1N9Ct0y8vgrpJ/TQ5De8z9XuVGmHFrIYt4zHR6PDvO2aW9C6QE/nvtkYJ8RnfmGCz/ZpxKFO4Rv+NJV7mdXAuAcJk38yIsAdT8hCndk+00NdkLPTFBHr5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Fri, Sep 11, 2026 at 02:51:09PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Sep 11, 2026 at 02:34:37PM +0100, Yeoreum Yun wrote:
> > > On Fri, Sep 11, 2026 at 01:59:31PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > On Fri, Sep 11, 2026 at 01:35:34PM +0100, Yeoreum Yun wrote:
> > > > > check_vmflag_guard() uses /proc/self/smaps to retrieve the VMA flags,
> > > > > but this can fail if the mapping is merged with an adjacent VMA.
> > > > >
> > > > > To avoid this potential failure, first allocate a temporary region with
> > > > > extra pages at both ends, unmap it, and then map the test region within
> > > > > the temporary address range, leaving an unmapped page on each side to
> > > > > prevent VMA merging.
> > > > >
> > > > > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > > > > ---
> > > > >  tools/testing/selftests/mm/guard-regions.c | 14 ++++++++++++--
> > > > >  1 file changed, 12 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> > > > > index 5c8ec3ca75d7..a28a57d34e97 100644
> > > > > --- a/tools/testing/selftests/mm/guard-regions.c
> > > > > +++ b/tools/testing/selftests/mm/guard-regions.c
> > > > > @@ -2257,8 +2257,18 @@ TEST_F(guard_regions, smaps)
> > > > >  	char *ptr, *ptr2;
> > > > >  	int i;
> > > > >
> > > > > -	/* Map a region. */
> > > > > -	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> > > > > +	/* Try to Map a region. */
> > > >
> > > > Map -> map
> > > >
> > > > > +	ptr = mmap_(self, variant, NULL, 12 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> > > >
> > > > Should be PROT_NONE otherwise it'll merge with the below.
> > >
> > > It doesn't matter. since this memory is unmapped and then second map
> > > at ptr + page_size.
> > >
> > > IOW, though the first one is merged, it unammped and then
> > > the second is allocated at ptr + page_size, it wouldn't be merged:
> > >
> > >   after unmap:
> > >    [existing VMA][ 12 pages ][existing VMA]
> > >
> > >   second:
> > >    [exiting VMA] [hole (page)] [ 10 pages (for test)] [hole (page)] [existing VMA]
> > >
> > > Am I missing something?
> >
> > Yeah, unmapped (unfaulted) VMAs can be merged with mapped (faulted) VMAs.
> >
> > In general it's also better to be explicit by specifying distinct attributes
> > anyway to spell out clearly that the VMAs are intended to perform that task.
> 
> Oops, I missed that you immediately unmapped the VMA too :)
> 
> In that case it's fine but I'd still prefer it PROT_NONE to clearly single it
> out as a placeholder.
> 
> Also a comment above it like:
> 
> 	/* Map then unmap placeholder to avoid adjacent merges */

Might the ASSERT() made you miss the unmap :).

I'll post soon again.

Thanks!

-- 
Sincerely,
Yeoreum Yun

