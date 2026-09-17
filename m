Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672FAC982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764D66B00A2; Thu, 17 Sep 2026 12:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7157E6B00B1; Thu, 17 Sep 2026 12:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DFC46B00B2; Thu, 17 Sep 2026 12:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3079A6B00A2
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:33:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5427D8039E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:33:13 +0000 (UTC)
X-FDA: 85223799066.24.3BF80DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 72B17140008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:33:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dORD7O79;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662791;
	b=ShxhurIo8EoiKrJ5QApk0WO9iva6VyJLef0ZXTl7Z/GI/KorFTsVpJHpCHRI66NwDspXav
	sO4i9ydK4ZrhvNaaGWDDZo75/FsqpDnwOuU/QWKKWVxJ06aFm8eJORlbSiGDZsXJBiYxYj
	fFbYzokgbo2MnXJuZPc003DSgs/CSXI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dORD7O79;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhSwIhda5SwYvYTkOqlzzzYcm2yovY5S5sJ87DUE+qE=;
	b=0gwW77+lPboFUrb1vgaIPG5uD/xsCJtlDLXb3Z/qAkNPAJdWo7h1WokqfLQpD1TC/bgQuM
	DEaeHn5j7FRzhP11ykSW+ztwWVCG3dr6OU6irqQSUcCF/sFrwkBDtXqFStqKEb5kefO0eC
	YOr1bMGt2DW4prFMZyEqwVJggIZrO4Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AB0243796;
	Thu, 17 Sep 2026 16:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A554A1F00893;
	Thu, 17 Sep 2026 16:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662790;
	bh=FhSwIhda5SwYvYTkOqlzzzYcm2yovY5S5sJ87DUE+qE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dORD7O7905WtLY8kgUN7SxoZqNl76iSbnysihXhVbhCnyNqihjpgbuWeEvD8DrHtR
	 WVodMPJRdQK4OgALskdq5JZvu3vVTbo+IUykSElVIEQsK5WfJYdDRsqEcr2OE4AcRl
	 4Qa17yY9uw0QvT0CmtnX8pIin6WXIYCXqdgM8iuj/C7UIdy0rvxZVeKPzXIOWxduH/
	 qJ3+MFqyQS9eNPWEj12ztiI34tv9fHsURYZ0dMja/CqJHNwHl0v4aqyuwWv6uPYwLJ
	 5Q66wF/u62Jciqsp4OEeTy0/789oK906EC0pH0zgLzwBJ6InYxIbzu4FHxT6N3Vmhx
	 OI+lAv5iNTUfw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:29 +0100
Subject: [PATCH v3 20/40] HSI: cmt_speech: convert mmap hook to
 mmap_prepare, refactor
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-20-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2632; i=ljs@kernel.org;
 h=from:subject:message-id; bh=GNn4/WHo/gNb5sHnp4BEq122HpiBRxK72Bb5u1n+58g=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB88Y/Bbz3ie7A2FFIc1XXEn3h14VBM4u3mNre7kB
 J39f7KyOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRqjOMDMtfZCoqv1z7RFM4
 I58zSDTt2IYw7paEDj0H236zO8I5sQx/BQ/EODP1zw7cGXOHwc61ge3JizlnIh0sdj2zajyRqJL
 PCwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 72B17140008
X-Rspam-User: 
X-Stat-Signature: qutxwafiryorzuxgwk7b83zp3rghtxk7
X-HE-Tag: 1789662791-322555
X-HE-Meta: U2FsdGVkX1/qrF+4+WVuYU+effEBPbVLyOhxciOr5WBdiy1k9auFunhQQv2uo+N3GRek/KLWsDmJnOAqWZYOALa3vFp9OqXvRPk/6tNblAEPXezfVTq39i6z741SxM6xTgGNr3ga8GPiofVjhuTlZA/mO+ZaKXqft/XaOGCdFQ+bbufg5QycNV/8YVdJHqFV4LzGirIm/EFm28LOIYV8am4CpKHZ00rSCtazm+00RXgJ/yBI6hhjUlyNvy1WEY3MmwArvo/5BO9Dhe23r4/RiaCWrRYGFiyQnn5gbfJksHtZI0aP1AzsZ0NhI6FqHxs5PZDn1qNdFTE8nwB7FvibSKqY2IckdYiRTdPq7MIMBiG/FsfNnnySU8iCKpqOfCSiN1tvUXP/wbl5Z8C6YdSLY+SiZhszqJvSdOmLGPEiDLq+0m5X4wcb4uyGUwhvvKqBQuAixwYOkiV8/fKJo5E78ZkzQNHiYGVgeNarREQY/XrgbHIFtJW48XlETHMptF+qKRcvH7CrKNdyVs5fgdx5LiHwzRowR0H+Lt/jeRoN+fw9EBrvsrgJDKuJOTXGiY8lSikPJUhKr8xybXsWApeH4s9OSMA9/j4bJgfKP3c3NU5tCQNiMbgkpUc+tar5m+BofbDZ6+0PGVhDibEwA5OS9zaNpHe9JWJhnB199d4ga2ZNG1ek2hEQAZ9iY7lameJ/bjQmwhOrpSRr354heoMZ/IW4yizMb+9xHqSUYpq8AowbgqPeKrAzVzVkF3KUCoTDg8A5WCkbIq3FOoVEHo3ZcBOzQ8nFlybKQw4dlrPldthEiWFasurjp4Qi8eiDxkY80tADYOWn3PbpeG7dZvFD36qaUrW/7ooF6J57XsRpbwha/nUXxXsmzvimG3PgjY1uX9cXXXE80DwhuY4G2m7LX/W37SBMNrEeOwKJzr4i2YnmuZTf7CQS9q9v8MItBMQeXQjccS2Lj34KFf2hgtu
 VzOnXj/u
 vWlmQqLfzLXovBChASXbXHtkTC/uFpUUEPZTr5qIB7CohrIYn+BHeIS/Jv2VgfxaG37lbgMank9KUOpbENBaq0rNNKy1UrVLyV1CtplsxE4O3KfpXkxH0qNaDzzvBBxNQbh29Kg2pdCkbrZwVBdWstI2o6W63ew/uoQ6CCs2Hp6gAIE0J7WdcAWgQkwsJYU4YRyN/eYO9EUA4meRB5T+SQJ2DCXCS2ogHJdbNRDRHQXzcuEZ709XqqtKmfR0OHH1C40aGTe5ix5XWTTIO3bb46E2Zu5E2mA/9quuKBONg0ifwVVvJe42sv3PS/1QEJI7mkH7VC8lNDg4ketd+rdC+mY5L8B2I93JM8A9d1b4fjMegqYNT75sueORciGlCR5Q0HDRuN2dJ/Dxjnl3/VFZosuRIXncxPa5rEm9WxKl+E4MfGugnBVpTR3fHp2bGT6UefhJkW6/8+u89xwQxZYgNqPeiJ/rObAKp0hx4lFydmRzFaypdsOfYRwWh1IHdJZc+EWxEuBmOOovx/+Ph0SeGODBOKlJP8KhEYkq1plTN0aNDGYXlOKvOqr3RQ85O3g2JXYzmvWiauTW3fqEbocAhyaR7qySk5qrtwFE4g6wYgAawfxXlGo8b7BoxCRnqYR16njO4fwpXLr8SZ6wdeNFa22sAJrNrs7GIrASFB3a7f9oKvdfw/hLIzBGqMDgxJ9HpNDUMo6RUeURIAKu25Db8ivx9FJSu+2dqdPjiX2M57086tw6lPFCY8IjZpEY2zk/hfQTFHzrK7wDbNW6HkUXnP6vs1OcaoF7BM9LY89QIutW4RVFy/8/wXmaGAc8VnxQ464lVUg+dOK0AmHWUhlktfmEalPMDj3VsufBNXtPaWUvGBRcBI/Crd6zfqDt/jEOyLLaJF7w0hoBHcXutuchTnrbXNxei8HHOEOBI1vEocqCIPaP8hzjx1RrJmaYo6/QM8ABrXZbcDWJsaEYKf2SqdDZ2Pgx+
 A7Ql8ZxW
 72qgyyvakxcxYiRmnc1IOo7ZVvup43nFmp+iD1Jxvdo4LMpw+m86FhMn5v0f0ps83gWiduHvx91HCT4T8BwZ6OWKhbhhXYZTldE2Ql8kk0bHXD4ReeygMBoUO0gdJ5q/+n5+aJuz0nR9BDOimYo6clZ3505/cj+DBMUbTrouaMpGMFr7KaRaDDjoAHDpfEr62M1sRLa0u3QW8cRod0VjD5p7XxUFkFwLJKmxb5Qz82wufmzwEANF19LvE6c5BtQ/pyjDTdvPprGnfvqbAggUyvbFxoLdl9w8pZrA44OwGMXfUc9JjHWJzcwaFhYE47VIGjq3twwd3bIeenvlCTpNbbkk6r0cq0loa1yKe27Vbhm3VRpKFMX2/RilscWHipdSsbCsM5fdSy5Utu/xD3Qyag7lkFcCPNoBnpPIyRl0m478KIpMeRBJa519M4vI/vritFDiLvm1jCGhv3WolyYInR4wjvhcq3CnUpjt5/RtL125qTQQQJO1AG5IRcqpFyPiRkdPj+pnS8yTjXrgI1rhB7I2CgYjLFF/aOOkFifCZzNEzGTPI4AV+GqjnTN8hitGM2cpA7HU+egPM+NGJ2slhJriuuR3TC+4eDwVHGZB7FJJk46fHw0v2/aEjy+dRFwFENKiTiS7r6TIsO8Tt1d2ch7zvGggzrr2tzDFK3TQb0Nw+p1cMbthiqwcv2w4yFL6pARSkcFcAZSnJbiF0TpU26dQaGEfFyEweu8ewTQtfzpU+QLglNra0V+ApCu6zLYOQ5gTibt5B8HtOinZBXwg7/pDlQVGwzmjyg0bVUDVJ9yXecpsonkI9kH5MCiuQeT5adbRl65Rc2speW41s0JqBpLxSgOJY9ZpwkT3xTK/4K3BP/l2AA1AHbdqlVM96PSjvyeAMtR1bwx1gXFiq20seilFmxTgPv8e22Agz0/HAogzJfap5iEnRRsfjvP8LVxVX2K/S+OBwWikhGErQfVM2XSS9Xxnv
 H130mkwN
 gs8gQlZwBTPTtt7PhCfSh+xNClloZFW4TunprATLWPWe72l/CxxnLZfecT/XGQNlO2iiA9HYQN7xp1CD0mqvuYLjaxYR4FCFm0lGHR39RBG6mW0zUIP8pEZVa17DjlevjsWBQR1nxbuWBX5aSEFAG1Jcw7gB6CnqciZtigsxjLMn5RgVuyjuQtwBFBMbVLRm2PZ41M3xXxk+XKc+oGNadWQq7SnT8WTM0HxzmoPX7q9bf3p3rLfu2cFeuLyGkQS8tSNptKHozXHsL4opoWVgqqUs64mSaoCcTj8XlfOa7v2stvjU45DIyoxtzRrQWMLcjRG3fKlx47x8nz8nLPW2DwoNeX8j+27Nr8M5FiMBuLqy3SEZqugtCc4bgW8hs1zDB5y3y/J6CSq7G8GSeWHr5+wmZSfgNQ8/+z8ry7XwAS/PllJ5HimjA5W4fASqXVDUX9YHRL8iHzLcoRsW+Jx89UXKPQ4RWmfJNRk8DSRyqbYpPBx1QKfUXv9nP0EgR9UfvdnA6v+9NM/QBSNFQa2XpJ3Fycja/1K/mn3Wgvjamj+fRXv7a4RH325IYStPOIczMkmdJkJN+n95F3FxKBGAME4ce7SxsGEA/MEWLljj6io0ffTVKnSg6Z9qtGEsi22IPpoLxDiWJR3zI+kEhNIh5qIEdQCFO31FxvgvVIjhfxJKPGU28O0L65+g9SwEuJpUUGV/dwKV7tErNIXES9rFlqPtYNgjmDqJc7dMII4mxUnGULq0DEqfEBa4oYXt3BL4nprqREgZDb25GmAYI+YNHeQBRbMO4kjUbJgM9cT5YEO2cCl50icvIWRa2zflQYvbgLQWkKIJjT6Zqt+kUU/uBG7dxFdlwHbHky10qqG7GNBcGzfGBOalFVs0nmm1oX886hy2FRkBIR1EWvOY7Ya3w07G3wJegwI4x2/08v99ctfHEHpQLb/t5Lsy/apzs3zCPEh18TrMBEHEzfWNTGkXjoOoZJJeD
 5VaZnoBs
 8usBwAulRZZRwrjqfOcU3hUMhuaFfMwJ1B6bFeSqrsobIfm08H5mShvOLWiccR8OFR5Z6T1DHqTlV99K3Cl8+4eVtWjoFEhhRAko62FtfPkTaLj7grH8NSa+uvz/8ZNA4V9c8/rOicFwcC50cyZf1f9p1eKWMVoyh2HrOA5gsTMWhXZ96zP3ob04Nlfx8d4Ad2Yzp9cN7Nhm+VSqAXGJ7fhV+EG3J4Pau33Mowu/2+R2H46OOs5SF+bah0SvdO+uECkEjsaPL8c0lwEL9dbY4Fyn7upU+wWxicmFOvnMSJOoe9a3rWZ49xaMhBn518WBWv5haa/lR30ywzs2A9yjRB9/AkzLhHWzntgTq1DRqGzCx9Yw4ERKcbF3MbJGswor0eyO0OA1XxR1MlPIuOW8xRGSqT8KXHnS/namJCPeEyqkpXZzshqrPKKV2VCEydLh5IrYxsZze14Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the mmap_prepare in favour of the deprecated mmap hook as part of the
work to convert one to another.

Since this is simply a refcounted kernel page that has been allocated, it
should not be marked VM_IO and should be inserted using the kernel page
insertion mechanism, so convert it to do this instead.

Use the VMA descriptor's private data field as a scratch buffer to store
the page in - this stays valid throughout the kernel page mapping
operation.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/hsi/clients/cmt_speech.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 7226677ebde7..801697b74d4f 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -1084,22 +1084,6 @@ static void cs_hsi_stop(struct cs_hsi_iface *hi)
 	kfree(hi);
 }
 
-static vm_fault_t cs_char_vma_fault(struct vm_fault *vmf)
-{
-	struct cs_char *csdata = vmf->vma->vm_private_data;
-	struct page *page;
-
-	page = virt_to_page((void *)csdata->mmap_base);
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
-}
-
-static const struct vm_operations_struct cs_char_vm_ops = {
-	.fault	= cs_char_vma_fault,
-};
-
 static int cs_char_fasync(int fd, struct file *file, int on)
 {
 	struct cs_char *csdata = file->private_data;
@@ -1256,18 +1240,19 @@ static long cs_char_ioctl(struct file *file, unsigned int cmd,
 	return r;
 }
 
-static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
+static int cs_char_mmap_prepare(struct vm_area_desc *desc)
 {
-	if (vma->vm_end < vma->vm_start)
-		return -EINVAL;
+	struct file *file = desc->file;
+	struct cs_char *csdata = file->private_data;
+	struct page **pages = (struct page **)&desc->private_data;
 
-	if (vma_pages(vma) != 1)
+	if (vma_desc_pages(desc) != 1)
 		return -EINVAL;
 
-	vm_flags_set(vma, VM_IO | VM_DONTDUMP | VM_DONTEXPAND);
-	vma->vm_ops = &cs_char_vm_ops;
-	vma->vm_private_data = file->private_data;
+	vma_desc_set_flags(desc, VMA_DONTDUMP_BIT, VMA_DONTEXPAND_BIT);
 
+	*pages = virt_to_page((void *)csdata->mmap_base);
+	mmap_action_map_kernel_pages_full(desc, pages);
 	return 0;
 }
 
@@ -1353,7 +1338,7 @@ static const struct file_operations cs_char_fops = {
 	.write		= cs_char_write,
 	.poll		= cs_char_poll,
 	.unlocked_ioctl	= cs_char_ioctl,
-	.mmap		= cs_char_mmap,
+	.mmap_prepare	= cs_char_mmap_prepare,
 	.open		= cs_char_open,
 	.release	= cs_char_release,
 	.fasync		= cs_char_fasync,

-- 
2.55.0


