Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 667AD104891D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 22:36:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A96EF6B00B7; Fri, 27 Feb 2026 17:36:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A455E6B00B8; Fri, 27 Feb 2026 17:36:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD136B00B9; Fri, 27 Feb 2026 17:36:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E74F6B00B7
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:36:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 223D28C8CA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:36:18 +0000 (UTC)
X-FDA: 84491696436.17.87DA685
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0655A10000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:36:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r6c75sIX;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772231776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNS9W6SZfyDIUc8hBvcmHVCCa8aXdEVnnS9qGJqvemc=;
	b=g2KX/7DW5iaBjzfMNLQ6FS0n9jO3QfsD/koJOtc5F0oi1LU/OYtpXa0xaNF3Q64u1brkYG
	37aKd3rwX6Cf/S5FwGfJS+q8dB1LkeNyzyw3sWc7eKQecmkNuPi6S8Q1EebBTZ1gxP3vuX
	XqRDzvqTxXQkPWIC0GLMx0F55cC2f2c=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r6c75sIX;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772231776; a=rsa-sha256;
	cv=pass;
	b=bOUFEcGIvtxxdt+eThFPs67KcXxcbkvMo9ERE7cRvely/1r2585b2hSqiwNGaAOMm0pexG
	zqwYP0G7+xf2TDFP78pnSZ2npZXHkxXpifvSGspfQtDFDwdbKzzVd58qsKLUOA1+VRCOM0
	FV3eOE7/wydAyT7GjfEobCVkM4YHR7k=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3870778358aso6250341fa.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:36:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772231774; cv=none;
        d=google.com; s=arc-20240605;
        b=OGkb9fB79TiHsC2pnsL5QyFZ05GrF4lEDziRqa5bI93v72pCw8cx6v1nO5MROWovj0
         SYNhYoNUbam8KtYzVh53ikdfbP3A2QdpKRVGwnsFGd9IeEbHV4H8D9eOSJD0SD0k9OzS
         2Zf0ZLQzyA3URPAeFI/uK0QVolPFa632bGsZvyjJkuFFFWe4yhceTOiDZ7P3p6532D4O
         t6iIppThHokauGYo2hPdmkjZX5zUOjxwVITVoXxrISFmVeIGEMZtXhcmBXKWFDGcqy6u
         o5sQRIyinMnp/UxJijA1UpskbKZVJI8Y8gRVtmlexRN3l8wWXFpHHz0zM6QHFe4YmQwu
         R5Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QNS9W6SZfyDIUc8hBvcmHVCCa8aXdEVnnS9qGJqvemc=;
        fh=HcqL3aTYBLe7cHEWm20J01sh9c83nVqfH33ltVRPslE=;
        b=HVyJWJ3OnvfUG9bNsCfoxXKzQS8W0OyTT85QTbBi9e8kJbpAsIgnU8ylsfq78eH91n
         1HIYommDMZYl8hHcSO0DbSPdJLi63EPPenuTDWs6/6Ay1eFnXpT0NKVyszhZq9eOeVkw
         d/mLvFsDx/w4CSVp8YB5MTHGgwIYDT3Y5nVXGdfS7z/qz8kETNx9x2qYQLjneukGlet4
         VL1oWIClaLb0k73/ZirjuTaXN1FOjiZxuCxyksALEFW2km9t9CXGKHA7MQD6kRx8knog
         Wu6LjiqBFBoIkHW6OLJWJEYx1thNHJPzrCbyzcXSNAvtDJocQZj5mju2zBoB7pPCweaJ
         /8nw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772231774; x=1772836574; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNS9W6SZfyDIUc8hBvcmHVCCa8aXdEVnnS9qGJqvemc=;
        b=r6c75sIXMGGBXcNNaTJxPhYGBAP6uR99rB0IL/ZDT1MkelWBWrmsV+upkS3OFxMjQI
         oYhS6OoC4M+q2coiCC/AngRLhTSLq7+SBoE9J5GCFy0xvd9F0xDunpVyhAZ7POKxBWYy
         p82m9oEAgksQQAptf/6UWOzb6nkpSmld4UVWMd569TnXDOmRgb/fHqy5YPUIhr1uXL3l
         6N4LdOBJE5lxXJwyY6npOS3NMdx68NOh2kM/TgE/Na/UxKqC+yERci+FIAgt9JHIMNWb
         dkg0eESel049S1Myp0rF+ULBLgIRI4MSJT1oKvDyCDfqMUM5sKbpbEx6404EXS8zxbqO
         wN9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772231774; x=1772836574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QNS9W6SZfyDIUc8hBvcmHVCCa8aXdEVnnS9qGJqvemc=;
        b=Io4tumNAIAGbRMNhd8bSl+qOGM1ha18FC7xKZuaMNK48zujfhTkHGLIXjOYvU+0kap
         /smCBRKF4bflaH3G0luw32bsFyAjPO/CMtZmTT2CdJqtel//YmEiyi3tKMe9Hzl2etuU
         siWKnnPbo7v6AKoB0s2wlXX9VenXKFcIFv8FkiAEcXFyFjlaij458EgFKlljXlYs+SzJ
         4avlhCFqSMWTG5oaA8LsWJU+x9CJYhQr46wtq4uqgMY0ux6zGrSMJ+PnBybY0OW8/ElR
         kqFYqPSnWDMxprR9zJRmG1gMPaGzVkRnMENWWBIW15ZbTZqtn0qFRYjkX3yLBYHH6SyC
         YJHg==
X-Forwarded-Encrypted: i=1; AJvYcCW9Rp3G1Kma9sS8Jlyh5iFipXBrVXx2Fm3jkbWrdTNzUQmgmZfSQ9c4+yORY2isJqdV1gCUz04uZw==@kvack.org
X-Gm-Message-State: AOJu0YyIE+d0IG2J23fzzbGW+UkoqpL0JHST/hozYEze3SgS/7pvaQ/E
	4QXOp8p46gdYTUUy9LucwzHyXOyP7IOhys2v28Oj/9vvVPmmshwp6ZMTmiuxhuA1UDdCzmTi+9w
	Xrp6qLCdxlW40CKg7hYjMGM6+n9WuRf5d+qzdQFW+
X-Gm-Gg: ATEYQzwAm/zLrA6wRILW1Io99qP/37Jq/7CaaY08rHP6Gg7BxgKwBkh9NYDuqWBNgZ6
	1ygo2grJztr7dX4qclc3XpVWuKa9qtH+2bZ8EFGwdj5ogBiv6M9K4XglhhTnY/Sc0Kpe+oCZ+KX
	sUvnSFPhn947XsBsTHu26dgguq7xmsBV7mbb7XnLWE6gFTnF+Q9azZbW9OjNCkZYXwVydWX5W+T
	20a5KNzIeDlG6Tzds3Gm2xGt78DNPj2IOrYjiONIuzzQLoBki0wFsfwFMG66+A2kvS0O0KNhzaq
	mdaQELw=
X-Received: by 2002:a05:651c:150e:b0:384:9355:6a7e with SMTP id
 38308e7fff4ca-389ff144dcdmr32194241fa.17.1772231773691; Fri, 27 Feb 2026
 14:36:13 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-3-dmatlack@google.com> <20260225224651.GA3711085@bhelgaas>
 <aZ-TrC8P0tLYhxXO@google.com> <20260227093233.45891424@shazbot.org>
 <CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com>
 <20260227112501.465e2a86@shazbot.org> <CALzav=egQgG-eHjrjpznGnyf-gpdErSUU_L8y82rbp5u=rQ83A@mail.gmail.com>
 <20260227152330.1b2b0ebb@shazbot.org>
In-Reply-To: <20260227152330.1b2b0ebb@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Fri, 27 Feb 2026 14:35:42 -0800
X-Gm-Features: AaiRm50D90uQBM2OzGa-RA7PnZi6CheC4aDHB2jS6rwjE4obcECpnTV5MTFBKgA
Message-ID: <CALzav=fq-3J4WFD-uNd5zJ_Fx2sHGv0vL+EtpV7WvGO8ddG5mw@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: Alex Williamson <alex@shazbot.org>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
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
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0655A10000D
X-Stat-Signature: f91husx9tf6zarud3u1tcic7fyjruk6s
X-Rspam-User: 
X-HE-Tag: 1772231775-699078
X-HE-Meta: U2FsdGVkX1/BV3hTVAw8hvD+XJ88FlLFM0LitSthjRMtQcfPMhKE2WLDSp2Gs9lnEOtlGTmwuz4DmafiFS2TswiitCa2f4bMpBDZ/eeOH/nqJusqS1keM7m8SmQo/DgyzsE25X5eWsLTH3Tonm2gf/XiCttFE5zzx3P2Ui0xRpPwnShhQsnr+OGC7nbM7bBBYP6x++mJfrXZhg4KMyONFOb+ac2SIvEv9b9L7ORBU7FpDTNW6hKRqoX1s2Il5VdxzaGh/vV8ZdBl0t+zbf8q4+Bf4wHeNzX3XSgoC1/R3Evga4ycxNjI2oefNcYE61cQGZRLw+O8rwcf8uyi/0eBIt/hREPIyxpzYyGpOSRlI9fHeaX584RqCLFjKwjwIOX88ZJf2Y5SW/i+jggfmGO2DenrmIDDM6YFpw6oDuMyMo3LTSVlVTM8wiawX8hNRBdTLOqOoq1B3ASXXEu1p0dQKT/HlBLxOX++pr76xV+4RegzJnh5nV9CNkOsAGQfnvQlgzoje5br07yUbD1CSaJryqEhjhLvQZB1U4ir9zdNBfa3tZ/xpoWIHhAPWo/qR9CkpYi61yIGEdgL6FbOcbFpBjbNaZyHQvrL/0yWhSa0po0NgupYlUEWQ13bKflqKfCzazZJeuGy6lIXx7mO0ADgmfKC0u12GFVwDupzRFg/5BD8LIqLk0sHfC3f1sf8RZmjPbyCuac3lsbSyFIbKNoSbevx/z9Gm7uQ6/Ou8+h7/icveZ/pxH8JLFuhVh1FlU2WPSW2a8j2PxFrBoSY1NLeHWJ2z60cdk7sDwciRQCZh1PVoq79wR+wJQp32o5M+y9yczKvvNl1auH+giPICMYnG3Z/9+612H7tHQcuZk94OdVj5Zvb7LU7zV9QFtEz7DKYMaBf9unn/BijLbyo9d0WmXeLmOUpeq5sh5tzcg5K5+2emxL/M0rqzgKKApKi4UzZmVpBB089p9y4Sqyro8S
 KEDRhwVb
 E5oTEwT7MCOne9l5dErr8OJFNKbr2CTHu1LPugswmPZlcds/h3t1npbd8PkOog1HeXxCTAa51thOFyyovlksbqrqHaju9ouCjKG0WTOu6zCjApW5H++iuUGAaULgkv8KieDfs08GWaC53ALRCbQZAIR9DRng0rezsQP6VWgPHruonjmqvPKgDK4JFbjNYQOyFC6RMZR4qd5CblxcEFeToHD5TCFhAQeITcInp328/z/2crdZR/x7kSWuUsxsf9QpUab/LamW+U3tiS/OecL/jlnG2RGw/TDIp6e2bslXw7VWBNVanbtcKTHH8sdC6Mbi0Qx8V385TfoiS2/LnsJLqh/+Nano/GYaxhEWvLwVARF7IHCOOcEeKAQET/genyTrAm9UFrnkn6GixZct39X35Sf/ibg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 2:23=E2=80=AFPM Alex Williamson <alex@shazbot.org> =
wrote:
>
> On Fri, 27 Feb 2026 14:19:45 -0800
> David Matlack <dmatlack@google.com> wrote:
>
> > On Fri, Feb 27, 2026 at 10:25=E2=80=AFAM Alex Williamson <alex@shazbot.=
org> wrote:
> > >
> > > On Fri, 27 Feb 2026 09:19:28 -0800
> > > David Matlack <dmatlack@google.com> wrote:
> > >
> > > > On Fri, Feb 27, 2026 at 8:32=E2=80=AFAM Alex Williamson <alex@shazb=
ot.org> wrote:
> > > > >
> > > > > On Thu, 26 Feb 2026 00:28:28 +0000
> > > > > David Matlack <dmatlack@google.com> wrote:
> > > > > > > > +static int pci_flb_preserve(struct liveupdate_flb_op_args =
*args)
> > > > > > > > +{
> > > > > > > > + struct pci_dev *dev =3D NULL;
> > > > > > > > + int max_nr_devices =3D 0;
> > > > > > > > + struct pci_ser *ser;
> > > > > > > > + unsigned long size;
> > > > > > > > +
> > > > > > > > + for_each_pci_dev(dev)
> > > > > > > > +         max_nr_devices++;
> > > > > > >
> > > > > > > How is this protected against hotplug?
> > > > > >
> > > > > > Pranjal raised this as well. Here was my reply:
> > > > > >
> > > > > > .  Yes, it's possible to run out space to preserve devices if d=
evices are
> > > > > > .  hot-plugged and then preserved. But I think it's better to d=
efer
> > > > > > .  handling such a use-case exists (unless you see an obvious s=
imple
> > > > > > .  solution). So far I am not seeing preserving hot-plugged dev=
ices
> > > > > > .  across Live Update as a high priority use-case to support.
> > > > > >
> > > > > > I am going to add a comment here in the next revision to clarif=
y that.
> > > > > > I will also add a comment clarifying why this code doesn't both=
er to
> > > > > > account for VFs created after this call (preserving VFs are exp=
licitly
> > > > > > disallowed to be preserved in this patch since they require add=
itional
> > > > > > support).
> > > > >
> > > > > TBH, without SR-IOV support and some examples of in-kernel PF
> > > > > preservation in support of vfio-pci VFs, it seems like this only
> > > > > supports a very niche use case.
> > > >
> > > > The intent is to start by supporting a simple use-case and expand t=
o
> > > > more complex scenarios over time, including preserving VFs. Full GP=
U
> > > > passthrough is common at cloud providers so even non-VF preservatio=
n
> > > > support is valuable.
> > > >
> > > > > I expect the majority of vfio-pci
> > > > > devices are VFs and I don't think we want to present a solution w=
here
> > > > > the requirement is to move the PF driver to userspace.
> > > >
> > > > JasonG recommended the upstream support for VF preservation be limi=
ted
> > > > to cases where the PF is also bound to VFIO:
> > > >
> > > >   https://lore.kernel.org/lkml/20251003120358.GL3195829@ziepe.ca/
> > > >
> > > > Within Google we have a way to support in-kernel PF drivers but we =
are
> > > > trying to focus on simpler use-cases first upstream.
> > > >
> > > > > It's not clear,
> > > > > for example, how we can have vfio-pci variant drivers relying on
> > > > > in-kernel channels to PF drivers to support migration in this mod=
el.
> > > >
> > > > Agree this still needs to be fleshed out and designed. I think the
> > > > roadmap will be something like:
> > > >
> > > >  1. Get non-VF preservation working end-to-end (device fully preser=
ved
> > > > and doing DMA continuously during Live Update).
> > > >  2. Extend to support VF preservation where the PF is also bound to=
 vfio-pci.
> > > >  3. (Maybe) Extend to support in-kernel PF drivers.
> > > >
> > > > This series is the first step of #1. I have line of sight to how #2
> > > > could work since it's all VFIO.
> > >
> > > Without 3, does this become a mainstream feature?
> >
> > I do think there will be enough demand for (3) that it will be worth
> > doing. But I also think ordering the steps this way makes sense from
> > an iterative development point of view.
> >
> > > There's obviously a knee jerk reaction that moving PF drivers into
> > > userspace is a means to circumvent the GPL that was evident at LPC,
> > > even if the real reason is "in-kernel is hard".
> > >
> > > Related to that, there's also not much difference between a userspace
> > > driver and an out-of-tree driver when it comes to adding in-kernel co=
de
> > > for their specific support requirements.  Therefore, unless migration=
 is
> > > entirely accomplished via a shared dmabuf between PF and VF,
> > > orchestrated through userspace, I'm not sure how we get to migration,
> > > making KHO vs migration a binary choice.  I have trouble seeing how
> > > that's a viable intermediate step.  Thanks,
> >
> > What do you mean by "migration" in this context?
>
> Live migration support, it's the primary use case currently where we
> have vfio-pci variant drivers on VFs communicating with in-kernel PF
> drivers.  Thanks,

I see so you're saying if those users wanted Live Update support and
we didn't do (3), they would have to give up their Live Migration
support. So that would be additional motivation to do (3).

Jason, does this change your mind about whether (3) is worth doing, or
whether it should be prioritized over (2)?

I think I still lean toward doing (2) before (3) since Live Update is
most useful in setups that cannot support Live Migration. If you can
support Live Migration, you have a reasonable way to update host
software with minimal impact to the VM. Live Update really shines in
scenarios where Live Migraiton is untenable, since host upgrades
require VM terminations. In the limit, Live Update can have lower
impact on the VM than Live Migration, since there is no state transfer
across hosts. But Live Migration can enable more maintenance scenarios
than Live Update (like HW maintenance, and firmware upgrades). So I
think both are valuable to support.

