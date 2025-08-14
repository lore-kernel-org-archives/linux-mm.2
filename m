Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05FE6CA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 08:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 927B2900111; Thu, 14 Aug 2025 04:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D649900088; Thu, 14 Aug 2025 04:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C66D900111; Thu, 14 Aug 2025 04:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6235A900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:34:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08D5AC0368
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:34:23 +0000 (UTC)
X-FDA: 83774701206.05.433D408
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf07.hostedemail.com (Postfix) with ESMTP id 626D340007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:34:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sYJMiC+A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755160461; a=rsa-sha256;
	cv=none;
	b=fIR4hxYQi9wLL4MAHNs4VEyAn3qaByfbCHG2Y3V/zOGmhIUZHGecHDJjHU3LDE8zVGskD+
	MsgUqfC5qv/a/Fx4pu8Ja/bp+nZLhr2rkv7eF7Yde2V0NFGyKNsnQEocUd1MdL6akk5fuz
	uTL8oOIp2XAVkCafxven4oVkIDzMXiE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sYJMiC+A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755160461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6E8Jhr1CwXdInnBhT/QSY6vkkwnQRWaMf581v4Q5VKE=;
	b=F44iXwzf58j9dY/XT2oNu/GoZYBS/1BLykEKlh25rSskPU2Et2SHKc35N3W7IS81t5+Ooh
	JQGclXJTwTD5UssGX85XezX/MY35qE4O1og2m/lUtP4u2wsyvhkNIINId1AIfGd0HUqBxP
	69UC5IxxlwHNEq2QnIbeovDf83yADUw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 839C5A5564D;
	Thu, 14 Aug 2025 08:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83461C4CEEF;
	Thu, 14 Aug 2025 08:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755160460;
	bh=JJZTzu+RAz4/lXyoF8hhed0E/+6KW4y3Lc2HDHprM3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sYJMiC+A6ZsYL/xcMfF5gXE5Tqd2ONGCHOWgXGdfoS679A/WsvWY4v/yNnAdOGJ+l
	 jTR2ZQjW5ocrjLWjjrbnOIQaPGP72w5wLeWhPEeNMh/kwb4iF3HCdoGM4lS27vlnlE
	 C06vKS2l/dvw+L7KYiTEAmNBniJOG5U2Dg3Z8Oqi41JdMD+dOS2ox8Yt3JVFMK4Ko8
	 yPGdi7p5vKJqhIUOiCUOT01Fp1IeSJzEyef+iKY1gvCG+p8H824C5wj+OzG16e87LX
	 PfIthLVHmXIqBCLYKsRoqDM9o16zhFcmVnIDLFE4O9kfBbO8ZR3C0vmiLs8ODwrqV+
	 DOhyHiLRa8bQA==
Date: Thu, 14 Aug 2025 11:33:59 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Matthew Wilcox <willy@infradead.org>,
	Mateusz Guzik <mjguzik@gmail.com>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 05/10] mm: convert uprobes to mm_flags_*() accessors
Message-ID: <aJ2fd3iD6GqZ_LWw@kernel.org>
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <1d4fe5963904cc0c707da1f53fbfe6471d3eff10.1755012943.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d4fe5963904cc0c707da1f53fbfe6471d3eff10.1755012943.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 626D340007
X-Stat-Signature: scabibyunj3raziky8mwzbn8qsxh5epg
X-HE-Tag: 1755160461-517011
X-HE-Meta: U2FsdGVkX1/wX/P2WvrIWOakUK7kUSwfet9FndWk45xhLjbPx20ReIqviZsvtYXux/lI6CygWjFikC8M6GAza7dl5NWCmnvCmiwWCviFgX1PsaqIjwOxbQM8X/MfFtjvdy1r1hD296DcpFJi/apFfDr8RS9qg5LBrYvZJninREnIrkuXfDnvRcbxLg0XS/F2Y7S7aesQgB44iU0cDLAOA3Lm9Cz24gReJKBXBtN6hM23c+FkZWK8Qd5vKuijQ5D6OZmTg65lOaNllV31RNMw89YT1dpMEw3KX0M+yo8pO2jXgnDopJUg5x0lxAQqKUrznyRZF9xc7vz4MLQf/m4T2wHFPgtZMn2S51B83s/7cCcycq8Ik/9oyHHZ/FTLtyi0QVKfavgOIs5Xk9pJk9+cUZKIWKsADlPplCD3HAX7xCS2q6+6uGHt3hOPf9OlSDD8cMsgUjq3PwwRBNxsLf1Ro42OtXna5ajn2WwUSXqeM44xkz6Uo03GoJfDM1OqKTcy60qmib21xH2q/zRIaXaq9psppNk1Pk/d4FOHooUocje7+piZAeBn+bhCkw6ruv2c/w44d9G6EN0HDeeuzE1l3SHWNYd+EWc+uGcAuFURLzmXC+PLwNgJ6wNmX+DEhTzGSDHiULuuevLKJZFHL5sVdmvTB5Daf4obWWlWVOxuaGP1+VILmhI2isj3FfKdrkul8u825haCOUJ49oKCzLGB6C9ePbzQbPUFKqadlm9LlallI95hzQ00WRQNR9NfpierJI1SZ9vjcoqd/0dngELZ3yIXPx+b5e182uS50VJXbHhbs7S3f6K0BS6xQg05vtb+cvH3lRjAJaFnFXAvBMRPDysjpAdT6RifLZLVHL6YBG0kQxAMco6HbXFIa/Mr8qlqoJUf84NYI59iuUPTGS7b4+Xn2ZqEQ9lLoO6oHQvbj6xfSueVjZU7LnCn4iR9qZNyLs5epSNXl/agwtoLwGJ
 4y3OWmC4
 GVAtCOxphVrROlp/aXx4qYPSppFHp2iIlRdwoizu3vUwx5/3S6HbxmDl43a6mM66wmNn9gGBHYnmTGInZC6RzjtM/k0OeZYsHD6BAC2sBuM4gxXr81KaEUDNcewy3tYzAhrJP7LBzbcGwtSFRhbEJB5/xWcYim9o7t6VS7DlN/PScJJQ5oei9uzHkoIbiRdXHOM65PNgWkMtSMo96v4B0SV3yfjRxx1u6qt2NGVRTEdtjpgaamv5+ItYbPk/VgnVgQ2qy6uwunhLF34ZAg1mbokT1+flAZZnLtHZ1rswoEfIc9wRbMyXABZC+kDf0uL3wo7orf2OcyDRPt9LwNNrvI+V7Jgo/kdKI+Gwzetc4cwJ6rBTQ3dy/7JabX4WR1pmKLY57
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 04:44:14PM +0100, Lorenzo Stoakes wrote:
> As part of the effort to move to mm->flags becoming a bitmap field, convert
> existing users to making use of the mm_flags_*() accessors which will, when
> the conversion is complete, be the only means of accessing mm_struct flags.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/events/uprobes.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 7ca1940607bd..31a12b60055f 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1153,15 +1153,15 @@ static int install_breakpoint(struct uprobe *uprobe, struct vm_area_struct *vma,
>  	 * set MMF_HAS_UPROBES in advance for uprobe_pre_sstep_notifier(),
>  	 * the task can hit this breakpoint right after __replace_page().
>  	 */
> -	first_uprobe = !test_bit(MMF_HAS_UPROBES, &mm->flags);
> +	first_uprobe = !mm_flags_test(MMF_HAS_UPROBES, mm);
>  	if (first_uprobe)
> -		set_bit(MMF_HAS_UPROBES, &mm->flags);
> +		mm_flags_set(MMF_HAS_UPROBES, mm);
>  
>  	ret = set_swbp(&uprobe->arch, vma, vaddr);
>  	if (!ret)
> -		clear_bit(MMF_RECALC_UPROBES, &mm->flags);
> +		mm_flags_clear(MMF_RECALC_UPROBES, mm);
>  	else if (first_uprobe)
> -		clear_bit(MMF_HAS_UPROBES, &mm->flags);
> +		mm_flags_clear(MMF_HAS_UPROBES, mm);
>  
>  	return ret;
>  }
> @@ -1171,7 +1171,7 @@ static int remove_breakpoint(struct uprobe *uprobe, struct vm_area_struct *vma,
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  
> -	set_bit(MMF_RECALC_UPROBES, &mm->flags);
> +	mm_flags_set(MMF_RECALC_UPROBES, mm);
>  	return set_orig_insn(&uprobe->arch, vma, vaddr);
>  }
>  
> @@ -1303,7 +1303,7 @@ register_for_each_vma(struct uprobe *uprobe, struct uprobe_consumer *new)
>  			/* consult only the "caller", new consumer. */
>  			if (consumer_filter(new, mm))
>  				err = install_breakpoint(uprobe, vma, info->vaddr);
> -		} else if (test_bit(MMF_HAS_UPROBES, &mm->flags)) {
> +		} else if (mm_flags_test(MMF_HAS_UPROBES, mm)) {
>  			if (!filter_chain(uprobe, mm))
>  				err |= remove_breakpoint(uprobe, vma, info->vaddr);
>  		}
> @@ -1595,7 +1595,7 @@ int uprobe_mmap(struct vm_area_struct *vma)
>  
>  	if (vma->vm_file &&
>  	    (vma->vm_flags & (VM_WRITE|VM_SHARED)) == VM_WRITE &&
> -	    test_bit(MMF_HAS_UPROBES, &vma->vm_mm->flags))
> +	    mm_flags_test(MMF_HAS_UPROBES, vma->vm_mm))
>  		delayed_ref_ctr_inc(vma);
>  
>  	if (!valid_vma(vma, true))
> @@ -1655,12 +1655,12 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
>  	if (!atomic_read(&vma->vm_mm->mm_users)) /* called by mmput() ? */
>  		return;
>  
> -	if (!test_bit(MMF_HAS_UPROBES, &vma->vm_mm->flags) ||
> -	     test_bit(MMF_RECALC_UPROBES, &vma->vm_mm->flags))
> +	if (!mm_flags_test(MMF_HAS_UPROBES, vma->vm_mm) ||
> +	     mm_flags_test(MMF_RECALC_UPROBES, vma->vm_mm))
>  		return;
>  
>  	if (vma_has_uprobes(vma, start, end))
> -		set_bit(MMF_RECALC_UPROBES, &vma->vm_mm->flags);
> +		mm_flags_set(MMF_RECALC_UPROBES, vma->vm_mm);
>  }
>  
>  static vm_fault_t xol_fault(const struct vm_special_mapping *sm,
> @@ -1823,10 +1823,10 @@ void uprobe_end_dup_mmap(void)
>  
>  void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm)
>  {
> -	if (test_bit(MMF_HAS_UPROBES, &oldmm->flags)) {
> -		set_bit(MMF_HAS_UPROBES, &newmm->flags);
> +	if (mm_flags_test(MMF_HAS_UPROBES, oldmm)) {
> +		mm_flags_set(MMF_HAS_UPROBES, newmm);
>  		/* unconditionally, dup_mmap() skips VM_DONTCOPY vmas */
> -		set_bit(MMF_RECALC_UPROBES, &newmm->flags);
> +		mm_flags_set(MMF_RECALC_UPROBES, newmm);
>  	}
>  }
>  
> @@ -2370,7 +2370,7 @@ static void mmf_recalc_uprobes(struct mm_struct *mm)
>  			return;
>  	}
>  
> -	clear_bit(MMF_HAS_UPROBES, &mm->flags);
> +	mm_flags_clear(MMF_HAS_UPROBES, mm);
>  }
>  
>  static int is_trap_at_addr(struct mm_struct *mm, unsigned long vaddr)
> @@ -2468,7 +2468,7 @@ static struct uprobe *find_active_uprobe_rcu(unsigned long bp_vaddr, int *is_swb
>  		*is_swbp = -EFAULT;
>  	}
>  
> -	if (!uprobe && test_and_clear_bit(MMF_RECALC_UPROBES, &mm->flags))
> +	if (!uprobe && mm_flags_test_and_clear(MMF_RECALC_UPROBES, mm))
>  		mmf_recalc_uprobes(mm);
>  	mmap_read_unlock(mm);
>  
> @@ -2818,7 +2818,7 @@ int uprobe_pre_sstep_notifier(struct pt_regs *regs)
>  	if (!current->mm)
>  		return 0;
>  
> -	if (!test_bit(MMF_HAS_UPROBES, &current->mm->flags) &&
> +	if (!mm_flags_test(MMF_HAS_UPROBES, current->mm) &&
>  	    (!current->utask || !current->utask->return_instances))
>  		return 0;
>  
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

