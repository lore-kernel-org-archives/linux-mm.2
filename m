Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B3BFC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0D76B009B; Wed, 26 Aug 2026 05:28:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C86B6B0101; Wed, 26 Aug 2026 05:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DE966B0102; Wed, 26 Aug 2026 05:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 334D96B009B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:28:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA080A2E94
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:28:19 +0000 (UTC)
X-FDA: 85142894718.02.1FC6E3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1805D1C0004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:28:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkFXSijR;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736498;
	b=RMlolmaISxlz6hayN7lVSV8ZC3ZkKOEkqT5vaMu8w1ljUS0Tp11ula3Pyictqf1/K7rsEw
	Z+rXpg+uAH3fzPboT2xv3+wYNv2DVrCaSWLzRRlLALkbCJfvcHZCPl3KQ/FakGZ+TXXnhv
	+a66VhNvOdPM6T0k2XOQDYx2PO2CPls=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkFXSijR;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkPDzgtqpJZ+C+pFu3IpQfmXypArccQSfZj/VF6NMbQ=;
	b=2yWEmQUwkmnyk5qyq2wqbcEt45LgDvYM9xulAs8t2kKS7bpRHM+X8/034yJ1LSyY3013MW
	gNSM/4lw2ijoQRjJNkpC+T46yvm5VE2DsMbGgbgWhSHm8DU2XqwoWgITpzdk+zAJtMxOSu
	gRTIqzO0LrTWuJEDBjUTuKBw16VDnX0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 621B1600C4;
	Wed, 26 Aug 2026 09:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751711F01561;
	Wed, 26 Aug 2026 09:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787736497;
	bh=VkPDzgtqpJZ+C+pFu3IpQfmXypArccQSfZj/VF6NMbQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RkFXSijRbA6EM3ZrjDU8tSwuriXKTTOKjpopi5CErpNWTeCRYBX/qsSUpyn8Ggw/R
	 kPodnkEfLkODpYExzkYsht60y+Ht4NVpAtwCjHkGW071tyXfWzKONDRORVx0+2QE2h
	 zAUsNR84Y0VJkVKEYg+xwJ/PsQmf2mhC46R5H69eX6Rj0okfWJkL0JaWA24/a/ue6K
	 8S/3idW0QkFMKJ3nRlZj8zfw3V9bg3e/B1zBxkMQNBUagKF5Fq7fD2KGSvyp8gNOXB
	 7N8bQJJqeIvVJDE0sVvbKo0VkfJSliyfgJII+5KVQG+v9W2NAhWYpNB1mlsc33s3gV
	 W90ZgP8IBSMLQ==
Message-ID: <82f138f5-11d4-4839-94a3-c226fd982715@kernel.org>
Date: Wed, 26 Aug 2026 11:28:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: reject unsupported kmalloc sizes
To: Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-usb@vger.kernel.org,
 syzbot+805630f1453e490427fa@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20260817-limit_kmalloc_size-v1-1-5bef487701cc@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260817-limit_kmalloc_size-v1-1-5bef487701cc@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1805D1C0004
X-Stat-Signature: ba1zhpqz9tidohncb61opcffwxka7kb1
X-HE-Tag: 1787736497-435895
X-HE-Meta: U2FsdGVkX1+HBM2kYFN2Im3vA6NSdSfbbbo2FqzqgKszp2kHOXtm0jEVVWc5u0n/+7uMuOBw9vaHHxeRDGupw5QKGfyOnYeN2MW/Ms9IilCyao/jW0wdpFzCTcZ7INApazS6Zk9yDCOhWyAKLH+Q+HJEhWqdQFqrknsaV4PGy9No0ppxbLyBikzDN+9h9+noun8CYqEmynZM2+KXuJYYEjNGgwVGbLEiPHHDisK9E0RZHvkxugL7gz/OzPYLzIPb3wcimXig2kTFXQf2/o6RJmTzoXYXRwUHE+k2TVXzXmrApeAVfDy+Hc8Mawxx6ZVMZ4pKf5+kpd5oSFm+E/lP8+c+Zi2I7gOPU4HIo9lBcniCLdriLGpxTYffqENlgqJumO1fb4XQVccns+y5VWQ5AivkhAtEKw27gFOQowTzOx2szIIBzW85EaBSxxOMPXqtYk8wWryzWvt/BPpJFGLs8H7sPub978jpnkSqPSVys9LFDOxFOHJVyND/lV3Hrf0E1yGglE/CbNYYKCaFxSybM4KHCgg9awmo/jjZ7HOXG3WyseThVON2e34hvGIgD+vn545BUAXLR0fQtBeIJlkg6rMcpXVivNs+Qt2gxp+NMexwhylnnuSyTFzLEEJBGKejPN+UX3MiUlX+8iUpeqtnVmWnqzj1+udY3+0wLvrTOjedrSR2lQ4xAjagLCl/PFbXTTpZyJSzfsgwhqbw0RaGIfafKjKMOgE7ey6D/uyHJ///ZXibJqD2l1CaGvTAyGM4/oh0O/1SkUBpWSUB5euI/CGTtgcGYJviO+eeNzFb1fhh3pcad2zFewKTO3RbUgL6PIy1ng15Ezt9GdlTQkIHLOxxOZhCkkCA1sDIJd/HUdscT0uvg5eEFmY/4TWbscp0F9iGziwOnf9mGA2nY7NI9v21p4to6+dVhLH+lV2MTgBZ983JcMYF4j4DIfuSg86qQjd6cN05lwoMA/aI+s8
 oVUjWIuH
 qM9CkBk2vaBrmarKQj88fFJUvGqYerCh+BrKmHrBi9p1u/+N4Lt/gIN3S6VJl/M7a+/GLtw6PUaH3YdekrnWg9jWktD1pmiK0ztSD+Nopm9pXPY5oeGTSIL6miRHfNNvSlsY4FdZEvRUDh2r+PY40jDTKemKFdpwNsmiDHUgkUCBu0zeCirMqT9UtmBSqZetajzQwPAFJOVwf1oYo0/uRE/rGEe9Sraka4tB8QcEflDAUXk5KaSTMJR8ajicQE0myO7G4qcg6bRo6+uV+p8/ibSEP87CZIPJ271NEXqaQmlCZ/XVU3Ei/5QPqb5Lc69mD85tnkzHb0Z6QYmgzo9RjF+xbKj5V4hEbPJ0mfKdY4bdSxlIIAt1U8Wmyd2W4AJHMLGvCDP9UjGvnE6YSDfPgorxwZjDjHIC3wv746Mk/yf28h1h4tYy1HDO4vwvZW5pSPOP+gXSzMBInB05i3JKNnuXqaQ6uryrigdpXTWJbs8oD4HIgDA/d0trVP6WwBoKoVpldlDU6FNDdNWl2gdA52sOT/5Jj5vsQ6Fqh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 22:40, Zi Yan wrote:
> kmalloc is used to allocate physically contiguous memory for kernel
> allocations. For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc uses
> the page allocator and can only support up to KMALLOC_MAX_SIZE. For request
> sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a WARN
> because kmalloc allocates an order greater than MAX_PAGE_ORDER. Systems
> with panic_on_warn=1 crash because of this WARN. Fix it by rejecting any
> kmalloc size bigger than KMALLOC_MAX_SIZE.
> 
> Fixes: aadb4bc4a1f9 ("SLUB: direct pass through of page size or higher kmalloc requests")
> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com/
> Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Cc: stable@vger.kernel.org
> ---
> It fixes a page allocator warning (order > MAX_PAGE_ORDER) when gadgetfs
> requests excessively large memory from kmalloc. Instead of adding
> __GFP_NOWARN to suppress the warning, as was done for usbfs[1], change
> kmalloc to return NULL without a warning for this specific issue.
> 
> [1] commit 4f2629ea67e72 ("USB: usbfs: Don't WARN about excessively large memory allocations")

So I checked and for kvmalloc() we have in __kvmalloc_node_noprof()

        /* Don't even allow crazy sizes */
        if (unlikely(size > INT_MAX)) {
                WARN_ON_ONCE(!(flags & __GFP_NOWARN));
                return NULL;
        }

This comes from Linus in commit 7661809d493b4. I'd do the same thing here
then. Thus there would be a useful warning for e.g. development mistakes
resulting in the size to be unexpectedly high.

Callers passing size that comes from userspace or similar untrusted source
can either pass __GFP_NOWARN or sanitize the size to what they expect to be
sane (which is context dependent and I assume actually way lower than
kmalloc limits in practice). Note that passing even sizes within but close
to/at the limit, trusting blindly some external source, can succeed the
allocations but effectively DoS the system with heavy reclaim/compaction. So
caller sanitization should still be preferred IMHO. Some of the recent
arguments from Linus [1] would apply to this too, I think.

[1]
https://lore.kernel.org/all/CAHk-=wiSmgwwLKCqJwGS-dVHnSLU8W+7q1UQq-G9=TBGGZbuhQ@mail.gmail.com/

> ---
>  mm/slub.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 0337e60db5ace..a3071f4ef1945 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5263,7 +5263,12 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
>  {
>  	struct page *page;
>  	void *ptr = NULL;
> -	unsigned int order = get_order(size);
> +	unsigned int order;
> +
> +	if (size > KMALLOC_MAX_SIZE)
> +		return NULL;
> +
> +	order = get_order(size);
>  
>  	if (unlikely(flags & GFP_SLAB_BUG_MASK))
>  		flags = kmalloc_fix_flags(flags);
> 
> ---
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
> change-id: 20260817-limit_kmalloc_size-3a4a2c73beac
> 
> Best regards,
> --  
> Yan, Zi
> 


