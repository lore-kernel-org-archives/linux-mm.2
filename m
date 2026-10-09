Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE77CA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6E2C6B00C9; Fri,  9 Oct 2026 14:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B460E6B00CA; Fri,  9 Oct 2026 14:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35AF6B00CB; Fri,  9 Oct 2026 14:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EDE16B00C9
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:17:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0F20A046D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:17:13 +0000 (UTC)
X-FDA: 85303894746.17.ABF26CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 15CEF2000B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:17:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nUkiwp5n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569832;
	b=MG0nvuzNoW4tiUOB1gYjt9swa4JSShxAibWyA27OeQ3DSlqhXRo0fuRE4puIw+AQ2S9d71
	ZyAt/bMB8Za5N7oI7vSe+1j3B44RdFkZ9oWy0DKEtSdEgCHXE/O5it5zGXtnA5hwyYW+Qz
	V7ruGKT1DUMCZ1+xH90pxChaE6GesxI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nUkiwp5n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36Kk9cCfrs+K/ZkPenTGstnZo1LIkvSMm4GHKa8AJS8=;
	b=ZlYvfLDHuElNS7H33FMlSeOuRfgMmonHkKk3ONV4XzYXiteH2V8SACGP72bcBR6vqAhcAK
	/vAf3TfhKmb32mkvOxf8puxndvyxbA8xeoPzJHSYEm+IXLsPHET57CWjhGV1ouWi+iW6zs
	CUGAGf118lDvwapEZraBNuOEoeqyjyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B71A41980;
	Fri,  9 Oct 2026 18:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A653E1F000FF;
	Fri,  9 Oct 2026 18:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569831;
	bh=36Kk9cCfrs+K/ZkPenTGstnZo1LIkvSMm4GHKa8AJS8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nUkiwp5nk4Gp2r16VH5gbhKuRYhYJCXKXqnWnAP25FGpRt9xDCub7xa3NGHvUlDm3
	 M2moER4fzb+y6B6nt6v4921eMmhNTNVzHTA9F/bvTayp08ReVHg1/SSMsRtWJQoaxX
	 6JjwHOYhQgjxXrbiE8u2s5aHmr00/3NbTyysIDaJj6blFc2K+B53iS4sU1XxlujvOR
	 sWT2aSxqOVIE4VO0jfPWRsxOypsrkGmlTNqls/fYYccbqhYYxGIYyNc1JwsZ4sCioI
	 smhpnKQ/FuKGtPAUZILJZLCi1hHf2Yxy11X1srezP4S1pGRxssxLAzYyZDdvg0gDsY
	 ZIL75tT0PjB6A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:30 +0100
Subject: [PATCH v5 36/38] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-36-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2224; i=ljs@kernel.org;
 h=from:subject:message-id; bh=D4Bktmj1CFdgrn8TjfxCWBpiKXIl0qBVGlP1ttOp62E=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sxv4Lk0p3ar0eSNd3KWRk/Vk9xSXx+nWFrQc8TA/
 sLj5JsrOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjAR238M/3Q9t6f/35/XeeWa
 75NPt7+0Z2VZp/YvOiu+UIYxxMFrvQnD/7p/fDwvPDzE9y8PndP/tJjrfK0ly36WnE/C2rbJzX8
 y+AE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: js5eistecezg8651xbij5z3ammu3dm9q
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 15CEF2000B
X-HE-Tag: 1791569831-597572
X-HE-Meta: U2FsdGVkX1+E4p+WA/49t8PDOm6fEpfbXLo80INWK4uI9yUlJiwfZHEzSBSWvkWt80yS2atzpnA42ETfnFQAqYSEMR5RVMlgW2kQWI54ZGee63zrorkMhmEkT7yUZVoE/h/gC+H+cP1q+jM3yDH28aGZumoQsAdS2r0r5XD/MahmUNCmiswWZIFbJo0UKy3RV1Jp9mXXIXYx0gaO+iCSTT8AEvMjBVE162FzgLo8oJpG/1Lf+/foCgGOY223YeFlO1vkS1bhVaBrh553F7oKXeMhq4XohtA2JgJ/+oOrGclXxqKjcCEq9c/GBSu9gnwu415wW/F+zDQ91o2CLfWsPrZc4YCZmNNvxGnuvDDKWABHGP1m0QMxq1N90875sdfra/mq7DIBp9bkvrrygzg0uV76e8QFOfQzgAidA+qwRucmAR1pDMAK/y0fkOBeIGCMrylJwbowUxmgJMnfZ3AozjaQFHFW9U55lxTwO2xYN8+0z9gDfWyVvjv+ppzQtF6Ne21NyNiZ8NX+pWtC/yjwMcHC/dhQQLmn5t2U+JKPv3d050b3ir0W6E76rzo2+qQz6jo03v8/+GME9G5KQdYlSr+Z2ErHeN1SG4puyD0i2DqGEpF7aG0Exbwrp3YMXpsDfmIxdqnNY3cwdVkWYM4FwIUp6wSV2ZUFRvmnuO75BsWQJiSgfNS9aPlciirDlUBlnTuluLXVrJZNoPKmqvzAcDbdFI13aolnXUN8HXq4zStZV/UveKR1Htauoz8SUr0m4D38woDnqWt/ylCu6zR0NMHB5fYDbSAibOmoLtmfEhas02rxHNzw3KLlFfItj+kMmmxg2exF48ETZBCVqaR1x64wW/qMhfru34NnlCrt8qfA5n0Tq4AGoq/5+17DZQOoFaZa2pT1FvDihdGG5LbxFuW2r0Uxz1BzVKoRJdy2UfWaSe7uQngz8Xu3nKsCq2ZdRkPzN6nH3LRAgYpLD3B
 fTQ9F+NS
 l8BQRtrigGRXWJSNyMGV9Yj1iZLhNRLa/6hlJIDZ0MlEhyEmNGfR1pvi7Z74o/9AtQqXVonIS/n9xGqsdC0ro/KrA6bU4SAQ/9k83ZjZ9NGYC83jkoYgCCLV8kCtQWVGNlhM0/mgC0/T5ncsceS1cL+CZ0GvIQNnNc0BhHPQb/Ah+E7+jAlvn42IiW0SWrrA0eG/j0kDy+v+1+LybljdFfk0LaR6yMgvYQNkkEZX/A/Iqf1lQCRsTnytEIM6c/b9Ze6dPEstHqXu+ev2P4cAg+XGpZME9uHusQJpFWCBQzm3aoeV7E6xs+i3mB4UWyGfRir/aKBkGCDDheMhFFBZG1LavVPzCBY3xcPwMcm7WPxw5rIbWlVUyMew2rAjQ2g8CDbCT6MHFISiacpTBkUjd3m0XgppQxiW5op+9x+R8GDoRFEJIElpKDcjB1HFSoGjVsX+u0PukMs9WmNvU2DkWrA2V7md9iynnMsw2Ub/gvtyhxzW7hkGD0s1AI5w+o0wuYX4abJUTHz2+u83d0mR7LshDQtQY1RLZdqXfeI4uly3kYbep+wDggdCaFawcXVEPL+9+WY1ettqKyibLP5sPEyBkmrhQN0KdjsrhfOew5Xk5CBjlzbInfj6OF60tKR0Ee4t7V0n/EONQ5JCFCyaf+qXJzFKLjjAVUEF+NgOMkx23onz9aL48W6Yh+FrZltRDef90MPZ93kaK/iNOvAKMYIOf3eTW6EXWg38Ycob0XvlJcvI2/BtL5L1V8Ie/RgLM70R/o4Ia28icGImf1k1HIHPtcoG7MjakUht+PLw3YzewqWH747884qtPsKybLEQLV76hYiJ+/vssP/8ld4GN9O9MpGibOBEXry3TxNUbsDaZkpQ88u1vZ3jQDWb5Z7tN0d241tKtXEWovFfFrWU55IXBTktorzN0vTQo78HT8FnyKHnUnNCJ+7KEtQZFzRDX8c0NnuyZBwYHUfj+BWm0yTTHjAWB
 uCCVAzn3
 pfMvrDJ1G9hCukUISdYd6qnGSgjLQmJlCP4ql6qNMyTaiSDu0lzJiRlJsoRxzaNrUwsHzG3WtyxoEfzeWwok9s1QPQ3T0nVEN/VmghWzwJXxCd7U9iv017NExAai7v1leUWwtr0K+yS/luFHJJg6+p8bfjIcgpeH1SWde8mddm/vWWWzO9QGcW7P6KMkPBn3APiSUAVFnB4zFU2a/762tWwkroQf/JrSApDTmNxl6bspmCTlC+yMSASP5IrrLITS4MAm9oBPxfmcKrVFpv1DSsvXmj5cBmoGPeNgsB0z3TlPjihGsShp5dYVoK8ZclTRBXaUFt14SJTpAKLXRjmdpcCGJsVA7sMAUGSJ9zdQkkVYxs4MaCJZDI+3O4i23a4LIFJ9Brs9UhRfemagqEvUelss824cbwo8lF+Qaj+7twCiXx+VE3evIH/EGgkAVoWgdv1gBxW0gb1sp6EEa8oYE84pthrHmwkQezAS2IlC44y0tAfusIFjRKZA5rJaaxQv05G+Dur8+h8hQVN5EaSgQOz45hY7B83UzKKB9DThPgFjV4UbkWShMc+FMop3MEr254ZVchIyRguUBa9ZrjOu30SOoFv8UaI3To6kfMdsNrdHNHv3/T6RuXu16ggbNu2OBCTMLmENDj2OkvD+cTMSg6iF6+tTO5MFkexC0OBAheNgmifubXVIXWwdpnqmGzuDevQxCQXcJ9EwaO8M/VYhkOjrkRUMQtyIiIdXTYELpOqFbTKvEdGPIQ2vv+eatCs1XryskrGEnsMGjGghc/RrlZu0IcCOxTLseO6u5V4cJBoG+WOhjt3p1ZazrX3lSTpGm2Z4gwlUXvel47Dw8PoTHM0+REv5UMjou9Ea8MAwr3YlmkHjh987aL8pknUBYVjRETgvPO87sYIYGih5XdlXQYRh6aGwITFV0ThEwDJxxuWDvJ0kJPmuT1AjO8xPV6qhm8JKh7xG+LQJxtJxBesxexfLlT6oI
 vmKd7Ol8
 b6r8BM78GzIFjF/k6dFQl/hC87wZJfimyPzHqMBEkk61Qw3QDi5m7b0Iv3LbDJm+Ud3nbqhcWV9Jd6jNW9s+/+6mkiKrTzj17dJILChPY30u6zLUToSbmyQuDie551aW8sXOJgforDFd01u1DkPLve8fe03l9WdkND9BrJ2bCkRH6l/Omnd8uh9kejnQN4gP9N1HIWpZh+vFeOMbaXnG2qktF0vrCSmbR0lI8U20t+ShFl9iix+5YoOcA46MvV6Vw10LNEpC+6vM2sV4aFBOdohrnnabqYCdydCgsxU74JPzpaAtW531kyOFFSakGS4Xqav3YBY2ZZM6czKP2JGmS+QeIVs0Ir08R2XIvve1/EJPB0loIy2CQS65PN8D/spz9fv8No92ppwIVT/zyuZclo57Jmkq3qovfkYtQZUXAuoVwI1ro9EZcLe5SsFfksvo7ygzHxHj7IwlMoSQQGlsakhdMqtGdWE5xbA+0D/Dzni0+l/DvxxtZ3m1igQvXqqH4gFvHEL7s5S3mGxtV7qUpwIm/ins/OZOWDz6GZtMyOUrzCOiZVFNqn9M1bp4EgRrrNVx1obVtbGObrmfiEdtU2ItzIeXCm+ILGy2+WbMska43is62JW9o4Y8vgUMFSTk/Xls/ceVpztDDGDeZzzQ7MqAnrWzky+mk9EAmO5GNg9FrFGJnym+VGoS1raB3+LEPMlTvu/ZVndsqQnzb2NSprAuyWeSb4q4J5Jj2+jp25YYRbyD2eOMigt81UgFeVIg95fuz4cafvOtQKwXvzAKTCPdcvNLQDACqv7wiLBD5ZBd9dDmTPCyepo1e/2WlBuSMKfsd5S4n64UpVOXERmsUCY+4neHeQKjzREuR4NOO/ldH0N4f3eEBv21MIzEZc1xpwR/nta0CJg2hcuEGbJ4Womiuwn4atDY8sDf2yweiZYJbcdJwzqcuarMlw5HVZpqmaRtJE23C6PmvBfOLchfTDWtX513j
 ZAw/GXPm
 qFLLriwXDhsDXdloNqU4OCE8Pm1Mkm94YHy4eYKk56RRirjmtqG/8xtFuLbdNuNhPSqKinSpHHah3aDIGRf4WFUlkXU+PfPlZ3ZaXA4gaLQb8gDHaiSS/3h73YJ99KMja8G3H8yzyJWEmeIgimH4Z05JHmQ4LBQkuJazjrheT45qqs8TgidlPXs+EltPAH+NHs17Xipl4yOcd2IHITRfUbMnvDUdpwQ4qYgiVFXJK4yEaz/x6Jra/ApUQ2A3FWohPI42/ujUSTfaGWjA1u0RMeMdi9j9a+o3Ltx+coIDvPQFAQGZ9RzEH2Rhi0IrSaIc612spNWvvdZsCIL5C5rr6WFiq1I0qz/eZyA9hY4qGLJNbKS2V4E/WkvZkZ8+nx/+rNNWdG8cOJrWgJgZIbxCEIQEG77OzmLmkMaVry6DdMYw29kbnSAobN5YvWu7slE9pvU2L3qLPR13+EASdsvDYt4YXe+ErqZVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted to
predicates which explicitly express what is actually being checked for
rather than the nebulous concept of possessing 'special' VMA flags.

In any case 'special' is not so special a term of art in mm - it includes
VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
other cases too.

Therefore make things less special by eliminating these now unused flags.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 8 --------
 tools/testing/vma/include/dup.h | 8 --------
 2 files changed, 16 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 55320cf2c525..7ada0da24d0c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -576,14 +576,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-#define VM_SPECIAL vma_flags_to_legacy(VMA_SPECIAL_FLAGS)
-
 /*
  * Physically remapped pages are special. Tell the
  * rest of the world about it:
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 94bf818ad0e1..7a6d99ad5303 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -352,14 +352,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 

-- 
2.55.0


