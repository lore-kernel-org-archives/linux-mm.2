Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12FC4D2E008
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 06:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C07D6B002E; Fri,  5 Dec 2025 01:39:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 971426B0096; Fri,  5 Dec 2025 01:39:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AE956B00C7; Fri,  5 Dec 2025 01:39:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79ACB6B002E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 01:39:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A5C51404AF
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 06:39:48 +0000 (UTC)
X-FDA: 84184466856.24.A89591D
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3ED6E80002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 06:39:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VRuMIeyC;
	spf=pass (imf30.hostedemail.com: domain of avagin@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764916786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xos3/gKqsqARg566cAUpDT+mdSxuLsIU5NrhIm44L6M=;
	b=vEQ24GWwOzKOxSDaurWCVGuZ4eHV50jYs4Y1GXxyLWEyOIgn6DH+AippBzMmTeLhOJy8+B
	CICPOqCbB2MmJU/xBZ9EKKlV5cula0pY/tDlxLRt7HLrHb/PrNSl25Tbg2CFEGiymUN305
	+yu7M4sescRpr7XyJ8QXEwy7lqQ/JHk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VRuMIeyC;
	spf=pass (imf30.hostedemail.com: domain of avagin@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764916786; a=rsa-sha256;
	cv=none;
	b=iuftycZNIV9bLOaYugoyC/S210S0xkZode5sVNrMx5570VKUEvmFmmzHN0Ii1GJpnxWLC/
	ngji9fBQyE6HtEh5+qCcz4gszvJKyMeA9OKInFabCtAcKubnJTZSXWze4n8bUrAz96T9sZ
	9XxTqhZl1gHVbqWQtB8rWnPT2Oo0UNg=
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6596897c2b5so971727eaf.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 22:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764916785; x=1765521585; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xos3/gKqsqARg566cAUpDT+mdSxuLsIU5NrhIm44L6M=;
        b=VRuMIeyCkLkXuVcnXeUJ1Em76eMS8nzaw7qrOpA76ulQKR7I3oKObcLI3s4IuOqUzv
         LmFyIH7iVa+dAq4DzNE4/UNVMEix1y/gPkQGBMoqhmp2Aim98W8lHvzwFX0Z7VzA6hi0
         wxlRYzEN+hc2Dq6ByFrb9Po/PEyQMXJ+iBhFJ2MgZGGB05O6nMJU9Fz0N6pPcJ6LlfIT
         bmnCDYZ3Y/7EmGptsamtR1CK+HNB19ipulMYeCt4JA5JDXqrwX7/hQqF9nImqtcfwNRN
         WQ7eo2f/MZdxF6JCV6QgiJoTrZdECPMGPTqgxAmfoTZMToESIfFnomHZAj8K+hFaUza4
         zErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764916785; x=1765521585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xos3/gKqsqARg566cAUpDT+mdSxuLsIU5NrhIm44L6M=;
        b=NXY5oCrkz6ojGLli/rHDZrNWohUctqHVtfC40erANDcUMOvyrFgqJ15wuD9mibBkkM
         hpwusHWcOiKPxU9wO4ex4ao4BtCY4dg8bkLsE+8l5dq9Enr4RwmMlg215rs4kF4+7rGp
         U5hPMJnxPG5OFQyt66dQJaHjWUoahgkuJb6RY7oGHhr/GDRHg4iS2r9PJepO0SuFUbdr
         QqASf/kKDT7l9wyuS7Mpo9DAsYjTYTMyblDvjmJ0V9lZl3qJax3yUIEoku1D/I0b3m6y
         QVov0hanf9amexZ00peBH2kEAZdTlg6Gdysdx7Ezi/Dkwr3khciF3h2NoqWgyAL73TlV
         xPlA==
X-Forwarded-Encrypted: i=1; AJvYcCWR+UFcu/MQa/2h+2rFdiPuNg1ewA59DReZ0TYgjYCRr5e1Tb2V2xl6+EZ8kokWUkgVpkASbANX4A==@kvack.org
X-Gm-Message-State: AOJu0Yz3bIS2we0sO1LhO3v7v/Ha1gE380Kiawk4hr6BWPHluLAJSFfp
	Rzzl309q9SW4cSCpukrD6d90YpVbgDlqHhIrzrVOATddy1hONIjVP/i7Xe8ZwA40c9egl/ud0Rk
	syEVSTNGItkR5yHthMzyaImW5s06EoDw=
X-Gm-Gg: ASbGnctC8NzX4Sr+oorjUR4O6sBUYlZJE1jiX4xcISsRh8sygjAEeeV8+E0rgySpsaT
	oKUdRDamj3GhWjrFsvSwj9Oh1wd4ZJLNu3HWLoIEDs6X4C4AYQUIDh+RsGhqAGgT32QGpusy9mR
	f6cqvAH+IjzyosQmONvGME5FaXX+/Y8NoT1CsHu17+kZfQFbpi5wsXr4w5YkqmJtxnwqTu0L5Wg
	e+VFKSc9zRvttKaBRogxoXYiz9l6HlsYB6Gc1T97uwC8qS1UGIcFK/eWEfRLLVr2DGT7fE3
X-Google-Smtp-Source: AGHT+IHbvPZzUKtzKOwSB0dGiwkv726da9NNiQT6QaR1QMK1BNnACaPRk9hA/hPZpkFIaQtQU42Cp1O5EiqTIF9MfqU=
X-Received: by 2002:a05:6808:6f87:b0:44f:fc93:f612 with SMTP id
 5614622812f47-45379dad9e6mr3120038b6e.32.1764916785070; Thu, 04 Dec 2025
 22:39:45 -0800 (PST)
MIME-Version: 1.0
References: <20251205005841.3942668-1-avagin@google.com> <57a7d8c3-a911-4729-bc39-ba3a1d810990@huaweicloud.com>
In-Reply-To: <57a7d8c3-a911-4729-bc39-ba3a1d810990@huaweicloud.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Thu, 4 Dec 2025 22:39:33 -0800
X-Gm-Features: AWmQ_bmnaGxfuYW3uI63fXs7wkN5Gs-TsqIbCFxvBK_--CTpOzbn9u2q1u0Kpoo
Message-ID: <CANaxB-x5qVv_yYR7aYYdrd26uFRk=Zsd243+TeBWMn47wi++eA@mail.gmail.com>
Subject: Re: [PATCH 0/3] cgroup/misc: Add hwcap masks to the misc controller
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: Andrei Vagin <avagin@google.com>, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	criu@lists.linux.dev, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Vipin Sharma <vipinsh@google.com>, Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3ED6E80002
X-Stat-Signature: fpfmgsuh3zzz7thwfd8nosjac3gtqwic
X-Rspam-User: 
X-HE-Tag: 1764916786-679384
X-HE-Meta: U2FsdGVkX1/G0NXSkCx25hUoBU1xw9cRXpqGmjC+D4NrIWQStTG9oIfSFqq3LUOHX+3YTKEqhFmXGjsHTNGE70t8/e46uslrXym8K9chr3dXFUOz3eNsaWPwOTtVx8MFLHBe/zUMExAeR2sJH3ETrvLQV+LhcgdLSz7ABdCjaTitxt/OFDPRX7WnktsZjOS6BNMY/Lfh3wMld/sWDKsD3T+nqJxMQbUd74b2eil2FkZH2zBHlX1uah38CkzaB9FZ+KcsYZBl2qM+n2m0EVmzBuw8HgT8U1bRrLUB/oImzRzfJCDJxW79MQpGoGCKLOqpo8RIrUCWkz2fX8ZfzEQcIYb7Qt3BpXYz57fXjGFFzt/ZU9Ljk/SIUUNCLEhYo8fCSAc3OEvtB0lWQMjahLYhYOScWKvD36FOypnXgoD7OLi676jE/ILgzqUm85a/5yZdzRjipuDXAYBYcqM3u9+wPHLoSMRQZ4X+boU2XLahPVxh6n91mqlP8W9iSDn+iLv65ejyfpyeOtZ4cW32N2ZW6+n9I24VhHgI74um/RxCuHf0yvicvZUXv9SIgpRSe4ZvMXdGXGS5IThQ7JLfcmZGQMPdRN85tUDO0IyCzn/fLmVzGMaRtMmJE4vgHYkP8zd9W/ktNNJkzO+I9ZlObtCsfGBe8crgFsJg8+06aRq2GZqwaNyv0aI2LM+wkRAFW8EQOIP7chD9w9RuQgC4g5B3jo58D3JSjY6CFqYPo5qtACPjVEMvav3bzj0bCa2EYTYIurGm5dq+gu4cP7EW5VttaDJhbgXzbA4EnGZozY31rtd2WFITam8DwonPN2TgQZHdTkAV+EQPkn60f6ymDEyXxR3R+/3q+Ty0QDTmFoyfOueZzVGEngFIuLJ7zl7k9X+zxj4sD3dUYblHnH6iwOu7FvigIgd6KSwrylFlLlcCRVIj5jFq0+2DID7b1DGuZqINzKF37iOVkmOxc4JM61D
 Zb3YIWv2
 6iftvrXRIHJP29cV6onkoxDApchDYEnUIwWPXRYW82CIWzTlsEOfRXtnnUJ4cFKrL5Q6756+Ybyo2vo5BBDFgiddAd0ac6XYWb8J1ch3dQ9K/D1xeghvP9sK5df+nlWTDEw8KMyc4L/KTfcKBAwn4ZzWcwd38bej+uDdILxKgjg73n7/Wu+XVop2Xe2bKfX1duO9pKAUaDtCIV7xflvdSu52EUGgrlm/8nrtcqjOtVlzSobVhI6mRc3rzqciW/ZTAHXhfcBcvZ+BeBg9EXrCirJVhHvkkKe4/kRXkxpi0tBhTpQ/qMkuRkgNtKLV68Om26SNWnSIVQ1cyKQunHoQmcXjk8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 6:52=E2=80=AFPM Chen Ridong <chenridong@huaweicloud.=
com> wrote:
>
>
>
> On 2025/12/5 8:58, Andrei Vagin wrote:
> > This patch series introduces a mechanism to mask hardware capabilities
> > (AT_HWCAP) reported to user-space processes via the misc cgroup
> > controller.
> >
> > To support C/R operations (snapshots, live migration) in heterogeneous
> > clusters, we must ensure that processes utilize CPU features available
> > on all potential target nodes. To solve this, we need to advertise a
> > common feature set across the cluster. This patchset allows users to
> > configure a mask for AT_HWCAP, AT_HWCAP2. This ensures that application=
s
> > within a container only detect and use features guaranteed to be
> > available on all potential target hosts.
> >
>
> Could you elaborate on how this mask mechanism would be used in practice?
>
> Based on my understanding of the implementation, the parent=E2=80=99s mas=
k is effectively a subset of the
> child=E2=80=99s mask, meaning the parent does not impose any additional r=
estrictions on its children. This
> behavior appears to differ from typical cgroup controllers, where childre=
n are further constrained
> by their parent=E2=80=99s settings. This raises the question: is the cgro=
up model an appropriate fit for
> this functionality?

Chen,

Thank you for the question. I think I was not clear enough in the
description.

The misc.mask file works by masking out available features; any feature
bit set in the mask will not be advertised to processes within that
cgroup. When a child cgroup is created, its effective mask is  a
combination of its own mask and its parent's effective mask. This means
any feature masked by either the parent or the child will be hidden from
processes in the child cgroup.

For example:
- If a parent cgroup masks out feature A (mask=3D0b001), processes in it
  won't see feature A.
- If we create a child cgroup under it and set its mask to hide feature
  B (mask=3D0b010), the effective mask for processes in the child cgroup
  becomes 0b011. They will see neither feature A nor B.

This ensures that a feature hidden by a parent cannot be re-enabled by a
child. A child can only impose further restrictions by masking out
additional features. I think this behaviour is well aligned with the cgroup
model.

Thanks,
Andrei

