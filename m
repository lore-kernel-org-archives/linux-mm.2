Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECCDECE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1B328E0003; Mon, 17 Nov 2025 13:17:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF30A8E0002; Mon, 17 Nov 2025 13:17:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E081E8E0003; Mon, 17 Nov 2025 13:17:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C93C28E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:17:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B430C0212
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:17:26 +0000 (UTC)
X-FDA: 84120906492.27.9E12511
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1751314000E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:17:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gwX0PiRT;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763403444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLkBFyQphttyBlL0MaxtfpIa2M3df8GEH89TkAXYszg=;
	b=RxDKYT5jRg59GJUKY923oQpEFBoTVWTCM6TIQTre7xfeTQijVDvramHH8K9ZEYrAUgk9Co
	bqvs4au7f6ooLbI4HsUN6XSQzib1U8Wsan3c3T+yFz1ZDJRp10ZL8ylGH97HJoPTMVvuAi
	cMNOk9QP+jvSr2dkuSw9vumsjzbodxE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763403444; a=rsa-sha256;
	cv=none;
	b=mzYCezUHGYrU3yO74b51pbmX/eG6rJ0hyVhM/4jTv3quIL5mnx9+Uy5emo9OeMuzSW6GbR
	rJEYVR5e/as8DsLOu0k+4WVcWVB6JOEACUkGL6ZmTyZVT9F3YBn2HVeLvKBLCB5s792TbF
	mMwfASENXamTTWq6BSmHgtahgcfARAs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gwX0PiRT;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763403443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bLkBFyQphttyBlL0MaxtfpIa2M3df8GEH89TkAXYszg=;
	b=gwX0PiRThPBeMPUXt7yVKVmVN52mV7H8+nmnId647GHRiCNTcZ9PrOVQ1qeihBLf/K6wPb
	F1sJkxyQ95U0o7wD6jtUtJz5lcNxzVpe+sQi9H5BmLn5HobmpVuxsE8yI458XOROSaw9aH
	bEF6HKvGE/kLjQxEcMFH4bwhjzL4Zv4=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-aDK5tlp6PGa1-G4Ox9e2-Q-1; Mon, 17 Nov 2025 13:17:20 -0500
X-MC-Unique: aDK5tlp6PGa1-G4Ox9e2-Q-1
X-Mimecast-MFC-AGG-ID: aDK5tlp6PGa1-G4Ox9e2-Q_1763403439
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-640d2ff4acdso7470908d50.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:17:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763403439; x=1764008239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bLkBFyQphttyBlL0MaxtfpIa2M3df8GEH89TkAXYszg=;
        b=wWcSxBdaU+7ArdaA8olyWRqqeaVjap9AmeK+G4ZMxsRje2d7Xwx27x4u6+AeumH9It
         MLmYQO0UOaRunfRbMSrhw6m/thUOtZXBm7oISZj5ILuvpCR3hGz0nPSji985AOKqf8Qi
         nsaA84r0RWjZe7RWiK8ZXBPpNsKaCEH2EC4W1ZEq+9sVgh1HZDpzAaQUpPLX718s3lUl
         bt8PUS50HTnb/qLB+8sZVgHdJx4qZrnAPFvpiHPt5TkYQC5y8fuVfJ7/I6XTa1UlwtDF
         aTYWoXxeoQAsfE043xU1yANTXKvGXh9OMBx1DwK9TWoLovk1MPMO1KyED0/vqJtj7u7W
         oc8w==
X-Forwarded-Encrypted: i=1; AJvYcCUSJ2KBAZ2G3DbImElkpS59LyuJ56YiEhA1F1B+be1duxKjtx05QuXglSwIhXhBw/NEN3+t7xw6fQ==@kvack.org
X-Gm-Message-State: AOJu0YxgsBaQoMo635CG1dcQQSP/73X2oG8WTf0RhRhiDh+dA5cFlE+/
	AFUwR9JgIf+7yVkGCrlkmfnRTFBHaawxqv9pRj09FOYro+sxy6EsnHh9JvHaWc4Y86XbGlzkYVA
	hHtwLna7aMsPrIFkqa0c4n5NMRix/T0dMm5UaFFErHhLFtCWSKUNXKgGLg/zTRUBppOtknUJA0Q
	2eiUUCp+Ardm8FtCvBKgwfInGibqA=
X-Gm-Gg: ASbGncuHdzQmkVGC/C3aZfNLY8j0c07tjDKLT7NjBTnBPX7/TTFM5KuKfcvyauTu7ue
	z93qdqA1IH99GHdPBmbupyzhfVnb8wgJPV0q5UZnXJkS4x0A9oT96r9PEVqor20KD6FxioXqEAp
	LMyE6Pxv7wxly8yLDaW1AjB6bFsb2JErDs9jEpPoi+gFwYul50VNUpfIBOmCWbCVPrawfF/A==
X-Received: by 2002:a05:690e:d8a:b0:629:acb6:d8a with SMTP id 956f58d0204a3-641e7562fd0mr10867446d50.26.1763403439596;
        Mon, 17 Nov 2025 10:17:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGqkBOn29yUwcPzlRUfZrCy2cM1EilWOd6JVaHoD7tCDRXb4G11MerU3OGL9P/y0HInk6+3E4wc78Xi4FqeiDU=
X-Received: by 2002:a05:690e:d8a:b0:629:acb6:d8a with SMTP id
 956f58d0204a3-641e7562fd0mr10867430d50.26.1763403439239; Mon, 17 Nov 2025
 10:17:19 -0800 (PST)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-14-npache@redhat.com>
 <20251109024013.fzt7xxpmxwi75xgr@master>
In-Reply-To: <20251109024013.fzt7xxpmxwi75xgr@master>
From: Nico Pache <npache@redhat.com>
Date: Mon, 17 Nov 2025 11:16:53 -0700
X-Gm-Features: AWmQ_bnbDA-LvF9eb5QkiR_KgOmDIKODHM2kGY-8vhaQuyICX8DSbvUaiKBYszo
Message-ID: <CAA1CXcA9zaGqLPHnJWH=fKPUjb02dV+rKgfmsRZOGdeukiC8eg@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 13/15] khugepaged: avoid unnecessary mTHP
 collapse attempts
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com, 
	pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: A8G6TGHBPn6KMMoAVY_xz9s-Y9cp21Vxwg6r6JuLCo4_1763403439
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1751314000E
X-Stat-Signature: 3q6gt3ngchgntt9usrqf1b8saeqp79f4
X-Rspam-User: 
X-HE-Tag: 1763403443-629560
X-HE-Meta: U2FsdGVkX1+WyV+sIh+dxCYdU3TeuvDriyRu3vfUvrwUHBavath8lRbkaGd9kRfePh8hjS7HYaDUi27/4PVp4DtkSXeaBa3cju6R0FsjYc0fnPKc91e6UNX1Sy4TIePJ6JzY9ylZ6vcRq4Lj5HG4vfic64nBA0SiOHYukQsMm1O3avbSnaz3QdjXdM3Ls++hmCgpX9pJ5f/2xCcgXxRNa2vfElKMVDf9jneLYqokznHohj0xqhFrYz7fA7woI74w2+VNdkAJl86x3mOn6CzintHpVbdooRZFWXfFO7WRM+V8jFHuHSoSpEFxi8qhenXgdtErilP2ZNDzSin4+5GUQF0tW4SqjpvvcjXB9VuRUD08hMT198+4bHPek5WYhELBqdMrCu0OCdUxI2YhtM91me6H8a+1hyNLG0ndpu9HUXU5fDhJUp9N06pXjBLDuBJL6bm3mdjGakF/e5NrzqaoJST10+awF4UDdu3g2B69FKMN5gOJfBpokrj8En+X6U8/ic7DPNpZjX7b3anNF8NZv08vIVsldKPHsvT7Xe1OWb/Fu1vP++s2fFDXXw05/gVEoXem/hHdSRdjjn/VcEyFTV5XgjfX7L7xminIhSdJP2wdT7A2G3v4S6JdxIBKZ+6vhjbuQ/py4yAoLLeKjHxRuymX2n6/u97hoaTQelXErnoe0KKUz9Nmq4v/kZx3QAFZiTCfRnb/bZ4nd8UsFy6jSM+wGb9n/l1bRgX0kFjjYHuGt7yLznKCMcKkmlEO/3O6OIbd7vRt9s60yA9vA7f7fdPSGSQA6Gzp2A4Q74bjPMw0X+0r7Z9MeHzAs7Vvha1FWCsj2Dg6A7PaQncd/9+bQuDe41hYTjMIztdd5Eg2FEl4ofnODTMUfSQQpbbVEpCSiFoXUTHvylB0poCujUaTrAg5Pkto6Z0USWUnTIa9o9NVOAniAtaduLZRkXKoF407nsQsosfsFjrIlGdtAMs
 YHQh7404
 DVTsgBMf0/7X+hqTLKGvAW0ico3TsJn/DxVKXlnJhSUzDK84gRO0ex4WHqglbv2vG77zz9gt9YNjkFMbIwaNuV68ZeQb5peDwe+nRREcI/awVrnJwjZjZ+bbBC6H0YnCSXJlYc59/dZqVHn+167wkmyGyPZLW253oEdbXW2R8NuH3Tj0Y+eZhMrQCRUXB2rOI+ixCrLxPeTZyHq5WSlmpWo5Wcgtq5J0IeP4LMZYNqSxAB+kRycfo5177YAF6BXP0EjwS0F3Drjkrv4uCCBoZjAPLKKtiS+4ewSq9Qsh/OktKl7Pf7oR2ZEewcjZi1uvH+gLSC2tKZfZdbZkJESO6Jce0Qm+POVHwV5a6vOZ006Yp/wraXpc+FgGDGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 8, 2025 at 7:40=E2=80=AFPM Wei Yang <richard.weiyang@gmail.com>=
 wrote:
>
> On Wed, Oct 22, 2025 at 12:37:15PM -0600, Nico Pache wrote:
> >There are cases where, if an attempted collapse fails, all subsequent
> >orders are guaranteed to also fail. Avoid these collapse attempts by
> >bailing out early.
> >
> >Signed-off-by: Nico Pache <npache@redhat.com>
> >---
> > mm/khugepaged.c | 31 ++++++++++++++++++++++++++++++-
> > 1 file changed, 30 insertions(+), 1 deletion(-)
> >
> >diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >index e2319bfd0065..54f5c7888e46 100644
> >--- a/mm/khugepaged.c
> >+++ b/mm/khugepaged.c
> >@@ -1431,10 +1431,39 @@ static int collapse_scan_bitmap(struct mm_struct=
 *mm, unsigned long address,
> >                       ret =3D collapse_huge_page(mm, address, reference=
d,
> >                                                unmapped, cc, mmap_locke=
d,
> >                                                order, offset);
> >-                      if (ret =3D=3D SCAN_SUCCEED) {
> >+
> >+                      /*
> >+                       * Analyze failure reason to determine next actio=
n:
> >+                       * - goto next_order: try smaller orders in same =
region
> >+                       * - continue: try other regions at same order
> >+                       * - break: stop all attempts (system-wide failur=
e)
> >+                       */
> >+                      switch (ret) {
> >+                      /* Cases were we should continue to the next regi=
on */
> >+                      case SCAN_SUCCEED:
> >                               collapsed +=3D 1UL << order;
> >+                              fallthrough;
> >+                      case SCAN_PTE_MAPPED_HUGEPAGE:
> >                               continue;
> >+                      /* Cases were lower orders might still succeed */
> >+                      case SCAN_LACK_REFERENCED_PAGE:
> >+                      case SCAN_EXCEED_NONE_PTE:
> >+                      case SCAN_EXCEED_SWAP_PTE:
> >+                      case SCAN_EXCEED_SHARED_PTE:
> >+                      case SCAN_PAGE_LOCK:
> >+                      case SCAN_PAGE_COUNT:
> >+                      case SCAN_PAGE_LRU:
> >+                      case SCAN_PAGE_NULL:
> >+                      case SCAN_DEL_PAGE_LRU:
> >+                      case SCAN_PTE_NON_PRESENT:
> >+                      case SCAN_PTE_UFFD_WP:
> >+                      case SCAN_ALLOC_HUGE_PAGE_FAIL:
> >+                              goto next_order;
> >+                      /* All other cases should stop collapse attempts =
*/
> >+                      default:
> >+                              break;
> >                       }
> >+                      break;
>
> One question here:

Hi Wei Yang,

Sorry I forgot to get back to this email.

>
> Suppose we have iterated several orders and not collapse successfully yet=
. So
> the mthp_bitmap_stack[] would look like this:
>
> [8 7 6 6]
>        ^
>        |

so we always pop before pushing. So it would go

[9]
pop
if (collapse fails)
[8 8]
lets say we pop and successfully collapse a order 8
[8]
Then we fail the other order 8
[7 7]
now if we succeed the first order 7
[7 6 6]
I believe we are now in the state you wanted to describe.

>
> Now we found this one pass the threshold check, but it fails with other
> result.

ok lets say we pass the threshold checks, but the collapse fails for
any reason that is described in the
/* Cases were lower orders might still succeed */
In this case we would continue to order 5 (or lower). Once we are done
with this branch of the tree we go back to the other order 6 collapse.
and eventually the order 7.

>
> Current code looks it would give up at all, but we may still have a chanc=
e to
> collapse the above 3 range?

for cases under /* All other cases should stop collapse attempts */
Yes we would bail out and skip some collapses. I tried to think about
all the cases were we would still want to continue trying, vs cases
where the system is probably out of resources or hitting some major
failure, and we should just break out (as others will probably fail
too).

But this is also why I separated this patch out on its own. I was
hoping to have some more focus on the different cases, and make sure I
handled them in the best possible way. So I really appreciate the
question :)

* I did some digging through old message to find this *

I believe these are the remaining cases. If these are hit I figured
it's better to abort.

/* cases where we must stop collapse attempts */
case SCAN_CGROUP_CHARGE_FAIL:
case SCAN_COPY_MC:
case SCAN_ADDRESS_RANGE:
case SCAN_PMD_NULL:
case SCAN_ANY_PROCESS:
case SCAN_VMA_NULL:
case SCAN_VMA_CHECK:
case SCAN_SCAN_ABORT:
case SCAN_PMD_NONE:
case SCAN_PAGE_ANON:
case SCAN_PMD_MAPPED:
case SCAN_FAIL:

Please let me know if you think we should move these to either the
`continue` or `next order` cases.

Cheers,
-- Nico

>
> >               }
> >
> > next_order:
> >--
> >2.51.0
>
> --
> Wei Yang
> Help you, Help me
>


