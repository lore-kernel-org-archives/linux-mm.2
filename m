Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21F89CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 13:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DE466B008C; Thu,  1 Oct 2026 09:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F9E6B0092; Thu,  1 Oct 2026 09:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72326B0093; Thu,  1 Oct 2026 09:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BED1E6B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:18:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44DF8A6DC4
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:18:42 +0000 (UTC)
X-FDA: 85274112084.21.5A030B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7A20940005
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:18:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=agBhyH+b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790860720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxjpaonxC/3VDFbLXavStYHgpCVIO4MBlBHvzTk6YXI=;
	b=W9SJJx61UxpoQoTrKI1FSpU9Nus8i0Dm6wQNbfF1/tIWz1W/vsfC+/OjUGN4kgDl8REhUP
	y/pl6MCies27JRZkgJ3tU8kZkwMiEDm09Yp96Z9mxoNTCDIcRSwimzvw3Hl936Ekw3fVja
	mW7vKKqFP2JyxySutZxifm5lfUnGgjA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=agBhyH+b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790860720;
	b=fGZZD8nKVkn+sQIOKhDqiKzLFIV20eDnkjhxuBUU5gh9dB1gcPxcxykTEAKODcnAPsj+Oj
	Eo3oUN4kD6W1zR9F2nmupeoIT4HWafUOmohV77BJs72RN21hwnhL5FnNnrA8MShhf86bF5
	f0ESSh4NYwb9v0HX97BLrzEwNkdq63g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E268B6021D;
	Thu,  1 Oct 2026 13:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628371F000FF;
	Thu,  1 Oct 2026 13:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790860718;
	bh=UxjpaonxC/3VDFbLXavStYHgpCVIO4MBlBHvzTk6YXI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=agBhyH+bFmKD1JiAnoEtz/5qMdv8Ap+ND3x/3N77sLFcXCZ3bcDlajbZP+2ap44sx
	 KPIQ+CdPX8Cd2RQc2lWaQ+6tuTQVHD2pYQlPNxdOxQthGqM2hpE/FWfeBE+JBoOiSg
	 aTHw3Pfaa+usXhHmYbPmjg6Em6hcDF+IY/Dz4XEOgO3LkcfaH27mJOMvaKWNKyUSaV
	 dIgxHpJeU+ZOW+vHFYouo/WQFX/mh6XCActsubBMgSttDFWHcozj2biVdd0OlH5rHg
	 SjqdUVy0SHAv0dkWibepFp4IukMLRAR7jxSvh/uVcF78zQKMLBluxXYPcqcH563yw/
	 oK2yZa6XGh3Fg==
Message-ID: <0623ee06-00e5-421e-a24a-ed605abb559b@kernel.org>
Date: Thu, 1 Oct 2026 14:36:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/40] mm/vma: add vma[_flags]_is_kernel_owned()
 predicates
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
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
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
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
 Xu Xin <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-15-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-15-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: kfqp43n3o1wgw9w74p9ch6utm5hqpuz7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7A20940005
X-HE-Tag: 1790860720-773803
X-HE-Meta: U2FsdGVkX1+f1XmP0MZWrYiseoA0sgaYMuRvz75yHww+y0vimCcUIOb0Y0cmZxpmefFc3776wr/IUD2FORyjCt4OuO6IkE3p7olMRriUmrrVpY0vCANqqJgV80r+zpsXIJ4Qaeb2/fmLnrjFY7v+gaF3/q9tcQDNCf+8JEU+UjzEZbsS3I9eJp6SN9qlsjF2bsZsYhyGxN/BHTA4NzTKoaJE1biSlDOtAnjpAp6fnTlFIaDD+SW7q686jfaSTXBPBMnCrAp2JLJf+UHLSJ6Wm1i4j/DBSfAk/eBrwNWiryK/MbA1Oc4baR7ZKTV7WQ8wrtIHfYLwj9mfBwOFhNXzgF/H5pk0WLebu7r+BAiVm2f0SXDY/wTSBjPdTMECVtXdwP28Z2Wy7A3D7F5LXUedmvn0s42j7jRlSP4eOqS4t5dw6kPYzDUHqcLKVXAaB/KqCbfoPVrLPW2B1LveswNwsi1Ca2ueAA7ydjeZlct3AoolYdd/PMmrV74HCGEVyOo/dQCqJfruuxJvJNNLJ7ABXk+A3DXybqSVWT3qw9pshrgxOwr+3srTjQ6uBEoq0Fk2wbK47wglrEklnpaUK/hZmshf4f2JOD2QFEvx9kSVTj/b+4tvV8Oc/542IYPabD/4IE2lHFT78QQbB6rgiE2KNPO7UtmI//sUsz1LvR5CN1mxuiJzviNuKQutiqLvjC4DjzHjQzCIYhQuZ8KPP/pP+IS18eErtjIcO2AYJtSaJqN+t6FHS+MG5UUEwhf9eWzpLZrLrDLiovcAY0GlMH6+GZBdHPfmfPkbUxcTczXBh4aVbI94Z9lIbKlVNJWpstPL6ytVAKbCJfQEzRRiuV3T74R4SyPv/tveCdTG2+Rk+eZOYuo+5VruKgq4fOPahzA1dpDigHySPsMzYgk8ELSwb1O50+9q1k4KCx/OrxGMDkq9GN3QCwz08LuOlhCpqlFBupnWCYkc36q51LKF4OH
 i2KuAGA7
 DainXQ6cEZO8eMqgbugEx4JOa1X8bFKIZdp5wP2fmR3qRB2br4mavRHdwgMtddFexsu+GYxw9o9MLtrODsV99Xr06+pRg1lpB3vaRmZ4fNnQjtN6IfBBdXnYDo6ItFl0bnRkqjvDWNrBSbVBKn3RPmrgCExHoPeCZ+ZmM6GutrVxI+gJvn6BOtNHZ0pTt6UI5IzqHbDcqsduaEBMtqlGZmI3SkzUVyvtGGbhKHU73kklAuAr6hdJs4l3QoIqEcztTOaeK2IesRjcAxU4+FCOHUh15IX0e182AB7i5v2QCBxtKcPUdj/eoxRPcHi3MjqwKfJjPUeBT5jNF1NO+vSO42FK5hH0NPs5B4wJIR84Wzj1nzfmSF6NsV3fk97O6TO1R3FmXCPugGmcu270pLGvSZfqMBRQfxUwFBRVJGGa7uFs+Nkn7jNykKgtTn7UT2z8hMkBagesbSn/ysMIsxTq53vebePQsYGoxWd/2NGYYDpz5aogkz49B7zoqVcy9309IDMLsfYLU2slE0wKJVxqa5hA9E3mGeRzfIQ3XasjGMkcMxz4ZLgqE7lM2U7sZSpkZpJCGEAxzFcsnjyiomveb1ummnF6i5zb2E0DK5GAgREumpjX64rbS/dd0uW4YJF/6+sGdV+cn5IxLbuuPGzDJVqNFGmxnj+qHtQ5HnAk7H9U4h99sEtCZ0ILB46GKSAmDhzaUs68KLvQZAO6kCeIqzdAh6KBeXdbu6KbN6BaexZ9Byd/ZQtciAd2npdk1rpNmUwoTn465o4mCm9Z48qH8oZMsjoM5UxBrZBqSv+K72N9RaNno46iEGBCJD9tlGx+iLKZK/NwaxppVjHav2Oo2pYUk3Uwh5I6XzmeYDdroVyxjOh1UdsmKbbJbKPx+AXeoLsQIy6c7C0dm67nvjxZuJFL0Q69P0kvQnfKFaJ06U3XGZCZ4eU0pVQkHqgmuy3QmUJ5UOezC3H7R/qMGX6ZlasnRa2p7
 kxTfgsui
 gNBroLhdLEMozGyRYNtVUKfQK6EdxT+bUDdUSlSvR/Muwn+tAPY76djeZmf4Cp4iRgTQoDbG6VDKpJJRel3rqu//oIT3/mcyayuyWGo85wancWDSqa3HWETkxdub5H513FeJlMSuuWj+GSNSgLKnmPp3gxHd9/6M6/+D6Np/8cafTRdGiXgsiFUUpulzI7hTZ+Vt9J4AIb+J9ZhXUujOsYlKNUILXzstJ0P4ha64v1P/VVB9Gh52REdywk4wMq385iza16bmJWSpjwRmbSwpEGNeENl/0hddoxSNFH16kQyOMoBNx8I3OuNkEd6qVO2Rxym4BwBS4P8Uxs67aSrfcGFfDFFJMrs7i1hWjfTyzR102X/KK1ZbDU7qV0u7/GLrzd0eV24mpCMdoUOVACJwyHUJEJ0Z7dAWtM4R0Ail8iz7ylTNxpUEpJ6sVOjegUWkkwoh16I1nU3MpG7uckkXpxIdQyVVQok3/U3yL/i8nNCogPiUamgvp8IfUp1qOFPeVoxlvezg00Rnc1PkarH7xrM3skWu/ayt6PoIDQZ2xRvnhRu1TocyaUeJnWK+I8yqkKFj86Gl6weqsXNDV+y67OWj0TKgibgsrK+Aic9h0Z7ptjRl1RYHiEXB0twu76VWwFLoEF3s4vKFpj2LHjBl28NbC0a5PpTSZT/yJTJLP/ts2a0z0bosBEawlXGnXbpR28ZD6L44PCNgOX2ZjVfpRbcXIFzctESGFsz3ePo5L4qu5YaAM2tsXiNzSyRLwRHpx8fja8JWVQ+hD3/pIO6DsUwTMGmTqHqGDetaekKUQHbP2SvEbK2py5T/QdgQUQihqsYVh1JelwPFlmtCC+o3MnCIKOd5pwgsyXKgc759H+40K2LEp+HEjG9g/uRsjdTujWWYUyBO5Wf9p1SK0jfyfGzzLxQSw9vPk2nrNdim7rJd/1+cyG/pFYe5DSsmQVz4DqJ5TtvYR8m5KOPph7fPy5xIhnsMW
 Xg4jzKEg
 Sgc5t77wX3GWRhn/GaXJwNvDHWsBGOOl58sbnHEIh5ndvBUKo1/kDAc0xh3gfQupRysvEhu9MWlmenxj90HcJpZHR2coidkiJP54gEJVXWj/mV/Z9y2hyq8GzkwTtMWDufDoLWdIe7lFLvXFgRTusAeDrbmkr3qzwS/oMx3qnVywMDIO/5XtNGjEpz7fmRIfm8cV/F14TnXWMbFsae8kGHMu73B+cFEym2AtW/j2QnKmqghegP+QRFFYDu9cc9iAEcI6ZjPPolLYWtLQnDpTRBp/IM+qpKhOk8mjfTssAludKtp0Im+zQ9QWL6Q8oEzFDEtnnluuZsk+tP5S0BY3ct/+IBMpkX+3BmyTca6berDGyrPbsMqhn3RA6HWejJqZF7p3uW6Te+PNgceZBI2w6ihgQCo4gdRB/WN3xPg2Rr+6KBGQr4KOdE5pRH1ckNVFY9gkMts5viD78L2C5cELSw7b97WrH/1nBb/2Kp68BGruA9FE1Q0VdRNeDPN3Xyil4IFPF20xuvKO2DPWZQP2x4dfVRo/DkEF10WjRmSrA3Zyb+cd9vdx+pfilcSSvn7yMYwiGGfC2R2qODnZ0u6gQ7Z2BxSJqzaK4XQiACUr1aBCVAtlyh/UivL9KsBxZdLp/UDCnJwatPqi0XnM8xNO4RM831HFnkpk11REpYUdbT/wOAQTEND+4MoGqB0fVwqdEiWYV8gZQRjZ+Ths1yFtmf80ba/tfZTDJqK+YEBCsFdic9P64y1D8X5FjWoqSZN6BgJTctNZ4oNtBnbBG7S7O61SxHwn7dsrudimTECxa8YhH03iU1EldjPcrzYLN75doJyOpvPR6/2BO9MdW9Sr1v8ZZSpBeZml3d7iABuvkG3g6t3xCzFN657ify6fW1INdw7OoJDltxt1W9yWqbtZ+37Dkmum5g93sVN9+m4vpPwPo4/aV+JlNOycyj99An0MRfECWFCSZMfnX4gnjqDgyzPvXpUP2
 65jpwGC0
 O4QzccbzqLYo7M+N3YLT+vWDmd6S5CjHrhfuyBhcxQwghm2BNrusOwdg32donAsYUTkZG0+yqtt+ZL32E0r/WZpxvqWyTVcDdeZYsCED2Qm1riIIoRVUlsqXC3LXyh5pJbDCRk3MbmiKeXSWl5jPD30VCcpXJlCmcC889G0aY7l7lBKDYx7wXckpLWkTFQuBQtRgHvWCYSSBdlGyQH1LOmKOUWWN/7U5CGTGc+L5DCbjd+KLxssMyPEFwLrKaR4bZxtipJTCPPyNaASDlrYExuWSjTdp+yRYKpKjUNw7MJDIo3V4WGXxUGMsXzrXd7qNDYpQyHqrkortnTj2Rq92YyAOsu+xOVm5Phjk2HjzxSVeQRFjQl7Dhk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> Rather than referring to VMA flags with uncertain meaning, add a new
> predicate that explicitly describes what possession of the VMA_PFNMAP_BIT
> or VMA_MIXEDMAP_BIT flags mean, and then refer to that function for
> determining VMA mergeability.
> 
> Either flag means the contents of the mapping are owned by the kernel,
> usually a driver, rather than by the core mm: the memory may be MMIO,
> kernel-allocated pages or even ordinary pages the driver maps itself, but
> the core must not populate, reclaim, migrate, copy-on-write or merge the
> range on its own initiative.
> 
> We initially also include VMA_IO_BIT here, as by implication, these must be
> kernel-owned. (mlock() also sets VMA_IO_BIT transiently on ordinary VMAs
> while locking them, which is addressed later in this series.)
> 
> However the intent is to in future remove this, as no mapping should be
> marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.
> 
> This forms the basis of further work intended to improve how we express VMA
> properties such as this.
> 
> Also update the VMA userland tests to reflect the change.
> 
> No functional change intended.

Of course I have to bitch about the naming :)

Intuitively: kernel owned vs ... user owned?

No, it's kernel owned vs core-mm owned.

Which implies core-mm is not part of the kernel?

Yes, this is confusing. ;)

I assume you're coming from "map_kernel_pages*", but that's rather "kernel
memory" and not "kernel owned".

Usually we say "driver owned" when not talking about pagecache/anon. Or user vs.
kernel memory.

So is it really all about "is this (excluding CoW) no ordinary user memory that
we would track through the rmap" ?

> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              | 56 ++++++++++++++++++++++++++++++++++++++++-
>  tools/testing/vma/include/dup.h | 29 ++++++++++++++++++++-
>  2 files changed, 83 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 2a92193ac6a5..cab29d6e15c1 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1612,6 +1612,44 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
>  	return is_shared_maywrite(&vma->flags);
>  }
>  
> +/**
> + * vma_flags_is_kernel_owned() - Do the specified VMA flags indicate that the
> + * contents of the VMA are owned by the kernel rather than the core mm?
> + * @flags: The VMA flags to test.
> + *
> + * A kernel-owned mapping is one whose contents are established and controlled
> + * by the kernel, typically a driver, rather than by the core mm's fault and
> + * rmap machinery.
> + *
> + * The mapping may be memory-mapped I/O, kernel-allocated pages or ordinary
> + * pages the owner has chosen to map itself (shmem via a PFN map, for instance).
> + *
> + * In all cases the core mm must not populate, reclaim, migrate, copy-on-write
> + * or merge it of its own accord.
> + *
> + * Pages mapped this way are not necessarily reference counted or map counted.
> + *
> + * Returns: true if the flags indicate a kernel-owned mapping.
> + */
> +static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
> +{
> +	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
> +				  VMA_IO_BIT);

I thought we have cases where we drivers insert pages and neither set
VMA_PFNMAP_BIT nor VMA_MIXEDMAP_BIT.

I assume vmf_insert_page_mkwrite() is fine because it is DAX doing it (should we
limit this interface to DAX?).

-- 
Cheers,

David

