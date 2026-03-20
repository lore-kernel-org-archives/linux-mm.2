Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F48F109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 951926B042D; Thu, 19 Mar 2026 23:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928CD6B042F; Thu, 19 Mar 2026 23:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866436B0431; Thu, 19 Mar 2026 23:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74C936B042D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:11:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20ED0140856
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:11:02 +0000 (UTC)
X-FDA: 84564964764.24.560807E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 535FD20005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:11:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=z71svX0W;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773976260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsx2towfWilL6iLCd+Hbbd67kMffYO1gq0QffXV1D9A=;
	b=0+LZ1Y5DRW4xdrJyWjDhqnUhhpfIfiTEqbP5d4R/VLOvxocfrR/9vytaLb+Hmfm1GMmkhy
	QGs6/g3NUfJeZi2/wD01AfpYKn1VwIxSOIVuZq0MozcwWCYILtNABIJ8ujKZlvSs0Fjd09
	wNj/4qirM0TbHj5jxoXmcmja+w6CFuo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=z71svX0W;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773976260; a=rsa-sha256;
	cv=none;
	b=VcyqBLaj2AEX5pbHfGCgvFDLkU34QB07xnkhYhssoNRrTvF5tts/dUs0uNm6fh3KldEnDy
	jdwHH4okceDJokvVG+/az+4WdUrejL+QcjTHkuEFR8f69PFds4TyT0GZnFnPxlLgqjNlXV
	LDd6O1bcOGMOdRURpDgRrFN5IqTKyHk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 57EA240BFF;
	Fri, 20 Mar 2026 03:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA4DC19424;
	Fri, 20 Mar 2026 03:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773976259;
	bh=PWVgh1useoiif8rGVsyxHxI0CYpzSQvYe+hudbWgJgk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=z71svX0W9IEG9X0CljZclwmdPxrS2xt0DgkYPV0miyW6uLliBKplyUI9cqLWsAMID
	 HknlgTOQAMOZMIJ0rHvOhVmKRO4JG7rzBzNqhHQadyrhW2vHnOnPmp9Trx7zagjUeA
	 Gp5Uj70ZJr6CbF0U6zE8qTTGLs0kE3eFTNqcLYV0=
Date: Thu, 19 Mar 2026 20:10:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Uladzislau Rezki
 <urezki@gmail.com>, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrey Konovalov
 <andreyknvl@gmail.com>, Marco Elver <elver@google.com>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, Peter Collingbourne <pcc@google.com>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH 0/3] KASAN: HW_TAGS: Disable tagging for stack and
 page-tables
Message-Id: <20260319201057.05d57006408a2f77342eedc2@linux-foundation.org>
In-Reply-To: <20260319114952.3241359-1-usama.anjum@arm.com>
References: <20260319114952.3241359-1-usama.anjum@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ykx33tqqzedoucx9ruzh6fgepdmywibu
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 535FD20005
X-HE-Tag: 1773976260-81625
X-HE-Meta: U2FsdGVkX1+obmSLky+X52yz4AHwcBqTP9IV5W4lm32GMTle5oE+74aQbB5kYbNiKbHNsW7k6RYeu4jc7LEmJTpbZt4GZnG42hoTuH5ENTS99Ocu23dWNAJIq2auDwO/037HdomNbLnVrvISCbzuHqA1l2NRzXqnZeBiDkQh9jrX248IEKvOgxx+MHKa2+bPRMPEoJchgj5G1jAhU/xrWAgdMbug4TtCL0Iy7LXVZtYxx+1ekHa8pgKBDCsG0kBGvVoDeIEzizDm+g26dUgtgqUr8auQMkfPewVD6fGtLrI8UOWU0Sh6hXhm3QuETCQVhT9DsiQuUI1OZU+gaI7QI08F47Y+bmSIXcOG3FE7fgkOU1QtkiMLcQiMBT8X6JgQsaAygSggTt37hzAB5Rc+4O7cGyLgv6X9kVQMBHwnDokMZQRj0uKeOj1Tn1XdSSbzeUhsg69KcQwUHBWegg3dqr/ruRlZJcIFnH+XjYMXCDiAdok5YAmlTMqSG/ILr02H5kf5couFN6JWJMAT5rtJDwNZOACAVlPduMjzWyzYJyERDXLZdpOKfJX/LApKzkQRx9b3Xodq+q3Upnies8WWAOoHMEKFiCr0a9HTh3Ql4hISqMI+R5/7ECgvnd5j70u1PscaUiGrtX3o7F1EtVO3yhOLAB06R/uil2JW4tvbPtiW97D2etx4c3tDTuSsgKWYQhO983kBMql8QFYN9W2f/NMqqxIN6c94uR+eqlRco895PpSJrrVhCd6bYBGU8J/Kvka0KTfKrAmrcpp7djOKxJyaqnQtI1Pf987Amg+pj32hd1dDM5wLSG/OOdNNz4vj6sHWmGgR5gKcon93mtoPGTr/s4ol3pZV8P3gb9uGiPjbbsnu8MPaqzSPNvNSvdjjKQUUAH07+pAR/KYzg2EpJjd75voxLOeR+Iz0+sE8MkFYWneAHprBOHZGwpHl4F4RppVKKXlyyAZOpCwi9ag
 F2fNdKBn
 wbM4zj8gD8ZtEjMabh+54ykDmUvmFj03wJ662cKZyC4pRpm3o/KATfaCGvZNzedr+ELt/72cCBIB0h0CAGb6oxbEnGD0ErEmmwCeX6b5w6MqEK7kndkv4RDYrt5YsJVWEQ3KkgRwlqzVxGTTBfGpF7Bo+LViod4/cHNn0CCXPje+onA+4FcPcOb2299ophhidu7Uii6iknxeqCRrn7jF4WafgpikB4QlQCCqk4dyR01jv8kCR/I45ni2EmGBsjOf/3Gjodpl2BA/50mKX7ccnusrSAj1iRvAgQ+sOCLuCcDT7d3w78CFHw+HEo4u41aH12qSi+gXrKSHMpuLsF3gkUqn0co2F5x52xds5bLb6nImjRFZJVRvEs2P15G84VJQSbO1aVuvWqzccbMa1rzjLBslYAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 11:49:43 +0000 Muhammad Usama Anjum <usama.anjum@arm.com> wrote:

> Stacks and page tables are always accessed with the match‑all tag,
> so assigning a new random tag every time at allocation and setting
> invalid tag at deallocation time, just adds overhead without improving
> the detection.
> 
> With __GFP_SKIP_KASAN the page keeps its poison tag and KASAN_TAG_KERNEL
> (match-all tag) is stored in the page flags while keeping the poison tag
> in the hardware. The benefit of it is that 256 tag setting instruction
> per 4 kB page aren't needed at allocation and deallocation time.
> 
> Thus match‑all pointers still work, while non‑match tags (other than
> poison tag) still fault.
> 
> __GFP_SKIP_KASAN only skips for KASAN_HW_TAGS mode, so coverage is
> unchanged.
> 

Some questions from Sashiko:
	https://sashiko.dev/#/patchset/20260319114952.3241359-1-usama.anjum%40arm.com

