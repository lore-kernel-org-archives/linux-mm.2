Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F516CA600D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 19:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFDEA6B008A; Thu,  8 Oct 2026 15:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAF016B008C; Thu,  8 Oct 2026 15:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975D86B0092; Thu,  8 Oct 2026 15:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BA676B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:44:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2BC9A4B19
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 19:44:51 +0000 (UTC)
X-FDA: 85300486782.12.C557AA3
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9E6A21C0002
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 19:44:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm1 header.b=Yd4QAqY6;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="m nWwGmh";
	spf=pass (imf21.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.147 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791488689;
	b=aQjIOqQLa8DNmjYUYFQyYq72xlPWcTlRFsCDwFIomCDT2ODoNXtW7BAgu16DS8EtIMq1+D
	hFsyEsbKMptyv47deWALVkRahMJF0K+EdFFPi96GT/AItaUf4SFCc8aycGpOrylxushJ+x
	0MCh2I1Mf/gx/yI+CxK6CAd1+AAbuOA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm1 header.b=Yd4QAqY6;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="m nWwGmh";
	spf=pass (imf21.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.147 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791488689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COytJpLfs+q/ANG27lRkpZETOhMcSaulKo4H07DhtEg=;
	b=t/8HkI0ZgUfz7hqe0stOVZGG9gTz5PPrDvPQXPldO2S35PVErFNp8aCz7IXT0QQApTJfQ9
	qYOM3FviO0Y0xmvqwf/hTX6xw1zoFdbEv8E9j3DD2Qljqdx2Kc953jB5dGhF8knxKNnc5i
	MdczzmLIKneXmgNxJ1W9zvTa3WHaa+4=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id DA2F91D00069
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:44:48 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 08 Oct 2026 15:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1791488688;
	 x=1791575088; bh=COytJpLfs+q/ANG27lRkpZETOhMcSaulKo4H07DhtEg=; b=
	Yd4QAqY6gBU2/GRz7wfGjPdjewNbKYJ/1L0JjGSRiq83ui33qvzI8/3dKBfhHAy7
	kVO6skNZo582wpgV6WKT3SWemgcNteTRxPaMdxXLTyPwBEPXcQBhJGsJRYzo4U8e
	7p1/mc9cDYTo3hxlToIH1aAHIolnbtMWWgfqQ4G3/4C7b87ws3e5pW9otoG+bA6R
	iNvFL6zFs27vrMv5Ln9Z8+OlPvL5JkS2YwTz8GEcEzzXHTIvbl9Fx4GWnEwV7Zhx
	efdrLI5eWFg1j9x5s1Omd3BfK5McYsNFRCfkBYeaFfrRmTgfbwRKwK05REQxtoPz
	gOHnnpa9tmn5SoOA7opBhA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791488688; x=
	1791575088; bh=COytJpLfs+q/ANG27lRkpZETOhMcSaulKo4H07DhtEg=; b=m
	nWwGmhiVFIDJMKJlqtTbNinmLRFU2bASwwWV2W3RqsE8n7FpGN97v1MsLEgs0PV4
	KbUSE+mUgR+9UE+HYg2uiCbfzO65L0XsDHKHvdSE+297EmejeR0w6Vrfx/x4NHj6
	amf81wTVYDfur84xp+30B3qM+bfOl1b+Sfv43/y34+F+KM2XKpr0V3v0b7XA4LpP
	B9YgOuikSqq5SfA1aNs4m2Kof2WBYxSEJsuUsEqdY3adhgDIghWIriysD4cACI0E
	ktr+rurNbdMpacgZykARz9ZMLcQCBMYXeCTVtexMeMWe/5gY9naqnD4XZ5J1N/pa
	kXRk71wUi7BjLaWzjw83g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=shazbot.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791488688; d=shazbot.org;
	mf=PGFsZXhAc2hhemJvdC5vcmc+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:XwspqFYLk9knpIL60eJ2sH3sZBCyBO6CzXOfHslwpSqnXIt
	UAq89PgwSPzBUVaCGv2Rs/G56MmzM9VVEImLvfq24zSdvF7V1a4ODI0sU9H6tnfI
	d+3+CtCepae/sUQQ7tBwosSDGCML7d1/2OTOb2WA2JroQ4jrB1rPdAfrLE4IBhwH
	NRTnTypKfTAMwCh08BpRERw9KaufvUid83J6EltxnyCdeeHqAkZC/d4IN/MlzAv7
	DSozb206nAOK8qSbRa9gBvqeAjxE7I7QVo+3YkebKvtt/GCyxLSZoMcg8nqdHtEu
	+uw7SG3vfmtsS5FW7nURb0de6iX49CQZggF+2pQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:33lYGRPjDKHv1HdyBDP9qbGPZW0UEmW2MBctLU/6GRQ=:1wyXoLopt8mogJZCTk37mCSIjObCu8f/3SbMW0aAY+k=;
X-ME-Sender: <xms:rvLHapX8Ta3ICwjcfGKXoroYrgkEjUvRPNoqfzn8UTdPOdljukjlRw>
    <xme:rvLHasYUP3Y4CfMOMPIePjx_wDd35XsiQxksT7ifX8y3OF35mtYvIL77ztQR2CHRS
    d5L2n7KvgNDl1t_SyRMEFz8279hHIO78OPdd6y1-AQLzIRUoD8TqYw>
X-ME-Received: <xmr:rvLHaoLFgCGgX5GhiafQ9rIApRowtdeTskaSBXIZcDxIL2ZX_-wHL8Fy58Chjw>
X-ME-Proxy-Cause: dmFkZTGbNECeNSQbpccY9nurK7QOA+b53gWRmUKrsbFi8+XR9mJHjpIrTJB25Glz1+iUcB
    +TjMohUqHZ1Pk8da8eGkz0KQNksM63CrCN74CmM4nOAa+ZrJ7C36t4tGkozpgS9N2RgvD0
    z3tyPfoLYnDB/MoIxqrShAyrSvX3DOlt0VoRgc0WvbPLIAL6bzLygEFA3ox5ylqaQke95Z
    ZoKuwGR/0+I0aMKxwxyZA3oH9Kx5wxomcRtN5c8bgUbvVhRqU3fjiu8pKRa9SyOmJaxoJC
    tdH10VymMH2F6cnjhN474fKqJKIBZUpiRuqk03T0WBlMnFptELFKI5N2XCxLr3pC59DgFR
    XwxbqiRbkNTiVkaFkl5HwRZFGbYIxsGRLLvr6Y2dMTt7G+uekh+MtEQRe/BdVN341EenhY
    cfiOUCLi6DGt4ubKnU+xEw7t+q5nM4qn2/C+v76dkVoKolggrdKK6l8n+Cg2444Vaomj8w
    7JdiTaZElhDArafApVwSfaER7SIU24PaiOlx5McVyLVNKVgXipJZ5+t4WFe2JVmQP6VqTp
    sL3/ccwYUbzuX22UKg00UAG2wb5H1CTRwEZWAg8NkzjjkU3n0TCTpusukHzle33j5fhlIb
    FJasCG5AsRk/Tj6JzKhPZ11Qhj/XS0YL4nkPeEmai2ZFAawLeglDP72JERpQ
X-ME-Proxy: <xmx:rvLHav0T5PK1_JlO2V5hcqalamEt7l05kJHFz-Nxsv3BzMGpoBQDfA>
    <xmx:rvLHauhm7G1CO7VKJKGvjI9bibjkm3fQTQ5ckBRVY4YjHRC3rTyBtw>
    <xmx:rvLHamyDzhoMpF3hT-aXE_iVZT6XvgaUfiUwb9VkdWknWR2bhVXsZw>
    <xmx:rvLHarFspBpbK7Shz3TfXfg0W7Ekho4iPqPijhnxYiIz-22BBjVmsA>
    <xmx:sPLHahEb0GocregFs4WRKKEr3D1YbybAGU5uu3zIEU1jQdbdljra1JJL>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Oct 2026 15:44:33 -0400 (EDT)
Date: Thu, 8 Oct 2026 13:44:18 -0600
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>,
 Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>,
 Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
 Yi Liu <yi.l.liu@intel.com>, alex@shazbot.org
Subject: Re: [PATCH v9 08/13] PCI: Save and restore the ACS Control register
Message-ID: <20261008134418.426c3d72@shazbot.org>
In-Reply-To: <CALzav=eTrH4WNPYNWAwmYSEw_imOXwRqf9y7zPDmC27dVE0zBw@mail.gmail.com>
References: <20260918200640.887030-1-dmatlack@google.com>
	<20260918200640.887030-9-dmatlack@google.com>
	<20260918191846.2f68b23b@shazbot.org>
	<arGVMaxfwEw_PkXy@google.com>
	<CALzav=eTrH4WNPYNWAwmYSEw_imOXwRqf9y7zPDmC27dVE0zBw@mail.gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9rk99jk7ftx1wuy6swks4m9oqdgn6pfa
X-Rspamd-Queue-Id: 9E6A21C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791488689-544507
X-HE-Meta: U2FsdGVkX19lW9pxZfcpQ7jMATTfcE8MKoZhFK0vhsk1TcwEDzbcXWARK/iM2w22aKrtjLXzZBq1hqeu5tubfXbARp3gRceogtWfsaE+RsRZ0CSxR0Kb/IdmqpljeTt8bcGGqa7j+q9ZrNtYJWu2EEdzH5cggSCCZJunOCYJUFCQSobovhOr0wcU3J9JvpS/GGfhbUCBlzdKoZzoQOxPlyNDMPzsK1B7onia+qzeAglUaYfdiy9LDCxhS1oZuvVWr+ejKErpz6pEpj5BGwGY7YJPy30iIdhwCKuPTvsKAqnrNsesxf6nlwESN5t1nhcvgWNGNkc47xQgevr9/eQU+gBAd5xD3WexUucztGFU4yWv2fXSJZhbsW3cRSgrfXi4M8c38Fk9g3t9M9iz5ZsdB+0qpe+z8vZt0baX/RcIcLgpo59/MP09WVN3G06ulURxi7QOU+T54ymXYgc0l7aXR1b9HNWclxAtNNcP+blXI5qXabo9MUiWsyN5yrFtwqcLs1da7dNnm2XYS8cGx4o1bloLPcEzRE2ygrqTKrxFAWaktp9G1O06cjlk5HkohGPQSfKn01d8k1gI20DPPJ7gbdxJqJJvlqTCg7OUysN8tRExDHbIAtJuAs8h0SbYKAWcu1uddiaj3JQ1pJU2askyXxOjWfy67P8F+CrtAJ4u+EB8wZD/ouVUDFdaA/1DDuQUpwUXbynerc60ZLpiTz9MiQgEbdii4Vp0Xnt1i+om1JulQB8a9mS/TeizTsWBlgvaX7knLj+W8Lc1jr79/EL875+Gct938ROpLAzQbH+Un3Kkqi5Ha6fEUEGTxfbsRWdM1EgZE3VI6XLGqbKle9AQaLdwdZ7pNe9pzTHJXKBz/AMg322wPgyKml5B2JdVGToqvHmxLQ79yqGXZMm6vQ+Kgx68t22J2Fo5vxMoX5JmIcFp97xXJwTkF0/oux7B3Sxs7y+xCEB51iyrUCk3Qua
 Y2T4pZkD
 72z41y0rSZ4berJ8Eb39sOcAgoY4XE8yzZlCciFcUhnIS7DKzUbJxD2Dfl3cu0914JDi2lD7EtKl7VkfVnYsdMZjvvJM7DTAcIOiQeaf8sJNfU2svxHWBZL3zUAFQ8eUTjGvOBjZ1pt5eXPSPitxNPlpS/gYUp/x1BgJPtl6ScQOYfDm+YETIbFSOTbjwdsAydym52tYovRN/Ub+xPXf49Oyrse7O+KYHAsnJNXcmFMr6mTH9MXu25mrRZV1yohcD8GfkS3w37yIMQHbQDDOTxCsWUPhXiio+86+gSCtsh/m307J+flJsV5PezmacFtvw3qEd56xrSqZ/os3SMkM8y7HNPGfI6hhUDX0JI9V7+QeU3VzOshiJJhTNMXu3mVKWZOwc7YYZDNLeD32CFd2W2ngDHWrSdJxTkYnRswHpOeJyk7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 7 Oct 2026 02:20:16 -0700
David Matlack <dmatlack@google.com> wrote:

> On Mon, Sep 21, 2026 at 1:36=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > On 2026-09-18 07:18 PM, Alex Williamson wrote: =20
> > > On Fri, 18 Sep 2026 20:06:34 +0000
> > > David Matlack <dmatlack@google.com> wrote:
> > > =20
> > > > Save the ACS Control register in pci_save_state() and write it back
> > > > in pci_restore_state(), instead of recomputing the ACS controls from
> > > > scratch with pci_enable_acs().
> > > >
> > > > This makes ACS symmetric with the rest of a device's saved state. T=
oday
> > > > pci_save_state() ignores ACS entirely and pci_restore_state() re-en=
ables
> > > > the ACS controls from the kernel's current ACS policy. As a result,=
 a
> > > > device can come out of a reset with different ACS controls than it =
went
> > > > in with, e.g. any controls programmed outside of pci_enable_acs() a=
re
> > > > silently dropped. =20
> > >
> > > Controls, yes, but if we're restoring controls that might have EC set
> > > now, should the Egress Control Vector also be part of the save state?
> > >
> > > Currently EC always gets cleared on reset and won't be restored by
> > > pci_enable_acs(), so we can lose both EC and the EC vector.  With thi=
s,
> > > I think we restore EC but still lose the EC vector.  Thanks, =20
> >
> > The kernel does not enable Egress Control today or program the vector.
> > Would this be to cover the case where firmware or userspace enabled it?
> >
> > Here is an updated patch to save/restore the vector, but I don't have
> > any devices that support Egress Control on my normal testing system so I
> > haven't been able to really test it yet. =20
>=20
> Hey Alex, gentle ping on this.

Sorry, I had missed the reply, thanks for the ping.  Saving the full
Egress Control Vector would mostly be for configurations where it's
enabled by the firmware, similar to virtual channel.  Honestly I don't
know that anything pre-programs it, but handling it now avoids the
issue entirely and also handles any future work to add such support in
the kernel preemptively.  It's the sort of thing that might otherwise be
overlooked.
=20
> This series is merged into the liveupdate tree to get linux-next
> exposure ahead of 7.4 merge window. If this patch needs a respin or a
> fixup I'd like to get the ball rolling on that.
>=20
> I think the 3 options are:
>=20
> 1. Keep the patch as is based on the understanding that the kernel
> does not enable EC today or program the vector.
> 2. Save/restore the EC vector (the below patch).
> 3. Clear EC on restore to preserve the current behavior.
>=20
> And if we decide to do (2) or (3) then that could be done with a
> respin of the patch ahead of the merge window, or a fixup patch on top
> to send in a later rc.

It's not complicated, I don't see why we wouldn't just do (2) in the
first pass.

> > From: David Matlack <dmatlack@google.com>
> > Date: Fri, 11 Sep 2026 20:05:04 +0000
> > Subject: [PATCH] PCI: Save and restore the ACS Control register and Egr=
ess
> >  Control Vector
> >
> > Save the ACS Control register and the ACS Egress Control Vector in
> > pci_save_state() and write them back in pci_restore_state(), instead of
> > recomputing the ACS controls from scratch with pci_enable_acs().
> >
> > This makes ACS symmetric with the rest of a device's saved state. Today
> > pci_save_state() ignores ACS entirely and pci_restore_state() re-enables
> > the ACS controls from the kernel's current ACS policy. As a result, a
> > device can come out of a reset with different ACS controls than it went
> > in with, e.g. any controls programmed outside of pci_enable_acs() are
> > silently dropped.
> >
> > Notably, this prepares the kernel to be able to adopt the ACS controls
> > established by a previous kernel across a Live Update rather than
> > assigning new ones through pci_enable_acs().
> >
> > Save and restore the Egress Control Vector as well to keep it in sync
> > with the now-properly-restored Egress Control Enable bit in the ACS
> > control register. The kernel never enables Egress Controls or programs
> > the vector, but the firmware could have and they need to be kept in sync
> > to avoid changing how P2P traffic is rounted.

s/rounted/routed/

> >
> > The size of the Egress Control Vector is not known when
> > pci_allocate_cap_save_buffers() runs, as the ACS Capability register is
> > only read later, in pci_acs_init(). Rather than move the allocation,
> > size the save buffer for the largest vector a device can implement,
> > which costs at most 32 bytes per ACS-capable device.

The argument that the size isn't known isn't really true.  The egress
control vector size is a hwinit field of the ACS capabilty register.
We could just read it from the register during both the save and
restore, much like we rely on similar hwinit fields in saving and
restoring the VC capability.

Caching of the ACS capability was added in 8f05a5f6745c, and while it
mentions that it removes some duplicate re-reads, its primary purpose
is clearly to be able to quirk out misreported capabilities.  Maybe a
better option to avoid the egress vector size being cached on the
pci_dev would be to only cache the lower byte of the register.

> > pci_enable_acs() runs when a driver binds to a device
> > (pci_dma_configure()), i.e. after pci_bus_add_device() has already saved
> > the device's state. Refresh the saved ACS state there as well, otherwise
> > a subsequent reset would revert ACS back to the configuration left
> > behind by firmware.
> >
> > Devices that rely on device-specific quirks to enable an ACS equivalent
> > keep that configuration outside of the ACS Control register, so keep
> > configuring ACS from scratch for them. Do the same for devices that have
> > no saved ACS state at all.
> >
> > Assisted-by: Claude:claude-opus-5

Nit, I've been letting things already on the list slide through with
the explicit model reference, but note that since 816d9992d9ed the
recommended syntax is just "Assisted-by: LLM" (plus other tools as
necessary).  Thanks,

Alex

> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  drivers/pci/pci.c             | 117 +++++++++++++++++++++++++++++++++-
> >  drivers/pci/pci.h             |   5 ++
> >  drivers/pci/quirks.c          |   7 ++
> >  include/uapi/linux/pci_regs.h |   1 +
> >  4 files changed, 129 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index b2879a6be5f8..e1c05866e2ee 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -1021,6 +1021,106 @@ static void pci_std_enable_acs(struct pci_dev *=
dev, struct pci_acs *caps)
> >                 caps->ctrl |=3D (dev->acs_capabilities & PCI_ACS_TB);
> >  }
> >
> > +/*
> > + * Layout of the ACS save buffer. @ecv holds the ACS Egress Control Ve=
ctor and
> > + * is sized for the largest vector a device can implement.
> > + */
> > +struct pci_acs_saved_state {
> > +       u16 ctrl;
> > +       u32 ecv[8];
> > +};
> > +
> > +/*
> > + * Return the size in bytes of the ACS Egress Control Vector, or 0 if =
the
> > + * device does not implement P2P Egress Control.
> > + */
> > +static unsigned int pci_acs_ecv_size(struct pci_dev *dev)
> > +{
> > +       unsigned int bits;
> > +
> > +       if (!dev->acs_cap || !(dev->acs_capabilities & PCI_ACS_EC))
> > +               return 0;
> > +
> > +       /* An Egress Control Vector Size of 0 means 256 bits */
> > +       bits =3D FIELD_GET(PCI_ACS_EGRESS_BITS_MASK, dev->acs_capabilit=
ies);
> > +       if (!bits)
> > +               bits =3D 256;
> > +
> > +       /* The vector is implemented as a series of DWORD registers */
> > +       return round_up(bits, 32) / 8;
> > +}
> > +
> > +/**
> > + * pci_save_acs_state - save the ACS Control register and Egress Contr=
ol Vector
> > + * @dev: the PCI device
> > + *
> > + * Record the ACS configuration currently programmed in hardware so th=
at
> > + * pci_restore_acs_state() can reapply it after a reset.
> > + */
> > +static void pci_save_acs_state(struct pci_dev *dev)
> > +{
> > +       struct pci_cap_saved_state *save_state;
> > +       struct pci_acs_saved_state *acs;
> > +       unsigned int i, dwords;
> > +
> > +       if (!dev->acs_cap)
> > +               return;
> > +
> > +       save_state =3D pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
> > +       if (!save_state)
> > +               return;
> > +
> > +       acs =3D (struct pci_acs_saved_state *)save_state->cap.data;
> > +
> > +       pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &acs->ct=
rl);
> > +
> > +       dwords =3D pci_acs_ecv_size(dev) / sizeof(u32);
> > +       for (i =3D 0; i < dwords; i++)
> > +               pci_read_config_dword(dev, dev->acs_cap + PCI_ACS_EGRES=
S_CTL_V +
> > +                                     i * sizeof(u32), &acs->ecv[i]);
> > +}
> > +
> > +/**
> > + * pci_restore_acs_state - restore the ACS Control register and Egress=
 Control
> > + *                        Vector
> > + * @dev: the PCI device
> > + */
> > +static void pci_restore_acs_state(struct pci_dev *dev)
> > +{
> > +       struct pci_cap_saved_state *save_state =3D NULL;
> > +       struct pci_acs_saved_state *acs;
> > +       unsigned int i, dwords;
> > +
> > +       if (dev->acs_cap && !pci_need_dev_specific_enable_acs(dev))
> > +               save_state =3D pci_find_saved_ext_cap(dev, PCI_EXT_CAP_=
ID_ACS);
> > +
> > +       /*
> > +        * Devices that rely on device-specific quirks to enable an ACS
> > +        * equivalent keep that configuration outside of the ACS Control
> > +        * register, so there is nothing useful to restore for them. Co=
nfigure
> > +        * ACS from scratch instead, which also covers devices that hav=
e no
> > +        * saved ACS state at all.
> > +        */
> > +       if (!save_state) {
> > +               pci_enable_acs(dev);
> > +               return;
> > +       }
> > +
> > +       acs =3D (struct pci_acs_saved_state *)save_state->cap.data;
> > +
> > +       /*
> > +        * Restore the Egress Control Vector before the ACS Control reg=
ister.
> > +        * The vector resets to zero, so enabling P2P Egress Control fi=
rst
> > +        * would briefly apply the reset vector instead of the saved on=
e.
> > +        */
> > +       dwords =3D pci_acs_ecv_size(dev) / sizeof(u32);
> > +       for (i =3D 0; i < dwords; i++)
> > +               pci_write_config_dword(dev, dev->acs_cap + PCI_ACS_EGRE=
SS_CTL_V +
> > +                                      i * sizeof(u32), acs->ecv[i]);
> > +
> > +       pci_write_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, acs->ct=
rl);
> > +}
> > +
> >  /**
> >   * pci_enable_acs - enable ACS if hardware support it
> >   * @dev: the PCI device
> > @@ -1057,6 +1157,15 @@ void pci_enable_acs(struct pci_dev *dev)
> >         __pci_config_acs(dev, &caps, config_acs_param, 0, 0);
> >
> >         pci_write_config_word(dev, pos + PCI_ACS_CTRL, caps.ctrl);
> > +
> > +       /*
> > +        * pci_enable_acs() runs when a driver binds to the device, i.e=
. after
> > +        * pci_bus_add_device() has already saved the device's state. R=
efresh
> > +        * the saved ACS state so that a subsequent reset restores the
> > +        * configuration programmed here rather than the one left behin=
d by
> > +        * firmware.
> > +        */
> > +       pci_save_acs_state(dev);
> >  }
> >
> >  /**
> > @@ -1800,6 +1909,7 @@ int pci_save_state(struct pci_dev *dev)
> >         pci_save_aer_state(dev);
> >         pci_save_ptm_state(dev);
> >         pci_save_tph_state(dev);
> > +       pci_save_acs_state(dev);
> >         return pci_save_vc_state(dev);
> >  }
> >  EXPORT_SYMBOL(pci_save_state);
> > @@ -1877,7 +1987,7 @@ void pci_restore_state(struct pci_dev *dev)
> >         pci_restore_msi_state(dev);
> >
> >         /* Restore ACS and IOV configuration state */
> > -       pci_enable_acs(dev);
> > +       pci_restore_acs_state(dev);
> >         pci_restore_iov_state(dev);
> >
> >         dev->state_saved =3D false;
> > @@ -3532,6 +3642,11 @@ void pci_allocate_cap_save_buffers(struct pci_de=
v *dev)
> >         if (error)
> >                 pci_err(dev, "unable to allocate suspend buffer for LTR=
\n");
> >
> > +       error =3D pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_ACS,
> > +                                           sizeof(struct pci_acs_saved=
_state));
> > +       if (error)
> > +               pci_err(dev, "unable to allocate suspend buffer for ACS=
\n");
> > +
> >         pci_allocate_vc_save_buffers(dev);
> >  }
> >
> > diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> > index ba3c3fddddc2..037c1674f164 100644
> > --- a/drivers/pci/pci.h
> > +++ b/drivers/pci/pci.h
> > @@ -1095,6 +1095,7 @@ void pci_acs_init(struct pci_dev *dev);
> >  void pci_enable_acs(struct pci_dev *dev);
> >  #ifdef CONFIG_PCI_QUIRKS
> >  int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
> > +bool pci_need_dev_specific_enable_acs(struct pci_dev *dev);
> >  int pci_dev_specific_enable_acs(struct pci_dev *dev);
> >  int pci_dev_specific_disable_acs_redir(struct pci_dev *dev);
> >  void pci_disable_broken_acs_cap(struct pci_dev *pdev);
> > @@ -1105,6 +1106,10 @@ static inline int pci_dev_specific_acs_enabled(s=
truct pci_dev *dev,
> >  {
> >         return -ENOTTY;
> >  }
> > +static inline bool pci_need_dev_specific_enable_acs(struct pci_dev *de=
v)
> > +{
> > +       return false;
> > +}
> >  static inline int pci_dev_specific_enable_acs(struct pci_dev *dev)
> >  {
> >         return -ENOTTY;
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index 7aee30734303..e500c202d2ec 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -5476,6 +5476,13 @@ static const struct pci_dev_acs_ops *pci_dev_acs=
_ops_get(struct pci_dev *dev)
> >         return NULL;
> >  }
> >
> > +bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
> > +{
> > +       const struct pci_dev_acs_ops *p =3D pci_dev_acs_ops_get(dev);
> > +
> > +       return p && p->enable_acs;
> > +}
> > +
> >  int pci_dev_specific_enable_acs(struct pci_dev *dev)
> >  {
> >         const struct pci_dev_acs_ops *p =3D pci_dev_acs_ops_get(dev);
> > diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_reg=
s.h
> > index facaa324bd86..66359cb94f0d 100644
> > --- a/include/uapi/linux/pci_regs.h
> > +++ b/include/uapi/linux/pci_regs.h
> > @@ -1023,6 +1023,7 @@
> >  #define  PCI_ACS_UF            0x0010  /* Upstream Forwarding */
> >  #define  PCI_ACS_EC            0x0020  /* P2P Egress Control */
> >  #define  PCI_ACS_DT            0x0040  /* Direct Translated P2P */
> > +#define  PCI_ACS_EGRESS_BITS_MASK 0xff00 /* Egress Control Vector Size=
 */
> >  #define PCI_ACS_EGRESS_BITS    0x05    /* ACS Egress Control Vector Si=
ze */
> >  #define PCI_ACS_CTRL           0x06    /* ACS Control Register */
> >  #define PCI_ACS_EGRESS_CTL_V   0x08    /* ACS Egress Control Vector */=
 =20


