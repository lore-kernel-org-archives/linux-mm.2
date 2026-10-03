Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7117CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 13:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93536B008A; Sat,  3 Oct 2026 09:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43156B008C; Sat,  3 Oct 2026 09:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A32456B0092; Sat,  3 Oct 2026 09:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 738696B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 09:17:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1250216091F
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 13:17:21 +0000 (UTC)
X-FDA: 85281366282.14.AA7AD7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6278A1C0008
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 13:17:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EgLBtik0;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791033439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jEE4HcLwsM6TWLGremQKfzztE+rwvfFYJGPZmoq8a8=;
	b=arSrdFqTxGPCT8BRjd9BZBkQ65MOSO7VTSEwIFF6tVnDlsCsR6V3PHoT2eugqWP8kN8Lqo
	ABNDRpDRyMFWUS1q0BHwJSn5aMLpYZRk39jmvv8H0dMWG+g3LcFKP+jHqZWWLqaMiikHs/
	da37XwrVnflbniPuFVzGRGT3uoxpCIM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791033439;
	b=RhlwyLptRQcuj3Vt8mt9a8hf8JAUqQ8hvX81d+/ncTH3Ymv31fQEPVQ+mFTSgOSvjeCA/V
	DrTVxjP+tsp9iHYgnK1SuM8BR9uA+u67YSgAvwvEaqvZnfa5oXTVyBWs1EkhewunfkR73b
	orL09EksgbHtc8lAv1p9/qCHg4wZR3g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EgLBtik0;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3A2760D8E;
	Sat,  3 Oct 2026 13:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E6A1F0089B;
	Sat,  3 Oct 2026 13:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791033437;
	bh=/jEE4HcLwsM6TWLGremQKfzztE+rwvfFYJGPZmoq8a8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EgLBtik0WJzJCXWY/9/TI+W7fRx1wIZ9UfQuWfc+RhMCCFMM/xZJ03UyprLnrZDIx
	 +hSP6z4pIAKExuSJlxbZygGALgGCQywzqqoPN2+Boz6NDgyFCoTr0xtw8XwpV2ytvg
	 iOEb69EMyCjSZk8NVHT0gmIKW0rVbZ0F8RMvb9s4VF2Dbo0UftiN8tf9aa6rRRTzuW
	 Fpm1LnU0F8ufx8E3b1Xf3T36YgbMjc4jOyHoaXzj2tW9/dfBgzxbHqld35pMVHgUgN
	 4zsEh/CAz3fCIdmxhWutMDOLIRfajy8aGYLGHSvm01TwlgzafI+V3dGI5soFrbsjYq
	 SFWdbxe9eRGJQ==
Date: Sat, 3 Oct 2026 14:16:46 +0100
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
Subject: Re: [PATCH v3 31/40] mm/vma: introduce vma[_flags]_is_persistent()
Message-ID: <asD6cgnNVJhZA98p@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-31-4583d8a23bca@kernel.org>
 <9bbdf4e8-6984-4477-a183-f0b236047381@kernel.org>
 <3557015d-23dd-41ef-9832-78b58587f3f4@kernel.org>
 <81e1e5ae-0aab-4584-81e6-3fc9c2634d07@kernel.org>
 <ar-b_Ug__TBzIZsb@gremlin>
 <2e5a4e6c-8f9c-4050-8998-454b83f4823b@kernel.org>
 <ar-luB9QVCRshtIw@gremlin>
 <3387642b-c39f-4f19-ba0c-267bbd2fe91d@kernel.org>
 <ar-ux41ILjI1Px9S@gremlin>
 <a202523f-a696-4a8e-be77-7170c3913cdf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a202523f-a696-4a8e-be77-7170c3913cdf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6278A1C0008
X-Stat-Signature: hw19j1aos6n5nt8n7as5ehq9m9jt8qig
X-HE-Tag: 1791033439-650514
X-HE-Meta: U2FsdGVkX1/6LRtATGp2+qs2BjT/NEug/36JKmNB9kOZrN74FYFY9bWlB/YGKbHB8H1TdLaBHMq7EKhbA33KIrxt4Cj56eiLVqZOYzQMSZZLCH9nY2YW4k6MSe/es2fLdsuHBYsZULAXMrjSwT2//n7J71yHOc/VW0UQim034Mzn1GbfnJkhzP7WXBOshvz3oMdRERf74AjxeYP222Y3KkH0wZORm88rOkoqGttQn+ZD7KjSBFNoLZhZPJwfu8iFk6kFCx4/cvNByWduopN5MVP5Bb7CboJUA3zz9zTXPxFPHuowwY1vnMrIBCyuzxfTc9ZBHyqgC7dWWiWJWrYq8pn9+nm9sYmZWfGFk3e+Zo2El1qVuFhZlmpfQgHZtvVlhLSkzzzq0IDJ5lFHZdWTlmFRWsve4VX7vBSy/WKyDW1geJtC/WrBtKH0+ECRfH+MDEYooRTdv6mtDP1kQ35pt8QOB23fEn5W1LzmOAcPcMzNkGacz5E8HUwgptefTjBEdJk6aez331zaqD+TwCOGM/idKDvyuEXCzZE3b8xpW3do+SnVPlsYMvVpjV4hwaz+M8A5aEJO1QYVEukmpq6jmimBKLhYLbldV3L7oc+LabG2iayptjFnUnJQ8lW7GSjoqJSDTjgD98NLw7ujsCxbin8QQPvSvsuj9EmG1hMbtH9+xRHw7Y7iwcXWJ63e7LpO/umRb85x6ZhTR2UtYLntGGNVDU++tiUjE/YLb3J+NOpRIPyWxt2bJR4bIyfDeSL3FMCQ4BAUG+xWrxk8LR+0XP/M4flAp4UPDxZgWLHBl9wbUrvh/jNzFsvo9SxudahJMkb1G9mePbJmcRKu8uq5jPvsDDwrHVmyUlakNsO6GmJSLyV4Jw3v+cN2bnT/QWIuVKfr/i+yS85wJilIo959rlrt/YGdQFkQ8V5Hs8sl5g9NQcbVUXzdmTGutgATdXmfCEWT1KyBLuJKPRxzZ4l
 dnOixfwn
 aCq0jLRlwnssHjb3MNNn9ZvVAwITj6TYw3FM6VF/maNhQLHnKO/resI0LHUSE2HIRMUNxhPG+c8JFnmxsNVcj1mN2TPmJOpV8Kva+ex5zsTqiLMVszZZJlTLLt2j2KnR7lk1NPcKaEcGtFeloU8NaMph7D1bKDkgVmUD0NPmjHwO9DjEwkbzIWEuHr6+BrxC6u4XbZ2wkzqbterYTx4L9LTl0QPp+0hspn+4X8wDW3T1eOgigxfXnvzzTCg6xY3jaeTXvHDgv44WS5y5iBMgEIP4/LrQExSTZ5C3TOxMGr1GUDxwxb4tOiu2omIoSdcvmy1LrGitVVO2wZQ9sZ8LdHsyerwksUKpplr0hDG2bvYUSc4GX3V6W2Q765+fn9ZbTXFlHFy73f96NJpbVnukOjK+8QS4cFW4Tzhd3WEOEEqPmI4yW/eZUBD99PadtK5tO1riNBBnzns3R7lc2iqXCCGTyOEKVYMBwtLpm0F/sknWBiFm9a6V0bIdCMuz0YmiPkDh4ANM7P/NKC9FGoK3VJbFXlaWjEiD7FWMy5U0zypV9P/Z2IpRXhbT7I5ag9AYiMUncYJMhopBpVr99YxWXO/gSxxY7EO9EnQQ2OxU+TddRHkW8/1bSwsLvO1dCrSRR10ZIskgGaSO+xYLYty1dTr7/VganSxzqeuPDb9WlwCFMlmTMX3LGm4j8/j1LlIkTdoilRAxYwntgXUaBUfWWFNeexj0yBBKTe47+V6c6RMOJPsyjbxQGuif0hvP+nPzB+gMaL7kFMM0w1GZzdOPJKRvKNgEnpP42s5PTqpFwG7zyAcPRSNR0qNKA/eyLHXAUQvXPIMCrP6P36owBp5mrP44WPO5dCzJW9vDuN4Zb2EKn5QWHl0u4yT9r73gNwVvvtl9866twvCUiVykgD1kUV6foNuJlN5fA3q5lyAxfQz9bBX2ou/eJXanGHUiVyvA5taQ7ZoXy7njprAe1ZDDg7FwLDh1d
 KZ4Vz3U+
 Cq73NufO7ccBreWpmA9sGD7CZyicZaMtWzpH4UutOle1Znz0uyAtUFv442/36unyvFs4Ya8t2LyLY6foIPnseLo3xKAujbDXKk54D/sNCA7aHBt/ML2LeNBeKtfpW4N6JqCE4hR4Ak5ycqVJGM8y7p8kCGEZORkVp5CVDVGBaTDIm77UeCBXgST//teyi4VRoNZu/d2XDQkYqP9ciKh2zHN61Xo4ojxngto4VoQSGknp92sup+PrxdSpI2ZAOIEAZWdEvDkv27f+e1bRpKxx9gufgoR+J48dmzmP3UApIAVukYugiLNsOAKDyAnAAmg7uFLTNGqkVLH6HfNkMnc4ENiIBX0TR/aELDmyf8DF+wqynaSuzH4n4bJo0RnvsFHDlmBK0wYvG07ijU6lMhrAElJR2v/8PWNTihaiDvAeIdnl39B2C19Woa9TXY2Mah5ZsvCaRl+54YMzfdNq4Q1MU2wdv2vO0kaq2do9GFOTGa8zls75eOqB/vdFCNgf9kiyQiW18P/xpAAPUxPkwMYWUrY6dznului/ID1YWCqJBHBkV26Kj+OObl0bZRWQhw4NYPU7l8lExZ0egNBtCVJUJMaxPLFMnnsjUzQYzxmJ9COAakmkfk3LMqcoxixl6gzZmfHd5q9ye3I3kiWAZJtfGpi2pL+JpT8eL6iaVbDLxu8HMgqPNc09Hyv3UOLw/Beu2VNdl6V/Y7sIBSGblOXmQgvBMZfoQtlgq4GVWKEOUNguzAsJIsJtVvTjEKT/wV+5foUXQgaMfihmmdQINwM1sdoV7h3pS4oFH9oN84hu8i5iCh68vpSq9pNySo24N3ATKt9/ozwpGR0oSPOninzQPUCi5YsX61HmdUcOijqtLBVMjCB/+kid1EYarfVwYwtJIScB/hV9ub9Bg7cgmDE+o6DQwY1IGAsY2asstG+XgQqC4rTiM3t/F0wGw6pEQxnr7XtXZ9JJVKjTBuB/8UQga7L1rzyQq
 rP6yOWcY
 Cxa7kiKVvpaSIR5NA4vgTVrzfL5X57YjvcS3ZexIDyhEOErmQxL4YF7TysXPmmzBHDu0kgTOnM1gO4zPhZwDyKkGLWGsWTQL80iUDEMf4NsmIHtig62Jx+r65zQ10xG+fCpeC4PikpzI2DJRClhVx+qKYfFJdgAcmm8ZXX6Ev/vV+l0ukLUzbqOuDMVP/USEmSXP48URjYZnM/0T3FK1AbNoDX5qSy9Rk4qpk9Vwu60H+844XCRiC3eIUBxM/5WMagEpHzRniOt/0cOZ2BdG/HsqFBWUSiOpUvYXR0195uE+v4bwqa8WI5Bi0G5+iHZDkui/X7w4yzQJA19E776acA70R81bvTpzBC/nvYeHpOD5vVedQ6jbH1jzpbuN8rOJRQmTBTVlu/JpmAi1ZQkm27tAaU/RstXvBMQk9k9j8nikXochdZtYnTE8VYeA0vLSaNotJ6FYG8cf9WitsGz3fsZOXpoiDphVHwFXcf1k3qlyg5d+RhzzfRuV+fqIMtcEmBW7Mk1Hzhv5qGL88w3UK8kOBMM4M6gnidpZsZYNTr5aOjykowqNj/KnHlHG/rgfQKlms/x0fMqE7/3QNZhfzUQ9cjE6K+hMoguanjVBYZoQbgYjFeknUrThjviUKbIYCZmVFcBHQ3dVj5VYrblQcuEUwfHfCnnU1aAXhfs9m16n5vcBjlMkhIBMi9FoTE6osGAZixhpWqgJcHYrnJohkXqG6WPqGXymLutDPMJIlk1g210zCRQxnGqmavgj69/kpAyVl5OQVr8Tkmn326d2OdA0OurCB2yCGmthkN8wwuUY+gFvCmTm/dk6X9IpXifXltsDqejqRYcrVfPT5YdbHGIuCdfn6iCtIAtTGcfAvuHhcjTJQSw4yDrt/nLws8EmlearsCZriQMTKV4HChDOZRlsVQG+5+eANkQX0YuLHO9LrtPJxG4Y6HpWuREJRv/s12/p9r/UnUdZBZMSwC4K4KZsX7jsq
 81n/pNiO
 R0jXb3XLopp49OgG00uIKFLSrj8h/g45KHYrk/qtr5OA3LV7UYzA9LMCRgls2r7HUs6KBsC31ZnQZe0kHOrEtnGsU19+oqz4BCDaloElmt/FY7NvAdRDJZ5IjAVdKSh/jEZ/KFx5qQB2m0mNdn1nIv9jorKt13zRNlgjLIlnR/YjerUvFk7bYxNIYFpyOH/3rTv5nYzuocdqTgKDnlAW7qPslmXM/z/rEY508nEDdO7nu1MmVPz5MyaGTEIw2S0+NnPkwsJR3lwozv6pFDv82LI8rS4zIFKyueFWjPY+HxdeBLXWw0sCULLMdxWq1ejZibzj4riazYQ8kLN3AVl674XgWRYSXGTKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 11:43:53PM +0200, David Hildenbrand (Arm) wrote:
> On 10/2/26 15:59, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Oct 02, 2026 at 03:11:27PM +0200, David Hildenbrand (Arm) wrote:
> >> I'd be very happy if we could find a clear way to describe "this is what we call
> >> user memory: anon+pagecache", if that could come handy in such a context.
> >
> > Rather than arguing about it, how about shifting things to 'what backs the
> > mapping' and something like:
> >
> > /* big long kdoc... */
> > static inline bool vma_flags_is_mm_backed(const vma_flags_t *flags)
> > {
> > 	/* hugetlb is a fixed mapping, but the mm owns it entirely. */
> > 	if (vma_flags_is_hugetlb(flags))
> > 		return true;
> >
> > 	/*
> > 	 * Kernel-owned mappings are populated by their owner, and fixed mappings
> > 	 * have a layout the mm cannot assume ordinary fault semantics over.
> > 	 */
> > 	if (vma_flags_is_kernel_owned(flags) ||
> > 	    vma_flags_is_fixed_mapping(flags))
> > 		return false;
> >
> > 	/* The mm has promised it may discard droppable memory at any time. */
> > 	return !vma_flags_test_single_mask(flags, VMA_DROPPABLE);
> > }
>
> In my other mail I was wondering whether we could use vma_is_mm_managed() to
> express !vma_is_kernel_owned(). Maybe vma_is_mm_backed() could fit into that
> picture.

Yeah, vma_is_mm_backed() = 'and the mm actually keeps it there' in effect :)

>
> Reading above I am still confused why something that expresses "backed" talks
> about "fixed mappings and ownership", sorry :(

I'll rework the kdoc to be clearer - I think with vma_is_mm_managed() the
picture actually becomes clearer.

>
> It's late here, and this is a hard nut to crack.

Yes :)

Thanks for taking the time with this, I know some of it is pretty heavy going.

>
> What we have here is:
>
> 1) Is this an ordinary MM-managed VMA. So far so good, I understand that. (with
>    a twist what I just learned about things that map random allocated pages
>    through -> fault, but so far so good)

Ack yeah. And ack on ->fault.

It feels like we let ->fault be FAR too permissive. In retrospect, arbitrarily
being able to put WHATEVER YOU WANT there was... unwise shall we say.

>
> 2) Is this MM "fixed" that makes expand/merge tricky, except if it's hugetlb
>    where we can still handle it.

Yeah the trickiest bit is the 'don't expand'.

The hugetlb exception is ugh, but hugetlb was engineered terribly,
essentially 'stick something in with total disregard for everything in core
mm and make it an exception you just have to remember for everything'.

I hope we all learn some lessons about what not to do from hugetlb and uffd
:)

>
> I think VM_DONTEXPAND is also rather misnamed :( I assume it really means, using
> sel_mmap_policy_ops() as an example: the MM manages the things that are getting
> mapped in here (->fault), but the pages are not really pagecache/anon, but some
> other shit. So we cannot expand the mapping.

Yeah. And it is terribly named.

>
> Gah, so complicated.
>
> 3) Can the MM drop the pages at any time.
>
>
> I still think that 3) does not quite fit into that picture. Using something like

If you look at what the callers do it makes more sense - mlock pins pages,
ksm merges them, dump writes them out and uffd hands their faults to userspace.

All four need the page behind the mapping to be the mm's own and _still
there the next time they look_.

With that in place it's not stable so it's not right to let such callers
have access, and all the callers have to remember to check that.

>
> "vma_is_mm_backed" to say "this is mm-managed, but all things in there come from
> core-mm and not some other random shit people punch into ->fault" would work for me.

Yeah agreed, I will update the kdoc to be clear about that.

>
> (not sure if there is still some other way how someone could get random pages
> into a VMA ... or how to catch someone not setting the DONTEXPAND flag)

vm_insert_pages() + friends sets VMA_MIXEDMAP_BIT now and
vmf_insert_page_mkwrite() is DAX only (a follow up will make that a thing)
so it's the damn ->fault that's the only thing left now.

Right now I think that everyone that does something weird sets
VMA_DONTEXPAND_BIT.

It needs renaming to something like VMA_CUSTOM_FAULTED_BIT or
something. That's probably a terrible name but you get the idea... :)

>
> God, this is all such a confusing mess with so many ways of getting stuff messed
> up by other parts of the system. Thanks for working on cleaning that up.

No worries :)

The whole point of the series is to stop treating these flags as vague
things (which VM_SPECIAL symbolised the most) so a. we can make sensible
assumptions about flag combinations and b. people can use meaningful
semantic checks rather than guessing (sometimes wrong).

Hopefully the pain here is all worth it :)

Thanks again for reviewing!

I will respin with kdoc changes.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

