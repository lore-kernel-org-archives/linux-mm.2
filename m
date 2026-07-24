Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B434C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943626B0088; Fri, 24 Jul 2026 06:29:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3B76B008A; Fri, 24 Jul 2026 06:29:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5FA6B00AF; Fri, 24 Jul 2026 06:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57A256B0088
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:29:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB186C0360
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:29:48 +0000 (UTC)
X-FDA: 85023299256.19.A0558C0
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1536E100004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:29:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JsITWa66;
	spf=pass (imf05.hostedemail.com: domain of mahad.ibrahim.dev@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mahad.ibrahim.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ljpgHhdLekhht1ZGLPz0kXgl8PWBaG+hNTc2Nu++YU=;
	b=22tGDYY8yWxys05KKKpgjnpfzx/rUwtELmWucoEF6UPleWJ1Zmut2+nAn0ZscSXBJZe6h2
	/10IA2NE73Hd8xAMnRrgbGljWf4+Qw1Nz5oF2IJFJJBv06NZsMN6dmTEM58S4YcGZNZ9ZF
	Zmwv4SHHuHp2xkYs3ih6KwfimlYfV0g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888987;
	b=fVfbIsB04S2QeriYn4mxNFlRp2fd0zA+jtHuHeFemf0fcQNe1PsY4nXUUKFHt/Y3Th/8eD
	EeJ+TteBKuPqysX/B34dwQH+BOh+9LUL6NJAkxEwYzYXuH+y/rgWGzrQSFJpQ7i2O/Losy
	GAzUqxmovhFYb6AU0Z4hYriqHN9B/Gk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JsITWa66;
	spf=pass (imf05.hostedemail.com: domain of mahad.ibrahim.dev@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mahad.ibrahim.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493b966dd74so2061195e9.3
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784888985; x=1785493785; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9ljpgHhdLekhht1ZGLPz0kXgl8PWBaG+hNTc2Nu++YU=;
        b=JsITWa66ag56hXOEtBn/ZlpJjX4qFeQMkFVsZF7A2k7Q5SFTsQ0uIEnTVZaZ9CLxSC
         zymT4+22sa9PdGshlwUiiCTbTa81JGw1+JfN1uebxmf0xBZn6pLPeMhpJBExUhDha+Eg
         HZR7/od0JTtiRF2w26yIGVOKsxw4vJdwA9YfijqaT0VNGz7IkHh67RF8LVbnrSKcPb7i
         tyIOItH1vWl0DYgxAmRs6v7toBejXlSpHTWcAWKPkO6NEcsNfhTQTzrNEjJaf/08Nc8V
         OL89vECXxhizVPLCWzmVEOzyXc8U9eHn0px6Dn/FJ0INGiovdCfxuskpn+4rFTUCzfI+
         hRDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784888985; x=1785493785;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9ljpgHhdLekhht1ZGLPz0kXgl8PWBaG+hNTc2Nu++YU=;
        b=bsST7ZADYvYvZ4Leksj2XSivArnUGXMBFR7VRoPeS59uNW76UPeQld0Ii7+Hvzj6+3
         6dFxFqiihSj5c6i7Wtej/LUR4KbCrIqd7rLOe+S4J46Y2ex19hs5bI2mJ4MxWMxH73WV
         wEJzLP1C/crQ1C98XGoC5qX+SKp7l4RX/NOkg1wBLGkv1mjAdDM10BoIeBJjMG5iHAfe
         QH9Zmr1YkKzLPMYvsccLsYAjZ9K1nDPIjeOin7WCYFiC4ygdDylfL8Dat7oU8Si84El2
         yG0Gbn0nYfQsSrcHyjwbnkLHKl5D966AY4w2Ih7ZfrUh6OoKg0QkOhGfYdkFkogybNvQ
         oVYg==
X-Forwarded-Encrypted: i=1; AHgh+Rop3g+dU2u56OdBne3XjHSFNHAljBYxQMrUVR+p2tGquaq1/pPZ+RTMyNbEQgdDar85NPKbc7rn8g==@kvack.org
X-Gm-Message-State: AOJu0YxTnYkUEsZiEvgmO0RqZ9/7e8PVREaIw3XMhkwa6udfBZYaWBhH
	jnDPPYNj5INJa7wJqu/simUU56JlYjQt0yaudgJkui2n4LXSh/AYsieU
X-Gm-Gg: AR+sD11XmOGaHstUPz2djGMDiMBeeVogDuwn7yyNuDmT/4X4Iz5MKv0Yx8j4+kyB8x1
	qEX0qyLwAN2X4b+NM+Dn9GJPceyHSqJDUzL7hXNmDqWaIOlyU6EBWaza3B+9MHDSeHSnDTTRlnY
	hptW/P0g13VJMErE+0MSog0qcHD4d20zkA5R2T/NbS5MUJo9xI11UNFRll7N9Auih2tTcIm2d3X
	dRQZqZuHma6kGUoNOVVlEErmi4RHYyczfU6DirLDGWwpiIE2IHCl+bAj4HUtya3r4QACQ989pvw
	jPAOTsx33wBsVS7DLZaMUgk2ZzgYWD2WRzXo9aeRUJ1V+PAp4N+jhViNaWmm4Wp/JXjntsvhOi0
	Bz+uHdZt8JU6esB056sGbRJCyvu3BLh/GRaq/MuA6eqa/L9rtjOCxbxRDlTEgHT86a4S+6vrAz8
	bH1KU2HHuU
X-Received: by 2002:a05:600c:5706:b0:495:7287:293f with SMTP id 5b1f17b1804b1-49573d26dd5mr57558265e9.35.1784888985421;
        Fri, 24 Jul 2026 03:29:45 -0700 (PDT)
Received: from localhost ([72.255.58.127])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957afac44bsm68368515e9.9.2026.07.24.03.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 03:29:44 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 24 Jul 2026 10:29:40 +0000
Message-Id: <DK6QC5V98I8T.1YC6J6RN8XK5X@gmail.com>
Subject: Re: [PATCH] lkdtm: use kmalloc() instead of __get_free_page
From: "Mahad Ibrahim" <mahad.ibrahim.dev@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>, "David Laight"
 <david.laight.linux@gmail.com>, "Mahad Ibrahim"
 <mahad.ibrahim.dev@gmail.com>
Cc: "Kees Cook" <kees@kernel.org>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Mike Rapoport" <rppt@kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
 <20260723094522.535b284c@pumpkin>
 <e9bb1f61-03ce-4f37-b3c0-cb87f11b8f72@app.fastmail.com>
In-Reply-To: <e9bb1f61-03ce-4f37-b3c0-cb87f11b8f72@app.fastmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1536E100004
X-Stat-Signature: jxo9hembsucgxhoj44zfzrnitxhe616d
X-Rspam-User: 
X-HE-Tag: 1784888986-631812
X-HE-Meta: U2FsdGVkX18ssYNHYpLxZTBpdHCTUF2lkkSaFB8xg52Tb0gzs3pOVFqOcUWIvOxlgBmnFIpFbUxYumS/oqa8DLyD9+I2B+iZHxf/rqgWpPTF5aRB0rNLieJ2VwZV6bKY9v0PJqHbMxCHUw8RNqy3pRgUQgp2DBEFM+pW75tVT7hxn5juOW78wPNSB4PnyNX//DI5QpM3o9BH4h+eno7u4F82SeO0OYgDT5Toz/uwhMF5lHZCOtpSCTuP4qtaxCFYmrNZblj4GGnqKdke14m0gOhbylJT/aJnsz6wg2kKq5rim+FcoIpSakd9xN/61QVsakOPwac70+14dP5IXFYUAz7aGgsJbVwhnFjRmeMo1Bk98we9irc/Og/YxavIcMKqh6wD6iwcqcQAPqcVTuMxr4zpLGsM6e9kSsgQRRjxab8O7Cw5uQT56UD9SW+LLpxMTHjkbKEA7sWs4D9CheDI2NrAJKZ0hMbZrYC0l49laEDJyxAW+ff/g2DwxNt53mwtCjpRXcGKVaA6gBJpZFYdHkodslDhQHurJmGQ3yAxMGpw8pumF9BzvmtmF3jMWnrmzLiPePserB5O0lqof9VB9BTzGizcSFT3GdExFbIdyScrQfL86VckEDt4MDnzm6riuNPGCR8viJjvJVdcynFQWnxlUCtIkXq+JBDaUAIvuoP7zhxNGbq9P+ZW2YcVuBCjLAOBbjAVyIy25ON27HCSAwmguXtiiI1ehTORo6GgudyFm/Fr5fHz0lDW0o01TFf131dx3M0c8AFxYYZ/gzF/2eFvHGaS41c3ZfPhvpMigjYxhX3kHPWTVAfojnMv9ncGODXQL2QQPosFvKMdEr1KUSSZQHT7XggLTVRbNkt5foNjGLxkoax79blIOW1nbbGr5EMuvTHsio6ri4VEUA/iynBskdTVzFBtejVTFyI8kWs/BkNCsFmFcNwgR4hnVl075Qofe7kVxygSiE3W5Bw
 xsxhjNeb
 eCMwd4mgSssjyiGO5XuO9FU0whTm5o5xFw+Oe1RyriYkRWCUiLxa+5kSCWWyLQdKIDi1VfUR1uBCKPKzYaSAGB1tT8iqOizHJJH0JpKxMkMzUlnS6YxjexQdhZh0K566Ll51tXSeylcnkaP5R8/CrO+WG+WC9Hzcalue50KniB+KYK2SfRAUP4huqrt/D/scCLVOqpBTuCIyjA1UH8eFL39rIXTlFy3HmQCSz/ozC+kjJosIn8BxnLC2oRKx9hgUO2mASVr/ch6wV4vIoMZ5cgxuMUErg8/dFuH9glS1uMLGa/8iBhztHGHzDk0f/qB142I5brLBQsFF2d89TEwHWKRKrKTuCzMzotiSVjIXa5TjwHXzbm5n1/STjRmCDTeg7iCKDnFptBlYDlz5W7z+Np3Qrx3Z/tFw3/1ZOxb/o1JXrxXJ0AaHL47fcPA3WIRCgAqW21y7ZW+fGtIAD9ZBpa1OHC0+NYy1qLm25kv3jqD3wzAPiTg9H8qj39uR5IpMXATbnGO8/WYUiOLq8e1kZszfkeoz2pXY1oMxi+p36i4FokSg6eTCyJrBwSwk3/TxQ44ZPE3QAKOmXCVoHN8+FkiLviA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Arnd,

Thank you for the feedback and review.

Your suggestion would replace the write paths; if Kees would prefer, I can
send it as a v2, if not I can do it as a follow up patch.

Thank you,
Mahad Ibrahim

