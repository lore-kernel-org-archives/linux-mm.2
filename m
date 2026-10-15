Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E8BCC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 22:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86A466B0095; Thu, 15 Oct 2026 18:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B956B0096; Thu, 15 Oct 2026 18:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75AD46B0098; Thu, 15 Oct 2026 18:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54BED6B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:39:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E46D6A01FD
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:38:49 +0000 (UTC)
X-FDA: 85326326778.27.A794958
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0BA7340005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:38:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JPaqGgWz;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792103928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fP2v0liwapgrtzdre9miARK7GK7WdtkeN3T+umPUbBg=;
	b=z9KZJ1tlyoxz6KrJy3RBcOU/QrPqxyCPlnsO2BMPCRlJYwaD4CojaMDv/AHFuCvA6NWjz8
	e5ZqQg+w+IRK+92e5y/SpfDGj4xB57aavhTwAyPNJTdpy8NS7W39Xw/dd+xiAHOTF1SVdf
	arhJ9mMW47HDqHaoegc8H8MWGiTDsDs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792103928;
	b=DAYc9OOqwz7oBphNdzoJbiysEXrX5KaOADcudErV/PdXhES3srpMHB6bxhqE4bd7M/W7jP
	w6l/HE1ZswGJhA1HFl755y73Pa2sATCgXToV09D75qC4VhZF5hBrvaLi2MCn80oD6hRQU1
	b8Q+QQ/tmkQ+wmcvZ8ejhmb+nH6Zn40=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JPaqGgWz;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A8C144522
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DB81F000D4
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792103926;
	bh=fP2v0liwapgrtzdre9miARK7GK7WdtkeN3T+umPUbBg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JPaqGgWzIovEpFaoe7BZ4hRl23EN5gAMhYA2PVvRXMIfKx0Ke9Oh2uLsD6u/gwiQN
	 QyeOTX9XeogeYOrii/88PI0Vn6Tu+cOuxUy4UDlVoNl+VDKgpwavkKEcIxRomNiCMW
	 F8gXbzcM2j39ME+ewP1DqDgV59SaFSujaj94OxRgA7md7RhDTx8AKbpc5CTfWM6WeN
	 rM0V3gXfFyDCilcUuMAXDDUPNk1O8XrZl+n41g4ptll2jPa+NNTmKtVAfoY0UWxMQA
	 r5m1mVdynrZx0UG9rDrVGPY8UKOfcOvq7OzBKVDQLv10wyInhdXVsF0An/5cU2VV90
	 H0/cPBvh/0+rg==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c3fd91337baso133185466b.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:38:46 -0700 (PDT)
X-Gm-Message-State: AFq9FYKCSlNuKTXj3IYf3SkXUaX/Pk8tmbIMJnXbDLmYjhD90/kQrW7j
	/wM0Z4nzGTk15VZ1jNiClO7FT6YfqdDdaqu4V2G+x2w4OGqHPeBqZiayKfGFQkhpvvD3rVtLFmS
	izORDaM2kpc+b7tCmGu8pgjcuePOB0Yw=
X-Received: by 2002:a17:907:a713:b0:c2e:3f49:df04 with SMTP id
 a640c23a62f3a-c31a9a3404emr1964758866b.1.1792103925460; Thu, 15 Oct 2026
 15:38:45 -0700 (PDT)
MIME-Version: 1.0
References: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
In-Reply-To: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 15 Oct 2026 15:38:34 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM_TfD82vZ23zwsd_pPLMpe11_XQhPEp5NDyhoPKDizag@mail.gmail.com>
X-Gm-Features: AclHuK9f358igzZrlpERhvuHsKqtHrVH0mq2fMOcIB6iG2oq3KZiunUWg1MmsVk
Message-ID: <CAO9r8zM_TfD82vZ23zwsd_pPLMpe11_XQhPEp5NDyhoPKDizag@mail.gmail.com>
Subject: Re: Sashiko change proposal
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Roman Gushchin <roman.gushchin@linux.dev>, ackerleytng@google.com, 
	akpm@linux-foundation.org, chriscli@google.com, hannes@cmpxchg.org, 
	harry@kernel.org, jack@suse.cz, liam@infradead.org, muchun.song@linux.dev, 
	shakeelb@meta.com, ziy@nvidia.com, "Lorenzo Stoakes (Arm)" <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0BA7340005
X-Stat-Signature: 3rutrzupnaei315yf6d6nbfo5e7twe3o
X-HE-Tag: 1792103927-675232
X-HE-Meta: U2FsdGVkX1/No+eMcQKHuG3IcTOUsUS27zv+oq1NtmfnDoeu9pAyjoUu+unY3kpLZC26fROtgAHkjO197Ay7nAE8r+BWwOZkUIhhleHrplI1w6nMWK4uku1+zemkOn5J5uJ+kAauiR7bvyDbptN4fYh+q6OtTvlq71FxXDc7dYk7pmWhl+jLk4ZPFWV3JK9FWHKpmwZwxbfyNywt7lgg43NxgNTyBQDV1jHV7KpE8u7G5mXquwuYtWCESAlmuc/Mqw/rFUdof2w4Ho/6L1reo7Kd19O3GJz6dNieYdH5stcDDW1lwLZk6gg4xtgLgVDpjCxdrsUpXaB57wsg3RGAviM1KSK26645LOwjr/QIDCV0WTY/dRSG+9cm4JxUjBV6LNYkkxE3CA3l1Cw9X5v0CCWHZ49w2oOTwUfxoDi9G8gLzSeW7nsSIBujhp+fEcjih9IcwYgaU+/5KWiwEKiAAvYfBywEeVwr6m2iEbiGJssAAOXJq3RzaYQq4NzSddsnae/86oi1s3qUJ/YaaKOgX7Nbq4DGKaLjpjT6qciztygt8E92/mml1ptbm46WNTHZXAUA/AI1KU8tj4Yej0xrySr/+rj0LF/ZS6Abe92wC2bleaI3AA2oKfCsAgg/YvD5MibglqGcvzoTqBKQqsQB3+f7stW+aTomhXzOv9LJeoEeLnaUZIjOrB6WvUWooFJBeDYeJnnR06EUPxd1f/b5wBMEPteKHC08jCLDQDEG97fBbo18u3jjZi0gY+62VVCXxwmTImSXkYz1HxRhTi2BiD252f8nzU7oH6WCuU8Dl0QCEqJEtVphwVBF3YC0zn+ZTqn7/SEz3lAwfNVYYzOyQ1ehNVoDFE7QKk1inioa2pcyRBU4i0vfPwXWjL9OH+krvMzRP06ohZ288yK1KhFZfYvLVv8IamEhggq0OdunSmdC2Fy7OUtzEAFslfvvwVSMue0iOErzyfNFbw4ByYd
 6Do0fBfx
 QalL3/QOU9T41t4FjEx9grNIlq5qO9VLl2jC5/o+7fdN1+4SAvBUAzqUuDy7QcybkjTi0dZOtaZmAgQPtvCCKuXwYsuj8Lu2qappnu9PJqVvtT+qPsDVD5Df9TfOhfyzuscdsa0uff5R3eo4OEbo+LTQQQyKWLeCgY5zG0jy5l0VQwcu/WchYIvciJ2kXcK65e3Nl0fO5/mnL6RJ6/4w9dq8Rrv9WcHe+yfrkL0SOEg+61P8282SL/RYZnxHUNXLuISn6xxmD3pXi+o8tFuJ2dNWX4adOlWRJhPD9bP1Bt15ExXugd8i/QOWbqfqD7XBgyOtkm2aS/+14tFUdq3wTbQlruIK96sLkSmYrrHHbETIVjn/AknVBBIlCjo82mDWOjZQ3LfET4fsIl1afetbL4of9vYC85NSaUgQolSglqPqcm9oT2Jy4gJXs8e0hWTXTeTiQ0zNeACnaOIgWrmgs07ofIAS4HU64KCd3zvXvl5ddFIqY59ZoBRaA5w0pmrifhK5fpVZnAQqhSxaJIVAOos9ucw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 1:38=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> (CCing all people attending the mm-next call)
>
> Hi,
>
> After talking to Roman at MS, he just informed me that sashiko now has a =
new
> feature combination:
> - "embargo_hours": hours before review is public + emails sent
> - Mechanism for signed-in maintainers to lift embargo immediately
>
> That solves the key issue I had with sashiko: people/agents re-spinning s=
tuff
> too fast before a human at least had the chance to jump in first.
>
> I suggest the following sashiko change for linux-mm:
>
> diff --git a/projects/linux/mailing_lists.toml b/projects/linux/mailing_l=
ists.toml
> index a9198de..ba123da 100644
> --- a/projects/linux/mailing_lists.toml
> +++ b/projects/linux/mailing_lists.toml
> @@ -46,7 +46,6 @@ ignored_emails =3D ["patchwork@emeril.freedesktop.org"]
>  ["linux-integrity@vger.kernel.org"]
>  ["linux-kernel@vger.kernel.org"]
>  ["linux-kselftest@vger.kernel.org"]
> -["linux-mm@kvack.org"]
>  ["linux-nvme@lists.infradead.org"]
>  ["linux-omap@vger.kernel.org"]
>  ["linux-pm@vger.kernel.org"]
> @@ -315,3 +314,7 @@ reply_to =3D ["author", "list", "recipients"]
>
>  ["fsverity@lists.linux.dev"]
>  reply_to =3D ["author", "list", "recipients"]
> +
> +["linux-mm@kvack.org"]
> +reply_to =3D ["author", "list", "recipients"]
> +embargo_hours =3D 24
>
>
> Which means:
> - Embargo 24h
> - Mails sent to everybody (author, list, CC list)
> - No positive-review ("looks great") mails (default)
> - No other static email addresses that receive a copy (default)
> - No additional ignored author email addresses (default)
>
> I'd say we start with 24h and see how it goes.
>
> Thoughts?

Thanks for doing this, it's much more convenient to notice and respond
to the review when Sashiko replies to the patches.

FWIW, I prefer no 24hr embargo, seems to work well on the KVM side --
but I will take what I can get :P

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

