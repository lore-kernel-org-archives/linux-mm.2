Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0121EC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 16:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214346B0088; Wed, 23 Sep 2026 12:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19EED6B008A; Wed, 23 Sep 2026 12:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0183B6B0092; Wed, 23 Sep 2026 12:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D28036B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:24:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BAD3140840
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:24:00 +0000 (UTC)
X-FDA: 85245548640.23.9E61620
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 69AA0140004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:23:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T88c9Fw+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790180638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FzOqkymgnKp+HaLHwhofGZjaEcw2lbzuDYsddlgiEM=;
	b=oP65AmvC/Cx/33H6n9V5jCB9dJuMp41wKkzP6au4FLm1YEmYcdnDTnbAWAftajpUzn1ue7
	+2Jxo+kYU/ZRpxJFeqyt4T8BoDIZVpaUIpTUuHQ+Sb2TpJYLiIE4OhLCkXbjfTYmGQnsYb
	TZPJL3vnIh1/ylNYiLCPYV470dusTP0=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T88c9Fw+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790180638;
	b=ZmowZfrrX6q4vjCFFw0KVFVo+gc/3qMLu2l1Uy0pzoxA88FdOi7MjjEj35uzvJatGXyW3G
	SOIQ+cyveobrHAsPVImaZEm+1RCvVyi3iaqTpNKEXMJkLex32selJYxgJoQfBRo/b0FW9m
	qjz14xQWr7pqyZfU5nAE6Hd5ivvuU6s=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-530e8c6fb80so276831cf.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:23:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790180637; cv=none;
        d=google.com; s=arc-20260327;
        b=DsS2tRFJ6QC/R0NuHHI8EGJpxm83GbAOHvH1zG5AVMOU1XFdt88iXi82GiSNz3GxfL
         KyJ46oCYHf6ENZ+AVZKSkqL15YAjzSC93E9uhtypr/QufTVKOKyI0feWGc3URRwaqOyL
         HstLB1q/i2khwSk6PhFaoikSG0FGUbUoEcmSW4hwB6WbeXImtVWVIN6o8mU05Na0QTDq
         MTEshorWEijcC+UT/V65hqfDAZaAU7I8+B913o0EvcHiXklRL8/ghSQQuhLaLPX1NFlk
         rwa5taFgj9i8Ml92cIRaidZXa6ep11JD66a0V08FowV3ygfHBr6Er33VLbJCmsMiqGwt
         gABA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3FzOqkymgnKp+HaLHwhofGZjaEcw2lbzuDYsddlgiEM=;
        fh=G/fmNb8s5MzwrrMqq/LajEwSL44i8PVGzmmTa6BHN9g=;
        b=ROzX/DDWQQrY2HmRD0xnHzBfW/aciM0QK/vt0xzrEvIoyyFpOEP9y8XtzASeqacdMV
         uy2FUw2agcaIeg+tq9O42xW5PGfbkvg/q14+al2aClqpcXaOVPYwvOeB9F6011CVCqg+
         P2JTgWs5CX3dJMUkGwZpWbAHZhZDDIz/4C0Z0diSdFtfwqN3Al79yA0LpylEnmB47qMu
         5rbfUoF5QK1mlJEKKJaHnJM0CLSK36Mzc+NNzqyEzMi5aGhSE8Ql3qGJpEvHo4Y9y637
         foOpSG9LQuPxj3lImLimXsA+3uvt0DrJH31pEq6tDq1Xb+KRs+mHNPJPSoQTgoOgZ2Cf
         RhpQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790180637; x=1790785437; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3FzOqkymgnKp+HaLHwhofGZjaEcw2lbzuDYsddlgiEM=;
        b=T88c9Fw+gFmJpZcWHSiRbt1yfRWjbFQXKKYELqeH6m8KqUmQ71lrA7UFi9xO0ng1EQ
         2b+Xd/zpNxKrVCkqReVeDjDYwJPjt3/zQmhDY73dOaliFV5XUf6RS8Yx7cherg/khdWq
         +ZWhNHRwP/YJF0fnT4q87pxVM2B1FeebWLPlzZQ3ZJR8gGA6uk7w0oc37Kv9+g1YEyMd
         bZoGff/gdgarYgBeHJazFW6X7MqNlOdc+fNypIeo7aTG+q5Ud1jwHiSTN1/ggJQYId6i
         yj+lpiVQvcQgVzqqn11Q6dgwPykDWn4aoo/s+0wHyGMtUNwrnXx5YpYaCbJvp7zMDayc
         y0Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790180637; x=1790785437;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3FzOqkymgnKp+HaLHwhofGZjaEcw2lbzuDYsddlgiEM=;
        b=m+EODVJuBkMoWeWwp2d4S0D4Xmc+4N1buBmkHULB+IVQR0AX2Qv2k2KW4Ht0XKQ2Tv
         cvESfQrb6eeEoa/WT8k/O2C/LbNNW52uEuatxs8hWnqsbM4v69gL1X1PTlJ3r5l0aAlF
         x/teqVygtloApPi95az0sQaccW2M5dwLv5Jv3/xjtOCn1Xqb27XFH9RyVtx8jVmnDOga
         GrsHaBh5FmXFjb/uxfN407zhW20vlIwroJwJPuzDFPoP+pIuuBt7stPEmvqRTm3l2Lvh
         lSuyodiOmFYbjyoqqXxWITdcKGyBZrAEmvOColDnGeAqD32wZhrDVGoVz5oNJQexkNkI
         J8kA==
X-Forwarded-Encrypted: i=1; AKwUvBwnvnB5bz5zYx9tuA7kcG+cXbcTV2o91CERD6XeMlR1lxVwScfjwkgLK0MqGTb4PYSUyAKExO+MXQ==@kvack.org
X-Gm-Message-State: AFuF++nBs0rhhw/ZnNYN+OzJ8x2r8qZIVe3bVfy0ZAkBBdwIqHN0t4wp
	lLf/X0tV6lD8aGoH18WudWOmU8KEf/xtRZT9/DDnYGKGuIMmjGS2q9YjwoO5sw8Nx145GTbrnqY
	fLD7kGWnY4UctCqK/+YNkvh2319mpmfX7c8aJXsKc
X-Gm-Gg: AYBFou1cDuH5gAfhu+ts27rvUDDz10UPtiSB42cnGoTNQXAlRKzhu8neS/rArKRRgP7
	grVhngI2tOjFqUxxdrNJXbeVwom7O3yWKG2A+dPO1u+ukTqrslE2dKtca1C0/UEbxOJ/HgWIt2W
	GIHVLTFD5/nzLkcqCofvi+aF9FmuVDExuapvRtDNH1TbYEYlpUtKu5X9gQkt0w+tXytppFD3TbD
	2Kv5h+/AP/ot2aoTg4DyjQO73XhYAW0C1HV5rYundrsEVTZbJYUAAmD/N6WYuimZtRVxqoati85
	6SCfTPqsZ/qsgKNNrL4uqujKW4kibdAdozGK5r9xIAA614F3VYClwbcuEnReSrL5r/gd4LOwdO2
	le5jGYNO3jg==
X-Received: by 2002:a05:622a:609:b0:531:282:6560 with SMTP id
 d75a77b69052e-532f9d4a86emr439391cf.15.1790180636277; Wed, 23 Sep 2026
 09:23:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Sep 2026 09:23:45 -0700
X-Gm-Features: AcwNN1U-1rGp6GFHFrF0qqhOHTzivX5krrdmfBch0hMHABT_yaCwm6D93D-Dyz8
Message-ID: <CAJuCfpE0WCr1Kp=+4EVJB7UdbH22HuCouOEtGMNCL+a8TnCQPQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/40] mm/vma: introduce and use vma_[flags_]can_merge()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
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
	fuse-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 69AA0140004
X-Stat-Signature: qi5qq3rzgwwmcjx9prmzojznyzwyu3m8
X-HE-Tag: 1790180638-51213
X-HE-Meta: U2FsdGVkX19W7nzeGgXb6Xuwwx2XI/02pChWxhp1zzgxDxAq9ZZKjKQbHEH3RLFSYHN34EjUc7ZUJNRefpIiyQEpdw/N4Cm+RqM7BBOALPYRn6A9WDpTrHAdDpC5b3soE98eLLgMBUIylN0ucrAaXmk5W6HN3junITnwIX6qFNsf56sGTzAHVB6o5CSkPvTfuZt8RMOq1STnwmovGMASicjCkG4k4Pj2i+Mv3mpQ8hWLjgAJnMnX6LSFhaNJVR4hV+yfr0XJlfDuOW5aPs+woyke+JcJeWuw0KOzNVK28FQ/50poYidSdH6Q6lUdjMvrM+N3w2cBtO9mOIAPI8rKZ26PvvdL2/+JU8AFleLxdelx6JgNecAj+pIlf/7U0tyWx72EEO0cib5/yUIbpJxHX5XbSBKrWF+zHl8lGJAym/SVrgH7iF1mQQhApwLfxHd03tQZo3O9c4GgkR7cfLKqClTdu2VY0OAsScQ35HIHRlw1vkHkDP5cRLDDBWXD5PyQAfaRJx62zlj2+PwdujTSkr7nGBoFDwW/MKfgUcA2iYqESnet084Rr9KlZ7u1VftezwP3tb/R+OREspabJcWRABEPMFIH3urRtdQgZAnW44NWg2QDm8L3fC0udVYireDE1YqrrHBTevQCNxpv1SNTUWjhAiJ8mX7B2ps+6dDdXZi7WKshZ9sb2VDoT8EGvt5zXtEBaD3x1zekSC5xgc8Px3QrVelH/cSu0IVSB/JWZ4ogE6BpMVBgdRLCY3i2V6x86+90nLqulH0sQoXko8odj49rRGOnp84tpKCIe/5yaOb+hTL201hItF5At9tTkIQwC/WwPlZZINA23y4UkPPpiw6hucBmukJe9qjGlNu9MauHSWOeqkC5ILpl0KJjjoeaTepd45MUkaqJralF9rhHWZFb5yV37nW/8id5d5uWSwFTlLMzaO5rM7ZNacPj+MofrTbnM60DXfqE6usE5yv
 EBpINkZn
 ZXKHYqC3pJGkjncvkphLdd12YhsuOmp4jLZXPffbGHyL4pYJK1JXH7CRRhAgWPCdv18RoUm7T0pEqKLcSKuZL0OSuax6+4/5YOt4OoCtGZjoCWRyZ9MVRBFDPLqO5ha6ZVMiNr0leJneqogkEVWdSK5WC10ySMsg2Mhq68O/ns1qTTh1iGnmydA2APLszAxYIj0Rbi/e2/ZPKBtnrxBliPLahoKtgYWbau9tlD5Gjvyrn3V2Xg96P0ifRxkLx5ffyvbyCy4oIigf7MZdahve1/lhcUYcGWkEoMamY+Pw/ybeqBjk9QzaECMfzV1HU+pxKUDqMP8oK215CDO0QuwZgYhYMz2pjJH5M+eqrK6KzgckjM4sveBVA+RnJ7JBpFSLFd6C02VQhJ2gcRZgnJo8PMjmhadyvQuCZPI5jyLLtWpK4K8/tRoxhAP+f+ut1RNfRigY/1r2w39iG/Zb5cEab7tKxVHwPbLib327Q/2ORbnX43xPZjNDKJ+nwbEHpmYO2Lj3aF0ownGPPWmVuq2mkHoNEZKi5jerw5ItNOtHEb4QYLh8HN0Ln6ulDe3hOT1/WbMebN15qsNvlvVeHDzadLckfs1TJ52E4vMBxE3EwCg/+ELlvnOKE05gLVtDAvRCbq+c1bjgJmTL0fagF83tRWKdP4Mccxk9HXbH1xxeJYOTyNRK+0z5ofB0SPJOvNPIw3iS9gIPjJvX9/cWCGT9mi9xtx/3BXZM1iI05KNVRLBS1S8Weia2IJ8pEyUagubbKNRKOZhySfbaQTd3CIN7T2Elsuz/icrnL6ObDgyoLK4FQKJ++oK8gIXtu7tp+bp+OkVlYnfUKveOq231nn+5xk+aEQJiJm1DwtzX1Kn/595G24Wl/tHcSis8BO7giSJyajTVgvFzcDs1PlLoonBy0yQBoc8tYQFbTaDh/5jkAUIALQq1m0gxUE6T0oObcFChb00w4uLmn8lRMbS/t6uQIX8n5NfTF
 INFFf9lu
 Y6har5upk5TOtF4mXIFvdF1bFfq7zUdCxHBz4Jui886e4bX5/x1+Gf8sLwXZQ398Ny759T9o1aq4ikkoOZJpg/EJxwcsMrGIgbwOTP95iMH2IMkwY4YHCxj80zhgw4sa+HyF5MnWUfcDWA/gsd87Cch4euVAB5iXIg3IXzV1VbYNV6ypHxYTq0mfbwoHpqJhRtKLau7ygb+iCOPCRs/iHmq+d6UGxL1jDIZU4CyhZooWvAkKewzgXYC9hRGC0tX3wvcc0OB0swKKUJ36rcIEliHj1gmRVrD2tuHtneHb3XoWLZjyMVxR0IKTPa7OquwP5A0oLmRfuNHPPbai3xAzo0MfYmvsvkFt6IlEmOAuGm7p9gkTL+kWwPvYeoI1wuP/7uoy2/Usyk5k9xvK5bSu+UcniQIf5iodC+G53ZR8knfaHMAblaKRF+ZrAALWjIMtHsvc2T0WQW+GjDM6FNbkX6e50WU1Srxp+3RiWM5iSLpNoFi7ocVTE3Y4ghb2swb6fahW2mIxiqNTj4ey66Qr/CqQCM89JWe1wwZ7nfiQEYuony0sEDgj8hguL3iX1yKiMBuRO+Fx6tbmIBEpGm4SvQLVg/KX6DRhgBmxjUooXjBy1OVfsTfUt4+1tXgEQ20/wpck/abm6hiHGzwrMMwagJBLEReRD7qomgB0YabnIqnMCaawJQwd07Ti9SMy45DnZbvaS/LutA/jjCb3VIEmbdZdBdoLNA84F3H8kG1l9q0J3YAH69skhxSHOQ6RH8t6LAERDYUs4MkAbJH9fCidOvCJLudq8beZboGgpp4l+TzjWl0bpQzmZJTzre+17rduw1E3aj1NJbIvM0rplskmSv1Kc6BnY6StB/CWwjb4i5v7/OpTNwAEMuAaZzuNaivzyIY1YaYlRyMoqsF6BLecrmUfmKJRgStY18LMMjyaJSsK2x3ALUjiMFK7Tg14RO37CHtmq2ts6YFq7XcghfAT6q85dFDoo
 4TuYNBam
 YRIc5ECCGXhEHPXR7pptTS35mxIcRnNiOB1ApRc5j0r+QtPAjdpuOhAH/raWdLsaM5HC0csDUpxynrOXu/K6x8qokO5cpB1SsFlQsLW1TJ2OPc5BEAt0afuu22s7WEG3u9Bc19lAYsJP+YWWsEHZppe4Own5rTha6WTT9PlcKovcCa3uRctk72tT8lok7V/CoKlHC7b7J0BiuWIaPuRy67JVMW95qkEMRZ3EffLTgrRxcBIC0yu8DG9iuV/bfEOPH1fBxaJhy4e2BTtOFUleTT1mmGKTFK1YQJf5f0HH0aie86CQJrtHaV/u5Whaf/P3QFpEmk3Y03gCzIwOtiVZE7SkQ/ekLJPZcB5Cq92fk5xZwuaNay1xzV9opSOT01LnErWHhOQ41BojwRWACSkbMKAAS4c69uKsYxwomBKk7gF7H1oCEP283dnnaSsF7XIrJMjUTdhrUf4bdkaIJ8ay+nH/p+1ymE7PLsca5pPOmcpE98g9+7IYnzudm0PYlx+xrAsvFBb9WaVH03yfC88gP2tPfePZZzjBv7IdNXpkzdn8THfUyn/lvcswDcaqMtgOzxMD4OpZQEKvf38WTDl1vTt+vXgOfIZzvV0/VDdidXkNp8N+jeoqrjxNEEh1m3Iq6zk4XLUqAZJP6+z3386y7LsKzF+vcw5P1RcLeYY5hbQRrR1g4zkD8fSXqU2XBNT2fUfH7Dz/5ApBkbwYAXKSitqKz/b7J4NQadY+G1S+JpiRJZ6QS0jYyc8MibzPbezaxEfOppxNsUxGlTfiyl0tkbOUkndh2BxwaWP0XdwQX5YPmCNPsUb5T8Lw+tRQwMENLFbjK5rrga9CPcYU7hmKqTsTZMxuKLo0YYqypYWjNIQ+Vo400gL1qtySkAWjgYB9dOWh2WU7PHk72vLMsa/wMK6c+T6Kiq78COjTRu1Ybt6tauqt6H9nu3y08RqzI1QQE9VJdxQvXgOQ/GMoMpI9GKrFjtDli
 sjYXGBSu
 dqP8xv1DIz+lQ/gz3va0VXbnXUaKsAmOljnM4+DkxrTR2G+dgf2P1e1zy2uP0ytuKVHMIxrW/a/In1C7sVRr7EzbtNOOTwKIg7tU79rO4M5uMGb5mbVoodO7QSWVgrcg5qjDJLIXpSktmKvl+eho2afuSPbIaIMeMHcnmDxLdsfPGPSj7w2cxCSCKjTVK017Dr4lLT7+oQ+QccLwxv/XrpOWQ7iFoN8Brr3pfNLIjWuq4cjVco4lr8Qv/bZktKLBez4ZT7t7KOhIVvpkNUrxF8R+ynQXyorjG03ri4oAhMZWa88K17j4+riZRcY1SQXDMSnoxpfAL0wv/+UibCo2FC3Ulw35YQbEPRy/RfP8+7ZmcvUSoF+mgK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 9:24=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic wit=
h
> two new functions vma_flags_can_merge() and vma_can_merge() and update th=
e
> merge logic to use the former.
>
> This abstracts the check and expresses it in terms of the desired behavio=
ur
> rather than an arbitrary and confusing VMA flag.
>
> This also lays the groundwork for making further improvements in VMA flag
> usage.
>
> Also update the userland VMA tests to reflect the change.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/mm.h              | 21 +++++++++++++++++++++
>  mm/vma.c                        | 19 +++++++++++--------
>  tools/testing/vma/include/dup.h |  5 +++++
>  3 files changed, 37 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 969594074fd2..68250ece4219 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1612,6 +1612,27 @@ static inline bool vma_is_shared_maywrite(const st=
ruct vm_area_struct *vma)
>         return is_shared_maywrite(&vma->flags);
>  }
>
> +/**
> + * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to =
be
> + * merged with another?
> + * @flags: The VMA flags to test.
> + * Returns: true if the flags permit merging, false otherwise.
> + */
> +static inline bool vma_flags_can_merge(const vma_flags_t *flags)
> +{
> +       return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
> +}
> +
> +/**
> + * vma_can_merge() - Do @vma's flags permit it to be merged with another=
 VMA?
> + * @vma: The VMA to test.
> + * Returns: true if the flags permit merging, otherwise false.
> + */
> +static inline bool vma_can_merge(const struct vm_area_struct *vma)
> +{
> +       return vma_flags_can_merge(&vma->flags);
> +}
> +
>  /**
>   * vma_kernel_pagesize - Default page size granularity for this VMA.
>   * @vma: The user mapping.
> diff --git a/mm/vma.c b/mm/vma.c
> index 4b74b48c29b7..05d2c676672e 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -924,13 +924,14 @@ static __must_check struct vm_area_struct *vma_merg=
e_existing_range(
>
>         vmg->state =3D VMA_MERGE_NOMERGE;
>
> +       if (!vma_flags_can_merge(&vmg->vma_flags))
> +               return NULL;
>         /*
> -        * If a special mapping or if the range being modified is neither=
 at the
> -        * furthermost left or right side of the VMA, then we have no cha=
nce of
> -        * merging and should abort.
> +        * If the range being modified is neither at the furthermost left=
 or
> +        * right side of the VMA, then we have no chance of merging and s=
hould
> +        * abort.
>          */
> -       if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) |=
|
> -           (!left_side && !right_side))
> +       if (!left_side && !right_side)
>                 return NULL;
>
>         if (left_side)
> @@ -1152,9 +1153,11 @@ struct vm_area_struct *vma_merge_new_range(struct =
vma_merge_struct *vmg)
>
>         vmg->state =3D VMA_MERGE_NOMERGE;
>
> -       /* Special VMAs are unmergeable, also if no prev/next. */
> -       if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) |=
|
> -           (!prev && !next))
> +       if (!vma_flags_can_merge(&vmg->vma_flags))
> +               return NULL;
> +
> +       /* VMAs with no prev/next are unmergeable. */
> +       if (!prev && !next)
>                 return NULL;
>
>         can_merge_left =3D can_vma_merge_left(vmg);
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 16c09dac59d9..2fd422789717 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1647,3 +1647,8 @@ static inline bool file_is_dev_zero(const struct fi=
le *file)
>  {
>         return file && file->f_op =3D=3D &zero_fops;
>  }
> +
> +static inline bool vma_flags_can_merge(const vma_flags_t *flags)
> +{
> +       return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
> +}
>
> --
> 2.55.0
>

