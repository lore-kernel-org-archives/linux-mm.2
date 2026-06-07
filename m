Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53DBFCD8C90
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 20:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662D76B0088; Sun,  7 Jun 2026 16:38:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613AF6B008A; Sun,  7 Jun 2026 16:38:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DBC16B008C; Sun,  7 Jun 2026 16:38:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC086B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 16:38:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D87E7A088D
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 20:37:59 +0000 (UTC)
X-FDA: 84854278278.02.8C19B12
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0C0DC14000A
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 20:37:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HzG6zS5g;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of praan@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780864678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oir9rCALH4eHYpJVikC6mAKB9V6wqMG19r6g7e/slSE=;
	b=e9MSZcVqgHGm5toXnoQSiGnyJWMORHSw4XXM3wPle5W8qDTmuGldYGjrRSNc6u3LgqldEX
	HMqGn0eVL8To7yXfsYxcJWq60LZGgR9chvbIgyPJwtgbcs/K1vaODR8bfNLGGhEIBnECMe
	uNwmvSPC7HFnAPv1Flfcqv+xS5iKZLo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HzG6zS5g;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of praan@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780864678;
	b=gB5mawDGvUUiszyUunbynfonPkFbH1TcAVjf7/1ImEDrBRNw70/JHY6zJD6k7nlwQpQazQ
	wuxVGcI6iic8Uxu2NTLbZ7oFc5+5lt8K9nSL2/tFzLW1O6/G/FRAafUtodXDpWrbH5uatG
	JWQ1G53f7uzb8tlmFKhKaTB7imKEuo8=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1380104f31eso20057c88.0
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 13:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780864677; x=1781469477; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oir9rCALH4eHYpJVikC6mAKB9V6wqMG19r6g7e/slSE=;
        b=HzG6zS5gD5yYja4jL/ZElVI3EKj1RRBFG+3kEgbZkZTfuee0mdZqBUT8o/ePcHU1UF
         wrW5CkMzpCVVw9Cbd3/6dqntN/Z98kY5OOmG1xwbzY7bY94QvGDrZ01Fxv+Cqguu2f5a
         1fCcvWA0mj91NwMpFbJmwpb9d2k52+wrQkvd0IbXfYHeYz+wXPONW6iYcQ406O2m+E/h
         r1Yz7ikbdHdYrCRkurHHUDRz1jwAAzFqMCbj+BvlT9/QCUq16s5VcL4G51gjTS/68A/s
         dvELxDZJZK9XHF+RDhyToF7YaLWUP2MYdpi/7G+3gQfYnbFqhLVzAXspJ5asj1k2aF2z
         Q48Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780864677; x=1781469477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oir9rCALH4eHYpJVikC6mAKB9V6wqMG19r6g7e/slSE=;
        b=mZFUlb4c2ywYPjK5uW1pahLSJN8350qC5jiblK1sxDsNrK+jsmt/gz8KRw42XjHUyj
         VmSIkd7jqJljCoqm5PmxsyxxUmzJXFLkkRZm8zEqb8H8qmUpbMozlSxpC2mj1lnQvUY1
         5wl2y2JpYlfMKgnT6NhfjN3pI1ToP/gXLr4nrf2CRqbY9fpIPBoVmyvh/7Wm+d9fcVCG
         9hBRz2XLLe2XAee2+BV31HYp6EOqWfaGiaso6n+GZofTC33edaHXFSQxMgtfd82ZjKYO
         Pi8ps1Vjyrc1jUi7iKmlIg+PHt/44VkxyK8lbjoHuT/nDpkZOwkQ6/9XgDOsyj1yJLAZ
         dGCA==
X-Forwarded-Encrypted: i=1; AFNElJ+MRImT1u9CN1g8eT483dwwYQbcdDHdir+627lfqXY64eG+ENcE5uS0LSmDzUOHQ/tbExGq8WgRGw==@kvack.org
X-Gm-Message-State: AOJu0YxgkjSWb2r0mkm1U7NOGhkZcjq3Wkz2ge08qGo7EX5YFPyYWPFq
	JerUzhMRViRNGl+sqT0bzoFEkAM0qwva7gbkCllQQLNe4Iw/U+jKN6D/vYjr79U9sA==
X-Gm-Gg: Acq92OHe46a37M9dDDgdJ3L9vuDyLIGRRiHPHwKegPPs7/RHPAGVdRKWwjHO6MpfW04
	Ke+sWVW0eNxgs2a639te6rov62U3rbd/4v4LjEoUKcSpQ12Nat+HLgLMOF08Buss7Nwet9LQWpB
	y+fki1cPR8fCaDZnWZW2ZA3fU/ETfptYvGhkV8evEyhTBAKglWA0RqPN6FwuptWlsKbKHsfWrNT
	Da2oAcUHL8tjW+b3441zwJvjB+hCYbRNNRppRA5hDS3BZYBVBrJIm7TtDhmiSDxtngVDyynuQLc
	jA6DxnyU58x1mXvjTdvhBI1l01CHi6wQkAI2KD35oJVsCHKoA3gjPKXtl4wn5G1G2FNk6J9lO7B
	fOy/eJIe6K3iQ7hwrGVzaRKS2Qvq0f1Dp3WFmQKzsA/7LjCI7wTL7NK7Z+seYIExnX5wmfHZQ/D
	w4VtTWZxT7Q8VlwERGBXJuTVatcw+kto6TOsAn9uvcQiwKgxVYhQxB/uMGLop1cDnclXWoYOU=
X-Received: by 2002:a05:7022:504:b0:134:fc89:410b with SMTP id a92af1059eb24-13807c7c2e5mr279135c88.15.1780864674937;
        Sun, 07 Jun 2026 13:37:54 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1381495bb00sm4230734c88.3.2026.06.07.13.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 13:37:54 -0700 (PDT)
Date: Sun, 7 Jun 2026 20:37:45 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 08/12] PCI: liveupdate: Inherit ACS flags in incoming
 preserved devices
Message-ID: <aiXWmR-ettxin4LC@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-9-dmatlack@google.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: g8dwp7i5poyz7erejhap1668ekaotu15
X-Rspamd-Queue-Id: 0C0DC14000A
X-HE-Tag: 1780864677-259401
X-HE-Meta: U2FsdGVkX19+u19jhmH0OspdCtX3A7RYl8g0OZq4aSOv/OdbssCFUIkFT6DFrQ4Sestj2IvDIf1hqHDU9d9NNigKMd/gVHIloXvB/IEDLw6UCY+Ns/Y/ox2JWNo/9HIabjtfQpXgEFJOIGA5S5RPBzHYEpX0hlu6kTzzzWTsrvEcNYZxw6W7puJju+9f59SXqWF4BqgrwJEpeYep/Cjjh2qQhBk9FCh0QWfvx4cKkAklfM2vtQ8eUvGIksHbJToobjLxbc0yzxh7FJ+I8ZzWoMzbvBa+EjLWoYCqFIucqD/Rwwp4QMpzuhWVbiuq8kZDWYb95VdanWGy1EUFa2R67AVFjouy3hMLwjOnSjOsMw4F6rVzLV3iWP0X7xRDZxqxndYAkz2iDfMbqBJZpmexAjISSrDx49GBmnT1dH4AcoSCsL766wqCAG2iVq9DCWhFD2i20+rLOjlITVdov6VC3s6w1tQRdADGKxHZJh8LOk/RZgbFb0GvSL7mWsSGXveRTcOoKyYiDE742GU3JFwlkh6odcHrJveqzLSTVrHserg98EMMos4zorolrwWqY7b8msDAsvXkaqGKQfwXMShnC5H9uO73C/mgBfZXJTnr/P8dbOGN7Vc+SKPHaemlQaf3MDOrRAGCNh6PSAelCugEQqpCSI+Eo/ha7gAEoAKqNWV7ZcAM14iD2ZR8shh4gYfGyTS4X7ynBzfGqjQ9tQwl8pssHuKEmgguAEN4/FassVTwWKgGLemcxtjllOBqXhrdg9erarTWKs22x0HnKHPeHb11KGqLk5qQMYY+WG2pzgefYNCgmdG7fK44VbemHGO4Y6h7sWzxAOyLS2vN8igR0Fg8s4O3upuFX8/aJxT9yFvzgQuNUAgLtNQAL+gMRpGeJwOteYYWZbIkcm9senvZjCXnRd/U+jKbbbJK4lc6wshIk0eYKrXtgMj3apGXCAjW3VD1zi2YQEIUm6a/pkh
 DJIKmOOB
 zlo28KQDnuGggOqRFkrqgkxfqD/eqlcT+Scdf9t/qzNhYbJ3S7AKj4tI9sP4xT0sAinfKJlDp54dOw5cmNKPLsjH7wLZkJIu4SdNMhd0TT5ZVW6pMM/OJcstWzknt0jveVl2hbmcO7QsabywvtfhXoYGfWa4RBmCsH0qFaqjrLYtjvINKq2UwbU5gTXCFTKzcJdQqcwDo0QIwv9cTfVSqAZrONB4HH2jhRes/zP4UWNYL9+x5MvCN8hRRUi/VfVAVv80dw6EPB56E5eZ9J5mQ7dbUPqkMwYuwT77PHHIyM9e0ZRbHhLkS65nOfQO04QWrEUKArR4keAwaApQKQZUWi33RFRf5I6kkEXdtHQrHZv19Q1Si+oppUqleh9LjX6nH58RggPftGlb6cKe/bZfLUsHgTl7mYllTgkZ6Yy2arLd/UAG7Mielqbs9rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:24:06PM +0000, David Matlack wrote:
> Inherit Access Control Services (ACS) flags on all incoming preserved
> devices (endpoints and upstream bridges) during a Live Update.
> 
> Inheriting ACS flags avoids changing routing rules while memory
> transactions are in flight from preserved devices. This is also strictly
> necessary to ensure that IOMMU group assignments do not change across
> a Live Update for preserved devices, as changing ACS configurations can
> split or merge IOMMU groups.
> 
> Cache the inherited ACS controls established by the previous kernel in
> struct pci_dev so that ACS controls do not change after a reset
> (pci_restore_state() calls pci_enable_acs()).
> 
> To simplify ACS inheritance, reject preserving any devices that require
> quirks to enable ACS as those quirks would also have to take Live Update
> into account.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/liveupdate.c       | 68 ++++++++++++++++++++++++++++++++++
>  drivers/pci/liveupdate.h       | 11 ++++++
>  drivers/pci/pci.c              |  5 +++
>  drivers/pci/pci.h              |  5 +++
>  drivers/pci/quirks.c           |  7 ++++
>  include/linux/pci_liveupdate.h |  6 +++
>  6 files changed, 102 insertions(+)
> 

[...]

>  
> +void pci_liveupdate_init_acs(struct pci_dev *dev)
> +{
> +	guard(rwsem_read)(&pci_liveupdate.rwsem);
> +
> +	if (!dev->acs_cap || !dev->liveupdate.incoming)
> +		return;
> +
> +	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &dev->liveupdate.acs_ctrl);

I might be thinking out loud here, but as an attacker, this motivates me
to somehow hack the EP FW to mis-report the PCI_ACS_CTRL register across
a liveupdate to fool the incoming kernel. If the FW feeds a 0, it silently
strips ACS protections.

Should we also serialize ACS state in ser somehow to ensure we aren't 
fooled by something like this?

> +}
> +
> +int pci_liveupdate_enable_acs(struct pci_dev *dev)
> +{
> +	u16 acs_ctrl = dev->liveupdate.acs_ctrl;
> +	u16 acs_cap = dev->acs_cap;
> +
> +	/*
> +	 * Use liveupdate.was_preserved instead of liveupdate.incoming since the
> +	 * device's ACS controls should not change even after the device is
> +	 * finished participating in the Live Update.
> +	 */
> +	if (!dev->liveupdate.was_preserved)
> +		return -EINVAL;
> +
> +	/*
> +	 * The previous kernel should not have preserved any devices that
> +	 * require device-specific quirks to enable ACS, but if such a device is
> +	 * detected, log a big warning and fall back to the normal enable ACS
> +	 * path.
> +	 */

Nit: It might be worth adding a note here that this can also happen if a
new device-specific ACS quirk is introduced in the incoming kernel for a
device that was preserved by the old kernel (which didn't have the quirk).
In such cases, the two kernels are essentially non-LUO-compatible..

> +	if (pci_need_dev_specific_enable_acs(dev)) {
> +		pci_warn(dev, "Device-specific quirk required to enable ACS!\n");
> +		WARN_ON_ONCE(true);
> +		return -EINVAL;
> +	}
> +
> +	if (acs_cap)
> +		pci_write_config_word(dev, acs_cap + PCI_ACS_CTRL, acs_ctrl);
> +
> +	return 0;
> +}
> +
>  /**
>   * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
>   * @dev: The PCI device to check

[...]

Thanks,
Praan

