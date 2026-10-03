Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F327CA5FED
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A59A6B00BB; Sat,  3 Oct 2026 12:40:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 856906B00BC; Sat,  3 Oct 2026 12:40:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744BD6B00BD; Sat,  3 Oct 2026 12:40:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 529CA6B00BB
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:40:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E23F61A0990
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:40:56 +0000 (UTC)
X-FDA: 85281879312.17.6BAABB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 20F98160006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:40:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SrbuwHRI;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cd51q0YqcZD3kMNPNmwWlRDjTampzb3TxekAjjezTro=;
	b=ATcMgCcAnbNm8W6SoeKVvO1goB/nxaNVIS1eerWMzvnBEMld+NN334gH5/NZEGgroSj3BE
	OhYgSph6kf1QckHTJ2C5p2BW71AlyWo/n+xuTYRs94hb9FHZssx7ur+k0eyk2L7vBAiegM
	KPIJaQMTmiShf7XtqzRuIFIhcxIZUw4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045655;
	b=wKi/ULi3Rt1SPqYVaAZ9VZuaESpmG5QWOET1Uc0XZLzxICQHmsGFOYRhFcP0CBdP1YPbkK
	r/i+1YawagfkCeXgZLyM3d9ztu/ijbIfpTLZABklngbI7FIB3gvOO+tGYmkYuXWMbjFq1k
	SsWN+cjkvXzl1YWWgDDZD/ZFnL7BiyI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SrbuwHRI;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 684F740388;
	Sat,  3 Oct 2026 16:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A8C1F0089E;
	Sat,  3 Oct 2026 16:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045654;
	bh=cd51q0YqcZD3kMNPNmwWlRDjTampzb3TxekAjjezTro=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SrbuwHRIYxEfxoNA73Hc9aLwxpyO4wa3VytMnrKKT0ogwAMXDtOcEd19ResTM9evh
	 yq5zbxBaBXi4w4cCUkCIPQU6jnd6mfb6oZrE8whBUSdIBVdXnqgB/u0yWefOEseUCp
	 ZI5pT/RUHPnj0Wki5mXTPGBFUMS+bJD4xQnkqWOBy5nCEG7LbZb6D5FWVEDttEhON/
	 SgQlzGs0R0HaskTbefGB6ngjaKnf7gJl54GfusIWWMNUdFpfrbVvVCJezbRmFyZzoV
	 gt1vuNt/Tw1iZ7QDCJCz0yOBCZF0zrV7lFrE/nZ7OHCn5iA5A8b3cKiMMFVLbsZe+1
	 V1Snn76bVDpIg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:53 +0100
Subject: [PATCH v4 22/38] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-22-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2804; i=ljs@kernel.org;
 h=from:subject:message-id; bh=U+Fvh21D6vVW1j7ZGcVbD3eppigVIEPnTy9IGbcU8z8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mmtev068JDVxMsPvhqHFxZOXLvIN28Tq7hr/dm6L
 ysWvU6/2FHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJOJsx/DNmcNGddk1p1975
 j3VVPm69PVGUc5vab4uwlPbdm6dEZ31k+O95Kfn7DQ5ljRxeszbfM9u7X30sCrbcszR7wtuj9to
 vy5kA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: d65ksbayeigqeshf1dzn9s7xeqfwtygj
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 20F98160006
X-HE-Tag: 1791045654-137259
X-HE-Meta: U2FsdGVkX1/HIdPtqpLB2vUj3XkLWNy/VPHB0hHGujbBtMZW6lcXjgo/5DGM7PC/hYUr8iyCFqLjk7mCfC0viid6aGZACj7mW38y2k2P4UUPKUWKj5Ws7YEAxul9cj2btueWUG5JmorqUtcP52QN9umzdK0JUpgn/0rD2Fa5fJeu3WSReSqX6T2GJlPTOvgC15S8X2rQr4KSbiyeug3qls9/QyqFz8Jg5V13gXanZ4e5Z3Y0xp48NU4T9/t6az7LJcjrGWemvcBuc+XibFSFRCs6taJuvVB2qPZtAE6342aKriE3sgAr1NJqpHhuUAwEsFx3N6uZ5LFxqkj3dc3+ntvzN0i/xzhklOheFfez1fKZBZWLiE48Y38T836b7k/wPMOP/+guVXDSZ3wnO1yo0qjJAGMPDKedYXAH6Msmbzsdr7wtL3J21CGjXcwnth/C7c03ESp82eYn/HIEwW9nqXu9y+c7xGpXmwAZy/Xo1DW+ajJ5dVZ3+wFoD3i9ddd3dxJF4sn9DUKzxvcz/d7mgf3AUICpA/Pz7WH5K9FFn2W9Oa7CFJDjKIe7Ma++sXmZeIs3Wir9yTNJe9E+iowIDTzTVpJpkFbRDlvIjJ6DFm/tR/X7g55n6dk/CBdmge5rWoR1oLA4yl8fJOZIXKJ9D88HtyEOLrFvTPXppyHTMKKJLQtqs1ptrlX4Zi2jmEeqjO//t2tZTdcbEBhFN1G7ORncCxqKDZOtqeN6NUH7q/xqdAQF5O4/eHntvnIV+nWfo0VcAiRvAg87is+3OvamSMQTB6+WY6ZfRw3378+dbwgCy51UE17kZFcy0U6ZvK20OOKNO8K1UqdDHJJ24kQ/wnOUf+oWrYAPUTDje+fCo81kiCfVKjweg+qUOWeZchffROlFO4tm1DwLoysSqxKxfd6r8/WAHOF/HV4gyxCwerMw2XVgA+L9usPeCNEz6KmieWHiNAzXrY48PoRn81W
 vfiv/j5g
 mPcE5rZYPUTzjHxOiTx7XWOr6I5bZEsCxjwlGTEazwjrdnRh6oMb56vJjRZnyjcaxGVxCeTpiRH+k/howwwDgC2AXbVIY6wmT3lm76zOZ11R2ED2QDAmbHjF/FMPniAcoVtp9weZk9hHD5zvzj/1C5BoB+vX3OhwECVg5BvE64eANU3GnK5dBW2vylhV3MxSEBFGbceA4ULrlvDU8UBAcoJVsAKAu+ofwt5mWAaldE19zHyxtrbEbPvCuryTGb/8QUwqXeZ7HjCcpD7NTPPx5+4MluHrVuAnlxeSn0uJ4N+wHcYq9bsW3VNEece40cHLZv4ppyR6D6MEOQigvjl4g/+zGbroQPxfq2jjZbHAj068hXylNLu0tMOiOm3q0qZSU8OAc1l1V8ZBgsKzVBNmALe1Tq1OCaaBEr1Fi1sNbnGadYMwmaw4vQGOM+dTmVGtPdoP9AtfM0MXgyfrR4EWTX163VBFTaoEwMkUp0b/BZRDY+wfnhBWBHSPyR/hpy6EnpHJutAzAk/Vj0nCfZgDV1+/3c82OkoxEvqwwRmySA07hP9dx5d7f2pNYbLxtIlcMtTl98xpv6IN7AIQSHbM2Cwie6GRZFg3GiPYJ7wb8FMRnEIJsm2+NFzIF+lVXSvhMjW0GpGdme0+52NIDzjuWk5grbS8RxkToWEoZhkVwAD0CU+lDp3DVqVrJXRahi/DzNlFKJvZAiWbDsJpNbd500gLDDOg949dFi2xeqq0cD9bWgilz9ukUh/GDsKg5K1Tva6GcY4WfuM8B3UYA/mJyw2qAs0f49AZMUMoLLckAp0cbSp/wyptj6kwVSWf+08C4AuE7E7XEli9YHSpToRTZ5vLlFHiM9QqtfKbC/U0UQiB0XY/+ORjXK0i5nBznLOA6E6XkCxoepVMo24IZzeikWCtLXs825WVVMNElTqHRECou8Lm3lbRXTqI5zZmLdXqC48sybcrfOrbWEzVMhmUZAxoNdLbt
 DGofsyHw
 k5LF/bsG3R0vPbjw/9PrhOqI/bdzplwhKXB9BNAhs5LCIr4kPeRdUP5kCpQwigQJ5UwX4dSrmoTxNFuZAQ+uzMSUNCFIxA5/ZlBlV4Pv6HM3po3XZvhRGWR+FAf8T0QXY25vq2ATjUN9amCvZMRCUVbmj/hJPQMX8sxjAFqjZNYPlz8nAPMkOOMyM28oxfSXa+FL+BO+zAsCng4JkOvANGzKViPsCt97Bs7iiqpQX5Qhh/obd6ppXbIAzwD/Wtujm4XrFAYcPGXstnz7H/RFQFuUIO7PnnFualUYELX/tfNHl5Oqn/6B2ZRh7ECiXYlZl2s7uBFcj7thhOKBLRmae8QBUIsOKMiQ1ZNo+sjdwhWTAt0y8/BvCdv/QJb3rS2UjWhsqxK5hSWor0hjUpuEVb1McEPRmeTDJ69rxhCbNtNDLw3d25dZPx6e8LyFlXjtz4uzA4jFRrkbFZz4huHNX/yywgSGaIVnJYWYYOiNVbcuny3ZE77FIHLOpt/0tl/nX1Q4EqDeqgSXhkn+3LHWbZH6hyoR7ytyAqxoHpB0A4bxazfOBPswDLyh1ZqglIgG6mkO3SJ6npiQgi5ovueAyY3J88nXNmQ/FlEzBBWzo/6INJS4BKurG8YMtqg7v4ldOZcb5zY+n3s88+QyTWjBjPrOAr4GxwJxo+FTzr6k6mpRfsiDBIhNGe23TaXMyhmZt59tqpym6DnXerjBJgTOrKJGVxSC/d6AgfEgUVSquDd7USrFMU4TFxHJTZ3FDbUrq9+PCPxz/BB92zg4/8aDzUW5wEj6qCqQv2t9JWjmD5df+GppxcIfqaTfab5MAy0onM6QJezzbyAN5Rjq6WlKtYSr1Q6RpsXShhh6pUPALeD4Mg5eNJbzOOCRNSdLMYmq5GKPfoNNBcpTuIqSnen+8NZP6r4ASS2vtvAecGpXjq59bexsh//GRgdg9+cJ3zNne+KeSurSaeJ3AjpanFHjUvoxgNZVK
 oHcaXAJu
 iNKdcvxEG1j+bUS/f2XPMViMoeSAvmjxp3XPN/Zkv14r7fTdiHf5zQ1AvEi65Ka7HIUao0c97kOxk6NdLS/5mTfCxnYfYsWJSgkm0hbHtfs4ZnCmJsgN99udfTIhfCKOGHHf5b88etJHDXL8XzZPyVA9hOEIxYekHg/6D6CRHrOBpBox1ZadxEW9Tx4Ol332Xc6/AMSKOvYUet5xelZJV0JkgaCzteIrpVabdYQlbGtdTFHtTh0B5SGlWPWgY0i92czN5nUJHcKe5yUO5C9Teuk1XXyJzZQdJKPFiCjHz8mLaAyUIyyS77H4GAKJ4/1tTvaY/AKVIB3V2aGCUo7KM4KOlckrjMvyUM5/Br4/F9Xbc8CGCP2PZgAgMjuQ5O39ZPCKfarMi7C/Yxg8d0aamKxviDsJGnqiBxxjpXdyu7gmCd9LpmPxvYyfo1xkorUJBtBl0qzMzITCOFD8V4aqbILf8IKmEEXOMfrzVIj2d2Yw/brnJotFmv4DefkjHzqjv1YmiZqXJvg5hLDYnxOYDRlpOa//Swl4rM04aEu387nDy7hVRunlzeUHcS7jIR+c5qhMujG2NFm3Yl/DoSlZm4/MFNcD4bY/PswjpcZtBnt6NT4G5cI2mjHZKBeRxu92kTybXVQjh83grkTd7M5O4+wFbidJ74lK3EfhxCiX9XpJGlTm54X8jypFiQm0sSon/fnn3a6bmrmCiWSHN8oqvzGim2kN6/YZ6UBrCReLiMxczMGahPrTOLQhQf32XA6O4YT+IpNID7iXBG/30Co9OVxYwRvJy+pUMYsuIgrYERLzfjMOcDqg8yf3oMrxlytp8SL/m+m9l1wPbPYwXXMgBSfQk6ZPKDPhz9gqUNWa/U3F7UBjN38J5RevhcALCWXCylioMW9TUq2ZQTbRQrYzL2IXGtBK2cR3/pQ4bI2Ao3HJt65BFiHyPh0iwwfSzt68UsewlgArwrW/1q1YIZ7Bf35ZNtgON
 EqWlsJyd
 fM3DuBTVXRjbcBG7PeNDsG/2K0hXEahnK6F/NtIQuDxg4/9t/sj9gwp9nIarw8oCqq04jwU4lh8q2PMG790vP6aXe4+SCi+qFOGn+t3ebMmCgsLQkGVx9Rrp0PDq8D0XpE0DEChyjUNgfhrFNS9tpS7P8qmPETFPxX6rsbJmU1ZQ5hKJOXt0b0HeDJaz6nIQtCL2lroMEawUt++ZVpL2/hVIiqDVNKIf0MILJSC+YdVi9II3FZoFO7RLYfRmnVX5tv5DdlXwtttmGIEEtnTWFLmZSPU/7nnq5TZlx+0r78JtbKaENpVafA0Lmbjc9uLOsmYrf2sP68EajF0Y7fWCVpJ5iqWDHgDqWC8S2VPYG/vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently there's a confusing mess around VMA_LOCKED_BIT and
VMA_LOCKONFAULT_BIT.

It is permitted for drivers to set any flags they like, with the VMA
already possessing lock flags.

This results in the absurd situation of a VMA possessing both
VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.

This has resulted in mlock_vma_folio() having a very silly check for this
scenario to work around it.

There is no need for this - just clear the flags before invoking the hook
and reinstate them afterwards if they are required.

Nothing relies upon this being set during the mmap operation.

mmap_prepare is unaffected by this so requires no fix.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h |  9 +--------
 mm/vma.c      | 17 +++++++++++++++++
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 557e629db8c5..4ae08fedffff 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -970,14 +970,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/*
-	 * The VM_SPECIAL check here serves two purposes.
-	 * 1) VM_IO check prevents migration from double-counting during mlock.
-	 * 2) Although mmap_region() and mlock_fixup() take care that VM_LOCKED
-	 *    is never left set on a VM_SPECIAL vma, there is an interval while
-	 *    file->f_op->mmap() is using vm_insert_page(s), when VM_LOCKED may
-	 *    still be set while VM_SPECIAL bits are added: so ignore it then.
-	 */
+	/* The VM_IO check prevents migration from double-counting during mlock. */
 	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
 		mlock_folio(folio);
 }
diff --git a/mm/vma.c b/mm/vma.c
index 90fe6f0ee3b1..df2efdfa3805 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2607,6 +2607,11 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	if (!map->vm_file->f_op->mmap)
 		return 0;
 
+	/*
+	 * Driver-specified flags may make the lock flags invalid, so clear
+	 * VMA_LOCKED_MASK and reinstate it afterwards if appropriate.
+	 */
+	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 	error = mmap_file(vma->vm_file, vma);
 	map->vm_file = vma->vm_file;
 
@@ -2626,6 +2631,18 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		return error;
 	}
 
+	/*
+	 * If the VMA is still eligible for mlock(), reinstate any original
+	 * VMA_LOCKED_BIT and/or VMA_LOCKONFAULT_BIT flags.
+	 */
+	if (vma_supports_mlock(vma)) {
+		const vma_flags_t mask =
+			vma_flags_and_mask(&map->vma_flags,
+					   VMA_LOCKED_MASK);
+
+		vma_set_flags_mask(vma, mask);
+	}
+
 	map->vma_flags = vma->flags;
 
 	return 0;

-- 
2.55.0


