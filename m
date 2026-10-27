Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D030A606A329
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 21:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EGI8e3OM
Received: by kanga.kvack.org (Postfix)
	id CBCA16B08FB; Tue, 27 Oct 2026 17:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C94126B08FD; Tue, 27 Oct 2026 17:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA99F6B08FE; Tue, 27 Oct 2026 17:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2FB6B08FB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:32:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F1D1140B10
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:32:08 +0000 (UTC)
X-FDA: 85369704336.09.9AD4A83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A5995A0007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:32:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EGI8e3OM;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793136726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S908WbS6sl8a+ccaT1hu8oFrTY/8mXQRTyc6SNjkEfE=;
	b=KmxF5pza7riN6AGfaG3w473QM/pZuncMlBx3SD+Fv42A8u50qoamC8x5lWKRiLeYhhV8tC
	5HY8wnkalzY+yR1Zhmui+FFcG+Mxwd4n+BH5fEckwYk6v/+yRykig1ViidJKxLpFLSOC2x
	GxsM7YXUEkCggL6fDaiebXf57+SGf7c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793136726;
	b=u4f7c6JBu0C1Gok4XqDLV1NIQNCALSloz2miT5UYkulqGW9P4zNaelLkToXZeL+3Qh2hjJ
	rxiIwou5dtaYq6wUYozjAYCnG7dNro5458kzeHQkc5yuRltTLcfHznwAH7Y3utgDmt4LfN
	H3B1xeSHMswDTuz1Ty6ZXp5vDDaF1Zc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EGI8e3OM;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D125043E7D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41841F031E9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793136725;
	bh=S908WbS6sl8a+ccaT1hu8oFrTY/8mXQRTyc6SNjkEfE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EGI8e3OMSj8oudPsWvxnIieFF6gTtab2PYp1pWyo2hMoHwm9k9vSCCBUrRG6xC8MH
	 0KGkcd0cCIQIKtaEwW9h9u/ChT04cEjChqjY1CDO6ZnF5ZAGMZXsI/3+Hd+Q5LXBkS
	 tstKAH5wHNK3/OGFItDDgQcCGMMsJehCZKVi5x688GOJAnc5FMB9Yl2vm4YMrbJS8z
	 GH6396g8Z26BXcomQK7YLP1JeyvPWoPTLaXD4wMHyikZsuZfVkFw4ACyB8DThiSEpJ
	 8mEUpcgXD7tk/pPGlMJZHaXf0LVXktt2gvyJsjPwxg15Yv9qrjFy1MJTjCjDoHGfaX
	 kdeNE1WPuUlqw==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9440304604aso36884585a.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:32:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzJHZNxSaarf9B4DunG/gF14MbivYUkBCuvtxhKf0JyryipucWAmyIfewReNt93SQ1wrKg16Y3lBg==@kvack.org
X-Gm-Message-State: AFq9FYIl67l52fr+3Z1v1o4fzIHdk7q3IvpWK+X9sQ+bRTbmLPq0XWoj
	0njyzJhY2jqTQTmsWmSFGILigylKCK0IGV5z8R0kJE1Uh22+E5bvnEesWdlErPILaBqGhQIB9DR
	+uiNzY7Ih5zB49KjYPH//0KOm+ie15uM=
X-Received: by 2002:a05:620a:6013:b0:93e:7156:f814 with SMTP id
 af79cd13be357-94408a65be4mr32182585a.11.1793136724949; Tue, 27 Oct 2026
 14:32:04 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org> <20261027-fixes_core-v1-22-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-22-6f74bec9a5bb@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 28 Oct 2026 05:31:53 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wPwBz8OB5opbuKsVh-ceKqyqi4d1aB8Emx4ChqDe4qzQ@mail.gmail.com>
X-Gm-Features: AclHuK_Qzkd3NBrrAvAlcTVmJZ8ovWd4rfeoh503KU3yWFCYVC_zuTNZmwxW4A4
Message-ID: <CAGsJ_4wPwBz8OB5opbuKsVh-ceKqyqi4d1aB8Emx4ChqDe4qzQ@mail.gmail.com>
Subject: Re: [PATCH 22/46] mm/gup: check for overflow when converting nr_pages
 to bytes in GUP-fast
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-cxl@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A5995A0007
X-Stat-Signature: ruyt51g39mdtoctr33bmdkg7s5fm7ab8
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793136726-691428
X-HE-Meta: U2FsdGVkX18o9QGMyiyHKlzGgTnv+b6SvekXMLX5VytAp3lJifVrsVKSFNRZeuMZCqVcLUftIQ0iEX+2q9uRlc/xq08sMH8tkqEjuvoiu6wvibfk5xho3783aMlclJGhKxuRxLZj3ONfOD+Qzgxt6IQJKxVdyxXj4XgDqdu/mGKipeDxHkmW7OIJKCEJCudpPcvduX5KqNbvhjSiCLapv3GsiYxaZm2vlPdwxZ3tTm6RtPa26F3zSswjdqA+AaAVZGZl2mhplMgoOhoN91jbyN53nS42xjAGe5TjsNf6cTjZOasNfhg+i5IL7eD40ZpOY7OO5/3NxaJtlsbkKz10SzGcZEwpwC0Vc5eSq27cpu8Q7pV/yUGrE85lgxkq1UTXW17vbHl796mXuZOy6+H9TAmX8kmnPOwB+u2coM5HHcOOIvldsCiKOG/N0P1wPzAr6joHn7O501bynkt3pjdF4TO+VTENdmxQpe2wcjZh+ymMvUiihpHKGX+dfoEjXMs1i7fNv30irQOXdYmoAXQtC0pkG4+TS9QjV/yjZAzO1Is+1n0MTFbTnaXj4h2+Qdwc1SSjpUlYKN7jXXw7ftPWxGE855JFzpWQ8JHdbK6carZC3GkKrPlSx0ItphA1gmIL3jG8pRyYu95mAsyhIt01nNkPnm8Q8ZyMWZ9PszdVB8yW6oNs4iIxA1ARgx3xc/Mv/Lr2no+Rlk85sLtvtHq61AmK+d5kFhuKymZEOPq3xl6CJI8W29wYhXNhvFMCM+fwkg7UamGnQNvpFq0PhWXnhMLuFNWB3FbzLUb8h4HMTgNuY2VPD1AOQ3APfFxvmrqNL9WxscxFh8EPXTmY6zCpNLNSkDqMfSUK1ktQnhlJK11K812LfAz4C+WZrKFfJBw79Ki1utXLT+hX2G5fwUHcZcvgz4oran/bETiOOJWXj/05Nv/PV3hUSmpPpKzzMMuHskSG712SpG+o8Kblb6D
 zw9TIJD7
 5Vcjh6vRbr+np6hecvFPbTXiophgNhoUdYXMlO209HD3l0lAw4+XiSmDHRHRWbx6gWDVj+SF8rKJGG4JnTtR6a3oSrONHt5OQuO/Jlkdh3b8qnJ2ryFHxQDKbmHmFBJacoAdqFcuROg6tMkBBTQQUqQDgLCNr2YKXewuYj0pLdsPNPHZfkD/YneOBmZ+IA4a34o/o+lUE3FSmER1JnM60gJpj3F/lX4JxeWua29cLYz6J3pmgZ+5UIO+9Yu7BiT5mEsQCMBIbJpGsEGwhs7kgUnDmZJSlNT8J8uphqxBmi9RfPSRB0IcJRa8uqLLFmww3kZ+3yUyCX0BO1+JDlcLjiwjMipi8hjJwXEAgJcKKF4MxyoneRCEe2dbYIK8ie2z6VoPrvh8P5XAo0bbrr6uKWuEvUmMAv59bXnOuLyMEtF3GXhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 7:24=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> The overflow check in gup_fast_fallback() only covers the addition to
> start. The preceding nr_pages << PAGE_SHIFT can already have truncated
> the length on 32bit.
>
> Users such as RapidIO's rio_dma_transfer() can derive such page counts
> from a 64-bit userspace length.
>
> Let's just check_shl_overflow() to reject any such overflow with
> -EOVERFLOW early.
>
> Fixes: c28b1fc70390 ("mm/gup: reorganize internal_get_user_pages_fast()")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

