Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 657C1EB28CE
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 06:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9A66B0089; Fri,  6 Feb 2026 01:13:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7346B0092; Fri,  6 Feb 2026 01:13:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6026B0093; Fri,  6 Feb 2026 01:13:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 357D86B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 01:13:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD0DA1607D2
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:13:50 +0000 (UTC)
X-FDA: 84413015820.08.8F5728C
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf26.hostedemail.com (Postfix) with ESMTP id CA00C140004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:13:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dC/jcKtH";
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770358429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4dJ2KwSmRisMZ/4xd6+bG4Q7esCOyMfca25PcWP+cI=;
	b=SRrU4zrXWVMUX2pokykzMpBL3VnmbPrntNSyZLZHEgyGME2ltAW4G1tQgqjlkZH/sME94Q
	6j7O5qIPzwGpPzuNMsGa4jgBOCQEOC6RwddOEMs94u6d9mn/KbfshBuSFPIfQ7DJeYX0/f
	VChtue1RisEVsuvMZcQqFz7IX3IFTjc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dC/jcKtH";
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770358429; a=rsa-sha256;
	cv=none;
	b=S4GAHX1CRFaSOlBgoVwT9Dc3Fr7FXvH9zgp8VSFDDBnyg3wrb1SI+jXhe+gsPXGTqvsLMn
	7DHO3CoR+xjkBIGtVu8eyGOx8zt9uXxEh1bhy4CDC7oJY4xe2Kie/LoAyyMgX/bUonzTUG
	XOC5GrumMVy69qs1qtxHMCqH0zf8wOo=
Message-ID: <cbb1ba53-134b-487f-87c0-85ca4791773e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770358426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f4dJ2KwSmRisMZ/4xd6+bG4Q7esCOyMfca25PcWP+cI=;
	b=dC/jcKtHfNMquOXuvapGfNJT6W1nn2qqoibSINRKajvM0TW82x5ygrDaisDNQCL1sOpKRb
	2Iek+94Q6nTAH410kB+pam/JhF6U0VU9rOG6KsRRZh90nRYs6AGKXl7HpvTUhbSIzEJOTi
	PqcAcaDs4RZo9IVv8sPt/yUhOLquyhE=
Date: Fri, 6 Feb 2026 14:13:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 24/31] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
To: kernel test robot <lkp@intel.com>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
References: <e27edb311dda624751cb41860237f290de8c16ae.1770279888.git.zhengqi.arch@bytedance.com>
 <202602052203.U8hxsh2N-lkp@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <202602052203.U8hxsh2N-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gnicgn6hgjwe5qwos6t4nr3w63jwwae3
X-Rspamd-Queue-Id: CA00C140004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770358428-365732
X-HE-Meta: U2FsdGVkX19hFmBC1azI+d6TvOifBPd/QyZ4hxnq2aBA7d6BCYeJKcciroDfN81X9Snzy+IoZFWuiV1IpDFG9V3DHOUeNSQs40+TjotP8np5dRQrcdiRRGtYj8RumlK9Ec80/Rl+Jct5PQpt7XRjpx8+uUX5iHhXeJmszgZyGLxrkgHPZ2Wnq0UxJxeRWNbCpXFpqktbFnazLxE9pwbMQcuh/4ELqImj6birLIRnN4wI1XQ+L+xWrAa5lhTJqDZzO+DOUzWelUkrrSy7cdzHqDB+LPAeXmgwr1a9gw+g6HV3TjkiAMEV0B3W72DncDqhu0aUg9a0hYx2sSdtOB66ox58ovyWP+n3k69M6MCbqyWTaJnR675dNFJBo5wT378y/WSAQ1U8Yxgqpak+TDT/deJSFEhWhngKepJUn1/6nyECGRwdH5hjU4bzj7PIxrkie35JpA+04C/+CabmN1v3jb3yGba+V3UbMbYq800HCPTW7gBGwq+3/KEPdnst9YFd6SJAnTrNoSmzxLLLPqMuqApuOx1TUQMrcOFhSPKSQbI5Ph5rd1psBmFWAh9TtK5SATCGpux7oCqCN7nMz/2to4txYUxjAO5lzvX9Un7+8CdwfKWBukjHeX9ZwPKUgj0upyQQnuejmQhQyzVRzbhZutW1D/uszmyw9oQEu2hIa3Sd/IdMp1Vh16Q+oucKYwoVLLgTASMBOz/smhZGkQAPObCQlbugrcJ82V/VBQVXXAMPAJv0Ezh99pQY3d591LJmjFaTVAToIsFp+vO6azFPTRAgswk+acspwlJKSHI8z2suvq4APRKCx4Rb8V61GLgTpW6IfyMTwzhnAopDwIWuYgRKIdWUevtFlrWCrRTCxZGOxRX4PSNTzDglsioGepJlObmPqcN5BvrVS9f6Uk9y32vVy5gTCAswCVuoHD/mluJz32QL/0shdqmWIdX756aPiPvGFlg4nBHOFf8ijHy
 4cqaUsP3
 OeVs+to/G1PC78ykEP0TWs/MIeJDB3Bwa7DZlijy/TJ9fH7C2/ZGPUmamHROmm/yJE7Mavx9Sl8YuBsW53oYJJUdwPHQ4FNqqb/UN3ymTfcjfYfySuTVaq6anuKAFYIPzZvAXKrD3T/sYqo+YJGPxhX6F3cmbVUcB1XGSrox8VWjxPZ/ZsEvccPLe59e7rghPiFVtEBdqtTDNn3L/WZBUSFfYmsEFWQ2M6qHt2322WK9k8jrdFKeW/G78TYXMQcMFibMaT1wN4EFTzETklQjSs7oM/o0R6Y/ubiTf8ePwtuxVak+4DPxEh6+h6fxDxDhc2IS/6PLFlYiDu142aunQsaCqbkFMYfo5+iF5yRr4q4kXpT/R4Br8DEzxNfzBARcx8uQJBz13h3RKwRA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/5/26 11:02 PM, kernel test robot wrote:
> Hi Qi,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on next-20260204]
> [cannot apply to akpm-mm/mm-everything brauner-vfs/vfs.all trace/for-next tj-cgroup/for-next linus/master dennis-percpu/for-next v6.19-rc8 v6.19-rc7 v6.19-rc6 v6.19-rc8]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Qi-Zheng/mm-memcontrol-remove-dead-code-of-checking-parent-memory-cgroup/20260205-170812
> base:   next-20260204
> patch link:    https://lore.kernel.org/r/e27edb311dda624751cb41860237f290de8c16ae.1770279888.git.zhengqi.arch%40bytedance.com
> patch subject: [PATCH v4 24/31] mm: memcontrol: prepare for reparenting LRU pages for lruvec lock
> config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260205/202602052203.U8hxsh2N-lkp@intel.com/config)
> compiler: nios2-linux-gcc (GCC) 11.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260205/202602052203.U8hxsh2N-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202602052203.U8hxsh2N-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>     nios2-linux-ld: mm/swap.o: in function `__page_cache_release.part.0':
>     swap.c:(.text+0x4c): undefined reference to `lruvec_unlock_irqrestore'
>>> swap.c:(.text+0x4c): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
>     nios2-linux-ld: mm/swap.o: in function `__folio_put':
>     swap.c:(.text+0x2ac): undefined reference to `lruvec_unlock_irqrestore'
>     swap.c:(.text+0x2ac): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
>     nios2-linux-ld: mm/swap.o: in function `folios_put_refs':
>     swap.c:(.text+0x384): undefined reference to `lruvec_unlock_irqrestore'
>     swap.c:(.text+0x384): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
>     nios2-linux-ld: mm/swap.o: in function `folio_batch_move_lru':
>     swap.c:(.text+0x4ac): undefined reference to `lruvec_unlock_irqrestore'
>     swap.c:(.text+0x4ac): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
>>> nios2-linux-ld: swap.c:(.text+0x50c): undefined reference to `lruvec_unlock_irqrestore'
>     swap.c:(.text+0x50c): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
>     nios2-linux-ld: mm/swap.o: in function `folio_activate':
>     swap.c:(.text+0x21d8): undefined reference to `lruvec_unlock_irq'
>>> swap.c:(.text+0x21d8): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
>     nios2-linux-ld: mm/vmscan.o: in function `move_folios_to_lru':
>     vmscan.c:(.text+0xa4c): undefined reference to `lruvec_unlock_irq'
>>> vmscan.c:(.text+0xa4c): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
>>> nios2-linux-ld: vmscan.c:(.text+0xaa4): undefined reference to `lruvec_unlock_irq'
>     vmscan.c:(.text+0xaa4): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
>     nios2-linux-ld: vmscan.c:(.text+0xcac): undefined reference to `lruvec_unlock_irq'
>     vmscan.c:(.text+0xcac): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
>     nios2-linux-ld: vmscan.c:(.text+0xd8c): undefined reference to `lruvec_unlock_irq'
>     vmscan.c:(.text+0xd8c): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
>     nios2-linux-ld: mm/vmscan.o: in function `shrink_active_list':
>     vmscan.c:(.text+0x11e0): undefined reference to `lruvec_lock_irq'
>     vmscan.c:(.text+0x11e0): additional relocation overflows omitted from the output
>     nios2-linux-ld: vmscan.c:(.text+0x12a0): undefined reference to `lruvec_unlock_irq'
>>> nios2-linux-ld: vmscan.c:(.text+0x144c): undefined reference to `lruvec_lock_irq'
>     nios2-linux-ld: mm/vmscan.o: in function `check_move_unevictable_folios':
>     vmscan.c:(.text+0x15d4): undefined reference to `lruvec_unlock_irq'
>     nios2-linux-ld: vmscan.c:(.text+0x1958): undefined reference to `lruvec_unlock_irq'
>     nios2-linux-ld: mm/vmscan.o: in function `shrink_inactive_list':
>     vmscan.c:(.text+0x2f8c): undefined reference to `lruvec_lock_irq'
>     nios2-linux-ld: vmscan.c:(.text+0x307c): undefined reference to `lruvec_unlock_irq'
>     nios2-linux-ld: vmscan.c:(.text+0x31dc): undefined reference to `lruvec_lock_irq'
>     nios2-linux-ld: mm/vmscan.o: in function `folio_isolate_lru':
>     vmscan.c:(.text+0x48a4): undefined reference to `lruvec_unlock_irq'
>     nios2-linux-ld: mm/mlock.o: in function `__munlock_folio':
>     mlock.c:(.text+0x968): undefined reference to `lruvec_unlock_irq'
>     nios2-linux-ld: mm/mlock.o: in function `__mlock_folio':
>     mlock.c:(.text+0xe5c): undefined reference to `lruvec_unlock_irq'
>     nios2-linux-ld: mm/mlock.o: in function `mlock_folio_batch.constprop.0':
>     mlock.c:(.text+0x158c): undefined reference to `lruvec_unlock_irq'
>>> nios2-linux-ld: mlock.c:(.text+0x1808): undefined reference to `lruvec_unlock_irq'

Ouch, I move lruvec_lock_irq() and its firends to memcontrol.c to fix
the compilation errors related to __acquires/__releases, but I forgot
that memcontrol.c will only be compiled under CONFIG_MEMCG.

Hi Shakeel, for simplicity, perhaps keeping lruvec_lock_irq() and its
firends in memcontrol.h and drop __acquires/__releases would be a
better option?

Thanks,
Qi


> 


