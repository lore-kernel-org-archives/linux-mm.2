Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C2E5606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 07:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nMR8+wvI
Received: by kanga.kvack.org (Postfix)
	id 8DA1C6B05B0; Sun,  8 Nov 2026 02:20:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864036B05B1; Sun,  8 Nov 2026 02:20:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72A096B05B2; Sun,  8 Nov 2026 02:20:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44A2F6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:20:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CCD6160253
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:20:41 +0000 (UTC)
X-FDA: 85411104282.25.EE00804
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 41ED940003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:20:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nMR8+wvI;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794122439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j18geaHLD1uUk2z5k4sfYhqgD5g0IHFNcch65ifUnps=;
	b=fIJhm0mHbEmVT+/HN1d3NY/OxWDTuMKV1jDro5XDN/l3TKVuj8M8+WZYvaqkIKRa647mps
	2erikCXaUPGVr5+wCU6tBwtIOLKJdq6q+ZFRUtpbNh5GZc8Aph0fylPAxKGXAwJt+JQrmX
	z1U0K5t2+v2fL1ZClP7kOnlMn/1BwB8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nMR8+wvI;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794122439;
	b=xQA9nRSLQ+tSRaXz/xC9Cdh32buNpBW0F1cKr4EKMcEIczTc4nJqdVVKyiHnaHOOIgRYF0
	qOIzqscboIl5eE5WNJhcHcJG08ecnqQDyJY9KulXukOkSNBKm3I1zh6vWrUzfN7MUJu+36
	gNXM6MJTlvxPMUMC47buCNtePQ/33Do=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13B8440DC9
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33701F008BE
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794122437;
	bh=j18geaHLD1uUk2z5k4sfYhqgD5g0IHFNcch65ifUnps=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nMR8+wvIKadhl0gb53COwD17VOLLA+rRcE4ZHBalTQd6dTblfN0N7okKJf7t+ZvYG
	 i+1EPKK9teEdkZdwO91Euok2YuPx3bDEEyJZACadzh7IHZcjF1vei7j5i14ZyLr5ep
	 VqIN9h39OurgetTUjWptuiHXXMyNj/ch3S+eFhG/T0fsNkyWJuX0YGPBQx6Lgex5/S
	 FNRmmJykqrmIWyWTVXn405JXlsSS3qO9xBCUjnrmQGUYVaIl/HxcUmN8F/6FuB7OFc
	 JL6U/ckBGoY/1PGMAYkrv+aSutNpdVyFBUeh4a+QlDevhJINYdHgtDXtuUo8725mbT
	 sRhxrhcIRQeDA==
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-535179e995bso2888521cf.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 23:20:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErH6bQCBMrpuNWDGwgahq00VC+WoFmXY+evc99iLaNmAckA9uTCWmE8NreaTp/TQK3FXM6Z/WK7s6g==@kvack.org
X-Gm-Message-State: APuU4Z+H8iqgsKF6FnrKbuXcjLJRAkBEjutZjmZsPz+ZGvomrdC62se3
	OP/GfAwztbwFoCo0aDCaBIDRZ+Uj2WX5nGzGVwQwzzTB8ivR33lAAxNsxBqDOhzqV0Om7lim//y
	bZTa3+6yCw6oNvvoapr3t3D8Jl2Q0M8c=
X-Received: by 2002:a05:620a:6190:b0:945:d7a2:4b58 with SMTP id
 af79cd13be357-9478427d0f5mr101426485a.65.1794122436125; Sat, 07 Nov 2026
 23:20:36 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <20261105-late-2026-vma-flags-v1-2-0d3cd15ab75f@kernel.org>
 <sashiko-outbox-200257@kernel.org> <au2_PPpdAMgRJZtX@gremlin>
In-Reply-To: <au2_PPpdAMgRJZtX@gremlin>
From: Barry Song <baohua@kernel.org>
Date: Sun, 8 Nov 2026 15:20:25 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yWQom=cG5vw2B-FR8+7wNU+rwZkvghjAxusym+3OH96A@mail.gmail.com>
X-Gm-Features: AclHuK82gk7ruViNEj2rccGK1fXvxCJcs3PhbZ9Er7PSONJ4wRSmOw3bXHmiVAU
Message-ID: <CAGsJ_4yWQom=cG5vw2B-FR8+7wNU+rwZkvghjAxusym+3OH96A@mail.gmail.com>
Subject: Re: [PATCH 02/13] mm/filemap: convert fault and readahead logic to
 use vma_flags_t
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
	Lance Yang <lance.yang@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
	SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, David Rientjes <rientjes@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, John Johansen <john.johansen@canonical.com>, 
	Georgia Garcia <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	linux-mm@kvack.org, kvm@vger.kernel.org, damon@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ky5mg3a9mj3qiapkkc6yic1zyqk7mdzw
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 41ED940003
X-HE-Tag: 1794122439-350764
X-HE-Meta: U2FsdGVkX19HoOgovFWEF1b46KMJL9TjwPRpg3PtbJMLqorSBV86L4wOJXuu9D22NiC/W7d2smoZcGYXVjYHQDvBZ+RjwnHs+1Hi9tAWDyp6CNvUH16xcrH67jDuRlKFordg3QT10Ba/S6I2Kh9Ht6U1zGjF0+IrQuWG1C0g7vVPWGfHK4P0ANOB+vOqYiF11rguUaz6tkpiK6VPvNizCb2RWJ1FbUjTuD/YCxJHda+SBFJh+K5qxj4WzRC5cWf/7n7LZqp/UCDDptGXryk25kisNrscua7Zu99BCqENO33zvGTfqNqjrPa5lkTRcb1J8z5nfqJ9qQVo/5ytORKo1AAeH/6NGfXZTIcndHEdrvq/nexx9xXfYxmhLb1mwitnZ94HFQn1i4w/H8qMMbk40YEcmXfTxPbCLy5ja84wMob/AIUcqCgA6zgfyn/b1jIC/Ai8ZuK2eaV0sAeDlFMbrJLxni6xvnFFjSFjjj60FpzBcprfjff/QyTCWENwN3R+woqnvzKv3qZf3qpLwX04IB4hNybyOuCs0tocbVJdvdbmtrokV0FpSLpu7RSMcTdBiO0zl779DFFL4rfPQb5+llS9UFDUQij/j1DsUYwFVep/LqDW8bKao2vqZb+bX9KJYEwbpQ7licpVR8X0HdXym/8Ztl4y9Gl2xf1OarG0xaEGg7kl/GzrA5oKMAMKLB54hygJOZD4eVuUklIM162KZxiMAlTZC45HztKnFpLTbZQqHrujyHhQbnFw5Fys8djPPR6l1LeCzOLSJBrdMY8ZU12MWbpc3gab5ihajt48a+sLGalOsgVwIW9pUlBsDYeEcRnSFzQqDL4zMXD5AzU8FDbYxXK+TFh6Gr59vK6rVwAJA+oSbF/6ByYk/68qkSvXhB2nmTfgwtDkviVbfCZdTO10bzCkcTrwzFKQ7MErnByOtFS+e5pTplUVXDmWde6o17if/8xGTLrIDcDEgQF
 CJ/vMF7q
 hKDI7VRo5ArH+QufzT1FxJXdMg/gzVNkFl5/XaYdQkazLcoHqFkPR+IviZ/07y8r/xS7ssAsUtHt/U3+9SJJD9LemQSu7qOLP+FJZRf+t57YgiQrjTeEeZbCu95XbltoC/LUENaotF3fuHBJiRHb2vd0Xtz8DFUURxG0IR0VDmuILrOts4FL+zs0VS+QnzCzB5T2opMY3hNM7Z2akPaYCy6qG1bh/wdMgreZaDsLY3WbcDufnL76QcH3wA8S9VgRLvMbFRQPuPadl2s4jb804dPpz4+BhpguUi/w//80xGbdXfZHq39IyTUBU5uXUwEMCPF+pn4cl9cYlQkGq7NdOfojd7UWGBcDe86g9W8eo3mVhxFdqgaTE3XlydjGF2NEcJbpgL5UxvZYKXQFYe/bA+9mSmoCIaji0Fgu9vPG4QDGXLJWxtfL/nj0NR3JvXitaHL0zG4S4kbvbOgSbPIxOB2iD2qLM2sVxinI7Yrp+Ir4t7Rg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 7:53=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
[...]
> > --
> > Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-late-2=
026-vma-flags-v1-0-0d3cd15ab75f@kernel.org?part=3D2
>
> It seems these are valid, oops!
>
> Andrew suggested a fix off-list, and I agreed to this as an in-place fixu=
p to
> avoid respin.
>
> I have also updated the series locally to reflect this change:

Seems like a reasonable fix. maybe_unlock_mmap_for_io()
could have released mmap_lock, leaving the VMA
unprotected. but  ra->size *=3D 2 is still going there no matter
if the vma has disappeared

For the original patch combined with the fix,

Reviewed-by: Barry Song <baohua@kernel.org>

>
> ----8<----
>  mm/filemap.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- a/mm/filemap.c~mm-filemap-convert-fault-and-readahead-logic-to-use-vm=
a_flags_t-fix
> +++ a/mm/filemap.c
> @@ -3410,6 +3410,7 @@ static struct file *do_sync_mmap_readahe
>
>         if (force_thp_readahead) {
>                 unsigned long folio_nr_pages =3D 1UL << thp_order;
> +               const bool random_read =3D vma_test(vma, VMA_RAND_READ_BI=
T);
>
>                 fpin =3D maybe_unlock_mmap_for_io(vmf, fpin);
>                 ractl._index &=3D ~(folio_nr_pages - 1);
> @@ -3418,7 +3419,7 @@ static struct file *do_sync_mmap_readahe
>                  * Fetch two folios so we get the chance to actually
>                  * readahead, unless we've been told not to.
>                  */
> -               if (!vma_test(vma, VMA_RAND_READ_BIT))
> +               if (!random_read)
>                         ra->size *=3D 2;
>                 ra->async_size =3D folio_nr_pages;
>                 ra->order =3D thp_order;
> @@ -3438,7 +3439,6 @@ static struct file *do_sync_mmap_readahe
>                  * pad that might exist between sections, which would be =
a waste
>                  * of memory.
>                  */
> -               struct vm_area_struct *vma =3D vmf->vma;
>                 const unsigned long start =3D vma_start_pgoff(vma);
>                 const unsigned long end =3D vma_end_pgoff(vma);
>                 unsigned long ra_end;
> _
>

Thanks,
Barry

