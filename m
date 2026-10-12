Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C9FACC6B01
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1886B0092; Mon, 12 Oct 2026 14:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61F56B0095; Mon, 12 Oct 2026 14:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92A326B0096; Mon, 12 Oct 2026 14:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2AD6B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:58:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D50FDA0B17
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:58:24 +0000 (UTC)
X-FDA: 85314884928.18.1CD21A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 17B8BC0005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:58:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=looXlA6f;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791831503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qH+yTBGHMx4kskcBpBDKONKQ96Db6V1NplbT44nRvZo=;
	b=hQ29e2VJ/H6mbJhPxl/kmOePkcDOF4J9v7Kggc0QFPJCcOQUavWOqkqreyiAl+32e7MahT
	S+IV8ZRPWDJ3NcXbF7QVIoGawB0sElSN/B3EKcQo7KWhVIfrWrCgVnulwabHRF6Gum0wCP
	d363BLqxd7E2H5qCR3RtMn0Wamln5XY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=looXlA6f;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791831503;
	b=4rlGxADqb2c4vS41o0bigqh5wQxLdeWFKXxBEgkdoVSX5tVy4+q/nHX8BlZGebwEtqlUn5
	zGHEfvBQAYvic6vFldmof0zPPJe8/jqRCYzN9Seca3kc4y2SIUojyvi+GGl23Q6GYEGDgv
	rmdYbqqOpyf9zDPg6tOD7LO82z/kbEQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28E1A42E05;
	Mon, 12 Oct 2026 18:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EB01F0089B;
	Mon, 12 Oct 2026 18:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791831502;
	bh=qH+yTBGHMx4kskcBpBDKONKQ96Db6V1NplbT44nRvZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=looXlA6fTwVHV01oPQjKIsaLN7qg4gOfpfxfIKT2JYCP5qc6mtNOfKXzipcBrh5Ot
	 PwTlWcUh8iMGaWDsLLerJWirxQS11zQ+uNPPZD56vjlnfd4Xt8Ty0QR2gLNZRLAVmZ
	 XB2AV4YuqJ2oKkV2g5m/6Icmp243c7oQwlXcOgSGhet9aPBJl7BLHiRyQaIFfTFg5f
	 R5mIs3NuvgJeGZzERtd7pZ/l5Ywtb7I+I+N5/X1JMKypG8+SLTaEsyrMX/W1aLWQJP
	 x0/ar3g7y36ElH0BWNMVIYJBfaYlLx77JuLREXrJFvmLlG+LDzzGKzUyJUzEJO7zAF
	 41OpXgdKh9hhA==
Date: Mon, 12 Oct 2026 19:57:46 +0100
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
Message-ID: <as0tfn85BbcLs-Kn@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-24-923b70125b1e@kernel.org>
 <5d51b6b3-ad58-4827-bedf-f1a79ebd5c86@kernel.org>
 <as0nF53W7dug-Fem@gremlin>
 <5ba7305f-0ad1-44ee-be0b-36752684cdb9@kernel.org>
 <as0qUOfS-FQgRnm4@gremlin>
 <c0b212bb-da62-476b-a16d-2ce78e1e2639@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0b212bb-da62-476b-a16d-2ce78e1e2639@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 17B8BC0005
X-Rspam-User: 
X-Stat-Signature: 6anx4izkzidtrbyxdmd1r1tzutxa3ao5
X-HE-Tag: 1791831502-561556
X-HE-Meta: U2FsdGVkX1+dO6VdUEsKqzYqWm3/b7z73eJBjIL3OA8iwfn+j5rSkWLEJp0Zyrps9XHWAAcpCUUHxCjm+z+L/k+38tD5/aqr1rEr12P4jph35lDpFkOZ1dIjCDyk5Z87gQD9nMJqfb7xQOXOMHwZJcHcQqP8sPOC6TtICs+s34zd2nVo8XnTmLEbcH1XZ2vHfTUIeFvsZjjc5SJxMr9BrEXl30S1GWM0xuPPBI2rMumgMl9D/XN8sn3YHPyJ+se6bbrR3/9pWDuEL9O81zp7ufI/7A6jheDz8YBULHiftOqq7ejguPSJxrRZ1Zx8OieMfEyqLfE43FY/WvXNhzW64aXJ3mtIfXe7Op+maZnl9EpR6puxktCuG7zOsgR9jguxE00oMKcBcB1KyKbSJD3AFYxLaPa107gbi82ovNleBQQqnUglPMy8/YyaMR+vNULw/Pqn5BUyvkGP4ssWG8alOPkyeqTPgk7zegQo9KP/a26IJmX96M6TrMZwNos+zGomkOjnqmRtAqAaChWUA1cuozHyWEjuDk/+xWtdjbXn2bAQ5mdoN+tydw/QKJv+m0Gw7c2Nq+Vkr08KnzfnnwsUA/sOTujw153Up46aQ8erLAEH6+tRcStytICPgFjKk208gXu85ppV/Eq04EXEeWWj3GwuLGmXeL/Z3qW6nV7f89PYa8tQczL8hLLRmDB7WIZa3mZYadvZqPFpREOzCG4ohcwhUlgWl5NmwmeNty2l9PR6CyMyxP9NgYd0NplW2s/a0JaFounf3QZj7Lm69n17EWsRbCtbJruTy181AgG2LY5TW+rj/apHkbmL6u4VxNZ4IW373oH6ZueRmvQ1CN9Bwi0WzlZ2AGwoA2d86snUrb+xNBQbzYxpDUiuCYhH6QRxUeRWrTD0BtGkxo1TS7MHGSqnUCoy3YbLzG9uRCIPLvAP27AF/PSWESXLjoeGWRm8WvuPyYdwG8WrSt30iZb
 Nl5/LHZ/
 QzdLZp6DH6dr18n6iwKqSKy+0bBDqnHVyO/L6gQBG0+8AcHAJKIiLizA44J9D8Enmq1wU9uTmLA6Fttl9L4IfdL8W/wQJDTC/3oLyxCvwWx74TgUrHwqWvxRJmhGQTuQkcXuzxCeJTnQ9TniFuFEEj3zh4UGjpDq0ZMSx3rgo7KR9yVhP6byeaPk7N6pFsWbKzB9t+ifLEBab4I/tWKbNq1352RFGjqRPp3RtdojsYQ+jGhAYBclvzQAPcDM2KEp+Lrhy6dIhMGZSkeSJ2uRxuv+2tYnDQMR0VGGdvv0ALZgTouLfDDcK0LiJIH7eWtvDuk37eYVH/Gn64XqGB5wghprs8Ts3pEpnIDf30xc0SJXIYMOHL2/PwAWBxy7QniVD43BcKcm1UHcXwOSmNGjipllkTdPbXIro82dyzNzEE03hZJi6a3famQ0VjlkqqgvYezX6PbRRU6kfJJDevebrz4RI2SvC37n/GSytWMeRxAVONZvFGgoVKIGHteh+Q+n4rvRnHArcRsQB4AU5rGFD/TB0iICnEQeffDszrTJ06vBFK8q6801VUi3xR5MrKKOFwi0VVKdZHsb0VshLVKVI9DOwJElpJz7NLUj140BNyRkXavqGX5ip87JE8R6iOkHiwAizsg9uQm2QN/zhBJt0bft4dcH31Oh9vfbv3vMCOA6O/GsEAOj5IMdOSreYVHN35YTJSacz+Sh0wxPJbH87lDyc0dI9C+XQ9gNFdehJmvNlDFhO+YKOyDgyJooFMA4yaiAwOksRi7+f6Svb5blQiXRRRY9EhCPXbfx0z8SI/Qv1kt8D1Ffh8EW9XYqS9Pp286bXSbfWVD8Qzc1zm5W8JlTQOJYUCaGwEwxtTH9fh8gbE1+/X04MQytocTOcR3d0t1xVq4fFI+wzJRn/3iXqlooY18O65BRNn57YvV2ve3gMfCazgrcVGEea7ajCg/TZkemGaRohBkK9G5rO2SuZh5uj0S4y
 OK7RWymX
 D4VOkryV8NSV0nZNHEhR/A8ABBdgWl0luBjM/hRNG3RB+GE7xZcMmkQN5EXO9YGW4tERndutOImFeL4L7BRaMsJdlr8s5Sbp7tukb6LU8ijRbW0saO/brZ7v9H+S5EgLHSjAVO6V84WhNd+NCVAEpWJwgJ1aEkdBlryjjq4B5vti9zIbeAIudj7kDvVoXjQDrjuLmLI1mm6FY7CjATAsVAIl0uWILVfDg+AKCC/Ax3weTyPv2b2JdAs2cmyEDhO5F0I7KoiRNQA8leIDE/5lx3/Gcl5KlYUnhMSVr9ed6UWOv8VP90m3bb6mjJ6FG6ZmBgaAvGuKUG/G8mItmAaIPVOeIfg6JrMT/+TjepQrsu3cYTOwJdRKaqz3zphEkoXdDIWnNMEMkgBWiJPnRfUtz4Zk2XDjVRCeVcW9oA4rlZTyBrA3YtG4iFzY6HXVQiVaghUtaEshCsbSl2fPppkHJJfMmfYBHWJIvVK9pe10YaaZJRo7Z69AwPFpqy5vm8xzWeOG4BHYfoWpUAuH35faJnD/m6baHIRAYHR8zbhkIXi8v9Xwqc1JHcXI3x7ULLvUusTdhh+Op6T+8qwxJgf6NjRLmyg6SWe3Ye1AKh8kwZ264SB8sDWqnc1+54ZSIbrm/m4EunnJ2uuScbASCBf96gkXqDb4TYQIVq+MvouFAGWo4wDDbC/AucTlhzKw8qRF+WRBTJEzXvb65szZDh690F5WWVzaKQC8EDpE5UyyaEgibvV5sAbhnvGb7zZ5cFvXUAdAKdXAETOnpm3hea/aO6idTr9MFtqKW5WowTldMXDBnO8xZPJVPcQYzTomFrYW5D6BzhyK5y9wZq80/cvRy+nFmWnK7XyJNyHxwWJv0zPo18Ov0uIAJgKHjp9cLTOqNIKVFwJUQ/Bw2LAQ5MMUnYYtK4rxwj5z7bHtYt4GyqfWxL+jvXPCidtofgKAuIJSfF57LweJMdFtkL3WOrMN2iI/QoIcL
 0YdDTgfg
 jQB1AMZNZE7D5JHcqdQT/SLvT3qzrbAGxyYncY2MezkYRRa8u8Tahm9DC4WnriAGFx5l4Hks8Q2B7Y9mDLBx2uL6syd0DTYFsdE7n1PZKbVf5bfOKM+QrJljDzfC+M6jGxy05yZxcl58U6rKi+Epzl1YfeX7AXzlvEu7txPBDVTSh2O28P9yL6HRMsy4fMaQpcwJt0t/wDeCD/PJXor0TZFs4FxPJbTLEuauxUiOh3qQ38vf0vih38Qqf0VP2P9VruTecrEDPMgfRwqYjT50dQZ6ZFcACRUoY+Ozfm8lqDJSKov2z+3R+HRUH7FVNxEU6ByS3SSQIeEIjYF6GbE0KeKOyg/V678hFXEVYx8WsELEBMKsTxgKWsDnCY5rLFRddM0mKPYAv8lVjxN3eFfNZgQA/Xf5AfggiTCSqVV1ZhuUxaH6nDarOtSZZb5G77Aqwi+EN+fGT6xLme0C/cATialuxEvNR4I3BndZJ8HEfrCvfUH2r7p1Deh5TVbYcJdEsxpI2GmdbItYPPIN2gADVgbKCMK+hU/q9P8ujcczbPx7pqPYSEwrfX8XXZ8oOF2K0UBaDwDeHKp4tzLsfnVFOeXywdPT+bhpKOlx5X8TanG02DwodTe3wc4pPAVKTI61fUKWWNVInMX1Gp1fP7ctKa6N/FDrL05eDBnOqkPMnqVbXNsyuD37Om9k1aROaY01TJXv/xTwsgd032NxOy4872VElH1YdA25YxhD//F6Sl8sycTy8rQfpd6LN3QlLB8UXVxpbJAe+5NMVB/Rar462r5MWCXHeDJDivfvSEhHAIXxhmmxVuJuGtl+BIECxwTzxlrOmkZT4m2UA/16xETl635425Z0+laSvDDy6i1K/jFCxkg82F5QezO/xZeCEQEoGexc3r499X4N1WGPCCN1jsivL4tTNa6rfFHULWVQlwW+zDIKwiggDU+RH1IqT/RuGnTDAOiKS5iwwXhMisRC4M89VJwcp
 pP+xvrkC
 0Jx/1fIQWAgrogEJmyhgIB/M8EQe54R2BXVKurDPdbjGKbRpIAaPTsmNYpwX7v2PNnFcLXo8KyOiPW4DmGk+N6Gcr3LpcJ0WGCfJ5dmhkzBDmc2v9qNoqW6kk2TUtGBD7Bg0ewo9FrCdBwqgjry7IePaB+JgMuJ/BNcaApy01h5VNoPy4S1hmkm7kdlFpwRQXzat0UgZPrD70vv9M4DykVKoqQnjEbaxj/l6WvShJ+/z31i/j0NL3T+3bOrBy2k+csydoJ09U/a/SQ6cDaY/mRktmEqt/KdBxR75kW0V/M6VGk6sSb07sq/0+OaKpVsQEMU38DgIGeU4moKmrjeTE4UAgikhWLkH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:51:10PM +0200, David Hildenbrand (Arm) wrote:
> On 10/12/26 20:48, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Oct 12, 2026 at 08:39:35PM +0200, David Hildenbrand (Arm) wrote:
> >> On 10/12/26 20:35, Lorenzo Stoakes (ARM) wrote:
> >>>
> >>> That gets removed.
> >>>
> >>>
> >>> I mean we do that in a subsequent commit, I think even the next one?
> >>>
> >>>
> >>>
> >>> Yeah, but to do that the code would now be something like:
> >>>
> >>> 	vma_flags_t masked = flags;
> >>>
> >>> 	/*
> >>> 	  * vma_flags_is_mm_managed() tests VMA_IO_BIT, which will be removed
> >>> 	 * in the next commit.
> >>> 	 */
> >>> 	vma_flags_clear(&flags, VMA_IO_BIT);
> >>> 	if (!vma_flags_is_mm_managed(masked)) {
> >>> 		...
> >>> 	}
> >>>
> >>> Is that really worth it?
> >>>
> >>> I don't think there's really too much confusion intra-patch about that is there?
> >>
> >> I would do it as above (- the comment, as that is the next patch indeed) and
> >> only remove the vma_flags_clear() in the next patch.
> >>
> >> But in any case, you should spell out that this is only temporary in the patch
> >> description :)
> >
> > And then there's a 'masked' variable that is unused?
> >
> > You need to have two vma_flags_t variables to be able both clear VMA_IO_BIT
> > and use vma_flags_is_mm_managed().
> >
> > So the change would have to be
> >
> > + 	vma_flags_t masked = *flags;
> > +
> > + 	vma_flags_clear(&flags, VMA_IO_BIT);
> > + 	if (!vma_flags_is_mm_managed(&masked)) {
> > + 		...
> > + 	}
> >
> > Then:
> >
> > - 	vma_flags_t masked = *flags;
> > -
> > - 	vma_flags_clear(&flags, VMA_IO_BIT);
> > - 	if (!vma_flags_is_mm_managed(&masked)) {
> > + 	if (!vma_flags_is_mm_managed(flags)) {
> >  		...
> >  	}
> >
> > Which doesn't really seem worth it for somebody who is confused between two
> > patches mid-series.
> >
> > But if you feel strongly I can make the change like that?
>
> Whatever you prefer. Most important thing for me was finding it in the next
> patch and being pleasantly surprised ;)

I'd rather not then!

It was always intended that way, this was all part of a careful dance to ensure
correct behaviour right up until the point where we enforce that VMA_IO_BIT is only set when appropriate.

I can update the commit message to reflect it.

--
Cheers, Lorenzo

