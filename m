Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A1A4F94CA0
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 19:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9D136B0088; Tue, 21 Apr 2026 15:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27076B0089; Tue, 21 Apr 2026 15:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE196B008A; Tue, 21 Apr 2026 15:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA8636B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:03:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39956161130
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:03:24 +0000 (UTC)
X-FDA: 84683486328.22.1452953
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1EFAD40002
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:03:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P8kjIKPq;
	spf=pass (imf07.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776798202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/JJh9D4iHfbIL7VgfpIvEFwBxZt49NSTXxWwWS0h9Q=;
	b=l1rLbgVb7ZGYK+93zagXLFbzLX2SKb5bOQ0Ftabhpe5lPl2StMag8SJTDjmH7Xv21TqhpX
	Hf4BGGqt0vtXbZxHQAENalIquHbMJ6tXetZuf4DSiIIBCakQhaF+NABiGkLJfLRIf2weFX
	iBfu4jhWEjgx++N1VzsIMQc4G09rEOk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P8kjIKPq;
	spf=pass (imf07.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776798202; a=rsa-sha256;
	cv=pass;
	b=Zpkxrb+6uKPLjEAwfdYkoU5R583nQg42U/70gzd/+ajsCAa67qeCFodhAnPFgpgD2GYwQq
	m+ZFTAwOWN9Sz2M86xzU4RzNlCLwRCJLJltIsMsimKVBgpsL7/QvwiaSlEWujrnWUbQrZp
	0UhT6F0KyIhlRqVq8IRebnzi7bgVPsw=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-38ddd8d3b7fso35583541fa.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:03:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776798200; cv=none;
        d=google.com; s=arc-20240605;
        b=X+FleBroa0ZoBSArc4VmFt7wauvtL0vNOMvmW49l+CEoxWxF5C0tTKeMDeXK4sdg+l
         9X6cUrdVkK1M04z6EguJCOflGNGx/xAfxkeFApok19gbJLSLaFWGa4jm351bIZ8go6rM
         RkwgPZsakaUYXhyEUmpjewaXcyFj+8knpKg68k0an9RZgl4yL7vzTQI7v6gg14Y1omZh
         3XpqKwHwKWf/tckzD2RwoylJevq3guTsFl5kG/HdgboYJcHMHCniYgkcOTd710+ekeCm
         bkY29I2chDGb1qW2rwKuLMrTMSgRurXCbWAM2S6ri1AttFfJ/SiEFaimOZHvY75aQP3n
         Slfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j/JJh9D4iHfbIL7VgfpIvEFwBxZt49NSTXxWwWS0h9Q=;
        fh=Lc8KUHQiV3/MtVQ0rPFkZ0TOzu7cGIr7g8hfFvb6Hmw=;
        b=cbBLVDTKASDFSzEMP7Db4QBevzvftDg95B+ey1RDidjDNQgxvKJoBX1QixcuKxEUNs
         lCCgdPsP5JTquUlrFbDVm1DGvog3Hw+rvc7MfPGwCkYRGXzBrS+qnOACQ/g0ZVC2HKZ3
         jLZJu/FYs23zWmKYNOlAi2T/NlaIK1V8Z/avPWDc+CbumwdKgFaK1B9pRFMkngzWWj98
         EXVh3aQ0YNcZYX+gIGZyq6eirOOSDryhToKoP1ZZH3gpxz7FQvl6A+Epg/Ovq0n48w2W
         /2T8QqpHo/bcV6dtgfZxefox8U4fu/qFshW6prqq8c7QP+anTPmSI4JD3AKEUBfbBKUJ
         mQgQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776798200; x=1777403000; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j/JJh9D4iHfbIL7VgfpIvEFwBxZt49NSTXxWwWS0h9Q=;
        b=P8kjIKPqbCI4Y4U2Y8yPv6Ww24jYHclpclNAuo3Im7W5aPcoi8a44FzE1DDxNpxS49
         ExpJ82S+H4tuDPkWlDezxCoy7D5LC5HBTFbKv6WaMsMgL8Rqv1cXJxqLC2g9fijyytEO
         LBxesSCNcyK2x67+CCDx3t/YjWjYqMKy2So8RxgFhaFWW4tDF+uxqv8Epa34rEGErRC+
         dt3unBK0Xn3FRl21r4PhlvbKuWouGG3WxgeBiLtWnTwY+VCxQNC8+F++OC6OuvchZFBE
         sHzgGUgo6cbjE26qerIREbnJrMSDoyZOH/0CzajXYXKFqLL78vEYsJv5fVdZrNTbdkY5
         FYKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776798200; x=1777403000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j/JJh9D4iHfbIL7VgfpIvEFwBxZt49NSTXxWwWS0h9Q=;
        b=jxZkNR7jfyRIbLfiyHxhDDpPEzzoLBpNqumpXtQGKC9voBhSpreS5HAILLUt4z5V/E
         LRl3gI8HUOaP8oXm1kXXPVhz8hcsBGqBauGF1zDQ51dovfF+AR2Puu+dJKMZP+g5lwjF
         H/+Blq3lcOLeYik7/nxsRybFP6XjChP8PQSAPrHpCyZN+yf7tmYlaejfahucowzO2NjQ
         vm2kMlS5M/EwZZFyEdH6sfkMLu+jE7272I8U1Vz5iZlx7BHpz2b0WN36a7f3JCxjuwy/
         fb60hByJnJq2hRzAKW6rW0Z3wNEHzlBdDnH9vKnUWZoZyUvOT8cJCtI33PClyMkj5jIa
         ubzQ==
X-Forwarded-Encrypted: i=1; AFNElJ/U7mUA8sDxzj8LaXfQYXhWGGL70PEz3GfIlfPBqfOD0a/GPW8XaZaVb4siwkKZnWcynfKyrqisdA==@kvack.org
X-Gm-Message-State: AOJu0Yxqd5lRPVhKX0SKtGM1RrZG8jdDp8qX6vm6g4V+IQdon58ai9y/
	Ysc8DgARyK3KpROdLjOBkGiT53fv+ACymgxTZU7X3mCpv6aynWO7ERupHpBT/Izl17FAT+JqoY/
	8dh4cD7oKQ/V4ok6p2ScbC+LAICrpSGPX/T3YU0p/
X-Gm-Gg: AeBDiesZOYQUA9u3LOHMtZRwLkpZaRNMHbaSrIsY8mNrQU019XplSgKKkgHyZEiR4yb
	GVq3KyxVeyp4auA7d6SRi2jzNHp46DNC4qSiGhaMvpq9OTh0C5FQjGuk9IKytR+iM2ahFJQuYFD
	zJHx/+kL9AvYrlZCs2igtq1gW7/1/b6eHA/MmxpG6Vo4s8aSwiI5RP9Sj+YmcKewrCwPztnUPYT
	YfcvhvNeV/r6LOAjisbWsyE3HObz0DKCTFNu70e1evS7IiGo1KE4gI4PiMpO/aUpCwlct28UNmD
	4zt2Wg9cV2IGEzfdY2jn1Xx7zi62rg==
X-Received: by 2002:a2e:a913:0:b0:38e:21bb:b2ad with SMTP id
 38308e7fff4ca-38ec77fb34amr60020221fa.2.1776798199609; Tue, 21 Apr 2026
 12:03:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com> <20260323235817.1960573-8-dmatlack@google.com>
 <CALzav=ehpWA=XchL+XLZuaYfYmBTPNWDYt1W3LFY5-6+US4E7w@mail.gmail.com> <20260421184433.GG3199414@nvidia.com>
In-Reply-To: <20260421184433.GG3199414@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 21 Apr 2026 12:02:51 -0700
X-Gm-Features: AQROBzApHbC_QwlDNMpyz8z8DrBINgdkBviaRKsddB8iPIY8E4-Zx9sb-aAKTZM
Message-ID: <CALzav=cFarR4q7NugCxXwCW6wnyU9dJRaaTnxs7MY5ia5SDJWQ@mail.gmail.com>
Subject: Re: [PATCH v3 07/24] vfio/pci: Preserve vfio-pci device files across
 Live Update
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Rientjes <rientjes@google.com>, Feng Tang <feng.tang@linux.alibaba.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qngkbwzzowhbuxsiphex7f3ietpqm88i
X-Rspamd-Queue-Id: 1EFAD40002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776798201-728696
X-HE-Meta: U2FsdGVkX18O3VbazKxm63LxCsvUrByOtsToZkDUSEq3eUC4qUP6pdW/9TghiZwgJOUcJjpzHK4BwpHZ6AivFltiunDQeKm55Xpn5JfsWO9wQWNkdS8Zxu1gd6hKBmd+gZLOIO5H1uGeJFt+r9wQOnH1He38lGphrXOzMe/X2rgcKolFt3oeT8XkV6/l7uttiYRyhG+UIcJ9WnWiMIKMgPqdrLqQhLFsciI427lziPNWrvD3IXh3dpjWetDNTUuPOxQ2qPSqAJG4cwWv2mdmDo1o6FQvDKDUghA6Uhi6zytgtuwVOxW1wSAEshzCZHSLbWNv2bK8asKtRv61HqVCMfF6pFM/u0YDMCyyODHtNUUrKKPv28kZ4ObStV4K4rNlJVSd4o2I4DF8WLUmYAMFfPp+0nvh8gFdfrNxubn79MM7Z5hvHAI97EG1izDZpoQ+lL1skx+qbUYsvJAKoIelgEdsAef2XXNnGR2xIT/OGnM+MXryD+KVykKp7b6609VShDg74dG3ytavkCFPrtTUVYIk6zXg+yoggjXhiMGPwyQ75WIljqOmSgyhYWB27K1XN4KTfokN/KGHM6AqS+wYJeDJg9zuRePWfJpQBtFlOElESXsbQLI6a7lCBpMEaCYk9qEUKqkjjyIIZ0GBhxa6KfP9owVXGw12X1xAlH0VpMnrmnZuXB6A1loyOP/XLFeLGCensVCqYifq8qn6x9PrcI5Du2/sK30vXwxFPDMlama7FGHCYZTGgXEUaWDFVogVylKr2mwdDXAAaHIm39yUY260OidEp0LwXIY0PpeIWaBdY+Oqr2ksVGiymhldOEtff6seq0TO0nucseS3u/ikZzx1fXlXRPaAuFufQY2fw+m2MPc+BN7aajaoEgdYbLApI6rP4QDXoW7HNp3Ld/bEIANF18Gurb5liXR++VJGIlFkTfqmzDiEXMZKgztO+9VjRlU4mBOvX3Io0f1LdTq
 QnlwC1WN
 DL//pLSAoS8pE2gmWG0/xQ1wMlrvvF68uMeHZ3plDsu8bNMqw6VUyCByfjxleDOxm2GMNDnOzr61lXEHGVxGYgnsQ3rhb0OK4YIudAT7aGCOK+lbo9kh1NWmcCsD5ayTGlQOL/8PxBjcFHVQXFWXjOaQsM38oCzuEhFz1mKzzswooaRaTsHcF4N4bhaxfRO7KUHyp4TuTB+8lCOEOkA7cFmMlG4uy4Dm1EeMzP53DTSrZ/EOOsAlornX6UQwM9A9tw+UFgShdVMVzh0tJxSh/IV/ZI4PZ/BIy0DxQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 11:44=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> On Tue, Apr 21, 2026 at 10:40:29AM -0700, David Matlack wrote:
> > On Mon, Mar 23, 2026 at 4:58=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> >
> > > +static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args=
 *args)
> > > +{
> > > +       struct vfio_device *device =3D vfio_device_from_file(args->fi=
le);
> > > +       struct vfio_pci_core_device *vdev;
> > > +       struct pci_dev *pdev;
> > > +       int ret;
> > > +
> > > +       vdev =3D container_of(device, struct vfio_pci_core_device, vd=
ev);
> > > +       pdev =3D vdev->pdev;
> > > +
> > > +       guard(mutex)(&device->dev_set->lock);
> > > +
> > > +       /*
> > > +        * Userspace must disable interrupts on the device prior to f=
reeze so
> > > +        * that the device does not send any interrupts until new int=
errupt
> > > +        * handlers have been established by the next kernel.
> > > +        */
> > > +       if (vdev->irq_type !=3D VFIO_PCI_NUM_IRQS) {
> > > +               pci_err(pdev, "Freeze failed! Interrupts are still en=
abled.\n");
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       ret =3D pci_load_saved_state(pdev, vdev->pci_saved_state);
> > > +       if (ret)
> > > +               return ret;
> > > +
> > > +       vfio_pci_core_try_reset(vdev);
> >
> > I think a call to pci_clear_master() is needed here to so the device
> > stops issuing memory transactions while VFIO is trying to resetting
> > it.
>
> That doesn't sound right, reset should always work..

pcie_flr() calls pci_wait_for_pending_transaction() which times out
and prints an error message. The reset seems to be working fine though
after that.

>
> Didn't look beyond this hunk but why is a function called 'freeze'
> donig a reset anyhow?

Disabling bus mastering, resetting the device, and restoring
vdev->pci_saved_state in freeze() is temporary. This allows us to pass
the preserved device to the next kernel in a safe idle state. The plan
is to remove them once enough Live Update functionality in VFIO, the
PCI core, and iommufd are working.

> > Sashiko also wondered if pci_clear_master() is needed to ensure that
> > the device has bus mastering disabled during the kexec
>
> Only devices that are not being preserved..
>
> > think that is actually an issue. vfio_pci_core_enable() makes sure
> > that vdev->pci_saved_state has bus mastering disabled, so
> > pci_restore_state() below here should guaranteed it is clear during
> > kexec.
>
> .. and bus mastering should not be disabled on any device expecting to
> be preserved ..

