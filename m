Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32DBF606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 04:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M4g7meN9
Received: by kanga.kvack.org (Postfix)
	id 6A5FB6B05B4; Thu,  5 Nov 2026 23:10:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656686B05B5; Thu,  5 Nov 2026 23:10:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 547986B05B6; Thu,  5 Nov 2026 23:10:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BB946B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:10:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 83ACB40CA8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:10:16 +0000 (UTC)
X-FDA: 85403366832.28.B61A00E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8E9B3100002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:10:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M4g7meN9;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793938214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpOrsKv6qGnA9uW832gOGeZZa5N6TFONX1C9LOr1sUo=;
	b=766Jz9g8+/1aXdiq8y2kRw6tScNRx18krCE+Oebptvey4EwyA919tNw9f9yhRJBib4YweK
	v6gA97M9sG2CVwpR8GBKki27La0Q0NEHS/G0vqMNccNO3LPfZkt0qEfZJv+bh3XQ8bgtDB
	k5erthziowPUxvslAOADpUak9gGJZxU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793938214;
	b=fCIdNrKflYybvsoe1SXZkweEwm5f0XCHWjEM5BqO3bBA05f9CnpdBQFb8dT1QdTo2Q1khN
	IV700WcbaqODtShBWzc7rxW0URd31WES6MZhrpjtiUESITyttuXGZWvsQKG2Up55UFZB8b
	wiTxlOruI8O5UyzlVMEBWYCQ9UnGRPw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M4g7meN9;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CC7144044
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B1F1F008A7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793938213;
	bh=bpOrsKv6qGnA9uW832gOGeZZa5N6TFONX1C9LOr1sUo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=M4g7meN9L4jcufSegpXXlWaGlXSAiSHsKt/N0gqp+weN1qe6aJeULVDkyojAgWtGd
	 gPzkuMhS3VJVvD2iSMsunZRORx5vJwxaWTAQVgFcpLq14jjWIAD7Nw2dIR1i7/2Hzk
	 /O5QenXf94M6jdl7yxnrnrLBTyfQ+VOsC+G1To0qVtvIPWpP8LkN4Fxrkoshn5Eodv
	 iI2U+VQDFU28zucCyh62Ju3w7+sSJBZjMtmNRYMl89xvA9b06kdZffirB4Mo5dQJxN
	 lfwJBW8CcnqbWHB2+bVzFKHN9Grs/TML+8Rs5t7LhzX+R2+u3PZkzW2XpkS0NsohGE
	 EFmyKRadV+PGA==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-91c719669a8so1958406d6.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 20:10:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzYZPNHwp/nHlb3z5+aUtVSnV75idU1oOr3kfyS6Reovs+Jg9oprkqJsE+KPRnklT/cELNTQSTyUg==@kvack.org
X-Gm-Message-State: APuU4Z/UQU5fp6a/OLKrZoyKcsvhjeRW4fMgBRgk5EolK04cKkS6uInr
	X1dYqYccdUTXnI0TtWY03PrZJ9+dMNcwntT1hB2ZgmryFnuU5y8nyXO9eFnZG0kk8sUyGhTfMfF
	OLwXPM+CHHeS88yJPqdPe5i/IiUiMfpI=
X-Received: by 2002:a05:620a:1b86:b0:93e:c12c:f134 with SMTP id
 af79cd13be357-945f364d640mr184996685a.79.1793938212273; Thu, 05 Nov 2026
 20:10:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org> <20261105-late-2026-vma-flags-v1-4-0d3cd15ab75f@kernel.org>
In-Reply-To: <20261105-late-2026-vma-flags-v1-4-0d3cd15ab75f@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 6 Nov 2026 12:10:01 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zfovh2t9zNeo2D6+TqPbKeEeoFniTyE6DQT8w8stXNhw@mail.gmail.com>
X-Gm-Features: AclHuK-3k2KPmLqEqbOgFVFtxh57Y4Ge5X7nQzdyUQMEUj3H7k7EkhGovaoUjnE
Message-ID: <CAGsJ_4zfovh2t9zNeo2D6+TqPbKeEeoFniTyE6DQT8w8stXNhw@mail.gmail.com>
Subject: Re: [PATCH 04/13] mm/migrate: convert VMA flag tests to use vma_flags_t
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
X-Stat-Signature: mqoqyfz1hdr8fuetpeaojrxfaetmdasb
X-Rspamd-Queue-Id: 8E9B3100002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793938214-991681
X-HE-Meta: U2FsdGVkX1/mO8gzTqmRrQk1EHypTIT1qDUUazGtQDPzZKdKlHojDHwGJ8WnQGuxDHOy8g8MuyejbFHlB90h8ACmm1ohTDBxv3kXPnzIAQOPHRlvBNrNPyyXA12BHBBTVPXfWyFzwij+RleXIcLOQfIv9/lcseYl25lDic2j3hDU7i0cAA6TXAFPzhqgy7zhDCR0L5p4H/GI8BfxGJVOG6Yst+p3h97XeGwJdSlIylYolr2OEe/+Ge2hK16seU/ozz2fGa72s8THEC3d9Kw1wOHWPSsxngGDkpDS0m9QkV7SHpABZbiDgmVsxEFPHp+qMkjSmOmqa96d9Q9uuzN4vg30Re4QMePjiPdetxhXmvhr9R/30jciA9VvKW+MfgUDdQUWri5gEgvVgjX0wxOCwA8cavN8/ZYwNL/PF/qyEhQuqZyu5dHsYN9kEqxxxJXYPmgsLpYycNFHZNvn7mIqwOMzu9Q7TVJgGkE+gIkbyP5UgfA+A8fEGfIrGhr5lyl6/H74fe0J8tP+ud6vWuLnLTA4VodhAbxxok2I9qwUhrrX1DNJW5b5dXMeXH543B7fb4rhmHBVN3f9bX5tLC6Tr3rcvV9Nefcmcw4eBnSTB1gWCtWYe7M2YU79gflt7nwbkiX8qnK8E2mU/xgULOWEkgRhu23WxvMtNzxVm/oEYGn37f1uMJkIapV2brcfaUEnQcrNncydorEFD2lsbxSk0hglaHP0HiqVV6YkFJzOfsqmXPiymDXdq+UTjY9zpJgHmU2NlPy8h79qN9oKlOwoplLgxwdIjGGDib2rqu6vU4Gixbr7Bg2DJ5LqA9uNmpMs2J8R0tFI/101k4bO3IJ+oMboJpljdlaPRm7L004ay3OGX+aqtB0OMC2JxAfISvZzGRbdeLXVh31W5eny+XzwILrZgms2D5uN1Ai+mng9EZ9KE3GtReFe9/Ymtu3dNF8xUA964s70epOKDG8hYyG
 62+mVBHh
 XIUDVS5bJ0fd58RYmJ/4Nj/nDdW63P0YW7H7AlquV4OXw7yVnWlG6MJMRL8oVh1IdFl3cQ1IjGCEd7DC6mJKUHLhZeA9hOSBTmjG2z0lRXVKwZeqkiYA0nMa5tLlWI1iaeNVajwA0fbKfEJRRhCgxEC5ux55aPnH9WnWjvVtrlPAzwXUo75LJB9qCHbJQxx/ToEemL6QxOguoaFUrURQprVzggejCfrffSBbKVn/PwB81LDrjzqjgFpG/G/IHS4cIQT76Qx1KUWEnu9evHEOLd6xJ4jC2FQabfa0gMHKYiEDV6ENb9Dx05huYnvwSkp1lTJTBiL31q43ZHMd6zNqc2tB1Wd2emzpgYuNqYZn2xli2oRMF/fHQ+KXk0AMeILLy4oT5FeqFmz5fsDj/HFSENW7twuEsW2g/zgh+nNpqdB1P4+A=
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
> Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
> migration logic.
>
> We retain the READ_ONCE() of vma->vm_flags in remove_migration_pte(), as
> there is no vma_flags_t equivalent, and arch_make_huge_pte() continues to
> take legacy flags for the time being.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

