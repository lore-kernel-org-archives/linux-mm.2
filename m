Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D70EFC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 03:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC61C6B0005; Sun, 28 Jun 2026 23:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F016B0088; Sun, 28 Jun 2026 23:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3FAB6B008A; Sun, 28 Jun 2026 23:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 787EC6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 23:27:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFF77C2865
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:27:54 +0000 (UTC)
X-FDA: 84931516068.14.005B705
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf29.hostedemail.com (Postfix) with ESMTP id CAC00120003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:27:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RfTJj7YK;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782703673;
	b=Qj9Fhf6+XIasfoJnkno0N71RaunRRUuFX0CECDQWhrVruNUaxlRRoRzwJZL9sE/MAk98eD
	x3JLMNHp0fsg80NKUq+q91rlk5Br5l6MzJiyRiRDueBDz6M/8F6FKkJpX7B6pD92yHebtV
	rrO1SjmqFkKmT7cGgjrvKklCsZyw//8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782703673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnuCCBI3ALRCI/rId03CW8nskbsRqSLSxoX75VBaEXk=;
	b=SOTkqdQNmDDw7i+8lR/Nj85FG7UwHtTp/OhatlExf6WYu7Ekwv2zr8X5SaaYUM2spMMo7j
	vqxhUImDCVt8see8D5T9Fn/VnTDKceWvBRAxSoe6H7NesLDVuyFnJIofdCL6o5NiNFYPzu
	5WbJZpnwAhSKF2yn8ohQHE6lotl5g98=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RfTJj7YK;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782703669; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GnuCCBI3ALRCI/rId03CW8nskbsRqSLSxoX75VBaEXk=;
	b=RfTJj7YKpeDTQ3aJjFkv/WBW1D2fp49pY4xzA8oxgMBBIDKygUX/fclParcqHDhact92MYZuiQTyaMmPhUmmks2nzt5bFL7wxjgJYh5NnIKUbwHoJSl8Ob9g8Cr3Dx6dQtS0Y4+h6Lo2c8EYiJPO22fGn1uCT4mMYysFd6ucuVw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X5luln4_1782703667;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X5luln4_1782703667 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 29 Jun 2026 11:27:48 +0800
Message-ID: <dde92cd4-c6fe-4339-a892-004ca78ebc30@linux.alibaba.com>
Date: Mon, 29 Jun 2026 11:27:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tmpfs: zero unused folio tail for long symlinks
To: Yousef Alhouseen <alhouseenyousef@gmail.com>,
 Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 syzbot+bf5586280a66e9ccdfa9@syzkaller.appspotmail.com,
 Barry Song <baohua@kernel.org>
References: <20260628004314.27370-1-alhouseenyousef@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260628004314.27370-1-alhouseenyousef@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CAC00120003
X-Stat-Signature: 8mobbkugo9f96481t56ptw71kmnzdnby
X-HE-Tag: 1782703671-535616
X-HE-Meta: U2FsdGVkX18Mf+7cvYZIGGKCs3SuzaMIefhyVQ9/5xBqAD0dfHtwdz3QfO6eM1LdQriWFOAuWSuDNLOdBFGownHkJ/tMneet9ogwFw0B6x3sUQqAsO/BKZId7z9+fdD79oiQoLvCoFLNYidqEJ/O5RC4UFKUVpULZT2rjhV+Itc6rw6PsrF0DoOwxzOZC8iToguBwEc5flgNVIeHvfMxEkeWwWkXJZ7G/SjoRikCI+LOSbrgaA67VHbXDz5r9eSScS8NgPH4YBhcryEFvIfLVeatc06XxJieLAZG4gUG8LB+9fnv/CpRKnN0zQs9gMRghhzyxUc/ls/3RmhSnDmZX1kTwvC5RC4msHor9+lwF5U/g+5YMTH/mbB5Q8SuDFSBZIWXwEB5kRcpcVJdFAtuMbNUDgF0L8u2Ohg6pVqLMsc+p+VyZK7EAxIanoUG143eqW0WoOqwPx1hjVVcD6G5i/Ougkkj3/3Oc9T/CyLP4GGg6bH7mkh1yw/IUUngJg2tKLVUzFxcrS0Q4uqIvR5C9bEP3L/EiGbapb0mb3nlk4gGBl/jW+6ZX1vHIkEh4wH9tE3wHhfiBhvRmeJyidz6X60XUG3uY6luRMDf51ifjd9g+xs0kT4GrBtDEBRtlnwYhzWk6yb/UwLaIPyRgV2uH93H4Bk8EaSWt6c+xoQi5OYbuj7/aTdrfN7zQo0Qu9s0DpyPgAgFWUgdx2QwWILBO/xVOlvCfWaUcDO4GlSLqHdVa03bDAJpBPVP4TAElZwl/5Q0MwBB9aF0eGQJAWyX1axgdsE02giNaLsDbgMh1MBORz3TMPL+w5dOWeT5sIFPyRRnfGsZlQPoyYb55MLa6AG5Schb9zpGJGRyzybxyzIsJxE4CexeYrk3irADcIbnj2SjnJW+fjsI8JsW1AlZcBq6aow5ljdZ7GbOqY15XxNuVUjdmzAKMqziN5nbr5PwaEB5s96sH4Uo6YFdQnH
 q0PQsRuo
 CY2ezWy2nUbaLoGGQ7JZmfr3sPtBeZVxvfXJMS1ftygqcc16qoWkR9C2OTLEmxLhBnHrzquB5r5ILDgEuAGpyf+pUY0uQB2XXwkNXC6Pv4j2Ddwkp5u4IJ6fBJR6+lLqxts+wa2y0tcA505UohngbI1912umuahLx7v0B4LK5j7xnw0M0kuip9dGK3j36bxb9Mx93vDZom4KRM3Smqr84VqZKzD4ciYak6sa0+J8wGJWvUCI/GkqJWmPJjyhIECV2TktkCbNabMtuJlm4RWIkL8g8BPDihJczDJGvTaEB7cvrKlq/GvXtvGfVVFW0E1RtdeN3/tKUly1vSAe+zX7ZY+0crbzjIc/Rma7x2vevp+YhReN3JNgJ45Ff3KLSgT2KI/EBQR4LM3LLDARiEjW1NZrI/vl7BzfQ8WRNuAd+U7ICF3spyQZTbZ1rfQg/jV0gQGEnXs6M95zBs1PBcWiq2FSV1HCK82WAwYS5nqX3aUFzq/WxgjutAQ3jWjUXkVwFOPZTMNfrrssjA5SE4XsOWkSUgMHkyc7Hrq2wg8Hypt1YmiGKlZ/1Ywmr7nBODwi3lkn/B07RaYzQO/5ZQDiHrEKGrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CC Barry.

On 6/28/26 8:43 AM, Yousef Alhouseen wrote:
> shmem_symlink() marks the entire folio uptodate after copying only the
> NUL-terminated link target. The remainder of the freshly allocated folio
> is left uninitialized.
> 
> Reclaim may pass the whole folio to a swap compressor. KMSAN observed
> sw842_compress() computing a checksum over the uninitialized tail. If
> the folio is written to a swap device, those bytes can also leave the
> kernel.
> 
> Zero the remainder of the folio before marking it uptodate and dirty.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot+bf5586280a66e9ccdfa9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=bf5586280a66e9ccdfa9
> Cc: stable@vger.kernel.org

Do we need CC stable? Have you observed any actual impact?

> Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
> ---
>   mm/shmem.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b51f83c970bb..b06c1ae2f50c 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4057,6 +4057,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
>   			goto out_remove_offset;
>   		inode->i_op = &shmem_symlink_inode_operations;
>   		memcpy(folio_address(folio), symname, len);
> +		folio_zero_range(folio, len, folio_size(folio) - len);
>   		folio_mark_uptodate(folio);
>   		folio_mark_dirty(folio);
>   		folio_unlock(folio);

Thanks. Barry sent the same fix before[1] (though I forgot why it didn't 
get merged). I think this is a reasonable fix. So:

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

[1] https://lore.kernel.org/lkml/20251224020424.52976-1-21cnbao@gmail.com/

