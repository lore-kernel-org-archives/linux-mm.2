Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EEA2F8FA64
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 17:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 836B46B0088; Tue, 21 Apr 2026 13:41:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E76A6B0089; Tue, 21 Apr 2026 13:41:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D63C6B008A; Tue, 21 Apr 2026 13:41:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5B11F6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:41:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 057D38D701
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:41:03 +0000 (UTC)
X-FDA: 84683278806.01.3A2CEA9
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id E1FDA1C0002
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:41:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l++7zfLX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776793261; a=rsa-sha256;
	cv=pass;
	b=p5YyAb7P0eEB7fpuhjOdIpG987wCwT0QC/bNmFFp/QcGiFQHb10FnYfN+MijliG5luIK4w
	p2piu6pacijLCGOyoJAejQJE6iy6Q+8hf0gpQr1FBf9uEnOw/mpLFjZAurA4w5ddgJEaNs
	rZCN9Z6v1l9R2vfAWrX62ne0xBK2X7c=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l++7zfLX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776793261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gAM3zLbl9RAB5ix2RgDFnveQg42iFe43IZ/4vSwL0po=;
	b=SLwXz0RxeTt2QnxfP4wyuXp0nvvOpK/Hgmb3+lqync1BIEhwk2+I8Gyvm6i37+f2MUvNk7
	9wXA3FYnTriNDvVSY4IXEuHzp/EaWV1UhqF7MYwD4DONApBdF5XDsvhsErMBLODv7Ogpvz
	V4uh8RoWbu1umgxaW6/M2LwW0GM6Fuo=
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-38e7d983f79so35341671fa.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:41:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776793259; cv=none;
        d=google.com; s=arc-20240605;
        b=cRkQByRK6WcyK+nRu/9DnWMK8kVUB0gwRm1jueBK/rKP7FeiAi90r3qMClNgKu8l1a
         8p0PkDN9psnsw6DTWN99EgWL20QkC0LJt3cMdeFdB9kkd+R6LUYKDtKQfvC5CZ+SO/0C
         NzWHBPIdOIEwmYEvVWOG6YxrzbyWzFVVllgUsU9oMcxcye9nWlt11djhupYgMFXUhtbZ
         yvbrezmmMLpft8QYUGrtNe9KMlqE6n0JgQSw7VlvPBUt9tnsM0QQX8Ct9pmh4zhHsxss
         SLucHubgdIPXiHUC2bVAaiew07Gt4lnFxEpHg0xzcJ0W7h6Yyr87pQZ/r6hB1HVaTsOT
         RlrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gAM3zLbl9RAB5ix2RgDFnveQg42iFe43IZ/4vSwL0po=;
        fh=amYANGbPkAFAHww541/I31LMrU/Fk15Ig9emUukVev4=;
        b=DfepRI3rvDTy+xQPN4eLQEXIFcRFbzqdksjCBILiEnccKgD+yNqSOBm9Jwqt056vUV
         2a2nDdSQyVX2i0HF10WwJdmk9VfXA/Ba/80+aXXkHU8yDxXQOi628bGe0fvuEtqREMes
         UiJBDCNAecRVpTyqYeAGcBwvCDwEhj7SeYmQ4A3Zea/nMKijLb2zEtVBYFs4Hquca+X3
         287+BPeXg/NtiVgFR9UTGey/B/iVTzhlVVgjS2TVN3TXrKqMyzFErad4l8E9o16sUYxt
         x/7p0oapkbyAFJQJScseVhCVneonms91Gl9UAnFQBnZiKZN8F97k4oFbO+DKjyLqsmFY
         FmGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776793259; x=1777398059; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gAM3zLbl9RAB5ix2RgDFnveQg42iFe43IZ/4vSwL0po=;
        b=l++7zfLX3UPehHapFccEqXb8zDeIVAXc1b0hU6ogF+lFhl506lDp5B76Y15qoH6wk5
         M3yXpuxHYcZq1ZTPu/ANUxiZwFAeBAN8X28ehlwlqDFfTd3X+hb95awYq+ZJ9TgmHFZd
         +ohCvybE/fb03HTF+B74/YW/2PjCSFvd2dYA7vOcJApJEpfdjP5B+IRKZRjWBr83BC8s
         foeXLoer8RIvEt+p9zlbWIrhRDYR8HG1P8qhTUOeDJeytNQnK7lh6OTb0noDuQc+av4Q
         KGMh6GAWZQsBn1Co/38iz6ZIOa8oHj6Sh27GJJzvBs42ihDQeAh4uBd0rmSG1cjdeDf4
         6oJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776793259; x=1777398059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gAM3zLbl9RAB5ix2RgDFnveQg42iFe43IZ/4vSwL0po=;
        b=nQBbUBMkL2bvFhFwHN89qzdFB6Jg05Hghz2xN7J6QCE963liBilWGj81wpU9CTrNBe
         wI3fR3+aElNjwX6es3u3dOXdvZBTXdGy3BfrkD85nNOxEPYTgiRWYo9+QRS77LqWym1L
         zmBR8IRyv8fy9xPo1ZYmx4JL+fE00qISMl0eGZLgUbkGQHFPPcW64yPZIIyROKiZjG3o
         IemLZNCmxlF4gpfw+Su0T53/6+g4xrwgoyoNSSi3NuJp7WiiDz0kSDolMJGRJlmhcR3t
         up2KM5thA3uSei3Gld4ny6+Ghli/dvP+SJrWsaQXBEN948OFW4fSeY6h0oYA0O/BPHr+
         H4bQ==
X-Forwarded-Encrypted: i=1; AFNElJ8iBqhPK0p81oyARMwKjKy+fdetof5BLDLUZNvyKKWLv27CXVHYFw74tm12zk+NH1evU1NDYbEGKA==@kvack.org
X-Gm-Message-State: AOJu0YyocBxWxYKT+U08W4dKfphrU9SDaETc5VIJiRN5tUkx1dUo4oG6
	HLARgZ2YwVyueP372OqW3N+YZqnzpQjlyER5XMSjC40pxQ37az93G2sNFiT8cC5B/snlTbryL1i
	f2hwuHAl7nDCIKKddmz1LKn0ejy3/NxR+XP7eS36U
X-Gm-Gg: AeBDiesbYS0f4HcffNwtwbHFOz2/rNxW4lioWETvKIU7T4PBp0n9ibkW9tQ+gVdCOAP
	gNyJHJcOVNuHOjbiJcv8obUErsqE1IPUPXvkSGOG55+nY/nO+/jqZ0DJXSrnzP4Ig+fFTPVo830
	BUdv/2oqvwCzq8uJfmSG/24vOZp/XED34OLgPztjeP9m7uZ8s5sZmkrIblcs9XXw0Wc3khp+zIz
	3jwK2o+50K3ISxCIzbVkIa5fr6bNNP6yQb8InyyAWU5kVbKpfjB1Ay36tGgejRsHWzF1jWCB1jR
	VDQ/9vRPm11HqzQvS/aNLXzGTFofTw==
X-Received: by 2002:a2e:a594:0:b0:38d:ed62:f1d5 with SMTP id
 38308e7fff4ca-38ec7aa4a03mr63977601fa.17.1776793258292; Tue, 21 Apr 2026
 10:40:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com> <20260323235817.1960573-8-dmatlack@google.com>
In-Reply-To: <20260323235817.1960573-8-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 21 Apr 2026 10:40:29 -0700
X-Gm-Features: AQROBzAxQqecIHMlVLo5_fKuOniGGCbgFfk1LcXxhbCrQbMNTrTkqomhARN-2eM
Message-ID: <CALzav=ehpWA=XchL+XLZuaYfYmBTPNWDYt1W3LFY5-6+US4E7w@mail.gmail.com>
Subject: Re: [PATCH v3 07/24] vfio/pci: Preserve vfio-pci device files across
 Live Update
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Rientjes <rientjes@google.com>, Feng Tang <feng.tang@linux.alibaba.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Li RongQing <lirongqing@baidu.com>, 
	Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
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
X-Rspamd-Server: rspam10
X-Stat-Signature: hgerfzk44kr49fdpz7u4yrewfw8t8cjq
X-Rspam-User: 
X-Rspamd-Queue-Id: E1FDA1C0002
X-HE-Tag: 1776793260-44741
X-HE-Meta: U2FsdGVkX1/dxQOUNi7AlrXmrOgyacqhVewdW6GO0eSqjrMW4PMxSyWqRWt0OpZntROpsA6eqptNfzaND8DuD60Sq+y/vRoGbPBPIaWM62LigskEiD5p3nUi4hyvQ8zb0UMrNFWmXKphncvLwcYJLvmMGmqAAETJqyE/3UHleS756VJpMkA3+FX3NZvarzzmipA2uJoUhxfwQjvPh61iggRmHerWiujS6YWnLquwVZ862GIvgL+pQxu/rAaHrDTxQlO3vYvjO5vjBPAPybbV1HFaBuWjdRu3hBPNo2EMCevqR+3kQFhJDiMuFEYVZaG051jkQslzePIHg0l+/tzfuZmQS6GoLNrY+l7GdDMXZJTpdKmiWmQriouC/Xtlrkg/bIsGZT9pAlgZt4LwKV/4YfvkOMb3+pwPaOMdfRvpdL/afaGC4+bDSBNA8y4Af2gvDhkb/4eTJ4pjL2YJZKZn4nf/A5OWD0bMSuvXNGmiV/IEbjj4bev4JJiOZXz0FaeP1rmW8fzM/XQMpqVAcoRaPAkGSCYisWMr56Hk0z4V2l5yXvEw0MnAy6awrKSKKXvEYuA1L1Eet9homFcS4/qLYdlnAkRuyGUQPxPobsQh+rwk6g5vVkFxv5VDWordgyO4FSDlmzLFK7WKD5XAtp4kab9NFNEZmjlUy16JZqXQs+Wr1PY+QEL2AfZTtVaEbx6Ry0GtDTKr1bQpz6pjmXZSo2ftfUODaV5u12MJSo/TN7FTEdWTFvQwDzqPBhpQC9ZifoJX6KF2Q7TO1EDyUn1TjvzdM4oFFbPzNEkZflLN99dpfho4WgnahXraJ/eoNfUE6Hxg0L1ljZSkA8VkzD9YzrIMR1gM/1UwLmcrtsjnoUADsX0TIymNdVuO+Z1JSm/iVlCyyXNEZaXzWq9L+DJTruJeIF73b8/t2SV5ghZ9vmaK1r0H46dTsVW3aU5TzQN3PRvc5uf/VXlOy9+jD4H
 Z1uezbrz
 aTug3g/K0CBnihPG7HpmTOYwq+h1sbij+DG1V30rPn9lF4Vv8t7EwNhSvKtEQRb8s09nub3R7w1yRlpTIPMwRp7Z8MLj5KuZ8D14nL4r0pDCg1cZpisM+IFXHaXE1B8uJpgicQ9Q5Ds/PRwoxhoILV8gFG4skjldYTLjw5LItPRZ6geWGzdO+KmwHcgz5BLh/WQkYvITfaWh2jFkLDVTg9wJHid/1FZheEImhqpp7AXTadVFpuQT0TzfzOJYy3e39EQRqhe1WH/POcFydqVAB1KYqhDuvLXp+c0j+5YdTtc2y9tGOEqix4ofnNfZ8ScRZmw1d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 4:58=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:

> +static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *ar=
gs)
> +{
> +       struct vfio_device *device =3D vfio_device_from_file(args->file);
> +       struct vfio_pci_core_device *vdev;
> +       struct pci_dev *pdev;
> +       int ret;
> +
> +       vdev =3D container_of(device, struct vfio_pci_core_device, vdev);
> +       pdev =3D vdev->pdev;
> +
> +       guard(mutex)(&device->dev_set->lock);
> +
> +       /*
> +        * Userspace must disable interrupts on the device prior to freez=
e so
> +        * that the device does not send any interrupts until new interru=
pt
> +        * handlers have been established by the next kernel.
> +        */
> +       if (vdev->irq_type !=3D VFIO_PCI_NUM_IRQS) {
> +               pci_err(pdev, "Freeze failed! Interrupts are still enable=
d.\n");
> +               return -EINVAL;
> +       }
> +
> +       ret =3D pci_load_saved_state(pdev, vdev->pci_saved_state);
> +       if (ret)
> +               return ret;
> +
> +       vfio_pci_core_try_reset(vdev);

I think a call to pci_clear_master() is needed here to so the device
stops issuing memory transactions while VFIO is trying to resetting
it. Otherwise I see these timeouts when running
vfio_pci_liveupdate_kexec_test with Intel DSA: "timed out waiting for
pending transaction; performing function level reset anyway".

Sashiko also wondered if pci_clear_master() is needed to ensure that
the device has bus mastering disabled during the kexec but I don't
think that is actually an issue. vfio_pci_core_enable() makes sure
that vdev->pci_saved_state has bus mastering disabled, so
pci_restore_state() below here should guaranteed it is clear during
kexec.

https://sashiko.dev/#/patchset/20260323235817.1960573-1-dmatlack%40google.c=
om?part=3D7

> +       pci_restore_state(pdev);
> +       return 0;
>  }

