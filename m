Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF1F3C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBFBE6B00B5; Tue,  8 Sep 2026 16:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F4E6B00B6; Tue,  8 Sep 2026 16:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A30F06B00B7; Tue,  8 Sep 2026 16:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 776876B00B5
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:12:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AD7316075D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:12:01 +0000 (UTC)
X-FDA: 85191691242.26.0CE4B6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6CEEEC0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:11:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NX+FtPcF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898319;
	b=2TbC4440NGZy+4Qso2wmhsFlMEqpfiPLhmpcpJ3KzkgkjE7U5o15RmUiXfCBOj2ekpU+m5
	3pPb3jzBUm+zfkwqqCAo9xaPiTLp0E+n8d3Ad5KPYQnl71BauGnqy6EN9JxLixcVLXNP2T
	LiUBeyOm4XaPnt0R0PQ3lO/u/WGqNI4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NX+FtPcF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+GInhg3kWngclwIBI6LIN8QeZAUoh1n+q1azU6i5lM=;
	b=RFnTpd4U810ejVx1A9fp8r4O6qVMkCYgjR+m0wfDLvkOFw7kLfZhsX0Ou7q0ZK+G7j2SDx
	kQ9WVwR8QbCyKPOFtr6wi9TQJdO0q7CzDzm/RWGXu3PPfri0mdDr8FWPQAcUmIgUQwxib0
	AArWsWVOL9dHCTjxnk6av+GEDv/5RnE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07565601F6;
	Tue,  8 Sep 2026 20:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C089D1F00A3D;
	Tue,  8 Sep 2026 20:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898318;
	bh=W+GInhg3kWngclwIBI6LIN8QeZAUoh1n+q1azU6i5lM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NX+FtPcFw02/CuLs003CLYtuxHGTtCLAKxV0f7iniTsepgdSWBnGTIuct5GAXt/gR
	 4AjS3MIYwY7s0g7oTLUx1rlVaWjNrpenZbgmO+duwVRJQ3DLa0chfVyHoON7+r7+SU
	 ihpWKH2iFPWgoAqwpA1Gel7jhEPnDre0zksv3fhbBpQ+onlKt4w4/7SvTCmg22qDMQ
	 iznK6neaQBvBFhhlncbeDbNKkHF8Ko06C/767ZAi0wxnNw3TS9zVp/h2PDHglo8rYq
	 faSKR/ddNCHv6kcMC8qH+2sYYtf5q0LoDmE8qkdz6lIGNl1tYNPgXkRonpfka4QDdY
	 +PFM2WpG+OKIg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:24 +0100
Subject: [PATCH 20/39] mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-20-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1289; i=ljs@kernel.org;
 h=from:subject:message-id; bh=0xVbMIjlxJVEqff8evxHaJHGQIlqwm40RTiR4EqieKI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG5edsnojOAZATdxs5e7z35KcbDru7vC84n71n6bc
 pZZq1MedZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAie8wYfrPGLqjSOKx2raUx
 YV8Xh1/HhgcGE+JF5S/IrD4jHylnFMzIsPbO5gK5rkTTD9dsElISF1zk95pTcNBN409F+e4TXHZ
 s7AA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6CEEEC0003
X-Stat-Signature: uw9pujnyykb1fbqzoqkms17s5gwcokk3
X-HE-Tag: 1788898319-626991
X-HE-Meta: U2FsdGVkX1/kCS+VW2WmKtbddMHUqjsm8DQjmdlnjbjSOG/oxAa5sBGIw4JRlrzHQHVmF8EXjDLUgpepSssjCKavHn1M6kuUFzVmtkZsx0775A8sucN8p247kwUbaHlphi6oNmyTisrwypkbWuskClOL2vSjF1uf7SXH6ChdPQkxYBssa/SMK2wBCJXxyhmvlGqkFvipNUWsBLsCyu66DH4Rpcq7dyTKJAJ4yFQb5LIFk6c11JG0BLE3c+i7YvD23/JkKo8YEXVQ+jjxoxQWo6Tyn/rRhaAhL41bCAh8BryzSKH24aziBvPJnu3FfhoKWQMdkrZ8jnOopj/+xPeFojnXtopBD323NgQqtdzK4FJSVrH5+VWccrNvi/gGZRUgTXJ4uikeCFxuSis7SrQeA9J0msQm+yPfKmN4HC65gRIfjQj0+JOza5X8M7KCzTFQcpAdMT3CR2wqwHYD4vBD4q21TYG8k+eeMLk8qI3eto8w0KlNTCigg8H+JtmcbdN+9R0uQV7T/sS2/08nETjbTc2MvWwuX9mEb0GooMaWWGCJVP5J6CFT8soVU5kbXczQoyMCMpddn3gRg36x4pN+jUhBe0ZF/vc+Jti7DwlXimoRI7Doiej8zDtx1q7gT6uOGU8N0fBNvUrSLElFA38BUp8PdoxxiGgnF0UpYOHHQda4ZQEsbHHUBxm6WOn1LA4ruxpv8uEkReO3BaC1zUFRpSAlH4OUlVaLuIJFjQNOjyrCVL87F3le7X9iqIA4MvL2Cj21jqzbLbmBg+l+grj/QZNJVNKW2UqL47LRStaEgJjU4zwpBcXaXi3vwGBoWPX/Ie94WK0k2OFIVPBeGYnFkP9s0yzBpy4SteyLYNmpqao0zK4hyEEZHpwP8e0UPcpqz84RHYCAu3mYpy/7sAJ0sxZzY2G+IyTKyFcww+2UrbLx6Hlzdd9ZS8H6/+40zRHZKLAT8vKptdUeTG8poQo
 zuxQ8wbs
 WpKctDhiczSTWSvcLOfTGId+ueJXrniT+CHt6srLb4b91hsPTtcgI29Vaq+wLBsaRRpkUpzPhnhCBvPj2zDmVZblY/Y5PGhIvrSKGqGmjvmIHEJTM9pO+BNA2ERbMdRCa9sirvX7XfbjImOsrVo1KvMaIzw4LRb5o1UQQmYmyI7Zhp41yCRS9H9V8tXsmXC15P/6E1+cb042NzsY3aKqxWJntKt2FMlzpvlD9RSd7hDpEWk+KOnUqqrDxpahv3r/6/9CfvfCSBjxPyiKr1wb/tpd//gS6jxJTJDelV4VnIyv5csmdkF0MH1l4JTuCHYZgnbid9xG04EkE9dOnXT7DLEfGygUFXXQLBnhl0BbtnHlUlmWqq3qbaBxaKfmS7XwDKC319IusP3HmOHoYothWOWDGHwqQW2LReIYuDmafy+/ayvb7ExwjLt3UKxjIU4gy9CZKAfbLGMR8hyi7KaUlc1GnXrmVDi2vuz6JoSpZ8Oc/i0oE4Hu0TMzVq5LsroyuG0wh0O3+9RDRAarJmbe3bcL9TbggRMT3qGTGv7R61atvTN2SKvZJ9X84vDCCKsD7r+/R0jx4PXJF/pm7vyx3HjirOvwuSqudXxGyTGxXZ5BeO2CoFUeDN627xhyP925LreyESFLRZBgw8wZVSkeuP39bosB5Q/+cYiix78yrHuxCQRope2TRBn5/OlG0ylS7YMcO04TNt1EfdsSHgKg+jpy2wPJGomXDySlW8Wfh94U8bX9dNvGsTDlT7b1qjLxVv2Ud7m65aXJHdv5L18RQUjKNY2vS9R35aey29ckFPScafhHuvZlue1xKOEdlpJy9cvuIuP9CP4kh8oivVm0nc+sbTxhCOXZXqvd+/37bTzMsVOSo37TMj2Ilf+UJzN0yFhca/pigOVbG/BOH6P1TluFfI04JhVGA92ZvvgwF0ieMV5rJ/oeDnsMXBorxu2e+yzUDsokMxX3I4lZt7lrgp+sGsU4l
 CYIm4keA
 /CiEIpUfFwlFGqu898ARPniBAeIGQMxUkw8tZdwrFXqBGbUtkU7/YKsWCzKBvMwVEyS7KHFtoMt9QUNY61D5/PakuS/j51uP7S+WUpzApZsSETcqiDDESQ8jGO59kBxKbPOaOLdgffQkrE3mxTXJva4pTSyZsku0/UStKVeTLHVAhxjqsBbyjIPggUJuRMqg5YMRd3ldLYOmswLUD5yfVshnu+MO0+Rvd6NwoOFx7/BlFYClBPXwYr6kFcjovf7DpIxL3mo19uQimfzpKL0uqvZHYfRNnRQQVj/61hVxE5zmLIxnZHO0dvJVk0eyZ+3tq+HhahfWCsdtxECd5amdg2Fco8K6XsMHzc6lV1xgGwofawCj2lRlmw8qgLCkgBFee0tjbcv6X5kguo7h6FbMAXk/1TwSC17McvGjUXBrUkz4duSxRVf3k5HENifcWz45CO5MfWS+g71T3XISMm73xP8gDU70KiZ+CE0JWsnLBmv2amndLyMMGq1APGg21O/e5MUpPMcLYzCDyzyDH0vg2qlm1xtfoVNLua43TvL2cs8yc8PqKaDCtjuvQNIMSXtTOEMT2sXsiSp0JVgz3XCZoPIMLl4rQK8JasXy9FqQbs2xbmqwg6vfqpg4etdAshXO0igoZp9rjofbvYEztpsJPkIdmtuNxcaKdtzLwWgCSh4Y2LdOH+CwWK6LM2jOiGn0beqjKE+DTE0iCoj4+qCUcwLlW+kRIgEWGmPYeHpg8w3G27662V0oO/HJq+MpygJQtPI/6i5zwnsolsMaY4VGQTg+thruRsuaKcf8VamyqCjjUMzGM/LFnxzTK5mfzrnnmxtvwb+gPeu7GyQGA2Rotzbvr0Q7SHut/DvDH4u/wT7UjcJ5OwQ/vtYR7j60Eu0WZOUoL7dq+7iuUU6h+u7sNoKIUk2/DSbYrUGR7tb0cAvPC3synaUqPKEewzAvVqvU7Wb8sQ7ix4fzoHMZuENMutAaycpla
 Jub/0AkS
 MO+zH/T1Sa5MYiFGDPcOuEocmcLqvBDjZIlVATxnrS2nSuUTOfSEm0Ix8H3NO0xx+W47kyCICnMBrUHrq5//LRr2JUmsNKnkfxRKPhywnh/r+RqHalo8kBGUsLIve44N5684I0KSO063/HF7uVpgL0SUkmysvYOwokFpY6gf2AljbYxlaaJ0CuhdNBR8OFGtqdx103wnX70Wp8TRyai60hPRvabbFCLZ30O74cvY4V+00iZPghOeI/s0P6kOnyhZ08L0G9AZzD8pNdpU2eAsfVkodZbSraadG8rEyeYA4/ui6JL7J4Uldg6DqZC8rrcvcuzjwu0P7qUHnmAVXqpBrmxS2nW97rNtUqhjfrSdi76quwA6K/Qbh4KNr8n3Sj6m2Umk5cVPO27Nxmzw4OkBuYJP7uOLYKz7GGNckaGf3XpnS96TNCeAb1IbPULHSDqNdvU+E7+YcC/pdJ7L/QGgj05bX7P4oZXlAcfVXOTS3y7+fL0tUPBbghtkI9aSR5/8pBcQD7rFxXRUpYVvSiY5JkUmMlnHTOj2I6NIF393MYkqAhRPBKNUTWng2t3LU14UCAOe80/4RSlNer/FTu1POpm4dptdLGbR8t4ZeJHTLnwUagZ/aBG97MFvqBmgW4w0HnKYQh4pyG47vUNN6Ik9Wf7pVxgH+H0ua2Q4B22YlmlL6PzfiBwp5Uwi+j+llcWCAmasOpxo+ukM5WM4KD5xUcKrwQo/s4c9INWxAHavNhz6SAFKUJ8S5Wp3nax1LO/kW5YiZbqSIMGuLscEPaGzE1gTJVc2vOkTOYql97bx/FQxu5IWzOA1Gy8G6ofx5CkeG2RYORh0suD9bchCF/7vtthgS/51WQBaJtgrMQkMU5GYqCQYFNn3reYjk98eEmfdYPSU9Szwg/HmvANR10B+5C0ZOHtYjHSO6W81zH+8rdJo77XDeGcVklyLIHuWTAN2KBwLT2mDVJC/Z84DV1Yr0F009Upsz
 gzygwR0P
 uy7c+IexLT2OIcmiRV3yUIC/se9NfjRchxfaz+/91yt/zRySGopBsveICvHYLQRLLLN7jWkZ1yDxtsHr9yNB6tZh9Et3VHGNGYfI9c9ZcJmSJmyZTmRmZbzsMj5S77jjm6lnv1oIucNwLPMyQ1Ab+KW5LRoT8jUlbwtb0nGNYFG19+cc4hAyhwXvUHp1Sjw7v6jwkv3vbD2b3tuc8hc3z66Ub9tAMwX/m+dusROTUUqGWfvY+Hi1Qc48g3MotqM9kaiepRo6iFj9rlyVH9SaUZxfj2vdR+opzCHlTpBGXa2WGuIU1MQOYSX/MFeKJluTOtOSpvdsU1c+QZ0NhCEtbrJS6lBs9nvFaSJ5+3A/hfIqypNckQ8Bir9P9vGTw6QxY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When populating a VMA range via the aptly named populate_vma_page_range()
an unreadable VMA will always eventually fail with -EFAULT.

That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is not.

All user mappings always have VMA_MAYREAD_BIT set, so this check only
impacts kernel mappings.

It is implemented specifically to disallow population of uprobes XOL
mappings which are exec-only.

A nasty interaction with these mappings may occur if they are mlocked, so
actively disallow this early.

This allows a subsequent commit to remove the VM_IO check in
__mm_populate() which otherwise requires non-MMIO mappings to be wrongly
flagged simply as a workaround.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/gup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index a4036c02e213..f5dc227bd6e1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1836,6 +1836,10 @@ long populate_vma_page_range(struct vm_area_struct *vma,
 	if (!vma_is_accessible(vma))
 		return -EFAULT;
 
+	/* Unreadable VMAs also cannot be faulted in. */
+	if (!vma_test(vma, VMA_MAYREAD_BIT))
+		return -EFAULT;
+
 	gup_flags = FOLL_TOUCH;
 	/*
 	 * We want to touch writable mappings with a write fault in order

-- 
2.55.0


