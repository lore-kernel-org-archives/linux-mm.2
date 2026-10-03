Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B280ECA5FEF
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0506B00B0; Sat,  3 Oct 2026 12:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70096B00B1; Sat,  3 Oct 2026 12:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37686B00B2; Sat,  3 Oct 2026 12:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8296B00B0
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:38:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17C04C0A0F
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:38:28 +0000 (UTC)
X-FDA: 85281873096.16.69D20EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3D00E40002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:38:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TezC4Gsq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuyKa/I96uYdkMiLn7Bwd4i5Dddz0EbLQSfVq/AVkfc=;
	b=5wKD4mb6AZnPLMzHFBJMwy3dBo06QKnHm5OHCL5UATz7JvPw5WM0Eqr5O/nMDg7mSD3WoC
	g1QSJ6MexXM7EVBuvjeR74yC1gVIlGfz4TbOhzN5Jsnv7R0OtP+DpYRshJ5XXRH+145zRb
	3XSIX/KhsGjC3RswLXGmAlgRd9/b8Ys=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TezC4Gsq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045506;
	b=ex0xwrlMvnbSkxlJwLlBQ+i91ELvYOGf1gpEQI9/frTNnVGZV4DIeqRX+YlH/x8Tm8qLpp
	fq4OdvU2WIPGSrFlhJh+RNTMbmEqkPj1ELndNLFDVWdYZGPf1aoBsmxLXZjIEy9rzHxg/+
	Wt9NUWdWJb3cmTY1m/2ERbGahSqnBNs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79D814077A;
	Sat,  3 Oct 2026 16:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8917F1F0089B;
	Sat,  3 Oct 2026 16:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045505;
	bh=yuyKa/I96uYdkMiLn7Bwd4i5Dddz0EbLQSfVq/AVkfc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TezC4GsqH1h245EES7NJYHaahlpf9wvnzjdbcPtXdEBqYEY5+itmGGSomEdTUewtQ
	 FD0UkXvaDp4hq/c8EBBssuGnm3Xln7be+6OxzRKfyK03NrB700m23mCw4Wx7e/lOeN
	 XinRittBm6gkUDiDRMErEG89hrLadUSVLup2yjrZZFpfOZKITq/EA8wUv6kbMoG9tI
	 Yo8ggxJkmvepoYdisj3sl4+jFc5SfivVza8ryna5MGD2GMAzUOgcniXtsgMt431Onv
	 +xGhxrTxYv23Di8RBNnsS4diw5eitzDJY6xCUlaACyZpgw92UR4d7UC9bkHzB4Wt50
	 nYffiZBBmjOlg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:46 +0100
Subject: [PATCH v4 15/38] mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT
 if not mm-managed
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-15-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2298; i=ljs@kernel.org;
 h=from:subject:message-id; bh=HPUF4b7/zJhaao4G+RxxBLFnTwux5pLYe5udJyFpZxk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mk07ObV/Zuu9+GUSlqS9ie+kNUTa4UYmDk7bu+dl
 r1G41hbRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZy7DHD/5Kim5YnVcwlrsff
 dPyrIBdu8Wvn2nYebaMMuTUZklVNWxkZ/sz/o/d/6op1z1jyPsxYwOeoxi3w6d5c9pm37EtcMhd
 9YgEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 84yhtitftb3qoteygtg7ctaopcprbnyo
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D00E40002
X-HE-Tag: 1791045506-367758
X-HE-Meta: U2FsdGVkX19muVkLUEgViy336iLPLuj5HoDRmEl6BIvOjefXu95SBMEtRgljw96K0xOZQtd0PSubkJpvj08V8GVHFlBgqR0ppTd+pEA83D7D+1ris3eIp9DuOKVhMp3PSw+8t6kiBVteBdNYtDH7ziFI+RKZoGQuYYD+jiu/b4IBZDWzxYQe/NVL2HUKl6a8WYIjQ/QEO17mlQKhj1RuqbfNkHusNmFQvMux7RW3oPUtqLlnR0p7EMPIGFvPnpQMjh/O76ibdVRYuv4SupSAX+Vf/vJzCzwmO0FIQRt0Bsyo/py97+AhzeZqK5kRJ5x5ogKEk/NUh7I8HsyA3CMMCSNlns2ZNiXxuA6mYZmRrh1EgB7j06Th9aNJ44e1TknToF8dOqzbs+DmCmJreoqoQVo4OC4JWz2wdIwOC0KJ2HffIZqJHhhyVOanDsFFv2hQzQq7cZsFwyRFQmyUd18h3HJxvcdLIusHH4e1etDh+afTCFUCeGz06Gr5Kk+Xdw2Xs7Jb4WS5RGja0ShZ7CgmdabThZ9SqVGDOR3cd74e9wvgWkJY/MfoXN0shBk028aotQCPV1RJ6OWcdvbbFFVarleJyxTB9WtycjZQBhU3jlfF6EwufqkYFiJFWOCU7npUfEVnSl5YaxqTdDX4HcCaHnnVBECsI2IGcW4mILmXH8VCAuY54lsxRn1DbPQNB2qCycPYB02gDV6V5Nl5JGOQvb6jVScsHQyqxMgwK41wRzfeXgTkCQ5GkvgnYor9Rb63RYx1X0l47ByNPltBeWKVq6Xd2o3OeQuhYmRst/deuf9sVnBrYeE3axhjqwzyqX78PLVtnkQDxufUHpj7d3/5rY2GLHiIEsT3lrX1qkqKoPTiE2QTL+1+Ipt0D/8G/TmwWn0Btm6KySI28nutO0LAl8MIl5mlpRylUl9Am/yWexlF+nGZjxshU4WKCel1BcyFuihYBebRD6FwLqYXXMC
 /wiaqZIY
 DZCxqH6MrAwLdYe+EdvC1l6XwZvm5bXpPH2G1Lp1O0cTIfgZfqHel23IU+nojJ1YU9R6bNYAWAe+ZgnB+dmhrIbPzMCrKP7pG/DUtCMETcTGI2rYfXitmLUnc9EPvuseUV7hMpXx1YOL4t1DNxK3B/0UFCJVXA4oxZtZmFpDNiLEUpre6diRn12X1Tgc6eUj6FgwA55ZbRqFsTkYkM1arjjMyt00zyI2ry27gnZ3m42lwxK4SD41T7EzuD13/hYsW4JPnE4zEGWXJtb9lxR/OjS246B12oOOKTLDJTwbP34wBEFSdYtaY5L7l/M8F1fa7Tr7Tuun13YGbQf2btptLGXnWpM+L18jqFKtDJdARcsMOPed5xNB+uDIU+aNE+AgYS8K2Wc3HSp7P/1E6CmDcZlBxmPKhVIudcDGUrXXHkHi4MlA1xU2ric+DcuS8KdoaiowACWFVGjQEq2fne+WkCcxnybzWXFZ2lLU4Smz9+j4bQLp1BijGxOsPV7ntFiuYxqC45OCdSotzn2zkyJwRDdJXFJIa8Esel7HtpOE4vFoP+/HvqdILWSDzLouwn1zesaTt1bATTcHNAgk6EqzBDt3ZhTN46V9hoiwDgIYHMV4h0NJDEro8bVQ/ZipYKVIMQ9vuogsQPNhiiFT0C33n6EeCew9IgLPzvH5ty6RvmkfkLcR4FbEVEyMctro3hhkU3N4AW8kPnbXL/HkCAchERf51ZJ3hUkq5Bj0RieOFgFacH7XzsnntCAxoQ1fh211g3s5kA1rx/imqKw5gwJ+boR4uRuoh66peDvV7zOlTB20M24tMmVKaSsXvfOS7sM6cwp9k4UfKSTJiv2ZVjzrSaDgYZZr/+PP/3Ua0ORXCDbip4MVcTiN5WFPi6AwXkxsqbq54UFeoKJSwAOXHkWQLCpImVMOGwVlebktcMTWIPHAx5QFwBpTySsejBJft0c/4nFFWDvUUtyg/gJsqQ2bdsPnPjWuJ
 PoQr1nnV
 B/OiHxNGlS8zppqtTYdAV7/XRTB7Q+7AD3o00rkA26pHRaLj5/dgIflh7E81Fzf+DrIG1UWDRJKgV883KheeZUOtQvGo5B7KAetF3UKbDErf+hAEJ4L+HZ/eWuw4mR7DIg/kdYrkKIArqYUZ8AVsMjDDoTnO/z7nFkLtyc3TjJ6aE65pLt7irrf1oSzBAiQQCLCW1Dw2DaXY+0I1F22k94BP+1wgN2opsiMPjMkI6I9hyvRCNqJznUwPGjiz/biBh2EXy/LGfxrLG3vbIhzdNKIsX2/SlR5Jcdmn4JmbctlUAxJYXVy0CTBTW+NOiG3DPVkeZc+PaU7jmS6wrRwYVLcegNHOQMbuqjKCggE6bhtNpftUQFTWmG0cAKlJj3ypsw9qSgg6E24o1YvMxFY3oztyOMKf/028eX8AL17PZelaXT3JGngWfwY7zB+KGTh3hWS2h3QoivnVHbZF/R+MK6vxpCJnpR8LY8NX7WTVyXfBJ2vv5eHklHUpPvAynkQjnUFasO5XRUOvkYhAoYJdtnahvWR6SMNU4jWyGrBHQgWmZ3zGkt/UvEJLPRqmkEAcZ5XfH4TSp3xEZLKvqphg8FWLknvUUQpo5YZ0hmQHaBxM4I25F0il8CTXVtdnWRWTTthCROA0Vq2csJJSM4YfZX8G4Nd+z+ZTaF5zka0j0vYWnmCbgBbVFj2MeOVBgWHJKb5YI6hNOqmQACrnJl+ApBS9bBEsrdNRByDI+u3C1Qfxw1bs0TMQNM1g9yr7tcmd1xi58VNOTcG5LZGonMysmegnBjbeAJXLvJJ8BJOj0RkrlIXzmMymebSKH+ssn7dbZYmC8bkpsZGrSNxMUi8fXRusH8qws9GgkQX2tOWVPLdCQYkuvtEnmx7bzfI71HR8k3Elz1BPmwJ1HOe0Yh11w9cxrO+QBI2OhGTtdh+9bY+dYxqoZtZJtk9qYHZZwk8RrtuM7fxI0ym1dx3XU6Ib7fMvyB8Xx
 If/8kdHe
 fIcN0iSjjmAqQmGU/TERCM8CFddAmmQrtVewkup/oWwd5XWb7lbnXKHMD1q3HvaKX7BAancwHH7AdwnMwWv4nz+MtvMEbEl0EShq2G0wJCpk+tXXnH0K0Wmm4qHkFIPgeplPDn9svkGlHvBtRvo1MQdjzhIUFmgiuVeL7rG+6/eMgHkXibxVjEllm27j93ctlKlzqpQrxbufbRL4znqFApMkLzcTK0wjhxdjuQCo55qBzB2rbvyR5quns33SgAZ7tia5HOcdX+9uV282D0ruiOqWe15eYwtw3wlxof6jfKk8TcEcZ7Z//+tiXKdVg0aGAYvv/KqTuswdbWkYrz8jFM4uALMpTePNnpwpIB//OKMkawldGdy6WKD5Tk1WIWeQZ93mZrhrg+OycUpS6p9diiXgibXWAUPJM8MKR7VLCLZUNwt2boiJbWrOSoqf7M7QlnqbCxGZMdL/ELxb7aT5eQR7nEQj4hLuLobFjldbl4BM7OXK81rImNcietuwVVaOErfHaNK/ocgI5RSuVbJwXwxWIYej+tel+XwNx0R32SVTLus15aoLWU1RyCbZFV7GCUrRcbr3j95w5l528RRwkTA4nlycgd29xcHezOMTyCNK673F4P25wA4FmJbjqZPTbWglm12T2j28diJLwSA0XL4F0Ae4U0jtvbV8hYiR0QcFWCiSpMb5orSuROGa/fCEwX8LQjR6KsXaMqeGcnbucl5SKWCHpev8B1x0NuMRoojxyZt9BAhYcm7uzdKoND2VCLBneKtXwBsx3ojfTyXYfe3MqixvIH8LH6IL9oc12FnxrgTnfptxainmrYi5FxBDJSKBP5SMHBqFKQyxhHN/vxvCDeJVjb8SJT5QPQwDvW17WsyhAcX+7PJLHUK53EAZHGqbYARj9qzja8NRsJSPnc0/HMJaALy10T6Mp6ssHrky8KY7kVUEjD6618ZfP7uk5aNTGYfelhMlpII6Xmn0jEquqc3Gt
 LUTMdSlo
 AULboZ7wKbr9OL1CYWxscba+144FABfqausxSEQi6QE+fVHGg2xDjNnOP602FtUmGGdO6qgL16+yaa7MdOoj1guu0a48/wUH6gPm5IDyjvxdN2Nsw906eKE3UkIkABMhRELVUhZsfA4i+9quAPtZwYcOTzAfLPcde7/49hS86IIrO8WDVoRZFYMen3q+LDLbf2pbZhOcNZitQYVkTL8nNhdoLsd+oezqztraFAOK+2MfHsRe9ZCpujoN3AnhjLBAh+HVuMPp4J4mgSC6FoG2AD07aJrfKp/YnY/JR4AaujKjcFJH8DXLyhzGpAp3DctKoBN6H6EGQ5m6b43VbrUMxjUUQZyKacRrMVuXlv6kHtoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is if
the underlying file is itself read-only.

This means that mprotect() cannot mark a shared mapping of a read-only file
as read/write, as doing so would violate the read only attribute, and
permit writes.

In general, we do not want file systems to be able to do this for
read/write files.

Doing so would violate fundamental user expectation of file attributes and
likely break userspace.

However, drivers pose a tricky problem here - the /dev/xxx file may be
read/write but provide access to a resource which is fundamentally
read-only.

Therefore we must allow drivers to be able to clear VMA_MAYWRITE_BIT.

To achieve both of these things, forbid this for mm-managed mappings as
identified by vma_flags_is_mm_managed().

This constrains this ability to drivers which own the mapping's contents,
whether memory-mapped I/O, kernel-allocated pages, or ordinary pages they
map themselves, and so define its semantics.

Every in-tree mmap hook which clears VMA_MAYWRITE_BIT, some twenty sites
across drivers, filesystems and bpf, establishes a mapping which is not
mm-managed,
with usbmon and the ALSA PCM status page converted earlier in this series
to do so.

Note that drivers may, if they do not gate on VMA_SHARED_BIT, be able to
disable MAP_PRIVATE-file-backed mapping CoW semantics.

This is perhaps not always intended, but we retain this capacity to
maintain existing behaviour.

As no driver which clears VMA_MAYWRITE_BIT establishes an mm-managed
mapping, no functional change is intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index a9532bbd4ee2..90fe6f0ee3b1 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2798,6 +2798,11 @@ static int mmap_validate(unsigned long orig_start, unsigned long orig_end,
 	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
 		return -EINVAL;
 
+	/* mm-managed mappings may not clear VMA_MAYWRITE_BIT. */
+	if (vma_flags_is_mm_managed(curr_flags) &&
+	    WARN_ON_ONCE(was_maywrite && !is_maywrite))
+		return -EINVAL;
+
 	return mmap_validate_vma_flags(curr_flags);
 }
 

-- 
2.55.0


