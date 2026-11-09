Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8133606A326
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 08:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WgfpydSK
Received: by kanga.kvack.org (Postfix)
	id 94CDD6B00EF; Mon,  9 Nov 2026 03:35:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8886B05B0; Mon,  9 Nov 2026 03:35:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778146B05B1; Mon,  9 Nov 2026 03:35:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35C1F6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:35:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC9C01C3EBB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:35:31 +0000 (UTC)
X-FDA: 85414921662.29.A4B21D5
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id CB540160002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:35:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WgfpydSK;
	spf=pass (imf08.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794213329;
	b=Cq8KcRpgTNH3j9pG/onq+/829YTXi2QhuLRO9FWDy7qn3EYr9BWQC4ROoalsQAt/+FHPsx
	4Uri5WWyC3ucYS+w6hy5EFrxsXu0iIqB26A/nFrTU1pZtLMLvsize9PVpvFypzMvsNfEOD
	UovCI+8NHqZGGWCpZU9UiYfUKxfg9Fs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WgfpydSK;
	spf=pass (imf08.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794213329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6v/EUAzIuUZtunuZ0TzsEXeSSrt8us4QeYlPDnXiIyE=;
	b=pJ053lwYTCnuSJyjItHBg0KT16aBNW1C7zABRP5npq9LnyOtUjqbhrS2svCKlqBD2UDVwA
	FsUELS9evtyhjRVWEz+0cM6CWaxiZW50QrK+aRzO1tnUR6buyUzj2cQg/vwLd7S7Ic2U7G
	AC7JAJlGzrJFf9CCktChF8ZwG4jPre4=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4b7252a32c8so5469895e9.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 00:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794213328; x=1794818128; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6v/EUAzIuUZtunuZ0TzsEXeSSrt8us4QeYlPDnXiIyE=;
        b=WgfpydSK2Z5Ivzl9VVNF99WQNRVqurETjT25itn/a0x356CQi1C/Nao/tFueIv+6fo
         GXAdBq5XUU5GgkMNMwGapGkMR8r+U4ptEHvwqIrG6esdPiazt9CNpcsdyCLRQAOzzGAJ
         Wh4dL8oW4V+O3q1OO7zS4pFBOKOP+v1x8PtcygFPEfqGYHAi8RQ0gQjVqyacc6Iz/GVQ
         toLViR4Uqv7yC+/h4Sa8VH5yQ7arC7Fj0Lrm3UfPkVFF4F2gzHiRbOWcIEMve7ZGTzgw
         +3PRWi1PVOj52UgORrtdPpQIz67bCvTuo83EXXlFsHM8CN67tUPb3DbOR6rkj2bXMxPV
         LXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794213328; x=1794818128;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6v/EUAzIuUZtunuZ0TzsEXeSSrt8us4QeYlPDnXiIyE=;
        b=rKNAYTyZuuJUEfMis2Q0pQ1+bCyUrEE2pFgpKFCwEcxemqOKGzi80BxHcGu/2vFugb
         mfNWcUkXjAeYnPqxioXoLrA7YASc8iAIhuaU92zNacmpY6eWnbIYTaASayOCtPaYPdFr
         StaTfDtmtR7mjNHSGuq+dboNyVgUgXkA09O/DLCr4/t5iEPXl6KrFsqoFJ/TBvNshVHn
         uZQvdtawc4S5GFUWORJmKEaFQQn5hGgjONrMmKsdDS4mOdTur485+WHPC3IM6hu2lUIv
         7ADxj862jQXVzXCH+W6JR6WA4dAOQg9kP0PCD7TWQm4N83h4zJgUba86nP7R3CYj7uCl
         zA0A==
X-Gm-Message-State: APuU4Z+MjgZGQHECZ/71Gr3NbPsRg5D1Buc0s/zIvNORjMFXbmtRrhFy
	JxhHkkOwGnEic/O2CAKaBUvKJvGGqW3uCUB6haV08WKECSQ24tMkx5zS
X-Gm-Gg: AYBFou3k2Ep7bwpCgAxPXDfynlqXCI3pWxD7kyxRzGh+hLXpCFdNnLBiOnS/ntoDlR0
	FpkFXcUHgybN4UkDHlLlTkzOUidH8yuXeD8EygIKl7FFLiXpj/64KfnsQpLpykz/VTNwVyJQBWb
	FodQ1RrOri/Lxqmm6miIbdvaQJQERjJ4WVCj7baARDuzt5Hw7igr0nXGc0ha/ZM7yJgkq6GCy0L
	ARuD9t2PpmZDXqwT6LATp0CU8vSCZItTjjYvc+TLwHrb1L4tbWtJSTdUSGinZkd7JdWPHbj8VB0
	rQYgg2ykRpr+dRXf7wu3zGvm1oDKP1x5GrY2xIE1V0G853Hl7zoIBojJV08zUULGCFImG/WuDWT
	1E5/9xWjEhXbLij3FNEP+LjapmgwECb6bToTpSPHcfGwI5LUF8cd7ZPmRjNqxyJAv0J9AIh4am6
	CwYCksp8Ek2TY3J8f5SdH7tFAetYPQOVHXFP/Osc/BdMoW68kQZk/qU6I0o+kkWefB+12ROH4sU
	vRxzUdvRwwnVyiJNZCR2qRWJfRQyl1Ne2GoJWfk1EKuEvoV6p80bTOus+8NSWRWUyIGb47L1ZO/
	3957HwkZzyzc831ZmBRrabb/P9K+GYZ6voaFdXMuMVuB
X-Received: by 2002:a05:600c:37c3:b0:4a3:5991:718 with SMTP id 5b1f17b1804b1-4b963c87b5cmr58185485e9.16.1794213328165;
        Mon, 09 Nov 2026 00:35:28 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b90ee1ddc7sm170118285e9.4.2026.11.09.00.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 00:35:27 -0800 (PST)
Message-ID: <4bae9936-02ca-480f-b754-c7048702c667@gmail.com>
Date: Mon, 9 Nov 2026 09:35:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: limit pagecache folio refcount when mapping
 pages
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-arch@vger.kernel.org, iommu@lists.linux.dev,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
 <20261107-refcount_overflow_stable-v2-1-c38f6809b106@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261107-refcount_overflow_stable-v2-1-c38f6809b106@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CB540160002
X-Stat-Signature: tec7spxwqwe4eigojpwej39bod8ysx9w
X-Rspam-User: 
X-HE-Tag: 1794213329-769733
X-HE-Meta: U2FsdGVkX1/GRfMe0DBpCjhCpiiE55ekW7n/UUn9bzwTZPhYciwvautBNqF/ggIqvCkvv7DstNDHS3mK8Wx9k3GxUN1fg5pR6w5vUrc1W07xBPEOUi4K+aeXWXWo1qV1dXxiD4gbP4cq93DkWAurO4eZiBQsokgoMyuAyx9oeYPMWuzL2G1Agc1qZV5gB9VuM1+WIIite7njVw4+9T7ZbfBAQf97nXgZQgVLfd6hohYV9SA+xF/I3Kmul2S7Lg+FRiuiI0p63VA4WGFEnq5AvAbshegmIGZsgp6tUxxMm5va4RKmzXB9yf84f6kFxThkUdasXQQun+Wz0JnG0l1K+REyPU65ONvEoLb90uzTGbP4RBfzm5uxIEFBIfdbHZc9q6Wp+2nzyx29N479tgbQNoLsyfm47c7BUM9FGS1Is2jGvLnweNfur2ZQvixa26ZtMPugoDLZ1At353C0YQfhQuMn8lWX+PWXYqH1zrnddDzLWdAmMawRdFNKVMNN3ajzx9KWve85rhQ7t4Wn3uk+15J6E8BkFBT6dunHYvqWxf7F8k8sCkDHRKEpdPtMdzsoJoWiI31yOTGAFX3Bz7CH9CJOxnBKZQiDHJoQF1muCquiVImkG5547oyxu5WyawzCsm1rYsZf2ESGitbzIETiEiCB7IIOeOi4jkFucyKjwDs7e8sp0VCh6pBzqQ3+ml3jcFiv1trs2A2QdY9LlzvjG7GLgpwsbS5SzAKSY8gupWykUt0Ojki+POFThlyfwrfn5mFvsl73FZRm+K1FjWP0Mpx2rOFPcfMiNAVNVwzbZsOMUabEXoWE9pOUoZ8YWH/6vH1qFCQHCZjY9V7CAksuMFdLCW6ZhCHrkQgh0q/NV7Zlk6lVaE42aescWGjZzK/kncXuOeo3dJ5BdqynI/WOYSV1Evtng9UrM8jCQmOIUsVr4umCtRSjNtlJclINFZa9QaAR/WU7xkUFjmEnEyl
 BVrvBhob
 FrMeEruLpJyMA+Vj8JeD6OlUsZNLtxvO/0NECEVXIUZk4Z/BaLNNw9VXphTBGnquOXEroPOqxgGYq1k65ec4Moln/40XEXMr79px4tdxCnlsc0zXMA5iBU9aGr6EilVLHTgl066oVdUJfAdYSyzp5hdjf6gHqsGHWxcaBUoOHcGYs9Rev8p7wRvBiRUsFUSaBqoldra0RCr1SztIvithcwgfdP4hhyotTgUISZj804dDlnYSawRFexCB+tjA1wrQvDEG8QYycCB6yMDcrvpd0pUBOEvY5qJswLcu/a2uC0yEr5+mrZfBg5kXQJa24s8a2fjW44/6s/QxnjloBw7Sc1tXAyajbS2uNVw9hp+Kn5KJhgsyupq9BK8RNvuTHpqHj85x/a7YexSEp5flxyOwOCGnRW1GhNub0+f7vCySFv7shYjYLZwv3Ks8RDt/TTR/qriwgig+eXrLGUabHWYDlyCcLWLAZYA3/CMWCuJWhEn0/9xV/xtFXByRhVrpJHPf81Di/AZpkf2hX+ZSUajAGIusbDOuCc2RGxO+TzPfrrCA7fZQQAQGJ4m8vfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 11:23 PM, David Hildenbrand (Arm) wrote:
> With large file folios, overflowing the folio mapcount and refcount
> became possible. For anon folios it is currently not really an issue:
> each large anon folio can only be mapped once into a process; on 4k
> kernels it would be more processes than usually allowed on a system, and
> on 16k or 64k kernels the processes alone would consume hundreds of GiB.
> Something to be sorted out at some point, but it's not as urgent.
> 
> Being able to overflow the refcount is not really big news, but it's about
> time that we do something about it because some modern technology might
> find ways to abuse it :)
> 
> One of the enablers for that was commit ddc58f27f9ee ("mm: drop tail page
> refcounting"), however, file thp support was added later.
> 
> File folios can be mapped multiple times into the same process, allowing
> for processes to hold many references to the same folio.
> 
> As a short-term solution, let's introduce two folio refcount limits:
> one for ordinary consumers and one for admins. Leave some headroom
> before the refcount goes negative, which we really don't want (having
> the mapcount go negative is also not expected).
> 
> Start reporting SIGBUS if we run into limits. When restoring mappings
> from migration entries, instead zap the pte/pmd entry. We allow for
> slightly exceeding the limit to keep things simpler.
> 
> During fork(), prefer not copying page table entries over failing fork.
> Export __folio_ref_count_over_limit() right away as that will be needed
> from fuse code next. Use has_capability_noaudit(current, CAP_SYS_RESOURCE),
> so filesystem credential overrides do not affect access to the admin
> reserve, and to not generate auditing messages simply because we access
> optional reserves.
> 
> This is far from ideal, but better than all easy alternatives we can
> backport comfortably. For now it fixes the big problem: letting
> the refcount (+mapcount) go negative and cause trouble.
> 
> This is only a temporary fix, we'll follow up with something better.
> 
> Check order 0 folios as well for consistency: each
> folio_add_file_rmap*() and folio_dup_file_rmap*() needs a prior check.
> 
> Also, just document -EHWPOISON for copy_present_ptes() while at it.
> 
> Note: When zapping file migration entries, uffd-wp is preserved using PTE
> markers, but uffd-rwp protection is lost because there is no corresponding
> marker. try_to_unmap() already has the same problem when unmapping file
> folios, so we'll happily ignore it.
> 
> Note2: For now we don't let migration or PTE table collapse exceed any
> limits. Admins can always refault, and if we are already operating in
> admin reserves, something is already off.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM.

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

