Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7763C9831A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 09:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2E26B008A; Thu, 24 Sep 2026 05:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBA2E6B009D; Thu, 24 Sep 2026 05:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1CE6B009E; Thu, 24 Sep 2026 05:31:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A232E6B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:31:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 225E080292
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:31:25 +0000 (UTC)
X-FDA: 85248137730.11.0B99D33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 87022A000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:31:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EZmbNWDr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790242283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NeTuCFcemX/adNl5XbtKYCBGxqR8ivj2ssA68DygpBo=;
	b=UCpZ4wVaJpQtWpkhXoEiNSESOU8136cZl5FCXpHHcLu7G3qS05IhIWfzTfui8ddtf0xfEA
	yucX/SSH9ngTRa+f+BYcWZfxW8thk97/WcHKZXDWzSywtXyDgL9vx0Hmv8KQu3R+MlS+Ve
	UeCiQ3YYHe5/XviS+2SmFruUPqaqIcw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EZmbNWDr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790242283;
	b=YD+ZvJjDvQxEiclt0D3J8d5B7poN4/1P6RQAmJ1pBsedmlHJDMV+XqM7j2r3d3w7I/VUuw
	dNJNpfRzG81KsihC8RnGHt+7DMReK4v83ApN35dg8Co2u46M2XxnLwnij8YX38y9uy+6DA
	Ss/7aSaFkOivXucTMKMcZRUY86VC6/E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED0816021E;
	Thu, 24 Sep 2026 09:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9CC1F000FF;
	Thu, 24 Sep 2026 09:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790242282;
	bh=NeTuCFcemX/adNl5XbtKYCBGxqR8ivj2ssA68DygpBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EZmbNWDrJtzCFAJtM9thEalDnEZjbzv/YFJ6VRB0CFMs6afx6LFyjqWeB9uvZu9Qj
	 x81U9J6SOwj+0cLIr/MZhV0koClWIOxcD5o/aYGCmtyDTOVlrSVvKX6ZfcZBj68e6K
	 vYdqUfgrFK//iQz1ODBsg0qkf5SSSUOk+wALZMA2yrtTuYJTmKd2zxd3tMMblpobmo
	 OPdWy5LyVA52bNPo6ohdMZWzXomoavKccUxrgflAMfYVBRrOQO6rK1bHxObbSADG3d
	 kdoP8cjsGmQto1i2Tuxf28J9IBuOzTTBvd4L9nigmzb2llrZgIVXCPzl22BDUyAmMY
	 BBCYQ4gHnz+VQ==
Date: Thu, 24 Sep 2026 10:31:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org, 
	linux-mm@kvack.org, regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: don't schedule deferred kernel page table freeing
 while booting
Message-ID: <arTtl-7Nl5Ie0SEs@gremlin>
References: <20260924092307.22813-1-mikhail.v.gavrilov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924092307.22813-1-mikhail.v.gavrilov@gmail.com>
X-Stat-Signature: aaucfh3zuiyfir8s8ri1uckksr7yfacm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 87022A000A
X-HE-Tag: 1790242283-336461
X-HE-Meta: U2FsdGVkX1/p+Uwq5S5s5vjRgV/St4EPt8xCi+Mpf0kY5mgqF3QzOP4x2Hi9cmO3KPrYiXCYBwevi8R1ygyPAMeKO2mjsvrJMNqQUtu3WIhH3n2ToCocPe8aafomfnmsigsRcmlOvNeEcyr+R6fGRel+Sn1UUt5qM89ll/yDVMGT6NEguK4IK7qpkBLH06o+ZdKbFx+g9Vn334Gxrw2vNjBw5BG0w9WzueCbJ/uvUnR3lO/zrwfwhXwWWd7dD9Q4oGH1plurSw2fPpaJQ5D+EfI2vl7GM5kvc9AQL9xvV52Du72ZZtg4zPnriHfPmXNT5XMWFDrBMoUFi6irqdXIA5L41+kTHfGNTuskNaBlsK6MhksVxaom7/iHNuMqGGeL6wGdDrOyWjhsnf1kmKMk1Z24r7poF1w7vIg7mLvOfqr6ZAQbzNptuvc4V8BpRQf8iwnF7EB0FWhd/idBDPP9nvGNPaeKeK/vpCqN1+/OfvjcKR1ilhukajUdC29JkMnnqH2p+SZ1CwnN/aehuMiQmFweWvy18XWL1AiiHH4VvkCkuDgGoybVwm5kgtAOMtmmzHwLvVqxEYGCGwlcPFR0RFmca9QJyGJOSGvXJqK0/GhAOvW/8AVuqtSyXXKDA2sv2xA/JgCv/HsmrZRWDieQczGDsdEXPfSaiTIsV3snRKYwev2o2Wh0/k/IkpMYrmPsAM8mm+2NvddTMf6iXmHc9X6XYlDO+djAAbku3moov011gGXMKMyeoeXmgAMWVhdyBt+DHdzkpPjNyVajqJ63gRVl8dRWt7p3HM9xSsKnbR6SvFUbcK40rpD3Gm5iUfO347ti7fmUFxYv+kTtqQzsO3xrAxoL7Q5CtdoWcEXe/NUseWJYHeZb27tpVcfaNmtaumJM+2c7+vOGLKYIsFC8FADdExeQ3X5ldey9jiWXrGD4BVhJwVoyaRcv2fE383reX7nz/WnNcW19vUQj8W/
 vGE+fgcM
 7TBXrYGDOcrdFsnlYYkhhbwF13kjCcyy1OJdJREBdeWcf4AGnNcoyuboQVo2AoR5S0kI+ktWz9tvoQ6vSYkTtc8MqRQJhLqpum4rkZwG+q5CHEWGQLJ88Kie5P2eJtQCX5zAQkficBmxU97VYmhVdPUVFA6M8GCN6I34jNFuyUxqMglMQJtamh3pwKLS98K5iqB03x0xGDZNsV3TXUtTRbHxOuKXG+roIamOPygupOcDW8w6nAy0iMtMOJOKlwOZNZozaufw/jicP0ZzQ2THVF0RoS6S1WGVI65Z2GyEI79cOU9vI/IRQYr+NNjuuHFmBxsCBhIy3AYAR3QE6rnyFiPCcxn0lF0tySI5Qz2WMx3sCSR4WzjwhFgj3QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I know I said go ahead so it's my fault not yours, but in general please don't
respin so fast :P

I made a suggestion on the other thread which this has now raced. See below!

On Thu, Sep 24, 2026 at 02:23:07PM +0500, Mikhail Gavrilov wrote:
> Booting with a boot-time function tracer and a filter, for example
>
>   ftrace=function ftrace_filter=pud_free_pmd_page
>
> panics on 7.3-rc4 as soon as the tracer starts:
>
>   [   23.531178] Starting tracer 'function'
>   [   23.675800] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000038: 0000 [#1] SMP KASAN NOPTI
>   [   23.819917] KASAN: null-ptr-deref in range [0x00000000000001c0-0x00000000000001c7]
>   [   23.964025] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.3.0-rc4-fe2ec83746e5-with-fixes-v2+ #195 PREEMPT(undef)
>   [   24.252248] RIP: 0010:__queue_work+0xab/0xf00
>   [   25.981629] Call Trace:
>   [   26.125727]  <TASK>
>   [   26.413912]  ? pagetable_free_kernel+0x20/0x120
>   [   26.990283]  queue_work_on+0x97/0xf0
>   [   27.134382]  __cpa_collapse_large_pages+0x501/0x6f0
>   [   27.566662]  cpa_flush+0x394/0x620
>   [   27.998953]  change_page_attr_set_clr+0x321/0x4a0
>   [   29.151729]  set_memory_rox+0xa2/0xf0
>   [   29.584018]  create_trampoline+0x431/0x6f0
>   ...
>   [   44.343347] Kernel panic - not syncing: Attempted to kill the idle task!
>
> The boot-time tracer is started from early_trace_init(), which runs
> before workqueue_init_early().  Making its trampoline read-only splits a
> large page, and CPA collapses it again right away.  The split table has
> been a kernel page table since commit 9e4a3ec3411b
> ("x86/mm/pat: Allocate split page tables as kernel page tables"), so the
> collapse frees it through pagetable_free_kernel(), which queues work on
> system_percpu_wq - still NULL at that point.  That commit is correct in
> itself; it only lets CPA reach pagetable_free_kernel() before the
> workqueue that function relies on exists.
>
> Keep putting the table on the list, but don't schedule the work while
> the system is still booting.  The next kernel page table freed after
> boot schedules it, and the work then frees the early table too, after
> the same IOMMU flush as any other.  If no kernel page table is freed
> after boot, the ones freed during boot stay on the list.
>
> Fixes: 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel page tables")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> Link: https://lore.kernel.org/20260924064321.23787-1-mikhail.v.gavrilov@gmail.com
> ---
> v2:
>  - Keep the table on the list and only skip scheduling the work while
>    booting, instead of freeing it directly (David Hildenbrand)
>  - Say that 9e4a3ec3411b is correct in itself and only exposes the
>    problem (Lorenzo Stoakes)
> v1: https://lore.kernel.org/20260924064321.23787-1-mikhail.v.gavrilov@gmail.com
>
> Tested on a Ryzen 9 7950X with a Radeon RX 7900 XTX, lockdep and KASAN
> enabled, on 7.3-rc4 (fe2ec83746e5) with the same unrelated local
> changes as noted for v1, booting with
>
>   ftrace=function ftrace_filter=pud_free_pmd_page,pagetable_free_kernel,kernel_pgtable_work_func
>
> The boot that panicked without the fix completes.  The table freed
> while the tracer installs itself does not show up in the trace, since
> the tracer is not live yet at that point, but the first kernel page
> table freed after boot does: systemd-modules-load freeing one from
> __cpa_collapse_large_pages() schedules the work, and
> kernel_pgtable_work_func() runs 0.8 ms later and drains the list.  From
> then on every pagetable_free_kernel() in the trace (660 entries, none
> lost) is followed by a work run within a few milliseconds.  So on this
> box the early tables wait until the first module is loaded, and no
> separate drain is needed.
>
>  mm/pgtable-generic.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index b91b1a98029c..f7f504f57914 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -444,6 +444,12 @@ void pagetable_free_kernel(struct ptdesc *pt)
>  	list_add(&pt->pt_list, &kernel_pgtable_work.list);
>  	spin_unlock(&kernel_pgtable_work.lock);
>
> -	schedule_work(&kernel_pgtable_work.work);
> +	/*
> +	 * The workqueue may not exist yet while the system is booting.
> +	 * The next kernel page table freed after boot schedules the work,
> +	 * which then frees this one as well.
> +	 */
> +	if (system_state != SYSTEM_BOOTING)
> +		schedule_work(&kernel_pgtable_work.work);
>  }
>  #endif
> --
> 2.55.0
>

Maybe we want to ensure the drain? Like below:

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index f3754cefb19e..67f286169632 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -457,12 +457,29 @@ static void kernel_pgtable_work_func(struct work_struct *work)
 		__pagetable_free(pt);
 }

+static void schedule_kernel_pgtable_free(void)
+{
+	schedule_work(&kernel_pgtable_work.work);
+}
+
 void pagetable_free_kernel(struct ptdesc *pt)
 {
 	spin_lock(&kernel_pgtable_work.lock);
 	list_add(&pt->pt_list, &kernel_pgtable_work.list);
 	spin_unlock(&kernel_pgtable_work.lock);

-	schedule_work(&kernel_pgtable_work.work);
+	/* No workqueues exist yet. */
+	if (system_state != SYSTEM_BOOTING)
+		schedule_kernel_pgtable_free();
 }
+
+static int kernel_pgtable_drain_early(void)
+{
+	/* Drain any early kernel page table frees. */
+	schedule_kernel_pgtable_free();
+	return 0;
+}
+
+core_initcall(kernel_pgtable_drain_early);
+
 #endif

--
Cheers, Lorenzo

