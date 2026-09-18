Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD33FC982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8966F6B008A; Fri, 18 Sep 2026 09:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 820166B00A0; Fri, 18 Sep 2026 09:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8176B00A1; Fri, 18 Sep 2026 09:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC9C6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:21:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CFF80806BE
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:21:11 +0000 (UTC)
X-FDA: 85226943942.14.6357C5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4505120008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:21:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TfzaMgjx;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789737670;
	b=KOLuEftKqkIerQilpWShzjEU8hXlIRx6mGrwYDdzXNho44jaBoTya/Dqa8pF91k2pX4e09
	aeQU0QqHSdd06KRiYSBoj2RwJzhpxBJyVUCcvhkqUHHnL4jX0R5huezmp0+xRCEOOQAcGv
	RojmUWa0tGg7AK9YQJ/57MI2o3gKSlY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TfzaMgjx;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789737670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0xpULa2wThyMyC/xm34rNy2PVoRdKfkNjg/wDjNfAbA=;
	b=7nNbaY+7V/r6ZPtmCmHPFI2j056DRgcSrKd3KIHedN+6mm3muHmLicWUkuKh7bKJUooU7w
	PEUS6JZBIu7akectWwPTrykMxzGfGCX9L9DCf0uAWb6qpfPRdVmFhMLOpd28tfi86dHskk
	RBseFR37UJGlTllO/IQV+/EBoMGK/6k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A960601EF;
	Fri, 18 Sep 2026 13:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67ECF1F000FF;
	Fri, 18 Sep 2026 13:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789737669;
	bh=0xpULa2wThyMyC/xm34rNy2PVoRdKfkNjg/wDjNfAbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TfzaMgjxtuNYRSbgy2oM9VNvelBoHpssOxVnn3XSg1NBMWU+/jyuXP6IaWZPY1CyA
	 HdBMtjIknOhPruLGftRV7i8l8p2FKFX9fh6wCnG6H7oIwP4PW1xdz9+MUzns7blyED
	 /oRJYHsPVqdDxPAyuN2AzxSAiLvBhcP8CKPzAWi22BWwuNke+22ALcPYId6jeNIBML
	 tQQNk+We4UYkN+CSHkOuucCPZKJx6kWkj+b3NHpOKoKa54bgQVSWJGafkpCLc8uAXu
	 3AdyFrmOR8pMPgGGIaBQnhqN7aE1U/3MowHa1LPEb32ScKkPhZnAMxVtJ6HiM44AnV
	 XbSuPP1rSj3rQ==
Date: Fri, 18 Sep 2026 14:20:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
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
Subject: Re: [PATCH v2 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <aq06hcheI4OGi_3A@gremlin>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-1-7d9781ed5361@kernel.org>
 <aquz9Z9JrK_H_E0g@kernel.org>
 <aq01JFp8hRReyY-O@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq01JFp8hRReyY-O@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4505120008
X-Rspam-User: 
X-Stat-Signature: i5eyi7ketuqr8inw8fj8t3pf4dk4r7fa
X-HE-Tag: 1789737670-208190
X-HE-Meta: U2FsdGVkX1/k8y2v0rlWtfv9gj/Lwpqj8S3oymjUz6VIjMdUOPXTKQXuD8GJBU2jgcaJYEZai69bzbkNRQuGUdVHaiEiJ166e/lHBw8xr+xYEPjUwZk3XT3psuPfmJqumcyNYh89+8hYY++4k19fafk6fKevuULJrG1bJeHHvQ42nXMZlVdR4/Aqt5iel8ym5vO1CP27phEzDYaXzwSnxHh4Y499nVZpN1/ZaqbDBDDC/mjbwrQvuG2MsaUJ3a/T7/4aAOqBF/5BbuPTPKtlr3CHyRNwDvYHDQzOZn0P0A5DabVaP2GdEpibWoZNNysTgITm1hKr25E1iaw6Dv6ynNRPZf6NPAqBx9YQnbB6PuKDg5WCWbf3Ys1djirwgdHFrTGj5FCct5l4fTOIgQoZnC4HkT5VecfieiNy5UuNBSA8nfQN7vHnFDVDbs6Upc4/lsr63zEnfFfaeDVgEm1tyQ5bdpbwiXGz640Q24CJLN9GHDncR0caCE1u2qwGUrK+eGnFnnsLfW337//IUz/4f16CxW0O7AfS/BNlSlzUiY4JymBca8r0KrEPIwcLt7RH191lg7td3+2pu7wDQSmJ84ZRvYPmOK8jkTdFZqC/bTU+m02iQXZyA3aXV6SS5ZEgKkuQGyF20MNp9FbdBExecBIsKCqT8uZD22Hq++QwSQGrFcaWsaTg+XyBVs67Tlh+cwL3nkHaA0lNCSWboacY0Abuatw+DKs/Lm/uKr2QrviwMMa4x1TNk9B6JfoD3QRNK2y2/vIJXg0OqC7Jke9iix5KvkZkNmpDoGL8hl2xs20RIHZ23XV46dq0bLn+WyKcuYlOIKPv6bSUIpK268ildl1R6UHz+3KK7uxe1lBMQhyRwM90pGaPF/NniOcSQiVqIGRhSlvu9ACMF1zXCOTEzkZY1Gy8tVjpzuSAU52WMdsE6WvCR59JIUsxgwoFXX5DDpAyvoq1kODpnWb8uFy
 qeiqxcaO
 jpxummCTifPg2iuYAjlkEgyjW9E9/sn/1Y+wAwwOMtx4vXO4Qhg/EuoAHfIKZyrWPTbYRYkhjkc2KWBkGF4AfYn+KbNyB94KGE1XL1fjSpE4JJWa2DWW6GR4eiGsY75sOk0x5sfe2q/hIujFqG+Xedwp1FEUOt8aQ1djH0+HXwsgCi09NQIHShhuqyVWbUTPARdpu8hpz8E0uXyc+mFAsUjdCxykHStYfW9aXjCpkktHtmVpWR7Oh8MCZGqliPdtVa6jt8z4bMq1SYD6Blt3CZNmyY5l8QvECSSmJLpDMvSp8bdMxBNaF3p+KQMA2KnEt8ft+0ngQ+zxUHqlhjNCSFPwYrnq4Pi/JhQmVVp7wz/2BLWO2BwmLo+U0p9a/+GN878NLdTKPZqVTAxrgOMQE2P6Vuycc45F3TrmZg0a25QewPnrqS4OfTWCHoTv2RapRDOcP9jbgJEov+oQ3GCTRbF85j1Iwo8lTXVs2fWWhcIEHXlxCKQaJEZjEKtCDgqHlKZdmIGVqSUZIGbbuDL6e7fSrQgwIY8fPIVv+DwzKMR1V11PK6DKqVLqAcWkUT7eGzyFw5WG/uQxhp+QET1Hw+2B7ReA/KlS7tmlQSH9LMJikx/meiR52OTZ/mh1UIY6YXM4GTFgGECsdyGLz/oHCccjvL8DhOZ+7/v4hFvUnp+lRK7BrqpIheHLa4QT3Gw0IHGR8B9XaTPAQsUFBEOGLrqXEfCFd6zFusyUoOgrZ8y0xldMumnXsCxLQ99gIJdCB3DHmghg1o0bRPo41Mx/p95dEi8xTbgQLSbyuBZNCh1EDoFUVe42Y0dF5NteMPZgjd4LcEAbsUuG9ssrc56OjsO9Zf02AjAD1QT/uE4ynQpAwPqE++gcswn6WiwDjhd0oqxhZyGgz9us/BohuUktO1Gh4RKl1X/w2U9VMl+WEQeet6abIR+DdF5b6gcT6ZpP1PmYQRK4gVq85iAvGmoMd7yfF6dwQ
 ufueHuRA
 kc7Ji9Wyv3T+iJVrjr7r10EcJl4W6XTzqK5pG/7hi9kpmSyz3celZg+u5b+78p0X6T90ZWi3wJfUZXfyUSU+Dn0BFBhunPBEexeBufNJZltFyMlF9hdHesISKk+Cl9RtxYZgJxNNn0pJrytrjh8+evqXuckUK/zbqNqQ2WhN9B+A7q2OZIykRI24TG5PERN5Fq8TU7LrplPwajUGttQH0HBMwg2J0gKam6e7X5YPWv0USsT4BpelI3Hr4uPDm+WNwpdmKseWEg42MVVIA0Y0FUs3LLYwZx1luj5/YQR0utahoidDgj21bICzmskJYHeXsxx6IcOm9oiP8owBJXGbLO1OfwM0hON4Wvxc6es8/cOUBVVqCb/NoqCPLTjefE+GoK/Gr+AG2ksuV7AVw4L0ILGeFD4nqKqnjlnLD0e5Sh8HysuBIzgwrI1D6Nvuq/YtC0i3uXMa80KuVYzWqjFkUmLa1G4rKxzgdmB0vIojqVcVs3DpIso3T4fc49chBDwtEP+fL5DNkTf1tr96OV9CoHT3iW8TW4TWsVv5HvldzEvRMyeliw9VaijE4eqOAYvOfhFhml/rpm4Vk0GM/W0mDW0020GAkHG5BwPH9hRUqH3+FOIM8xPpD/DAvsHPTFjjmwgihiYNlixnPz5GUovyl+SGu8ZT47LjpTub7mQb1nNtzoZWp/Rr78dBp1Z1iE9WODkfIrlcOOh6ncq5VJVbps41oLKP7Ik6FGzTtBLYnHfE68QW3+pSJfVMwLB1MDnkoh/HetRP3IBGLagotDcTDxcDLCs3edrxMnZf5DTswhoFeLxyXW9NDJkyWY/J4ia+SNMsp874+NBM3pVDOSj/G+27++8j+kSR/uOCVfoo+gCuc5uNGF+/+aWoteYN/UEWYYdjGnNg4PPkevMuopXIAu1jGGBDOqvgnB/R9JKPL8LSYqysXFxZ1LabIP4aLsXdrFW6SUx1PdcQrgt/mVooX9H+pC3Ao
 W0QoU7BE
 ZLky2ZuGbInu2g3pjw17/4lM9lJblU8Z40M+cpgxr7rNpnrVFy94gu8jhNGAIb9UX3KZE7BXkvoKfrAmJ+NlQ3pYDC9/gdJL8whpP9bKMVTJ/FGImD7KYybS85BOaaTu8p8NftTrw0jdtMaPeJZvZQHyfwh7Qry6SffyaO/MF0X9iKOUzwzgucnL4buz60eW9fUJ6l3adMd/FcXVilaVuEw687hHCkt3UqxKHWlJKc+VSHhJMXPGMW7j/fOKLslN67lHvgOwHJTtuKkm+XV12LWVjDSGEoS6gy3+DRSN6Eo9BeVkiWMc/hduYVIZaDEBCgKte0GkJLaasEUrqDzZK+EDRM0GTTFA1lHCml+GLxlfL0flpgM5Arvfj1OY9dYvqiFgwobJ/toG7CrWU8S3Hr5r8SnH+9uamJJclmjcrxXTW9TKmupNjsMVt3ds1gkjyVa9/U/eg15qdbAKxD8kvvtlz/unlcijJUQLLCPPYVyfBor5AaptQCZujbyZ4C7KWJlpgjU2/YCwHYCCh820DrDjUCewFvyVPGitbTBxL5SuqEH7wmhKMLaowvWEqGwNEo0xN1ow/yTvH1HNyVVIxAzTee/WeB7xc7ew4UiDqGZBQCe5p5mwPI2SsUrhNYbpyl6vb3WuRXj3/K9u39QjviQO1X5x5X9pFjYujZtdPBaWhKbKYhJ2VT3EdlXwwo/ghAoy5KL2ZjWOJIgOXxk0lKLtC+Yyatgl/q7OsN1ERUEpkvlQ5VPqxTAihm8OuAlciuE+qG4ctDdm/TlWqG2oM/94GkpEKyv6JfJ48o9ogxG+7FyEXktjTrbtfbsXsxbyGxLWe7L/25l/GaaUQ7nn8qYkMCH6mE9YuRrlLGpGt8lwKutCKN88g4Qoitmz5AinBCQCVWAkvfDMMYInMrzYcLQv8Lcy4Fm4HeLjcRGCEImdAXs52KxswrqfXb5WMUwPtEuXVbPkwxgTQlMQEOhmBLb09/I5Q
 P9Ghb/0w
 kVXRD4Wp1vEpA1eaRXTRaDxRMu8Ii73aa40GXu0u/SNeplOh623j8j8B+oIVAsw3mgdWP9jl124+YWzjhGRaPpMagMErzG+TEi6RLxsHhIQxWEcpadYIn6eU51hPYY0LZfVwyJkotEebXTNGfPpu3R5RFYWgpq7CL1sxGs4FN9l+vVM5QZUZYcHz3oWtiS/2CEaDpSKI1AO3/nwCe+Pwl8bht20A/w5udfzlivgabiR2+pyceuFcAaIDUzD2ZLAnygt81saO+nCUmF8atVESWtTz0CXWppW1VWR/aB462o83ur16k5WXM5+jNQK9E2W4mqog032u8TBT9sLPvDl5iuXG0jKKZAF5KCFq1rygt9qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 05:57:51AM -0700, Breno Leitao wrote:
> On Thu, Sep 17, 2026 at 12:33:41PM +0300, Mike Rapoport wrote:
> > On Mon, Sep 14, 2026 at 03:57:21PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > The map->file_doesnt_need_get flag is confusing and the existing
> > > implementation has holes.
> > >
> > > Drivers are permitted to change the owning file of a mapping. If they do
> > > so, they are required to take a reference on that file.
> > >
> > > The mmap() operation which ultimately invokes __mmap_region() is guaranteed
> > > to drop the refcount for the original file the mapping was made under, but
> > > this is not true for the replaced file.
> > >
> > > This has been addressed so far by tracking map->file_doesnt_need_get, which
> > > is rather poorly named and unfortunately fails to correctly track whether
> > > or not an additional put were needed in a number of cases.
> > >
> > > Make life easier by removing this flag, and instead drop the reference for
> > > both mmap_prepare and the deprecated mmap callback in a new function
> > > put_map().
> > >
> > > Track whether this needs to be done by aligning mmap_state with
> > > vm_area_desc and store the original file in the map->file field, keeping
> > > the updated file in map->vm_file.
> > >
> > > In order to have the same behaviour for both types of hooks, only drop the
> > > reference __mmap_new_file_vma() itself took in its error path, deferring
> > > the replaced file's reference to put_map().
> > >
> > > To make this work correctly, map->vm_file has to be updated before any
> > > error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
> > > set this field first.
> > >
> > > Also when mmap_prepare() changes the file and is then merged, the reference
> > > count also must be decremented, so update the logic to call put_map() in
> > > this case too.
> > >
> > > Also update __compat_vma_mmap() to manually perform this step for stacked
> > > file systems using the compatibility layer, and update
> > > compat_set_vma_from_desc() to replace vma_set_file() with a correct
> > > refcount/file update.
> > >
> > > No in-tree driver is impacted by the incorrect implementation of this
> > > currently (no driver that does this is mergeable for one), so this does not
> > > need to be a fix.
> >
> > But the patch iteslf needs to be fixed :)
> >
> > It seems to be the change that broke the CI.
> >
> > The rest is from LLM, take it with a grain of salt :)
> >
> > mm-ci mm-unstable red build - bisect analysis
> > ==============================================
> >
> > Bad commit: 2a937a04babf1 "mm/vma: fix mmap_prepare file handling, remove
> > file_doesnt_need_get" - first patch of Lorenzo Stoakes' 40-patch series
> > "mm: make VMA flag semantics explicit, eliminate VM_SPECIAL" (v2).
> > https://lore.kernel.org/all/20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org
> >
> > Symptom: tools/testing/selftests/mm/pfnmap.c triggers
> > "BUG: Bad page map in process pfnmap" during __zap_vma_range()/vm_normal_page(),
> > seen on process exit/munmap. CI's run-mm-selftests.sh greps guest dmesg for
> > BUG|WARNING and fails the job regardless of the test's own exit code.
>
> I am seeing something similar here and stress-ng can reproduce it:
>
>       WARNING: mm/memory.c:3225 at do_remap_pfn_range+0x9b4/0x9f0, CPU#25: stress-ng-dev/354858
>       Call trace:
>        do_remap_pfn_range+0x9b4/0x9f0 (P)
>        remap_pfn_range_complete+0xac/0xd0
>        mmap_action_complete+0xcc/0x3d8
>        mmap_region+0xb54/0x1978
>        do_mmap+0x588/0xb18
>        vm_mmap_pgoff+0x1e4/0x320
>        ksys_mmap_pgoff+0x2d8/0x510
>        __arm64_sys_mmap+0x100/0x128
>
>       BUG: Bad page map in process stress-ng-dev  pte:0160000000000fcf
>       addr:0000ffe8d9080000 vm_flags:00000071 anon_vma:0000000000000000 mapping:ffff0000a0c4ea98 index:0 (file) ffe8d9080 (anon)
>       file:mem fault:0x0 mmap:0x0 mmap_prepare: mmap_mem_prepare read_folio:0x0
>       Call trace:
>        print_bad_page_map+0x63c/0x740
>        vm_normal_page+0x228/0x240
>        __zap_vma_range+0xbe0/0x34a0
>        unmap_vmas+0x240/0x318
>        unmap_region+0x12c/0x238
>        vms_complete_munmap_vmas+0x318/0x958
>        do_vmi_align_munmap+0x254/0x2f8
>        do_vmi_munmap+0xc4/0xf8
>        __vm_munmap+0x174/0x288
>        __arm64_sys_munmap+0x70/0x90

Yup I already fixed it and respun the series :)

https://lore.kernel.org/all/20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org/

--
Cheers, Lorenzo

