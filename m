Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63B81CA0EE8
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 13:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937B18E0003; Sun, 14 Sep 2025 09:53:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90FDC8E0001; Sun, 14 Sep 2025 09:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 825378E0003; Sun, 14 Sep 2025 09:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB2F8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 09:53:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EED0513A967
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 13:53:02 +0000 (UTC)
X-FDA: 83887997004.27.B45A967
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 24411160004
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 13:53:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bECoVG1z;
	spf=pass (imf08.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757857981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLpgwUf4fony2ahEU7jyRp8ERtRjVojzKUczuwKwKWM=;
	b=qOjTDBl7O62XL0O4LICJNwY3xDyK+rzMaI/959ONc6M5q+e8bq78paMJ7lsgsoF9O6Tq+7
	us0y+3DMaXd5JOc4fgf7YuJf6TAAIG/Zz+6dwc0iFogkUD2p7ip9ObBPMQ/3IFKXgxybdx
	5cNkWXu1/CijLBlztkMIfg9ja3+/flo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bECoVG1z;
	spf=pass (imf08.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757857981; a=rsa-sha256;
	cv=none;
	b=TX+tN3jEqqskOJZZjVIOHWOtum0vjPG3JFEZjG2yLVqGv7PkfbTFFbPirNg3GotUsFaM45
	UAIGzXNvAnXxKPRAAqkoIDEuahG/3wBkUeIxpCYsNibaib+iQxPihzPmSQA9mhCOcPrxMy
	D05sO64GPTZj54BVlu8tDrXizCP3E18=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7384B4058B;
	Sun, 14 Sep 2025 13:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA19C4CEF0;
	Sun, 14 Sep 2025 13:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757857979;
	bh=37L/puyV0GzSe9BaFG26DDCjfs3MDxprvSq5MtRjnW0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bECoVG1zEMs+vWcw9+n+EsirVXp9fVwqwBw8pr1cnMHuKwtnpguud39cSqncKvSlM
	 5P9AiNSsWL0BS2rssgcNDHMdNOGjVL8INd/wucFte+qZQ7R2QOJ60Vem2/J0HBJRJ2
	 5uTK5KpwKceGpShpNyBM7I/EnLOKtJ4xmivDiE02IDf0PulJ0Je+Cn55zNvLvbdq8m
	 hQPJym74sUDYZL9SHdiuuXHEpfjdiBB3h2M5apKhi/dFDQog4u9Z0B0UMfkxrPjpuo
	 PzYNu+Q6q9N1EXXBzeVSfXGGbGDe31fYxRBO6+PjM23P+lNTUjX9ZAkT3i6TqMCK0c
	 GtI8DNHL7jraw==
Date: Sun, 14 Sep 2025 22:52:42 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra
 <peterz@infradead.org>, Mike Rapoport <rppt@kernel.org>, Alexander
 Potapenko <glider@google.com>, Jonathan Corbet <corbet@lwn.net>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
 <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
 "Liang, Kan" <kan.liang@linux.intel.com>, David Hildenbrand
 <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, Justin
 Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Sami Tolvanen <samitolvanen@google.com>, Miguel
 Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, Rong Xu
 <xur@google.com>, Naveen N Rao <naveen@kernel.org>, David Kaplan
 <david.kaplan@amd.com>, Andrii Nakryiko <andrii@kernel.org>, Jinjie Ruan
 <ruanjinjie@huawei.com>, Nam Cao <namcao@linutronix.de>,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-mm@kvack.org, llvm@lists.linux.dev, Andrey Ryabinin
 <ryabinin.a.a@gmail.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry
 Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>,
 kasan-dev@googlegroups.com, "David S. Miller" <davem@davemloft.net>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/21] x86/hw_breakpoint: Unify breakpoint
 install/uninstall
Message-Id: <20250914225242.b289de4a30557fec718b8cc8@kernel.org>
In-Reply-To: <20250912101145.465708-2-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
	<20250912101145.465708-2-wangjinchao600@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 24411160004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: nmoodg9xrry3yszbfsnuznsroftahsua
X-HE-Tag: 1757857980-700417
X-HE-Meta: U2FsdGVkX1/ySNGqdNiI11tlhIv7nrQp/6Fme9M2+ES02ssacyDIDvzZeTik60j6r4L51aBIeuA6otaKSxOhtX+4HdsxNbUG/Srmz883uDr/mtCYKE7Azm9mP9qi3/6nhuDwfYyBh4FicEFP9yAVgkRpVPFoeVDDhELOZd0ESf5xQ9hQ7UZQdqIhthSeLYJ9tfbiWfIevhzIQ8NQFDagLoQbHSDIxcmShF8ETCMoHwVLmYe3PWakh2LANlRSJFIDeSVnFHCehT5skheDy/mvCW4uvRMj0wmU3Vsbl3NrS4N1EcljqogbVcq4T/YJkCqLh8tfLdAPDsqFWRDx40Tcr/n09ffRRBvrsEHOKL93rhMvT6YcWa0ouwjn/SWyt6J4rtuOj83PMtnrJXknsgs/wt9BWeeWM1ybJ+pDFezyTsIhWL9/3swfjJStnsWC8qmiI7Um+SPwnOFT3crWeOJ9n4yWaTZvxYQSYYrDmqih+UrZgEKEkSOvJ9j4S1e0pBlomgpJdSiEOhml4/MBpEH73csMy5oynNO7Ia2miyMX5pLz+ALK6McxB4pg8liQGqVXA7+DPj2d8QpNV8c9fj5zrteQ74vHOtCEN1vI7DmzEn3vMiyw62hMdi1fQn9efOk9YcAbpaSKU+DlWubahM6IVOmKf7aHyy3rUXMSihipcC39uY+4rPITprzwrcAFIRJqNNl2c324RLB7nAPL6vhwKvKgTpSMlqAtbteYM9d7JFNkm9coe3+ggIydpkKxp82HoiA5qIu/SZ4HF22upnMl1TUhMSiIdNdALWb05hDIA7qzalEjFonu8NRm6WZ4ILNKPenrYCKjl12uC1CcVLAxrf2cpU8KKSztU4RpFo416+Q7L7c9yFORJo98rL9CN/e84OI89Q/xZ7LomFKuSZxDPPniBZi0hVJpeLlKmhIEj5NpNRnXAJUngwsKRpX6IcgAXi1jAnGdzH+kVPw6eL7
 Cf7jBiZE
 Jz/dY0drt2hbTQw23gv7NfsR3bbTfN1AVDxNn3s9urdbBdSTU0KNJXD7XirGVV02u8o/HJhrIFqybIELz7tmNg8GsZlNlsOdgGX6Y/WEYmf7pYlB01nBZfLGasJ1XecR6u+EZVMTDo5Tbw6Q8REbJyfhga30JRrq+RUXpJeHS1nqWZBijkCKUrTAhBhVlOLVE/sGQb4/Zbqxo2ak9ITjX3WpXU0UCNy+QY+GLjteN5l13irOrRcSQ8r+C8JRDCCRaDlxKwsWJTr68I39npBSFC5iJ3S3SK6eiFNWWxxyc8+qpNAlicLf0dYVyUOE6+UyNvNjFd0BMJMSWHiIgSECAmlSyYZ3918pEC9N9JVimKtLHwoJW4OBAxjzMtL1tTVxXMoc+OrBrhIJu3Yo45FhAlnrnknK4Z2nYQ7Ob
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Sep 2025 18:11:11 +0800
Jinchao Wang <wangjinchao600@gmail.com> wrote:

> Consolidate breakpoint management to reduce code duplication.
> The diffstat was misleading, so the stripped code size is compared instead.
> After refactoring, it is reduced from 11976 bytes to 11448 bytes on my
> x86_64 system built with clang.
> 
> This also makes it easier to introduce arch_reinstall_hw_breakpoint().
> 
> In addition, including linux/types.h to fix a missing build dependency.
> 

Looks good to me.

Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks,

> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---
>  arch/x86/include/asm/hw_breakpoint.h |   6 ++
>  arch/x86/kernel/hw_breakpoint.c      | 141 +++++++++++++++------------
>  2 files changed, 84 insertions(+), 63 deletions(-)
> 
> diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
> index 0bc931cd0698..aa6adac6c3a2 100644
> --- a/arch/x86/include/asm/hw_breakpoint.h
> +++ b/arch/x86/include/asm/hw_breakpoint.h
> @@ -5,6 +5,7 @@
>  #include <uapi/asm/hw_breakpoint.h>
>  
>  #define	__ARCH_HW_BREAKPOINT_H
> +#include <linux/types.h>
>  
>  /*
>   * The name should probably be something dealt in
> @@ -18,6 +19,11 @@ struct arch_hw_breakpoint {
>  	u8		type;
>  };
>  
> +enum bp_slot_action {
> +	BP_SLOT_ACTION_INSTALL,
> +	BP_SLOT_ACTION_UNINSTALL,
> +};
> +
>  #include <linux/kdebug.h>
>  #include <linux/percpu.h>
>  #include <linux/list.h>
> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> index b01644c949b2..3658ace4bd8d 100644
> --- a/arch/x86/kernel/hw_breakpoint.c
> +++ b/arch/x86/kernel/hw_breakpoint.c
> @@ -48,7 +48,6 @@ static DEFINE_PER_CPU(unsigned long, cpu_debugreg[HBP_NUM]);
>   */
>  static DEFINE_PER_CPU(struct perf_event *, bp_per_reg[HBP_NUM]);
>  
> -
>  static inline unsigned long
>  __encode_dr7(int drnum, unsigned int len, unsigned int type)
>  {
> @@ -85,96 +84,112 @@ int decode_dr7(unsigned long dr7, int bpnum, unsigned *len, unsigned *type)
>  }
>  
>  /*
> - * Install a perf counter breakpoint.
> - *
> - * We seek a free debug address register and use it for this
> - * breakpoint. Eventually we enable it in the debug control register.
> - *
> - * Atomic: we hold the counter->ctx->lock and we only handle variables
> - * and registers local to this cpu.
> + * We seek a slot and change it or keep it based on the action.
> + * Returns slot number on success, negative error on failure.
> + * Must be called with IRQs disabled.
>   */
> -int arch_install_hw_breakpoint(struct perf_event *bp)
> +static int manage_bp_slot(struct perf_event *bp, enum bp_slot_action action)
>  {
> -	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
> -	unsigned long *dr7;
> -	int i;
> -
> -	lockdep_assert_irqs_disabled();
> +	struct perf_event *old_bp;
> +	struct perf_event *new_bp;
> +	int slot;
> +
> +	switch (action) {
> +	case BP_SLOT_ACTION_INSTALL:
> +		old_bp = NULL;
> +		new_bp = bp;
> +		break;
> +	case BP_SLOT_ACTION_UNINSTALL:
> +		old_bp = bp;
> +		new_bp = NULL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
>  
> -	for (i = 0; i < HBP_NUM; i++) {
> -		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
> +	for (slot = 0; slot < HBP_NUM; slot++) {
> +		struct perf_event **curr = this_cpu_ptr(&bp_per_reg[slot]);
>  
> -		if (!*slot) {
> -			*slot = bp;
> -			break;
> +		if (*curr == old_bp) {
> +			*curr = new_bp;
> +			return slot;
>  		}
>  	}
>  
> -	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
> -		return -EBUSY;
> +	if (old_bp) {
> +		WARN_ONCE(1, "Can't find matching breakpoint slot");
> +		return -EINVAL;
> +	}
> +
> +	WARN_ONCE(1, "No free breakpoint slots");
> +	return -EBUSY;
> +}
> +
> +static void setup_hwbp(struct arch_hw_breakpoint *info, int slot, bool enable)
> +{
> +	unsigned long dr7;
>  
> -	set_debugreg(info->address, i);
> -	__this_cpu_write(cpu_debugreg[i], info->address);
> +	set_debugreg(info->address, slot);
> +	__this_cpu_write(cpu_debugreg[slot], info->address);
>  
> -	dr7 = this_cpu_ptr(&cpu_dr7);
> -	*dr7 |= encode_dr7(i, info->len, info->type);
> +	dr7 = this_cpu_read(cpu_dr7);
> +	if (enable)
> +		dr7 |= encode_dr7(slot, info->len, info->type);
> +	else
> +		dr7 &= ~__encode_dr7(slot, info->len, info->type);
>  
>  	/*
> -	 * Ensure we first write cpu_dr7 before we set the DR7 register.
> -	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
> +	 * Enabling:
> +	 *   Ensure we first write cpu_dr7 before we set the DR7 register.
> +	 *   This ensures an NMI never see cpu_dr7 0 when DR7 is not.
>  	 */
> +	if (enable)
> +		this_cpu_write(cpu_dr7, dr7);
> +
>  	barrier();
>  
> -	set_debugreg(*dr7, 7);
> +	set_debugreg(dr7, 7);
> +
>  	if (info->mask)
> -		amd_set_dr_addr_mask(info->mask, i);
> +		amd_set_dr_addr_mask(enable ? info->mask : 0, slot);
>  
> -	return 0;
> +	/*
> +	 * Disabling:
> +	 *   Ensure the write to cpu_dr7 is after we've set the DR7 register.
> +	 *   This ensures an NMI never see cpu_dr7 0 when DR7 is not.
> +	 */
> +	if (!enable)
> +		this_cpu_write(cpu_dr7, dr7);
>  }
>  
>  /*
> - * Uninstall the breakpoint contained in the given counter.
> - *
> - * First we search the debug address register it uses and then we disable
> - * it.
> - *
> - * Atomic: we hold the counter->ctx->lock and we only handle variables
> - * and registers local to this cpu.
> + * find suitable breakpoint slot and set it up based on the action
>   */
> -void arch_uninstall_hw_breakpoint(struct perf_event *bp)
> +static int arch_manage_bp(struct perf_event *bp, enum bp_slot_action action)
>  {
> -	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
> -	unsigned long dr7;
> -	int i;
> +	struct arch_hw_breakpoint *info;
> +	int slot;
>  
>  	lockdep_assert_irqs_disabled();
>  
> -	for (i = 0; i < HBP_NUM; i++) {
> -		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
> -
> -		if (*slot == bp) {
> -			*slot = NULL;
> -			break;
> -		}
> -	}
> -
> -	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
> -		return;
> +	slot = manage_bp_slot(bp, action);
> +	if (slot < 0)
> +		return slot;
>  
> -	dr7 = this_cpu_read(cpu_dr7);
> -	dr7 &= ~__encode_dr7(i, info->len, info->type);
> +	info = counter_arch_bp(bp);
> +	setup_hwbp(info, slot, action != BP_SLOT_ACTION_UNINSTALL);
>  
> -	set_debugreg(dr7, 7);
> -	if (info->mask)
> -		amd_set_dr_addr_mask(0, i);
> +	return 0;
> +}
>  
> -	/*
> -	 * Ensure the write to cpu_dr7 is after we've set the DR7 register.
> -	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
> -	 */
> -	barrier();
> +int arch_install_hw_breakpoint(struct perf_event *bp)
> +{
> +	return arch_manage_bp(bp, BP_SLOT_ACTION_INSTALL);
> +}
>  
> -	this_cpu_write(cpu_dr7, dr7);
> +void arch_uninstall_hw_breakpoint(struct perf_event *bp)
> +{
> +	arch_manage_bp(bp, BP_SLOT_ACTION_UNINSTALL);
>  }
>  
>  static int arch_bp_generic_len(int x86_len)
> -- 
> 2.43.0
> 
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

