Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEDB8C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 04:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2B416B008C; Thu, 30 Jul 2026 00:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDC4F6B0092; Thu, 30 Jul 2026 00:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACAC76B0096; Thu, 30 Jul 2026 00:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3255F6B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:58:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C006C4021F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:58:30 +0000 (UTC)
X-FDA: 85044237180.10.3C3C355
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id EEDAD100007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:58:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ly1i9sSO;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785387509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xIFNfpu9gmD/EDvYhBb6eSwchsbOBYYW3f9ffk0DLHE=;
	b=Doaq5cgaHhO3RHOstObkmXjkYALW22MY3KmoQyG/AwcfsJstBENAAaun5nvmaio7krLyn7
	hzx/prSAgvzgAJV7/c1MW5JXVJJ1+ry1XgR4roYnPVfY3U3S/H/0UaXfgmpNglIdPdHxTK
	jxn2/Yzj7Dx+ttVdeL/Mdmx6+ovyzlk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785387509;
	b=eyvgPbicE1Y1tpd0zFEt+JRO565d5zVs1OFVYm5Zga58hv/Rr8sssdlrrLWL060NW8/qG+
	LGzf9Mt/x4YZSgTDM/gIQSWpCqcwoF1FXyW995gSY6Ex3cASpOfeNE0igYF0r5XH3qy/oX
	jbrTCTblp8oXkHlKb8oFp22wfQGL3g4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ly1i9sSO;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c16ac21acso11002341cf.0
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 21:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785387508; x=1785992308; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xIFNfpu9gmD/EDvYhBb6eSwchsbOBYYW3f9ffk0DLHE=;
        b=ly1i9sSOyUATyEjD1VTuL1KnqBcDudVfhsNmrLf2hETJYWD3mSufu/A3hADiIuapoe
         m9Poc7TIoO8dqvoE+w4Fr0Dh5MqQjSzOdRLdxPKzLdVEIc0gHN8pegLm+novcLjyfRfh
         hZNSFS5vWcpWtkLNww5MrKp6XvTYQ2BpaOswJL4ZOGYP6BSeJAPO1pqc9KFF7B3nHCsz
         CWV3qTo5LCRPgD4D7szuHZTOf68QOsGObakESKS7vmtPU0h21n34hxxzDITxI08vxYLN
         kAOr39fjcZiHz5oQs/ZJGRefTNGZGYDcZb324ozKj+TWmeOMsXLrA5go3ePoOBx0EgIO
         pZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785387508; x=1785992308;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xIFNfpu9gmD/EDvYhBb6eSwchsbOBYYW3f9ffk0DLHE=;
        b=aUj0kv5SN8/o5O6DyU4/wyLpYLSpxrQzMT/09zw/l7QwC04AIBR2V0z172KRUPjZQ+
         dS1DZHB2bFlYm71OLjVObQl22qWzFflAy9KQTtGRil2oi1VT53iHUWEMIZmvAQFH20lr
         x+S/oiZBPUzdjlofi8P8OwC/C6smocw9+PZOev2a11Qq6JZ/zi50jUrk9FwHgPjel5qM
         508zcZGizMKImChIzNY4u+QF0Pgv9fdXRdOYvktqg7W6FHwA7aCP0OdHHzkICYqbOkkY
         6mCJk2YFMf9hxmh0KaRzEgUIyXbiFS+DHohon3rRYBjoksNxCjbxemgZYsBt4IOf5XpX
         uwWw==
X-Forwarded-Encrypted: i=1; AHgh+RrRTQ7fGSL4dMgrfRo8PHP7UqZS2HkU9DrTgX7rDs7ycLbdb0j2C5gtT/w9EIvD7GOSPimrpqLv4g==@kvack.org
X-Gm-Message-State: AOJu0YyVUwUw+HwTBz/5W1Vf/2s2q07ICTAZ1HOi3CbwCFYxYORY79Ha
	TNPN5ARDS0l9zjMY6gQHrNwxmhMjENkQMcI1XKtXaIfR7ha+JfSr0FdTQXJHBIVbR78=
X-Gm-Gg: AR+sD12uSUIb0LTpC47fsWd3WCuHm6vb3ZLmWyagNfdcuZ54MLRvNCVhmXNqaEYmP+m
	mMMchEv+jid2n+JQ1b6BFGpVnL5f633SX5Nuh+L4XDKXmbEhNhA14ZGN1CcGJDxMbvpwGfFNX/t
	fzpAX/obznc+aDDlGfkU1PZ+9HSSzmRqyWhpdzYq0fAzhlteAdsJhaa99BlwYTBJf4R3Hv9kBZy
	/MFSv076+nPljvdc0orOXm83cfnO4T9L24ik2Ypvr4DpVkZu2ZMeROMvRDPboikht9DN7A/f50h
	nEkBI4Oz2n9kBmHlkRhe2/GbpLe7yR6SNg+F7XTtfkHn69ArDp79yIoXYOu7GRycsJeXQ9+KsV0
	C3piliaaParDB7/QUA75aN1CvFvARp0p8k9vvriUVbRxBZyEI3o9MTETXRZakY2IaQaauVJaGNh
	f06XkXT2mDzLR4LPDbylf1maXNv36lBP5v1kIBvCMV10aCXfKV6r7L2P9i8KofgeawKzlm87zHS
	9aJbrwXpES2E9Vt6yrviKxB5PC6i6sOpiq/6mOt1yV8
X-Received: by 2002:ac8:59cf:0:b0:519:51b1:e764 with SMTP id d75a77b69052e-52b38662c5bmr13461711cf.47.1785387507988;
        Wed, 29 Jul 2026 21:58:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933e733a27esm338204685a.34.2026.07.29.21.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 21:58:26 -0700 (PDT)
Date: Thu, 30 Jul 2026 00:58:22 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 03/15] mm: abstract vma_address() and introduce
 vma_anon_address()
Message-ID: <amrV0Y7ZUtihiB2B@gourry-fedora-PF4VCD3F>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-3-e8ecfefea812@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-3-e8ecfefea812@kernel.org>
X-Rspamd-Queue-Id: EEDAD100007
X-Stat-Signature: xnksopmmqnu59r5o6s51dptpu5ser1xs
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785387508-882684
X-HE-Meta: U2FsdGVkX18O1m8NOckGR6NErCE4NWIj/kmunoLtF51EfvhvuafAKYBkH32RFLHxjHohfs46xv/a8eBWCqA3EZBw5wvFx1nBgtYUNYX0fe7jEpPfrFND0I2l1tK9spGr3Rp2yzoC5ycQm2uoIl+7B0fBYLgmy8x3nYoe0e6WshSXtnPYO1s8SyxGSai037yKq4qYxTvI7yOos6IqFotWL6RZIhMQ9zhyY/k4Rd1vihRQvVgefearYuhlcO+5x7rbgwPn7bsbtRma0M1Owem93AYeV9vBIDLM0XW62F+ISNItlhSvhtsIydQJhs5v25nE7GIHUXPhSBDMM9HgGReRR708m5s279BPUphOaxgdadz1POXxT0Iz+MEX931E2ltQLPGpc5ZT4cMGHAyOInM8azlEVIbiCu5hA10JsAkrbB8eZ3zGf/aM7GTEjTrU8GHxmOXoW9duEFFJgYS1/A5WOo1RUvm/LFZ3eGPBCRM9nKpPiTM/NbVOu/FjN3G3X2Ahd33sVQWAYihi/8SPUe+mxXRlTt1/J67r78zzzIP0/Ed/5/1VQ/vH1HCXn0mZ9Db2cLfdGJDKIILZTVNRAJkzl0qnMmVEu+I/fRJRERPrDHEWWhQqD+huUps8l7O3ku0RPHeKJe3/fHmXKhYxzpIU9u9PdNDMuOqoZ676mzaLvulNG0kzY+1A6b20yAVe82YE49E0MQGeCIEhSq8bKDzKT90ZUPQIfe5dl7T2JPlOOUJv5Ulg4d+T2FXVZMNPisR3HsezBmwyk9KxEBeb1jNI0FzPyj5bMEol3bx/j1+5teTN9or0Rc9MwwEv0rKUmVNius0psRVu9o7nYSC4vRy+OqN+nmQWwzPzTx5z/jjQO3Jr8OGwXSK3u3AojGonQAhvp+gwMoqZzE92qNcV263caiYHGZINQIUGWucb4P0zr7OT4yvn/l/IgeFWZ3nWzz5L7jNHAcB/lUQwjSmN2zp
 WR7Rx1XC
 LrPDSZ2Nl/bjLjah5+TpZ4FmnqBEiid52PN84qxNCtJOjsMFGIoEyJrp0ebrk9dbIPHTJpdBCE9GIEDJEts6lfF208QYjbaxAtJ6RdVhY3zp+Zny1oNvIhCUMUIK4es6i7dY1o7ENHrBdPfJZd3JJ5+jSddG+UTnp7Fqll++3Y0IP+KgvI9VZD2JrjC0KZQ3sNwclAVy+oAV0dZWm8W3zLVU0M5Yh1BD05rjtWlsrUs4OY9P25nBw31Jw12RRIIG/l8L98dNeamRv7S4CBOxkoEl1RfkZnqvea2vqufiSGOh7WbT3eJClLWavE4mRB4W3c7mRLOZkN+Gj8P00rATnetbo8YnSV1DG+30IJVCWCKAV4fcR32yiAHCsXz+4LyIsxxArUpj9h4GIP9tW4tFpHf+WbxqND07dcNW+d5xSkLr0VW+IsSuSwsiU6reTQZruNVCafBU55XtzmN8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 05:48:38PM +0100, Lorenzo Stoakes (ARM) wrote:
> 
> This will be necessary for determining the address of a folio's index
> within a VMA when the folio belongs to a MAP_PRIVATE file-backed VMA but
> has been CoW'd, and thus is anonymous, once the anonymous VMA page offset
> field is used for the reverse mapping.
> 

This is a doozy of a sentence... 

... determines the address of a folio's index within a VMA when
  - the folio belongs to a MAP_PRIVATE file-backed VMA, but
  - <The VMA> has been cow'd
  - thus <The CoW'd VMA> is anonymous (as well)
  - The original VMA may or may not also be marked anonymous?
    (just clarifying, could be original mapper or a COW that COWs)

Ow, my brain.  One question below

> +static inline unsigned long vma_address(const struct vm_area_struct *vma,
> +		pgoff_t pgoff, unsigned long nr_pages)
> +{
> +	return __vma_address(vma, pgoff, vma_start_pgoff(vma), nr_pages);
> +}
> +
... snip ...
> +static inline unsigned long vma_anon_address(const struct vm_area_struct *vma,
> +		pgoff_t pgoff_anon, unsigned long nr_pages)
> +{
> +	VM_WARN_ON_ONCE(!vma_is_anonymous(vma) && vma_test(vma, VMA_SHARED_BIT));
> +
> +	return __vma_address(vma, pgoff_anon, vma_start_anon_pgoff(vma), nr_pages);
> +}
> +

Why make the caller have to know anon vs not-anon if you can determine
from the vma bits which vma_start_pgoff variant to use?

(I suppose this is probably the entire point of the series, just trying
to get some clarity on the increased API surface).

~Gregory

