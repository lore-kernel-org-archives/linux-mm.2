Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B474CA5FED
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25BF56B00A4; Sat,  3 Oct 2026 12:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B0C6B00A5; Sat,  3 Oct 2026 12:36:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AC7A6B00A6; Sat,  3 Oct 2026 12:36:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D663E6B00A4
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:36:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6751140A0C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:36:20 +0000 (UTC)
X-FDA: 85281867720.08.3DA2C57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A020A40002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:36:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5RNgKyN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3NscFRoiSw0VLcsrcN7WIQlCyh4L7cg6MA64F9Bvckc=;
	b=aspesoql16/PNzoZJ/Yh32DBicFZ6aWPbK7F7BRX+Cn5+13GwxIWYSoaWFGsoz/HQ3u402
	LmImr4VLaLNlQ9nMJ+fO8UstObsPEuBtk2GJFeKdFuBLCJohhcpSDNMEkrmO+WDJitzeyv
	Z0F7CaXV2YwsqK2hyKkLHs9Mjj0yh2I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5RNgKyN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045378;
	b=tW7FqeKa/1JxZCNckPNF2nTTdRYIFJcaxAKgtcjJcJPUdoVLR91xOPtDmXhZf272zs4THn
	GGcYP6wTBX8xApVZ6btWxfTYd4hdjCl1ps3I0HSWoSSR3SsMb/Nk+BLwIlUvDUpiT16A0Q
	tydqRJEpLOW8+U6Raq10IO2lXd6G/Co=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 34A7760D9B;
	Sat,  3 Oct 2026 16:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A1F1F0089C;
	Sat,  3 Oct 2026 16:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045377;
	bh=3NscFRoiSw0VLcsrcN7WIQlCyh4L7cg6MA64F9Bvckc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a5RNgKyNGOTC9c/3CJeTmIelZPjGEVeYTz67rOVO3dvZussd7Q4ouR0hExPOEjMMP
	 ao3rYwPksxDNKuEC/TM12ZL8T+puxUYc4cUFhYr6NjOFvDh7Diutn4Sdwj5y+AfDd/
	 bf3dQ5DunIl0Ocr0etm69qmTankjS1wdAhyV5OZyoMdP0E7aXzygy2vfUuIPu+0G/P
	 BzQ+Lff+cJFYAQS0fBErEHycPrBSSTShj1RMkpRR6K7g5Z57N+c6zXI3q6milYz6ty
	 UHLC82TGcIl6g4KI56mjFt2p0jn/Vb3rsCJME5DA+99W+A7kQNJhwbzsAhqtRjiGZU
	 7NpJGhyxDusGg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:40 +0100
Subject: [PATCH v4 09/38] drivers/usb/mon: update to use mmap_prepare + map
 kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-9-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6221; i=ljs@kernel.org;
 h=from:subject:message-id; bh=GUpTHNxmxWarSVjd88RVgsA6FQygd+NcCuy3YFJiswg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6qmbzFx2qHR71Y2/bxnK/UQ9/7dKz/27wUr1VWzvF
 pFSl8v2HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIcz4jw+HTHyVnrzs6s2b3
 z92blZ/w6b45/K3zsdCyrFN+mxKv8mcw/DONqXY0Mjr9l0VwqerSc8ub2rWPbj7tOKXC7c2qjzu
 /ybMDAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: 4c85s1ina9yoa5x1jqcsq1ngnck881zz
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A020A40002
X-HE-Tag: 1791045378-796751
X-HE-Meta: U2FsdGVkX18hxtDmH10H1svMGgrfvqj45NZCFx7TtEW0+faGMfTc+MfI0jax8qqXHfpcV4aaOnSLktmzINaYGAc9jK+3IA7iLIKFmdM7JXZ91CV47yibWusf1HHhulc0PV2iTWCL+u8KUm34zsmDmj5nInU99SXLEefTF53OISb3CPlrDapWPzXZRXZdoM8IC43PdskAOC3VytA9K5ffzKKpXKvWWjbDxl5vcz9WEoNiQ8E35EjerP87dKcproy/M0i8o0SjMv+0MI+Dlmh5T4uucImimykfzYota43OOp9KW6+VG+xcw1ZJncqkirk6o/WBUxsU/S//pP/qULLx9C21LrKGHkGNp0ADgjsRsk1Uo922Zbf4jvg0OqwzLC1YZ3ScnssndrIkf08OZubLSOmKOq9ceyuyDL6k6+96UgU+5ZdepPbgTKXGfqvszbJzFtW6M7MJV0xE02SfZIZiRawZ66EvLvja62ypJKNrln+oDzo34yEPVR7Bt/w3LK16Eopx3LLIRO10mN9H59IHzYRBfI2ecsMP1SycLUP3wYK/ZdFjxw+im5o6UmS5suDxedmJeUfc5ITpJ6IOmOZIDMFwW4qV533W1XF7dqA6uNREb+eSk0MOdvRPrjz2ty23kJtJ9R+SnWp6ryeU0thWvs+mTJ6x8YkRtnCkMGLROVVINqT35uF5u0q5+NBtoUbuVEsyej0KCLMJ/YZRFHis6xeNLYebLKV2ZyYQ6y6CDfVqSs8FOb1Mfmx8w32Xn326s1zo9GsBZBDK5AndmD/L3dmzrs7e4L+jwdMpKCA04unIQQ+TuZMIVWXFjRRTTj0vKGiV8+l1wBB1pTOKQjNPcJxjNtlqHJ2oGtYzBnomiY80yUVm+yr+ycNqEvL1UcnIx7DOW7X7ztDnNhHtE9s1l+PGA5LYZbVhsReqMVH4Xxh8HVJU6UW0egWii0F4SdgfErA2UUMV8Vg6uuMKhmI
 /q1cDHpl
 YL6JgY8OfioIp9CF51nDDpzNttxTTM6ol7yt9U/Qc13yKgVb59KUbKmcTcYgWb0seBYbYZ5Y8v7eyw7byvq6/Hcg7cz2OkrwQ487bYNn2RZakmDNNXBUfMfc36WUZMbfBHrwXys+vzTZt1wVJTE6FdnrhlZGUvwLc6Hvqe37hT/+F1AajmGgJp3+N4+337Qr9ROxQxYKlj422WIoSmBGoMrpbPRHkoJEGRrGqJj11LpCcjHftuVLcnwBrFRcl0LKblcwc5DJOK7CA6WjzKjqerad08xLHCZcgISCEGMTkez3y9L3HzEIxOMW98cMASZUICDcRxrLOaz16Be7ali/mqFjH+QKri4csIVIoiDf87iuUpFM7mzoeGOMN+8fOq/mtsbzEii079jiUDWWB5wcyQ9dF3rDkAAYeFFo8yk3roNjAjhyzMMwLz+89wtzjkIJzfND/lJNSmI8oiFdrUGGI+AJW8sDBSXLcpLZuAHBFAcvaIM6lsnPIuXydZU6AZll9ncB9u54ChudDuEXaiHBUt+9NN1w57rnIywVCX2g6xw74x6xkf4Bp6pS8VtLjMKHXW4nzzvPsZpOv03hQBIadbGAxTduhNP9+b1pr6yJuZU6JWqhE1OYn93aN2bJ2qW7wPJ3kwC/Imo+knkm8gY2i3YaRNa2+EPVBCkZ57pARIA/btrHULqkJa2Ly/f+IMS1MQ+n0BUMYJjeAG9kDOWingrreunNfquqqLDkkPRRMJyp2oTy8r2+Uxw6wgmSlVFwE80JzxVl0s83S5EHaCOiLxyajF6zEkUq4DZekcDtp5zeCAYL1zTPUgZk4C/smZPDYiWRgMq7vrZHFkcQZvCRtDHf/1lSmo2UsCzpYFSeYkwTKPl8PSr/YyjudYs/jj1vbKihY6IqIeNglJWRKS+yrnx+IJZIQDjvscMF6Vrgq7iRowpXQFP5d6yl24baxAmFoD8iGeiiLh5zrlKDZxbl6OJbG8KkC
 X8B0MlwM
 wfRfrzypuKEEI0b06HRD7z9uaEKr51w4kds1FUlTqFBUJ0aekIp2aaLWPpeRl2ZwMerHUEoRDvx8HUf8+GiAHixEwZM2IPfCyDoQk2HQMltGNKnzVn1GNkyD9Riy2+ePJyka2whn029MLLeNCxB6Ft+RQQvq3kn9zufrcYMbbM8QdpRjLjQrdKgcJ1M1lxE+Eh4Ei+ftOpr2lQ4u1yFGlZp5LsW43ZLcxRsvjDOUXauUS5kd8/ORjoCNPg6wKDLZQ+tdQWpHxoyfNLstdsNHHFNt3yyM4kOT3+MT92WJwPrnwbRO7g6As6Tc0iSa/0XmPYPtxXTHHm/n2fMjW9cLd7cA4Nn0/3WJgcZpShpHYw37By1pTm8dl7zB3em0p17IHfxiDUz+5kPj4DoR4lrTTd7tnLpXkxTXt4g0kte19riTLMtLtmNXiBtWXCWfWGxYaDoEa+CJq6OB6EivGhv1v5KLwtBeBI1SKx/fRCx5LVkzWsPeR65B3g3QS1vQw8rioT5fu6OvV8heLo0QV7JiSS0MWXbsv0TMwuG2h+s7ShgqPqY1B9LOtQCmOawCOxSuOZUqFv6eRaCZou6x4LVrVxmAPoRZXv+HjzgQN5OASjQepqFrCzrPRBHlvMSBg/wCoTBYtFRHYg2KiW0leAM5eXRkRgJIKQ8Pr6vAVpj9ziH1XL0dv+g962Q9mkiwgmmVTOu4fXFf/w3zsCkhIWD7uXxguvrxKGsJnLEvR23g/KqLFswFv/GScsk8oVTSOWsXSedbJq1bWMEZeQKKJTve9zMr/Ry8VdLkgOhDSH0r1PfQTaHiCxKVdKSGIVW7/bJXODO2aFZvvENpd9BiMWwPeSz0+E4JUucKtExeQHAMJ0JL1RyActhbkMf5wgk4rZciy8QSFcRc4rKyFrHwM85xGQk5/TdUiTbDcO37gI5HfdgfRsTo6LT5BsxDCaX5594qdQpyr8XGBtVvGe60Fc8bRcCW1Rwz3
 AThaddhA
 QGK5Sa505SRtt5QTl2+x2IBFVJS2YwvdAVXBN7jE04NwM49SilaxKijXyg43abbGXeycLTOrjYIHdZfwSa5NNe3uxLOyoOFsRNUgNnEXKr7JdgRH9jcYoAYrWj/29wIp5KtyUZpcu556+sTvQtXdk7X5pMAsU03NymPXCYJvquASc4OQT80qk/YaAB40NhAZGSEzIkyvtrwijg4K0Ch8oMk4gQ8LrjSu3xFRtD77+y9bPOyhCnMe3KzeAtQ0hucLVI4PykF45Fi9UgC59WDF4KYeQ2pH7DyL9NWJbRjwyIdl2L/EcJW4vHMYGYtP7tRqpNsIyyoHmgO/BNV9VF3Qrmm0N+Xip0S04uDiOcbwFpGQ5jbX5EK823DI8kXUzyLSSZ0T/oW6dwhjZxKM7EE3b9GGs1bB4l+MU9hwyjdwNcbhR61zcm9yaVp0LQcqDJFAcMr1HoaooYUMfqPI0vd1PPsPJ/igCRY3l/bFHBZgAPAmhct9B2gCeHPOw89klqLjmL0pVkmjKChEWHiCxtGug6pDEC6e80qGtOQ7HHevaNe6ivyjTHOnzbXbnA+EQ68cLcMHrj0RHvDD0Z79THjxjDj5rSe6RgLmCDj5NWX8WdfSaqtAm0Qz0MAFZ1Xk+BXHJOQqJQzbIMrM7TRBRL0Qn2wB+aneELSsTc7oMhtMp2xa5iuePS935xEkwKXSku7yKLNWP2E+2PsjW+A4iMRzr+MwFBY2EIOGr8JPacpMm+EmetXT0laDRojMFa4xQXjpctOX04sf8WuNBURPv45nEJonboSgOAI6FjdPk7jg6Dvu37q1K9wCLzP4CYf5R9tySvYUZrqlrxIPtjgw67VvHGK47qqLmcKu3CjdHd6pYyhIkI1DL0wowV6dkcAddXdFiGWT9O36ywfXu5YkqNF4Zn/h3EL3bFI5L3zr98BxQtZJNjezRZMzhuRHC8pE+I2+liS7cFT93+n05d+DC4Tjx31YuWhaq
 LTTRZf2j
 J0vcxw6uU/dUV48/mLjVmfEC2aX76eBliZa9rdXK+qFdLT4694enild/gEj5zZVnIbEiwqFjRxS4F4wLX+H0/AMSnF9CgkCp0zQurbD8jkyBbZT2k0aIHO/9aLD7m70En8cr6yqlsi8n9+mEb6Uo/iYx4e7Dm3nfCTmNnAwBT6PhyJnjHpqTNTEruZibVRb9hicR6I1G6qHNhPVZ5EUTtc3NuUFoav0K9PJqmUe/WW596/Y2ezLVhoDdoCy0fPQ5EAdACUvdiTHJxVG9ramsrW4xUapbwFqkEGpYysdZeA/balVIPI36YAeSlD91QO8LCL2PIFmw9kCg4ML1CUzk6x23nbrZUsT5oKSg+Tn7dy0nE7DH+ilb+4OQ9IawRLPvIJVDTkcLtyATLdH6DIoLwA
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


