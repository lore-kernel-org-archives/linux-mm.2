Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 490D5C5AE5D
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 08:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338C56B0092; Mon, 10 Aug 2026 04:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9B86B0093; Mon, 10 Aug 2026 04:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9626B0095; Mon, 10 Aug 2026 04:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D96686B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:36:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72A141A06D7
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:36:57 +0000 (UTC)
X-FDA: 85084704474.08.FBCF5BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CF74A18000D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:36:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WG9vfruA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786351015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JV5WNgHkpKWzZzTADt5HV8WfufvTRE1W/LdtA3ppIU0=;
	b=mP0gTINdmlVYItCGz2qI+fQ5Ws7yIAP8MSmoNwVy7GeJpa3psLCp3BA2mr+iR6iJZYZ0v0
	4l1XwH72wJTC/Ld+b+4mbZIhHPxdb4WUOJhfJYFjG5snlI6SnFPBBcjGSg8CcJXBa/k19i
	M2suL+hbaErqpc4PSKLC4wCWL0LLUUk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WG9vfruA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786351015;
	b=wJEt4rAg04NodSuQMMVtCJOfznRDJ/GBt/0N/lvY7MWdWXK4+1EG6n5VEGkrSTK8TfyFoT
	c5grOUt726tQarztfa+9ILG5OjrA2jcLE4mjnByPt+pMfmaIaIWGBbaAeD98Q6yeXPciWV
	MTFN1Yx1PTy0qyhiQTu0t/xcie8ZSfo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 765AC600AB;
	Mon, 10 Aug 2026 08:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7FC1F00A3D;
	Mon, 10 Aug 2026 08:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786351015;
	bh=JV5WNgHkpKWzZzTADt5HV8WfufvTRE1W/LdtA3ppIU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WG9vfruAdcqV26E8riIECGmFnBJZd5QFGEF/vLwr28j8gC4/i7xF0ppv5LbXGsZXX
	 JxNn+AK3ID5hxM+oY6+3ga/4g5kSAUZ3bpLvKsQ3jdW2iUMHhzYR8K+qeLV3wBd+SH
	 VfMjlXUAPInIsYgKwkG0faj9NQPkTn8mbqTh93b2RkQ6vc61GikkngdVPvCYS8u1v3
	 Bbmd+K6Qvi9MyaqQYp3ipshXdNTBrXxLxAhKWBNy+rqBS761NXJu8HVp2apMLGHoSi
	 TNqEO7IDleHDyLVMiyzHc0N4UA6L3SFYnW+RHipKKKGb19601kNwdtCQOjQmzQOcPt
	 EgpNCWtEiomWw==
Date: Mon, 10 Aug 2026 09:36:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Steven Price <steven.price@arm.com>, 
	Liviu Dudau <liviu.dudau@arm.com>, Huang Rui <ray.huang@amd.com>, 
	Matthew Auld <matthew.auld@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/20] mm/vma: introduce VMA anon page offset field
 and add helpers
Message-ID: <anmLnvWAyIJwjsXj@lucifer>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-1-ab318a350404@kernel.org>
 <CAJuCfpFAA1H2pOi6EOarNtrdzLQDJyhm6QOGsfZ4SFTuM5eiLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFAA1H2pOi6EOarNtrdzLQDJyhm6QOGsfZ4SFTuM5eiLQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: jxymj7tmtyzhfwqa6z5c8ysjb6difzsb
X-Rspamd-Queue-Id: CF74A18000D
X-HE-Tag: 1786351015-931895
X-HE-Meta: U2FsdGVkX1+pfI8RMdKnxIfPN/XWt+1FB3k//PS/M65uOkwZZL094xq2owlOvXs0PmxKJxUv3lek3rs9AKnlU40Ef97kuaWc1QisehxxJUyyYEo3qUTVli/DiwofRn1cIqxYnxHj7Mn5ZTcFnf15Vqo/eIitUYxOZ83aGEx9BlCyt0N+UBLccFc6eS4PADAu3gqvbL78i/ipIN0C34k3i0f2Fc5Er3F+GU/AkN91DzEunkuM2KTXlDrscgfQhFLUXebCY97gXTqyYbTjKVitc6HPqlMPXfpv8sWUbAD8zGGPUlp1r0oc+DBy0N55QUyAIyHELAJfGbHv4ayola378Wo2GPugVjHKCyWMMQEJHEOLN7OnbDxNzqxZuVECBOrEMI8HHISk26mQjC6ycRH3JLbdrbkpBCsdAamA/nhYGKob0A38MQHQzYq0tsIKAatsnAjCUdEGSo3OjP3XN8LY2w7T54s05ZTVaduRDZsiIt5dyZ9JHVMMqQipygChRCyE/Nnkk/fZTHuXu3aszx40OWugU25WaW6IKHsiY9EJXDAKteGb1qNOqHT0WDUcTZ7MLWRFQx/8ao6lVusWu5bB1z0iGNQpvtrUE1qNHpNoY7EkGnNzNpz4yc1FWbwI235OYZlWsMhv6AM8dSKK9aW3hxXhpJE6QbGF8P2q7qYp2BLXxVJg/1iIX/5LqT5dJUmCVOCCyh0qBQ1sg9SWtmi2f/Dfmmm9DZpwwIWwv1lpDzTQtdbpEsM51BjPGy3FEYnwlYdlRwC8nfKTgSmYrxdltb5rjMIeG6bgYSiPnnpite3SPGvOCi+m41lxKt3HMtP/W3Kv85rgsj1E3MxRnMjRGrhVQEvbZmLUf7mKsJkiKS7HHKdpS3PFMOSKiPDlBg4GJlhgNauFa22VaiaW1wJHmlGBU0u5p0BT3hSNXR65zQyXZbLJWgG9mPcmfh/mH/ifpDbmq8QjYnzG3jM8A9v
 V8Typtmy
 HsbAAwfouWBlBkryjBPcx7pmEzzwemAaucvKBaN3Qtk4UpXAqz/uK/5xUP8Qwq1skU7j5T7EdnL64sr5OUwaZ6IZKKGgNpmTb3sHs5xFTAYtsDgX2y3wKmzOnzVkGh/spv7PG9tGFQYDisBb+cEHL41iWdfiWn6jRKFLc6VPyIensXOI8sp6jYg5Slil1x9CVk6z3PNMQS/Mut/NxFKcOS50Gj2KDaJXef7LZlfJAEJhPMozVuLBVIs+CJcPJmcrnvIzfuNSU0IRqKq8zdNhOb/qMPonkuY9+ypOBH0Do+Lela/1WukJiXd5T9Eo6OizDdjFe1nrrQHbqbrZW2SZAU+TlAxWqdjKivupJF/P1VgCzNQBloOBNhxpuyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 08, 2026 at 05:51:10PM -0700, Suren Baghdasaryan wrote:
> On Thu, Aug 6, 2026 at 1:22 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 87feaa5a2b78..df78847f5f07 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4393,6 +4393,65 @@ static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
> >         return vma_end_pgoff(vma) - 1;
> >  }
> >
> > +/**
> > + * vma_start_anon_pgoff() - Get the anonymous page offset of the start of @vma
> > + * @vma: The VMA whose anonymous page offset is required.
> > + *
> > + * If unfaulted, then this is vma->vm_start >> PAGE_SHIFT, if faulted then the
> > + * anonymous page offset at the time of first fault.
> > + *
> > + * If the VMA is anonymous, this returns the same value as vma_start_pgoff().
> > + *
> > + * This value is used for tracking MAP_PRIVATE file-backed mappings by their
> > + * anonymous page offset.
>
> I assume this function should not be used with shared file-backed
> mappings, right? If so, maybe add a comment like the one you have for
> linear_anon_page_index(): "It is not valid to call this function for
> shared file-backed mappings."?

No that's not the case, it is valid to access this for any VMA though it's only
meaningful for MAP_PRIVATE and anonymous VMAs (though in the latter case pgoff
== anon pgoff).

The code keeps the anon pgoff values consistent even for shared mappings because
- hey - we have the field anyway and it's easiest and safest to just keep it the
same.

One alternative would be to have code that checks the flags and zeroes the field
otherwise , but then you have problems like - early on initialisation now
there's an ordering requirement which can easily go wrong.

Another alternative is to just leave it stale, but then that seems objectively
worse and again requires branching code on update and set.

All-in-all it's easier to keep this working the same for any type of mapping,
it's just useless to do anything with the anon pgoff for a shared mapping :)

--
Cheers, Lorenzo

