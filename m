Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31879CA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB8B6B0092; Mon, 12 Oct 2026 14:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B9F6B0095; Mon, 12 Oct 2026 14:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A906B0096; Mon, 12 Oct 2026 14:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F32C26B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:35:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58913A1298
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:35:56 +0000 (UTC)
X-FDA: 85314828312.15.DE36DAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id CB94E1A0006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:35:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TkoO9qGk;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791830154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jU1x/84DlGCNGu203wenlbGvVVAo1cCrNfBUl54k+9g=;
	b=MC+FmUeWBLE8Yj2eUdnXXd20TVGwo73AvUN2dP5ypQhzLcvg35gUhtETY2HsQHX+xzWk9m
	l5yTMEBclHniJkoIQAiRq7m1eUZNVvb2Wv38MMWOTF56cs8TQ2q5UKiHs0E7H7CeweECIy
	dpDgNt8ECAgWF+5T7r2ehFC7W+TjI+g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TkoO9qGk;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791830154;
	b=43IwjSkMt3d/fLP2rpYsMGxRFysqHKAuVmtNUk3Jz3aTzV//rrWNhRlCt4I0aD8+re6Oew
	ss0r2+FsTraOGLErBgAuhYqdqTsRFraTuVVsoyZI6JnFYi8HLtt8hthdQSjNoK0ZGDuf18
	tlHn3Q2km354lExnMGUwmnKgiUTWdZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADA7C601E4;
	Mon, 12 Oct 2026 18:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9F21F0089B;
	Mon, 12 Oct 2026 18:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830153;
	bh=jU1x/84DlGCNGu203wenlbGvVVAo1cCrNfBUl54k+9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TkoO9qGkYGW1FWj2/mgiryBfpjnccwprQC1E7o5f83BDlENqZ8WPD/ofG4UHSiZZJ
	 2vTfSnSa6AfkIRzL17M7Qz3/R8466zAY4o0xL3ERQQ5qospe99h7jGb2E56B+IpTh+
	 d24PWBY7F0GHc5FcjGCh7xfi2y8M1O5anCjwIHtWAObmFhqYcKzxPoXONOOcxQPLwF
	 1BC4mXOJVOwyb8zVOJNG8qTcKgDAS/9MxT6XcESD/Gzwg/+VdpY2WOqwMVOUhDNiXC
	 MWmuJCQgGgWTNDRl4BnHkHTA4wJmP83NrXpTXiIzc3wpmWufJck7EqkStuGgGwvu18
	 ILC0aMgVybhUA==
Date: Mon, 12 Oct 2026 19:35:19 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
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
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Bert Karwatzki <spasswolf@web.de>
Subject: Re: [PATCH v5 24/38] mm/vma: enforce that mm-managed mappings may
 not set VMA_IO_BIT
Message-ID: <as0nF53W7dug-Fem@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-24-923b70125b1e@kernel.org>
 <5d51b6b3-ad58-4827-bedf-f1a79ebd5c86@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d51b6b3-ad58-4827-bedf-f1a79ebd5c86@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CB94E1A0006
X-Rspam-User: 
X-Stat-Signature: b5epnci9a1nbce1jz1oc8d7za99yrex9
X-HE-Tag: 1791830154-541520
X-HE-Meta: U2FsdGVkX1+1MbB2jmUlQfpG8iHRYJTz+7NzrppycjxzJzM3nylFl4iaaIOomVRANp6pyuuECstTdFwTkGlokuXM2bERfxnePrZuX/jOLA8vpirXWTTZH0rf9KHInlBcjf4t8/YdpkPUN/F9StgYGP/potBTO7dwf5o6nikGuY7ecwV4NzOnLUxOeglPN3J0s3x/YFNvP8+7jiCibCg8UcPQmjumi7PfgFJl6Gd31JbYRlhBIBAr6kNsu0F+UQgoqJtQyJdv8l0o4R0vVuP0GZzGp/8VSW8u7Q2rKLdz5p57e3HOX4TiXa5jzXB8IgZEZb0CNZiq54RUyZJtYDJxExyShmvjK2B4rJb+xE3bIXJIGTco6YaqN/BynOEmEyv7kVefxNPRlOGIq8Auy6oGQbmBv4ISof1Sa1SRb9xZAZMSpH+hTVOaB/Ax8OqPq4pfUusTiCDOY0sJA74O8znuWxmRWCSOBofYXAApI/dw9gZ6NFyjk0hzlFlILnkDLIBEQ43dgMC6VFokFagBnH+FkrA/96zuT1HIBrOjVSaHnVyVQnuIViCG286zi+jTA72Q/RVb0lrPmpWclDawk+BYE/tHceGaYy70cFMRKo7ZBsMy6fbt5+71f3jS+W7QuCW4F8yk7riCvq8hMD0j/8LMArMeDLt/f2jF67HJQ2x5j9mLE6QNWWbBhSO/JDDT2mkOvkq9gEL7mB2U0bJCiXZYpri8fzTfFVnJPsHuOU/pv6CP6F83Q6eZaVhz5MnogDymi9dO3UDxHZkKhFGeNWk5OwOUjWxcbj7mej6Cw+/O4q1SMzUmcy0QN+4R9IxiYJfmvF6WAjEjQIp3DV0RmgzmFsHDEacZ4+ZVQ+/JlFVaYsKiGAntVsL7X1tiYqKJ6KJPzUt0vctsQsQXTlgQOwc/gYtjOjj6Cz3FtnRl5nj22CBHhAGs2xChJyKBIxZuM7N4qVo1Wtfefd7BpWBlilO
 Fw/ZCOpo
 6hDT1dvrgLPwdv8RwKwQroaTVeABy9+UhKKNEEZPANbllcuSWCSZLDVMuCO8Kc7B56TduDupNS8N/AiXCfTaMY8L/KKbKH/FdVLXDxYSPYUMwmPXJ7gFA2kNB7+1VYM3SQiVfk9OZvNT6FJwj411iP+wdh3c49EUeaw6bjYlJgBnKwf0Z0l7wZplxhQJHu8OLEX5bArq7x8myj1eWIaajtyplz6qcGtSP9nGaM7wDF4tX/I0k64rz/O+QruJ4/8nIj3drNbnaJ5/SlIgAUWV7J2Va1IKeGdSeqD6QZKzaF78WfSFHHVmv2WA8qfnDeGQ4cZA5NvwTJnhzrBy2w9K6T2+kV6QxxfKDgDuM2RHPsOM2lURxAvK5S7jWqlXsWhJ785CuW2fnYBjdd+fnQLe/3g3+vFw4rLmFz4znsvIGVgrFGlBvA4VdoKQaLPwcDuDIn3gXA3jySHqNqMpmwICeQ1C1NC9rSBeCsqiALnp+L9CS9uOfZC+F2Ypc+tWHoizsYvwECIjCrCuzvsXOAD/VNyFMVQgF8QwR+LfE2+gnI8o8EUg3o4NK+AfAS/P2i1eDaznosz+Sylcbj5DFNFa0Pmydq0W7C3zwugt0tOMAbZo+SrqzZA8FFLJeBVrZoGftFiI+m4i+azf6Q0U3ZmOtym7iaH5F6qV+cwQdqfj0r3zd5fkIKl+kA05LUI4F/rlvBAL7QTgK8e1B40FHMPu6ehtsHOeeGjHCrEHFNJ6NCCLL2EAGn9wsjUf7d/AIRgJyTv1CLuA+4hteTB59Fu1h71WHJbUxvvrHjB/HNvqK2WnwdSZaxZpm56U8vKzZQJIUE2gHCKOAZKERFE6JuG95+5v6hgcvWJDOCTIHuZlzHkB6rvAla+QlQ8mSK/qeNpsgeR4oCoOIqCJ8wq7ZCS+E3wZPeI37Gg+QjVYmvm5pEpMDq5Mlia9z6wh5NYugxdT19/WNrZ7MfJJClTvc6S1REQ6EMCjd
 RF0ClYDj
 ClY9WbAO0KP1Nrg4p0EvgIgyELt5U6YFxCBwQLM0RaLvWICZr+0jlcAN46qKrqXTZRlfKJpHyRDXIJ7nLDk6WeXNlWs0N6VJg8915kDqj/2jXW0RBThCvzkZtWsb914fzahHOdPsP45wvf56RkyErc+UYrM9JuzJy9NYjMO2bNguA2tjfbOGzIsbgjjPb32kCWFxcGPAKf1Hm+kscb18S4CHmZMX6lTky4lKPcVTr326EJNddYTKvWg2JAiSJHEtk5f9n0mirPZtyrhGdCFipOyice+9PqFG1C+A4mQY/rItgSCNxjvMqLa1JzZnuOBCnG+Vdq6WSnSZZXDTDWLuPowsQ2tyylqicR1ooPwdRClShEhs4L6eN8U6pQnQ+jEjLSmgGypDm1XcaMZ4jXHU0nAIrEzRlovNpQAF1TpZAq6tu+bps4bkipTmnCDEKD/BLdnr3DpBF64c43jivCHsTZQJufjerbONB2ENEqVo9AttSU/F3uQ9mPGWl9o+n6wRkHr9cJOGmv7cXxwWZ+BvVApPHiL1VSxI9ZR/xS/d36uc64ANU8YsTxLLPzz5TXcT3iYAvbnGEVULli5oViYg0Eaecowms7U+JgOlJ9VAS8k3ALMsDnHhNrcnZBTtf4g44U/HyHxHXH4r/4EYYsLWhkyyRpQkLMIpi0Zk25Gkim9coe7jpSdagzZ/AdZgCPR99LlVoUL3FFXQnDuVlNOQD/vy16IAFbtRXe/E2w1LqIyUb5jNv5QQYEkNpZL4eElUN+U92I8v3mwgOmZk2YrhWlvEgdypljQNmBhVcEremU11tg0kg0x83v9H/68sGrfWAzjMPNaJ0DGBknbZ2x49Gc9Ki1UfvnmYAbH4Qp7Y5qynLTgbX2CGFUn5NqDPI5b5LFKSS58tsYxwacfhBS3F4qAW/ki28MjHR8qamT2dJb6br7FjJb744LbakxMC6dAHZmpHFvV4A6Lj58Pw/wYwP9WmwJzAQ
 dhC1jnaV
 sHeMF/eIMgnFw2pVLfQSjmNxhuPt28V49zLXFmc0WLj6JWzZGYxPh4UzW+yIP8bAE4eSwj+CD80JdnAB5+XWuUgS5syFKwa0S8ePaDR+JLWxr1kOE7oFm4rdcAa9Gbzk0C/FJxum2YkgW1+q0LoR0HmOjF6Ag276GzQTX29nEOZUoAwpG7bGlCuS4KUWHXEN6xT8anAvYyyVjq0yk0huInwB+xMU3fofzr8Zo3V7m/oMImrMiG3XYnOFaeyT3CfxQrxglKYjkYlaHZ7xvXoYeLOzMMCHbo2Jzg3iZPp3UVEgFxlgixRbKyWm9nxMYZyXILClYJUwkha5uWCFEbYYp67DiIrd/u7ef3/9aLIpgSzcBMTf5Nixf3BXxiLW/DNJx/GRTXEqWhANByD12627R5AHgtFts1ivt1kLF3dawT3018dJuqC8n0tkdsyoxVEFOde3DAGNknkkmv8E6VmaxYufFlyjoEJtKZ/+Uzuxb8Xa19rgh5lSXobAx2ENPT0RaV7aTpRXAr2rytC+dIjCJ3sqAgAWk4uE0Ubl1N9eUI5OvyrwbtBbLaOXjUIPFIIQpDViOd89576cmHlH1q6K7oC1Dm1fnNcY8yBOGF4TBwqjmdjCPzD26UwOTHN+H0kbZa0D/ltiR01iT3zFIivBLlLqeyiIiLTQVzSHCw8Me4yVfh/7NfoPRWnx6dTXg0Dgp7/sWWhT/GdD6xaeTpo0laNybHhY950WPe+jcMOpHLkG32VHk+LjKYBYK+mJNAG/t0bc9qlf0S6dMgqc8II+qmcqw8Yvy4a0Tehbt5IB75CfWaNyts4m+yDeHNjMH+HLT5ubyj5YQZxZJUzUZQxmVGCj3pahpLVG6706Qdug8ovJhSgYaQYWm3gJpo5hEqAwiQGnPTyHMzE3oJUVs9JNXvXNFf52p6J7vP647eLUJnOSourEAAvkUWTfqHOGQqeIHX3JcaSvztpd8ZULStu/Oi8nQNvY+
 DBWg8igr
 8e0yuguptd2Sb/nN9+jvBtdVKIUZO/QsWFO5mPJ45IzuAcjvo3V4Rg4KODfPq7kuHhUeUODRChxWXmBPZQEJpnHaoqmwH689rXYEyN+Y5D0aoEUgZ6YoOGz31VfnuQUxSk0w2g4XFvAoeW2L6RF8x9jC7tmduk6u/jkTO+eHvH2Bsbgd7nCz8Co+B+Vx2pHWfDvfhru5uoAeRaycnas5kTwhC2MvZ0P9eAqASk1Xcdey/M3PJZ0r4jX/9L9QcI5wPziUhgocPFUioMm1Xecm5ge/zfWcpma7sjuy3s1nS/l/IBSV58nbQcz22B+IjI+E9n6M4pWCyHKE0Q22Hnn1DXlESHgVCtyOYixS2WWxnQP/V70GNxgZ855L3xcprYRSV1tIae0UHUew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:25:54PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> > It makes no sense for a mapping whose contents the kernel does not own to
> > specify that the range is MMIO.
> >
> > Prior to this patch, all in-tree drivers which did so have been updated
> > such that they are marked as not being mm-managed. The check WARNs and
> > fails the mmap for any out-of-tree driver that still sets VMA_IO_BIT
> > without a kernel mapping.
> >
> > No functional change intended for in-tree code.
> >
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/vma.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 4f09fb98a2fd..51bdbe08bb02 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2796,6 +2796,12 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
> >  		return -EINVAL;
> >  #endif
> >
> > +	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
> > +		/* mm-managed mappings may not set VMA_IO_BIT. */
> > +		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
> > +			return -EINVAL;
>
> We do have a helper (vma_flags_is_mm_managed()) but we're not using it because
> of the VM_IO situation ...

That gets removed.

>
> That's confusing ...
>
> Could we do something like testing vma_flags_is_mm_managed(), but removing the
> VM_IO flag from the checked flags?

I mean we do that in a subsequent commit, I think even the next one?


>
> Then we can add a comment about VM_IO in the future getting remove from
> vma_flags_is_mm_managed() ...

Yeah, but to do that the code would now be something like:

	vma_flags_t masked = flags;

	/*
	  * vma_flags_is_mm_managed() tests VMA_IO_BIT, which will be removed
	 * in the next commit.
	 */
	vma_flags_clear(&flags, VMA_IO_BIT);
	if (!vma_flags_is_mm_managed(masked)) {
		...
	}

Is that really worth it?

I don't think there's really too much confusion intra-patch about that is there?

--
Cheers, Lorenzo

