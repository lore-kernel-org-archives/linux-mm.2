Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 111EDCA9EC1
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 267416B00BE; Fri,  9 Oct 2026 14:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217EC6B00BF; Fri,  9 Oct 2026 14:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DFF76B00C0; Fri,  9 Oct 2026 14:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD75E6B00BE
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:13:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCAB71C342F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:13:43 +0000 (UTC)
X-FDA: 85303885926.20.FE4DD04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2CD91180008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:13:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="llFa/poY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RI4WX0O22KjPeI16PdUA8FkhrmSCrPwITssscZUOsxA=;
	b=LP3cWskGKWdUJu2LDumIKvmJPpKoh2GmxEeoXAL8rD+NW82EvlqU4KMMK7ngsgeE2zJOLz
	pngA/rrm5fwm//NYKvchfiSbcOXZpS1jsC/a/xz7//GH2xsevqrLLPJWH3VObmbpQaogtd
	MZ1cxo+tLNZ72BgMkK89ENyU8ZXGWFo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="llFa/poY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569622;
	b=t0hvME6QIYwBXIoHhK9PkRjRX9Ug9YquXrwgb1oZeAxoK+t/EEp8uoyfdBE5BRYnUUnJoq
	PJanH9cJTu+RkHcZ4bpd5kNoww2cRPkvO3GT6VS4Y2aCr6JuQ4DCTmpYWTl1itTep7072D
	9zOOVIKZAR+n9obOfArFZwPnewRUE1c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 857E360DCC;
	Fri,  9 Oct 2026 18:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BD11F00893;
	Fri,  9 Oct 2026 18:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569621;
	bh=RI4WX0O22KjPeI16PdUA8FkhrmSCrPwITssscZUOsxA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=llFa/poY0brf6+kiPhmRb1N1W0JK886d+tvUN7BA0EBLft5rKIrD15XtZgQt7LDgJ
	 94bM0LjhJxPxv5Lnp65QXqT/hk7kjPw1jz1bWg2J5J/RQCZeph3B+hiMNrGPT15dKN
	 C5tbKlRzqdZ/z/Xu2S2t5QN9tjEMxeY8gQgT7r5qa93woBjuDUE7Ww//naj0HA1L23
	 UQHaJr9niawaKr4UsgHHAR01YGMCRnurKUjweb1cB75kFRZeKmP8AuzxjMt19htlXV
	 D0fJCYxrjGgRKX2HEoKZrWp3M0pJnfZdc5r3X0DLRqudrhqWthF7IjJ1N7Eu+E4cYy
	 wHCQwDQ0fk10g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:20 +0100
Subject: [PATCH v5 26/38] mm: remove hugetlb_inline.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-26-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5629; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Lb6PN86E47rAtJp1lXXo9OY9NeHwxjKk0v89DhOzLiM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6syV62q7OXvHmknHD9nJTihnzTy2/9wd6dabLSLpJ
 vd9/xcLdJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiJ2UZ/qdy5ClWqWQ0+j1e
 /tnhQNdFlgNRTotmuU6WD/PcFhKsq8vI8KDVJD8vpc1W8InSt71+j0Ur9YxO7NHheB3yRevYFQU
 JBgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 2CD91180008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: izd9153ow8yseu6bhhimb936gyk4k3po
X-HE-Tag: 1791569622-364473
X-HE-Meta: U2FsdGVkX188wBQvx5iNrTzwYUSBU3HWKGD9eAfG40jIf3bttAaO9d+SFxHAvi88OI8F+455N1A3HxLI6K5XAkscMFpYkZLiUrdTOGnVPqBXUym76uhSrisl5B+94WULN5vvP7FsMUHeb/6BRh5eacHcUe/+mk6BS1AVioM8dtJtvLzyDhqXMUrV+bgeOKnfVuZLFXk9WGn4+CPP8KMVsSgtnCHmCtw9iEGa8OvkrL+n9bbo7v11B2TmdptjgQChfdFhIlChC6cwzDf9KZdxhAIWmYRKk9DJ1y3DpxvN7sbwMpucQdywY6GnUiD9yNN8t0cYbvEvww0JlCIMUlQ92LaxIJPlH1V1fYp7OeEfPXLn5CvLHPy5CSZuvYIrYUVc6cd/urezEAq+RtxSR1q/xB5S72CsfHFstq3f6RxF4GUqe+TLtz3NbYgrXnRlZmpaAyP71rNRl+Ti8N5PFCBxm2gNyxF2TvOdTib4AnAY9lsu+mzbG0u08BwY9flpD2xhbUdtFGBBfu7/REbI7Wy8ELrmSaQqRSQTUvhCjiITG7gG+761BORpFwxEwsma8TkN3CdyWpp6I7+7KYmSFf7PeDhoEaxmEYeEqd/1Ys6NJ5yDKP7VIGqPJuswisTRDKi9a5kRTjGPzG31SiWJykgaCP5VrBflr2LMikauSTf5dspLpL/FPH2jfiHGCa5q+1jfpDIZmCxYNnpj2PMnDzoU5Y1huZkAGeVxC0Hp3D12ZLRbFq2mWF3lIB2F3y+/2L3PWs2Cdeq0mKO17VZONYdkHTALIJ0GLeh4WK5kHG/HK+nADljVAx3Tk/5yK0XLU6jxYAo3XeV6PCxNABscmG/CkCjgiZRAK2uFOUNhdybnnoXYz9Dn3hDR9JTPBTuT6g4v3EsQ6unJICp9MVQsjabknZDQrT1ch9t3kS884EDZz6L0pMsCoZ+RZuIm6PSeNRmfBskGCK/ImanXfFKxgyq
 rG19kG1U
 BhzsQTCQTYLwFydEY+rsFxneTwg2o7IiagJL3TAjO6Dokt0tblWitQVKas8Wb3p6UIlr9SX4BfdouD12cDbpwv1RVQTweh+DvPpUsiHUWmh0fwLlQcXMK7O3uhtToMbZPeGCqHnnrKRaA2fa64/pjiIr3VriUGhCbIEv3jcpfc+Px5p8ao2lFysUuRsljsl7HihuXqDxmuyhxVKQWjC3XAikYrr/iZI7fd3acOL2hiFoG/GD0jxaa1Ckrktg0hu3sUFpXr1EBlhgjau0YFMn/aR8QKuanQKz+ZWUP8M3V6teVO2nMKuqu9/TsaDv20xLP7Gh0++tEomRbn4CFRKXY2riqUPstKxO0xUFYuIIRvPlNhGuzWLu/TzT1nGdtfeQ5YaZeTF1ZZgHbUsA+hOU3r/SqPzwkfTGp6LpPksxTjYJ5C9rcxQRDfi3NOUjGfrkRpBuXaF8Svuw/3ak+QESBq2LER0y/dlMNK8HkexAkoTaRn+Fhx/VHtu3N7qw9CNnQsFpOgXfPdERd0Dr8MmNBIz15nyQ6xa79LwAK8vvHR47L+NoI2ry+4FhazSEqkFNIk6CKqRt5E9MKSKwKbdUAQLnN0IzYNQ02D1RFQd7EUerYJa3RGhD7bSR2QZL3RL6c0C/a+G9MdrbtYUFKJ/mFSoRjH8cBeV0JiTU9Gg+btblj/v1m3DPK/qkLYI9Kh97xWWr3TYYdkv+EA2CG0Fcd8kog90RdZeXkkvXlQLfbV/hkovl1uUVoVOvHfSJzjfwZ+S8+vX9lHCn4mjQY7F5/aVdXaaQMyyqy5M1U9xiQ2ZMyRvFIXHa+ZYdBMVnVc9aokPldyXO5hl17TgQ8T6ojLKOtAqoSB4QeEKGWO0Rn6945/GwWmapwH3D6auItcsH9iwkOVf8eeuJg/WmYRUz1ZTueG3sSsS6+Nb7kngfmmz5hfwhNBvXnBz0dzID2u5vbf20ZGCv8Zb/9hwWRKaGbXmgpGEc/
 h20hiqyj
 BnE7civcP1af2hL+PbikRYwdVvxxiQVQcJOUDJmxN1ByphfZWhLQCjcsdTD/rzm21pdSirSMmnc4gIJHa00Ru40R96hrVqEnqYJ/ckc7o8qeVgaJLv7BuZ7nSGUIzmm5rcisRB7rutOUaPkDWvwRSzucND++QgnQYr1kW8QMsCDR4beW1vzifrwukK9QkzB43GSdFi8tmkfjDbBRAJl/oYsmEO0yGu0Qg8zx9SmoutmnguTHIe+RWZWCj9HmsYrZ/eqyzwzFRyCsh0aDOgu6gbovoe4DtFLk9smIGaK6oNG3KKhuCW4R3b8sbEqIScEA0YH1dHXVeq1sDVrdOC5Fh38bNJqpNrCAv3awOH8/bpoGLn0Mpb2VeWm9TQgmFh9tGhcbgi4NX1aXPTV54Q8Iso+RnbDiQ1grAwlhpnQ1m9eB+msaPTIpVcnn2wmo0tyRQR6dmMbJS4Lg/GR1NUOA9QBG0pGjZgvKbV/VuJkI016i9Iahm9AvUOvOsBU4wqtVFKjY7OG5vvTgzpMnpvMomZiq7tkJHT+/juaC8J/A6qHhoq8ZvHAU2rjqv+3qDMKw93BSmrSCRUzefStej9CjaPNfak6VkF8EfoucgKApezs4EK/S43Ye0+67eQEqZmFG99ylPJ10ZGJRkpivvqJriw/W2ezS1F5K4qM06/cEWVYRAAr5AEPQJ1xAZGuwtVQzhEwbGsUm+KI0DEJfnHq1lpvAHqGJm16LmFlHG3sxuLovRy0M1akNs+Xj/l6ccy7uetJ6drkpJfFjnKFsGXWWahxSWKPBjx2HdCFaY+KJbNI0Dt6Au/NdYuactQTO5E1R/AoiHKnaKVT5mYfYuVwVcy/U9NSy7wl5GMkyS58GsUP6otzqrU315oBGQBJcuMg9qCdSEKz1B9XIOJm9ZTWTsW79TiG97hTxro/J/ifBGjAwT+/Iza1IRxOYJc2Ystc3Gy/xn0Su7vryNItO9I9CzdhT7Ylqm
 qE1IxP4f
 Ty/0MhSOSPIymNKnpuj8UwL6g8CF24Pvt4rRGe9fnRtkyVV4DQR+mdMPI2pVDcu4hhWaRh42RKjadjVBmbiPywx3WKu0Xm12gY8nZA6pIRwShRrknfMNmmQ0zpqJLYf/NiXUmxEgBcXr62tZbaCUICFFJu6V41uiCOm4qhIiQLpKuvdh+EcqjEBY/KQc2F7VMg5K3D5lguTvlcWpXm4cAl7+gr+loIfsp0coWXz1cZzUe1ajYcPZnlz6qYSeAN3i5dZ9Ilusg+RZIFosvVlLrxQ1s9qK8/yf0ee69PAtPwSlozdR6+hxtBl+Ox3eFLxr35ln3Dg9VydoVMC18HHNraFWfPOaZ0frFRPOUUK2uAT309374HHPWzxeF1FcYrTlFzGh++i/agqu2bS/8UAk60M10RQgu58ZSWTGGm0HHBKE7+gKXtF4IO7O2GnHz0jCRSnjGOpCVfpThl0DfgSWWGeRLw4asPqwdMrEJXFRC58KNU3JUGmoWckksu/RK6T2DBo7Zd5oL7PiQaqcBXDYRdqtX2C0pd3FD7Cd6bjtmehgdydBm9cxbsIviULVjKnzVFxAV6dK2cROfVDmvmms8wi/DbYcXkvkXfpy1Loa9oSKYbz4JSw0VgO8CMJZsmDUdyGgQ5+s6AfBMRjCmBedVnzdQqueTR9v2IaSAA+Ma9G3W9RJKnunlredNxUums14U2s2gXdx2rGePZh1Bo01rjwQbjH6hgGTjK3tiPqb5kc0Aok6eINAn8izcxFWfmlzbs/R8kI4Vi4R9FGRryKIiE8887AeA1GNoYPCNj2vsm/vNMZl5Cu6obgSChNtUDEaED3be9iUBTqXmggDhk+yzVOxwCcelwkhI38uIfF86TzdtcfvLV2jUsLQ0dnAbPHuYrg1RaTr+wk4SDz9hAZO/xhHVYgVSsnp1PPt6iFofaDLEUBs/qp950m0IYWosX+YCbyCXOdPc29jMtS26KDc2OH3Yk3lh
 x8FQCIVw
 xdqA3w0nRBQWv9utxFwr8F3+xSINw9f7BqXfssdBMB3iGhr+oMHXUr2dRkPCt2C8hloLRlCN0VJ1T9Kh3O9fzLarwS9V68WIixAi58dtpUfAzQdt3c2J6vvaehM2pbixDXYaimWLudVThjNgun+PJoVtOIw4dmLhdRt4wBctc5nVbQwhC6wwYIhRDymfDx3kdZJWDZRLKm58CZgY02E5CCWvrrNj9A4uTP43u4JKoW8MggmxlXtsrhPRGPIRbjQlpKkXYig9NbgFmF4nFvHOn6HNFOmh7h5wUZW3jX17x5a5GH3b1e0svX2+jD/fvxTlFP/gqp6XNkCzceKEn1nrmBQugE66hmBZwG/+SpJrzwFLblzTVSzp+DvrrCwubrJ/96WBfxwTVC+3LVfijUtM+NnhaAH511BUYLjQGEHxFFNb8Bxc/voiUzQ6LXKeHtQU5jLN+bykG4+B8SrF1CWPiTGBZwezwGrTw25nJGPD86rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This header really makes little sense - every place it is included mm.h is
also included, and the header itself includes mm.h, so it does nothing to
reduce header size.

It also oddly does an #ifdef around checking VMA_HUGETLB_BIT, however
VMA_HUGETLB_BIT is unconditionally available, and will never be set if
hugetlb is not enabled.

Simply remove the header, eliminate the odd ifdeffery and place the
predicates in mm.h.

The naming of these predicates is odd, but to keep changes separate, we
will address this in a separate patch.

The file was never put into MAINTAINERS so there's no change required
there.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/gpu/drm/drm_gpusvm.c   |  2 +-
 include/asm-generic/tlb.h      |  2 +-
 include/linux/hugetlb.h        |  1 -
 include/linux/hugetlb_inline.h | 28 ----------------------------
 include/linux/mm.h             | 11 +++++++++++
 include/linux/pagemap.h        |  1 -
 include/linux/userfaultfd_k.h  |  1 -
 kernel/sched/fair.c            |  1 -
 mm/vma_internal.h              |  1 -
 9 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index a93eee7ddb9e..793dacec2100 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -9,9 +9,9 @@
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
 #include <linux/hmm.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/memremap.h>
 #include <linux/mm_types.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 
 #include <drm/drm_device.h>
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 044dabc1fe9c..8b8123e5b7d7 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -11,9 +11,9 @@
 #ifndef _ASM_GENERIC__TLB_H
 #define _ASM_GENERIC__TLB_H
 
+#include <linux/mm.h>
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
-#include <linux/hugetlb_inline.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 80a5a03e9cee..d7e6563cef75 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -7,7 +7,6 @@
 #include <linux/mm_types.h>
 #include <linux/mmdebug.h>
 #include <linux/fs.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
 #include <linux/page_ref.h>
 #include <linux/list.h>
diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
deleted file mode 100644
index 5c29cd3223a1..000000000000
--- a/include/linux/hugetlb_inline.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_HUGETLB_INLINE_H
-#define _LINUX_HUGETLB_INLINE_H
-
-#include <linux/mm.h>
-
-#ifdef CONFIG_HUGETLB_PAGE
-
-static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
-{
-	return vma_flags_test(flags, VMA_HUGETLB_BIT);
-}
-
-#else
-
-static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
-{
-	return false;
-}
-
-#endif
-
-static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
-{
-	return is_vma_hugetlb_flags(&vma->flags);
-}
-
-#endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3ddb463db895..6c470da29a64 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1609,6 +1609,17 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
+{
+	return IS_ENABLED(CONFIG_HUGETLB_PAGE) &&
+	       vma_flags_test(flags, VMA_HUGETLB_BIT);
+}
+
+static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
+{
+	return is_vma_hugetlb_flags(&vma->flags);
+}
+
 /**
  * vma_flags_is_mm_managed() - Do the specified VMA flags indicate that the
  * contents of the VMA are managed by core mm?
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 939f3a5e973f..d7d8b312466c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -14,7 +14,6 @@
 #include <linux/gfp.h>
 #include <linux/bitops.h>
 #include <linux/hardirq.h> /* for in_interrupt() */
-#include <linux/hugetlb_inline.h>
 
 struct folio_batch;
 
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index a4351cffc60c..a14b8a9ffb7b 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -18,7 +18,6 @@
 #include <linux/swap.h>
 #include <linux/leafops.h>
 #include <asm-generic/pgtable_uffd.h>
-#include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
 #define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a07a658cd99f..9eb12d0b6f1b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -22,7 +22,6 @@
  */
 #include <linux/energy_model.h>
 #include <linux/mmap_lock.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/jiffies.h>
 #include <linux/mm_api.h>
 #include <linux/highmem.h>
diff --git a/mm/vma_internal.h b/mm/vma_internal.h
index 4d300e7bbaf4..4f73f0a4db79 100644
--- a/mm/vma_internal.h
+++ b/mm/vma_internal.h
@@ -18,7 +18,6 @@
 #include <linux/fs.h>
 #include <linux/huge_mm.h>
 #include <linux/hugetlb.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/kernel.h>
 #include <linux/ksm.h>
 #include <linux/khugepaged.h>

-- 
2.55.0


