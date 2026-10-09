Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A90DCA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C19C6B00B2; Fri,  9 Oct 2026 14:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371E06B00B3; Fri,  9 Oct 2026 14:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B0E6B00B4; Fri,  9 Oct 2026 14:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F327E6B00B2
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:10:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CBA8804B8
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:10:35 +0000 (UTC)
X-FDA: 85303878030.01.F8488D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B52BB180007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:10:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqpUmEHM;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569433;
	b=cHHjYGdfq6+AF3PGiqwcayNYXqUBTmtoRyXnQkNTBfAiYbYrXlF9ysOrlNazcfAJxhY67c
	ct/udn9vbvIqhdfP/XdliG2JMivrAjKESCzqrluPs0TWd4LwohxHrmCNygjkRY7RmrIMm9
	TEjaqoAQGucTUXNXq8cyRjXq+Op23to=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqpUmEHM;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ytmLoC3zHdwZxCxWy26b8X7pqcm/Lj2djuN1AI4Dw0A=;
	b=c1beS7GFKZlFPb0V2firf9h8mIRxL9rUvsQ/hx3WUpN0uM8/qXLf/hDjnZVB2xLxlFKC18
	nWzND2KMQmZsRH1pxMaYszoA8rrIKaq+RQlctYusdUGbGHc88hWZ2wBUcoqRbDYU377/wp
	9mzayXDrdh+cu7ymafeXrInaVzF0h8U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 341AE60DA8;
	Fri,  9 Oct 2026 18:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676291F00899;
	Fri,  9 Oct 2026 18:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569432;
	bh=ytmLoC3zHdwZxCxWy26b8X7pqcm/Lj2djuN1AI4Dw0A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oqpUmEHM2z/wvmmgp2MRRX+GRvaOCWjV5ii6gbgoGkcP3lf550eL/rHRvYtLwRVRg
	 ZJMUScuAxtIuMMdTd0/rulTohZO+IJpphLyqqqkuRExULVGQPbSlIhiHC/WxZpQ4KG
	 fQh81tHtSR4NOHTEA4EDrNMFYFIFFbqZ2qQD9VidjqYV6Py02HvXoQcYIWihcamcRu
	 KsyHgQuQxyNr6YkiB5k/fnqBzdl/oz22gM4MzVcUF2tjxBA/a5BznF8UgObWl3n4px
	 ou/xRPUciNnG82Yno1GmwVHXPEBP3ceRKVW1FTIGI0NL/tr1c2S0qjp2XAwDzl03Hm
	 vkQeHpFglq1Fw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:11 +0100
Subject: [PATCH v5 17/38] scsi: sg: convert mmap hook to mmap_prepare and
 rework
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-17-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5990; i=ljs@kernel.org;
 h=from:subject:message-id; bh=a3PfLNgLx1GbuXFw7DoxzYfKOvfjucxXwlN8dVffozI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6szuCDXk3+0XoqX8cm3eY+4PvK0fuS8crYx+uu/js
 12HPhw41lHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJ7N7MyNDwQny18urz1t8X
 SthXznvXf2jRaYbrAhxn1T5bNGTOnp3GyHB6dTbfvV/zD0+YUXnj2VcG2QVaUkYOkn/fnP/7P61
 trg8DAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B52BB180007
X-Rspam-User: 
X-Stat-Signature: 5ftfjy75npuqfzb1rrt3zfm1rifgahb7
X-HE-Tag: 1791569433-544560
X-HE-Meta: U2FsdGVkX1/IXZyArFzU/OADZxf8JiSMBMcG+6RvTTpZ+gcTOgifHz5YDZOVI9Wm1XChRWk+QJml7rEHpHL/FdUsXBG/ISRYnD33jHl2KKfloEC0ejHVCzzkQvvcKbyuIeMACw1vf7j72LCGyvnTSyzmlzsK8TQP4QBMpwhmXT1GDWWSd2FmLsWsTuq2cLE29zTfIoVIn/x6BVtR0ZZQb4MDIi+66m2pgkl7EtDY5GlOHKp2HjxOtq3sM5CCvthyvO8MMBuD0WR2yyuflEs7Wdj3j+PiepufzcR10i7yjxh7xPpEEGfZxE1ehl33OoADLd7vsi2KzpDQsjUehl7OEsu5cD9jheuJmlfYC7tpzgrjx5prWzF8OgLcEar1UJFddQHxG/SyeN20PqLYo9C0ZqYXZ7/grJ5FzbpoQnN1SZuKuKIZ2yrwdteLuYaIgUXgtbG5iOgB1/k9/tkFdD9Zo+klOsKUoAJDmIRF7JtSK+U/Ke+2fqsukm97o02x7irqiJkLyCugKyQyBJy8TozcSMRlxKkTI1Vz3C0R6sJyP9YNv2SKnsLer+lJMokxBpLYfgWq/Q5R7LrB+H/4c7+LcKzBslUIiF8LqgTUkx+kMyQPonOsrQnppqs/E8TQjYsJ7ULuQtzCS9Iq5ZklOm9WK8UG7NIw63G5aplK4phHxEycUnnrChIFklY3t/lZ3LTaauQBB6oLlsH6tAYFI3VwzpEOyrywFl1w+KwbO6DXcITxJ4vcUIcxZ3Oexwsn12n8PuKtf1zrYr1S2TrzaUZL51lP7AHTBjlJvv5X2gN0kNvkBPkuj+/fI9xGMsbUad4JZ8M6Lbkfs7OomTZpX5pogBAs/+gx2y5flzmrtxSwsEIy1srP1iPPj61qO5T7y4NqGQnp4F4uTBdUPUDhi+pJV/KLZ2RUx2mYBpsulEABGoW1CYs6tUJcjj6GhK3cY8OvFfXAugIIVQ1O2rqawtV
 vlpF63Yr
 AR8RJrtZvExS+amJICvPWtWgCRsdd8icDgVZAWUaGEHLh82ORdK8uaOyLrcy/gu0zJOD21Wv0A595WOzaTZNd97A8Gx2e2rjp7pqxraiyop03GJyNdYxPvwmIHnn64dMRH4ZyibMpF8GwvZCjXr26AodViPyIQkEFjqp5ReVz09ZcQDFX9b8aBn1bN66nppNfxHOZvoFYQfRw2S6j3NoVDAqeQUOVGJ8RB2680hU8p9S7HRxac4SQkTRvZ9hWqlUyyTl9foZBner6lrhbncmA3HKFzuIXtrBi/6wPZvHbhIJ2YRTkYEffFc4Wv3bnS+HaRaswWHugqXbYurbQXP0iuqIS+CP3K2Na14FoWxE/r5zlFJCuVKUftU7hQneHDuM+KHWpeixyNe0trbbiasciGef4dj+mV920PCb/ononwb+oEqa0q+/ZQSCNTUIMc2dCJoGzQd0veIQyvkWFPVkoSfG5Vo8YRbIMJHeiVv1fK+o/ewq78rLg8d7aALiVj2/7G3ug5f6+kmO2fXqS90rWo9MmbS5GvY3mw2V7riTpTROHhVzmPHdFTXRlya94Dt44ovb/Zr2lpDz6G3QWfWoNYkPOTxoJ9dz97FR02SBVqEqMYkgK8Ni/HUUcAlWA/Zr3IrWsi8qxjBQe6yyGOuX/pis9nrchsZeKdjPf04TwQ586WyRdOZvq+P8iXPjo6JuzZSR6OPquouJVoved+MrXu2yd5W3FvvDmdmn13RjnbhRltIH59tHiBxB37HvAlOzAXgoTwezMj02v/LV+U29+7w3MrcD0L0+V/yUexQrYXH0DLeCBBE3AiTFFqtkCfyP6fO7g2VeovYRBXH6IZsJ1iPt0gJbbxPpqs8I0ZKHcGvpXZOA59onmOwhDwX8ehFH3fQz57vtfdQx1UA4n/POHrtXv7L4t+2fCOMGBCe5Re3sElcUMeAaQBKL42drwx8a0wMQ5BNScT3AgGqLDwEbl9i3wRfYp
 AEa+NUvG
 gIFCkVjjbjKzmrmHldnbrSBmnpl2jydUNKLEU2YspTNNyOvXq1fxPCkgBwoh3dwv7bmgdesT/vX687Z/R79QnjFWGeuvojTwf+erDzza8HCVxqGORcznfQB6ehEOV9Z9Fdf39gO3RDgUFLRX6oFNpfjmUMletLtVSbBrwvgDe6j0gt9sWc4vavFJ6EP20o6CY/7gfuWsEnc6h+jRl89R8UaiD4WaFOoCSdTyqXzc6amGLFqfhROX9LEmgbNrehM4XPYCigBFWtzQGclzC3cjxtSOZ+D4v9AsT1JHiNHf2KiHbJ/tbObuO8ScygLEbEmdm6RXJsmUkx1maNFIjfCq7l6JWWVE6sQpzXB3FKZUCT4u24Wk3L+wmghnMSDxfnJmGmGnsOLXk2iGQT/nY0LZYObX7KyDKTvfNJCTIqG0BSjtdQpxHNwzovhNRRqfB/1CZg3eSeVVukTT6Ekl7dbAu8Nf005+oPOntp0w1lqrryB4EkfUc43iAIOjvQiQiHDoBzzx3Fl9pH1luTI1q3dncwOnVjJ/ENqgxzzpk2oviP2FNw9SZmw7U41gBzc/rozI63P2c74x2nYg89PY2++8yjFdLXZD24vo2pEE5mZsEbG3KWPy9ZKFoPEmwJv0FhbOq1V6P1xslxL8hFNghKjralNWktTHOxLyHs/dpk9y/utNtLzHUSgwfi33nDghnfhC6I7gG27ykB5QDAdHPhzdeFzVeKQxL5RIodPuH8RxpxsAEyv3ThCT0VTVgEyn5+Yu4qWNVPFAeUUJMaJKuZbI8xXjVIc3GmHn9YpEKUvoPTEgiFwY9TYHx1OFB6eSozHEXgI8oGeJSDaUeNphq+rHWLhaf/a401et4vj+F1ueXD5wthlqfuO0imJeyDwECgEikRkUNZnAaDkryd4Jj9uIJ2oG+5FCv4QWxJKAgO+uw89PH86xpyJ2G0PwmYKa50QYUsKycH8h2S2GaU+VitZX4H9qJjYRd
 KUjQEzYd
 6pFlVJFLo+x5h8oBqcgARAwOYlltik/qpI7/R4uX/dato9ewURUdzPOn8QwU1Cqp98TRteu/shQ8TcqO2RP3+X65jPp87KJPS+ooHe2yxgFhe16ve216tkL+U9Ub2O74gk1pGVq3fwwnkQY/3BkCyNkmRl6Keq+fY1aRSRZPkusLm6GedldMvj8vQWYUJ2AyYc9nms6ZPt9DDL82/2rISzYKeQAK1jcXHR4FpHJxbegZI8Mvtp5eUZEJx97jHJcRMEqra9JbHdgLPGlX7VfLWhBHVCa9XhSHmFWYPiWWDtGFaOl6dyIwSTpQqC6RvKs9DuKtwzNnZsVRoYyiXp9k+5V9UCN85W9yrtpj3FMLlNtzssACKeTJMtfM8l0Z7Kf/Eb53OCFZGzKb5RudnBQ735mvV5MbGGfZHHyunsASR1ansOIe28NsvzmZbe4BFgMuGdlCiZm2oQYTj8d3aG+aUYXOTH0xLEh/jE0NXhyVpmZBMNpnfVezeqwGW9Pup5dU7bLQXOudeTE6/zX2oCkpOAA045+sVPkdfWEIoLFZkZsWENeY84rwaJm/1FcbicpxB2IZZLh8KvgGpLTOwo9owl2GlFx06HOljIbSv6p3OAseOYbwyDfz6r9oZdryhwRQOQKDvM7RF9WiuWJxjzfKt6spWcwmJ5pWVT53YY0yEvz4czIHUMz0kfFqAgw5scZUP61T/pgOdwiFAOX3iX/7eSC3acB8z0W6bsz4xaCxDxQ0aSu8fu0iUem1bomG/90V7NWyC+g/m/5jn6O4my88tmy/xjSu9VBkpqJAdNueIwaxEs2HayW/41PC18llTYfHnXkOCO2ltbhf/LvoR7cqC+0FuI/2PKAtrSOwml9AkByKBAngM3DWNgF0B8OHl0CrOSnOR1VrIA++3rAWP2Pbu4P2muasXdmPj8yQVKEVo5iUK3Nv1m9HVMmK2uTsYytzuU9xoEvLOyXrG2ht/bsxg6Np2RVwd
 M8NWBwX2
 ++MlSdPXDYrauhXWJGpWOK+bC2SWqCs3zR+RaxM117lUyUPxw4JrWJLzKKwinjxxsmOqfX7InXdn+DgRre65OhgLmcBcV3LkUQ4xpIeAEgyAdP9TzwGfJizFMYpIP7RSlQK8xW5Id5ytu6rNRVdTbZL9RghfIvvmJoVMKg6D2TSbrb9EtXoV1AtY9ZGql7yu3xyP88xgyaV45jNRRyFLkAA1ddPRLSZPJJWVDNY+Bk8jB+7MVyNjNwAYQGTotBDWFJd9zaVHHiAapJ6HykYiiVwV0Qni2tleqeeoqxTG0r0QH3uF1OCQXR+7j+BkdnCUvptUUwN4dxo0l8TEHrEbz1wYVODt0qEvkCmm1sknQIwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move from the deprecated mmap hook to the new mmap_prepare hook.

We are mapping kernel pages here, so use the discontiguous kernel mapping
mmap action to do so.

Unwind the rather confusing loop and instead map as many pages as we can at
one time.

Note that we do not need to pay attention to rsv_schp->k_use_sg here, as
the pages are populated for the length of the buffer at
rsv_schp->page_order granularity as compound pages.

The discontiguous kernel page mapping logic handles the compound pages for
us.

sfp->mmap_called keeps the buffer stable for us. As before it is never
cleared, so a failed mmap also leaves it set.

We also remove some useless vma, vma->vm_file NULL checks - these will
always be non-NULL if you reached the mmap hook logic.

We retain log output for consistency, but change what's output on page
mapping to indicate that sg_discontig_get() does the work now.

Note that we drop the VMA_IO_BIT flag for the VMA here. It was never
necessary as we invoke alloc_pages() which gives us refcounted folios that
are fine for GUP to access (VMA_IO_BIT would prevent that).

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/scsi/sg.c | 115 ++++++++++++++++++++++++------------------------------
 1 file changed, 51 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5408f002e6c0..3f9e08725602 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1212,85 +1212,72 @@ sg_fasync(int fd, struct file *filp, int mode)
 	return fasync_helper(fd, filp, mode, &sfp->async_qp);
 }
 
-static vm_fault_t
-sg_vma_fault(struct vm_fault *vmf)
+static int sg_discontig_init(void *vm_private_data, void **private)
 {
-	struct vm_area_struct *vma = vmf->vma;
-	Sg_fd *sfp;
-	unsigned long offset, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k, length;
-
-	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
-		return VM_FAULT_SIGBUS;
-	rsv_schp = &sfp->reserve;
-	offset = vmf->pgoff << PAGE_SHIFT;
-	if (offset >= rsv_schp->bufflen)
-		return VM_FAULT_SIGBUS;
-	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
-				      "sg_vma_fault: offset=%lu, scatg=%d\n",
-				      offset, rsv_schp->k_use_sg));
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
-		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
-		if (offset < len) {
-			struct page *page = rsv_schp->pages[k] + (offset >> PAGE_SHIFT);
-			get_page(page);	/* increment page count */
-			vmf->page = page;
-			return 0; /* success */
-		}
-		sa += len;
-		offset -= len;
+	const unsigned long req_sz = (unsigned long)*private;
+	Sg_fd *sfp = vm_private_data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	int err = 0;
+
+	mutex_lock(&sfp->f_mutex);
+	if (req_sz > rsv_schp->bufflen) {
+		err = -ENOMEM;	/* cannot map more than reserved buffer */
+		goto out;
+	}
+	sfp->mmap_called = 1; /* Prevents changes to buffer size. */
+out:
+	mutex_unlock(&sfp->f_mutex);
+	return err;
+}
+
+static int
+sg_discontig_get(struct discontig_kernel_page_state *state)
+{
+	Sg_fd *sfp = state->vm_private_data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	const unsigned int order = rsv_schp->page_order;
+	const pgoff_t nr_pages = state->nr_pages_mapped;
+
+	if (nr_pages >= (rsv_schp->bufflen >> PAGE_SHIFT)) {
+		discontig_kernel_map_abort(state);
+		return 0;
 	}
 
-	return VM_FAULT_SIGBUS;
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
+				      "%s: offset=%lu, scatg=%d\n", __func__,
+				      nr_pages << PAGE_SHIFT, rsv_schp->k_use_sg));
+
+	discontig_kernel_map_page(state, rsv_schp->pages[nr_pages >> order]);
+	return 0;
 }
 
-static const struct vm_operations_struct sg_mmap_vm_ops = {
-	.fault = sg_vma_fault,
+static const struct discontig_kernel_page_ops sg_discontig_ops = {
+	.init = sg_discontig_init,
+	.get = sg_discontig_get,
 };
 
 static int
-sg_mmap(struct file *filp, struct vm_area_struct *vma)
+sg_mmap_prepare(struct vm_area_desc *desc)
 {
-	Sg_fd *sfp;
-	unsigned long req_sz, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k, length;
-	int ret = 0;
+	Sg_fd *sfp = desc->file->private_data;
+	const unsigned long req_sz = vma_desc_size(desc);
 
-	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
+	if (!sfp)
 		return -ENXIO;
-	req_sz = vma->vm_end - vma->vm_start;
+
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
 				      "sg_mmap starting, vm_start=%p, len=%d\n",
-				      (void *) vma->vm_start, (int) req_sz));
-	if (vma->vm_pgoff)
+				      (void *) desc->start, (int) req_sz));
+
+	if (desc->pgoff)
 		return -EINVAL;	/* want no offset */
-	rsv_schp = &sfp->reserve;
-	mutex_lock(&sfp->f_mutex);
-	if (req_sz > rsv_schp->bufflen) {
-		ret = -ENOMEM;	/* cannot map more than reserved buffer */
-		goto out;
-	}
 
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
-		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
-		sa += len;
-	}
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->private_data = sfp;
 
-	sfp->mmap_called = 1;
-	vm_flags_set(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_private_data = sfp;
-	vma->vm_ops = &sg_mmap_vm_ops;
-out:
-	mutex_unlock(&sfp->f_mutex);
-	return ret;
+	mmap_action_map_discontig_kernel_pages(desc, (void *)req_sz,
+					       &sg_discontig_ops);
+	return 0;
 }
 
 static void
@@ -1415,7 +1402,7 @@ static const struct file_operations sg_fops = {
 	.unlocked_ioctl = sg_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.open = sg_open,
-	.mmap = sg_mmap,
+	.mmap_prepare = sg_mmap_prepare,
 	.release = sg_release,
 	.fasync = sg_fasync,
 };

-- 
2.55.0


