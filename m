Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A105BCC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31646B00AA; Tue, 13 Oct 2026 11:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE1AE6B00AB; Tue, 13 Oct 2026 11:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0416B00BB; Tue, 13 Oct 2026 11:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7DD6B00AA
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:24:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28723140C77
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:24:28 +0000 (UTC)
X-FDA: 85317974616.30.FA140EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 625944000D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:24:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L4uqKWKS;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c4rVcjUdWsmZgXR37AiCsblE6rTioP6R1HOXCFtz8Rc=;
	b=RhZ2es46O8xW1sP8vlxwFXYiPXZA9Uak6iL6PT8HJ9iF7zPKWBgg0/nBp72z5DX/7Futby
	bbrK6+tI9PX7nLR1tR7ZmZRq9iTIvOeG6e5btTEjsv5BiCCZycinKlQj39at57nQTlbwME
	RGThIofgP+fbZqvJtF6uFYgMRqTEVgA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905066;
	b=Ro8lFpmNFkoksmO4j4Qhj82QE4vv6Oato85zPeKhQ5/u2mQghXW9gNCn6HYHgVecVkV2DV
	pObt3O/DxGBB6kJ5JDRW4M+ve0r7x0GmtTu5oZQpoocJd3QXKeRk5T51R1nsGPTHbencRM
	HUtlHTLo3jSHx+qZpDkaim9ooYIQp3o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L4uqKWKS;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F288560A52;
	Tue, 13 Oct 2026 15:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AC71F000FF;
	Tue, 13 Oct 2026 15:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905065;
	bh=c4rVcjUdWsmZgXR37AiCsblE6rTioP6R1HOXCFtz8Rc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L4uqKWKS9/emjCwZ6ql1Rngkcefwxadbj2YCnmnNYIqciykzVO3r9n3a1kI1Wc8/v
	 pl9+Z026A7Wd99YqDlk/w+flWd4lTTxfZ48mxuxDthLUuk6LYacqflyrOLKPqYaJZZ
	 omqtFrV79COMPMT7LVCyNVrlyiTTmuzRgt9IfwRHJycizVUkkXgSzPQrbVEMAJeEUP
	 BbP5knG7nsw17y7k3BUf8+9e9+2xWWMmjmvkSw266Xxlae3P8KckZETttYg6ZhhnDR
	 G9bLGHM9X+HkvIYzM1tgRV6/E/g49SycB/GbPo4L4HCZGcLzi8zhn0/0eIXG3vEtcz
	 bIdqvwIniBgzQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:15 +0100
Subject: [PATCH v6 35/39] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-35-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1459; i=ljs@kernel.org;
 h=from:subject:message-id; bh=xwh5wt4sdgjg4CaLiq1dR0SENifKfETJ2iV6aFSDKR0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZzpO7TT1uLbDaHwqVfdp71NnXRWZYXB2o5ygVs/f
 b3E3p+f3lHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJcPYyMswr7d1m7tPoJvY9
 eEvozcqrGhefd38y3KMop/9JeOpB7ruMDP27Y9jecewKPOp2YO2lqwbZ3XV1fcVL70R97RS6N5u
 DkRsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 625944000D
X-Stat-Signature: kkkqd99tism83ouh1zx96397pmjhqwou
X-HE-Tag: 1791905066-361620
X-HE-Meta: U2FsdGVkX19UMBdhg4/VjkzDrkEDl2amWgVUJ/asOMCIDLGikAydFvZI/s6oRS7HWhpzdQSPS85YH0XKtibuvQWehbOL3R3/MOMBFTf1gB51LExDvzvnIUni6Cevq/CZGfKv9lPbiVGe0zl5WxiCxf/y1fOAPsaFkKIR3FycI0BxyEnSTh5A8dooQ8Lp8bglqR4VMYd0HpJHlJEuZ6DszAnzSoU0RnbZBwXVJew2kCQcauxOm0LlotI+u59ZH/D0DVILi0P80NicZmKa/KVTT4k3jJS5aCg8JajgPomtHR5Ki6RwJ4TXCLk2ZUhHSgayF+MqW+t4vL8In9MZs9ObxgdE1BfZ+Up3MMEIjZFZpWueuF0tkSPlvJIAar2D4vcmdFj4140yW8x6r9r2c/p66bg7KAF9DRYdc4c3WZY29qYcnAPbcyb04exWgmPM41rrEEQ/FoUbyB+BAt+CdXUdSTRGkNaFDDBNKgND117AlG8stZo3rojHkcl286/UNRM3X0wNY79S9caEzBmVlItWc3J01Yjo9Exz0najjNEPCGpIvSpqfA3IrBvh5pvKJJ9hg6wnwd4zuq4Mc7L2zHilfmY7VHfs7QDkMw0csJ9PuBgYrwDkTvNywN49eYguc6ExK9oWQ7ntG6PqpJPtbqTcWqiQU6AWMkK7w0EDEW/QTQrVY5YqlMCBCskVsz6nX0G2hdeLx+yavIeB4F8TkQfm+3aSfioOXwfY6T20jTHjDbBVhi9t8dbfh2m4jqzKK0K3ROx690fM/diuqpgd4F5jpmdEf1awbbxsJk01l94Aj5HtzI7/nSj+I2VFlGQAxiNnQz+ay8YozfNepO5FSR/edURwLbZ+V3gGcTlju+gNteScvw1uM/KkYWebZRvAzEpRSmOkHa2PZlm5aeSspTmT2eFcINVJFFqy8O7vnfVPL5Rr85ALHUuYQ+8WuyYWBKCvIJi8Cb/Ki3kEgPuWEK5
 vcsF0cEz
 OgkAYP0YfUdlGZM/NHodO5UWl9UgJNRBNxOkVylKcizJcuptEKWignvt3F2t8bJH/jMgqX11OenMikrftTnpOni1cLMewnQnMxUmmtuHL3iegld69pYELCjn58fqTR//B+G1pI/9A015rXK116EB0syzF9WAWEUcF6afr13eTJhTiUqBpO34ffk25KfDO0rVGZqsd2Cjlugf1QnyHWrYYQF0bWgrzGl6UP5KEitlxz3JuodqIokKySKL6WSxnE66Nn/ZLcfaYU24yLizfA2bJDWOpJQwIU04cjra5VVZozklKsee+L+65hYk+mZlM6pHAgDgcLVfQXHjTKjCbxW2L4MDxeZph0uyvzYOy9jD1HM92TJwju3pIQ/t87+2BorL3O+LYSF3+n/1/zJn3pIgj16+SkDEZn3bNUYoFzhgBg06eL7opc57nV1CiBNt9xVUr0kBk6QY0sLfeRtbOlEqvajyLGW2K5hMK/21YpaJJYQFMgHLZF78BenmJfRAUv6hGxuPfih4zqEfarlT67a18Jx+tX3APenhJMSCQsTMjHVQxgpu3wswxm2lAh4agIqcXvlTy2G4gFRcaReTV2QpvTjEs2GaEDfY+xZcIfMCx4efVhsSMHpJzZbSHfx6lWSns5wPzfyzfi9mjlJBGp7LmcXRL7NDyNs7mLKXGbJlLRk8Vt+qHFNLhtSxJvmGmAr0r4DyZZW7TyukJS9Xdpd7t2vibOuz2IaQXBUsq01WakgFhnIlbN4AoIZBt+D6iDppj1VVhCTHgjJHb1tcB3op+6S5MdwNkqg25sNXzA4ZTTZiopJ2l02CDPiynRn3VW27j1XwolfA5ixfaNp3OARG/oPneMwGOXgAgM6DekxyfzR5MVYP6RuOJHUZk+IId2avYUzx5UkCiRVAx3VCrESpzfH9LAdJNH40VPCS0Ay08vwTnLtGyfQEgCmo8YO4044k/7Bs8wA+be9oB90QSUWU3lPN1gXkr
 4/MgQb0g
 NdAbmwwA/bltI3+PfKectHzp+KcFMWleS0Khd/3QyUVVAcEyFW/f/0ThkFArBd7yquJIeRSoTKPg9CBCcLvsgqqRpMh2QlgtZbgUJLmYMusGWRpKX9DSjbMHb1oT3ZwGccmPs52y/Bc4W3YHDmNqVlDlI09JTryGQc0c9k4QE6fTzDmkxHeNFadnOYmc3fIp1bRGgVBWmSM+WNCP24Pn9R9AAPkA4gCAxCUO5ZbPpziSlmQ+zmvxDP7u3uC+qFgGOhWfDbj9KNqnrxmilr14JlJ908QBNbDzorQOTC6VaX35Sd+7SZVwNuEZkV9lteqtCGU9zENsYVprZB9aEIJudaTofEzH8icdQVjvJCaxNe+d6mfy3wyPUVMF7/ua2E3SoWrJ6ngLbJdTarAcoeNisT3zPoyWIZHLCcIfPN2KYnODA5Ezz474FK0qTIuRgJMko3rcyN8dbq1Y/B5ZKQxLK4WA9kM9HpfHvVoLpthK2WfFEJ3HRSR5giPEezjeqtVpNtbj2gWSG0+ChCaYipd0Z8JFZmMBkGQod8EF+0BdxvnrYMNWxYv8LPoCUMTEfUGcIKgXx1ONeJ1NMdsszE2a9zi5tW1ZNqpgcmAmbXCSHdlI4OOzr1CK7I/zxJmIVq8I0KzwHWCIL7HpJGNKJsivI7u6HJrluVBQ3n9F9709dq55SvPLV+KlNBtDab9KSFt+U/2u7j8dW0c4Ue9yd/LhInZpQmSaC0TwJ0kU0Gj5CB1B7XxI5JzvSTM0jgnDeh1QdUoBp78/GBpQ37VhWXJYj+svjIef7pgR2heusvd2iAfq8EJ+i4q5StIk0Zt+mCcYQ5Rgp+aGlhyYZYCJs+x+AoxAPjpHDk4HhQOx0UWcyyEOVrKgHd6osuwzb9GJ/Fi27tY6+CMwLAxxFbV4ul6h8/9yqZ4jvrNsiT4nDTJk/pf1JGbtVYilMSfelXmwEuQwnvjQi3bSWksC/JsN+KuM2ZPWmob3R
 zcP8veFV
 QdZNYOBrwkJllqpYktmcsaMyjvOA1c/hMg1kXJBWja0O6STysb89I7GA8Ceu2AeGB+2FXDNHgOjn0Yn+q4z4bw9V1GtUQCdeNKOqCZw8/gP73H9jyFp8hc14LVY5LWjO9+tWFSjMlxz/FTCK8LYe9d1lAPwGpkEHrQn8NNRfnp1ldjrDbdEoYi/TeRRGskJ3J2styValRYO+kTtD7LxfnIifUwug0KMPq9iNODgxtgtRGLy8oVAXQH7k3p56aIGvtsx6VbObFN6x1WeCQ2xZAbslkDBSJ6uMjN5z2htGO5aJmE4IWUZ3NsR+Dx9Oz5HQVUo5NUQVO88lJfguXv020k1Y6CwiZNgNmexGt62TKwxaCPTfDOV+NRrFzGSCWgNc0dX3FnwYpfb67ro23F7DR67zzVp6NfapbJMdhV0UePwf9T4jecrqljViRlNv2Q5O9Zkh0kR75+E0zVbibWXCflA+6wJ6NYLvSZHUuOH24F47cOPTUp8PjpzNLWQYGQsDt7AoXzMtIgbnn5savwnWX0WlNndtWk1nHdchXLxC14hzBio+18SFELheEfIz9wCyPOBTh1Dym7IcHd0m47yt5B2dzrTrdvF2ZgqP+o2Ct66icZYbzqWGqM/2oAEGDxvIB8m97DhTuLbf6GQewa5CYaa8B7ravhqEEJ9NULMJvfdBt8vQBoMrP29rPvYQZN/x4aOXPeEdFXVpyC0ehfz4oiYvQjWeOCbF/U/gwvbuq2ntdv9YdMTcAovBtr0Qjcwk1wV+2xDmR0ZO0fUuTTcgiC49zEZGZZYK0mJ95UY3ynSU0tcBWl804fjj5ssU3bgK8lGuF6X9Na5ykaECey0oDcKZmrFqrg756PSYX+o0jhHThbLhHKDOT5s7679tgR7wpPhSKz2vP+FP6GFe2QmVKoEWRjJQkLcSek7x6gHF+DX+YgaHC9Hh1Dgy3ipwRyE/gYj2x/GzWE4qckYCipd5EKhNUH2Ik
 /cWLTplP
 xljclwMLj04r2m3K1zRHPzYK3knNWxiCIqdskLDzgFEXrto0L0cNS8gXkK8nUbvxCXKnY5OBUyzaS+90TdCxbyI8iFpBOBiD76nnl7QDmHmA7uVHR/9zwSsciIACnKKZGnqcZB2XKSM6mZDUnPneKpRp0nkqcU6dH9Y+maos6z7ERHJKEuHETCaXXhObng4PK0avu1rZJHteKRnKIkNmKMfhoKrZqcJgkc1oiHf17jq1WmthFz0VocKgGrKoDp7shiYlcf+B8kKSNbGmbUT+5+qQQ1lXfLY3TowOnQ0u+2XGp5E3rMIPo7HsxrycmaTA+tLO/X/wBRHOkRUB5d9vvcZckT+2UG0WTqPeaEuGWFYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A fixed or non-mm-managed mapping is one which sets VMA_PFNMAP_BIT,
VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop as
mm-managed mappings may not set it.

This is equivalent to testing for an mm-backed mapping, except for hugetlb.

However, hugetlb folios are never placed on the LRU and
lru_gen_look_around() is only called from LRU shrinkers on reclaim so this
is fine.

Using vma_is_mm_backed() rather than checking VMA_SPECIAL_FLAGS makes the
check self-documenting and helps eliminate confusion around 'special
flags'.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index aecb157bc379..178a5de6c439 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4417,8 +4417,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	if (spin_is_contended(pvmw->ptl))
 		return true;
 
-	/* exclude special VMAs containing anon pages from COW */
-	if (vma->vm_flags & VM_SPECIAL)
+	/* exclude non-mm-backed VMAs containing anon pages from COW */
+	if (!vma_is_mm_backed(vma))
 		return true;
 
 	/* avoid taking the LRU lock under the PTL when possible */

-- 
2.55.0


