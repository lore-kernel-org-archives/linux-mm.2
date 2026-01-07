Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64174CFD642
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 14:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CA946B0092; Wed,  7 Jan 2026 09:36:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6785B6B0093; Wed,  7 Jan 2026 09:36:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559EE6B0095; Wed,  7 Jan 2026 09:36:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44C486B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:36:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DBC311403E3
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:36:43 +0000 (UTC)
X-FDA: 84305419086.02.D8E7809
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2D86F80010
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:36:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LlJGPpB4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767796602; a=rsa-sha256;
	cv=none;
	b=alNbGlywxFerySaUwRlFPT5u4Zu4UKJS+3UYM8Av4EIjRuMDYHZMUb1KFv8qrmpBjT9Qrm
	Ip3BSFrgdAQabYY6znYfZuZPtdt1evkX4Ep9tG2P3GU83qwe5/q8SAUdMCbw0T59UzN5ZN
	KRdAwb4cl6Rpnt7xwxJQeR0JJl7KkdI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LlJGPpB4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767796602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+/s8cv1+GfekKYCR16yNNn6Bw0/Je1efKM6ddt+xwI=;
	b=rtOLUdvBmKxQqo/KjHt3EoMzFsXUJPlQv9th06SBkEUvcpls4VDIRWH2TlG/Bhi0voJxnt
	bapAWVcXQHhDAqwojcUJVXU2DWbjvRahM50LebB1qyKltsvm4SRh6ahwgSBsbgcCm3XaId
	b1OboeUc0zfkEgAPDN+JW/ICzp/RR2A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 637D16000A;
	Wed,  7 Jan 2026 14:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92915C4CEF1;
	Wed,  7 Jan 2026 14:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767796601;
	bh=U3GkqvVUqLIjI1hj3CxuNpDqnrKa0rqNuNhg+EEUs0E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LlJGPpB4PeH97qZ76RytczaHbzZVpk+PYs5EIz8e0zN5N2FTXhH86qT9774UnsbnR
	 VAP3bVJDIQLBfY9/VYuRZ9qNIEzSGGC5QtIjKaxt53YYk/63RiMGwPQ6r8h7JYqQ23
	 hr9f7DrCvnbmteJ8BtvaG1azrrhk+IKWIAB80EvgDcLqGpnsk6WBjUUev4+kjwn5XN
	 fnBkcaHN7760UuFlSFnrwceAYAHJh+EZ5rM8CTy3f2E+6En4gX6VIKua0HkCkzstwG
	 Ghz+OqC/7NijeuY1xDj89O0nbr1g/kT73bTBACxJ3mql0F/yq+I7guzjVpaob375cX
	 IrhTr/2EB+XuQ==
Message-ID: <cb269767-688d-46f1-8d82-1fd6dc32e94d@kernel.org>
Date: Wed, 7 Jan 2026 09:36:39 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] NFSD: Add aggressive write throttling control
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@kernel.org>, linux-nfs@vger.kernel.org,
 Chuck Lever <chuck.lever@oracle.com>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
References: <20251219141105.1247093-1-cel@kernel.org>
 <20251219141105.1247093-2-cel@kernel.org> <20260107075501.GA19005@lst.de>
Content-Language: en-US
From: Chuck Lever <cel@kernel.org>
Organization: kernel.org
In-Reply-To: <20260107075501.GA19005@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2D86F80010
X-Stat-Signature: 1ppyreezpwmw4zdzodn5kw58e8khowa9
X-Rspam-User: 
X-HE-Tag: 1767796602-252906
X-HE-Meta: U2FsdGVkX1/nIQbh5sCRqaZqjXU/xY8VCGMJe69sgyfIWcGWQuIqXplPQNJfC4t08ao6QFrpB9YRbaQn7LdHDK3O8rJPEjLA64Z3lUMTGYZ9ID6buvn7tGcZ0SVYzEsNDWU2xWl1JVvj9ML4pSBpDx8qiSMEKz0yUraUuFpm6SfNm11AYfM5rK0z3QQoqBRMd1A6+eW3U+sKeiGlE+Aeq8uWzomiRM9nOp5t4rHscKueE5OqraoncJACUI5m/iiklT57koyRtHl0YyqBhWDvKXDhzH2V17dQeTIYp2k+cdbERZixtTExJgW0Cvb8nNMyk8iyJ5WMNKbi7nL9t/3wkwU0h/LKT2cEAnP+UjMx6I7awC7h2cBoBhfwXxem3pFu49U5d8EqqrrHTdyTvHNm4fb4drQZ81uVFVE+bRhIztltd318S8VCBG7NplOPizvvKQp8RAyNtuZ4owuJbCWdmNQgBuGIDSAO22fY+Aa45SqNBqhPOZiRSsqwL68dkn57CLPJ62qGbbWFhSIOnBtvpy22Dnc2wQG2QA3nb/B+yVWHHKeqqm1KyNVmX3e4uYK0RLO3Pv3a37gaEYm2tdyCuiKxtByctHN6AF006PDv11o4lSJkV7fq8dulJlxuCOrNQ10tcjhC8I/Bb1rLqtDBPorTylqoTUG9vEB+6TtDctRMTbFPEaEZ62nqMagu4Ph8s4cvXJbLhbH1+6nnRkRRvpZzL9RmjJwIs8n4+dHl6suTVBr47eUNNRIjQmLDd6vOfBeoK5yDqKdY6ak3R9lgqCSnog4dnzFDoVaq6jLDUhAKWThiFUPwdxvmsbolB3UTxRg3QpsuKWE2MXsmL9T9m5WcmMdgenKSeQZ0BDVcJLa0hCItk+wXvGVUP0LPM00zv1LmVwoQdsvBruZ3qznDyG8vRSUVqWrzpJfZqRn9nGw69FnPbWaMVKf0dIX0x892mKkcVerbKUFRUNC0Kps
 KFoHTlCT
 GcciVaMCopa5epZCLjlp0EhMMRFtYDvL1AzRcMQLVRa7ZVoHXIiUK0X/VE78f9Oa3g1CuVoK5YbjEQc/31kYT67GMzeSUEL8eJFPK+xehZnEnThleKq5pGqUi9KgDkAvbAAgbfI/ceJNtiR6exIYn/GB3CIOkFC/Y2xCSJCVTUwIc8bWeP2G5dW+Jx/IJzxrg6YjNdSJu6QF+/OdwmQSB2WB1s5XGva9QRb8w/aovxxIiiownZKRr9/SVcP1A4iKC/MFHQUbfSlwrIh+VRp/DyF9WZv6nvqPmrTdFLlQ58bEXPxuWmOnN+qL4Ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 2:55 AM, Christoph Hellwig wrote:
> On Fri, Dec 19, 2025 at 09:11:04AM -0500, Chuck Lever wrote:
>> From: Chuck Lever <chuck.lever@oracle.com>
>>
>> On NFS servers with fast network links but slow storage, clients can
>> generate WRITE requests faster than the server can flush payloads to
>> durable storage. This can push the server into memory exhaustion as
>> dirty pages accumulate across hundreds of concurrent NFSD threads.
>>
>> The existing dirty page throttling (balance_dirty_pages()) uses
>> per-task accounting with default ratelimits that allow each thread
>> to dirty ~32 pages before throttling occurs. With many NFSD threads,
>> this allows significant dirty page accumulation before any
>> throttling kicks in.
> 
> What makes NFSD so special here vs say a userspace process with a bunch
> of threads?  Also what is the actual problem we're trying to solve?

The problem, as I see it, is that the system is not providing enough
backpressure to slow down noisy clients, allowing them to overwhelm
the server's memory with UNSTABLE WRITE traffic.

This is the same issue, IMO, that Mike's direct I/O is attempting to
address. Our implementation of UNSTABLE WRITE is a denial-of-service
vector.


> I kinda hate having this stuff in NFSD when there's nothing specific
> about nfs serving here.
Don't worry too much about that, these patches are obviously not in any
kind of merge-able shape yet. We do need to understand the metabolism of
UNSTABLE WRITEs, in particular, to get a clear picture of what needs to
be controlled to make the server autonomously stable.


-- 
Chuck Lever

