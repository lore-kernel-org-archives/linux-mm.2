Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76449C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 20:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40D316B0088; Wed, 19 Aug 2026 16:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4446B008C; Wed, 19 Aug 2026 16:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4536B0092; Wed, 19 Aug 2026 16:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 019FF6B0088
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:33:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7210D805EA
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 20:33:59 +0000 (UTC)
X-FDA: 85119170598.19.985C72F
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id B0AA24000B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 20:33:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EIvGsBJY;
	spf=pass (imf01.hostedemail.com: domain of hughd@google.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787171637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJDZ3zG6BST+HSWSWwE8GsdZoVMnM7ou/ROzox6VqsE=;
	b=yoFmlH8GKa/Ll7VyzljHoXg/XXjTL/sdd6heWIWaDnDnMsXJTKeJNcAlv7L9BhJ5py0RAx
	iaSAbYgQFNOv0+ZtAXDktO9nwei36szRBDX488KmtElGVN/C6XA2nZyrH194U3nfD575m1
	vUIspi57uyb4rSMmwECBMfxwzNeNWoY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EIvGsBJY;
	spf=pass (imf01.hostedemail.com: domain of hughd@google.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787171637;
	b=YFix9DUFGj2GjYxJRR77Bix33k2qyAcIWBw7yvf4GaLSLKm+J+8NHFMWCkWWumrGfB8ovP
	OC2PSXQaSsK+APJzl0agMjrKZBhBk1AqMU2+0RuqPIDq07TICl9M/vEvZv9Bn0EduG3CRI
	dpbXt4Uj4as6OA7TCrU5P2xJZghHc3E=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-66c70f05859so2611415d50.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 13:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787171637; x=1787776437; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JJDZ3zG6BST+HSWSWwE8GsdZoVMnM7ou/ROzox6VqsE=;
        b=EIvGsBJYFbOrLpRKAHyJgZRK+rDHYi0ztXfUs5en/ILsCyW+z6g4M+L5TTK60/FIbz
         jy7p0BRA7alnolMGbXPm6uWHu7H3mQqR6ygE8jaH2Ec2e1AC3IhU5cMZaoj0mcSt9yeW
         fJ9tmSFRzk87i70d0JA+81JZyrU8Xe2Z4yNFZMLMoCkSpXYG6cKMuaHLLDqVt2iUyrrD
         lxiLdj5TmBMdfU/2nDnL375/GtnOCFyKuwLMc38Hdx4a/7TqYi8UWS+YFZGjCUGkVuRK
         b4jLtIA16NfY/TTX3rnpaLlVfWiR1llljGxX6frzM30nmzg5nxgz6y6oL2wnQcxCUFd0
         jpww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787171637; x=1787776437;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JJDZ3zG6BST+HSWSWwE8GsdZoVMnM7ou/ROzox6VqsE=;
        b=Xqc3aX8ihySSxpgZa2vVw25WCJw4LK2bPXE1EfJHDlHlcaAo1EAGLHdeiAeSJIYsz8
         U691jJ6aC88VkR1tYKG2Mmtkz7QhZQo4n888u/vQXWhcwavAsoNeRK/dEstbeirhjDl8
         tDyNj6ElmTZ3DNm0eWa4TNGAGV16T1HmlyTS2RXi7K5YrZ4vis5StwmG4DXS6tFSmAdo
         +fZ6nFtJfS29mRTkL/ILFa1rmL1NcUnyik+pELNmpkDjH39k4gq5GOFU22f6w1oBy/Lp
         DtB7wpTf0qVReouHLY24AVQXNHb3inRwWgpF/qjoJDddjFfkLw++LYyoQeE1Zeqm5oY0
         +GUg==
X-Forwarded-Encrypted: i=1; AHgh+RrFzQxYy5McAnTTFyX43Zdbsio7RWJbHT+ARiXBCbjeH/u1DAaTzYlsHvDGAdFwUiatBo065eGK8Q==@kvack.org
X-Gm-Message-State: AFuF++mOrtbVhmbVhmVj0oypcF2/VMMKar/YJFhHjP59BC3YGyqJoOBB
	9Wcrb3Teijn3IRRpFKdx7YyyjebvvJ6CoCaIks92vPl9bJKfUol9PsJfT6gUIe0SlA==
X-Gm-Gg: AR+sD11LH+wpJxwMlRvRV6NN6WF1FXLR9NCPUC8bpdH4mMqGXJQEtC9rlVsbJKri3n3
	ow6eS39LmNoGU9AvlVT9c7OVi4gPa7EszCh13W4HxxI1yUTXQR/udrkplZ3V0fr5Z5qwqMGjXwv
	xX6fJzVswDYfkmxov/t4+dcvMnBdtUoPsFhtyhpGWV6X1D8KfwNFqWq14T/RiTg+e9Z+Ga0pbHn
	p/Rh9/c3zGs2pNgaVds2o0EqDtH5QDytMoXp2NTly7Kp16b76c4v3Syl04utdWhLOYEkCOR8WiP
	NOZrm40Y7jzQhscH2gwRY+jOt+LDJejixQn4mrM3H1QLg0ZDVl+dHKMnDmvulMHx0MZQAI8Jitx
	2MPbsHhUEPt8ThacHcWzmF9tPGsOVNkvIDTw0kc7jdrZ86e6/lGk0QmZXZ8UgnaeOK7uUohsb1a
	romACo0JIPl4iQoYG2l6dx3kp6M7smJlDrGeHi+SD8vHpE9o0lCXrqOJyRt30fLZBNZCJTHB17K
	rc0I7NPF1YN7pJFMBeRDCHU2nZjD0n3ddVwIGohrGUU5g3c
X-Received: by 2002:a05:690e:1a46:b0:663:9a0a:7b80 with SMTP id 956f58d0204a3-66ccb61cec0mr2093887d50.19.1787171636227;
        Wed, 19 Aug 2026 13:33:56 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84512e347e8sm15186657b3.20.2026.08.19.13.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 13:33:55 -0700 (PDT)
Date: Wed, 19 Aug 2026 13:33:42 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kiryl Shutsemau <kas@kernel.org>
cc: Usama Arif <usama.arif@linux.dev>, Hugh Dickins <hughd@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, baohua@kernel.org, 
    baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
    lance.yang@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org, ljs@kernel.org, nico.pache@linux.dev, 
    ryan.roberts@arm.com, ziy@nvidia.com, nphamcs@gmail.com, 
    hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, 
    kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
In-Reply-To: <aoWw_iKEDLjKL2jr@thinkstation>
Message-ID: <5bd5c5fe-0d55-9fec-aadf-477891428887@google.com>
References: <20260819101222.3732660-1-usama.arif@linux.dev> <aoWw_iKEDLjKL2jr@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B0AA24000B
X-Stat-Signature: c8188bb6gudwxghm4jpx8tydz3pde6es
X-Rspam-User: 
X-HE-Tag: 1787171637-298015
X-HE-Meta: U2FsdGVkX1+FxDnTefCZn5s6oj0bkLwGhIH6glkAFZVVRvQSI5us2yyTvO+R29uss0LftN+LYOxfPlZvtnBkRgAuDkGm5B9nPS2aXGMAmvhje//38wv69YQk79Kr53XGTKJI0pCd/tz4Lq6JVnfxMS00XEddivBrpIcuqhLnF1okhAQca9nrnGXMyKEP8lk+YUuPXjpM7G97e3dH+cx8SlOKuyVykCepARASi9lFRZIMGhysGZYvNpPederSJ8MkKrcoFv/onGy89pxsg51Xq/F6yz0zd/IHJ36StSAUADnQOsEgPJCH7swKMbw79WFiLCcD4dpsEgCcKMAxulvz41Ty9Riz9wJPGNusVK8ynp0l5HHRwEGXjTUq7deSg8cdy3HAy3kGsL9MJahmY72Kk/podCN5CWPdy5Jj0WWz0h92FYn5kNAeVtohjDZuOa1EPeq4boBoe8fCDznVna8caSdarSDUCCZRNakklQciEsM+gY6SvRtq9eL7jLv8gx43Udvy2pBNOvzD3DZValPL/BTartz+SXSqH0ptb9wYE4bnW48/tShZMmZjcAJRN4EeYpNMwgtSvRp3JwA0ADizf4IMdqf5sPqM+tAhgtxsenunGjrTIIUaM9IivneVlOSCYBDwjeACdKI9x+H5+WFD63aDVg4s5OHCMAxyscHQUPz6IdJklMpxI0/Hp3Ki1TjybtIMDEl3kmf3iybBYj9dsnPHlGbFiPC16veO5h0zaarDVFNoNb7ShvJX10K/hzw6ppjfaGtAsIwKhkr6DQ+2UzejsfpImAoqmA4HrYzN8KkH3hqogZo9oVssIz3V3no25JLobwfrM9GNUe83AWxjH2Cpon5SsLDiVTIzfV1JD8CsE9pNPZ79a5RLZ5TNXzceZlz4hXbwUh4HWmRpSFPMX6FqzF6rYrKt8Yl5FlC1HHsyvF9oiEaiDFQi7/0/CAUg6davGyAeL9xyiIREz2v
 yIH5NmRa
 16fvyCFFGPqBHbRBzDcZzBqVm4zaKKwAIO175Wqr8N2VHv3LtVA0nxAaITe71EDnLtSAPMz01eGBfkzDNzFsXFYnfcXBtjbaberluta1zqNzSMtkx8q57wJxtR1fiU/6RpVpdIHaQYBUG6CmuqOoT7IcpOegZhB2zA+89IAtVhv28QBz7/HVIW0od2SypFeSfZqL4IPZZAEzqKm3H366I5naOAX69FmaudpZlXyFztg2NGaNO+XVL8HS1gBv4apxBa55uKlFb81VwsIee28LbxTEt/6XCm8c9FNpGY5s5Wwce6J0EFTPnr0zAtiQddAOK2Pw6rbVILg1xR2Hh2VFhUj3u5QVXhK6bspXNZeQYqkP11YMsUNf09DcBe1CAhg5HwIhN8fi/te3ovbSRVRf5/acGEJE0gfCNBwIi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Aug 2026, Kiryl Shutsemau wrote:
> On Wed, Aug 19, 2026 at 03:12:22AM -0700, Usama Arif wrote:
> > zap_huge_pmd_folio() propagates the pmd young bit to the folio for the
> > file case, but not the dirty bit.  The pte path does propagate it, in
> > zap_present_folio_ptes() and so does the pmd split path, in
> > __split_huge_pmd_locked().
> > 
> > For most file mappings the omission is harmless, because writing to a
> > shared file mapping goes through page_mkwrite(), which dirties the
> > folio.  tmpfs is different: it has no page_mkwrite(), and
> > vma_wants_writenotify() is false for it, so a *read* fault on a
> > MAP_SHARED tmpfs mapping installs a writable pmd via do_read_fault().
> > do_read_fault() does not call fault_dirty_shared_page(), so subsequent
> > stores through that mapping set only the hardware dirty bit in the pmd
> > and never call folio_mark_dirty().
> >
> > A shmem folio allocated by a fault
> > is marked uptodate but not dirty (see the clear: block in
> > shmem_get_folio_gfp()), so PG_dirty is never set at all.
> > 
> > Unmapping such a folio - munmap(), or exit_mmap() when the process dies
> > - then loses the only record that it was written, because zap_huge_pmd()
> > drops the pmd without transferring the dirty bit.  Reclaim afterwards
> > sees a clean shmem folio: the whole swap-out block in
> > shrink_folio_list() is inside "if (folio_test_dirty(folio))", so
> > pageout() is skipped and the folio falls into __remove_mapping().
> > There, folio_is_file_lru() is false for a swapbacked folio, so no shadow
> > entry is created and __filemap_remove_folio(folio, NULL) simply empties
> > the i_pages slot.  The data is freed without ever being written to swap,
> > and the next fault on that index returns a freshly zeroed folio.
> > 
> > This is silent data loss for any process that keeps state in a
> > MAP_SHARED tmpfs segment across an unmap - for example a cache handed
> > from one process generation to the next through /dev/shm.  It requires
> > the folio to be PMD-mapped, so it only shows up once shmem THP is
> > enabled (which is what we did in Meta fleet and started noticing crashes);
> > with THP off the pte path transfers the dirty bit correctly.
> > It also only becomes visible when swap is enabled, because with no swap
> > device shmem folios (which are on the anon LRU) are not scanned by
> > reclaim at all, so the clean folio is never dropped.
> > 
> > Reproduced on x86_64 with a tmpfs mounted huge=within_size: read-fault a
> > 2MB-backed region, write a known pattern through the resulting mapping,
> > munmap, force reclaim of the cgroup, then re-map and read back.  Without
> > this patch the region reads back as zeros and vmstat shows zswpout 0 -
> > the data was discarded rather than swapped.  With this patch the region
> > reads back correctly and the pages are swapped out as expected.  With
> > huge=never, or when the first touch is a write, the test passes either
> > way.
> 
> +Hugh.
> 
> Oopsie.

How ghastly! Thanks for finding and fixing, Usama.

> 
> I'm confused why it took a decade to discover the bug...
> Maybe read ahead of write for shmem is too rare, I donno.

It isn't entirely clear from the report, but this is all about modifying
a 2MiB+ *hole* in a shmem file through an mmap thereof, with first fault
a read fault not a write fault.  I suppose only a few proceed in that way
(though truncating an empty file to some size and then mmap'ing that size
is very normal).

Or everybody who tried to report this bug, wrote their report into a
2MiB hole in a shmem file through an mmap thereof.

Other than holes, all shmem folios are dirty throughout (and re-marked
dirty as soon as brought back from swap): so for most, it doesn't matter
what the pmd says.

This raised a dim memory, took a while to locate what I was remembering:
e1f1b1572e8d ("mm/huge_memory.c: fix data loss when splitting a file pmd")
from 2018.

Not quite the same; but what a pity that one didn't prompt any of us
to look further and find what Usama now has.

> 
> > 
> > Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> 
> This would be more precise: b5072380eb61 ("thp: support file pages in zap_huge_pmd()")
> 
> Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
> 
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Hugh Dickins <hughd@google.com>

