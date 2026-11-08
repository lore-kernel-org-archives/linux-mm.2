Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C34606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 07:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YYzPMZ5U
Received: by kanga.kvack.org (Postfix)
	id C13BB6B05B0; Sun,  8 Nov 2026 02:42:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E8B6B05B1; Sun,  8 Nov 2026 02:42:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D526B05B2; Sun,  8 Nov 2026 02:42:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7ACCA6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:42:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E835F801E0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:42:51 +0000 (UTC)
X-FDA: 85411160142.13.0CD526B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0F99340002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:42:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYzPMZ5U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794123770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hq7itTvys1Cr5iB10ff6BShqs7ZRME9USZpaeDEQWac=;
	b=lmH1ktse82Xp6Goqnz4N0DKuieRk02ZdHQ0ykqfkSg61K+INA0mqgc0GuhkJXdSV8Wdisf
	wFmfYmmyyXtX8zdEiORqIlTrD3fho9o3PBZMpKqdLdbQ0PZaHijj25Pytl7992uxwLz1SU
	Ze07jOiOtfi5XOMsxusEHbdKn1VJhVs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYzPMZ5U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794123770;
	b=aRQwrCeOWmS/caK/4jkId4WJjUMO7EnNWMRchcAmvTc65kl/ThYj/+p7B9UbuzpJ1dDQ4Q
	Q9528wuG7OQA2AyByJ4RPtwSPA12cglvqwnkGMu/2aNMAtUbu487i5vvDLWH7Q/dZntKve
	ZLNtN3Ty+f6STErdxVNSBgXV02532bc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD93644CBC
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B751F00902
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794123768;
	bh=hq7itTvys1Cr5iB10ff6BShqs7ZRME9USZpaeDEQWac=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YYzPMZ5UtctcPpcRnUG9P28WIDENCXgambK8yjDHypKWPFGpIe6TmQSTfVWfDmpGF
	 htL/bA+oP45fy221Tgu6ZPP7QU2vcSC93rDug/R0h+uOCBTkU1oP0mPO+pyxMd5Jhv
	 CoAb6Li7/zd1myiQ7koRfQVHWASdDYrbjZukStnwggMZVNq956usiAsIIcWfeSGjdW
	 iSMgTz9CV0K5nqhUcTrsYwq+gTQ/+nc0FgUX+3dzs0cCh5Ji3aeDIDDg7dxyAQsBEH
	 YDOylo//GrfIXsoUpwEHk900nWB9bv6omEL9JYaoBp+LZY4PiSIKEnYc2zNwFMh3Sx
	 bBGE8vXHSK+Nw==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93f36c18b75so11746785a.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 23:42:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGUzZCi5oPKNCeumsrzuZalxZrOgJ7+BLNJ8fMNkEhLdrbZrIm3dWsO3VKqR0v1aoV4xHrC3QtPWw==@kvack.org
X-Gm-Message-State: APuU4Z93TiD1G5Z9YlkEIqQeLP15GzN5LY0i2+rIibMDvatfy1u9smBR
	vClJhKT+cvwZLRRjbSDSN2ZzWFvitSU8nPYO+AHx8aRo9hy4GUo2a38ltjDU48sTBkutwcEzLGq
	M7QNEIi7lZoW0QY9VX2QJYw3ipG6quRI=
X-Received: by 2002:a05:620a:29c8:b0:93f:6f8:9d72 with SMTP id
 af79cd13be357-947842d0ca0mr101856885a.77.1794123767495; Sat, 07 Nov 2026
 23:42:47 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <20261105-late-2026-vma-flags-v1-2-0d3cd15ab75f@kernel.org>
 <sashiko-outbox-200257@kernel.org> <au2_PPpdAMgRJZtX@gremlin> <CAGsJ_4yWQom=cG5vw2B-FR8+7wNU+rwZkvghjAxusym+3OH96A@mail.gmail.com>
In-Reply-To: <CAGsJ_4yWQom=cG5vw2B-FR8+7wNU+rwZkvghjAxusym+3OH96A@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 8 Nov 2026 15:42:36 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zvRSUSspBe_hNwTYDjK3-TLuq6Mhi5gDyOPZGDXN8gDw@mail.gmail.com>
X-Gm-Features: AclHuK8HH9jkrTpk3YGZtn3OLDvb25GlEH8O5QS1DwT0MQXSYfuXeM9FnX7dKXs
Message-ID: <CAGsJ_4zvRSUSspBe_hNwTYDjK3-TLuq6Mhi5gDyOPZGDXN8gDw@mail.gmail.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0F99340002
X-Stat-Signature: n5dbq5qwug8z7smoyf5zumip84ibbnez
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794123769-598680
X-HE-Meta: U2FsdGVkX18U61XCUKEJwZP109iTXMiND0nfi3ZQGVYYASeiQwGlUq6dtmmUXE6vNpnVWwhVEf2AZsp3Cc8nJ75Bc9RUeaOpH+ICOKWb+GQ8wChE6F3cxDuzomPqKH3RhPa/JfTju+9n64QpFWc9mKipcV0MUggy3qxc9qbfifOehUnjgYYQ80RLMIFgkJiksXafN1G2554YFrpJEm4VRKFG6fhR0zyxr2SjsKTAsEB+Yio3BOe8nSUf6d7GdJdFKZ4baMCjNuweaxEVaacVvtFoHA2986dkzJ6uy0VP8P14bSrpsMsM4ZriqgzbiE8vbm8ErZ8LT13gGm3K6h93BI4hMo6c4Juu+l0vF67zdikHkwzT6tTAMY3JaBB4BjCBFh3zE2g4/qhgQFe2LBx1A/csyK8ozrtd+F+k5bj7yALB7IytoPwYUmYJYS3USBZW729lwx3c6UARY+0ghiNXQo07O6QUnqWIhNAXA6gmlKxfsVrVHSb9wZXPliEbHc7vMveYgl/7K2lZvB1vgw0N7ej1Id4s2U8GtbsM1yyu43JaUYZY3tj6/wMtWKezQWQ4o/96L+8wDeKHLlFeirElQZ6EAI9gqldpXaOC7z215vTiEQr6otJYJXcHFSM+j+qNS32PdgXZrMDhh4+XaLdGC6LBrpu3g+Qaf7YoLtnVFDdmQ9LRr+DDyKxLXQaBSySTDdBd6cemVgzpLq5N1yIOOtDV0jLKuqZU+F7f0vWTnCUe6dKJaph1okak6MXVemud1CvTBYQv1a3o4wwJJtHedvGM2GX8I8x6VQ8G8vqhyjCdLdipFc35n7G67xVm/i07WWcZ7/NkBt+XCmQu6eXZh8HAbTBG6M8qphjhETmiwO5E1vFBHv+lkMgWUVH9ccmhn/6rx2KsAr1ZCIo0CX6i3tFUCIldhCgpjUDS6FeTbl7T+tFTNiOg5ceCKL8m1+TQZqtPSXBCJHvAtYsuZox
 t3tji677
 FKlt3mrtjOup+Ed1RIZqRqZGee33uPKyPcwdc02CdkXnXEYbZm2HLq0f4Oe2EroJI7JwEsIIe0DXyCWg+o+Dop/Qs46X8vlq4z7WdU+9OsiYMLSrSAwCTLrJhza+9LWg9dOCTgC1XFTbFjiqOg6fOBR8LaaJz5e4UrLE4s+/mjTI8OEkqB8aGd36xRY8Htd36PMq8HIsQq6zzgaqW4otGcU2XWhw4MoEkKLai1MIlMliz8FDWeMpRQ12+/TepU9ksumSo2Ri3UA6PQSyzUmBuysFb0sQuGqJtZdsn9fH0JqYjLGh+5PkW9a6gk7RRHDj00uqZFYlRd72x4RcF96JQCudOuyWd4mHaOw4D2HHBI2K6eVB3MQ0B2w62rBkU1qWnMCTrJ05br6AptzAqAsjJ2cPhjgrFhbkZe2W38djC/B2ZltPrERJx5FoilCgCxFCIdSI+9Glq9P3zLGMYlml48IIn5PYA0656CV5F7WHTNMvDR4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 8, 2026 at 3:20=E2=80=AFPM Barry Song <baohua@kernel.org> wrote=
:
>
> On Fri, Nov 6, 2026 at 7:53=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
> [...]
> > > --
> > > Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-late=
-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org?part=3D2
> >
> > It seems these are valid, oops!
> >
> > Andrew suggested a fix off-list, and I agreed to this as an in-place fi=
xup to
> > avoid respin.
> >
> > I have also updated the series locally to reflect this change:
>
> Seems like a reasonable fix. maybe_unlock_mmap_for_io()
> could have released mmap_lock, leaving the VMA
> unprotected. but  ra->size *=3D 2 is still going there no matter
> if the vma has disappeared
>
> For the original patch combined with the fix,
>
> Reviewed-by: Barry Song <baohua@kernel.org>
>

BTW, one question is whether mmap-based readahead is
still worthwhile if the VMA is actually gone after we
release mmap_lock (or the VMA lock). Perhaps we don't
need to continue readahead in that case.

However, we don't have a reliable way to know whether
the VMA is really gone until the page fault is retried.
We release the lock to perform readahead, so in this
racy case, readahead might be happening for a VMA that
is being removed.

I'm not challenging this patch, just leaving a note
to think about later :-)

