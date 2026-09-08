Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62B53C79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595336B00A7; Tue,  8 Sep 2026 16:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547646B00A9; Tue,  8 Sep 2026 16:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D736B00AA; Tue,  8 Sep 2026 16:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 147786B00A7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:07:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71CD714057C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:07:44 +0000 (UTC)
X-FDA: 85191680448.19.55FFB15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id BB5ED140006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:07:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=All57E8n;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898062;
	b=MaBote0HvzNPdCpI6WSW5TTQkkMyEdnPT9gTsbsnAeinENx5nkV20G7yLKLljBQTHqiKNc
	sYDLtyYeYmW9hWW9RQuPIxkDr5vrwKYHEaro1ct3WeMLQ/wCuaf29pXA9/SgHoXj54q7ad
	3l2Qe5U2eG4uSQZFM67FX2GbEgSp2mY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=All57E8n;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6JliJR7ViTH3j1425BmQhOALwn5mdQwAHUwDAt0ssqU=;
	b=PjYvLefET5vC4d2SyV+OA7/PpJoHk6ACATHhwLh5UpmfGbild1IDsT8FdQXoiQrYpFeBDU
	cn9oSVet75UH1AhSSiUCRytFpHIAE5/5BOqOSNXAQZ8uYrIMo2MWrcZov8QEPly6VaJMAG
	iBHzDT+X/HyU42vfBfMUEBwPhLDwz6Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 56991601FA;
	Tue,  8 Sep 2026 20:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135221F00A3A;
	Tue,  8 Sep 2026 20:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898062;
	bh=6JliJR7ViTH3j1425BmQhOALwn5mdQwAHUwDAt0ssqU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=All57E8nd5Y9Mo+79iAtvvfb8qkTfEj+MhzFWEBCznwtGvejbzyaSMhbmzJdtyuUK
	 J77pQ38Ku1+bCoJ5haSRvDIVgEr09l30s6GBvJq9UswAGqkMKUJKmX8PbQ1AGQARUj
	 mGkVvcnE5kORERMaWPHgbHXdFXZ33l0j0T5KnuIDhLAWDslw191IuUuHEkBHEDe1oV
	 yWJW6bYfBbFQtHm28CAr32dY/a526ClALGAjnGZFu3XbFkpKvmDUXP/B8yPLjrsyIf
	 Uyzbvw4Iw4mJDDuVHBPKBulueRNwjrT4szleUp408I6e7vPwp7IKoKNzzssIXupjXD
	 Nc9OO8klUcsgg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:15 +0100
Subject: [PATCH 11/39] selinux: reject writable opens of policy file, drop
 mmap shared/write check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
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
 Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1777; i=ljs@kernel.org;
 h=from:subject:message-id; bh=63Oi680Y2BJYA+pUWl4SWOqti/LTNaoinrX/vyjyoN4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG4KdJyrs+RI1FSmzKCCPUaTjctO/5kafujTg9pFq
 dqL813Od5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiPL8Z/qdEuR/9Z7g7w5Ej
 VXz+1n/rlWMfzPket07SbmLuwb5EPwmGvyLMTgE/tzp6zj6p6r50I3+b1KI3/jdEop65To0Lt/E
 9ywwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB5ED140006
X-Rspam-User: 
X-Stat-Signature: rxc6tzjszsshef6y64ceutk6z7ajew7u
X-HE-Tag: 1788898062-5462
X-HE-Meta: U2FsdGVkX194UcN9wSSEBHGXpVCPgxpDppT1DyJG41eZwHzHIcBJGXf6nFIPZYvA+Hh09IqpUT3NQfY+VVWZwl0X6w9lvRLtEJqY7xzSo9z0LSRziBz/8ao/U6ixAbBd/sd9sOkBdF27rdQvK3IqUtuBDhe6JHBVOT/OIO1djzqiWiAY3zQnJ9nkCjAogmjppDWhHackpBx5qUauZSdeflitO8eMVtyafnB//lX7paI3X3N2gm8UJexXoPz5iRcrCqpp1iUzhSIBxqkjvSXwf267f+F6d7el4mtUBrgGf2VFnhb/uYYnQUAMbCYfTygGeOb36hraWN4vA5iaxd7X0mH69aXuUeMSN9sHZy+NCtxD13GUbDM+EWGa93o/F7h5/E/C6i7V7TPqf2CaBvecZEF+L9MpXKpkhjbF8aSKOZQZmFF1mxddEy5MCv/iQu52Y6CCAFNP5lGYxOgAPVmMqWaAYZjaLliUxHe9w7LVXr1mtJqHaBCrNCBYGzmt/+Z8gGkTwlIOApmXVREHwDakBAC46p7O6/Q/T7xTqXBeemmLGneDRU80/LsLns1CYKoboawsmYCWxxUK3WHTr9wlCQtD92mdnhGJPEbwQV5phNbU3dA70AWJ0wNGVWiqhEfNw5Q6H90I7R8ooBxNM3Q6JdxDTldXWB3cLHpSL7Cn47CHt26CtdDS8Cc9ANOYVXuvzDNnqzq57XDoj0TSQVVGqPZuDbnsAI+UHEd1fL7lhFtLJmauzOdE0e5CJ00vbPUyHdiSRWIpXOmQcFkVSZVSsBVoQA9x7w4K429kx1II1CCRES1+oth82CYeG5VZbUAT/LL5KIJj9pBLF1a45cd1KOxsYOvqA4fGUyPUHdQavUAM2zHGFJYX55JYerWPRW2Vz8e7Bd0RRuEoJk1z5KOR413TOrBd2Mkvdwo1sOYsnN9b+GLkJo/NDIrHh8dVPGxM+yXY+5eh7S0T4eZvB93
 emtoE2f8
 IuncgwfOrDPb4FBNXQRiHjuuFnn2TnS4GPJNDOtq3i/SDrTjQvQhmnW0kb9kbr4ewHXsE3+pjOCP/l/5G4TrJMHiLlBNqNjPNcOuvoNkVv7i25P8e0EuFyo+ElVPXVd3kiAyOGu5sOMzZlXcQoG3nWKAhoTACS4F2kIQKvqxxQmoFNyJEe/NEK0qffVbUEszTRg/wbzv2FjNCKvpfpqxYoG036U/SYRmHPsDIx8v397JeW45nwcEE8QCgCIHIje5T2EXCMgX6VUILuML9EUmUfIqPZGMdTRzGe+pq/PGQLDDNa84ZcpZOjEFINXLIDFl61GrSbGNiN50ft8/mAoprUaSOE4Ce/vsdONWFwl1borOWk1cfJ8ySMJel6KazFtahqFhV45Y3mzjdndSnzodBf0JiLLOZePvjIaFYDT01dwRIrM+l5rYaMDC+dX/S8DU5Hdq1BCcDSzkOBvHF9CAlsDlme+tAGCqMpBqnMpw7QKC6ndIoUSdqRrEzWUaISk4r1B5YAr3E62vP9/HVS5EE2J2KGSUFSsi/R2pfvY0MXyDQNnEhiR2ntl00QkH5oCywDqiulCytzFMtNdNOcpzlbcKRc0tBekw5yzczDt6NRBkUjuEg+l4f0yDBym3zO4vkqjoBIIbDoxvBqkvH+kSHFTOvZBkCOnot89ldYiH2p4Pw/abQueIwQfw4QXXN+BC/4WOpxZ9I+NiTGTbbOfrIo6yRSupTvcfHu7+HV4XO8Oew5o2qhH9+QWPNftW7M5pAJnLMxmNHDEM1XrvoHEf3iOL19x74yno4xvTMGrjgmPR4YyyOmrzSHUWZCA3p6n1sivZki8fqf9ssjFFAcgNMY6YMTcVB2cge9ESj2nESUB5VqzPOIGZmblhi+PNjlL9T8tNDg2qDgtdwp7vp0cdOf2X6QCA4IVjRF6qTrh+EXi/MXMG3T+1rlRcF5iyV+5Mb1COpWQHeTC+zpsfWjbpqSyCNR9Zv
 paDnGUkK
 cEyt4WqCsFIkTYQn1t7jo7FcI3QsvQN51gvp2Aw9IHld4xtp69KeJOOpVnQnVRxPyjKUeUayFvrYIXM3OqcG8at1waWuT0IrAZXXwckurpIHcxSDoNu2BUtpfBdyIQeQrwEJ+LrjoY3w79rn7GcgGpdShippgyQv7jKKciPu3WQR5BRoE9U3DJSbbxTnUDA8lh1djwq1xVoc6BX9mfGLFylbMcJQ6ujZM7J35Al5XZScgmjusIf/rAG0NXWc+Yu1bmHn4p1yBOePtA2Mil7FFY2b21LoHVGt7RGxEKZj7/M9TEDwth67RUHEsR1H9+m+4vQZXXzycBFstsfeJH3NfG4fYVN2Bukys2PbYF/XTGqsvgyWJOvBBAQFojvDEkeswuuJXnuzm7KQtMNPY1f6ACtatj5T8kJX/P3Ajpecg9wA7sXccoGdx5UvlhgwV7glXHSKOMTzpmC3D8FNmsesZ/soqakTAv6dOIGTVAhOP3oxTckgWn5Wg73rwgPCL5q5brf9whiZCYTrytJ/S1DeaQmHBqdjygmpRWh9g0nBgTHu6LuZVo/MAq7gAcSMgKdBA1h9VzOqHVb2k8gxDdf1Wx/iRnPdFvGNt/2eRW14J+mj9syRotVv6i4iGsloqub9PWOy5zrwopJ8jIjlmGl00G9rzDlE4Aa/EdHFydSZuIrtcvDFwljhk3lEJIpOb3AqYXjUPsj8795siS/jkh/hWsYXZo5Mpm6TvejakDa2GZeeRrpizsVVF6mAWLTq7ewsc6VIduQMS116DaZrOxYazmcmK0l2PztQ7udNUSG2aaVpb1co+6XIkz6GbAQSO35yKcOk0Tyv8t0g1/S5cU8BGVVbA+fHwnPOHSZd59pCwVK3CxCloTuWhee6l/K1mzfbbPfrkitS0zd7EVQwyOLXuu2bV4FV51tmIv0jHQjhde6Az+FOstX9Uw2G+vPt00hBDrIinVSiP/zvn/acB5LILJfBDtahg
 18aFm2W2
 Th/ZFMIicsy9Ieo3w/xam2Gh2l5i4AaaahFXb4p0kYATIF++u/3v1Vegm5eCJ7B7dYIZ6P0QU+sjitwpnDu7BTGHi4TaL29mdE7BGiDtJ/H8bTQjnbnT5A40UPJaNqIybbhaPvZgYhVt2skanr4hC2po6RI2sfUYhoaBvaVNIeXJp08EEbu3rfR94QvQRyCsVW/IFywWqMfRO4GvEIbaItwQRAqXvBxSCftISQ5yqL0QIK0tux2JntKSSzdRU5X6xvxB5tDkLlLeNCTpwsPJNr5otiEqYkEYeCvnhovPu3QbqCm+MLTLOjLRzj5kpwP7XqLfbNg+D3mCn066hl4cHEwTsewGQMYLJMuGqvrY+sbv2/gxu8tCCoK6i7kU1MY97DVWoaAgCzRl7pCYlYWHPzvnWO5x8BqnjoqhKo0dOob0f0e5CrVbgFNEykLj31Q/C2mocHK6SE3bsJgsvmcY4a2wgP52Dk7D0VfP5bmNbq3sBLnk4O6aq3sovVI0FrIui42fHZ3Gq73aAhBmkIol2+d/2IyC2PfVFomjoH7uBDGJ5VYxNhbY9lVY4ccbxP1s6jSsRMQqswV4/0QYVnB7wYGr0wd7/oc1JCKtilz3ixwCc5KB6Bzc2dlfFlEf7CLMYr85pFhSP6W4GBoMgaElwUAODGF9eqVaG3gqwOGCbUMAydTwyfKJxgLONtHbgWeTwwNCRrByKqw4LPpAphtD1hES/v/Fd0dNdE95Se/vWp0ctxuaMCMxAxQlqenauICHW1TLDWXLy9UkloO6waRT029VPsIhCT4v8T5UFF73s2UNZ4D/KS5zggDCXkYXdqglcH5Scn6Y98UttZyXzWPsq61GnEPoH+JsE5fPTKnHGcHu3WQ1xk5UD+wmasI6dPeToW5hD2Nc2cFK/c+7RwI2YCai044fmrzxLmv0zKU7BKwWHc6mI5OEfA1Wag0etMoxHVpkBnwiXLV2IVA8jxo9N04CsdqZR
 V1MasrMY
 R41ZKPSogC1ptAnNnyVGcoekUSNAteBZdoI0hvwOvyhLuoqR9RWxM70JEGDmAk5F0O45PDDTNClVOl6MQok+b6tUVxWCdc/a84nmK9IyeIEc+9qrdZ8/I310NytgaxuQWAB0ukUeo6251qsmrws1L+rDtFFoz3uMeX1PozaiyNhUf4b5U/rgaTE2s3KLLAPNAqRE6HPaXLge9QhV5lAvJLOQ64wzWSu+A+EEZR2ndySNoocr7WUqMiwBx30h4ilY9TtFvKk8MErGteu96XV7GTFius8XZma2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The policy file has no write method and is exposed read-only (S_IRUGO in
selinux_files[]), yet sel_open_policy() performs no open mode check, so a
CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
kernfs does.

The file can then never be mapped with FMODE_WRITE, so do_mmap() always
clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
check in sel_mmap_policy() cannot be reached. Remove it.

This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that is
neither a PFN map nor a mixed map, ahead of the core enforcing that only
such mappings may do so.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 security/selinux/selinuxfs.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index c7d91476971c..545a6f89f9e7 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -340,6 +340,9 @@ static int sel_open_policy(struct inode *inode, struct file *filp)
 	struct policy_load_memory *plm = NULL;
 	int rc;
 
+	if (filp->f_mode & FMODE_WRITE)
+		return -EACCES;
+
 	rc = avc_has_perm(current_sid(), SECINITSID_SECURITY,
 			  SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL);
 	if (rc)
@@ -424,14 +427,6 @@ static const struct vm_operations_struct sel_mmap_policy_ops = {
 
 static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_SHARED) {
-		/* do not allow mprotect to make mapping writable */
-		vm_flags_clear(vma, VM_MAYWRITE);
-
-		if (vma->vm_flags & VM_WRITE)
-			return -EACCES;
-	}
-
 	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &sel_mmap_policy_ops;
 

-- 
2.55.0


