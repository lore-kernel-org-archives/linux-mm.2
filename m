Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF542FD8FEC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037986B00A3; Thu, 26 Feb 2026 13:08:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C266B0138; Thu, 26 Feb 2026 13:08:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E53196B0182; Thu, 26 Feb 2026 13:08:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB7FF6B00A3
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:08:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9230F14025E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:08:26 +0000 (UTC)
X-FDA: 84487392612.15.7EFBD8E
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id AC4D280009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:08:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TlptwlK8;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772129304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wcq9MDR3n757j4ORZwFr28h6INReHt+LZDRBVW4SzF0=;
	b=VOjL6rTMqIy0gfJ0bLpIbzuppPv+VzW5c8D2X3DoVMq+TDS+GQjtr7+u/EatKZn2Kw+/d9
	c0cnwZ3LqwpxlHuz0lPeorv4IxqTCBWm+D/XIOFjupuwebpT7Vdf7bnIW9ahp1ypQuFS8W
	MDzoighjY/1JrgJ7PPCmcI4tdMP6lW8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TlptwlK8;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772129304; a=rsa-sha256;
	cv=none;
	b=ToI3Lbs7tFaTCgsyaHUWLsgVGLKyqUETbE2Ja/q2mZoEUVJkLChyMH/svjolEbNvlCArKP
	RIcKZsmmBLBnJ0DzZ/PrY13U9k6EXxjnivJemdxuRgaWcLueZp4UTynIN4F3jrWbkDPdet
	pkYCMre2Sl1Lw5wuAkLaYv2qEn8fJDs=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7d4c383f2fcso1037678a34.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772129303; x=1772734103; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wcq9MDR3n757j4ORZwFr28h6INReHt+LZDRBVW4SzF0=;
        b=TlptwlK89zTDNGxlH0F2TjWzU5qSTUd08ngPChQnlbT4RK8aveIsPv51hMiVRcLMFN
         uM8+s3llzpUk5vgjLdZEcBukzFS/THrc396TOgvpEjev4HtB1jypraMQ2GaPZ1kx7xvu
         Hee1WPJjeeHzt/C7BFBxgOg4AGxPNw8euy5q4d0NIXTX7gf61NVCLPrXQNpkvPLvtaZu
         WSC21YijZGdelpT6Wd5Q9i2+aYx6Ix0vU4RCejZJ+jTxqBBwi7tkKLVO79MQ398Y4QOx
         hkBnvC1Bv67Y5XQCLWkrfdCnV1yfVO2US6IBW09JhyzNURQil94tF6H3p3GGHsPTVk8P
         xgkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772129303; x=1772734103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wcq9MDR3n757j4ORZwFr28h6INReHt+LZDRBVW4SzF0=;
        b=wLQ+/hSHkwMmR6iavEqdsxP29Y1ny/96qk4dLafYlAQReNESO5AxdG2LSuo7LhRmRb
         CNy9tQKDmSFYT9Os94LVeTJXkYXM09eIiqwZti1MJ1cVaFl/wlD5Oe3h1UI8fAZu6OCC
         X2at/yLREU7aEeD+o+bjMp3/tf9/kolL4pTLpVvwxTvE0JbMi4N25tISHCw8NUQjpx/k
         ENAnK7uJfH+S0HVoWyUI5FeE5TigilH8aUhJ7UXv4NDip21fr4rW6Znh6tn75c0J6N4D
         FKjFkcQYoR/oJ4/rVi1ebBLwJYzgMtm+Q/1wOJ5NDpbNi9FU8aIB37X2nHk0HNAGnHqf
         Jkdg==
X-Forwarded-Encrypted: i=1; AJvYcCV2Egu3BGLphBtgX/WNyXeUlw/ovrfY2Ys/e8jGJ7fxtT5/gKCHKRlxS8TcLb3wsx66XioN5n7aCw==@kvack.org
X-Gm-Message-State: AOJu0YydJvDpV+iaYtElpAKf0ysB7CYgFpNejrhfrBfKp1+uBcPY/ig/
	hy+Cu/9NHCezBW4ZbojK5IirQ8FV7tRzmLePOwSdDQMbUHN+PTlKFuhi
X-Gm-Gg: ATEYQzwtd0RdwGaOolzhHo3GXlo6i5CybEr6j88Txc5elk/cZBCitCSvpcpfBt6kQos
	vR79y5P2Q4H1/yEEJgkGufNeBvN6eLgV1UdG4J+X5cbxcdIvTiR8UdyOaPzKM6b0o7jE10isMIL
	Wkf3OvPvNxmnjww8Q62U/tDVpSPAtyqPpLANtrYTktwLUPGKk1E12mBrm4gIRCw5Frc6ft+2+LT
	kFgSgtGmfPXSFetj8RRfQlLhoUGd8ZsO9easKYoO8e/bFlDlXNq9ksh3nRfE/M7pOz6O9bKc1fg
	ZZ3ABEd7B+UInJamhHabADq++0AzQo6h7kcYRRwgiDOvDH24fUvg2ivvDIUIHWswE0hZ7T1XcJU
	V2qUewmgMkaLJrR4x7kQ9hF+8p0NPJGcVEmXLyaZySlIS+0innYI20PpezHDC/j1bjsOtncjzI0
	LdyexhaYF+KFJO5RNmco4vTxtmMUrTDI4U
X-Received: by 2002:a05:6830:6201:b0:7d4:96c3:3f97 with SMTP id 46e09a7af769-7d591b0f5acmr73197a34.2.1772129303538;
        Thu, 26 Feb 2026 10:08:23 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d58666ed17sm2433431a34.27.2026.02.26.10.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 10:08:23 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: akpm@linux-foundation.org,
	dan.j.williams@intel.com,
	david@kernel.org,
	fvdl@google.com,
	hannes@cmpxchg.org,
	jgg@nvidia.com,
	jiaqiyan@google.com,
	jthoughton@google.com,
	kalyazin@amazon.com,
	mhocko@kernel.org,
	michael.roth@amd.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	pasha.tatashin@soleen.com,
	pbonzini@redhat.com,
	peterx@redhat.com,
	pratyush@kernel.org,
	rick.p.edgecombe@intel.com,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	seanjc@google.com,
	shakeel.butt@linux.dev,
	shivankg@amd.com,
	vannapurve@google.com,
	yan.y.zhao@intel.com,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 0/7] Open HugeTLB allocation routine for more generic use
Date: Thu, 26 Feb 2026 10:08:21 -0800
Message-ID: <20260226180821.2218448-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAEvNRgGaJXbOGPQSgvo3rVDfis22DC4hYy=2Rczas0Vm3o66kQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 93jthc9j7gbphr17k38gt1691cmnxms8
X-Rspamd-Queue-Id: AC4D280009
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772129304-993536
X-HE-Meta: U2FsdGVkX1+UzsGLLSosz8MCPaI3rPwdbWqSfd+K4nb75WAMPdxWseKdbKxqdmgVz9y/SemMcMYipcV3fMBNlfXQ4nN35pp4JetI5dXCRWeIyRb0FcIEzrAwKgEkkeAC6AeI6Tjgc1Lg4rBBEED9XKRBxtbzOaAM5B9zOfz9rtBjMXb94n4zz8/K7bXoM+YEk3fLmxjuzvyMWjrElr2LuTCqOsaP+qlfuPyVRNuypNyzQqd33kFnyaqQoiQLyOqULVrBRti8EenAeGzlcoe6aL/PqEMJZv3DG9Y/r6QyHJS5iZ/CPYhC0R5IBzjWsgJD+yQ2cosQd616pY8kObAI14loyNmWICzJpMl7Ncwmq2J4l7U4pGK/zMoe/0tScMyczS9ZpQbNo5luQvsx+I4ymdN7VGeJ7+kxrCvihSZrsNmCqmaDBCDuSoMbIQvcJ7aL0bhA9UA2xNT/aA14NS+903n87Bcg2BvQ3avA63BNwAZAnUnK/eMpF3GPF9YFqdjzeWk96OZr3AcvcZgBu894pYclf47vgzqnX/+dC5rg1C4bex5OkKbZbHUUI4mnwWlsWk7Odfnb5fLp0lkuR6BZ4px6rQKLtwrXZKcn50OAjwqwg2zdQuox2IdGREp69fX3AGKJEtN+FT+zk3JdpK97AOB8Dj6jmC2Xm+72vdoWQAR8sHFvti4QdlZEOAjKnCloqgUKgldQsYqwqfd7QtgBON/jRtU190b8CnV9EKJlD4JSJ6uihFHry694+xov9ygBk+uWpKQl8std1TvZOSp03dSFslsZ/Q4Ylbg9S3fUftCqEj5i6vChFmDrxPxFXrh9skZymH0Rf3TpYrK1CCsLZWuJgObAUONSNTz6LMbrFBQZsM9NV7MgXTOsH9zSzeZxtBOVMUDGrISbA9ckaYkMOmEEjeLBaXRwekWYIYe39Z084MwmyhkcbIcX5VQeM9K07XI2QqjQ6uFNRlO3Z3q
 P5rozHsh
 gvNJycaR3NedNB9OfRqjw9WYgW5gTlmyOVM+UWDjpit2eqFgEIp+JcSYZoVZw7nW5/oRAss+tNltVAA2oTO+FXquyCV+zbBBJsP4FGTc8vfdvdO/F4lmMh1O9sTXHzSCMYeh5cpENTQCOSVTzkp1XbQ4AZKOzDtvA+yB1mfUQwCIA+58J6M7i2Fjh5z6M4t6YAJkanUmGbGPhGMn0qbbGG86imGrrSDQAIec3QOGNESfX9yE66m2CEMHPBPEc8EnacCmJBNyTWmO7pz+9Vt3sKP/ihBYb5vADhIhnjhCG40gChTIjMvNPA+f8UjQad5oWeQfP5oTjlbcQNNRL5fNHZG3KTQCmPjbSGqYbWp3M+ThZfI7mWG2g51jkpyoFuFvkUIIvyXJjJpDqDjwQVCkX8liNWE2p9RfGB1qYE8D4E3HMTDaGX84ho/rj0nxdIIQaAsvNkmYZSBWxVoDuTAiKakMkoxR4OF8I6TaiJQm9qgzDBMTt6bBP6JSRXvdb1eHZNy8KAWeXqxaMJQsXa1Q+I+EJUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 19:37:04 -0800 Ackerley Tng <ackerleytng@google.com> wrote:

> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> 
> > On Wed, 11 Feb 2026 16:37:11 -0800 Ackerley Tng <ackerleytng@google.com> wrote:
> >
> > Hi Ackerly, I hope you're donig well!
> >
> > [...snip...]
> >
> >> I would like to get feedback on:
> >>
> >> 1. Opening up HugeTLB's allocation for more generic use
> >
> > I'm not entirely familiar with guest_memfd, so pleae excuse my ignorance
> > if I'm missing anything obvious.
> 
> Happy to take questions! Thank you for your thoughts and reviews!

Of course, thank you for your work, Ackerley!

> > But I'm wondering what hugeTLB offers
> > that other hugepage solutions cannot offer for guest_memfd, if the
> > goal of this series is to decouple it from hugeTLBfs.
> >
> 
> The one other huge page source that we've explored is THP pages from the
> buddy allocator. Compared to HugeTLB, huge pages from the buddy
> allocator
> 
> + Has a maximum size of 2M
> + Does not guarantee huge pages the way HugeTLB does - HugeTLB pages are
>   allocated at boot, and guest_memfd can reserve pages at guest_memfd
>   creation time.
> + Allocation of HugeTLB pages is also really fast, it's just dequeuing
>   from a preallocated pool

All of these make sense. Just wanted to know if guest_memfd had any
unique usecases for hugeTLB that normal hugetlbfs didn't have.

> The last reason to use HugeTLB is not because of any inherent advantage
> of using HugeTLB over other sources of huge pages, but for
> administrative/scheduling purposes:
> 
>   Given that existing non-guest_memfd workloads are already using
>   HugeTLB, for optimal scheduling, machine memory is already carved up
>   in HugeTLB pages for these workloads. Workloads that require using
>   guest_memfd (like Confidential VMs) must also use HugeTLB to
>   participate in optimial workload scheduling across machines.
> 
> >> 2. Reverting and re-adopting the try-commit-cancel protocol for memory
> >>    charging
> >
> > On the second point, I am wondering if reintroducing the try-commit-cancel
> > protocol is tied to factoring out hugetlb_alloc_folio. When I removed
> > the protocol a while back, the justification was that for the most part,
> > grabbing a hugetlb folio was a relatively cheap & fast operation, since
> > hugetlb mostly operates out of a preallocated pool.
> >
> > So the cost of being wrong, going above the limit, and having to return
> > the hugetlb folio was also relatively low.
> >
> 
> Thanks for this! I saw your patch to just optimistically grab a HugeTLB
> page :) For that patch, the primary reason was to simplify the logic,
> and the simplification was justifiable because grabbing a folio is
> cheap, right? (And so grabbing a folio being cheap wasn't a reason in
> itself?)

Yes, exactly!

> > It seems like this patch series introduces some new paths for hugetlb
> > pages to be consumed (specifically, without a reservation or vma).
> > I imagine that these new paths make the slowpath for hugetlb more frequent,
> > which makes the cost of assuming that the memcg limit is OK higher?
> > I think explicitly spelling this out in the justification for reintroducing
> > the charging protocol could be helpful.
> >
> 
> Yes, I should have done that. Will copy the following to the next
> revision.

Thank you for considering!

> The main reason is that reintroducing the charging protocol is the
> clearest way (for me) to cleanly refactor out hugetlb_alloc_folio()
> without worrying about the edge cases around HugeTLB reservations and
> charging.
> 
> If I didn't reintroduce the charging protocol, I would have to depend on
> freeing the new hugetlb folio on memcg charging failure, and the freeing
> in turn depends on the subpool correctly being set in the folio, and the
> presence of the subpool influences (in free_huge_folio()) whether the
> reservation was returned to the global hstate. Aaannnd... there's also a
> hugetlb_restore_reserve flag that controls whether to return the folio
> to the subpool (and the hstate). I find folio_clear_hugetlb_restore_reserve()
> on certain code paths kind of magical/unexplained too.

I see, if it makes the code simpler to introduce the protocol again, I see
no reason why we shouldn't revert the patch : -)

> I would rather iron out those charging and reservation details
> separately from this series (with more testing support).
> 
> On the other hand, reintroducing the charging protocol has the benefit
> of avoiding allocations (not just dequeuing, if surplus HugeTLB pages
> are required) if the memcg limit is hit. Also, if the original reason
> for removing the protocol was to simplify the code, refactoring out
> hugetlb_alloc_folio() also simplifies the code, and I think it's
> actually nice that memcg charging is done the same way as the other two
> (h_cg and h_cg_rsvd charging). After hugetlb_alloc_folio() is refactored
> out, the gotos make all three charging systems consistent and symmetric,
> which I think is nice to have :)
> 
> I hope the consistent/symmetric charging among all 3 systems is welcome,
> what do you think?

For the hugetlbfs case, the path to allocate a hugeTLB page on demand
makes sense, so I definitely see the argument for avoiding allocations.
Does guest_memfd also have a path to allocate a hugeTLB page outside of
the boottime reservations? In that case I think it would be nice to
clarify that the allocation failure case optimization is also for
guest_memfd, not only for hugetlbfs.

Symmetric charging is definitely welcome : -) All of your reasons make
sense to me, I just wanted to ask and make sure.

Thanks for your thoughts! I hope you have a great day!!
Joshua

