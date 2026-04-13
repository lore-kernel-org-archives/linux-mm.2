Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 736BDF34C78
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 17:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7176B0088; Mon, 13 Apr 2026 13:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77D16B008A; Mon, 13 Apr 2026 13:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB59D6B0092; Mon, 13 Apr 2026 13:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF4276B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:44:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F706C144B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 17:44:50 +0000 (UTC)
X-FDA: 84654257940.06.713FA0D
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf04.hostedemail.com (Postfix) with ESMTP id 868C440003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 17:44:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kF82xfwR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776102288; a=rsa-sha256;
	cv=none;
	b=RXy09BfoQv3k8UEcUfCJPqmmH7Ejd4PtylGIjKlAQy3o+IvUKvGG++dLN+Fud0WZZlHWnY
	cOqwBdWt0io8pqJx54jwE5I9+CsVrlLg3l2sfowTbLp8mK+iQpsA/7Gz0e8TBHZIhDYncI
	tEcf859J0WJrBUXB4VTAVBv2V9LZWCo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kF82xfwR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776102288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0j9S/oeWv9cGrOnlEmdvesYiWMQozAk+6ZeIzA0Owc=;
	b=M5mzBi5oemFdTxeNysw4z3XAC/udaXLlKb0MpgtYw+sDmKMXw2nZoIMSNv7WZtg5W3UTaY
	BzKFXVCqoYh1KLN7WT6j05jtmEHC0R2RP6j18q7Kf5mNmj8calyIqm6JW2Nr1gI9X+1HG/
	vcjT5LiIC4RF8eDFcgWx1bkFnv91brQ=
Date: Mon, 13 Apr 2026 10:44:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776102286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b0j9S/oeWv9cGrOnlEmdvesYiWMQozAk+6ZeIzA0Owc=;
	b=kF82xfwRKUDeEAuXqOchwk9JzjnHGoGfLr6ipXkTHA8Y9gDscmQu3i/dgmUx3cPA8uIVZb
	a4vMT/H+Owd+AsXn3B5FTclx+2LzDPYcGlTlnvfjefVUU4SzorZ631Fwoh1XzU06KX+uM+
	TEyj96yOsj7dLckLcRg5oq87cs83K3A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	inwardvessel@gmail.com, hannes@cmpxchg.org, josef@toxicpanda.com, 
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, martin.lau@linux.dev, usama.arif@linux.dev, kernel-team@meta.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: blk-cgroup: fix use-after-free in
 cgwb_release_workfn()
Message-ID: <ad0rbPUaeGJozbSe@linux.dev>
References: <20260413-blkcg-v1-1-35b72622d16c@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413-blkcg-v1-1-35b72622d16c@debian.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 868C440003
X-Stat-Signature: p5sfhtwmzz15wcm9ojrk96nmdsbehsui
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776102288-513036
X-HE-Meta: U2FsdGVkX1/j/r13IOVI708dAntcmYKFNNMyVHIQu2/SS9qZZ8d/GJeGgV5GDXw8Nd75R3Iagafr/1GMdv7gd18YLp0AkdvUuoGGq8VzBisJo9TrLrvmto471va9UJMr1RFS/aW53mjMfsJGbXi4tCDn4HehnQJoNMTA4HQzrEztig6aYoTLsDTkZXjFCD5uBue9nY7mG7Zj/YhmSHfEPgZUeAhy4H0qpzVTAhjyr3LVA4e0a9s0gIsJ4e35g11T1N9XIEuUu2dF0qgCzQxIOlAQdcvDQyZiSwnwHgw4fYNQ/GgmvsadYWuXvuoQSdLbXUp1ffqn3OeSYNZQ/iSgkFah0m1ySUkHFDDpbJqeU0Z6fem0Wv9W2l7ChCdr8fF2aiWw8/tEZJNmuz7/Aux8canyEccTKWulWPBXxPu/iyGEeFCmH+8dFLCCvc++/pnbS7+j7RGBheoAzA1196FYHgUgIG8cnuRLBl/yhYIk4K02ouPrNzIbejrFnHmXd8i9q/d/R8XGK4+o0ABX0Z0liDRUHni2m/qD4+tVzoN7qWOzZrhKYiQ5Om0N7Ybfbc7mIc1B0XK9NvNdk1wMpPNUDYGq07S+5frI9RMkT87WLXlis4W2sIRuNCglNGrtXmZeZfBonEUDfFyvHccsjYb2aFWMmbKmFFBx4ZM2nX2ivvd0mIrVwvOxwz6cVF5GIEgf45sqhSsbWuZS9P1khNLRFikBD9PLguPoPgJC0PS1I2HLpOuNyIWe1wBlRx7g9oEHzOncB1wD6jp1GVvlGYri0jIOb7/GAJ0a6zJyEdg4eG/0znlbgNn9lcBIjsxVfDY/1T9h6bpXCBveupR2+oC7GjcvSz4JkNL7z0MI6N3TCo5+MFxZ3qcx3gvRrmTCq6O/lFrDhqmJ8THow9krl4d0ZNxgFKl3d/QwB2a2DmfKAzpAN98N/bz+EyLsAi4w8swE/BXECnflBVlM63X8bLX
 lIOZLLVS
 vIpA1QzVAiuHKjD7nheDuOlaLt0HSizQXUUB/xZaVByi1YhkLt36iLm485Qr5Q+pL6lL+M4jbWnoZFIX11s04jDy9htmg2jugp7kanDZQ/1k7odhwywvgVfVOMEOQlaC12Nnht1bRVqACti1UfO73da4kokycJ5H71Aa8hBJeRyJMej/2lkplyE4lkbnKmJDsSy4H2C//jceuEBzb6lKbimYkqpYYghdJuN/MwMayClluUwFdNpr92yLnKLSDiKaictlUG+4vmKYTxhYvKRO42hm78jD5E8BUnXUnl+vWP468Dfbiv4AX1h2N/TDsoCiwchR4Ppb3k726CyXxpExRvKiHAkPuG8fiWbBjMeZ8sR38Ans=
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

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

