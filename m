Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0632C88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3505D6B00B5; Mon, 14 Sep 2026 11:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9176B00B7; Mon, 14 Sep 2026 11:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1094C6B00B8; Mon, 14 Sep 2026 11:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBAAC6B00B5
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:04:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F59914018D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:04:07 +0000 (UTC)
X-FDA: 85212688134.24.B94BD64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 890E240004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:04:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+2yR+Gz;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3NscFRoiSw0VLcsrcN7WIQlCyh4L7cg6MA64F9Bvckc=;
	b=uN++KoD1cZQiCYQJARkHPXJ6IQRdAXl/l1Q13aM+2dGyRLQnvgpptJajiUKKfSbw310/5C
	LXVvypt7jTMQtdbQJLqIst/m+0TOIYYspoZOfJMmv/aVCrPa1ECDoyCoh0aV+q0C00U3et
	3Tznw42pej7gXCVNLK5pVudUGp3HKqg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+2yR+Gz;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398245;
	b=1Z1okHih1InjprPCJljrsET/MrlfwbkgkU3wT81JrX9VFrsJ/0ICRIZOaa4CLUFIfQ9msZ
	8+yEZsmKc1uMjvpbXxe+tTazfaQh9PzP62mruNvPF03AdwDDCsQGTC9wtbrBm6eJ4cx7Pe
	9p6kCJhsuo0u/Zps3s5Om+0qW16JNRg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F40060252;
	Mon, 14 Sep 2026 15:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1A41F00893;
	Mon, 14 Sep 2026 15:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398244;
	bh=3NscFRoiSw0VLcsrcN7WIQlCyh4L7cg6MA64F9Bvckc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O+2yR+GzyvNY1voG7/f8ZVHT93rVxgpL8XsI+IF8jWob+9y4QJLs9WNbvI5u2uZI4
	 8jwm80J4TEPRKHMI/fF9JwIyD4KMVWTZYa9Xa1Q6jP2pjrfmh+3R5rOcDV6+tFh0qk
	 BPMaPLVOOx/1bR23u2+g31dBlFWlYoNrA/qO3GUmKZlEes/wEhZX6g937fjftPF1rd
	 Gh0nLKzieDlOC4lnc+IlLrFQ3ajJZq7ozkNKzEmlgjCgElroomjCystDaYutw8WEcC
	 pTndPiVROmqPhUP2X5CCNeqKIlShLBEE41NDxrUMltsx/QwjYt91IwWq0ysLkZiMCG
	 kTmtQdKuZAiqg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:30 +0100
Subject: [PATCH v2 10/40] drivers/usb/mon: update to use mmap_prepare + map
 kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-10-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6221; i=ljs@kernel.org;
 h=from:subject:message-id; bh=GUpTHNxmxWarSVjd88RVgsA6FQygd+NcCuy3YFJiswg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK/vn/Vj/uFpybwPt1Wx+5eeLFooMnOba09gtZWKx
 4RPk3gEOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR3GqGfzYp/OHeXgvyb/yY
 9mx31+f7vswLnO8ZVmhY2ilxTiiSP8XI8I219qVawpriGQGOdl9/i/rqzBXwj7zDseal3NpVz85
 KswAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 890E240004
X-Stat-Signature: pxr47wd83kwqxxpnirnisx4dic38yxua
X-Rspam-User: 
X-HE-Tag: 1789398245-644147
X-HE-Meta: U2FsdGVkX1+zXuukAEHVpX5XwVIyUTwP3+tOagNRMcA9YHwKnGM8mxm7kb7QCY2tr9XLlAzVwLhf9cJi3xkkfMeLdWoPQt5Da5LM/d3n2NvSieqhNbpOZ1G01MRgsgZT/gQrDNYeojk8bBb0LlKi5yLRHbJ1oqa01u22RSMGti6HhFToRJqb/sVbMxS0bdMPQyLEbEV3ibnAkhGTuJX3XetciOwsRZEmOSTUb2FEinQh77UrgjyiI+08yPx+FhGB12asXW3Dka+fKeo7SbDRmBZcDY6/xhJwHpZw7a/hHyv129ZfxRfHTeCpbQcbuA2jDWUTw5OWgKbZyeIjr1ksw4Mo/T2C3FNa4d5rEeaPlI1GJc2Vv2jnd1NtKv3X97AkLMaFBF2R/8qrAPefOHjCimn8OxPxcbU2+p55rfLyH1y2qY7pwUgLLdbRCdg9TQCug2aEnnYe0RjoK1jtq7ZcjFSL0st+eM4EV2ZdXrr44LPxE6Zju6K22KBiP3d18H8mrFoYLBgUJv3GODEIiS2Sw3/mDTWAfAWGpsyW0rXgadOMZ4BLziAs5UqmAJbHwvxqTpMWt1zWgEV42yXR0vLVgyyXjF+GDIX6ReBoAFZROTtF8YuZebyXyV9YGqv5aeiUXNQhFgxSJ+otTJWhC+lcCVwJNivniPInTYtFTJ7B7RGg9BGH8k2m4LdN5hfhZ4+MWn1lhELnIkav82tA+fVaO7uSTztm83NNhWNpzCK7w/s+N/ngmfxoxMU2EBwX/9KW17btvOrreFeFjP14z67jia+c2+dT0LJy74Eb6Sm3RiiGA0h/YQHDaFMiy60rBQzPoQjVFJQxp2nHwVWE1S6frlob7UND716h9EKeJ8/bMl/6SbN5rOW9Ca+5rEW5oymzQDtSb2nMWSoZWEkHs6rirrB4cWNtvOPoTyK3/u+9hZazG/ub1Xmayt4Kg41W2RLxZG30vd4/B0JtRfo2qfh
 k1sxL2dF
 bFO4DTJ6EVty+pR27M6U+5GUzugJZWwILoIIXuiXajtZjsPTrc3BDvVj3m27cn558cknnHWGLuJDJqeLv72UZruOBVlFPpC881SIq1K2TBuuXnmT2OUtM0s/ayUQo/xwdaSv47Ca5MvAy8biXP5h5miOMN23h3ZigwAW4B1/6I1La6EPOLh2CWrCqpk0Zq0m3y+P48utDX0LivkundAPMdNozI+aL3disJ4aFQEM6uyiPHo8/K7ksYiym1GLNNRlGwmcVKbL/DUuYLl2tsBA3+wUaGCkOdD9OgoAWpiiJ/D/Ms+M8r++5+/DHymJ+Smz6oqn+5KvRhbg/gKKhg+frlZrX+oN8k9ospSp4kdsFPMEjiXBNJIMyThgdSKGA8NsN22t9wxprQLbh1P8Ri5rQ9RspNTF5VlMXS4OZcGvKBx6d2loCL2w3PA5sLqH06u3nAgutps/MBHRUUahj7v3M3wy1x6VQHKaST+Bz/BbulDoGFi5B3UTjHXIHn46dTXVExCcmxXrHmCysqPcqKzU8rA0PblYz/2FPb5/2GEhMZltzVZ2sfXukhEFlSnIBKDhkNBEkn0aJzHszoN7w+G7qxRENoF2TnChKw4h5R7AFyOchLR0bjXaWQV7bXLAFCuJmNDUARudICJn0HoatIh64VroCR4ZuIGx+hs09rU2zGceri795xIlmd8PzhJiyfqiWTIj2+gj0o1m+o7+pEH6ozSbABEPJYcyUW8iz7HEeAQ2c7BJ/f++9RmjsdPMsd/JxOiiA+uXjXL82p1PF7PpHXdMdEkSyxFau81QkTLwPNGYYXBOvopJD0jckdKykkzr/56+Z88098xdYh3iUUU7iB9gcU2Tl8L569+m9z37N9fxH3Wrof9PLGhI53vDc6zMOuldIM4xSndfbCkFY87ixXXvSP6cFUmbp2003DDUe3UAb00lsKucAn6gtXBNaamn2n499dnSsNHg3oF/KqLDwO2ZFDno9
 0fEGx0np
 Zw7MsJyE+JI0o9tCgV6VsKPZpqq22YeYNsizblUfYLqbhszmYXmBiZaAUf3rhKQXktwpX1hneR8Af9hdz7+zNbQKwZ01ztRPdCvX8/m1dRwlyiOubUfx++3l53JQFZB2WwQ7shxdDnn/G1vSe29WUTUTcW+9t2Orm4W5jSWNPPBuOunUzA/9R37cMvidSgAwtSzJF3SLoal7TXSAxG3KJIPH0kXm8zqYVho9Ei+tC29dw4LjioQfLCPHn11goisW7RR4ZvsCEqCYbu1oaNid1jV9M7Vu+U30too3l/x8UP5vAcxevISnz+szQfwSKjcJMHesfd3SQOsl1DT7zF89KqZ3H810Xf/mmAzTnu5ofruhwOW332qcIRumMR2Oik8biAX95UihFGwaH2ZULpN/sjdPpDm/7eakF5JGWv5+mW1RQtetcVbMpzcpxiq9NW99wwj9jRTNEDU8RAeFvBYgoXtXhKrfPBRE+Sshtj1/Jqc/XGwR4oixTJWkmaagtgMdaPyoMv1XiSmVrGm6V7EWXStktDUuCeqjyB3fiTvxPHZz8emD4IPB1ycnFb4htHhZbLV3NneURMHUWLKhNg7BndSWmrMjxGdIwp4alAuMMIXIRkJLR8RSetFoVjpakLI1Edllh9OJV0C0NvJQANxy0mZ17QY92Dny4p9SYZu7L7KzxbwH+uakt9VN8NlCPwj+L+TX4wuiq+0pjw/Sd4tIAdP92mAybtKrWeL+7hc2myhg8Hep8m8lbpaQvNn/Goz0l9HVW2edNJhV4Mc5nEgIVFHwS3ujJytKtH4ufpB146HAUe8Su9EKEp8QeAiwlZ/dZG2kprCGx6wMLjOuyHYR/MibRUK9w2g284dzst6gHsd81XEJXrDNVUfDPABZo/VV2O/aroGJ96PL6NNf8kbpu30LTLJ+p/0u2w4e0iuu+F4vQM1iUJChX8xW+hzciLIBqK1x0IpK8kjExg2Pl4smLGx6Ct1Kr
 +RXIMVFX
 6zUtuf/1qTMcYkverXqJlBywDiVDSSYEJ1hVgep4upCzLY7b44MQbWBTQsTvF8jM6+F9RgNKAMPcEXo39onS6cpUNclLaG36BQCyFxGCrdZaeQITgyTySTb/eXOpOJZmv8A9j66nORdMyuH/DFBMDuP535ALxkaF7NkJ1Eb36f9fyU27V1lXHYXIl9Ia9piXjHkoVzsDOnRgFzs5YZat0i3uaFuMNSbwQkXqsBAGjF1ojtWT7gkcvAmVj6sv78RGwX3Zrq2vNuwXvCgn5iX6TS6x8fhaivRZupOqi9LSTx/+BFW7hUzSke6moz/H9NPiXcE8Og+8QkRGZxPRQVnEKbFtgG3TyctVEXC4EUgjg/oZpVfFxwA/Lr1WgelU7X3oDL63kBNcvXjnjtAt0xcklWoSDbjZlTtA61Qir9IcNUUf5aQo98vtDKZTU7ILHd5yJtts3aMTOlIBITBWWuVJG0UUvj5rV0Yf6faqByHVGz/Y4O2HVlh9DsBxvaEA7sZ1PhBngP8WN3Yr8EXmRf8U9PcgLbvUNr4jJEbjMdPZXz9Y9Fg4Q9ojfZNVNMqUx8jYyvJ0y9Vot+dv5NdqJvZDLzeWbKFsCiCW68sXJIl1KEb2Rk9cvWGfIa3GRexxTCsA42e8njrLtFf0RS412ZeT+y5Iq6unBFxmZ+hm3l5GcBbEbKyGtmDI8kaOj4h0+Qo59yvnktgTJENpU2K7TpTuRmBISFx1NHbw0sCr2F0hcbsTGqAiZsb6jwWPA/qNQ8CvtO4U1+qK+7TRVpLyHbOzjCf5cNJoo17XN8pOzU0Zqs/XfdZnehUJy+G1bTA8KDjpv+IoamrJ7jpXZgU23AnTr+wzyOXJ6f7c7Z60znpXCPQXr0M7jiQV3gkn3NwyvmdkJL0q87c4kZjpcKiymE4Fu2T5JgsPXhml10XS4HG4aCnbMJdNr64ooewS7IB1Rcgsbe/KLf6BMSOY4Eurgwk6kDb2r20U4
 g//37R5u
 IjQjlVJGn45i2h5Vqn2Lqw3z7fX7xa4yvXlx0LWvzVELgHqsSVKLosf2xpFqnxnQlMPaTDpuMJCEHoZ/JQXLaDXNQa9SKGKBPxyGJqhK+m0sl7sV+oiyvwJzLT+nZnpr3AwEWtcboZI9x9FuulsM5lXzdileIMrPE5bLYcjmSyfKLAoG5/A3Z0XhKqrDdGiZwFWKnw434MRsxtJeBcuiJ/hKbNvNvfJ2m0NB0aqSXFSArnI01CLni6YWvHUooJmelRbH+YJ7UuZYSjMOaDUcmbfanQlj/9ARqQQrBw1dN9n0jApYTNAmnPWqMwulhpVipIIV0gwOjetUO6EMweEXWWMuq/uXQMm38hthEQHQvFUD2P4BQ3l3j1QCmQ0XzaOWGmQ9nFXB8Wlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the deprecated .mmap hook with its replacement .mmap_prepare. As
part of this change, additionally take the approach of mapping pages upon
mmap rather than providing a fault handler.

The page span cannot be mutated when an mmap mapping is in place, so this
is safe to do in advance (the MON_IOCT_RING_SIZE ioctl operation exits
-EBUSY if it's attempted, gated by the rp->mmap_active reference count).

Utilise the newly introduced mmap_action_map_discontig_kernel_pages() to do
this, which allows for iteration over pages in mon_bin_discontig_get().

mon_bin_discontig_init() increments the rp->mmap_active reference count to
stabilise page spans. Should an error arise the core unmaps the VMA and
mon_bin_vma_close() drops the reference again.

The vm_ops->close hook implemented in mon_bin_vma_close() will ensure
correct reference count arithmetic upon unmap (with mon_bin_vma_open()
accounting for splitting).

The existing semantics are all retained, including not mapping past the
range of available pages, with a SIGBUS being raised in a userland process
that attempts to access past this point.

Ultimately insert_page() is invoked to insert each page, which increments
the reference count on each mapped page. This mimics what was being done
previously, only we pre-map the entire range rather than doing so on
demand.

The existing fault handler did nothing that required demand paging, and was
presumably implemented this way for historical reasons.

One behavioural difference: pages are no longer faulted in on demand, so a
page discarded with MADV_DONTNEED is not repopulated and a subsequent
access raises SIGBUS, as with other pre-populated kernel mappings.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/usb/mon/mon_bin.c | 82 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 687f6a8981f3..9d00b21a8153 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1219,6 +1219,15 @@ mon_bin_poll(struct file *file, struct poll_table_struct *wait)
 	return mask;
 }
 
+static void __mon_bin_vma_open(struct mon_reader_bin *rp)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rp->b_lock, flags);
+	rp->mmap_active++;
+	spin_unlock_irqrestore(&rp->b_lock, flags);
+}
+
 /*
  * open and close: just keep track of how many times the device is
  * mapped, to use the proper memory allocation function.
@@ -1226,64 +1235,79 @@ mon_bin_poll(struct file *file, struct poll_table_struct *wait)
 static void mon_bin_vma_open(struct vm_area_struct *vma)
 {
 	struct mon_reader_bin *rp = vma->vm_private_data;
-	unsigned long flags;
 
-	spin_lock_irqsave(&rp->b_lock, flags);
-	rp->mmap_active++;
-	spin_unlock_irqrestore(&rp->b_lock, flags);
+	__mon_bin_vma_open(rp);
 }
 
-static void mon_bin_vma_close(struct vm_area_struct *vma)
+static void __mon_bin_vma_close(struct mon_reader_bin *rp)
 {
 	unsigned long flags;
 
-	struct mon_reader_bin *rp = vma->vm_private_data;
 	spin_lock_irqsave(&rp->b_lock, flags);
 	rp->mmap_active--;
 	spin_unlock_irqrestore(&rp->b_lock, flags);
 }
 
-/*
- * Map ring pages to user space.
- */
-static vm_fault_t mon_bin_vma_fault(struct vm_fault *vmf)
+static void mon_bin_vma_close(struct vm_area_struct *vma)
 {
-	struct mon_reader_bin *rp = vmf->vma->vm_private_data;
+	struct mon_reader_bin *rp = vma->vm_private_data;
+
+	__mon_bin_vma_close(rp);
+}
+
+static const struct vm_operations_struct mon_bin_vm_ops = {
+	.open =     mon_bin_vma_open,
+	.close =    mon_bin_vma_close,
+};
+
+static int mon_bin_discontig_init(void *vm_private_data, void **private)
+{
+	struct mon_reader_bin *rp = vm_private_data;
+
+	/* Dropped by mon_bin_vma_close() on unmap, including on error. */
+	__mon_bin_vma_open(rp);
+	return 0;
+}
+
+static int mon_bin_discontig_get(struct discontig_kernel_page_state *state)
+{
+	struct mon_reader_bin *rp = state->vm_private_data;
 	unsigned long offset, chunk_idx;
-	struct page *pageptr;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rp->b_lock, flags);
-	offset = vmf->pgoff << PAGE_SHIFT;
+
+	offset = state->pgoff << PAGE_SHIFT;
 	if (offset >= rp->b_size) {
 		spin_unlock_irqrestore(&rp->b_lock, flags);
-		return VM_FAULT_SIGBUS;
+		discontig_kernel_map_abort(state);
+		return 0;
 	}
 	chunk_idx = offset / CHUNK_SIZE;
-	pageptr = rp->b_vec[chunk_idx].pg;
-	get_page(pageptr);
-	vmf->page = pageptr;
+	discontig_kernel_map_page(state, rp->b_vec[chunk_idx].pg);
+
 	spin_unlock_irqrestore(&rp->b_lock, flags);
 	return 0;
 }
 
-static const struct vm_operations_struct mon_bin_vm_ops = {
-	.open =     mon_bin_vma_open,
-	.close =    mon_bin_vma_close,
-	.fault =    mon_bin_vma_fault,
+static const struct discontig_kernel_page_ops mon_discontig_ops = {
+	.init = mon_bin_discontig_init,
+	.get = mon_bin_discontig_get,
 };
 
-static int mon_bin_mmap(struct file *filp, struct vm_area_struct *vma)
+static int mon_bin_mmap_prepare(struct vm_area_desc *desc)
 {
-	/* don't do anything here: "fault" will set up page table entries */
-	vma->vm_ops = &mon_bin_vm_ops;
+	const struct file *filp = desc->file;
 
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_desc_test(desc, VMA_WRITE_BIT))
 		return -EPERM;
 
-	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_MAYWRITE);
-	vma->vm_private_data = filp->private_data;
-	mon_bin_vma_open(vma);
+	desc->vm_ops = &mon_bin_vm_ops;
+	vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->private_data = filp->private_data;
+
+	mmap_action_map_discontig_kernel_pages(desc, NULL, &mon_discontig_ops);
 	return 0;
 }
 
@@ -1298,7 +1322,7 @@ static const struct file_operations mon_fops_binary = {
 	.compat_ioctl =	mon_bin_compat_ioctl,
 #endif
 	.release =	mon_bin_release,
-	.mmap =		mon_bin_mmap,
+	.mmap_prepare = mon_bin_mmap_prepare,
 };
 
 static int mon_bin_wait_event(struct file *file, struct mon_reader_bin *rp)

-- 
2.55.0


