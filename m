Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4AF4CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 01:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B5EF8E000C; Tue, 16 Sep 2025 21:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38D7E8E0001; Tue, 16 Sep 2025 21:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255958E000C; Tue, 16 Sep 2025 21:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FD478E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:09:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8BE1B7E8C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:09:05 +0000 (UTC)
X-FDA: 83896958250.21.29A8EBA
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id E2A0D40008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:09:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kOOJsqVf;
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 209.85.219.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758071343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aANTVr5axolQ7BbjwnLuDvhkzbQohdfLxP4+qHFFkZc=;
	b=Hiub6dxV6X248Y4z0IaNGRchYxHjeLAEAQHw2TbdXaAH8x5RTtaFCjlGtVlCQifDr1l1dE
	fjtaIrVA0P8OOCz71y9F0Up3mZRS9cg1JgFdVU3MMwqRO6aRqlBjmxr+1aV1Du2/6qO3rd
	XHuc+XyzekEPxfgOp4FITrrYsKTQmZc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kOOJsqVf;
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 209.85.219.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758071343; a=rsa-sha256;
	cv=none;
	b=SI+eC508EvgacKc5L5J1YJvQPWcOccydi40Q12okTFjOnfQI7Fi2zTCBA7KpHxkdcI/ipX
	gdpwKmsJPi/ce6xZ23Wjl0BTKRSt8JtreWK6/6F1XvKfT4HFr0D0YVvl9UhgRN9ypJor/z
	rn8++G4RlHlHyFeo4XdTcGYMkbYfTkI=
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-ea3f6ac31d7so2367488276.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758071343; x=1758676143; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aANTVr5axolQ7BbjwnLuDvhkzbQohdfLxP4+qHFFkZc=;
        b=kOOJsqVfsOApifv/LXF8E0HNl0Z7iQnOJDihLlHAoUghEmkUpGMZ5AVq8o9wjtvOWB
         lAyhq/pbkk8JUEdwbctGJaX13LSMynaMlqJQvT4GQsFf9B1KezB+MVIdGiArupPlek9n
         2mC8wBOseWGQ6e632KVJ/d9bq97JzVChTS0ZXALqn6/KYfvi/+nSj4aJea3XiS2AvleK
         90w/Bvu37iUqkIHXAjFBCnQxKax5cIWYc3hdBb/zIonyoEtQhDdJS6gkq51DqJ9VTLSt
         iFOdoNswihibqmHZ7WTQRPth2CRP/I6JzA31HbBDs9pgpIkFqHMsXuUyFkkTcyY0HvUv
         S19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758071343; x=1758676143;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aANTVr5axolQ7BbjwnLuDvhkzbQohdfLxP4+qHFFkZc=;
        b=LpR1CihU11+3wnxOOsCYlC6lweEMvFGh/AiQ3d1uVLbpcHqdX/I3brtsf8I2eCGuzc
         BFp2+9iECVuHJnCxooC93O6X81oULqmSKtAMPDPeiT1n5vXZjj4fFzH1nxhqF1jul6OW
         QLO4Kz7XR280NNvyU9muIYjoT6arJBjsdxp4Yc76v303yn/DGVmJ8fcws5aKr1kngLYG
         7r1HkpVsLO02qkiywI+of1hEVA7JrSudkocp7uznaFb+6b5ZW2XOzPW9uUz9ivpqTCK9
         xd54VzC3Wo0qCfkq0WdRrxvurue4h/wB6WRCZ8iNlDshgOzp8KUq9NCxT7vieDKQB1UK
         SB7A==
X-Forwarded-Encrypted: i=1; AJvYcCU1ABMAX/7K0JUF2RqWxoWTj3zo5WNFkRmepjtkV7YcdTisenR0p0yrTDJFkpGZwmzxXCB3aS3GCg==@kvack.org
X-Gm-Message-State: AOJu0YwL0cU7ZiEwqA2TVdofu0qFPrZAK2rzNJQ5Jvd1HIbsu6WsAmVz
	sV1HgfMUUXLs5FCoYY+tSklyQ0HOFn1KUV+8/FX9z3VIsBHZ5JGgU8m++4DYiwIhuQ==
X-Gm-Gg: ASbGnctvUy3AaWMuyvIBvVaqYoUvW1sUBu+oINK4yIHLSMmhlq4RNjODlgs9LWtTEwq
	qqbSBoTS9R0jdEQCDD2r6sdvQGYFtqgRxDAwWjj10n75pvS7GLr4gow+BIYYVnBTCWYDtJoBLTZ
	UMxZ3eItH/g3BljvxQkR8PMTZ4nMwV7PTAEOT7/CcBkEfBh+7vlcFLAZGAS1FtY2RaZmSiXEqCk
	pIrPgYGD8VKbgcqNyfuuhS1nfkvUixBD5g+z1l+faEuT1dOwIXUch7fJxhq4zO4MlGIzm5kSRE3
	straHFMPaQkmYDYVXlgJowjToMEKQnRCbbizG2wgOQLPaJ5/6Q70qJ2W1zk8yrjq1PsDeJBY2bs
	Ae8qsbY4bz/ntJHF0F4XEu2WzlseebvGowvz26szOZvWrwuml5rxmgpq5aFLO2DeR7aW0Az7Wta
	0204NPAAuWoM2ebI/ssSFKDJmH
X-Google-Smtp-Source: AGHT+IFGR6+9Hx1aPuBvMpaobAq/qWl23NruMocVjrvxvIXrOI6tSCiwuhhjzQFtoMNgnRtW9cEMWw==
X-Received: by 2002:a05:690c:dc3:b0:71f:b944:103e with SMTP id 00721157ae682-73892c5726emr2575027b3.47.1758071342433;
        Tue, 16 Sep 2025 18:09:02 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-73266fe1782sm29375867b3.46.2025.09.16.18.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 18:09:01 -0700 (PDT)
Date: Tue, 16 Sep 2025 18:08:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
cc: Paul Moore <paul@paul-moore.com>, Hugh Dickins <hughd@google.com>, 
    James Morris <jmorris@namei.org>, 
    Stephen Smalley <stephen.smalley.work@gmail.com>, 
    Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, 
    Jeff Xu <jeffxu@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
    linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
    selinux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] memfd,selinux: call security_inode_init_security_anon
In-Reply-To: <CA+zpnLe8Z=2qY3rVCyZXyGPOaO2a0V2BVrdMkuwKs789igGCzw@mail.gmail.com>
Message-ID: <b266fe61-7a7a-b13f-a73c-f30f5edc22a3@google.com>
References: <20250826031824.1227551-1-tweek@google.com> <6afc91a9f5caef96b2ca335b6d143670@paul-moore.com> <92255d5e-7e0a-6ca3-3169-114ae7f6247f@google.com> <CAHC9VhQejS05C8AExkh32GidBdzXjauKPP6T_3eSGZDEwfwDuA@mail.gmail.com>
 <CA+zpnLe8Z=2qY3rVCyZXyGPOaO2a0V2BVrdMkuwKs789igGCzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-746452338-1758071341=:25424"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E2A0D40008
X-Stat-Signature: ybws6gc3xzaik9j66ripy46ch9m49rci
X-HE-Tag: 1758071343-930451
X-HE-Meta: U2FsdGVkX19LAdFmHeJ0U9hjT4Sl99bC8KX7njejT7BgELMvGhVAnUBf4CG8vvfmsSiVG3593jzwxyI4YkoGiwbfVPqQP63RL/mUcLA0rU3doZo/QGVLFr+gnVibeWCIfw34jsSe9YO8wHwRzQq5b4cjQGI3/gh49ymAXbMm+57SfA6yTO+6h2UI7TAcoHxzvJ3IP1i/tcDg5XjvGlo1FrgreKPN1wJiJZTQtQu7RRA7VpG7iJ6zn910GecayjphuxLpZTtdK3IGUVfR0wF2jCvam+cnZEFu98/Hz3i9pTpul7N3F37wrIFfBNHpT5/QWQWmsNXosjawJ9HwqA6w3QtMHHrmnG9sexRtyvXs5m/HGfZJdrNgFWFibKhwjNb8WhFDtnxgUx37Fk7bEkftLEQwCawIAvSuDg0aSzDl4gAHg0WdjF923ZCuaITSizfB3y9ujknSf+8XSPLjjrj093fOecmhLOmEfzA1/iLzhAglswPORoXQ782n5grm5sUa2HKj7VStC39FPTzS8TvA2oXhqEltg4L+ZVnsHhrBl+UkF0Ht9vbQumbWkmJwzwy7NxyeMKUD8Maq3NPWvQO7XbNL2esG/OiwXQwLtIAYmWxIUJfF9gi305LhMvJVXhew6Yxke1Kt/cdEM7cRzGmgmE56xNTboY27nZaGrG9g9/P00e2nhmhDUIMxZr/fgtNGuInNLTg/ChSkKTgxOaYM5DjKJ9mfhQAvj2nS3ZxqB8mC351a3bfIiIEY1a3Ay+Tf87rdWvcbBlYYOjrLk/wPhfSUfdbbqjd3RJeoadjq0ZBAStybu/0/I+/5O1VJ5IUushLbj07hEL8RWR39+gigbyZoSVuTUsQryITeGDXJPVuysIkLCmA//9Gy1pSBTF92pUDlzSeNBXglfaEXjqxmrEOErgtURZGgmTJdccTymDDdFsgCEdQR5InPvRy6fCbj0pLtHbaFafCtCHefHlt
 MJzg8C5d
 nBr/F3S9ekUBgj9os4P8PVqZl+bNNPoygHsY0lH2jbN/bB/XuUrbxiVYZedxEAmyb6sumXxIPsfJs9TyA0jRXnRsLecO+tLoSuRk7jjBsVApW2Vvkxk4y0oXk6c89KPon1c8oUrVK9On31PucLjyH8YkuH60ZqWvBTB3hoLRE+1P6hWeua1f6l77sirJ8crNUMuOCZKRiLA7rfF1vooY69n3ig8IX8yeZW6fTP1I+xr+TEXyYPhzzS0S14OA/xdFH9GOZvCdaiE1iqrs6IseKaiRjkeUyB47gSRcfnIauuDVRUBk91bxOmlxUXoi9HxSIAeR48OcIO33ZVqHgNk/vh7pJX4n7FeDW6i6rajD05Dz9ZswN0AGDRJZUJbNojApvKm1o9bfRPU8LQQ4hoe4h/A8maFNdsYKigMSpcnnbTy4vCL64utEMr3lUhZgKyT4a7Fo8U2ailJcnC40yF+p1d4SA7y2O7tl+02AFBVln3YSpjy9WBkFxt94ZwpBFtEmVgRdJ+Slr2nYreGyWjSVXIAWP441A6JP/dTRcolTfGlNEx1z90tnhdUA/+0BTim7dnF9Wvut6fccaA9lPp27Jo7FW6tKw064VIR/k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-746452338-1758071341=:25424
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 17 Sep 2025, Thi=C3=A9baud Weksteen wrote:
> On Wed, Sep 17, 2025 at 1:26=E2=80=AFAM Paul Moore <paul@paul-moore.com> =
wrote:
> > >
> > > So far as I can tell, seems okay to me:
> > > Acked-by: Hugh Dickins <hughd@google.com>
> > >
> > > If I'd responded earlier (sorry), I would have asked for it just to u=
se
> > > &QSTR("[memfd]") directly in the call, rather than indirecting throug=
h
> > > unnecessary #define MEMFD_ANON_NAME "[memfd]"; never mind, that's all=
=2E
> > >
>=20
> Thanks for the review Hugh. In our case, it is necessary to expose
> MEMFD_ANON_NAME as there is a string comparison done in
> security/selinux/hooks.c (see selinux_inode_init_security_anon
> changes).
> I would argue it is cleaner to reference the same constant. The
> alternative here would be to have 2 copies of it, with the risk of
> them being out-of-sync at some point.

Oh, I'm sorry, I simply misread your patch, and thought that the
#define MEMFD_ANON_NAME "[memfd]" came at the start of mm/memfd.c,
whereas it's in include/linux/memfd.h just before mm/memfd.c.

Yes, you're perfectly correct to do it that way then, ignore me.
(I do have to reflect on why three instances of MEMFD_ANON_NAME
are safer than two instances of "[memfd]", but you are correct.)

That does lead me to look quickly at the security/selinux/hooks.c
end of the patch: I don't particularly love what I see there, but
that's none of my business, you and Paul have constraints to meet
there which I'm entirely unfamiliar with.

Hugh
---1463770367-746452338-1758071341=:25424--

