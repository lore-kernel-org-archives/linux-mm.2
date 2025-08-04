Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41115C87FD3
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 05:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6681F6B007B; Mon,  4 Aug 2025 01:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619236B0088; Mon,  4 Aug 2025 01:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52EDB6B0089; Mon,  4 Aug 2025 01:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43CBE6B007B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 01:12:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8CE531DC929
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:12:42 +0000 (UTC)
X-FDA: 83737904964.10.B7F2E3C
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf09.hostedemail.com (Postfix) with ESMTP id 42521140007
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:12:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=oYmWBoah;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf09.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754284360; a=rsa-sha256;
	cv=none;
	b=KmPlwwa0VfLL7xntSMgNkGFiJHTZKZANg0Cu1ydOo0NfdN1wrEYe+wXRhKg38wlyKRPa1O
	x86tgZp5JBqPu6bgnqVtEkq38VSL9tzp88oCDMxqkNfxATZ50LINiAgkfm+r4i2wfgscdK
	BfSvq0cu8CTxv5505lYPGx1HXF2QUx4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=oYmWBoah;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf09.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754284360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvPkdQkZuTk/oKdUqX7+df3m3jcmeHsaTzG3mAWFvRg=;
	b=MkKnAsnzkEQna8Qrw8i5i0CprhlDGjeyNny3CAL3hORYG3BwaRGMe6IFBchvnYdpfmyE0z
	8W1L6RPD28czlTry2KE22bHLjBDhKuACYP8h+MqMA4HX5i9NSZZKh7szJda6vwkvmRL5Cq
	+itrCNbEsj5eVSJrif7QbuCBMJ0/KR0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EvPkdQkZuTk/oKdUqX7+df3m3jcmeHsaTzG3mAWFvRg=; t=1754284360; x=1754889160; 
	b=oYmWBoahMmMadHzVKtNrB4ZvFrqraBqBraCpLeAg+yRKilQfFw1GblLqhmb3fcrh29+kLzhHoSF
	Ub86g/DIt/JC4Fc28Gvi6Aj4ncPHAmFdISCrrvSce7J2bEsWciaCv3sc/y3BEIM8s9cKi2fKfxj9m
	Z3Uzn/SbDAwHtF4xHaSdndUdiu12e9g2nMGT6feFB3QIvNtuMXctKd28H+WZTFjNiZiVyL0fielnE
	kLBIrpaLz0sU55kelY+80MSzMBEJ09PoXbIKVm5HbbGN3fsAiAhE7sYtcwQWdYPQJgdaMf/18iNfa
	pMIr80DhpkJvMUDygLCBIqAZrfm/pdVnVTQA==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.98)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1uinUx-00000001ST0-03q2; Mon, 04 Aug 2025 07:12:35 +0200
Received: from p57bd96d0.dip0.t-ipconnect.de ([87.189.150.208] helo=[192.168.178.61])
          by inpost2.zedat.fu-berlin.de (Exim 4.98)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1uinUw-000000008us-3HKi; Mon, 04 Aug 2025 07:12:34 +0200
Message-ID: <75cbab0cdab084795422335c0e0d69c6f57b468c.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v4 25/36] sparc64: Implement the new page table range API
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Anthony Yznaga <anthony.yznaga@oracle.com>, "Matthew Wilcox (Oracle)"
	 <willy@infradead.org>, linux-arch@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, "David S. Miller"	
 <davem@davemloft.net>, sparclinux@vger.kernel.org, Andreas Larsson	
 <andreas@gaisler.com>, Rod Schnell <rods@mw-radio.com>, Sam James
 <sam@gentoo.org>
Date: Mon, 04 Aug 2025 07:12:33 +0200
In-Reply-To: <83931f05-a613-4972-be76-80bc695915e4@oracle.com>
References: <20230315051444.3229621-1-willy@infradead.org>
	 <20230315051444.3229621-26-willy@infradead.org>
	 <ce6337237169f179c75fe4a1ba1ce98843577360.camel@physik.fu-berlin.de>
	 <83931f05-a613-4972-be76-80bc695915e4@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.150.208
X-ZEDAT-Hint: PO
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 42521140007
X-Stat-Signature: zhtwdpbrzkygfrw88uuke6799uiguu6d
X-Rspam-User: 
X-HE-Tag: 1754284359-687134
X-HE-Meta: U2FsdGVkX1/udBStzLkOubFyRHLcd+UaMHt1+5UQNHkzdC3XsNgHAWe90JLww7dDOr7mN2H01LSxN4NjBINsB46pbSUpDf66I2/Ctb+iK9BrCg8GymL7qQNUPftNX8bbN748w13xFjmEhffeVe1RovylsID/NDQaEtEwuckKqJS+fQdmjHi/krAygLn9cRo1kjWCh4J4t7IhwGQk9Ej0BoFOn6U2mJUC+hRJ2YZx9RO/i4toOGkk2xCgJsgaNYO6vXV+FvtrRLKk/TUY2rtPLtQ6Y7zRY3u5Qzq5I1mxxXRq0n99vDSZe9MLm9NBe4iW4WJcknqDXEpId7vONq52RpQkN/gh1Jy6wvjoDEmkCCAoA4BeZ0uvfuVOulCmPm8mEqesJwQVYV/CgY3l/Fh0SX5pHWdMtjSmEAf0GFLjLNMkO7t+h4r8n6Icyej2R5xtoqZRkKH1CEAVuQZqpFZ9PVFrU3Q7J5PVN5QSen19NW/pbG9AUkYU0TCKzGtdR80Nq1cpt7g4gDQvUHKRqhaKKH6BrG5iU8dE15Sydqw62ID/AmO7luzN9nDkCgWmnObwiEZD+1uQZRVp1MmIrhsCYNh3wugFJ0z8rKp4LmxaUqQg2L9UuU2baK3qSPv2xICJ7hiM15WL69vpnHSGAi6nz3RurZWQktrCkec8seDGP8fY0ZUuL8iULYFqvXOwWrFQyf64odU0hMZM2BoPFjNVJLXNyrAbMhQoQiTQunh7BfXjWdyo1UxLGFXpAxhWNU/rkhAQ70smfto3VOvUBXtjR619+KdWuiDwy6+GyAo/igiVuhCyuoQ2n4tMDbHjdt8291i3HUBtaetxRBC9DZMyL17PAGq/43JPFAL1JMlxa8E85oHDdEtP3beHJh4QmZ9HKci7zt9FW/Pl+G5atYdSZhM52zdo6+V72JiY2lv0wpjIfC6Cx5OpLvpqrovRcWLqLSTIMAw9aFrMTPNRiYR
 mPhNktLi
 QZA9scv3hJjExnvoQd1NxFt6QMaaX1N3WndR0Q2U43DlF1CtOvoPpnOvU92G6QZElr9UdjxW9qJ4OEmX/ExM64GBGXuMpKgI3Am/VSObKcWRC1zB0TlFH/Khf/NpKMHodjKC7OD/pnE6tdOBeLu5Z4qbI03dPpVrF3eo3ic1RYBzOWR4oXZ5aUOPM6+xTnvwng0KCRrEXSMPvR1rr4JQI/ODaWJKefu4n70cuOyI8MPt3kAJBoewqBlYiVUQgUt8lnGqkbSxDaiJ9vNJ2A7hH8HC0F9Sz+1oxz41VrFlV9orVOkdKWl4Jku7V07bKd1UW31ZQOiOi/fs+6Ub1PNgTDMD7PX1Q5ylSDJ8MDt8sqksGqQQKc44bStxeadp/zRMJTM0OCbTPMaJPHy9MlfMViEmE2WGk6Iwh5Yq3QMNFTjHepPsteVO+qMW8TGEcyfRLSMfUZ9PnDcessyw7lckSud5ZTLfNFps1Mmo4+6RSLcyvESZx3keMQ6aVag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Anthony,

On Sun, 2025-08-03 at 12:08 -0700, Anthony Yznaga wrote:
> There was a follow-on fix that addressed a bug with this patch:
>=20
> f4b4f3ec1a31 sparc64: add missing initialization of folio in tlb_batch_ad=
d()

Indeed I just tried v6.6 which has this patch and added your sun4u fix and =
it
seems to be stable. I was sure I saw problems even with v6.16 though.

Let me run more tests.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

