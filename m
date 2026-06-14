Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31845CD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 12:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29B276B0093; Sun, 14 Jun 2026 08:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FDA06B0095; Sun, 14 Jun 2026 08:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EC826B0098; Sun, 14 Jun 2026 08:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F00C06B0093
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:32:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 76C7F406A3
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:32:33 +0000 (UTC)
X-FDA: 84878456586.11.E8BD1DB
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf26.hostedemail.com (Postfix) with ESMTP id 33FA014000B
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:32:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=CkQ7fN0W;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf26.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781440351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12TVOpMiX5ADydgREBd8yJZ1cemUPERFwxCuliwFQSE=;
	b=uKMDO/dkPeQk4VErHKmWnSjjLCFTdVqvcApRY6MgFD9PFm3BcPUGg5zaVcwhzjvD4AlKSk
	xvkuEvyZDmwELDYkyldQV5dfkHiXGNomDfAHf+SjUfgHIMgRMZbcqzHs57ux4xAkiaFi1K
	YL3hJsqDtiiM29RhbT9RQYvCCpuZnIM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=CkQ7fN0W;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf26.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781440351;
	b=i6H8TeNvwqZVDHMF4BVE0/yX9aDmlRMu0sdpheBkBfq8UlIz9Znuq64s81G1rXKFS1U8Tl
	s7jQJGw5BUEO/4SGZcm2N751cCFnJcICrYM5DwDP9PcAN+dpfjsFosE4Sk4ZlvvaAdN3LC
	wJS26ccafUQTeP0HA8edzyuN8NGxGt8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=12TVOpMiX5ADydgREBd8yJZ1cemUPERFwxCuliwFQSE=; t=1781440351;
	x=1782045151; b=CkQ7fN0WjR80GhRMUEh2NnOCFhlJOPymgi5ySSm26SwnbteyANj50yZXRM25C
	oV48ir9mr9BE8OISuWkVlqq5q1HCXA1LDXIOBZnJpKiVcOUp5fSAsWRCwPTD5kCBYQ43ByVX7gZvV
	28xYXPjrkIVy5QRb179jK6e1ZhvKTgaIfYnDi3Gmexhu7cvWuqpygJv5b/i9DgphHEq+txTdd80df
	OOFzeFdBd5rZ+pDpIsMSo7Of7sTBJM0yCNWfgRdflbLmd+negTFBGCjsSirOK6dzuAUX/Tz7ZvjOS
	nYrhoq3JbS2Q2j7qMHYAwLuAxGUgVBUWtXtBuvjdMwnkDaKiHQ==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.99)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1wYk0l-00000002P9o-1VeE; Sun, 14 Jun 2026 14:32:23 +0200
Received: from p57bd94c1.dip0.t-ipconnect.de ([87.189.148.193] helo=suse-laptop.fritz.box)
          by inpost2.zedat.fu-berlin.de (Exim 4.99)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1wYk0l-00000002Fc0-0XhR; Sun, 14 Jun 2026 14:32:23 +0200
Message-ID: <82232ce685abc2050601abec8b4b14c0aae14e64.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v2 00/10] sh: remove NUMA and SPARSEMEM support
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-sh@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 Arnd Bergmann	 <arnd@arndb.de>, Rich Felker <dalias@libc.org>, Yoshinori
 Sato	 <ysato@users.sourceforge.jp>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Date: Sun, 14 Jun 2026 14:32:22 +0200
In-Reply-To: <ai6Diz0UgSGccbhY@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
	 <agr7XvoWn_-axX1-@kernel.org>
	 <adb1db8d1fbb9d219fa041776ae863aa2fc09270.camel@physik.fu-berlin.de>
	 <aiBI_QEmeVSBb2HY@kernel.org>
	 <865aaa7aa64ab69ca9020d64d86baa8d9b700bcb.camel@physik.fu-berlin.de>
	 <ai6Diz0UgSGccbhY@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.148.193
X-ZEDAT-Hint: PO
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 33FA014000B
X-Stat-Signature: eg7mrueir499hoqogphht9suo3wz9s5e
X-Rspam-User: 
X-HE-Tag: 1781440351-604719
X-HE-Meta: U2FsdGVkX18MwGwVJ9FJ27geMyyGkL2olZFGrs+uAAbfeVkZQfgYFUecjl4ukSiltTpC7lGIc5XrCSaJTvXwK2F+182PDLY/nsmZ8X8acHNpBRlQrtsHQcEIiE9TNAqbgcL+O0HJxjSViLPUsmcKs+zu1fvMd0VHzkBWrT3Inkfmd8VYSofM04KxG9186wpfdcEOrt+sNfMVGOHl/vsJlyMebxbxeUHEFBa4aJam0oE0ETMez1vSGeDxx40HtI21Jd9LfkOEpnOPkpFvHYZcJSrIYC47vbcO6wVCWBncmwz35Cv6LcDiJrmw0motgr9RrruKo9Y6fdfKFOqlK8EF52BGVhgZz1lPq9fEEhiw+BDYRyrlMec6ylD9WhLRLp4UsIhb6LkutkWRHDsp7z950oxkDsh/YzvqvzKGTNHHaZVCnBXOlLnobjWA9M13nFnm5EusyBjo4ghaSQav2GFwfjYANhPkUqB4n4YVZmF6OLD+8ZpFqlkgM4n3kFtJGXBNwquLSmIvp8h4zahz9YgQ1Gw9yKoB+FDrTAojtmk77qoipBMJGks5vtgleTLiNJd/AcZO8uFp/LhOir8Tq0+pcr/zwDh3IYN4tQxYrKiLq7zm/P/ZJoQmrSrmTKSE32x9rGN1eMDWsRC4ipTUpzQCJiMj6N9dfquByn5KdWjVmwgawJFDoH90ecTnL8Y9lhF5l/aNgunvoEltsJMHpO+BYLXvbc+nq3e4k9aVruFbnCtqJvYGEbeq1qsbHsA8pey7s6zWrottuaJSgswB+ZMF3oRv/aI5Y2X29VEO7wTCVgofVhN7uq5GAYZRFYwm3DzOLDZJEGdFA3B7pltd0CBcNnbTVZB8xUboz5nG3Zdc3u7vl3+mflHBtEG5+LHJXuuwNSLntuJpfoS0g+7TjtEp8L6IoGC/3EpfRV34iDSLPdZnYzXfvXSWxrD5gPfTKuZ3ydv9yYymsYfK/A2X2X0
 wQL2tkTP
 ICATnj1k2cYEaoeCI2eIInqvPLeEySLUuiUHUMkiAhwNGSLzFxI0MRTURjVMvxW8ccRhgn5F5ga7SQOsD5zjWr3DzamvjbG6fPChGK2LnwLaj0KKr5igfBmDOjL/HlojfL3meiO927GTSP4fixzqDZlSPXM7CwjSb9am64++SpAdDyVF+7NerDyoyGyr8Fr767+szGOIcKEgIUBrn1pW76Zgk+a3Xd9Kpxe7rzN+lVLsnr/Ir7Rgu+EiuSpe0gZaRPFlyrkQbXZpFY6u4t45S2sioq//zXjm0Q9dCRkPMkqsbizrPL4oBvvZQgTD4NLvZu6Kfc+5BA2FBgL7lfXu74thEMXlXZMKEYoHFpImPHf8qX8qVay+PruHQ2r/1FOnmlS3J3c5MXTaQhWM33V6c/xgKsO6p6xphQa40YCSQSCCCOD7A515WnJyjG2anSVGG8pcdMyLhSGCTzoH9jFNKRbrJo+1D/KqFnXRxvbP8GOYVH+ZxKxjhg+U47Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Sun, 2026-06-14 at 13:33 +0300, Mike Rapoport wrote:
> On Tue, Jun 09, 2026 at 09:21:37AM +0200, John Paul Adrian Glaubitz wrote=
:
> > Hi Mike,
> >=20
> > On Wed, 2026-06-03 at 18:32 +0300, Mike Rapoport wrote:
> > > On Mon, May 18, 2026 at 02:05:39PM +0200, John Paul Adrian Glaubitz w=
rote:
> > > > Hi Mike,
> > > >=20
> > > > On Mon, 2026-05-18 at 14:43 +0300, Mike Rapoport wrote:
> > > > > Gentle ping?
> > > >=20
> > > > It's on my TODO list for this week!
> > >=20
> > > It's sad to see this being dragged since mid April (if we count v1 an=
d
> > > there were really minor changes in v2).
> >=20
> > I apologize. I am doing the maintenance as a hobby in my free time, it'=
s
> > not my primary job and it can sometimes take me a bit longer to take up
> > changes.
> >=20
> > > If you don't have time to take care of that, just say so and we'll ta=
ke
> > > this via one of the mm trees in the next cycle.
> >=20
> > It should be better this week. I've been recently busy with CVE fixes d=
uring
> > my dayjob and the workload was extremely high.
> >=20
> > I am not going to let this slip, don't worry. It's just been a bit too =
much
> > stress the past weeks due to the AI CVE reporting.
>=20
> I understand that this is a hobby for you and there are a day job and oth=
er
> obligations and you don't have time for timely responses for arch/sh
> patches.
> =20
> I just don't understand why do you insist on taking this via sh tree give=
n
> you don't have the resources to timely deal with the patches.

Because I want to learn something in the process and also perform some basi=
c
testing where possible. I know it takes longer and I can only ask for some
patience, but I will take are of it.

I will get these changes landed for 7.2, promised.

> This set can perfectly go via mm tree as it cleanups a memory management
> feature that should not have been added to sh at the first place.

I appreciate your efforts in cleaning up arch/sh, so I don't want to stress
your patience too much. Again, I will get this into 7.2. Don't worry!

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

