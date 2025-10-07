Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AC2DCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 13:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7BA18E000C; Tue,  7 Oct 2025 09:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53628E0005; Tue,  7 Oct 2025 09:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69398E000C; Tue,  7 Oct 2025 09:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9498D8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:51:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B391117842
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:51:53 +0000 (UTC)
X-FDA: 83971456506.26.AE4799B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1BD0940004
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:51:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gQlKl8d9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759845111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KrQVt4Oy0c+QhuB8BTSmtP+2slJhAn2k60X6LTe3UUI=;
	b=W7vb6PDwBrbuCnVFpOpxR4zLdWJx2kPcpyUm3XB3hfq2sljQ5YKpMaUkl//yi89psZh9dc
	yPSHDwO+vI8jO2l950wXlTtFsVndy+SorU/GkfvBvXCDILbHSjXU7TOZ4mVkWrWAhgQ8w1
	ThNDY/BJgqP0iD2arAc1TLh5Cg57T7g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759845111; a=rsa-sha256;
	cv=none;
	b=36ugaqiRqtPvbRv6cIaBhE5WmKpN3YFHdOW/9EzjAdIDxqYEjboSjbsY1QnjaKQrhBsHqW
	Pd3IbD7/gQoP+hJlZFiOyYZrTKP3FQR1/aBG4FAagLoBg8MO+wvIBi8j7cdd5FhrcODWwX
	TM80T/Al1qGXz2k9fG1BA++uTt6Yvww=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gQlKl8d9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759845110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KrQVt4Oy0c+QhuB8BTSmtP+2slJhAn2k60X6LTe3UUI=;
	b=gQlKl8d9xiLna6pb7xwitIzj6Og3QPP3RiovPBnhzwEHS3izJlNYb8xU0J0gbuHVUfhgLA
	oQEfRMTphK0kHJ7NU4FZdxBL1GEs7zTTsQdLfB5YgZpq+GVum6eanCTjxSNxQ+o99fqML7
	RwKwuz1vixHiQnSP8HXuB141zdVdmbM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-E7-JzknKNnKg5-BU0msqHQ-1; Tue, 07 Oct 2025 09:51:49 -0400
X-MC-Unique: E7-JzknKNnKg5-BU0msqHQ-1
X-Mimecast-MFC-AGG-ID: E7-JzknKNnKg5-BU0msqHQ_1759845109
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8635d475523so1243535485a.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 06:51:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759845109; x=1760449909;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KrQVt4Oy0c+QhuB8BTSmtP+2slJhAn2k60X6LTe3UUI=;
        b=GlQAufh120jtbnsEdhdJzZpRiRZfVD6ZPM64CbqWQz0HlgmPik2tMPn4H9vswAc7r4
         Nn112Y3PASn9Qhp/QcRAxSDu0rb0T4C8YM1lzk/ii2O9DlN0sELpCP2Zi2/egwI+FgfZ
         bWjDPoyFLBJ9wGeY73DYxAQFXtU6ERmhI/2xt7YxYr4/L546ZXY7yYJbcJ6u9XxkmNVA
         +t1B5sNo5tIkTtzTqU2kcvToH5LTPn4f5yHU84yI3NUDg+1Bmt1DSfbXUPGvgb/xM3/P
         zY3wXiG+3GHhKYxgFtIuZwlXfc4XUVPqkMrPa3GaUutn+S9kHmB6fr82TBjbrQyC0/nM
         t7RQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgLaG9m2C8Ln6Ql2DJgCZe81LB5/A3jaaBtEdj7wKyGYm3IAJZFrtw5hvK/xrHUt4w2QDNgR/xKA==@kvack.org
X-Gm-Message-State: AOJu0YwMmvWFLTMQz5GIamYT4PIzxlAvGqC87uJm+viTFRVJx9+NHwly
	csH2RmzHuv8IdCGU5Kam3KkRLz7y/q9Ot6A97WE/eE+FjvI1QnOXj/mrS9RzTmqjKZHMyqKd5PK
	hmYZNVm1HnXerfNKn2H7FvNl7sb3qyz3EPZ0PVyYhuP0yJako8SoF
X-Gm-Gg: ASbGnctiE0Ww+KsVBsWCgCFWtEY9w0WAabn1rxG0uxDO7wvTegGGJVBstqG82rA8+kk
	u41tRWAn6qi49e8knODcMKVp8rE/HOuLWH8kSXJX2mqKTNxAYf1Z5//0RTOBE7LJ4X3KRSm4+1m
	YQCHcbQO1ZlTwB+87KUkLMoOUtHr5+Q50slEPZOc8NHMDcytqYZrKn1OOGoTYGevpvVijODVJk1
	Bw9qNa8qaHJF4SgEJwDS+y3rEH4OTQ+Hz/myjFjLcaZYaeK8Z/RoJmXdUtBdokb89Pe1qKtS84l
	65jX8dEbAzGtvALRbTLBJ8+cxhcSA57yT5RnnQ==
X-Received: by 2002:a05:620a:290d:b0:864:e52f:311f with SMTP id af79cd13be357-87a346cc53dmr2292106985a.6.1759845108521;
        Tue, 07 Oct 2025 06:51:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyTN7ORuYSWPTrnejt1+QGmPLwI0L8U3s7S0+xuWtUbchmNvNTcasASdPK+56R/Qk+2jQJow==
X-Received: by 2002:a05:620a:290d:b0:864:e52f:311f with SMTP id af79cd13be357-87a346cc53dmr2292098985a.6.1759845107717;
        Tue, 07 Oct 2025 06:51:47 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e55a4448desm143437771cf.9.2025.10.07.06.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 06:51:47 -0700 (PDT)
Date: Tue, 7 Oct 2025 09:51:44 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aOUa8C8bhWvo5TbV@x1.local>
References: <aNwmE11LirPtEuGW@x1.local>
 <f409cbe7-7865-45ab-af9a-6d5108bc5ad4@redhat.com>
 <aNw_GrZsql_M04T0@x1.local>
 <43d78ba7-8829-4a19-bdf3-d192a62cdac4@redhat.com>
 <aN08NxRLz7Wx0Qh4@x1.local>
 <ad124fb6-a712-4cf5-8a7e-2abacbc2e4be@redhat.com>
 <aN_XZbQjuYx-OnFr@x1.local>
 <cq3zcvnajs55zr7cplf5oxxjoh54fb7tvo23hehd5dmh4atvum@6274mneik6hu>
 <aOQuZy_Hpu1yyu29@x1.local>
 <akld3v2mtnjdqvs5dgwr4gnffdqf5dojwhmfylq3mkfzakjj7j@5oqqxsymkcbp>
MIME-Version: 1.0
In-Reply-To: <akld3v2mtnjdqvs5dgwr4gnffdqf5dojwhmfylq3mkfzakjj7j@5oqqxsymkcbp>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -Vr-Hq8RD80EQwp8TCG_CPsVylQMkg-Mo13sYLFb-pY_1759845109
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BD0940004
X-Rspamd-Server: rspam02
X-Stat-Signature: p3wpdsk5ygnht77j9hapzenmryck3smw
X-HE-Tag: 1759845110-432342
X-HE-Meta: U2FsdGVkX18V5aWLsfM96slmjbnjEfd+lxZOr6cD+rAt52ICCfRZ43etwBo6UPQmzlV5bxZw6v06BlLrKlrCT7bBuC1Z2Vif2kaeReEq8EeskFYI++NlCNojmv6CqhRbqBUCm0xuwZPX/boj14RnyXvHapzqI4h1dSjtpl8Io261ow2SbJoY81Ahw2zqo7osfQr29RloMfs1XmZckhvCDqzQthems2nYfvjmeCz33HqPUe0T3ZKV+ZhKrMlT2Ta8DCKdPt5w/8aw3ls/cSl1E+K7C7U1YOz1pCHG5boye0WPl279O75RwRTjICorWZ0nQFi4zNYBdj4Xri1k+BSGox6a/oiByKTyVgTxzLlvIahNH3D+oszlqXnqNYNo0wOgYT7CthXKV73vCkmOupO69TEF+bWGhtCMeVY0bHuVXUTeTOtIG9Bk1UE4bKiI9aotr0SqBG2WWYhB5CZxiWxMlno9/qPt0TIYWPAYRnV3EIE1bBoWNWvda1Jpwm2tdDk43llWJWulAk5KP0naX7qX5NwtehyYv1jxe1ifEqQiaPZWxpiwRTlRBFQBnUTQFiTwvBXYqeUOZfduV0G9Fy8Um2nS6GU9xMcGD5XG2ro4bpKjazsFgbeDv1H+DMyrEYAXBni5tU7JryX3WUx/zX/1kr2d7YrOCUwrGBmPXMzyExuFqyAhTKPvJBnj+GakeNtIX3cKThAq3iR2xRE21KTQYZ8X83mFMGfKZqqf/Haow00g46lFc7EQgUpTJnZ7nql0l6Y7BAswNzjQYFEalDHhVEnLRaj+jo7cBm6viT/KYYXWVb5w2ubtu6RtbwenEwSgT7Pwy9uSV6tOhZEKANPKOa00WRFpwXaUHC6YiEzU2jn50qLZEmG62gfaDhVdODKEankoXs2x0+xXEBDtBbyG/+D2jhXzXaDlfs8GbzXeeA2Tk7KB7zAgybB2/oGw3pKIleUP/8R3y6DBg6636HQ
 oOO8949c
 45Unj6iAIBFp3vTIjWA0+WvIw9FCyVuenjueBVYiKnhvenRjSFmBbHFZY9L0iY+Cqq7Am8OawRXN9WSYSNXOxqXFpEOgZPsnzQTfWfBQdxRtwmlsW3IQskem5i6g/Lf6ADLuU+0OQl/omOx6XCwCCIEDZDrZSAa4QniWEplJ+vm9H58SFvB3sd7FtvenoF3/r+DXAvBpTrTtuVIOxEh1DP96k3Z4U+SdhsztyXF+NWIM6AA6k3ZPpOdHSJyp5uX+X3LEQoa2s5WjpSuzM1uhejcp69y3H7cnRcxRd9tpOejcDkpcKkR/C9ajJwOyqOCXMvFpnPasxHl8jUAUrDslFth00TQxt5V2xt6ywSUxhCIZajynhyHNi4BZzAICMlOOWOQw2mdeWsnspXUHfh4nUAN1zvvv11XX2YJXILmslOt4ICV06nBR8bV2GxaFQS0HCjuC01D7bmxYkcUoCIBAVlUpB/9pfRNNdHO9adWoY22zkACrj62d2hEsa539Hy7zaYGwVVIqgcOv2o8bK9PS7PGyIWD0qvttuNGCBq8U4MOXx2DhO0B9DfIWRiNANFPBg6tjClk51fRjLmhRrTkTD/DEvUj2aFK8E5dsA0q6re5DDQzw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 11:31:19PM -0400, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [251006 17:02]:
> > On Mon, Oct 06, 2025 at 03:06:39PM -0400, Liam R. Howlett wrote:
> > > * Peter Xu <peterx@redhat.com> [251003 10:02]:
> > > > On Wed, Oct 01, 2025 at 04:39:50PM +0200, David Hildenbrand wrote:
> > > > > On 01.10.25 16:35, Peter Xu wrote:
> > > > > > On Wed, Oct 01, 2025 at 03:58:14PM +0200, David Hildenbrand wrote:
> > > > > > > > > > > I briefly wondered whether we could use actual UFFD_FEATURE_* here, but they
> > > > > > > > > > > are rather unsuited for this case here (e.g., different feature flags for
> > > > > > > > > > > hugetlb support/shmem support etc).
> > > 
> > > I think this supports the need for a code clean up before applying an
> > > API that generalizes it?
> > > 
> > > I would expect the uffd code that needs the same uffd_feature would
> > > logically have the same uffd flags for the uffd_ops, but that's not the
> > > case here?
> > > 
> > > Is this because uffd_feature != UFFD_FEATURE_* ... or are the internal
> > > UFFD_FEATURE_* not the same thing?
> > > 
> > > > > > > > > > > 
> > > > > > > > > > > But reading "uffd_ioctls" below, can't we derive the suitable vma flags from
> > > > > > > > > > > the supported ioctls?
> > > > > > > > > > > 
> > > > > > > > > > > _UFFDIO_COPY | _UFDIO_ZEROPAGE -> VM_UFFD_MISSING
> > > > > > > > > > > _UFFDIO_WRITEPROTECT -> VM_UFFD_WP
> > > > > > > > > > > _UFFDIO_CONTINUE -> VM_UFFD_MINOR
> > > > > > > > > > 
> > > > > > > > > > Yes we can deduce that, but it'll be unclear then when one stares at a
> > > > > > > > > > bunch of ioctls and cannot easily digest the modes the memory type
> > > > > > > > > > supports.  Here, the modes should be the most straightforward way to
> > > > > > > > > > describe the capability of a memory type.
> > > > > > > > > 
> > > > > > > > > I rather dislike the current split approach between vm-flags and ioctls.
> > > > > > > > > 
> > > > > > > > > I briefly thought about abstracting it for internal purposes further and
> > > > > > > > > just have some internal backend ("memory type") flags.
> > > > > > > > > 
> > > > > > > > > UFFD_BACKEND_FEAT_MISSING -> _UFFDIO_COPY and VM_UFFD_MISSING
> > > > > > > > > UFFD_BACKEND_FEAT_ZEROPAGE -> _UFDIO_ZEROPAGE
> > > > > > > > > UFFD_BACKEND_FEAT_WP -> _UFFDIO_WRITEPROTECT and VM_UFFD_WP
> > > > > > > > > UFFD_BACKEND_FEAT_MINOR -> _UFFDIO_CONTINUE and VM_UFFD_MINOR
> > > > > > > > > UFFD_BACKEND_FEAT_POISON -> _UFFDIO_POISON
> > > > > > > > 
> > > > > > > > This layer of mapping can be helpful to some, but maybe confusing to
> > > > > > > > others.. who is familiar with existing userfaultfd definitions.
> > > > > > > > 
> > > > > > > 
> > > > > > > Just wondering, is this confusing to you, and if so, which part?
> > > > > > > 
> > > > > > > To me it makes perfect sense and cleans up this API and not have to sets of
> > > > > > > flags that are somehow interlinked.
> > > > > > 
> > > > > > It adds the extra layer of mapping that will only be used in vm_uffd_ops
> > > > > > and the helper that will consume it.
> > > > > 
> > > > > Agreed, while making the API cleaner. I don't easily see what's confusing
> > > > > about that, though.
> > > > 
> > > > It will introduce another set of userfaultfd features, making it hard to
> > > > say what is the difference between the new set and UFFD_FEATURE_*.
> > > 
> > > If it's not using UFFD_FEATURE_ defines, then please don't use
> > > uffd_feature for it in the uffd_ops.  That seems like a recipe for
> > > confusion.
> > > 
> > > > 
> > > > > 
> > > > > I think it can be done with a handful of LOC and avoid having to use VM_
> > > > > flags in this API.
> > > > 
> > > > I waited for a few days, unfortunately we didn't get a second opinion.
> > > 
> > > Sorry, been pretty busy here.
> > > 
> > > If we can avoid the flags/features, then I'd rather that (the derived
> > > from uffd_ops == NULL for support).  We can always add something else
> > > later.
> > > 
> > > If we have to have a feature/flag setting, then please avoid using
> > > uffd_feature unless we use it with UFFD_FEATURE_ - which I think, we've
> > > ruled out?
> > 
> > Yes, there was no plan to use UFFD_FEATURE_* in vm_uffd_ops.  It's because
> > UFFD_FEATURE_* was introduced to almost let userapp have a way to probe the
> > capability of the kernel, rather than the layer to describe what features
> > userfaultfd has.
> > 
> > For example, we have UFFD_FEATURE_MISSING_SHMEM declaring that "the current
> > kernel supports MISSING mode userfaultfd on shmem".  This feature flag is
> > essentially of no use for any other memory types, hence not applicable to
> > vm_uffd_ops.  OTOH, we don't have a feature flag to represent "userfaultfd
> > MISSING mode".
> > 
> 
> hehe, the overloaded terms here are numerous, but I think I get what you
> are saying.  It's funny that FEATURE_MISSING isn't a check for a missing
> feature, but really to check if the register mode missing is available.
> 
> I'd also rather not have ioctls and features/flags.  It seems reasonable
> to drop the ioctl, like David said.
> 
> I assume there is some future plan for flags, or is this for versioning?
> 
> I'd like to one day even remove the suggested backend types and instead
> use handlers in the uffd_ops directly, although it is difficult to know
> if this is reasonable today.

The current proposal will be two fields (modes_supported,
ioctls_supported).  If we add yet another feature-backend flags, that will
only be used to map to the two fields but using one flag.

Could you elaborate what's the handler you described?  Is that one handler
returning both of the fields?

If so, I'd prefer that rather than introducing feature-backend flags,
because I want to avoid introducing another different feature set to uffd.

Thanks,

-- 
Peter Xu


