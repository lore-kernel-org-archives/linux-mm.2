Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB396606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=a7zS/728
Received: by kanga.kvack.org (Postfix)
	id B928F6B0684; Thu, 19 Nov 2026 20:01:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69B46B0706; Thu, 19 Nov 2026 20:01:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A312C6B0684; Thu, 19 Nov 2026 20:01:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3B46B0706
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:01:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3652C0CA7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:01:25 +0000 (UTC)
X-FDA: 85453694130.01.B7FF991
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf31.hostedemail.com (Postfix) with ESMTP id DE05920003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:01:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="a7zS/728";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795136484;
	b=uq6A2sIf4e+ISjTxb4jTLhquFhFhUi+7u/naH8eaPmrETWYe11jabEEpnNZM510sdUpFoE
	1hjsq3jc5YdHDQDTAH09NOsW8zyaH8u3WMHrm+QSgek/bHW6odVXUtmEqxvLcnaIX7gdJL
	MS2c1a/GMeOT2MvD0LPY40q1+IsqpfQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQwX2YSXjHFZhdcGcul9Os/DsNb3L2Z/dlwRM94y3qk=;
	b=bAOkAiJiF6v4EdLj4Y1VDgvA2AEUQDjOm4bEDih6xYVhqqmrjEydXUPqwAdUxepgHnMu52
	gN2/Jha2hOUtv+GQ7kU35MKbACa4lc55nAO4EbLuE3JHg5vVIxWvwvColB41av4URy8hPW
	eZp2Jq+ZrRawBRd0TbRTxvtqzRrlWek=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="a7zS/728";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3b0bbdeae06so247133a91.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136482; x=1795741282; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tQwX2YSXjHFZhdcGcul9Os/DsNb3L2Z/dlwRM94y3qk=;
        b=a7zS/728NdIyL1ou5wA1RMVB7ht7Fc2xtwU0HZBf2J/sRIdj0mmOOmHbpN1QHQ/xKv
         PK4g4PBDmxItgfEEFEvYf/mVRR0rjtV6K3UfW+PgxUdzHnO+6vSG2xI8jA6+c5AxwZme
         7F1x2T0rQZeRo3dxGuctvZU6E0IxXbCwUPGdrnV/CFRKck/kn6T/W8JVvF6wEFxN9Y23
         UbW3Aw555q6Dneszk33slwm2ZWHVvR1nE6wJi3oFPN4lupl74FFrzkIME/WTI2U7/cd4
         cSvqQ4HKzsf2XFkYs6KHzA8LN5Son200C4BNgtDFi5X9Iv+uHVGiEp/lTOGx9oA+XGrR
         8NsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136482; x=1795741282;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tQwX2YSXjHFZhdcGcul9Os/DsNb3L2Z/dlwRM94y3qk=;
        b=Wl+Z1irTtD+UIHU8uTg190iiCE1AXq4krviXDTSAtxHUNekl7gnRCbrls3npJD6+Mz
         hgNVPPxOtkBue/QSE6lm2Nk96imBM6plezsNEl+Zr+IeLkaJLWdLBgez0G4Kza8vcAvt
         aTpAl3AjdtsYw+k3qi6DDqRmJP8JqFgdk49IXuzGG7EbpBbLOLYaEMrfWJXFp8XUbkqi
         mA0hTKVjwUVKvSoH0G3U3XOtMDMcBgFA7FHYKRjbIqECq23Tu4bPN0TK4RL6TTKXG4vW
         3Yhr1KL3N3wMBFmsxwzeZdVgnAeoqj+yfMhVjaI/6RBssaUbz/QvZ5pC2vIFtCAqkz6e
         dltw==
X-Forwarded-Encrypted: i=1; AL+hErHTQr22cIqTkr81ISaf1ZMSYN+cHNunixwtlaNHPehU2Z0YW34uMz8Ak/15vIMPvWKwU5gG8sGDog==@kvack.org
X-Gm-Message-State: APuU4Z9eiuRJ4rKyYYSYo+c7UILxo1EMgLWx9X/t5tPNnMkPxVU/xGrf
	06CogZ2l4PTYCpI4Dg1/ih1iU7JkqAi1CUtnYrjNsPGlVo1CVUMDspZEFZ7BLasL1lZgKc4luRV
	qpCeUbcVR
X-Gm-Gg: AZFdTZcs6kd8dH1E/Pfbz4hOj3ufjxVEEN3aKlWkoHqf/pU/g04UKwixMlaNVVA8qjD
	PIJlHPbtlEAdpBDui2T1DkE37iCSIMI3pZ1V3Y/3POltDul10CxUyX5lo1nrmJwKRfTpyW7eS8V
	j6GV4sSA1jboy0NYt0L6zhs8VAwk/c1tANxNqWoUf25Wg2v/CVCiv0/gNHDMhLnu88XMSr3jBBO
	XUxZZpO4aHQ2/N2ERyZ7NB0WIPQ0qg91GVFfx3NkBzt5Y2gibBRyYJYYCpdye1Uez2MsWw3y11R
	vaVKdwBqh2PmI48cXwzpYLaOZnrrrj5qPjNsjXZTEiWLjUAVCR2qbC3KUJjPhnNDvPQrWSKytUe
	Y9U5GSDv7jGApR8UrWVzTDtj49mJQNnHmZ/Mzt7CNRZhKsoqAYlmdOi2uqMYCE7cG7wqJTrbOvO
	KYyjUUNfpieSYSLAD3lZ2HmbyzqF1zzUl/WN5xTemHT1zhnyNNte91FVDg1iIpo+ElJtK0C3LhU
	9VS41EvVsHQjdcI4COpfBJIVJMfKuvx00Sf2iGfg2r/SE1AxJKBLx1ZNNWlMvnmsuwQzHEY2srU
	xg8htUAah3cbuBtzR2kbS+pdXEXSqk0NUa0Iwd0QoKUfMdVhTHpIy7snUQBUNMoe
X-Received: by 2002:a17:90b:4b87:b0:3b4:a63:d55c with SMTP id 98e67ed59e1d1-3b41c93b17cmr965473a91.30.1795136481385;
        Thu, 19 Nov 2026 17:01:21 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d639fdsm4865271a91.10.2026.11.19.17.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 17:01:20 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 19 Nov 2026 17:01:19 -0800
Message-Id: <DMZMRTXS7OSC.M79XF39ZVEWE@google.com>
Cc: <ajayachandra@nvidia.com>, <alex@shazbot.org>, <amastro@fb.com>,
 <ankita@nvidia.com>, <apopple@nvidia.com>, <bhelgaas@google.com>,
 <chrisl@kernel.org>, <christian.koenig@amd.com>, <corbet@lwn.net>,
 <dmatlack@google.com>, <graf@amazon.com>, <jacob.pan@linux.microsoft.com>,
 <jgg@nvidia.com>, <jgg@ziepe.ca>, <jrhilke@google.com>,
 <julianr@linux.ibm.com>, <kees@kernel.org>, <kevin.tian@intel.com>,
 <leon@kernel.org>, <leonro@nvidia.com>, <lukas@wunner.de>,
 <mattev@meta.com>, <michal.winiarski@intel.com>, <parav@nvidia.com>,
 <pasha.tatashin@soleen.com>, <praan@google.com>, <pratyush@kernel.org>,
 <rananta@google.com>, <rdunlap@infradead.org>, <rientjes@google.com>,
 <rodrigo.vivi@intel.com>, <rppt@kernel.org>, <saeedm@nvidia.com>,
 <schnelle@linux.ibm.com>, <skhan@linuxfoundation.org>,
 <skhawaja@google.com>, <vivek.kasireddy@intel.com>, <witu@nvidia.com>,
 <yanjun.zhu@linux.dev>, <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 11/27] vfio/pci: Retrieve preserved device files
 after Live Update
From: "David Matlack" <dmatlack@google.com>
To: "Vipin Sharma" <vipinsh@google.com>, <kexec@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
 <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-pci@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-12-vipinsh@google.com>
In-Reply-To: <20261102153656.1431701-12-vipinsh@google.com>
X-Rspamd-Queue-Id: DE05920003
X-Stat-Signature: mz1suse4zohofqjsrmgwcxfw6ifsbffk
X-Rspam-User:
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795136483-507763
X-HE-Meta: U2FsdGVkX1/rfcn1zYjXr8KkUQtgZp/kzpfcNJ9uTKN17aJe6vVOBfCELEkTPU6pA97FS6b+KkBQyQ45sziwyb70kQTSXm3tYWhmbeIxsWV9tJoVANOevl1M+rx7L5asQpkXvQgSyDY2GBxAN2c2HWiGZThGu+02r+obx6ZSYohzNj8B6UDHDLa4WJIaE2vaa3gnATmQVycs7wPX38WLor+BBfQV4JEU0Qq96xu+KJBl+LstZIvm6emmTA+xgcnxMA+WxkdnAXawlmF5vxkufuZvgJXzR+1Iq1VDhm49XXZ95KzMANUKRabdz+mDF1W9ILbbKYFhYSUbDyHEml6WrdQrS18kQUWiRMXFaZzvY+Rug1oTzS7xmSN7r1xvVF7U9mGjp9GZ8m3gnkM8D9lYhngiiT6gRGLK9VJXYZiy13IXrbY5U4cHVH9WPkX+7qPrBotbFaZfs9PPJkk/62j0NWy21eh/rA2eOw4XW2YUWJ6H1jmUSUKHQCVfIriDRiQmA4QLsxeuVGoZIKFxZ66sXm3p58wPWZLnhf+8TwbP3NShEEVYREBbeH8lb3u3ZnxxtK4HWA+MXLyKBk6aJLHvjc5fiBt3gqt2fqk5yru9YhpYRCgNfsRv0kd2WkFtVqVSLMHI8ZMPWSYObs4X+l8oaecjHrdwSOl3/2l1kHiftpHfQ4KTiWYyeDT4Sk/HzYKI3HzsriPqyZDdupBD9oAV5ON2kBwVpQYxpjlH+vB9pg/LKIT2prEsrwAc6hZtit7JMRrHlzBL6UOFA7bBnm2h8JZ3UVWGm2SehZZv9XT93rhNAnb8fkq7oBRwNJbgBqReQ5sKmPBNWelOW3u2/bRIdhayxyNR6XCUEa83ZWAN8SBRrP2798fkzf7AEe/CGtBJMc8RuzkfpHPGWMULqps1zQYjTtuyRAl0GMkLFM+wXBApcM7tDmZ+/Kpgg5ZEFQeRz5Vl1h+7FZmDqKtub0/
 oXkf7pFC
 VmBPwk6YxE7zmx+6iWyXrWLWMFttHXJuVN+MKlJZty91ZiC/9RqjUub7MyILnGISVjdxSVuNPuHebLiE7IAr1Pg59wdNzYUfxUvTq6N6nEFuiruGkfLH4vGZZ6c9t9sdw3xVMruCDniDc7DOFPpggau51LDYQkfIDTnoij4xzJ8c/ruN9egX4snKDorjfian0Gg6QMqRcfCKPlgwpEi5xoRXzXLduTNBte94+XJ8tRDeWCRp/X28UdnaJnUOVQwQ+M40zEXr41F0bRK1mhCLaB2dtt705hNaqO4W1m3WAMhZiXh25OD91YFcFuD4WP7w0KrBZI5dWY+OnsuJOs1W0a1gpwTUmTKpsVz5OH7zbchynVKUhLlakSqWV0q2J2H649IwvqC4VPMsGCyaADetTFFy7gXO4B4uKPa+3ux4xFCfLURZhFLJEWJATOskTM/Mzh4mgrcDRA0XuzHkd845tIMS79ynGqB3ziTszFXoMSFFwYLxJSQ6cRcAGIDMIVOtyT3eViRUSNxSGdemHI1+43xdenCZwjUajZL+IYtJUL8bohGiydiyCTpdpdPLvvQEhqz3/yfq7D8LoAg6ap5ervgoYgy1vcN9dKOIMde0i/n3mhLRnBWvJloU9RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 2, 2026 at 7:36 AM PST, Vipin Sharma wrote:
> Enable userspace to retrieve preserved VFIO device files after a Live
> Update by implementing the retrieve() and finish() file handler
> callbacks.
>
> During retrieve():
>  * Validate the handed-over struct vfio_pci_core_device_ser header,
>    sizes, and flags.
> [...]

Please make the commit messages in this series easier to read. They are
mostly long bulleted lists of everything the code does, which is hard to
follow and largely repeats the diff. A commit message should explain, in
prose, what problem the patch solves and why it solves it this way, and
only call out details that a reviewer can't easily get from the code.
This applies to most of the patches in the series (e.g. PATCH 07 and
PATCH 13 too).

> Do not implement can_finish(): closing a retrieved LUO session invokes
> finish, and refusing can_finish() would leak the session and leave
> unclaimed devices running. Instead, finish() always completes:
>  * If the retrieved device was claimed by opening it via
>    VFIO_DEVICE_BIND_IOMMUFD (which consumes vdev->liveupdate_incoming;
>    subsequent patches replace the open-time reset with non-reset
>    take-over, reject opening incoming devices other than via retrieve(),
>    and protect incoming kept-running devices across runtime PM, dev_set
>    resets, and non-noiommu boots), finish() simply completes its PCI
>    Live Update participation.
>  * If the device was not claimed (never retrieved, retrieve() failed, or
>    retrieved but never bound via VFIO_DEVICE_BIND_IOMMUFD),
>    vfio_pci_core_liveupdate_reset() logs one pci_warn() naming the
>    device, clears PCI_COMMAND_MASTER, resets the function, and restores
>    the inherited pci_saved_state just as closing the device would. If
>    the device has a function reset but is not reset, e.g. because
>    pci_dev_trylock() contends with a concurrent driver unbind, latch
>    vdev->liveupdate_reset_pending so vfio_pci_core_unregister_device()
>    completes the function reset and state restoration via
>    vfio_pci_core_liveupdate_reset_locked() under the device lock held by
>    device_release_driver(). Opening the device after finish() resets it
>    like any open, so it drops the latch.
>  * If the device was not retrieved, look it up under pci_dev_lock(),
>    which waits for a vfio-pci probe in progress. If it is bound to
>    vfio-pci, finish it as above. If it has no driver, clear bus
>    mastering and reset it. Otherwise leave it to the bound driver.
>  * Call pci_liveupdate_finish() and kho_restore_free() on every path.

This is a lot of complexity for one commit, and it's hard to review. I'd
like to start with the simplest approach and build from there: implement
can_finish() and have it return false until the device is fully
retrieved, i.e. retrieved and taken over by VFIO_DEVICE_BIND_IOMMUFD.
Then finish() only needs to free the incoming state and call
pci_liveupdate_finish().

That gets rid of vfio_pci_core_liveupdate_reset(),
vfio_pci_core_liveupdate_reset_locked(),
vfio_pci_liveupdate_finish_lookup() and its bridge and device locking,
liveupdate_reset_pending, and most of the finish documentation. If you
want to handle the other scenarios (devices that are never retrieved or
never bound, devices bound to other drivers, unbind racing with finish),
please add them in separate commits on top, each with its own
justification.

As for closing the session leaking it and leaving unclaimed devices
running: that only happens if userspace closes the session without
taking over all of its devices, and leaving the device running with its
memory still preserved is safe. Resetting the device in that case is
something that can be added later.

It also has a nice side effect: LUO calls can_finish() on every file in
a session before finishing any of them, so a memfd in the same session
that the device DMAs into can't be finished before the device has been
taken over.

> +static int
> +vfio_pci_liveupdate_attach_incoming(struct vfio_pci_core_device *vdev,
> +				    struct vfio_pci_liveupdate_incoming *in)
> +{
> +	guard(mutex)(&vdev->vdev.dev_set->lock);
> +
> +	if (vdev->liveupdate_incoming || vdev->liveupdate_claimed ||
> +	    !pci_liveupdate_is_incoming(vdev->pdev))
> +		return -EBUSY;
> +
> +	vdev->liveupdate_incoming =3D in;
> +	return 0;
> +}

The pci_liveupdate_is_incoming() check here is redundant with the one in
vfio_pci_liveupdate_retrieve(). Nothing can clear it in between, since
only finish() should do that (see below) and LUO holds the session mutex
across both retrieve and finish.

The liveupdate_claimed check is redundant too: LUO only lets a token be
retrieved successfully once, PATCH 12 prevents opening an incoming
device any other way, and the liveupdate_incoming check already prevents
attaching twice.

> +	if (!pci_liveupdate_is_incoming(pdev) ||
> +	    ser->cfg_size !=3D pdev->cfg_size) {
> +		ret =3D -EINVAL;
> +		goto out_put_dev;
> +	}

If the device isn't incoming here, that's a kernel bug. The previous
kernel only preserves the file after pci_liveupdate_preserve()
succeeds, the PCI core marks the device incoming when it's enumerated,
and only VFIO's finish() should clear it. So this should be a
WARN_ON_ONCE().

> +	if (pci_liveupdate_is_incoming(pdev))
> +		pci_liveupdate_finish(pdev);
> +}

Likewise, the device must still be incoming here, so
pci_liveupdate_finish() can be called unconditionally.

> +static inline void
> +vfio_pci_liveupdate_unregister_dev(struct vfio_pci_core_device *vdev)
> +{
> +	struct pci_dev *pdev =3D vdev->pdev;
> +
> +	scoped_guard(mutex, &vdev->vdev.dev_set->lock) {
> +		/*
> +		 * Complete a reset that finish() could not do, see
> +		 * vfio_pci_liveupdate_finish_vdev().
> +		 */
> +		if (vdev->liveupdate_reset_pending) {
> +			vfio_pci_core_liveupdate_reset_locked(vdev);
> +			vdev->liveupdate_reset_pending =3D false;
> +		}
> +		vfio_pci_liveupdate_free_incoming(vdev);
> +	}
> +
> +	if (pci_liveupdate_is_incoming(pdev))
> +		pci_liveupdate_finish(pdev);
> +}

VFIO should only call pci_liveupdate_finish() from its finish()
callback (see the kernel-doc of pci_liveupdate_finish()).

If vfio-pci is unbound from an incoming device before finish(), it
should just leave the device and its Live Update state alone. That's
fine: if vfio-pci is bound to the device again, the device is still
incoming and can still be retrieved. And once the device has been
retrieved, LUO holds a reference to the device file until finish(), so
vfio_unregister_group_dev() already blocks unbinding it like it does for
any other open device file.

If userspace binds a different driver to the device instead, that's
userspace's problem. The PCI core documentation already says it is the
user's responsibility to ensure that incoming preserved devices are
bound to the correct driver.

So I don't think the unbind path needs any Live Update handling at all.

>  #ifdef CONFIG_VFIO_PCI_LIVEUPDATE
>  	bool			liveupdate_frozen;
>  	bool			liveupdate_intx_disabled;
> +	bool			liveupdate_claimed;
> +	bool			liveupdate_reset_pending;
> +	struct vfio_pci_liveupdate_incoming *liveupdate_incoming;
>  #endif

With the simpler finish(), I don't think liveupdate_claimed or
liveupdate_reset_pending are needed.

PATCH 13 later inverts liveupdate_claimed into liveupdate_kept_running
and uses it to block dev_set resets while a preserved device is still
running. That can use pci_liveupdate_is_incoming() instead. It blocks
resets until finish() rather than until take-over, but since finish()
now requires take-over, userspace controls that window. If some flag is
still needed later, please introduce it once with its final name and
meaning instead of adding it here and inverting it in PATCH 13.

