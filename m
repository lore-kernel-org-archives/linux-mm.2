Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A48FEC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 05:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556D86B0088; Sun, 30 Aug 2026 01:36:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52EAA6B008A; Sun, 30 Aug 2026 01:36:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4449C6B008C; Sun, 30 Aug 2026 01:36:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22C136B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:36:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9EB7D40276
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:36:19 +0000 (UTC)
X-FDA: 85156825278.19.B9BA68C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1289D40003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:36:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F5e3f3zr;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788068178;
	b=hvTDsPBion8suwo/z0hdGHdKx0K13f7YtPyq1I99XOQpyKa35Zm/SsozxWdf+lfGjaXyf4
	vOyKEB0lKZ4EM6gGsLOcIOwU8bzvfkGSXUOVCeMfKk7XeP7FYBUN4Q6x5qcgGXl78HI1SC
	MgsJWrlgxr2FxlUWoOUzEsEBgbweptc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788068178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbu7Q3qcydpbduK5d5xuw3bm+6kDkYu6ps7F3h/cYC4=;
	b=L0pEI0UPvejU9f4zViNUYMMMGMlrOLis//dJmOPoWh3Eg2ng7ztu88t89HfzV18YZwmFhp
	iiIZcqjC8zy42NUBIR+9FK1K+Bzcli7y9m7hRoAX7CvkItydK+wgrnv3NLYHrxV+FrHty9
	Ydb2I1OBpP0g30La8AQEL4pPmnnjNtw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F5e3f3zr;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA4DE600AE;
	Sun, 30 Aug 2026 05:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AFA1F000E9;
	Sun, 30 Aug 2026 05:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788068176;
	bh=dbu7Q3qcydpbduK5d5xuw3bm+6kDkYu6ps7F3h/cYC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F5e3f3zrh6K28tm/qQp6Oue55tKOTLOm01Yu0X0OpWd11buxJM+oaQZgRaPgAlviw
	 orfhumU4zI6rXgZbcTbz0VyTxjMqyrqmt1yX+dwx/pPQKPoDwxaZymNkiEKL37jeMy
	 m8iwifd6CBos3sCjQc12VSH5HxST5TNAz8sS8HWLLTXtD53zgpGszWjYd1Udf6YqOi
	 RItioxeawc68IRB5v4ZTiIT2/t0l07vAMlA5MEkxNFTdL0oaOKmRwu/l+811BFK+ra
	 hPrKDWDpFPIFCqHB2QRZ5eP+KTGkOQHlKN9AYVVTraJss062/hlCVu+RUurmS761IA
	 JU6btVfCDBo7Q==
Date: Sun, 30 Aug 2026 08:36:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] userfaultfd: collapse VM_UFFD_{MISSING,WP,MINOR,RWP}
 into single VM_UFFD
Message-ID: <apPBQQ-850DwlCVA@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-6-3086981b33cf@kernel.org>
 <ao16VxNvaYzlt2WG@gremlin>
 <ao_9R3CbjYFipFu7@kernel.org>
 <apAB9GSnHNyNoSc1@gremlin>
 <apAcweThjiD-iIBF@gremlin>
 <37f6af95-950e-4457-886e-6548d4719f0d@kernel.org>
 <apK7s4xSgA_GmY7d@kernel.org>
 <178802897277.671075.10362065249796431311.b4-reply@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178802897277.671075.10362065249796431311.b4-reply@b4>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1289D40003
X-Stat-Signature: 7be8qsee6qdazr78wu344h77set1jm16
X-HE-Tag: 1788068177-681669
X-HE-Meta: U2FsdGVkX1+ZZnvBQhhSdiwMpnr9KWKD+GNSoWRgbXKrOMo17i5JFGyVRcuBumMI9bNL3c0AiMgrn98Cj80vKkKgOqh2v+fIrSk/EdZ7TgN0V7t/Yg5WJxy0U1wJs/4+yK40lsKCBEhTYR83YTcm+rRyb+NXZxn/ZKQ030Q6hliYDQjUtZwbvgijPjiaVg0mbGw640dXdV+ywBGtVC7E90LFPBL7Xq3PbBbf/D8I36AxniBQeCIprIw3aZV9/a7Yy3ii3gtJEucRnL8Sm0jmVju/3ELY6UmFYpzYMlNQxtMB1gxr3vFNLwSctJgzXH7dWgPoz7h6rMjnVsji7fkxuvU/mkRfIFznrEQCOIwsPPNqQVpyesT3dziBNJFrz3EUHraSYAEJhGg9J018ESqNreS7OrYkn7TI+VbSrCRIjO1O1Y2yr7NNdVUzM3YsenbMWQU7kaNrPvmbqQQloTHvQTknDmMDfrx7TswxqYCSYe59DH/VCFdFAiJcjGHdUJX7cY3En3usTltWCqoihr/CdBGtEA0u4kp/6NmCvSetrPpy58GniCc1J0jdJN0fajXVIPMZ3kaGcQg04WVqH6FCAax4m937jwq+mlznC2ukoBYh75oJOyRg//9LUVwRhSrl8sd2xJLk00aYAfgnhwoG70EYtBcAy4dbvyC2v1FJzekOwDMLXzf501zJs4GVqh3aA398f7BAXUzgJH4NB0ZjAQ6EpEmKyFFglB0LeynZaf25HRm4n4n8c0E9U9yce+Agvix2EzCMDX9PmJ2kE+JIi76ROtYlfe+94Z7c4wXGhe8H3C7GmXuv+lxzdi4GHpqFZwvvm5jLdMx0raenEBfAfdJ3feQQUO+WBC2i8wtk58cY3QaZWIo9HajXa/j8hF5fu5sh/Wd6r3UYNYZxO+WkjvzEnSfKuIrpWv/NXHrhOR+aANrJTLo9RN/si+bBGPP64DC9nneLv3I+NrtsmyV
 a2EgR2Wp
 HY8k9z6I4+baMHQqlYjERc8vmwOKSslzFjlKu2YJp/MEfzCemRvKllXBCrL847+A33iUUBZo4JyerolkvQ2oSqlDuScKAGY8rM1CFPI1gdUX47M15hrGuQFGv3+lX11LsV84R+rT+X00KHGywKzDIWCqzdWQkQkFieVvj9KTki1kBwU1WGWe+2JShkaMfBBUzBzyMj7mb66Syf36CYnqquOSy3S7h3sh6hokQBnJwWzLIS92n1496AODL6THoKL21txv+5LszFBDIhIPYM4XPSdGe0sToYrJbFMQI/FXZfszAXDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 02:42:52PM -0400, Tal Zussman wrote:
> On 2026-08-29 14:00 +0300, Mike Rapoport wrote:
> > On Thu, Aug 27, 2026 at 05:19:30PM +0200, David Hildenbrand (Arm) wrote:
> > > On 8/27/26 13:18, Lorenzo Stoakes (ARM) wrote:
> > > > On Thu, Aug 27, 2026 at 12:16:32PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > >> So actually you're increasing by a cacheline and increasing the VMA size by
> > > >> 64 bytes, i.e. 1/3, which is unacceptable obviously.
> > > >>
> > > >> Maybe there's something that can be done with:
> > > >>
> > > >> 		/* forced alignments: 1 */
> > > >>
> > > >> Perhaps? But that looks potentially ugly.
> > > >>
> > > > 
> > > > I say elsewhere (or think I do) but to highlight - I think probably we could fix
> > > > this by putting the flags in the low bits of vm_uffd_state.ctx?
> > > 
> > > if that's possible that would be clearly preferable memory-wise.
> > 
> > This gives only 4 bits and makes this completely not extendable.
> 
> Wouldn't it be 6 bits? struct userfaultfd_ctx is allocated with
> kmem_cache_create() and SLAB_HWCACHE_ALIGN, and most of the flags are
> only available on 64 bit, so it should be 64-byte aligned in the
> relevant cases.
> 
> (Not that 6 is that much better than 4... but it's a little more wiggle
> room.)

I did remember that SLAB_HWCACHE_ALIGN could be as small as 16 bytes, but I
didn't verify it for architectures that support fancy uffd modes.
 
> It could in theory also be bumped up to 7 by setting align in
> kmem_cache_create(). userfaultfd_ctx already takes 192 bytes due to
> existing alignment. Aligning it to 128 bytes would make it 256 bytes,
> adding 64 bytes to each uffd rather than each VMA. But this sounds like
> more pain for little gain :)

Yeah, even with as plenty as 7 bits :)
 
> > So I think I'll drop this for now and wait until VMA grows another cache
> > line or until having per-VMA uffd state rather than a pointer to per-fd
> > context is a must.
> >  
> > > -- 
> > > Cheers,
> > > 
> > > David
> > 
> > -- 
> > Sincerely yours,
> > Mike.
> > 
> > 
> 
> 

-- 
Sincerely yours,
Mike.

