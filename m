Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D42BCF3380C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 08:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1273B6B0005; Tue, 17 Mar 2026 04:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8B26B0088; Tue, 17 Mar 2026 04:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F093A6B0089; Tue, 17 Mar 2026 04:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD6126B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:31:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8DE759738
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:31:49 +0000 (UTC)
X-FDA: 84554886738.03.50FA807
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id EC7664000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:31:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tfZYjmXI;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773736307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Crt0FUtXZUlQRT5EK8GRozTxAFs1h9ZhTI4kYw69QgM=;
	b=zVMS4pUBccIjUaTsSXU+gzK4tgA4ZuytQ7kEVlfPa9E0l+c3NxOvAJKw91+Y3JIoshmzdH
	vRVOZn/DefXVC+PhPM7KPEo6SoEqi56EFKhZ4SdDrBI8TzWvFX1BPjSl1pKssEIgLKULC8
	tmK/JuIhgn1JA79TbMxshEa3Tp57c1o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tfZYjmXI;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773736307; a=rsa-sha256;
	cv=none;
	b=3l5XaKEXLOuHzs2RfOI6/BPcgxMhmh4eBy8tEiQ/6N/5xQpeAxdmJLTsjA1pSjQJpCgEEK
	J9NwSH0rEL38Z4LBbsemLyH6OY16unpC9sTmXbpZiLxjmkMhA50ickZZ33+89zhbmokB1U
	mNW4xamLFA/zyN4EXFgwQd6p86Epsk0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FC5460127;
	Tue, 17 Mar 2026 08:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582CEC4CEF7;
	Tue, 17 Mar 2026 08:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773736307;
	bh=WeIKA7wMjc9z3DOyJDTCgVuCaNGqn4/m4m3a/ZuQRMY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tfZYjmXIX93uh23VwW9nzPGKKfdLoN0eRENcO/0HFeXZdn3bXCPLRbZWcRIKtqCEZ
	 SV3sT38PrTQouLaUz7I8jIGf29xqfjxwy+o39rOiPt5oqoXG9UE4ZqwVxxoVOtaMgX
	 lxi2KH9oulV7LEJjDOPub1Y+MkIkvzu85un4W5h8IeF598/pp07Du8j3c1pnWoQy5j
	 XlyolfZ4hZc15gTXLKve0c0DPujWBQAkf0m8Co+d1aC9+NzDnA4aDofc0kwAil3onf
	 VzSwdg1bJoYBkCNyacVkU+FSHoYpU+cBCGIqR/5JU5wprzmMiEuM4CmtFJK7vHoaA+
	 4qaZBHXlHFz9Q==
Message-ID: <55ec2b7d-4f14-4687-8977-1bcfde8cc938@kernel.org>
Date: Tue, 17 Mar 2026 09:31:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/6] mm:/Kconfig changes for migrate on fault for
 device pages
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260211081301.2940672-1-mpenttil@redhat.com>
 <20260211081301.2940672-2-mpenttil@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260211081301.2940672-2-mpenttil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EC7664000F
X-Rspamd-Server: rspam08
X-Stat-Signature: 3it9i8hxdehz98j1fwg9tr36xgnaj33p
X-HE-Tag: 1773736307-795970
X-HE-Meta: U2FsdGVkX1/QAiuS+S6zjT4h8tVLWkf3jVDAkQs9+X8VFZRWgeN2IyDb/S7wKwH4XiQ1a7emI7HT+lDnkeAD7eD2xWRZY05KOSoQeNfH9GMOh2eVlsl0vP+0M+VbHTup1YO0bogiDEsHbJ5TQfTQaJbifKLOCtGhzDFKAX5R6IRW1uUhVRTmAGeFXuTT02eer1HJbmq1di62cNsYGWA28O719pb0QMuV+O7Doi2ewL7RYZMUHl+hY340+NyjmC95o7grONV7/bObqACQtfJLFzAbsxxkYPsZNf70qMSzkD8G7ktnSPNOhtAWdvXs4YAu8nR0XleZwkPqRDQEwRq9MlQbM/vQlvLFB4+ofGLvDE0v/EeOlkonbNqe0HeJYWx4hbVCAXM6LksyLgwL07hQnKwkDeFPrHfRJjVZ41OJlx4ownmAPnBr7W8pdPX9apBTEWOfqWFuId9iCtrOI+L1GLcIMD9VgllZQHQPSEZZwWefJUlio+nVlbcvtWkbRhMxqP3srvqW0Ms39SVTM1OSfFO15yb/xBDsOUDRx2qWqK/qpQ/lzNGJOep8PQAaD9dnSUFgPleuq8m9Io9/Y5mE8p1FPlW8v0eKQ1bieh++oMvCqLhIFkqH9+QmYs6iP4sAWriJz5zhc9251UMTIE1tqbTMz9PY7U0lnlx9ljyVA9JNYq8UiQUoASBq0SzA/Hg/oivztV/cP/6UmolHqWzAF8zNnUXoMW5iMoBS3joWWjiXlJK4cpGfpZ8Q0wYbnCdIC63ubTIgG2w23aq1CTwU5psrFBs1B84IOJyj597uTKBzkGrAuZ1nBWcmq/WZs25Nkw73hl7nh/QHPyRPK+wE5h3L8qFxjimo1Ec3cxZC0qhA0Mxzpj7qk2wI6OlNFkQxJG/LaSevljeN1ZWV209lUwwinHsxht5ZDscyW5jJGUJRPW8n+JN0eJYp6PJB89SFkR65lVb9L+oK7QJ3qc9
 dVCoDmE7
 Na6hwrmXEIdqc+xL40Z2UI4ICLj8VILeGESdEziA2cQF45CqO0BlqWw6dWayygifZMv5ifh1Vg7iM5gNwF0Dxp0vLr8S6ozYXkQPMeWyT/kM+KKXjWkm4tpEefg1jlggswXkftojZTUKkADK5LH1sWsg1yghadLE97SFE6wRhF975oO9HQju9cvkSW/nUwvysYgak/SVxtQM3tLpOWIGL5ep5veMEV4kJvqABpkH7oG3pOWw5tOUPHAwGZondwtrUKWxJPbMGX66HkHWkHgZ5hUZJvrtjNfZAG7sLpxucVavh5+BJBuVvVKgWiFgMv7GWBWXllcSFq/Qw1RR3bIylXxdBvS+3mBm7yPwU+YQKqUCJ/N+LRWTF+sAZS6IjIKk4ItMfb4Gflo8sHFEvDn+6jvbatB0o6CQTpI+X657zky53PQ1JB92vdrdfhu+DClNGhYym4VeQ5MUzd3gIO/l8EHtGolB7k5IpQiQyVZNFYB1KHTZZ5Qj9EcSENbdS5j4/veI6u+tDMfjIr48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 09:12, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> With the unified HMM/migrate_device page table walk
> migrate_device needs HMM enabled and HMM needs
> MMU notifiers. Enable them explicitly to avoid
> breaking random configs.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

