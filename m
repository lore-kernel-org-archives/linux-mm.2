Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E824DF43686
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 09:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD1D6B00B7; Fri, 17 Apr 2026 05:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D486B00B9; Fri, 17 Apr 2026 05:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D8B6B00BA; Fri, 17 Apr 2026 05:11:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9486B00B7
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:11:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D146A13C069
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:11:36 +0000 (UTC)
X-FDA: 84667479792.18.F3164F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 327F880007
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:11:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VtVx276i;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776417095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAES0UuR/WntZyJ443ThO/9g6b+V7S3rRAI+p/NoIAY=;
	b=q1KriI2SwpR8xDi0vZeFv05IeVcDAE7ZqodMzUM1UVYGTr5Z6LSWavq+HfKb7voUWRON7e
	med3KNCZBDgewGNKW0rimUK+501smqROucPb5pCkpZyYLQB4Po/fJKEXEDSQSeJgI5haP7
	RpKow6mwMGtssCG4yp7daXEHyg2Yel4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VtVx276i;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776417095; a=rsa-sha256;
	cv=none;
	b=KeBBIexTFpUTMZX8zzJtG+4lOJv5HM2hvkHjhDCIPudcKWg4ZPJz+krKc1UjZ8bryAb77b
	4JyQC7GUyOmiWFEERb+Ysp4GK9pcyTMDiFzOOC28LVJUkwuqN01dFYVIWL4gr3fe9rHGhM
	2Em7zDxSN38D3ya838E15L0mH2qo5mg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9422160138;
	Fri, 17 Apr 2026 09:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FAEC19425;
	Fri, 17 Apr 2026 09:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776417094;
	bh=b9DebVhvg3kMguhZCy3y+KwHTug2uDLeAd0Plgmcc4s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VtVx276ikd8VY5G/3b9udrxO99gGFLmUPQkhx4AKxGVhfBTcOq4MzDQjajqLfL1bD
	 PaIJoyjhOB5bqnxjh5DAg/CgM2hxtBYXaiKVfei39lAD4sSf5BACulYZyHjcjNkw25
	 bcQ5sDPRBh5HuJtiOhMnyqnr1FPB5tM4X8MMfYj2KWoKIIHi19GenyJ4aMnfT6KRmi
	 v28nyAmseut8Fky0sIJ+x/yWSwFnAxEtsQtIQuuhVaQPkx31nCUGnVA2EU65QJxYC+
	 JEEG/uH/uxwtcDykSvnfBEaEvgmOw0JKSQv5n868HhcAdWdPnJEDCjSS1RA3s/5n0G
	 uikaIEBV2EKdw==
Message-ID: <3a6e90d0-59de-4eb6-ae3d-56aaaf3e5354@kernel.org>
Date: Fri, 17 Apr 2026 11:11:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slub: fix data loss and overflow in krealloc()
Content-Language: en-US
To: Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 stable@vger.kernel.org
References: <20260416132837.3787694-1-elver@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260416132837.3787694-1-elver@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 327F880007
X-Stat-Signature: otpwbsfah9kag9xu9cr33r8zksfsj1gx
X-Rspam-User: 
X-HE-Tag: 1776417095-326946
X-HE-Meta: U2FsdGVkX19s6TU3mMHlqnySQi1UNist47VscBWYnn+HdcRyPBtf/LO0tDEvzteZ8bW2RnY0AbEqTlGAp01tJVMX6VYhFyGE84Z8obNf6ykTnxuPBnHJdC34Jp8id7mz+kgHqMoqzzgSvYdHmvr7aE1eTp3LJr5lpTLx7u5QFtKsk76p0RCMkJrHWMvzskWV7eXGrnoS0mYJjzWISeS0hrCN9mDIS7V03qgO0c7qsX0xydmKxFPuo6iy/0ukJ970xXjW+25nyAKPknv4KqJT42OeiOTymkhG9FmcLa06MsjUYlmtpSZKh52F5N8MfrdRhcEYIvzRTYX7zyn1MLN47FcPsV2qgYlFzN4enLtSzcn67KBWCgBRFvVyvWvHRF7K1Sx4AHnnlvx1sQ0OHG09lu6YZeMr0i74r7hpDc7dYfMIKQ9Vh8xDkiIAH5ubQxyxGjujDCONk7xifjp12obeKAdGXecdHMKd09pRsKJ1N+wvsJlfKbvL1V7eKEHS+GLsHQD/71uJ+sdDE7+XcUVEwHrbn1KTBwB0vMbNHLCdYagWzOHbyQQX9CoV7SG1xbEp3QUIq6x0YLQtip4Vabeg1eDqW8jN4IJlsfGdm6wRysPHVVLUi+CsKKmUXOADQp9ffAx/oqJvkuN2/3JwMczMvYG23QiEdnW2D/+D+8WzlwVFWFtyXQjXl/l7zBSSHCoYBUNgeHZI7N6xUWOeEiq1a4eb92FSP6A0j0rMSNsrryjHr8iZrQxo8EMxkYkbtt71OKFx8oo4qiduhQ0y/PTqkJXQixml6Xfj4EOpxy+N5yB5IZi1ADy2xkZQj2ERl6RnqeNIw7BTKZ+IkFMMrylECscvPg7PYBsL0IW6egXqM8VLqF8ahnY3G6VRBouC12iH04FTd9EELdJ2v7cIkAXiuqqrbGx+JnP4angEBQ6K18Ibp7huDfBHFi/DqTqyaBUoRd3khX9xTjNSRLToziN
 HYMGUin1
 eVJZC4iRwLSOYAleMVY6CIXUph7SV74rCeZIXIa41pYDU1i4mHJ/3hGzEY0GyFIos0F04aPcE5Ll/bho7jd+AbIL+HrpIuYKPcPRtuGU0Y6s1aeNw75zX2gIglaJp4GjCpmz5fH9kfu7vxtnQ3pg0RbFfbPaMYOPbUYajcYvSgu7ANlCqG5gT7Sj4CQkSkZSbwMV2wFw0tkJpsrxLVWUIln7vk96hyNoyKCXfl3WnoU8PYudjmnWseJFCd/k/mwk3THXR6cmp8R/NoL2BeT3KlaHa0B1//1P4WkgAHPl8NIlGmlo/OgcnC9N3v88qe901TKaF6ICuODdd/pw96g16edCNv4n7g8luTHxln2faCYCl0Fc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 15:25, Marco Elver wrote:
> Commit 2cd8231796b5 ("mm/slub: allow to set node and align in
> k[v]realloc") introduced the ability to force a reallocation if the
> original object does not satisfy new alignment or NUMA node, even when
> the object is being shrunk.
> 
> This introduced two bugs in the reallocation fallback path:
> 
> 1. Data loss during NUMA migration: The jump to 'alloc_new' happens
>    before 'ks' and 'orig_size' are initialized. As a result, the
>    memcpy() in the 'alloc_new' block would copy 0 bytes into the new
>    allocation.
> 
> 2. Buffer overflow during shrinking: When shrinking an object while
>    forcing a new alignment, 'new_size' is smaller than the old size.
>    However, the memcpy() used the old size ('orig_size ?: ks'), leading
>    to an out-of-bounds write.
> 
> The same overflow bug exists in the kvrealloc() fallback path, where the
> old bucket size ksize(p) is copied into the new buffer without being
> bounded by the new size.
> 
> A simple reproducer:
> 
> 	// e.g. add to lkdtm as KREALLOC_SHRINK_OVERFLOW
> 	while (1) {
> 		void *p = kmalloc(128, GFP_KERNEL);
> 		p = krealloc_node_align(p, 64, 256, GFP_KERNEL, NUMA_NO_NODE);
> 		kfree(p);
> 	}
> 
> demonstrates the issue:
> 
>   ==================================================================
>   BUG: KFENCE: out-of-bounds write in memcpy_orig+0x68/0x130
> 
>   Out-of-bounds write at 0xffff8883ad757038 (120B right of kfence-#47):
>    memcpy_orig+0x68/0x130
>    krealloc_node_align_noprof+0x1c8/0x340
>    lkdtm_KREALLOC_SHRINK_OVERFLOW+0x8c/0xc0 [lkdtm]
>    lkdtm_do_action+0x3a/0x60 [lkdtm]
>    ...
> 
>   kfence-#47: 0xffff8883ad756fc0-0xffff8883ad756fff, size=64, cache=kmalloc-64
> 
>   allocated by task 316 on cpu 7 at 97.680481s (0.021813s ago):
>    krealloc_node_align_noprof+0x19c/0x340
>    lkdtm_KREALLOC_SHRINK_OVERFLOW+0x8c/0xc0 [lkdtm]
>    lkdtm_do_action+0x3a/0x60 [lkdtm]
>    ...
>   ==================================================================
> 
> Fix it by moving the old size calculation to the top of __do_krealloc()
> and bounding all copy lengths by the new allocation size.
> 
> Fixes: 2cd8231796b5 ("mm/slub: allow to set node and align in k[v]realloc")
> Cc: <stable@vger.kernel.org>
> Reported-by: https://sashiko.dev/#/patchset/20260415143735.2974230-1-elver%40google.com
> Signed-off-by: Marco Elver <elver@google.com>

Ouch, thanks. Added to slab/for-next-fixes
Indeed the vrealloc would be separate patch with different Fixes: commit and
handled in the mm tree.

> ---
>  mm/slub.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 92362eeb13e5..161079ac5ba1 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6645,16 +6645,6 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
>  	if (!kasan_check_byte(p))
>  		return NULL;
>  
> -	/*
> -	 * If reallocation is not necessary (e. g. the new size is less
> -	 * than the current allocated size), the current allocation will be
> -	 * preserved unless __GFP_THISNODE is set. In the latter case a new
> -	 * allocation on the requested node will be attempted.
> -	 */
> -	if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
> -		     nid != page_to_nid(virt_to_page(p)))
> -		goto alloc_new;
> -
>  	if (is_kfence_address(p)) {
>  		ks = orig_size = kfence_ksize(p);
>  	} else {
> @@ -6673,6 +6663,16 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
>  		}
>  	}
>  
> +	/*
> +	 * If reallocation is not necessary (e. g. the new size is less
> +	 * than the current allocated size), the current allocation will be
> +	 * preserved unless __GFP_THISNODE is set. In the latter case a new
> +	 * allocation on the requested node will be attempted.
> +	 */
> +	if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
> +		     nid != page_to_nid(virt_to_page(p)))
> +		goto alloc_new;
> +
>  	/* If the old object doesn't fit, allocate a bigger one */
>  	if (new_size > ks)
>  		goto alloc_new;
> @@ -6707,7 +6707,7 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
>  	if (ret && p) {
>  		/* Disable KASAN checks as the object's redzone is accessed. */
>  		kasan_disable_current();
> -		memcpy(ret, kasan_reset_tag(p), orig_size ?: ks);
> +		memcpy(ret, kasan_reset_tag(p), min(new_size, (size_t)(orig_size ?: ks)));
>  		kasan_enable_current();
>  	}
>  
> @@ -6941,7 +6941,7 @@ void *kvrealloc_node_align_noprof(const void *p, size_t size, unsigned long alig
>  		if (p) {
>  			/* We already know that `p` is not a vmalloc address. */
>  			kasan_disable_current();
> -			memcpy(n, kasan_reset_tag(p), ksize(p));
> +			memcpy(n, kasan_reset_tag(p), min(size, ksize(p)));
>  			kasan_enable_current();
>  
>  			kfree(p);


