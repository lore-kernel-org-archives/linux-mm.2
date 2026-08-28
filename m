Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1578C61DC6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 08:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92BA6B0088; Fri, 28 Aug 2026 04:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A436E6B008A; Fri, 28 Aug 2026 04:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 931F56B008C; Fri, 28 Aug 2026 04:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5716B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:57:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4E001C14D4
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:57:34 +0000 (UTC)
X-FDA: 85150074828.22.371D624
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 24DA3120004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:57:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qdaYRwSy;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787907453;
	b=uj7m3Rp0ZI8Bzc+PtykIxValCE/HwZtdrg39MIZk0PouMBNZOyOGjvB45OrFLcH01Q4XgB
	TfeEXRLz6jU77RolPoxmtWH5H8vVkx4OLUD/VW0JU1UVr2IU5+UyAgSLdAWdX+3jQDkGjf
	jOh2BLC/RIWskiqsyWGFeK6pG6xPg+g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787907453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRHnAqVdyLXqgRdMi4x9m/HrY0C+uMDxYAPAdjQk/dM=;
	b=0DmL/E34BroqZ9UGRlswBQ5L9L9MxWR0n6e8d3l8T6CGVvGx9mPHoKbbSzGu5jSVu9ZXM/
	yGiV5dYU5N5fcciDrN/XjCIT7aPKWjn2TvwtVtJrhl2qd4erQiE7YOWB6dhjJz3Rut/+Ev
	NEN+EUXlgtM1NtD3HCUfCCVTZ2uxMeU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qdaYRwSy;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-85aeb506b78so8575687b3.3
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787907452; x=1788512252; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hRHnAqVdyLXqgRdMi4x9m/HrY0C+uMDxYAPAdjQk/dM=;
        b=qdaYRwSy8/gN1Us2SyuXhNp3K0ZKXcemkwqeqPfbjdQMnCBBWBnRI6efwcvjCL1jjE
         98kDEj/XtNvik9436iV1OFp19yo8BCw7cgzTdNnFri+ebPIDJ9WKqYd5tUW4SMsCb0pl
         17Y6mWeaIgLnV9/LuX+9YwzzbMk1ZNBUO66uaMs0owZic2xmEYAh5gY3rDfdvZT0Iiau
         PdI9xmvFsQue7gJuinq84zIu8A+jaJAxkwu05cWge6z5kYeYXS932itHqc9j1IGOLeN3
         G8dq5EB2LfSqgyuANENECtxlfDYtckTJJPMy7f6eYKGt2+eT46+JPcRGd36LZF2c42KJ
         ujYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787907452; x=1788512252;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hRHnAqVdyLXqgRdMi4x9m/HrY0C+uMDxYAPAdjQk/dM=;
        b=EGmcrRJhie6v62elZm+S0mMgoX1XXwAKllqCaEqV4Xbz/ol+d8L6HTzYoVZALhVZt9
         FPSU/rWi43KbddZNQeVZQ3iDpDf9Hce0DDr7KqrfMqaaB4s1HyO4kZ7LQDw5PepRbNC5
         Jpz+Id6ZmrbBbrdyAtrmMh7jHx7QjsTcD3pZ2mDg/E2+2GZGVSnWhvNKCquVHe+BxeUj
         WLRh1j4vI1b1oa57G16XoDjFnWlIIcYSoMtplR38SJqNF4KKDyK65LIzc1qW41ClJAJQ
         ZuVO+N+Eix2V58eii4UC6uemKF1LuzlAlOZzd2rrtxSO0n4q8TTMwBYUFCXg1wKE4WgH
         2CJA==
X-Forwarded-Encrypted: i=1; AHgh+RqFtq+nn2X1zqtXt2GsrA1DHsy903DOeYQpaIt68yVhX0PhFwbtoj0sfHwz8bPOootB9dB5fd/74Q==@kvack.org
X-Gm-Message-State: AFuF++nY6fNOdb9zpplsgnf6n6nv3+cZ53W02BRekEiGdDCp+LDwN7D1
	gftLk+ONiaCcjrZedPDDuV++FGdL45Zsu6jif+Om1z6qVcbzkFCgffEXxntWSK2T9w==
X-Gm-Gg: AR+sD13pSLC5nhI5r4m1mGdkrCBmQSDLVEPsshOXLpmgy7EBf9Cg++68NBnfpSfpVdH
	AJjrJFxPaMmh+xSA6hKkfe5UKuynLJuJn/XGGwgf0hmQoDChTeU6r4A8r72hc41SU0eBWmmb0o7
	RvQFFV1Ua5ZdURB1FTpRJARyyo0RgWyhcF/0n0jUenixQKGtQo8wY2OTs99jkyLhAZ0wvlfi7c4
	WSCqZThVwCUekdu+f1kEohUtrTcWv4I8PkL/Gn1RUWs/HhGr413V/hBgVymEPNB9OAQ2uIlOqj9
	CinY23PzfsOE+m9IBModYX0H0YI24yFwkmZZQS3YNerdo+Hx34SZJi2UNf4aexuU+2QZzF0lwU4
	fGtqcf8kmNGyiXZ1MRcyS1tyIj1pj25xqpre8V60NCOS4XBDmSGrpELZe/HCs8iEp5cFjFasUst
	gnZ4hSZf2mgYc/wgvJku6JITCydm/tEVdxlZWTD1gVWQfp8cibg56mjAv3IkTjpLrCktETDcFWf
	BWnTT6bk4RhyQr+uAkd45M4GxqIyeVQiIPizWV5TctuI+07
X-Received: by 2002:a53:cb90:0:b0:66c:c8f1:7623 with SMTP id 956f58d0204a3-66e4c6ce6bbmr1380164d50.27.1787907451455;
        Fri, 28 Aug 2026 01:57:31 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85e5ed1cd5bsm3672297b3.17.2026.08.28.01.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 01:57:30 -0700 (PDT)
Date: Fri, 28 Aug 2026 01:57:25 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, David Hildenbrand <david@kernel.org>, 
    JP Kobryn <jp.kobryn@linux.dev>, Jan Kara <jack@suse.cz>, 
    Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
    Kairui Song <ryncsn@gmail.com>, Kiryl Shutsemau <kas@kernel.org>, 
    Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>, 
    Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 20/25] s390/fbatch: no lru_add_drain_all() in
 s390_wiggle_split_folio()
In-Reply-To: <20260827145502.2fb4505b@p-imbrenda>
Message-ID: <cdbaa4ff-d2b3-34bf-dd41-01fdc65edebe@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com> <7bf68e7b-f88c-6ca9-39ab-e9fedab0c8be@google.com> <20260826155722.0198d3ce@p-imbrenda> <2319f670-fe0b-f032-c0dc-486cbec0f3e1@google.com> <20260827145502.2fb4505b@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 24DA3120004
X-Stat-Signature: eu1a67xdyhshee97r76atzcnotg8kwmq
X-HE-Tag: 1787907452-912054
X-HE-Meta: U2FsdGVkX18+nRtbuuVuIQnmM21ZWrUf2CpYULpuB+x015HMcQzwJfvyim6Pm1oJMmzceOJUroLwli/R+OpDVdsqNax+Ycfg0/3o5zkQb8wds7fzPzFFWE0d35eyAKLfOZWdmqltQx8WJyQAsV++CNkznZTGSHjfs4pYVmmEIPPIPbgruFM/rsTn3jSq55al/fRdu8Coxlkfe9S9rfWdkpsWdMDFLAPTWIFUHz9ChPfzZ+DO7L9/cp2pAP0ZVEeV5daD+PnllvW5nrthvIL0mLCz2EmeiHPEMqZ5RvedpYV2H6NB0OIXXLOWx3/0GPFUlbM463oh2vf54gPVWYWxc/6MF0AU8wHT/h03Bce+0Hb4yXPVU8ADeTCjya8VKap4VLxWW/GsZvc7K2WHhFCyQQkIblOxLm4L+NVNLqwE9NryyOlN03mP19ED4pi4FYMIA7MJFdxZduM33m+mv+V5XbetQ8WD1ZCaveXIrlLO8xWTQuxonwu2LDGmr+Dy3zG1OWwG3nJT74KRprE/5ryMJp68Yiz8D+NAJvRPni2c35KkwFfnYzqpZotpynvqF8XCJG3HfJa+g11X+YemiA0LLfuGYHV0zosIFri/4L7TxCKMVFPLCYQFt1voMqji+eL9zAS8fhXLFtlLKL+Zxk1/7Dhs/ez449mKF+vPaGp4b75P49xo/OFc7DGWkpwig1ZsW2AkR9JM11DgqMH25x4KwRoeVYUSbI22FeVxqRnjVDCZVUc4QAm8We6WsVpb2+/XTHZXWcdnDOjBX5wMQ+bkBJy4Y3ljXIKv5YAD6VeQ8eMIvrHljPKpnp1x2DVaki8ZboiHYnCfsfNg41ii78NbN537dP6rRosA3fgLs0X/O9XapVoO4vvuyw2QLqxuYNPGwo/eNk7BYVtYs+F6GtkgWbBjYQR26EMKV4Ph/j8XuxJ2q7wG6SolHbVm6YcZzKPy97j75Tq+liTN+PfdGGw
 r8iGv6tD
 1wjUGE3pmN6OaAHKw4m0uKbi+8h8dBmXy1mvAdEDCQZBnRD3ioxG/s4RfuGz15Jd2NjrCf/pxkwDwuycG71EeY3kF/e3QzE0OhVJwICLMDPrBxPSkXegPQwp8QKiHm1AX0mhgiA17rpwdSWzDtiwSdJbaat2UTvjGBXC5zo8FM4LC2x1yQL1ed7nD2nAXHEEIMMS52NPNv+N+u+CO3p7F5X+YqnSXTu8QSqInnKJDTOX+eGg73D5NSU4ppInCnbHCvVDh/YXmuG4zXqJ/j9SA8KOW8C8BYseUZzPduaFgcRuKywoY9yvMwTUZ5prGzFm5mF3cdAdfP6ppBmHLFg6QK5/TqYB8ts13hWqslo2SUizAyqPNJ2tnPwjwxt7dkg34WBjTgOlcAaRWAfrGk+y2xCjh1tZMvP8JJ9i5fb3x0iUVit+RpTGzKNokguTBR9ke0RMN412vjmkUjnk08h+f7GLSH889FnavLOQZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Aug 2026, Claudio Imbrenda wrote:
> On Thu, 27 Aug 2026 01:49:12 -0700 (PDT)
> Hugh Dickins <hughd@google.com> wrote:
...
> > 
> > I most certanly don't know s390 or that code well enough to guarantee
> > you that no stray references to mapped folios can remain there. What I
> > can guarantee is that no references, of the kind which lru_add_drain_all()
> > used to be needed to remove, can exist there: so there will no longer
> > be any point in s390 (or others) calling it for that reason, to help
> > split_folio() to succeed.
> 
> we are not using it to help split_folio() succeed (although that's a
> pleasant side effect). We need it even for small pages, to guarantee
> that no extra reference from LRU is present on the page.

Ah, thanks for explaining, that all makes more sense to me now.
I remember from when working on memfd write sealing years ago, it too
had to be able to account for every page reference before proceeding,
and resorted to lru_add_drain() and lru_add_drain_all() to help -
those now removed in 14/25 of this series.

...
> > If Barry's relaxation goes in before my drainage changes, then
> > there is value in that s390 lru_add_drain_all() in the interim.
> 
> hmmm so, should it stay for now, then?

The s390 lru_add_drain_all() should go whenever the rest of this
series goes in. It's not essential for the callers to be removed
immediately, no correctness requirement; but nicer if we can get
rid of most of them. I'm hoping this patch can just go in along
with the rest via the mm tree - and I'm sure you can trust David
Hildenbrand to understand and protect s390's interests.

> 
> also: I'm working on completely reworking how the transition from
> non-secure to secure is handled, with the explicit goal of getting rid
> of that kludge we are currently using. That will also get rid of the
> lru drain. But it will take some time (I hope to have something by the
> end of the year)

Good luck!
Hugh

