Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF5D1C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3616B008C; Wed, 22 Jul 2026 23:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4876B0092; Wed, 22 Jul 2026 23:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABB556B0093; Wed, 22 Jul 2026 23:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE686B008C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:47:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09412A03B9
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:47:04 +0000 (UTC)
X-FDA: 85018655568.09.25F430E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 744CC140004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:47:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nTRYtKiW;
	spf=pass (imf26.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784778422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=053eY0ZCIcJIC8vBRuJvf9GYS0I3AC9NFOjUm6ZOPiU=;
	b=7NOjI8ZVYLyyleNTXYm852NYEkDYKbh4ZNCN0BBc/sW+2uZKv9w0gq+NMx8tjGFsZl7dmX
	PlrsNE7p7GqraTgJGV3OOcYH3X4SNwW8TKfv3fLffUoYpl8CB/xxr1HPdXcbPqZDtUYDep
	6Nxw+DfJXEf9HbcNMs8FuM5a3m3l3B4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nTRYtKiW;
	spf=pass (imf26.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784778422;
	b=5+Wu4/WKd1VHT9EgTG2NBPYOiDHqTK6W+D5KP9DAwu6q56RSquy0WAVEaMx3hp3GHmgZvW
	8fnZux9FmWdjr4nwUeISmS0ZkGtWXKA0LC+e01aCz3YFYGe/8HR0ZHRa+Uzy7pQWHmFlrv
	Gy1FVXNwC5kIgT4Dji6aNnbMQi81Aeo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFA2443265;
	Thu, 23 Jul 2026 03:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF911F000E9;
	Thu, 23 Jul 2026 03:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784778421;
	bh=053eY0ZCIcJIC8vBRuJvf9GYS0I3AC9NFOjUm6ZOPiU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nTRYtKiWM+4aHRPfnlovPOxnr4+q0aqHwj0BpC0NDSg/h0XMtB45HxezSUN5B0ZPc
	 8yZ8GWqjtyWK28De/saqN41GPQzDaCiKly7XbnjWJoGE0KqAg8SY6+iQL93Y/uLfvZ
	 cO3EhzuTtSdk98OoDw8ofz0x32SsDUrRTRcg7OsdQQ6nOeIPqcoS3v4ao/Wu/dCtlj
	 fGe6D9rPAVB0mQJBZ3LMjMgfM//xucVn+MJ/PDOzqCgWO3+vBZecQTTEGPEBm6QvmG
	 1rfnJYhxiJvDQVAymO/a522M0TJvfIIcYGv6HdtjqcKmyx9gXgNscOjjTxO8g2RqMe
	 lL1ZHrY9TngxQ==
Date: Wed, 22 Jul 2026 20:47:01 -0700
From: Kees Cook <kees@kernel.org>
To: Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lkdtm: use kmalloc() instead of __get_free_page
Message-ID: <202607222046.D287828@keescook>
References: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
 <DK5HY1IKXNC5.36QEPX9H8SUHB@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DK5HY1IKXNC5.36QEPX9H8SUHB@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 744CC140004
X-Stat-Signature: js1da5ymwysqk1d5ou1wwwccuku4g6ej
X-HE-Tag: 1784778422-502592
X-HE-Meta: U2FsdGVkX18iAWCAxZTb4trEQXKp5O02ovFCj0M0pLy5UScXbuEnMxA0gtx8k2rl+vkHdLG/oMgRta2eRWkrTX62TAot2Na6FDoIfqB15IPSaq6Mx50bXxKE+yyNzq2WRWDC1t00bcZFYNLqmVqDxB/gGorkX+/DRDZjgXam0FcjgtyIpeHZJNKLYtx+aKgc2O0HkkL6gWK1NMdROImRr5WG1aGIuj+Bfw2Ld6wdwd+8qWNLBiARvYQOhz+ryS/CCcGhgmjXKe41Ix2k0NmFhKbODFWxuva2pLQG5tV5B1BdglFxnRqPGuXiv6VhHFnGlmmukWoQXuDmTQUSFBY1M2G59QBmuYMipk/eIQa2oBUj/DIjr6XrrcmFqbUH0GZ3OFk1AuoFNN7MFPwC0v0GUCRuZPOBc2tqJSxbHUkCpnh7cOLczIkkUZsuI1bzK54O+QwJisi4Ue0AVTgkeMdABMTiqYY5o7fe1qGEpvR4XBJvyAjgWLzoJOC1pjsrN6fReicpNT93JrGVAvxrfoKjtSu8z6c1HcbzaJt733sALQw2uxCGvdXtpSxPnJeeFSe0o1X1zFkOlAiqv4FHuUab0a/MgqudoDUPM3oKT2RD/HyQB5pQlc12AD0yuzbHvOHYPIKOok1GM1Ytk9x1iBUpuaFmzUYCyBpfILGN3xEqLkRDy71lSBS36w1V76GoyU5qjbGnZoivATTRpe775SD3RYPtweP5OgFemHPH7Rffwf2MRSeKLMjqPYDcXGeimhXKhpLlr3FdJuVjfsbX/lMo8RaRusl4Xli/ZdbyMoDpISElaQcj1nSYCFOxPYujmdJ9B9/O4kjl90DHvYo6VuK4hZuWLtJi27ogn953WKoAaRfcLAsXm8ov3ZDswruQWlPtPEo36K/VGhOWRBWgR/MdXQ9Q7qYslBfo+ht4EG1y1F8lwXVihZXy5kBgLzpCbpOiyKdI25unlVgahBekfsm
 PYNxLbSb
 cauFDZ0BLxOYu7e7XrYMLbccvumLx8Yul3cnuy1LMkapABPcdjf0vgwUtK6sO9uJwh2UH1gVbmmpzd1cOY4ouUxgAyes/FO0KPCtF/vsL7jEp2MbNMxXgxcqThWMEsvJcx1iICEpzU5f/0AOLV557fVNFvuNpnAkChp3raW9ToloshuaxZbfkqc6WsKi5WYzIXadzWxqBG/dr2J4vNWx7KnXXzCYv9CtAoDeA+yc2ILMffDH7eJmxk3+PAi2nE8+13dggXy1gTFjtjNTxOg32JTR7sCaTf0IxuWmyYFgYlJVrKs+KiZ+S99edJLhj6+GUxnIY89F3kP6HRUaeqqymFY+b+VFvWophbQXPJ2E6OcDWru15TmYrGKdwD7P+2sDUGznawtx7BTXy1zcCIB2TFUwz5881KwThHA2d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 11:42:25PM +0000, Mahad Ibrahim wrote:
> For context, this is part of the broader __get_free_page() -> kmalloc()
> transition Mike Rapoport is performing. I noticed it on the mailing
> lists and found this site which wasn't covered.
> 
> Some background:
> 
> [1] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/
> [2] https://lore.kernel.org/linux-scsi/20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org/T/#t
> 
> I apologize for this messy reply. I thought I had added the context, but
> I didn't.

Do you want this to land via my tree or via the series Mike is doing?

-- 
Kees Cook

