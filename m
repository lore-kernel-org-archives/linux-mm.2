Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA4DCCA5FED
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F606B0098; Sat,  3 Oct 2026 12:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2ED86B0099; Sat,  3 Oct 2026 12:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D05F6B009B; Sat,  3 Oct 2026 12:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60F9F6B0098
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:34:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7A2FA07EB
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:34:12 +0000 (UTC)
X-FDA: 85281862344.20.7FC7BE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 25B05A0004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:34:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XBJ7eshz;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xrjMC9Dpjbm3TNXkJuovzg2js3tKWqimxWla/lyOj0=;
	b=XXLO2XliLpcj7z45CxcSwbGEgyg7wXm7/iDkWQdyab/+JuDyoD8DxzyRPSu50Jc/XnU5em
	VW9cIdZWmTpdXcsWZAb2z3Cz1TnnWF5u45Wwz5pvS92v3SoKugTeck9h0MoxO6PKOk0Zgh
	fPprF6bgNxrqpn/DeItcs0Kzj6RBH/Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045251;
	b=vFEg7nqrngDoz2yU1pJu7yz+E4VJIhTuIGzA65B5AJxR/7/ItpGoW1R5UObLWsDoIjgtFr
	GRbBhTS71KPrFYast6xX27Q58AbB21iVI5kh6mTM3DVQIXngZJddVGee3dlhCnOtrb2qy0
	eD6zLVyyTH2xK0cpvc9J1lsBIiU6RtY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XBJ7eshz;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A368260DA4;
	Sat,  3 Oct 2026 16:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8176A1F0089C;
	Sat,  3 Oct 2026 16:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045250;
	bh=5xrjMC9Dpjbm3TNXkJuovzg2js3tKWqimxWla/lyOj0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XBJ7eshz/9dTPjcgfLHy8XrV+pu6w6B43PpbsusQS8RmMTtuzVx+nc32ZMdpVijr4
	 nLnpFKX1qcCfP8/QynCo3EBzDvCP5GAdinmpRw9mYhuFzns/eLyKQNhv0gPu7XDMV8
	 4E6DhvOQfYrA5wCAVNrz2G5K93fH559419VunofCiCEUbjn73VRCMsFBoYEM+m+3so
	 KMdFXiHxswpGeU0ViXRbWa6P2pqT9Js61f+CWSny1A+9riDUMJsuvDyqFNwXhWfyLn
	 MMLhgS2F28vjbWurLQEX3CY0MVa1BFopzMP0dnIKvKHMJSHrg1o9wvnPQnHiAcldVC
	 +L9lWrwAsA/Ng==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:34 +0100
Subject: [PATCH v4 03/38] mm: consistently validate VMA state after
 mmap[_prepare] hooks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-3-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=13708; i=ljs@kernel.org;
 h=from:subject:message-id; bh=HxQzct8KQnxQfww6ezrHr+Qrf9mgNA9uFLaUMEi/5mw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6ql9rQp5sahx7QLv5XUu+w0tHj707jkWLM/h9cMss
 3uXS5txRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACaSv4KRYUXR7aNTJ/k5mjqp
 mffMWLKP/8H7yQLK7dKKkTL+5lGbpjH8rxWrNv/f833N9dJFEe/sKudobV6b+aHUbbvycnfHeYe
 qmAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 25B05A0004
X-Stat-Signature: pknoy8pzsua3jwoyz4c58xqw9q6u49z5
X-Rspam-User: 
X-HE-Tag: 1791045250-276102
X-HE-Meta: U2FsdGVkX18CA9p1hAZqLVneUl9EkpWyuZ2IExQfaTQxbdokYAJQ/vbTKHi1ysD3phAbMKJTVoesdxg+RD4MERkUzVvt+pNfvhon2alcYhC7J73D3jH9TNr6RFGHxGl8thbKyacQTwglb4dW0+ldZtfLnOmBqN7qyqNyW00whRcT916N2pCfhmWCTwmM0qEbM0925vXyyfO9QegfLZicqs4wJsqEs0F5/eDmgmJ2+wfDk5tyytgjTWEyreGNTbCPKKTOs4PmkAR7lAFGF4ASfV0prv/8Rnq0YiRGA81sWMU2VRfjxn5XvKIHkEam+I8jwedPyyifodA/uBk7F0WA6nrcCdtzOJr+l0HGaOoNaB17M+4lRwJfNH3qCKZjrU/YgexZDjoB/2NhMvldBXRsdsCY3anX3iUOPS2X1zMZ5YBpf3EXAsx/KtcLgvCjvPbOXk5I/NG42dmXVNtOEGr+BbZQn10qU5h++aJs0rh5o/MDPLE8OPp2rbPwL7PuWet2LqPnaTA+ny9YkFSYN5ROXZxy0Qbd+H2XPm40bXBGrvWu/h+XY/3r963dQOW3JSUj+UY5wU/HxymHmuUyVzORg4Vgb9YDfRC/3KB7NHc9Dc/niQEBIT6p+zc20mrS/KuwdJaPtCA4gMHuAhPRm/pd8536UETWX5rO9a7DoeAsavt15uSUnDZpkS68cAlStETcT0z7iAifrfOzmYfp4vrtMOJsjlQ2TgnxICE/xoDedCkooqKgAEAozMzGLaJFT/ZOJvFwDWQ/P+Vty8UyjP0VwMqhm2sB5v6V2TLiQSHGbH5JQdLQkMTj1hEoD11PNoGn7wcYM9N1k7JPcJ0n7MMKF+5k0cMEPVcjrZxztI0v0N18Wp74w8PDDpCsPbh/0EfDoCZgX5hLSMyuhS6pPb/hcqpHPnxMz7Rm/1aJ/pEqcaAEtbobj9MOfkhZeIEMln1x71jAUV8Ir8N1vcSAOQ1
 aX9ksr2y
 56o3Nd6Inz5Ya1Z1NPmCoilKnMMGLs1ZposGUnItfZ2X6Xtxskp1Uo0aiznsXOxTFa7I+JXZkV5LCwg3QesIl4ArAGBDCkMJNIa+HDH+u+9Ui5HefJLEQXY8OOsGvTZUtb12W3yrnFU63/bMD8lYCi8iEp7TDDKUAy/0JJZTIjRSS0KkQzb6uvhP0RFzO4x8uoy49xWTVLIVOlfLcAnZCizIOP8cmYRSJC1eVUenPM5grG15zDuSh6N+Nf5wwrhzEIbqZ6z/7KYRgLUuuvTMULeazWmIfA6QJhTJQmbIFkZjTWS/G5e6k7Gqf40bPL+yxmcrD/nEjIx46z9xjJjcE1axCYph3ZeTAFqa6RxriFxrk32gXBTvoPxcP13BevQ883a2vb8rmRUNuqrRCyllQE3Whg22HBpefyn29lxgNIdk8w1xIgHH7faY4SL+/JpW2I6TDOto7cEqA1fW3KC3VECQZjP9g312oPPWHR4FyaW5YtYYP3mGr64g6sCxFxvUHUcNv6danKUt9jn2Q2I5b8yDbUlKGvCOogXThGNDv8RMfGDzs/YWo03+TiHisAxXA7YY0Vannn5F04F3raXsv3dcv5GxahTNuj4OYoAS7dcOwr1Tzw/d8iJLoIENQL/xBVAYMy0COANlQ6Sek5lTNhEFkk5dQKaJbFeafNpsZF1XTERszOCEHYS9TH4O4dwSXyGBMfNKXZcBOpOhZFVrP60Z74CLC9BsnoZuFlUpPad+OVSqwmg5K4QxNcO+dx7QhTcjKGEvXDwuqG1kTXvVz5BDoX/C+KJr5tTo45eli68NsDermPj4oqoYvP5cwFuueqIfC/FTdt+rBda8YJIKSaVF1JGL3PK/ig5AJJJupxh9DcXKPeeay5oyImZcoa2PFrt2JuIvH3Y6+AC/nQ0RocRP35XSzYPRj6IrwPeLfL0tk7pixLZDNdbUVrJm4npMuIdpJd0VtzNubc3T9bCy5tY/ujyh3
 utuG7gAR
 Yw8SrxX4lHlnrP+Mm/KUJNvM3HWzn/km48yAm9Q+ntGCQxPHCcPrjveP6bbrfNR3VMcNGMpu/C2M0W4Hi285mhxM8TwYtdWUS0/3wJU4/Ya/xV1hHsEf4CN2AahdAwiy5xZdUMYGBNP0wQgDMNIuFSCvobXtpdkJg5PKO7nMjuHAEdLOZiCHPuwOXS8avhR6InCeWcf5DC3BHmSFQwnr6jWBAxcoBP/mbcgDrNWPkKCUYx8zd/WuwaulvTwSOddpCpm5VKcQqkfOi8JHy/Ff4QwWB9YVhIsCtaoZgk79t9NCO1nvYBAtbyLC05vc/+V3fzokl9k+iOqXDt2YJITLkccYatMrHSXBvT0IugPRojTf9tXwWiJXWO35J2c4KjCJGrrMHaIJwP0OZSuOew1AUmWn2GJVdgMojf2hJydgx2c5LjgdJ2RQsdeYKSkJr4Zt73Z8cwCYdG2ct//jf9/jE6z9qpw1gBtvekHz1mFcbjY3HqVr6IuDMDoEB/XOxN+epHT/Wff9+rz1QBrHzcdWfnr8vSMH6i10JjFYBvWHA3aEXBktq3YcXModE0BKCAlbyXpvzKiDmF8dKj5wwAKAdVKckU4HxMKPIgNv73Lq50HdCm0zzHO0xI9c/9ILXZLDjrigLRCcY+zmmRTOsCxPL/LhOEYROH4iIQZMIV+X9E/hC4Bh3dtzCZwSanM7RrfaSfORb3/x1GZMCMTNiI/gyQ1rwErWKBR7YsAIRjiPX9/NBdyOuv1kcjinbwb0ZAlkPnlaCAQt6AIgEySUydd0wTmcroAGIPl8MNRyWVkGjOkTbYQQF9X6wgPL79nB0DMAZz7AuQOMOnFEv6smJck5p8P23oLoTXzvVjU/D1EjSmgMtXdLQftmOWN1zDEbXEz66HcfD1F9OrE1A7g1Kw2S926Ng1J6AXThDjq79sOBOt2xSk8aOTCkrM+NLOf0BPhZefsCQSkxPuPdD71rF2Xp+WgZ+nc0G
 Un7CEvMo
 MJH9lOkK3jJzXrySB8yNI75Zp2Nf75achzIqKGmOLRJ42fJZapc29DiAFBKs12+sXy7YuqiUwqa187NZhSoZitKSwq5LikKM2cG4p8dRd5cxLnB5Uyz5bY8GoeiogOWC28WH22BHS1aTlL8XXx/qtO+gTXkZF00vVDr4J3YqFXByQJikfZnD7xS10PnMZF4gjn9WX9FgQ/spNKeIPs02mBjGwVkcZIx2V779mEpnW0TUiwnGH0vN3M1nqn9At82C7qKjwboZxmZq8bluGK+fynuwTgEDlwSTsGAT4/D2Y4DAjScm+L/ygO0qwqlvZL+qaRW/5RoI5KmhYYwI1emgN061xQfTlUwJsRxjFyiyUzg67HZF0+p+3wyWoHShzOob0c56PP6pvpnw+nqQqhTgBdWQ3ggBEGn0BRrn1rHL44X8if3j84nZbw+S7grI7zBcXRXFDY8+xaOFePP+pwJu0ECKO/NTnHpui1paoFaZv8z9vK+8eV3Itrt48DGpnhYI+dqWkC8C8qyadgSIq0ix46uF0jJOgFUCuprlFXxdzQrCciObn2l8y3mftSQJ6BNKuMqv2qFXzG4FZJCaVPqhESct09Rp8V6MqHLGi4BG9PS00qHPatcQ5CTH5ynpmfe2mp7YDMabo3nwtiTtKuVe5MYJS5wXErB4ZZQKl8NVVuZhciVNH7znNdNfB3CExYihu1bVQWs7x4A851JFiotNXkofeecwH/z+xBsB32G6pt61+TiaFqQJKWNVtWPdXAcNejugYcSBwEjVtxyptI+dWEOQoLl/g049/f2U9WU5k8VLwkkDMoVeXpvjB36F981dIfI0DyY56md3pWT6fWZEpD6gYBjcJ7gIw6TYqf6VjhVzsPhII1J1oCdjPOh1ItO1mC2KXvHBx065nz9giB9O+QitVdaSI80XFRzj3cIfmevJNZA9qtfW/8NDDQWkfmaiEDp89Cv/bshbD2pzq1uBDoG3YhBFT
 lg7fXXhM
 CyQ2Vjvgg4u4eQLu+U+BYqu9PVfMVDPLUxs2iW4Erswfq6ExyXB3b8eMyEBjQLkW95vZj0hAFFNP79TUhhmPVBLFtSPTMw3VSQ40qgdm4b+xJk6lfTM+v6lwl11ocWXUK18+lXyHLhiUaqc3j8eliXCRNVX/1bH9QZaUlUsuYWHUgUPopd1mv+N7VDDKHggrg8UAR6ex4MxbWRKromPhGSFVsbctfgnc4+JUPoJQ/s2oyez6ur9S0NndzbW/iN4Iugbm5R3/7D5op7czVPe0snsx6WLKg830ZqiQQOm9WbeCcWOejQpZW9VzDChErbYtbgFdPPwjoxz5MoJhhQjLGRYaIDSgUyNEW6ShvvezLVzi/EBtWsPPL+n9DNLc2EWwI7ve8uBFPxb8SSWHSMKPFeVL1y1TPqRwUVVEfgkasUwLbNvP1MqXrigwSATEDhDJFINEDP5/ux9KdwLxfNy2PI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked, the
driver might have done something crazy that is not permitted by the kernel.

Currently we check for three such cases in __mmap_new_file_vma(), but only
if the legacy f_op->mmap hook is used:

* Did sparc ADI result in invalid flags?

* Did the driver alter vma->vm_start?

* Did the driver make a file-backed mapping on a read-only file writable?

Generalise these checks for both mmap_prepare and mmap and apply to all
invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handling
in the core VMA code and the mmap_prepare compatibility layer.

Also extend the vm_start check to vm_end also - drivers must not change the
VMA range at all.

We also WARN_ON_ONCE() on these conditions as they are things that should
simply not occur in the kernel and it's important to call it out when it
does.

We invoke mmap_prepare_validate() after mmap_action_prepare(), as mmap
actions often manipulate state in the descriptor thus providing the final
state the VMA will be derived from.

Also call mmap_validate_vma_flags() in insert_vm_struct() to ensure that
special regions which are inserted (such as a VDSO or VVAR) also satisfy
the sanity checks.

This way every VMA established through an mmap hook, whether via mmap() or
the compatibility layer, or inserted via insert_vm_struct(), has been
validated. brk() VMAs never pass through a driver hook and so need no such
check.

While we're here, also fixup a couple disjoint blocks of #ifdef CONFIG_MMU.

Finally, update the VMA userland tests to reflect the change.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h                   |  50 +++++++++++-------
 mm/util.c                       |  19 +++++--
 mm/vma.c                        | 109 +++++++++++++++++++++++++++++++++-------
 mm/vma.h                        |  25 +++++++--
 tools/testing/vma/include/dup.h |  10 ++++
 5 files changed, 168 insertions(+), 45 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index fe576d468af4..061a87f9c3fb 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -213,6 +213,24 @@ static inline void *folio_raw_mapping(const struct folio *folio)
 	return (void *)(mapping & ~FOLIO_MAPPING_FLAGS);
 }
 
+/*
+ * If the VMA has a close hook then close it, and since closing it might leave
+ * it in an inconsistent state which makes the use of any hooks suspect, clear
+ * them down by installing dummy empty hooks.
+ */
+static inline void vma_close(struct vm_area_struct *vma)
+{
+	if (vma->vm_ops && vma->vm_ops->close) {
+		vma->vm_ops->close(vma);
+
+		/*
+		 * The mapping is in an inconsistent state, and no further hooks
+		 * may be invoked upon it.
+		 */
+		vma->vm_ops = &vma_dummy_vm_ops;
+	}
+}
+
 /*
  * This is a file-backed mapping, and is about to be memory mapped - invoke its
  * mmap hook and safely handle error conditions. On error, VMA hooks will be
@@ -225,8 +243,12 @@ static inline void *folio_raw_mapping(const struct folio *folio)
  */
 static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
-	int err = vfs_mmap(file, vma);
+	const unsigned long orig_start = vma->vm_start;
+	const unsigned long orig_end = vma->vm_end;
+	const vma_flags_t orig_flags = vma->flags;
+	int err;
 
+	err = vfs_mmap(file, vma);
 	/*
 	 * Either we tried to call the file hook for mmap() and an error arose
 	 * or a driver set vma->vm_ops = NULL intending there to be no VMA
@@ -239,26 +261,16 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 	 */
 	if (unlikely(err || !vma->vm_ops))
 		vma->vm_ops = &vma_dummy_vm_ops;
+	if (unlikely(err))
+		return err;
 
-	return err;
-}
-
-/*
- * If the VMA has a close hook then close it, and since closing it might leave
- * it in an inconsistent state which makes the use of any hooks suspect, clear
- * them down by installing dummy empty hooks.
- */
-static inline void vma_close(struct vm_area_struct *vma)
-{
-	if (vma->vm_ops && vma->vm_ops->close) {
-		vma->vm_ops->close(vma);
-
-		/*
-		 * The mapping is in an inconsistent state, and no further hooks
-		 * may be invoked upon it.
-		 */
-		vma->vm_ops = &vma_dummy_vm_ops;
+	err = mmap_hook_validate(orig_start, orig_end, &orig_flags, vma);
+	if (unlikely(err)) {
+		vma->vm_start = orig_start;
+		vma->vm_end = orig_end;
 	}
+
+	return err;
 }
 
 /* unmap_vmas is in mm/memory.c */
diff --git a/mm/util.c b/mm/util.c
index 016932780925..d809e08c7b4d 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1224,19 +1224,28 @@ EXPORT_SYMBOL(compat_set_desc_from_vma);
 int __compat_vma_mmap(struct vm_area_desc *desc,
 		      struct vm_area_struct *vma)
 {
+	struct vm_area_desc orig_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&orig_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
-	if (err) {
-		if (desc->vm_file != vma->vm_file)
-			fput(desc->vm_file);
-		return err;
-	}
+	if (err)
+		goto err_put;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&orig_desc, desc);
+	if (err)
+		goto err_put;
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
 	return mmap_action_complete(vma, &desc->action, /*is_compat=*/true);
+
+err_put:
+	if (desc->vm_file != vma->vm_file)
+		fput(desc->vm_file);
+	return err;
 }
 EXPORT_SYMBOL(__compat_vma_mmap);
 
diff --git a/mm/vma.c b/mm/vma.c
index 8f8c554d5c07..159fd3ff8560 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2613,26 +2613,19 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	if (error) {
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
-		if (map_same_file(map))
-			fput(map->vm_file);
 
-		vma->vm_file = NULL;
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&unmap);
+		/* Only safe once unmapped. */
+		vma_close(vma);
+
+		if (map_same_file(map))
+			fput(map->vm_file);
+		vma->vm_file = NULL;
 		return error;
 	}
 
-	/* Drivers cannot alter the address of the VMA. */
-	WARN_ON_ONCE(map->addr != vma->vm_start);
-	/*
-	 * Drivers should not permit writability when previously it was
-	 * disallowed.
-	 */
-	VM_WARN_ON_ONCE(!vma_flags_same_pair(&map->vma_flags, &vma->flags) &&
-			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
-			vma_test(vma, VMA_MAYWRITE_BIT));
-
 	map->vma_flags = vma->flags;
 
 	return 0;
@@ -2710,11 +2703,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 		vma->flags = map->vma_flags;
 	}
 
-#ifdef CONFIG_SPARC64
-	/* TODO: Fix SPARC ADI! */
-	WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
-#endif
-
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
@@ -2777,6 +2765,80 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
 	vma_set_page_prot(vma);
 }
 
+/* Check to ensure that the VMA flags of a newly mapped VMA are sane. */
+static int mmap_validate_vma_flags(const vma_flags_t *flags)
+{
+#ifdef CONFIG_SPARC64
+	const vm_flags_t legacy_flags = vma_flags_to_legacy(*flags);
+
+	/* TODO: Fix SPARC ADI! */
+	if (WARN_ON_ONCE(!arch_validate_flags(legacy_flags)))
+		return -EINVAL;
+#endif
+
+	return 0;
+}
+
+/* Check to ensure a driver hasn't done something crazy. */
+static int mmap_validate(unsigned long orig_start, unsigned long orig_end,
+			 unsigned long curr_start, unsigned long curr_end,
+			 const vma_flags_t *orig_flags,
+			 const vma_flags_t *curr_flags)
+{
+	bool was_maywrite, is_maywrite;
+
+	/* Drivers cannot alter the range of the VMA. */
+	if (WARN_ON_ONCE(orig_start != curr_start || orig_end != curr_end))
+		return -EINVAL;
+
+	was_maywrite = vma_flags_test(orig_flags, VMA_MAYWRITE_BIT);
+	is_maywrite = vma_flags_test(curr_flags, VMA_MAYWRITE_BIT);
+
+	/* A driver may not make a previously unwritable mapping writable. */
+	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
+		return -EINVAL;
+
+	return mmap_validate_vma_flags(curr_flags);
+}
+
+/**
+ * mmap_prepare_validate() - Ensure the driver hasn't violated invariants in its
+ * f_op->mmap_prepare hook.
+ * @orig_desc: The VMA descriptor prior to the mmap_prepare hook being called.
+ * @desc: The VMA descriptor after the mmap_prepare hook has been called.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+			  const struct vm_area_desc *desc)
+{
+	return mmap_validate(orig_desc->start, orig_desc->end,
+			     desc->start, desc->end,
+			     &orig_desc->vma_flags, &desc->vma_flags);
+}
+
+/**
+ * mmap_hook_validate() - Ensure the driver hasn't violated invariants in
+ * its f_op->mmap hook.
+ * @orig_start: The start of the mapping prior to the mmap hook.
+ * @orig_end: The end of the mapping prior to the mmap hook.
+ * @orig_flags: The VMA flags set for the VMA prior to the mmap hook.
+ * @vma: The VMA after the hook has been applied.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_hook_validate(unsigned long orig_start, unsigned long orig_end,
+		       const vma_flags_t *orig_flags,
+		       const struct vm_area_struct *vma)
+{
+	const unsigned long start = vma->vm_start;
+	const unsigned long end = vma->vm_end;
+	const vma_flags_t *flags = &vma->flags;
+
+	return mmap_validate(orig_start, orig_end, start, end, orig_flags,
+			     flags);
+}
+
 static int call_action_prepare(struct mmap_state *map,
 			       struct vm_area_desc *desc)
 {
@@ -2803,6 +2865,7 @@ static int call_action_prepare(struct mmap_state *map,
 static int call_mmap_prepare(struct mmap_state *map,
 		struct vm_area_desc *desc)
 {
+	const struct vm_area_desc orig_desc = *desc;
 	int err;
 
 	/* Invoke the hook. */
@@ -2822,6 +2885,11 @@ static int call_mmap_prepare(struct mmap_state *map,
 	if (err)
 		return err;
 
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&orig_desc, desc);
+	if (err)
+		return err;
+
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
 	map->vma_flags = desc->vma_flags;
@@ -3457,10 +3525,15 @@ int __vm_munmap(unsigned long start, size_t len, bool unlock)
 int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	unsigned long charged = vma_pages(vma);
+	int err;
 
 	if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
 		return -ENOMEM;
 
+	err = mmap_validate_vma_flags(&vma->flags);
+	if (err)
+		return err;
+
 	if (vma_test(vma, VMA_ACCOUNT_BIT) &&
 	     security_vm_enough_memory_mm(mm, charged))
 		return -ENOMEM;
diff --git a/mm/vma.h b/mm/vma.h
index f15faa83f3d6..89f831080bd7 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -782,14 +782,19 @@ struct vm_area_struct *vm_area_alloc(struct mm_struct *mm);
 struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig);
 void vm_area_free(struct vm_area_struct *vma);
 
-/* vma_exec.c */
 #ifdef CONFIG_MMU
+int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+			  const struct vm_area_desc *desc);
+
+int mmap_hook_validate(unsigned long orig_start, unsigned long orig_end,
+		       const vma_flags_t *orig_flags,
+		       const struct vm_area_struct *vma);
+
+/* vma_exec.c */
 int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 			  unsigned long *top_mem_p);
 int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
-#endif
 
-#ifdef CONFIG_MMU
 /*
  * Denies creating a writable executable mapping or gaining executable permissions.
  *
@@ -838,6 +843,20 @@ static inline bool map_deny_write_exec(const vma_flags_t *old,
 
 	return false;
 }
+#else
+static inline int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+					const struct vm_area_desc *desc)
+{
+	return 0;
+}
+
+static inline int mmap_hook_validate(unsigned long orig_start,
+				     unsigned long orig_end,
+				     const vma_flags_t *orig_flags,
+				     const struct vm_area_struct *vma)
+{
+	return 0;
+}
 #endif
 
 struct vm_area_struct *__install_special_mapping(struct mm_struct *mm,
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 2fd422789717..077df510a311 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1359,13 +1359,23 @@ static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 	return file->f_op->mmap_prepare(desc);
 }
 
+int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
+			  const struct vm_area_desc *desc);
+
 static inline int __compat_vma_mmap(struct vm_area_desc *desc,
 		struct vm_area_struct *vma)
 {
+	struct vm_area_desc orig_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&orig_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
+	if (err)
+		return err;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&orig_desc, desc);
 	if (err)
 		return err;
 	/* Update the VMA from the descriptor. */

-- 
2.55.0


