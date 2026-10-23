Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E4E1606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 11:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=FAsL8Mng
Received: by kanga.kvack.org (Postfix)
	id 6EA8B6B0B38; Fri, 23 Oct 2026 07:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A536B0B3A; Fri, 23 Oct 2026 07:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3B16B0B3B; Fri, 23 Oct 2026 07:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 373BE6B0B38
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:11:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C9A1C1A03A4
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:11:24 +0000 (UTC)
X-FDA: 85353624888.26.94D5444
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 01A204000B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:11:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FAsL8Mng;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792753883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZZkxyap/7dlUZUT4UQ++G0HXHd1yXMsqlTCYWXzFUY=;
	b=qKNv6D8hdE8N7qzL0nl8N0zutdyGtZyXpI8yUlmDfWOb0PC0nyl0SWi1ZACAMy4vOF5uJl
	OTlRv9gJIxvZuE90B1TUNZc+T8X2inIOGXe4jDEEJbmeAlVxhjvkCB45u5CMTaPQXMz1sD
	Y5mEWsBeA5iNm6aFakuMrcQcw2OfFjs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FAsL8Mng;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792753883;
	b=DwR8jL4Opa2r+MNnygJEUQSVDd3JwDr3ShI+FVAFUkbSPy8/xvJJHCitBwQWYzQbN2E9iu
	KsXFnNEthB5UgL9ParJCOV27CeQdDQ4zlpYRTbYoZzXMz3j0q8Hi6uNoGjPj2pD7ggxHJo
	tSCyQUb7/BLa47pNKemCwRbALqn7lOE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C531814BF;
	Fri, 23 Oct 2026 04:11:18 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4412A3F7B4;
	Fri, 23 Oct 2026 04:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792753882; bh=hzRNH5SZs+yfGxmNNryzFab0nRLdeJhjiE2/+3MJwO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FAsL8Mng6IPldGvEH5YqSMzj8yEY55gdPl7o0JRr8UygQWqYXKEqqLJRMkMes2F3P
	 f/74bNgaYi5YsKmwTGXnUNMbkCXA6grYyfnlKbN5HA98X0W6pyiVkCYRQaAdpED+gX
	 ZXz7xocv6h+KEyyYLQ1EUq8TGqQFTD+mCQNECWrw=
Date: Fri, 23 Oct 2026 16:41:18 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com
Subject: Re: [PATCH] mm/page_alloc: remove unneeded forward declaration of
 __free_pages_ok()
Message-ID: <e3s4abh434i5osy2jkhy7aifhtytzwnkbvdben5zaeesq23vgn@7cupaxhi2ao5>
References: <20261022124504.75642-1-zenghui.yu@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022124504.75642-1-zenghui.yu@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 01A204000B
X-Stat-Signature: tarysm1bckrnc7p3cwbgpiwtkeqqdwwc
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792753882-520832
X-HE-Meta: U2FsdGVkX1+W9DhaltmyNqp3m3r63JBocjyiFbYZneI8R1Q99S21e7J8FrU4zjKRlOCUsdqZU9GlpyCePueOHHq/cb3ZJUum12TRvRwGlB2yskfJwBoGJnxg9hBF1KJP9Kj47uNaqK7DeQgI7PvbUy2HkMttrhV/s5qKVno/+WivnyWaLMDLAk1Boukc6JPtTGMGI0Hw62UUw7Ed17XpbuSwBwU4wIlXbh3s2D8U/u6xBzNk4NUtMUBz0q5J9OOkQ+YkaKlGbLep/rVlLJbosjJQDCNnNg8j67zzp94lytyZAB75Ib9ug9NNGonoOO8BBKV/1Vpb8lEBLbQIXCYtlickLlPsC8SdEpugx0+dxXZJRDNyuXZ93E8l0O1M1Av5mQg65A8h+uh4J1p/2CFi90YzmV+/6aDPRf38fst4RKShRrlGfR8Z5Wknnnbs9b1KN0HFWJigQ2PMIb3bQIBTLusGLebiTt1sPz0XOlUbFdAuvihaiois5UshjeQUo8dmjTVakCihce76jX7EL0VHXRfZPsHwZEwabS+jLj6C2QDpbuQZ2n9F2SdbipOjizPmnPY7nhfG7IZDV8Y93UnEhFGCICnadCS+9TI5gYbYwn3YmCIHizOFHOUoaJdkYYXEbrniaRa0H+AAhcPVuzEcMcpm/WN9YQfsL4ViXtlrXbhQA21x2M6rZszkIf9hfNbhDcamFgAoPs2tkr2RuSQk3ujUJj6i7Q7uiQnARdS3d0eGyyvineBCxSm+ugb2DqkDB3T0o46PHGEHmh+OLbOdpH6hJsk/kDs6T9vZ/tyZzOpLI/dk23bUeqt2QUjrhynKZP+QoGX2yLdC3bqCxPS7y8KVOXKwG8P3cG08+76KwiijxfxuME7p79kOLSaJiBgANbGHLi6VwujiVGNNsTAaeIVZn51vCWgmtt4kw4pnWaV41iEPg1So15eXnVb6PTdiFwUnCU+nKeuoABL5bMl
 fo9y/SWQ
 ZZ4IV+XKY9fGLIeJtK8BFRRvhrerDk/hr4CAcg/T8IE1tKheJOBxqlbSw+rNxDyscLDj/VdOI6cXR6FRgF48Fvt4wncC4K0lLcq/zWqrjrs1w3dA+FD4wIPvhRmj8VmJJXEwbGr9zvJH6ykCYCFsi9id2w4Bu7Bo1KsxqHUm/+7l58Aw8DjYunRMYZDP/hsF6QWWLFtAMLHJiQ6COeOEBKtfTVCQUTm/9XysqiMWGEb0LSh9ndZLwrbmKLjVLkyc+734cgO0v9mTrscoIk2wuDnhK1W+NBUhFLRASsl3Ciql1EIykLIdnSgPsrxesmni+iBaZkJ16SaLmKOLrbRxqhnxMJChcAW7VRtQNvcoQhHVFl5FPXyHFv/yPCCqYXVltwqky
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 08:45:04PM +0800, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> All remaining callers of __free_pages_ok() appear after its definition, so
> the forward declaration near the top of mm/page_alloc.c is no longer
> needed.  Remove it.
> 
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  mm/page_alloc.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0396c50b96f0..6db90e0aa929 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -216,8 +216,6 @@ gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
>  unsigned int pageblock_order __read_mostly;
>  #endif
>  
> -static void __free_pages_ok(struct page *page, unsigned int order,
> -			    fpi_t fpi_flags);
>  static void reserve_highatomic_pageblock(struct page *page, int order,
>  					 struct zone *zone);
>  
> -- 
> 2.56.0
> 

