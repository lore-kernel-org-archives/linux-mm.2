Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E073AC88E78
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC84E6B00D4; Mon, 14 Sep 2026 11:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79796B00D5; Mon, 14 Sep 2026 11:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29366B00D6; Mon, 14 Sep 2026 11:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92B106B00D4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:14:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0C59140169
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:14:14 +0000 (UTC)
X-FDA: 85212713628.03.3B0A43E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D12FAA0007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:14:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mQuGz7/t";
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398852;
	b=FESEmcu7VZueatTynoX71i96SOzXC9Xbvj2DLAU9qUMoxrRRO+0DbYJy5JkXLMWn0pQIaL
	y2y9N62tfiwf1clL6k1IO/P1P4bzHo0IZ4Dm4/wi0YNluJPvqYq6LmB52DmSoj55hlFWI4
	0VccBcZdffUqtoQI2OrjGTwkFJ+L/9M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mQuGz7/t";
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WoUWUiccCZ5pmncdG/fVn1uDF622HEjGzqeAT5aHc8=;
	b=hWkT9OFmU7Y8kfC6maqUuOrJAF5ruxD1QC1cbQxXPw4siINJiQ3bOnnVPsoJefbF15xMra
	wTze+LuvrzbMIsix6T+lWusn72ATnc8wKsS2pyaVFgxnsgjykFQa5BxoZFXqOw03FYqb7x
	WP2g0FzxdLcH4G/EtqDfTcH80QJ/JMU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F1AE140710;
	Mon, 14 Sep 2026 15:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36861F00893;
	Mon, 14 Sep 2026 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398851;
	bh=9WoUWUiccCZ5pmncdG/fVn1uDF622HEjGzqeAT5aHc8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mQuGz7/txzYesAJMtBCbn7ZfzTB/KlNr4TPqovuNgSOoVCydbhk+jy3YSFL1zSmj7
	 ZngEXa8qEB1QbOt+DaIqYYLRuiCYf94eeH2j/KUez4FgSi35O5IJ7/3VirViisn0l7
	 45yaoBch2L7x0ZnN2BWOFTWs/9m7lJmF7hB5vrV7UHzq2uMwUDuRBM/jRLb2L2GP99
	 R7er+Xj9cWvH8j+SJqxYM/LxLtIRfdl/2/HuvWNx/tMnUZW/H5z6mP0BpNbe/OoMZG
	 uobtsLE/kEt9BejhdkmRL2yFhy/FKtBfHsR9mVL4p7wohnh1s4Vt90A3QJent8U+sy
	 alzgjeWOejIqA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:52 +0100
Subject: [PATCH v2 32/40] mm/uffd: use predicates for userfaultfd checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-32-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2289; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RaKyg3GqRiVqHvw/UDaaHvGcpLhQwigi+RNlsL2zffs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG+20diWeckzqyprhU5s+VX2eL/c5gBf4dWSYUdaM
 0/unx/WUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIlkaTIyzGt0Mi2q2NqRoZBy
 yFV/Y/5strlZB2c3V654Y1djMDF3H8P/+G3WItOMT93bYSEkVDGl1X151a4eiTh7i8MfdpwVOOT
 MCwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D12FAA0007
X-Rspam-User: 
X-Stat-Signature: cn8cjpu5btz9itg43x6jpfzkeynkezsj
X-HE-Tag: 1789398852-513898
X-HE-Meta: U2FsdGVkX1/YkbKv+hiQIJ0XxnS5AXCkjsw4UwJX2s4eHoXMWPUdw30iAITlV3JVi5TPGunezYFRY8xx3o8A8qh61N4+4IHW7RAHVkn2+1FVvMrAcpmExVYdKLhTeABAV2q2pGNL5ciz2bwfgIsxHhPajCikzcf7uOs1S6n5FsGEqL5QsCAh61THBsFj5KrF7BnRvy2M3yjC+Dq6o1SFvt8ZnBrvdW8MRE7V4bc24yC+5r1ieTW3Tmc2DqVsmJSjxTVlFQtlWzqLR/oeUt+H9mjURnZblpvGlVl9rwCbTetb+IQVvIx/6YhIIqwOXcV4zh0kQRQGW+uQBbTnSO2DCEvrD7PVkNnHFt6PPE0W1REZkPK/RgfsLRmbNZ5Ec1iTsY++Uqjya9PAtaxhnaWVRVijxaopt2yko0AJ2v4G3KCnFG4OMrHBVTig5mx/HYG9RBa6EwPzSX7gd6u/ULUEt6v5CDD6Ov+jMTghSAnJU2zmsWrU9IPkoVxXzg2sIa4edWrPIUwBil+6wHiVjSBN9fKNp8V0V2Gd4Y5uQQx+iIqjyWU6Gbw1R7OSPiZHdmrPF0s5/EWJOjQu+QOU7QoGq67bUoi1BlsuIQ7ooezAckxtsjJqR4+GdysW3NbL6isBf+xjjW4gGF8qgjQs2QDfTyh9e+MLQNXzfSksgdISOlpi5V38ke6dsFysMKxZ73MAgQ2ib0DfjviBEY3M9xrE8FpGPkwUSVhdP8YqJ0fDvylibKHMLEm7ei21QKHqXUPEMMDBT0sVUdrU6WhXB3KG+6axZF6gPy2wCWUnuWjf7ySoZhBPYiZPct0mZadwFmV39eWVkAbGzLeFhJ2CSYCd6bvEAhphDvf0RKB9EISPx72Ybn659nhxpebPfAj6A9L3HM40PV6UAIXG1Jw/ZD1ehY+axOXlk6/wNohzMcH1jylqjSHJMnk2EO/MIa2wmofJKP9g5nicjbv74OJgOx2
 kyvH4t09
 xXu7ZrEce7Cdb6V0TUpyr0mSgkSHzTbTUHRHzBDOfOf1Rxc/sLg4Jg9wn7IevvCeqALMrYuirLFnNoHgB/nM6/GU+TgKzIVgfxcMhNeL6lg43Huq7mKjPa1Jky5TaQf5awyNZPjAekfhzl2FmAgj9s8DhOM8lbmQCgZcyNQmRH0feef/uxJdB6FF2JUoSbvv3x4VGPAjbMfPkkE+fAWafpf2OTsxM8KR29bAbe6Pr2q5OI7Yv7ecbDRMytCDwuzGoyEFqi9g5oaHcmJp1plvlpFMPhp+h1PKOSYU6f1e/xIHDxQmFzkM/XZBOnOxGqkAdJiGw3MMCyusGC7XILhyO0MAXFpDj5dOlMMV0/x1gCGAfQpJ3D9HbPAOokEjVFBwbjMYw91WZMnGV+aK+fJpbmSAozte0q6GImbH7razXeJgcomvNq/ZlFiUadUpFJaPgHMn4xgGitTVuGnrF3b0IBG7jTlcrrtkUcT/sPRQcgiHMoFHgxZrJxymOrsWK3sF36EMDwDFwdGJx8TxukCjvgp8c7vja/kShQgj0UQUt+tD2dKTERzFHiogCXtbHCXWiamQ15r1V6ie3G52BUqPZSnGrc6RBzLUV016d8CIjtv9EkrseuWxapvrTuRec7E/7Ot64DkRV+19OFflqBKYkmiBqJzzb322pNzsjNntu+setxB7N2phfU/V+4yf2/hy53gEFiVB6ru7sVNcZehpkkj2gR3mDVk/eAshfGJdRLUJBueJMlmTliH48bWXuEqX9mbRp1UMdAnAdaCpxpX9w5XzCRO6IBRSqqbfhl8VI43KUXtleSUWKee+7nY5M6ytPV6LgaZMbPsw5wK3DnYdusUpKjKtGR4YdVDMh+9b83rvyDKEIxiTBOkqdvJEepHSjs/LPwlKNvWWulnenWyydqNiLeYkjfoGlIBzyROLoo7iCklqKcQOxriC8nAg3IND3HfEGrcxFhB2oEB3F/Ft6K/kh9yqE
 YOErfoTv
 lM/vmv9TfHGRB0SSTj8po2jmcrkuGs1XBfDdZRiEWbFLSYSu4OfkE1L8Ww8EZR1Brwkw+BqkaI3ZuS4flLsugyel2/rW1BSkiZjegi1oolHWcs5XBDk22+Vm2tp2SYOeBj8Ca/07J8HXxNHLj9CUzjMz+d6LUrwv6bhZY0/wDK43FliNyhzPpmJ/foNhzel8IAJam9y99k6LpSgTu1FnuzQDcCg4THkbQkYo9EPq/4CJXOr7mD/PjNMdCvFf8ZWw5v4GAL/wiun+BkWZeM6jOedMs8Dhe9nl22kddfGLShFKbR2N8NhGgkof4Ot8k/fLYKVbicsg7eEUkyeynM+oFLkw+No7vPI/ruPeput912KTCsOZ3fV1laGCe6I8xp3XHawgjq8L8YXdH73SR9OBiob9EODv5B/52/mMUxSzVxYC+S7VSsKEQAc63686IOJIqgZhWJ+Ww8BEsLUBKoxIGJ+5gKJTKOdLPC+yv00MXV/WP+9BkmgZJxkud5DKebYAVQQErAXArQCeoAn/ym1FOA5OkFg3npCDSuFAbuXANOt4x+R6N0mIAONZEq4efDnXlyGlvxIwni9MROvqII8tQUjYDkbQ3SEmTelualk2djEWXJlwvlJUiCQ5hjX42vDYCfDoHLWzmzIjrb0jSHyZnHQQLTJXLK1+7ycO4HxB2EUKCCt+sUi4M8Slyowt0zQo0Y/6bZncEOwwwACOfE4m6aewDtHv9gPsFFsYLXChK6h+52lgQk5MZNiGCn47AK+KCyMHdxDo8682kH7QcNpoSsts16q/u3bvPdEZzNhbaDdy6NUnAq2s5MKrGi/3kHcQvg00GA+cXb8/45Q5od7TbhFflplUytbHVaYQm/9rYUleSp5gMjYpFrHlkPd4tkqoDN8KWJJO7X7kLIx+qL70Jk75wcnyoeS8eEn1ZOqXrdRTGUE7Oef3rGWfujZNCTMqBtyBEYm3Ox62wai7qYv+bye4K98uy
 XXi/XV57
 uQgOdbHfiTWBF5vOxo3b54cTbOl5qmglMhD0fjqpD6SqeShMVst4XCmB8AFTIePYVLtjBAzmd4iGDnoUDs3RXL05WwsagyDpjKfZDHAsZmzqIvSEyi8fE3MKjcHM/nfT591XccMwDDLUpgI2fVk7r2mLJCjl6XnGrGTtqbl3KtzSJIiiIC0LdZdWeacWGfu3dLinnnTHqnEgknsFcWysjeWfpEXjD75EG4D8uomZyYk07E1ooX0p6sQYWkw4C7sabxOKwSKh35sK6GhhdCTSCvoHe24SRf75zjFFwtt+VuBpbUujtd9m9lIqF63PLb297ITqiaeQ4aKRMbouUtOJlFHITb24RDUcRYbjXon4RU+xSQ4JLiMi6ZvfBSxqro6Wy6dp05sMmQSqjXAZsAuR4FzvE1lIwGVynmHHExp0dY88DX+iHRy5vCaQG/6F6Y2+Wbw+1IXBCj24UsCadt3kuNphSvTA4vltPk4EJhbJHhn6ubeQJ9M4guD7/CCNldpF5cnQ4ZN0dFvBKRlXJfIOqyJ6pWH3RIR0q0Lrg4QIbPSzNdWRxvCVwMcJ9tMfT520ZDrm+ixT0NpJ3U5KteKZCRF3tx3NLZ06mTOXkBH9QOcsv2d2XYpUBUK9AI75tOg6MBJthL2U6vUx5NAudWxxxlwA3i9OBIk1pS649N+KgC/Bm+ZeGxl10jKAwPJOrCSL7l7DfpOLa6Wdztua5vC6GI/TmNuHqIoZQVqZp2zU3KjCs8FfEVqKrVPVYIzrveNcaMFHji9G0k/35tHI02JPhmGIv3Qgpm338fOfcerjXm0OzyM9HqeSz3l50tSYxMVThs6Hn8ORfyxlX8gXZIbwhJpLTuoLjyDi3LNGkiZymO6YPRNK+r7ojFMWe71BajEvybXPPFahcYnzAd4NBw7Qas2tFpmdkuvPmI9WUoLQUJVXjM8+yp/1lWK05MIq9wuwUEpVJ+sjRzRHRBJAIWF/q5EZ6Y38i
 YRYhGDoy
 JxuhGMDqlVNPVya1G7dmWG+424N5HxzZ7KN423V+ZjQFZAARv9NIq37Xjnndyig9HK4pvKfSTL1JAJcj2iPXTUigcXASZcDbcAkrbH0WrxZSXCkbiB+bkE5gen7xQun7gI3/z7ci8//SP5EI57DKnDPcZcDDiwwpuHWM3vidO19Xn/3LNEU1Fh5t2zKnCuuaOI95n6L/DnamxRK6dCZwYZErMI+0Sd/+FA/y1rRqmZW3dpf1H0VydMo5YwJwXXjIm3e5Jpxw++Gpg5eY43+pFAgTQbUXv5EpEUjgO53i5mQKh369BxNTyTiM7fPYDHuJpuMuTY+p3n2fNsZB3UjPf8dqB7PMjgv9pjK0wpVeVLAEVWQhxUsKnd9g2FAQrCoEXQjEHNuHioCZjU5Y3Myx0uNmdpt+MOp6g=
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


