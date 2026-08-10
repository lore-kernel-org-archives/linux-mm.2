Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7C3BC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FD596B0093; Mon, 10 Aug 2026 12:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AE806B0095; Mon, 10 Aug 2026 12:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74EC96B0096; Mon, 10 Aug 2026 12:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48EF26B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:24:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5DF61601ED
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:24:38 +0000 (UTC)
X-FDA: 85085883036.29.31B4621
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id E2DA4180011
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:24:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ey5qJBQt;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786379076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnpU+yjthofc0zpgkM1QSjOc8GqltDckB0JeUB3rUkg=;
	b=nGfBUL53+GPpDJmCT4Ykud7a1wll4MIPksMZOXOvTRJwQAVUP9ZzEkKzQT8U+11x/YQhEi
	xBVN8qfKwPpE+oBpl2ufIFlhf2ads/0yDVzlE1ws7ehQTmmaq+lAjj7NGCHBMHW/67md1T
	lBYBzMAmo7aA7P3hpy72/v0EUGwcXno=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786379076;
	b=ED74L59S3K1G8fHMEKasSroSUjaxES93kUeHJzue30muYkhatuogT7oSTbYnXBR0uxjPUv
	wJetARR6C6NpWMtlWpDwL9wx3T8Lb3ayNahY/ESibSKUtBNgCHpZwoXe53zODehKy9u/lD
	DVQnc3LmfyCzL+R/ECAViNXzGnYl+i8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ey5qJBQt;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c10e86e52so428791cf.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:24:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786379076; cv=none;
        d=google.com; s=arc-20260327;
        b=T72UqMhJiDyQjrOYvZR/x1W60UBeHpvmz3tXTS00WsL31oPU/Gw2N95PvOYJ+XVeCs
         Tlwcz8AolaoQTkB0Ggbg8wkyeQo69HIBTW0Pd0etwuxl6VTOnBajjETzuu8+ddPXW8XW
         Yxba6nAiJjc0QMh9Ug91lGUeWTzA29NR/XVpwQoltqtsLqqvszL22OxPJJf9IpLinQNu
         I8zHz8TBeL+WAfUsdiNvZ68kCGtwEi9yID+YtCWwYTgUia4XfvroPY3lkKnuNoJF1dCY
         ifI/iGfT+37bzMwBd+KAVdetqYHso6CSdNuFTRtk38c9BsgzIne3Pus8f3ElIa2eKcUg
         nKJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JnpU+yjthofc0zpgkM1QSjOc8GqltDckB0JeUB3rUkg=;
        fh=TortwQSZfeAgskKqGUMMC6Agr4JSZbgndP4WFPy4zkA=;
        b=cWOWpQQg0rtnpi2t2AeWG+NQYKImojxpbMdH2SRKsjTR0QN/XfhJEH2kkMssFBtLmS
         S/KuBKl1AEcNXnFU/W9GZWAD0SX8L3rvW/vGhX/88HlEfzWGPARIJIx9dUq3U4xPJduQ
         u3/yB1DQ3GNAWHZcVOVF4FFCIEeYKIQ9to/CYkITmWxRK43a9MWKYAqGiM7hcpc++1H1
         s/WVzSHGn4+0cy6YGGF3oQe6T26k/aB7R+/xRHk8Y5p93A8T3ZDpbQLTtS0FPopmAMyd
         YPwcK2pegqsJdXwXOrftZICy+CJI5KAXmV9uCdmsZSzpBTdNmL10TRE1ejLGIqqznOUy
         1Xzg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786379076; x=1786983876; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JnpU+yjthofc0zpgkM1QSjOc8GqltDckB0JeUB3rUkg=;
        b=Ey5qJBQtd/tpTkneD9jCmMxE/ubcwbKzRBpJiwgz3t4lF941ZEgqGFjPr6Z6I2YTyg
         4SISAS5E6nCy2Wnab4tAfru/TuHXEGm+To+fAgvfddKu4Vo90StyaTpbY/KKUY1Y84F0
         YyRWhXWEAnpcVgoBYV5RH0NprMsjBC74tJmVwIVI6Tmw7KZRKLbGKRBMZmR45WFHxpnl
         oTTm9sSMKcBI7aLDLsV2vwuCYy05QiQIkpTTnxvTrVymX3srw7I+Li18wSuvTqQUz/xf
         D/71Zuj4OoPFuj8cxCF+dyEHCXYm11IUkN0gVNETJIjmCyVwkiP+LyIUuoW4XuwEXuye
         7bqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786379076; x=1786983876;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JnpU+yjthofc0zpgkM1QSjOc8GqltDckB0JeUB3rUkg=;
        b=krO9KcjrohPJeUSZOV9fkRMjkyaVTogyAF+GdY4bDHiuTN/SEmrjykrpebs0zh/0Is
         AWECXnzOI/ye+LHabCcuRPKjSKKajfoAqqVBy+uOwGtTBAV9Q3RaXTFDqDDIsQ4RC1EL
         VvLI9C/I29f0UTd1uNcyci1+PMVPiUB6VQng5+xqZ0+NlyQF7y8VONluLYz0W5MTIrHZ
         1dRg5FnlV9QSzhiQBBjJXT6qSHFSyzj4g/jim6mxpePfSY8ZmcUt9RRkHC7Wvhuao6Q2
         o/Cbmqm3rrP/PqVMu9wWJBhN2m9KsdK1VIqhnLmrbaXPFcohtso0TX+81wGygUYwS0ET
         Q1uw==
X-Forwarded-Encrypted: i=1; AHgh+RpkT1v4pe4sHiPFSXKf99lILSJ35JlII6tdiwi6LU51avbdYNhrPpEW+Lnk1prjsfS4Tt6Ak0kKRg==@kvack.org
X-Gm-Message-State: AOJu0Yy5RMQ1+isVxNMA6+CFinPEnwnDMHctW+KwWCiecUpYxEVEMHXV
	J6SHEoEXFFSUWyYL9YXvpdROHeSjeRCXRkXCUxoAmxQxoAsLmGBWy4W5sgS1hCkZv+gIQf7WDqd
	oax88HjoXz8ZVRkaFOGo5eEkFgvgWhSztGqOn3i7y
X-Gm-Gg: AR+sD12z0RUKXHVCIMSmEhSTdVWH8YguXW4g7xuP7ttZZAYt24PbkrAqaBMZB9hAhj/
	abiBfnEuhriU0c0mLprK+XyIG1YPKkmbqrCnBOfK2v9auwtZU064ui1SxTI4G305K/97uYEMvS1
	NMBmukhgPguM4dUEFXLw0LSU+wUYzVj70S3GXodC2Fu2EyTDSHOBhUSI9vvyDxZhNDazoEW23r9
	CeGoJy02rkJheKrsCFu6x16rhiwc4v8i4ggj4H/8JZriDe98bVWaGYr6gqJJy1M+oJgqbaFgpOw
	UvmKZsundX5L4BnZsCX76hQvZXrWmWGGnTJ4HSz1lDkS55CS/vyG+A==
X-Received: by 2002:a05:622a:2b0a:b0:519:b655:235 with SMTP id
 d75a77b69052e-52d2810222bmr38915311cf.3.1786379075203; Mon, 10 Aug 2026
 09:24:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-1-ab318a350404@kernel.org>
 <CAJuCfpFAA1H2pOi6EOarNtrdzLQDJyhm6QOGsfZ4SFTuM5eiLQ@mail.gmail.com> <anmLnvWAyIJwjsXj@lucifer>
In-Reply-To: <anmLnvWAyIJwjsXj@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 10 Aug 2026 09:24:23 -0700
X-Gm-Features: AUfX_mykce6fbL166nHsURFiLv_kMzKY9gOukzdEiVHYnjVKW8Vop-MtXqL00bE
Message-ID: <CAJuCfpGJuf3NOuPg4+7TaWhNOv5sN7WEY2awZOpDv1VV13J-DQ@mail.gmail.com>
Subject: Re: [PATCH v4 01/20] mm/vma: introduce VMA anon page offset field and
 add helpers
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Boris Brezillon <boris.brezillon@collabora.com>, 
	Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
	linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: i3njonoatzbcoz7oexy1qpimmxhpm1hh
X-Rspamd-Queue-Id: E2DA4180011
X-HE-Tag: 1786379076-404399
X-HE-Meta: U2FsdGVkX1+nFJPBRHgn+lCNSitzPUURj/7y3n3Bt7SGQzZ+w1MpVLi983zrdYjDSu4/YUuKCqJzSEm3wZWHtatKwbqUvOCBoMGgule5NKJkQPqUWEPTHB4TAHFRee9HTdNtP1rwmdHX+siwSJm5kaTgEQ+NDwwy1QgqXotfeaWopec8XjKmFFWo+2T2Fzz0+6ktW86BnEdM8gE4BVA6tY5itlLK3u9z0Zwsg1cJl5k/lG6CQ1W7JMH4I+CgkMypUMdKhKx7UETFoKu/56eElqErmRJ66YXXRKDmvRYNLsqNvUty8xqbKkLNvIdjS/EQ34h1iKbSYVZ/9JnrB+5qShXAY3FRe8nY6hRWAbBu02+0h0+CGHXqUcxF6QYu3xr+Q5RV70rsvHIWkhwiO8yRz128T7XvT0SyEgWC1HwBa2mQQjPQme3ONo+QpbTnlfGcdTlCQVOLjKGU5qwli/a1DOFuy4TF2TMwC1ZJGoEQTcCRtF9UOQ6p9VAdlAssmgmC+8EWumlHsI38r3Inq+y25WQwJ9E9LpoNZ9P7h66IGx4eU9KzQUkOCibJEeNjrPuk5rJrFHGSm2IVaqECPLlhyqhtovmuFAkEkfdYLxsayzMckOIdfGlPOVTp7ZwWueCgACG9mUASYRwNX3pLgKjwjF7O6m4K9EuTJJ1yJRCeML3q479f909l2+5cI+vbzYaPQmVYLwhU6P2lzlpwha0bA0LDQ/mTGiW/RrLXD+C0ME8cFSnMIzAS85Aeqj7yNqBwFNyQ0aezY14LMQf/59obZAaEzk3bSoemjobq4S2+pHvBnc2rO4tac1GjYh20N4bCFqv38OQWdifsUXyECRRUEB1w0WWuJjSuNtqj9WJCGbgwpUXgQHxQswV4WWTos021lWwFNzjCcmsgnPApicTLezGv1l8rddfQvdB9kj0KEVk2nTpvLJg/78vwlpZkGCBfkQuAgcEkEXzM6JETMNJ
 Ue6w/Tzp
 XS/3lSPhBK+wnIEkulQl3lgpGtici3YM6WSa3QNLQ916uffFnyPfZMfEzJl4gn6JNhuzPyGxWP0X3d2ukku5LJACYS8UREow/FWkeqW9p3KJhQtUwZ0Gx5XUNaAU2Pu5g3OEMpuluLOBWA6ma+Z0vgTZmCLc+HfWZnpXH77VUamjUKcYOAdRSZZNjxjwkDeYXm1upBfs3mPI6MpTcrpMJW6hJUnRkwmxy+q/0PWH/H14+QHScMYRduXsOnFcMETu6Hiprpy6r8DlR4R9PfojKLGOuNq1ghi+BmBGIM1g5EH9xWiekGXVsg7xUrSS8uvQlTJRSBH53izC1Iw01bPY/bL+wxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 1:36=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Sat, Aug 08, 2026 at 05:51:10PM -0700, Suren Baghdasaryan wrote:
> > On Thu, Aug 6, 2026 at 1:22=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kerne=
l.org> wrote:
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 87feaa5a2b78..df78847f5f07 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -4393,6 +4393,65 @@ static inline pgoff_t vma_last_pgoff(const str=
uct vm_area_struct *vma)
> > >         return vma_end_pgoff(vma) - 1;
> > >  }
> > >
> > > +/**
> > > + * vma_start_anon_pgoff() - Get the anonymous page offset of the sta=
rt of @vma
> > > + * @vma: The VMA whose anonymous page offset is required.
> > > + *
> > > + * If unfaulted, then this is vma->vm_start >> PAGE_SHIFT, if faulte=
d then the
> > > + * anonymous page offset at the time of first fault.
> > > + *
> > > + * If the VMA is anonymous, this returns the same value as vma_start=
_pgoff().
> > > + *
> > > + * This value is used for tracking MAP_PRIVATE file-backed mappings =
by their
> > > + * anonymous page offset.
> >
> > I assume this function should not be used with shared file-backed
> > mappings, right? If so, maybe add a comment like the one you have for
> > linear_anon_page_index(): "It is not valid to call this function for
> > shared file-backed mappings."?
>
> No that's not the case, it is valid to access this for any VMA though it'=
s only
> meaningful for MAP_PRIVATE and anonymous VMAs (though in the latter case =
pgoff
> =3D=3D anon pgoff).
>
> The code keeps the anon pgoff values consistent even for shared mappings =
because
> - hey - we have the field anyway and it's easiest and safest to just keep=
 it the
> same.
>
> One alternative would be to have code that checks the flags and zeroes th=
e field
> otherwise , but then you have problems like - early on initialisation now
> there's an ordering requirement which can easily go wrong.
>
> Another alternative is to just leave it stale, but then that seems object=
ively
> worse and again requires branching code on update and set.
>
> All-in-all it's easier to keep this working the same for any type of mapp=
ing,
> it's just useless to do anything with the anon pgoff for a shared mapping=
 :)

Makes sense. Thanks for the explanation!

>
> --
> Cheers, Lorenzo

