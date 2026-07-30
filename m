Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0FB9C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 17:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7768E6B008C; Thu, 30 Jul 2026 13:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74DB06B0092; Thu, 30 Jul 2026 13:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663836B0093; Thu, 30 Jul 2026 13:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF996B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:40:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3490120205
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:40:47 +0000 (UTC)
X-FDA: 85046158134.07.B31E325
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id E658C20006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:40:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="QFxlq/pC";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of fvdl@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785433245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLMCRr3YVakAFIrgmUPrhARsAro1zufop+cwIiHnKcQ=;
	b=x/8N+6tR6uQOXLElFH1jsx2pikZ7VS7X0Rvuqcrt4vUvD6S7b+ouF0OtmItRZqg0ErRE2T
	TPY8pPjs9TYte2PRzBH9rnDax5UBG66aakBd1fOLTGtRzJelRPGk6zQqbi9DCMn1NKy/b+
	kWULWNeimPmx37v+urVky+UJO451flM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="QFxlq/pC";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of fvdl@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785433245;
	b=6G17QU3zM9graHxH+rSNc6OsH2pHncK9be0wTFyMVQa7e7Eb5lIg9AJ2EFHgkVGZ51SYQA
	LtSUB2dX9Ox+rcoJoYIkr9vxnqHKW/yh/j9vABPS8nDR6JDut2dcTWd/tl/hCBLKwXZ1l5
	TH1Gcsp5wZd7nUP6S/zLaKob1a944lU=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-495509b08ebso5145e9.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:40:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785433244; cv=none;
        d=google.com; s=arc-20260327;
        b=FwxmNEjIOyP5/0EcR8+juuuAUxgWeIaBmNZJyfLN00XVxBB8885Krd4oR3f3HE6u4k
         wE2ACO6BVEjMxfaAeis6PRLIRwiFdoLXwB3ALEPtlzRuTeja9Lrw3QyHxiMoMgq43JVt
         swTDsR1qtLc/vcruCN3Ed2A14vuY8kfXvoI1jpbO6hk2z1KCToS156141DY+Fpl2oPm/
         tPj4w+yXg5pAhHxKXn+6NMWmJTp5u1VyDzxywqme6CCHCieZK1HS5lT2vi5l7dbE6TjE
         GUeNU2nyNFw+/oQohQpqJxaBIcCfhCEreJdiwyY7tMmgVqRUmZxV5mENBDmdVwew81IU
         WLIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XLMCRr3YVakAFIrgmUPrhARsAro1zufop+cwIiHnKcQ=;
        fh=hKGHIzkjVrHr0WGLQH8drfNdeHw39aIHx8NR3mbnpvE=;
        b=Knf/fuBxV1mLe4odvEMekUKkHlk/mLiXV7wkuENq3TIpdNZLS8o44fcHlTloc9RJtu
         3d/YWsuvovsDOuAej7OPQ0TRhv0lBMf6jrkCFYwJFCIIa6ID5/yWvZPD4Y/zLzmgZVjX
         PJohh4yIaR7ENTE74a5c0ccaD1mLtQ5owlTb8ZlPk9lEH9X9APfBqAb4NoLQTr03/+Yi
         7gLeY0GYx6Il97v5gwC2xi1w5VYUCQ+QakuUB+C8sRbsCim9H2tXDQTR0Y+EpYHiYn7j
         Sozf5HlaiqiUyR5Jn+Ccorny4TRAThLqSmdsYW2BBt7qUmvPgw8La3CwOe5ALkmmlkH0
         4W+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785433244; x=1786038044; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XLMCRr3YVakAFIrgmUPrhARsAro1zufop+cwIiHnKcQ=;
        b=QFxlq/pCw1zqU7eh2z3SKDIPG4iLUu3kXNRJpxg/URia28PXHFjZK8C9Saz4ROoqF4
         GsiASHEgNk5CpVL7AL7xHW9+stdQEchokhZShBC5hHU/S0yYXO6T0elggBDEY5vl2xJH
         kn3OKr6xyS8S3zlP5I4L3AWRtF+NpAphANQgDNQBtdE7MZPfywZ8JavE5tkoMOoxwyjH
         a+71lR6OaM4TBezQ8xRVJjOrkTiJnwMn9EAcRvR7cxJHHtKtwhFBBGaoclMgFgabPvuT
         r+m5Ta/tezevihFd+qfLgD0xWa+B2R8Y6QwlMB1nkNzo99Ygaz0Uyg6cxKM6gwZQV5dz
         r/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785433244; x=1786038044;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XLMCRr3YVakAFIrgmUPrhARsAro1zufop+cwIiHnKcQ=;
        b=Tm6gMLntuicSqnBYAItVk7tNoqWBZ7qYRPYoiwcxbCdL8TYnadAkDlQCzKj1Ah7Ptm
         uFweSHNpGu21nd3u08EUSdzWKbrHe+da8C/GlBF1kCJw3THJLFp9cspGbS9+QC91C04n
         KhkrKmmhHi2+jQghxFry0tIiVriH8caXz06ZHe5JSOjGFyIKxTjrRuFgjkU0fyNPe8jh
         rQS5SYtmkyRfXWSSuZEbpT736DYSG+mgKKB8TzD7mRzo6tia8mrQOFuErYMDkgoYdL29
         hnBzqcmJ+QluLE0tkJUc2+79SZkpnfWxI4823Xun0ZVmYR3+/c/2NeduTU5MXTHA5gzu
         CljQ==
X-Forwarded-Encrypted: i=1; AHgh+RreRjWhDelZNNNdxIkTukxw0Dh6WrTqnIhP/+FnrWuOsEZ5mRW06R0x9jSER6Up1Lp/lkvC5FVhEw==@kvack.org
X-Gm-Message-State: AOJu0YxLecdDkGeBn9ZbUkYDXlx7+v4uCktighhNJlykO3OKkzFMD+Gz
	VK/H1St2kzKQgkzXe10j870e1S8Kzy6AYJgQtvtb9P5haITU/9/3pJRr8a5yXx/OZpiSgvZb0Q+
	sj+tuQZ3QVbnF1P6+qKrBJC0grNfQlObFWYbAqRY8
X-Gm-Gg: AR+sD13aEqyj0sK43b4Ik+S5DfzHA4CZhUJKW5TfRa/rVMca+DNLih4IKcQ6CIvYB5t
	KM2j1z/TvxwZUnY/YhZkvPWvO3wIfQk8Fm01pwhqL+rrKA+Si6k251FLat3lICyohEULtebhkDP
	g+D6U80JtUuFVRPUwCJAdzMG8jK7gJnig9w8jWFOi+pTOfjJkE1g7fQu9tYxY9qFBvY0+D18dkX
	pjnDYHoWCjW8Z/JReGtzh+Z1qlBEqjDQSWF4qUKvpyM1NWHZcia0IjXB7Gt4Mlj3IbVjoWM2HFL
	pYRQL0OeOr2+ZdoXS6nnTtoODZBLfy9FKhLXz4hp3u4E
X-Received: by 2002:a05:600d:848c:20b0:490:ab15:b9e8 with SMTP id
 5b1f17b1804b1-4980587baa9mr47795e9.2.1785433244036; Thu, 30 Jul 2026 10:40:44
 -0700 (PDT)
MIME-Version: 1.0
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com> <amuJbBrTW9W6_sx8@gourry-fedora-PF4VCD3F>
In-Reply-To: <amuJbBrTW9W6_sx8@gourry-fedora-PF4VCD3F>
From: Frank van der Linden <fvdl@google.com>
Date: Thu, 30 Jul 2026 10:40:32 -0700
X-Gm-Features: AUfX_mzF-rbdWdA029msHQErAvjm1m5KqVtwi7O3MQR1mBpjRQR1Wfxbg8w05fM
Message-ID: <CAPTztWatWbsF4KQwD-_nib-vrZ6uvrhMYcOc1mkWu-7DzN95AQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/3] Demote to lower tier using non-temporal stores
To: Gregory Price <gourry@gourry.net>
Cc: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
	Jonathan Cameron <jic23@kernel.org>, Raghavendra K T <rkodsara@amd.com>, 
	"Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, Wei Xu <weixugc@google.com>, 
	Xuezheng Chu <xuezhengchu@huawei.com>, Yiannis Nikolakopoulos <yiannis@zptcorp.com>, dimitrios@palyvos.net, 
	Ryan Roberts <ryan.roberts@arm.com>, Huan Nguyen <nhuhuan@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, Alirad Malek <alirad.malek@zptcorp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E658C20006
X-Rspamd-Server: rspam01
X-Stat-Signature: 8wr4s3h9p5qxk9kxbxfujeywcye9w8cg
X-HE-Tag: 1785433245-346268
X-HE-Meta: U2FsdGVkX18oz5uBaIrIsrptHb9U7cKVMV/mhljdRW8KITXXPVODTIeqco8zdfZnnAIBJIlGsvanbS5LJ61OyppNSM+mTFhI4y/zp48fU2QagNN0qjGRc9fRpWvwTANXh9yfEA9WT7j/Z1/JZpk5aThMJKHEsUlqqEqdlb6xH7JccAsh1hhukpXPHhaIUYwrUZYVu8WJeA996Y4whafSrnmk2JA2Nz30UpUlfxt1Cux00tayl/KcToVR4klWGmzpdURL19ZvAb5exOarOPa28dr+vBFK1VuVxrY1R5pdfn51Da00J+hyJa2bJWGkUyZ9fdBwQriO0HO64s9WFrgHFGUfMWPqYS7VFqmUTXLmpPV8F3S9R6v4hcB4MA7REpmLI5ZUqTX4T1F6em7y+4qFmnhOymVn0bDTaUirj7zgdYD1G40TvDXNDvJJpuFjjWZF4TFr/1+GM10rOk31Lg/crU0W7iAkLJpIWfuHHQqls/TXt+0t1OhXOvnYaN0m/wGaTn76SJ2zGFpUovex0zkDD0FN33t4Poc7+1xToDrDUoUKHrMKtWvGt6X3sVsaWl4jZAW3S725dqlfO4/kKT9roQkZeCJF2SB5YuRUOrRRBxzru+ZM5zEfCZqm6F9mXYVuFNqWco8bFGx2GhM4zGE29F09NwR7CN+LOsmFpOznQd/njuIvrjzoWF0Rxf5ZL2kay/tn5VHq9JCrkscdt0YzHMFo3shpMBevNxFLmnO7qVUAZLKn1iJfd9bb1obU/wSsUl2S00r/qhUfFkJxFsMih+kfjUdOZRTrdzq+m6QES6HqZx8O8VHJHxqPygdGIe7zsIIFD8L1nFhUM2XPcBjbe5Oq3iQR99JMrmmSxjXEjbPZyYxPF04HBhIWPaM2IyLKFMc+yHksn25iFVZhjghiyZBlIlTn0HdjGqiUjkXmXUJU40SA8M7fQ25hrr7y3cRT1xRsPRgsia9Mh76DFzF
 sTMX9YtI
 CKPFocNseIkP3bmfWBr7YGjAyV75r9YWoOOAIACvfNjXAGWQyXORKDxOCY2wrKDzu47dr3N7dC3hzxQIjWgxRFiryAZA7p5SezQDk012FFRLjCkzo+MSq2xCoEgpKujIExCY4KYHZXlWHsR/IRcwmFbZrok0qwKExde+osFlNfo+6xlPf53S5nHlFCPoZznw5K1xx89ue4EHBfZX7MxHTN/f9Ym0RmR4V/YqykzLLrwQiipjKthDEA4qShas/r0fBrnNtvR6s00mUhgMShYLTao0tSC1GSiGR3U5Gse77rYfMlYBOABOi+HQ6W5Dqz+L8Q5dY05ZAaf76PcxTnlQRscS068S2mnGUqXVkFzE+T8STtIZ+AnLSirovew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:30=E2=80=AFAM Gregory Price <gourry@gourry.net> =
wrote:
>
> On Thu, Jul 30, 2026 at 05:02:56PM +0200, Yiannis Nikolakopoulos wrote:
> > In most memory tiering scenarios, the memory to be demoted is expected
> > to be cold and most likely out of the node's last-level cache (as well
> > as target pages in the target node). Using non-temporal stores instead
> > of a standard memcpy path can reduce the cache pollution in the local
> > node and the bandwidth overhead to the target node. Furthermore, for
> > certain types of CXL devices that support in-line memory compression,
> > the last-level cache eviction patterns can negatively affect the
> > bandwidth of the device. Non-temporal stores can mitigate this.
> >
> > This patch-set introduces a new migrate_mode flag for using non-tempora=
l
> > stores that is used only in the demotion path. Patch 1 adds some helper=
s in
> > x86 and mm to bring non-temporal stores support to a respective folio_c=
opy
> > function. Patch 2 adds the new flag and necessary changes for compatibi=
lity
> > with the existing behavior. Patch 3 uses the new flag for demotions.
> >
> > Experimental data: in a CXL system with 1 memory expander, a microbench=
mark
> > that allocates N=3D64 GB memory in the local node and then triggers dem=
otion
> > using memory.reclaim, shows a practically complete elimination of read
> > traffic on the device, i.e. write traffic is N GB with and without the
> > patch, while read traffic drops from N to almost 0 with the patch.
> >
> > Opens:
> > 1. There is some "duplication" in the x86 tree and a bit in mm. Can we =
do
> >    something better there? As it is now in copy_mc_to_kernel_nt we
> > duplicate the machine check functionality, which if available will over=
ride
> > the non-temporal. We were not sure how to prioritize these two and what=
's
> > the best approach here. Can we completely skip the machine checked for =
this
> > path? Huan Nguyen has some ideas here that we will align for the next
> > version.
> > 2. I am not sure how this should be structured so that it is easily
> > adopted in other architecture trees (e.g. aarch64). We rely on
> > memcpy_flushcache for x86_64 but this does not use non temporal stores
> > in ARM. ARM support is currently out of our scope but any input is
> > appreciated.
> >
>
> I'm still a bit confused why using NT Stores needs to be an explicit
> option - rather than the default behavior if NT Store is available.
>
> Lets assume we did this for all ASYNC requests, is there a negative
> effect? A positive effect? Why the new ASYNC type? Is there a
> correctness issue?
>
> ~Gregory

Yes, this is a good discussion to have. I believe that the initial
reason for using a separate mode here was to be non-invasive, e.g.
"don't break anything else".

But why not use non-temporal stores for everything? I don't know. I
suppose one argument might be that if you know that the destination
will be used immediately, NT stores might be a slight performance hit.

arm64 already seems to use stores with NT hints by default.

In general, though, I agree that for ASYNC requests, just always using
NT seems fine.

Maybe the mode and reason should be folded in to one variable, so
that, further down the stack, a decision can be made as to what type
of copy to use? E.g. if the mode is !MIGRATE_ASYNC and the reason is
MR_DEMOTION, then non-temporal is still a good choice. If the mode is
MIGRATE_ASYNC, NT is still a good idea. If you wanted to get fancy,
any mode with folio_test_waiters(folio) =3D=3D true should not use NT,
since a task is waiting to use the data, so caching it is better.
Maybe that's overthinking it.

- Frank

