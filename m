Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88ACECD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8A766B0005; Tue,  2 Jun 2026 13:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B846B0088; Tue,  2 Jun 2026 13:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78136B0093; Tue,  2 Jun 2026 13:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A75626B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:06:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FB1316317A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:06:27 +0000 (UTC)
X-FDA: 84835601214.29.9D82139
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B7EC61C000E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:06:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XeASP5J0;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780419985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZ5K9M91kQ+AkSUeti/+IQh4gtRy8jNlzNE635XCeGU=;
	b=BQ/+HPWnkDVWkdaFxAgbRRq4iiSa+Z9TyvhtxsyTsjCgY0Avtgx8nnwlLoKjPbnQkhd+Q8
	FKeSrs7YkjHQvtjT3rttq48M53G9jaj9l8D+Zr2lUqfvAUOc37iWoDux7RFB/C5VrAiEWL
	F0w6DMy2mVNwqALa26dQrxMvpd7BzSM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XeASP5J0;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780419985;
	b=OxgAF+ggMFD4gVLWm2Nm60t+3I4ui+ZbJLXRpMKVYPwGmjmOuNw1DBJHddgnumjDPklT/4
	PIp7kOO3or+1Xxjrz6IG5KZMKBaoagQMiU45JXDvve6jWNM8JoJgIjMLbvM2vCyB4XlOzK
	l3/bVPYjY71tPsJjejvdTwmgRFgd6WI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB0A443899;
	Tue,  2 Jun 2026 17:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752A71F00893;
	Tue,  2 Jun 2026 17:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780419984;
	bh=LZ5K9M91kQ+AkSUeti/+IQh4gtRy8jNlzNE635XCeGU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XeASP5J0XDs1YevH+fi0aOVQ1MIU/R7ReCO3KBfrw0EjKQoWcSCuUTe+TFZd2QYJY
	 GKn83c51+jpr5JLmvuXOmhxB2hOaB2EBU8lwH3RGLhERAO95WuVtvYA9WQiOd1312v
	 B35AdenzRdSgQJxcy0NmgOeepVriM/v1PA8+h02Q=
Date: Tue, 2 Jun 2026 10:06:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Alistair Popple
 <apopple@nvidia.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 kevin.brodsky@arm.com
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
Message-Id: <20260602100624.b458286887fe9a7c44d3bf22@linux-foundation.org>
In-Reply-To: <ah7WsY02cNAN1LCS@willie-the-truck>
References: <20260521032730.2104017-1-apopple@nvidia.com>
	<20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
	<ahACfQ6kCfONqz5h@arm.com>
	<20260601212225.11f277a85d5ed15083b08cc2@linux-foundation.org>
	<ah7WsY02cNAN1LCS@willie-the-truck>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B7EC61C000E
X-Rspam-User: 
X-Stat-Signature: ztsmyor8hd7s16xb5xytdmpca4fy74wk
X-Rspamd-Server: rspam09
X-HE-Tag: 1780419985-857949
X-HE-Meta: U2FsdGVkX18+XjgCsWgDEENevQcEs9uZ6WBqonZv3zeGpIR65TJpKgbKx2AocVsNisLW4iJJl/4v/wRbZeEwEvOUcET4dfuV9475JDPi6B65HRPvKXWHz10ZMTz11yh/YWtp6GbTVFZj9Lm/yknzoqaj6GekX4jalS8OlIlAuIojxhq0lQgkiMrR+Z17rMgQv2OMTP6vC8GQ0bQZv3WAnlIdxLZtTEB3j9n+8YmbrlDIkKAy5qk3N/vzsqQPZ+6TrpLWUbktX8L8gwGW9m17T3/IvTTTKag/sijeyJ8QCeD/IQ+FWeWrSHU19Q170f0+KzBlfoY4NNzldyVXE4TJWI2dK9Cz1Y+5m7oZ2xwmGz7rw4VPrmjhEPFain77N/meViiu0C+92PXKN08hJzFkVV4ixa6NSooUekwcceMu2HkQducxGtFHjapmaHVaEoEjHcfheEV/rJm8tE6PwP3V+ZuoHkZBwjtWzek0unOoHAN9BHMdaQUZ05z3drLLzq4rJPTkjGxyMVV2eTMgMuq8tljRcCCpI1rfyeB+h0uzBtyi0UPTAJOzHEQodExFrrLUbXnhfOOLMaZJk48lZwBIqTApOzhBMFc66GVPkL615nH8ouURD6+FCWpbBmKMEP1u4z4UazTfsvsbKJ5bKGtE8oxjnVEmeHk8vo9mUsiXFEpx2cCuixGp7ZwZbGqcdZH2117GI3SOJc29ZOfMIqzZ9kPOVImMD+kf4D/C//K7mX0KU3AJ/3VWCBtL0EjeGc/daf2HgAGRKDWFNJCQg38hj2ABeLh+68LozdxLaXDopOg0u3oyu8vi/oCh3Q7CMGaIT5ttniKJH7O4WbWx/Uk2Bq4PRykASz+V/Fc9e2aYOrDFJJNTtgo2l2yKxqUU5c5XDsToitwXL/0zc90jBTZtyIUzObNWdnpF6YWe9BjSekjKSmusqYdIe0ud0MGsVAD5jKo/iH33kNG89Ag8BqB
 UbC8Re5r
 g85SEVb4iaP7fol52hfpLAt5EZNViOgYDGfPaMswhROciP5m5BAEDuK8AFAvkhwV1fy/SuuUiM8nrX4GUpTXVUr8sOZF/vdBCbbCNeIQMF9c+U+JW3/WSfSex7NbbBAmMt/33qvR+WpBI1uO2gsSgvqC2oaGzmwJWkBXBiZcbcFrT/Rjitt49MGM+7lriQ7kVZ1GwSuBL+CnvhG0XJFEX9YA9g28cGB5k86Q3IQ/wmgrBWdsiwHQQxwv6BuRz0C0GmoevAhM04/PSGFVshlqhRObCPZBXHfGpk+y1erHmeYsskJw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Jun 2026 14:12:17 +0100 Will Deacon <will@kernel.org> wrote:

> > This patch is still floating around in mm.git awaiting some
> > finalization.  What to do?
> 
> >From what I can tell (assuming I've been following along correctly!):
> 
> 1. This patch improves the situation, so makes sense in its own right
> 2. There is additional work to be more consistent with the constructors
>    for page-table pages, which Kevin is going to look at but is probably
>    a little more long-term.
> 3. I'm happy to take this via arm64 but also have no issues with you taking
>    it via mm (so please shout if you want me to pick it up).

OK, thanks, no probs, just checking.  I'll include this in the next
hotfixes batch for Linus.


