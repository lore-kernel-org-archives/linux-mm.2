Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A56FCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C959F6B008A; Wed, 13 May 2026 09:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46A16B0098; Wed, 13 May 2026 09:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E5C6B00F3; Wed, 13 May 2026 09:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CC996B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:20:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26F311C0019
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:20:30 +0000 (UTC)
X-FDA: 84762455820.02.E8593A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 27AF74000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:20:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aTYH39Ga;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mE0bCltYuQEzJnDp579JvHnSctx/8nXmN4rhG0HJdB8=;
	b=xFxXFbmRK1Bxn/XjQvZMByZ3eC8D7LYIpWjj6I5yzZqPv2HF1vybh3d9CgekH/dj0TEEhr
	Va/ZoXsOJoSjcmLSKSr0IIkNsio8toDk4YzG3wQ44BY9cNqMkR0M0GCTf/eyUT83gn4Hq4
	am/5PBlRTjurf38zefobF3el9L6VBHQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aTYH39Ga;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678428; a=rsa-sha256;
	cv=none;
	b=fEVKPsa0u1sofTSCzyIiOR9EkSjwzGv3L9IgiP4uvE1VOXeIC5jrkyn3b+D6Xg5UjUNeQV
	wwDGtrUj66FZhDwq6eCjM9S/ttG0FFaWCvL2ciqGENTvwV6YQFfLYRKIMFzPFE0EPMH/WR
	aNEUEthA0rXBhswC+QB+XgFQVaYyGo0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D0634444ED;
	Wed, 13 May 2026 13:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1684C2BCFF;
	Wed, 13 May 2026 13:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778678426;
	bh=mYPlP7BhYPRmnKvhMakPBxOJsC1+fQGpxM4WYNcNWxQ=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=aTYH39GaDWfyNYxmlTbxqWG5yyl/nqPV8orp+2b+V1dTd5UU9hw2mYdeuoqocoKo4
	 2ZxZD4OIQRoYyofTL46wjmPS9b2d49+y9ZWwpH2TUFRgExrUqP2Con5OBQSuTa15UD
	 lfIxlzBeSKSfZEunwQfD62A+Ngyyz1bPB1ZWYUpLMsuzyeQvNxox0qpa5YPF2rCEm0
	 OzddAttG1jvcOC6q9D1YwdpZ+EGScjoquQEbsfBKFE0aAx78QoJdd46OvGnFevl9a6
	 vji/MJDfY+01wWmnlG18ypeRv2Tx4pZAA1DcvgStvSq1iwUp2i1JH8hjXqyZqzyjTT
	 ZVbX5VcHTW2Yg==
Message-ID: <a3eea8f4-d693-41da-b8ab-764e6ce311ad@kernel.org>
Date: Wed, 13 May 2026 15:20:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/base/memory: set mem->altmap after successful
 device registration
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Georgi Djakov <georgi.djakov@oss.qualcomm.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, djakov@kernel.org
References: <20260513130900.2204499-1-georgi.djakov@oss.qualcomm.com>
 <f25f1ef0-5359-4c00-920d-cdfc37cda968@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f25f1ef0-5359-4c00-920d-cdfc37cda968@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 27AF74000F
X-Rspam-User: 
X-Stat-Signature: r3xnscqg1yefezzgh8y7j3gkr4fzhohw
X-HE-Tag: 1778678427-366634
X-HE-Meta: U2FsdGVkX1+t4oWp0TjpOCpv1Xb2s1GlIL9GS0nG1W0TyBbOVhSpHGXZBADuT2DikPfh7+HvpprafmLnAi9F4Mem9YuKsIMiInRF0ZToDQjr3xZp0oXJKK2N0rL4tK2irCl48hfEZ9HNJSRR6RFXHVCfq1FdODY0RGnEZ88h1kK7mspc+WGKTyTuA9wkw8yzHELVE7aWQ4IdAqOLGbRb5QWbdKcZuME2cwXfJGlnUyfR9AVBv1cLuMY1gAF8irMpqGm3oiij5TQTN6TIiwI3iCOKTE/4tmUtrGX1p8wAM9XCEYLzTpoYj8c1pSZ2cHR3yjra+AHZPkdOBhOmozpnhjg+n57jVA6ak3XxxZSSZLV6YdGv6eVwJ116v2OZNpCU0hUYqc0Dr5TjeydD1TLIAXF8j3UlP3x15AYVfRlZonENs5Ss0AIIXJOMzFZ8ml9FsoHCp0jFDuMJbEMVWyt8BBwJ83Rt0BBILOCBN/c635O/jX52wwQJhyAuQOReER4zdfDBQzRHUL5a/EeJCdAqnaQeW703+zhKbD+CNw3LKoCkj71Q2J0M24e/5hRoLMzVk3R85tRvz5PBwNXtOWKuaGHJ6row86A8/9QbBJFvEF9KkJPln/e10ienbQTBbgcJfCmACQ9TwU40fwRKqmM3xSmJPOf5b2o5QKhu+9UTud4cylXfsefo5WQuVhd7TCWcSu8rPb8VyI3DKXiC4zt09SBRrxw3s8dqmGyzOEmnLTVnS5j9mnBPo9go1xahkmWqOHiWB/4iwm35LGDIuggsTqbSu69zAf0PLdXrNeN7aQBAtn8sBG/ZYOVAvxup4F30Qo/1PfBknS4o8taL5YyvzScigAL92xBKVOr+wuoWzo1V6Ng6KY2LhidNUSpzJfAiKh9Lr99JEQyydisyq+RxigBdl1SKbWb0SBZ+rAUYmv28aE+8BE4Zz5kj6HmA37b9CmLSec4iAVY2i9+S1mO
 +ZzfYsF/
 suG5BINCMiqbzU48OP2zhqsiGnjJSq7/rZyV30OKuzzcUdQiI/NGdTLAxo+2+4Yg+/PuxssnvWv7g3SarBYrE8By9vGjZi88HFCSIWhCieJe79fp2OeD3S2euJArynl533ea/na7+9CY9xewtSINE/I5wyZq9aoy1wrUTBQFWTMDu8BUwYjWasWNs/Cv2DcfvUjFstWYzd7vP6q7Ib4YviWFX76IQnymuWo4yYNEyFhTeTeOKtTKcPaybeN4ucBHSVHPQzt6F2HkpjcDV9RcdzZK7ZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 15:14, David Hildenbrand (Arm) wrote:
> On 5/13/26 15:09, Georgi Djakov wrote:
>> If __add_memory_block() fails at xa_store() (under memory pressure
>> for example), device_unregister() is called, which eventually
>> triggers memory_block_release() with mem->altmap still set, causing
>> a WARN_ON(mem->altmap).
>>
>> WARNING: CPU: 1 PID: 76 at drivers/base/memory.c:96 memory_block_release+0x28/0x30
>> Call trace:
>>  memory_block_release+0x28/0x30 (P)
>>  kobject_put+0xc8/0x1bc
>>  device_unregister+0x2c/0x68
>>  add_memory_block+0x1b4/0x214
>>  create_memory_block_devices+0x9c/0xfc
>>  create_altmaps_and_memory_blocks+0x130/0x1cc
>>  add_memory_resource+0x10c/0x21c
>>  add_memory_driver_managed+0xb8/0xe8
>>  virtio_mem_add_memory+0xa4/0x194 [virtio_mem]
>>  virtio_mem_sbm_plug_and_add_mb+0xc8/0x16c [virtio_mem]
>>  virtio_mem_run_wq+0xea8/0x1088 [virtio_mem]
>>  process_scheduled_works+0x18c/0x300
>>  worker_thread+0x1dc/0x2b8
>>  kthread+0x1ac/0x1f4
>>  ret_from_fork+0x10/0x20
>>
>> Fix this by delaying the assignment of mem->altmap until after
>> __add_memory_block() has succeeded.
> 
> Something does not add up here. How do you get an altmap with virtio-mem?

That patch itself makes sense, but the callchain does not make sense.

virtio_mem does not set MHP_MEMMAP_ON_MEMORY, so it should never reach
create_altmaps_and_memory_blocks()?

-- 
Cheers,

David

