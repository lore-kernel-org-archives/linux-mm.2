Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EE02C561E6
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629876B007B; Wed,  5 Aug 2026 02:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3BC6B008A; Wed,  5 Aug 2026 02:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407BD6B0092; Wed,  5 Aug 2026 02:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08D866B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:03:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83F8B1C0BB1
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:03:04 +0000 (UTC)
X-FDA: 85066172688.25.D63948A
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id A3D9310000D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:03:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JeCaAgp5;
	spf=pass (imf14.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785909782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYGJAHMfaG43a10+DAahsWI+BDlKwBdKnhIOAj6soTQ=;
	b=Dyv9qwWhRojTXYyxotKaInTopXsasegLLJMTSK/Q2FVWTdXsYLeztKeMwLx16k1R2HhB+y
	SGgDB+tId/WPOFA+TnYqyaFAPO71tK+dbnTuDbc75UPeqcD9UxjRAuNCZhmkws4vUPOiLQ
	saaX9fmxAIwGIils68o00J5qdAT9etk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JeCaAgp5;
	spf=pass (imf14.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785909782;
	b=8Y8gGdJuFf7xGh6aF52iKgQatVmlq11vMueI64wawphekvtYkjwcZoNqLVoHYW34qzY0fG
	yk8xTxBobovTqrGeobNIwb1/km12t45Ij89Dsvm77xac3+KLT3/YEQNwabjJTkEJqr1efL
	J6Iqmumi25NmZwzjmRhGio+ZWp3xQL0=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cab97c86bdso59635ad.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 23:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785909781; x=1786514581; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kYGJAHMfaG43a10+DAahsWI+BDlKwBdKnhIOAj6soTQ=;
        b=JeCaAgp5Vms7oLRxX/pknhXM0v0pfpt6k+43oH1UreFOnhNsihl50XzXP+W0Dcx7bk
         +Nz6E4NkuWploLF0pHa/iWRTJCd3nldQ0WQtQthPEiGuzy8gcZnX+RiYU4HCzJIkEhsj
         LbVrWfeKP/4tme514UHr7UwCbUcKPtyM79d4DuvFzT4y5bKS9t0SHQuP/rpCPtwEYFMi
         w/1t7Wl+r4t3GCZqb4YKaa+PRw0OvKVfiCNvqYjL7OvYLu0gTZPv79eFw9LM2H1MKnpi
         /b9/s2BvvYAZGif4Hh92hva/FPPCq88S8GJ13ZlJpUmidDZJpo3W1GrwHIyDDwl3Shf3
         HPeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785909781; x=1786514581;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kYGJAHMfaG43a10+DAahsWI+BDlKwBdKnhIOAj6soTQ=;
        b=UhmOP2iiOUgziihwGV9p8HrnezWkApUDlTFUDBvKV4ULdHRDajndrE9TjwGtfPCwzw
         t2aR6hYrzx0nirw29YBpGaGuh3AYUntYhvEGw+IAbeToHRc4KpmgXcmlMKbA1J9l2o87
         AmKg6SLp6Wv3an6kGgd2DyPdlTjeeHBBXx0ICSGrpkHuMrGpXBd2x1arSg2wuh/CRHMS
         2U/9BqOeiSITTPRerLw8SaF5yPYf7/zgSYD4uCciLZxGDnl+uHMrlNyK8ek9rp5YMx4/
         x8Gh5nuxjvKQlyMgAtpnUw/oK5ItKXgnY9BxZPRPa+rd8RTYpuCmkm7W4PgnyodZ9JMQ
         0Wog==
X-Forwarded-Encrypted: i=1; AHgh+RqtEu8vdv0cIap3TruSe4c2RQJiuN46NbwufevysBeDMRxxxm0dUY0GtJPUbGDjk1tjJpszK0chAA==@kvack.org
X-Gm-Message-State: AOJu0YwA5qltECqgzzSMbtX/b9DB0gKA4+sXREpg/repEZDTtO+7iqy7
	aQeDNFSaCT2t/KAr40D+YzuMzNl0vnFhdBNY8abxzm4Iv+5Qfw1Um/5Q5tmvywhGRw==
X-Gm-Gg: AR+sD11Fe4IjO1Igf8kes6g0R2NGBcLMw0zTWAJULbnjHBSeok3EK9Jr6mOIA3kxYOp
	5lLMCXB1OO4FoMUKkXbYOJl0ZW2tgJ+X8mksFzyUCtsYibaC17TxlwaeKOuInvWTa4MWx5aC9e+
	PsTXH/uDXt2t4rvfABTtI7mPfpK9NMhqIDdWFpXgd60WlZro2USsaphNMX/2q+cv4QsSdZfai2B
	FpO/iRIVUG41S+rJTlB2l2g+Qg2brbPK4iL0hqh32/csyIfjiM7ecr1HiodC+JniSMwcWH46LvI
	4zD+7XDDzfY0q6cbcpwm9xntZRv44uFA6mv5mhExsmS/wqUBzI6ptmNlTIwz9UTd/9K43tn7H+b
	NLfIxSAbhTVZ1ECB0gAjHkVmPARI8feRbyAjdgXQfg2KPDFUS5XHzPNCnl6Vqtzvqwkl6fH7sbC
	TKceVPI9qC5QcUN3qTL6HEvHhJhDg7FW2UnNwLIGoH+g8Nv+W4wUtklnFwr+dVG3i8M6D4+4/I3
	fJiYb8+vPWcb+U3PmU+YPU=
X-Received: by 2002:a17:902:ea0e:b0:2ce:b436:272a with SMTP id d9443c01a7336-2d0d0704d14mr5233675ad.3.1785909780734;
        Tue, 04 Aug 2026 23:03:00 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38febfdae85sm3462574a91.3.2026.08.04.23.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 23:02:59 -0700 (PDT)
Date: Tue, 4 Aug 2026 23:02:55 -0700
From: Vipin Sharma <vipinsh@google.com>
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, graf@amazon.com, 
	jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, jrhilke@google.com, 
	julianr@linux.ibm.com, kees@kernel.org, kevin.tian@intel.com, leon@kernel.org, 
	leonro@nvidia.com, lukas@wunner.de, mattev@meta.com, michal.winiarski@intel.com, 
	parav@nvidia.com, pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, rppt@kernel.org, 
	saeedm@nvidia.com, schnelle@linux.ibm.com, skhan@linuxfoundation.org, 
	skhawaja@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, yi.l.liu@intel.com
Subject: Re: [PATCH v5 17/20] vfio: selftests: Add
 vfio_pci_liveupdate_kexec_test
Message-ID: <20260805055042.GA806762.vipinsh@google.com>
References: <20260714151505.3466855-1-vipinsh@google.com>
 <20260714151505.3466855-18-vipinsh@google.com>
 <0556e2fc-3be5-4023-a9a4-8482fa8c88b2@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0556e2fc-3be5-4023-a9a4-8482fa8c88b2@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A3D9310000D
X-Stat-Signature: dc3mx35i6z1zx9m15pyqffswzrru383k
X-HE-Tag: 1785909782-535634
X-HE-Meta: U2FsdGVkX1+4TzHLbEqIdVL0D12COfVNxY7BupsS66pUe6B9sfK/CQ5InAqB8IYF3p3uzffws/0HA3hpJM3El8CFCgrhc6dSNABFuUby35mp6bR4np9WnLyLO6iF+rPYXwaR+R8RBDu6za2jHuTnbEhfFVL/21cUn8jh/l7P+ydH3XukzjmOAovvVrQkUbIZoGPiopGp9kXtI7sbnvdxRk6baEu4CgPq4LOMFUNrg10mBff9zI/rQTO6wyP0tmufmgRu/VbqqF8ugkXHBpOLtML61fYQhuwcnR0M3uowkY/yyuPZC5vr2p7OEVBXgsW0rbw0uYQdzngLPUVOwJWeFXL0BY4ET9Y9lCSrjiDK664GPJRw88W9ihKPDxrO7hxFirrc5ElxlcH0piHiKR9C/6+Ebjv65uuYwbL/MGXw/P3khFzNVBzKhLzZsPbRP2isiKYFItqRMQ98YcZhJWSHwivRIxZ1tY4OwLiZcl9kdOr5PpesN7K6oPXPZ4lfK4mqR6Dg82ODkZVriCVSZDqxQcjXsZh4ATTXwolZTUWxKPy4/18wQYFI5aqrGvTIS8EPWS4zAodXX8w7zDj72aPZTsKh/R55FREav0FXZCNwresu4RvBchD5C9q5UHmWQnYoZZPnYsEIsDKr9I8n6FItrw4nXXEQtV6BJrwYVf4Dcislqn4Vj3sjQzAKWfinjQ9lYGcfC7VmR6ITvL2Z9AFJrZEPWzW8uhp8rvQdvaUCtOV9ljCyNGXvGN1ZcDtXFESCRmg6MevJY7QNMZRpERgVJs+GMIBPmssMH57renNF/WVeW2kDNp2bC/FFJiEZLJepo3rDkYZUBtUPsEFHhP+K49zCXDKp6OIXDNVwuHRGmUPD94DaDgsJp88kxEu8HuzlM8od2Q7MuleydJat5w1hmJrbm77frGe9o6tJdXsOFbWH2r2prhKNDoIdsizgADs28/BNlcivNnh6VVDV5EK
 nrbWFaVU
 Glk9hm0nAItZmy0/X4gHkSYBw8+lDdO9kgzSGO9lnyX9dwcbybbdWSAt9ImxPfGOdObOybBl0vx7unnNQHYHHKKwC3YTuLHZzIkFqimBxPJzhfnO+Dj8WTsGp4JMFJi7MMQxZupB8puCrSz9SD8zc1tx2isOOA26oao4RsTchYo2gnrEzWNJD5TpaTiFgAoqL6pmZsgfjxMIT8Ee3UHoank6HKkzvG5CBJiuinTId6SAPTx9+OJU8JodyWgyxfDaZT4QV97Gin6RWQS/o7wpmgkKvn+x646CtPWf/yMCyKGHkmVaDCgz7DOr5CLEkj5vua4qv05CSpPQ00VwT9k98VVOpo4mZs0TZ6gnuXNdvPYvT+eayS0mc4biNGGJpfcUrulII73Lk8d1vf697b8xgvdEaXB7ro6pDhG/GbZrlmv0yRQzGsK0TkVhH0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 03:19:34PM -0700, Yanjun.Zhu wrote:
> 
> On 7/14/26 8:15 AM, Vipin Sharma wrote:
> > Add a selftest to exercise preserving a vfio-pci device across a Live
> > Update. For now the test is extremely simple and just verifies that the
> > device file can be preserved and retrieved. In the future this test will
> > be extended to verify more parts about device preservation as they are
> > implemented.
> > 
> > This test is added to TEST_GEN_PROGS_EXTENDED since it must be run
> > manually along with a kexec.
> > 
> > To run this test manually:
> > 
> >   $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
> >   $ tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 1 0000:00:04.0
> > 
> >   $ kexec ...   # NOTE: Exact method will be distro-dependent
> > 
> >   $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
> >   $ tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 2 0000:00:04.0
> Hi, Vipin
> 
> Thanks a lot for your help. I followed your suggestion, vfio-pci setup can
> work.

I am glad your setup using virsh is working.

> 
> The followings are the test result. In the step 3, after kexec, there are
> some fails. I am not sure if these are known problem or not.
> 
> 1. Before kexec command
> 
> + modprobe -v vfio-pci
> + tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
> + echo "vfio-pci" > /sys/bus/pci/devices/0000:00:04.0/driver_override
> + echo "0000:00:04.0" > /sys/bus/pci/drivers/vfio-pci/bind
> + tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 1
> 0000:00:04.0
> Preserving device in session
> Preserving memfd of size 0x40100000 in session
> # [STAGE 1] Forking persistent child to hold sessions...
> # [STAGE 1] Child PID: 1236. Resources are pinned.
> # [STAGE 1] You may now perform kexec reboot.
> + set +x
> 
> 2. Run kexec command
> 
> 3. After kexec command
> 
> + echo "vfio-pci" > /sys/bus/pci/devices/0000:00:04.0/driver_override
> + echo "0000:00:04.0" > /sys/bus/pci/drivers/vfio-pci/bind
> Checking open(/dev/vfio/devices/vfio0) fails  <--- I can confirm that the
> /dev/vfio/devices/vfio0 exists. But open this failed.

This is correct output. Test is verifying that open should fail. If it
didn't fail the ntest would have exited with an error. A preserved VFIO
FD can only be retrived using Live Update session ioctls and not through
usual VFIO dev path.

> Checking ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, "0000:00:04.0") fails
> (vfio_type1_iommu)      <--- fails
> Checking ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, "0000:00:04.0") fails
> (vfio_type1v2_iommu).  <--- fails
> Checking ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, "0000:00:04.0") fails
> (iommufd_compat_type1)  <--- fails
> Checking ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, "0000:00:04.0") fails
> (iommufd_compat_type1v2). <--- fails

These are all correct output. Test is verifying that userspace should
not be able to get VFIO device FD only through Live Update session
ioctls and nothing else.

> Retrieving memfd from LUO
> Finishing the session before retrieving the device (should fail)
> Retrieving the device FD from LUO
> Finishing the session before binding to iommufd (should fail)
> Binding the device to an iommufd and setting it up
> Finishing the session
> 

This is shows VFIO FD is successfully retrived by Live Update ioctl.

So, you saw expected output from successful test run. I will change
the message getting printed to avoid confusion. I think current way of
printing ".... fails" is confusing.

Thanks
Vipin

