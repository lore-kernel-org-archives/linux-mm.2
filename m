Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F0760A260A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B1yzwcN7
Received: by kanga.kvack.org (Postfix)
	id 8F6FA6B00EF; Tue,  3 Nov 2026 09:51:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8106B05B1; Tue,  3 Nov 2026 09:51:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7975B6B05C7; Tue,  3 Nov 2026 09:51:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 581616B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:51:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E03D580482
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:51:56 +0000 (UTC)
X-FDA: 85394097432.29.50C892A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 56EECC0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:51:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B1yzwcN7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qj/jBK5uYX1lBOAh7CIGNjD5DbAGZcwkTAmQo8pBkzs=;
	b=EOhfAY27HYnTkf/mOgYQwkRvnW/pp18AL97gxBXY+Yiw1WLXiJvVUkHLljb0rueNIAXxsR
	wfwmtfeh1MZc6PnXDXCLA3KkYMAjKSncPw/+o/0exPj5KFLYvtdWzpLtwQ9u1UVSWmK4SF
	Bz3zoDJOBgQmBcWZMK2leG9JLnpcMsc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717515;
	b=VL6SafA0UABzAHFQ6KEyz77QZM6HCLuiU/27WA0lpI+CxYC4QR0f50cyM8LcYV7zai0SSH
	+XXjgsCIijhXS4sBTngtO88rKdIrEX1jGHOJO3+UK0e5MQZCAZgCchxiM4uTpcvDmLxxGq
	TB/Q8xjAp5NwAUIlY8jN5pRKB9AN88w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B1yzwcN7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C64BE60008;
	Tue,  3 Nov 2026 14:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DAA1F000C1;
	Tue,  3 Nov 2026 14:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717514;
	bh=qj/jBK5uYX1lBOAh7CIGNjD5DbAGZcwkTAmQo8pBkzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B1yzwcN7CWiyNWpcvubXRrCbxuNfue3EMWaxmI3o8yCwa1dApj+/hy+6VaZvzbFwj
	 gEiGdceIHEoatSvdxVZYydAj6jRnOYabrYDeBySkuosbTg1kwo0jFsSP59YwWge8Fh
	 vUK638xS1loXo8ZXokQ+5An9IkLHb3WpMcTzQ3KsL0J8WrjSZcRZhAoPTl6T2kttoz
	 rdkBGDeGBcS3zMVvm8FyuDJ2cPNbXIXbrVQhwpQZhqqSn2Json5EKJTKee4s6G1RTm
	 tpxiF8y58k6WRTbQocwVUIseU94DsGbwghXbH7zHPKxEd/jWAiuBKsm5tltGI3Ev+r
	 CvokGvV5slJGw==
Date: Tue, 3 Nov 2026 14:51:52 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] mm/slab: serialize defer_free_barrier()
Message-ID: <aun0lgIta8LmcP1T@thinkstation>
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
 <20260624-kmalloc-nolock-fixes-v1-4-fdf4d17351dd@kernel.org>
 <feb3e339-f61d-4f99-9859-e1895d396561@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <feb3e339-f61d-4f99-9859-e1895d396561@kernel.org>
X-Stat-Signature: afju5okrzqz8up48fxdhxny3jjffeyn9
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 56EECC0003
X-HE-Tag: 1793717515-891949
X-HE-Meta: U2FsdGVkX1+xOthgLxMXf28HYO4UeU0eue/eIIHV9+cYKbiGOdShhOQoSN7u2QNgwP71aEWFMLd9KWwZJ3O+ZVFTyC0b/ZFfY4ZJAQIxr4JY96bzvqJVUbi1QPcF/n2f+8dTOoHguBOFtpRXbjP9+ScBvkx8rcuyROclFpT0Yo1d3+CUKhqZoyAnJ0NwBFvnRiiqBZEHwyZcNxPtamDbHbskRGf3l5g3Ig3zS5Iw+mAMCDukaRw5TjpmxS3sjJuY65QitvsLBaCrGbga/oTofvQrdXyPXI9BZlNay2DuRcjlpoapFnYwt4HFk2A687s6KjJzC/mvRe0tU5rx1yXKvWXkKbFYk/coHFpj6/hR4f80g1uwPJf7yc2opSctf9xGolS6nzSrwuQEPtFr0sznMxudl3AGdbdClPovE7RfVYX/TPKtohkIblecX/+vKPDrVo4APqpzStlDOxmLD27WvwyLvpNWTQQltv/LPO/k+XKDUKTy6CaXCKLuJX7KWfsX/gnYth+0bMpnr166+GVpRXAaNnrcLLRQM0+ZINkBcUAdT9Eic3yY/Y/3Wh5439dy/foCeOR0B6DZYstViy0iDrTAni1JSUwi4EjfJDm+FP0f44FlVSnMLr13cod9MOhUTmczNx+03yjsKbCBsZq5oKncqxN44yXXJBlZzxy1+BbsELy/0penpHKfYecWATQiY3MKYOfOKE37HZVWoiX4JiQ0NbZN+dkMVmN1sdm4TFp/uRnLid8IDxuvhRLyqVTfgc/NQW7Y08QeqUlh85otMJtR9ETaDT+/g7gqujU9Vrv+xp43+DxtnJ2ovpsXi4UB+HRjPtDbuxZHGix59b2KdveuFrOxlV3k1evHyAQKcXO0EGuhR73wXDgSoFiLt3A1jn4VhD4YcUM/wIT3MVIvMHpNjGcfDpkq7SebHTjLb+Jfq5IwiYoze7zAVN4AlWmsGS30m/Lm/PTjDY797nd
 6vE1fGzt
 fabGXq2THpwIzxO8lA31sy5TmdYgEhzP8c2VSwAUIrSTclH65m7IhmH9zrNsvSBksKv9JcFFvtjhlD0HUKKbDlWOrg0+119yW8l989Xq1IJE1liwa7XjZw8JHZV9AiITFxFv+Hd8jLYbLC8rKlW/Xhe0Uiz+Wmp/zggvpYLigUFvQPSeGtYt3f2obUYYrCJRLOD5dX+lk3XLio7QiwciaHZf5yYhSky6roH2oEoM0E1ju3A3ld2xxIjDBzKtdCSmX9+yBfTDVYDtxBdFy4GaMw+RiaHN7PvfM+AqzFtjUhDR/qOHaBbHXs9dSQek2rqob8FsDZ6T/dGqv+Xl3MPzbsuj0k3JzK0n3dcLNXoLTpAmcy4DCHo5iP5JC8SfOLCFB/6sd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Jun 26, 2026 at 05:00:51PM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/24/26 15:11, Harry Yoo (Oracle) wrote:
> > irq_work_sync() uses rcuwait instead of busy waiting in two cases:
> > 
> >   1. The kernel is using PREEMPT_RT and the irq work does not run in a
> >      hardirq context.
> > 
> >   2. The architecture cannot send inter-processor interrupts to make
> >      busy waiting reasonably short.
> > 
> > However, rcuwait.h says:
> >> The caller is responsible for locking around rcuwait_wait_event(),
> >> and [prepare_to/finish]_rcuwait() such that writes to @task are
> >> properly serialized.
> > 
> > Since defer_free_barrier() calls irq_work_sync() without any locks,
> > it can potentially cause a hang as writes to @task are not serialized.
> > 
> > Fix this by calling defer_free_barrier() under slab_mutex and
> > cpus_read_lock() and add lockdep asserts.
> > 
> > Now that defer_free_barrier() is called inside cpus_read_lock(), iterate
> > over online cpus instead of possible cpus.
> > 
> > Reported-by: Sashiko <sashiko+bot@kernel.org>
> > Closes: https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org?part=5
> > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

It was dropped as it now introduces a mutex.

(codetag_unload_module() invokes kvfree_rcu_barrier() ->
deferred_work_barrier() but doesn't have access to slab_mutex
so we can't reuse it.)

-- 
Cheers,
Harry / Hyeonggon

