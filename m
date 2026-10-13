Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5B8DCC6B1A
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABD886B00BA; Tue, 13 Oct 2026 11:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A74796B00BB; Tue, 13 Oct 2026 11:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E8F46B00BC; Tue, 13 Oct 2026 11:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62C7A6B00BA
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:13:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0D07160CD8
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:13:33 +0000 (UTC)
X-FDA: 85317947106.13.45CC3FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4372F40009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:13:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ve2o1nPV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904412;
	b=pjbbVWBg90JGxGC4EZju1ngk3nbCQGwbAU6p9jrenkqdo94iFaA2D4z+2t77pnRLd4KM6n
	lsGe5HuIea8ttXB/cNXh5FL2g0HwpRly1lD+5tXDrvajA3DkO8fLqZPF5BrCzvJqGTaOVZ
	3MbuK1Q6U5oan/LlUFQec3JBNX4f3Jk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ve2o1nPV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNT7r4CjRxGgpmU98KAjnsq2tgE7lxMRwVW+eBf5yTA=;
	b=3qK628Et/D0ol5xVJlG7lS8rwShY67FNYJZXJLmAdNTS8i7vioCeXACHpx+7M8/DHJ2PJP
	dMHK6nVM746HflAmjAZVpyAIS1p82626J/sIprGcZzFXvpGlCT0TLg5tMbSfKRPhUOrNyC
	+bVBo5Q+KEvb0VS2VR5aeP8NEcjnmLw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D53BA60A52;
	Tue, 13 Oct 2026 15:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95521F000FF;
	Tue, 13 Oct 2026 15:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904411;
	bh=vNT7r4CjRxGgpmU98KAjnsq2tgE7lxMRwVW+eBf5yTA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ve2o1nPVh+LHGy9ixY1aQf7xWWVVO7dZYQvgBI6O7+bRF/qj5gbUCIwvmDf7pX8mJ
	 XdyU8DZVrerNAPmugb5rzySHLdqP/BLHqVF9/qikHT89JOpkW5ujxM4YbsIjjHq1Lt
	 VaWgxxBRXFyQVNUw+Gq+zWnh7sQCZFgEwYaCARQbHIsPzs105epjjHvgGKrG/jvnvD
	 sKfRV17R8h6abdWpcUa4Q8FVNeSnIxbMqZl68cBPFzjYsf/6XQWtcdsLJqEqIxw/dK
	 Y3pYTWg1bNPVDYDnXo5Dm+CQQ0gyUwNHq+N53JICY6cYQrLs2VJBjzt9/OGxMWVxn1
	 TLWvmbBlLEX5w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:54 +0100
Subject: [PATCH v6 14/39] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-14-1aa3c9b139f9@kernel.org>
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
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2233; i=ljs@kernel.org;
 h=from:subject:message-id; bh=YL/D7PzUYFsfQy4n4374d+RxPJLgGfcMIAq9i3+xHok=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZzMvhTb99+L8cqk44+Wxp1wnGvfvN2Mhdsy2Ypr4
 se5jcdMO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRyL8M/xP5Z71p5O1Lq/bw
 6rzs+GXJFIbK5OVKqwTC9+0SXzk/pYOR4R7nXs9teXv9bTjFY+V87rTrrApYtrB6mlftu1DXDQe
 UGAE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 19kuog7scuj3xmfr1sei83brzk7rn3jx
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4372F40009
X-HE-Tag: 1791904412-632560
X-HE-Meta: U2FsdGVkX1/OKPBoghD0t18HsZW50VmxfCNhzPBC6l4Skw/cgG1MtqpmcpQKRy7eOyMfzFeNtdYWdY2odPRrA60wm7rq1yMCjA0mCurGKPAIc3/ET4FWOHe6J6tgpRNQOSS2BUEhuvg1U7x9P7P5rKDSIy0pGCB/vqxtjNrWqwip9BGmBYehK15FTYZu9k9mUemOhL5vgyFYQOQ07AaA1BCiUj6FWrz80EawkvEnCxW9beEXwTpJQefHJ8p7zu0xTwuEPNl6DU9X/EMZ/fU0AbTwRHqBlGlIpjk69LVrHl97wWS7t4RXEc3H1/ZuXxYydsUggG56j5A0IgKrjVSpVSnV9RUQ/dgqRNqrnUUUs5WUQPn6WgZHBynL75gsEk9W+dq0dof5aZLnl51eKdLFyK3/xQCczPy7PeSQ0ToGLiY1rutjF3R1kfLtiiVSQcvwfBaSeNWc/DKfKLUJ404bENh4mIGIg2F0n14Z1s58PtJ9TyTSOMnvRyJIxbc6i0onAqj/ykZmfNSX/Q2O20qU2h9LNTUR3DDuII9uDZdQL7aYwY+NVwL0EPpLIPPRiJy8NuJcl35kP2TXohxKvwgTZJqE4PxrVh5qGfCbxx1Sqj6F7wxzMB0P/2V3bDc5e2HZMdP3z8sxvKyRkNP58UzYOHDFRJw/pPa0i2lf4VuJtgeVsN4kzLVqmEQ4XG7CtUe30lWt0dES8ji20jZ0LTyIdw3q5++3EMuFRAfqoKUdx0fyNMxXvlutzYFJ0hw0J4yCrHnCS5FJcijsFn5+PC5QVHx8BNVicB+uOBgeXMguFNPTg4jgC6V6m2v2/ICIqSayIGoJxNzvxR2v/lJRtFhavfGXy4BVimz6ptJvkYUWz/hEtTXeMEFnzDu9DPakdr0A6CY79IMRb7Ns4De0r85YFU6GD35vJ3tJr4LUKTKx1+j+5pe3wrTIVAHUcxkrkY4D86V81cTHroeGAfifZEJ
 ck7EBDxI
 CF7u3ZjfSrF+mKpIgTncOVosnUc43BUT+WrtBj6h3HrX8l1irK15jU0lBNihO3YNWZpZtVveomOYKqS6tyesRptsZ/Xyu2Cs3YHESJpLm50S2HtWGOp+VjTgtMWfMz7WzGvqqr+UTBim+ku/x7l+s25U9ovGQcP3Dp5FUlZDj397V+4g6CH7b9SvSVLaOAzp+yQcJQrsxZ2oWIJK7XeBqoB04ckh6A57GxgTa+EzJNWhmuWzLPMrfynohe6WqvLEd8tlLGsh2qSguPhlrwmp0zHYoDr/W2DqrvowytSAJnuHp84VrEmsbc7eISfDEj3ovA4x3EYKsCuug3k1Xab7fV7RYdzlp80sdfTeIazvdUnmTjjOf1xn9NiHGEoWkmDhsS+N/71fVyToETaz7Wte2mTXL3adsOZZZ/7Bo0fsh2G43tHB4dmPsBl6K3FaAz+Tb0DTienHwSfTs/3WfiA7ogacAsIQ7H3RQBycazaNQlALPrX5RlO7zyrFhxYYhRO2cGLYkaAAyuS3+ewoBdzmcLHLHZ1Fs5m2DWuqBKhPP1SHhCEPUBfKT+/yNsEoDavBE5XwMTK0z/rhVKxJlnAcnY6wC26Oeb8wNcBHq0gAD9Yl09R0XKwhAGWsgz9nNa/8rT5KRQlJeEeA+WtIw4N+TTjxQCYmkQ4jqtklTlfmguIeOkQ+YvOTvs2I8FcmXPV1yqI4LQCk98bocC2KlB3AhH45l9wWKJBHlRMgor70lfygiq1tt4UqLYGqwvdUme7D2yozok2ombeDub9z0vZ+8Rpfl+j91fXOeQuyh4txowGlM8IW/W2wtWbogyd+zhvQg/pW3MZUkmpasMehkhZJieuATgBcq+em9pXKR1SYbZh8TxL7JNJCdhXPUUFfq2jQWDUSiWj6Q8Smti4J+wTzTua10+BC+MxzH0cZoXReu776FXbyceHctAZm/z148zhcPyhllmtyVbls7OkUQkziBvW7BJS8w
 Yjsq3Y+Q
 P7qQiPPIm4zUogT8F0ygtH3QS+b1T86Px/5R2BZyK8z5GQXm8DQU1d52ytPN5ar0yFbY+vhmYl8pCweA6N3gLbkitmVIThXKWZbq86y1qAiaWa2I/KjUQuf0O8S/9vUtXd4Irdlc8XCxPfmn0jukKstBkLs5EXSyeOYeusDPkgmhcE3zzAnhqAW5v6Ixx3QKPWfCS4Mo7pIidUNGPH2r0mS9pbVsCooSSLWosHB7CQS5zS2Ve23cQsxI9M7/UCiYdwcKb5Vrco6dBxez/PTMjioLD7UdDdEZawXPV7u8KP2aMWSNxhpQhZtXf4PiNRFGhMMnjncsEoncsRmWBW7fMDIfhb5e2bi111S2iyeSCzhyWpK/98bnS86XOFu15gC2jVxND3AJGo6wY2wILedCSc435BOx7Jt0cRGq/SJA63Wie8R48hvPtydKGErkmzYjBZukW0S3bx73oUMGntA4tfR1KMdporECExA9aZhC0mwXZCMiog6VU3SKOO79aK3IZUWUoXmMNq6w4Qf7VAGZ5H1YDoYUpNhSpd7nn22Ox3mYwdo/Oaul4iaKOUSZeHePz+OLAbt4CBH0B7f1LyZQCH7cISwk/ceWUOfmjuQoU1AKty1IP4kDdqrLAVv4bRFrks/jz/LGNZk4ZHd4zkdlUAZWpUkwk5kPMxd9VLC686N+E99gU1Cey2Pp/LU061G4DwJqPG2+i2MpFFI3Tw9kmU1Jru4JvQ59GaaX96eAPPdTrqftBBYPFBpkSTm9IpLDwpiCAqDUtIWPskRAtz8vlLZDOQcRryJtm+nDHcfiXXbwN5EiSqa+/e3exEIGT12nOr+XSPWRm2uMv9bBpV+r2F+eZQT4HIylcGOcqv56H9mb+7huf9w6zLdtRYMjVhbuZ4IHsE7gYl/prtQ1d1F52DBbjlHFeKHyQmtR0CB9qTqgLWOKUTs9LA1Cv0BIJlPJJ36yA7zsR0c6Grtc+CBx6IQZ7wq+g
 Dnaho6C2
 y6+1nFDTvYYpJ1BxG/gmYaph4Nv6oxibAuLLsRHdsIz6lgNhRXw3o+BreyTBUvBKthb8AfEe4Nki6YQhFnfb6EgPsMhtrdLFNlrfzF4NKCd0CowHUDmUpWN2hBB88P/ojC3tihIVoV7D3jgSwIV//48UL/afaGtGLklWr+i4AAnZWNX+Tsrirdk1O1lsyg/K91aVvYr7wsbBTXgD15YvOFc2uJtWbQa+dSqtRAFc/QyPgbyC6K/Hq+VFX1Mrqno4GlBuX6vHnFN6wQ8238pDvRN0XrEcdRdoWPEHO32pQ6NBzbkR7gqP1CJW6IvYopaC55ityHeyQskznbfNYEKBnPwecJ/mhfYs8xZCWbQyR5LbnlAihAGUHtDUcBWHt+kqONWZdCf0AVqopOxcRhDTyRezahQ/fMZ1HvmiRBlr2yjNCPlV5QziFcxr6n9CsfkZ7XHQqS+3nmUWkS7Ya1TfXRAiaUGNpB4H0LZHF4uW6Y+pH9iodMP6uXF0y9wqFf0Psb4AneYBp2PT5ONnReKgY178px+r8Cs7xGK21s6GF/E6iuGL9diEjSrDbISMMJWfWYd1skbP3sBAXnrg4W/0+aEej0zrINZicF2oUSu1haRgs0qj5qLqCM1Ym/97PGVO+UhTCngNc9DEehuUy+sN3vyQSra+Srn7JY9P8ki8WB0JACCDQmAxHF9PIBKiYtJOZL2lobDWvvzaPykEFNxIWe36K2ZeuRRhjyYtbVbKgjDrlozR4iMV5woDdqYH0r4qfwaIBJ6yZcUynK5DDxKI6g/y5NcRPAu6XzHleNqtCIGIFMOdaAJK0EXjaGcXRxT1RLyPmVETjSCN6k/ol0uCRuVpQ3PAZ8WeQmoafhCOtR019ZiPZK+SqExG/GXzIizr5k6+/VMlmNHpHxOE5fty+ekYACsFCKlu7+EXj3oYdIYx36uoZiGb/rPXjjPY+cKWHrlURE8tVH8id0Gi0uUCXLTR73eKh
 K17vPNWE
 kheuoggWY0t/fxRmaJaiKIo2n0lA+PyD3cxUagFXWgMmP1Rw37H7dMicrmUvpCY+kBQhS69tl1otUPE4p5qdw5nD311asx+E71jOJ6ruYdGDcKKA66w3j0SmDG2KLyoI/yomlAsTQSbJNOgmWOQiE4fLIMJoccNW/mfu3iVQStN9yqyKjMCVYEQnShN6z2r2dVjfSd02WUCRzw2vbE7uRBVurBPSFN8HvM0SkdQMxfEBtEAEbwXUtxE3S9g/9WjKdBN6UUqvFqgjMBX6h11B+eetjxFLjluNOBu8g8qCk7iek23/tpjrQOf8WVzYPXmhyuUkHY7nmodIO9D0w2W2pJJMOQkAdcuNxBsRbfLa/6jlm5h7agYCHq0yj3j6TRPbTIvuFQM1fcgLP1YILMfAlxWKxkxz+8eKECx/u34sAL9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set to
one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
or arena_map_mmap().

It is convention in mm to mark mappings whose pages the kernel manages
itself with VM_MIXEDMAP, so core mm knows not to treat them as ordinary
page cache or anonymous memory.

The map_mmap callbacks ringbuf_map_mmap_kern() and ringbuf_map_mmap_user()
use remap_vmalloc_range(), which ultimately invokes vm_insert_page() and so
marks the ranges VM_MIXEDMAP, and array_map_mmap() sets VM_MIXEDMAP
explicitly.

However, the exception to this is arena_map_mmap(), which doesn't set the
flag.

This patch corrects this and updates the comment to reflect it.

The pages are refcounted and vm_normal_page() finds them regardless of the
flag, and VM_DONTEXPAND remains set (marking the memory as VM_SPECIAL and
thus unmergeable). The one effect is that NUMA balancing now skips these
VMAs, as it already does for the other bpf map mappings, which is the
reason array_map_mmap() gives for setting the flag.

The intent of this patch is to be able to establish the invariant that only
PFN-mapped or mixed map ranges may clear the VM_MAYWRITE flag, as is done
in bpf_map_mmap().

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 kernel/bpf/arena.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 7b6847200b43..b69fe5e34339 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
 	 * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
 	 * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
 	 * being copied into the child process on fork.
+	 * This is a kernel page so set VM_MIXEDMAP.
 	 */
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
+	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
 	vma->vm_ops = &arena_vm_ops;
 	return 0;
 }

-- 
2.55.0


