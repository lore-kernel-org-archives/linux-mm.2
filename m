Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39C1F606A320
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 09:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dl8FfbUE
Received: by kanga.kvack.org (Postfix)
	id 5510E6B01FE; Wed, 21 Oct 2026 05:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501A86B0692; Wed, 21 Oct 2026 05:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F15E6B0694; Wed, 21 Oct 2026 05:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1ABEF6B01FE
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:45:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB16EA04DE
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:45:20 +0000 (UTC)
X-FDA: 85346150400.18.20BB67F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B21531C0006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:45:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dl8FfbUE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792575918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qrLUCoAybbCPIOjIm2Qh/M2gA0Bxoq5R80FYWxMk3s=;
	b=yNjNKMyQ9YiumQIfbCCfewYo/yZeF4B88UAmCC5ITSLnqgXlohr1eqbjIzGpg+WQ05RrlB
	LRS+BmvJVbitRMRRXiy71oDKVaPu9DhzwkOVV8pIP0GaGnsUxfZy2cQwMD1S5SbvDHwnTx
	sx0DWdEHbk7k/BQJxvNVxgTMh4tORog=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dl8FfbUE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792575918;
	b=Kj6RRLTa+fklhvJr39kxvIgFSjD5w6VWu/94Yc6PDyn1qpwr6diWW2kBzcAcTvp2HQ0RdC
	pHc1uSKLfy40QEvh/ptfuz+9qeCoq21ULFTuaTqj5v8dViDd/zvsEaPbo2sOhzrSYx54JO
	Dk494DLxLyaPU7bGaoagmhKpTSES7bY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CC0260229;
	Wed, 21 Oct 2026 09:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347011F000C9;
	Wed, 21 Oct 2026 09:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792575917;
	bh=7qrLUCoAybbCPIOjIm2Qh/M2gA0Bxoq5R80FYWxMk3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dl8FfbUEEph/srB3oughhas0vq05lymkKS5IjuiUXP+TWb0Kp2Nz38DlPqyh3pEcK
	 P2xvXI5JSz7zthaMiYRi4hPE1KVoO6SnF899jGCjL2pGaJkM2AtzTP9cKYRhBClA52
	 NPFMEScx1jpvUhTxDiioZrDBdU2cByQicG23fkSXUM1p27kpA20KcAxrxaSzGSiXJs
	 7GBAOjWOwiNnDkqScnL49tAkIoR5mBhlxZfZ+Tko932oSB0KjKVVzV4fQ+1A76Vbqj
	 BwyE2d0Yi1EQkoWrc0yNzELJJeKe/io9siirov/+rV1nlVtGRnpgVUYuGi08jRYq1e
	 jjsw5x4r7Bybg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7EC8D198003A;
	Wed, 21 Oct 2026 05:45:14 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 21 Oct 2026 05:45:15 -0400
X-ME-Sender: <xms:qYnYaufq1do0LiMjqUh_MVS5GpCTu8MsEBrUxXrtuEYmRQIiez4Fxw>
    <xme:qYnYakkO9X2tqPtKQBq0QaTYASVnKG4i7bRJlJbH0gpHOcCDetx7dYYMBcIWWdy8h
    swM-qFQT0yeqeuJWhqBDZ1Bvdk9DzVoD_l5EnSP9Efdqtnq5ByOW1y4>
X-ME-Received: <xmr:qYnYaj88NIjHidgJaPHUmMHcKLobv2PmE6e73TvZdwCcTz96eGn54NFpN5c>
X-ME-Proxy-Cause: dmFkZTEvSGxqsS/DCaPrggYcYAQK0UZ39j8LbajDADSnOtRkzscubUYfT4QG9YFwUmB4m/
    kOLTZtPo7idkGfRZ64bg0kyTMrowCm5MlGyFhj2RDKk0JZOjsjyRhPqI+lFteJQkFUPNHn
    LozYLAA0SEOuSdMjeSqqWrdzUl1ewAlBAh6qM/3JGoxsevh0EFDBO2dV7vgsbPTDNf3Pgm
    79iw0I9pIorh5TKx/C2X5McT2BllFiKgTQ7VWpqSEgLzS90pqkNYD8KlcMrCH7Tj6OwscM
    8X80pZLzvTMIfxe0yFhsWRlt5G7fqzGqFbrLNJ1wR+Xr9XyHSX32ddD5haUU/skkilnHUB
    3zFtcBXirPMjfyxZGGrSpd251ZIIi7VPccrs9cRUe8lOjItkCBc+H7f1K5fISdK19Vfr/6
    kevT2sr2dcWqR+C3h/lXltL9BmGAb4nhmuXnUch/YpHUh2RdsvPspYvBZag0Yd2UkcbUuc
    FtaQusiN0eI3qmfzISC+tHyb/mTecI1Rth2pNEy1TregUSscp8U/3v+k2FCUScHm6lMd1O
    0UPm5z3m8ijT2DNAQveiywpygsF+K2gX9NKhbRpqrA+mW2ovUShVy5ZStxmXxrCoxG5SBe
    0O5j/SJUUf2+TGYNUEkfQoodCGzsjfBHxpC+G6mVSRXqylr6qqvqXvUvzTIg
X-ME-Proxy: <xmx:qYnYaqFVp58x8BH9wMBODSM8NWmLihPyVegrbn3ZCkhbYqui9obYCA>
    <xmx:qYnYanK7YIze1X7ly1Mkj6OL_FBM8cGAvE-Jxvqfn9DAHl8KJSL1Rw>
    <xmx:qYnYaqlfF3IT31nnq3QmPN7Xt0VLohR4Xr2WGeF2ATGt_IbkTz3Taw>
    <xmx:qYnYagyW3OXo_oHBKD8jZrok_-aFcP0eybriN1OV46m16eYMyEWX5w>
    <xmx:qonYaksedfw28ySJuezGXN1KKRNzyi5bOkQSvHzBnt5Ewz2nHRa90uGL>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Oct 2026 05:45:13 -0400 (EDT)
Date: Wed, 21 Oct 2026 10:45:12 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Zhijian Han <hanzhijian1991@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Nico Pache <nico.pache@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: khugepaged selftest: intermittent collapse_full(madvise:anon)
 failure and low-memory false failures on arm64 64K
Message-ID: <atiIEzFdd_sm4JG-@thinkstation>
References: <20261020024116.2949892-1-hanzhijian1991@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261020024116.2949892-1-hanzhijian1991@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B21531C0006
X-Stat-Signature: ggygjmgqwfmi8k8a9xzdjgqmc9z48ip7
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792575918-781429
X-HE-Meta: U2FsdGVkX19ChXBpgEtwkIywtHjrv5+eIFl3tEFqpATTSFmlxFE4tEf22cos2R4tSjaARqdN2zL1NdUpznbB9UX/CkaFNxR+sBcLq5A2o9IanpFloKlHwjLuJhHSgVS+QSb18IUhpkG6L9HQ3RPJqTlL7v3BW91X7vho+wm/W0Vfbt6747i5cUcQxiP6u+sLlAK8oIEDGDBd0zDKGwEbELQ8ofYQYEGkovUZIoN80xe5jm+o1LiRzY+mfuOmp1SDRTA3xmzwdE68LoB1tB3Z9sYAl6cP+fnLpTIrtgbEE4dQRpUUkBdoU6jTHrCWT1zxmPZ8AcT82ry9/U33v0LrXpSs7Adn3kMwPs8wgsz94Dr+4JBAgVgtfQsgytAsmnH63ETrFOEsxbd9Ckl5EUqfu4fpseuq9SzH1xB2pi3qlrhsYfSQMtc2ikzs07oInkPmchXjIy7rN3yOTCqoCJQ4rhUmcY/2BQW9vHghBPU1sQW1rQWTohMlzA5l2cW0nBeXgu1LSCspRDMCy+v+3lYJdXZSjtS2rnOGCJ8e6/MKcAT2MuB3ST0RVTpm5QKRlGJcSY9zJNVbiA+9CfrB4RkDF+ASBD9lp+tGLhA01dP4AsFOJXf+Pbr9+oZVjIBK9cumFxM7cE7T8ZjGazesBvj9GQIoUYLwGMAHVahBBxptsUavXHJuDOnoUsoQC1N5nkUWhuIWU/44BQNwH39aun6Rc+RcjlOpONqg/pcHt7bYF9ejZSA7aLl/YjXFlssnnqWzFrQSiZlPPA+BW6dRHYWMWhBDmVLEd6ccG7R8bJX98mS7Foz5lOTAsuNIkG26rbZ9FfozlvaczDsABumsNjwqDp+N9E78uvsURs2akOGWHB1hWnBRJ8kuX3eT+m/Lc3H8l6UjiVcN+0qObUNIXl8ARr8MgC8jeRdxQle5juJvxle9VVL0+l6NSG/Q9IDjWxtRM/uTenIdGp6ZWTpTYY6
 yUt/TZIE
 U6D8IX1kHvfDv+s9YEr3IHYLLVTo6ZIU4uv/jmrSi8ErIwZQ/MnNztPgY16S/s+89O57oHSj8XGFy8JAFEuEFwWBangaUqIebbDyFaTZhdVcBsDzkRsNrh6UDNm+5RCKGfgyBxVVZpn6SwUpXyusgQ/6/kZH8CfJerf1S7YWK3UGOvmGvVMgkYSVf40IWtV/lWhAE4pCCnzdb+VKYIBk20HZbuhwizF+yYL096Qgit9CKfr/Ly/hEfnYgr/Slh1ZuHDcFEKWrK3pleoo5XRFm5YLElu+TpilcCvy6i28tVr9T/DCappPBNaKZaqRk1Q63exQ9J+hp1j5xlO7eLUAKh3/zuQP+LpAVd50k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 10:41:16AM +0800, Zhijian Han wrote:
> Hi,
> 
> I ran the khugepaged selftest (as of linux-next 20261019, tip 3d229ce89862,
> which includes Kiryl's "run every supported collapse order by default"
> series) across several QEMU configurations while setting up a test
> environment for mTHP collapse work. Two observations that may be worth
> acting on; full logs available on request.
> 
> Environment: QEMU virt, cortex-a76, 2 CPUs, khugepaged test run from a
> statically linked binary inside a busybox initramfs (no distro userspace).
> 
> 1. Intermittent collapse_full(madvise:anon) failure on arm64 64K pages
> ---------------------------------------------------------------------
> With 6G of guest memory (so order-13 PMD folios are allocatable), over 7
> complete runs I saw one failure:
> 
>   # Run test: collapse_full (madvise:anon)
>   # Collapse multiple fully populated PTE table... Fail: Bad return value
>   not ok 80 collapse_full
> 
> The other 6 runs were fully green (102 pass / 0 fail / 3 skip each). The
> failing run did not report an allocation failure or OOM in the kernel log.
> A minimal probe (mmap 512M, memset, single MADV_COLLAPSE) succeeds
> deterministically on the same setup, so the failure seems specific to the
> test's sequence rather than a plain allocation shortfall.

A failed allocation would not show in the log: MADV_COLLAPSE allocates
with GFP_TRANSHUGE, which has __GFP_NOWARN, and returns ENOMEM.
collapse_full asks for four 512M folios after faulting in 2G of base
pages; your probe asks for one.

Could you check whether thp_collapse_alloc_failed in /proc/vmstat moves
in a failing run, or print errno?

> 
> This is the same symptom family as bddffa2f9cbf ("kselftest: mm: fix
> intermittent failure khugepaged test") — there may be a residual flaky
> spot on 64K-page configurations. I was not able to reproduce it
> deterministically; happy to run more instrumented iterations if that
> would help.
> 
> 2. Low-memory runs fail without a skip guard
> --------------------------------------------
> With 2G of guest memory, six cases fail outright (starting with
> "Allocate huge page on fault... Fail") because an order-13 (512M) folio
> cannot be allocated. collapse_compound_extreme() already skips itself
> with "PMD too large for fault-time THP construction" on this
> configuration; the PMD-order cases have no equivalent protection, so a
> low-memory or fragmentation-heavy environment reports what looks like
> kernel bugs rather than resource limitations.
> 
> A skip guard along the lines of "cannot allocate a PMD-order folio even
> before the test proper — skipping" (or a documented minimum memory
> requirement) would make the suite's results readable on such setups.

Generally, I don't think it is useful to run this selftest in a
memory-constrained environment. It is not the focus of the selftest.

Getting a reliable guard can be tricky, as we need not only free memory,
but memory that can be allocated for a PMD-size THP. Fragmentation or the
migratetype of the memory can also limit it.

Let's just keep it out of scope for the selftest.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

