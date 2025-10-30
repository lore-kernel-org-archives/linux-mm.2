Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A12FCCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 11:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93438E01BE; Thu, 30 Oct 2025 07:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A7D8E007D; Thu, 30 Oct 2025 07:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980968E01BE; Thu, 30 Oct 2025 07:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8424A8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 07:43:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 244B189393
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:43:30 +0000 (UTC)
X-FDA: 84054595380.14.B3905CB
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 50EF51C0014
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:43:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lDOcF7uN;
	spf=pass (imf21.hostedemail.com: domain of 3Xk8DaQkKCFk1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3Xk8DaQkKCFk1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761824608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDSI58A/HQKOUf6eeXjJJOZLO/JqDx1ROCyXyTZAY7w=;
	b=kOIJMiVo49ivY7vrE5k9xp8sLdr6il7binFRJMsS2aVDkSi+fsZ83g5n46+flOdWfEFQLY
	+rMlf/m21K1ch6h2nOVAeUSsnKU6nUEm4Tu4cBjrX+vF4/V/ppgIl+CT2fKA+dYW2x2oZm
	IEyLDE/OeeqrPZlb32Wleay1rY5Eo04=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lDOcF7uN;
	spf=pass (imf21.hostedemail.com: domain of 3Xk8DaQkKCFk1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3Xk8DaQkKCFk1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761824608; a=rsa-sha256;
	cv=none;
	b=OoSYtauqAaWPppyg00dLPjIt3mrVkxt2Btj9bAzAq948hr5mjeg0NZZCLlMY5MwAGpSvNJ
	56GpYkVihoRC+XfS0UxxwR1edEfNOcH2ZJ3omGyD4q85RfhAhLE3Lu7e3SEMjJtiX+7c28
	1EmozkIvti+AJ20cqpsLm6e2npHAp14=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-427a125c925so460644f8f.2
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761824607; x=1762429407; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nDSI58A/HQKOUf6eeXjJJOZLO/JqDx1ROCyXyTZAY7w=;
        b=lDOcF7uNBihkZBkqi1zEFIppknqbN4CdsWbJQIKBsPNRYQvX/8X6QWGSeydvhlM0hD
         pmDTktCUhw+5zuiRTKt59UV+PxSgSBbJF7k3hjZwDhcnPnaa/wbzUECweJelfeqC9GBX
         kpQ3BpDN0qozc/XIwer4c5MS6gBna+PppmhsOfYU6tq/RNqtQXHBvICzV4risau4T5cQ
         2XlA7g9ooJy6jaZ5ONtKHBV0eBvVypYRFJgHaxhRJgqHsDzXWbls4cNzhaPWvusOhP/h
         JoA+kAULJil6D+o7BZUiH3xmonDjytOTOlsK9gW4aUqlJI/h8ROpdF7BpqUFUCVZ+jLt
         dwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761824607; x=1762429407;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nDSI58A/HQKOUf6eeXjJJOZLO/JqDx1ROCyXyTZAY7w=;
        b=oGqCllYAhs+h9joIk1kjbirWptSc17USZqwZVdo4VV9EXn/NujIL4IRXwy7+BxCzD0
         3Z8nEt8gfx5Op35WhEXLqKa9gUEBiVePkiPdKWUiBIwe7WcddUo3YK2T6TFJFFZT+FIJ
         UeCZy5DHaMr5V2RzWADETyTEGYutGgXbZcXnZkiC9NaAq4jQklArnI67AhTEcz/3urrX
         bWH0WG98PXjBNrs4WT0KukVYU6IOrfDwm97vzf8tLOHFjbdaWOyX7tuu3TZ5EqkB4MJ8
         PvzPccz/cik1N2+KTiNG94kiKdlyFexWdW/xuIagJsgss0RkMrksRj1REwHQRW18DehD
         iltw==
X-Forwarded-Encrypted: i=1; AJvYcCVnce4iUxaeDd2H/rGWFH6BpsrNmvYL+aF7Mk5w/SgdDrfVPQP4djC8fy4xhvAQUGpXc8Xtu85GOw==@kvack.org
X-Gm-Message-State: AOJu0Ywj3uN32pMpkhh8GGdw8LkRCGWvCaunqr2ziM84+opsdbgR6if4
	SFFw9g/pe8bI9xgiYcZAsjd8Q+bZWA3X5C6wczHSFuxQwmjEqTSLGXaD5BqcRrfkSd8Vt2qMH6a
	FW9embeaHpGvH9Ib5gQ==
X-Google-Smtp-Source: AGHT+IHzjpoD898gBgMNPMdZP5uEYogpZiJA8uErDROog5MEOI5DpnJbAzYLVH3kmqrIf4gyzUsqqY51Um1rkCk=
X-Received: from wrme11.prod.google.com ([2002:adf:e38b:0:b0:3ec:e23c:988f])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:290f:b0:429:58f:325 with SMTP id ffacd0b85a97d-429aef830c6mr5166773f8f.24.1761824606490;
 Thu, 30 Oct 2025 04:43:26 -0700 (PDT)
Date: Thu, 30 Oct 2025 11:43:25 +0000
In-Reply-To: <4e6d3f7b-551f-4cbf-8c00-2b9bb1f54d68@lucifer.local>
Mime-Version: 1.0
References: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
 <CAA1CXcCiS37Kw78pam3=htBX5FvtbFOWvYNA0nPWLyE93HPtwA@mail.gmail.com> <4e6d3f7b-551f-4cbf-8c00-2b9bb1f54d68@lucifer.local>
Message-ID: <aQNPXcxcxcX3Lwv0@google.com>
Subject: Re: [PATCH 0/4] initial work on making VMA flags a bitmap
From: Alice Ryhl <aliceryhl@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Peter Xu <peterx@redhat.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jann Horn <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Pedro Falcato <pfalcato@suse.de>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 50EF51C0014
X-Stat-Signature: fgopco1pswee5rqtibtdm6oc8of8f4tr
X-Rspam-User: 
X-HE-Tag: 1761824608-231463
X-HE-Meta: U2FsdGVkX1/PzrnhonuDRzVQeTi9RYw7rFW1Ch13u1xivzwNasC4Ms5Q6GILvXvrm2E6g89tcV/bqFtgnGUWIi4Al4PCjv+VdXgUxEwTQN7jzB0DuiF2q1ImS9QVuGKfVI+jMss7YE0Gnj/Knw5btkf1lrXZX1wqBCXs5nMRJ1XEGRvDPqizluZ7VLtXdPfeAGCvvuMWrwqJlACxcQOTgAwAPjrL9Hcl0d9lZp/s49sXdUrn87oN1z1WcRrNAN0ye+ozO9/H+5kp0WFv+o9rG659QATaByjnUG1RUjkNSWvrEkAANOi4GQFDAtGx/rnERImS3YfWLAB28dPIbf46C3G89jlCr7PUQ8Spb6jXlEKiK8guIRAHVIH9TbnUM9e+Bi7gmQKyrqgr9y5zqgicxIXe06xFGESqR/XJRzTL4vP5VHx2zKW8c2L63GwIjJucgRYI/dM8Qx+Z8FdJCRhrR4kzs+zzQjx+0i5G+hfRFjFJebxRabGTZyihThahl982yx+OWErF9dfrrJ88AmWuGP1StP/ci+hVk9UZEbB4jYO/EPXvVBzMfo0r/viV2yHY71oXzaNHHIPes/LU9ro/vPT1uwvFeN5dX87U/E9Br4BYXaFjlhp1oqC9RCHgqFRCmiUv0QQwRdVW5sdihvzfouVhwsTO3ZLw8LQ/wX64lHJ0FuXIJ4/4jQXXUsPMdO3/tk7HHZi/EkgfUWSrnbuQuGsvtokmsRiS6ElM0/tRK0uew57FW91YHHPG08Ioo2eaX2JR+m4uiDQkUy+XsIGaka1UJYF+Vw+LrfOGIUhCoFN52wr+bRElO0evMM7lI1XUh1FkarYYFX7liYphM05q/VeOdmGJMHR0kibv5oroVbg+zTmcP0au+8vQtsoy+Bduu4oDCHBGnAYPnRT3yWB8AXKAOCCKzaS08APRaLbMUaozsPP09Fl32TmBqzNiQ6zO3R8fGu5NQEvfgGHUr6i
 QhB/0UmB
 SEzlKjESA42F1d5odvQ69T/oLxX/sZ2o6eMd47dRmtNS31CeGAbBAiNUcsBdEZ5CWA3DNHyk/LE8vrlgyESQJaIvy/Y5ggSB2Atc5+7IXdODgBJvHbmI5XHdEUzuDpdvbXp4eDg0HoF0/++j+t5lfBqxG35B/kPLl+20deyTnqyLAi8HA12llrrEmcrjTTF6EuAbluxxHBw0HGD3u/OsurBHSn4RlDkQqF7IU1Mrh00tNDdE1JD55lX7k/mpfmHi7FbRcL9uokFdZAJRUVNh9ts1DfeDUcNYycDsGATSX4WDw8ix3zppXt1HZgbr9Y9Sufgci+G3jqDIXnEtA5hkdlangUbcyCnsPaJ1HB+VQxgwtG+VSBXhbyRXfL9w6OCCtTF95CjBy6ChC787DU1t0dpfihKxH5Oc7lUZDIeAKI2HqFiQhItx8+Q5Zn0O80auFg0vhQbyq/vY9r8wJFGbDdVvHE48dwKvvevc6roxWiyiPB64u2G3c1186tB08YMQJ5qGOcGqlDvP9hJJazARB7sVHeocJczgWbT5B9JAD2vwtaT8PMdgQpgWpEDTPeovnNmOZdH+vj6cfEC0YSUOl1qr2BsmSK4LcuHhX2KlQeO8sBSC9tcxuRbXD3s2bjdLA1NWxFQVkEMD/MzQrkY/aBVGiTTbUMbuF0kxD1amBeAWDcdyWF+usXCXXol7srfrFAYLX+W45elMov00rYNn6gLAvaTmflODDqatW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 08:33:10AM +0000, Lorenzo Stoakes wrote:
> +cc Alice - could you help look at this? It seems I have broken the rust
> bindings here :)
> 
> Thanks!
> 
> On Wed, Oct 29, 2025 at 09:07:07PM -0600, Nico Pache wrote:
> > Hey Lorenzo,
> >
> > I put your patchset into the Fedora Koji system to run some CI on it for you.
> >
> > It failed to build due to what looks like some Rust bindings.
> >
> > Heres the build: https://koji.fedoraproject.org/koji/taskinfo?taskID=138547842
> >
> > And x86 build logs:
> > https://kojipkgs.fedoraproject.org//work/tasks/7966/138547966/build.log
> >
> > The error is pretty large but here's a snippet if you want an idea
> >
> > error[E0425]: cannot find value `VM_READ` in crate `bindings`
> >    --> rust/kernel/mm/virt.rs:399:44
> >     |
> > 399 |     pub const READ: vm_flags_t = bindings::VM_READ as vm_flags_t;
> >     |                                            ^^^^^^^ not found in `bindings`
> > error[E0425]: cannot find value `VM_WRITE` in crate `bindings`
> >    --> rust/kernel/mm/virt.rs:402:45
> >     |
> > 402 |     pub const WRITE: vm_flags_t = bindings::VM_WRITE as vm_flags_t;
> >     |                                             ^^^^^^^^ not found
> > in `bindings`
> > error[E0425]: cannot find value `VM_EXEC` in crate `bindings`
> >      --> rust/kernel/mm/virt.rs:405:44
> >       |
> >   405 |     pub const EXEC: vm_flags_t = bindings::VM_EXEC as vm_flags_t;
> >       |                                            ^^^^^^^ help: a
> > constant with a similar name exists: `ET_EXEC`
> >       |
> >      ::: /builddir/build/BUILD/kernel-6.18.0-build/kernel-6.18-rc3-16-ge53642b87a4f/linux-6.18.0-0.rc3.e53642b87a4f.31.bitvma.fc44.x86_64/rust/bindings/bindings_generated.rs:13881:1
> >       |
> > 13881 | pub const ET_EXEC: u32 = 2;
> >       | ---------------------- similarly named constant `ET_EXEC` defined here
> > error[E0425]: cannot find value `VM_SHARED` in crate `bindings`
> >    --> rust/kernel/mm/virt.rs:408:46
> >     |
> > 408 |     pub const SHARED: vm_flags_t = bindings::VM_SHARED as vm_flags_t;
> >     |                                              ^^^^^^^^^ not found
> > in `bindings`
> >
> > In the next version Ill do the same and continue with the CI testing for you!
> 
> Thanks much appreciated :)
> 
> It seems I broke the rust bindings (clearly), have pinged Alice to have a
> look!
> 
> May try and repro my side to see if there's something trivial that I could
> take a look at.
> 
> I ran this through mm self tests, allmodconfig + a bunch of other checks
> but ofc enabling rust was not one, I should probably update my scripts [0]
> to do that too :)
> 
> Cheers, Lorenzo
> 
> [0]:https://github.com/lorenzo-stoakes/review-scripts

I can help convert the Rust bindings to work with this approach. I see
there is a nice and simple vma_test() method for checking a flag, but I
don't see any equivalent method for setting or unsetting a given bit.
What would be the best function for Rust to call to set or unset a given
bit in the vma flags?

Alice

