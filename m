Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ADDFF8925F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 11:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E57C6B0088; Tue, 21 Apr 2026 07:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895D06B0089; Tue, 21 Apr 2026 07:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC706B008A; Tue, 21 Apr 2026 07:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6426B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 07:21:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DB068D03C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:21:38 +0000 (UTC)
X-FDA: 84682322676.29.CB57EFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6F9B7180008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:21:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DZ9aeual;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776770495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5NaQp10fC21czwxYz1OlOt79WdfoTHaXfQ2WZiUuVM=;
	b=DGVGDLrRuMUjaEatCyt0ls1i0dGbfPPVJmzVhbnnpgzIENIKog6pIQoVizKp1VR6y58Ciz
	QRiWse4MiSeJtLbVRRenDjsjYQmusrJrdyOjnI/7j1sfDwxn0bDIgZfY1SGLTdiePkzh+O
	Xb7BUUVR6Ji7Lfj0xDquxXTk+RyAn0A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776770495; a=rsa-sha256;
	cv=none;
	b=tVFbBjn1z49UxFa7vgl5MV2mGyFYGLGstvkayjMSMSu8AMmqibKRwamjuV43KXIQ569ZWX
	5WpVf7i1dk9f/wxeOsWDh/lKZ25xIBFOdmVSzQHUwY3btSjqEDHqiXZOnGKqtHbHsYH2jo
	SaUBQ5hTqJyO/mF9ilAalp9aKIic0hg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DZ9aeual;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 670A960125;
	Tue, 21 Apr 2026 11:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F2DC2BCB0;
	Tue, 21 Apr 2026 11:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776770494;
	bh=9SngLDlLSrRZtWzwN1nn6cQq5z3isskMTiIoeHQPXUY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DZ9aeualfrYF8+3WcZLwsJEpJIz2cA51j5ULqOULX1PxTiQg+XOAQTK212j2XfngN
	 wYQQbLy+bmca0BeeYnHwe/1dOGQ5ZJaAWXiiLJXEH9VIGrncejeND4K3NzDiL3wA4K
	 zvgd7vFxKb09ENWR8Oov6pCqX2MU8yvfYAB5kpOFXig19tU/qQIlMAVDM49vmEpRC5
	 9PGbX6lRG22bqjNnvauJQaYqCAIvK6IB9wbh7HxUziTVqKJqWTHWqrhf/tL0Dq4gO/
	 fRRJeUs7R+8NVUnAtfMw6mxlSI+fWq6JnU6jWG/4lOmmlX1/n4Zg4xqkk7ENA4k4ec
	 MCzr7KpmpQsNQ==
Message-ID: <76cec69e-6ee1-4630-847b-80dc1e49d643@kernel.org>
Date: Tue, 21 Apr 2026 13:21:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: Fix race on mem_section->usage in pfn walkers
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
References: <20260415022326.53218-1-songmuchun@bytedance.com>
 <09d1ef13-e02b-41e9-b431-4c3254e42011@kernel.org>
 <B139F2C1-77CB-43A5-8377-4F4BD44ADC6C@linux.dev>
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
In-Reply-To: <B139F2C1-77CB-43A5-8377-4F4BD44ADC6C@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qsyid3b8gg8cnhfeya97xb6c6n1t8fqw
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F9B7180008
X-Rspamd-Server: rspam05
X-HE-Tag: 1776770495-349595
X-HE-Meta: U2FsdGVkX19+QjwEOvpcVuLpEZOMOzLsqUzsEq9t3PdtAy0EeDdJsCbugyZiNUcvs967ASLK3V2eOzuIhFRkWQjTLkSPS/LjIATMC+FbKph0TOPVN3Ip2u2QfEiMhPsaa68wEWjV4/jlWLSY6j7SlmKu7H1s5Z6VpyyDyEv8Vn2kgi/yFL7vGSZeVSQbUXIwBzgPIX23vwY3QSEWMduSNgGZ27+d4ZvEqXQTdPB/kU/HFOH4XobKkJ5UjAOj3XTDYnoeXLrNQcV3s9FoZEwtglJoipagMM9lpU1Dv05yWpshDxV9iTfTsInuLPOd+E0i4k6H20DQMzFww8+8DfKJX+aW6SDUJsWtxOm2TZXBsM45R43QcveIu0AGCa+3PGOUIHBlIkJfZYgRnzLzhNyHiwtrqxv3VnM8mIBu9mQgRSELPavRxkVtXT6fDwC3sbAMbL4Lv43f7fpKu6YLOY41uMTvUXR70qSzs8gqbpOvWHa+Skb8cP2+G78HA7IZ7nCHTsxPUV1r/4iY34jttsaKM0epDNKeV4eZYl4LVQ3F/JQGySmsMjoQoc9wNKyWooTzjH29MHUtvc8QDhuRcBibWJQbBGeXqI2ej44zlTEjtkBEMYc/6TW+towz8ZVRQNIy2XB0/8/xhdKUGypUyuh4BHIYderGctxEQI70cvres7Wx+dZToLlSPy+ZgXusNS6iDvFVfX66sRDQ3iPKyhLDpJeU7KYhm0khEnD0QTGSOGdzVTZlVE2NqMNdOukaiIYOcIUROuNBugY/Za27Y/JZ9kKSJZvnKm6sLEZ9ZV8GCnTG7mC4Brj57I8eAslGyoo+zBDKCpf1+U4wovSYYGmc+2KKr8RvlrQ1pt1n+vfMNcSmriAcXKh+s1XVpYN2wdTCazVI9oxKeb0ojX1PhC1hW5G06L7nzAUzHWOUvR4gz47cf4RvTwPRMsm51a93Zg6d4zi6v2uU6FqPqUYY2nt
 AMDFXYkD
 +GovtwJpZ8nibCpuwZ5NYn4VGaMo1Fe4gguAsA5biYCmUqbxnalYa/XCHLwB7bhh0upxbU4/C8vsj+0cTgbVIDVM/FUYpph+FV/oGbp0eSusu8QnTzYeHsbBTjz8rwupzvpgsH9IzbQustH1Jnn/3mZ8Y/+agGl4x9ILM/vfHm03T3nqPcdPs0eNRvMKTFXpjNcal8v49Z9Mnib0uGNuCSnFqtQqoGAwwctFQG2TIDvu12XvPVjiMGNmpYQSLQoOPxWKVyMztzwjpuMqdFvtq9H9SlWyFyYNEem12/YZYRuJwTs+WEmio0s2tclDNr1jzZu9L6WmadZrIfeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 11:20, Muchun Song wrote:
> 
> 
>> On Apr 15, 2026, at 16:04, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 4/15/26 04:23, Muchun Song wrote:
>>> When memory is hot-removed, section_deactivate() can tear down
>>> mem_section->usage while concurrent pfn walkers still inspect the
>>> subsection map via pfn_section_valid() or pfn_section_first_valid().
>>
>> I'll note that it's all racy either way: someone checking pfn_valid() /
>> pfn_to_online_page() can race with concurrent unplug.
> 
> Agree. When I first saw the commit message for 5ec8e8ea8b77, I was curious
> because the goal of this commit was to fix an access issue with ms->usage.
> Looking at the race diagram, I realized that while this only addresses the
> ->usage access, subsequent accesses to struct page will still be problematic.
> It's just that the former issue happened to be triggered first in this specific
> commit.
> 
>>
>> We've known that for years; it's hard to fix; it never ever triggers :)
> 
> Glad to know my analysis wasn't off! It seems I've just stumbled upon a
> 'well-known secret' within the community. :)

Heh, yes.

> 
>>
>> So is this really worth it, when we should in fact, work on protecting
>> the users of pfn_valid() / pfn_to_online_page() with rcu or similar?
> 
> I am not sure if it is worth fixing, especially since I just realized the
> community has been aware of this issue for many years. If we do decide to
> fix it, I think the most straightforward approach would be to protect it
> using RCU, something like:
> 
> # the user side of pfn_to_online_page():
> 	rcu_read_lock(); 
> 	page = pfn_to_online_page();
> 	if (!get_page_unless_zero(page))
> 	    goto out_unlock;
> 	rcu_read_unlock();


Right, but we'd have to protect against the sections being marked as
offline as well here, though. So against a pure concurrent offline_pages().

If you're looking for a project, this is really one worth doing! :)


pfn_to_online_page() is more in need for protection than pfn_valid() I
think.

-- 
Cheers,

David

