Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36FC3C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 05:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E4A6B0088; Mon, 20 Jul 2026 01:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CE916B008A; Mon, 20 Jul 2026 01:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F27426B008C; Mon, 20 Jul 2026 01:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8E5E6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:54:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F6AC120783
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:54:42 +0000 (UTC)
X-FDA: 85008090804.01.629CBBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 46CA0180007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:54:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pov8w++x;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784526880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vv5OoFLFLqo6apFeODcZIfFoAiaXPCnVVI60/8Q5tKM=;
	b=NkHOKmUqU6DCfyVcWvORszs6H7ksgRFZwFF6wMvNJy+AKtcXQQCNHYkpTCZDVUehV/yk4n
	GOAn84GNxMqi36NaRVVT9WW0/dWvr8O4+bvqwoohcsW+tBCxfaG+kCZJrMKL+kU3OL5dY/
	3IinZ8EJHM8iHtLRMJbg+gqxilTB8+E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pov8w++x;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784526880;
	b=Hq5XmOywbwCUlcYQ71XlgPf59tlfi4DagZ2DNUgPriYNlpaP6FkuYbpNkG9Ffo5Au00+G+
	DaZsNG9gJXz14aftQyn4ZVVqT7vA5Rl84Nr7ShrO4RX9hN+wfzEd647cTQzGFZJKG9plEI
	fYT3M8HCJjlyOQyVf/hq3Mzg/P9i0FQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B895B60103;
	Mon, 20 Jul 2026 05:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C32B1F000E9;
	Mon, 20 Jul 2026 05:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784526879;
	bh=Vv5OoFLFLqo6apFeODcZIfFoAiaXPCnVVI60/8Q5tKM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pov8w++xeZevdsFadUk7ss39KjD08TW37Hn9WpoETxN/x+3rJjbZPz0DVqqNTKq9B
	 vVCHiepmPkpzuMCGf7Mhd9OXm+2d9h3r1k2uGQZvt74eE2fUrMNmUVI/QsA488KDJc
	 vyt7+eko4EjwqMbfqAuJfNzLY5Iv3l8OA8QzE6IQ=
Date: Sun, 19 Jul 2026 22:54:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Mike Kravetz
 <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlbfs: release subpool on fill_super failure
Message-Id: <20260719225438.041287a56c87effe61796483@linux-foundation.org>
In-Reply-To: <20260720021900.1376309-1-chenyichong@uniontech.com>
References: <20260720021900.1376309-1-chenyichong@uniontech.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 46CA0180007
X-Stat-Signature: 1jxea5bodarqeoop1mn5frnx7mk9qnph
X-HE-Tag: 1784526880-515163
X-HE-Meta: U2FsdGVkX1/ob1oN08Pw/LH3JhRj/ekeu7mPr9gL0virEIVw8gOWBusaeRxvXT2ScFw1XZRj23WKC14XNJ/ZtFJ72B5EmfikfoueW4KP2LT7dKNMLlHVA3Twdv9AXbWJ9cyzhGy4FkbINgNoePRzNLJIQtVc+DUbhvmXWUvZqeWZMUayYsUESaG71W2KwX+RKiJiVglytfmqEEj3tKVqp18oIuotazQFgHaZDS43G49nhNg1+ghtrssYK6eH1/XyB0JezWP8E4k6A9WB9aF5trPoeKQJOFmkO55+kwvy0BUjyY6VyKr3AsNhz+10bPLjoLjDMEoiwwBnOW42uCE9Xno4JbY/Yex/xs9LhRIKlFFStR7fO5YGi2ZWQzvajNWn92hzTsyvEdDI3k1BYJ74Hbl9bTm2QXCV3o1QK/GM5kFYaSifL4XUC3KmHc4WFTYB658yMC0utdiM3VMeKPjIBEDIwr2kwx9RLY9RUqNtyFJ3v38IYySSqFyt49uTbhhXU7Uc8TrfWtQqvflqCF6Eky+JuXJJF12DrlBFBBi5emlsrWLa1UK9cqE2g7NMmjapHPRFFjP5qkvGaTAnEyFdHzohaGBxycbju6vvNdoyxThz4pM1t3ElnQapUW23THShIXLV8X/30/lT7zh+S3ddTDCEDSGAFi79jBVN0uvBd5OvE36jfwpil3gZ1Y9+HxlAYwPydI/fqeviQP+61CG9hcs3T9gbHmn9uDUO2lyTR/peRtYHvK2fjV1QtT7rxGWSBv3VEmlQGQij28voOWnKKxFP37P2RlD25BBt+IYC0+MghyD7YC4Dxr0X0n8P+O1e0Kc44oVGmAZc2go+KpUCVgTW2ug6vDpRBmtV1bpiPv+IYrqLhci8wM77c4cDoJN5+BFPxpL77rtrWibsG+9YhOKBPFD0Eo7CtILpWJ4Fk1XtOAfd0klkXMDAxvHTyvnUGTplvo043VdGjMimlST
 AHh377VB
 buC89vuwBF9UQ05CMM6zYNZsbniDLQPiqfvs89cpK5Lx6A/+7mJGsoD47I4yuO9RREhkl7nNWwW80uOEYs0bFzHuh99Rr4De0vkwtyiz0AT4Oa6tdbrueK4dVxJ6iTcVlOTqBpK0ICGi8NrqxEkjLtiRAVc3dI9UsD/YTJR61UHeim9oKJbQNPDcBfvTfzD27J2ffYrf3C7mnve9WdeujmxKKbmW81QY83+x73giWxNizEQ9E036DSUwi5zgAwheLS8/l+2BHYABDVJhhXNigtYvDUs3UdncFBqcp5H9CoR1FNi4zjrtLre74aALvll52gXrL1FqBrlOwC2Vggg53JdO+9gso6LESbM4dOwWyQozCsNms4rLYLkbX//FcgGB8dM8RC0sgQhFbW4Fw+b9acXcnsgsGXxUVZ4hJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 10:18:59 +0800 Yichong Chen <chenyichong@uniontech.com> wrote:

> hugetlbfs_fill_super() allocates a hugepage subpool when size or
> min_size mount options are specified.  hugepage_new_subpool() may also
> reserve huge pages for min_size.
> 
> If root dentry creation fails after the subpool is created, the failure
> path frees the subpool with kfree().  This bypasses
> hugepage_put_subpool() and can leave min_size reservations charged.
> 
> Use hugepage_put_subpool() on the failure path, matching the normal
> put_super path.

lgtm, thanks.

This might have led AI review to find a pre-existing bug in
mm/hugetlb.c:unlock_or_release_subpool():

	https://sashiko.dev/#/patchset/20260720021900.1376309-1-chenyichong@uniontech.com

> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -1419,7 +1419,8 @@ hugetlbfs_fill_super(struct super_block *sb, struct fs_context *fc)
>  		goto out_free;
>  	return 0;
>  out_free:
> -	kfree(sbinfo->spool);
> +	if (sbinfo->spool)
> +		hugepage_put_subpool(sbinfo->spool);

Both callers of hugepage_put_subpool do this NULL check.  We could move
that check into hugepage_put_subpool().

>  	kfree(sbinfo);
>  	return -ENOMEM;
>  }


