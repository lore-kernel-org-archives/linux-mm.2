Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B34CA5FE3
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 16:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD186B0088; Fri,  2 Oct 2026 12:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE356B0098; Fri,  2 Oct 2026 12:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09D726B0099; Fri,  2 Oct 2026 12:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5FD66B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:11:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7386B120808
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:11:51 +0000 (UTC)
X-FDA: 85278177222.24.9A92E07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id AB685100002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:11:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KlPBNFEO;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790957509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/BWqh3I+o1TpqkOrGVewyRNzXZFs+ZGIdSCNuZrwAQ=;
	b=48HHL8QDVKuOseZoApDef2cOw/J6Zjkkb1wFJ0DWNFUY1xpMUqg6z9KAWuVDyB8yrqqHwP
	kTZrP+179poEY/Kgk0i4I4T+TMJbsVFxcyOryxvBdIYzFd21ajezA7pwXs/npDUQ1oRQy5
	u1xZ5YneK+nediawFTzvlECkMGQka+M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790957509;
	b=rJmIKZSSszRLfSlwTYNsv1dElNVy4+0VOyzjiXXuUbGO8OGp3BzXkn305Q0Cgcf3L8q6JX
	GjidvCD1ifilQhxHZfnOmKNBoAUCIQdqByRWwad3eEHjPoNklavbtyqMU9CjuIzeJeT6DN
	41vAPJIM7spxUlEhjlrEp+/bsV2snK4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KlPBNFEO;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8694060A97;
	Fri,  2 Oct 2026 16:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8488D1F000FF;
	Fri,  2 Oct 2026 16:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790957508;
	bh=d/BWqh3I+o1TpqkOrGVewyRNzXZFs+ZGIdSCNuZrwAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KlPBNFEOE0gGia6RZAPeBTgVB7HNktDmiscBZ7dS/dxuvyJV5qZ4EBnMmKRqBWf+p
	 NlxsjCUCHTgzOy14NdmetFcItytYbmQN/W1Cz9uNprrziSxnI2AwI/H7kvg7pcE0Th
	 apHw1PmIMxp0r8Tb82ZsCAY6CdcYuqB/iILLMgb+Hd9L8Z04owEifByqirNGM+qtq7
	 tnLVDa9jv/B19Ic1romkl3FQeHLFBdffX1K2/Z3MGzjcMTPK1VcbUS2u0EawxZYH+y
	 GpQjr2jGxvYJz4PqGTUmJEW1o60Sr6vup0HAlwN8d+g/2nFyPIqzdSzcGp8to062lR
	 qxk5wHC7LEjbQ==
Date: Fri, 2 Oct 2026 17:11:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
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
Subject: Re: [PATCH v3 40/40] mm/vma: introduce and use vma[_flags]_can_gup()
Message-ID: <ar_WousLPxpyMozt@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-40-4583d8a23bca@kernel.org>
 <202033a0-ea65-44de-8119-689e0df0b78e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202033a0-ea65-44de-8119-689e0df0b78e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AB685100002
X-Stat-Signature: 37j6163o4117eb5ods3fbauaj79rn1gu
X-HE-Tag: 1790957509-626690
X-HE-Meta: U2FsdGVkX19Sjlc5M7fjh/DLQYTtyqi1H5WRHr/+QzzkWjtli6V2x3y7aDb9aBkPvoE/NdFHV0A1IP5w5JtCcnGAmCMYz6GixiUoGmskOcFWqKiT1D6KAkRFR3LYhZ3+pcfPBZJvbZWsGN8SxcMzdr854sI1LWJWDHUatBpdC4BEGHDoVpi61P53FgsocHUxt6WRdWMi/dHBBv1tXkYqevSQca12sLQCmDfBREOCS1BhPXrVJRurAuVMKQVkhDXkSszybM/S/fly8irdEm7MviitHVd0+BTOEHqWHOyCsYZa55pfAORmmisg0/CafdOUernF6O1MYX1NPy1r8gysi8O5g6kMB5l9nr2rQVdmzkg5D5/CYUC7XHS9I2u9tcGE+HX/WGS4OjmwcOYkcPb5SK3UV17xUH78643aI/Z0DfyRzW/fHEpdLjkgP7DTnp/vtGw0XM9ZcJlF31Wg+sqQWU7J70RzRL+L/qMAwS961G0le3/xtMfVgptv6NJP3XaS7sEV/t3zBVewjMZInfRwhu9WYzg4CAqt8ouAk9RNYL60Gb1UzhU9nv6Id4Q5vD5XP4VA7S2f7I3UR6MUZgDmDzwMfViuP3ewAvpMtLinmZ/93RFs7ay1mLd+cY7vIy0JN+pd8+MQeSj5xA9r4sQzTJsFRDWe73ktYvZEYoUzvPvscqgTaM9LhDcKn+s3BBELa7bytaaLWmh/xn6L94R7VwunxlD40Fs6vtMX6dAOJKg+hrn06dH8ZX57mebSJz9r7Rj+zrWZI3y1WtrM6xYDtAlKSvpM+86mbPhbGFd+6FgORxqo9vyi0EFO0rQW2IBO+n7HjKHVMXHLiUOjjXHOo8sR+CH6yr1K+K4vFyWUKvJIqIgrNHgbFt1JP04eWw721dEvDBsSpGS3M8c5Z7FuToPDyeRYjMJ1PEldnWw39B0+ufLkcAVWlH3FYL7zKa0bbUamA766p27FY2tnFak
 AwQcip9Z
 UuY60Xa1vHdd1kQheK6Fl2YmhFvXYiZCB7I3SN1QmnWIfVcC8tY6kmTCYe7ZImOd0MrzUQKd6PbMFLyFT2oNXW5WiQOHZ11L6Mk53RvYZjvAcI3t1VY8BRR0lzCnWV0oiE0H1LKBHrCOXu/zAnFBtDhllT6JKVKncXuKZdx6j415FbE3+3mPcz5LUC0+w5+rn7kiPNjLNG7caM/NKveNp6SH5M5sJQJgpH2qKKkX2EOKSRMAi23yGP5CxOM8Umt7R+kOwOHoPqRppQ/Yo5lnb6lI4q0GZB1QiDh3n2QIEej0W5zb9y9FbXynIVHxMU/WRFmB6sCjbP6h1xmtGwOgVXDN8yC4BCNp/E2L050nJQSZU5k7V8KLh5BvFHFDB06owidSXYHg5aYEVbMJj3YRBNQ39ZnGSMeV8k7o12q8HG5methx9hJbLjUjjFWgxBLiZHWNX7j/AybBM3zAaveXklsVgyQ0M0lFi498WcKX+9WUevQ8jsRNnh/i9pQGSTaVcIbgC1u7AtkZZkfavmPMg/VP+kUDvbDlr6hTQKL5T5gSSpXXIqZK2ks7aKUPG2VHkSxjCeh9KJLl9ZnnrwvGa4roRxgNTziaksrI9EpcGhUwgSMyt/RN548xgbB+/mZOJyMncCe7HY8//OK6y71DGJz6FA2vgoj+MlyWeg2ChxJuNTTLKlBhAancKRBssNIJujbFAVyBXp9bbt8oQf7OrunhXVdmsds9o7Nb2cG6neODHkpJzUvuHakWq1RvQvAlWCDqrly445f7q7pMJDAMiCrc3Tvfmj2Evxo7pjVS88hrOPhNkcCN1c8d4uyE3BhZPpC3/Ugdh/dRDH/HJml84mF+wAwociw+c5GL5OuyBPMV6Xp6jC+Jzn/dM5XLOKzXMp3f3lSVEVyPDD2hyplwoPm0V68vmL9MXwBFm22grsi7cARapEmuTmgc2DdPdps3XSANNpui2crT8ZlMG/er2CQ7Yw+jH
 5k94vI6n
 Pb7U9SHmFyRtKw0s4HxQ+eeoFdE746992xtHPpCVS3spH02iL1QfOvcSl2RpjMKuVzxrB2haZvODxfMFI0C+5M66TdqWHXVvWiSAVqJw5uBY3K6nIKLHIcJrcIwlfxvGiVDUSQr9sJa9dqH5NAJym3cAnbLLbCunfhaUR88wq08zNsrxYQmNAxzujg8x+s4TgM15QUA4sNSdvg5IvAZhhpldj61XLUFymygOjjZkobET9OjIOxpkQ5i+v3I59Cqn1/3t4m/XEKwNgseXpTk/TcVmkEgVmmdDmSSFX3qx6kCGLZg1Pm2qCK7pj+3kSUQtDYEhUw64918BvSsaRcSOt/axDz1cnm4uYHM1MBgaTQWwDYbuFTYSOhWZCq9mUcXXZPoNVPDkYg5h08aAfFEzNRS+FOXh/zwA9sSmLV/BJLNkr3rWQHL/i29oYdDYZnMaciQdVEKNOPWNS3lMHSp3YVnVNZEEOpr3EPWaPv9pCd/0cYQpW6sFtEzQ0t/QVTkhJlVm3iyUJfQmVI0SHp/QO83xEc0Wk3+mZ954ZAwyCM+PBxSZzoRn8kUDO4XZKw0NvhGEa2SpTLAm5ZktUu1ZYhyK0EYfJiTGsOKAJe/RkGERyz6L1KK0SYRzUnGXQ59Xq6EywagPyKJsFVsHrHwkoOnGLIQlHpkNWHnLQ0ZPCw5WwmVnOJO8Q3gMcXGT0WNFsF+y1HDIfTwUPV5f+zqQt5/UTDjZa5mXoVTRy2b6FhYYbMWkit5zwu3Lhjhyt5KeuejbZpZlmv4CdobXnQxUCdVdlxMaWg/VgR/6yFxI+SDnZsiw0aThzSEqkvs7U7iTXFP63uefzOnQ3mWLzHU20alwP/boqg0H1n96BBXKyMv/MWfulk0Ncc3dPl9cTnG9gXZCDlGulIYhSgdB4MPR6mInLd/w9B6ycxGp17CB9zcvYvXo09IfCZbYvZffgA2QLvVhebTmRP7zpu/sZFi8HqyUyFN56
 mzOvT9z5
 VVz5nadPXhqelSomZUbXtu/X0PeIy3vK8L3FawC2m+TAL/LmCgykvCi2xbRb7bP/4z1tsvLEpoCLq0eu2UtQ7IzS/7xGOv+GdNsTvaPF/K5w4S9nuEG6uj/e8NFduYMdREeowtK/d/B7DZaRVoyUyBzNYKnWzjsfOQL1sOh5BXCJWcoqmRu2xGnub83jsTsS/ztnfFARPdtxE3vQHYNDCr2HYv8qjryqUsg0SnsbasdsoUY+VGhWLGrWlufMPy7f0ciEIKugUUf87Uizx/q7h7MFAdFR4k74QHDDF8ens34qmuqmmWvuyErup+HQNyKKiQ4TDmK5zwnEvkozCd+AVjb2mHTZdXjF8qdn17c+nTl8yxh9dgcdi5lNieYhmpG1+NdfdV5u3mfd9QCiNqAUQr03YhM4si8KYNBwCpC7slNzu+Q5joY8BhbH19K4RPEOLtZqrivyQ+UGI18cdwrM0pKo2Odm++5rxXz7xIHLNrcsWzGN6qTqERb1Bm7Jw21PCeYX8DM+hRElFrum1oxNxhgCIovqj8N3vZX3yDLODCl+fK9zouX6ATHLCSJW/3dFWeunyfyU8cbnx7TgBVLP2Agy6u7NSM0gI135ynaRebGJpvSrH+1uecwMR5K4WTuuDPl03LRC5s2QdDUtqadcyAhwfcCpBR5NCl1CgUt32vJaH7y5zcLwISFo15UvgL/6tStzfLaLlrNm7pdYncIqd9QZsjmLjTHdznbCmffolsrtm3DA6so+0GqT3M/471/ABeYZx5TC+VVFUmB3z091EIWwNvFIFA8LvXkzAJ4VI/6rj/1MxmFXGuwrzFo04fm1jP9AASjgIkg6+LRtKPEXdWJegAoYLNL6122AiFYDoJTfPYebLHuJBLlj3M8A+8IyZdn0ueyRf/eZjiMbIIfflsl/RLIIPC9ZEdn5/mS0wPKtOk6We2JD+Jp/Owq8UTYmKeSGVtMw1IEZiEDSFKYVge5py17iC
 p+mrfaWV
 Htaap1uLY2HhTZTCrsRliOqDWMrM09eVleM9jgSVOIuFTAijbcAbZOaHmE3Av5LG3TVcwE+7MrsTgu3EcOQusi4bLit4xpT4L7E0WqFJRt4xvstBn99DqHpuyJwHfrXRx9caFpsY8H195ltSKe9+/yu/9GPAu7Y886N7byZMXjpzbAHlcUoh4czvzUNC0ZGgZ3kOjn5G7mczEKpW+4Dq6FOmYjOO8QYVkelgY7bcMgDxauQG+qmlsSt6IkxvpNVw+hySaYkicLYmJ3Cy5u+17KDTuhMpXwnlO9OZnAtTCm8p3MPFdElbs25IpUwAVbBJtwyJyPYisRfwliIvVTGS7g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 09:48:14AM +0200, David Hildenbrand (Arm) wrote:
> Long story short: I wonder whether vma[_flags]_can_gup() is the right
> abstraction, especially for users that don't actually *use* gup but just want
> slightly similar semantics (no VM_IO|VM_PFNMAP).

OK confirmed off-list that you would prefer this be dropped for now.

--
Cheers, Lorenzo

