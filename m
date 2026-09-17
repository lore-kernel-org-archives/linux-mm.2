Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 074C3C982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051116B0099; Thu, 17 Sep 2026 12:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 028596B00A5; Thu, 17 Sep 2026 12:25:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5BA66B00A6; Thu, 17 Sep 2026 12:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6C8C6B0099
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:25:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16A234040A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:25:06 +0000 (UTC)
X-FDA: 85223778612.29.3841713
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D20DEA0002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:25:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FKtFvH3J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smTxTWGKEevjb7CLSP8pWSf7Bj+6gdU3arnaSVDqSUY=;
	b=nHe6im2xu0rCDWJHhQpZriIXLrEsrvnIKLJH8nX6lmXVubRRXV2mReJgghdB4ULlOhffeh
	8ifZLxgvU780wXlq1NOFDgbYQD/oTB4F2QGnHWxf8agkWh7hw0aCUpHvi1nH8XOl9lO5Fw
	qWortBYl+yMi+BpJu7eO3K+bMPe4Obk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662304;
	b=wyfCOurtbPt+fV/A7LTh2DRf1nTCr+15zhzsmR7KCKeg61JFl/QX+DZICeBkoOrRg9zDbb
	Y4voODJul4UVDoZeoyFBkWJ/zJmdKUQD8QNFNNSnS33p1Zn4M5ao2gPLi+5/BUyHEK5+wb
	6pxSP2aGxWqEv70NZa1RuRE/x2Ef/k8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FKtFvH3J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EFC9E43AB9;
	Thu, 17 Sep 2026 16:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A4F1F00893;
	Thu, 17 Sep 2026 16:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662302;
	bh=smTxTWGKEevjb7CLSP8pWSf7Bj+6gdU3arnaSVDqSUY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FKtFvH3JVkLHGZsf8uYciO+eOgW72UaiAxrJ8Z6EShnCBvECEyuNVT6thNmFT//Ug
	 WQBBkerWbn/RiCNB7oTGkWlzRoouZbpmeKKdGJmXI4vy6vcZC8qaF/vFREcBDK3wYa
	 hFrcWKpaOhF1HX9ZAunYblSfjW+h3QPhjFVJ3fsvaxIME3zzaS4uDLtU1oV0f+NERU
	 3nrkCLxdf0q9p9vNtn5YcdtZBqIAxjROlfqBXEHoy1tKIZJgO4bmDwxfXFTAVXEks5
	 jyPqK4vfC+Du6aNYzuRmJowz/JEBr0ECvS1w0+K4eGzXH4K7D4xzRPlDlW4NO92MLu
	 Q6Z9dtdwkL+1Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:13 +0100
Subject: [PATCH v3 04/40] mm: consistently validate VMA state after
 mmap[_prepare] hooks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-4-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=13137; i=ljs@kernel.org;
 h=from:subject:message-id; bh=StVNYANZU3sF8ij38este8h5c3k5S8te34QwspMLkvk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCO8XM/t45qrC/oPXV12s/t41ZbdVbN4rfdW5V7KlV
 RdHSG/l6ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEwrIY/vBq2GzI+3HJcc4u
 rW8uVzescW7OfCmQEqQ7K0Fa/8NJjlcM/wt2NZ371KRg+0p675Hnn3LmKpw3tnXtOZAreH23yoV
 geRYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D20DEA0002
X-Stat-Signature: mo3qru53jqt31b3rmqzctcn8nkuxcwz9
X-HE-Tag: 1789662303-889550
X-HE-Meta: U2FsdGVkX1/0ZJNDjINgDqp9+cjQdOsFaWee39LzR2ibUqRZwQL1BeqE/fh3SyBRPwEnKNZRi140lGRxw0mvIcvZpazTEZkl4WXUzS2c/mQiStcU9lnImaTAtTamMQbdit53QZ6SrHm5mFMllpTfMzOMCVMQ6KwmXxLSkAwTbA+pc4MWz9C4VBQBZFzrGKHxrwUSaHvnWgt3biwaKijnKX5rTW39flYv/9NZ6YAqC/LMh+QCtW6CoEYw5mzsQmGThXdHNKdyRAGdStLqwkHRDJowarK+yceqjIUxv83WZJQuBLkst71yVqStmOV1giIOAg1dCMHABlbC249qk/nxH9ghelLRGTCgeRVCaBc/WbxF6qbAMUwIXT+KvJoStP1EhNJyz8/o9q4M+2ZO1waSIMGQ3E63AcVBJE++IQwRWDXGWBMehYXMBlRbU9yMZaiwrqZ5mRhfoDl1Yn4pj2htSV17O1IkyZHSySgpa51Gsmj2dbCRw40mTRGEZz0FCK1JhjdR0CgEs/OhCCtZP0pwyTu/w9OqUSlqMg03ZZ0/IXGb+jFDMgaN4xSx3YenTY78GaQElSH1uVTxtMDSZbXUx7h1qYddUMrjEPH1N/MM7gUyA/mtlwOT5YpXYtLTOxgbrQMgtN8aijbuvbzmBR1zMp6pXVQep0hNEgJNdx7ANsvIdE2odJBhJL0qclp/1GZ8cBuU7JJcQKQw/9CejP0NG+/vtDT46YgVGQhvzEMzNmOP1kbTz/JH7FDqmn5bHRD6tx75V/ictMTkiCLwryZ8iWC+LjrpaIR2wC2WH2JzJ5Rrq8keat+q1WCCjDS4XMlqbUY+U8rNi8n/P5CBwFH/XCDCjyn/1EE7jTXE9QI+LW8rVYwIITwEfNTx6z4+FUTsr2P3TmdSzHEtEfctrTbGqQaBdqlv6gcSONQhpG/bV3XqjQWDYcQZm8z7XMN6JqxYTX9/PcmnSK+9/JJDm3+
 O4J8WNOp
 KLtoX2JOSyZyphqZ5unpPYLFf85bhueGrdq40U0B6lvKY3/wdzOUoKZMBtCRM64CRyc8znZuLwR4tyNMwdBn1QtXnNyKWdf1bQsDEzKr3d/vWu5OYI5IwL0ATCCxck7OvWaF9oidEE+iMWrfZx14oFn4BPVJxNEekbJSKjNOOuOzLk8J71YMAEZ6XLZsC26K/jc0k1SXiuQ84XU8O/vypsCzlMzVHMhNS/GNI2OH1Wmny6InrgkmjhgWDXSGxkLq/E0gFC47xW6DfRh9mAV99/bc5wllYCTA/2FCx8QSEAB98wHtXAdgHKEjsTdHiEC4Rw9WEUp2gCJ/Y9wA6VFmypc6IGqiEDJsGTPekRNFRAI4E+ojMHlRd30fG3Da680/vw89i7lUQS44PJIH93uB19C6gBQLa74b+KDTREU9dQgAJdM4SaXNjHxKd7fpOTAY1XTSV5xcSOE22IAPUCaFSwQHHc1U6gcr2d1DgrWnC8QmKbMH67RtmpLuPuVfslnIfAHaReCYKLyeEgNH7sGSv49S+rq3V6YGxGefTSXEbcgKl/4hfpv7ot+7bw4H+I0bFclReBfYkJwFWMCSbd1HgdYHHizu/WMQDDdgYaYbm/QvgVfeXYRfwS60FAszirPNwBNFbD8SITgNMqvq75uJjAcGn7CANCEi+CY05OgO4yylhRcQPOJJCuUf829NX+BPlcHewiBisdiT1qfRJurHaoct0DkCYTmu4e/UeHjbtIwjfE8AGZHXX9uv1K/ARsjlVjan2Zuqzg3mvi3iTz1ob9lkJJyV70tU2xZrZjvwVyncv/R/MBGahZB2oKBAMTH9crIQrAlK6wVHP+e1awj2cDOdsfpz8h0vMPOyzq1+Bz3j6ao5tXewNsDj4Ys535lej1+nB8XiYg4Cm6ufbr+i4akQwGPU+qgOsQbGwA9rCsI5xho8rJJAIQYfCV5ruy6S9JZGuLQA4e66eSso8KTlF9dt5yCDH
 j9HydVal
 k21hirkb7dWgghAAepoIbPPb0dRtC2ifImccY5W2DWGm3XMPlpDAXFLywT69QUHI2aa6XREmFh0O+f0HlYL5a3m6Gbh9t+g0YI1xKU+2D1T6xqQDUx+BWEYoGWU5w/4bec7a6UgE4P8TwwqCywxumNUZvw3OxVQpOKsR5OWYC1vBI7w7367xAgA/loBKSqIGHqPuChRjnFVkTXibwkzJ+Nbgzp6mjw9VQgWr0MhQYOWmqfvE0R0hZTtoF6uGLidYabwbphuOTQGAgZ5/G8dWok8zts1QGdKYsW0tggJUFlNQ9baCVAcNE3q+gtrLsP2mPaXzyqUUWzwFpUpBhLBQqA47zCKJtILdwvoZAgnf3M/kUfm3NtQNdqFLfDJ9bpCPO8Sv9RhAQtde35CNsLwpRiZlKRdh+xRRQvNmR3UHvJ2vdUh+C1TfuNgpP5S+9bPv6OOicDC97JPzCoKR2BRcZ9ruWWuNwb2yWBmYMQ7kjb9cOitrHyxAd4+ofJpSpLAz0DHphXHlzXQy6JGRtx27qX124hYtzVWBy2fBazuxVG+H0kS881Fi81DdBVXvECeka8TneavMrOuNWNnWhfuLefVveIvsZrU+3QpdoR+Zelg9nrgzdK1MgWzSqsEhqNfhuEqjlAQF1zzVMrQrmgw8O65FifYOUfziLRdcpO9fr+HKF24jAH3Bc0kUAxrbDwlJvmiSOZ891A3osD2djn54sSzpdAIMgV2eU4S1pJmPwN7zHK5/T8ZTv/EUz1grvCa8pp5a/dICMAdNv4x+zSGsVsYl+kz1jrceeN4BU5mOS0TWPg6Kq1s7PusXeCXRahb04KYjBVEXClF/VDYx4gZf27XTbZE1lGKHufG418b6+iMC48FkDqYCgI0wEnFa4Kpa0MFcz+bsjel18b9dM6GaFckz4E7crz154c3HyD4XuQAds1z8sxMPGLw9MwzLt7anKZbjm4NGlT0BpuYIis5MWPTyzhOvh
 trP3P6AS
 ISq4MkWRHS2rshzCp9mB0JVFq3T4O+0XpOnjJvijEMmFyHaSyV+0SMq6r8INUmD8KSYyJjLz3oK2UDxOukLahHAE8EImximP3mfK4/21a5DmhPWiVCnLZ8h40Cfc0gV48uOuxL7QFvhbaEzlUE4TwmDthUkDFLgbLcF9z9t9wolXEdXdj+CgBY2chrP5SPxHbcYQ42zrpf2rLWUd4B6dwmOQCvXbEYJqiUr0/Ie81X7kFJv6QNPxZmYoc3GBBB38dFXd94xznnn1E7gEZJmITCnIcwVQfZpXEGVhJkDBJ3gmSmH2o3Qwb3rfX78XGpMsVWvFsvpEUF4sAw5oZT0eohCffQetRGl7ytWddX36NmVri7ErFwgrkYIMDtgP/O4ykjL0PbTOxzk18WTZwXxs86XyMw9Y0UWmf9gyhIapt/be07mDW269rI1AsF6Sf2Mn6N03QXpWTW8hCMdyWPqlU3JgKXBL9D6sIM5QRfZzI9LGseujFLgQh9KXpho51onIHT4hhIT+HSpxI7nr3bLkk9NYqSumNZcsueC32mVMLPBUsYviPCGujMIwBrmO6YjO1Scj9bikuKYJx8UDXEBfWegFPFq5hgfw5txZn3ZeYHatdaiLvvTciMcnpSrcBv4/sblfl+O0YLhls6UObV6kNsrzAGq3AE9AxqEtfltts6sCg7uuY+AazxDjNVuT1SEqdcz17/zmpWomClUYCaiW6qIWerTk2TiK2XnCKx07Bo+WGpB6iF9vI7NBLF2PUQFIjk0WuQwBf5G6hkwkmU3on0dHOSlRoFWxH4c0PjdDGIsRa+Pnhd7u+rI1nJsWVWugEwxtRrF6a5kUu3ugdlDCQ/2u9E38YfO54fOw70rtWcZF+maT2Trp2XDNTdLrFCvS//6Q0aTFSsqAuxsQlyuxoMi1ehu9WaRKBVmuCiap+SZfQQIpGH367e+SJhxjo+jNSqxe0L3ldcrlBUMIMxZrQYeQYh5Kv
 Wf7usHb5
 ro7O9+3+r5vDQjuvZIuiprL2gMcebBAXpY4tI20Bll+y0HP5Oo2RRyFxtJyREbktgBsmpnAu/C39Pa1fAWL92QDWbGdsKXAlEbou2XBS7Xvt9rYkFcWyTxnNcLu3+UkG5RW/DGIi1S2+FJEHkZBwE0NNCNeSgao3vojGN50qE0UEslI4Bm+rAJoEmFr9fmpEOdgk1MXF8/URJjjpMDGEv7EFOzCLhh3CZQ15KmxXHMe36UAyrVBBDRkmDAl7XdSx3P7Hjaem2+Q0Q9QYNxkQpD1KkpXp6GNWRqd265r2Yrg1pi/T8VGwVP2UAozyelW4I5dbOTAkZJw6wSqP8YFbtv9BZmKjUG5BxaXPUTcWAplA==
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

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h                   |  51 ++++++++++++--------
 mm/util.c                       |  19 ++++++--
 mm/vma.c                        | 100 ++++++++++++++++++++++++++++++++++------
 mm/vma.h                        |  25 ++++++++--
 tools/testing/vma/include/dup.h |  10 ++++
 5 files changed, 163 insertions(+), 42 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index fe576d468af4..970fb34898b2 100644
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
+	const unsigned long prev_start = vma->vm_start;
+	const unsigned long prev_end = vma->vm_end;
+	const vma_flags_t prev_flags = vma->flags;
+	int err;
 
+	err = vfs_mmap(file, vma);
 	/*
 	 * Either we tried to call the file hook for mmap() and an error arose
 	 * or a driver set vma->vm_ops = NULL intending there to be no VMA
@@ -239,26 +261,17 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
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
+	err = mmap_hook_validate(prev_start, prev_end, &prev_flags, vma);
+	if (unlikely(err)) {
+		vma->vm_start = prev_start;
+		vma->vm_end = prev_end;
+		vma_close(vma);
 	}
+
+	return err;
 }
 
 /* unmap_vmas is in mm/memory.c */
diff --git a/mm/util.c b/mm/util.c
index 016932780925..bdd5923eebc7 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1224,19 +1224,28 @@ EXPORT_SYMBOL(compat_set_desc_from_vma);
 int __compat_vma_mmap(struct vm_area_desc *desc,
 		      struct vm_area_struct *vma)
 {
+	struct vm_area_desc prev_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&prev_desc, desc->file, vma);
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
+	err = mmap_prepare_validate(&prev_desc, desc);
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
index 05d2c676672e..d6ed10cefc8f 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2623,16 +2623,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
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
@@ -2710,11 +2700,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
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
@@ -2777,6 +2762,80 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
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
+static int mmap_validate(unsigned long prev_start, unsigned long prev_end,
+			 unsigned long curr_start, unsigned long curr_end,
+			 const vma_flags_t *prev_flags,
+			 const vma_flags_t *curr_flags)
+{
+	bool was_maywrite, is_maywrite;
+
+	/* Drivers cannot alter the range of the VMA. */
+	if (WARN_ON_ONCE(prev_start != curr_start || prev_end != curr_end))
+		return -EINVAL;
+
+	was_maywrite = vma_flags_test(prev_flags, VMA_MAYWRITE_BIT);
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
+ * @prev_desc: The VMA descriptor prior to the mmap_prepare hook being called.
+ * @desc: The VMA descriptor after the mmap_prepare hook has been called.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+			  const struct vm_area_desc *desc)
+{
+	return mmap_validate(prev_desc->start, prev_desc->end,
+			     desc->start, desc->end,
+			     &prev_desc->vma_flags, &desc->vma_flags);
+}
+
+/**
+ * mmap_hook_validate() - Ensure the driver hasn't violated invariants in
+ * its f_op->mmap hook.
+ * @prev_start: The start of the mapping prior to the mmap hook.
+ * @prev_end: The end of the mapping prior to the mmap hook.
+ * @prev_flags: The VMA flags set for the VMA prior to the mmap hook.
+ * @vma: The VMA after the hook has been applied.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_hook_validate(unsigned long prev_start, unsigned long prev_end,
+		       const vma_flags_t *prev_flags,
+		       const struct vm_area_struct *vma)
+{
+	const unsigned long start = vma->vm_start;
+	const unsigned long end = vma->vm_end;
+	const vma_flags_t *flags = &vma->flags;
+
+	return mmap_validate(prev_start, prev_end, start, end, prev_flags,
+			     flags);
+}
+
 static int call_action_prepare(struct mmap_state *map,
 			       struct vm_area_desc *desc)
 {
@@ -2803,6 +2862,7 @@ static int call_action_prepare(struct mmap_state *map,
 static int call_mmap_prepare(struct mmap_state *map,
 		struct vm_area_desc *desc)
 {
+	const struct vm_area_desc prev_desc = *desc;
 	int err;
 
 	/* Invoke the hook. */
@@ -2822,6 +2882,11 @@ static int call_mmap_prepare(struct mmap_state *map,
 	if (err)
 		return err;
 
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&prev_desc, desc);
+	if (err)
+		return err;
+
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
 	map->vma_flags = desc->vma_flags;
@@ -3457,10 +3522,15 @@ int __vm_munmap(unsigned long start, size_t len, bool unlock)
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
index f15faa83f3d6..b2c3bc832a48 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -782,14 +782,19 @@ struct vm_area_struct *vm_area_alloc(struct mm_struct *mm);
 struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig);
 void vm_area_free(struct vm_area_struct *vma);
 
-/* vma_exec.c */
 #ifdef CONFIG_MMU
+int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+			  const struct vm_area_desc *desc);
+
+int mmap_hook_validate(unsigned long prev_start, unsigned long prev_end,
+		       const vma_flags_t *prev_flags,
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
+static inline int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+					const struct vm_area_desc *desc)
+{
+	return 0;
+}
+
+static inline int mmap_hook_validate(unsigned long prev_start,
+				     unsigned long prev_end,
+				     const vma_flags_t *prev_flags,
+				     const struct vm_area_struct *vma)
+{
+	return 0;
+}
 #endif
 
 struct vm_area_struct *__install_special_mapping(struct mm_struct *mm,
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 2fd422789717..2986ae6ca1e5 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1359,13 +1359,23 @@ static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 	return file->f_op->mmap_prepare(desc);
 }
 
+int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+			  const struct vm_area_desc *desc);
+
 static inline int __compat_vma_mmap(struct vm_area_desc *desc,
 		struct vm_area_struct *vma)
 {
+	struct vm_area_desc prev_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&prev_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
+	if (err)
+		return err;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&prev_desc, desc);
 	if (err)
 		return err;
 	/* Update the VMA from the descriptor. */

-- 
2.55.0


