Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74A63CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64C786B009D; Thu, 25 Jun 2026 06:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623996B00A2; Thu, 25 Jun 2026 06:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53B0D6B00A3; Thu, 25 Jun 2026 06:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5326B009D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:35:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A65A01A0622
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:35:16 +0000 (UTC)
X-FDA: 84918077832.01.894396A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id DC43E8000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:35:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YJjiMrZ0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782383715;
	b=CIdNZhGURvU3FtbitzN/CSFPvPmis1hxe5QLBRPVg/ySAlYk5YkApbY7xzpBqPWn0+1Lqf
	fH6l+3lM36eHF78ltYjPMF3M2pyh5HOoFgMEmHDhlU1ZBFdLR2TjstAxEFUAxdNRwlLDSe
	iPleIOjou9srGodByD7GMjMAI0wokbY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782383715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9HHE2RTbj2iNotWHLn7MMLQgGzSC89HxckcJ6YJVqXI=;
	b=zasNm3iLbwPxfBFnV1K5POgMmxWT7esAy/YHOTs1eHdNIZD/N5XJj5ZjY+bthg+fwFTK5T
	/33kISFDXEeazSFH5PBzC06AueSWHhtw+O48eUxuJItZGPviA29JPi2nkkTo7F68GAA4uV
	7qFVhnc7nzRPwvznj4RLz0FvN0mPnMY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YJjiMrZ0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D3AA43EEA;
	Thu, 25 Jun 2026 10:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1B61F000E9;
	Thu, 25 Jun 2026 10:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782383713;
	bh=9HHE2RTbj2iNotWHLn7MMLQgGzSC89HxckcJ6YJVqXI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YJjiMrZ0/8wpraKfJb25kF+R9/R7rXS90lxdE9nrUCKr81o6VzQIt71qEISgR6bMW
	 zuUp2Xzg6xGCSPRvG+u5UcnbLMipCim//ZFlA/VQEw1wGJkAT6rNElx3DjDoVGj3S/
	 FRhTdpoBidcqc9+Dw120FdCsaJO0tjeSIB//cpJ6Di7OQdkmgVo5b13u4+EgaRZuLI
	 F+M51h2YPFzy65ntiXhUVZ/x9yXMPSGt/3eXLmlvLhPuTEYcEnHF2lgukpUzHEa55V
	 gj2tCZdyJ0xpDqI4yiRt3urxerVy1LCephZK9ZhkvyTe5R8BwX1CXHyXiQuOeTCGR/
	 5rzlOr4q3O4lA==
Message-ID: <63f7860c-4f5c-4682-8914-27978b9fbfe1@kernel.org>
Date: Thu, 25 Jun 2026 12:35:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] vmsplice: fix some problems in my previous
 vmsplice patchset
To: Askar Safin <safinaskar@gmail.com>
Cc: akpm@linux-foundation.org, avagin@gmail.com, axboe@kernel.dk,
 brauner@kernel.org, collin.funk1@gmail.com, david.laight.linux@gmail.com,
 dhowells@redhat.com, fuse-devel@lists.linux.dev, hch@infradead.org,
 jack@suse.cz, joannelkoong@gmail.com, kernel@infinite-source.de,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@amacapital.net,
 metze@samba.org, miklos@szeredi.hu, netdev@vger.kernel.org,
 patches@lists.linux.dev, pfalcato@suse.de, torvalds@linux-foundation.org,
 val@packett.cool, viro@zeniv.linux.org.uk, w@1wt.eu, willy@infradead.org
References: <89ea76b3-e956-4232-8180-ee3929adf905@kernel.org>
 <20260625101132.3859505-1-safinaskar@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260625101132.3859505-1-safinaskar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DC43E8000D
X-Rspam-User: 
X-Stat-Signature: 1jzaz5w1q74a6we7wfihox5ueattfqws
X-HE-Tag: 1782383714-222341
X-HE-Meta: U2FsdGVkX1/SQ6HARj6/sgbZ/wia8RA24HauBS4Td4Bjo74pIfhLsl3p0PsGjjai4AH8hwfdRI49Ou78pV/11Fmf7ZtKilBVXOsjP3wlddDcNY+8BvT1sWPWQ1kdRIAIE2F57gr+LO5dEVcmHhcHpLKsDY3KThfNSXQmFZhdndCfxT5UqRCQvpryOLjXJyuzfEqVKhknhLufVwkrCp4vkDJyCGZEIv3e4XOd3tvg+77vrqd2SR1Z797EWuHP04DpOXFd7mWjLlN9WFqlxs/E3YeF8BMryDIjsE44P8Myk3ddDhV4ZRzXpjZNqBVOF2L2FSLno3WaB5OtvGYfllXFTBoWv3/ukBKVQEppIljCh5kXkn1hlWhFnuL1L54h1PpUGUDpNhI/cVFXVysHjAXEwxUwPdn0wcLP4UhI2bBQvC50qHYhHmrZS47WCWLrCA6IdwMgsUehzrFei7pB7W190UvGARninuHQNJUfkL5MXf1Pe0JPC6x/ZmMJ76j6+dySr0PEYG0i44eFm3HUHXEDByevlPu0FS7Rj1R2TvVBwOYGxj7theOtr+MTDhi7lFNPI9z3fcKp31NCZJYK1V4b77lLGGrUHv+33DEPOHtVDlf6XXnIHTQRgWQNjYnsIUG823FJgDYFocp78KSZHxEfO7dSrdeXuXRxCepdPuVY+hmOn/7nIQNcWkjBfcXujh1VKZgY4k9ILi0Zwcx5UkOXS3/ZXvkF+XtQdPiwCGyBQwuZlt3IsqfuJlOL/l+sp+WKujJh4KwG/gqjP4PPGogm41ZQPvmsgGKsG6PwDIFR22Lqq33aAb8v1FbnC5UpUYERNIQH22W0m884MNz/WBC/niE/MrL9wgvaDlN8Zc4LLCJlgIkO25aSQ1ySSthYHck41P7kStKn1D3CRTml67uRuNNruWtk2ya4U8GwGtqpBAYu9LcSiKwAwTF5cpfSbGeWRhyB39jPsD7Pomo8uOV
 EZat6ZL9
 pBKkKfWhMonTVBcC3bIjRB9RFMu4lT1IW1YIvBCuphAXyWp4MiiK3U+yKnUBMkbcf9Uj8XYENpEIPHx1gt3AL0TPzyx4NiHjO6Erb001pGxnwdhR4saVjCRj/IzUk2o439fj2sQcHYMxR6SX7VC30Ahb/LWtwa5ZMaux7MVcwGfea1+4BULyAzJUZkgE+U0K27oODhAnZhTP9mCky2LB4kszJomSAxhn3Ql+uBczGL3BTbMO1n6RDPuFtaz5SE06gAHA/vJygAyb33HCghpngy+956FwC5eVLmE9EnbCvx4q8+Rj4Yax7T7TAF1hRfLrQKI1BycTfk0o0JBbhH1qkruDlTy3p8HUkla6BHIUFwOOloDc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 12:11, Askar Safin wrote:
> "David Hildenbrand (Arm)" <david@kernel.org>:
>> I think we concluded that we cannot rip out vmsplice that way at this point, and
>> I suspect that Christian will drop that topic branch from -next after -rc1.
> 
> I think my patches still have a chance.

I talked to Christian and it doesn't sound like it.

-- 
Cheers,

David

