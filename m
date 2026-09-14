Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD36C88E78
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80C786B00B0; Mon, 14 Sep 2026 11:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD436B00B1; Mon, 14 Sep 2026 11:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636866B00B2; Mon, 14 Sep 2026 11:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 392F96B00B0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:03:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66CD312019D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:03:12 +0000 (UTC)
X-FDA: 85212685824.17.C9D0A49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8340940012
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:03:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lPD9gr6x;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIglkKIN3/W3qByFkLNG0bBOvws5ewzjysWBscsc5Hk=;
	b=VpPbRRXRFLhsfSM0b+DW0Dxfxh0i2s7GkOeIbyNartoQwsle9uExXdIk5gyAxqxxfbUYuU
	DXRJpadc3P2L2CvaA0NCi2B+FOLUd7n8UDk8l6Tg8SngtSzQxKgg1ArsWHDvO4ODUeFQTX
	SC/XPaFKduFIR1OUlJmsXj3BREkbirs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lPD9gr6x;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398190;
	b=dj966OJ7svdv8O/wFhddmug9NOmoYr/HYR91VhurHhIDtvU+FGWBdHNVEV++JBnxhfTX6o
	tSbPcmKVTClFLVjrDaWeqBBS5qgxj+JC//g+lrv84HNP74S3dGz4DQqTQC7W3HrapECymb
	50Ee5q34sL4DkdpDpQFAEvj5zqEoM6A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E4E9860252;
	Mon, 14 Sep 2026 15:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936841F00893;
	Mon, 14 Sep 2026 15:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398189;
	bh=dIglkKIN3/W3qByFkLNG0bBOvws5ewzjysWBscsc5Hk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lPD9gr6x3UMX0UN1vV291JL3OZaZshRC1NwUhZmw/mMNefV6y+atGM5mjggFSf5mO
	 sPHAAfn8fXkFUrLMBdHi3LxbDJX8VQrg8zLAeehpP3Noi3scH1mCNMq391jWrGhPNZ
	 4lFUyIMXKK1i2Ng7o4HG2+P9TSMlXGYFNUpgACzx1SshXx+0dl3dtlvtnAjAOu6Ony
	 1PNw/EpTBu9/DWr7T8qNne5LEJzkMvftVxRJ7W65WXDXlwaIvVwCHrwF78ZZicGH6d
	 xZArejpZ5SOtZBL+IYbTqkDEjNrmCsh5UhFhqpF+uQfhsFhnDy6KTh0MG6e7+Wsfqi
	 XflhGt9q+Rsfg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:28 +0100
Subject: [PATCH v2 08/40] mm: add mmap action for discontiguous kernel page
 mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-8-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12992; i=ljs@kernel.org;
 h=from:subject:message-id; bh=KTopW2/sxfulwf59WpGpEZd8vJ7w9dPdvS81FaJO3IY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK872izbIBZ4ZdJMQT5Vsb8PGZZLLMnh8zDsnmf4r
 Wqhg7RfRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACaSVcfwzypb7MreTUf6Yypu
 h6meXNKxeKrlnLmZEZrzwoSFsyxi3zMy7JH6lHItklfqycGCZbIMDGvtGj+3Gdyrc7ktXK/eEb2
 HFQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8340940012
X-Stat-Signature: fh4maeeugq7e9js6hjtffrod9bcx51su
X-Rspam-User: 
X-HE-Tag: 1789398190-379098
X-HE-Meta: U2FsdGVkX18lD1zPnlIbXWgCSzBZf3Cg+AUiFpjT8Z6x6PhBtlY84/pDwBJb2DV4WM3VarGiAdSRt4oExJzMvwwY30f4CaYH0L0fqbApZEGQ4wp0+v6FXx/Vm/Ykxi69NuRJ6fZViv4YAqoURA8ViIB71IWisx64n822EwmX2J6unj3jzkkXEL8VxZLFKOdbO6ScBqEG7ZjzKAtI1hGVrJv8eW1kTf4fVFZox9QHz9t7LYuB+HILtmn8Nd3FYtGE11ncO1NpeMYnGCt1SbEPvOcqM9naNYmXRKtHc67Ycbhi5wGd1KMz4X2NQFnjIzSYUTF3yUlN0MmFjJvZaPdk4y0Ti+3OQNcj1uUeBXUcDYa3+3V4O3eYYLj095Fxb5qlyZfxRq7OWfYH7Rt3yzZN6GUYzLIBs2T1wOd5VVaKIioO0aNUijH96obwR4VwIdZNm0/jJMZl0Ow8sbSVl8AJAYkQVtlcscJlOwwrD6Kse3m897c3iVa9FUGYxyFFnycUVLE8vaSe3fcvnOx65eSs6fbX53mkBNTn2Qhm8WHkT/AINkeCQa2d7yw1ZTTV6SaXeWi/R4y3Gkjzdh1iiTJ8UWXrFgvUoI5CAwbZiGEODWMXnQGm5Wt+TebUddJpMYP/vP6I5Ql/J2pqboyMYo6E1PK9u8fTTw57GAfSw5F9jTHM9vT3G9BfZpY43FMebXhOYnkB3TdeikvqWkQJLwqaA2GQBgocT1/geQ3W+FWwPzz/lFpFUo4XA6wKMjNTaaCQXeKjcgMbEPIxrG16JN3YKLw0HcDhmHgE0PtzMUBUPChgVKn+I5zGHKs/YuOG3YIt5k/ldE6QdGvEHFoZaKM6irAPLjIEvlLGRsqwQ9/BlOyaTqOCXjq/pyKQFjgrpUlMCj7R+3x1WZk9dIgChSfLQT6NlqZVHKzXM5hCAMBLPFKlL+BRPG3JLah/fDOlahTjEzvwQ+CdFeze/j8hiak
 d53XffBt
 GiXHAnGYg4MrBCqtf93oa7BpbI6Y4OFSIdhq47jhobfI1xzw30+qqyn+QUdb430Z+h/49QkzRDo1YZpAD++kvvRECYCvvwd8aadxPglqmLDobFHwzMRviSuwO4yko0u6xt6Qztv5g3eAlKDB/GmxuryZkRk9nj9TWL7It7L1zFL1pZMi0XJd35LPGvd20ezFS9gkjBubczf45Oym2GuVr0zLC9NYce7lH5PPf5t94wPtRpE+yfaMzJDAcOt1jAE+v6HNGG5QILVa/FejCbZGtYpTcb1JeXA1JNii52tuCke/Yiolc/plCOe+6oenKCUdVQ1XBTlFIwWv4bZ1lT+JQpz3E6iJ+IOqGlMqEd6IGo1Dl88Lf1eEEfFeMrxPOE6raJI6QkHocWOiGz5HXTgvNUJv8/vfWAGmUoHkeTgxhZKhB/WCYK1YK8ufRVqrx919TzyLerkcaHN3GuqxkCZEQx2C1dkj+NhSbNP0XeRtwgBycZ+FA3wYlFnuX0/b6nCN2Fep3xiRoif98QzuyiE9Ij/RaYsAzXmC4cll8G/PVSJ8jPy+wvIKDanpMKYshIo9pc8WWsXQoqaWVL+1ct4id5gy71vvmrWQ+6c5IH6g2Q/JsmQBTSPQ90ssZAOOVOvlOek0IHno/Kg0I5J00kLwNTHVA8fTwtAIhy5psWXQszRBsaN/u/YaIa0wjohjXzDIaLfYifQJOmKkuHAjmLxrHKMBwfJe7WHTBMQ/1UYf18fMwPR1Ndfyc11p7DujxQExjwuo20gRupcwBVNhGDm/dV0TpzECKGzOpFD7SiSw5jGfaEGIoDxnMCiinTlAt2s8bAOMHukta6Pcu5MzbgsuSrCCcOmr9LQjGD7ivI43d/A/PDXfRfnfbk3ECLf64BGsOuZBwz1ooToGCdxTDVw+lBFV7N/VauvfK+gzh62dTVnFi2kDltKedKn/NLC8F2gUzmuFmNQupM9esiLtbDHFkNzowpDQs
 YBErE5Qj
 1kdDE5tlTp92rl1UozjWKqjXF39C7DexmQ4jOMVPonbIPqZWnSqCfW+XJ3xWADGYDNZ9ZMY1BrKLQbCdL6VwXvPCAQRtRsrIcDLeNcNyaDiYXFUOavGsuR0YuebtuGSwocr+LiOuXrAItIyxlzSDONFsYKMq2f+V37Trj+34mL2O/iZtzgodi3yrSNjAzc0eZjR4BKeoF0Jio/96pb8QsukjEPk1QW7jOCv8XTjnxb0LngdAi6NJqAa6tmTvRMFb0LGtUyaZZl6FtMsokhjzIMACHIka70/62Flkak2qIziTo8nVF5AafwIW54W5bM+LqGMzUd6B/oqej2V6fhNXi/kJCZyzlsqtPPd5IwqA78kAkleYz5eW5t1rKUs+m0z/0N/hO2YjHRFe6ihmRjkozXB39JmF4hTwmkFReqMHS+XC0hls/wN/Q0n4z4JwcKsYM/0n6pQTUgqWgdtzH6vr1r8iR6IzoxFSmkU6YitvegG9XpGz+SdQeI9UiD6XqOYnZeFWLAanrv3zF9FWIwVHEXyVDWa4kGPWdiMqwSAWdRiPlxYe1uJBjswQpxzec02GcNSqKPs4TgYne9t6DR8KIPkbZ2IOE+rXsZp2pPv5a0AFAjOrmuUj2XJ8W1t5eO+1bwIz6/w6G02e8kUCvyslt7Bf1eV2fAmlCUj0Xl0Uhs6NzHWW7VDZE3E2Vct72NfSAi0twKhbqT9xhbvdgkZOnzKmanzFFvrTyYqTxS0B7RWSUWV+0sAJjQ5fTw8M8mGD8FNXYvCZYTi7vd6sCBYEq4SXHhZl1dMSU9GgIAPleMUB+0PBU9ah+jE9bvBT/v2cLiXl7T6MCOMWWcWL4IvGMA9WHG765aLdsbqiVffUI8Q3MwUPZGsOiTvBFrO3YaQSBhL3OShvh0KfnZF2WGzTc3DoPc968IdGecQTR7Jbn9TNmk1CRgUPp/js3TJCb7n24q2ewaj5M73QyCztsKz/R+5crmi9/
 Fr69+QKf
 cPP2dCepnHkI6ofoYDKPBbSIFftVpBX1/oISUmsklLSnnbCX1PlvpxShYl8WLiOMhLfXTXccU71+3bjnIh+WCfgh/WxGBoH1VJHNTqvhTwD0kO6OeAfxEdQrGnLf1kzNGKo/eG40xDQi7uUsHBGLeVhd6TD7WEZeKYF4pHRQIMhmbVRJaURUcNN2nH4OIxiBKl0FDhYimSi+7bVEtHKWJ7CTdDqc964X3F43BXbVbT5wterLWklMbklq4VscCKJMJwkCbWals5qlhUzswSkqFA9Z/Bnt6WyrNya5Wd+0Ff9zdDrz73pPG/+kaB4vvLCEibD+I+8Dbm5NqdlCpcEDEo59SPeGL2ktwubGkJmNK33/BIDmces/oLFOZJGIE9Kna36/KXAUJrCTpxXFGgf6DXvDkkakj6HRtCfbwCQoKxs0Vcknx2+LppUrRUMSqK2kXnrVhGPlX3uYMW4eusfEsGZ2pWyNeGUZwNezBJ8pxn6nzp/Uxz29mzhX0v07ZSYs7i35rWp64umQQvbAQetfHHuqKxQgrTF3q3g5C3RnAQoYBe14yaIjtQ687nPc+sAFDGGrGo8IoRmYPOaxoEYV7hBbOyS4R2EEP9ft/PmaRaQAlN8wUBO1D8vxTDu+8akipPIbS+Z0hk9gUIQETiz2AMgfRURmRWUnTkXsuW6rL1I9787sHzuAP7sI/nJrSVEiwwmxtvinPM5bHSOtnidnsikWn9TdTBismJ5c/B7zIZywQj0IsU41VNA7PwdoILl6aIjvw4r4X/dEgPvMVOW6NKsQzEp8B1zr+oJnYAwoKsSf5ZwxtT2jOYWUszKfiFGA6Ykujj55Pu/vtXJnyJfgCKapaODly0UMN6OzEYWsos0fJGpzWJdq/GYoCDGkcx+lH/tupEw6KIPXdUCoh0zRDzrNXl9ftrW4slT+ualHMjxe8E2QrfmxdgJ9mCrut89J5dwox+fLlQlP3naUF8EuQWBgYV8CZ
 XbD3PLu9
 YfDG7DpJATvVr0KLOO7A00mGSlPshzHbi58Cii2wubSi/G5GISG0nvfHWHXymPsNsYkbHAC8xLOPoQM/WU3VJ6lbKXAwzuWg+4T/AXgmpBimOQFnfVUKrWs4CZ16dPI1ymmoGPGrelBKcTnm4CV/TAfC2fJq9Gf78mtYc1roK5weUaaIoVbHMRU4MsTBwOql/vKm+BX0nz5RSG6vBVRLiEbzPEpxQkkwYe6X0qe761JICw8pDI7huEo+iDBVCtJXWbh7DbQ4G4zd/S8yPaAN3FDHXkOLRcnXU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing kernel page mapping mmap actions allow for partial and full
mapping of an array of struct page pointers.

However some drivers require the mapping of discontiguous ranges. Permit
this by providing discontig_kernel_page_ops which allows a driver to
specify how the operation should begin and how batches of pages should be
retrieved.

It uses the minimum exposed interface to do so, providing address, page
offset and both vm_private_data state and a local private state object.

ops->init can establish state for the operation, and ops->get outputs the
pages to map and their count. Should an error arise the core unmaps the
VMA, invoking vm_ops->close, which is therefore where any state established
by ops->init is released.

Batches may not exceed the VMA, but may map less than its full range in
case the driver wishes to allow the user to map an area larger than the
available data.

To use it, users invoke mmap_action_map_discontig_kernel_pages() with
initial local private state and a set of operations.

Users can then use one of the provided helper functions to perform an
action:

* discontig_kernel_map_abort() - Abort and leave the mapping as it has
  been accumulated so far.
* discontig_kernel_map_page() - Map a single page, or a compound page given
  its head page.
* discontig_kernel_map_page_range() - Maps a struct page ** array of a
  specified count.

The userland VMA tests are updated accordingly.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  45 +++++++++++++++++
 include/linux/mm_types.h        |  44 +++++++++++++++-
 mm/internal.h                   |   3 ++
 mm/memory.c                     | 108 ++++++++++++++++++++++++++++++++++++++--
 mm/util.c                       |   7 +++
 tools/testing/vma/include/dup.h |  11 +++-
 6 files changed, 209 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a1f2d375cf7d..2a92193ac6a5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4647,10 +4647,55 @@ static inline void mmap_action_map_kernel_pages_full(struct vm_area_desc *desc,
 				     vma_desc_pages(desc));
 }
 
+static inline
+void mmap_action_map_discontig_kernel_pages(struct vm_area_desc *desc,
+		void *init_private, const struct discontig_kernel_page_ops *ops)
+{
+	struct mmap_action *action = &desc->action;
+
+	action->type = MMAP_DISCONTIG_KERNEL_PAGES;
+	action->map_kernel_discontig.init_private = init_private;
+	action->map_kernel_discontig.ops = ops;
+}
+
 int mmap_action_prepare(struct vm_area_desc *desc);
 int mmap_action_complete(struct vm_area_struct *vma,
 			 struct mmap_action *action, bool is_compat);
 
+static inline void
+discontig_kernel_map_abort(struct discontig_kernel_page_state *state)
+{
+	state->action = DISCONTIG_KERNEL_PAGE_ABORT;
+}
+
+static inline void
+discontig_kernel_map_page(struct discontig_kernel_page_state *state,
+			  struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	if (folio_test_large(folio)) {
+		VM_WARN_ON_ONCE(page != folio_page(folio, 0));
+		state->action = DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE;
+		state->__folio = folio;
+		state->__nr_pages = min(state->nr_pages_remain,
+					folio_nr_pages(folio));
+	} else {
+		state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE;
+		state->__page = page;
+		state->__nr_pages = 1;
+	}
+}
+
+static inline void
+discontig_kernel_map_page_range(struct discontig_kernel_page_state *state,
+				struct page **page_arr, unsigned long nr_pages)
+{
+	state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE;
+	state->__page_arr = page_arr;
+	state->__nr_pages = nr_pages;
+}
+
 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
 static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
 				unsigned long vm_start, unsigned long vm_end)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 9ca2ea3664bc..0cb4f9603956 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -818,8 +818,44 @@ enum mmap_action_type {
 	MMAP_NOTHING,
 	MMAP_REMAP_PFN,
 	MMAP_IO_REMAP_PFN,
-	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
+	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
+	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
+};
+
+enum discontig_kernel_page_action {
+	DISCONTIG_KERNEL_PAGE_ABORT,
+	DISCONTIG_KERNEL_PAGE_MAP_PAGE,
+	DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE,
+	DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE,
+};
+
+struct discontig_kernel_page_state {
+	/* Map state. */
+	const unsigned long start;	/* Start address of VMA. */
+	const unsigned long end;	/* End address of VMA. */
+	unsigned long addr;		/* The current address to be mapped. */
+	pgoff_t pgoff;			/* The current pgoff to be mapped. */
+	unsigned long nr_pages_mapped;	/* The number of pages mapped. */
+	unsigned long nr_pages_remain;	/* The number of pages remaining. */
+
+	/* User-defined state. */
+	void *vm_private_data;		/* VMA private data. */
+	void *private;			/* Mapping private data. */
+
+	/* Users should not touch these, use discontig_kernel_map_*() helpers. */
+	enum discontig_kernel_page_action action;
+	union {
+		struct page *__page;
+		struct folio *__folio;
+		struct page **__page_arr;
+	};
+	unsigned long __nr_pages;
+};
+
+struct discontig_kernel_page_ops {
+	int (*init)(void *vm_private_data, void **private);
+	int (*get)(struct discontig_kernel_page_state *state);
 };
 
 /*
@@ -844,6 +880,10 @@ struct mmap_action {
 			unsigned long nr_pages;
 			pgoff_t pgoff;
 		} map_kernel;
+		struct {
+			void *init_private;
+			const struct discontig_kernel_page_ops *ops;
+		} map_kernel_discontig;
 	};
 	enum mmap_action_type type;
 
diff --git a/mm/internal.h b/mm/internal.h
index 0cd26277a4c8..3a395e8c224c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1514,6 +1514,9 @@ int simple_ioremap_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_complete(struct vm_area_struct *vma,
 			      struct mmap_action *action);
+int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
+					struct mmap_action *action);
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 448342883e9d..42f084517247 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2609,17 +2609,23 @@ int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_pages);
 
+static void __map_kernel_pages_prepare(struct vm_area_desc *desc)
+{
+	if (vma_desc_test(desc, VMA_MIXEDMAP_BIT))
+		return;
+
+	VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
+	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
+	vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
+}
+
 int map_kernel_pages_prepare(struct vm_area_desc *desc)
 {
 	const struct mmap_action *action = &desc->action;
 	const unsigned long addr = action->map_kernel.start;
 	unsigned long nr_pages, end;
 
-	if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
-		VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
-		VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
-		vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
-	}
+	__map_kernel_pages_prepare(desc);
 
 	nr_pages = action->map_kernel.nr_pages;
 	end = addr + PAGE_SIZE * nr_pages;
@@ -2640,6 +2646,98 @@ int map_kernel_pages_complete(struct vm_area_struct *vma,
 			    &nr_pages, vma->vm_page_prot);
 }
 
+int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc)
+{
+	const struct mmap_action *action = &desc->action;
+	const struct discontig_kernel_page_ops *ops =
+		action->map_kernel_discontig.ops;
+
+	/* At minimum need to be able to get pages. */
+	if (WARN_ON_ONCE(!ops->get))
+		return -EINVAL;
+
+	__map_kernel_pages_prepare(desc);
+	return 0;
+}
+
+static int apply_discontig_action(struct vm_area_struct *vma,
+				  struct discontig_kernel_page_state *state)
+{
+	unsigned long nr_pages = state->__nr_pages;
+	unsigned long addr = state->addr;
+	unsigned long i;
+
+	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE)
+		return insert_page(vma, addr, state->__page,
+				   vma->vm_page_prot, /*mkwrite=*/false);
+	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE)
+		return insert_pages(vma, addr, state->__page_arr,
+				    &nr_pages, vma->vm_page_prot);
+
+	/* Compound folio - have to iterate through each page. */
+	for (i = 0; i < nr_pages; i++, addr += PAGE_SIZE) {
+		struct page *page = folio_page(state->__folio, i);
+		int err;
+
+		err = insert_page(vma, addr, page, vma->vm_page_prot,
+				  /*mkwrite=*/false);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
+					struct mmap_action *action)
+{
+	const struct discontig_kernel_page_ops *ops =
+		action->map_kernel_discontig.ops;
+	struct discontig_kernel_page_state state = {
+		.start = vma->vm_start,
+		.end = vma->vm_end,
+		.addr = vma->vm_start,
+		.pgoff = vma->vm_pgoff,
+		.nr_pages_mapped = 0,
+		.nr_pages_remain = vma_pages(vma),
+		.vm_private_data = vma->vm_private_data,
+		.private = action->map_kernel_discontig.init_private,
+	};
+	int err = 0;
+
+	if (ops->init)
+		err = ops->init(vma->vm_private_data, &state.private);
+	if (err)
+		return err;
+
+	do {
+		unsigned long end, pgoff_end;
+		unsigned long nr_pages;
+
+		/* Default to abort. */
+		state.action = DISCONTIG_KERNEL_PAGE_ABORT;
+		err = ops->get(&state);
+		if (err || state.action == DISCONTIG_KERNEL_PAGE_ABORT)
+			return err;
+		nr_pages = state.__nr_pages;
+
+		if (!nr_pages || nr_pages > state.nr_pages_remain)
+			return -EINVAL;
+		end = state.addr + PAGE_SIZE * nr_pages;
+		pgoff_end = state.pgoff + nr_pages;
+
+		err = apply_discontig_action(vma, &state);
+		if (err)
+			return err;
+
+		state.addr = end;
+		state.pgoff = pgoff_end;
+		state.nr_pages_mapped += nr_pages;
+		state.nr_pages_remain -= nr_pages;
+	} while (state.addr < vma->vm_end);
+
+	return 0;
+}
+
 /**
  * vm_insert_page - insert single page into user vma
  * @vma: user vma to map to
diff --git a/mm/util.c b/mm/util.c
index 438170490e7f..c5ee52aede1e 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1469,6 +1469,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return simple_ioremap_prepare(desc);
 	case MMAP_KERNEL_PAGES:
 		return map_kernel_pages_prepare(desc);
+	case MMAP_DISCONTIG_KERNEL_PAGES:
+		return map_discontig_kernel_pages_prepare(desc);
 	}
 
 	WARN_ON_ONCE(1);
@@ -1501,6 +1503,9 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
+	case MMAP_DISCONTIG_KERNEL_PAGES:
+		err = map_discontig_kernel_pages_complete(vma, action);
+		break;
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 		/* Should have been delegated. */
@@ -1522,6 +1527,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
+	case MMAP_DISCONTIG_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1543,6 +1549,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
+	case MMAP_DISCONTIG_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 1098655a5f4a..1d5f6b3cbd21 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -457,14 +457,17 @@ enum mmap_action_type {
 	MMAP_NOTHING,
 	MMAP_REMAP_PFN,
 	MMAP_IO_REMAP_PFN,
-	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
+	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
+	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
 };
 
 /*
  * Describes an action an mmap_prepare hook can instruct to be taken to complete
  * the mapping of a VMA. Specified in vm_area_desc.
  */
+struct discontig_kernel_page_ops;
+
 struct mmap_action {
 	union {
 		struct {
@@ -483,6 +486,10 @@ struct mmap_action {
 			unsigned long nr_pages;
 			pgoff_t pgoff;
 		} map_kernel;
+		struct {
+			void *init_private;
+			const struct discontig_kernel_page_ops *ops;
+		} map_kernel_discontig;
 	};
 	enum mmap_action_type type;
 

-- 
2.55.0


