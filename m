Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B42B8CA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C012C6B00B7; Fri,  9 Oct 2026 14:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1D46B00B8; Fri,  9 Oct 2026 14:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79D66B00B9; Fri,  9 Oct 2026 14:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83B426B00B7
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:11:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF70FC0435
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:11:58 +0000 (UTC)
X-FDA: 85303881516.17.C4F947E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3D7608000B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:11:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YmlBlEw2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVsKBqVWvO2goFpEXdlOxthsdTnnCRoJk7yo/PPrnVs=;
	b=SxkDeMw1c8uhxYCJNjCdtE6G3Fdj6eoaGffVUKXyu8LsI1eqKg0hy0Ft4vb28lcPRDY3cI
	++edPF3dssMT6H4iVrTNvETACN83gTM6lVu0m0HmTXI/jfjq7IW8/0z5R9v5UNNeg969Rg
	pjogtRmp4otr63BIbnd/oUzECUcUxYE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YmlBlEw2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569517;
	b=R3t9r8tffaeLOrrMfi3Cho0jVF7ehdOOCy7qfHnVXAER5roA1t4ek1AkZpEzilNw7az8Gz
	yvRULXhAr51VEkf1dcGY1cx/sNDDbOMo7hBQABj86W0dOxWyGeqyGOE7M7Ews/61SoxbiA
	Fnk0JLp5F0lpwtIqaXkguO4PYG+BAzY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE54360267;
	Fri,  9 Oct 2026 18:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006361F000FF;
	Fri,  9 Oct 2026 18:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569516;
	bh=LVsKBqVWvO2goFpEXdlOxthsdTnnCRoJk7yo/PPrnVs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YmlBlEw20GnNRAi0WeBFfkS+cdj1zT6uWTbp0O8prPQdyoccO3eXZVZGVr9xsDdBw
	 j1uuZZsWOJepfs4c3FO1hJBtW3Sute0o263POAqkrdUQDCSvV+zPmoaCANn1S+IfWb
	 jtFQ1Ub9VCpM6VuDJgS4BkSyTMjbYmTrV30UtURfNzoXVhIl551+iV87N9QkBjXFaG
	 EWC9lfZE2XE21VTnGzvUZ49H5ybi2jZnnznZqyAMud911Nd5M9PdWWYjmZEq/biNZ2
	 AkKA9UuyTiSw8uv1+1WGWXSLSvvpM8VEG0Hym04wvA05kqMQITzi07SzsyPSnsLwsY
	 juJmQlICqvk2g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:15 +0100
Subject: [PATCH v5 21/38] uprobes: remove VM_IO, set VM_MIXEDMAP for mapped
 kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-21-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2123; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Z+RdhWQ0b5VD679RGsODXA4DFYVH3rkRqMWlJZjTGXE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sx5+Dex2eSZiuQkXsbz1+2f7zK7JGG06cSKn4UuI
 rmz+BV6OkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRj24M/zNWe1beyfvX7Prg
 dd2JlczFGW4HTWvnb9+reLfwT1TvlYMM/+O0cqLYTwZyv487XXAnrtX9sZue4+p/Zgc89lxYuqW
 BlxsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: p8ncjt5fmebyo79an8ewakb3fi5pia6c
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D7608000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1791569517-301413
X-HE-Meta: U2FsdGVkX18t1zcY46I+YWY/l/oeP9bYkCwQXUlip1N6Fh4bxaO0iBzvRoua9LieeIAJuJofWfI/4p0YNDDBQtbKtGCNuK97b4990Yj3Oo0W98JF/HUwwRbWcOBEXkD2glPs1e7JstJFu1jMXgCe3FsRFhrclxFZAsJlJ0eLSWRiwfee2w1ZzIZk89katAXyv72DSoWBFasBUjW2IJR4GQ+RgJgzcas2lDuqyXYjBxj6mtSZLD7gQpHtHV58I7eBeAnfEfwaEsA/+DexUFvHm8mn3GFAyRncQIsR+A29zmFz4haMLK4T/RNzO+50Dp4fIpNn/coi5CRKkb9Qkib8wXPJS/3CFv1txInaWdmLlRRzOcFrMuEf0X+wJKo7qxeYIsItNFPWB7eG3G4mzP4AYslbiH5YqNAKwgefZJhSABQqk5Y+SVvzBJ6rXSjLH1doQSbnHXiD5s9cwkedkMv5SPtV9Z5AEJgcvgLMjJjcQ1/yxPNsM1v2GFu3JaUjZj7Q7BgHY1z1xhUFm3RNVGHADdTkLWD3ygKf+Ly6OD2Vk9LDFwqGDUoSlhVgROr6pT1o56CmQ5jSmrj4MIRc7xgA5zVJKQZp0RkbpikZCItgT69sO+N9B+fKEQPc62a2F+SaAYyqujOt4cIiIrCm3dRPWEENIsbFGwl74CHs0oR9WnSwctRB7oOm+tcqSZsQb3UaOqvTXDKKzJls49QQJUWoebz5imLnI52sgoKFLymlGg73BtbKrGtclze9GOFunW0MVz27aPRyM+6KfZVz7o2t7A0EGAgpr7tol/3oppaZuu/+DrH/tSNY1W5f9acLhgtTZtVLEf6xCBtJaM8Xb7kjT7wCND960D37yBpOSfJSV9lk5VS9ZgzxzOnTZQS6Li7pvlWQFb8VCfUxmNwakt1ee3L5+2QfxGlERHfEaG5L39zDAn0kCeF2T+Xj6KgKKEnSB6/KtU19n1i2Pn4q1UF
 f/ihSxXf
 OHbNdDkNNSMg7Wx9R1qXF6n9S6I2+ebyTnTBhElKJn1Z7oV+1WJolChZHOGG/hmdmx9jbVudMXchhU8iKucYXs4hPlMKLLKvyJhM5+qY9BcKfogZNfGqflhjZzvqUA0KIxBQoQnKkDM0mPGzVcoGtURua5OL5aqgaK7UHKovJEHOgv1ogVhBupsV7XpJP8TIIECxmI4xP8vwgfkbkEHG6V2dKUyofJyCu5En/YOfxn4gk2BY/PUlZ0PO8+xXzq+jHjupahIzm2SCLnorZEEz2JFGmjS/zYhxoJkeNoF/nPpqVG9XB2PfqVVuEtNVBAUw+ukxXpOhZqC6+X99D5xoqFc+TJdnq7LSxZrXlsnawH8h44/ZyAJpHRx+JEG6GmhR8HRg8o5okawFhelEUDa/M7NaRZcjVEQIDbzU6m2q1ugRGCqJXCpx8MueXkgmkxFA35YrFuuQl7gtpj9koEMl8BhoZQhK0akT5hAJNqemXvQCZOklxPg3fKXNdBNBQp5qQ/4YHu9B1vQ4KEdtRjPO3pg/ZDJoa5sdAuZ7KUMOPYGU27dVfq+CYnGblQnvW/YTz0Amo62VTWUodFrh5TtB57FkZdPxDiDBQJii7Pbam/oDiGE8OWP3T1F01lcDSBZAKYIW5b05yail/Ye0zvdm7CAyRGx+U/IoWQ2UoVh+LLdpWiffL1/r2RxaolxGXIfEX/JLadP5hkqozIeMrWk+B2oddXvcRI/b6N02Ojrp5Q9WkVId9b6Qp2Q0dBmCQEPkUfdLHV+Kn7pfO6KD6pBDj/cfq1sRMGk2dJ+GvEVcXza50A/ibVkZy5ytGZHuMiAWG/WgtpL2XUiHWiyHOzTqB3F197aP5kIQyN9/h/yo/7XGIvCsJQt9z35ZQgZpLe26SHweJZNoW46c38f2ubaL9A2MzJ6FsUjTxhdoufSDnDnT3lWMoM+TPLRSk7HyjZCFxTRcZFCK2SR2qpZG6dlyFTIAZaAAg
 kkvto9l4
 nUS/vHVG87ZyNeKj02CXi4QNrPvBuqLRBwqV++CRPUsK1kRR/ykGI0UgCvbz3vRGxp5mfbwFOu/rkH5rUWj5YJgGS1lhxPo7IcGcRql+sLl+8Ux5mP2b65K9zGP+b75fsTqhz84tzixRJPxkaCGkp/gGeYqkGiGTwUja6IlmCgoedvM+HDuJCxzHaD+35nHGSmYgu2/TVpc5QYKJQR57NbDgxxyXu84LpP4Lh87KjbrvMtz2kxdPLET4IkFTyZWRzJCBHmqT7+jxo2z6hRWxZwTQkxssIupAvMx/oXjBDCxmBR18+YyKV1b8gLeZ38QyuQXSbHDKKXs6lbO0GLN0ZEvxdNdILTrUNzspKcienjs1RepDrkZlvvQUVML/4P5oP21BWUC8+XGjuVPSCwxM0JAENRf2jdXTRFeTBiKJAlF9kjOOatQ8FxioevuoO4/KgJF14r89hE3Msh6UthUbD8K3X+SjIHBbqFLCSMXXeL59MUL1mLxAjJsTeAWmzZFezscM4xgTniL2d0vTYq/a6tsyzHxIL8kvi/E40A/+LJcb2hVHGmQqu87ZTJ+5oRFTdF6lw/bTlTMzT2VYRdmBRJA2X+4mVeGvkCWpFg/10+TjXaysvPU+APZy6Q6Dv0KOGAdmfrhRyPJ/W/N+Qrk5Zy8mu2lZQuRZuk4mImCHsi71fG87oWPFJQSfoM7hMd6RNIjuMcfzTSv5ufbdp/R7k1rQoEv20MugsE7YgRx+1Hgt6L6o/JwYKaLLo4WlfqtZ3KorzjPUrWfXMSa7boQSFYSRbHvIZ+h4DYapki0t8681OJoQVDRwVblShuRn1grPQ2i8qk+3p6KApI5C7M8+8MhUoVUsNGpBahQf5jbK5E5h57536wn2SukRru0UJbDsumoFL5TkIr1x6sK8qeOomcm6ieN6eQcc1mlHNa3Ka1IF4vMD4PdBE/eaCSATZVXWNyM6URCFXYmiKRzTt7tObWte8/U1F
 cHCvs7xX
 fOvZiWNzEU49xBuq2jj/nSKZhjHI74QzFAb/F56HvMmdXc235hIlfoHlLyJcHMT4AHqBYJnbZWQMK9+7dr6zzUXt68xh4y5sxuuFpY3RCps0s6wJC3iyjj6Ih+Cb/CsIsISumNdPHEsCy7wetDuoenX20ZJXL7kvrfQsBGz/DmOcjydG6aSMultEYp3TxijILes1mvlnYmZZS/iEeKX19+fqaP5/T8l2KoTcT/XXI+jXY7DH6SdtFXtb0Wk9OAZ8X3wNeP2TcprCoEihvOGDoTvo6nWgErLLO8JF/SxoCBOri/KHK9roBuU5wQEbnCvWThsTZv0qu5IMXP+/Y1GhVZqJvPZc6B/iMBnYK1Erc7CFmCAuqsZzkIdJEIrgP+yMq+//86XSg1nWHHmVxoKhB/3NPcC0YT0p3Cd3M1ZGTL737m2QpA1S32bknqk3a1ZvXFnyIHocB7VkS1Pcd1Af/2zSZwTdLP9JHcFnKhqapifijsfUvQ5EuI77sVSEhQr8OejK8i1m7Aletdau5bs3NaGoJKrK184P1z6ab+y5fL6sXz0yXIx1IkUS1izuUCtPIxV/o2bSVj38duuJ724AqP2YeEas/EzgOqDgD9dodXeJF3X7T4NwC5TnJlv0Vg27PyKt04RAXYnjARrL07fmon3zYNOt2O7/jreR6h10O1v7CsHIYtTXptbvbAjsWt0v2hiKdd8hr2Uly3HBIpLXfxTYBUZycehsw4QC0b0ilXsXjNrRJYPd8asMDMvWijXVJlZ6OMXVTddqWZUm+AOX7Kimlf9eJi8GQChmjbpO+glvJV1d6sfiHhZE4BpNvoeFBH5pY8kPQk9TQY9xFA9UYVFiSX+hIHWxtp3WpFqmz5AbiNAgvfjRZRflkfYgQYm9UjrPnXG6qDPT+sS1HD1A7fZnhMpkV/Eo9qcPXUS07UAHBckhCDval4momLFaFs1IMsoGYVaYNocTZ4vGJAin81RrKYA0L
 wJHMOaFQ
 2lNII80tkBJhGrnvmPynsU1yYMxszEYjGgvD20S9ybU8/NQk1ALwdtPjFvSY9RpJIqOwuGls+3cxyKJTK4xmvKJ2YzT/TGxHUOC2veQnsl+u7SNXBPsewsokeFenjIOYst+kUt+CQiajRTHwfmsV/P6ERY7AG43qs0s6MmecUWI8VTKTfm6sQGVRGnj2ZP+xgfmxA2zrA+GigBgsj5Nek86PDpQpzc0wchbG6GFHDpmvhBTVfT0XwB5BL6JiJBz2aznBqkKHDKKMwo8A6rxpMMBjmLZwsb1Ht6ZJ2Ge55JLAfGNxeZK6Sf28JUu3cmCblb9K2oqoxzrHk1doHBdibwgnc4UCScW4kYj4ILoMfyHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are not MMIO pages so VMA_IO_BIT is an inappropriate flag to set.

Instead, set them VMA_MIXEDMAP_BIT as they are kernel mappings and this is
the appropriate flag to set for those.

This provides the semantics required - no VMA merging is permitted, but
does not prevent GUP.

However this has no meaningful impact as these are refcounted and thus can
be GUPed.

A previous commit already prevented __mm_populate() from being invoked on
XOL areas, which VMA_IO_BIT was previously relied upon to do, so that is no
longer required.

Both VMAs set a VMA name, so always_dump_vma() returns true before
vma_dump_size() reaches its VMA_IO_BIT check, and thus there is no change
in core dump behaviour.

Change this for both the core xol_add_vma() function and the x86-specific
get_uprobe_trampoline() function.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/x86/kernel/uprobes.c | 2 +-
 kernel/events/uprobes.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 65a2de82ecd2..0f60c0d076b6 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -715,7 +715,7 @@ static struct vm_area_struct *get_uprobe_trampoline(struct mm_struct *mm, unsign
 
 	*new_mapping = true;
 	return _install_special_mapping(mm, vaddr, PAGE_SIZE,
-				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_IO,
+				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_MIXEDMAP,
 				&tramp_mapping);
 }
 
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 7709ea882477..b89cc5cee002 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1726,8 +1726,8 @@ static int xol_add_vma(struct mm_struct *mm, struct xol_area *area)
 	}
 
 	vma = _install_special_mapping(mm, area->vaddr, PAGE_SIZE,
-				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|VM_IO|
-				VM_SEALED_SYSMAP,
+				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|
+				VM_MIXEDMAP|VM_SEALED_SYSMAP,
 				&xol_mapping);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);

-- 
2.55.0


