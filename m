Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26A55C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FFA76B0092; Tue,  8 Sep 2026 16:19:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7E26B0093; Tue,  8 Sep 2026 16:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C6016B00B3; Tue,  8 Sep 2026 16:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED4996B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:19:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E57D1C293D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:19:39 +0000 (UTC)
X-FDA: 85191710478.26.64AE503
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C47D780002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:19:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gRKBNnJJ;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898777;
	b=IFH9pqeobC86pqbQBuZbfbthhtRR/nZ2S71BoDM22Tm9KbL9W1E/HDW1huGgGZQBIrP5T2
	w79OdeI1OJRehaEzTf9KIw7I/gLnL6R3dmhdMwNmk/YSKbe7JeIxz6I+HLF8g/nhgi84Hh
	yOPWcrY1O+kRkDSEiLLh4F935VzS8BE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gRKBNnJJ;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xaEH9s0394VnHAUaB/1RjJOd4x2IZyvIZAfGxratmM0=;
	b=rU9xnD9k9LL579eC5aLBATk1Zc/FvZoI3vV82vq+4zVpYi+xgoDx3g7H10D6eeTwM/HCfw
	PzFWkF2J2zVwesJGi7pW70iy1nP7lAqkXJD/RKoTwTYcemTBvg1plBKsfW0njNvx4+RBKX
	US4wTMSHWMtlZMLnU2wtYYFZB+LjbLs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 197D84039B;
	Tue,  8 Sep 2026 20:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB871F00A3A;
	Tue,  8 Sep 2026 20:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898777;
	bh=xaEH9s0394VnHAUaB/1RjJOd4x2IZyvIZAfGxratmM0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gRKBNnJJRHtxe4qw4P+kLKngn7k0FkyLX5IKKgFD73pNGeVNwWz/N1S0Z2OZh0Kd6
	 lzMdwxp3HZVOsNFt5P37eVI4Mdak699X/wWJ9/aCl2v9Plga0u62hPw7JluK4xNEhM
	 NbEal2VMOa+wLil6Mq32V0b1NBmsWbGifsFFLaCnEIoWS9mmYjk6uv6lr5uiYqvvuF
	 oI8KVmkDpJ3xyG6ktJ/dwHjaERy6tm8OywQe0iwHPYevEq7/7aKEs5n1Fe7FgkVOGx
	 qi5OJ/UpXbASs1Lm9FzuHeecPsW31A05efDwIhZDQBrxXSqZWZSX1dplv8V+1/Q08H
	 H78RamrKZXtkw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:40 +0100
Subject: [PATCH 36/39] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-36-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2135; i=ljs@kernel.org;
 h=from:subject:message-id; bh=WdrPDwIiJWyraucoH4JeeXWA6KhoQfToyMCGWnY9BCA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG6b+Pb+phn/5szf/a/rVOl883DNulb++I77Uo9Yr
 nOwTDJt6ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEJHoZ/idmySdc4mV9Hce7
 Z4qvcOgdR9cjR+e871jnX6GtEyfJwcXI0FFncaK8Olj/kvv2z52WZyYXqRzsqGyxP22v/UT+bWg
 tDwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C47D780002
X-Stat-Signature: 9az3pgubww5ns65315rscbejrpp936yu
X-Rspam-User: 
X-HE-Tag: 1788898777-719198
X-HE-Meta: U2FsdGVkX1+Mk+Ny/G9EnE34YEEtSZd3a6NPgjz5dBzCxRmbD5jiH3a3AYBcdwcgzCN5lgDH6Zg91dUO+QXdzG2VKWOWWeoX/1LVyuLIDHg8PfZLRbkgko6Vn9PGlO6IrqLQ+MSSvcgfDiseetTHnQPYM28fwxAjILLZHQcdE5H+3X87RZw2NKysfIDlWotp9WkDqJGUI3NkhEpfEH1IW2x63rASEge5AmmjYZS4a5AGg0TkfEwAPV5wvBsPqZrz63asHceSeXnAPYzzIq2J6kJ4tXl4A3LIHxNUBtTsADMMIR24pJpYFZemhN0fqcpxwXgJMXuNf4BZeyTZ81Eyv07TqSJOdRdJ4s4GCrc/YjYPPrYgMg/UkshL+DlDcBhHtJldgIEn2azaZqfqQYeFZrf7AVgnkeSNXCf+OxW1oUhmQBrZmxXQamnoFLXygGKn8K5AxdQtImY5Tvgwmta3w5mP2h70QpysPWKFwcrAOkJN1PsSFG9YdQRSPAbuL1ZKVcB0cNAQXMJ7TEKL4bAdYFjygbaiU9hZaEKFb473GWcJ0SB6S3vCrPG+VDhXMV6c3M1kZ3R7uUk3l5x31Cimx330FvxvSMOmdMiWsa/kqPg7FHFn5bEY6GFwUfknmGh457JsI+j+2xwCBUp/+Vdg9UZFKhqDAgbjripkUJfzHr3A36FY5DxNrBr06811jZyLHxV30E1ZJ6bg69nTLEBrSjJySIZCQ6JKZenO/GphxCTincKKIzEB+IdkejJ4lJxwS6FIocXJdALptOenXnTHNamBfc0MEey7p93j6Fov3FBbeKXde21NN9A4TpGRlGjHbA1i4+CMfbbToOgxQd/YcBRr+Ykt+4NjjpP0PS4iaLInSbGjlp4DWNebGqDqSgPy8az36cBWrejEsfhMoeN8K8vByoi/YAS0KgSXitsucS+vZjY3bvEG9ls/YgzHSzzSllvGDdT5EOVp7u4G/cx
 NcPcUNU6
 milV4i5hqXI2psm/F8MzV+mGdYusNwpCcu7xGkd4ZF3YgabWKBCVPnPATaRxxriwjJiDTO74OG9cKui2cHvFPWJ1bPPIGC4jRxYDU/6qjn+mU0w1+sRNyF0FBWOsYJBmmvYcf1XJVZYcqnFCowNzfjxUdLMYYknQF0MuGLKy/GsOlxe0Ej06B1wH0yhu/sHFqOpDJRjS6tU0Tp5GcXW4Ph326DO+U8/gXqKuoM24lYJ5T2VsFKHql1yq06I61pUr0XWj23ftTlmLCDhWxlbGD59jRKAD+IXJp91Yuru0mFxjegPlt3UtpOFmiNczPcfKLLVjK1BRwD51/3E3CaTdJCqsr2RDzClQ7ihf8wuhnI6gx9b8U8XuBSvtThqOvyFFF1NcBOxv89OZ3uIHKFCIvdK5grctnYvbiCS3tzqgA5BnECEL3BGf6v5uCo990UH7g4IgbHsQMNNrnJqmeKnKy5c+L750R/qX+FL7Z50zZUZvP8i0fYCTRbVh5D+hOp4QptjB8qPYmy5y8m+8zMVfKnwStKsrADYRtroKjaGH6W+vT86hZtF/0ojkI0USn1YmZ+/yXIB9F/5Bx4mIT3DkwJHGWYszK5msVnF5oF5PuQZEXj04op7WrzQHu+6KnpfCUJ4sBoAyxFD2MY5QqrnXMg44c+qkynosbkBDZav2fG75SZ/aWRVpdqtDoBWUAXbDSHsjdMGYmAi7XhYsJ/U9BNUrFKyOlN14fCPA8UpEeu7wPwnGgZhkX2s94+17rocg1Z22wn6//KhGl2Oahn0TgRYEOXUL2SewZyra1lG4fqLp163g09kDoP3gXz3htomAOYOD/ZNo09Ua5uFJrU68M3NKm829tVv8q6YShviyD+VmqFt1UyldeRKJyqJtE05sWbeoVvn08vLNb1iefh9rcKOsQpXWjyJG4TTtzQHPovbX0dOogtX6zSQbv+nXxIrw6b8h7+o0josVj2RGNmHUjwzDlpDi8
 +AZifahv
 h7Vikh1wpUk8xCkZlhW0xyirCwo6JrYI5aZxmWIGXle6Y3ymQTsNwvF6dCWYPhS6jLtBcdD6Of1lPws3C8TZm+yf76Hc9b9I+MuZNazfbT6tuEOrM8LEcXYYonFBw72w6OJk6eOtQjpGJMBwaJQ9VzguC5FakF6eG8s6qyp6rZ20dK640E1SfJhYRPKE3e0m8jQ2euXMHqcQMYEmNl2W4/X9vRUmEbSrZlC6kVsWje43RNzUWRMomYDpNhu+j/wfSCE5OOgPwwz3maj8Bx3fzpIr5flnlL/Oek8VnYR07y47LtbyITsJe4JXxenEEs0+xWB8Wqll6yJnROgjUc+oK6eWIWWfAKONysywTdnHtNyepHxkNQRMqIre5rcpngyl5RdBWkkR7cSh8QCi491CsTW+9P9MYwlWe8me6DJnyg3tn41q+uGLrKBKoCoRD/v0k+V8D/hJKhrKPnWAIT5QQeEbKCsy2ojgKtwvIA1JSv+2PRIVHTw+tQga8rLtHn0P47t+Re2j9IQ31r57YwYUsf1FfIk6cEz3tbRdQQU/cR7odq8eZkLFqf+3ke+HrWpP8YUtyQS7d6ii8ZallmX27J/R6g66HPW+u+u8WlhgpvnO0G+A1/yc3fAIXLbPuzMhT0JrLYxG4oc69JRtFWDPbGG/C4ruyP8dJVzvGYwLAHC4hNz6hKcMGiU2NKtNGgTwvqfA4c2wGx0YzHFGv1insTmDyGFRGEwmtTaSd9B4WzDHt7VVmCAz0ySjFQ77AzseDc9OUC1yYdhuc6CFCVZiPaxSXxtu8JSuaNpWOugeJRM8cNn2H24P2csNy2TxfocaraJ1XaNqkno92n3sbngPdlBRIuV4B2MV+7T3hbF8nByMUzfEuS2McdxxgY7ps5INUs5iu2ysn2uuHytA34RssOzNRNx05bXlRX5KHsaEP1EwB3o4M4LL17iRyQOpu+a2pr1W6djB9nSnyV9XcBOAULiDtDiPt
 miBCwBel
 Tc691Ka8iLDjGWoBE3d/yhdMi2d5BaTSSQUeh1jk2XVxlCJ/2NHSB+ngXnWj2zaxCZEEk1vQYx1aK/u1IJcfwXXdJ3xWJlY+HuVyFevXlI+AkhEK6UjwU8ep2RupoW7IXdycYwyCH502dTCkJstJWjwv+F5WQ9DStGfgZLHfYZJQYY1UsNqQ0NVPYWKdleF0yBMgKBCQnpo3SIci1gFXJKIgZMgX9xlhJlgezH2ymsVnwtkp1iOGOqTUSJak9TgAivCL598a7IO93WgHC1FwPSfsCkL9P5HnknyLxaEyN5TH4bR77FS2lZ9NspIGV6H9OmGn2tQmkTIIRa6EsaFMxETYdlj04zBMjxuGKlP46dcYaxrpZFgMKWTdCIBYtw41vgryV/HQphYWAnuJzxGDUfNGd5ZcA6k7FpnFBfeRhJu2LOOJ68aU4NQq9SoFzjKSL+RKMvXWZo1XuupIPaNk3kdZtiIiVPTqIAHUsExJWKeXwCiy6CGJ0Y5Kusbk21lkTTfXxy92yRp9e5H6Cmp0mR2rOYZL6+M8p/04k9BilOOQRUSpQsHCVNsoFayCzruXildhq0QH090nYaVQwqPaPa9yfux3gitMQgfGbuTqYbIMS+YmgOaER3aGC6N8wA2VFgf+wfN+VWYhkxJKQjtKDwO6FMQJQfuBIo+4ID5kt2RfVz/rk6HzMFbz63we5mk1KXaN1voHCXj2DQw9Ay6uOLVZt+jjdj3ZzWD04/XhdnfP0Bxx6BmClOyvqK3hMvraHC2mhEqtU72mpeSePTIFvGnJKgkEPvapvcSXLQP3t+2cBQSuHdnQe+B6hAyR9uvJB1+IiUj/tKtdh/pjIpRt7LrXhqGNMDh6B/izPXjFkURH62nPAfoRDxPK+tN6pAN6khbrOWI50Ux3ndN4MPYqw66IlV45foh2b4g64JkQzHIiRT1hIoof/E6nXIfqU32bhMTo7Wfvsco8h3akUUu5Lfxv7qTPY
 GK2yd6XH
 VjSOdpgMhj84jyD8ed0b99r7WAg8xHzSyh0eCCDCt4q6h0K+PGTFODXgO8SDOKspGsYdpQBeBLHE1BAJ2spg1mqTZ0IN4Wj0AfY2YOy8oha8Nf0ix3lteFaqKlNV9QERBbPEsbj2lrSzNLwIZKS/ouVgfI4V6VWHUXVgzRgnOIyidqKoI73amG/rqgMu/kUXm1AHDbCQEqj8HlSvZdvLTiAivBxu0JuDyCl2chLwSgVrQw9ZLnDFcElVP/0TR/3t/jUpu7OZfjV4g0OFyDXX7uHMAo6WBFIOlomkgagPQKFrxCgXfkUF+Age3hMqVtGITAW4/ANtjm63e2cE3LQdNf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted to
predicates which explicitly express what is actually being checked for
rather than the nebulous concept of possessing 'special' VMA flags.

In any case 'special' is not so special a term of art in mm - it includes
VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
other cases too.

Therefore make things less special by eliminating these now unused flags.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 8 --------
 tools/testing/vma/include/dup.h | 8 --------
 2 files changed, 16 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e6c3ebb09c8d..b5784685272a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -576,14 +576,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-#define VM_SPECIAL vma_flags_to_legacy(VMA_SPECIAL_FLAGS)
-
 /*
  * Physically remapped pages are special. Tell the
  * rest of the world about it:
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index e6cb2ea196f2..61b08589e592 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -352,14 +352,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 

-- 
2.55.0


