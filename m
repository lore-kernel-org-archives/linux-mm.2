Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9CA2606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 03:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SHNJYmjZ
Received: by kanga.kvack.org (Postfix)
	id A97386B05B0; Thu,  5 Nov 2026 22:47:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47F46B05B5; Thu,  5 Nov 2026 22:47:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937C56B05B6; Thu,  5 Nov 2026 22:47:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4F76B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:47:48 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4588BC0C96
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:47:46 +0000 (UTC)
X-FDA: 85403310132.25.250300F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5A26840008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:47:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SHNJYmjZ;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793936864;
	b=EQwo926kk7V/jpVfB6oXw+bSKKw0/3AX7g1oxfUBsO48kzQkR+7LiE9RC+pRvqiUyoRKm9
	Qqu03eh5+X1F61QdwSNky9DrN0JXY50OoWk/+9n3u/G+k/q+ubXz7evDDoTB8emvBmU4ny
	YFl29JCZYboO/yQfFVRktUudF+NOUG8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SHNJYmjZ;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793936864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7itVVRO0OrCMzanAOyJRHIm0MPtgmrlnhYWCxSa5SEs=;
	b=8Pe6QBuU14XE59x0QT8KWWBP837avk4Q+q9PZnXhX0xYRrt+JJYNEDZqEA3UVLkxCd8nxZ
	b4Pugmr4HSQzDwRUqCPfT1YIg8x+0q4Oh8HaAa1cmcD0C3L589wKBWXOS2wCVheD6cNehv
	rJqVoZ6AeGxYBG2nIZhpMfZWffF7yS4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48F1043970
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274FD1F008A6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793936863;
	bh=7itVVRO0OrCMzanAOyJRHIm0MPtgmrlnhYWCxSa5SEs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SHNJYmjZARW+KMI9weZlYiailG9olXiPUIy9DhCfIwXmV7q4793PyRrLUT1E0bUGo
	 nmmkSMDlfuESlH1L51OEthu9tEkk2dz2ml2LZ2Yor/qURFWM9SBb47kSDL7kUWgh9C
	 KsoGQQsyq8SQ3dBpKKj2a0u8iYdYRtyHNqGxCi2IdNRzvx7Jk2ogdHgO1WRtzTr3ck
	 pbqvm15vJgAS3L3BUo1VvUPFU4RI+LQ3b7/f020/Qst049o3V6Tx1xgJr2l3zMg1Gi
	 d0CgtsezOi7hf/YovyD6VXycvpTFmxYdwrokEbGNW+riJ23JkFlugyHUX1hoqofhzR
	 GMHWANQP9U7qA==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9441591aa5cso169893385a.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 19:47:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByed8486fddONq/FS6dFdlRgaFNouTuUaCsXbVWX+09RUWXFiqvfoHoRlOtjcPK5674FgHtHihebQ==@kvack.org
X-Gm-Message-State: APuU4Z+3VUkxQGRp/rCCP738Gq6ZGQHhmDwYbX3czyxbiBX+eg4s56cr
	Kw5Ug+g2+L8CJwt5NDvSDWqduoucQx/7jqsw9kfyFPetCW2qAP6VM6LyRTxcBDG1+gQPENMAAy9
	IMeFjHeDMaVJ1R/dGcwtahP35WK4Vu7g=
X-Received: by 2002:a05:620a:6ccd:b0:945:d3ba:7d99 with SMTP id
 af79cd13be357-945f3593146mr175996585a.37.1793936862458; Thu, 05 Nov 2026
 19:47:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org> <20261105-late-2026-vma-flags-v1-1-0d3cd15ab75f@kernel.org>
In-Reply-To: <20261105-late-2026-vma-flags-v1-1-0d3cd15ab75f@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 6 Nov 2026 11:47:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wFi9mqSsq9RFoYP8m0GbqU01he_icbP2VLPhBfQAvCOg@mail.gmail.com>
X-Gm-Features: AclHuK8VX6mOjbrvfm7oXhssK45doLoq2eZ9cV_P4690FurSVGBQe9E3r9SjObI
Message-ID: <CAGsJ_4wFi9mqSsq9RFoYP8m0GbqU01he_icbP2VLPhBfQAvCOg@mail.gmail.com>
Subject: Re: [PATCH 01/13] mm/gup: convert GUP code to use vma_flags_t
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Zi Yan <ziy@nvidia.com>, 
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
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, damon@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5A26840008
X-Stat-Signature: m8pxk6hxr9t9usbzpg1dcx7jf1ns3cmr
X-Rspam-User: 
X-HE-Tag: 1793936864-18078
X-HE-Meta: U2FsdGVkX18lgxupf6m2S7E407FD0QnFTulDExUv/41DUbknU0gmOAPkiZ/ZtTYxMUGJYIB/oPBlq8k58TCLGr2WH3DQLZDypc4DBLHy41+Ppvd7lDCJMGoe+1at3pfvD4rwdQcvHIBhxxEUr+kBx+H/hEWgXXIi+h8hfDThAhHbSAwNAGkP/RGqgKawsrJXVIiuqbx+qHidyOX4Dab2KDAopqAxDzLP5ox80nLkQjgTIDGIKq1TNbxaPBBY1U+N3qA1Yqx/BPiMDEMAD2tfVPrSS//m3LzcDmAW20X0qK9j4Sll3eutE8jYymf2KrIgAW+6qCIaESmoDa5CYOG9/qOBi6++phkLS7dv5CcLlOxYPuJqrqXKtDAeuh8pm0eg4ur5WtfEgDL6W1mu/xM9y2PzOO57QnnNGLADnykTqpW6VYNKFPili3fwF2+15Qse4/0XDnB8kCzLpw6MDkftJdF32fsvP+BxkmBxuUX7UNtJEotAB33hFlhuEUKSJkHSaZgNmIdNwJjQk7nFZ18KaWOUAc6WWh7QagVOG+btHkkQrJ1MYsENg4S5USNfnem9eo8xmAXBaXzAu7og8gsCE8+6YIdLoDNSh7AIr9PyMquJ28F4OSI6sKE6sQ6W1YEbazgXFHLok5n5Ywks4jneOdQV+z3Zi3sg5DK4tltRSKYItsuoQMg/DngCnP505mTxFPw8ty408h9xOahv69wYPJesdfGZtcKyMJjQ8EsQyHCKjlFEr9mb6pIy0kdNn98VJ/834nH8v2FIkvff3c75VM+h8aZyZThI2cODJK7TIgGokX3pIae2CNc+vCFLEO+QYSTnVA27oIgY3Fa2+8vXvhNtKk8bL2Yeyvdgcb8HAZn+4+UXukCYxOeMeIYmaIWeT1UX3l21uWyt1854afsgrB5MMjfsZuvN78+y2LtcRKArpbno2CH9czUlAC56QntSktZEijqdI2Vy6qSDtET
 6o+y5+cw
 n/nuQeArAVzdC1cpfdV0g6hgDQF8hrmR2wsHKWAUQnXVKsvuRDFBTLlTzhEUuH9wQ/ru9NokrpSArJEK9ChMy/xtSPJaGhA739wRbysBEpmJ2lCwgLam/xYxxyvWEGgx68yCP1i5b0J+cPRByOCwdmpMoJ/4oiMTJytcBrxydTexGO27658R1R0yBzEpBB4xSvB64WGL8DQrbLgk4dro0XlpbKS3hM4wyc2xWnW59apM2lKreD+uy7ELNhIZDPziVPtwfSRRgaK81EU9EAKj70S20BrjFld94FC2UqxNUz4VXbJ3VrvToyToiZhEaGDcJUoILTfYDJZK4viuFLe1gtv6uS++pXnRLgMJPDgZHyDBqz064nqQRm4UhEHrP6LreX+qsEKKxEnZZviL2BworN6X1lATU/QIKh0hPWoMgmf+4BAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 5:31=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Replace use of the legacy vm_flags_t flags with vma_flags_t values
> throughout the GUP logic, both for the MMU and nommu variants.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  mm/gup.c | 45 ++++++++++++++++++++++++---------------------
>  1 file changed, 24 insertions(+), 21 deletions(-)
>

> @@ -1514,9 +1514,8 @@ static bool vma_permits_fault(struct vm_area_struct=
 *vma,
>  {
>         bool write   =3D !!(fault_flags & FAULT_FLAG_WRITE);
>         bool foreign =3D !!(fault_flags & FAULT_FLAG_REMOTE);
> -       vm_flags_t vm_flags =3D write ? VM_WRITE : VM_READ;
>
> -       if (!(vm_flags & vma->vm_flags))
> +       if (!vma_test(vma, write ? VMA_WRITE_BIT : VMA_READ_BIT))
>                 return false;

This also improves readability. Thanks!

>

