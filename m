Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB6B2CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 026C86B008A; Wed, 20 May 2026 06:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F196E6B008C; Wed, 20 May 2026 06:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E936B0092; Wed, 20 May 2026 06:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D296A6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:04:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9AA261C016A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:04:20 +0000 (UTC)
X-FDA: 84787363080.26.A66425B
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf18.hostedemail.com (Postfix) with ESMTP id 47BE51C0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:04:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QUCF2KP2;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779271458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/XSdoqWrkFocuSh6cxq2pbiUwYPICfwv5WO3SOEKurI=;
	b=03fiPcAkOeJl3GQ9tZXa8TG3ryqMn3g79tbyE9t6BP2efIFbL8gtYFq9q8dM6LwqIk1Q1T
	QtpnTnqOjkREsamJPgAhXwFOb9Khs3pm5LdpHoG4NA7mF7y+Jk7ruYJAN0qCOI8+9IUIwx
	S20TQ8kEZ/xDah/igeqDIzEjXcecdEE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779271458; a=rsa-sha256;
	cv=none;
	b=16MoBFlq6gZ7hRyxHKyT3/U1Xp1kt8+KSB27uHlHj0cDOQ6SQSzuFsytUIdhuI7fEi/Sxz
	diGjz8wcJlB+x3Q09HqhH+5BVdH+ORu8X3mr2xjVPMj1GG1SmJqMPO9KMHC0l+LgsIL3Ye
	l1uKFJmQpW/zsB0DajS/LxLg9RO4fq8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QUCF2KP2;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779271454; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/XSdoqWrkFocuSh6cxq2pbiUwYPICfwv5WO3SOEKurI=;
	b=QUCF2KP2fVauariDvgI8BfwiD5SGqvQB0sXhb8snMUbqD+XL8tK0Zaf9nQVe8qQQFhdRxZYeYu3Fo4aJy5oRoaff4af0VTUXcZuSSM64kBBwNr02ZNFMcjEyJ0aPYwxB64Q7rRzCPdEuvIQPF91FV44BY2tC9Hi5fZpWj9vM4t4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X3IbWOs_1779271452;
Received: from 30.74.144.110(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X3IbWOs_1779271452 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 May 2026 18:04:13 +0800
Message-ID: <72bec63c-09f2-4a97-908d-3e6af8e3e0ae@linux.alibaba.com>
Date: Wed, 20 May 2026 18:04:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] mm/shmem: set __GFP_SKIP_KASAN for
 swap_cluster_readahead
To: olvaffe@gmail.com, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Kairui Song <kasong@tencent.com>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Boris Brezillon <boris.brezillon@collabora.com>
References: <20260519-panthor-kasan-v2-1-b7384458f076@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260519-panthor-kasan-v2-1-b7384458f076@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 47BE51C0005
X-Stat-Signature: 9na7fpn5tijdan3pf59pngbofxhatrxh
X-Rspam-User: 
X-HE-Tag: 1779271456-522943
X-HE-Meta: U2FsdGVkX1+uL0ia9RjPiwA/imLOY8rnjvIX9imgyawFCG/uw+sf2xOrPUpHxYgE/vvNz1fow7Pf5IABdMxmn3AgmkScNvg94/ENlsM6c5rJMMhwpFy1rDMwOmaFr2+5uF1xd7Wp7LXyCmO8JYY1Kb164XnfcrLfJiDgoY1MgD2xbZS50BKrIVsfKFJKXuvpBfT6y8r9acAbAAbbz+pUkMxaxN7WSYWskdTNGE+DvcqYyqs3Z88RYmEHMIPfOnpw0/w0cyNBk3IYuKeaUpbPl87OsN+RCmwi12MTHjcXKn8l9rlwMFg5RoHIM7i3H5G62//MB0ReGBwUJoZ9mSaC+t0fspetALLT/tA9Y1QGzsIvxjvbBluXw8HQnqdMJG7MuL7jR2DgB/tntve2u8NYD8jH+uIItP688EAJipdZMxO7LOXRklZEGLmrbT7H2+VGUI9ubdz3L52wXAq+AI2u8sSZXHoiQ2oQAHdFwG5OUz6GMRl94qjpKgmlNHSZGubGeqy+xkZF/5NriS9CHpWHLSWRQX4CKfDbL9EbcDfliVldA/EJOoBci5k9TK7GIyZvcCxr7zpClovv/oEafLlhS02RBCfYWK1OYTSUTV50e63kxxcc5CFWSpQwAHcDXYBVbmsoNUnp4i/85KcNRAxD6zL473V6TCvmeaS9A6g8U47h9pX4KeSkqFpC+3kmdMmjg6JaGSIL3tWcVMSKJ6TJLItXjnf0/GAwglGzM4gUX4spbsIziqMAFMYhh4DyxEXr+t7CdqZiJMFaAb/hGeS7zDWZN+p5zKwawFz8F6hhNmGUh1KFKVwes/vJHkWcy548n+PKdtDaS3JuGJ63hWUeGNbgcJdZkxUV0tLc/HCPIddruPnJsPGrooLLTxNNshbV13Xr+2AnDcZjyJpUQoSYSqmS/6eh8GG7JuEisvAy6wQ4StrVjXZLDfU3074akzvPfsNiFwrgXdErpt+ov+s
 buIIl8KM
 nHDJJ9xJwlnpGnk6KYtEl7dDBFK20+h2+AKEoicQdZkwE3+KIXt+3dCZ6kwkwtTYM6x+xYzCT8ugAWh6Rh95vdLSmVgHbNot5OD673pdEOn0vaksBbA4wB9QRQtzoazW+b1PgN58w21dX4ANzwK9+Yu1iAmOmfFnMu3Isq6pByXIpGDAeXjUciz+6fe0KO3hJjvsKT5UDeQ8xYcHdKfWIzBwJ5h42RT9KOLylXxNISCYHuvyY9UssDX4u6Yi62/NKUAYm7TSNMccW6NGlBjdg11WMX+9B3DnNkFy3H0Iw8JO7PUslAkQuu0xSHi5pnc3uceDz1U7urs9xC3jMljThu9OD4dClYhkUACDw6gnEwRbnlmq8LXVw2G3uuA3ckUzgbxml6RVMQ0ONxk8JKYbsC0lor3KT8jjP32LiQbmQ7yG2Ftbq4xKQZNttkMLKNqRd5Z5A+M/jshEhRVCIQPAILIA9eQbJArTUB1j6+YZ8L/RAlCjvu8vlrfBfzqUE/9abdSQJDMOaZdLZ2sKX8NcQq5qSe0lQ1nLLEBNx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CC Kairui,

On 5/20/26 12:31 PM, Chia-I Wu via B4 Relay wrote:
> From: Chia-I Wu <olvaffe@gmail.com>
> 
> swap_cluster_readahead can allocate folios for other mappings. If the
> gfp flags do not have __GFP_SKIP_KASAN, but the other mappings have
> PROT_MTE, we can end up with false KASAN errors such as
> 
>    BUG: KASAN: invalid-access in swap_writepage+0xb0/0x21c
>    Read at addr f5ffff81aa71dff8 by task WM.task-4/6956
>    Pointer tag: [f5], memory tag: [f9]
> 
> In the above example, because __GFP_SKIP_KASAN was missing, KASAN set
> both pointer tag and memory tag to 0xf5 when swap_cluster_readahead
> allocated the folio. But the userspace had already set the memory tag to
> 0xf9 before swapped out. arch_swap_restore restored the memory tag back
> to 0xf9, leading to the mismatch.
> 
> Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> ---
> Changes in v2:
> - set __GFP_SKIP_KASAN for shmem instead of drm/panthor
> - Link to v1: https://patch.msgid.link/20260512-panthor-kasan-v1-1-d8d3e275d71b@gmail.com
> ---
>   mm/shmem.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c2..db9130a8c5b76 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1784,6 +1784,11 @@ static struct folio *shmem_swapin_cluster(swp_entry_t swap, gfp_t gfp,
>   	pgoff_t ilx;
>   	struct folio *folio;
>   
> +	/* swap_cluster_readahead might cross the mapping boundary and
> +	 * allocate pages for other mappings. We have to skip KASAN.
> +	 */
> +	gfp |= __GFP_SKIP_KASAN;
> +
>   	mpol = shmem_get_pgoff_policy(info, index, 0, &ilx);
>   	folio = swap_cluster_readahead(swap, gfp, mpol, ilx);
>   	mpol_cond_put(mpol);

If we force __GFP_SKIP_KASAN, would this cause issues for mappings that
explicitly should NOT have the flag? and your v1 link already mentions 
this scenario.

Additionally, I'm wondering if we could use shmem_should_replace_folio() 
to detect such cases where shmem is being prematurely swapped in with 
incorrect GFP flags (e.g.: __GFP_SKIP_KASAN), and then handle it through 
shmem_replace_folio()?

