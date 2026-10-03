Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08817CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 09:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7C66B008A; Sat,  3 Oct 2026 05:04:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9CC6B008C; Sat,  3 Oct 2026 05:04:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770C06B0092; Sat,  3 Oct 2026 05:04:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 422996B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 05:04:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 15F521A092A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 09:04:05 +0000 (UTC)
X-FDA: 85280728050.13.6A11470
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5535DC0002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 09:04:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UU+loouH;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791018243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NITJ8yWQ1OUFlY+k5bUccAdy4sUgfCl1c+vQ6EKuHAU=;
	b=QCN60T8mrvIpGlK3xiNuqkooEPKoeA/X7V+L8A046CsJnsZee25HUD+XIfd0asqKStlvdz
	yymqBF1eBTJQhb7rnjKKaA9vsWisF2+LNlr5WTO/crjqEcNEDDRsQ8ifOW6bh47/igqOe2
	1Yi5hSStihA/pFDCy2b9BuYqj+fkm0M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791018243;
	b=kQDusVFOZKvKdeiwVM8vg455Ds8pQDXSnpilAOevJmwyxjYdxVQav+VHcWwO1aKWL+H7AA
	cj2ESubPFRHCm3arma5lbORtGOr9b+79DjqngIWjEWxw9kp1rZSdvD4uxO/GrulZ/8sY8o
	CLdnBT8EJG8ul4nkuW0qRhcqu/CsurY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UU+loouH;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CCD7B43B22;
	Sat,  3 Oct 2026 09:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767B81F0089B;
	Sat,  3 Oct 2026 09:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791018241;
	bh=NITJ8yWQ1OUFlY+k5bUccAdy4sUgfCl1c+vQ6EKuHAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UU+loouHu/X9/2nGZUM3yCjbj4m/KC/TpyT2T7f6ukoZ0E8xdeCQhCux5NhqFywrK
	 emhXMJF4ztWEAjcQUfNwmoOfmxWibJrgcS0Y14+/3QYIKiQ5kMD+QrEiMuTQiog1N8
	 HdzT/Ef9+BC0kDIPVp13fKjpTa3KnJQlYUuTeVVgi+gEshYQcDbogRYzy1bU/u88qg
	 37uls/VRrrDFxVnS7En+EP+D0EmvYFVAJfg454GL12+afZ6I3k3lu7HdNKAXHgZG9u
	 cVstBTuY/reLAY7kfSL/oJgi0aXYVR8zFlCr4BXzJpC7jM5kV2qrlq5ymtar6nRky1
	 2H6/ZXoDRdmXg==
Date: Sat, 3 Oct 2026 10:03:31 +0100
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
Subject: Re: [PATCH v3 15/40] mm/vma: add vma[_flags]_is_kernel_owned()
 predicates
Message-ID: <asDDLXqBduWVX0k8@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-15-4583d8a23bca@kernel.org>
 <0623ee06-00e5-421e-a24a-ed605abb559b@kernel.org>
 <ar_CYfkR5Pfb7J9b@gremlin>
 <83bf4650-7339-4fc9-89a6-378a327f4f6e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83bf4650-7339-4fc9-89a6-378a327f4f6e@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5535DC0002
X-Stat-Signature: 845mxqyastsby3hu9kfbt3rkbddgxynj
X-Rspam-User: 
X-HE-Tag: 1791018243-341036
X-HE-Meta: U2FsdGVkX1+lD9P9bw0yUwk5lOLU/3PxR3UhvHPrsaHMsjC9ywGywmQOek6gUi/SsXOphiJCJjxolWQsc3zTVAw5G5efbXOKvM8q9ydgnlNIkO9wcwnz6MxNRFqK2OAZPVSTjXpQjRvWDPRIMnf+hwIp+0kEKorBzuRVopXWDJ0xbTq5GkEl6OJChBmg00dv8h7JMIuF980eobzMo8UjUaomjaNA9b49FRJ96JALK734DP2tdGbGPo8N+t6+nvFG7DNAF4EDwaUfE+PQ1fS3aw/u9YcBcV9prg3LAcE2hQiCme8Ee9pQT/gxnVBf3lO8Z+jKFvOX2aceowwYMWlRpZAVGaARsYPmUjQuTbo91acTQloMfbaHx30QK9kEY9ACefUUoHa+V7qaDUdpo0u9jGFUj/AR0aaBS2pC9TX3MHWJ7MWA9fv3UmW+q4QKXA+0WbeaO/fPuycn4T2+BmzOVeGHYjuIR4wNIXOVTeBjwuxXZK9JnRS0jldYyeV7NdZJ9NS4f6qAuJh+UDDjjkrbFvjVqZiUkNbOyMfXAJCDvxfCJNrObO5a+V3YPYLmbm6skJ1sJPKIBhmtLN5cHuu368UcWkYcHXXl9+6YIyGapQDu4No8PrsVdxGMzZnPpriI/FRuAVr2jgal/NIRAb/KDWZrrooH3rSp+oamxE63WbRJEbBdEDDb6c7/+noauB4xE7s86BLMQE2/JK6OEasZ+T4M2WJZ3s3N+IAAcvEAp3guBP9SjN3QffNHEv4k6R+23M0f8R3qGCJY4qMLUPh5jFthi7jbnW9u2y6D//EjvlDeRrs3zarFeb6HfNacI2vaHaY1U18X3IA9YusO0LFAlxd3R//maB3kgC4XSXmHFJ2JHax/MyRDRJjA0MnN2rBwaaVJQ7Lebrx9x0/vC6wyInSFok8cwXa64/EWxKCcHIBnl52SsCcSeyMOaASYInLQQpup0qq03Bo1PLqEknT
 U0Ru1onR
 fOJ8SXEac5XrqR+rNTB3F20bO2yfviq34wg2TkWYbV8rrra40fWl6pYSGW+qspnJXDg8jVJEJcGl80QZhImsNmszfTG1Jv9fEwOec2lXPisAhy8uDIXi+X6DrvAXb2BrFGpYRxMcOn0V7vRBYE+Tf8ASno/EFVmlxwK8cpWG1V0LR05HRF9mAZ3M+nGnHU0FVH8CzjxU6r+4l5kur5g9f7tOmUN/k6uvG/q5X1GELvUc22scheW3VV2JPMPoKKKdV+xdR/U0g+57EL5bT3I0qbC+eirpe2L485f4R2DqJkTEDUt/PfiI8BuSIr2ne8zL1SHJKVV60fGychqxEUOCLKr+kP4fMLNFGNL6m/yir8ylY7okwEPLH48VAvFZz8355lTy6Lou0xdTy0bQXPzFqyKDRrh/2cdACiyrUWVHtoim2O4AmFxaOIM+sLWWLrxC27XDdQgstHVTTGwoe1GHjaaS5Z5U/wRLoOC6qNqlntIqt6P5k7Xa+hguT9kyjMf5RRLRxEHxWucFF5LeJsvIZH8EKWZI1VjLVVGIjFpcIxqyFAqPeczD1LlYS+k/mY/2yl41TexW3RMjiyNXcN9Y/eKnA4QJq7GhTn5iP0SSQO02pHYi491nIbtMqFah6LcnrK1VLBs15e/PU9RlXYnBg4BtPuxthKx/mJJiKEXy4Z9bngfzJr56ulDmPHUOWWkx4Fk9lPGyDCT8pF4UJABTthNOiy19Y5yPZYLTQidQm3kkeL7gNSBAsD2A0pguIWbKG+0QgsERaZnMmqRBNen582cRcwpZ7ZI4hU9osrpK+xJTssZPvszavH8uxf0xl19GLJKWVeMDYjyI6XULdo14fl8qM7WDPY9C0qOA8Hj/ndzL2VTotKAih/dcQ4j1A/K5bjPpazSo+ZFIEJFvjgMY8DDc0ch8cSz/m5G7RLgCIF8A7LPpSuKjhZpwjgFmjQrG5MmKpgCnltPQxhsd57y2laUBj6Xsg
 1iZHSMrl
 06qkzOkGra+AH60CqluvA3zHfdE6WbgRSZwkG7kMB957LSfLK5c8DWzj/UogDumrz8Vi8ONiJhCNoIF6fvo9lsWnOFjki8oMb/YuFaeM4p2dkPXeVobh7FLfRojE34wGtl4eOtiiQOo9/PMZZJ7ZHQEN1WH/QI/U+72/KK561YlOIAmLeuMufhwbgiKNUMmi316AHS6w7/PdGdWn0DXcy62ptTrcPFHOOT6QPPbl268utFveqYQfibdoArUZ+fkNuMIXy2hdh3NpGd0LmTjudO8Wjttp9Pt/FbDMykRI8/ihq45isczUIBiQRIl1JJZOP4uAWH5KJW2kY3bG/pTs/C1ZzXjtTffvJRQoBRukSeElnCKuOlTvdMTeIY6TCRJ8JMDpgJF0yz8R/uw6zAc86xEZiGbU1fme+xsUlVW/IK5/ucDVwRSMTsgPLeuCIE7jgpK8HLjMZDGTyzOOE1rZQzzGFq5arECla8Utyg+sn3pkFDpqVzKiDOCmDkeID4dEN7uI9QgU1uBDYqahmQXKDj9cLeiq/w3fBviNgpSckchPRG7TYfjEVpV/9Jb7Hi+4DL5yJK/1ddkmsuNqZXnvnHNrRhV0siuvTNhEzcRDWDKMkHzx693O6zoUT9PQWuG3NrtnoTMpCxsX/DWDU5Nz5WrhM/VBe6FtOpBcZTgWhw9yTlsILiE++w5LSNcXuWkg0mASlsk8T7aTHot/j/M4hlpYJUE8Dwph4LmyUw0Eri2FTVUGcZXDWUmn9jya20EjCM6zwuMDD9gKhlcojgDbZa/Nhp9lQSR0j/of+Z3i4ATxEqhKFCAjLbMwpTr43Nb7KnDwYmk6Bzq21vgbYojRJCy54CGmK3m6viFyUTTKUJkKRmKbcPjMBQkAaM3CaGYc+CDkvPcZqr0L+mWWohDwkAkksgZQf1tYCM8yNntG5bV4Heo2FIDjkJJtkNsL9764rNH/4uaYXw85PZMr69mQbpQbbfUx7
 DLhnM04P
 bEs3X7eX5r1TnPSxe3iWupHDuJns239K8ZJWMZaqr1zUUmdsta84QkPtGA97e2B8m7wIXrGt7/8Py15EwzGxQeTvLJtkI6jR0RkTZQmc60sUu/fFjHn/CZwxR1ovR4z7IuliOTBQ3AYQPSxqp28WkyOdIuz0qwdxbPZkAjVi+W91onKS7M8vKZnzTyMAhQD2XjcuJUzEpctfkQVQFeLnY+Ul9ht8qphV6HLA6Zc6JgYJi9TTeJb/SZJNX5/lDgPuC+I2zf12o0s/duidDT2KIGmI7wXbW6hrZedD8yPNaMl4+izQ/vT1uTuPOBbAFrvcxPKZd4/PsVqVK4XgeHWJLFXXK+77uAsrpSm6QCbAd/+aa+VPGMQ+zrRtwW7S/LwAnbiD2D+dA4NmFYsFr6dpQcGbuT0odjJtnKc0YBpUnGYd+as542TXtAkV+qW57Jval6xTqvC8eALjlqZiikG6bFI2ZxLMeaXhbI9O6xkROejIIP2DaDWvHRIb7QZyulcgCZdVkqnyw92ri9SLlLbfVKRl7Esp2JmAY15nUWEnj/vjahjm2h6+jBGKIrU6VSZLqAPfeLpGM24b5wBV4P8aBNsGIH2btW4erRqQPoQ3QzGh6U1nLZpeJF1rH9gd9ZHFm087A8y101MSECZwI64I0TLQuTqLHOy9sSdMqrX+3IgMA4egskR/MC/KvJ2f81rGUz/y75xXoX48bOZdeW4cwV/LyKhP9NdjBWWR9zFOxufKFqVYYXmTlJ/YmtGwPL74DkYSibJGTjHjXT8qdG2cPWMkYYu7jw49DS8lT8j9ZEeHPnurFzlnTJxzm07EYVXJY2GbiHibEJIeM7MFnoHAh1UGAdVABRcZcuJ3/ODceye5+hjwfQ5c79+S54tst8cpLuXvEhx4z3sqoKceNMhEmmB7PLmqdqBWMiofHnIebgEARA+ZJmL9xJjQQ9Fe9jPNm+CZP+l2iPKzaQNV/o1abwhDYpTvx
 YW1YBJBZ
 9bkvc2tFlKfKrMb0WcCoOhtW4Je2EIwE0wzdeXWWHbAbGKXMsPKBNDtWpbYS+IHQwmkmXJQ5NJOvH/ZazDXqOPrVDf032IfEqX4THW3zSRHkOmYLogeVAbY/f6O3D//oGDkm5R/H2uaB7+2k5YYxGR0+8UTe+dpOc9g8/hz2WgdI+sHfdt4nqMCvSFEESgs/akTXio0l7JrEYZBRHVbn/i8hlcm8BQoN1rbYqFcemwvvzLVS50+rZ/iT7DMQSFGmecFC6Qt/r/cPT3uh+mI9AFJzBvunaZGBv8Npkr/tSZ6PRhcE7WGe6DKRv8pMtg1IiiSyLL5kYdolVebfqT6C1sEOBijpLvX34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 11:19:32PM +0200, David Hildenbrand (Arm) wrote:

> > So indeed, vs. user-owned.
>
> Right, I read "contents of the VMA are owned by the kernel rather than the core
> mm?" and that confused me, because the opposite of the kernel is to me not core-mm.
>
> Maybe it would be clearer to focus on the opposite direction, then we wouldn't
> have to find a word to describe "not core-mm".

Yeah, it is hard to know how to express that.

> > I think the issue here is you're confusing this with other things like the
> > rmap and refcounting, etc.
>
> I think it all weirdly interacts.
>
> In !vma_is_kernel_owned(), would we only expect ordinary folios
> (anon/pagecache/hugetlb/dax, maybe shared zero folio)?
>
> That's my best guess looking at
>
> 	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
> 				  VMA_IO_BIT);
>
> So one option would be to focus instead on that aspect (folios that are managed
> by core-mm vs. random other stuff not managed by core-mm). But thinking about
> it, I'd prefer if we can leave the "folio" bits out, because COW mappings also
> map (some) folios. See below.

Mostly it does indeed come down to 'can I rely on core mm to do the refcounting,
mapcounting, rmap, etc.'

But folios are not quite there yet until the memdesc stuff is done as you say,
so best to leave that out of any description.

> > VDSO/VVAR, perf ring buffers, shmem mapped via PFN map, uprobes, etc. are
> > all in this category and I doubt people would consider those driver-owned.
>
> Agreed. They are all special things and won't be folios in the future. (shmem
> mapped through PFN tells us to ignore its folio background and treat it just as
> some PFN range).

Yep the shmem mapped via pfnmap is a special case of the 'hands off the folios'
variety.

> > The distinction is - who put them there and who's allowed to change them
> > and who owns the lifecycle.
>
> Lol, I asked AI for better names and it told me "vma_is_special_mapping()".
> Thanks, I guess.

Yeah you see my point? :)

That's why I want to steer away from ordinary vs. 'not ordinary' (otherwise
known as special).

The semantics have to be meaningful more than that.

>
> I assume for the reverse, we really just want to say "just an ordinary core-mm
> vma that you would get from a simple mmap() as long as no weird non-mm drivers
> or subsystems are involved. Core MM fully manages this thing.".
>
> * vma_is_mm_managed()
> * vma_is_mm_controlled()

OK, great, that works!

I think vma_is_mm_managed() works best out of those two.

I'll update v4 to reflect that, I plan to send the respin out today before
LPC :)

> >>> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >>> index 2a92193ac6a5..cab29d6e15c1 100644
> >>> --- a/include/linux/mm.h
> >>> +++ b/include/linux/mm.h

> >>> +static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
> >>> +{
> >>> +	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
> >>> +				  VMA_IO_BIT);
> >>
> >> I thought we have cases where we drivers insert pages and neither set
> >> VMA_PFNMAP_BIT nor VMA_MIXEDMAP_BIT.
> >
> > There were 4 - defio, cmt_speech, uprobes and the bpf arena, and I fixed
> > all of them :)
>
> Great, that helps to identify these things. I didn't look at all patches yet,
> but we should definitely document that.

You mean the fact that this is required? It's documented certainly insofar that
this series makes it a literal WARN_ON() error to do that ;)

I'm not sure exactly where you'd document it in the kernel documentation though.

But having this enforced now as a strict requirement is very powerful, because
it means core mm can assume things that before it couldn't due to drivers doing
'weird stuff'.

Which I think has been a large part of the problem with the VMA flags - not
being certain that VM_xxx means y because hey I remember that driver z does
weird stuff with it suddenly means the flag doesn't have a clear meaning any
more.

So this I think is a very useful step to take.

>
> >
> > Other than the DAX-only case below of course.
>
> Right, as DAX uses real folios.

Yup. And FUSE DAX now too :) Another 'weird byproduct of this series' that :P

> > I could also add a patch to this series to do that too if you wanted?
>
> We can do a follow up. Not giving others the chance to abuse these interfaces
> would be great.

OK cool, will add to todo!

--
Cheers, Lorenzo

