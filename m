Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF102C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 08:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E13FC6B0095; Mon, 10 Aug 2026 04:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9DB06B0096; Mon, 10 Aug 2026 04:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C666D6B0098; Mon, 10 Aug 2026 04:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 999696B0095
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:40:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 361161A06DA
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:40:24 +0000 (UTC)
X-FDA: 85084713168.27.CB494D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7E3A640009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:40:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JKo9vEdD;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786351222;
	b=lURc9C+LPKN0iepyaNLyHU44+a4m263w03tft0R/lKlBZWUA88wxGfs3pR3G2/qJwCKNyT
	8aFPQ72TYNMSzYE8J9comKKwPcBp4vv8mEl3q/AZe0xt38HZkYJPxhXb0hlAHw+OZASMo3
	pGjj7HQJK3NNJDdxXJvaJ9OEZevNj2o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JKo9vEdD;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786351222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqefW5WYGaVGXBp1EcWnADXqL4SSTTp93r2Me4s4EHs=;
	b=WyplLP9p32feiNPbnWCPfgDAD5t0w/+M0NCdhuxV4qUp27jtHoeTaTAfIX+gMantsH4gXF
	F7zcWDZFKEvqf27NYf/jG0Jb5kftsXvzfAtkjFaueVKh4J/Us5DGNSQ2wnV65E7rm42iEM
	lSf0Wp3K5tpt0BcY0TgbnVkQOPXoanE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4949E41776;
	Mon, 10 Aug 2026 08:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B481F000E9;
	Mon, 10 Aug 2026 08:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786351221;
	bh=pqefW5WYGaVGXBp1EcWnADXqL4SSTTp93r2Me4s4EHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JKo9vEdDRY9kEpH19pzoxMjPpB+BwegkZ/hk4gIse31W3/UahgMnQa9xh4JjiQFgo
	 vyAT1sLy2fN77hi3ktVZitRAApigE7usTNwPtrxSB+xZCKedho76MmsOO/kaNwnbCG
	 G3vVVXUDdlBbR1BRn+wmJtYxwXZyV17hCm0IC+Cr7LvHqWPryov+rSycK1U6Sf07Q1
	 a7K8Tx1IL6pcLFaXbOdwrOnccNyiajONZXrnTfr9FsiSjC5tGcxHcAlw+KE9+lCQDw
	 I5B2NwM1a16Nkb4aClNBGjXSL3P4mApb8jLLnQeWlG5EA6ipQr7F/Z059iZBFNYRbF
	 tXXNVEkrpiKjA==
Date: Mon, 10 Aug 2026 09:39:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Steven Price <steven.price@arm.com>, 
	Liviu Dudau <liviu.dudau@arm.com>, Huang Rui <ray.huang@amd.com>, 
	Matthew Auld <matthew.auld@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 03/20] mm: introduce linear_anon_page_index()
Message-ID: <anmNojqwGzdiLkIm@lucifer>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-3-ab318a350404@kernel.org>
 <CAJuCfpGjE66Duhw0r8H0GKBFDExjroRar6n5MgVOOQjz4ZfTuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGjE66Duhw0r8H0GKBFDExjroRar6n5MgVOOQjz4ZfTuA@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7E3A640009
X-Stat-Signature: gi7ge1s6xzqn6ggfxkgi698edgnt16ze
X-Rspam-User: 
X-HE-Tag: 1786351222-487705
X-HE-Meta: U2FsdGVkX19SV3g8JeEe4o4yARitA2968cbCOmBg89XaCWkv36xG0Dh8PvFwAIosH5dOsSQ5HUM9/tyfvASWU6fwpLX9qK6+WxqQRKICEon1CdkHxApdBcW35wi3vtV62eQe4HZ3i1Bp/3LhY8qWdYFW0ZXeeSIwT2ftEeYO/QgcX/dCmdEK0N0nOMnbikSF/ZJzR0ELu7qMoav8kMeMDoqVOU4w/Ztlicn2OlcFoVDT5501IBGD8+qOtgL/RhgECJlFNX4Nb/1dv0JtXaPydsCyD2tzoS23gTVM2L4jpYtMJyVLzW+/PEZhLCWWbzxt+REL6RsHlsiippkkGRu24kxaBDctrvmZR/e8yD29Do4rGCqqr6F2WEwY6GzW2yHDQy+makd53/Kg305DlOLDsNPEvYh4hNzfg8hc5Zqjs2U+wsbTkHd4/QBLi0dMDat57Axvhj1serRF4oit4a1opoUowB9U7AgpKXW3phhogoKoayDpDwwmcBnmI9DqvpBw15adjejSkGLJUgBpuoECNSp1tqitKlSdSd0uN2I2q/4kM8kwm8svS6UMqJGK8iEJYh2V4d/S0QuX7INHzXndBxfV8X6XxmIHOvxVbrvDZFT3lH+DnKYduLulWtapbyLIvLZTDKoMQJ8S/ChZUAzxtxWPuID45G8j5EfcucvvaOfjE8zlUr/jZkkEbhYcI0ZvfEhGk4G82Y9eVDMV2OpzfTfCo+Og+TlAr/fZpxF/0wdFznujA7Wt2zAe0JfmKTB+m9QWtn/CvPV+IGJ3zrNMztIRB0if3ftubsqnaS16wvfcVOgK5l8q12tog4hFMHnw66oHj7tCB0pEizfSoPScnon7V6Cjt887H8N5qfd0CK5ZAZ49uuQ+zZMNjpPLcmxVSE2Wnypr0zHBs1KOs9Nw8t6owMCVFG3QrfPKiGgRbrY3m+HjMGmNfIbZq+5VCzA5ZPWcbqonxJqKnbs+bv6
 xW+clTCV
 sqnV8Y/a7lXj5yxGaLWAZUEIfsR2BA1sJ9Jvs4rC00GEkK2QpTHSTJ8jVuDKAXf0rhsU+wIyo9AIEBSWfWnugfYJW1SKg0+e+f+2THYECM7OmXWTRwifNWUQ8uKKyNquZqBkWoniSB4sTj/MDQe46yRgR0C7KOQa0x0rFo7rtJpqTo4G0koJyAOjDTyGJEvwVXTNNhHkIF+NF9Y0UcDCcK7NbJ9W37z9w4YolJIFSxOtkqyDO9TL5wQiJpfpcccbaAsRXVo8KLr7ubom/aWYnizZGK3iSUH7xDGLWNPzsjuLk7A1AAeXAKm1UWcT3CMERd4LYDMlZ8dEu6xk71VtfmnxHlmeyw4UIIiUNyVqNNlvJxLGmkwJNuk8GNGNk0JcZFu/L/3ejC5j8ihdAyK5ROm4PZlR042VUXs5q16xlKst06Cg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 08, 2026 at 05:49:48PM -0700, Suren Baghdasaryan wrote:
> On Thu, Aug 6, 2026 at 1:23 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > This function provides the anonymous equivalent of linear_page_index(),
> > instead offsetting based on the anonymous page offset of the VMA.
> >
> > It is valid only for anonymous or MAP_PRIVATE file-backed mappings, in
> > other words CoW mappings.
> >
> > For pure anon VMAs, this will be equal to linear_page_index().
> >
> > Assert that both of these invariants are true In linear_anon_page_index()
>
> s/In/in

Ack. I ran these patches through claude several times and it didn't get this ;)
the machines are not taking over just yet...

Andrew - could you change this in-place? Thanks!

> > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > index c6fc783aaee5..0adfa6605653 100644
> > --- a/include/linux/pagemap.h
> > +++ b/include/linux/pagemap.h
> > @@ -1094,10 +1094,44 @@ static inline pgoff_t linear_page_delta(const struct vm_area_struct *vma,
> >  static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
> >                                         const unsigned long address)
> >  {
> > -       pgoff_t pgoff;
> > +       return linear_page_delta(vma, address) + vma_start_pgoff(vma);
> > +}
> > +
> > +static inline pgoff_t __linear_anon_page_index(const struct vm_area_struct *vma,
> > +               const unsigned long address)
> > +{
> > +       return linear_page_delta(vma, address) + vma_start_anon_pgoff(vma);
> > +}
> > +
> > +/**
> > + * linear_anon_page_index() - Determine the absolute anonymous page offset of
> > + * @address within @vma.
> > + * @vma: An anonymous or MAP_PRIVATE file-backed VMA in which @address resides.
> > + * @address: The address whose absolute page offset is required.
> > + *
> > + * This returns the anonymous page offset of @address, which is the page offset
> > + * the address possessed at the time the VMA was first faulted.
> > + *
> > + * For anonymous mappings, this returns the same value as linear_page_index().
> > + *
> > + * For MAP_PRIVATE file-backed mappings, this returns the anonymous page offset
> > + * of @address, which is the page offset the address possessed at the time the
> > + * VMA was first faulted.
> > + *
> > + * It is not valid to call this function for shared file-backed mappings.
> > + *
> > + * Returns: The absolute anonymous page offset of @address within @vma.
> > + */
> > +static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
> > +               const unsigned long address)
> > +{
> > +       const pgoff_t pgoff = __linear_anon_page_index(vma, address);
> > +
> > +       VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
>
> As discussed off the list, this assertion works even for read-only
> anon mappings because, as you said, "there's no such thing as a pure
> anon mapping that is !VMA_MAYWRITE_BIT, there is no way to achieve
> that."
> It took me some time to see that after reading your discussion with
> David at [1] and [2], and I don't think it's very intuitive. Could you
> please add a comment explaining that? Maybe add a comment at
> vma_is_cow_mapping() definition since you are using the same assertion
> in another patch of this series?

Sure will do! It is very confusing stuff (and I was duly confused also at
first).

To save a respin (unless there's more stuff I need to address) I will probably
reply to the relevant patch with a proposed new comment.

>
> [1] https://lore.kernel.org/linux-mm/anBjpdMicqaGADr-@lucifer/
> [2] https://lore.kernel.org/linux-mm/anLyhaI6kW-EWk13@lucifer/

--
Cheers, Lorenzo

