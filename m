Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD0FC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3940C6B008C; Thu, 24 Sep 2026 06:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31F096B0092; Thu, 24 Sep 2026 06:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE406B0093; Thu, 24 Sep 2026 06:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8E176B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:22:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BF5AC02D4
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:22:23 +0000 (UTC)
X-FDA: 85248266166.27.C4E1DE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 99FEA180007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:22:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bK5oWCb3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790245341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/kufuYs8c40R6+aOEF8XLRCigB/kXlHZjyeo0hfMBwU=;
	b=hR+BTVy3AwDvsTInBesGIx7VVEdrXD3/qtrG6Rc04jm+JjGMoNELCKU3Mq9Y7K5SOZdQU0
	M7OaUAXMHBfAyDGMkvPWayjcFRZ9duPYuR1fPK47T2N585UdXtVYO3XwSoq064Xe+5e+Vb
	a3VQkbxa9lR7eTUu7RZPQLHxu9dMw14=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bK5oWCb3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790245341;
	b=8Kgz7XkgThq/o0CN3pWwo6AaniRZ8qJwSFCOeHvvNONKqcTN0pbn2hxxhi1v0qaOliQR8n
	kl6Ivien1P0cZ7ZrfzOb1+8xV1UpL9jS17aZnJeoEfFDnBpsyubYRNO0Fokgo7UdJsgD3Y
	I9uYA7H+6lc9o66+xw2msKtqbup+MAU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80BB043D0C;
	Thu, 24 Sep 2026 10:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DC61F000FF;
	Thu, 24 Sep 2026 10:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790245340;
	bh=/kufuYs8c40R6+aOEF8XLRCigB/kXlHZjyeo0hfMBwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bK5oWCb3icJZsdzewTtJXUj2g8+OdPY584wvobmFjH9caA6XHPZPOxLC+ENgAYis7
	 FMWfW3kg0b1pKU0W7dpIcpkH9wgepYgd+Vs0xeodvPvhS2Z2eCR6zzIfxbc+F4vYn1
	 crr7Q7r6oewUJpom74jt6mX2gF6IAipPmH/f96jRZvGrtuVNztKClju5BP2uHo6kW6
	 734wktJAnH1jO9c7SkfE4BGx5XUqUo3nH1YffnP3W3u3mHAJ7/dU+/pRlEDaapTJOL
	 hEriCB9vp3MVrONwH7vOYcoqLNO15CHvH8FuBJLz8aDKeueJxc7YfwK4KfyNmRNl7E
	 8UCm0PUzGxdsg==
Date: Thu, 24 Sep 2026 11:21:49 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 24/40] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
Message-ID: <arT3K71l86fUVldk@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-24-4583d8a23bca@kernel.org>
 <93672B94-BB0C-4713-8F8A-3619D81DB7BB@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93672B94-BB0C-4713-8F8A-3619D81DB7BB@nvidia.com>
X-Stat-Signature: 4t7qatei1mkhaundabqciqbnrhf1otbx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 99FEA180007
X-HE-Tag: 1790245341-672968
X-HE-Meta: U2FsdGVkX1/d5ivpbcMxMXXPcw2aDnn2CTD9ckVGGlGmM0RXPraT1B6ImE0tEibAXQ1a6Uuq+zllSP6LwuoeA+UlS9Pc7eD5c/U/v55ipEoz1JvLkcnC2a4NGQdPxATiBnNpHjHGpuU/k1THOVnfceu28QMyyKanZRk2zcuI1FZidDerUVl6bhtSyVXqf9OJl001YaZSD3crcuLm0XTZtHsxI3WuOK/pxGCNyaCHXGb72CfisxwxeOycCA48p46FWs0Kr8gpPH8KSMAWAlvGLof7rbbDItsQC2yN/TjXhAYKo7JtXPUa3diaU31FAAtshkZxE8oTiuXdquOsIvNCynGIZs+WgFpr4+wTstUuaEkIRAiDTTOuW90nW56ZO23MRi5Oz1Qv4adCQQfZBYD0Oqnvvzu/UAOK1i/qD0JIxXKGdjYvQOFxJK8F78D1cPc+naoN+wAG85awbB6h6iixIjrp1RvnSF8aXe74/S9USX2NWf+s7anP+zs7FRCgHUW4nbB9hf5T09FD+h7sPkdffrdeSauYvvhkAhGBkfWguXtZjr1Lcuzc+iNJ5WV/QS7CvvbZJE7FS98o4/mxDEF9dppaV+f8RwxgN4+YXjuEAfBF51SziIJu/1cd861+FpYxqHDtO5mx31//2plXrdoCGiA1wxSpTQMeq+hIVEiDcIJ+R6LZqwSfh2GreYPDIq3lkG63vl5llJhGQIZ/U/gciWBUFVX2qABdlpDqlCjz6+1CGJ33Zz8RgegRY+ZO9rMqv8NuoOCIM4CgZ+uHh/zYLst6PnMZ7eNXL0pH97Wp3iz5b/CguXuBja3H8ky/qAJg+HIiuh4XFakRM8RwL8cN6AjpZVBSBMcnPN18HdT7PBuovjF89i+VnJnuDAcmCTdAXr1RrfURtPUmCHGmMjt72+QHLhfr+1+d4DAhbiRmP5MqakJUvtQY1nNErFy9QfbJA6wMl/OX+X3HYYbDk8J
 fcMrlDv0
 afR0+W6frX5FSvF5m7yp2oYqxG6t5sgKspVvl3cZLcazbFYrdtcy9SQug1Ux952EYepEn1HVGMP4VTy7tdk/3A+k0JsIhx9HQUqbDwiZZin+YZ5Eu6fgjS3B9nqgPlL1t/VK6wygVl5PZUsQXxmOKW8NEqMxRa7B8vsEFL4O7C/qH4lP55Hu/3YElyoRFGfMpdGjCmFIBl2f1bM9vJwJn7AWagv7S5mb3UGE4VxPHaWtKL7pTeRhhUZkpjY58Qa0Y/VBOtfqp74cfSLRuth2M99SjUatZiLRXPItvURLs3TM6Hr+8Rrp6R2e915CggDGhCkemHnczE2hP5Y6MkWTBLhMPsMEBOYuG8QTi7onG9edWYfq0+Y+LaD402DYqkKgwX9G8B9GcXOMcZ7ZBznrCh/5JxyVbiY60WFzPYNba69jOehVT8Fja0jKdoPFWd5K52UrOQHMJya796SLlanLVNALNolDfBhOO3U9cQrqmvps67lEdfbwYsWfRN4qZpY+vFxyaw6DX+3z108OcX2iE4Z/qp3P9qe2Yeupq86ApVPs82yzBFKaLax7WLbakzHgG+z9vAWmmAr94wBSVQ4iYhuLmVLH+vy74Yhg7WNCZSU6z4wgnb8qCPQK4pBYr59qxF1a7gElMf0OjhRhX/DZXrg1rJoHI6v3ehfPB3aQlJi5w8kVEH/ZiLDVJ3eWwPXGdvs1scbFyM12x4eezVds2dmR5ldkVZM0K2X7wCT84XHJUxsHp/r4FE7Lq/ttG86Scq0fORy3Xxzs49uDWi2KM8Ex0nLqUDXH+I3NxqaxPwyolS53Nmt4HjTPQrAJZz442vdg9b/XHFm2cfzOcv6XQDSISaDgI39H3P6z8KipXMJT2N4L6kGI6n9y4SkRMoFY2/oBvEQv8G45cY9Q/eaDC+yHU7b4MPsJH0GzGBGgDCWhAKdemJgHJpqiaIgL2tLAYs2C8NNjmi1qeqQXFZRne6uFAK/RA
 8utgmfYN
 Ifxp778OPmSqub6Gwey3kS7u73JAaloy7Tv2Vl0UDPQLJP3wBuM0y2dTybAi0PRbzUmj9w34mFOJrf0aJn6QoOmm0CfkrrUDPamT6eFyOyxKSGjNBLe3lgkNyS6EWj6LQJiyq4hV8RwaovYjviAF9dBEaqh2+BG1jGgiQ925IVaSEaJRa+mcY682T9l6PCcGVkEvrIO0KDKLjWhLtp9jehyt3ZLGTnbb1ae/jzsI/84cGZGlHGWd8NQqvGhewssEsK+RO9H2/VYwLDKar3J+EYes/nfVcDJ3Kz0SgZxEZGiREw9cAys0jDyaR4mHxwtAX0BSN3e6qxa19QKRhYVUzbSxCIokJfMNpwQNf7ui/RpgK4RwkdeaGfYiZk0XYeduSoPpD+2MEX0lB4Mb8KT7CNm5ZkG+qPE0pqSmKgcLUnmyz0BVRJ3J2RHWu8AW7Gjj3V6WS+i+DZWFFvEeqPEk80dGUelwBs+PwgDbDa/DtMD0d87TRKf0BEMh1BEFyW9Li65eri03ZNXe/eCWoqrc1c65TQP4jHZeBzzWBY/CRt3WbhAwYaMWmv/dsqeQXwRB7MMzM2Fys1xrD1PY4iS5aL02KIUr0aD+KAy9Diq+DKuAUfxHFU7AHIazAhwwnAuuZGCU9J61crfmr2cxzed/gRvYA5dVNmmghV4tjYelOoitsU2h9XBIYs8XpK868MAEPTyS79hCaVQ5azGwsN0rr/MkI2qNvFuTdHqTseF4vU1a8mDmNTS4ZPcIZ7KhLrrOHMk0CglT/OfKbr+0urDBVRLP3G+LvmFua9SHI3UfaKEOguQiYTiArIu8vcPArwaT7XvVFJsyjnsiTBijjxTFwPRUy6/sinDrCo+WUFo0leFBYA89uuS051/a42wBknCiEI81yKOF6TBbzKuiLPA7lpdUbzBwxwT8dQdGVflkvdHTyqpI74P9HQv7aobIm47ewPS5H+BOd9hkHW0fMYPGE05IvzRDL
 lUXM2TXC
 N0jFK0tMTFuvzHvkXsOSQw1GuzEvQjX9QEJxlyhjNMHJr2G8mjZRZzs4tbfmv1gQJsxO9o4inO5HeJoPzilXeYm8aM8gCnaZLRcnRMGH3WjiCX2sEkOaeg57ghqLp6+d920A3Zd1m7PrhIoLhFIlWrpMn00x9Drt6pY/+nCz6DJFfvf2TEx2xvAsxZfktzzKb+4YLIl32ZZgv60hWPhymufbTqnHSXmsc+0UYYSYa8aXARgGnFsGjnZ5QVSTGDqOZdDne9Z9xgdiCvHcctu1Sdnl0m0o1VMd9vLEoV74M1BVfXCmM1YhT+sVCvRJBTQTYf82pi8ayDamzg3skpghf8Mb0giT+k/Y0SCxe7gETZRwyYfuFr1v9r8k2+JRHb6+01kKq+RVP/R0swzoAqQdX2LKiUl65uTYOPxWrgTERMBJiz+yPvsN/IcU88FMMlRjtaGS8zx06Zpi+lKPXwAGkxalvpELrIZ/ksYQqTwL1EowJqqSNHIwTGaNLAY+nJ/vsIoxvw8lUmMK+Yc6+GJJ67rxFu3UhpVC8gadwgHJZ/eoAzR5Z0TSfsBVhKsCNKeCxeqzUlU5MH6B3UrgmwYR80Tz0c3Mme65vWWDWNDUouRZT/rVcG8u1jmbP+E7Q32DZfi6t42jQAtOBeK3ESLSExCwhllgheeYZldOIi7xfdb+V75NTPqKsrHrAyyGbVdIyxgvYoTAjgnLP+z2Jbkhcjt6+r0/F7Y32dQtIK/LylOZ9LPrxzfOsuRRvUMFirQ/3TddVYEzvbQrVA3Ou0C/vH5d3RVn4HWPxjj3pzuuZfWGkUnUOVFlZ+wXwXHrnE6GskTzivwk0QMeaGpnXSIaPZRFpZAfdArjoXGbTTOQZdJMjjQ42Xzol8wZVkxaOcVLdkhcRdqqy3ufk1ZY6uUYBz++9PK+3yjJtlOsEVBFcYDQai2k8AVQsWbPITlh1YAs5mFt7XD5iYtdb2NpL3yCv5Fxdvvsm
 7AJVXfpJ
 mE5yAqweYaFPlBaF6igYbTF+d6467vHmHQi+BYCUX0n6eOO0xiqjQmRizKy8xxE9UMWxEkxq+z/Fm7jCQQcpE+aYmC/pmrMUzt8ns5ekzo6ghMpnji2usHLQXE+/6H4Dn7ZvZH9qiGSoJhxwn26LvRcFzVgPW+Do7BwH1lxmiLIRflXqD6lQhjCHavTT2Y7hNg4G0furXkO18mQwkzoW87B87wqRCyXceBNi234LUhgDp1qZaAGzRufQofgneOT8NP3K9ihysNy7MTaipNAKN2wDzicHMHyD5rOvuNChVLDRg5PWMr+nDkIUurxYOSnBLcpulwsNFu9CTf6QnEA8S+YPHVUq1bO47Q03nISkF4EpomVU7Nz2F6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 04:06:14PM -0400, Zi Yan wrote:
> On 17 Sep 2026, at 12:22, Lorenzo Stoakes (ARM) wrote:
>
> > When performing mlock() or munlock() otherwise normal VMAs have VMA_IO_BIT
> > solely to fix a race with migration which might otherwise double-count
> > mlock VMAs.
> >
> > This is unnecessary - at the point of applying folio mlock state, whether
> > setting or clearing PG_mlocked, we know whether or not we are locking.
> >
> > Solve this in two ways - thread a boolean through the page table walk
> > indicating whether a lock or unlock is being performed, and run a locking
> > walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.
> >
> > This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always implies
> > VMA_LOCKED_BIT. These are also always cleared together.
> >
> > Then, update folio_add_lru_vma() and mlock_folio() to check only for
> > VMA_LOCKED_BIT, and update try_to_unmap_one() to check for VMA_LOCKED_MASK
> > instead.
> >
> > Also remove the useless invocation of allow_mlock_munlock() which simply
> > returns true if unlocking and instead rename it to allow_mlock() and only
> > call it when locking.
> >
> > Finally, with the other mlock abuse of VMA_IO_BIT addressed, update
> > mlock_vma_folio() and folio_add_lru_vma() to simply test for
> > VMA_LOCKED_BIT. munlock_vma_folio() tests VMA_LOCKED_MASK instead, as an
> > unmap racing with the locking walk must still munlock folios the walk has
> > already counted.
> >
> > While here, also replace some deprecated VMA flag predicates.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/folio.c    |  2 +-
> >  mm/internal.h | 10 +++++++---
> >  mm/mlock.c    | 51 +++++++++++++++++++--------------------------------
> >  mm/rmap.c     |  4 +++-
> >  4 files changed, 30 insertions(+), 37 deletions(-)
> >
> > diff --git a/mm/folio.c b/mm/folio.c
> > index 47a437e0f7fd..35e242b48870 100644
> > --- a/mm/folio.c
> > +++ b/mm/folio.c
> > @@ -505,7 +505,7 @@ void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma)
> >  {
> >  	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
> >
> > -	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
> > +	if (vma_test(vma, VMA_LOCKED_BIT))
>
> I think it is worth documenting VMA_LOCKONFAULT_BIT alone means mlock in
> progress, like you did in munlock_vma_folio(). Just to keep the protocol
> explicit for all the readers.

Well I'm not sure it's necessary here honestly, because this never checked
VMA_LOCKED_MASK anyway, and VMA_LOCKONFAULT_BIT never made a difference.

So the meaning of VMA_LOCKED_BIT here is strictly 'is it locked' and it's
correctly handled.

And I fear that it becomes whack-a-mole - the neat thing about this change is
that you no longer have to special case the stupid VM_SPECIAL thing, and can in
fact do the 'normal' thing of _just checking_ VMA_LOCKED_BIT :)

So I think it's better not to.

>
> >  		mlock_new_folio(folio);
> >  	else
> >  		folio_add_lru(folio);
> > diff --git a/mm/internal.h b/mm/internal.h
> > index b2c6c9435021..84aa3e6c8bac 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -971,8 +971,7 @@ void mlock_folio(struct folio *folio);
> >  static inline void mlock_vma_folio(struct folio *folio,
> >  				struct vm_area_struct *vma)
> >  {
> > -	/* The VM_IO check prevents migration from double-counting during mlock. */
> > -	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
> > +	if (vma_test(vma, VMA_LOCKED_BIT))
>
> Ditto.

Similar reasoning to above.

>
> >  		mlock_folio(folio);
> >  }
> >
> > @@ -989,7 +988,12 @@ static inline void munlock_vma_folio(struct folio *folio,
> >  	 * always munlock the folio and page reclaim will correct it
> >  	 * if it's wrong.
> >  	 */
> > -	if (unlikely(vma->vm_flags & VM_LOCKED))
> > +	/*
> > +	 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
> > +	 * mlock_vma_pages_range(). An unmap racing with the walk must still
> > +	 * munlock folios the walk has already counted.
> > +	 */

Here it's worth mentioning, as it's specifically relying on the new
behaviour. Although it's neatly using the VMA_LOCKED_MASK to handle both the
locked case and the 'being locked' case :)

> > +	if (unlikely(vma_test_any_mask(vma, VMA_LOCKED_MASK)))
> >  		munlock_folio(folio);
> >  }
> >
>
> Why I am commenting in the middle of the series? Because I am taking
> a quiz given by LLM based on this series to get myself enough background
> knowledge to review this series. This mlock part came up at part E
> and I only have part F left before I can do the full review. :)

Thanks! :) I really appreciate you taking the time to look at this! Sorry it's
so large.

I held this series back from last cycle to help with review load, then spent
some time fixing various AI-discovered things, and all the patches are necessary
(well for the most part) to get where the series needs to go.

I think the change is worth it though!

>
> Best Regards,
> Yan, Zi

--
Cheers, Lorenzo

