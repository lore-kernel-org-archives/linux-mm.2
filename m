Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CC7AC79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 09:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46FD76B0088; Sun,  6 Sep 2026 05:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 421296B008A; Sun,  6 Sep 2026 05:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336BF6B008C; Sun,  6 Sep 2026 05:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1578B6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 05:33:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 056381204F3
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:33:14 +0000 (UTC)
X-FDA: 85182823908.03.31D59F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 26D7220003
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:33:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LSSS/VC1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788687192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QtJaQC53Xu+vdhNscJOrU+8pQpYtxNdNcVyiWjAO/Bo=;
	b=S2g7Amvbns7SvFeFF5mCFOcB9OGs75Jfk/kyr5EA1v/ltFWBc0guI8FTXldZqrN+g99KVb
	Jw0qNXPk73g6v/RM1qdWLGz4di72joI/t6vILai5zOcRSFPR+ihvQRjfcFsKP9kSh5jOpp
	HdPYBWTcpuhoFcFuabkBhRbm0AP/aWs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LSSS/VC1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788687192;
	b=SFI6sDIw3Ogmx8VZDiv7B4AVpGs2s1bdIwZuzLk5NKzrpFfoji935v60WZJ97skhrKVFe5
	HL7Dt/QE1f0puTzzEVntbUE9EtPHk16YHzQz4gJzvhTGfFqFcR6Lmd+Flb1FXUnawCDFr+
	WdtIoESq8ylGOvBwOUe6PtxRf36Qu/8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 548C4601DB
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB011F00ACF
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788687191;
	bh=QtJaQC53Xu+vdhNscJOrU+8pQpYtxNdNcVyiWjAO/Bo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LSSS/VC1pTisr0VvLky5uFqbyjoqWhb5z2K6GGrB2mCOJLkw2uGt0Uf0htxcPreoj
	 oMRxxmX7TkODoDzd8gWkLySDh7SihtwmHxhP0aC4nvr1yK5ksm0SHwdrfIjmNUDBm8
	 zl/rPq4WVz1T5fg9yKXrPeJaR34YTBhG23WUdO0Z5dwXfnj5P8Q6o0gXjJJN1x+x7Z
	 q5KfOdDLSARI+R6vGi9Dt5Yap8c50/TR9b8rOuej3tFoW4gEPmUIna0dJggPXynoIN
	 S5pwOymjPA2kGgko98rv4Mla7uyRT3Y0gPSDN1NTCS94CLXimxDpBWZf5c4WQsnu2T
	 A2rJD2CIClVww==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c263415982eso87745366b.0
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 02:33:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzBOFZQA0TPX2/36sqNtO+WerJ+Ya+Xz9qeTPUdgYVf+ZjCdEyFR/PrvIBpLfyh/bcL2Oe0YUDmoA==@kvack.org
X-Gm-Message-State: AFuF++lWdAnZNKxfG+xCB4t21hdGzUEEgs/Z5/A4wGg4K7Y2rsf2XeGJ
	5tXZ2zYjelv6MPv0CingszSGS3XCvK6lF08cMFGkxRQIBkLDKd+xt23ZkjnWxBq98edRWWfskWX
	QAn8KD5zutvAxcyiwKzTUbPzzb586TWk=
X-Received: by 2002:a17:907:c017:b0:c25:6210:84e5 with SMTP id
 a640c23a62f3a-c260c9dfc39mr1222379966b.14.1788687189891; Sun, 06 Sep 2026
 02:33:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260906-shrink_zswap_entry_v6-v6-0-ac4cf61565fb@gmail.com> <20260906-shrink_zswap_entry_v6-v6-2-ac4cf61565fb@gmail.com>
In-Reply-To: <20260906-shrink_zswap_entry_v6-v6-2-ac4cf61565fb@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Sun, 6 Sep 2026 02:32:58 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOm=7=1qE-7hq_L6SrdvX5uTNi-hr2VPaBWVaZyA7e57A@mail.gmail.com>
X-Gm-Features: AcwNN1Wmy8sXB0gnqeV_vKVpovj5_3Y85XL9KiBOHP7UIyqos5p705VNMCEOgWk
Message-ID: <CAO9r8zOm=7=1qE-7hq_L6SrdvX5uTNi-hr2VPaBWVaZyA7e57A@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] mm/zswap: replace the zswap_pools list with an
 allocating xarray
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 26D7220003
X-Stat-Signature: oy3w5pp4db9wkhirit3fpquemqw4gbq8
X-Rspam-User: 
X-HE-Tag: 1788687192-861839
X-HE-Meta: U2FsdGVkX19cf9Iwjm9GhqthAuFu/LzpHflShVN+SXzvG6mKhzkG88omlU61Id2qJMlkTfXZ5GYQHAfWqQcEOvpaDYEVmPQD/5iQqzsDhgobezTvAmQXcIq9jHJ7zw3cAteK8vPzHdjcZgmCa9omlqTCpbQ/+oqZeeUf2mxMFxQSfO5fAdufbJMfrG3jrfFwsg4/2NU8S5MnYYx3B7fbGZ9WcBUCRCRfpg0mYfa7zPwKm5NaB7ND8yvn7f31zegKNfagyYJ/nElJBhd4ovCPyKEhC9gzfRkcQETP+05fJao+sy3eXi+Bjqzk3AAcEtSx5Bh9MlDap9fy5D/+wiEvzxtW0VvMpSA7kbwqF6EGioatiXFfoCWDXiWMm8/G+cubzQ09pNgFB83Pu70vj4uorpdh1OpYmV/46eSXYC2JQOigsGui0rPwJ7uj0tkgxKKeAnNJSYnOqfvDdruNIr3kWf2S2Sp5MrU3kV0VCk0TI/g9jjjxirSYLzVjrzlqgrBv1g5/vrMe4dH4qKaSHQ68nlazebolc3xEpb0n3I/RZYdf2yuJQZEbEEJgBSDxk/Dd45VwyLtvKlamH+3D9z0puXLdT4TfKEjTbgdyzEDnZp2hEm8ZkTEhjCeL1Kvsd+VsMHyxh2KlVfsIV9wCuGeM5kN+LElNzZ6NcwBAvwDeR5OVM2b3nP3uOPh9u51XKVd/g7eIchlaDwkobKDB2IVMGOLXTGbpvTd5h6kWScDAIMGtQ5WFbwM6vmVL15crMoRzQRuXC/uLd7kkDY6+l1lDrSHDQ6fCEWK7EXcOePv4TaJhxFUvqp/s27xz6eR4yLN5rG3U/DgphuYlBp9ybnr8JKcaBg1cNvorRZlr6U/hP++Jz8XhkRjqS2XtnDz4Wit2KU7IbB2FmREMxhapRzj3HrEmTGd+cDJ5wGg2znc01IH2JqrPbj7KsQBFYAhLqoPT2k7/VBgX/BT4P2eTbEK
 3njTX22h
 ZIV9457rks3dKY3Gnzf/CNpe5VCo56dMNE9PKB4an+RBP9KrOSwc0RM3aMFNFakgs7Q9e3R7U6Q0MT4Vd1ed9X4YHuocXKD3T+asnVBCIXL2mnjbNyqlZAbnNDh23RHtA05yHplHT0N45Ig54yXrkrVHGpurHgbnMHb4DGsd1oTKZDwASgXJfwnZl9JacHTq3z0F2QRgGLhUpaR+1eVaIn3ffzSYCl0R1XsLssTDljNa/K6KH/9ZRCrUkcTybzW9JUSiR9yT8CJ5hLD73Uxdr+Qn5dooyHbWeWhEdIzCwOg5iqNKX/htmjYiy+72EPIsjaCq/PLDLrphxjhaNNvtMUekM2QewPVe1b6yJeWaVX9bSmt28VHd+NglS8S4UKwGA6SjpHZ4wMoD30UvLJQ9yoCDlVAXkueH3U9OuYYD5hkc9x+SAwGTEwhNckQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 6, 2026 at 12:47=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.com>=
 wrote:
>
> Originally zswap kept its pools on an RCU list whose head also served
> as the current pool. Convert the pool table to an allocating xarray
> keyed by a small integer id, and track the current pool with a separate
> RCU-protected pointer.
>
> The xarray gives each pool a stable id for a later zswap_entry shrink.
> XA_FLAGS_ALLOC1 starts ids at 1, so id 0 remains reserved. The id range
> is bounded by ZSWAP_MAX_POOL_ID because the later entry field is a u8.
>
> Keep compressor switching close to the previous flow: look up an
> existing pool with xa_for_each(), resurrect it if reused, or create a
> new one. zswap_pool_create() allocates the pool's id and publishes it
> into the xarray as its final step, so the create call either fully
> publishes or fully unwinds on failure. Publishing makes the pool live,
> so a caller that later fails (e.g. param_set_charp()) must still kill
> the pool to erase it from the xarray.
>
> Compressor switches update zswap_current_pool with rcu_assign_pointer(),
> serialized by the module parameter lock, so no xa_lock is needed for
> that update. The pool walk above is lockless under RCU. xa_lock is taken
> only to allocate (xa_alloc_bh()) and erase (xa_erase_bh()) xarray
> entries.
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

