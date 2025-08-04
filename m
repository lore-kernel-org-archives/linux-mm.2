Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4699C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 09:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CB7D6B0095; Mon,  4 Aug 2025 05:38:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27C606B0096; Mon,  4 Aug 2025 05:38:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143B86B0098; Mon,  4 Aug 2025 05:38:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 051566B0095
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:38:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CDD60BE984
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:38:40 +0000 (UTC)
X-FDA: 83738575200.19.FD415BA
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf03.hostedemail.com (Postfix) with ESMTP id E236E20006
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:38:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=ZjM+meP4;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf03.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754300319; a=rsa-sha256;
	cv=none;
	b=aqSnIK3ndfaOw20gc4MWfhEYENnNzAPTDZV4naY7c7A+XZOa1uXkRgmYoOU7MPIbAjiz+z
	3XKMvjA2aK2EyhOs7vepn96EPxdmPuysc3Lnyi7WTiLcNyL5t7L0mUdTjFS+oZ3uKpsyOZ
	sTzBQK9g7d63k90RCMaIrwNIWq3ObZ4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=ZjM+meP4;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf03.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754300319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YTCl/zW/Wo/tkqi5mo+Efw9tJOY+FJ3ba2nykfa53A=;
	b=1yg2nUe3XudLgUAb6hBXrsmLPsznH6FY0+wx4ol6LXsHbFe4P/emUdGQ145m1sKeeHx1WM
	xssX9whOVpgewPwMAA9Mar3nFiUQk0S1ApxW/ephzSefe66eEiL5NS4G+SdZlYLW+THWnY
	ACtxHEupkJQcd5/XJ1O/xhSqHPFrrxo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3YTCl/zW/Wo/tkqi5mo+Efw9tJOY+FJ3ba2nykfa53A=; t=1754300319; x=1754905119; 
	b=ZjM+meP4MAtcpcZG9Lu529MJvQ7EnfpzDLskccToFvuM97mihIGa9pn5KdU6jzqbamYYSkQiW2J
	M/bEG2MGL4j6VPM2wbRHl6CKIcUJ8GMImdbHdyaf1c3CBRQyntyY9GfZLUgjFpTals/dgrKS09Jap
	eSCsxySU/zYk2jTOzV/N3kwM3wYQzJGHpqRvqTcM8AC8nkpGCbfgkOc1Gisghjj/WvjRGNRebXZXP
	aWuatajzciTCNHBvFzpPWWxmPeBuaE5N+nCWSDWMKgYbGxIHREE83rYTVlV0CF7ALMbEoAolYBQZ0
	FajOWTdHtVPPZ5SJra2JyKdU+BByEq9VQ4eQ==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.98)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1uireN-00000002kpa-1lOP; Mon, 04 Aug 2025 11:38:35 +0200
Received: from p57bd96d0.dip0.t-ipconnect.de ([87.189.150.208] helo=[192.168.178.61])
          by inpost2.zedat.fu-berlin.de (Exim 4.98)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1uireN-00000000oqi-0mSZ; Mon, 04 Aug 2025 11:38:35 +0200
Message-ID: <ab2138b468994050a817426f8ce4fd784108c210.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v4 25/36] sparc64: Implement the new page table range API
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Anthony Yznaga <anthony.yznaga@oracle.com>, "Matthew Wilcox (Oracle)"
	 <willy@infradead.org>, linux-arch@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, "David S. Miller"	
 <davem@davemloft.net>, sparclinux@vger.kernel.org, Andreas Larsson	
 <andreas@gaisler.com>, Rod Schnell <rods@mw-radio.com>, Sam James
 <sam@gentoo.org>
Date: Mon, 04 Aug 2025 11:38:34 +0200
In-Reply-To: <d424e109e6f1a00b8cf22ec1b40d6dedff38ce52.camel@physik.fu-berlin.de>
References: <20230315051444.3229621-1-willy@infradead.org>
				 <20230315051444.3229621-26-willy@infradead.org>
				 <ce6337237169f179c75fe4a1ba1ce98843577360.camel@physik.fu-berlin.de>
				 <83931f05-a613-4972-be76-80bc695915e4@oracle.com>
			 <75cbab0cdab084795422335c0e0d69c6f57b468c.camel@physik.fu-berlin.de>
		 <76c45021481cfe1aaa9fe2cfcd2287ac6c8d4504.camel@physik.fu-berlin.de>
	 <d424e109e6f1a00b8cf22ec1b40d6dedff38ce52.camel@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.150.208
X-ZEDAT-Hint: PO
X-Rspamd-Queue-Id: E236E20006
X-Stat-Signature: kzkh33ad9cuytcfzm594e1o1mgce5sqm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754300318-558150
X-HE-Meta: U2FsdGVkX1/0pvXYhENMpfRhb43eTizwVO6Ds1ZkLbrWDy3AO9B6oaG3Rte6chpz4FipVdmaf6p7EAdgwuDEc0iBZueXOk3X/EiWeF0kSDYrSYDgpplelWSlnQplGd5kbIlIYkD6NjOSFytkI7/5UzvWTQlImzfVep+ubevD4zzRO7WMo0SAyZ/NKvwm5Ob/f/Y3VSH1tTU9jJ/JuxIcToqboKvTFE0qw2pbrjUDxg2MlSV3q17yGrPqLDEZWw31YIWWyot0Nivv8de63NUHIaYHfIEknFdHT5drBz2RwIgg5rnde7hW6n9AA7zEu//Fr53Ling6cg2Ui8wk9LJACSMDS8BzVROv990lVD+gmB0qXHMa20J2u73CEmOs/zO/c01SHed1MCUkJJlcisOwBk2RMfy1NXWbxlIVM2uRjGdqvqYjDnvJRR5Tyr+83Hqv50k2//LSNtHCcHsHCRwnQpDWdoS4kjV5W889kFL4qp15Sgj506FQbUCUbdrGRD+6V0vKEPgmZ/95uQyQLD31dr+CNZCjGcrimiSaDeoE4zeadK8eNFZDEC4LSdEIGSuUZb4g12jtqXDPAHIBnaHTxUstOeJSpPqMW/eDe84PQmrvLMbZoMGFAhJ27rEsWUMmcbTMf6XzrhwDT+F7pXwiqRONbG/nnHXEyPKRudwGwnhpLtadhcY82mjxuAeTn0xcvQFoUn9BSLJ71bbWQdB1DhEXf9Q+QQ11BWBkQYNfpai88Ch7StH2VrwrQkIFV+OKWdo2Y0jIy7OiYsKGiY0256XzSrf3NZamKNr3i0cpKIBHs6biDay0V0pBUh1q4hhDAUrTex5Pa/SORQy2ZziHOyNJgkH4LpShpEwl2NUeA+nGHQLP1/vtmtkO+hpc+uY8rlWSL7wxjROpLK9h4lK06QWy00JzncaXFwdFSUg3wLrNDUvm/h319G6kPB2NLQJnE8oMGAlj02nh/Z+JDcl
 zm10s99Z
 AF/d2L//X1+lUuOiJ1nCi5AoCU/A7O0imBTb7k1PO2IFrdt5Ebr3K5nqV28R1Z+9s7z0Mkw6ZBn3kp03bqm0j3Pr0FajFg2llfooCT2rExvSVlqI/qs2P5MOmhyzSClHS232UOsWrIQuf4g21O1JFzyhtUobVSuGMqUhCDLBfljm0Muc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,


On Mon, 2025-08-04 at 08:58 +0200, John Paul Adrian Glaubitz wrote:
> OK, so v6.8 is fine while v6.9 crashes:
>=20
> [   39.788224] Unable to handle kernel NULL pointer dereference
> [   39.862657] tsk->{mm,active_mm}->context =3D 000000000000004b
> [   39.935941] tsk->{mm,active_mm}->pgd =3D fff000000aa98000
> [   40.004566]               \|/ ____ \|/
> [   40.004566]               "@'/ .. \`@"
> [   40.004566]               /_| \__/ |_\
> [   40.004566]                  \__U_/
> [   40.197871] (udev-worker)(88): Oops [#1]
> [   40.249329] CPU: 0 PID: 88 Comm: (udev-worker) Tainted: P           O =
      6.9.0+ #28
> [   40.353415] TSTATE: 0000004411001605 TPC: 0000000000df092c TNPC: 00000=
00000df0930 Y: 00000000    Tainted: P           O     =20
> [   40.502105] TPC: <strlen+0x60/0xd4>
> [   40.547844] g0: fff000000a3171a1 g1: 0000000000000000 g2: 000000000000=
0000 g3: 0000000000000001
> [   40.662224] g4: fff000000aa4dac0 g5: 0000000010000233 g6: fff000000a31=
4000 g7: 0000000000000000
> [   40.776599] o0: 0000000000000010 o1: 0000000000000010 o2: 000000000101=
0101 o3: 0000000080808080
> [   40.890974] o4: 0000000001010000 o5: 0000000000000000 sp: fff000000a31=
7201 ret_pc: 00000000004d4b08
> [   41.009924] RPC: <module_patient_check_exists.constprop.0+0x48/0x1e0>
> [   41.094557] l0: fff0000100032f40 l1: 0000000000000000 l2: 000000000000=
0000 l3: 0000000000000000
> [   41.208936] l4: 0000000000000000 l5: 0000000000000000 l6: 000000000000=
0000 l7: 0000000000000000
> [   41.323311] i0: 00000001000256d8 i1: 0000000001143000 i2: 000000000114=
3300 i3: 000000000000000b
> [   41.437686] i4: 0000000000000010 i5: fffffffffffffff8 i6: fff000000a31=
72e1 i7: 00000000004d63f0
> [   41.552062] I7: <load_module+0x550/0x1f00>
> [   41.605811] Call Trace:
> [   41.637838] [<00000000004d63f0>] load_module+0x550/0x1f00
> [   41.708752] [<00000000004d7fac>] init_module_from_file+0x6c/0xa0
> [   41.787670] [<00000000004d81c8>] sys_finit_module+0x188/0x280
> [   41.863158] [<0000000000406174>] linux_sparc_syscall+0x34/0x44
> [   41.939790] Caller[00000000004d63f0]: load_module+0x550/0x1f00
> [   42.016423] Caller[00000000004d7fac]: init_module_from_file+0x6c/0xa0
> [   42.101059] Caller[00000000004d81c8]: sys_finit_module+0x188/0x280
> [   42.182266] Caller[0000000000406174]: linux_sparc_syscall+0x34/0x44
> [   42.264614] Caller[fff000010480e2fc]: 0xfff000010480e2fc
> [   42.334384] Instruction DUMP:
> [   42.334387]  96132080=20
> [   42.373269]  19004040=20
> [   42.404151]  94132101=20
> [   42.435030] <da020000>
> [   42.465914]  9823400a=20
> [   42.496793]  808b000b=20
> [   42.527674]  024ffffd=20
> [   42.558556]  90022004=20
> [   42.589437]  8f336018=20
> [   42.620318]
>=20
> So, the regression was introduced with v6.9. Will bisect this later this =
week.

Looking closer it seems that the original issue seems to be filesystem corr=
uption and the
consecutive crashes with older kernels might be a result of some corrupted =
binaries.

Will first try to figure out what commit exactly introduced the ext4 issues=
 on sun4u.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

