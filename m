Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F641C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204166B00AF; Thu, 17 Sep 2026 12:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DCF26B00B0; Thu, 17 Sep 2026 12:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0CE6B00B1; Thu, 17 Sep 2026 12:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1C296B00AF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:28:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D61FA0443
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:28:08 +0000 (UTC)
X-FDA: 85223786256.26.CFB2578
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5ED2E10000A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:28:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gpom1URc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gpom1URc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662486;
	b=34OoAX4KdUkvPU3eg98NCZAZjGruoy21uw699mK+XU22F0awi9ajd3ILICp+rVA/ReeZqo
	7DkYz+QDTZemM6dETeHPy6LVU519OdAZPzOUYSh3hgY47hNEgU6Nka6ic3im3VnLgDIGTc
	QRg9qZISiGa/5l+Ys/jZ/0dr/uAA7+0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3NscFRoiSw0VLcsrcN7WIQlCyh4L7cg6MA64F9Bvckc=;
	b=f4MqlvORmiwuUotKaQBrEqXgA0ordLpeSNIxOoGLVwYZnXuAyQRauoRpGixq1YUEroPad3
	NI3in6AEPYvuPHQKxvKMgAYNnYE96AjH/sfMwxKP8/1wXZSABeroeJHzN9iSzt5WeDctde
	k8JlnyPOottKwUIAUqnx2gVg9inGVbI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC21960214;
	Thu, 17 Sep 2026 16:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9094D1F0089C;
	Thu, 17 Sep 2026 16:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662485;
	bh=3NscFRoiSw0VLcsrcN7WIQlCyh4L7cg6MA64F9Bvckc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gpom1URcjhFec5GNJSWz2yyDLLYnwAgtINCYT4ASOKSNgDUA2U5NGLUDvUCT3d1Tu
	 pgFR2SXBCRJ1BCNKhQfvqLjsElhjUXKrW55em/ykgDOlRMieGQCdgOnnJ7bF59E+L1
	 mObQ14Jn5cD7jF8TBA/hswysZuTzg8pcrcswbqqqsaXhkp2eyva7zZU68tU6CryrI7
	 9awNVvOq3bPCHNSQiORKYxqxKChSoVbbEwIha05qEa0eVCUqs8S2rnYXSPh/W0DdHo
	 I4s8ITwoQUgDID8yXBKg/E5yDdeL9M9Mp9pAaRPZc9qODWQUDsHAy5st2QmImSRgD/
	 67A1IFXiTl7SQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:19 +0100
Subject: [PATCH v3 10/40] drivers/usb/mon: update to use mmap_prepare + map
 kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-10-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6221; i=ljs@kernel.org;
 h=from:subject:message-id; bh=GUpTHNxmxWarSVjd88RVgsA6FQygd+NcCuy3YFJiswg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB/4Yb3zwPQsD4dTiz/vrOc6aHZEMO23doKjhW9oi
 7206Fb3jlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEykeSkjQ3vElJvhtZsns7zx
 kl3CpLxg0t9TjKorTDzXeiw0uyox8R7DH55lzsfs9Qyqcvw2CxtETdsVZCjmmWjB8Il98i+V+dy
 tbAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: 5ED2E10000A
X-Stat-Signature: sk3csr7ntm3bjp3m8d7oaopygsfg1ceu
X-Rspamd-Server: rspam01
X-HE-Tag: 1789662486-287213
X-HE-Meta: U2FsdGVkX19jccs5gZDqGHltOlARthLE/rdsbU79857zfBO/0o4vmOjW6v8ETsS3nhDGTdpDlIfe+pnzOP/anm6S3Oo5QjOcVo9s3mQoR0evflAoUkr4lgd2YNZ168jsLRYvGnsgASqhNkJlRJ2K6rRbdTHmqeuuAX/zVTu1dDSp43G9KtDUfQo7kFiflDOZvwRcG4op1W1jh+t5MstE/h7buMJD8l8lVuh3qT3n8Cl8rdBht0D9FGemqGwkfGX0ItlNrnupP9nB53Gf+prMfXqEUoG9/3cDB2KdHmdnemBP3O63/ha1wKNK+yf7XqTpoot8iWXzr7wQ1V8kuuPvd/qLg4RGiUvQl9V0RKw4Sv+Mvp3J2tO12cW0olBYZOewXge84zRRSs7xq+HW03I4rXs/5Tu7qOSnOwoJphkshCPHXnR1sLdkgO/kY0EIz+EDCuMC/k7EqL66FPG6g1DA7+4uV9jLGjkKi6a0b+GT3Ruj8GakVktCr9qSGJnIKNRBCanDETIGBTK136R03tXZs8H0Ll5ntGBhsP9veJl+m+BuN3crX+C4uVcra4ira5HI9R+DsCKV2vDHIEwiGzCpxVgaM5WM/u9MbTd6Zr0u+/CXDlfHfm5BBzJ3ZKy05BDOocIk5zbp8t1RKWqBeiDReKMJS/fucBetz3uatAVoS1LPGMOq9VxX2MWO6dElB5a/gctbowUDa5b0jOMEKpcg6Zb9DXCROM0LcbAINlSrfjVCdoo/e9UYI6aT/BhFByM/0UPmloeflsg8v042eF8HK0ctMMn+HThQHioSjd4IBshsp+lc+GdfQJlhXf1t38etn8Kr1i/zoHP3h7K9AQd351BiPIuMqDspBPUgwDxzlX57QaBNZN1JkbcXkfXGRi8u8kLL8gx9hVvEHQC1eggYyyoex1OAJVsc/klqX8ojE3vyqxfGxIlrK/uCk3gJu7fBU7ME0ExnQXl8q4UTkPR
 pvUyrE7A
 XHcMik8nVZ/vtK6ENudg0R8DM0+aC12vAVRUQeWR+c2OXBvcmrxr0rLbbNwy9kudt9m8X9vd9LWkvA1CwELpDBhpcKyqKyY9Rq1MR9tGwe1ZccrJeNdzgOo4dwc0ci3GsbOLfFqxHuUa1NL6cjjaJKO06oOIdCFnsuqKWIjQie96af6YOWPwZcDjaJgU+8d1YXA26tN77AzFDpIAH5LTbJkzbh7sMQEP0ed4nL3gJhbfr+5dqAUwZ3JinHqBM83NZeYkqRPEOT1Rzk0OjLes7pMeDtIlC8Y+iKIxVayAbd6EPFzb0YYTw4ZPTY4+H+OI+SKm1IB5/8j3agF2azQQp2xhxBX7Fadr1mzLRvPt5bNdYTbCFigvHq1y05t33jWmlp4f0ci3Y2hPeP1Fnn0c/2+S1T6konhG5r1cySGlQqetXugXzUrRYWfraBOOZKYX/viEOi+y2AYbY3EBUd3fYk14TEy6gk8FDe6ybDiC7qMlfP1iKi+eiiK5Psz5vidXMUk8JAfINkH2f/tRIYM+aieXS6O5F622eRJCz4WETqB38YGDtbyY5HUi2JSKB7LmYpZ99Kb8sZMNCdGjm11EvfMRqoqUrMA+DPSE0pPlTAdn+5kauGIUqkiXeSKX4sXoRaFdvZGgRzAdDALL+E3R7OHFOj3KVBzxgOf9Xq1ey62m4kQ6tOkMqiIazWkJfpJvC8rUbFNYCwz7s1BkxY960NE/0jcY8vW63UEPIJur4V3V7EiR4regfBH1QkxNsH/AelwRLfdG62vXA/dg2XJDrZUO7lAXhTKZsaez4rCyZusQv6t1njgpnZH4qWqHO4cYv7PSdkIyc5ohh/71wfIqUf/WGNXs9sKT0fKa5+cNQmfFKJoJQi1bYAOuO5rEoYhHcK+C2O0QtFh2NXLbUqCR4HFKdzInIBx5uVHFfDzV0n84oRorJDTFYROwlrVz1HTu5nqHcdf1CB1CnIdKcabOqpx0iKdcL
 fJXmc3p/
 +wtt8n0+k6FFQRjjoWMvXi/08nAeJMuomkj3IOBvmQgxMt1JpHxXd1CljBcPGJjsnEzWXTIIy2mjD/O+6wFZwNVn9oatB4Ezi0iuojnS4CnG8uC4msykZCUZUjcBoMlj2FMfd8lTXAhpgABWBWDTAkRdZW590XgSugwRaYwdq0h8cnS2uw1DVNOL35RORekis/ZBMT1yfC0tIuuq08AK2vEYlyTfdL6soYZudkPK66WjktHGCplzUOnn1XioIhbe3R+2LtPnSwFAqxbPdgxAwHXPmySpXJ3S2fOK4P3XN6Uf9iwSj3rn3lM326usPEDCF2G67LmeOxx8FsOaWGYSB7pTQTy/2MNWLy8D+dMd777f91lqKdpw8QlE6HJk+zf6BQWQH++UQZHPC7zCDnsTgorXVgnYmiv5ZsTtwruNKUCLoYrxSfeWPSAzseb/1SQc5kC6hr22uRazeeneMrP/vMkvZB3UMcwxsbx+V4b5lO4POeEZk43rdaGu9AC33ZP+qhdVzwFiG6NTbd96WE8tCf+HoiQhKjqvMIUHKmCBpJV/SWwthaHdK24UKzSpM5kIR/S/2wUdUqwZbWn7lvBtnbuvliAv90imYh/vTrR+Ova/m8kaRqBZJt2FKjReaC8U6q0E8uE1iZySg8wGSaUqjCHMxzK6CQQPoyBIwqu0tUCmJ/XJiFrJjBoNOm2JtnacDhJxU3ug8z/yludCNfV82SKiS8OgQzKJeCN3ax/NIFXUQLU2HOgZQDmIUD2PjXz2K3V7Jnr3xfbO9+Wpa2MSSwn6cHkBpfHnYssSEU1wIjFcAnEu665T9Q1JogWXFsyg6EmRHp3KQ+83C6cpgw2aZC4zm/3r+s3T2mWXLjQc63G/JvI5w602c2VqYnC0VLL8PLXqtf64qDNhxJT4SDMx8dzgBMRinFB2YPETvjCO6bGk4CKW1NZ9UDLyDxfTo2yGnkQmU/1MhR4r5HJxlhbt/Szlkvhg+
 PmWWITtu
 swTKlUP+4x8OzsPoBzuRHNH7gEbBiQg1BTWb68YZ0AUuS9Qv5fYl3m106MqFN92i7l6+YSqxrOxYArMW/a/4+Do5HHjvJULO5KSzZcNLcV3KtUDw0ckCRHMPqiTD1Eh21ppr3s8aP15u0G9iCvv2v9+L8xHJUneaFRODZAM5t6kaiMrN+INB/iMsd4mZtpwPLpMVYrSIOmLe+8QrPDTTPq2UQchdbXCJiLqRqvop41OyHutbfraYYm2rkGBSMUMWBwLcikdlAJmw1MR3EYPuLT2MD/PdWUkHyUs4CXX63IkCXkY6zG7VdA6ly+tVzU3eel6Iuozg9ZqFRaxcIfKuJur5V0zXw0xmI4htAWVZroTenKIzWn7Xq/x3YllI6dIAYHfUXbEA/ckVY8v1ABhCD6qJZ39BudX3X9TWcWR0c7ybIPuGEk9gSXkpZRj8LfXO5uC9tHi92d6qhXf0eE9lL4D/flY1K5CZAgQ2cRLxSaQkLeKuqN3nOV0NjJY4LQzHJSAN+7znpvcWEFAR4j+PGjd1vv8kDdt+W/3Tc/LAKJzACK+6IiFuN/lrZkiqjKiKUNLil6TYV9fEvcJwY43fDkx62RbMA9egR/AOy1BbJRCQ66RPdarZtXpbBqgsBDBrl9QxRUDXm/05yIfDs2ryASk1qUEbvESrZm7/2dATluO8xuQ1EX5q2Zb9vvZFNbxmwcZOevyuhCHBqkfJuQvr1UolEIFmAQ/rvilRWAW8lrSsnYJrfxRKWtPwRvpdNFIKVPGAklbA5C/B7d0gJgkfpDTiGlNLU8tqZizEogxEBsa6TcEPbnW2MZivGg1Kovx2yxwz0EbupO8XvtHVW34hj+9Q/4zlb/L/BEo420xqbcfayWZ8eepbVEbzp3Doawx6j2NT2y9TAqH4ivDBiueCqgvzB2llbx3i1o7htfch2qBYFZ3yj/EMhn9cX9/seonb6UMDsRgI54E5sm1K88QGCc9XGoUD7
 9HOFjNRV
 6lNgHMAJ0+cppfFF3TIi8xhOk7JCghfpR7V9yBYNCEBg0auVRP6Z3Q6RemnzKoCb+HAL1aWs1GPZZA1MKi5pfXYexl5Y1IY2qYY5Nzr543QyJ5X/+b0vvAd/2mBMs/RcNDcV/1lXY0+eF4m9YrIEhEO4A57kifX8HDusDIslIPTvJ0LhGaEN86zMa+Bx2JxrFmwUZOF1uvp0h2QkwOcjkNx0+RVZayyTdq5TOgh9pmud2tSWJrcE1wGd/ztkv8obk4SdTVBOfB2dvcaNdX4yHVgxIlppLEyvLkXbyV/rf7nb6Ge5FjscadV3sPeLFNypBb8k7UbjZgXRdwHCUvgT7PUg8FJvXWJumazIT0/HstyHfoon9qEOj9CU9RkwIpchEDJ2YMKvYTus+vgNSPlPf7t1yYUmLHWkKkcUhT3/iOHXbdQYEO+wpdDXkPsNIwXl+NT4/k0W5OeYom8NpAlrBNPygW57MSyP1yHOMlLPTz++GAEYVXKmztMHQJ0dZFAM7mqOqhGq0vmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the deprecated .mmap hook with its replacement .mmap_prepare. As
part of this change, additionally take the approach of mapping pages upon
mmap rather than providing a fault handler.

The page span cannot be mutated when an mmap mapping is in place, so this
is safe to do in advance (the MON_IOCT_RING_SIZE ioctl operation exits
-EBUSY if it's attempted, gated by the rp->mmap_active reference count).

Utilise the newly introduced mmap_action_map_discontig_kernel_pages() to do
this, which allows for iteration over pages in mon_bin_discontig_get().

mon_bin_discontig_init() increments the rp->mmap_active reference count to
stabilise page spans. Should an error arise the core unmaps the VMA and
mon_bin_vma_close() drops the reference again.

The vm_ops->close hook implemented in mon_bin_vma_close() will ensure
correct reference count arithmetic upon unmap (with mon_bin_vma_open()
accounting for splitting).

The existing semantics are all retained, including not mapping past the
range of available pages, with a SIGBUS being raised in a userland process
that attempts to access past this point.

Ultimately insert_page() is invoked to insert each page, which increments
the reference count on each mapped page. This mimics what was being done
previously, only we pre-map the entire range rather than doing so on
demand.

The existing fault handler did nothing that required demand paging, and was
presumably implemented this way for historical reasons.

One behavioural difference: pages are no longer faulted in on demand, so a
page discarded with MADV_DONTNEED is not repopulated and a subsequent
access raises SIGBUS, as with other pre-populated kernel mappings.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/usb/mon/mon_bin.c | 82 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 687f6a8981f3..9d00b21a8153 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1219,6 +1219,15 @@ mon_bin_poll(struct file *file, struct poll_table_struct *wait)
 	return mask;
 }
 
+static void __mon_bin_vma_open(struct mon_reader_bin *rp)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rp->b_lock, flags);
+	rp->mmap_active++;
+	spin_unlock_irqrestore(&rp->b_lock, flags);
+}
+
 /*
  * open and close: just keep track of how many times the device is
  * mapped, to use the proper memory allocation function.
@@ -1226,64 +1235,79 @@ mon_bin_poll(struct file *file, struct poll_table_struct *wait)
 static void mon_bin_vma_open(struct vm_area_struct *vma)
 {
 	struct mon_reader_bin *rp = vma->vm_private_data;
-	unsigned long flags;
 
-	spin_lock_irqsave(&rp->b_lock, flags);
-	rp->mmap_active++;
-	spin_unlock_irqrestore(&rp->b_lock, flags);
+	__mon_bin_vma_open(rp);
 }
 
-static void mon_bin_vma_close(struct vm_area_struct *vma)
+static void __mon_bin_vma_close(struct mon_reader_bin *rp)
 {
 	unsigned long flags;
 
-	struct mon_reader_bin *rp = vma->vm_private_data;
 	spin_lock_irqsave(&rp->b_lock, flags);
 	rp->mmap_active--;
 	spin_unlock_irqrestore(&rp->b_lock, flags);
 }
 
-/*
- * Map ring pages to user space.
- */
-static vm_fault_t mon_bin_vma_fault(struct vm_fault *vmf)
+static void mon_bin_vma_close(struct vm_area_struct *vma)
 {
-	struct mon_reader_bin *rp = vmf->vma->vm_private_data;
+	struct mon_reader_bin *rp = vma->vm_private_data;
+
+	__mon_bin_vma_close(rp);
+}
+
+static const struct vm_operations_struct mon_bin_vm_ops = {
+	.open =     mon_bin_vma_open,
+	.close =    mon_bin_vma_close,
+};
+
+static int mon_bin_discontig_init(void *vm_private_data, void **private)
+{
+	struct mon_reader_bin *rp = vm_private_data;
+
+	/* Dropped by mon_bin_vma_close() on unmap, including on error. */
+	__mon_bin_vma_open(rp);
+	return 0;
+}
+
+static int mon_bin_discontig_get(struct discontig_kernel_page_state *state)
+{
+	struct mon_reader_bin *rp = state->vm_private_data;
 	unsigned long offset, chunk_idx;
-	struct page *pageptr;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rp->b_lock, flags);
-	offset = vmf->pgoff << PAGE_SHIFT;
+
+	offset = state->pgoff << PAGE_SHIFT;
 	if (offset >= rp->b_size) {
 		spin_unlock_irqrestore(&rp->b_lock, flags);
-		return VM_FAULT_SIGBUS;
+		discontig_kernel_map_abort(state);
+		return 0;
 	}
 	chunk_idx = offset / CHUNK_SIZE;
-	pageptr = rp->b_vec[chunk_idx].pg;
-	get_page(pageptr);
-	vmf->page = pageptr;
+	discontig_kernel_map_page(state, rp->b_vec[chunk_idx].pg);
+
 	spin_unlock_irqrestore(&rp->b_lock, flags);
 	return 0;
 }
 
-static const struct vm_operations_struct mon_bin_vm_ops = {
-	.open =     mon_bin_vma_open,
-	.close =    mon_bin_vma_close,
-	.fault =    mon_bin_vma_fault,
+static const struct discontig_kernel_page_ops mon_discontig_ops = {
+	.init = mon_bin_discontig_init,
+	.get = mon_bin_discontig_get,
 };
 
-static int mon_bin_mmap(struct file *filp, struct vm_area_struct *vma)
+static int mon_bin_mmap_prepare(struct vm_area_desc *desc)
 {
-	/* don't do anything here: "fault" will set up page table entries */
-	vma->vm_ops = &mon_bin_vm_ops;
+	const struct file *filp = desc->file;
 
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_desc_test(desc, VMA_WRITE_BIT))
 		return -EPERM;
 
-	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_MAYWRITE);
-	vma->vm_private_data = filp->private_data;
-	mon_bin_vma_open(vma);
+	desc->vm_ops = &mon_bin_vm_ops;
+	vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->private_data = filp->private_data;
+
+	mmap_action_map_discontig_kernel_pages(desc, NULL, &mon_discontig_ops);
 	return 0;
 }
 
@@ -1298,7 +1322,7 @@ static const struct file_operations mon_fops_binary = {
 	.compat_ioctl =	mon_bin_compat_ioctl,
 #endif
 	.release =	mon_bin_release,
-	.mmap =		mon_bin_mmap,
+	.mmap_prepare = mon_bin_mmap_prepare,
 };
 
 static int mon_bin_wait_event(struct file *file, struct mon_reader_bin *rp)

-- 
2.55.0


