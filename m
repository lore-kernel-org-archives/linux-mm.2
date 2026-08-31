Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F275C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 17:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDFFD6B0088; Mon, 31 Aug 2026 13:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90D16B008A; Mon, 31 Aug 2026 13:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F266B008C; Mon, 31 Aug 2026 13:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9815B6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:34:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23E71A38B4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:34:00 +0000 (UTC)
X-FDA: 85162262640.20.5339C8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8074240003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:33:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G9V21Wgz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788197638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3rWoRkOf7zv0PCshbvqGEHS10L1P71BDIMS5e/cVVs8=;
	b=hqDCRMZyib2ZV2uBP5FaNlrMXwTe4VfIgUjvwl4LQa1JB9zZNv74bg90ZW5tl+dUJ0hOKH
	W63YU5AzXBgackVAYGAXlpsXrro1V5DG1yEQiEvgfI2pructC7OHtAONtUvuT9IHViGJyz
	6xNmB7k+lyK34s7KTJZZoZ5TBEO+XtY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G9V21Wgz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788197638;
	b=2wniUL4h+LRq9SrggV8bYL2PAtiYsNwlRuIqy2LEifMlOfrZgEw3kRpnlJ5cnSyu3xKXRS
	X9l5+IHmNTo/T0VBzJmCD6Va6FMVfY2x8dJt/BgtiACEQfdz88BUhg4lwsuWUH8VJGVfZE
	xf+lQoPaxEv6z41x6bm3/UKbYMDqHyQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C20DC4080D;
	Mon, 31 Aug 2026 17:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6982A1F000E9;
	Mon, 31 Aug 2026 17:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788197637;
	bh=3rWoRkOf7zv0PCshbvqGEHS10L1P71BDIMS5e/cVVs8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G9V21WgzmFLNQZSG2z0fQqP6cGbXpFkpjQ33pCHeW0JoUiwQk4jNLw4DG0qFobeJV
	 SB25y9pHTmIgw6hrHkJqVXLqx4PxokSKd+6FnKExY5fUXUJCY1wbcw6poJIXsHgvU1
	 f2/ksMYJ/KI6+hnaezkUmQ3m049g58J6402lUYK5HESvPSz0E5cH1q5qAWVGDQnVaK
	 s/03FuqbRC1Ko5k7gBhGNv+uwjBDZGOCah1wzXzVZwG19OU+55Z/HE/r/iBYILtjMR
	 Uj0BZGaMWb6APJCKfnn+2rHy2RAEHQBpgbLC6xREt+AZzgGwBvx/LDiM2Blb5FPKiF
	 nOCRD7bfgP/Ng==
Date: Mon, 31 Aug 2026 18:33:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmpressure: remove window size TODO
Message-ID: <apW6fJZ-i_JdJejI@lucifer>
References: <20260831-remove-vmpressure-todo-v1-1-498515e59cdf@kernel.org>
 <20260831101636.a714f7171af108d520d4848c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831101636.a714f7171af108d520d4848c@linux-foundation.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 93f3concxiq8a9efkwirjs6kntn9id63
X-Rspamd-Queue-Id: 8074240003
X-HE-Tag: 1788197638-888774
X-HE-Meta: U2FsdGVkX18yoZYccyT3kfkQ85olfr/F5EFFMqFl57kp5MIPLcYtXabzYoM0wuULO38sijbGIBaPJpdfAwA1zmS7+XETZ665eZjfztJVHzPcf0BlUsmy7XVIMkco74Uks5xsKVy98meL8XGkCVt2O8cxD9bVLX2p6p02K8j0CFpLqStwNznX45XTUJmQtcBTU6B1roYaaE5kGZWSTZgnB1fDEM6t9vFLiO3Cu67Tg6RmalYSgZC6GiI8DyUHHn6QYKFT7BuNZ+4c5vQSWoVGhSkyR/JOsuoWMgtzSeLXmpgmWWPvvmWUGB7e3fFC5PWsW9sqN1S9fxqVq9wXcT7bWthYQHykzdijFVwGTIObf0rAwN8jbqNPNonVZRckdJWqs52aqubqTkCQkoHeu5t5INafcBhA6qKvkRxD+rbtopJDUkiim0wwNbAZvBuICm5BHUanHKPHTLK0qIQjomR5XmidERKs59bvds3+xUNRBVILrefQpAKORnrd+k50BJXTkwkIkkBPJinsoZcJqKGjpGpO49sH5HMEbr2torjZ03v0elYmayvn92FN+CB2dQ+lNBSGMIGWEYQfmJQST0BOJR3Gdy9jbHt/BcSvGsIcagChFzpbyDlSSeSxqTJMs0TXY4MhF/flH3xOUI+lyZtuHuJZ3IM+6gVKRgEofsjW/SpMxxuPE5trudnjiTsnwDejxae1cuJiM76eokyT6cWzjeHm/Vr5aYS+alE/fa3l7ubD0TjKu29f0JLYuN0qLxvGlg11R7hoxwD9RZXdm4yfRA/MeTBXYwL4X2nhqjhGpufN2z1ber3N3VMwQhpFGJwPWJuGWWu01Q5UmL3mojJuWX4CEmdDZzunCiQnCG6adGDDYY8Ry+K4UngGSer02VhslwzBDVmJ8Dui09mIJde6um/NsxKDNb42FpDvUM+mstmMzkChVFXMIPayFfk2uenvmL7BbwgrO/xSOdSYz7J
 B6V0p4yL
 h1ZjbuIrV3KIpxvEPScA9KlPifRFlmR2KqUdJIOaOiq6WdgdVzLK4C6eEfIKAAGbSqu2xZSdZeEqUJgqW3Z4nxBDC/7MOQ9rPjzmKpMMocWSFGsx6rjMd9FI2aDxeqVrXgEr5YeHp276mJ8oPzRe3ALGQB+SBCrhYTzv5DQCqaquaUV4HLsX33Y075waF0KmA64ZAnfe5V6Ae6/WfoonGGqyuXViabzg6jxNX1oJOnH00u32s/8Pv46pSk7zGkZQ+1iTx/N+iC82cS3h8z118uHXrbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 10:16:36AM -0700, Andrew Morton wrote:
> On Mon, 31 Aug 2026 14:42:11 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > There has been a steady stream of patches that have been submitted by
> > newcomers to core mm 'fixing' this TODO, with all but the original having
> > very likely been generated by LLMs.
> >
> > It appears that TODOs to LLMs are like red rags to a bull.
> >
> > In addition, TODOs in code often bitrot and are distracting - those who
> > understand the code know what could be improved in future.
> >
> > Therefore remove the TODO.
> >
> > The work required to actually fix this TODO requires somebody who both has
> > understanding of the code and significant real-world data to back their
> > changes.
> >
> > Such a person doesn't require a TODO prompt to implement this change, so
> > nothing of value is being lost here.
> >
> > ...
> >
> > --- a/mm/vmpressure.c
> > +++ b/mm/vmpressure.c
> > @@ -30,9 +30,6 @@
> >   *
> >   * As the vmscan reclaimer logic works with chunks which are multiple of
> >   * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
> > - *
> > - * TODO: Make the window size depend on machine size, as we do for vmstat
> > - * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
> >   */
> >  const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
>
> otoh, we could enhance the TODO to explain these considerations.  This
> might result in the LLM warriors submitting more usable work.
>
> It would be a strange place to socialize these things but as you said,
> red rags.

I don't think it'd help anything, I doubt the LLMs are going to read what
amounts to 'experts only' and sit back, they're not known for their
humility.

I also think, in general, we really should try to avoid adding TODOs - it's
bitrot bait and if it's important enough to do, that should be abundantly
clear to smart developers.

And if people REALLY want to signal that, put it in the commit msg (and
yeah that risks LLM incursion too but we do have to stop somewhere :)

>

--
Cheers, Lorenzo

