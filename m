Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B91CD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 06:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4153F6B0005; Mon, 15 Jun 2026 02:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C6216B008A; Mon, 15 Jun 2026 02:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303A76B008C; Mon, 15 Jun 2026 02:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22EA76B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:39:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 912D84088B
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:39:30 +0000 (UTC)
X-FDA: 84881195700.21.DA425E5
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf03.hostedemail.com (Postfix) with ESMTP id 66A4220006
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:39:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781505569;
	b=aLfHrzXXOPwscuZzOwhfTR1wtm/j80f/WXnFR8KVgy3YkW15Rx3kNfRHoHf7RR0lcSI+A8
	qOKrDnAJ40FMhhC99JTpsfps564wuYWsrSZoYnbmnrOSYB36pqGToSQz0GArzwyB3Fo9b6
	oXXXuL7tnCHPmpfs17IVTC7cCzbXY7A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781505569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ymgPLb95Gorp/d4/yQWHFlUnDsVwKIqud9GGRY122H8=;
	b=jRYVUP8YBV89Mbm4o45CHVjnr8T+0Zy60qQp0O76Bbu0KbeeSqLhtF0/dbKeh/th4wfILK
	YoQeodUOi3vtZnD5cV1lWbxAHF8WIML2w0uWAO9UhDncmIdPkzw7dsSaiQzCOI/zH7jahB
	gyJUHth1jgOCECU+nj1ELt6vehMZ37s=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 15 Jun 2026 15:39:24 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 15 Jun 2026 15:39:23 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Chris Li <chrisl@kernel.org>,
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/zram: handle swap read/write via swap_ops
Message-ID: <ai+eG9sFYTn/vTq5@yjaykim-PowerEdge-T330>
References: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
 <20260614-zram-swap-ops-block-register-v1-2-6c1a6639c222@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260614-zram-swap-ops-block-register-v1-2-6c1a6639c222@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 66A4220006
X-Rspam-User: 
X-Stat-Signature: u63pccd4wicrzrqpsnes9aajqfpsx8p9
X-HE-Tag: 1781505567-477064
X-HE-Meta: U2FsdGVkX1/ShOiDtQyD6uA9VqYNP0BRU0oCtlh8M6H5dsLsvTuqaPaHVET+bP9fzSKL+1BSsxMMuxiN3pHFc3KtYVdtGNHB2UgjlTs3JtzuoWfveRSM374X/EIPX66KHbrpE/G1jalKrK1dfiXTFd2AiktArc/RRjVTeJw+oQ8Ty300UpaCcmTGy3Qwtyjxy6b/ROlxU3gxEAdCl4cOEy8FvFfUbQMZImLbS9lqkNo1ZAgF9pYBVGExpSMtzPBKqlwZ6v9Ex8cti0C6vV9XyxPAsf4PsTpKi3R7+SG7/SVHgiO8FVGx3r6cnnq1wIxbxAsUNZxiJ2wMP1Ebjrbt9lomKIhxmwj0DO9lx7j9LzxhHsZOlWSbt65RgDPHIPfDTC3ws/OMmf78fQ7vqxmcoF4L+cLemHJiFM4SlU8xZ0bYAq7kcadfSvdqp6cBavIhK1PvuVJL4ZP+82kDxSDa8hZ8cyTlTr8nwDPDS/+bBwRx1DY2YdbRsko3d6DnsCWiIyUaBuJPpraQxECZ/UlSYmyMT8cSo4/w4iS5cncth+WhfKb+4F0H8x5ge3RflOsQjsNm/jhrsivjVWCD+5qufNUfHhr8ulGdMOhDVFPoaZGEQDGwNwCH/YDGwAZdpgJ4aZXF61+IamyhAdANvjh2J6xpjDTxt/O/+ivOyLerDCrAzN2TwENnYaCWzqHdZok6K+gvCRmiQfW1NjSMpfdy8Z9i2MReBrBVW6oDOhpPiTsEzQRdLDVePSLEhf6XPF/QtSVXRg4kLwNIBUw4CTUMkrxqAb/FexZZ99X6IgTQfRPOYLs4AQii0LBTwuq2vhMNAOf5oU0bKMuPxw1pxDLuJUg2D/mZMWehIKFLU6EkA0qDqXwNCs7ak8tGtY6PfXDigvCl8E9AJtZq0j4stNXr2ZFJ+oU/TLqxGhWL3YVnE3RBwLjSKzm6rR3Zdb3iq4e9fQbYH4oXJA8VSWoiGKB
 nPF6kRP6
 S8IAaiDL/iCAKTBBiMcSMD8LtxIKz/fY/ou/IbTTEUjsH2Jdjg5FaL0fjRGyrKxTXS97haIzH/NHT5RTc8yUd4EmK0igwnPo1A5AwOTqp9y9YTUqXCyUlKvHeugBugS5e/HmKJ1iiNipyElMegZcoIQ448/KFXdh3jmNDKspq9IyFJaSnCCzKhbwizl/AZXNFJ26QaZNunkByGzLiAbS2+VzHsUyHcTtj7SqygXqI//jEVEZc7a+u3UV7iM/Un84jKx3fiwOuVRKBUuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 14, 2026 at 11:35:30PM +0800, Jianyue Wu wrote:

Hello!

> +static void zram_swap_submit_read(struct swap_io_ctx *ctx)
> +{
> +	struct zram *zram = ctx->sis->bdev->bd_disk->private_data;

A passing thought. accessing `zram` here is too indirect. We might
need a `private_data` in the swap device struct someday?

(And If there is a real value like some swap-side only private data really needed.)

> +	struct swap_iocb *sio = ctx->sio;
> +	int nr = swap_iocb_nr_folios(sio);
> +	bool failed = false;
> +	int i, j;
> +			/*
> +			 * read_from_zspool() and mark_slot_accessed() must run
> +			 * under the same slot_lock.  zram_read_page() unlocks
> +			 * before returning, which leaves a window where
> +			 * writeback can pick an idle slot we just read.
> +			 */

Regarding the comment about the "window" where writeback can pick an
idle slot. I think this reasoning is a bit of a gray area. Writeback
could just as easily pick the slot right before entering this routine,
so the race condition seems fundamentally the same.

Isn't the actual justification here to separate the non-backend logic
and ensure mark_slot_accessed() is called under the lock, given that
zram_read_page() can call the backend device?

If the "window" mentioned in the comment is indeed a valid issue, then
zram_read_page() has the exact same problem and needs to be fixed as
well?

If not, IMHO I suggest revising or removing this comment to clarify
the true(?) intention. :)

> +			slot_lock(zram, idx);
> +			ret = read_from_zspool(zram, page, idx);
> +			if (!ret)
> +				mark_slot_accessed(zram, idx);
> +			slot_unlock(zram, idx);

