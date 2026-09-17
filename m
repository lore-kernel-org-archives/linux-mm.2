Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFDDDC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D93396B00CA; Thu, 17 Sep 2026 12:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6A2E6B00CB; Thu, 17 Sep 2026 12:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B116B00CC; Thu, 17 Sep 2026 12:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A81276B00CA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:43:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B013C03F2
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:43:03 +0000 (UTC)
X-FDA: 85223823846.03.E40C8FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 637581C0004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:43:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VX8sd0/6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789663381;
	b=YKPVl+OU40kQQxScaAvhZCix9gSty1XeBhUpGztlmn2cOxkwSZyPMRS1tUjhv6y4yob2oV
	y11zvEjA7sV6k1hY4vdVmybp6+T/TiVTTYCWpO4KYltTqZ5RrVEMzbgEfYW/wathYPK3Ls
	CnsO6r/ZXyS0u8ssxB2ddT6m/mGRJ34=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VX8sd0/6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789663381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Dab/JGj5h11GJwmfZC2qp9KBu5kIrwqs5kjA45qPyk=;
	b=Uml8Z62bNN7HJOvLIna45ido8AqYTFcwIG7yM/8oAJGiMFFkK7WxaFYXw7/2mU5WqxY8/Q
	pl/9dZJ1FCNIC97/IhA66FFnPRj/HbmBZoqFgd5WXrNrM0EG65dmRVbgILzSP6A/eqs+pq
	OIeXueX+SK9AdpH5riy2zoJyyf5F07o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1EA440AB5;
	Thu, 17 Sep 2026 16:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A367C1F00893;
	Thu, 17 Sep 2026 16:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663380;
	bh=6Dab/JGj5h11GJwmfZC2qp9KBu5kIrwqs5kjA45qPyk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VX8sd0/66chGwBSXTRN6xewgRxbkdbYKvu8TXFtU97j1gbO5MtY4GA3FuN4pxa8kQ
	 sJFEbTFNFVlyAMa8Na6QNMRSq4oSA2gdS7Gui7OgLAi4IQQEmsyqhalKYGXl/bRxNX
	 D/3ycl79FQ5ht15gqYWhPEtIXytHr54JCpZjtE74fYeYcilBPDWfVgMKr2V1oU/68Z
	 G8QA8UvvCFGiQf+kJvlF9KEewMqtI6KFQNL2DNfh1SCDpC9shan+s0AyJYsTXjtS55
	 kKPDtzbkzQHcQvlV0ZfbpqeyZW2rJ1hQkTlYasEVZKlfMcTqdFSz8jOjTnyvV7i/MB
	 wwiohy6LPq+FQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:48 +0100
Subject: [PATCH v3 39/40] mm/huge_memory: remove vma_is_special_huge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-39-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2897; i=ljs@kernel.org;
 h=from:subject:message-id; bh=2A3Cmsn/41H3VCQe0yUXH8gcl1gq+lw+YTsrD11Z3Vo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB9lesOuX7ti9tWy2c9VHG+vaQz+v+5YpsmCpzf36
 +yddNxVv6OUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATSSxiZPgjojDnQIHWZ/7i
 7KigVRu+qSZ3zDwz3WZ1X3jD3fN2uzkY/tdPWPJHbRnXvkl3jv1m+3NH3lmwI/DhuRfzVp0wPNM
 WvJEDAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 637581C0004
X-Stat-Signature: cj9193ybryhgg7itusosgtofuw9w5ze6
X-HE-Tag: 1789663381-334874
X-HE-Meta: U2FsdGVkX19QpWjtx8ki90O4138f/6sxgaLm6R+kT2ZlvUX9N73evEoQaHZi1LiQtJa1AbesYwZbQdtBXvsKuOgaI2f3JiQMZpio7gzduof25sNmE56848d3ISVAXUCyzalppYBX3lpnwxUf9VQ8x/nd6UxdP3N7XaNil37oZvWKXUd4qgvKLq0/x9TixoNv/0Z72vMtGzkjG0wFhR6gHGy7PBBt/Vi4IEepZhCxa5UrEUIbL6I8ASoRlRlcZH4uCzvL9cek1G3+l/ctVhFiAGGRnB+PgyaECC2/To1fsU7DZLlzpYAHgqg3Poj2ZnnL0KBKzkBXbiH4lA7BV/+c5MmbzLEW9iYnGNx4+puKC7D/JLgjdZfFHJ0t4CpE9bfd3dw8nWPnfX4DXnfS4izzmSqqCCtS0AU0h4SbAdCT5EiGx75/pBDlIgM6deTJUEZr8Ir/t/q1kRn32MBt7RSza62RCHElwImPPOGLYzCs/g7bWyKqzFaBZ06A8crDzfjIOaBNlkJShtJep9CqPnAWA9rEPOBd3Xm++ar7bkunCnJMz11QTfZ4k/F5kThLoQqifXKqg4kHHdUUMCDyUDGEzNK+ck6KGloZuhlnxYtNOiR6yBYXXgvpeB3md0802GzcQPvdvJ2w16lCIWqbPcVNOGpxnyO+J9CHkU5EDzSZ2/qS8Kdi5UNlwuEC2hqB6ZwRIE6I879lFIj7tg24wE/jUH4LXdj4Znt5perFOBAIdNiy9dj7Yc6WL/YOV5z+WuGlCuQpSDYoJYVQXcWtr5cxWK95dFOoJjjZ/y5JEHJ+jRedS/H6s7ExRVoT97LcRoElq6enueGNigZ6jdatZiHkW83oXJ5n4zOF9y1fcvMCgl+jkkiWucZ0wxJBff6LRZX13rAERJCmmR4WIyhVGxLZ8QkxUqtfCp8NuzXL6cWs/g0D7dr2hBOYWfpJXh7cleDj2K6jj3VC95GFEnRY+nq
 k9b3uQEz
 v0NUHlF2GhdEO5fqFq+9Nr12jrku8wlevDOEzkrDxwuhzGUrZ5RYLhgEKWnSYIYnbYFpFAWFL4AvGK1IuWmuNZ5WGLd1ObISrtTNdVVXRSMo7nAeIcIZAOeOn0jzUebSLpt8wNVYbDJvQ0hVVWcWp8JxSsaJQaGQZr3tVyAuUcL2HRTs1v82qrRC+VZ3TCraZnahnpa5+Kkcb+7I9beE45Qw/JO/24a7hG3LiJnXLRVFLyxA6wdNXAjjbc/80Ek2WGK5CE5jFhkHMSXCfkGtyvwOBCgENiF4sN9P0jGQaDgLu/rvTplnNam2qK1jo8FfySWCLg06sU6C20qECzbg8b6XUO+SzFbOcY/cK8rWa+WxfR8XeMQJSfkzxOY57sOSiff+iHIJ7lzLGoTd7/tV8d13s7XyuISEYmabN6P26cNQLneC0kFoE0iZ/5ZPSEYzSgAsp3N1vhBQW4WrhQQ8JN+irpayatUsfzmWbhX43azFnQpA8gU7xlJavXphxhsC7iJVS11oy9/p14XZtx49y3gl4QKjDOyp8Dt18t3IvCu6pHNBLDcZxRZ1b9KOSGDn+j5INhGQxjFwiNC2Gr40JLRnlAL1JSd169p+vvHMlsF5iOliMsHxFMKzO2PeCsw8sMDifDDtBOpHdx1p75Z5QO6t+Z9NbQDYgSGSljBtHtR0b3g7AgmSFHzgh0y28H1gRevJJI8gVFDf+kGLE0kGN0O2G8zfTWUa09LDU0Hm32zQrTtey2MTREVNTI8c8oHswiG0pBjo4RVmC6FjNUkYxoYnwIlYAlbOUxDG8Yk8HoexiV+PlyocQQRC4snOEBq3cjh80jQCgvbOi1CegHX5hXCWyyJbnUHTtCvLzfJp5jYz1TX4T1qJkRF0YKYpdab23CNFk0uaebG6TgRjW3rp3pMIv9mNzNAPlk6JVEku/jC6TasNwtpyKS0n6DvQXiWlwSxgE8Ajr+UOgtE6KhlKQLyHjHFpL
 1h2wG1Ex
 PxwuDc/GUIvP0sdN6yxh4DoN/Vq3Jubv4a1YBhIM3eNqa6o/fMiyx/x5it9+bZ2BHaq+u1hOqTZwKns740OuVoMitaV7z54isW0f7kWXueU7pdW/SiJpX3TiMHvsu47Mzgk5uk10XkV1Av6tTqvEno0TFZAjY4P0/hrJWPrmUX87QXrITCCTv6jByo0CqmpqhPI0kjucKGOjfiVuKbKZNr4t3yg0CWC8p+m56b0vCqcVohY1pHJzU6yMgXnw06zdUeG3dEeR/6w2w9sdsI2Tzp+/PCqeqNqL7AWdZxi4IDbDEfFex+XyfMV8GBtarZMjAgs6Qw19+LJHkPfkVgntOccLOXgiRmz7uAn/HuYk+dy2hbcqRQnR5tQ9JvcN9pSCYfd17p481PDshvrt3EuMGSUUiacnqeps1WucpH1fDJkO4H8x+P/z03YDdMzlpOX1DmkT0JqNxJesIRP8k3TUnCXxlfitLQ6dvcEE7pqg4HidfTiqqaGX5uhk9O9DU4r6LztHo1AlK5oZKS5eT5r+m7lmzj4NkWjTLBVt/rLkBDLXjvWYzB+q10t8mN0q1jJGnNUra7CDFTllicreIMA9QOejFUFdwmXpPisgHZ+XwwieOhJqHO0S6B/jI/TZfQTGVpczINNDGVNVDV3OHFINQ9K01/9Jlz92ci5rSVYpSRbshBMpQYTiB7ncsu4yF4oIPJlfV4wUgMnFS+IzqMxqQwzu5bZVRp4CtU4wYGnQyo759Zo1bCXowSYpVqKQuMmyUJASuhwm9bhwyPO4m1pQxbxdWX/oiy0GnOCemmRoWinZLlSs8M6ZlplB7ovHvteqQXN0rav/PivLwIR/o8CvqowhxYG9hLS42xz8ibNmSb5JpCh0mP8+J1WiUd3LQ0Lnrn3iZm6ViUA8Y3zngd6mIjs6pe5DmVonz+iBaQSY6sPF6qPqJ3Dr/U4gQp0zv02Bg9LwcurOYIzL4RErF222/3sx13B3j
 KUAIADTu
 cpbIBe1NTmNA4rS6vML7DwaQtETdIrZPgSGy/uJxkvLMZzgjgsE/iO+YSsv0U79OhTAC6npvGbrH2sxbQrh+LY+f7X7eCUCMRakKxlXuwWMZeW/5RyDTBgs2m0WWsPud1lKNTQXg+y3M2agcP0C+OdP+8mpN6xBsAK7W0vrnbhZHf0qtQrtwxZCfZUghTXnnLzzc/8IV4OzNuz4IeTaGoXR2MdaqlC5wEjw6W6fEh3UPhlYBihYMIYlZmzUELegH2WpGu9fKkCw1qcsGhXOaLZ5m8K0rNUrwJYTK022Etu52AKUHlA0GAzPm51vcpyzO02TG5/SFWj3QTEfQY+U1GzG2GMtfVUJJ/NDC0cdM4X+WeH5iaJrV3yuVvRj/pcMUTg5FI/ft+RuCEKGpSNvngkxg9RCSGUAGPRWx3aqwV6TMl/mZDg88113xM4i0VU/JEridUATlTGqueMISuLSla74AR2gBfUE7hjKv/ATXj4TslD5dh32Lm1CsqhwEIEHIblWfld+uR2x6UiwhXbq+Q3nInMNnBwGBaZMB9Tth87XX4nbBZEGsKmL/l7+WrRNdQNUtguCMAFVkgZX1Qr/wXxzbie4/2TaKI9JQXh8xKxKsiWsAN5rEPVUx/M7VDctWvsFgqWp5JTTL+/2eZQwyLzfQzZ4JeEUr1mzH74/o6gmQtVjvNni0T6+dDz4dEhf8xzg90g8QOlnYQDrUMjO8P4Jq7vk+dc/QZ4m3WYeKy0jsiAZzFJXBVjgUENqm4RO4YvRTYEharqsMj217iWmklKI+UKk4ISMCL9PxUG5GUBbi5nJSO4DhzUy3oVi6+UqHvbwpbSKkJ4sr7bgfkR/sjz0y3S1hmCe780jBdoScZBZSRaknIvTCmk6sfcYEs3Ec/OO56fuwR6HiI+Ej8zUhe/R6ma1JSul5XtoarfF68AaeyBzsCuDbdyoNPSW5BcnAu3FFgAm1tYn84l383ys9bZGWwlRRR
 nd8coiPf
 hENhNU1EvGZF3X/aEasZUa+JBBNeFdyRzBTpj1Omvqp3CUQJSo042TYEXjltgbcJEFV9wvYO5XLGf08QUDb7vxb34YBjeJdplpm9aprxhd5i4JQ5PglAeJeoTNTWJhvoHv1XotvYo6T51uk5M17TkhmsucykDAQm1I4pfch6fTynJdCqWRnSXF5aAPhTy6Eq8Yog16TfGFBXRB5bmgxM6pKPnNYbr8RAUG6If3hIQtR/WNlwCCXe9LjRUYSy2usDThPK70jvRvpOlbRAlNN1oCKNz1Mrn5otnt3XAxHYZgI79HGTjBmJDzAyL/LTOCoti77Xv4X8IXBrwfJ2I4yNb3K1SnRosNMKp1gn6+dV7pcDqbiKgxV9uZqqVxdf3ZdlRuNtbN05nk+lDtCmk5UFA2klO5caA9CJ+rxdCWc9iZhkP6xQ4k2h11cqVRTITeSf09f1bW7pp3rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is a kernel-owned mapping),
but with a DAX carve-out.

DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no longer
required.

Therefore test for vma_is_kernel_owned() instead and also drop the
VMA_IO_BIT check, as it is now redundant since it is enforced that only
kernel-owned mappings can set this flag.

This also eliminates another overloaded use of 'special' within mm.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c3c98ea672c3..3cb8e2d4d65c 100644
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
+	else if (vma_is_dax(vma) || vma_is_kernel_owned(vma))
 		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
@@ -3066,7 +3058,7 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
-	if (vma_is_special_huge(vma)) {
+	if (vma_is_kernel_owned(vma)) {
 		spin_unlock(ptl);
 		/* No zero page support yet */
 	} else {
@@ -3222,7 +3214,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
-		if (vma_is_special_huge(vma))
+		if (vma_is_kernel_owned(vma))
 			return;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
@@ -4765,9 +4757,7 @@ static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct *vma)
 {
 	if (vma_is_dax(vma))
 		return true;
-	if (vma_is_special_huge(vma))
-		return true;
-	if (vma_test(vma, VMA_IO_BIT))
+	if (vma_is_kernel_owned(vma))
 		return true;
 	if (vma_is_hugetlb(vma))
 		return true;

-- 
2.55.0


