Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6262CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9AF16B008A; Thu, 28 May 2026 03:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72296B008C; Thu, 28 May 2026 03:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF836B0092; Thu, 28 May 2026 03:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C84246B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:11:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B06A161E2A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:11:05 +0000 (UTC)
X-FDA: 84815956890.14.23C9760
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6DCDEC000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:11:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JQhU+SWz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779952263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGwPmErgfHqXdHhan9u0w7llgdjcFzdocpty0If0C+c=;
	b=G0E3jbVURKUdMFSRkm/7IBZz3JDwIe16o1poTilaC3Ta5UKeltJGy5mN+kcVK9l28O9Afy
	V883kgjeDtHZOusD8egATPRpacmSMhNpY7AO7glDedzxqkDfafDabin13KnRZN9OBsadLc
	+/m4MZIxwJpFmI06HBdbCcLpFjfeCPA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JQhU+SWz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779952263; a=rsa-sha256;
	cv=none;
	b=BglCuIOav0QPldleiLi8W2J1chG1llAdbU3aAv27UcQ+WoKbRsUzR0sG67qT61PzU53kWp
	JeE0ppyTUbD9GJa4iG6Eo27M6K0wZD4OFx3I9xYZyrUuCDYxmTzPaJUDjqMwS/x5F5cyUx
	N8RyJi6ScRhvs/LoVTwmCN1kIquYELg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 785A640639
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB4C1F00A3A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779952262;
	bh=AGwPmErgfHqXdHhan9u0w7llgdjcFzdocpty0If0C+c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JQhU+SWzHpB8xcXMX0yFFWRPyIp/g7f2ZZhnViWIFBX4hoeifUf7bPWSNnJhQO5EN
	 +HvvvEYxFPrtgprz4FIDdbgmDZlqJSld6dYDVoXOUn0u4i6GvVRMCffN82g8DAFZMT
	 jnEpoGzTOQrObiAO/VjGXAIAlXAzbb7MvEYnNJwOYqL7ueVCexDVGFHCHs8zQLWGTs
	 RWs0EjnZsnSM5Mh6a/BWZhMENHOA1LqYZ5NS5NJR9ehSm8x1/CM/Xo83PsrYfoby0P
	 xLMnKNAb2plP39T2TAZkcQia4wVpFC2h8GNszgqzOds2rV3Zh5s+8bvW9sJxAm5yvg
	 cKk3wAV5T6flQ==
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-65c0bda7f15so12417958d50.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 00:11:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9q5XNml3YwV28rzPATEWL9HL5HDKxSlLNV6tHDn3QTQLkxEyUBWcRI5uOi7QIonN37Oom6O+xfuQ==@kvack.org
X-Gm-Message-State: AOJu0YzbPlT/aAm+OkciHEn+zVPIFIHMVlDmROaor9P1hFxckacMoW9b
	JCagBEY45q7ABVeXNqR4hnoPbJ26EWgnh6Y0FwPyd5vn7BgA1fP0+0hrCvOkOz/HQgUZ/HWJ9jj
	ciqWmCo73GDoBfljYoZ5XxCvjk61vELWF81KqHUJMXQ==
X-Received: by 2002:a05:690e:2513:10b0:65d:da2c:ca9c with SMTP id
 956f58d0204a3-65ec979870emr20814576d50.18.1779952261816; Thu, 28 May 2026
 00:11:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260515120019.4015143-1-hch@lst.de>
In-Reply-To: <20260515120019.4015143-1-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 28 May 2026 00:10:48 -0700
X-Gmail-Original-Message-ID: <CACePvbVvhJ7Kz2wtUUu+PoNweOsq5XABSMqKrabX6FTdK2fpuA@mail.gmail.com>
X-Gm-Features: AVHnY4JyxM_1WxqiIwmeGiuCWiC6ABJFVjHAAFaVjqp0SbQgcCYQTvDUVaS1kEY
Message-ID: <CACePvbVvhJ7Kz2wtUUu+PoNweOsq5XABSMqKrabX6FTdK2fpuA@mail.gmail.com>
Subject: Re: RFC: better block swap batching and a different take on swap_ops
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, usama.arif@linux.dev, 
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jxhwz185scrtcqgeu9quzhhjz1keu16o
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6DCDEC000A
X-Rspam-User: 
X-HE-Tag: 1779952263-119019
X-HE-Meta: U2FsdGVkX18OyvV8fGzynFEJXYY+OvAb/8SY6zaOK6BduyDi5Ivl/IgnIxKTvmhNy3A0QSR7qT+l7jsy6PkOCcAhAsBSgQ2H3EgeFzgYuWyzZTo0NRBalgHEcxpFe0HvW0S3LtOf48Smm6BHx1d1AFhNYTRWbMjvkJMj5A3yCtLvxg87vKTlEUATVd1YFhBo4mVHduQp2q5ElN6tkp//+Eeo4z9yccVccE5IWA552pNAe8sdz6C85r8BOxqmygk34PUh/QJGRYb/Oa8IVWAXVWQsMTEnFhP0sbNGv112XaMYjIp2UuagoioqzHqPHp4cebGJdUKFpiJ0S3w5bum0D4i8S12kPTFjvEbb5Zj4uuoMvbZhTdw6LbhBjsv6sqtL5gP192a1BKbC3xTL23lVh6BiTMObUpQ6LyN0pmLkzAhoYASKzCgLJw3fcmA+ScoS0oqAEDw+O1E4EuzbmZ0BoRDrXOcB1vsnVHIGH88t9abkZnF1dthzaiqHurJv+kgQHHfmMVQuTy18WDGIFz9zsXCofh8m3Vfqwns2oyDauO+K+Sr3oF4YL0djT36d/JIfEoP42phFub3jskUFFlTx6WgcIjwUMU/AG3aaG8ZwKPbY7DRXwVCod/KXEkb4nTng/lbV8Qpi4IUpgNpK3L861WjzFwDZNoJMKNygIc4EgEEEfMNekTrv+AoisCEBGKccth4vFTFzp8bGcQ/ksK7QSeSzqD2WAHSVVofL/xT+3W26PS3PMdx1xHNEArQrN+66qf/pMciQH0VMIguFTs0kLw0UKMBNJur+5KX72IisS1FkqW6vcJQwe6qbuJrP2GX5fvSMPrv6MLahtB1VozIhFlkurpVD4Dp/8C8S+q+lCIQmI1juOfJFm+kjB7NH+HDrBGBhaR+LDH1tXBWqVpdjJ0FnBMPGuq3Tk/tiLr/pauDdHtP+UpVIHpD7V4OFBpksqpZHfFQyMshEn1EmB/4
 X6W0ty00
 PRa/iSl03SNwJY74Glm8ZqcH5PNHJhR0xHsI/X5l65NQpJiwYorGorypYkbSqHn/bC1dZjZc52O2UGgDf9W00LoP/qa44UPL2SCKoFmwtoO8eG75hk8euLwh7Rdd4p3XQ0tNiXGSV7mJrB9S0sGGwvp4VB1KziylA+aOzE5E73BKsOvFkJFfAG//5l7l+uTYxujOtj1HVtr1+/QllMxKfrg3nAxkkaEHM8Iu1G++2/LV9T1MHtvfevqi6vqvW0FlwD2e9l37gBvyNYxp9js6MdqcFBBfVLcLfIw8fHLgEsLj2Ja7eKv8dgByUrNLKLLJvnMfOBIbHf4VFdI0uObucKP+zPqlEokU6PK1cXPUm+H+gB1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 5:00=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Hi all,
>
> this series makes use of the swap_iocb for block as well so that it
> doesn't do inefficient single-bio I/O, and then rebases the swap_ops
> from Baoquan on top of the now very different method structure.
>
> This is very hot off the press and has only survived very basic testing.

Hi Christoph,

Sorry for the late reply. I have a crazy week.

I like the direction of this patch series. I suggest you send it out
as formal patches without the RFC.

One observation is that, this patch series aims at situations where
block io merging would be beneficial. This makes sense for the
physical block device. However for the memory compression based swap
interface, block IO merging might not offer additional benefits. What
do you think about a combination approach that allows the swap back
end to select whether to use bio merging for swap or not? The end
result is that file system swap will use your swap_ops flavor. The
zram and other memory-based swap backends use an API that behaves more
like Baoquan's original swap_ops series.

We can merge your bio merging swap_ops series first and then design
how to allow swap backends to optionally bypass the bio merging as a
follow up step.

Chris

