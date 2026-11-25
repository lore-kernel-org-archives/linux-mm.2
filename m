Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E15A9606A338
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 14:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=c2q6pUxF
Received: by kanga.kvack.org (Postfix)
	id 0D0656B0A33; Wed, 25 Nov 2026 09:28:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05B606B0A35; Wed, 25 Nov 2026 09:28:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8C1B6B0A36; Wed, 25 Nov 2026 09:28:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C590C6B0A33
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:28:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 537CA140E3D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:28:55 +0000 (UTC)
X-FDA: 85473873030.08.3162E80
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id A1BE64000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:28:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=c2q6pUxF;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf11.hostedemail.com: domain of BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795616933;
	b=cCbMBfFC6mgp+H3Auxb7W5YUit11+hdj44RdyLrSGyK5cqg53iH7u7MJUGle5k2IaQwpZr
	QhC9U46TPvdB9iylVEf5cTkP2Mzb0rJXbA38eqXojhEY9xZsHh+q/fRclsZJoJxapioytM
	8m9mnfYLO3vOsP+Kv/9u0q4tW6FPQeQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795616933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+nE1qPVp4biQfgnZmZtxnKZHxMtTmWM+XoomPfXzvfY=;
	b=IRZcoUegS/1gvP9fhRcKcr8txz1C8RTwrDPnbMxDOZpYf60eOrSSbMI4YSbeok3koMQHpx
	+DZmhEGemMpTYU69XABEc3g9F5IV1VfUdVo6P8m0CkGitlWiU0gTXsf1vM8G+j3Cte4/hT
	vgfZXO9D5tPvcnZM9DggVu5YKv5ccdg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=c2q6pUxF;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf11.hostedemail.com: domain of BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+nE1qPVp4biQfgnZmZtxnKZHxMtTmWM+XoomPfXzvfY=; b=c2q6pUxFggMB89suK8IDdsrUdZ
	jCXUTOcTfjjP2XBTsLd/yj5QK2auCU/GBO5+ClH1686zBnQ2JUb+5sqF68UB8Zs36s9rZx23QT1ea
	JfZD91iGWqAcXnlOZAbPUiv161xP40bU/irhHG6UIgMODsh/ORUwsJlwTH07E+56mRQqI1gWBJZY0
	d8M+jtoVUh+R+Cd3WUo4NAB7jT6GKt4a9/uuu0Jv4N5XruPfzuYRzWXFXSll6GU66xQr9Tn0nEr3G
	MC2oLadAp455auSpszEib1fSqggUNyZp2aw7tgClSQO7v2Mx6WX7pKI/ou7ercp0anUCWLIdYYP8g
	ON0PNFGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWDzO-0000000AAC3-28Eg;
	Wed, 25 Nov 2026 14:28:50 +0000
Date: Wed, 25 Nov 2026 06:28:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, willy@infradead.org,
	brauner@kernel.org, torvalds@linux-foundation.org,
	Andi Shyti <andi.shyti@kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gem: Skip writeback of shmem folios with extra
 references
Message-ID: <awbwonrVnwB9yD5Q@infradead.org>
References: <20261119134243.3745282-1-kas@kernel.org>
 <av8n42vx3Q7zvQK8@zenone.zhora.eu>
 <awBIB3vjr_o-gfCn@shutemov.name>
 <awZz6sq_4cjIgUcq@infradead.org>
 <179559949792.43928.13638993010156007645@jlahtine-mobl>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179559949792.43928.13638993010156007645@jlahtine-mobl>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: A1BE64000B
X-Stat-Signature: kbt5pjswsm3apcom83kejqepagr3hbc4
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795616933-440050
X-HE-Meta: U2FsdGVkX18P4WUFTISgYx024l5rsT41lFJuo4RufTa9bcjr4vYZT4h21+Eik1d3/n+gtZLNC3ON8BCblf/T5APIoQfvd7TCAVCy8xtkIq4c8DLVhd4yynYnOkTtpD3psuefiHXJ8r5Synu7bwDgDbSBYthbaejqDZZPPEr8DLP1d0Urp2ENp/n8r6Cy7gvRGza02PC0P9Y4DPB+G/2Pq3bbDjulX+EYfkLnKVSyjGIE7eHxgT6H1TjcZpVVIoXDbmI66ICUBF4WTvDgof5dj26Iipnjo1IWN0eMJpI7JoBwdfKbOi+7CVh33ozJZgJV4rXp4s7Kswbo7DUWmHriLyupdOXrvHM6XTXdZ5ql5s2LZaSu7WRoDxfCAqD8nXgUbXwLmwkbWp4hjz6lcKbisuNqbPpS80v+J/fKimfT2VChxfZZgT3wW0OVtd8MiU5PAEXgqm5SW9PInpCi5iqo9n/GQP1AU/LlnQVB6tLlJIt+cc49k9vrpUHEQ1VyhkbreyDNgtjejxo9hoXFj5L9Pey/eUokWTSGof7orSfqHiLuPjID55s/qx1jx6vjrs/jlXJ6PXXax1dyiJMr9y/Yqpl4gEiuIZhgBzZ9wUmejx+kFb1W6w0s4dWADJeQR3W0LPMAsUgAfJiPQUeiUg44l0flfODqauE4qY0wbpncGwiyWfAmPm2ZJ5meCuS3N5ie/XWyfPLlmTdoPFqOJZnnxvVZ+69W3GZqP7uKFlWMJa0wew7QZ4WsMNw4QI8d5uROI6KU+AxJ4y5b5ouLJ2BPOQjWNNdhSMG4hJUqoMmjX7ZRlWtBpE+Avj5LxDoytDjV3QoYtjfZr4I5raJaLDi+0YlLBtNsJR6P5Zj3gigo+kwjl1gZZNgIPux6AAQNUASIZbx1hCYEw51s8VHP8skP89FW79P2xB3Use69M8uGn5IrKI8j/DiAQFkifvU6PjyJJGyznCSayc5vg501jNJ
 OQxUz9jQ
 4KxIO2z7YCLLWYqLgBUzH/XH7rVXqqNK/XJTheFfliglRmeUyGKWXq2gcdE2sW/+TfcrQy0nScLqzMtAqw4PiMGiczpmxsub1BWAC61y1j+1o7dN6/QI2WLnfXUT4XP0SPU1WJ+7kO2BZ9ayZk2IXuuKpBMZ/W85+p9F6YXoV4BpD2z7Oqf1PRMr495srXdWq+RTr3jJLjqYUad/ckkcFpooesUTfvL1q2JaowemYYG5BK/fHC87UWCLoy5n/cvqHaIM8n1ijmnyoyJ5CE0nhqk5CUjSafvhujrkoY6qoc4GjvGQUjUQjXMl8CbwwzrEDHORnaGp9WXRvK2pbDjgE/kHz5GAjGAQk24JnWR2aVu0NEp7gj0GiOdZEH7Gy++xxEo/UaWVzdsm9WQ6KcA8w8EOGwvJA8d9ypo8VUW870rrwMRP+ncN8WHHqfGUTRRA767BDsvGHVi6nYodvN94Aci/U7jGv6OqawTwULrflyybkbv4efL8DSG2COVPkrik0i0xGB9xdLXGdS0Y4OuG9EGXR8jFX6nmj/St/L80kMYm1XfBcLXIzIHO7BHQeiVcm6jXZ1lITqrUyZif+3yr2pvVumySNpXnjUp1o7hFnfVyZWFI5DgvRk/JG1cuLDuodhHLrJVTrWNwzhFSzdqFhTktGqJTuypPa4nURZhH6GdWntfqklG7zpm/uOcbKerNlzkUbiCprdYRMDSRbLnAzx2wzSpdi1wEmIsVNWtzjyfxvzawH6ckNaZjuZBcbtSe9tNbLV1epVkKmEktackhz+NIJwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 11:38:17AM +0200, Joonas Lahtinen wrote:
> > Heh.  I'm surprised no one noticed..
> 
> Not so funny to me, you folks are pushing regressions without ever
> Cc'ing a single maintainer in the original patches.

It's not funny, but sad.  Especially your reaction.

> I was under impression that Linux development had some rules about
> not introducing regressions and also some rules about not pushing
> stuff silently to other subsystems. Maybe it's just me not able to
> keep up with the vibes of these times.

Nothing here was silent.  All the relevant lists were on Cc, but as
so often with core fixes the drm and i915 folks completely ignored it.

> It's also more likely on the hardware from the era the fix was developed
> on, and the owners of those older machines are not exactly jumping to the
> latest mainline but rather more likely to run Debian oldstable.
> 
> So which one of you will be writing up a revert or fix for the offending
> patch or do you expect us to clean up the mess you've created?

Of course no one is going to revert this.  The change was part of an
important and invasive core change that is not going to get reverted
for something that hasn't seen any single bug report.

In genral everyone on the mm/writeback/pagecache/shmem side is happy
to work on a solution, but a little bit less of an attitude helps to
get things done.


