Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8807C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057146B0093; Fri, 18 Sep 2026 09:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23466B0098; Fri, 18 Sep 2026 09:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB566B0099; Fri, 18 Sep 2026 09:00:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B39ED6B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:00:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FCF014061C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:00:04 +0000 (UTC)
X-FDA: 85226890728.09.9251F1D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6BEA5A0005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:00:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=doaKhNAy;
	spf=pass (imf25.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789736402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tFEJAKtD9mmde2H4PbcVbjy8oluS9JrKkxB0Up7WPqU=;
	b=469eEvddzxLM0JgOe49/hOCLkBjkPqr6RuTwdoU7wrFpPCy7kAoXHE38GZKNrw1t7M0fXN
	AhvHBlRUBu2vmfDmnubWFSUWwTUsBd6BxZaK2d3DEu8lSYolizCrTMSRmUTGsXbtYXrQY9
	MfpJhU5YueOG0lG9yVbgKxLjghDe018=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789736402;
	b=C+86pFS4lCZne55dosAL/riHDYkrSpSFY58eSIQdl35zvASMDGnoREYdYDjcpCn28/1r8G
	6YLNUXFquIR2pUfQUa1j85gCEHIZAMMVesc8srGYxhzm6NJj+aqtW8itknT+DD8kMhstEV
	GSqXDXsBSUXweNk///nQDTT+FIBWt3Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=doaKhNAy;
	spf=pass (imf25.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tFEJAKtD9mmde2H4PbcVbjy8oluS9JrKkxB0Up7WPqU=; b=doaKhNAybvn/PmhBX86Gi+7t3T
	QH5iPoxVyvmEHWG83eTRJM9o4ZunjctnxQa8j36AFkUmkVOgAR7y9lYyUO+8Ew7Y9LDYUjDX1Rse3
	NACgdCdDzZb/bAGim+VyCazzwjiCtehdfLhm8bSqggh0UROL0tVLejVQjBijz+QaYJl2uetfHRc5g
	RXK/frKyTYKFcWRh+9vzWcXg+EdL8OovvX1t0ug37AWhIuF8+67JSnP9Mdp17zAIGwNediac6ShCF
	k2QDzSzmnlid5Z24SbXD5fKP6vGN6tHG99LV+v1Eeb6mJUW+fXAFJKwV34SNAoZUlnqryynx9XyFq
	4XtIZ3eA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7YAO-006k2B-2q;
	Fri, 18 Sep 2026 12:58:13 +0000
Date: Fri, 18 Sep 2026 05:57:51 -0700
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
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
Subject: Re: [PATCH v2 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <aq01JFp8hRReyY-O@gmail.com>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-1-7d9781ed5361@kernel.org>
 <aquz9Z9JrK_H_E0g@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aquz9Z9JrK_H_E0g@kernel.org>
X-Debian-User: leitao
X-Stat-Signature: japmmwy4wu6dbnyd55djcd9dyq9kdsto
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BEA5A0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789736402-975103
X-HE-Meta: U2FsdGVkX18aeoeK7Pj0oFn6EKR3fE4sNbHhKmHeFQjvez9Bq+9dP4grCCm4gcFl0OmBtbMcVeRXLDesjn5sBXgNdrbfgGFXIq7UIq2PD2h2oi9Pmz2Zh/SUbXIgqhKwgQuZAaVEEPC6LBCRT1kHUMDA4UhTB3cfb8PTGButcWpIz42z/r9ZH6Z/3HZdJm1dr/93pgBkeS3UV5cgxexJM99Qd5TLHcGJzxPVtmn3qWVKVu3TRxNJm6EHTjeQfjqd1dNKRFy99TJBwyQvGgGIBlnm/YUNbIqHBl/SxenBntspiJCPe03j3/tLG9lfkfhS5NU5n+GIgLrqw3ckYPXlBuDzJqZJOf2GXWPFxAEi2uZCwZ3GxZtvZ8s6G/dHn47Te6ezaFgF1d33lf+xNvL3YaUF2TegRKWP2+gTsFIpotqKQF7sd9J3e/cPAStEiT4C8Qo/Xh0Ril7uHTFiTOEHs9k2JYadxsupfxJv33IYIKaD/iOgR8D04L+TBsSHoew+TxPHCX6Iwlv7Q5+n1O/wLArQJz90elxUh3LhOpU+n4cpkeXstQuczZbIN3WFpTdL11orPg3EZ3PeaA2ci2CtL+qyhLhLjgUqMzDqq7uRT3hp/s+WA4P7DUxDEQTIhYFrb1ZkWdX8XDTPt3TlXxo/+pDe0IIOy13AH0ZNkLApRpBj8bP1lzxdrZKzcxABRwkIY+5u107ZWGjmaS8EcvfeeqPbos43cBmqvWxbDznBHNKRdSP+SpJ91wOOW/QxrMZUi0g+lPb2eeeS0+rh2odA1vHzpGRwN7/3eP+bZnVGeYR3sAJylbgyQwt0o1HTrQAOzV3r+3pToGYWmQV5hnuGq3JSIo5GsB/Q/ZBzZQcSrKEuNhbatjICiPJTxYFTXngOVmJNsunEGY0mWSErwlNcCGbTQ6xnDAPSbO45e3HlLvbwNo8I+4wkbq7keRbKER5vO0ndxrPnNgNJWBa4OHY
 z8FTjnKz
 GZv4vqyHNU4bMB7XLeAFwbvekd8VucyivdUo+XlTnhMBZrRWfSwDtSfEq71yMvnF8jVBtaRqwENkdse6ESPqJZTQ23fAOOunhdR7bwAr1OLLAfdLWpfmW+4aQjEnFC/NVvSEF8SMYZvdVoAiEWjtfo7c3zP/2xc2BRjUXs8mkdvnFl7TbuR4aWiT+RSO0FzCE64vjG0e/GzC95c9bB36zlb4z34qmCQTt0n3EFJ+kcazLf7fRroatu9KrhubCZaqwvgv5R5d5O6nVESKGbiTxkjHdUtlDbyqbzGH4I/SA4nmC5RYbX6/xCTMjS8qZXHI522ky2I0J8BTYzHXPaaX9iOq/umrYLby54zZHm4OJ2TYIYDWZ5b2NNqtE5UO2ynL6E7ceh/um77FkX+28HUvyuBb14omuXOwLa5S64tFUo7x0Kc+dgXUkb+X1xy8+0RlJKHNfEUNEWY+CVfctLj4nMPh4tkj0FW48WVDCwZU2XSB4KoKMt7SwHcHHlJCFrqg2MDd32mht11YBdmm0uUn0l5Evl7MBHPFwOoZSUt7W+E7s1feEXDpSXp7dIYxjlNfP0iafYYkQ4NkTbm2wiqoa7G0xsetshRiEiJfeKSctxPlS9xYaeDol7P5ejjbsyoXbXOaD/PvI2TLPA5DFSsxwij/joQJwvqvPnzOOxwtQtGNkLqezX4BNRndjAI8r8KQE1Qh6h6U+SZi/7w2PxsScAJAvhzdNOPc9xnmCUDT/2gbqiO+B3eu6gonnEdUqY9kDJEuoOGuaV9Jq+8qQo+ZazXCGtd8Y7VWV5I0XKZPOCYtFkbchotrgihE3aW3iCax5Q0mJmCpPvoKn89Nr9/HQ6a9rTqPJq/xsIajMafmOOzl/flR/VotjMeiEZeSbjfVNKsyaBNTYb/hALo4X8t0rxx1KHlvfOOoX5KI5XeaqFChsCzAdg0Ccraop4CvRthjn6mPA4aiyK1+dzabNU8AI4P+ax3/e
 1tGSUOYO
 QEBOcdv3+lmY2Zx6Y7qLacZRQrBghj79Uqapx0c8yUX+0XJPVz1XwsNAe/TIReWe48sqm15Fc35dwbH1DIbgDdq5e01Ib+5YR4uH3JfrTq/oIRMmn3GC8h2+Br/Cwtx7LuGW9hzJJ+wsR8RI8d19QU01QsTA8QH0ltKBcbw2l9eYIkwJ8bEIOy8lbJyXqJud9WWEGDAmtQy3XeMJJDWxkkOKbbgAW3/v7Ijr2WjCsFloJuyDggulAW4NycI2bgfAc4ZH1jsItUFQ8Xlh3B9PsLQcCVMPWlL7gPd02m3jKpDXiWtSnMhFAhqrB5Qf3f/RfDaRue97xU78TL9olGj4NQFnL8rbuYjYWRl+7YRAddxriF+zn1NpWADbDYiZLqgTA2/S7PUPSQwG4dC5cSKJ0bh8JCoF602CFPyp4jgqsIZVUtZTOrrQ9yYQekmiXr/EMPsLFV90ktpBqMFz9MnmX2y/nirG+h7Dh4X9A7Q1rNqaelevgsAym7KxsKtJGnrwplCvNgCjB1RQGyp5pEEhfEMIGfY4g9X0D4gZEiE0jTeNvx/RBJaWvrflbZbAAs0sZeMoamHwebVQtsZcrXV82sM+PTIFMaARbPF7ih5tTBUlmQSX+VcO1fCAY9KDxadNjZ+Eg1uZD/LjgqUPgVqoEEB1xjhefoyUNOlYdK66JBDEZrUUaNC4IfUrYgH4l9Emi2QO5naYHWG/AbUOgJNyoRflmo8ThN0PFl0qKLCIonwUBEQR4FNCQyNhWl4IybmV9zXzSdmDQA22ksPBnR1aOU10nyHbt4jzEpv1k1/l3KaxW4jEXOw716quzGxtGRLf6V4/AKn9s8CEhSshyvfMT1+5u5BlSS0cajdmbNg6NUFkemJasZ3Af6aN0JfsS/DBooVZIy5kZwVbX2eUHcyrfdmbKSqok6P6nbR8hFWcWEtWHC8WXEYz3c2s1j54dUFKkOfiO5jyc0fb64BSCb5dlW74Ng0iQ
 5fzVVLi2
 rODHYWABGxoHBjPaAvTQ8pjIeM+Jb5C/VogZBy2RZw01kym9ossX34x31XhGdjMaCeL0g2mzyDbuxafvgKhDhxDAe4ateSDO2Y4Y/UOiFVb2FhkH3f0YmcAdT3NNEJQcLn47HzZVwfjXdncumWTr/Q433tqyQRFIOmqrTJugQjFtwy/RfDNLrW9SHrw6YgN0+QpIQQ+u4bTlya7fHLjIrT2UEa/rfYdL0c3IGxgmWRoueAmVKULty2+9OnpaboklTig1PW11qPHTYaQkjw/D3TKjUslijWCk8Y3xlSNI14fwGiMqHYNN/CroCdaPbKFARlYRjmd5Bh/IQQB17ck0ufWmiLT36tXfR8fY63jhhZetYR7bgDjw1M8mgCPnl1pC0JG5N5LK5SsFo1wtp0KRD5+5KOhaFlrDDBD/zcgvAyEVnW+JZuJ+YGXLYwAvDJ0MXfbW2fSzIrx2xGPXYVQuJelc5BQAn8ixk8D102keuBjjBJNDvRuI1hcg/wkDMaTiUVx1vhfEdalhrop/xnghY3n9T9y2ZgrKNbLZJGKE1Lyvt+JLqkwalZQpdyBxjpM5SvHB+Oi+nxkCP2gU613ZbQdkYQTg/yI5TxqIXxSz1tKWAo3M1PNrwimqgxQl2ZDCdcRTPp4U5Hz2aK/l0qhT9mcBAUVIYUP79ZHMYkFtugJD5ElFoS+D/o7QMmv7y3zXYHrFuZutOvUnhQHqFiFS6bDYDBC8g7b55vKUb0UBr6ZiUwzAdZGf4merkbN6OFJRMI7b4dVYOhJk2SUfGZjHeelNJcJIbdHHhkxWULq9f9/XGyQLKd1Fw5x4UpBGoO4IGJ2AOzcoZEYw6QR7gWamZSWy9yukdohjzzQ8WHyGAmpGj1zA/0lDo3YadvZxdc68I6f5drp5VnknLYPSaCz5a1ceBuYeLhKj2MItrtcckergmKuJ9JXLQa63aMjVP3hP/Uu7m5HtpyA6VHbOB4efZU/2OQQev
 Ax+/K9Ad
 KA9bMfmy/R2A3jNIixTNjQDc/jxcOEg5Z6NDX6DqPEwF3/83BeDhKls1pv7zqensYjX+7epsTOn/Xuqv3cvKrug45xALr/f4n026ExxH32HCjeNgA54aFVPoOwsToRiTVel1NMWUULrYdW+8BXtQ5c35Yaf3ptt/w8LcfuUKc7fQ/7rCLoBB1MZRMtUFtqkgnr5nYDi9LhrgwNqwNfd7xDZH1GFcK3iEwQTuSQcxlWbyyf622WmyhsV23zrHfxOn7m5jX3XLdJl+Mo1E+dRatuErHD54zeq2oBQdgSrBQU+KzeyBR/CViLkUw9DcFzPnYWm6Yvfu2Yp3RIeXNotHkbm/3IVJl7Ol0XthBPZDE9uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 12:33:41PM +0300, Mike Rapoport wrote:
> On Mon, Sep 14, 2026 at 03:57:21PM +0100, Lorenzo Stoakes (ARM) wrote:
> > The map->file_doesnt_need_get flag is confusing and the existing
> > implementation has holes.
> > 
> > Drivers are permitted to change the owning file of a mapping. If they do
> > so, they are required to take a reference on that file.
> > 
> > The mmap() operation which ultimately invokes __mmap_region() is guaranteed
> > to drop the refcount for the original file the mapping was made under, but
> > this is not true for the replaced file.
> > 
> > This has been addressed so far by tracking map->file_doesnt_need_get, which
> > is rather poorly named and unfortunately fails to correctly track whether
> > or not an additional put were needed in a number of cases.
> > 
> > Make life easier by removing this flag, and instead drop the reference for
> > both mmap_prepare and the deprecated mmap callback in a new function
> > put_map().
> > 
> > Track whether this needs to be done by aligning mmap_state with
> > vm_area_desc and store the original file in the map->file field, keeping
> > the updated file in map->vm_file.
> > 
> > In order to have the same behaviour for both types of hooks, only drop the
> > reference __mmap_new_file_vma() itself took in its error path, deferring
> > the replaced file's reference to put_map().
> > 
> > To make this work correctly, map->vm_file has to be updated before any
> > error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
> > set this field first.
> > 
> > Also when mmap_prepare() changes the file and is then merged, the reference
> > count also must be decremented, so update the logic to call put_map() in
> > this case too.
> > 
> > Also update __compat_vma_mmap() to manually perform this step for stacked
> > file systems using the compatibility layer, and update
> > compat_set_vma_from_desc() to replace vma_set_file() with a correct
> > refcount/file update.
> > 
> > No in-tree driver is impacted by the incorrect implementation of this
> > currently (no driver that does this is mergeable for one), so this does not
> > need to be a fix.
> 
> But the patch iteslf needs to be fixed :)
> 
> It seems to be the change that broke the CI.
> 
> The rest is from LLM, take it with a grain of salt :)
> 
> mm-ci mm-unstable red build - bisect analysis
> ==============================================
> 
> Bad commit: 2a937a04babf1 "mm/vma: fix mmap_prepare file handling, remove
> file_doesnt_need_get" - first patch of Lorenzo Stoakes' 40-patch series
> "mm: make VMA flag semantics explicit, eliminate VM_SPECIAL" (v2).
> https://lore.kernel.org/all/20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org
> 
> Symptom: tools/testing/selftests/mm/pfnmap.c triggers
> "BUG: Bad page map in process pfnmap" during __zap_vma_range()/vm_normal_page(),
> seen on process exit/munmap. CI's run-mm-selftests.sh greps guest dmesg for
> BUG|WARNING and fails the job regardless of the test's own exit code.

I am seeing something similar here and stress-ng can reproduce it:

      WARNING: mm/memory.c:3225 at do_remap_pfn_range+0x9b4/0x9f0, CPU#25: stress-ng-dev/354858
      Call trace:
       do_remap_pfn_range+0x9b4/0x9f0 (P)
       remap_pfn_range_complete+0xac/0xd0
       mmap_action_complete+0xcc/0x3d8
       mmap_region+0xb54/0x1978
       do_mmap+0x588/0xb18
       vm_mmap_pgoff+0x1e4/0x320
       ksys_mmap_pgoff+0x2d8/0x510
       __arm64_sys_mmap+0x100/0x128

      BUG: Bad page map in process stress-ng-dev  pte:0160000000000fcf
      addr:0000ffe8d9080000 vm_flags:00000071 anon_vma:0000000000000000 mapping:ffff0000a0c4ea98 index:0 (file) ffe8d9080 (anon)
      file:mem fault:0x0 mmap:0x0 mmap_prepare: mmap_mem_prepare read_folio:0x0
      Call trace:
       print_bad_page_map+0x63c/0x740
       vm_normal_page+0x228/0x240
       __zap_vma_range+0xbe0/0x34a0
       unmap_vmas+0x240/0x318
       unmap_region+0x12c/0x238
       vms_complete_munmap_vmas+0x318/0x958
       do_vmi_align_munmap+0x254/0x2f8
       do_vmi_munmap+0xc4/0xf8
       __vm_munmap+0x174/0x288
       __arm64_sys_munmap+0x70/0x90

