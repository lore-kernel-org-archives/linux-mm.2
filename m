Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B269C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4686B00AD; Tue,  8 Sep 2026 16:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D4F6B00B1; Tue,  8 Sep 2026 16:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE816B00BE; Tue,  8 Sep 2026 16:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4CEB6B00AD
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:17:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B182A065C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:17:16 +0000 (UTC)
X-FDA: 85191704472.30.5ADEBD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9026DC0005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:17:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WCx9g0et;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898634;
	b=nyFwXOtyvSVhGUOGwPIOumzxYpdQeVgjNV+ajKK6nrwfUcaawCIgfuAqf6XzQqyIFWe+/j
	+MuM88Jni8pDFiHx5fFW+U3c5zQuFXjRt/MpdnMLgeztrij+cBdtiZ9DlG+fSn3bFkQsIo
	65bnS//eaq6sWi4a5n0tWX6qJhY9RIk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WCx9g0et;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WoUWUiccCZ5pmncdG/fVn1uDF622HEjGzqeAT5aHc8=;
	b=JyO8+A8rLje9sT86P9MUKv8ffx2sDWXCiyC6n6nLW8Ymg1BYCKfdPLmLRAj4zp+NnUrTA+
	4m7wnBsAxbENa47DHA4gezRnwkwQ7PnJooe/qSU1p2MsOjL3aHfbFRi3lDnBQa05RMeIgr
	wjSYVORs4Bp8FnBcB0y8wZrNcJsw9gk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3C0B42B06;
	Tue,  8 Sep 2026 20:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BD71F00A3A;
	Tue,  8 Sep 2026 20:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898633;
	bh=9WoUWUiccCZ5pmncdG/fVn1uDF622HEjGzqeAT5aHc8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WCx9g0etxmzhUw/9vx7dYEuk+1E+t7RRF5GYxZ3UboiiICcZJ2Z9VJXIAX5jvZAuK
	 yLn3n9H2CIkNxPVJIviLI/un0CQOivB5urZe9HHAgD5DOtxto4kGoralvGL6kuQxq7
	 WlJdP4LsB8jP3OaO+x7IB2Mv8LkIcnHT+PIwoP8WVj8TGNcEmoljLAKM1f26rjlYBg
	 KHgC8wVn6x7kLvbLQC+H30sQyVOp0lZUZU9rB9+gs97wte01EHALW54o2MKn9uudGh
	 FvY0e3bpNwXp7EH2Agf5q2IWP50fU9Z2s03D2k/bOK8gl4G1EEOPz807EajKpcBayM
	 cZJmMvliLRSAQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:35 +0100
Subject: [PATCH 31/39] mm/uffd: use predicates for userfaultfd checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-31-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2289; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RaKyg3GqRiVqHvw/UDaaHvGcpLhQwigi+RNlsL2zffs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG6N47m4kJcv6WDE48sr8nKPqpXlTvmzNeP1N5ct/
 8WWxMz/0VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJrHFkZPivHvnoI//nC3//
 vu0/ayir/68l9MOiJTsmir23Xe51QtWZkWHVl+PpG7ifX94VlC64cdvh6P9OBZ7sQWuMT79TX6r
 6uowdAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9026DC0005
X-Stat-Signature: xybgay61hxrzwaormpqsfe4kdpszrmiw
X-Rspam-User: 
X-HE-Tag: 1788898634-30944
X-HE-Meta: U2FsdGVkX1/u4VmOHRuj9NnP4gdWM8tv7Pq4YZIC1iGb9jV21mT8Euvp3gz1D9ayW6WiGkqKnxtzk4jhAoFA3frOpppcwiAm50MZHhjh6fEOu32MMTKQ5RYj41YloRKcPsz0w1GcY632XjXLNBw0uCYfM3ecy9naSzgsBe5SJi7Pk6x7ONmnMiiklaaWSJf1pp/mPk6HwX5PtGC/J45yKel9jS+4oi1sXUzabvTLxOV9ozsQF4FqhRYgmiZWjUOLnlZzVLbCp/TfCNBRYkn0QuAYk7/oKua/l5u/jKAxT6YhQLqFjJefy/StgJc7sfBCp+puwYSnW8XwacCQDIZ22YWgCnZf4g0E8j95bQ5yMSTjT4U2qVs5+PiW9UURvO9JIpvke3YSDwqYhJS0QUubH+iQU5OMeJTAjMdBnibcbOFqgSS2ssbDpdaRUJAi9HVNFVjGD02NakllPwdpH6ff0pxWxqEMWQs2UGgeJ8fx65GdNyN+/vD6uzc6js8/wymnNYLBKNEbi77UC7Xs/rFgD1DiGAVi2b4J6kAN9blZh7DHTzjhqPC/GqIkI1LDQ7QDFc5PFwxj9lH2z3hqfe2OcBiqpxTjobPhY1kVEGryTUwiScLvasyn5cMtS8CB7suHnkiTeyekjw1QYbU8tvdfuuoB051Wa31e54aKOKuaqtHSqm82TLXGgX0cXtheKlG5PoajWHqBxoqSdLktjbhf1vW3evdsmCm7sW7fmEcGr74f4AWCI5J6HsyPGu6IduOOaLBSmMqkT+Lsyct1gfG+1+Yn0Klml1rxB+eMMCl74R4l5RmkKvxiS+bYCink5Jx2C7b2jCtyByOZ2miX64dxR27DsI45jZ6A1iceIbySD+oqTZ1lS8nEg/Rie3EDSXSSuKFKVoY8xxxu/rJFC6FxNvuGrWOCtMcF74gV9YNrrmdFD19jDTFUyB1NP476G61VaLhVaM8hW7QiZ7KhvWM
 +CgpMEwm
 F3jxepJDhWUqgwj7Jlu1lo6UAxLJHkGst5lpjbOxm+Vq1SBUD5XBvHhTHbWdjm0wX688ejHnplBCdAF/2JK8C9UowEze3iogp9J6x5yKlBiYmLnK9lzmJOeOomu5m1SbLnPZHbQ9Wz4N2PapPlsl1lKZA/7EAV97IC1fc81lOrkMdfJwV3loq2q8gAV4EjuUfY7HR5nSsH/7L4B0/g1dj+sTkyU57VNrVYYtvJ/BZ1NQMf5YoUODwcI7qyZfuTDrnvjpb4Nb/us1dF0mI7oegbyrBpZIhabvmJy6pbOdumbGcP4W57F+fpAFDSzRu9p8s4DsZy1KGtmS3bjG+JBBn4BWLQTCOzp0UR6QdKLFzZg5SC9ciNF6tuxWwVF9Bq7iqnP0nLoBYtm9yyvgZObs5+wf3HNbhZ7yWjKLK1XK3r8hb2ec5gLRHzWwoVMoxyCNs3OVh6WFN0GHk6tnEBbX5gRpH9+YL05KraxgIJo5ze/FTzcfX4Qr78yNtfIiSNwO1UF77j0QtJcA3HpxB/6GUnsXZXVBNdnlX9hNYo2gzo868MKAoaUrOUhg7fyAgAdzyGXBD6XZa3T8hyMeDDJZW6mkalJlyr8571LmCinnl8IN7ecBedrPE1i8JcTmmFdLl6bWW824lIbWL/jOIqLkeAO87l4Tr359+cKnSuGotzeX9tluRcG9tBIvnhuCZ2al9QOLN3rAO+T+qMtQJxreBjOkhnxu5L8Ic+4cVzrNjkKA2EIVpLzqpfVEYxcPzHdylTRAiKaDGwhheJyIa9ttPz3fsOAbv0jaVX78uWm31gXxhwt/OGlCYBQ4wiCEI0UTItzA39WaKdPuOXlZxUDjl8GIRARIyObh/T5iRlcpzmiQnnOS1wKeGINuSdkNvzH5XdTBvmWovU4RdOcv7sGx3uic4T+oLU8ryx8VjMezSGAXvjMg1aPjvinkNLEK+ZbYMpexgoaK2b4aUSxw2LILAG2hyIeJu
 oomUBqal
 TQUBuOk0Yn7ltKfXF/Ao7HMAjvjF0+ZY6smZXpFbfqWtENSuk1gLA8l2jqCVANBOYTPv/6hTw4GsBKTs85kuQTA3lwsFtuVGCycnH+iWDL6Qzup6v1uCd3ryYKJAtlmpOEhZKXD4gfM5mS7JVWq/VSFm+WFidG41nM54pfzLXB1hV5q4JSgzTZ0Mda/+eXkmsw6cdkXZbyxgB/FoAHqPwU3lwl6nfv4WoNaSCVpCUCo761L0FIs4th1zbE3D009yNrw5agKpMJH1sl4e/hAy4j9FtuvfotnBi6KABgrycbSdZnmyDZC5GFvREIUGIDegdSUaSMHbfILVmXw3bZIoKAJ+WWuyqCydYFuPdZ9LkAO99jAEjhzsgttKPJ2zLL5aWlpRx9kAkyaLRhgLhLhmaRUoo+1LC4iV+09eqhhPoL0T4aFNjNrf7cIhVmlUAhZYZswzTgqjy8CjHxpjsTNTNWatxdYY3wiKQzfDshqsbaCit5dwVrc2uRh0xAE/WWVhTqteN7dt0tfCxWDQm9FTPszuluwDNMzT3L9o2FvSvr/sSX/HMuqDFmK+8GMqevMEFXItsmHldgrv3XH3Fl/dpJ7gWKwIEIfEO9ClCM7i3bPN9vk5fDUHe3uYxqa/Twn4N89wOFSLggOdNxNZIoQK51tBndjYw6asVja0ugNl8qt1qNPoGeI2viQvWjC+4ziaRS1r+Ha/ZaExyCcQE9J1LQ8eEc1EsnKhhj2cg2mL2yk1O3Z+wra4SDdHPtWN3A9em/6QGS7jCHMCZ1PThMtM+9JRnt8PvgHxyJ2Boc/873V4IGqq+3LwXxs3wshw7lRj0Ce6OQblAvKTExxxixcZvo2iqpX/y/Fhy4BGcAPzhUswZlvErix/Z6aIy110xhSoaqaAHvb24JXFpuaGy0AW0GfXZPCZW1V0VVeGlWfFt7sk8DMdUeCxIkti6YUEaBEDt7QJ8ALEmhe0iVGf0U2r6OHz5QG0k
 TIybpUTd
 p+HkC6PvvP9taqfrGVRRu87LFBR57i10xsD7zdLPGdXT7WRSIDt4sCaF0Kkue4JFydPOkPLOy8FAMd97i2lRjcT8aL4J1+Fmtuo+eLF3xYDotE/8jV4qectDlEzZq2tiqtP2+XA5cjjYJh27pS8ptNBlQhZ8nMUSE7NjBwW7PL8mM729y/ANeXInwUoxUAzyyB8eHx6RL8WgLIE1DCwAtVCA5xmgm7p+0C7WIZUwgpUX0ev/URZhnslQis1h0LveIInXXwvrRcATFbj6F/1+lRTZ+GBa5FBcHWvA2MhqrdBHf8PGjQ+6TwdfF2wsPjS4eOOtDPllXVLOJNtkxEm0nLkNUI87wla1Oxff3YDRRYIW6/EbK9vYpOnrpj1afDG9/UEyXB84hGMb6JUPeRLw9DLdWg3nc68PPZr/iIuGCN89gbcJam+AOw78d045NR7C+/IJeQfWm86SphmSE3cuQwE6qqD0XK2kejZ9yWFGZNvIMaE6MS2SUh4EkYXhGyoIglk2IUlizjIlitJ/R16Qlp87pTKX+cUpsFd/WOS7c9Y7aEWYPKyl/glgb6XEYv+jsFGtIVtmXcQWvRR1rGAM/KBMF1d0oF+RVoIyZ9DEC1qvbCHvqhQd6qm8BOmjF6FsfL5t4NG+IgwY+V7OWwsWu1iWeYvJ4CTQqdRjWdNFB1+1T1xrFvR7M3hc3uLPtD36x16Bh9pZSVxTRJ+0s1hX7jezHKnaRciiUnexbfqscnsBKkOZqkhAL3KvP8a5oxk+kXDYM59iJt2eEaBbvISqyuiFDANPCIYP8Qm8caewWV4WkaXEzblKZ7ECt9LPRNHQ/kmJoinaj9LZhkvrNSJTTtfIOGHspK6iCpxHaNUKdOce7tPS4N/bwOkiR+Dxp4U58fzAuqkCSdS2DMiYCbGSySlfoWvmtK1cF1ZM5rDb0vgfpJ3gezLk0xYX8Ts1CDUbcnk9fXfDu83uj57xd/xNBp/Fay+zR
 PmFANvH4
 TTR28tjkTmYCagAdQVtIlhFAWZQ9Nh0isbwkBbUY+MnIIEY/R/dqHeE0PwAbRGuLRqAq9kC76KSNzTs5C3XYbj7JD8kWLV/h/yn2tHvefj/iuTBppC7BBKz0uthnC7NikLaAi5ozFawY8eSvCo5agNedktDlnRk/0wPi4q1PmdLD4AuZ+0Q+PdO67p3myLxcPzFbxgNSXo5x+F3Zt+3nzys+5C11JBvU32EZ8AoZyxyKnR5kAw+S5On0iZ96Dn0FG6dcHpb4zALmPX3MqodjK+9WE+tIstK3g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than directly checking VMA flags, use the newly introduced
vma_is_kernel_owned() and vma_is_persistent() helpers in userfaultfd when
assessing VMA suitability for userfaultfd and UFFDIO_MOVE.

Update vma_move_compatible() so it's expressed in terms of VMA
characteristics rather than arbitrary flags.

Additionally, update the use of the deprecated VMA flag API when checking
VMA_SHADOW_STACK_BIT.

A VMA_IO_BIT check is no longer required but that is fine as a hard
invariant has been established that only kernel-owned mappings may set
VMA_IO_BIT so the check is now redundant.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/userfaultfd.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 949017e60608..ddf0a4a3d399 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1754,10 +1754,18 @@ static inline bool move_splits_huge_pmd(unsigned long dst_addr,
 }
 #endif
 
-static inline bool vma_move_compatible(struct vm_area_struct *vma)
+static inline bool vma_move_compatible(const struct vm_area_struct *vma)
 {
-	return !(vma->vm_flags & (VM_PFNMAP | VM_IO |  VM_HUGETLB |
-				  VM_MIXEDMAP | VM_SHADOW_STACK));
+	/* uffd is generally incompatible with kernel-owned mappings. */
+	if (vma_is_kernel_owned(vma))
+		return false;
+	/* The shadow stack should not be written to by userspace. */
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
+		return false;
+	/* hugetlb mappings cannot be safely moved. */
+	if (vma_is_hugetlb(vma))
+		return false;
+	return true;
 }
 
 static int validate_move_areas(struct userfaultfd_ctx *ctx,
@@ -2146,10 +2154,11 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
+	/* Non-persistent memory is inherently not controllable by userspace. */
+	if (!vma_is_persistent(vma))
 		return false;
-
-	if (!vma_is_hugetlb(vma) && (vma->vm_flags & VM_SPECIAL))
+	/* The shadow stack should not be written to by userspace. */
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
 		return false;
 
 	vm_flags &= __VM_UFFD_FLAGS;

-- 
2.55.0


