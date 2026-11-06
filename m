Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A4AC606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 04:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LNdgrU5z
Received: by kanga.kvack.org (Postfix)
	id 4E55D6B05B9; Thu,  5 Nov 2026 23:01:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F7E6B05BA; Thu,  5 Nov 2026 23:01:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A6B6B05BB; Thu,  5 Nov 2026 23:01:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3C3D6B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:01:22 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C8F2140280
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:01:22 +0000 (UTC)
X-FDA: 85403344404.30.87754B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9CF8D1C0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:01:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LNdgrU5z;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793937680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKI7PGZaHzRnKhw9+Gxl7Ck/B2CGZVJrrWzNjxtIAHE=;
	b=zGsMoehQo3kE746rnzdwMNmEFiEXsgjr4R34bWoqpxrguHQgxj1y1bjguwVUUdZoTVEZWo
	eckHymGWvJSLn9T32+negaIc3QrPWQzhd+wKzyVy1HeFqAExuXWmBlY+XicTOgWDuMW3Sj
	z8skRfE931Yn4mV6Sd6PM82jFJ9ON0o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793937680;
	b=gb/urZfnQfutZStB8ljzm+76O7+hxJ/p8iuVAYEEtv+QYgNehAA4lzEqCcMiFR1tmqmyxB
	w8vyo3zRops2UnNosCP6aYE34UNqJQY4vT/9yrk/eVv1WoS9zpBFGsP3akJPDO7MVQlh+Q
	RAhtEqxY4bMM0xQq0iPEOkAn0b/gViM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LNdgrU5z;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B3A16020F
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0873D1F008BC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793937679;
	bh=EKI7PGZaHzRnKhw9+Gxl7Ck/B2CGZVJrrWzNjxtIAHE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LNdgrU5zM2nugBvZVCR02iYgDIFmlQHM3kqBcyp/SVdk7mtCDyZg91KEZW9QGqiq4
	 pTrdL/v5+Sridp9dwQOz13aeDVsJ3H2YdUTQ2WgTqzAN3jOXnwlTOnh17e7nKmSJJS
	 cBGQ2Hysr/0o2u+C0HNxL4jSArWNZCkAWoE4VqHwdeCR6AmOWsinVXhs4XeD3AnnYL
	 NyyqQbfWqKaONffmcdGvCd7zgPIyaaZdh/1bZChmRJVWt9bEoba8Mj9VPdtvLQJHSL
	 LtcLpkBtQervU2s3YqAwlJwk+9qPdvnWWnyivKaN8yf3MXd/mXhVPuD1TG2CyQRZXk
	 koUxpIOcYqO3g==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93f259cdc86so15092085a.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 20:01:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxTP3X25oNFNp606+ZjqGC8Hyb52pRBwmZ68LWrjDHAcNysabxnMvIR2prrY4xHm0b8QqdGifTpIw==@kvack.org
X-Gm-Message-State: APuU4Z8cKfREggQyEFY0VSnZNeR1Rur6UfLCQ0r94+CLESyV8cGhcDaW
	GHnn1rUoKxtMAz53Sv3kC0rUm/HPwVlBcl2Zb5mnMNhAetFWdvdXIDJfuurC7ep/ogW/apK1Hk6
	NeXw6nB5AOKlWgfQ+PGWBwjPzCIW/KR8=
X-Received: by 2002:a05:620a:688f:b0:93f:5f83:2cbb with SMTP id
 af79cd13be357-945f33a9aa3mr181925685a.7.1793937678322; Thu, 05 Nov 2026
 20:01:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org> <20261105-late-2026-vma-flags-v1-5-0d3cd15ab75f@kernel.org>
In-Reply-To: <20261105-late-2026-vma-flags-v1-5-0d3cd15ab75f@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 6 Nov 2026 12:01:06 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zKtBarGn2gMEH7ckKtLLgugoyPb040Z2KtXX5Feye1Mg@mail.gmail.com>
X-Gm-Features: AclHuK-043SJnHCawrQog3yw2g1v7cvWQi1ZSPtdBLorMSdL4MZoNdMju91VkJk
Message-ID: <CAGsJ_4zKtBarGn2gMEH7ckKtLLgugoyPb040Z2KtXX5Feye1Mg@mail.gmail.com>
Subject: Re: [PATCH 05/13] mm: convert THP VMA flag tests to use vma_flags_t
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
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: eppybygg3qmrzautttnckqncg9kttn6m
X-Rspamd-Queue-Id: 9CF8D1C0005
X-Rspam-User: 
X-HE-Tag: 1793937680-701545
X-HE-Meta: U2FsdGVkX181wXJPnQDgfz5FJfYHvOKrzwFiJz/WQghtQ7TxdSPJrivW60AKlLucbt2WMavp5bWXw2O8HbdPTDlzgFPtxsj/5hASkb/1KnooBIBG0GC2WZImubClD2fJFe37xOJTuMw3WvXJsnBlcbVCZDW7JplhL9QjsSviw161ImFe7I1nQ85fLeuN3qSmjSNS5ij60//JYQF24/YpMgOvuNCLZs7iWkKmJFd7cQBvBE7TQHOgW9J6gkTnAJRXbjrlQZkDGnJ/ya+svY4wwwK8Vb5OjhJRrcOclGI9YQCbtPHghiormhfcztHyMbGKcxeFtqwfQhXMjAJ5B81EsXMcbR7ufepMHGhcPK6A4ol8aQ/LTHWYuDNZdODbot8CGeQEFnTCmfImxjwnO/2iXO3gUTdUUPBZkjFY016TxyI2P6PXsx1wlOMLa0VFV9TQk7UDzt1IhdCi2czE7qvmW55/BsPlwjLDUVS/EEvzG8/Tng7IK516aBv5o6Y3xao2SteLONtW4x68c8JmE74oX2T2HjDmXh+swn1lCKFCA7bDNf6wi+55t+k+UB8xFqI5FLqZXDktHupQza7s4DWUZ3SByKrCcD5PINvDwtJ8wdunx4yfRjCjWFmRemXCDyaVemmZB2vyngT4LzXBqUURgiwJCPO8nEVoM+RbBbO2J/NVXxOMPe73MFg4n3OwdVbVE+Fcg949WI0BBb2yC/jVo0XgMf9aWtBfKQt+HzL1UtGkmkAM2m5geuAEANOxKZ7Qo4fmWoZKRCBPtFjrFunX1bk++xo7aX9cWoq7rFNLqsKMdy4iEimclt6A/QN/ZB1PDZdgeFc87e7EXGdRc8ABwya/e+ABjHI7I3Kn2j3qEnfbmsoLlLtAyHHicVc1ytUzY/qtnPQW5AOoFI3c3PhQbOFs/EZnb7coaIWpo8aa5tHe0bNGm+wnCyjotaUf5Kk2Br/GL4Fcu9cG5S/UFRi
 CqtFj2HN
 2ktZn//qMcjctjRPTvo/9TD735naOKvopA1pgsSALEzwzRgWM003zigIFW3ughZeeXh6UvsFTwjPMHBq0a1Y0aNQV6N3SeIof1fJHtgYXXADwMciio6Uu8PUXGAz4E1aAnXONMBvVEeLEvxgMpaqMTCK8ij03A4Z1QDqtTEgabCknGtbSbcVunR+LXPFkIkqAQW9iBpC639aZiSZz/GUD/dS0capIqv+k4vdSd9PdyX1DAH76Vfqkdt+4OzzZOva4WIumY9UYk/fvpIQ+kwC/yRzOLeRnUE+CzinTGMURipp7o0RPmVCClMxnYzkIqrBwBPJ3DC5QtvjWglmOWnnbJDEn7H5UQqo+cXxDvrl3C+wGhj+a1PZfACQ7l0BenJLXXFP/rbOpLDB5L7iCrvm0f3VWcxedTDA2Ls5XmsJ4D9uoOiE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 5:33=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Replace use of the legacy vm_flags_t flags with vma_flags_t values where
> VMA flags are tested directly in the THP and khugepaged logic.
>
> The thp_vma_allowable_orders() family of functions, hugepage_madvise() an=
d
> khugepaged_enter_vma() continue to take legacy flags for the time being.
>
> Also update BUG_ON()'s to VM_WARN_ON_ONCE() while here.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

