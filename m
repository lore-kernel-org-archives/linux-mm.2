Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531B3606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 11:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bK0a9SGW
Received: by kanga.kvack.org (Postfix)
	id 5909B6B05B2; Fri,  6 Nov 2026 06:22:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541726B05B3; Fri,  6 Nov 2026 06:22:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431506B05B4; Fri,  6 Nov 2026 06:22:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16B8E6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:22:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A4CA11A0D9E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:22:02 +0000 (UTC)
X-FDA: 85404454884.01.FA3A1A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id EB95240004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:22:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bK0a9SGW;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793964121;
	b=DK09Ug0v4v/5/aovVl/0d7G5GSe8NmnVbEOBVqWWwVrlKo1RnGsKNXXhcNe1wRuvApESM/
	uG924V8pSdQE02C/erfJs8fOu3D8Ypl1fxzsvJEjMoyF5+BRxMJqkA7amao0eFwOCJ9Li9
	v+q/JvoKEjTitV0Mx9CHUi1wJc+/x+I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bK0a9SGW;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793964121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+Ok2jd0IVx31NW+VHJJuf+Q+PVcuhS6OrBHlNc0X1Y=;
	b=Z37p0l4wjQrIEG6/dTAd+90ihmrP1UGa3qkq1VR6FAIolMUAUhb2t2BT6GBJYEyNT7r08a
	3OHxqIx0MmMbtnEJXdqDJmLEsxfIr7mlI2RDcOAL6SuCXWx4pl+tNHbY4CeXsoDrSaFJCC
	C+l3AS2/efeNGKqkQgihgUWrwbd4Prk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C9DB4325B;
	Fri,  6 Nov 2026 11:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F931F0089F;
	Fri,  6 Nov 2026 11:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793964120;
	bh=p+Ok2jd0IVx31NW+VHJJuf+Q+PVcuhS6OrBHlNc0X1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bK0a9SGWX+VyZD0kFIiK4yNIK9A9v+An7WfGjPiMiNKuUGcrfRy/CwNqTxljrBpV0
	 U7m1a/COhNVgako5ExzfFpup8zroemN8PZasns74e+wzdmXNGp9HfFsumePkfHpqUz
	 B54avhJDK4RV1zIBmim6BKz7o7ZgZ9/g1a3ek0DWtoergphiLCDdHz5glMnik8SvAi
	 sjlHg1ttAqkP8985sWOQHptTvB9E/+p4pzQXWHiAvU6YBAJ26cTB4FDz0XEBtsF1a0
	 bgh+paL3EuS+CEi5iRnn4vYJCUV3oXHmFOJ7h5ygJmRsCVDkmI4xEURGnOh8gud8UK
	 jwyBg4yTS3zRQ==
Date: Fri, 6 Nov 2026 11:21:40 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, SJ Park <sj@kernel.org>, 
	Rakie Kim <rakie.kim@sk.com>, David Rientjes <rientjes@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	John Johansen <john.johansen@canonical.com>, Georgia Garcia <georgia.garcia@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, damon@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 03/13] mm/rmap: convert remaining VMA flag tests to use
 vma_flags_t
Message-ID: <au2yhvzWy6HID8jM@gremlin>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <20261105-late-2026-vma-flags-v1-3-0d3cd15ab75f@kernel.org>
 <CAGsJ_4wCd_j5or0uHwPLq0PUixcXgiFim=_d7uUhUhAuQf0nTQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wCd_j5or0uHwPLq0PUixcXgiFim=_d7uUhUhAuQf0nTQ@mail.gmail.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EB95240004
X-Stat-Signature: q3k1ah1zqre447nh5e7z6ux846wskcsu
X-Rspam-User: 
X-HE-Tag: 1793964120-717719
X-HE-Meta: U2FsdGVkX18RtReiwv+CS87nfmq4TtlH1DxAkq8zNcqDOmgI/jYZkQN4aa0p3e1TJL9DXPKC2uSk+3suPIn9ubcPz/lweE9XQXH/dfGBMMbJO9LLosvxGHUGSr6PoR7undjbNIzPp5SxgoTYNtO13mu7IawZCsGnnIjbbFtTAdEwwg2Rz+vbL+t6S2X5wqFxAh3Vvn74n+0wPT4NU6wP58Cb+U+/XqNP8qv+bu9/q4ywJJDEA5aim+zZM/WH7YRCQlIRYnW7UNdksqDJTebBFRRHZRyP5SHmQ+QA6NVohd86CJTBQ37ojn+GZ6Mv4JAHAutzxFke4lWI9SpiAwSKRyMe6o08PT20gScEbh+m+r1SwcPNhK8hVmu1UWk+1SVWfMTokL2HOsv/oo9GscMmMPOW5qEya+ZNByfpyQV/Jgl7xcbN5qSMIFvJPQDyRtpsiUWaB++YAVVtH6fvdhamZTCbPq5iRFh5i7GZKr+s2iXzh7n7imsFW/ICjwurM+sIlLj4aBfm0GL2bfd8HaGNzv2PZTLAUH17h5n9ST/RjuzNWFPsOPWNDG1LEBd4BRj0dBrI69C2QWKIWm6GfRnwGuk/aVwmYBJrFiPLOOa0dPKXJu7EhNxWIbW3N9GNfY5Yq6YzYdyFdNq+o+0wKTpKuBy7vhbvUHrEAaOQhjsZxFlDwwdwa/6a5lluzACLvRF1pVPObRKC2PFqNE/4MQpo6VVfFfxKTWICmmTvuaj675c7qcWgCvSzBCS85hZqPTxF1OoQz2/Ail4vCQHIVA+gRzdayTpItg1yI+nYUYjZBJwnW0Eg6NILear6rG2boEwG6HapKLKFySclga8p69wqrEUA5uJKDdhz0FtPTKMX8teJPckxI6CBnHadwqYdxxo+RXfKSM3D0AN2sM0i3Eel81pu8sHTFrkG4WTdnKrRP7bP8DITzGWAU9DyVmBuZcgQzuXQq3cenkcPjHlXguE
 6lS7QTen
 wGKmglUXZ3EOJzq2uRGHzUfWmk0Yr55k88JGlIPNgMcbMqRpaOBPYjWPYDj54w9q6vcCPwJdvQ+rVNM36+J02i1kX7yPCJ85IXOVd+oQGkuBb1ny863bBXy6ZBmXS3u7Qku0gaHgJCE6fIWI8iJ2bYAJ2ez1MXOXISnl871xpmtLsuHlFGKzI/bu0lt5Fs+leqNx8hlLUTwMNZIHKGzKgZCNHFq9Jvo5gWS7opfvDNnpL4+E6DNQ6qCIvTB8mJASFr6tP/P+JH7uwjyMrvYE4GJPgBAIlYsZVzPP/j8nkgCM9dMjzxa2ka0hP3GkwHaYC9TlVZ/zyt27z8CheCp67ejl5/v+WrvY8QVa17RU3+5+k5aLwW4/QBUh2nOLzNCy729jPXd+UsYx6N7f+ktfIqjAqSpPDCE60jprOr+WD/M+PWm4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 11:57:08AM +0800, Barry Song wrote:
> On Fri, Nov 6, 2026 at 5:32 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > Replace the remaining uses of the legacy vm_flags_t flags in the rmap logic
> > with vma_flags_t values.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
>
> LGTM,
>
> Reviewed-by: Barry Song <baohua@kernel.org>
>
> >  mm/rmap.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 1131b76bbbc2..cdc97fec8586 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -1196,7 +1196,7 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
> >
> >  static bool invalid_mkclean_vma(struct vm_area_struct *vma, void *arg)
> >  {
> > -       if (vma->vm_flags & VM_SHARED)
> > +       if (vma_test(vma, VMA_SHARED_BIT))
> >                 return false;
> >
> >         return true;
> > @@ -1660,7 +1660,8 @@ void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
> >          * VM_DROPPABLE mappings don't swap; instead they're just dropped when
> >          * under memory pressure.
> >          */
> > -       if (!folio_test_swapbacked(folio) && !(vma->vm_flags & VM_DROPPABLE))
> > +       if (!folio_test_swapbacked(folio) &&
> > +           !vma_test_single_mask(vma, VMA_DROPPABLE))
>
> Right, VMA_DROPPABLE_BIT is not available on
> 32-bit architectures, so vma_test() cannot be
> used here.

Yeah, it's an annoying wrinkle having to differentiate, but is necessary.

Eventually we will have 32-bit kernels move to the same size vma_flags_t as
64-bit, e.g. something like:

- #define NUM_VMA_FLAG_BITS BITS_PER_LONG
+ #define NUM_VMA_FLAG_BITS 8

But that's down the road :)

Which will solve the 'not in 32-bit-kernels' stuff.

But also this form is also used for stuff that's not defined under certain
configurations, in which case you get something like:

#ifdef CONFIG_FOOBAR
#define VMA_BLAH	mk_vma_flags(VMA_BLAH_BIT)
#else
#define VMA_BLAH	EMPTY_VMA_FLAGS
#endif

And then vma_test_single_mask() is necessary too.

An unfortunate outcome of defining per-bit (so no bit value means
'nothing'), and any kind of invalid bit value solution has worse drawbacks.

In the end all this stuff will be useful as it allows us to no longer be
constrained by either 32-bit vs 64-bit or in only having 64 possible
flags. :)

--
Cheers, Lorenzo

