Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9FA8C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22E56B0095; Thu, 24 Sep 2026 06:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2036B0096; Thu, 24 Sep 2026 06:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9BDD6B0098; Thu, 24 Sep 2026 06:03:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81EF26B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:03:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08253A5D93
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:03:57 +0000 (UTC)
X-FDA: 85248219714.03.5416CB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 67C7D140012
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:03:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMbxskam;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6qe1GeJ9XQcp2Qtuu+QjoS116ZDPXf6D3ecAVzIRhY=;
	b=6683ck93Mj2agY7nfQHM/kQRfWT9XUuwjJEs03skUSAPvACBNFP09r1k//zN5ucmhmnncG
	fcynemDv+gXtCHSFnJM8M34j0BwnVa0bDqoXNXf/0bD6CemhJ/HLcokAczeAn3TBxsygRY
	U3f2+DVdJFsK4Qz9m4hl/dgDykdsKpk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244235;
	b=OaDjb1xd9oawGj+35+56xsK2oVdun+K3+SXouODqYUrd2nNNBeUoOhyrGJkhn45jNIYcy9
	d8/hUFFvH3KqOf28mMB1BDeyv43FREQKvlRJApZ12aaYmmZTgpUpbSBw437RZX+Rq/Vriz
	5iR9HhV3kyi1ZI/TEr/udkkKdDCkya8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMbxskam;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 98303601EF;
	Thu, 24 Sep 2026 10:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097291F000FF;
	Thu, 24 Sep 2026 10:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244234;
	bh=Q6qe1GeJ9XQcp2Qtuu+QjoS116ZDPXf6D3ecAVzIRhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DMbxskamLqIuQ517s1qWGAAn1E+xsD1IWLYGPnumbRx6pTv8bCwHJNooLP/0Y9MmF
	 ewyfTQFlrtMHi0vbNbmoGXeP02wTiKXQwMUnfW6BJPnwha3F6zTor4G266x5NCtrLZ
	 UINk2FfnnrWpmI4AgQSRtCEaaer/qXtOU6XcHLmcrADLmAXvRTfOudurStBkH10L0j
	 cHXvTwq8BsOo1ESnuzegeDjHk5jwPxjbI7VL3VpDQNaTCWwI1ExYzT3hhqIHmtSCUY
	 phCcWTevzoeBg5AakjX55gtjhS7DlK4HJYPRuO/TGOEmjyYP86Mnf1i03HAWs2ule+
	 sZHwPnp+ZmfYA==
Date: Thu, 24 Sep 2026 11:03:23 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
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
Subject: Re: [PATCH v3 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <arTvHhdoxZi_LslN@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
 <26EB9785-2909-4D49-A755-09A72BA94BD0@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26EB9785-2909-4D49-A755-09A72BA94BD0@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 67C7D140012
X-Stat-Signature: 91qkhutmq5n3j7f6b6mzr9kf6qj5re5y
X-HE-Tag: 1790244235-577587
X-HE-Meta: U2FsdGVkX1/ndp/rMXrD1kmQt4lSTm64WvF978okjRm+CQuygrUpSykDxPhzI+GDAnJsPKalrXfrZbwBKA0YJzf6PNcF/dC5isdYtACtNm6CduLE3tDrTGS/V/EXoKd/wrKK7IIWN0jg2qbd1QisdGM7FidQrT6+gwCeLbAiqHXbvLGcgSSSIabg0GTbvGCAxLe0GtJWXO+7xpA/Th9NmC4yLryTNgEPAZXbpzW9jP+jZHcS0nGTxsHD/Fcpl7ynTd+NWQmH0dAYw3BIz+JL3XFT8m9ii0/gHW2qgdUT4+QusSt8gqKp4gOOF3/+02Awbyuuqz9Bed/MV3VuaQGbMWAf4l+DRCHeLBjVUqRvS87ZMy0Xzwuam2O+/m7d4/dfOf+++OhtymLgcJRjVo9TiNGHWQtEyJ9gXnCZJa0PUGEoS3zxPpH5NIoBGlEcXMJQv7qzOvNN3vMkUoBz5m+iBggZ7V26sDy7K2oB3yAcYEwupDxBFShg7HUIvyM+NguaAO05HZsbwCTLOAy+5ES0uwH4kTJ27qOlD4cCbi2uj5a/47KiHgJmjjsH0X3EZq5w0zJ5rAmXr/edWQbeyiBVpcP2Anx0LPH92p6L0VB1d1bH0vVhounJf+KnKeOyAS6Fv8fv76ubaqQwBD1bKcA8Gn35GUyYDGsOeo0dM6II3JiW4QP7zGElpHwP0D/afyvUXwUGdRVYtz723pVAPuWy0BGNDJOvdxSmzRvv8vVmTph2x0+3wxvdGuaIZ4MpFbo24Lc3V/GJP/uU26bEFbil/KSTncfr2+OtP3uc+YP685+FXFvLwQmeIntDTg5rhSf7yB9QlZ2JK1QcmmCGDBPJEHUZg0Mm9X31R93okUItS0TgKRFDR48gYmAbym1uhUZO2almkbFNr5ls2vgrhdZmsqu+eZkQ+B81G/nEQUxYtFWOtbc1wWJWz4Xbe7jxSwuCAO5L8mWwbp0JX/pWQZr
 VPnMpP07
 7vri+2bBVu/d4+QLs56bkA2l/ZoGnPSzMwLuG4nVIxgFT9oX/pt6PcgCNilvnQYycZ4URFkCii2xdX4Kh1H79IBoHdFPHbCmNlt6EbuS7rIKTueHimF2kXtz7ojKQy5vn+fKV8vMm3FSErc8XUNzP1q5WLjR/Xf9QfBqecLR4hRYi9JJYRUghpfClKqxfXrOnusDCBbl0xnMrIu8GnR8fU8ZPxC+40z51wrlc6t/2IKx0BwZoTQpY3U/c550/2GBMTuZ6hvRjA7u3wvt2L1q+8j7Ub6kwm1WJK8fZvvHQ4JLTEr/mdMLtghjdrn46vUscTmZmTrvll9zMyy8ms4NYZ1gAaKX32eFJ4OJp22BMHQpdrI0BsSsodt4y9vNmL5SWxS9cyTsYjyt7qgSENeydQGJp6LtpwO7WqvdmMFDL6KvscMIoVqmtBAKfcBYJfHCFzVZEEpMi0jsJiN2GO/MOsseViFYyR38KACjsUEFiRLvq3nONuHh1lO5HhExIkP28GX00ntY4UZ8NjshqqJfMMr4qp7YTVlLicors3k2OnqC4XIS151yer4aroXxo8BUH/7uVNQvDy3x/CK7b+5pX5QEfXMEFBviM3HDl6TZhVTxmgyyRbCGMbjopj1iDia5m4wR7DpYoGp4bRNMWB1jZX/gNGK41w3c2O1rovxDpkyDhrv2CwANISW8GysP0nbIj5StV5AA3omZSH0qstR5GPjOIY8LaFTPQGkMkzvcIiOOu9UazO0+ACTRrVjMiiUpFsCwzBXfDNawV6uLrYc/lKyQ5Uy8IfqLyfpAsS54hYelsu9PH7puGsCBBDewuCq890qBPZZ6UyCQSRQgsg7q3FA8rhSrZc3AstnlCMYHGhCf9cpVA1v3i6pOqTbviHxCazz7nDrmYerc465E9kPTAmEntK8+Q+OKUYxeWG7wXKaOhCJtbTCCkAo+XCPzurw0H4qCIbh2HG50j615+njfz3027HyME
 RhcZgw9D
 TpbztBK1UrfOKDfE6KH9vxGAQf+vtt2sFVmSbA2rPzOPkAOCmiMZz3ehc/0G7hfagcu2ag78u04CfJOeHd6Ul1xHfMrT9bVT8QEdvh33fO8cD2/q2rBaG+x+BTxs1t4pU4ZWJ+V0OEImFLed/w4aW7oLFkegy4R14Tp4wF/ARXVXTzX8XBP1LMMcqPXzf3oIoto9l0WvUHV5tvkGyCp1pswzfyYNU4UpXE/aFh76lErMH2Oc95aGeYVKBorohCqSbTZZr7rIPmwMXFQ1owI71LCMt6/4GaszEnuHcelNM9uFloJF1UlOsw4CZdVztGYxwRQeefy2OYcHco0wR1MLSgKnc7Ww38e7FA/s+TAM8Gim93+HCOUZX+RT5165G6BYDUhbQ+Ihq0sa241p1TmqL7MViOddeX/Jus2q1YHp9TQFInLbjcHwYZdDXmruySCF8/iluB3waRmbqC/1RKsXUDcrs6eO1/esbawVAimYNkdsVI2hAxYfrPkG2yQn/dV7ikDKilOiod/o1GentWreUp/8N7eOflKhUDPysBGxlvYU8HpNEom/Qti4iTV0HTlxVd8ZXGEfRFUSUPN7iads+g9uv80KkOQj984R8NdLRdVHwu5IGtwnASSf0lgPuzXsKdPr7E5g9gQ4V/2fQ0f4lFPX1CfWeiM9fTl+GOw6ujEK1C6UZVjNEGQQXSrp4QlA8UG9ubH7TX9mwysbtPZ2fVeF0fxueeBBcX0v/PFF1LcWO3xIp7dfFlzAND70GjRg9wWpc44sX4xeChvLPRhymGKbcehf7vqWIg6yqN5q/V1haylMFFoqzf1epNbL4kayuqEk1Rk2kGulIv6zl9UaEF/eFIhR7gOAdmDZcMZSZruFrUkmcj0sXk0ekVGgMpiJ8TLx7QnMbTgNCnmHsEJeboIejP19uGuNvDYx9BXbLm6jUSTVVh+5pr2paoUFT+Dlr+m1vStCKpZWLXmp3435Is1SRB3QP
 IHD+fxA8
 qr77OTmw3jvKfbVjedLQ2o4XrIJb4ueB+GOcuT8sBJsP2kvgh2/TPWzpMP+1m7xqqqBmqDHY4Bmw5k/bZKwrV80JgJUJBz9lsRuKobfLSgctt+XmIlKZgGPKC/+pgpKqjkkfsILOOWqkiTNA3o/ltaPE4W8KgA6qvyaktoLDmntQYxykTBblcYMmhBANZxcrgyygg6UotMLAaJHoG2KCOkdSlN+c6IavdlBDyZE/rl2qhnrL19r7QiXlCIZOQzX/T3hgl7WqbLVQ/xyppkiohsuNfXY2vXG8pYy11oGrRX7smyGatwdTPKowE8EVt6mElZ+tc+TMNKlpA2o914+XfKy5Us2BXmjlmZGz+qLQckxRiAA6jngC9+NYxbia3T5+lTmmwwSpTj3p2NpTTo/y0o9F4pog+VqAMeRqWkBdUGzpLBr7X4Hv9bGdGBWcsa0lkUy56RpVfS9k9ayktLUv6VFQC4bfqClcAkhKwrCoJW5tPxaz9QF19Nh2T+cY+z6QigGkV4kU76P7aCRytD5mh0CfW0cV6D5LRDfZ1lNDxi9lH/3BqhbEG8SsVD5OJ/Kx1nG6UmqCBitzTTIknHJ8nXwQPtRQCkC7embK/TcqCCc93xxL9sO7G74bdLk2iRPeJGRLrZIFhKaYlPNIA4T38BzaxtYB4ggfUKAor6gmvECb8Ttizrv7UPjmPNSBS5Hk1SwjsluB2iJdo9VYPLO1FTZCmNKzeSKWGIMDByJxPgC91LDMXjpZ4gIQQkPWicdMGmmLwQuPrA8TbQsOH9uDIWzxGbOUYW8oiLx0Z3xJfby8kMlPMjt7HDtcYktVfvgRMKMx3/3qsw9mY8ta3WU258SgMxpKxJjxM47qvcaMyZcleNYlq/3SQEnUIYU1LDPKCJKhxM8qsW6DDpd8A/2BqLJ2uJGz4/EnlC5/b+QmWHLR9BcpeDPPKy4crq3BxVWwWkBW77dUTfBZAR0hiVvIpPQqWL4da
 MvOuleJl
 dfSJmiQHr4rz+ansOD7eu2ADi+fQ6pop276/jYnlSKxxLAxRKCS2VCI+ZzZTv62RDkZQHAfMNXUFhXXLjEe5bRF4lejU4mt55VNEqwVkY1oxfywbw7a91b5QAb6r6Gfh5g9nV6++WlQIUWTNyBWVpL+4+WSOfxRMQs/BgkV3suBiQSBXN4rlafdKYddjtcY6tS9OcNaOJWgckjqDD9SgPGJ9m2nHYYZN1qylXIqI2tauvCtEAuXm2MUjytqXvzcPFvbIYqDUHmtIgdzVU9Lk//Ucb/N80CpsE2tapAljDjIJ5Jonpsg7hdQ4wHxQ50KiiYhhELFXQjrnVvCk91zqtkhfM0uqoJbpqY/2g2HeP7hM4KkCStP4LjuTizB2S+pxwgmtUioilSXtYQruHyxVca
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 10:20:43PM -0400, Zi Yan wrote:
> On 17 Sep 2026, at 12:22, Lorenzo Stoakes (ARM) wrote:
>
> > The map->file_doesnt_need_get flag is confusing and the existing
> > implementation has holes.
> >
> > Drivers are permitted to change the owning file of a mapping. If they do
> > so, they are required to take a reference on that file.
> >
> > The mmap() operation which ultimately invokes __mmap_region() is guaranteed
> > to drop the refcount for the original file the mapping was made under, but
> > this is not true for the replaced file.
> >
> > This has been addressed so far by tracking map->file_doesnt_need_get, which
> > is rather poorly named and unfortunately fails to correctly track whether
> > or not an additional put were needed in a number of cases.
> >
> > Make life easier by removing this flag, and instead drop the reference for
> > both mmap_prepare and the deprecated mmap callback in a new function
> > put_map().
> >
> > Track whether this needs to be done by aligning mmap_state with
> > vm_area_desc and store the original file in the map->file field, keeping
> > the updated file in map->vm_file.
> >
> > In order to have the same behaviour for both types of hooks, only drop the
> > reference __mmap_new_file_vma() itself took in its error path, deferring
> > the replaced file's reference to put_map().
> >
> > To make this work correctly, map->vm_file has to be updated before any
> > error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
> > set this field first.
> >
> > Also when mmap_prepare() changes the file and is then merged, the reference
> > count also must be decremented, so update the logic to call put_map() in
> > this case too.
> >
> > Also update __compat_vma_mmap() to manually perform this step for stacked
> > file systems using the compatibility layer, and update
> > compat_set_vma_from_desc() to replace vma_set_file() with a correct
> > refcount/file update.
> >
> > No in-tree driver is impacted by the incorrect implementation of this
> > currently (no driver that does this is mergeable for one), so this does not
> > need to be a fix.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/internal.h |  1 +
> >  mm/util.c     |  5 +++-
> >  mm/vma.c      | 83 +++++++++++++++++++++++++++++++++++------------------------
> >  mm/vma.h      |  6 +++--
> >  4 files changed, 59 insertions(+), 36 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 0dca33db068f..fe576d468af4 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -7,6 +7,7 @@
> >  #ifndef __MM_INTERNAL_H
> >  #define __MM_INTERNAL_H
> >
> > +#include <linux/file.h>
> >  #include <linux/fs.h>
> >  #include <linux/khugepaged.h>
> >  #include <linux/mm.h>
> > diff --git a/mm/util.c b/mm/util.c
> > index bf0513d1d3d0..016932780925 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
> >
> >  	/* Perform any preparatory tasks for mmap action. */
> >  	err = mmap_action_prepare(desc);
> > -	if (err)
> > +	if (err) {
> > +		if (desc->vm_file != vma->vm_file)
> > +			fput(desc->vm_file);
> >  		return err;
> > +	}
> >  	/* Update the VMA from the descriptor. */
> >  	compat_set_vma_from_desc(vma, desc);
> >  	/* Complete any specified mmap actions. */
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 55917d097933..fa784f069da4 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -24,7 +24,8 @@ struct mmap_state {
> >  		vm_flags_t vm_flags;
> >  		vma_flags_t vma_flags;
> >  	};
> > -	struct file *file;
> > +	struct file *file;	/* mmap()-specified file. */
>
> IIUC, file is never assigned other than MMAP_STATE() and should not
> change after mmap(). Could it be made const to prevent any change?
> I assume mmap_state will not need to handle the nesting issue like
> vm_area_desc, so file can be const.

Oh I had assumed that this couldn't be const and I thought I'd checked that, but
seems not, it can be :)

Will fix that up for v4 thanks!

>
> > +	struct file *vm_file;	/* May be updated by mmap_prepare. */
> >  	pgprot_t page_prot;
> >
> >  	/* User-defined fields, perhaps updated by .mmap_prepare(). */
> > @@ -43,8 +44,6 @@ struct mmap_state {
> >
> >  	/* Determine if we can check KSM flags early in mmap() logic. */
> >  	bool check_ksm_early :1;
> > -	/* If .mmap_prepare changed the file, we don't need to pin. */
> > -	bool file_doesnt_need_get :1;
> >  };
> >
> >  #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vma_flags_, file_) \
> > @@ -58,6 +57,7 @@ struct mmap_state {
> >  		.pglen = PHYS_PFN(len_),				\
> >  		.vma_flags = vma_flags_,				\
> >  		.file = file_,						\
> > +		.vm_file = file_,					\
> >  		.page_prot = vma_flags_to_page_prot(vma_flags_),	\
> >  	}
> >
>
>
> Best Regards,
> Yan, Zi

--
Cheers, Lorenzo

