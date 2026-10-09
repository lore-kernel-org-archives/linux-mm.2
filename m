Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E4DCA9EC1
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CCAE6B00B5; Fri,  9 Oct 2026 14:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87CA46B00B6; Fri,  9 Oct 2026 14:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744576B00B7; Fri,  9 Oct 2026 14:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 507716B00B5
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:11:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D752A404BA
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:11:38 +0000 (UTC)
X-FDA: 85303880676.12.A29E1DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2E75D140005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:11:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a7/Ll5oy";
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=el2jCgXoJXHv+Kw12WkowqS11UrU+02k++d1dTT+Yhs=;
	b=timmeL/779oa6iHQ/2qvacQWOIWSPYx806BnYy14LDmJXeNzAFzrBZtEEb6/I5M1P/gxGE
	M2cBUJgTQ0veZdcITm4A2n4zraiZLjvyHoBvJLwyEOxwDk93YDNWlmw2SzlIHYFcmD+gPe
	ZHqIkJJuymUMd6yO/4Od1vuXUdUvcAk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569497;
	b=VCDeBy4KYnpR0VfSRZL0aNF+fSZNkIJLkakp0IxM0BVakTQ+0t1Eq2DTka40jUVR0aXDSh
	ft/zai892dS11/enwz25ZXw8cWKzypORZQNZ6GjYQ6fQsxMgK4TGx6Hzdy6A9uUxswRww/
	Z5U+Rk5thuH/nYX7qNTWbtv5qlZeB04=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a7/Ll5oy";
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E30EF60267;
	Fri,  9 Oct 2026 18:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F1F1F00893;
	Fri,  9 Oct 2026 18:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569495;
	bh=el2jCgXoJXHv+Kw12WkowqS11UrU+02k++d1dTT+Yhs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a7/Ll5oyWfbHwIZTdPhw1BCs0zSOIpXzIB9G2bV6vu5nmuFmsJ0pdb52fh9rABH2s
	 96A4dXiIvofjJLpaQ/2+AIypxGZsiKbNt8Nt9m/dXtT3NJbzAAX1Djv4PZ1enJEZvA
	 94IdhLEAjNBtv/9JhU/sL0NDsFQTy2/rrsErEax1jdpl4wjOUEFkbnCdHWqA8WVoG3
	 YHYKFFIlhxG2/t8YQBZW9WfvXVK+5SdPgQEJ9Hsq3BqUzG0KCpyJ6MSETsoXPD3p7/
	 LWpfPY9G0Op7qqbPkTrtpBd4BrvPufFypLL36yAM0HHuuPUrlE9cWWqF8S6rf6Y1S2
	 iU7TIPpkYAELg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:14 +0100
Subject: [PATCH v5 20/38] mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-20-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1377; i=ljs@kernel.org;
 h=from:subject:message-id; bh=9EZavFkFq061KOoliOxtk7vpVQljz+WstI3qyeYua5A=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6swJmNKrm3zTdM72XNVZ/SrFRSvX6ZhuzdWoXDDTa
 /apfqNFHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhI3UyGf4p3p1yyENZf/7rc
 JbcqbXLih1/8F/b6rt5R9ZVhLj/TnemMDHeE7BZvWvxIqlktUGvDQX5VHsMtLz0CazXNtkR/PcJ
 SzwQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E75D140005
X-Stat-Signature: gd9xo1hk3rjdetbcsz9rh8b8qkrh6ydp
X-HE-Tag: 1791569496-855197
X-HE-Meta: U2FsdGVkX19MhnJxTlD0IlxWo3lS7ndCG1isDAJJ+r2ovTONX6LgY6f1gloBlrX6NKtYRK12n4S1PldFbuwQONzX/5YZURDR2tMTVowK5Qe7mpvJTJ6/NHcDXm2trQOfPRmLpA5qHrOHKS1ArmHcKgkBiBYoaWYLg+7HNdtN4kCK1KdmVezGkHpPMcdqdH9J0er3Zx6CRN1QAmfKblqVD6KFNVIbc0Ou+BZDl6hy8Jmob9yyjn1boSi7sDfTCZGdhHL+Eyg4LErNjmPNTEPg5D63UX03YNKyMGLYqqXYqjZVZ8hBChgCFAv/hNp2f6t+WRf63G3m/itzWIO92NXYfReaBzFXGw/XNss4ulyHjfVt7NN5d8wbWNxY6Bl1GLPE91PInz4Yc3ZSahoeNoF6g9QbGlLWIBRQ49vyEJjug1jS3k8ExQR29VYA+sz5Buuayii/rZ0fuzJX2pRd6x7S2yd2O7gPHT8UvkBjXHWyneM8NfEOHDi7HOl+AiboL3Op1Afk0AuR+IPRq/3yVtxVc09hZws0MnZvqu0fTvdsMv759DEqza9rTdMc9r+DJEPtAZ5iyLnVyyQvSptgbhnemiExYGFhj9JZ4BK1Qq95tMAwScY1A3SJLceZKeCKdJAf8W+J3fBFQBwWsU9xTkvLMYC1FFzqWJBOBCRz74JOLBAeLij0AbnFC6tsLov0ldRnsry0AvoP/WvvMlDjU7tsisW+Urbx1yREFmq3MnkJzpObwConUtH+bju02TfQ4e6yAdpCFiAfC4S12UVJbOLHt7dlM6WC8lYM40cVx5CfT3UP8aZLJqQ9yL5Tk8cirVGeDaaThr6HRVgpijdkxDRWDejl9uSCjXbAoy8mr5PyWRUKGgetdC3v+IaaDiqIURAzihPAsCesKE8lSbIt7qw28nwp+qUElmJzLv4i+7JPvIdPyH8JvH2GhNGrDRVTsk2ePOjZvmNGv+VtqXFiKix
 Awkwgk8T
 2/H0lZaxZWVBEuApOA8brAmN8+OOIZv5cpS4Zy+KzGLdwpPL9lDx83eXUVb7GOwrPVqnwAil9Vh9DzQ7Vr6wtS0kV73cx7UzkNgM+c5eY4uCJc1TE/DfNOEIUt1o/gLk5GcHDufDaqEJlPVSzruZ+vnialga8DCwSNAxSCK+pjvNOMQGvTGrH4vh+u7JQmO4dJx4nwvzkwjt8rYAyyHmzLbC4K8DHHh81nmr3qtlIT72r9Ngr1kroulPOa4kVy6/7PrPEpRrul81vVOe2fbXdtoUt2mG2SgPBNpq8AfC2UjV5lqhOsTnaT7gtLhZoRCcDuO/Dr24RlJUV4lW5DBjKvhw9NS8FHAlZNueZO7HxAhqpe0l3fj1/3iyPusPrHzIkJRCLo1bCOK2uiFLcNlc9c9+A2S2SpbNxXK1x/tDHNjZoLFH8dtfN6oGCTzDrAiXfldbfF1VYnqB+wTzvXz0zCxQvApEokYH/BjJOW5sbKC92QwexIJmIEoqESqOm9ME055+zq8JkHqCl27HXlNV9dtfJZL4CmKjVAHPhiNZdtG1VNUZ0moPHcQRwEOUrOaKNreKmMGnUH2Oq3/xxGVahRgFtMxPtiTrp06SklZDWYoAmHgafa91jsAr79bij0+bbgvruGjauNak66n/aLKzz4dw4ONVqWTLxlOMLwZtqKKiQN27+YmMMpDkOet1XYC8uKWB8XEWXc8Y5OX8/3Z+537cARCsLbnYfTFixqi+3iFbkV0DGS/eCm3ECulgS0icpN2Mops0AbDw/sqMQijonNoF/3Sa7P5La+2l6uQ3Cmg8/EFaqyq2hVGlNPXq+H/8BCG/MCeA+i2QNRW7KeEJmMWkiXtlcyt0SWEcoPa++m2Q4PLjRXEBs5/3UnuwpqcrG+K6I99lSBoKYu6Qy0feV4q5RZa7fLEMPzgZazyHGXmGUROvbx76pIf3UT6M+Mz4iR9/MsSHBpBf56xGjJANAG5+BPXkq
 FeYrcnXm
 pNCWfPqTDgUkmWJBYf8etkJBCQ/b3O6nDZQfZhWpgE71A+b7NZAZheQhvJiI6USUcXS0G28G5EombxAyXQHRIb0Zlp5k3nKaiDE+al3RAAuEMpHH8o1XBkUqZVsedCKHmwtIHBjk9fBnSdv9FCXhYtNNkhYO1QyFZB1/EzZh1cAzciP7f/mBU3zED7znNVgAubtvctVJW+QOxxsE0W/ySByaOX/GSofvGIzImrqANqC8cO5WdJ2nz8XqROIS5GxvZ5D/9vfOats2L/fcOE841QYuDD5avwOAZtOihGkyQxaVJJ62DRQ2iIL3RdRu4dAjSPSqCBnb6ouAu3lnaNKK3hLgvYtZJeo1MSJgS6TYOPNlBThHM5OglTLX7trYCKBDDdAfqHOmfK+UAYsBw3YE6FIE+6XHcxtueg1/oDmu72U+jKD0a06vfDkNda3MDU5dGrWFM/No6/U4fssNi3twj5naJll20hZreB0eD98Alc5hwRtoZ4WbJDtREnTi4eIHz72c6x7d6zuYjZVWetvVYDtaIYSSYJbplGL4MTuI2F6mYsztLnnGqjsaiQC8tOReAQIdogG+d1+kYWTAyUOlBL1OdRyXNjT50sOBodlV/vVVoIBoGfmhbcpCz4wYEmN/42P3Sw6uOsjpdXaH2u0CeCs4dOKn85w66nbD5vdv0aSisK9LRnCNC+hTe06Unu/kcitutU/aWZN3/9wxzETuXNYZmLgQZkfUWPOJPD0HR0FF3HS/DfH+YbCO4JTD8sPHqJXlJ+MV5sUZbeYe/7Ta8Tp+DMEiJ62IX78mYhdKQCNbhSwx/xAgXt3sbXgIinUZcRHCDBhTpsyzGb7q4LuQr0o2cT7ORXr9wCMaLKyWxf8sZBuUNoeUBCr85AlWYIoshpqTIPnDa1mrQGBC+kjAKa5gliwLOCUd0EsaxqP1tC4EvcuVyZmvFApHsVfUmhUaPvw0TOpDLcF+i/VMYb35YJGrpIqbc
 37r6MKYF
 7q18G7Pxy8Qv3YO07d1yfiCwlB2zImXr75aXNQ/bcY9aPMbTmfhoUgdX4XpUAyqXbSSFWQwxn9VxX2lYnfA67JOqrtkF/xsti+1eJq1oxPheRsnl2RR5fSaD4W/BNP3lHk+F2tYf2chZUsCzG3cxP/RLPCaNSwIWAglqa3eZJhaHnT0kE+TctsV/vsf0mfZZxYJporMXtXUtnHH6pXi+lAuRWreF2+4UklSypXgCpYjGgbV4MbQLHXDFkc+5C4XXhddhbc3ldPxsvNnHSdprMPs+d5PSjlIXy93Z43aBonQ6JHwx3+x1IurHD/o7ozZHk2BlP8EZ92iWRQAMWSwtcWFDFi3mQYKmZ6e9z+jZ+4+gd2ChkdG+pYdz5O+mMKRyVrnbg6gQ1PwVdut+fVeLEKzPukmTCIjFur/OsHLFvu7TQ+ZyA2T17j3qWdyfmUMLGOwv/3iRGi7rLGxeV0cUz9JvZ5jmOW0i+yGepz2FElbDjIhiA1K+n6OdnFAcVVwt09WwvHJ8CnkEPJLECUOLuS6VItyrd9SEDPNWaL8r3arvfMPQZPfILa1EyuJjHpMlHyE4wqMItR6bjgxqm4Ki3PQpfOY+6+5Ohz/an8RHW+ZF54CJ+SZP+MLLyiYEHTtkEyIP/6PHOq/84qk4xyNMu4BvN7feVrzBpz/++DSQZCNLupGseoQS+WqCkq3G2GdvnyO18xKIzfabxBAKvWiSQo/dlz1qdl7AII5FUsp79KL9mkz6OOMiA5zRCUClbDGapZkk+XDAtj33+nU2KFrkiW9/f2IgzyFgtrnUHqxaMHUpKtp5WFLpdVsQbgpoBde3ceOW7OegG0jMK9ta5BMAiTBgKik6bGJEhGQdC7GF14OJHV6UaEp5X7+xKvA23bUbR6Tw8oloOfq+vWdvXOThmCps18bM2J6HLxofD2y2nCIjRWvT384oEzlQjGzbQBTUXZMJxTjcyUakRzXPZjy+ybYGRxePZ
 vcAV2CnA
 J6FG6JMIiVou9DkEmrTcotcSmnXgWXUw5PkXkRvAI+Y5li65CYmQQbeFWK9aYCjcpFV2oHE6y/XhU69dCLZ3WvvR6Hz8Q21tPbfAzcOTXcB7UL6qr3jP6e1yEhonbMB0svbVomMJqZH8IxJu1UL9v+W8IWLoetyGd+qIdQWsL6Yf+lbttf1uyfMvO7LMmw45EYzUpDliyVWmiv/Z+AW4hYWvsHgdswLou6n13exiopJTrftaoBAtEDYNpY2t6osIBpmGt+zGsnOWXx+deVTJibqTzjebxBQRKhUM5jswlZFIY2LV2QdCO1JGCNTKvA9Lfw8+QvYF0VhMxDaeT0WtiK/sCTRHnrSaoHh/IK5ajK4nb/pCIYTgNyHbRB+tIwyG35WvR6zk26e3x130cJVcSqg5f6tlXOTuctaQkEHg/kOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When populating a VMA range via the aptly named populate_vma_page_range()
an unreadable VMA will always eventually fail with -EFAULT.

That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is not.

All user mappings always have VMA_MAYREAD_BIT set, so this check only
impacts kernel mappings.

It is implemented specifically to disallow population of uprobes XOL
mappings which are exec-only.

A nasty interaction with these mappings may occur if they are mlocked, so
actively disallow this early.

This allows a subsequent commit to remove the VM_IO check in
__mm_populate() which otherwise requires non-MMIO mappings to be wrongly
flagged simply as a workaround.

Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/gup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index c2dfcb4744bc..e6310a7cc05b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1836,6 +1836,10 @@ long populate_vma_page_range(struct vm_area_struct *vma,
 	if (!vma_is_accessible(vma))
 		return -EFAULT;
 
+	/* Unreadable VMAs also cannot be faulted in. */
+	if (!vma_test(vma, VMA_MAYREAD_BIT))
+		return -EFAULT;
+
 	gup_flags = FOLL_TOUCH;
 	/*
 	 * We want to touch writable mappings with a write fault in order

-- 
2.55.0


