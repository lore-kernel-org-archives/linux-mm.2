Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 684281099B3F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4A16B0124; Fri, 20 Mar 2026 16:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBBFD6B0127; Fri, 20 Mar 2026 16:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD1C36B0128; Fri, 20 Mar 2026 16:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC44E6B0124
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:43:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 792431A0325
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:35 +0000 (UTC)
X-FDA: 84567617190.14.B2D1A4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id EDE88C0007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CypuAB31;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774039413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XzczC32VV00AwDiIh21zb/sCHxyX8rnSOTF7An9uPcg=;
	b=CK2J8SfgZhAXIcRd9unLHs34gHQGJJz6pL0SfYWjck1L6JTf+PfbUXrVPawxMHGG2iqPSB
	3i7dHbR20779Vk5bSjTJXDyUVKz3KY0TeN1HK4rL8eoS+06SuEo3Rlzm3qj2hgLYEu+Wl1
	wtPmTEVs15G71JPCYq4rwpnaxFuzkLo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CypuAB31;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774039414; a=rsa-sha256;
	cv=none;
	b=gaESy810lJYfb8hadQeqnOieLj6X5YrfD+Yl7BwHUN5zQKhbL02cb3GWUylQdLcRKRFw/e
	2EDibIHslcq5ZJZH8xbxXHBPJDgtbHAhK8rhqXId+iY/MIWsfK29L77aWXYsgSOnuRWwSz
	32UXt3YQjFO+dgg/XZOAplnSoErUgqQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3419D60154;
	Fri, 20 Mar 2026 20:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D20C2BC87;
	Fri, 20 Mar 2026 20:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774039412;
	bh=XzczC32VV00AwDiIh21zb/sCHxyX8rnSOTF7An9uPcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CypuAB31keYeNpOx6+BKaUkwMJAfZXn2C8u2PsOdPDThy38YXRFbY3/5pqAtP2cro
	 HcRPsPMEoqtBOp0Y89OOq0diEXH+QJUGD4o3QQPB/lSWNd63ck3NFlPYMPPWlX6Xdh
	 NY1MxQ8mtYPuDD9Hbj0TTMRMJ5nHPBd59/x7XDvfNJi+dQOQLqpW3Cc07z0rxBdKVg
	 Zj4xs72z1sb5iNfDp0ESmZJVtFbjrzICMsXM1S8xUE9gwY/R6UUKFhHfPVNUMKzrEc
	 uXQMf3LaWOivk84XWig7hurOoAmqWcKrF5KB1u4nDb4nrI88wQkI0PYARg8sxzO+Xv
	 /gE1kUOfP2KbA==
Date: Fri, 20 Mar 2026 20:43:30 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
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
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v3 04/16] mm: add vm_ops->mapped hook
Message-ID: <f711f67a-9c87-4c9c-8ddd-0a78df962942@lucifer.local>
References: <cover.1773944114.git.ljs@kernel.org>
 <a97366fa6f22a0ca1340cfd2b0d4df87c80ac80a.1773944114.git.ljs@kernel.org>
 <c9068fbb-a23c-4342-8638-3b11897a57cb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9068fbb-a23c-4342-8638-3b11897a57cb@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EDE88C0007
X-Stat-Signature: gzzmujfepttfhea4wcnbeycmg7bo8pww
X-Rspam-User: 
X-HE-Tag: 1774039413-669963
X-HE-Meta: U2FsdGVkX1+64G7fQ5IVnAp0lNYRX5yEEF6ElmMlFFdgiIj9ah0wt+WF1TydrLZSKFCpCMLgswx3Z21bt8qSqVEfuSPG9hvsfePKp8tJmMN3yS21VOCcq/duDnCWqS4NJnlO51HhtDPtQizr6FSG6A/8R0t9k1BSxthfwmSX3PSk/a/Tm5mMimP2W9uHh7Ql0TSleKJjB3thlfy9q2TibHnNwLEd4WvepMRB/jt/mv4LPSK4pbqXVSvpNes/2nIKPyYJzM1mVpOPBWLfFvSkuvEXdkIivGKpgk63kJdvyo/Mwa0YE4qD64hXzeIYN2CP0n0FibJIgSwn7wDu6O5mIeaNxXgBSFYEAicu0EYsZ0J2kZfsKkv1XOxuixEeOZevUgAq/JBItGV2NYeJyFo2dKUQVaTr4pR/J0P6cXzYz04BKNCPxqjp8U7piObTlc5oRdX8SSFQTv+5l53dgaIzP+2gFMlVckMMUsKP7b6YSIF1zA/ErVTWQsabpEH4sqEz9+aULi8EwT/182i3VnTl0JBaxBx5D9wG8AiUHcfWLN9NNXSQuWw7WdnNBqyjxFSQDqYL6cwIeNwmG3VHYY4nhsDsPv3JIJ/BA5vTzI+EgUuODMfuDVcG406Y7HYnxCiVQJoubG77ouM/adpkb4ddGIYrb/o+HRdedq/isN5SSOPorEwmQvFPuh41/BZp4Phln39/3iQtVgaH9c5easprjsDAjdkr74AyEKXZA/fnDRg9hZcW/Lw6+7IDZBzjHSXnWAD98/ZPJVzkSef9GXVwi5ZdhIODYdetsQaETrv0tzNfEl7eyTBjuMhdZv1to4qhcUiPI0yfGBEjZXIcowfGF2hF0CyxWRdElozlCVmcWwPsGklNisrGSyKSAxvou6bQLih4rKzHI13L2kbNW0Y29x+sYZ5/UvttAb8KyWon5P+iebooM6mhmnUSwS+72N0hqZb2oTV9ThEVd7MepUp
 eZVnt/6j
 UcbUyAb1HwtDDiHLpCXdECdbu99t3mEPFFZyaDOinmSXfuO5ND96GA9N19SrbtXKkTnqGZwRV2Yv1TnXY58Cvy8aN27AumBMRFQqAIremM3/qqT7Mso77jSvgzS48Xi6gYKGGtrG2bnM5LiuRZANTXh80An+fUrCRACWsQTEgnrFh1VaMQnSlxKAePQwLWldPYuE/WxFhYAhUmwzubnzG7FK/TDp1KNP2oXYC3GRBhcW2hWqrgA/PwMxdxfmJwLwB93DrikdvfgLQLVLtMPM0Q6FM3T6migQTrRsjbYEbEM71PuuyvwVBCfxfYS1SwqtynLMv9b/UUBEbN4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 07:26:37PM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/19/26 19:23, Lorenzo Stoakes (Oracle) wrote:
> > Previously, when a driver needed to do something like establish a
> > reference count, it could do so in the mmap hook in the knowledge that the
> > mapping would succeed.
> >
> > With the introduction of f_op->mmap_prepare this is no longer the case, as
> > it is invoked prior to actually establishing the mapping.
> >
> > mmap_prepare is not appropriate for this kind of thing as it is called
> > before any merge might take place, and after which an error might occur
> > meaning resources could be leaked.
> >
> > To take this into account, introduce a new vm_ops->mapped callback which
> > is invoked when the VMA is first mapped (though notably - not when it is
> > merged - which is correct and mirrors existing mmap/open/close behaviour).
> >
> > We do better that vm_ops->open() here, as this callback can return an
> > error, at which point the VMA will be unmapped.
> >
> > Note that vm_ops->mapped() is invoked after any mmap action is complete
> > (such as I/O remapping).
> >
> > We intentionally do not expose the VMA at this point, exposing only the
> > fields that could be used, and an output parameter in case the operation
> > needs to update the vma->vm_private_data field.
> >
> > In order to deal with stacked filesystems which invoke inner filesystem's
> > mmap() invocations, add __compat_vma_mapped() and invoke it on vfs_mmap()
> > (via compat_vma_mmap()) to ensure that the mapped callback is handled when
> > an mmap() caller invokes a nested filesystem's mmap_prepare() callback.
> >
> > We can now also remove call_action_complete() and invoke
> > mmap_action_complete() directly, as we separate out the rmap lock logic.
> >
> > The rmap lock logic, which was added in order to keep hugetlb working (!)
> > to allow for the rmap lock to be held longer, needs to be propagated to the
> > error paths on mmap complete and mapped hook error paths.
> >
> > This is because do_munmap() might otherwise deadlock with the rmap being
> > held, so instead we unlock at the point of unmap.
>
> Hmm but that was also true prior to this series? So is this a bugfix? Should
> it be a stable hotfix done outside of the series before the refactoring?

Yup, will send a hotfix.

Thanks, Lorenzo

