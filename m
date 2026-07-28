Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F69C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 14:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48FD16B008A; Tue, 28 Jul 2026 10:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440D66B008C; Tue, 28 Jul 2026 10:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37DAC6B0093; Tue, 28 Jul 2026 10:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13F096B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:58:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A28CA0283
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:58:01 +0000 (UTC)
X-FDA: 85038490362.11.7AD37BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E7F7040009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:57:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I5Zl3o/K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785250680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XavTPYhZ1V6grCtqsli6GAmQEIr10veG6My10S97eVs=;
	b=CZiPQxk87eZSIfWi6pf2BZw71rYAvaTWox/D1xsxIciKxfpW4HQ0QTb3x69OiaCDe8jv4/
	weL7VouonNnysza1gqH2Emi6bUwWhiqjXXEuMI/DXdlR43XVUUJ+VO1L3lLOVdGZjmQX2G
	1ITV3ag2WStmUPcD2klatm27C0vOAPg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I5Zl3o/K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785250680;
	b=pPDE8x5QaVHPVs1enNS0vZ3U9l4a7iNYEgRvLF8iJD5tYlSPCnBUn1cfMLpnAEsebIlJq/
	x6A87TbK1gKLHJ0MZPgTDQYigfpB1bpN9HTEKPebDxl+iUqClkv1EzLCU+Q7J6UfGfAqRu
	38p8t1JNfL03uc99yTRCzkV6I2HMNWM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DB6242DD9;
	Tue, 28 Jul 2026 14:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933441F000E9;
	Tue, 28 Jul 2026 14:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785250678;
	bh=XavTPYhZ1V6grCtqsli6GAmQEIr10veG6My10S97eVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I5Zl3o/KJt/SGX5J5Z5phrw8JlXv+eibePTs2ZJb2OlniGjrxZ2aLybRIZH3u2DF8
	 RlxQLhdRoZCJjorNirlbXq8823hufnnYDGZz2u5d2AEGy4iEAZQQC+/4e2Ndx73WSV
	 LbExnPGA0r2PxPagADbQI2Jf5khFxHpxri0JA16SFX+TDjaSZ/I3ItepmsAhCMoyJa
	 eC40WOyQzHxoCW9cjDVyY8Sy/qxGM6TC+b9IxE9RWcVOdWkcydcIcu5aVRdRe/Uvdc
	 YLVSfMar3dBLmIiOfJG1Rx/0zjzmvrRTLnWtisxhkn1QmaSZZP31waSxoHFoEeJkJR
	 iVDmjXRq16VyA==
Date: Tue, 28 Jul 2026 15:57:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jakov Novak <jakovnovak30@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "\\  Liam R . Howlett \\ " <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel-mentees@lists.linux.dev, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH] mm/khugepaged: replace mutex_lock/mutex_unlock usage
 with guard macro
Message-ID: <amjCQJUDNYseR6y-@lucifer>
References: <20260727181136.2542-1-jakovnovak30@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727181136.2542-1-jakovnovak30@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E7F7040009
X-Rspam-User: 
X-Stat-Signature: rwtxojifsf751s5ehtxqz3rz9zprbt5e
X-HE-Tag: 1785250679-381187
X-HE-Meta: U2FsdGVkX1+CgAx1yaKMElue00VKDZlVj/leeA1M260/kn+r0v5vpOa3RuY9ls5ik3He8gydTUnSre3N3ZozJgH+ORSP1DqYtTKcMwOkbhWQvq0tOv4GmVI9TwRUcoXeB+tZpLlQSYB0/gUnHeQHNaGgm4Q2kIPqkJocqyL4NgVwOIK3mtvM+uobU0CRlManA9gctu6Zxw/Bf3gT6rTuRTdgn7gv2YSUeRLuAgSSe7l5w8EmjVfyRv+feQPejJ1J98Ip6rXYaIzqZuCDex2BOiPtqTXJl/w/iQaAocR1u52OoeYs3KDUnwYMxvCDivGUhqkqzS6sczczPNUm+R2FmrmIbZaMy+UGKQNr0tKDmqWYlvTXa8gM2K6sp5tYSQEnuUX6B6xHxoTStWLX3LJ/vv/7MwOBGXwNw1imyklORAhIhC1tMaRWmuckIdEMkQpiOh94uzT/iJjwYpKgjPQd6hvFsEAHQ3UqqYhzK6Q2wu1ISyuUA0QVH2f1NHRsNbv2KtC7bqDDJ4dmmaBWu9GI7Nmlk5FjSYJeQnYanrHol7teiDyxuTEL+soMUEYcslq6DIhNIM5bnbAfKZuao/lcHMc2E/WXdQ5l24H7mAZWqGs3bjyRAxiHuwZ5S9aBLLfZYWQ7b/KYH0wgGvRZyEPaIeOOzIjqFkq179ck8F3XhTQgHFpjdsyLLQ9x/ejMFx6gEpUJxcrS1shND6n8O3vOBwjY3+IirkKm7g6AQpFz7tRTd6UCVMUNwZbDPXN99a8upLPOFsB0j4fV8NGx0+SkJunaIR9ChlDhuFr8QeEIm0/UoRPoVlhmmJ1s3n9rRy2REyjwDuzRn8fb8t7GWBg+0lr4D8U6gZXmVrksbLlebs+gC/9fwoNB+4k8RMYfDM6drjSv/oY9bRfP0bWj35oEGQJxmWsXxx70H4k3vYm+HCtJRAKar1H+rHqlJrSi2uwz1uVSuXtp/+UkoyAlOgy
 oAm50JNa
 zxnjiuBrr4FimZPJBfp+oM38UlZL5Trs6eVJDDsKxWFzHI3mudyYKLEYifUoGYlxhAmxFPlcCllmPBQa4e96TP6xS4fG9N/Jg/Yg4gPw9mlQ6dR+kEaNf6yOplPFnSPI8UQjoIue5jx2vLfNhwxTUfS6OwMadxEE70jKDlVUUAzB8UqlVrzE6R9q1MBHlBdVI6XQ+qVNGyBeJNmUMspCHuO5g5s68j3h2L6DdAv1V7fxKafzCcAJOB+0IFcp6quNW26SSqGPscop61Q4iBehdzgze9+dyNlfSjDXfF1BVLquuIBP/pN3LSn4VkqZptRUpgoDEu0wEOlRxhL+eWbjdisaMNdYGfCUt4zZZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 08:11:36PM +0200, Jakov Novak wrote:
> Currently, khugepaged locks the khugepaged_mutex in two functions:
> start_stop_khugepaged and khugepaged_min_free_kbytes_update. Remove
> mutex_lock/mutex_unlock usage in these functions and replace it with the
> guard macro. This makes the code more readable (removing a goto statement)
> and makes it harder to introduce bugs in the future.
> No functional changes introduced.
>
> Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>

Various nits below, with them addressed feel free to add:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

To the respin.

> ---
>  mm/khugepaged.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 617bca76db49..c583867f2e7a 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -3113,7 +3113,7 @@ int start_stop_khugepaged(void)
>  {

Please add

#include <linux/cleanup.h>

To the #include's up top.

You might get away with not doing it locally because of recursive header
includes but be better to be explicit.

>  	int err = 0;
>
> -	mutex_lock(&khugepaged_mutex);
> +	guard(mutex)(&khugepaged_mutex);
>  	if (hugepage_enabled()) {
>  		if (!khugepaged_thread)
>  			khugepaged_thread = kthread_run(khugepaged, NULL,
> @@ -3122,7 +3122,7 @@ int start_stop_khugepaged(void)

		if (IS_ERR(khugepaged_thread)) {

Can we move the 'int err' declaration to here then? And not initialise it as it
gets assigned below.

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

Let's make this return 0 now.

>  }
>
>  void khugepaged_min_free_kbytes_update(void)
>  {
> -	mutex_lock(&khugepaged_mutex);
> +	guard(mutex)(&khugepaged_mutex);
>  	if (hugepage_enabled() && khugepaged_thread)
>  		set_recommended_min_free_kbytes();
> -	mutex_unlock(&khugepaged_mutex);

Nice and simple!

>  }
>
>  bool current_is_khugepaged(void)
> --
> 2.55.0
>

Cheers, Lorenzo

