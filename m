Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7EBFEC1104
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEDA56B0005; Mon, 23 Feb 2026 11:34:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84966B0088; Mon, 23 Feb 2026 11:34:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D576B0089; Mon, 23 Feb 2026 11:34:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0F9F6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:34:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F36C1601CA
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:34:29 +0000 (UTC)
X-FDA: 84476269458.30.0F5B833
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7FE2440002
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:34:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="kwJL8ng/";
	spf=pass (imf11.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771864467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQg2B0MzOxp152VTKRQOSVwnDCQuGkKfSPBos7vbAu4=;
	b=bsS+FTpbhqO/0+44pYGrt+X+vSy5Lm1FFuKb+SWLY1xxD1iLjTT0TcJ4jQQ9o4PpslgBV/
	bLIVtZoSkmSj5MF9DgLW2MaqADhCrY2VbpVc+e1IEebr0kldD/XtArEgGpCNUhvQsCpOPN
	kcQXACKkhUTCWdC9vDA0lsNkoAccbdM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="kwJL8ng/";
	spf=pass (imf11.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771864467; a=rsa-sha256;
	cv=none;
	b=Pwb6WIQ/4ZzEeeGQjv/1w0J36WbI8MzHwkjnYK+p3yAlcLDqf35XLzdXgoeaCkGsKaxu9i
	W2r+daQmqAvJUrLTDb1KCuIg7ithRte/PVOZBeeUObo04olxR6bpWD4mAM19NXQDEeyoX0
	U8MZ9aHB8auqIQow9SFXmZ4Gq0fLBSU=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4806bf39419so41389075e9.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771864466; x=1772469266; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WQg2B0MzOxp152VTKRQOSVwnDCQuGkKfSPBos7vbAu4=;
        b=kwJL8ng/ppprIjvSlfI9h5BsJW00j8djp68vcSLE9XYeCnZYfxl4aOkhiAZYl6HG2h
         /m/Tm6XxWRw4MzRewIZiLYU74okbh7RJoGo9d0SnJbfvRTuON7g1ZP1OpHXdOTQIVf38
         ZT54lvou0RqvOvsIWeLGi5GOXkJANa9wE4Kj4nvXihUm163lj0QA7O+4BkdNz97dEQUA
         sBuUcjh3Jqm4bc29FrVjcYDo0PwmkPDlsBaBhANfsOAQzWL+42Un5QMXUyMtv03+PX6d
         Ayz577qUQYR9Pwc94f1UNIMZEus3VnuUholtF2EhdHmomaPtvHa+nRiBwltcs3DP/ZOD
         UTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771864466; x=1772469266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WQg2B0MzOxp152VTKRQOSVwnDCQuGkKfSPBos7vbAu4=;
        b=SOt6Z47HwEwwVuUQgWPvbBlBU4MJkxqMdSvD3ISFnfPRreD6PSOLunA5oxvBshwkCN
         PQsJT/jVDJagVehn4SFn8cvfqRuPAjlU5q9o65CQspBm3g9G0YR+tCkUSmGdhotdTQGH
         29CzafxkYnT6e9+DGOFZNK3ie9kYEp6wcwr5jTNJey5F45kW9plx/3dfvggHrIYktAmE
         ky/OX3RdRNA1sXHcYCixe6JAGF83W2n2GkFT5UBuIHoXYTaMzd74pqLaUJ2P3xQr5fOZ
         YSOSLuDmojDZmz1sPASawaGkB5FshwP8pnFFYwtzfp+Zn7l6Z8FM5QyjjEAdyptmzOdz
         1hmw==
X-Forwarded-Encrypted: i=1; AJvYcCUmOQhuRB9rHHDad7nISjwbzT64iTIqBPUpZrEAW7jPbCT8rEC8TehuOlM+pGm8gL4W6nggKqwiIQ==@kvack.org
X-Gm-Message-State: AOJu0Yw60gdCxikns+/hFO/P60RWSfgD71vueHfYcZIMw0DxULWD8RgR
	Z43LM7x4PuGlvkHRow8yaSUBXD1+btPLK715e6URftmJHiok+ADcsiFF
X-Gm-Gg: AZuq6aIrx+s9TJwdCmrCO5dk+e3IogtRDzg6G9EA+pNDDQZk4jJzhp0lq3ZlnKzu0zQ
	1MxoFIHFNj26dOGtK/OnSDIxP3jVjDifLrYnm/lFxnVsWXW8U94V6KRPaWaxObOloxsVx2OS8o5
	BrTkQ9gkgOwaANi5BQ39wGeM3XYkWMm40aPfCtcmki/MuBomaomyflDMSjgg+S66OiKQQBrSje8
	qN4UAiCFFZ8O0ItkbUbbe5Agi9ifCfggDClpnJEAmcNNn7yrFP3FDdSrQmP/YIfp8aPBS6k8yEj
	GzPdwryHlYUsRC4Frw2dymyu2aXt+hX4rQPy/IrhnUIsq/CY1bhhoM9ME6BocT5RYvFmKrRZi58
	8NByfI11QAVLShxKZaFuVf1iuQxtEv7mHSpawR5D1m6Dv7byOUPUDrooYgxE+0RIge4igXf5WGn
	WggR+/xFQZz3yjmPaAF7IExqfsa/0lXL1INf4WguZU3hMZ+K2FJjweSb9cG4LFzh5U
X-Received: by 2002:a05:600c:1c29:b0:483:6d9e:e4f5 with SMTP id 5b1f17b1804b1-483a949e5edmr155013945e9.5.1771864465473;
        Mon, 23 Feb 2026 08:34:25 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a316eb08sm301960225e9.0.2026.02.23.08.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 08:34:25 -0800 (PST)
Date: Mon, 23 Feb 2026 16:34:23 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Kiryl Shutsemau
 <kas@kernel.org>, Kalesh Singh <kaleshsingh@google.com>,
 lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, Usama Arif
 <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <20260223163423.61a19e5c@pumpkin>
In-Reply-To: <7b414e68-4d0b-4d2b-a664-bbbdf314c0d3@intel.com>
References: <aZcmlIF4bmG0twkp@thinkstation>
	<915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
	<aZdCl8byz51Q1-v6@thinkstation>
	<17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
	<aZhErt9DZcWI24_v@thinkstation>
	<d7c7ef63-e40c-40c5-8ce5-a4ca411da832@kernel.org>
	<CAC_TJvd=wKKnj=d3phZsAaarXUdUbZDGauxWNWkQtsFV-MTYEg@mail.gmail.com>
	<32ed82dd-62c3-4a5c-8bae-9465afd7e75f@kernel.org>
	<aZw1DlKHaWvgOtm_@thinkstation>
	<06684dc4-3902-4452-824a-ee2064314d24@kernel.org>
	<7b414e68-4d0b-4d2b-a664-bbbdf314c0d3@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7FE2440002
X-Stat-Signature: oee3hm7adnsizzrjkpmzfs8m6rbzkwij
X-HE-Tag: 1771864467-139650
X-HE-Meta: U2FsdGVkX1+995r1/Nmgl8izJeUdVl62VpzE0Ysnku6C6kWCl4r269hibSPB25dLojUkjEhCFskqQJhRcMaysfAhwtZ3K4wClFord4AArAodFKVjyjrTaTyhiLopz6TCe5ByGm2YB6owwFz4FG12NMYyhAs8WrXHx9BDzDJysN7ptWys/UBE0mFLnNdbZ7xILVSO1WIO3GNNvzjXM6Nvqzrh0aKLz0Zfp/or4ZtL19zxshQ3phMXbL8dFqucdVOsM0ohE3A9CwztU3hV/AB1pugzMKJ51T6LGYayQfWaoogLQzI7dIr/I4PziFRnRAO35qABAuRtUcsw8EkZHF1pigHOMN2YPAYPtKBQoqxzjrG8fQJ4ngWofrfOSw/4wYm6AIJa7J5cm8pCPC6O4kToPaRNUczwDlKf38XyaGDmvCj66dxKKiGWr0OUHohMYvoHAJ0NAvwKbCiZIUgPeGboBYbiI6CiT6yVCBMaHyrs4VwCAuj3ydWJlRNVSyH7jog5fsmd/+D9BYYlrwgkhRU/TKFd7mBhR1QRfKdNXpOkdQalcJqlBI6r/ypclY6mQDMoawn+HOvYXNLtDSp9zUZFF15twBPUmQ8dJ2e5oKCM8KYVub3a3Myx3QB/Hc5qC3+xrX4Px/lHDGYHw2tMBLM2f+EnbP5vWPh2kRZAssKBpfTwtyfpvXt6RkciDowlY+sSY8SVUsgZl25t6QgBcflq7JhFzSHh+jJHm+5dqciVJnjfbHBW3gj3j+XnN6gyYRVsglAJbeJbWoY0/PU+qPlk1KVXoGgq2jQPfcanDCkK9vDp/37se6cS89aA9aCT0Mj5qe4nkY38ySgcHqQxjQRsqdCcT8nGhlUx7qchUWUQEDrU6lFBqiz31TvoRfg3Q0QmR/qZU5px7HWcLAuyQWK95pclf5JizgPllSXVxHKgPAp2GwuKqmexWG4Msh2HrAOQEzz0ikPEjimKnT68kTC
 KL5f+4Tl
 vt2He/xX4Rnc7wP9szXXQdZre3o4HtKdlKINB1EKbDsn0WxT1ytfTSWxcC0XO8ctk5U9NKsZ/m8p5CCHw52YW4BU+QIXx4SboZNOrN+AZS/CKwGBISuakH2vHq9G8acueTD1lFv2a2BS5FujiWm4z/3WhpaYeBKA5Tp+KGUGd02H8nWGbhmU75vKxwY+FVcJdbmfln81KMFOUWAlVSc7dXQa2gBcqVFOp9FIFr2FU3D7j4qP7cCvni/cJ+i3KESPTWKl5g83SpAn3zLmYc/gKDVCaXUeuU+pvKCHmLAivPqWg/sIYqHxeU+VQMvMTD/f9DhSpIDkj9UlRgj+0bL1PVhC2NA89glFuaen4PEsFxx6Xr6s9WMVxvJkdTgDzVXczmPZEFv9dF8NXVgVWFF1HT0xHdZxE8S78v67vAcv/ec12YNM6w9d8NPDBVr7r+ypE+tMXihvGjghSq6Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Feb 2026 07:14:39 -0800
Dave Hansen <dave.hansen@intel.com> wrote:

> On 2/23/26 03:27, David Hildenbrand (Arm) wrote:
> ...
> >> BTW, x86-64 SysV ABI allows for 64k page size:
> >>
> >> =C2=A0=C2=A0=C2=A0=C2=A0Systems are permitted to use any power-of-two =
page size between
> >> =C2=A0=C2=A0=C2=A0=C2=A04KB and 64KB, inclusive.
> >>
> >> But it doesn't work in practice. =20
> >=20
> > Even in well controlled environments you would run in a hyperscaler? =20
>=20
> I think what Kirill is trying to say is that "it breaks userspace". ;)

With a 4k physical page what stops you dynamically splitting the 64k a
'struct page' references into 16 4k pages (using an extra dynamically
allocated structure)?
I'm not thinking it would happen that often, but it would solve the
problem of 4k aligned .data and (probably) mmap() of small files.

If the cpu supports TLB coalescing there could easily be a net gain
using 64k pages for most of a program binary.

	David

