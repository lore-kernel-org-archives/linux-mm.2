Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 678AACA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 12:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B176B0088; Thu,  1 Oct 2026 08:11:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5796B008A; Thu,  1 Oct 2026 08:11:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F886B008C; Thu,  1 Oct 2026 08:11:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E29D6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:11:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AD5716024E
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:11:58 +0000 (UTC)
X-FDA: 85273943916.17.580AB1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 284C34000B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:11:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aTTG82Se;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790856716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUH7OP4iWerRy/EG23fSkrllMLjJHrglwjsFo+POc+k=;
	b=A5Zuhm1g3jsFdiz5lCZ1i/VIcyp6ZnqMMkDjU2ec6LYhROQYwna/ds8+MNG28k3HIX8emg
	7aRHSE7i5TpF6SCuww7kaEb+QaUPsv982EyOLY6x3lbU3h5B9+YuU+BorKkcFa+iFmGiJP
	FvLfS+jENSX/YJutLKQdYERot7DtLWA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aTTG82Se;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790856716;
	b=Jv8C5KlGjCRn7rRkozjWP1YGs7bUXO11Xh3lJK4Tj3WMEskpCeecXjHUEiKTDW5ucaR6Ov
	GLVBGaqUr27q0Brly9lt9XUQWjp1ZWaUqpmCdncLREBPbXmxZsZrf2kwOnMKNPLTlHH1V+
	JWv1vudE6pd0uUEzDkbFX3b+s9AlBa0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 19F1D60A57;
	Thu,  1 Oct 2026 12:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21261F000FF;
	Thu,  1 Oct 2026 12:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856714;
	bh=KUH7OP4iWerRy/EG23fSkrllMLjJHrglwjsFo+POc+k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aTTG82SemKTBXalZAmyFggcAXHDZ3Rsp4Cmfpknx90oZs6SjaSeN6xwh0MitYl62A
	 KbssxTzqFSUEaggtmL6jMvB86LHa2jnsZFHU/xrFBjAVC+9Vtp/rgHsKyXKeBH1VQF
	 9FeHXun8+ubEbhMVwacSZzjlGMqbT+bDhQDFsP36vzpqNZmSFxVhkJxegmT5trTh2S
	 WTJrAzj4QhQv4yAGrgeBv/EjE3x6hX29NRXk7FHaMci8pJd/RkHk6Oi6wu97anKLlR
	 xjZeUVyQJ4+Imjtns2I7vZIcC7bQJHhg68rEr35+FgQQDLatQ4Ka6FVZa7YRWF+qhX
	 EShwAA+rZgLzQ==
Message-ID: <119abf62-6fd8-424f-ad26-18fda1bea269@kernel.org>
Date: Thu, 1 Oct 2026 14:11:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/40] mm/vma: ensure mmap_prepare doesn't set actions
 on a mergeable vma
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>,
 Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>,
 Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
 <CAJuCfpF2U9rgHmhaDoXX1hxsuuS=s-oWK9Nk19TDQ6CLpjhFVA@mail.gmail.com>
 <arZEKkLGpHNQX3Jg@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arZEKkLGpHNQX3Jg@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 284C34000B
X-Stat-Signature: 7xijec33ogpxmcgkrf5o3yhm8phhobhr
X-HE-Tag: 1790856716-808003
X-HE-Meta: U2FsdGVkX1+6w/kPmnHITH1zeP2Op6dj+Gdik02l/BIv4rHoJWhLcBhW3iimxCpLJnST4x66/OLULCjHGQmvcgjw/vd42ANyLGmXFYRtW04rgsfjrZf4VkKH98KAvueMo6NnJO+GziHRg6HOIsVH3TqsI0l0odoK9gKyzoAKCczHAjGEGUrHV6Shdqyo2jYN2SYgXFXgg4Uv+gc8vUDjYq+8i71ISwGIKPTCi2pOup2NIR7sV9dEt1ABwXof0Hab0nPJrwTXdnaax0psF3fiVa0tn0jHMt2AhD0bYemhQyPLdoI3YHpp02L1vb2BolIsjKfbUa6NtKkmhBXvIVBhPvpR9JksrBCLb3vBee78kpnahL0cgfUu4EWtwtDmTOK9kI8ntsyp+ZR+424kM7FgW8X1ei4M2b3OVzUNCQSq1Icz+wKKjbQJLYNa88ai+zkxyWm/xjj9wHUBB0weGmPBXCn6i+HthJXXueoIPBq8Poy5mhoCxGRDBuDXoln+vzCMcXTCEvV1o3Kz4aJRVUgFQL10svHixZdE5zX1CtaYtHX00WGiaUknH98sAfFcIj+FFVEefgB/0FzkQ3pNu31LIxMTHp3WySlTFUQtO+ldviGXPuD0pxqLFZhyhvUxkL/tlNeOKAEeQTRA0/wPguceQ+ORdPLSp5kpM4M8Wdh+q+L97uLPBLp1LC3/TTLvptTKPhvpZSVHfcllD36RBV1OpYWCyjXsCXicao7V0fupchnJoSY+IGlo1qnbGZKUo6RVfY9pkGLF+xKkaV0S/AfeeBG2rvoNx0DHmNj2+vrH1/zaw5SVYXx+oKc71FEtjWstlVXt70KbxD2q7k2MCyYeTH52KlTuW2SO/Fbk0BoYCJBTifBO228o4xgk7b7CvuQR4osfbVXDOV1eEn4sTwEbmowXn6wxNrmNIrCJQ1X7jl2J7MEq26EfFcWurtqUXk0GyFqb7LMNMATSrK/KHWt
 OS2Zkrp4
 1SgcoWaN9dP+dOwJAAx/2cXzXAuMESrxpla0Kq4KTgY/zpAQ4+wM6pCwCcVC7daDXK/spFpCucJaCuRqvVNPcA8tHLwAZBP1JBxfBajIJ5v1GxYQ7uWjAA/wxD6peTS6kl1QtzdxjAm/m2zJbztCqRD1hm2Jppu3u34idwk9AChxjnlMMEN2tzwnea+kcatP7Pf7ZOjT5yy3jvuV/5pZMBOSbfBZ8FajXx+4uu8OAVi6EpjLLTjRHQTnFy7gIaejHgpuMIpUxvBPnqwzrP5TAhMEvXeWJlEWKnMkSj2pWmCU/KgtUjsvCL1Bgu3vjVbJ/lwxj/UC3fjEyY62ByRLOxR6WC8QxCvZXBK498KvIBxpQ+XVzS89E5H6uCs4d7OQZhQjrEDxxFim5XVJP025Opuhe7Yv2fDoViwAXHRVi/iz6xtRxIDTHhlRbHuM3hV5kLc6UP9FLFimgow8AujWrEnXVOwCCgtLjYz69peSDb51Gjf1rV84u37vr6u+varkP1lvz1hid1TmadHK+SdFDqfaArbmQkXjEd7efjqf0uPX+ye55xoc58LGB95CdsjQQawMbrwuA7qvlkX3uREEkHdEBGs7/z5W3gfqLuIxfmj38FGZVx86cixph+E8+5Xy14VhN4/hAFsQcDL2fzhgpC6mtDZNdLFx10wcN33QA/vo5dHCA/0k8BwP6qKLBA2crW5FA94U+WehMdm/upK72WRR7rmCFm2fOvroorYhRU0OAPEO7kfKpaah7vOEvgWbaxU2KpOqR1YVkTykATMNY0B5PWu9DGvBjVP46dQeMEJ55wmdG4Uni8d5JoGsbTvsOgNj87jABGqUp+PAOyEpf8yn97NMLrtKZZQJY9sUKAckVE+isK49ZRGePBMAGt2PggNwN0iCE2NEhi+5oB5xVFGKB0JUC9zyLoT1aRZMY3JOLpke04b0Rw/OxAJum2UWUR2L7Jq2K1ep5uDeT6W9/gn1KQ6lW
 KXC/D4e3
 ZbGZ+OeXA1Pb1d6OnA3HNMDi5i7Fon24Dv4T+iJDdARrfBFPuEwheItYdNJ+XT0ZwUiyX4DEvz0pqrm1PlGRYHr+f2g6LcF7eKwt51lk9k+f+dAdxkR4+1SucbVBE1wu9KbMcv6H3VbcT83C8VLnknsIyJYJ44YI6Peuh3UA8Gdx0690Giar3G1dE+dfcE23UNf13+MiNQS9DSKlUXu6guqeLC9NM8v3SR0f4MTy188W9NLrEW9P+NtskvBtrhD9OwRNBX+C+XxgdG8O8sAA1HgJsJ5hldw2kyMt6NMJPdF3zSk78t9g60dpWt/96MmqfV+NLcPsEi3R+NuTE6Aw4DGzcUmorRFzoxhooTcbY3q1spo0cTBS5cOGzOveQCVyIpFNf/pH3MZGplZB+4U/K2isigc+yom4e2PZnvOvZbRix+FVKByQN6uMcDfV1sEtO4ZEXGcIs/gH8ri89Nz0/FDVuQnf4eEqIJGIx9xND/DPVLAHKO7KTjMwsBjHd72gPK/MgU+wTq0Y7opZoc5KjBEGWyhJLoqJ+bKCLjmJ6lSyVthgZNHISEKw86oddaUjMHHdVCNA+JShHRJQ3ESy1L/AHOyMuZZKW48Ffn77tQwiLnmhNl6j8vcn4QvwPyJPCUeRitPPtil7vA45dPauEYcsig1Bc+OhFfD/s+GfUbw+x62NA6Y4TnHa0mFmJWOymsgSmQ7YETuEBNcOs/hWtp1h27GTZuD8khQXPzj8kNRlzqiUKF4MfMvSpIRN+fsWUazlp0NreGo4BJrr3noWV+zdEW9T36V6YRasF5Wc+TydzMHqlDx6IVviSCVRE/rg91cpmYwzdnl0JxAKOFY/rpLqGk4us4MsejSDXCUN2Qt9GUKrDgJNFHedsDkl1/1LxLCTDD2aEfQoo9yzX/sdhhzsbvzUSfl9VUJzI7YnMkO1li18vko1OVInIhtzXW3BR+K84eeM4QZQr2HopSREsxevgY7X/
 lXwyTdBc
 waywXUiHYtAB0IZtRZui6Bp9IJjnCEnaZmp3p+S6xBMAFNFr7EtiTTE0X5d+V36EBirSxvhc4ywxl9DHwhwn0r/a5da3sJTTMdMWBsrPPbbVljOt6FvCh9PZ8mpOoxN9adMFlJ7a4FbtL9dCEcoLzy/EHoRBIB1oKBKmlB9xnvPRAViDc4s6I1hOTb+FhR4gb+AxsJSSm7KEdfOOL3OMAW2dElYiFa8G+2pvKee0InlDoTDPZ73GRxEmylQQdttHoV5lxJDlknsod9/XlF0AG3QHDgTqFSQ/SnGWWNn4k2WyllIkrEYADJxHv1dzOt7djVgsTBOceJCkxoXmSLz5OHS634cEKp49GFhGwOwzpv5gAJimtZX5PVNXzntHmoaMiFVmkEbSCsidZoACzpLy3fcUPdCu6V/NeeyobBaudV7z8JMEXu9t/jgi77Ubmkb+rnZC11ZfFzEAhLEH2rJ2hp5yumR3ViEUtuoRiy2NNZ4ec9ieeHzdS4Fc0NzTdKICZKrnDD/geylGpWV/JnxnpViEriSJmdAKPBD/3IouszEitaiO9CU+zZZ29gNhriHBiZDLXyYCWS9MHH9WKKXybEqqIxvHjJm+E3DFeoOxoifxXSnYB4Leg3+bfASa60poJObuz6VKUMeqRVg2m00Rv/jIIgBvrFm5XXUvyjdssYwVfg17GsqII29nQQdlAYdI2EawmRvvUTU/hFx/lxPynuYHEMxRCOX68yI8h2l3uhWrXye0xk+8QXQczVrDMrHIZv5tAZjr4LM7AEsGMcKQmXBJUh0XoN8HhKPCCgg5Qj4Uptvn9caUwoho7O/QaWsdOH8cspLOih7kRBMLVInmC9ql8gJ4AhEUm7kyTn0h9bHSx73pCzljOrpMi9Eb0d3t0bpnDxFZrZLkoIXfuTyR01w4mQJmUuo3NRSiv6ILuRA1F2fbayT+Dm/a2GpL5dIVvAo/w2Dw0Hs5uu2Hhbe/Cd+nmTEX8
 U9Gc/aOB
 3JCwezEkduPWic2UsBW6wfS4Kdt0S/EH4UgZkGu+YuB94VLl33KvV9VJXOhio/55VxXgA/lK7VPzbFzpZrsENxIF59UWO26FgfvEonazbfosC0hqzCyrgFkWbGa6d7asxKfyKhNIhCQuQpn6Rd/GRVVd2YkqxOHVSfT9jc+h7DaglYbThBB8p0e9NuHn/llnpe4ip69GWyOXf2t3eEBeDMol0l0+VSaEmhziWELFK4xUoHhGDkQia2vaRFdyvBT/7anYcDwTACbpDVOKWvmZV+CMYS1s3rrLIVhcVoAwerYzqCQHv7MJmFxr+zb7WxP4KW4evj0+56KG2Ocb20gZggenNA9HYWjY0I0fDAkKXuh8MBJoIj2UJQ48/jKWgIN8sIC72B/Q9cZgandQmj0l/2/dwVpeE5FLdo7xQ8wmEEyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 11:53, Lorenzo Stoakes (ARM) wrote:
> On Fri, Sep 25, 2026 at 12:28:49AM -0700, Suren Baghdasaryan wrote:
>> On Thu, Sep 17, 2026 at 9:25 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>>>
>>> When a user requests an mmap_action be performed in mmap_prepare, this
>>> involves populating the VMA range with data.
>>>
>>> However, if the VMA is mergeable, it might then mistakenly be merged with
>>> another VMA without having populated the range.
>>>
>>> Every mmap action currently available sets VMA flags such that the VMA
>>> cannot be merged.
>>>
>>> However, to ensure that no future mmap action falls foul of this, assert
>>> that this is the case upon mmap_prepare validation.
>>>
>>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> 
> Thanks!
> 
>>
>>> ---
>>>  mm/vma.c | 9 +++++++++
>>>  1 file changed, 9 insertions(+)
>>>
>>> diff --git a/mm/vma.c b/mm/vma.c
>>> index d6ed10cefc8f..62f2ce1ad5a1 100644
>>> --- a/mm/vma.c
>>> +++ b/mm/vma.c
>>> @@ -2809,6 +2809,15 @@ static int mmap_validate(unsigned long prev_start, unsigned long prev_end,
>>>  int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
>>>                           const struct vm_area_desc *desc)
>>>  {
>>> +       /*
>>> +        * It is not valid to execute mmap actions for VMAs which can be merged,
>>> +        * as any such merge would leave portions of the mapping incorrectly
>>> +        * unmapped.
>>> +        */
>>> +       if (vma_flags_can_merge(&desc->vma_flags) &&
>>> +           WARN_ON_ONCE(desc->action.type != MMAP_NOTHING))
>>
>> Any reason you chose this "if (A && WARN_ON_ONCE(B))" pattern instead
>> of a simpler "if (WARN_ON_ONCE(A && B))"? Unless there are races
>> between A and B updates, I think these would be equivalent, right?
> 
> They are equivalent yes!
> 
> So it's more of a style thing, as that reads less clearly to me:
> 
> 	if (WARN_ON_ONCE(vma_flags_can_merge(&desc->vma_flags) &&
> 			 desc->action.type != MMAP_NOTHING))
> 
> And this version highlights what is the broken thing here (action type set) a
> little more clearly though obviously that's only if mergeable so arguable.
> 
> I don't have a really strong opinion though I can change it if you prefer?

Looks clearer to me like that

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

