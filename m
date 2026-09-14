Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F3D4C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52C306B0092; Mon, 14 Sep 2026 11:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DCBB6B0099; Mon, 14 Sep 2026 11:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A44E6B00B9; Mon, 14 Sep 2026 11:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1311A6B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:05:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59DDA160121
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:05:02 +0000 (UTC)
X-FDA: 85212690444.13.9E09139
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7F2241C000C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:05:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bHAoBXnC;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398300;
	b=s+fJ8p/rfO8SM8O4wH6U+A1I7jS5Tc+cjXn4VPJsIFw3t66k5raSNRzDAMCrbbar2QAU1t
	ixTaAGGX99NMsSWQ/20lmCEIJi6w9LQjNw4QuJguH4TiQJI7bwGKKhmSSI2rZce22UZ9+S
	Qrubxtebgu8TOaJPrurBzzeekptmtAA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bHAoBXnC;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKPZ8QoZldXfuRlSWzMd6mSbaJJK7t2kmdRsGSTOMEc=;
	b=IMBNAxr1Ff12t2Ny0QdqXbI+eCWKBKnQE/M5r7/6vGPy8dXgBuOQcEjegR6QDweIrrQ+8B
	wFxjGE69I6qX+2KRe3bq75yuICJdu2gZ4o7EohD7zBb/aJcHfKhR6tiEl5YPMbgGpPaMsy
	9Yin7xZOzMzMXFEXNRt/VGB53ztSSmQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 125BC60252;
	Mon, 14 Sep 2026 15:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B873C1F00893;
	Mon, 14 Sep 2026 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398299;
	bh=iKPZ8QoZldXfuRlSWzMd6mSbaJJK7t2kmdRsGSTOMEc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bHAoBXnCjLMOWtgubRwbqEhW8/63qJmiFnf7viZOnUKC23VvlKKwMTzUtqC7d9KfM
	 shm/X3XkTr93YE4qKtOI38Pj8YcYVg7D9aPJoBatHQXy1SdYfK9QUtFlLO8wU8Jqnz
	 PR1uM4imIjm6GSZi7j3gsVAePylt+/5gsKdL67nNlqrRxHE5U5MotjGMzG4vWiV8Lc
	 RahJJumhPqsjra9A4bTa/uh71Z09NULtNMwLwo46z90MgsmRyr0lSZRH0Ef0tzxuv0
	 AWZ0NY0un9zBKCh/5yTaC6kePa5QaTNYTdPVv6mznb6EuY90bUgNSoO3pN4jEeuUZp
	 XGK7PzMQlmPlQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:32 +0100
Subject: [PATCH v2 12/40] selinux: reject writable opens of policy file,
 drop mmap shared/write check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-12-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1880; i=ljs@kernel.org;
 h=from:subject:message-id; bh=aNFeiTnbUkQbxAr7iS7c1JWEd9CfcPtAZlIAhlnNHxY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK/P/j95F9+ty7p/527K+tW0JfG+DEf4P32mmh+dv
 6vUHwd+7ihlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBELpoxMkzsPHubz6Sm1YvB
 RI91mn2IAIPb5HWT9rbvD6zmt58vpsnwm4Wl10N5h3NGzfr/023uJ+zx2VNjEXE2/8at8MbXvpf
 zWQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7F2241C000C
X-Stat-Signature: wmx6mzkfjeqcag7frusea3ztoni9zf16
X-HE-Tag: 1789398300-908674
X-HE-Meta: U2FsdGVkX18nxDQOyoJUdi5dfGLw5uNhAW2WvW5lmMWjqLQP3P0adgQxe6+IGcupU1BRtbs3zbePxVKlAN+tW8AU+hOvtCULrvY+VHD5zsy9Oy7UkkLlgRUVcggeNg/OqTpQQI2O18zu0aL4H+5Kgb8uVoSNQGXOIBBwq0N9gfAfcml93DH6p3Pb7P2I5oaHHuim+Pb/LGxr37n8H2OzZG3cvPS8PeRAQ0JfIzVszc4FGRTXaKsCj6m1dGPy7mEeDv0JRrOiENnsy7MISdiXRq0ZUQno8Dj4wUW86JIWVpEY7NGJ/KKb1LI7lalnexS5ifkTaVDGMZ8c/955Vqt/XP1cc2GEHDB52geT3KNK/D5uMIBR6zpigsoXTBKqV14VlAj86nkzFZgA8C/YhhlzxmkrI1R/eQ6uSOweHRbEGbuWCZxzKMdBQmbO/Ll7PRSroVfITDiposfYghLmHsyzD231dx4nt+FSuAm4PVPayXxzvAXK0x5ZW30bgzUTAGMWVhkd1co9brw/4KKcTGXPAy2xBxf2Avsrx1jN8UStWxhQEqK7LrtCSn3T+MWNyT7UcTK1jPM4QwTwQ3dxAiVkHtMIcRG31fpHaY8zKc8DVMEfK6YpkoKDmDX4MW/ikpFDUn1J38/hKTBWvjFaycZ/Ul+RZisH+KZP9Vbpk0swbqQ7eVvt+5b2D/QGSpqO4WNTS8qAqwEb4nnGT07oBWwB8ZzddlpxQpBO91KnuNVSX2o8mQL1WOW2iU+oAxgMBhie5AMvU8dZumHDi2F8UewbgWPjXXvPd5cJf+MYiU2vLgpXjWEm3pjwhuVRAbZQE2XBlnU5sbBoafTHRfmLqYs4EoITYPl8RcqUbH6VvDmueUtH4wdc7ZJfbt8GOIjh5XaEdb6g4wocStufMd5ICGrEu4tz45hsbfxP4//WXjg2zVxsFZIdfOb+ZnK4PV1Loivi8lGNYX52pi1Gpd1Ttq4
 7zW/ugKs
 gQmIVX3Lk9L/WVWe0gzfq7r54teY5qhBmSaPylZB6/uh5vIjFohFwtMpV6OA6Eia1JHTnsvLL6wxGXO6i+HP4FDqiJG0DyIPb+xpEgk1qZRSkaz5X/vEq5ZFOISkXuGAmw+pd0FYCU4FkVTYaAZHMp/8bdGVdwRlXsuEBKi+fARfCjQZOdj+cfFG9PQNfyrd/KdhHoGQBWzi2qnYWkIs/0M17srGIhoKm3BK5LUg2kt8irsb5NoUMC5L/W953sQg6JhrDAWF1DXVAgJjvJf1gxB2U/xaAVwoSvqyyWFJOOj+jmPXioyFYDdrph9ZTveac4yLDTPx298p6IRfnaf7/1hvVOJlOWXD1tO0Lt+JcqQ1752j7EdxQXH2ZNT9eB8EYyeQC1A9/ymXzZwSBEZMrAsNMM65wwfCZDTSkcocQ3Iki+3I9dFhGaoF7atoi0m2e/ku1RCVQYdXMwH+/Ax0LUvMcQ/N5/h7Sli/HsvfcFxiwykwUDmmzda4JBFi+TTIw7Fwy7JIr++1Y4IONUUVGBAqbWSbTNR0zK/AmlK1Ds5HbyOCg/5IVDGN7YP4AaJXVi76HhhejKuaRfz8720vMajISkt7r0dFa6Er+3UnHTtX4THhoiHuAlY61KxuUEjesr2qGGOudygK+BgWe/lsoaLN3hr7mjIcz8vL/9Wa3YK8HjnH39YcOqKk3rbhPuu9WZQC/Vk9agZ5DXHSZkxVyQiRlrh/3nletpdPjQ+FuVf12sjReig184JLWyMRfwpQGcLTrJHo5V3aBuYobloHdSfgiJU4O+llPwC4+ptINblbWtLFPZ3dN+X2MRYqmofwYvETY/RY8NgOPIJC2xf9XjzhpsWvJ8GG3rlv0olvwjLlKsFbM/+IlTTRsvI5ytSxdVDluiLR6QYeHPi2Uo9bNNcRq9dsHG49xsajzHzRIIEQMdwnADez/8Q9Gl3W/GRbZvNe+S3lbZxFxM2U1NyPQqufYnFL1
 /YHIqxAt
 TL48yGhJcV5gQ38bNuejqoGPyboBuMcWA3iIQ7I5vs8+Q5lQXPlk38dTFSJ6xkUEYzl53FcC/BcOEOkXPzPLWUYpBVMwutQuWLofyy8kW8KWjXqPr47hGVWm/suje95Ih180Dx4QZPcB/xZRZssoFO141IjiwEkB1bzX9kex1re1xtUtcJy1NVjb57aZAVwNeHWqm/StWYPw+5SeqRkcrujsCk9yu7Mz08XEdORrpjdWEEG6JjdwKub7GM7i8BpB9g/4z3KO7i9trORP8aisgNtZ1ZAWEaRJ+bxmIjn2YsVPFmC5Z6ayXuQALMjMakxdkiCS0Uprs6ZdSQi34bzMh5U0XfANOJAFRi2sTutpi59dtzoO9vA7Yifa0n4UUygmqKairaEDLAlkbV+ycJCk6lclVu2vYTwGWGL+m5Weij/fs/x9smU3fICzYXyp1exV6PPMXShLQW7wnbAAXRb6U0K3eWPRlRUTApNngZhmUIFkXCi2WXXnGdMphRi9L/ehMBCqXHftmi0fZk5ULnpJKnjLrVhXeOGDdkrrimLyfD8ActY0BjkzkRHPuuw9eJEqgrGdYjjkwqG6V0u5x/is+b2hP9VgqaQiOTFSvmgf6/p997VYiuCcFVUkMjJmB2zM6hV7UhTyHbyuLTNFvHiVyMgtpmoJ+bcBkpkdx+SiMjHvMESRsMhCJoyXJtkoOcz9Fspx6RibwlGWS60651Rni7EwoSzUyN+0drV+Jz1Bq+8dmDcRFauVsKkHEuoN03vc2ZKDskzath/S656zAubQkXstc9wgNzWCIJzKsF0CrHy0BdnP5cx6QSfIG109DFKlkVTkltCG0LCob1ix0hrnJ89O1yYCVPLBUa+yhafx8wpwPoshnr2epdJoon1uNjeujOBZtKlVFbK4kNWRcyDmhQVBWhhxHoW1/h5ABgdJf1xAA6w+GVhtcLTVVscSs+AThQGCbQgDzHpzIAFKlg4fMtUyDIChz
 5eWKcpVM
 +0kkkWIJjniMQV4i6i1X7dQ7RP6Wm8scpMPZ6Uz6GgO4HsWaTKIXgNmRftT+Dh7XJj/JLnGlPluU0MFOEjr/v7olvDyzdvcSahimVXt9JBMRAGJiHDCcoB6MfHigwp5jnzWXXwmQmERlfwxrM3uQh2q6vEgoIluG57L85diDaks86PhWxBnoEQfiSMBBJmgTTorG8g2qphGev3Wnh4O7qm/XkriVh5b51Ig67/OpU0lHD51f5lA6/yLa/f7tx9iMQKpijFgpZwO0Hw5438lDvQQXOZNuXfezVQ5A4ho12lU44w12KPyanC6tOSiWMA2sZgv5MGSQduLT2bfoxGHSXjwzrY/rkh4ta8LLh3wSu2JOcjoerq9x5OXQef3SdRyafArxnvMZsSgowGTXgHzrAK96C21EP2xUZ++FT8kf1vU6CJ0OOjYwkBqOywcBI7ge4ZhbO/PegSgJrmiMU6X4cQPXCM6j0UPzMf0aOjHkk42ZnWs4qEXEW/T1rgex5i89Bw5hdPfJxKhDQws4NwrhAsEHXb9wXBf1G/pNwk32xEQo+yOOtSX8qKKD5GjWAeHNJJovnicoghh4QwL6ADlK/LAIB+ocxT5A7QviyyGPHLwgfNI4Pc/HyX/NsouvnD9lh4ZOtGOQDPzqL0AUdBMyHBWIG8+NMyVJLZ6Lw9LGbVUa88dv7yuxgj+FqLXl2nPCo0BDwqhfVlp1owNLjWNszKri8IxPLeImpPEYiTcQVGi2osmOyHtKZP5INF8BstgnnwoD9szKX/hgyq02cDRfa8xrM1w2HoXPKH7I7PRGb03BaXu1spTMb1SVM/rbCCpg/+KRPvd1eJm4QYF31ZB+m2x+I3nsUlcEJFYvUgZCKieWyMiLgTMJhk0ykLXLT5YgfTMS6CW/ExDJZZLxVT8pgi4F2OLB/qf77W9tw/T6s6Uz++fn8wWWqmc9W3pw7uVUVHxmegw4nbBOT8iIpzwRWvqG307ty
 pK3M/gHf
 bpslrn3/Lu9NFssIOwHd+Dm7YrJVlu/nypR3tQpLs49PrC2CoECPrNKcmpexRq0t9xCR0F1T3nXNca7++lsAOGR/L6GI2OtG5ZTcT2ScMGJjkTVFlvjDL9+LcuE5rWpsFkjv+IpinDGfSVgw7v4aew+UcqJzlNWrFtNpPAsAA4xUXHEmehpXyPG6oCvmkVjVEvNvIMgF3Ys+lxqg59YpFQLT8Rzvxa6ikwCsS8DgX2X7enbNof9U5ySwkUrMUzJYA6TG43kH9WbHVsbj3n+PBvc5XaG05bv+GSoemiW+SwevBIoiHYmLV7fZ5624+YXW33emjshg3bm7jjwj/+DM51
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

Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Reviewed-by: Jann Horn <jannh@google.com>
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


