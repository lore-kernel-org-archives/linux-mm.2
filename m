Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9145AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5458D6B00A3; Wed,  8 Jul 2026 03:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51DDE6B00A7; Wed,  8 Jul 2026 03:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E6B96B00A9; Wed,  8 Jul 2026 03:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEF516B00A3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:59:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69CCB120706
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:59:49 +0000 (UTC)
X-FDA: 84964860498.24.6A4099B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id DA237140005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:59:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cogbiAXK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783497587;
	b=GMa9/ylP5rLdB2ixJl7rOxmJI69p5q4Bay1ZooeBONoA+Yv5AnOvW5PHKoqleQnpKbDWgU
	R/M2GPmtrIbweJzmWKuBYXL2WMbhw/GjwROq4LOlhgmXtr7Bq4o4dxrTHWMFc+CEb6UPKQ
	t2u9kOsshrzeeujvznSVnhCx8G6RC4A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cogbiAXK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783497587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8g8Ttn0kjFhoN2K8SOSf7rP1PCWBsxtWcEWwceV1Cm8=;
	b=foSUfzwtalhxVUnRlwScrlYFLNcktgy7dRxbcBDVbStYIZIy2GYelgoxhWTtCq5hE2ogcq
	pd+AUZrCKKprTkf8s6lXpCOWYvGmVqdW07vRl+e/re4DyAfT21V4SWcv5epTyYAYm/CHKo
	Vi7lgggLFRnWjKdK8XQkcrgg5630fG0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65AAC6001D;
	Wed,  8 Jul 2026 07:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22611F000E9;
	Wed,  8 Jul 2026 07:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783497586;
	bh=8g8Ttn0kjFhoN2K8SOSf7rP1PCWBsxtWcEWwceV1Cm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cogbiAXKmyAMp8pfFGMw1+XH+2/KFQZ2sirJm0MkZ25BfGjdi7K7UkK2mGaisfiBm
	 KuN5ega3YTdU78XA4W+ovM0uk40KtUwj1IQJmdwuQOvmh0MLUniAH2UDpAzGHUZg0P
	 u1fYmNoGSHOAUHdmYneYRgfT/AZFQBTayBEa9v7QKC/NjNK+mp6bmS9UuUV3dYDcI3
	 TkVvcloCp1L2SU5GfdNRvlOhdCjDCV2Q9JdhGctPFX1cA+y3HBjoNVMbHew/PGh6oC
	 sTKjkZqL/4xzF5SYpZ1Wl95LijL6ZH0gEp7MczaplLaen9JfL6pHR73TxoEo+KBbpn
	 Dl5SwOUOzgI6g==
Date: Wed, 8 Jul 2026 08:59:26 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Eugen Hristev <ehristev@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Kees Cook <kees@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Petr Mladek <pmladek@suse.com>, John Ogness <john.ogness@linutronix.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-arm-msm@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 21/26] printk: Register information into meminspect
Message-ID: <ak4Cr5GEMdo8xWqu@lucifer>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
 <20260708-meminspect-v3-v3-21-7aa5a0a74d5c@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708-meminspect-v3-v3-21-7aa5a0a74d5c@oss.qualcomm.com>
X-Rspamd-Queue-Id: DA237140005
X-Rspam-User: 
X-Stat-Signature: afmq3g7gsgcf9y8usen1n1etxa4q1u4s
X-Rspamd-Server: rspam03
X-HE-Tag: 1783497587-839032
X-HE-Meta: U2FsdGVkX1+jWidRjUjKhr11HFaJOVazPHZhuuB7Pz1vo9A5tloruOjIrEzEcP34OELmzWxMRU1GrKCqHYcANV3GkIAR0sluP29H14FNBeb8CWWbYDz6UKgBu6apljA0AuVrDVxpKLLnnJmJs3WahUlFfYzdNIm8JXa19xQI3tBqNCobS9fdftfCLv+xClv2X+94UFdPuZ9BV2K+9MqAtc0CSMjUiSqZ9qEiNKsY8FOupb6bHmRnSmi402ahZV9UHE5KwoHUo07tcj4vJBYqntsvGNY2vu8MUREVqEdcaE9cxXs9NixYaGHDEF2LxrwTFUgkphvayfpHSO8rcN4AbxGUjkb93oQF4vT0TyPt+pw98RVAeaCApFwO3Bpb+EVNnABtv6b7Zp5v3fNlQS0tiOwk4jp1cJ37h5RQ8MFcl88kkygsPDqNmttmaRAEsEI7BPFIIae4egllGv17tWdNAnneY1l9Z/BKCbYqvof1j/lchlAcgRI8FgzzAwneLlYUX6ng0I1WkHgYURXBEYCc5r+3dj4i5xVqHkdh0T5bM4RjQtmAPLD45eQ8Xfi2BhefmwE5rO6wZZP23/2lmDc6aMioVW7Eu9EE/u1Ct2b0KI+/+AKd+tbPGIU/StqOAk6LLybBech0491toeLLNVoaUTejooMTYYRf1TDt5JYLHizAkNwphCOj/NF90/WxyUjfgDq4wAWNQARgq+yWfB13OVSX9Dz0BZfA/rpeQlDmq1p93qW47skfA5be5i1kRBAxioiN6v0JZDfkf7rUr6E8TS+TM6lKjAceXJcqZK7+DKmttGEwR5MsQB+rE7oZsA6G+1kxMaTOOEmvolV1RLecW6EiaFGq1rmBsLnk042IHBUVH8Hrr/lnsmUN1JKkc42WoodBEwKllQkpY0QzOU97eiAsDGe1X+6clf2MS/IOMNPD8skg6jA2j0R5ckRe2iYm8rec3wG2CFYNubzX9jr
 Mh8oVq8/
 MXoypTWC3QNwIznpe4iv6CM2rLw+sN8x+IlW8BhrwchNZtyL9lG606QpMx3jzyP+lFCC2UVBcdPy20wlIVPzDCQ/uN/35oDzJCOLJEzutBONxvoFJxmrlGANiqwkxd09EbZCkXZknFN/gORlq0OihH4it9LV3QymlBvmMn1CJL9Ax96mXo5+/B/6tipWcI9tC2Guk1M1LX4al3GHfGHJzEsj/ZrheTkHEBfoXUhg7+4A/MMwcw1bxpIUczTgSwr82Xe9P1vmwEyjiyBkhPITNuJUtb25ZkkqjOInK9jaSc8fjTOKrDCOQVY+ls3S3C850FE2aXi0CFMNcOYdgZVw9O4pHkYsBqzwrBHxFt4c/BI8UMDVMW5N5aFUhf9bU/agL0YUIYXbtD5IEJ9STkmhUc1HHCqnW1L1Ir72XeZx8E0d62vEDMDgyFbFs6/CD1lleDpyBjOBc/bdt4Z01Rg2Nviqsn58Vog6YE2hBX2p0dEm1piXJdE+dl0oFGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 11:02:00AM +0530, Mukesh Ojha wrote:
> Annotate vital static, dynamic information into meminspect for debugging
>
> Static:
>  - prb_descs
>  - prb_infos
>  - prb
>  - prb_data
>  - clear_seq
>  - printk_rb_static
>  - printk_rb_dynamic
>
> Dynamic:
>  - new_descs
>  - new_infos
>  - new_log_buf
>
> meminspect uses a different API to annotate variables for inspection,
> and information about these variables is stored in the inspection table.

This commit message is a mess again. You're writing what the code does, not why,
you mention separate API but not which or why.

It's useless basically, and it's weird to list arbitrary fields like this.

Always think 'what would be useful to reviewers and people coming back to this
patch in debug/development'.

If it just says what the code says it's useless. Put what's NOT there.

>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> Reviewed-by: John Ogness <john.ogness@linutronix.de>
> Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> ---
>  kernel/printk/printk.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 2fe9a963c823..f7f32c09b9b8 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -49,6 +49,7 @@
>  #include <linux/sched/debug.h>
>  #include <linux/sched/task_stack.h>
>  #include <linux/panic.h>
> +#include <linux/meminspect.h>
>
>  #include <linux/uaccess.h>
>  #include <asm/sections.h>
> @@ -518,10 +519,17 @@ static u32 log_buf_len = __LOG_BUF_LEN;
>  #endif
>  _DEFINE_PRINTKRB(printk_rb_static, CONFIG_LOG_BUF_SHIFT - PRB_AVGBITS,
>  		 PRB_AVGBITS, &__log_buf[0]);
> +MEMINSPECT_NAMED_ENTRY(prb_descs, _printk_rb_static_descs);
> +MEMINSPECT_NAMED_ENTRY(prb_infos, _printk_rb_static_infos);
> +MEMINSPECT_NAMED_ENTRY(prb_data, __log_buf);
> +MEMINSPECT_SIMPLE_ENTRY(printk_rb_static);
>
>  static struct printk_ringbuffer printk_rb_dynamic;
> +MEMINSPECT_SIMPLE_ENTRY(printk_rb_dynamic);
>
>  struct printk_ringbuffer *prb = &printk_rb_static;
> +MEMINSPECT_SIMPLE_ENTRY(prb);
> +MEMINSPECT_SIMPLE_ENTRY(clear_seq);
>
>  /*
>   * We cannot access per-CPU data (e.g. per-CPU flush irq_work) before
> @@ -1238,6 +1246,10 @@ void __init setup_log_buf(int early)
>
>  	local_irq_restore(flags);
>
> +	meminspect_lock_register_va(new_log_buf, new_log_buf_len);
> +	meminspect_lock_register_va(new_descs, new_descs_size);
> +	meminspect_lock_register_va(new_infos, new_infos_size);
> +
>  	/*
>  	 * Copy any remaining messages that might have appeared from
>  	 * NMI context after copying but before switching to the
>
> --
> 2.53.0
>

Overall exposing live dynamic printk information to drivers seems unwise, but
not quite as insane as some of the other stuff thus exposed...

Thanks, Lorenzo

