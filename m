Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE03C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 23:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289046B008C; Tue, 18 Aug 2026 19:46:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212486B0092; Tue, 18 Aug 2026 19:46:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128A16B0093; Tue, 18 Aug 2026 19:46:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA7896B008C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:46:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56233120297
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:46:14 +0000 (UTC)
X-FDA: 85116026268.17.6DD1265
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id E95D1100005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:46:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IOEZHV9d;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787096772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEupeHIpt7OfU2n3KVFf/NixP6ZlUu34HUVlp84fKL8=;
	b=e24diVZ1cX3EXig60Sn0Oesm2MX5OPWI2k1cvHB7x7aB/yipRUfI/C3SNcxuTmYdvAK2Vd
	BvN0psDgJwEwnQ1JG/dQZg31ltBHLojZbr0wJ3gphJUMa+ncpgMJhN/VFbbvxLJ63f/F3W
	eKn6P0hzNWJGQ0amueqW+SBEadryF0U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787096772;
	b=tDdW/sR0z3xjn84f8zeYIM+IYmItyVh9uJWZowTxv0OmN0oyZdi53gvCF60VBbjbL8fUxf
	wwcIxsXRelbP/YUxZx+pASYyG0Azk4NVG1UwYxdAhZ39n159WkKcgzh2u+mvusghJtczBL
	rTJ3wv3ak3NhVUQ7K03gZ7/5AGBpIAY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IOEZHV9d;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aEupeHIpt7OfU2n3KVFf/NixP6ZlUu34HUVlp84fKL8=; b=IOEZHV9dHZvSA7iWBZfSP2TaEZ
	/CAujOUJr9/N9i+hkSstmcRlvCofYvaKWeYpYRmcnfFVapO05dnpDrYg/YdPbPRfZDgPGqepC8snE
	wJjA+biMXikKvdno5NdhmPC0Q7WATxmbmksOLp8/5b/Cz8H2a1sOEY54OdToZyh5hD5q3s4ZYBzsT
	LCRHNfXXM+ztGo31EDztA12S4L7nCxj9/AOlmYwohWQexoqG/ZysAaasf6AIj1q12K5RgwkLa51+l
	X2Q0D/qFuyldYzGr0+eOC4qipuuKS33P3ERjE4m9DjJOdFpYnBta1TrBwvtoLCOtYT5lxlSP09oEp
	fOmuZ/rQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwTVR-0000000Cmxv-0rwC;
	Tue, 18 Aug 2026 23:46:09 +0000
Date: Wed, 19 Aug 2026 00:46:09 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>, david@kernel.org, mhocko@suse.com,
	leon.hwang@linux.dev, linux-mm@kvack.org, muchun.song@linux.dev,
	osalvador@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: add cond_resched() to __unmap_hugepage_range()
Message-ID: <aoTuwV76Sd0ahBEC@casper.infradead.org>
References: <20260818115526.654d7311366b66cd031c67e4@linux-foundation.org>
 <20260818221858.86452-1-lance.yang@linux.dev>
 <20260818162430.0a51522ac9bd671cce62650f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818162430.0a51522ac9bd671cce62650f@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: 1ijofrd6gg5n1n96jrj8h1t39egfoqcz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E95D1100005
X-HE-Tag: 1787096771-921225
X-HE-Meta: U2FsdGVkX1/THqpnbayW4UYVx7TJDyqlgU1hudYrFqWxsJZshfayWGgxoRAXRXKmaQpcNwyJY02lF1SsarVCXPsx4gXhI68fHhNuHZ8ui8ci09OLYOlmO0UflI+B9pYCCeNjiDrEifKVgdoIyzCvoAPS37DnHyJeaFz2yUMU1zaWjTrKykeU72GXA0ivAiPrl+pRTJ8RuQdj9HSYSgp7Vjcz5/A/49569MzOyVaZXpz+y/JGvCxfSx4QDfLLSfOp2VqluYnDixTz5cjIIFE+UXJB/pPwQXRH8y4rjl1qA6YnfSrYA/OpRsMcOQCPg/vtqAtF3UdqJRE3uMW4doAz9IfUNFn4GEJPcKYF+tF5H9UbajsxEaEWy2qKyxxekPznL9DTzMkE6y5qhihq5jSUgqEeei+DgO/gz821Rdt+cZHuUbBTjtlYhUgRaH59+JwaQ3fYdzw/p49iz70P853KbqlSLWY7QpMR36IskCjh22VCobOsERSrFNDEczZokozoHZmQ41vappHXTaT6iUYI0l20F9ats7eFwAFTZP7RT7URo+7AynIP0DIPR95a94N4UAZqTHvp0nGDmfSi1Ysxcz14432FSn3hcYWwYhLBuzy6rgx2dOQhSkDsaGjH1jfETS+Tm/AIBrycqvqNsOii8GGZj1DA5PJNXNcYqDMpooA0mNd7qdNd7i7S60wR+QkxolkSDFWjqv0Et39V/t85xFSsYfFj6O7eSi/lYshf29i7J+0b2sLUQY9Km8ge7N2zoQHzETsQk1GOwdo0+l1HVuqH5YamKc9u0299SS+W8SBPY4F9Dx41A/W9Qee/9lFmYr11QamUVBiZSGwow/qxQFAFyG3axza+lNnB2B5wd28z6uH/5An+rK6OycNFBCtY/mX9vNrZVW2Qz2v8a0lNedHXokxyy2QVXw5RTH+JwRaaSCV9xudNKVr0NYDKUrHyDWQNGtWL6XgFx9PbSeU
 T1a3hx+Q
 yzjWUQ/O8eWs8Eb7tbCYcBKtxOkzSvVshOiJWV14qq8fuMej5LDTQNQZei+3swHAqG6IsYKJNU5DKs+kYAsSUZLI9MBFwmiQ+v+g3t7jL5W5JP8yHErr0imw+ZSjZVzmqf5gz336WzEpkoDyZDnqH/2Af6K1g38ZBCoQvh8uU2uxrgXPXHqlroY9hzAaEk4v4MWNPvqZTgnvUymlfsPBadkRnNu3qhrDdbvnPqF9H8a0GiR/RcS46dvc9TiQ06K6YtrqlyuyX5qnrLpcw2EmEaTGEqBUK5UgkiSac
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 04:24:30PM -0700, Andrew Morton wrote:
> On Wed, 19 Aug 2026 06:18:58 +0800 Lance Yang <lance.yang@linux.dev> wrote:
> 
> > >> > 
> > >> > That's pretty bad behavior and we might want to fix it in earlier
> > >> > kernels.  Is PREEMPT_NONE effectively dead in 6.18.x and its
> > >> > existing users?
> > >> > 
> > >> > If yes, we do want to fix older kernels then we should merge this.
> > >> > 
> > >> 
> > >> Okay, but that would be stable-only fixes?
> > >
> > >Not understanding.
> > >
> > >Maybe you refer to adding a patch to -stable but not to -linus?  That's
> > >against the -stable rules
> > >(Documentation/process/stable-kernel-rules.rst).
> > 
> > Since cond_resched() is a scheduling no-op under LAZY/FULL anyway (only
> > the __might_resched() debug check remains), why not take this upstream
> > with Cc: stable?
> 
> I think so - as long as PREEPMT_NONE exists we should support it as
> well as we can.  If the day comes that PREEMPT_NONE is removed, then we
> get to remove lots of cond_resched()s.  mm/ has 200 of the things.
> 
> > Mainline scheduling stays unchanged, and stable can pick it up for old
> > PREEMPT_NONE kernels. wdyt?
> 
> Addressing this issue in older kernels is another reason.

That is not the direction that the scheduler developers wish us to take.

