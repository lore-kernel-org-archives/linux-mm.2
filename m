Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BC2ECAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 22:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03F838E0023; Thu,  2 Oct 2025 18:50:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31EE8E0002; Thu,  2 Oct 2025 18:50:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20818E0023; Thu,  2 Oct 2025 18:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFB128E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:50:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80448140688
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:50:37 +0000 (UTC)
X-FDA: 83954670114.07.80E5A42
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id A228F4000B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:50:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LU1QdNdQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759445435; a=rsa-sha256;
	cv=none;
	b=E+5XWhyuEB1BHzl5BNgN4z8r4qCoKtLjVWq8OfyQYDmEreV8iMbTIzFavhdCofPIcU7rjf
	Ibi1W6idPgD/ycOkkEB48EKoYFkKbiaXVQeanuAoGjjq4xoGQMAgaTNC70J/BZQ79jwW2h
	sINMUdHw4K8YQkLWB9zJiAH1dSwjoNo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LU1QdNdQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759445435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCUh+3y9oWcGOLJYRgcUnoLdgWctAgE5Oi5walHuFOo=;
	b=MjILqarVPEYFMGsxQz8brx0ouLGV2NzkbkZFC4cJBloy6Xpq8yQ9wA83tm5uZD8e3QeDd0
	XFMWmF+Z1EzWe1HfnsUERCQWzlIpb/QJPZOfmf2qaPwOR7XgDVtqs2dhSUBE30yLlaj5k+
	BG30qD85woZCrMsM4w0RWxTLjRi5e3I=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-27eda3a38ceso2543825ad.3
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 15:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759445434; x=1760050234; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BCUh+3y9oWcGOLJYRgcUnoLdgWctAgE5Oi5walHuFOo=;
        b=LU1QdNdQToxJdjPPPMu22/G/CKq+MBR4sgdNfsaTn5E9a/JhUS6QsbPaVsosuYDBrk
         HUTxMyj/DGk+sd4aWcKfSx++XmfUPu3xvwFrFH6fhweZmZkvJkUMYXULk5bqAmZQ+i/q
         8uVeGO4tPLoAP14+I82odsQ8IUH38gdx23oHY1V+l7ZMxY1WXfQyeWttqtp3Q7N5CwKz
         xg2DUsNVwTRHVkwbzi6Zcs4VyZtpZXXDJtk3/5x87bWlXJVlCMKOj92d0wOxHNOXg3be
         sSTqywu3xF9c0dMfcSFJ6NaR50wFbtbMWd7myGoKj0SSc1RuzzOXdcgMBHQGUCabxb4B
         WmYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759445434; x=1760050234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BCUh+3y9oWcGOLJYRgcUnoLdgWctAgE5Oi5walHuFOo=;
        b=pLK68pTmOgxLuHMzxR3dAsYlcqHI4jpqSzWTgElO2c63kwu35wK9nr9sc+gIh2oVjv
         hPGEMjVVBaKMWubfyLY5XOtBttBRatw61yPI66+GnbTes0FEvj7SMOoF+l/y9UYF9aSF
         8cqh1y14dRr+OrMpEpbRc8o46kSdDnZvA9iXFKgP+9yNlFZSX1wxEUSBj45SmY+Ht6kO
         yuXbHvStnl/W3wB0u3Cux1ClOKeyqr84fdzcHGQqH4qRtWtWYsoqC0N7BrJp/cFbFlhW
         eJ/57nXS+tO0RFyr4cpPVjYFBx0S82zo6jWC+PZlOv44AzfFsYjSKJAg/B4gzeY4MhwR
         R3Eg==
X-Forwarded-Encrypted: i=1; AJvYcCUU+aM4NUHPTYGFyp3elQxXrTHbUUfFTzxR6Y3UgOpzf8/mq4aYkQFZvlss4Xs8Y1tqsLQjVAwm5Q==@kvack.org
X-Gm-Message-State: AOJu0YwKH5p73LI+zzceF3nEtRhDaYUe5C3ay0RM9rlBuKxeXOyoaR3I
	eRasXASCwRfasMJfugeeQupQwQZ2YrPX8j4uoF3t7Tcv44kP2hZGvQERJoathNFlo1uRRZYaLag
	EJrquJlz8Gu3U94sL0jdJ6IQU9LQh1hI=
X-Gm-Gg: ASbGncsU0vrzZ5P61vtOQSjF7jmnVh0eamfRxYVL6igow1+4bigWTDTqUgmEA0NRy9v
	NdlNDf4G0VVWisGUV9VtvhNfuAaboNjmx3/OlH/FhuZpdEpsgiqNMgfTaK3TqqAMzNH1NjlciPL
	3g1msNjEbN4Ek4QB937pWRBgtNji0kc7XdQGA05+RnoPkWAwW8quf2ryOViMSFBbZ3rK+HXYHBq
	utm86Nj4Rb0tTgRDkDXKoyOe9o6PVt68qqOLb4vpBdc09UTqq7U5WndSsDtMGD9kYxgFnUwWqkq
	pthh5iIqhIkxZ9SSl4x0cnxO+ktaP3hShHYsB4ZcAJENGHb6Mg==
X-Google-Smtp-Source: AGHT+IFV4Wfa8o9I+3qoUvKZUb+LJ0mJzlOW+f77CCPCebEjpFDzi/h/XE2fti4OE3uAE5/ckhQ5s/wz69kA9mqMIR8=
X-Received: by 2002:a17:903:234e:b0:27e:eee6:6df2 with SMTP id
 d9443c01a7336-28e9a6de147mr5355555ad.7.1759445434467; Thu, 02 Oct 2025
 15:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <202510030449.VfSaAjvd-lkp@intel.com> <20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
 <CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com>
 <20251002152753.c756678dfdcf739e2fbf74f7@linux-foundation.org>
 <CANiq72kWWPAZ3gq2ktMpVeMKpWOU1nAmYi-4d-BgbuDti77ggg@mail.gmail.com> <20251002154323.ca15e98421255ae2978e8d6b@linux-foundation.org>
In-Reply-To: <20251002154323.ca15e98421255ae2978e8d6b@linux-foundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 3 Oct 2025 00:50:22 +0200
X-Gm-Features: AS18NWABBmYLu0f9tJYY4He7LPAqs167ZupYqHiSSMsWv0t6_x72VaAKmUard0M
Message-ID: <CANiq72=5eDXfq02FXUBpEpe5Ke9kxhT2CUQU5hsMkPMBL5QWbQ@mail.gmail.com>
Subject: Re: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Jakub Acs <acsjakub@amazon.de>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A228F4000B
X-Stat-Signature: 5n5s186ephm3gjpxa4dpsps84fgxtdc9
X-Rspam-User: 
X-HE-Tag: 1759445435-466254
X-HE-Meta: U2FsdGVkX19ImyKh3shshpgf83qXxkWrrxeY6JmdzDs3e4EpOyJLfccnvRprsDoRF95ANAbkQjjuS4Pt0O0PoNeT1PRdJZwdu5bHwZ9Cf5f6ZmMti+UmzEQlttz1mr1o95ojelQ4Y9QAfhyNL9OLcaA5KztZxr6VkTMXYIy2pPypr3X0+jfxbr+xblN3AFFzQZ/c9g3cQVLSwuS7i9VDhbJRxMh+QdI3avnu9x41WB8aanZGVwAKZ26EkB3kWii4RhEODD5+TMrWLzbFQllczC5QAnUX/w735A1X5Z3UkbnX0saSeWeIZ26GIl0qSBKaIkjNZGojMqJEUuqufFoFLoaooWRRCI2SU5qh/doqz1w54jsVKbc14ov0GAPagOpOMk2ipsPgTVfaDcH74Suya4jaH4vWmrmTTBxHeJ7UtAE0R1LlFqklil1WLd2Gh1SKgSVlbPX/h66xoNCiphXqrNs3pbnXPI7Fx0cyN1RGVmRqNULZFpl42tgnj0Lgaj3EyKIKa2tUfZSPMwE62fDTp8UudJWcLy2nEH3Uuv+r2GV58GYUCSI3F7SCcbgRyI7hbfiWODzuslP2cCgEZy9YoLd8VDmM+RfEh+8RNzHFEwWA4R3Fa9RH+FKlPRKsyRAX0tN4d2lSBRK4v090Ek0SioBgQjcs4gvwLH80OBcgAFJ54zc1Cl2kAeLPqli43C7VN4nHyMZB6/cGzJjpVJhP1ZCXokNDZuieCjChZlHfxKtfUbJsI7aW/VY+C3xeV1KWL1BmPQ7S9uah4Mt5Al9vQJIxUof1WBBLCL8xxuQBAVb2y5fLjLYwGMfLoNGgLSR8xOr8+FbSc3gA1Qt4FMeCULMPyJhzN3y5SDtuRSpP0e84FWrlE/Ok5owRXKMDWUqKbkspxAuQ3Az1N2RK1o451IHIngs/wWTVV/HrJuYPixjmdNJUdxebKyslmXW8BJBt3B4SYc3FUlGeOg1BSPf
 6R2bHAnW
 kvtNrt/oJCLYT/EdgK70JGgBDq/dJWVUydkcFLcGaBFMRjxx/4+o5rE9FqKUJD0mWE0Nf1gZRpizEdn9QdI0k4cUP3SS81M7XDVlCp1t9hDbA5a5piTosW+Tv51dtZhRfe6bgBI/ya4qSUD2bFHwcUE33XSejNg1OIeyi6wi47FZxo7Hd5nLFgyC0m+5rDVrOttSnV7kNCmBlI5pjR6fOLNSQIuuon9t/zrj8/My2a5vdncOzqYNIFiTH8Bjg6/NgpgMiGv6+SDBejtlWQPzZxgBEQRBeGwjQz0KgZbzH+MP6d66GJgVgpM1UI33VyMcQgUDKimUM+zERGVe0ofusBvOC0eKYmSz9hu4K4ogrY++RJ4H/7g5VGTZBNb0b36nMsKiWIX2DUih+6sRomM6yE35RsTWz7XNetNIn48HyjqrLfC2J/383nV5YUa64KmFgaFdRrEjXXf0ylvKKBu47ssyz9UxbdsaKMxFmGntOVbiUSQeRbw1TdplVV+7+fYcaeB8CSwaIRKDXvd8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 12:43=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> It would be nice if someone were to test it!

I did...

(but on a different branch, by applying your diff, reproducing the
issue, and then my diff)

Cheers,
Miguel

