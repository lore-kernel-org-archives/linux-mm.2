Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12538606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 03:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EgFmAbUp
Received: by kanga.kvack.org (Postfix)
	id CF4966B05B5; Thu,  5 Nov 2026 22:57:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA4F56B05B9; Thu,  5 Nov 2026 22:57:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6CE06B05BA; Thu,  5 Nov 2026 22:57:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C5A06B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:57:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 035C4A8932
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:57:23 +0000 (UTC)
X-FDA: 85403334408.06.8F769DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1B9D6180002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:57:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EgFmAbUp;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793937442;
	b=4NKnh6z0U/1p5dmDdkOLnqzvMAQii9pN4b9ZVjaQs9B/yoqMX4O4x3jStS1NVJP/fqThwx
	BlsmgfYMNyH4rSAkSypQnUo/y2qFVdNPtxZ7eyXUTLJUzKMpC+q6lu4VdND99X+luM358L
	OkpVnxicEBS64n7zXaFO0RPu82ZJs3A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EgFmAbUp;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793937442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHXR2FH3bh5spT35/G4nG+cv25q2yTDGLvo0NNx3ZVg=;
	b=f6UJebO+y7mdYiOwB7XOYRMqRC9n1vRhMaKRaVgxrMa9vVdPVgeYSYHCJzrz4IOgEIzy+3
	4ty2Af+zapPsrWq1wuydRQxmZYeoyYME87lFMq7mhwRKfe3LqJIm9tdNXan46pOPMdfeOz
	HU4BAocCP41lrKkjgNuifSVmPkD9TvM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01E6943FD2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4DF1F00927
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793937440;
	bh=lHXR2FH3bh5spT35/G4nG+cv25q2yTDGLvo0NNx3ZVg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EgFmAbUpAM2cjwI+PAsaOIcEAvxopqxzrr5ETtb9YJduifyoKzN8YwdyePG7jZcgl
	 MAF1R31GIZ0XeuUOJ5ajpkRLAI0gc7RjT1TWr25oDrdTv5MC3GjICuS4R/pPi0d0Y+
	 pCObQVcMyzbJ8upJobLZEEgDDMPAax+RNdKemLW9HXK51pfSHhspbfEziQxNccns9m
	 V6Ao+kTwjY7l3VQQwr9rOMONlSWWfRMpgLakbtQVmIq6dK6cSWWL0ZgDvyUd9/JdBX
	 zzAa59f4NI2tvQUjbttnwVD7TfUy2F0n9FlrD/xYew+h3qG/zcNr0KCdZAsNc+VsTK
	 tfw0hgrFmLfHA==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93cbc3ab2fdso9234785a.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 19:57:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzvncSQJy/NFhhLCa7i6dDQmz45E8k5+SWixaYGexDB6nzIn5XGiIzCN9XAKMKZeQO3oSpfZj16dA==@kvack.org
X-Gm-Message-State: APuU4Z+5gL6QkfzlFtE/ZyjfqO30+PQqOtpG/lIYrN+2hU4IrfsnpwRz
	xA0f5nmarAWuG4KwQsofWBkfajzzduK+7nN9UZ6dC5hbhFwRhtVxmo2p9bGaYE3KHzpXcvcvDrQ
	EPVRROfN2azvykUWEVjfvv61JaIGqzNI=
X-Received: by 2002:a05:620a:6c88:b0:939:b8d6:9b1c with SMTP id
 af79cd13be357-945f34af2acmr198595685a.19.1793937440071; Thu, 05 Nov 2026
 19:57:20 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org> <20261105-late-2026-vma-flags-v1-3-0d3cd15ab75f@kernel.org>
In-Reply-To: <20261105-late-2026-vma-flags-v1-3-0d3cd15ab75f@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 6 Nov 2026 11:57:08 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wCd_j5or0uHwPLq0PUixcXgiFim=_d7uUhUhAuQf0nTQ@mail.gmail.com>
X-Gm-Features: AclHuK8deEInzaZZJ26UPrq6mS-8I8VnGN9Ocbio_nvLAi7VvywQ3Ss3UdDHcfM
Message-ID: <CAGsJ_4wCd_j5or0uHwPLq0PUixcXgiFim=_d7uUhUhAuQf0nTQ@mail.gmail.com>
Subject: Re: [PATCH 03/13] mm/rmap: convert remaining VMA flag tests to use vma_flags_t
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
X-Rspamd-Queue-Id: 1B9D6180002
X-Stat-Signature: eh5hi3gahmpmfo4kywuxfcnini1xdixb
X-Rspam-User: 
X-HE-Tag: 1793937441-151801
X-HE-Meta: U2FsdGVkX1+SzqO6uRhgHJYianfTVm33VLdcZV4XwXzQWIv8qp2fpEljfFXcV5KNZbwvtdfMaSOINsxSohJVbOPh7UZBgB5ZoQHH/E8rW7xcap5ItOPwzlQdVKUmmHmhCi1RlOQEEAT682AYzpOIKAxv5/va+OBe59SXBJg+zBOtfXDTxsDb8bRfMouLMRIa8zEiZzbAnejjsA1rwYTkMv9cJsfwPeSMr+qKrE9rpQBqQv2WRGyHJ7LwFn2hfzqYLCRYYPTXyXg7wMxKP13PNXe/LMuV2EzEDTTS9cMzzsn6mZxeviseLXSRmlkCnW3I7IKCvY7JLOIeM6RVCqxj8DZiGSgxSpxM3jMXQhPSoHzED1FVAnGU60ELxrNEwju5vOo5o1SlZ73GZAl/ax8SpNuxb99fJpd3LTO6s37kMcUnrRMQ5176gvYdb7oxJ5s/JS9Jw2orwdx5gWEFIRhQxjGC3VoFn0AOQrSURnf3dqUgfe8ePo9JOK2oa0rEP3EaGrfPgWZVO8Jqn0bJJJwrZkj6Gohqt+r8qbnAg7Aj6V3rov1XHf4zB2UOe1Irb2WoCcMyAKjmm/obt2m/ehpem/Lx0SK2nLYcdvQdiiGU0UKX6HGVaJ9pK9eZq4uBarYy7hofvqAcayYwdD2PgOHfrTJy1Ij9xmA+Ehwaq/5CTsZHfA3wT05yRs9/JAYZVizJzTHl82j2ZJBOd/IjRzVZavd5OM8WI5U3D4/yDT2cmVbpnB6X4ScRwneZQ1LoufaI96XMI/9qO73qXfS+xX/E1h7YM4uVaIRx/y84hK2FqiMtH4eeZ0uVpvC7Yjd93pbY3vJcYdYDg1wksNs/fx1yNo8fZDI2FeMpKJR9V7EFTUPaUqWyLljncY72S8mIa4TD34Fn9TkUWGBOEHASJXHMf4D56sR5WsQJ8zgE5bv+UiBBAI8TKv8qtWKvUB3dyeFTy4xC1PM/4LGiZzoq2tb
 8FTUcIO0
 aalSrpe4z1HcGMl4TJJ1P1CT7/+5RkEQTw7mX/Jp065len4K5pm+r0YppTlyvIj685J3+fu42gT1DUcKbB91CBECei57SdSZG9W6EzzCC1KvD29glaBjAuIQOonaKLlid3bGxJizaeA8CHsCMPvY1vptjjDs1h0mKChuv3/6N5SL2nOr6nwIH5PfGyld3ciQAI4IrKbF8v+OJnrjPCUS5Bl6KIuvshmktf7iKZ8jcZWuSZfE1puAu3NhzKoNGndUUaRIhKk0DWGBg1PnKKqfcUmDMPGZtzDhKXjXtkmU9KR9pAJYWZZsm/A+5MJsDgqSvnVkxtAMU7JeyGP40xWfK0TaoqQ8wExUUkYuy5eUQRIGV45uBjHo77LSMPvsgm5yu4dUMKcOUmuJDeBcZtTDK0xpkLe7xUTOOD5ZGMprMzXuBMwvjs9uMBo6f8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 5:32=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Replace the remaining uses of the legacy vm_flags_t flags in the rmap log=
ic
> with vma_flags_t values.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

>  mm/rmap.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1131b76bbbc2..cdc97fec8586 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1196,7 +1196,7 @@ static bool page_mkclean_one(struct folio *folio, s=
truct vm_area_struct *vma,
>
>  static bool invalid_mkclean_vma(struct vm_area_struct *vma, void *arg)
>  {
> -       if (vma->vm_flags & VM_SHARED)
> +       if (vma_test(vma, VMA_SHARED_BIT))
>                 return false;
>
>         return true;
> @@ -1660,7 +1660,8 @@ void folio_add_new_anon_rmap(struct folio *folio, s=
truct vm_area_struct *vma,
>          * VM_DROPPABLE mappings don't swap; instead they're just dropped=
 when
>          * under memory pressure.
>          */
> -       if (!folio_test_swapbacked(folio) && !(vma->vm_flags & VM_DROPPAB=
LE))
> +       if (!folio_test_swapbacked(folio) &&
> +           !vma_test_single_mask(vma, VMA_DROPPABLE))

Right, VMA_DROPPABLE_BIT is not available on
32-bit architectures, so vma_test() cannot be
used here.

