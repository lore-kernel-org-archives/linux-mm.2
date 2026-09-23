Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C5DC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AC806B008C; Wed, 23 Sep 2026 11:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584426B009D; Wed, 23 Sep 2026 11:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4739B6B009E; Wed, 23 Sep 2026 11:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2416C6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:32:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A81CA40395
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:32:58 +0000 (UTC)
X-FDA: 85245420036.04.64E6405
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id AB548C0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:32:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YSezGbH4;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790177576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hKtcWNVFda3wl86zaKIN0hpMLzWuZcmeXVfEC0xSzRI=;
	b=vd8kp1/nSAv11hHOjUU+jYwXLdkmI2qN12yuLHpvKHfgT1AElBRipQgI3rqiSQt2yJR19h
	/HTJPs16QTIwtOJX3gWU64aYiBTlZzdzD5xY33wgkD91MwyPZcKNI42HxZPFMmg/pbogkp
	/V7nwb7RhfhpPXvJ0fkfCoCP0xr9KYI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YSezGbH4;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790177576;
	b=Wf8X2aJXwkYFpZZbuT4OrUeCLVJF5nee1dFAoroudntgw+neg8Wd7TOP6qAndEQzyO7nVD
	jkQLsPyUfckbaQ8rhE/zrHwEdvF0SwtiRct2PzQSyq/44734GBdpZxzyBTLknvBlcJXnzj
	Kz1zuW/kRSl61Vj3Oqgapmvye4ZG78I=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-530e8c6fb80so258471cf.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:32:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790177576; cv=none;
        d=google.com; s=arc-20260327;
        b=NWDRT9FBG7z36goSblokLIBlHHU0o4ZTg+D6/MCeyV5YcvjdoA6q2S1HpW9mYgO2k+
         AWOy8ZDcMugdEPhIZ75cZtMd2YSZi3sS3cfmWWqumvBJwuq3NqE0tM2oEs+kGkXs9ENN
         zQlC8Asid/uO30h8Z/GvrLB6oh73DSe/7ZUie86zlBfFMc7gXp2nZnVh1LgMIFjTZDj4
         VrAj6zu2IWd5ABphtCdPB8JcX+cc5YTCzsS0bwtsRMz1/3eQyes2q5CtUEDe7hNuFXfF
         73pucaGd0TUi8sBtWI/xzLpr7UIKTDHibk/oW0x9n9ovWaLnv/GgqbKOw7V3wLqeDvkW
         2A2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hKtcWNVFda3wl86zaKIN0hpMLzWuZcmeXVfEC0xSzRI=;
        fh=6lecb2eT43ppU0cm5tIwbKCl5ylntyAiQ5OoWyNlnZY=;
        b=I1k5L4M3vB6iyP8N2bfZV/goIBbG7K0bp5hItGKO+gbe0GfFbS5JZOBsGU8wsKvLne
         DQKJh5udmuLDGtyR4HN1XvGB/iBME97uRkSSQWm1pph2tjjLbYV6/OwsTLVmjaMXpsWL
         ivtpONkZrBkLycXNr19OQ8ua12uTXqiTuKoPzv8iHKqvnE+Q2y+lPG+PRSZj6hPrOoYU
         efj3YRtCzSHlqts+UrmS+pkXHD6f/YVsQ2gXVSIBlmfrXfsNuDLv4TSRs1O9Cfka662g
         8v3NXSTwqSFtXxeQ8zs84akLwrXW/f2W2kxKPB+9F+nTBwx6dM5O0ghIQhDhk/MTv/sl
         TNEA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790177576; x=1790782376; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hKtcWNVFda3wl86zaKIN0hpMLzWuZcmeXVfEC0xSzRI=;
        b=YSezGbH4M/xqk619BS9ztmmeaucGUJrt/LkbPo4hsEEhZQn8HVSaHogKzej2P0YW4B
         7BHx4o0zISJfq0uO1A/te6So/EqZeL6fU6pV7feHIxpVEne+6h5oBC8F9jpIkv3Kjqe+
         VgV/vKbKzkjrE8nW9uidf+Mtz3Ch08THEudUrVIYyjeHoojJzMh4bOfzfHSA1BzbIz1F
         tuOOvw0W2oDlsXd39S5Wb6KRzkRBWqETee1t6MelxHOt7rtlX157U/R1xk6/NCtPJNK7
         KZPZEKDauoWy34EOIH/vUg9Cfsk/xNz1Fdmb2rLgaBWuJjLuIES803CdPSVd76UTVOqN
         ZS4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790177576; x=1790782376;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hKtcWNVFda3wl86zaKIN0hpMLzWuZcmeXVfEC0xSzRI=;
        b=dJeRpxPfgGuJ1cLldhdMy43+CAnknqaq+g5i4HEa+IJTBS0EZ/tUQG2s+2R16yu5dn
         kIgrX9P2aaFQWiTWzvSBkRqAxFUVsFpQdPAvmwtZmPnIfjP5s9A+W51ixGnjyptGjddH
         UN+q6eldv+C8AMt7D+Uzklb0TjW9Qaat5ZnIaQY5VzngKK6+3bv4JHinPiuSKapV4r+i
         ru9u8BNr+2NxqoBPYUwEBhD/hIwM1+QoJMN5NvDjuJXXaEb9pTi3xstCzclXI+ESEKa/
         UZLmQtIINUXH4BMGn//zrop59HQEiUEIczrTWFjIArL3BJa4N+9sRGvf5NSqPEdUEQlU
         sw6w==
X-Forwarded-Encrypted: i=1; AKwUvBylnfH6+OkKM5lbZq8atGM0WcpBt+lU8zZ8eB8Y5Fj0SFzv0gbW+bHhfN2l//sUVgv5oQ8crPobhg==@kvack.org
X-Gm-Message-State: AFuF++kUiU6LA2jLMzDQ0Di27WfPYft+tamHUGACzOZyH95xY4tsqKQX
	wBnw+/25h6W7I3WsvrC3bhhOzvfSihOoFVInkHAG+hXQVTumOSHw7oS662CGECEiNhUTT4LhbKn
	KXm29t1wcv3B4AXVI0wuvfSu+FThCElZ3IqIwnKst
X-Gm-Gg: AYBFou2THaULhNtBm8zASe1xLAkBG1nxx1SLMwhZBTaIJRHojGyKVbu/wGCja3gRAzq
	2BTzF+kTGWs4SybV+45A9RRIuDJLHOqgFIRvC/+C+tt148BoX2riw0A5cAmOYBWnatq8AWcyntW
	rzg0H563y+DZtDtq2hRIMbh83zYbHlFBB66kQvLc6O1rgdP2joXy0YkxPDLcMJHMn7JPXqhQfNk
	wbf/MKpG9DLaTtbTPXHHnDyyWNODIrYdA7bjR5LaMtrbZm7QG+PcJLFgGi9RVLoTnKkzH4rlw8F
	b+D5SFR/qQu/TYTuehu/0LtdZfQzL9i3wDbjHJUgEtbrzmRTNO6hr6X0bq6ZTR2hN4veAOja2E4
	P+s2iuPbZNA==
X-Received: by 2002:ac8:5f13:0:b0:532:8423:1e78 with SMTP id
 d75a77b69052e-532f8eef5afmr573491cf.10.1790177574693; Wed, 23 Sep 2026
 08:32:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Sep 2026 08:32:43 -0700
X-Gm-Features: AclHuK8Inh8u6lJouEWaJf_8_dOxdEc__Ja8ROlufrRS70N8N3MQ9iMsAEM4G5I
Message-ID: <CAJuCfpEa8tUmYJBjx-cRdAE8y-jcKY0C81kAOa1QZS7F6tKdfQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/40] mm/vma: predicate setting mmap_prepare VMA
 fields on new vma alloc
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AB548C0002
X-Rspam-User: 
X-Stat-Signature: trconmntjr74xapox7or45pohzeimreo
X-HE-Tag: 1790177576-855013
X-HE-Meta: U2FsdGVkX199dwVtg7H9Nan1WZBm3ynkKaXFFtw+OdOIwjLTRnxVjB3IddAkiGw+KlHrjhMct9Fsrj3Mr9BVPOPagdBmCO3cIwgS2UVNIyZlUDC2sBOl+IcESJp6QqeDHm91ltDC+hhH2wpgWo5WX1BK1gEI6QezvjFdGzTUExin/CkEs8qhVJHZPymN5X89WDr6ojOyfsOpF41ma4vdoGfDpIxWQHqhZOj8YyagpQXHo6gpJ9/JQr+61bVCqdmeC8u1FVkHRx6kskMcCixeHw4LNJy2tIZXH1Vv7Saq4HKg92t02CQlCwGQxJeqYqJl9kJ+6g8Njj9AEta83XcFBVBY1ycKZtqM1K4AlzVkCXas5EsKd6tubSOYUqCC28lh+olmYch8aTze6A88xiYPSPQ78Tw46zbBcwu/kK0Pysyh+XFGqpR6t9GhpW7pfQ99sMm5HE76tas4DPRGkBI8ARanUAljBHKZt7xXxRIITZoeZm1lKYbl8NnMEX7TpXlXqH00pxPuCis7NC5CMgdm1GDZ4ju0/QY/dk2zVzWZjLwANuxvEe1JFiTD+NSwOQs6iE8gPz8Mbop4C75127Dgsu6P0VY3rANdwdMdHbht1ToSOHEf42S/kwri6TOlA32u8dL1U1VfB8jzwKGl4jUzIrscs99y5Xdtqxts1LjraEXt7GrL6oINvcnbMvmK8LCiZZLbzS3dy1FR85pjuosT1P3BhXMPxSPIUbLc5UJ44bakid2BiKWXKqB07VEyF0ifbRE93w46eKjm5hkwaAERSrMtvx+n0UW4/kefKyjKb6IigD/5H5/cMNStGYi8EUdj1RzFmky3+WxsRRtTlu5uljOOt+JgBIry5LTsLCkiMLIr2hMPjLgg49TYWxKdrD3s6yHFdJmyrbJqaOT1rTeMf6DJhQjx0uxyUzo9xFduhMHaAP86+IMe+q4EfkjCoJ2gDG0zymSWi0joUVupqxp
 2bOY4Shh
 hqjJv/J4Ozim/FOP8nTMn+TCXxvdaFxm07NUx4TC7WXMAZb+KH4ZCjAlWsc7TrpbRhvFIJ3MbH0kq+AnEjnrCyg+h+rw7ObgaOEHL7tAqQwS1XadynpAnlROJYn8Qss0aaGQom8M05ErviUV7gXPnnGdRTkjaeyPnpFl75wZjaogB9S/K2680YJsO1DzMiLLuczIejwM428ZqS1OfDuaIJIQNxKrZdOr4RVOkUIJP1J+ce9KpYjaqj/nDdN2RyaH7ePqgbGNN2yPr8YzKtdYKiKaFCTY6YXEQ+1kJN8yPkJlQpNXYxmJq+zY++Dy7ZzuDzZ8ojVL5qYg7Zeo9T8XfEH2QeL83ylAO6S8MrkUo/5mNCCWeqV/31/T4MfXTO4II1pSPmpOoHxNACy6D2980fdijsqbMypELb/QGifrRsXywTGZLPnR3L7BvaocWeL+x/sdp5aCRdQbkSNZuDLY5rg5D7Zan3sPtRoOVU8F8w5gaJl8QCL1xKiyv3hxDDOxXx6eU58AC9b6ppUQ88xElHyWKm0Vt4aiv1iY4qRsq2m2Zna/gUz59AQLvzvkZtQo753HSya1hz+icRp9lGvL+RC4mpChSETXEECwMbyEi23vEClYxzJ7UEJpcpPU6cCLpRr4TmfDbz9AmeER8Hon5QwunwogctLZfNm32HLAcTsC4gNijSKV/Dize2HW/ZFD1/jkw9phcNn6nhj7BQS7JP8TnoXiN27N5p6Ye0VYr929RbUE7xHFhFnJHb4KW7gO2OruQGx60PpORmyeUedrOfykLf5FXssjy+lEX49/3HrmA40KEx5wc1W+zMYFOKMsKIdsSAUo7deP82cHUhu458zzkIAf9coScN35xJ58xnbWHGoHu51JWIQTodqElufSZz2yo0qFG7J3p26i4T+BDitJg3+LH1a6FGd6b5J0MHvEjtKxOtMoTs95hV9pzSv6sa74Zr8A4EqvYDjcMDFrP/ChyJqjl
 XlkdTAwl
 dVdUGLNfaHbadVtqVDYyLwMA8RzHIMvkbgElZMWuklbJZS4WZPoiECKIW24UOQqY+xSZ6PDDX6AXR2MUKvNJ6ZgrnG18SbcmXjDG43itk2sKrCGb854mYXEWfiOoEtQ+job10OhRO546DzVRqrznoS9efKPyoKNXPIdKagi8GPVz34ow+OCL6wpb6753PmdNq/hw4Z8B7OLT2qdt23c0j4HsXEAB2EyirfPQuW6yo2yLFNFQQoym6461HNp0T3lK8LmpBMu4PHfQZsBsDPN2ZJOnmsE7gmWBdJeyMMBcQbnH8Q1A23vLlq4VtHjTNBQu+0orXYKZSjiPqFKwsFeR6VSSvykxaaCPN+m5Jvczkz+D64sxwvJtnV9EbEUegZq6+D5Gxqk7EQBABKc/XJHrr8m2qVZLN6isHmby8+htx2cnU0qSwDI9nAFlLjsFxKAHK/EaK/WfA3xHWE8KIzf5P5kOj3tOiQ1o1bUGmT/4iTz9pvHdzfFJP9qmR9Fo2t+chEVepBIL7eA1P+WpuOC66cJjyYnQda/0wJgs0YtMJXRVx/b4rsArNUiUrUSkfJLqgIHABWVfdaKpVLOWhtrqFL7BQSDKg/e0wuTonV+Y/Lk3g47pI8K0MWNywno21rYvBtXjKPq9wgXj3gjCClNMQo9KglCEJ/xQatrFE5HmTSTnDSavnz9BzTYUuFlHke4Y2kW64QflgEhNSxxd4hVhoH+muX1xNu5uaoK5K5+DFdfUyu1EnzXwAnnipgRaRppsqBJaN0NpEf79YbS2TAyGN00NBbs4QcUT0oyTrJdydtcUiA0PBITbWnAw3ftQQaTBqMJ7hsCzub6XFwnvcHzcn6HVUwyxMnBxe/7jQIflK/x2Dv8o1qEtYJOgg7vZ/VCm/WzqNw++Bx4Qgkjbwf0UoarOSD/5+JdCGInpwvMM1yjsawc801c3rdFYYUL0DDq7pcTeZzXjIUL6J0WTxutRmvAoOShE9
 bcNzukml
 Xlg0AR9jovR0Lxo61x/jg+K5ZeZziPBXrfZj5m4X08Pn3cJsqLmcORlnGBNofstmP7lwD6nkfc48vgLzD4iUG6rORpGcNmBGzvZnqlFhdSK1jSIWh2lZiwYG4rjgicaLwQzVBYbJE9X0sVnt1OHA8sy0g/0cmmDqgEe8DArCt4PM0IxvvYH4k6fjHyjQHMzUVc43qDunnH946JGNOMSQgrh3IPCsbKQerxyDaxbiAzSw0yrsa5qx2fvJpOOiUSc5c8vrmD9jWb/EuQKniEeecSD1fbyz1QG7pw9oGMGTWYgDXNsGvDViIV0TOPuiohB3qs0wfvsuv5lxToJ9Kcrf5j1ELEMfDzWsKdm4XaxE5T5OhSIFjkz45Zjrdg+JpoyMKfsED+3OCakfR1GKjM6yaJrxj7ZLvNK9jfe++oiRN1QQzAitEvrY+hk4li6jmdMBUVHvPXVSJmClAO8MHRcK6ZCw5V0vHzaAbhHCm0u2mq6LhxvCJEstGa6Aq+XszoH0JaDJ3iiBXHpGa/Jb/ucjElwRl6lstFefczg2IIuOP0fnOq6sVYJ87qyGPmCpezWSZxQmaMaJ26NB3S35hB+4ivaLozO+1nj5XNjKh44w+qmZ2fiubAs91gCOKyayYncjP0LuTpBmeE6xxB5brPtbhADNIb0OxYVA4hDkXN25R1IaCNkBQwnHvVhr6SLPHu84ztx8U18tOzixhydVfmGOz+eHHFt80PXJkGEEQhbsiIaOuh5XYzPF0reku1PR07pTrVtwAkGw+sQPORF9dQPsDJj/mdbJpo1xZ+er2OYPskPoc6eI1I7UHjeoT6HLod84W1O8Pv57Af1QpD4KVq8gcu/RcYI/tyYa0hEk/36bh9khfNVMn7U+sWGLUBIgizOCiN3oWE1y7PFHlQFtPQIM+uuowUpNkdN2g6ElOEKozlcdDXqOPdMo0qMbv/IVXo/oMdA7tTc+Fgei6soXCjRL8Nl6uJNUS
 qYkJ5zau
 8XaYcvQO3+0Blu/CKMbKV8vQKm8HHN667J8Z779r15uUKte6OrOuXzXPr0Y22O0D47JQYlMBxv6XwaZu0vWz1Qstz9NBBg87kOWx3xd+gg9nv48Q7s3NVvJlPHEp/RtbFpgHIlrPwWG7upv/1YxpuhT1yZQM6NaERkXLND3+2jtOUi86mw9HGxVa727/kfD5wbWIwai24bC/WWCsR7mIsiHV3OgwHc5IVPAZS+MzXXT13QNJTypWSCL7j7aacTcfsR1oodtyCc0nNNEzxF/UdzLWIY2pmUDmUqtqyUh+TIXf7LsWHeds7FbYQTfWyMptT9gbH8mW+WBKLNXYdcj8XK8XnoGCZwSkKyC0lNH10YBKKVp30hc3jz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 9:24=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> It only makes sense to manipulate VMA fields if we allocated a new VMA,
> rather than merged it.
>
> VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
> keeps its own, which is also what the legacy f_op->mmap path does since i=
t
> never touches an existing VMA. Previously set_vma_user_defined_fields()
> overwrote the merged VMA's fields with those set for the new mapping. In
> practice these are the same values, with rare exceptions such as shmem
> selecting vm_ops based on whether the file has been unlinked, so no
> user-visible change is expected.
>
> Make this dependency explicit, and additionally constify have_mmap_prepar=
e
> while we're here.

The fact that we might be overriding attributes of an existing VMA
that we merged with is technically a bug even if we never hit it,
right? If so, should we have:

Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")

>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/vma.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index fa784f069da4..4b74b48c29b7 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2894,7 +2894,7 @@ static unsigned long __mmap_region(struct file *fil=
e, unsigned long addr,
>  {
>         struct mm_struct *mm =3D current->mm;
>         struct vm_area_struct *vma =3D NULL;
> -       bool have_mmap_prepare =3D file && file->f_op->mmap_prepare;
> +       const bool have_mmap_prepare =3D file && file->f_op->mmap_prepare=
;
>         VMA_ITERATOR(vmi, mm, addr);
>         const pgoff_t anon_pgoff =3D addr >> PAGE_SHIFT;
>         MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_flags=
, file);
> @@ -2937,7 +2937,7 @@ static unsigned long __mmap_region(struct file *fil=
e, unsigned long addr,
>                 allocated_new =3D true;
>         }
>
> -       if (have_mmap_prepare && !map_is_anon(&map))
> +       if (have_mmap_prepare && allocated_new && !map_is_anon(&map))
>                 set_vma_user_defined_fields(vma, &map);
>
>         __mmap_complete(&map, vma);
>
> --
> 2.55.0
>

