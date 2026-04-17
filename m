Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8E52F43683
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 09:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60E26B00BC; Fri, 17 Apr 2026 05:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B14A66B00BD; Fri, 17 Apr 2026 05:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A023F6B00BE; Fri, 17 Apr 2026 05:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E47F6B00BC
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:21:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D5485C3B1
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:21:17 +0000 (UTC)
X-FDA: 84667504194.03.B81A561
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 500E9100016
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:21:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iXCfHYYn;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776417675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CImWESrDFMuPQ8rbjInBpSHdlOxJxw3BpC83+SuWeCI=;
	b=JxRq+2pXI40YeH5x2jMr7cM28LGjkqpYK/4TuPszxAWB/blABrANDCcUQKZxE6b1eMpvrt
	L8L3qPAO7wzmk06tnl9MqO6n/SoSLgpaWX6Jcho7MjpawLvWwJ95W34inP832Z8QGkzLX4
	BesZCjhKchohH1oHO8gPPKx+GmLXOyk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776417675; a=rsa-sha256;
	cv=none;
	b=FsP4NB4Q1jVqusa3tkdy7u8lqy06Xyz0ksK6V/eAKCabscoWEdF5xF5ZcHJ8c3gQd3+FI+
	jP6hDeqgUPtBYXWV73Z1rE+Vn8FFSsYwfUybVseNphP23JScPeiqDt+NXeOb+/bPKa7Kna
	i0wQFbdlasgpugGtTpisjl/gG0IBsJM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iXCfHYYn;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 159614453B;
	Fri, 17 Apr 2026 09:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6DEC19425;
	Fri, 17 Apr 2026 09:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776417673;
	bh=V2RFZAnMgXF+jaCr3USxaHS2Sm7HIfxBEIFGnLB1dN8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iXCfHYYnnyj9s6NhCcO7l7gl/cumQK4oF3UIrfgzRXj7adqBckWo7XULrVRZqzznf
	 Gq67blHvotz405eP/y1zdXhVY/nOysIjtVy3ZSKf2SoHoxAEQOIXZGxXio/1iG3JFR
	 HMdZRFlOuVXwvyPRRL3o3XQ/Q5wqwl7/ThCW+pGT7T46qHrrly1AHSu/JArluYqQrb
	 XxZmA77/3H0YRfR4d1dwpGYqiy1tN3+epSP++AKUAyovNVI5PI/axFTTg+HBE3rXqC
	 ePqVyC8DgYjz0p968RbcZ8Qi1Ago5TDCc2vNnYf3Etgv+7NQpwO4IrWJHBEf7HXuiO
	 7lKuAZ3JUH8Qw==
Message-ID: <1b3c0401-6d10-4a28-97c8-8e3858d8dc3d@kernel.org>
Date: Fri, 17 Apr 2026 11:21:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: shmem: always support large folios for internal
 shmem mount
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <26f954be62348591e720c4e8b7a9099b74dc1d6d.1776331555.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <26f954be62348591e720c4e8b7a9099b74dc1d6d.1776331555.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 500E9100016
X-Rspamd-Server: rspam07
X-Stat-Signature: dppprof4e38147pgfoqkqcjbs6fyx376
X-Rspam-User: 
X-HE-Tag: 1776417675-478618
X-HE-Meta: U2FsdGVkX19aBc9gma1wO3By6WnX13ZFwmasVRoDt3eMedkNEVAarn2p7w0CcMYUDSHzNWrAa7c59BTfNB+VB1+0lOKNMMB1m4TyshK5JNCJnSO29+Cr0nNPAiAeedGvL/c+KvtgZOFdvclP79mZLUspbsxWp5BNfPkVVFmqCMlzJnb/9e1fAfwt+q1yuPJZqXDjhLsUbaUtawgcxJpvfJt0SzAFUriwj3n398EDJ+lF+SwbgIxR3+lUyCP6kdgJF3XRh3MYPQ50xAMcx/FEXjF3RDHJOqnPXniH27pBUzj4rR9XD7Syi0nLWNdX8lwoXtnyYRFcAZ838f6ZmbDNtAynOHLc+i3GOBGYHFNjYioxWUD6SdmOJJ3gAcaTeZalR/Co1f0L2pW08unGn024duYkk5gdKoAsRCzJz/mNDht2oIKoTeow1b4OuJOlDDZTcL2mXx36AiPngTNTgrh9564K494CU7m4wiIYVl2f+GW73zSmEwKKssKnH3WomuBLDwUX/1hkkx2MdZlIJ6SFU0KZBsCkzVfjuTsZC/oES03cGjil4jDtBo8hEcgC26kWPZPefqAV59mYaN7jiTBDlz+tv5ZIP+WEQFhg4thQju/lzgiUM5dX52aqqH0j5mcIZ/APRGtbY8lIdGAYrB7WcFAX+RWjKUYYcMluEFKbnm8JGgKsmwu7WZsrrNEuvDWmh6uioYDc2/RZu8yEZwdtvSrOPRC2PbZyqDzz951SZcPRKVuNAmtloeEvrgIndhsJRwA/5xMfAHbWjnlR16uaE6XCp2bQWY5hJWMnn97vNj1PiicSwEE9RTRaSL0ISWyVbJ0fHYMMWJUKp776SCNLtHTdnza7qI9diDF33d8bdXCCjNWPtR9W0ZrVMb+q+JqwiJCFA5sA9WX5ynpSde9k3o5ALIHU127y6buVgMfRDzeKyidKfpukKn7lmpTZKBWVyYzAKto/DeGIyL2bVy8
 aqkUJxm3
 tCVsVLZ89MqGdKF7EiSHcT2LthByC5vWDX4ZbJ0+qp0qG8UTanFFJ6MTR4AQtqn8Hn386M/UwiNgviJSTH8/ivpWzKViaMHs/uMVDEU7gtNlKjU1aMYOBKQ3JWtkqQ7ht5ZkWgJgOl8Pg0T0CMIe1nAkjSY1IAOkwIJhjASyYUXCCEebyOG+uy9OxgbEQhoL2u0xkl+CwMQVeJDdRVvpA2tE1fwH/PzuT7E+S9eOyQrY62A+ZRdt3IjRPtCMYwKuTR9PziiV+XZSz6Cta5p/jQmw1KWikNhWB6DhmijYy9m4rKdM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/17/26 05:25, Baolin Wang wrote:
> Currently, when shmem mounts are initialized, they only use 'sbinfo->huge' to
> determine whether the shmem mount supports large folios. However, for anonymous
> shmem, whether it supports large folios can be dynamically configured via sysfs
> interfaces, so setting or not setting mapping_set_large_folios() during initialization
> cannot accurately reflect whether anonymous shmem actually supports large folios,
> which has already caused some confusion[1].
> 
> As discussed with David[2], for anonymous shmem we can treat it as always potentially
> having large folios. Therefore, always support large folios for the internal shmem
> mount (e.g., anonymous shmem), and which large order allocations are allowed can be
> configured dynamically via the 'shmem_enabled' interfaces.
> 
> [1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
> [2] https://lore.kernel.org/all/875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org/
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Changes from v2:
>  - Always support large folios for internal shmem mount, per David.
> Changes from v1:
>  - Update the comments and commit message, per Lance.
> ---
>  mm/shmem.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 4ecefe02881d..769ef37b1ea9 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3088,8 +3088,17 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
>  	if (sbinfo->noswap)
>  		mapping_set_unevictable(inode->i_mapping);
>  
> -	/* Don't consider 'deny' for emergencies and 'force' for testing */
> -	if (sbinfo->huge)
> +	/*
> +	 * Always support large folios for the internal shmem mount (e.g.,
> +	 * anonymous shmem), and which large order allocations are allowed
> +	 * can be configured dynamically via the 'shmem_enabled' interfaces.
> +	 *
> +	 * For tmpfs, honour the 'huge=' mount option to determine whether
> +	 * large folios are supported.
> +	 *
> +	 * Note: don't consider 'deny' for emergencies and 'force' for testing.
> +	 */
> +	if (sbinfo->huge || (sb->s_flags & SB_KERNMOUNT))
>  		mapping_set_large_folios(inode->i_mapping);

Two questions from a non-fs person about the semantics here:

a) Can sbinfo->huge be triggered later, for example, through a remount
(staring at shmem_reconfigure())

b) Do we cover all cases with the SB_KERNMOUNT where sbinfo->huge cannot
be changed later?

-- 
Cheers,

David

