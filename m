Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0717606A333
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KKO0GtmL
Received: by kanga.kvack.org (Postfix)
	id 862EE6B05B1; Mon, 16 Nov 2026 05:51:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8140A6B05B3; Mon, 16 Nov 2026 05:51:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7035E6B05BC; Mon, 16 Nov 2026 05:51:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36BF56B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:51:51 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 862F88091D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:51:50 +0000 (UTC)
X-FDA: 85440666780.03.5F17B59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E9B6FC0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:51:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KKO0GtmL;
	spf=pass (imf28.hostedemail.com: domain of lpieralisi@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=lpieralisi@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794826309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rny6q4V2AlEW+9be9hzTdzBqG+gm95vTnvqQb/sLFhY=;
	b=pntkuqwq+FW7nd/jhI8yZhzZFsDFVeB/O2IDFPXdOISdLi1ZWVTUgpADcJ++bXoI9eaj6e
	J3VxY06yxJOLXY7B6tey8AVwSoI3uktXzWOw6R73lAZULBLHdOmtl9/hKpDv7ccCxHw9lx
	Z9UrXJrSwRQyVPhrbvXc5fz5x+Y6rtI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794826309;
	b=m4uAi3vPIxnHqPREv3H56CLMAk06oQ+9EJbkYtpYpzEVOHEgUBfb3hsjHoUpMEwWBABtjw
	NC2HA27pe8sjQ/yo09eahjdFpbrXW9zf9ndt6jWGNQdlko1CmhgIAOrAbkF3C/GdBTJbim
	HVyyZLR6pgG3S7Qb/EZXs7WPfBfT6kA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KKO0GtmL;
	spf=pass (imf28.hostedemail.com: domain of lpieralisi@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=lpieralisi@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22640411BC;
	Mon, 16 Nov 2026 10:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA0D1F000C5;
	Mon, 16 Nov 2026 10:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794826308;
	bh=rny6q4V2AlEW+9be9hzTdzBqG+gm95vTnvqQb/sLFhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KKO0GtmLmo3FANikUbE0i8Y6q8f05SERDvSmxDTTrvZcguvwuOPJiERRLiY3km+p9
	 zo6CwRf5CpRVfMsRxBO5VC7BJ8aswdfaLrTnWNGso8MYwfkMSlZlr/JCwl7Yb0DKYI
	 eBWEl8S+pydXFjwbZYHaKbLWD1FXtNqR/hU+W0ogRIXX/8Ttqui5864q8rXI5QbV1c
	 R6fnfNJlYbpdNAOv54aoayBIVtR/wby4m5kxP9JLbu1/7ECYHfn8X6ZW0o2rJV/Mfu
	 EVIiWUPpZlAFacz9vc7Vc16Rny5Ozfd3TgFqBoUQmnJ8ExsrAtD4LpzCw5QASx/URm
	 B8JnGpBuX+mvA==
Date: Mon, 16 Nov 2026 11:51:32 +0100
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
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
Message-ID: <avrgNBXDFMGL6dqO@red-moon>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-15-aneesh.kumar@kernel.org>
 <86zevn1c9a.wl-maz@kernel.org>
 <yq5ah5huoteu.fsf@kernel.org>
 <87ld6x8zb7.wl-maz@kernel.org>
 <yq5apkw5xpnz.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5apkw5xpnz.fsf@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: qqi8iit3edz8gonnpce1no345o8of7aq
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E9B6FC0006
X-Rspam-User: 
X-HE-Tag: 1794826308-850990
X-HE-Meta: U2FsdGVkX1/0X0ke7QhlCAl2Yt6GGmBUgdTmbvSzxJGANZm67eRBgEQF5N38GtmjbovKxOnaph3rt/j7PqaBHD1PFS11o6lnUPrvX5SfWMYRoqwbzAOTHusOWJmJms6vCBGmPWGZbbB7F8AKO23UN2uDKcydELlx49ipm2xjGxLlQrwKNzA4i4iVMHNXcwH2wDX/duXEf680ce63ZpxrMu8wV5dRe7AyU8rr9B8GL6x6BHfLTsPy7kFkG2bs1Zj+EqhDS4JREkbrifObRPsjmZhZlQ5fY0Kzi2PW58qVNYK7iDNm6jHC2leScSVUL8R9z/xZV1jjraxo+MxtTBbmK+wyiN6gDHhzbf8RDmpazCBgvhPOZrhjBdV3WPvTQgwRdgKmBzpkYBncIxYbtjWLrM+F58c3a3TpdkYSUx3Kc/CXl5NaWdDneo92sMGlQpo173TfUVkCbaeqnDvWlAbikziPYNLE6UyFIgbZJ4aA+VaALSidV6bR2v8buDq9nH+4QpqUaxoyq7eys1uqd0XJUeY9xWHEzNwSgEhYsCPmmPM0WXcQ3E/c/qISnKPpAqTU2tfy/QRf+iu94sjThFSJOYTMZb/u9E++mcvZvyM+cY76dNJzy/w8jtJdKSLvcebnHrgWaPHOePPqLAPIMX21QBKqRdg1rLo6HKb5A3ASIL8Kntpb3h52dWx+DX3dKxdgy3ac2XmX/LnkqyoPhjghmIt0CgOc6bIxTVa1rEmN9pYf+Nlk8EnIAWVKgZsavT8kt7tJio2N7SB4Q+1XYQWBscxgiiwouLoX350YHG/cJQS5rb/s21Yl9ahWZWVLdVo1jowlg02I9RJVKGuaR7uhRvUXlkwtJTAJMbWKP4hUZtbBG9AHQ4iXmDMpG5wr+AVBYBg1NaZMQ5i54TBWmlYsv+RtApQCJ0hPT2D+Z8cossufiOgR1Dw88qBBDVE8U00kXD/6ZsyUZ5Ov18IH2w+
 H6hmN+VS
 XooPxlBphM9VGB67DV6PMgdQUbOqOEqQ1t/Sz4MewdsUjOZMpLXxAt2vt0Uv3VvPDDcp59ghR5pRVAS0X6dVi9Z8DDbBT4g7LRP5PKarQuQfsjIAKMMmxrs+CGiS/VQ4uhmfcAMf6VEci72DsJihq936h/FrHTcA2JgRJjADlHLDP8Twdsc4vURr9xg9YVFesWjezg9IMUcfO3wbftZCL8SnKy3D0waJOS6c18e4JlKIfhQU+vuZ5f1oZjeuJ/MTScvy00XDy9L/NwektMjwYfJdCz3IH4krZ482IukSdL85qw4wEn1MyHUGzqC1JB9moPFbVaXAQRz/+ClPpaHLhyNSmIR9JSSbs48xW002iPm/0TpbWmXcpHAO0wM/5GrPh2YPH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 11:51:04AM +0530, Aneesh Kumar K.V wrote:
> Marc Zyngier <maz@kernel.org> writes:
> 
> > On Fri, 06 Nov 2026 15:45:29 +0000,
> > Aneesh Kumar K.V <aneesh.kumar@kernel.org> wrote:
> >> 
> >> Marc Zyngier <maz@kernel.org> writes:
> >> 
> >> > On Wed, 04 Nov 2026 16:45:55 +0000,
> >> > "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
> >> >> 
> >> >> VPE L1 tables are allocated from the CPU-starting callback, where sleeping is
> >> >> not allowed.  Remove the page allocation from this atomic path.
> >> >> 
> >> >> Use a blocking allocation for the boot CPU and record the resulting table
> >> >> order.  Allocate a page of that order from the sleepable CPU hotplug prepare
> >> >> stage for each secondary CPU.  Consume the preallocated page only when the CPU
> >> >> cannot inherit an existing redistributor or ITS table.
> >> >> 
> >> >> Reclaim unused preallocations after the CPU reaches the online state, and from
> >> >> the prepare-state teardown when CPU bring-up aborts.
> >> >
> >> > No. The way to do it is to move the ITS probing out of the
> >> > non-sleepable CPU hotplug path.
> >> >
> >> > I proposed a potential hack at [1] (which I find far more palatable
> >> > than this proposal), but the real fix is to probe the ITSs as
> >> > devices.
> >> >
> >> 
> >> Could you share a bit more detail on what you have in mind?
> >> 
> >> Are you suggesting that we create a platform device for each ITS and
> >> initialize it through the driver's probe callback, while the rest of the
> >> GIC initialization stays in the existing early boot path?
> >> 
> >> Would that mean the main GIC is operational during early boot, while
> >> ITS-dependent features, such as MSI delivery and direct injection, become
> >> available after the ITS devices probe?
> >> 
> >> Is that the split you have in mind?
> >
> > Yes. Then once this is done, all the tables become normal DMA
> > allocations, for which there should already be adequate support.
> >
> 
> Thanks for confirming. Can we handle the ITS platform-device conversion
> and the switch to DMA allocations in a separate series?
> 
> The existing VPE L1 allocation path calls set_memory_decrypted() from
> the non-sleepable CPU-starting callback, even though
> set_memory_decrypted() can sleep. This issue predates the shared-granule
> allocator changes.

If I may ask, why does the existing code ends up calling set_memory_decrypt(),
or reworded, why does the VPE L1 allocation path goes through the ITS specific
allocation function rather than using alloc_pages() (as it was before
b08e2f42e86b5) ?

Why did b08e2f42e86b5 patched allocate_vpe_l1_table() allocation and moved
it to using its_alloc_pages() ?

Thanks,
Lorenzo

> 
> Since fixing this properly needs a broader ITS rework, can we handle
> that separately and drop the preallocation patch from this series?
> 
> -aneesh

