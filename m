Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B57F2606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mIAvKWrp
Received: by kanga.kvack.org (Postfix)
	id A776F6B05B0; Mon, 16 Nov 2026 11:39:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28726B05B3; Mon, 16 Nov 2026 11:39:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917FC6B05B4; Mon, 16 Nov 2026 11:39:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 685C36B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:39:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 053D016017E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:39:08 +0000 (UTC)
X-FDA: 85441542018.24.915EDB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4454F40007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:39:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mIAvKWrp;
	spf=pass (imf07.hostedemail.com: domain of lpieralisi@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=lpieralisi@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794847147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMR9qDrcuTjHQIrjpgVj0zhPv473ZEqMMWfCbIqm3Q0=;
	b=QZn8QQTwvI5Ool9DHEULt/oVZoCsDukeynHphJPjrcR3HnmcsaByQvA13CoS0Noh62NRi4
	CmH63bWYgK9OVMivkSKcZtuYLHJBb0B/22LxLEqiVfkOPiXImU9Ji7AOrn5LLTt9gmNvwA
	kQtCZ7yg7mVuhhRnGi9X4c7XQnepDX8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mIAvKWrp;
	spf=pass (imf07.hostedemail.com: domain of lpieralisi@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=lpieralisi@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794847147;
	b=IuGXlDaHToLjqQWAMgP/WuskftlB33UTdn3MPMdjVjvPVDlj+PTwnuvXvMDlvBO4iRWcv6
	uyXk7p1ZIDCVgryvFJbIqUcu9IpejbW9lJ/CCCQKxHR0Mav18SaeUvLuIL6gRk9B0LUb7M
	SQhnqjUD0rFwraClLFRsnlfdQ8OHcLo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82966601D4;
	Mon, 16 Nov 2026 16:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD0A1F000C4;
	Mon, 16 Nov 2026 16:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794847146;
	bh=lMR9qDrcuTjHQIrjpgVj0zhPv473ZEqMMWfCbIqm3Q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mIAvKWrpblygY2gORXGuS+vgNMSQVSMyYMGIWMZc/H6+A5K1SRoMSSKhPXBmNJgcL
	 mHah2e2gLJCrS2rxFDDsqYQDQN2FxJ5htDLRKrxn2bLKgTVEqpump37b2SIHvTGsNQ
	 Ku5hQP3825SFJhmREJktFIa1+uNR3LVV36d53y4Pua2UL+tsbROoDeiW2EWcsiQjF8
	 tMV5yx4cwz+87l8OdaVp1F+SRVxQXher8R55izBUPgHi/4VmsjOC/E29z/2iAVxVRe
	 y35CyYf1mPlNrWcbpNKBstQFgnObG4iv555rXzHuoT41V85m42mMchmbA63X97Xt6w
	 Q/i7Lj/aLTTvg==
Date: Mon, 16 Nov 2026 17:38:50 +0100
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Steven Price <steven.price@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>, linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v9 14/14] irqchip/gic-v3-its: Preallocate VPE L1 tables
Message-ID: <avsxmk815rlqNstc@red-moon>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-15-aneesh.kumar@kernel.org>
 <86zevn1c9a.wl-maz@kernel.org>
 <yq5ah5huoteu.fsf@kernel.org>
 <87ld6x8zb7.wl-maz@kernel.org>
 <yq5apkw5xpnz.fsf@kernel.org>
 <avrgNBXDFMGL6dqO@red-moon>
 <f2e47b68-1aee-4d17-8b63-e67075e7a42e@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2e47b68-1aee-4d17-8b63-e67075e7a42e@arm.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4454F40007
X-Rspam-User: 
X-Stat-Signature: 3ixtfy756831ogt3ytbwxdjr84xfxjkx
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794847147-191075
X-HE-Meta: U2FsdGVkX18xkm4YeHV5FUipriwXNB8KIrijrHWqoueCT5OxTx5e/m1C4gldbtiyWXTD8/U9hYSREwMhu+eqVBst17Z7ve6D8jJx7qlFOx48cJNPX/goDr6Nm/G7tjVYeKzssf63A3DiCeg3oXuaPUFOjkOfMQS00LrG/pz1bwKMQh3qWlzx+3Onlrlh2linydxBS8A1GuNKy9dw+0YQcCAib5IPUIPw/KDRqTmFyufE9SP/mlbPIjZcoau286FlBWBi2aeHvUceVysXUhQaCxU3Uqv+JDnZNC9Ypsy5vXdJsNpB4xqxTjp+W7kswW2Tsd3kZxT0gsPOc5kbRRssrntQYdtQivP3IzTYUFD+XdVfDqGZKxkFgCEZRZXT4fL9o3oKiVmBQRwfLitbmsPwbr34qHjI61VJ57+Z3ap4zzr9WGsawSZ2aCuMYwioymRE+q0jK6YT9sZjLUkzyI7gtGByOomcmC+F+LbH/II0HlOkWun6QlwOnQQpQoFa+ZCIOUOAuo4KtefeKEDD1HDK+9DenNwwh3DPiXlmC3Jw7hOVHzxG28maXWs5hdRLNRuwP3YBHt3sEN5AE0dIWR9QuEMWuXYd99EjpmyFJS76enbFzFhiMUCQzd9M989sY3/+rvzoDSnc7M2Wh8m4mG4BVUEeW9b4iQ3NgHSs5OQ3Tuar8U72UFYNXErJsvzC7NzsOSmYtFowhciO4knawQLrweFDO+W4td5l+13dcV8p6cef26cJX4yipmsPw9z+a5heBs8AAuuKydp3DSQWR3VtCV2Y4cFtfvT6cxvvqxEK8FM76Rco0ikE96QbYO5ksWGFcEtj4ljysujHRYa7BCXqLoF1KYQ8TUqd0U8G3Zdu3xeDKIRQex6+NBGI0MGwmjU9CRLhvhIuc+bnOPYHm7eUSaeqdOWcg9ye7ZNDM7JUZbVqh4TEwRE47xzpM1x4+9YMRFdTa1C8ryo5uC8yEAv
 oc80kTDC
 M0QTjoCIVSBSHxR3u7deVokURKO6UYHGQwvU4LVT1X4HTw/CC9+O0k+rr1Lgl2aGc8eB4cNjv5bALZdkHblupyCYItONCjAfNPazYiJoI+tqLHFCiuAih3iDAbkiBvadHqCQkdZU6NPsEWPIB2pC/yYS1BK+P++lBNXI4w+5kP0x3gFWd45WdR6AzBhYXoVU4rL5Hx9E6PlmD80DtqJq+aMy1QBejbGtHNUSm3i132K/oiCcwH/tyFQDB8fjK+VoZa4W0uAymIAKC9FhHceo+M/z9pQg/2w3KJGoIhCXyuibbYl9QIgu8rMtklhOSQtO6WQfV3frq2C3Io2Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 03:32:25PM +0000, Steven Price wrote:

[...]

> >> Thanks for confirming. Can we handle the ITS platform-device conversion
> >> and the switch to DMA allocations in a separate series?
> >>
> >> The existing VPE L1 allocation path calls set_memory_decrypted() from
> >> the non-sleepable CPU-starting callback, even though
> >> set_memory_decrypted() can sleep. This issue predates the shared-granule
> >> allocator changes.
> > 
> > If I may ask, why does the existing code ends up calling set_memory_decrypt(),
> > or reworded, why does the VPE L1 allocation path goes through the ITS specific
> > allocation function rather than using alloc_pages() (as it was before
> > b08e2f42e86b5) ?
> 
> Because it needs to be accessible to the GIC "hardware". In this case
> the GIC is emulated by the hypervisor and the hypervisor for a realm can
> only see the unprotected memory.
> 
> Now I agree this is a little academic in practise because Linux (as a
> hypervisor) will not expose RVPEID - so allocate_vpe_l1_table() will
> early out. IIUC this would only actually be relevant in the case of
> nested virtualisation within a realm guest - which is a long way off if
> it ever happens.

That's what I was actually getting at.

> > Why did b08e2f42e86b5 patched allocate_vpe_l1_table() allocation and moved
> > it to using its_alloc_pages() ?
> 
> In that commit I simply changed all the allocation paths which were
> allocating memory to be visible to the GIC to use the new allocator. As
> we "know" that the GIC can only access "decrypted" memory. Admittedly
> that could easily change in the future - but my expectation is that it
> will only change with the switch to GICv5.

Yes. I just wanted to understand whether, for VPE tables, this is,
currently, a requirement.

> Of course what I missed was that this specific allocation uses
> GFP_ATOMIC and that set_memory_decrypted() can sleep. This wouldn't have
> shown up on any testing because of the early exit:
> 
>         if (!gic_rdists->has_rvpeid)
>                 return 0;

Understood, see above.

Thanks,
Lorenzo

