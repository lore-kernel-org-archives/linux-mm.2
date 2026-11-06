Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B370606A33B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IuV32zb5
Received: by kanga.kvack.org (Postfix)
	id 89DBD6B05B0; Fri,  6 Nov 2026 12:19:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 827E06B05B1; Fri,  6 Nov 2026 12:19:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0376B05B2; Fri,  6 Nov 2026 12:19:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34FCC6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:19:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B801160142
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:19:35 +0000 (UTC)
X-FDA: 85405355910.26.13C7049
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4F909C0003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:19:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IuV32zb5;
	spf=pass (imf10.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793985573;
	b=PdAu50PzXkGY0vANaYiTrun4hM/gbOzR9xEDj83tSWx4ZLu0ilK2smljeoJUii7v0M7C3O
	vCImpDWs42mbuZ0LoohKGG3VpWZfiTt2BBoaL9qF49kP+tQAJTBDb60/vR6QIA+v8gZ46L
	s4A/Nozh8bVz+7N0N4E0s2VvTOrArpc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IuV32zb5;
	spf=pass (imf10.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793985573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tEaeh2MQM8Yqh+InUxWcP/c3Ugn8r1gCgilB/e+XZTU=;
	b=AqCy6zZBqBXxp+uqcnFrieXP3TaiQyJe2VR+9QeObASXBLHHV5o/RSg4B60yTr4kY8mWpJ
	73B3pIzT8GbDVbhy4PQc7Kq/EOKg1cynHcmphXqqZ90YnSus55U7Q6B8DTS9mr6ga4Ctfz
	A6mnM9uZ3Fb4+WKs4F0LoROCf3SKQKk=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3b0ae87069dso424681a91.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 09:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793985572; x=1794590372; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tEaeh2MQM8Yqh+InUxWcP/c3Ugn8r1gCgilB/e+XZTU=;
        b=IuV32zb5uucDQ9/yxXwOKg6rlEONGzx9+Cr3/n66kNTo3ELWDRVqOusddrmr/Kb9u4
         /iEV4sNCfcYhxRFpC0MWNCS+DM1buH/CyU4JZ3G6B0eq0ZAHC7rNjRdMe6ipNO0r8ruc
         it1HzU4gVR76+YPJVD/6J0v1+ItKIqgQXkpVpsuylZUMZc67XmUItcixEHzRaEPQtiKV
         8iYYjfc3R9MNEy8SUGPMzqMI/uhna1COC2/3XdXSn78tVBuaENp8heeHeZY1Ly2Q54/Q
         V4ttFsVErAfkV/dWZJxNVjt79Lv0rY/h0qcL4kwOWtVUB09Zs2fx5mUE/34LwDbVUDff
         jb1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793985572; x=1794590372;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tEaeh2MQM8Yqh+InUxWcP/c3Ugn8r1gCgilB/e+XZTU=;
        b=b3yZzYjUn7vahkgecTz2FUpRfvhLO/iJutP0yntuPpCb/C8dXWsL43J7357qlHPsPL
         YXkOH2cKPsqPEQtA3m/Sk81PLbTNZvswhjpJ8wQZ5m8v4ZDYFykj2hU+ztrKnuDco0lF
         ZHWAvHnvZCQ8c/T/7mhNSEcozQBiTjcDVJgOM/jXvT4jT7i+DwqbJNNLFf2cOXWxMFDl
         zhFb2lXDPLon4Uqp/yyknxpOjpCd37MovNhl8+B92bDPf1reX/I0YCaARS8DdcX1iQ7f
         zvfa2CqipzMF8FJdFfvKhqE/5dYp0uLCG5sewqV7UaQJ+Q2qbLTSWk4vD5yieym63BHe
         jjdQ==
X-Forwarded-Encrypted: i=1; AL+hErF2ejYESIwNC1oJnBub88mDe6C8nAf+N5Fnb7vktd1bZJJxHmVOaLY2YN1CnAW9nKFTlB8XopRthQ==@kvack.org
X-Gm-Message-State: APuU4Z/eRHZ5lO460HKkc09FbgqTiv+z8rr7v3wPLgtIKyX2LtTn/MSN
	dijAMJ7Sqbyae4WOeP1UdXOMFRCcfvmamgpmIqABgdLXTRyT3pluf6FKfqbXxuxxFg==
X-Gm-Gg: AYBFou3w6iCmVREwE1UtMO/GvzgPNAx0dC4AUMPs+g8Zk3WZn0aS1bR4/1/t9BcnvOC
	C4cnPmtGDYphJjYovHNIetnJBYV2DHNTkKNobnUKn+vsFt2a/FWjxxXsrWlCyIFoA4v4E5IuTpy
	IvItzCwSye1FfBNBCW4aJNurHt+DgOPfONaFkwhFy7+vdi/USK+zrB2ZGbXnbIKT2MixNM12grf
	SzPZPCE0M+BnQiHIQEMZWD/3DqyM5qMlhMprTtKyhAqU7LIJu34NycefyiI7hvMOvOCCpVt8t7/
	FctfR7z4mIALT0Vl1OZfwtdgNxFI6tsVKt5+0ODcIt8HUCkVr9P9x4V5yqT1N2b6YzHLNWQcRVj
	jeSOyJf9Z5bsLFsE1tQbALnrEqe7iPX6aMuZIsJp9I1uW3GHx1aVJynzT93hRHSHuuI6nXf5KVU
	XXcW5JnfYKFCK2+i9mBynTVXLf85l5U/uI1qlBlMDtUiz/cPzMd9K2ISXJ2IUk2jd6JsGybR3cQ
	TLkMSGrx9FwNDLMDd0COHNJcwnwo2JdARnL/SZlh0TNS+rAeriz7VmrH7C5y8cPWnh0brWkc0q5
	k/U7iY2u9eRHtGpPQjklH6b0nhgRao5KXGbLrswROd+3y0BoFldf3mQ99wfbv71X
X-Received: by 2002:a17:90b:554d:b0:3ac:bfa7:b079 with SMTP id 98e67ed59e1d1-3b0db5edb73mr3411640a91.7.1793985571464;
        Fri, 06 Nov 2026 09:19:31 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb70a7fbcbsm795231a12.25.2026.11.06.09.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 09:19:29 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 06 Nov 2026 17:19:28 +0000
Message-Id: <DMOAT4VV939P.2DI8CEOMMSKMY@google.com>
Subject: Re: [PATCH v6 11/27] vfio/pci: Retrieve preserved device files
 after Live Update
From: "David Matlack" <dmatlack@google.com>
To: "Vipin Sharma" <vipinsh@google.com>, <kexec@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
 <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-pci@vger.kernel.org>
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
X-Mailer: aerc 0.21.0
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-12-vipinsh@google.com>
In-Reply-To: <20261102153656.1431701-12-vipinsh@google.com>
X-Stat-Signature: p4ka9tpp6eiuyryp9xbupjaxb41r43pi
X-Rspamd-Queue-Id: 4F909C0003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NEW_PRODUCTS,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793985573-671609
X-HE-Meta: U2FsdGVkX19nHegkQJS5+bjO9vFPHj4Bet8gjFq3keZQkDdyrvWp6l/kFnTnvwYkcNmgm8cH1mRoZeoFLvljlAhLZHvlZR/L+s6/OPEpUHVlgMpQlpWoYrod7kuZKuaTH/w1Ef2hIXM9SCcKvTfM0UwEfbsBw0jOgvCGU4R25RE2pTmOYKVjqCzYGVjMCFrxLOGFk1Yeu1/KsU3Rrc63hTHFqrvCz/fY3rZb/Xa40BETybq/joDBtWQpfYr2ATmo1apSgRYSbrP+WfD3MtZ2603eC66COhKpHuCDlsbiEvKMcm0OF6Yb1oVNv/01dfwmZlutNFDiB1GSoMoXSYZi681fKc8PrDRGOQkA6r+VoLK026UejsxX8IR2QppIeBNz+6tO/rMgcDCD8qZ0mquPNKKRXdhsVIyB679Jn3r6vlYtk03ZeVrAZ6ppIECrC39bwL6j350GWkyuwjrTRCs9mzsVWPlqjT4V7PBQCVTFN6PcJpKZwfR94hH+vs5EbFVRQFZaMJ5rmd1A1Jv7zYry6LdJkGA+COiF6aAbcgQvf41vwh+xm+Gpb7F4o53DdmKVlSKqTYVjLbDBAYqqi4Ax1sKyquEe5+mdoWDsX0qmBq/h/OCit5G7JHcxX5pIeVaC9CYM0ggdOoLjspi0iiY7a/wLEH5WNsU9gU5a8g/J26ppYzuCnBapJRHP2dRhglKzfAcgXwOQWvLB57DG3uiILDef918YvSPWpeh7UH66x9gZ68cSKIed/ORX/3kJVD8TOHSFjMtczmeuljtwwhQ3RhPNepFMHsAQpuDqVplr60p3dSUnicT1dsLtQj5skmVVDcvVKLNKke1hplmhZC3R3FRiU3wZDWxKensqPge8TqFDp8dHcsQEEzipqco8dnuZVh525UUUtL6yclKQUOoM4lcDjrwzzOqnClk6LR+Wm9VLEvXl5UPy+F4p40U8FkVdZX1j0KWnLyhVDNpmImn
 rfvu03K1
 EGBW7hUV6zuy5Ii9JDuVuTD13Y3znIb9s1a3wnLReGN0CYh060OF+P/pGJYRnH3H8Vwp94EjYFs3UW71fRbwYkMnQhVvhpYYGqhxvs2uiYSNio+oaBlhOK37OtwVIPWQx4iqHRKzXGalSO/8XsJaxm5pzrTV8QRUI95c1UrcbAC7B8vmCA6FnX6LzFCkRe2kbLUGNlXSkBU2FPdmeKytVNvTgfu8vLicqH7kQqpHNobsO6+cjNcRmReI2Y6Wlldng9gKLABAi5psKWdjH0gGCxxWFB6gkXNs9/H++yNczCoWS/sHoKZp7VmL7+wTkt3F+riySF3n2WVcOO9xjZln9IwlBVk+jmtJ6NX+lEWgzVFYhHqZjYB0SJhKTFoqhl+VQH/CogMf2cgysFIrerDDqTD5VaWf3hrzwbd0+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 2, 2026 at 3:36 PM UTC, Vipin Sharma wrote:
> During retrieve():
>  * Validate the handed-over struct vfio_pci_core_device_ser header,
>    sizes, and flags.
>  * Locate the registered vfio-pci device matching the serialized domain
>    and BDF (requiring device->ops =3D=3D &vfio_pci_ops) under the device
>    lock. vfio-pci registers the vfio device before its probe completes,
>    and the probe holds that lock, so a device that is still being probed
>    is not returned.
[...]
>  * Open and return an anonymous VFIO cdev file via
>    vfio_device_liveupdate_cdev_open().

Here's an idea for how the device file could be created on retrieve,
which I'd like to hear your thoughts on.

The patches from Pasha at [1] lets userspace pass a
file-handler-specific argument to LIVEUPDATE_SESSION_RETRIEVE_FD. In the
next version of the tmpfs series, I'm planning to use that to have
userspace create the file and pass it in the argument, and the kernel
then restores the preserved file into it.

I wonder if VFIO should work the same way, e.g.:

  struct liveupdate_vfio_retrieve_arg {
          __u32 size;
          __s32 fd;
  };

Userspace would open /dev/vfio/devices/noiommu-vfioX itself and pass
the fd. retrieve() would check that it's an unbound vfio-pci cdev file
for the preserved device (domain/BDF, noiommu, incoming, cfg_size),
attach the incoming state to that file, and LUO would track that file
as the retrieved file. VFIO_DEVICE_BIND_IOMMUFD would then take over the
device as it does now. Since VFIO preservation is new, the argument
could simply be required.

I think this could get rid of some of the special handling:

 - There'd be no need to fake a cdev open with an anonymous inode, so
   PATCH 09 and PATCH 10 could probably be dropped.

 - retrieve() wouldn't need to look up the device by BDF, or reason
   about racing with probe under the device lock. If userspace was able
   to open the cdev, the device is registered and probed.

 - The device file would be opened through the normal cdev path, so the
   usual permission and LSM checks on the device node would apply.

 - It would be the same model across file types.

A few things I think would need care if you go this way. The file check
and the attach would need to happen under dev_set->lock so they can't
race with a concurrent VFIO_DEVICE_BIND_IOMMUFD on the same fd. And the
incoming state should probably be tied to that specific
vfio_device_file rather than just the vdev, so only the file passed to
RETRIEVE_FD can take over the device.

It would also change PATCH 12. Opening the cdev of an incoming device
would have to succeed, so the check would move to the first open of the
device instead: fail with -EBUSY if the device is incoming and the file
being bound doesn't have the incoming state attached. That one check in
vfio-pci would also cover VFIO_GROUP_GET_DEVICE_FD, which opens the
device right away, so vfio_liveupdate_incoming_is_preserved() and its
dev_is_pci() special case could be dropped from the VFIO core.

The next tmpfs version will also add a way for a file handler to say a
failed retrieve can be retried, and a helper to claim an existing file
before restoring into it (so a file LUO already manages, e.g. one that
is preserved in an outgoing session, is rejected). Both seem useful
here too, e.g. so that a mistake in the argument (wrong fd, an fd for
another device, an already bound fd) doesn't make the device
unretrievable. I'll Cc you when I send it, and I'm happy to share the
branch before then.

What do you think?

[1] https://lore.kernel.org/kexec/20261103010216.3447716-1-dmatlack@google.=
com/

