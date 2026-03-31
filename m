Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56069FF60F1
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DEB66B008C; Tue, 31 Mar 2026 05:22:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6466B0095; Tue, 31 Mar 2026 05:22:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2E76B0096; Tue, 31 Mar 2026 05:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C0096B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:22:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DDFBBD458
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:22:08 +0000 (UTC)
X-FDA: 84605816736.29.CB58913
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3B1562000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:22:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Or5RWsez;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774948926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u89XgAtMoXR1/Ibc8jhF9HqZHMlFctxvUlUetm6nh0E=;
	b=FUfbXhvfwzEPFFr8GHmmnwHX1BxykyqHM1rYDYjKc92lSGPipHNtiW8my/Vs98fOyItxbm
	eL2/WOAopXdAZqfBGnCxXJ0m9UP/eEVIHXPCNk4t1p507NhuDg6eCANJdGLQFi3BOpCXkh
	wFyBD+zQ0aN6/MzsaQSZtTQgksqMea4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Or5RWsez;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774948926; a=rsa-sha256;
	cv=none;
	b=D3TWEHrLL+6j1Pyd+NSXunaxeEhzcZJbRuEDGShDTg/u3vPIXSIQzmF27MeDtwYX76+H2O
	PouyGyfH2r3wpdXsKDlPrnTBjQo64pPhLxthIIHVxk7OJo6NolPRSP3JKF1OV4QB+CQCnA
	61f+9TR23tvC5qDeUh8/h2dL+LDNeII=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2281F442DA
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C78C2BCB7
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774948925;
	bh=FV3sR90IOiDlBhgFbrawyU5jutKOvYsXcEIAnBX721w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Or5RWsezVdmJXmfKXLU/+RO6AW73b9HhH7qXdzh3PhUekUvVn6glLz/t2uLWGRfvF
	 Bnqb7nfaVta9+E8dtOVG7lGniJp9Hwx3p6AnZwttYtQVYMBAAwQU8OiwzjBXdOphRW
	 VZALKGp30KZ3cZqVQ3YRe7/+95QRXATjcCBJgGdUT23sZymEw1UlTGzysFv6oa1ZUg
	 or4GK1TFMxuOsfIJdeThcNUTdzLNXZQf3sNf+wZMs0J+sOoo8zPsmVHKgbUq9XBoAS
	 jdooTCWwai/K1tLXTdRFl3NlyHEtXQMoS8nSMi1Usc0hMx1zqPFMcvbqqHIEJ+ZYE0
	 SdIOAzd7JNnXQ==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-89c43c4c383so71885446d6.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:22:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXbGJYohVs5eloe9or6sSpmE1zI8RISn142EXyNbn08hLn5GEkzIkT61hVjBHiO9W/drQSV+EAAqQ==@kvack.org
X-Gm-Message-State: AOJu0YxeerlLFqkIMVR8+wKglrTnBM5XviSVoST1f/tUo/NJP4KkQQeh
	UiexaPybm5pmHDH4nSbWonJtfgBWJ6bpUoX1/99nlq6gaj2Fd1prY77UNpYIoJBGLYR11HnGktS
	RFnSqYBpCfFE2K27RM0ml4uBvkCLfQpM=
X-Received: by 2002:ad4:5c8b:0:b0:89c:607c:8c4b with SMTP id
 6a1803df08f44-89ce8d5d0d3mr214426876d6.5.1774948924079; Tue, 31 Mar 2026
 02:22:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260328075812.11060-1-21cnbao@gmail.com> <20260328075812.11060-3-21cnbao@gmail.com>
 <CACePvbXVaK0McYSr8O7h2XMpEh1f1JGzLVJQd69V0QnFXr8Evw@mail.gmail.com>
In-Reply-To: <CACePvbXVaK0McYSr8O7h2XMpEh1f1JGzLVJQd69V0QnFXr8Evw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 31 Mar 2026 22:21:52 +1300
X-Gmail-Original-Message-ID: <CAGsJ_4x97xHVHCtXi7v9wgbjRpOO-LaC=SsNsYQ5tJf5_Wc5FA@mail.gmail.com>
X-Gm-Features: AQROBzCJdjrXABR4qdV-glYAtPXEJJS9NfovzfViIj2lstem4gT-6tr0zCej8sY
Message-ID: <CAGsJ_4x97xHVHCtXi7v9wgbjRpOO-LaC=SsNsYQ5tJf5_Wc5FA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm/swap: use swap_ops to register swap device's methods
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, bhe@redhat.com, 
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B1562000A
X-Stat-Signature: km88bk8af7grziz8zp7ptz99gi7p17oe
X-Rspamd-Server: rspam06
X-HE-Tag: 1774948926-16848
X-HE-Meta: U2FsdGVkX1/7iiKPzKZWMJDeZ/9WDs500HN+nWuJu84pTI51yu0YaTlpwO7GyTBFP6k14i+flhIr2RBaCZdhExiNnfE3Lu61Pb1mQb9vkKWM+rPRu7vuFp/+8LBWayJXMAgWit/WTjzP4lzx0n38lln0K5pG89pMmffvgOVCvpVn+1VOcMfRc3p9jF0yW86BYWJobB2/5OsUVjc56tKiVIZEdaIkjWA0PlwsCjBH3ynrscGA2aepJ+s0h4ks7PpqYKXZE7pbG5H+Ppb5Thy0EOGREojBUsgI6GMRFNLdDG5b+GoItfqAbuDbSjvCY+XeRAUb4k3SSYNO1WEtlp4Ngu4m4Ox5916rdu8WykWMIldWQdo1iwgtnIm4xHoBN5OirzJKfNtuua9DgqHn6sMfRLHwENqhM7Be8RXeO7dlQj3QkYHuAfl2sCQ9b8yuRnl7m5yuIOspGz7ovtRFOxr1ohuaKysM4nv+OBOWVVjIjxDe7+bBMIUAPoS7S5FyQqsEJIO0Nu80u1+HOxQ87ONk2AaE+wbFW+QHHnepyM7kXyqi7/GjB6eSjmTT198MssPx8SfWK59y5/5UdLBGJIa/hRqwuOJP78Ih1zHBOSMcRjcQesJucZtYDmWsXNFH7B9jdbIOeGD4TOqZEiWYpYtLVg1JDAcvRmtl11WZS5ANlIkSdVG5OMXQrR6ILgMzi9kql9w/3b+Wry9uYKdI3HUT3ZYAWUHcy27o4ToXOtdST5GLYwg8K+l5Egijt5cYuphXm8MC97cs3x99EKGGDVb3jkMswFwkR0av30ZirC1aDou60FZoSFsviNdlC68Kf7zyVxoYb++XN5SbSD9aLBxUHJpmmABiDJBSMfibuoG7evqE4Cme4j4MMRmDkioUBZ2TSu7BYKlzBOGsxHqi4Hbxh3EtBTfWs2sf2aqCEqz7W7B+QcQcVW7em4+EFO4YgJ5QrgxrnCV6XV5A8qmiPgb
 GjyGvuJT
 1eQiO9MMzjw/U6NWNRttDBQafWihNBrVH7jkx94fMWFf/uiFoA4iRFSzFQNafIPdqz8sfalU6Ddr4qXRGS/EmURi5QLDmXpQxpOK/coEStkKQvRhEwXP4C+yO6t6OeFxIA/lPl4ZSSZ15xwdWuWmY+53gznknAlKgE8jcCc+37m0knXhOwkA1j9zcrvcYDvvIJnh6kCeXxsnp7KwM7fopUx4JvsIwbpV+4l9uR8+thH4hH3tJg2+nPz/dH595HPsrmSy7r7aU/wqMAtVsukOJ3dhbGiabeVKj4LlL0UoynrK1r8ng78GyTST44wF72Xf3EQZDtr3MNM25RbjiBKRqV0PvBJncstHI+/4CREoVYsbfBWvsTPwv9CpHAMjZO6o63Deci9WCpdgQZq2CBtYpshIqrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 4:31=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Sat, Mar 28, 2026 at 12:58=E2=80=AFAM Barry Song <21cnbao@gmail.com> w=
rote:
> >
> > From: Baoquan He <bhe@redhat.com>
> >
> > This simplifies codes and makes logic clearer. And also makes later any
> > new swap device type being added easier to handle.
> >
> > Currently there are three types of swap devices: bdev_fs, bdev_sync
> > and bdev_async, and only operations read_folio and write_folio are
> > included. In the future, there could be more swap device types added
> > and more appropriate opeations adapted into swap_ops.
>
> Should add that there is no functional change expected from this patch.

Sounds good to me.

[...]

> > +static const struct swap_ops bdev_async_swap_ops =3D {
> > +       .read_folio =3D swap_read_folio_bdev_async,
> > +       .write_folio =3D swap_writepage_bdev_async,
> > +};
> > +
> > +void setup_swap_ops(struct swap_info_struct *sis)
>
> setup_swap_ops()` needs to return an indication of an error.
> The error is that sis->ops is NULL or op->read_folio =3D=3D NULL or
> op->write_folio =3D=3D NULL.
> If there is an error, we should fail the swapon.

Right now there is no possibility for any of the ops (read_folio or
write_folio) to be NULL, so I was using VM_WARN_ON as an assertion
to catch bugs in kernel code.

That said, I agree we can return an error earlier instead of letting
swapon fail later.

I think it may still make sense to keep a VM_WARN_ON in
setup_swap_ops() before returning -EINVAL or a similar error?

Thanks
Barry

