Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48C3AC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5912E6B00A1; Tue,  8 Sep 2026 16:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5694D6B00A2; Tue,  8 Sep 2026 16:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458C16B00A3; Tue,  8 Sep 2026 16:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2FA6B00A1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:05:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC1C7A4C93
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:05:50 +0000 (UTC)
X-FDA: 85191675660.15.C2CEF55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C392440003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:05:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jc+25493;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788897948;
	b=M/L0t1i2imDrP9oZ3kaBysdNNEzsGM3QrzuiaF+Ar2k9hJTFs42QTpCuu1u6a8xCBR9g7D
	Chv7OJ0mXUCa1P48uwQLQ2Ks1Dxfp3rrQ08dVFr5dbFYAxEtCJPfHVNzdGYpTHGVAIUaDt
	sOhx5tDuhnco//4pYh5hacEIMZ6xaGw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jc+25493;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788897948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iscL7XQ2qz+Nzy4lBqsV3dTnKv6z1UKwiafW35/dBb4=;
	b=wZfTLWVlpmHlFs7WpsM7ihzjt4GGCC755nifIYTZyX+tpEtdSHjGuLYzx+ozW6Svg7Remd
	pZGpt9kC0+DGAuS/byYpN1f88hYm+2lepRBq2i8r1uwP0QiRS5KJpqKb1gMrJLhhv/w6UB
	Y6ErlkoIuM84Q9OPZFkJVfjclHXjv0w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DA41437F4;
	Tue,  8 Sep 2026 20:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C1F1F00A3A;
	Tue,  8 Sep 2026 20:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788897948;
	bh=iscL7XQ2qz+Nzy4lBqsV3dTnKv6z1UKwiafW35/dBb4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Jc+25493tsckTbWCOZP+Zyv7md+VlPGAmEn3On6Sc+eAYFaK+dxOenSmzWLxaAOv8
	 i3nIqz8EUF8c80uLWntZ2aH9Lokq5iMJ74K7L9SPQTDc33lfTe5MZE/3gRynv7Y9JW
	 Od6nbpeIIyAIOfstTWQdWkxXIeIQErrA+CfTpMp4DPftLLDpReZQ0x/FCFNigTagYU
	 m78Su9hMxY5pV5va1RRv8CX4QDeKU3wEGpZI797elPK/sE2gaxlEp405CEO3TbJme1
	 akL1BLZnCJhjae4iUstmbk8Shgs+1z8bevPlT8sngmYD4yFsXVXTY4rdXE3RXyOJiN
	 X4RroRrlG5uvg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:11 +0100
Subject: [PATCH 07/39] mm: add mmap action for discontiguous kernel page
 mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-7-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12539; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RVcXI/9kSHuUo8O2heRZlHSZv1OgtVQ9ABB55RKE5TI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG4U2FvyUfRZ7qrcGX7ettfbfIQWMv3c5vsl01KS+
 ZfSGYGjHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIotkM/9PrnrryT5T9JbHv
 7FUt4W8ihz56XkprWBZecM9Gab5lYT8jw/XSN3Zb3/VGtSsx1gq/ucS4tTJ3k4J33a4fkycVXNm
 RwgwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C392440003
X-Rspam-User: 
X-Stat-Signature: 88xmj4shxup4f3xu78r5ggqpz1rkk6s1
X-HE-Tag: 1788897948-491395
X-HE-Meta: U2FsdGVkX19Oc1lHDEU65M3l3ddcH9fVc30ZrNSlvo92nP6h4aCUjuzyuZsTLID6+gsoI2ZNq9MmnSQmZbJGKtiItkrd0ZLACMlsqofrhXe8Hes5y8O+Hnw5qjb3VBRUJPNEg8l/ykSESN7QTnAUDuB3KIlNzUFINl/oQjmZNvR4BQMNNzdCA+w67f6bau4NUtnIjZF/RUg9acLkIxVxq3GMut7T2tke77mb20csdlleAAgjjdcGaAAR8mw93l6FQcEhqaw1M1VEL+gRrK1/8fyodkvvCFFWE+rSdTwXlgOLktL8UCoazV7lq01zOyJ5nvZAz6LETxdC3LjR86gqfpgrFKAqZ4TXC3KcGJV/DDjyCEX8LWAe47B8OU2oemMguynfCUci4Onknurkp+YjA5ZKInmMH/uCGM24rfpoSK4xVZtl1LgSe8x3tNg5UNMWI7Tl22lK9Aeq5WXHndfLgdVlO51o6Xldpnra5KLOLYZE02TbzuDjhDQuesxQ+KtsmyF+Js9wBYU3OmBqlSzsv7HJP5sqUW/Qa7n0/BcAd4/5xNUhP3Wg4Gwjhzm9BUw85S89ch+UvGj8cQFYh5LVhIhsbPcF143aha62sK8lfKoZ/8BeMQ6AJCR9fXQ9KJf90U39zdvk+P0rZILZTZHVHWRVwOjISbfBP5dkeuvniFOgSo5sSj7vTHHi77WcB7oLCA9ryjC9mLpT+03KkeJdeRgxxEGwDojF19I9PymsDpYkeLUcCYevEpLP+5lQ5mYZIG09RbkEiyIFBH8SQxJQ/c3lp7M87yR4Frc1OgU11sIKIjUwyr4MV4cmru5h3JcXH859iQUw+cV8Oi58KfG0nre+N3i12Z73H5r2pAtvOCnwTpATZosjr/5i5mtRAM92pDSpwdnANg0AdmkCJZM9qlzlgXs2fbEi0uoimwCDjPHW8+0/6Ofr9Jjd89zeXiD5TpL/OvbKkMEz9MxRZX7
 CjtedegY
 gwpdPk3iB5om/coPlgWePB+QsH3bzMGbgby7Zdjf1KyPJKSmmh7D9hiMgsmtSj7Gb64CMmXQJdTlQc0QKEoI7l9F1a37MwgMBjyetyLSGagJRLfaTYow+UqMt581i2IlvqjrVIenUXHGcRW4ng3uaZM1Iyjk+O5Q42fbn2pVO7i1978aPfExldlSwDeY2BrWLPobezRVBR8PXa7L5NTup80uiQzd+DZ8g4qZ+Cgrf4Lp1HREVnUtODyqbz1mEmBgov+RHNfvKAsuewkbwep/XTXLfv6+B4+nrs+5iOQpjFoz3vcXUzQ737sqMITxmlTU30XuE2sk4FoBRyQu5oqJubDwNvI1Go28EZR+XsoK8QaLFbMY4zRuBYLEOkkasvTeDL2Lf+bDgY5A0YnJ8qnUt0A8wbz+i83xlDkEdwiZmnGzS4EyluhnPp6Uur03kGaepQQXhv6LMyuVg7oa9hg6Mr6lJeidWx11FqwoQ5MCQdxUI3N0QMJI2htHOMna07kS8Fd8m40vWzHcLnfl9LbVi3dWFcii7xfgAXK8t6UowbSvSG123peQn2kxIInxR5p83x5Ttm5VTrZD83QpQ0Axnv3DN4Vrtc1qsS9X46TEdFGZzR/pDn+bCn5jlzG1HBYFoCg+K4I5y8TwCiq2BWbEwwIvKg2M9Id2cO2HXyXpdhjgy54zw2yTU/qTJZ5BJo1U02XFXs5tFoYKl4E2p+H+p1SD1/8oO1A5Bg3hItFR7m6THS7IVnCAWnUhD6BVKjJCn+kB5wfTSc5c3yCMFSE0rZPEBmZOfMv6NBLdHbCylolVBj+urUNT4YkGJAN+hEKLFzQMt04JEvaA31zDkCUC1lGDQWzKlqh7vMx8YfEvyVAl/qDD5SPF6uXoEwF6HrGB8DAgbxY27PvULthR15UPZDuF+I/NJOUsjn1LIZqhdLAA4L4EXu+cIlGWJtrtbQfCefuLRiz5sKPoYk/vAWm+/IPIXDaaA
 0fG/pSya
 MpC3W54iSEB3ErVU8Jh1VzZITC2d8EFPQ0Hh2HrYNzGoT8PPwL425O7R1sUkpJ8y85t6Kn2GbsvA2XIZAjgBF9FXblqIH6zxJntPp4pHBULIpAoS/xJh6U6jRO+ST+y6LcddJOKFA2ER/wadzhorwjsdVevF0/HWoNVvhXBMjQynC5EvJ9qedniwbNTB/KzfBoq5NRKvdEPi5l8Hy75lu8eLuUkkEzSA51qDp4uvC1xlu4KJ/4ywZXk9/UWXcKKYKczaWYZB+0hoShKJwMvy38bR3KgSokeLgVdnex86p4iYpe1w2l2Li4CuFFKktRVeQTFLbgsXAqPZLYN1R4zdMESzjXZ10tW2Y99rbIm5VVque7cfvAOyO4Fbf71MNXLCBaKyUVL3WQzyDaJTMz4OCKcWUuNbeUf/vfx5a9npJP14VvsPgSXHWwdyjUt1EYkzwiVOpB+bFbHo1JbwXVlyM7e9dSQ/JP8mp6V1wIR6T8T+voDof9O4d6GiMoJD6e44NIj3S1iw4L4w8BqGbo0CaTHFroR4OWu6FrkOyXmzR3ZmWrEdIdtI6jUXozlorh6W21ET/IZNcIqsdfReT6HfMcsFix8cV1ziAKSM+prujymyvubYWajQaI5zsMbJRLXIgA+4scdYFh544OdmeeEOoFMiIhSLhDAT59bAIucHnoBTrwQxyzzuGu39sDCoDbzf5j1RhC3s7Wy8ChvUWbGbGjJTzrzeK+jK6Iqf9/KcujB/i2ogOO883sgXPdYDaeR6m21I4zDQk3uniSI+Jc4dPJScswuhqlgWAcolLM/I3NAMUNP2iqok4lBeE+uGiyh0jgivPufVxevGD0CmlpcyiopKA9VoDU3vxGfuRU0qMNjmAY4wsg/zWaeLbDPd9ZAfuALaXuHAXYW/c0fdJG7/a07Z7Fw1ywWhLobDKj8ep5DNamFeiyVb3HjHP00Rhv4sO+vTRjH5Ek3K9mYKmfV4E5guvCTU/
 Nzb4lRuF
 7Ci7OSybZ6X5wBHRYLYp05qnzonG9a5lN5KO/572VFo3KufkUbt54rlnkRZiQdn7tDK6+L5XYwJLPKQFkAtt3/ZEA2kk/bawOwqe3u2z/+7ym0HHaPaqvj4oIfbhH6IT6KCdRALpAAZKbMli5aH7bVcnPWSXSzyCqDWqSXbeD9Cx1paKNOdR3GvSkuu80Jj12e3xM/9ZZLF3TnnhZ87F9f4HUIfK2DJvnKGPmlacyNsKWlGAsXpKKYclTgg5xrvTmIQiOfb8WPuZP4JOh0x2V6+6jL2CoOt79xKrGpjY7y75qPKHLu6qGNQyygIkoRdpcX3XMJIY6IMdyPq/a0z2550CHoqTkNTvt9q07UoIMoWs1asKCFHGYU42E5yyjJtkf2P68RcjLkA4f9r4mvsqf23hY43a2zoZpNqsS1JBTBHIl87QoXYCH36Vfg2xXNiVJ0VFWWRyND8o91sFkGUnHr1vl7UE59SKM/EFTVVD8ioYOHlJ4eF4yP49RSjFV7yi05gWMjKXPn+FJy6sEjN6leVWotVXUKiS0gah7OknaNF/BHHlutdSPpe7Mma1NX4pbJ1rfCm7Sy8Kif2LKesH3JggW92oeoh7HZO47/p6PaO/45f5P7c5ho7gmD2FDw3MnwBgewQnr/24KPS5xRMrEqKN7ztt1eNE58oXClSnss1rQrW8kKJbmG4+G4M9OBCMDRffxZn+JzN4uMXjmM43KZR+TjXAgtQOV7Sb3IQVj4oewUEHCY/cD1LvQfVep/umak2zpLNlk7X9sw41VZN2AKErEBSQHm7lRtDbyh8ECXKL0QZ6gNxgb/G0G7MLzHBEEEV2GryI2jOcEAbZRC7t88sRBhhwdd/iXFCUfQpHmnMJAFZvRhYigpXSy80xKkP7CClET96Kmst0Fn+qfi28/JL0NI0RtS6HM5mafaOCsg4JHDn+pJegsmWtbCgQc1sIelCpfX0YFlkInd3/3ohDaIWM1Tdi+
 WtDJlsQd
 UMaKOqRi1VDYMFuYQz4/x2F68IYWfPWnMeBMzGiWTCrimP3CtioHWBsSscG9FsO2OtyxrDjO8Tk9ZKz0XbA74HocnPZ09Bgr3/xeiXNypJRkf8m8Ea3m8s1nU7/XFgcsvxgXwzDLqTBroTD5WbqP+d2MhWDAq8WCn+qGpG5n8R+KHJ/KRyYNrkFl6lNQsclhiLE6pjGanIJto9TbPUN/YknxbBGE455GFgvZLS/eCg1zEhPHRP+shDe0tL3tVm9/ql2dWBdRsCHABeAhVonrKUh4+vNiAVZvM=
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

The code carefully checks to ensure the user doesn't exceed VMA bounds. It
intentionally allows mapping of less than the VMA range in case the driver
wishes to allow the user to map an area larger than available data.

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

The enum copy in the userland VMA tests is updated accordingly.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  45 +++++++++++++++++
 include/linux/mm_types.h        |  44 +++++++++++++++-
 mm/internal.h                   |   3 ++
 mm/memory.c                     | 108 ++++++++++++++++++++++++++++++++++++++--
 mm/util.c                       |   7 +++
 tools/testing/vma/include/dup.h |   5 +-
 6 files changed, 203 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 94b860b8c50a..4604cd011ca4 100644
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
index fe93be1cea32..a86b9803a4c3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1520,6 +1520,9 @@ int simple_ioremap_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_complete(struct vm_area_struct *vma,
 			      struct mmap_action *action);
+int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
+					struct mmap_action *action);
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
diff --git a/mm/memory.c b/mm/memory.c
index dc38cad1dcb7..8c9675451d4b 100644
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
+		end = state.addr + PAGE_SIZE * nr_pages;
+		if (end > vma->vm_end)
+			return -EINVAL;
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
index b6f1bec9da15..5a1916d8fdc1 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1464,6 +1464,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return simple_ioremap_prepare(desc);
 	case MMAP_KERNEL_PAGES:
 		return map_kernel_pages_prepare(desc);
+	case MMAP_DISCONTIG_KERNEL_PAGES:
+		return map_discontig_kernel_pages_prepare(desc);
 	}
 
 	WARN_ON_ONCE(1);
@@ -1496,6 +1498,9 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
+	case MMAP_DISCONTIG_KERNEL_PAGES:
+		err = map_discontig_kernel_pages_complete(vma, action);
+		break;
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 		/* Should have been delegated. */
@@ -1517,6 +1522,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
+	case MMAP_DISCONTIG_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1538,6 +1544,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
+	case MMAP_DISCONTIG_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 1098655a5f4a..52eee05e6c32 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -457,8 +457,9 @@ enum mmap_action_type {
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

-- 
2.55.0


