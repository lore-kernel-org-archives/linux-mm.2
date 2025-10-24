Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D367CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A63E8E00C4; Fri, 24 Oct 2025 11:52:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D698E0042; Fri, 24 Oct 2025 11:52:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693ED8E00C4; Fri, 24 Oct 2025 11:52:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 555F68E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:52:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CBE35C0F21
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:52:00 +0000 (UTC)
X-FDA: 84033448800.27.5BBDA3B
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf13.hostedemail.com (Postfix) with ESMTP id D986320011
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:51:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=MuiviN58;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf13.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761321119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+WGt0cv6lLjP7TTTzKdDcUwT/Nmru/ATJlKONEKntac=;
	b=4p03JtSifRXhvJGGz13CU5m3fyZgS6Dhdvl7L38LWfiBJvKupknYR6W/LFP44ZUrqGzWzo
	R3GyD1p76vynFo7WdH8HAIOXFA6aaxmCOmugxmA0DxEryAwdsV8vZN/PikOwseKR9USdHz
	iY1KyG89/F/LM5zLpkemhuCqcRu9VnY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761321119; a=rsa-sha256;
	cv=none;
	b=Bh/RsplHggE3QaGwZ7/k2c3DkbeRixSRlebSkmTRuuikCAdh9FiPkpq2vcX8ELxJ5Qbaxc
	CZms8ya9UoKnPYoLRH6G1EXyRnfDn9iKuZM0zIH/yDDSfaj0woVPmf2eDxReVF3HA7Rqc8
	Tx9fgRCieHSgvdKebkwoB3xBLK7pya0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=MuiviN58;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf13.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=+WGt0cv6lLjP7TTTzKdDcUwT/Nmru/ATJlKONEKntac=; t=1761321119;
	x=1761925919; b=MuiviN58qCK68CjYs4IhYM/Bvl4ezQsb6dZ4gMHzJpkcgRDGn95o0P7HwJeZU
	L8/k7I5zGSonrOZTwuDcMyuipYnG4q0oB8MJ2mH7/a5umcbMwDDdfx/5a7H+Ssxb0mVLaOP/a9q2V
	slzIpLTlZycx/f4+nWB5Oop5wHKOlxtc9ksxZzSpuc3kIWEPClvYYZjWo4vJ52XtXlG6eT/HxvSCW
	Bjk3Rm+v6b71cFHC9f3ZolUdEDq/98ZLF07hyM6jxfpMVuFL3P201MsbGkSJrIk2Xrf9ZXDq+NDz9
	ASg+M4SATDSWnXmTYDwXWaBEqd1eNKi6Bm1odRnMDzvF3xNJ5A==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.98)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1vCK55-00000000R61-3t7w; Fri, 24 Oct 2025 17:51:55 +0200
Received: from p5b13aa34.dip0.t-ipconnect.de ([91.19.170.52] helo=suse-laptop.fritz.box)
          by inpost2.zedat.fu-berlin.de (Exim 4.98)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1vCK55-00000000Lvz-2RRr; Fri, 24 Oct 2025 17:51:55 +0200
Message-ID: <1d9f416fd3665faf27841b6305b1e8d661427125.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v3 11/13] x86/xen: use lazy_mmu_state when
 context-switching
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: David Hildenbrand <david@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>,  Kevin Brodsky <kevin.brodsky@arm.com>,
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
Date: Fri, 24 Oct 2025 17:51:54 +0200
In-Reply-To: <9faf750e-2369-4fae-b58a-ed9052cfd6f6@redhat.com>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
	 <20251015082727.2395128-12-kevin.brodsky@arm.com>
	 <f0067f35-1048-4788-8401-f71d297f56f3@redhat.com>
	 <348e5f1c5a90e4ab0f14b4d997baf7169745bf04.camel@infradead.org>
	 <70723f4a-f42b-4d94-9344-5824e48bfad1@redhat.com>
	 <cbe0d305cce6d76e00b64e7209f15b4645c15033.camel@infradead.org>
	 <fcd7b731d38b256e59edd532e792a00efa4e144e.camel@physik.fu-berlin.de>
	 <9faf750e-2369-4fae-b58a-ed9052cfd6f6@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 91.19.170.52
X-ZEDAT-Hint: PO
X-Rspam-User: 
X-Rspamd-Queue-Id: D986320011
X-Rspamd-Server: rspam02
X-Stat-Signature: k1yzg84gopiizck5yxdody1oab1z6gxz
X-HE-Tag: 1761321118-378525
X-HE-Meta: U2FsdGVkX19fgpmSBgQCF48va3X3UYXew3wOFKtWPJh0vFWvUnZX++VGEjtY60Nlwld/ERJ0WlUlFEj1EmCXmFNbZLiXs0dPMgq8AW0wxwHSz0TOUHET4sl7cbMAEOJNApsXj3PVmOfiqVHRw7I/lsj+sKV+ZvLgxpjJ3Yp/eozLqSjVD3/q5QhwEdkymTRbfSQ5v0t0P++Wd5R82lKG0914p6tCND3tDJWNclnlDNgHzcTmRTthZkXS0CU7FYaizkifL7KRNrOWD+AztCEzC+isJPP4zTW6PQiCzniYZ2dpYmx/m6La/4YePR+iD+5UgI0V8T+ko41l28EOoPgmBZ5BEd7/g2gGbZd+GqNSE+0LQIJBjD0OMrNmeS8S5bOtIvGCztBW4XYF6RPkCZnpBmb1gLrjB5Yp/NW44d/YdyTEuh1+b9KbEqMtsKwhB4wnrp0TTeu11aZ07rjFjGpRmsCkcFD+pRnkLfWWVUygONOfIjpYrNsK0kv0JBtqgVnlxMWFrC0/FA9gVxnVt0rLf7DorxRAbAwAXV7BBovVqy/Vu/huaiLzFl+T8GbGrV1loEuA/OFnvlVOIbP0Er9orXLEFw9ZUx9u9R3hVRoKdhZ2OKPnXUvPhsOIh6zcj4JLeqRobRrHGsW9V9cXz1r8Vjznqqbkd9u0ywG496mNvSO1WP2bw2gtKGYgEemZuCYefbm/cizZlzrO2gtDOjN92sOuq+WJzpsE86ZQCNZ6BH5MMRS1hVZt5iuqsb0Jj4767YlXLG4BU0nVXebeTZpCHaYw9GbTz038wK3WRPjwiI6FYjv7rLLNBBv+/mhPxRMqm8OOJAYqHC0CM8grRTi7THYDF3VF9aaPqaH87SS5tfRb8Y131ExL01E9rqkIpkAxxwMT5huQz5dd5+fEyYKRgt4fDyhL6DYjHqaYiOXQDP/kBy8grjB6tAVgCpiF+WDxVHvFkqv2fea4zy6tSj1
 9gF82WEI
 n2+nqT2gI1/gZqSZDYAZ+5DRBqbDgCcp/gw6tytYNakkXTZxtvZt2VtVrpZ7UgUMPxas6VQmJjZirg70jdVVvU/CkKux5Mi7J53JSSX65S1E12xp7stJXI7Kl1NVgLSugM7xUPFvIdsEkXkdkevDwuI1GUSJHfHgRp977GftWZUn0/96oA0hwhwEemsSA4GYjcRpkEUYNzmxu/NFwZ6u+/+m6+4uovJ4+u4V5DJY80PwR9z8qNtu5kpVpDq8Tts/d21bmAJ/zT0CBRq53WxsPNcCYwXVObhUiN+OUYOsD/SVqb30Kwl86bPxI5F52UrdZL21mTSiZ+iBPcCpmx3oaBKjrEQ+kuFs9941z9dHwmNcT2yXP374YZKEmgKtY0jxNcvoqYNp6nyr5kSsTTZqzCiOla+MR/b1ey/G/5OMhgebKZwvMmn4BII4RvVtl/MyfTpxZHWLxnKOOxQe/wwHGrIYBEX66RpW73IEmk4HAoQXXAPuLBIMw9YgF6tNXpfKDHR/8/wVBqeKQk7NeXZqdiphEb1CPHU74JZuPOLv1q72tV9g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Fri, 2025-10-24 at 17:47 +0200, David Hildenbrand wrote:
> > Please have people test kernel changes on SPARC on real hardware. QEMU =
does not
> > emulate sun4v, for example, and therefore testing in QEMU does not cove=
r all
> > of SPARC hardware.
> >=20
> > There are plenty of people on the debian-sparc, gentoo-sparc and sparcl=
inux
> > LKML mailing lists that can test kernel patches for SPARC. If SPARC-rel=
evant
> > changes need to be tested, please ask there and don't bury such things =
in a
> > deeply nested thread in a discussion which doesn't even have SPARC in t=
he
> > mail subject.
>=20
> out of curiosity, do people monitor sparclinux@ for changes to actively=
=20
> offer testing when required -- like would it be sufficient to CC=20
> relevant maintainers+list (like done here) and raise in the cover letter=
=20
> that some testing help would be appreciated?

Yes, that's definitely the case. But it should be obvious that from the sub=
ject
of the mail that the change affects SPARC as not everyone can read every ma=
il
they're receiving through mailing lists.

I'm trying to keep up, but since I'm on mailing lists for many different ar=
chitectures,
mails can slip through the cracks.

For people that want to test changes on SPARC regularly, I can also offer a=
ccounts
on SPARC test machines running on a Solaris LDOM (logical domain) on a SPAR=
C T4.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

