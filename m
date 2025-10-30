Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A88CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 09:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A938E013B; Thu, 30 Oct 2025 05:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0520A8E0112; Thu, 30 Oct 2025 05:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA418E013B; Thu, 30 Oct 2025 05:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D55FE8E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:23:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 455A612B515
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:23:29 +0000 (UTC)
X-FDA: 84054242538.25.5253787
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id E6DB120011
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:23:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VEiHr33f;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761816207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4JeRqvX7ZbkSQVSnZTmzlKVFPz7NTFo+cG7lq/is1Y=;
	b=0bOzyZ9HwXxl7CrSjphY1eXL8Fl9hQWsxJ8WFt437I1bLQLFFEqPycgrcjSUYOEIjqDSG3
	BJFv8RDZUz9CH1aRPzJDFPtOpxh6rXOrq4pyjdjgm1SOF3J61epzb83zdfLrHMtFTD7ivj
	HguQE+43luFMxp5Ni/O5Dit7uPEEJLQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761816207; a=rsa-sha256;
	cv=none;
	b=BEf+WYrHuR+LwHiCaY6BxEcnrco5b3pks19UHXm03pLmJDp40IIyERb4apQlttKlNYVyR8
	LRylalwU834V70aaCSDyRNDZCgXwDOCcMFPICTjY0PqHR9oOfcRzgKBDUBiX5gQ8wOTjUz
	KE6n4pnF5U2GEJUYPcbmQCkFIxljBIc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VEiHr33f;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761816206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e4JeRqvX7ZbkSQVSnZTmzlKVFPz7NTFo+cG7lq/is1Y=;
	b=VEiHr33fPeAiUFYSE1CCT4z6tVxfdiNaGJsYYZZkWhe6/fmn2jYJw0VhMZlK/AcL8tCraa
	OZS0uKM2xoDb+N6ZZh/NOODaypAgNACRzqLj/NFb7Vgl9IOLfOyHDKyhebbpiqxvfnlQa/
	qiiheyGKCVF5syg91tk5S0Nx+DJFaxQ=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-IqoA1oVLNzaN4hSlf6HKrg-1; Thu, 30 Oct 2025 05:23:24 -0400
X-MC-Unique: IqoA1oVLNzaN4hSlf6HKrg-1
X-Mimecast-MFC-AGG-ID: IqoA1oVLNzaN4hSlf6HKrg_1761816204
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7848b193cc5so36358097b3.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761816204; x=1762421004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e4JeRqvX7ZbkSQVSnZTmzlKVFPz7NTFo+cG7lq/is1Y=;
        b=uUHIPeBao92sZm+rS8H4bUHIMQtCXs1urNcGDvp60m7sZ9SFmOtr3vbKeZ3QwYHxWi
         mp+pxbxIAmUMZYyDwrvVBkd6O4KDWKaPELt3WoC4CXsbEFiD2Si20eMSSqZe38j7vS2R
         Ab+XntQvVl2/rY/5IvrhN5inxy9f7a6yBkuwHDRXvTxMgrwG/CjNulVJoNY5BmQt4FSR
         Eq2n8zzo7mRHTh7Awa5sG12CYJNtI6MycGqozE6kF7vlXgJ9Zdtr1T+mHVzv3R1wjBDh
         W+F7gS/zwmHJDibAmloo0u9uR9YdhJiF6vKsLQ8nHNobhNMfQHCnMkbYooe3PKgJyqrz
         5R3w==
X-Forwarded-Encrypted: i=1; AJvYcCVj00O4SADJVe249dzhazDkbO+KgL5FqPz2ubYtBE+zgFc/2HleLPjRNmlFQQN3AHcdECDhgW8/Qw==@kvack.org
X-Gm-Message-State: AOJu0YyTZuPnGfPy1sky6jcDWwcvcuOmkbVkvOAzIm8Vs2n0Sh3oPUPa
	BFg8Q5ulsObIq1qKAZPsgxfy/qdCxJFoawpmtOauuTI98K3YXAaCKh5z0q0g4xvRjRQ2A4yzTQh
	NaEVzS4gRtFWv+bkvPGv3gFkoPfjnLnutv0pcptMBW89+wX69HhV/UmUtuEU2ger7zhQfz6SkKp
	HYmwej2JF6BBm69gmeJbuKzgRYLmU=
X-Gm-Gg: ASbGncuE2TkXY3hgpMinOQ4wjNeIgPbAQgO3yoOec9RBxsXcF3Sl+SZlHf/r6Utw9cI
	OuV0BlS3SancvZKDFwLZCvJNcaNcIUpOrpd0vV3KcPt/HUNUO94i/GW1Xs1X3CwhmR+lSnkCegI
	fF0+cSWsAWf3ITukXMW2doaeXS/cgCEVhuc3sWk9k87lVeiq8jxg5Z9dI/Fo1ZwGbgn3kb1Q==
X-Received: by 2002:a05:690e:1206:b0:63f:7c9d:d378 with SMTP id 956f58d0204a3-63f828c2c02mr2020899d50.5.1761816204109;
        Thu, 30 Oct 2025 02:23:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvrSCrTEgMrUbOgoPl2KJmDrRVI+3ODtqSsbueHVsh8YG17MM43WMAy3K8Q32MQ0B0IGUbciac4I47u/HJ0wk=
X-Received: by 2002:a05:690e:1206:b0:63f:7c9d:d378 with SMTP id
 956f58d0204a3-63f828c2c02mr2020849d50.5.1761816203673; Thu, 30 Oct 2025
 02:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
 <CAA1CXcCiS37Kw78pam3=htBX5FvtbFOWvYNA0nPWLyE93HPtwA@mail.gmail.com>
 <4e6d3f7b-551f-4cbf-8c00-2b9bb1f54d68@lucifer.local> <CAA1CXcBP1MYdBi55kdF83B5OD6uMoFmyKP95mWJx7gkwZDQxKg@mail.gmail.com>
In-Reply-To: <CAA1CXcBP1MYdBi55kdF83B5OD6uMoFmyKP95mWJx7gkwZDQxKg@mail.gmail.com>
From: Nico Pache <npache@redhat.com>
Date: Thu, 30 Oct 2025 03:22:57 -0600
X-Gm-Features: AWmQ_bmooqAizSQnE4QAHs6kTItRvcGPa4RG2-OLEQL1ZfORrpkhGIXAfBnMCHk
Message-ID: <CAA1CXcAwpD0fruWm280+66GQsMyk6LhJTo=_xUu1fzCTELjC1Q@mail.gmail.com>
Subject: Re: [PATCH 0/4] initial work on making VMA flags a bitmap
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
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
	linux-mm@kvack.org, Alice Ryhl <aliceryhl@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -t_9O5krfzcO_uSiBvyFle7IhHKoSuBDeNy9VpKNq4Y_1761816204
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E6DB120011
X-Rspamd-Server: rspam02
X-Stat-Signature: 69y4wwc47ud76iugah4zy7rtf1dbtjzy
X-HE-Tag: 1761816206-990667
X-HE-Meta: U2FsdGVkX19xbXgVrofbXbjdw7Djmuy+j4yWOmXbDZWCAPKD8KEyBkSRALpJNYZVQTBbyTMktAIhE9iqMfARLroxhsxA3lkig9yWgiZo8mXWVwM8DqmTi+Lbn8jqCgYJjia7aW7+SAKo5+Jmff/fr36J/4Jt2l4aFGMG9xqANXwUopJE+OTF0zqchTbTV5garGbaDJhDGEVRdeZVD7DAYn9S6kHIcu6gPRsCfqAOhoeD3t5P3P3AOlnPuoZ18efm9LYUSdm4refN21yBv41c7JcOK28k2rdTDWNDLKt+gf+vnTti99kcTyY/3pYqn2fNClpDGYXTpoIskIN4XTtcqMQq0sY+ywiCSP5odlAZ3RcWnGS3oI3qxvvG/D5feLSlP8KkkYitRBp/zPpHQl7RbR2xEqEbmJoZtvbOplaPSQ/+bAntl31qTXhVpfLmRpmlmMRcJIgQyffjYLtNP+M7b2Jf/wkFDKLH1GGI/snmProl79T+iHWUbmDP704P/rQjMXLuiEqmfvrdwJkTaw3hfyT/U3aD9xPMVOv36AYjBTI5O722g+CJLa7ci8J6MrmaObRU7766masUDmp8T2mXdNluEAG1PDTQOlQuPcS2itmqYIJl1DMv2eYBIKueA6qltZmLZf4giYB8T8w962b2GGPzVKb5sBzbnNh7pGf9GelwpkKCk+4nzaNHsr3hdYMtojnQhJqVmvVZZr9xnxiX9SmLjoSGNvCkHDqIAY4pf8ClQ8DJpj7d0w4K2tjq24wGcYkOqxQt+zgS1RntiZwOJU0dYzyrYN9/DygInFeqzTqykxp/8z0kOcsSxZBbNDLNixniOAp6gG4dQA1Bh0n7ULqOIMDRxxFdqHfWfOktnoFYFvfzSuVsVC4Z8EwTUAvsdqQtzlCX6vS53k1ztTzNiBoVL8+m3cAh7yIn8OcDLVP8zw73jsO34DGcaZzYh+SvzznBbf+vKl9pmT6/2FM
 igYCqn+i
 HBkwpQlf8NGFE9es6Nmgi5knpmOWSWSakW473sF6b+bgjQKRlbSsi+6kUG6OSSpLO0Cx27T8w8qZq07qHQgLsad5sav2kQ+vkC/fpks+s0v9E/tAoopZ5lrXdHxCoOZ1AnbJEcc9hCOoFi5Dg6zLKjjO9Ei6HSCMP+9cc4q8q08+h/RCht5GmCJ5L8M1fjrXNYCw268cPeGZINWzzPuR5VcWUjNvbokrkAmBYy+icJ88h0JDzMP7aNxbfs6BjVhYric/5HMbaHtBIUKIYVbWDQF1+RNsTSFoMS4V44vbM0HG8Sug1XqMiHsrsX6xoNV2RZOJVYXezdCeehytD+4+z2cbQ4YLKXR9Vqa6ZuTWwqpfrVLlYHXY/QVYGZ1hgK+4kfW9pPNpkB7guxbPKFCzCyKljR1X0b7Bx47SMCb64Tc28IU0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 3:20=E2=80=AFAM Nico Pache <npache@redhat.com> wrot=
e:
>
> On Thu, Oct 30, 2025 at 2:34=E2=80=AFAM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > +cc Alice - could you help look at this? It seems I have broken the rus=
t
> > bindings here :)
>
> From a first glance it looks trivial to fix, there are a bunch of
> bindings of the VM_* flags.
>
> for example
>
> kernel/mm/virt.rs:    pub const MIXEDMAP: vm_flags_t =3D
> bindings::VM_MIXEDMAP as vm_flags_t;
>
> I believe this just needs to be converted to
> 'bindings::VM_MIXEDMAP_BIT' if I understand your series correctly
> (havent fully looked at the details).

On second thought, I think i'm wrong here.
>
> >
> > Thanks!
> >
> > On Wed, Oct 29, 2025 at 09:07:07PM -0600, Nico Pache wrote:
> > > Hey Lorenzo,
> > >
> > > I put your patchset into the Fedora Koji system to run some CI on it =
for you.
> > >
> > > It failed to build due to what looks like some Rust bindings.
> > >
> > > Heres the build: https://koji.fedoraproject.org/koji/taskinfo?taskID=
=3D138547842
> > >
> > > And x86 build logs:
> > > https://kojipkgs.fedoraproject.org//work/tasks/7966/138547966/build.l=
og
> > >
> > > The error is pretty large but here's a snippet if you want an idea
> > >
> > > error[E0425]: cannot find value `VM_READ` in crate `bindings`
> > >    --> rust/kernel/mm/virt.rs:399:44
> > >     |
> > > 399 |     pub const READ: vm_flags_t =3D bindings::VM_READ as vm_flag=
s_t;
> > >     |                                            ^^^^^^^ not found in=
 `bindings`
> > > error[E0425]: cannot find value `VM_WRITE` in crate `bindings`
> > >    --> rust/kernel/mm/virt.rs:402:45
> > >     |
> > > 402 |     pub const WRITE: vm_flags_t =3D bindings::VM_WRITE as vm_fl=
ags_t;
> > >     |                                             ^^^^^^^^ not found
> > > in `bindings`
> > > error[E0425]: cannot find value `VM_EXEC` in crate `bindings`
> > >      --> rust/kernel/mm/virt.rs:405:44
> > >       |
> > >   405 |     pub const EXEC: vm_flags_t =3D bindings::VM_EXEC as vm_fl=
ags_t;
> > >       |                                            ^^^^^^^ help: a
> > > constant with a similar name exists: `ET_EXEC`
> > >       |
> > >      ::: /builddir/build/BUILD/kernel-6.18.0-build/kernel-6.18-rc3-16=
-ge53642b87a4f/linux-6.18.0-0.rc3.e53642b87a4f.31.bitvma.fc44.x86_64/rust/b=
indings/bindings_generated.rs:13881:1
> > >       |
> > > 13881 | pub const ET_EXEC: u32 =3D 2;
> > >       | ---------------------- similarly named constant `ET_EXEC` def=
ined here
> > > error[E0425]: cannot find value `VM_SHARED` in crate `bindings`
> > >    --> rust/kernel/mm/virt.rs:408:46
> > >     |
> > > 408 |     pub const SHARED: vm_flags_t =3D bindings::VM_SHARED as vm_=
flags_t;
> > >     |                                              ^^^^^^^^^ not foun=
d
> > > in `bindings`
> > >
> > > In the next version Ill do the same and continue with the CI testing =
for you!
> >
> > Thanks much appreciated :)
> >
> > It seems I broke the rust bindings (clearly), have pinged Alice to have=
 a
> > look!
> >
> > May try and repro my side to see if there's something trivial that I co=
uld
> > take a look at.
> >
> > I ran this through mm self tests, allmodconfig + a bunch of other check=
s
> > but ofc enabling rust was not one, I should probably update my scripts =
[0]
> > to do that too :)
>
> Ah cool, thanks for sharing your scripts, Ill take a look into those!
>
> Cheers,
> -- Nico
> >
> > Cheers, Lorenzo
> >
> > [0]:https://github.com/lorenzo-stoakes/review-scripts
> >


