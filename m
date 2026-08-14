Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A43C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 18:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B778A6B0703; Fri, 14 Aug 2026 14:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30096B0705; Fri, 14 Aug 2026 14:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40986B0706; Fri, 14 Aug 2026 14:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 819586B0703
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 14:51:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE5BCA021A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 18:51:03 +0000 (UTC)
X-FDA: 85100767206.09.704B4B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4ADB0100009
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 18:51:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mzXT+Uop;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786733462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TV8bUkdBfVbHLoK7BDmT7kXxjVr5tsUwBjeyEdijATs=;
	b=dwPkNjV7IWkeVZCKStbx5EOxxeTV7AKUCyURprQbZiBVWFeIWBxkKLCWBZs75a1elMJoVe
	lg8coKLPJwnxSXJJ+3hrYTl99I3OcSlEsHJ1LfuECDZKYr4WdfG0w+4miSDvXBKuVa3Hu1
	0PdMT1Iuh3qPSOZEbIclZqXzmJKTT/Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mzXT+Uop;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786733462;
	b=jritehnjTjV2lPtN2qQLzsM/Aa1q4gEdZkx42n+MLZYHGDEv0555o0dYkFzFVNLKSS9xcr
	drNIJui3bwv3XO7qApXH9ZV6zatT4Haz+YM25YJOW7oJyDDOZLOehPBT89aXQ5qZeiFQPL
	Y2DJU2551tIc93EnDCQOqYv+8+s+uKQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 445E240E2D;
	Fri, 14 Aug 2026 18:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56F01F000E9;
	Fri, 14 Aug 2026 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786733461;
	bh=TV8bUkdBfVbHLoK7BDmT7kXxjVr5tsUwBjeyEdijATs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mzXT+UopQ5TruH8fdX2R5O64VKqLtjeMTGinJHqMfmSQVGWmUXHgfvK+vTAj90Bgs
	 GUJGekglByQFLxslwQZKmlIO34m8kThXvkhZvKCcBjNHVnbPhD5vzNNNA2e84P/+0Z
	 k0jJP+3SYgqRKUN34ZUxuJzVSN7LFLuZdUPeO2Qc=
Date: Fri, 14 Aug 2026 11:51:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: linux-mm@kvack.org, david@kernel.org, liam@infradead.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, baohua@kernel.org,
 mhocko@suse.com, rppt@kernel.org, shakeel.butt@linux.dev,
 surenb@google.com, vbabka@kernel.org, willy@infradead.org,
 zhanghongru@xiaomi.com
Subject: Re: [RFC PATCH v5] mm: retry page faults once under the per-VMA
 lock
Message-Id: <20260814115100.24a6be0cd0e672cc3c051f86@linux-foundation.org>
In-Reply-To: <20260814085300.399107-1-zhanghongru@xiaomi.com>
References: <20260814085300.399107-1-zhanghongru@xiaomi.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ju9redoow33ocqud6syfy9u47oi89xz8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4ADB0100009
X-HE-Tag: 1786733462-419058
X-HE-Meta: U2FsdGVkX186ghG01Pk/KBihJ+hTxMKR33eOq3jhKcqOKmJtCoUIrvjV1IA59NJh6bW9QCPX4F9t0fcIj2Fsq5VMMDPzfbIpaaLvGicfHtfWnaZm3x/sCKZD5OJZ5FZPwfDknMcyzIhEbuIBmOCDi+2x6ionyNuTiRDW07Cxp0UV7qaM7uedBQT7dZHFiWZBBNhGc9CU2nCNTYtzFS+0C3M7PwseZG1qREP2nkVfZDdbfgo8vueF2Xlorg5b12vvUl2mBU+qvCP94eQYBcBMBBIXmK07U5bNo4uzXitVOKigcdI8CvisPYjUaCmLvj7XpYWsV48Qb8s+Stlwm9V94VhN8UpHH0I9YBmE3+J+D0jJhcKOpqxCYz/XCYJNtdvmRa43FJjOnIOup3GgyA32D0rIyeDs+JHKM1vvjx0djomiJu4plyiZ2ycRoOdMvrTxQqhULsEi9jn3uYSEcNeOUQKsdyVaOboV1/4lgbv6gGQGtPvKljqj1wTSFM+vPqv+rnu3uel7cSovFPOg0RAvuY0htN7lmcPZi+4jYjozSn1ySHa5fVG9s7sc/vHO7A0L1DRNzf1szR4h0bT60jX7AEeRlbFq4Zc3KZlnSHJ2VDkSGU7iknCWndbnwrP8/HrSVNH40+UKOb0e6IwJ6ouZfmNso0jLmWG/CCOed0WGYQZQq50Wh7ws2YMfS1KNbeuTO3Ln4g39kxJnicGl6fwsWMLpR31I27D7zpOmmIQgkivVpZVUlii8SY8xm33F//JzizDbdQ7x94qY/eQZBgzTphfpC24wAYaUxSjWTyh/ka4lVQ5LbmjL6CjX55O27otTXKhz4qftv2Y60+Yj8ZdyRJ/xSXVo6irKiXDpxSbj/j6z+u7Mni4tcg8ECTCTFFeCpZzcoq/uojXwgeh8EuzDtlP0f9Wodr9fHVO14ZGtELsF+718bIXKaXnjhO24W4/245VXHlte7LQfAdeSMq+
 bHWcGCLl
 fims2AuyTz+JD0ds4Rmrf6yha8eKeXZbBpnkpLji0rXbBhb+Jk9JQaACQnadU0PfrOatkPsmPvK9yBxoodjhME9lIS40tWRbSMKxYH3MjQuFRyw5HuCu0zNntHWOSDu444ZlJXNWkaf5ZEyHQyvI3ldRU68niCu2JjdgQ5mg36g0EmHmYX+vyqr3qoK8kCkySvNsiyn3EI27CsJtAqvRbR2nmiF7uDSpXY39WsP2sCgEt4QxvkKTJIZ6ZegUzBrpzqXzU3zR4O4piZ5QOM1BwOE0cEriA15AubtsW1OWRLUgDPXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Aug 2026 16:53:00 +0800 Hongru Zhang <zhanghongru06@gmail.com> wrote:

> From: Hongru Zhang <zhanghongru@xiaomi.com>
> 
> The per-VMA lock fault path falls back to mmap_lock on VM_FAULT_RETRY.
> When mmap_lock is write-contended, the fallback can reduce page-fault
> throughput.
> 
> Add a single retry under the per-VMA lock in the arch fault handler
> instead of adding a new VM_FAULT_* flag.
>
> ...
> 
> Swap Throughput (higher is better):
> +--------------+-------------+---------------------------+
> | mmap writers |   Vanilla   |          Patched          |
> +--------------+-------------+---------------------------+
> |      0       | 17303.09 /s | 17899.48 /s       (+3.4%) |
> +--------------+-------------+---------------------------+
> |      4       | 12596.23 /s | 16095.20 /s      (+27.8%) |
> +--------------+-------------+---------------------------+
> |      8       |     0.58 /s | 15420.57 /s (+2658619.0%) |
> +--------------+-------------+---------------------------+

Well.

> With increasing mmap_lock write pressure, Vanilla degrades sharply and
> drops to near zero at eight writers. Patched kernel holds up much better.

Thanks for working on this.

Are you able to help us understand how much effect this change will
have upon any real-world workloads?

