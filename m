Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C78BC98338
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 19:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EDC16B008A; Sun, 27 Sep 2026 15:58:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69E406B008C; Sun, 27 Sep 2026 15:58:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C966B0092; Sun, 27 Sep 2026 15:58:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34D236B008A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 15:58:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8453880A6F
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 19:58:26 +0000 (UTC)
X-FDA: 85260604212.22.4580C64
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf05.hostedemail.com (Postfix) with ESMTP id 414BF100003
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 19:58:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=VoQOJrfK;
	spf=pass (imf05.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de;
	dmarc=pass (policy=none) header.from=fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790539104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VmUTXC2IsZgXuwZJ1u8D9MwDqxE4b1ifYD3+hAizTzI=;
	b=1jMyVtqWi1kDyWgSU5TcsKvXulDL6XqYx935eWgmC07c1NK8Nd8f/VJ5apPz1Gt4L82xQd
	Sf8MmO2YsEmXdYc0PI/pBqf1FUWM5sX1IMia5px+2UXwI6tmah3bbwtTmtIYJmp1C5ENR/
	uVvJLbRSrRMd9ImiZ+B7vrQ8fNRRNpI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790539104;
	b=zrW10y8qNLas4rm5++I7KmJ6wjqjBcBcJRR38BWkthzip9VpGmQJV5nY6SJ0JjVrdOEPmM
	QrG9zNB/8cFIfJTLwBgLlI0PlTNBcSL6b34TYL6UnM5XPGm6RCQkkppqjeHzSFc/TntVSl
	nIu/jlT6wL7bXb95cz9GkmNNrSBwAC4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=VoQOJrfK;
	spf=pass (imf05.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de;
	dmarc=pass (policy=none) header.from=fu-berlin.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=VmUTXC2IsZgXuwZJ1u8D9MwDqxE4b1ifYD3+hAizTzI=; t=1790539104;
	x=1791143904; b=VoQOJrfKGclnJziKdkejjD2UDUrFt8dLK97DyjLauYI4SWgkkJ3tP15KPYAxc
	nh1aY19W0rnj8vPPXf/Asxrre6+b8fT3Zq0i1s04nASPM8KaEncaQAN7TP51owKKO+SdYnIIHZWBK
	zOy6JyOm4sEUgnN5yntl3xGOvPJT9lm8eyeiGtJTJEMHeT0dTOaChYhVELDlUWGPyW5cvZGLLpG/t
	9i5jjDZr7nVFrA1rGAKFbngBchDqM7Glna24EYL2eeDLpzurhwwC1UvNUPQgN2uqNYtdde9CHO1Zj
	wV8wyNiQNiuQKVMRRfeYbVX4WyIk5cxkvOMQDHq84B8gR/W52Q==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.100)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1xAv0s-000000007mQ-0FSZ; Sun, 27 Sep 2026 21:58:18 +0200
Received: from dynamic-077-183-200-086.77.183.pool.telefonica.de ([77.183.200.86] helo=suse-laptop.fritz.box)
          by inpost2.zedat.fu-berlin.de (Exim 4.100)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1xAv0r-00000002K6W-3UOQ; Sun, 27 Sep 2026 21:58:17 +0200
Message-ID: <416ab0edeb42d71f78ab5481cb54f8ce0995d3c3.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 0/2] sh: mm: fix hugetlb on SH-4
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, 	linux-sh@vger.kernel.org, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador	 <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Andrew Morton	 <akpm@linux-foundation.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Sun, 27 Sep 2026 21:58:17 +0200
In-Reply-To: <arlhcX870kV0DBO2@gmail.com>
References: <20260926183904.76186-1-kmehltretter@gmail.com>
	 <9b75aa51e19f9c0f5c97ac02cfc0948ab5bbf279.camel@physik.fu-berlin.de>
	 <arlhcX870kV0DBO2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 77.183.200.86
X-ZEDAT-Hint: PO
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 414BF100003
X-Stat-Signature: bh34z3u64gr5t5xnpmmooosy9osds1y4
X-Rspam-User: 
X-HE-Tag: 1790539104-672334
X-HE-Meta: U2FsdGVkX1/2Ow0loHXDx33gYhHcl6kb0S/MtGQLbJGj22oqntSgS0WQ8cCHoF35qZMaRqY5P+U26fgt1jPIEWs4V1livOilxgrE3Rw345suX5exebqe4B8UpZuXMsZhORj5gQYIm1nXq4v32oM+FPOSCE3bGiJLRTLxq+GhBWnawshpqeo7CuOdefJze8GFkSilHKw6DjXuaxkbfJ3GOMnU/ljunZx82o3lhZQfTKYy4SKAGk31L242JUg5VDoXbooK3Zae5S6gwyYl2n68Mnp2KUJtzv+0OqiRM0d20cN4O0QrOy6cYjUab+6cMUFqZuwJ7RzKl+HCL7QlJl71jBAy80XhZUFndTH6Bc8uLeYJDkrr5CE4ZkwrkjiIb7rdKVzAnHMxAq8kLJBRgXpHDFoeNrZVeWlplP8q5FV88mA8DCpJ1EQNERlyd0GmSO8EuBJmUo8/f/if9oWuT23g9OOEPa9ziAmIkR3vpKOkPd5mXYe4UjdFjD6VneNTW82WaKbH4soyJKCtyUln4PdnRBQCSys0MfZA5qR9u9Ke/fHgMuvtadbmXcHoh5YOp8BVarQmwfE8REZdgoR3Fr3X3Gb1Aj6MvszvwkFyi8JWpR65mcKC0IUgM5WHF6UxUUPoyYQ0QSvshdmj+2/3AGp9gHvTIYrfXOOSOVoMyKqpH2viYP69TaCN9zYy+B3mrgaJc259Uk/WNXJmTNAny5GKpu99HiYC4T/p85hLcECiX8EJryxrWITIAFV+W449OPPxLWQoyU2GDzuZddgsO9RALZ7d6X8VtHA89U5KJloWMRlK5s0cBk+O1+DjuEiSai2H+dxVb5sKRzWbb+IVEZbGgHhaMMkdQUNayD8bwEr3Z2o5eF4t58rKGfRXM/HHLAefKUFvG67TltNaBrsHe7rHhzAWId53q7HHT/cJ70iw7RlLwF33IRzKy/BOvtI0uXs7MPtPd+d98JHZm1v1w20
 B6kGYeY/
 GDa8g0JVxrHUDmNw/nSs07iZnQfW/nAbOvj4EYSOUCebF1dku47RWw5tYIMs9zde5Mqr4txrhFA19AuSsjiJbB1HuUk7glIMmYTeydiihDKJ1TnQDmK5mWQivsW9GhGSysD0o6y8v2QFeBFgWpIXu/D17MU77mkJibrGS2dK0s34VxTX+UN2OeUGhXYdprPhxjLziKp9CNO7CHcGFk6VAdM25P/GeMbynTCiKqfNg3zcY21zFUL2Sie5p4hXbF2vmYYK7U/jy7lT6jBg1EaBUb9gQcB8MG02zWy2Dr8Pt21dFkaYnYFGcURTENabls+O0ZA0UM8/195mRSMg1ln2ml+6fFPkbBqZ4aYRDuPyOUh7dHMw/duybbT4NrhXIHyZs3PJGj/EUDlyEKQztq4BsXVtbmu6he3a39qgjDQaVQLjTSmtditrMfNidjDPhrVSlCf3bpl5uPVH3tJxcX0KGUX1WLbLBS9UHt+Iz0t6+hdXcDFtyupaj3rTCZ+9SMRg/cnq5DLQKHW+3ExtgBWDWOYBXM9DEIFd0dRB+M6ctXkKbUUALGai4bXY62Z/XBdOIJ4jTRixwGWGmdmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Karl,

On Sun, 2026-09-27 at 20:35 +0200, Karl Mehltretter wrote:
> On Sat, Sep 26, 2026 at 08:43:45PM +0100, John Paul Adrian Glaubitz wrote=
:
> > Thanks for the patch! This should definitely be tested on real hardware
> > and I think it's a good reason to test this on my SH7785LCR which would=
n't
> > boot on anything newer than 6.5.0.
> >=20
>=20
> Testing with real hardware is very cool! Maybe I will get some SH
> hardware myself one day. For now you've motivated me to do a QEMU SuperH
> fork with more features, with a lot of help from my LLM agent:
>=20
> https://github.com/kmehltretter82/qemu-superh

Thanks, appreciate the patches. I'll try to look at these patches tomorrow.

Since I am reviewing them in detail, it can take me a few hours to properly
review them. Usually, I'm also asking Geert to have a look at them as well
since he is a far more experienced kernel developer than I am.

> I will send some bug fix patches based on it soon, hopefully also fixing
> your 6.5 problem. I believe it is an old heap overflow in the SH intc
> code that only started to crash when sh7785lcr_defconfig switched from
> SLAB to SLUB in 6.5.

Great, I'll give that patch a try tomorrow when I'm back home. Would be
great to unbreak my favorite SH board.

Btw, feel free to join us in #linux-sh on Libera IRC and/or on Discord:

https://discord.gg/WhtqXkYys

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

