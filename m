Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 242DCCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656F98E003C; Thu,  2 Oct 2025 04:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6084A8E0003; Thu,  2 Oct 2025 04:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CFB78E003C; Thu,  2 Oct 2025 04:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 32F5A8E0003
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:25:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D638AB8890
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:25:42 +0000 (UTC)
X-FDA: 83952490524.23.98E549D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2092F100004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:25:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Bu2eH7XH;
	spf=pass (imf14.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759393541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VV9Ovf6F7XAAIGErik7svnoMKbuW+Havs4VsSCXuJaI=;
	b=MIZYWdi9qVHc3gi95t2Mx7/r2BOv0QJgaY46/zPcX2JWoqMGDpaUjh35pi/JSREGRM5SLW
	Zq2l+TzAP7/Zri2YUy12SqbdVXhBZSDUA/oo/sb5osZMGpmGTogUj/gK2noLtcNEQcIfro
	YF4VS+yxZ1scKTpxPdYUhgNOjTtdfcI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759393541; a=rsa-sha256;
	cv=none;
	b=unmMnxcb1KVz6pC/47ez8mkUkDhb7W9VY7xhdXsxYKp1MCXVHwxaaQX3sH0H6RpEPnp7Z4
	RMA+IhvkZPAWWI5A4moZHRDDQ+CuJzAsxRIUV/Ie9S0wqgpEn2e7Rc+eSEVxxvVzfxjUFu
	hapHD78YbYeojqrSttI33vcDNP78eZM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Bu2eH7XH;
	spf=pass (imf14.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A9AD44E68;
	Thu,  2 Oct 2025 08:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4C9C4CEF4;
	Thu,  2 Oct 2025 08:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759393539;
	bh=rUYgOjZIb4WBFkTgqPyZeDyE4Q7jwjqmDpE7Z7xG6nM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bu2eH7XHdLHePX4Bf9lC5g6VKtI9ke1uBOEcSnJHwXk92fJhzOASc8OM213ef4BG5
	 q4GhQcZBnpHEGQKe8BKzoeZ2FDvVw/OAegY+rlI5qeXGG5B3lb6rK7guEI3fkTUc8R
	 Vz92RglvCXUVsjfgg5oOym6M1SHpU7RZx/f0N6Sg=
Date: Thu, 2 Oct 2025 10:25:35 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
	will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
	joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch,
	duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org,
	tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
	amir73il@gmail.com, kernel-team@lge.com, linux-mm@kvack.org,
	akpm@linux-foundation.org, mhocko@kernel.org, minchan@kernel.org,
	hannes@cmpxchg.org, vdavydov.dev@gmail.com, sj@kernel.org,
	jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
	penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
	ngupta@vflare.org, linux-block@vger.kernel.org,
	josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	jlayton@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	djwong@kernel.org, dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
	hamohammed.sa@gmail.com, harry.yoo@oracle.com,
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
	max.byungchul.park@gmail.com, boqun.feng@gmail.com,
	longman@redhat.com, yunseong.kim@ericsson.com, ysk@kzalloc.com,
	yeoreum.yun@arm.com, netdev@vger.kernel.org,
	matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net,
	catalin.marinas@arm.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	sumit.semwal@linaro.org, gustavo@padovan.org,
	christian.koenig@amd.com, andi.shyti@kernel.org, arnd@arndb.de,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	chuck.lever@oracle.com, neil@brown.name, okorniev@redhat.com,
	Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com, wangkefeng.wang@huawei.com,
	broonie@kernel.org, kevin.brodsky@arm.com, dwmw@amazon.co.uk,
	shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com,
	yuzhao@google.com, baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com, joel.granados@kernel.org,
	richard.weiyang@gmail.com, geert+renesas@glider.be,
	tim.c.chen@linux.intel.com, linux@treblig.org,
	alexander.shishkin@linux.intel.com, lillian@star-ark.net,
	chenhuacai@kernel.org, francesco@valla.it,
	guoweikang.kernel@gmail.com, link@vivo.com, jpoimboe@kernel.org,
	masahiroy@kernel.org, brauner@kernel.org,
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com,
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org,
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v17 02/47] dept: implement DEPT(DEPendency Tracker)
Message-ID: <2025100255-tapestry-elite-31b0@gregkh>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-3-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002081247.51255-3-byungchul@sk.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2092F100004
X-Stat-Signature: tydk6zc44ypphr3i4i4nto95dsgjdn6e
X-Rspam-User: 
X-HE-Tag: 1759393540-192752
X-HE-Meta: U2FsdGVkX18WH9Nnxa9bC6NViZF6hiTCralzWWkNOIkF7vxX/Yp+piSeyDOqMw95SUucvM9x0tno+NCRbeKqsX8x1BlswJ9j8yQTX4rXwxf9i+ljM6ePjA8KsmKs7nCt0F3EOjKlJ3AEtsH9BSAGTQ+j6/pSoBaEQgA2p+USw5y4KmNXXqjrDFCqAs8f1pBYWfsT47hpdTIb6Spg1IVRJkxylFxPXjnseNbtiyKlyLQ88DSJY23ygRqOWmMLSdrjmHIipxp9us4/s32cn5gNU4Q+nTcoJU3f7/XrKE5R5GyCscxXifNSVHihoHmCynSuxZGtylqdnSVpZXXCNxEyyPBWQfN+gqKOs0vthutTX8qU7JYjk7OS7CTblIM9W+15e3TvPqex6O3t0tJ7HCI+QPGk6VY1x7AgLK3/V+9XHqj6irEenzGGn4eH4lpLwAEfS0yzAtT7EvtFxj/pEYfrG0BHKgG0yTjs7VZTnDXCI23BxRj33LoS3vVm1uAu0gM4PcgXv9z4BIMdc4hEUQE0oxrisRc3LnhHUgH2COtztCSxRCPv0eFE/SkDGRT1ie15v6GIWWBHBnQjQRcM2pki1pS4P7d/yDUPc8FeJBrAWyHhkpCX0Et4bwRQgoGyE04DNO7nw4948jZJ/thtP5ueM9NlppM0acjVd4TxJy9TWOZh0K817gZaHmQ+VQ5bHBgSJh8NYDR2ZKCMw7ZQNukV0zRme/P8WKhX68nCkKKGZXxvSG1Qra3uG9/BudLCjAkLStQlFIrjDnFSW11Q5SCXZ4lTYCzEhLygqLzZ6u1bwJuf54Qxb4DB5MYs9xeYJIoJtFamhRB2dYd6I3QpqDksNXvbevesisUOrVwO6Sbar0sW1RE8/9BOrKrGvvSNKJV+fCQxOGk3C1VSugbBST3R2YU6iEqDPCjRMm18wdA/vUQf0bA6YCAN7WN9AiYJ7hsSdkG8G4YZZu6MnAS73Fq
 rojJ2x6/
 B+dj/TrovU6FfTvH+9hmvL+lP2zmIvzG7xAr2AwbtxGHtlY7tRzzbfL9lOD5yJsu+vNLEQygttSo3A5xq0Yhys5+pC30I4ZBd0lfp7y1jCevgPJVghaSU6JnPLLujcVWvd/8yNLPEODCYE/hQd9oY61ZgJvv/cY7jJdSeHMw1GfhGgVUQZItH8VH5ktBSdAjVMfiFFt3BquiyR606UfXwnoExEgBfqFsEoLu1bgnp12yh7qtDjQIN9mDp2n2aO0BA50ztRby83Z366RoDqj189BjnH0oZ6JbFKA934HGpvcanOFtJDWazyxkrHQ/d5YpTU8kBcQw5KkWxtHHUSd51fWI+1+0PcHQUTuJ3pnlfdwK++5835/V6PDGKMF7PLegEeuoplpDfZ13jobo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> @@ -0,0 +1,446 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * DEPT(DEPendency Tracker) - runtime dependency tracker
> + *
> + * Started by Byungchul Park <max.byungchul.park@gmail.com>:
> + *
> + *  Copyright (c) 2020 LG Electronics, Inc., Byungchul Park
> + *  Copyright (c) 2024 SK hynix, Inc., Byungchul Park

Nit, it's now 2025 :)

thanks,

greg k-h

