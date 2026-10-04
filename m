Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B8BACA5FF9
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A9BC6B0099; Sun,  4 Oct 2026 13:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186E06B009B; Sun,  4 Oct 2026 13:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0499E6B009D; Sun,  4 Oct 2026 13:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0C286B0099
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:19:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E1F41A0B62
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:19:25 +0000 (UTC)
X-FDA: 85285605090.01.BF31586
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 46AE8140004
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:19:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LIoveowK;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791134363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LB9YQVahVaEWF6zZVDiq8xpdl9rxBex8+tzU6TEVUNY=;
	b=TcBajXDoYepIBDxCHUSJJ88TPUvjQVRfGYMxv/QxzIqGYBdjzQrOHJhDYNPaduC9oQ6tnm
	v4XodMoUEP9dydOY5W2doc08pPlj0/TpxkCyN2LJBCcwkjI001ssGuiXPTvXTTDONL0XhY
	C0lgn/yM7/W7o8c4mTH6UfLnS5VvPnQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LIoveowK;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791134363;
	b=ncI0LeIajSibC8gfO5mplrDAWPOU6jiUEp1xgNA+c2LSqR//K5BDaS8tXaxlPxKM5w9+Rm
	XEqHYEeFS/qWniiSxlirMEVwqsSiuzcyao34B9NwgysF/H2uCJWFoSCEpl0sK/5FE/Bgok
	hpHH0S6geWYZ5/H7u3IVTjWz7JA1gCA=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5337fa12431so180771cf.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:19:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791134362; cv=none;
        d=google.com; s=arc-20260327;
        b=AnB9Omsmbw8rFhPwBDvRJIePcv3O86DVY15udqw0wJqms5c+X/SfLUGxK2zF/dqnFI
         3MGfe9TDDL9BWjXItJmeZ5b29EsIDy50JN9D7vHbWZkQb2/YqZ2x9nyxHZZB4Nd1Zs+9
         Kq6reGpaDp818nr7xDyPsCoYg4TGekpaGxGaxa7hMyh+8wDBU9Ud7g7wSgAPoyBa0ENv
         KJcyany2Rwvg+t1xGDvgXK5aC+tT8ZZ/xu/2Av/jH05W8fdoDXhy6+/MaHEnKtCxHWZE
         Iuo7Ic/lh0Szjd+uc2DusOMyLtotHAwOK06GXt0DODi5OpqqrbNHfRtbSkHC9nGZr6gh
         tGYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LB9YQVahVaEWF6zZVDiq8xpdl9rxBex8+tzU6TEVUNY=;
        fh=pS+V9qPGmpUFcasrAXDUWypyCNY6q90/Mq/pK6nhJFE=;
        b=eJQaKCKmDUy1t6yTxUhk04TP8rSLnBCQ5yMVEZDHllCiiRttZ7WJa/THkTvgFMFRKy
         hJOGleMrQt4LPOeZC28TFpLeJ3psHcsVLKw5XTY8jO91ZWrx/9tgogN/C/g/FH5nnJ1N
         ZucI2zcM7Y7RZPfWni6Cb7s+C4g8375lahNvmdfg5SnFIO4snbYN094muHUgjB2W6iYL
         b5gjrvkjijgRBXYPN+Yog9XYbVqB1GlihR4jksTxEhmWPR33AJqq9jiXX2TTwGFrVfqw
         mcbwwxb7kCC5h3IrkAdK85vm3+St6/wcc/1JopEEEdy+U5op/OGgbfAsP+Bcw74uqY4v
         iiNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791134362; x=1791739162; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LB9YQVahVaEWF6zZVDiq8xpdl9rxBex8+tzU6TEVUNY=;
        b=LIoveowK5+3OdEQaE73pMDmitHfWxva+w6H/90i8rhHyTm/Z1kZ/+ksJMAYb62fZHt
         5rMIm28zE27xVxaQ9rHogFER/56POVEzxoiYc6Ioq8D4brxSwour4KrZhMAsxwNRhqZ3
         JOCGJbPqkJOel1/9B6qS9n8ZORd/VvmlTElbJi22iWM8JiXT4mUetNyOF4fQUbXAMbuL
         Fg9sOtyryxvlRWWgqS4kDPgFn9Dv4jJgknAgtkYqEEK2Aej1XWnRKeN8UeF7V78Zd6JW
         HvYibfFLAZFoUXPiwML5gHeVZlNYVDJI+joeJ4Crxj08F/DqFKAp8pT4pV93j3mZ1yqZ
         /d+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134362; x=1791739162;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LB9YQVahVaEWF6zZVDiq8xpdl9rxBex8+tzU6TEVUNY=;
        b=EWvHbn2oIYFzi2A8NYbfcG0d077ucRpUQOXCXpT7S5rviUesO5fT9ow5yf6+i3yllo
         Lyx202bt9UkS7REiPmhqt40GoYe5AYtKMGWXDU1nYvbK/FM8lo4ijPUl8grcbkVYvwDO
         x4pj9fBScz02uKVN1emPVgrjTe37TqseV5m0TEaMt9oEnfu1+EYZPQJugqoMWSgpx8E/
         EwQjCZAWKoJRDMphNyRazxEqvgraX8ERuqGxUKH1tWIjMpKn/Te2AtuLmaNqHw1yaCgP
         LKv1P3pmR6bSAVLP5nX5rHUBNlE5b0+9ZpIQzqK+a2gcBQkincReZY0Cm3qDXfh2F6H5
         TLmQ==
X-Forwarded-Encrypted: i=1; AKwUvBwRGzrzjWWcFWrgBQSVeNYAL5EkTETKL3tYKJf4X5+MH0Q1Fd0LwKPKiiL7scS6lk1Z+G9bvgCBsg==@kvack.org
X-Gm-Message-State: AFuF++mCRlmUKcS9YXxd0BeBvrgX8kR8KgAvUD6G5Ff9psz4EASZpsp0
	4BeC46VeoE+8HtOllmiVGuuXIweJhBtDNIIySoaymfEmqpJhBXQfT1Bh1fE1Y0n48Awyi9dYy/q
	FViyA7vl3ROH84UXMthJDTTlCn4nc8CaxNR2tAR1Q
X-Gm-Gg: AYBFou3xIPgbqEX1HBC8GODuvz2gXhhdfd6jMYWJWFPzCCMoQehnKKE91bwI7W/egR/
	KksJBO3+IqR33+AHYegYXcOPh3mtSHruhztEzgmVqn4AYxdM/4kW07OIQ9TyWswZQl1FDGA8fL5
	gN9mv0dQ+2MjH1arvc9NiVP+8qp0oGxi66gJuA7Gr350COR1dRTcUjDO/nCfRwp4EMNv4cfrubF
	Y0VxCRSnawCkFD7j0WliFMTzrYG9a8dM3GCaIqhheoNhbttrLgi974YdnUu0f3kcUx1Ew+6E7f3
	iGyBOsYZemAFNY6XbdzWoMeTEy0V+/aI9oPsPEO1k1YpxxzRT2Gz5f947w==
X-Received: by 2002:ac8:5e4d:0:b0:532:8423:1e78 with SMTP id
 d75a77b69052e-535131e75aemr16242571cf.10.1791134361196; Sun, 04 Oct 2026
 10:19:21 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-11-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-11-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 10:19:09 -0700
X-Gm-Features: AclHuK8q5domRMZg3DAHzMyB2slG297Lp1_L7hWmlqEUWco5tu_MI_s_DzFbhWI
Message-ID: <CAJuCfpGdJM=J+6tkzid_Mu+7nevdhFaTW0E9tbKXoLmzC951Fw@mail.gmail.com>
Subject: Re: [PATCH v4 11/38] selinux: reject writable opens of policy file,
 drop mmap shared/write check
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
X-Stat-Signature: kah7j18c7qri8zfi41t5n78xp8e5fgtt
X-Rspamd-Queue-Id: 46AE8140004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791134363-431806
X-HE-Meta: U2FsdGVkX1+Qe5Wjkz8/IC5YOfibfiFhBJ4F11hrLsbzIOB8gKVCQQemremwCBTLYzh4BeGcI4/UH4ukyBavGM5qoX+nngls67sUUY1EiE1IcBRnAEu33eqz5GT3p2TfjNDewsAdmXm75Yn9If/dYbkZVadNS67s9Nh54F3N/+o6l7SqjPfBIHfQCaT0fZLIzsS55dzlJJ2DPQ8q9Z/NfBREdLq1QH2+2bEysb5BEkRwoq1zc1POaLKPEQ/PFXkYYduaJ2GxiSMzdaiCF2KtuCciiVD1/mmIhMtUZAU6FX17ng3/ML6sfGi3PRRqVKfQk4ZiF8gp8QTiOCrFsSQ0RBayfjeZ01X1M1mGAY/n81xGA4cJVU0NzooMCjFKXHl2zONlWmkm7cmlokJXhlkBIHq/Aey5Atq4rN12B0klNNGkJqHY1oRZKKwH7tFg3URr6T0b6EqWY9UeEScfDl1MzP913sjkFehVEyqUbtU50U2/SKBa5PbVnkjBZJDTrZuu+yFbeGlX66Y0CnEk8+ldx4kcmtUu2xoWZK0UqWDgJgejtvlakiyfCqQmUomSj5Kj/olazP/tmebTTnSkX/50IB3Ad8EZJc0/U7zmt2aIrkUn3A0+1f59imrK60xY8rZDQ1nmHWVUseMq5QEIEZ4tKEAAJ98Lr6MyTawrmnfU9z/TgHJ9JRBd6JsamBxP1HeccZn53dhkDuVV2q9UfV18v5f0qQIsRf2WAI5w4sYBD4n9f3xR9xL7aF5YP9SnPNpOZXuejsGEafxuVPnL521CYHbbDFDggCWGYgusQKasAqp1qpJLEmRw+4G+A1m/RjdjiXw/+b/2PvkeG1eEJ+uQZTRIjD4OXHtijUlszap/ak2E/r0VCORSSo71jijw/XaEQPhPMDQ4O88gkv/c5/ENjT9tYJHF3aFCnjjOMh8GJvq7A/+jzZTssXL+YZAu3K08mMsA1flQ2wUNYoWbpcv
 ZwjS6+od
 v0Hs8B5PkfXDlHpGA+Ga1wa5r9CBlKipiO0DkX5pPyQyvY84YWKTtHA9NQ+nJBQk6RmvYwsNdLhrUjMPpI7XulRHKbKQpLUr8aXk8ATCnfKwFfim/3Md5Dl7RsY3DId688+bKzcp8B75zSxA6xtTgJBjzOWmGL49Y5ZiSMm62wDNTrlWqWCTyiz5ehnJx4U5N+HE9igwHUKcMiGpWt7IxhIj3epno6WDi3WMuho7e6pCFrGU/jxOqUl+V9J/KHd7DsPqzezynEBwnsXB4oQJ06O2ULltweSLvzCL+TJZmARQOrAm1b1v895oCadRuISuDbQ5OT8Ux7DmiVWFAQx+f5Z1LihbPm2TCcTP2DOuv1+5wDBj0jEF9+LDSmYRLr04wtjeEiBtflWJNRm6YFyloR21t9a8luwEEYcGUACi7YSaMfYeAnNfkWFsdIbB4Y59uCeTyhlddc1QvlzkYk9IN3UnZ3MzQKs/3rglCUvHGIN67k82dhWOOjkIP61spq0Hd0ZjRM60YFF/zRmZuJFUrlBOUqUxTy+mov7DgtpHC53ivSx7wrWd8JCGTs0J7JXd9qBf8hvdv6vbSoTFLj6CrXytZftq6Rju/cv4xQhMviingsWc+5j1FtX5EGhWyCUZ1UXqCjMxW5IpjoUBmqEUCjILPw+z6L6Q/yjRP1O8LvEayvFo5Bt8xyUx1JexwNvm0SkF3PeWPeCq8aZfULBtXFdQzfWH0sJ9pekgJnTeNTbJ1t4CSpViLWUpco3A3b99B2Rq7Bf1B8ptRcoAessmmHq4irtr38fXWn4ciu1kXNE0mNHbqA9bj5RvTsrdy+fhiaKllAQoyNinKBtKfp3tWXHjP6Ncty+QuUc/iJRvuQl8SvqAbY8K5KmUb22KnPBWZYu0Akk++ZXLm2GqqzpFGtI8DEOMYXwju5q//0wYAxfgYEY+6TAyPpUOtOA7hdRIO7NcZeUg2BGWrjl3Z7+IdwzrVVrDt
 IRowA4S1
 k0Q6/h18qPxOEIlCEsqem6A3mmCa8CISCOLZ7Vb7uf9FqEzobzIjP5friGwt6VebWrm/z7/L/68o9b4NDICMWcS9p6rmyVHSaeh736/wKC/JJscjlMnWX4lVL18k+92Y8ygNVClBaQs5i+H5qDRWiy4KUiXx0jQWrhk66/T9VPMt69KKbs27gdV8vh9zmUI19OlVvHN1W23AY7MnofrLrL9xojCnumkEnLf2Zu0+1ZDPX1RrcgM+pXlDorrmuurV0LFWoBIa+EXyMfXGK7g5Ii3/SnIE40LuEUheLdDS5JHPoWtRKMtgdKc+Aqvz2q66K0T1n2aOejxlvGRHQ+gqeR6XP4M7dNibf3H9ljjXduF9maEPsjttIb/0GGshHF761LhS1mZobvU/PvTMsqe7Pu2JCl90rescMoty+l2nz8/DuwFtlH5Mn0uPvl7wNfhIFTwh09HtFoe88nQD9DCgsR3mi2DXGTax1AHmT0OqPl0A2Qar9BBvhrc8rPXDsxHVZ2X/U7mclKvSda/+swy7S7e5/bV9KFg8u+C65o+7T8xZgIGGzGAZd8xv/gedHIy/9RvtuYJ1v7zx6+D6Ar4kxTKiBTAD8p2EEkSzByhCffZ4H64SgAnp0pl4TjQt/2undHuG0xU+qnaM76nVtky86G3NcI3FPY2tjwYzkPlBtHVmecyEyBjXsWqB+RJzB2ECKxxfhdLG9iptdM3A/iG34PmzFOEUIOWFH9YY8dcRGsXkp3K5PBdnQ5zX7AXdTHJEKFl8J5ZyYSBpbFT2FgkWDJpUnLvO3CiiAhzpf5nKPE6wEIXXTqOesn7AE8/40n3qgtAfdc+pnOei7XRCio6Rlezcu10z++lHqTUyWl4PWsYaRmNzdl0ZUGqnPO3/lehj5i2YupCxpvleYwPNTnGYWmZy9k4y989wYjmjNL0bCfd1hSr/PWdGw6xbjoWOIGeUKY3qI4HypjUrgJppfNJ9MSKc+BK+k
 WinWngE+
 z3Fc50wQRRjO4yMCUvLKk5wDXLmY0/M128b1in/4GJS062Jnvav/EQ+oXGT/R1r0jJjCL07ftxePV8oFiD/xQVsmzP+FQsp67EL4TMUwuEqDxxBDa1V5Iya81tbv73PJTd4bkYuI+ytV3QpjWxNREgUszHtsjgRp5Zy1cTXiwGpJqktmObnEud6A6RgQyeq8cejOAn7+iZ5zzlYHNFDT8vC/nrAloAmAu3g3ZjcjofR6u8oeed+4TS9JXhvJibnOIxSqBmdcU0MEP94GIgGrAT86WdHcLU5lt0IHTKHxF3YHj0cNhz0EnUzMdGXxAVgu9pJb36KZpyeduV9lpwcxPpSKV0BbZLI/tQ7T7M633OOO3iDDPASW9ngxNfAEdheMJA14QncrHHtRWdFQQhamw8X1fm5Sq1ueqJb6tCRkf+yX8XCgYmRvCxfP7lb7LZx3kfxHtmfkgvd1bWZXxxBjOSxxEOgOOApSEhPZwqD0fhxtQ/pZSkWBWma47s61HLVuha9drMyVyWDUf34xFb6B8OAWcJ9gH/lmGDHEYrI8aV50ZpSXFdTUv50/JLxBWnv+bAKr/ptYZCcH4oRPNGahYvoNjUtZ+T3AZ2eho/07fenVbKnkb0iw04wEL1G+DlqQj1FqRWn4gwog51C6QWGYq5X1icBoQ/MUIUjSuU5c82xTK5IWY3jXKbi70GwO4THiWjhZFFavlMdHrTDHJzy+O7dtvPnmknP0ZQIF8kLU/8tLavHm00L7b6NjsxQnauRwVmJ3Wwnvgg42x72DRRoFMwtO7DncWyVpLdG4hZmx5lNngJwxGtufx52rZFhAHqxR1kxcsEn3lPjlY8bSQedIfAKBLBUYvCcqFj1PO3JuhhSpETGI0mMTBA6aHKhBHPFHIfN2Zu3YQ8L/Reas+cz7VPfdwOWhNZWgU3/6CJRWhppK8KVB6YUzv5wFOsvI7IBUqaRU9rQx/Dryu+qYwMR5AOvt55B0l
 MLisabPu
 VVpTKhCEw3eicT4jawHawvOIm8jD6Zp8s+29xakjHxOvokzoAsWG7iIrhio5O98rqrV+EDG9zOcWOkW0uWX8Y3xbviFwwNRJTbs/0H2LVOkYsMaTJEmfvsLI40NrBowF6YM2t5IbkYdCdU5DEQjsXXCvc+bGncqiwVOFuZ1fCHQ3kkKZop4U72T1a7ZdJwY7daFKzp3IVcAt++gECdaq9DiB8D/dnv+jeLNR9PR5oS8oTvAhDgWGYxBail3GVHtRmNldu8bGWvI5EqmU19N1qGu8bm34gEZnNbrQ/3Whk4tz1vM7+7aC5me6P/zrTrn/ZS3IzMCDPdat5xjlA8xQ1FxPoJmG09Me0JRibpwsgUla7l3T6pMEIg0bPTawWez95aqkFaUEzAc0WLjUY/2HVqkOYw4uQVZEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 6:37=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
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
>
> This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that =
is
> neither a PFN map nor a mixed map, ahead of the core enforcing that only
> such mappings may do so.
>
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Acked-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  security/selinux/selinuxfs.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index c7d91476971c..545a6f89f9e7 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -340,6 +340,9 @@ static int sel_open_policy(struct inode *inode, struc=
t file *filp)
>         struct policy_load_memory *plm =3D NULL;
>         int rc;
>
> +       if (filp->f_mode & FMODE_WRITE)
> +               return -EACCES;
> +
>         rc =3D avc_has_perm(current_sid(), SECINITSID_SECURITY,
>                           SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL)=
;
>         if (rc)
> @@ -424,14 +427,6 @@ static const struct vm_operations_struct sel_mmap_po=
licy_ops =3D {
>
>  static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma=
)
>  {
> -       if (vma->vm_flags & VM_SHARED) {
> -               /* do not allow mprotect to make mapping writable */
> -               vm_flags_clear(vma, VM_MAYWRITE);
> -
> -               if (vma->vm_flags & VM_WRITE)
> -                       return -EACCES;
> -       }
> -
>         vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
>         vma->vm_ops =3D &sel_mmap_policy_ops;
>
>
> --
> 2.55.0
>

