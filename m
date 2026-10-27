Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02968606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g5dpc32J
Received: by kanga.kvack.org (Postfix)
	id 0EDA16B0699; Tue, 27 Oct 2026 06:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09F656B069B; Tue, 27 Oct 2026 06:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECF4F6B069C; Tue, 27 Oct 2026 06:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB82F6B0699
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:43:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CBC3C099A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:43:39 +0000 (UTC)
X-FDA: 85368070158.06.5EC7F6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C900E40009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:43:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g5dpc32J;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793097817;
	b=zU3s6qoDAUQVTFj8M4JC/UX8rbKZNc0PqinTnjNzPNMIp8Y3r1UFqiRJ8frIa16hjQXCcW
	AslmBFvrm6WUToyQHiUmTVR21UgVkh5txLShxYwLLx1p7Kwoxu7Ps+ic9qrOVj9qVDI+y+
	Cb9CbTpAq5flool0P/U+pKH8mTL/C0Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g5dpc32J;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793097817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbJa13RjfN6919cMZzDU3gy2a1c9YqXQ9xqZ6+QCABc=;
	b=O3J8hWO1XXHriz0lyOBhMkSLkyskWI8q8ZCfMaJBZGiWkoKAWsuyOn9gSyYA+KCIB7IDoC
	hdLwjREWxJ2/C7m5AeqtSL6GjSs+1SMUa+dX/29eIuCxmfA/fdGz2qRpK0rXdjNOZuItKw
	fyQHlte4efYx7i9LwEtwoPP9cSwvi3k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A661140D7A;
	Tue, 27 Oct 2026 10:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48011F01829;
	Tue, 27 Oct 2026 10:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793097816;
	bh=XbJa13RjfN6919cMZzDU3gy2a1c9YqXQ9xqZ6+QCABc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=g5dpc32JNKqIkhyHWDOEi5UqQbRy0Xl/siRc8G+C1x4stC4Sg1XdCA281G3SQ+aWu
	 s0ByXluqi4gjOnDvTfcvY79PvjMrgo/HfAl6GZ65DItvU5QoAetsN5Ffy2Cbqm4UdL
	 rgBsVa22PtnNFp3OkZNAtboIGRRIN0NDqn/DqjBnGEYjiXtLnQ5MK1c3AM08h5FCXM
	 FFx0QjTRPnQzRolETg5TgzngAjW5IYRGTGruo9yn8IOY/CVG0JOd79/vD87r49v1YQ
	 cTPQkk3zmRhG9tfqZHeIUXLAwYgTFHehPBP2LSm5K7d1Z7Nza/CviBXX2mz4Tor9XG
	 VIVL7PNu6Z4DQ==
Message-ID: <c7adf7fa-a1f1-43d3-be75-4532a3274415@kernel.org>
Date: Tue, 27 Oct 2026 11:04:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] mm/shmem: stop retrying folios that cannot be split
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
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
 stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-8-703206d5fa0c@kernel.org>
 <at-AmbZyqUnGAJkI@thinkstation>
 <f7d36a47-6879-40bf-8c24-dfc89d937647@kernel.org>
 <at-U8JkqnTC9GZyK@thinkstation>
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
In-Reply-To: <at-U8JkqnTC9GZyK@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C900E40009
X-Stat-Signature: dfqatsxns8farpaiu1zgdka1qoe7kp5k
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793097817-540663
X-HE-Meta: U2FsdGVkX1/Hsrynl2LDy5RpwEjGvOsvKaqxoG329jZBF/g+u0x/GsiRIAKnx1EmQ86OKNUwBdlUxjFJqsf2sICVf7BwDS9FOU5kIqZD8lmh91Fe37PPBa8hVXfxD+BxGSliOgIyhkVplFPbQ/rbfDSMhv7vBgNIlpnHbUSePz6rmOkA6XfLzotJT0DBVjeB2+eQ1AqJxxA3t3hgc0CDDKBExXTwOjrVN8AOgWZn+xNZ3SeN5uxIcpXtDtzJg4Q3mUqk7qfHsLpGNd3CVUZgt4IvUYcSpTAFAc/CfCS3AQMl+0xNoxy2e2VyXFyT61FBv/yFH7NyHh/zXHkOQyrtkKQUKW8OcRxp+nB3etE7kyKz0Dd5PX5RbhuUwt9PGXw0FbWKRMEljgJtLXfR1AY8AOJZUj6n7BI0Ql4Y8jonbihSWqx0icu+Hilikw06EGG9RAvUmkasi3JX+ypxzBvgFubd2obAacJNEO6+r/kRDurrRhQcFPe1n5/VV4eJ8nSuoYiG4/034dR2DH3Hy84AnlZdvo2aGBBqitfD1y/LnnygSfgVJtviH71mn4ra25ZVshVXxzsPNRoRy5elTC5PDwClqmqps2oPPhceTsMOuxulC4hF7CihI5DSXfFV7hkRPAh3Rx+Z3YNWMCB47AfCw8GTpYYjieMlP6SiMR/gfXssVDwxVbvfTVZ0ntzbwbYMWNZXPnlMFB4w7mY4ybbrJGihCvwatgoy31ctqTIvYaOlDCs07N8RmDYwNZocMQDM6VEbE4lXFrUQERJ8/R8HfAqPqDQ8hunw7ZROSllp7N3mm9OuS3tpH3ZueGo0TzIcAtXNObIHwWoasrOo22y/uRLSuxL3J/tXTRXvsNINyEPCJM6iPOLSY0+/PIs66W/7DE00HEXziEnfGzZVxr+7PUdTV3nPfLh/lOYfrEspW4TOFCdIy8g7O8F/YTz1lCqANlI8wtvfuTxCSEWO2Eo
 ojYunh8u
 u33XmQs4jxbO3RgZkdHQCUiZUujSCE2ampEaKPUYbCd8JMssKaKtvWi5hc7s7WGr2G4LTY0FWuDGJP6F4J91m/kkp5Ef/d7l5NQJGYnf+ALba8/HG38uhYrlQmiQfpNovjDFZkgaIUl0Rrsem8/ELYOr/hA/k886tA9Fcqo8iA6BD0j3VQmsc5YSnXBsEQ9XDAUVBxHBEJ49JEQj9RpzUHqE9QDmY/wZbnWfK/Av7gxj5dbUgYiI01YDjxbIB6/Jtm1CUYqBfJAngI+VyOML/MNEHyWdn4WFVciqnaKt4ovbOs6j0MoKUyUBsS5RZysFKSvbwetZzWrVw0/IkIG/mcf718Pzgh6bIM3rJ2bT8fmjsJco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 18:59, Kiryl Shutsemau wrote:
> On Mon, Oct 26, 2026 at 06:08:15PM +0100, David Hildenbrand (Arm) wrote:
>> On 10/26/26 17:36, Kiryl Shutsemau wrote:
>>>
>>> Any reason, this should not be in the same patch as 07/16?
>>> It is the same failure mode in the same function.
>>
>> I decided to split because it's a slightly different error mode (failing to
>> discard vs. endless loop) and tackles two different commits.
> 
> Fair enough.
> 
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> 

Thanks, but I'll drop that tag on the changed version, so please re-review :)

-- 
Cheers,

David

