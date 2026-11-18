Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E27C9606A336
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 07:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Qy3l98pI
Received: by kanga.kvack.org (Postfix)
	id DA3F06B05B0; Wed, 18 Nov 2026 02:51:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D535F6B05B1; Wed, 18 Nov 2026 02:51:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C42CD6B05B2; Wed, 18 Nov 2026 02:51:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2DA6B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:51:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 064AAC0399
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:51:35 +0000 (UTC)
X-FDA: 85447470150.20.78A33EB
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3C53A180005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:51:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Qy3l98pI;
	spf=pass (imf24.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794988293;
	b=ugr1yW3UWBTQr9MSXjZSEsYu88C0d93RGf83aAqapTxZhSqEM4kJroqDl+H/KQvVIj8PfV
	zlbBqTvxlRxuI1rq3Wqjy4njErP6mjvFGKsqrLapOhXdFNHTCd08QvcyxXo3em96qLd9Dr
	pjps9K8jVE+RCvUKNfgaRcc+Jf0qPtI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Qy3l98pI;
	spf=pass (imf24.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794988293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1RbWjqFm7axK1WA6d2qj68hL+HcVofiqBMMK2TnnVw=;
	b=e1tbVWKO3dWtDhyxZPeQ84qcGZddMSCf77oeMsdllJvXyTXOECC2+jYo0M737NfLyqZzge
	n4q9PfXNXfmKF2Ino7SzOT/LusCwDTuw/D8WdiXimVFC7wYnUyG4LK7JFr9wCEub3eLMAV
	pMrBpsXl+PDzElICiWToL8znpWELnmE=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2efc4a84e75so31195ad.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794988292; x=1795593092; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r1RbWjqFm7axK1WA6d2qj68hL+HcVofiqBMMK2TnnVw=;
        b=Qy3l98pICsn3k9WuuQB+dt40y095eXQFW6xXYq+lxKBRUQ5jfTsQ3TjZENcu5v/hED
         slI2g+E3kG82uGPIeA2ESs7iCgVGwqoE8uRMWp17L74n0UFQ5/HsneHydizLvPNW330k
         ILXzREdnO7bzV42oPCCm4wbxOgVwsfWN7IQPctjRDl92KWbCIdsZDLf7zGUbi0QWd59+
         1KcwzWdsX5IIJn6P7lYWQZcEIGBBApJ6V7z68rHtzgeTaKlS11qVh8PIyyjk09emGSYZ
         pZ6KAKKeOuv/iTGIKA9RwmsQrMplBru7YSYlOn66Vv2AArt7hqMztFwPn9HWdukfoppB
         9Uew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794988292; x=1795593092;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r1RbWjqFm7axK1WA6d2qj68hL+HcVofiqBMMK2TnnVw=;
        b=eleDJkx6YkP+CceirHt5tNzjlrYu6DukllAyZzCSJt6yKStmE5qf6I30zZtkF+iKUE
         X8AbGgFrMZdxKkKmJBbFZZ8v/jlqrAUYLyXKC4aeyLyMnEAc1A9TFlB4FZZXPPM5Nxi0
         NGUUPJXecgjU5QSpGPaRwbwrpbiSun98UrN7Kt1CzK6ADjykO7I+TplQ0Aoc6new5FT0
         lOol90FUFx5EDf8M5D3t7aoqCnnElqtoQagOYrqt+K9Te1MB2psrWVIFRsxEuBDRaSty
         aMigI80eujYIHyH2zhzJ1iMa0SPudgSEWZepTQ+1i15qJA6Lg6NqF1k+dzEh211Oa36M
         VLxA==
X-Forwarded-Encrypted: i=1; AL+hErE0thnbmHXeYhMa872ijVK82GHzV1QNmrz++8E9Av+TlTqb8kXrIbBcvPm6piMFRpScmd7tUmruog==@kvack.org
X-Gm-Message-State: APuU4Z+PI9zxdkTQVu7qYqTJBszhtI6cJJwd3T74LNEXi6o5SXm9MbZq
	XGvbjHdvnaDFdFy7BSjYDI7GCXdmf/6Qrm47A+BEfDwqTj7IHTE+g1VolMFyyC86EQ==
X-Gm-Gg: AZFdTZdCCmgFmg/nzqhOy/p6atxvLbtfMjyqIAOPHJfZPxWVEggoIL0TZuqffUD8Iu8
	7VNGVrVLJ/5dOLUqGd8CFRV8LzaBgroo0BSWam/T16BlIVVeaCtWtbbz4sOu3k8bEcQX8we6lxf
	/LFLj2aAXvo7kao2SGr61ZoJKHfEoxbsDDSJrezadul3GKiJGeQuLxbgEUZFZIf+WDX5PwksuTS
	giPAhlMVcUc92hdF3/OqqBbGAKqMvCSyX7obFk5rcOTLhRMjbUjWyLQakiLg4m3WvGsNnUWZ7zK
	abnuPA6+hPUEQ8YMWMgSGzQNzPgI434QRyTsXzS6yp96y9oLsUn9F3JN/viRR8/tMfRoLE0ReHH
	fyJHJ4nmmzsKFGb95ZqcxhqYIT5SX5nAahAlL4yPv6jl1uXCeKPDvs76YqYlig6CG15fU+NPY/K
	lhlmGmNi0I//mBUloMel4fBnec8eOsFpvQIaQwo58+eVN3G8ZSopfqSRUqWfDuLyuFSru+cbqCr
	TRhftB7VY0NJ7hmut58KWF4gXur1xgQPh9w89YOhG6EWe8HRnAikHBaxAMkjCYRuW4xefrzdyul
	ahoCWE+tgYHct9nW089pI/qPUzVeRNQ3QB+RjIMRd6ypAQA85j2YofWImbrudq9OqQ==
X-Received: by 2002:a17:902:d544:b0:2e6:d25:d874 with SMTP id d9443c01a7336-2eff98d30f9mr2984215ad.10.1794988291451;
        Tue, 17 Nov 2026 23:51:31 -0800 (PST)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d56ab352sm1000229a91.2.2026.11.17.23.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 23:51:30 -0800 (PST)
Date: Tue, 17 Nov 2026 23:51:26 -0800
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, ajayachandra@nvidia.com, 
	alex@shazbot.org, amastro@fb.com, ankita@nvidia.com, apopple@nvidia.com, 
	bhelgaas@google.com, chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, kevin.tian@intel.com, 
	leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, mattev@meta.com, 
	michal.winiarski@intel.com, parav@nvidia.com, pasha.tatashin@soleen.com, praan@google.com, 
	pratyush@kernel.org, rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v6 11/27] vfio/pci: Retrieve preserved device files after
 Live Update
Message-ID: <20261118065653.GE2250529.vipinsh@google.com>
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-12-vipinsh@google.com>
 <DMOAT4VV939P.2DI8CEOMMSKMY@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMOAT4VV939P.2DI8CEOMMSKMY@google.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3C53A180005
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NEW_PRODUCTS,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: oajxu6upxpmpeb5d1uozqeqsssznkrkm
X-Rspam-User: 
X-HE-Tag: 1794988293-867526
X-HE-Meta: U2FsdGVkX193V4xTF9AEGwfuf1mT1f2LaoVZFVqMshAp9zXSpikKrN1DJr9Kjr+5itcEIEg1+Van+9QjMjg21cd4ciZ6pc3XZzZUQtpYW/eq878qjjuDZ9U3op6U0IHcXvEFN9NVIvckNlmKZgiV0OsZ5AgetwNaZTiaYw+w5MKwZPLvyxKYc+FqEWgpxagtpUqel6CThN7s+E0w/vSfmw+idj5C2+FlKMZQwHLkpAd7ygswpFnKlkCJLhDCsCik+7EEkxFcPuXMcUdJq2fbJ6IwHAl/jOpS9Y62yDzSsZSu0JCBgJ6Wvg4GIueeZowofS4O5KA6rAs0z6N676qvhZvD16kxTbvKRa8f5nNj4AZ4k95Iue7nWG6gPiDxObWotodh2G4gDftr/6waoYBHQpCcrDzLF1ftz/UTyjC60uO1CHD+H31eoIFDzQPM7kye95iu+foh8RovPw/rqTc016Ap1Pn2hHu+ynEYyEyBpt9+LygtjwMmJoqRnlJEMlGpZyyUjoHTQ5PUfE7z7lY7QPqk3KSvj6kXhkMNfvvoTXn3sbtb9p5UppexOHuz9XvOCpojUpwo1MKuXJoXoEEHYI58dWH/dozREwsk6nA5YNg3NWBaYdGRzp9YLLXLWs3Wc0h+3C8dtyZ2nxyxAhurLLQf2RKLiEL8JPkZu/woMd+4gChu5KG1zPpmfEqJPIwdL8I/Sok5RLhVeIBxsu0Nnpo/RtkG6Sa65b7nM6nKitO3tEXu2HjASmsglO1gqVMgg2hd4d4ufalCF7v4e07QyuVpDkEx78lLjfDkmGkho/XDQX0mK34prOh9SiRws9/VT0HkvpVjsnMlVokTc1wPRilEMyyXVlM/AgCMA3HHSwhKLw35ffT4aGbpFA63jJxJYQQXFNt+GV70Hbke44833anftF6sqfFLvflaBCb0EZ62FE8/vpXsk4rhZ/MfPCGqwc4XD/2i5tb424OwAsH
 7PI7iQBG
 LOjovlEFnyY0dlYLCgsXvxKZWszPys6aDf08w2bQ8Wu6cWYnAyawpLo0j137Iu8+B3Sf5jD4InkmMlA/NBY7cDuLh5BMrD8jUWoOKJv1aX0OwxM02qgY28TSuQ82IC0Dll3L8VKuzyj/fuRKG6WXG7fw5VstI/E7bl2keNpleeB3CvgzoQyTfyGad5WUus5TEhrhjewkRZqTZrLqstKOQaYb/pB1Qzku3FjAsUWgvv7KC/TLmu02eWe+t4zIVjnAZAj6gqvPWo1SxWNrq/ViVvMOiGoe/BQP67xF19kktN82J01US8uZmXjLz+Q2q6xdOOVJYFAycATi+jymB1OkFP7AJA+RKyjAnHlUdawQXgm76diRdZF2MHuSxZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 05:19:28PM +0000, David Matlack wrote:
> On Mon Nov 2, 2026 at 3:36 PM UTC, Vipin Sharma wrote:
> > During retrieve():
> >  * Validate the handed-over struct vfio_pci_core_device_ser header,
> >    sizes, and flags.
> >  * Locate the registered vfio-pci device matching the serialized domain
> >    and BDF (requiring device->ops == &vfio_pci_ops) under the device
> >    lock. vfio-pci registers the vfio device before its probe completes,
> >    and the probe holds that lock, so a device that is still being probed
> >    is not returned.
> [...]
> >  * Open and return an anonymous VFIO cdev file via
> >    vfio_device_liveupdate_cdev_open().
> 
> Here's an idea for how the device file could be created on retrieve,
> which I'd like to hear your thoughts on.
> 
> The patches from Pasha at [1] lets userspace pass a
> file-handler-specific argument to LIVEUPDATE_SESSION_RETRIEVE_FD. In the
> next version of the tmpfs series, I'm planning to use that to have
> userspace create the file and pass it in the argument, and the kernel
> then restores the preserved file into it.
> 
> I wonder if VFIO should work the same way, e.g.:
> 
>   struct liveupdate_vfio_retrieve_arg {
>           __u32 size;
>           __s32 fd;
>   };
> 
> Userspace would open /dev/vfio/devices/noiommu-vfioX itself and pass
> the fd. retrieve() would check that it's an unbound vfio-pci cdev file
> for the preserved device (domain/BDF, noiommu, incoming, cfg_size),
> attach the incoming state to that file, and LUO would track that file
> as the retrieved file. VFIO_DEVICE_BIND_IOMMUFD would then take over the
> device as it does now. Since VFIO preservation is new, the argument
> could simply be required.
> 
> I think this could get rid of some of the special handling:
> 
>  - There'd be no need to fake a cdev open with an anonymous inode, so
>    PATCH 09 and PATCH 10 could probably be dropped.
> 
>  - retrieve() wouldn't need to look up the device by BDF, or reason
>    about racing with probe under the device lock. If userspace was able
>    to open the cdev, the device is registered and probed.
> 
>  - The device file would be opened through the normal cdev path, so the
>    usual permission and LSM checks on the device node would apply.
> 
>  - It would be the same model across file types.
> 
> A few things I think would need care if you go this way. The file check
> and the attach would need to happen under dev_set->lock so they can't
> race with a concurrent VFIO_DEVICE_BIND_IOMMUFD on the same fd. And the
> incoming state should probably be tied to that specific
> vfio_device_file rather than just the vdev, so only the file passed to
> RETRIEVE_FD can take over the device.
> 
> It would also change PATCH 12. Opening the cdev of an incoming device
> would have to succeed, so the check would move to the first open of the
> device instead: fail with -EBUSY if the device is incoming and the file
> being bound doesn't have the incoming state attached. That one check in
> vfio-pci would also cover VFIO_GROUP_GET_DEVICE_FD, which opens the
> device right away, so vfio_liveupdate_incoming_is_preserved() and its
> dev_is_pci() special case could be dropped from the VFIO core.
> 
> The next tmpfs version will also add a way for a file handler to say a
> failed retrieve can be retried, and a helper to claim an existing file
> before restoring into it (so a file LUO already manages, e.g. one that
> is preserved in an outgoing session, is rejected). Both seem useful
> here too, e.g. so that a mistake in the argument (wrong fd, an fd for
> another device, an already bound fd) doesn't make the device
> unretrievable. I'll Cc you when I send it, and I'm happy to share the
> branch before then.
> 
> What do you think?

Overall, I agree with the strategy. I think VFIO cdev retrieval should
happen as the flow you mentioned above. I want to hightlight two things:

1. This will lead to lot of code changes happening in vfio core. This
   means VFIO PCI live update code change will spill in vfio core.
   Should I create a config VFIO_LIVEUPDATE for VFIO core code. It will
   not be visible menuconfig option but selected when
   VFIO_PCI_LIVEUPDATE is enabled.
2. List of other inflight series that this series will depend on is
   increasing. It will be 3 (reset function, pci saved state, and
   restore into fd).

For '2', should I send v7 without changes you are recommending in this
patch and future version of this series can transition to the approach
you are suggesting after LUO changes are landed. VFIO liveupdate series
will go through more iterations, so we will have opportunity to make the
change. WDYT?
> 
> [1] https://lore.kernel.org/kexec/20261103010216.3447716-1-dmatlack@google.com/

