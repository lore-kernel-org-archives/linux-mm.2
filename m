Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAB82FD88DA
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0ED6B0089; Wed, 11 Mar 2026 05:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6EC26B008A; Wed, 11 Mar 2026 05:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950156B008C; Wed, 11 Mar 2026 05:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70B376B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:06:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0CB6D140191
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:06:01 +0000 (UTC)
X-FDA: 84533200122.19.116F353
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6BDEC140005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:05:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OpaMyPfq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773219959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnNyLKmjYEZq2RUQBnjPHjK0TRD3X9R1o76bubZW2qs=;
	b=C+78A6bgk4F3MX+COK1bMpzwYBKPl9U1mt8jkkzJ7ygmkgN3Q3JYgF8DX5FK7Q4bgHGfAw
	wddAHkAKLy28TX7I12w7VyCCDVo5dqCFmNQFHZtRVbCFJD+YMgGZsGKjoK8n9qX0xi1g1q
	rdL2YX+MiKKwkBOrsktDN+S5pyO2Pj0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OpaMyPfq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773219959; a=rsa-sha256;
	cv=none;
	b=kgfHMBXVI0tD7bFLf4DS6qroiOSJS6jmZKQavAaD6vBhHBHnJPpQ7bZeQNj9vVq2PcIZhQ
	JBMBeSTc/MAvCdevVkaamsXQeKHB2Pe8G4oSjAsmSCg+4Iri8wWgxYgxsq7F8zno53Urgf
	rUqkw2CghOGqUUQ3+KFdiTOPjL+zQoI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 244506024D;
	Wed, 11 Mar 2026 09:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F588C4CEF7;
	Wed, 11 Mar 2026 09:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773219957;
	bh=D51Pq/e4LwlQGDMBcJS01g9zdaJBXlcZ+FyspkYyjeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OpaMyPfq5NJaxf+QkDm+yAtMK9kTWUJspfstygKAnF36YOzTZ2jWyATAqtQgBLBOM
	 X7EOY4g5cKeILwzeLPh05VN39Ui0Tl0XRCyhPtPKF+XRDBvG3uGRxL3geoxNA01KsV
	 ofaXr1sB2KM6GdSqJGVEzXwom3ewd9AWlWCw76//1vFUck3bpY/jDA2Z3TJeAS0wct
	 x7wrFcLwQUXjxKKLVQojnFj42oKnR7IDX+XtyjJleVSLWbpk5XV9qItG3s7hMIzEUc
	 chvYt7DQKjUQu3mfmM6HFrP1S1qSI/69qT/hoP0l27gPIQJeHYnZR5m2vfxMrlSCKn
	 nz/28x/sq+9yA==
Date: Wed, 11 Mar 2026 10:05:55 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Eugen Hristev <eugen.hristev@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Petr Mladek <pmladek@suse.com>, John Ogness <john.ogness@linutronix.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-arm-msm@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 24/25] dt-bindings: reserved-memory: Add Google Kinfo
 Pixel reserved memory
Message-ID: <20260311-light-terrestrial-bison-d9cd97@quoll>
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
 <20260311-minidump-v2-v2-24-f91cedc6f99e@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260311-minidump-v2-v2-24-f91cedc6f99e@oss.qualcomm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6BDEC140005
X-Stat-Signature: cisurcza1n9jg3n774ma54gsd1nzr3on
X-Rspam-User: 
X-HE-Tag: 1773219959-339978
X-HE-Meta: U2FsdGVkX1+V5Fs+yCFP0JVpmjuoUsDD46LGte6BR5Qk6MN1hOiH88LemhfF1k2LWBpvG0Tfcci0l5irHP23qcXltAc8ZpDwADxN/dskqf+FYAFMMr4l4Yaxf+FrwyqB7jlhCNKEFejNWt/ZeNr0+qWEOI8786erZSi2ufpgWVHEy0uPyRNBCTWQYao8urVZOaryMyvI/VrHjpcSpFygDNNwD/6t9/iiBU/YGBwo+ODXvRQZxq+AMZxUAtBb3Y3Wqw1JmWUKFidaEVwQwr25nZUBWJx3s54kx4uPQBviXSJsOg6AvTRDLMFg20iNzQ21g3wtg0ic8seeYFlVXLoTeltmOB6nB83SnDxipUB8V9vXvjgdFzIW5hMmbZ20QMiO+fVtoB+jB8fV4ZyvoBN1k+zP446WtIydDTfdF6I2o+9AOoy2pAm0YpVQz99tFgULYAzn8zL6jpzbVv08B6AEW3x+spOE1/dZ2T9xQf4xpASTsSnqSwjnKH0pPUTd+s5y3oS3prnEnkDLNeptxn1AudIw9Y0PImpfU7OjaZhVyZtW9Y1eCrH7w4ebRan8d0gI3kVgzXHMtSMCRvdw1IMuPJdpp3T7tz8BSUIbk8TCNLDyU4AA4rbvQohjkwYxHC6xwlb4rL4FJLUrlWfVkLQQY9F07HH14xaeeO/C8c0nPE42POUrArnj7ll40pS7rWN0nAY8jsuL1asNQBL64dSTiGt9dtxw53jf8poR6Rqxdte6aSszH2AELeLbObC7EAKu90Blxu5VtjJP6ws2iFqrh9TK8I6T2+FAhkm+vs2MAD13xpvzs8r3NOCg7YB0pcebdHamdp/Uc4LNr1Fa1/n+dIdJmuyGNyrMjDjIOSOPCE6GH2TDFRaB69XQHqGeHXpHKST/RjuR5UECcuFw2/IeJIHerVEWDWg774Rock69XWEFb3PjGnKn4rEejIF8BCFZJCO7oa5EGeO2ZyONmgn
 WqQi3Ugf
 YjRseRtcj3tnDJ+m/iylzFLop9sm0v2hGKC4xZZwq1+HLXwGIavVlYKd4xrnuIWKFQ/k8pJPpRuJAoFResPgEzGYf2hpWP5GYuZUA5leEjnDrEUb955xsnQlJTJw27FZVioz3Rwt/Kqw/oXxRinYHpoYUkAjEQrYQXg6orObzRaoqMfb5YxXcNPBI9KnxpZdz3NvJqefVeD+m4PdScrq3C3nS1tJn6F5fJ7rqlCqARZ7N1m4xLb2aQVeqGw/mCtLlsGmiykm5tOf9rgLadNan84T24Acz0pbwKCIX0mF/vD1l/dtHwBJd9mkNsIUnujAUqiAa/6xRDSYiBoYjksxYbZSeWpz9WPF2B6/KJk2RFkIlThCCU27tiNrR2J1KSLGkIDDF388d9mmE0UQIFIY4crg+iqvjo4p67/2NWGgHtAgs/zkeYRCYNXz0ua/Dx0MrMr2vBMwZKkVVH4543uM6YtMrdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 01:46:08AM +0530, Mukesh Ojha wrote:
> Add documentation for Google Kinfo Pixel reserved memory area.
> 
> Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> ---
>  .../bindings/reserved-memory/google,kinfo.yaml     | 46 ++++++++++++++++++++++
>  MAINTAINERS                                        |  6 +++
>  2 files changed, 52 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml b/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
> new file mode 100644
> index 000000000000..2f964151f0c0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml

Nothing improved, read previous feedback.

> @@ -0,0 +1,46 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/reserved-memory/google,kinfo.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Google Pixel Kinfo reserved memory
> +
> +maintainers:
> +  - Eugen Hristev <eugen.hristev@linaro.org>
> +  - Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> +
> +description: |

Do not need '|' unless you need to preserve formatting.

> +  This binding represents reserved-memory used to store data for firmware/bootloader

Nothing improved.

> +  on the Pixel platform. The stored data is debugging information of the running
> +  kernel.
> +
> +allOf:
> +  - $ref: reserved-memory.yaml
> +
> +properties:
> +  compatible:
> +    const: google,debug-kinfo
> +
> +  reg:
> +    description: page-aligned region of memory containing debugging data of running kernel

Missing constraints.

Please wrap code according to the preferred limit expressed in Kernel
coding style (checkpatch is not a coding style description, but only a
tool).  However don't wrap blindly (see Kernel coding style).

Best regards,
Krzysztof


