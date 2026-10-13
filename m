Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C8A9CC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4034F6B00B5; Tue, 13 Oct 2026 11:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2256B00B9; Tue, 13 Oct 2026 11:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DDA96B00B6; Tue, 13 Oct 2026 11:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6EA06B00B4
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:11:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D1B9C0B7C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:11:00 +0000 (UTC)
X-FDA: 85317940680.22.938841A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C580840005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:10:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K2+L9Q/z";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mU7Y5nNDVHDzKFrw1lrh3bp+5Qbf32xd91WOb6VG+Eg=;
	b=r+RQc+5Lq3OCiUIImahX5aQOJPf9qMfI0KUJqCiPfHOhqrPMZVSgGVgH/EKbvxdIHpTxGr
	WSNtVLh0uwfcUG8ebpJDzoEiAk22MDLXeIYKd+C98VSdnyRNsLsHpzC8tCdM2YWBizd/3b
	xNY/nvuIRnFwXIdl8gaZj65LFKXpdks=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904258;
	b=CymqGnCrIMIR6l8ZPtcgUDChpJ4tQ1ivS+gmSa9xCYWIQ5Z8QnclbpKH4uTsNJyFYUydD5
	tr6gYN587Cqb2o1EMSzhthEnixrUyR0Ef7dZNC8gd84zEZNd4nSS3ZZTDNmZA+tjAh0g4Z
	iGOjWXF8UdtOnki0GlIHA2Q0HXC2fLM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K2+L9Q/z";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6942960A5E;
	Tue, 13 Oct 2026 15:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DAD1F00893;
	Tue, 13 Oct 2026 15:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904258;
	bh=mU7Y5nNDVHDzKFrw1lrh3bp+5Qbf32xd91WOb6VG+Eg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=K2+L9Q/zk5F1JMZQoVNEvJJrDJntVi7BRnwxv6VxSVhHPIGwIZuO6hsP6antZRApX
	 uJutW5uu2S2oKbCLLYqTfVbV5yLuZ4VIAOMRulD5xbCnMFHVOfEekoZbDQSPzErySo
	 xoJKnXc+Ul7hckWVUy1rnU5nhunwRAgAVjP/O3fXcZ+T0NAKr5vdjHfla7vtxP6vkk
	 l5HYOND8EECqPb3irEk3KXmmEnaoQ7ffjrhf/H1ZpsvesyaIvLGEKDlNSSQqnNO4aT
	 x5cP7oPFadXNoagrLSzTBY2couFGw3Z0Z7vIUed7GNHJhZMqjWaMOTWvRjwJGyMDoW
	 4OE2dXSjJ5jjw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:49 +0100
Subject: [PATCH v6 09/39] docs: filesystems: update mmap_prepare docs for
 discontig kernel pgs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-9-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4636; i=ljs@kernel.org;
 h=from:subject:message-id; bh=of2UYRzW7yp+Q771g+lXdFKJWDHV724vw+P2aUhj3j8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZzQKHWd53gm5uqihtiapbWCx05c2W61+NmV67/2e
 D24mDw1oKOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATkbdj+M3CWBf53tyX0yFp
 N+O0OiZlv2df96y+p26+eE3mhkpP43uMDF/s1oh3aD4OzFXh12H4fbVLvWRnbZLL1fh3HM+vdDw
 7wg4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C580840005
X-Stat-Signature: h81j873wdk4ahj6pm5gi81piqpnyzgb5
X-HE-Tag: 1791904258-351991
X-HE-Meta: U2FsdGVkX1/dCoHSRPPCQVpAgu4f1WNPAWnQnzwUWQpb8OFBusqAb0a35xuBXTgd2yLs7Ykgaz7PEaWb7etgXG2881SU6+UbYiydYvpA9d3NK+gaQ17kmXM0vxOtMoPINZAerZtTmK1k3IEcPwlkqf54d/mx/nBeokMvq/YF9xmrxtfN2TFWlpaZILDtDwDlUjsIEsxnq+0tZa1nCR5TEdjZMM1E8svCrIn2PnUIsdGUe/3ar15yrGuDeLy8/yyZLT6kKfLrWLMT/9KMBTkHvhAIegU5UGnQekHiQPOzJ/+gnRFwXXkwZm2209IAPOAL6TqTNVvzBlFxSpWX9m2r+O82LwSqDJU31tSe4T3l9e7DrehaeBzOk0h4q5cPCVOBalHQroyEi5dUr+gmzyKyaAUa99OkwQgt3NGty/Lnfm48SxV96sSZWgGNrCELfyiPP/BOdALXIrAGy2IngNIUVGbU+ySScL3XC8zhWP26x2bfgmuYnGHLwd09F6CjIUHF+gfPVkwla/V8sr3Ew5WbtzTYTymfv9PBY3DyZsNsSfGosC3YULZVpVsZwsEzZmsbjFyBCctG1H+iGZgv5QsxscOFja89erL+taiZqtiZuWi3EG207J4EU/lbsQIMefIuSwzn9ARixN/EqjGT5fzb1WZrZ6tEjOgF17b/rO9SgB5Ah2Ui/QOvD2JCtZUkWbQy1F/I3Iba0KvSIjvQOPrXpAYBCes9l54DUllUCYXXzxD1K28qRto0nG0OA8xTRkDs2GvbfD9aIZWs1KQyfNG1O0dqPB/i0vETbj+yK2q8Wg0i86hJFCWslrn//hccvsvxm6vGN5G1vfPiNqMe1wxN46jaCTMJWqorKEZEAVomOuRD5zbplzxkUyetKrv7Ppn6Ixx+5Tmj1qvCiuQTN6XN5oCFs8rYfb3INh0hhEP7kZqg5l2xNRRozWjKufF+PkpemwY1n/mbc0llpK85EJk
 XO3mVbza
 H+rF/W2QPea+UC+jRJrX09puZUTzU8XXz/ePUiKwbZ2G1i8N0Pqqgpm8xFXFEZ2KOYvQvudN0vMzg7X2AsLJTw/M9pOv4WH5tjS3r81EI+VI9IDFjD0otKb22B8cvatymuXNORFqfZCZmY3Qhaj/nxAwBIpVhYKB0At76FGL48QotTzi75ZKSROc8Zd5kcbgADA99goIH2d2KDr5NYvHDvR/Ck0/lzGSvrA2S1K13iB62pG0AH9Z87Q90acmOLxLwfpbrSw4DLGGT75ANrdl6uzxTEVTg4Pxekp4IO/hYhp3dmvnqwDggmQzB+SYBh+K6FXLWmnfsQYh1fqxiP/IUEVBz1zSfShpqZdAEODOxQvqQ+S7wmd3Gxi+0kdpJj/IVxXkDh+iv93GgsurlOCT7N0KUHG4lUSgEiDBz9Z9XE0+hwSEDdziieh7lC2lhbXN6KQ5LwKVdZaqeJD65LrQA1ibwAj0Rt/hF8Q/Wq4yJGxw3Ae7RgxheXzihE8LcLdPt6cSN7X3GADF3lesa6xxTKODJC4XPJIRT4LRTE49uXj/tYlenjolKFDnXDSoFprHc0+Fi3qDeGJoxYpYHPn5xEtSGspnlbVjqg7xt8NKyz9p4OUV8vcKJVrzuQMmmwPmWHx+jAJc+KPwNP0YXT21HbsvTsYvJBZvMzxVSonbfm7lbQDg4NYh8F1HEE7IwEjAZ6Z2RRNjQlyNsQ2EFf36gfUxWmpoRBQwKqWtR3452Nj0rVufR0Bf++d3x2VOxWkzNIS1hObeM4jBxcFKqHJzzay2k7Ox0TVLnek2ozIApsY9tCbjchE/m/+qUOyeZUO48eVD5ZKdPR1ltXi9CqAu8rYhbzu84O8viZLLejcfAVder78qw5vpVRtQd47VDREI75KkrKab/H3c1v/dTixECIU+E6NWz+P7AJcnWHrGlI5OHzifhBKWwqtUzRuSZvpmI6bOJ6yUqc1C0uwPNItxOCgCbuPFr
 /nhPq60n
 mqi5Zq7ItNZVXywCDuRLt/vd6IJgeo7KHUBgROxMVB+38ZnxQdVt2Ia8XW4MQRvyX46XuDcHRW7BlBBZnlmnsLc2AYAmhsOzTwpJM44x2D+1aQEEk0unZMiH5Lk5hbikqebkKTHv37O6lwes+6Qe7FtzPpIjKVQdVbfLsYqe29g49jGt92C1E9ihxB5fz6es0kkBrYzFlgep3JD0LPdvmXb0ODwrotlhbnkguiY9zhfaEvv+uINZIYiqfwK9gHf0mOUqbl7ox+46y3NW1mgMT2jFVBI30Br0TaAtIepwm6BO4IBevWkg6sEemIQ5WDcUw5yiBIvUGlUFp0yQRgLSYNMzab9UELAqdLtTSRDd1PT0r3JLQ7x6EUnbmtm/PDX/5pN4RrTrmF/lNaQo4jHdXKinS4XCOoGbZ0iBxnpXXU30dxstYBdQSb/GR53+Z4ZcTE4pbg6q2v0rG+2jPyyixBUVszmo6fLQLsbE/wBbPIv647rtY8H7/eDk+pv8p75kS5qcgnq+7jPPUcjFSGZFUefAELjfzKjBtOFDDOMMWBKd85IzQN4Fmj/2OTxdihlZ+ETZMF51+eQ8l1wbunMiS+Y0G2F8pOYIezwbxBYtWdZ42Iwln7uD8wwn3YaNwD1gLjvzT2ZzhYXkMGqBZ/fzFeaDRz3bIiWNMXwDDBNqiW+5G+eJb4a+LzRBoBpclYVAQaADm+6/qii4hdIaMihFgoil5jybSZ+Eb29796pD34S+5Jg+iVRCnyu/PhDO4cb/eJXpEH7I68G8QVaxlxmJ2zAJ2BdAEuBFWTEyJxvkK0h2akY37miIXhmfmWADD6Ll6VxJ2mBykweEoMG9/5Nb8g+ELORObU+ixdqm7nq9ki9uQB6j3ENsZD8MreT5BydoOwBunTSg1DbU/IrI7+oEyE76bTWz24w9MuYQHk+luWWnj6kskuDlQT38PIFffYVN2K/WaOOtM+gchWQt7M4ccvI/qLLN+
 tPEYTLZ8
 uRI+6t3OctmDS8rTh58oQCxVal0ZwHvv6ofsZ92WhhvQ9SfWdeK4O1BVqUqqVqN+IdJmdVoaBYKMSBGAo6K1bQwzbv+GRKefgL0OUz91LPhcuzsSt1wMp8HqiRmFAmI1pAw2MWkYREph2QjsU8hKgDDxEhbYCqtQ3+HpwQTMhS3Jo55wz2b559nc1TOYd0B12GI1A3FTFEX9GLaPL/LlKqFb+sys5x9JE5u2oUVAs9Id/UMLhcUplGpVLbN7twPcB1Nn30TdnIbePQJr3l+gde12gPiF5Bn1sIVsxrJ58dWSUmBgt3NeVbzh5G7esSk+g6Zh3xF3Z82FEb5ZYozVtkQ0oEJ0l95pnhaVS97QfvefD3PwerM2QLNad2G3Av7dLPhqwSFVju8yLFos7/x5ntj4AxHHnf/0jIG8rdTuejX5A0IXH2npIFowezM0zehh/eTtGWRvoqVR7GZBX9e1wsInJBrtj4lV9Jnc4SE4T8uAUhUOtvZiceQEKXVkan/dFZHpwhXQKwuz6+9VATkXSYqZPAOgNMbTXhRdkBn7qSrPEz8iOol0Fwsl/PdNEPb3fhSTg7c1iMr4hhLZJbn18DrEEZZZvY5mx9f69oU8fhnHvmMd7+7XbIPA7ZsUgOAQtLlzGbQe5oZN/c73Ul6qFANFun8PX074JS5KGXsukjD+TMSeTsdB7ElHRGZzyjER3hciXb2Db9RMbbM3nXzKe1tIfpYs6ZDK8Ov9vyP6SI74NRZGolXRPvZ6vB1EOZsw3T82WXYV3DlnRF4PSo4zvCsO+3gnFaw7MP5JbcPdOJYin5Qw7/pp0Ns2PzO8a7kZ6pAgAUcStQsU6nSyuD7ym/P4911mcIKgQW2lG/cRsMqreUYM9TLGvGTyOXBVBYH4J69EFVefO9X18TJZIUNTRkE6OIcEWbS/pTqSiDrdkmZu4128Qc6sSXqkawlKbdSHvxvBYp9bmYAfonIr5uv+xE/LW/P20
 Hx93HFsu
 +a84x9ktET/PNqroyt2wRrvW//g8KqBU5Fd1AIEYKPg/bVjm4zD3Rl0Y3tm+8OBcQ5TVWMhOTinDiNgnqUMcTGnKCozOj23soeOJNxf2lf8jvjtXi8KJRCJOu2ptPdtEDu9aLo8zUZS5XsIFnbyKD5Cpj0gYyg1GgL/hvn1NN7bhRsJLxDiqf4pFQwniVys5SnjGVMTlwZp/xtuBfqCxZdpyZfgivdnFv2uTyCCyhbtWZdvlJ8ejRW4LF8zhuG4olEt0z7iPf8mMm8axwIeX9jw/ETaMJMnPm07zStjK5oBLEDjqsX0n8rW7a6PHhOsKkWyKhgOSaFNDEPThtKxYygG8+oeyxPO0iqbms2sYQLflvvnI7f61+vpaQdeBexVel3MNFRg/rSKr3sgtpjascAhCprdHjxwRA2RE/p/HK0CwLGCzPoQddclmmiq61TgUYRynMLhZqfqNJqzlTfOrlg+apLB1xu/sM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe the newly introduced discontiguous kernel page mapping mechanism,
detailing how to use it sensibly and how the API looks.

Explicitly detail the various discontiguous actions available and how to
use them.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 Documentation/filesystems/mmap_prepare.rst | 81 ++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
index 82c99c95ad85..b5afbb33e5c8 100644
--- a/Documentation/filesystems/mmap_prepare.rst
+++ b/Documentation/filesystems/mmap_prepare.rst
@@ -164,5 +164,86 @@ pointer. These are:
   sufficient entries in the page array to cover the entire range of the
   described VMA.
 
+* mmap_action_map_discontig_kernel_pages() - Maps a discontiguous range of
+  `struct page` pointers over the VMA. They must span from the start of the VMA,
+  but may terminate prior to the end (leaving the remainder unmapped).
+
 **NOTE:** The ``action`` field should never normally be manipulated directly,
 rather you ought to use one of these helpers.
+
+Discontiguous Actions
+=====================
+
+Some actions can be performed across discontiguous ranges.
+
+Map kernel pages
+----------------
+
+To map kernel pages discontiguously, you must provide hooks using ``struct
+discontig_kernel_page_ops``:
+
+.. code-block:: C
+
+    struct discontig_kernel_page_ops {
+        int (*init)(void *vm_private_data, void **private);
+        int (*get)(struct discontig_kernel_page_state *state);
+    };
+
+The ``init`` hook is optional and allows state to be established before the
+operation starts, for instance taking a reference count. Nothing is invoked
+after the operation, so ``init`` must not leave locks held, and state that must
+be released once the mapping goes away should be released in
+``vm_ops->close``.
+
+The ``init`` hook, if provided, is invoked prior to the operation starting. It
+may update what is pointed to by ``vm_private_data`` and/or ``private``. If an
+error is returned, then the operation is aborted. The ``private`` field can be
+reassigned.
+
+**NOTE:** The operation may sleep between invocations of ``get``, so locks
+needed to stabilise state must be taken and released within each hook.
+
+The ``get`` handler is the key means through which the operation is
+executed. The current state of the operation is provided through ``struct
+discontig_kernel_page_state``:
+
+.. code-block:: C
+
+    struct discontig_kernel_page_state {
+        /* Map state. */
+        unsigned long start;            /* Start address of VMA. */
+        unsigned long end;              /* End address of VMA. */
+        unsigned long addr;             /* The current address to be mapped. */
+        pgoff_t pgoff;                  /* The current pgoff to be mapped. */
+        unsigned long nr_pages_mapped;  /* The number of pages mapped. */
+        unsigned long nr_pages_remain;  /* The number of pages remaining. */
+
+        /* User-defined state. */
+        void *vm_private_data;          /* VMA private data. */
+        void *private;                  /* Mapping private data. */
+
+        /* Users should not touch these, use discontig_kernel_map_*() helpers. */
+        ... internal fields ...
+    };
+
+With ``private`` being an additional user-controllable state variable,
+initialised via ``mmap_action_map_discontig_kernel_pages()``, and
+``vm_private_data`` being equal to the ``desc->private_data`` field set in
+the ``mmap_prepare()`` hook.
+
+In the ``get`` hook, the user must choose how to map kernel pages:
+
+* ``discontig_kernel_map_abort()`` - Call this to abort the operation, whatever
+  has been mapped so far will be retained, the rest of the mapping will SIGBUS
+  if accessed.
+* ``discontig_kernel_map_page()`` - Maps a single page, correctly handling
+  compound pages (if the compound page is bigger than the remaining pages in the
+  VMA, then only those pages that fit will be mapped). For a compound page, the
+  head page must be passed.
+* ``discontig_kernel_map_pages()`` - Map an array of pages of a specified
+  size. As with a compound page, if more pages are specified than remain in
+  the VMA then only those that fit will be mapped.
+
+If an error arises after ``init`` succeeded, the core unmaps the VMA, invoking
+``vm_ops->close`` if set, which is therefore the place to release any state
+that ``init`` established.

-- 
2.55.0


