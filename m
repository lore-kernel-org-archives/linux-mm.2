Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08BD2606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PI4rT4CE
Received: by kanga.kvack.org (Postfix)
	id BA20B6B05C6; Tue, 10 Nov 2026 13:45:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B503A6B05C7; Tue, 10 Nov 2026 13:45:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F03F6B05C8; Tue, 10 Nov 2026 13:45:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 663DD6B05C6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:45:41 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA6251A0AAA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:45:40 +0000 (UTC)
X-FDA: 85420088040.30.0FDEF42
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 20DDBA000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:45:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PI4rT4CE;
	spf=pass (imf25.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794336339;
	b=Z3UpQHswNmoq1OM6XMsHQlyRY46S4M3+8DNF82FqW+xo5ihslL7M1Gq0GlaBGrTbO+QQkc
	pM23ZmdE+zTLeBXKtbBFMSXEbjW3+dBipECAqC7Tz0Ms8/IpQtyuj7/Dvt1bLifsctx24C
	giSOhjLBOiKHwcPCah678zGg6l5FBFo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PI4rT4CE;
	spf=pass (imf25.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794336339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6HenvetdiqKK5Mv1KKa157Ln9/E8xXqIQ72cYSu+2Y=;
	b=RD1mvLckEEbyIZqMEvUtOqffuB/zX8ApQOyhh7WuG/jUMf8W3x7tOa5Zml0S/2YitH82Yv
	ozD0Wld7D/PrZ2Ee/kMgzsI6zl/aJebcZZ4q3BrLt/rabdvXkkj+7EY5ZxysPY93BViKWE
	DEck1c26G825wkgNkrAdaeCjb8GVsKQ=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e8d6fcbba0so4725ad.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794336338; x=1794941138; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j6HenvetdiqKK5Mv1KKa157Ln9/E8xXqIQ72cYSu+2Y=;
        b=PI4rT4CEbJXK2I+G9WOmzsHJGZOr5NITyUuR8+tjunr0Y5VYsVPJpkMHBEoM+YcbpM
         6xJ5XuZcZ9ze/vSbo0eP2Wg8RRDYcaf8dYPlowqSwh/90sohleztxRbcX7k85xQtxeUG
         nX3ifdLChzrom/bVncLkWBFWaO6Bdx8jRFGyepmBRRE8clZ5WtfQ8pl5lYlmbczVWqr2
         3MmvmAkB2WjuA0EsvU2mXe0i8hPFpjOrBAF/KR4gDbc2ILj+Zuvpdxtj+eiR3jj0PfE+
         vq8qUZOj9Jd4hlefZPt2xgV1ymF1Ct/3A72dGGyuUs9mi9+1bXoNZUj4coc+YvgrW73x
         16kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794336338; x=1794941138;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j6HenvetdiqKK5Mv1KKa157Ln9/E8xXqIQ72cYSu+2Y=;
        b=C5Fi+Nyt7LhokwdYvuWYxNInXKPatVJLN1MyvCWA3IiW44Z7oaVrBk8lnBlbMGnux4
         IlVQQ3AKVBPGDbZv9rWLq06eszKGM8uWjtFA5smIArsRMDGF29J6TirrnktxVY6fvLs/
         dMHhot+xtKZsMNSYkOnboLIHJxWjZEnBmrs+6n+NapxgVva8g+cKdH78xc7qQmq8BuAR
         CvKfmnFf2F0YXG4aiFF9T/SC0digMhR0hH+qVq92DnviNih7EzoWS3+xNmZ9TeW5ubM6
         ReXgGYJGyvjra3KmsAYcbCzmVTpJc+2RUkxWPTGkMkL0vI6XlhYZ17+zUNYmuaGFd1Eh
         ZwAQ==
X-Forwarded-Encrypted: i=1; AL+hErEcfWRCGb0ZxGOcRK2QsFM+ufsG4WUo1qmzOKjUGPp1nmW9MUL1kB+Z03YUWfL4XT+APdRSsBg2Bw==@kvack.org
X-Gm-Message-State: APuU4Z/FIxx8E/dzUTq1fJQgYFLAnzDN5oK1D3DYUWrIOp0QfYH6xlGj
	fWBpISlr2gq+ZYOrLla3rF2Eb6NjrM+uZneoFE4lMh6MG9/PF0xLWgN96ar3ttTwPw==
X-Gm-Gg: AYBFou1Z4/+S4SHJIn2pCM/gxDcO4jlbLzBmvV1mII7n65KXSZTPkxR5PoMOi5Ju1oI
	PRaAeDnJjH6bw4FOymxshGCJhrRagDGzeVSBiXbtfPc50m1BCGbpMVT468D35INVUEM957CWNFI
	Fkdd2FmV3gWi+TDKgevByZPULgcMA6VnGyxaBT1fefEqOoPl21ovzf54CoOYQA61by5jFANKQ9J
	8scrlLgFddOZ6TWrJzJFYodqI3D/HVcq/GGxK8ApCsfEzl1MVnXGsJKlBWlFN6hhFskfr1ib1W7
	MzjuQrqK7YOx434uGNAIJps1tBz1XbSHy0KPOQJoLfDqrmTAIVigefeQJC1g5xzrluhSTE3cgPH
	xqh2Q7PlwSXiP336KqwlZo33Nv1VoHsqaToxwqaICNPy+9q3sQgk9/f8nY8EJ8hwSeBwkb902CL
	o89bIDnzXIQGvoLWI7mbFg6TLqnOiTQ0XqfhqvLUxj4LjGwPWxmkFsHdZXo6JvHmZAMgRmzLExL
	fl970org06dWxFLwi7x8sQJu2dP+S26xm4+Se/xEUAG394vpb+3nwH85Xa/V2U1ywrNO6iRA2s2
	+A2H+wgPI061PeBaZtklBIXobYms9IihxJrKz95tOb8I1ehxdABJOXs2f2dfmR1b
X-Received: by 2002:a17:903:2a86:b0:2bd:3bfd:74f1 with SMTP id d9443c01a7336-2edd7110fa8mr255665ad.2.1794336337416;
        Tue, 10 Nov 2026 10:45:37 -0800 (PST)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaa86ce5fsm1317128b3a.21.2026.11.10.10.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:45:36 -0800 (PST)
Date: Tue, 10 Nov 2026 10:45:32 -0800
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
Subject: Re: [PATCH v6 00/27] VFIO PCI Live Update (noiommu mode)
Message-ID: <20261110184339.GB519525.vipinsh@google.com>
References: <20261102153656.1431701-1-vipinsh@google.com>
 <DMOH7D1PZUM4.1X82LVQK7E54Q@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMOH7D1PZUM4.1X82LVQK7E54Q@google.com>
X-Stat-Signature: 56swk35auqbw46kzyequtw4uny495o9f
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 20DDBA000C
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794336338-931424
X-HE-Meta: U2FsdGVkX1/9vSDHhDzJZP3HkF0vRQQPdKIPsR5vFCW60GgAW0Q6ikhDA2DfFF9D7qoZCBdbM8sjQRzalOOtAGTNosEN6tox1N6EB8mro1MxCgxDFa2mlkVfAw3t8h6bT6/SoC5FP1T/walCx2IXStvNwpDEvUnuqOF6rF/Wy05Z28qnFXcRCJS3G4GjueX8oPlnz7tf+FxDGUVorvgUgNJ87wuBfD3sF++9PcKFdkCakiz9DK2s5xaoDE6BCaNqx7/hbhApTWdraWBvA0KE7a3K0Jtm+p23Po45GYdLlFrOB53Hs4Y0y8QHnTqUOKDj/V3OkiUe4Qpjz6GzRTxyTN6nTk1XPD81n4Z6zM4UN1C6HAOCpNMWIG9d0LYpzJ6/m97rCv+THIm+hdJhnTCDM1GsGvw5dhz8eCwRQS0INgDzVZhdlxkBG9VfKeCny6XHfGNz7OHlIGbRlL5XtY1iU6D9Hi/RODlKrvHfyHLZ4yWbjpSOx2ne1Qqz3vXDhXLRqDhWRRqh0Z417/N3zhOFnhIIj3OVsxyBb/b/kri5zJMhcY4lluasHzO3sctbCfpZtq6eD9bwJpRrPTrjofNKCWfjODbWp4YDhAXEqIxBCIhySgczWJLBnWIL2fllLidx+/9VVF1SnB3hZfFVoMvTpDuQBnK+u0hO7tOclz7L00xFvQCSIUB1VECeJ36iUreWDVLaKYMsyCItpC/e5y3Kytp0F4YGvqYFMg9KQXG9NhG0/Up137erMZVKrXmPXxHmIMHSEG4Rx3/M0X4KNR7A9bviICYKD1r2wyIKa4yo3qtC2L0YcfQwi2VarMhjq6idCDcP0WkKdEgjHKdkGg8A0WQf+owdGNSZIPOFLl4jFbiFVU6XJc67qdKbx2bzMKj1LaW1OrfKDVSmzlj7iRjd8VfpQdo93FfgiHNCeRrhUbF0TfEETVGlBNoz3nz0PivBgRPSmRCzObMmzNK0AgE
 tjftGLz5
 tc2ZwcVM/TdkziBVJ+c9PnPPVGWZJdK4xw6XknII9w4pPbeXqOoxyLYQD9P+RfIsjD6HSzj5qBaw6qvNiXgjP0EWMqL19NIeBcC7Y3iGn50Hm5/Uw+TKvPRqk+m++7pLQSLeKACctf/s0v45im0uj+myEpBEg+Rl8YQR3wLqBXFq457emeCPFvZ0iMAdsotaoi2YxSpx8Y3730wZWno70PORpvO0DKjZotoaIhf6rlBdH2DyjqMtcz1s8qmyIIOdF6bM1WcK3E2y3KsxIg6rt62QUvac0zteoxGNTu47oninJuJPk6dGkuAx8oZUztPxNFTN0aVtjzbo2ZvuUWRRWCVduSZcthnqi2qlfkIz9l24KyiY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 10:20:10PM +0000, David Matlack wrote:
> On Mon Nov 2, 2026 at 3:36 PM UTC, Vipin Sharma wrote:
> 
> > David Matlack (4):
> >   vfio: Enforce preserved devices are retrieved via
> >     LIVEUPDATE_SESSION_RETRIEVE_FD
> >   docs: liveupdate: Add documentation for VFIO PCI
> >   vfio: selftests: Add vfio_pci_liveupdate_uapi_test
> >   vfio: selftests: Add Makefile support for TEST_GEN_PROGS_EXTENDED
> >
> > Vipin Sharma (23):
> >   vfio/pci: Factor out the reset logic in VFIO PCI device close path
> >   vfio: Export various helpers from VFIO
> >   liveupdate: Export symbols needed by modules
> >   vfio/pci: Register a file handler with Live Update Orchestrator
> >   PCI: liveupdate: Add helpers to preserve struct pci_saved_state
> >   vfio: Add helpers to identify device files that can be preserved
> >   vfio/pci: Preserve vfio-pci device files across Live Update
> >   vfio: Introduce vfio_find_device() helper
> >   vfio: Refactor vfio_device_fops_cdev_open()
> >   vfio: Add API to open cdev device for Live Update restore
> >   vfio/pci: Retrieve preserved device files after Live Update
> >   vfio/pci: Protect incoming preserved devices until they finish Live
> >     Update
> >   vfio/pci: Take over preserved devices without resetting them
> >   vfio: selftests: Build liveupdate library in VFIO selftests
> >   vfio: selftests: Initialize vfio_pci_device using a VFIO cdev FD
> >   vfio: selftests: Add iommufd noiommu mode
> >   vfio: selftests: Add helpers to map DMA memory at IOVA == PA in
> >     noiommu mode
> >   vfio: selftests: Add helpers for Live Update DMA memory and sysfs
> >     state
> >   vfio: selftests: Add an attach() driver op
> >   vfio: selftests: Test preserving noiommu devices in
> >     vfio_pci_liveupdate_uapi_test
> >   vfio: selftests: Add vfio_pci_liveupdate_kexec_test
> >   vfio: selftests: Verify that opening VFIO device fails during Live
> >     Update
> >   vfio: selftests: Add continuous DMA to vfio_pci_liveupdate_kexec_test
> 
> This series is getting quite long. I would consider splitting out the
> selftests into its own series and we can iterate on each separately.

I think it is a good idea. In next version, v7,  I will send two series,
kernel and selftests patches.


