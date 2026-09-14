Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A8CC88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC5D16B00CF; Mon, 14 Sep 2026 11:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B762B6B00D0; Mon, 14 Sep 2026 11:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16566B00D1; Mon, 14 Sep 2026 11:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71FCC6B00CF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:11:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0A10140190
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:11:00 +0000 (UTC)
X-FDA: 85212705480.03.14C97A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 351BA140008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:10:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FdCD3xxt;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/cry2esgQFXzUQwTlztFBc0G/64MzNaSwhtVxa/cNQ=;
	b=3fo5nVxTrYg0R0LQdDg1hFsf6nfbgibDn990WXuuIp/DtuWPyIwZzsRVn5VEQwCcGqQIog
	kwVArxQVF/o5GIRURA+JonHYLi/wh4N79H2hOd9l2HUY4SQs/AuZlzKeI6TRXmjQU6axdt
	F1Naxmb4j5raYHo0OOOhVHAs515HSMc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FdCD3xxt;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398659;
	b=3BrdzRW8nydEtKEAOZm6J+qzHXcKRgbXhmAvUlDIeUFpxxU6NQn6HoO3//Cfx9UqtN9vcF
	6b6XSxIaGxAerxfgVJZYhBiQJbZ2sPQPZJd2BHQal7vdIojhBZSLqAnD+xvOIck/LYQyjz
	CjD1q5m8zMyrC3vof05eoI2r6Lk+qtI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADA0C60142;
	Mon, 14 Sep 2026 15:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598031F00893;
	Mon, 14 Sep 2026 15:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398658;
	bh=a/cry2esgQFXzUQwTlztFBc0G/64MzNaSwhtVxa/cNQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FdCD3xxtPtlTwHiQQZj8z58HOi9MkFw/LOjVgiOeQFJKApMbOI0qQknZWVW7JXSyg
	 Y6RanDJ6eM8vUgNBhoZunb3NfFiAb59g+tgGk6TaCH4zOyk4ibxTl9xCTU+/hLJd0E
	 C/wbD2IDRA8Lvd3J1H5ArrZUxT8hzAa+X03t2VlMg/PzDUUyE1XQ8G95pvKUn8stXe
	 5JafdDmyfGUOBkYvNJ1Shfx6uvfEsHhRqIyGn/RpP44hW38FVrHaMKQP1hXWsOs04N
	 0vo0S19ueYlfUjq6lqvUydfqN6RnhYccRmlVYJOgbUa3Quq5ILEZmZvkbkiamSm4fU
	 E7RwPVDE5T7zw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:45 +0100
Subject: [PATCH v2 25/40] mm/vma: enforce that only kernel-owned mappings
 may set VMA_IO_BIT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-25-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=988; i=ljs@kernel.org;
 h=from:subject:message-id; bh=2Jr9TGQDZkUd8fLzavPdA/40vMj/7KYd7/4/rEIq1dg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG+UVm7geFp/Nd4nyCOl4uJts+L3JptYjA76JEss4
 endw/q2o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABNpYGf475Q9If+v6fdCTSel
 /PnVn2ZuTjXccO52NZvg5ofeGZGPmBkZZgu/u8Ji1euQ96dtlu2yY0uvytZrCh/M0yyz2q675ow
 9EwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: rcw43iib9aob7ojrjsw4rawxb5wx5zh8
X-Rspamd-Queue-Id: 351BA140008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789398659-339711
X-HE-Meta: U2FsdGVkX1+rC5o9kcbu0FsE88+alkDHE+8g+oPgpj0e7GeMHp7VlvQOdmpv00KzCtwuKTIjGEDO57kBYFU+3FDIjiOnnXbVrLhEZd/n6p7kRTHN2QsMZNMYq26yoOQczMU18rU0SKQtwvUfATQgWxce7NEckbpupqvjgImYCGONSaJNCdAthwugoEpOXzaWUhmHEv6Xp4tpFioDKll1zcFrFD5AR610t9CS6eEetIJu/gFrunWDsEzxNVOUjleelb1zuufaDlVYag4SfMRHk2v3Q4qmuun8mxey+DXPr3iDeANUQCQH2qqizZKHpUYoPv6Y28AKdQUGd3io40T3w7VPAyvykvDU3Gy3sFQksELWFK/VClW/a6ZluGCeh/ix3M+dJjj3AJLyF5WLWg7/g15jQu00zM9+pWT2HrmzJ/7vLKoD99dQwEZvI9Wc8LLuGK3ODsomO2C+pQlldgoameg65CObUS0MzALQ3FMxt8R1z5+La7s+HpcNVGspr+S94kKaDu1FOQBNe5t/GVnQ9Awe1yhx/lI2ODFIFmog47iG772AI0c/1OkBHQplUNA93sK6qdkVwYj79cQtAdHUKVL07gJFjZ4xcxXKUWEqycZcc//Me3fRmTLCY7EhOzBAOUQ4DudvXnEYIrUyaQN/Cr7KTfAX4Rd2VidCx7qrqrZ9/9+CfrRd13hz5+FN3HTqPtnPFg7IqmoSZ6KUiVUjnjxIb2RmpOIcJvy67eVw/pz3LtxSEWZekL5brxtRN4NgLvAkrzMLOH51Ax5s6mwfZZpW7Q8O6Vpzzhe2t/ki57cAzfuyF52g4Sv4i/AT8Ee7Q11oGehbVf6dy/X8K1dFWlvByyG3vZ4PV2QHluh30u8Iexiy3OWdUSXVnZoO3UH/E4dk87H5czt+yPkVKlXhbwW73LyNtrEgCipDfHJ+yxuLFjlP0+eeExeMmQ1FZIei4U+o9Gug8e0U8QnD5j4
 kcdkGCwq
 z3HoTlDEk1qZSVDzPUAa/IbBkVXeHg97EFkQTAdGn1J6Baqk1b+OKzIjBXyIg8RJaicZGajO7F5a8Wx16WUM08NIJ2A84A1+l8cKH7iewH8VgCGB7Kyr2mVxczwBLwvMqTtbhbaxrRaLVnXYdWJGrh8Q37NlUtcmnAEAw6zcdQx46moQ1nBfui6OIbHmv2EtTi85JZSpFv+BkFUqucFq+atAbsJK79nDVeORqBGl5u9MgLIg+XE2ItmzV1RdWjvlVja65vFe+3HNo66FA7mkmzfQHfSBchi6pacx3mnKoEW/TXz8wH2ZoRzeMdhLP86FObFRz4s3dnY23chjV8ADo9hMMTM1IYUB5aZgdBaZsHAtZzUZRCRc2MAQDCVgtgXFntrGymlOx5u45b0rECl9qoOOfnTPabYBL7RFZ4lJ3S3sXPVm37zEhVF3LH27j6txVzwggVm3p2uPvz28tgdgkFfNVbrVm1yIxP3dADzsZzIuQGEmtA2caQ4jBMMYYXl2uJO5kzCALVS2Yo9seBYRt0ghsjvde+/aZXSJkzJU62B++M+Ka3SNqqcMIAMQQFPbDionoDE4S2LYk4lAJwv/KYt8Z/afl1AYoRcj3bJ7ancqhw4Lvj3Zy0gGfY4fyhw4aGMiZn6lQAGwpIwo0do09uV0HOzJv4EfnPok5f+auOtciggvYD3evc54Wh+gFeon+AtIeyf4kUc/qwyMX3Q3WwmToXqylxQhkZa637GLQixPc9FbFkFp1MlkLSJKBBg35KyPrmPM9BqokAU4cvdiIyNm7Weti5gE4UdfDyvI0qf+7FjTviXSSDB9N7ZfCRHRogKs/u3ytEDOCVk67R6jlHX7lcwvMuR3dw37Pd2gNrvX038xF6/fW3NAD0Ky3SRQv18mmk1bbzbotTlKjp73WBRkO4/cCZ1fuA1qFydT7QnL6bBvfy0wiPRZbIZlsVSoDHbvD2LrotOuetIVnYOMh7LZvRDpF
 huEVRefT
 v7oxefYGet4s22aTAUQFBwtJbrVBp2G9CaCGVefiqV3GOs5FeNXzptsv85N3xQj0yO2qOK1DpDN9oHQSx1LSH8wY+g+mEaMaoSxNj7808PVEMcgLHHquMmLFZ4q7tT/cGlzavQvVC/OqhhfCurQKyxSP1cfKeeM5FFZGBvRSrtRhc/lAu0VpfTKdym0Ez1izZTSPJethF1zVKFIaA0FSIY7tQoObtva+rNI7ADc5mngIJ+drnXKR2IljgtSpEMkx9va2apA8gTJw4OKxEqwaRQM4+Y6Q8kpSAFgrbBpYlvD4owQZ5bARN2oJv7gOUJ2pLWk32zSvLwCmL7lDe2M/379R1oEAVyQIeJ3wcIb8NUO8uaqzkGSw6thyvOu4tHp/4I2XrIKRL0hAW41+Apc2KUJeCetwGAjUr27zxo+5ivmIStsRD1A5cYOXhX09ZddncRBAZ4t2c2nSXZlOi1wDGIv+Lzq51dlLb1p2sCWDpMgywMK3LN9A5gdagZ4NynIwq8Q0GxHksy7HXyhSfClPBpmHHYjVV5rCtAuV1k1ySvZdSz1175yRSZKDw0aci2O2mNWIVGJiZFhOUW7gLoe1CCjJlLQUE/e40fHE1uQPYircasWl4DZl5Bc0gcpDWENgbd3dvYVc9bV80JGPG6TM+LMSpFbKB/kHfvAMSEijW4jZuhlOdA4bdCu9+SgEYRt76WhjCM4AMF9KiDpVmVoMHz7zSL0Rcmjm1IFDZJ1klwkYybcGaqsELzPvrAZpPnRWJGWmUG+JX5L12nucDfuWsHsSZjxkvqGSZd/S2Pgd+ukuWTCrsoJQx7IV0dbRvmQQkSgsU1PupfVnEx2QjCj2p4Dwf+q/WB9lYB0XviFbD/cvocn7Hu0HTNQPjqFQmmyY9D7j+rcdt9b/t07MJ+6nmCJI4uMF1NesNqs1IyNzVQgGpPEMtSNbicGGPy7TTiOA8ZsM5dspE0I4mcZaJmVfNXkTVsE6r
 dV0M3OlP
 UWwjIYg6UJM1Nik0bQzBS/6rF+MZuxf1TSldFvzoebmMzggK4NP3FkYxxbtY2+rJa6W2iHquO/ZtvEdZGOW0ZTpQFbMzkYeqrXQMKZRgLz+LuUPglPxUIjrwkd0Hya3BA314a4OeaMwiaFAEU3PmRO9ivzMXEKGh4EdbToFx5UhhmjFvRxkeuR+tFOcQiW2uCLv5Ug7IOhvEUYfhjSUd3dFxGdOEGbTdA/G9iwji6q8hpFmPnFOM0FOY9VIkqX06MVbSTHfICNUd9L3BmhsKhOah4zZvw41hmUNXl3LxExvbd1EcGXtkEenkKsBhAQstUJxGNmnIr7yx2tdOwtA+5sT3X1zOGSQ+gB3VaqsQFYz3xNKHNrB6wS2Jzu49AgHB5yPMrd3M1sHY1/rBpjL3MX/b38ziuiZHnpXOjxGZqSD4ampQGqX7wlbIXZ3XnLr4CmHj4uClF7maKOQL9Vs4hYii6JnxbjQBiOlCntR/GUfmkXzSZ7dAbFepaaLkfhQ/BnA0EFYcKI1K5UnmXvlfLzDHvXCuH8+sfrKqELXxSIRYC4PTedrxA2G2ya+p1TsR6VKGFnCcLgaNqINget2Hlq0dcqfGAWn2yewZMJEYm+cFtlAQeODpxJJRncVleb+HFEBRidfIGnuyTnKF5HxZewrZsYbzL8jTFg+I16aIE6LVuR9yvt94bdbPEkMR1opwZivGx0t9i4OYuBQFblMLuQkcnj2F3B55PxeT1TCgSvvfugQp0Kt9JDbq7qnxTiwPvMFkFCaAUoRLGtcM0SXH38qNjwhhKHmH3cYG5unYBXTvit1R/yidwiL63g30xZ0GzXgiZGoMQYdlAsJZpEfup/aYukQbniGAM12zJRgsWI1/9f1f1upghKud/HasaCBhf+qKn7iSYVuW1/vXM24gG4wRq9g+5U0gBIar0oqlOREUtBi5CWM4Sv7V9ga3Q9XDZcSm3y6ZZQn49JSwgNCtN48I8Wb4q
 FDMpDu8I
 Sn77Em+6WI+7DG8lAZpHpfVTlgUimJ759wF8LKGQ07CdRcMvMPixM2s5CIajlYEF2SlKWypU1LIv7R8ntFL2OVupPs16OX8hk9eDfwiGklFnwV0LuBIs61BiuOwhX5wR9Das2d1P1/B8p9T9+++uEBPmaKpsnhOydVOPGUNTFU6Wm69weOJSdCgxWR3Rvg+NHDxse4uW2eux9dNCRr/KFTydzzT4Z0jZy4/pCAQfaN0QblM6evmR9pp2zVCprqX1a4QaSLC4gnjtdlVZR/vocM0RSfDsS7eaR3vC6ccLcTUBOVR+yy7IM45dbuqGzoOBlPrqETycavvP/0q4PbDvbddY4qfVHJjioPPvrpGyOa6+91BwrraMZxWRYdehbzQ6TqblD4BK8pTi3iWzz3KSnXoppYvWaajp1apbJ4MxpQoTxLmwidQKPVzGOpmsoyH/bfM0TyAgFmcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It makes no sense for a mapping whose contents the kernel does not own to
specify that the range is MMIO.

Prior to this patch, all in-tree drivers which did so have been updated
such that they are marked as kernel-owned. The check WARNs and fails the
mmap for any out-of-tree driver that still sets VMA_IO_BIT without a kernel
mapping.

No functional change intended for in-tree code.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index c6ed04d27351..fa429771bea8 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2787,6 +2787,12 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
 		return -EINVAL;
 #endif
 
+	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
+		/* Only kernel-owned mappings may set VMA_IO_BIT. */
+		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
+			return -EINVAL;
+	}
+
 	return 0;
 }
 

-- 
2.55.0


