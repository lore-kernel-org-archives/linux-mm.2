Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2FEA606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 18:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cxpdLqKv
Received: by kanga.kvack.org (Postfix)
	id 91E676B062B; Thu, 29 Oct 2026 14:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CFB76B062C; Thu, 29 Oct 2026 14:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7983A6B062D; Thu, 29 Oct 2026 14:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 304246B062B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:06:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78F111A0519
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:06:46 +0000 (UTC)
X-FDA: 85376444412.27.0884E62
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6DB0E1C0007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:06:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cxpdLqKv;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793297204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Ig+VOdZjoHggEoKr5B7bwbxLSf5OSLxc9dnZMZuTIQ=;
	b=cpSxwxgDmScDIHUZ4IxZxbj9AvEpU1E5Vv1p0pt6xKJGCshXYrF+Ebj/H7seev/za4Bb38
	gkwrZwb2Nyb/Xd/JabD6ImMuivC5r4n9zm4HSCpC8rCYDWKS7+yF/jRF/FAulgcpxj+0Ax
	aE+sOXQSlH3slp98UDl7K9JZWpOysaU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cxpdLqKv;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793297204;
	b=zu1p50Cz/1r/bk5OXRqgLE1Msojuu97uSIe3PdWCTzn1E+DwOfsPhBnqxEwhO10DMyoHYx
	7oCwd4fH8logXnSZvOUpqNzZw5I4NGD+8u3Dyf/BtKYtpxlDYKidmZXPBtp1EUllB51yAw
	ANMld2Hh8m9YLwxfl39WxzIZLhyg89c=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4301e334ceso215400566b.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:06:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793297203; cv=none;
        d=google.com; s=arc-20260327;
        b=Gb4bfaPhhDrEYKukUa6VYoU/z1q4qFMuZlLm7olOjvBpBCm25t+KYXh/aCjoK0m5um
         bUoi2rxpFewuFYo/zRRn8gfAMy24+hWjilCschal/3GSct5ofU5jJGEX95/bzjCCJtKl
         O2c4DV/S0trq1FaZZcNFK0B8gbXQoIbniqHHwE1PnD2VhGk5tR4HBcQHrfpw6HoraPN4
         vl6+i4Gc37RzzEemkxjBb1b08sJuw8emgSy9hWez7Q+X3tbCNaiGkPAoocvfx7Vs9uP5
         M2U8lvqLzd3werm+wv+EN+PMb+pcw4W/Z1Vznpd/IQlpmcPRI1QugjUOiihLY/kzRrJo
         1GPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/Ig+VOdZjoHggEoKr5B7bwbxLSf5OSLxc9dnZMZuTIQ=;
        fh=VU9ERVSAIhr+U5I+11tXWn8cD6kZZqmbHHVdJ1IwVgY=;
        b=kLKtY4Fbye+LAMnlSVqqVksn3bIOMUkhoAvTOKm+cKsV+wot4lFwsD5Fq6bZhQxMdK
         vlN5AKDkhdDdgLhprz5fF9YPt9RFuJxg5+lwd4B7LRM18l1pmk5etvyZ5yh0RIcbbHJq
         cGSWBH4BIgCWu/b2NNeFo8TZwhsmsk1rmUMOMa5dZ8A9KRYOgdEoJnYp/MhGUxj1Wkhq
         HLo5O9zURaB3zX4wXcqohBJKCaHhovIjz9PThuUqFOXy3jAbID2o2lt0RBELw5txMoGy
         UK0+uXLn0M6PfY+2fGZZtHFiBaNEJUC0cZIdqMfCxFdTCgaD7y6cJJahfcaHKfiil4Zf
         IJEg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793297203; x=1793902003; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/Ig+VOdZjoHggEoKr5B7bwbxLSf5OSLxc9dnZMZuTIQ=;
        b=cxpdLqKvvtCljxjB9fqSGnF/053dYad8v7JD1rn97pN11s+1zzvKaKaHyxr94pJajx
         6/XVrCbpdPDzsKxa+VdH7uq8qdBlyt/DVZn8PY1rXyPjD5HTjTFSjhphWSKN46dSFyHU
         VZLe10c0pxTMLg/4FhVZCl3uIR6+YgJHu0TC00qgVTYPRiimtbj5CRn2B6AUt4CjzPZS
         jOoyot3dmwfNbZJSg6EzU09udTdb+xnhQdwPeDAg3nm/j/eNLZOJBjWQENCWprudbrdI
         PeyXZwoNcHfXImWBDXsRKqs1D+aEEKHfZlK/VcnPPeMhACGv5J2FRrapLKFCzbtZv+ea
         DUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793297203; x=1793902003;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Ig+VOdZjoHggEoKr5B7bwbxLSf5OSLxc9dnZMZuTIQ=;
        b=P0Qo2RetbLZ8xy+U5eJLO3yDwWY2f17OYr5GxB6LzYWSLRVzb0CNClcSK673nvOlmM
         11Pri0aSU/qLRghrka6vYv8m+WD591DD74RkyiyOjnJmV5KSmNfy1JNzXQ82EqLnJ7rl
         Em/Ixg/sjShcBo+iq3fhfgVMNbF4raPGFNARAhJcC9QAQoNnWK8VtQcJk9Z6uynjTH1j
         pcMncukE1ZDljpicolQmcVQqJby6iuAw6xaSY/y0UsbcKUnLQSeQg3QZqHd4XGtBU5at
         mUCwo4ql1OlgfDugXL9KZAgO5wnkGb2sjGj2SnXpK1YSwKRWfMCMZ83n10yAILFoNgFS
         8s6g==
X-Forwarded-Encrypted: i=1; AKwUvBzwGr9y2qDtzCx/fAkrXWHqLZ/O1exBbDfv/Md9Kx6MqaE1Qn2aG6c6YGoaG/Pan5NGC8uNz5IwlA==@kvack.org
X-Gm-Message-State: AFq9FYJGTIF015am87HnyDDmV+icQGybNH4PxhjlTieKF3wTakEqDhrz
	RLINppkSY2FA6UEKCwIuD/W3kHZbQaT0XGufefwR6PazdjogJ5U1RyMZuvDZTpqrVcZwHdZjrnk
	4ZWZP5kScY7Q6uFvM9Fw6MbQyd2f0BtSARJh7JchI
X-Gm-Gg: AYBFou3O3mhMqKYIyIk7xJcm+cQOg5NdhvZfnsdcymON+ufD3Yfbeizcg2edVMd+JUe
	9XPMOLCEnC/RnQRO9U3QthqmWyA9KwekCiNemXRtB0RuXIie7voLIRCPY5zXRZiW1Q3V15Zs1+g
	TTIN1Q4VI8n1YeqaByHhIzL9fpm1P3UxoJ7MmjKU8NpNg7guKP60hmkOCmC/fDt54qjy8eZ4YM2
	iH0hgaE1tMNnuowEWtnyP97UEK2s1jHzw+BrDddGmK38f83cdxrFACeBqfsfTKnBGLWME4VtXmT
	iaZe2Y8onclSTcFV1ScGnqUd78GooKgoMNuYfuFpiN0TjKUP5tJ2Uz0ZiMk2SO4FDCPK+U4RXe1
	aks0vg9tVCGIh6phFuLOhViKuZ8puaB4D371hRg==
X-Received: by 2002:a17:906:7953:b0:c40:b477:dfa0 with SMTP id
 a640c23a62f3a-c49bdf3e797mr571689566b.18.1793297202249; Thu, 29 Oct 2026
 11:06:42 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019213054.3157159-1-dmatlack@google.com> <20261019213054.3157159-11-dmatlack@google.com>
In-Reply-To: <20261019213054.3157159-11-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 29 Oct 2026 11:06:15 -0700
X-Gm-Features: AclHuK_cLRpus0bFwOM3qezLRphS7L77ne14GXebvql4AuxivCEsM-6MlWYX4p4
Message-ID: <CALzav=f8+pTJ3m+99=85ntwouUePzzQBA2RJQ5Ogg23J-5rfkQ@mail.gmail.com>
Subject: Re: [PATCH 10/10] PCI: liveupdate: Avoid enabling INTx on incoming devices
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Logan Gunthorpe <logang@deltatee.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6DB0E1C0007
X-Stat-Signature: yyziznu3ra8ng9j6tb4uhq4iritctsr9
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793297204-657727
X-HE-Meta: U2FsdGVkX18faS8nw8NbrYPbKh5vyxZH0nKzoByyAVSjBm/C47IKhP12TRB/wkzTMYgsiLTUVX0JyKh31KzY/8FxCdzN7of/ud8mSPJShUppvho/6/ORCEDRLXd0chpFQ+ykIfHaQl2krY0OfroDyjuKiwFb0rf+i0Effr6VkUALoNlatuzWWQOOGhk8MvwrHqPN9+HICNSwurfd7Rs9K0nXxspmHDnCQGhIV0kXbjoB2DJF10xsekozEhpeODlv1WMhlar4/g3UgHVYYX7ROoYAiFssqjRNJR6vf5jHuibHennS7XXfKbHXFavELzG3Y/9BhQ9knyoDZGJvEjQmflhuWc724ZSrxqb3D+JJf8Fk466r2Y97jEY/n2F2Pv3O+RW9vUs4TR4UZbX0nCZVes/rQyJfYRg149zWDiSrmNvgnLBiNsC9qTuJbLdhIk2EK+zulP3zSzo0QeXnwzIlPG1gXC75r8oddTh+wvDB8KWqbsd+Hl3V1oZye7BrS/M2IHktMH1TKqIerwJ7q6mSsUvKOEn1JDWXHhkKIzUHUfpyUDGGOExW5AyRPIRMhJTpTn9Fqr0RiWFFiB0Ac4UIDiEW3vrZCbKDS/0K9ZN6AuzYb23rRdwZuwcxlmJoprJMX7Ps842xjkEswC6vUVcxNON+b/LQlfkyf5OxWEqyQ/FlDaPeblNeVV1dffIZxLgHRsn9+Q5TM67yiGNTkroMpXrYALOZUI330RuXi+wg5Jriv6hCNT53dXFDHm7wCk0362f24o+LYQpLtJnqH31u3df+g32WWpD1zg9m1RlxWsnZ08t6zRkgDNQUVOs6nZMz64QkjTvOJWR1P8m4ZAjXSpmMynQxoo76B50B87ANlUhzerlcA57ZxlfyXRJmpwKoeea3AfhglTVFchMeoDxXuToo1S7KQbk3Eps6biy9hzaCrP77Y4tVjDJUhaQZyyp0OSdnBppQEfyaKZ6+AQE
 YnR31LD3
 wkdWGWJo3oUqKJnEWUkLo0gW26gDtlr9ZvCDjaXJXSra1ATBPxYHJwdQp1rdMV5wF4v70k1VeRJRECNCIwNRRz7ebS7OAx4yDyLRUQWokpbbvrauZS3EF5EIZCpHHEeanLv7N5FuCICtDacJb4ajqPlRjnYkA6ueTNzEwJV56VpPx+RzHOf5yXwljR3rAgc3JJDcP8bX+G5UT9AjQll7CEkaAr77m3ECICLek/OhRZTsKDPtZIPsgbepEq1CtU86xLGPZwzTDR/zSFCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 2:31=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> Avoid clearing PCI_COMMAND_INTX_DISABLE on incoming preserved devices.
> Pass whether INTx masking is broken on each preserved device to the
> next kernel instead of probing it, and skip clearing
> PCI_COMMAND_INTX_DISABLE in do_pci_enable_device() for incoming
> devices.
>
> Clearing PCI_COMMAND_INTX_DISABLE enables INTx on the device, even if
> only temporarily. pci_intx_mask_broken() probes whether INTx masking
> works by toggling PCI_COMMAND_INTX_DISABLE during enumeration, and
> do_pci_enable_device() clears it when a device that is not using MSI or
> MSI-X is enabled. A preserved device may assert INTx at any point
> during the Live Update, before its driver in the next kernel has set up
> interrupt handling, so enabling INTx could result in interrupts that
> no handler claims, on a line that may be shared with other devices.
>
> Pass the result of probing as a new bit in the probed results in
> struct pci_dev_ser, PCI_DEV_SER_PROBED_BROKEN_INTX_MASKING, which
> reflects struct pci_dev::broken_intx_masking. If the previous kernel
> did not pass it, fall back to probing INTx masking.
>
> Drivers bound to incoming devices are responsible for enabling INTx once
> they are ready to handle it. pci_alloc_irq_vectors() already does so
> with pci_intx() when it falls back to INTx, and vfio-pci clears
> PCI_COMMAND_INTX_DISABLE itself in vfio_pci_core_enable().

Thinking about this a little more, and based on internal experience
with Live Update within Google, the kernel should reject preserving a
device with broken_intx_masking=3D1. Otherwise, there is no way to
ensure that the device does not assert its interrupt while the kexec
is ongoing. The kernel would be forced to mask it in the interrupt
controller, which means adding even more Live Update support across
the kernel, and which gets complicated when the interrupt line is
shared by multiple devices.

I will reject devices with broken_intx_masking=3D1 in v2.

> Assisted-by: LLM
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/liveupdate.c    | 37 ++++++++++++++++++++++++++++++++++++-
>  drivers/pci/liveupdate.h    |  6 ++++++
>  drivers/pci/pci.c           |  8 ++++++++
>  drivers/pci/probe.c         | 10 ++++++++++
>  include/linux/kho/abi/pci.h |  3 +++
>  5 files changed, 63 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index ac4525568818..8a74762c3f7d 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -216,6 +216,11 @@
>   *    bridge implements), since that would disrupt memory transactions
>   *    targeting the device or devices below it. Instead, the previous ke=
rnel
>   *    passes the results of probing in struct pci_dev_ser.
> + *
> + *  * The PCI core does not enable INTx (i.e. clear PCI_COMMAND_INTX_DIS=
ABLE)
> + *    on incoming preserved devices, neither while probing whether INTx =
masking
> + *    works nor when the device is enabled, since the device could then =
raise
> + *    interrupts before its driver is ready to handle them.
>   */
>
>  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
> @@ -650,7 +655,11 @@ static void pci_liveupdate_save_bar_masks(struct pci=
_dev *dev,
>  static void pci_liveupdate_preserve_probed(struct pci_dev *dev,
>                                            struct pci_dev_ser *dev_ser)
>  {
> -       u64 supported =3D 0, probed =3D 0;
> +       u64 supported =3D PCI_DEV_SER_PROBED_BROKEN_INTX_MASKING;
> +       u64 probed =3D 0;
> +
> +       if (dev->broken_intx_masking)
> +               probed |=3D PCI_DEV_SER_PROBED_BROKEN_INTX_MASKING;
>
>         if (dev->hdr_type =3D=3D PCI_HEADER_TYPE_BRIDGE) {
>                 supported |=3D PCI_DEV_SER_PROBED_WINDOWS;
> @@ -1213,6 +1222,32 @@ int pci_liveupdate_read_bridge_windows(struct pci_=
dev *bridge)
>         return 0;
>  }
>
> +/**
> + * pci_liveupdate_intx_mask_broken() - Get whether INTx masking is broke=
n on an
> + *                                     incoming device
> + * @dev: The PCI device
> + *
> + * Get whether INTx masking is broken on @dev as determined by the previ=
ous
> + * kernel, so that INTx masking does not need to be probed.
> + *
> + * Return: 1 if INTx masking is broken, 0 if it is not, or -ENODATA if @=
dev is
> + * not incoming-preserved or the previous kernel did not pass whether IN=
Tx
> + * masking is broken on @dev.
> + */
> +int pci_liveupdate_intx_mask_broken(struct pci_dev *dev)
> +{
> +       u64 probed;
> +
> +       guard(rwsem_read)(&pci_liveupdate.rwsem);
> +
> +       if (!pci_liveupdate_read_probed(dev,
> +                                       PCI_DEV_SER_PROBED_BROKEN_INTX_MA=
SKING,
> +                                       &probed))
> +               return -ENODATA;
> +
> +       return !!probed;
> +}
> +
>  /*
>   * Check if the windows of @bridge have been read from hardware. Outside=
 of x86
>   * that does not happen during scanning.
> diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
> index 98d23e217308..7f86cc85deee 100644
> --- a/drivers/pci/liveupdate.h
> +++ b/drivers/pci/liveupdate.h
> @@ -22,6 +22,7 @@ bool pci_liveupdate_is_outgoing(struct pci_dev *dev);
>  int pci_liveupdate_read_bar_masks(struct pci_dev *dev, unsigned int nr_b=
ars,
>                                   u32 *bar_masks, u32 *rom_mask);
>  int pci_liveupdate_read_bridge_windows(struct pci_dev *bridge);
> +int pci_liveupdate_intx_mask_broken(struct pci_dev *dev);
>  void pci_liveupdate_claim_bus_resources(struct pci_bus *bus);
>  #else
>  static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
> @@ -74,6 +75,11 @@ static inline int pci_liveupdate_read_bridge_windows(s=
truct pci_dev *bridge)
>         return -EINVAL;
>  }
>
> +static inline int pci_liveupdate_intx_mask_broken(struct pci_dev *dev)
> +{
> +       return -EINVAL;
> +}
> +
>  static inline void pci_liveupdate_claim_bus_resources(struct pci_bus *bu=
s)
>  {
>  }
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 853c84a2c782..43af72d1e5c9 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2184,6 +2184,14 @@ static int do_pci_enable_device(struct pci_dev *de=
v, int bars)
>         if (dev->msi_enabled || dev->msix_enabled)
>                 return 0;
>
> +       /*
> +        * Leave INTx disabled on devices preserved across Live Update, s=
ince
> +        * the device could raise interrupts before its driver is ready. =
It is
> +        * up to the driver to enable INTx once it is ready.
> +        */
> +       if (pci_liveupdate_is_incoming(dev))
> +               return 0;
> +
>         pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
>         if (pin) {
>                 pci_read_config_word(dev, PCI_COMMAND, &cmd);
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index a53d0077a08b..badce31b34f8 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1976,6 +1976,16 @@ static u8 pci_hdr_type(struct pci_dev *dev)
>  static int pci_intx_mask_broken(struct pci_dev *dev)
>  {
>         u16 orig, toggle, new;
> +       int ret;
> +
> +       /*
> +        * Toggling PCI_COMMAND_INTX_DISABLE could let a device preserved=
 across
> +        * Live Update raise interrupts before its driver is ready, so us=
e the
> +        * result determined by the previous kernel for those devices.
> +        */
> +       ret =3D pci_liveupdate_intx_mask_broken(dev);
> +       if (ret >=3D 0)
> +               return ret;
>
>         pci_read_config_word(dev, PCI_COMMAND, &orig);
>         toggle =3D orig ^ PCI_COMMAND_INTX_DISABLE;
> diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> index 84a1bf71eeca..badcf2f01be7 100644
> --- a/include/linux/kho/abi/pci.h
> +++ b/include/linux/kho/abi/pci.h
> @@ -95,10 +95,13 @@ struct pci_dev_ser {
>   *    window.
>   *  * PCI_DEV_SER_PROBED_PREF_64_WINDOW: The bridge's prefetchable memor=
y
>   *    window is 64-bit.
> + *  * PCI_DEV_SER_PROBED_BROKEN_INTX_MASKING: INTx masking cannot be use=
d on
> + *    the device, i.e. struct pci_dev::broken_intx_masking is set.
>   */
>  #define PCI_DEV_SER_PROBED_IO_WINDOW           BIT_ULL(0)
>  #define PCI_DEV_SER_PROBED_PREF_WINDOW         BIT_ULL(1)
>  #define PCI_DEV_SER_PROBED_PREF_64_WINDOW      BIT_ULL(2)
> +#define PCI_DEV_SER_PROBED_BROKEN_INTX_MASKING BIT_ULL(3)
>
>  /*
>   * The size of struct pci_dev_ser when this ABI was introduced. Since fi=
elds
> --
> 2.56.0.212.g129ede20d9-goog
>

