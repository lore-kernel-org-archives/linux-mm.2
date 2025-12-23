Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F385CE6F07A
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 09:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42D946B0005; Tue, 23 Dec 2025 04:42:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F2C6B0089; Tue, 23 Dec 2025 04:42:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359086B008A; Tue, 23 Dec 2025 04:42:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 229306B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 29B8013B307
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:42:53 +0000 (UTC)
X-FDA: 84250246626.09.AD22FB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 45A3A20003
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:42:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HbF7OsaP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766482971; a=rsa-sha256;
	cv=none;
	b=Tg6gc0tiB+aEguoA1A1B91ViwQ9+hala0dDbUARdT39m3DMmvhkKxcjf/c3ZehlwBboWqx
	KaLJKKGmueldPa8oPkHAK/7ajWXiLDke0EYwg0H/FEL1HjSIiKDM6hJkActFi1PDFwin4V
	+SVY4QOsnPEToOpxa51eEmvftdYyQns=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HbF7OsaP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766482971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LaBUY5KHIpGxhyUwYtzaVyp+87hCSOUTn9wOUej8fCc=;
	b=LlAjYECe+AFABSZ5ow6sPs2RdSTsQOETBnsPV2+U1Uya0EdjQRt0SiIjbAV3ndsjTGIEvu
	rdl24ErXVt2IzFuzIMfr5amND0IIpNIbIKQ4zjEt4l6+xL4Cc7STGR6ZEFpqz56ipfccWx
	pjEsGY/dZhk55Kh/Z2Wnsi8Q0OxY30Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 218DC42B12;
	Tue, 23 Dec 2025 09:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4F5C113D0;
	Tue, 23 Dec 2025 09:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766482970;
	bh=OgrrIS5kSKeOkNAg1o3SBBtI3WjzGuW6Rb6zXIqANak=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HbF7OsaP13i2azHJQ3dr2a8dsVsPs6XCg8dDvmQY6JaRJZwTNq5LsDRgo2BSZtIn6
	 Y5jxrvIuZoh9wNQo0XKnraDTCQd73MbY7tMGNY4ETJz4NRtYFMhyr49UXPp5dN/oJD
	 iyDiEikKs4yJxB4R/LlnF8XMNK8EtoljcZfMT9J6CsOnRP3Zd2mHZGirMy0dzj0xiV
	 lnVvfQSOgsF3DAhKZG3Mx5pmsD1dj3zybweckn4H1h0nFiVz4oReiCTFJLWWn0Jwqx
	 XVMRF8i6QZfre+PYKfBLbyIYe2tGzoGj0sTFx103LaDk+Q63pxju9aEwezE42jo09e
	 38PeAH6+cYZog==
Message-ID: <c6b766bf-0f05-47c3-bcc6-2f0e1961a864@kernel.org>
Date: Tue, 23 Dec 2025 10:42:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_owner: fix prematurely released rcu_read_lock()
To: ranxiaokai627@163.com, akpm@linux-foundation.org, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ran.xiaokai@zte.com.cn
References: <20251223092526.140566-1-ranxiaokai627@163.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251223092526.140566-1-ranxiaokai627@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 45A3A20003
X-Stat-Signature: 5p7t5wfux7fzgp76h7gb91aogzury739
X-Rspam-User: 
X-HE-Tag: 1766482971-626454
X-HE-Meta: U2FsdGVkX1/YeNV6HbclsPn/K3wnZKSXV/jjBghIYX98PlkiNWcZ9/QsJjDQvWZFsScvgqaNCOx8pfjFzgPBcDMNIrsgY8arWpJOJqRqLyt5bV9EScwYl/Omgn/rPx7daHhUM8kZ3QetPeM6U2RDPhOI95DLSl+7GfyP4h0u7SvIHyNdEYQ4EqMAeQNTyWbTVELff7c5oR8u2EXewUXVcDqx056/hiJsXr9rlQnICJWPd8sfYwLO4HXn9IHX7oT2RlQqD6AulqV78iI7mEN9tk6naGq16ZoWMqt9cN42NXcKbdhxAN4rVVsM/WuDMXTUp+4kT2bt/xLrg17lMIOSE+Xr80Z8rMlxK1IVwCIzoeIZrCfG4iVuSfi57SWghPRRAnUs0Y8nICI+kZ2BLti7FNvhGmSpMPkWt4msah9GSkr9ue1uBQRJzUqI+IWnIzhb+xQkBrMELIn7CMfUB6CrjksSNchCyBFqd374n0yzKHRzsfwkzuGhW5L7KIHGBJNZGpgAZjlFcHdZ77jPSI/9pM8rDYnw28gRVHhSjxSOi+9dPRR7xNfHip1vtQ3xl1sDQh2BAfpcBoCQ1cUqTZH0va1yZ9c7evkLrVwZk7DMzNDgQvcLntX2NEntcx864eufFNIvXg/iXQSHE1JxJ+8h/zh5mVuquKzivgvJzqlESyLKHCxt77l0BwsbCZ+mkInV9uqhh7dcHfDZy8DHjnneoY6mivnlvaszYW9uNoosNHfiaSSsZICHpuVfUGiLVEQOnf2fLIMp2x046cD5ZMZTBPaMUckhtEHq9a9VrxjK0xe2L8KAB8OstgNJ0ahCe9pPBrQU3f42E5poJ6ZGxscQotO/NLWIhTvH0i2vLnzzK6M/CR8HP0R+roVH85ihLt3uWaQp4wq0AvxGF23kjNPc+lgOJb8/5qdtz2NrNqv3AKG1CJmGHVVsUWcffpwd7g6gQnyIvkhPWo27+v+FdDR
 PN8S6oox
 kCkn7/dryhsAJpyS9/0TmdJnHBRDvz2Wt+R0QSBbFWNo7KTwLUri3bsSb236az9ye7XVDYzrGoF4qbqUVmzbMPhg+ofqVAZetLYFW14CONS+z1MmJJF2L7trndkkS0PVkQxaztfe5g7J3Vld9XXDPAPaHabyR/boZnYfbzA9WPIQga/TZeHGgaJAgJva29DFLbasgx0xgx9sultp5uVN07cuXhoThIHsDFzAisDa9ZLNbnCj/HNrF0o66MWBCjxDu2nkkxVE5omsepCNaWRv/S0+W8jedR1C/BwwQAE3sTRttj6hgy7Ky8yS0jb22yTDvylYCCH6ErL2gHzKxXd73xpvRZB72jNT9IVMhvdIwfoGaa6dFY9KhgsIqO7m3HkrUSwrdPCAK/DACN28=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/23/25 10:25, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> In CONFIG_SPARSEMEM systems, page_ext uses RCU to synchronize with
> memory hotplug operations, ensuring page_ext memory won't be freed
> due to MEM_OFFLINE during page_ext data access.
> 
> Since page_owner is part of page_ext, rcu_read_lock() must be held
> continuously throughout the entire page_owner access period and
> should not be released midway. Otherwise, it may cause the
> use-after-free issue. The sequence is like this:
> 
> CPU0                                        CPU1
> __folio_copy_owner():                       MEM_OFFLINE:
> page_ext = page_ext_get(&old->page);
> old_page_owner = ...
> page_ext_put(page_ext);
> 
> page_ext = page_ext_get(&newfolio->page);
> new_page_owner = ...
> page_ext_put(page_ext);
>                                              __invalidate_page_ext(pfn);
>                                              synchronize_rcu();
>                                              __free_page_ext(pfn);
> old_page_owner->pid
> new_page_owner->order   ---> access to freed area
> 
> Fixes: 3a812bed3d32a ("mm: page_owner: use new iteration API")
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---
>   mm/page_owner.c | 21 +++++++++++----------
>   1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index b6a394a130ec..5d6860e54be7 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -375,24 +375,25 @@ void __split_page_owner(struct page *page, int old_order, int new_order)
>   void __folio_copy_owner(struct folio *newfolio, struct folio *old)
>   {
>   	struct page_ext *page_ext;
> +	struct page_ext *old_page_ext, *new_page_ext;
>   	struct page_ext_iter iter;
>   	struct page_owner *old_page_owner;
>   	struct page_owner *new_page_owner;
>   	depot_stack_handle_t migrate_handle;
>   
> -	page_ext = page_ext_get(&old->page);
> -	if (unlikely(!page_ext))
> +	old_page_ext = page_ext_get(&old->page);
> +	if (unlikely(!old_page_ext))
>   		return;
>   
> -	old_page_owner = get_page_owner(page_ext);
> -	page_ext_put(page_ext);
> +	old_page_owner = get_page_owner(old_page_ext);
>   
> -	page_ext = page_ext_get(&newfolio->page);
> -	if (unlikely(!page_ext))
> +	new_page_ext = page_ext_get(&newfolio->page);
> +	if (unlikely(!new_page_ext)) {
> +		page_ext_put(old_page_ext);
>   		return;
> +	}
>   
> -	new_page_owner = get_page_owner(page_ext);
> -	page_ext_put(page_ext);
> +	new_page_owner = get_page_owner(new_page_ext);
>   
>   	migrate_handle = new_page_owner->handle;
>   	__update_page_owner_handle(&newfolio->page, old_page_owner->handle,
> @@ -414,12 +415,12 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
>   	 * for the new one and the old folio otherwise there will be an imbalance
>   	 * when subtracting those pages from the stack.
>   	 */
> -	rcu_read_lock();
>   	for_each_page_ext(&old->page, 1 << new_page_owner->order, page_ext, iter) {
>   		old_page_owner = get_page_owner(page_ext);
>   		old_page_owner->handle = migrate_handle;
>   	}
> -	rcu_read_unlock();
> +	page_ext_put(new_page_ext);
> +	page_ext_put(old_page_ext);
>   }

How are you possibly able to call into __split_page_owner() while 
concurrently we are already finished with offlining the memory (-> all 
memory freed and isolated in the buddy) and triggering the notifier?

Doesn't make sense, no?

-- 
Cheers

David

