Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 361C5CC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47CC96B00BC; Tue, 13 Oct 2026 11:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42CEC6B00BD; Tue, 13 Oct 2026 11:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5B16B00BE; Tue, 13 Oct 2026 11:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02A6C6B00BC
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:14:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FB4480C8F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:14:04 +0000 (UTC)
X-FDA: 85317948408.10.600643A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B59631A0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:14:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EStLdfZ4;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWi4IxfnQiutVrp4mRJQjtOZDBSjGIMVxxtGuyoDWoA=;
	b=5WMnWfoQi/ooa+XwdJ3Rwz/fDX6vIewaMHv6adQSc+nu/Y7UP2vAxalfS9ywutO4yUqN+9
	U64+T3EBbPC3MPg2GXHM6eWdlxO6pCZjczIocSgVDl2GqcAlJzKv0jd5kUkSuAeAlnL+lT
	MHXEtoROry5TGsdunbj/LqYR6qwfYVs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904442;
	b=8kmFDrTSdfuBQJ0dOeNL01Mx3JVsfnm6yi4Sx5UApi2HrZdC8zDBvxO3Vq/4zArMw1fR/9
	2GRtPWslKdyvZ1ZSADPOkIFOpYr0QxUDVtSEFIlTFwpmT5raWEukjOXOLf0D/pByabAzPa
	QsP6YZH5EdSjvUk0JAqLKUllALmgvMM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EStLdfZ4;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30A6E60A59;
	Tue, 13 Oct 2026 15:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139041F00893;
	Tue, 13 Oct 2026 15:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904441;
	bh=iWi4IxfnQiutVrp4mRJQjtOZDBSjGIMVxxtGuyoDWoA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EStLdfZ4K5E6tJVGJyXckKVNKvAC9pImHOjucLTUEe4cD2QIAMiyAP3JqubWVnqOz
	 tn5EHx04+E+T1MV2gnalX9qItGYzrsCUMEq9wnfjprZc2qwgM2FrMss3ugjuJIvr7H
	 M9XD3Kq6cBSEms0yMaPeMdl/3AX5Yv2onNx66d6bzLmdYkVM0/dy2cH2MJfBhOw5zE
	 YhqRVMV016fA68fhVoKPkeJQHbGVcUzxRjNt10VJJLWdmHBU4jEwEhMs97pKgpVNk1
	 gSXpxkeRLYDm99LW4xE386wi+j/RlKV1vamMWpsRMvMt1wAfAYvyKn5YTpXqkjHehe
	 H9HHqBtgISIbA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:55 +0100
Subject: [PATCH v6 15/39] mm/vma: add vma[_flags]_is_mm_managed()
 predicates
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-15-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5470; i=ljs@kernel.org;
 h=from:subject:message-id; bh=2k7CL5BDCTQMRGPrACd5d5hU5TGkD0PVJs0dITN+1Po=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZwMZ1B8nauuatK06r3l9AMnFyoWmPkx7lpRv1/wa
 szm4wWaHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZgI8zFGhmMzare9X/NjW+2j
 t/wewjy2znuvbt64bOv3Mg+T2VN6LPUY/pmt9Qn/tOlwaNWK6Es/uu1+TeTnVM+MF/Z993Khwbk
 2Rg4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B59631A0004
X-Stat-Signature: 3z8t34zm6s5ywwxuqwugycrjxto4msoq
X-HE-Tag: 1791904442-704164
X-HE-Meta: U2FsdGVkX18Y0/mg+0IASVAy+YvG1pA0fYHEZEGJ6q0Ps/5+aSrA265JoKW/p1kLxhaT/kZdybEh5oQ/4Lr5OHpuH6x9x+e4WU6nH90dI3Dd7exU/fvf8x1NuSDuzUzRpGfFkw/3jzaICr+ya3HSmJvW0l+qxPfvo146vsCV9dVMQa9uem3lPe6HR7wOoeylVuGyoK+mPBPBFJDxB7nHfOfZ0Mc2rx2Mea4ctjnOXud21Dx84llLCEo4B1ufxRCdT80jeBudcFndi6aXtMWIBJDp3Re0+DVRKAPFqlp9VJjC3RTGDX7mcgL/a8awnBG6K/75ob54/vCB1H7LBqI3mQtJeOkVruHzF51ShM7GCl/d8ThSPmcoaFqjLizWgdLC70J3mALFm8eqoZPnZJ3wt4NYMRG8qxqCI1mvzxx3T4u6urrGQlN9XIiwB4xNrin/WQPsBOJO0qKo2Knh7MdptN5LIKKrDTBm8KCFS/pHf0e94TECVAkDX/N60UH6Hgxmv4J9icgwquk+faBMir+itUJulw3oxNh1kBD8VlWm8w7mWL9XPsxPd29630z1KFqmtiIiC/k+r6btndcpA4WUZxjh2uSzjFtlENQh2tHKBtyIrvY7LdJfVuFrhfoLbqLAJLefYsPmcV7whCdzB6WlDYqtMeAQp/E3OpFN5G9+Mo/DxdVM8SNBPTjYN98KR6uaHhT1+edeH3c5xTr7K+d5x2hUOfl9LgU/1oZnxusTlP0Pk2KHNoYcsTdbjB1ysqPBk0CxkjKSU8EPe6D65L6wZWQ3H8xM/3Ikaq0zU5n77ZFA0Bac7VpdoXaBY9LurOBh4LgahVuMaof00stMdxurzWzRZx0gfedBJXA3oxRuyT5O9SVKR+vUgQLzstSjbxBuY88lgWKd3hvo+LmsdiQvGbs9aE/Q/sQmPUVHVsrzSgkrzM2kWbltEWJLA7CAFkfAabjx5GEVcnJvdAZakXT
 5QwTGXGE
 ebddznXRVPERpUtNDGAa1H3pkCr/lcyos/eYt2rd4kBsHj6llkAnrmpeQCE0PgPa/xBmEvIbQbbNfDjlCcuTMoTkZtR5DyZANahF/OE68VX/EkjxqgUN1OdyzJhlytKBehK6ci3r1lXdfjngXAxrY+CVGiRv4kubH+jLWjc73zh0ujtwbsyOKqFEp7D7648mGy2dHGxFhkH2XUYRqMSG1lTFYXBiQSIuA/ssyUIfZH1iAoGJdNjdSy8AHuuYTb81vXIP8LaXIOBk5+kASK8PAWPDENjezPl7/nc+0hxAk9O+yiDuqnkaMB4MgFTqBFWizrMw9vYswtfk+kc+0M5Pro1lDYIPLTvNeKZv20jYCbaS/u5C735Rm0U5H6hBEuaj7q7/U2vFs/5ZTEUHuj4GreBLUL1s3dB+b6V0Jtb0plMvjfB0fdLmaWmR+JXyOvxlXuwe0b/zGSOw3nXYXw0GFPi5/UjXYNfkn3s1OifEw1D1sByPSwKPZnD5Y86601vQcXi//5AJfpaWImHNtSMYYw0PbTY7QwRRmBFegFFBGs0/6K3mCZQN1DV2oac2cvwYtNO5OI/PHWrg2xsoAP3BICewC63PCq9frxiFtwxmRxxHTazj2QuSvDcQ8q3LGk/jFYn2MfBxjq7Dz5giq4mDSI9gm+g8JzH5jgRhhE5a3aPpl71b/hvLbe+OgLUDHoExv19IY1nmDhWdCah1XbMJJEI4oZnhx0xQTZsxqPxIu9WfGXLKd5NBaFHqvmNMyVCpkq7itOWHRN60+s1G7bFCIpdqpz1xmxmNfu933uYfwJqdFOZ/RhwmrK0D8h4xETEBexueqh8ZKshh610L69/lz2ZQ0lSD11bxVqsDyrumkcLQCTHu5pXj87Iy+6oC1pJuGn8e9gGjqDwA+lofaV6Eu9j1k5rOgbRmoxsqdv5J0I0C45Ze6ZGodDCHuuyNltcbNpENP2SiUgoC/9eu3ytAe4Svhd5pn
 S+dCmKDR
 /PwnwJC0xVl/c2sYZXXucjnxTKfX2/X483P/r6zf003D0TPeN0JD0thsTcMY80X4ZDTAHtaCcbRD3bp9HYBus11lQdFmGELrqu2Vz9xlftm/PE+OjYVoXp220as4fjLrQHarbsgzXFaWmRHDK/9zakNqGMh4GFTRRQQCRH7b+lnx1GSHII2epJ1HLDb+Uz6JXbtVVQ80TZQSpH1hnET/mpUD7n2GNA6/FNRL/w4k9UJh9lz5F0lGX1mQrVfzStMoDwnzBmGHm2yaj9ePN3kJMu6Wz15Rw34EyTrN/CL8c59ad08NaHKswPd5f+VRuh03ubYnNWFaWnnJyC7oSz4iTAaDOXfZsCP/9KMKQUOwAm6Tzt0H3muyI0jRycqWU+PckV6nr22Abj62gu7FAdANjX8xZ1xQxrXEOKQzgTzsMObOSIea5noxxZfaaaO96mICyYkI76pTEojVtQrSegb2r/1/gnChppHH6pwXJvpJTjBz1v2lCHw2RWm49FuDUtQpWLDB0lrDCppn2Q2HFsc7lgDfvibh4kszHiisG47ZgPtpNRXY64zV9u6cpJ+I/9yyIBI+Uz3OlsLsuoZpx+pg8vD/4GUeUZtLF1xkJ9rLTnW9yEAcBMhL8/pMAnWjWgXMcpm+KNEvQ3uEYaV+eIaz/F6xSylEYONMM/3Z2qzg0Ee1YknORGLYq8KXPGKYqyGHzjVlR21gMqv5AGkpU/yWxyFWM16/BHXE3sU4EyKNlyGNKMx3oot50NTE+35tvCdgTlrwRQ0seMK9EQcBK30iEUUEGtWLSTDOt7OM+Q+8CCj2Jmh6KPDAExfl54EJbPKCneX/+UM/6pJF+TXheIOyQCsonFlGjbKsPXJrZyqpk9VWin+DmJfSIJZSWbEENvCC7ok4J1AXI8NsX88Ud1fgI89QCtWE9ZqI85kE98ZxDg4j2C3W0twqJbUWQ8YMLAj+o01TCdyiVUzDOobZ6eLTlHoCpfChT
 qkzXGTqq
 3/opaQcngH8tx6VSBAmDJHdt2TgQ3dOlEsYFQAcQbN7a0NFLpCygMvfTwNAfr0RSk9FtB4UdHglRnxpXiuBU0pmagTh7niXEHaM9rHcJRYI36i8LjfWhwcZEKV0jJTlu73/gwwGcvhbsWo9b6IwMeH8gSgqteQf8//PlHVSJ/huBQraQANl4VjxcZDHBGFeJcytrggTl5T5gJyf2TNKvZdfv5XJ/UTssnx4Z2B8HpGaFQUm7nma8hiHfkjpgK3+TwP2jcDcubNQoluuJZf42LWcbZHZ4rnpodM+oBFcBRlumLPH3sc8LNBA5jvNSfjGMXH7FKFxb0UUU8V4fp/8PuvDFuuX38iIYHpG1S9Q0nZpfb9aFTNDyjnmj1BT3+ViptPBpeAnKHUe2v7TZr0H0Ad/BwB+iWyYP2rPnBPptoyo68aqUED3ygdGtYeXenC3zYKNqUmmxbfH8eqtCh/sLnaiwElGcrWCNs7aM/hUZmkVm1qnb+5c1bRV6Ydj5mqPTsPveh++wIOy2pyQNZ8UUegDPU9AnJP+kj9UIlVLFEH4ly+6txFzTZv9EiDH+UzpvMBl+2dMFq0/1zRmRLKJB9FZgoQn/eDeg5vl6tXAxEetUQBiuYrY42LT4pdWNuQ/y5+X2NRhJmNgU03MH74FweRksn4IoM6W3wyIq4NHRd3iWsKIJLh9HsrnANWedDHEHlr53yREhGYz83zhEJ3ltaLxoJRlw9DN6JsDFrLpCVN04Ig+M4opPeQ/h5MA3gqnxLDY0zd1gaQYEMphOjgOZB7oYRzvQaZrPzx4h0kAD1jpgDADpW4eRKVaRWIdHZ3KtV1zQ9jlrPUFgWMMIro22SbqTN/eriOT81jpDf5jhgJknpK1eD4HAy8aoH9ml1EOWp+EYKvURTRU+PQBXM8tshI0OmOUHM6F0j0vGkwzUe2Siqd1TGgMuta6Cau0dHrY9PmJOHO3NmcQGkctUUK2OH+Pv0t91e
 5Xi3psxT
 gTd7IGmHHJZasGDwwBk5zLPJbDx5WQTJRGGrYtVNJdNF8pME/NtLM4PuBReJ/NMIHC9/Mfa0DT07lZJf//SWYxjWoLFSEgOPNp52MAdLW67ZOhiIrXxQkBcB9KOceoTzW/qiAbyJQmiLrtcQ699lKj5raMZxDDClgtrlOVhZs/PcSJW1fa3EpdbNAM9Kk0DixODa7GWeo9Ja47hFbUk1LOshag28CsIsaBjoHGDxIF97iB0f8Dod4lu8N7fxN/7/RP7o9Gm3H9GWRpkjFfr8WaAyKhuth3QkznuY5D1kp1pHyyfX/ZGxd/2OeMuS3lhfCFubjJbAqIBCb/5PhEPr7Urs4pZnZz/SBSng6Pe9Ni4A24UFKx5LU8ssNCO3Pb0gKSkDLxYH2ZYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than referring to VMA flags with uncertain meaning, add a new
predicate that explicitly describes what absence of the VMA_PFNMAP_BIT and
VMA_MIXEDMAP_BIT flags means, and then refer to that function for
determining VMA mergeability.

If neither of these flags are set, that means the contents of the mapping
are managed by core mm.

Otherwise they are instead owned by some other kernel component, usually a
driver: the memory may be MMIO, kernel-allocated pages or even ordinary
pages the driver maps itself, but core mm must not populate, reclaim,
migrate, copy-on-write or merge the range itself.

We initially also treat VMA_IO_BIT as implying a mapping is not mm-managed,
as by implication it cannot be. (mlock() also sets VMA_IO_BIT transiently
on ordinary VMAs while locking them, which is addressed later in this
series.)

However the intent is to in future remove this, as no mapping should be
marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.

This forms the basis of further work intended to improve how we express VMA
properties such as this.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 53 ++++++++++++++++++++++++++++++++++++++++-
 tools/testing/vma/include/dup.h | 29 +++++++++++++++++++++-
 2 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 438ab06a4a91..df8a5a1eb9c3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1612,6 +1612,41 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_flags_is_mm_managed() - Do the specified VMA flags indicate that the
+ * contents of the VMA are managed by core mm?
+ * @flags: The VMA flags to test.
+ *
+ * Such a mapping is one established by a simple mmap() or brk() with no driver
+ * or other kernel component involved.
+ *
+ * They are rmappable, and core mm services rmap operations including reclaim,
+ * as well as population, CoW and merge/split (if eligible).
+ *
+ * Mappings which fail this test are those where this is not the case -
+ * e.g. MMIO, user-mapped kernel pages, udmabuf (pfnmap shmem), etc.
+ *
+ * Returns: true if the flags indicate an mm-managed mapping.
+ */
+static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				   VMA_IO_BIT);
+}
+
+/**
+ * vma_is_mm_managed() - Are the contents of @vma managed by core mm?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_mm_managed() for a description of this property.
+ *
+ * Returns: true if the VMA is mm-managed.
+ */
+static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_managed(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1620,7 +1655,23 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
  */
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, mappings which are not mm-managed may have established state
+	 * upon mapping not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (!vma_flags_is_mm_managed(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }
 
 /**
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index a6a8e53c4b38..89c645a6ad60 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1665,7 +1665,34 @@ static inline bool file_is_dev_zero(const struct file *file)
 	return file && file->f_op == &zero_fops;
 }
 
+static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				   VMA_IO_BIT);
+}
+
+static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_managed(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, mappings which are not mm-managed may have established state
+	 * upon mapping not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (!vma_flags_is_mm_managed(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }

-- 
2.55.0


