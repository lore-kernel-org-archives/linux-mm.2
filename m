Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D0ACA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A6406B00C2; Fri,  9 Oct 2026 14:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156C56B00C3; Fri,  9 Oct 2026 14:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045CC6B00C4; Fri,  9 Oct 2026 14:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7DDD6B00C2
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:14:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7FD89A7F0D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:14:46 +0000 (UTC)
X-FDA: 85303888572.26.BA5EC71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C640140007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:14:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Js3B2P5g;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569684;
	b=vVLaWYu2Au/TZKPoEOZuAQhu+BJWgKKf+RHlu4M6NXCSVqZDnEucNi8KLioBTxcXkW15gS
	AOeJagvOBVXGFAMbtYCAY3YIsIm98vZagtJ23iZoOjrAVPcbVPkC/mWC2Kkj0+J6GjTUi8
	xYfknxKMp1kOlv0FQb1J7xlkNoPIs8c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Js3B2P5g;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2WAPq/01IfLjO2S8vhrYpwSzi1RQ9xk+b3YXsmkfaS4=;
	b=bHX1xcTmS8rXaCp5tcCrxjSmyUWQg3p8DLZtAoDWYZXKd2vKb5GKLoz4PuVOYxBdHTomZh
	zASH+8wm7Clia8iX/fIXrDlELkfmuIGLh2C5lQuuIdr+upXVxqLAX/mVZPR0+id67Qnb6w
	mZzaQcie4LV9O6lRr7EQS21EGIoAtm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F32160267;
	Fri,  9 Oct 2026 18:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731CF1F0092B;
	Fri,  9 Oct 2026 18:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569684;
	bh=2WAPq/01IfLjO2S8vhrYpwSzi1RQ9xk+b3YXsmkfaS4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Js3B2P5gbPAKU65Dg3m8YeIQgo/m6GL4gZ12B0utWLjBrrqVOPuvx00f2ZeLryxql
	 D/mbhI6bTWdbA0voWMSy8G1U9oc6vBfjynTItHS/GQGAgCc9desa0OvJfzFRe/IbxU
	 xXXqyZJPioQFUuYDBeDq+ZrxAWN2OOiZWdFdWi0TKG0Q/bSrkaPYdsM6Py+1Wm83ET
	 /fk7G29sUrFBQuK7NzNyfaubbutdekeLd+bsu84F0AQDwb3pZJAFOiq4sWcy4s7V+e
	 kTR6BeZ7AY4jsSWDLiNbgo/RrPtGeyqsFfJ+hR0v6OjM5nG2j/QAhIkTnJk0ECa++c
	 pxlqTSQDA71PQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:23 +0100
Subject: [PATCH v5 29/38] mm/madvise: update is_valid_guard_vma() to use
 vma_can_merge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-29-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2028; i=ljs@kernel.org;
 h=from:subject:message-id; bh=lESe6gCmDf4+F4pdn3o7bqurkD1VaVSfNfkAaTS9RAY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6szN4chcMokh7SGzyaaNWwQ/3X9/6lBV7omdU95/4
 vv9b51sT0cpC4MYF4OsmCLL8y/i+4NEwuZ1XvB3g5nDygQyhIGLUwAm8imS4Z/t6YjFMxbrewo8
 zP/jYRMmGZPYv6Mw42vohWv1j5avvnSJkeEfz+a974R/vMzxEY/7qqcsJlsmmHrktuuMHSXnHCX
 fBDMCAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C640140007
X-Rspam-User: 
X-Stat-Signature: xo85bgt9rou84e9xcjw7g7foad1k5u7w
X-HE-Tag: 1791569684-836756
X-HE-Meta: U2FsdGVkX19+YBL3/CWdVrJTgRa3IDRidY7yKU4BSBbEkg9FQFmvqAsjakCwlNTJpmy1/k6iM+eUtow+MxZpkby/ZgxjYBx60ayU2voINgMVBtRZhIRw+vgot47j+S6kEnQjE2MJ+CV0jEI6xix0IVkQ4jnBEsRUAYQmRyiMZzpTiDhA5hr2W4s3xquHuoH7nKk29XF3QbNjGC4QT50OufbexrgV5nM32cTPeMVtkg1UIcMuTp7SlTm+Q7a/pVmMnLfZwbGHvv4K68RxurEK4KaAhYfFWRxJMpMjKQgLXeIuopt2Z/GgjGMTaBzMdTE5Z+BtxEq581wSJ4fOLtN+AakuOJSsUrvnl7/RazjU9C0P7EvKHpzyS81/I6viqCdsog55b+bbxn76YlauisOViyoxA7Lgg0zc0ZeLykEhbXWlTnKA7YfuPkkrq7bysgeMk3ci2+L/LmN8S7EAOt0kvZj19BAILbHHOLy9HqY3+gaFLI+WLsOA8ieycWA0L2JwakKXMvz7ox/06UHNNGNTp3IaMe8WH9UJY8VJ0fX3WZ8IQ0EBpoB/4ToZ4ifuY1/vRqnJ9WVQQ+I5rYM8DtK8LBsPbLWAb4UN+hNDDj63HqBUdU9SuokcN7cLqQTQ7uZ6Qfy1cbPhlqxNzTTd4P4OsZOxU7xSwYKSaaIt+yN3KbGSE5RRfoHYFrGqY1iPvuCijw3ewEGMe3WlA/ASmzStCdb28qL/83dRy258vm8+StT5avTc0JV1sz8eFb+emfMDtYzYaDKkEXWQ5WPFdi+aOZp2unIK219Nq4+zge7Ij7Jmo2C8AnFH8n+K1+7fWR+llFUQzYrFiRkXF827z00XUf8gpb+CaIdr6gfgchjCnv73ObfKS0972PQJbmBoA0wccTzLhFryJQnqGNkFrD2jMZcsA/wKRNqNdrTjCyTaYhUaGu20wnUoubF5tsPMdkVBn6vIVjGLt09WyePb8JA
 o1aNob0S
 T3cg5kd/sMjOwJhnX9BYFBgc1Gy5aLBFnnzsY00NPmlcq2DHyyjj01fxEtktxRa6ePoyrTUEUuIWGc0LpS9Jtc2UpECvOX4/Jv8wKcLf7iS0pbveRNC5kKBO52OthggbLfTZrulRHc1dSs+Q+mkrPWCD2XoTdvm7TC6pSsS+ckhBTAYE/qDXAR2xOwCrOdTG0hvHOOroPBiD06RFxsCYXpvToeXqXD7F3oMiqaxj4jbQ+L993jYiN3r0pzV/y9HDS3Gr8G8I/Dv7Hm9EuKfE+7cnEHP2K4c9WhTwQUUVrqxsVcQa2jDwBpGXoRU948m2Rn97uTox5mDlSz/tJXaeqgZz2egMlaKJ5Z/3uQ0CazEMqDT6EGtLnmla27R3Nnm14VBXst20jVub0fG/DZKnoKTMvt78DBIXIbjPFH0o8p1tX2niTMRIr415mq0s+7hdhjRF1VYmIo1R7zVodQqI/auDwQEoCzlC8XjhFXJOZIqYD48gKDIihmtPCMPbotLbNN+x9pKhVjnETK5Cp2KgblYKv43FqEac7wAnfi4W8SdNgFoZy2wiCaCUOHmbf5kYLI6VSBkUfEiIaJwioElDWcpCtGckCb9JRlKjNb6wpxt85XQHNUJoZD2CzSHL5TrUftHWJXxExTqyqHZvsNHKLQrxAK+g+/u3D3AlN4Zj2AlhHoY1GIDTqh0iRec9gZCM6gbbFQRWX4ePtl3eAN9pcY5pyI+cpZuyHQv6g2rIdzD/pXqyg4v/6pG2KZvCWIgChr3zn241tqYmt+F1UpEZEXFcn/bNPetVp5/tF07MOK7RuvW02Bl1S1MZ29JIgdRuIHlj7xeGTjqs4bWnTKgV5HVszw/tbqWpNwqKpXTnUbgAIWtjnrdlr+Xvl7NgcumCZK7PRM7pQ/pFQAThBFj4cPm11U2dgGZQSnvXOC727qjTE0YHAWNDCPs9YCk7lpfIjSKabq3N0Y+tocLHqO1YRgCDa35aB
 CvK1D71m
 6f0hl+KO/h3oPLOcyClsiUwxjnKIl4Xnl14mmtnG4eya39nYu7AjLAn3A/KHCBOiBGYeE5jsrRCmf101n3eAc9jPEqyIZag6clpMh6YigBpcxKNzhAvqRtGnCB27sl3hp3H4Qyws905qUdUxHaX1BDfAITE2qlo4clAuI2qgPmiHKRDlvjzj9NYJuuNjg5vzt3NrMtLtaP3s1fnCzKMIaedNDxdhikRHtNuw0COp1KEMsPmepiWAzblC8/35yiw0h6KXWkEPPv4DeNngl+iy9Od7KLgGsMmWivI/tlD+2Xh85TO3j/UhT0LbiqgB3XBGOGAjwKR6GWFstA01gT5SSBgBbptS1S+gAX8MV84wMixqgzXIM97xsA/qB3fI4OJ47Wl4EKpOl2gzWcw5ckySdYGg2bEQXSCy5yAl1Ozo8v22P+w70LLL+ERjnHDhDaiOdffMJY8qYtbURnYrFEQT3wrCnkctH3UF8l4CzC8l3YPhyhzlEM02A2yHpaoWnYJA1aT867h+W4ym4GToK8EHA9CYY+8qMchIXSKWUUdSQ7FwFjMIkFd3uEpKuOrbHCNyYkpGgPGdAM08OHFt9wjE1XBl624Lo9x+S/PL8zrIkNUhPfgN/2v9Gw+URcGIowTY0Z2JGBAGFa0eGwIVquhodVkwzVQMXZNr+nlKbzBYGDcmQ2Litn4UKEbZQmBBlFqycu2Oehx3FZJU1/DfmrgLTHXz4rLws43ukQXzex7Z6Y/+rB4v59h/4rT02JC5/antiR35yhU6JrJdGlypnS5x6m6aOT1z2z+NM7l6EqqvJR4nWMWXvIhexkqvaoWMNTi4Q3L89CRFNC2Arv3VegiSHrvhlXNyXGoByqwr0apK1O66mQozuO8TlLvolrpSn3cAOzBDQlAeU65w1M3K7IgnPQLD4rkTqyA4M8ZPFNDLTi4+x6vvwz68WXiyQ2swFBdDIn3+645mCG/AVgLkhJGlkzsBWlxCx
 ptUCRVai
 ecANVgTWHvawt5Nz5wB0HvllbHnxk5AphiXInMXUv3e5+Wq4GEtdSWS367U1BuMQhj/3XGBzRZUopLqa08F3vwjYnmmSS39QftuUO6pPOZ5IWxpXK78+YBqkgg8lvwlyG489yLJmCmEBQUXRZs0tJzv77tGXunb5iMw70DncmCP2AHVFgXax8zlIMk2JzdJOMtr/j3G29UoFAnRGLUHxsSFCWjPXJf07Bk4foSGJKvAXaGnUq2NipubKEbbY9bbfjQkY76W6erPR6tkw03FJ+KOgLFNy5jABmWaI5pHrBj4zlBb04WUrnIFuuo+P0Li6rBtPP/IEVUNyPZnoMXYRtLg3Gbu5wb9Tk2TnjxvCRTJQaF29WSoPXJPYdzuubfS3gbOYxEmjc7T/+a+PQ4wR3t0fWsURp58XSq5WqfNYtCXbkCde6NL6OjJkYzcjwuWfHHkmX7eMzVBo+9Xq0xGbgM5dJVAr+uDMzJ+06kwQ3TMXfe9zl2sVGpsq7mJOWiUliDltFNFLP/uKdGAwNbykTNx/eCWO/6Dap2ieovqrnrBmZn95Bn5pJwc7eTZkenN07TPR9buJXpTYtO1FxbaNd1BbFmv2P2CVYzGc+vvzvNh2XXpV9VzEk9qY3BBtJFFOXxBlK4r3HSvf1LRfoNyDrQLn3NLC7u4aiORFwlLwSOsj5zu2a/yfBPXTfMGKvotk0uQr1ai7BVxYuDyEoW3Lr5Zm+QFBhTcA3fnoaMPEsf/fik11AA5+QJAL94x3GuGJpFdMwSXOtfXBQBo6eWgoh9SuXMCbb6MzP+KEwhbR5ttk2op0Au0XpKelfnjbrhcc6jgz+M/zuI+gSuoGEuWamiqt9+uTT/C+94COlpIUlCFOuWGunP5QA665+DFd9b+8L8MHYac3AzPiSuZsSx5PKP7mIYb5VboL48+0V4AkYWDoqh1OaoK/lUu22xNu2eazhaug2zrThgesYhj0VJljQk9creboF
 zKk5Z62X
 0h2dLx076rIAsV7ecZ4ZkId0hItP3U0YLoXdmve2R51yXD9iMM5jgOKXk//vQQNeu+d0MiqpNTRncN+yNYNWmL/VBEGh/vSEAuZn1hAc0Zwh9Dav1h/o7G/HE/8ZKzl6pTumWpIM2W0HxNCw3znXpQUVDVbVF0xnA3DfBKMSw7P7kK7WX8QD15G91zzCKkfYfazCccB5VpxlNq7OQMtSy9/YUg7w267JErcTo2MoJ3EEBOlwb4S+ythE7UkWqb6PdN4N943TCytrieL1r6AGBYD42aMceLK+Koo01QFt4yUkGh7ivtpaN2YAn78S+VndqlUeHwSa6f8lv/FsGkEQKlNClEmSXoXlTZB1MVuBSAbkYTeM2U9/nnYGkpr+YVM70fDXxPEKlb+PnGenH5kQJe/2TMoPIkvZm7Pd515P73LOjGJhbfmRUs3RNk5iEPumXl56XxT1q4ym5U1m7tPT4dqfz96SfLldA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We currently disallow the installation of lightweight guard regions in VMAs
whose flags intersect VMA_SPECIAL_FLAGS or VMA_HUGETLB_BIT, or
VMA_LOCKED_BIT unless allow_locked is set.

hugetlb VMAs set VMA_DONTEXPAND_BIT so this was already redundant,
VMA_SPECIAL_FLAGS already sufficed.

However, now that VMA_IO_BIT is only set if VMA_PFNMAP or VMA_MIXEDMAP_BIT
is set, this check collapses to being the equivalent of
!vma_can_merge().

Update is_valid_guard_vma() to reflect this.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 467601a8525b..0922d5f07a12 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1221,19 +1221,25 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 	return error;
 }
 
-static bool is_valid_guard_vma(struct vm_area_struct *vma, bool allow_locked)
+static bool is_valid_guard_vma(const struct vm_area_struct *vma,
+			       bool allow_locked)
 {
-	vm_flags_t disallowed = VM_SPECIAL | VM_HUGETLB;
-
 	/*
-	 * A user could lock after setting a guard range but that's fine, as
+	 * A user could lock after setting a guard range but that's fine as
 	 * they'd not be able to fault in. The issue arises when we try to zap
 	 * existing locked VMAs. We don't want to do that.
 	 */
-	if (!allow_locked)
-		disallowed |= VM_LOCKED;
+	if (!allow_locked && vma_test(vma, VMA_LOCKED_BIT))
+		return false;
+	/*
+	 * Guard regions require a VMA whose page tables are managed solely by
+	 * the core, which is also what merging requires, so disallow any flags
+	 * that would prevent a merge.
+	 */
+	if (!vma_can_merge(vma))
+		return false;
 
-	return !(vma->vm_flags & disallowed);
+	return true;
 }
 
 static bool is_guard_pte_marker(pte_t ptent)

-- 
2.55.0


