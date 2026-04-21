Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB739F8FA72
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 13:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DABD6B0096; Tue, 21 Apr 2026 09:04:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2896B009B; Tue, 21 Apr 2026 09:04:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8546B009D; Tue, 21 Apr 2026 09:04:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 398C66B0096
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:04:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A76FB8D11D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:04:05 +0000 (UTC)
X-FDA: 84682580850.14.D471E05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7C0B51C000A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:04:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lblW3fN/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776776643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TgED33Aj4ouzyhKaPFpPobDpAHIEyxpa5klbogLqWhY=;
	b=duFgxtxJ6XNR2xCunYF2Hi1EwEvr0Vu6aAXbBbBDJkdkW/wyRdjYiOo25aYeSzSJnF46HW
	nu8ihA7DCM3tuMFTcx0+rg9i4WxLlinBrvMC09A7vR5+ZvsJda27jpmiiwM9ATps/BQYK/
	RlXmuRCdWvF/4/xdcOOErV5umlWqaxs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lblW3fN/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776776643; a=rsa-sha256;
	cv=none;
	b=EHhehXk54lqg5G/f2LjmdDVHgqZaqaT/MKRzeK2XfYRQpmUSJTBjE/A8s7ilnU3CsRIQ1x
	eJwePYCp/XLP7jn+ZMH/nMQNiHLBP608ps8oNvsTJvrpOiWuw1fG4FinciaznxB3l6gFAK
	VQAk1A6PLThQNcM5TkIEj0R4dmWnbdk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 65DE941B40;
	Tue, 21 Apr 2026 13:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DB0C4AF0C;
	Tue, 21 Apr 2026 13:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776776642;
	bh=h89KPraY+wdrcwNr8DY3CJydCGxk7pR9YiiPdhRuE7o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lblW3fN/iUQHqxqXTRrmG+VISAc6Ux3YEFKhyadi2HK9XSYN5eklKxARVsgecaNEM
	 HStNpgYE9rKF8mQMzidcplDLpyN51BlfZ5XybeuGJpWF7pcjqRv9+3RhVHdJ5m2KOL
	 W3adAcEWXUtimfU8QekoS8GK4X5v8h4thp4mqBiBGxAovwk6VZttITqVtGMiG/G4M9
	 KTiFQfJDkJJ3XrHnRdXSMGoP5BBPJrQV1FRntPXNlcFiZRKU4EYxIi/4Fyyb1vg2sy
	 hZSv5er7Mwh/uYYDvBGXRcBJkM5tcSXoLR2ZEafk7WKJoM0hcVjejUc3OEm83A9vfM
	 5+9soV0DP0TkA==
Message-ID: <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
Date: Tue, 21 Apr 2026 15:03:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM guest
 memory
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org
References: <20260414142354.1465950-1-kas@kernel.org>
 <55019037-4f1c-4d9c-83ee-3a844d8f3d5e@kernel.org>
 <ad50rPOseVa-SP_s@thinkstation> <aeDoqFWPFxkkNB26@thinkstation>
 <1a499781-1115-44bc-adbf-2ac3769354ca@kernel.org>
 <aeFCuLJXT8VOkzH7@thinkstation>
 <4c635703-3d8d-4cfa-bb98-7f6f5fcbe547@kernel.org>
 <aeImfRrrvr3UoKtL@thinkstation> <aeTnlQUOOh-dHG8z@thinkstation>
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
In-Reply-To: <aeTnlQUOOh-dHG8z@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C0B51C000A
X-Stat-Signature: 59burgd7gi1fk5juw7f4k17mnej45e7e
X-HE-Tag: 1776776643-537643
X-HE-Meta: U2FsdGVkX193uIBv8xkneEufb+/VxtId/CKJdYzZ7OiYxbDky6Eb9vbTG89++FEiIcqGmRAfIUSBEHAPHz/fPSQL39B1tmc6LfJB3GYGDWLRpby1UUPKuyxLvuids9rpZ9iUL9mL8WeA7jc1oLLV3vNjiSqB6gIyGD0Jz5xvKMGtEgUx98+t3OVl2gkuEj+My/vLDIHMfL5zMnDZ+TTF3XEbmfIseM4fnPlfERbGzRmVTZaXb6MUwvExAkvjtaRMuivDxF/J57DhHbQT9phpP3xvFoYBkV2SoZphzUZapA3dklpd9F1td/wimVakbQxGFtA9bFQP+5CKFY/jLXPXvHxO7jWQe5qJqIFQo7VzZD+n4nIVFiH0PZ8eIa3wET9y+wjUGkNz/u20u3I0ARN78rgqV3tXcqIY7JkF8vT45ED7m8amMPYItXuWp9l5tclEafjt6jAnn0OS9Pik1n2tSH0huP7qtbvuK14N11GUC2NrCBDWz4yUHZ8SIvAVpafmSXN30IkrucdAYi2tfDjwE+wp3tFsaKObBrP+xAO1AqgOdxSGHcn885iIXE2/2uaD6deMH2Ws7FQFWbzqsWuxjv+Oq+qgK/QXtmYiN9dqxxNT5BtjBqPHzyqYcjckf3Gs7lLJvhfmrM3u0p8a8PrcXMo2lzzBLdNkidwvxRYuFSOFvK0EOCE4t1oONl+1bDql+RMbaw6SqHb4pVGDstE6CoeVpO3hIRBHUkirBijPUfSnQtWZ/YcQmGXK3QOfwrurKqPw65UcFsv4ijniDk7B/XMRraxc5pr+mv8IG8bqUzqWV5swUeKUoHMjfkpWveM2Wuf6vy5KgYYQHPMBbQeDvSY8DP314HN6iUi7dw51b8MjEFfRQlhGcwWjAQkYX30lmGniHLbmFZDV2T7WCncx/c/8aC42pYRPecVycFFynYzKMm/0Rjb2QcTlFjXXrDU6HKj00TV7dSa16mKqEbS
 9Gdq6md8
 DTTAM4eP7PzK1yQugVbc1p0bMaL5+WgJe6xbBa5OlMB1tdZpvmnKAVtDp1xcva6C7rBbQ591lEOH5w2ZdSFq9cAJoPbGXAbgZu5XhIxM6cfKLDXtf/oGhncSV8jrN7X2b0MvUktGUKLTDaLBy6ks1ERWhgtR3AKmPp86Hq+PqIqeCBIZWn4hQP39+/Bi9HnkO4rt7amzdciHR0mvfBcwU3seemL0S5Mt/4vGFBOC++V7awEG1XkLa6051YK1SUF8SPilWSGWkZPGiH9GyyUwDLIqypXdczBP2g5e2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/19/26 16:33, Kiryl Shutsemau wrote:
> On Fri, Apr 17, 2026 at 01:26:34PM +0100, Kiryl Shutsemau wrote:
>>> Leaving NUMA-balancing aside, a simple
>>> mprotect(PROT_NONE)+mprotect(PROT_READ) would already be problematic to
>>> distinguish both cases.
>>
>> Hm. I didn't consider this case (miss some uffd lore). Will rework to
>> reuse existing PTE bit.
> 
> See https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git uffd/rfc-v3
> 

Quick feedback from skimming over it:


1) ARCH_SUPPORTS_PROT_NONE needs some thought, because I am pretty sure all 
architectures support something like mprotect(PROT_NONE), and the config
option might be misleading.

So you very likely want to express different semantics here. You want to
know whether pte_protnone()/pmd_protnone() works.


2) The other stuff is really just an extension of existing WP handling.
I suspect we want to have some reasonable cleanups to not end up in
common code with

@@ -1841,7 +1841,7 @@ static void copy_huge_non_present_pmd(
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
-	if (!userfaultfd_wp(dst_vma))
+	if (!userfaultfd_wp(dst_vma) && !userfaultfd_rwp(dst_vma))
 		pmd = pmd_swp_clear_uffd_wp(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);

All the uffd handling should be better isolated (i.e., a single vma check?),
and likely the uffd bit should be abstracted away from being called "wp" to
something more generic.

Maybe it's simply a "uffd" flag which's semantics depend
on the vma flags.

Maybe something like:

@@ -1841,7 +1841,7 @@ static void copy_huge_non_present_pmd(
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
	if (!userfaultfd_uses_pte_bit(dst_vma))
 		pmd = pmd_swp_clear_uffd(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);

Not sure, needs another thought. But I think there are some decent
cleanups to be had.


3) Some other stuff needs a second thought, like

diff --git a/mm/gup.c b/mm/gup.c
index 8e7dc2c6ee738..08fc18f1290d4 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -695,7 +695,8 @@ static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
 	/* ... and a write-fault isn't required for other reasons. */
 	if (pmd_needs_soft_dirty_wp(vma, pmd))
 		return false;
-	return !userfaultfd_huge_pmd_wp(vma, pmd);
+	return !userfaultfd_huge_pmd_wp(vma, pmd) &&
+	       !userfaultfd_huge_pmd_rwp(vma, pmd);
 }

How can a pte be writable and prot_none at the same time? Maybe just confused AI
output that you should carefully double check before sending that out officially.


4) How do we want to handle PM_UFFD_WP?

We are pretty much out of flags soon. Overloading PM_UFFD_WP means that we will not
be able to easily support using a separate bit.

But our internal design will not easily allow that either, and I am not really
sure we want to go down that path any time soon.

Maybe we could document this for now as "In WP VMAs, indicated WP PTEs.
Otherwise, in RWP VMAs, indicates RWP.". Whenever we would allow both at the
same time, we could change the semantics. User space would fail to create one
with both protection types for now either way.


-- 
Cheers,

David

