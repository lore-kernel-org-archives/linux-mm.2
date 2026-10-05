Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A8BCA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 10:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27F506B0088; Mon,  5 Oct 2026 06:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22F886B008C; Mon,  5 Oct 2026 06:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146956B0092; Mon,  5 Oct 2026 06:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFB416B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:58:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8850DC0201
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:58:31 +0000 (UTC)
X-FDA: 85288274022.26.01A4333
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf18.hostedemail.com (Postfix) with ESMTP id B34AA1C0006
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:58:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="OLkmd7 K";
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791197909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MnjNsZvLBxlh06WEotH4Sv0vETbpUxjht0MF5KzNVik=;
	b=ygYH0Su3zio2sE4NHbDbx3EO72QmI2CdI3SiNnnM6e19H4jxjif0x4zcUhy6CV0xSCo0GG
	uobEtoNFx1tBkdkD6HeTUtIKjUPd9o/psMJ29M0nBa4Z2Z0JFYIPY4NuNGPlj1YcwZPs0f
	bIO4kQX5BLDp2onRmylSFc0hfOfaPFI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="OLkmd7 K";
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791197909;
	b=eM9XvF2RBDHcdo7vs6LSPAcXXX82Q2JmkSVNOYhxoWAFDtP9R3jyU7fp9aSMHuo4tLyh74
	7PVouwhxhHc3pw6NTq1QD1IiLWPDtkFfYtOIO8LQHlkeveTwsvUVYN84Kk8iUd+oR3KK8Q
	V2Jn3o6xctH9BhLZcQomTGgLzen2go8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=MnjNsZvLBxlh06WEotH4Sv0vETbpUxjht0MF5KzNVik=; b=OLkmd7
	K991WN4E1A3Yoki6X/aL+GxIm7cGVR9lvUjfl9DyfmB//E/pNrVsdP/ojFz4kdzToWpV8NWfu5AZc
	VBoYv4nlMeb6pcRv/4CAyyUBEFuIynVu+LZb2bJg0TAG+K3D2+vInIw1mrMBjppQWQZFcB5gE7Vm1
	zLYXaQ59k0QYtIlIQuaPQQ7iEZHltLga4jfLg9sDhKZo3Unojbt/f5haCAM2KBW8HDrbvib8IwNzw
	O6MUTGOWXoEiPNOCFyDQqROJI5v1nXuBZ9uHYhTc2Rb54MO07fGFhxrz2oT8jUFTOoMO/2EBuXW/G
	TKVtdnYb4O5pzOd9zrS2aGVl8HVg==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xDgOc-00000006ENN-1cWN;
	Mon, 05 Oct 2026 10:58:14 +0000
Message-ID: <6047f10bc230a7d34628c0021373e407279bf3dd.camel@surriel.com>
Subject: Re: hunting memory corruption bug in 6.18.x
From: Rik van Riel <riel@surriel.com>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, "Lorenzo Stoakes (ARM)"
	 <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, 	david@kernel.org, Mike Rapoport
 <rppt@kernel.org>, Dave Hansen	 <dave.hansen@linux.intel.com>, Pedro
 Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
 luizcap@redhat.com, pbonzini@redhat.com
Date: Mon, 05 Oct 2026 06:58:13 -0400
In-Reply-To: <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz> <arZHp8hjYFXE8Rkt@gremlin>
	 <arde/t0zQNEkWqi5@pcnci.linuxbox.cz> <areOeRwZOez0eHm7@gremlin>
	 <arotyz5g6LozSjb1@pcnci.linuxbox.cz> <arwNebjYXyGqrp32@pcnci.linuxbox.cz>
	 <arzRBv9ceJsxJppI@gremlin> <ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
	 <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B34AA1C0006
X-Stat-Signature: h894nqr311rh11axmkg35s17iuiorb3r
X-HE-Tag: 1791197909-451093
X-HE-Meta: U2FsdGVkX19tUEKUezG/atj3qzzFuMjARmgRb/2egqBQa+tmrRNnZPdFowLIAku8DmJNaMoxw8pqa+o9GpJBwz/yhqGlMEFGbKb9HMeJx/FyHjAFWbwzOD9Hfxcu9tmcP6woT9Jze8+YvDjfvU0G7ujshHfhFJgov40sI++1d44dQl7TCLH/crahcIhdxl3SrrKmBUF4kzE788tpfr1r6n4lGiSun3mYrMMcpqk+dPr2U//eAdSskjmaOZmU+UIIZCcjNYsg7BCQ/Nb7I7jUS+Xspcr5pt8u+dTlQr9Ar1jr16HfoZrs5kZpixo86Ic73c3NA3fvsH+V0euH3q5XXvXkrp8/ZxnJUiHFWQtDlHmZyhI/FPC77M0hgit2jyuEdCsv4hQBVqQL94tikq8/a/ujPbjwhLZ/qwjNtlFa2Cx/Z3tq5ekjJmJpYddSbbmtaZhR8JgPU3VnkbvVIG3EkJeD+mIDBvIH5iN0gFIcnO8gBCxQq4k1d//FAM3kqNFyxjUXIj1AN4/+iyahF9BpoGcuLkxHytGY1Wxyny+XLuvpEu0hOIbZ9+0LpmWbdHsEqD4/gxu46t3UFdgXxs2h8aXW+MVISOtWny5RfIMrFOgGjKQwo4i+wQxR6RUTQlwrKsCkU6g6+kR1ObKNZbE/XsT4VTZBaOUXcUgra4XDhZuFWLITz+5JA7BGwRerEX0dZzUIxOKZKEVoWkVNmbbzIj5cFByOYZ01B0M8cikZOlcs+Qr4hJK7WXafa+7TgwzBV7E1V/UXiESqGHuJUA84km+so02ebmdtUOBI5tYpWdz42z+1TB3++wk4+DG4CsNLB2f3WCJF+u/5htEMBEsXMOUz0MftzVOS3cNQiCG83i6uinv50lngNp3uffU3Rx7JZp2vGTTVKDIjfFNtKC1RcfriBWiUbT54pZJv/pJUhrBYDp99LMss13QBckA4mvsIHXxZ4AyoinYcVEby/VL
 bUWb9+MK
 AL/FQpLaeAH6QVudQos8BfGUifpHjKalO/YM+zYEY7AmPbYK5ujGt8fe2gFYK1RWSVy9dxJhUyVcXB3Mhtrm7BCmyfdZr9KZk7YQgbBLnBS9I+7N0XMR0H2sGPbZBSdeBpWx/J7bSgHNJLcqUJzjnBzgxL5Qyd0I5vvC59GE7MNbMZygJUYr1j4WeJsYs94bpcPV6Rpm+78apzVf9pqNTBjnAjOiTSOyvbZ97RZE/jPzgf+YgzaKBi1gmDgu91DDW+mMMrPQrLcqnxQ2jzE8upZpbHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-10-01 at 21:40 +0200, Nikola Ciprich wrote:
>=20
> Oops:
> general protection fault, probably for non-canonical address
> 0xfffffff0c930038
> RIP: __d_lookup+0x4a/0xc0
> Comm: systemd PID: 1274600 CPU: 23
> Call trace:
> __d_lookup
> lookup_fast
> walk_component
> link_path_walk
> path_openat

That is the exact same memory address as the
crash in your original report.

Do you capture any crashes with other memory
addresses, or do they always crash with this
same address?

If it's always the same address, we may not
be looking at random corruption at all, but
instead at some bug that results in the same
bad address every time.

That might narrow the problem space a little.

--=20
All Rights Reversed.

