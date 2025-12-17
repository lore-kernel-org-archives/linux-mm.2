Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF3D0D64060
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 00:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1519E6B0088; Tue, 16 Dec 2025 19:07:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5B06B0089; Tue, 16 Dec 2025 19:07:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40D46B008A; Tue, 16 Dec 2025 19:07:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF3506B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 19:07:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82DBA160760
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 00:07:50 +0000 (UTC)
X-FDA: 84227024700.27.F4ECCA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D8D3114000D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 00:07:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XkfXCBPA;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765930068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqJgNRBhyY0zsTzWWrAD/qnWMswvoyS5pWDeko8Dv8Q=;
	b=atqLlqPu1mcKV/r2bpjwDH6cNJO3nwyK/vy4wHgN0WT8LIzKvdKHVt1nQVCo/ZVGOH1xxr
	3ZofFApn4GgpQDe3Pp2fdeBeO64bwSO67f0n1mFHBvxkTWzmskdBw9tu2RlSjsH/e3iWCj
	Fx1LZeGDosgtd2qSAH1JxlOiubeOHCM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XkfXCBPA;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765930068; a=rsa-sha256;
	cv=none;
	b=uss/Jnoq8mPx2QPYDG+Ha3mBtiZ1eSrdHq0WLkcZBM/TjFQsaxvc/D9X1SLMLKPQDn9HzI
	Eu7f0oBLIsphWXmKdgUw21gKjKCYGD4v8qYWDe4UVI77eOYntHVRYzBAa85Ry6T5g9iOGT
	KsTR5f69sRlABIQLAcd7My13fND0iog=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DAC260191;
	Wed, 17 Dec 2025 00:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BD3C4CEF1;
	Wed, 17 Dec 2025 00:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765930067;
	bh=I1puVGxpYyFnMSxez70MjXgi/52vDJCFU5H+7YNe5W4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XkfXCBPAlnmsILpX8PuDcKqLJsABCe8mlh9KO7QwZEPHw6vMzoaL93W5JpRav9THc
	 oPaqGIRuHAqMrnUb4FU8CUbW2cc1bU2G6mGcGpexuCVEZwyr58rHz/0rcHxDXeS+Vy
	 4Dhiqt4ijH4kBn65IRRS48ceUbkybzh/8RF4wdSTzcBjK3tFHQgq8Gh9zF4LrxH5C7
	 sXUs1gBJee/2E74VBB9GO+Ze9uB8paAQxsT8bd2Nlv5CocPQJ/KS374Monz2pPuR9l
	 JNUZxJSaX1BszFQyUYXj5qgMT+2hzPSi8OjRvwPoHDhoFym6RPqE4NIgmTG226SGsN
	 1tL9tHbbO2zmg==
Message-ID: <6b4cadb2-6246-48cc-9c76-64ba0a23198b@kernel.org>
Date: Wed, 17 Dec 2025 01:07:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Consider non-anon swap cache folios in
 folio_expected_ref_count()
To: Bijan Tabatabai <bijan311@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shivankg@amd.com
References: <20251216200727.2360228-1-bijan311@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251216200727.2360228-1-bijan311@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 99x1hsfa3wwfqx6ekxm6twydreahbjb1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D8D3114000D
X-HE-Tag: 1765930068-256841
X-HE-Meta: U2FsdGVkX1/vkTTSsl+nsSquFbCCqm2bjMpqFOvZLd4wCWDcz5IEGYNazpAkdHY+wwOTKpcGCVd/fTmlbKQB7s8ixErHW/b1qxtohsrmxm4PnmfkZmSBR2wBkTHIDbxesadTGcl1bqv8dzUpAxn/lTb7oGEakbcXpK7ZobIFe2//QxA/ZjEqpZIYbVteB1fOMwhFi3hO9bYlRmmBUTNmJOAdUk90/dIHMvDPmvVkdtsza+MFB9QnepD0HCsch6Z8YqtN2f2U0NyauA6y78AqcSiKj9SR1cqGuZL+URP0i7rTrsERTHQqi5xpOtcKJeOFlJJhg0ZF4UsTxz3pXh5vNzI89rNagmZOesUX8TX9mvTsCo+9Wp91/qtpNTWjm/iY+lCDcDP333O63TVxRcJG480dEouOwUHSu3wv0pv9vWM9ybrXdTnOPkn+KEziR1WXyb3SPgenBE4pTHJ5U+yDKGnKKcbcLuSTvfKk9llm66knU9eMWxzUkchhbBHkZLCS7yTFgbFI5DF1Zkjp+DdNSrgz19QkE3lCsz5qu8VSvecl8qTUmHzNRdeqHnAbkXE/VuJigj2UhFn04JQrgtqaKO+g0PQbiM6B08m2QXp9E2MG13gkjmvQtg1vMWmQP5uQ+RWUcyO+eA3IGyCs+Lsbw5uSSCiNPULv8WhG+hrbkIwsGp1EE/DwxvVHOpzAUTitj0DkMb77/FSaGmLQgX+IFRfJjWAj9GxXXdMOj0wd5R+ytDRwg+wvMmvfwMQ853Sf39xU/m9dX4Rmi2FGbni2x+uF3XoHZNLaNOY+SGnO/63aMzxz0Yd/R6WQqovMAhC8xwQYMxYvIsRbeznvLA3802sBZNRk60ja2pDKZZOjaXyVsOwCr64lP+UfFdvLcyzI9XdW0TKp8YWs5Dyhab7aBcdx85dsuxfOLypKq5aSJC6SWOrM+bcmqKG1mxJ7WE6Vi5B4DocLf7UmDVz/tsQ
 TFucDJW3
 gBsGPemEYCQKdAb7jPmsEoBVrOguokRzyr7D7g0Xt0HznKEWQHHKn5ovyv0E6jh1vqrR1fsfvfx309vQsiyzBp6PzglBc0uv5mrsoAMjx9WsWPMOfOhSeLlT1iu3WtyAHztIqCl16TMW8Uvw1Mvvc6Uqg9fco1so4oOjK/nLqCKcfLDzqmewWYscoxZPIO9ZA/Lk/pnWYNw6kiYJq8YmK4ZILxVRZL3wDp9meOfru+jSr0vA1lVJ0x88Adx14qk9k/e19A57rplq+MgjecyP4pYYkkvG0U5965Ic1zQc6eDuNq4EYZAf1dWAi7a1E5HcGY8VLTKW5dyDU/LgM/3deIyvt6/xpOadFApzLFDF52lLgbrNbhy7uupIMyBHRqs81GZX0g8Sm0THfbaMnrBQTncV++ZhuZ39S0vZ3RcyplVnC9sEV79tq2jpyAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 21:07, Bijan Tabatabai wrote:
> Currently, folio_expected_ref_count() only adds references for the swap
> cache if the folio is anonymous. However, according to the comment above
> the definition of PG_swapcache in enum pageflags, shmem folios can also
> have PG_swapcache set. This patch makes sure references for the swap
> cache are added if folio_test_swapcache(folio) is true.
> 
> This issue was found when trying to hot-unplug memory in a QEMU/KVM
> virtual machine. When initiating hot-unplug when most of the guest
> memory is allocated, hot-unplug hangs partway through removal due to
> migration failures. The following message would be printed several
> times, and would be printed again about every five seconds:
> 
> [   49.641309] migrating pfn b12f25 failed ret:7
> [   49.641310] page: refcount:2 mapcount:0 mapping:0000000033bd8fe2 index:0x7f404d925 pfn:0xb12f25
> [   49.641311] aops:swap_aops
> [   49.641313] flags: 0x300000000030508(uptodate|active|owner_priv_1|reclaim|swapbacked|node=0|zone=3)
> [   49.641314] raw: 0300000000030508 ffffed312c4bc908 ffffed312c4bc9c8 0000000000000000
> [   49.641315] raw: 00000007f404d925 00000000000c823b 00000002ffffffff 0000000000000000
> [   49.641315] page dumped because: migration failure
> 
> When debugging this, I found that these migration failures were due to
> __migrate_folio() returning -EAGAIN for a small set of folios because
> the expected reference count it calculates via folio_expected_ref_count()
> is one less than the actual reference count of the folios. Furthermore,
> all of the affected folios were not anonymous, but had the PG_swapcache
> flag set, inspiring this patch. After applying this patch, the memory
> hot-unplug behaves as expected.
> 
> I tested this on a machine running Ubuntu 24.04 with kernel version
> 6.8.0-90-generic and 64GB of memory. The guest VM is managed by libvirt
> and runs Ubuntu 24.04 with kernel version 6.18 (though the head of the
> mm-unstable branch as a Dec 16, 2025 was also tested and behaves the
> same) and 48GB of memory. The libvirt XML definition for the VM can be
> found at [1]. CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE is set in
> the guest kernel so the hot-pluggable memory is automatically onlined.
> 
> Below are the steps to reproduce this behavior:
> 
> 1) Define and start and virtual machine
>    host$ virsh -c qemu:///system define ./test_vm.xml # test_vm.xml from [1]
>    host$ virsh -c qemu:///system start test_vm
> 
> 2) Setup swap in the guest
>    guest$ sudo fallocate -l 32G /swapfile
>    guest$ sudo chmod 0600 /swapfile
>    guest$ sudo mkswap /swapfile
>    guest$ sudo swapon /swapfile
> 
> 3) Use alloc_data [2] to allocate most of the remaining guest memory
>    guest$ ./alloc_data 45
> 
> 4) In a separate guest terminal, monitor the amount of used memory
>    guest$ watch -n1 free -h
> 
> 5) When alloc_data has finished allocating, initiate the memory
> hot-unplug using the provided xml file [3]
>    host$ virsh -c qemu:///system detach-device test_vm ./remove.xml --live
> 
> After initiating the memory hot-unplug, you should see the amount of
> available memory in the guest decrease, and the amount of used swap data
> increase. If everything works as expected, when all of the memory is
> unplugged, there should be around 8.5-9GB of data in swap. If the
> unplugging is unsuccessful, the amount of used swap data will settle
> below that. If that happens, you should be able to see log messages in
> dmesg similar to the one posted above.
> 
> [1] https://github.com/BijanT/linux_patch_files/blob/main/test_vm.xml
> [2] https://github.com/BijanT/linux_patch_files/blob/main/alloc_data.c
> [3] https://github.com/BijanT/linux_patch_files/blob/main/remove.xml
> 
> Fixes: 86ebd50224c0 ("mm: add folio_expected_ref_count() for reference count calculation")
> Signed-off-by: Bijan Tabatabai <bijan311@gmail.com>
> ---
> 
> I am not very familiar with the memory hot-(un)plug or swapping code, so
> I am not 100% certain if this patch actually solves the root of the
> problem. I believe the issue is from shmem folios, in which case I believe
> this patch is correct. However, I couldn't think of an easy way to confirm
> that the affected folios were from shmem. I guess it could be possible that
> the root cause could be from some bug where some anonymous pages do not
> return true to folio_test_anon(). I don't think that's the case, but
> figured the MM maintainers would have a better idea of what's going on.
> 
> ---
>   include/linux/mm.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 15076261d0c2..6f959d8ca4b4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2459,10 +2459,10 @@ static inline int folio_expected_ref_count(const struct folio *folio)
>   	if (WARN_ON_ONCE(page_has_type(&folio->page) && !folio_test_hugetlb(folio)))
>   		return 0;
>   
> -	if (folio_test_anon(folio)) {
> -		/* One reference per page from the swapcache. */
> -		ref_count += folio_test_swapcache(folio) << order;
> -	} else {
> +	/* One reference per page from the swapcache. */
> +	ref_count += folio_test_swapcache(folio) << order;
> +
> +	if (!folio_test_anon(folio)) {
>   		/* One reference per page from the pagecache. */
>   		ref_count += !!folio->mapping << order;
>   		/* One reference from PG_private. */

We discussed that recently [1] and I think Zi wanted to send a patch. We 
were a bit confused about the semantics of folio_test_swapcache(), but 
concluded that it should be fine when called against pagecache folios.

So far I thought 86ebd50224c0 did not result in the issue because it 
replaced

-static int folio_expected_refs(struct address_space *mapping,
-               struct folio *folio)
-{
-       int refs = 1;
-       if (!mapping)
-               return refs;
-
-       refs += folio_nr_pages(folio);
-       if (folio_test_private(folio))
-               refs++;
-
-       return refs;
-}

in migration code where !mapping would have only have returned 1 
(reference held by the caller) that folio_expected_ref_count() now 
expects to be added in the caller.


But looking again, in the caller, we obtain

	mapping = folio_mapping(src)

Which returns the swap_address_space() for folios in the swapcache.


So it indeed looks like 86ebd50224c0 introduced the issue.

Thanks!

We should cc: stable


Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>


[1] 
https://lore.kernel.org/all/33A929D1-7438-43C1-AA4A-398183976F8F@nvidia.com/
[2] 
https://lore.kernel.org/all/66C159D8-D267-4B3B-9384-1CE94533990E@nvidia.com/

-- 
Cheers

David

