Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E572DCA5FED
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07A26B008A; Sat,  3 Oct 2026 12:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB5A86B008C; Sat,  3 Oct 2026 12:33:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C956B0095; Sat,  3 Oct 2026 12:33:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC9C6B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:33:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F93114096C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:33:10 +0000 (UTC)
X-FDA: 85281859740.18.2D79562
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 39939140007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:33:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LndA8oeB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7mV0kCMwthfxGwZAbu/ZFWFgT8xuTHH7F7eDvIukLrs=;
	b=LBPnLq+5I5caS3+KyBI7IJfT5hDpZhfndkO108hgCLwPgILYr+2XmXsEclN6MFD2Ma2TZj
	Ejqj75bqSEnNDAC3QHecGDbOsmQr9SX+x9l9wBcegMeSJkdoUMSke3KIM+culmUhiU7Jhg
	uRnZ3ZGqZHcejDiK0BWTIV/yuLhC8OM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LndA8oeB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045188;
	b=B19Dwt3eLCThreQ0K9viYKxKJcZVNN40rHDNRp51lMAoxbBcN+VA4e5YOZa+CtdP9/pmzD
	4a2AxlNXq9g0SYIUPF6IxXPJla9c8qGaDg6ocp7tCg2lO7IUsWFmoYOB4nxAVn1KRFpaxw
	qwOS2hCJDMLG3kLphQ2IXnLwOjRK3pE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA96A43597;
	Sat,  3 Oct 2026 16:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799741F0089B;
	Sat,  3 Oct 2026 16:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045186;
	bh=7mV0kCMwthfxGwZAbu/ZFWFgT8xuTHH7F7eDvIukLrs=;
	h=From:Subject:Date:To:Cc;
	b=LndA8oeBx4cxCZDvPQOzvN55Mf54Ch44GwyPEPMobYBFo4bSkj1UFaQYgmFpskR25
	 1pdAnjYFESx3z7F8sBgzaM/Fwc/i0qhDt13PFf6eAxV7LUrbb009p96mkTee6EpDgr
	 zI0uXfFrzUeQESjiGUKWN3EkdBJ4F+R/gP+IdCkXdTpCPZhxcNbBWUKcnFVLbUWuGy
	 AE5KGLEl8Y6LEpaK3zoFAZ9KvBkL76icrHC6Cx3iCAeOwX8OjNZnmToT4zCJ1TbT+y
	 JNYFx86LDCvvR2GYZMfesY360U9ZJ4GL0X+EbRUgfGQ/055Gql7Fuq1ty4cgk8bzi+
	 te7lvN82gJeGw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v4 00/38] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Date: Sat, 03 Oct 2026 17:32:31 +0100
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4XOzW7DIBAE4FeJOHcrWHBs59T3qHJYw+LQxj+CB
 DWK/O7FySVVDz6ONPpm7iJxDJzEYXcXkXNIYRpLMG87YU809gzBlSxQ4l7WqKAzMAw0wxx5psi
 QBwJ/ph4SjcHfAJWUBivnKyJRlNLz4eex8Hl85nTtvtheVnZtnEK6TPH2uJDV2nuutbLZXMsKJ
 DiyXrXWMmL38c1x5PP7FHuxzmV8AZXZBrGAtWvrRrGr9F79A/UrWG+DuoCmarRrCHVn6Q+4LMs
 vKf6DnoMBAAA=
X-Change-ID: 20260721-b4-mmap-prepare-vma-flag-sanify-2100425df5aa
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Takashi Iwai <tiwai@suse.de>, Emil Tsalapatis <emil@etsalapatis.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=13236; i=ljs@kernel.org;
 h=from:subject:message-id; bh=lFfevMj7mqvZBoj0yBSI2QDBwyF6zMrkTs+CCxQqOyw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6qmtyHlqddRZVGoNn5i4+9ElBUK5qj4yurPenlwvl
 ntLrmRuRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACaiG83wT+H7pybFfLPZx6ae
 +dbl9E1g8h+Xp6svz5WYUX8tykPYbx3DP6P6wycP+bilFgbKNJzw3zyTbV+dU7bCvRVfPk7RYKu
 o5gQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 3fczp9ctfrathqfbokc1syrqkyw4zmus
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 39939140007
X-HE-Tag: 1791045188-585800
X-HE-Meta: U2FsdGVkX19sdYnxbaWpegC9hOgLql5hTITrzHFdX1IKewhq+1JY3r5t0qjJMY2QwvCgm/StX8aghOP8jmxD/3wdJAK2T/z6Uu0tavymUzkZXesBMttRfNX0C3Au+QA3qzjH+/zWftkW2pGQ1AtUP6rgH35/B1XGSwxvgI4MBSDmuW2mv6OdI2jzsiUe7VQClBZVIEcX9XfkD58d3kd2MPunihXhB/qTmQkh+KJ/E4CXvbMWUcNvbZ4AhQEYh2I8KF99uAVVogvVL9IE3F+yOtUHMpSLf1MpxF4Ktk+UWx9faULYGB7QTU3brFg8NBYqOWN/TIRHBLawzNLoC6/WJoMf3KSF4Uu8GLpzF8mXtppjUrEm2YJMkU+gg1Z9FCVnm1PGC1zMfHRL71Kx3D13J9dmoSA9Ex61BEahaQ2Kmtv+aNbcR/NyeDITusW1temq2z+8LLr3GTl/4we+E+532QPykRFVtsgl5fjiqMC016LBPS66zuVipB/HwOrYPbhCosNz+MJa7abm50jP7R2KJplYnbs/r/l3zMMdb8eC59nhbguS79tLtTkGGPK3iFaOa+T7ckMCtKeYEj7zWxjO29tMgy5WzzKrdiPLVk63eKBcgb6adhepeMrYoAhn6xziQtdSGdFh7l+CoZczaS+GGS+q2oICsNuVdhRThYxU0bciOzE49UpICz2Bv8SFA41tlOcOaaDJQjxpzZypQgedEPTaSSlsMZYehUdxphiYYC8/ZT9boqPuybMq3gqAnfiknqWk+p2yJAY/bxnwcisbiwzO37b+a0/fPihAeySdUtJ+N0N1bBZC27raCrZrXGn/oqBX7o8S6+Umkq3Qgt6WbAdjIS/4np/0uszEJM4uONsW2QFzCo1sOtiXZf/Kowwga/aiXNGjprbXYkiMfHaOKz24dq/kxqJAdu1nHncEKmbhStmwpeWu4TkYvhWU5kQtk8Yztzl1z9jnNR8I4Av
 wNS6+H3w
 pEtuBRaGrQQfyBLfHi+K6vHWpDIqWArV9Fc/7xJAaOR7wjjOc/r3MYRV+T5G3/OcZfBdm0yqdysU0kxa7T4tc6CPZVUWgErrzJ2fP/21USvVadSrbsoVjulg4QWJKk5nuFW9ujIIZRjicY0flskgZCX+amc2KVESUQAkG/Ufi6oHv1Q2+LmCIwdIScGEziXIUVGQy+4lIjNtXxp2kAG6ZF5H7aP+Fh5BlokvGDokVZFn9amvaoZlLLFjQco7cFlP3H/Di5atSeXU54a0E2Wrmkyu+d6DqkyI1Kehj+7uAcKU/d/vMxdvLivXZZItVesbgWBsKCa6qZ05CHx63w0ymjp++0IqO8uN5yEqjk+v9FzNhDQ/0zkP+8jzgu7PIQHjx4/OKTbprN2PqyAWawkAwsJ0JNb9gFzi+P4aIwRqHQ77UzKAPEgD/dAnXy2CrN3EZ7BJ4aHzNQOeQWniCW8BfKEVRpKnLJEzQcBKgOivY1Qd9AY25upSEHR5S4qOqtkngXEeXKBdIhUTrXhXNVlxqoNmYzRPKfLyj0zFWmsYO76Q+e9UAncVfPmfZITEQEX9TKNO5iC7q5PueVrLZfd8o+mAjI+nmRHctJSJ3B7LWBnrVF5X8EB0ra1Iil+r73wjcs6CrM9Ejs3qKbHpdn+sA2zSVwCs00I+wM2DunTKAo5NQH5l0bpomjmZUoconFn2Lxp0Pbkrziz2TjigYX+q+Tyy2NoYZxMHsamSzxREen5c2ipROYtlxNCuzkyxgKuMW1/WM8VQAxmW35sRU+4Y6k7uINs2e9G6k9fjmhlgQQbtNiXkWdaZsuDAv6R0nqY0HvRrkQkTsZ5QJPzP5lMdOIO/8Ll0KYv18mOMqCcPAtp4/zXydyREiIuXbREeYuAv0gObmX7/4JnJez19HAcQL2UQemdz43VMBAkoUM3FYjZ2LJtdOe3xjLBdTOeg+VVAp8/SHlPLf8zN2e53Xx/VoLpGSWx1y
 K3sI87sW
 ccIsl8GIC9bvDq8Y5HpkcE/YUuIPXDegNCWcC/PFyAHtq7jT+8gsedlXfASUbm/2S7pgQIEucrNdQy2XJcJUy1tQ/+6OWrGbHZ//bIRepFyOSEMMmvrC5NAt32ttDiXKyw447jQ3XiHvjvhZ4FAT6Q9mcRgtH4OJ8vdPQz0ImFkJBQE+SxbaMAhYB6e6k/6wgQ4zD7sWhQqaYgvv+Q5lzYw4YXPAnt+1ZC4kdmVB+eDCGa08i96yP00ZqJcaD+7FCF2boDawk3eSIna5sYtKc0oiNlG5BMitTp8em9pOVsOr2agFu5wywOgB8w6AZlLS7s/COJWJ9lNCU+41R6KMT07vq7kc90gqnXgMclULoauVl4CB+aeC794iNTgQzAJatS0tB7W/j/IKCkzRC4DoQ/yKlxwgP5phf8NZ79df5ISGShpNH1PfGLEzmDNDgjGgwyKNJRJ1h0JpTnSX8kUDNAX9/Pbj6OOL52heVoZ4KpnCtrXEbztfJkHJ9tjjzJT8hBJ/2wcCKewg359sByfcMRbUpFrtbq7dahvehcVfpcqWYE+F9toCO8HTZIjaN/JeCfB1qvKXbw1j+wreNC8MliALBERu8dumEboECOCJLtq1Ri8//z0MKl1gNlrQav8cmDUkizcZSXZtKCab0Ys/9hCZgejQP5MxqESqPvC9yjZy3D6K0+dGoZiEe68iBlPgR9TW1HIS9zr1MKpXV5JSojKvP0fat9abxAqldWWBNAZcRNA2pgxyZrLJQ8EOkgNHO2vsYDNuBZeE1IAbCFc7aYldLspMe32ARcUI3C8ksRWegjU5TIhL5XSujx3OY7Ap7DZjafMKPDHNmt5LY4ao7PvZOBWMjl76YelZFgdym7sit45Q/qP0XjSu8RhW3Gj+JV8s+Eql3BDNvRGcApiXUeoY7mGv5e+qTE+GyoOVAnSNSA4DGzOhVpaqSwPt+vUk9l6i/DvJA9V1BDcK0j64dDuyOdma7
 objHKa2T
 Rmv+oWg+e+b9FHNiS9HOpGxlL3o5BGezCkgUzRYCPG4KAqUjoAroDik3fWpKbEHUKnxDm78rq5N8AlPADONyrXmWPFxv3xZGLRxdOv436JCXRCYeVgOi8XsHoR9r3ORkFFdiKnLYvOBvaOxa2kf8g8bLQWqY30J53LqqTSMC+WBYVnvNbFlKGv2CcO5toyNTUOo9TFLwrqSjO1YFd4UeKoNLRM77rTE5Wuvmou2R5okoKYGXNbUrl5TlQ8I3/Pq3W8H+7hWgTuEKOJGfT1edckgKTL3XwEtvpc8ikzQEPLm4LXaBEUHq1ygMT88G8ZtL/Z9E0oerDRbr6WMa3sLDItn9kjcPIGM4Pd/ZhzcGoT9W/HzDJBF9/PmhfKWVZsTxIkNeG8ytdzwARoKSF4357B2lUWnbXN3nvWE3XlxLIyNKlNtNSYHhahBUzV9w+iPMYs+Ehk1Eai1XRDZv2Cecvg6h/Ivfw4TNBJtGKJsJQQMaOfcSN1Tcm+e61Jz381YUfm8yqbPdsjGPn3hLTZWZ8iFztHLJtIh86R6wdTGvMm6JCk118oG0SIpEphNc7Opft1JTN6CcixBs8QzOMrSW4ER8Dk2bF0v/7ZH6xRQxPXPklJumTKrJSfTNpIJ4S99un4jJaKjN4NIj70dqZziKC3OsJN0IrRCzARHq8lk3NafHy2EcKMBKLUrfoDiuWt1mRAtFuswl+Jw2tckejMYvfQrZ9/83Cumob9zapXRs3sXK0jX0sTwBaE8VdZ/kBAgo+nKL5mXXWa7vCYEsGdyu4UUE95nN4XEEKnX1K+qDMf5TFeb+fWDrBV7P5tC8fFT1TOZJp/yKTkay0daYSGsEOomkCq7rddM3mILPS+NRado/OO/IFtWW1eBY1RNXjNEbpzX3CcKW9dUuG2hTyVOB02I3gQIWKSZRDHD9Hyd3PVw41TElbFE9/KoSTtt1B/H42xt5AqBxsdHwoxuFfiU4yvQ55Xs+u
 dh4ErSux
 vKQBTyqu4GXswhSo5Ck8E7GdW0mwrWXI4blEJ52aac+0fTBrU6sLoGMM4nPiSh28IKgDnb8ckZHAyNoPbyHbwHahfk8dYg0fu6SZlmv3q2/5Gc3UUvq6YMHbJEKgiT2+hapzRaXxGzWKGLpKXsK6jWlq64HKxpXe61Owiwd8Bff7hOEWSV7U7YD7LecdWCcWMdUMHcjEfSk/Ts5rNZvfpZXJ428Rp/e3N6iDHEU+r4NfpqjyZqWNxH8QpxQYDu8Hdv5kxrytgPffq0k3IRmAIrOvig3Tyu+2I+Rj6dSKfCPUbyx6KQxhS3FBLOwd6kDLuD0IdC08AJG/gKu5sWH83/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
properties:

* Is this managed by core mm, or by a driver mapping MMIO, kernel-allocated
  pages, or even ordinary pages itself?
* Can it be expanded or merged?
* Is this a 'weird' case like mlock where migration might race and we
  'have' to set invalid flags to notify?
* Is it another 'weird' case where we just want to stop GUP from touching
  it?

Driver writers have often been confused about this, and who can blame them?

It also interacts badly with the eternal edgecase known as hugetlb - which
sets VMA_DONTEXPAND_BIT but doesn't also want to be treated like a
'special' flag.

Another issue is that we cannot make sensible assumptions about flag
use. It's not possible to assume VMA_IO_BIT means iommu because drivers
abuse it and mlock abuses it.

Special is also an overloaded term in mm. VDSO and VVAR mappings are also
called 'special' but they're special in a... special way.

Sometimes things are called special that are a subset of
VMA_SPECIAL_FLAGS (VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT for instance when it
comes to zapping or vm_normal_folio()).

There's a specific kind of special for THP too, which considers
PFN map, mixed map 'special' but DAX not.

It's all rather a mess.

This series brings some order to things by both limiting what drivers can
do with VMA flags and switching to using predicates that describe
behaviour, not arbitrary flags.

It establishes the invariant that mm-managed mappings may neither set
VMA_IO_BIT nor clear VMA_MAYWRITE_BIT in an mmap hook, enforcing this by
validating VMA state after every mmap and mmap_prepare hook.

It updates usbmon and sg to mmap_prepare in order to do so, adding a new
mmap action for mapping discontiguous kernel pages, and has hfi1 and the
ALSA PCM status page map their pages eagerly instead.

It also establishes the invariant that VMA_MIXEDMAP_BIT be set when mapping
kernel memory, something that is usually the case but happens not to be for
some users - specifically defio, cmt_speech, uprobes and the bpf arena, all
of which are updated to do the right thing.

It replaces VM_SPECIAL and arbitrary flag tests with predicates that say
what is actually being tested:

     vma_is_mm_managed()   Are the VMA's contents established and managed
                           by core mm, rather than a driver or other kernel
                           component?

      vma_is_mm_backed()   Is the VMA backed by memory core mm itself
                           faults in and keeps, rather than a driver or
                           device?

  vma_is_fixed_mapping()   Is the VMA not permitted to be expanded or
                           merged?

         vma_can_merge()   Can the VMA be merged with a compatible
                           neighbour?

Remaining raw VMA_IO_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT tests
scattered across mm are converted to predicates where they express one, and
left as explicit flag tests where they do not.

And also the opportunity is taken to eliminate THP's vma_is_special_huge()
which was an existing source of confusion.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v4:
* Pulled what was 2/40 out of the series to send as a fix instead, as per
  Suren.
* Updated 1/38 to rename put_map() to map_put_vm_file(), as per Suren and
  Liam.
* Updated 3/38 (was 4/40) to perform the vma_close() after unmapping the
  range as per Gregory.
* Updated 3/38 (was 4/40) to rename prev_* to orig_* in the mmap hook
  validation code, as per Suren.
* Updated 4/38 (was 5/40) to clarify that the mergeable-VMA action check
  runs after mmap_action_prepare(), as per Zi.
* Updated 7/38 (was 8/40) to have discontig_kernel_map_page_range() map
  only the pages which fit in the VMA, consistent with
  discontig_kernel_map_page(), as per Suren and Zi.
* Updated 7/38 (was 8/40) to unmap and close the VMA when an mmap action
  fails under the mmap_prepare compatibility layer, so state is correctly
  released there too, as per Lance.
* Updated 8/38 (was 9/40) to document this, as per Zi.
* Updated 14/38 (was 15/40) to replace vma[_flags]_is_kernel_owned() with
  its inverse, vma[_flags]_is_mm_managed() and reword accordingly
  throughout, as per David.
* Updated 22/38 (was 23/40) to add a clarifying comment, as per Zi.
* Updated 23/38 (was 24/40) to test VMA_LOCKED_MASK before draining the
  mlock batch in try_to_unmap_one() and try_to_migrate_one(), as per Lance.
* Updated 30/38 (was 31/40) to rename vma[_flags]_is_persistent() to
  vma[_flags]_is_mm_backed() and reword its documentation around what backs
  the mapping rather than persistence, as per David.
* Updated 31/38 (was 32/40) to make the code more succinct in
  vma_move_compatible(), as per David.
* Dropped what was 40/40, vma[_flags]_can_gup(), as per David.

v3:
* Fixed up bug in patch 1 as reported by Mike - have to delay setting
  map->vma_flags until after action prepare, though map->vm_file needs to
  be set before for correct reference count management.
* Updated 4/40 to add a symmetric vm_end check as well as vm_start in case
  of a dangerously insane driver, as per Sashiko.
* Updated 8/40 to check if a driver did something REALLY stupid like having
  a NULL discontig_kernel_page_ops ptr, as per Sashiko.
* Updated 15/40 to trivially synchronise userland test comments.
* Updated 17/40 to correctly duplicate code to the userland VMA tests as
  per Sashiko.
https://lore.kernel.org/r/20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org

v2:
* Rebased on mm-unstable.
* Introduced new patch to fix various mmap_prepare and file interactions
  that weren't quite right as per Sashiko. None impact anything upstream
  yet so it doesn't need to be a fix.
* Restore vma->vm_start if an mmap hook has moved it before tearing the
  VMA down, so we unmap the range we established rather than the one the
  hook invented, as per Sashiko.
* Reject a discontiguous kernel page batch of zero pages rather than
  looping forever, and bound batches by the pages remaining in the VMA,
  as per Sashiko.
* Add the missing map_kernel_discontig member to the userland VMA tests'
  copy of struct mmap_action as per Sashiko.
* Set VM_DONTEXPAND on hfi1's RCV_HDRQ, RCV_EGRBUF and RTAIL mappings, as
  dma_mmap_coherent() doesn't on the IOMMU-DMA path, as per Sashiko.
* Recompute vma->vm_page_prot in snd_pcm_mmap_status() after clearing
  VM_WRITE, as vm_insert_page() uses it immediately rather than at fault
  time, as per Sashiko.
* munlock_vma_folio() now tests VMA_LOCKED_MASK so an unmap racing the
  mlock walk still munlocks folios the walk has already counted, as per
  Sashiko.
https://lore.kernel.org/r/20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org

v1:
https://lore.kernel.org/r/20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org

---
Lorenzo Stoakes (ARM) (38):
      mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
      mm/vma: introduce and use vma_[flags_]can_merge()
      mm: consistently validate VMA state after mmap[_prepare] hooks
      mm/vma: ensure mmap_prepare doesn't set actions on a mergeable vma
      mm: make map_kernel_pages_[prepare,complete] internal and unexported
      mm/vma: tidy up map kernel pages enum values
      mm: add mmap action for discontiguous kernel page mapping
      docs: filesystems: update mmap_prepare docs for discontig kernel pgs
      drivers/usb/mon: update to use mmap_prepare + map kernel pages
      infiniband: update hfi1 to use remap_vmalloc_range()
      selinux: reject writable opens of policy file, drop mmap shared/write check
      ALSA: pcm: use vm_insert_page() to map PCM status page
      bpf: arena: mark arena_map_mmap() mappings VM_MIXEDMAP
      mm/vma: add vma[_flags]_is_mm_managed() predicates
      mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT if not mm-managed
      mm/vma: add and use vma_[flags]_is_fixed_mapping
      scsi: sg: convert mmap hook to mmap_prepare and rework
      fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO, add VM_MIXEDMAP
      HSI: cmt_speech: convert mmap hook to mmap_prepare, refactor
      mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
      uprobes: remove VM_IO, set VM_MIXEDMAP for mapped kernel pages
      mm/mlock: clear VMA_LOCKED_MASK over mmap callback
      mm/mlock: eliminate weird VMA_IO_BIT abuse and simplify
      mm/vma: enforce that mm-managed mappings may not set VMA_IO_BIT
      mm: remove VMA_IO_BIT check in vma[_flags]_is_mm_managed()
      mm: remove hugetlb_inline.h
      mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
      mm: drop some redundant checks around hugetlb VMAs
      mm/madvise: update is_valid_guard_vma() to use vma_can_merge()
      mm/vma: introduce vma[_flags]_is_mm_backed()
      mm/uffd: use predicates for userfaultfd checks
      mm/madvise: use predicates for madvise(..., MADV_DOFORK)
      mm: eliminate VMA_SPECIAL_FLAGS usage when hugetlb explicitly tested
      mm: eliminate VMA_SPECIAL_FLAGS check in lru_gen_look_around()
      mm: avoid use of VMA_SPECIAL_FLAGS in migrate_vma_setup()
      mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
      fuse: dax: do not set VM_MIXEDMAP
      mm/huge_memory: remove vma_is_special_huge()

 Documentation/filesystems/mmap_prepare.rst |  81 ++++++++++
 arch/arm64/kvm/mmu.c                       |   4 +-
 arch/powerpc/mm/book3s64/radix_tlb.c       |   6 +-
 arch/powerpc/mm/nohash/e500_hugetlbpage.c  |   2 +-
 arch/powerpc/mm/nohash/tlb.c               |   2 +-
 arch/riscv/kvm/mmu.c                       |   2 +-
 arch/riscv/mm/tlbflush.c                   |   2 +-
 arch/s390/mm/gmap_helpers.c                |   6 +-
 arch/sparc/mm/init_64.c                    |   2 +-
 arch/x86/kernel/uprobes.c                  |   2 +-
 drivers/gpu/drm/drm_gpusvm.c               |   5 +-
 drivers/hsi/clients/cmt_speech.c           |  33 ++--
 drivers/infiniband/hw/hfi1/file_ops.c      |  83 +++-------
 drivers/scsi/sg.c                          | 115 ++++++--------
 drivers/usb/mon/mon_bin.c                  |  82 ++++++----
 drivers/video/fbdev/core/fb_defio.c        |   6 +-
 drivers/video/fbdev/ssd1307fb.c            |   2 +
 fs/coredump.c                              |   2 +-
 fs/fuse/dax.c                              |   2 +-
 fs/hugetlbfs/inode.c                       |   2 +-
 fs/proc/task_mmu.c                         |   8 +-
 include/asm-generic/tlb.h                  |   4 +-
 include/linux/hugetlb.h                    |   5 +-
 include/linux/hugetlb_inline.h             |  28 ----
 include/linux/mm.h                         | 240 ++++++++++++++++++++++++++--
 include/linux/mm_types.h                   |  50 +++++-
 include/linux/pagemap.h                    |   1 -
 include/linux/rmap.h                       |   2 +-
 include/linux/userfaultfd_k.h              |   1 -
 kernel/bpf/arena.c                         |   3 +-
 kernel/events/core.c                       |   2 +-
 kernel/events/uprobes.c                    |   4 +-
 kernel/sched/fair.c                        |   3 +-
 mm/folio.c                                 |   2 +-
 mm/gup.c                                   |   8 +-
 mm/huge_memory.c                           |  31 ++--
 mm/hugetlb.c                               |  14 +-
 mm/internal.h                              |  80 ++++++----
 mm/ksm.c                                   |   4 +-
 mm/madvise.c                               |  28 ++--
 mm/memory.c                                | 129 +++++++++++++--
 mm/mempolicy.c                             |   2 +-
 mm/migrate_device.c                        |  12 +-
 mm/mlock.c                                 |  51 +++---
 mm/mmap.c                                  |   2 +-
 mm/mmu_gather.c                            |   2 +-
 mm/mprotect.c                              |   5 +-
 mm/mremap.c                                |  11 +-
 mm/page_vma_mapped.c                       |   4 +-
 mm/pagewalk.c                              |   2 +-
 mm/rmap.c                                  |   8 +-
 mm/swapfile.c                              |   2 +-
 mm/userfaultfd.c                           |  43 ++---
 mm/util.c                                  |  49 ++++--
 mm/vma.c                                   | 247 ++++++++++++++++++++++-------
 mm/vma.h                                   |  31 +++-
 mm/vma_internal.h                          |   1 -
 mm/vmscan.c                                |   9 +-
 security/selinux/selinuxfs.c               |  11 +-
 sound/core/pcm_native.c                    |  38 ++---
 tools/testing/vma/include/dup.h            |  80 ++++++++--
 tools/testing/vma/include/stubs.h          |   2 +-
 tools/testing/vma/tests/merge.c            |  10 +-
 63 files changed, 1147 insertions(+), 563 deletions(-)
---
base-commit: 6b41451631cabf9ea3b384c2a099088e1598f963
change-id: 20260721-b4-mmap-prepare-vma-flag-sanify-2100425df5aa

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


