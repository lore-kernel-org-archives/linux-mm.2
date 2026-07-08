Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23ADAC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7346B008C; Wed,  8 Jul 2026 03:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C8B6B0092; Wed,  8 Jul 2026 03:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDAC86B0095; Wed,  8 Jul 2026 03:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BAA3E6B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:46:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47BE51A0665
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:46:54 +0000 (UTC)
X-FDA: 84964827948.23.4E43D5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9985040007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:46:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eea4Ujqz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783496812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=neDS02cfQQVbwWO1slKZu1V0NB0VTVrZbXTSCvVa/Kc=;
	b=Xyr3ua/caRwElEsVFR+WU8cSoYA5JIqFJZ0WFO4vRdCyEjXJuBLU87E4Bs1DIUibBiF4LC
	nc8baDjQCPLsGoMXgLVq3508GFRKYR0ljQkLClroi8HXeXI3++InIX9Z/lOesx/i7iZm+3
	QoKeKKAkG76ouR/9KMjKPjstCphCxiM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eea4Ujqz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783496812;
	b=fPj14oBflYI9FXuEP/IWSVcp0sQPSXzNFr3ZqkAKpACGHHw3AIyRlisXspdAvDGMZnr7mg
	eiDYoMDcGuVSOxAL0nsLBn1WA5I9kwa4wZSb0V2Y4kqn/02yoQAQiy6I4c2EDdcH4pQAB2
	aCGGkyiz3HgIAF+yyBeOLuG6AO9NbZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD05340E21;
	Wed,  8 Jul 2026 07:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66DD1F000E9;
	Wed,  8 Jul 2026 07:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783496811;
	bh=neDS02cfQQVbwWO1slKZu1V0NB0VTVrZbXTSCvVa/Kc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eea4Ujqz62FT0vySYF9NSerT3eNneByUh/zKAeLpIGg4Giepjmq9LwSzCfe6pI7qg
	 t5/s4JlSgEOLi80un2HKW38j+1E+FgpoT47E6KaSAvGc7r9e4vHqNxZbgSTmc3N9sv
	 sXNxZJfRXPJf0JKot1UJgMa2c8WHnIFd7vunEKRf3bzpMJdv/SIbyJSivwKrY8aoEi
	 xrNOfxWTWt0lUjB7a0L0lNUYbQbCwmZ1X1oTyPSB+uXLQDnLmaWgTreYIxFc2SCY4r
	 e2hp8QV9mvBJMcf5MtCZjcWi1nO5gDjdz7/sXDF9dh9/gTutMr7owKEG5uAhHVcWYN
	 l4nN4l3c5wWkA==
Date: Wed, 8 Jul 2026 08:46:30 +0100
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
Subject: Re: [PATCH v3 05/26] genirq/irqdesc: Annotate static information
 into meminspect
Message-ID: <ak3_cfHe8fkNfyud@lucifer>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
 <20260708-meminspect-v3-v3-5-7aa5a0a74d5c@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708-meminspect-v3-v3-5-7aa5a0a74d5c@oss.qualcomm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9985040007
X-Stat-Signature: kpgzmwp698bgkgd1xm4e6zejtb35tcau
X-HE-Tag: 1783496812-108868
X-HE-Meta: U2FsdGVkX1+D9Fod4h7YTJHM1l5AaAT44Oc2BR+pvyUQqjrub1JXwyu3ReByCVx7yZh9K4FZ6sKLGzTIzoJqUXLIwT2zLtWN0OedzQEV7l8WeSOWPNDV5sCU6TeTzir1YQOGRBtMcSC9c9/rOAIyVc2udEwlp5cwi2NBxnRYGpO8W9ji9Tu/7HcsseoSWaNvOKIvFsIlyaFpO1ZurQjAP+NJ1Mjg16ZUnA78mtWtRVQiBf5uDF+loCGkLD0pwR9UNa786jga1h1B/wZUvyJKq16J5F20ErnouxXVKH0ewZDYqCdpdi9il2co6rmo6tcL/PebGdn4JzEx2Sgz+a2WJ29aBbGvi68BETvzitbTkJxh1VDPFXAf6ckhE1Tp34BTsUjT2iJfHe++UnKx48ijUqYRVlUMatvAM9gt9ub0I3NtJHH3rDvi+oQZQLixpNUohEBoxoEnuVJOC7QT+wE804+bSmBjrP3ZXbMfGWtPnhf+hj1wWNRmlXoiG5V5DcVtr5QBvtvp91NVcope0IZ69rlfT5znjGQ+QzZLXTRN35try4Zm8rvwxTk8Pqbbb8mIpkiikmyuQH9Ng/swVz+q3665tCjiwjqAqc4xF8niQPjESoQ56eIEloX/jEmBbmIkPYb+ywZhgRhKA98hQG8W8HLifQC71e3t3xycYjmViz9582IW9pMX4wT1W2AhnARJflP2pF6I4UiIHb3l6EznvM5N2oFrRVEsMvqxyjkZUj3qnQ7iUQ5vhvh0Z1LCe36tp/yU7K14U093qiS2uRaOzanSEZazMPfOcULmtwC1jhKD19uI3yeg6tOk6bKxLMy1wKEtoBdRXQunf90lj39DQ6yMhtHG7rG82457hBQ6IQVeasHs+b04rKRHlz9FT5G6+gp8hIrzCWjfxxSHd9JQN7uylY+FvOBFNN4YOz6Fwps5wZBnmQZ1dTLJZerLRznuYM6pD6E4JHDELR4WLh6
 lFLXlYmY
 GcR14YNkcMylWZSxxMhUT03J2HJL5UbIWIz9RbvG8VzIO6VyiN1lC575lpIhwgVQLDkhfYmnsisoLxbhBdXMnw8hLZ0UgWskorTVW2TNltIkbeKEOKMRRtxNR2oTJ/P5+RRbPj0Rnb8TnV/Z06Ef6X/yI8AhARbLs6OG+1Hr/NiKk7sbProreUkS9wjOtRANYpVFwpRenCIMkUj6myS2Muu8M75QGDv8KAuhkdzLBp9XOLPfD8oGT2Us1VUAd2e0qsSPJZ14N/qIuGScC9pLQwhvmDXgx4jku1qjqo/9hBARbClcQ3G1dF3P0Y5AM/tb34Enl/Yr/QAJY0B8XmbkTH++zlaS1knfYXAoyPJnRhudrDIxMPguhR4UubedtM/v9WNXYufyHldewGaGVZ3zLrs4kAHCxfrHzDMFfQ8JLA8a5neg7/X8FvSzWY9vGT5VcXIE5hUPWNdfLsuzb/XnMrnTCdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 11:01:44AM +0530, Mukesh Ojha wrote:
> From: Eugen Hristev <ehristev@kernel.org>
>
> Annotate vital static information into inspection table:
>  - total_nr_irqs
>
> Information on these annotated variables is stored in a dedicated
> meminspect section.
>
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> ---
>  kernel/irq/irqdesc.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
> index 80ef4e27dcf4..4e58e7f5fc6c 100644
> --- a/kernel/irq/irqdesc.c
> +++ b/kernel/irq/irqdesc.c
> @@ -16,6 +16,7 @@
>  #include <linux/irqdomain.h>
>  #include <linux/sysfs.h>
>  #include <linux/string_choices.h>
> +#include <linux/meminspect.h>
>
>  #include "internals.h"
>
> @@ -142,6 +143,7 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node,
>  }
>
>  unsigned int total_nr_irqs __read_mostly = NR_IRQS;
> +MEMINSPECT_SIMPLE_ENTRY(total_nr_irqs);

Err... this is effectively exporting this unexported variable to drivers?

This is massively open to abuse no? A driver could now manipulate this value if
it wanted to?

Why would we want internal state like this exposed to drivers/firmware? This
isn't something you can even do right now without kernel debug symbols.

I am getting ever more convinced that this resembles a backdoor EXPORT_SYMBOLS()
but now much worse because you get a VA and a PA and more information...!

>
>  /**
>   * irq_get_nr_irqs() - Number of interrupts supported by the system.
>
> --
> 2.53.0
>

Thanks, Lorenzo

