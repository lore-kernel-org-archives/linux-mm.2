Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC31CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33AB6B0098; Mon, 12 Oct 2026 11:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4496B0099; Mon, 12 Oct 2026 11:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85056B009B; Mon, 12 Oct 2026 11:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9DF6B0098
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:03:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25E0C140F90
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:03:41 +0000 (UTC)
X-FDA: 85314293442.21.7EA1882
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4596EC0014
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:03:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KqQnzUmK;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791817419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TUxOJIoEwWGSOtnlIj5KDXixurt7xGhOIGc9/JpBlPw=;
	b=zkFc9o9SlcfYTRspf6r3tSUpUp7SFg1RE8pmAvkBantZrUEQ1pePM51SMyRhIQytFuh5R3
	NeW2k2O2kooRcsH8Coo54aMI8ZxIyVC8dclISJ3G/74J/no71nuZJuxqYF+te9ixOiRnWH
	x9QJ3t9lrXvJHB+BSML+ePsD5VdOQMY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791817419;
	b=IidWKwVDkKLL9dAeBGzR39b1xRrOC+otZ0QqgmzX5BFEMVLqLnsYz2MUKkDdZUX20s7fHL
	io4Qmhlr+EE5EpqWASAHxxqRxTvvgsXG/6oBBBmtMeoMFr6oisHGmS00O4MRsciRukVI+G
	hdHJ846N31SZMiDuVxBeG5iLzczoFGg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KqQnzUmK;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA065600D4;
	Mon, 12 Oct 2026 15:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE88D1F0089B;
	Mon, 12 Oct 2026 15:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791817418;
	bh=TUxOJIoEwWGSOtnlIj5KDXixurt7xGhOIGc9/JpBlPw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KqQnzUmKbn/q8oL6O0MmGCPP5O+Y6m2jAfrhciRJULIkfNkMEFSgUq3BTPaW+lXQx
	 GIwV4tZup+P4INDs4Gn6nMeTOyRttCGB24ku/aRmE4h4WcBzlEyPvcWIHvQsluvDPe
	 ljJQY7vjnwKB4kDQMjmJr95y6KkjQ1QY4GJ0jzz1aEiI5jrcTnKctyGRt+DiJUzcVl
	 47GeIw3nxp9Q1Ghh3zHPmCdVZscbz0DjbAe1gvPifzTBpsYgdm/5vuHzgvbF8sqMDn
	 r1xUZgUlhap/cdcEC7S+qkylXJ9w9p9Qhm4cMonxJ4hpaAzFFcuPOeDysNEgt9wr+t
	 bj7khxv0wkoSQ==
Message-ID: <56cc2787-134b-48f0-a9e2-840f57b28607@kernel.org>
Date: Mon, 12 Oct 2026 17:03:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/38] mm: add mmap action for discontiguous kernel
 page mapping
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
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-7-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-7-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4596EC0014
X-Stat-Signature: i98wwuq1e1ixakg5bqcem1ncg4fezsqq
X-HE-Tag: 1791817419-519414
X-HE-Meta: U2FsdGVkX18vGTxgske11u0ijKabhHi+480roGNxVAQsGiIdUtyXmm4xisd5LUWWiJKIhlWzCwcm4sSnyPeeJZKOLbr3XqT3d0/xW0U4f0m/4G+9e3qaTYu09zhyd4ibLNzmqZ8emCm14BGBk4pz2pObHE7/sHjXVeXEWe3mcDFqzOQ9YzTNZ6lrzRRkiQ0YRvqe5MDl+MTzn9HcAcymQsoun0QdYuU7fNU5OsBkfFqqFAsHnFo9EK/YaE6JdU9ZhqjjsbeW5LN6d/owvCgSfnP4J2fn+RN+5Gm3Qqkv86f3CUDBBJ16oZgCqJFOnZqa4jR6nSdh5VdY5aHrJWgrW/mpnRjXMST2wPBN28CD9eOS0GxxBByaixRQJbjpLpJj518APtaSthjdSlJJsGJCczw56KdVydsRIr+MSAWSepoAuEx1PqzOPFCsAPp6hcrmpvvyDRlB7gcjJsUDlKcsC1tB7Ww8EOnv2QyJJWt2Fpy5sjmd5FlRQt2wmh7JegK/LqXxJDx6mqYf8fHgqrxgAcL7EHQ+6FBC0GbQ0IhSU9yOYPmkvDxfuQYhob+o3sMY0hFLdrxUT10JWpZhjKwfXS2IbWB6zVkpp+fwD8bIdmb5gFbxh74Jh4vv5cf/cSyOyxKesIWHq0YodlklQ9oyqITSwqoM+9h1Zp1HDyHVRu7U6938J/7o4ShhLq2EyQW4B0PPdeIoTbSGxP8uh0HfxnUev+Az1WSz5O3KRZq53jZZUQU5qab57+P94U0TX2kcGvfd1q4RNJ6SDw7c/p5WjIkQ8bRAVpQK03mOUytmjZCxvuRtfVikyCvK+s9/45nnCcKJpZ3AP3FMNCnSMKsye7q/lwpBvaRwVd+lNC1QGkEFm6tWGcZMhf3jepQ2aSF67z1FCIOzhh+/EgFf6sEw0RcAmLjX6bcjzKuVxgldfccJ71aT/AXFwBGpILkSDHmw47S9YQfOZINqiWY/J5n
 fymtxJ9V
 UDskqST77hyHYYQf86GtpLMRnedRR7iZPIG43t362B0b7FD9TqTNPG+hBhsObdUJGb08XdivoMPENAd1PNqMMfkJFFXqEJER7jdD3XGIJc85VLgUfqoW0EL+U0bk3lCqtj59YkPnM3zAfyMCCJw2MER5hwBjV22Suhv9Y9PkRavhL4sq+uJcKQbKp8q0haqm8l3H+ljoWvR+kjg2hDW9i1IrKvdsm1gQJytVNlFERNM4HJ28SrJjanWtpAHaqhI6r35IcCI9rmZrmXCfSQtRQO7Tlxeor6wvUTKZ6yjfNW1kEssdfKsn8o6+VGGQe9xOZg1Q2gXcypA2IoZlTA/Qe/haBDuhP8cr2NAPiA/iYOFng7MeB1fnGdZWOPgfz4Y8AGonQORRHir43pWoD8cFfbPxvJPTD3DU04c/L4FQ9Y45LYpxXgF0/HlXugXA/0Kk95Mv/b88FWz3W4x74f6YWingvoAJliaIbpOXCai4N6OKvWrUXJ+qYZ9RkCD/YcxyP51TqEt58+SaJzHhTafjQCnD+6NdEuGc4vXJZtPVzlSbaEf6H5wkHbT7/jM6YeaZ3Ky0YBARrSoMT1BCDfTdzsaNChml2xoA/QhLtJGg0LC1zEicHIZ93qbz+TgBG8/09nz6TNsX0XzcqVmCFUh6R+UQwxUaVS0bP90ckZ5kRJvdFq7c7chUUa6Rq2Zh1OF1Fa1opAtHzGuR6J1p9TbRWk3HAlXXEl3Bt19nvrcSeqGP+ez9CMHevwXfVjyQxjmufuwzaeszcji1G+aEHZIJvLJSdkzXS5W0ObA+VuaKzPF1veJqdasgUqLO/Lj/qVtYexuDHkqc0nBxLoQqV6X0/QaAMi988bj8jar9Oyv84FC6ZNfgjwo4nLI5SA9nCxsPBil5LAN2IHmMhDab6ltfloFaweFM3slMrJba7bvvl3v+RWwfKHH941BUdUKnve0orUSfsXmBG162KWPQJlMUMSJEVMI4B
 BS6BViFC
 FCg1KndgJG1t/i1q0Wn5IKpXFDcw7bPgrtlNcsWa+ow6rBVcU9YaOVxdx0FjZqe04PKDtmWLKxgpgMHzJzkeB0aYPoAMNP87RcHT/s3HdeBoPYPk8srx3weJLiKemh0BO1wAnmpR9h2j0py0Ylg5Iix1WZpzwwagWd9DvWXsEwem/BcXdhkC4FZ0jeUBP7zkjfDAewUFt7/YsN4OZy8kc+dArTwah5jlNddGuhh2ms3w0f/omTVKd+zWZwAGkMficOiT9pDNBwe50fvd0bSR7CKfD7e2LOaTtNQnoGGR03AE8m15fd3isOkY1YZb3fCrU0eN/aXldqdKBm1QnVDVUIoba9ClrUt9EJWMmiPrI8klG91Jcm+p6r23RSw24NgRVtrHsfDomMDtAX3o4lDhzRIJRwoMULLmKRNsWUrZu1824v97wuBeOW1tTkYPJQKVg+yYAzfnSK8ALpYJGbrR05oC1wRkuXMWHu6pSIbo+kt+3scXy0QEKyD/RKY3DZMwt2CzpU9JabJNKxJa3bc/JJ+6bFt6VMR646IBOo/XBIazfG1P1GZ+veSOEGcGJVwRWovfNw//u/0VGlsUa6wocLa27bBwJuNoaYgR66RzTEUZo+R8s5xBT/IScrZ+Xg4iygns0C9HxCs+qHev7z1UkrbsM5/bhK+K6tjY3PyBREAFceTg5rHV6OyCVptMojc0MPiCISLR0tzlFB23A6w5p42pgVhSNJAAmm/eZf1az5nenJ5D85WDvbAG2OuJVclBgncBavEJPl7kKyXYyCnWLZHLgNCRDoDwRf28ZqVMSr9o8VT4D09p7OodJBWc/eVAVg7zfPH/LanoVYzZ+CmFl0NsThLspZ3vc7qgABhKYJ8Oddzr7UwOugWUFcv3wOddGz00aHTAnhDbEFBEoNyCXj3yFqUVivTK6Vw5gJOmHE1iDxh3cNTSlSQGFV9PaRxYKftVMoAYcUZMzkUsRYSMA5xYtbIyi
 oXRZ76zB
 KhSdZ9LbQ8z7akVKuVYNlmhfrA5+IJWY6bxBDr0qakwMBoov0kXn+cEL2SG3mMFslGZjy4Jpan8ZMx9pScdWdc1vOUbgFf+7nRTJk7mviJibZ6lej7vB6Ffpzh+7MASBccwJmM1+Gx7BZd4AcaCATV1hfMZ43aCq5r9gS07CUHZQTKHAELX3H/dKupnRAbA2TCxM4cwVul4dtMihcQvRvLbeQcNJ/B9OubbgUCEZPKP0imi1ChdDPOgHxcXWMAVfHctoan2PYxH4xlh5TMsEofXMjWlwyiJk1VjEwbR1QLcWEOfKtzbtC0anzbp7TXiVfgLSQElB0J7oR6oCrUsUmwZmOHXDqP99TWXtlhXVG0SV4MHXvTH8jzAj71/eUDFco0IklLV2GfESbD2bx+yytbdJ/wgZFVCaJ7+Gx6FKSI2C1/En8XvU3IC4fAYrjH4mFNRlvD91nbdFYng9Vmf1bRabDZuUjC6Gd9uOhobaqMwiBLWyjqqcyFxFZ5zixRjQT/uMXM+IGu6mo9IRnW0uhGcrBSmxWsualzAFcHBmOxYZqaUnuCv49pmJcFs+KZUKXcQwsYanyGoSMWtvBP1G0HYN9LYtSUxIy36jZoENnrGXlIa9+BxtLDKXpBNwiOQxRx+TeTDyqFZc8fYJii91m0Mo5c0cDXDVhtcM99NYYBmlionze3AnC9n8lOmUvxDJuSEAtqPfdvl/cE1PrJBn+HphvQO/DA0YhhkziW/6RdrnplQRG6qWgdocCxM976y6IrjC82qxFzhKwrukeXvOtl096CQYrPypKCgJBrMuV2rqHzQ5FSrmCS/Gb791x4oWPHUQc7MYk56Yl/l5ub2STV6onWSWvrY0Wq4cQJARI3u/2uewyuDDLBYXgML3PCQPu3TieRBHbYCSV7nfe1rQ9bscfq1a4eTsCpKMJgym2x5kmeKHRnx5O80N+guEyHB7CtePz+SqNzFL7UqEU+0dnbqzH7DGU
 M4C8KsG1
 SY9615tRsdchq/ZyF5aUYGY7NKcQlf8ZiBzEp//WaRon/E+jKbH6lWQFNLbrfM4Uj/OfOilCQY7utDP6F+CGpVugYCVhy1SUTTGNfOIMr6FDSrr5ddjfwrT5VqJGDQA0OhX09p1OGlNQcLi+T+SpymzJ3NMcmJZOmByNUuD3fn4NjrDfkavcdnEx/H9wy372FKdFwPetCz941e1L671MhY+9wcyMs5jPQdAqvSkYZoBrAtAUBOPKWW0um+QZ+tX6+DTnCF1pWU4Y9eRRsyhtzjz0wBwlKASL3ATslgCRS6PTsAXxU6f8w5uYqweRelI5Lbrao/8Rq0B7lsHmOq22eNBAU03z4Cs5U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> The existing kernel page mapping mmap actions allow for partial and full
> mapping of an array of struct page pointers.
> 
> However some drivers require the mapping of discontiguous ranges. Permit
> this by providing discontig_kernel_page_ops which allows a driver to
> specify how the operation should begin and how batches of pages should be
> retrieved.
> 
> It uses the minimum exposed interface to do so, providing address, page
> offset and both vm_private_data state and a local private state object.
> 
> ops->init can establish state for the operation, and ops->get outputs the
> pages to map and their count. Should an error arise the core unmaps the
> VMA, invoking vm_ops->close, which is therefore where any state established
> by ops->init is released.
> 
> Also update the compatibility layer to do this too via
> compat_mmap_action_abort().
> 
> Batches may not exceed the VMA, but may map less than its full range in
> case the driver wishes to allow the user to map an area larger than the
> available data.
> 
> To use it, users invoke mmap_action_map_discontig_kernel_pages() with
> initial local private state and a set of operations.
> 
> Users can then use one of the provided helper functions to perform an
> action:
> 
> * discontig_kernel_map_abort() - Abort and leave the mapping as it has
>   been accumulated so far.
> * discontig_kernel_map_page() - Map a single page, or a compound page given
>   its head page.
> * discontig_kernel_map_page_range() - Maps a struct page ** array of a
>   specified count, mapping only those pages which fit in the VMA.
> 
> While here, update vm_insert_page() and vm_insert_pages() to assert the
> mmap write lock is held rather than the bizarre assert !mmap_read_trylock()
> and use the new VMA API so all code paths are consistent.
> 
> Also convert a BUG_ON() to a VM_WARN_ON_ONCE() in vm_insert_page().
> 
> The userland VMA tests are updated accordingly.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>


Finally finding time to go over this. In the future I want to have more time to
review such massive series, as it causes severe stress to be forced to review
this last minute before it goes upstream.

So if I push back in order to give me some more room to breathe in the future
it's nothing personal, I just have to keep my sanity somehow.

I hate being forced to review because we pick up stuff way to early. There is
just way too much other stuff going on.

I'm planning on picking up most stuff I maintain in the next cycle. For
cross-component stuff (esp. VMA) I expect Andrew to pick stuff up until we
tackle this once cycle later.


> +static inline
> +void mmap_action_map_discontig_kernel_pages(struct vm_area_desc *desc,
> +		void *init_private, const struct discontig_kernel_page_ops *ops)
> +{
> +	struct mmap_action *action = &desc->action;
> +
> +	action->type = MMAP_DISCONTIG_KERNEL_PAGES;
> +	action->map_kernel_discontig.init_private = init_private;
> +	action->map_kernel_discontig.ops = ops;
> +}
> +
>  int mmap_action_prepare(struct vm_area_desc *desc);
>  int mmap_action_complete(struct vm_area_struct *vma,
>  			 struct mmap_action *action, bool is_compat);

There is a mixture of two tab vs. different in your changes.

>  
> +static inline void
> +discontig_kernel_map_abort(struct discontig_kernel_page_state *state)
> +{
> +	state->action = DISCONTIG_KERNEL_PAGE_ABORT;
> +}
> +
> +static inline void
> +discontig_kernel_map_page(struct discontig_kernel_page_state *state,
> +			  struct page *page)
> +{
> +	struct folio *folio = page_folio(page);
> +
> +	if (folio_test_large(folio)) {
> +		VM_WARN_ON_ONCE(page != folio_page(folio, 0));
> +		state->action = DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE;
> +		state->__folio = folio;
> +		state->__nr_pages = min(state->nr_pages_remain,
> +					folio_nr_pages(folio));
> +	} else {
> +		state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE;
> +		state->__page = page;
> +		state->__nr_pages = 1;
> +	}

Why are both separate? Isn't it sufficient to represent that through _page +
_nr_pages > 1 ? See below.

> +}
> +
> +static inline void
> +discontig_kernel_map_page_range(struct discontig_kernel_page_state *state,
> +				struct page **page_arr, unsigned long nr_pages)

Is this actually "map_pages"? A range is rather a number of consectuive pages
part of the same folio/compound page, no?

(we call insert_pages() later ... )

> +{
> +	state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE;
> +	state->__page_arr = page_arr;
> +	state->__nr_pages = min(nr_pages, state->nr_pages_remain);

So we expect all of them to be non-compound?


[...]

> diff --git a/mm/internal.h b/mm/internal.h
> index fc4e249e2343..557e629db8c5 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1515,6 +1515,9 @@ int simple_ioremap_prepare(struct vm_area_desc *desc);
>  int map_kernel_pages_prepare(struct vm_area_desc *desc);
>  int map_kernel_pages_complete(struct vm_area_struct *vma,
>  			      struct mmap_action *action);
> +int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc);
> +int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
> +					struct mmap_action *action);
>  
>  static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
>  {
> diff --git a/mm/memory.c b/mm/memory.c
> index 448342883e9d..e5c1d1c35bc7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2599,27 +2599,34 @@ int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
>  
>  	if (!range_in_vma(vma, addr, end))
>  		return -EFAULT;
> -	if (!(vma->vm_flags & VM_MIXEDMAP)) {
> -		VM_WARN_ON_ONCE(mmap_read_trylock(vma->vm_mm));
> -		VM_WARN_ON_ONCE(vma->vm_flags & VM_PFNMAP);
> -		vm_flags_set(vma, VM_MIXEDMAP);
> +	if (!vma_test(vma, VMA_MIXEDMAP_BIT)) {
> +		mmap_assert_write_locked(vma->vm_mm);
> +		VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT));

I would prefer to have these changes in a separate patch. Or is it strictly
required to have this in this very patch?


> +		vma_start_write(vma);
> +		vma_set_flags(vma, VMA_MIXEDMAP_BIT);
>  	}
>  	/* Defer page refcount checking till we're about to map that page. */
>  	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
>  }
>  EXPORT_SYMBOL(vm_insert_pages);
>  
> +static void __map_kernel_pages_prepare(struct vm_area_desc *desc)
> +{
> +	if (vma_desc_test(desc, VMA_MIXEDMAP_BIT))
> +		return;
> +
> +	mmap_assert_write_locked(desc->mm);
> +	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> +	vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> +}
> +
>  int map_kernel_pages_prepare(struct vm_area_desc *desc)
>  {
>  	const struct mmap_action *action = &desc->action;
>  	const unsigned long addr = action->map_kernel.start;
>  	unsigned long nr_pages, end;
>  
> -	if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
> -		VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
> -		VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> -		vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> -	}
> +	__map_kernel_pages_prepare(desc);
>  
>  	nr_pages = action->map_kernel.nr_pages;
>  	end = addr + PAGE_SIZE * nr_pages;
> @@ -2640,6 +2647,98 @@ int map_kernel_pages_complete(struct vm_area_struct *vma,
>  			    &nr_pages, vma->vm_page_prot);
>  }
>  
> +int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc)
> +{
> +	const struct mmap_action *action = &desc->action;
> +	const struct discontig_kernel_page_ops *ops =
> +		action->map_kernel_discontig.ops;
> +
> +	/* At minimum need to be able to get pages. */
> +	if (WARN_ON_ONCE(!ops || !ops->get))
> +		return -EINVAL;
> +
> +	__map_kernel_pages_prepare(desc);
> +	return 0;
> +}
> +
> +static int apply_discontig_action(struct vm_area_struct *vma,
> +				  struct discontig_kernel_page_state *state)
> +{
> +	unsigned long nr_pages = state->__nr_pages;
> +	unsigned long addr = state->addr;
> +	unsigned long i;
> +
> +	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE)
> +		return insert_page(vma, addr, state->__page,
> +				   vma->vm_page_prot, /*mkwrite=*/false);
> +	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE)
> +		return insert_pages(vma, addr, state->__page_arr,
> +				    &nr_pages, vma->vm_page_prot);
> +
> +	/* Compound folio - have to iterate through each page. */
> +	for (i = 0; i < nr_pages; i++, addr += PAGE_SIZE) {
> +		struct page *page = folio_page(state->__folio, i);
> +		int err;
> +
> +		err = insert_page(vma, addr, page, vma->vm_page_prot,
> +				  /*mkwrite=*/false);
> +		if (err)
> +			return err;
> +	}

Summarizing some of my comments below, I wonder if this could be:

DISCONTIG_KERNEL_PAGE_MAP_PAGES - array of individual apges
DISCONTIG_KERNEL_PAGE_MAP_CONTIG_PAGES - 1..N contiguous pages


if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGES)
	return insert_pages(vma, addr, state->__page_arr,
			    &nr_pages, vma->vm_page_prot);

VM_WARN_ON_ONCE(state->action != DISCONTIG_KERNEL_PAGE_MAP_CONTIG_PAGES)
for (i = 0; i < nr_pages; i++, addr += PAGE_SIZE) {
	struct page *page = state->__page + i;
	int err;

	err = insert_page(vma, addr, page, vma->vm_page_prot,
			  /*mkwrite=*/false);
	if (err)
		return err;
}
...

-- 
Cheers,

David

