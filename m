Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 875DDCA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 10:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A9918E000D; Mon, 25 Aug 2025 06:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933658E0001; Mon, 25 Aug 2025 06:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ACA58E000D; Mon, 25 Aug 2025 06:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 648898E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 06:19:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C45011856D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:19:33 +0000 (UTC)
X-FDA: 83814883026.26.ADC8928
Received: from mx08-006a4e02.pphosted.com (mx08-006a4e02.pphosted.com [143.55.148.243])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5BD681C0003
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:19:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=iram.es header.s=dkim3 header.b=f276yTAV;
	dmarc=pass (policy=none) header.from=iram.es;
	spf=pass (imf21.hostedemail.com: domain of paubert@iram.es designates 143.55.148.243 as permitted sender) smtp.mailfrom=paubert@iram.es
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756117170; a=rsa-sha256;
	cv=none;
	b=jTTpC7zKJk3CLuj153ANJabDV2QGGFNh1e10Al8fUrOjBPmYChAztCxQoYPTucapQ225Gf
	+LdI7mVoMtDp7IB82/J/huEnV0JoKoDv512Gkq1i1zvnXU6P85gomA75ZjR28zdM7MxHKf
	Hsmx8OWRzKp2J8BndiYSypDn9kLUhYg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=iram.es header.s=dkim3 header.b=f276yTAV;
	dmarc=pass (policy=none) header.from=iram.es;
	spf=pass (imf21.hostedemail.com: domain of paubert@iram.es designates 143.55.148.243 as permitted sender) smtp.mailfrom=paubert@iram.es
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756117170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2RQQU+xVYCIYE9iCJ4jbQxYZO59NkcR2A8V0GUG+Mo=;
	b=0YcS9bxMQpWEP+vVjFV4QNVJbjWbsbt0Z1ZvDrTEWchmADOzBj5tFdgGllsI2czoBn8XRo
	ucA8Z/LqRkMfUWgjuMEdDG1Ww6Ex1HhGXm1pZ2Lf8e2Hpr/q7OZYSIEeom+UJHERjRZWhV
	Jx7vgiZ62MHdqhSEXBDoOm0AbFVbCzg=
Received: from pps.filterd (m0316694.ppops.net [127.0.0.1])
	by m0316694.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 57P6PW3W020069;
	Mon, 25 Aug 2025 12:18:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iram.es; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=dkim3; bh=D2RQ
	QU+xVYCIYE9iCJ4jbQxYZO59NkcR2A8V0GUG+Mo=; b=f276yTAVV1SD26/ulkZ2
	ssJY8XTewysYT4tMLHnjnSIBPzgblP8WuCw3pnh/XAa52lQyDLxmxShvX17t1EXs
	AoQda248LCfIMXON/nZwXpeu4+MTA43njmbgfGliPSIcYHT6eGt5tvWcsz+Ebm8/
	4lIyyZv8wrgSbUY90OllDWqU/MTlR6SEhvM2DfGVcewE1Kv7qk7AtlaNhqjqabwW
	IOCDoLYjGRp5sJ9N4qvDQOAd9gPixccJfFHXTLWq+WrJuREyVW1zYVGsiH/zFMSl
	OAyS7jVvPh7W7XrmyRecvqRovk6Azt/V4iwX6CHVY52rTnzQCWQmiOXOKm2ygevf
	nw==
Received: from sim.rediris.es (mta-out04.sim.rediris.es [130.206.24.46])
	by m0316694.ppops.net (PPS) with ESMTPS id 48qs26hbtk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 12:18:43 +0200 (MEST)
Received: from sim.rediris.es (localhost.localdomain [127.0.0.1])
	by sim.rediris.es (Postfix) with ESMTPS id 26F1D181FAE;
	Mon, 25 Aug 2025 12:18:42 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sim.rediris.es (Postfix) with ESMTP id 00B66181FAC;
	Mon, 25 Aug 2025 12:18:41 +0200 (CEST)
X-Amavis-Modified: Mail body modified (using disclaimer) -
 mta-out04.sim.rediris.es
Received: from sim.rediris.es ([127.0.0.1])
 by localhost (mta-out04.sim.rediris.es [127.0.0.1]) (amavis, port 10026)
 with ESMTP id T0a5k0mKOE42; Mon, 25 Aug 2025 12:18:41 +0200 (CEST)
Received: from lt-gp.iram.es (haproxy02.sim.rediris.es [130.206.24.70])
	by sim.rediris.es (Postfix) with ESMTPA id 4570418007C;
	Mon, 25 Aug 2025 12:18:40 +0200 (CEST)
Date: Mon, 25 Aug 2025 12:18:38 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andre Almeida <andrealmeid@igalia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Laight <david.laight.linux@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v2 10/10] powerpc/uaccess: Implement masked user access
Message-ID: <aKw4frSacjCoruSJ@lt-gp.iram.es>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
 <647f1b1db985aec8ec1163bf97688563ae6f9609.1755854833.git.christophe.leroy@csgroup.eu>
 <aKwnMo7UllLZkOcK@lt-gp.iram.es>
 <16679d56-5ee0-469d-a11c-475a45a1c2b9@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <16679d56-5ee0-469d-a11c-475a45a1c2b9@csgroup.eu>
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDAxMSBTYWx0ZWRfXyQKmoH9DesXw
 ky5qpDKRbPVEO1j5P6RR/dl92Vu5gG46S+qU0RD2h9TCpiV9lxYjE4Rf4eAAbziJN1WFf5iKIoL
 vwHyFf4hVFUMvanQ6xRm7ygYHGMCvWURJrObfA0zrkO/dAoKD6EpbGdosihHgY3UjjtywmHeIhh
 zadbuk6ri8Bjd//t+fuudKJvFfCA6JbBQ9N+HL1oXH8gyaqcVqF4z95oY0uvqMW92ZBVK+g2n6Z
 F5336k0OeSJ784mGbOt0xTivvX2ToRO8PW2UCuoqsfP7MIu8uTDDGoglgFl+oLkNRfmAFLuzTMV
 j3inHZqHmiMrvZjyNxDRXcurMFxlSzfQPLVCuFgRq2ZkLrTZLm79a044/SvNKtbKXHZ8D77pt49
 kvezQV2k
X-Proofpoint-GUID: gpjt9l5GPC7skcU5Z664_moW2gPMxUzU
X-Authority-Analysis: v=2.4 cv=GqFC+l1C c=1 sm=1 tr=0 ts=68ac3883 cx=c_pps
 a=Kke4r4mcy+kRAsMtzpf9hg==:117 a=Kke4r4mcy+kRAsMtzpf9hg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=_EeEMxcBAAAA:8 a=LQ9UBoVtz5yYhqZLJvEA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: gpjt9l5GPC7skcU5Z664_moW2gPMxUzU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_05,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=salida_notspam policy=salida score=0
 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0 adultscore=0
 spamscore=0 suspectscore=0 clxscore=1011 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508240011
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5BD681C0003
X-Stat-Signature: o3jq5hhrjjudes4k6g6fxk84zkex8nqe
X-HE-Tag: 1756117170-202268
X-HE-Meta: U2FsdGVkX18zgfUuOp4ZkdjSlqzQdzKa00shgtz0qZNHXP0QlAk8t7wHwN5KadNKoDG6sqm03ATRfxCbfZQ7OV79ghXZ+yqOHechJO627HJ6vcrgXVLFc49FTdHsK1ifo/endwMwcFUCO1S9dUzPBslwhSZ/u3leSdsLErMwdoT+J5zEEePDZ6E6QYtuhFELRpMohIxoOUS8hVo3aoHXzUZvmbo+5uMzrP5BTeVJ0WJ/BzcxVDN9OGYRB0ZbS1bJg6aQ1gdIQputKM6ATushYN8zc6y3y7ZTEqXUDg0VgODEgIRfSvGCHlxmKv3mw2C1a8kTaH39+iJr4vLpTTPCXWgHPlJC4BwC8zP0dAPCz6TL36vqTU0SC4kAEUN+Jup3RbyjiaRLJD4cUIEcDBnkebLgZwV0ElVqr7RNOhquvlAqTtdLTqfvClNp87GrDW+KLluzfXEED8ihk60qHxIESyhHxizycR5EwCIIioV7fvAmVrCV8sQQHWFgxlApi2AjI/QCGPA566A1UjTTI5z0IAQiqOYaepSsjJSZBE3pbzdYcrWfwdJLanZ6LJkDay8783OqNClEo9qsbMPW6yJwEt+ybEnTjBjx4UgfjhaeWOIYyBQ/oqnAcxZoE33ZZPVXVGyiK+orqG49nvhRoKhT5YdTFtMeMyoX+1RAmALxxwVonuZ0OgyjnvrRIGERspydUY0SO+9hPsVR+QXp1wgxlNTnK7zb1OFbwd4zzZKaheUcMKRubAKtVuuidgceeQ9QzbkD4PbC4rpK7LiwEXvWAO5AYHOqOTxaS/XWb/U/gSrWKCsTp5f8U407EvxDR3r+CXGiWuRvscmxawNjZ1a20MUpz2rFB7JWxJfo+3JmW/4nK//PGl42GFB3seBR0okRJrz2GSL4i7h54cPRHE0Oucf6h/VhOLaTrn5GT32UiCjxh0bJZg0BKoUtCYF/50FteUN9+qVA0xyxFlNM7Rb
 h8dFSWAK
 uePS73oT84u8ddc2wVlEHSqiyb6L+eTaknFka7D5SJ7VAoGx53uOdRQRGT3kMmuu/Xe+Vyb1Ek8ehF1CaFHDFB3ubTZ54JEvtf+x4gbcm4gU//+VI4/zblhZFNYR3tnJn3X0cjrnkbbOPcFY7+eJOcYmwT4iq7ZrLWcDotthMV/GMuAxBQZjSqrU3ApD+zrVaf1efaWfrzokGgQg0aT9v3Hg5g49od3sZyFaAWUKmO8ofUronwbRfBy0Rf2RltkpZlpdd3/b4/rHmQaW4HwWozozi7GGzk0POg38hUi6vLncYVvuLi2CloQBW9sQJPIhO2PIJ/66YqUT2HSepd0LE3MNtePwA227taG9852dml1OU1SH/Ufm7xcw70A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 11:40:48AM +0200, Christophe Leroy wrote:
> Hi Gabriel,
>=20
> Le 25/08/2025 =C3=A0 11:04, Gabriel Paubert a =C3=A9crit=C2=A0:
> > [Vous ne recevez pas souvent de courriers de paubert@iram.es. D?couvr=
ez pourquoi ceci est important ? https://urldefense.com/v3/__https://aka.=
ms/LearnAboutSenderIdentification__;!!D9dNQwwGXtA!QUcSIXoDBBj9wAtcyQ-z3nP=
EAj-RnJpPgYwjOeb6LZWLejdLzq4uYsPMecQuK5Qy3147APjCNc-hcXGT71XuBh1AJI2M$  ]
> >=20
> > Hi Christophe,
> >=20
> > On Fri, Aug 22, 2025 at 11:58:06AM +0200, Christophe Leroy wrote:
> > > Masked user access avoids the address/size verification by access_o=
k().
> > > Allthough its main purpose is to skip the speculation in the
> > > verification of user address and size hence avoid the need of spec
> > > mitigation, it also has the advantage of reducing the amount of
> > > instructions required so it even benefits to platforms that don't
> > > need speculation mitigation, especially when the size of the copy i=
s
> > > not know at build time.
> > >=20
> > > So implement masked user access on powerpc. The only requirement is
> > > to have memory gap that faults between the top user space and the
> > > real start of kernel area.
> > >=20
> > > On 64 bits platforms the address space is divided that way:
> > >=20
> > >        0xffffffffffffffff      +------------------+
> > >                                |                  |
> > >                                |   kernel space   |
> > >                                |                  |
> > >        0xc000000000000000      +------------------+  <=3D=3D PAGE_O=
FFSET
> > >                                |//////////////////|
> > >                                |//////////////////|
> > >        0x8000000000000000      |//////////////////|
> > >                                |//////////////////|
> > >                                |//////////////////|
> > >        0x0010000000000000      +------------------+  <=3D=3D TASK_S=
IZE_MAX
> > >                                |                  |
> > >                                |    user space    |
> > >                                |                  |
> > >        0x0000000000000000      +------------------+
> > >=20
> > > Kernel is always above 0x8000000000000000 and user always
> > > below, with a gap in-between. It leads to a 4 instructions sequence=
:
> > >=20
> > >    80: 7c 69 1b 78     mr      r9,r3
> > >    84: 7c 63 fe 76     sradi   r3,r3,63
> > >    88: 7d 29 18 78     andc    r9,r9,r3
> > >    8c: 79 23 00 4c     rldimi  r3,r9,0,1
> > >=20
> > > This sequence leaves r3 unmodified when it is below 0x8000000000000=
000
> > > and clamps it to 0x8000000000000000 if it is above.
> > >=20
> >=20
> > This comment looks wrong: the second instruction converts r3 to a
> > replicated sign bit of the address ((addr>0)?0:-1) if treating the
> > address as signed. After that the code only modifies the MSB of r3. S=
o I
> > don't see how r3 could be unchanged from the original value...
>=20
> Unless I'm missing something, the above rldimi leaves the MSB of r3
> unmodified and replaces all other bits by the same in r9.
>=20
> This is the code generated by GCC for the following:
>=20
> 	unsigned long mask =3D (unsigned long)((long)addr >> 63);
>=20
> 	addr =3D ((addr & ~mask) & (~0UL >> 1)) | (mask & (1UL << 63));
>=20
>=20
> >=20
> > OTOH, I believe the following 3 instructions sequence would work,
> > input address (a) in r3, scratch value (tmp) in r9, both intptr_t:
> >=20
> >          sradi r9,r3,63  ; tmp =3D (a >=3D 0) ? 0L : -1L;
> >          andc r3,r3,r9   ; a =3D a & ~tmp; (equivalently a =3D (a >=3D=
 0) ? a : 0)
> >          rldimi r3,r9,0,1 ; copy MSB of tmp to MSB of a
> >=20
> > But maybe I goofed...
> >=20
>=20
> From my understanding of rldimi, your proposed code would:
> - Keep r3 unmodified when it is above 0x8000000000000000
> - Set r3 to 0x7fffffffffffffff when it is below 0x8000000000000000
>=20
> Extract of ppc64 ABI:
>=20
> rldimi RA,RS,SH,MB
>=20
> The contents of register RS are rotated 64 left SH bits.
> A mask is generated having 1-bits from bit MB
> through bit 63=E2=88=92 SH and 0-bits elsewhere. The rotated
> data are inserted into register RA under control of the
> generated mask.

Sorry, you are right, I got the polarity of the mask reversed in my
head.


Once again I may goof, but I believe that the following sequence
would work:

	sradi r9,r3,63
	andc r3,r3,r9
	rldimi r3,r9,63,0  ; insert LSB of r9 into MSB of R3

Cheers,
Gabriel
 


