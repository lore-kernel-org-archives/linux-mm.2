Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A11C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 11:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92C66B008A; Wed,  9 Sep 2026 07:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B431F6B0093; Wed,  9 Sep 2026 07:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E46B6B0095; Wed,  9 Sep 2026 07:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61DDD6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:07:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A96911A0199
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:07:36 +0000 (UTC)
X-FDA: 85193948112.08.1A1B082
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 94E75180009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:07:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=brainfault.org header.s=google header.b=MgYUw97n;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788952054;
	b=jLTE5MxqIGHc5JE1P3+QXT5anndL220ppcK8JJHrnoD+LSRZuOCcXpjkvu68Ds1eZV/Ix7
	77hDAFMRhJTMy633bM4ix8B5SWxv5MOWPoBiN83WI11rocTe5luzypZsdVpUx9tGPsL9fj
	QkrDMdI4Z2ETvjfpGTnA7K8+0cwAU+E=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=brainfault.org header.s=google header.b=MgYUw97n;
	spf=none (imf16.hostedemail.com: domain of anup@brainfault.org has no SPF policy when checking 209.85.221.52) smtp.mailfrom=anup@brainfault.org;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788952054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3aNdR2wa0m5qwFvBLEhbB9OXR/stCYGJpQtxZv4DPbo=;
	b=SpFJ/xI3SwwYLqPyRDgipTZDQv59A0H3BNCA6t8CAvNKg2Uf2+Jo5MVvhZ2f8J6TIRmx1/
	383Qna3YcRDYAJKn1DaXsbvnyRE/iTMiikfz/mhOjSVZQqheBsvq6AvF/LvoUFxF16dWz4
	USbS6WcjejMRs+rrhTj+rawwgT86gRE=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4843e9c5960so5446904f8f.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 04:07:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788952053; cv=none;
        d=google.com; s=arc-20260327;
        b=eHK7QX8HEei07Zo06nsqpsODSGZRTGcCyVOhkt7rW2FFmcSEFCoSaw6gIoI31VHkc5
         YpwKiqUulV76jpehJbm/pCu5PoQZquRdrg/fHD5ozV76paaKaeUsuWmGyyQnU/TzPNFm
         8KD1YebgdTxM6uB2kqM9BS4auxN8Rn3RgqFzLWDmBLlMDmsVzOf9YeVUjt6Elsn40S49
         SX28+DHP05jHfz8aIi6q65Z8h34FW5XAUeXvVZLxvUxjWPJO+9/44yueInwsyrT6cIFk
         AH0hu0vV7IXzqjesj85ukLc2k8GjGhAaheHmE2rNqjHf0Kitr/Cl23hZQxcNhldduU/v
         4jlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3aNdR2wa0m5qwFvBLEhbB9OXR/stCYGJpQtxZv4DPbo=;
        fh=AvN3v/1oQ31JZr41KRMzblvVOhtKrBDMmZNYoauCZw0=;
        b=lFnLb65tdeUBREC9uhtwlaKIcskNwqgSJkjpGCY5EhSgOD1vhDODbOOyy5oXScPZMV
         gsP0WwjqcOTJgFKCgUYb/pfo1lhMkT7P9/eSBDSFZyC1Yy8NXpO8ZQfZJEWwmqcHSgRA
         glLUi/SeQbNKc9769kx3HyZ1a1bpGNzfpTXFeong784NPzsJGJgib13oG+z1mef5cuLX
         tdrxYdAKI3oVI2Ue3R5ByoGoTfGEsRDGPPIA8v3XVRCoWuxNW4CFOJU8QXfRrPBmvtO6
         DBus3QXfU2pm9kAw9cax6hkasiQpXjvxGtE0dy92l8lUrnT7O1Pn0JN8IxMoZtWSkFm5
         PrSA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault.org; s=google; t=1788952053; x=1789556853; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3aNdR2wa0m5qwFvBLEhbB9OXR/stCYGJpQtxZv4DPbo=;
        b=MgYUw97n7g+oF3c1T6myX1s3uLOtaC/YOf7sm2ylraTWLXq37Kf82d3eeDoH21YnzA
         mRDWZKE23tcQ3CGGql2LWi8AU9QPUonvfxdWIBl72JU4q6ubu17ujDXNumpshbWvjhUm
         zgUWfL6oEXTqoCC+A0G4jX6+waT4jIjvMpJBuYNXtmrYQHjC+ICz8IT/EJBzbTygsTcB
         OJyTjBclHH/ZJ1M4jVziOMnXcikyOo7eUjdjJykzcrCTKGjrE9WPq1WVNGOuh89JgJkK
         aAUHV5AwdxIo43HkbPcjirhMybh1PclC5XP6qVRmWMqL0pfSwWful3f0QIApm/hLgp9T
         XjJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788952053; x=1789556853;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3aNdR2wa0m5qwFvBLEhbB9OXR/stCYGJpQtxZv4DPbo=;
        b=kAoE3jae0qiATVw7odgXlDJr+DmeQ+GT6ZJpAVkun2p/CrfDEFCbz7X+r1huwFmex7
         VdQHbPfYHVe5VEuoabpvpZYjJZ4r6R64uZtcEs/Gl7D0rysGrfD2+c5sOPnmT1v1j5gR
         Y5hfYl+jD8uQpYv9WaUs/G4B64IvngkxYR85wwO4L/p4TUqy1CDJQeobL4WxyyAKYJs6
         9Ozz7pRaMHplIcCN9UK9gR1h1y+RvEG0hKUcE9+fkWF3nEphT47tuLAKtf/kWNrCb4XN
         5T12TdoWOtIUOMLu7px99Z6Vik88UI/5PnBZnkLITqK3hbjazjDRat9ACGGutk86t7AX
         pa4A==
X-Forwarded-Encrypted: i=1; AKwUvBzwLKc5xoURBfDD6kPGNP3VuF+HMzPCQNfF0CsXZYqcfoBftySP/0ywLyoF/+bWodmlT8DQ+UmnxA==@kvack.org
X-Gm-Message-State: AFuF++mbwwNqal4thtQVSN96NU2Tr6kAB3vyIzcLQlt8bbHm5l95ta0T
	bIbxjmRAlEAfddmoGUvSVkqWzjR1x3DsDbTjViYpIb5qjA7VCJsBShCwzDaeDA+CPGFuwe+kLVb
	26ojongzkzUoezI+mpNU/QGLE6d3oJtOodvpo33QZPQ==
X-Gm-Gg: AYBFou0qBTMk0FfaOpmlt/i4hK+4L2cgBWlSEgYb2S3ANVJO8M5HRjB9JXQmAuDbtoG
	6+akajisRqyd8dZlzh89w6tivKxPW6bBiC8gKkpLD5F782Y47TuaQ1rMV1Lq7QRjnYoLe2Tx3hH
	LKcbB6lYcfsgu+qCSHgT7BikUREUDdsx7EAvWOr6VNybEdVXlQz5TFB3V+Y3NQCVTxuBoVG2aEm
	tyGfYPR3a9W+lRgP3IYf3aPC/VCaTQqUnuT3cZ/ew2C4V+TLxPQtgQvq/uUN/l1GDT+PDwZA5aJ
	phP/vzUW4UxhXNfH7rWGaRQrv2ZgHk1iMOGakVXlnZxXduC8JiKa8xAwjdlw6TKzu0/AbgIrHgR
	uKmf/XwkHukKKURrW25Mr/Kg2+EBL3ZHZDZ97Zp6dNzy8eV+djbxjPo/51behAQo6JIaOPk6x64
	c=
X-Received: by 2002:a05:6000:4304:b0:484:3313:fd86 with SMTP id
 ffacd0b85a97d-485872d6572mr40565582f8f.27.1788952051658; Wed, 09 Sep 2026
 04:07:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-27-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-27-dacf19cce22b@kernel.org>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 9 Sep 2026 16:39:22 +0530
X-Gm-Features: AcwNN1WNLYOzW9NhL5OQsaP2ymIc9oiRkuM47d8nFsaWORRm-KUzRKSHVVswJpE
Message-ID: <CAAhSdy1CG4O51ZFjUxLsGb9v-2aB3HteBNuNAeRD89vV3qr6Rg@mail.gmail.com>
Subject: Re: [PATCH 27/39] mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
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
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 94E75180009
X-Rspam-User: 
X-Stat-Signature: tzbdyni4mxg9z6xwzj19jmutcpno9t6g
X-HE-Tag: 1788952054-219389
X-HE-Meta: U2FsdGVkX19uMPMSbFxScmoGqUKLcdNVxAjZMObfSJm6nRg0xIws3QPbMzQjWSdg3tOagPHNr+URhHSb6h+/mNlXcCYiBiK6goBnkvMPv8GIdoffFEOubk99yt3iLLeba+c+9Rq9IBCu4dmjis3drp2o7LRbEGq4/OwH/a5p7jqYekb0IOZsZE9whkVJ0AajRK/3zrzhpde1Ct9bS3as+awvujXS3VDyG1VOLIUBclDzt0Z4xgEHUVlqmZkoSb7zp8pyhVKDv2uGPfHpfFsvJ8Uhg8Xhc05MmVBPsTM/c4Ho0sF0/gXNv1p5TVCN/JL7uQU1NWS11vfSYieaJTcdeeZ0jHasvz7duNpfCdR4rn3PKNNhS+Pk/El+KxTwwUXhhvJ4MSuH0sjgVw9KVEIl+KHQCAtD7InO/KCgg8KesOhDOEhRP70Ju3m5/LiM5hua2MBKjuZ0eRaIcZAMCumVCoDq+tENF1cQg/85Wa+izmH7b0J6nyzcHOybAfEppAuCAa/4oW21jbflsTmifRL8U7knupS85dU4vHSVUmtb3+je4eqz6kHqFTOR5crL2PAO/j2Y0baARHMCzhJMxEjfDcSTGkPYO3eefhO6hmKRz1LY6sruG22SXBgn5TCUby6rI/t7RaT2l/TNiSNVdA/45o8gdCf0eQ6PSVe8e6mDfMIQ8e6sUflgZCOsIgxzYQTd23mdq9AT/GF5/1oU78F7/RlZjGjS8Vqk/OVrSTESBCGGzuaZ379PggGwdKg5Vq/nf3MHVwj1ouXn6R3RHfoBb/IXaT/viFcCmKUEck0bs6NUYJB/YWK150QJ/cCAbPLKU/AnB9CPZbsj9+9Du6uMbAcgLBjJGsz0ksVJk15oaNUSwbcUc2gM6GBWumqhyv8wLhfHV1pem2naeXe5BYi4efk0KPzyaurfmf7+O9lzNOwcbDTzXDv8CHue6hn64pH3fWjtOVOGO1WlW7Nqf5U
 7d4dpbT2
 u1xHKro+9GAcCN1ks3mYVih7riqnfIjZi7RjtiqlGKuAlpR45v69RHuu+0FSPKbc3rkGMbNwbH6VTTShg8noEBdKzLGrUXbL3DhC4NWLymNyLn4DLi4Uv8zzMF0WjrjHCV9iALnGvOagTm3sZGN4+pKxw8hhTtY62pskSc1pIpZKCp8LeeZ4gKklw2SNgpy4DraYEBELGARbelc2zaGn7ygfJBMkEQ7Iv+AyaE0MBfyuesHoeDAJilC2joBrxTh6fYy/t7j8NkLNzlkN2TYA4LaglqQtPGyCRwBiCfH6xXKsfkjP1/e+5jAyLln2nu8uN259CDy1qD8IdhFoLYgTyZQ5nqL+gjr/rokMopiDhnUr4EXtKMTK8/Jsu1vkp8EQe/iWfbTg5L2Bf1ihVvKukYz2wL3nHQF3jjBjCeS71RDF0T2MLse67zVX4GEvvWxNu7DqWh5SWgNoUGwO3nrxRLImpD44UxvCohgJ4djJgeMcE755GvwZM7gaC17IyuSeRIXgL3AYtSpZ4NU70l7PTliPCTUiDKtdCo5U4AuXJsXyCr+lGLbca+ZSZ2AnSnIol9hrXmpz3an/5Al6ecTsfJXgDeLlciPFPNvt/45SdgaJqxA9lArw0DoTABenQ8Xv30xDNjl3d4EVJcnBgqYLN+Q5A8j2cx7I1KdIO/K68oGIKS6JJ2jLlJVq22W6p39Sjxqv7GB7wsW5NnfumL2SY5+cwQUvhgp3HNekpek+vhnJ0nSHyhgkLkXrI2WoHSiPTPNDNKF0ipeMDJLLBdcVMS6Vr79+Bp4FiNnSBxe3BRIjQQxW0mW4CvSw+p1rknFxnnZLw2ZLE0HbYJEDBSxkSFhBErtZEa0m2L4oh7f/jsPqymDDmInRHpEOgotrpv9AAJfdKU1lnrR/aNtAL61lnJYLJZbzcqkgbFkMaR43iCh0R3aliw43XjrpKGh7EtnQJKkjppGB/+UilaHwphq4UVvNMxgbV
 fubyAt5v
 QdGH+4LM/LZqmFpTnl5F4p2mM4nYnddPl9JWcWgtE0FwVMDdlsJiPRsZKicpcfKu6LcpDAnVzH1oDCGcetH4J0tSGUZOk/dSklkIbw+n3u6u6VKdI0nmLRtkE9Qq9nvN2I6q8C01VP0OWsSt+/4NvEooIIZmSFO7ksjSJYAumxsrZhJwSSOfqhPW6kGny9dmBcN+2WnQAzEk/xNPmPGqmVzTWwMH+9wpHoJpcCE1VVWbWn18BGafioujPAJDZG7YIwetbwFF4GhSYE7eQrqX/Ic7mOmwG3u3oYfQnQ2T3seNODKfpLv2d89AnCTkkHt27vTiSNPGSXk/s1JlxeyOxUtpj6vPEMIfM8QKFZw+W6+HoiePVNEzq62YulpVD/zCru7e75opYgo18QBu42l4IHwaBEzXzmjCzpvUlOxS74va0gF6Qt3TZ0ZsxoKf8ssM8+tMb6pY5Cy0HUmA/uy2GI34QX5xBGUqAkFNDrC1RXRsY0DymHVe0LaZP1NyKk9gBk4Eu3qPtLzcPhTvqts44v2hxNHgDP11vggv1xE1YrOzyRUg/0ZYgONJDSmqKvKpHmJ5y8RXJY/9mlkH+i6PVCIHAop5mgv+8sd/tmyfU/FAZBQVzMf9EfSLRyNNQDe2zRKkxmiTJgWwH+gHV+2CGY8ziqKKO8zu1SIXa6U1wMRWswFQ7JmgO+/ueuKe0XV2inTA3AgPQ9fXmVYgJ9lxSEUhqqoAANGXtO1/qHJ7G/AQlE5QAMVxEXl0/qtI1Ch8POwP2Cd3QwNfT+Vc6PQoY85LfTmq9kIJmICXCy2B6JkwKj+nyBdLW1BbaV6zfTXJogFf9Wf4ZoKdIx1trx3iM11jIpzMB/Au1WyObkFRJcjRHwRhbAJsyFHzRvX4vKPOwxwG1LvuJHlV15zg6/rVOPdFImjJ9Jw1FB1AfB8nBEzJ7EUyJZi2Uas7NYTvA3088oZEoRfAEgkcRLo26O3Ind39yX0KQ
 zlFRli8i
 RY+fUJJYpNLIT/bcyU+eNpd/s2U+iE9kD8vPEQ/adIpg/BfvRIWV0wjYlWyCBM1QenAnc+6ABNqgj8T0ivTTKdBAMFgh9MX+6gDnyLgkpyiaXnPpqS8NKJFixwqYA2Mr0ExrK6wNfZ1uKgGGcnwUJLXAXC6Z/sAcjGZkMNvOsRPDaTVeBVD9uiqTn73MfJovi6bbNre+aLrR81s5kLEgj9YueaJZD7XN0TChoS7VRkWfoG/sABVBnumXb9Prmi2ex3A/ZtlcoH4fEFgK3V1H5CbQXKj7KOnqBsnN+gJ4f+Oh/3SeWzaWRofUHlshic68bjTx0ysut06r6U8OFKgPxM6Gs1VJ0cVhIJ8lQABjhZ17x61rjEWf0gpIJzCYqyia3aGbsGbWjmWx3Q4ooNMDqrIIX2OerN0c2pwbw3MRZg/zGjilIE69bim+CUfc2px1r4bCCRjyL4NqVClU57c/BbIPxtN5un6lO1AuxP9STLHV7kWvrARPddrcCHqlh1X3bNhbIq4w6xc7k1g5oq0o5p/llJLXeO89k0iEJGOpcUJJrfJDGDRWdT5+lD6K3GboZZUGVeixtlPX5UykHQj6hAnnRWQO+tKme/B3l1+O5j+n71jr7O85nUCrs2wIfxsudhbDgeLVppVI1WROnKVN0Omh7GVt9FOMWDFSx/ps6nJtIPR4oCKBzCR+VltKYRv5s6sxRJR91LjOEPJdnAogvxFm4MB5Qv6AiZJkuAP7r+dHfQzRiYCNrnkCooysalV/TxfZg3yZVy0q4e1uF/pgcW8DynA/QcyVoMrnzBARbBpO7IoXSzd158y9DVvpif8sU/7/B5YSohWm3kyD4nDGp+E4zuhYN3aTQcXma5LouAfQ5WyOTHWpQDLwrxafomSUs3jEsIyLzeAVnAoP4Wp8mYIMhu/MHUX1xtdHUEg/8EAhUOz20vNQ7m4Dtu5cO0WTaWP/YSh3W9lry0ATBD4FjWRkD4dxo
 Gv68fgjL
 ftpxyWn8175cXIFhV6PLfx8AwpLhrIMf/ZCWCSzvSVzughtB8r6GQymNRbDCeQB0C2fxkh5h4hqtbgCPyTKkA3mkeHqQQD/UlRr3QC2aGWljD6hZWwWcjhkKjkGDg/Wj6zTSyMtunmolOS9g8VwjDuHuSBBHgjFrKswh75XYEhOo/gLDvrSamlRTRq44oc55E9GJhNupuK9DzfJ0+ik16peMjitLG1VJ0SELFA4SiSiSHgRpiC825R1o0dNZRoSKxokX85BF2Oq1+clr6kv4zykvWPxOB+wgr/yOqRCjU9kHbbLs/1aTBIUT2FNVBb1Pog7PuU6+LeHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 1:45=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> The is_vm_hugetlb_page() predicate is badly named - the mapping can span
> more than a page and it is inconsistent with other VMA predicates that
> typically are prefixed by vma_.
>
> Rename to vma_is_hugetlb() for consistency, and while we're here update
> some VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA() as to avoid unnecessary
> oopses.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/arm64/kvm/mmu.c                      |  4 ++--
>  arch/powerpc/mm/book3s64/radix_tlb.c      |  6 +++---
>  arch/powerpc/mm/nohash/e500_hugetlbpage.c |  2 +-
>  arch/powerpc/mm/nohash/tlb.c              |  2 +-
>  arch/riscv/kvm/mmu.c                      |  2 +-
>  arch/riscv/mm/tlbflush.c                  |  2 +-
>  arch/s390/mm/gmap_helpers.c               |  6 +++---
>  arch/sparc/mm/init_64.c                   |  2 +-
>  drivers/gpu/drm/drm_gpusvm.c              |  2 +-
>  fs/coredump.c                             |  2 +-
>  fs/hugetlbfs/inode.c                      |  2 +-
>  fs/proc/task_mmu.c                        |  8 ++++----
>  include/asm-generic/tlb.h                 |  2 +-
>  include/linux/hugetlb.h                   |  4 ++--
>  include/linux/mm.h                        | 19 ++++++++++++++++---
>  include/linux/rmap.h                      |  2 +-
>  kernel/events/core.c                      |  2 +-
>  kernel/sched/fair.c                       |  2 +-
>  mm/gup.c                                  |  4 ++--
>  mm/huge_memory.c                          |  2 +-
>  mm/hugetlb.c                              | 14 +++++++-------
>  mm/internal.h                             |  2 +-
>  mm/madvise.c                              |  4 ++--
>  mm/memory.c                               | 12 ++++++------
>  mm/mempolicy.c                            |  2 +-
>  mm/migrate_device.c                       |  2 +-
>  mm/mmap.c                                 |  2 +-
>  mm/mmu_gather.c                           |  2 +-
>  mm/mprotect.c                             |  2 +-
>  mm/mremap.c                               |  6 +++---
>  mm/page_vma_mapped.c                      |  4 ++--
>  mm/pagewalk.c                             |  2 +-
>  mm/swapfile.c                             |  2 +-
>  mm/userfaultfd.c                          | 26 +++++++++++++------------=
-
>  mm/vma.c                                  |  8 ++++----
>  mm/vmscan.c                               |  2 +-
>  tools/testing/vma/include/stubs.h         |  2 +-
>  37 files changed, 92 insertions(+), 79 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ba86450fe4a..a7968f8d24bf 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1463,13 +1463,13 @@ static int get_vma_page_shift(struct vm_area_stru=
ct *vma, unsigned long hva)
>  {
>         unsigned long pa;
>
> -       if (is_vm_hugetlb_page(vma) && !(vma->vm_flags & VM_PFNMAP))
> +       if (vma_is_hugetlb(vma) && !(vma->vm_flags & VM_PFNMAP))
>                 return huge_page_shift(hstate_vma(vma));
>
>         if (!(vma->vm_flags & VM_PFNMAP))
>                 return PAGE_SHIFT;
>
> -       VM_BUG_ON(is_vm_hugetlb_page(vma));
> +       VM_BUG_ON(vma_is_hugetlb(vma));
>
>         pa =3D (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
>
> diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3=
s64/radix_tlb.c
> index 7de5760164a9..b4603a98224b 100644
> --- a/arch/powerpc/mm/book3s64/radix_tlb.c
> +++ b/arch/powerpc/mm/book3s64/radix_tlb.c
> @@ -627,7 +627,7 @@ void radix__local_flush_tlb_page(struct vm_area_struc=
t *vma, unsigned long vmadd
>  {
>  #ifdef CONFIG_HUGETLB_PAGE
>         /* need the return fix for nohash.c */
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 return radix__local_flush_hugetlb_page(vma, vmaddr);
>  #endif
>         radix__local_flush_tlb_page_psize(vma->vm_mm, vmaddr, mmu_virtual=
_psize);
> @@ -945,7 +945,7 @@ void radix__flush_tlb_page_psize(struct mm_struct *mm=
, unsigned long vmaddr,
>  void radix__flush_tlb_page(struct vm_area_struct *vma, unsigned long vma=
ddr)
>  {
>  #ifdef CONFIG_HUGETLB_PAGE
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 return radix__flush_hugetlb_page(vma, vmaddr);
>  #endif
>         radix__flush_tlb_page_psize(vma->vm_mm, vmaddr, mmu_virtual_psize=
);
> @@ -1113,7 +1113,7 @@ void radix__flush_tlb_range(struct vm_area_struct *=
vma, unsigned long start,
>
>  {
>  #ifdef CONFIG_HUGETLB_PAGE
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 return radix__flush_hugetlb_tlb_range(vma, start, end);
>  #endif
>
> diff --git a/arch/powerpc/mm/nohash/e500_hugetlbpage.c b/arch/powerpc/mm/=
nohash/e500_hugetlbpage.c
> index a134d28a0e4d..b87623f04be5 100644
> --- a/arch/powerpc/mm/nohash/e500_hugetlbpage.c
> +++ b/arch/powerpc/mm/nohash/e500_hugetlbpage.c
> @@ -180,7 +180,7 @@ book3e_hugetlb_preload(struct vm_area_struct *vma, un=
signed long ea, pte_t pte)
>   */
>  void __update_mmu_cache(struct vm_area_struct *vma, unsigned long addres=
s, pte_t *ptep)
>  {
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 book3e_hugetlb_preload(vma, address, *ptep);
>  }
>
> diff --git a/arch/powerpc/mm/nohash/tlb.c b/arch/powerpc/mm/nohash/tlb.c
> index 0a650742f3a0..07a2db16c2b1 100644
> --- a/arch/powerpc/mm/nohash/tlb.c
> +++ b/arch/powerpc/mm/nohash/tlb.c
> @@ -278,7 +278,7 @@ void __flush_tlb_page(struct mm_struct *mm, unsigned =
long vmaddr,
>  void flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr)
>  {
>  #ifdef CONFIG_HUGETLB_PAGE
> -       if (vma && is_vm_hugetlb_page(vma))
> +       if (vma && vma_is_hugetlb(vma))
>                 flush_hugetlb_page(vma, vmaddr);
>  #endif
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 6035b5ec9503..5c5c77f98bf0 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -664,7 +664,7 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct k=
vm_memory_slot *memslot,
>                 return -EFAULT;
>         }
>
> -       is_hugetlb =3D is_vm_hugetlb_page(vma);
> +       is_hugetlb =3D vma_is_hugetlb(vma);
>         if (is_hugetlb)
>                 vma_pageshift =3D huge_page_shift(hstate_vma(vma));
>         else
> diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
> index 962db300a166..a74a7d5258aa 100644
> --- a/arch/riscv/mm/tlbflush.c
> +++ b/arch/riscv/mm/tlbflush.c
> @@ -149,7 +149,7 @@ void flush_tlb_range(struct vm_area_struct *vma, unsi=
gned long start,
>  {
>         unsigned long stride_size;
>
> -       if (!is_vm_hugetlb_page(vma)) {
> +       if (!vma_is_hugetlb(vma)) {
>                 stride_size =3D PAGE_SIZE;
>         } else {
>                 stride_size =3D huge_page_size(hstate_vma(vma));
> diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
> index ff63ffb1dbd2..3f6783b93e67 100644
> --- a/arch/s390/mm/gmap_helpers.c
> +++ b/arch/s390/mm/gmap_helpers.c
> @@ -102,7 +102,7 @@ __context_unsafe(/* pte_unmap_unlock() not instrument=
ed */)
>
>         /* Find the vm address for the guest address */
>         vma =3D vma_lookup(mm, vmaddr);
> -       if (!vma || is_vm_hugetlb_page(vma))
> +       if (!vma || vma_is_hugetlb(vma))
>                 return;
>
>         /* Get pointer to the page table entry */
> @@ -139,7 +139,7 @@ void gmap_helper_discard(struct mm_struct *mm, unsign=
ed long vmaddr, unsigned lo
>                 vma =3D find_vma_intersection(mm, vmaddr, end);
>                 if (!vma)
>                         return;
> -               if (!is_vm_hugetlb_page(vma))
> +               if (!vma_is_hugetlb(vma))
>                         zap_vma_range(vma, vmaddr, min(end, vma->vm_end) =
- vmaddr);
>                 vmaddr =3D vma->vm_end;
>         }
> @@ -247,7 +247,7 @@ static int __gmap_helper_unshare_zeropages(struct mm_=
struct *mm)
>                  * proof to catch unexpected zeropages in other mappings =
and
>                  * fail.
>                  */
> -               if ((vma->vm_flags & VM_PFNMAP) || is_vm_hugetlb_page(vma=
))
> +               if ((vma->vm_flags & VM_PFNMAP) || vma_is_hugetlb(vma))
>                         continue;
>                 addr =3D vma->vm_start;
>
> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> index 103db4683b16..9bbccb5d23a8 100644
> --- a/arch/sparc/mm/init_64.c
> +++ b/arch/sparc/mm/init_64.c
> @@ -413,7 +413,7 @@ void update_mmu_cache_range(struct vm_fault *vmf, str=
uct vm_area_struct *vma,
>         if (mm->context.hugetlb_pte_count || mm->context.thp_pte_count) {
>                 unsigned long hugepage_size =3D PAGE_SIZE;
>
> -               if (is_vm_hugetlb_page(vma))
> +               if (vma_is_hugetlb(vma))
>                         hugepage_size =3D huge_page_size(hstate_vma(vma))=
;
>
>                 if (hugepage_size >=3D PUD_SIZE) {
> diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
> index 793dacec2100..a1d4989b0b61 100644
> --- a/drivers/gpu/drm/drm_gpusvm.c
> +++ b/drivers/gpu/drm/drm_gpusvm.c
> @@ -1142,7 +1142,7 @@ drm_gpusvm_range_find_or_insert(struct drm_gpusvm *=
gpusvm,
>          * have to change.
>          */
>         migrate_devmem =3D ctx->devmem_possible &&
> -               vma_is_anonymous(vas) && !is_vm_hugetlb_page(vas);
> +               vma_is_anonymous(vas) && !vma_is_hugetlb(vas);
>
>         chunk_size =3D drm_gpusvm_range_chunk_size(gpusvm, notifier, vas,
>                                                  fault_addr, gpuva_start,
> diff --git a/fs/coredump.c b/fs/coredump.c
> index ac3cd74808c6..fb21fb6703dd 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -1608,7 +1608,7 @@ static unsigned long vma_dump_size(struct vm_area_s=
truct *vma,
>         }
>
>         /* Hugetlb memory check */
> -       if (is_vm_hugetlb_page(vma)) {
> +       if (vma_is_hugetlb(vma)) {
>                 if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED)=
)
>                         goto whole;
>                 if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVAT=
E))
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 7611a8470ea2..ba7097d5720c 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -108,7 +108,7 @@ static int hugetlbfs_file_mmap(struct file *file, str=
uct vm_area_struct *vma)
>          * vma address alignment (but not the pgoff alignment) has
>          * already been checked by prepare_hugepage_range.  If you add
>          * any error returns here, do so after setting VM_HUGETLB, so
> -        * is_vm_hugetlb_page tests below unmap_region go the right
> +        * vma_is_hugetlb tests below unmap_region go the right
>          * way when do_mmap unwinds (may be important on powerpc
>          * and ia64).
>          */
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e671b4fd8ded..565e6446bd31 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -3015,7 +3015,7 @@ static int pagemap_scan_pte_hole(unsigned long addr=
, unsigned long end,
>          * hugetlb differs, see pagemap_hugetlb_category().
>          */
>         categories =3D p->cur_vma_category;
> -       if (userfaultfd_wp(vma) && !is_vm_hugetlb_page(vma))
> +       if (userfaultfd_wp(vma) && !vma_is_hugetlb(vma))
>                 categories |=3D PAGE_IS_WRITTEN;
>
>         if (!pagemap_scan_is_interesting_page(categories, p))
> @@ -3028,7 +3028,7 @@ static int pagemap_scan_pte_hole(unsigned long addr=
, unsigned long end,
>         if (~p->arg.flags & PM_SCAN_WP_MATCHING)
>                 return ret;
>
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 err =3D pagemap_scan_hugetlb_hole_wp(vma, addr, end);
>         else
>                 err =3D uffd_wp_range(vma, addr, end - addr, true);
> @@ -3470,7 +3470,7 @@ static int show_numa_map(struct seq_file *m, void *=
v)
>                 seq_puts(m, " stack");
>         }
>
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 seq_puts(m, " huge");
>
>         /* Skip walking pages if gate VMA */
> @@ -3499,7 +3499,7 @@ static int show_numa_map(struct seq_file *m, void *=
v)
>         if (md->swapcache)
>                 seq_printf(m, " swapcache=3D%lu", md->swapcache);
>
> -       if (md->active < md->pages && !is_vm_hugetlb_page(vma))
> +       if (md->active < md->pages && !vma_is_hugetlb(vma))
>                 seq_printf(m, " active=3D%lu", md->active);
>
>         if (md->writeback)
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index 53ce414d9d81..dfb5dd3bec40 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -486,7 +486,7 @@ tlb_update_vma_flags(struct mmu_gather *tlb, struct v=
m_area_struct *vma)
>          * We rely on tlb_end_vma() to issue a flush, such that when we r=
eset
>          * these values the batch is empty.
>          */
> -       tlb->vma_huge =3D is_vm_hugetlb_page(vma);
> +       tlb->vma_huge =3D vma_is_hugetlb(vma);
>         tlb->vma_exec =3D !!(vma->vm_flags & VM_EXEC);
>
>         /*
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index d7e6563cef75..24727ece20fe 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -251,14 +251,14 @@ extern void __hugetlb_zap_end(struct vm_area_struct=
 *vma,
>  static inline void hugetlb_zap_begin(struct vm_area_struct *vma,
>                                      unsigned long *start, unsigned long =
*end)
>  {
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 __hugetlb_zap_begin(vma, start, end);
>  }
>
>  static inline void hugetlb_zap_end(struct vm_area_struct *vma,
>                                    struct zap_details *details)
>  {
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 __hugetlb_zap_end(vma, details);
>  }
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index d6b38556be36..d8ee0ca63ccf 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1609,15 +1609,28 @@ static inline bool vma_is_shared_maywrite(const s=
truct vm_area_struct *vma)
>         return is_shared_maywrite(&vma->flags);
>  }
>
> -static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
> +/**
> + * vma_flags_is_hugetlb() - Do the specified VMA flags indicate that the
> + * VMA is a hugetlb mapping?
> + * @flags: The VMA flags to test.
> + *
> + * Returns: true if the flags indicate a hugetlb mapping, false otherwis=
e.
> + */
> +static inline bool vma_flags_is_hugetlb(const vma_flags_t *flags)
>  {
>         return IS_ENABLED(CONFIG_HUGETLB_PAGE) &&
>                vma_flags_test(flags, VMA_HUGETLB_BIT);
>  }
>
> -static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
> +/**
> + * vma_is_hugetlb() - Is @vma a hugetlb mapping?
> + * @vma: The VMA to test.
> + *
> + * Returns: true if @vma is a hugetlb mapping, false otherwise.
> + */
> +static inline bool vma_is_hugetlb(const struct vm_area_struct *vma)
>  {
> -       return is_vma_hugetlb_flags(&vma->flags);
> +       return vma_flags_is_hugetlb(&vma->flags);
>  }
>
>  /**
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 0b332770abee..74cca0e3c726 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -888,7 +888,7 @@ struct page_vma_mapped_walk {
>  static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk=
 *pvmw)
>  {
>         /* HugeTLB pte is set to the relevant page table entry without pt=
e_mapped. */
> -       if (pvmw->pte && !is_vm_hugetlb_page(pvmw->vma))
> +       if (pvmw->pte && !vma_is_hugetlb(pvmw->vma))
>                 pte_unmap(pvmw->pte);
>         if (pvmw->ptl)
>                 spin_unlock(pvmw->ptl);
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index a6c8e38a3110..8ca8a6842924 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -9808,7 +9808,7 @@ static void perf_event_mmap_event(struct perf_mmap_=
event *mmap_event)
>
>         if (vma->vm_flags & VM_LOCKED)
>                 flags |=3D MAP_LOCKED;
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 flags |=3D MAP_HUGETLB;
>
>         if (file) {
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index c75b5c50af30..ae6c1a606eb5 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4211,7 +4211,7 @@ static void task_numa_work(struct callback_head *wo=
rk)
>
>         for (; vma; vma =3D vma_next(&vmi)) {
>                 if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
> -                       is_vm_hugetlb_page(vma) || vma_is_kernel_owned(vm=
a)) {
> +                       vma_is_hugetlb(vma) || vma_is_kernel_owned(vma)) =
{
>                         trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNS=
UITABLE);
>                         continue;
>                 }
> diff --git a/mm/gup.c b/mm/gup.c
> index f5dc227bd6e1..66b306911703 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -621,7 +621,7 @@ static struct page *no_page_table(struct vm_area_stru=
ct *vma,
>          * But we can only make this optimization where a hole would sure=
ly
>          * be zero-filled if handle_mm_fault() actually did handle it.
>          */
> -       if (is_vm_hugetlb_page(vma)) {
> +       if (vma_is_hugetlb(vma)) {
>                 struct hstate *h =3D hstate_vma(vma);
>
>                 if (!hugetlbfs_pagecache_present(h, vma, address))
> @@ -1213,7 +1213,7 @@ static int check_vma_flags(struct vm_area_struct *v=
ma, unsigned long gup_flags)
>         if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
>                 return -EOPNOTSUPP;
>
> -       if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
> +       if ((gup_flags & FOLL_SPLIT_PMD) && vma_is_hugetlb(vma))
>                 return -EOPNOTSUPP;
>
>         if (vma_is_secretmem(vma))
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index befffadd978e..cf6c50e531f5 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4754,7 +4754,7 @@ static inline bool vma_not_suitable_for_thp_split(s=
truct vm_area_struct *vma)
>                 return true;
>         if (vma_test(vma, VMA_IO_BIT))
>                 return true;
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 return true;
>
>         return false;
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a69bd463b1ae..d93235491cbc 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1146,7 +1146,7 @@ static inline struct resv_map *inode_resv_map(struc=
t inode *inode)
>
>  static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
>  {
> -       VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
> +       VM_WARN_ON_ONCE_VMA(!vma_is_hugetlb(vma), vma);
>         if (vma->vm_flags & VM_MAYSHARE) {
>                 struct address_space *mapping =3D vma->vm_file->f_mapping=
;
>                 struct inode *inode =3D mapping->host;
> @@ -1161,7 +1161,7 @@ static struct resv_map *vma_resv_map(struct vm_area=
_struct *vma)
>
>  static void set_vma_resv_map(struct vm_area_struct *vma, struct resv_map=
 *map)
>  {
> -       VM_WARN_ON_ONCE_VMA(!is_vm_hugetlb_page(vma), vma);
> +       VM_WARN_ON_ONCE_VMA(!vma_is_hugetlb(vma), vma);
>         VM_WARN_ON_ONCE_VMA(vma_test(vma, VMA_MAYSHARE_BIT), vma);
>
>         set_vma_private_data(vma, (unsigned long)map);
> @@ -1169,7 +1169,7 @@ static void set_vma_resv_map(struct vm_area_struct =
*vma, struct resv_map *map)
>
>  static void set_vma_resv_flags(struct vm_area_struct *vma, unsigned long=
 flags)
>  {
> -       VM_WARN_ON_ONCE_VMA(!is_vm_hugetlb_page(vma), vma);
> +       VM_WARN_ON_ONCE_VMA(!vma_is_hugetlb(vma), vma);
>         VM_WARN_ON_ONCE_VMA(vma_test(vma, VMA_MAYSHARE_BIT), vma);
>
>         set_vma_private_data(vma, get_vma_private_data(vma) | flags);
> @@ -1177,7 +1177,7 @@ static void set_vma_resv_flags(struct vm_area_struc=
t *vma, unsigned long flags)
>
>  static int is_vma_resv_set(struct vm_area_struct *vma, unsigned long fla=
g)
>  {
> -       VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
> +       VM_WARN_ON_ONCE_VMA(!vma_is_hugetlb(vma), vma);
>
>         return (get_vma_private_data(vma) & flag) !=3D 0;
>  }
> @@ -1191,7 +1191,7 @@ bool __vma_private_lock(struct vm_area_struct *vma)
>
>  void hugetlb_dup_vma_private(struct vm_area_struct *vma)
>  {
> -       VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
> +       VM_WARN_ON_ONCE_VMA(!vma_is_hugetlb(vma), vma);
>         /*
>          * Clear vm_private_data
>          * - For shared mappings this is a per-vma semaphore that may be
> @@ -5269,7 +5269,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb,=
 struct vm_area_struct *vma,
>         unsigned long last_addr_mask;
>
>         i_mmap_assert_write_locked(vma->vm_file->f_mapping);
> -       WARN_ON(!is_vm_hugetlb_page(vma));
> +       WARN_ON(!vma_is_hugetlb(vma));
>         BUG_ON(start & ~huge_page_mask(h));
>         BUG_ON(end & ~huge_page_mask(h));
>
> @@ -7495,6 +7495,6 @@ void hugetlb_unshare_all_pmds(struct vm_area_struct=
 *vma)
>   */
>  void fixup_hugetlb_reservations(struct vm_area_struct *vma)
>  {
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 clear_vma_resv_huge_pages(vma);
>  }
> diff --git a/mm/internal.h b/mm/internal.h
> index 04b1f1d3d960..104bbca1eb57 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1116,7 +1116,7 @@ static inline bool vma_supports_mlock(const struct =
vm_area_struct *vma)
>                 return false;
>         if (vma_test_single_mask(vma, VMA_DROPPABLE))
>                 return false;
> -       if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
> +       if (vma_is_dax(vma) || vma_is_hugetlb(vma))
>                 return false;
>         return vma !=3D get_gate_vma(current->mm);
>  }
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 73c2901b9adb..2db11c832d0f 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -880,7 +880,7 @@ bool madvise_dontneed_free_valid_vma(struct madvise_b=
ehavior *madv_behavior)
>         int behavior =3D madv_behavior->behavior;
>         struct madvise_behavior_range *range =3D &madv_behavior->range;
>
> -       if (!is_vm_hugetlb_page(vma)) {
> +       if (!vma_is_hugetlb(vma)) {
>                 unsigned int forbidden =3D VM_PFNMAP;
>
>                 if (behavior !=3D MADV_DONTNEED_LOCKED)
> @@ -1413,7 +1413,7 @@ static int madvise_vma_behavior(struct madvise_beha=
vior *madv_behavior)
>                 new_flags |=3D VM_DONTDUMP;
>                 break;
>         case MADV_DODUMP:
> -               if ((!is_vm_hugetlb_page(vma) && (new_flags & VM_SPECIAL)=
) ||
> +               if ((!vma_is_hugetlb(vma) && (new_flags & VM_SPECIAL)) ||
>                     (new_flags & VM_DROPPABLE))
>                         return -EINVAL;
>                 new_flags &=3D ~VM_DONTDUMP;
> diff --git a/mm/memory.c b/mm/memory.c
> index 28c1bb7b93af..9a38c7d4cc40 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1564,7 +1564,7 @@ copy_page_range(struct vm_area_struct *dst_vma, str=
uct vm_area_struct *src_vma)
>         if (!vma_needs_copy(dst_vma, src_vma))
>                 return 0;
>
> -       if (is_vm_hugetlb_page(src_vma))
> +       if (vma_is_hugetlb(src_vma))
>                 return copy_hugetlb_page_range(dst_mm, src_mm, dst_vma, s=
rc_vma);
>
>         /*
> @@ -2178,7 +2178,7 @@ static void __zap_vma_range(struct mmu_gather *tlb,=
 struct vm_area_struct *vma,
>         if (vma->vm_file && !reaping)
>                 uprobe_munmap(vma, start, end);
>
> -       if (unlikely(is_vm_hugetlb_page(vma))) {
> +       if (unlikely(vma_is_hugetlb(vma))) {
>                 zap_flags_t zap_flags =3D details ? details->zap_flags : =
0;
>
>                 VM_WARN_ON_ONCE(reaping);
> @@ -2313,7 +2313,7 @@ void zap_vma_range_batched(struct mmu_gather *tlb,
>          */
>         __zap_vma_range(tlb, vma, address, end, details);
>         mmu_notifier_invalidate_range_end(&range);
> -       if (is_vm_hugetlb_page(vma)) {
> +       if (vma_is_hugetlb(vma)) {
>                 /*
>                  * flush tlb and free resources before hugetlb_zap_end(),=
 to
>                  * avoid concurrent page faults' allocation failure.
> @@ -6933,7 +6933,7 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *v=
ma, unsigned long address,
>
>         lru_gen_enter_fault(vma);
>
> -       if (unlikely(is_vm_hugetlb_page(vma)))
> +       if (unlikely(vma_is_hugetlb(vma)))
>                 ret =3D hugetlb_fault(vma->vm_mm, vma, address, flags);
>         else
>                 ret =3D __handle_mm_fault(vma, address, flags);
> @@ -7797,12 +7797,12 @@ void ptlock_free(struct ptdesc *ptdesc)
>
>  void vma_pgtable_walk_begin(struct vm_area_struct *vma)
>  {
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 hugetlb_vma_lock_read(vma);
>  }
>
>  void vma_pgtable_walk_end(struct vm_area_struct *vma)
>  {
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 hugetlb_vma_unlock_read(vma);
>  }
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 2ad0a5f18280..aeb99c5933cb 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2021,7 +2021,7 @@ bool vma_migratable(struct vm_area_struct *vma)
>         if (vma_is_dax(vma))
>                 return false;
>
> -       if (is_vm_hugetlb_page(vma) &&
> +       if (vma_is_hugetlb(vma) &&
>                 !hugepage_migration_supported(hstate_vma(vma)))
>                 return false;
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 0c437004329d..c38cbaaef5a4 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -743,7 +743,7 @@ int migrate_vma_setup(struct migrate_vma *args)
>
>         args->start &=3D PAGE_MASK;
>         args->end &=3D PAGE_MASK;
> -       if (!args->vma || is_vm_hugetlb_page(args->vma) ||
> +       if (!args->vma || vma_is_hugetlb(args->vma) ||
>             (args->vma->vm_flags & VM_SPECIAL) || vma_is_dax(args->vma))
>                 return -EINVAL;
>         if (nr_pages <=3D 0)
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 4bf26b0f1e6e..98449f364af1 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1786,7 +1786,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm,=
 struct mm_struct *oldmm)
>                 /*
>                  * Copy/update hugetlb private vma information.
>                  */
> -               if (is_vm_hugetlb_page(tmp))
> +               if (vma_is_hugetlb(tmp))
>                         hugetlb_dup_vma_private(tmp);
>
>                 /*
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 3985d856de7f..506f005adbdc 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -500,7 +500,7 @@ void tlb_gather_mmu_vma(struct mmu_gather *tlb, struc=
t vm_area_struct *vma)
>  {
>         tlb_gather_mmu(tlb, vma->vm_mm);
>         tlb_update_vma_flags(tlb, vma);
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 /* All entries have the same size. */
>                 tlb_change_page_size(tlb, huge_page_size(hstate_vma(vma))=
);
>  }
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index fe32fd87cf5c..a1b6d29bf039 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -717,7 +717,7 @@ long change_protection(struct mmu_gather *tlb,
>             (cp_flags & MM_CP_UFFD_RWP))
>                 newprot =3D PAGE_NONE;
>
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 pages =3D hugetlb_change_protection(vma, start, end, newp=
rot,
>                                                   cp_flags);
>         else
> diff --git a/mm/mremap.c b/mm/mremap.c
> index ed19b47c2caf..1122282a1d6a 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -812,7 +812,7 @@ unsigned long move_page_tables(struct pagetable_move_=
control *pmc)
>         if (!pmc->len_in)
>                 return 0;
>
> -       if (is_vm_hugetlb_page(pmc->old))
> +       if (vma_is_hugetlb(pmc->old))
>                 return move_hugetlb_page_tables(pmc->old, pmc->new, pmc->=
old_addr,
>                                                 pmc->new_addr, pmc->len_i=
n);
>
> @@ -1735,7 +1735,7 @@ static bool vma_multi_allowed(struct vm_area_struct=
 *vma)
>         /* Known good. */
>         if (vma_is_shmem(vma))
>                 return true;
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 return true;
>         if (file->f_op->get_unmapped_area =3D=3D thp_get_unmapped_area)
>                 return true;
> @@ -1758,7 +1758,7 @@ static int check_prep_vma(struct vma_remap_struct *=
vrm)
>                 return -EPERM;
>
>         /* Align to hugetlb page size, if required. */
> -       if (is_vm_hugetlb_page(vma) && !align_hugetlb(vrm))
> +       if (vma_is_hugetlb(vma) && !align_hugetlb(vrm))
>                 return -EINVAL;
>
>         vrm_set_delta(vrm);
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index 28e306fdb3a5..8408aee7571b 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -109,7 +109,7 @@ static bool check_pte(struct page_vma_mapped_walk *pv=
mw, unsigned long pte_nr)
>         unsigned long pfn;
>         pte_t ptent;
>
> -       if (is_vm_hugetlb_page(pvmw->vma))
> +       if (vma_is_hugetlb(pvmw->vma))
>                 ptent =3D huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>                                       pvmw->pte);
>         else
> @@ -206,7 +206,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk=
 *pvmw)
>         if (pvmw->pmd && !pvmw->pte)
>                 return not_found(pvmw);
>
> -       if (unlikely(is_vm_hugetlb_page(vma))) {
> +       if (unlikely(vma_is_hugetlb(vma))) {
>                 struct hstate *hstate =3D hstate_vma(vma);
>                 unsigned long size =3D huge_page_size(hstate);
>                 /* The only possible mapping was handled on last iteratio=
n */
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 7411702a37f5..e6493bbe6919 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -408,7 +408,7 @@ static int __walk_page_range(unsigned long start, uns=
igned long end,
>         int err =3D 0;
>         struct vm_area_struct *vma =3D walk->vma;
>         const struct mm_walk_ops *ops =3D walk->ops;
> -       bool is_hugetlb =3D is_vm_hugetlb_page(vma);
> +       bool is_hugetlb =3D vma_is_hugetlb(vma);
>
>         /* We do not support hugetlb PTE installation. */
>         if (ops->install_pte && is_hugetlb)
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 01e7b6b046b6..f90f029bfd5c 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2705,7 +2705,7 @@ static int unuse_mm(struct mm_struct *mm, unsigned =
int type)
>         if (check_stable_address_space(mm))
>                 goto unlock;
>         for_each_vma(vmi, vma) {
> -               if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
> +               if (vma->anon_vma && !vma_is_hugetlb(vma)) {
>                         ret =3D unuse_vma(vma, type);
>                         if (ret)
>                                 break;
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 79cc7b546f13..949017e60608 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -237,7 +237,7 @@ static int mfill_get_vma(struct mfill_state *state)
>         if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP=
))
>                 goto out_unlock;
>
> -       if (is_vm_hugetlb_page(dst_vma))
> +       if (vma_is_hugetlb(dst_vma))
>                 return 0;
>
>         ops =3D vma_uffd_ops(dst_vma);
> @@ -804,7 +804,7 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
>                 }
>
>                 err =3D -ENOENT;
> -               if (!is_vm_hugetlb_page(dst_vma))
> +               if (!vma_is_hugetlb(dst_vma))
>                         goto out_unlock_vma;
>
>                 err =3D -EINVAL;
> @@ -967,7 +967,7 @@ static __always_inline ssize_t mfill_atomic(struct us=
erfaultfd_ctx *ctx,
>         /*
>          * If this is a HUGETLB vma, pass off to appropriate routine
>          */
> -       if (is_vm_hugetlb_page(state.vma))
> +       if (vma_is_hugetlb(state.vma))
>                 return  mfill_atomic_hugetlb(ctx, state.vma, dst_start,
>                                              src_start, len, flags);
>
> @@ -1114,7 +1114,7 @@ static int mwriteprotect_range(struct userfaultfd_c=
tx *ctx, unsigned long start,
>                         break;
>                 }
>
> -               if (is_vm_hugetlb_page(dst_vma)) {
> +               if (vma_is_hugetlb(dst_vma)) {
>                         err =3D -EINVAL;
>                         page_mask =3D vma_kernel_pagesize(dst_vma) - 1;
>                         if ((start & page_mask) || (len & page_mask))
> @@ -1172,7 +1172,7 @@ int mrwprotect_range(struct userfaultfd_ctx *ctx, u=
nsigned long start,
>                 if (!userfaultfd_rwp(dst_vma))
>                         return -ENOENT;
>
> -               if (is_vm_hugetlb_page(dst_vma)) {
> +               if (vma_is_hugetlb(dst_vma)) {
>                         unsigned long page_mask;
>
>                         page_mask =3D vma_kernel_pagesize(dst_vma) - 1;
> @@ -2149,7 +2149,7 @@ static bool vma_can_userfault(struct vm_area_struct=
 *vma, vm_flags_t vm_flags,
>         if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
>                 return false;
>
> -       if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
> +       if (!vma_is_hugetlb(vma) && (vma->vm_flags & VM_SPECIAL))
>                 return false;
>
>         vm_flags &=3D __VM_UFFD_FLAGS;
> @@ -2319,7 +2319,7 @@ static int userfaultfd_register_range(struct userfa=
ultfd_ctx *ctx,
>                  */
>                 userfaultfd_set_ctx(vma, ctx, vm_flags);
>
> -               if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_shar=
e(vma))
> +               if (vma_is_hugetlb(vma) && uffd_disable_huge_pmd_share(vm=
a))
>                         hugetlb_unshare_all_pmds(vma);
>
>  skip:
> @@ -2895,7 +2895,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, u=
nsigned long reason)
>          * (sleepable) vma lock can modify the current task state, that
>          * must be before explicitly calling set_current_state().
>          */
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 hugetlb_vma_lock_read(vma);
>
>         spin_lock_irq(&ctx->fault_pending_wqh.lock);
> @@ -2912,7 +2912,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, u=
nsigned long reason)
>         set_current_state(blocking_state);
>         spin_unlock_irq(&ctx->fault_pending_wqh.lock);
>
> -       if (is_vm_hugetlb_page(vma)) {
> +       if (vma_is_hugetlb(vma)) {
>                 must_wait =3D userfaultfd_huge_must_wait(ctx, vmf, reason=
);
>                 hugetlb_vma_unlock_read(vma);
>         } else {
> @@ -3744,7 +3744,7 @@ static int userfaultfd_register(struct userfaultfd_=
ctx *ctx,
>          * If the first vma contains huge pages, make sure start address
>          * is aligned to huge page size.
>          */
> -       if (is_vm_hugetlb_page(vma)) {
> +       if (vma_is_hugetlb(vma)) {
>                 unsigned long vma_hpagesize =3D vma_kernel_pagesize(vma);
>
>                 if (start & (vma_hpagesize - 1))
> @@ -3795,7 +3795,7 @@ static int userfaultfd_register(struct userfaultfd_=
ctx *ctx,
>                  * If this vma contains ending address, and huge pages
>                  * check alignment.
>                  */
> -               if (is_vm_hugetlb_page(cur) && end <=3D cur->vm_end &&
> +               if (vma_is_hugetlb(cur) && end <=3D cur->vm_end &&
>                     end > cur->vm_start) {
>                         unsigned long vma_hpagesize =3D vma_kernel_pagesi=
ze(cur);
>
> @@ -3831,7 +3831,7 @@ static int userfaultfd_register(struct userfaultfd_=
ctx *ctx,
>                 /*
>                  * Note vmas containing huge pages
>                  */
> -               if (is_vm_hugetlb_page(cur))
> +               if (vma_is_hugetlb(cur))
>                         basic_ioctls =3D true;
>
>                 found =3D true;
> @@ -3917,7 +3917,7 @@ static int userfaultfd_unregister(struct userfaultf=
d_ctx *ctx,
>          * If the first vma contains huge pages, make sure start address
>          * is aligned to huge page size.
>          */
> -       if (is_vm_hugetlb_page(vma)) {
> +       if (vma_is_hugetlb(vma)) {
>                 unsigned long vma_hpagesize =3D vma_kernel_pagesize(vma);
>
>                 if (start & (vma_hpagesize - 1))
> diff --git a/mm/vma.c b/mm/vma.c
> index eb2b4501a677..ab570e0a7f16 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -599,7 +599,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_=
struct *vma,
>          * boundary.
>          */
>         vma_adjust_trans_huge(vma, vma->vm_start, addr, NULL);
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 hugetlb_split(vma, addr);
>
>         if (new_below) {
> @@ -2228,7 +2228,7 @@ bool vma_wants_writenotify(struct vm_area_struct *v=
ma, pgprot_t vm_page_prot)
>          * Do we need to track softdirty? hugetlb does not support softdi=
rty
>          * tracking yet.
>          */
> -       if (vma_soft_dirty_enabled(vma) && !is_vm_hugetlb_page(vma))
> +       if (vma_soft_dirty_enabled(vma) && !vma_is_hugetlb(vma))
>                 return true;
>
>         /* Do we need write faults for uffd-wp tracking? */
> @@ -2347,7 +2347,7 @@ int mm_take_all_locks(struct mm_struct *mm)
>                 if (signal_pending(current))
>                         goto out_unlock;
>                 if (vma->vm_file && vma->vm_file->f_mapping &&
> -                               is_vm_hugetlb_page(vma))
> +                               vma_is_hugetlb(vma))
>                         vm_lock_mapping(mm, vma->vm_file->f_mapping);
>         }
>
> @@ -2356,7 +2356,7 @@ int mm_take_all_locks(struct mm_struct *mm)
>                 if (signal_pending(current))
>                         goto out_unlock;
>                 if (vma->vm_file && vma->vm_file->f_mapping &&
> -                               !is_vm_hugetlb_page(vma))
> +                               !vma_is_hugetlb(vma))
>                         vm_lock_mapping(mm, vma->vm_file->f_mapping);
>         }
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 245f68c75b28..9cbfb90b0ad1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3413,7 +3413,7 @@ static int should_skip_vma(unsigned long start, uns=
igned long end, struct mm_wal
>         if (!vma_is_accessible(vma))
>                 return true;
>
> -       if (is_vm_hugetlb_page(vma))
> +       if (vma_is_hugetlb(vma))
>                 return true;
>
>         if (!vma_has_recency(vma))
> diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/includ=
e/stubs.h
> index d6136e19a8af..48d1dc53df42 100644
> --- a/tools/testing/vma/include/stubs.h
> +++ b/tools/testing/vma/include/stubs.h
> @@ -193,7 +193,7 @@ static inline bool mapping_can_writeback(struct addre=
ss_space *mapping)
>         return true;
>  }
>
> -static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
> +static inline bool vma_is_hugetlb(struct vm_area_struct *vma)
>  {
>         return false;
>  }
>
> --
> 2.55.0
>

