Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3E1FCA5FE1
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 07:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED186B0096; Fri,  2 Oct 2026 03:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977A26B009F; Fri,  2 Oct 2026 03:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0BD6B00A0; Fri,  2 Oct 2026 03:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FD816B0096
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:08:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8F3480669
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:08:05 +0000 (UTC)
X-FDA: 85276806930.06.905F336
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 144F51C0007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:08:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V65N4TMT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790924884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBWGWnycwnNdtBcxWaH2SknpSKu+rT+gCbl7PdEjrNQ=;
	b=RYjARniig0C9Wj3zR0w5anyUC2eN1YLEW9BPoBq5UPYLGN/Q7Joe5tjwbQQFFCQL9Igt8y
	OfOSkfginr+0jRkfGBslfBn1jFC8iBf05zzadvO8OGHn+2+954NY6ebpxdK96RYX05q0kP
	7tUBuNEfLPw6qertL/SydGshkNoYBEU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V65N4TMT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790924884;
	b=e4fdRCyX5DInqezHYHeYKwzkNF5RQwq3tKjSzybsleXhjB0YqA847FCGnvVbP0gZojO22G
	y7iFNESe81rNrD92M6TsrcvOe9R8qVrCWOOYtmgk0MCbuL968k8nubd2oFvJf1+m/Vwvg0
	0SOJfBiybfnEmxsKXoAM2C/qlVmxAdQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 375DC60A79;
	Fri,  2 Oct 2026 07:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6895C1F000FF;
	Fri,  2 Oct 2026 07:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790924882;
	bh=gBWGWnycwnNdtBcxWaH2SknpSKu+rT+gCbl7PdEjrNQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V65N4TMTsBdVODK4V3MQsVqocEvbPZczo89mZqdp1CE3E7Cq2EjUntB1O8wX3FvQm
	 Fu+kek5ypkFI5A/DlAHPJy/OpokIe4E/QWatJT+eMH/kOaLwQ6clrIcPqg5+8qINbf
	 J0jS/SWAjYeORDKHJi7zkoxdEoA9iHFpNbA9tCoVoH/P15MLoPE8RtOJybliqwCvxj
	 CftdkI9ecROuf84j064ySy1e9ix4G+XadOwRi84hTu+F40tXQinSD4LXIJNnmWgqN0
	 bcRcxzSz1artystIqvSGszUQSskJ8FjqWZ6POh7rRVQJeBI4VBQLI94EQwXcy6afad
	 GeuplIkMqvM8g==
Message-ID: <e07e95f1-5e24-405c-aa46-b727d1bfbfd8@kernel.org>
Date: Fri, 2 Oct 2026 09:07:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 36/40] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
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
 fuse-devel@lists.linux.dev
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-36-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-36-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jbqidzmpnidex3yjenzfehimxw54pkjt
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 144F51C0007
X-HE-Tag: 1790924883-176099
X-HE-Meta: U2FsdGVkX18o+q8wrFgcb0endYER3lVeU6UtFnQFq5n87ii8Uq08fjE4HdqbrL2GPM8r2bATqu2gQv8xMPsNr8CbMco96nynYPkL5BpGr4rn090nNEef2W7+MWhquhmvocAnLGEoGCairyiXPjD6yOjykpa0jTAAJULdx7jYZ6P4QG/RHleZszAHIi+FLDTU/yESF40wKGoCFnv2ajVPEWpUuFtIRB1bS++trA2TYUeCY9MBeOaQVrCzP7VzOaMnWRZzS31xkFxFSCSnZ1pnKOeGYDP5pjwZI2BVPSUXsUI6yLIGAuWZk81T/yN40ZfTmDjWiLVoaj+E/FkWr7V1pa0zMfF0EFNVPq/EooWSZpEIGmJJ8t3Q3IKZGCwTEDD6v0uHxI9ShbFBZe+K4qCWjbPOSC7ZQsVACoPf0NFJ8U74HZVb7vfxII5lvIXDO6FA/48EyeJC1ZMIv4BvWnqcPNOToGEwgJJbIaWTbuIYej3w+U091K6tVMPM/g9BlwQkgtW87Ae4iJj/uWsoZvKBYUwOZUUJ17xp9EmD/EAugJAk72K3I57TXSIM2Mc0SMUKT0l10sEYe1ro4ReUOv2UmU1HlbhZlJGtdQi/VOZGu0U3hnRQFW2BSed5slXOhi4DFOk+TdipqckyZ5FO3QC94GCUrO21vV3iu5JOZSk8477JNSs4jcIQbTjw/IrwMf4EIFHHT82VMtUY3YgVKhGgf97SUatL2LgLzHM3nZGj3Ad5qQHRtKpEWWr1SqWQvOloTRNds2Rp/DJozkozfvTri5wYFhpawB68FgLKZ71uZmPJi8aT04LHuC/1/KVETR5Z6gV7MEEMKmG2Mu8ArDxUzz4N0UafB4raDBDqTa6pp9hzmGC5rN+K+Fn6uo53NDani57V/t5iPw+uwScoAnNo3p4iiekTIdGUrNG5RScCDOYxsH8mMBUUlmLc6suau9BvYdc9nCf71AUvlatJN2P
 8PaLueYG
 qUhSjRu1KqrNW/OMKjJfozjFVyBbHrwTKwkMMrR6Y9ZBicJKTOc1CtnBxL4HfZYl0RDRBXsmxrdtFn7+xWwMxsSx6o4B0HgJm3C3wMBimmmXhv+rpPy5633JqAqC6fToZ2+OyZq859n05BViMlMRZHPQZmFj0n5EA+6qgGfDO7m70Zin9zzLPBb2wweeovrD44SmKNbdpeER9oyToHyMyrTGDRITPiwDXzctI4bEwV7CFYqx67j2L09wxcUlsKlayrG+SJDAkqpMA17+g/j24jkSGhx4jZLwFN6HxeRS7VhwkGQxCzRD/V4fVqjvfVnYvcAxcnjp81J6HR+j/cm5Y/uSQD/f5dGLw2vdlQPkCaWCFCVSA8lrfkgRKbGdxVKi7W1fUWy1bPgmWCuNJkc6nQutcU5Y7nGTnINXqAYn5AcT9tu4WtXJnBsCJU9Gl3Rq+jg9Mfqd1PY7UkYLubR8ISoOXwUWDC3wme1NQdSGoQ0y/clKcOCwXFu321XpPvmYkpr2o7MzDOSnmpKgcG3tqaGWWgcDnIS+hqatzDflbcLR6NuXSO/FpGZm8Urb0VNfCRfz07hJXCXhG6kPEoM+MAbf1jtAlZO4d5xQt4JyzTrujB6+Le3T8cO6zHDH6oOuOz2RaIncP4XuWzRPSstfx2nir1Lm09cC/Ix061z8pd/zCBDlmu4xZdJTgvkJm9bipWj4ZEHJVoymioQnz4n9e4I8ztFekWDuetzE/nZASfQRFph2bTVoaDfCcZ8l2hpkFyL+upduVzPb3dx7Gio+nwOswIDLpAyXYOqTXU/Fapk9PBpv4lOUNbgcc76fRx13IxkWlF2MKPwSJq/nt5myIx2z3U8Lj1GXdEvyjrTZer3U7WgIPxJLc8WB6z6bwHgkJg8eSzHjo/QUpv/RC4FBpkTKdqRCprqcbju8/M+fwdwT9DlfaxGrlU1QCbfQo3iF+WonC6lhjPyHTZeXfiTAq0Gvp9FR7
 us7REE4K
 nkUYVYuGzTpCgrdZduBh/0JiYZYsdH0vw02wKMg6P/PokCAci5DT73ep48pWKDCNm+1x92jXq0bEWNyvh9rznazL7+RvMFN823rTglIWqq+9VN547Plw9NNq83L2nddfcXOO4IFH/NkOR6Abn4FBcey9/ckyLZGRIF6F1JyXSETKjsu8Dz12xJTc7b4Q9buAJSFQLaHMLfOLeczMggeTSx9VcvZS8lX4TWYmDIgXRlh15KUPoiecVLgeij/8ABF1P7ch4f6a/clU+zB578fXElqRioe+AZ0WTyeKnyl54kmL4IyrnKHdjP+podAMKN/lGkXqejI25kSuFCE1GnuRfe58ZlgGSz3P0IvsmHvnZeubBdz37uSNuryMV2Vmp58fS03eg0k73cOmgwvL7Q1afG9g6uzW64FRq3Y54sz2pdkXxGSFstwPL2jPo3mwo5/33zbxbwqSe7RLm0K2P/hFYoNMS+NlvsdbeZoOQcdlvFzXp0RqI48Qy3dBJRLX8Gj9G5WtGOr+T5AveC2jFd18micngV3g6u1AWi+QsVhYosk+NOtjNNDgWFMr3SEva/1mdJveNrD3WUjcycoeUITVovMJlLaupI/O3YQpwCcapNxs9LsxKn0r9c5b+m4j3NXTUBZ75axIyFeCoMQiNLppYtBjOyl1uHKf31N2g2Se1pQxJjgXYWDzz39VIuGgvusNQnMR3V2dU5OyzpW2yjJxKJx9xCaO2kOuKkMHuSJDhFX5A05jcFsRAHxWphswAL4zhkcBv6SBE6BDj6Pthe+6Flzmq878hNXQiCoxrqHxWQifoER7uL5V8HOQ4uBf3ujMpzj5TsDqgFF3vZJqQSwa+2GEtP0tVf6PWQiL9LoAh9So5cifY3VjvX2lGonrZsvxiFxTls+y+WO57iCKluBgAgK+CMZYNXst/01Xbit7iS7fgPpSEmkCByl84Slqs06j50rbusD+3rzmfMb140H66d/ZjYs/Y
 CBSajeQU
 bRUJcJyLIMPUnobd1Yyp5AezRubiEFpSRtj4gm/cTQyLkD8BmgqLrfkghS2vP1aqHYJulBBuhNrPVMCrRRK1pWIKF1R98mDUOWRQ1VHPGSDmWi9rqhf6CSEWorEEWheRLk3WlIglZjWrBfyjdCTUBkXO5zun8rWFXK0fddvmbL7bKTixiTmrsODuznD3fkUy0x84/9RbLDqENl6L3MXItf9soRakpj/KdbBqusEEiYvtXjOnjCy1RKxOfxnxFMk1+ACO/xi0xVLjLQfSKWSxdBqBAVePbVSsaAYSX0zkcLyP5WWpdaPMhXt+cq+vgmgWvq5O59eXuPS3NFueBlROuWK9PEgFDAlsHHPXf+zUPWeCXkWEDUkg+i950OWcbm7hTU2JoNLRuD6HhKi+JPg6QRIFoUK9T/xivpkAF93iFUyqKOaNrqpvweOEntAQlLUou+8sMtNkSn8N2uiikLDpVVKD29pyqEDdXGIg//TvLWF/ZyYOu26qv2riatLnEbEySQh7SqshMArbbVKktZhBdI9OxtlOwxOmOZeFnejo3Shl6pxv544uhWqxhxfz4GoBNoOZ4dSr87N/zpLXc91vetkb7rpW0TGy0jbPAcEnPOtvxdgnS3dBD/TRrZ2cMCMRuCMCDMrco26JjEhitQmvHe7FGbh/9QPraQByx/7nrv/RhAOCJh8rxJyhhsdFnvGMmZ6yvNRI+jCU3ObrcP64P17QfiLUAKn7hncwf7omWVuI3XduPI2t9mRPJkw2KY1gaZQeJ3ANcPPpnv29jB3/r+vSVdncU+7ztk31AM6/6BhHwUPCtKEPXF4gav//DJLdxon9KVv2JHEulzIZNG70l7mReZop/eDZwWpcuhYjWFXY8BX4ZM2I+bFC1ua08dyk69YVfNwcu1Q73+Dbnn6kXxGtQZ5ItmzqPWirL4D88e23AlS2Bu07F0PrffTn253u99fTwm+8n7Tk+u2Tr/8TLgpPc8XRq
 SGttXLuf
 mzl3t6qtuRHhCmdPwkvuyyN+l63GHbnuICkl5Ai4I79xTOCyXMdPG9dZjYGlim/5OPBUYDsL4bw/FCiSwtLDbH+s8+xy/957MVuAlex79YP0X4WQnyuAd/B2dxGxs1jiCJFviKC1isQUIUlHZftB9SsKLzNym6y0X8KZI6bp7NiWXq25+pt2bp9dbLp2fNLP4YrxmLoMoo7fZU9dkmntt9yndcu/iMccApIwE4el+Cq5gryEfME27HjbNFLE3RughTwoToeV+BNbEISDbOu2QG5wJQReYqVu/N8keNEVbt4cB9fm/hQwQYUZNUW10JcdAfZnj1H4dOR30O82zQDbvCFAguKJ9MmtK//Lmx4ZqAl21NTvSLe14f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> Now we have the expressive vma_is_kernel_owned() and vma_is_fixed_mapping()
> predicates, use them to determine whether to proceed with migration. This
> drops the VMA_IO_BIT test, which is safe as only kernel-owned mappings may
> set it.
> 
> hugetlb mappings remain excluded, as they are fixed mappings.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/migrate_device.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index b9c453c28795..b74c0ae42768 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -739,19 +739,21 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
>   */
>  int migrate_vma_setup(struct migrate_vma *args)
>  {
> +	const struct vm_area_struct *vma = args->vma;
>  	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
>  
>  	args->start &= PAGE_MASK;
>  	args->end &= PAGE_MASK;
> -	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
> -	    vma_is_dax(args->vma))
> +	if (!vma)
> +		return -EINVAL;
> +	if (vma_is_kernel_owned(vma) || vma_is_fixed_mapping(vma) ||
> +	    vma_is_dax(vma))
>  		return -EINVAL;
>  	if (nr_pages <= 0)
>  		return -EINVAL;
> -	if (args->start < args->vma->vm_start ||
> -	    args->start >= args->vma->vm_end)
> +	if (args->start < vma->vm_start || args->start >= vma->vm_end)
>  		return -EINVAL;
> -	if (args->end <= args->vma->vm_start || args->end > args->vma->vm_end)
> +	if (args->end <= vma->vm_start || args->end > vma->vm_end)
>  		return -EINVAL;
>  	if (!args->src || !args->dst)
>  		return -EINVAL;
> 

Much better, thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

