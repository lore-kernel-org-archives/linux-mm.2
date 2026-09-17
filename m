Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70F64C982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F586B00C8; Thu, 17 Sep 2026 12:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7759C6B00C9; Thu, 17 Sep 2026 12:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63F726B00CA; Thu, 17 Sep 2026 12:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 423AA6B00C8
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:42:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB1F7A0456
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:42:32 +0000 (UTC)
X-FDA: 85223822544.25.FB9A67F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E953EC0005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:42:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cmb/ysU7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789663351;
	b=W8uVyqfwcQ3Y0WEn06nUxWNsdJUONa+3pgVUHbnAa6Itmns8/TwEZ46X1iVg4ENJv/Fnik
	PYHYaN9YPR0PdJ85xtpAVIrbAKOUDulG9CT28FRQEcpPwtkmneD1ygKbJxm08Bs4czJcru
	+iaQsrEZsOF5Lb1zbfRYBshcyE7QeDA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cmb/ysU7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789663351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwIdZujBqtKUK3euRg5palCjbTo4zKXqAqucXZZYP/8=;
	b=ApxxgJTisLyfnWd0SS37MX9c3qJrl9/QeJYnL/R3dkN4W0zrw+dejE593LzyEXSVAtzvTI
	wo9zL5zIQ0T+qOh+2i0HUVUtfL9NejqiqC1HXZPyOblE6xVz9OYqt46n88jiGx1CTm4mAy
	AFKhRymxTcEusVs067VXon9U6zAxjHY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4081840959;
	Thu, 17 Sep 2026 16:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468B11F00898;
	Thu, 17 Sep 2026 16:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663350;
	bh=XwIdZujBqtKUK3euRg5palCjbTo4zKXqAqucXZZYP/8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Cmb/ysU7A2bqkrjcmYKGtzkObQFsqsQPqhrTeACuT7E6udtT1VtRCokjSgZIP3veQ
	 c32KYE7Q9DbF8zaMyxdAW9fKam9QLmC03ZSyK4ksj3idJnuVXs/oNjziwcFItF2LLw
	 UXTD0GRBCuUWyaaHwFU7V9V2R0kh1sCwhloi6sboQXKT62VT9XyL4F7yz1mQIDjL8k
	 LACvKsTACex+CrxisqCI3kiHS0TusrT3njwlV7H9m09g07nLEqTRxyiI41CBhhw8KS
	 E4K17K11KDA0M3WOz6mIGN9sK1RDTsxG0KWWwfBABdD+kmBzfIknYzcl9f3xb2eAKv
	 UHCLP/xRjqYsQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:47 +0100
Subject: [PATCH v3 38/40] fuse: dax: do not set VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-38-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1455; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RCEYQjEW6MHyrFoJLHJtSFluFNRdmgFFgjkTdNXkXXM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB9tal54zilG6a9/eXzYJZmViV0XHrHWeHJK7Ly4O
 N+crdq8o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABO5/IDhnzHXzvycdY9vvjhf
 ZcHj3XHM+C97xXHnLRW/LW0fMVv8LmBk6K2oFzgzw6ltR9/uvf1lv9v9fgYkZEu+2axxyPD2Ip1
 sXgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E953EC0005
X-Stat-Signature: b31ugb6585w3w71bdpxoncry4xtojrqk
X-HE-Tag: 1789663350-115984
X-HE-Meta: U2FsdGVkX1+dQ8cjSfwnTgiubIDPnqiImTcu6iP/TEVCqu42gbpSrnD8fuP4cfbxR6R/LWGjgnYnbDzhESgoVgYuvtb7pSxqTYlw5440b5FJZzOfqf7axvQ5mChI3lo5HW6dLtWlfyts8H2oGEQQJsV3c2xE4XXuCKGHbZqvRJ6tRhkrEtftVyZrcHjq0vrXMzkpkSQsGwDsVMdwW0/xRs/jxze1HYYA24VqNa79QeXcll9Zef4XybzqMwQK/f/6ktp4rQI4FknZXJMBv1RVtLk+CYrYQ01J6SYCMItaR20+1PJJ3mk5T2YQXIm/2C/pV2u4eLc61Js2LrNLv5ReA12NdFS6flPwo+eHAuiRWFVM8jZ4hrfiWbP88f5TZYX0K1SYonlQunKRUnmdqQ452z5LFznbadnQ68nHN5ch4YbDt9jgD5Stxg7KUAnAMQ1VeQ9WrLfHs0NikbmjYqVojgnVx2Td43PNWQPz9gk10Qbg8n6GbtGSj6v/j3aByIfaCTAccA04lEQk9vMMGQubHX7gPrQv9yNKiMnX4jf9VeRliQ0HS7eHGjTwDl2CJ/YQRlePCsNrvUOsVe0ikEn2eiDBOXZ/6OVAz0chdZ/vGj0+GIxGR1CCR2sU0RL9NMtHh42C2+pZOze28j7JuOYHmhxYk28ead/5PmduCrRZNTS6dyetf9hAQuhegmwR2lb5Xf7dP/Nmj6MUcUqqiVa4/ZfNTagosIJLzIdJ13Y8cK795PEPFwnlYu0l21r4/FgcDpVeTHtGJ93BpyqAUNyPYHuh+qwY4w0X0S2v+cS8grL7n9snGiZy8MVJM26wMnlPB1gK1pA8wixG86HzDPHpk+s0t1Y0DU0s7ZB0ZDZA6kOIrET6/e9INJ+75aSPFqAWYPdNFfJsUaSfy/dkpwh763OBh2x89grf8rshVUzWTvng77tf9x1QtvDd5Yxt/gFjYiZZzYcN+q4yfKrc4dM
 G4+seIPO
 MNsxGupYB4pOdPMGq3ja3niJguezPO5pU5SZtlyT3sPdbVQXoPpJEmD3usB1TEAbUGZLX4LWxXfDNoCjrSlICUU7UqT2iDrdTK4mpnMm0g6TztaNp9wTp2zY+EWHYh+Qk8CCp2r90HW0vQrnNQ9L6eOQHRmbnPUWvqQVXCvmrOkdVLLfV3pxVaLD+Sx0sSNaB3TipfiZuW9bLGxqEZpH/gODfUY4AmVeasAKRyztZHhFkadOcvMCg0gQpHvXmOsAWGW64Nijn2KNbDUkJ+25YO19FyXGp4Mz+i/2SMKrmVviOpEqQXrHYTGt/ly0CIZhyVvtAa6ZswmSvP2lN6BWsw38hLCwCDPR8D3FatVMMJ7dn4kZm4okvYm9WB5IuzNml2X4nHkJYIjLpEemZwkIoPNVksOFPNhq8U7PBqNta9KevQYXUQGG0AErKGLCsVCkiAsa2349x1I7S7q555jafm6a7hqMizhWzQcIRXkG24xYBqNmgKXImcoCLaDfJ+shXE5L7p6LgpZBtm3RIHRwbMhGsblWKTd0ZD5d7/oFT5SS5L0mV5Z+W3LohMqtlVx/Q7zkVa+nCmvp5uEHq+WUOHYgfM1hDUdtoH7sIIg5kPnIgiEc2MWUcD8EWjw+90D6AnSJU6/v+NQmxDOukqndJen+itjoEdVPTfq32CXDzhwwt3h008yr79KSqCV5o15V7C8xe5n/ZhbaeWuC+3QYLIkG5zzn2PB/A0CXIssTrW/So6l2RHkA4T+axp8T5fOJeRKnLNX+MojI0WiUSIVlFjT0dcrfltFXyY4idPHvEVKtM73h0uhXGT4CLOt5nFH16aLbzCeJ12DFmTiId8Ric/g7SOR8E3TvvKAH9/ff5URnE/n/V+L9brIueOw57QzfcThxXgCnILXSbm8qHu9o8OFqglZC0hJkbwHQ5d+CUoECUhvlVwdL+urwBhxDFUzSJS8VqmaT6llxaYogG9spEMU2OviQW
 EhmGM8zg
 G4l4WAxiO9QDqvSgSrI6BPMPxO5aQOz8SN7/uUu+mzgUYQe9h4b1EtuqWuVoBU16R9Zv8QBfVWGONuhAJOAjIVFJylWcfEeSOo8bgkp5Ic+GW4MruL11m7AwQD+i/Bg4mrk7M1c2lMU7k6CQDC1Gsz9NFWaF3n0B0wLtlmlYGgE9fa5JXAGQFYes66/n8D6HBWphTcopOYExv+9Cv9tNkRzVlvsrq+5N2uulTog6NmbruZRX4/DYqQf6X8iDDZjSl39pAHIodYC1rfLI3ndvus7XqU6fMiDLIW7ual/2zNpwHml6HINkMNrrWt76w/kQMXT2HzYBSV08ELtb64XSFVcX3GxkVIC9jJGmIuYBmx8prJL1IDUqdSP5BlQtJilJSYUA1BIzO8fqpwXgeQegR+iqRDNnGGqQki1S444QyaVnYfg7/tB6ytlsVg7Ojx6B0DkdtI8kqa+tnK7bwPvkWlfGCdgWlT4dwXPGgECeCub5WBFwMSTZbvr2EfO/T4DGbV6xmpegrMFdQnWfHSLDac3X2pykdtpq5XOrNyfMtsjGWj7rbnPPxFg3T5Sp0b+VtEV5klRji9jkIEDpEcJC4+u5zVRhjoonUO3CCQ/D+ity4CnCRv1SbgIU/WFarfOU8ex2GwhQSPZ1P0WR87xj1b++irLvSi/W1VvjBOBuoy/tfNiFruZ4stqIz1OfTJUjjFhU0RaZxjqyZs2F+BbHydGaxO310s8mxDZ4GqPzf97f+0mmkNI+QoU+p8SRNomz0fjqZRkfJaYTNC5A71IV24UlWDhJoRir98B5Tyf8AU+TPNt0TIQ58GQeNUFTpoLKzmy6361/QtEglNPa5j6HQXQj7Nv5ZJ8LUCXmP5F+Ko7brPPeRLdTyfZfofpbbbKDJIg4su7WA6cgwDjVZ7a9pYKMjR24A0S89IVi1YZXMBAYEIo+tp3c1PJiFYXmwfcOWTpsU9Bbf6pRgRkpSHmcHBLfqRXLP
 ZO5A7ZoI
 lt7DwQGtEyRqbnRoS4XOFD+STsLtr+lBi4Ft8hHDcHfI90VxPOj4O7bqhoG2N492QCHQsGq+WAoTrG/mB681jjDYR/eBfEWmBDNd+Qi7EMh71M9j+6aQJXD58iSSmvkvED9wjI/hHqWvzUE6DYocDizkes5/SgJDMTtE1p3VqKBZy1vOuPkZ+m5RaifMptyK6KKe1Mz5hGkMF+wVQ28XArmws4YoMoNwq0WtridnFsyezkTdc9AZsDGSAmVWUgNYEZ79ASYYO2IeaRg1ZIz8x2PFZZu5xTKazsYlGxaXnQ3+tXzvytfoLaByjm3J57nxIOUT8V5CF08pYBsdLdckNRxAs4XDWAPBjo9QNy5sTGAoVA/o8EEn4BJgiY0oXWxvdqGKctLa3nF8Rwr6aY1/6lS2+2ovrQTAFoFO9IZsu68/uyLGt4enO/ArFhw9JL7tVmBhdoHKLyXIp/2+pxb1jG3CwMrPc5erN0FenIJvNfzTOgYdU5SEZl1wO7j/RqQBrgDJWyRw2zWqn4NTOZ4RE4BiZL6x/pGz0F1ybQRZZhVfEVSrSkl3nlGVVaKuHWdZd7F4jv+P39Q93+ybebDKJcYbyPhBudbgQEjxF+yF4k9HGlBjf0TwuRCtAAyZZYpTLy+wmJhy1G3uS2gDAw3SHcexslCAw23CCpI3E2m/8IG/XFBmf5cKBncnq+kwhrXOkexbnAki0bJam87MtiFNomC5rScgHpYHHqOWQJ3av6E138TZf7HV3a0+NQ/ITD3YMwVBYcz69Wptjuy3lhGHsjg3kouySrMhyJwkT+Yr+8a2AMOihACJHsQWOYr9nAAclVse2NeU4FxhEC23liQAa9+vH0CsxQ4P+IoT6ZR4CanJiouu0AXGp+Z30HSw1UBtoLX1Ss4OgpV0c3SR5ta19NVVLSaH/lawZeJhmSmFO4O5xCK/Pz0LBCKy6LcznlXdNHFIAcjbSFOyLQwlKe36p/NIau+B2
 wgYsDu0N
 9d3mszhvg3ZmqRSM8ZoOCprMfSJWt1pQgOxG5arPtaMLK6gzJGF2dvnMG3mCtnYfL0AaV9CfCee+uL7gYNj1B6T0abnhqMbC36RxDlqbYvFby1Ye/k/0g+OGkUkZRh6aixm/vYsqGj+bHWlCvamvDzcBuq/alVq7V1NLh4JdHl9kF78RhnYKca7spsD4U4dqsBC/WylWraPjBq/4nrqeLHV/kQD/NJgK0jUTWAuq4eoBkSILh9ysTjQsASyC48COjg4YM9jCGxx+ueFirnlvXNXSzstJKEu4hSuYBQoGfuy8ORx42pBeGywBI647oBmbKjb+nBVV6dXGeSWpHOff3RHTjVIUur0Gz3baDcI7qwkOxL5mszMfgU9H3KVpi1nTz0QIomhc0NexkPMXZ0RUYIADECtdHrn+XFB3U9vxsLt9zgyisjIOD8nKnwpfAcKtoyGhHG0cUVPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit e1fb4a086495 ("dax: remove VM_MIXEDMAP for fsdax and device dax")
prevented fsdax and device-dax from setting VM_MIXEDMAP, as DAX no longer
relies on it to direct core mm paths.

The fuse DAX implementation, added later, copied the old pattern and still
sets it.

Fuse DAX maps pages the same way fsdax does, via dax_iomap_fault() and
ultimately vmf_insert_page_mkwrite() and vmf_insert_folio_pmd(), which
insert ordinary refcounted pages and so do not require VM_MIXEDMAP.

Setting it only serves to mark the mapping as kernel-owned, making fuse DAX
the sole DAX implementation whose mappings are unmergeable, cannot be
mlock()'d, eagerly copy page tables on fork and reject MADV_DOFORK and
MADV_DODUMP.

It also requires vma_is_special_huge() in mm/huge_memory.c to carve DAX out
of its kernel-owned check explicitly.

There is no reason for fuse DAX to keep on using this flag so drop it.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/fuse/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 85cdf0199bc0..a5994f1c637d 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -826,7 +826,7 @@ int fuse_dax_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	file_accessed(file);
 	vma->vm_ops = &fuse_dax_vm_ops;
-	vm_flags_set(vma, VM_MIXEDMAP | VM_HUGEPAGE);
+	vma_set_flags(vma, VMA_HUGEPAGE_BIT);
 	return 0;
 }
 

-- 
2.55.0


