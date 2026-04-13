Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C257E9381C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 05:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9231C6B008A; Mon, 13 Apr 2026 01:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8E96B0092; Mon, 13 Apr 2026 01:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836916B0093; Mon, 13 Apr 2026 01:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 726406B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 01:37:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13375BBF31
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:37:58 +0000 (UTC)
X-FDA: 84652426236.14.474BEF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D44020003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:37:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CYAidPKq;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776058676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9xdq9i+G0zulG6323Mzb3s5ZrM924e/Sx6+1KNbAKI=;
	b=uWrnLa5n+6zRAC0OrzwoqDy1RAnbouGi7ZVXJ2LEdR247aXHCJ3DXTPAR4PTKH3RVz0eGL
	qDA1lsyQeZj1zDrQKYTeb/yPi9pURiaMG5cGFtun6ZRPOM54jDXsorw1AqdxFOMSaY57mB
	XMyKbkHqNoIVcxT5Sp8U79ObIOnWkmY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776058676; a=rsa-sha256;
	cv=none;
	b=pxQUsysaa/giTjNICD1IbeMOyOvlJdq3+z3whnI6xeX5lu+MG2y1MFsWQpBjvJtCVMZy6n
	hNLJPZ7aXuq8wNnsSEyxO4qGBSRhHh8y1WDB9Pc1161T7A/csGkpz0/f/oTC8FO/iIRbvl
	13bDTJYh29DTLl+kvZ4zvdZUoa5qqjo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CYAidPKq;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D5BE7434F4;
	Mon, 13 Apr 2026 05:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D756C116C6;
	Mon, 13 Apr 2026 05:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776058674;
	bh=c9xdq9i+G0zulG6323Mzb3s5ZrM924e/Sx6+1KNbAKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CYAidPKqcLB7DggtGonSr6XqmwbLLK9P1gNbNHNBTA3mq0vH1b50IIBl5v1zbXXps
	 GHHshy2hpn9wUga0epb1dJOO1e0BFndrNx4clnhZZOn7zUnMfzMx6U35BjPalsVv13
	 qe/HFMZY82osynewGvSj46/ZbqIGUSh+xDIhvSd+QTqUHgM4YzoDv1x2RvlqnEOdRo
	 7wWfyVwal3hQDzOC2w+RlZOAL/OCU5glHRpaDPGFhkr7WJsPEXrSyKatLqSv2fukC/
	 Y5fVO5ybbUpow/LSffY8kBaDZD2Hl75evpdO2SqpzWa/lnBVl0wUwWPho8OkumYSk0
	 wrCdvcELxpHgA==
Date: Mon, 13 Apr 2026 06:37:41 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, 
	"linux-stm32@st-md-mailman.stormreply.com" <linux-stm32@st-md-mailman.stormreply.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, 
	"linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v4 19/21] uio: replace deprecated mmap hook with
 mmap_prepare in uio_info
Message-ID: <adyAzdYVm95MZny2@lucifer>
References: <cover.1774045440.git.ljs@kernel.org>
 <157583e4477705b496896c7acd4ac88a937b8fa6.1774045440.git.ljs@kernel.org>
 <adx2ws5z0NMIe5Yj@shinmob>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adx2ws5z0NMIe5Yj@shinmob>
X-Rspamd-Queue-Id: 3D44020003
X-Stat-Signature: dredfe9smh9f3xpai85zafwo9dc6rzun
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776058676-6196
X-HE-Meta: U2FsdGVkX1+rEb1dFSHopO4bf2YSJ2B0hgPlB0d4R/M5yg1I2KUU2bUHolngyJIDfnQTwPJyzVsvU0tVDdLJZfgnRuvH2TdMNXmXbr/XVl+e7MKUZQdZXDTZ5pe8rUvAvEkQLL1hKIc00Ne09VsgKJQXP93vPyOg9P6bTsRpAlW75mtLeC5Us+DTGJGbw6MOxbuGYJUPL8cXOoa6dqeODolTOorvhIUxkdTyJi0I4NZIjPdA4dSk5VqFVeJKpqYVNcmaFA1eGcxX1S0VDcp6KVOC8ukpldr30jILINUojfQ8pBn4pXs8rCodqE8r40aWkUXAc1oTFiD/04azMbwHisWr0Y0fK4SM6gJKGy0jasCui3AXRsqxBWGm0TNpVtsaAQwOZ3++TeKKNIbpkG7nQNsHhcM99e3GzcmjIkFORaoWCieyV2dFHOjA/juOW5Z+gD6MO2erd1HO/VjLtPFXdb/Wa3UCXEosaGNoUh04OeyI4SQBFrgJGIlfuDpmheoOmyDB13yhdURm0zPIEn8JkhtTq+pTGAFidx4Pw/SMPRghK08eI7WNAhhfGGyCDWlA7LuK0txEnj5j2SPxNCcNpdPZlwZsn1UA75A0mOpp46fokD688nje6HCwvlvwOPcZkvL1o87np/b+stJ3PtYTQK3OZ1gi43FyqrwMOAcRf7gmvVxhF2Fwsb7hOR9wAnEcvYkqYXLK24Zs1Zc41tEKct7hyJdSNYThm6yLw9zgRtWPv8/++W0yQZzVwG8Ih2v+alynZ09hbd3y0VSB24yZVfyu8tUkkGCpRVZG+Gvvu4dN3U8XKI+UFN/xDEsYfySB9YWAWxDAvmG3XEgL/ZOS8t1sGBx6t03NO2sI1wDvGguy4Eh/J7izlUDSckFydC1Z5UdPZp5IWQOxKgvBGvUfNrw5t6Z1Z6vIOLJzJHDu+Mbmp5KPdska6wb5GMq8VKe+uq7iJsfBZ26gnWzL2E+
 Kp7P/bQs
 7Vp1QWU9ExtNpRccTspu29cwgGFE7cnKUqtd0E2z3sC8rPvYNV8UjrBVUpqQdg6d93t1IKCo7V6cdu7PpI7tL0NVPhyKK3OabHMdL54FiFMTlSoU38f5PSHRMZQU51xQbH3doXXyerQrKBp/rBoVkw9n3fm7ZI6Q/pv9ubDnrRaYAN6fQ7IaOJFMiyvySDGqF7QhE46ORvDP6NqDU/bJgh31XHyeW0dmCFGV2eJ6lVG+ADTEbYVX5WryyrUkuSbjOyVqWBwKpfHrqwzHewDqXfGu+ZIic+da3BbPBTGjga4XQ6k4pVl+v8PGeV6OtiN+8CrifKhGkfFRJJe3jbyVACo12rLtAuiSjke210ofWBLlkSO87PWCpvO/cVn0BbaCEwPoYi8aHyyfPienZCSN9XcXL/bH4l1nKAMPVf4qgS8URJrV3tPk0C8/V1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 05:14:08AM +0000, Shinichiro Kawasaki wrote:
> On Mar 20, 2026 / 22:39, Lorenzo Stoakes (Oracle) wrote:
> > The f_op->mmap interface is deprecated, so update uio_info to use its
> > successor, mmap_prepare.
> >
> > Therefore, replace the uio_info->mmap hook with a new
> > uio_info->mmap_prepare hook, and update its one user, target_core_user,
> > to both specify this new mmap_prepare hook and also to use the new
> > vm_ops->mapped() hook to continue to maintain a correct udev->kref
> > refcount.
> >
> > Then update uio_mmap() to utilise the mmap_prepare compatibility layer to
> > invoke this callback from the uio mmap invocation.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Hello Lorenzo, since two weeks ago, I observe a failure during my kernel test
> set targeting Linux for-next branch. On failure, kernel reported a WARN at
> __vma_check_mmap_hook [1]. I bisected and found that this patch is the trigger.
> Here I share my observations of the failure. Actions or advices for fix will be
> appreciated.

Ugh yeah thanks, this actually needs to account for use of compatibility layer,
so probably we shouldn't even assert this as that isn't easily detectable.

I'll send a hotfix for this that can be bundled up with 7.1 patches.

Cheers, Lorenzo

