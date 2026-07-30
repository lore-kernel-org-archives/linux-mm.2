Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD2EBC54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 10:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACB3E6B0095; Thu, 30 Jul 2026 06:16:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3FB6B0098; Thu, 30 Jul 2026 06:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0FA6B009D; Thu, 30 Jul 2026 06:16:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B44D6B0095
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:16:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF8A8A0917
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:16:50 +0000 (UTC)
X-FDA: 85045039380.24.5D6F377
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 60FFA40004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:16:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gicFi79A;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785406609;
	b=PdouFJRYdX97ZHkOr+HU/oRkRyiffn2W3pwvX5gi3z4olOqv7PpjvQHwWTZETsxacou2hg
	y3y1Kdq6nsP/iz89PA+955h4ucdPnjJ1WiU2mb0XmWvpQATmP8MpRiY/AqAA5JepXHC/bp
	hEMxT3Q0suAZ4zvGv7BlGA1zOwVfT1E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gicFi79A;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785406609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jY7VtAKWV/98Ym8QzylyCgqneeBfbLyDYEdBY8MaJjs=;
	b=YzzZG+s2UbZ6YF5e4uhSzyALxgPqKklB7ZWk8t7TrWFuPRg59nChFo/3EIsm8AZL93BmyU
	ukoaBjLSeRkU8M1qdbcuB788TwG9iqmLNrXB16JasEzdE8qqnXTBpzWXTV+lBNgmbXQpCq
	lufK17D20DjxEqSBKEptqWz+xz5Iuyw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11D4F600AB;
	Thu, 30 Jul 2026 10:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F2D1F000E9;
	Thu, 30 Jul 2026 10:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785406607;
	bh=jY7VtAKWV/98Ym8QzylyCgqneeBfbLyDYEdBY8MaJjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gicFi79A1plyT5Ti6H4RX8MMHL+IUzcvhaDxk+855KtXagGlz88zpfpsLlMy6qiWp
	 KrMOEXmTZ9YJV8WurjO/RePpEPPCJFTrJYf4zkVCmofvO9P9CYTZZGtQsmkbmkyviF
	 4P3QQ9cB7b3pi9ZzhJ7V+wJasty4ReS8mTQzt2zhu1rim+TbsQVxlDGF+wZ7ZougrS
	 vXPQ+mv6Wb4YXCTWJLRoTOJzjKraalZtYoo0h7uc0Ln8jxlGGUaZTbSsRQumeclcX2
	 aLHXyf2rM3HWXJlUX2XrOB52z8JLwApbZUFOu/q2n4aD283FkJYC0jCY1hRrVWDMD1
	 oM+G+hzJQ9LGg==
Date: Thu, 30 Jul 2026 11:16:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 03/15] mm: abstract vma_address() and introduce
 vma_anon_address()
Message-ID: <amskFlOFd7l-VRpQ@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-3-e8ecfefea812@kernel.org>
 <amrV0Y7ZUtihiB2B@gourry-fedora-PF4VCD3F>
 <amrw2v7TVl_AG5_3@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amrw2v7TVl_AG5_3@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 60FFA40004
X-Stat-Signature: zwiyk8srg5gx5j6pjybuigmmeowaksmn
X-Rspam-User: 
X-HE-Tag: 1785406609-337420
X-HE-Meta: U2FsdGVkX1+KL3U2Zxm3J9nV4QGNIQBGGD+ncjo9hT3TP6gQ64mkjUM+B7b8vdZZspPGPYux4b/TVn/pqc3iOWG7guKCZmGjcHI6lJjeyNU5yGaxPcWG31vGZo74Gt3SUVMYuDXCPvDjsWBrkMMFyjk0LgI7130oeocYhjBLAMeEEpC+FzjhhnD+Dd1v2rEvOmuXSlaEPC6HUS870Q5YUub4nR0GGZPiKDzaFCXAax9eEFihw2uFe2yVFG1Fovr8NuPpB/Rs90zw1GNIS1Wrki0p/PJnGpiR7TfwIF1SlPKQjFqb9mGrK1K70Cs0dmXbYv3YNu4O1MgDJxCdxFDXxr1Xdmc6l73aQVrYu3xsJQe0cVjo3PDsTnOoe2CjlqLTAt9Dsu2CQpEAe82sHSzIQwPgEPWiDZABOg7rqZl6Qtqp26Putrdcf6H1igRFt40vIkcCQA1QtAOMQnsJcXbnosjliEh/XCCapNJku0El8pykpexd5yi7ME8MpF5Um3xPiB1AYSRpZWJpwioS6OpH8J9G50Tjo+KdD010j6Ou8hvF20qC1O6nn964Jb9mmlRfPfr6tbtEuU7T7eLzV/UnNb/aKDDzwV+Wz3hlilD6syRU1C60TRu0L4UjyfEZKSPynnkqMp3kdoAQ8cmv2BFnkRSH7HezFrqpu1kaPNdZCiIw3LhufdtjAqGqLWdiO41WxHer8USmIxn5t82rFlHQw0JVRl1l7XHvWOi7GNwx92x/mLg3azeKqOqo2mkEXerSp51Tk7Y+vsttNMOudrRyaXQr61yeXwu6zfmnywgDpoSxHoKJECZNHREn3Tn2GagL57uuPiJFJgY0JDmCbVsZafgY8asC3hTCiQN9k0YSNFD+XFe9iEO6kZ0Ps0nff64I0tlN45xCTHbXqeJaoPE/pOAEa1bvoBZD44zReppk0Utb63At0JJIGowuAgckA6RKaPOZ+UgpM7dUSH5eemt
 nvCmtwc0
 Is7wJ9J6IBmBbKj7q5fIBlYilQFrklUx7On7OeX3VvtH2lTPmAuyvI4O01RJ+PlaSH6DazpGhMaZYorto9fmt2v/EsV0F89tR3mVB7jwg+xlOCkBuxmdH0Wc/mvDjjjxUSgtgc0zyl8VLMi6NmEPurlBO3Z7kxtaIKO6f2zychZxG3H65xvzLobr7k3PQMwLTsjGTYjyT3ZZaOWatwWvWodp64bsksOM8ZJdV2lhFBMlXaTZZTiSCeGju6pjip0RmuMJcWcLjovhXtdr8Tp92IvJP8lYW0Xea0lsKCFXEPmlghBze7Hl9YabmOemFQM4/IxW5d0JWkKe8q0/9iCw6rsKhrrFCBHv5sJCOhEm+/ATuGc9hprLDsWCOgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 02:39:27AM -0400, Gregory Price wrote:
> On Thu, Jul 30, 2026 at 12:58:22AM -0400, Gregory Price wrote:
> > On Wed, Jul 29, 2026 at 05:48:38PM +0100, Lorenzo Stoakes (ARM) wrote:
> > >
> > > This will be necessary for determining the address of a folio's index
> > > within a VMA when the folio belongs to a MAP_PRIVATE file-backed VMA but
> > > has been CoW'd, and thus is anonymous, once the anonymous VMA page offset
> > > field is used for the reverse mapping.
> > >
> >
> > This is a doozy of a sentence...
> >
> > ... determines the address of a folio's index within a VMA when
> >   - the folio belongs to a MAP_PRIVATE file-backed VMA, but
> >   - <The VMA> has been cow'd
> >   - thus <The CoW'd VMA> is anonymous (as well)
> >   - The original VMA may or may not also be marked anonymous?
> >     (just clarifying, could be original mapper or a COW that COWs)
> >
> > Ow, my brain.  One question below
> >
>
> After re-reading the cover-letter again - my note here is wrong and
> my brain hurts more.
>
> ... determines the address of a folio's index within a VMA when
>   - the folio belongs to a MAP_PRIVATE file-backed VMA, but
>   - <The Folio> has been CoW'd
>   - thus <The CoW'd Folio> is <now marked> anonymous
>   - The original folio may or may not have been anonymous
>     (depending on whether it, itself, was a CoW copy)

Yeah :) this message is meant to be effectively a placeholder for 'there's a
good reason for doing this' :) I go to greater lengths to explain in the bits
that actually implement it.

>
> Lorenzo you are truly doing Darwin's work untangling all of this.

Thanks :)

This is really painful stuff and trying to get to scalable CoW the 'right way'
(i.e. several series and probably 3 figures of patches) is a slog, but once in
place will be worthwhile (and also save a bunch of memory :)

>
> ~Gregory

