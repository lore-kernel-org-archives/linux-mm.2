Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 861D2CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A28096B00C7; Tue, 13 Oct 2026 11:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B22A6B00C8; Tue, 13 Oct 2026 11:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 879C66B00C9; Tue, 13 Oct 2026 11:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 638EB6B00C8
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:17:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3E8EA8BC2
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:17:37 +0000 (UTC)
X-FDA: 85317957354.13.8401A2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 47F0010000F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:17:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxFe+SVv;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904656;
	b=6QHR9t5uuMv8ai326rm1uv7tooWQ+9tItuc44EAyhDxOQDtKP26ykzfVlK0e/nXlOQaJri
	kLxcUXZXzN6NHJ2OL+FuWEx+Z6vSyRXMCaz83pKXXAKBNhmJfeBYr4W20D5yMalnd+yWSF
	hzKcma3/INXadU5fQzT0+HEnIcAKbqk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxFe+SVv;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sWfUN5n62E4e+bmVpFyFp3zeFeOC+JwJLHZEzoq7w84=;
	b=LlevVRc/SssHl31wd6WVihv/ycdOKSP2WKKLuFIHD5kaNl8RfGaH/EXd/6bJWc30lHWlF4
	I1AhL1amk5EJjCOCozLYxNhn6rTBxnFFznn7sDybvgcuRzo9BFRMwWML0Y8IFU0g0DrgpV
	6sgvpJw9zvfokkQCMeiYPAV98ew8Pdw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9251602C3;
	Tue, 13 Oct 2026 15:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296691F000FF;
	Tue, 13 Oct 2026 15:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904655;
	bh=sWfUN5n62E4e+bmVpFyFp3zeFeOC+JwJLHZEzoq7w84=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kxFe+SVvd5Zc7zI2lMw7EcaLCAsc7ByHaJ6Uf3xgnewrLa6if2h/v7O1SikFKQ3jm
	 FkqnIOHtCElS7Q/9Xkr2HYvedMc035KlwYXVmfuCz5E1aZmaIFo4TixrqYg6Vx9Ent
	 7Pr0enwn9FMh5T0Uunzh2/Mc6F7YqbaKrlEbyuVCctxmmVs4G0kbvA5LQcjdwu27iW
	 tdtolsevqPE/oqmgHYbOeaXZB4CCDd0XcZa54NLWTjJXRx2JBVlxZX8pPW0q67m/eV
	 U8kPXCZPZa5DoXxxQFF0LIGifl4z80s/r8Scn7EsJ5t23cASGjEBMauj/jEIlnsVIk
	 ivDmXsfPzXWkA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:02 +0100
Subject: [PATCH v6 22/39] uprobes: remove VM_IO, set VM_MIXEDMAP for mapped
 kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-22-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2177; i=ljs@kernel.org;
 h=from:subject:message-id; bh=J73VgxiDJtDbEjuSEKaa2w2gvsHiWji6iG2sKtoTEY4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZwKWHe8wH9l2lmTBcE7jhiucOK/Yeofu2fKMpHiM
 2FHw9/WdJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAih94w/M/yLckUXy51oCdV
 //EKlpc1pvdLQyKveZ9/ZPDrcFbYeR1Ghm6BU5Nm8HGYp6zd4RXvpqehdsh29z1n0Z/9GywqJBr
 T2AE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 47F0010000F
X-Stat-Signature: z8j9grkkgj5mazwemrsrfkphg4urapmq
X-HE-Tag: 1791904656-981650
X-HE-Meta: U2FsdGVkX1+6NMtxkW/yDG2OeLEiE2qL/o6TYofW0ed3lbn+W9QNfXtlw//yBA5G0jTVpOj/9nUUqDGyn00xB2nH+TQ0VwpW2zhEUE8u1BUTKcszt1AIVpFRcHnWau2OSlqwr7DpD0GEQr3e++kGCh0S/adKdIelhtN73dwN+evcWXD9SqlMRCdN0nLsHDZ8ljFO9Nz7klVSNM1Pcgma2cxQvgA7rnUCnJSRyRdPtOST/Uv+pDelB03FKbXWrDttyArYfdMgSC8QUAw3P+nmtYZFgkK4aFvMfT2RZHcQp5f2r9tWUPr2p7hrPchqaY4qxVWl0WLDL0SVag3QIBJOk7CR8zxwx5tAgHoSe5BADkHAqs3yF3E1xmnqBSiS0/tF1OTS9Qkez9kRjetSRjzGxbK0Fl8/MxAB4icbiIflYXMNBFuGUNehnpZbx4wRDj/JrZYfuJ9AZ7G7olrmwmBQvxP9HeN4iHV0K9QvCLFHqbwIiBWBlOlHdX2+i50njKrOnYl20dGEe2+AAFpJpwksUs9lcS2yiI035LX7zTLT/U5KTvRr++2WhD4kJTOPsus13WSvGEYJ6pO/xLNozFTIMbNbpxvNNf0Vmw2XGLzcjMBRC4p4Tjdr2+wFSBALBKT+1oBHqQ+B+ctFeQiv01t0HVxwp9KNuVrcvLCT2J76TWGlL1sfVTSaFlYiAMlWzjBNbcF5qCuvsuzpU6u57lYc0Z5IgHJ1Z6OBZ5S6mm8N5gDvcWVzFNmeulIMqUOIIbgyNjTsVwqby8u4XkN0WqvntFS87hx6ovNnEw2AXudVvL6AQserR1lZ09jDJet9LxoUdpbkjShZXycSXpC4yc2LzD/wOdBhCXC5DNZ5jXeH50SoFKP0ukg3vUPLYLIOaY68StHGAqna883Zyn3JxPcck0nvQ9KjL8Aa5f8t3HuBH5qFwoI+budn7w0MOdRyYuYaPoiTnfpOphddgaS69v2
 oV8Yp0oA
 HwcT+kHhNgZuLowrsJ6SBp4Cz4XQscVPxtTIZXUegrBNWnliTzrtSZLnNzU8A4f8yg41r9CJwqNkF4hIQhjxFJggAosNrl4qHvlwvkr4USE8ccpbqJ/vizL94arULvw3wSrYp4XgJ3A1aFbnV/3+UOhZplWLsLmJeXAIXEbb6vBOhmNQ3yT5XJw8MZJbNYpXcZJGt/ys1vv6jolzDp/26D77UzABzbIoHiyL0wfKF92ApsbwQhAuqFj0HZZcbgEGOml0yEIRvUok2c2XZfSD0JQktZyLTpm/18I16Q/CTX4XuK0bR9D60Vm8VwKx2mBFfDvjtxps6wECYVA+JWJLWudbFE8rM6uyTaRTK40/sB+xZ1jDXokC9lx4joGGndtHwdO1idArW9Wd8Xiu4b0ihusvRCLruffJkUPgWhi45lpdy63WLjunPdIkGuIA2UlDwIw/6x3Q9c5NWTa9FNMcU08pnZvAFteRuIDynlshyR//yQ5aTZA4Ciev866DhOgka7kMW2D5ioXdrnSl9mgdO4IS7FHFepePUzBwdah+1KL72l8fdwFKp3s+qYOkQvKqx1Qzqk2vRBVylsmP7NitrVjFuCBQtyGPbQD3khBALdAEUmxknYAuV9YoYZK23evef9zfsbAR3BJ+H9qLD4dKseQc+x5rVH46bfJZFmUj3lm6u9NDyhQDYU5OL2Y+SEyC3i/LydEfyPcas4c7LtgyI2G2+ClE6/63hTpDKlK9ygAq0S5tLotRa2D7WHmIM8fERIsSsbrOlFrOFhZZBV0hA4Ch9tVcjtnRFp7xqpro8YnvE30wR6eQSiHoAy4pBO696E+lqSmm4JK8El4pEJLSlPLW2gACoYcJ8+Q1RYl+Kn3lzxrbpeMP58ZttDxY1Q1rH2ymjO9aYWi0U0XOFROjAT7kGKcK1Awlf9CLE1IwGJtGquDx7IArjLyWFGVbpEB5SMUICmI3f18AqFFLZIuZpDvXaRll9
 dNtR0Nft
 /PkdZGWhpA9WIAW5vKtx3Eh1Kp7+JL/cao6AjN2SW2PcCoa+6YyB8hhPNynWaGMVq6ySX4loavPK0U8xjt0mMRWwi7G4XWcU7AqiMr0gH4QK6IFGDh26MhTtuHUAKJ/OSSkNEN+AYiEq4Dfstz1uHRpQIyA8nZxsMyQWz69JnmBZpJnwS0yYyZ21BGa5kh+lcguoDLbCcIKY1bSrH+NFbsSss4lizKNhLgaA3YXTH2rMgV6M9QMlpaIm9A+6v5mWSTxFhm8COzmkip0MKZJa9bf8CKOk8QP2q7pwCZlQQ1vie4uV7b6prWqmxAW5uW23hqgQMuUi6qr7Rzk29Ico9WAqOLEi5YDf8Co3FeGLYC/x9UxHG8194uai0mrthE0FU1BSxpb2TeqGD6BxvOriKu6KKR9KQ5puNN4PiEOQS/sQXa4EUhIvP10YVjmb6hMptXruWOjsT664N5AtXKyJyisasUku+sWGHmea0jk/cOY/oJUCnKnMFFUvc/kG2qJbaqjkp2+NE0tZbFtTXh9Dah9VzLYTAoJc5xQ7iIZTgjOkxGGeGuG8NCWjjDdHhvTIdhIFIx0qT2GxUAh1OaaMUbXoHO8rOSoEyfGJC/YCTV5uUtkEjOAAy7WZIfJRnQ8O2mDArkcjeFvR4svdMT6F/Yne/PyjXX6TFVEc2Ry9jmDJRBXbNnU2erXHk2GXhA/uYv/o2LiPBSndE/f5KBPWXTwE57zYRamSn/jUQ5vsKvq2Cm2TnXLth4Sl7kQSbfmYYkcYP4rGeIVCnyhG4UJI6Rg1XIAxPfurMyad2kjGKifp712RIjSypw/S9FAgT6OnotKuRQcucGOg26vqfs0W3b/sUjaSYQ7F7gmwbKIuWbD7XmLSpWMYNbkVuXGswlU/ewWteIVtdCs4HQyN5PeIFLEgR7IK6HmHj4KxRKOcm0oS5HPzXWtQFSS+nN9yVo+emxbZVpi9qApOIIXZMey37UWbc+ksn
 vlDXXYP4
 1wzwMols08vj3Nau/nfHG3Vp9qaChOfoe3fuU/9Uc9mU7du7c/fxk0Ykpp4/BP6FnAyr3wB/XPlPS5/imb5Mk0kUlozY8886ahqDkWsbdregvBAOd6J4NIndGlVfNBjVceBcxnb3su3014A04Do/DxfznqtYH/pHwF9He5kQEhuSDZRdbKLWt3DXF8wAC2C9YvPKcKOyojM/IvBJCAGzHH8ag6szgjgNpoyPsaVU1jvMBLqK1Ih6qgS+wXAt18t1SlkGrv1RTpOaef2HgSpyYMfCVzVatgnsrM7xscVYMxskA7gbC5nOIWeQro6RcX/OGTfCcJht1hQVSqh9EliASc36d64U3vdHS3LUQrgfa8iZkM6RlnAGpyVPKhCQVrns3ktQvx+4nATafV/5ezc9jh8Y+oyuY9wNxMNUxmQK/6DiDtdoyjXlUGXpjdccaCoAevixzkPB+hPomjzqh98KEAP1jBoy+PRSsvDup9qdefug9bBqTST7UiKMp2yzseQIkUDkL9JvpR/Xt0L7ytdFMQPtuSmK7+pX6mmJdC0E/H6s9tAvi9JdP2svKDrd6Mh1wXrmKsu36K20PcsZRSek9hJf8uVGi1xL/nk1rE3JMBFVIrXC4Cl9oKkn6mFwQOQfHPi2Wiay0hUkUa5Eg603Aroapn9FmMpdB+Ahme7mfpC8qcRFon7bVclrUibj7y7vdcjb/tciUwaiUtqEFjr31xE1SSup58EX1Sp+eGUDGGK/h3GabmZgBdQuZuHHtcsyvpr5nMh89blXRpciRJY+T6U0eMG0Nhktz8ZL1LE8EWGiFqaD8cIqN8XzeHM7V06jIO693JBljULHGLUbfBFrPF1CXmqi94A/jdpQBsmzUiO86pCnP70lDCw4IePz8GxQGpBI7sfAI8Rzmfl5xeoSleAhKggVkJjMvlm7YGDrCv3JgFWY0ObfcG7R5bcyO+WSw5pii6pqmpUeCROp2XnMJdJ9lyrcV
 ZS6P56Xw
 qQMPFPE1chRlfiO4NtFIYTeda76fVcRgkF/3LNgcLBd57wz/jWEUw2ig/SGjBwh6TNyZ6+uwzJbDPQe7lIr0eCWXFh/ZgKWIkbtqGOSfcxJTWpMMK10QRmqBdtFUQwy93TEf7BteP3TKBR168zsrYcXKilUbzUTmB3J4xM2YV4mSipbA8k7JcJ8nZoAtbvFwJfuRshfE3bxT9GPRiY4ds65zKqfxG+FxHTQ8v3/iuMkGzfPSUZ+9WE35BNmFpo9YMPVRPis9vaKwxUIqN9yPxk9/WKOEh9PQSKqy3cXcCUkblHSOl/qRdXHj11B3DSpzFtUC09D4uCAEQ53NaOQuGRInoVxzFBjw0M6jEHctmaXw==
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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


