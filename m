Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6BE3C79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E89A96B0095; Tue,  8 Sep 2026 16:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61376B0096; Tue,  8 Sep 2026 16:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D50A16B0099; Tue,  8 Sep 2026 16:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADF7E6B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:21:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A0E316077D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:21:05 +0000 (UTC)
X-FDA: 85191714090.04.B267F2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 77C42C000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:21:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AEp1REBG;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898863;
	b=sWTtuIqZe02wGGOzyVg85qznexTpr0exOuUKWmK2OBMqzwPyD8wBZFMBMlaUN5qWTJsK/p
	aDFvQ7Cj1dgWZQlszNi2C+2cAO85QEeOf+zG6bsS/LBJ9ItvcmgvK1NfyzjBtlIte4sI4K
	KEQDkBCu6ZuDEcBLOftLwIuDr1n9xWY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AEp1REBG;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOMisn73rdVVhY8+AjzvTNNmNUkAEb20IWBzE7CPZUU=;
	b=53m1lUMfyjXV3Sgq/DdvqOQqe/xHtF+d4LbnROEw5gUBZhLln3qcIlxM2zbMMhqqXU9LYj
	U6n4amIGPhTaoA2dgDSZrcOmsJcJO4sNqZUQn6QsUneMft6ICLQd+gGvZxedDsRyvZtIvF
	BDOeXZ4vleoxccBePL7wsBgajCu3QW4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C581E6020A;
	Tue,  8 Sep 2026 20:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F2A1F00A3D;
	Tue,  8 Sep 2026 20:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898862;
	bh=MOMisn73rdVVhY8+AjzvTNNmNUkAEb20IWBzE7CPZUU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AEp1REBGH+pakt3xHUNX2JKqVONYzgzvgZGlCes8VpWTcWPNIU+TMTKT2sVwlEKVf
	 3d3HkthAX1FMsxxuYzx8BEFXz0VIq1fV7vOp89w+HJFBkSkxQzPGw8pf6KjunCOEha
	 aAStY4j8dulgMJGDKYfg6byPl0UaLo7QmScwkKnJQEb6SoGID7WBqLjmi9Q6nJiQDi
	 mFJrZqwN9amg72vbTmq5g4P0vaGZ3NaK3J55pnKuUo/GxMyGPJDy7MEpcYr2/8hWSF
	 tX/1SpYavP4hBrQt3jwlo8PTcuszTSW3joN1et5kS8WFYzcq8/vxvnduS3NkwS0fQ2
	 k0/tNEa3pZ2VQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:43 +0100
Subject: [PATCH 39/39] mm/vma: introduce and use vma[_flags]_can_gup()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-39-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
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
 Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6584; i=ljs@kernel.org;
 h=from:subject:message-id; bh=kPVMWaJCwo1lhrTWXad/wqA8hcD1f6brZZ1kpIuur1c=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG6vmyVSwLU385PLJLOsm8wrPI48vnjnyrRcyfpXr
 QZ5rW9tO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR5KWMDE9+ar3kPPvQ5u7F
 6lzR+P7LZzmWGP6c93zVo4ye57oHDxox/BU80L30947zd/l2STndnSQ2b77G82v3+VnlD9utDXp
 utJEDAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 77C42C000D
X-Stat-Signature: xeia41t4qmy16azohwj1ha9q5axe8r3r
X-HE-Tag: 1788898863-125503
X-HE-Meta: U2FsdGVkX1/FbngLY1eXfmf2ZgT9zDvYRQjc5XTRMxM9LSVDVhGdj3pO/88tMlyrm6gIMS0xnXehBqoSoS0Qio/6fehY4Yt5b8C3zYYQZYbwgeNu2F6i3Yz2eEC1NYc22/ZOGJaEIwmE5jsyc6AANByCVHMtg18WhADivFJvBeB663GSAwyvbHcZHfVAU5bom1YWceUak/S8mrFjSYJQ7aqeU0L2EraO8Os5ecH2/HaCJ3uKwsQOeZ+W6RsGpHqVgDov95D84EOPXOAQCwsh/3/u3GOcEB3JVNyfwKHoqONxKTVd8bOLOo8w8OiwmErMZFdjwdI6mHqJ6asXYF4J3pcADNnPvjW1IsYG8b+AsNaYVuhKMpEYuD8cAfEhaO6mGQzlAsxYfTuhgjrKEIeD7kVuCwoIY1sUcdOiUmLywPrGfXiKLnBXyEOnhvfnaJrB5o/XyzKGm+n+z6icPMGaUZemFL1btSUBtMOSiKDrtBKPJIoOMRofgQcYqssszIvOsa35BCHob32UYIJErTrTIyGNzuH1raAJXXfM0CkboGGkdwzH8af/huUw4q11kl37+g8wdYdw42ir6T1bc1DRp/HVuP7em/HrR1fsINPgRkJKxWzi8nyDSfDp1yJisqsmj0Z5B/8AVmQ7QSU2rgTu6AivL05MzBjS/90qVj23Y4TIPJ+0NITAvK6NH55Dfw4RPjDO5Coo+MqzJ8/bp7Q3+fd9CgLorLTH0aAZLmFcSt6G67JsMZkPXMvpguw0gBC+tikDVZMA538wpt0yNxThD4+gm3+PIToVjxT9JMuVcbooNUzx0t18r+6w0RZ+Q2ch7fhNf6XA/J3V43bM3wC2hgw8Se5XE3wq6EOzJJRDuDWpyhfExsFwvQ/mZvUHwKoet8FjNWg0FjJpH34aAFua0XXOVNt+CXK1QscftTwoKx+3alFDbFPkkSrNEMorPYnonz1Ft4GgmpVUb3d6+Sm
 uJReWkCr
 a/3kXG3vd+Zo8o58N50Htp8a3duqGQOHqLmDp9IhC4dY0V2dx9ZBbfegrgTlXTF7+JTM6lANmWcHDWiuEmsP0JzPIiMr4is9wYeE07N1Xc9gOeFX2BHU0s0MZEggDFrj8JR6IUL6HAR4KMCi9TDDOjel/Pa40br7kH8KVGZvf+PCnPKKRtm+EnHjXbEzbeWNXrE1qpeWJPZeq2oAuYl4qOEet5Kxg382Flcv3Lc+yPuP10BrkicvRQNCNu4RxD7WQDT+NBUxOjkCcH5Zw4mXTovglkxNC6Mg551xULAsCPvS4ARSOehcGZvoMdoxSGlhiEYVKVqWO6S/EHW6JJyvLZ/ndxuCTIOgY55OBGMZBqbhmpeSr3sDaOPgrsi3hcBXAf7mPuy+U7b9BlJInoYa88WwzNEOi0W12GIdwzYyIfFqj4Qo33VYiPWVsJUfnxIo5b1/tm9XkmcB9rduuI6UR+w+r2sexcL8Izac9xGzY7nUNgZsRRwaBnqflkxbvY54GUzaRL5uG/QYAN8zmU8RteGv/LL+WNIc0ZQaS/j7qTGIh+G8JXTYR0iPxSWuw2XKaB9yVIAcEm+RG4JFujLu094VUEMv/+tZYSsyMNuszy91H1g84P4AfiGWVUe5x0RB01gyKXHVxheqkR/BTta1qKCvnvx1W3Q4FxMKl65UV1w7CqI0B+7Ypn03+tIN+Dsy2JLDuuaX2DcaErigEISU54gUGk8cpqx9nXB8/zLPYtKMmB/eG34cD6lN5XnQ4WvprB2w6Jdv+OpekYdGTOEC1IanqDKk8G5DAlTmtdAI3OstqQwixr1iTOEw/yrnc9qYrgryJLNTYPJwfMDsn1K/O4pPdezeDqoRW7Fgm+ZzPAxCl/57F5PfTJMtk2AXvqbu//RAlh+f6My1FWxGYe+y3SfY749LLs3/xRlWwrqKOmpYbkDyKgjVAEygoDY80mCz9dIlCs0OtB32ZXEgYnhhgL97nMzND
 VLlWsWoT
 hrdCe4sbfozwq/Nkpd7z/cHKRimN3JOdiihSHabvOB30So1YlDgACJ9LIUyBXqD4dW9Hr4OH3IWYAfhsE4VqOZugk7C8aJZS91p9Vrju+DF1h96JDwNdBPomjgYHC46xWNh4zRr2sxWmxytrNmCxb737Crivf8zT4aDsFDVxQrlELASMOxpfFs0Rnx7MohGZ67Uhy2cmw5l6GpKDbsSpPIF7m/eCtbFBunm1YLT9pvBymEYlVIOIvI51AWkZpSC4Acc6SKgoe6YKUl9GBfe2pGN4gtbtz9qvE2DR3IlSpC767ThiT0NOtLSYbGEeo+g4+FjtBPjuTaaZ2JDFrXS0TbZBvQTXltNxWbik36ZtweDnbJFeRi+30fjTa0Ezj9IILATLl3MTh0uBPpIiNd9pl8jQLgCqggNH2KDcsbQD5xYyy1xxC7ZFzW4wcNVzpeWl5eFnbQ3CMh9rAkT/Dr0ieaeeaxO6RaT8UkT8Cg51BJdkXIEoYQvT7Devi02D/Vpf/OVOwDF7EJngou8nI+5aY7JvOYcZXKfZMDa3hlKwgcRhUDIHRXORTZaN6M2QlnL0YZ/qi7XKs3+sLeFhJtL16Fhh9WOOuZlo0ZfG5gsEiwbQxGBNPd20wZsP2XaoliHtS7K0ULoQ6EOS8QpiB26BewA7djUlmYV3wtKPdWYE6z4tSuKn13ObzFxSgIEknBG800bpk9nJwKbB764ciYMHQ7p5bsIGC6R2Dp/9w+MF1Vv67dWYQOMn2seHM/U8qJleZTbqMpxdBcdnHioFOEqxWHa6M7H9ARO/WXDGWoYjgQPooU5rMU3neX6onwWn3rneNvoSgSCDbYw6elLLoueztELxMby03dSxrVLhXI/d6gTneLrhzFnS17hK53omhvoEEw48XSyRK04LSa1mq5AAQnz9tV19gsSU2afPDZznT+fG9q+HX0MBLAWEvSNcoULiPmwFLrZNJqJyQawMCKxQe41bLj2ou
 vDI90Aal
 lv7M7MRha0Yhqx4wFp81kClUQjnv15pTwbfzuOjiDQx3yR2HpiOmyx1zb6Br5NBhkIL22sCTNPKASxPD+gKr35IZaKJ36LWsZahIL9+eUzJJ2+QViQnnIjEdUJuY4Ai8Cuq4YbXxVYCwj8uDGlPkZCUkHRH+voTOeOe8+YVMgDfRgYvufks0jkygKbOEr4K22GXrA1HUzXwLXRoPZvYTJeBtzWC9K6hkCRq1sb7dGYmT6zJj/XaRPYKs8m/MYvk9Ttp478SZE/c34d7YbnfdFvCMFtKLhRP4R5DaR7Zqr0fkg65zZ4YcNdF7ON0ELpCtkx4D3qAq4J0gVn/vgyYBgClMBoCQacn05mwbjkgvXXJuK9KZf9Uw/+/P8IZMOF5Vuoin8hPfRbrQvX2DXrKWblrp1hp6hEPhTiCriXBtI30iDZ4hT/RZiX6YSfCwAYl1k1h//MvvJcmM9zNRqk8z6mUxage2NyJIQhwVhi9yt6d0ePldauGeq2p7qQHsYqQc1HpCDVQ+RMDW2V8rJ8WNcN5SYhmmxk7JHuOA91p+6FbHdosh5LSLfu8tYqjd2+Y3W9zxXf4CMS5JQY684vxXe+d+T/GGlyYt/SdDcmR/TTSlrzde+r91a0xKO5f6rcK9SZq7sgQbrFoRC3U+bP6Ea7u6dON3JE91gIhfOF8a1dlNsLz13O+jbC5cCszUfxGeTe1XY0uJrnpHD5bEKgwCeItE9P/iQ2seVucpTWSQ14449NcgZeyt9BPUkahj691PI34kJkzro2wR7vpi2ncnwR1BIIbziX6t4FNbFpEVV35KT8MTp/zBUTrYkyR+coKuivdeqorPRbRVSJM+uNKq7o8bNPAxO08QzdNVCDO1AwUtX1h/mGSZkTt7rmrvYhKjS+WG/xnwsGSf+AOnQEYk2SwYyX8FLvEgfFtgTjP9lcvDGP5dj//Py+8njDe+A3EMfqEE7f9ajSqNUKAMxoKwDPSPAp4zx
 36Nxfb5r
 K04p91RSp751piNT2KYdcJpDyrWqUeHIzDcuM11gHQN/E+p6jLM7PX4IzoFw4hO3E+At8aSBTqHMY9ZkAm6bipnrxfVivis+Ff++xNYajcuPbVScau9UPDHzXpJQtj63ma2n+gXRmoyc3131ibLPyjestEkCSJBRCm+N44f7DTPoMzv5FlhN1tPJkAylKDCkB6lz72tbjOQdiFtsaK2qs/Kuw/jWNT1yCLBvGX8xXcjkVXsDW6sicIKitxle3gQfBnwHqQ7Rlcv2zqoM09kQqi+YrdvmxmsgzQNL/qPgkxTata1NAShnDWssDpcB6tn7xdxgwMGBCtTMPC/HnNHiRV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GUP cannot be used for VMAs which set VMA_IO_BIT - because memory-mapped
I/O must not be accessed on the user's behalf - or VMA_PFNMAP_BIT - because
PFN maps have no folios which the kernel is permitted to access.

Rather than keeping these checks open-coded, abstract them to
vma_flags_can_gup() and its VMA wrapper vma_can_gup().

This is useful as there are a number of additional places within the kernel
that need to check whether a mapping can be accessed via GUP.

Therefore, update all such occurrences.

While here, drop a reference to 'special' and replace a use of the
deprecated VMA flags API in vma_dump_size().

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/coredump.c      |  4 ++--
 include/linux/mm.h | 29 +++++++++++++++++++++++++++++
 mm/gup.c           |  7 +++----
 mm/hmm.c           |  3 +--
 mm/memory.c        | 14 ++++++++------
 mm/mempolicy.c     |  3 ++-
 6 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index fb21fb6703dd..9f729c594c47 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1616,8 +1616,8 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 		return 0;
 	}
 
-	/* Do not dump I/O mapped devices or special mappings */
-	if (vma->vm_flags & VM_IO)
+	/* Do not dump memory-mapped I/O, which may have side effects on read. */
+	if (vma_test(vma, VMA_IO_BIT))
 		return 0;
 
 	/* By default, dump shared memory if mapped from an anonymous file. */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b5784685272a..1902d4c77481 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1777,6 +1777,35 @@ static inline bool vma_is_persistent(const struct vm_area_struct *vma)
 	return vma_flags_is_persistent(&vma->flags);
 }
 
+/**
+ * vma_flags_can_gup() - Do the specified VMA flags permit GUP to access the
+ * mapping's pages?
+ * @flags: The VMA flags to test.
+ *
+ * GUP cannot access pages belonging to mappings whose pages are not permitted
+ * to be accessed (VMA_PFNMAP_BIT) and must not manipulate or provide access to
+ * memory-mapped I/O ranges to users (VMA_IO_BIT).
+ *
+ * Returns: true if GUP may access pages from the mapping, otherwise false.
+ */
+static inline bool vma_flags_can_gup(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any(flags, VMA_IO_BIT, VMA_PFNMAP_BIT);
+}
+
+/**
+ * vma_can_gup() - May GUP obtain pages from @vma?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_can_gup() for details.
+ *
+ * Returns: true if GUP may access pages from the mapping, otherwise false.
+ */
+static inline bool vma_can_gup(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_gup(&vma->flags);
+}
+
 /**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/gup.c b/mm/gup.c
index 66b306911703..f4d0cfcb602b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1204,7 +1204,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 	int foreign = (gup_flags & FOLL_REMOTE);
 	bool vma_anon = vma_is_anonymous(vma);
 
-	if (vm_flags & (VM_IO | VM_PFNMAP))
+	if (!vma_can_gup(vma))
 		return -EFAULT;
 
 	if ((gup_flags & FOLL_ANON) && !vma_anon)
@@ -1955,7 +1955,7 @@ int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 		 * range with the first VMA. Also, skip undesirable VMA types.
 		 */
 		nend = min(end, vma->vm_end);
-		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+		if (!vma_can_gup(vma))
 			continue;
 		if (nstart < vma->vm_start)
 			nstart = vma->vm_start;
@@ -2017,8 +2017,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 			break;
 
 		/* protect what we can, including chardevs */
-		if ((vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
-		    !(vm_flags & vma->vm_flags))
+		if (!vma_can_gup(vma) || !(vm_flags & vma->vm_flags))
 			break;
 
 		if (pages) {
diff --git a/mm/hmm.c b/mm/hmm.c
index 2f1e98c6b644..e9569b82a1f0 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -595,8 +595,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
-	    vma->vm_flags & VM_READ)
+	if (vma_can_gup(vma) && vma_test(vma, VMA_READ_BIT))
 		return 0;
 
 	/*
diff --git a/mm/memory.c b/mm/memory.c
index 9a38c7d4cc40..cb56d67b17ca 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2417,11 +2417,11 @@ static bool vm_mixed_zeropage_allowed(struct vm_area_struct *vma)
 	 * be problematic as soon as the zeropage gets replaced by a different
 	 * page due to vma->vm_ops->pfn_mkwrite, because what's mapped would
 	 * now differ to what GUP looked up. FSDAX is incompatible to
-	 * FOLL_LONGTERM and VM_IO is incompatible to GUP completely (see
-	 * check_vma_flags).
+	 * FOLL_LONGTERM and memory-mapped I/O is incompatible to GUP completely
+	 * (see vma_can_gup()).
 	 */
 	return vma->vm_ops && vma->vm_ops->pfn_mkwrite &&
-	       (vma_is_fsdax(vma) || vma->vm_flags & VM_IO);
+	       (vma_is_fsdax(vma) || vma_test(vma, VMA_IO_BIT));
 }
 
 static int validate_page_before_insert(struct vm_area_struct *vma,
@@ -7116,7 +7116,8 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
 		goto out;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+	/* Only mappings GUP cannot handle are followed here. */
+	if (vma_can_gup(vma))
 		goto out;
 retry:
 	pgdp = pgd_offset(mm, address);
@@ -7310,8 +7311,9 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 			}
 
 			/*
-			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
-			 * we can access using slightly different code.
+			 * GUP failed, perhaps because this is a mapping it
+			 * cannot handle (see vma_can_gup()) - such mappings may
+			 * provide access via vm_ops->access() instead.
 			 */
 			bytes = 0;
 #ifdef CONFIG_HAVE_IOREMAP_PROT
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index aeb99c5933cb..ed444061631c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2011,7 +2011,8 @@ SYSCALL_DEFINE5(get_mempolicy, int __user *, policy,
 
 bool vma_migratable(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+	/* Pages which GUP cannot obtain cannot be migrated either. */
+	if (!vma_can_gup(vma))
 		return false;
 
 	/*

-- 
2.55.0


