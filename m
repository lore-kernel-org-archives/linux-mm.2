Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DFE0C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 16:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8744B6B0005; Mon, 12 Jan 2026 11:22:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834F46B0088; Mon, 12 Jan 2026 11:22:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761A76B0089; Mon, 12 Jan 2026 11:22:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69C5C6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:22:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A8661ADF94
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:22:55 +0000 (UTC)
X-FDA: 84323830710.13.FF0BCC6
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	by imf09.hostedemail.com (Postfix) with ESMTP id 116EB14000E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:22:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b=lkO8Z4YM;
	spf=pass (imf09.hostedemail.com: domain of ben.dooks@codethink.co.uk designates 188.40.203.114 as permitted sender) smtp.mailfrom=ben.dooks@codethink.co.uk;
	dmarc=pass (policy=reject) header.from=codethink.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768234973; a=rsa-sha256;
	cv=none;
	b=sTNgBYB8WDGp+uAw37HwObc0rYWTrbL868XAhyqk3/y7zpoihX8sYm0pSdUEDYVE2atrdM
	2WceT/rVZoQKliWPxPC4fk9jXSDbA/znDhoY9T9gvboQ1VN8yRwAhtGVeHgbcJ6HaSAzpH
	fh3UmaWOjFgc+BsD7qPISJ/wtHnWCII=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b=lkO8Z4YM;
	spf=pass (imf09.hostedemail.com: domain of ben.dooks@codethink.co.uk designates 188.40.203.114 as permitted sender) smtp.mailfrom=ben.dooks@codethink.co.uk;
	dmarc=pass (policy=reject) header.from=codethink.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768234973;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4ecvw/VgB9jzPx76+1w7EVY3QrE4ygM62Gv0kMz3zY=;
	b=kHxFdIA6xE1eYrYD8/Q3PW0PQq3HlZFRRn3zdD7KoZrLsutCbiAPXIngcLG/XO1Jig5bnK
	S6EpyJfkZRg6N/FyBx6TtLDm8gGjLLOahFXGUyXFIl7YwmsIwHmvArC2Rs86gbrPCWlIY9
	340jzqq8VkjiS01hwe49Ga89ZzyU0yI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap4-20230908; h=Sender:Content-Transfer-Encoding:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Reply-To; bh=D4ecvw/VgB9jzPx76+1w7EVY3QrE4ygM62Gv0kMz3zY=; b=lkO8Z4YMNpUZOsi/
	2D2Ik1BSAfdFlTUZQ+V4vtON1WxenKwSkjoNpvbkKNzWmi+opp/m+alwUe6ylBHyCK/HpH6Olh4ud
	VoyW+HWmof7d6qcu8XYVF9xHTI21QCpzmsZQEKr8H0lOJZCT5bv3CiHNbUbFPapogar5FyeBvWHt1
	szDP3WW7HttPhXw4+gG7WsG0aqQWLL7XdIqRFOBtyF1kViNqNqeqylMnyXOzCUiCshN0jGLmxg+uX
	3+6xDTUILwE4Ukmyr9qlao428xVWVwVax4mVsx0zOLsBtwrXfk+0A5TY5D6kw2pUR+4+E+Hccd7Ua
	9Ga5ksDOGljYQ4Afow==;
Received: from [167.98.27.226] (helo=[10.35.6.194])
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1vfKgr-00FSIo-66; Mon, 12 Jan 2026 16:22:49 +0000
Message-ID: <935f653b-46b5-48ab-b7b8-8f26f6377812@codethink.co.uk>
Date: Mon, 12 Jan 2026 16:22:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: make khugepaged_collapse_control static
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com
References: <20260112161820.604669-1-ben.dooks@codethink.co.uk>
Content-Language: en-GB
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
In-Reply-To: <20260112161820.604669-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 116EB14000E
X-Stat-Signature: gw4usog8zmajtqx7x4x64k5nsiipqz3g
X-Rspam-User: 
X-HE-Tag: 1768234972-841485
X-HE-Meta: U2FsdGVkX18i1SF6aMBNaz/Fq09SsSmPnlntXs8glhrUw928LvGlbECwbUq4umRqiZhPkTej/Q19WVAeIUgGluX366yx0CzytHRXSBoKSByrE6dsuq4/TPOExCFffokByGBWIeDyTFnLz69NGA4QbaRId3tptUvVghTiSiDOkguRDZRnU8/YlINu7JFnm6Hog7G40wyqGl8TjWpjjrq+FWoXQdQqvAAra5tV3i8cf9jpsfY+r4nodavRULGBb/ADvj/p8wIP2kvHewZJVYUb8mx50fZBMnz0QOKzvC79/mqj1EBHxMNeUvAUMvkOJ+snRHIGxvzWyxBlONc1CyK3TGIbvnyTfiW3tdg35p2m3R9UleVrMiTcojLbvj2paF9rDj0n2SGdRT32x7i4fsZeFqQbMp6k5GnEQe7F2FJhLnkRg/BuD/qFdmf52ZIv6CDjUFGRfqC9wOp58AJFX+RtdGldHGZ1MtvKu2NAVjHeTpjhmnPnWiZFOROPBDvGQUA36b7uuvheS7rAifa/XXgVOhQyV0kVvd895Mis+t9RPycv5hIXkNYhZ7NQTdBd8SuF9QPXTtmNAG8HMumFET1Xi+Myo3v6yybJxEBDCBKoHs48q/WtdxB2scM7xbUBx7lTbQdkn14sjX5MTw0rUxWajHkwrn3IsVmQJnCsOljDIa868ByOtCNGdN1zD8FsrUa7NnNsl4nPnwqBgXQ8jku49qGRDYx9JtAANscpv6QaHgsnQaooHJ47o2TH+5r2PxPFbyNRmap/oBEEamDaKsbDgm19PQZmK+WIG99O1r02e9ULUOoZtYgHgAhH7ms0tpSMVfTlfdnDz4EZ1GESHsyu24pLsbaW23hB2UQPmRYt+UUaz98zMmP+jKh86HUZ8F4GfukPwW554j8sMvL3i2A190pPfPC68Kyt1UWxWDBTffmnvIC2atyZSaQ2fhjWfFZwhFwggFBw9N7ItsWBOxu
 yYqZCic6
 BawaWxdCzHkv5TxofFz1IWEXlHFKLcInLw3hq2Kfgs5yFbLofJiYcD9YN3HKyM0gPRm3KBD8RVlbEBVfWqf7dmhLOhHF4/gIJRS0u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/01/2026 16:18, Ben Dooks wrote:
> Make khugepaged_collapse_control as it is not exported.
> Fixes the following sparse warning:
> 
> mm/khugepaged.c:829:25: warning: symbol 'khugepaged_collapse_control' was not declared. Should it be static?
> 
> Fixes: 34d6b470ab9cf ("mm/khugepaged: add struct collapse_control")
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

Apologies, sent the same patch twice.


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html

