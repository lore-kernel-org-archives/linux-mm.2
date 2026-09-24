Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58F7EC9831E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722446B0088; Thu, 24 Sep 2026 16:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3276B0096; Thu, 24 Sep 2026 16:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1966B0098; Thu, 24 Sep 2026 16:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 387F66B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:31:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D51781A04A2
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:31:00 +0000 (UTC)
X-FDA: 85249799880.09.B6608DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 17D291C0008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:30:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dwzxLk1z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790281859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7QesB3wn8+yidQJfEr/89OKxUr18TgMww+mIYXxRsD0=;
	b=hS6TwB2Q94FM44pPwvvLlIHdvfAy1JGRJ7iaKCFNHdNANsu+yR5FFSqLVk+uLhuj+APVz2
	fGns4SDB+8Fc1ecGaKn1KpaxQV+lH5MbWAtPIFtPGBZ4Haq3Wviy5SPdK4578HojWQKlp1
	lmAlKNi+Fh8dpCp5pFvo7D2JYYwEUQ0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dwzxLk1z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790281859;
	b=d0PBZOMxvWbBHAj8+G3faDMZHyeTBbsnSpDbbN3EtVYbTVLflO14HPSyrc9pvgbfwAwif+
	xmYcq8gHh64dCB4+xkNMv03mKCRwbe63W6s4Az1rudoLn1ijqktQt2LtfyOIkT7lBT9YqB
	l/WxwdHDE2BEenFCzpNYjR6o5X9nb+I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 869D860230;
	Thu, 24 Sep 2026 20:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952081F00893;
	Thu, 24 Sep 2026 20:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790281858;
	bh=7QesB3wn8+yidQJfEr/89OKxUr18TgMww+mIYXxRsD0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dwzxLk1zFjuelEjbXSV1QpGBOpalmXXXwREbsm4ynBL02XEnvhS+KtKgYliWpRGdq
	 xBQBouEEARo9WI4lxyUPxdSIRjVbsoh1q5EAZ9CBIKQhDe+Mby8nwQ5C2Eu/ce0aoc
	 N+JA+6L+tfIdMTfLyYzFQ7q1e/Ps2Ep6SBrGQnibpWm2SOA6kXu4Y4soAANgI80KXo
	 NJkETdjZz+7xtcfrV2SlITh2YXd6ikHSVLj12W51FQdPpBw2NAe2OdRyOGp45+S0V9
	 QB66EBYVDUQ7hHgPuC5DX76C5hjnZkNIVbZeCevhtJo4smCmvP2ySX/ueDGXTw+bod
	 x/L7WQo+UxuOw==
Message-ID: <4842e76f-c30b-4204-922c-ecdd02d627dc@kernel.org>
Date: Thu, 24 Sep 2026 22:30:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 13/29] mm: zswap: reject high-order swap cache
 allocations backed by zswap
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-14-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914122950.3283997-14-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b1donxbzpt8no7q8ytu6xgnpd8zjrsq6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 17D291C0008
X-HE-Tag: 1790281858-513662
X-HE-Meta: U2FsdGVkX18Dmr1cUsFOMYm4WZm2yDOfYIdW3E49xBle1y13As6xcg6hRPiluvr3US7BBXsDCIXAurAbyOCBnEkR0FZGz2fVHhSQD1Lv0KXtBX6XACUcvMHVT5cX5WKT4bvJ0rYZGxRz3Nk508bqp9JTahX6uSzg8Rvihu2MzCpzJBvJ9nkrYnHCzeQcnGq2ryQvKPegBh+M8oszXU68qMpxUwrevt6Dsvg9xzqBxDt2VKuighZJfJdSbeLIn2Hww2Hm+AS3rWIE5ocfJHD151RpYEfYTg4G0HFKERF3iKAsunEsdo7lbst1JXaETHMsUuDDcKGv8RQbLAylyYhj0daGpvx+Xnj/kUb/JDlXc5G+2uljqdzUbkLEOIO7Xoc/QUECUCeHuaw337HWiimdBP/j+UQ4KV04/mfy2B+lplh1jfLMDT66xBf7cdu/2tfl9hdFVz9DcolMESN4VzhCexT1ll9VOruV/ez8Ud1A09gsOxAJq98YXlyqo8KraSgUoO3s2ETdad3NAX9c49bdmW85I2oNsCZvSMo/UtWUhGBrbExFLbl3EL0myQ96Df1g5BomfSipivn61LJJr1DMuZjdvZSOjftQYeRsaPO0JJO38HIs5+HehXM2TGX8GMFxbdoR1jHDUu+W38QMz+UMnSeeT50aedCbb2iDUOpupSemBzzTDW9kKnkd6nl42iQnV8W5vFGC2d6PKURvLfEHTd8FpfcRxPpp8++9FfAy5AxUV3tuQxSREjujH0mrZfKePCpqjmRnEoY2h5LNzYmeVG6MyfoOwswlaToLWqHElPEFTBIbkoz9apO9ychYRFY5/sfRdJwtY+S5r5md340hnVGkiwe3DmhwmtkXQNGlVz6Kud9hX4SsmO/5hkCJ3+IdNAEsAcagpxcA1CNqRWpL7vam/EGlUv4dgXtbbAeMAYE629tANgxivG+PTY+mmSYjl1HLoYxm0hcTPDDiXK5
 wqMHMTAX
 x4ojakjkNIuLNLLmxx3IV52FjZ//ylsYFgNyILblTT8ezbpjRQHJbzvgRTrmtXzK7URnxcev/21lffkmfeVkT7RlqDS0lKouU4ypYcFBioILJ0VppQqs53nGJni5epEKj3fm96xFZKH4DXh7QzZlG2rAm1PG32HrD31JJJB69PZ6AICNO+ZPRAVsc/PLWfzOywiLSmqdnhMU04FR2yeMVudUZ7UYW0Mgz5Gca34JO7ut/vFVJDX4wDb2WxoHuk9hp0QUF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 14:28, Usama Arif wrote:
> zswap stores swapped-out pages one at a time, so a range of swap slots can
> be split between zswap entries and the backing device. A high-order
> swap-cache folio over such a range cannot be read back in one go: the disk
> read would return stale or zero data for every slot zswap owns.
> 
> Reject that in __swap_cache_alloc(). Do the check after the folio is in the
> swap cache: from that point zswap can neither start storing nor start
> writing back any slot in the range, so the answer is stable. Callers
> already fall back to order-0, which zswap_load() handles per page.
> 
> Export zswap_is_present() for the PMD-order swap-in users added later.
> 
> Co-developed-by: Alexandre Ghiti <alex@ghiti.fr>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

For 10:30pm that is way over my head to review. I'll rest assured that zswap
folks have that under control.

-- 
Cheers,

David

