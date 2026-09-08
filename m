Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D64C79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5C16B00B7; Tue,  8 Sep 2026 16:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4661B6B00B8; Tue,  8 Sep 2026 16:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32E2B6B00B9; Tue,  8 Sep 2026 16:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1E1C6B00B7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:12:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8DC03A528C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:12:58 +0000 (UTC)
X-FDA: 85191693636.27.8B5A04A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id CD53718000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:12:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vs0Mg3ar;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QHHORr5JJz/ySIh3gX90PJx9IHB99angztW63GXDee8=;
	b=FS7f3RP+4nNWy6QH5gZraisn6BS9vwflPppq4AzL9I9Jjhh4VilhEro81Cj1rQnxuBJvhI
	LxsZYR4jiZE9512HGnH1yNWFDPjLmONHGpHfSwSTlz34CZhN9xPzj8WtJqRyD9pHzugGIQ
	LK5fUGbAotLEhJpjo81zGSchCG+9gwo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vs0Mg3ar;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898376;
	b=KS5cRnEpT3OC4MqqSF5ypvjOAqTSeb3tjsR/iL6Sx9F7uNT5RbTkrwPTTKmADAr6uRQ32+
	ZE3S4Uu+cDgC7+nV/Nbt8F+ZXYaa0BEqOreK+mQlp4LLe8JXYeoiZJMdrRN+k2v3fKjGJ3
	kR6aI0DfAnzR+MZMmNr5BfzyXY6cMYE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51B43601F6;
	Tue,  8 Sep 2026 20:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD5D1F00A3D;
	Tue,  8 Sep 2026 20:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898376;
	bh=QHHORr5JJz/ySIh3gX90PJx9IHB99angztW63GXDee8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Vs0Mg3arwsVcSXEmxq5o+FmpfXNpdelLwiHrc7m63iGLN9sQgp9XuYAVxV7u4es1v
	 EYlQHJVyUm+HFIzM+g++Vu0aB8BBgKEhIYVyz32b4rPamI4g9ttd0hX4qKFlcWkF0F
	 vkAQ/8EILn9v1PML95T62JXW1ZTSvMN0tdnZSpv2cuRX1fFjF2eg+/l7q/LTFMI7DC
	 TDTjZBO9aHEmBiqhIpY4zmmAvLfFGav5kJrIjJSZBGNNPp7yDiE9hiEMYqbnnV2ItV
	 R5moZ1pKmsOpaiF3U7rO1+W1T3kkCX0UTSaLY4kcTgeJLg8nT7gpuZA4W1VkZwChT3
	 BHmriro6ICMOA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:26 +0100
Subject: [PATCH 22/39] mm/mlock: clear VMA_LOCKED_MASK over mmap callback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-22-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2741; i=ljs@kernel.org;
 h=from:subject:message-id; bh=owzDO9vl5baUVRjHzuAZ7IOE+AaPo04FqzxJP0WdolM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG5hfPr/NsPvDJ/+8pAC7cn//z6fOuly7nvLy42ml
 uGz7pjd7ihlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEcoQY/jvaS7b92s3ie+H8
 ZL0yzoUWRuLhJa8SN/Zl3L7Ctqru2z5Ghv1N02uV9r9a3tfQneR7au+uk7JXl3mf/rVKvjMtWFD
 PkQEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD53718000B
X-Stat-Signature: zhd6ssb6yajzfke63bdzr8u94us38y48
X-Rspam-User: 
X-HE-Tag: 1788898376-938660
X-HE-Meta: U2FsdGVkX19H89oMnnrZFLqj01+wDb57A7eyDJR7yj2GaFOimYxMk7Nl97skvZqaB4oQVgb1drFbDW4Yjju+lLRdva9fyzlR4bmbKCNdCznGCuwBGwJO7VSuKKehgsGLRlXMKtY9MWZqDU2uMJeATlkJDpb3s3fwFhu1Hexoj1LWaHNrFmCqviKYx3wstBy7Kmrai03uMijZ2Ypy5sZwbXvWl82BRMRAQv7ReZ4HIB84gS2/1xJ5UXV7IoluRll9DoiMBXMNwM5dYz/Nn9wQ+1kVggUGbU22c2U2KVOP1liQ1cgrwZIX1pQ5QYFMymWLwwW3jmtkamkiMi49rmEpTFDusKjB8oBkQgIJ1fQlEE2dcjb/9nrsG6tZnT/DlUnC+a8wbiJZMtp585m8e7AHta2uNArwIYAwtpc7gCn8XJ++KwBF9V5cOks5RTmK5e8TRPfEuZk4G0MzbUtsNCLeTWLAAvAAkZ1okRD+JXgs1Dm9+ALoFx0/7EElaR6Ulthts57jny6qnumgxKRoT9fLVyUMtcmldWooc/9OLA5quAlC3hIagY3YnqCve+V7uMX308NT9i5E8s6oomMEeAEinFz2L0FNYoUIDTWolhPPxE0axN/unRsBvlp425FaQCw9UfCEhzPWR+RJ+9em5NcBWG2ewXHbLKDQaH95+vFjw7jjsWoifkZrP0Oka9638YkYHtC1zcc7iXgFQ31vnJZ7WNVFw8nmj4RAr0PeXtPSWZn/vhsdH9kxBINi7+CFqnd2WI9FYE1yQLL4PjwN1xPvTQMdSH/Dn1DLWZ+ckX5DxjyuKdqlRBiTK8coojs5/ukGWuFwW1HaxrdRtKlIQOt9QQmskU1OK4jRdNu5f8Wr/gB1PMz4DF4kRYHgwmx5V+ln3h257CtK7w2uJv9RVm4LpjSuRs86IDZ5GCDig0do7Rjecdm77005psJ1grwq/0jgchM9h7ep7eA/KbOTrf0
 wTuvxO0F
 SbVYr8eUNXCVQ/6CMNHrHcJFa51ytnNYuAH8Z4PQSLWit32K9tccqo5QbYudrBhSmoRwr8VOssd+7MuEEf4QX79567DWW3b8B7lN3rskl9UXRFdYkPwYqyDDX6BJApmfSQuvCR+0xOZ3nhzgrjvqgniUeY7/jOoTuWqpnpTGDYvDtsUtDpRq3mOQXfberSyBNXl2RWkvzW1AjpB05NdWKzfBJJ7IWDoWmuoM+RNWBM9rMIXouCvHuUdNwtfbK2lSTANr/vIDMlDY+ssbkA7FhFPCyEu+JOa7WLDR6CM1Z43Ed+6pVP0HNBDuAVSH85L/zZXWIlkL05J+3NszSX7Ztxn4o9HqSm6AAWzRH3Ln/0+cXwvhFoYb0cWF5mcNtf4MtCg8/AshvSb3HfdwaJuz1eXzf4N3am3RWpJ3UnzNe1bDSdHdqZ1z4z59QRU2e8PPBxtCpCrWl899JIPP+GYjHCH7up9XroE+Ge3mInayqfxxyXYlgKiPtE6oYudq7pPzrAtvXIdL92SrKpHROGC0tgytnx5DLXU/AF1jEwoW3dEuJ+gJEjOo8zb1hV7QEj59kHeCsN9EDGrPJmtJjNOQRINrU9c434JptiIi3bNvSGEL79vj96PKsukzcWHzKx222AjzeIhs+lRrZtuKFJF73B/XVlfYjgw4rw8OXLOJfaocRmhJZPFIe1q59ARf0AdOiE2EM3UgeMtsz+P3BaR531OdEoJYQZEgUUuqJ+uHTpeDPlNX9txsKIan1t+5/XOjhO94TvmdTMr8FoV2XgHwSZaLi+M6dERol7l0cbJ93E8uaAmYU0MdSEOgLwQDKc8NtlzuVCb0Fclq7/nkthv3DPOreHbqD/Qbhzt/e9jnY8rKrZw5oZDWmHcUrnwybZNFJPiB4C3UGy3MyAxBdYJ2HhDGUll207YdVLbDslsom5Kv8kUIoI+pMRJZw4eigXn+RyxQXdr6V/OhyGfNounKCb9jdwxmG
 eg5jHOFV
 I4e2ILlOFrIf+EWaZ4uaMHR5j1vB4sy7APMXtL46F0/1dFLHI4ovYey62AAEOCywNggyTpnPmMY10T5E36OMs5uAU56Llw+a1YlHFFjVf2b3Reg4DGYYkw6vDnj0RuBquwtVe8rn0OXNikuxMGs+N5ZOhqmScJOcXmXorJLy42deaZ5kIYluQOpWgBmkvlfwcrERCM53+If+1Merw9UUD7F4ztHNRDhHIUzrzs3azwAlpbjMjyd/6SZE3IfgHIqvdyXaH/b732GKpK+ncgMF0537WWsskFrSb2y1sX6r3Mkua2fVrvuRiga40qqcqlBwsg9gSn1XmhHt0bsgaA+Kf0SX/TJUKtGHKi8MO2pc78kS60LITpcq9SxVA3mWt+Vt6T0R++kj2pjvLdfZetjg+iSToqwlNLThFFtLSZHuDYOfDMPfi6bA4GgQyMULLiQXvwQ9iVLiEuwqqnD/gt4FHd/LXLLAMDpxNWT8YVBHk51zLbfc1I/B3pMlo2lG9QX3GO2vYUdiNfyMSqz/a1L9hhkNTD3qO5BPkuul/gfKgoLs1hNyGboaH6UZc2+SLu3689TdbxnMJ3JK/Q2h7qxrrbVUpbEx3Myv/gB91PSiLWiiZBvUF4sIzr6PvC00LfM/YNq71A2JiZesZBpIZGUxu7BHPftt4fVwlj/6ZKi9mg/rRSyt7bcb+8J29393GMSyMkAoymSX4OlmNrKv9xrBmjzlPwx4EM5TPOzxk9Vss7tmCAXf/Wvvf1bah9HGqu249cT37bSWLoPsdV9pL6blNTJqBUFJ0W4Ob77kkxAm1e1UwvlVica/0W3C/mXc66tDvEXLjLFBVAtbkb82UioD8hxZjyG7kja3OHLMuWJm4ELJOKZl8Q5eWzNQsbpa7xMipVLc85+fgxPW/2/tBRJT2vt72k8iDPvcWFFikidSSYixuCMq7Em4ZR26FG1qpyvUX3H2GkBMV7zRgtqt+vWeeV+j0G2Lx
 y28/nlo3
 49iwQhV5//Gvo/Ll2L+wtJs985jzAIEdL/ddcAEq2eCKWovX/7vV/87a31SRXjxbkSnuiRyj/dNoBsiEV4I1Ptx4SvIdgGsWV46e85Bu30t7syE741gL2S4Q0Kuy+b6UVpe5DHf8th9SmC03x2uZk+lW0cqOk2y+4L+wOUS3YtADwltk3n8PqOY01SWGrb6zZLEFLW1jFRj78arqM9j+6Hsn8+cBurd6YaQBZZ97/Pjzla1eK06+oRy7yKsD5epa1dHrgzUxzU2aMXeQX3CwgTZ7Mr3SW1psEEu/yTs9FEs93SimZlM/OyJCmDcjpMd8bezDJNxeWEwzkjjCphI5ELExOrT6xhs8toyMML8gbMtjux7KOn7PZalcTWG4Xh4lCKOE24dW6KzvXDSAAcJTDy3H1U/tlDAS/C0vJThJNvJ3wnxGWaCYNHc+mJBRUtRsDFua/xXhNH4ub7s9RdWpUN05UlVXJ8MKb525SwOsduBUE3G6QdxgBBZoKmSp+6jUUexeftV1/HRh4CRIw8nqlZT2baEya72yhI2O0hFEvSjS2T+16LrvzEy3YoraweqJxMY8ejvqBdMopzUZZrG9de8cs+fPI6uzvudoWQo06dGq+hP1T3OLDfreVKEORZRQbifntN2/gF9/sMkHDn8zpng1zohxpUi0d5mYO1Fq8IB8AfjHqWcofH3W7sQyjnm0nW3RtlbtRtrvdEow2Xbfs7Z1GiFrcbmQiYoXzw5uGrLvy1TbfABQmT/qmVcAzfU6rR2mUfYFVysSg1s90fJcjuF9Evl0hL6crMKn1Pe0NmhnU/0JEQSu9JLiwY3Er5c+NmlNlkXLZhdznvsdF1kJ5LWuHF3FsFt/iWKKujIrGTg26V/88jYhVAmfllg9vytm4Whs5tp/QsYTujw8MLNr1KQxZu+zIPqCjBmIevqnom7ZilYVWpUM3Qu0gGQuXlGk/v77cSBZvlNuin1gA1ZhldEgB0tx+
 OMov11M7
 vpnBxkK9PVIJHV8BqZXBYTbmEbuv8JSOHkEAa4lTPo0kcTnF6ry8stVFE9q5ndodqz3R+MFJGAjpLG/Cyn3mq6uwY3uNbv/qr6IJ9/r+j6wm7P4eKVQxn3zqhUqqcCUI8QBnzmDzdg3ZOn4G+fGyGAieWq54FjacJhAph5veWJSNYqlyOjJcyaAIkwEf65L0hLX9J7q+aDGE+kDjoFxALoNJz3coSMRp7Mpsy45XIkXTImJAANkZH2WObSJUeCMaxmHF6YUbAKIFhP7Mm1XMzIPPswX53dhwijq2FrY7PXYo0LNC+AZBgNnj/X9OW1uYr6yJdGbaVM2Kq/va8ztY9v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently there's a confusing mess around VMA_LOCKED_BIT and
VMA_LOCKONFAULT_BIT.

It is permitted for drivers to set any flags they like, with the VMA
already possessing lock flags.

This results in the absurd situation of a VMA possessing both
VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.

This has resulted in mlock_vma_folio() having a very silly check for this
scenario to work around it.

There is no need for this - just clear the flags before invoking the hook
and reinstate them afterwards if they are required.

Nothing relies upon this being set during the mmap operation.

mmap_prepare is unaffected by this so requires no fix.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h |  9 +--------
 mm/vma.c      | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index a86b9803a4c3..6e27d3b10c01 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -975,14 +975,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/*
-	 * The VM_SPECIAL check here serves two purposes.
-	 * 1) VM_IO check prevents migration from double-counting during mlock.
-	 * 2) Although mmap_region() and mlock_fixup() take care that VM_LOCKED
-	 *    is never left set on a VM_SPECIAL vma, there is an interval while
-	 *    file->f_op->mmap() is using vm_insert_page(s), when VM_LOCKED may
-	 *    still be set while VM_SPECIAL bits are added: so ignore it then.
-	 */
+	/* The VM_IO check prevents migration from double-counting during mlock. */
 	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
 		mlock_folio(folio);
 }
diff --git a/mm/vma.c b/mm/vma.c
index 526428753218..cb0c4c625756 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2594,6 +2594,11 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	if (!map->file->f_op->mmap)
 		return 0;
 
+	/*
+	 * Driver-specified flags may make the lock flags invalid, so clear
+	 * VMA_LOCKED_MASK and reinstate it afterwards if appropriate.
+	 */
+	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 	error = mmap_file(vma->vm_file, vma);
 	if (error) {
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
@@ -2607,6 +2612,15 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		return error;
 	}
 
+	/* If VMA flags still valid for locked mask, reinstate. */
+	if (vma_supports_mlock(vma)) {
+		const vma_flags_t mask =
+			vma_flags_and_mask(&map->vma_flags,
+					   VMA_LOCKED_MASK);
+
+		vma_set_flags_mask(vma, mask);
+	}
+
 	map->file = vma->vm_file;
 	map->vma_flags = vma->flags;
 

-- 
2.55.0


