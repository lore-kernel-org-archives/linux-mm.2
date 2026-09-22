Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06AE3C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 10:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFF516B00A2; Tue, 22 Sep 2026 06:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAEF16B00A4; Tue, 22 Sep 2026 06:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99EEF6B00A5; Tue, 22 Sep 2026 06:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6916B00A2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:17:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E10D1A638F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:17:36 +0000 (UTC)
X-FDA: 85240996512.30.08F4A47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0EE5D16000F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:17:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXRwwD9Z;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790072255;
	b=jYCZsiFQB3kpuR+BkW7Q3T0a0PEJC3f4y09hYTUvJW7+Xg/aScwn7qEY4YU9zlkn96sTDx
	NDaIVtrUT7NgUTM1msWZQXV20GvTTRF2xqMlOZ+f0R+BDryctQm+WE/EYlJGBoMyOldNMY
	+jCamoGhGnWEJMqUMgBjroZuzZcQQ+I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXRwwD9Z;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790072255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5fauLT8ZuuY2ajM6FiAGbOvo57L73z/6qhgXvAWzLs=;
	b=BQxNno1BbZsv7h6TF2Cwbb1SNmIiG6CCh87eh/6k8tjNAINgxAM9irTDk496EGc6vqwkkD
	BaEW2ct1DiWNTzNASBJcO7zkri5WrNM9rMHQZvfKpjo4SyPhKYdxGw6+4VP2gQiRZMplbX
	wsceoVvEhSG8EkiU3HsieQVZ6j/SOYg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E1A540046;
	Tue, 22 Sep 2026 10:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6624F1F000FF;
	Tue, 22 Sep 2026 10:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790072254;
	bh=T5fauLT8ZuuY2ajM6FiAGbOvo57L73z/6qhgXvAWzLs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CXRwwD9ZL3yhrTkqxAeknomV92rLTDZpaQNiwJ+maRcLwpOjEIp3vAzfkJFYlpQF8
	 ly3ejSd/6IhagpAtdyOwKJPOJkbte+qSN7F6xkJ6V7y3jQRXOYmhQ9ccodDWrprsK3
	 8kmGCUDhx0Oxk6nsHx58vr+fblPEUYr4wYNzTxX493dnmE3esr6/nJk265S8od19Yb
	 tnFtXnOsqZecQ8I4rAdrkAcnnxXFWHwLhqZT+gRLl2SQ4EkdKCGKxBHQvc8xK2DpGM
	 3bB8UavCRRjP9zqE4yxymE0zbIZkk++DCriWVXKoTX8TafrEIrFR9WeI9elfdGjGOv
	 kKmhsJj7PY3Sg==
Message-ID: <f12c2f4e-a437-454d-809e-902c5fed4403@kernel.org>
Date: Tue, 22 Sep 2026 12:17:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory_hotplug: cache zone stats for "auto-movable"
 online policy
To: Zhijian Han <hanzhijian1991@gmail.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260922082207.3224897-1-hanzhijian1991@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922082207.3224897-1-hanzhijian1991@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0EE5D16000F
X-Stat-Signature: dn8cnedhzwrumwnfjdc1yipsquorrkzj
X-HE-Tag: 1790072254-140618
X-HE-Meta: U2FsdGVkX18XPXPBxHzwNKiSQDL1Q4yuAQvus7alSfVEt2zIUhIRjnTWfB7JKXTKY5Vy+6sslaFWJCKZj6LSd8GGUEpoZUqI+6Bi8QYy7hqhBNPIcWfOnASrXNNX2AcMpCfrkJeel2IGxaiWTzcJZJoj1tznSIt8/6Htv5DApvhwH7frbQOt+vwem+bdP6gLt/ESRGbk5lQ8+6rp/ZjYPxSnuhN7cz0dqoPaTlGewLf6jfM9Qp3zzojkMCKrCvMptmi7Uc9OIRhsgYBxHedWS8ZAPUPk5PP7s0wd/O01F493RAvTVhTaAoI/5fXHziD0q+Ox/+wW4z1EryjTwnPEvUu+9E/WyWLmbCofKo4vEYjR2HpiVMQnjKWBfqB3e2cXULS4LvZUa4UGf1+Z1MFlv3DhoRQaru6z6eNOoFSIo+AwDYOtF3mKt/rdmyao3hTPj70f9bhEFQL/P7RTzvouoNtcqMMfcNh7AQ0LkP+sU3oYet7ZjmGC+7UwcORgZtx6S8NDnXIEJJ3SX0RFFYlG9HfNhbmvpxcCrq0VREzooExQJk30/voLQK8K3VRSTEg7prFNLi3aqJSyFStypID3D4fTaM6oWt91d4w/HS6jnmHMNkRM1yBY+1g0jBZqrpUd85bt7PDYgAfUmJ+H/yMi4vU3TI2a/xiWuRKkz5uVcZzpK6rieJv5P+SyVT+cedlmt5y/5fHBKSCsrDgsidDbaTNWi9AFN3RMEOWA6xXdbylwGt8DmWiPfrsuBmAyzPqChRfbb2/ht/MkBwbPJYprMnyc8QUBszz+crYLnEJA1rtnDB7wIZ/wEaxK5jPKHpkcMQ7o/OW4SMZ5uDdo8BIGjEIQaZPTCvAv11qoT8oE8nxx+23cMFg3IEYJWs4rzlanhXkCurEStD3WSwDlnb8/E7hqom4vuRVefniYvWQXbbh5I+QOkGPAVJae413XVMZcti7zX0R1PkYfp5JUO4e
 py1Pcy45
 b/PnoMBwB2WG+PAWCVQ7JMEcrfco+bTGORaWajaVapljzNSHPwAb6nlPeNv1w/kU7e/NKIeisVWzmQ5ZUsox47aTylUN0M5Zi4dxj7TtZwO5wAb9eD0VWl4XmucIYLQN3fCsheuEHKaQbX+uSQJKzjNYYhUAxDO/jEkYgacx+i8ZS6qBgYr3uHCSvIgEcG2XLStkLqoiD3vngqCeZTlpzKotlQX8ewuhmZyt3s3kf8sRi1TkAUcbz2XfTXv1q/0nZKCXaA9il+waAwZuKEswHBCjgarWO0pT4FFZ31xNyi6OtGTZ1VWbjAlbwbsoobKtyO6p+XhmwC9VxSJcPHPxs32jRBj0IuRI0IuJ5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 10:22, Zhijian Han wrote:
> When onlining memory using the "auto-movable" online policy with
> nid == NUMA_NO_NODE, auto_movable_can_online_movable() walks all
> populated zones across all nodes on each invocation to collect the
> MOVABLE vs. KERNEL_EARLY stats.  This walk happens twice for every
> memory block onlining decision (global check and, with NUMA awareness
> enabled, per-node check) and is repeated for every single memory block
> that gets onlined, although the underlying zone counters rarely change.
> 
> Cache the stats for nid == NUMA_NO_NODE and only recalculate them when
> a zone counter actually changes.  All modifications of the relevant
> zone counters (present_pages, present_early_pages) funnel through
> adjust_present_page_count(), which is only called while holding the
> mem_hotplug_lock in write mode and the device_lock() of the memory
> block device.  Invalidate the cache there, such that the next
> auto-movable onlining decision recalculates the stats from scratch.
> 
> CMA adjustments (zone->cma_pages) only happen during boot (via
> init_cma_reserved_pageblock()/init_cma_pageblock(), both __init) and
> cannot race with memory onlining.  Boot-time zone initialization
> happens before any memory block can be onlined.
> 
> The per-node path (nid != NUMA_NO_NODE) is left uncached; it only
> walks a single node's zones.
> 
> Resolve a TODO that was left when the "auto-movable" online policy was
> introduced.

I have to ask

1) Why is this TODO a concern for you. Are you a frequent memory hotplug user or
   somehow working on memory hotplug.

2) Did you use an LLM to come up with this idea or this patch.

3) Why is there no discussion / performance measurements whether the TODO should
be removed instead.

I'll point you at:
https://lore.kernel.org/linux-mm/20251206212507.135503-1-swarajgaikwad1925@gmail.com/


-- 
Cheers,

David

