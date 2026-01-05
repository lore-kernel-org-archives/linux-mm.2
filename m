Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A045C2A077
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 08:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CAC06B0102; Mon,  5 Jan 2026 03:54:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578816B0103; Mon,  5 Jan 2026 03:54:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AEFA6B0104; Mon,  5 Jan 2026 03:54:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3753F6B0102
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 03:54:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDC2814219F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 08:54:38 +0000 (UTC)
X-FDA: 84297299436.20.50D217B
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4DB111C0005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 08:54:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZOAfE6YE;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767603277; a=rsa-sha256;
	cv=none;
	b=CNj2wmJbnee9boRDyy0ihktoLTn8eYwZsEWl6E7bAkApFt6Hq0G4CaAcOCsREqB2heZEZj
	+ogVK/+zBSCgjbPkdmpXU+IHYsANqIw4ql/FPj0IFaeZXiQ41t0J/Be055vxPyQ7KoqzgI
	LyjOMeN6v+g12HfKq+xdT93S1z46z2o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZOAfE6YE;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767603277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r55kyqmmD/uClVKO277vu4AQCwQE5+8myu34W1wd2+s=;
	b=OEJvu0kCIOL3jy4XyVRjBcLypnc8jN9HlGWUdVL8tbBM5wBW70Wb9lsE9JvpEjckVh3sAq
	I+aCX5TCUHz34qBhDrsoIi5KpjIKDDFnu6+OBt8Gydp97iqkw75D46xRevw2fRFZYBL/03
	xPcdk9yZGrNG4n2v+rW7+hLptmNhXpo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767603273; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=r55kyqmmD/uClVKO277vu4AQCwQE5+8myu34W1wd2+s=;
	b=ZOAfE6YEZZR512GS/W3z90MBl3s9AplvzLUMNQ2k43QtuJKJnYt+TYrv/JhK+AbnlzIiMBa5W029t1030R8mdyA4ovwhpqLzqn6UWa2Pe5diWTPs3Q2eumnh6Qy2iQ73geBDXxIoaxjIBjjV1MYp8I6mHxVrYb0a4Vezl6Zwbq0=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WwM6l9s_1767603271 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 05 Jan 2026 16:54:31 +0800
Message-ID: <5fd5013d-89b7-4d32-b655-67bd9d103f04@linux.alibaba.com>
Date: Mon, 5 Jan 2026 16:54:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: fix uninitialized folio in shmem_symlink
To: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Barry Song <baohua@kernel.org>,
 Hugh Dickins <hughd@google.com>,
 syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
References: <20251224094027.65842-1-21cnbao@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251224094027.65842-1-21cnbao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DB111C0005
X-Rspamd-Server: rspam10
X-Stat-Signature: q6xf8k9crm1tp9q8qbgb3dwu47o3qwj3
X-HE-Tag: 1767603275-447493
X-HE-Meta: U2FsdGVkX1+9GNmNiCsx7+aVVqAVroNs+bjm77LgulXXAD2ahXkmVZhzB6f+kYpHbeS8f7BqISpRiq9f2086PkiGjSulDhW3nRm/vv1aSej8XkghDtGCaVXxxg9xa8IEUNthAwNxei3A9IaRt60w6LssUa1mP+gpCZ65KkqEh+yI5QGUL4mnk7tbe8V4JHLnDw4nvYQ2tABV34rGVGLl2Z1+7SXEgQKERHv/tWhskQkgHTec39ZFBYJfKnJHCjmazhCkLwNfV4EMG8pjTwd+4mTWCzozaK4C8fYB9GDuAvDX+aC7LGsf+YHaQt3HEX0xQ/JCwkmBa8S39jUUCzAMUic42OPhPIb4OJkgau/o0r3xWm/nQHZ5h6T8zUWZDbK/PSZEOcuCLdwmw2Cr2H1tbMeje9aMsJCaPmovVgjEpWAVy/q/I23ghr3btoazkrjrLdLYyEn8Ncm3RbJGrUBGywuxikm8gw10guDziP7gyvuq9s6lUlQ+v3ArTvnWKraYzgQ/Nalmg3Jsnml0IgSv42BsOGBHzjY3AIWlqLfSPTGhN1H/qgZBSkDNFEgQEwlyYqyv6GYiyHFZmmkfd9TycTGu29nP7xL/fgJV9PZP8Bz3sYx0AuAvgulo2MsS48VGgRslUkTOMxmAzoNxderkFAY7G105podci9vJH6rDVacwPEE13wLjwbOVWPJIoFCu3un2bRLO6MitnBi8K1HlFJGJP6IItn6sq8UekMoqwABAwtFWzK32+j2X9OevcFiTo6B+8nCi+Hh+2wnmncWSqNZVg5lus+rZNryyLaCPkfGCQbmzPshfUR04v/kZXfmW6/SEi8lHHK2K1O+rPm3A2yur449JhTxej9KqKdKgjvcV3Jb4UDcKgXpODCx34N2823Gr3DpjLnYJOaefcD3RzwCJtvbzq/2AbU35GA5hw8eZqzlZ+VyJTDWkeoBtRo4JjXj7XotT6dlKznyMhBH
 unU7U7H0
 BhEbAqrvYS25624i4gwInIXmhXvJlP5ZDK2kKwDrQIaF1EKFFFGo86fSpxWpTs4ipiXSV659ZVezYYNT9+1WOEp5iITkrgAriSPgwWNyndkQX12qSnUwV1n+kHfcb00CcUFv1zfLSWGrXGYRX5mtYrPa4uNIwnhgWSex+DeT2Va9OlX/h9R+O1OlLEpVv19/8uQzNWp6aUuORXKIH3Z2cfDxKuOY6AZ+BCHSjsoW9/6Z0kxf7f69WU56xebAhDDJ6CtkmoVf2sdD3RceVGJnTub3RrZnAMioY/LMJpyvb/RKLimDC9YMBayM4l20ZYVrmulf3V5u4UlMZbCXtW6gaYI+wSn1PCx96vO9khGeMGZFExtA99mACOck/GzDWmEs8jKYBbrnhgqlQXoIO4EjP/UllWpXX7fxMZbSAnRMzNc/6gbs5GilGuwdkiHT+Q1Gj5rEVTUxPKAFhwfda/lYoAgXKdOHrkYYlYJ0dHuBUSjXxYhpkVKP4YHOIaWfp/NR30mnLVHH22TcpJ/Pj4gg5F0U3jpWwidC2OzMDyb9P8XBM1Uw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/24/25 5:40 PM, Barry Song wrote:
> From: Barry Song <baohua@kernel.org>
> 
> Uninitialized folio allocated in shmem_symlink() may be accessed
> during swap-out, causing KMSAN BUG:
> 
> BUG: KMSAN: uninit-value in is_folio_zero_filled mm/page_io.c:188 [inline]
> BUG: KMSAN: uninit-value in swap_writeout+0x468/0x1390 mm/page_io.c:263
>   is_folio_zero_filled mm/page_io.c:188 [inline]
>   swap_writeout+0x468/0x1390 mm/page_io.c:263
>   shmem_writeout+0x1abb/0x1f60 mm/shmem.c:1662
>   writeout mm/vmscan.c:649 [inline]
>   pageout mm/vmscan.c:698 [inline]
>   shrink_folio_list+0x5920/0x7fc0 mm/vmscan.c:1418
>   evict_folios+0x999d/0xbf30 mm/vmscan.c:4711
>   try_to_shrink_lruvec+0x12b6/0x17e0 mm/vmscan.c:4874
>   lru_gen_shrink_lruvec mm/vmscan.c:5023 [inline]
>   shrink_lruvec+0x46f/0x4f10 mm/vmscan.c:5784
>   shrink_node_memcgs mm/vmscan.c:6020 [inline]
> 
> This patch clears the remaining part to zero for the portion not
> covered by memcpy from symname.
> 
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reported-by: syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/lkml/6949370f.050a0220.1b4e0c.0038.GAE@google.com/
> Signed-off-by: Barry Song <baohua@kernel.org>
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/shmem.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ec6c01378e9d..835900a08f51 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4131,6 +4131,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
>   			goto out_remove_offset;
>   		inode->i_op = &shmem_symlink_inode_operations;
>   		memcpy(folio_address(folio), symname, len);
> +		folio_zero_range(folio, len, folio_size(folio) - len);
>   		folio_mark_uptodate(folio);
>   		folio_mark_dirty(folio);
>   		folio_unlock(folio);


