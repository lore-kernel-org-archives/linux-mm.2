Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE28CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79C2B6B0088; Mon, 12 Oct 2026 14:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724D06B0095; Mon, 12 Oct 2026 14:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E556B009B; Mon, 12 Oct 2026 14:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27F2A6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:32:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A794E1A128D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:32:39 +0000 (UTC)
X-FDA: 85314820038.24.DEBC8E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E620F4000D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:32:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LJrxmNyf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791829957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MR3QSDnJDSPQxchGzKX8rD0iI2DqeBRHMbI1BZ7pOVs=;
	b=5qq09MaGmJj7KAr88UuqV059Qk+/XXS10llshCOHvlUtZ47LykS7uhm18dlmRd/OoftnrZ
	IzkrnbecPcmitQzsLjnVUiDu5cTvjZ94hpKKFgrgr6PaOCMaf7za/IxF2q0bo7dvgB7yVG
	ZESzJd6lWBUJ1pS8G0egoY1nrIfGFUw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LJrxmNyf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791829957;
	b=uBAJxkUgEDaoqcvFXAYoLWS7AkVEjMJgjEXjTFok2t83NjKJYkg38DbswvAhhKkLaTz91O
	V9G/2LzKjSr6nRLkirDoEYIokfLfNHcOTzkTTHO37mVyKjL6C/RTAhfTgZ3jTusF9D92QR
	F6Vq9+oZh5zaNfjakxMKoxftg18Pkzg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0C1F60142;
	Mon, 12 Oct 2026 18:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320051F0089B;
	Mon, 12 Oct 2026 18:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791829956;
	bh=MR3QSDnJDSPQxchGzKX8rD0iI2DqeBRHMbI1BZ7pOVs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LJrxmNyfv4doXTKsvMR8Iw9B51t5c5xFJDtYRKmU1dHUtf+9U90XD86OtNFb0w1Zj
	 6d0laWdCJCGOqGdcF/w/H7Kut9bsHxub56BAKK2evbqD1Htp8Y5RdUPMWan4gJgCy5
	 cWmt6/DIUTBPO30ptvLUTNgAPExQ3TR6z6mtRmDYcHDEaS7V+PXMJkXy84x5sGAAeD
	 dZBmxs+SqaGZnr/oBLA9Yj04OzVM0x9cCZlzoPkp72RccEb0UoxksX/kkQlTpc+5U+
	 YmF88SRh4WZXNh2ZgsPVTykyA2nSPdEzfba5mQGgWRtjShzglmPaDCDbqeVrCZb2XD
	 jE7Tz7jOtPk6A==
Message-ID: <c43caa45-6a4a-47ab-bfa8-c9875491a9e6@kernel.org>
Date: Mon, 12 Oct 2026 20:31:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 25/38] mm: remove VMA_IO_BIT check in
 vma[_flags]_is_mm_managed()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
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
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
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
 Bert Karwatzki <spasswolf@web.de>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-25-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-25-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f6uhk8xfpqx9m7e7dojpchxo6kxf18tb
X-Rspam-User: 
X-Rspamd-Queue-Id: E620F4000D
X-Rspamd-Server: rspam08
X-HE-Tag: 1791829957-766239
X-HE-Meta: U2FsdGVkX19hqdtkrwH1pcU3gT9WlB119hbyP382/ldJ5FNO+qy40/msLDdLOoOm/sLkRUhno19rrOM+K40JO97em2AvaZaX68sIo9J5YNtp+v1izRdyofAKvsgQjR3Vk+DLzyUWzjMtb+Fj6Qt2lUYeQt6VsELsZU12GaLew4juTM4oYnSNE7/O35rIHH4/jL5EcFU6jupGNQV0RcS+mnuV5WOfNq7phCMi631iirc41ouu9ExTa0Emj30/44r2L5HWjNJCIYRPTy/OilyOY9N6ThDeKZNX1Wj+0xo4iHxd8UAINFUhd7YuyxVDev2xjEJhFdNYQW8vlmLcwMUpMVwpSqcMpsGurrSc+S0QtTkeLhkbwIY33dYkncMR6QxeU3vjtNJXwKN4aWY72+0tMtoID7eJFRvj3r8jcxf/48P+1wW9OZIiTyt7/jTMvEqQvxFnLR5PJZKntnHThynXhNNKzIX2rNLXKZFqq1jk7vaImnNknwRoT75LiWk7SGbxGcaOOWOuN6SikWpmS1rYqNDlKERELBkohtY6B8kuncr9fDotHU4Uo55Do5TPpx9ROU7vyEN3Axk04BOIcPJqj25nJwi86eAX3xENmQrY6qzdwdLb70nxrO3Ko+Km/kTcKyAMsR9DJLLR8loisPOS+Gz/aD0TCYsczEN40lsMTwcbzqXJKe4EaYxU1kDNEePW5TxawOgQgJGc/kw4upT8We8ktr637fzhaDJqfyIcrCfVEQJQ1eMJjW5QUY5g5ANnNq6JDRUpBbz17ROTv6nP/KoZXfvq332o4cmQ+p+g69d5qLdEWiG8I5KrCmqFig5rP0NqphZ3TudYv8JbbezWySW6SuAGfostVoBIqJ5ryJa42RzW2bsoFUfvV5f5JJkejV2qyVxZl019ubzHRRK4tbRPOtxfkcawvKvdIunPKK3POAwhZGtp8b8DZYO9Q2+IF2y4B+5rRIiqFctthWV
 o+nsBidZ
 2rmQIygdvjvJ/FfAPopSQw9dZXu54iD+ZgSBHYVxnllk+2a/fgf0X6lcmYslNXWDg1hBiqFy1cI9emzMeN3NoJ6dhqsVonuOdXPzFL2rqyuCh+hSHTMu3xuMp+FY4s2kjAamP27cruOk/EQ00mya6Nr5q09aw+fl7WkJNFOu9vuOa/vQy7IkfXOcPld3RJBl8fIv14S6/YZj8bmkavz8KzPWm8JmeDgbGBs9nDlhL3SrU7m9bIP5PqLKRLC937EBZ21zB/0hD5030c3+AZB+ocvwd5MM1ptfVZ0F2K+mg8FfjH9F4UAY51wjGwpP//7f9LlB0USaLerFRzrZ7DMdkyFdUN4EUUORvewyFEvxIYsYUBWAhq3Ijo3vIUGTgtqEVa4s+OBvyKyecTfRLGUF12O7KDyJRMu5q0hkbN86mRlkt3baOvKln+c0NW3Vut2CeAmu+C4DNY5TNCWPS2E91aW2AQJf2X+uDbaJjpLxqVbzQomqcrj7sxiET2kwWqAsNUbRU+0VENYSQ9nYYldVCweBIQDnZSXHKQorwHaS+Clirproqu+Nf/ZDx/ilTKT62Es9y1eYAgYQqO58MUudzCoyWx4aksKvEapWzgxvD3xpTsxVLUg/5GLav+GnQmwnGfRkEiHiu/Dj2+qm5bjvPVk6sh5+J7WQAeGBx0OVB8h04pNGZwp9oIgYaY1gaZSisLQMQ8OsJNOFWnSCg8iK0xOofIM/jPORmErg5gisyIwpHGn9+Ibr7hiGsA6mc4/6GWnNMSV7g37Cb934So9aNqthbfyll0THrYmw4TezoZyOVrXUPkkdlg63yW+a8s4MECe9MNBsU+KEeGz811XdM+TANO0Dduc2DbojJBsnUSx2QkA7+5SIGCyxjAPZmloMpINEQRXzTs1f4ziLa9cN55GTtOmjb5VMnKJBsbw9UYjbgL/cNwojNXRfwihlIRZ7C+mt3/MrbuEMuxhwP1r+C9+1WMfdY
 zD0N64dG
 azVV3yFRjLRPjuGJCu1w5Wy/RjHQutq2mdpIpi2pfoCASXB0CW3mMdMQZzdy9+3QJsGxKM/hNcTRV8MTlavz4VHAdymkXcPlDknDBNCkVhyvPV2taVa5QpY4cBXoB5T+BCORjzKHdzBzT05pxKB6Mh+X2a36KB5DpkKQvgYR3FTM0l4LlNbkY2njKTSxjsu6rgOvmURbpcxXnOLm9qdMTDt5UUK2Uhuj1v0bqeStoq6PBD4mGnR40it8DkORHcr6MPlYa9/fTz/N0IJK/3eRhL7MfYgMbkUSzVFUXa7Z5HckoRGJjrIrnQJ7oQBKCd7JX8NKXyo07Avs49Ghu3KQq5/fDfCUcgsJeXhve7e5UHGCxWwIlW1QeWN/UmhQ9qPKUJ97a0WYgpJgQvTUtrI5La4JFTqzShxdmRZrKWeXn4SPJp8WyLhTMA5aNm/d8Rxwi5td1d/125QP0tJ9sl5gGOF7Hj0Ql4uSCIFx/FobuWXctQrh9Z3EeVdoTdvskwr5jCDlAfGxRu7bgHifW2+tV9xi5cuJ7XS9r3wx1YmcDYpa+HbvGR4Nts7ucF6c0FPfNjhoNSrwztqMV+Cuvpboy9ZHPx6u5UJDRDmy19ZN5oaj24XHWc7icpEn9C6qXuwX1gzZvE7qZr1uleUh9XiO5goKWmm2B6NCqprnGuQraHUN7Vu0VlmQKRX4TKZj3OSJHzvi5+Uw44sXZVI3RCVRjV8zUHFMBu7YX7vq+2xFwbbJCbQUJCNSW4RfGZ8JtdunEP0JWiqE7FPHc5DSfy2TC0vdxNWgo4emvlBFYpjOmbWqOgeRCRHs7KfnIoULkiuiBU8scvj961p047aaeVPnYtnxcchH376d8RgmMmnvzeozcB9Mwvb+6q+lJeLrQ72Rmp9QQ1hEni81alHi0ONKsCeZyagucaWY97YSodivE0+1cO9/rEFCZVxU9EC88g2n80C6ABA+Ltzk0YTtzsv/YR5RnDNfT
 /uZfegv5
 YymIKx2kFsMlcoJHOVB3fdmX7tpeAH7HGHK8oukNv5vlMmZ5Kw3HE020izo26KemHo8Mz8iVJNFkfJKlBj3i3rYqBiZlyfZbzmocZlH6Cl4NxbS1wublzKUKQOHrZmYZBEZ2xzjOcFmW36BmzY5uAjzF5fk7UH1JQEQ9I0omrEB28Z45J7hs0crqhN06SKkKha4Gq27XgKB6s780rJvUGGlBeNRVrG4nzE1ENxE2VVVSDE6IwR3TTwzcWb8urTRH4g43PYgEYywF1DfW3WkgLGbd/jbx4ozGMN6GYj/RSJTg1coYVw2kL65j+ZUEB/FDFgvMdJ0JV6PYAE2yQgXPKwgTZxFFAKBdMo24Arrj68+mBz1MN30dUnVygkhPDvjFoQBAx7jJE+AEeeRPmGjDbCWvPUCYgaFhupPYQjTLGFyenfmWlw15AHozr6y38ij521o7hWMuycZ62H5T+lKKG0fA67I+sF7iTwU2seO2r/ADg51RaT8ZY01bncez/nO+sTENYODZayTRdxcN052T5opEZXsMjZD5BU3l0UBeI/y54Gv1aoCEDr3K93iDXXXBf3kH5yk/vlkvRF3DY+bKXYyDlA/dF+Q4z020YW1TqxQd+vgRfmyUb3nAX0QKHmAz/Vkz8UXOvD+2+4hESWeyQMs+3+EnGdOcWYr2OvZJwNWvDQO8Hd8B0TsNbd+rE3n1UIaM6hYGywzC+9ESWVMtyLJlwxXwonbylOCOSqbNGCbQCoanSkj0KngPgfedlaeDtUiPygeKkDLpPCKXCux8NMtgCOWlNcDMppLVFF2ucsKeLV7GAYL2GlmQClU+B57yoMrtQ+yDScSDJXhLWz2FKaGVCtp/njRwQtIuVvMcbdvRL5pHuzmfzUdjW8r8P2NEJo0M9jWE7t3zpynvNSqcsCiGuhuT6ZOgYmiHzOmuVkrx9Lw+b9VAX5LvPMwupVDc9oW7zPFykPmn6L0A0DE6R+N1sjxNk
 epUra6nb
 CiQYwudCnkOgwf4erV5z6sdF10f+tfSk5XtjAKnj/lHhkQ5MHE/nPZUqGucYfI0vPP6/YZ6kIKcK+AQ77SabtttGdS0+DggH8ZzsOsCPbt9qZhmK1/NJlblukjArvvs4cMXkqKKkVD7Wh0fhRTPjnQK/3tYTAfZEWThsNz6zOhZ2BsZYdE1ldjNzHNmumodykkbRe5C04I2h95ijuNLFni5yEGk1amrkNb19yimQnAOq98ie1kp0nKOgypswvhk2JJICSoYTvsrc+GvITdUsi16URmz7hYM0OqI5ccv9i9CjIFDCOX69fwj1W/agPMkAyaMH+PdTGtrQKzjocXRUzAy0+b8u3snSNZV5O9i0Dl3JldT53t5QGD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> We have now made it such that every driver which sets VMA_IO_BIT marks it
> as not mm-managed.

Confusing given that mm-managed check tests VMA_IO_BIT.

Maybe combining this with the next paragraph could make this easier to grasp

"vma_flags_is_mm_managed() still checks for VMA_IO_BIT, and if set, treats it as
non-mm-managed. This was previously required to handle driver that would set
VMA_IO_BIT but none of the other flags that would indicate a VMA as non-mm-managed.

We already established now that a driver that sets VMA_IO_BIT must set one of
the other VMA flags that allow for identifying it as non-mm-managed.

...
"

> 
> However, vma_flags_is_mm_managed() currently treats VMA_IO_BIT as
> disqualifying. This was a product of drivers previously marking a range as
> not mm-managed by
> setting VMA_IO_BIT alone.
> 
> Fix this by removing the VMA_IO_BIT check in vma_flags_is_mm_managed(),
> and update mmap_validate_vma_flags() to use vma_flags_is_mm_managed()
> rather than open-coding the VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT check.
> 
> This change means that vma[_flags]_can_merge() doesn't check VMA_IO_BIT any
> longer (which is now redundant) as it calls vma_flags_is_mm_managed().
> 
> Now that the predicate means precisely VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT,
> also use it at the other sites which open-code that pair, so the intent is
> stated rather than the flags, with no functional change:
> 
> zap_special_vma_range() only zaps mappings which are not mm-managed, as
> drivers use it
> to tear down ranges they established themselves.
> 
> The mprotect() arch PFN modification check applies to mappings not managed
> by core mm, which may map PFNs without struct pages.
> 
> NUMA balancing skips VM_MIXEDMAP mappings having already excluded VM_IO
> and VM_PFNMAP mappings via vma_migratable(), so it skips exactly the
> mappings not managed by core mm - say so.
> 
> Finally, update the VMA userland merge 'special' flag tests to no longer
> assert that VMA_IO_BIT prevents merge as VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT
> now suffices.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              |  3 +--
>  kernel/sched/fair.c             |  2 +-
>  mm/memory.c                     |  7 ++++---
>  mm/mprotect.c                   |  3 +--
>  mm/vma.c                        |  2 +-
>  tools/testing/vma/include/dup.h |  3 +--
>  tools/testing/vma/tests/merge.c | 10 ++--------
>  7 files changed, 11 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6b5f06cd174a..3ddb463db895 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1627,8 +1627,7 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
>   */
>  static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
>  {
> -	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
> -				   VMA_IO_BIT);
> +	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
>  }
>  
>  /**
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 8dff37059faf..a07a658cd99f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4212,7 +4212,7 @@ static void task_numa_work(struct callback_head *work)
>  
>  	for (; vma; vma = vma_next(&vmi)) {
>  		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
> -			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
> +			is_vm_hugetlb_page(vma) || !vma_is_mm_managed(vma)) {
>  			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
>  			continue;
>  		}
> diff --git a/mm/memory.c b/mm/memory.c
> index e5c1d1c35bc7..094983683f24 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2343,19 +2343,20 @@ void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
>  }
>  
>  /**
> - * zap_special_vma_range - zap all page table entries in a special vma range
> + * zap_special_vma_range - zap all page table entries in a VMA which is not
> + * mm-managed
>   * @vma: the vma covering the range to zap
>   * @address: starting address of the range to zap
>   * @size: number of bytes to zap
>   *
>   * This function does nothing when the provided address range is not fully
> - * contained in @vma, or when the @vma is not VM_PFNMAP or VM_MIXEDMAP.
> + * contained in @vma, or when @vma is mm-managed.
>   */
>  void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
>  		unsigned long size)
>  {
>  	if (!range_in_vma(vma, address, address + size) ||
> -	   !(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
> +	   vma_is_mm_managed(vma))
>  		return;
>  
>  	zap_vma_range(vma, address, size);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 2888ee638d87..706c679d4281 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -783,8 +783,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>  	 * uncommon case, so doesn't need to be very optimized.
>  	 */
>  	if (arch_has_pfn_modify_check() &&
> -	    vma_flags_test_any(&old_vma_flags, VMA_PFNMAP_BIT,
> -			       VMA_MIXEDMAP_BIT) &&
> +	    !vma_flags_is_mm_managed(&old_vma_flags) &&
>  	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
>  		pgprot_t new_pgprot = vm_get_page_prot(newflags);
>  
> diff --git a/mm/vma.c b/mm/vma.c
> index 51bdbe08bb02..cb8729b195ea 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2796,7 +2796,7 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
>  		return -EINVAL;
>  #endif
>  
> -	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
> +	if (vma_flags_is_mm_managed(flags)) {

Ah, there is the change.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

