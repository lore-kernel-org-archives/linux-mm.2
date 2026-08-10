Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A274C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1DA06B008C; Mon, 10 Aug 2026 12:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF036B0092; Mon, 10 Aug 2026 12:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBDD46B0095; Mon, 10 Aug 2026 12:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 979D96B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:25:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E95380180
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:25:31 +0000 (UTC)
X-FDA: 85085885262.29.E8F5B5D
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 26A5E180013
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:25:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p6Lcubla;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786379129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQBA7RZMWG8pbHKGdFOSfTUai8Qp0mhMLH3fVjxyT/A=;
	b=xp6aX+eRKnC9qnsWISGDMhKze34O0jhWndn1obwnPMShNUVtzi6I9sJKkih7eTZYBEGOuy
	iz4XNCkjCRBzQKTlqNKlI99Pfl3W3s/XImHV0pCASyvdNjnemo6S882PmwfYfGZeoNseuS
	4fNnsu69JucDEe1N3kI70QoBxSDupeA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786379129;
	b=jnMz9ZUsyOgkgIswjoVwEAgoIVNk0Dm5RrcteDtc/BR14HctQULEdIH70JJcT945BrmeCg
	Qg73t7Rizp7bxQQpx/NNosDGQYFcZ4fT5rBVQcm5b8uASgX7X/FR1wWhU1jsi1WTIkw8/6
	Anc3X3t/WvJK2DXo6N3ZdbDszpq6rhI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p6Lcubla;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c10e86e52so429201cf.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:25:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786379128; cv=none;
        d=google.com; s=arc-20260327;
        b=pPJ6G67IeIlX4vm2+YXGheh0hyej5HomBQxv2wEYvZd2E1iZ+FD1bpQohYiPuFgE0z
         PfmfDLuBADs7oxH8zoB9VTl+Ke3WbsGUBX5twHkesuj65dPZ0GTXh0lDV3cmaEzMAxke
         9GfiDJE5Q049tQeCq7CgVehkDTkWwXqgujM4D+TWa9mu3OrkykAFjdXsLUfg5ycuxP8R
         yFqyvZHmMkRQiL0YiEtAYBEzgG0wh9Na1bMr0ulZyIdgF1+seBxt1j0wC0Hy4fU6X1G+
         3ntpJMwKmIqHS/Me19EsSXUQbTj77CGPNAQpg5rZ6hwh2Sxxz2awRDuIlM8Wld4lS0tn
         ZWlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oQBA7RZMWG8pbHKGdFOSfTUai8Qp0mhMLH3fVjxyT/A=;
        fh=RlqCpUC4GyvQ4Lt9dAtliw0qu+No4U2pE/tHqFGeLzo=;
        b=XrPzrA0l4CNHotDmA51MXBNENd57Puldj3qiBohqqJEbT1fT4qW5RLuwUS1YMEofUV
         LPFdREx9vOsCcKCbZlyZ9jaKAxNEdasiBVHH0El+B4pAAgzPyqGKLdoD+uAYaIFux+rd
         xflJG29fVaNz2K87S0UNrge2SDtZkvH3JAhlguci38ckoNWyn1cOGIr5yx6xdkX3DfHI
         B/PsU5dXWJ9xaVa3XcrXCZM/TrxvyfAO4z2IqOsnHoA3qlComhOx54rxwoMJTTC//X0j
         J97fS9w0LwCB7+QJ0euSEAtl6WJFyxsR1OZTF0V5KwmZyuCo8k27UO3zE+yqBZtN1Jr4
         F7OQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786379128; x=1786983928; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oQBA7RZMWG8pbHKGdFOSfTUai8Qp0mhMLH3fVjxyT/A=;
        b=p6LcublahOXCZEpQYYb0Yt1r9s1Q5CMtEEO73wHP/z1ndsKERuHe7+Mb25uSalO2U2
         ovYc/CdAMcscXFvggiPj9Ztnij08J6TsmUwMO9W0pA+71aYsMaS2N37zSvl6upERPMV7
         riOsHs+NyeU03UtTrTwuZBD8ed7iJ3AqiWT3lZop5/dsH7RaUgiyFv1KtnMR+H43RCp5
         fMBlm2o0iIYzDq5EJK0xlD6jUGzRo8UoA3HahRL0V9LJIcLI5IF8yjVwUvgp1igxB5Tw
         0y4pAdqD92OdLwa+JuIRgkYu7FO/bmU/TDilnTNH61Fsm+0qJMDyf4PhDS9K5nd2EZld
         KD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786379128; x=1786983928;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oQBA7RZMWG8pbHKGdFOSfTUai8Qp0mhMLH3fVjxyT/A=;
        b=nouYFnaAIzIfK/daLGsd06Z/XPsLS//s6HXEimMslNhadaZ7huOvbOgc1tjprATpHP
         kTTj8ogM3BJ4w7YwY+Be7CUoWQGjNUnRuFGeHEszXXsd3oO7tqbxFMW+XbcrouktzkV/
         4g9S6jqbLMAPxTEWWH43KwJTPJOpgtCOB7orW9GMH14cOcktzCm4suoALTnzDecZKv29
         sJpjl+Jq8uIHFabATqasiwVRA86iHG4ReQF8/MPXQJxwh3fdksHUFefUUP71STgP7xGB
         VG969X4CCw1jBL9Kr02abr47AnlQVdTCcfeDjBGB2e7nR2RQjcJ/drD6m71NyoCiIKMu
         CqpA==
X-Forwarded-Encrypted: i=1; AHgh+RrQsF4u0fcLqqYfbaRtZkilCOhUiYDuL4pituPNr7RvQC7DeQ62lG2bjTmphqBxmNfTlL1ftkkQJQ==@kvack.org
X-Gm-Message-State: AOJu0YzBtsdEIc/eC5mUjUnNTKGjHXOxSJI4A8M03W5CeQ/G8QVfH5KN
	xtkg3fh998nJ/ihvrNl308MGiT7Q7bTrrnLRgCj69Cdzx7cPxxHGnqzCUJ1TJqNGfXGVzvvCCxi
	AEh5K0MMIKyaNi2OS9tp19eNfiPtsOU3kVNariyqe
X-Gm-Gg: AR+sD11AdS5ESyjtmBuC2Lx8r3vjoNSzwZZMBUUx3v2V6tBlNh+lR7QvfUUANs3kEE1
	DfwoGDsigFlPtjy7FoJBerjlkMF5fNrh+8iSf7mVlLAaLaziuUXokDcjw+2ZNhBsOrhRmbKHQDi
	2UMVgkq1D2FAkbb/EHg3S3bWqmlZhfdwvkwmqgtNtiJi0Ce0gukC1vE7S2gSPycpEObmW73Gt9k
	ORytE5oA0erldvAcj5tE+zB8urrfls3QiRdnNHIIMg3wUefq7ei/DgXwHISXWsFRsaCurCfcDXp
	/qtoil5YH6oiJ8PQDO81s0aK8xHOetU5x6mL8Lf04UU=
X-Received: by 2002:a05:622a:1b06:b0:516:3f51:81cb with SMTP id
 d75a77b69052e-52d2817b938mr34999921cf.13.1786379127554; Mon, 10 Aug 2026
 09:25:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-3-ab318a350404@kernel.org>
 <CAJuCfpGjE66Duhw0r8H0GKBFDExjroRar6n5MgVOOQjz4ZfTuA@mail.gmail.com> <anmNojqwGzdiLkIm@lucifer>
In-Reply-To: <anmNojqwGzdiLkIm@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 10 Aug 2026 09:25:16 -0700
X-Gm-Features: AUfX_mz9WU1SPgoH6YTV3DTKwNKGMKFcURK6j4M8chTMyTH0jJu5GwZ0wv2wrtI
Message-ID: <CAJuCfpHtaeeqn9UbnG1U0iA8uhrcQpEG8g8+G_RybVbwoOE0sA@mail.gmail.com>
Subject: Re: [PATCH v4 03/20] mm: introduce linear_anon_page_index()
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 26A5E180013
X-Stat-Signature: 163na6r563p5eoxjffugn3n6y78oj4kh
X-Rspam-User: 
X-HE-Tag: 1786379128-595045
X-HE-Meta: U2FsdGVkX1+aUJAUJH6DV2LH4tJ/cgSU2UNsERwM2bWE94X4CeH7iDEE/t3PUivoY5yB0q7R/DJpuR58Vy6sdPrc5xERHRfUNC9Hhod+219X6CjiQOrre8qGFEMb90sVy/f0g/ujyrusVtc1G0OfMBd5F1fsfa3ZzsiMIS4CtQWZZECDcRKOFOK/T9uwfC+6N89Lky/UZrgdVyvZSHJqn7v8MflED0HCBcPJZP166rC9+6ovxNNdX3+Qy2nmOK3QO9aqMy6Erb8PgjqiciNlshqUyIxpC7zQ0MgDR5rXsWtn/+SrGsOckp8XVBxVJkYqQ9CKzkGGEuVLzWe8TMuQYL3m+hM9HnWLSqSb6eHXVoRBmInjxu8bOFynYGoTiZdTmmjUDqDHLedZEnVRFu405EiwAeGYlqhwIOWzVfCDl26neZL7/9TQAmUGV/wCh82yl2wXjF4hibuIlEcItV8NG/WH1rRB6k4upl7ekGvpHELISuDLUg9/KxbeAct9KRhIzMmHUCAFeCjvPXjhBxAKDUoq/9hHhkSSHjFfdUW07D8ca1iVfQwlD03+wN/Yt+GQkKRXJ9HpsyY1Rby4/X3ZQABmM5BeKT1hgxdU+w4sUMq/8oqfKhRF2Ji8DWbyXYfGLAEDZLmh+CL2OQ3ZMqIAqkfNJNe9o/HndRG22ks6iZof6qqQR/DJlSce5BOn1fcrWn10n6jIMQyHPsrQu1/dk3inbzXDGWQCenu/4OUH+8W6gU1YsUyzkeXkob3GtzxN9m4vMiA40gCCR6NRNKOH55R7f/6f1avkZJ1E46YA90AwxXt9bnKd6ypweY1Wo6IQVPFo9PVXqMAdvVzP8zWO0LNuCczm6LAa8Cf+OsTc8vpzm3MVRfcEw6tw/lT373SFW9zFcqEfULBUyq3+u8/vE0XrFH2+3gNG+gFkFP1oP/cbXgqq5oHmbT6mh7LVWugtmCKx/Bm7aRB73PEVScY
 vnW3HKSD
 xB1JzNJjgtIzW+yYwRAmDbwETbQ/RnKSrgdTuGPYuhiHwcl6s8Ip0Ql92y8tcN5qgFTMjRLnVgigPLGnpcuUpNu+szIhOT3KNDB8nKuP4e4fsDI+beMGsTkuTl/bpXPbafwT71PufeDVtQqAc/N8dOiCeVLJisXe2AcqxHbhfJRAntNFjMKX9fftTWRCwFH3Y3YvpyEJ/987089f3glThBHTDemAFG7wewMXmsTdgADzmWv9l4OItjJNshCxl0C/c+t+/h1xZvXVSxEUuUfYpCzjpu2kJumC6LVgnM2NXZRPFuqGZi4KeZp+ePDzohyxxRLKDioRafU8lJ8VoBb060jtu8bBu7f6078M2iEyIBaZBAofHidPvzI3YqsqsPG9GYSSL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 1:40=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Sat, Aug 08, 2026 at 05:49:48PM -0700, Suren Baghdasaryan wrote:
> > On Thu, Aug 6, 2026 at 1:23=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kerne=
l.org> wrote:
> > >
> > > This function provides the anonymous equivalent of linear_page_index(=
),
> > > instead offsetting based on the anonymous page offset of the VMA.
> > >
> > > It is valid only for anonymous or MAP_PRIVATE file-backed mappings, i=
n
> > > other words CoW mappings.
> > >
> > > For pure anon VMAs, this will be equal to linear_page_index().
> > >
> > > Assert that both of these invariants are true In linear_anon_page_ind=
ex()
> >
> > s/In/in
>
> Ack. I ran these patches through claude several times and it didn't get t=
his ;)
> the machines are not taking over just yet...
>
> Andrew - could you change this in-place? Thanks!
>
> > > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > > index c6fc783aaee5..0adfa6605653 100644
> > > --- a/include/linux/pagemap.h
> > > +++ b/include/linux/pagemap.h
> > > @@ -1094,10 +1094,44 @@ static inline pgoff_t linear_page_delta(const=
 struct vm_area_struct *vma,
> > >  static inline pgoff_t linear_page_index(const struct vm_area_struct =
*vma,
> > >                                         const unsigned long address)
> > >  {
> > > -       pgoff_t pgoff;
> > > +       return linear_page_delta(vma, address) + vma_start_pgoff(vma)=
;
> > > +}
> > > +
> > > +static inline pgoff_t __linear_anon_page_index(const struct vm_area_=
struct *vma,
> > > +               const unsigned long address)
> > > +{
> > > +       return linear_page_delta(vma, address) + vma_start_anon_pgoff=
(vma);
> > > +}
> > > +
> > > +/**
> > > + * linear_anon_page_index() - Determine the absolute anonymous page =
offset of
> > > + * @address within @vma.
> > > + * @vma: An anonymous or MAP_PRIVATE file-backed VMA in which @addre=
ss resides.
> > > + * @address: The address whose absolute page offset is required.
> > > + *
> > > + * This returns the anonymous page offset of @address, which is the =
page offset
> > > + * the address possessed at the time the VMA was first faulted.
> > > + *
> > > + * For anonymous mappings, this returns the same value as linear_pag=
e_index().
> > > + *
> > > + * For MAP_PRIVATE file-backed mappings, this returns the anonymous =
page offset
> > > + * of @address, which is the page offset the address possessed at th=
e time the
> > > + * VMA was first faulted.
> > > + *
> > > + * It is not valid to call this function for shared file-backed mapp=
ings.
> > > + *
> > > + * Returns: The absolute anonymous page offset of @address within @v=
ma.
> > > + */
> > > +static inline pgoff_t linear_anon_page_index(const struct vm_area_st=
ruct *vma,
> > > +               const unsigned long address)
> > > +{
> > > +       const pgoff_t pgoff =3D __linear_anon_page_index(vma, address=
);
> > > +
> > > +       VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
> >
> > As discussed off the list, this assertion works even for read-only
> > anon mappings because, as you said, "there's no such thing as a pure
> > anon mapping that is !VMA_MAYWRITE_BIT, there is no way to achieve
> > that."
> > It took me some time to see that after reading your discussion with
> > David at [1] and [2], and I don't think it's very intuitive. Could you
> > please add a comment explaining that? Maybe add a comment at
> > vma_is_cow_mapping() definition since you are using the same assertion
> > in another patch of this series?
>
> Sure will do! It is very confusing stuff (and I was duly confused also at
> first).
>
> To save a respin (unless there's more stuff I need to address) I will pro=
bably
> reply to the relevant patch with a proposed new comment.

Sounds good!

>
> >
> > [1] https://lore.kernel.org/linux-mm/anBjpdMicqaGADr-@lucifer/
> > [2] https://lore.kernel.org/linux-mm/anLyhaI6kW-EWk13@lucifer/
>
> --
> Cheers, Lorenzo

