Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37EE2C982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2986B00C3; Thu, 17 Sep 2026 12:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB0F6B00C4; Thu, 17 Sep 2026 12:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 293EB6B00C5; Thu, 17 Sep 2026 12:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEE156B00C3
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:40:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 809858044F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:40:51 +0000 (UTC)
X-FDA: 85223818302.28.76E1B20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9A36D40006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:40:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gspn9qQ7;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789663249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1QRQ9WYzmW2nABpmD05iYHWtoRPkYuNGcAfZon3VB64=;
	b=sbZyIUca3nRW9S3QLn4dXoPnVgRCMOTIjCDbZd46I9ocgA3cVUjkzff3/TFmBeeNVGU+VV
	+dpwd+WRaE+Gi/Jha8bU6AGDMN8W8sbtro8x6xBW4+XhXjBhJlbny8jRza5nMOElzQ0Yl2
	XmAi+eNfRj3CxUdYdFs2rD6YSzpgfSU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789663249;
	b=toaH6t/7h4hBNWIbVVH11m8inCYqGbmHkmRX+rz9CD2rGh9S0zcPSdabtOujJMC5T5KCHu
	wTL/1HoDA2opzp5BBiWI2MROE4SHQ7PdSvFyWR3UoNks72h3BAYK9LHByCUxlRRtRCmiiU
	8kVG7CmwoPHBRRFnV0Rlez+Y37VjN0k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gspn9qQ7;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91F3240F11;
	Thu, 17 Sep 2026 16:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213F61F000FF;
	Thu, 17 Sep 2026 16:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663248;
	bh=1QRQ9WYzmW2nABpmD05iYHWtoRPkYuNGcAfZon3VB64=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Gspn9qQ7Co3hTNTbvqHEG4UcsqEuAaXs4WpY+IWArwLJpD+5im1F/7UjZBYzBxEFP
	 r6kNzzWv/ygP9N4CBTIF6SK4Me1N+TZ7kg6quLRtughmHxBkfXwla981QkTLotSK4V
	 PNjnrxnE7nvQlWvnL9nNWOrPkCRYAY+FZPJilWJSHjfUPF9+dMlR6D9G7cKVnY5zew
	 CY9et4FnP9P/JyfZel2Guas6YNCbujBjaIbwC7sV5R2ANs6rbBZryLjyMGMzIfInyM
	 67LHWbWvbSV5TTZ0+n/kZZXO1u8Gous31lF+kG/dEXbhUdNWe84ivAYvKYlYgwsB+w
	 kA8OssQfVfUsg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:44 +0100
Subject: [PATCH v3 35/40] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-35-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1176; i=ljs@kernel.org;
 h=from:subject:message-id; bh=DL5e220u7y3LwD4Eiaa74zWyGi+IuXsLh7IOYBtbckQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB9hLL35ff77dPnnyjWxyxtOXnb5+35nmharbKxQy
 6vMp54JHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIqy/Db9aa5weOsMxRtPrs
 HCqQHviv6mfnxF/xdR/y2ZT0lC4lMTL8M7Jx8PFZKXNRYHPiW8EVFv+upxuICcwLWyu1R4MnxHw
 zCwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: o1b76zrwa69xt7g35ahjipefr9w179z7
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A36D40006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789663249-737308
X-HE-Meta: U2FsdGVkX199X2273gKH+rB3Af4swxAX8CtTpmZLhZqmwjxcmTr+5cdqMH3alWGs60Pk/yzRyzIDi0J3LxsilaCltiU1oXx97p5tXs32Bl2L8vUO7Wk8Q9BNV+3siBnddhyeHoiBvUH4cWgMFKFEOb5p+1EbB7z/PSPiKC1ZL9R6nlmNsduks75HtsFDJqYcGaYi2kOf/kRvOACGs87Fr/8tTRV1TH6c9Q8ECmca5u7juXNcaj3Xi1Vd8a84q6UUpkm1GJx5bgt8IR9WaehXjMH81zZsCwrc8TQUvkP5CdlvISPYL6gGgwIiN4teZBMHRJLT++P/hU5IryqOEMzrsEmnOGdsqs/rpodBRE8GZkeMD86NIfp/sbVHkSOZuEIL9TKqb9nyQs8ZWBEMkACN5isjdWYefperF9y3Az91KTQA2PkYsVCAHNcYhes5tjPkgLjw3EcQmPo/6XY2ed0blaAVq9JwAY2L7cT7n0XoWSSSLCZzUwoUs95iE0KzPIEIdU/APselXATHdzdlwbma6JXH5wOgrX1lBQJ9DaYUoZ3J0LdIYq6GkGh08o/jvX1mhz/Bmy4znbsTWjVmWEdtwQPU55jRXFom9YdEYhUI5VfOJHkl4jNk17CZxKwaHz0ewgvTZPVhJ7mrVzdxRSQfUII7S/WnjtWEh0CoAlx6SFjp3Yaw1BMfSNKVmltEdJBlizfhb1ZBR9Q2YtBMhfN7d0EhYvd0Qx0ek9K/CBsZQ7dq4Op0p3DJWxuMrDwai5q9sGw3oeZ/8ZGcjwoGq3ucZhqKWjoRLNyahz/dhp+cb2Q5opeGnkGUMoN6dZofM6LGLYeERY5PCdFmqYZMC6pgRLQSaqFLDx3UYdr1/qHQ7QQNDDAXnqb10ENwbtxbK9EP+GA+gD94V+PBjjyTCtopFS8L00NzdRwjmNYjzFqEg4KWvBJ028gthn44SO9ssyj54FA+t7mW1Fd24NVH9Kc
 KdYhkAe1
 FALTaf3wVQb/7w3yucZR527EnBVRME3ZSzzDl1IBhBuYWrG1vRejCT/b1LqCzSZZygaVhsGND25dFV+N4dqe8LxSw8WIf81rckTWmpkzbLR30gulKV0X7z2OuReme6+U+AeEXErTEqMo+GekuNwuPgaTXbJpgEea2jo0xk1vSLz/wyShiPiZBFXFh0i1ytW9ZvjtuHIokOcRsfE34ywwL6TjvQb9Mm2a576p3e68GnPuMDWbt3jBGjuUP4Upe8e0UUaVDSIlh/AcTKt1SLJmo232boPECmh7Tldw9lsAdhXmIiNyxT880fZOsTG45jEB9MJq/mz7mp2DieCBjDpEucOHSTIsRnt9NQaOgGqo5W0LXqI+2FGxmSlRDVLEQ03eBhqolgYVSOGmIbjE2PlD6Rdh5i171wd/0H4brtsygzg0VMHujQu9JYneFfxwddjT+2pqqA1b2USCrq77OG7zlhtHrtgtrLgkyTh34FgqZjiyacB6aPeYA4hDVsh4axfb5dk3cHq4csPmT4x9bIOfiKfBPKEIBqRDHmAZD5yOu6W9l10gFeeZkaT5QtIBSF50EX3Uxcxuf2aGmelLakEOVijmUyhWRBjnXS3pUFENB7m5reFk/2BGiSFx1q4cde9yXadGqYJrk8+4LIosQWgopmrBHKSx2k8inBRIy0OjxtS3ngaHeAT93jBFVDgR0lvLdl8F0/Xq99pX/menihW3UK+UIhB0xPzD0TTJXGCCB3U1CZZVmMPPcjNEqfQE0lAeFDDfJM+eqKjw1iTfyJbrfmPWJnI3Du/b5WyQbYef5AHT4ir+/NY4aTyVhjMDwZfSI7Wz8Bbib8do7wy8t1xW/llMEDnOL6EzF4En9O+PNISSyuHfQzbTGYbiLHglfHfqBmpuaFI9TRjOIngmf2xtyOoRMVkW/3TLfvX99Vgxgks1KPfLlXUCV+Hz/7wW02nxG6864ccjEOzUQprsEWyblhGiAkr50
 SH8D6U13
 X6oJhZgCuKM2x98rzitWkVP3IqHaAGXbYM5V8db5w3XijFkCanZJKk8PzFQhAMzBr7lfeFVDqWMOEZ8iHx/5W6v4IkKMbpOo37ElnKqWwaNHvWPJ4XI6dZtWtcSqTAvRUBSEfAVAGaw2RAm5r9jK2mmIUAZm6YUk7N1UmBx8Yb/25xbK+Kc+Bb/Iu/5KHK1gcBfihRpfkt4S+6OZBmC8+meQxweb3pBWfXJz6xBIS9EXTym8xuxplBZQuvm+8rbxapDM81uje43/GKfPBUUgmpzaMRj7Wi5uibQPpX3oPbHET1kNRojLtJNn/Mw2Q//24pDcu0ZyTQ0dG5xA94IHIWRWooMYwKcGMkqyNfZcNngnJiTqHJAI91SpAE7zBdnGssvRsv8d1e3/F1mRqfytm1c6VhkPk+pUAIBnhEJozjzETkMgwHZjeDa/OVTMBTWNnZNQfKdbgDvA1zWCJ9f1bxDqxxa85NGvBE93dMjouuKJpABjGsyWMMSS6zl35UaXqNGEQMEp9IZfqZTXCwyWdu2vMZgNU+Kr90FYmuXumvitmzzhs/8yz2ZrucGNM5B87krU6/M3OUmPhIXA1fty3niF4gnHiO65zO1eP81qItq4DLGEg/rkLicb+ozwUPmzcK60EGL776GF+DXRstDPrasuWE41kmNmaSD9Zu5SfKerYjBtFpIHVMQ/9aNh375B7hr/E1/ld6cO0X4bNhk063oPvB/ec6QEJ6rmgCMFCP/npxHLrmCqLZr0aYrT/kF1L/2A/Dh6VeDBb1l00MuLljgGmiKOKiXmBTbaFjOpP+f50qzS5EcSQMptGvIUmsA4YIvU0Axoqunu00vrTSdtkeoDLamJq2QE+g2JZCYnY8qrAmKJE1cwtkq2iVVWjntRuOmRv8tSWLylmvgfs1nubej1IBjHtSQV9IvSRfc+5ITx2iIsqfdnIExZHazyZpUVv73K6tZhnf4nRl8qabiAOL9HhjM8o
 rv+Iz1VM
 OaB4rLRwbwBovmFSkOy51Tr3BSkq4PMND2H5hXTxKRGxw868+6mmIhtYulfNnNSTHV0u8FtKAneMyPV1CXTLug2LkrVfwdnrN3xYsfp6m1kw21Rh7h9SJjr8S356ezdrGWXui3d2kP6oXp2z/cEcpr2Fph9zXaMZQGtSf4vP7f7/i3DM0ri7X87lmgxpWGmywCIETAPaoZO1PJHS6Ay66Jje6nUbCSzRYBdJsEuiY95sGzEyQr//bLDPK1HiffbeVHZuzsDVt6JG5jiSaD9JdYpVcRyVuhdhJ0BFEeBNhrAgH1MUdRqeb53yWnXaaUJ6VsH33dHOnhyTir+eY0Joua++QW/egkYgXm51ea5oj9LNEMMLFYkAX/1t3Ei8zirINa5l7nf7zcURz0ezFYd5hNc80In1gNrcKfe+QiP6/2G3l25oHAf4t1XmkGhkvS34/YPk7pP0qq6dKoSjDGFExoPmDwqviNWmWkq1PY2Oi1dnxtTvUeXnle7ojyngB/mr+ykdZ+9vL672SLSeVZonG05BoBs55VxxxgqLcF/Jspk6sNGSCRXIUDDhui9ID+e2W1wDmvV/IonrK2XnPGgpj8CPYh6NZ7kUBj4y/e0gRDVw6FXVTd6VRzZESqkAyXd/jrYAsS39lr2r4rC3tL1cyU3Is5ISN3LgpDfOQDdPykATr+CHBDIyUzWG36nxMwEWsuFyiEi7cfO1VJbfREESMqr9zVF92slGllkbVH9RkpMxXZyWtYK0G2wPLYnC6hBD9+S3V5wCmvk9M/+2UeZOECuAP96VVpjhC2Kz4FyeQ7bIIDQOQtSoZ/qqU9L0ghe0KcOC3Md4M2EPHNCeSVHCTY/zl9olQ52fP5UJ17rSHiw7iTDX8rJ33Tr16NZabC2bxt47ObvFUXsiDVxKpXcPTzp3SQqRw7FuOD0Aio6eqlzxjZ3WlWvk9T/9hOX6tjsXw1lSIL/TfT0a30vUps+88dRi+mNPO
 /ZcmPyKU
 EBBzGLCDVBgxTcUfpGxU3FzfL2OGgaFFXq+WbBB4KgIDccK5VD962VNT1uwgZs83JVWr7k6EWraBAWWrXY3vM28CDohGxvpK6EiGbpbouLSN3x6oeeLYDku2vyCAt2aMqJB5BY/e46MU7DL58yKNIpiCR6GmSHqj1sQAVqOMol1t0im+YmXEt9baDJZ4fRCUdwo9QjD4GVHTpuiC1nLJm1lMz2RPJl2g1Vd6s2OfIry0kVe07Clupc7G+iX+6mrpyxvr5CIZQMpidglLbj2B/Vsmft3U6LL8a/OdqsdcPj90dPUiXBQSv1vr1S6ZZrIpLvgeh4vyqq5QT3PXZcCDAODfhRgIWz6IqV44zY40SwInmdSRtbBi/Yv/HYN7qnnkdZm8xQE/m4yIYwuxpms15mnAYTPY5xs1PNSKol5BcLYC/BnThWqsaq2FB6kbvZuS4HEG40OpkVHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A kernel-owned or fixed mapping is one which sets VMA_PFNMAP_BIT,
VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop as
only kernel-owned mappings may set it.

Using these predicates rather than VMA_SPECIAL_FLAGS makes the check
self-documenting and helps eliminate the confusion around 'special' flags.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 09ff20c3df5b..001f8b760266 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4418,8 +4418,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	if (spin_is_contended(pvmw->ptl))
 		return true;
 
-	/* exclude special VMAs containing anon pages from COW */
-	if (vma->vm_flags & VM_SPECIAL)
+	/* exclude kernel-owned and fixed VMAs containing anon pages from COW */
+	if (vma_is_kernel_owned(vma) || vma_is_fixed_mapping(vma))
 		return true;
 
 	/* avoid taking the LRU lock under the PTL when possible */

-- 
2.55.0


