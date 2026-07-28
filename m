Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E59C5C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 06:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C807F6B008C; Tue, 28 Jul 2026 02:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58A96B0093; Tue, 28 Jul 2026 02:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97BA6B0095; Tue, 28 Jul 2026 02:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9025C6B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:12:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2EAA16030F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:12:57 +0000 (UTC)
X-FDA: 85037167194.24.B29D7E1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id E9BD9C0006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:12:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=r3gkHQC3;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785219176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PgUOtTB4h5vS7OHqbc1w4Vj+PhKmwjj9lP80RWdtCHo=;
	b=r21qTk4FbK2XFX6BpZjVHwzWnUDsQ2uAPXcHiy9ga7KlcN+lCIcGnzMI9WWpCZ8nwTBB7X
	xpdKwhpSAwW+liro3qEzSh04qQK/m/nuEKu2oIYi7+bcenP0y8QhxR8+HbtHwLRQDD//3N
	zOAPk3iARSq12VbP//6ddE2WCVFO72A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785219176;
	b=bAjPwL3vEevtXRCyEmAU95tJP72neC29woiJgu15x9qKPay5tXgGNCPCrVSY6FNqOe5Imh
	xwRE1uLW4jjS0q2FVIz5KIpJKcrjY6HYo+Co63Y/7eruPD1+k5AZ8xmeBnQpECaGyH62bh
	q0M5C3fjGIt4hOMp+EGL5TNuElz2njs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=r3gkHQC3;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9442C1BF7;
	Mon, 27 Jul 2026 23:12:50 -0700 (PDT)
Received: from [10.164.19.51] (unknown [10.164.19.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 96AB93F66F;
	Mon, 27 Jul 2026 23:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785219174; bh=b91PzJAS6m3d0mLPBuksaYLOMk2xknc8mZLXVjVh+Pw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r3gkHQC3Rxd7tUgANOXWNow4vrs8PU2NFSD1divGBytcs7mGWL5XFgs6hO+aAkFoq
	 ffd2LJ37v+2zJ+aqOrOJEvAytJobm0HzKIiQv9RDoH8n11IjjAZeXIBzZZHKo4WrPr
	 GUnj7JNp23tKlOonf8AkxkceG13kBBrP5Hpm8vLI=
Message-ID: <65e0aa09-cad8-4898-abc0-a8115ae43976@arm.com>
Date: Tue, 28 Jul 2026 11:42:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: replace mutex_lock/mutex_unlock usage with
 guard macro
To: Jakov Novak <jakovnovak30@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "\\ Liam R . Howlett \\" <liam@infradead.org>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, linux-kernel-mentees@lists.linux.dev,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260727181136.2542-1-jakovnovak30@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260727181136.2542-1-jakovnovak30@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mkjq4sqca54e7hfpbhn3wqjq9faj6j4j
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E9BD9C0006
X-HE-Tag: 1785219175-189459
X-HE-Meta: U2FsdGVkX1/HUCAPRx/qk+crqWpGthMYxzU/5oiJmsLG/5b65yACe5YgLp1dtCR4F2f85hJ1vrae+oo+S1ObX9kWcenKmdetRRZuTKeivnLu9ZB+aFUKIOjSkLgapnWwsLIBLl5vut2SbIy6/AplcgWUAAKqY3BDatIJs2ZFskjH19OzKu+3wpJFJnr+czMzZPFUyp8TQhZcdagkI16zQzglGf6+Tt3gK76lZ8bQWKzF5TIJzGXqBJpRigKCrk6QQwiGmb3i4d7G3A8cUyurnevURM5QNWkVMPejwNijocCjClqI3LNqUdVHJHgPuft67wv9p4Kx+elfca2nesqHSmL826oNGrZgQPW0sJnajRyP/sf7caqXBgGbCSyR22YZz3IEetJswl8UR6Pm9Ag0/Ydk3HYtXxh8Kbq5EcqFXnf2BNGiruGyPRWEw64OvOg6Ng5pocPu6AdnigSyiTM/NXPxoWHZvmECYC3NFn0DOcNKN2W4ONHkXMm1VlmGt9QhnzZJsktiugnogdCjLQ32dSjGz9SGW0a/zKeEHlQXRr+e8QLIul+NnPIN5jaIVOyBgSVL3PN7sycHBFMkEyfvLnqxXWgLm+E2rIiltiQinUqfTlibrONxppvn9cB+KQ0evO/dFvbvCVLUagn6C9VlvSQYN8nAto+p8iGDtYp6bSmLBYztl77f+LidsfGhVfyKp6/SurZnKGf7MD883LUfAV7azarrhbaM61IhgdWHa64kXvRV4STfSTs1QYNbGXAFsKBQaeUK3NIV0qc6sS7mDEQFQ9VBg5w+YyRgfrPzHhVJ5UqK2GJFagH68PMfvfDN17z/wmZ1s4fXXRyGzckCxRbCGv9PNS6pZVJ/18hqoAHvnNEYPh/DEdR+YNaaPiHh91BMOaIh3pVHAYlNsipuNjgi9JjnOoJoiWppigaQzfXwKPZFDN6ElI9nJE8fN9Kz3o4QVuCgVY8mu5ocGGs
 KjGon8T5
 Ga0+HGFDJjtRn/wvRRtRsSK+Gc837iNzugK2DARJ25DhJy4vAUu83nSzJjj6B3DsVnp4H2npOLZSpdwv7ZVjD7cd2FvZFjFeK3k3TQKCdMvPDOKIke+KModjujYhAyi8xfs6Gnqvk4hXhVyv3MhbSMkYd57a3n3+CGNgAVhlb8qF08288sNQn1lBb6W836IZuFz36tsDk04gd9eEv/n6ZgVqsNUhDcsJAVyFETEAqpoLrYfvLwbYMzC+NSE1lsC7Td7x0qFDbzwPcFtucSdGex2d37TK9Aw6ApjbB5yZnyK3F/GmvbhqgRdur4NCPSsWMI1RNx+3g4hzztnpnmXDbmM1j1J7BScX2mjnfWlG7qrmvVvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/07/26 11:41 pm, Jakov Novak wrote:
> Currently, khugepaged locks the khugepaged_mutex in two functions:
> start_stop_khugepaged and khugepaged_min_free_kbytes_update. Remove
> mutex_lock/mutex_unlock usage in these functions and replace it with the
> guard macro. This makes the code more readable (removing a goto statement)
> and makes it harder to introduce bugs in the future.
> No functional changes introduced.
> 
> Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>
> ---

Thanks.

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  mm/khugepaged.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 617bca76db49..c583867f2e7a 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -3113,7 +3113,7 @@ int start_stop_khugepaged(void)
>  {
>  	int err = 0;
>  
> -	mutex_lock(&khugepaged_mutex);
> +	guard(mutex)(&khugepaged_mutex);
>  	if (hugepage_enabled()) {
>  		if (!khugepaged_thread)
>  			khugepaged_thread = kthread_run(khugepaged, NULL,
> @@ -3122,7 +3122,7 @@ int start_stop_khugepaged(void)
>  			pr_err("khugepaged: kthread_run(khugepaged) failed\n");
>  			err = PTR_ERR(khugepaged_thread);
>  			khugepaged_thread = NULL;
> -			goto fail;
> +			return err;
>  		}
>  
>  		if (!list_empty(&khugepaged_scan.mm_head))
> @@ -3132,17 +3132,14 @@ int start_stop_khugepaged(void)
>  		khugepaged_thread = NULL;
>  	}
>  	set_recommended_min_free_kbytes();
> -fail:
> -	mutex_unlock(&khugepaged_mutex);
>  	return err;
>  }
>  
>  void khugepaged_min_free_kbytes_update(void)
>  {
> -	mutex_lock(&khugepaged_mutex);
> +	guard(mutex)(&khugepaged_mutex);
>  	if (hugepage_enabled() && khugepaged_thread)
>  		set_recommended_min_free_kbytes();
> -	mutex_unlock(&khugepaged_mutex);
>  }
>  
>  bool current_is_khugepaged(void)


