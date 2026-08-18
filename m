Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A96ECC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 23:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F24A6B008A; Tue, 18 Aug 2026 19:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67C4A6B008C; Tue, 18 Aug 2026 19:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A376B0092; Tue, 18 Aug 2026 19:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 310136B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:24:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B54EF1401A3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:24:33 +0000 (UTC)
X-FDA: 85115971626.12.C732881
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D7302140004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:24:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SRT+6pzv;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787095472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIH6X1fb1/sEriLyBuiVQ+EzB6m/VSmiOnvuHrxsua4=;
	b=lRvIespXJV3VGqMR6ZhtT3+XydyRTj91tnVYT5Tn+h674rGZELi7oTPacXneCKoNuV1LkD
	M8C5fq7iVX2KdwjbvH1Wu/vIF6p/9vMZfN7w3rfghDhRuvhRU+xu1InoSfBJ6hbhUpbATi
	VhRAVLSzSMIsJ0qWdeKgGgsnJHqUAF0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SRT+6pzv;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787095472;
	b=lyQjRQs9PNlgCe50DFd3GROyy2WzIUOLFnckZLvW56ruFgdI7Hn+mDaBbFheOJOPv8SZ2i
	Deh27ZRGM88bsRQcfZ5xvdEF6fpwjUapnMV80Y8vrAJZ2IelZyMGlkvyWi/IcOXtA71jOH
	9pXI2ui14plXHogH7dpbTbWxBJVQoq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 057734364F;
	Tue, 18 Aug 2026 23:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D20C1F000E9;
	Tue, 18 Aug 2026 23:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787095470;
	bh=aIH6X1fb1/sEriLyBuiVQ+EzB6m/VSmiOnvuHrxsua4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SRT+6pzvcUuM9ptCo1ACCXsrdwT3tbAev1mMeJyRN1103rh5P5+6ZFZuV848WQqdC
	 B8J2zyv+PDS8MvzNm9P7lMTPXlh590jG+ktscuQ2Eq/dGZp0GR7PCMOGZ35f0eyup0
	 BQ/Rz5F4OmQIiwKEMiViXHjuJjGzHBQwp1NkTgq0=
Date: Tue, 18 Aug 2026 16:24:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, mhocko@suse.com, leon.hwang@linux.dev,
 linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: add cond_resched() to __unmap_hugepage_range()
Message-Id: <20260818162430.0a51522ac9bd671cce62650f@linux-foundation.org>
In-Reply-To: <20260818221858.86452-1-lance.yang@linux.dev>
References: <20260818115526.654d7311366b66cd031c67e4@linux-foundation.org>
	<20260818221858.86452-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gar3inamday8io7skfe4cqtoubg59p9p
X-Rspamd-Queue-Id: D7302140004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787095471-773192
X-HE-Meta: U2FsdGVkX1/LI50/Xw9KJi9EgVHH7Sw9mGzURTuQ9O6JKoEgilwomKS1URoHIuRWmLmJ1jGhqtoDO5O2GJOPdAx/Nhf9Ru+5pjIxt79mxpGeUtGBFI7mI02wO+tG2wr1cZFG1FaQqtskqXvn+EcsO92SYW0gKpALzTHrCUHgOhz4AmTgiUnXfHwlGaqSkzvTPMZwr5YNlINt0Ro+bCW/XqE58PPmnjgxXZ4iJLMFT6RvW7Q1MsiMOAeSGrbSQB5fchsAgpsF/SeNPlqBI7FTEgMjBCJEk8bOkHTGxsNuQ7ZqnH2HXgJ8XiHcKAuh9khHK+aKXX0GiYl2NxpB6r4JC+9DNYIUBirZRsDbABF2wBBHIy6anJdTqO2HM43WHd2IUbiaslnI1nVlXTUBBo3Zy5N1IvLikdnZLmAraEkVlMzNS2tLtu1X6Wz2AMT8W6tyRJEFsD7eg8voGsFgIc9gzrplM2dqgzWUvNt37m87zt+PjIcVqo3XHNDe62MojFRAr92QCX9W2JGu590ZRSWF3JzHe9oCMsgiZ4aOv6iFYssB4ithtI+3qG8SsQbfCuPsVH6NclJXMXR5PwcK5Jgb9QA/Posdsi2nmTorHRIP/nU0ncKG0IMbQD244jwyVqGNuJVTPV4D2KrRh36vaX2e0w6cD2+t8KbJRTNQ0kfzfcc9atGyhPlEPxvxM2431JPNAuTBQDLzd3nohiM+Df9vS4HmA0Wn0GJiJXW0Kl0aTChLUC5qXX7/HnTA+yoaTjtXkylcLi0b+KGxSWx+El9b5MBKAR/T9trkE4783W8t/hON+UKMoPe8N/h91MGirWu2boXk1nan6j11sR1pSWMV49Uv9AiieCkfMt/3anb+s3tzxEUJ1Vr0cF862Zpazq8kUPkUiiUTqkhF7ylxhmqJc6i2h2OF1gvAUZPCY2hOAzmp3EeHWxr6wBszGqqDTTKa9y3k5gj7UAQAe49l9s/
 r4/vQF5l
 fSdWlTEjg1/SlaKwK9IT9T1MWnAcpwkz3cowW0J8DBZyJazTjjUzEfsBGVuxclbIoXSDVR3PQ0WJvS/VpWKdGRlkls0YFo/9PCicsfVuCNOkKDGcx39NLlSuCnDdXI0tblul/0rTUVsUT33tyJKyKLJ4Cb38NUnyN0uguCt0+nr8p3TneJ5/WOLHz5E99Vj8LQYfFJpVHR9MOfsZQZfnGvrGiNcAnK2SrMNUtw8OEkI8W+2v0NE/rwq5VaVTWuqZBZcZ5Olm2WBfFvJmVbLv+7MjPThSqbfVonmfEu9J153t68+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Aug 2026 06:18:58 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> >> > 
> >> > That's pretty bad behavior and we might want to fix it in earlier
> >> > kernels.  Is PREEMPT_NONE effectively dead in 6.18.x and its
> >> > existing users?
> >> > 
> >> > If yes, we do want to fix older kernels then we should merge this.
> >> > 
> >> 
> >> Okay, but that would be stable-only fixes?
> >
> >Not understanding.
> >
> >Maybe you refer to adding a patch to -stable but not to -linus?  That's
> >against the -stable rules
> >(Documentation/process/stable-kernel-rules.rst).
> 
> Since cond_resched() is a scheduling no-op under LAZY/FULL anyway (only
> the __might_resched() debug check remains), why not take this upstream
> with Cc: stable?

I think so - as long as PREEPMT_NONE exists we should support it as
well as we can.  If the day comes that PREEMPT_NONE is removed, then we
get to remove lots of cond_resched()s.  mm/ has 200 of the things.

> Mainline scheduling stays unchanged, and stable can pick it up for old
> PREEMPT_NONE kernels. wdyt?

Addressing this issue in older kernels is another reason.

