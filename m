Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7338C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 03:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65456B0005; Sun, 28 Jun 2026 23:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16F16B0088; Sun, 28 Jun 2026 23:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53F16B008A; Sun, 28 Jun 2026 23:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82C936B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 23:19:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 139271C35A8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:19:34 +0000 (UTC)
X-FDA: 84931495068.05.340C326
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf20.hostedemail.com (Postfix) with ESMTP id BD5721C0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:19:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=w8fL5AlD;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782703172;
	b=0Hr8vdCCKIcFn//bLfk2rWSWQSWYzvEZ4EjrsEZQ4x3S/s3qgI5onHqnJmErrz2uz+9ppg
	LLQHiLuDODBaTQNKywkSV7c6I2LYGXI+55zLhf1TO8SR8zrHUvL7vV68SYY6siAZO9Xh48
	00SXhNVTiu8ErIIKGABFhAoYJdoIBEs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782703172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eirV7JvdpiqJpLKq15ukPt6tpYfLjuJTqmiHC+bueg0=;
	b=HoXH3+jSlRuligBzPEdjvFAI09slDJbP1PpAo/ltp73yfOStlOe1QEhqKl2ACF42bQS6v8
	sCa7hMSupJ2Xy3608b58JMjDnUzd0OsLVDazBGDBAcjqJSmRT/ZcF7/l9o9pkIE6XcHAJQ
	S+O0WyCSbvvKnxWQgj58iQI8uKGNrAE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=w8fL5AlD;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782703167; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=eirV7JvdpiqJpLKq15ukPt6tpYfLjuJTqmiHC+bueg0=;
	b=w8fL5AlDbptLwot4buyfT2Sjf2fcX7SBsplOMu9kLsY6dgn6SHVVJ65iIbGT8RlyYSxngNBcRznZi3Kdev30iC+yx4I8KYvVsHmeuxXkvBsndnLwEgHHGuTt4wDolz+qOZD0JpKWCCXrL4zBLLQI4AVhA01ociALI42H31Dk99o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X5luikQ_1782703165;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X5luikQ_1782703165 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 29 Jun 2026 11:19:26 +0800
Message-ID: <828504a2-a1f8-40ff-bf84-ed7d03f02d83@linux.alibaba.com>
Date: Mon, 29 Jun 2026 11:19:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: Fix data-race in shmem_fault
To: yahia <yahia.a.abdrabou@gmail.com>, hughd@google.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
 syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
References: <20260627223656.181988-1-yahia.a.abdrabou@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260627223656.181988-1-yahia.a.abdrabou@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qr9ia3t3q7q34mw55kfy4oysueqtzfx5
X-Rspamd-Queue-Id: BD5721C0005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782703170-629490
X-HE-Meta: U2FsdGVkX1/fbI0yWjdf7rvsOEcXS2sSfdNU3CI6QVTWjAnhC6zqe0TBULgUA7l/hKwHFTP30XZ6lEM0Uba2qz5z0OPdHfgVQisUoXBRNKOuTHoGlB7Rv4vy2eTOYG4T2UgCZ3SAJIoyPPGff0N/3luUABkd8Re7QL9FevTkBDIw7w91+mTwNrOPUTQUOZoE4sMOodosFoUapkDDocBBU0zZhh6e8J3hHJPI3Sh9dw9PqFSO1O9NggJp9AncWH6h3/AyJZrd4ou1DS3RGoK5fcMeLMsCYyx/rWJGCyjajhiik0+FSrxICbiwqYbYCz6tloQsoRa4XOmnPPHb5A+xz6nAG/pzsOtgoXgRC/1LrjQ8rppjjfz4EdixcJ1FRbf7eEP435EcjCnQpDFQso9+7EeJUXZXHG12LyGkTPMP7oJLHoJbVYK5lTy9HAGARzdIOGAStUQdQpBHwchvudMaFX3imOlfzSo95fkBUj8opL0YRvLD6fTnnLyzZGMywGS0G6E/jPykBErUL3hL4qlxvTeJCjMagdwaZ8EawRzFFBusWz3hj0tPvZMMxff0LNx+Q9oUsUG2a/o1P/+Ey3hsrJtVuaNgTVasw8Mh8dFvNA5YCFUn37Tq0HIysY7XwaVffdHEBO7dVq4vULmPjD6cSuOfRwpsqmSaNhheijZu9cp/15MhmHrhFa1xlgWUPJ4L5ZiWpx+wVRud0F+XomeiLggcfaS3Qf6mG51fOZezpKYNxWoDgbHA+TQ2Gt1w71M2f1n2NdBNbn43tYMnmXPqNtPs94NMMzCq07SkfMnkPrOMeQYt9WfpKAw6UVMWjv8htF29bkjCiYvDqBHZ7pdMCcoJ0aEPNCenO0BfeqXD2fK/mtsFx/YPTP5QcKPB4yqTBEQNr5fzHCRdTlnvsocSAYbr3jIRjRBgqithD93KCN4TBI26pPd//5nLrdLFKUBiyeyFIphzSm/86gPHYds
 z5Q8IG9D
 kbYy74N8GwIYKczeLs09CiOuRABtZE5DR10bIYlcI771rmbRxbhz8qL5e/rHMYkDAIjA/CIF9XnHuoDlb/N0DrF0jEd+5oadEFiRoTVltWnzvrc6Su+yROwh3r3fkmmyRRRjs43lzRRJq4wNzZwgeG+CvaK0Rqgz1RTY3J/3KDDbpAKRlPx0ITypopsOxJ796jyl0dEm5GaVva63WmK73Crvqs383g3a3eP22SC/K3eBoq8X5BMsBImP4VIHaNVmC2EgHrrXLQ3tF3EpcyYnSJ0+52vtS5plsFx/dzn8w2+eTcgaJMKnV75PnzHODwpU8kScjMTzSp9U7Nnxjv54V5vIFgm+wCZCvOKFRABY6BntdPNfaJbcvDJBLvaguelsiyJfjJ1g04F3JbTsX7z5/XAQjLMXeIy9WglqHo8aMMlhBnHNorEXlLUSSDpC20UIfO4G6zT07/wcNLppkd8KLqZg9hyNIYrl9DrjxvWrCFFmNKJuqqpt71iIYk0SuOZnbaMSwnuGHRemZ7CgbmrklLoiphtLt/YTIltKGd1HGddsOTZ0Ves29PDKG4ix4jCAKTi9RcJGU1zZwLgUZ6ErBgegT9mapciOPzaieBbU0vrgNtvlyfbrsNu1lZrkhKy0gFOIK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/28/26 6:36 AM, yahia wrote:
> From: yahia ahmed <yahia.a.abdrabou@gmail.com>
> 
> shmem_fault accesses inode->i_private without
> holding a lock, while shmem_fallocate is modifying
> it while holding a lock, thus a data-race is created.
> 
> Fix this by using READ_ONCE, which provides an atomic
> lockless read of inode->i_private which prevents compiler
> optimizations such as caching registers. which is safe
> because subsequent call to shmem_falloc_wait revalidates
> the lock.
> 
> Reported-by: syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=76cc716982cf0254f302
> Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
> ---
>   mm/shmem.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b51f83c970bb..97b3913144ad 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2693,7 +2693,7 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
>   	 * Trinity finds that probing a hole which tmpfs is punching can
>   	 * prevent the hole-punch from ever completing: noted in i_private.
>   	 */
> -	if (unlikely(inode->i_private)) {
> +	if (unlikely(READ_ONCE(inode->i_private))) {
>   		ret = shmem_falloc_wait(vmf, inode);
>   		if (ret)
>   			return ret;

Make sense to me. But we only added READ_ONCE() for the reader, which 
doesn't seem sufficient. Usually we'd also need WRITE_ONCE() for the 
writer side.

