Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35638CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 06:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059F16B008A; Thu,  8 Oct 2026 02:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A326B008C; Thu,  8 Oct 2026 02:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E634C6B0092; Thu,  8 Oct 2026 02:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB6CB6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:20:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2162A1204A3
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:20:22 +0000 (UTC)
X-FDA: 85298459484.28.5BF89B2
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6BEAE1C000B
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:20:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Ke/Tbykm";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791440420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBjIFJjH1YSESX6XKsyH3s55ktCin3Q3Ic6wYond1xU=;
	b=e4PX0sfsx/VKfYL34PcL8VRxmHYRAvTJv+adRHfHfqSZAU9XV7jgrZ9eZEep9s/ZILLpW7
	zXPXMTTZ+owCUWjGNRn+a7I43vSvKqAawyyVCvw6tRQgc0T8M2meBkz8FtM5VWWI8rwIbz
	hbq0e1KSLmkZabC5ovo+h0FyITVQcIM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Ke/Tbykm";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791440420;
	b=00FMSQx/OUFB4Y+aroJAM8kiMBrXQGhwkXGrwRVmx7ZU4fyqElaJix23iQrAJsEGEYsQiM
	96Sa8d4HKLxjvywKo+injigh8AKBrJWyhtijZWHjKn1yZNWZnoxrjYCBHF3ahShfHCQt+H
	jqKCa/8rhnOAJMqIm3Bi0tVhNyqX7Xo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791440413; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WBjIFJjH1YSESX6XKsyH3s55ktCin3Q3Ic6wYond1xU=;
	b=Ke/TbykmgbT+gud/+G2OUkea8+LhLcc0w6t4NzXXLvVJgqkOy70RxPsPyBAXimlHeIx9q4FfNWiBn9aPcfYybw6ixNGE6E3oeWCQdI1dDLRRZpVy5xbQ3RUhaOrTv13HKriVnjtd7X23y0C4Ev648eNDeO3UOqBEEs0IPIccWd8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XCKvm76_1791440411;
Received: from 30.74.144.149(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCKvm76_1791440411 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 14:20:11 +0800
Message-ID: <fb549f87-c6ca-43e2-be19-ef0bfbc5e085@linux.alibaba.com>
Date: Thu, 8 Oct 2026 14:20:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: flush deferred unmaps before dropping a
 failed folio
To: Kyle Zeng <kylebot@openai.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 outbounddisclosures@openai.com, stable@vger.kernel.org
References: <20261007041001.43181-1-kylebot@openai.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261007041001.43181-1-kylebot@openai.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6BEAE1C000B
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: d1e1eb16wfzgujjy7nh6a9b7oc43umq4
X-HE-Tag: 1791440418-732001
X-HE-Meta: U2FsdGVkX18GoLVkaluqfAfWSMnGMWvv7gg4mq43ou/+zTxXWxinEvGOndxayz+je7FLTeYxvr8cb8GGJUbxuRiYN0wtlFIU7+w/0e9auXh4NN96Gllyf9X6IE8GMUUL6wiO6bfGDOLk7pikBVlJ1N/zQ2f/U7Z7hjhNIrLA4jLUDhsUw5hKN4A+fdd24rpX0FjCwqW2UcfU0NBzYe4tu5bC6DCp7QCewwo/sKcY8R3XbMGt66pDFAyj8ex6O4S/PYyUnJhqe6xgBmXHxSzUc78wHP+i59EWBmOvpWO1H/Nv75Xg6LjXhdDO2Zvz7MydF6HcPEEB9vti+cKIA7M9MvpKga2qUIcAcX/Abz8R2kDbuUVtH226b1iuhgZc4a2wE/51sY4ppy5OpNPsWniAZqh9z6QOFfxhYWS8BjL7nWXlZAIgc3L06PVSwgzujpzWFiLdDRz/V3ypZtBBilqjf/RG6dn0aTggVPViGAq/jo8j5kAkAQ98hLFLxt6NNJoTlb4cRFMYG1gl25zhrz2LiiD8eeZTO9eEOrbww7ymM3Zrt7vQrODvrWh3xMVdbFOysdKSXIZMn+pvYIyE99jNPUQKhBrL6lPUxo+kjLCIKGiv9iC2PnIF0G5BhOZ+VUZ12WL/bYi9Pu+wXlPXx7qBAlfdPRxQGKgyEFhriM/4OjpjMy6QqE9+gUUlPschPg1pqAJ+CNJ21ttWXz/NMXwNQiyI/0cK3yLtEL7aUJ5bqMPJNEGOLA3qHpRRaXqGZNhPWd0ZQJvjj8DXfQ6s9lGQwn+gqwNw36KEKnr0au/wc9XX4r4ElDovwrsINUlnwbAn2K4hNQRKrDXdm6CZ6qGE2EmxzBe1WxzCDIFuqiarozqfTRdeeIJsLZxkJBydIULtMwhuVKZOYv1Tf5FCabSbm/JAJyAu34L462t5+y9+iJ9OOQ3rpoyNYxTX5iZ+SUPLgUaw1xekYyv5k2q4qJj
 KsIsl57V
 pUZAXt0DsoTHNCyN5nX5whUmNQcl5iJRMbCa/dD4vH/f2OgMwv94x6psnuy2w732zEfQdFJ/zhWk5cBVCxi0nYmmD+hYihGQ+GHQ6VQCfFXEWiFT5LmRYpf4MNI3BpyfUvcezRpnASZDq5MHniE3EGjSqUQg0Bc29hzQYDJgmsk+LaxqJ4apw6c5ukuRfaZIN+PZbeWUTdDZ+pi+T6OtZ6lkAygm07I3XqExbcRSaCxBrH9GLI+P+LVNtxcgCHcM851DUQPsCOC8MBzUJKj6EXBmT0OVY+95PVfFK2eodtUPzMy3DOuCzI0JLP3+E42fSKxJMdiBkYWmVR3/4dJui1LlrSyyZOKZYz4mb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/7/26 12:10 PM, Kyle Zeng wrote:
> collapse_file() can fail its reference-count or dirty-folio check after
> unmapping with TTU_BATCH_FLUSH.  Both paths put back the isolated folio,
> then unlock it and drop the lookup reference before reaching the common
> try_to_unmap_flush().
> 
> The page-cache reference does not keep the folio stable once the lock is
> released.  Another collapse can replace and free it.  With its PTEs
> already gone, that collapse cannot flush the first task's per-task TLB
> batch, and retract_page_tables() skips short or unaligned VMAs.  A CPU
> can therefore retain a user translation to the freed folio.  This has
> been reproduced with unprivileged MADV_COLLAPSE on a memfd.
> 
> Flush at out_unlock while the lookup reference and folio lock are still
> held.  The common flush continues to cover the accumulated pagelist on
> both success and rollback, preserving batching on successful collapses.
> 
> Fixes: 6d9df8a5889c ("mm/thp: collapse_file() do try_to_unmap(TTU_BATCH_FLUSH)")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Kyle Zeng <kylebot@openai.com>
> ---

Good catch. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

