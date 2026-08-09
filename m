Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E83CC5AC67
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 00:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 826F66B00E4; Sat,  8 Aug 2026 20:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FEC46B00E5; Sat,  8 Aug 2026 20:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0176B00E6; Sat,  8 Aug 2026 20:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23ED46B00E4
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 20:50:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DE454031E
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 00:50:03 +0000 (UTC)
X-FDA: 85079899086.21.DC27E57
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id A990380005
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 00:50:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XzSwLwdi;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786236601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glHudYQR7Sx8Ip0RwDHznG86gS5ZxNzd6JiJvbqbi6Y=;
	b=OrJj9gmoi4g1cep9dz2Enl9gwVxN6xQ+hZxfNMVV3rCdCAqGQhJ6zmOBJEDGHSjaONTruv
	ry7zKE5Xt4HseJHV24wOpQg80QmFgHON+wVkq3F3zgDK1fEvtHGYUUiVuN2LIsO8Yk+jeB
	GnV58rRWF8k6YflwsZOdvAF37VQlN9I=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XzSwLwdi;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786236601;
	b=Ht5UC3DsbOPy92/+CCYcry1P83y57FukF/uORSFmVCx5o9d++AXtiFg2otYfjhb5btuzdK
	rSzMCnijN0CuwMRiU4Gd/XltHo5cRk4YnpiBQYc9QiVFLLILkQdJg5USFx3kzZu6L6z/oH
	lwFKVZPG7WnS6YU6vgL1ChPZCbQUuXE=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c15a5b265so178331cf.0
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 17:50:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786236601; cv=none;
        d=google.com; s=arc-20260327;
        b=skt+jhmh5aeK0g/5wEc5x+jXbWifwu8Hkl6wqQ4NTekaXydU95muC0efmTx2rpMYK1
         YrYiii14bGpd1k9pMK5v3pTLNWZAzFrXp5Pb5QFnqC4kt0cjkinxaE/RjtmxG+Jciij3
         gcJE9tACa17CcNn0BNb5Lftb1eTYzThdckAIB6GEL/yfGQDqw+GwORtp2vZCiLZMOkyh
         5VW4UZcn14Uwm9H9V+UehvOmhGG02wGtMV67QWks8CO6mRefX1giXEFB4LHTqRRmag9y
         68Knxes8vf2HHT8awl7mzQ42ebWcV6BHwkvgiLJVeZX2ZofxNk4Dlx2Qq46ok8jQbRuP
         neSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=glHudYQR7Sx8Ip0RwDHznG86gS5ZxNzd6JiJvbqbi6Y=;
        fh=3Kf2fyuQmRcEgpwyRWwo9eG+SePcgTgOOqpoYSYaGp0=;
        b=ajsu1cJuqr3VtkInilEYdP+DnkQ+cN6w5h+dizh3palUn06pMoxVSByCRJx74UgLO4
         6/LcrcpQJogHiTxnYD/ozlPVbloENqbp2So8Biw3d/PB9Si0BjjdwA5DmotjfxvqKarl
         aWJVvd0y4lcqRE/wywUQOffa10qXjrxqoayhC5LrO1h9xg5SSYyddHogvvrLlIeIwkfC
         iIa4BkjuRDQjYo5NIpui4Z5Vt3pT3oj5KqgYOMTSfHnXZ1V0r1HJHQZ68i1L50K14ZKo
         sskw/YgpRgS2pASntsqjIgWltrReQWCgmhhLxPbitBzN5nv2wPkt/V0OlmanqFtxk+jU
         V5og==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786236601; x=1786841401; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=glHudYQR7Sx8Ip0RwDHznG86gS5ZxNzd6JiJvbqbi6Y=;
        b=XzSwLwdi7hGvQc1wtKJofz0opLvtPshWk+6vjs0ogyZjjZukCqToTQCG6IlQEsgYPj
         C+OVpjkkGewifkZOgPcewsBxEOVO/MVUQiylaMIftKe8+h2PwjApPQz8uRZk6Os0sFU2
         sSQZSabRk6RT/+MEy4sc+sHmXYTcU736m5Mi60FIy8+8WcKfuOzQNhtKszTspOQIbtkT
         ZGNyyG7OnNTU84Eock+/xYF8r+7MGgKPGBLVwsVGWsL7HME10yJmAJUjQzfm6ixUhm2g
         cfQkAAcRhFVgT3g1tQuAZSCwkbeognlWehgY+jicIMI9aokFm3rk2MFTfPLKwDtdqqeh
         kBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786236601; x=1786841401;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=glHudYQR7Sx8Ip0RwDHznG86gS5ZxNzd6JiJvbqbi6Y=;
        b=rS1LD26e9tZqrte7SDGiskmr/z4MCH/XVFiOjsrSdSKv5lhL3GS/n/vcLL/zEejNtt
         hIG8odJ9G0lzUDDOW1Hjxw4WLxRPJfJxX59QLFMRjpHR04QcnnBdmOxp9i7nD2dSl711
         LBm0lmCPvQjunH/i0OhI726zm1npG8A7upmApav1BG3SAOS92W4K0ZQoxuPR41yBBCv9
         GbceuZ9yhmcM6XefJ0ePzeFrFsO7QCxSm/fYTAT7ez1J3O6seMDY3acfIG+5Gzvqa/gd
         Bd1rT6pCdHYrMS6+ZZGCzIUdZzpmp5CgdHEdsvXA92Fens4tijAv/C2yeywyidQYAVM9
         rLXQ==
X-Forwarded-Encrypted: i=1; AHgh+Rofx9tMeC7galpKCDYAgU5DtRztXwDh8uGYlFq2KghVXBuvjhiQ5WNL1aX2Dc8UyoExZAlip86R6g==@kvack.org
X-Gm-Message-State: AOJu0YwDyX/oS05MPbI11y+qIjtRKkBLewlMGXRVlqdA1mPnsErbzzc8
	VlKYeCQsV2GmzLBH4tgYYZEws9IDcD/EjdP+o0aulA5ZPgfkrfM/4NTGIoZKhSd03iFrPUPZDDJ
	21ElK1YzstsXZMw/O93sg94TDEW69QuOi604Bcdhs
X-Gm-Gg: AR+sD10sjY6y6C9nBsyxlNsThy3TJaWtNGNm7s2BEzKsnCziPJzx4WMrY35dwOSf0BJ
	onvyZ48pB80Gi/CrxxM8G974LOg1kxA3MVtNBYkiuUvRjKY4d8R6jd4nsO9iPn4u0PmFkjUIV0r
	a2IdVbRr67qzPNKaEoUWeV6S0Un3mwY8V0+276l2CFWJY+vkQFEjWXte5plIB3blT6EokHGzw67
	ZOdiLHmkMwOqR6jmU29rEd5IuOKVEgW/ZK5DQ1jJYGiZXAg8YNHgdDSXDch2x8dYH74iNpL3hmL
	xC96g4sZDK94KMQ6CGn/81/WiLBQz0sbcqRdqUPWpB8=
X-Received: by 2002:ac8:7f4f:0:b0:52b:4ec6:52ba with SMTP id
 d75a77b69052e-52d23c37702mr15746931cf.6.1786236600065; Sat, 08 Aug 2026
 17:50:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org> <20260806-b4-scalable-cow-virt-pgoff-v4-3-ab318a350404@kernel.org>
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-3-ab318a350404@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 8 Aug 2026 17:49:48 -0700
X-Gm-Features: AUfX_mw1Q82W2dZ-6X55NWg9zTGU5sEbnBW6U_FzEZzOIU5ZiJmeQXvgECKsKPA
Message-ID: <CAJuCfpGjE66Duhw0r8H0GKBFDExjroRar6n5MgVOOQjz4ZfTuA@mail.gmail.com>
Subject: Re: [PATCH v4 03/20] mm: introduce linear_anon_page_index()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Boris Brezillon <boris.brezillon@collabora.com>, 
	Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
	linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pjke81p38xf98r81co9fbjw8mmwj5dfp
X-Rspamd-Queue-Id: A990380005
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786236601-246415
X-HE-Meta: U2FsdGVkX19ZWXugAuhDkql/JsrXlDYACWZmIfTKHDE7MiTyETNrlavvmI/z63gxr3c8O8FJ3lZKyuTWnfnal6qoi2LJVAQZAQwYWJr+T43gTo+gCVMCbQjMI0AjxzyiidRsY1z73wJ8i+4FpdQfh15yRawMh1aIeBdnRMr/NVTtaMM/M5XDhwalptJlNoL9kLxBAm552SQhuM6o4wv1tqrlkyXFfCqkFN9vy5KTbWncE6H228EWNhlVY48MytIHIeEy5LwAQGO6HMYFG06ZKPOz/8Fv+duOgrYRs1W2/wufMar2C6kXeWdCavMJKLwUtU2qLQ5jEgxxCrSWym2gxBcaB49+IqJCe/UA1QkYS5vvlJZ0NcWZlZ60jSuyApPCdjWIVgDLj9+SByYQ2yGyPdofbkniC5bT+UitlYQzjD0/aRKCpF7ss7Y7B+Oo/oydHv0VaIEczmb1rgMQN2Z+KsQnA3HyRhhmoaYl9ozy/OeyBA+nDpZCjKNCTyu3SqNmN3J7fbv2QtCyXxRKqPnrxWCPnSmjeXMTCotQo1AsA3KFFnuKmKEJ7lb3DMgHd4E4YwBLm9K4n+LRFKwt3D7z0HjnxZOyTYOZOwSNZilRJtVVLUem9Z0022GyGCyPPn4EgFTCv0C5y8XiS9dy87Dq/2QaM+egOc5x4IobxTTXrBLeeYnhB88QKRDUvnZCbSBvamNA1RzBuh3EVIjO234ffk3PGXjE5Bttp7yRH2QRqPz/FSKHUy/h6EMnUK3HIPO2S1EDJZmfuWr8IJNnDZN4lUpMt8q5dpaNv7rRPpGJ9hovQPdqSZdN5FffWU1XgvLuUmwZC/qxDEmIR8nH5shktpkEU2Y/u/eR7D82fnOpBc+5pyPaleOQyYxz4OxJHFV7JVuqsN2QaumhWzjBauw1ymFmZgA55V+Ihbuw7ekckbSamjp7TxbLlpsRDQM9I//5MK3v86L2SO3C9JrOp95
 eIewVuJ6
 aRckrhKAq92AxwwuZAerAbPP1oVSJQvYCn0MtEZFBU/UIoH+uTwjSLxnbKxCheaQBTuWvo9NITlyDl9nSi71r1mNbawYgQ8KUqMdgvb0dOwzZlDCKHI0HO+ti5/ZpvjFsRp+IQTeELJxpfV3fx6TYXM69e9rvQUFncp7+UN1XANPnxtrZpk8Zsqolqqret5D45zqrTX8F6vhV8LtZ1qhZFUNnK0HfbRt/OsGun1shjVDcwfcRDIQkdWVp3VgCQnAxZv+RrRcEJo13zTtaRRbqEdxOZlJMx8nTuDRk2DIDDGNPCXFjB6PG1gXcBd6EWqFzg80HziGGDVMymqDsLrnURz9LqAdRooHN1k1xSfzRAFF6CbM4w3JNzo7aYq8jaklvQZ8PD6FDZ32LHugcHDQGIf8JzP3z4qJ7exjFsY/SRa657SaPP2xadtXvj+uoj31knlDi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 1:23=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> This function provides the anonymous equivalent of linear_page_index(),
> instead offsetting based on the anonymous page offset of the VMA.
>
> It is valid only for anonymous or MAP_PRIVATE file-backed mappings, in
> other words CoW mappings.
>
> For pure anon VMAs, this will be equal to linear_page_index().
>
> Assert that both of these invariants are true In linear_anon_page_index()

s/In/in

> and implement the algorithm in __linear_anon_page_index().
>
> Note that MAP_PRIVATE-/dev/zero mappings will satisfy vma_is_anonymous()
> but not fulfill this invariant, so when asserting this we check
> vma->vm_file to account for this.
>
> We do not update callsites yet, so no functional change intended.
>
> Also const-ify vma_is_anonymous() to make it compatible with the
> const-ified linear_anon_page_index().
>
> While we're here, update linear_page_index() to be more succinct.
>
> VMA userland tests are also updated accordingly.
>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              |  2 +-
>  include/linux/pagemap.h         | 40 +++++++++++++++++++++++++++++++++++=
++---
>  tools/testing/vma/include/dup.h | 25 ++++++++++++++++++++++++-
>  3 files changed, 62 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a3368c542947..da36a6cc907c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1556,7 +1556,7 @@ static inline void vma_desc_set_anonymous(struct vm=
_area_desc *desc)
>         desc->vm_ops =3D NULL;
>  }
>
> -static inline bool vma_is_anonymous(struct vm_area_struct *vma)
> +static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
>  {
>         return !vma->vm_ops;
>  }
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index c6fc783aaee5..0adfa6605653 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1094,10 +1094,44 @@ static inline pgoff_t linear_page_delta(const str=
uct vm_area_struct *vma,
>  static inline pgoff_t linear_page_index(const struct vm_area_struct *vma=
,
>                                         const unsigned long address)
>  {
> -       pgoff_t pgoff;
> +       return linear_page_delta(vma, address) + vma_start_pgoff(vma);
> +}
> +
> +static inline pgoff_t __linear_anon_page_index(const struct vm_area_stru=
ct *vma,
> +               const unsigned long address)
> +{
> +       return linear_page_delta(vma, address) + vma_start_anon_pgoff(vma=
);
> +}
> +
> +/**
> + * linear_anon_page_index() - Determine the absolute anonymous page offs=
et of
> + * @address within @vma.
> + * @vma: An anonymous or MAP_PRIVATE file-backed VMA in which @address r=
esides.
> + * @address: The address whose absolute page offset is required.
> + *
> + * This returns the anonymous page offset of @address, which is the page=
 offset
> + * the address possessed at the time the VMA was first faulted.
> + *
> + * For anonymous mappings, this returns the same value as linear_page_in=
dex().
> + *
> + * For MAP_PRIVATE file-backed mappings, this returns the anonymous page=
 offset
> + * of @address, which is the page offset the address possessed at the ti=
me the
> + * VMA was first faulted.
> + *
> + * It is not valid to call this function for shared file-backed mappings=
.
> + *
> + * Returns: The absolute anonymous page offset of @address within @vma.
> + */
> +static inline pgoff_t linear_anon_page_index(const struct vm_area_struct=
 *vma,
> +               const unsigned long address)
> +{
> +       const pgoff_t pgoff =3D __linear_anon_page_index(vma, address);
> +
> +       VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));

As discussed off the list, this assertion works even for read-only
anon mappings because, as you said, "there's no such thing as a pure
anon mapping that is !VMA_MAYWRITE_BIT, there is no way to achieve
that."
It took me some time to see that after reading your discussion with
David at [1] and [2], and I don't think it's very intuitive. Could you
please add a comment explaining that? Maybe add a comment at
vma_is_cow_mapping() definition since you are using the same assertion
in another patch of this series?

[1] https://lore.kernel.org/linux-mm/anBjpdMicqaGADr-@lucifer/
[2] https://lore.kernel.org/linux-mm/anLyhaI6kW-EWk13@lucifer/



> +       /* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous=
. */
> +       if (vma_is_anonymous(vma) && !vma->vm_file)
> +               VM_WARN_ON_ONCE(pgoff !=3D linear_page_index(vma, address=
));
>
> -       pgoff =3D linear_page_delta(vma, address);
> -       pgoff +=3D vma_start_pgoff(vma);
>         return pgoff;
>  }
>
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 40ad83936b28..4c58487b764e 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1428,7 +1428,7 @@ static inline void vma_iter_set(struct vma_iterator=
 *vmi, unsigned long addr)
>         mas_set(&vmi->mas, addr);
>  }
>
> -static inline bool vma_is_anonymous(struct vm_area_struct *vma)
> +static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
>  {
>         return !vma->vm_ops;
>  }
> @@ -1621,3 +1621,26 @@ static inline pgprot_t vma_get_page_prot(const str=
uct vm_area_struct *vma)
>  {
>         return vma_flags_to_page_prot(vma->flags);
>  }
> +
> +static inline pgoff_t __linear_anon_page_index(const struct vm_area_stru=
ct *vma,
> +                                              const unsigned long addres=
s)
> +{
> +       pgoff_t pgoff;
> +
> +       pgoff =3D linear_page_delta(vma, address);
> +       pgoff +=3D vma_start_anon_pgoff(vma);
> +       return pgoff;
> +}
> +
> +static inline pgoff_t linear_anon_page_index(const struct vm_area_struct=
 *vma,
> +               const unsigned long address)
> +{
> +       const pgoff_t pgoff =3D __linear_anon_page_index(vma, address);
> +
> +       VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
> +       /* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous=
. */
> +       if (vma_is_anonymous(vma) && !vma->vm_file)
> +               VM_WARN_ON_ONCE(pgoff !=3D linear_page_index(vma, address=
));
> +
> +       return pgoff;
> +}
>
> --
> 2.55.0
>

