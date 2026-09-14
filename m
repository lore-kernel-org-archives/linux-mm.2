Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 523C6C88E77
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52CFF6B00BC; Mon, 14 Sep 2026 11:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE5D6B00BD; Mon, 14 Sep 2026 11:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7726B00BE; Mon, 14 Sep 2026 11:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12F1C6B00BC
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:06:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE9B51A0188
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:06:25 +0000 (UTC)
X-FDA: 85212693930.22.5CC77BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id CCB7A140010
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:06:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XONMabZx;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398383;
	b=6MwiA3qWhq/f6WtrmgvwCEqGAQWb01PpnvwS4XbOqJvTGzBGSxzkPxvuEhsp6D2UdbFGO8
	gTq5mQy1jd0mpDL9N/2ub34DUU9xfDXaDvEvSyStDqRNdl2L3BqESEWAPYPhD9dAJ2r7qg
	Uk5JtcYF+8QrBTq2YXUyjseeNZ753LA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XONMabZx;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=960UTemXLlYbejvF++nDfw4hlZnQCzP1Mhoxnlt8Uqc=;
	b=kcbNS1/U2F0fprgdQ+U3gZUlss1jhqfckBWBPrcUUxwiXQc9sAFgbeBucjrVRY4+kRdhAJ
	mRkcFIYouuZIMAa20ydMu2cd+mFvEg8sl1gXKHPUAimkeUr7HM+Ggfkg/EgYmLWO3dzVz3
	qpM7rKS8/xiXpERxm/ZD8hx9iun3mfs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7B914062D;
	Mon, 14 Sep 2026 15:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F73D1F00893;
	Mon, 14 Sep 2026 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398382;
	bh=960UTemXLlYbejvF++nDfw4hlZnQCzP1Mhoxnlt8Uqc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XONMabZx9a2tMH4C2B8NLveFpQiwpsb9v/absrNfv7MTntkbuo8zaX269YxgARiRW
	 Px/otvDFyxGLFNwGAiVTkFUVvE8SDw8kNQGm+XBLXkJuYHnRNCCMxneuB6eXBil2W1
	 CcWuu3UAsYQci0UW1VkyyLKK5Mie8vOwgoDrbKDZHI+tMSxDYzimAYyuEpV4/84ad7
	 vk2Ao2o/VGO5U5fQH+AK2T60rxC/fvRLY9K2gTjsnb75/nU2WpKtiDwUnkvN5TSth/
	 TY5FQ5xVgK7Hj3X1cfNFd+sL/ccxjs54mQO0NS/b9l5BtrdTD+GlTStU5ozTn7/DkO
	 Ia9bHhdQfYdlQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:35 +0100
Subject: [PATCH v2 15/40] mm/vma: add vma[_flags]_is_kernel_owned()
 predicates
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-15-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5411; i=ljs@kernel.org;
 h=from:subject:message-id; bh=YkBI9YfuiRUNJqQZzdNQ3yvqq1XQeKFLWKyJwcARZII=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG+wsVOSY4w5+8xmjzjHFyWZEPfZ9ns1W+frPlA9N
 104y+1PRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACayUo2R4e6dd/UV352+6G3Y
 EHeyNXL5p2U1Nqf2FW/4ep1xzjyBc3cY/gc48Ng8v6G85LnDN9XwxJST1VaLq0WL5/098tvlC6f
 wVDYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CCB7A140010
X-Rspam-User: 
X-Stat-Signature: fb69o4p59ahcj7aofobx7tobzwckdfqb
X-HE-Tag: 1789398383-393812
X-HE-Meta: U2FsdGVkX199P6iPLEoHjWLqeCimIZmpDhxDXDKkmR6EV2O0LRdOUgIuZ9OUHcFrwYAjr9JCn/KGM/VSVcC02tKFxCMiBIfLWTBVyEkHG/xzV3KzvSRZlYRzWHwnwN4naMig6H88pwjwyIZTX5XMqwapb/3FcZo4NFfTGpD64XCrpmFg+ki+wwnMqxQmcozDL5vc33z/lHQ/MusgE8U66BoC2QeyuObNcYr7/jhzVfy3ocCqZuyFP8m7x/tuiRW+dy/krpWd+zH0f2dGr52CYQCoaWKI0IMtFMpUp8HVUYnvrG5P6oDbRNXyx4K0r9iJ752w5HolGUBviqNWDd3q450+vYJZJZs0PmsFVCEMtgJVkYGc3gLQTotGYJyvrV+vI3bmueg/b1AT7fXyiu34/4Urqh6JwVaj5lXybgs9LXhnRj75SflSmiKLGhjBGeZxeEXAM+lbE8fLyUfhI+qTFb/puKUWWm2o+fSIbW6eb0xNNtHJPkTXt8vWWSJ+MfydOGS63dtzesGvFVxJt7bSN4JhzL8fabn6KnHMvEhurGhdFnQQqsXKopAkfjdnmZYczCrS5/ID0jUBhmz1syIjjQxGk0uojvJpUbR6GIo610/U8ZglUQb0/yWfBgp3hQwANYByeLv201+xzewZi6uN82DJz7dHFKxoS8cp9j3yKqL9J1qFDNDDxCQhSZogyf3U04YlsZZsv8FiFXnPVh6Bzz1K3V5h/ds5p0nX47QiOTlmvsZUTv1uTHTEz+bjCYUfU+N20eB5vlIqvSEPITw2RIod09MNQvQoMkYyJQ/pMLCd+j1Qchameshi46/zLzJ4HL9JU97nud1lneqlewNsnSwi6r8qUQSAV2IhArbnPaCs0S3wd4b9VghfdW6ZNU3C/ynxMkzFT7XxKlpL7pD0zSv3PIuXNBxWWkQ/UG505FKtg6aqRfsldkptDNHA5CL7WiIbiWOmskOtkG7EDyu
 0DFz0uzl
 5lFk8FSZaB5MzbCCpZNIAUPYpxi/VGx60YDrkT1QDPtwwhHbIMWCxavLGuYr5flULCDS0XW5Mc6IFmxRd4pBQGCbw+d9fy3+KmL58cWoyLnSmoxVjsg7XeLzwpyw9gn/SLQ9JvSjbg5zZfrkgqMZ9SjGYurXjbb43U5cwfVpZcAuvPLm+MceSbxM0RBLyXAui9pVl/mLkMMgOk3NFwqIXP3etlhGagWn0T8hUQY4wbbOtWZDeUU2z5aYN30X7M4hUl6vgfIfCAu8SMrsPzlQsYOKq/z6NkfsRkCbeK/4vJSABwa+htZaNLeRiDGGJAeABsWxKzyoACxTOA1nTQ2kUWcw+OQY23TwcqcI/lxMPoLW5gvnvRuhk7P43UIW+5IV85cbXC2/ZAmKGAmdBEKELkc1s24jm0fkz3SSI3pi5C0syVE+e1msDufIEQ8CiHA3KnrtAUYvUoAu4KdoHT/3RFdAbkf/0RyGrDir4s3E3pSLxcudMkRalxnn2pccQ6vicrZ9t7NbcRa/dMeHBzf96f1uPNJxvs1v2TVZoZCiGGDNlmbEVoC7l/DrEteJjfMnaSRdt87JHxHx7GhTWocdZMoVoURavp3MfQG58QwHIzUP7GFApbpXqE/Vfx3UPqXhlGLqSb+oi6lYD3DUBScG54B+i9B8GHO3bwXXk2M4WCN1IqzHIX3hofEN0AP87g+mZI40wHegsrAAsQ7e/DaqLbFfxFaz2VK7aGjfSnBmz8Cd3HeBHhgRBhOwpx3kfibWGFoZsTaFpCfSp4fyzXrf1SCHobSQBvseqGare8la98tBHwWGmCacXPUJztvHtnt1SqUc9gZ7g0lmMTJXc6p/RWbf/BOY8VTXojsLXM5pZVRUKrn4V12C2BOBd+TGBpzSCmkTE4nWkw/AovF0GGAPNSMiQTy9i2lNZA5CsLpWxSK7I9ySfORIHk1MQGI8DABjfWlk5PfBGi0dDxLq6eiCrvuHUCHOw
 +hBAWi2y
 HGyDkYy7CAp43b4ZSK1F/RJGSjN1aXmF3TpP5TprON7ZOHpffIwbXJst57xN0KF6gwMf3jlw7lmvf2Qm2fXVOH72CdPXMwy0uskC1Mh3olMXUq1ADBJCNKrebvPTOQN6NcXcMI7CS2I/LNJ/0KgR3b1JzrwG2XcAp1dlDbWtgs6Mrae7S+bI4h8f2mXgOY1mcV4y+NGcDijsedETWVYc+93Qd0GZ2Z7vNzcRJ0Hi+2PFJuT1hKNBZqutx2tHoxy2CAqRhfrsBAO63hyNv7yZ3CQE1u7pU0k54azJscK7qN1HBUo4DVOcHzt07RAxVD83pje2pnE3peZwzWQQBXfQ/PaZ7gtIuSl+nfF2Lny9Ik1EoCcJlDdobqRar+EHzyT3yTs1toB0qv6LAkYwI1WcvZTTWIFq2VCrx49BXlCUJHkjKzXSAvMf1zjSHhAEFoEQu/+vW117QhpuN/cVIK/7CllCEdTSqp/J4rqLX07/hVc0sN5lktqDtBA3AEtWDVRkgjWOFUl3c2+h1L9owQhDdi9apIqKUiib64RK6IE763YhV+AXiGQhS8QMIEB5wlGHCdrHCexVllxVXJ51CJU4yEW5v0mu0fBADBy2oEyKz6UONij6fMz8xbM01pajAQFIfbBvJswRBDWDiic0b76Ht9qS1ht3Vj1XE7cFFVAwxljMHKluycsi1eICrUuhvo2xTLHXBtpH0KR4zEYUxAHeqsmQHTgV04knP79Ssk6wkAyVgdsPYtw8HK5grejwkIlLy00v1HMvJrqlBT8rWzCySPGMbAF2GigsPOuYi+ES+HSVqC+6CwFh0U8YigwBIrYvk/XU5SC+iX1KDy95uCS9xRSf75GKIWgTI4gBHt7ljpiUFwLIiPkxeRSe6+h/nduW/yHD11a9kNC8zegURN/7tUwSN0rPWKJ5ezK1jw/VlK9hhIGEDTW0k+pkhL+PnnBoz7CO+MHUQ1jIBf+VMt+HIVL3RCYdo
 pSl3wHzi
 QNOTAyLbD7CuqmX88DcryeEZYBvZv+f0N/06NkpfQ563xhy7h7b1QXNQWIY+2py3MlHaaXOyFWsxr/bApzNyWsvsEYVM4QjaVrLo6lg7TBEBReZp95lk1jAUPbjtPeXcX3g9+zliuuHeblK9YOwHdzgMAz1VrSzpH9ATuj7WT2WFxEpgB6j9EYu7UvLLsWQ2Zk0t8F1uci0/FMqZoZ/RwKd+O63oCsL2mFhGvymAio0NmeV2930gdPGzDIfO1RmBi1YH4ixTXcLAx2VhzBqmpI+e6fM0k3CcECsp7UfeGBZ4A7pUWzqE+L+94EFjeEyTtiGt/apDisxf0SA2E8ms6tp/RS0lMRC6b/gAj6qi4uy2wd0ECgJh5eafEUMmPleYzMmMh8LWk2J/HCDQJULxMnrOLbQSQUCmFEpYPyFRWvTXJCUOnDY72H6DdQfHKzYQAirbK6qLEmc2oyCg3ES89Myy4KXF9u17Et+z19zxCl5e+4ArabCk/Vy5Q1FLCqabt3AlAItpSu5Ktys2IrgMbfmriY6qYESMBfF/z3njRmJkQ594R5hoyEseZy0SJADjUL3J0YDjbvtKSQn3PrlWQQVZLhTTUrcKFeJe0V3A5lZLnik2Gqc3ifuw+rK8d4JsX8HiprCj25eIRNgmT4aQFZud/4J4IaaG9U6MjLncisp2hLAGYJQB5wMN+NkCThJ92CWCfHD0waLK3m/hq7u9RygMmzT1SkijjnJ5Le59Go6wNcx8dHzx3Ql4YSvcbfz9iKmertfGiQpGTkpov2WzOXJu10G+uLhy6navyK9GeLh5nKvSB6/7U3+kuqpr3KWHiQHG7O1jSY3kgtSgAC9lvuo79NPt/+uhHG7OznGyDXSxJkjH70OV2uRLKSofrbR5BAEmvFDm0dxzuom+6W6KG2K1P+F0CAt0yQSwIHxhmkYfKfr+RjwBnVE+EapLAb9z1tenYEJIm6mZq3x0HX+anxLFU42UZ
 oJ7xYC3T
 JDt9yN7KTlcgs3Yn8La4QDiRTXCgiw2BazmMv4RsoGqANpcPiSfIJ9wAvyN+TOEQnktE11mWj1LeWQkVuPFbjoeaEnsFvo8ztBt0FCoa17201AkBkuuGSLrIMbcX+AZbojrDHJcn7vA5pNdCusUIuY/IucvxbO2BMEBGsueJOut+9IVDHKRyB54oqJiheyULYD8OKHKbGaDNmOpMKgDKzcnjaf+26fUjYU9lfS2U+5uGJLRQ2F5mE6O6fczozmQFul5ljYc2xmLIonov38A56o3UI+2lRGWs7FqUoSS0bVe5nfra2acfhu327Lg0O1apNVASFv9RQot/iHl6Bx9DQ2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than referring to VMA flags with uncertain meaning, add a new
predicate that explicitly describes what possession of the VMA_PFNMAP_BIT
or VMA_MIXEDMAP_BIT flags mean, and then refer to that function for
determining VMA mergeability.

Either flag means the contents of the mapping are owned by the kernel,
usually a driver, rather than by the core mm: the memory may be MMIO,
kernel-allocated pages or even ordinary pages the driver maps itself, but
the core must not populate, reclaim, migrate, copy-on-write or merge the
range on its own initiative.

We initially also include VMA_IO_BIT here, as by implication, these must be
kernel-owned. (mlock() also sets VMA_IO_BIT transiently on ordinary VMAs
while locking them, which is addressed later in this series.)

However the intent is to in future remove this, as no mapping should be
marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.

This forms the basis of further work intended to improve how we express VMA
properties such as this.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 56 ++++++++++++++++++++++++++++++++++++++++-
 tools/testing/vma/include/dup.h | 29 ++++++++++++++++++++-
 2 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2a92193ac6a5..cab29d6e15c1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1612,6 +1612,44 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_flags_is_kernel_owned() - Do the specified VMA flags indicate that the
+ * contents of the VMA are owned by the kernel rather than the core mm?
+ * @flags: The VMA flags to test.
+ *
+ * A kernel-owned mapping is one whose contents are established and controlled
+ * by the kernel, typically a driver, rather than by the core mm's fault and
+ * rmap machinery.
+ *
+ * The mapping may be memory-mapped I/O, kernel-allocated pages or ordinary
+ * pages the owner has chosen to map itself (shmem via a PFN map, for instance).
+ *
+ * In all cases the core mm must not populate, reclaim, migrate, copy-on-write
+ * or merge it of its own accord.
+ *
+ * Pages mapped this way are not necessarily reference counted or map counted.
+ *
+ * Returns: true if the flags indicate a kernel-owned mapping.
+ */
+static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
+{
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				  VMA_IO_BIT);
+}
+
+/**
+ * vma_is_kernel_owned() - Are the contents of @vma owned by the kernel?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_kernel_owned() for a description of this property.
+ *
+ * Returns: true if the VMA is kernel-owned.
+ */
+static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_kernel_owned(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1620,7 +1658,23 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
  */
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, kernel-owned mappings may have established state upon mapping
+	 * not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (vma_flags_is_kernel_owned(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }
 
 /**
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 1d5f6b3cbd21..9205ebf31ce7 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1665,7 +1665,34 @@ static inline bool file_is_dev_zero(const struct file *file)
 	return file && file->f_op == &zero_fops;
 }
 
+static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
+{
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				  VMA_IO_BIT);
+}
+
+static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_kernel_owned(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that the properties of a VMA completely describe
+	 * the properties of that VMA.
+	 *
+	 * However, kernel-owned mappings may have established state upon mapping
+	 * not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, PFN maps encode the source PFN of the range in
+	 * vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (vma_flags_is_kernel_owned(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }

-- 
2.55.0


