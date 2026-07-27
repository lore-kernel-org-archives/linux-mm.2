Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E98C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01496B00CC; Mon, 27 Jul 2026 08:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B32F6B00CD; Mon, 27 Jul 2026 08:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA416B00CE; Mon, 27 Jul 2026 08:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F55E6B00CC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:03:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3C42806E4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:03:40 +0000 (UTC)
X-FDA: 85034422200.01.8131E4B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4913840010
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:03:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OiXA/qnr";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785153819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYWQxYr7Z8hEjbx0l6qZmmyZsK1/paY35yOfvBUEJA4=;
	b=noHAANvBd1TDTO/nKMr8NOAhsq77grbGqrGnPowNQANm09BMhR+iJ1ekljLNvN4kTZf2uf
	tLCvOdWG8vWReFHxWuvzH57bdqAKX+SgZUVHq0bySfDi/fIz5NYCZmq1lRALfVNaAW4JY9
	dSyPEr3wuBUdWlEbeO38YQnKSZ/vQZ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785153819;
	b=a+PNS4dyPBdI8OquCbhjQWQ2ab2IdpQhJ8C69sFwv0DxMdLykIjX2UzjcklkK7j/CMc5bc
	HT8hVPhGc+rqJ8yuxkMou9pMJ6BZkbIgs7sF7TxN29TZYSIFG44dVEqmgTu32DUhoNwZlc
	E4nUcGOcmzxJKXeukTf+FKevj65HvVI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OiXA/qnr";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A369E601DE;
	Mon, 27 Jul 2026 12:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320A91F000E9;
	Mon, 27 Jul 2026 12:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785153818;
	bh=xYWQxYr7Z8hEjbx0l6qZmmyZsK1/paY35yOfvBUEJA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OiXA/qnrXF+F/T9jW8OrjlLT5fKXKnIHLf7BA+8YmJTwcwQP8TKwWmhs9QRsmcSS0
	 IRs5bQUDtunXm9LtIyga8PhQHZSYYFun8znmV68wHwZ2xS7SDXDC4+zkEMhx+dSEpA
	 f4fN/OOjlMMEJuEAc277wK0aK9kR3LY+j8llfbFY8uDtIN2DkeVk8ArXr2VbOkQ5Kw
	 z72CrtZ8sBoxPESqYtD1MlGmen/WrsNutp5u+z3NNQ3lJUjDGnOy0mqGXAKzd1+y2u
	 fMF3Gt53MY9JK8lsqKB2jn6QGMxgqLcJkjt2amNK6epwNnSJz63W3WEvB5PNHYrrsh
	 4UBqnWTWRz0Tg==
Date: Mon, 27 Jul 2026 13:03:16 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 13/15] mm/vma: make MAP_PRIVATE-mapped /dev/zero
 mappings truly anonymous
Message-ID: <amdI42D5Y_nsB1t_@lucifer>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
 <20260720-b4-scalable-cow-virt-pgoff-v2-13-2d549757a76f@kernel.org>
 <9d2c8f26-aaee-459f-b73f-d07d8671e805@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d2c8f26-aaee-459f-b73f-d07d8671e805@sirena.org.uk>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4913840010
X-Stat-Signature: 5ewbc9yj4y8ieyshrw5bgcjw9phg3mmr
X-Rspam-User: 
X-HE-Tag: 1785153819-745413
X-HE-Meta: U2FsdGVkX19eHcvDzKxf3MFyjQzpEMkigQVyS20jWiBYS8QPhwAwuuyCE1jvv8fyIi1Q4DUM4yY/WbFVO45ZrUbnk6qSbQSZ+ZFF0yV3t05kQt96tpYz11KvaoxAFz5hkjsDRFj/A9BpnGCqeR0Mbob3fAu0GSAUVOkMHR0hQtZmEyrQHABrv3diGMkn1mkouzlsEjaQ+JM2BmuN4F6e16Oey4JHl3GTm1tw+InofbpB/JQZigicoizOhqCs+jCQnrHBpn5JGdI2YAkMcL46W/+l1s3qUsbWbYncHkvbFKO6ek2D+GMJS8R0unsq/PsT9D7X6XtPJrGs1h1FlY7HRpONx/upgnB+P4LOcUyMPTC/lSTLp8jxKrI2G0onbtY7Y+WoD+WEWcypuKkF3jTwerI8d/nrU6+AktJmGRnuqxMgFQH7tqLtG4g42gkgzfR3ym1IdEdKOW+RuLcvxRJaENjoI/ZzMe2F30lzEmY00twrMNyifO/DuUEX7XyZ1DNmRrmef7XPFReR862ga0YySOiFoclnZOlcyUzr3JEPXubdqcyEu74S/tbFf2/SpPE++8k2czv35+WugQ/6C5V5AQhVE+z1vPI8yDskkncuzeigS60FTNUrBf4RWgjBcYsO+xy0XymkoaJyyucmvDR+8G7jef4gvupKcylnHZzbGuApf7lyPRsKpUDitmcM9nZiF61BBUJ2B0740fBh1zox7bMMNayvWP8cdMl9xqz+KqACNlVAh6Khs+DYfvfxk+n8Q3mm5w+S7DsukIbhdb/D1OgDXMNK5ZQ2SjUg3JdtGsXiK9b0EtKFXLZ/OI0eB/X5OEOOob/oODRywWb8r39zsYJOkWjrRM9Tw4Z9ce+xJBHY8BpmEC5EnQbBTpshfuHyqSxhNc2vVxuHypN1UtZGJnNqR9by9g7Xh6SpiVSqlYrkFi0yUYse2uhQT+UaS0NIWhtZkXv+Dyso+zU2xG8
 aqgKGCdK
 dU2FiSQkHYNfX2XdSYIOyD6toumKbh3Rr6/d9tGPJra0Daixg7+gYyRnW4Z1M7mONvYdUwYFjwcp1a+1CkxgTC8N3yQ7Ob+h6gBa10u2/G2Tg3lQbuUsIEgtFi5HbQl0/epjQM17nHQL7J5H2HY3he0VzILSKu3YYRXnbi/V+AqCK0js0SZYRmn+xnF/v/5m/6jX+SbaRvdl4F1/zkXGwez8Wv4Mq6Sn/YIX3JrPEW38kcfhFwp9lW45FTK0PFVMH6uh6pAniTKuQYHSknDD/2sbaee3kEjJla1YJVaetEysP0Yxrbw/ReHu9s1WrAKg8qjVvzf7IKmjpgglbJjGZl9DLrByI65Tf6aCdIBTuqHl8aXG3YPKKRzqN5zY6qPWvOleQWyBh2VWRu3pH3M8gwI1SJ/4Hx4QW5eRL0MVlPyYNLNofgrpZN+BiJ6bK+orDGsoWTXz/HPhnXnnc/2bqJU1JUW4HH6Ia0tPFrLz4rmr7Ejd1Yu/dUyQFGFs7Lo2vpuB18S0ECyjXk1uh+3QMHLvy0N4fDXbac1H5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 12:48:57PM +0100, Mark Brown wrote:
> On Mon, Jul 20, 2026 at 03:38:39PM +0100, Lorenzo Stoakes (ARM) wrote:
> > When mapping /dev/zero with MAP_PRIVATE, one ends up with strange VMAs
> > originating from Linux's distant past.
> >
> > These have vma->vm_file set but NULL vma->vm_ops, meaning they satisfy
> > vma_is_anonymous() but otherwise resemble a file-backed VMA.
>
> I'm seeing a test failure in the proc proc-self-map-files-0002 kselftest
> which bisects to this change in -next.  The test just says:
>
> # selftests: proc: proc-self-map-files-002
> not ok 11 selftests: proc: proc-self-map-files-002 # exit=1
>
> which isn't super informative.  Full log at:
>
>    https://lava.sirena.org.uk/scheduler/job/3030495#L13846

Thanks, will investigate!

It's likely making some assumptions that no longer apply about MAP_PRIVATE-/dev/zero mappings here.

>
> bisect log:
>
> # bad: [c5e32e86ca02b003f86e095d379b38148999293d] Add linux-next specific files for 20260726
> # good: [692519a077bfb1a66d209e713d2210bb1d9adcaf] Merge branch 'for-linux-next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
> # good: [ef4f2357df6e9dd6213ce00d01253f3c458d5df0] regmap: clean up kernel-doc comments
> # good: [86e9ba573c353afd1a46816682f4cc3dbabeeb23] irqchip/irq-imgpdc: Remove unused driver
> git bisect start 'c5e32e86ca02b003f86e095d379b38148999293d' '692519a077bfb1a66d209e713d2210bb1d9adcaf' 'ef4f2357df6e9dd6213ce00d01253f3c458d5df0' '86e9ba573c353afd1a46816682f4cc3dbabeeb23'
> # test job: [ef4f2357df6e9dd6213ce00d01253f3c458d5df0] https://lava.sirena.org.uk/scheduler/job/3020719
> # test job: [86e9ba573c353afd1a46816682f4cc3dbabeeb23] https://lava.sirena.org.uk/scheduler/job/2955047
> # test job: [c5e32e86ca02b003f86e095d379b38148999293d] https://lava.sirena.org.uk/scheduler/job/3030495
> # bad: [c5e32e86ca02b003f86e095d379b38148999293d] Add linux-next specific files for 20260726
> git bisect bad c5e32e86ca02b003f86e095d379b38148999293d
> # test job: [673a43d4e283e8fc3bee7a874766278427263bc1] https://lava.sirena.org.uk/scheduler/job/3030777
> # bad: [673a43d4e283e8fc3bee7a874766278427263bc1] Merge branch 'libcrypto-next' of https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> git bisect bad 673a43d4e283e8fc3bee7a874766278427263bc1
> # test job: [5dd91aac4216c19e9eeea6e0c1a04bcb3e43a876] https://lava.sirena.org.uk/scheduler/job/3031099
> # bad: [5dd91aac4216c19e9eeea6e0c1a04bcb3e43a876] Merge branch 'xtensa-for-next' of https://github.com/jcmvbkbc/linux-xtensa.git
> git bisect bad 5dd91aac4216c19e9eeea6e0c1a04bcb3e43a876
> # test job: [457b365bc545636d75f65067d18afa86f6ced162] https://lava.sirena.org.uk/scheduler/job/3031248
> # bad: [457b365bc545636d75f65067d18afa86f6ced162] Merge branch 'for-next' of https://git.kernel.org/pub/scm/linux/kernel/git/soc/soc.git
> git bisect bad 457b365bc545636d75f65067d18afa86f6ced162
> # test job: [a8fa5c7be42a37866fcc315470df3307f0583c47] https://lava.sirena.org.uk/scheduler/job/3031351
> # good: [a8fa5c7be42a37866fcc315470df3307f0583c47] mm/vma: update create_init_stack_vma() to use vma_flags_t
> git bisect good a8fa5c7be42a37866fcc315470df3307f0583c47
> # test job: [5c9f41c7115f0e16b7e133abca791a4860bee0b6] https://lava.sirena.org.uk/scheduler/job/3031429
> # bad: [5c9f41c7115f0e16b7e133abca791a4860bee0b6] Merge branch 'kbuild-for-next' of https://git.kernel.org/pub/scm/linux/kernel/git/kbuild/linux.git
> git bisect bad 5c9f41c7115f0e16b7e133abca791a4860bee0b6
> # test job: [c68210527d235e59afa54bc6aba6ecc532488a82] https://lava.sirena.org.uk/scheduler/job/3031482
> # bad: [c68210527d235e59afa54bc6aba6ecc532488a82] mm: page_alloc: fix non-movable reclaim storm in defrag_mode
> git bisect bad c68210527d235e59afa54bc6aba6ecc532488a82
> # test job: [497078da29fbfe6ae057c020f1e5717ded142471] https://lava.sirena.org.uk/scheduler/job/3031540
> # good: [497078da29fbfe6ae057c020f1e5717ded142471] mm/huge_memory: fold split_folio_to_list_to_order() into split_folio_to_order()
> git bisect good 497078da29fbfe6ae057c020f1e5717ded142471
> # test job: [2afd297a9a621ad41892bc0a05481110f46ebfc2] https://lava.sirena.org.uk/scheduler/job/3031619
> # bad: [2afd297a9a621ad41892bc0a05481110f46ebfc2] tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
> git bisect bad 2afd297a9a621ad41892bc0a05481110f46ebfc2
> # test job: [a4beb459e21af80c1d8c37b079686753c21932ca] https://lava.sirena.org.uk/scheduler/job/3031661
> # good: [a4beb459e21af80c1d8c37b079686753c21932ca] mm/vma: introduce VMA virtual page offset field and add helpers
> git bisect good a4beb459e21af80c1d8c37b079686753c21932ca
> # test job: [84bd1aceb0233c3de9064028d31a16ecf50070d9] https://lava.sirena.org.uk/scheduler/job/3031711
> # good: [84bd1aceb0233c3de9064028d31a16ecf50070d9] mm/rmap: track whether the page VMA mapped walk is anonymous
> git bisect good 84bd1aceb0233c3de9064028d31a16ecf50070d9
> # test job: [880b6fe7442df760fe0a726b5f5e568bc6b450b6] https://lava.sirena.org.uk/scheduler/job/3031752
> # good: [880b6fe7442df760fe0a726b5f5e568bc6b450b6] tools/testing/vma: expand VMA merge tests to assert virt pgoff
> git bisect good 880b6fe7442df760fe0a726b5f5e568bc6b450b6
> # test job: [e2ad1c5a1f0a96a4a0435213b0a5cb963dc501c5] https://lava.sirena.org.uk/scheduler/job/3031804
> # good: [e2ad1c5a1f0a96a4a0435213b0a5cb963dc501c5] mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
> git bisect good e2ad1c5a1f0a96a4a0435213b0a5cb963dc501c5
> # test job: [9f2782812095787d87ee6b742899ae37966ef0f5] https://lava.sirena.org.uk/scheduler/job/3031854
> # bad: [9f2782812095787d87ee6b742899ae37966ef0f5] mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
> git bisect bad 9f2782812095787d87ee6b742899ae37966ef0f5
> # first bad commit: [9f2782812095787d87ee6b742899ae37966ef0f5] mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous

Cheers, Lorenzo

