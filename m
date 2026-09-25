Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DABECC98324
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 09:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38BF86B0088; Fri, 25 Sep 2026 05:13:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3164A6B008A; Fri, 25 Sep 2026 05:13:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B54B6B008C; Fri, 25 Sep 2026 05:13:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE4756B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:13:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E4641A0545
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:13:24 +0000 (UTC)
X-FDA: 85251721128.10.E3E56B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id C095A20005
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:13:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K2qi0Whp;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790327602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfSL2ku4OKsR1ZwNLU9aq+Cv4BSlDAV3gm6yCuANvXg=;
	b=UmFrVrGWSLOGKT5KJmKXqU/o4wg0aJ/iDrmH+rZ/OZCL+yHAxMayvKZjO4/XlffC2A0Szw
	oIKU6lBGxh6MOqG+m9tq+33UnDHFhFD+/WD9WfBpoh8BVd13EtLSPuFLDy4WslrVmeQuQ8
	1FfSIzMlWUzXs/Ywya2808NrxpztqQE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K2qi0Whp;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790327602;
	b=XmqNCzDg+v1Um88ZoC+gFXXtSIhf6t5IUNr5bMlSWll17D7RzwhmpyYpaMG4u5NZ4wo74p
	J2ZlHXqjlWB9EwqfZnumejw1Y1fxVueZXpM6HCV34W2ooicKJ1RMMj5b/1X/aWC+oAZUXn
	VvOdOvtTrjr2FW9NDvUkw0TGKyN0G/4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D72366022F;
	Fri, 25 Sep 2026 09:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A0E1F000FF;
	Fri, 25 Sep 2026 09:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790327601;
	bh=yfSL2ku4OKsR1ZwNLU9aq+Cv4BSlDAV3gm6yCuANvXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K2qi0Whp5/6TRdhA6MhlGYRilQhTQ8jPlG08QvTUUmQwkWOHWgmSx5AdhFTFi0qw/
	 r4+3OumzOouGc7txXhbbk80xasHy05dho7/yw8n5cfGkWIhweFLORuSQD6wUTgF3bF
	 dlK10/x8cBD+DlIEYdpY/JpYJifQA5N4twHg7jDXzl6B1XyEXIXzNDQx16+MJsnNtN
	 sTXe6Jh9EmnWLdP4R1YQtEnnOP8lnDSORnscuubhZoG/xGcNI3ROCCX9s0YjPIJIxI
	 MdK5fq25MLwiukRwd6j6BdAO4Z4mjaXg/lCXJQXPIaGguKLjAmtHiggDOa9mUzFR4Z
	 ur0MJU3/gDHOA==
Date: Fri, 25 Sep 2026 10:12:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <arY3xqkPCgZj3IVD@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
 <qpkcjtl5jbip46zxcpyogsk4phmhetfvrvgftxhsxlbxjhucnn@h3a64dfoxcmj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qpkcjtl5jbip46zxcpyogsk4phmhetfvrvgftxhsxlbxjhucnn@h3a64dfoxcmj>
X-Stat-Signature: uwd3f8n4ignej3bneuprg91mmjf3hhbd
X-Rspamd-Queue-Id: C095A20005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790327602-52623
X-HE-Meta: U2FsdGVkX19K7YUlxDgu11cwykkHkcti7mbBAKtlKH5g5Y9eHD+DJRuLe9vgWxG/GTzaIPQu1dQ/f9koKv+6p2EXU8MMMOhgjcdWjum195gh6ray9MmwgaWV0nL5zlp/8bL5F4dAGZPq6GkmhTebsS0nhxkN64AmyutRMUpwEYZbDo/Mh73M0/LiL0VK0SHzJ8GMPBjZe4bjINV0rUCdVbOhS9ePz2tWB7cnYhxCEt+2Km6xrPOM2YYKjcgs+FXl7M2AFhzc6lIZI4gapqz+N/IXHWq6XIpL9D84zrJzhqci1p0DcKSfizQcZ2JJIgMRXotoNCM6G/Pp1Bh5idVtmuozlgxnrlIXO4KaLtISqS7Of/+jH4FzD5CBFq5VPH+63K94+as83co9nT7u9lpV7GQLbg/i5dZxSixmg59JIYxdfPxfz7mvsPxHSppVW0esq2gL1r8CRhr5hZlKBRjd1zdY0+0kF/jJYEU2obWwrL5arwKNTBkrhiUhzgnIdibL6EvYudL+2FdhTBP6aSYvFryKBrB6pR2iMg3LyXt33IcNVrX9egpIUh3JHkABKnmw06iyUMoSHobt4teaVKIQuHuLJunZ7WegRl85Sc0NvLAPwZTp/G2C3UGR4xXCVb0ZS19YYvDq+m5lB49bCa4hT1/lmB/LTLpHa0cYf7wMtt8IGWkpNxvXmmyl4aHUdR56wKGdnph5DWH2X6GXBzvvcJ5wEu1DuFB49wgMidDXrLb7iqU9UilhGB8O6Vm0SVMy5QHNZpDilxa+xr7xG48jaLdpnaipxVq4OTfw1Vp5zS+q5TYsN79LxBGPhYgXhyBICkaX+Smbpe4BmfUI0q1rTya17P7/xe0xJX/5DMQ0O6pKrZaGIl//fcVAVzLb9is1czrmLTpjB1wDNNMeq0u93ElFOCb/mtNUJDAqIWJX+D1Ixs45K4Htyc2NcMNWtcz9CODBtiH182S8P0l1j91
 bWBEA1Y3
 ToEdpeLSKoHlnVrjOdQqtwRiLlD5qdVdKYIlSv1J5O+2InhZE2Cdg1hEpeCXHUAu6ET1MKo7E7hU7nJc0rZuEsYlGCUrLOqPfgFDB2rPghoJZ0APjSZnjl7I/oCXLHgvwKhpte7vE4otkqaARLOwoGrNf90HXgVd29+wXHmdHo4UudTdgb31I61xJ751zp9VBnMTmLP66e21TppyegWW6rPaaD68zZ41c3PesoEX/NyvpMDcsi8B6kueCVLRDskbySBuuiwRCWsuAouO4+wEBPo0ibejZFevdrLv6vcMq5Q9cSI6VQyYG8Rb7MRpBAWS2GRc4Jx2odaDr6gKY4T9m4LLoUirRGnLjZ5LcEowg6aatWZTXuusYN9A7M5Jvgm5bIBnlJSCDlm+z0doWHJsW5kaV26BcA5Hx8LNdQ7C4+QLzjFpA7vSH8tawDKNPuFXrsPcdy7hK6L6srvQY95P/4MVWTp4XUf+MrfDiWPn8Z0lZZmFD9XQKZx+31fTCz3KBiUhVMNEkYAEXHMwTB8GJ7QUHB7yFkEAjEFj3XikzWiAvP3YDyCrKnJZllH4Pz6UrNODl5Tdxdk66PwRcH9bSzlF5Pbjs45YHizUImtTc+m55FFLwEGSo84XyzjFol9ZoMHdcid5Npjd/whwS8j8gKonq3kRVIM2+/mL5OfmsQPp7V3HCRoEt84NOeBLS5hJM9eI3M8upsaXqUdRNmiwCmqFx9XdV6KdBEafdGAuWb1eNghVNqIECpgdrI67Oq2/i0NQ6HvT+CNjOKhZ6YDEIei0X5L/OXuL2vMRstnEvmeDdTd17EgWaL8rhjSUB8UT/Dxe+PPu0fIqNQ4BY/YAL8Hc49WMtSPj9cIbRq+C+9SIm+KtN0i+PDsF5FiOBDrXnF+SJa6j1kxkZGgKDPsZgMh2qgAIELxjI9sCnwkYiHTs6vZKP3qkz+An7ZS3YQ3uLBxnFg7Y0vYVUfMtovcDUS1DdeFVk
 bOO1brf6
 MyzgpyvAIlBV7h+6dziLqBd8y1wJIZaBbkJ9h4lpXogL/sa0NO2+cB+sne9Vfthft8+GKedQJqCeEcnH3ZHo2VsZKWl6WzdxzB2BEiuPCiuQr1B1MN53NBMgp/vUnQbQwrhC/Fy0WAGyWzZnDRhdq5Oy+imbIstetP0ulvsx443E+L7jCQ/PFm0kpHgnnzN79f2bfctwW7opW3LrYkt/ASl+E1S5OdG/7GQvBnnydAT1/Y/ysPwFJkTpHZE494KE2BtTOS8tABTTcqqCdy7Ljb3bMnYfwMu6HT3oHkn+RUchK/ExM6tQgqrzC1krWfa0cN7X54Sn6/pEf06lcVvMPxLZ/GWGD1lcvQN5PssP+fiuJtr85q8FALNFir743B5Mc8VXdol7x4h6124NjYv8IBDv3bcq2Hubi0zH+vtHpKgbkQhhAAR6aACQ6OUSTM4mDGk8nPXB86w4U3RMoPNboPa/+XjAtAvSHb3mtkCHciKlzyNkUzALI1EpDWc+rbRZDj6bD5twtqvfGlUVMwmD3PyWVAZ25CAyhv3ztdyfiA7jJBIDplZ/5qVwZWUw/z4kPZ8R+bs0VGIJSwg5LcDvq3bAP5jh2BMS9tsK7TUh+B+fGLtuXgWtfT6kR55/2uh4mTKInkr61wVm/UyvxY5k0ksfqRzwWzD5WNMQSK3P3FvyVtOw2nAtM3qoS9/bfK6MeKfqpiTJ36OYVcAyi7YIW0ZYUR1VJOxBjdp/QpMw3RO7FIgm/FlrqL7lKaGtn1xObmlT1xaWZmy4X46FTFlEPj0iecj2HLFV0V/dXMMxdpx8xXe3OCeNy4Hutlk3gilYwVVXKJpEI9fjW4/hcxVRA9knJXzZU666y7ksqs9uxxnLXI402K62xP6ApNhJjFXIaW8WQS3Y9g50pWLhRFciFEBN/P6eoxoIpc6xKVwUyVLFA3gY+Ch7vbksUXVyS+eiQjYKbGLbl2cBuoY4ZJ63m6HdGbH5p
 JiNz+2uE
 2WwkH2YLENu2eQTbXYGONTsbXXf+m6lD3oTlWu19NX0zLU1HdyI/0uKP1XLX/ITvbuHKiaLfQNL0UFxQvGLXRNEEGO9HvQZmOLQIDXkiC17YAcEhVP6zeuh/IyP10qO83pEaK+uSgdYMKtzKH/Jp4+Zh9fmCsB6bDIaTAiW5YoZY+0y7x0OSvCLO0rRQBNo0+R4XoXChUcuDGIVSP8Jou4CBnpaYOCzwXN5WL/Gl3YtRGmbQ217VXvGx34XC9rLGgLt/OYep4aK/LQ1/oSh2Hxl7CoI4wCKX+RfH/xm9qGm7AZdc+wGWJOaZdUQx3Ha3iExjdpvu/7LRMsa54lqo9OpdU7BI9fnaDDIQsrsoaNpoPCJqgs35wD7GOe1RnzrjDfhjFyYla9chAT5KPClnMlgEqcJGi91c8OYwcyODbgPvyOXRPiifiEdzr4al0Cd7mHPhNUawiZvFMAIyyQjaD7X2bqjbHN2JV0qUcLUfJCOtK+edHGI6P4o3sxZ140HzY/SZ/FjnAv2Hff2bSsm9Yn9pU9sUGik7IYGFLtzH0p+03TivSuvVhos0AO5WblH3ESelbXxeg8AxChsARrG2aWLDu4enmYJ+eAQyA1TBBXYObZkgE1Z+Fm/f/H09RSDYbqPXoS5PAiSO7JRwnNBx/HGTIr4gUzDVyCqepw80F6Znp8zvGhscCvcuQbToHlMahy9sJpWqQ3TNsJlHs1Qaf01CTyKjqacv0kaZsf2MxVeKI8ZWbr1y+ZWgqmP99bzd8Suwk2x0HDf82T/vwdowhX08hDJUT+NX3rb6/k5lbyk1aWtOcRv57eKzVTGSWGXK9eEmqP41YKKKfrOJnjvML4EDV8E/M54v5EptdVc6zVSqvlyXW2EM2U15Uaa+Yo2UNyt6O1FqJXZ7nnF5e34X5Be0rEMCW12ZXeeGba+vUah/4xnBCTbahKNPJ/b6wyWqQXwLa89FeYDxV7Au95YXlre+7Mqgt
 nj5ZTjPK
 8id6v9OAV91uSpLTHIqLALFDnid59j7O1O7pGnH/+GolvohKnYXkhZkimG7VfFx4WkRh/vYGLVLCmD/0reTdzMH7p2RBw9KnzhFVGakFlrDZ+qlrw6e6pCfFpTPVEDQjYP2Jf0/4wLsSjbAADqT+DfO6+EzCEGliF0Njodfl1TdaK1WHUUT16GAFY28iBYd4qnbDCHIdes6Nm3wwdzqWyghi2+tGOTHt1IHXimAPTS5b3XAeI/vqKrj5lrSxLl8f/Z7eLQ6AyR4FgceQ4tNZLsO0XjHetfUZtWDqKeSk5/qyEbhqsIGEQQDnTnWGzBvvV6oiIZiUvrt+qYCJgSA2mJkZgztLcnM5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(forgive my possibly semi-broken efforts to trim the mail)

On Thu, Sep 24, 2026 at 03:00:44PM -0400, Liam R. Howlett wrote:
> On 26/09/17 05:22PM, Lorenzo Stoakes (ARM) wrote:

> > diff --git a/mm/internal.h b/mm/internal.h
> > index 0dca33db068f..fe576d468af4 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -7,6 +7,7 @@
> >  #ifndef __MM_INTERNAL_H
> >  #define __MM_INTERNAL_H
> >
> > +#include <linux/file.h>
> >  #include <linux/fs.h>
> >  #include <linux/khugepaged.h>
> >  #include <linux/mm.h>
> > diff --git a/mm/util.c b/mm/util.c
> > index bf0513d1d3d0..016932780925 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
> >
> >  	/* Perform any preparatory tasks for mmap action. */
> >  	err = mmap_action_prepare(desc);
> > -	if (err)
> > +	if (err) {
> > +		if (desc->vm_file != vma->vm_file)
> > +			fput(desc->vm_file);
> >  		return err;
> > +	}
> >  	/* Update the VMA from the descriptor. */
> >  	compat_set_vma_from_desc(vma, desc);
> >  	/* Complete any specified mmap actions. */
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 55917d097933..fa784f069da4 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -24,7 +24,8 @@ struct mmap_state {
> >  		vm_flags_t vm_flags;
> >  		vma_flags_t vma_flags;
> >  	};
> > -	struct file *file;
> > +	struct file *file;	/* mmap()-specified file. */
>
> I guess renaming file to mmaped_file would be a lot more changes.

Yeah :) and want to keep things sync'd with vm_area_desc.

Can always obviously follow up later with renames sync'd across both.

<snip>

> >  static int __mmap_new_file_vma(struct mmap_state *map,
> >  			       struct vm_area_struct *vma)
> > @@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >  	struct vma_iterator *vmi = map->vmi;
> >  	int error;
> >
> > -	vma->vm_file = map->file;
> > -	if (!map->file_doesnt_need_get)
> > -		get_file(map->file);
> > +	vma->vm_file = map->vm_file;
> > +	if (map_same_file(map))
> > +		get_file(map->vm_file);
> >
> > -	if (!map->file->f_op->mmap)
> > +	if (!map->vm_file->f_op->mmap)
> >  		return 0;
> >
> >  	error = mmap_file(vma->vm_file, vma);
> > +	map->vm_file = vma->vm_file;
> > +
>
> You set vma->vm_file to map->vm_file unconditionally above, is this
> necessary?

Yeah, because the mmap hook can change vma->vm_file, and this is necessary
for the correct file refcount accounting.

The accounting is actually very tricky, because the file that was passed
via mmap() is fput() after the operation is done but if its swapped then
you have to make sure everything works out correctly on both error and
success paths.

Which this patch does (with a lot of AI review checking to make sure it's
not broken! FWIW)

<snip>

> > @@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
> >  	}
> >
> >  	/* Invoke callbacks. */
> > -	if (map->file)
> > +	if (map->vm_file)
> >  		error = __mmap_new_file_vma(map, vma);
> >  	else if (!is_anon)
> >  		error = shmem_zero_setup(vma);
> > @@ -2797,11 +2803,15 @@ static int call_mmap_prepare(struct mmap_state *map,
> >  	int err;
> >
> >  	/* Invoke the hook. */
> > -	err = vfs_mmap_prepare(map->file, desc);
> > +	err = vfs_mmap_prepare(map->vm_file, desc);
> >  	if (err)
> >  		return err;
> >
> > -	/* It's invalid for mmap_preprare hooks to clear vm_ops. */
> > +	/* Update first so file refcount tracked correctly. */
> > +	if (desc->vm_file != map->vm_file)
> > +		map->vm_file = desc->vm_file;
> > +
> > +	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
>
> The less rare of prepare ;)

Haha 'It's a rare prepare that would dare' is what I'd LIKE to put here as a
comment but probably can't :P

<snip>

> > +static void put_map(struct mmap_state *map)
>
>
> I like the put_map_file() instead, like Suren suggested.. but maybe
> put_map_vm_file(), especially since it could be read as put to the file
> pointer instead of vm_file.

Ack, and of course to bikeshed it a bit :P maybe map_put_vm_file() so the
'put vm_file' bit is clearer?

<snip>

> > diff --git a/mm/vma.h b/mm/vma.h
> > index e97bd2dfa786..f15faa83f3d6 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
> >
> >  	/* Mutable fields. Populated with initial state. */
> >  	vma_set_pgoff(vma, desc->pgoff);
> > -	if (desc->vm_file != vma->vm_file)
> > -		vma_set_file(vma, desc->vm_file);
> > +	if (desc->vm_file != vma->vm_file) {
> > +		fput(vma->vm_file);
> > +		vma->vm_file = desc->vm_file;
>
> This isn't going to be racy somehow, right?

No, at this point the VMA write lock is held and everything should be
pinned correctly.

The vma_set_file() dance was the problematic bit here as it didn't
handle the file refcount properly.

>
> > +	}
> >  	vma->flags = desc->vma_flags;
> >  	vma->vm_page_prot = desc->page_prot;
> >
> >
> > --
> > 2.55.0
> >

--
Cheers, Lorenzo

