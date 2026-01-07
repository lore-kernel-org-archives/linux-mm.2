Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C45CF6BF3
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D58A6B0093; Wed,  7 Jan 2026 02:28:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACA66B0095; Wed,  7 Jan 2026 02:28:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 000D16B0098; Wed,  7 Jan 2026 02:28:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E32BB6B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:28:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 908C31A01AE
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:28:12 +0000 (UTC)
X-FDA: 84304339224.15.8881F48
Received: from mail3-162.sinamail.sina.com.cn (mail3-162.sinamail.sina.com.cn [202.108.3.162])
	by imf13.hostedemail.com (Postfix) with ESMTP id 528DB20003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:28:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=N3JMU7hp;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf13.hostedemail.com: domain of zhangdongdong925@sina.com designates 202.108.3.162 as permitted sender) smtp.mailfrom=zhangdongdong925@sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767770890; a=rsa-sha256;
	cv=none;
	b=3y2LccTMNcSNj1HO0oOiQCugZqLHcrjiM5z802orsJTFIkNZzpp7y6wv41EZ9aaFZ+hSqq
	0pfaI/F2mkKYTzIVa0jAsYMsugfWvIcL9IZ0XEtVBHqmwGExIaaFdz/epqdsfvGUJFaCSt
	N0bOEYIeIqbEpc9xUnoGQuIy0qKmEPU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=N3JMU7hp;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf13.hostedemail.com: domain of zhangdongdong925@sina.com designates 202.108.3.162 as permitted sender) smtp.mailfrom=zhangdongdong925@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767770890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCDQKkv00dee+7Hq9Qla+ViyMcC4NAiMlT8zc8Ml/os=;
	b=EHtHZ9mV8eif4UBVpdY20hpk5IstJSWkog+0VWk1cVu/ABeLpkCZY11Ist7cTjwvYpeCQh
	m6yO9sEwgDOWQuiQs1bOrG87tTck1zx+TBAPA6oPP5DYKASrp0NjD6IhYpZhow/bemuCdQ
	4SAE7BvzpkrJ03I9wHEuVEv7knS4xY8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1767770889;
	bh=MCDQKkv00dee+7Hq9Qla+ViyMcC4NAiMlT8zc8Ml/os=;
	h=Message-ID:Date:Subject:From;
	b=N3JMU7hpdGUHTMBTyYRmJd38YODiyOhQh2sNcbox24zxEPowuulhYs9DLMv7COQkl
	 1QuT6pksCmiIR7y3CDnRLGI+Wdrc4KoF4hFLbw/M/8BPwW9HkfSvqdgW7d2PFb6+IP
	 i9NhstIvjq7oqVQh8qJqPp8jqCIzGgoAz9t3SVK4=
X-SMAIL-HELO: [10.189.149.126]
Received: from unknown (HELO [10.189.149.126])([114.247.175.249])
	by sina.com (10.54.253.34) with ESMTP
	id 695E0B0300000142; Wed, 7 Jan 2026 15:28:04 +0800 (CST)
X-Sender: zhangdongdong925@sina.com
X-Auth-ID: zhangdongdong925@sina.com
X-SMAIL-MID: 8978036291840
X-SMAIL-UIID: 5D5FCF9AA3104E0E9780317D09358A48-20260107-152804-1
Message-ID: <2663a3d3-2d52-4269-970a-892d71c966bb@sina.com>
Date: Wed, 7 Jan 2026 15:28:03 +0800
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
Content-Language: en-US
From: zhangdongdong <zhangdongdong925@sina.com>
In-Reply-To: <7bnmkuodymm33yclp6e5oir2sqnqmpwlsb5qlxqyawszb5bvlu@l63wu3ckqihc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 528DB20003
X-Stat-Signature: ah49fngm1hifix96bm9rr6azq36mykpo
X-Rspam-User: 
X-HE-Tag: 1767770888-83134
X-HE-Meta: U2FsdGVkX1/vT7DIdw68bJUG+aHIw7YWI3QhbXglcMN8dLTWIB3dkEZuYMnm9L3NMCTNKd2+e/rGUs8r+55ooOOqjAoD8rXDECfL2XIQIknSV55EUDHm9s8UJEjxsRxvOaarz5uuG4Rx6pzn8aNS0j4RUd690grm12CM+TagQ7zBe4WwsYTV2wmRwlNjwdj3ESWjNFp8VyeA6rz86r2Zq05ffA9TdIYHWxx6h8hjGbbqrpVF8BU7M9ws0itHvFybpv5ERwOCT2UaLa+RBn7Bjm5f9g2Rz3+kUy4ScfxHRWjXvkNN0yc509DA7fMPZNc0VgEPEdhNWyLrvrqd4snluZqO8lR7TXczK9B7AyIjIF0ga70g9PdJFFfqh/u1v+8QkLHgUJ5QloNyTrtMtHTiIXyhHaI1PUzU7Tt8mSGjfc9FVB8A9E3B/gqVkoIgWJNl3qFRfAbT1+GKiQvPlI1w2nHR9m2WfS7NlOVApnUlfnE9Ofjf2fZE+Rpg0E4gX0d9AgbLQ5jzD6zXD/AGSYeqf2QtGOSL7gc8KTpImL9/4Pp5bF1sCePGt5QteQnBxmMTtuJhf/kXjP9n1DEEDhSZUOCdB59YCUSPtQ7pWNWBohetzcbTP9CB/vqqnWfVJMoCLI0+rKzjPN6uXqbfcvuU2KOOSJF4jcBfkHgR3xdNXFZ7btVIrkM+c6rHHmop7VNFKCTRZRPvOxd/g2MZ342vmMZqKLbfaxJTonLrB2SViFS1oHfcDJOfNgy2VaVJZIpVx1/TVrxc+kTJABdAqbLPaIi5SiPnUY+6zX2NCLu+QL7EYmwk/pYgU4pu5ECM6CTZNMy06ctjSWjp49HHGB1Z6Ih87U8z7H15IoHaxBTUd8TYZI9WqjZmPJ9vCcM7B322UYHOp5Kw3+0maELJVVWgwyAtpYy3F571I/a3Os+Jsdv+FVzMSRXztm5Jf3iniAnVhjwOFVSRqfIi16Oh2qD
 YhrG1T8Y
 urNJ6SOqVY1X4Qeup4LWc4xtHHc+BNLkCac2++6u/QchGo14PRA0pFrPzA5XhFxBV35QtkfLsfEuFh+/JYbkuQTldQzqz+tbMnB1/S8nUkXZIXKq5TO3K8EgEijICUOTqq2CsH2jhXKB/UFHHrYGK23v3n7MbFV63l2s8PA9mD4BN023ARjbFumrKghP2jRiEYrEwiTNu3GwhH0Gmg7LP/DV1v8Bd5mLDam0PLNdbvdEM3zmmuk6pC08IDExVGofXtcjdPCZsF8f7Ph1Ov0frE4RnVeIxcoC8EPCQbgzZc8yqS/ha31dOixi87Ni7vvME10olIOa0TcJw7dIpYypOxGec4kF6z5NV/5yI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 12:28, Sergey Senozhatsky wrote:
> On (26/01/07 11:50), zhangdongdong wrote:
>> Hi Sergey,
>>
>> Thanks for the work on decompression-on-demand.
>>
>> One concern I’d like to raise is the use of a workqueue for readback
>> decompression. In our measurements, deferring decompression to a worker
>> introduces non-trivial scheduling overhead, and under memory pressure
>> the added latency can be noticeable (tens of milliseconds in some cases).
> 
> The problem is those bio completions happen in atomic context, and zram
> requires both compression and decompression to be non-atomic.  And we
> can't do sync read on the zram side, because those bio-s are chained.
> So the current plan is to look how system hi-prio per-cpu workqueue
> will handle this.
> 
> Did you try high priority workqueue?
> 
Hi,Sergey

Yes, we have tried high priority workqueues. In fact, our current
implementation already uses a dedicated workqueue created with
WQ_HIGHPRI and marked as UNBOUND, which handles the read/decompression
path for swap-in.

Below is a simplified snippet of the queue we are currently using:

zgroup_read_wq = alloc_workqueue("zgroup_read",
				 WQ_HIGHPRI | WQ_UNBOUND, 0);

static int zgroup_submit_zio_async(struct zgroup_io *zio,
				   struct zram_group *zgroup)
{
	struct zgroup_req req = {
		.zio = zio,
	};

	if (!zgroup_io_step_chg(zio, ZIO_STARTED, ZIO_INFLIGHT)) {
		wait_for_completion(&zio->wait);
		if (zio->status)
			zgroup_put_io(zio);
		return zio->status;
	}

	INIT_WORK_ONSTACK(&req.work, zgroup_submit_zio_work);
	queue_work(zgroup_read_wq, &req.work);
	flush_work(&req.work);
	destroy_work_on_stack(&req.work);

	return req.status ?: zgroup_decrypt_pages(zio);
}

Thanks,
dongdong

