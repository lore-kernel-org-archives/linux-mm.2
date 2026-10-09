Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BFCDCA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5181F6B009F; Fri,  9 Oct 2026 14:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C8736B00A0; Fri,  9 Oct 2026 14:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 391ED6B00A1; Fri,  9 Oct 2026 14:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E8FE6B009F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:06:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F0251404B8
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:06:03 +0000 (UTC)
X-FDA: 85303866606.07.5209E13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C155F160014
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:06:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EhnsIePt;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rm+C7Ys434hUmEU+Xa4zb6DLDJf/YI3CeF+AWIPMT3w=;
	b=uqK/JGKpoxE4cb4d0+eRfmr5vnIHK9kx2pdO3ZGC9YcfQBKuWUd/rdf3rZ7q5fwp0BzCch
	BYqsL8kcoz484e63Yedx4QYsLRtoj8JvQWgaHBPUYTfs/lbXt15bHdUqcRU6z7+7YmSKOx
	mor4CSXyBxtsOvWwPFqwD/R6Qs1+QMs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569161;
	b=J8GyaAUMVWIs1zkxgadHVsJSmxmGgreZnCwp9uXue+oeB3lXPokgZKOXYPxIMMmYNEerFj
	VzVeju3PSRFtr4gfS+SFHDJyZ8jLIs6PeQpDfmZ1vIFTXsHzm5oZHvBkDsFBEIR3aYHY83
	FjmWLxS1iSf6xIQE7HEk2uXH0nrXerg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EhnsIePt;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F21F342EA3;
	Fri,  9 Oct 2026 18:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5FB1F00898;
	Fri,  9 Oct 2026 18:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569160;
	bh=rm+C7Ys434hUmEU+Xa4zb6DLDJf/YI3CeF+AWIPMT3w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EhnsIePt+Hx9RwCLEubnbCyplaU59qTlVhfTxop7P+3uhk2Ily/naSbIUssmH0Cca
	 7DmV8MPocOQNZC7aB7K19/9JdYrzIp8ajWDDWbMznyo2q7eMiZ0hcQwSgqeZwbTYgZ
	 HrOdA3n2KzoHzF9YOdfMzvnO1d/+vHmCsDvm2suwU1/ooiOjuSuWR1oVwGsPSuPNo1
	 47Jh/vb3+DZ5BX672L2nR4MfSAIgsqKVFxcowACYf8gzuuYiRVwrE4VOi8PIKg2Fch
	 3pe7hAuK3FbQofrwD1HE3M0/FoaKD4+y7bcPegA4ufqeFRV2GFPqQMiNv4Zs4IySRc
	 9pIYc7rhGtiow==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:03:58 +0100
Subject: [PATCH v5 04/38] mm/vma: ensure mmap_prepare doesn't set actions
 on a mergeable vma
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-4-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1712; i=ljs@kernel.org;
 h=from:subject:message-id; bh=c0okmVqdd7ip0u4PvV3oDEa2CETwat0gzMSLDhHRBRg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sycxlPQcn4Vf+LXDYs6c9Zlr3Bv5cyMVdz9VPZWW
 nP8g9BVHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjInueMDKs4LjZzLwhba3dX
 +0f96XXROeELb9ZoKhzljgxuqS/YJcHwV+BPea98cvJ6vQg3Fc4li17wcyybbc+XfJz1QPga3ql
 cXAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: C155F160014
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: o7s4wk644xxir1o3utd5bqwza5afbzyw
X-HE-Tag: 1791569161-760523
X-HE-Meta: U2FsdGVkX1/hdVVwsJFYEe2cLUnSRVnMpuSg0BHIwOzu6Wwr1EWte50Qb6gFj+7ZB6ycAzIeAD7WHnDNtgDhwh++k95LySleQT0lC+BPta8w3xF7WvSe6IhZrKNsbrRQoMWGnZE4Xrigr7BP851as3GNX+Zmu5E97pPyZe7Ng4SCJtgD+uNpJcH/vR0WPExX6yIIHiQo5XZjsO8avpC7aabZiPDHcOf+1bysd+3sbyNXhD6EPXcmaWCwuiZbB0V95qNPekCnsdkVzaSWHj3zCBuviSXysnlggL36aEBHgUYtJzsDbdnFukbH+O7wphIdk/XXQMnT7g0J8cBJB9T9wiH15oVwF/ydGPrbel/RwyV5El+K2SDXENwbx35AegAKs8xiI2bcYC15p9C5jAWbwHZGY/AIoIj7+6A1/+FAhVSlvVzrM1mpwb+jT19CwNkL2fa7Bp3eOg9oJxVsF1D+0Wzb5ghi8AdI1cUHcSYWDl8e17l/8Jg3xUPbAT3fwlNCzpE1AJSYpg6vhceNAwDAh9vAeZp8hevfRp/cnp0cfYIZ/NXD2ZyWHlwBDqS3wq0uMar7R97Ub8oywprGpl91dbAYRZaFOibjt9BbDdDtDbpj7EJpjp735EGVz7icRzroZC2KBR+7FfTbjXZHMLkiMCvimThFvwyDEaQWhJKi5ITWYabwEFYjb0GrOGzs0b4FY7sbuv6oCSpVaymrblFXDWlYXh4Gm6UJNlr0GiKKWRcH8blDtH62CnTSPWHQsEaNdYPMMgiqTkiOGJxDMQWOGYHZPQNaF7qE4raDydd2OZskpbZ9kWmFSfSfL3QaQCLTVU2tYThxcp+tOVdwuSRfetdwMnqDRUsQJ/ehH2uYVoefa4iq/3Yw/jsYcNOfH2C0WdGmHoqGAztRMeHLQ3pyHhUhYxBJwSzkLPfdi1sGSX5G1RFs0Yk1NwY0B0nzSd0bgol3KkKU91L82ZGIQhA
 eQXWMPT8
 spQsUKNvGlZHZsDnBtlIx56j9VGbuUtwHr2rxtGmWIjTgqCL8NkVYTzzxt7HyF7D+AH846YIy8CTpQESIgVkHIszx+WBqVcTrSDaTTaUQAxKvVM7qHpEg6gWBjYBese6y6kjpRfAWX1m8YbOmPVG7u3dOT9iRfItJPQa9adN+XRotHohdSpj92zYPsHtOls5TSzkKMv7fPpQsSlAG0Cp387sApSqLFtLBOkK5KCSfq2zhLKcuy8iO4XT+gHE9eZb8cr8pKdMG/yxv3+/ZOQaqZK3+ncmpngmcJgmTKJ/1I52vZYeFw4wwvwPUqh3WcXaL+lLm8m1aGodPNpr2uxQ0je+cBe475wC2WaHtTBIhaGlqKXa2d8Br0K8oTjB91XWya1jigpLZRt1RvkKvb7AHDkB0RsfDmlVQOMJUHYGKJoJUTTPHsVi6WHpv+eDeWJddyu6EiVhZyfZhfTVtoXSX6IzELSVVyayuiQOvPyBvgsq4M5Sq/nPgEJBZlBrSMPyiWTd7ZDmAkbX6z14bpWgCPse8QpcEhWWkqRcHmvMfJa4bEkrfj0rAocyxdBPL7nv27Ia12nBLDfnzYuj9tTNon3xA8jyBS5SXzTiLs6L7rY/SSQkNeQ6e/KnhaVBKMs/D5z8MHznYN5ZHQvll5Upeaa9ghyZSWXh1mVAnBhlWvFy1DUuLqL4l2wimzTOu6sTcT72tUzf4GB8JNBdg0NWu1HqliClYLtoh4sPfOnRbNhCZgLke3Rixd8fS4KgAsmxmZU4UVhAUZqbawv4xE7RKyYrhm2O4USnubXICkJFtsiritIP3x870vTmREVrTPvS4mBP3Z8KloNAvb5QSGwuzPU32Q0CO08rv1rcoBCj1sc8eNxlOrLZu4QjUkjkWlPQuQw6YLL1sa3VcSP791PpQ3BWKfEOT9KpFiK2bfZ7zsCclr4Xv0N6KR26iBisGS7TSqdIFeMTZBiDSSYMT1YDe4Kc6YFEc
 +upboSZc
 nt2bbnP9VSOsgV+Ct0TjGiQ6vTATPB5Yq7H9COzcgfrUuzRn9Vlr4xTKKVACb4X0Qmc0pAGv+BEanEexYGTnd8iXWQRhku24vDVFZ2XiGtgdBZDN+7EU3m8jtDP63El9SOgT7VkM4/Io0GJfbMwa4Zz3WuPQP6NLJGJ8fzHOAr/B8DmfqiR8dGqkx7GmQos6b2o/ZmEnhXc0ziYcmAJtVlKw3AFWTyiX/aSAVm89ujVZ7iTu4LswHcP8VEbB889q03Xv5y18/HWXSAcan6RppD8zKp2Kj08VC65rd3n1SHjyVcXsp2+FlzNY97PsbJxcUlCDKx6mBuFnhOKBXFtvRWSeZgIvKdtEzbNsWuCMTSNlpGaEnurpyMiwMTpK3KqSGusIZOb94XAlz/jZ8bWcMNJ9UisC7W/uHRgSQ47i/dSnv8hm3bonSy1so8Eagx7fyYQQr/LN4x86mU9vBQJxddbo6sJK7XDYe/Z8KdPaFD22kPWT/zaR9qrGV+ovG3Rx2l4ZR4D9dJVOvuHSx2AwAOC3BUSGbpKWjFuzYTnEm4n8QdohEGCmPY2O8vdBS7T4VEgKpWte76XzbfKsmoTFfd9IWFzGWL/NCK0vvdPwFl4aLtSv1WA+CD6yGRnT6almQUi/NZ5WXojuJX69e6JrZnaQyzeq1mnWshcYIFNFWRzue/2wEB95DJWOi78eR8HLIR92l5CURUvViJoU3ITltB7DgauYuLT9kR5REfysmgG2d2pfNGFjXOkKeR4bYYYC1yabkZwcr8F8HKKY5Fg7ysUm5kNeoNRst8es8/oJI2lVro3sVXvl+z1ymT0PF2X3bB4DluzRhuaRgpcVhI5bBxvDsO66zGkQxr3C4BZ9TENLqDl3lR+6Zy5bx0lIDGjs7qsGfRnwFk3sciiNzNYp6XcL9hNjZvjIoJ6k283PaHWg90y8XUY0Z0G1gEgKyAmuHoTk+34gEVdv2em16OCJQb46esxbp
 dT0Cz5Io
 +uSyK3yIi691+6o61UdK0IljwBzjEKkuwOQOGKtoBsDiVAEsv+LE4z0KcFM/peggA4qK/FbkzCOeawFwU/5exVfkJgvcucM3pXIjpsPUW1rQCXjRWZgqEDGnB1+SRG8eKtmcHQWIEyepFbk4lhscUkAsVJlfkY8x3G1MTBSK/lnURdvltTDGJspaODIQ/HucLa+Vk0ywcuk2wsybm0BOEQqnwhX6G1ZZ9BIF2Pw0lElX36o2IqMFZn7de+oHPNLRwn0KnyZSQdnxZpOCVU0zbBk82HY4F9PzXZ6P+aJOb+iixu672301oOTPKNvLoR6GXbMtBe71yJteXuT0sJPhlnDyqzRR9vAgkI8OfA45sZYLNoSAnqCuMHKTDwwdX1AzwRHlyJgUVCGfZOMheU+7QXlsSWQ2MCrmHxO2u3D7NTYMQLylshhUZnEITPTqduphBUNoPjn7qh9i0WZsNiyG2hsKUh9eaNuXFwEhphX/GL3eerJagf4srHJV3fbr9OuabxSVs6EY6PeZys2m18pgQdq0jK2rcfOh30xd/Gx8la2NoDkNS87O2pokHwm7PFML1zayFcDylSmRJUEHrWTvIb7H+qonvLgYxkrDkKookdQzhZih0eYhB8P9/8++6uShKN6PwVRWw1Cj32uQhHvXe2KievvBxppRmAxNYAzPrEmkaVYYliyHrg96KWMtoUmt6hd/uNlncsH+J8gaFE9keQA25wK2uA2VgGmyJ5NMxGKQdQ+DBQqhN6/tZymhZdgTd76vQ1HjfikTP8YwSP37/uoh44DimrN3ejIk5OmgOFzmjFn86bFsfMBPWqf/XC/Int8LZFdm7MyaliyXmcDQj3cYjPtViYfpU3lo0Cu/ilp7kR1/Ah62gycl4rb6Opb0hCRDyIf4ojBCR/oworHBPS0bEM9v9FKD7z4uMaXUeFYd07aLxaaUE4EvW8sZpGjgv1QNqS2oXTlU3eijC5DBIK7llI5DG
 eKi57uiv
 jzh6E7itcZ1dvaQ2pmLEl4Ir6EfgPPT7Qi+zMsO6K5Ozh52IZOOraUF5YLg0ieqrr5+0KlIfpMY7FFeztsJ9oAuf3zKIklNpN/gE/tKFUmCkS+S7ABCq8j/aqDQR/Ca2xiU4nztvgiA6xyZojhVrFB8Qkwl9xdvvTVyjVvw+NTH2GoX1+s42v09wPbbfnjMLjx3BvUNbP5w6hxwsgIrgKbaMGBUe4cHegNQXEHTHvfVoOQp/Q4aTNsA90fAuLaN40/X7mO50ZY2xbmSI6eGTnN/g4C1/mfR8kilPYetsgiCeE7fsxEMzGEllCP2pc+zXf7hh6k/v1ofSup1Pn4ArkeqSHhgmLxGw1PwAeqyWQDLMzNR4GM2lqnP2Q9mpLQIzwh0jqr3jA5oLoyYmSXRQSlStp0S9q+W53db4bwQqZ2Lnbc1vfpntOVaPgldBSGPbWRzE+wvfYhqnbsAGaYk20vSb/17JgBxHwyllBCNQkb5v+IS8k10J83qrDypEhQy63Cd6ViC0wn50Qf4rJhECkFaRm0K5q5+2BOfpv47PIWbJeUIqS2TN5w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a user requests an mmap_action be performed in mmap_prepare, this
involves populating the VMA range with data.

However, if the VMA is mergeable, it might then mistakenly be merged with
another VMA without having populated the range.

Every mmap action currently available sets VMA flags such that the VMA
cannot be merged.

However, to ensure that no future mmap action falls foul of this, assert
that this is the case upon mmap_prepare validation.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index cedc24dcdf3c..c067d6a4c826 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2815,6 +2815,18 @@ static int mmap_validate(unsigned long orig_start, unsigned long orig_end,
 int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
 			  const struct vm_area_desc *desc)
 {
+	/*
+	 * It is not valid to execute mmap actions for VMAs which can be merged,
+	 * as any such merge would leave portions of the mapping incorrectly
+	 * unmapped.
+	 *
+	 * This is checked after mmap_action_prepare(), as it may update the VMA
+	 * flags and therefore whether the VMA can be merged.
+	 */
+	if (vma_flags_can_merge(&desc->vma_flags) &&
+	    WARN_ON_ONCE(desc->action.type != MMAP_NOTHING))
+		return -EINVAL;
+
 	return mmap_validate(orig_desc->start, orig_desc->end,
 			     desc->start, desc->end,
 			     &orig_desc->vma_flags, &desc->vma_flags);

-- 
2.55.0


