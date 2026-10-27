Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D78E606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=droMFJoX
Received: by kanga.kvack.org (Postfix)
	id 27ABD6B06D7; Tue, 27 Oct 2026 08:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2518B6B06D9; Tue, 27 Oct 2026 08:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168A96B06DA; Tue, 27 Oct 2026 08:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA6646B06D7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:07:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6439E1A08ED
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:07:30 +0000 (UTC)
X-FDA: 85368281460.25.CC2FD3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 960F4C0004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:07:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=droMFJoX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793102848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNXJLprrikiyjdl1QDWtGw0/RtOyXwyYKGXN/8wvjIk=;
	b=wTUB/rWswprDPK/OWSf/jxjmfeAqhOcIWQTCUf/9hDo7RTK2tZB930JORSMHpQGq5or8ZB
	kSu+84Y3S5WKuUabVylF9xVPf/s9sy7RhyCCtT9cGZSSnfM6P+Lz/UojcYazIirhZHp8WX
	uuswdWHWL+xkf7lGuC4ogqjSv/d9BRU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=droMFJoX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793102848;
	b=CSaq3FckhOxjlpQ4wP7bxweQX02UnAfOoHet0sn+z3dTiQ3l/fveVl7pTZfgjOK3PlHhc8
	iCtkpZkVTPWrJvJ4PcJoGHUSy11DlxhauY6S6cVk62SfENd8XtBMPukmMeHTJGT0uCwpPy
	yj6ckCqSpwTgSoyGcZBqAGRuwLKvw+Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C19AF43C1C;
	Tue, 27 Oct 2026 12:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3C81F01828;
	Tue, 27 Oct 2026 12:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793102847;
	bh=pNXJLprrikiyjdl1QDWtGw0/RtOyXwyYKGXN/8wvjIk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=droMFJoXyLggipZyfrxjW6vvPs0RatK5Ln8l/8ouZu9C+IH7SsaJ+ysMa9LZCAVQq
	 e+xL4ZIejnr455+J5CQxelz195RbChcq+BJl04WYclXHkI48r+Cq96ZzkN613lJ9BD
	 nO5IiQ3hJH9mQz+VrbRivjNP+nRaLk/PATbwYuP0V4psk8PC+aN+OLW/EAQrvphVah
	 e0snwB80F2nuHWo3re3sNJWbk3i17h834g4JmwA2T7n66Wx+rpOyCV1I/zgQzLMG4D
	 jPA4+ze61RWdVnQAJQ1Q18w6b26mK1d0iEROGpcyAMOb6jbPdUmy6yAcLBZ9a4UmDV
	 qVBDPC37NRnxw==
Message-ID: <7e4b4737-8086-4444-9c27-88ef09a2e591@kernel.org>
Date: Tue, 27 Oct 2026 13:07:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/16] mm/shmem: various (urgent?) fixes
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <at-yaxmjeOXtA15M@gourry-fedora-PF4VCD3F>
 <5d10eba8-11cb-4031-84e1-a394ca5b4cba@kernel.org>
 <179304984259.319828.7383468637599462048.b4-reply@b4>
 <3022ba03-54c6-499d-b07a-2ca8d033a56d@kernel.org>
 <179310104515.664110.14057520583832900506.b4-reply@b4>
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
In-Reply-To: <179310104515.664110.14057520583832900506.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 960F4C0004
X-Stat-Signature: nk8i5i48s8ykwuidbt37qe9ub5pcpcdd
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793102848-795607
X-HE-Meta: U2FsdGVkX1+Dk08u7HibkryiwncrhTx7fdcE1wkoRk2QhxkW3xKzVU86JTf6Z7wrSevbO7VulpZFNV1ZYSGqCX9yfYpI3WobASfUJiAVTSHdn0Iqr80mOJeGBal5JHJdP6i1MtluJ5PFE4xNi95Y4VO0ZuCFRFEaHsOBIocQbp2/tLwLhL8lGHWpGnChjAYliiAkE1GSHRvsgWFj78Oqu1h0CpGb+koBo+d6R5G0rvXVnirkEMDuGOunirwzP7vTHWbY9h7VRt8z2aXDCDEXofbkhW0B/yBOLRw026DOzbEQnvzM9uUgoDZqPseutAbHbwhEaw6EpCqCzcHrDpcAkscdlqs/yAbKTjDj/ByfgTg+Hw3MtS+J0j1TznhX1IY8BgMyv2K2JTuzrv1bjmJ6yX+0Jc9xv1rLv1/dGgMQKGf/1b4NS4bOOru0wfonIDS8tdnnymJ0q69ice+NDqEwO7JE+v5OGbsXuj3NjnoLtFqLWr6K1l4+GDzujSatipXZsrztDzy0uV45VFycdn8rn792KSLUbgUzqCYRCIRSVUJTftnZfvDNHC5b9Xdvx6VBYJkOJ39Gc0+PmwJCdvV2sNDNdMagMj4LlNX00yxdPmy80PXH/sRyeKH4VuJYL9rHCA0jkpGHn1mEzeB13cd/FJxjOR81hlJr1Xf0aZ7r6eVyaJ5jrx7slTjlNoJvCEWZJ/Vz7eG/dbpNUNkH2afiAHyM2764iq9jEIjWgv5EGZz81NU2IuPz6Mhb5iQIVLcrgOMO1HYWhyzmQAN0azm7H+ilLKynuoMf694FGSL5LWA9XDE6aoeXk1pdWpYWDMdR/K4RXhtkWpLDuMnflvYwqaLfehrNDqedLxzwf/2DNAffjsCCjQU/cVIc3VgybwAk0UVjR2rxCVqSM1P948bNX1JRFaEGMSyJ9B0e/jLMIHC4GeViCL9ZE3Xq9IEa512KlZX4wNG/3CyyY1SBAVn
 8OI7bZQE
 9nu8TftCA+6Ze9pDhedGZsZHV78gMUT0PbcfpkIlaGxZSxAmh9Fb2ejq3sGdlbyfc9KSy7PJHypaIPTCPEZL0qKV4vllNXQGa5VJQi73ntVRKL8m0EKA3rHvVEh5SDsLqiSQ6DJQ1LwOK065dOP+off2nDz6Jw0Jl5kwCJHFKgO4YN/AhNU9v5HGk3FhPWOjZkOhLP9UWEG4vaTPMSLQ1WBjXX2hCt/fGNx4tqcP/awQfJzmNYU1DHR7/f2f9mx90EiSfSmp9OuKXyQfspGJy9gXEQc3NXG/B3B+oiUmAzM2iwlvbvd3d2wnP1+zTB1ULIw9F5g0s5/ZeJ6bVdJofRqcxRiXksu0dyPszofuCAzRiJ3o+CC2b/qXlmyqVpw0yGaeoGRDWm3hG4DWPQQyIqpsLlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 12:37, Gregory Price (Meta) wrote:
> On 2026-10-27 10:34 +0100, David Hildenbrand (Arm) wrote:
>> On 10/26/26 22:24, Gregory Price (Meta) wrote:
>>>
>>> It's there to show the work more than to merge, but the long-term goal
>>> here is to feed these tests into a larger session that does the polish.
>>
>> Agreed. But a note that if these essentially contain reproducers that can cause
>> harm on real systems, posting them upstream might not be a very good idea until
>> fixed.
>>
>> Well, unless people can trivially generate them already.
>>
> 
> Nothing here has been generated by anything the public does not have
> access to with a $20 subscription or enough RAM to a run a decent
> model locally. Otherwise I wouldn't have posted it.
> 
> Posting the patch is the full disclosure at this point.

Agreed.

I'll post a v2 rather soonish to move forward with that.

-- 
Cheers,

David

