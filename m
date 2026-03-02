Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5265CE9B36A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980616B0005; Mon,  2 Mar 2026 07:20:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D3C6B008A; Mon,  2 Mar 2026 07:20:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8399C6B008C; Mon,  2 Mar 2026 07:20:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72B7D6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:20:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F85513C0FE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:20:35 +0000 (UTC)
X-FDA: 84501031230.08.E3AA643
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf08.hostedemail.com (Postfix) with ESMTP id F1B9D160006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:20:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ORFSgjz9pVvcEg/YR9y83nJbJ3QdLxbVFzzaNo/s5WU=;
	b=Jj9QvfhDRrVQ6SGv8TtBtAn1rKI0KBsHRyEItzS2ORD0biWm7DTVUeh5kVLFB2YAVMAFN4
	+uQLLCbCm0eZlqXlzp0ZEVlRs0gqlG3X0fLRoa/lOfeSJBfdUuHqqTwLuGxAQ2t4ALRHNV
	kmNsAGmzjWlZ+AUYCZblQIZLeqgi7BA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454033; a=rsa-sha256;
	cv=none;
	b=a9FBow6vJ197ZdKJiTlLUUPR3tOY1w8B6entFhmCrh+QgjnEKiQ+80qitcH/VpdviIM3tE
	Ax/fbBb45YaqO9XwKKrK2gpKvbL8wCvvgfN9UsqyGF7hixF+hOgnYUwU5koY9XiIvejysr
	72Megf4ezBAGwNY9kzqr8ufFy0+oZ74=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 2 Mar 2026 21:20:28 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 2 Mar 2026 21:20:27 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	baohua@kernel.org
Subject: Re: [PATCH 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <aaWAi1ZjJAeI2gRv@yjaykim-PowerEdge-T330>
References: <20260302104016.163542-1-bhe@redhat.com>
 <20260302104016.163542-3-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302104016.163542-3-bhe@redhat.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F1B9D160006
X-Stat-Signature: e6kc154w5jq45331hygndb84t9ct4xqi
X-Rspam-User: 
X-HE-Tag: 1772454031-158714
X-HE-Meta: U2FsdGVkX1+AQwyXQjz1h4yfa4Wb4UEZVdP0Zp10hX5RzMjphU46RgOfHW8Mqf+phgAs0fZS+mDFP6Pj5Rbx1S60ddwzDo8BKD1YoEP/FOtQz9UfpY4Z4lHSMuVtPKoWbEN82NwrZzAgEr67XVQCv5mF3PvyApQcczTsEbxclU1KlDP2kUSJp5qlmoQPEih7CShbif2Q1BNdNK94IpiWH0KomTk3nK5Y9Y5KR+ItQsxrRMkknyB4A/thnpKIwkxJ7iIvUfElhbfe3u+ieOqFvY88Di+hZA6Vc6tUero2PebVOoyaI1eXVS8G5MpsqOEzL8ZO5eZbTBU0hb0BNK7fcSj3CGsLaTvUGNB+xxIdhC/V623RJsoE8PXx4rbziBkSymCWw6+lraDnqsl+2DMDD9pKQ9nsCmq/PkbbHbbUyaNy4OADvOh1ETb1W5fuWAkS2vrQa4+EaL1AWa1Frd/HdCrnj+2kyIKRYlv4SowHHPGi1BzeFRBigaIhHcRmqrOtACzgloY5nBiVv7oOPow7t8i8Hi4p3PUCOOxQ/brIfpRt1eNrA2yE/wDuxtXPBdI46zzaxhbydgGOBc8UeA7s+2eD67TVz8Yxi/sx8IP320e4W+J7E/QkHzifjSQUf4RTi0Lc6tJ7CxcyZKQSSNFcPeF4EfxmnmhbowfaERzxWgjKpEJB+uP4UvpyUetODjrir/phHL55jffkp9UyW/Te3/ekZsl54PMHqw9X2S5Xq1ZPDZkAbhRz9MPjQrLYRy1Jr0RLaPzUybq63uGh4rZFqMN8e5nH3aHrs3SfMLd2the0G+XqeaQJ1Td3Zu+lU47RVyOe484MhmM7PAKNN58IEvDqo4ZNACKlhCJpB3oAqUDclM/YK2s9ndCJbthHdozqXFX5Erzq7soXkQ0bimf79zpM4ppb3z2OZG3kZ1EDFjWQRYCubA9rM86pwm+HG4fIHJgpht/cbCn71A8nRZO
 jyszdKvn
 lT2WDkaIndV5//76v9fCj7dGYrpN6iKhkxU1oy9Y671jqW3wvT6ngva3uu5nE7YbIhZsqKD982DtqWouutCFPnZWWgvfkWndvercpOZHfMtqC6cLw/EdThnKCQNsC227E/chUAg6iLSmebBcZ2uZsm6rXNOVDktcMjZC0by9ZgZi3q6VtGYg1yiQGetJlvmR92auLjDF5pypVw4FPW9Rvr5jH2EdYxOnsHf+94PcUlIHRw5UlwEMj1hT4oDvAPRgqplsjIVimnBK/NKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 06:40:15PM +0800, Baoquan He wrote:

Hello Baoquan!

...
> +	.read_folio = swap_read_folio_bdev_sync,
> +	.write_folio = swap_writepage_bdev_sync,
> +};
> +
> +static struct swap_ops bdev_async_swap_ops = {
> +	.read_folio = swap_read_folio_bdev_async,
> +	.write_folio = swap_writepage_bdev_async,
> +};
> +
> +int probe_swap_fs(struct swap_info_struct *sis)
> +{
> +	/*
> +	 * ->flags can be updated non-atomically (scan_swap_map_slots),
> +	 * but that will never affect SWP_FS_OPS, so the data_race
> +	 * is safe.
> +	 */
> +	if (data_race(sis->flags & SWP_FS_OPS))
> +		sis->ops = &bdev_fs_swap_ops;
> +	/*
> +	 * ->flags can be updated non-atomically (scan_swap_map_slots),
> +	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
> +	 * is safe.
> +	 */

The reference to scan_swap_map_slots appears to be outdated as the
function no longer exists in the current codebase. It might be
better to update this to a more generic term?

If comments are needed to be updated, 
Similar comments in may_enter_fs likely need a similar update
for consistency.

> +	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> +		sis->ops = &bdev_sync_swap_ops;
> +	else
> +		sis->ops = &bdev_async_swap_ops;
> +	return 0;

it seems return value is not needed.

Thanks 
Youngjun Park

