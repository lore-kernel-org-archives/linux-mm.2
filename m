Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692F7CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40128E00BD; Fri, 24 Oct 2025 11:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C17608E0042; Fri, 24 Oct 2025 11:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53BC8E00BD; Fri, 24 Oct 2025 11:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A55C88E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:38:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5646312A2CA
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:38:38 +0000 (UTC)
X-FDA: 84033415116.17.E6AEE11
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf03.hostedemail.com (Postfix) with ESMTP id 786302000F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:38:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=kJlcNoD9;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf03.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761320316; a=rsa-sha256;
	cv=none;
	b=FEZiYsYAMJAbbkGsO/ldlcDGA04Sd95NcFlD1qqhjx/qfshEPCRx8SktzZ8wgL9zn1Sv5R
	kHQXSchEJJICd6R6vcdWAKfWCRfypiuBf19gcpqWSl6wz3OFIfcbkAiprPiskb3J3klM3q
	QnH84d32hL1DJObvPAPo+/JkKXOcWKM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=kJlcNoD9;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf03.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761320316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=73Zwdq32M3wvIOvcsImSKjLgygutGdvwi4JFjWo6zTA=;
	b=0tGTHlUipLd0q9SRT3P7DxwjCiY8g4RagU5rPrGunKfJ42rECzl+3xU6yltkHYY6v8a9gJ
	cD+Y6RsPubLgJPdF9XIAEKCnUbiHa9Zj7j+ZDk6JMMcxMznr04WM53SX23HQHQ4CP5R+16
	PoRBR4iHyrMlpuHLtXXTq7MEs8jwBqE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=73Zwdq32M3wvIOvcsImSKjLgygutGdvwi4JFjWo6zTA=; t=1761320316;
	x=1761925116; b=kJlcNoD9Ge7Y+/qogo3qcy/SlsGBnVihuuXMMKiXYr1sDR2Vsf4tQIBJQ8Gd2
	fnXShNbToDkO7EUbJK67l2JGgXXtXBiJw1etFy2m2ibzpF2SVE6/1tcKtS+J5Ejoa2c6Mrg0tkXnY
	XIYMO7zwTHjrYwFb3iCGxizx+CgORVuDFGpd08UWIevUhIL8SblENYwUd/hdqXWTuMjlKVuX6wjCQ
	/WQBAXccuV7tylsdhirGAO7cVUy3F3uOlqyu5Chva3BY2VX7a73Ycep4Y3R+nPx57JRR5SwzkqNr2
	tIlOU307L8nRAXEJoJcY+u6Kq+HuVuAciNniVIFd2sDRrQv7lA==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.98)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1vCJs4-00000000MJF-0C1i; Fri, 24 Oct 2025 17:38:28 +0200
Received: from p5b13aa34.dip0.t-ipconnect.de ([91.19.170.52] helo=suse-laptop.fritz.box)
          by inpost2.zedat.fu-berlin.de (Exim 4.98)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1vCJs3-00000000KCV-30QZ; Fri, 24 Oct 2025 17:38:27 +0200
Message-ID: <fcd7b731d38b256e59edd532e792a00efa4e144e.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v3 11/13] x86/xen: use lazy_mmu_state when
 context-switching
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: David Woodhouse <dwmw2@infradead.org>, David Hildenbrand
 <david@redhat.com>,  Kevin Brodsky <kevin.brodsky@arm.com>,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev
 <agordeev@linux.ibm.com>,  Andreas Larsson <andreas@gaisler.com>, Andrew
 Morton <akpm@linux-foundation.org>, Boris Ostrovsky	
 <boris.ostrovsky@oracle.com>, Borislav Petkov <bp@alien8.de>, Catalin
 Marinas	 <catalin.marinas@arm.com>, Christophe Leroy
 <christophe.leroy@csgroup.eu>,  Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin"	 <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,  Juergen
 Gross <jgross@suse.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes	 <lorenzo.stoakes@oracle.com>, Madhavan Srinivasan
 <maddy@linux.ibm.com>,  Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nicholas Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ryan Roberts	
 <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>, Thomas
 Gleixner	 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Will
 Deacon	 <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
Date: Fri, 24 Oct 2025 17:38:26 +0200
In-Reply-To: <cbe0d305cce6d76e00b64e7209f15b4645c15033.camel@infradead.org>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
		 <20251015082727.2395128-12-kevin.brodsky@arm.com>
		 <f0067f35-1048-4788-8401-f71d297f56f3@redhat.com>
		 <348e5f1c5a90e4ab0f14b4d997baf7169745bf04.camel@infradead.org>
		 <70723f4a-f42b-4d94-9344-5824e48bfad1@redhat.com>
	 <cbe0d305cce6d76e00b64e7209f15b4645c15033.camel@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 91.19.170.52
X-ZEDAT-Hint: PO
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 786302000F
X-Stat-Signature: gao1r41mzj3ew9nhoiuocyu7qco7eabn
X-HE-Tag: 1761320316-8445
X-HE-Meta: U2FsdGVkX1+xLHosJnqEGqhGF+gCiVvjBJuvbdOnxeO6PmgypisPboz6Pywla74xOV+oYVlVBQGLP5vTF/tecY6Jp6K7Zxmx3eplUH9zh0zFEKipRgRYUcT8F+Lus3r0oJQgn8tKwJk+vA/UGUTwUbMKLzW37BrJGeOknNBpH41VBrVDJtAq5EyANjshLUugmOUkPTcErnYjlToWYiRccKV4NnN2H+DoZ+jEni4uvYIO49s5u08PivM2RGByCYTvMQEem49l4lDIKSha9ZR6zRbligrOZdukdOltP5CEY9Gyx9GDZHsUzCT7UCUi+/des48H29ozvcgA5E5ERTWEqjETX/vN5Ghyb0eZgvpJHtqyNKhKz38M8vdlivRkdwbhZSw+2i8KePpibJ3mmm80MxJ1fC2Vaq/6CY6gZ0wF+fGoGSiooLf37ooTovaO5kja2Qg6UyUIl75hmDBrqa3NLoKBlhrGj+V81v3TPL1QVdskXLXE68VOAYFSej2IdHHgMycdzDeVfII1kJRiJ1FPAu7OOxGBCt7uUqxUx0x8yBfQWTqH55guh3GkfmuuOWm9CJbYoTskJKEe1VB699G2m9g8XqM7BsNPujTX2t+X56kto+i2y2YJMT0ZhmEGsPrzzoSwfugK3qBq2InN/LZfb1zRJUykMD/esFtzYbz4HJeoH2OrqcwmJ5KQbjDSY1GYlDLCBw72kd8FmjvKz09f2+XzdVJiiZodk01GKZs1J/VzGvWAVyQBm6OFtocHDa7wmY96DKEEBvqVQ4vE6zbeHB+OmWevvc207LUnD6kRT6q35gpjOQt9AqC5cZe2eGKtD7TQFDIkI7pqvNcKCZ/4a0pHq+Cax3YDOZfXtlKKteC5xkXLa01F6HBaRqhatHmv+YdLnAUuTRNAURJX0dkRobdjxW/U7tlspbTb90LoR0NYDnNb9RJxyvRdq34UYP6mSTtTTU+FmBUkw4GXn1y
 xYXJaa0H
 Vw3m69/iQgjolmUiP8egv6Y+ls4ILe3JnkwGhU6i1lOKO9jkG4S5+Rxd4RAGHgUstbtBk3PA+wxvoBponKgCPkf49fCUH0MUZW/w8o87+WUuuB6I2MtxQGQIuEBs+ByOcIBFwDoxDCsZM8XRGxwya1D6EuBPZzjoA48g2lxrpidw/5NJ+sYR47On2Zm9jNkSdA/cWTDfBAe07Sdsb+eJ3+e4lu9qxxFzkywJ5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-10-24 at 16:13 +0100, David Woodhouse wrote:
> On Fri, 2025-10-24 at 16:51 +0200, David Hildenbrand wrote:
> > On 24.10.25 16:47, David Woodhouse wrote:
> > > On Thu, 2025-10-23 at 22:06 +0200, David Hildenbrand wrote:
> > > > On 15.10.25 10:27, Kevin Brodsky wrote:
> > > > > We currently set a TIF flag when scheduling out a task that is in
> > > > > lazy MMU mode, in order to restore it when the task is scheduled
> > > > > again.
> > > > >=20
> > > > > The generic lazy_mmu layer now tracks whether a task is in lazy M=
MU
> > > > > mode in task_struct::lazy_mmu_state. We can therefore check that
> > > > > state when switching to the new task, instead of using a separate
> > > > > TIF flag.
> > > > >=20
> > > > > Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> > > > > ---
> > > >=20
> > > >=20
> > > > Looks ok to me, but I hope we get some confirmation from x86 / xen
> > > > folks.
> > >=20
> > >=20
> > > I know tglx has shouted at me in the past for precisely this reminder=
,
> > > but you know you can test Xen guests under QEMU/KVM now and don't nee=
d
> > > to actually run Xen? Has this been boot tested?
> >=20
> > And after that, boot-testing sparc as well? :D
>=20
> Also not that hard in QEMU, I believe. Although I do have some SPARC
> boxes in the shed...

Please have people test kernel changes on SPARC on real hardware. QEMU does=
 not
emulate sun4v, for example, and therefore testing in QEMU does not cover al=
l
of SPARC hardware.

There are plenty of people on the debian-sparc, gentoo-sparc and sparclinux
LKML mailing lists that can test kernel patches for SPARC. If SPARC-relevan=
t
changes need to be tested, please ask there and don't bury such things in a
deeply nested thread in a discussion which doesn't even have SPARC in the
mail subject.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

