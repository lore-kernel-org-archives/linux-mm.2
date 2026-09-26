Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E1CC98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 13:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721146B0088; Sat, 26 Sep 2026 09:07:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D18E6B008A; Sat, 26 Sep 2026 09:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571F86B008C; Sat, 26 Sep 2026 09:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9676B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:07:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6791C087F
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 13:07:23 +0000 (UTC)
X-FDA: 85255939566.06.3238756
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf10.hostedemail.com (Postfix) with ESMTP id 780DBC000B
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 13:07:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=JY6ej2Ga;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="w 0Cytzi";
	spf=pass (imf10.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.141 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790428041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/0Aixz4MoGQbluxHxh98fr8xrgoH3pVa08CacPtFqs=;
	b=Ay5r50LEy04H7wxCPkknskrGeLgYsJ33ajJrOpoAMnlaZzAao7cgrPIaCXurpb0XXRGqqW
	29XfcnW30izcwblDa4Ebd/45UcTxFbIG3/q3XJ5HdFqMkwq2mlLvOLkYpzhAyNRWJRCwtV
	cSJGrjwvrwLhkdXheCv96FEwmgNw3Zs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=JY6ej2Ga;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="w 0Cytzi";
	spf=pass (imf10.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.141 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790428041;
	b=m6ip9J0MXH2E4qmRobzKUbFj7nQ72RRBkNqc1J5jr5C0fVC7mXS9l/WbJf1V1LDaiuYv+n
	w9gNkW5mxWuxI2V9efc71+32AYkjlYDpC5shS64X7DS3xaFnFtVCZGo+MgTfTrGDzQYZ0m
	m4Iy+kB1ENEQGIvTsavOij6IsFYtRdg=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id C06B913804B0;
	Sat, 26 Sep 2026 09:07:16 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Sat, 26 Sep 2026 09:07:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790428036;
	 x=1790435236; bh=E/0Aixz4MoGQbluxHxh98fr8xrgoH3pVa08CacPtFqs=; b=
	JY6ej2GaMU5tFQx4P4L7xpK0hMl18csetiXOfr6O0dqdVPmShWq0JPpifDXCAXS1
	WAsyKi8pjs7t6RWq759bpX8FHUqqgB3ix677GOzcftzN7F9N8PLmthIECeaNfa/A
	P+2uJuuFBTTgZAQ7EbICe01O/JdcPwKinMgJvLho7IluNFj8RTtGxVmNjqIKiYpj
	UR3vOmenvvoHhh4I2ZiYEvackkexMn3lXYx3KuwIgkOFVskKsEp+lc6xtXygxdEK
	AjntRnwlwzXroiH47DzyeX4QFd/GKDl/9E642yS7DF2Kw0s0p/0L0Ubu+WuXNN9t
	Dwqap0O2x84uyGP2aDdDPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790428036; x=
	1790435236; bh=E/0Aixz4MoGQbluxHxh98fr8xrgoH3pVa08CacPtFqs=; b=w
	0Cytzi8wSmj+mFhvAnjabMb+QZf7M3dVCKLEj9/Dbx70AK0JLhjm4IvD59f8aPoW
	M3lSl46dKAne7di/wMTJ76iJeR/YN2CWmJ273SA+/BycJRtz2TadIIcXjRQRA6Fw
	d1PjbiAXLrHehMn9sWL+H1plV3O0I6zA4hqQ8L1CMVdgSuWipTkep6zve4YfEqP0
	Zs6j6tUUMO1riGOt8v1vffbaH/NF18IOy7CG4zw9bmOLTzHJKqkXp4V6OtaaRa5H
	2eR47nryPx9zkA9F1ahtgW9c9sl4Pip3yYqEADEeqnrzG3MzERSbC2635R8ZhKrg
	pwU3ej5l8FK+5aoJABjXA==
X-ME-Sender: <xms:d8O3ag1HENOK2aqX5Hwlw6Q8RFPRNjCrvC5EQg62Q5MwZ2X8bbKZZw>
    <xme:d8O3al7CTh-qdNdQdYHKlYAc2HK5Pct0chw4_Wh6lTausRDuhvnXgNqkprm7sdGdM
    5U4_BMYkuFoj-4mearySbRTQ_cmndooZhYXir5Lfas9_vbxa-3XFA>
X-ME-Proxy-Cause: dmFkZTGluhR8DaufX6B/O8p7kobwL+s/+e2WxIV1ftwgdk4MOyOBMt7LN1vTfG/eVZk0Du
    poDENDPAZWU/+DFm2TqDnNDFfgVA6hHaGe30H4n6HeZKXNfngYWBIprCqpApIrE+Fbsucg
    3T43On08Mo6RNjVXL9te8gsrxz2WjOyw/W95nmJYPc0JMOu2PQIIsRRzHlvn+vNrT8LUbX
    mmoYyzTpLxtlzDHIP0u3kK4ktm0M9xoXlmDPLfcWfL49p+EPf/LNIMvJJMcvl0MfSqseyk
    Rsr0fjsMhmDFEIX9RQVpOsEW/sifidIp5PFecnwP38g63Y0mVjJCAlVER9svaUec6rZbmC
    qbtQKRzPvL8vBpUlrACJ+50qfVABYjsNU7+coMpX7EK9rz3tWqDsshpIrekmR1EYoFIwzi
    MFzRtA6nyv0gSEWy8V3Jxg6yoM9xEoGlhkpmswvoPC+1yCzJfj9aqpNmAvG77toghXLpW3
    oSZGIcXZugioQhzHy9zw5o5cRzaVDoEyD+WlhlAIT7/5QdIXyAicupFVuieBjIjNc7MSLE
    ZTeTptEMpLzGLB31HwOxannZP+AQz43E3ZUxZlcqdrZ09Q6mzAI3aJNRZ88M2AiEhJSkoF
    SRPUmVb1bqKMeD4YM6wIkw8UjM82p5rtkv7hDfqSo1lynYzWf8HPL9EYqClQ
X-ME-Proxy: <xmx:fcO3asP_JZb7_pe9MebtKK8m1oQZ2mFysi4LzvtqxqjkK-xmQJG7oA>
    <xmx:fcO3ahdCUIGe_-N0_11cq50k2hB7qoMtAn8OQ0p4v_cKD3b-BZ1GSQ>
    <xmx:fcO3auH0MA2jXNBVepFNbfn0NcMhLJ0i9yrj76_mSiuk373fUnS0zA>
    <xmx:fcO3aq71vFxuFeuj5WpfAshyYTTqDxV9SfXlvv_NrYetkbnGCsY2Uw>
    <xmx:hMO3aqB8ADUszpbuD6K9q4F8d_--PVT7Q9k3xSG4B02mLBEY0FvpthMT>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 577F132A0087; Sat, 26 Sep 2026 09:07:03 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AJwEWD5WPnhk
Date: Sat, 26 Sep 2026 15:06:33 +0200
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
Message-Id: <408aef6e-5b0a-482f-8ba8-f8c20ee870e5@app.fastmail.com>
In-Reply-To: <areSEI5pWBadkqIe@gremlin>
References: 
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <d4d7d4c2-a1d5-41d0-b1c8-8ea0cc5a0397@app.fastmail.com>
 <areSEI5pWBadkqIe@gremlin>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 780DBC000B
X-Rspam-User: 
X-Stat-Signature: scwe7ten598fy5stxu4cbj63p8osk8fr
X-HE-Tag: 1790428041-392720
X-HE-Meta: U2FsdGVkX1+AElhwW4bkGHMpiKBg4YZdCiJpkgRUJ3vYBbBlrDfj1xzX6Ii90STHzLkFFVbzYvhRvQMNYZlgx6wU9/VY6MgLB+PvTJiErVOMGqJj72LwflFNaWwyEy5bC3PmspOyRZ1RnTsAeupXRIEEBSBNAQSceXv0k9Zjch04DsIXGbJiOt6iTVTQyEhS3xVwpb91WxCYvkPA6ek0xphVoQodKkhO7FdgXm9uf3aoXKplyy+0iLWWT38lLP/m2xfC3s8ZIKTUYdkAHSpIVgAPsru+TdtnmgxYyUh9zAohVvnvFnWVRA83OzI+qrNvOcUX/2o+GtbADEV8jlV4ucPoHN0+JC4pqJj4QMPidw8YGZz3ghqtt6GAy1d+aXL/4mmJRVA2d2U4TCgVvGM9Dc2PqwQULS9K5r1CEhT3MRUeIxHapFE2z+rl+IvyWDVWbMBLwqWVFmYY+O/k9G/pwyOa0qVKIyQ9ITFPLP5bp+sT6xRPficmN5Hq8O2Lerv7GoRAguovbtKh2uGT2m8Vj2NnoM3LSgsFByBTB2ejkxNfX7WU4K5bTh2gUEKe9kEI00FixQZS9qxoyAC87ZqxObdt+aGd2Dtr7zKeLR3k27mRTRRF3pJ8FK/4SmAWlpIh9Xj7NPl1w0HDWQekOaDbQyTdSCJQjM4Ib7rVaTIpE88qUfP4MMID5/jrg8JJb6diMN3Q5XbdFPmZ1lKwHs6P/NS8OWpzjtxp9vZFbI0kK8uC/xWFdODOx6tst/wVVlhZiozQjdDiI5QPvS0bmMX9a2W77Anpf99AWQQxbaY01YgyU9RlfJ/1dBDVweCw48WY8S+j+8UcRSknUC4Nt3CAcMBAv4CtGLPVdcw6nzXpNew1x2ihgeLABx6L49XdC+05og4Q79Gopfsl9HwboVD3Th4YOawIS25OAMe56hsTxJ+hTl5S7tFi8lFvpub1PGK/IYmwt721DQQS1Ivj3a/
 YSWBstSJ
 Umwn/MA8mZ4dKzNQvuk/eXsl1z5ISqxvI3O1PJIXGr8ts1TINWMTR0sqmaAvwBuINkHC7JSo0bVhunWHZyOKYLh0IpCX6UnrdMoxgpVCi4zu6pizyeWKpSk1AtB8pPuvYkshzTfJSzzQ3HNghTB7gisNaSZSsBugC85YYOKIUDvl4yF1nMoPkBFndw+YbAYtHreOPC/KvIx6RjkIMc8Tv+8zH02+KzEcreY7Gb7CSztQR8nlTQ5HJ6F3Losm/0TbxTiin2//DX30BIWvitDE10GP9SqPTtcXU8Rmj9Ny2boPfl9GZne9yGV97hsewW2pDwPDsunAb6UppwKZ1pAM4KyG9a2Tp7WIk5truRvjCmIxHtcadgqkm8gvo2zs9ipbOdA9NYMFP8lWAZWcl+vk0BA/7uUXv2Xz0/HDf4W10tYH83B8pBitVnYc7KAPOF7T6KSjOtEZKnoe2p9fIPnlan4896n6oCP1FcbirY7gYaZ16BfjD2IzkVSEGk5uHStv6jMF6pAvvyQXwWfADCOHl63f5U1+bNMqTZuIZj6262ftLKsQM+rahKQJFv8A23Eqb0jrz/aRKJwTI0OLA+f0TXB25bZCnSbFt8mZH0LOH8wvNOISUyngGTy0wwkHF0/0JM5eVivjKbppsb4+pK0M58LFnDw4XRuQoM3ZWBCBdfFMTVwnRXqal7u6XCLVx3vEJiBgNjRpiVHaViU3V+XxPydoZjxk5JrHNz+JwEeVJrMTY7Ynv0XiNAZPaCOsHd+fk/+wY2cscnFb0kz+cdXthx1Rtu6tMjEImF/XZyX3DDwUe/mxFetnyDwMEMm8cP4vpvwxQcBcoDiWqwT+0INA2K2KJ2heX+i5E5kX/Fd/DHj+rINl8UKcHAbxuTGwC1naYEesM4ooxgD3n7T6olEoPyhOgaVVzkf9wrYjTg00I6St3CnRaciW2IIp6iCB7Wa8bux3Njdmz7NTTA1eL2/wG1gGF8VaE
 g7XkgY/b
 6fg8G0hQEDYhaCLGelPPB7fZeaS/qB/4odW6W1i6V8DVbXLMT5vk837oXmvkE8Gg2uCSH1OFrK3dCsn8IN4tKFhjW4IH2K6kHh6BxPkqnrW4KpPb2IAtFpF7XbyPNyQP/wtZwdze5hxF4coUs8il64IZS9r0SerKsnt5wbe41b1+fHLQm2l8Bxa6JFBvtnF2piQD62Z5rSOEoR1RpqKiPi7OiyNVH8tDdgKlFn/i3fBVQvwe1h6W1hnK2hOYzX30dm2m4LbNNas0MHHu3EgcNPLOUE0rMRbXioZBxf/Dd2d/HhkzKRwtRide7bP7k8NHH3LHVZPPwFZX1WpLxkzpOVzLpLeyvslm7YcMMdl94g/Bap5L57j9doNyKmfXKBT9hi0Wo8LHTiN85UGWLumlkRqKxr9PUjcygx9VY3LRs0qTP3IJjlhuY1bAXI2DnPUz+/Jg/k4j2KzGiQmpMm101q6SkmQuoTuxwEL5oIKVCd92ffjNf5Jl9tRHnNwdgqSta3O4CfWztwiQQm8jAQrYUZiWlOpcDwwo0e8BCmymyUKlCHwZwgw7+OfiQpO/8Ut7fFSJCVPK/0fCEbr48MAZEjAlAE4zZsZKCDYTDOxVSUVEUzblQTXwy+nkXfKgoYKmDSVjDZdLZ5WuSBxhCw8m9zzhmgQm36Zw4V7rcHvCYpzGQwoGZQzzJxclZzv2aKuS40KFvo0lP/U8ajRisX7O8OUKscvMBx/N8hpDHS6s5yNfZusk6K6PVAqlGuIT9CCz84hUJMFr3ev+v8J1VmziOvu2nGot8cgYK+x2r+b4TVats4Ql30h/dXTdldg8ffr08LdV/t/nxs7dfVcFYVMt1J37mliuCiE/6RLq0VPR4ZUqFYdN30c9S8Ja6ZHD5IxxSo3dky3HePqgfDnUrcBkGiPqk1ZundCyxTJLh5AHtFut9XsqEWvjhUmkfXH/njL0zBMTLljdx9uUUVApRjILiqhC4wvbI
 uzJsgm2p
 mBwJY2v12XJDTLrY22sHJWgRiJzvrHzGxKICCXHIcSZZUOrTirwUugjEsqJT0CvVu+03vW8LytJe6U/npxr49OFiBgM3ZvFmFmmLmNGFkvk0PFKdgQcRuxk/wyQZd6hW8EMGFxlG2z8CTXKpRFXfxdnDmXvs1EbEpJXbQZkw6lIwdQ5bx4YxG5S/9SX2dsH5/OrSJp+U902B6c/smkLv9RcqNazStjYGGZGFlsnnTS0v6Nwvf2SgB1nrRDvmq1ypf7qnvokCrc4wghnrM5KqOioOzo+3YdvhgFi6ZTWZd8ZLirgXCeX4UV7S7acHWFmntEh5DRyrXmxAnkHtd88or952BDkCXDD0wXo3ualbHta87Pwsfp296Jfc6K/AFqTpA9x3eM1xz8APWAc4/lIAlKj14gwCQ6aAH67zvVjpkZmIkDl14hMwuIm3l/nzv6C3MDANpjLW60ML7kdSEZ62A1vuSe9ErHzDBNXSm/62WOsZ/kj8RmwXKeLTw2Nuz3pPT0ijsXSpDBr81psjD+cOTSMTJHqvpSv+BAEKxRKRAkUQG6IsZg+/q1S6/lRQ5i3hVhwtvLgqZ1f0sY6zwQUprDnBlz/k6JAIPO/6WFBTsNCCmJAUy+Ezx0ltfR6YxFDBv6ilEhwS5umVnIxcFyLDW8Kk4cJdUUESGNf8VwBR7fKhQAn3TGMe2Se/8K4mEyo+XZ9vshNzN4TbjSDEYwTkB0o+fLiEUcGcwdksQWtnmO54TiPLEt8kf5PJj9ep+r2+0EWqnbKABzhgPwfUNck49pshnWUxYGU5izv/Pw74XL8DJyg+JKNGR1QpIS0PQPaG5YVmyZcvr0yrP898PAjrl6FNfEIpzNWCSP4Ut74BpvoKsYg6DWOCX/Kcqp5USGFEtV1CWwLRh7JeVbP69oOhoS1LXqgR9PYdS0ygUFDvK0HDj2JVrwh6lrhA3B/wETuO/aH8EsNdcovyXxYhSDxlOWwvd51d6
 VZ7WDikb
 P0yvIQriOiNFhqEfqCcr2wSE/kGIG1/aUw8KNspleeZNs8VtGcmeWHKwUucMxW31DNHA0wohblC99nFCDncqWwPLxSGk1kLibUtk2YvUpnpFAd9gv3DFEeOrv9CeqNyHk7nhTDeuiRmkHZkbIqe6LoM1T2Bg2VAr5vgb3jp1GF0EVWdbDIndOKO9HPa+gU3LNEq5fqJiVzgMYn/00rBv7ajMqNmPubSiszu67n4BR/jbb5BZxrd9aIs+RnQUir08LG3OE2eJDEwUaYdqFOUSlrQtjykf4w9lSC594IGYuSBjFkkkhdbBZ/ZIJEDwQA0f8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026, at 11:40, Lorenzo Stoakes (ARM) wrote:
> On Sat, Sep 26, 2026 at 12:06:22AM +0200, Arnd Bergmann wrote:
>>
>> mm/vma.c: In function '__mmap_region':
>> mm/vma.c:3083:1: error: the frame size of 1552 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]
>>
>> I don't immediately see anything that you did that would have introduced
>> something bad that wasn't already there, so it's likely just gone from
>> just below the limit I was using for my testing to just above. The 1536
>> byte limit is what I use on 64-bit builds with KASAN and otherwise
>> still has a clean build (with a small number of local fixup patches).
>
> Hmm are you specifying this limit manually somehow?

It's a Kconfig setting upstream, but the way I'm doing it is to have
patch that calculates a sensible default based on other options that
is a little smaller than the default (currently 2048 bytes) on x86-64
to catch more cases where something sticks out.

>> If I sprinkle some 'noinline_for_stack' annotations on functions
>> called by __mmap_region(), I can get the size down to 1144 in this
>> config, but that doesn't sound like a great workaround.
>>
>> The large stack usage is potentially harmful if this ends up
>> in call chains that have additional large stack usage (e.g.
>> kmalloc() leading to reclaim). Any ideas for how to reduce it here?
>
> That can never happen :) this call chain is _only_ for an mmap() call.

I mean more functions called /from/ here, something like

  __mmap_region()
  __mmap_new_vma()
  vm_area_alloc()
  kmem_cache_alloc(..., GFP_KERNEL)
  slab_alloc_node()
  allocate_slab()
  alloc_slab_page()
  __alloc_pages_slowpath()
  __alloc_pages_direct_reclaim()
  __perform_reclaim()
  try_to_free_pages()
  shrink_zones()
  shrink_node()
  lru_gen_shrink_node()
  shrink_many()
  shrink_one()
  try_to_shrink_lruvec()
  evict_folios()
  shrink_folio_list()
  pageout()
  shmem_writeout()
  swap_writeout()
  swap_add_folio()
  swap_write_submit()
  nfs_swap_submit_write()
  nfs_file_direct_write()
  nfs_direct_extract_pages()
  nfs_do_recoalesce()
  __nfs_pageio_add_request()
  nfs_pageio_doio()
  pnfs_generic_pg_writepages()
  pnfs_do_write()
  pnfs_try_to_write_data()
  filelayout_write_pagelist()
  nfs_initiate_pgio()
  nfs_local_doio()
  nfs_local_do_write()
  nfs_local_call_write()
  ->write_iter()
  generic_file_write_iter()
  generic_write_sync()
  vfs_fsync_range()
  ->fsync()
  xfs_file_fsync()
  file_write_and_wait_range()
  filemap_fdatawrite_range()
  filemap_writeback()
  do_writepages()
  ->writepages()
  xfs_vm_writepages()
  iomap_writepages()
  iomap_writeback_folio()
  iomap_writeback_range()
  ->writeback_range()
  xfs_zoned_writeback_range()
  iomap_add_to_ioend()
  ->writeback_submit()
  xfs_zoned_writeback_submit()
  xfs_zone_alloc_and_submit()
  xfs_submit_zoned_bio()
  submit_bio()
  submit_bio_noacct()
  submit_bio_noacct_nocheck()
  __submit_bio_noacct()
  __submit_bio()
  blk_mq_submit_bio()
  blk_mq_run_dispatch_ops()
  blk_mq_try_issue_directly()
  blk_mq_run_hw_queue()
  blk_mq_sched_dispatch_requests()
  blk_mq_do_dispatch_sched()
  __blk_mq_do_dispatch_sched()
  blk_mq_dispatch_rq_list()
  ->queue_rq()
  scsi_queue_rq()
  scsi_dispatch_cmd()
  ->queuecommand()
  ata_scsi_queuecmd()
  __ata_scsi_queuecmd()
  ata_scsi_translate()
  ata_scsi_qc_issue()
  ata_qc_issue()
  qc_issue()
  ata_sff_qc_issue()
  ata_sff_queue_pio_task()

There are many ways the call chain can go of course, but the actual
stack overflows do tend to follow this pattern where you are at a
function with high stack usage and call kmalloc() during low memory
condition and that ends up waiting for a block I/O down the line.
(you normally don't go through swap and nfs, I was just looking
for the worst case I could easily see in the code)

> In general I am absolutely taking this seriously and will find a way to
> reduce this, but my only question is whether this is actually something
> that needs to be done in this series?
>
> Because it's already huge and I would rather avoid adding yet another patch
> to it if possible.
>
> If I can do it as a follow-up that'd be ideal!

What I was hoping for is that as you are already deep into the
exact code that caused the warning and you can already see something
in there that may help.

I don't think it's urgent, I just don't want it to be forgotten.

     Arnd

