Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42E06C5AD2C
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 00:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4F56B00E5; Sat,  8 Aug 2026 20:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78BE56B00E7; Sat,  8 Aug 2026 20:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654716B00E8; Sat,  8 Aug 2026 20:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 166F46B00E5
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 20:51:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9FF33160472
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 00:51:24 +0000 (UTC)
X-FDA: 85079902488.21.0469191
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id A412A40005
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 00:51:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tqCKcCfW;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786236682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5t26LPlL2x6rRQWr8/8g+glnpY16lnjlFmjLTvMppKc=;
	b=RemBfcuJy8TBE2UqE0Y4QXNkt8Ps3w9WEhFVZzfrjHBJwcZtt35woQ0zGmDNzAncnZbFrN
	Gezesf+sfQ/6o3TrqR648WSK6ptCs9YyxuEABGKk3fNXTp7bqTiwNjheMIBM6jl1bYdjBE
	QS64lkzZWQLBiEWCSuWLGnjUkaZJX5M=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786236682;
	b=Z5HwW6jqmHo8FnrVfwN2NyQ1G2xsBu7BNPXXMfnNPCAz94iyZAcV0ru8kftyBDwWgBADkg
	BjFqjfF3mVow8XN/avXQSGWZb1TG0HE0DB3GMZNl6viOiJytG4HXlQ26UdROMVj34utnIG
	AR38NyEXtTaom9Ca32wARBz/T++2dic=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tqCKcCfW;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c10e86e52so135011cf.1
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 17:51:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786236682; cv=none;
        d=google.com; s=arc-20260327;
        b=Oj0Fvn+jEeu2CFayuFI/kh1nsuCftdO51aJiM3YVtjR27lSrfpXFMzIrU4DWIjiUVv
         pIP8ePwLgJ+r+UqGRQMCakr7UeRzZRaRibvMJaoKKCyapj4wjRiC0bsZ9iDeb5QOolVm
         iGwK2D18g7g1eDkTKnXKpUH6aQJg5xaoZmgtM72Wq0xSeM6/x6K3vQSt29p8mkin1Vvu
         1i+9qUn9OzC360p+fBvfPc8H9zg99B12PEa6XrfCxqy1Uy7DgaIf4/3fO2fz2V1GDVLS
         WgZXjNAmcSpXX+yx2YELAe6/jrtgAVMIyY1bW5GPVsBv5B0lFiBJfTkDk9ycRBda4tds
         6dtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5t26LPlL2x6rRQWr8/8g+glnpY16lnjlFmjLTvMppKc=;
        fh=4+39XqVEBDxxB3ZF0VIsZVPLFT5CaxP2DxcQynLLWJw=;
        b=RiAyAtbdpGUQ7wmZhp63iHlLgM9Cwb3AJhaI7fe0hLm/PtJr6/C81GuR7kVU8cAbxa
         tx6qmP1Hr/iQcpDqzE/eoW39pi6AB1yy5X1CDGXNwuI8g1ctF9kh6eu/Svho6918zIOc
         muDIfvr7BqA68IvwdkPOmep8TGsNVYz8ekWjGv77arnNsJMWvKJfSiFpmCMfrI3V3hZP
         9cw39p2/AXQW/GhbUA15oeLDSw2hs2UpInJUk8+WP+A27BJKKLU9/olcjjG832q638Bx
         Ms6KTG9swvwPQvDn4JQCso5MJ5DFz+kMeepNdptVDWu40vi1Id8ak4noveOm3SC2lNn8
         AXmw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786236682; x=1786841482; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5t26LPlL2x6rRQWr8/8g+glnpY16lnjlFmjLTvMppKc=;
        b=tqCKcCfWhSJ9Evmz4f2Jnc17d4l/UJZQQHTBWFh0UIxHW6r4S3xzXa2mPYeeseGpRj
         sM5+Kg6nL2G1cDsf0FrB28xOhIhrYaXTmYtnprPXIHtqSxBwtFE48UJBJL5ve+wVsMtd
         fK+gtFpjnh2Rd2Y1qZwkFBN606okHCCy+LSYEfE6J6JT2jPOwen3o5tqWWJlOjDAlSWI
         Ikm/rdIn+wL/hL6JjMKSKUxLmd+GzZTZsjznZMD5Nae1ABzw8IVWBx8BTlEf8pbLKBJ+
         hfLCj6EKkLuzXRScacBxGnv6UwRhXhoQ2oZ5CogZWtjYsTztKa7ghd8Mb7tdz77NQWSO
         iu+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786236682; x=1786841482;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5t26LPlL2x6rRQWr8/8g+glnpY16lnjlFmjLTvMppKc=;
        b=OmULtcTQPBkuJ1kDVET9taoyYndUALyico0zL0FL6XCY2phFVaG0boZPP8sRW0JvhQ
         kgF4fjFcsQnZXNLs/YgWhRmUpG4le30ut+574ccD0uuXGV4jzWanLqQko7qi4bkuZ40C
         U/n0+OSMVGDt9VAsbYrD4Y/OAUW6tZ54ypGU9DmKFRB4/xHEXinu50xTknLTqtNeD1K5
         0rGQGz2D4lc20fqYE1FRR9BRBjUKXr1ZKFPJyBq+Y8COvxe3ijJg9jhgqlSFNVANAS3z
         xnNkABdb0QNheAe+jSmWLecvqYbbKeHiGELxPXeKKrT4uzPhGl9i80x8Ouik/LR+mlpv
         x0HA==
X-Forwarded-Encrypted: i=1; AHgh+RqsBzZoqDKhr6XDdPs+9rYPKoRzBlIQ7KumvqT7NnNNmniJI7j/fa7crbP148ZDBjQalxzqF9NrdQ==@kvack.org
X-Gm-Message-State: AOJu0YyZh54d72SsnDm38wEUJs+OGchJ5kxT1n9L7CdfUhaJhfT7jc8O
	tQB847wQC6nP0BKeA9slHE2P0fz9RtCVw/Y5djZfIVNPLpGlCH8eHJ5KM8PKrxVhAOZoJGvV0WE
	H1xEKsmNM5tDfIenshCK268yIw8kDuAUlLv+9p+5R
X-Gm-Gg: AR+sD10iIalA92FZg2vDq+0c32jp9Kmuh4Yl+M8HaJoxy2fAiiKhTpw2Do7cXW7SnHP
	7974LlFxiUK+/Z8FUib1PaVwXcJNT7wPdSWd7CFbsOWX37Y1HFUV+VQqe/0WswyQ68/W1GfoNvk
	oYd+vRD2jNIg0cbZiHFuKA0k8Zkw1Z9jlcovwlXOMxwwMJKwGVygRpzAQFn7gM36rzaNTdSJC4Q
	wbzjX8FINio1iT/VBT0LMqYVti0d7AAI9bgrmiO5mPRKZQLgeR1ViNaJRVAXfeRrYR64J9R2djW
	cGipdn9GKgD93kPE2Mu1d7Q5A1jj1h1Beiyc2i93Fp8=
X-Received: by 2002:a05:622a:2c2:b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-52d28104052mr10844831cf.5.1786236681095; Sat, 08 Aug 2026
 17:51:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org> <20260806-b4-scalable-cow-virt-pgoff-v4-1-ab318a350404@kernel.org>
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-1-ab318a350404@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 8 Aug 2026 17:51:10 -0700
X-Gm-Features: AUfX_mwrAfErRpWaGdsaXjFbVsuLxmBdhaCS8dBRSF7bNpazo-ZM1X1L3isxLV8
Message-ID: <CAJuCfpFAA1H2pOi6EOarNtrdzLQDJyhm6QOGsfZ4SFTuM5eiLQ@mail.gmail.com>
Subject: Re: [PATCH v4 01/20] mm/vma: introduce VMA anon page offset field and
 add helpers
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A412A40005
X-Rspam-User: 
X-Stat-Signature: 7ry3io7c9e6sfksofnn45y9ufq5ozuc3
X-HE-Tag: 1786236682-788122
X-HE-Meta: U2FsdGVkX199XtdZ+sOX4PYg2iUKDHtIUwOw/kIyy5x3516ONYyYYrcL2P9fZJP9UGQI3JKKSpQIUqzR+HuwxsnaJkDN+xARu4i7eofXKkmc/DTKUWKG9QqCJCycXqUUDZ8nVD0Tv5portamGJElp72xBfoGgIGEQYZYsMpVjBtafV0g6J9VSonIkRbKM23X8GoXWenHP5O9XcICu/GifLEMr0KrHninYXfYgxMBzqptnRjme+lN4J8W2Bfe7bGaFP9nPZvB4JYaOkAqqoK2C0n+euNPoOjh2zk65WgDBXE77T+egCf/hOwO9Wf+nYBdSV7R3mQrHeHvGcU07n1h07vTxV9HPWGrnX7QxCLH5LSlsiCwXhdDyTRcSlX0vsqzhYlqV5v7/nKyErZd73GId2+xaI47bFrDb09/dzDq8Mmaf9jGQGMtvO+oY1yCn0FyE5UNatHA78m9T61QqXtk/Q5kGKNQqClRuXi6pLd9nZZkoPDvTMu/ff2zGN6G0/QzASlCTchI47dIjUx52CjCtIqP6dDWLQeopOGnwKer1U/Y83x+mJ+Y2VZZLyZTO7v505Bf+TDi9jQuKl0pvClsYFnTOEh3TP9q26D6hHiThTplekC9v5Fl/yxCQDGTSgHHMIfpRtHkpAb1Tx4vm07Sk7v/Cp6ExitvFG+mQOIDs5Kr7HnrkjnWV8CfuLkzROEFNI6JZVVICbCBAMgytE0i6BDMSjU6J1xP480KsCbAkwkv39QbKeZF7iyG0I31YhvOkTFy9DlEoRJkbSaLeyCbwxrZpRBEDZApKlGCrXrI2a80x9CCC5uMYIgROeCApxuSuEVYgROtQ57Ig901oIUprKaHIpFSlQbj1k32J56gYeAY0gkv+ZhkTshDU39la5boPhJizKlOdYqqFvpvnuP4dO39rfHOAwkYkEqByWKgMijMnjgWDkeap7Cphcf2NgaVKE9taJPu+uhZUa+5iNO
 ID78UlPg
 3rHjVrvCaRmgq0hd4SuTsDD1HT7qdrr1PEthgOrLAc3jVvMEMfps/F/8m7HPoCMwRr3SkytkVbPoN39PmUoiG81wVLNmjSfc7fApjZydI+7QdjWFkZ3YSvzsuGZ0W/ghRNK26frVRNfRdfcRE2rxmbC/+oiNN2icEJmmBqUc4HiEZHXwxHN8qmeXPQmSfQKO9gTRy+bH8A6syucrPeVD+BSoInbWTlWYK/i7vyedbKS+nLtI1JphAxIZ9rDa5W/9kzUA8cxDdT7jV5HwQ9RCUw5/uj5dwvf4NggAGf2KrM76B90lZBMfZv0fPKqgWmyACz0h99W8pKayPI6vdIta17U5QvCw2fgOsGdMCBjyI7Fx7hp2pGswoe5MsAbEvpUif++zlhe1SoALDfL5a2UYlaWHbn4sGm5HJw0+yRuESZJCZzwLPlHIf0A4YUzRmPkaE8mzuWiROBOhsO3A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 1:22=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Establish fields in vm_area_struct to store the anonymous page offset of
> VMAs.
>
> Initially, the anonymous page offset of a VMA is vma->vm_start >>
> PAGE_SHIFT.
>
> When a VMA is remapped to new_address its anonymous page offset is either
> updated to new_address >> PAGE_SHIFT if unfaulted or, if faulted, remains
> equal to the anonymous page offset it had when first faulted.
>
> Currently, anonymous folios belonging to CoW'd MAP_PRIVATE-mapped
> file-backed VMAs are tracked by their file offsets. By adding anonymous
> offset as a property of VMAs, we can now track them by their anonymous pa=
ge
> offset instead.
>
> By tracking this, we provide the means by which to eliminate this
> inconsistency, and more importantly lay the foundations for future work f=
or
> the scalable CoW anonymous rmap rework.
>
> This patch simply adds the fields and some simple helpers. Subsequent
> patches will update mm code to make use of these fields correctly.
>
> The fields chosen are packed in the VMA such that, for 64-bit kernel
> builds, no additional space is taken up.
>
> The first field is present on cacheline 0 containing key VMA fields, and
> the second on cacheline 3, which contains file-backed reverse mapping
> fields.
>
> Given the relative time spent accessing reverse mapping fields as well as
> updating them, there shouldn't be any performance impact here from false
> sharing.
>
> Update the VMA userland tests to account for this change.
>
> No callsites are updated yet, so no functional change intended.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              | 59 +++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/mm_types.h        | 12 +++++++++
>  mm/vma.h                        | 14 ++++++++++
>  mm/vma_init.c                   |  1 +
>  tools/testing/vma/include/dup.h | 26 ++++++++++++++++++
>  5 files changed, 112 insertions(+)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 87feaa5a2b78..df78847f5f07 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4393,6 +4393,65 @@ static inline pgoff_t vma_last_pgoff(const struct =
vm_area_struct *vma)
>         return vma_end_pgoff(vma) - 1;
>  }
>
> +/**
> + * vma_start_anon_pgoff() - Get the anonymous page offset of the start o=
f @vma
> + * @vma: The VMA whose anonymous page offset is required.
> + *
> + * If unfaulted, then this is vma->vm_start >> PAGE_SHIFT, if faulted th=
en the
> + * anonymous page offset at the time of first fault.
> + *
> + * If the VMA is anonymous, this returns the same value as vma_start_pgo=
ff().
> + *
> + * This value is used for tracking MAP_PRIVATE file-backed mappings by t=
heir
> + * anonymous page offset.

I assume this function should not be used with shared file-backed
mappings, right? If so, maybe add a comment like the one you have for
linear_anon_page_index(): "It is not valid to call this function for
shared file-backed mappings."?



> + *
> + * Returns: The anonymous page offset of the start of @vma.
> + */
> +static inline pgoff_t vma_start_anon_pgoff(const struct vm_area_struct *=
vma)
> +{
> +       pgoff_t pgoff =3D 0;
> +
> +#ifdef CONFIG_64BIT
> +       pgoff +=3D vma->__vm_anon_pgoff_hi;
> +       pgoff <<=3D 32;
> +#endif
> +       pgoff +=3D vma->__vm_anon_pgoff_lo;
> +       return pgoff;
> +}
> +
> +/**
> + * vma_end_anon_pgoff() - Get the anonymous page offset of the exclusive=
 end of
> + * @vma.
> + * @vma: The VMA whose end anonymous page offset is required.
> + *
> + * This returns the anonymous exclusive end page offset of @vma, which i=
s useful
> + * for expressing page offset ranges.
> + *
> + * See the description of vma_start_anon_pgoff() for a description of VM=
A
> + * anonymous page offsets.
> + *
> + * Returns: The exclusive end anonymous page offset of @vma.
> + */
> +static inline pgoff_t vma_end_anon_pgoff(const struct vm_area_struct *vm=
a)
> +{
> +       return vma_start_anon_pgoff(vma) + vma_pages(vma);
> +}
> +
> +/**
> + * vma_last_anon_pgoff() - Get the anonymous page offset of the last pag=
e in
> + * @vma.
> + * @vma: The VMA whose last anonymous page offset is required.
> + *
> + * See the description of vma_start_anon_pgoff() for a description of VM=
A
> + * anonymous page offsets.
> + *
> + * Returns: The last anonymous page offset of @vma.
> + */
> +static inline pgoff_t vma_last_anon_pgoff(const struct vm_area_struct *v=
ma)
> +{
> +       return vma_end_anon_pgoff(vma) - 1;
> +}
> +
>  static inline unsigned long vma_desc_size(const struct vm_area_desc *des=
c)
>  {
>         return desc->end - desc->start;
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 939b5ea8c9e0..ebf0d912be7d 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -967,6 +967,11 @@ struct vm_area_struct {
>          */
>         unsigned int vm_lock_seq;
>  #endif
> +       /*
> +        * Low 32-bits of anonymous page offset.
> +        * See vma_start_anon_pgoff() comment for details.
> +        */
> +       unsigned int __vm_anon_pgoff_lo;
>         /*
>          * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_v=
ma
>          * list, after a COW of one of the file pages.  A MAP_SHARED vma
> @@ -1041,6 +1046,13 @@ struct vm_area_struct {
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>         struct lockdep_map vmlock_dep_map;
>  #endif
> +#endif
> +#ifdef CONFIG_64BIT
> +       /*
> +        * High 32-bits of anonymous page offset.
> +        * See vma_start_anon_pgoff() comment for details.
> +        */
> +       unsigned int __vm_anon_pgoff_hi;
>  #endif
>         /*
>          * For areas with an address space and backing store,
> diff --git a/mm/vma.h b/mm/vma.h
> index 0bc7d521e976..54ed7c744e3b 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -283,6 +283,20 @@ static inline void vma_set_pgoff(struct vm_area_stru=
ct *vma, pgoff_t pgoff)
>         vma->vm_pgoff =3D pgoff;
>  }
>
> +static inline void __vma_set_anon_pgoff(struct vm_area_struct *vma, pgof=
f_t pgoff)
> +{
> +#ifdef CONFIG_64BIT
> +       vma->__vm_anon_pgoff_hi =3D pgoff >> 32;
> +#endif
> +       vma->__vm_anon_pgoff_lo =3D pgoff & GENMASK(31, 0);
> +}
> +
> +static inline void vma_set_anon_pgoff(struct vm_area_struct *vma, pgoff_=
t pgoff)
> +{
> +       vma_assert_can_modify(vma);
> +       __vma_set_anon_pgoff(vma, pgoff);
> +}
> +
>  static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t del=
ta)
>  {
>         vma_assert_can_modify(vma);
> diff --git a/mm/vma_init.c b/mm/vma_init.c
> index 715feee283f0..baa7e82f47e3 100644
> --- a/mm/vma_init.c
> +++ b/mm/vma_init.c
> @@ -51,6 +51,7 @@ static void vm_area_init_from(const struct vm_area_stru=
ct *src,
>         dest->vm_end =3D src->vm_end;
>         dest->anon_vma =3D src->anon_vma;
>         dest->vm_pgoff =3D vma_start_pgoff(src);
> +       __vma_set_anon_pgoff(dest, vma_start_anon_pgoff(src));
>         dest->vm_file =3D src->vm_file;
>         dest->vm_private_data =3D src->vm_private_data;
>         vm_flags_init(dest, src->vm_flags);
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index c52b23773cd2..26d9210b1e8b 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -577,6 +577,7 @@ struct vm_area_struct {
>          */
>         unsigned int vm_lock_seq;
>  #endif
> +       unsigned int __vm_anon_pgoff_lo;
>
>         /*
>          * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_v=
ma
> @@ -612,6 +613,9 @@ struct vm_area_struct {
>  #ifdef CONFIG_PER_VMA_LOCK
>         /* Unstable RCU readers are allowed to read this. */
>         refcount_t vm_refcnt;
> +#endif
> +#ifdef CONFIG_64BIT
> +       unsigned int __vm_anon_pgoff_hi;
>  #endif
>         /*
>          * For areas with an address space and backing store,
> @@ -1320,6 +1324,28 @@ static inline pgoff_t vma_end_pgoff(const struct v=
m_area_struct *vma)
>         return vma_start_pgoff(vma) + vma_pages(vma);
>  }
>
> +static inline pgoff_t vma_start_anon_pgoff(const struct vm_area_struct *=
vma)
> +{
> +       pgoff_t pgoff =3D 0;
> +
> +#ifdef CONFIG_64BIT
> +       pgoff +=3D vma->__vm_anon_pgoff_hi;
> +       pgoff <<=3D 32;
> +#endif
> +       pgoff +=3D vma->__vm_anon_pgoff_lo;
> +       return pgoff;
> +}
> +
> +static inline pgoff_t vma_end_anon_pgoff(const struct vm_area_struct *vm=
a)
> +{
> +       return vma_start_anon_pgoff(vma) + vma_pages(vma);
> +}
> +
> +static inline pgoff_t vma_last_anon_pgoff(const struct vm_area_struct *v=
ma)
> +{
> +       return vma_end_anon_pgoff(vma) - 1;
> +}
> +
>  static inline int vfs_mmap_prepare(struct file *file, struct vm_area_des=
c *desc)
>  {
>         return file->f_op->mmap_prepare(desc);
>
> --
> 2.55.0
>

