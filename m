Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDDF4C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 14:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43276B008C; Wed, 23 Sep 2026 10:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A9C6B0092; Wed, 23 Sep 2026 10:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908BA6B0096; Wed, 23 Sep 2026 10:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 718016B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:31:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00BEEA6BCF
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:31:18 +0000 (UTC)
X-FDA: 85245264678.13.B1E6C8A
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id D731216000E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:31:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OoIRVqLu;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790173876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3IRQTfCkVu29EAhzhIq8HL8xV9bhN+vmwTvfaTzW1hg=;
	b=iWjbW5IcNeqPJRt1m32KTWZsM9Bb6Ga1PpbXm+sxrdarQwH9nPPMOaUY1bmPfxAZdDP/uu
	JaLz/wIhFX7YyDZzm5GGq/39Bbb/vrjiSruF4noOr6NVDeltsv7aQxV4G1OD1DnudyeHgH
	SRIibPH9TvkmIMnJbna9SrVEvbu384E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790173876;
	b=ylxESCcPgIXNbTA5Wg4ZmOCNmr3pgn1VrZSgXOPh3/EpReye8WadL0EYmb6II4AQUzWsaF
	Q4TL9C5u54V8xnQJ2MN/MjYiin6vkiXM2YAfx5KHIYk647Thr9//lhIMZce/FESxyLSqW+
	4PSe3uRCeAGRgR4jowYy5GKD1nZrsTw=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OoIRVqLu;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-532e9ad9a1eso208081cf.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:31:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790173876; cv=none;
        d=google.com; s=arc-20260327;
        b=lx5T/tDOYx2p7+z7rcFkn54asJbprchmMryfFT/3ZM9DpA7cRxl+l6ixAhTPxl0syt
         WeN8qu8ZtP9w/+6siKhmDCJHrVoOPH5u53Gy4MzPWli85LsgR0EKz2ToOfImSTbgTA1A
         hBw0dLDclcibmWSOQSyV0DC/YyZ5ikiqGFZ6E+lBk/kx3A6Kg0P9MMUMXQsVFY8vY7Q0
         bgzIlG2wU5PpWyNxkK8v6Vx3UXM+ClK9eaeyvVBu6vS6+YlaFkKcDvkbI8aPaXropuWD
         oW/iQYHiNqpcT+tEouggMomurxtOuN4Di0KhdGSwhWeIlueJpA64T5Z8VzIsPvRGpwyQ
         ZAQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3IRQTfCkVu29EAhzhIq8HL8xV9bhN+vmwTvfaTzW1hg=;
        fh=X6TsJNePW5YOuHN/MtgggSu/fWIawxi6G0AdfTvVRMI=;
        b=DlMTMJpl7wtRtNK7uV7gULlcb1YoBx/nOoC+ewbDHQf6rwq2pNZKosfB+bmtJQm4h1
         MluDUbPrTkhebXY1YOflEmvqvbdiM4yjPTp2UiMYPZJnh5YTEHLMXme4grKOxAgRqfMK
         cve0z0bMrcEXEownXbo1gF9bflpViq1+EdQWK42Q2ND4qrDEMW3zf9MplCqdHDXWB2zA
         99OWrLUEuNEDaCvu/jMJ0qtdKELxQbkM6DJMhdcC9om08FsHlqa+0QpiZgq+/ml73IbU
         9RMblNHQW/ktJIpuNTGwpxOeLAkG6nDMi0OrgZPrp6dNl5z4TpnAd+b/Lc90NXOOnso+
         mtxQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790173876; x=1790778676; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3IRQTfCkVu29EAhzhIq8HL8xV9bhN+vmwTvfaTzW1hg=;
        b=OoIRVqLuHEZAqkQA3K9rWbX9gjC1KLueZFZPKzjS82N3haSESlJ+y1q/56aiey42bs
         UJDBDN1y5eUwKW38LyJiaT5G/hhgWjwopndiy8dn15jfM7gjSI77IHCTo1P0sQIgRpdJ
         COBIp2PtjZKSf9AMTHlEZEY7wmQIv/LsxpE/jd/FbZxZOlb44N/3sI3LMtClCXiSEC5S
         QM0DJvHe4w64yQ+ZFQzBb3yuIJrM5lEbrgT4bh5N7W0Ph04zjd6auTmXOiBhuuL2YlkR
         TFtEGc3741XhWvyTw8LNiX9JQAKWMrxsCf+q5tHar4w88HbYT/s4S3wXtJnyEJUwSbxH
         Fshw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790173876; x=1790778676;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3IRQTfCkVu29EAhzhIq8HL8xV9bhN+vmwTvfaTzW1hg=;
        b=Rsc61n7wACbEy7KnUPlrhDNy/yScREDbIt8hVfC8dIYhGQI8LlTjE6KL5znBQCmiKB
         X7y3tKkNYK07NfOw7eY90rT/xw+UGDqVA58EJHVcQrdHUFQd2eWnb7UHqFUMqR1A9lw9
         Lctv+nnrfaSTw2ShBxjifvXoi2kdmZNUnHQEohzFo00CjtJHr7eVPd3h9s0tcsN2AXbd
         AARifZiZ+6zaQLy9blLXyJo2eofFdOlaOZNLA5Aez6D7eIBI/Z+fVWAuf84GmgpIbl9Y
         +bmvWOUBT5TsCtwD7np+k0vuzHx67OQZqEO/tWxZQnUdWe2OTLZPNdzj++Da4VeYSsMJ
         FQXw==
X-Forwarded-Encrypted: i=1; AKwUvBxUs0HD2Ql9ftNY/bZDKhc6mpysN+Hgvx95WrN9m8MgS8YvgLBamZR6a8oJwsksD0VGx/iQT4Mffg==@kvack.org
X-Gm-Message-State: AFuF++lKB/TKXugCfFi0gA4IBMYlbL4rZjNpJbTbUBYsFhpdLitUbWHM
	GNL7Y+cmdTSG/MRMPID5oUBaU9/SVEomBCd8Xg0xyDdRSxvFi5mPGOcStY8e75Ys+45vROBA268
	a6qYWSU5sjGLz/PGm9Kab1gxFOb3JqarhcFr9HpdS
X-Gm-Gg: AYBFou1Ia+K8Wxq9dDfYPUYrhrYOJu4ql02UFUEKF6ceBN3v9i+QzOWe/z2TzG78R9D
	FV59hvg8KQFNShZZwPgPikvaJg2GY4STy03iSXxw9yQgRvX5tKw1JZhwwdnH5z2V8Z/wNxHNiOu
	7kbEZi/pi7Us3T4LBDwusK9p3f80V0TgEFFFHtC6C9m+RjFU7qD5hZ9yiwZOuLu4HwlWRrfOVWA
	a65TjQp+TbMXYdNJBFB3f/8oPPaA6ehu+1o5G56c8JcuzaGNGNFMhF9ViqpE/QyezKPAZFnupkv
	w7xkBGnk6l7xEQjE+PEKLOHNSoTseJTqyddb4N1/UtnN9cBgCpT+G6zJFp7TKYNa7sQH/6KN3gh
	aG/4qIWQ+ag==
X-Received: by 2002:a05:622a:260e:b0:532:9d15:2e5a with SMTP id
 d75a77b69052e-532ede89b29mr14598791cf.1.1790173874906; Wed, 23 Sep 2026
 07:31:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914180811.057cba8fcc48d6e0b53a2683@linux-foundation.org>
 <0b064fe6-ddb3-4f26-a1f2-2e9dd88d590f@kernel.org> <CAJuCfpFBichJH4OcmSHTb1rOuQBT6k5pXeua9_KgpWjDBKvsYw@mail.gmail.com>
 <aq6kzpK7wPl3iFGe@gremlin> <aq6lW9FvL69QeA9H@gremlin> <arOCPN02xB7mykju@gremlin>
 <b007cd0f-29ef-457a-8e44-63ab26f3bcd0@kernel.org>
In-Reply-To: <b007cd0f-29ef-457a-8e44-63ab26f3bcd0@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Sep 2026 07:31:02 -0700
X-Gm-Features: AclHuK_ZGTwaB8ygIyiOyIIeQNRzbEtns-G_Cds8CuZ4q61CHw7YMjTifucik0o
Message-ID: <CAJuCfpHL=dHjT=O4S88ZBvT1DyodAtCL9QTryepzs3EMwoECDQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/40] mm: make VMA flag semantics explicit, eliminate VM_SPECIAL
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D731216000E
X-Stat-Signature: iujisbyob9uzq7g5ccckrm5by6b3q63e
X-HE-Tag: 1790173876-913420
X-HE-Meta: U2FsdGVkX19ZxtopvBQm3uF9X1AmPZFYLh7CiDIZ1gLsdGqua9u/HxbTdtnGtEbhYkS5Dxcyc2deNZ16m1VlSTSLbkvGSP3dL5+NBezsDrnOvz8U4KAdutp2LzGG+YToFCZvaXcwS6yfFj3KICnihaegSG9xSYE6K534IPUfM4LghgYJNOcjBEw6zOPShRMsUKicmzwUon3DDvQkBstrIWEEFSG/4r/535+39e8XTYZ3uXL0FY1L4K8NsW3dtkFjaaR64WOHSxOzCyPZ+xzg2txd5X1Vcun2s+fMX5k63hc++R0jNQ/k0wT/bF+rYQmJbAHBC2OtKX1QEj1fh9OiAZWFUQChoGgDGhuM8B2AZPR7ZoGEFAmfEGV+ppiB+nw7xs8ZleOERWJ3wJOj86vVU3MItWfC5vwntuYyAcOr6AqI5KaVRHeox6g46NtUikqZdBqk2bjpg5uieyi/n9dx7KB8Tm3ulcGBZVplA5FHb2k9cUzIPVVrpJyaVq5YNMjoiM1k4HwCLcVx1smzSypSZjxo4C/kS2HFd7IfUdsBpXauE2inXhcQ2lVVZwhNOOwjzfbYN6xmZg5sywZlB3l15DJ9thZYDzo21dhgS1/W37B+Ebzu5QDp5THJEcTkZIsCdIYu9srJMqQ3r06picr2B3b+T/2A1SnVxD8ECatNd7O/j+x3VN9vsaTrKzPElIJnHbT4CI7i1f52dXFtwlYO2Jn1qHzvqxC2pJAaEKZIUycNMvaTnxT2Sba8l0+WNr/U1lumc9d/m6aaFRGyYvCdiSCTHaHFEyUn0oizEtHNZ7AKyfF9AGiHfgxd7lZ53lty+2EV6lFGB2nSXO/1JWRFumfG3wNf08eUn7WlkgzvrFmP48x9VZlPJvpm+I5rs7VNpb9j6OCc56oUCBqGWlQeTvOxIMnBZj/uqFqeyK0cZzx7Jmyc3kvavMSycAmkz7Mp6daK2Kv8OQfUE8vFC5C
 9s3uWhis
 9G0G+rAwzZVN6vTaKloJ+pLbsPGhPVMozIV3rLa0yHxpQIBDcW4p9++py8V1lnnHbraY+8h9wK70BomxqQQYmhsKjRF71ZGucD9XKKo0aVBUNK2Az3ChF+0wIo5BYIf6ntGd00myPpMiFPzZ0kSVa3TUeH+HyVV5ZS9xr6n4gVgLRwsPDyalPeqFUSoCRY0i0UkqZ0X/x59Sy32bkhb3oWP7CiwBW3MkJPPPvAlM2xhWgkJ0wb89s9xny3AzKJcKt4+/xE52ePMMRzdSbS/ONjXf0QixwwARkvljlXvixM25BJj/7Ogcg4m1KbJzdL05A0jsvY4Ul5RHhHn4kjVAee1KmDj7shTmwEcgWtKeDO8ubZ0R0Zp/piZdheb2saCEFZSlI+i+kLqI1zzkaXZIkF8HYuMc3wN+tp4tIT1D4ArMKcAybUjGAD2rjjsgukNq29mwZEtlfGpnChgDAtKyn2jp3lnpAMQ2S1UZfTMD9lwNBn0UjDamP6VNgI5lpnOClHf7xm+882pPSrHg6U8rvPouBBk7fUEAwda+n4ZErSSePxdQvZWRMrhyEHHYOkO8vxNgtpAWFO1KGjaJ2t5mSomeymaQBVuXjrR3uCn/2JM4rvjUZb9qulKGRXjH0l9ziX5/a3r/9cbB/BEFV1UYzsb2mVjyVMUAwTG1wKN7ULwaBiaKCoLTIRavWlCiBldlFzKVxxI2m/kwViSm0km4gljGaO/BbQA0MpPPcx38s2UiDNeoJ8V++KV6nDkEviDr+0jZvAM+u4wPUbUvReKbnQQ1G2Vzb55feI0QGD+fD/W9VtIzZVgbt+WYP+iIyK75We7AxwfAv7j43cRkhV86QfF9ovHoHS9oKa7uwr7sJDlWYwcy11/1InQFjAXO2bscx521ImnkfuhFDA6wSifH5gRFsFHtt2DE7OKePOSXeGEvxt5+XonvTT0+NmzU63bboWvWguFFf1A7iIeYC8YyNi9dw0led
 icZoV/fx
 7pdva8UfAFYwTbZqIBTzQYH8f74IXpRykMIO9FTJ3TarkrJQCuoLTkDgFfJ3mDOTY9wB9RM9vumSQsFK8vh9ZRx7SqjHBnAXAGsLOi7IMBCOuT5vbyvLe05MVdTjXkgY5jUANoUOFp7rDxyTG2xsNu/iJd3s8Q+wnm1b/PBOIhsurkw5tJn+vsgW4FDnC+7XRZ4078JOaJ89LaWvLSBy04+w1wdO4TAVmrPL3ZZg0WhglH3jiNo2CrMGXAvJ6yfSGgG5tKJO6QXFifyV0CEs1Mr1BkuMxRsBHfjJX3TwTGXwonM12taPfzxx9taCONQcirX2X/xWGsc6LTB0vNI+Bd/CghKsqBMOkD1rl/VeI7/QEerp4dnXrKC9slyaxDYq/rqt4iXsEnLH+m67uhJSxGlUiz+yCJCqc0L8ZcVSHdtmz+hODqEejFW+rn5E9eJlQO7QBZXyW1j4UpIGHv+xKWxbfS6uEmA6nV3uUBzaq3wcNjVU/EQq6cvUGSvoN3AUcVphScDPv7nJ5/K0xV2/Ya0MnJm4wYtQJwDU9tXZyqPrymyB6tgUDnAidW3vOicviUSEBaihC3AOdkjvhsdZhALdcxLYD097LkzMPM+QEvKKxk41BCAPl8YXukeJWC3cLNf2p/jimq+Q4HR7tBA89cZR89KRq1oa3STFfPSdltZXWrD8i0smOsQUe6me661mUWqPvlZ8MyKHdl5qHwFbDiJ6FRR+qs6wj5+rSQ6sOpPmsydmoCqujVdhsbWdZThCQR1mxCPSVbrbB+JLXCSchHrONNbg3EGIOQF0VQz2gSUQnCHKwaECVA/9rkoXvbrNlZfvdSC4adc6/VNSFxlriSuBnVllpR+FJ/dMSf/nK2tlTYSxuWpnZYtjCQNGOs/iIavbNExx3mJkMfYDZA/VNXyrTIInpMBXDfw/uEqyKDVNP5hfn/kqrE8dhGQcqkkJrr5ya21FOPK2vWA7xHnDQH36tnBtg
 Lx22Smuv
 EgUu6EVjXvm+DZWu5WyLL4y1tUgaHN8XrhJi1n8Al/C2ailWTArtgaaPVPg8d573QV9QWsDRXceT9FOlBy4Y/ZCFF8evkRbLd1dS6gHjRzSHS/SrBp2/A6wfFPMjw7ksVukaDfF8ZsU21yi2qrEBSgKePyKpqpd09B4hPGxweQhIRo9JN7UwsOEbpVYrvWkYF+eRCiOJ4r1XYDc8xIqF8Tx4XMA/C6t6t1yFY8AczTqS1LU8YJui5UgNUgQVNaeSvIUWSPYHsX/EozXxj+cPOCPlPtZKvy1YJtiK6dGty+Y29CeH4taHwYmmjk+eRmIAxM4yU/raYBgGZIDD92HJ6GNXp/VdUPdAaqKJewA+LgCmPjSrHBWVPbxH0VvJxNAoHpQZ9PIJCV/AYZQ2bLNqVBn7PyOvfC+8RgizW9KSekAhBlN36+Fjw41oN40K2KdXNGCn5BZlbZbFWvnOVyH92BqSsU8w7auEHLnrIQefK0iccWc/dNMTxdTAvZCJSzj5LRHENYh6Pyz8ibu3DWSqOqsudDbdwBHDCUr5G3eSlNNO3j9QoPGsS/ISGC3DRc+qwYOLacUPc8qT7rTnDX3gDCbpqoS1CIrD9oONmNb9poAa4qOcTN2I1Mz+CMF7knfZEpZKy4seHzS0bIJOxmbqJEJ/xZWAzeZkaLT9zeEsvEalTU44ev66559DGu0Q5EIDzOa6ZwbB32O7W+o/HbILStQetlE0Mb9VUlOibDenHrkKNV/J4TEzNFLVmMtSLYyVXvRL/lxaRBSFt6WJp04PwvBnQlbiDyGRhC/GalEvQ4u2dyqkt3Pek/vPfJTONpO2EMtAN3T/sW2KD60gZndMjsLnnLjI88rCbmN24Nbhj/1ReTLb/NsZ+MbkzhhIeBqtK2/b8pE/Zc0rLtY53YBZU7Dwh4Rzx1TsHwNpyQVBWdU+N6eK6s7tgQQj0Pt4KmLBZE2mAFvEphv+44faQJlXdP1DUTo2q
 GreNp87V
 7jfvMseU2K1yvhjMnHTiP67AvOgjozxPwoxDeS3TFudcuyGTuvIu1/lW83AhczIp6UzN/lOj+nQASbzlM0+FrN+m8s1zSnNfJMVb2xLkc/owQCFAltJvi7DswVK8aAQy6TwiR6dKNGi5z+FUKm18gbDdvkzuAi3XwRkEbU5ikBPZlnUlG859+IYqx6xb7mkI0E4n0ht4v+ukhGYylBO0ssBx02jOgawGNv+GoY6kxY5mhwskwlBO2VK5Pya8kJmqbkTS+o8G4J0uDS460LX+CrApuymr9g6wbyNl+Bza9ttnLdk2oqt3ErtYh/RDClmslgePqiEXm5G7Tgooy9uYw/R3kJYVnldeA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 1:40=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/23/26 10:13, Lorenzo Stoakes (ARM) wrote:
> > On Sat, Sep 19, 2026 at 04:09:13PM +0100, Lorenzo Stoakes (ARM) wrote:
> >> On Sat, Sep 19, 2026 at 04:05:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> >>>
> >>> Thanks guys!
> >>
> >> Note v3 has been posted to fix a stupid bug in 1/40 + attack some very=
 trivial
> >> sashiko stuff
> >>
> >> https://lore.kernel.org/linux-mm/20260917-b4-mmap-prepare-vma-flag-san=
ify-v3-0-4583d8a23bca@kernel.org/
> >
> > Just a gentle nudge on this :)
> >
> > If you guys or anybody else has some time it'd be appreciated! (obv. th=
e v3 as
> > linked above not this v2!)
> >
> > I know the series seems intimidating but most of the commits are very s=
mall and
> > it's been in -next for a while.
>
> Busy with too many other things sorry. Its time will come.

Had to take care of the pile of bugs but I'm on it now.

>
> --
> Cheers,
>
> David

