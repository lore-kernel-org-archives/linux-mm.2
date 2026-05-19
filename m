Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 013F0CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 19:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448AA6B0005; Tue, 19 May 2026 15:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3656B0088; Tue, 19 May 2026 15:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0C16B008A; Tue, 19 May 2026 15:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 140DA6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:20:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C750A140747
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:20:45 +0000 (UTC)
X-FDA: 84785136450.02.A86AF0E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 93784100003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:20:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YidhG/sV";
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779218443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n8tG2wswV07nIaXcZKUGCsw/G0T7Ho3Kv10KqQkUI+0=;
	b=23kgbhuMvMxusO6NavCxlA2SXE+AHwC1DTmQ9IcgufHASeXfzwnuH8JQrnuGdnqZPZI7W8
	QL7ioy8+pzr9JdWvD+CsZTC9Gih0/xiMhncCYtHDAikwosIgIs9iRUdgIEIf3dRMPmVEUn
	QEhvpXxfFakRJFYtmpRslVghLZO0vWM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YidhG/sV";
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779218443; a=rsa-sha256;
	cv=none;
	b=dHUuX5hOLUQQgL5gFygi4prElSHt1W3MgC6L6yIzWOa7mcuMyfwuq4J+BGng/mvGxQA89l
	CRMfI7fZYHXVwIGX6R0tTWVCkWF/4AdT+4GxryoGlWbg0NV34S5qijxW+YG9ZYtM/K09JU
	S/k+Ozxl3ZPlb5CESG9Y4kHAL0QmTc4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779218443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n8tG2wswV07nIaXcZKUGCsw/G0T7Ho3Kv10KqQkUI+0=;
	b=YidhG/sV4P6SpgOMgNrfosM28fWHAN3pwSHVOE77/gqy1HRutjJNFkbOmRyZxUz6h1hpzq
	KGLfWEaqDe7OMtVmo7YYVVvvdxZg+eRd0tORhD7an/cF1vh+pQnOd0Tkyc+AtsRRI7gr96
	Uo+buMbu1HBYmXNVYcrgSAdCnzj+woo=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-WyXjuqbpNHeQMNhKCoD9-w-1; Tue, 19 May 2026 15:20:41 -0400
X-MC-Unique: WyXjuqbpNHeQMNhKCoD9-w-1
X-Mimecast-MFC-AGG-ID: WyXjuqbpNHeQMNhKCoD9-w_1779218441
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-6583252c117so6866896d50.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 12:20:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779218441; x=1779823241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n8tG2wswV07nIaXcZKUGCsw/G0T7Ho3Kv10KqQkUI+0=;
        b=XudgD1xDp3jWWAw1sVjHehU264Gu7s3++mx1m+Up6z+kIQq1vkgm2iY3GuLHNP6in3
         /hDk2IU+PAuuwn35ojjkgOOlIXsuuJC/xrG8zctjBQUwA+fO1Tl7L/5BobYyTMJ7Gfz7
         yRuYj4h8ceFfSKa76+wE10qLZsl5m985rrROfIAqHm0QIEGTb9N9X2FbarKrnt5M2NaL
         JE1PrQtQN43WQhnswaUug8OgtXJ9PSqTq+Wy2WGdoCB26fwOw1vOsswHNRON0BDjwCxl
         x/hw0y138T5p403HSBRTW9L9lVHVU4JAh8zBicNFPMHxwF07VvxtwKZq6ZvbytSiPKYo
         BHRw==
X-Forwarded-Encrypted: i=1; AFNElJ/2Xw6Dvj6J398p2dX9JneyGsQ+l9ZePXJORCU7HV3h9Q8oE2MpU5IRwxzoOkNXE/WV5ptS176Syg==@kvack.org
X-Gm-Message-State: AOJu0YyQCveUS1XyOoYktOLsJItZYQecupBr9+OaN+Nd/2mo6cEym6MW
	ORVsJCbcVLNCxPDyYU1I/AadAn6yp5qtcvqlT+imrNuIToptMNg9XhAtYbCNGVB9nCbWK4ESYgO
	D7r6yijHnQ3PGOX4+zrPwMDf0mVwPjnlZT0ZDXjjMJnJqh2h5x9Nhysc/bqwFGFlEML2i7SFyEl
	heZW25qUDkDd6+qRWaMTTOTpZxVtQ=
X-Gm-Gg: Acq92OGRn8/1k9Y70gXSEtjdR3B7KtEeHxoYuFj1xpf2mD03UkJVcdJQ8VzfniCOjF+
	wRqp6/phJZ+aA0+wIj69Frj/Z0OwiPwn44NJ6pct0jg4vGT8tZV0cZnqfedF5AaAjeSLe7mf3ma
	GoBRX9s91swvWUUItAQRLyJH8V2AA5Oy9RROul5E3z78CMLd6XyIHlNMc2K4OqeoQKP3aVWhIlL
	BBxcw==
X-Received: by 2002:a05:690e:4417:20b0:651:c20e:a43 with SMTP id 956f58d0204a3-65e22674e39mr17209611d50.6.1779218440626;
        Tue, 19 May 2026 12:20:40 -0700 (PDT)
X-Received: by 2002:a05:690e:4417:20b0:651:c20e:a43 with SMTP id
 956f58d0204a3-65e22674e39mr17209557d50.6.1779218439923; Tue, 19 May 2026
 12:20:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260511185817.686831-1-npache@redhat.com> <20260518125007.a4z3pw4r73uuwja4@master>
In-Reply-To: <20260518125007.a4z3pw4r73uuwja4@master>
From: Nico Pache <npache@redhat.com>
Date: Tue, 19 May 2026 13:20:45 -0600
X-Gm-Features: AVHnY4Jl_QW-vgdM5ZP8NC0nxmd5EfltpH7tsdSlcrq5iAp5kcmnKVwJ9jkpOtk
Message-ID: <CAA1CXcCnMddMbhXF9zkut6tD4kh1fXRecwA=LFAiBSRatL3Rtg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v17 00/14] khugepaged: mTHP support
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, rientjes@google.com, rostedt@goodmis.org, 
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WNBWT43jIbzcK5FU_b7kGkWmSTXvCUnd_O08qo0D9zw_1779218441
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kry1za4xpt76rcwafinomdhegzachmsk
X-Rspamd-Queue-Id: 93784100003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779218443-427216
X-HE-Meta: U2FsdGVkX18so63T/8opaVYhHxERv28MxD59602vYv380PoAE/LpBydKIT8zuOGRt7waNfWOWfdejT8bEZaK4kOeamR8ymb18jGQReFMX/49VYnstiqtiak06s/d4IwW6hIxpwxDI9CfQqEqb8jWlRVhCW6mt4Xq1t1R4cg70EvzXtgwGfxiXB6CSBfFMKntBvfmAjvz6LhAAgepi90Lfk+1GOKoCl/AUj88KxCEhwk+WoejT1crdof/Tn79vGUUNqTJnoSaJ6DM5XAajMnfekacGTQFMs5JlR997CYN7DgUCrRtpgjqCC7gxKMERO7DwjeeKu0cx0TfjE+NgbmlWJLd0ufMnBgewnKFcI4v8AZia/0/oJPDep9GEuqcdd1owBTS1fdSDuwMPutOkmWMCbEbN7ufuc3czo2noKNuUOY/HBClaTjFua/B9tIF5FGXYjd04s0SlrXMY/OzeZp5w2GUpGwOI46L7SVcb/HV1PxsYE9n4szDHlGNZOiLfTXF8udXflD9okzXCBEDHLM5/MIy9to+4hNC/C8SHAy4SBHbxZ6wtc5/MIk35547pQ5gbr9nd5fGuDegREoq3MBoYaQc67L+ftXHF5241DNynoad1kraFtqE5JDSvJtKfKNPWi/4Qwjv73J6CWzyS4b1CUu5XmXnv3BuYbFL3ZrJEyTIcMEObwWigBxpwmEhWRxHK4d3LyA4j1QlJuN0Pb42XaxCks7gpR0YYjZlzsJDapSDHDikS63CdrtRORQK0JHpcTj7IyunAHKPWpyAVg/lYElzgCalt9dge7JiEQEysD11AEbD1uFNWrGEG580OuqwUnEzfJ8uNWhnRt5bTH3ZBekLATYXw5wUOHyjUJ1bRDz44p4vpIspDW/ItvqU5HSl+w0EolfXWZflmWa52zHuBbA2Ik55OfLsXjrCVsanOqQ5h0N7Iu4hTjTtqeGPrTctisH+MQihb4OXpfZn36F
 FE4x6Yyj
 5fL+IK49+uLNjRqJBXb5aVG8RqHxb2BZj8O+UDpqH70BVrcntqDvZ/nJMR3iPUkfvmUPq/m1vDSvb63KNzXPbN5X/azRLrw9Mt2EutBuTta1mibRa9NAzk9mW7M5wPG68Z1u5+ylnrsu2fgjRclFd5AAWlMIcYDlOtg/4ouwjmTVb4+hTLtjzuUrsgaVl6uy8VWKgjWrC6mWGk1EjOdWUyOSkYhKZKLLGXSuFtGIIfE58D2Wm6SM/mxo4IeSrbt1Jlc0fwzAcfHw0eHT3allnlaKdlyEBU+X6eoo0ZyvZ3NDm0ijFYukOpSmMlfXl7gsgBUIbsyI1z4dDt3A8L1+Hwt/D3cjUU7FzjqfbaHTbJeLzP37G/zjGZbip2CgZ9GiMVISI54KlhhRN5jiR2l7Vlj7zcJT7yK6uCpZ9IkDO/PvYP+t2Ud5UT0gB/85bbaom0IZ2MmjTQKTHctecikGrpiDSnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 6:50=E2=80=AFAM Wei Yang <richard.weiyang@gmail.com=
> wrote:
>
> On Mon, May 11, 2026 at 12:58:00PM -0600, Nico Pache wrote:
> >The following series provides khugepaged with the capability to collapse
> >anonymous memory regions to mTHPs.
> >
> >To achieve this we generalize the khugepaged functions to no longer depe=
nd
> >on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individ=
ual
> >pages that are occupied (!none/zero). After the PMD scan is done, we use
> >the bitmap to find the optimal mTHP sizes for the PMD range. The
> >restriction on max_ptes_none is removed during the scan, to make sure we
> >account for the whole PMD range in the bitmap. When no mTHP size is
> >enabled, the legacy behavior of khugepaged is maintained.
> >
> >We currently only support max_ptes_none values of 0 or HPAGE_PMD_NR - 1
> >(ie 511). If any other value is specified, the kernel will emit a warnin=
g
> >and no mTHP collapse will be attempted. If a mTHP collapse is attempted,
> >but contains swapped out, or shared pages, we don't perform the collapse=
.
> >It is now also possible to collapse to mTHPs without requiring the PMD T=
HP
> >size to be enabled. These limitations are to prevent collapse "creep"
> >behavior. This prevents constantly promoting mTHPs to the next available
> >size, which would occur because a collapse introduces more non-zero page=
s
> >that would satisfy the promotion condition on subsequent scans.
> >
> >Patch 1-2:   Generalize hugepage_vma_revalidate and alloc_charge_folio
> >            for arbitrary orders.
> >Patch 3:     Rework max_ptes_* handling into helper functions
> >Patch 4:     Generalize __collapse_huge_page_* for mTHP support
> >Patch 5:     Require collapse_huge_page to enter/exit with the lock drop=
ped
> >Patch 6:     Generalize collapse_huge_page for mTHP collapse
> >Patch 7:     Skip collapsing mTHP to smaller orders
> >Patch 8-9:   Add per-order mTHP statistics and tracepoints
> >Patch 10:    Introduce collapse_allowable_orders helper function
> >Patch 11-13: Introduce bitmap and mTHP collapse support, fully enabled
> >Patch 14:    Documentation
> >
> >Testing:
> >- Built for x86_64, aarch64, ppc64le, and s390x
> >- ran all arches on test suites provided by the kernel-tests project
> >- internal testing suites: functional testing and performance testing
> >- selftests mm
> >- I created a test script that I used to push khugepaged to its limits
> >   while monitoring a number of stats and tracepoints. The code is
> >   available here[1] (Run in legacy mode for these changes and set mthp
> >   sizes to inherit)
> >   The summary from my testings was that there was no significant
> >   regression noticed through this test. In some cases my changes had
> >   better collapse latencies, and was able to scan more pages in the sam=
e
> >   amount of time/work, but for the most part the results were consisten=
t.
> >- redis testing. I did some testing with these changes along with my def=
er
> >  changes (see followup [2] post for more details). We've decided to get
> >  the mTHP changes merged first before attempting the defer series.
> >- some basic testing on 64k page size.
> >- lots of general use.
> >
>
> Two links are missing. I got them from previous version.
>
> [1] - https://gitlab.com/npache/khugepaged_mthp_test
> [2] - https://lore.kernel.org/lkml/20250515033857.132535-1-npache@redhat.=
com/

Oh whoops, ill make sure they are there in the followup

>
> And the test in [1] is a performance test. I am thinking whether we want =
a
> functional test in selftests.

It also works as a functional test in some regards. The reason i never
pursued self-tests is that I naively thought this was getting merged
6(?) months ago and at the time the selftests infrastructure didn't
support it well. Baolin included patches to clean that up in his shmem
mTHP support patches and added tests for both features. Let's repost
and re-merge this first; then, I will follow up in one or two weeks
regarding self-tests. I'm currently on PTO and only have time to
complete, test, and return the v18 changes to Andrew before they
create a huge merge headache and we miss yet another window.

>
> I did a quick try with following change and some hack.

Thanks Ill use that as a base!

>
> @@ -744,6 +765,51 @@ static void collapse_max_ptes_none(struct collapse_c=
ontext *c, struct mem_ops *o
>         ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>
> +static void collapse_mth_ptes(struct collapse_context *c, struct mem_ops=
 *ops)
> +{
> +       struct thp_settings settings =3D *thp_current_settings();
> +       void *p;
> +       int i;
> +
> +       /* Disable mthp on fault */
> +       for (i =3D 0; i < NR_ORDERS; i++) {
> +               settings.hugepages[i].enabled =3D THP_NEVER;
> +       }
> +       thp_push_settings(&settings);
> +
> +       p =3D ops->setup_area(1);
> +
> +       ops->fault(p, 0, hpage_pmd_size);
> +
> +       /* Expect all order-0 folio after fault */
> +       memset(expected_orders, 0, sizeof(int) * (pmd_order + 1));
> +       expected_orders[0] =3D hpage_pmd_nr;
> +       if (check_folio_orders(p, hpage_pmd_size, pagemap_fd,
> +                                          kpageflags_fd, expected_orders=
,
> +                                          (pmd_order + 1)))
> +               ksft_exit_fail_msg("Unexpected huge page at fault\n");
> +
> +       /* Enable mthp before collapse */
> +       thp_pop_settings();
> +       settings.hugepages[2].enabled =3D THP_ALWAYS;
> +       thp_push_settings(&settings);
> +
> +       c->collapse("Collapse fully populated PTE table with order 2", p,=
 1,
> +                   ops, true);
> +
> +       /* Expect all order-2 folio after collapse */
> +       memset(expected_orders, 0, sizeof(int) * (pmd_order + 1));
> +       expected_orders[2] =3D 1 << (pmd_order - 2);
> +       if (check_folio_orders(p, hpage_pmd_size, pagemap_fd,
> +                                          kpageflags_fd, expected_orders=
,
> +                                          (pmd_order + 1)))
> +               ksft_exit_fail_msg("Unexpected page order\n");
> +
> +       ops->cleanup_area(p, hpage_pmd_size);
> +       thp_pop_settings();
> +       ksft_test_result_report(exit_status, "%s\n", __func__);
> +}
> +
>  static void collapse_swapin_single_pte(struct collapse_context *c, struc=
t mem_ops *ops)
>  {
>         void *p;
>
> This leverage check_after_split_folio_orders() in split_huge_page_test.c =
to
> check folio order in PMD range.
>
> --
> Wei Yang
> Help you, Help me
>


