Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E5B9C5AC67
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 00:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79A0B6B0088; Tue, 11 Aug 2026 20:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A8A6B008A; Tue, 11 Aug 2026 20:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662D86B0092; Tue, 11 Aug 2026 20:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4FD6B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:27:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24F4DC02A7
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 00:27:17 +0000 (UTC)
X-FDA: 85090728114.02.00E558C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4B7A8140004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 00:27:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ieGROTSJ;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786494435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qG+lKPEemN6eouLTMYgrSIpSvsYzzW8mFU7XppiEwkQ=;
	b=mI0T2x7/vZyUt9EkEF/dXxauujMu3vD5MZCGQDujh9kL+ExjYg3R6SajAgmydCleOCsGLK
	bwbMumVwrhftGtG4W0x9TJ9yezDeG89S81ddQ+DfwjuE6HucQ2z6McLeLFI62iWhxigmKX
	rIiCLAn8ZT95FKdhIhGbZpuhA52jFnI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786494435;
	b=oii79gE5LmRxwNtR/xhnqrY0sAk86RTJEpoqZlNuHIEq4Q9zrGpQJYtlox3KdVFO367U/b
	T/YVvOHtmDOsBkVN8Ourz2UwUL6pJi7RaoxUor/Pv0rbwPgJaaiK6IetGYeshpDyAUMP73
	6iVtQbbFJOHPyWg0XImid49v8fGs+BQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ieGROTSJ;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B73641683;
	Wed, 12 Aug 2026 00:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8DD1F00A3A;
	Wed, 12 Aug 2026 00:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786494434;
	bh=qG+lKPEemN6eouLTMYgrSIpSvsYzzW8mFU7XppiEwkQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ieGROTSJtjt4mm9KowXgzx5n2unlLwhO2+fizeq1K6SBy/bqmTDHoz9nxrpib/qKU
	 pvVcYP2DO7dLgfB2avVdw+j5Qi/AkfwLI8zzocOzc8spc+8gDdrhyJ9+ETIpP4PeY7
	 mCYWa558gMwWBAWBpe53lu4s25ClTjbWnTUVxWFw=
Date: Tue, 11 Aug 2026 17:27:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 e0ffd277b09a7c9f1a436e5f75be37ac490bc59f
Message-Id: <20260811172713.d9f98913055bf8dc8331cda1@linux-foundation.org>
In-Reply-To: <anu1N-DOnQwxO1kF@skinsburskii>
References: <202608101053.PhnVUM4u-lkp@intel.com>
	<20260810132334.3cf85dc3e9061bc7072759f8@linux-foundation.org>
	<anu1N-DOnQwxO1kF@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: xeku5jyg8w84itsysfma4y4hwhfbts9m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4B7A8140004
X-HE-Tag: 1786494435-424752
X-HE-Meta: U2FsdGVkX1+M53pRHcaOcfciUVRgQsCZGT3B050ssCQTa9m5cEJ38QKwrPwpph2tROKocwdJPYzPzPzQaVCrOVqKnzhxjlqaIc3Ul5ewYfPymszfM+QM5d1ibxY+hQ3TSiGTezACtyTVMntJ3ZhkCKZ6S1JAMYoOzhzAwxZOwn30YARhY/imK07XfJ+ups6QwglnGsi4D9RWyr+mFsryt05xjiV3URxFgBiYze2jQ6eq6hLUVDG5yWr2rFMfBqF4b9LyM7bAJFoRG3pFgVISuyDkSm8Pfhk9h2Ntdk0f6cS/mGSWov4U9jvilSfAIqQnoMfANYsJ1MAgfwAsOK/2Gd2EsfCe9jY9ysobCsNbukZ/WvFvsJ4KORtMAhqeQKebtrzV1nm8ydvBG6P2JM9sYzr+sU9rTB1hJ+YpMKtiLSw4GmwH+a0kdGDEjv8znz4DeLT1bOdtxPT6OWngt2fQyph5TI66n7asdMJeL1o+GNZtDFbrpur4K2smUZZpxV62g4V/WWJ16zCky54WovxOAtCurMVSEe2jTrYWJVZ5WMJXBPYp0tZyDNxlxS1W9Yl4Y3w1F6DwCspy7Oz/yZQEzr6mu3GRCz3MDPgqOxRn73Y9L7ui/EyQhs8UqKohBMHy8fM/bPH3Q9A0HIpUQaYYGM6Mbp+wjVsp+DicGSIJEco+c4RiUhi+Dr/2QNhsy+WL4NX1zAMUAidtAGjj4Y/QVvHd83CvK9V1umxaA1Cho+jGutR8HLmg3oqnCfialT0cMrFTbU1zSsX/jcVDN3ma0FIevSiOx5aHtL8fexPGMddme7z0MjWOkThQKwrsy76ISeumGGqrGGZxtWtZVBvLDtOyXJ2AYxHVEv1ZxFdlufBGAHmYqkvHsQRzByUXXw+F2Bwh33PteBd5SMoMRQvrvncf7Dh3G92Jt1QsskpsameMHLSz+GqSeJFzOeh1Oe2MNzRqGyETUcrCR9BIxs3
 +DD8093J
 x80KkiV6V8Gj8DzhU+jZzxl2Kf6iVozAeoGGcehpAVI/m/e65Bs1LW0/qZHOTPURiofzD/pGRbaqOIt9b2XNaRy4Hdnpup/X5aMJXO5BSMJUCTLNT8Ga1n2i8yCYR82NigLctsTuSJmMLomvIqKpBSLClMhnPouhdpVteM/pPd1ElSTtQKb+nWM491PvMYXRG4DD3gqAbIAwN/8W6NUUQPF388Pc91ulIE/QLO2kE12/NG3g6UhwkQ2EhJG1Bs/eMQ1gyxgepI5LvETtk73g2GMP40S6De5VANfMsOw4Ege2tfi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 16:50:15 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> > Caused by
> > 
> > 	121170831228 ("mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support")
> > 
> > 
> > Stanislaw, you've previously said that this is a can't-happen, but boy
> > I'm getting tired of seeing this warning report.  Would the below change
> > hurt anything?  I can't immediately think of a cost-free way of doing
> > this.
> > 
> 
> I think this change doesn't do any harm.
> Perhaps it worth a WARN_ON_ONCE to expose a wrong fault handler
> behavior?

Like this?

		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
			if (hmm_vma_walk->locked)    /* needed by sparse */
				*hmm_vma_walk->locked = false;
			else
				WARN_ON_ONCE(1);    /* broken fault handler */
			return HMM_FAULT_UNLOCKED;
		}


