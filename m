Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B30251049516
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57686B008C; Wed, 11 Mar 2026 05:27:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E3F6B0095; Wed, 11 Mar 2026 05:27:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2DF06B0096; Wed, 11 Mar 2026 05:27:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE7E16B008C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:27:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F20E160777
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:27:28 +0000 (UTC)
X-FDA: 84533254176.09.BAE6C39
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9FCC24000C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:27:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vCkVumd0
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773221246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BFLqimmXwB6BbWmOdEJ5V1xgLZKeGuWLhtRUXAuApYs=;
	b=Gaym++IisyXF9bUUuExYayTAfSLetcds23BWD1me0Q9uJtCGka0FquAWyF4rp/LSH21TRj
	xuumigQqV7mQ8RzIEL6ogIQANUVHwpWc5j1t9Afh3eFlmrnT1nxm6+P+a9cGyQKvSgMjnx
	OrPmit+hN0ClM2EzcrPo2LEJ98EXYvs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vCkVumd0;
	spf=none (imf11.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773221246; a=rsa-sha256;
	cv=none;
	b=p3AtecHJBtVE0sF0ZstIIXf74+L+FAHsebxAUwC05QalS6J4Z1P+Y8A+PIin0pN/yBALdh
	l76jfpiaxHwif5idelaNAQEJpANM+ipoI5HXjkJsy4C0BWsRjAoyOzZcBfkcEmLbA8U+YS
	axoSREUGnZOLmXRgcc4boA4kO2USmes=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BFLqimmXwB6BbWmOdEJ5V1xgLZKeGuWLhtRUXAuApYs=; b=vCkVumd0LOtXR6qOwYwctmbOy0
	F+BttF7V8MzgqOXNd7HJ/CEKGRsCfTHDcZ86YynJoOUGsi31SdZAfK8CnuY04qvuXhsiY3nH30fIu
	dCs2gEGXnNyke/sv1yNl75SaRB2sDqBaAQlLuvkUUTb9PKRpggeEnw+6Z2/tjLSEsD4iuR9tDUdlZ
	nu9eqaUUI9c+1KvkJUUA1ijz+92wPmbWEOSvjgJrfunVTRY+3bDm44VMAQfWZY7aWvqdW0jtBRO57
	Wg85KEaDq3DO3DjdTTRKjPajvu+S049j2qH0v3kmy7LGMcupZXS++/kKsGohr5sL1Rsp/iJTkVFw2
	tJPtHPng==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w0FqM-003fVp-Iy; Wed, 11 Mar 2026 09:27:06 +0000
Date: Wed, 11 Mar 2026 02:26:58 -0700
From: Breno Leitao <leitao@debian.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [PATCH v5 2/4] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
Message-ID: <abE0xSmUOFyHwOpG@gmail.com>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
 <20260310-thp_logs-v5-2-686099175bf6@debian.org>
 <20260311031229.mloqvlmmqipr7k2h@master>
 <be82a89f-aef2-4fd9-9304-a5c9b4e3e125@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be82a89f-aef2-4fd9-9304-a5c9b4e3e125@linux.dev>
X-Debian-User: leitao
X-Stat-Signature: xcs1nj9mhbf43sxuetqc9fm1rk9c4qjd
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FCC24000C
X-HE-Tag: 1773221246-112360
X-HE-Meta: U2FsdGVkX1+Iidr0FoStYRZOIQqgCagNssWxM89aefpO9bcibB7CONQuYmRp6c/mX9szdtNwif3BmbBF3YZH/Vf25HVnOvNaSnzYj/B0BoCT6lTK5WZ1oYM8jfyi/pNjn/Ht1VW/xj72UZstJC7deCPY71MIKb5Bh4prQcHNiB+wurDZ/EAE4qkoptu+2OCbK9d+pAlnzi/zvYN54TUTY/Iu27enkZHtpleCVyT2BVpBKNhsveInDh+GO9HolN3RG+cjDTKAyJ+w93scCOdo0D0fswqHCs0X0ju6r8oUANIRWdLXoXoVviYYye/Bn+kMy7gsNj3PFUme6tJ0yw0gMkVATMPZYl5Qc7w4jZJi4sif6AlInHitRes3usXQwBexTTNy6oUixUPNSf7VoTbO32wjPiAslKxrJHeaDAP+sljtoD4+wsEjBS8oydzWlKv9y1xDUkV5KJuwKZpnC6q4CmVqV+LHPsUolDztOX5vSAMfGQDVOBPjuRHTQivtR43fN1XDfnUZ55eH5LaKe+7KP/YJsP2zt2gtlyizJNt0E/44urRSCg1wjLm2RJ0YwSwphG31EBJ0qGdoFu79G6mLKDBjML8qYXyE9c1GoX9yqnBQ7qeZPTDrQkX0D5y4brOTCD/zZfL0hZHGw809ZpbATBR8IBCbKQlMovo30LwbdhfW58uthWMCwUXn362NfOOl9b2M6dtvxxtKc1YnFxV+6q/PSL1gZ/RdpTr0yYCybDe7BAnJjeCPYnvLccNbl36Gx9qO9nDQacBrMfMMzbbVKqeglwGSE5CkDFs4s61+Avl/2p9yW6hPxU34bVmKMaATEoZcqwnxL8XnoLaBaXz2vrjNYsuI5HncRwATbywd0vZnBJW8c50kQO+TmhIZJr/tej9WNIHuTCaPuZWoeN6Ak2rneacSKVMMxTXukMd7q6FY46DMuI/eNrL8hJEdUOBwS96R4c/Bdh8luGLbRbr
 wVz/WiBM
 B4b3ks4WOoHJ4FDpyqOBKsMkQqbwggqmNRCczb40i1OlBjeOaqO4JuKEdBc2eoYA8a1G5t0AiYewPlhbzBDO/OMrrf6O1v05fSh57KlfHrCcZbCSs0YZzL71gDdNzoqvZqy0Hv5dzc4D7U32tYuGzpQw9ToqTgYv0W7M727q8UDHlyClbOEL88LXgXD8KXb1BAuofro4eL5GXpgBr6DlQZqSCX5nPKUj8SJlwog97iAMPz9t4C32xmbZtCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 12:52:02PM +0800, Lance Yang wrote:
> On 2026/3/11 11:12, Wei Yang wrote:
> > On Tue, Mar 10, 2026 at 10:57:08AM -0700, Breno Leitao wrote:
> > > +enum anon_enabled_mode {
> > > +	ANON_ENABLED_ALWAYS	= 0,
> > > +	ANON_ENABLED_MADVISE	= 1,
> > > +	ANON_ENABLED_INHERIT	= 2,
> > > +	ANON_ENABLED_NEVER	= 3,
> > > +};
> > > +
> > > +static const char * const anon_enabled_mode_strings[] = {
> > > +	[ANON_ENABLED_ALWAYS]	= "always",
> > > +	[ANON_ENABLED_MADVISE]	= "madvise",
> > > +	[ANON_ENABLED_INHERIT]	= "inherit",
> > > +	[ANON_ENABLED_NEVER]	= "never",
> > > +};
> > > +
> >
> > Just one trivial thing, maybe keep the sequence as the sysfs output?
> >
> > Currently the output of /sys/kernel/transparent_hugepage/hugepages-xxxkB is
> >
> >      always inherit madvise [never]
> >
> > But no strong opinion on this.
>
> Yeah, keeping the enum order consistent with the sysfs output looks sensible
> :)

Good point, I'll adjust the order to match the sysfs output and send out
a new version.

Thanks for the feedback!
--breno

