Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B22FDCA5FEF
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACB026B00C1; Sat,  3 Oct 2026 12:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4336B00C2; Sat,  3 Oct 2026 12:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9923E6B00C3; Sat,  3 Oct 2026 12:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74DDA6B00C1
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:42:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03A42140848
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:42:21 +0000 (UTC)
X-FDA: 85281882924.24.0D04CE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 451421A0002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:42:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hou7rug+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045740;
	b=WK74RzCnb9CNHnIN9qO3n+zj2SruQ3vl4AVbyJ8d07IHCsXPb5/vYZv+bZfKzyHe0XhkZ6
	Q3zhyG1DtZgkNQNpwPfI1F8OR+R4nvqxY8e10s7wR/WfADnu3HUc010brbTQDWSIyRj4Ey
	rQoR/+UTwF5cLqkVedfmTGoVSeaQF74=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hou7rug+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RI4WX0O22KjPeI16PdUA8FkhrmSCrPwITssscZUOsxA=;
	b=Vu/vYA4UEsgvLlIXBg2KrLwSAFbpzPCQUdCp1E3aU9lxzwT6IdXDTmYwUF3H0jeU2uNKRn
	opavlYkiVjboFxg8/fWDACVWFr0xYq/on8rZMMoE2EV2RgUt6pO/uV+owwj3AdjXQHO3Ae
	D+pRTFaVCiZm72iLyjxq0HetvWm5Xu0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD64060D82;
	Sat,  3 Oct 2026 16:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1741F0089D;
	Sat,  3 Oct 2026 16:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045739;
	bh=RI4WX0O22KjPeI16PdUA8FkhrmSCrPwITssscZUOsxA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Hou7rug+QqUGNLNgAi6BnWY08jxPkEE4TkLZRXN7nagkR2TTVQ3/gAUahfuqyUaPw
	 AUcgBHtnai0IFU4OfyWJuw7jBCsO+Y2Is7fdUONN/rT5ZA33NA7FVKkerKsTZ482RI
	 LT7BDCrsV3cfESaRZf7x5iFejDNvHErFKkLh3E+k5Xgd/k/LE6QO6ts/NOlWiCBh3J
	 mrBm3ySbikVxQI0DPYoDO5zsQV5hYerS/sDlKFRueISq9gLgoU0uIU5m1coqoPGatQ
	 XqkZqL9zCOPRZLWkVOEOTnSZREyBBdgFc6nSoJ+ZcoY2PqGEoOotZ7ZKm/uIkn6rFM
	 P+cvhhY0XApkQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:57 +0100
Subject: [PATCH v4 26/38] mm: remove hugetlb_inline.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-26-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
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
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, 
 Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5629; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Lb6PN86E47rAtJp1lXXo9OY9NeHwxjKk0v89DhOzLiM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mmV8jx24jm7XDkqM3stf6fP+Ubp32vElOZWBb2XV
 UtMt77XUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIl8aWVk2Bf0L3fvzXPb1Jpe
 Cl18duPzwZze1545v+e9OdxxZ1fJ9nZGhg8zJ/mpa95Jdy8sTCur7RLUcSnrbLHrCZ1/rpzLVVe
 UDQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: efr86564g33x15jdquxjjqeye63tgn8c
X-Rspam-User: 
X-Rspamd-Queue-Id: 451421A0002
X-HE-Tag: 1791045740-792025
X-HE-Meta: U2FsdGVkX19IXf/A66rfWUMSig7CMJKhn3Lb/tbODMxecEXvGfEZJNmu2PGIbhg1mhPDodJXWC9y66neo78iK4m+V8NdQemKDZM4ksSeTgR/BdiVJLk/N7qOsWuRQgvXKf+3BMTFq4AWz9S0nx6sbGXNogajguoJNY44zRKTXoLkO97qwBvR1NpCfbiJi5sB7NXMtILgJikqcOd6o0QPqOtE0URk3Bq1uZHHPp6ORoc+meem9EtUUgrsW6Vf4EI4Spq4LheDexAxA7liH1FQ4zrYuRxgTgw1bwIP7zc9rfM5svoaft6LGSfuKgXymdmZCC2YTi90pAb6M8oWYf99yUCzGf0S9zCHQv+DEkENN6WLKHqtkJI7dRaFAG+Osf43z2YNzUHMwjlc3+ohuvVuWqIwlJRejkiwKYbWNrcua2a0515WLBcoH7Rn6UEKyHFbAeoVQ937UH3j2JTBegRPga5geP+kl3zwCW9PbDc8WpaBE4ZoE6HTMekzb8Tz+x8y2p4AKtflWkb/spev1+0kiPs6cAhWcO7DzQc6GptE1TFjZtMI6tuLnsXmAhuvMFUcFHmUcLKQJx1oHraBTFolTl7q5rhqGkPAJrV7lbh/f7WYpZ8POnFR3oPtnaFEEAt9sHT1XYtBBSVMbCbXv5WHi/LaQXFRcOEuy0CH0NvhEKrWBcV+l25d1AkrePLTUH1r1b5i7spYKhxvm7nCjsd9/IltILHvW0qpzmmW5UcxXSXOBdqO/Ek4NOT8qkC1jhxQwg4oaPoENtuibD5XZMciFgS3e4cewNcO5hhni12GMp+PP1RN6a46do5SemGf7jcj1hWM4l+lSg5vdAO/sA0gkwoZmyjSg0iFbXCaZRQGQeN2z1oIQlAPKOtajXx7h1OJrvUjBqZv8qIx8lS3b/6jgdJLnqmNfurADVSmcRKa9aQo0RnxAVfxDlYNdCIopVRYEOwsM3P08ltEhyd600X
 4GP0hvPd
 Scj5DNENIROw+exAgDYz8ZojJ5wzbtY4I6e8Lg5uq4l6e84MeJ7d0vN8lx388Q92nAHpLC2mlx3vdne+qqsCbDvulvZ4h4iD6r6sJcbuiymownzTc1KT0yZCz18vsSOE07cai6nf3u+/UrewF8Bf+sr/iCEfezYQprk3pLoti0sLUDTF9hWBP6kNMcCKsVTf53xEOg1UmH6UDum1qFTwtCPiX7g1PsbSXZ2zlo+wrrwFBhWhIp6eC2MX4KximEdgrfEfUFwA9N4kEEQGAzshU+/rzLI0vlMTtIp73BeM9GoWaBTGfwnrd3fCceDCQF3Abyc1+z3svdzpGK5qBpaJ1WkewsWuL3kGHjU2TVJO1agACd8qQEJB5ENHCk3a9xQnnBqs5I9RO/4XMeRSk+o0+i7kuU7NUCc7L8WqMME0/eCfRJz8YDXIW6Zp1HpJFt+Nhbsovjrc0xbUwRJKzZwbAaasZuXQq8tZc7Pmc4MXoBMQp8ZbYWuz5fs3oIiQvo6TPIWhd0b1xCuujC2diRNO5Tr7mPYaigPuAjfOpp0lGTJLOeLbxD+RH05L8VVoMKjIDKaf0jfqUYRnd/tqI27/AdBZKDzNI16JLKrEdx6LEx8wah28hs1shGjFEy9o9R/aXSfsvjjvRVuujzFWznEuTv/fNnPW/79+JN0MNDmaqamV16aP545K77TmfMJwZMxR3Kmd7GhcfUbI2gx9HIJB1XcsRFFvJNDqIRWDREQo8FyXP1EUCEKW8eRy4L0k4vjI5ku+12uoLKzli9/U6nJhvswNCCPkJgn1qBW8eYVN2VCQ5o4pA167YE415h9JdAsnE56A27lrXMkAtzNwX90vVgfg0+bBJBAI+ZOXzaOH5y9x59sPTX5PxfGAT9+/Nc9DdG2d83w7AVW9GwFX8GIuZoSjlc1bTQy6DwmMb/FgD2ZrrnCbm9lv0wS9Lv3ddV7uQFAJn/1rqiQ/omS2KbHLBfwaqajai
 yfkkymZd
 iXYjjgF6CjetE1fL+4hvotRyt6XkS1Z/oI/3kuOmcq37V3S7sHskqAYqV2gt0tOM0DiaMtCVf+mol/5pLVwWklt1HUWblwBZM1ru44x9zN/JK69EnGxqCn85bWdl+bmiRDSgLG+fyT65EnVDAbOMREtkqhSvTPy5KKO/gw5VvOZ8PtGxTaB9FfOBgYngWAhVdUDC9r04YxGoKEyMKziBThAbLwXfrLJxhWYw3yZaQsl7zRiJ+z7183XwVAQvaCPu7VMw+G4Z7n7HKL4wSAoSOQo1oj9+BiyeJZxcQXkY4U/GvfWjNa16d6p33VUjsI9ookYiYDs46JLZdpeHU63Rjg3Sk/R8Czpksrw8Xp6nEfiVQabYFlwDr22znaEDTfLqdyK0TC1SeaDZZeFUzLe+RId1YhA4pZ+t9svFXmDEY/w4WFM5j0YnsdDcMnTE3XV5ztN5uiwGj4lOKrmilUzU3aVFw3qREG6kkMbwsKybflsJi7Ov1YKl5nienHj/6TFvaeKrpr2f8kJSLnAdqfvwPEk9J53PoSw6huBxR/WiUCH5crbRLBn8tQ3d5ENb7AKkfLXHL2KKhSF4YBhmloGM4Aodl6PCss3orH3Ii93Rz6xWd1edsZ4hFdolkliW1r52tCR6fyuuyAkxaaFAPwOiAaAvJgqPS1D05+M3Y1TE1rpUiSNVCCAzY8CDxEPrWoiFyivMU5VFi4KUXmLyB56lDXbB6uA2aihPK+12iHBhv0nyKdJnKX+V8QhXqyVSRtVI7BguvQL2s5/4GpL4BL5erthpmrSCt64FvwOu4j60J3J5CzB2QAHIPAxG4jLf+5SGPhga3eAzwHTCY9dv4ldmMrTifbLvmXBggIXxFzAVRBhLhww0a1RQYClydLOpKKcLfiZ4/Zh+yN4oTv8Eaj5yKqgiYP62KFq9cUwPoBeo7tQeQbsgGUor2M0zQOoK4TS4IPF+Qc4vpuQ07uru8CCbPZEpxqXUM
 iu66aL6U
 0GPMnd0yIA+OW55qL4u9lwLpbR7YKiM0auIVPnZ2lFUOUoNn0TaNglFirwiTFL6zh7uslEXcVG+UUTBhZ5gjl+7nfi6CQdKs9goqXmZf/PwAFRW7JYP4OVcO7so/Kzrn5LdS0jr06LYWR15RHb/O0h6G+1Ifswy2yMid3YGMROJ8azYDJNnY8xb/y31/lNRHoaE80z72BG0RYfAycet+AVQiXBSZ2XCBZtCi2q6JcGTLipkpKYHTumIH8i6zFL/Vzt1Ot7R2c5uK450iD7nr63BbkE5k6M4duDKdvc4RqXoNRgfjJRJarUUucycz6DDw+IJzJjA64CsdrdiWRoQTzTpd5NQjaEShshz4kgkMCFszuDRGR4dxb7QiGNKYQ+p3eooe1rZl7XZmIoE/M31kcfoHEY1GvVrOmUp3Pki+76TmBAg4fya4VOpYXxU/8RU8hay/DrOEToGxgYX04ExXVPFvgBbcQf9HGQX+6DXjVe0XvcwI1c9wv5TgEZdJVZtAV4VeYjf27U08UnwoN9WKGNv+n45T/KTsmF/mt0Pb+laar5UJCRpm3lBIxNB0OO0BGLkB9fBY8F+mhfuxWDSaMfVeSzC6gVgo/yBxYZwT/H0fhw3l5yZIjh0T31uxYMYHLh5ZMH9kBTcakCMW0+YBmwMl5fOtpQY+3Mj9CbkYqNpg9NKOeDfD6ciXiXm8gINel2Mp+OPWpR8/TTA49NEJF5ewdJgmky2dZa2AEYfMpvOGKOkOacTJQ0J2EcpUUYk6luX4qRRoT9wUpEbJtW5shO8u2r4cdYZS25tMRYqzD3y2Dv9NLiiZ/iNouL2t7YItMPAbl2QhT5gwBt6XSNu15K7GQ5TRbwIwc4+K7jbBNSPWAI5CfALkD5CtrvFHElFLhXrR1CyvWf5lMwbi5jSYYFTcGiv9Ot7pX5lUJUUOdkW6OXpYWPtagutTtVdhgt6oh/2XzXdz6varW0aceIy0YIq/+6TcJ
 oBQvWOuu
 JSyFqL22sFO05x6ELXS8bQtg2NozxTEfvK9Mwb/Ttca/qyopVPYGJs7WJEs0KkQkNJFB9dcUBYUJF8tEg04KokA64FZ15nhHEpJH2b6jrtsmmusLqW3ZaP/qOa9DEZjdaV4VKrqRKX3f69mxdsPsxMMho06JUPk7y2DWim3WNiJKZEspjUxRTw36Z/+9l6CNjVnl0rqTCsYkeJtISlM85HllTIlpZjYbizjuSHppV9ePKbPEDAc2MjVouqLaWbR3mXwKDPExEvVuDy2S3G3f0iwuBOz/RHrSI+gIn7vEaZyxlCWyNaQc37UEJGx/+VbHC6JVSeDNSAJ9ADwlfSk+kkPIdCLAKH7QL/Bg/y4QGXaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This header really makes little sense - every place it is included mm.h is
also included, and the header itself includes mm.h, so it does nothing to
reduce header size.

It also oddly does an #ifdef around checking VMA_HUGETLB_BIT, however
VMA_HUGETLB_BIT is unconditionally available, and will never be set if
hugetlb is not enabled.

Simply remove the header, eliminate the odd ifdeffery and place the
predicates in mm.h.

The naming of these predicates is odd, but to keep changes separate, we
will address this in a separate patch.

The file was never put into MAINTAINERS so there's no change required
there.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/gpu/drm/drm_gpusvm.c   |  2 +-
 include/asm-generic/tlb.h      |  2 +-
 include/linux/hugetlb.h        |  1 -
 include/linux/hugetlb_inline.h | 28 ----------------------------
 include/linux/mm.h             | 11 +++++++++++
 include/linux/pagemap.h        |  1 -
 include/linux/userfaultfd_k.h  |  1 -
 kernel/sched/fair.c            |  1 -
 mm/vma_internal.h              |  1 -
 9 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index a93eee7ddb9e..793dacec2100 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -9,9 +9,9 @@
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
 #include <linux/hmm.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/memremap.h>
 #include <linux/mm_types.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 
 #include <drm/drm_device.h>
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 044dabc1fe9c..8b8123e5b7d7 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -11,9 +11,9 @@
 #ifndef _ASM_GENERIC__TLB_H
 #define _ASM_GENERIC__TLB_H
 
+#include <linux/mm.h>
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
-#include <linux/hugetlb_inline.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 80a5a03e9cee..d7e6563cef75 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -7,7 +7,6 @@
 #include <linux/mm_types.h>
 #include <linux/mmdebug.h>
 #include <linux/fs.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
 #include <linux/page_ref.h>
 #include <linux/list.h>
diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
deleted file mode 100644
index 5c29cd3223a1..000000000000
--- a/include/linux/hugetlb_inline.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_HUGETLB_INLINE_H
-#define _LINUX_HUGETLB_INLINE_H
-
-#include <linux/mm.h>
-
-#ifdef CONFIG_HUGETLB_PAGE
-
-static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
-{
-	return vma_flags_test(flags, VMA_HUGETLB_BIT);
-}
-
-#else
-
-static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
-{
-	return false;
-}
-
-#endif
-
-static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
-{
-	return is_vma_hugetlb_flags(&vma->flags);
-}
-
-#endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3ddb463db895..6c470da29a64 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1609,6 +1609,17 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
+{
+	return IS_ENABLED(CONFIG_HUGETLB_PAGE) &&
+	       vma_flags_test(flags, VMA_HUGETLB_BIT);
+}
+
+static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
+{
+	return is_vma_hugetlb_flags(&vma->flags);
+}
+
 /**
  * vma_flags_is_mm_managed() - Do the specified VMA flags indicate that the
  * contents of the VMA are managed by core mm?
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 939f3a5e973f..d7d8b312466c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -14,7 +14,6 @@
 #include <linux/gfp.h>
 #include <linux/bitops.h>
 #include <linux/hardirq.h> /* for in_interrupt() */
-#include <linux/hugetlb_inline.h>
 
 struct folio_batch;
 
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index a4351cffc60c..a14b8a9ffb7b 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -18,7 +18,6 @@
 #include <linux/swap.h>
 #include <linux/leafops.h>
 #include <asm-generic/pgtable_uffd.h>
-#include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
 #define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a07a658cd99f..9eb12d0b6f1b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -22,7 +22,6 @@
  */
 #include <linux/energy_model.h>
 #include <linux/mmap_lock.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/jiffies.h>
 #include <linux/mm_api.h>
 #include <linux/highmem.h>
diff --git a/mm/vma_internal.h b/mm/vma_internal.h
index 4d300e7bbaf4..4f73f0a4db79 100644
--- a/mm/vma_internal.h
+++ b/mm/vma_internal.h
@@ -18,7 +18,6 @@
 #include <linux/fs.h>
 #include <linux/huge_mm.h>
 #include <linux/hugetlb.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/kernel.h>
 #include <linux/ksm.h>
 #include <linux/khugepaged.h>

-- 
2.55.0


