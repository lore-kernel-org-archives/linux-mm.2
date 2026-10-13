Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7523CC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23C46B00E3; Tue, 13 Oct 2026 11:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB566B00E4; Tue, 13 Oct 2026 11:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA6E6B00E5; Tue, 13 Oct 2026 11:26:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 73A586B00E3
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:26:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F274E120CD4
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:26:31 +0000 (UTC)
X-FDA: 85317979782.16.A202A10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2595F8000F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:26:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gzoVtO52;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905190;
	b=io1/oS55REaK2WcJQk/n//iGx4wegMgJKfzAkGKpP2tt3B84R/iVWyCy4YT0Og3t3C5bWZ
	QFXgqAs4vRdnftZNxrv7kOm6Y2Pe41soQgZv53cmRZGrYLJtAwjELzXN/VT0ZvbTwODGzT
	T7N0C57ol0ahTBCux/VDUHA1RsxFf2k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gzoVtO52;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfKSMRwRrChtZv71omqSFoDEDYkiNTw1yN9Lgs5eSEE=;
	b=bD8Okd+98QQhEl+YCKiSjuK7tpCzyePJmTIxzOutY0f/jk5XXO+DiHzTs5CJQdt+CDHOtT
	W52shr00UbWx/PqoAX6PM6dvuAXr57KEB5bFYT9SXAKJN7PNCvCZxrqGZg8LKg8or3Z9bq
	EmlgGxRU+HhQYv7BqXDQr4E5mqszluU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D5FF602C3;
	Tue, 13 Oct 2026 15:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352C01F00898;
	Tue, 13 Oct 2026 15:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905189;
	bh=nfKSMRwRrChtZv71omqSFoDEDYkiNTw1yN9Lgs5eSEE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gzoVtO52IG+v86EDCc9jjOK3ZpyQBLgQ9SYi/8AD6nkY9wIx8jQmki+yLKtgjBefO
	 yJWHmOB+Mekm/VGHZ9nnA05ls9ev7L44EbxduL65MdSZSTnPwHKr/hfI7gSGNhNGHL
	 dVWag5TMkpMdZ4TnBr3J/Mu6YUFS3uDJVRZQ77DjRfAnx32erFNZHQD8Yz3fBM2hdU
	 4i1KNcV2aEyIFQyVT+tLjYtIohswMekiLIWDZyzbQj4DeNWVNtmXhqWYYnYPkWy+vA
	 hidJm7k9V9fsX6GO/x2/nbVceUTLmQqgesa/Dr80xOWh0aBkVUToE44HNof7ZBecOx
	 Oah6TpmSUjMJA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:19 +0100
Subject: [PATCH v6 39/39] mm/huge_memory: remove vma_is_special_huge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-39-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2971; i=ljs@kernel.org;
 h=from:subject:message-id; bh=CGEMQnlTOf3HSf1ca7HiwGzo5wiBm5vCkfKiV5simqA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZxl2b3ax4T7qoBdSue0lL9XZm16LWSy5eScJ1OF2
 Z6d+PxHpaOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATWcDI8Fdueo/Ct6LuhT+3
 TbXrnGSrbPfOMz7Jbl638orMw0uF73EwMtzc/T+yK+jjSxlX+ZNzNintWmS86dwlwScFPFceXf0
 7YQYzAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: yjmk6j5qrcmmnnz8n7ip9bkwka7wub3r
X-Rspamd-Queue-Id: 2595F8000F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791905189-401238
X-HE-Meta: U2FsdGVkX19Kezek8kcNRAEp+iyDj6k3bARuJi6vq0lwrnZKNo1VfJfWYwvm4UunF5k0gyUYHNsU+DaBCbd+jzzpKe80jaUaIgV24n+20jMVWhCWdDN2ovMpEwSaEHJEZ4GPicjcPdZCiPEL1yeqYFeKBrSsWtz3hilSlFX+ZiDdj05rgzqJIR3YetcCM0DOeq5Kw0Ciq+YdFI7mQhY8gQlL4I3JJUbGPbInjl/OILy4xAznpaQ33aA81xpx9l9J0MS7dXkQg6TG8tbIsyFeb/vWH40lxb3OLUjx/Y+bK2tJdWt3pH1+vk85y66s0ZnCyiuMgj+XrbG8PElh9PaNus+y86uQS9Zeel6QkkSY8r+j34gi3LcvFSwH85sb/ZXS0L5Szx/c95z7cLmgiQmFs/UVQil+uNaD+eTlTVApQ+wP+iXXJK8ty1EIVJ3JfnMaqVtjRJ3YxmUGjwJphuAh64U+QsdjjcWO7hKW+WIqglSYrGws0vYn5Ow6KQe/jH5ozlHS7H7qr7h9ZSbgDbQr5ORubJgl3v781uCJtdqzlXUB5rRE7MXzgeQXQVWc0dKvP7Y+1mRk/+t6WycIaB9ApPlNleiWTjOZrvaJMgYIxzhSmOxa2FmmlnhVVUcaE9jCqssn5mJA5hU4SBLnE57dbzUtSjtIm2oUiOj/aW52Q5osvrHa9t5UqyLR/oGh14ZpErsohSiMReVphyG9wpHozd0DoKeGl/iSxwGBJWV6qi0wc47TpLvC9zL2BzYWDPiv/GpIsU9y+iURykKkckueSjIvNWuAfEnApZ2i8MRcqpNSbEhsxxcxhyr/eL3/BlgzZZ0MCuJYvLZHRweYfDtXvLiKbGaI6IbrMJ9PpeGs1C7mFQ45GP0PxGsaWoRgqolkVQbzuJrNKfXz9ZLJ3c5Z+k06omm1UMttPgOQchDVELHigdVTkLjcfuhSiI+FG2H5/wP4Mh32Qf2veIcIR+j
 MlmGJnWR
 wAGZIIC9b1gVNQVyjfDfdXiBUa9co5b6SGyalWxe92yKVjnAC+GOU8qyUc4JrL6WsqDKihWI7E0yk0lWsyyckiUW5MHZbwqW7d2xuiUlEbwHcH3LPC5bfSUYIMKCAPmk0VUEZXo7aOfCnZxdMQD46fGFX4GKuboK5USWpyhpIDQxtZtUNIQr/z9Dr38Y9uITGK7gGsWGmnIOzNUVZnuO/DX4Ocsvx57fIRnkKLtcunltwUdbjeeoly91bSH1pYWebd6zH+aNFQ2aUMAoGIF5xDaGlGlegSPorFHAeqI62bFI/z2lxRhhVwIJj0QxTJv0EX2EFbhSaj/bhEAJ6eERdv4mfvjtDHNb2zYcG/9mZeYR78P+8ByZvin2U7O/KuZJFI13OREZADaIeRc7RswP4pbG4eQaC4prW0W1epmirJpn+9KefjAs0DMn+Z9zFdZDH+uEXiNNgoZexgI7lnNJR7z6CZyr5FHJ/O2hK8YkQtfAlosQC7wNgi3cvcbWGEXTICSrVQesOKXL7vQjwNP4n1+Saun1CnAdfXHtXH6a9Gr6+d4ndPIxpnK3/djBxBIao/oBVROlzowW55b+DUkUSmA4+i8NahgM7RJWSz0BxSLeeAGU+I55YwRHn8eDndTjPDfUSStyTal3HeYpApxEatnINRLCr3rt1738zXKp8+onyZUE0dKaoBJlJbQb8Y8i8eTSmkS1pNqsTtnr2qWUHdBOxpq1J/4DUogafXbo1oHXKEzNYTwId8apmO8cHZ8xz5ZsuCSmv4AwCS6sZcm0dIDuKj/GRxj8tO2h2jB7oF1cWvpY1KrNQqIeI8dYHg1x80yBeGuZe2Gcb0I2aw8yCZuEM3kHPAGqKi3f4F41LOoxreQLKQ46WC1lVgQJYRu+vkS2puFjfaRL4n2oZRma8FcxKuBoHUacQk/xGFP8CnS1o01YrlpOo4pIIm9zGe34ntHTcWS/+JsOzZeO4zHZhMJhyf/4f
 nCsUgZiO
 Q4MDpfHkreVt4Oh8ahwtRoEXbuPIMJOqDXtTotpKjUHoACqH8j2uzTgXnV/s3DVA8iUzsBofjYK4zaD2hVmxJY4I5pkhbUxHtD5FXqua3924pIi9oh+wQanuLVMnZSo2TP5zCDf1gIElQbknwHmJ162mkHQnBK+UbHrOwfuhzcRFgjmEoBN2QugrqmOpEhyagBicd2QZKLxMPl0fPgGDTsaXa1JctrloCfrpXsp6aZV2iWElpuOVF8w1h1W8Kw1at87re4ixejlX2VZQxz5qLYk2oNI/KuqRXUyP2Twd/EXmiKPNv5Z2T0wKuGFNaJ1W+qcz710n4HZrlm5USEQDuVtCmh6Fo5SegVH6zRqlCT4j7uIwc1REMDSw7HX1Vf+ZU5sKBCVLGNLHQS0g1AlHHA8SbSxyxuH8as3CTIla6UkR5UJHCV9YtoLAufrZvrKjavBaPWEsIB2DW+kacjW8ONfk+op7QSiZK38vn51KoRKNr/5FB+dMw1W58sZ7/DyGzue7MaxjrEQClzPYaGBLhGnpM2hUWDf7RsgIyE8xVKiRrmmvatu02FYv+0biaxwNJ6Mj9ZeWyZ7kfTDOt5uiCAvbDy/SNEb1bi7JYdUNTEbOxfaUVdfvP9SENchyin5pt7b3LnKk2jVV+Bgr2mkNlTumwjggeZiWaugRiVTxYqGyeJevjX3zr2Lr9Kwfjsw/bPxZUizkV/kQJ9ebGDxP/bmeVQCeWC0ZxrnzVyMjhehTZzQkiwRwvV+MfOXYGx92+NRzYz4YQDqM901RWgW5f24xrldjwaJj5dEEfURNBDaajCpdxCQPkKfPmVAWpL7f19X7QkQrCC5rI0F7gN38U6/SAkwLqtlOMCZd288hWu5CQVCT5RSnX40ZnaZrptldtJTzt5XFy1lNCBh9jh9g3HDPa9nLQRsjXVQGIY9A27ptnirMERnY1fT2yopjE6nvShAYBo+SUn+T1vNubLZeBpIkb3JqJ
 FXsbxs3L
 wxvh2XX3qu25gEElF8ZRZ+a2w48mezVt5ka28pD3PaZcTcbUw1uR0Vm7Z9e8haUZ+WHbYe9ULSil3BInKvxKW8Z82dldkoaSLBM6ymez/T/qWigbZ1lBR8iPJuZ+V/I3sQoOX5/7652lvf7GSwDD+ZtXpeKWVFZTpsnbe62cbeu5ptTvPeyUEWxdqIuFab861v7XioaT+me2URZ3gYsfy0t1KSNHD1hFEWQ6GxLqn6qkXhfF0pO7M1H1hjkSOgOVBM0aMHZMH0W0D/UNuuf6DL7D9jt1dv5Ao1FpbZ9+jX1kRVMgNaN7Mpkn7+yc1c4dlvMRtqP7FBDkIIAqwDfJ+k9hznBsP1iW/FkWGx0d6/tHkalceTz5urklJ3Vmz9wvheTgINp/Zt9T3Zm9ipC5DuTwhZIPIURhoTJYaUvE5dyb6B96XJQxG9pktaDUj1M00OVuOIK2XLbJi6S/1li5fbyPNEx1QA/upAEgSdLg76dj8pqKrMeKTHb+N3aH63KftjSRezAhq+AkMRXfRNJ42WaoQeO9BB9gORX8LV6QIwFMvnFSHmsKWpUBK3hyOgNUnen5MR0kAA3mzzJ7JwSGpRp5CwTEc0preN6VwcSybE/ZFOEi3CKpOjA98Ex9tri12B4T11+bb6JK1yu4IP5uKXfGKh6UhN31WmzE7EcWc9Go6QE0XyQ7H4g12kBItM+WFKlRemVYdDPyhXrrK4Zejt6kjUs0Tn5ld3NzKEBQgcXO3yHaVWnkRnOGEZV6Nx1G7MQZDdNNno+grbapcs7UnlFmQpOp+XyoYN0pGAzpRDoZIHW/VskTm+NfbACPDaS2V1gU8LL/MNpVAeGBbK7ZbpSBFq2LjJrlQYegHA11u+XZEZmGDjTLH469UbvZxKQR5zYGNz3XVVPUcyH3O4wJXcaNcHUz/7BrYBeKV4BdNCSNQUtSKDgZZhg0ettQqPfn2h30IqMwivU4p4LsSEkYpB9XqHF8t
 c5U7ZuYJ
 0B0FSxIL2WvoV+AeJ6p+NX35302GaI1w7HSaRrOmW6UjuTdvHgW9g7FgwErgW3X6M1YrVDMUosHrdilPLaca8GD4BxPvJOSm7Xjlc+Oc1puSOs3OMN+CbeDjtLWFzUjF3r2HXesF7ov12f1RWO/9XM+heQ+7BCmEgV+ydJJVhoRbXI6QvC1puGxVU+JB1b2i0aMSjmkqpWE5pBqnzJwT6Y/tIYOMfMInczrru0yWJXLzoEjgNbgBjkoeMTKQH/9VcTpVTZwzsZ6YHS6zHbFcLenFy4KK4+W2h7X0BJ6QwBLssY5ovpr6ykwltTjz4cFZY+dGp4oA6kuuBRkSYN224fEvtEyzmCNHg80dL0haGBww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is not mm-managed),
but with a DAX carve-out.

DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no longer
required.

Therefore test for !vma_is_mm_managed() instead and also drop the
VMA_IO_BIT check, as it is now redundant since it is enforced that
mm-managed mappings may not set VMA_IO_BIT.

This also eliminates another overloaded use of 'special' within mm.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5b295a7979cd..73575145db7c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -110,14 +110,6 @@ static inline bool file_thp_enabled(const struct vm_area_struct *vma)
 	return S_ISREG(inode->i_mode);
 }
 
-/* If returns true, we are unable to access the VMA's folios. */
-static bool vma_is_special_huge(const struct vm_area_struct *vma)
-{
-	if (vma_is_dax(vma))
-		return false;
-	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
-}
-
 static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
 		enum tva_type type)
 {
@@ -192,7 +184,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	/* Check the intersection of requested and supported orders. */
 	if (vma_is_anonymous(vma))
 		supported_orders = THP_ORDERS_ALL_ANON;
-	else if (vma_is_dax(vma) || vma_is_special_huge(vma))
+	else if (vma_is_dax(vma) || !vma_is_mm_managed(vma))
 		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
@@ -3065,7 +3057,7 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
-	if (vma_is_special_huge(vma)) {
+	if (!vma_is_mm_managed(vma)) {
 		spin_unlock(ptl);
 		/* No zero page support yet */
 	} else {
@@ -3221,7 +3213,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
-		if (vma_is_special_huge(vma))
+		if (!vma_is_mm_managed(vma))
 			return;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
@@ -4764,9 +4756,7 @@ static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct *vma)
 {
 	if (vma_is_dax(vma))
 		return true;
-	if (vma_is_special_huge(vma))
-		return true;
-	if (vma_test(vma, VMA_IO_BIT))
+	if (!vma_is_mm_managed(vma))
 		return true;
 	if (vma_is_hugetlb(vma))
 		return true;

-- 
2.55.0


