Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94F71D14892
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 02:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0875F6B0093; Wed,  7 Jan 2026 21:57:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068AB6B0095; Wed,  7 Jan 2026 21:57:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE3C6B0096; Wed,  7 Jan 2026 21:57:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DABC06B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:57:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7770DC2154
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:57:31 +0000 (UTC)
X-FDA: 84307285902.19.CD55056
Received: from mail3-165.sinamail.sina.com.cn (mail3-165.sinamail.sina.com.cn [202.108.3.165])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3B06180004
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:57:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=OwoO8OdY;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf30.hostedemail.com: domain of zhangdongdong925@sina.com designates 202.108.3.165 as permitted sender) smtp.mailfrom=zhangdongdong925@sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767841049; a=rsa-sha256;
	cv=none;
	b=1u84IVXtzpBqi1oqeIvGKPZfd1r50Zi7bbSB55hcStuX4/vWRbPskXJVpfunI0hoaFEKmd
	2ST9ikadesW/dPtXZvAs7vKdRXU2j5NvHZxAl7CGmRzDLI0EYnibI8CSKlzAnjXCiZTFVr
	QgYrf/LMgqw59CHpGihxX7Ci1PthKBc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=OwoO8OdY;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf30.hostedemail.com: domain of zhangdongdong925@sina.com designates 202.108.3.165 as permitted sender) smtp.mailfrom=zhangdongdong925@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767841049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNxegYof74IPP9KhgYLykJdLB7hHFuhQpm3nUOS29DA=;
	b=a8+6P8bpGsSlcoSIwnQI3akyz0JywIB0ImF50gRLHQFUrzHqi/YTSVl9B1WeTrP7ettqH2
	caYV2109LbM7Iw/jPXamyIvORZYc28iNvtHPoYnUZU+1rLdiF6bWWFcoV2lxbWsruI2ZZm
	oXjz3q5aT4c1Rny+rcaINtBWFOYICW0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1767841048;
	bh=LNxegYof74IPP9KhgYLykJdLB7hHFuhQpm3nUOS29DA=;
	h=Message-ID:Date:Subject:From;
	b=OwoO8OdY+hp3kb1JEjdmKb9h3C/aly88ydEfxnEtDAyVzDo3rWf5xhmfILdfIQw96
	 8qw0TZ1WhlNLhbtUWyuCSx6FQb2nk2XRmQSdyKryDFCEpyY2c3JRBSjvvndR6EgY4f
	 F+fFNDM//gqHI1D5s2bLPzXNrfDcAXc1+gmT9HaM=
X-SMAIL-HELO: [10.189.149.126]
Received: from unknown (HELO [10.189.149.126])([114.247.175.249])
	by sina.com (10.54.253.33) with ESMTP
	id 695F1D0F00006204; Thu, 8 Jan 2026 10:57:21 +0800 (CST)
X-Sender: zhangdongdong925@sina.com
X-Auth-ID: zhangdongdong925@sina.com
X-SMAIL-MID: 8957726685282
X-SMAIL-UIID: 56B5BAE87F644BB09AAD52D6CCF48F14-20260108-105721-1
Message-ID: <a527b179-263f-40ad-9d7c-bfa86731bfde@sina.com>
Date: Thu, 8 Jan 2026 10:57:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 1/7] zram: introduce compressed data writeback
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Richard Chang <richardycc@google.com>, Minchan Kim <minchan@kernel.org>,
 Brian Geffon <bgeffon@google.com>, David Stevens <stevensd@google.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-block@vger.kernel.org, Minchan Kim <minchan@google.com>
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
 <20251201094754.4149975-2-senozhatsky@chromium.org>
 <40e38fa7-725b-407a-917a-59c5a76dedcb@sina.com>
 <7bnmkuodymm33yclp6e5oir2sqnqmpwlsb5qlxqyawszb5bvlu@l63wu3ckqihc>
 <2663a3d3-2d52-4269-970a-892d71c966bb@sina.com>
 <z22c2qgw2al73yij2ml2hlle2p24twgpmz4jemfqhjoiekc65f@pvap7olsolfp>
Content-Language: en-US
From: zhangdongdong <zhangdongdong925@sina.com>
In-Reply-To: <z22c2qgw2al73yij2ml2hlle2p24twgpmz4jemfqhjoiekc65f@pvap7olsolfp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3B06180004
X-Stat-Signature: 7xs61fpsh84o8hz59nng4rj6fzay5snb
X-Rspam-User: 
X-HE-Tag: 1767841047-824030
X-HE-Meta: U2FsdGVkX18f9hZZq1VgTnFnM0iKq+3Hh/vXMqgwN4FSTetsxDAuRozCh3yIZjFfu8WRMUvncTMwUAXRhWIKhQlbHt1NLBcNaJX2IAvv4C3Qdo8+bhOerTYsOonGhE4OjVmOfV1jiUTxvHzcqFg2U2TkU+AnwW+unJvTRSS0FKtZ4vV0Lh66z9J9XslLsOdwseGzhYAXB+opdWZDIKhlJqMWrI+FYSx+Im5Qj0e08FkGYElrT8VZwqEGQensIPXv0PS5qbLERfzDRUEfXzv1J/sg8qGzItLkzL6lAXqV5osF9AYofdh0HGVWL43tJrR/rir8KemcwaimMMYp8E4jm07D+jT5eoVsbunh741RsUYjKBbp461fDUkqPYtFvVddqCgpgZO0aKMMJrYm24LhoRMQGs8Ciw2dkeUGkStj9TLkXoDldw+gorH7b8VKyCOxEYWTx5J23XgC2IzCqXFg1Z30Yimk0slDuhjj0afxmDJgyIs1czZ0WxKA9+uWOqj7jF6VipBK1ucd2M0JQKN26tzZFS74patw/MmbOhf+fpdrKubRgK0TMnoJJ8x0RtWk2eFjnnkr+6qD5cHrxPNjM+Ds6xkFnoMfTsSc2CzW3kdqdzeunx+fsD6JId88xW3CxwLOaCuQMd6SsT2HKr1FNOrUL9hPjMNPMzCbLiiyAC9S0w8+YGlWf5xoDpLzRLc2Ff3q+W79TQFqJKIMZD5zQoaKnFRYXh4rlR0d4w/vGqJ7yc/PfIlUnqLMosmOMSxvNEW4gIJ4kSk6rtLo6eGisMqhHATEo0o675QI9Jji1Sdx1ZDBu3GHvJ/NX3Y1DDVs/scOejZNuCjoRM+SpgozWEZO+EsmvaSQNoq7whI1Mdlh1sbftL0vdCHg6Ik33VaeTbE2Bum+MXnUUkgye+jHEJ8LzGzbB2D2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 18:14, Sergey Senozhatsky wrote:
> On (26/01/07 15:28), zhangdongdong wrote:
>> Hi,Sergey
>>
>> Yes, we have tried high priority workqueues. In fact, our current
>> implementation already uses a dedicated workqueue created with
>> WQ_HIGHPRI and marked as UNBOUND, which handles the read/decompression
>> path for swap-in.
>>
>> Below is a simplified snippet of the queue we are currently using:
>>
>> zgroup_read_wq = alloc_workqueue("zgroup_read",
>> 				 WQ_HIGHPRI | WQ_UNBOUND, 0);
>>
>> static int zgroup_submit_zio_async(struct zgroup_io *zio,
>> 				   struct zram_group *zgroup)
>> {
>> 	struct zgroup_req req = {
>> 		.zio = zio,
>> 	};
>>
> 
> zgroup... That certainly looks like a lot of downstream code ;)
> 
> Do you use any strategies for writeback?  Compressed writeback
> is supposed to be used for apps for which latency is not critical
> or sensitive, because of on-demand decompression costs.
> 

Hi Sergey,

Sorry for the delayed reply — I had some urgent matters come up and only
got back to this now ;)

Yes, we do use writeback strategies on our side. The current 
implementation focuses on batched writeback of compressed data from
zram, managed on a per-app / per-memcg basis. We track and control how
much data from each app is written back to the backing storage, with the
same assumption you mentioned: compressed writeback is primarily
intended for workloads where latency is not critical.

Accurate prefetching on swap-in is still an open problem for us. As you
pointed out, both the I/O itself and on-demand decompression introduce
additional latency on the readback path, and minimizing their impact
remains challenging.

Regarding the workqueue choice: initially we used system_dfl_wq for the
read/decompression path. Later, based on observed scheduling latency
under memory pressure, we switched to a dedicated workqueue created with
WQ_HIGHPRI | WQ_UNBOUND. This change helped reduce scheduling
interference, but it also reinforced our concern that deferring
decompression to a worker still adds an extra scheduling hop on the
swap-in path.

Best regards,
dongdong


