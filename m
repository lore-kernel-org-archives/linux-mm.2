Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B09D2CA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0FB66B0098; Sun,  4 Oct 2026 13:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8656B0099; Sun,  4 Oct 2026 13:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB09C6B009B; Sun,  4 Oct 2026 13:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6622B6B0098
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:43:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C31E080433
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:43:33 +0000 (UTC)
X-FDA: 85285665906.23.69DD0A6
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id CF3FB100003
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:43:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E8e1rkf6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791135811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vMNQ59LV7QrrLF0PW8JXbsDZwLj1dza/KEaeRbY4SzE=;
	b=INLMkQoYQ0Njc3jgiiSTGyaxXj3u9OdESfCCOm0WOsqjg5zxFcRlxqQrv5ZW3IM5G/Conb
	/lZ1MQaNDpv54adabu/Nl6XwalXwnpsl7GDFWmX7evzYa00QBJc31WF8lO/yP/zzWw5Fs9
	l9nWakyiv6yj0dYF9DRxFxi2gKMvGPo=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E8e1rkf6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791135811;
	b=UxUtC1RKwDW/4LFHp7qiF/O0hEvA+JQGYCd1LfphMRZTuoyzuHauT6tsMiqX+WXhoEnRYV
	oAhd0wBjp70U/f+uNNkBVglGXeZPTO9zVcVo1C7emUFPssxegv7VmcL0A+uRsXHPaMcktq
	gh5mCx/KNMtnMY4iyOUXA3rRgd3iYfA=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5351f9dbfe0so95791cf.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:43:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791135811; cv=none;
        d=google.com; s=arc-20260327;
        b=nZqbf5BxKIcU4HaFRM8Kd7XI5AfmCQ1QKGDUvrcmyunvkg1E6++7Vgi7DfuYLaCq2y
         hBrbNJNNjFp6zkvVuNTFrrftM/xtgAUP5OtOwnpQNhvEUmk12xZTzoLCzTaO/x3eODfs
         96lWZ/Cj41tJxdPHLOlcg/XVVI9fQgsG2bWId+H72cTsSRQ5wHWwmySAUs3yi1Z1kCvf
         WK6TLKj+XFuQwWOlGypPWALH81XT8PwHXKX16Avs6qGn86tpMl8sYsLLDYWg7p4O0L3S
         2A9eCoh6FRy+qMR9Qm/TxGRpdQmfWYi1b+LTovITU3KM6liunyLW4XbJ6t5uZeWgryNC
         QacQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vMNQ59LV7QrrLF0PW8JXbsDZwLj1dza/KEaeRbY4SzE=;
        fh=C+sywEOZI7S2kQt10fyt7+mM3YjgDLEKN/LPV2zPsX8=;
        b=iJyrhlnvi8JqWe+bahWO2I98buj8NqN0kBb05XnbOHs/wdX4zsfd7rxOUvfzArgeVc
         8iHCrSHl5SSHhF5SvPuSlaey2SwmOH/ORM/nJAhtzK4Jjer5yJjsDmMRUbAE5SaizdbG
         1Dkm686r2VCFYFoXPmM/h89AFA6zg30ijQkFsQR/Op6s0EPjsjTG6/xGHKpkg8VA7+WF
         BOfFLYyDTRkztTBOTFO8GoSTLaVd9fe8HFjXOt5m7zW0Icg4bbMe7HNg7WnGXowWUmD/
         2IDyO/ssee66QZ50b2g+WZDznDHIPE8fN2fog+Oa3pJumjt0J20FEHsfWfLZhvC+Q44m
         q9gw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791135811; x=1791740611; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vMNQ59LV7QrrLF0PW8JXbsDZwLj1dza/KEaeRbY4SzE=;
        b=E8e1rkf6jd+QNxarmFDuSy5o2WiRJaamZKHIQsMnvBSLv4WtsjBN4W9sSmtWBfYxH1
         P57lsGS3b9vzoZ1C8KZ//uPlLrvWaaGjbFLy7OrlfZ3INHsBmcPf5LM+TA7saHmRdHYh
         7IKPr3DzPDOrYnHshLFo4Df6Xynq35D6mD8QJP3iCS5E8b/k0x0J/40Rtcbpsy71xQaO
         VBuUwRxmHcUXbxKlqRfRc3WOuQj07UvKb/j+kexIrjvBgQkIGQyAA0lL82w3pSgh64U9
         3eHww6g1M+yQtKnar4rnPzrVKmfhuLt29/Y3UiaV2wcInXUt8sdbQCffGOD83ySimusQ
         xVPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791135811; x=1791740611;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vMNQ59LV7QrrLF0PW8JXbsDZwLj1dza/KEaeRbY4SzE=;
        b=fcY3MlHx1coSQR9NvVd5nF+QLJAuDweTaQbCDmI3v+dSbIkjOd0Iutl+wCcFY/k5sS
         /diWK/DUJXlFJg4V31ouyug4xmb4fA9QkYkdF24Fp9/v24wRSxN0jx1K/DL6CV7naQ2U
         HozjKP1Igzp7zYnnmWn9yXxrnBz0Oqi77Vlso0IejhGIUZ6rDIQR3BHEHXz/MdvwEBVa
         S01bE9+tyV/nwVaS/EzSNXurztw2OnvOSaRwBwHt9bM0Qtslv8g/77TE/gO0J1lY6o94
         nl9uMUfvrM6yCa02gEZGXOsrqSw/AObb4Zpq3x+J5NYYW62Qo8tPRdvoSZwA6LtUmqoQ
         OAPw==
X-Forwarded-Encrypted: i=1; AKwUvBy3Oal1nvtOX9k9XEMr6brP2qHyN4Rva4Aodz8u/fcV3goolSCSAEjsa2btGJorqKxJLZ93XsOhdQ==@kvack.org
X-Gm-Message-State: AFuF++lQGLR6dM5jegCxPoouwGRhIujk2GBlbeGRVf/QnL5akHTmhVjQ
	wlVaMtn9K0jzAa/wjU7M7wb1dlVDjPc3+j2T2s0scUKobePdVV2TecU8Dy7heJ9k32FevItbm21
	c52CLkNjattHEVmHI/zrgU3gEx/FV0YqNKcY8949V
X-Gm-Gg: AYBFou21E7FwHv6l2i6QGUIUL5+g0mGWRNA7gRYN+kQKREWgODJw+mEs9aVCyBQqLGN
	o9Lg7SXJddyFGe4h6qN1mtzooa5X9o14SNG5ZEZpmTL6DU+GwJzH+FNLzeMQOl2LFIriVhHAtYr
	D95Q9cBEmyL2nh8oIKvXU+c3HB1K2/A54PHkpotnv+UM70Am9gSCjYTQ6BaWmTW8pmxN4P8Rh/X
	W4sWGKjbsi2CznX9vNc27vMLXbFLTxoSQT78VqyBsw6tIIwnIsc8y2dYzU6Ju/yljpbHGm/K2mF
	VTfYgTNKOaagVxkoFprybfTwoK/SssHlz4zr6lWdGBpbTkFX0u8f0VDi
X-Received: by 2002:a05:622a:5c09:b0:532:eff8:3491 with SMTP id
 d75a77b69052e-5351497bae9mr16844861cf.14.1791135809929; Sun, 04 Oct 2026
 10:43:29 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-14-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-14-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 10:43:17 -0700
X-Gm-Features: AclHuK-Z2ieyqrFQLh5f1D20FCqfsVRqEWMyJIzhNXdOxd9iUhJDwyyLAY8lrcs
Message-ID: <CAJuCfpFounkD97p9iJ8zUunAMoOv+h8Tnxf2NOkp7qs3cfqs7w@mail.gmail.com>
Subject: Re: [PATCH v4 14/38] mm/vma: add vma[_flags]_is_mm_managed() predicates
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
	"Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CF3FB100003
X-Stat-Signature: 5pxys6cyinwwrgsndus6f7baeez4hrw1
X-Rspam-User: 
X-HE-Tag: 1791135811-777309
X-HE-Meta: U2FsdGVkX18FbiRu2WHeWc6c+3tVpNN0lQABSr1dxmfglIeVugsVwAAG39HqdW6JYSxannp0E1cx3xUEM+UcKiukz9Z1fjH+Z9xr9Soqcn6Jk/oq8yt/ebnclYXP6FP8CsN+3v97wjUY8EcbxSC5qXtntKaj7gqUgkjKPZA9ix48Qa/RD+iKh1CdH19pMUQSfiyQbBnA3J9utLM48wZJB8vT60zOcscAzv9rS3TWKpR2qXZkiwOPeZKbTAN1CfFG5Za/FBg8p3EV9Gb7Vbp8i8mIt72SRI1lrZpRQ9wg4GsKDoRC5qFRQLwqzGPZ2sXu9Up0Hq2FkhN8H5MfSRSBs+9Phd4gdu7Xg1yY7TwsURMG4Gt45L21Ug0ZHnrVycA1e0EbW79ef6t4m01DNTOe3Vle8wD8BQTZVRWCqsEZ1R2rLsNGZDZ11EqF7TaL6M9NydjjWPYBrmNJvY1vMhPyseUeHvhp0mV1iCu7nO28TjdhcHNE5gG34eq4J1sA0o6hSCg3vLlSK+N+6eFgfHFY80FwtBFRi7XJQyXWegQDZkhah85VVKYaUBIJkkL3l/fW42yHxMr4G86n7AOSUVngfdWlZo4eeMnAO8S1UdhLUR36bBABWgselo1EbfjLwxEDcOIGCw+onqcEJ9byE9JosU2meHCrdPWxwRfqqBgXP4narXb/XdvhXwHBsQuT98JxSkV4xIGL50uSZw6ivzuNUM/KmklMmKqQGFrn6zXa8rgG7FGRhK8dZAFGdVCKOoOIkJ5iwxln0kccA2ctFvMfTtu+ycmrBJgjZ3XA8gN+jjBuxde7LtMMHF7N8ADE9iv8jC8JMjMwNTKRPTss89CZI07rmSZL0mifNP0RwsKWF3K418DrNMRC+s7sppbAFEvdcDF+R+nfX9aZUrnueNs60OYVtndMquqiqDdRjF3T62Bx6NL+/F4nAXomhLi/aAk10SBGdk8sCdrL+dO6VEN
 KsOdaj+A
 5Mqi1b7E5wxhwycxyC20C4Yy1c+hUtxDML1K78z6JJdjutB4rnfLTohtTRr37WWu5vFIrZX5SgqA51S3daoBwQFo2vJNdLMpk9a44sw6w7KJjorep0uhjo9pSPVtqEY6+/JT20no+3NJ5TOs5ZcTg9nAKZN7i+OdMViWWx0aw7jHvGZQZ3MjqKp6JWZ9LPK1J1JuOLSLSNTPoZKhAT6oSR5F95sA23bsxGp0B2VZ0XRPulH1RjtlDsfzNKwDkPOL4bQG3DWySA4OwWJx1nQK5IJ5ANDYTl4wm3G0icVw4AH7Wd/e2IkcdlFFZvzhkosasPxBqo6HKbycMHT5rKBqfHgfulyixv8FOxENlaTGywSZLQV4YULCz/sVFqx3eXH4q+XBxieRGya9fwcgz5IzO5QSI6WWE68FTdbwOFlQHF+vWjW6vr46g36vQ7+W13WbC/hXsJEhOs22LW5OioyKzp7irDeBBkSJAk7tAUjE6TNFjPs7FHCwoUBcDzX2KYG1BKFd2yNFgbFVvd6l+t6ghsJrzycAUdCsp82S1HO/yCx28LbYoLxtU3s4uGNyfkQBGxB23m1uW5QtAWjK+PojqxZa94bpKTXo9KpculQLGWHvV0p5Kw4xSwJL/3BZpXWjb5ASIBNlzLiwig3sEoSjlGMOexcMoe17NZ8YRRNBQGd2LcDdxBNb8afNYh26qsLnBXgTLb1wEuAs2ZeSV+UZ9gJzsVCvuCwEVxTzn8obmlUVY1+RHm4Q4sbUUH+qzvHTnj0Hhd9N4+xo2g8tmA8QLcfHbruX36SstLL6kWdOx3TICj5id16N6RoCDQMQoGcKUgV+v5hlKfLMY1ymKftStXNCrxYqmiGgoCCN0MPdxPM4CWBJZNB2AmmopcXaJwhEUNQJv+wlUaKJQ/6YsnobJjrnls5ps52jdTMq/i/R5pE2/yOiJBpC6xajHgeKC2pknna7+XG1RUs7ZPjkQcwcvae1ltxYN
 OUbFk29w
 7zExsBEm2spNGM7Wy6Kw7No0MHYNBwm2Vf4uZKxEoOrImuK8WdFzu9ufD7nRTJPiqXZuQb0yrug1Bb/FgpmIL/texHQ65ZSowedyBCIUpRNYZDcH4Hk6sCSkb4wYUqMG6MVuQrVYk1NWsHOE55AaEj/CNhRR/s1pulqHVroTuTzrSjghkLc3s/JgIyYKMp3XNf/dsPg5XwhztBUuyIfiFZYF2AHJsUsyB8pdU2w/ndcp+d8iBt8Y7tod09HRXy21mHtbm5Y54p7SgZGhAk/LbtwRMskxFQMuDqYQGv0qpUxnSS7GxMw+1A2b3w6rnOPSZyzhlHu5orHuTdNVAZaVsJ7meWAfgvrMnvHMSZTfydiqxVLgNVU1zkmPbtoaK5qE5NAhXPHA43abu/gGWJ6/cJS2LPZuKZ15jZKBLlDKGrcYv2HvmFyvNKNF6yGZO+62HHDbUuiRJTh4MA4EbOfbL3z1YZ4me+GUPAHvee4ddoPYRPRBzakiaYyhLe+GSzYyVe8ndg2Bf6C5DmuYJMf2yyNP8A0RiTaYqnJoTkZgXYl9hde8Bq092QnuUcB9KPQuPnhLYeey05B35H3EJPqQFZ+ss5O25CejpOPtpxMeXdobzoQZ4V4YSJXLOUEu5JdLb2HCxRWKzfTjulvkQ5EeBh34fP180ljOWxXUN2dsvr0yTBs4LiJSvyC82RK69a7eCKi4tMqSd9tpwpZNidowIMCoriL+wYa0dzDJNm5ZrK656H2AR8JmxHrqpL2YER2ICLT7i3MhG+PxgPS2s964waSvZUfq6UXYU5eE6FiLB2APBAGo76hg7eFQfCfUeh3QRzStOIyy3hpHLqsNcPT3krNK5XlqKkQeS/RPXTXX9Y/vzlKt6qP/PTtEW5Cg+2om82WIjHs70OMoZoQJ04kbcJh/YLIF6vh5X2/cIWqRoLtWi8c1lum8GvqWIqschJTB9ef3vjB0bvDcETdTXSdHxatPJtRuz
 qFEc8GRn
 bkMmGh+R5EU1JQYgRKoaJbyHxMPJyElAYF43hF+dLSBYa17CYSraOVuAMswVA5K6eZR12h3lx15M9dieBA4iCu/ZWRqLGC4oGjmrIOt1Di+q3XmPT8ALEp68mQ8OaeSzt6BVhUoNG67dGPFSn75zHqhTSfwQqZ0l8ksvikhsvXc0EqfcemXeKKrSgIOLdzoB7LFTZ4swkgLbnNJPA2RgKafDfPnJdj5IEvLLG3txb5gdJIBHUtNEzAwPTQCxK2x3jG547OK/cQMYsVzaeTKMNW967ka03L0McyXwTrK1EpAOYT2FRib7pg1Emn7Jz0PkemyC+J98F5GQT9jv18gnUbpOZIOVkzxtWkR/uXyCDG5z7iW4dgs71skUphVN0Zz9paNrn/DkFWetOH1XVQ1A1VFsjiZhukYVOMW+E+21H7uaS9EblHX1EQKeDNdKv/OQyu5bmzQMPRGONTn66ox7rDlJaA2oo8V8FO5iHPAR7kQ10mWtfHAEjsE6WvN8YGUXVuynb4qzOKsTvh91QKMWWgOa26lPnXwUzRZdQZfz+rKl0jS9BEVsOYP7+HxeV7Q6hEcMrcv/FN6NDyqDQJoC257SzfqPDoV7p86BIxzrwEwyO0D70JYwNdWE7q6wKh17YsZsSscRcKg/pVdQUs+vNDFAMMeg1wUxtzR+VXwdlOwfAFBWJNKPbSB/UFF8SCkFNVFU6pAunx3pPg3Z1k/3gbOjGBwP5TlfEx+X788bM0Bv0XuRI3tQsAmG5eJepZ3naUH6gCNNuz0KgDprvgTR9oK91uAQigGzq3KN7au0OxDvbcU24XDauvdVtfiQLfYscdx8ZkW7YnYlU3N+PfpSklBglz40FCa4P/gLBplHqUZ7uAUUS6KcntbouFE9DxxPHc9bnPwDvsrfF0o82/UjukZ24jS6RqBRnskeQK0+iOlUrkh5LIYjp1YrBBxGCMQ35FVuAblhda7H55YIh0OL08XhoG9c2
 EjtjpO0g
 axx7IeFcZ7M353z/ekxBWoSD5MIVTrtOe6VjBzzWRRfhguZXjuakTcT8sQvXm9gLRhbhBmujoFr34OuoAMVm1cIzvXgXZkuJ2WPiX5BOPlZEsX2Y1CRvIuQehvRM7PEQj5c8JGZvpJoMzQBaBgLVYgUGdk1nPoNJxO/RPQ2cZ/Zn3md+wPSh9YI+uFsRvvvGKsz8iBoLLNUf2ldGmJ0U6gUy7sXqfPKGl+2LWd9CDWSF7aRfTCY06nU7lp2iDBNhGcF98ZxFId0RlNahvVSCNhaF8Zv6Rg1nNum/ESq4+ygEF59/5H0yiDnE9HwftR30OnFnlpX2JtbD3f9Q9fACVMWHEpLk1xPWau/XwJvPzL2yoX8A9QZqlq0BaXcWffNbB374CZFzSBjQwd11gwUbq3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 6:38=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Rather than referring to VMA flags with uncertain meaning, add a new
> predicate that explicitly describes what absence of the VMA_PFNMAP_BIT an=
d
> VMA_MIXEDMAP_BIT flags means, and then refer to that function for
> determining VMA mergeability.
>
> If neither of these flags are set, that means the contents of the mapping
> are managed by core mm.
>
> Otherwise they are instead owned by some other kernel component, usually =
a
> driver: the memory may be MMIO, kernel-allocated pages or even ordinary
> pages the driver maps itself, but core mm must not populate, reclaim,
> migrate, copy-on-write or merge the range itself.
>
> We initially also treat VMA_IO_BIT as implying a mapping is not mm-manage=
d,
> as by implication it cannot be. (mlock() also sets VMA_IO_BIT transiently
> on ordinary VMAs while locking them, which is addressed later in this
> series.)
>
> However the intent is to in future remove this, as no mapping should be
> marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.
>
> This forms the basis of further work intended to improve how we express V=
MA
> properties such as this.
>
> Also update the VMA userland tests to reflect the change.
>
> No functional change intended.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  include/linux/mm.h              | 53 +++++++++++++++++++++++++++++++++++=
+++++-
>  tools/testing/vma/include/dup.h | 29 +++++++++++++++++++++-
>  2 files changed, 80 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 97e1eb4fe3a4..83953757735a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1612,6 +1612,41 @@ static inline bool vma_is_shared_maywrite(const st=
ruct vm_area_struct *vma)
>         return is_shared_maywrite(&vma->flags);
>  }
>
> +/**
> + * vma_flags_is_mm_managed() - Do the specified VMA flags indicate that =
the
> + * contents of the VMA are managed by core mm?
> + * @flags: The VMA flags to test.
> + *
> + * Such a mapping is one established by a simple mmap() or brk() with no=
 driver
> + * or other kernel component involved.
> + *
> + * They are rmappable, and core mm services rmap operations including re=
claim,
> + * as well as population, CoW and merge/split (if eligible).
> + *
> + * Mappings which fail this test are those where this is not the case -
> + * e.g. MMIO, user-mapped kernel pages, udmabuf (pfnmap shmem), etc.
> + *
> + * Returns: true if the flags indicate an mm-managed mapping.
> + */
> +static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
> +{
> +       return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BI=
T,
> +                                  VMA_IO_BIT);
> +}
> +
> +/**
> + * vma_is_mm_managed() - Are the contents of @vma managed by core mm?
> + * @vma: The VMA to test.
> + *
> + * See vma_flags_is_mm_managed() for a description of this property.
> + *
> + * Returns: true if the VMA is mm-managed.
> + */
> +static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
> +{
> +       return vma_flags_is_mm_managed(&vma->flags);
> +}
> +
>  /**
>   * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to =
be
>   * merged with another?
> @@ -1620,7 +1655,23 @@ static inline bool vma_is_shared_maywrite(const st=
ruct vm_area_struct *vma)
>   */
>  static inline bool vma_flags_can_merge(const vma_flags_t *flags)
>  {
> -       return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
> +       /*
> +        * VMA merging assumes that a VMA's flags and fields completely d=
escribe
> +        * its state.
> +        *
> +        * However, mappings which are not mm-managed may have establishe=
d state
> +        * upon mapping not embodied in any attribute of the VMA.
> +        *
> +        * Additionally, private (CoW) PFN maps encode the source PFN of =
the
> +        * range in vma->vm_pgoff, which may otherwise cause spurious mer=
ges.
> +        */
> +       if (!vma_flags_is_mm_managed(flags))
> +               return false;
> +       /* VMA explicitly marked as being unmergeable. */
> +       if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
> +               return false;
> +
> +       return true;
>  }
>
>  /**
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index a6a8e53c4b38..89c645a6ad60 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1665,7 +1665,34 @@ static inline bool file_is_dev_zero(const struct f=
ile *file)
>         return file && file->f_op =3D=3D &zero_fops;
>  }
>
> +static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
> +{
> +       return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BI=
T,
> +                                  VMA_IO_BIT);
> +}
> +
> +static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
> +{
> +       return vma_flags_is_mm_managed(&vma->flags);
> +}
> +
>  static inline bool vma_flags_can_merge(const vma_flags_t *flags)
>  {
> -       return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
> +       /*
> +        * VMA merging assumes that a VMA's flags and fields completely d=
escribe
> +        * its state.
> +        *
> +        * However, mappings which are not mm-managed may have establishe=
d state
> +        * upon mapping not embodied in any attribute of the VMA.
> +        *
> +        * Additionally, private (CoW) PFN maps encode the source PFN of =
the
> +        * range in vma->vm_pgoff, which may otherwise cause spurious mer=
ges.
> +        */
> +       if (!vma_flags_is_mm_managed(flags))
> +               return false;
> +       /* VMA explicitly marked as being unmergeable. */
> +       if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
> +               return false;
> +
> +       return true;
>  }
>
> --
> 2.55.0
>

