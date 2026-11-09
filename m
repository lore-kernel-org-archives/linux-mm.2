Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A94E1606A330
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 03:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=J94oXTKr
Received: by kanga.kvack.org (Postfix)
	id 94A3C6B00EF; Sun,  8 Nov 2026 22:01:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920F86B05B0; Sun,  8 Nov 2026 22:01:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EBB96B05B1; Sun,  8 Nov 2026 22:01:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E4976B00EF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:01:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0462A16057F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:01:33 +0000 (UTC)
X-FDA: 85414080108.20.1C0C2EA
Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	by imf31.hostedemail.com (Postfix) with ESMTP id E52F220005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:01:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J94oXTKr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.42 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794193292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0cBsTfKr29EprWvRWdTno7HJ6tVflTBayogkYmKhf8=;
	b=jp0pD5IOKFmOU2ljaj3S12M6bUfhhHSGW2ufgqf8c9xxoxXTp3yVj6+x1HuVQvAQN/DDAg
	E5Xd2uo+0KB0d/lsFTpj+eFsT+bDOtaGhHZbDtbW9PM/DANEdzENP7I6zWShw9JlZrai8p
	sLRuzCRz8mwRvGkw/U0pP6pNGtJ1z0k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794193292;
	b=ysnmbRdHhWtWOcwS0EhhSULZ4uziffnb6vDOszFSYz/5xU3rIJhZd21Z29wGd2BP0mMciI
	Fxj4OKMs/OckZ3BgTQC7AqveuVnrSARmK8KUtIKTr4NY/ueAY9xftJcdmVwqkj5jGeseVu
	jAGl9pm0XoWo0xE326IuC3VEu2rUBqg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J94oXTKr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.42 as permitted sender) smtp.mailfrom=hao.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sPWwyCgiEM79EBArYvsUTzRVt5A3f2FMp+z7ozhU+4M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794193290; v=1; x=1794798090;
 b=J94oXTKrpISxrFZDMcsRTX8ndZq5TdkicIjyguqi0hP6sytimOkWguN6F5Vvk7D30cU4pugx
 CrUzSTSlhyxjns081C0A19ec3Snfxuu6eg70ZFbZT5PmPZBXt6BzNaxUjS8jk/ATMbgY7UnYyeS
 itaN52sRfHwWGwDs3m9slzQA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b7bc58d81506faf9;
	Mon, 09 Nov 2026 03:01:30 +0000
X-Mizu-Trace-ID: b7bc58d81506faf9
X-Migadu-Flow: FLOW_OUT
Date: Mon, 9 Nov 2026 11:01:24 +0800
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/8] mm, slab: rework KMALLOC_RECLAIM handling of
 SLUB_TINY
Message-ID: <avE01iTQccxQnhl6@fedora>
References: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
 <20261024-slub_tiny_rework-v2-3-bf1419ab5ffd@kernel.org>
 <auHcj2G78VkXy-Vz@fedora>
 <auycUvCC2mL_EQ1r@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auycUvCC2mL_EQ1r@thinkstation>
X-Stat-Signature: digqpxcoaenwdab9qpi9r8yiyajo43nk
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E52F220005
X-HE-Tag: 1794193291-97297
X-HE-Meta: U2FsdGVkX1+wig3oYuJOyxTNrhmG8dHWE607BzT+fpYNAkPmRH+EFLKfRtAEz8E4e/EYW0jLKnAczB36p1Dm1bjam/L9DALSLtRgAorR472liSlcs3iPdiN9j18y1UVvezH7Sm0Grml5DrL9hO1rOm8PPUMlyq6RWYpxxh1iB+X0LhP1c38AZr8sgKnfUq2ob6AFPx4mCDsXnwIIkkuDkcfrtXf3XlM1wtN3KmaS8pKaEAu1sJYGplOmaJsztQZdIwsx+qv9ZqLAlySq0dPHd5kT38oirrATDGsqmQQJK0Hn/dilnKF7KaTlONIjqLh8WUlNm8dD1jV6D4nnuG1hBgSiKOy9VukjN81B+HWxyXABmfVDrSzb57PqIMFXeFlPo7Rh6UkjTlrPG0IcQyRAeMxt/b+jC3K8jUqZepFS2VQDgHzPGlgAmTqZ3hWWlFe4A8hYXF8oXNHyRFGlcLCqbXIUtwWJxUPDWKQOFMh9fBVrujYaxyukiYnAkfT22npkhX3yWfCv9oB5MUnZjvfV2UsJI/7axBfiVtfQSmYKklGAt5+5LKVdRq51TIh4sVmXhIKfplq0r4H7Y2i4+ysv0FXtZ+CMrGtJEFSfjqaTCQdlEOga7CcvVHPb8F5Sy1dlqcZu2AHgTqvadD4zksXgQE/jCnzzaQf+DRMBaOAy89votT5rrtCFW1CwO6jk2Ie/nrITRPjCZinbmQBmKVbF/ZZ770wuEKdYKqfLSw8JcFTaZF/FcbXfm6fLesKqrDK97gB5/HsRGz+FN2kOoOOLkRcvOjtvYKB4IBBV/ci2ryhHTjygUpmLuwAZsXBf0qSFRATRe+vl2SJgtJJxlJprke8EzIDQaryvEfnUtXZXoqjuArpFrjHh8S53KaMfBHYlqZ91UXT+cIwJycdP+VrcdUq//ydes0UBcu3nmi/xntfmkrWM2f/kNc/6XYoakiJfz4Co8xPB/rWlFq/3nd7
 8eCVKbgN
 FJ5fEgQ2JOXu2Bzd0rPYkHMTKKQdFbn4Cszp5nOFkD4V2ul0mJMRDC2eiWx4j+4EEDCikGyY6wDa1mL3fcN9YEvYQemnj0GetP+9tWhux4pEHku2oLhPw4xlKIOG1JuA6/+4q4264crhRYo7WiT2xT+No3Xv/2DhT23SoTXtpP9wjfSnmhhdozfD/p760z96RG3dm6Piw5bajgeX6ylDZaoXYa6J200god9DVcLUdKH093qjSJgsssfph5dUV5kML6iHYc8GbJG/Pi6UsSNpmYeGNiV36Nd9YsT0lXGTbvUGR0oE+RmDUkOvRAGVAlgKq1i68lmDHCP5silB4qxGjlzfEbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 03:19:01PM +0000, Harry Yoo wrote:
> On Wed, Oct 28, 2026 at 07:43:14PM +0800, Hao Li wrote:
> > On Sat, Oct 24, 2026 at 09:07:25PM +0200, Vlastimil Babka (SUSE) wrote:
> > > One (relatively minor) aspect of CONFIG_SLUB_TINY is the assumption that
> > > letting reclaimable and non-reclaimable caches merge will save more
> > > memory, which is more important on small systems than the page allocator
> > > level fragmentation (where distinguishing reclaimable slabs should
> > > help).
> > > 
> > > For now that has been achieved by #ifdefs that result in making the
> > > SLAB_RECLAIM_ACCOUNT no-op and aliasing KMALLOC_RECLAIM to
> > > KMALLOC_NORMAL on the enum values level.
> > > 
> > > With the goal of converting CONFIG_SLUB_TINY to a boot-time decision,
> > > rework this so that SLAB_RECLAIM_ACCOUNT and KMALLOC_RECLAIM are
> > > distinctly defined always. Now, creation of kmalloc-rcl caches is
> > > avoided by assigning a pointer to the normal kmalloc cache on the
> > > kmalloc_caches array level.
> > > 
> > > To prepare disconnecting of this boot-time decision (and the evaluation
> > > of the need for kmalloc_no_objext) from CONFIG_SLUB_TINY, introduce a
> > > slub_tiny_enabled variable that's initialized to the CONFIG_SLUB_TINY
> > > state.
> > > 
> > > There is one minor functional change for CONFIG_SLUB_TINY=y. Since
> > > SLAB_RECLAIM_ACCOUNT is not 0 anymore, caches that differ only in that
> > > flag will stop being mergeable. If that turns out to have a noticeable
> > > impact on memory footprint, we can adjust the merging decisions to
> > > ignore SLAB_RECLAIM_ACCOUNT when slub_tiny_enabled is true.
> > > 
> > > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > > ---
> > >  include/linux/slab.h | 10 ----------
> > >  mm/slab.h            |  5 +++--
> > >  mm/slab_common.c     | 12 ++++++------
> > >  mm/slub.c            |  2 ++
> > 
> > [...]
> > 
> > > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > > index 02dfe4351e8b..33e76a0c3084 100644
> > > --- a/mm/slab_common.c
> > > +++ b/mm/slab_common.c
> > > @@ -1009,7 +1009,7 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
> > >  	 * KMALLOC_NO_OBJ_EXT cache.
> > >  	 */
> > >  	if (!mem_cgroup_kmem_disabled()) {
> > > -		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
> > > +		if (type == KMALLOC_NORMAL && !slab_tiny_enabled)
> > 
> > (While reviewing Harry's patch [1], I happened to notice a small inconsistency
> > in the current code. Since these lines are being touched in this series, I
> > figured I'd bring it up here, even though I haven't properly started reviewing
> > this series yet :D)
> > 
> > IIUC, for both KMALLOC_NORMAL and KMALLOC_PARTITION_START + n, if gfp has
> > __GFP_ACCOUNT set (and without __GFP_DMA/__GFP_RECLAIMABLE), the allocation is
> > redirected to KMALLOC_CGROUP.
> 
> Right.
> 
> > This seems to mean that neither KMALLOC_NORMAL
> > nor KMALLOC_PARTITION_START + n actually needs an objcg slot in obj_exts.
> 
> Right.
> 
> > Right now, KMALLOC_NORMAL already doesn't carry SLAB_MAY_ACCOUNT, but
> > KMALLOC_PARTITION_START + n still does.
> 
> Ouch, good catch!
> 
> > Given that, would it make sense to
> > change this line to something like:
> > 
> > if (type >= KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END &&
> > 	!slab_tiny_enabled)
> 
> Maybe you could send a patch as it's a separate issue from the patchset?

Sure thing! I'll post it once vbabka's slab_tiny series lands.

-- 
Thanks,
Hao

