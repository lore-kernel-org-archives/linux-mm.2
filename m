Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD0D7C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06AF26B0096; Tue, 11 Aug 2026 11:40:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01C976B009D; Tue, 11 Aug 2026 11:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E76D06B00A6; Tue, 11 Aug 2026 11:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDA6F6B0096
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:40:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66A441A0485
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:40:19 +0000 (UTC)
X-FDA: 85089400158.05.6303DF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9757340009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:40:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ov/DJFsT";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ddfzN4LL8RZM548F01f0B4b75hLtyEj0OXR4HnBvYcI=;
	b=jGoe50tEpyqRp2k7MK3Z5P1v4P9CJmRGjJwoH9pHvWx5v9JCAIyveJJJKEBiFh+3jbO3q8
	nft1ULi/0niP8wO51mLoRiHcSgPjMwlXnux4k9DK0tzeOx7x8ijkbrHnWl6/mWBJttlKHj
	QrFzNiusN+4Uh6f8eUXTugdZ0afOdxk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ov/DJFsT";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462817;
	b=fmb3MxLABayUwetPrNoUnsRwRzjVN0DCmzCJ+N1sxqQ2qjmZD3CO9KLdzJ27fj4LAUv49n
	SX3wsDzig9K1Ft396v3OL206ZNseWBYGQM4iqTmiKprvVw2Z6Thf4n0NVxyF5hrqXAbamS
	Gdr37UwGgsNKdBQaleLg4ThrfLL7Zmo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C19B543A57;
	Tue, 11 Aug 2026 15:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0CE1F000E9;
	Tue, 11 Aug 2026 15:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462816;
	bh=ddfzN4LL8RZM548F01f0B4b75hLtyEj0OXR4HnBvYcI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ov/DJFsTT/RxE8H1HZktEketc8VZ1xNssjfKJAtsCRLXL0JwfSbWma8R2mYelXbwG
	 TIMj7STY/TbE8asPHQvVk/4PEcSy3yg5hzv7cISm5vkJBnWmeYMZQkgevLCI0aGTvR
	 iavwXtn9Ksfbl3jvLLGxcVv8N31CGy+vKzVQx4v3MCz2/ztQxXXDRZPPPpt3fxfUwq
	 ArZeRMGwXhFPm40Kc81toeV1wRsxolfT1qaG/dt+YtFNF0UHKOdVaHJUXDGipNKQYI
	 BeBJ04HCzt7hNbvuBVuEG+uNNIDKAA9/F0dpSz3LET/jL13Hx5SFK7mVgdbG0+lmFp
	 w1rilioPGtF8Q==
Message-ID: <479ae96c-bb84-470a-aa2f-f88ced0e0dfb@kernel.org>
Date: Tue, 11 Aug 2026 17:40:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Make VM_FAULT_RESULT_TRACE compatible with sparse
To: Bart Van Assche <bvanassche@acm.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <e56c9e2aead04f79192c3110de80d846e41e3791.1786122711.git.bvanassche@acm.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e56c9e2aead04f79192c3110de80d846e41e3791.1786122711.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dsj38f9puu16zq4xn7w16q4zemo1u495
X-Rspamd-Queue-Id: 9757340009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786462817-793480
X-HE-Meta: U2FsdGVkX18fR2wU/lxowMyQhmlyKsFpdjWwfz9kw/rVRIMC66rqZqzYwEkAEKjddcxaGVIFOhdRiaQwvybBxv//t+6d2v5xB5x865KPNuB+iZXps5R+GsCx6NDTQgI0OW8FFbEubsAJERC4b10C8spElkNKc41p+G8ZcKadvhoJAXr1zy113MCSmUxYX2XunvVpLhj/C9WgXiH26DX6VezuX5rbijn0XtqgVF/wWHArnrCE7HSDQuKDpzKK/w82Aw4mqrRwyswoiieSKNUhagt2l2cDkSHt8yq4MKTowydoa3R8sYQzvr/XFncUDlWhBm+COARktPJfDLArn+LQXY6+3hDSgfFFasa9KKhUg0CZJgcJHGq9jYuFL1ZZhmt6KN1yeSj4imoJkq+AT1JLBLHDdPiwsbW6uxjUqPRJ9ttBPWFuJihXv6daXZnVZ23sbWq0fG21ZBMCFk6XdBYmbNBcJMAWzCI9p35UQgs0Oi15Emly72wjA9/gMYL7QTZv7CVlIYuvsIwi3i825gAvs+pfv5+ZhBm95NjL56Mgv+i7C9GYF9vYDT76hVYu/OBBV+UDDiXSyFdOy4LOu/4heCjJo7OiWS0eVFn2Dezf1vvwdtukqEoG1t9p2N4cxVZIEvWlhVdc1lJAPfjOuLYEwy2t5lfr5y0kRtv8eXqyVd4LAYm4FqF8LAQPm0eGGL4sk8qUxCbXGOGA+A/jLDdNFVCNlOuAWm6MZ9BZX8rbouYDGnFqibI4nvBJlkW2UqcnfZshEu6dejc4aUowhosX7VKu4zQDDu/uUYEzOp32vrGmopx+Jus4qt+/nqFqd8UlqWS2Z3/9J5rHgT7+i2B0KQCIYNnA9OdAQBM6ruIL3PVLb6s8ts6ty1zPhDmASMsnA8MIWBi1tu26vJSlJ+f9PGn5WFBe4a2BDw2YM7cAxXgKY6Z0F4R2UMQNSw/V52zh4cRa4Kg/ZacPYgjNDjw
 WC0BLK0N
 WL990nsyKmNmLmlA6fxEpniv0aFo9fb0iEPTO4ouJytJ9COY168HeloB+dLvXAr21W3ssLq7GCQwDgshfFOAsydTzvnxioWg5CC3RlLLXgDcmNJkh6MwXAck14YSM1YdSavsCd/EZUfPftXsMFdFdrWYEs8GGQh1URtTu3IoBcs8xBICrAqXOST1DVuvVp946DcDVG1gR4c0vAczHZaWATtIU9CxpJbnIgCuhUjhKDsdJVMsa1yM5J8NFO1ynpHN5AcLf/jBpB/MgeLA3hBIOa5LvZ1DLfGjcnWhIKcsdyIJsDUEz6ro9hsiXTVv3DPZxKMTn/qLu+yK0nlzGhepcFlRXAg75yXm5mbH6IGIqd4G1yRxRX7f/jQYpM/oSBCOOnsgUKMWkayoMAbt6lfczOUSTlXOC4IMSM6bNk68qOsyl7PkWLVJDHtuOdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 19:13, Bart Van Assche wrote:
> Fix the following sparse warnings that appear while building f2fs:
> 
> ./include/trace/events/f2fs.h:1469:1: warning: incorrect type in initializer (different base types)
> ./include/trace/events/f2fs.h:1469:1:    expected unsigned long mask
> ./include/trace/events/f2fs.h:1469:1:    got restricted vm_fault_t
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

