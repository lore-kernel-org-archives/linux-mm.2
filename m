Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E39C6109024E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199286B0548; Thu, 19 Mar 2026 12:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A5B6B054A; Thu, 19 Mar 2026 12:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0603A6B054B; Thu, 19 Mar 2026 12:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAA9F6B0548
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:28:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4A841DC67
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:28:40 +0000 (UTC)
X-FDA: 84563346000.02.3500492
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id C1A6E120004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:28:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=qVsoVvGZ;
	spf=pass (imf29.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773937719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H52Zybh5o34dbFpC/ZH35I3IR0TeF3CcjTZ7JtQFu2w=;
	b=378Cflq23TiVYgkGtryQ5P+IP6gh+O2eeOGP/H6JBbapn+8ON7SIMV+A/4Gxx0Np1SFwq0
	+J2KILgO33wYqJ2hgROLZQxKujVXpmZ921GCkG+553T0lEHX8o88lalrY8hrW4L9wfwT16
	QWotdyKVc4ppEe7JY090U204xMGLIaI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=qVsoVvGZ;
	spf=pass (imf29.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773937719; a=rsa-sha256;
	cv=none;
	b=A5UUKiMe3vKQnbtBy5udAsIXM7sURt/Hpi33CKF5ckN0h1MChZ19ciY39d2jkQNGFMvqjO
	yW4eN8hejRV26wDOetThBHy6Iv+fTab8/TX1ALzeWg+vGzvlnbOX+WcKEk5mNJ8cWvpP4E
	ZyRtcb+7qgTkQGu4/HHdBdAt/cg6Qwc=
Received: from localhost (unknown [20.191.74.188])
	by linux.microsoft.com (Postfix) with ESMTPSA id 3BEFF20B710C;
	Thu, 19 Mar 2026 09:28:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3BEFF20B710C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1773937717;
	bh=H52Zybh5o34dbFpC/ZH35I3IR0TeF3CcjTZ7JtQFu2w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qVsoVvGZBgiMTYzcaPymyws/zFtGLAsJuSf42v3omgVhgy4V/7SM/UFdDfZU97k+C
	 vY11I8eol4oictnvBu/vQMefqoMTn+2RHUiOztqmT14YgkRFwnc3yMPdzePNXNxnxC
	 Y01VMPNtIKCj5VPxAbfZbdq9ZRMZ8zsrYw0n9y2U=
Date: Thu, 19 Mar 2026 09:28:35 -0700
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>,
 Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf
 <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple
 <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, Ankit
 Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li
 <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, Jason Gunthorpe
 <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet
 <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Kevin Tian
 <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, =?utf-8?Q?Mich?=
 =?utf-8?Q?a=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport
 <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta
 <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
 <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>,
 Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <20260319092835.00004887@linux.microsoft.com>
In-Reply-To: <20260316162518.GB1767448.vipinsh@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-11-dmatlack@google.com>
	<20260226170030.5a938c74@shazbot.org>
	<aaDqhjdLyf1qSTSh@google.com>
	<20260227084658.3767d801@shazbot.org>
	<CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
	<20260227105720.522ca97f@shazbot.org>
	<CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
	<abNOwcOTXqxCxNzt@google.com>
	<20260313083918.00005731@linux.microsoft.com>
	<20260316162518.GB1767448.vipinsh@google.com>
Organization: LSG
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C1A6E120004
X-Rspamd-Server: rspam07
X-Stat-Signature: bn7xthm8huq374hx3xoprb4g8roykkj3
X-Rspam-User: 
X-HE-Tag: 1773937718-326769
X-HE-Meta: U2FsdGVkX18o5HammF9U8Ul1sW5Lzmejk0YnjqJZUBz/8RtMgkYSUucO3JSnT9aqQEnBtdL7mKfkDn34gQMLU220b1nblsKUKEiKBN2Sy7bQAYvXPESV+QGOPzkmgXrFRd4hoh3odrXF3SNhoc4/cA1d7iefRQufsd63VUf+gsFdk6zr6fy3Xdg41dq752ua69SsTWbimRwXDbrTUvOs0YjOIsWU/6Jyzk4H9uNZqGgJvsw9y7ihCVvJJ+jbVjgVRRkFUuecjDfS2Le3iNbxDaJisrbnzf5JX4t41nv90lWXjZs6f76kov7NHCfoc9HG8aR2uuDnYvAHoxJEL3zYbAuCo3I3W6WPv5iNpyutrRChPR5KzRwzZNKskqn06UXukjW6JEXFpVmA/d33aL/akezRW5HXbJK7coeW0cyHkNefLAs2aah+9rYYwiaZOPu0oDKsAGMXfMqXc5RQ3dL4wmnialEaaG55OCxV+6OLbt+c3zi5cu1Ql1zR1uVg1hJiNBwSO0S0RPRwLnQplrvrvn35iS+jBmGxz1OGrkZz1PWzrNvZTeEc1kKiokQoujrKl/ViH1BIZyVMkZ6mGUlHwimaf+NPCM7UUQHg56c2CMH3cwIGpYDwtxlVIsPktW8g5YYFViYr0qeSXgtUPkA2MbTNB6IrY//mkuzFriATX6qAwmWGevSxvs3/tUmirCpP5bv1UIUCMX3EK8273UiBYmbnamnustog/8AqdmePDgvhqt92xvpAZzV04pXDcsNyJs+1dMFe6wrw+hOto/8rK09YFKoS4j2dtjhzOuCeI9IMuw9SB+R3q2/YSSThzaYH0J+wp/t/b1v1JnSn7Kj9GFdZugaW9/bfwMu7aekWuFNieZG2aJ8n50giCT2de2PDb4iWGtFceRsa6SwZR1qb3ReA09W6sFch+VspMBI1ds6LESQFngxXhshXvVtFTZwZo66mpYPDwehaFa90t9j
 hx/VrNtG
 waP927OyMf0x0AtSOe2O8fqB90nJKHcZt2HnKydmhRQBECZVy+xI5vOS7tFaGkL7O7immjKtcXQdX2lPYry46fKCbLNFOqNbloKbyaVtZl+S1uJiANv/DEkOW7XjXxz5jTCBBMvZtX+Jqqcv2ZHltGCgW2sKsX/HwmViToHYYMs2Kx8QwRu2ItNBjcyCZrguROAGTh8nOAmI/4RqEy6LZ4AB1uNQ41lt57z5qBrY2bO78DHGWb6rpz/Kf/j8wFEe3jqGxYB6FPdTGjqX3q6etujZJTT74VAlJYzi5VWUESsDh0FwAgkp0tkYR1wzZRzlNzzXzRmomBD3xi7GCwK0CnUDj8j9N4MQomMwykPPPdNpPPbi8Fn2c6MjzOFxXXshrKGvR2WucnxS8X5RVt1gUQiIGtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vipin,

On Mon, 16 Mar 2026 09:28:32 -0700
Vipin Sharma <vipinsh@google.com> wrote:

> On Fri, Mar 13, 2026 at 08:39:18AM -0700, Jacob Pan wrote:
> > Hi David,
> >  =20
> > > +config VFIO_PCI_LIVEUPDATE
> > > +       bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
> > > +       depends on LIVEUPDATE && VFIO_PCI
> > > +       help
> > > +         Support for preserving devices bound to vfio-pci across
> > > a Live
> > > +         Update. The eventual goal is that preserved devices can
> > > run
> > > +         uninterrupted during a Live Update, including DMA to
> > > preserved
> > > +         memory buffers and P2P. However there are many steps
> > > still needed to
> > > +         achieve this, including:
> > > +
> > > +          - Preservation of iommufd files
> > > +          - Preservation of IOMMU driver state =20
> > In the interim, what do you think about moving forward with noiommu
> > mode without preserving IOMMU driver state? I=E2=80=99ve tested your
> > vfio_pci_liveupdate_kexec_test with the noiommu cdev, and it works
> > as expected.
> >  =20
>=20
> Just curious, are you using qemu VM without iommu device for noiommu
> work or do you have actual system without iommu hardware for testing?

I am using a qemu VM without iommu device and with an assigned
nvme device. I use a low level nvme userspace driver (modified to use
iommufd noiommu mode) for testing.
https://github.com/SamsungDS/libvfn

