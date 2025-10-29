Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34332CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 11:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32FCD8E0066; Wed, 29 Oct 2025 07:16:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B9848E0045; Wed, 29 Oct 2025 07:16:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A83A8E0066; Wed, 29 Oct 2025 07:16:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 041C08E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:16:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B56112B268
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:16:53 +0000 (UTC)
X-FDA: 84050899506.20.0667360
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7C80B1C000F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:16:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KP2OTyxf;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761736611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WCvsVqRRGfW4cQudR/qxQTL/2JCwBDViidhpr0L3UA=;
	b=XHfRTHNn1+RIRaaFp7rFSnZbAP+3p4gP6d9887qgSFmtgu+bO9ST9bWDjlhwjTeqT/hpX5
	PjzfBK7fwD7BH4+hUeIBlrtSXu3AbOeVKScq/fb6jhvA4eEtjnvIVkzhtMwd10EQIboDml
	ghoVbXlPTliosS0Fjlu/8F789Scib0k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761736611; a=rsa-sha256;
	cv=none;
	b=K4dkwUF7xWBWhY90Gz4cmSpg4hODzo0SagRPyGWOyuuPYb1/NXO7cSmffMxSD4xbVqGilC
	jdvo294eKkwcfj6sCH4KS6GyKZ9InqdGxdy+8Xv1VR9wCq4h9O7eVr5Y1Lb6Uz1fT0U1oH
	6y3acdszQAdmUagT5hZU7Obt26Nleto=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KP2OTyxf;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4225C452F6;
	Wed, 29 Oct 2025 11:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7380DC4CEFD;
	Wed, 29 Oct 2025 11:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761736610;
	bh=iNs2W88xibjLrgXbOdvLwDJqMNBdJqCGzzdryH6uikg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KP2OTyxf1XEj0XZm6VpkKI9dPY50h2i37uyJuZ2Uuu4cUA+pvJpietR6o0kHynmFd
	 o37IcYYOofwwx3v03YdOQEeuDmvPZxqON1407AhDyQsCW4ClF5MwSFBHniLC635610
	 809xOAJik6txGhSk31S8hz1lSV6PQ1JLFaRUfAwFjKb+r7X5L2UpzwYpKPRI+78uvU
	 2bMedsgAvXw1S4irD+7v0ZOVykEqrlMB3c/StkZiAwB+94u+cIt4K/se0CecNMJ9Q2
	 T9BeT6oRxpkIAY+WDhujDlSDHrkxFHfZsjvCkpCpMKiHzbAFdVhOlAXIglXcArcIum
	 JgDH7RYgSOMdA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8FB99F40068;
	Wed, 29 Oct 2025 07:16:48 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 29 Oct 2025 07:16:48 -0400
X-ME-Sender: <xms:oPcBaZO6lfmC-Mua3l16fCzkSAs7Tx2I_WumYQydLcQc5mVJPEisEQ>
    <xme:oPcBaVJYoXXvLx7oHEQ-CSoTk-5-i53_LpLSHk1hgLsjKCt15WTx7YG0CvBQ9ssfl
    UsO3ED-qjNvtn2nC2FBqYEAljgntSVpjDLc7WF0ugQMG7BvTSwUV0w>
X-ME-Received: <xmr:oPcBach5kS8k0d4J0t4p33_OwiQduxzSe9OQqE9jft7xmvDSqMcET7r7peVQRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduieefheelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepgeegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegusehilhhvohhkhhhinhdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugi
    dqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrght
    rdgtohhmpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrd
    gtohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhmpdhrtghpthhtohepsggr
    ohhlihhnrdifrghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhope
    hlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepnhhprggt
    hhgvsehrvgguhhgrthdrtghomhdprhgtphhtthhopehrhigrnhdrrhhosggvrhhtshesrg
    hrmhdrtghomh
X-ME-Proxy: <xmx:oPcBabeMIrjhCPKlIhdYpD-rHjd-YcfavdcFH3S0eYx1o4VLRERtvw>
    <xmx:oPcBac6KBarARx_Mfm45pzpP9ZhWgQra0xWowHGT287EcoH6-SmJIg>
    <xmx:oPcBacghqWlpd57EAZ7LYWaeysojbbfbtnMM-5_7T_ceygxaLVwThA>
    <xmx:oPcBabGhd8r4ILWmiKPmY4EKtO_72rb_uqDDMyzcuTZdrH9yuAHrpw>
    <xmx:oPcBaXU_6r1C8H2YaGwU98AAAVGTTSx4jp-fGDAqnrtsWWOiHMOzq5RU>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Oct 2025 07:16:47 -0400 (EDT)
Date: Wed, 29 Oct 2025 11:16:45 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm: shmem/tmpfs hugepage defaults config choice
Message-ID: <ivpba53svcfavp3f4pfqfm5z3goht346ri25rstz4dteggcbuf@73bnztkf53b2>
References: <aQECPpjd-fU_TC79@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQECPpjd-fU_TC79@shell.ilvokhin.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: 9rzje5edzzqkkyeydxcnymscgrzqc6t3
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C80B1C000F
X-HE-Tag: 1761736611-876464
X-HE-Meta: U2FsdGVkX18kdhODWhba+wQZrlkUveNe8VQ/tNDWJPZb+x6gSSa3a5wjLA9l4u/keJbwGvMQng+ifv1IOaMmKmFyoot0vQ4+KFCFXybbDOYZ16cTeMlPr/u3mzk56/78R0Aom9t+R8/XWM70lc25okjB0r0oqpsuh6Xu1tujhmDNpjQUBl9AsXlSehMzvEsg0CIcn5TU2RiUSzUtfJAXcFzpgacF9jVz7f73Bs+BqfZohYuhQ7FNhDWmsWrut4lxxRFTXYxNsZY+at6N9oTWzfJuLS/jDMclbb5fYKDao51Sg9MsodoQi3N+4702bkWS3V9URwg9Ipi/z6rmM/z3i89Ge9v9SKRsbuuuX53y19NYjqdjgv90lk/l3WBb+LpM50vwSzqQ02tTg6TUilhXgZjxE7TqkDLNVv280th0fF0Gd+1OR5up1DZTl6Ipb3K2M4OdmsXgYujqe9pEIaWUUyznpbLhsQN2PnewrM6IA9xz2+4QdPndr9fIyoP791ejrWKf1Ysmz+TaHbHm8htLUtAJJ/Nu9oemNlOCya4PiMzpWHIeRCl6FekehPgI5cbNqwetcodeBvhJY0xNaZ48aFtmrMCLb/ehPe2SC7SEClZrQeWij1yidKWDtBgcozOnzaB/cBwF3JY6biKEmfUcHaPP622FbCkUlZgXn1S5qSTMKY9W5S5m09ZmOxcMEgpZIQeOlM7em4sCgnsODXLAn8JR9rsxC/QwZW4o2Q14OZS+Jnr1GmKYwPjsgOCM0cs+ii5hv/gb/Ky4k/HjYptP2kzMZldehYfQ+m2YTEa5joKHy0T68nA8YsNCwtJK+50ULOkQzrZuqahAH2pOz+jz8cJeBZbDUjJJeTpKglfFoyrLMLML7ncc7XwJnk4DYT5eSWLD3LS4Gq+Z1LPsdIY0On6NPMlixeJP5rQZR4e8sox9TLmGwmWRskpCPUmE0ITNh0dplTY+OLLnT5uUw0D
 aKatPpz/
 Qc7bRpu3T+DGEVYiALbUv66Y+GSSgSoqokxiu0/Uha7sUDTniyKcwbCsM6JKWg+6H6B13s/bqIlagAH3dHeGW9SMVMqwHAeBYAnEVE7EftKYAepj5lFkCchHIMzoRyoieJxIP51mcNh78ncsvlw4ozcoiMtYpDKPyeeBt4Fs2NXOVoNuqyrvjH5P3FRDcKjEFqlp4JkqW7fOuSGSY7wV0jKLdgQWev78D4LRAJqtloRt2ZEcB5cf5ntRESf2V5/QeyjLs0TAZ2/WoemKS9LzPLkVBsUSVk1+bWxe1LV39fA1YZO9nTydw9As63fshektKGVv5coRgTpZhPxzPjQL1aeophIly1O9esdKHcfXso8efRmiFLulUCMOHwzO60I+fdDPdXWQlMeVOy9ex9aDXmbFHeeCQzOoUC36v33KAqPMsvETLsevZA15DcSOaKo0EaS3G2YmcJbHkAeKW9DdhVNmBpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 05:49:50PM +0000, Dmitry Ilvokhin wrote:
> Allow to override defaults for shemem and tmpfs at config time. This is
> consistent with how transparent hugepages can be configured.
> 
> Same results can be achieved with the existing
> 'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' settings
> in the kernel command line, but it is more convenient to define basic
> settings at config time instead of changing kernel command line later.
> 
> Defaults for shmem and tmpfs were not changed. They are remained the
> same as before: 'never' for both cases. Options 'deny' and 'force' are
> omitted intentionally since these are special values and supposed to be
> used for emergencies or testing and are not expected to be permanent
> ones.
> 
> Primary motivation for adding config option is to enable policy
> enforcement at build time. In large-scale production environments
> (Meta's for example), the kernel configuration is often maintained
> centrally close to the kernel code itself and owned by the kernel
> engineers, while boot parameters are managed independently (e.g.  by
> provisioning systems).  In such setups, the kernel build defines the
> supported and expected behavior in a single place, but there is no
> reliable or uniform control over the kernel command line options.
> 
> A build-time default allows kernel integrators to enforce a predictable
> hugepage policy for shmem/tmpfs on a base layer, ensuring reproducible
> behavior and avoiding configuration drift caused by possible boot-time
> differences.
> 
> In short, primary benefit is mostly operational: it provides a way to
> codify preferred policy in the kernel configuration, which is versioned,
> reviewed, and tested as part of the kernel build process, rather than
> depending on potentially variable boot parameters.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

