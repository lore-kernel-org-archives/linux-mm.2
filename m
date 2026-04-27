Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 599B3FF8864
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 21:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9186B008C; Mon, 27 Apr 2026 17:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859B16B0092; Mon, 27 Apr 2026 17:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748D06B0093; Mon, 27 Apr 2026 17:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6375B6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:38:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECAF814011A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:38:32 +0000 (UTC)
X-FDA: 84705650064.10.07AFA37
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id E3CFF12000B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:38:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o+vqGpX+;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777325911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/TVU4nsu4bcRfWhQiDtREc5LpuHyEjGWAmgNF/qgKo0=;
	b=PfoeQE1Le7Vygcr/Ep1J/HKbwOqt2afVbSzvCWjUIxkeCgCJHeLfl+FnuZTf2L9vXhYmFV
	eNMJtIWOEizllWgCkUi1cU6lCM3CvlW09Qc5XyvU8/tLyjdYsanJL3SzPoBZn2O/qjeCiC
	snva3z5HRToQoLSQDq4jEvfwRiP3SI0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o+vqGpX+;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777325911; a=rsa-sha256;
	cv=pass;
	b=h6B93bBzRQcO6uYKagLKQp/ZQzXNlCcfZVolUDdjqlSVBpC+pNZBbTKceu+vTy0OBD+HmV
	4lV9KweymOLZ5iCowHtBIhDFnslwh6nL2mRyMCJjYnImFMPSQqHcLeCXfFkeo7JqVs30fl
	LQmAR3R0KF9UPke8JBuF8Q28zzztuyI=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488d2079582so126728865e9.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:38:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777325909; cv=none;
        d=google.com; s=arc-20240605;
        b=HWUo6b6X5nxaHLMTkSTGdeWOk5hCOcHP2uOFjarLBDaTy0uBKSgQhyWNVM15Fw7/02
         H0iADM9Md9u5FZTBN77mhfIybdbmHQz3nmnj/XpYzaFCIReT0xNN89iFaW7fjUdcFi3L
         7kJqE7GFsmqcCwDIESrK/Zi6QC2nkJnIT9K8FWuXjJBFe7J6gx2dfmyiWyedHL/UYbVB
         5h1+aQ2pGNO2UhCsroGLowbSOAakcx5hRITt50id8rTa87On1UncqjcUYTUbg+I4SHuY
         bJPFmuaD8CmzMoUf9uA5IEoclieAjHmW2EF6OisvA3oHGyqd+a6iM0lzq1j4zSk+39pW
         d10A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/TVU4nsu4bcRfWhQiDtREc5LpuHyEjGWAmgNF/qgKo0=;
        fh=LR9VjZEuGV14JEljm2om+kOF1l8fewzKmow2/+vf5Hw=;
        b=ZhRCEPmuThAjneJwJJyDWPfFLEM04M8xPuC+jPVfIoCeST/jzK5MiMLRluNkUbo3cJ
         xkLaPofLn0Lk4w9zOicA/GUiWJflC2DatXarAypF50nF6K0QVIurzIOFpEUF55mIm119
         qKdNRgSsJKp3EUL+GrrBIHi9EMOIi4nrKSeT4mCuJUVAwKYQeamUBr/fXA5QvrpRBN7v
         9vkUcHB4XnNyAhcI6IB76ktbdSQ19VJfpKU6EjU+8qge7K5RYh0hNXeVHpNyUbWuUi3H
         rZmr9dbMh2N22cdp6gvJD0IZlLQHlBn4kvQZdQrxVX/YYFvGH03GuVyuxtTQqCJdINic
         2Gbg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777325909; x=1777930709; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/TVU4nsu4bcRfWhQiDtREc5LpuHyEjGWAmgNF/qgKo0=;
        b=o+vqGpX+qhWFIehj/Mjr0+9U2yrWbUKZ/M8XaJm/svHizibGFQzg112fGHhzwjVV2n
         m4Ee6qN1hzYvM3bqwW66oGql7deURR5hRGjockD3UR53GtJ6DVQcxsInLOMMacDrR942
         SApZi/jDjUakgm2+0VejfpxZ97Nh9NnsBrAi9+du9+zEMgbypEqTJt69X0OXBtRmLxl2
         Xt7zSRzyCeeUrXNTvjOf74f1YUZIrffgK+DFogn5D/i+fzJUtZQbpSR0oqeQOIjdnzmE
         d4TLA6C/zUw+oPz3r0i5qYKY/QdSrSAYnkGTRYFRpd4CwN7VzSdoKwEElN1U3zTKhQvd
         t/RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777325909; x=1777930709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/TVU4nsu4bcRfWhQiDtREc5LpuHyEjGWAmgNF/qgKo0=;
        b=aJ6z0wwSTpu6UH+e/WQTIMEDXhSpHLEBuaIo4b9/b/N7gDQ4wOrTl7y/PXImt5DGh7
         mmitASnBBlcyEinnmgfjiQSabr4Dpj4xFC0B5+7hmPN8T1wlUczJ4JTCEpy2gH2OcJzp
         50ZbRymJS1ZpsmTjgmhPLaKlHFpOCc2WfQx34GOWwXAH+awkWK1E6oOr83QZeFLMGyMC
         M2q3to13mXZpUencN2GIWHQGpsFHO5Bdd4du69S1VPDXi9CA7jcjFbbtlNK+rYeHQSOw
         lBKkXT1A8qU+HFhnf95IOlvH3Tp/3awAi5oBXQ4fVZpXNEzBTRBwxDStTe0KCBXTr0/0
         gGcQ==
X-Forwarded-Encrypted: i=1; AFNElJ/02MvuoBx5V6P/rVWm2XAmLjODcDgUlz8phMP7kMilY5qtmZhi+aNXLLutq7D67yhFQVmC7WuQUg==@kvack.org
X-Gm-Message-State: AOJu0Yy0UxSgjrIkQQEnUoc0e+ODvkV0MfDXGk9aBMGv9nPyTLYbuCHe
	ZLMcVAIrfVCP3xH7RefZaH6yKmidojAFywhVOFLTYxoVPExLUPu+XwW/OdnhmBVZgQxXa/icQAm
	YZSnO3WXLD8WHY2o0mfmX3SsgCWfSDng=
X-Gm-Gg: AeBDievYtaBa14twVpExGG8hmckf5syo9qEa5VeRD0h94Fds8zoEOSxyKxyyns18mC/
	Fz2/5FpZhE1Z0CktWpEpYAo7x3wxQZv/PNPSSepE6sPy6XtI8kMiAgnk6k9ZXoCNC953arPnSJw
	eSF2iKMn0WQpH91KdytgEhxBiuB6mvN45CUEple7vj7ySdjGgtXbiXuqDsjb3P1JLIiTD/9denv
	2icUyHKmQyqm7GJgw/BusYbCSHYSuzfEkRY3nDvgDP8kb+XYvbyNgO8RQvEh9tAK+Z/8Bisxsjn
	iqH1bwV1I6l+lIKHTMqn0UqkJCxwUFy9CX68FvMcV7surT/LJcUrH0zwrsX5pTUz0QrmgAAhWI5
	sq14=
X-Received: by 2002:a05:600c:34c6:b0:488:8840:e5ae with SMTP id
 5b1f17b1804b1-48a77b25335mr5030135e9.24.1777325909037; Mon, 27 Apr 2026
 14:38:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org> <97192ac3-643d-4393-87ef-53a9f3ddaf95@kernel.org>
In-Reply-To: <97192ac3-643d-4393-87ef-53a9f3ddaf95@kernel.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 27 Apr 2026 22:38:17 +0100
X-Gm-Features: AVHnY4II_oIb8C3aVippcvmoyZheListN6_PokHgWDygL-8vIswX205VDGz9ilg
Message-ID: <CAADnVQ+t549-aWEXq=ZUN79H-M=std3-Q8w3fU+dyNhF7mNjyA@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: remove page_mapped()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett" <liam@infradead.org>, linux-sh@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E3CFF12000B
X-Rspamd-Server: rspam06
X-Stat-Signature: e6m7sf1tduq5y1oqfo8d933tuu7atonu
X-HE-Tag: 1777325910-236669
X-HE-Meta: U2FsdGVkX1+EDrZCnt8TDfl4kr4P02tqPK1Xmp9/ffaNgKVHi2NiQ8NqsAbis6WQGZ15fy8JIAAEwj7R4dgG1Zrz1rwMhFUsaaNvSp+Q4LVYx1DVNQwiKUkWzidFyg72O7q4BywAPeWm6gSXlFrYVSQBbqYO8k3Aj+NfF1++DenpU37DWMjS2WJ+IBzpPaxKXkVcuwmurFn6YiPzIGVS1gVUfXYoANsXsqrHiLSMdU7U2JSjmSCZjrc/CsRlZ7OFomaADvsGI16j3YRSJfwksszwXNcUJ4+6Jo6BZns0sIXNbSz2Zl4j2IssQNOG8WPjsQ8rBB8wQ2g/q9dikt2JlRT+vNqfc/ffa93n8/kiikA4dZReAXZge/aYahcyecrbWMbNjG5UR3GdTTZjbLc+n0SNWuxt6/GTnUUjmlrFYfJ4cW2+tpUZwvjpeuhrSeZCp6lcziC4IdDJhtWIYx9ASFnBsR1tCeJxgB/+IbLHynN2WYTg/sTc1LS9ZE/1ZLu7FQMpQqmn3oPPrBgDGFGQUN27aS1sm1/YYH3JKtC52aH46fSYQcZZFUDihGCru/VZIM4WDktY0TDon5FkQ7F9SMopmAYErCt4uBa/mQPgvqlfKfPukSK8q3FfaZpuxOAInKKIzclpP2Dt3A4jY1bDBG9OAdaKAs48SPhRk8dGZkYqC0uIK+QtJJyQNLKlLVt7ZtKabfWmQA4c9tqo4BKeQvGds/jO3OUAPXxF3+Bq9ZgJ33bSS9GSujMoxwV990Xksr8nHf5ZG3B+Qb9UPnvtfCo16KeHxpvN22b2ya2EzZvKRgkk8kz3jNIE+Mw23yinFDLHvPu8b+61hfVG4iwhKvU+DT9giU7YNqG6h+Tjis+LWXquM/yTT2+8hzqKbefqjltKW5bJhJLjoIzzUEpo1b7mu9Vx28HucVrj6IOT7Fp/ybL3KZdO7lISIf4LEQDQGm2URlgWpRiCqHoPotg
 RtjVabZ1
 haObQaBrvKBG+8PwyVRhgkZEEFCBmU0nQozEK54owLCmBmoZNXif7qJbnsrYokDVaCodJTqbgcD7PTUos0CItjJhg2WNpSNb5eh++t29LAcMe2fAybSvFKfS+jEd/ZkwLZD0TWH6vIH9wsj+DFEWCJmoh1vAB4uBAAjiUURU5jt/lNaJG6Q4Bm2YMMeP5f2z8OIdABtBpVaWPsttyHJiO6DOIfSkk43HFT3aFjFs6cf+eYs/iMHV9TRBZFMIUoXxujIZYbFt6tDIyh6GTJ+vnvElfPj5LcURto2K7RHIot38rtozRURSaC/DegN9MpgUScdgB5Jxp1a6Rwb6GpmhHhINRV4jH3Xk1UxTeKqibB0Dx62jKGXJgAqeUwTG8ptexiIotF6IMTBaoxqDJ6SJKzOnfVGinpzhZnlmWb2orWGk3MWxC6TTSXCyMSVpAVG5qdB8/Old3ONCe45s3gi8WjpPEfzO1Dq26E5vXbhiWdQOtY7vfShJ2yQ70xHt6zDqgUsbFPYzC2C0RTo+8IBHw+udod7a7XFvBqMlfsf/jlOLnffphFdlxUcPk6i8wbAehOnG6h3UhM1hSPnhFiQ80b8k5oQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 9:59=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/27/26 13:43, David Hildenbrand (Arm) wrote:
> > While preparing my slides for an LSF/MM talk, I realized that I did not
> > yet remove page_mapped().
> >
> > So let's do that. In the BPF arena code it's unclear which memdesc we
> > would want to allocate in the future: certainly something with a
> > refcount, but likely none with a mapcount. So let's just rely on
> > the page refcount instead to decide whether we want to try zapping the
> > page from user page tables.
> >
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > ---
>
> I scanned AI review and I think it founds something that is not related t=
o this
> patch.
>
> We use the page_mapped()->page_ref_count() check as an optimization to av=
oid
> calling zap_vma_range(). We must be able to call it even without that opt=
imization.
>
> Just like the bulk zap call earlier
>
>         if (page_cnt > 1)
>                 /* bulk zap if multiple pages being freed */
>                 zap_pages(arena, full_uaddr, page_cnt);
>
> It talks about concurrent "munmap(), unmap_region() executes unmap_vmas()=
"
> racing with our zap_vma_range().
>
> Looking into the details, arena_map_mmap() calls remember_vma(). We rejec=
t
> mremap and VMA split. arena_vm_close() removes the VMA from the list. The
> arena->lock protects our VMA list.
>
> So in zap_pages, the VMA cannot go away. If we find a VMA, ->close could =
not
> have been called yet.
>
> In vma.c, we call remove_vma() after vms_clear_pte(). So after unmapping =
the
> pages and freeing the page tables.
>
> So munmap() can indeed race with zap_vma_range(), and the page_mapped() c=
heck
> would not have changed anything about that really.
>
>
> @BPF folks: does BPF take anywhere the mmap lock in read mode before call=
ing
> zap_vma_range()? It should do that.

Yes, but do NOT. As I explained to Andrew.
It's a git mess. I don't want any more changes that cross trees.

