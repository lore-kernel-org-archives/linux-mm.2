Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AECC606C89B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cABB69KJ
Received: by kanga.kvack.org (Postfix)
	id 8882A6B05B0; Thu,  5 Nov 2026 14:57:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833396B05B3; Thu,  5 Nov 2026 14:57:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721136B05B4; Thu,  5 Nov 2026 14:57:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46F946B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:57:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2976C0C07
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:57:49 +0000 (UTC)
X-FDA: 85402125858.27.3C22D4D
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id 070FD160002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:57:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cABB69KJ;
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793908668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5M1pVxSHRgoftylSS6+7dytfFVlWyjkEZ+vlzow5Ync=;
	b=TdJEO4EMdqjT5Yj3gK2F3W2Wte+atL+rSXPkbH05GR3/FpVcEAW/S5imPUIXUG/w0U88fk
	tlmE3mdNXMMIf04hNmG91aevqpRKDc9/PekPrIIX2K2itie6yPwAqqZ96Uropy/Hp/ta8n
	Vqblf5ryKEC3iYcEcytnbNkg/cawIiU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793908668;
	b=wQLgIst1EQ1T+g629bsFIXLWqMxQcYyZ5bRjz+AppDIRRzIC+Mh7WRQupZREe94MhebzJT
	FbwV8PdS2PHWt/lLPS9dyKEQxXSuBhlQp+hCYAbdtG02xYfzChiLkcpEi9h1nGDf1jb6iG
	lSUH7xG2ahgXycBk6d0RufU5IeaQtY4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cABB69KJ;
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ad2b3b1c02so1365055a91.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 11:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793908667; x=1794513467; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5M1pVxSHRgoftylSS6+7dytfFVlWyjkEZ+vlzow5Ync=;
        b=cABB69KJdxEiUOvtrzHTDwlFSlLrgufTzWLwK1sn4b2wYhuAMWMyddjvb/F28X9/1b
         yxGv4iDbU8gMic6D43wHRYcvtm4nl/LSmA3PL2/esYFM8p3fD4gOkRUfBvmrrDgPAjAi
         L4cHYGP/JYvC7+rJSL5TaTpsdze67Bhc3oCSSyfECoBDdSo+jAPyqa0ML6WHX5+oIDUo
         Dy2cDQXfaCNZZ197DP1MdsHhIzn/D9+xxY7vyMqVXML4wCIgR6uCVtktOtXeA/oQGVH6
         wcxCAIaQcOw3FKm0wQo4r/9U/AlIPFFDT3g4MqDOygZuQr3PDlXsOCevWTxA/HgthMGT
         1wBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793908667; x=1794513467;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5M1pVxSHRgoftylSS6+7dytfFVlWyjkEZ+vlzow5Ync=;
        b=cjGP2lwF/6az2j79ZdFenbT/4QKrRq7mBMhp+TucObzMrAToAn3A4HYDMptRIWlHZt
         oPVtHvPJZL7OC7sm9kdaEW8BFoyZIkVg5/nwM21BArJUQYcblG7Bnf9tCyTCsaxy85VD
         mMtkQsNp+31kw4Uqw/VpZosPG3OpCh6KapZLFBuy7jQgrJP80Ogk2nb/KxCdd5l5qNu2
         O+vZGFOFccABAwf5R/xTp3wHmtwA/Is6yMRW7IOnGhGZgsRx4k+x2mC1NeoeJHcblWWu
         2+2Wl77wgw/CD/s1jCzLOJv2xtCzGuNqKv9x8da/UQo+5Yqvbu+XAdt8vswf5GBLpqJE
         gQKA==
X-Forwarded-Encrypted: i=1; AKwUvBygiC7omHUhHqURnMLTuFSr9yIrGhsf2mnuEVrQaEarKlDohz+uDN7LB3Z/zq4fyieeVbu7z+OS6w==@kvack.org
X-Gm-Message-State: APuU4Z8Ldp8BGlGycqB442pDVVU3Fz+kZqOBINB22hCBr96/im8Qr242
	YkA7WhV0jz27G66tNoA8OCOgiri4SmyDs7LrIdFa7hUUmy9BW2SH/O2JKqCXL4h5wg==
X-Gm-Gg: AYBFou3K7mKeFBadjmgN8G1OPndNpPBmX2aCly9nOByoXWbmXPF/tFeUcHLKS0i5cx0
	8hVqrB3yi0iA/H79aUUIZzquRdrYQ/LTYeDvdq13YeFM5vzPSDLtG3pYunHk3yD9PGzppmEQqqj
	K7wVZ/KqqAxdCGoXzoeIPdiNP4sV03uH/QY1Ml4FyBddsN0ICa4m5r7eEicmNc8DTARSwSfBdb2
	tQTcZL8rmimAnJqwphAKdZXt3STutCWKRBxlk9lZ/tzKek349gJmepL+7nXXzGjiuJkcAZCRppJ
	DXEQHSO6h++D+2F8JT1thJ2pO6UQSQXcb8Y8kOfUBekx7V8Ht1CZLZhxYmRVjwccKWpYJ6/Fxij
	8ozazkezjWUn47dFa46x2TxfWj+E2FAocl9pkjxjyta0UXT7Nbr9yaPB4XwuDkpCpUDnj9dS1Vq
	VybnyRqTezn5B5dLE6oXgnmnt6kTdoO/KypwIRkjlQ8dDhbfGQE+qQaot7vzHKcdHrqJsoZGlIm
	mVKYoY1iz67McOLN8B+yu88dtgVapsEm5CqRYsK+YsW8ObgjiXPofNE+Wn91gWTU1m5lohuRtc5
	NnHevu4XU4P293c4gOluVtbfPSKZ+pRvjHYqT6L0iC+9Z6IRGvf7KB1pUAtjqLsH
X-Received: by 2002:a17:90b:3c04:b0:3b0:968f:fdee with SMTP id 98e67ed59e1d1-3b0db7190d8mr58712a91.55.1793908665982;
        Thu, 05 Nov 2026 11:57:45 -0800 (PST)
Received: from google.com (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b326add7sm4962363a91.8.2026.11.05.11.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:57:43 -0800 (PST)
Date: Thu, 5 Nov 2026 19:57:41 +0000
From: David Matlack <dmatlack@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org,
	ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com,
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com,
	chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net,
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com,
	jgg@ziepe.ca, jrhilke@google.com, julianr@linux.ibm.com,
	kees@kernel.org, kevin.tian@intel.com, leon@kernel.org,
	leonro@nvidia.com, lukas@wunner.de, mattev@meta.com,
	michal.winiarski@intel.com, parav@nvidia.com,
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org,
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com,
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com,
	schnelle@linux.ibm.com, skhan@linuxfoundation.org,
	skhawaja@google.com, vivek.kasireddy@intel.com, witu@nvidia.com,
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v6 07/27] vfio/pci: Preserve vfio-pci device files across
 Live Update
Message-ID: <auzftbPFO_6XBYVw@google.com>
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-8-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102153656.1431701-8-vipinsh@google.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: xz8mm1obs315tw9diurfozreixifh5d3
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 070FD160002
X-Rspam-User: 
X-HE-Tag: 1793908667-920777
X-HE-Meta: U2FsdGVkX18i3sPa3vk7lBigZIGuVo376+BmL90WXGLQ6pDqYo8DPrKU0iY7fots9S2YdGrzCY83Aw+xL/+Ll+foc5IthmDaARjNxoC8xxUMCGnJdZ9JRDtKshvUwAmi2/hHEPSbm7hSFGJm/zAe5JlVUjfTyMb+JRz2n+D9iCfgvRwDJFMt+nrS0KI6s82Fj9miqOqf0BJuggNOTbqehYq91xrqEj5zBzWhhjGt0iBShd6dGFsyA96fPzw4cGV8QrVgvY/c5UN95RpTyzK30ct86kCFHLo2UBKxLTvYWbStmVeEB21lYeDkzdM7iVZgx1oMZyOoFQdB2nlkdzofq/7PnTGMQ72FEIswak5OcaiAS7v8to/ypXI6InE4nbSvbvwiHDx2t94i/BDenJ1zApN7oe/L440vQ356jOtzpaz28RlRzIjQTBxT5Fj0UH8aLfltd1NpCPNAJXO4FHFBRT6cbbRihCFYMTNO2WkyIF1zubxpPH3GZ72fCHzi095cEA8jEMJ3x15WpgD6DInaKTOxmwaM0mC8sopqH1duYPHMrujqABGaFySXBWAOfXV8aTq27PFYBDfplKDSmuB9SUkDlcPEB7LtgN8VDFmdZdR1rAJoj0ethfzBLr0Yv93Ph+0m/gsC8TdCIm7Bhde8pbwi3uXrvs97NfsIZc3YTgxyLEO7WH523lFhOpIsGRXSw4wvQ38anIxANblL4e3u/HCQ9f3UR5it6/D/Ymt4oRkD462VQJiRh37aHCEtR1nxw7/oJq287+nlUlnCrb2E8WyTk0hM6hkOB1CU3wjJO1joVkbA4SUQ/HDm5VeW/evykGV8g/5zqz0jXXXGq6YZcM2OxBqCesP90zidF6Pf62PceqoPhTBFi1QjEBNUraa6IF6jZGQEyhhA/Wa7ZD/T/KchsobqEYPALndB8SCzrCN5sp8lrXwoeLJWSmaHxRfAnY2eVMDpgno/v/ur+Bp
 BRGkbHy8
 vQbNH4vQ6IOm67koLBafNzjJQsFz19JLq86hil717dT8QyKNRTeamT651u3OK1Or9C+53ypED1ubU+Cvny25OT3SVUtHvVEGX3C9V89vDDfZTtiMRjFYomhB4cKcREyor8TIVS45yyv4pYD0gO/+2OQ1zt762H/T4ACYXEekiHBmVLHfY0mqFJUuM1w3Sa/7zS1o7UB9lwiDl6pB+IgEitcOZxiFFLxccUHYIxszUb7+OLNw36MdyL7nK4Kb19i/6SHQRLYdPwqR+/mjqjGe/SEZdN2GRVOvEBqOwehpmU8rRZVdwZ1SfHlRz86M45IZNiSJsdEad8hV3Z9FFrthpR5DXE0RiSiiVG6UCSN2ByqJW24hswbtd3wJJmaMpc+pIAlsFmjhOIoAR1Tmwzgk/R9a7wuF2xgEumLtk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-02 07:36 AM, Vipin Sharma wrote:
> + * DMA Memory Ordering Contract
> + * ============================
> + *
> + * Because a preserved noiommu device continues performing DMA using physical
> + * addresses across kexec, any memory buffer targeted by device DMA must remain
> + * at the same physical address in both kernels and must not be freed to the
> + * page allocator while the device can still access it:
> + *
> + *  * When using a LUO-preserved ``memfd``, userspace **must** preserve the
> + *    ``memfd`` in the **same** LUO session as the VFIO device and **before**
> + *    preserving the VFIO device. LUO finishes files within a session in reverse
> + *    preservation order (LIFO), guaranteeing that if the device is not taken
> + *    over in the new kernel, VFIO's ``finish()`` callback stops bus mastering
> + *    and resets the device before the ``memfd``'s ``finish()`` callback releases
> + *    its folios. Cross-session ordering is the responsibility of userspace.
> + *
> + *  * After retrieving a preserved ``memfd`` in the new kernel, its folios are
> + *    ordinary unpinned shmem page cache until pinned again; userspace must keep
> + *    the ``memfd`` alive and re-pin/map it before finishing the session, and
> + *    must not rely on a ``memfd`` whose ``LIVEUPDATE_SESSION_RETRIEVE_FD`` call
> + *    failed (failed ``memfd`` retrieval frees its folios immediately).

Most of this section documents LUO and memfd behavior (finish ordering
within and across sessions, what happens to memfd folios after
retrieval), which belongs in the LUO and memfd documentation rather than
here. The VFIO documentation should just state what VFIO requires of
userspace and what happens if userspace violates it. Something like:

  DMA Memory
  ==========

  A preserved device keeps performing DMA across kexec to the physical
  addresses it was programmed with before kexec. VFIO does not know
  which memory the device accesses and does not preserve it. Userspace
  must ensure that all memory the device can access stays allocated at
  the same physical address in both kernels until the device is stopped,
  either by userspace after taking it over or by VFIO when the session
  is finished. If userspace violates this, the device can corrupt memory
  that has been freed and reused by either kernel. VFIO cannot detect
  this.

VFIO doesn't stop the device when the session is finished until
PATCH 11, so either add this section there or drop that clause here and
add it in PATCH 11.

> +	cfg_size = pdev->cfg_size;
> +
> +	if (cfg_size != PCI_CFG_SPACE_SIZE && cfg_size != PCI_CFG_SPACE_EXP_SIZE)
> +		return -EINVAL;

pdev->cfg_size isn't limited to these two values. PCI quirks set other
sizes, e.g. quirk_citrine() (0xA0) and quirk_nfp6000() (0x600), and
vfio-pci handles those devices fine since vconfig is just pdev->cfg_size
bytes. This check only seems to exist to bound the variable-length
layout of struct vfio_pci_core_device_ser, which goes away with the
changes suggested below. Please drop it.

> +	total_size = size_add(sizeof(*ser),
> +			      size_add(size_mul(2, cfg_size), saved_size));
> +	if (total_size > U32_MAX)
> +		return -EOVERFLOW;
> +
> +	ser = kho_alloc_preserve(total_size);
> +	if (IS_ERR(ser))
> +		return PTR_ERR(ser);
> +
> +	if (saved_size) {
> +		void *dst = ser->data + 2 * (size_t)cfg_size;
> +
> +		err = pci_liveupdate_serialize_saved_state(vdev->pci_saved_state,
> +							   dst, saved_size);
> +		if (err) {
> +			kho_unpreserve_free(ser);
> +			return err;
> +		}
> +	}

Please don't embed struct pci_saved_state_ser in VFIO's serialized
struct. Variable-length serialized structs should be preserved in their
own allocation, and VFIO should just store the physical address (0 if
there is no saved state). That way the PCI core owns the size, flags and
validation of its own ABI, either struct can grow without changing the
layout of the other, and the offset math here and in PATCH 11 goes away.
struct pci_ser already references its devices array the same way.

I plan to structure the PCI core helpers for serializing and
deserializing struct pci_saved_state to require this. The PCI core will
do the allocation and just return a pointer to the serialized saved
state. But I just wanted to call it out here.

> +	ser->flags = vdev->reset_works ? VFIO_PCI_SER_RESET_WORKS : 0;

reset_works shouldn't be serialized. Alex's series replaces
vdev->reset_works with pci_reset_supported() [1], which only looks at
pdev->reset_methods. Those are set up at enumeration without resetting
the device, so the next kernel can answer the question itself. And the
next kernel's answer is the one that matters, since it's the kernel that
will reset the device.

Please base on that series (or cherry-pick that patch) and drop
VFIO_PCI_SER_RESET_WORKS, along with the incoming reset_works copy and
the reset_works argument to vfio_pci_core_liveupdate_reset() in PATCH
11, and the copy in vfio_pci_liveupdate_take_over() in PATCH 14. flags
then has no defined bits, but please keep it (and keep rejecting unknown
bits) for future features, see below.

> +	if (!vdev->vconfig || !vdev->pci_config_map ||
> +	    ser->cfg_size != pdev->cfg_size)
> +		return -EINVAL;

ser->cfg_size was set from pdev->cfg_size in preserve(), and
pdev->cfg_size doesn't change after enumeration, so the cfg_size check
can't fail.

> +	memcpy(ser->data, vdev->vconfig, ser->cfg_size);
> +	memcpy(ser->data + ser->cfg_size, vdev->pci_config_map, ser->cfg_size);

pci_config_map doesn't need to be preserved. PATCH 14 already rebuilds
it with vfio_config_init() in the next kernel and only uses the
preserved copy to check that the two are identical.

I assume the intent is to detect changes to vfio-pci's config emulation
between the two kernels, but the map isn't a good proxy for that. It
changes for differences that don't matter (e.g. hiding a capability or
learning the length of a new extended capability), which would fail
take-over and lose the Live Update on exactly the kernel upgrades Live
Update is meant for. And it doesn't change for differences that do
matter, like which bits are virtualized or writable within a capability.

Preserving vconfig makes vfio-pci's config emulation part of the
contract between kernels either way. I think changes to the config
emulation that affect how a preserved vconfig is interpreted need to be
tied to a userspace opt-in, recorded as a flag in struct
vfio_pci_core_device_ser. A kernel that doesn't understand the flag then
rejects the preserved device, and userspace shouldn't opt in while it
can still roll back to a kernel without the new emulation.

> +	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
> +	vdev->liveupdate_intx_disabled = !!(cmd & PCI_COMMAND_INTX_DISABLE);
> +	if (!vdev->liveupdate_intx_disabled)
> +		pci_intx(pdev, 0);

This doesn't mask INTx on devices with pdev->broken_intx_masking set,
either because PCI_COMMAND_INTX_DISABLE isn't writable or because a
quirk marks INTx masking as broken. vfio-pci normally masks INTx for
those devices at the interrupt controller, but nothing does that across
kexec, so the device can still assert INTx in the next kernel before
anything is ready to handle it. If the line is shared, that can get the
line disabled as spurious and break the other device.

Please reject those devices in preserve() if they have an INTx pin and
!pci_intx_mask_supported(pdev), and add that to the Restrictions in the
DOC. Check the PCI core flag rather than vdev->pci_2_3, since
vfio_pci.nointxmask=1 clears pci_2_3 even when INTx masking works.

> +struct vfio_pci_core_device_ser {
> +	u32 domain;
> +	u16 bdf;
> +	u16 cfg_size;
> +	u32 size;
> +	u32 flags;
> +	u32 saved_state_size;
> +	u32 reserved;
> +	u8 data[];
> +} __packed;

Once config_map and the saved state are gone, vconfig is the only
variable-length part left. Please either make it a fixed-length array
sized for the largest config space (PCI_CFG_SPACE_EXP_SIZE), or preserve
it in a separate allocation like the saved state. Either way this struct
becomes fixed-size and data[] goes away.

cfg_size should stay, to record how much of vconfig is valid. The next
kernel computes pdev->cfg_size on its own and could come up with a
different value, so it needs to check that ser->cfg_size matches (and
fits in the vconfig buffer) before using the preserved vconfig. Doing
that once in retrieve() should be enough.

I understand this will waste some memory today, since each KHO
allocation must be a multiple of a PAGE_SIZE. But that is a KHO problem
that can be fixed later.

> +#ifdef CONFIG_VFIO_PCI_LIVEUPDATE
> +	bool			liveupdate_frozen;
> +	bool			liveupdate_intx_disabled;
> +#endif

nit: liveupdate_intx_disabled reads like "INTx is disabled for Live
Update", but it actually records whether INTx was already disabled
before freeze(). Inverting it to something like liveupdate_masked_intx
(i.e. freeze() masked INTx, so unfreeze() needs to unmask it) would make
freeze() and unfreeze() easier to follow.

[1] https://lore.kernel.org/kvm/20260812045325.2733631-6-alex.williamson@nvidia.com/

