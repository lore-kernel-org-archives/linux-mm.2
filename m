Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22748C9832A
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 22:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C47B66B0088; Fri, 25 Sep 2026 18:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9466B008A; Fri, 25 Sep 2026 18:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99866B008C; Fri, 25 Sep 2026 18:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A87A6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:07:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC44CC0613
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:07:02 +0000 (UTC)
X-FDA: 85253670684.16.8A188A2
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf09.hostedemail.com (Postfix) with ESMTP id B5606140003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:07:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=Zlmr4DHG;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="X /5NAWL";
	spf=pass (imf09.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.143 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790374020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JrMmm48wWb5nfElfLTql9tnPeB0+8MEVeYNyAgGoaQE=;
	b=mKIZ4h8hy0KuaGm0x6xO1YbFwdgd04bufm4GEDCRa46migZTTaUuXzxipuYrjTBxxcF71n
	2tPAy28bZB6x/w9nmPeUWC9ZP8j1gs9kZ3WL3HJBD1HIqKNb+B89pjwkU7B8YrHl0o8iY+
	iey6FNwTudH3uQtUrSrHDUCdMCP3Or0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=Zlmr4DHG;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="X /5NAWL";
	spf=pass (imf09.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.143 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790374020;
	b=syzbmln2/yKe7yCgb22puxz4n6QZlP2jgdd+aAiviCYTpPVAwbaDyWViW2eH2cF3s91poT
	1kFjoWv8j9ZwYSGmSm5uWV8UloGDs63iBTOPoCKx1unDktVWd50KlPzP4qRtItITL5gYnX
	zNOuRcXIloFHA1IHNlKaJgM5Vvi43YQ=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.stl.internal (Postfix) with ESMTP id 66524130051B;
	Fri, 25 Sep 2026 18:06:54 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Fri, 25 Sep 2026 18:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790374013;
	 x=1790381213; bh=JrMmm48wWb5nfElfLTql9tnPeB0+8MEVeYNyAgGoaQE=; b=
	Zlmr4DHGQ8VOFDbBpL4C63f0nX7MHZG2nG3ayIMRnmI96rYz/AL0gq1drAqD488p
	nRXyZrQmC6x+9EmXhbOrO4tVieILNRX1OrF85tC3SpyFYFTooOPtwQhsomsyVFnR
	/JL/wUDCwIAvzqukPUYWFpnmPjA9tkQKzm3sN8CtP4Er/blf9iMJ5E1RbL9dQr5Q
	azNWuCqNQFI/RtcVKlzqmiwqBdEB7hxNNBcJHZRuQOUlpbLsER9WMTIqh7fR0cbO
	0rqOTpCQJBH/fMc3/cSkpsYg3m2x/XVeiwXfI/fIE3VkuK0tu6kmIxRtGMjmZ5Tm
	0bGA+qPzrmWnT/PmDeHu3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790374013; x=
	1790381213; bh=JrMmm48wWb5nfElfLTql9tnPeB0+8MEVeYNyAgGoaQE=; b=X
	/5NAWLyg3YZFuUWu8ra4DQtcMMYuSCQ8ppRoARSsvykmth6tIbYB1DV/SBkKaBqy
	ucuqfLFSv1a5QY3O0fGJBFNvVgU8ch42KbnuYXIespMpXGzMotkKHyFDIfMWLRl9
	F7nM74RkfKRQS9hC/5ei1xuCfo5nmfjaqdTQnN8R0e7Hlj1lgy0J+W0FR4BAU+A4
	NQLC+nBh6bH7jAdVJkhAAdtNuTA3rfYfCtwlx0hw1TN0+AzlI/wyWDtTfY49272U
	L3RJ4biROW6jLSXjRZNZVlLfRNuZn/iiVPFefw8RdPr0K7bp3w4jlh5vyZVoO4CE
	5wC6Ljxr7feU/E4rReomA==
X-ME-Sender: <xms:cvC2aleooIz-s5Od9uinMQe3cwAY8eDmch1kynf_fy3H821eqXhoEA>
    <xme:cvC2auCqaLVPfE6ov_bEa6-wP_ue3HT7urx6Pkp8OHuNw8Gx-YmbQwreoPICZC_C8
    wqzDaLNP2F-QCveEeF9wWmMIoLPnYMKvncpwz86IJJPrk1J4H72akC->
X-ME-Proxy-Cause: dmFkZTFzcTdzGevjqjoCPQwS3cDuhZoK8oU2gJZJEJ9nm6Ezy4rCsybvSQH5LWRQQ5BGYD
    rWE8GcLh/SD0OK93rHMHb+nN85ZiQLBNNWUMv4/GBdRWEXKSGbwbYWQ2GwGJmZ2CLvUIP3
    2eF1fY0CpcwTbnziypIg5cFo5xsUnavn7wLuBNDJE6AclU/QJrEq8x08d8JZw195pkMut9
    +XQ7lzPYEQZohK59KW7gHFp7WnISiwDCkylL1SuAn0RKCSSdlhmRMt9w65C8xyi3rDiCVv
    vE+hQgASzBzLzKVc3I9ppRL7f57uPiViyuwADs8Yu19vaS3Qfxg9r9IrzC4Mkgk2ustKRO
    F4m05rRdOeE5QpPp6vbIW6kxmuTWTAckzKlnyd8YSIxkWZv6i9nfm513vFD+0eTgA4SdTt
    qri3VNnnch9OdxrqaSSzsWZHizOYpxImHRcvk6QGv1bq1UhMgkHFzBOBPavWiMeiwky2KB
    3YkeHFQE/+K4iWbdjOEFO4OTzP/2wAcq7DiAjSIWoqjXvFqai5/eBWEZwYXzH24T2Jqilr
    EgQhDSmS5E2SAJVWg3UyPZsK5j9sRZkoeQSL0VVjyCIZZx+DN7PLGivuCQsWF/VP5s+ABk
    01aGDOM3El01HuVwMy0P/rO2I5SQxMqxGjZSe1srADQ0PhIRJpx21/0+EvLA
X-ME-Proxy: <xmx:ePC2ai0cNfYHa_hu2mUjpUBcw5imDXjczzuFVtK8vQhMU-jtziGkzg>
    <xmx:ePC2ajmX_hgY984FYsQ00EH6M5K0sfyeHvF1qv2R1IvPjts0GUTCKw>
    <xmx:ePC2alvAPzoDWLruQB6z3Ygd2kq3A2wm1GlTlHlWYalN8zlbryTlaA>
    <xmx:ePC2aqA0UTfKSyeeZg0dB6TK75dxPCAzmPZFuC_nBWalRYa9mhRkLQ>
    <xmx:ffC2alqlaLQVHV7jBfKQ7aBbho8OdZx_4GIw9IJBalNr09Mw03UhyI4W>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 548BB32A0087; Fri, 25 Sep 2026 18:06:42 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AJwEWD5WPnhk
Date: Sat, 26 Sep 2026 00:06:22 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lorenzo Stoakes" <ljs@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Jann Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet" <corbet@lwn.net>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>,
 "Paul Moore" <paul@paul-moore.com>,
 "Stephen Smalley" <stephen.smalley.work@gmail.com>,
 "Jaroslav Kysela" <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.com>,
 "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>,
 "Andrii Nakryiko" <andrii@kernel.org>,
 "Eduard Zingerman" <eddyz87@gmail.com>,
 "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Zi Yan" <ziy@nvidia.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Nico Pache" <nico.pache@linux.dev>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>,
 "Usama Arif" <usama.arif@linux.dev>,
 "Kirill A. Shutemov" <kas@kernel.org>,
 "Doug Gilbert" <dgilbert@interlog.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 "Jaya Kumar" <jayalk@intworks.biz>, "Simona Vetter" <simona@ffwll.ch>,
 "Helge Deller" <deller@gmx.de>, "Sebastian Reichel" <sre@kernel.org>,
 "John Hubbard" <jhubbard@nvidia.com>, peterx <peterx@redhat.com>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Oleg Nesterov" <oleg@redhat.com>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Namhyung Kim" <namhyung@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>, "Rik van Riel" <riel@surriel.com>,
 "Harry Yoo" <harry@kernel.org>, "Juri Lelli" <juri.lelli@redhat.com>,
 "Vincent Guittot" <vincent.guittot@linaro.org>,
 "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>,
 "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>,
 "Dave Airlie" <airlied@gmail.com>, "Will Deacon" <will@kernel.org>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Muchun Song" <muchun.song@linux.dev>,
 "Oscar Salvador" <osalvador@suse.de>,
 "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>,
 "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Anup Patel" <anup@brainfault.org>, "Paul Walmsley" <pjw@kernel.org>,
 "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>,
 "Janosch Frank" <frankja@linux.ibm.com>,
 "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Gerald Schaefer" <gerald.schaefer@linux.ibm.com>,
 "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>,
 "David S . Miller" <davem@davemloft.net>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>,
 "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Chris Li" <chrisl@kernel.org>,
 "Kairui Song" <kasong@tencent.com>,
 "Kemeng Shi" <shikemeng@huaweicloud.com>,
 "Nhat Pham" <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>,
 "Youngjun Park" <youngjun.park@lge.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 "Chengming Zhou" <chengming.zhou@linux.dev>,
 "Michal Hocko" <mhocko@kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>,
 "Xu Xin" <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Linux-Arch <linux-arch@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev, "Takashi Iwai" <tiwai@suse.de>,
 "Emil Tsalapatis" <emil@etsalapatis.com>
Message-Id: <d4d7d4c2-a1d5-41d0-b1c8-8ea0cc5a0397@app.fastmail.com>
In-Reply-To: 
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
References: 
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B5606140003
X-Stat-Signature: wp9917pygrrdcrpkci4i6w87ddmu9zim
X-HE-Tag: 1790374020-151125
X-HE-Meta: U2FsdGVkX197NhFyTvHzPchlHBd1mxx6oMFhgruj/DuV3gg2Ma5qfXOWcCVF84jaFJDyWJfAbHzfYM9PBR6vA9Ev1sk8sP3oaSPuv+jHSUbyYxUoP+EY5HvRLVjo0fBzDtU5GKl4EwiISGroDY/5zYuX5sPvxPrt6Fx9AfWpG9nbzpfKA5kCY3wHIRfCrPX2El+ZLPz6WJOeiUWREfQ5IHBzDggi+4Aj4dx52mfHYYfA2v5m6qUXRR6mbjOXrs9lCZ14gbeAJgK0K6LtPWLfq+sFCHIANLJnvJ/hJmojSAWQqp0Ez7YM9u5HrcwC8xdV6hUWL+Excc4mWQUJSXsXUVEr3Llbbpb2cjD2IX2jcZpQ7ERZ0ptUjrX7OGE/A2Dax9WLunFJYqkSfeJdj9Xw4VZTSVLB880FLkVMPFAeuSL1kwQgkxmZyg1LQWWRbYe5qg4jehhQjQtTfRd1sV4PTbOsI6b+RWF+Kub3g2peBuviG1+y7mpFAjfpXxN9kQQz69epIfNeLz1zcS+HOBba9LjYFYh5ZHtLKTVur9cmUEHRVy0qi668F5ezc4fAvqvBa3zRiwq5dTrhC9L5XTvgYyBRUvepsAqgQnSNtPI2pjl4D/+WW3Qxbjqq/MfYTGXHFKdW+S97DWXMK/rsx880IA53DtzOihhI4WVrS6SrRPuGVe0a1WFNZ7X5vJNx5W0Cyy6XZZtsOO6VZW/WDlADZ25aLB9X0NUj4caFpMGKRTDcx5mlZsT2VmLr6YjEt36lnHL4GLHKTJ5gDALIf9SAdjmA4va+hqIyvJhA8KKkQ9vfJv0IETYyIxboHJeJ8PWyOAFLYcQPeE7wITtvwjBVSUGqw8Jk3ds994YW0+XouXM2KXiRURBoMgJ4f1rwSpGadX1QKRDf4haEd9aucEB6bjmQ0unb/KtG/sauznlEtcfPfBn4hwpWtszDr6FfIGGq5JmFUde5eWGEsLuqME2
 vRZ6kDl9
 +TIhzCWo9sOIrU27B2OgqZnFCRq5bxforMmf3G+pL5DleeuCsY7+zJNRexcKrTWfYx3KMWl6mxmgtWhL9nICNo4Ako+JDXxMOaSBr27A0doF/NWUrGkAZKvYHZtHaCIrRpmOJzUFwtWNpUQoqI7Ow50XAZ0PgN1TlT1a6OMF0/ELuRhKRZy8KwsFyYOpmqOXnKNJe9IB5JNXy8BIcRd6bBe4mRg5X2gGgtbND/Ycskd0XtxhZfpwesSDnKx7EEb/YzWsNVBchNG+Z2s88nEaKOFYmR7+KAiZTA80sdWSmojc8nePG6xj51FQIosiZ/WMjyug/LyB9Zn+wt+DXl2exOkufeVtN7U/pelZo9K7A727JmTX1YXETF6uTedPdv7/saWVpIDXSCbNRLsSqd4WmNUj6MfV/t9nzCaWF3wlzNckPFMAs7Szfa0LPWiiBF0LkPSNh53LQLMgkeiZ7VLBy0cHZ8qcgyanqWzOvwjE90pj7iwjNPU6+o1faZam1lxrbAMsbPKTQtGVDewx4uXEXosInmiYXe2IrThoKdF9nRFBFFxfVGF7pqkgwnw8n1WRMgfl3n40ggveEb0W07CYL3HBvGpwtiENQC3mJ7L2/olEXyeZqSYS6bZFKqMduHmUy4VflzxwnIfA9YiGi2N4y9xqYWKR5VWUzNm377E+SPgcLLwtbax/JLd0YwnJKBDvDwHCe1T5ZQ9aEzP6IvAF2pd/0lS1kbPsaxD0a/LScUxT6h2H8zclMguabJVPqRu0a2P9L7QzzADY9/fHXQt/UgMRHNRrJDR0ECQl4FFW50JR+f870sUgrda23Gx9PZjWcocQE1KNAB7eO4WdOJn5XFvaVDYejUZg2sGpi3/oUoQ0u6RLHibfESa5032FIJzlNFGvpfUzoa7QnR7EnfqYQisS1+9PZbPIqSWA+z0rAOzaO0M3OUhJAzyzSF6TTyeTsZsZAVe7e3A0MDeXJ41fpRBSYQBs9
 kw9CW3rb
 Eegfxy6WRoRsOxuvh8e7BAnACEG3iT58za9HVN5rQEO9+8rzbQFSL/xxjQ299d2/wVgUqvSFY4KPBXCoNh2HN0XQ2yVMxkW4QhY6vY4DDcAp3TrlPmN2mje5qAnezM8qYy/8fqLN3igbcCF1/muYDZKYTmFcJX9IqQcmB6rtcgEvmad9e8hZ1OTAAyCgWr9E8l7i7ftkqZjbezQol6cxNEU+jo9R/q3WM3nmKxvYvtQht4NoN+tBppZp+mL7jQoXv+9/NJ/Txhx1cpuxESdx95LhhzhvNrnOiffz/GSJvkts5zM7yUdk3YxdPSUSoOQKWaz/dXxoOn98nBXuoj/XTkk5/XG1dafJQxSDC2t81fNvBsIMx0kV2nS/+vPx/ivCEDK21afh8GYvTZRO3Ov22slqwo37g/3AajT2JGK7wjzszj2Q19AQA5Ea/gq03Q69Gps4YxJonCU4RexcAKhFPhsq2zrZu5fxhY6GAOzGDoO9d8OlVC9GhnVoAOOJD6osymscLX6vO3tMbnRqE7Xp8RiBNbl0ma8Qr1NNO6jphqn5liU+TLNRlhCfgPMkclkVRbMyp+3338HfJURKW9gykv6DxJZSLJ3Tj3sR0bhm/wxZO2ZC1LFuhNaubYARGOv9ZNGvgCFsQYTQHPKTxB1ubUHMvnu4AAT/1oqpxX7ZYD038PWBr9KylaEyNfcDiK3ESudz4VXOZLfmGUFXNvsOUw0oRiYmeIYb7DWoAtQbI55WKF8lZxFv9EvcNIjxCKcGptMc2EvmJ2xw8Iu5DA4Olr5tni0Bv4PEniGKY6t3b7T5zLwTCbrzTQWuAyzMqcbHd6Uhgezv+FetFfD7efZ/+DFZOPRe6aVqt1Vd6ETAQwnoj5ZjsU9Bu/4C16Mw54AOyKXqlScU2Bgjv1mZ1pUDTTtLyW+6SoonwkDfMwtiQ+ftrNQnYWWeA1pSTZsx2J2emKQNmsl3Tu/nJoePIDzUhv3lDQQf0
 8duTlwum
 44BwvHxoh3T1jP5/ADl1FRF8E/B8r2pazppkqKPBSYrZrAHk5CukYlcSm/Ljj0ZAvCjWOb7BJ/oh1ueLx9+cJDm0fz9vSQsdzUYD6zJJt3yqfxlAV6L1yRSQFUwGhGICWvJXLS7cSmF90M0qhfEiHQ8qVpT2IV9hAfLpKrIaOjBGlYoTFYHXZeEVEnIlOZkMGUCvDk9vJ+Bt1w3SR1ypFfT9ms3XiJMvCe/3O3xeoS6KokFNjud165C24E4KTk1Aohhxmh6AZa408YuEucp57E0lXbdMkCQwun1lZp/haMR519Rr6HCbbCl+qKAycDpff/OfaHMEgks7eQUESX1/PWk+MxZV4S37iDeyoIpRF2d6ndaPpgeCiyyCLa4jkOaH7cixl4FZ10W3HQywCrH83jo2rhJIgpjFyqs6trGTmteIhVpaXr6Hq1cacH28tBX6+klFrnEL/3wTRdZsmI9MG5qfztlatbqey76yJK6n+LuCReObnCd1F50RletW5eCX+ph/N5OLdeASFo0BZfHC7odhkQGsfzgWAgzsH4YYuE3OAoQ12mKhDp52yMrKdkDcgE66qBNVcTIF/bBmLoY0BcaStroUH4lVolW0lxMopqQua0fiqAKSKMXUVbZJDuWHgAmwxjJc9ZCLCPili40vfQJRnMzy5aKLAxfHWbecL6MzI54MQz4CsnctYOd+o+mvqeir0XywJ4yiLJ1BjAUua/1NdrjDFS98AwencP3aknmSgRQGz+OjqxTigVF+2rgSNNv7IDU50bx1LoPeW+HfrlriUAP0AKJiza0/aL6JZAw3WjGc4YC//pQNwcQxYeseOYeI2RqxXpZUK3fHjksFa2cmV5swPMMt9ZZIE8+u1DAsaNK1hb89y8C8o4cKAqJeaDHcy1UDLSrIHDkYOpGRTZGkkFaLnL8xuvC+EpVco+WurYoNM/xXel/byZwnm/dtuUbhxWojbpT6fCOMmj3aq8wqVLcVw
 hvVfd2JD
 2Y/n0BdgL124YtqWKaIct6VseZzDvX1gOkU5Hh5fLZfVZx+ttOttf/Ka5JAbOoQXaMcO+uxmXF+zjge+eVL0JM+0DQaBbIML5j7ca7fbDmx2pjfbXRv2rHtcYBMe82jSRu6MjdTVcxvS5/wb9GtLMnmZpMKKX8Aoz8Xn/utzMsA/1riVqJjokWIty7Lrca1JVziTgMxvBNTZwBSlb54v8J8ho83VOcepd3VHA157Rit07fZcedy8dMd34Sir5yFFKew9G6N+L6+e1XkQRFdFG5cycUmEiIzUUdaZecCneCAMbiR1Lsc39QsFc41RNsV8YgT1T80c5vQ9kntJeU35nI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026, at 18:22, Lorenzo Stoakes (ARM) wrote:
>
>  mm/vma.c                                   | 246 +++++++++++++++++++-------

Hi Lorenzo,

I see that in linux-next there is a new build failure in some
configurations in code that you are changing here:

mm/vma.c: In function '__mmap_region':
mm/vma.c:3083:1: error: the frame size of 1552 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

I don't immediately see anything that you did that would have introduced
something bad that wasn't already there, so it's likely just gone from
just below the limit I was using for my testing to just above. The 1536
byte limit is what I use on 64-bit builds with KASAN and otherwise
still has a clean build (with a small number of local fixup patches).

What I see is that this function has multiple structures on the
stack that have nontrivial sizes:

        VMA_ITERATOR(vmi, mm, addr); /* 104 bytes */
        MMAP_STATE(map, mm, &vmi, addr, len,...); /* 384 bytes */
        struct vm_area_desc desc; /* 128 bytes */

The config that caused this is https://pastebin.com/raw/5M95qHy5,
which is an x86-64 build with CONFIG_KASAN_STACK enabled, and likely
a few other configuration options that made it a little worse.
KASAN_STACK tends to double the stack size used by structures
in order to catch out-of-bounds accesses.

If I sprinkle some 'noinline_for_stack' annotations on functions
called by __mmap_region(), I can get the size down to 1144 in this
config, but that doesn't sound like a great workaround.

The large stack usage is potentially harmful if this ends up
in call chains that have additional large stack usage (e.g.
kmalloc() leading to reclaim). Any ideas for how to reduce it here?

     Arnd

