Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3651BCA5FEF
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32DA86B008A; Sat,  3 Oct 2026 12:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306256B0093; Sat,  3 Oct 2026 12:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F53B6B00AD; Sat,  3 Oct 2026 12:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F301C6B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:44:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F3DE14097A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:44:29 +0000 (UTC)
X-FDA: 85281888258.08.441650F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C3D0F1C000A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:44:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V2kIMAj3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FL+pG7iYbns5NAvxUiKpoa2h2WT2T+0wVsizSFodaIE=;
	b=RI/uSauqPz0TZza3wC+BrfdPqtS5x2NUBfVo4BInKM9xTEaWCmDSJMHStUlJSgm6LZGuwd
	Ut0OAe7eO37LLNX0DKN4la2Z7CycNLa8LVuI7pJDx6FGC9by/6UCSe0gqET1OSLy6BSvB1
	diBjiCdJ6iwGoTR0CAYrY4WEd03a2ME=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V2kIMAj3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045867;
	b=7nbHKfP2rdt03waWL1fWdWZma9shYWh/OnPHdEwKtLZm6ywyT5lN3eypE4AjSIJBazX8Wl
	uS4bwJWxV0hVcfUocWq6/xi6efl9j+JCeBC8p2vVr+RB+LuyuYR0UuS3CiXKcSvJSpk/+V
	2KleoL/qTDRVNpH5fet3rCnR/zGp/ss=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 080B843A88;
	Sat,  3 Oct 2026 16:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2065E1F0089C;
	Sat,  3 Oct 2026 16:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045866;
	bh=FL+pG7iYbns5NAvxUiKpoa2h2WT2T+0wVsizSFodaIE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=V2kIMAj3DndO75feJyq2K4LFAGvGBo9EJULHc5tUj/bU5oIOgQ4kWNIJ03PGZ01cS
	 5qvQix6vOGxZrjwFTU+9L2Yx5D6Uv/DPnMD8oaZSKp2KJ5L1VI6Su9ET1CQIhclbzH
	 DTyKuCY1Mc1DPM4lv0K9ltuhkoimxv/xbZX9ci/ZxB202U+thTXpPM7pwB8CUNW5LJ
	 NVWIvFTWRpQPqqsmgu9nfyBeSaHFW794xNZ7OYAqz63EXVaDZm5PD1ukQjNIuD4CZD
	 7R/lHsPFey6ZXGM5drttQCWuzurWU2dAuB9lDwRrn5jCK3D9TSI131QvAab1f5HMcP
	 ut8jyQHbLXjSA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:33:03 +0100
Subject: [PATCH v4 32/38] mm/madvise: use predicates for madvise(...,
 MADV_DOFORK)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-32-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1363; i=ljs@kernel.org;
 h=from:subject:message-id; bh=YNfpkCadbWvpcwwLlLHWuiS8T4ZWoqNpMFslOQmKhoo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6umsynLT+hVwJvjR2/u+xwz+xxvdajvwUSU6/JVVk
 lla0tEXHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIE0WGf4ZLvp52ec56dcpj
 9ehoKwuzsL0N12crn3/PlGZoXrrMm5GR4XWvYm1Lynm5HeV53jdWOtSb6J4Xu7BmZS7noXN2x1t
 nMQIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: e4war7bqtmq8s9cs8rnyhc8gx57zt39h
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C3D0F1C000A
X-HE-Tag: 1791045867-144869
X-HE-Meta: U2FsdGVkX18S9UUBctPyKPb16C86FSSY8Wmgbd/0/vkkaDRN9xoFjDpxlz8MkpfshJNb+/kPrhXLrLtayFow++y5xhFesZSF19ALrCQupoHx9xmQWUx1NFwIM2tvftHBEig71D9kgt54ISQpCy13fOdDtsQlLf5bdl6I9YqkOi4+H3zjPpWRedpStoqrEgzf81XzaB7X4Se6wp+vMSyHaYNWG2rqiOtAOL305edl4/A6GwUWc0LU+4idkdpx7U4AUHZ0LwMQ/QfTPHBL2u+FWtvJJH+XRbXUb6VhidXW19X5NhGs3TZzTpOuruXDIfL9V9AJh3zZ8Ky9nooaIC6P77yoG9PokPCygTsy/v6ju7UcssTKrmCK9PVtxlYpjZ3O5AUjSidnfWJxa2MWqF3U9ol4W9//VrF6JchMnRzOBxINw/j8weuquQKIG77fGyGyO3xIOLvH4l9sAop1evZk/PFC1WOhGZERz/VLKjXjVc0spQb24Sn7PB7ILrOAM6IBDiU5Qki1LUvGepFs93AdeT2W1p47aYpoipSpHDH0JdycDuqjBF3EO82ZkFkkz/QSYvwBxAhvFICAlxFcWmq6zNfvUGHT9ffzsgp1LYQKUfrlo4uN3xy9f7YdBcE071l7YD/S7w82ObcYLayua0XXQorxgrfGGOLp5x0p14Wm59k2KfpHNfYoVkiKvPzaMRoL/I1yxcPIOX5XsJZDdjctnJl/5XVrIOrGgljQPA15+vySrCBLIAU31UsR6nW/LFW7JRNZey+o41xUu27Dy23VURxWYUb1RRBqkCkgtTETgSBWPK7b5y7tWMgSITSig4f7kmZ04FYCXADIJAArZm+uG54VW+tyuPkr0FKPgUsmv5xJaSxR2HKgYWwlFPYE4JHARp34ulv3BI4BE4NkuHfhU3HY3pJSVbX+f0ve3+JDYtwHGO5+yjJf1soGlk9sHBHV3XUJvdsesCLnUbFl0kD
 PDa4jYS3
 q+cXpENCUo+oDbqc+BYlw9KzODR51uKWsWr1saR06N2oq/BYK4GN4dHznzKgVllr2D8TwsGNNuvgNDZHFD2z1BIMIlZte0N4T+KIYRolBhAcfEX622P4PDQAVf2+qkV8GE3goLzUX7c8a1bRUQDNpMogVO+bESlr8qtqtvgEpFBNxeLDHRZ7YdiaNMwFe0nt3J4A8A0heQjrL8o4ii7zuowOY685/VDZ2Jg0bBW4un+6quZ1zpmJcXUrpNzQ55YxN5CHWMxD/ToN+b+BYtPtZuNCnvilgTRbJTD5brcWqFn/r0hSZcdTR5e+X7rinKd9PpEnd1yRC92M3fFFzBKNnupeCjCUnSnZRtox7pUdbxt6Bh4araaH26/j4FzO2oBuVJj97PpVHv/dvUl2uvUwX6KKJ9RNxSeDTG1wcCcF9icngTjiFeAih4nqPuXuVwgOBnXYNF/TlWhAGtRgqzA+fExmCEWxLYXXADImSGYxIBEoEO+LUh7Za4P0xbnCRxJ7X3jw8jWrIhrpPxCzWlzjQ91pbWyHZP1jt5sYwgsHtW+NHYTqCQdY6C8di6YkSzDu53ZE7019Y+7bMPdoEK0bHaXhkhX1nfAlM63uR33mtyZaegY9MFrT6ECVQTLNeMv9t5SDFfa1QYA2zOvA5vvAj0haPuf6foR7ec0aGK8uRsnzB1v+uU9JRlkqyadSuEpr9mbUG6Fhdbyi18SvGE9rKlMLAJMNLvOEWsOgIixAMVSuyguC6uH506/dyinJrQDDi9Xpv7z1ZB6blNMrdmsopgG2+M+iqsnahdb4TfVDCAOndAHNx5mSsSVBnX+2OUP2LrmNgsar7SA7/Q67zgKjodJ8npRpbR5BEp0Vqtp6uyQ6O4VYZa6DO4g3IELC+j76C/DrgNoVfx+94KznSm9Ux4MtfRhNIXmiS2GrQ1O4YQaFgCXCqLmJ/XTleqJGpcOik9J1vZAMUPsK8aaVgQhyDueUOO7LZ
 szeBQHSw
 v5eV9EVmjpJstFPt6P6Oo901rYVWo/KLdNjJysL9JdcXQ5l7EEII0gz95qY5PAN4HjHje9OL8cTA2+riuvQryjoM4EeJk32yVrkmFh0Cab21mwAH/k4rVjYA+IAInM503NyT9vlIC1d1rJk3+XrkZr39kE2rCU4iaJbWZwww0uDUD1bjGwzgfX4uos5vmHxoLkPoQlq+Y62O+94zTPPlJrGBFl1d5Swu8OXBJa/EOdaMDcB28vx5THvbsYq3nFndUmiQDDdAdKOeFXznGRAh4AkVmph1v3X2O1tZhpA18jo3nE/nW8CU0uPwi+2vP+4hYwriAgPULdk8GEokx82l5V2zOQodi36YxrJfrYOU1QIQrFi+N6p9OPrKvupHl6IHqGG2NWiyP5ouaMmGjVcBsfXKqlgDDQV0mzH1PMvsOGrqaK37JFFyCTHpGcRZJjG2yX6DsUSYJZJThedJ21B1L3Cp/O7kAbrtBwwnTBy0iXLCh8R8NsBSR9cqPnl8TYObHeEOPJVebZvqwVFhH+18Um3YgX3Euh7Am9K6kQopYGpfG+MrjVykKGUuHPGYW691ol1ui9J4eNCn5tutTlkszf2hkojXKdqYy1sXMoyEiswo4Y43LQXod6HqWWjVojQw93NJVHr8CpbqLDAa3QRK5Zf09yPZNdOap76H/Mxf6ywyx50J92rA8gQFL4Ty7vbnCjLsZMS7yZw/VWi874nzULzspTbaz3xzl1S/yyRQaiuFXeXiRFAhfB8cCmLBdDayp8YMZxaENE7g8HUSu+qZyhxSbAmHSDGm6atWk9W8FC9Q7BgR3dGmIXDaoMCMzvy8KI0SwX8AgvELOF5zh4tfZowc9LaxSmykwyCKFUM0lfEt6W+YJjEwUnfkQkwcfEHI6DVhFPeuYBOCVa2mhqv/EykSRkA/g4KflhpiBlWZ+vssV/FUc9JyGFW+nks+/OQWOaVNcAh/dHrsPkihRFaFSDDle8KWM
 d7rIJBzz
 //6zLNFU57Eh5WG1mvxoISyZWO7CDtcOWTQwBpDhxMzSWPZFtW1g7h/lDfeNfrTSudCpcN0kxEuP8VLrQfp/TCmqrtmutSyfNddf3GJbp8FPNAEZvjW3xPCWeqidGNEr5ctD6rORwWNKDPXXZYXOm2TI9b5FCTjep5sKc7ATA+J/CrtEttQaRCu3o8GbVbRKm1Bv1CjqR3ihFy3ArlOASnbd9+ogLOM5Cts4o3V9UDaqC9zASHTXJr9y1328ThbCfloLH4QJtElEBu9hmKkAIkf9bRb4mhXnfZMY1ogBUTWxncUuYTmwERFP0ZLhyZL7sSQn/ko/RIfH0sXzGJw7VnWxaNr2fK4oYjFDHIYWZco8mmuvH5+elrDDUQaPPbwXrmDGURGeUUlZ6FARuAKn4sPS1U13gnpMNwb1wa5CnJLkidK8LhTElKJZz6ueqy65bmHO6L7PxEysT4w3FGTAi4buGuCaSlbzrWgBkEPCXSjBTpa5m3uBkVYOrB+JrkA5bhe6F/DzED971X/kFrBzmVmJpZKU0i+yZ0QTy11gOpZFEM9r/b759RZcr2n07c9q7vrjp5J8n3gR8BTvgP2NVzRrQCWirejhkD881fSK/HRK6ykfyDMypjaoeki0Ndu6yVO7kPGP1GTq/itC4Y5vkGERvdQUHoo18s/1zgYPJ1V4W0uJTexWXOotZ3kdduz3eLQBNOXdbtycX8CZ5rKG2pIu2fz+UUSEuT3DqAVIjGKgAX1tpv5SHn8mAcVorPKjEBYLaOhs5SY+xkcjznCMZjbOcT4G+BHqtO3sM+dYVVNB2y/S+93MhkYZl83bjiTHOl4LqKCaeL9wyQWgO0yyNf16AuQAeXbppRc35NGvaMp1FXMypjK0Lq59i1WNpBJacJZr9aIkYTAUwHzykkvUTcKn77xXKBkzIBR/D4W2lG8fO8RDxxnEO4FThzyYSlRFNa8bEvu6XzWz0r/JvR/datob1CTRX
 zwmiTr97
 YPI59L4qExGkZYYa9ZNYlGSecqlGEuOkVoO79coIlRiqfSlIsLt0gzAwzrwzNvskFCKifWYFkePGhRKzs7o0uZm5IzO6wvpA4N1WMsRIJiSXLF5mnnN1649ovrcL8n7AH/lRq91gUdSSg/4xWaL2iNyHSFYnMBLjqZHngx0+nlhBweo5k2CGnOGQUkSDJrhoUc6C+TzIZDRplHujlCECze025ULTEAL9yTKQqCB4nlaf82uitHX+PyJonRqCDuXpwv7x7Z6iBfpoDzYRlet5pEukvnqHlL4LHwSSZyN7N6+qvohCAme9ejG9jVPpP3EkKNmIhphiERXL3/NG9QzAO1jrj8k2s1HMifb2azqZGfwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make it clear what we're blocking in MADV_DOFORK. Previously we simply
disallowed VM_SPECIAL i.e. mappings not managed by core mm, fixed mappings
and
VMA_IO_BIT.

Now the invariant is established that mm-managed mappings may not set
VMA_IO_BIT, the VMA_IO_BIT check is redundant.

The rest is equivalent to testing for a fixed or non-mm-managed mapping,
i.e. exactly the same check as whether the VMA is permitted to be merged.

This was established by commit 0b2758f48f22 ("Require (reasonably) normal
mappings for MADV_DOFORK") containing my hands-down favourite call out of
all time.

Express the same thing differently - if we wouldn't be allowed to merge it,
then we aren't allowed to manipulate CoW behaviour on fork.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 9d0cde25da61..30e42df6910a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1565,7 +1565,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		new_flags |= VM_DONTCOPY;
 		break;
 	case MADV_DOFORK:
-		if (new_flags & VM_SPECIAL)
+		if (!vma_can_merge(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTCOPY;
 		break;

-- 
2.55.0


