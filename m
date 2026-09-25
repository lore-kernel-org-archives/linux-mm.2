Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E76CC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 09:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 029C16B0088; Fri, 25 Sep 2026 05:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C8D6B008A; Fri, 25 Sep 2026 05:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B916B008C; Fri, 25 Sep 2026 05:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B82626B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:31:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35999C057C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:31:00 +0000 (UTC)
X-FDA: 85251765480.09.2DE3C98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 81EB6140008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:30:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PrcRyvDk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790328658;
	b=m3aXrx5BBm8JFh7KauW3T9SunCuCfFK7sFdOkEhtFGbXBGGoOsilbPFnONxFPwjVwMaLXX
	OQkj5XlbOp6qQEbtxUVI0allG4JeeMI+D7ydhnz2N89z6+EezE0UDmt3dWsSqRhDitqcch
	dQYtV2KCzccekt03V8RiHKkMttqRtBs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PrcRyvDk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790328658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZPvROUzm2CS6Mg3envH0hZ0KiQZJyc6fxn16uw0Jxg=;
	b=AWexD2YkecsR6R1SOrnGBvrVmYky+jjWOB8Bbtf3SKPb+HakpDumxS7smTwBFLX/nKXlO6
	ZAgrgEjdmGTAb8HbwjXeHQJz100A7HuTkYW8yoTwCDbvBzLcnVolMv1cP6Fh6gam7ZxOl8
	agzman8BSRBHTdUYlnoydG2OEvhZYSM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5710417E7;
	Fri, 25 Sep 2026 09:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795571F000FF;
	Fri, 25 Sep 2026 09:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790328657;
	bh=2ZPvROUzm2CS6Mg3envH0hZ0KiQZJyc6fxn16uw0Jxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PrcRyvDk4tQWcaU7YEM54W8UvoKbXWTsquEdmtoe+PYIWP1qcTzpTyNSl3z8mlgsQ
	 LnSdpsSp5U1oLFwFTRGHgnsAaa/t4O0DZfc/HpojLpvBH4Ws06rN2p3zjR+lEyU74Y
	 TKj+ZFQZ7G3M9v+D6ciK4niXnj9PpzhQvrBEJUrX4Unu4TU4tWJyC0sxWMrKPxeV7r
	 qQeOts850usAoS0s56E3+ILHWvhC7dLh5y+1WfoyozqGrj9lplRCwt/iy0EIg13t8X
	 Wnz9pnIIQ+MMfCweN9eQgW1+VBOj1ghs7MNXejm1bsj3qlRD1/i3uJVkBLidSwsNhf
	 WJYtkR1Hqu7Hg==
Date: Fri, 25 Sep 2026 10:30:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <arY7e_4p27Mic7bH@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
 <arVOW_frpIU_JbbP@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arVOW_frpIU_JbbP@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam06
X-Stat-Signature: bij8kfnna98r4zot5wjjwdaskshawhhm
X-Rspam-User: 
X-Rspamd-Queue-Id: 81EB6140008
X-HE-Tag: 1790328658-980568
X-HE-Meta: U2FsdGVkX1+jOBW9Y3yB1sH9b0pZCi1OHZ0XePitjwnWobffvrNU2bU37JhlTayNEamMUw+fpENv8VNRza6gg1MANOEM23mhgEloazQk2xUJS5ILOQ4MxMOfj3kRt/AyfcLBNbYLq3Jd3cjqF/NKIVgOaOpF9yRiGsMYlH9hih74jtpZ/Z4Z2V3qdWbSPeaPYlOCJZD05tXJFuhDj56UXs6peIrSDePxHgwPzedhWNOXaYxjZdTD5kaf9bWry4P6j9QsODIm5KsVFmuy6zfakN3r9Lk5K33UQlm9KQqfdsn5T1NVQkFEyCACxURI89jbdJa2H2vd3gWhFLRgxNxc/yFR0dkfQOjYmsZNFWIam6Mze7hKp/o4DmpyC27OXbvqE5VjZALzMkkzwcHIfu/FPqyFHlGalZSj0NGAfRReIk65sO7QxZBseM/LwJvwGruxk/tNQb7TPkakBj7Qw9nOOVJA1bvyuhLVWiRMTKqCg0uuYsRZpn1SQXGjAJkOOITvN68sw80XhSpUaNyOkmcdGi3lYSMQAxYobboNz4eRv4zBIoh52CzYigFLp+pkv3wJ2nE6AANeY9J7QmiZYrgoBILGYOzbrDIV6S0fQEWgbW6eM8xpQoEcMqF8C9WnVYh+BK3oX40ihE/fkOm8T3397khCouTuC549Xc3BcmODOeqjaBapyTeZRjd2Fm7gdpb3UW/We9uQCOXAYvZDPA+/Ey4VPLT5PW5TW4tf8J1lO4D+TW55MqYBJoBynf6mlcqOXC+nhwxLgU+uA3smHBfqn985NFHYXKbuWcTEgK6NhkTTJoFjcCVsnV8ALl9tQNiA5J880pa8EeZjRxq1c+Jv1TPFARboVq+3EyV56NHZlpd1vZGiKL20wQpTuHWNIi7v5CLDNKqRvDyZtnRqQD56UEJUnjEavWuR54ZO77WglZzGxj1YTqQxOE8kwAPQp3C79oV7sm46/XiEqlwwEZr
 JZ/ZkX6E
 4AC6IX4flnnmAthOv1pJkBsrO3Er7KxdZNreP8TRQsWqYxfpD7CJHCp21rJCzvDuMzp6+DqR3+55HA7Icp7AEN5OoSnHuVAc8AVDE5pgRlpsuhHeDbW1jj8rdvadcnOzLwvj28GNChljh9zvMspkf0Qi5EczmipQoPzlUYhLuRh7P8Ccc4QxeHlLxDl2eqyfGJlDzJMrRynOUsC7jwvp06OVrSnlQqa7SobhqWE6MkIiDOiDzMBlKqhAZSgJqhybel8It4d6VsaXRrx4+I0BvC9gBSnJ+ap5T2PB6y8qstfmvE2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 12:28:39PM -0400, Gregory Price wrote:
> On Thu, Sep 17, 2026 at 05:22:10PM +0100, Lorenzo Stoakes (ARM) wrote:
> > +static void put_map(struct mmap_state *map)
> > +{
> ...
> > +	if (map->vm_file && !map_same_file(map))
> > +		fput(map->vm_file);
> ...
> > diff --git a/mm/vma.h b/mm/vma.h
> > index e97bd2dfa786..f15faa83f3d6 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
> >
> > +	if (desc->vm_file != vma->vm_file) {
> > +		fput(vma->vm_file);
>
>
> Sashiko pointed out that this could be null if the vma is "anonymized".

Sashiko is wrong :) I wish I could mark responses like that so it didn't
regenerate them on each respin.

(I always run sashiko output received for each series through a frontier
LLM anyway + fix stuff that is real, see the changelog for series for those
things that were valid)

You can't reach this code without a vma->vm_file.

>
> Previously we'd discussed that anonymizing a file folio is more of a
> wart than a feature, and IIRC you intended to remove that (i think?)
> when you removed zero-file mapping "anonymization" so some of this VMA
> stuff could be detangled.

The anonymising as existed before clears vma->vm_ops not vma->vm_file.

The new _actual_ anonymisation for MAP_PRIVATE-/dev/zero clears
vma->vm_file but only on the raw mmap_prepare non-compat path, stacked
MAP_PRIVATE-/dev/zero is not supported as a means of getting anonymous
memory (and would be a really strange thing to do anyway).

(In general stacked file systems only operate on regular files anyway).

>
> If this is an intermediate state, do we still need to manage this NULL
> scenario, and when we drop the anonymization mechanism we add a WARN()
> that says someone is being naughty?

Nope not at all.

No code path can get here with NULL vm_file and it's already the case that
a driver setting the wrong thing NULL could trigger a NULL pointer deref
anyway.

Nothing in-tree does anything like this and out of tree drivers can trigger
stuff if they want but it's not for us to worry about (they already can do
that locally :P) :)

>
> ~Gregory

--
Cheers, Lorenzo

