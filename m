Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71BB5C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5465E6B00A7; Fri, 31 Jul 2026 16:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7446B00A9; Fri, 31 Jul 2026 16:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40CF16B00AA; Fri, 31 Jul 2026 16:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C44A6B00A7
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:31:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 837C8160150
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:31:52 +0000 (UTC)
X-FDA: 85050218064.27.439E2AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B4B6E40003
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:31:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bq6sNpWI;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785529910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWjmH3n1jSqN2OxBU+GvsMdSKEdt6YvjB3RUAiKHypc=;
	b=sHV9KYOH3bM2cwP5FCdqNLBgoncg8vpnw4YeI7FY54k+yHLnBM3Bw/FjdfbEAMLzQ+SjON
	0Q3MZnUZqqtU8Wtd33j6liTrjGpf7OxBj5JiVcUJsoZrc2WKq9tJx2q/YY3MCpqO1Zce5i
	sRvE8qzuUIXSbeCW37E16ArGenK+ma8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785529910;
	b=SXp9QnSoZjgoZL2sXB17o38be4HUhxIJcCl/jL3poyCfUo4hcqsDRGrjnlIqs+s3xEiTSd
	Ybo9EyHOrz9jT1PELN79gs8xUJrEYFtKleOrAZToYx2y2o+lDW72uds/5uItXbAN0+3THb
	5L+37/9sKTr4vkJjwoEGm0Wel9JGFcg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bq6sNpWI;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D9E141500;
	Fri, 31 Jul 2026 20:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2141F00AC4;
	Fri, 31 Jul 2026 20:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785529909;
	bh=pWjmH3n1jSqN2OxBU+GvsMdSKEdt6YvjB3RUAiKHypc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bq6sNpWIjDU/RF+4UMgTybXKuFiWty9pVvPF7RaJxO/L7F9E4a9J9U64Rlkd4a46/
	 4dsDFOKdHBHRJaV7mQ0qlLYv/ur32hczBNbB3ipSoVQ43SU8gra+Nd6y4M97p0tNx0
	 IrwAI7UWY1kAgdw2KvRtkk4NlzoNouDSZ8/7u8A0=
Date: Fri, 31 Jul 2026 13:31:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhiling Zou <zhilinz@nebusec.ai>
Cc: baolin.wang@linux.alibaba.com, linux-mm@kvack.org, hughd@google.com,
 vega@nebusec.ai
Subject: Re: [PATCH v3 1/1] mm: shmem: reject page-aligned fallocate end
 overflow
Message-Id: <20260731133148.44d0a05cbfad8859c7276e7b@linux-foundation.org>
In-Reply-To: <1929a466735dcbb9438936ff50b7a4fc2332a8a4.1785377919.git.zhilinz@nebusec.ai>
References: <1929a466735dcbb9438936ff50b7a4fc2332a8a4.1785377919.git.zhilinz@nebusec.ai>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fewgn97rt5y5wiojsh3rjqjdqy47nakn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B4B6E40003
X-HE-Tag: 1785529910-165826
X-HE-Meta: U2FsdGVkX18YuZJRboJ/QGrQLLA0Ln93E6mYrcoxnWZZG/YLwjrnhzy88bXpvEJrLdbp4fuJR3TrcojTpcGgiV979cAxeEKxC0hjMYlTgogSKYdmnQOhjSMxVITrBWGmk2MsIVmGbe65F86pMjsLOhY1txnFsvRCAAf/h18IL7toqMb4e8/E2R/21m5idSxFHZ9kZyqjb3G8vhDoD6fG5ry7NmyTxLD8h+Ouzv+DZGPafUSxhQBp0Z8A4psE8hej7bYydn5vCIiCGu54pZU3/DQSlx9HPe332+cbzuQUEm+TVt8JCeuzzf8YxnPhhdwfRwPkivBVN3rLAkvwB2p2I5ggxEJeVOBGkVhrVcz9RPcx8RZXtKvxslDL8SriKuFy13QjLhQ0jIubb0RI1rmtyji8t8wpGoxJf0z6vBaYSc5zwI5HmecWqo2PQBwghbmehUclbOnMZlNA7UI1xobJwVtKuAzsB5MsDDrAslYAeo3qhzobu0iDJdcva0CspQeB85UnpS+O+rKUTLS1mmbvoOzwHoyMaFWO9VQU+/xoAJidFNBH+NS95r0ckd++ohccyYS5qRP9o8tsMw3uMd7K6oKO4BUTY1GWKnf5u3Yk1VZBMLxK5NTWRWhEtpwHdBovchwLlc6FUcJ4cQhw2kmmjnTICrVcgRo7OdcjB2pqEoOlD04uC8b3xTKTr08A2HXC7Cqca+SpCWR5QQYWO+JBsPVsfbJNhq0t7ies3E5BNrK1X6OaWFFFUVv3WsRIsUrrwWiaWZQzxZ+tcfj5gjoa3ERZGIcBzDzNGkDzCQSIpZB/tn6hceNoGl5RGSQFNIW2PE3E8kaiAyRnqYmCenu6tZl7lkMOjUB9KtQE/uCS6iQ9V69UD87uSnFKbT9TCTZGk6+urxeSfKToajGls7/NVTapL4JTvo+5oPD/9c3MvcpNryw25Qv8m2X6Z3HZEhnmUZYNuzWXVwZ7J/N7FX8
 tNCPIZ/1
 A5uaJnpo3TBEnaYXroJPYht9XfwMO3b46v/FPzyJYTogjljEox2rUGGDWiaG7G6i/9HrNwmG9di7WjrlmfaoiTrNqul8EXvZuP6KIf4qpOtt6NhbO+oaQOlHXmhkjcbrUkru1El6DvN32BxDnafSQvIvhfwFRxN8EwmzOHFs2YrwAN8NFzYWhoBW/JaudK+/HxgIJLKdj7P8HXWbOTvylnhc46pyK9UzOTR9pZUFIKz2jW6N5QJVcLATrhDm13MHzSY8w2MSQbZPQwH0f4fY8YjYlCr/xt9uNpHqigWSt9w17nknd8eVlbnJu4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 11:22:51 +0800 Zhiling Zou <zhilinz@nebusec.ai> wrote:

> shmem_fallocate() validates offset + len with inode_newsize_ok(), but
> then rounds that end offset up to a page boundary before entering the
> preallocation loop.
> 
> For a valid request ending at MAX_LFS_FILESIZE, such as offset = 0 and
> len = LLONG_MAX, adding PAGE_SIZE - 1 to the validated end can overflow
> the signed loff_t used for the rounded end calculation. If that wrapped
> value is then converted into a page index, shmem_fallocate() can enter
> the folio allocation loop with an invalid range.
> 
> Use check_add_overflow() when calculating the page-aligned end, and fail
> before entering the allocation loop if the rounded end cannot be
> represented.
> 

Thanks.

> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3602,6 +3602,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>  	struct shmem_inode_info *info = SHMEM_I(inode);
>  	struct shmem_falloc shmem_falloc;
>  	pgoff_t start, index, end, undo_fallocend;
> +	loff_t aligned_end;
>  	int error;
>  
>  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> @@ -3658,8 +3659,15 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>  		goto out;
>  	}
>  
> +	/* Check for wraparound */
> +	if (check_add_overflow(offset + len, (loff_t)PAGE_SIZE - 1,
> +			       &aligned_end)) {
> +		error = -EFBIG;
> +		goto out;
> +	}

AI review suggests that there could be a new overflow condition here.

And it might have found a pre-existing underflow.

	https://sashiko.dev/#/patchset/1929a466735dcbb9438936ff50b7a4fc2332a8a4.1785377919.git.zhilinz@nebusec.ai


