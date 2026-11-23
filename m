Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A3B606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 21:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gxJWpn+p
Received: by kanga.kvack.org (Postfix)
	id 36E416B05B0; Mon, 23 Nov 2026 16:14:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31EB66B05B1; Mon, 23 Nov 2026 16:14:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BFCC6B05B2; Mon, 23 Nov 2026 16:14:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E42436B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:14:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 800081A09CF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:14:39 +0000 (UTC)
X-FDA: 85467637878.30.FF603C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id BD46A1A000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:14:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxJWpn+p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795468477;
	b=k8QPTlSkTu/KLVpjLA371J/hQCMr1toQKp60CZRJyLRGIGgDpCHtOnjmNvKtBaTVZSpWH9
	yftX5sw0M7wOd95bsUVJHkN28Lfcm49jSodyLBTM8XeIbDVde7fqb6VLb6nu5vrC2Qhgq3
	brfDHTEVL1LGAznfrGesDVqU4FnMNaQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795468477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsMDDAzOXXPVlqZAhT78LNgHlpzs1qOoQ51ThwSZbcI=;
	b=RU2X7aVJH4So+qz7l7kiNSs4bivimTyBQOkyRzhdW3baAaS+sTkdhHhMT1cgbL0G0FmX79
	GVw0W0JIcrpjbbTGsP+wH8M0O9bX2FA0RjdvAzrafCJSct7l5Y0EOkiRPGGX5u86DiFUns
	1+3U1ztTOQYBSX8BhBDl2Z+1YW3lsfk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxJWpn+p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 043CF611F0;
	Mon, 23 Nov 2026 21:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F301F000CA;
	Mon, 23 Nov 2026 21:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795468476;
	bh=YsMDDAzOXXPVlqZAhT78LNgHlpzs1qOoQ51ThwSZbcI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gxJWpn+pKIP1DPAQW+Xlj0/cDHz/oP47pY2UfaTHTC4bMpT6LmorOdig8/M9IeB6d
	 ydoSnoRIBZTwU/vuBUmUWICSix37TF894qb0E7Wqgad/r4LRBzt49U/feSVKrqeur0
	 tKgM2lsf3EEb0e4J5u0cxyW3BazOTsu5siFTj8L83oJ4b4s9f/1azeoYKZeGiz8xM2
	 y5sUxAVKPqHTJKEIOIxzEMNOELvokmO8ewn/P9hZmLsKZAOdLhsLneGdezVQlItveB
	 FWxPrbRroZttV4KwG2wUcCMG7qrvVrW9jhIs8j6jMm7ofcUQOq1T/2D19h7dlx8G4W
	 xEyDB3k57QDXQ==
Message-ID: <4be63e4b-c037-44b3-ac8a-071c25120e3b@kernel.org>
Date: Mon, 23 Nov 2026 22:14:25 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] mm,drm/i915,powerpc/spufs: vm_ops->access related
 fixes
To: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>,
 Matthew Auld <matthew.auld@intel.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>, Rik van Riel <riel@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linuxppc-dev@lists.ozlabs.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
References: <20261122-access_shite-v2-0-808d8d2aa700@kernel.org>
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
In-Reply-To: <20261122-access_shite-v2-0-808d8d2aa700@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: asrqai383f4hi6xyh7w1msyd6s33cuph
X-Rspamd-Queue-Id: BD46A1A000B
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795468477-633472
X-HE-Meta: U2FsdGVkX190nioJ1GSrt2QJHO/eC9cYmlXmgKSREc8LonzUVnEAY02HDWBTM+WJy4MIBD3JO6KF4ktKZvd2hwtg2xZtweMv074g8EUDn3uRQGX6kfnNx7QFcNMiwHvRJNxlmS8GCyZ6uF2GEJulPPJc+KIuxeJHAaNCI49XfyP/6y3d7TBQ2JMqoTQFf0D7z0paMX9JUXJX7qDMu7VaXN9Py9+GgvmWM8NlAHjcIVtGHW8K/+GIlEv4gKjGgg5c4cF/UDJUbVOypui9ODVVe09wog2KozsPaqKTAeaVsq0l86SkalrGBa28TivyNjQ36jKbrQcCTHlfdgXDA68ox8iSZZI0u3opC1gfSO+W474XyLfE8sPLyzgIHjuTfJWYUiRsfTwxMYWFVRm+xKklYuYujwhAdUYmiYyB0MQ/7uI4avbYNIwF3aKvruDJElvyubdbCIxv02Am/H4dZY7cYijYxxLVaIjR51y1CWMoZADyUPOgDn8p/++m54iHHQOUGOL3n3i/2iQ456t7J56CTVelKGJcToagalZXpfW+Ru0eEUcsibA0iMEBD1uQJmI3UFyg91AM+bGyBiJzMvsdrjt9OoejJE2EkKZ8f7B8tr38GFuiEsh4c+jGttnWkUvRcwk9QruDgGPxHOn3nRcdSDFjqnz/+SXYvYk/UhY++6ZuFCG0ij6ezKFM0vwmV5Fy6cYRk8y0KjROEaU9cW+5IF77S+2OYDqisKi+Z/rpeqiRbnAe9gg3cEt5pN3Y/7G38MB8v8bZJuhiz7GnTg2ji8/dq3dZz7L0ZCToembA0RaAtfuIdrE2cutMoXrWHFqJRVd+JVFAhdIGVvVsER8id/GuuBUV5CDpp3mybw6GxEmesDrdS+zJ4shZx7wiMQcxs/8AXGZKFZourD0nCqqpF4PC8Ui4l50vpOzHcpOPUAlpNycfdIk53WKggSaKJbSOXN7Qfz54JEwvuD45g10
 VOQG7Sgw
 xqdQ72PYvm4gXPd9fkONRj7sPAcWhO4qLdAzpEE6JoxKjjpffjXBhSwCpt6rfbi+XSfdGo0GUkABRRX1dOBSYJwE15C1AwwU+JxqrgVvUZ0kGysM6tj8irw8Nyh46yMQ9E1TVArc/xm6t/FOuOJ1TJ7vC6I4AMX9NA4ZgVmDbar42o0BNGuBiaFVcvwyy9aZoOhXimh8rkeDxz5+AeEXdCpvnHDpOVzNhO6LXyfPWkE7AJe1ADG8kRtZ/JEnWR2UKgX5B78h4ShRrxr0ztOnrYDuGtlbN7LayKemULBJyCBmb4iJx+i+B2sc+rp9SWps2/eSM/x+KT5s/uK2XAP91nQbCg4I1ZuCs6IE5k0gHOCL/c8R0mDV3Wi//JS34WZGbofpGQ37PRe9SPXeP/uTxcYSMks7RlEaQCdPEA06/P4NcX6b7/EiwXe9UKPcurY8SF4cgVwW5BQ+LUdyx4sYWTx+yRjbAe0yNnZB+XjDRkDsW3KnPPmNJu8Dm0QJ5KOeMmskCX8XsanxA9AhucSNOUmvkGUy9UZkKXbx+IfsSUXsoWsQT/usp+x9hsc3JSe51+7Gb8XoyZKYopmT1XMGuy52ZK4NxGAP5ak4xD+a9tPapeuxj/6cQw5Ns22TV3lh1Bas+GcAUIsxUhlhKzcIz91QbCAArWc70cslz8Z7W7cO0m/0USwWfX/IlDfCgG9O5Ot+vQsEbv//0dQUR0KaZK2suqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/22/26 18:55, David Hildenbrand (Arm) wrote:
> While working on vm_ops->access related fixes in core code for FOLL_ANON
> and VMA access permission + size handling, I stumbled over two driver
> issues.
> 
> Fixing it all in this series, because it's all intertwined. Only allow
> FOLL_FORCE to bypass VMA permissions, similar to what GUP does for other
> VMAs.
> 
> In patch #4 we break a debugging use case for older ROCm versions, and
> forced writes to mappings of read-only files (e.g., DMA-bufs). Current
> ROCm no longer relies on it, but old setups (e.g., MI100 with old
> userspace) might break when updating the kernel.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Changes in v2:
> - Drop "drm/i915/selftests: request read access for mmap access tests"
> - "mm: check permissions and bounds for vm_ops->access"
>  - Allow reads of write-only mappings, as we historically did
>  - Combine the permission check comments into one
>  - Mention breaking forced writes to read-only files
>  - Extend patch description
> - Pick up tags
> - Link to v1: https://patch.msgid.link/20261112-access_shite-v1-0-988a5c470db2@kernel.org

I just sent a patch to teach the

	igt@gem_mmap_offset@oob-read

Test that partial read success is ok.

https://lore.kernel.org/r/20261123211018.12339-1-david@kernel.org

-- 
Cheers,

David

