Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B00CFCA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 03:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174538E0008; Mon,  1 Sep 2025 23:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1253E8E0001; Mon,  1 Sep 2025 23:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03B458E0008; Mon,  1 Sep 2025 23:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E74FD8E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 23:14:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D6618642A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 03:14:04 +0000 (UTC)
X-FDA: 83842841208.16.9007383
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id DE1541C0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 03:14:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IStlruoH;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756782842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lN+zT85GifRxZDGLDO44cXcKvRkcWSEkrLdMaJqcXAo=;
	b=qWn+c5kzByZSYR1xagGq8CutDigsgb0JmcNbdNCUh8pTaEyj/MPmiRuvqkE6l5oCJZGO86
	6P0zZqXR4V8IYNQdLDMuJjSJh2w8tXMgqo9HPiDbC6p+j65/hm9O++Kd4Ay0EoLOufdKue
	KZXECUhFXzb4gSKTsWsrG7Y+kmcNe9s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IStlruoH;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756782842; a=rsa-sha256;
	cv=none;
	b=KrIFidBkkmt2rHEYUCBTeeEv2r6ZGyujsRbvCHKkgFKvsuNllu7Uctrz/uipy/gjUPEVlo
	CQLNok8hu9i6EDhNQljs3v0qLZIm88AZXBd0SxEeiLzLUIqWmYZYQZCOI0wKHhC/cZ/WKf
	KvTjJf6wkMjY6fSyQ1xHLvY5UPzInIU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 43A49601F6;
	Tue,  2 Sep 2025 03:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9A0C4CEF0;
	Tue,  2 Sep 2025 03:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756782842;
	bh=8tRc8k8YGWK9MMlGkaSLcLvU0VnkuktJf34kIwuKRNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IStlruoHV17kUxTKoN29PmCrF7uh2z+fshCzr0KTNrPM1eeOpd/i+s9SjtFqHAgPg
	 Ak2RvUtwLGkDdD83HOWBfV8Mw/HD2DbCH0JobnrxVE86GgYLF5G9AlHcqHUGmjeIwY
	 JA7lPdTVT0LeVbXrQJfpb8xKUVine4dW9bGDe2c+Gva1JRq/RCSmN2C/OuaZkiUk4g
	 nVB3rVsEj2MDMjY/fa/oAeFnu5gndyK1aS5rBDmjZZ+pTCIlgrI7xduU++i3JZVrMQ
	 mtNqlyPelyKkaNkHV6AwUidgC+gzZVjblbGRgR/9b6BeV6+tdtC6YLp6GJtVfFydfj
	 /YtJV7E9s/cJw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	kernel-dev@igalia.com
Subject: Re: [PATCH] mm: show_mem: show number of zspages in show_free_areas
Date: Mon,  1 Sep 2025 20:13:59 -0700
Message-Id: <20250902031359.170361-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250902014933.93741-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dzzczpjo8ein4ae5cktijpw69nmtft5j
X-Rspam-User: 
X-Rspamd-Queue-Id: DE1541C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756782842-88618
X-HE-Meta: U2FsdGVkX19otI+B/+K/rqaYQi8qNmGxkug184wUgsEsVUIt+4Gm7X1CrLWZ911cklQyo7SZco9VGVE4QwMs3hnctSBeQe+VOdE4HG6ZlhKZkeJeMFRsm/6CEr5RH89IraEFhMesMJHMo2jW5T6n6GnJCgjY6RljuI/RBgh/OA/7QVSuwbd3pdu/Wzfp1TpNFHlShIH5KLUSC4QeuNOdZrRNrhI3ZEyY22xjgWJLDY/3OX9ytKgF85GXrSU2cXIcCL/Nnee8XhbGwsWzQ65P7MeuYKGwXlM+/JljEU4lOnkI990DW153A/ltw9sXEDV2EosCaqm8fy7W9o2zl1yTQe25ijuzlOYwuYWWi22DyuJ4s0pcvT2iazk5xiztZFKNdv8DYN6HSpltAA9uEIoaijunBwvH2M4iLwgpE9ruQp2eFA4v6U5GDRPdulB0B5MpX9jkgCXEs7WczWDk4itRNKS8HWKACnrm5NNYu5HJ5cgQ5meZrcVuN1vGZZGkhylhpax44ZEsFlvBsFWYLaKKN09kXRxgGrFWQhZo71AmW9vtBnP+C0+JILOwINALE4thQp0iywdNTOq23UcPHwhxEoyN59dmR7WI3W2dg0XGoc9vR8jbXWspqy1aRS2lB78gNzMfaGrq4FWtn7Txcp/JcPvFn1W9h/x9p15FQ2RHf3plRjymOrrdF8DyG4o6K2Ks2YTcsd7FCgOllMQHwV3QFayb6/wi9HbXjlYc4yxnNFCqsx8LNLZRWn9Ao3Dg8nvLmPP73Wn/ebrT8ykJXG/XlJJLJStfsfODkJmgl1oP5Ey7If2+tYM0qMb7sr3nO0RtH8DkkbXcxf+dD8HjfcxL99Dho0W0BIqm7xVg0hg8T/jyXRlDyYwEtIjm2+3QBiUUgx3BygLCpc1ZCLmD3gDyipP6t07Lh+g7TOaUdxnc8bqPZsNBkyqTC6tmVvS37zJ9tLckRVcfOjQb5Idh47M
 fL6bZgrS
 iws9IHkeqyO4yAXYNBOEbXyETHLl8xjBUQmHeVHnaZa8FKBHko/b666UekVYAyU7DRF463KFxT49FIo3M65gXVPz9hFO5FOmmBwOjJzbfV6Yyz8wrN3jZh1gTgtibQ7jsM1/hCoxWBqPZDfSvT5U4H69N19CcaQltyDOAnzf8/4I3pbefcrxCJsaQNigW5tgCXNPDQ/ko3dCRq0ftn2LYAGogs7vu4j5ktaBBWed2HiDdAhR+mkwWh/FXSZks7tF5B1zpbPQKsGEijLwH5yCKhCtNRVYcVerFqeaNm8LJ7Pkvm+iKEg10cSdZaqUUntyxP0FnuozYMoXQ6ts=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Sep 2025 18:49:33 -0700 SeongJae Park <sj@kernel.org> wrote:

> Hello,
> 
> On Mon,  1 Sep 2025 15:37:28 -0300 Thadeu Lima de Souza Cascardo <cascardo@igalia.com> wrote:
> 
> > When OOM is triggered, it will show where the pages might be for each zone.
> > When using zram, it might look like lots of pages are missing. After this
> > patch, zspages are shown as below.
> [...]
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
> > ---
> >  mm/show_mem.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/mm/show_mem.c b/mm/show_mem.c
> > index 41999e94a56d..ecf20a93ea54 100644
> > --- a/mm/show_mem.c
> > +++ b/mm/show_mem.c
> > @@ -310,6 +310,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
> >  			" inactive_file:%lukB"
> >  			" unevictable:%lukB"
> >  			" writepending:%lukB"
> > +			" zspages:%lukB"
> >  			" present:%lukB"
> >  			" managed:%lukB"
> >  			" mlocked:%lukB"
> > @@ -332,6 +333,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
> >  			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
> >  			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
> >  			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
> > +			K(zone_page_state(zone, NR_ZSPAGES)),
> 
> I found latest mm-new fails kunit's um build as below, and 'git bisect' points
> this patch.
> 
>     $ make all compile_commands.json scripts_gdb ARCH=um O=.kunit --jobs=40
>     ERROR:root:In file included from ../mm/show_mem.c:18:
>     ../mm/show_mem.c: In function ‘show_free_areas’:
>     ../mm/show_mem.c:336:49: error: ‘NR_ZSPAGES’ undeclared (first use in this function); did you mean ‘NR_STATS’?
>       336 |                         K(zone_page_state(zone, NR_ZSPAGES)),
>           |                                                 ^~~~~~~~~~
>     [...]
> 
> Maybe some CONFIG_ZSMALLOC undeclard case handling, like below, is needed?
> 
>     --- a/mm/show_mem.c
>     +++ b/mm/show_mem.c
>     @@ -333,7 +333,9 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>                             K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
>                             K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
>                             K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
>     +#if IS_ENABLED(CONFIG_ZSMALLOC)
>                             K(zone_page_state(zone, NR_ZSPAGES)),
>     +#endif

Of course, the above example will make the output shows wrong values on
'zspages:' and later fields when ZSMALLOC is unset.  Maybe below change on top
of the above diff makes sense?

    --- a/mm/show_mem.c
    +++ b/mm/show_mem.c
    @@ -335,6 +335,8 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
                            K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
     #if IS_ENABLED(CONFIG_ZSMALLOC)
                            K(zone_page_state(zone, NR_ZSPAGES)),
    +#else
    +                       0,
     #endif
                            K(zone->present_pages),
                            K(zone_managed_pages(zone)),


Thanks,
SJ

[...]

