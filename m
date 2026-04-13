Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BCCFF34C63
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 16:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A644A6B0088; Mon, 13 Apr 2026 12:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14F16B008A; Mon, 13 Apr 2026 12:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9034C6B0092; Mon, 13 Apr 2026 12:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF666B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:35:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01F9C897B7
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:35:39 +0000 (UTC)
X-FDA: 84654083640.04.115FDAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5070E10000A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:35:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H5ps2bll;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776098138; a=rsa-sha256;
	cv=none;
	b=PqDUuvGoNd3bGmwxrKnveTYHam4sOkZZJnRBSqb6UCakjHRKJvWAhXBmQaPyJee7RUCqgO
	lhsIevFB9KbBmtb4P8pQLiP7j5h2rdZ+mz8rMYBO9PSg0seXj6pR7LiLRZqW0dHIy4zbwS
	rDx1nLZOYC4grk3W0NfaPP9JHFqDCOc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H5ps2bll;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776098138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJW8uPJLg/6PJ7g/RMrDPLpdUBJLsI99GPBpjG93K/E=;
	b=FV7ICbK41YBV102rD0tkqrkphbZTaeSbmAqCRFvbx5ABfpp2ywpKUFiGqk/TkKhc7i8zGN
	hsoqJ2NlDE08q822aBBz2khBm4XotV7Wr1hasuj2yvQ+YmzX3aoM2xO/W58Dr0vBB8ts1g
	nWuyU6UNMIh5YAoUc7cSEOMjcM+/BR8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EAB6400F4;
	Mon, 13 Apr 2026 16:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80CAC2BCAF;
	Mon, 13 Apr 2026 16:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776098137;
	bh=Jc4nqUyrOUi1Nz4D+bekiKLIc0QDC++Iihbsm7TKSHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H5ps2bll3FOA7hkTh90vEDWKW5ynlDPs0dp6oPTq0IobVU5jMWnbzdxEXelPJbnm3
	 0QeCEOpb6papaZ81PORXF62n/Qt7iNjs3Wj492dgoaerCXcgQ9CN2zWPI1HUbIPe4n
	 UqU5AQGIP/Y/r4yXhwVuNGjM5f6WlwKjJFEsKchMa1Dv14fs1ovhApsOpKQQEpgodp
	 vN89Rf+4aZTp22oLcKNxq4vzjxN1nSRjK/96YiF5KBdnq3ArW+bkZncbfC/ZyxXd/u
	 KU8516Fp3Gud4ksfEeOCss/xT43MlH5z6fCxWNc7q5eQhUKb+X9BkX7gk2kvfnY4bF
	 a4T5MognHEruQ==
Date: Mon, 13 Apr 2026 06:35:35 -1000
From: Tejun Heo <tj@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jens Axboe <axboe@kernel.dk>,
	shakeel.butt@linux.dev, inwardvessel@gmail.com, hannes@cmpxchg.org,
	josef@toxicpanda.com,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, martin.lau@linux.dev, usama.arif@linux.dev,
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm: blk-cgroup: fix use-after-free in
 cgwb_release_workfn()
Message-ID: <ad0bV0OaUiyRqTKe@slm.duckdns.org>
References: <20260413-blkcg-v1-1-35b72622d16c@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413-blkcg-v1-1-35b72622d16c@debian.org>
X-Rspamd-Queue-Id: 5070E10000A
X-Stat-Signature: gkrof64m7idh11c7jrh7wqriwgsz1zqu
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776098138-504513
X-HE-Meta: U2FsdGVkX19wNFbZQA8Om7wX8dyG+gk5q8RC7HQa9waWA0oOafaWdz88Wo7FuF8F2QOJikDjIYVCP4qM67ArL2WJISp4hEA3cWDMf/ttAJeKJ+XL64bFFR0Zbr8FtYf5GRxIzVomFUDpL+X5b9ox84wVrMha2WPHqm8P/1Fc6D9UCOgqUvUN0Sb0Qe3y638cvtgyN7mAVJV670tuKULPlV9/UjiLXuwtKxHgtaNqEBiN0zfjhmPoIylpZukmMz0Q+A9hsbP1vGIBHD4iWFOirFcOaO3rmWqYOnvwFoC2B3vozyDQQ+AAWJwZuKNXeT9aFvdlPIYIbZ70A8xHEc7A7x3DN7dNCJmGpuOjMVlG8eM4xtqIXvvzY3miaQDEIInAcv3sKNx2nVNX54BfFzcteilpnvcVAlMqRb+FOKXQ7SZdPMsWgCXjXii9jsoBIBxyX4KHK1AuKARigCVO4DQXXVpkdFbpCKVGLVlsPCuKWd1Aw1g0qBoj8njPMvLEeRHBjxdZv288V2acC6hMYnMPvlOxPrXIMEJVy/Pa1ZbPHBKj5vyFOfdeSd9ZZ8+yX9MfmLrcdwwTElxJelMefJ67sigZfAjaR8cz8Z1FPQrwlWqZSODBgkCU+NprAqZnlFTDQyTwJx/6pPPwHWDTgRa9tPIsWd9kjMuzszlzfAakfjl/OaphplZSXYlmmFQ6VF06N/ENcAPmYLaFEWa0AYeR93+Vba2zpLDW8OppPKgbx0UxQKFhUcQ56x0oRBZ+MJoeunaowuibvxi8bbMYqMD4ygXaNP6Ck8B9WiZFbn5FhDkSvuW6h2+zTLCeLDCRm5miZUDaRv7eoQWoFJhtV1L3LwHU0KrmuaAyjWjvGbrdArlRIYneSky/EmjZEnQ0fG2Xmbu37DY9oWF5aYX/c5mHBQfwVK8aHJbS7W9rtGtzrUrkFp7+2/gZmU+3LTwDvgK3xbQMD8hW+ILpiM9uhtn
 ZnkaxF+e
 iTCUv2LPpj9V+uEgMpjgmntDxtKpHyzvJQpQ4UGyg3GWUKo/mV4fsUIfgzaWQCIW20Gj1qILbzUypj86hAHbO137Vo8aQunnYXIHDCEV6KpIVukO7j10HpJsaio6tikxGdB22CNHwJNhEwrIdHaHPZJ4JD+/Q7g+FOsKUrZLSydSA0czSV08/qs28agpcKvoAAOqUX2CooQYhboAAHW/H3XKCvcGsV5PdVQ1Hx+PHQb2L+C8rKDUEk1mS87dpZj6W7REVTx7VHxziv163Ruvch2VqtOBASJaieR4vnOGnHZ08JLvtm/QEz6zblqdyA3KYGVYiK6lwxdZEq0osWDFrbP4FlVw1dum34acPWXprvIDfD/Zt/zRmtNzciw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 03:09:19AM -0700, Breno Leitao wrote:
> cgwb_release_workfn() calls css_put(wb->blkcg_css) and then later
> accesses wb->blkcg_css again via blkcg_unpin_online(). If css_put()
> drops the last reference, the blkcg can be freed asynchronously
> (css_free_rwork_fn -> blkcg_css_free -> kfree) before blkcg_unpin_online()
> dereferences the pointer to access blkcg->online_pin, resulting in a
> use-after-free:
> 
>   BUG: KASAN: slab-use-after-free in blkcg_unpin_online (./include/linux/instrumented.h:112 ./include/linux/atomic/atomic-instrumented.h:400 ./include/linux/refcount.h:389 ./include/linux/refcount.h:432 ./include/linux/refcount.h:450 block/blk-cgroup.c:1367)
>   Write of size 4 at addr ff11000117aa6160 by task kworker/71:1/531
>    Workqueue: cgwb_release cgwb_release_workfn
>    Call Trace:
>     <TASK>
>      blkcg_unpin_online (./include/linux/instrumented.h:112 ./include/linux/atomic/atomic-instrumented.h:400 ./include/linux/refcount.h:389 ./include/linux/refcount.h:432 ./include/linux/refcount.h:450 block/blk-cgroup.c:1367)
>      cgwb_release_workfn (mm/backing-dev.c:629)
>      process_scheduled_works (kernel/workqueue.c:3278 kernel/workqueue.c:3385)
> 
>    Freed by task 1016:
>     kfree (./include/linux/kasan.h:235 mm/slub.c:2689 mm/slub.c:6246 mm/slub.c:6561)
>     css_free_rwork_fn (kernel/cgroup/cgroup.c:5542)
>     process_scheduled_works (kernel/workqueue.c:3302 kernel/workqueue.c:3385)
> 
> ** Stack based on commit 66672af7a095 ("Add linux-next specific files
> for 20260410")
> 
> I am seeing this crash sporadically in Meta fleet across multiple
> kernel versions. A full reproducer is available at:
> https://github.com/leitao/debug/blob/main/reproducers/repro_blkcg_uaf.sh
> 
> (The race window is narrow. To make it easily reproducible, inject
> a msleep(100) between css_put() and blkcg_unpin_online() in
> cgwb_release_workfn(). With that delay and a KASAN-enabled kernel, the
> reproducer triggers the splat reliably in less than a second.)
> 
> Fix this by moving blkcg_unpin_online() before css_put(), so the
> cgwb's CSS reference keeps the blkcg alive while blkcg_unpin_online()
> accesses it.
> 
> Fixes: 59b57717fff8 ("blkcg: delay blkg destruction until after writeback has finished")
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

