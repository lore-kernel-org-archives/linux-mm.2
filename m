Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84246FD45FE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AACD26B0088; Wed, 25 Feb 2026 19:52:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5AA86B0089; Wed, 25 Feb 2026 19:52:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911ED6B008A; Wed, 25 Feb 2026 19:52:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E1716B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:52:20 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16C9A1B61AD
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:52:20 +0000 (UTC)
X-FDA: 84484781640.04.4D42DDB
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0ADEA140011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:52:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hmHDONgw;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772067138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tit/ZfajxqvE3xISUpVUeXJRv5DgJC6ZdqyR1I2SKAc=;
	b=5as+6vtlf08RuIekdK467SUIBpf5WXyX7kuUDVqlFstR7Kug9rEls6aVUJoj+cGoZCiWX3
	fjLa0fuIDLcsa59a1k26WIoZJ8tHCqyX+4WjrliDIAnNQNItBfYk2+QKTmFenBmYroE/HY
	OLUyCXfRf0UI3sdJb7J5cJhBIVkILXs=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hmHDONgw;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772067138; a=rsa-sha256;
	cv=pass;
	b=2mjGWYDt+59PnFEhDeFWRJXCbqYlFsoYQlMUKYCwF9g3mnLK4VstBWYA6PNYhk9ejY+vr3
	fLYD28plEbADC+zCJjTYj43thGf0CxjVRVNaVgai7spvyZWc8GEFq1m8HS746AYh9EwoMN
	Nvy+22AeWOAJ1+LYvNa8I/DTx82u6kM=
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5637886c92aso236818e0c.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:52:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772067137; cv=none;
        d=google.com; s=arc-20240605;
        b=EqlbW/R4Z6ZcAEDrxX2e1XVHelW/IK5itvxJx49yefyPI6RJ4LetI1I/xJ1cDcGRkj
         MDulZOXfXcmmuz1QzXviGLavHjJHDLebDOk1G0U0gGJbVu6y4AaEMxjxeMyRhuCRvAXs
         c3BcSjNCYkoCIWAPlB4ihXRv4ClntcylFJuSB9O/1sm67q6GBNb3TNnwRxH0Hjb0YHZO
         awK3BSbvsGpzBE/9h4KD4TC4dqlXr5lkU5FUC2NfGhDOLe0LR/mGphUFsW6yPe4koBF+
         xg4ZlgFfspq68TSF7mcOwFZLW+d9U8pJZgmB4h6UiLnZK1y3dFwfhxb7NrcNB8+++WDQ
         /lYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tit/ZfajxqvE3xISUpVUeXJRv5DgJC6ZdqyR1I2SKAc=;
        fh=jKH0qIap7HPcc66WJ9Hk9luW2EUQiQKwA3b+psUzHkI=;
        b=ZghHRWISd8Xu8Ld9454iqVlrKOk4DYqB58NHTLbww38NAHajn3Jua1d94NpgjJzt3M
         TKKagE1pkM0g7imOzXq68a2aaEJw4I/yaHk7xiodPQKeiqfQXKWbXhlVDkWaa6umnkT3
         wCkUyZmn09exFgkjxVbjcMjZlkXY96GLzdN3jOvcmXcU6WSz3BQEBjKlLe1Q6pJBYyCi
         N0rNl60D2+AIYHsi/drLNIG/juY7rqWNs6tIvtJ/W7LubDTzxPWSdJaa2RqSWccHlURP
         gRaM7eGtSVjRshR5sHymtGk3FFA4eUWT/h9hKgM2H7I7LsPvkcXAMAXHMAn6r+vKOd/R
         Si9Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772067137; x=1772671937; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tit/ZfajxqvE3xISUpVUeXJRv5DgJC6ZdqyR1I2SKAc=;
        b=hmHDONgwh4YZVo05H79SKsUmF46682GHRj38N+DF7t+esD2crS7e88PRB3w8SWfVCl
         NNeIbCxLC3Ti7TeQIIeCcDfrzzxq54gQxGGMNO1zpuMGiamFRM7OGUBhGyTtAjjkyAAR
         di4RWM45mbj/chZAGFi4KB7ZDY5mgwQaR4saHaLGZ3kIuyAxF/Pb23tDxzu/B8jO/trc
         PUodrugroNQrHEVkP7gGEic8oHeAg71LPlMlS+0UKXxsnn4oCGz/pY9xgxOb4fjV3sgF
         wUZ2EvpBv6++JT5vVnZQZxvpzvKMDpgMJUwc0Loe6l/9APkNJ/L++xfPx7RAXZkgwVhf
         BtzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772067137; x=1772671937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tit/ZfajxqvE3xISUpVUeXJRv5DgJC6ZdqyR1I2SKAc=;
        b=u2V033JMHxKB9EYbHZ3erNfFMeIs5trzsJoqaCxdscn7JsRM22mDs/9CzeHXBq4n5c
         qy4JLxKbqg4FX19ItCXhTk0446/i6NfNlLz/I/38JCpikAl747DSTHRYHGalE9lKA0E9
         Osz2ZwXIlwfEcfOwnmDKKfYO4wBAMDvDUkjOLGNhyABuzjRPNlllgOtUeXtldvj7fthy
         IwsYRaHCj0ca8VGLui2mB3B5RBaBg1YOVV4+/llY/LaUaWV/pvx3UmlPtOhAuyeV4RhE
         +ZOeOoEaSt/vqEf8KvsqqGOU4qk+xAjAzV+LPxh20JfPd7E66EoGCiS4sVzEIM26D9u/
         EhKA==
X-Forwarded-Encrypted: i=1; AJvYcCWOR7xfgknCmgkEF1ptKqK6Iaw9YVTTwFw+xE6ItWwy9+d2dbyTfcVm5O9xSsE6QnGb7WeOM83vyA==@kvack.org
X-Gm-Message-State: AOJu0Yy72sCUErbzMZqpTi1bGVMLxgt/ApkYixBvpDELgtPAuPWaGgc4
	hgC485BqxE4LPWC6Ch1u6uCOsYnenGC9+YMK82C9weC0yYcRfRdwO7ljuDCZuj4qDFvUE8KWiUN
	Wj7JZrUDn0NNo7PHbJ5g0LB3riesetv8L19D2ns4e
X-Gm-Gg: ATEYQzyLP5YFikh+36oxyiVNQqB8wN0Zzjb1wY12zmUlA0kRJPALCSBl/KGclUWl/+b
	TdJZD6MXKUZyzTU8kI2XGR5hFObCdACin1blucppPbtNGPtpBk9+DwUO0EQbygWrdNLIx+Ukwcr
	0/lJj2qKSMTwUrqvNOEWO0h8/UvRwYtqJ4lXzjMf33RpJY9we18q60pXfqlXy/mwrGV8azqr4fI
	VLGY1FfYZcJBwCuHHWnh25Qp0guF3bYRq+4fyqPXddI48oOIhu/WuwLERqlJbZqoRXyU5RVmOrW
	Cer0Gnc=
X-Received: by 2002:a05:6102:3f0d:b0:5ed:f13:e58a with SMTP id
 ada2fe7eead31-5ff1419f7b6mr1037473137.37.1772067136513; Wed, 25 Feb 2026
 16:52:16 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-10-dmatlack@google.com>
 <aZ606sDJxtfNF6qW@google.com>
In-Reply-To: <aZ606sDJxtfNF6qW@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 25 Feb 2026 16:51:47 -0800
X-Gm-Features: AaiRm51I1tTdJRO5CbbBFYwdOmR4S6VSPvkujC59eyupuwvOv4iLZLnGYRmW3DQ
Message-ID: <CALzav=cH0-qqQJTOjDD7pHzsFeZOir5DoC3f1hhDg=jqK7vdgw@mail.gmail.com>
Subject: Re: [PATCH v2 09/22] vfio/pci: Store incoming Live Update state in
 struct vfio_pci_core_device
To: Pranjal Shrivastava <praan@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0ADEA140011
X-Rspamd-Server: rspam02
X-Stat-Signature: 6cs5qxuheyeuhs4oiowbaj3bfyia8d5k
X-HE-Tag: 1772067137-839169
X-HE-Meta: U2FsdGVkX1/MOmOwxzM3cHAoTjFiFUnhBjGwQ3LrtiZSc8NQYozId6kdk0Cy9w88Lp1CAbPnNsX+/30PXg1mMUaI/5UMx/1nF3+NKqafTTUOqyHtiukyCWn/6VNAWxfoEYnvuRNBv8O6dDB7cAyMKFs8NvVYpTePcyQOJF2fF3jX7+evMI6H76vCHFPQQGSSeGQZ5tAuTFBqB72csN1uCaAQyBAlVjeV4/UDRXvn6yZlOwHKj9qDp6DfsfzkFTWjexR3+c410qkWGutLexEKgbs8+mQ+tk5Zge++JA1vxas4ZuiEus5ygp3xgu2xqjkFXoN4/duo13erqAXOgPsmvPYrFk7WWgKSDc5JQnjfuvmwJ7/Cnluud3LHVj87lmtqc3HB/EEkyUBu7vNB+lFO5SmZYCTpQ9KjBudh5WNgQ55sENle39ZmB7ngBkfzrr0wvsWFU1Mj3OQkWZdyag2omCD0Es1+8DDMrVga02sDjsJeK74E1FVYmnywWvongvPKuhIaVq7DIkE0mXpp2XZfVkyl0zrisC/jCipSXt4TVh86BQP9E+4GVFEUVt3pLgIpvcdgt1nBMIBEf5D68W8wTz4zogGMhJiOAqbhhSNIX9wQQFy6cP3R0EnKsyCfMl0jnWIuMGUpm6Oig5shVMNL6QWkCBrDL4gLZLf0zzn0VPZ39ZvTX9ZTHdNsgxqJIuYd2DJUQA0v9/wwOEpWXx7EKJY0oLNAkunDcmWuyaEkeDf4yWqFTngPDGUUmK9d/1k3Gry399jFXscTFdDMp5TC/vy+7Ore8odWUO/XUuH9wZLO0H3XrcxS6h1Pgf0c3QbunIlsSl9PIEuGX9oqCvddSCbSugAiKJ2gL/Zqyz5VrBia+ZlwAE+Q+L+sOnOzskINKmFy/0Q1qRYLROilRRzsyVdyMONPk6u3cMAqBxyjIJFdu7JY2wmextfmMJjCcOPaPQB5i7RLjoPWWfU0ViO
 JXvyq0dc
 9werCuO0d23Msuw3OsI3S65xT90yvHm3+xH23SfOPLU989DK7y5pAiQr7zioz16hCUKALz+1sGItV3stkiVNljT6dWteKZyWSyjtGK/qSAX6vlx9xkaz/tvaYRcWR8VEZSzoe4wCTrpK0YXyP3kc4aOu2+2s66qR2ReBc+8OXjf2MdvW+2MBlMV/GNighovjmFn4OMQq7lAY0swnL/cPRnrDh737cd/VcRWYAdb6tPqROqwvC6K2aj6YZRl2lo5DtqHdmaHN7rliZXA30mC22TZxEZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 12:38=E2=80=AFAM Pranjal Shrivastava <praan@google.=
com> wrote:
> On Thu, Jan 29, 2026 at 09:24:56PM +0000, David Matlack wrote:

> >  static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_a=
rgs *args)
> >  {
> > -     return args->retrieved;
> > +     struct vfio_pci_core_device *vdev;
> > +     struct vfio_device *device;
> > +
> > +     if (!args->retrieved)
> > +             return false;
> > +
> > +     device =3D vfio_device_from_file(args->file);
> > +     vdev =3D container_of(device, struct vfio_pci_core_device, vdev);
> > +
> > +     /* Check that vdev->liveupdate_incoming_state is no longer in use=
. */
> > +     guard(mutex)(&device->dev_set->lock);
> > +     return !vdev->liveupdate_incoming_state;
>
> Since we set this to NULL in the success path of vfio_pci_core_enable()
> I'm wondering if a failure in vfio_pci_core_enable could cause a
> resource leak? Because vfio_pci_liveupdate_can_finish() returns false
> as long as that pointer is valid, a single device failure will
> perpetually block the LIVEUPDATE_SESSION_FINISH IOCTL for the entire
> session preventing the LUO from reclaiming KHO memory.
>
> Shall we also set vdev->liveupdate_incoming_state =3D NULL on the error
> paths of vfio_pci_core_enable() ?

LIVEUPDATE_SESSION_FINISH will also perpetually fail if userspace
never calls ioctl(VFIO_DEVICE_BIND_IOMMUFD) (which is what triggers
vfio_pci_core_enable()). Or if that ioctl fails before it gets to
vfio_pci_core_enable().

It's not a great situation to be in, but this is why can_finish()
exists as a callback. Userspace must properly and correctly restore
all of the state in the session before the session can be cleaned up.
And the kernel is not going to handle every possible edge case (some
files in a session are restored but some are not), at least not
initially. If userspace gets stuck and cannot recover a resource then
userspace will have to reboot the host to get back to a healthy state.

