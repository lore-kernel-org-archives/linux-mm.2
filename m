Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A577EC79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD3DC6B009E; Tue,  8 Sep 2026 16:14:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A84386B00BA; Tue,  8 Sep 2026 16:14:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94BEE6B00BB; Tue,  8 Sep 2026 16:14:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64E116B009E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:14:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EED6F1207A3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:14:23 +0000 (UTC)
X-FDA: 85191697206.13.0D60AA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 50502C000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:14:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1m034QT;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NnPPfuZme0NSkQHeWnz1PsLK7rAxCsSDuwDKuv1y3M=;
	b=b0Kya78e2b8TYmAL1WL4A/vsJ0KYkULrSxBYQ4S1v4s9qMFJEsPHSSLiquBCcYe0HpanNG
	0ez03a99ApowjQ/Bgp/g5PVSGEPrz714fYI7+BnVfOIirhFqsWs9Rv+uBUGT9IOD8x1DQ+
	U/h2egN9WvK8YvAoYEoMwIQl5Zw9gAk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898462;
	b=g+Exqhjz4+aoGWaNPT6dAK6JPOBjdecrFcsUyjSF/kl6I9wTWc4MLFV5tGp9ArYIoQmStD
	OHfQkstRbwZBEQHpQaJlqXOUKFVVu0nsC2J9K8U4UO2NvkQ4wrb+N6G790g1f1dsi/2c4M
	0smrflbwMSeaC2c4tYv7R1eLevv5Now=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1m034QT;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C1445601F6;
	Tue,  8 Sep 2026 20:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1551F00A3A;
	Tue,  8 Sep 2026 20:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898461;
	bh=6NnPPfuZme0NSkQHeWnz1PsLK7rAxCsSDuwDKuv1y3M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=S1m034QTgk4AAbMXhW3pBtSw4QN0ohxWlW4RNkxcLFATJ1xhyGPLecmEi+XMI12qW
	 dr3YRNGrou5rS/KM/JBBY7Bc1xloPttF8CkVagWQeY1UlWPXJ3NTTjLyPlp1X/u6Wl
	 cyN3WIw1b4iT5LLwuNxVGKoC2gFM0jgLiEn9U+AOIloCIPUiM7dNbuAlEF1UqVXha8
	 /YhYT64ERxftJgX4JOAg85vFPR0pBt5g3kiBrJtaa60XXFr9UgVRnB6xUIajIqW4Jn
	 uapeZWXKlMmQb3eCTGRlvsZs9Fwq6U74Qv7qPuz1OiS3EYPZnSyYwcvjVRz44fLnpx
	 ySKehVRKCbJaA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:29 +0100
Subject: [PATCH 25/39] mm: remove VMA_IO_BIT check in
 vma[_flags]_is_kernel_owned()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-25-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6787; i=ljs@kernel.org;
 h=from:subject:message-id; bh=iIAFxQZLJ9bbMTZzaHnO7LS3UeZ6tj1UDBbYm6l6Gao=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG6J5gwLWxnw/3LWiiVr+5dyZGz0NBAoqlfUvdy3Z
 0fQ3JblHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhI7EZGhnXJ5W/ECr8k/b4+
 by7fxG0/LGo+a1SpHzrh+dp3pQmPxjKGf/abVzT8+eotfOXdnKAjGZPfZU3dF9KQxu9xkbM7xNH
 ahwMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: c7hheimqh6a6jrmuzw31nqfknugxactz
X-Rspamd-Queue-Id: 50502C000D
X-HE-Tag: 1788898462-510313
X-HE-Meta: U2FsdGVkX1+bIEbqccGhg43DxjEc0eA8VmWgqaz5p21aVZiEZDH2YxTRNyZlWItYDolw0Y7FbWteHAshQD/y2wnh4pgCcwNbJOErx1E27F0WdXQ+LKu6/jZvH+Tm9ZZN60HfdFKwsCWXllv+IGi8OfHW6SikEYGnEGf8ebLJr2bWUCXvtCIeo9IMdm6XPhLtpeOwOk5o6AknGlFASL4KcpQkbW4hY1Iv8w1VY0tIJrPs7Jkq1oG9jDASh1kjnkARS8MsbuVuANq+7wb06pV5W0EY+0RUVHrXLeJX/HqFjcPVe5ne99yTbZjt4TyM+P6aZlrdf3OzHSPjWVwqS/3fX13l+izCMt7i1fumZHbKWU4J2IAkOk9mY90xaFLxXVRtksDVX6Fyp65dW1PZ9PejTp+namp/hj1z8CmTvW80hq091HxlQG84tVd7i7EglXjpDvnc6D/ncAsd9XfPaf+JmCbSUEqa5BQddWABLPWuDkXtZiROOfUjUEs049TUtWa/ldBeXRliMZhq17I2fQZ4LKesdSBZ+GkR6wnoIH8F6OgdMSNRSt6z2f8fKOWTPd+twxxrMq7dzyQ/Cf+03d54lRGFPaAXJLyvSNKa0i0tf8zYj8yzOdBFwIqy1crS55RefvgyREjWcLFnQHb++FGqShxthbYFaFMPF9jZXgrHiDfi9cdnYdiMq4ceFK6AEOUBq2ZkePSPImh4YUbT41Duu8RHtS7EP6Ch/NVkbkpTScquuXqjtSuqmMVjXxDV78VV74DEjL0/uD4+9RL2dWCgykFD/BsxPxEEYqtkeu4L71FmR0tF/vAELNhxSBg8mH3x8c3Srh1UT7n8CzKqs4GTGxU5beSb/oOV9FaOJVZk4JNv5A5oqmGmX/DlubZFB7ojuDIAR4607Af+M6Uy0iCWJxHH4UGqqmWYNiGw3/zOrM7QF07Tpef1XV/lYPtp4yuYDFxkmx20EAsZiY0Rrb6
 EAD9Dnpe
 RATfGywhETAdLPPDWwStaIru1NoimNQZx1qWTFGeR0kyFGWYK1to6A1Mm/yvOKWdz43GBraJSrZwIdIfleLh1kMCyhik/kGrvb1Mo7gddxeAJ/9P80OlFOqU7m7tgReTfjEGLYRtLA4gtmoBu5pgJFa8GwTC8GE0ERaxOe7PItHlwpy3jFamVFtLMQrhODWP/bV0cpqVBiXi1eAO/cFGUUTw9oGAKJfHLwPFw+UlawK9zLpIglmPrtHOaKSnOOcxT/gbXkiSa26NBmwjNg6eylysyWgxgVD/tVrcL7dv/T32oVy+NA6oNdZPZ/FT7r6+e6MAz3fJD0Q66X/4I2x+CEbnCHWRHUMXjwCgHk5mbOb0U+Ln0sDa9RVlHjtn4JSWxwYG2zJNDU8pjftbXVZyTWN/3TwhZcsuhDq9v2ezX38oMhg9VwLLNReP7aCAa4A9QlQTOQ/+JmXVqDXjyPizFi3tBokVyLFjwxvUXIhxY9RX7j71QVuRa7hmQebOalXQQLqqKjozeadZa6Vm9bZqYb7gdT81PQb71q5PCQf2Le+W+uCfOC/8Lx2O+4AURgfEshYpCXDdxCpdVwmXDZyTTHlFvbMhNGsGdp4pMDKxQIf67FbPCDfelX4vvo7MLXEF/PaWh5ZzAljMMCcKsXjrjAOcY1UXs0ruDH6Mwgy9o9ztwTySA0blQII2zSlxyAo0y0X3cwqZZzw43mgl/esg1T8W4ot2gQXaXRiMYvjZhsmhhR4pwX9jG7pbN+YJFWoYaVvTTIXXB+wyAEXq2ar0SnPy7j/GBRsy86bpkus2OdpljllATcHyZPNU7JagkKrMchzAWWjjoVOXjRA24oirkrOTNGHXp8q3iyXdFzpiSbNCQjKh58xGXbC/9DTmdUjdWF5tbjCT3Kg/OTeksk4XpvyXAdpthSIoTCfdRDdVIZmdRrutCqPLK5HUAEYy7NniZuWnD+vu8lREanI9XmYORnHzed4XJ
 LLX8D1Ng
 RTVqIe2fu5YCB5uFedqnuCK1xN2lYHLus2c6BGFaPXKYaFAHFs9+CaFEKG/3asI7uhJ+gpWGz6T17kpxcWDLqcheLBWijBR85/PiLbKugtNC+uO90DiM+VcG2FmI/cxlpRyPIUEZIm6NuEt/wIXMm+WKQdoK0vDmhA5QndSiBjNE22KBZSI3IL7gVDheqtTTgtQBqlwyEJ2wKZr8Kydn97dasuJgNjC7zSG44ze0WewXNL6LFdOq1ZkTibkV/IjbRBlzHpwIIhPHmyLLcNkZzeLixkH8bz3urqFsuA3rWpzJNstEwm1Agnb6ja6FbnyAhYdVx+xJkIBlk/N18rrhX+1p7X8/NTU8l17K4gF2Gi3tcphusqfqZmpg7nLOHfEK6R5AtZ9dQyqGfEIty1AUYQ/dkFPkXidBFzusdSJrOlcefseusW3yJaeIhx38yCE4q/1fNzyub2woybBhfVhPW83biG7pWoaidFyh68Tc1aKwjX13qCYTu/94kKG1lhO011yVhQb+Rvux+bbwLMu4Dv+c16ZbPXVq020/bsLHnWjdcEZek6Ogg4Za/O+ujuv/tM7awB1L2H56I2iTQH8VeBjHFEzax2WJjukGkZr3my/lW0jdDxU6tMZHdUTh0E37SfWnSwMUjdExxhxU9F2oWLPlK8ZRtWC8L8/V329nqE4oZtbQmsx3OPUKSa23eEO3n96d/aP8aK/8204NKC43VtslYcfjKNQiCCLEjs+LVhSzpRt1jId1Dxf/d/MZz2g0LPDFP2UKNILRdIPkrxwACkzzpbtkQEI1+mkCGVdR1X1VgaTlvgE8Ai5gX2inXuqzNBSl0pIKKcOPEC8luj37Sbo2sXemced7sybIEj10VOxKdlAVKhlCOKzyjWY4/OQUb1gfczB3q3T5lF79IZazCDIE33RWVhucb0qocH6L833RhplsZypu5jJLuHcai4Q1mg6Fp4jzRxo9XfSDQ3KyLMKdC23e5
 +oQF0/e5
 M5J2X75QZReG3vXt0+ispVcdx6vaNIikmKQ9giem7J/6QqYx9g4x/2Tq3P7MOd+0VyVL2QOQ6grVc884VpfGmENuCoGlmP0r4U1ElcLt7C8dZePJsLb+NPyE1A/S+RlQxNGoJONvmHsb3RtOApzaaISXK2hR5zjUW/fmskEk6DIuf++gif+iSSQab1zyyhf4+55ghDjFcBBvCEZ31uohqRkh9L8kCJ8Id4NsawJ5OfGJdmL2m0NHg5S8vGxDFV5Is87Y27UpPODy7hfNZrnsvyvMqA4IfqxhZF/l26kKP0lqMmyKxh1kRhs2+v9IOV7hLtlzTSvUTClmolovcmxHOlRm5v0vJa0P6i6n1i0rhsGLT8QmE4NIGUGsdm5DWr0EpNweYx623ANGIp9e/y68pb/8QbQy6c9K+pvDydIiiRuhZV4CrGTbfgdHgOsdGeU6c25jUhflYmRHtXNeywhnknDoZ0e6yDgQnVrM6YUjzWb7FPmjOrsp8M30+rSleEFa7V4L5qRBkn+U2921gRQVF7yi34UTg6pR/XVQk+gU9QIHVAHQYzKSWMqodJ3SFmy6nONoNrjC+rUqGKl1p/754fC5HPDNYFvXOiEtIcVlIQBQhIts/9linlj3h27p88bxYT0m92JJjzl8xC0anLsYc2cWpvv6BDssJZ/YfLOG3Tqa8uNNq7Wizpnwqsbmx7VmlbTKV8TpvZPgsdC2hvNtCNWGtK6Xn57t5XYAm9zpWoZIiZJXzO48lXnxNcuY7IPuNHhPijkVFHWu5uXXjsdtVqmA63EegDlzsWGBt6yc21bI0fM3HohYhEdi4y0bEeI4N6GDaXG/+tzyORIJj9D/CKIqvtIO+I/SmziBzCxFMy/Z43nlJ3gAYDZxIPbt5qgyiVCy5d3IJ417KISgK7ezCFPeOfxieo3TdhgytG7tF0oViZ6ru2P0Tar06ckQWO1IeKVsgFIrJgVpjcbi63oP66BhlEPZy
 kirRxZap
 9VuSsGjxZvXiYfCGhJnLBXi/2AT9+LImQCpFWPnLmxY0PCcj+YmMtUR9u1Eql8/XHGzlfei5JzbHGzu9Si8LZb4K4F0M0i0pvjCCdXyPHW87A4HDqBuKth2jwCyAJo/WEASNI90t3ox7hn8lfFYvKZqeQ1+lr/1r3CW1bkXjc4+OSBZ4lSWHv4nU/AAg35ZmO2IdgJxVW4PWK8idOeum7VHUj7Ho14J0J94BrAsGYI14+IEGMBVU4fB6VVHSJI73oPidN7DDtPHz1pefZRBUcnudIL3VvQsegOd69q7WfBMvzWJ1mR485IAuCG3zYudlfv4xNxRd/Wif9qzy1aX4n5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have now made it such that every driver which sets VMA_IO_BIT marks it
as kernel-owned.

However, vma_flags_is_kernel_owned() currently checks for VMA_IO_BIT. This
was a product of drivers previously marking a range as kernel-owned by
setting VMA_IO_BIT alone.

Fix this by removing the VMA_IO_BIT check in vma_flags_is_kernel_owned(),
and update mmap_validate_vma_flags() to use vma_flags_is_kernel_owned()
rather than open-coding the VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT check.

This change means that vma[_flags]_can_merge() doesn't check VMA_IO_BIT any
longer (which is now redundant) as it calls vma_flags_is_kernel_owned().

Now that the predicate means precisely VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT,
also use it at the other sites which open-code that pair, so the intent is
stated rather than the flags, with no functional change:

zap_special_vma_range() only zaps kernel-owned mappings, as drivers use it
to tear down ranges they established themselves.

The mprotect() arch PFN modification check applies to kernel-owned
mappings, which may map PFNs without struct pages.

NUMA balancing skips VM_MIXEDMAP mappings having already excluded VM_IO
and VM_PFNMAP mappings via vma_migratable(), so it skips exactly the
kernel-owned mappings - say so.

Finally, update the VMA userland merge 'special' flag tests to no longer
assert that VMA_IO_BIT prevents merge as VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT
now suffices.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  3 +--
 kernel/sched/fair.c             |  2 +-
 mm/memory.c                     |  6 +++---
 mm/mprotect.c                   |  3 +--
 mm/vma.c                        |  2 +-
 tools/testing/vma/include/dup.h |  3 +--
 tools/testing/vma/tests/merge.c | 10 ++--------
 7 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bca955941212..15fc4509784b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1630,8 +1630,7 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
  */
 static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
 {
-	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
-				  VMA_IO_BIT);
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
 /**
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8dff37059faf..a71f0ab79bcd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4212,7 +4212,7 @@ static void task_numa_work(struct callback_head *work)
 
 	for (; vma; vma = vma_next(&vmi)) {
 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
-			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
+			is_vm_hugetlb_page(vma) || vma_is_kernel_owned(vma)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
 			continue;
 		}
diff --git a/mm/memory.c b/mm/memory.c
index 8c9675451d4b..28c1bb7b93af 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2343,19 +2343,19 @@ void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
 }
 
 /**
- * zap_special_vma_range - zap all page table entries in a special vma range
+ * zap_special_vma_range - zap all page table entries in a kernel-owned VMA
  * @vma: the vma covering the range to zap
  * @address: starting address of the range to zap
  * @size: number of bytes to zap
  *
  * This function does nothing when the provided address range is not fully
- * contained in @vma, or when the @vma is not VM_PFNMAP or VM_MIXEDMAP.
+ * contained in @vma, or when @vma is not kernel-owned.
  */
 void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
 	if (!range_in_vma(vma, address, address + size) ||
-	   !(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
+	   !vma_is_kernel_owned(vma))
 		return;
 
 	zap_vma_range(vma, address, size);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d87..fe32fd87cf5c 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -783,8 +783,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	 * uncommon case, so doesn't need to be very optimized.
 	 */
 	if (arch_has_pfn_modify_check() &&
-	    vma_flags_test_any(&old_vma_flags, VMA_PFNMAP_BIT,
-			       VMA_MIXEDMAP_BIT) &&
+	    vma_flags_is_kernel_owned(&old_vma_flags) &&
 	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
diff --git a/mm/vma.c b/mm/vma.c
index 5996757d5aaf..eb2b4501a677 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2772,7 +2772,7 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
 		return -EINVAL;
 #endif
 
-	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
+	if (!vma_flags_is_kernel_owned(flags)) {
 		/* Only kernel-owned mappings may set VMA_IO_BIT. */
 		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
 			return -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 3fe40e0f4034..e6cb2ea196f2 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1661,8 +1661,7 @@ static inline bool file_is_dev_zero(const struct file *file)
 
 static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
 {
-	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
-				  VMA_IO_BIT);
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
 static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index acaab282939c..b26f1a66a170 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -496,17 +496,11 @@ static bool test_vma_merge_special_flags(void)
 		.mm = &mm,
 		.vmi = &vmi,
 	};
-	vma_flag_t special_flags[] = { VMA_IO_BIT, VMA_DONTEXPAND_BIT,
+	vma_flag_t special_flags[] = { VMA_DONTEXPAND_BIT,
 		VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT };
-	vma_flags_t all_special_flags = EMPTY_VMA_FLAGS;
 	int i;
 	struct vm_area_struct *vma_left, *vma;
 
-	/* Make sure there aren't new VM_SPECIAL flags. */
-	for (i = 0; i < ARRAY_SIZE(special_flags); i++)
-		vma_flags_set(&all_special_flags, special_flags[i]);
-	ASSERT_FLAGS_SAME_MASK(&all_special_flags, VMA_SPECIAL_FLAGS);
-
 	/*
 	 * 01234
 	 * AAA
@@ -520,7 +514,7 @@ static bool test_vma_merge_special_flags(void)
 	 * 01234
 	 * AAA*
 	 *
-	 * This should merge if not for the VM_SPECIAL flag.
+	 * This should merge if not for the 'special' flag.
 	 */
 	vmg_set_range(&vmg, 0x3000, 0x4000, 3, vma_flags);
 	for (i = 0; i < ARRAY_SIZE(special_flags); i++) {

-- 
2.55.0


