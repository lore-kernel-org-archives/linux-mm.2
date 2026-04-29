Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6372FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 22:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69F16B0088; Wed, 29 Apr 2026 18:57:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF37C6B008A; Wed, 29 Apr 2026 18:57:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94146B008C; Wed, 29 Apr 2026 18:57:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B36FB6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:57:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 632548A5E0
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:57:15 +0000 (UTC)
X-FDA: 84713106030.20.B2C7DB3
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4DFAA4000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:57:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DjdfGiuk;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777503433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5PgOh4MKm9Ysku8H251/i15pXVhU7vwYYgGQfsH0l+s=;
	b=PiKd42F8/xYwh1xF2+n7YQ/W1J66R9taX/v1CxYykd2VO+ED3bFDUV3OegOVm6apcM5EL+
	FvOPze4EqEb/d9u9bbD02k3jScuBS1ukd2wRN8re74VerlEzBAjit0fLgl6MkOTOKuhCsR
	Iq8g2MSJ4thFrDcnuvSuxR0QnXlH2vQ=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DjdfGiuk;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777503433; a=rsa-sha256;
	cv=pass;
	b=j/fO7FmS3636eeqI0aDyufA0a4NEd/zzHLkwnQ263YGbIHMEaC+LidqmhqSu8xqkjM5EOj
	vF2zcCycAKq2ZBcTbjoyjS9J2Ibuvt4FHp2pnrwcJPkocZJ7gVAPZc5JyPkpvIaLurvq6N
	aU3p/+rN9q3SD0Zs7iv0I0cgMYRvUNk=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5a3be187ffbso1294852e87.0
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:57:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777503431; cv=none;
        d=google.com; s=arc-20240605;
        b=T43n3WwtDqmr1TKR7FCEJDCdmeDgYS+C9Kyk4p9uidCKfkQ8xJc1ytEkp2WBYp7+hd
         fJRTy2Gg3tfGQOpjx3tIGb4xYyYoUKPAnbmnsOSeT2+vBw8BO5lURmTfLKSycJCIG7mt
         3p/XIkHN8MLr56zQJo4YLVTxCYs3cSrcn7xrX5z3gYB23S45P3QWSsi+/86pcLT2BPzA
         pK09UukvCRBfqhLNDroMmXjIUi1HDk3BakS8klzXj5iCAf+Srywb9dyw3+qLk9PMDpZg
         VJTV/FjoWROEW5BaCBZpRe39w1k3Kj8OpptMRUpc6PHw27VKRENUFBgMo0575ZR2SpYf
         evVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5PgOh4MKm9Ysku8H251/i15pXVhU7vwYYgGQfsH0l+s=;
        fh=aAtNg/De0p+eFe5jGo3sPznJmZ7k7T0MBHYnaxO8MUM=;
        b=lpB0VzP0eeKuo5CbcthRZWfCwIQ9cOnXBKxBSkwzyyNwJADlKK89Fzp/4tviWy8A1z
         I0LlelOJN/iucYiZ6JvbVFsCUXMyhZI8PkVwY/cOq0VTPJWO2zE8Pi51Bwh6/retfqSm
         rDB0hHh1agMaFM+Ts8xmLpckJkrzjYNIwQTr0MBSM4L8ZuTZZpxISAcIOAMgvnPrJf/o
         hXIfRc+1mbSvmu2e1rrkr3JwLqbwAtRLL7M7UxujCDPyIuhod1jQwd8+6cWV6gQIAScA
         FLYyAt+URXFDNAmGQ/IRScwmJq9C9SS43z41RyTA4QKhV5PoavvfR/nRROY/PRJ4TGLu
         E26g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777503431; x=1778108231; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5PgOh4MKm9Ysku8H251/i15pXVhU7vwYYgGQfsH0l+s=;
        b=DjdfGiukRi5kPyPiTZYAUqTiIRwMjM4+6yTxtrorSBBUBP3J9kGsYTi9T/69AWlp+s
         /v1LquWVNtDKNh/WK9zIRgn7pTfse0L7t0Cv5VQ90WIWg12/m6UdCoa20eMkhYM10ZIK
         W3dr3xwnWfg2NKfYicRZIYoJ6s9/M4zg/XYP8o0PRxRKZ3hrcKedPptdPg7KZjpg+PeW
         v78z3cYdeC2eKFPn8F8dvQHqJhEMmuqtLv4NdV6dXJqFsyrliidWItTsAR1NMJc28Qrp
         4amCrMF//pWTXU0TekOsIBH9y2g4OQNcrUjI/TtL1daqlJA9yE3fIUdm6lbo4sN0pd/X
         OCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777503431; x=1778108231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5PgOh4MKm9Ysku8H251/i15pXVhU7vwYYgGQfsH0l+s=;
        b=J3Zh4icFLAfzixYP7RhvxFjgjSLMv9dqABkzFuSyrVY2hsk61O7Urkedd1q5imGoUn
         8mjjibvrei6XxJQhHwD0hi74QYib24CodritnITdkqKdTrx1OyBTKDnLpBfma0XLECQ9
         IkkpIyL4df483bcpFM4jS7qfEkWOLiD6zM/7/afDDcHXCxK1KPJefBHFd41jMWEAP4OS
         pAFbb4BFbH8EbQ8jEMRZE1CCHoa8iNHsIl02UitCgmcmtlZmaQkwZGpgXaP2lTHeQWpH
         NnKyHmnwH+IJ3g/qGmEKUfYj8xTpAO9UJZln94d3Ob7Lf4PcOk3SMzp4kc0pNSlhiVRN
         9H/w==
X-Forwarded-Encrypted: i=1; AFNElJ/aiyZkXXQF4NG8lCDYeprfAi/bbx9xxWMM+CuP5KtuySspKiOcENebORaBvaZf1S+Jzx2k+o6HsQ==@kvack.org
X-Gm-Message-State: AOJu0YzR6662ZOAT4xJxW2yB1iFzfcXxQ62u0jO1jDTRdQWfIOl1zVSj
	w7rsLDkzY7arRPQI7nVjg0z1QQIu8TsfjxgiaSMHjiyFER9jnA7JZOsK3wR24q4IBv2fQafkV3y
	q+BGQQreKXK09/KgT/qo+FwpIve77DfVeBLgT1fKy
X-Gm-Gg: AeBDieve/XhyP1TxM5wh7d1KeMR8JLtZ/s0IColYAZjyUEIZUijzpnbxCf1aVBRNKO+
	/LIDcYSDhszyQxCr9WR1AF5dX7OdcoLitEOdVyyvbo/tJTt0E7xusmynp3AbPw5zpS+9xVVKByX
	Cme2Wo64ByJgk8sL0yABG+3roEVgb3sBJDOxgGmT/lZPN5Q+sn+B76T7MsEH7U7LzpqqG8qE5pu
	8aadcUmodsOiWp3GgnAhlA8OfSbWf7/tw560vx6NFMKy9pVtGh8sxCYMvf62w9/KVGCDPJLCqaf
	AGoezrocxADSVbttmhmIpzwswEK1Nw==
X-Received: by 2002:a05:6512:1148:b0:5a7:4912:1a50 with SMTP id
 2adb3069b0e04-5a852741d7amr22979e87.20.1777503430946; Wed, 29 Apr 2026
 15:57:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com> <20260423212316.3431746-6-dmatlack@google.com>
 <20260427114745.00000656@linux.microsoft.com> <ae_J2pRWFf5qjZXb@google.com>
 <ae_SHCjNGrEPurzH@google.com> <20260429152814.000005f7@linux.microsoft.com>
In-Reply-To: <20260429152814.000005f7@linux.microsoft.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 29 Apr 2026 15:56:43 -0700
X-Gm-Features: AVHnY4Le9iheFK_YlZgcrAybDAS1kEhRs6kG_ymy3g2e8lI5OrgvcncvoFuHHPU
Message-ID: <CALzav=djG6T_NfwDD+aoobMfqdCkG0Xo8hHU2YkPc20uJdb-qw@mail.gmail.com>
Subject: Re: [PATCH v4 05/11] PCI: liveupdate: Inherit bus numbers during Live Update
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4DFAA4000E
X-Stat-Signature: 5f7pb5nstuanigy99hctiijz89ei63dx
X-HE-Tag: 1777503433-459672
X-HE-Meta: U2FsdGVkX1+glT1i7hsNU1ZaPQrbe2TStF3B5EwvDMCsyarSwUTb4hWbx18BUsLhTppDgXY0zmlYmFuDi9Nzus7SUMCdasYX4c/OphztC5KzgIpn2Y7dhrKvMApPVRvEyo/R4ruqbz5l8ijlwouwqXHKAfjaE9rLzcHfQAreRRyGL0fo+1Upm7xPKiOntQlhmc/r70GXk1JVx6K1oLLC3Ohvad6QejDQnWtv0ssTG5as10eJgP9RAeYQumSVyh4Jc/loGFYXehUGtF0RDG++v6A+3OK5I63AaHi/PihYJdACTgPsHfoDKLsTjVoUyvHqdGKnSAKs3a33tTCsGVZptQiMkgwpDU7wgmPp1P6AlOFC5stUzfSIScsPk74Iv8BUBtnAiRsyc+/JR//VhjQF3zvZvOl44qqw3FkVfu3H5RW3+7tOfbsrIRgkDLBa4EFZmmgT2vsrwJplSnI0f6wt9dt0qgXQijOk5aXaLiv/l9bs8ZKriHbORTGh7gnRsIkJALuyNqvCM0qgDS18S/nfCxlFlyCrBPIoi0o/7yJ00T1OmLyo4MyekdU56nLN18TGc4jkvr3PcUgF75Iyrn1DnOQO9TzKYFkzzckIjzSguml+XrTDSnuDv0aAXVnRvEiNu9zOM5qlYAJGMPsZ93J7Cv8AEA7y9enzMdRdiWQbZTfi4/OqPtuJMwVeGqDMHMYsImXQfeMNDEXU83Mulp6snUXJ2e6ht+cvkVKGhtoEcCj1DNX0ahHI7S4w23QGWjyY/bc+ym+woWngZG/j+64epaghmAL0uO0x8M9Tkb1ggoX6FK1KeB1uiqND+LMxSYI8GM2OxG2/BNshDYlggw+F73yt4m70HNoHK6Du+3iIzBIqX3K/HOk2bGaQvLLZJ2xzcPHyEGRe+RcsK0cHBqdrwwYZqQam9QIKvTZO0+5w0X0e1dALq7IQUX0mRy38IpNZJ8cqeEoWguN3X/uGRRE
 cdInqZ7g
 2+WQi4squzyoNaF5+oL29jnlDlnuzWVP3ddL3miSEROhsXeUC7uvpgZ5xyoURH/to0YF6K1YrokCEJr2TZ0/gtgnIH15oXYIa6g5dCdy1680lsjpTBiNKSTUODciQvv4weSRoxD6NCgUCvJM9QP4fPu1BSFFFv1UyIndaL+nY1RoMLyEND+spQP9o09I9RssbbjAOIBqVo2I7kMwWPvDCSKBqUbM3zhvxF7RRm4jWqapR67ugeNRkLmTfnGDxNaLYCLdMJG6rUx3xt0SGG96/3ulVXGQs3pqlm0B5/+ZJq3ELzzsdLYn6e4DtzEAyShKfXZPo+5IPNy0knLECXBicuuO7pCuH0K92S+9G8ExYhdQraBcnXJKZIVBcpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 3:28=E2=80=AFPM Jacob Pan <jacob.pan@linux.microsof=
t.com> wrote:

> Below looks correct to me, but I have another question. How do you
> stablize PCI BARs? PCI BDF stability does not guarantee BARs don't get
> moved, right?

That's right, this series does not guarantee that BARs do not get
moved or sized. For P2P use-cases, we do need BARs to remain
stable and avoid sizing during enumeration. We also need to
ensure bridge windows are preserved.

My plan is to send another series to ready the PCI core for P2P
use-cases, sometime after this one.

