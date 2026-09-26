Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F27FAC98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BDBC6B008C; Sat, 26 Sep 2026 06:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D5A6B0092; Sat, 26 Sep 2026 06:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77E56B0093; Sat, 26 Sep 2026 06:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B87506B008C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:03:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52A861607C2
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:03:37 +0000 (UTC)
X-FDA: 85255476474.07.EBDDEFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id BA1D340008
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:03:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PotPzrZ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790417015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ti2172MLMPIXoYLD6wBNBUuG1vVW74lvR3yPAsyJ4Mw=;
	b=fHtCxMzY0f7que50qM8Kp1ihyR5ixUi2W4ZPw84nRjx4nX/d61kQc+W1NLBzK6fnneAHZa
	7A0LurcGQcVAnPXE9dtg/AiZu6Ux62M6jesxEtIpt1fPqIFoLdq96ZXPvWah/l32n0pQOL
	KIu4GJDnKdcyUAdpRSlu9Yz5ARK1y4E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PotPzrZ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790417015;
	b=qPVItrs+qI3FN7sil5Csv4xmA/nbk5H1gOvNZeHyUDmj8Wq80/j9NlmJRti7kgSNPO21YT
	NQBWPaSZPS2y4dYd7GCkXX7lfPlUnKhVgbbP/8AV6xI3fL2LXIqAaT29IL/AZdlPXEMg//
	ryuL1wprjAtfvAB7nBhwEOTc+6oF7cY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A5CD6021D;
	Sat, 26 Sep 2026 10:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F031F000FF;
	Sat, 26 Sep 2026 10:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790417014;
	bh=Ti2172MLMPIXoYLD6wBNBUuG1vVW74lvR3yPAsyJ4Mw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PotPzrZ5JhDcKjnjPPw4xklb2BV2GvKf2hehW5Y+mTu9Ze/h0GvM2oipY5M9D+/cd
	 NRSteOJJVQwOgJ/Vk7qXpUvq2TlOQEyc8ylr6ggIIRLBObKxZ+LGlahTeOSiW1DP9A
	 NCr80n3Ix3unBLfTdBkNTu/U313Twxe7BdIULH0hZv4+HKf9SLfgwohoZjpf9YbuDb
	 pM/4foaBcqD6tdDoCnbsIxQUPKUzkTKJ14OcpqpL1z9ouoHn3tA5tZPlu8aWNsTXWH
	 kG0V3eJydf9/vQZMEDvq3aPanED3H3sJB4bqO1nejPbFwjDnaIc7Dx5neGDSzNUBqo
	 N5OxElMlwQ0bg==
Date: Sat, 26 Sep 2026 11:03:02 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
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
Subject: Re: [PATCH v3 17/40] mm/vma: add and use vma_[flags]_is_fixed_mapping
Message-ID: <areX8JFWf2gJLVcf@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-17-4583d8a23bca@kernel.org>
 <DLOW5O2LS4KC.7BAL5Q24VJL@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLOW5O2LS4KC.7BAL5Q24VJL@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: xxtw9speodbyat4s43eabkzpx397abn6
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA1D340008
X-HE-Tag: 1790417015-449687
X-HE-Meta: U2FsdGVkX1/GUDFu98xSTI8lKy7S5xnvBF0TNF0b4xGlk692D0bdH0hk+CjyenD2nHimlLwW0GgPPYkZoCEGEgUM5GhHslZzWWMEaxpFqoNkHbDVDYv0JkYFrol7a5xEBHECcNqB+clf6Mqkm+5IV6viUVKv4KxjSWYc9HwLTsj0cv5OprwOk4WR7q/CZybGKpqOQSHtutuHEClL0C5yd0dsc3PVqyZD4vqWs61HssS7MwHAG5iBlWWEHPDieAe0xgvFXKFNvDnOio/v2DlsWBTCPGpRvHC63uepZMM/Evyyrcbc1B/+shX7HIbQLLfOT8Rdgv0Xgi9yHUHkx903gaM7BsjSWdeiI0FkTtM7xpGIL7WVNW1pGwaXlpvmX5UM35KpPZ/DnfHxkibDcD9Z2EEkoeYwA9eSZ851C03gJO0QzD0PJuPh7nYYnS6ow8YTU5pqsXu/pkFxs0zlujVrAzYZJ3S2ZIUSGk4v+60gFAVhPheNu6QjnH5aC7C8RZrbRaCeTh3fwXCOFAJxQoZN0mRVFIvv5jpQGRLPyPfl6hks9Dh178m74BnfIcCsjqY6FS/r0P25yu2gzGOfv2bJlV4hvpbP8nGJ54ccE32Ez0UPt9XnJCKRo1ObghUoQ0z2zkNmh5E1mwRFUhfeL/bIzPJ5s8gRV9/2PoU2T9f8GSrqM0R2DY2LHR/bhaG1BMfgDCuzyXYRK6rpe2HZ5nd64B1stNQQBJIelHHXxbFxUFNnLK5Sz8Q+VjyiM2E9LvkRQMz4qojGNekRPi0pFhts9/Y5eWRflMC94YvTDRwKnpCDP4AjgbcZF/cbNvC3LHN2HS6DUiSKtGH5PB8azxLdVvWx1RTL3eZvECn1LhH97l30cZaoJSS2gQsob0ypm/QRVGYTSvzOAKXqNUcWbqDi+J5wZDt+A64QDBpWRhYl8vLaSEhe0bfmEI/OfNGnqghenUEo9LHbK15TBGvhkKF
 FFOzmdfW
 7u3juWzgyb7GRWahahL0dec3sen/DWTlWughmdZm2t+iuAa5yt/E8BCNr4kY6qaannvvvy9y6YdFiAYtonAgERv3vNkH1wYdlC2+WZp8AeuU59zb96t8XCfGvEK0gKx7kri0LBXb8sLV0pI0tKvv7VFh9+BPSiNvy6uYm/l9EDwA1SumnuyAfAvfZlzItEh2EDUNDUYc0RjPCBpcdVxu1gLT25KZwZXRT7GAd/gr2cYXDZJx2/4T5KcZJGUY1HsY4oBpdkkYr8gBICO/TpTY2Zca5SwLYNGnbPG/WhcuipQVWxiADUrOxcU2WU/e2oCunilS6RkIQbRXlBUDVTG0ScC+JHOUgxwsacUYoWYEPboFKXPuyu2E1wJWlLvod53Hig56FoeCaCcNQhT3veUJig37EyeKSFf2+qgteRBf4saVk7GNdSY/IvCP2t46j9Zt9e+m8wgfSBeb0YwMxOsk/F27ytCU8DRaio27zWoWaZO63r0O72fdwQeebOY2wxoOv/ZtJ5EC1d3AeLTAR95UK7JoYdlR8ReCoFrVnrQYdtnT+fY2xEolCQgH+cpvbI1k5/RmDEK8SgXAxznoYKZ2x2rIynywDW/2ZAPyswEIPnC/MnIZxYd0YzMvW3aDBRshY8dS7yENY1CNjziUF5MNsHBJ6LgNqYB9nlpVWWm6uXVjCeVWA4C75EAWQ2MY1Hjywaurwx4a1beRfyKV4336dxBmwpKAKkvvrA5dPmbt6lrR1aduBdusvr5gFCzcNVQ1KUdkw06KaW5i4Uj19x1RGIffs5v6AQLJNHrefrdiroVdrXkwS1pluOVz/4ArUBYV1XAh5vPPhU0RwI2scF+WidWgt5TJ2RkzwXUCbYIYvvYkuv4uV2Lyd0egiLBJwPvpPLv+A8oV57N4btU7SWj1HqPdwyFVVm14PxwomGD+RLBjyybUKU9BkabGwP5G75Vn1msdodtedYevTiZjmqA1qrOmrYP1D
 A6n30I4M
 pgPCK6fBi9hQDYEPWOyWaAp8FfJ/whgAksq9xl7dAsen4J8qHSV0NBAaOkMvtqI967XYb4PQ+EO60BAy2mga6iVYBifKHkBcBt3OLlqY7RRsZ/Is5UCfPYcY6nvTrIlufIDp1NU9PLGUaJ6TvTJ3OunFPyVrUlxCe0M+AxmTG63F6rSV3QxRpN/VcgxwGzonnW46xy2kz+uRkG5it2u9KZtfyy+37vWfeh6Tbrze/QF7KDnNMten+2hTjUweX3k8t/1HzAxGQ0Lvmu/V5CrWjx1zma+hjIHI1V/v+8dLUm+bjBKHWeFxR8bDBFbXoZblrA1rSaXkKfRtmRSqQFXDDm8VmIPb0Z5b4TOxG6fUC6UfgbSuUlOCX4pN3Tl6kkC9nK6/dBs+GD3ep3oRWcQ/Z66RpbPL7M1nWOJ6RDRsFU0mTBCrAOC1JmzM13oov8u7CYj7boCDS/C/i9MyF9rl+LMbyYKqNVbyWww7ypDgVNe4BFNF+7ubv5ilufxGBZ4IIx3DTZnDKLUtx4Y8okT43DTXiq92NL+FYj/3/DUljmB5rakK9dvf+5u6K9JK2xbQIAGWr8CdQ68gk7XBKLTeqUuqrQlAjUKcM7tNDuiv15/HW6Hjj8MhXD2S0ZNi1xMK2V2XiTkFKtzvuWV2DZHbWKe3Xv955Qr8n/k76ittbtff0e1rKkadPdOSWlMmIS0+u0AeBlQvBNbDXRrTKuCGTVJ77goBT6OsiEPQl16HWrIAt827cJnRk7rqBRGIT2xWGuACcnX4NMt+bJDhwX+b4kWeZAtzgXh7R+Gnyrq1bZkfBBZtEnLhl/pu31APohbrr5YGX2HFQIkGVVHHOlpsYWBwrSnQh2rsWZ1QgiyQ3zA4yA/vjpfu9L46sq9HVpZfbCVUfpvQFM2qCqNuRXzCHJGY7qVfGraURSw5pJAzI47C1WdR8eO3Cj+xUeQpKG2ASY1fL2yU/bCMNAnEIOV/11IgviSWK
 QujeT7uc
 YOsOU7F+NhwxS9SZcu4BxLa/9XoPX53P1snVVEXeZZw9xUWpzgwvZ+EoB+6zg3NHksn5rwrv1gp9H7wxPYF0DmcgwK7uCeGTD59NImGMSrRyRybmwvTFV8rcejXIj1Zy/G4kgvTjfPy0m66vUNavbKKcNkzEFHlWgp8FXum4isbeo/uROs1hNJ3UU6+VIsobFPFZjuvJITFyyjWmNqmbyFBc0O8olkxoW94h+zWIKIwb8XdvhTku/0HYeectLEgVIvonSF4nYcI+jiEW+OuPUoYuavnIm5LGwU412MxzrdcXlLf5gLzRaQnUAneHOtMbJEP8V2Ep9j6gOWTnP84Mozdy41pfMKDVJo/U4zNPJJqVCfC7ujE4sWVyvEiR4zMTx1hDp6uVpxdHBD1jIJrCckN6uMukwNMJvgJJy9wcMVfMUiZqwydbDat46axx5ETLG74OzV1bNhuJA5WpBeLHB0wI7V8D/ic8lwBCsJ4r9q0FYBiNGBRqv9Ow9j/Fe/CbQQIrbnNMyX3hSPc0LYX2qpds267xaXINpjOckVQ9jLAOcTC3FUybxW0S2SDlpe9ZOe1RSCEwZ6pgPQlFHsAC3utkCCMBsB9+CJaAsQNa1y4y715DTwAX8Ct2GJ23No+6cGbkk4MlsHJuQR3MTqE6nSN77fpE2GOhGwgJucr3PDiNbRyOIT1FjvuIUMIS6+f9PmiB5lg1m8YuwN6dIoRABFP+FsY745g9Yq46oR+NncYXq/uKQkHy46h5Ruc7HsMB2R6TMZAbJUwPTYy9Y9PfEdG2N/E0Tt8uCpzcTVxBTEO9jwxZC8LeGx0rMJCQjJuaJCUKYwBKr5iHuCDJYNDuBgUEmNM7MX7DBsWSwSiB7zXScbwIhcOQoy3EtX+5eaT9tv5q/dzRhKdeoc2i01sL0GZ8Ba4rbyYno57ZSOJAy1n5LPTq5Pnee9dzChoHpWb4Kcz/DgmKcSryQEzFgjxaWKFYsTKLI
 bycSn57a
 3AkXm6Il9wiPVHM1JdLpeFQklFl9zfkxZ2t1Y7Ju+EAmOYOZIa1R/uHfWPzViQXj9aIPk3xoXFKajicCKfROn8f205aKeAEDPlfHKTPzDL32ydyEhbygEkHrrPN6nz2b80jk8jiy0Nr0PVLnEt3rxFmgr9LX+gFRGsiZLv820BiYeneIjryPZXSWC9QXHMXEzFJhW+bBDrP7BkalnW/IWWOnV/ktrkmEG1FsU3j31UNwmKUt8BzzgsQMA/HjCzLPPe2P60RHZwLUF/zx6N+nUPwcZ3lYXjpzKqL1MvMxflrzJ6Ov+rpSd94+PCW5QwcI4MKHA6uwZCnZqwTwoxsFy8zRTD8QjV1JGX3VyboS5Oa9hJXp/Lo+IbvJ4YfZ6L/2SI565jTRO3pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 10:27:15PM -0400, Zi Yan wrote:
> On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> > This determines whether a VMA cannot be expanded or merged because what
> > they mapped was determined to be a set size at mmap time.
> >
> > This typically refers to kernel-owned mappings, however VMA_DONTEXPAND_BIT
> > is not reliably set alongside VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT, so we
> > must explicitly test for this for now.
> >
> > We also explicitly test for VMA_PFNMAP_BIT as VMA_DONTEXPAND_BIT may not be
> > set for VMA_PFNMAP_BIT's despite the one implying the other.
> >
> > Use this predicate in vma_flags_can_merge() and in check_prep_vma() in the
> > mremap logic testing to see if mremap() can expand the VMA. The criteria
> > for khugepaged and MADV_COLLAPSE eligibility in
> > __thp_vma_allowable_orders() are precisely those for mergeability, so use
> > vma_can_merge() there (with an expanded comment).
> >
> > This obviates the need for the VM_NO_KHUGEPAGED mask, so remove it.
> >
> > Hugetlb VMAs remain excluded from khugepaged as hugetlbfs always sets
> > VMA_DONTEXPAND_BIT.
> >
> > Also update the userland VMA tests to reflect the change.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  include/linux/mm.h              | 39 +++++++++++++++++++++++++++++++++++----
> >  mm/huge_memory.c                | 11 +++++++----
> >  mm/mremap.c                     |  5 ++---
> >  tools/testing/vma/include/dup.h | 16 +++++++++++++++-
> >  4 files changed, 59 insertions(+), 12 deletions(-)
> >
> <snip>
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 4cd917f77f3f..4d0acd9a1099 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -212,11 +212,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> >  		return in_pf ? orders : 0;
> >
> >  	/*
> > -	 * khugepaged special VMA and hugetlb VMA.
> > -	 * Must be checked after dax since some dax mappings may have
> > -	 * VM_MIXEDMAP set.
> > +	 * khugepaged moves data from VMAs once collapsed, after they have been
> > +	 * faulted in, relying on refaulting for file-backed memory.
> > +	 *
> > +	 * Kernel-owned mappings cannot be reliably reconstructed from page
> > +	 * faults, and fixed mappings (including hugetlb) may not be marked as
> > +	 * kernel-owned - precisely the mappings which cannot be merged.
> >  	 */
> > -	if (!in_pf && !smaps && (vm_flags & VM_NO_KHUGEPAGED))
> > +	if (!in_pf && !smaps && !vma_can_merge(vma))
>
> I wonder if a function alias would improve the code readability.
> Basically,
>
> #define vma_no_khugepaged vma_can_merge
>
> or just make vma_no_khugepaged static inline. And move the comment to
> the function.

Hmm yeah, I'm not sure, I think given it's here and commented it's OK and
avoids having to have a special snowflake entry for khugepaged, so unless
it were referenced again elsewhere it's ok like this?

If it gets used elsewhere in the THP code it could be relocated then maybe?

>
> Regardless, this patch makes sense to me.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks! :)

>
>
> --
> Best Regards,
> Yan, Zi
>

--
Cheers, Lorenzo

