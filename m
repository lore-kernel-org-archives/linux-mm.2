Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADAA7606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 20:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=WGeymg4H
Received: by kanga.kvack.org (Postfix)
	id BC1786B05B0; Wed, 18 Nov 2026 15:15:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71FE6B05B1; Wed, 18 Nov 2026 15:15:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88FD6B05B2; Wed, 18 Nov 2026 15:15:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7583F6B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:15:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04762A0858
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:15:54 +0000 (UTC)
X-FDA: 85449345870.26.C1FB9C5
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0E05F40005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:15:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=WGeymg4H;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf07.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795032953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t46oCZlEPTr5mTMcBQO1+iAphJVAGxOpg+yCTJY7ELc=;
	b=IlmRgV1qzKe+Dx+KSkg+FYKhi/RoojCkojs0mJrGh+FT2AKjL5mlpaZfNuiGVidk9GoA1x
	34LEd0ADCB2G9748usm+GHJagCijEIh3NKAnukhamAkWtFv1WX+1FmX9mHirI7cP3n6KB0
	lO+FErOsGcaBRZYDfBqi6bVIbo+azOo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=WGeymg4H;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf07.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795032953;
	b=olsGLtL0ycZZDkeeWtNdLQ0CKvRxYIaM8dK/5tqrWtxArCePNo7/Oj7kWRYMJuAG22XPpw
	w/oOwHkvE2w2EYrsq1BXZb9ipD7w2npoZTGqpQ1hsBZdfnXOQMb06MXFMcrG552KnHAyNi
	EIMFb1zeAw9ayrwx40Noh+o2qTsFqnQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=t46oCZlEPTr5mTMcBQO1+iAphJVAGxOpg+yCTJY7ELc=; b=WGeymg4HyfLLCD02rVRbeH66gh
	DlppyLse3qppMUZ1SNctkolV/9THkuLRy37LfplwZetrsGg80vw2WWpE/6HyAj5CttbrBwfdF6Uqw
	+j3w8CgjznkmAhDrhpDtJZMItwlUy9ok/2P3l9IaEPPQNdmyrvPN1U7IFpAbmYNFF+FUTzRh4t9/h
	h6iaT+m/DI18b8kKJ0keCcE6B8WzSzB+dOwOZFtjuOK7CQEpRM+0Ze1Sav/nRxQ28Kg2vQszlsFTL
	NuI8bPgus//uPJHb23MFC6D30xMSAkW1gmNCG0MgBNpyKwIF7YWbFbTzluEYy8qS0ezEjB5Nc5seL
	LMqCrkew==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTm4M-0000000ACGb-38U7;
	Wed, 18 Nov 2026 20:15:51 +0000
Date: Wed, 18 Nov 2026 15:15:47 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: consolidate the memory mapping entries into
 a VMA entry
Message-ID: <pczhkwshm2stepxznvaxynkp5svfuc5kdzmwenyrxjp2tm32p6@bdbuvvak7vow>
References: <20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0E05F40005
X-Stat-Signature: yejzip4bbz654s1np19zqarffajhsnaf
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795032952-383496
X-HE-Meta: U2FsdGVkX196Y/QEkcA7q+VUaMy9ffTJIRENFqSMU9UXK/W5t4PPMR2aK1cBs8QHhZ8FtXglKGjVQz454vbRiecfk2zl+87DeR0rn9x8NTiQJVjgk5+IhwuwBvgOUUloUmhmqnXi1mdcYPDN7+/6NNq3TB6WexTV8aT3OhhzlCTeHIRTHSPJw4K9QW5ugM+0mKC8Wl9drOsHtghsPy1DQqrQ+8BER/AUD26Zz7iVZ80+GA1Oefpp5TuAzqPI3jaUaQl8tz857tnsT6vMTaNCu52wyOVDI+nwb+/+DTJidn2hT8kWgoQniRNUv+ZZhRD9TIoGdQrdKoXCd7soUgdv4lrk84tCmSSnYXWSgpZHPAPaCFD/ic64arWhtkHQJVq6e3jxCvkZX1JYh8gO+ragrSgGvaXVZL5aX+C12CeWXzXBPjjpHLc+XUnhtm9D1fIFEhwSxoR5HdYcuQlCuru7TytIO4UFes/Gd2TcrERzbQevg82pN+IQx3mK/q8F0YSsuZbk6Rct1AIHaUIzvWXeTZkB9PYTU5Z/BXVIclXG8+t7FgnD23vk4C8Q0WDDpo4QmwInn+2/KZ86HkQSa1H8Yusb+L1QA10zEFaWRA10ajvlkZpgbF6U+4qlWTuJSBw2oAGZjLA6hR8TxpIENHZRA6uoJPjkvH9OdjHQOXCzDYSk7PtFi3pnXb8yNrGmP4Dlf5chAmTKbSqf88jPdRejGslTrr8RJoID14NP+UxmDcNNt9qtIXi6WhjaVCZoYjZhThO8HbCQYese8inwugFGkocbCuNw3Dh8QGqDtczmlMHNQVuOCJnaUM74Rn2nuwJV2Y8qEkW9Np1RJfkrep2K95ZKg3hHpQ5n/8VowHngyZF9EasG+Rpfqvj+wqjfTv/odobyizh5ltzw1ZXbjdeGLpBJ5VubuVMlIK9fChd59757Ze735eskkBay/LoTbvl8/U/0ulZNWxJ/lYdbwgs
 E/TOFhOL
 t29nQqDvoaX6HVM/xf4kL2J/oymyT9i8PpXol3okfv/j471NvKDP2WPVl54//bF7Xyk1fHWeWTIP/EQioPDSpTj1LUG3a5boH9QNoAxuy/QdXmsscHqCLL0aipAIDKo0iPmfN3dPAi2a7KC/VamtQ/0+sx3LZ74Mo5mTwPeeqznlXOTjRzLxcamPfrLR1J6hFy5TEEwltnbxc/TGJIINc+VUQPDAVjI5Lk4f1PqWGFhWh1dF6keVSfS0g4KCptAJSUPRFJXyG1+X4TnVuHPALCnfbHd7HX0xaSUPDYGqyeTYQ/O1OfHXhtMFkXBp2+v5ZqMgrSAAONbWuOmyy2XvmUEXwAmCGyNuxhVue2brhFkYbAtMNCivYACcFSVA1+Gr3ow3Tfv+H8Kl/qSqEh/4GQvNkv3ucV5cxB05ZKq+D65FXBh7rar68v3r6uDvfTKSST8fflNwNE1Be6l740sKviak8q0y0D+u2JX/oJoljQ4IzWijtUdjjInSJzXM116gm+aHI45NuKJM5gW/rU4PF+jwzmWR7x2NFwfN7/P63Tra1EkStxLQVVH+hpNgtkGjvOSIsWjZGZQhfMAjiDpPf8V3W+ocZdezYBUSkpgdLd2TFp5ae4RZk4zdU+Rc2mFHVolTWMxbcHMGd3XT5m7TeHyQhTzCbII7ehn84UmdNJZk/HqGjaS8ddW9eUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/18 06:22PM, Lorenzo Stoakes (ARM) wrote:
> Memory mapping entries were kept in three different sections in order that
> those maintaining/reviewing each distinct part would be made responsible
> for/cc'd on only those parts.
> 
> However this creates confusion as to what files belong to which component,
> so simplify things by consolidating them into one.
> 
> Expand Suren's maintainership to the entire component, as he is a trusted
> and valued member of the VMA kernel team and very much deserving of the
> position.
> 
> Additionally, drop Suren's core and misc reviewerships in order to focus
> upon VMA.
> 
> As David is receiving pull requests directly, make him a reviewer, purely
> as an administrative change.
> 
> Also specify the new tree location in preparation for the tree being
> established for next cycle, and remove the link to the not so regularly
> updated linux-mm website.
> 
> Given that, from next cycle, the tree will sit outside of Andrew's current
> process, remove his entry, also purely as an administrative change.
> 
> With that said, I'd like to take the opportunity to express gratitude for
> Andrew's huge contribution to mm, and for his being both generous and
> gracious throughout this period of change in the subsystem.
> 
> Co-developed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
>  MAINTAINERS | 51 +++++++++++++--------------------------------------
>  1 file changed, 13 insertions(+), 38 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 222b7fc2c3aa..59496dd1d11e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17509,7 +17509,6 @@ R:	Lorenzo Stoakes <ljs@kernel.org>
>  R:	Liam R. Howlett <liam@infradead.org>
>  R:	Vlastimil Babka <vbabka@kernel.org>
>  R:	Mike Rapoport <rppt@kernel.org>
> -R:	Suren Baghdasaryan <surenb@google.com>
>  R:	Michal Hocko <mhocko@suse.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> @@ -17680,7 +17679,6 @@ R:	Lorenzo Stoakes <ljs@kernel.org>
>  R:	Liam R. Howlett <liam@infradead.org>
>  R:	Vlastimil Babka <vbabka@kernel.org>
>  R:	Mike Rapoport <rppt@kernel.org>
> -R:	Suren Baghdasaryan <surenb@google.com>
>  R:	Michal Hocko <mhocko@suse.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> @@ -17974,30 +17972,37 @@ F:	rust/kernel/mm.rs
>  F:	rust/kernel/mm/
>  F:	rust/kernel/page.rs
>  
> -MEMORY MAPPING
> -M:	Andrew Morton <akpm@linux-foundation.org>
> -M:	Liam R. Howlett <liam@infradead.org>
> +MEMORY MANAGEMENT - VMA
>  M:	Lorenzo Stoakes <ljs@kernel.org>
> +M:	Liam R. Howlett <liam@infradead.org>
> +M:	Suren Baghdasaryan <surenb@google.com>
>  R:	Vlastimil Babka <vbabka@kernel.org>
> -R:	Jann Horn <jannh@google.com>
> +R:	Shakeel Butt <shakeel.butt@linux.dev>
>  R:	Pedro Falcato <pfalcato@suse.de>
> +R:	David Hildenbrand <david@kernel.org>
> +R:	Jann Horn <jannh@google.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> -W:	http://www.linux-mm.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/vma.git for-next
>  F:	Documentation/core-api/protection-keys.rst
>  F:	Documentation/filesystems/mmap_prepare.rst
> +F:	Documentation/mm/process_addrs.rst
>  F:	Documentation/userspace-api/mseal.rst
>  F:	fs/proc/task_mmu.c
>  F:	fs/proc/task_nommu.c
>  F:	include/linux/mman.h
> +F:	include/linux/mmap_lock.h
>  F:	include/linux/pkeys.h
>  F:	include/trace/events/mmap.h
> +F:	include/trace/events/mmap_lock.h
> +F:	include/uapi/asm-generic/mman-common.h
>  F:	include/uapi/linux/mman.h
>  F:	mm/char-mem.c
> +F:	mm/madvise.c
>  F:	mm/mincore.c
>  F:	mm/mlock.c
>  F:	mm/mmap.c
> +F:	mm/mmap_lock.c
>  F:	mm/mprotect.c
>  F:	mm/mremap.c
>  F:	mm/mseal.c
> @@ -18011,36 +18016,6 @@ F:	mm/vma_internal.h
>  F:	tools/testing/selftests/mm/merge.c
>  F:	tools/testing/vma/
>  
> -MEMORY MAPPING - LOCKING
> -M:	Andrew Morton <akpm@linux-foundation.org>
> -M:	Suren Baghdasaryan <surenb@google.com>
> -M:	Liam R. Howlett <liam@infradead.org>
> -M:	Lorenzo Stoakes <ljs@kernel.org>
> -R:	Vlastimil Babka <vbabka@kernel.org>
> -R:	Shakeel Butt <shakeel.butt@linux.dev>
> -L:	linux-mm@kvack.org
> -S:	Maintained
> -W:	http://www.linux-mm.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> -F:	Documentation/mm/process_addrs.rst
> -F:	include/linux/mmap_lock.h
> -F:	include/trace/events/mmap_lock.h
> -F:	mm/mmap_lock.c
> -
> -MEMORY MAPPING - MADVISE (MEMORY ADVICE)
> -M:	Andrew Morton <akpm@linux-foundation.org>
> -M:	Liam R. Howlett <liam@infradead.org>
> -M:	Lorenzo Stoakes <ljs@kernel.org>
> -M:	David Hildenbrand <david@kernel.org>
> -R:	Vlastimil Babka <vbabka@kernel.org>
> -R:	Jann Horn <jannh@google.com>
> -L:	linux-mm@kvack.org
> -S:	Maintained
> -W:	http://www.linux-mm.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> -F:	include/uapi/asm-generic/mman-common.h
> -F:	mm/madvise.c
> -
>  MEMORY TECHNOLOGY DEVICES (MTD)
>  M:	Miquel Raynal <miquel.raynal@bootlin.com>
>  M:	Richard Weinberger <richard@nod.at>
> 
> ---
> base-commit: 0c524518413094607a6178c53a65815762bc9c45
> change-id: 20261118-maintainers-consolidate-vma-entry-ff6a360ab069
> 
> Cheers,
> -- 
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

