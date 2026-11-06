Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07871606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=m4UFofJA
Received: by kanga.kvack.org (Postfix)
	id 1A11F6B05B6; Fri,  6 Nov 2026 17:20:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1526B6B05B8; Fri,  6 Nov 2026 17:20:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03FFB6B05B9; Fri,  6 Nov 2026 17:20:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAFAD6B05B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:20:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64B3516023A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:20:16 +0000 (UTC)
X-FDA: 85406113632.25.40B730E
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8857218000C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:20:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=m4UFofJA;
	spf=pass (imf24.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794003614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YdrvcTfiK/07Nw/kCOuL7er8KrOXBZTHNtdfHcqY3yc=;
	b=XJq8yuHtmGw3BjykqL+It/FdZ0aR7wGpnGfekDnJsHdev8yS1MUrCA5Yid4EuQef7iW1Mx
	8GkUHeTON/XAtQfgbVhr0p3Rnz6hx40pd9RqZay2svDY7n3ybW2oU6cLK8gCmDWVG/IJTF
	Pi4xpei89HCLtyfFsLcUFTKtwU0sBiU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794003614;
	b=yt72ut8v69fBGMUzKFdnVv9SI9YspFVMYG9EIHNbCw7m+B3MJPLshXM0+UBFx9e7EWrBJR
	EbNobBSrpX/5OCSNMSjL95q4RW6pF7BVoqBVUsWyGuORXFLdp8BZMQG2ejR+MIzeBxtmP1
	7plOodTgoiFcxpSvIepTS9tWAuBiW0w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=m4UFofJA;
	spf=pass (imf24.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cd6acc50b8dso523463a12.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 14:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794003613; x=1794608413; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YdrvcTfiK/07Nw/kCOuL7er8KrOXBZTHNtdfHcqY3yc=;
        b=m4UFofJAoq+A4lfN2BZb8cRWwQMhP58n32LGR/YWOJ9iH8xWKLjc8Whp0Qs38tBFLo
         ZyAXG9vkO7MDmp9GVVoJsh3mqUjYKFGelTlO66No84yl8Z2uL2w3YFTMb5dJXAxHNyy0
         z24HgTkURvcs7oT5Y8OS0lWRgTZGlKBSX97N6x45KrBjLXeWvBmHyzNBG5EsvEBE5rD/
         /hQcEqz1Kpv8Fa7dIQ/BmpeRndhHob6gdqqVB8jMwpVC3HK2u7OQRvaPu1hPoqyghRfJ
         YUxLDutRq8cPSJeDtDxxF7FjuJo+TdlTdRSjlpUxjbp8o9K4kIzX3ojr3ddxiOtbcNA6
         kgsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794003613; x=1794608413;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YdrvcTfiK/07Nw/kCOuL7er8KrOXBZTHNtdfHcqY3yc=;
        b=EOCryQ15di1uQMWKkKWIRM/AFPqD5BLXCX/SQmYX2g+eqxYknfcaScguCxFtak6GOJ
         k1/3AQAChil24ONQCuEJxAdHbD6Nk0+dblIGBtTJHiGog+3KDl+3YQyBFfIerrHSDuAF
         xXim+GMXAAqOt8+2Ir2QaNsFXwbp2eFDMNxxIXrpE1E3L10/XSa4lygoimSSgRC+pjzU
         +0rqUn1fwO3aijSMEOuD0nyaWH00g4zbBhXkQAjorB1AHYuMQkpyVGSofYLlVqqJe+nc
         Cs1w7PJXZj23fAvaAinVlPFaiHkwOnjapinO57oQYKMZoJpkiRMDt49A14nL3YF6Bn48
         E1Pg==
X-Forwarded-Encrypted: i=1; AL+hErEahYeuSeNDVLfZySh7drEmlYRniC8F3BEuN1wAvVa9F6bL8L++KkuWECrdi8l8mF2vOjwn05H8yg==@kvack.org
X-Gm-Message-State: APuU4Z8qiGCNOhA3QRJN7ZELhIHCnkIrGm947txrAiA2MYz/rHbcsPqA
	AMNv0mY+X9VIvyvxO9Xg4J3gp9Mbsb0iKhAlpswplxw6RApDfxsnT6XOK7OFHOrm+w==
X-Gm-Gg: AYBFou3sqW5uq3hmu//YD1tdVP7Aoa1TE4pzwnM1XebiSOaDmnuF1kd1fbfBU8NfAoe
	/WklkkAUL13QTCFCeVqQosF23L1+RvtohoJwUyNqqZsEwzgVS/AgCwzDFG9eaj5odIGU9R5NXLD
	90rWdCEyLkqzWiO0NNRTuNuAJb88pUid565TrGjSIYbiIuen97gHYYRO+HUt0VhMrF2DajWBqHD
	UNwP8oN6H3aQbzpbyHjXQ7T7LXzI7h7/m9sB06cMnVF8Qe238tpsKbsOWEqhKZ+NsBfYmSaPsTV
	FpEx1wvTk47jw/s/RS0OPoVfrUNpVZOBTXSSZEY4mzqnfdZogK5Hf/genPAgX+yoO/dCHwvlSVg
	KjZginMpld5sQqvZBq9YuMhlAg4DT1NHRtrlxMKa2uigOGP+PeUVLWqg+9vSUYHQGlTqXpiW7eh
	eI8jrTeY0nIAklEQ26miFpiGOGav6emi7iCn2vUVmR0xah4avUQohYsENpXBheMVJc2PY1r0/KG
	+z03jzTc+YROa46FsPMBFKuWwK4JuoeYkYMMOXhHEhlZydY8cMpEG6stZ1R3Km3pH6IX5LXQoqx
	7qCzAAA0bT5qKUE4rvtx73F0aG37o0P9zSbdE0C+THTokygQ1HCNdEXkyogj9pSB4heexA==
X-Received: by 2002:a17:90b:3ec8:b0:3a4:e735:b39d with SMTP id 98e67ed59e1d1-3b0db726100mr3762406a91.64.1794003612758;
        Fri, 06 Nov 2026 14:20:12 -0800 (PST)
Received: from localhost (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1057b1fa8sm528979a91.2.2026.11.06.14.20.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 14:20:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 06 Nov 2026 22:20:10 +0000
Message-Id: <DMOH7D1PZUM4.1X82LVQK7E54Q@google.com>
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
Subject: Re: [PATCH v6 00/27] VFIO PCI Live Update (noiommu mode)
From: "David Matlack" <dmatlack@google.com>
To: "Vipin Sharma" <vipinsh@google.com>, <kexec@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
 <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-pci@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20261102153656.1431701-1-vipinsh@google.com>
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 64y9e3zpjphfexmtm47ix361rxe4ki61
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8857218000C
X-Rspam-User: 
X-HE-Tag: 1794003614-803303
X-HE-Meta: U2FsdGVkX1/0TobsWbLfST0ym6vJw8gW5YFhA3b57gQB7lhC2tTwmqcgwLzpPFksRKUpJlfqMxKHr0rSODFtJ8OVMDIfOHVh6g58L5tVVW+nzVXKXdtGSEZj/d1GP7dzg1+XQSD5LPtESiaa+xchfPwVbpXRhQTOaTu9/pywX44zng7WhB9XGy1O7TWBULmn7PQj9Irq1OnP6lc1WAjvTIcab5S9bXIMFLH3W0Kd4vm4UvFrw+0sVklvje5XNRkFfbFe+8EylES8cg58nAbcwDwmOxMnuqUn/y+Rchs+whol0VDpVocYpSemeqdimJbGWJyZgYO7USYiIn4lG2IjeKmazQT6/+gVfbwrN/4easqIS3wlPeE9UxF8FsBqECTpVJEJGJMmyzJX/uZg47piy8AO4B5b05hbxTrdcBwE1u2fEG+R3G1kS+9QAxJeyAPXNKEZdjsV7hLyZtmK3nQwBxRuosheKF15XsMnyv3vOUCoJesE9rWXytxInVhPYgsyoLjX6laUQh3BKzIlSemMpwd8P2zzXgjM0NnKs5e3ys2kZ1zYHWO/aTLpa/iIJL1LaJBix613sTpR/k3DcolJ2NUCUhjU4kHd7If6bW9opAX6KfAD+DUXak1TEe3Ay2w7Eh4co9qAV1MfJLwEHdHYt0ai6RE/MI7wHDNbaKXNbP6EiW9LEl7MDY7KknRP4jydeHCzVLInq+jgOaKAXVMMy41MvEHRio7yUIgu3Xchi+pDWqGgcGVyIsJq/APy9xpNwJTF5u6jVGFaB9KFXaW6HWFBLePRoRJxGOh6MKoatAytMEMgDYV1W1ufuAuDDp0bR+gKX5Sj0+VoqIEF3UEQX6MF0WcQBC1I5WEwf6Lic9nTfvjjicuF/rvN2Y+Yo9IiHNA/gC2yGmKHVYscRu77+dgm19zdaAGTgCrn9SpGUIbxuWkyw8Fr4b5FOrOJ0A5KIGsT8xqqfYscoThRMD+
 tXp74LkL
 UeOvB9wFzkX1Rxxs69yyhHdSiqVu3MwX1/onFwuqXC0WcDp9BvFUBeuGfc5cYYsBTSm2cdgpo0RgY+dTYe0LJE3SSE1p4W4MjeLk7UDq+EXOjyGYvumJaNLZo9HC2hPbcEjA04GjxOd8BcMUfEAN8ZooMspvB41UJAVOO4BANjaKCgco5G2jBtq5l+fOSkhwUtixRUC8tsQYYwRWwKs020HRNPT16PEZiY4k/Wx0PDS9xkMoO4nyn/tML5EGTOBBKSGnowRZZ4i4DfbYMXHeleZN/HfCSz4UollDehA0Cri8Y+DPL7PiR4fO3CNZupGX/x49qD7GGPzDfoNJfNswzSJVTUsFMtuaILdpQB1shLTh2vlTBjdsQ1m9b/dNOneyZmDc/DBeWBe77+wTvNZNonuTo5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 2, 2026 at 3:36 PM UTC, Vipin Sharma wrote:

> David Matlack (4):
>   vfio: Enforce preserved devices are retrieved via
>     LIVEUPDATE_SESSION_RETRIEVE_FD
>   docs: liveupdate: Add documentation for VFIO PCI
>   vfio: selftests: Add vfio_pci_liveupdate_uapi_test
>   vfio: selftests: Add Makefile support for TEST_GEN_PROGS_EXTENDED
>
> Vipin Sharma (23):
>   vfio/pci: Factor out the reset logic in VFIO PCI device close path
>   vfio: Export various helpers from VFIO
>   liveupdate: Export symbols needed by modules
>   vfio/pci: Register a file handler with Live Update Orchestrator
>   PCI: liveupdate: Add helpers to preserve struct pci_saved_state
>   vfio: Add helpers to identify device files that can be preserved
>   vfio/pci: Preserve vfio-pci device files across Live Update
>   vfio: Introduce vfio_find_device() helper
>   vfio: Refactor vfio_device_fops_cdev_open()
>   vfio: Add API to open cdev device for Live Update restore
>   vfio/pci: Retrieve preserved device files after Live Update
>   vfio/pci: Protect incoming preserved devices until they finish Live
>     Update
>   vfio/pci: Take over preserved devices without resetting them
>   vfio: selftests: Build liveupdate library in VFIO selftests
>   vfio: selftests: Initialize vfio_pci_device using a VFIO cdev FD
>   vfio: selftests: Add iommufd noiommu mode
>   vfio: selftests: Add helpers to map DMA memory at IOVA =3D=3D PA in
>     noiommu mode
>   vfio: selftests: Add helpers for Live Update DMA memory and sysfs
>     state
>   vfio: selftests: Add an attach() driver op
>   vfio: selftests: Test preserving noiommu devices in
>     vfio_pci_liveupdate_uapi_test
>   vfio: selftests: Add vfio_pci_liveupdate_kexec_test
>   vfio: selftests: Verify that opening VFIO device fails during Live
>     Update
>   vfio: selftests: Add continuous DMA to vfio_pci_liveupdate_kexec_test

This series is getting quite long. I would consider splitting out the
selftests into its own series and we can iterate on each separately.

