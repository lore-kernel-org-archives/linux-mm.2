Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E78C9832F
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 17:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DB566B0088; Sat, 26 Sep 2026 13:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9656E6B008A; Sat, 26 Sep 2026 13:14:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805376B008C; Sat, 26 Sep 2026 13:14:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4531C6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 13:14:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C037EA6B96
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 17:14:53 +0000 (UTC)
X-FDA: 85256563266.11.120FE07
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf30.hostedemail.com (Postfix) with ESMTP id B997580006
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 17:14:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=dE1RFAps;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="L FqYjy/";
	spf=pass (imf30.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.138 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790442891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGTq2YiYGuZgWk5ZY7JZMyWu45IuuL1ykMMcgPEJafg=;
	b=REOFb8ST12rSsHyHib5fWPAPFVOojM8795as1fek74Tv1WjizNsGiZuKWyL0iHnXAIOl6p
	SSsmPAp/VZf/OYPW/h7UaDqp3zX6D4rc4+R1Sao1YjnISAPhmx3gkxjLDhPLxTfUdoXmYS
	G/VJLkznemqtW2jfdGRdzPLxWUSOAGU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=dE1RFAps;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="L FqYjy/";
	spf=pass (imf30.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.138 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790442891;
	b=gdVnZVPIpekTQQAVy7qkgBWvDgqMzz73jxc92KMOyi+sd9rUb9mi+2ggWGW3INXoHzicig
	T0CSmE5aJfwtGWSdACeYufXS03pAdoTPFQXX3ryJvSr+stX3GGuQzxeMGp6t1kCcHqQPja
	hc6ro1h6ZeUED/l98/oV9Ls4SxqVuns=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id 178B413800C5;
	Sat, 26 Sep 2026 13:14:47 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Sat, 26 Sep 2026 13:14:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790442886;
	 x=1790450086; bh=tGTq2YiYGuZgWk5ZY7JZMyWu45IuuL1ykMMcgPEJafg=; b=
	dE1RFApslPrSXAIEUR7zYCnrfR6vWyYxLHf2mps7m16cLN5ynFqwRrqagDCdLt5m
	YGRbmWqMeuJZtlHPeeOXNw4YOCr4WJ6Mx0NBGForSSyaTMKmirJa1d3T2lnduVHI
	rsG6gUbympIQqV0TgHZcoaLCS4Np+hjwdRsk5xnTjJWQAspIaZDsh56Wd+ZL1Q9P
	guB+47QlTtdPYoLG8jeKzxdNJlNY8FOh1EE+3+tKu9V2DYSkeblqIQPL6x4FiFqi
	37BVGgjvon0RgSlw4AbAROwgO5Lo55li4rPUTLQ9IBrXkmPCZHI9T0Ji1alFsVXg
	+dWgvw0N90MVm2Z635R8Zg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790442886; x=
	1790450086; bh=tGTq2YiYGuZgWk5ZY7JZMyWu45IuuL1ykMMcgPEJafg=; b=L
	FqYjy/yVFlEv/wmLmbEHRnoCYINCfyu+CrEq8Z1fyh4tz9qIiMya3S3yY3OFrTAj
	kbwJ1H7p0hlPQkLTIbo3q91ouu2AqnlXl5AXAUacs9gWfltmW1YlpP2JQRX6xaDG
	BIlnaq23mgNxIHZvkc5sn32cnf0vgx81JvFvLJXh30/EkXzOIDF2jBGju20aWRpQ
	r+U4sr/EsBDJPkf1NNPApHB0wtpHKJnfgD68NUX259cKVa0+Te+WR7YSLWz3+AYG
	NY5HM9amaFG4UKU2VWfYypsTDrNO67ys7nqOEDOLSOI0kUSbd6LrrDfi5G6ZeLOj
	guHR/v4b83Xt/fUVhxgQg==
X-ME-Sender: <xms:ev23aqEfCNjet-2YbYWWzRXflqtzqi8hwMuw-sOV-SpumEa7LG2shg>
    <xme:ev23amLx2unnBtPfhChzlb1fRZ2Od9LfU9yDqP0ez7conwhJcOBcipgwHXcNic6Vd
    ihyMWwi_TyPeTUyTmoikaAeCIv-aWaHbyLCC6Ub4m_6V1cork6IqRQ>
X-ME-Proxy-Cause: dmFkZTE6NCtyMLNoS8hrfLFpEVvHnZq+KuaY8H+9LmihRjQuIS2tAlukOayEfreBF4n2zt
    VM1Xb2o3pLojfbA1Q3K/syWPA1rTM+rS4TL1sKcoS7DFAfYGpLW2jXD87OlXNKqEST0xN/
    cCB9d0v2iX9PJOBVVmY1Q/2SAi/Mg+fUIg3v4HzozejY4wwxdLDProktJHZEibcEbdkK9A
    DsbLRqLfari181EQsuwTU6q2VoX8ASbKad+pD4D4x5fnBcBEsLw1S0g0DqkX98pTL00H96
    s7WDOTgZX/sRdKZFzHVYGuDUWUJen+c2yA8PP101rXcEkHHLoEMw3Y2mH/kj+PJ6Jg4phW
    ZPtHSWVzfsMi/uo7wINTVSLDSLjRI4Nrcb+iIceGEJgwfznIyowU/XB7wjZK1vQwvmWNfh
    Xsf2CcydvUcV328L0LwSnRsCbh10PhtfXwxt1AdrlAnXwA/tpDhQGwkJwWPe8a1uDDSIgR
    FuRPcva3YSO3dMEwljCPu2EQ9gdo7QVG5vdPgtLNw84R0kUyuYuZE3uKBRMlgr4529/DqD
    DjCSn1ux1tr4q9apeaHlutLLSq0hzxv+TC86iyQ80tvVgpfvwCR7R2k16RICYFops8dGKe
    orvK37Cs5fQgJyBNeJVlwb2UjdrY+qi1eBLaiX0vwatLO6jmf2NBuSQeeCRg
X-ME-Proxy: <xmx:gP23aluqnoTw4Kp_p7Myy76Cg9h3zOKmotAVHEwJf7Xg8wiaBQaRtA>
    <xmx:gP23atVx8P31dhvH6TSVp8JBe56LI4k3auajT3v0qFyKlytMy_bmLA>
    <xmx:gP23apJheLHk8ePOwgYDLSw0f2H4aAcZiX3L2QUNgpYltbdfKVe22A>
    <xmx:gP23ahPAx3Etc-AdLxQIy0Ipz5Y_4EKVj1jjlEnECLU6wC7z8PJW4Q>
    <xmx:hv23aunjCQ20lqB8ZAJCIhTa2AfrZr7JcwsQqJyvJGCpuVigaepn1ADv>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 7CCAA32A0087; Sat, 26 Sep 2026 13:14:34 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AJwEWD5WPnhk
Date: Sat, 26 Sep 2026 19:14:14 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lorenzo Stoakes" <ljs@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
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
 "Xu Xin" <xu.xin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org,
 selinux@vger.kernel.org, linux-sound@vger.kernel.org,
 bpf@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Linux-Arch <linux-arch@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev, "Takashi Iwai" <tiwai@suse.de>,
 "Emil Tsalapatis" <emil@etsalapatis.com>
Message-Id: <4a3a089c-3ade-494d-8f83-f9cb710e9ad1@app.fastmail.com>
In-Reply-To: <arfGmNiEngnO3JKm@gremlin>
References: 
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <d4d7d4c2-a1d5-41d0-b1c8-8ea0cc5a0397@app.fastmail.com>
 <areSEI5pWBadkqIe@gremlin>
 <408aef6e-5b0a-482f-8ba8-f8c20ee870e5@app.fastmail.com>
 <arfGmNiEngnO3JKm@gremlin>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B997580006
X-Stat-Signature: xqbmsogmtz776dso8c3dou918rh5bz3e
X-Rspam-User: 
X-HE-Tag: 1790442891-66392
X-HE-Meta: U2FsdGVkX1/GwJMBO+p1y6ZVo0xy7Llssi88C6g7kSPfGGaK9yFTuQSl0JVH7Qx6toYPomwKQQiWWpy3K6nzlJ2ggN7iKRNdkDFRk5gDmaYiUqQdrAiFUN1AxAJVnGErJtdFou8EHUelMjvNqPyw4mPive2PVXp6tbvbppaX7bUoqfDkjMGeFb1DtOlAMNOhbVsOgJuZJScNfZVsZxVqbItgocguBRNxOnMANcmSOItCcgz3M6VZWTIrM2YHnZlXbwcWBXlHEkG3Fdo4YVcVLvYoBksA6+wx3FjOKvsICFrRfmLHRVOOa3h2jezVzUvbyh4lxVij9POYgrBPKGzJpYsqYGbUY/FTC7hP6SRyYkUZaShln5aWyF6iAMTXrBxlBn2NVlxu1BgzmBvPqT8TFuaUz3EurYP42ajeJMbsNj4p0Nv2PTUeOu/RsR0Jdjg+8MjCkQIdvKPakrNVT852HTlC8uyr+Xgi3ZLUF6Whdldnu6BSdl3mLE8gEJiNWPl1ofT/vuxcThn7dld6OO/W743Gwx8PZDFiL140hRGLvZ2yW2EnalQFhmaiGEMovU3vi37WSDsUKKOxUmt2UG9nZje9MqJoWqzjlSLoPPOyNE1omnsFnvShaESekgXyn1Hszhd+PJ2m7guhfwPOEtPAEd6yrrOiqxuVfML543oTsoAnxGDST3uzq41RdZuFmxlKWilPdHIXjWXi+hNVl0HddWbfVbvdaYAem74a19Q004CUtfjHH6Zka95HowSYeFfpob0LasuKU8QkAsLP/Dj1Z38FcKJWldKEc2YKWYaWRB19KLXWFgR6k/NcuLEda32488pk/qAEBIYTvPVEA5BTE0bkzQMSoqPE/GBFTLfZGsKa4bd9V9ht/sFi84z+AWus71pJMKQxgESQyMpv3JnW9xmYi5AUSqiR1sn1BrtwM3MuhP36i9oKfZnGAYTM2gc4MrlFIhYiMPs9qxSz7lw
 BcInZfKM
 gQE7xDCaRc8wj0LXg5idiAgleWSnypu09Ht4AToNHhYD0VnhGIbv8x5ZBWY1jPKjZ1erJruWXC3PXvy0aJDgK6umssUUZL3d3bJiFyOO1Qe3kO2s/Ho/VulSgNzoNq5cJHtNixMBbgChMIwa8O7Dhuq0gs/SUAjuhMDsQcOEpnMXp/tqjDAY6WEnmroadmg/esYcTHUTdNCGicf61SsTys/bHIgiOS60K9BKp1Rm3ilJ0r9oWmlyunyNPON+MQFNpIIbmTILBJAkNxczOMg2Qa9uMJH8/pREHo4kWdYWDp6lY5qR2pU2nQRT6alWeP6EfS4NsMbpzL2DyDjZ8ExoB3KM8ZoafMqPA6jq8sG8xVXsV2Qc0YWGsgQUga74aHQIJpPdS7hKry74Tid9/dftY/ITvhusGLwBl4IQVS9jkUWi9Sfy2i3Zr64hJMzo37aiVgWWwLbFYm7zyV9Th5rqv8seoeD4p6c5Xf20iiJkgSL5K+Egztkt0XU89iLm75rYcDwZDLs+ZWDKvyg9XhPkedWLZpj1Pek2910ZiXe2KOThz0uo7CKv/+Qyn31gmbPRZFt7vSerkpOHMZdZU+hJdmVwCqHkFayGJ0x4ynAH+wMbS5r91SHnPY8vXQFgWN5p9fXWToF/LDZNtJfaF+jGofhTkT/S2hFN8yWfeBXZ98OctZBX5BTkpGbooVWcUp94Ak+r/KpV+jVefEVVGrp0Oy5tWERshX27O6pua3hJGIrZpbr//4n21Y1rGE60ftSsXGwFQTw6QK1yHlKBCSoUOr3fkQx4WLFHnUUJh9baUZsMzerECjPHtsJBeLC39TJHpTWR7OJa+XaVu51egvmGNumL6GgOn1l5Epf/MmrDucuD5TfifGAqMn4OK/GkY+nQgi0uzuDc6E2IOvIM8CB1PZGRT+ShqpO055p4U4D6Vgg+nzUETQv2M68lhgRRWKbDhGg4F9ISYhXlKxAaEkeg3XQvszD4U
 fXs95OJl
 n1YMMOE14H27+b+Mi+8T9+eECiGsPk8ZkkLasSVVAmx1Sx2Ymn7/p9kNHxoRJRTs+aRRxlYhNALZB/WodnJZUDjzOmdDYVf3VPbQrc34uBQN6UhnRmUe8NvRVCFW3lW2L0hs1DZP2ywjp7jXjF98e8hcTtMEWH4JeNIMT+MJU61/t/SEOn7ohNt7IDg9AftPb1TmQWhCSc+nLHMCctGmSCbpOLK2Fwt0+WqSg6BJpmWYNyLwCRxnNjy6ZRfG69rDXwpWBmDuPBvLpQK0ODyNRViirxKPkOkpdDH5C+6TeSQF9xXWGZ8EYS1rdzkmEPF/KM+ka7XmP3psdSMGWN59zkJOT4UaSApwbeWQkrtNlTeB+nMZj3GEN61PwMxTybqd3UKkdx/4eKw4wwIz1jelkPJurDUFlYiPdreFVhfL/jrTveciUz5CwnIsHiPg4nACHgAaXJ2yLMJZsUc69D1hvEjiiVV9gylHyi2PoNscp01Pul5/WPgxnz5Xn3Zor6lmAtjUDHQi93piKFP0dWqw9k7sARY/lstrQXeNzTrgHc9H1KlYOaoS7T0X1Ba92oWCJR39zyIdUUTUjD+BklM3SNkpX6zhqo8EquER7gQSzcF2hz0KERsjmXyklu669tdtQTpvBL6n9rPUaxyCS9WqSeg0zeIHigsfW4tWYol0q+4uemqUDk3mhtm7nC+t//f7IDvCm6U+KirDs9p8a2t9o7OElq6voguXJ5wKoKCDHDBCJ0LZ9CrVwqAqtl36vCCsyvuR5fWSi3tXAeqYz2CgXRnO4cGmA/XOGOHXYe5H7VdviKL4pDlmf0KEA1EXIMn/Sk5vamS0CKIvX1JJON3b1ATVDjsXFV6mQy8JF3/3RvVEt4w15N5YebGh6mT+RjXT3OHnVVQ3aA9lWwS/8e/cta8S2DYPcD8QwPaLJkFP/nnciNJczmGxTbqm+nBaO+Sq/u9yhwJnMtGmWSNbmuvwy+dBM7MOz
 lFjz4gM6
 PrTTjVNIveJU1hocKALDdHK1qrvCR6AYcgVlKHANgRmyiVZH6x2Ym5QYOkOmnCUygnKjvjuCwneHwPYJa4GjNbyZg3u6ytk/ZwxP33rBM8yx1HT8qNu4ctaGZl6cetuxvXmSPlm2jMhUZXNoIZlnKxoFexn0/WXraP1mG1HgzXtDTYuwtoQ2sFvsi5+GZkDrWFytv3B8Ke0MvF+iNeoWEn+SRLzDarU1kZpgo3nmlc0HL4i7Y2e6q9tXW6T2imXZf8oQaZredVBKS865AG2wuBKCzrHx99B4y9lxOZDg1DZZv5V1OtB5AhemgBT9qXlLKSsOKIJ6ECL4lAEOBGstAgbGx44ZhDrydimKmR0x7iayO0wjTRhFci6F4FHdmBrENWth0puc7KmRqAjXD8LeSUtcLj2XQVKdNaD+P+WXD1OdZiDeG4ttpMQ860DhTOoPL8QpCUguD+nu5i6uIeB/3I3ZfG8sLKz1RXfQohEscvsA0R1EeTL/Vp521ZE75M5qxh0q7N/i1fJgeKaQ/FlNeZJJYFdYaZO5lKrcvPFaeLP6nUR/l8pE3bk+4uyK2uxl4mSHeySEJWx+LY+VB/HabcwmGHIPRT9GzU9klVfqqR1T8VuQQu/oc0dPv13cxxkCUtICiDlyLcJJ3BMI7bW8NYycbFTEZeKI9mnzmT0FvdoOGOaFzGeaAl+4QzD68ayKSE2RCv183Ab22W3aqtJmZ7ipGt/bhB51Hq2l+s9akI+QeCqaUFK73GBfjtUVVg+28O88MNcaGfmF/USBjFtBhs/YmWlFvJD/mcxBw03uNk3/dnZ78LgWEIk/R2LGlJYrdFnCvM6xgQ6i7Og4jx/RTovfy6F0eRKYOiDCZsJJUIFsuii3cMbZ9QjuI1Zbvkvq40Gc2jcynb63O3yOrY3pWFTO7nUV6KLnNWybd2ZVilfwM+whkF0mhA7r7DekiWaxdt1WOgAKxnEliP5Up0kd6os6Q46Zj
 FVglZ0ol
 JDhM7aalEVKOLKgZTuvH92WzDCnyjHIYESvQKpAtY14PFlxtcmJQs10VRfMiVmMGKwX+4KwPiUcj1Q3MwaIGii1zf2jD2xwEldnuXqQP1ON3lTgNTLNt0baOGboxW1QwGJv/2wYDZcAfndOvfkg/hjlTescthL9DAQnCVbv2KIi2ySqbUlyrmvZPWFSYqUN22zgzow1wH7LMxyUj/+RGwTGsjJiQFsNWwigaF+loYlFEdDgpFp3NBe/dmKeumxspW5W6j+N+c+whDZtJimImk3k6NIckzQt0fFE8AT9wHg7EBJHznCHBwhnaeEL7Lateg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026, at 15:22, Lorenzo Stoakes (ARM) wrote:
> On Sat, Sep 26, 2026 at 03:06:33PM +0200, Arnd Bergmann wrote:
>>
>> It's a Kconfig setting upstream, but the way I'm doing it is to have
>> patch that calculates a sensible default based on other options that
>> is a little smaller than the default (currently 2048 bytes) on x86-64
>> to catch more cases where something sticks out.
>
> So this is an early warning more or less :)

Yes, a surprising number of these just point to stupid mistakes
where the developer had no they were adding a large object to
the stack. This instance here is unfortunately not an obvious
case.

>> There are many ways the call chain can go of course, but the actual
>> stack overflows do tend to follow this pattern where you are at a
>> function with high stack usage and call kmalloc() during low memory
>> condition and that ends up waiting for a block I/O down the line.
>> (you normally don't go through swap and nfs, I was just looking
>> for the worst case I could easily see in the code)
>
> You certainly found quite the example haha.

I have previously toyed around with using VMALLOC_STACK on a reduced
stack size and syzcaller, so I knew roughly where the worst offenders
lie, but the list was from looking through the code just today.

>> > If I can do it as a follow-up that'd be ideal!
>>
>> What I was hoping for is that as you are already deep into the
>> exact code that caused the warning and you can already see something
>> in there that may help.
>>
>> I don't think it's urgent, I just don't want it to be forgotten.
>
> It won't be, it's now on my TODO and I see it as a relatively high priority
> thing to follow up with.
>
> Will likely send a patch for it next cycle (this is about the worst cycle I've
> seen workload-size for mm so I don't really want to send anything more this time
> around).

Sounds good, I'll keep the local hack to mark functions as noinline for the
moment then. Thanks,

      Arnd

