Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68D2DFED3C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD30D6B00AA; Fri, 24 Apr 2026 10:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAAB16B00AB; Fri, 24 Apr 2026 10:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8466B00AC; Fri, 24 Apr 2026 10:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD9A6B00AA
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:15:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F65D1C0121
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:15:38 +0000 (UTC)
X-FDA: 84693647556.24.78C92EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 751AC20015
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:15:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uQNXKqM+;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777040136; a=rsa-sha256;
	cv=none;
	b=U/0z6TsjWkLTv55lIzHwuOn7x4WSBpi180gOeDtKt1+nsQlVu1dnUKJd7GnnDxsGJTBe6R
	U0zaCdBA5K5AhnAG0FKXX47EqnczTyt+oukAJrg5JsIDXlZz1sVjnl+3GMwj6J5IhQRwiV
	OqC+Pt22hYYCp/LD8XAnSgtywH9DLa8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uQNXKqM+;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777040136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nyK95quYkZ2efvIo/lOVO2C8R8VhlGTOEAzo29ISL8g=;
	b=FSdSnymv4z+8qNv8jlQC4K7h9HH2h0C1njyPOi4LQ60sOmARfI3QQMuzxyGiQygx/jSp3C
	L5S3J3FvzxL/i5v7CT+/6zCgcIc6VGQnc1ICKO4FN8R97cRVsmepILKQ1MqNZ5BrIwVp+b
	ERAuGLijMIibWwFzuy+Puslthuziu48=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B97E0600AE;
	Fri, 24 Apr 2026 14:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450B1C19425;
	Fri, 24 Apr 2026 14:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777040135;
	bh=L08wbD9RP1yIjusIkp7uHpvtDFAssJesg0vXbY3SOlo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uQNXKqM+5mUhzXG3wrgwsljDXLTKkGCn8k++R/99g0dgBzwKo29qei3pipqEpVoSp
	 HuV9V9S/Im3ZA6Vaz92WxkLH2DorTEPO8R4P/gHUl8PtrDg1axezxhJHT7OiIMHGd9
	 KAwmmNczlPPrkQAfSbFnDc8IB/UfpxrsFV/tN4G0=
Date: Fri, 24 Apr 2026 07:15:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Lance Yang <lance.yang@linux.dev>, peterz@infradead.org,
 david@kernel.org, dave.hansen@intel.com, dave.hansen@linux.intel.com,
 ypodemsk@redhat.com, hughd@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com, roman.gushchin@linux.dev
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush
 sent them
Message-Id: <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
In-Reply-To: <aetw4aoABYj3keMh@plex>
References: <20260424062528.71951-1-lance.yang@linux.dev>
	<20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
	<aetw4aoABYj3keMh@plex>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 751AC20015
X-Rspamd-Server: rspam12
X-Stat-Signature: smizidhf37n4fx8cy3tmbwuiuhqhyts1
X-Rspam-User: 
X-HE-Tag: 1777040136-310213
X-HE-Meta: U2FsdGVkX18u6HCxugZ3pCzwJmEYbURlR056spVIvxi7QXh5d5G+csVlVg/Obbohw85cVie/GvTp7fwqz5iIWC/LH5Yhzx3/UCFXScDN3/K8TgdBvtWNDglfGBxHj9UzwzgsOmQTwPzb82oyfJlCd4vgTPQ2z9fLDbJL4JzY93+v+BmD444AxlDo73H5GcHVgx+QBY2hafKmU020J2hwjBTjq/xRO8u9fgpxN+VDFQOtyhTAFEYr0zvfEZizvoAlmStPcW/DGu8Q7r70Zx6NTL/owzSHTgKwmaD0YTXNvWZSWG/6c4skz/nc1iwlNM+rnOjKdd0P7AjsTLG700vPtOzkUZBciK7VNLdeCEUo6R/YEylO1vYEUaNq0K/yuhAARyb6lCqhvHn9FQJ6DGn76w2D1Zuok2W1XcK9/Y88GnUpDJugRzBIV+rMHGv+SvbdBHM9JoDGQyHDZGfVlKkQWwvh7FG4x5TSwpEn9drtXRPUQAKHD2Ed44dfuWo9tdByoH5flR1H9doUohFTPCey1pXy9O1YTRG9jWld8lN5EAqni+maA5dYgMGOusHxcOhguHPohGZIT/276DTEbDuTrFxiihwvLRP3yqyMmia8vyfkOgAk8G6HDpBw9a9jXupTFz8NhiuKLS2vLRqb/FEYs44WnRK/7/ufHdm3LpPJ5fgfE0NWlIB4t/v0Z4wX3FFlyDoUsvoJsK64Xe3CrBWwN2qr44D1HJiquTvNhN/lH/Gd+djTK6wT3Rvd2yUIaMQQlRrZWAOjPc0k//jOx5OGZ3swuS0LJcLNhbM6ug33uT4ewwTJX48mLPvYZ3wtAuYLnOf80pSgsTKOJuve86aEIY3hLchSLTrYerdgXK0trGIw2WXGcGEDIx+WGdHt73XO9OsR0chNQ8VnfP71VD51uEowQW8lIJGUGWL+M3jhVGjbH1Mex4Tp8fjRMLCxG5RpDvgNrwoCrzofySSb6CY
 Aq7uVLkE
 TfuyLAoL5JjkLLMAbxO0VVGf3gFw38ZTOdRWVsAIKaANnDUxP66hqJy/TvR3n8tRB79kcZ1EOupV8CQW0pPnwK5g1fXgrCP0qd/y24soOKjlo/sBZP0CV46k8fgENlpbTWhb6FBJFLQrusAqJv/8B8RgSt8M41EvmPBrUBWnt/d1LxYMr3Nz7PGeg/AH0ekUyoGTSsZ/2WYGW3D+M0ksd/1r6k0mCwxBlrVGCYsUJ++3K3J+Vq0vogfrHZWbYp5Nx8MvANHC3LFnUkzVCQHgIHmLQ77+ijmhqfd7fMyFdYI6pnoCETF7rct1oqjzOMjP63W4fWw1Lpsden81fQ3uGl6jcbwfwq7Yu7O33oth7vUmoQhNgFqkk7f7HSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 13:37:04 +0000 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> On 04-24 06:30, Andrew Morton wrote:
> > On Fri, 24 Apr 2026 14:25:26 +0800 Lance Yang <lance.yang@linux.dev> wrote:
> > 
> > > When page table operations require synchronization with software/lockless
> > > walkers, they call tlb_remove_table_sync_{one,rcu}() after flushing the
> > > TLB (tlb->freed_tables or tlb->unshared_tables).
> > > 
> > > On architectures where the TLB flush already sends IPIs to all target CPUs,
> > > the subsequent sync IPI broadcast is redundant. This is not only costly on
> > > large systems where it disrupts all CPUs even for single-process page table
> > > operations, but has also been reported to hurt RT workloads[1].
> > > 
> > > This series introduces tlb_table_flush_implies_ipi_broadcast() to check if
> > > the prior TLB flush already provided the necessary synchronization. When
> > > true, the sync calls can early-return.
> > > 
> > > A few cases rely on this synchronization:
> > > 
> > > 1) hugetlb PMD unshare[2]: The problem is not the freeing but the reuse
> > >    of the PMD table for other purposes in the last remaining user after
> > >    unsharing.
> > > 
> > > 2) khugepaged collapse[3]: Ensure no concurrent GUP-fast before collapsing
> > >    and (possibly) freeing the page table / re-depositing it.
> > 
> > Sashiko questions:
> > 	https://sashiko.dev/#/patchset/20260424062528.71951-1-lance.yang@linux.dev
> > 
> > (I never know if my Sashiko emails are welcome/useful.  Maybe Sashiko
> > said the same stuff about v9 and it's all wrong.  But better safe than
> > sorry!)
> 
> These emails are helpful; but, I do not believe you should have to 
> manually follow up with a link to every new patch series.
> 
> Perhaps  Sashiko could automatically send a summary email in response to 
> the cover letter, or provide a link once the reviews are complete. For 
> the kexec ML, we opted-in with Roman to receive automated emails from 
> sashiko.

Yep.  I'd be OK with an automatic reply-to-all.  Maybe some won't like
that.

An alternative I've discussed with Roman is an automated
reply-to-author with a cc to a dedicated list (we could use mm-commits
for now).

Preferences?

(I'd suggest automated-reply-to-all, see who complains, then figure out
why they can't figure out mail filtering ;))


