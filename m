Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF310C4452B
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 00:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15296B00AC; Tue, 21 Jul 2026 20:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6516B00AD; Tue, 21 Jul 2026 20:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3326B00AE; Tue, 21 Jul 2026 20:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 673EB6B00AC
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:55:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E089416014A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:55:47 +0000 (UTC)
X-FDA: 85014595134.24.2EE1E14
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 883D8A0003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:55:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hWtJVb9g;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784681746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0QW8ZsmS+nE37A5nW/s8wH8YzZiNTBe124WuGdmmtU=;
	b=2IaFArsm4o6EbhxJEfUBjkAZJJneryW38DfZJ7J9URzLk+iBpfaW3iZgl8833gZA1aWC3y
	7VdOXd8tHljh8NzP+Sa2uwLuuVYxaUVBI4e5krSKb9N+dMpMVCfV8Ackw1vZ1uYlcQ1rwr
	bhJnbmS1HDStsilWb2T6GGt3iBYYqV4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hWtJVb9g;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784681746;
	b=R4NNMxLC/ac3cGJTRaMyN/HGs7XmYJCrmEfh4NLquXjn1re+ZYXa75I9uF5a6GvFLfLVZN
	lb4ulX0OXl0IS1ODyIhKf6NUpiTzW+K3Pl6VamfnKWdKc5Jldln3nOqWtIHgkC0cM2u6f6
	ujxsXYV0J1KQe6fzyljEV+Nu33l/gP4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE628600FC;
	Wed, 22 Jul 2026 00:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732701F000E9;
	Wed, 22 Jul 2026 00:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784681744;
	bh=U0QW8ZsmS+nE37A5nW/s8wH8YzZiNTBe124WuGdmmtU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hWtJVb9gAKDbevXQH16mN1PBzSL0omMRBophVdF5wVB80PYyvhZKSBymL4sDtfSpN
	 2rxPd4LwvBeYJuC8u27gjjqBfCcxNkLi72yxHOh6MKoY2BTNgql+vI2eKyvYfTg6Yd
	 va71f/k+h+LUbeBtvQSsX6/biO02PW6Uw7vDKFNo=
Date: Tue, 21 Jul 2026 17:55:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, David Hildenbrand
 <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hugetlb: evaluate subpool free state while locked
Message-Id: <20260721175544.11f896c43d2b0fa1cf80c1e9@linux-foundation.org>
In-Reply-To: <20260721035207.1437935-1-chenyichong@uniontech.com>
References: <20260721035207.1437935-1-chenyichong@uniontech.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 883D8A0003
X-Rspamd-Server: rspam01
X-Stat-Signature: 98g6kg47iz5u3c3z4tqwpdq5ewycfoxm
X-HE-Tag: 1784681745-985266
X-HE-Meta: U2FsdGVkX1/C9Uis+45O360dVsjx13LoI+D6n2QuH4MYbYHanqxE1vX/qha3YmanjzmFIXvVdrgl2LVIThQeKlqjJiMTwDieEOWhip82qC7r2gkZH6laBSNpie9KPLQoD+D01aOfnVheJozIWQ+bhQBtQv4v+5zdwy7cQFldW41pGwlNhXZhP7mIte6OiIypd8lhAKbJwFlHyOnf+03L1MyjG9bcicIIi2ev/WQnSnUB3PCNOp5hIML97BiFXeMTySDI8AK4w+bf4pyBeMMCtij2iTDl4pAUI+ezyXhGfvzj2cnQsd8bYkTF4U4dG4yckWNH/ZwfMGg7iS3h4GREmPbk/OOXKkVIEJRkZYiGbLbzPeSTOqP5FtY1guQJhHRQOudaKx0xXWDbaqNhrXJsuySetxIecZtKZOBlXMxYmn03Ax/UX0dangyPb0eqwp6NctVAWrBJRdtGAmDMnCVFaJu1KvOJLKIBv+tTtpVDk8Acck5aJ41E5PyJne8ePGDA2aCi6nu9BCw1nI7p0WexxbnTtz5FrplJsR9qk+K4MHPGRZ+iwWGciS8PtX0nFFR/8Z5JReQqIp4Po7Zjccdkn9DtRQ2xrrUBF/cunJMSNAnWCpqHaN8TQqnJQRRy/6/m4CNxSyVzrHlrvdFsmZCFRZKOlTfuv560iTmBMZFthK2W8kBG/fpI3kDUnYP1zx+5qhdUJnod2qHcMpj22LNajhGlsjpHAsJvOKW9I1nO5JyZdqM8KMgRBTjvNh3/QwQme/DF5vnUm05N2pvx4jtajFuEOOAKUX6uLb2wuZ5wNWECuGH5MJmcj4i7pINokWSTNwBvwoQCaa2XmeVUQejG59BqG7zy8W3lmu5xqIrvW9FsFsS03OWvyaUBGn/CTLz0Htb/tKHXvVLDeX2Y9SObPMEFuBO08LgfDYUOQ5tJQoYL/lTdxiNQZ0shihhbl3e1c8XkNG5Vm2xWAf6ZQyz
 rRrj+l4z
 NVlsYRjTty2NPSAasFNYYxYUbCtXoD/7LNOPOkDZ+tpHM9cSNF4qDYpocCVefQy94g2X8PK6Xw/dgPqS5SbNOONGB4d7JRo5uAqI1DLqkTHGgxUR4ZBqbbdcx9HDV0pH0T+27gGfdPxZwiUppWhuO+AYpPGW7rswXc5T6c5AneBNaQlbZR0mSyfrN7snURGY8RldMEacXmBBS935gH5Qemfqd/lbzQagktMDPCffVLPMpvdyWDhs9ADigfxm2KKsT1CL27iMfg6FdfNw0LfDQVVoCFEmwyRXl5q2xNxqo23knVU0KWwYCIcnf+e6DCJyJ/GQqbs0STiTUJZEqPVdZyz2bX6dmaOjOvgxrgFyy/XPmQ0oOQWL5QQ8LGeoRAbkp/rv/9LBXTuDWIbKlRK09sPjT4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 11:52:07 +0800 Yichong Chen <chenyichong@uniontech.com> wrote:

> unlock_or_release_subpool() drops spool->lock before calling
> subpool_is_free().  However, subpool_is_free() reads fields that are
> updated under spool->lock, including count, used_hpages and rsv_hpages.
> 
> Keep the free-state evaluation under the same lock that protects those
> fields.  The reservation accounting and kfree() calls still happen after
> dropping spool->lock.
> 
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> ---
> v2:
> - Reword the changelog based on Joshua's observation.
> - Drop the Fixes tag because this is not known to cause a user-visible bug.

Retaining the Fixes: would be OK.  It's potentially useful information.

If a patch doesn't fix a user-visible bug then we consider it
inappropriate to backport it (by including Cc:stable).  The -stable
maintainers have been asked not to backport Fixes: patches which lack
the cc:stable.

>
> ...
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -140,12 +140,14 @@ static inline bool subpool_is_free(struct hugepage_subpool *spool)
>  static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
>  						unsigned long irq_flags)
>  {
> -	spin_unlock_irqrestore(&spool->lock, irq_flags);
> +	bool free_subpool = subpool_is_free(spool);
>  
>  	/* If no pages are used, and no other handles to the subpool
>  	 * remain, give up any reservations based on minimum size and
>  	 * free the subpool */
> -	if (subpool_is_free(spool)) {
> +	spin_unlock_irqrestore(&spool->lock, irq_flags);
> +
> +	if (free_subpool) {
>  		if (spool->min_hpages != -1)
>  			hugetlb_acct_memory(spool->hstate,
>  						-spool->min_hpages);

OK, better, but the value of `free_subpool' can become out of date as
soon as we drop that lock - some other thread could get in and start
using *spool.  If that subpool is still findable, which it hopefully
isn't.

