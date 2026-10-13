Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBECCC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C656E6B00C1; Tue, 13 Oct 2026 11:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3C956B00CA; Tue, 13 Oct 2026 11:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04CC6B00CC; Tue, 13 Oct 2026 11:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76F086B00C1
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:31:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06C3480C5D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:31:52 +0000 (UTC)
X-FDA: 85317993264.07.CE54D3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3F9D9160002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:31:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D5BClKMk;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905510;
	b=VEW5bWa43IfSokxX7dPJ0UX/bPDqZA7Nbyt5Hu/tvgkk9Rn84wT2acx79o1pV7mru4SZj3
	iBVgQM5I1a2M/qKHxfmuvouw5HCaQLIjj9IH80LXjMHh7eo4GQy1K7BTE6S2JQem42VNSW
	UXRWIFM/Odg5j+toNzzC0DBlVb/icOo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D5BClKMk;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ABcU0W+nIwCqZSTy0PPdZy1uyj317pAS/O9WDDdnQZw=;
	b=V9ElYlvhzHP6qvnwwdu8mLq+apW6N/7Z6WxYea/jxcrtXM7hgn/Sy7xhXgOy9OntFJAtqJ
	Cb2MGlLewuwVqcjxPin08mRo3yxKZel7y+THjq+1XJXWWl6j1AUouqWl1Nh19U78478Jlx
	tEMG9QBkXyk26v/hE1gJBsJ6kZNg3Vw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC58E602C3;
	Tue, 13 Oct 2026 15:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABA81F000FF;
	Tue, 13 Oct 2026 15:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905508;
	bh=ABcU0W+nIwCqZSTy0PPdZy1uyj317pAS/O9WDDdnQZw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D5BClKMkyjHNOoeNuUKWF6HwQ8es4HwocZa/1vk5hPJxYK0OE2MtOdN0S2gmcH6lC
	 h2bS5ASLQ2jbvKrWro4RUW2U8G5muKxncrLmF+Jou2z0+IhaAxzQhCEY/LrmDDFWT6
	 M6xKr2R3fPo+unNvnMZSc2FKExJxWD5IMaBvhhbtafRSFGB4ueb89jIBT5sOdDSJZN
	 GDOdloqs53ZQ9vDKS7F/ry5KwOabJqSqdFue4yGsWFChcPdcnrWzVPTjRyPqdUgvoo
	 j9GhCWKrZ4bFEjuUrlQ3XmGuaXcGd+p+mRRvlVf6aiAfRoUGE+Fx6LYN+MBnX0qWdK
	 WFMXQD15T+n7w==
Message-ID: <7bf5a2dc-f7be-425b-99e3-75b4546c8e19@kernel.org>
Date: Tue, 13 Oct 2026 17:31:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 30/39] mm/vma: introduce vma[_flags]_is_mm_backed()
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>,
 Bert Karwatzki <spasswolf@web.de>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-30-1aa3c9b139f9@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-30-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3F9D9160002
X-Stat-Signature: 3hj48kng4qk7b3bh8s6w6quqkmb5rjku
X-HE-Tag: 1791905510-221110
X-HE-Meta: U2FsdGVkX19PkgpbXnWgSP73iUko8QRLKTCI97s0+gYEviHDanovvjs6fK4AOxY59P6GjLHJlxbMYj895jXerdpfsr8c3ix9Lpye1bxSM/ZCWfP/+QzG1jNVf7T3zHdGx16RHworHSwwWUDM3AjoKMdDFvX8sZpXne4WGpYxmPnS7aYRYXLRJtxyfaC+ir+tDToupFsMlUyGBS6+F871VtTfx+IRiRet6Z4ixG6PrZBs6tJrA2O8AWjWuVPKLvUXCLIudCxacifSfNj2I7JdT6dpyGR4pT1TAYVhO0i8kEAVC27AdAcVXGu7vdEYilnnoRm0Y+LoApBk+GH21MakFp0gt48pZ8l+q2A75ndYyIghwzfRlncfcBDEsp44IkQZEYPD0pJdqf7449Pm0zvQHsWNNEQsUBCLhnRVrqjnVfXHfFDZk5th1JO53Ky/2rgiJJUhkLmdkkPwniYpd0BB2Z4m9Su2eluhuWIHg6cj9q6gOfs0iVZ4Hphf/Szfa7EmKACwsu4yf9MOobVkdFBe3sgAQdSTDWSCJalEcxiFdFlR0YRQtIsLk4iwEY9XxQCCUdYvR845lLapSkXhLRZe6FODL6uGbHYQC9o6eZl1N0SY6s5aAgon8HpNUkotOdw4/0Rvi/w25VQ8tygjoOC38IuNR69xsm/2AnmIiZ/XYBL1sr9fyoCSriOnFXcXx7cq+bz1nSpBjATIt/Ynl+qZcqVTE3ZxxfQPYB5XHLx6BPD0d5PqzDKDBPHesY3WJX71uvIjuGLsjiRrb99E2Jce+eVSLInDMpjBiKicnc/bkk+0uknneu0n6TxTpDP+erlwtJBVdzVppFH87BTk2CaDDI2pglGHPugB82HiBnXdlj+NaI5Un0eo/P6qOErvVPwz3hWmf7OujT8BHy7aJMv5knbuJrA+QKgNe2JDJaTFgzmW/Rp3VPX9PlPo1L7zZKUx1bkY4VkUszVqUZUnL2U
 t4sccK0M
 5b0eTFVoUR7w9pSBFqGrbRrezoUQgZ0m+BrpZ/XiSE9lO1gQGbaDo12xY+z5TJb678JiLu+cEb45FAd4qTtSZUPk5CbnNJxt6088oNiiN1zGpXud8R8wAPZ8r94Tx9aMr2Go0R1kqg+MtckePpPCpE7xQivPL4YJcTFqGBQ9HxaE0Jgjbbmaq3mRfDAPM3mOS+6Q/x2KATxooHnJXm9LdWoTv2E0b+xLQAMs8VGFi+WYnfXnGKLGmydxJPbKl41gYoHhwNZpzfx6eyE1kqblY8sMux1eDWs0crEB0tzph80ITdrzwkQEHUf1Ej3fZh0aAWrJBG1xb1C8mvsEhj58hTZrmZVvqkxcy+Ie8I8Ow5ydrlAMVwmS6owbAw2DEGVGbtsOdvDJAorLvxIWTELNAiF74XN3W6W1qYIsd0xS9G4QkLf4uhVokL6FJMkIpmka0E+rQ571SmZjwPZY2KMRDfePZu8UgF3DledQtCTO+FMC2lyq5n7QcZpdB1aPr5sftmtGkvkOMYhqAoybU6/ubdHAlCp7LrD9+LgAk6NlH9WvEU2SY1h4wFN2qB9umJMzLLskL2s9xN26nvGTv0KHyp86GNqAtAX+LCr3Kbp8iwfr3AjL3MuYJ48UF+9Mz6HcpUJcuKJavp/te+FHV2KpPo6ZucqypRSLV6HylV/C2erLvNNjT68TBNA+ZPlXEsfxotwtu0qVrLX+4Mjf3Bg9tmQspXImb9d/dRQBpzPjx+/w2ccuFq03/hWn7QxlKavbtde+vnKxSKKoaVuE3pcwHGJpXC0S6eGrjRSfideYaPU00r2DH6iPMc4C/apS0ECjqkLWDoomAsHH/6iFBefGPNT3YxylRw77T95u7Q1sHRvrM1YFf+rmBIJYYGccPMRAqdX1fN4davFsSBuG6bKVT572sEI0h0+iSheigz5BRC2LFfmufUuPjHlCX4jyD/coVjX8iTRDQskMwSQma+s63OVn1ObCW
 J97qsD1V
 MtC5AprxZJh+baCsg/PUmB7PQQZ2OWMhIemUgtKEsCnJ/iaXgD73DcvxJb+u5Vm52ReCD+Z1MYGAW+0q1bMVK3x39iE1pttO7EHe0ovv52pAIuxuWHYJxJ1R6njbcI9pa2/91DKpo5SOixEDrFAlPpOGTcRi64NwO5JUF3kRKrQkAVE+eFitXIMah3CbDumC9UBpMJpMTy3QlkhalJT4MiBwgRJJpFE+gZO2IBERvtpWBqyS8hFagfsXn70mVZSlM/dkdFG1YURnxsNIbapicxbXgmQr6HhuGJs6kog+qjAiuwVnvrBclXCv5du8g4Zajk/YpCQKE9RBrSbL3p6tubFF4Yh933qJnwTaSTJQgULrjUow0zXoMgi/q6WfobG/EfQCRQBox0+pRrvJuDm4rkhmu9nJcffMrLqd8B8nlhVAmTQUbJkiTepAYSkeAEZFeVnPsNDSx3dTohyLzsL0D2efuu0Ni2F+vkKT46MHxAVwL99q91QA0j3KGb9LHHeyg9bYiA+CY0KqmLGyy+XC4kJ1Bm0ZbhHLzelpfIaETgZk/mNMtTA3Gd2kXMkwIMI9UgUM9so6wODEiqq3POtuPpTsK0MVmKUCSykMoRD1rkozkZ81/Mu+NBP1w52oHMeuAeOXOrlcoIjXpZmAhzxMA2gTOqKhCl48JIb0uNFa+7vja1iADUMRQkIgY7jTTssAw9Q40MKb0kIBxXTQ96e/vC55PKSQav/wtjPT/F3EfIB0Y70BYwABrhHYk66CItZgmfmvtlMndKamS1T7VLNEjYK98JgPOBJqf7JDtGl1CJq55myApbH9YjY0tbKUmPQxQKnXwhxhISyyQgLGNlzbFyD2wxPve19Tm1yczl6s+rpiUS1FQHJKC2vtXuRcY9GkAlU9HbAeC97CVyj1z6bl6diFKUSvKtPbU0si6XZFkCr0Z7osmXIM9q8SWfmUUO2WiGPlpfulxhPinST0yhrOZhzdb3eKG
 2mWqcwed
 eBSQ2DJi72ixayZQk9zjwWhDGjX/sLfYrpCt3A2lcEM08tj7EtRWcFJkQAtEptAobMU2B1jZhDtKzJi+H9KxafOgNe8WbfXFR+HWeQi7ghvtzxcIutH+4Ilyq9KdZb8s6N64YSZMJGuIi2rhxF1ihWqGgnpI4pDqpGQAB8KQQRzMHtX1kG+7ruipieMAjG5pSfzB67SzQIpwpEyYHyzn+dXwDzoGU4FhfSY503WR4YZoJSCZj7IBx+pkVuzKrvnr4lp3wTA+Levc66RZuzlJk3wvyW8KJy57zcyYhrcS0AFiL4QwJ1bmBO/50Lm5y3FQ6uwCu60GLj5bcxc1cZximshE2qs69cgx1T2wJYULX+sjg70CV3sTf8M0f781lJOfsMWOFJFsHiwiE9pQNaxfN6+rhK8AoNJMFMsw9rrVf1k9djf6k65SOP1INlzJEvD3Rmvh0bmBn3TRGWq66dfO2Xcguu5Yuew2FVntCrdaqyXleR+CbgXwlOvrvDOHkAQgI7T+p3N7LtkCo6hFe+3Yfuz+J71n8acmAO/TWQVk3KUXHqSpyct/SG2j7m7r9xMDRNNZ7Cadr39fqYElTclSxZYEuD84n2VsBqw4AK0oO640+oCnV2tvivthOPPjXeCPUd9+xkczmN3+yZz/Pa6Dm1T1s3SaA0kgIPnNOW3MXhrjjNuRioJksZpSDBQKfylkz83z6/cHXigEDXoippfXW6OWe+aqmBkMj8Kb1s40/XeCfz3R6mfIKm1eD6MYuKsEK1NXBRRRqgzaFmeHA4Fo5gv3pHD9hwOfAgvGQzudKMcM2P0B0JSpl7B/KhGV6HjKmTMd+H1JUMIFfpcaiSg/6G164JuR4vWyb03V1GGzoEJRYN7TTlGsiHmHfXZ+GNzzsPr1reL2gY3Xnw8DffSxJ7RQlkLfhlosfkmvRGEkNAZzHYPE6Z+jcdXUCEL6ZxPJi0GhLpKgzC6VZyNDs4MzC9SZ0kkC7
 E9RVPFT1
 vk2MnKfoHAndSXQfoxMiI9I4+7LCLYSIVjgg6LADH8AoaqDshp2EGbY9akUs5QHWB9GxDbT6AYXz8HSn9gI270tsm/dwiRRjrLUUmbWAzzVySIggM8R5ygdzXDpix9DqVUOVu0b/SA62tW3Z6rANV16FhiSCmObxwARWB8t4A1Zzi0qqsfqTCMOtFwiWCmW+nJEMeUk52XN4u9dKxVhx72KsAn3YweXZGrsCborre8MmQP9G74+25/YbFcm+KvN7x7fxyXeCB24y+oPTVUwH3AIR2zy4b8d/nocAabC8IZ2RVaeKUqCmyqfwO87TlznQdp5+68PUJEcNSgxQcwAkCky+WcejL4jWu+mfDEi0dkYjE2BCxoFhiF3xxMH2HfrHkOEIIls98gJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 17:05, Lorenzo Stoakes (ARM) wrote:
> Introduce vma[_flags]_is_mm_backed() for the purposes of identifying
> mappings which are mm-managed and whose contents were placed there by core
> mm's own fault path - rather than a custom ->fault handler.
> 
> Mappings not managed by core mm do not fall into this category, as they are
> populated by their owner, and nor of course does memory-mapped I/O.
> 
> We exclude fixed mappings as these have a layout core mm cannot assume
> ordinary fault semantics over.
> 
> hugetlb mappings are fixed mappings, but core mm owns them entirely, so
> they are explicitly carved out as mm-backed, as the MADV_DODUMP check
> already does.
> 
> Use this functionality to update the madvise MADV_DODUMP check to test for
> this rather than open-coding it.
> 
> Also update vma_flags_can_merge() so it is written in terms of
> vma_flags_is_mm_backed() - all mm-backed mappings can be merged except
> hugetlb mappings, whose flags and fields do not completely describe them.
> 
> Also update __thp_vma_allowable_orders() to use vma_is_mm_backed() rather
> than testing for mergeability, which is irrelevant to this function.
> 
> This replaces the VM_SPECIAL check which means it no longer checks for
> VMA_IO_BIT, however this is safe as we have established the invariant that
> mm-managed mappings may not set VMA_IO_BIT, so we implicitly include
> these.
> 
> No functional change intended.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

