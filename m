Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B8A606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fcMpkfYU
Received: by kanga.kvack.org (Postfix)
	id 1A1236B0606; Thu, 26 Nov 2026 06:21:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177A96B0607; Thu, 26 Nov 2026 06:21:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068856B0608; Thu, 26 Nov 2026 06:21:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D968D6B0606
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:21:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71D2280463
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:21:26 +0000 (UTC)
X-FDA: 85477029372.27.6F99DB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C94E6140009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:21:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fcMpkfYU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692084;
	b=LRo0X4PjXsQSdBcXN5YSp75wXTS8xiZJn0HAa1CaXStJjINcZNfgaaTFq1IoRnousomSm0
	Zxk5YbVdN02FjSV2kPJdx3fmc0LePbql2LPk+HVhm4icasgm30PgokbYzWW1IX1L6GKWFa
	/3MRSZUbeLkkExsYllArzkgZvVMk+Sc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3UuAdt7dSVCdcMjg2v0KRdp+uX84J2DmHB+3MfIgCio=;
	b=orXT/QMfxJ3H0okzejmxsMHxXL7zDNdwtBKhjlihaclhPukpv89GiWMDrP82uwll3m1/Ds
	CPTQGIaKxlNPdrpQVVwZTEHCi28FEe1cmcIhkEEKIrQSNSN/11EiuTJxLLQSM94j6wNZyP
	iXE/2WgGF73vb5cmHnGUT4W3KYeDo+o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fcMpkfYU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 117CC40067;
	Thu, 26 Nov 2026 11:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721DE1F000CF;
	Thu, 26 Nov 2026 11:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692083;
	bh=3UuAdt7dSVCdcMjg2v0KRdp+uX84J2DmHB+3MfIgCio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fcMpkfYUPPxSdHrXBEDXH5r0pdjxRpjy93Zt4Kx20zZYirYAJUjl5pIDbOUxZecy9
	 Z6lQHKg19QGO7V9fxFM3spvdLuYK6N3NLsSac6BlvrOBeV3KF7LnhY/sgcq8gYEInD
	 yczJOoLOYSUrP88rqweUx8QDgqven4oPCZzNgQ3PvP5hHsn2/TNVrKqvbm8dQl6HjR
	 1PG6SEttsPiCPgJdmoZU4DHzPCx7skKD2aFyv42T6DcZXpQhgI7rRUU6Nge0FvvTDb
	 7veKQ6wKzE15RxQQ57HkIOQK+YOe0lgTrA5j0ufjwTuyRf/KkPx77g693TixMxVwx2
	 89vRCFbq+I60Q==
Date: Thu, 26 Nov 2026 13:21:10 +0200
From: Mike Rapoport <rppt@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v11 00/13] PCI: liveupdate: PCI core support for Live
 Update
Message-ID: <awgWJok0E3ASR7Q3@kernel.org>
References: <20261118223704.3286085-1-dmatlack@google.com>
 <DN0FL1752MH5.1FSZE620OJBM0@google.com>
 <awKlfqlQYhphXCvf@kernel.org>
 <DN2TQRX57C04.ZT5UUS6AQ1L6@google.com>
 <awVjqLFrXY_PCm7X@kernel.org>
 <DN3L5XQDSVO9.1NJFYQJTS16ID@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DN3L5XQDSVO9.1NJFYQJTS16ID@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C94E6140009
X-Stat-Signature: hfojr8awj37crfkjopune4ocb486sttt
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795692084-291869
X-HE-Meta: U2FsdGVkX19C36as0r2a9EstMZ4gwql8a2uk4dAqv3kT1K1QHK3Imn8Kko9ihWHX+wsI4ivxSBhljs2bgJOYFDafjHBRjVrs9jZNZWUHLDXdrUhc9XY5Zmnj3OFHuj1g/lRmO+QTEaX+rP9Z2GhJbWKviOR0OOvrFPMZeu+8kizj+TBZSb1Hd8If/NzLCLRcCd0sL2MufKlb+kA0IsSEb63WpgO+tnH173lwiCropxU6Mv0EqXUwTRb1NIT9fGHwmReZ7imS89syCzSP1LrCCCoBX+G9B7sG2TEACtmg8cNOu45/l1VYcXzlum72ZAv27ey0XZbMnrIxtjp4LFKfyMKarewHVFCOlwPwct8PBfTNgmAUZiK807k6nqtP7FXt82C7OWzDLP4obDrkTCXE6P6lOT2EvacGmllJ/tIEzOKqud4FNgP7j7EFcyTb/T/TD2AuTWvG8/us4s8Eh2+MeMSjiVYTGm3L+Ga2Vg50KQ4Z2fwpxrq5YQ6BpuEpzjuSvffFrZSGidy+asJXWnX8osauH/Yq3t/TBcusnmrGDbpunj3mSYvKrIeTcpsZQSQqE4xoigwu0R20CSHpMFydrN/FUe4V5wKTkCxhGV8qgQS2btrAWiR6p99bVEXhxvRvs9Ypsik/qDYSySjo3Uzi2xr6N62oARrmjZiGT6hdgnLE3Ry3ScnmRGoz3sYN02jZyu78FOTYqh1m12XgQo+OJQqk6kZFt5Z4kQCEuZ+dP3GS1P6B03Z7Ty50W1mJJDVpzuZOUyS0YQV2ehZEkn7UI76N3KcBmP7G8ljDeSSUn+iPNL/wEvDLMW9MHJIKvkuRYa0YOr4jUm6LP+D8AV4bBKgEwdHKwgbOwmTFHzLu0jqkxyPLxwXeKcOlkQ2XITctMUBRHSeQld96wW9d8QlxUzziiY13RbU4+4EieiDnpw6pnwm0tPXgEkdeGXdv3nGNGMwlusYpMMbOMxFcnR1
 bFf+Uju9
 HmVDzvgygycKK/kuR+DKw2sVzm+g7IdxzbHJa7cUJjXLZdwQpjcFJoee9WFEA2Xl0S8nW12XUduTp8tBjEawHApnBRizZTs6o1h442LLDW79XDMIvnbOAxZEMT6OiT2Y7TIm/etWB7nCt6qjFxiHcHG/MPkLw+gSbBy6sUl85BCIUOJKYiBKyX5vW0uKFore+XtZgkDhSdqELfEfUIdg5mizArK2iorod34gWY2J5PtZCOK+VB+tUy9dHtJX2/VhgyFvsS1TMcMSBIUKrIBZ7SO1QVn+LhTl7wvWothC0hbnY/yr3twtb+l3FdTuenhsszzFtMXI2b6FJqFJYr/xmpfsh2XJSh+QNhRWydRxRJzs5q2/eXDzGZIsUxoLfQLVxfv3EoQZx0uJzlQ7qOFB03NyggmvvIIr4pS9477jxq0d1SzaX9TNgutcUgQ7B/efWveAfBalTVx9PIekg/Zc15smrV7EaD41qfQobH7lATjrJRRgQw2DNaXQpuCpRlOCP+TSoVzkwQoP7fOibysjSNBBXcRECcv9YgRmVxmFC5RRMEgqnpIUz6US/owtWx2eUFXgUiNF1lU+Z1l4+CXKePYzk2FVbBB7TE6no+BEEg9nPYNw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 08:36:22AM -0800, David Matlack wrote:
> On Tue Nov 24, 2026 at 2:15 AM PST, Mike Rapoport wrote:
> > On Mon, Nov 23, 2026 at 11:07:04AM -0800, David Matlack wrote:
> >> On Sun Nov 22, 2026 at 12:19 AM PST, Mike Rapoport wrote:
> >> 
> >> Hopefully I did this all correctly... This is my first time sending
> >> in-reply-to fixup! patches.
> >
> > This is my first time merging !fixup patches and it seems b4 managed it
> > well :)
> >
> > Please check I didn't miss anything:
> >
> > https://git.kernel.org/liveupdate/linux/l/lu-pci-preservation
> 
> Thanks Mike!
> 
> I checked the updated lu-pci-preservation branch and the code is
> identical to the v12 I had prepared locally.
> 
> One commit message nit: "Freeze preservation status during shutdown"
> ended up with two Link: trailers, the original v11 patch and the amend!
> patch:
> 
>   Link: https://patch.msgid.link/20261118223704.3286085-12-dmatlack@google.com
>   Link: https://patch.msgid.link/20261123190045.2166865-4-dmatlack@google.com

I dropped the second link. It's the same thread, so I think it's fine.
 
> whereas "Adopt ACS controls in incoming preserved devices" only has the
> original Link: (not the amend! Link).
> 
> Not sure which is correct.

-- 
Sincerely yours,
Mike.

