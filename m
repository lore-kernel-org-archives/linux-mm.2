Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33FFBC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07F6A6B00B7; Fri, 10 Jul 2026 16:25:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02FE06B00B9; Fri, 10 Jul 2026 16:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A4E6B00BA; Fri, 10 Jul 2026 16:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3B7A6B00B7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:25:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 571BB40479
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:25:17 +0000 (UTC)
X-FDA: 84973996674.02.AAD5CC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9C925A0007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:25:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uq5XeaJL;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u31X8RgcNJCyJqpmVcGG42bB96q2xKa4t0yZEgilb4Q=;
	b=jAzfu1EnAJ3H1Bw7r55cvaiGTgur1Uabl39YGs0xsLkscl9gmD7XgzEsHzzy421WAq+GYd
	owh40HrOEikKOBhIDDtGUqoTP3MSbVOMoQnswV3pcXu+As6lTqH3pq79IslJZDKe1W27yu
	Jj6BPRU3lZjq4TkLJTRTWnDfLHtcg0E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uq5XeaJL;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715115;
	b=38xNI+OF8+FFHsw8FGVq7/8CCNHk5GlUF6pqZGH50NfgkGTBjbsNoE3ZPNuACvoK9MoaJ9
	YXWH6pR1x+mbODmqzITI+n56euYjZffRJURsiXj8IRnj2iZH4RWmLFbAHi7gv4TPPgzVVG
	SLYFDANC0JEIn4qz1wKdM0VhEYJiemQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3984960052;
	Fri, 10 Jul 2026 20:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A631F000E9;
	Fri, 10 Jul 2026 20:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715114;
	bh=u31X8RgcNJCyJqpmVcGG42bB96q2xKa4t0yZEgilb4Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Uq5XeaJLHBwnumgunwSh7i/Hd9s2U4FpSqq+xiCRQj/osFxm3pnId7Z+XBEDS3gd5
	 3ypjSBQFS9TyAD7v3Npi5UX7YFEZ458imtDcFa4Jt+/44KEYaoKfRZj/LIELwe4B3N
	 BOrvvcUQomx6n+P2PXoPHUdmjZD819pWQZfoLvVZ13eY4EhKbys8SuV58kuIBHCZud
	 WHdNwrMicwK+JmxVbSAg20mFS0W2LrXaI8T5/dVwSsGHKaVzO6nHs/m6KaLL4Dh2ZF
	 5aRdp9q0gLj2o0/nafDk7JsU+Tjvmb6YGzpPig2SNbqXtBxRENUBxdxe9JxkHGhwYk
	 GDuhKXBcZZhJQ==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:01 +0100
Subject: [PATCH v2 20/33] mm/vma: remove duplicative vma_pgoff_offset()
 helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-20-2a5aa403d977@kernel.org>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
 Simon Schuster <schuster.simon@siemens-energy.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, 
 Peter Xu <peterx@redhat.com>, Kees Cook <kees@kernel.org>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Ian Abbott <abbotti@mev.co.uk>, 
 H Hartley Sweeten <hsweeten@visionengravers.com>, 
 Lucas Stach <l.stach@pengutronix.de>, 
 Christian Gmeiner <christian.gmeiner@gmail.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Mikko Perttunen <mperttunen@nvidia.com>, 
 Jonathan Hunter <jonathanh@nvidia.com>, 
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, 
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <skolothumtho@nvidia.com>, 
 Kevin Tian <kevin.tian@intel.com>, Ankit Agrawal <ankita@nvidia.com>, 
 Alex Williamson <alex@shazbot.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, 
 iommu@lists.linux.dev, kasan-dev@googlegroups.com, 
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2240; i=ljs@kernel.org;
 h=from:subject:message-id; bh=IR92Sj2wx3lyPljFS7ckov7loj2/kkvP36FNDNTtRqM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg22Kr16aZZ41tS1Gwr7/Wmclt6HgYvFlnTotLDvqr
 73SCjTuKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwEQighkZVs965fbQTWFX+DNP
 1f2brm+ySlkTMP3ewjxpTluDV9P+rGJkuFX/VPbDSc7A/gaOpucV8Yw2y5tFqpOnT3nkeYtrxn9
 GJgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: dsinkgprpmtiaophtzzuw18fdfngs9nt
X-Rspamd-Queue-Id: 9C925A0007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783715115-795470
X-HE-Meta: U2FsdGVkX19L5dOIA4d2F96zRFke9viLVfjhuPiaCTZgj1M9bB1XfZ6hcB03CI7mg9bFLKaohqmtNXgPanyOBh2DhU3gDdNZpK0eaJEaWI3GahOyaswr1ysRmJmYPgU7K9/1NYkjE7/kWKaqDl8vOW39kMaEN2wFLDZC16gPEWmr/e7h6BddNwH0ssQn/pcWRxPYMQ01Kaq6eDMEOH6pmc/H2U7YJhy7xZIjMx7q0oVmc22PzWX5NcdlMORf6/aq6XUf1zIMq4a7u3gamu34Wl44p+GoPW53Xmizye7UIEqUmDV4QYwpZAN43I/s8BdjTsg65Tl1NDhSb8aWwVdDFFJcLasqN4IVC+6gTWdGOOY/flQU1QFlQ4ty1oxkZvyezL6x00uAqWayn7Tr6QIjQ+RrrqKFK3cqotCS61VJbCqE4yEh1GQy73FqU8L9g1FSSQ/6OuNgX7qhj8zt75zSnON007aACr5qjTP15NKVJbha1YXOouaIzGBI83z6q8g8D0+qb6M7w/MyRBgZVtuCLNkrkQoe8nUiKLSOnOdaVq773JJEks6CxyBABUMxnFPZMc3zesstxz4JKiXg8S3p8KX9yb7tIOGoqilCwavzCI9Vsr82va7H24KjAizfSA25qDIcP8ywiPe+kUCIEZngi9AlHeBUMpAviyeTZR4Ajf06QnOO2/LAyrX/CZqaSEsMuX6cUIY+3D9EpjAzhjNKCJUgIQLOp1Sg0ifAlnAkFlqgBPQ0W7Depl9KX8Nynkein0XE4JDs88OB81vCjW3qxk9fLzjqB4FiKgB6Ut1EDo8qYUxDKM09LYADrOHvEzfRrnKTrQ1LERAEnFTjt+6HiMNcG8ywQAaJHFSGiGg6gk2f22aUd58VmZriU2al4Suo55IjD0oFKfc2n3lMGQWnIPKgMZ36O0TkwBh9FUFrRgQoks2gzHFvisdmriV9FzUik40tA7zU3GyKIHcmquq
 vIG0m1RE
 hvCmzRkxMizPAJmJwifpWcrWMn4fgApGO1iE+NMIWMQbqYh5pcvnefMKD45j9NpUsjLNs/UdDRF8FsU8aVDamNxTvzudliVoL4xgM+oDtEJSALo/MiglkwjR4A8N1XsBNj1qX9YxYUR3wz4AMGeZeKF4kZBIcs1nxW8/dPFdYZC7Tb37g9qvOVjOP3N8Rg3ZndXX/O3ux9IxWKlLgaz2UXNr5+njrEHHt7xKEQi4aodLnulo5aw7xPStu8PETgqY/wZjtIr/2xrhNFsPprRfYjJJ50ABJ54jzeoFchj4tYthcuKl7SRKFMNo7Eketk3PZ1TpHN5tIgqFMEATSf9cjnIxvOkQ9u5P1qWjhFst2F/7TAqIQr+5pIBRoMQhMXQsVho/zsHYnItzD3R4mqCTUrHxzp1iHmeY6xQlZLTJgpFa66Gh175P7wNoXXBqrMIfpqyeYBmZ/1Ej3rbxVt9VNrWYf46OCWBwBdjRw22goeVjwnkYBgYNJAm20gP5JW8T/fLJNou4vWhUBN1a9FY4iXOUjY+/ai9Zfx5N9DEXK6iRQfeDuoUxFrbEUs+LKLvjdxZk21T0pt8wCOZcPCgzH9/f4QxNYXzgXsdppA48HqaBw7J73FODd0i22HVqqJrW2b42z1UFJ5wAXWLi5QqYXq7Ff77CsBGxtl/jclgj2/tdQYPcWOpD/YN2clC8P0Yabdded2cukcf9g1kPDMBn5nADqoKZtKgt9GV1iBy4pfMFf8+Ay/cO6+c+3Be82QZWL/ASjw7dkGG1VQVYrGk3IV0I11FBCa5tbjm5gJ574QTLAsU4+XCLFMQGH2Aqp/Mke2ja2E2PpxE0E9eJBDCYfrZWap81TYUkt8eYknqEDJcxl7yOi+GUx2JOufRuay9R4Hk4WxAvhsxH8xPaOsKyP3mFQijbEhc+MMTUD+V1Aat6g3Iwjs2r2geavxgToLz74NIey3Zu2H6ZKSJbpYcA6WFUQST8O
 UAvNgt2s
 S70jTtDMGx5FoRL/CpqMGVsqnWd/x7fCXvjzHyKCN9cuZsStL7npPMUwbL6bdsl/JJADlXWYz7kBkWhIdN/RDg9lUsB9G5uVNm6DSCZiBE67a02KeUQomeXMp4zOe3libqHZ28gP+mfTxpuV0eSDe+/suJ31crK93lcv6bFeTB+B22IGkb7NM5EKUc+C4zgooD9lnt5WtkGTtzJHm/jqcbInyqLx2HBZXjS7U7wU6uMnndCcuh/3rxdStgoupKSUqtTwTij6wk4UYtHoF5jjUVl4CgN7+ieDzwIAxYBhePrvG2CWnxIOjWj4b99ugqal4/xzqZ10TlvQ0TeKSOk9SHeI4Zetm156vjIjc2HhiSbQaeM63T2XkPVSxaHKKCQd6e0+cZIXSoOysaR5Z3xxmXqvlPiWLe7lxVNLCf0IUzMGDfEd/4Ix4dTi2jkGJVx1uRRjSewwi2yprFHV3qzXL7nDIO70JQrhBIyVe/j3lVkFwkjq6ffKzvMgXBPeIf8wHhe2NCBuVghjJMEZsBN6jRgnw29Us6TWaKovlSyxCxxVnDlevEZ/TvKAEvO+reItM16X1nVvD0SzSeadyIcK4kYDG5duSSNEDJ3CgjB+Z8s6DS+bph8FQ3Yadi3y8B82IaHE0Xp04mF6SvNjFaNOr4CFK9wIG1TAumd3kH94x248mamO7lo6sEGKGC/O07oX2sdaV5m4qwg8sZFofRbJuIryPcjAWHlszYRUMXTbLtYEQu/72KF4A9lfwRRb28Tg/gRDzYRPHJ8jzZxDzurmuOELbAEKwpYDAPpRfD2IKjyCmL97pffBZfTFl4zccVwnnFxi1kUoelPuBr37UcOYWE2rQZOmbauG4/p9EoTwrc81GBZ92DqQ6EsyRqu2N2E1m0hX32kaMvwIMjqBR+l0C8+xGb9Ry8YPue3CIwN4t38xSuzfntZiAt1pi8A1KFJH1za9lcXj4UFzKlL3sXk2kT1cN7N9a
 q7G9ctiC
 NCS/8xE3hQwg+jZaMv746fAYRscFRyfGLTbV6PEiJNV5jSU8UdFQPZaGDYGnzCUY9sSHRi7Z5R8pC5z3qjPQeW5u6Pr8ni78rX4uLuapeXl1rImYJ00aKrYHToxQgrNY0dgtt6x+YZHko1gNOFcg1v+lnHqeVd2QcXPmcJ2uJzbXRwogE3tya0ibuAKB0zCvvBj5RpyFirASe/zB0t05CVKd/oKeixY0vhkzzxRixXqKs80N6F9+NMcV5Mfwm969wtpe0gWMSxpPTBR+RN/npfDrrtVSvjm4qYHXwHedxRNi8F06RKMHBsR0q59UHdrbIFXAeF+wqUyhdGVMpcNNclQhCEMGRqDiCok4UXqxOwo4Ujstosirvqdrxpb4LUh7Za/ElOseA/Dlimnb6b+pn6jiuqBxBk85FfpFhbaUOFfE49GdiwTFDigwmaTHnRThZGy5sXprm1bQG6Ydmrs3bJXJpDl1Ae+c/LcnQ0eYZxqMo7cY4bBrJOJCgqMpJEWHUAr5KwjseeAn4AqiF4yUmHJkwaqljuBTmXS4QxMhfc5DWX9rYno8kjImrmNTU+xHEQOWtG8zD4utqiGbb8ufhQdAuxupzsA82BM7ktCvbgPS7s1mzavP3QXUTDXBCwnpIGdyE7VLblwJg5BNNTwzeDFNfSt+azx3pxE+b1KY2O62m/iLTS7f+hL9Fw9Os80U/As4OpJ2s+6HXEGS8c/M2e6s2z1a2gFb8RN4Qzs3QA4y/OjWTQfqpKskNTC2xDx1SbSq9aHJmOVZ0LdzGW5bp3uFjbqBkwIU809rs5265ClNJIEpOBfpuU+acGOttZzVn3FXcX19ve8FmfhnMwqquyFnJAqthS0XR78UDa69E0ugxPBaU46UNU/AkjDajqoHlfcyNw0iOThS87RbDyWwwFpC4BpjRDm+1KDMCEaJVhMYHBstJJ5COJQr+gMJJn6rCoulyiUrdni1oLhcFxGNLFTqJJ1pW
 mDuYyEqP
 vlidOb2qYboiwRIwyymP4z8ybKOsbcIScavjoGe+GaMeRxQVbj0NQp0S54LWEjEdb6+Eh6VebJ6Zi3EfOVM4Lm9r4oGRfW9NelDGi69UfUp3P+2em1idUT/oSUBdRipX6d2G8PifiEuKv/MgBbThUs/FAfxd0QeVBWf6pVI87QFQOXifswf7aaOBpjXujyabB2t6pU5AUCQOBwyqrgpeRlPBZl8Hrmh9O2c/JtamcKWft2N8hmdeBf1Dex8G+0BHESzxAHujr1cUwiSlUVtBJWoK4kj/I3+Ba1DctkY2JPwlyuOclMWBBl8ml7B2PbHvGOrDj5b8/bkwpCZL4OO2tCppCng/Qzyi0ZWr2eSJWLpDESZZGNYFs7M7orMwT2m2iJtAXK6Uq1ouQ5DrhFOB19RWGpFyMEtxiiK/xyQkeCJMD/OXN+tkcrXSJHuIvmLq3PhWE/1jfcUYf4W4zDOyEzMxkrZ5O5L060CGlN8OjImLJql0R5wSIjr6wcYAKbP427rZFAG0QGjZvfoRJ9WIT8hJyqxw6gdy9h13LbFm1NLgLn2c9W2DkK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is doing what linear_page_index() does, so eliminate it and replace it
with linear_page_index().

Update the VMA userland tests to reflect this change.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.h                        |  9 +--------
 tools/testing/vma/include/dup.h | 16 ++++++++++++++++
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/mm/vma.h b/mm/vma.h
index 527716c8739d..2342516ce00e 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -247,13 +247,6 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
 	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
 }
 
-/* Assumes addr >= vma->vm_start. */
-static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
-				       unsigned long addr)
-{
-	return vma->vm_pgoff + PHYS_PFN(addr - vma->vm_start);
-}
-
 #define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
 	struct vma_merge_struct name = {				\
 		.mm = mm_,						\
@@ -275,7 +268,7 @@ static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
 		.start = start_,				\
 		.end = end_,					\
 		.vm_flags = vma_->vm_flags,			\
-		.pgoff = vma_pgoff_offset(vma_, start_),	\
+		.pgoff = linear_page_index(vma_, start_),	\
 		.file = vma_->vm_file,				\
 		.anon_vma = vma_->anon_vma,			\
 		.policy = vma_policy(vma_),			\
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 535747d7fee4..7ed165c8d9bc 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1548,3 +1548,19 @@ static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
 
 	return vm_get_page_prot(vm_flags);
 }
+
+static inline pgoff_t linear_page_delta(const struct vm_area_struct *vma,
+					const unsigned long address)
+{
+	return (address - vma->vm_start) >> PAGE_SHIFT;
+}
+
+static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
+					const unsigned long address)
+{
+	pgoff_t pgoff;
+
+	pgoff = linear_page_delta(vma, address);
+	pgoff += vma_start_pgoff(vma);
+	return pgoff;
+}

-- 
2.55.0


