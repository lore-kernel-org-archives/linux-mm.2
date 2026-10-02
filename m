Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37DE8CA5FD9
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 06:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36EC96B0092; Fri,  2 Oct 2026 02:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31E546B0093; Fri,  2 Oct 2026 02:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20D6E6B0095; Fri,  2 Oct 2026 02:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00C846B0092
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 02:55:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77B27A6D4F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:55:28 +0000 (UTC)
X-FDA: 85276775136.28.37AF065
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 999CC40002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:55:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jcg3T8Lt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790924126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISzeg/djpEJgZuQfNd3fqeQR/RcIoDTgRKI00G7Zcuw=;
	b=Azo/XNwv0J+TDQ7aYJca1d53MWuJpZFQ2tM+gaT7AbHnnMyyYg0123FJ2rXO9aDbecvtCg
	zeq+1awzvVMp2HaIaylEsV41a3IU4bjsBPcjV0y3fWH8aRvPUNELFiOSCeQZtak6rg9sdA
	/AgS/eYVpLPmT9M9V0C1Til65Gc1iS0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jcg3T8Lt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790924126;
	b=7TrbZcw+aOXTKIXk/Zr8ouWRRnDQjkXJulT4NOhFxcu5sRDUg5i7vRIZW519ME7LmsJftq
	ebox2FvRORXxvK4qTEVjvkvC65FaAu2xgVE3GYHOIE/yOdrqtmureTDzwbGa90BTfbkQSr
	7pvCvYQvzvdicovdOKBGgfOmdBaaq4I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C47EF41825;
	Fri,  2 Oct 2026 06:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2B81F000FF;
	Fri,  2 Oct 2026 06:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790924125;
	bh=ISzeg/djpEJgZuQfNd3fqeQR/RcIoDTgRKI00G7Zcuw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jcg3T8LtVGFeCP22PjJ5Kmv9ARB/xlyzs+V7VKXWrcGliXXGU0CUjthFJOOOSg0Hx
	 6CU6htfWrkq8uVkwnyN4p20qhOGNewwRU/UbFZx50g58zMqo9rZghxxOXE5Sgn4Byk
	 cCtePOS4ForF7OdoDSH4CGhjCIkqhnRDQcxizGY2lVyeFq5pdQhwHHIXJGGnnpU5c5
	 f0rMdqdkNfLNmT6GRUD7iuUwxWsVvZ303YXTDcZkh980uO2TEGwYTNmDpVxNp4xXDJ
	 MbMPkkMYN3WygH1pwmvSsevDkxgASGDEHdWFY8ljYW0NPayHu1k6zMXETsr4Yf+YHO
	 xBkzjLjRmFNXA==
Message-ID: <2c01f806-0428-4a96-85de-6a853605a537@kernel.org>
Date: Fri, 2 Oct 2026 08:54:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 29/40] mm: drop some redundant checks around hugetlb
 VMAs
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
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-29-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-29-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 69nrttw3nt9dupi1n3n8r9xaonancx69
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 999CC40002
X-HE-Tag: 1790924126-256511
X-HE-Meta: U2FsdGVkX19SzHKxufunkcUerZ1nGk5mlHdoVOyOGMiHy9/eqYqTcEu1/QtVne3g+siPAed6pvjuRzJhEYTDsj31gjUiqN4roVmK+ZIpeQ1Tu7lYXYbeGZiqv+RLmiqeFH6Spz6DDuB3XiTKfVBPrvRWh1iD+bRcZkDakpaFPJ8zXoece1F/71wF4JydUt/VakiOj+VPjsrCU2VtoyrA+kgFX3KfXbu8xuw9HbzG9znhIRKdu/lgxXvkmHEwZ2bCedP3P+vLUS6mfuOVPuB6Qv18vCciRL6dsguW2YCxSindIso9MeAEraeiMjcM9pInyVGhK9BuL6DyVw+EBHM0lObPT+RQDQzcFn2sCYcmC25SuzthR8ky08HihHzmhrIW4+vvxYNe7jgSUSBLC3kiXKwvk4SEWZw/1EGU2IJ+BfGkm6RkH0DiIz4wwTd7x2iuYpZVIqFhMUh6Wl82U8K2jQ4RAEW1Cv13fUkBEMrxSrWsfVE9b9J2rH+3WY7A0OXv0xPacJx4rywA0ERGeydR7YZeBvOVQqPY+aXJ4VWaJjHaa+biW5GAiP9OEeIsuy7teT1XEfldW7pnjSrhC+3eqdrYwyLMtKf36GioIrp1Q38D9506JA47ShBlz0gpqtulw2LfAKZKWXlSLxVrdvxd3SV5j5NaRf5CO5Us5T1wB9F7rxzawarfKjuSK8zxyR3900G5BhbNDerjC/muOtUQ8npQVEZEmSXSkf9Jmar7EOvf6dpIL98YoaM5pZG8ds+tzbRsl71TgsCyyL4ca3Bb+O7HW1mnCZmxrCBCzqlaGrUh99AC/EVtI80h9RsqCBbhv4gtJpgPLHKrTF/gC2T5gVFx8/OnXsEJZY4sEVnrxRVEJ8QdyJwqRIZu0Zj6mgLY29Ug027LHQau46Kw/Zn53AHiCLVeJ7+RFLuknhlEuHEGXiliKLC12phLvnzbbVBRPnRrMmlEjOC1Pkjym/7
 T4Ufcyd7
 Xuqqf9ATF9AHIAAzbZRBXukBwr8n7av/bfd63pZmCv7hu5CcuPLBBgVQZwKgu2dewk30YN/VNW9hnvplsHvmVvGIjKpicBdh9gv3oKqD0JxYWy03RU3XwCkyzIThboIK2ZIEXFZUZKFDLgPdQ0ErLmJz2WKp+OtxDEpsffuE4uYFpuN/16MZbgvjN+viqDmDvlEV1ttlOzKCR8e3H6JKBz0GhDeup6W8uDuI0xRDEPyY75RVV+B4ZCy+yzhhD5BduJC0pbu2oAWw5FP3Zw53Ohf0txsg6uxjT3iODWdYB/q9rdfZqi1XlvwVcSPPl5PYx9HPa+Xr7i7N5beeTQBtVavvIYK7vQIExkT09fj5pAfxk4SIA5OdcrTsQUwsGykoJGOTnlgycW/adqrIY1gxxV6OURgjZ9/3k7HG74GwaUTF2JxAUN4JVG4ddiEAVnMXxHQdNmTSzvkXl1iogELqM+eQxmD/GKacqr+wdRLh/Hnlh4nZoGhZs+u+zhagPy2U9ZAL7mwhIzKrllXiN1nBcFnMaCd4tCxTBf0SqwQLfimg35OsY/CfA7iBtpBPYVUhtqmRhtQFm9rBSnE8+KC4OH2S2wDaHzah3toDY6sFA2/fBfKTvi9gPPDKjVPOkHV8vadOf2VvZlkhDnba246yb2sMBxemNO313DpQMdHvm3kOBR7tP5axKyB5rtt3GsvNJBi0DAs0x1A13bYkWeDios6ejoN4J592ldQbZdz8KEoWEwAGiDJYw6y9wpqPUCCNDhLJuV0f4Xlg1HNrFg8750KNCf+uV8KxwTpoQr7r6OdOjr9urSTxAPD4HeOtFjDle8PF5PddXlaKrpC+Kby5aw8aWv/BlbgLdrVMqOdfn2czqrc960O/CO5Vd00KpJOqT0ieC4eAIITTV91MeItubEN7EqUtQewg18nLF3KZr+fiay4qRaGBYIlBqgRrbI+yjIzVEtvSmaxdi/FOxeRnZqhoiqJRp
 vhLBRv3L
 JQ/Eerm7gQjly8O6EkEhpIqVa1MtK8EiffEv52fBrImQPVvR8DQPUQ4MNzfm/lyutDuO1oJ37Dxbn3CkrA2KmWcvnq3F3hRKq/zPaP9bMYCFS2Ii9evXdNcpiXrDR42vIxNMpkmgOaJJu9rekDBYDmyQlfFAUyv7Dqa6bx8isO0RCYxX98OUELPKzy2oTZumKWdwGqeKjP8dKaPCDMobSNTN09dXYlwLBbT3CfbcXWI8IpZmc8QuVgAB9mVwqSvmDgKiPH/mE9jSR2KE8ilGWd/kYr9WlqBZzzNrTN88dWKXva6MkoRF1IsjN0ogk+rAO0S8ED9WFrpK1lzGXs5kbF5fJ3j3E275uDoICeRXlSXTducCdPeOXlNOP65PkjZB8TT0IpjN3rpYu7pfPqht30wrmfPgE3WK7tfg1E0cA9OYuy6TSvZAT7PMeWeLFvksC+UdyoN1O+uSIqZtKsXYE9yd/ycepf4FTfeH1gL0EariYLnSqBAOi4CLoaVHq7WMutB6bipaQJzcLdbqnmv0oJGIe3kjtOr9dSRUWTZjQgQfHnyJnOYXn1EAjo/l2T4CEVWKtZvKs7RzKwm/xIsRMLUKmNHVMTyV5pvlkh3sQcfcMzYo8jeK9FyVBCHKa+BgY7A7ZWvRXkOviNK49ppscsFN8N5DcWaJWUkJRkaaVb1a3auUWqCJW5gwZs/tzE9FhP9sFPg4D/o4Eipwlniy0fTSU2JiXlWG4StiSR5piOzLFAazXOAZFe722us/yFlOJyQKvc9D7Q/4ukdOHnly7Ey1tANT3qzt+Grwq6+mZc/DJYc9vEvnKRWuzA4j67I0F9EdFRY5EzNx2Gc+rQJg55Ynhe4WEsh44JMpuA4vNfHD8tcVkMX0KvXVvt9Csb43lUGlGJsONkcEcyKDFDJO90YFv1oj66DPoJNiCE2bcDa/NjDv4+5Vw+uIyKt+QpxdSTXUiSPvZpxP5GE/lQmZWBlRqTsqo
 aLwMz6MB
 MCVoysn6zccnkcQ9NyEoT6Ly8Kjl9fiPTWOZvIYLGqzNAeO7ISZEQMzU1fWDI9ivRU1VEGaUwBHn2lUjmQO8PCs4yMJYTXALOHrO5gb67F5yHTOr9S3VlLfxpuZFXLkfmC3in0zp1AXF59bk3YZ/Vv+n4hba1nO09XBVTi9MppbwnR3qV5BHCF5Vz63eqXwFFEKwwn7Zph1fwLjagb6nUdbiLmCeC1jNnipjUkiiSUYj2DhLKGAleUMhfD92XEe9KOGUUXB4ZMVbnqXuS9px7Bgmtf18WJZ4ttgn2DMkssM+4qi2n6hku3wHJc5iyXfLu31nEciqv6YeKmLLk3g5pzWR+GSX2QED2ZApDJSPuv9dtEL4uFORtCnlFB1VikU8mqNdRoLy0BUHH6vLt75p292k93Q6w5Zv5ywsceJ9afFoYV0ft9q0MsWKS9YcRujpYRry4SElt9F9qIynQ0XWb2wS3viAilptHb1QoLPf238FvSCrJemYmCtNThfo21AyVmVrW0o1hKfSSuV7UjMj3J0Ojul2Tsjut0zid2vhynNPmJ1SY9nDoulz8WUKoj2FgFA9pzDINledIjZqxiR1iwE8thMr2tYYCJqaT7aZhkpZTd2UE2nCQaceU89FPlosqQc9blFW3O4hUYje3ijnfbCIdiqwHJ0EtVSzizwhGdyKVvDtuuQ/opVl2M8V0DW7nfCrV1GkKwUCcQAKmJ+sXQn855aO1ifeBeLnVxFp2u8TYq5bjbAX2nBUmW6i8vjiKolWnyPJ4vGR0gRkWQLPFY0m61YHhmYkldxpOnrkTLSg+QKY+QQaU/a0M129+ddvSqnEvcnbOpyuCZfvKhVfNzSlok0Zabt9t0Hd3J4gVhHnxYRF7CZ6amDxbgQ9tkpgY5i+ylLG6Csw+VVm+bqruvLBn98IdZke91NayfEHHeAWLhI/IEFBdE3Pv2i4L9Sfz8lkX2thts1r7A+4BMakzc7jFlQKm
 iL0L2PkN
 nzP1gRzcY39nfpqX7Wi1XgEpDfb605MsVTI80DoJ/L1JBZRIcc1OpR4dnpvHJzPUhlHkldeFXHq7WZp3u5NEiN0q3n+kqxEE2VYx0WNCgARFQKnIpeZikhM6InxMNaXBka5YQ7u5T0huyN7Uzt8kWJqC9lfV1GxRdT/qMjHdB7wO3a3sRO/4vo08xcR4yT+R1H2DaLZn7XUYGxxZjmDar44bUbJ2d9cnGrYJMI4GdAlDr04HHcmrKwzYGtI/+5FSj186jJngtbXyKcATJB03dcMigxV2mpPZdXaT0ZTieqhyXMpQO8zMl7OYP1Yvda83Luj4H6ePVOsp9YMEbRajmKQ+RFbfB1HjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> Adjust code which inadvertently perform redundant checks on hugetlb VMAs
> and clean them up:
> 
> * hugetlb VMAs have VMA_DONTEXPAND_BIT set so a VMA_SPECIAL_FLAGS check
>   suffices. (migrate_vma_setup() regains an explicit hugetlb test later in
>   the series, once VMA_SPECIAL_FLAGS is removed.)
> 
> * hugetlb VMAs unconditionally set vma->vm_ops, so they are never
>   anonymous.
> 
> * hugetlb VMAs do not set VMA_PFNMAP_BIT so checking for this is redundant.
> 
> While we're here also drop a VM_BUG_ON() which the simplified check above
> makes unreachable, and use the new VMA flag API.
> 
> No functional change intended.
> 
> Acked-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

