Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB9DFD4F34
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 810136B00C1; Tue, 10 Mar 2026 16:23:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4F76B00C3; Tue, 10 Mar 2026 16:23:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4536B00C4; Tue, 10 Mar 2026 16:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B6D36B00C1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:23:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 236E81C30A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:23:05 +0000 (UTC)
X-FDA: 84531277530.13.FE1D5C6
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5CBC520009
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:23:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IWxikTC9;
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773174183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MvUTAnnhc8zKV+r8Z88BcKJZ/7ZFuI0lAAC+kKQkCpI=;
	b=DjZJ7G26tiDj9vjzDSo9/VzH9lys4nOH4Zx5ksfk+dyjRfLDZk3LJSr/fbqXK/mcK4aDEZ
	cyOc0w0zTu9YXYmjxh5F0xup5gwpCOHTn2nQomjlDLJkaXLeYjGwc7tzFbaN2PTQCn30t8
	VZFGJdt/lCBE5oyVIUv+FOIGuFKEpuo=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IWxikTC9;
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773174183; a=rsa-sha256;
	cv=pass;
	b=SiMkru7UtA9z/01PBB6U1ANOhZZUQxddb5LsAXY7Majj6dGn+y7USj2sZFvf4njND0JNkz
	0ogJWBl4lJF52NyQRVV5ApOBzr+EYvVvR/Ty8qiaQF7EN55Q48OuGcQ92mwJQs3dPoeBuM
	TvuL2xnYUqanDuYycl+JBb/WwYhsnto=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-899eabc5292so100228336d6.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:23:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773174182; cv=none;
        d=google.com; s=arc-20240605;
        b=jHdUP0d2u0F06ez1zgcijbMo4Sz7/GnYl/h+oQNdWVtb33iUhaKRLMYvoARq3XXYVO
         haDI0sJyDyZ58kBBl1DeS6D0zZkbEdy1KuHE1kX8B44eyfSnNiLBmitEAm+26Kpk/aIt
         DLMDYpTo4qq/Otz/583qvSnEKG6xdRcq9BJjtLmzOlfrSWHAl5dxM6mTYD33UAjChjZv
         am7gUJrmgXWTFy8H2v1xi/QZFwSCvjd7c+fYrGykG4hFyxNKMcyxE4hSbyNbUl5/U8B9
         eDykr5oz42V4Uq82RavDsBt+V4o//RL2cJXwooKnoxxV5P1WClDp3RfnsqmJ7fXlxqdz
         CaOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MvUTAnnhc8zKV+r8Z88BcKJZ/7ZFuI0lAAC+kKQkCpI=;
        fh=BvJ8rSv7hjRJwbZveWzSWjQ0Bao4/BJYWAbn6Eoh2LE=;
        b=Pmw4Xmz/hOqv8p089AcH8D8KARIvsNu+GIwD5CTgFojBWP8LkIaGE2MZbjgQGwUInC
         odEPML6osD8kFyREekyRIpnYNB92vYT0FshH0zPELfrt7GvVTyENM8XnhdEDm3aiXbAr
         cHidF4gREF4xcLmdtq8w6xdG2oZOpCyhv1y/uAL1dVnLoN5HiJYe5IYsvRBpc/xYLspQ
         YUkSZFfqCbsVyBalUmflb0FacxEPO6FJvGg5cwtrCxDB4kmJS/KQCEPTqGUMgSgjcLMe
         sK6Qk/o5BiSypywPzwuJBvHfduDIrWJHNWj8PfIgIUVoDgyJwMGzMYafzqSTv6uEkboA
         9JcQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773174182; x=1773778982; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MvUTAnnhc8zKV+r8Z88BcKJZ/7ZFuI0lAAC+kKQkCpI=;
        b=IWxikTC96W3z/AeNxsdyYN8reXHq4ws7NarXyukYuOBAHwuvhPRUPXP/FeH2dqPdYd
         R1Y7OMUbFqhZ6EvZUqT2LgqapWf8eZtmzOCyCw4+pJjROdboLHUzbmDB/h1DTx4U2oiz
         f5A24Au89+gpFZnj9X9BV4TjQtIUAqdcc1JKJOhGAffs/Sp5BdqiObC0oAqxeY4e1ix+
         v1M2YiOrDsqTYym6SbIP703DmKdiL6Jex4VQwJ3zzw+Odp7mTtnfhg3R3ynOeXqkjNOU
         5rfZeE1bfhKMGUcXiHlOYesCcV0WvmLEZKLyIVgANyY1566Rg2fs2oufJph0fgDntcVg
         D72g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773174182; x=1773778982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MvUTAnnhc8zKV+r8Z88BcKJZ/7ZFuI0lAAC+kKQkCpI=;
        b=xRE5ygUl+7CyUA+c0wdHzg0VTAAyUYLSjtKzCf3t6riQ30tCF9codvGcZfkELY6D2N
         +9XG3GmuiDfKJK4gyuTrSeTBgwSZ9uJflx1Px9J9+OtTVTcPysJs8nhZeEPy8mxANIbs
         HkK2Ha2jDVyj8E6WFvL1XtnrQPO+ohCJCIaRqzPdlwXscJVz6eyi+H/O9ZYWtKw2LmA0
         0YrlQ0Nf30WzjEsAM13hJdZAFEG9xU8Gxaf2wIqYICrWL76oksCQiDEdTb6ASdMmapYj
         amrav52J4qnH9fWttriZB5LSn7ZXPMoh2q6X3o7dWaqR/nG1Ow6WE5xCNMdB7RYWAkRQ
         ejzg==
X-Forwarded-Encrypted: i=1; AJvYcCXuyVjWJafIRDD0WuNb+Yr3gC1ykVhuiUWDDoCegAl6Jidz7X2nV43N1yOHc7EJUoxwvNPP6h+uOw==@kvack.org
X-Gm-Message-State: AOJu0YzvxRnG0yoQBWg8mRjlFeu6akejezFeRoRs9K70iyYQRZePdOwP
	zrRfOGAVoxtcpO8LJzmBsEBPVaOe7jteiLTypjkejFNgYU6HrQzvz0O9gnYou0XIzKSv+2F14Ah
	0rIcWv+FSNrAjLlJvNeV7WQXR7jYB1Ys=
X-Gm-Gg: ATEYQzxIDJXWLZMB/I69LEhJnQt1t0xB1HGrFLK0eS/X/NcgEcaPXT0TJvQlpzWWJuz
	l35OAPnTwTsINPfnU+MT7sCQ+DMRhnRwETVUbE6wJJomqkaM44bX7PU+34YX1J6P2n6QE2uXvoK
	VS0Sw+b88xxI1SJ3kobP58SDtAB9hk4JKWsJOg9uHWbo1JdNps4oZqOndcy5433N1iLkmOdQfQ+
	DzdFYYmRG2V5EZDsS8x0J1IUe/lmVcnJgBmsW/b7cmmeC58C8K8bAQXck+07iXkoByaVKHgCk6Y
	Ocprog==
X-Received: by 2002:a05:6214:cc7:b0:899:fd8c:55d2 with SMTP id
 6a1803df08f44-89a30a5600fmr247155436d6.15.1773174182006; Tue, 10 Mar 2026
 13:23:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
 <20260310-thp_logs-v5-2-686099175bf6@debian.org> <CAGsJ_4zUQPfrpnwcXJQUGMP_0dUW7uQpVuGr7EfNm+qPnDGLHA@mail.gmail.com>
 <20260310131726.a9173c7cfa333b6522f9c8f2@linux-foundation.org>
In-Reply-To: <20260310131726.a9173c7cfa333b6522f9c8f2@linux-foundation.org>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 11 Mar 2026 04:22:50 +0800
X-Gm-Features: AaiRm51ZRMJnvEv-JOrd30Tv5A1BTLvAGzfg7VnWKNYbFopNGBE_oKN_RJyEr_Q
Message-ID: <CAGsJ_4zQf-6t5uSqNobA22q8wtchsE217ohC+2yG9-Rgum+dvA@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Breno Leitao <leitao@debian.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5CBC520009
X-Stat-Signature: k8u8hfh96a6jibap8j4dbct5fdp1ayh5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773174183-560074
X-HE-Meta: U2FsdGVkX1+0/zr5yluzf69wgByORLSlKwj+Jqc5i1OojrSCkQKvE/CilFUYiYioLaUo3jQEx4kwYTtaEnzWsBodccyQNQyGH1DxKa17Vej0Vjek9viUJpVm3xiYK+IvqBzHgT2FQ1BG5PAp/zKA2TasXqratUC8ju/lqtSBSx3mNeIcmMn9QCL40hZ3oDxzETt3h4yOZ7AqvNU7l0vLJ2KZN+n8fPU3vIqmaIJg9E6oaCwsDlpMc3G+CXWIf+Qjbm9mqW10OSITYu+2YVNjBlG7QXMMP4hwmqSC626wbsZvNZKblVNI2JF24igqcg9aSxMPaMGYwLeXpfoRYxobIEKSHWCo7DkDFdCyACEJ/4pukmJfCwO83cpc3u92+tqV/HTa0I9DZI0S0DaPUfqs59H3G5Dux18GHbpVRJwwDZLbxFz2DeaBA42q7CuvXkPHu1QZU3u8kMI+IegMx1XcdCOrB4MI8ywfrF+mcdbswFvKxLBRbQdxsGICV+QlJ2/+R2faLA0WmSEKJ6N+Cr7XoAWDf5ZTE/X83IWpWyag128g/Y1JMYg1NFnu9n/ZhLqKvV3v4+fVxN67V4RPo8r6lR1pSJzd5ncvd/AcCEqyIQ7HJsxcVvayhahPPjE8udTtvCLY9zr43ggPOilT3VXbNl48H6Uh++w3KscPKlKcMT3DxmZBKsY4gwF7vNGGRmhXWe6Pd5zAbWbOFolAgvHydEgOXwN0+l4Dq8q2x8JiAnFC0YjBURYXiykD+hJKCoVw6wQu1N6b1yQfQLKkgUmr6J4XnNyc1Ngm3q2D4AZCjtgVj5VqLfL1cihEZqAewl4Yz5Web7VlhsafLU4FUov74epC1vSZmtJgyrk+to/Rwh5SaK2NWz2zSh6a4DerxKm1utHXqoPYXsWCLp2rh2EkelmqUxbDf7IKN/fXnwhlZ6UsaOtvEM14JWPL/hy3RMlIa15HU1InowOvyqT208N
 gbJHVX//
 NY3Dn2bsRmeXWDFMND+W/TS4w+n1ToWhDywvzHli1G/ZDTZS41kUPT3VoA813B+3IuwmEv7sQ/WUKiPhmcU9xOnLGwK6ffE5GMbh2Y+X9F7PFNiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 4:17=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Wed, 11 Mar 2026 04:11:36 +0800 Barry Song <21cnbao@gmail.com> wrote:
>
> > > +static bool set_anon_enabled_mode(int order, enum anon_enabled_mode =
mode)
> > > +{
> > > +       static unsigned long *enabled_orders[] =3D {
> > > +               &huge_anon_orders_always,
> > > +               &huge_anon_orders_madvise,
> > > +               &huge_anon_orders_inherit,
> > > +       };
> >
> > Is there a reason enabled_orders needs to be static?
> > Could it instead be allocated on the stack?
>
> Could, but then the array would be rebuilt each time the function is call=
ed.
> The idea here is to save a bit of runtime cost.

I see. My understanding is that this function is very cold,
so we don't really care about its performance. But I'm fine
with keeping it static if you prefer.

Thanks
Barry

