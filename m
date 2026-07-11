Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB702C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 15:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48DB6B0005; Sat, 11 Jul 2026 11:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8C66B0088; Sat, 11 Jul 2026 11:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C636B008A; Sat, 11 Jul 2026 11:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EC986B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 11:44:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9083120791
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 15:44:02 +0000 (UTC)
X-FDA: 84976916724.20.DF8FF36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3A06B1C0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 15:44:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZIAqARcK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783784641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Hx51w8dFEncFI58huRfM4bO4YcYrbYiW5us+lxhCn0=;
	b=HdjJoYoqQbDin0UgItcQIyu5i0OeHzpZ8ET1mzeiOmGaWH+mCOF1lalRiSHU4wAsPMA7c0
	V7fbiG2jax4/Nh5oR0V8ashFdylANoBMHzoApLkuarTfSLbyqrJUf4gcx37qYDV9X6NkA0
	TILmHF5KXGqZ1OJQ6yKN0PqPetVsN4k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZIAqARcK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783784641;
	b=w931Phq1FS5r1oLD20E8hXQqIqpmYPcwvBb3Jvqe7dAY323JQ99PS4hSs2UVV3wVSlyv4c
	xPNOZsAW+hWKRHjDnMp1Hm+e/+TjHkeMZfgjmqyRI+dkviTezUtYqtADTjdQ0CDnpfSiiQ
	Jk+nTsQd0lvBlGjl656LIKVrXzSIOQw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 177CF42DEB;
	Sat, 11 Jul 2026 15:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C6E1F000E9;
	Sat, 11 Jul 2026 15:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783784639;
	bh=+Hx51w8dFEncFI58huRfM4bO4YcYrbYiW5us+lxhCn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZIAqARcKP8hujblE64oSTCkc0UZEMo26D7eVRtr0xDhcXILGxalvRvFmMtdghf/bI
	 q7qQctgHJCL6WCDEnzfZDVOe0Aectw75OQfsY1G5tto5Q0WSLIy0Frl6snpWxroSwy
	 Swdl/NBz6s0ZYnNMaB8U5aDNYLrOouKqs+25wP14l7jNzBb3xWc/37FYla9s3u4MAZ
	 g7PRUdo+J80jx0RVD8zD8zo44CNIR3crgyrCUDjCQsEMxzt/PBhDbBoNShaK1xBH/9
	 DWdmt+dD+oobnlbRjWzj0rOnAtXSOlOmDsBsDGjFIetPZEjlaem3yegxLO9pjx4qXk
	 5e/HWkVwggiMg==
Date: Sat, 11 Jul 2026 17:43:56 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
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
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Petr Mladek <pmladek@suse.com>, John Ogness <john.ogness@linutronix.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-arm-msm@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 25/26] dt-bindings: reserved-memory: Add Google Kinfo
 Pixel reserved memory
Message-ID: <20260711-tested-elite-dingo-93efc8@quoll>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
 <20260708-meminspect-v3-v3-25-7aa5a0a74d5c@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260708-meminspect-v3-v3-25-7aa5a0a74d5c@oss.qualcomm.com>
X-Stat-Signature: e7m1exmnwk5ikq69mmkggmu6ws48ermf
X-Rspamd-Queue-Id: 3A06B1C0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783784641-475352
X-HE-Meta: U2FsdGVkX1/53lhChqmD9WdznwktCKhmQYaj4AMiBT5oy2CPv8ouX/h8IenKyz3V1FWBJBKXGRFNMigQZ/CRp0vnMPLKAbLval8P6WHs5sG8eddR98/AmCbLWS/xDhVrt0ao2fC9g2lm32dHoznSJXmPK6Rh1NzEIqeY2ffxIJI6rDaiMMyIC3P+SLlBfiOXogHBi1tMkM/SKLBU25UZfpgxKOsRVPmMHGurV1Gvn7NtRR/7k2nmuJosgE6OSpRd1CvtN3XaaJdAycw9qMlUShqtv8aaupBu5E8BU4Mc9RbcEoYSLQal51Fa0Qoc/x5QpQqMKUnweh7zLMPIj0eJijFkuXnpU4XYkOxgUyk7Mvn5QvswEHj8VoUHnbKoAv03i7yi1YmPdeA17WHiMKQyiw1AM84GaIe21p8epshFK10j0ox40GCC9Ez1tPkTfov4gkJEIJVg9awXmPnaQvF+P8RDdAsoUrJN9PPJCpSppMAvjPJV8MMEmlO5dKZrxaZot99vbRI/sVKwX/pGo3RG55jdiXAixg0FcWfms93NJqdcfychjt+uONAwI/Uz0PbbMsFfn6JCQ9UzSY5rDVRv4sFS17Vf+CGJsw5VrvFonlnqmiamAzYvNihioS0gtnC1NAm9dFdpIIyZYuppxAsfClvsoFtPvy1S3UOXWsm17VAvrpmKWv+4MtBmEbCoNbRIE1/27SNS8I0/tFQ1XVTNthGKO3z881WrFXlLthjhne3EqLOVi3qB0EsMNgjKL/eaw/MmVSZ8s2PT6pxEkOeMlT5gIotpcmpznR31BT09Y4Lnp1FPeraYBZ3PvnAbR/dBJVTVtBnHSaSW17zo4lAsbuVluC/6cOsJe74twLOyLWSGiNTHQ5xNjxpwvPLSBqIp1io/82xHjxDXNpwICajR7/h8btpsIlwXrCjSKP9m2TskoiZ2q6IaAq8CXIOcTYHd1jbyTHo+UkkTzpDS2TK
 eIx3ufzX
 RoEMyIk/aZq5w7++2Yb6Egk/XF0rygJRO46aSJcaXn2mCuBWJ0V/ZtKlvFEbvGTLMo/9D50/CbvvmFFquhC+/W9ZEza3N/cgGoGr1Hg0uz3CozRGeS5kJGtbSmLR3Ztgto+ypzZWZdRgxjgIB8cuj5rz+99IYAIZ3w/7NUqzMEEGmN7w9X5vBGQTaS5d4ZdHTLGRTne2f1jlxv0LGOusmTBN3R3LSWJ3YwXZNeeuETUc8Isd56vASXl1Nr8ouQZb4n/1ofLeNxmbzdDhLUukxsm8FRo9hja8O9Y40YdZLepLMDIBfP2jx2Tg6HZZyTFBl5nsSZIMEpyyhTVRJJsK8ZYJIEIZXX2UYX9fAwmCvhX94vM7r5ZhnRMDKyXvD3UMFlseHONbL8KMM7zxbNTrhUVuWyOmzJmuIAEaFXamldqKVsADgY/SGT9xQMjxlFkuMsoWq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 11:02:04AM +0530, Mukesh Ojha wrote:
> +maintainers:
> +  - Eugen Hristev <eugen.hristev@linaro.org>
> +  - Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> +
> +description:
> +  Reserved memory region for storing kernel debugging information that
> +  can be read by firmware and bootloader on Google Pixel platforms.
> +
> +allOf:
> +  - $ref: reserved-memory.yaml
> +
> +properties:
> +  compatible:
> +    const: google,debug-kinfo

I guess: google,pixel-debug-kinfo

Or maybe even specific SoC. Both title and description suggest this does
not apply to other Google devices (makes sense), so compatible should be
somehow more specific, unless debug-kinfo is already enough to identify
possible users and there is no conflict with debug-kinfo in Chromebooks,
for example?

Best regards,
Krzysztof


