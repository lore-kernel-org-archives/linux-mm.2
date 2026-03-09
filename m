Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B363FEFCD6E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 09:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A05B36B0088; Mon,  9 Mar 2026 05:20:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3AB6B0089; Mon,  9 Mar 2026 05:20:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BFBA6B008A; Mon,  9 Mar 2026 05:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 772816B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 05:20:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21CEC1CCD5
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:20:56 +0000 (UTC)
X-FDA: 84525980112.06.40F82A4
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf25.hostedemail.com (Postfix) with ESMTP id 55E3CA000B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:20:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=grKOV7J3
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773048054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DFuJec4H2+P8uy4f99EliGjNhZsMpP0TMfZif0dlTmg=;
	b=NiG4xNpSYMdLqn23DuCq3inzcwbMlTnmfN3y7g2bC52d0UStiE8S08AJY+KtszucOCqwbT
	NFssTdaQr212AzwHdc7W9Z3gzh6miRat/o/R3jhjRt5uKE/BhpOCpvE34lO0WqkxO8gtQ5
	0GQnKjTe9XJNovbRtlxuJRbPc4Pg+J8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=grKOV7J3;
	spf=none (imf25.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773048054; a=rsa-sha256;
	cv=none;
	b=ltvFzUYMXtfZN7b3F4TSdwhfpOeirO0JNtxz+l1Eqyq/3jLOYn01qX5Ht1yEVejOZIiuBD
	ahomYsrMmbfH1jrZ2xFHrMO/2b5LXem0miNI0LGbYweXkGZbatpiVEsoIpSLNpcpNUPpKX
	8N42xhD8By18ghEwBj5NOkXqtoKrIwQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DFuJec4H2+P8uy4f99EliGjNhZsMpP0TMfZif0dlTmg=; b=grKOV7J3oVUX0lkZ9SfKH3a/27
	f6Bk2FwEfIzs3Zny2Abzp7YtYcv6Muy74KXRejKo9lGCsZ1k5CfunR7pdYv2Lk6ymO4IruxiaocRK
	w1csjZjXh2mmZxuoWSqAEoAse0Us9jb8llF/KNOPuKMfdyerQdW2nrY3kZvHvqW0U5CIKPTk/+KdB
	XpJOAj9+pFLW0/LeEDgIxa2UTVEx3Ji7QdNwZiDLzY0rWbtqAIC/6UPqVQ5syjCon4NBaMgElvDGB
	2Gozqy51n8MTJ6BNWVij1xja7uaJQ1qH6b9K58Vjpp+M5a7gx1ur9E0gUt5YzW90Iq9ZOVLZetlm/
	+cgOKmtg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vzWmq-0027JK-12; Mon, 09 Mar 2026 09:20:28 +0000
Date: Mon, 9 Mar 2026 02:20:20 -0700
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [PATCH v3 2/4] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
Message-ID: <aa6Qqb0sGy0m_J1Y@gmail.com>
References: <20260307-thp_logs-v3-0-a45d2c8f3685@debian.org>
 <20260307-thp_logs-v3-2-a45d2c8f3685@debian.org>
 <20260308140530.9ab6d1445d0936467eab4aef@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308140530.9ab6d1445d0936467eab4aef@linux-foundation.org>
X-Debian-User: leitao
X-Stat-Signature: pb67a6rmqtdaprd44z8bpxpu6tdksdqr
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 55E3CA000B
X-HE-Tag: 1773048054-375861
X-HE-Meta: U2FsdGVkX18PyPFrzpObJOwgUDkjDSXjj4mwVFOc8tSm6TUZbuXJ5sovcnaG4utuFbMWaZ3iUR9mJPQLSIHbIcOq+3+DPK/N11aonTDtxAuxy6diKo6L9wdkot2fxn1yMc4jKZdT+o1h9wE/TviwcAPaPOPXTWOasCs+iKe7yDyK7b9oUl9/mxaefw49WGw44vh/oXz4Ezk2LbOvOtxFSvFM5a1/0SqxJHzyNS4WNHl3CzqYh3TTuuZlHgIBNfAWCm8FiUPm0/fTadLrxZ9zGJKS2r+hK0MoF5pYo1VNxqR6vTyMNrg3q1iXyo4GJW5D6oKJyy7tcyvJ6HCjGGWcqXN8Qf+uqKK//L6RErQzdINQql1fc+8PiOIZdBThThrNMArq59jMKH6rAaNfgUCbD1VpFisJvBA3k63kffQAGc+j66axCBuoN0wrZnxKUm4bY4dd8ZyYII73yfQWkI1zTRko5K5xbpBNRJsL60LIOJfhW496nH4kNI67bP35RR0kWScD1/76ELYRxDO83YkHnoh94qc9+fu9srv90IS2sPxVOpL8A0qOKlUsl1cgpOgCRruU3cw8TxuVe5gsvRC4GfQQ+8GxOjhF+/gfIz7pLqFbnnUg83Gfg1eiW5/Jpm6pegRC1+2B/GCEBGaU1Z/3G3w5MKYn/o13+/t+3T64DWu/h8yUTVesBF+7n6CbcCWpLuUtPUve1NnAmTbvOzUJ8V6lZI6Dv2fGWdHRkS7YseQQp6Ep1s6QumTpWd3NOYjaS/hSyxBfpZ+zXk6ZLk9Rsx0fkbOL54UisjuDjGhk3eQVsf3PTIfKVExf7PgQyHMVuBFx+9/XoD4s+AYhYzhu6hR2S4ttaQnlsTbKOz7wHEY3KrdqTflg2phaOtPdmGx/8ZAVc9uZZJiMtNb65zjreacOywmJ5fYMVPUvhhOjPZWIzIq1lnnnejhNShlbttmrUtyOhvejQah+IYLby1T
 OHFS9P+W
 7iTE6cyIu7aezMd6WulHycoXW+1rW/cgZciOxzyByQlzhawlYEKhbQNhSmyGOigg3QP4p5x+5PkWc3GgzL/m3O3NTYYnA3afPXkZOdMUi+NhFCG99YnFdFpzf+XMIj7P+DoKpLLLLkQhpSbMVq9Y8Wc+2yhT5OP559qShMasBAJc68fA4Fj7r7HBVX7cEs2TrgJYraAnKYUkktWo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 08, 2026 at 02:05:30PM -0700, Andrew Morton wrote:
> On Sat, 07 Mar 2026 08:08:06 -0800 Breno Leitao <leitao@debian.org> wrote:
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobject *kobj,
> >  	return sysfs_emit(buf, "%s\n", output);
> >  }
> >  
> > +enum anon_enabled_mode {
> > +	ANON_ENABLED_ALWAYS,
> > +	ANON_ENABLED_MADVISE,
> > +	ANON_ENABLED_INHERIT,
> > +	ANON_ENABLED_NEVER,
> > +};
> 
> If we're feeling fancy we could use
> 
> 	ANON_ENABLED_ALWAYS = 0,
> 	...
> 
> here, just to make it clear that we iterate over the enum values with
> an integer and we *require* those values.
> 
> > +static bool change_anon_orders(int order, enum anon_enabled_mode mode)
> > +{
> > +	static unsigned long *orders[] = {
> > +		&huge_anon_orders_always,
> > +		&huge_anon_orders_madvise,
> > +		&huge_anon_orders_inherit,
> > +	};
> > +	bool changed = false;
> > +	int i;
> 
> 	enum anon_enabled_mode m;
> 
> might be clearer here?

Thanks Andrew, let me respin it.

--breno

