Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A382CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462536B0005; Tue,  2 Jun 2026 11:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412FC6B0088; Tue,  2 Jun 2026 11:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302346B008C; Tue,  2 Jun 2026 11:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7A56B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:37:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8FC91C2234
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:37:31 +0000 (UTC)
X-FDA: 84835377102.23.19A74FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4B0B520006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:37:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iaQB19BN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780414650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+TuS8DPkmqRtcPq1oa2ywCobW38zWJCJnKHfJp57ck=;
	b=6Sgk6S9iZCC0bQBic5uBT+5BQKtR90cpTv398xn87xNLqOn5UdrB8SgX6hoJ3M0r1vt9xs
	o7dg5QvDJRbY1pQFr/yofgebblt4WQdCYLzIG5Uvhu48v+yIkfhFccOi2lqacpoW8IRUaj
	QDu3IKsu0B1vwu6p1PTmughB9fnWGJw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iaQB19BN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780414650;
	b=xMEYUrYdTxw+D8gOLu28nOI9+baTJ2hnlb4UONCYbizQrewbQ1FUK+/qNmXnOPgQYvETbU
	VzM7AAjLe4Bz4uVI8j3deJghNVh1Pbli8BDuPYTs5+za4KkKjf0JLNXCLtqoJMd+yiQEaH
	4Lj/8SRZYSOaW/sGf110NcSzAvQ00Cc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 92B5360154;
	Tue,  2 Jun 2026 15:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8958E1F00893;
	Tue,  2 Jun 2026 15:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780414649;
	bh=V+TuS8DPkmqRtcPq1oa2ywCobW38zWJCJnKHfJp57ck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iaQB19BNBJyOrQTApmU2FIBDnUDlGm06EsaWVbhN3JfWPfFzKos7oVryfuz2kP8Bg
	 9hiZaLmt3p6pa+56vFEnxwIdysvQmp4oe4BADtREZ/e7I+QVQZLrc6NtgxGP1yakY7
	 1eNOU6u9hu29q/DVPlbFNS9b5tNooovRJI4pxdnPsuUIArQyEX7A/W98RqDLiuZ4zK
	 vB9qWK4PpYNT1/+2dW6eGnxGq1zq5E4OdG2YrYHX4kQfhxg/Xg6HgcIqqeRqFOuDey
	 17M1W/oK+PFtVIj2yIteJXc1fWZgYAqYgCsBprsuPs6oD9xpm1ohcDL/6gDZowoSr8
	 OCXJqUGKuVQSA==
Date: Tue, 2 Jun 2026 16:37:14 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: Barry Song <baohua@kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org" <willy@infradead.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, 
	"harry@kernel.org" <harry@kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, "matthew.brost@intel.com" <matthew.brost@intel.com>, 
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>, 
	"byungchul@sk.com" <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ah71gjj21rLIuTnb@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer>
 <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <99dfc4a50f3643a6bef6deaeccfcf115@honor.com>
 <ahlzj--3Gm5pD9ge@lucifer>
 <a90bcb0fa3a044588350e92a78258a09@honor.com>
 <CAGsJ_4wFr89M2i8pth79swv3==i8SGSMWrbr+Yp2umwFTuCShg@mail.gmail.com>
 <2e9175ab-f9be-44c6-bf1a-a82aeed18f98@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2e9175ab-f9be-44c6-bf1a-a82aeed18f98@linux.dev>
X-Rspamd-Queue-Id: 4B0B520006
X-Rspam-User: 
X-Stat-Signature: ir7nhzpmkwu67ureapefxiciga71uw3x
X-Rspamd-Server: rspam09
X-HE-Tag: 1780414650-438503
X-HE-Meta: U2FsdGVkX1+HVN4TGpQEk/RuvlcvaA7a6Nz7f0OGrqJCnHNndfUlbDfYRVm9GpDCFA+89dP01TqmENoGS4QPgzr6NhfSxg0aERX+FB44Z0lBZxdU1Up56F7UKre3iUA2nC+egN0yWzVQ2DNEDu6W97ddNe+cnadZ9aJxPEelCXk/fuYHt8yqtc/ve7+4CHY6Wo6bpCL9mhQfGTsjYelk9IkKhVqt5KlBRWllr0MvL03qDezHekwRxz/MB5f9ZN+km4+38SRjl7DfAralWgRjyC+bDU4QhyqUow1yGRGmaJfbKwk1YMTpyAO3wG+UA4PrmLVQi5qvC1W4IIOzloQ9v1xGo8k6mk3bk5q+xB4KVgg7hjORHepwixoH5EsfGMmTYWTok1s4GsIHOdsRHkANQpQzB+oWfkbj5RN2gNreAakvBoNdGiR5Zo6ZwvGwi4Ma7Am3agcgFac6uou5KohA90ymrvX/fFnD7BIyOPgFryNDimneMBfTWy26tgh0jz7H5BF0mjS2jkqUP6GdaIrf/RbZ0/FV26DORVlLmdW3TouD+D+pLY0XYBX6VoObZ3izeOVkCm18QD7IF6QVrfvCDWBaUHzmCgWptPq8SEQqpSS8qHkcgcfDW+KnecUXyXBtcpQzHnAX+bbEVqPN/03rWz06XDx74onjcaKDlKHTU2fL0lEEgfbDqB/cucthxtu/LfO3P1tip8FIhXtFn6eMpS2mhhh8OyKj+mNad7K8e9o3i3lR4NGyAoQZ/yo/C/PcXJ8BUiz5IEF7l6lYO76VzRMm3jaybFCnkU+bgRK1WpFMgTt3A6rFTyW1VjBkLxcjpJUaiLJG8RKvhdBE5xRr0uzA/R7TfzRwoNMlGDOuoh5YWjD+S1SDeNsX9MSawzbXZQQW4WujhRTqIhMYuywIJbt0UBxk2QUMW74Nk/OaCqIZ/NoofZv9SVE6WpVNymKyobJneDALcQSdNsNTfk0
 6KK759fV
 olGphAv/AZVNtqleWSO26mfsmUWjr40j6mIqDjW8u69e3OWwjeOrVbWfmSl+mDthiJmXTOByIf7X+9hpMavl1Dhkv21ECcN/RlgAdddsCOxXWYMX26n9Ijt1cVf3y3uteJKRrKgT6sxGc//Y3nCP2Ggt3wg/IxQeRjIAjvmqcqKdNEJCGwxVjCdnbSUFhfPkovIydV/V8MVwsmJDDcFYiRUFrT3CMn3wvCSvd02FKk7W4pqfbM42f+O7qXhzSzlZOlDW6fIfbbrA1A3qsETHRlvEvRhGCjLyVjkMYfw4frQPs0T5L1zqPVzuMwC1sQv1BWp7RqaBOIHKHESGbiVzf058pMM31gWwp5YxZYPMz0QIEi13JbZcpsmDtCdvYRCP1pGC5mCxEkjRVuspJxFMaId0t5yf8SRtGo1PwkeeZxrnrDY0lytMFbzLJBJrOW3JpfEjaksJkGqsHZQbx+GkRsia22PRgsUxfix5PbkkLhbYvzO5TGCKjFaC3f1sD7LSyueY/nQ78cG28gvo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 10:46:35AM +0800, Lance Yang wrote:
>
>
> On 2026/6/2 10:15, Barry Song wrote:
> > On Mon, Jun 1, 2026 at 9:46 AM wangtao <tao.wangtao@honor.com> wrote:
> > [...]
> > >
> > > You said discussion was welcome, yet when someone offered even a
> > > small comment, you refused to continue the discussion.
> > >
> > > If I had known you would be this inconsistent, I would not have
> > > replied to you in the first place.
> > >
> > > This will be my last reply to you. I will not respond again.
> > >
> >
> > Hi Tao,
> >
> > Please don't walk away from the linux-mm community. I read your
> > patchset and found it quite valuable. It not only reduces memory
> > overhead, but also eliminates rmap costs for exclusive folios.
> >
> > Since I'm not very confident discussing technical topics in English,
> > I wrote a blog post in Chinese about your patchset:
> >
> > https://mp.weixin.qq.com/s/k00tzhTl8HbL3k4G6ev4SA
> >
> > I have to admit that I found the implementation quite complex and
> > in need of significant improvement. However, I think the underlying
> > idea is very interesting and worth exploring further.
> >
> > I'm looking forward to seeing a v2 RFC with a cleaner and simpler
> > implementation while preserving the core concept.
> >
> > Regardless of whether it ultimately gets merged, I hope the discussion
> > can continue.
>
> Same here :)
>
> Tao, please don't let this thread get you down. No first RFC is
> perfect, and the idea still looks worth discussing :)
>
> Thanks for working on this!

Guys, this isn't helpful.

We aren't extending anon_vma, and I am working on replacing it, that's the
bottom line.

I have presented compelling evidence suggesting this is AI generated. In
response I got more AI-generated nonsense. There's no trust, the code and
analysis are all wrong, end of discussion.

>
> Cheers, Lance
>

Thanks, Lorenzo

P.S. maintainership is utterly thankless, and I don't really expect much in
return, but honestly reading this, given the case I've made here, was
really quite disappointing.

