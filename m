Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C522F8A171
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 12:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8D26B0005; Thu, 16 Apr 2026 08:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5898D6B0089; Thu, 16 Apr 2026 08:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49FD76B008A; Thu, 16 Apr 2026 08:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6176B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:49:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA50AC2B56
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:49:33 +0000 (UTC)
X-FDA: 84664400226.04.6B880F8
Received: from mx.fmap.me (fmap.me [51.75.121.85])
	by imf05.hostedemail.com (Postfix) with ESMTP id 38B6B100002
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:49:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=fmap.me header.s=mail header.b="G1C0y/8M";
	dmarc=pass (policy=reject) header.from=fmap.me;
	spf=pass (imf05.hostedemail.com: domain of ab@fmap.me designates 51.75.121.85 as permitted sender) smtp.mailfrom=ab@fmap.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776343772; a=rsa-sha256;
	cv=none;
	b=ZUH/rnPr8rdJnuwR4X7y7hGsAbZl5YnNqSWWDxAwpNyBb2w1uDAEOYnjVw93MUkFJW0QjF
	1ToSin2qqCBIx/sjhHg7Ki8mv1ZRhWiFTqJzMoJgEiuWooqqdYpu347QMZrPI463m83vZN
	rPFBuAya1kOT0DmnBoEe0VdofTC5z9c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=fmap.me header.s=mail header.b="G1C0y/8M";
	dmarc=pass (policy=reject) header.from=fmap.me;
	spf=pass (imf05.hostedemail.com: domain of ab@fmap.me designates 51.75.121.85 as permitted sender) smtp.mailfrom=ab@fmap.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776343772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDRa5CfUbhqNNkRrJRkBwEijvm1dQG+Se0DmjI5DvHw=;
	b=j12lxBRfHnMfdZZza/7Iu/nR3wUF7MQGpdRK/NTrb7THFkxY4Eraq0SqfGQhC7ujUZ8iXm
	KGYSlPick7NZlXeQ1ehDPuxMvEvUguNHXMXNO9OMbCdIrtkEruJEbIlfGd6y8GovF1DeM6
	HEmnHnXr7+F5HE6iWFkg792Jc3Q5T8c=
Message-ID: <ca73a724-2e6c-4474-8301-32e509f553bf@fmap.me>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fmap.me; s=mail;
	t=1776343770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nDRa5CfUbhqNNkRrJRkBwEijvm1dQG+Se0DmjI5DvHw=;
	b=G1C0y/8MVky+yHo8qUSlLtizv+3LTEBROx6KHcit4DTtzxXl0JQX39I5G+Uxk26+WdHTiX
	Sl9e6emH3jgGUM3epLF3zG9+RY0tEyAg4xcziPNpZXtWSu3lL6k35OueAfxppwqKCfUuDb
	TDR0G764/94ORThIQbcR42cNdVr5hwk=
Date: Thu, 16 Apr 2026 19:49:24 +0700
MIME-Version: 1.0
Subject: Re: [fuse-devel] Debugging a stale kernel cache during file growth
To: Miklos Szeredi <miklos@szeredi.hu>, Matthew Wilcox <willy@infradead.org>
Cc: fuse-devel@lists.sourceforge.net,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, fuse-devel@lists.linux.dev,
 linux-mm <linux-mm@kvack.org>
References: <898a4e10-6193-4671-b3b1-7c7bc562a671@fmap.me>
 <CAOQ4uxjoS-PvnZ2poh0bx0C6ocTYwuEpfV0q5md15SjS620OMg@mail.gmail.com>
 <CAJfpegvxF7F+XKFKokSH4eOgCA0V2RNm6B54MS9nr9wG=U66OA@mail.gmail.com>
 <59ab54f6-680e-456e-91f4-0a26889844ef@fmap.me>
Content-Language: en-US
From: Nikolay Amiantov <ab@fmap.me>
In-Reply-To: <59ab54f6-680e-456e-91f4-0a26889844ef@fmap.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 38B6B100002
X-Rspamd-Server: rspam12
X-Stat-Signature: 6jqnxhxr1b9yojifkaop9rouast6i1a3
X-Rspam-User: 
X-HE-Tag: 1776343771-652673
X-HE-Meta: U2FsdGVkX19iNIkgEWZSdvpmCM0RxOZu9RSTi6aEMGUs/ehQ/FciHDkdmSIbdxKQT5c/kk3nfFbUwlGX8L344EbQbbgZ5ihBNH3tHY1P3Phj9AYmOz5f9s0as6NVVLwGfkY1tgDI+RlneJHk3G++fFs6bYKSyK/oAKxsrR11j2gQB04o+aWargM878Ba2jAB0ZkjOeLqvHXFK5IWE3X2UylMNZibEG573iyQ6L9dpdEsIZY4ISXPh+JffPuFHHzurpP4kJgJVkAdZDcelYRrXV/jGvV6xaeiI2nxmsT+qLOfuJszdC0wcbw935rg2anTx8n6ms6BBzV77Udjdr5UAehfuesYnW/EYdsdc1xaBxx/7bB9RNZOGXIyN0V2LJb/m2WPUOzp79IGgrJgGRxXnBHVbdd/gdCCjYV4ZvTWap90uWPHcVvwOb9radmne6RqLwcseJCpQlHD55p1iJ8vKAfAzNCKQ4ljj/M7j2GGuJPdVAxnw+B9YqAcuTArH1vAtUdYDRP2W9UYu1+bXUB3mlBxyB44GPFXxFDOy1kWAA/dcz0Am4YVjOrzlTzvMCu9Kqf2Jzl5/z5fMCAyEUwtINH0ClxKymPgnTykumoghE68N6iDrLOoX81mwVe4iCUiINwI48VkQnCgeCZeGb5if5eh+418G/kUMnVWz3Bk0bgQ1UXC2hSv4dNiDsB411VdxXa5DC/+OEV+eMF7iAsDy8gSPhfi7tVUM3FILGxX2bKDRLbzTBMdv+hKp1Rvs2tjIbmwLDpGtQmkw8RwjijNYtiIOhDK4NA8TvKOZGHWaoH3FZG33impuaRovt/UmYWZ9YDjohg2qophtuPvAixHihdKGQVlr0yQ6UgGciE8WdsKFzKnzt1Wn3caiKC00NXVwpwM0VRIX1l3LLmI03x0BX3zOJ9zia9jSOBHjg0LmJ7PQpn52dVOKcbygyGL0p9FMvPjYm6NJ3IYryXJuCI
 9dVF1zSt
 RzojcvALsy8HJKY5UmIgeemNSFQMdbopVtkcyxd8Fcb/hr2vDlBtOuZpXtP+bsNFKw4rEFbt2u+9fR/iXCKXu3j9frywkYDZxOqxuq5gvWH5eADX/YyhYs92I2Lsfbd8IPO+zjS3wToaiBoxW4KtktR57mbsqG7rxQdVe6Q2aB9bVFS5SZBHMpfZQLs7PYYqgOydYcTIAy9Xop2tv+NpSKnUEguOrz299Z5EioU43qjMdPJizNQobRDS6nSruc0AbjmdZ2CP4uYkm89Z1W/sYWMKtbHhpywCAcb5dkD6HilVDgrSPtwXUUAB/QQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 19:41, Nikolay Amiantov via fuse-devel wrote:
> Finally, if I understand correctly, this also leaves a (much smaller) 
> theoretical race condition in `filemap_read` between checking uptodate 
> and getting the current inode size.
Correction: "would have resulted" in a race condition if we would be 
retrying to get a fresh folio instead of returning an EIO; I have 
assumed that's the case when I tried the patch.

