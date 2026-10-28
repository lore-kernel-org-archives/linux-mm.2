Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E064606A324
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VVZwcwyV
Received: by kanga.kvack.org (Postfix)
	id 510DA6B05B0; Wed, 28 Oct 2026 12:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1C06B05B1; Wed, 28 Oct 2026 12:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D7706B05B2; Wed, 28 Oct 2026 12:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16F786B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:08:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FC1B80154
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:08:56 +0000 (UTC)
X-FDA: 85372518672.30.81B9BC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9F9044000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:08:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VVZwcwyV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793203734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vo1r+wQbOzLzCV+CAr1Yh9jJ1GiuCBkoMlOOYp8Wt4=;
	b=Yi4fBLJdsEuHyVYg1XGaVqZWJulivq+rhQ9F8yJCMf6SgyrpPbOZ22lLtwxRel5uIcghod
	jHZJHwruBAxXj3XmrMCVlyt9dPfSOZ1HSZZCv4lImsAq2Iz5wtCnCYSaeowUAPQwLvqxO8
	H+dWBi4TLEZaTkpkcbyf63K9y/1N9KQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VVZwcwyV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793203734;
	b=Y2iUPuiTNT2DQ4wpeu4rK0DRAkdjnXsy0Ovt49G1zYId5JP1o9rcxvNiFcCD/WT1ksodpb
	y8Zv/NQW9HD08V1/ZCg5LF2Hk6iDdMGg4z0MgCFevlTVFlTiimoyhJVhQ+K+Oj/iOqpyJ8
	wy6JmldLgL2L619P+vDexeQdgTN2C+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD70443BDF;
	Wed, 28 Oct 2026 16:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8711F01301;
	Wed, 28 Oct 2026 16:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793203733;
	bh=8vo1r+wQbOzLzCV+CAr1Yh9jJ1GiuCBkoMlOOYp8Wt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VVZwcwyVvSGy32C+lIKbS30eALeGvBJZe+g4bcBdMztrsf6jMbOXEq8QfsnHf6XsN
	 ZaYNXTWdnRcvpsl5OoIe1oIb8MyPAhJPCGdcR5u73Cy76hqzvj9H76jSUKwkbxpEV/
	 agYoy6aZXGkzxcOo4xEF5c47SnvYEXeM1bD1gRrlzKC3kIGzqwwxIgNrAuPA6TY8Jo
	 /vm80F2+VKdZkXF+LTNezNOC0eRYYCXwxq1On7B4ooG8w/c3qHo7K8vYWYrealIc6E
	 WkxCdcMc84FLf9C029GNywxwIMZ6vhKpxVMIUYXbILBccEptSNycsEZG+z0U8K1Dvk
	 kdO5rYESs50hg==
Date: Wed, 28 Oct 2026 18:08:46 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm/sparse: simplify the vmemmap alignment check
Message-ID: <auIeDjoOQej4AT9b@kernel.org>
References: <20261028121129.39916-1-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028121129.39916-1-kaitao.cheng@linux.dev>
X-Rspamd-Queue-Id: 9F9044000A
X-Rspam-User: 
X-Stat-Signature: cwewqjusjfj9guec4nc9e6xijseqg633
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793203734-675240
X-HE-Meta: U2FsdGVkX1/1qw3IXUO4BKbFWwpv57PZTCEetST5hOo8dzSVwQDqtvDgxpmj1n06zDcMINZTCYyVc173QqkJWfd46Lols4lQQGJquYK1QFDUJNIMAXFbrmceNMo2emDpImWhDVE9+I4M+xR60D4mx7gnrTUDY/QrmTzCoBVBc7WUBsKSox8YyS47lWmrx9msj8j0sxKxtKemIpljwktxLF+IUUz816h3DnC3xjh/GtbJH80DQKkZbvTUE871FTgqRnMs4RUL0D61201pdqPUvSVF7YBpfIP8rjNjR2LWWZth1CdR//3wNI0Yrtalk0h0rIEwqAylxS3mwAdlnBWS1VMFBUHFChURdqMONMNdrx7u8ALxeXa5dfTLVwjmHTm8W14WRWn34GfzyJ2clg0OILRynbQdvsDoe9I7nQvvGwwaXyM8hYGpSn5Q/8XOBLh/NQcDbrseD400f05eRG9If87DKw/rG1ycBDDNJM9i1l0bDXamzYwrrgjlfFH/lLXlvP6MOio6kjZfWb1dxbh7k1NuYX/vbcywsXtDjwyv3XVGG3E7dOEzF/3bLcWNwCny1vGSnECw2utrOj2BGugdd7mMjq9zEyF32mk/5lwpTzjNGuWvkG0+XTaAbaECMp19FSSlxNgfKh2bhddzpK17eW7ZFDl0l3CwOpYqm0vWDtmbzkAB6fvvv7zw4jEkv3KgtE9e9fHE4sco0haszEzwNyKrV7Ot4PYTQ5Ln4JFx6CYrlQ294dHNPylJhMkqeucFe2TwlXEapobVWKTP0UF5vPS1PWW6ngYz2Vj/tL2eFDZRfD8cyJNt71gLADTzNSLr+/50TrF8Z8ZnKCDK3CBufW8Mn9VijESuglQGEGFSHioVUNIApOpKJlZSaiDU+HuFI/nbCOWH8Szd8BPDZoF0FgYuulsoLzT2nLaLVztxSXf3bt3X02FVsv8MypNrsyGtRMR3ZpMaBTLjRehEvNI
 Q6oXIEvn
 Dw9YgR0oP5aTjkJqHngwLHMswNvZ+XR0pwzlWpJI58pSP6zlZ0uwdXlvwuaukvyXC6lK86mTE1EiHVQowm/4oXvbA/a/RAIM+3/fC1OvkwwsasXbEUD+nBKP3gPPIi4MXiaC92qxQ1w4NOMBwvFySKjjC36LD+MtwxYVvtBRjQ8voWjLRDUXmIkeJV9TZ3Chm79rnbyGWIbm1FpjjTJpYeHpUVka0On2LXipsVko4AQfVktQNcRisTAjSVR+J/g8ZHlGq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Wed, Oct 28, 2026 at 08:11:29PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> sparse_init() is called only once during boot, and the vmemmap alignment
> check is outside any loop, so VM_WARN_ON_ONCE() provides no benefit over
> VM_WARN_ON() here.
> 
> Use VM_WARN_ON() and fold compound_info_has_mask() into its condition,
> preserving short-circuit evaluation.

Do you think it's worth the churn?
 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  mm/sparse.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 6acb628c8a73..248bee2d39b9 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -277,10 +277,8 @@ static void __init sparse_metadata_init(void)
>   */
>  void __init sparse_init(void)
>  {
> -	if (compound_info_has_mask()) {
> -		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
> -				    MAX_FOLIO_VMEMMAP_ALIGN));
> -	}
> +	VM_WARN_ON(compound_info_has_mask() && !IS_ALIGNED(
> +		   (unsigned long)pfn_to_page(0), MAX_FOLIO_VMEMMAP_ALIGN));
>  
>  	sparse_metadata_init();
>  	sparse_init_subsection_map();
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

