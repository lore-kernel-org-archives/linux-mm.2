Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB7A606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fPfRvFK0
Received: by kanga.kvack.org (Postfix)
	id 4A6E36B00EF; Thu, 12 Nov 2026 02:40:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 458286B05B0; Thu, 12 Nov 2026 02:40:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346846B05B1; Thu, 12 Nov 2026 02:40:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 127D16B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:40:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88321A0538
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:40:24 +0000 (UTC)
X-FDA: 85425669168.26.E019F6E
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf30.hostedemail.com (Postfix) with ESMTP id CC42380003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:40:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fPfRvFK0;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794469223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K4R2hK0snJM7f5RU+CVLzgyyCzxkNvFTXNS07H9UUHI=;
	b=Id4FFxX2vXyIBEKcw7pS6JWVZ+S1Mdh0dIes4BusVHcYqeL9wrikOKBdSyLY4WDeGQ5RqS
	L4VRX0RyV2yFX3RvLYqQpfvOdIuTuCGcg1KAUzHbc9MlJsGXIHRKaL0lJHFoD8ukuqDKfB
	jFjDxlLlIhngSM0dEXaCqIEw5Px0hDk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fPfRvFK0;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794469223;
	b=jyArZrqOfWBVELqRxda3xflFd0mrG5synZ3c4V/DsDuA5hnzRI8fwiim40oT0Xa0sE2DFO
	PGCtqcu+pv4e4Guz8JySNzhfynrUB7Bl7ueWK4Cpwan1JAt5orBMx+yXwph1jXX37/d8Q6
	MdaPOok260hX63eEDmfAs3SskxyRRr4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794469214; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=K4R2hK0snJM7f5RU+CVLzgyyCzxkNvFTXNS07H9UUHI=;
	b=fPfRvFK0s5PlVlX+I7eJpucIbB0/FTxDfYgSdagHVOkZRFtlCapmFwtsnLp+2gef4h4XVVKUdLNvPQuBo6makcZjJhl9K4KpnpyUXFIfri87XA2QEjh1TsPyMXkFBWM9CUmFZWangX+dv1jJDlO4T73BfDW2McpqAH3BqUZVQbw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=32;SR=0;TI=SMTPD_---0XEbHbqg_1794469212;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEbHbqg_1794469212 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Nov 2026 15:40:13 +0800
Message-ID: <c92a3132-da7d-46f7-bd06-6beffa3d2e34@linux.alibaba.com>
Date: Thu, 12 Nov 2026 15:40:11 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] fs/proc/task_mmu: don't read young/dirty from a
 non-present PMD in smaps
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kernel-team@meta.com,
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev
Cc: stable@vger.kernel.org
References: <20261111113904.650722-1-usama.arif@linux.dev>
 <20261111113904.650722-3-usama.arif@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261111113904.650722-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ppaqgkkfshc3mykoifanwh8bbehtk36n
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CC42380003
X-HE-Tag: 1794469218-120879
X-HE-Meta: U2FsdGVkX19MQaj6S+Eol6rlptz5jopIj1SSl/x6yvFobYwqaIxCjHNSPjCLLJgS0KBwm6C0V6yQsOHMG69nk/OJJm3VhyTKCbNFNIXJ1Z/r2CcgkNS9yL/Nh19AMjI2Wjt+sa3FaCRb/OYhbMp25Wf10FiG3ugw/JK7wfmEwDemOtHUfgEaH/N/wo0d1leJeW38UX4wdJLF3fnosGWD8oupJE3hK4Pf2e7wZleYbEpzSzrZevY44ajCdsYmZeK7x+ogUJkNkiqEUmPSpNY6Ow91XiE5QIS9ahd8SzUngCVRvqKmrvq14w6RRnrsSqJwjYgpwyToORUGlIxasTZ5hHuWIhpUPABEvp+yWn0/sNQzMtS4e/SmcG/D70XDI+IXMYVTVIK0B+pvc6LeaEcbvSNnQJocTzvk0NSjWd7THVVMfXYTh/YdHjv+s5lAhdBZhyri2ozHWDMfgysEwo4LHLuIj39n55ZWthFw/Tz4YXwge/ChfgcQoUq86fxsexHh03H9WTQM04Pw5gaGcpYSw46WIeo4H/N4sB5dPLqx1B4Iqyic2N3/vUYJ+b1yJMm6f1wT0LIpsF5suQu8+rog+USxHyJvOUiALARMJJetrmUpCp7q8JFt+4M2+/JhsMw25ogmE43J1jDicIw5ua5LWU74F3Qxbta9Yoj/CBDU7UubxIm+VedyzLe1EL7Ru+5WNmVGYFIMHIDITSsb5+QM4g8rRo/i8U5LL20+X0TR6Fy0FXMcGqFGe7O9jnxaCq7pVbImmDODsktVWWqxNRHTqc7NfbL5l8908gewF4LeDOf6llWECwIUh4VzHGdvG/1YmpKpcdxAGZjJeFGZLs7MqQpbbuaaQvZyB5ZFvlZ6uYlAQQWQhWl1RKyExZnaGl2DXoQOlGOPbUHh4ZjzMsw5VL9bIqvotHrRTsi4ITJ/ZiMQC5wlpoazeIcvKsqG9ehaVrfkMelJaAe9j1JoNSs
 y4qs34u0
 m0JQXs7lJfHhOJ38ur5ozQM1PAhyxH/VSgDOQc0B94lw0DBpmkko/FNO8scNwoi5iII+e3Fjm0wLgGpwfk1NiQ47iW637V1D6p/ZNnygLzzVGnjwWHDnlqcVDTo0r7DO+IkBFkMly6qWkzT5OpzuYTpSEKM4CekU8LWy9pi9Tjqwdh9uKRybi49nWIi9yFbSsSVWjhdl8+6GS0hukCsiDNZXAFttTjci1gii1mkn2mPckhQKIYzUKipzqWe9gDeFvVxxRj82GgIm1YquYo0jPr/x3XxF0iQgbMvzxYydCqAGwHe0Tu3eaGvXSPSMondIAwqwTtM/AFeKuJ0ivC1cpw79B3O6UbkZ6uHqocC5Sg638HP6yxgwV5Dh+juVCGnnsP+VrnoWlwVK6OdDkBayrhUN8xo8zdmpSKA/4dq3IFMNSrYTWxuQMEAFhpTkItGhujkYSTFZ4jZqAcIzb6DWlBMcT5rw7v6c13shL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/11/26 7:38 PM, Usama Arif wrote:
> smaps_pmd_entry() passes pmd_young(*pmd) and pmd_dirty(*pmd) to
> smaps_account() for every PMD, including migration and device-private
> entries, where those bits hold part of the swap offset rather than
> accessed/dirty state. smaps_pte_entry() only reads them when the entry
> is present.
> 
> On x86_64 the offset is stored inverted across bits 9-58, which overlap
> _PAGE_SAVED_DIRTY, so pmd_dirty() returns garbage: a clean 2MB
> device-private mapping is accounted as 2048 kB dirty, and lazyfree
> accounting is suppressed. pgtable_64.h also warns that the hardware can
> set the accessed and dirty bits on non-present entries by mistake.
> 
> Only read the bits when the PMD is present.
> 
> Fixes: c94b6923fa0a ("/proc/PID/smaps: Add PMD migration entry parsing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

