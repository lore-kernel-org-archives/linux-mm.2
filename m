Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC015CA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3576B00C0; Fri,  9 Oct 2026 14:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65EC6B00C1; Fri,  9 Oct 2026 14:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53D46B00C2; Fri,  9 Oct 2026 14:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9935F6B00C0
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:14:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76D3BC04A6
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:14:25 +0000 (UTC)
X-FDA: 85303887690.12.CE3E474
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id BEA521C0007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:14:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=itAYN0mR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5upPOtDABwwVpDceVPyuSA83QzDcrZ56JA1+Hc43xbI=;
	b=lwJFlf5eYG6JUkn2qy59CyN9sCjKUegEc42KsBwa6HARhmLYS+uCLI0gHchIjs4vh9j8sl
	tLF8DNb9LUymokEZ/20uZKnt91f+gROoviYSnlz/D6zI/Af/wvTnZCaqtztTWXH/j0895t
	6CBfxxM9gR/OM8ifiSk4mGDw2vLwT5g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=itAYN0mR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569663;
	b=q+T4I52U05SFrKKT8AFW71+YFMLbLVVjKcq18ktgE5/Qj/Xexk2lCqdrQhmiVY71t9uS5K
	xT+vFBo1xWsfN7c9kiyU4JD3hnPbO6dr3+gDKHPuUOSlZFgc48N6Ka8ZmH7uEy0sdqMfIg
	IJzzjppueUcjElUXfdlF/bv3AreSQFo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6697E60DCA;
	Fri,  9 Oct 2026 18:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F871F00899;
	Fri,  9 Oct 2026 18:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569663;
	bh=5upPOtDABwwVpDceVPyuSA83QzDcrZ56JA1+Hc43xbI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=itAYN0mRby3loFr3kB3erznCYLyJWSv7y9EdE4a4SdBxzAp5q9gGykK29Cemo1B6n
	 xUIbU6fwrjcABEJj0iAu2KbcnlrUKjdpTgGMauBAph4NqMhPbKfYOkEzZ7Zvgyaehb
	 T21cEITGvOur1SbYWACxHxHKQ1DccEHNV4AJ3e/rShDKhT6LHsp0Ex5xX1XPtKVIOk
	 GPC/H3skaPetLTfRKnWecsjavs/Z0T711H8dQMj5SbT/UyGlsv8YAl8fiEiy7R69Em
	 rN+CScbilpeAbrAjSYkjfRgZDK3SDt7CMJcVqsKijMA/xdq3sIu8832Eshzeb08S77
	 AiSCv6n5JHppA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:22 +0100
Subject: [PATCH v5 28/38] mm: drop some redundant checks around hugetlb
 VMAs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-28-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2822; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ULLCLMudbM+nA5DIlUO12EUl7FbXJrpgl/45EV2ltd8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sydarL6faDM1u3ZZfdn2yeZbvy5T1m47nOX5xo2w
 +oXTFOEO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRx+wM/1TuxklMuhhxXiG/
 a4aAGltEa0NF0YptPTMKTRXfc59Wa2L473R/2uuHOzJWnZfmY3Pv+5LyeJpj3bxlovOPqaUWsi8
 X5AUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: a1jac6gwgc79oaupcmbhk4exjfi9kid9
X-Rspam-User: 
X-Rspamd-Queue-Id: BEA521C0007
X-Rspamd-Server: rspam08
X-HE-Tag: 1791569663-155846
X-HE-Meta: U2FsdGVkX198IV3IA2jE2AVUX3Cd12b3jHNEyqplJq6lPdXSpQZsxnIKNcnGO4ZWRJYXZS5VShot6LIMGyJ6qRmQxYaG7bU8ylbbV4U7O+dBihiO1UnQ2OJuMAfjx4lRgMSXI0vZND26nsc44Zm8V6+vQuWmKkha2SIVB4qrPZgoN1dDycj1WDMf++YmvV/Z2MAai2754cu7iK20RpxXzv8yRH1kZzHQLNTs6Nxw/bGJ0wE3ezirIGWGTlJ75ty6TcJVCojm7RkC1pkCNGoIrfmR+GXWquCJz9dREqWrWn/gvn545yibxon4elL4ngFMz7kXvTfA3IoXIIefSjLmCbxMSuY/WiWlEs9tmd6tvwrDY+prZiqTVxHmLE0plCH4CgMj4QyrPFGrna3LJLaCZ/u6Kg8qLCff1AlNG0OLJNL5qc02euqTM1k1mvUqUhysiN3XDZvkAYCr/Ia/r2CCPv4MxLK+/8SstHmaYtPCN7Gv52e7QnVZ2xrKyySTTmrnpqKSMWKL3EIoM2GPrV2uDdKpDkOulqFmp8bypYGVPASxeVH7K3S++kFw5+97GJKdeFmpHcOLd+6T1YMMwOMut2ohpqhSs+pS0TC49rvp7DUpXumNpVpztNDSBeVYB5G59gtlOkQC1aqdkDsaf8F3aohEfkntEK4JtdZtDjLnJTLfG/PUglG7y1vlnHRJP9Cj1ip2vSyMBPkBRVGah19yOLD/TvgrOWATgeB6rOxm3XDA+QHsechad3Tg+9Qx4ycT/4vmHIMxrOedw68b9+ml8U7JCf70cxN2YS3277eRS0cic/crESPSG/LrL8D+qOqTuuTHCBUTD01rjD+x2uyoEaoxtZ7eEsIDyl4KViyTbRO5Q+Hdn7b1PCsZg6vDy1FTQZd0PXnBVv+HV2HaOgnw6PxqM5OBF5F85AneOj7oeG3ugjSMQsUpg122fm+XK5avRDyuEjVM3e6tqYyXXbw
 SrLe6CQR
 8YvKffJts19mN/ES6zyj2lom2cB9N+mlQmpwpE+KXiFsKduf64JOL4tNw+tE2eDZqhCzqgVYU60m8T8NpuJKbtt1HlvBfQ4tDMxxB1cf0bc0LcG2OSX2G7lgoCppwJfTyPXKvM6XcfkLSGpD/qdBuI57V4LVlQ4t3VsvZyqyVYHs5ivNKVkBrWXlfvE5uFbSQyIPY7ST+TemRoN5R1OLnN/1aH69a/L8VdqBG09pvhp5fp1dUNvtqIy1e2FabE/e/81fcXadUeWc29R0f//qOvd8LMJW7TJfpG1Oys+sdDWE5QFTFetnffXhSdxeYWwAtd2v9uMN6RVJqJ8V1/EKtcx3KEINA+jvPBQo47DZHroJZP7eb9uj/XyvqMl9CIvRNvXNjvIJC8nD4tRk9or0iraGt07yrA5rdiLyvZOwVP+shkqphrF+A6ooPtJnkKC+IV01YIfWlphC/dfgdHIg/RUgW0Uf+FmlFVKiZ3bJKws3zzakUxRU7/7ijzG3jLhENFSDM0AIh90GY4m8ZwECpXuz8Ua13vuY8DICA9U2uApsVS79Yuw6Ls1ziHd9Y6ZtTwZ2MUgrP85WtY82tv3lbx42X2b769x+1wtyCDTKUGAqvyqQ1qigD4+0wuPZltbSgFGrOph9aoTeqYm9zMeFHrT9co1p0HmoJwZAt/LGmu0nJzAGieYXTNkhgQFywXCzBllgGtzh1omg6iV0X6u0uF8MunlsbDpjeKnA/VhtJKleLhxX4U7aH4QV4PnuaE2V1XY1UrdyjvIbGMTurs7EMs0i+O2WrxqOP4eeCogdv350h4mvSryrebKnMBva6HhDkmZvaf+gnc+tSAfDpwWu3l+hCOV3glL2VWk4vn9k6Z7VG6MPH71KtUX99regaXVsVl2fttx3TziLaKgi33/nucJwo8bOYFdNdOEg2S2Nl59EHkTL4ByYQ21WPdWwj82w6NBPvTuYpWP081r32jpYAYKlQul5d
 SnAM54s6
 7tTW6O7S5in+268iZ/OMLBUOmRp+MwHc4Z4DkcGp3w+lBXE0NFadcQWcNIZNi5vQmsv2B17Hv0KrPTh7WXEq7f3w2dhPWOJUJEYtyg8WUEBZetYGX5jpx6lL//O5lsADGkJLv9Yv/3EgC3bq+ijXXyb5dQHQk1LH4VZ+BzP7Oa3eeZyNed/fBZV7/0/mW46y02HmctECmzI+AzwyCtfyCCK/iu6nNQmtrNdWmMTOgy3oRxmnaPdbcUGAbPnNjjPVlHAHFP7ZYqGaeD8pTPgJOKc/A30bcBXWizwOTvgfIoWmEgfz5pYCpc3Dz7asXmj2m3sSa2IR0z9eBI/Lb/eppYKRdGqKwvoCWtSPfWknGEC8m3WGHLr0nGbT+3ZSrMMO+OoXXsK28Dxc3Fj+pt/+0CQOuA0gp7wZ2UHh+ITDOKOIV/4v6t4MKG8QXBaB+QOsqhKYwid8PxN5Ru9rrEh2ktw0JD7FRr85Zf1yQdEpjW31ChUlxQqnxkwzEyPA9T81xi6mf0TW4hUSHCYIBSpyU3SmCYesvPlO0UJ7ql7oq2wmVsd1ZcR/VQNveqKMX9CwEjcEKELCgO79NBLq4TOXIc4V9GT0VIDuQxPhZLcW3JEvJ2YuGg6+NJ3kbVsn/2CuybCFi/DgF6V5QO/42iYw0hoENwztpqBF++vW4R2gA3xZmdwIDAgO1ZglndjXpHzHdJYz84YwNJ1hnwDt52NlaIVA0Asq8DaM0FE0FociDuExhiHQ19Os+Dv5PaeM7R8CGWqP+larYKYIy7lZPQ4j2+OYNjmMJ+mOmt+sKSaEMEQRs0nxOMjZWnTwV6h0zIvZfQre35CH8zqw1j5ozd5ehVzHP3GLtrTJKl08wOEFDzGjTFlWfuJ7fnCR7QdxwDhxfiRUd4yoadql7QgSoc2HbpPIv4VEusD5Kvb+pXma5nBfl2PdizUI5xNAQNQqL7E2lmte6OnMSQIpqnmE3xK7IKF8GOs2h
 tXOTC+JX
 jhh9TdzbY/BhIbxNSqhgRxHW/w4Hu12BaTYneaABVFzsLJxlzLP1UHX40KqqpP6rx0nUNwe2ldJusIBN0tl9gxt3Jxks6E415+lYGhg5dpaLBeDwEZS8qkeUclAufzj8+mo1d4uyBC4mMynQXTeOEYxA31fVBzWkU/ek5qQxC1rfDPT0a/bh0lt6yGSSbZ3/lUoXQHsjirNxuCI9Z90R4uORS/0xKkRQUTyXdUolt7fOgzNjvAlRNCOY6UB4Olj0xKz+nRQhBTIj3/9/2Vc1rIpOgvoyXP/p2ejUD9XfjO13ZIWHmukvrshXOSHaSNFpQwiqBSCheGpWFTIEV251wNiMLkTmCxHVtH6N5h6H2ukBXpKVC/RRhR7iZTAIp1ewotUT0dgymskz1zTwWji+mUZWp5q6zeR6e7xsSs6nVvUdwEcaUc8yteH2SUAdgSaoXmTcBKQ/nMWTa0crYXOyAdOIs6blI97AdhxrL+02MlVKrsEiGnwKbElGw27O95SgSLLuaK8KiwtQaIUbIXkD+m541g5qFA+D+ygupuyBQ+OZYiHR8ApYi2Df1bqVI6Wctkk7fqCAooTJ6FyzIMVT0+ZyDOEZu0mtJ/5upPlXR20INewm2McrKKtJTu4DHV5tTcaxvc7hqbQ75MXFPu0e+DLI97y9RKIK7OuYk7fZxyQ2Vj39q6hBQnKGNwEIeGzwHZMuF8l0T4IwOp0ZpH0vAdKYeu3WY6hQogLV9ql+dnai1O9ZsrZW7egu+Ickn/0884WtcUQz41uWCD7UImvpemcI65UIZ4iszsuQ2JbNYspxbwc48YH4ar5CJA1xk30/tSsM0/G+SjCsoAR1SLzcjFGNX7VZxlW0OdZpXJItdg95n3odLzUqZ4fkx3/VGyxoXaVhvyuyzggK/nh0inykdoMrAgr5v/XDIAE3gQxEX/XplPh0Jk4YwqZ1cvSEo6WHPq9/i9dk+e+7cDt2mz7ztFzurrDzd
 P1RrjK9p
 5aJLvX/mvQbm7oKcAyeTACJXX4MfnIDw6cDomI46GR/bf6OT9XHaPDDr7xBUMEbCQOvCqmp09ijVsyKRKQ0ITpRt/SfznlaCBQqxx0h7zK5rHVOEjCHAjEXDA6THJGKXmfAl9HNblfyRZBIrfJyLklb7YpX9rJsXoS7aoBoRzOiKc4E/Tv2M5E5rgvSipL3s5lmhU+ei349bi6yJLgvV19gF5/C0DhwYxWUZKXFK8cpc/Mnb9mhnCQykKf4rP10S9FU68O+YirAUSI/QaXkT3XIilqzEeKWybp1ut1hTJ5MDx/35iY1NJ9u8M3k0WYXxBWGTStMWVRgCUjtMZ81Zcl/n1rIpY6fx4ZTvaXSzG065YT3js6Kumrd2VxSrilzP3cDw9HltCIenkbyMwOlRLBh/a/ZvZRFUkAygnQ7ZqXsksIBX2pRPM5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adjust code which inadvertently perform redundant checks on hugetlb VMAs
and clean them up:

* hugetlb VMAs have VMA_DONTEXPAND_BIT set so a VMA_SPECIAL_FLAGS check
  suffices. (migrate_vma_setup() regains an explicit hugetlb test later in
  the series, once VMA_SPECIAL_FLAGS is removed.)

* hugetlb VMAs unconditionally set vma->vm_ops, so they are never
  anonymous.

* hugetlb VMAs do not set VMA_PFNMAP_BIT so checking for this is redundant.

While we're here also drop a VM_BUG_ON() which the simplified check above
makes unreachable, and use the new VMA flag API.

No functional change intended.

Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/kvm/mmu.c         | 4 +---
 drivers/gpu/drm/drm_gpusvm.c | 3 +--
 mm/migrate_device.c          | 4 ++--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a7968f8d24bf..3c1240ffc38d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1463,14 +1463,12 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
 {
 	unsigned long pa;
 
-	if (vma_is_hugetlb(vma) && !(vma->vm_flags & VM_PFNMAP))
+	if (vma_is_hugetlb(vma))
 		return huge_page_shift(hstate_vma(vma));
 
 	if (!(vma->vm_flags & VM_PFNMAP))
 		return PAGE_SHIFT;
 
-	VM_BUG_ON(vma_is_hugetlb(vma));
-
 	pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
 
 #ifndef __PAGETABLE_PMD_FOLDED
diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index a1d4989b0b61..fab34fea99c2 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -1141,8 +1141,7 @@ drm_gpusvm_range_find_or_insert(struct drm_gpusvm *gpusvm,
 	 * limitations. If/when migrate_vma_* add more support, this logic will
 	 * have to change.
 	 */
-	migrate_devmem = ctx->devmem_possible &&
-		vma_is_anonymous(vas) && !vma_is_hugetlb(vas);
+	migrate_devmem = ctx->devmem_possible && vma_is_anonymous(vas);
 
 	chunk_size = drm_gpusvm_range_chunk_size(gpusvm, notifier, vas,
 						 fault_addr, gpuva_start,
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index c38cbaaef5a4..b9c453c28795 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -743,8 +743,8 @@ int migrate_vma_setup(struct migrate_vma *args)
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || vma_is_hugetlb(args->vma) ||
-	    (args->vma->vm_flags & VM_SPECIAL) || vma_is_dax(args->vma))
+	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
+	    vma_is_dax(args->vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;

-- 
2.55.0


