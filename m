Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FFBACD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789CF6B008C; Tue, 12 May 2026 05:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760C56B0093; Tue, 12 May 2026 05:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676BC6B0095; Tue, 12 May 2026 05:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 590AD6B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:02:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F3F1120422
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:02:30 +0000 (UTC)
X-FDA: 84758176860.24.2A94E32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 61D57120004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:02:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D2vfH1t+;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778576548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/TORd/xXM+E01xP+tkPc8uvGWAcJ1IMs1CDoUeyNORE=;
	b=gB9yWMTq+M0ABgYLD0Qm0UH35qmOvMpd0LeVj/jA30eOnq0DOabc9XwXEUfKfptLrrUMw/
	uyklHToMRifFY5Jqzc9uhT7nE9AsQJ38m11YdSPmFWAxIl5BxLmz+w0cvSMw3dMvHUGlnu
	ofgC4jMtZcAtn2jFU+SsTgVMf/OfGVU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D2vfH1t+;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778576548; a=rsa-sha256;
	cv=none;
	b=B3MXCaCOsqSh6D4GafqydgN5x1BdOD4m351F+l8WoXHKn/Qb/1uyjx9EcfUXoNKJ+4R/oF
	Grkmd/AkiYi3GSvQQ5MLJLKqnZb12SVGwMZAuyL4BLiBQjZuNgY1W944SJToMqPqGvk/rJ
	VtfNWO0TzL89JHtGklybuJUweSQ2U1U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B5AA760103;
	Tue, 12 May 2026 09:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6BAC2BCB0;
	Tue, 12 May 2026 09:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778576547;
	bh=nUSqbg2QVpAxEQfFRfBvRGZgoisTakpc2RR4Y3RGvL0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=D2vfH1t+2SNLEgNYgnXizamNj0nQQH2BWDkarlQyHg1HyCU4sppZw/kxeq6xPJN9l
	 d0h8/Z+x4qKdbYmA60Be2WbX4Ha7Y3bmwfapyGLLWDqIyVqGJVLDKFJeGsVvBSRZ2s
	 ICeX+MoOai2D9Jzho7z9SdmkMMrSupJyhkbQXfjJmmU5u6jq9jVq6dfulgvG1G/aWU
	 nZMEV19yEQrczoFyQd0RDQQsJ81Xc8pMtSWtSbtgycDk6SA2S7Cymsd6UQl7Ix9Jkq
	 Nbhhxo4JXEgJn++b1cb4hVrOLKyhSoZtvn2YOkO/EpWPoKRfRPAR+aaAgZ+IEslcHE
	 83Tt4p7t/SkXw==
Message-ID: <d16893b5-3a21-4595-b4ce-e34a7e8a199c@kernel.org>
Date: Tue, 12 May 2026 11:02:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 PATCH 0/11] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: Yang Shi <yang@os.amperecomputing.com>, cl@gentwo.org, dennis@kernel.org,
 tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org,
 ryan.roberts@arm.com, akpm@linux-foundation.org, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260429170758.3018959-1-yang@os.amperecomputing.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260429170758.3018959-1-yang@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 61D57120004
X-Rspam-User: 
X-Stat-Signature: 4r4875oz4saduk6a57otja6n618xxbde
X-HE-Tag: 1778576548-832947
X-HE-Meta: U2FsdGVkX1+84syQhanhdaSg5vPaf0R75Yy9fj9Cn6oYnVSAHApRyCa0jGBjbcYbclWwZsAteWzb+rLwIRZTVQ3DF3UyrfarCAwKQ1UM5KNzRBM/Zhei7DhEegagaCet48zMb37iQ8Hgpp1FuPGKrEj3QF3jiRmSEVsPSWZKosyAhVfuAdn8DbMV/DbqBY5asjac3TgsRUeyVifXeCh87cx6w+usaxtsB2QuF6ABLW29+JANG1TvrUlVTI/DEjLWQF7XMZVAnjP5m16TkZCbi8ZDX9dsX7qdjRtK/uC+H34YRcda7XjXNdabBIYNLBTXcgYE1GQ4WWOR3NRb7kiLoD712PgJq07kSfjkOpYrMjbLLoJrD4PDSIPxbLQnljuhqKAfEk6Do/K0O3NxnaZjgJaRhRTwb8qYPgJDMOlvZnKgelLotqGJKytq2mADMXR0Ql4u1sV3Flxg0fO/P4PtrCW6cB6y4abPNl8RQGU3ChLTZzexsvPUetpkct2Hn6MorFPwcYRKN/TXnTw/Pmj22m1NIPpCwsgJskp9fsaq0ihWwgup24BFVFeGgntazUCk2FZk8OdHY7AxXb4KaWQkn7nEmJ0WoZnswfWntmWLKqXB3I+0soDvAeewpRMe/7xOWX00wiRIXOTMG3tPCz2I/YkwdTRX5KE+DPwSdaaD5/UA1pR1rhF0yTng642Mij7HEjE/9NC9W+xM6L/ZFqmVEWcTLaLwRiuTH4hHoZ7TtDhWPcDijuM3Srg9ROcCq1mFR0YEfpBtqJ8z7tysirO0UsZuL6KOo3wuhp1iJIGUAFht/elpCllNtJcgU6Vxr5l+8h6OKchGUDBUjbWx92/wgqzoaNFL0DqhTIflTuZq+i4wl2pcbMkIe/30qAYGL6NFjjoibzgYcmLHE08yCPBzsd5uXxhqKzxCSFMIzzbD0MgW5YIq8sJ/RBjJCA4k2Q2l6nL3o1KqQ0M5Srvthdg
 okbs0AUU
 xAP/2O1dmZFsmYtRi9/R8Y32H1AKfif+v4yIOEqS1NoHT9S0e3dcL9bWR5ZELlQMNDi6onh4w8oRfiFQBFfNX9S/ecoSX1NH50VxbErBT+DSbKgq1M4LgdDfpJyE4CqPtU0rvRMklbKjsXfLWJlKqWAVWnsMq0U4vqI6k8K7k8NC08dVpDHobZyDCxWRCQ9GO8BMC8yB+rXR8abMRyjI21lhmJGPeLCUiwynUiwiRxoDL/iCo/QWHG1FWmfAKXhApQWFy46pZQmkd2SOmNqdPgbKyuzhSZRPR8vhDovE40I9jZYjBj/Cs1icFBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> =========
> The benchmarks are done on 160 core AmpereOne machine. The baseline is
> v7.1-rc1 kernel.
> 
> 1. Kernel Build
> ---------------
> Run kernel build (make -j160) with the default Fedora kernel config in a
> memcg.
> 13% - 18% sys time improvment
> 3% - 7% wall time improvement

This is pretty impressive!

There was quite some feedback during the LSF/MM session, what's the current plan?

Also, it was raised that Linus so far didn't enjoy per-process page tables. Is
there a way forward?


Finally, in the LSF/MM session, there was the question why the preemption
handling is even required. Can you describe what the problem is?

-- 
Cheers,

David

