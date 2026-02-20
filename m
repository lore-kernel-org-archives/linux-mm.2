Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A84C5AD4E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 19:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139906B0088; Fri, 20 Feb 2026 14:03:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111596B0089; Fri, 20 Feb 2026 14:03:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005506B008A; Fri, 20 Feb 2026 14:03:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0DFE6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:03:51 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82C3158269
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:03:51 +0000 (UTC)
X-FDA: 84465759462.09.6B24A48
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 546A21C0006
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:03:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m+ziIaMy;
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771614229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nos4S2W/MH7DucXly1ylwYhWrSc0JMSiOmM7eQ5L0v0=;
	b=y6dH3p4eWOmiSPveMpuV7iMyc45JeaXwvggSXeJhKSjlXXnYW+vdbmECFMU4wAyD8uPE3i
	EH4IYqTDNY6y9Bb/2vuRXvCJXivaAIc1tGWlQxdzOKSdOR7wGPlzCPGVt96aC/ZaxJPOCg
	0FuTwRd6wwWdzQsOrwAJ3agJraOzuFM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771614229; a=rsa-sha256;
	cv=pass;
	b=M/9CXd9S9oqfKBELfzxlXBpsXz+u+5bGByMtqQSU16/ziEVO0hEdUNqJ3LQ0A9KPyJ1GOe
	Em9Qkk3H+EdHVdctD6Hpi/TUhO9na1sTvi0IwzdNV6lXkL3fkVQ8J0xGboHoQA3hUSWBac
	5R/2iLSqs7cCzMf2x94B/TR/4wdDSlE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m+ziIaMy;
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-59dd4bec4ecso2570766e87.0
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:03:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771614227; cv=none;
        d=google.com; s=arc-20240605;
        b=kJbUjlExOfdDfcBBMI4D74o1Nud7GALN4S/zF+oiKTqaBIK3t9DVFXawbHxMyV0DcX
         HOLerdCKKm82mcpnxsvuJ7KXcNjH+aYNbUDByC6lc99Sc6ELf/Rr6y7v0AlVmGRPjkhL
         4UyQb/b8bDqBOyLPAi6AvnQMaVwSEMuxHCRSJjpk0nb8GJeWV3RlWFnB1lHCkcqDX0Ot
         fPlsm8AMGoFNUIecEDaGhVUvPtmuGZn/rleVLUagR4iMsFtoeM8+D8jNuCLsQHcnBUYX
         lKuslycA4FQnLbKik/HuUGd8jLEdXbRjkJUlvvWotYB0laOQxLduJ+avQONQ7rPtUcwY
         0VmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Nos4S2W/MH7DucXly1ylwYhWrSc0JMSiOmM7eQ5L0v0=;
        fh=LJjvDt/lRuYtrCbxv5NCsXNsV10CR7XR3eJ2IjzDgxc=;
        b=Alx3bbNakUefYcGHOvfUGbcCH5ei/8c/QYrJiKVq5XeJ6rQhI26nplq2mrjtjGzGzo
         S6hmffqTU02W5lyl1fbXG9PyK6QFlPE+wFmQtV3n47EeMkF2/w3gSvDcILKm91gwI+aX
         MUZRJ+YQeUCP0IAXfdnudMbHZ5XSaR9Ku7LfcmsfflUftURsBlQPDesgiB8/Ut/e+Xng
         IP7pqQAwbVLX4lNNzgul32WWU+A7aRAmZpQCyJiyLdqo97zmO3AANhPWS4adw6IHYYBU
         1CNC2PkgBeIN9FVksyDN7YJI1FSw30HnrFDQLdgnZ8gRVUb7w78LtFx459wDqfJ6XymQ
         iuXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771614227; x=1772219027; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nos4S2W/MH7DucXly1ylwYhWrSc0JMSiOmM7eQ5L0v0=;
        b=m+ziIaMyqSjYBKGxy/jX/3sbhVqmY/rlpVAslVBlFVqDhI4qlj6e/pW6pe2ekBcSHS
         cLgTH6tF89C3zVmGIRLyLsv/sZiTYoRUJaAOXU5LMFgdFwKPR4N9f+cN1zcVqIoRvJ8q
         eFkS9KwQMy63tSDNxNUQLs+ptzY+pmcT0VeTm8hxZFv94k9wCVAzC+Lr+vDVZCoM5ejl
         Oe5ZUdPT5RQmPpOQhnP/CYbuscnlFGUfeayNR+mrpABBg2NFEB5nBIAZLc3Qy/sq4/3K
         CSeDZ2SE5wnbCPLFjKB5R7jbzPA/RbS0OOgW8+cCKkDJa2s87CPATr+NMJu7FIILfqe7
         VMew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771614227; x=1772219027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Nos4S2W/MH7DucXly1ylwYhWrSc0JMSiOmM7eQ5L0v0=;
        b=U0fuhXiyVGSGbRExIZtL4tW6nMcYLELMSyD6f8R3QvEev2ONNVIdhQKRYycCFF5TES
         F+cLSKpHtumQXlMRQAo3Ny+7QkXgbEgEpALRbonIM/Uj98YW1J885Bg/Dla8h+N/S6aI
         SyE3RGbZ3VHAVP3tCx5s023Hg93T1dwa1htggO1NK1w5SHsjzcqonPY+nZD2GGnWwIJ7
         g3mGfYlQ2zbTmuI2HvWLixRyOLQqF4s5qyV/Zandy3KoorQauMdXC7aE0vk0gjypPZse
         MBKzHut+ag/S2CCNX9JW1sBCiOeTiVuh8xf7K9pRkDRCNaHihZsMibTox9YBRckl/6EM
         UhmA==
X-Forwarded-Encrypted: i=1; AJvYcCVnXYT6pFjZTzCCpXVqqQgZlM0G7Jo/lXiQLNnmbrecHGF0yxUh9oKPdTlr6qtescDknbNSHIZScA==@kvack.org
X-Gm-Message-State: AOJu0YzaYnMUTd7SwexV3PE7IoHFSqo3+L2m1UxH2euCn2MueOwYWlSy
	n+R9msHv2sGPgN7enl/82HR5tsMjOXO0jRKyqWAfpnftwYwdL8e9anbwwF75CYHHxORsB4E1OHs
	7Fa7qcOoNFqrQl8YRlnW55F1sk44dV1MZA6WxOYFe
X-Gm-Gg: AZuq6aJwAty7kodpAAdVj8BbleoB43v8qCMW3V281Et+H/H+a02BeMo5N6HOTwJmwOJ
	18aT8E5fi57QfYcEGWFvrrRpBSk5fFv7bG3ySvluOC//5UoTq0hLHHiVqSAo7dmfpc+DsvapNBE
	RIUMpzihX4+ah78I2HbSmQGKi3DnXn4tm8k3XxQLVf3ZlzSwpYSO6H2ut6U9cec9tgjYUoyEgcS
	nGOEKEcpWyL/B6PkxHC7k+fxQ9Ncb9OzLEyXos/3zrg/nd0Rcu/p+Zu6M4aLxmHOMzxwR+HNAkA
	RT/e48FNIhvkkU3s7A==
X-Received: by 2002:ac2:4c56:0:b0:59f:8546:203c with SMTP id
 2adb3069b0e04-5a0ed894dd1mr165159e87.12.1771614226924; Fri, 20 Feb 2026
 11:03:46 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-3-dmatlack@google.com>
 <44484594-5b5d-4237-993c-ac1e173ad62e@linux.dev> <CALzav=d1ZrHrWd-HhZJ8aY6aqxkBcLoet_5+-LL1mOakVTj6Ww@mail.gmail.com>
 <7e49472c-4bbc-49fe-92c6-621e4675d882@linux.dev>
In-Reply-To: <7e49472c-4bbc-49fe-92c6-621e4675d882@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Fri, 20 Feb 2026 11:03:18 -0800
X-Gm-Features: AaiRm528gVDC51Vc6VmuyDJufgtIlxh6fV-eX6614wdRe-TzmLDadtAg2AEPmi8
Message-ID: <CALzav=dEykMZGsqz35TgvPqqZZFzG0kqojmry1Ya+Xf+zEgyAg@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: rrmds9m4cfrgtn6ynxsuozqecjgrcf9t
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 546A21C0006
X-HE-Tag: 1771614229-423987
X-HE-Meta: U2FsdGVkX1+aJIiwJ1ZjHQ0V1ZdypWgrd9dlvXaH6zAnLd+W2wymbVs2V62L+Np8IwbFyHtXgza7lXNKl/CNYgQnYvAYLZLtWec3q8Bqmp6J+ZMDSKsoRqZyzYnTjo6yCe5XA6w9/OywB2Lq/NzO/5AZJGMh40l+Fj4cQT9HbdAJI3ILXHbeYMtJE2/dB2P6m0HCYYfRAd9cfxDZLJEXYM2xmn8xI8EdQJ7w/SWNve5GAqh+qoMkxgTp50leOfvvsxCyz8Rq0jQ369zIjEsSoqRZD1SIfv7gbUZQ7F/boQaPje9twzAno9w2QYLVbyo+vnFKtc4kn7/cIz7gxEFWX35Ar0gzGlu2dDTkEGONP1esyIURCErA3FOoAYL5hieWC/EW6pkmrYAXYs0pavByrEu6oLuPBi7X6heQdi7HR5ykrEc/W+ZHlKtxXFAAoHxjV4zzKWtAaVmZUgCl1d085rdKsqXTjjEZTEwhOOVKG+SZrCf4cG5Y3fNVaXUS9RV0qUH/3u444NInyjEVKJ4kSW3rJrRqNThybINvE3Ude9IfCLzPe35sOSaYmKfKyqe0Oeg3sw2Vi4vHxMulM5Z3Btsn0IqkwKEv4ZkCPdC7L9M2Wj5ss3wblImv/BzFNttMddX+HXVo8rgqMwwpfo7xdCErQOSiECf+88eX3ay3EfBZJ1KY3TobnnXrCAJF8VA1GbRLQ647BRyXsrBqVFdqNwYDQt8rHuKHdY/1z7T0wOpzZ8nE+/1hmTH2OBPR0p3EGlvpJHU7HKMyjcGBgtOguzkPBQAIpSTcXpYbMQMDIkSDuc5T8f7jP3l0RGfSNALPeI5FpqD5zSL0hrou8yeahNC9s22o457T9nj+9ji0RPoAe5J5awbTbwo/2GkZN3eOgs9Wwa/FA0iNrODTxOfw1dbok0/jT2yuiXsGyFXvITDwuvvfKvsSpuW2FG4EawT6WcUmIP5CMP9GWsLe4xN
 I2Z2UE/F
 Ey3+cBwBY29uVIlUmW5c7qHIFTCRHuOQbIuQDENPyuj4Tlj2w3dxYpZTKdFs7Nsik42PVpZ9RGsqVLluNTAHPSQA+BpNTut9D+lx4SnnBig82FrgFbk3SOw4R2EKfd3IIJGYB0iziFFkpKW+N6c/mZ1zPM03V5Zr5HberftF6JiWbfKakuMEzfwfqiCxIb5FQrRiPDKx09XgJjBIXmjaalhlo6fWAlDmAPAV++MkZXqRKlzU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 3, 2026 at 4:10=E2=80=AFPM Yanjun.Zhu <yanjun.zhu@linux.dev> wr=
ote:
>
> On 2/2/26 10:14 AM, David Matlack wrote:
> > On Sat, Jan 31, 2026 at 10:38=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.d=
ev> wrote:
> >> =E5=9C=A8 2026/1/29 13:24, David Matlack =E5=86=99=E9=81=93:
> >>> Add an API to enable the PCI subsystem to track all devices that are
> >>> preserved across a Live Update, including both incoming devices (pass=
ed
> >>> from the previous kernel) and outgoing devices (passed to the next
> >>> kernel).
> >>>
> >>> Use PCI segment number and BDF to keep track of devices across Live
> >>> Update. This means the kernel must keep both identifiers constant acr=
oss
> >>> a Live Update for any preserved device. VFs are not supported for now=
,
> >>> since that requires preserving SR-IOV state on the device to ensure t=
he
> >>> same number of VFs appear after kexec and with the same BDFs.
> >>>
> >>> Drivers that preserve devices across Live Update can now register the=
ir
> >>> struct liveupdate_file_handler with the PCI subsystem so that the PCI
> >>> subsystem can allocate and manage File-Lifecycle-Bound (FLB) global d=
ata
> >>> to track the list of incoming and outgoing preserved devices.
> >>>
> >>>     pci_liveupdate_register_fh(driver_fh)
> >>>     pci_liveupdate_unregister_fh(driver_fh)
> >> Can the above 2 functions support the virtual devices? For example,
> >> bonding, veth, iSWAP and RXE.
> >>
> >> These virtual devices do not have BDF. As such, I am not sure if your
> >> patches take these virtual devices in to account.
> > No this patch series only supports PCI devices, since those are the
> > only devices so far we've needed to support.
> >
> > I am not familiar with any of the devices that you mentioned. If they
> > are virtual then does that mean it's all just software? In that case I
> > would be curious to know what problem is solved by preserving them in
> > the kernel, vs. tearing them down and rebuilding them across a Live
> > Udpate.
>
> Bonding, veth, rxe, and siw can be used in KVM environments.
>
> Although these are software-only virtual devices with no associated
> hardware,
>
> they may maintain state that is observable by userspace.
>
> As a result, Live Update should preserve their state across the update.

Sorry for taking so long to get back to you.

Userspace should serialize the state of those devices out of the
kernel, persist it in memory or on disk across Live Update, and then
recreate it after Live Update.

This is why, for example, KVM does not need to direclty participate in
Live Update. The VMM serializes all KVM state from the kernel, saves
it, and then constructs a completely new KVM VM after the Live Update
using that state. KVM will only need to participate in Live Update
once there is hardware requirement. For example, I believe some of the
Confidential Computing hardware virtualization extensions require
certain memory structures used by hardware remain in place and cannot
be reallocated after Live Update. KVM would have to participate to
preserve those and reassociate them with the right VM after Live
Update.

