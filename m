Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF97CC982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:31:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45356B0088; Fri, 18 Sep 2026 16:31:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D716B0093; Fri, 18 Sep 2026 16:31:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0AD66B0095; Fri, 18 Sep 2026 16:31:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7960D6B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:31:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 142E71207EA
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:31:41 +0000 (UTC)
X-FDA: 85228028802.11.74B7EBA
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 209E620003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:31:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LIsTiHlx;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789763499;
	b=JWyXSlavOeN6w46Y4IKrXWA7my/L1xhGEi2sd3dY4JbqHPAJ1FYO6qaDvrAyCbugNabkFZ
	7Sq0Rw4SLY0Jtmel5nTPcKmcEdMW1O/HIHCzsR32U8yKnXwozKgyuaPAWoKHom6aC+4Zod
	AYRHLvcF+ZbAg3OJp5LHhgbXQFqRIOI=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LIsTiHlx;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789763499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rakr0DVeS6w19WPN+xiAqZEbcFGWWdpHaQBH8HXSGgc=;
	b=CInUlOxDZAF39URjAUO9IzLDS+hb2EyS0IP5JKeiev/AS900s16nhhnwruoAz0HetN+1hs
	z4/GPpeF/1OloinVePe37Ju88rqhrh+3OeeZRmZDfmTHJhMsg8NntSbF0IigZ2pupe/IIL
	yKwqH5VnJA8w1ukjTEdVWeUB8On3OBE=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-530f6bcc301so55101cf.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:31:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789763498; cv=none;
        d=google.com; s=arc-20260327;
        b=bDjaVbwDylLYpSXnvPmCfkm6nYlNrtKyVYQjgDilaQwMm/Qc4dh3C+W7SNPM+6N7YV
         wNrHJW0PFtu07V1MRncoWosu4XVtoHGi50YV1DG59WbyTaYJUHMUtibbBWn/ZG0q/vzY
         mNHe7hMCauXINRhTCyNebnhvIDrRllerATmVx24dmluGHrIUYIJdxEBf5JJW1yzQ7XoV
         oCNA+p6KihUBuZ5WkdS0lrcbo0hk0318YfCjVWW3tTlHX2KrCTII2TQidhCP4PCnqR5B
         mden71z10w5BREZKy+wguyHm/WYRFXHOgqmPSyKmXS8efTj1Kz2sjb3W+yzrX+eZe2uN
         GTTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rakr0DVeS6w19WPN+xiAqZEbcFGWWdpHaQBH8HXSGgc=;
        fh=bdy1BQKXhYVbfm/XV3K4p91xavOraXxURQsOaVBZoKI=;
        b=fUc46ThEULNk9Seq7Xqq941cZ5rGfaAYSObCfRhyqotBlRpkubRf4axF7Qj/8uNCK0
         O2diNKdp1f9Eq6M3sHyOLgxXpw/ZROkRbDXi/aT9HRjoSKRBSit2aXBlTaWndcaipLNO
         kdLM784ERJ6c7P1gwMNvBklGd/kcyD4CY577/HeSGnsyYjblh3Xj4u/TvgC1w/j+pqiz
         oVq4xD5UvVwmCQEIYXZ1BVZjWdtVP9AhRss37NFPOq7WRPeZc90RvXGbcIV0/n2m9pRI
         oq93HmNNPXxhcbh739d4CFwbJlLY+8FyoATTI0KBvjxJSNkDvYSwvkrKd1bpHSw8WYUi
         ANzQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789763498; x=1790368298; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rakr0DVeS6w19WPN+xiAqZEbcFGWWdpHaQBH8HXSGgc=;
        b=LIsTiHlxB3/+cfSPB94PxYaG7XwyNrUkrM9SqZ3v8cNG/AvloDuM8BkMGcRtv2yKhG
         2xwdo+/BYsieCD+v+LrdTYvN8x+CBpqkG46SMxubLSrVs2PYHOIMYQyujsIjS01vziNi
         Jr4rxh2tzCXgAg56y/I9dPmclZzGs4068e7cHXlP6zgnSpQwcFK5zWPDm4anMukJQvf3
         dcsZ5e+tFhJ/gHqeiswTosuxVf4NT+bmAop/s69KtErm3F42QkdY53EnfgSjVgVykfxT
         WNYZ1DyPeC/IVu+smck1hnoNpTR4EMzx61jn59PzU2nWkOYTMzPix/9uE2weUhwSaBxj
         wS9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789763498; x=1790368298;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rakr0DVeS6w19WPN+xiAqZEbcFGWWdpHaQBH8HXSGgc=;
        b=KQvw1aFMoF5nSe1Z+N0/0tfihr8+1cktsuNixzDdP4Ywsq2DqJk065pyM/Fw2Itz40
         UBnfMLXG1+0fQ/CgYUUmKIYyUOlhbUOIBU2NPxTwWPib4G1l/TCiTPgo9dsobNHv/6CC
         nBMlqzxlNeHK4lmFj9gNobBCKleFPb+yJ7S8ujv/F2RN+Volzm6M/B8+ypkUmlzeaK8K
         UWdIQDLwFzC6OBSZjwwAUJmypqEYugPwnoTPwNQf/UqSSPrIdb+XVJd1dVrUw0CAd7p1
         BrWSDdqr61Q80X4tTyJ+MaMr0Ax77UkZoF7/1sOFhCuPNwfxadKb0jQJsOgA2+slkRp+
         8JNg==
X-Forwarded-Encrypted: i=1; AKwUvBx03TDwtHypNO0V2Ihq15+8lXYVl3pJbST8O7qghMnMOqOXlAjjUf02AgObcl368Lf2uoHQjWH5kg==@kvack.org
X-Gm-Message-State: AFuF++l3IkMBcI08aj54ZlIONeqeXw0m34+sFYnSiF/MbYbKkL77pC+8
	40hF1dZbrTxsXrAe0HY4hqI+9d9hJgfFFSJfodEqobltthbeWW0/Nactrd0cz5dtb5VyH8ws+o3
	j6CXvKvPHSsdAhSzCtHRjO1xU0w0iUixTEXSv6fwG
X-Gm-Gg: AYBFou05JxkUo0542QMAiyiKfJl9+k9mHeDwmbOUtms9LtnNd3ruDHEkFRwnokc8zew
	QnIsacf4PQk98MiRoHKzNJOsogbMz7Wby01cBVK0Wcln41dz6+wWO9DTfo4xfal56EFcq67nRm2
	0yHf6+pWa/EFDpbgY8tgsHWwlMQlWEm4AUN42OHjluRyJqnG0NQyngJDEepMJT6GS6Pk9A4JTqw
	lChdSf6Lc5+M7S2fB2zmakVz5mL5986xcxqrsntdDg65X8ff/vk1GT3Z6l0BtoeTojeVwpXPa4c
	Kv/dzmT00KNCx3rrzG2bmSFJGyG/Tjfj7j/wuTm0C5BDtUXeknVRZw==
X-Received: by 2002:ac8:5d08:0:b0:530:2f98:cebb with SMTP id
 d75a77b69052e-532b099561dmr605641cf.11.1789763497212; Fri, 18 Sep 2026
 13:31:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914180811.057cba8fcc48d6e0b53a2683@linux-foundation.org> <0b064fe6-ddb3-4f26-a1f2-2e9dd88d590f@kernel.org>
In-Reply-To: <0b064fe6-ddb3-4f26-a1f2-2e9dd88d590f@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 18 Sep 2026 13:31:24 -0700
X-Gm-Features: AcwNN1VqLTR47MatnNlBWbpWA8EMmoQNGykspJvqoxdaovPnF0EYfRCWZF-8zh0
Message-ID: <CAJuCfpFBichJH4OcmSHTb1rOuQBT6k5pXeua9_KgpWjDBKvsYw@mail.gmail.com>
Subject: Re: [PATCH v2 00/40] mm: make VMA flag semantics explicit, eliminate VM_SPECIAL
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
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
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, 
	selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 209E620003
X-Stat-Signature: ro6o98ziatanw94ftgfe4sczf4wqxgg9
X-HE-Tag: 1789763498-698487
X-HE-Meta: U2FsdGVkX19O5J7cv1PjkIQoa5+Qt8nRSdiG9CojtdmX2y/bIr0++2L4FnsYbONBwdwe1Dap4GY2b44CVGpH6yQ+1/P06Ayg8drSSIAEuTh+poQbOWb2g7Y6OwLaN1+C/rzGeClmvwFzthakroLsW9lPvNhKXFedMomiA3pZD9TMwsefZJd6WiGGQe0T7Krkcmlh9XH+S6I4FXhoJJU13bqI1IrzgF3EF5Yj0CoGtTPK/7Yh51z1Y/U4hB9hhQZwcMzD9naqvVQBblc/yTi49s761DJB3hipkUn6trf7rd6F3PHqZrH2HzZDzK8YTghNw9tC78eZGtrct4OASFW3D2Ryda20CEnlytYmV3mwymSTOAdUv2G06CdrZK8V9IJoutumrhSr8+qowhk44jmtHUpzuYmyKyRG3RBSa2aT9QdxY4gPNILev1X8+MiBxQMbDxbUbc00KJOcJvV9h2T2+ATKgNGYUcI4ePcudav2o8gUdIRM1MerbGk2omgRK0oShjalRLV2Hy5klJmmN2l9WBI7d6zGGJyAhANbbM0KeSWSCwllBaur8eqj/kU/BRrWU+JE98dsCk28hz3exMUkdXRVi7CF8hSLhL4L9AL3nxAhdVk0SNulti3uAPWAlDqnmwXaPeRcH9lq7ReuZzoVi8JNZtOKzNddxolsqGSn7GgbNvJua79MTalyMXOn8yTGAHLXpqJWxdbo5wJngkhi2NCZ/vmB/8ljc1T09swyg2mvVLzsbGtgZLGd0/7ZevMMd09oW2s6jxtB1MeARJ+jZ9e4r4r1i3NXLr1jdYDUzuNSsJyJTWtTGZUajW7AeRwrw/sQprybaZSyvj8McRT9qeScI7KuAd2JcFUMjJctpq455IXMS0N2ZOCkqVyA8CZmQVDnC0sr1/tZt6+Up5klpUbpKAK5bu4LikCGotVOaQxHdUNkNCCDZUBRt9kwvZGtfewZ792Et/CpeFPbMb4
 bgdLF1xa
 t65PJ96Gze5URDcdOc4FreAA/DyGgEGxBONgYyDP0LxfjlcN8Q+TXmK0G6Aub30YsOdh3iIgiup1EKpHd5Of4wLtr7BThwz5oSO6IRD9EZc0d+dN2m4GbcgWTdG1X0P1jFs2wNwCX5Ht7sYh2pFXmIthMpZb5a3C/VUePTQ1cYodrmwW4sXx7IjtkFc6pJEz/ClRzx3qPjvHYIvYH3GtuJVOyajoAM6BizVL3BcB6V0karCn73SA2hhMvFa6hdLlKgEhVqSXcPZlzOdgOCnuUAfdC2woJ8IyXZLi8PhVOFTEub8Gsv8V8Hhvv2Zu14XX+NXAFd/xWBr3Xt9pbtS8tRUyERROnciRzq1M3piRI63OSjkuRBfRkr428AUaUeHTdclzH4yTCxHcREW/nDZwsyBXsVk64l9YWHvZyCAIOhPY0rJaaOmHbda/T3kWdfJVRVZuXk5MzB3P1IE+dth45lNl0f/zmxfEPUZJm7uXLjoDGhC3UOGUpFHeB48lo66Lp60ihkmFjFZ39MTCgaT8DvBz9kZnCPbTATI2dzXvTdB24tbgMkbCQgg/bNQAjUO4p4EKJHRYzRtOlQzBn09CcLpdayCo+rOtUcZJJr4bns+uFtsKmnAr/zz52tvcMdd3mJ2KjdVVJm7QUq3mDTR1gar5bHDe9o9/cv8i0GKeBBqS7H9SYdyne+rDp7KOg+K4N9jupNMr+PHq4wjNvRaVvqksuY4CVp/nTf3renRhOX/vBe9K/GGnG9q4ctoLLXs6xp7Rwc4UrcTxJdJhQaZfBiduIkLTJK0NZXCRyd5Dal1l6X8535z7h/bwpqgEElDzOW8tVSkAFb0yPdDqglVQBmYHY0w499rQY9gDAzUS4Z9NBo41MGjMKfUhcxVJXtdLrxKJ+ryyEZbTwlHTkTdN+4tl5jT2MM3ZkbJ469aoH0VTX0RE8+UwKqfLLaulx1WBa6U03LHzlipWaXGk2iETnFUhIMWzm
 JXN4U6uE
 1n69ADfn8YF5dri6ixaL78oq0a/34hJW78C3i/uLvQ2DqD8H0RyXfvRxogC/c/SYnpxIDx8HXZWGiNiMFQEd/R4dgVCGh/IkIYCdxN8pj99YrWPbBw86ruVL4ZWKm6R8BXdzPXoWqeY+8s6O4XudHF5qVXEhwQnYqhPfwJXvmVuZJx5+9dgI0jceUT3NszvSzjI1r1gdUQj4tAD5KcXKFNO+rta3xDOyZNVG+3+jjaXTEBa+PlKlhmJrag2HNb2OchpW/tKZ5Xxdjn7gM2ioOg8ymSuEN8NFNtQvQyuinlvS5SPFKjtBHcryyt1XxR+0mUmgram2N4ltjfI9G15dB8oAFD0VBg36xtx47qKj5PxpQIv0K3mBng6LebRscemeqEhUvGJ6qTnPqNUIcBV8FnC9nfMPZntExuJKUstmeN4KlMsK65h2rutbhNFhgjW0WyWB5YnpkdGCx29j/fjlfwrEes0FrFL+/KMcF994A4tgFH2IODsBljCvoiguzxK2iasZk0dqKyj1e4Iz62kOiNrwN/h9eJpuWx+G1qr2VMZ/bCrokftUQ8yHfPjpuiyvN3cQhjWrxXDKCnNcqRb/ao77/5pW9jn8hkNCLcKpWl953Cs6DbXZQte5cj5qgs29NLb8sqxflKGJJGHNP/rOfpGLvxhoH6oLgAv1/i8J9lSccyowDRasiKAZ0na33ue482m9jzlLaJizLLMdb+3u31UYUF415xH6S2ncGiY1zVOLXi01IKFZMTsXyPUD/WFHG6BvkLSjYpVW5vzUFLXqsDB3mt5gO9rsGdpHS3DoUAYkv3YekVy2STTtygxUwxbyAPsn7Sra0KsmTPniF08RrVKMgoHpBOrRm5plKDiOw+2hs2h8jNIdhYOlhW8cwFYzuQ9vwITjidqjb/hOr7TNLIdMxhOh1tqYZ7F9Kr6vzr0HoyXFSAAIcAr7dVUgD00zrgPOUDyhonmsqMIKB+uFg1KK5Ew+L
 /MmZ1EUq
 asQb1Kxt/GUT+BnPopoTOMaNTVXP1YT6xo3BAqFc8AMSi1+cxmyAznX5ZI/tYbbZRw5J/zOlH0JV4pwUY0lo6nGBs70GYgX+NXIa3igr4INQFqMuZNCBsjUF0UzhdOYzbTCY9nCPH1WvRgbtBC9gT6ZO4sqjt4zJ4P6SDJL/cckigZ8B0BLXEVykmD3PymLmLqtMHdDc4sbiB1svSLbO1f7+5lOrBo0fdrpGDcvnGwp/9UpwWAW2sl3fStWyLwbV7nIdGELw1LSpJrsGfZoMKcOOkyIEqr7Wy2frHflym26Gx1Pm5XX1sSaNMkEkcGnQppNlSt2OTLo3MvMm+j5N7NtgAaxy8BsiD1MohRFJJJr3hKihx6kVb1RNpCQdf7j6QK9wYyU4pbro/r6//3FwwYY0LoCUwBamveCcpMqROr7QZ6CyQPUrXRmOW/tCV4hnRauM6VDfeVRfTcCk+qhKLdOK2dw0yZ0k8Ermo36VxhvKN7Aw1Net/+JcVn1482pZiILUGniJPJGWHIAQXepUHitEWhLgTkWt6xvY7W53/heNWZ1dOQvxK/da9+NrIMIhsZOs2rAVeZ/390PiUQPsDIL4t9CO2jY/g54eIc2xFXXDaCE7aQNQLQPsLc/1O33T7Krw//xa7I2VpXXePxBfaVcQSNAUuzrIYT4IwsJrFCZtI4sGvgay4pTA3a34A4VqzuKZum27g5Rppdod8FiD6H5aw650GWRsWD4j27ijWI1FAvNjGF3v34HnwcxKixfCJHkCP0EcnkvhtsPaDkJOIZGhvTuBIbL7wLhdA5gak3QBLRsp+CBUG+dJC/5b+pfLNEMs+ggTk42Xa0ieN2NODh27Xvr65re48Mg/pXiTLSi4Se4sjA522xpOK8OBZ6nJFBoNXU2DQPMluanr8q6EW0nw3KYEFntcuIT6KpDsGikt/FC31hZOWmLlKaKSWuIUSwqRc9hSx6imACqB6peZrw3KNyxI4
 axjqDGXi
 IR1/gH9g9ni9OWrkPCLbVL8cDXMR2w4uf9z3dnMqa8Z3iese2Gq2Lxlx4+ZMyp26KFMZjETSDdHmUmuw6CzhN0PSRhWbYPEi+dDoMuA8Mm3r3QKytCxkiua1VCCR1FDa9TLNT5A/q3u05E7km69qB0AzRU5juDqwV1r1i4inRMHq6+Jrb+V8G4FzC/jKq0XLOdviOnFWTYGzKK5qD+DcKexYW9TFswKpmL6gdGJeDPi8L9x5lmZXiy2u0KOHwhimItHjsv+qaWcxXarl+vgy6e6dVaQdaF+GvMbCSUg3FU+iNeP1SY6Zy4KLqU/gBeYsjUV3oxuBIYOfN4ypvLnegJ9MN8koFpEMQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 1:21=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/15/26 03:08, Andrew Morton wrote:
> > On Mon, 14 Sep 2026 15:57:20 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.=
org> wrote:
> >
> >> The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
> >> properties:
> >>
> >> ...
> >>
> >> It's all rather a mess.
> >>
> >> This series brings some order to things by both limiting what drivers =
can
> >> do with VMA flags and switching to using predicates that describe
> >> behaviour, not arbitrary flags.
> >
> > That's a lot of patches.
> >
> > Review is thin and I expect this won't improve a lot.  Lots of "no
> > functional changes" changes.
>
> I'll expect to go through all of them. Might just take a bit ;)

ditto

>
> --
> Cheers,
>
> David

