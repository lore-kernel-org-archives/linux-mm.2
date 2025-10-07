Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B705CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 09:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA77F8E0011; Tue,  7 Oct 2025 05:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D578D8E0005; Tue,  7 Oct 2025 05:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DFE8E0011; Tue,  7 Oct 2025 05:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1FA78E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 05:53:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50CE511AF91
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:53:40 +0000 (UTC)
X-FDA: 83970856200.26.5CA6E2C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 78C5B180006
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:53:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PhYFE0Ku;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759830818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TpIokZil5wRA37yHuTGrVjatNtsjR1/AI93C3YeLOPI=;
	b=tG/F3daZJEfifceYfFabLP+RHHPwExF/h/hPsnoCdg9dmzYT//4MqBBdxWYeMpNcJVeMw5
	YO4Ab9nqlfc4Sy+jl6CGS4F+iEp07oYz3tJFjbvSw1X0wUIRxdVyMaM8tKVMGh4wWMFIiV
	wVlS9AJG9szff6FI8TXtT4KkkFQmGnM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PhYFE0Ku;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759830818; a=rsa-sha256;
	cv=none;
	b=boox9R7Cx9Sb0rzMACecHkvtfdmZaEUmWX9MARutwxXXyrXeyNucy2TqutJ9Q/LuYIAduh
	DJN2rSDmeONtlkHoUsOaQUETEChRjFmT2tPj1chMiZpRIlMGFDl8+VqQr7oxfC35nLjIjO
	sjX1IcWJITwjtXON+bczhC1KPyCNbE0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759830817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TpIokZil5wRA37yHuTGrVjatNtsjR1/AI93C3YeLOPI=;
	b=PhYFE0KuDCRI/Nj/9YAOruy3fZObSVtp1asS4iAQuMEzzFUcCwtumNQ6ci3EKx7ge9jg5m
	E3p+El2aXk830BL5VZj/6ihDuiCHBT+3GmPLCtK67BL+3WhYljnXR0M+bgichPHY42IAWc
	Gdk//xKj7e1Jq5gNxAX/JFx29tfSZ6g=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-nF3XDckcNdWMcLiHVdHMlQ-1; Tue,
 07 Oct 2025 05:53:33 -0400
X-MC-Unique: nF3XDckcNdWMcLiHVdHMlQ-1
X-Mimecast-MFC-AGG-ID: nF3XDckcNdWMcLiHVdHMlQ_1759830808
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 790F41800378;
	Tue,  7 Oct 2025 09:53:28 +0000 (UTC)
Received: from localhost (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 386E91800576;
	Tue,  7 Oct 2025 09:53:26 +0000 (UTC)
Date: Tue, 7 Oct 2025 17:53:15 +0800
From: Baoquan He <bhe@redhat.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 09/10] mm/vmalloc: Update __vmalloc_node_range()
 documentation
Message-ID: <aOTjC9H/1cbZbuar@MiWiFi-R3L-srv>
References: <20251001192647.195204-1-urezki@gmail.com>
 <20251001192647.195204-10-urezki@gmail.com>
 <aOCejd0aghFS8iSO@MiWiFi-R3L-srv>
 <aOCqSrnazd2YwGbe@MiWiFi-R3L-srv>
 <aOOUlW0SbBcPM6Mq@milan>
 <aOPBePFxNk5FP/ru@MiWiFi-R3L-srv>
 <aOTgcZWGlcx1TeDX@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOTgcZWGlcx1TeDX@milan>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Queue-Id: 78C5B180006
X-Rspamd-Server: rspam03
X-Stat-Signature: 6uwjf111xnn5dqwn7mtfipo6575oqu35
X-HE-Tag: 1759830818-639078
X-HE-Meta: U2FsdGVkX1/jsXBLTpJL+dpWnwNrXo3tswQ0uVy2FdXg62Orb23Ex3NAhdPB2iQYSMMwL3YP9/xu2fZ3UyLxGH4EY8NQ7BgVU4TQQIRK1dVfYVVOSXW/ZtgfZvQgrkyzoVYojRzLmPYpp+Ca3i7iPmzWVU0SG62GoyMpJtE1N+2hIG7Z9Mr7IGfhlnhW4ZAvHFwwhfTCsVMKgCuGfCK463BYqJwPWTPIefVEPe3OyNgLCTOff0X+lhlMV3mRhv0Sd0/IDffcU1VXdo04GaS60jZbSz08q3tXU8ddYDSFf2Ze++9+zuGgEcpJHQ3dGJUVQIfr3e2EBaepQrnPyqBmPz76ATmlIQ2xNCUTielZ/cR076JTQ0rBgBEKCylHniEPiUFGZShK9eKJ7RVGox/QjydIJIQJRev+ExngJlqC1utOibzFEQM2Qxd9ha0W93dLHSbRbAqIsnX/jJJJM8FnO9YSTMWiL+LOvIdzDy1TaMgUJRowmYkmN9glIiJEEX79NcQNuqvzm7bpajnMEU/PLlfE9kKnSFgw3svZv0XGrJGMMAc6iwXh5eI+67zDuleCSpcQTwd+uWCDuJZodEbFvr0asBzBry8d++fk6hpPt5IbfyvQ4wv0e+el9TXBDsCGhcW5yxzVJjInYtdyH5mCkj9UtJyh3XCnXH3DWhcUKS1GlwZbZ9SYHIkAcViSAhx0kFqm7fx2agLWmiFR1Egax/KIrm8EEQqnyYNMmf9x8B3qYbxKKSvy25VwTiyg8tKoetfYiVnCX5jPBwm+Y9sz/PMqlvWraduTcJVflg2PdinwHqz5ci3B5RPxu7ch9LSMPwcpD173dVsyAFl3nWUiZzTKYxi06SJoMgJrRdFRwwTaIr2SlICpU8cJ3xF6XjIOOavHEFP5QkCitWpvCn4Ocm4yU4SmkV5KTAyVcwViLfwCN6qHU8v4Rv3J+wS53c4thxSdrjCwZai3mn169oA
 2jVOJmIY
 43WabP25YUaNFsazDAOlCWNcRq2bhSZGL4nLescr00mgAPlvduYU34jIx7kIranqNa5d48+ciDgFNMyW9Xui7stitOz5Nv0rgjosIFxwr7tdrH+kdzqPkS0IamsG9RTNrQFVMFWVfP36YkamLp10w3aCp5A4YBQEVZ0NMKR/H3orlQACyJvbGiVOX1unUFXmjogPqgV2/QGgKO7NsGOFrScAk+1YbNt467hdKOCccQGo0XKekUWf/LQceB9qIEir50/wGQc15FNVjiFBluLE8Vl0O9ywzNfNS7dvDhzr6bxod9PBjnkOXLyQSrSbyNC76m9Fk8pYvYJ7PWNZxRqPbjDuTJ2S3019yTmJWOZ3F8Ju0RbWjujuNJ1BIGIPCD/av+vhFqvolan3z1sKuQTSPrT2w7WXua1gPUnUK7c6TzCgWzAZiHYcsj9K596WEl3RU/ngYHu3Yje3RptBlHcKcrKCtv429vhtdBRC/FFmO70M0aojUV6EZ8ijqOU5epE2G//JOAUXHjXICg/mHnmFR+fFwSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/07/25 at 11:42am, Uladzislau Rezki wrote:
> On Mon, Oct 06, 2025 at 09:17:44PM +0800, Baoquan He wrote:
> > On 10/06/25 at 12:06pm, Uladzislau Rezki wrote:
> > > On Sat, Oct 04, 2025 at 01:02:02PM +0800, Baoquan He wrote:
> > > > On 10/04/25 at 12:11pm, Baoquan He wrote:
> > > > > On 10/01/25 at 09:26pm, Uladzislau Rezki (Sony) wrote:
> > > > > > __vmalloc() function now supports non-blocking flags such as
> > > > > > GFP_ATOMIC and GFP_NOWAIT. Update the documentation accordingly.
> > > > > > 
> > > > > > Acked-by: Michal Hocko <mhocko@suse.com>
> > > > > > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > > > > > ---
> > > > > >  mm/vmalloc.c | 21 +++++++++++----------
> > > > > >  1 file changed, 11 insertions(+), 10 deletions(-)
> > > > > > 
> > > > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > > > index d7e7049e01f8..2b45cd4ce119 100644
> > > > > > --- a/mm/vmalloc.c
> > > > > > +++ b/mm/vmalloc.c
> > > > > > @@ -3881,19 +3881,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> > > > > >   * @caller:		  caller's return address
> > > > > >   *
> > > > > >   * Allocate enough pages to cover @size from the page level
> > > > > > - * allocator with @gfp_mask flags. Please note that the full set of gfp
> > > > > > - * flags are not supported. GFP_KERNEL, GFP_NOFS and GFP_NOIO are all
> > > > > > - * supported.
> > > > > > - * Zone modifiers are not supported. From the reclaim modifiers
> > > > > > - * __GFP_DIRECT_RECLAIM is required (aka GFP_NOWAIT is not supported)
> > > > > > - * and only __GFP_NOFAIL is supported (i.e. __GFP_NORETRY and
> > > > > > - * __GFP_RETRY_MAYFAIL are not supported).
> > > > > > + * allocator with @gfp_mask flags and map them into contiguous
> > > > > > + * virtual range with protection @prot.
> > > > > >   *
> > > > > > - * __GFP_NOWARN can be used to suppress failures messages.
> > > > > > + * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
> > > > > > + * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
> > > > > > + * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
> > > > > > + * by __vmalloc().
> > > > > > +
> > > > > > + * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> > > > > > + * and %__GFP_RETRY_MAYFAIL are not supported.
> > > > > 
> > > > > Do we need to update the documentation of __vmalloc_node_noprof()
> > > > > accordingly? I see it has below description about "Retry modifiers"
> > > > > where gfp_mask is passed down to __vmalloc_node_range_noprof() directly
> > > > > but have different description. Not sure if I missed anything.
> > > > > 
> > > > > ===
> > > > >  * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> > > > >  * and %__GFP_RETRY_MAYFAIL are not supported.
> > > > > ===
> > > > 
> > > > Sorry, I copied the wrong sentences. Below is copied from documentation
> > > > of __vmalloc_node_noprof().
> > > > ====
> > > >  * Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_RETRY_MAYFAIL
> > > >  * and __GFP_NOFAIL are not supported
> > > > ====
> > > > 
> > > > 
> > > > > 
> > > > > >   *
> > > > > > - * Map them into contiguous kernel virtual space, using a pagetable
> > > > > > - * protection of @prot.
> > > > > > + * %__GFP_NOWARN can be used to suppress failure messages.
> > > > > >   *
> > > > > > + * Can not be called from interrupt nor NMI contexts.
> > > > > >   * Return: the address of the area or %NULL on failure
> > > > > >   */
> > > > > >  void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
> > > > > > -- 
> > > > > > 2.47.3
> > > > > > 
> > > > > 
> > > > 
> > > We need. But i am not sure it should be fully copy-pasted from the
> > > __vmalloc_node_range_noprof(). At least __GFP_NOFAIL is supported
> > > and thus stating that it is not - is wrong.
> > > 
> > > It has to be fixed but not by this series because when __GFP_NOFAIL
> > > support was introduced the doc. should have to be updated accordingly.
> > 
> > Maybe just remove the documentation for __vmalloc_node_noprof() since
> > it's only a wrapper of __vmalloc_node_range_noprof()? Surely this should
> > be done in another standalone patch later.
> > 
> Like below?
> 
> <snip>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 9a63c91c6150..7ff81a38dcb8 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4027,12 +4027,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>   * Allocate enough pages to cover @size from the page level allocator with
>   * @gfp_mask flags.  Map them into contiguous kernel virtual space.
>   *
> - * Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_RETRY_MAYFAIL
> - * and __GFP_NOFAIL are not supported
> - *
> - * Any use of gfp flags outside of GFP_KERNEL should be consulted
> - * with mm people.
> - *
> + * For detailed information about supported GFP flags and retry modifiers,
> + * see the __vmalloc_node_range_noprof() function description.
>   * Return: pointer to the allocated memory or %NULL on error
>   */
>  void *__vmalloc_node_noprof(unsigned long size, unsigned long align,
> <snip>

ACK


