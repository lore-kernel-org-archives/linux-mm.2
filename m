Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 327D0CA9EC1
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262E76B00B4; Fri,  9 Oct 2026 14:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214786B00B5; Fri,  9 Oct 2026 14:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4766B00B6; Fri,  9 Oct 2026 14:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BEC5D6B00B4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:11:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4EFB61A04AC
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:11:17 +0000 (UTC)
X-FDA: 85303879794.19.5FFB6A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8360180007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:11:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZLFT1XEI;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4y1sz7ZVghomqASsiy9XjZk1iqHWnAgN1nUm45xiCg=;
	b=RMxZdrzmcIiT/cxxQhRwRjw0tKWJS+3Fknenzizzg4BeIn3WljIViQPg/4mv2DL+W5crm6
	uD5XKq1aweCLJlq5507WlxVgB3uvtulrOl+yAVy155Y2w/EowCZ6ZQIFwAZvzOX+bAISzE
	p4Msz4aZbQh3qw8eWDDOjcXaFWB5Lrg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569475;
	b=k0ECpiAKvnoEDu0sKLzWyIog1zCohKDwyqCr6jPMr372i5XSIrfNXYze9NT3lS771dNXZR
	hbUChHGa4a7OLZaJmQwNXppH4Xob2lE5PPgSYznps5W5odFa5a9IP4cplEJJIX4gX2UjK8
	hQfDAf7DsKJFtddQ6Oc5uhSVdaruE0c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZLFT1XEI;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CCC0940A78;
	Fri,  9 Oct 2026 18:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADB91F000FF;
	Fri,  9 Oct 2026 18:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569474;
	bh=i4y1sz7ZVghomqASsiy9XjZk1iqHWnAgN1nUm45xiCg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZLFT1XEIIbgkZgYbl2cjVccfZl0WKiE8m0l03W59DgDeneiv+L+92FBild3sPyde0
	 wzuqOjF3Vi0Eodv+kRyAn0GxTK/vytccPEoGWPP+suajfvmc+F08VZ1oopYqvzdtOI
	 gILxTUEONu48fqVbkejv2G+UmDtjgipP/1mz81o3k6pHGvEd/jbGl2ey//6m4Sc6aa
	 EwtFe6k4gZiCPvFZ7ccHgXdRKe704eDpyuT7oMGEQ02V5L8/keYilUw7mGeP9K/b5J
	 YIPgLlCxq8hWwy+A73RCX9v4hfjY2Oi0k2pU+usaU8PsYFavcgQ591QEr+WIPN7KJx
	 VunBPOI806UKQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:13 +0100
Subject: [PATCH v5 19/38] HSI: cmt_speech: convert mmap hook to
 mmap_prepare, refactor
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-19-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2685; i=ljs@kernel.org;
 h=from:subject:message-id; bh=MY9UuAl0nfMrM4GSY6SwItqCUTxM/pJjBHtqUqIj4oQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6szhFQzwb7tUeoPRuuPlFgPj5tXbDD5Iius9vRzo/
 m6mlbhYRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZSwMTwz2b9vWTG1ESd96su
 dPx99u6Q85TpVdvX7pLb9cDO7/j9db0M/zQuLxdM+WWdy3d7yS57i4s8Cw9F8E4Ld5p+416nzHk
 XeX4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8360180007
X-Stat-Signature: bfcrkpt7ymwf3fro4mfhkc9fp6udr9pq
X-HE-Tag: 1791569475-378421
X-HE-Meta: U2FsdGVkX19S3tfg6Er2MgS3MYb2yPUHrdUOpBSru5kFfhVCWgX+DWb+BN9bye/hk9BT6AsuKn4blvwNZK0PXJRwL+fPSBnfsDUmjtvLTeoEVorCRQW9MZrMJXNRRNDSuoyWKOlkXEz5pS2l8zqWyxakDJhmrk7iVKiEYH04Lsa2I3A+mRlJYUvFY3XGf6WCAl9fJDq828Fuc9h5blQi4PS7HqAt44NGkqpNO0cJK9NKqSRlglIjNucCv46uolheRwOsBpzQ317QFSDDCsCZsrTteTMUZ0ZdwkHFUeGUmIPt4SZv1OQZwdOWE4jZNfkfo7q/TdM3oXz2eFkwqoR46nDFKB20r9dHQdin224yJGUwRWO+5uI9BqDOz1llwzLGbLdZutjeUm+4dXMUcXKDrfNu+mnvXK0ObJiQCCZk+woH7s+RwzaqP6zBd3kFOX/WjvGasNmI3FMYcr7zRJyx+zXLgQRxds2IOxlVIGjP4aGoxHa6TXYxWrfKe5vEj+ZHCdkdVWmRNYJCm0l03S34VkwBRHD4+5WaMVLWEYR8F2X8KUqEFk/U3Q0vaUxqxDg34AbO4jo4iz9Aas80CQ5m8NVKkLXHtYScvytAEBjnXXFGzoDVwcUbO0u5xrrnkZykIwRknxSFRDxfz0/flpwMYncp++60f4C1bibViPQCXQeFkUEn50pwveB/ar61MUfAgURm7xQYJIsLHao2n/0xwLLTUa9gEMxsKlqBKOI34nzVc/XxJaXNCE5Gsrd3scTH05kwgVKJ3E48Deywe1RqZjwbbrrxh0aqAFQ4EjhRPWM9X55IxXqb5GmwU4KcSbji1O+7/2esoPbCGaSNHlmGQ7wfX5ic606CRYPSlelPdsj1jtoeQFQRm/PXxyrSTcw3qxwJg7rt8VhPaDVYjkp7lEIQrqfrJ4ipTYz7xT6tl7xMsrUISmitjREifr/mOXWlcrZyJv/MCaHyFI4JxHj
 lMDC/JdE
 EBsmDOhNDfkXzA1n6weQy8qeiZ8kMNHzFUkddbsCAqhd7y/mEJPwpwpAhskKa92pyBTzMPmxfj9D7OKz3xQTDZPwuAsLLRLzqVBSF7JmQNDYxPLHr6rZ+ZCCdFwNoII6vFY6IVpaJ9BLuCp8MnCOeziqV4f8URz2l/2A6apMs2EROwb37Wu8t4N7zQXUU3CoPzMzzPm6+JGDKteREQVAKIyMsAv9882XHb88vK+zwDc49r0xMWklXbY4xj9ted/Sz4pClVhB6uiIv99IB5jsnsmuEDMqDFDkJuPgcwjAmNdU10VgYwDGi2qQ1ZdK+K1/spA/E/8C14T0OD5D3zmq1sy3Ylh5D+sANNleebW90J6K9eIgwPmDCf/h+Be6qMpWbZEFL2CIwu/Bv2jk0wqdYimT28R4x0QjEnSuI+qR1xutKYVvPnXHfHkw/afqi1nTigqZhOjU0++P65yYh37tVv80JoUkJzNVsfoSmyh4kzuCaR33xlaFhHFfFpJ9t61oVe5yJJzlKSxlQHy3hAl+ZJMKsdEJBOGMGGlN71jaT4+7hxj609qbyMw7pYwi2ja0xnzZ9vATbtDBEFSyH2vGZkewqkiAZQcS5Z501eGqyfgdF/96q499dsI4mTNLeTLx134l8CwPYUKOYI6fnHJgbW/OhZWi+8r3sgsNS36x6qur7dCub1eW468FggYSU0F9KmcoXxczOEexCiMU7ODmm2j+MngrkkoLQXOHTneh6hjMrnkMBWa0X08Fkqx6SrstqM0fXKOn0wXzJJinNTgODVeLoUXLpfAklUZoY9q/3NLxWv0MOGrJE6uXIe2dXJMZ4nv1ViGA+ije3yg3S2FBV96J33uSbq1p9e1IKLBZlxRzI20g2d9bVgEKQOWbsVjR3V8ZXCc7ZKEDZXAJhTuODoNomCU9oWXv4AKJpEZblzUvEdMY0LQMp2bn9hHlHqUlApW8vpLJUt9MiXS7bvWBpgOmtsuKw
 eTQV0zvg
 1si12cot71JZu5wjxkxdccSlx5bYZ8cCwcTGox4cH26dFiWDvQq3rybW8VBmkWTU48LBx4ELqmCLDBv7KhgeiGnWSx53S9R7bXqrnZ5xAvBI2WmzSZ0ztugNeGTv/fHYSz4k3qphCLnbmjGNfAfiQFdpy1gKAYEeEeNTUdA+uyE3rZ5613OG05Md0iRefZRCqAHkQVhMSNya9g/lO7ms0wdb3ODwrDGo/Z38F4HZ0dkvi3rmrNGmJoyhExDSsZbZ4cFVtvtmG2RPNzqikl3jaBOjlVzzosttYdsssOuQQlu0s2x71u9dfcLACJcX7cBijabvgQMmp5y4zKZMCAqU1K386apX7LVCW19pV+mCrO+Ykiy2f+xbIw65QnLHAP6A41O1iUCw5t6GYxmILWYV9XoYuEvm6xwXYJVoNXk6e22Z6ep1aCBW0v2fjp5cHqp2vK+YEu1hjXKwxGkkUYQRxnkdEwWbZPgeKG0Ohtrc506jnK9dsFyxkWPO1KnhRd/k8O3iZyfIAGSzsKX08xGk9W8sKcWjeMsxa5nxBW4xJ8gmgQe4cQb4TncUFNtme5twnHdW2JNoBQzKsFhJtGrtjd+ZvtTutFmw9BISX/5IyllprZ6ekyPlqouXcGl9fuW2O/qQAoIVPH9CkiTCJ8AMFWJQSbBUMqvJC4wxDvf5lrs2JJBukBFLCuHJlJYhDUIhvwcqYtLlIWTzCN46manqPPwoE80pCbIUKryZEBUPJHufC5FLaps9vgTicw0oG44HZ6fK7J98pbtQYX8gmHBfSFfJiwDxezmRec1Jg7fo6tpslle5UgRlwPCIuTBB9i0IOv5CA/KYhlc29SrGOrXSaLGWIBt9L15E0UoWsp4WtKKh1+UtLmL840MQ3o9A8w0zBaDWa8t6yaox0Jb5Mj4AmGujya7fIJb+r3sSr+wPcgyE1JThd4H4HKHd1ms34Q7nKXp8w6WL3bQfcG0VpJe6w6YoVyPoj
 2YogVEAd
 i+iEFJlghfhIwjM4cub3SHOS0MaWv46JjBkF+ygKekoTVCtuoG3YwPBi9rcGK6wXYelwZEUgDImNnTccEs/IXuaKHPfle8mLTqCzPpGR2Q5l7DamLydw2oAm7HYBARUsElbPRlVQ0dXYzT6np7C2S+b7O19eeHFfqKlJXiQYh1I3sVTgF1AS9VyELb3u9RqERh4+KjYJv0hReZf4VhlUW5MAs1s5znkPqKsdjZm+YjX8a14WzwRToqnB/Hw8S5MWmoI2+Q+5r7b8ZTBAmCITvXh+A+MV4eZKmdJ9ClsBxIY84n1n2lJtbRt/vV7dP7EvbtItqgkvGbpZ1lqPCeo/nRaAHMf94QmHby21nRDSdLBaXNpx+kgptrwVLuWoMMP+adi4PaN5tKZMO2uNEy/mBaeN6EAvgaBr2sez+tIzG+o08HAk4B4sL6+O9IEYNWcgByPdH3vftgzv060+wuqRdtsKVCJ4pZssKci+heAUGJAVcb5WkKevENZEBV+b97q+wON1IlaQOxjVZeiy7+fjVQ3CJaeEjDHmnKZFeu7/WioombYaxVqmCkgZo8CPss8iZ048XJy0oPk1lFdPIi/NGrw8NXyUdN2leacnIsXNYqteFdoY1XPOe+Qc6Kx3GwAbXmZjC1Qn9EhHub6TIiSsgttHKwTXjsSCstXV/z6KNgePCAlEIHNMHaZzq4PLe17Jt60u7fJrWSdZjicF/JzH3xO8Z4NB1UrNvp7a2h/NH7TjkvYwCf+eIjCKvFc/5lwHA4Qo+0Lvyw+yQc2HcjNT5eMLh8twLfOyTNfi1ICl9FdH4RhpRmR3AiUh6SpAWxS9hSdxB/sHe8h5x3HJV/6z6YXCPkOVxdT5QxUFH/P72y1pgvJiJmeoKRfA7KkDPGt6xK5c23aT5TyofE5/PfGBPm8wKxI6mN34d8/akxWYrzZPNGz9gSe4/MLmXn4JTX8/U6sScl9fZYzR7HBF2Mswdaz8Ijk1K
 dtW7bjBx
 zCAQ+C3rtFm35pdn7oWoc5/eHYDr2VI1m1yQuhjOxF3bTo+zh1sMP3nj7nHz7np5y82nHuqCVZmlvpv2YgauvHUx7IJbETR07vCFR198gTBIS4571YHVK6SbooK4CKuCIttZ7UyiclQ5BsCoWTjYCnpkmHj04uLovqU7tJnXiQcd4hY3lvjwa/4juXvENMQpQaKwWnwK9WiagTRtqXEG+6R90gFJBCERLqnWoApgwIV28QHfSrK6wo7R411e1fCbvOJTM5zmIalaR/KteZ2PdGw9tL+IhjAWoljPZ1es6uGUNegaUdXL4tsxnfNiMo3PwgwSAJlVrrVGsulTc/d3+mSZXRKFp0k/7+SztM0xL6Lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the mmap_prepare in favour of the deprecated mmap hook as part of the
work to convert one to another.

Since this is simply a refcounted kernel page that has been allocated, it
should not be marked VM_IO and should be inserted using the kernel page
insertion mechanism, so convert it to do this instead.

Use the VMA descriptor's private data field as a scratch buffer to store
the page in - this stays valid throughout the kernel page mapping
operation.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/hsi/clients/cmt_speech.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 7226677ebde7..801697b74d4f 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -1084,22 +1084,6 @@ static void cs_hsi_stop(struct cs_hsi_iface *hi)
 	kfree(hi);
 }
 
-static vm_fault_t cs_char_vma_fault(struct vm_fault *vmf)
-{
-	struct cs_char *csdata = vmf->vma->vm_private_data;
-	struct page *page;
-
-	page = virt_to_page((void *)csdata->mmap_base);
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
-}
-
-static const struct vm_operations_struct cs_char_vm_ops = {
-	.fault	= cs_char_vma_fault,
-};
-
 static int cs_char_fasync(int fd, struct file *file, int on)
 {
 	struct cs_char *csdata = file->private_data;
@@ -1256,18 +1240,19 @@ static long cs_char_ioctl(struct file *file, unsigned int cmd,
 	return r;
 }
 
-static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
+static int cs_char_mmap_prepare(struct vm_area_desc *desc)
 {
-	if (vma->vm_end < vma->vm_start)
-		return -EINVAL;
+	struct file *file = desc->file;
+	struct cs_char *csdata = file->private_data;
+	struct page **pages = (struct page **)&desc->private_data;
 
-	if (vma_pages(vma) != 1)
+	if (vma_desc_pages(desc) != 1)
 		return -EINVAL;
 
-	vm_flags_set(vma, VM_IO | VM_DONTDUMP | VM_DONTEXPAND);
-	vma->vm_ops = &cs_char_vm_ops;
-	vma->vm_private_data = file->private_data;
+	vma_desc_set_flags(desc, VMA_DONTDUMP_BIT, VMA_DONTEXPAND_BIT);
 
+	*pages = virt_to_page((void *)csdata->mmap_base);
+	mmap_action_map_kernel_pages_full(desc, pages);
 	return 0;
 }
 
@@ -1353,7 +1338,7 @@ static const struct file_operations cs_char_fops = {
 	.write		= cs_char_write,
 	.poll		= cs_char_poll,
 	.unlocked_ioctl	= cs_char_ioctl,
-	.mmap		= cs_char_mmap,
+	.mmap_prepare	= cs_char_mmap_prepare,
 	.open		= cs_char_open,
 	.release	= cs_char_release,
 	.fasync		= cs_char_fasync,

-- 
2.55.0


