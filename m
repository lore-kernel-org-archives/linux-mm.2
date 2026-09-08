Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B56C79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43FA6B0096; Tue,  8 Sep 2026 16:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1B246B0099; Tue,  8 Sep 2026 16:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE32E6B009B; Tue,  8 Sep 2026 16:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8556B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:23:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27177C0233
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:23:02 +0000 (UTC)
X-FDA: 85191719004.18.5AABA7D
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1F8864000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:22:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oTfIEuw9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of jannh@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TsLhOzf+D46xHpyx683mbvtqY0bc9njzNbabbHNEj0I=;
	b=FSHo4AabtQUfciDYOyBxmfdtiNpJKkYh4KUxr59nY4CdOT+EXDYuN0Wp2QRTQn2UMEAJly
	T54erZWccgkW1yMfXrIcPAZ3h+ur+4ysSrbm7CzvWieezzDBMj9yikdjceSPn9IjFGJ4i3
	yMhfY8JdPbmEqc7ZLXOIURYzAz+Jr0A=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788898980;
	b=cMRNkgp1V0yp/DYOZnFEdA0/RnXHfB/B1rzx1TFAy/eju8wuIM2f9O/vxOSUGgSu+Y+aFN
	MDt4jEk+pl6B71KvjYCxJXXCfn77V4IF1rKsSW/B+nMoHvzuYFWY3RDHV3uA5JVDwyU1HE
	6NNAgvC0xFKa6pHynNkMKPPGYChNofA=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oTfIEuw9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of jannh@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d6ff3aca07so1745ad.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 13:22:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788898979; cv=none;
        d=google.com; s=arc-20260327;
        b=bjUY8tRAC2f+XD+st93D9MqpGawodczq9eCeDuba1MigL8cybGYNe27EUIRZWONgos
         UEHBJYuLbsEPKHHhCQKZ1r4yYQlIq4Y1gRqedljgecGZWg1/68FSEr2vYJH2gFoQ8Kt+
         A+I65atgGmtQsFOhHYirrU8+WNNvyNfs1TC1JBoB2/+qDcrDzSbpXw6BN7Sr4y8JTFcv
         kGrgmeKMIYHDc/UNGiUYvJPTT878uSAjcP+IYjvQo6yuAWGc4VW1B4QtFHolFkS0K84h
         dxtmhtWV+nbdfw97q/9DRW2pYsx70vI1Oy4dJ/QoDP+fweorMZlyLwkhn+CnHMvQ7sr8
         ascA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TsLhOzf+D46xHpyx683mbvtqY0bc9njzNbabbHNEj0I=;
        fh=dlUTYNUhfOgE0AzDGFCRcNxTiAogLPgVcHMxqVCwS7Q=;
        b=cDtWi2jRgxOD1XPn8+0/lmwtAGvsFevdBa96erc4D133IigA0MEb2JI+hGc38ku03t
         lj0SwOAv5KlMRYpketzHBPw/BXY3XVPozcw97WuGhe83b+3oHdrZ8fpm9pZSeR4kvHwZ
         TSklQAfjIMKmTKcgHPzdxq3XOqaeEH0mW9ElofXpXcjUVKdVWTGbpiRUHLPGf+WXNvXo
         dFmduCmgGl+WLtg+yE1oR1UC+08vrSOFKl6/UHuyTVJIOLG+L9AoLCiWodINpWMQwWch
         Nts80Aum48KOSlp5zwACME0s5vI1Dk7ov9haQKxKIc9VQBQuMEzoTwJaRwmaVSgLCvsW
         wncw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788898979; x=1789503779; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TsLhOzf+D46xHpyx683mbvtqY0bc9njzNbabbHNEj0I=;
        b=oTfIEuw9rsJj7/nodOt/Idmv7trr9/n68oJNTP8A1ckxPGtmgytOqNaQ+BsDFwXxi+
         WMm9FYEZOaK0hUNI5p+ATYBjepBTgIwmzu5TPmmkWqI9tDuoEhc+PlQ4QLWJfMF9LgdT
         v5+MwtaJtHN9e06p6SGWMMse7Bn6eKdakJwu+RHYIYtnp4lmf/jsEYauKFI3+jctnKH6
         uGZ75ZspruIbt1vMXdEP4QSvClFdEOiTf0KsFHz+46NwTljhKNxv9RDx2z4Iwym5eXUs
         UcmWjU2As75GKqKBQcnB9KYKO8t1BLS0gxnRkSpKoqBu0u2ZKZ109jqink3oHblS80Yu
         TeAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788898979; x=1789503779;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TsLhOzf+D46xHpyx683mbvtqY0bc9njzNbabbHNEj0I=;
        b=I9l7en4JwFtWY5JOQHpyMTuatkAMaNAvgoVMJmM0C7KQ5UzQ4qd+AUI4NXg4inAl7K
         69F7qxcl1FjI/+RX2N95V5zh3d4Hnwgw+7zLqlg+21VTb4G5zEo2P68JLp2MP/AOnB4y
         IiDg6leYcE4kFWHpXmzP8x2LXSV603H7rT0GfYk0NZdClGRrNjmYH2PNQR8AUg5zzXXX
         NkI0ZcX5zgW/PYDTNolytNBqkGfB6vZRd3FH/vkucK8o8Ly2NIr0Uut3kZ1QrGHTF5fo
         s3vQXgzEWZ1F6JaYs5J3E5SzW++mUOHpwnmSv+r5P0rO+4fKhwpoPCxyXJug5/4H9XpB
         vWaQ==
X-Forwarded-Encrypted: i=1; AKwUvBzmvZjpLBMzGVQ8xgY7LaNVCNQLniEI1fpc/liW1n6ReUl3poewHDWXiszDIcvU9h7fiQgDsd8nnw==@kvack.org
X-Gm-Message-State: AFuF++lYH9msxKttJV3jmOI7DfXyKdX0u6wcS/+QyTw9JH0MqC5NR3lV
	CRdOVK2SkZZcffV+G0Y1BfMyz1BW9euyRHFtyNrUlcXa5mnMyThQRTiDZLDIJC8+hqwH6dxZoae
	1MkE6eeTQKa6G/qPm7bnLfjfHNlqw73DqEJ0gOXPV
X-Gm-Gg: AYBFou1+/UHd4eu19rrKIJnMHtE48hBXJne5JkcCK+mX2nrkB2AxuonJKNS6iY+A6gD
	aAk/fRKVQzP8lfNSklqc3LTLjGDZyttX/ccyAe113W9ANdi0EIeVUPI9YtpCZ5L5xmN9h4P0GWs
	r74ozBZvwDIRc+vumxykiwOt8BHjlzGsx+IN32brfM0i7mUZ0Kebmsp7mu3CJxvsi1agD9orBhg
	vRkvOvCLDWRdTACDN4yH4WYkS33+RQ1l5m+nMrB2cRqVx2b49Tt3YNJWP4c6N/jfYEK/zmO7eUg
	KIKAtlSxMYJjUz5XEmp74OvL4T4qkVBxF/gXjbBv/7iRv7pCc06o4dltiMM7Fl+wDE3+udTQBCV
	m3xntDp3Bp7gBQ3uGIbvYl2HpoiITbgGm
X-Received: by 2002:a17:903:fa4:b0:2d1:1d3d:97c3 with SMTP id
 d9443c01a7336-2dbfeccdf9bmr1436185ad.13.1788898978067; Tue, 08 Sep 2026
 13:22:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 8 Sep 2026 22:22:20 +0200
X-Gm-Features: AcwNN1W16jAho4HwK_fzY15wUA-qa4DGJ92-DrEx1Ojg_VFhiHj2JxDdZTxOKSI
Message-ID: <CAG48ez3Ucb8HyhjC1-fijFiYJsnWcTLYHvJjzMyU710mgegxnA@mail.gmail.com>
Subject: Re: [PATCH 11/39] selinux: reject writable opens of policy file, drop
 mmap shared/write check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, 
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, 
	linux-sound@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1F8864000C
X-Stat-Signature: cx5qrpphrgppx1qgbwjo3xiziup8yndf
X-HE-Tag: 1788898979-423171
X-HE-Meta: U2FsdGVkX1+G4vhb5JHXry76tjMrzisnXKcJZugAz+2x6bdejDdW7rIuGWkCyMN2HjDmyrLL9zyTIAX3LR2xmiVpSXq+XW4m7HtrKaSWDmthTucIuYeqUYrBMowD6boR2XFV8/QkEN1ulpIg56uRAOQnu2yhBrRLZUnAUGOEdFrvVCd2zaKrbCeMl0JNY14BqHAtjVGFIPwk7hDf+u2Kg2lSlKn8omv2hqwthhaRp314b7NvJ/cSJWTQbWXmkJXRXrf7uM+sIYAoB6M/UmgBx2rfTylERwBBRF1uc/9JzHDEnTNoUvZw4KHFsQo6W5MRE3063yawf+dN0H34aVRX+sihfWfd4ucZ64/oYtlm0P2Rx7RKL3STFFdWWgEao3YI5BMz22rEC05paO102GxZ5p8lcAK72o0maxbEqV/Rqpp2ljhBjXgTJK+Z1zVG7UX7eiNclP7czbQfTrDhQb5VY7vFQqBydsckpVyFvZuinSdprBvYlDZpu+br55RI09CMIc50KuS2mvdClrEG04NlUeUMi1JM7kASvbEtk6Mi0fUzaX4zlN3EhRoGl1afbE1sog4LiTkiA6OCplL1gcF3PhjWCVJRc2akuieBVJq9opWE4812TbJee2LhpyjOYb019jK9GjAPUtTvKLhO+WGeBixCa7brMVibfF6WYO/dLwjxUc/DY4MJFaZ3JseSvzbb84Is+rSuLrV2UbB1focs7V/LxcjraHs0a+kGucoPK+tHQJ16ULYTtinbMOKOAP9My9ZyFF0Vb04Dpz4iYUwUhFeWow1Z95Ue+YMZCodOLjZekKsHhqtWy6V3YLITdAbTjrQP3bKkgfWyBQUoVhn+ibnDaGWNBOnXpH5RJntoJtFi3xqDWuqJ4LvBhAEpSemoxppN/p39fhHtEgVCQy8ycFTMxyob889wAyPoZFC6627lXx+KyB6Di1XmbBYycPv1+fF6iHO8+rP83yjh0LE
 phKnX1gh
 gLnwE6Uj+qNlwn9ynKl8y13kpDdNLRfTk3pEZi8aZ5zkk8cPasVjKZT7labK8IQGPg4DtZ1YiXqD2MymmXbw8bOhYDC6UeVKfsi07WTZZ1F/r5ma6jwfPl3gQQ2DPJ1RhXWjVD/ccwh8z/H47l4Q2lhDxuOS2xEWs3UL23VgoVDXVJMaIhO4+tWmiQ/8AR6X5A0loiQ8uGZbqqG9NpNmpPYNW5Cpr2npl7ye8uHHddM87+U5hZcnftr9Y06KuHqjT8Ht7yDfKZQ6F3IVGLPJFqgnFClgLG3as3rewGT6aGPDOMfRPDct+4V5AMcFFG5Gwkb2y3gEMAiq5Vo6iSmSjD8aYVoFd9WMnfudUAvrSZDboypoabC4v1G399NpdTbbjl/WOjWyox92UkvDotlaggvAm8sqYdFvX4wIa/tD19xWBMe3mwAKLVfhwArOMiEmNVL9gbkfIkaQjHYdjQayYUpMYeUTzPKGodqom83tttqm+XiE9qpkzLUHCCASzcHOOFRlnKoHbcY9y9dXe5GhwQFf94hmNNS1Bmwm3WEUBQD8SeQjZAf/0O7rTacnvDFrBvtIprkHDK8NWulB3Y0LjiLBz3NYMFBGGDub2ztIoMyi8tWdylHE0wPOLAcoolWa1oHUc9O3r0MB9dZIj93viRFRpoY2vNV2S97OzrKvsCuZh3pUChJrjZ7c+Gzdxz10TndjP/KDDibxysbOJXnuOV4rx70nO4Q1A6cuPMECbNhHACY1DobbNP2a+wWRWPr+MYdWFEu5fQDQRg6Ku3xSmMPsBEGTo6hXjpRXOLDV5FGgATiSllEihJclGX4I6TEBAW81MZUG/+18uZxByq1JyG1ISQgSjWjN4UnPR0O+9cQgq3RRjkbvmWJk9mzukrt/Lp9iAp3bQ8s8SpxrDDLTEMroWv4WjsxZUUXyqBBtRNJ1r5bvYqo51EiW/WTRIgejIr07kxU8FJirJ/2pcRA4lbRntsJgB
 zDqfmi1Z
 e4OH9Bm1aYx+MwHdaYOpiRClFVQVlMw2JZbfMQOTi2rh0Z8isfjVjxjd/toqncd1OVKyzE4gITY3Fz3opyAZdPu15ijbSNxQfSPV7AlG83geulOdBUyHjfwLVR7Wvvw/YWX8Tq5PTGiPnjgD2qXN0f+KrCE5new1ouafpAS/KZ/rtBOI545bKdD5p72ztj0ibRZngoi1KYWc4R5JPTmNCfQoIeK1I0NWisR8L3N1URCF8SwIJbwG1ZlhWijcmgjZi0oeEfYGd5rrHjvFty5X7G4HiVO6N123vNMwDbO1gowVhWGyHjpdg8Uc/L5piN4eJ4T2EPtcXsPDrpdCewm/ennEiP4fhaeHxdrvfWJ3O6OvEhB3dMRbx+Q/kR1Ioc/nBAxY1qmomnGJYXWE8KEPTkDeR2MiR0NOxELtM4F+MvJqoD1zdHHecXPLpCg5gzJ4vLFs8d8SUjGviqnbiE2WM6CNN+4R5gGAZknaHPtTLh2M4cHQHCwXGmoadJxDP2YdhuzPbm0BsDFnOaSw4hebKKSOxzpaKyO6HDFy77O7Ivo0b56eHwpFJc9EgtVOaUKFBaDz9jVeCmi0dthNqWYWHD5auRwVDgTt0p0vltmyCxSFGqMwEWRia1jMO4GPaFOs2aymE1+C/hJXs4Kju2H5p1RBA7ZDQzkqPuUbJkfTw6FZcKzRsZYqoUUYmPuKal+hszyW3V/U2gmuaWqluELGmD476IVJ+UXoHFzvgzm/PKIGMOuz7/qFxHLpq1euP6YQd/1+AHuMu+DhFlIfm12KOVMQCfjh5l5XqC9OU76G3bH8njZ1s9FlkDakFA7I/fLYYobdbKysOslDM+aZi6/G1d/9ksHzchG6uestwgK/1DF2VI2XVP+vdT/SSEMRJbYDXRJIkh1Mw/a4rSXBqPo2AIM50m7LKDUA15W94lO++MeCNnued9kszI08SiGHs27Us8bJKTkQ7WjHs/LkHWW18X55IBLGz
 ituKf7Jl
 8Fayf2gwt07fEVK5ZY1nH+ZMLqSaQkdNA7VNTUuK619PCOgsMLnr3j9r6cbGYPuZNzW2Y+eATUZeKs2IRbB4yOUgUozZDj2UckamVCvz7VEDTh9DAPXUY+giimUk+iwSIPO8BZJC23yz/DhEgqe3zZA53/w3eSDInWqm00s008Vmir6YcL+49TQOFCo7GtruRZ52/5Wnny44CxNripQbLHmo+sl7Y6XEoCh+WqfjJsFG4qPdULRCAl0nIDfr0sq/JFrP1iqL9aG4xqw7EvSp2CEN9JX09OilNKESiQ6jLxPvP3Uw75Nm/JcK9KU8R3wM4xWQI1PZQfiB1kWN6mThxaMqdSSfsP/TmaJRKqy3JZGrwHFt1tpgjY9+pQmzNUEezmvGuLjrdFd4IGmwZanxUUfZErr6ak61kxVF9spcdVCMIbJQoLD+wvvxRXUU7BGI7JGp2C7YdJ/98i0VgayGBxK1cWbipQTZQ0SOIxP8y3uhUNrYzxHR0UtxCQoFPVcABr23c0Ex8XbP01BUBtUge6S+WLEmywGBTkcR+yJkdulJgSo0/LFFJR+rv3eGpp0fgEBrzATXNcWokE8HbdIBWc3f3cbq2Cbtg6XwTT46jxpD+vfaakewWTRklqiLdWLZhIsWIEurnL0BFmtvctvCR+MsRNJ+WwkgbgXbt9++7Kfy6m5ZLJM7JOE7sXQKn9b/lMFSc5gjjgAE+g/s2p8Q9VxiaKrNMdXh/L7eSZnSfAo2CFRECt/Klm17DD/PYzjYbjJxWb6FRStOgAsEO7RsMqbr83cLsPqqxfxZbJeEq6KYdDQwbtBz4NvEOr8ioyfPOBj6CZjANWQH4PuGkSZk6uM0g+mKt3a3sLtkaOrJBuBj0+PYqxkpn8lSQ3T0XiXH3rN4S8jdd5adH0v6CGhUM7BaFOKilS3KDLYRoC5xLur+L5+UOVv/33ZtBaZSh4z2TPTLLirD3xZ90Mkf8E9n1OurbyIKD
 OoLkB6iX
 LOe+hqTJC513PAd79sKdbBdr1I1oC0XkAwYL7fHuQsqgfbhYSCb6xwPt2kCw9fDitSV7O1GvvSiQOo8wQgJiJlC3QbT5vNo+ZFs+3+0a+XVfwy6wi7pVaZryMcXV2PAz2vFUJ5lNbCsNgStOTisl8ZB/vim2HLqYkQdNSypvUciiKv3nJ7JP/f9yx/RT/HSqsXh/ngSTcMQHH9CtSzCIPV8oPG+WQAmIjZSOLVc8D2CC2j3hE+K0PhNymHTUD/4sExKKd83NschJ+tdnjwFgbJu+xU2rJQpJ302FOxAoIQJMeTBji7zTVJx1H+Zr7+MeV8FzXseH8Dzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 10:07=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
> The policy file has no write method and is exposed read-only (S_IRUGO in
> selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, a=
s
> kernfs does.
>
> The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARE=
D
> check in sel_mmap_policy() cannot be reached. Remove it.

You should also be able to remove the sel_mmap_policy_ops.page_mkwrite
handler, which is only for shared-writable faults, right?

> This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that =
is
> neither a PFN map nor a mixed map, ahead of the core enforcing that only
> such mappings may do so.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Jann Horn <jannh@google.com>

